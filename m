Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C35ED366F63
	for <lists+io-uring@lfdr.de>; Wed, 21 Apr 2021 17:47:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241197AbhDUPrc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 21 Apr 2021 11:47:32 -0400
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:40689 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240048AbhDUPrc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 21 Apr 2021 11:47:32 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UWK0rq._1619020017;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UWK0rq._1619020017)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 21 Apr 2021 23:46:57 +0800
Subject: Re: [PATCH] io_uring: check sqring and iopoll_list before shedule
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1619018351-75883-1-git-send-email-haoxu@linux.alibaba.com>
Message-ID: <a7c70456-5c1d-b300-3449-00f822dda193@linux.alibaba.com>
Date:   Wed, 21 Apr 2021 23:46:57 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <1619018351-75883-1-git-send-email-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/4/21 下午11:19, Hao Xu 写道:
> do this to avoid race below:
> 
>           userspace                         kernel
> 
>                                 |  check sqring and iopoll_list
> submit sqe                     |
> check IORING_SQ_NEED_WAKEUP    |
> (which is not set)    |        |
>                                 |  set IORING_SQ_NEED_WAKEUP
> wait cqe                       |  schedule(never wakeup again)
> 
> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
> ---
> 
> Hi all,
> I'm doing some work to reduce cpu usage in low IO pression, and I
> removed timeout logic in io_sq_thread() to do some test with fio-3.26,
> I found that fio hangs in getevents, inifinitely trying to get a cqe,
> While sq-thread is sleeping. It seems there is race situation, and it
> is still there even after I fix the issue described above in the commit
> message. I doubt it is something to do with memory barrier logic
> between userspace and kernel, I'm trying to address it, not many clues
> for now.
> I'll send the fio config and kernel modification I did for test in
> following mail soon.
> 
fio test config:
[global]
ioengine=io_uring
sqthread_poll=1
hipri=1
thread=1
bs=4k
direct=1
rw=randread
time_based=1
runtime=30
group_reporting=1
filename=/dev/nvme1n1
sqthread_poll_cpu=30

[job0]
iodepth=1

the issue mainly occur when iodepth=1 during my test.
I removed timeout logic in io_sq_thread() like this:

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 042f1149db51..dd9c95016f7f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6739,7 +6739,6 @@ static int io_sq_thread(void *data)
  {
         struct io_sq_data *sqd = data;
         struct io_ring_ctx *ctx;
-       unsigned long timeout = 0;
         char buf[TASK_COMM_LEN];
         DEFINE_WAIT(wait);

@@ -6777,7 +6776,6 @@ static int io_sq_thread(void *data)
                         io_run_task_work_head(&sqd->park_task_work);
                         if (did_sig)
                                 break;
-                       timeout = jiffies + sqd->sq_thread_idle;
                         continue;
                 }
                 sqt_spin = false;
@@ -6794,11 +6792,9 @@ static int io_sq_thread(void *data)
                                 sqt_spin = true;
                 }

-               if (sqt_spin || !time_after(jiffies, timeout)) {
+               if (sqt_spin) {
                         io_run_task_work();
                         cond_resched();
-                       if (sqt_spin)
-                               timeout = jiffies + sqd->sq_thread_idle;
                         continue;
                 }

@@ -6831,7 +6827,6 @@ static int io_sq_thread(void *data)

                 finish_wait(&sqd->wait, &wait);
                 io_run_task_work_head(&sqd->park_task_work);
-               timeout = jiffies + sqd->sq_thread_idle;
         }

         list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
~
~
> Thanks,
> Hao
> 
>   fs/io_uring.c | 36 +++++++++++++++++++-----------------
>   1 file changed, 19 insertions(+), 17 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index dff34975d86b..042f1149db51 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -6802,27 +6802,29 @@ static int io_sq_thread(void *data)
>   			continue;
>   		}
>   
> -		needs_sched = true;
>   		prepare_to_wait(&sqd->wait, &wait, TASK_INTERRUPTIBLE);
> -		list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
> -			if ((ctx->flags & IORING_SETUP_IOPOLL) &&
> -			    !list_empty_careful(&ctx->iopoll_list)) {
> -				needs_sched = false;
> -				break;
> -			}
> -			if (io_sqring_entries(ctx)) {
> -				needs_sched = false;
> -				break;
> -			}
> -		}
> -
> -		if (needs_sched && !test_bit(IO_SQ_THREAD_SHOULD_PARK, &sqd->state)) {
> +		if (!test_bit(IO_SQ_THREAD_SHOULD_PARK, &sqd->state)) {
>   			list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
>   				io_ring_set_wakeup_flag(ctx);
>   
> -			mutex_unlock(&sqd->lock);
> -			schedule();
> -			mutex_lock(&sqd->lock);
> +			needs_sched = true;
> +			list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
> +				if ((ctx->flags & IORING_SETUP_IOPOLL) &&
> +				    !list_empty_careful(&ctx->iopoll_list)) {
> +					needs_sched = false;
> +					break;
> +				}
> +				if (io_sqring_entries(ctx)) {
> +					needs_sched = false;
> +					break;
> +				}
> +			}
> +
> +			if (needs_sched) {
> +				mutex_unlock(&sqd->lock);
> +				schedule();
> +				mutex_lock(&sqd->lock);
> +			}
>   			list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
>   				io_ring_clear_wakeup_flag(ctx);
>   		}
> 

