Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 552B736E3F8
	for <lists+io-uring@lfdr.de>; Thu, 29 Apr 2021 06:13:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236988AbhD2ENm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 29 Apr 2021 00:13:42 -0400
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:47769 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233053AbhD2ENl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 29 Apr 2021 00:13:41 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R671e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UX85T.Y_1619669573;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UX85T.Y_1619669573)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 29 Apr 2021 12:12:54 +0800
Subject: Re: [PATCH RFC 5.13 2/2] io_uring: submit sqes in the original
 context when waking up sqthread
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1619616748-17149-1-git-send-email-haoxu@linux.alibaba.com>
 <1619616748-17149-3-git-send-email-haoxu@linux.alibaba.com>
 <8cb5e446-d19a-4a3f-5b96-5487723024f8@kernel.dk>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <821cfef4-769e-b05b-76a4-8bea9d0168ff@linux.alibaba.com>
Date:   Thu, 29 Apr 2021 12:12:53 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <8cb5e446-d19a-4a3f-5b96-5487723024f8@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/4/28 下午10:12, Jens Axboe 写道:
> On 4/28/21 7:32 AM, Hao Xu wrote:
>> sqes are submitted by sqthread when it is leveraged, which means there
>> is IO latency when waking up sqthread. To wipe it out, submit limited
>> number of sqes in the original task context.
>> Tests result below:
>>
>> 99th latency:
>> iops\idle	10us	60us	110us	160us	210us	260us	310us	360us	410us	460us	510us
>> with this patch:
>> 2k      	13	13	12	13	13	12	12	11	11	10.304	11.84
>> without this patch:
>> 2k      	15	14	15	15	15	14	15	14	14	13	11.84
>>
>> fio config:
>> ./run_fio.sh
>> fio \
>> --ioengine=io_uring --sqthread_poll=1 --hipri=1 --thread=1 --bs=4k \
>> --direct=1 --rw=randread --time_based=1 --runtime=300 \
>> --group_reporting=1 --filename=/dev/nvme1n1 --sqthread_poll_cpu=30 \
>> --randrepeat=0 --cpus_allowed=35 --iodepth=128 --rate_iops=${1} \
>> --io_sq_thread_idle=${2}
> 
> Interesting concept! One question:
> 
>> @@ -9304,8 +9311,18 @@ static int io_get_ext_arg(unsigned flags, const void __user *argp, size_t *argsz
>>   		if (unlikely(ctx->sq_data->thread == NULL)) {
>>   			goto out;
>>   		}
>> -		if (flags & IORING_ENTER_SQ_WAKEUP)
>> +		if (flags & IORING_ENTER_SQ_WAKEUP) {
>>   			wake_up(&ctx->sq_data->wait);
>> +			if ((flags & IORING_ENTER_SQ_DEPUTY) &&
>> +					!(ctx->flags & IORING_SETUP_IOPOLL)) {
>> +				ret = io_uring_add_task_file(ctx);
>> +				if (unlikely(ret))
>> +					goto out;
>> +				mutex_lock(&ctx->uring_lock);
>> +				io_submit_sqes(ctx, min(to_submit, 8U));
>> +				mutex_unlock(&ctx->uring_lock);
>> +			}
>> +		}
> 
> Do we want to wake the sqpoll thread _post_ submitting these ios? The
> idea being that if we're submitting now after a while (since the thread
> is sleeping), then we're most likely going to be submitting more than
> just this single batch. And the wakeup would do the same if done after
yes, prediction that it will likely submit more than just that single
batch is the idea behind this patch.
> the submit, it'd just not interfere with this submit. You could imagine
> a scenario where we do the wake and the sqpoll thread beats us to the
> submit, and now we're just stuck waiting for the uring_lock and end up
> doing nothing.
true, I think trylock may be good to address this.
> 
> Maybe you guys already tested this? Also curious if you did, what kind
> of requests are being submitted? That can have quite a bit of effect on
> how quickly the submit is done.
we currently just have put it on fio benchmark and liburing tests, this 
patch definitely needs more thinking.
> 

