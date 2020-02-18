Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62A7F162AD5
	for <lists+io-uring@lfdr.de>; Tue, 18 Feb 2020 17:40:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726671AbgBRQkU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 18 Feb 2020 11:40:20 -0500
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:39481 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726360AbgBRQkT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 Feb 2020 11:40:19 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R771e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01f04446;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0TqJ-1k0_1582043992;
Received: from 30.0.147.63(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0TqJ-1k0_1582043992)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 19 Feb 2020 00:39:53 +0800
Subject: Re: [PATCH v2] io_uring: fix poll_list race for
 SETUP_IOPOLL|SETUP_SQPOLL
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, joseph.qi@linux.alibaba.com
References: <20200218162800.3089-1-xiaoguang.wang@linux.alibaba.com>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Message-ID: <e3605ed7-0d26-6115-6a17-d88573282112@linux.alibaba.com>
Date:   Wed, 19 Feb 2020 00:39:52 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200218162800.3089-1-xiaoguang.wang@linux.alibaba.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

hi��

> After making ext4 support iopoll method:
>    let ext4_file_operations's iopoll method be iomap_dio_iopoll(),
> we found fio can easily hang in fio_ioring_getevents() with below fio
> job:
>      rm -f testfile; sync;
>      sudo fio -name=fiotest -filename=testfile -iodepth=128 -thread
> -rw=write -ioengine=io_uring  -hipri=1 -sqthread_poll=1 -direct=1
> -bs=4k -size=10G -numjobs=8 -runtime=2000 -group_reporting
> with IORING_SETUP_SQPOLL and IORING_SETUP_IOPOLL enabled.
> 
> There are two issues that results in this hang, one reason is that
> when IORING_SETUP_SQPOLL and IORING_SETUP_IOPOLL are enabled, fio
> does not use io_uring_enter to get completed events, it relies on
> kernel io_sq_thread to poll for completed events.
> 
> Another reason is that there is a race: when io_submit_sqes() in
> io_sq_thread() submits a batch of sqes, variable 'inflight' will
> record the number of submitted reqs, then io_sq_thread will poll for
> reqs which have been added to poll_list. But note, if some previous
> reqs have been punted to io worker, these reqs will won't be in
> poll_list timely. io_sq_thread() will only poll for a part of previous
> submitted reqs, and then find poll_list is empty, reset variable
> 'inflight' to be zero. If app just waits these deferred reqs and does
> not wake up io_sq_thread again, then hang happens.
> 
> For app that entirely relies on io_sq_thread to poll completed requests,
> let io_iopoll_req_issued() wake up io_sq_thread properly when adding new
> element to poll_list.
> 
> Fixes: 2b2ed9750fc9 ("io_uring: fix bad inflight accounting for SETUP_IOPOLL|SETUP_SQTHREAD")
> Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
> 
> ---
> V2:
>      simple code cleanups and add necessary comments.
Sorry, I still don't figure out a better way to clean up the codes yet.
Or we add a new kernel thread to do poll job, codes may seem simpler :)

+static int io_poll_thread(void *data)
+{
+       struct io_ring_ctx *ctx = data;
+       const struct cred *old_cred;
+       DEFINE_WAIT(wait);
+
+       old_cred = override_creds(ctx->creds);
+       while (!kthread_should_park()) {
+               unsigned nr_events = 0;
+               bool has_inflight = true;
+
+               mutex_lock(&ctx->uring_lock);
+               if (!list_empty(&ctx->poll_list))
+                       __io_iopoll_check(ctx, &nr_events, 0);
+               else
+                       has_inflight = false;
+               mutex_unlock(&ctx->uring_lock);
+
+               if (!has_inflight) {
+                       mutex_lock(&ctx->uring_lock);
+                       prepare_to_wait(&ctx->cqo_wait, &wait,
+                                       TASK_INTERRUPTIBLE);
+                       if (!list_empty(&ctx->poll_list)) {
+                               finish_wait(&ctx->cqo_wait, &wait);
+                               mutex_unlock(&ctx->uring_lock);
+                               cond_resched();
+                               continue;
+                       }
+                       mutex_unlock(&ctx->uring_lock);
+                       schedule();
+                       finish_wait(&ctx->cqo_wait, &wait);
+               }
+               cond_resched();
+       }
+       revert_creds(old_cred);
+       kthread_parkme();
+       return 0;
+}

Regards,
Xiaoguang Wang

