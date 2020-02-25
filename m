Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D4B916B772
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2020 03:00:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728489AbgBYCAT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Feb 2020 21:00:19 -0500
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:52646 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726962AbgBYCAT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Feb 2020 21:00:19 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01f04446;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0Tqr7L2F_1582596012;
Received: from 30.15.229.215(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0Tqr7L2F_1582596012)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 25 Feb 2020 10:00:13 +0800
Subject: Re: [PATCH v3] io_uring: fix poll_list race for
 SETUP_IOPOLL|SETUP_SQPOLL
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, joseph.qi@linux.alibaba.com
References: <20200224070354.3774-1-xiaoguang.wang@linux.alibaba.com>
 <6ee28cc6-3c4c-a5cb-75d4-83bccf93fb2a@kernel.dk>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Message-ID: <ca4803dc-af0c-5d6e-834a-343e3100f6f3@linux.alibaba.com>
Date:   Tue, 25 Feb 2020 10:00:13 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <6ee28cc6-3c4c-a5cb-75d4-83bccf93fb2a@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

hi,

> On 2/24/20 12:03 AM, Xiaoguang Wang wrote:
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
> I'm still not a huge fan of this solution. A few comments below:
> 
>> +			if (!list_empty(&ctx->poll_list))
>> +				io_iopoll_getevents(ctx, &nr_events, 0);
>> +			if (list_empty(&ctx->poll_list))
>>   				timeout = jiffies + ctx->sq_thread_idle;
> 
> Just use an else?
> 
>> +			/*
>> +			 * While doing polled IO, before going to sleep, we need
>> +			 * to check if there are new reqs added to poll_list, it
>> +			 * is because reqs may have been punted to io worker and
>> +			 * will be added to poll_list later, hence check the
>> +			 * poll_list again, meanwhile we need to hold uring_lock
>> +			 * to do this check, otherwise we may lose wakeup event
>> +			 * in io_iopoll_req_issued().
>> +			 */
>> +			if (needs_uring_lock) {
>> +				mutex_lock(&ctx->uring_lock);
>> +				if (!list_empty(&ctx->poll_list)) {
>> +					mutex_unlock(&ctx->uring_lock);
>> +					cond_resched();
>> +					continue;
>> +				}
>> +			}
> 
> Can't we just put this below the prepare_to_wait? I'm not convinced
> this is closing the gaps, there should be no need to hold the uring
> lock over this long stretch.
> 
> Modified version of yours below
> 
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index d961945cb332..ffd9bfa84d86 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -1821,6 +1821,10 @@ static void io_iopoll_req_issued(struct io_kiocb *req)
>   		list_add(&req->list, &ctx->poll_list);
>   	else
>   		list_add_tail(&req->list, &ctx->poll_list);
> +
> +	if ((ctx->flags & IORING_SETUP_SQPOLL) &&
> +	    wq_has_sleeper(&ctx->sqo_wait))
> +		wake_up(&ctx->sqo_wait);
>   }
>   
>   static void io_file_put(struct io_submit_state *state)
> @@ -5086,9 +5090,8 @@ static int io_sq_thread(void *data)
>   	const struct cred *old_cred;
>   	mm_segment_t old_fs;
>   	DEFINE_WAIT(wait);
> -	unsigned inflight;
>   	unsigned long timeout;
> -	int ret;
> +	int ret = 0;
>   
>   	complete(&ctx->completions[1]);
>   
> @@ -5096,39 +5099,19 @@ static int io_sq_thread(void *data)
>   	set_fs(USER_DS);
>   	old_cred = override_creds(ctx->creds);
>   
> -	ret = timeout = inflight = 0;
> +	timeout = jiffies + ctx->sq_thread_idle;
>   	while (!kthread_should_park()) {
>   		unsigned int to_submit;
>   
> -		if (inflight) {
> +		if (!list_empty(&ctx->poll_list)) {
>   			unsigned nr_events = 0;
>   
> -			if (ctx->flags & IORING_SETUP_IOPOLL) {
> -				/*
> -				 * inflight is the count of the maximum possible
> -				 * entries we submitted, but it can be smaller
> -				 * if we dropped some of them. If we don't have
> -				 * poll entries available, then we know that we
> -				 * have nothing left to poll for. Reset the
> -				 * inflight count to zero in that case.
> -				 */
> -				mutex_lock(&ctx->uring_lock);
> -				if (!list_empty(&ctx->poll_list))
> -					io_iopoll_getevents(ctx, &nr_events, 0);
> -				else
> -					inflight = 0;
> -				mutex_unlock(&ctx->uring_lock);
> -			} else {
> -				/*
> -				 * Normal IO, just pretend everything completed.
> -				 * We don't have to poll completions for that.
> -				 */
> -				nr_events = inflight;
> -			}
> -
> -			inflight -= nr_events;
> -			if (!inflight)
> +			mutex_lock(&ctx->uring_lock);
> +			if (!list_empty(&ctx->poll_list))
> +				io_iopoll_getevents(ctx, &nr_events, 0);
> +			else
>   				timeout = jiffies + ctx->sq_thread_idle;
> +			mutex_unlock(&ctx->uring_lock);
>   		}
>   
>   		to_submit = io_sqring_entries(ctx);
> @@ -5157,7 +5140,7 @@ static int io_sq_thread(void *data)
>   			 * more IO, we should wait for the application to
>   			 * reap events and wake us up.
>   			 */
> -			if (inflight ||
> +			if (!list_empty(&ctx->poll_list) ||
>   			    (!time_after(jiffies, timeout) && ret != -EBUSY &&
>   			    !percpu_ref_is_dying(&ctx->refs))) {
>   				cond_resched();
> @@ -5167,6 +5150,19 @@ static int io_sq_thread(void *data)
>   			prepare_to_wait(&ctx->sqo_wait, &wait,
>   						TASK_INTERRUPTIBLE);
>   
> +			/*
> +			 * While doing polled IO, before going to sleep, we need
> +			 * to check if there are new reqs added to poll_list, it
> +			 * is because reqs may have been punted to io worker and
> +			 * will be added to poll_list later, hence check the
> +			 * poll_list again.
> +			 */
> +			if ((ctx->flags & IORING_SETUP_IOPOLL) &&
> +			    !list_empty_careful(&ctx->poll_list)) {
> +				finish_wait(&ctx->sqo_wait, &wait);
> +				continue;
> +			}
> +
>   			/* Tell userspace we may need a wakeup call */
>   			ctx->rings->sq_flags |= IORING_SQ_NEED_WAKEUP;
>   			/* make sure to read SQ tail after writing flags */
> @@ -5194,8 +5190,7 @@ static int io_sq_thread(void *data)
>   		mutex_lock(&ctx->uring_lock);
>   		ret = io_submit_sqes(ctx, to_submit, NULL, -1, &cur_mm, true);
>   		mutex_unlock(&ctx->uring_lock);
> -		if (ret > 0)
> -			inflight += ret;
> +		timeout = jiffies + ctx->sq_thread_idle;
>   	}
>   
>   	set_fs(old_fs);
> 
Thanks for your modified version, it works well and looks much better, after applying
this version, I also don't see this hang issue again.
 From your codes, now I understand why we don't need to hold uring_lock, thanks.
Should I send this v4 version with your codes?

Regards,
Xiaoguang Wang

