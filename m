Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 766A336A657
	for <lists+io-uring@lfdr.de>; Sun, 25 Apr 2021 11:52:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229559AbhDYJw7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 25 Apr 2021 05:52:59 -0400
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:52888 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229551AbhDYJw7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 25 Apr 2021 05:52:59 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R531e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UWgPIQM_1619344337;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UWgPIQM_1619344337)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sun, 25 Apr 2021 17:52:18 +0800
Subject: Re: [PATCH] io_uring: update sq_thread_idle after ctx deleted
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1619256380-236460-1-git-send-email-haoxu@linux.alibaba.com>
 <3d5b166a-b093-9bd5-7553-cadff7b2a41b@gmail.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <003de007-b289-96f8-ba0c-ff71e8c550a7@linux.alibaba.com>
Date:   Sun, 25 Apr 2021 17:52:17 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <3d5b166a-b093-9bd5-7553-cadff7b2a41b@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/4/25 上午8:03, Pavel Begunkov 写道:
> On 4/24/21 10:26 AM, Hao Xu wrote:
>> we shall update sq_thread_idle anytime we do ctx deletion from ctx_list
> 
> looks good, a nit below
> 
>>
>> Fixes:734551df6f9b ("io_uring: fix shared sqpoll cancellation hangs")
>> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
>> ---
>>   fs/io_uring.c | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 40f38256499c..15f204274761 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -8867,6 +8867,7 @@ static void io_sqpoll_cancel_cb(struct callback_head *cb)
>>   	if (sqd->thread)
>>   		io_uring_cancel_sqpoll(sqd);
>>   	list_del_init(&work->ctx->sqd_list);
>> +	io_sqd_update_thread_idle(sqd);
>>   	complete(&work->completion);
>>   }
>>   
>> @@ -8877,7 +8878,6 @@ static void io_sqpoll_cancel_sync(struct io_ring_ctx *ctx)
>>   	struct task_struct *task;
>>   
>>   	io_sq_thread_park(sqd);
>> -	io_sqd_update_thread_idle(sqd);
>>   	task = sqd->thread;
>>   	if (task) {
>>   		init_completion(&work.completion);
>> @@ -8886,6 +8886,7 @@ static void io_sqpoll_cancel_sync(struct io_ring_ctx *ctx)
>>   		wake_up_process(task);
>>   	} else {
>>   		list_del_init(&ctx->sqd_list);
>> +		io_sqd_update_thread_idle(sqd);
> 
> Not actually needed, it's already dying.
> 
Yep, we could keep it since it's not in hot path.
>>   	}
>>   	io_sq_thread_unpark(sqd);
>>   
>>
> 