> ---
>   fs/io_uring.c | 72 ++++++++++++++++++++++++++++-----------------------
>   1 file changed, 40 insertions(+), 32 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 77f22c3da30f..b6d7c45d0d0d 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -1793,6 +1793,9 @@ static void io_iopoll_req_issued(struct io_kiocb *req)
>   		list_add(&req->list, &ctx->poll_list);
>   	else
>   		list_add_tail(&req->list, &ctx->poll_list);
> +
> +	if (ctx->flags & IORING_SETUP_SQPOLL && wq_has_sleeper(&ctx->sqo_wait))
> +		wake_up(&ctx->sqo_wait);
>   }
>   
>   static void io_file_put(struct io_submit_state *state)
> @@ -5011,9 +5014,9 @@ static int io_sq_thread(void *data)
>   	const struct cred *old_cred;
>   	mm_segment_t old_fs;
>   	DEFINE_WAIT(wait);
> -	unsigned inflight;
>   	unsigned long timeout;
> -	int ret;
> +	int ret = 0;
> +	bool needs_uring_lock = false;
>   
>   	complete(&ctx->completions[1]);
>   
> @@ -5021,39 +5024,21 @@ static int io_sq_thread(void *data)
>   	set_fs(USER_DS);
>   	old_cred = override_creds(ctx->creds);
>   
> -	ret = timeout = inflight = 0;
> +	if (ctx->flags & IORING_SETUP_IOPOLL)
> +		needs_uring_lock = true;
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
> -					__io_iopoll_check(ctx, &nr_events, 0);
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
> +				__io_iopoll_check(ctx, &nr_events, 0);
> +			if (list_empty(&ctx->poll_list))
>   				timeout = jiffies + ctx->sq_thread_idle;
> +			mutex_unlock(&ctx->uring_lock);
>   		}
>   
>   		to_submit = io_sqring_entries(ctx);
> @@ -5070,7 +5055,7 @@ static int io_sq_thread(void *data)
>   			 * more IO, we should wait for the application to
>   			 * reap events and wake us up.
>   			 */
> -			if (inflight ||
> +			if (!list_empty(&ctx->poll_list) ||
>   			    (!time_after(jiffies, timeout) && ret != -EBUSY &&
>   			    !percpu_ref_is_dying(&ctx->refs))) {
>   				cond_resched();
> @@ -5089,6 +5074,24 @@ static int io_sq_thread(void *data)
>   				cur_mm = NULL;
>   			}
>   
> +			/*
> +			 * While doing polled IO, before going to sleep, we need
> +			 * to check if there are new reqs added to poll_list, it
> +			 * is because reqs may have been punted to io worker and
> +			 * will be added to poll_list later, hence check the
> +			 * poll_list again, meanwhile we need to hold uring_lock
> +			 * to do this check, otherwise we may lose wakeup event
> +			 * in io_iopoll_req_issued().
> +			 */
> +			if (needs_uring_lock) {
> +				mutex_lock(&ctx->uring_lock);
> +				if (!list_empty(&ctx->poll_list)) {
> +					mutex_unlock(&ctx->uring_lock);
> +					cond_resched();
> +					continue;
> +				}
> +			}
> +
>   			prepare_to_wait(&ctx->sqo_wait, &wait,
>   						TASK_INTERRUPTIBLE);
>   
> @@ -5101,16 +5104,22 @@ static int io_sq_thread(void *data)
>   			if (!to_submit || ret == -EBUSY) {
>   				if (kthread_should_park()) {
>   					finish_wait(&ctx->sqo_wait, &wait);
> +					if (needs_uring_lock)
> +						mutex_unlock(&ctx->uring_lock);
>   					break;
>   				}
>   				if (signal_pending(current))
>   					flush_signals(current);
> +				if (needs_uring_lock)
> +					mutex_unlock(&ctx->uring_lock);
>   				schedule();
>   				finish_wait(&ctx->sqo_wait, &wait);
>   
>   				ctx->rings->sq_flags &= ~IORING_SQ_NEED_WAKEUP;
>   				continue;
>   			}
> +			if (needs_uring_lock)
> +				mutex_unlock(&ctx->uring_lock);
>   			finish_wait(&ctx->sqo_wait, &wait);
>   
>   			ctx->rings->sq_flags &= ~IORING_SQ_NEED_WAKEUP;
> @@ -5119,8 +5128,7 @@ static int io_sq_thread(void *data)
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
