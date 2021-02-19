Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 698C731FFCE
	for <lists+io-uring@lfdr.de>; Fri, 19 Feb 2021 21:27:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbhBSU1Y (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Feb 2021 15:27:24 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:50150 "EHLO
        out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229914AbhBSU1V (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Feb 2021 15:27:21 -0500
Received: from in02.mta.xmission.com ([166.70.13.52])
        by out03.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1lDCMI-002ZLB-S5; Fri, 19 Feb 2021 13:26:38 -0700
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=fess.xmission.com)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1lDCMH-00Bmyt-O8; Fri, 19 Feb 2021 13:26:38 -0700
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, viro@zeniv.linux.org.uk,
        torvalds@linux-foundation.org
References: <20210219171010.281878-1-axboe@kernel.dk>
        <20210219171010.281878-2-axboe@kernel.dk>
Date:   Fri, 19 Feb 2021 14:25:29 -0600
In-Reply-To: <20210219171010.281878-2-axboe@kernel.dk> (Jens Axboe's message
        of "Fri, 19 Feb 2021 10:09:53 -0700")
Message-ID: <m1czwvoldy.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1lDCMH-00Bmyt-O8;;;mid=<m1czwvoldy.fsf@fess.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+R64qsXIXlolj4R6IiGGPCyh8C5JP7y0o=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa04.xmission.com
X-Spam-Level: ***
X-Spam-Status: No, score=3.6 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,LotsOfNums_01,T_TM2_M_HEADER_IN_MSG,T_TooManySym_01,
        T_TooManySym_02,T_XMDrugObfuBody_14,XMNoVowels,XMSubLong,
        XM_B_SpammyWords autolearn=disabled version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.7 XMSubLong Long Subject
        *  1.5 XMNoVowels Alpha-numberic number with no vowels
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        *  1.2 LotsOfNums_01 BODY: Lots of long strings of numbers
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
        *  0.2 T_XMDrugObfuBody_14 obfuscated drug references
        *  0.2 XM_B_SpammyWords One or more commonly used spammy words
        *  0.0 T_TooManySym_02 5+ unique symbols in subject
        *  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;Jens Axboe <axboe@kernel.dk>
X-Spam-Relay-Country: 
X-Spam-Timing: total 514 ms - load_scoreonly_sql: 0.04 (0.0%),
        signal_user_changed: 10 (2.0%), b_tie_ro: 9 (1.7%), parse: 1.03 (0.2%),
         extract_message_metadata: 14 (2.8%), get_uri_detail_list: 2.4 (0.5%),
        tests_pri_-1000: 4.6 (0.9%), tests_pri_-950: 1.21 (0.2%),
        tests_pri_-900: 0.97 (0.2%), tests_pri_-90: 83 (16.2%), check_bayes:
        82 (15.9%), b_tokenize: 10 (1.9%), b_tok_get_all: 9 (1.7%),
        b_comp_prob: 2.2 (0.4%), b_tok_touch_all: 59 (11.4%), b_finish: 0.67
        (0.1%), tests_pri_0: 323 (62.9%), check_dkim_signature: 0.58 (0.1%),
        check_dkim_adsp: 2.0 (0.4%), poll_dns_idle: 48 (9.4%), tests_pri_10:
        4.1 (0.8%), tests_pri_500: 67 (13.1%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH 01/18] io_uring: remove the need for relying on an io-wq fallback worker
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Jens Axboe <axboe@kernel.dk> writes:

> We hit this case when the task is exiting, and we need somewhere to
> do background cleanup of requests. Instead of relying on the io-wq
> task manager to do this work for us, just stuff it somewhere where
> we can safely run it ourselves directly.

Minor nits below.

Eric

>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  fs/io-wq.c    | 12 ------------
>  fs/io-wq.h    |  2 --
>  fs/io_uring.c | 38 +++++++++++++++++++++++++++++++++++---
>  3 files changed, 35 insertions(+), 17 deletions(-)
>
> diff --git a/fs/io-wq.c b/fs/io-wq.c
> index c36bbcd823ce..800b299f9772 100644
> --- a/fs/io-wq.c
> +++ b/fs/io-wq.c
> @@ -16,7 +16,6 @@
>  #include <linux/kthread.h>
>  #include <linux/rculist_nulls.h>
>  #include <linux/fs_struct.h>
> -#include <linux/task_work.h>
>  #include <linux/blk-cgroup.h>
>  #include <linux/audit.h>
>  #include <linux/cpu.h>
> @@ -775,9 +774,6 @@ static int io_wq_manager(void *data)
>  	complete(&wq->done);
>  
>  	while (!kthread_should_stop()) {
> -		if (current->task_works)
> -			task_work_run();
> -
>  		for_each_node(node) {
>  			struct io_wqe *wqe = wq->wqes[node];
>  			bool fork_worker[2] = { false, false };
> @@ -800,9 +796,6 @@ static int io_wq_manager(void *data)
>  		schedule_timeout(HZ);
>  	}
>  
> -	if (current->task_works)
> -		task_work_run();
> -
>  out:
>  	if (refcount_dec_and_test(&wq->refs)) {
>  		complete(&wq->done);
> @@ -1160,11 +1153,6 @@ void io_wq_destroy(struct io_wq *wq)
>  		__io_wq_destroy(wq);
>  }
>  
> -struct task_struct *io_wq_get_task(struct io_wq *wq)
> -{
> -	return wq->manager;
> -}
> -
>  static bool io_wq_worker_affinity(struct io_worker *worker, void *data)
>  {
>  	struct task_struct *task = worker->task;
> diff --git a/fs/io-wq.h b/fs/io-wq.h
> index 096f1021018e..a1610702f222 100644
> --- a/fs/io-wq.h
> +++ b/fs/io-wq.h
> @@ -124,8 +124,6 @@ typedef bool (work_cancel_fn)(struct io_wq_work *, void *);
>  enum io_wq_cancel io_wq_cancel_cb(struct io_wq *wq, work_cancel_fn *cancel,
>  					void *data, bool cancel_all);
>  
> -struct task_struct *io_wq_get_task(struct io_wq *wq);
> -
>  #if defined(CONFIG_IO_WQ)
>  extern void io_wq_worker_sleeping(struct task_struct *);
>  extern void io_wq_worker_running(struct task_struct *);
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index d951acb95117..bbd1ec7aa9e9 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -455,6 +455,9 @@ struct io_ring_ctx {
>  
>  	struct io_restriction		restrictions;
>  
> +	/* exit task_work */
> +	struct callback_head		*exit_task_work;
> +
>  	/* Keep this last, we don't need it for the fast path */
>  	struct work_struct		exit_work;
>  };
> @@ -2313,11 +2316,14 @@ static int io_req_task_work_add(struct io_kiocb *req)
>  static void io_req_task_work_add_fallback(struct io_kiocb *req,
>  					  task_work_func_t cb)
>  {
> -	struct task_struct *tsk = io_wq_get_task(req->ctx->io_wq);
> +	struct io_ring_ctx *ctx = req->ctx;
> +	struct callback_head *head;
>  
>  	init_task_work(&req->task_work, cb);
> -	task_work_add(tsk, &req->task_work, TWA_NONE);
> -	wake_up_process(tsk);
> +	do {
> +		head = ctx->exit_task_work;
                       ^^^^^^^^^^^^^^^^^^^^
This feels like this should be READ_ONCE to prevent tearing reads.

You use READ_ONCE on this same variable below which really suggests
this should be a READ_ONCE.


> +		req->task_work.next = head;
> +	} while (cmpxchg(&ctx->exit_task_work, head, &req->task_work) != head);
>  }
>  
>  static void __io_req_task_cancel(struct io_kiocb *req, int error)
> @@ -9258,6 +9264,30 @@ void __io_uring_task_cancel(void)
>  	io_uring_remove_task_files(tctx);
>  }
>  
> +static void io_run_ctx_fallback(struct io_ring_ctx *ctx)
> +{
> +	struct callback_head *work, *head, *next;
> +
> +	do {
> +		do {
> +			head = NULL;
> +			work = READ_ONCE(ctx->exit_task_work);
> +			if (!work)
> +				break;
> +		} while (cmpxchg(&ctx->exit_task_work, work, head) != work);
> +
> +		if (!work)
> +			break;

Why the double break on "!work"?  It seems like either the first should
be goto out, or only the second should be here.

> +
> +		do {
> +			next = work->next;
> +			work->func(work);
> +			work = next;
> +			cond_resched();
> +		} while (work);
> +	} while (1);
> +}
> +
>  static int io_uring_flush(struct file *file, void *data)
>  {
>  	struct io_uring_task *tctx = current->io_uring;
> @@ -9268,6 +9298,8 @@ static int io_uring_flush(struct file *file, void *data)
>  		io_req_caches_free(ctx, current);
>  	}
>  
> +	io_run_ctx_fallback(ctx);
> +
>  	if (!tctx)
>  		return 0;
