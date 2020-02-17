Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EF87160D80
	for <lists+io-uring@lfdr.de>; Mon, 17 Feb 2020 09:36:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728299AbgBQIgM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 17 Feb 2020 03:36:12 -0500
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:55938 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728296AbgBQIgL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 17 Feb 2020 03:36:11 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R821e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01f04455;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---0Tq9Vzyr_1581928559;
Received: from 30.15.220.15(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0Tq9Vzyr_1581928559)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 17 Feb 2020 16:35:59 +0800
Subject: Re: [PATCH] io_uring: fix poll_list race for
 SETUP_IOPOLL|SETUP_SQPOLL
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <20200214131125.3391-1-xiaoguang.wang@linux.alibaba.com>
 <880c7bef-ac1d-30bf-6ab7-9866d0614afa@kernel.dk>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Message-ID: <6a8e4bcd-a817-8dea-c265-4d4a2108c6b2@linux.alibaba.com>
Date:   Mon, 17 Feb 2020 16:35:59 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <880c7bef-ac1d-30bf-6ab7-9866d0614afa@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

hi,

> On 2/14/20 6:11 AM, Xiaoguang Wang wrote:
>> After making ext4 support iopoll method:
>>    let ext4_file_operations's iopoll method be iomap_dio_iopoll(),
>> we found fio can easily hang in fio_ioring_getevents() with below fio
>> job:
>>      rm -f testfile; sync;
>>      sudo fio -name=fiotest -filename=testfile -iodepth=128 -thread
>> -rw=write -ioengine=io_uring  -hipri=1 -sqthread_poll=1 -direct=1
>> -bs=4k -size=10G -numjobs=8 -runtime=2000 -group_reporting
>> with IORING_SETUP_SQPOLL and IORING_SETUP_IOPOLL enabled.
>>
>> There are two issues that results in this hang, one reason is that
>> when IORING_SETUP_SQPOLL and IORING_SETUP_IOPOLL are enabled, fio
>> does not use io_uring_enter to get completed events, it relies on
>> kernel io_sq_thread to poll for completed events.
>>
>> Another reason is that there is a race: when io_submit_sqes() in
>> io_sq_thread() submits a batch of sqes, variable 'inflight' will
>> record the number of submitted reqs, then io_sq_thread will poll for
>> reqs which have been added to poll_list. But note, if some previous
>> reqs have been punted to io worker, these reqs will won't be in
>> poll_list timely. io_sq_thread() will only poll for a part of previous
>> submitted reqs, and then find poll_list is empty, reset variable
>> 'inflight' to be zero. If app just waits these deferred reqs and does
>> not wake up io_sq_thread again, then hang happens.
>>
>> For app that entirely relies on io_sq_thread to poll completed requests,
>> let io_iopoll_req_issued() wake up io_sq_thread properly when adding new
>> element to poll_list.
> 
> I think your analysis is correct, but the various conditional locking
> and unlocking in io_sq_thread() is not easy to follow. When I see
> things like:
> 
> @@ -5101,16 +5095,22 @@ static int io_sq_thread(void *data)
>   			if (!to_submit || ret == -EBUSY) {
>   				if (kthread_should_park()) {
>   					finish_wait(&ctx->sqo_wait, &wait);
> +					if (iopoll)
> +						mutex_unlock(&ctx->uring_lock);
>   					break;
>   				}
>   				if (signal_pending(current))
>   					flush_signals(current);
> +				if (iopoll)
> +					mutex_unlock(&ctx->uring_lock);
>   				schedule();
>   				finish_wait(&ctx->sqo_wait, &wait);
>   
>   				ctx->rings->sq_flags &= ~IORING_SQ_NEED_WAKEUP;
>   				continue;
>   			}
> +			if (iopoll)
> +				mutex_unlock(&ctx->uring_lock);
>   			finish_wait(&ctx->sqo_wait, &wait);
>   
>   			ctx->rings->sq_flags &= ~IORING_SQ_NEED_WAKEUP;
> 
> it triggers the taste senses a bit. Any chance you could take another
> look at that part and see if we can clean it up a bit?
Ok, I'll try to make a better version, thanks.

Regards,
Xiaoguang Wang

> 
> Even if that isn't possible, then I think it'd help to rename 'iopoll'
> to something related to the lock, and have a comment when you first do:
> 
> 	/* If we're doing polled IO, we need to bla bla */
> 	if (ctx->flags & IORING_SETUP_IOPOLL)
> 		needs_uring_lock = true;
> 
> 
