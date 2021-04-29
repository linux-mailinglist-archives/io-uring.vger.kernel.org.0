Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C25AA36E738
	for <lists+io-uring@lfdr.de>; Thu, 29 Apr 2021 10:44:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232942AbhD2IpI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 29 Apr 2021 04:45:08 -0400
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:45946 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231701AbhD2IpI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 29 Apr 2021 04:45:08 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R991e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UX9bvyb_1619685860;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UX9bvyb_1619685860)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 29 Apr 2021 16:44:20 +0800
Subject: Re: [PATCH RFC 5.13 2/2] io_uring: submit sqes in the original
 context when waking up sqthread
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1619616748-17149-1-git-send-email-haoxu@linux.alibaba.com>
 <1619616748-17149-3-git-send-email-haoxu@linux.alibaba.com>
 <571b5633-3286-feba-af6b-e388f52fc89b@gmail.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <755e4e92-9ff2-9246-75c0-63fb79ae1646@linux.alibaba.com>
Date:   Thu, 29 Apr 2021 16:44:20 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <571b5633-3286-feba-af6b-e388f52fc89b@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/4/28 下午10:34, Pavel Begunkov 写道:
> On 4/28/21 2:32 PM, Hao Xu wrote:
>> sqes are submitted by sqthread when it is leveraged, which means there
>> is IO latency when waking up sqthread. To wipe it out, submit limited
>> number of sqes in the original task context.
>> Tests result below:
> 
> Frankly, it can be a nest of corner cases if not now then in the future,
> leading to a high maintenance burden. Hence, if we consider the change,
> I'd rather want to limit the userspace exposure, so it can be removed
> if needed.
> 
> A noticeable change of behaviour here, as Hao recently asked, is that
> the ring can be passed to a task from a completely another thread group,
> and so the feature would execute from that context, not from the
> original/sqpoll one.
> 
> Not sure IORING_ENTER_SQ_DEPUTY knob is needed, but at least can be
> ignored if the previous point is addressed.
> 
>>
>> 99th latency:
>> iops\idle	10us	60us	110us	160us	210us	260us	310us	360us	410us	460us	510us
>> with this patch:
>> 2k      	13	13	12	13	13	12	12	11	11	10.304	11.84
>> without this patch:
>> 2k      	15	14	15	15	15	14	15	14	14	13	11.84
> 
> Not sure the second nine describes it well enough, please can you
> add more data? Mean latency, 50%, 90%, 99%, 99.9%, t-put.
> 
> Btw, how happened that only some of the numbers have fractional part?
> Can't believe they all but 3 were close enough to integer values.
> 
>> fio config:
>> ./run_fio.sh
>> fio \
>> --ioengine=io_uring --sqthread_poll=1 --hipri=1 --thread=1 --bs=4k \
>> --direct=1 --rw=randread --time_based=1 --runtime=300 \
>> --group_reporting=1 --filename=/dev/nvme1n1 --sqthread_poll_cpu=30 \
>> --randrepeat=0 --cpus_allowed=35 --iodepth=128 --rate_iops=${1} \
>> --io_sq_thread_idle=${2}
>>
>> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
>> ---
>>   fs/io_uring.c                 | 29 +++++++++++++++++++++++------
>>   include/uapi/linux/io_uring.h |  1 +
>>   2 files changed, 24 insertions(+), 6 deletions(-)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 1871fad48412..f0a01232671e 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -1252,7 +1252,12 @@ static void io_queue_async_work(struct io_kiocb *req)
>>   {
>>   	struct io_ring_ctx *ctx = req->ctx;
>>   	struct io_kiocb *link = io_prep_linked_timeout(req);
>> -	struct io_uring_task *tctx = req->task->io_uring;
>> +	struct io_uring_task *tctx = NULL;
>> +
>> +	if (ctx->sq_data && ctx->sq_data->thread)
>> +		tctx = ctx->sq_data->thread->io_uring;
> 
> without park it's racy, sq_data->thread may become NULL and removed,
> as well as its ->io_uring.
I now think that it's ok to queue async work to req->task->io_uring. I
look through all the OPs, seems only have to take care of async_cancel:

io_async_cancel(req) {
     cancel from req->task->io_uring;
     cancel from ctx->tctx_list
}

Given req->task is 'original context', the req to be cancelled may in
ctx->sq_data->thread->io_uring's iowq. So search the req from
sqthread->io_uring is needed here. This avoids overload in main code
path.
Did I miss something else?


> 
>> +	else
>> +		tctx = req->task->io_uring;
>>   
>>   	BUG_ON(!tctx);
>>   	BUG_ON(!tctx->io_wq);
> 
> [snip]
> 

