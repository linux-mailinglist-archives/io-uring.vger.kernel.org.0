Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 626BB1DC1DF
	for <lists+io-uring@lfdr.de>; Thu, 21 May 2020 00:11:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728261AbgETWLE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 20 May 2020 18:11:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728424AbgETWK7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 20 May 2020 18:10:59 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2458EC061A0E
        for <io-uring@vger.kernel.org>; Wed, 20 May 2020 15:10:59 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id z5so6304991ejb.3
        for <io-uring@vger.kernel.org>; Wed, 20 May 2020 15:10:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GNtW3DHeCHBYqpr0jnwlMYpVIBPuB1qsEBaRM0VU/Kw=;
        b=cPmELI7XOXI5e++u50DbOC7ktb7Etcjn2rCAPjMZGerQmX6GZIIkCUvbe28+2HaLZl
         HYk1Yd+1QC9aA7EPv6I8dCHJ9pb7PsOMD4uQSB57awVLYYFxz0HmpCnMudTWkXTc2EPH
         UfPUKYrvTQxNtDG2NLuxn07uQlLQnQzw01a537m783mB8i+7AKS98IJ0r2h8+M8frH5w
         6DBSMgdiWtun2M4IYvNx4xD1+kceHqn0Nswv0aPlNa9PGYBnKRNSGj1QwTTnLalBfk+z
         qdbF2AcwckqEXJa23BavAWUxD8TqyxL2tOm/i71eKPe2sWAK35PS3BArLqf2KCkm56y7
         iuNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=GNtW3DHeCHBYqpr0jnwlMYpVIBPuB1qsEBaRM0VU/Kw=;
        b=hSO5TP9zDiOgec+t7tVYdNe3k1VejbMONSkvajtOCqJMOaF6l0O1HkF9USh0Lx8EZy
         vAZguAIg+pxont7czGsRUOmobkMlnkIUA95UxcY44hFXxCQjT9xM2Phvuu6XFTM74jP5
         fbYhbFHiBBUGSjvMTz06VOeVCX3Tsc24Zr38aUhhZcjeO/BICyXQG4CfD7UCuLQa+sOh
         ezR44K/sVvxlWOnWvis3Rs0MvBNXGfkUzI8kghxPAQE6L/hpodFXrQBcWvgZwEDLAO3F
         WDyYkgMjdWeg+1q+1Yx9PMav3ZMLOAdPtwRe9RrTsxjw1e3bQqYqInuQV7w/74HSgSBG
         nBsA==
X-Gm-Message-State: AOAM530RtWL8cMwec2kFWGArU+pi6y2XocWhGbbe74i85Yxa0A0uZzjW
        hBjH5bo9MUHzfWgFmriMKE6ld54O
X-Google-Smtp-Source: ABdhPJxOBd63AzY6JR+JTgQKp4Oa8QQT3dl5yikzvjftal3PqnT3UUhua+gXu0XS6uAD0qJbSBRglg==
X-Received: by 2002:a17:906:6453:: with SMTP id l19mr1017499ejn.169.1590012657572;
        Wed, 20 May 2020 15:10:57 -0700 (PDT)
Received: from [192.168.43.61] ([46.191.65.149])
        by smtp.gmail.com with ESMTPSA id l11sm2903236edw.55.2020.05.20.15.10.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 May 2020 15:10:56 -0700 (PDT)
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, joseph.qi@linux.alibaba.com, yujian.wu1@gmail.com
References: <20200520115648.6140-1-xiaoguang.wang@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH] io_uring: create percpu io sq thread when
 IORING_SETUP_SQ_AFF is flagged
Message-ID: <3bea8be7-2a82-cf24-a8b6-327672a64535@gmail.com>
Date:   Thu, 21 May 2020 01:09:45 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20200520115648.6140-1-xiaoguang.wang@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 20/05/2020 14:56, Xiaoguang Wang wrote:
> Currently we can create multiple io_uring instances which all have SQPOLL
> enabled and make them bound to same cpu core by setting sq_thread_cpu argument,
> but sometimes this isn't efficient. Imagine such extreme case, create two io
> uring instances, which both have SQPOLL enabled and are bound to same cpu core.
> One instance submits io per 500ms, another instance submits io continually,
> then obviously the 1st instance still always contend for cpu resource, which
> will impact 2nd instance.
> 
> I have constructed tests case to the evaluate impact:
>     1, a test progarm which creates one io_uring instance with SQPOLL
> enabled, and bound to cpu core 61.
>     2, sudo taskset -c 60 fio  -name=fiotest -filename=/dev/nvme0n1 -iodepth=128
> -thread -rw=read -ioengine=io_uring  -hipri=0 -sqthread_poll=1  -sqthread_poll_cpu=61
> -registerfiles=1 -direct=1 -bs=4k -size=10G -numjobs=1  -time_based -runtime=120
> Note both io_uring instance's sq_thread_cpu are bound to cpu core 61.
> 
> In current kernel, run above two jobs concurrently, and the 2nd job will get:
> Run status group 0 (all jobs):
>    READ: bw=1623MiB/s (1701MB/s), 1623MiB/s-1623MiB/s (1701MB/s-1701MB/s),
> io=190GiB (204GB), run=120010-120010msec
> 
> We can see that 1st instance has a huge impact to 2nd instance, I think it's
> because of unordered competition for same cpu resource, every instance gets
> 50% cpu usage.
> 
> To fix this issue, when io_uring instance uses IORING_SETUP_SQ_AFF to specify a
> cpu,  we create a percpu io sq_thread to handle multiple io_uring instances' io
> requests serially. With this patch, in same environment, we get a huge improvement:

Consider that a user can issue a long sequence of requests, say 2^15 of them,
and all of them will happen in a single call to io_submit_sqes(). Just preparing
them would take much time, apart from that it can do some effective work for
each of them, e.g. copying a page. And now there is another io_uring, caring
much about latencies and nevertheless waiting for _very_ long for its turn.

Another problem is that with it a user can't even guess when its SQ would be
emptied, and would need to constantly poll.

In essence, the problem is in bypassing thread scheduling, and re-implementing
poor man's version of it (round robin by io_uring).
The idea and the reasoning are compelling, but I think we need to do something
about unrelated io_uring instances obstructing each other. At least not making
it mandatory behaviour.

E.g. it's totally fine by me, if a sqpoll kthread is shared between specified
bunch of io_urings -- the user would be responsible for binding them and not
screwing up latencies/whatever. Most probably there won't be much (priviledged)
users using SQPOLL, and they all be a part of a single app, e.g. with
multiple/per-thread io_urings.

Another way would be to switch between io_urings faster, e.g. after processing
not all requests but 1 or some N of them. But that's very thin ice, and I
already see other bag of issues.

Ideas?


> Run status group 0 (all jobs):
>    READ: bw=3231MiB/s (3388MB/s), 3231MiB/s-3231MiB/s (3388MB/s-3388MB/s),
> io=379GiB (407GB), run=120001-120001msec
> 
> Link: https://lore.kernel.org/io-uring/c94098d2-279e-a552-91ec-8a8f177d770a@linux.alibaba.com/T/#t
> Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
> ---
>  fs/io_uring.c | 257 +++++++++++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 232 insertions(+), 25 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index ed0c22eb9808..e49ff1f67681 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -258,8 +258,13 @@ struct io_ring_ctx {
>  	/* IO offload */
>  	struct io_wq		*io_wq;
>  	struct task_struct	*sqo_thread;	/* if using sq thread polling */
> +	wait_queue_head_t	*sqo_wait;
> +	int			submit_status;
> +	int			sq_thread_cpu;
> +	struct list_head	node;
> +
>  	struct mm_struct	*sqo_mm;
> -	wait_queue_head_t	sqo_wait;
> +	wait_queue_head_t	__sqo_wait;
>  
>  	/*
>  	 * If used, fixed file set. Writers must ensure that ->refs is dead,
> @@ -330,6 +335,16 @@ struct io_ring_ctx {
>  	struct work_struct		exit_work;
>  };
>  
> +struct io_percpu_thread {
> +	struct list_head ctx_list;
> +	wait_queue_head_t sqo_percpu_wait;
> +	struct mutex lock;
> +	struct task_struct *sqo_thread;
> +	unsigned int sq_thread_idle;
> +};
> +
> +static struct io_percpu_thread __percpu *percpu_threads;
> +
>  /*
>   * First field must be the file pointer in all the
>   * iocb unions! See also 'struct kiocb' in <linux/fs.h>
> @@ -926,9 +941,11 @@ static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
>  		goto err;
>  
>  	ctx->flags = p->flags;
> -	init_waitqueue_head(&ctx->sqo_wait);
> +	init_waitqueue_head(&ctx->__sqo_wait);
> +	ctx->sqo_wait = &ctx->__sqo_wait;
>  	init_waitqueue_head(&ctx->cq_wait);
>  	INIT_LIST_HEAD(&ctx->cq_overflow_list);
> +	INIT_LIST_HEAD(&ctx->node);
>  	init_completion(&ctx->completions[0]);
>  	init_completion(&ctx->completions[1]);
>  	idr_init(&ctx->io_buffer_idr);
> @@ -1157,8 +1174,8 @@ static void io_cqring_ev_posted(struct io_ring_ctx *ctx)
>  {
>  	if (waitqueue_active(&ctx->wait))
>  		wake_up(&ctx->wait);
> -	if (waitqueue_active(&ctx->sqo_wait))
> -		wake_up(&ctx->sqo_wait);
> +	if (waitqueue_active(ctx->sqo_wait))
> +		wake_up(ctx->sqo_wait);
>  	if (io_should_trigger_evfd(ctx))
>  		eventfd_signal(ctx->cq_ev_fd, 1);
>  }
> @@ -1980,8 +1997,8 @@ static void io_iopoll_req_issued(struct io_kiocb *req)
>  		list_add_tail(&req->list, &ctx->poll_list);
>  
>  	if ((ctx->flags & IORING_SETUP_SQPOLL) &&
> -	    wq_has_sleeper(&ctx->sqo_wait))
> -		wake_up(&ctx->sqo_wait);
> +	    wq_has_sleeper(ctx->sqo_wait))
> +		wake_up(ctx->sqo_wait);
>  }
>  
>  static void io_file_put(struct io_submit_state *state)
> @@ -5994,7 +6011,7 @@ static int io_sq_thread(void *data)
>  				continue;
>  			}
>  
> -			prepare_to_wait(&ctx->sqo_wait, &wait,
> +			prepare_to_wait(ctx->sqo_wait, &wait,
>  						TASK_INTERRUPTIBLE);
>  
>  			/*
> @@ -6006,7 +6023,7 @@ static int io_sq_thread(void *data)
>  			 */
>  			if ((ctx->flags & IORING_SETUP_IOPOLL) &&
>  			    !list_empty_careful(&ctx->poll_list)) {
> -				finish_wait(&ctx->sqo_wait, &wait);
> +				finish_wait(ctx->sqo_wait, &wait);
>  				continue;
>  			}
>  
> @@ -6018,23 +6035,23 @@ static int io_sq_thread(void *data)
>  			to_submit = io_sqring_entries(ctx);
>  			if (!to_submit || ret == -EBUSY) {
>  				if (kthread_should_park()) {
> -					finish_wait(&ctx->sqo_wait, &wait);
> +					finish_wait(ctx->sqo_wait, &wait);
>  					break;
>  				}
>  				if (current->task_works) {
>  					task_work_run();
> -					finish_wait(&ctx->sqo_wait, &wait);
> +					finish_wait(ctx->sqo_wait, &wait);
>  					continue;
>  				}
>  				if (signal_pending(current))
>  					flush_signals(current);
>  				schedule();
> -				finish_wait(&ctx->sqo_wait, &wait);
> +				finish_wait(ctx->sqo_wait, &wait);
>  
>  				ctx->rings->sq_flags &= ~IORING_SQ_NEED_WAKEUP;
>  				continue;
>  			}
> -			finish_wait(&ctx->sqo_wait, &wait);
> +			finish_wait(ctx->sqo_wait, &wait);
>  
>  			ctx->rings->sq_flags &= ~IORING_SQ_NEED_WAKEUP;
>  		}
> @@ -6058,6 +6075,133 @@ static int io_sq_thread(void *data)
>  	return 0;
>  }
>  
> +static int process_ctx(struct io_ring_ctx *ctx)
> +{
> +	unsigned int to_submit;
> +	int ret = 0;
> +
> +	if (!list_empty(&ctx->poll_list)) {
> +		unsigned nr_events = 0;
> +
> +		mutex_lock(&ctx->uring_lock);
> +		if (!list_empty(&ctx->poll_list))
> +			io_iopoll_getevents(ctx, &nr_events, 0);
> +		mutex_unlock(&ctx->uring_lock);
> +	}
> +
> +	to_submit = io_sqring_entries(ctx);
> +	if (to_submit) {
> +		mutex_lock(&ctx->uring_lock);
> +		if (likely(!percpu_ref_is_dying(&ctx->refs)))
> +			ret = io_submit_sqes(ctx, to_submit, NULL, -1, true);
> +		mutex_unlock(&ctx->uring_lock);
> +	}
> +
> +	if (current->task_works)
> +		task_work_run();
> +
> +	io_sq_thread_drop_mm(ctx);
> +	return ret;
> +}
> +
> +static int io_sq_percpu_thread(void *data)
> +{
> +	struct io_percpu_thread *t = data;
> +	struct io_ring_ctx *ctx, *tmp;
> +	mm_segment_t old_fs;
> +	const struct cred *saved_creds, *cur_creds, *old_creds;
> +	unsigned long timeout;
> +	DEFINE_WAIT(wait);
> +	int iters = 0;
> +
> +	timeout = jiffies + t->sq_thread_idle;
> +	old_fs = get_fs();
> +	set_fs(USER_DS);
> +	saved_creds = cur_creds = NULL;
> +	while (!kthread_should_park()) {
> +		bool continue_run;
> +		bool needs_wait;
> +		unsigned int to_submit;
> +
> +		mutex_lock(&t->lock);
> +again:
> +		continue_run = false;
> +		list_for_each_entry_safe(ctx, tmp, &t->ctx_list, node) {
> +			if (cur_creds != ctx->creds) {
> +				old_creds = override_creds(ctx->creds);
> +				cur_creds = ctx->creds;
> +				if (saved_creds)
> +					put_cred(old_creds);
> +				else
> +					saved_creds = old_creds;
> +			}
> +			ctx->submit_status = process_ctx(ctx);
> +
> +			to_submit = io_sqring_entries(ctx);
> +			if (!continue_run &&
> +			    ((to_submit && ctx->submit_status != -EBUSY) ||
> +			    !list_empty(&ctx->poll_list)))
> +				continue_run = true;
> +		}
> +		if (continue_run && (++iters & 7)) {
> +			timeout = jiffies + t->sq_thread_idle;
> +			goto again;
> +		}
> +		mutex_unlock(&t->lock);
> +		if (continue_run) {
> +			timeout = jiffies + t->sq_thread_idle;
> +			continue;
> +		}
> +		if (!time_after(jiffies, timeout)) {
> +			cond_resched();
> +			continue;
> +		}
> +
> +		needs_wait = true;
> +		prepare_to_wait(&t->sqo_percpu_wait, &wait, TASK_INTERRUPTIBLE);
> +		mutex_lock(&t->lock);
> +		list_for_each_entry_safe(ctx, tmp, &t->ctx_list, node) {
> +			if ((ctx->flags & IORING_SETUP_IOPOLL) &&
> +			    !list_empty_careful(&ctx->poll_list)) {
> +				needs_wait = false;
> +				break;
> +			}
> +			to_submit = io_sqring_entries(ctx);
> +			if (to_submit && ctx->submit_status != -EBUSY) {
> +				needs_wait = false;
> +				break;
> +			}
> +		}
> +		if (needs_wait) {
> +			list_for_each_entry_safe(ctx, tmp, &t->ctx_list, node)
> +				ctx->rings->sq_flags |= IORING_SQ_NEED_WAKEUP;
> +			smp_mb();
> +
> +		}
> +		mutex_unlock(&t->lock);
> +
> +		if (needs_wait) {
> +			schedule();
> +			mutex_lock(&t->lock);
> +			list_for_each_entry_safe(ctx, tmp,
> +						 &t->ctx_list, node)
> +				ctx->rings->sq_flags &= ~IORING_SQ_NEED_WAKEUP;
> +			mutex_unlock(&t->lock);
> +			finish_wait(&t->sqo_percpu_wait, &wait);
> +		} else
> +			finish_wait(&t->sqo_percpu_wait, &wait);
> +		timeout = jiffies + t->sq_thread_idle;
> +		cond_resched();
> +	}
> +
> +	if (current->task_works)
> +		task_work_run();
> +	set_fs(old_fs);
> +	revert_creds(saved_creds);
> +	kthread_parkme();
> +	return 0;
> +}
> +
>  struct io_wait_queue {
>  	struct wait_queue_entry wq;
>  	struct io_ring_ctx *ctx;
> @@ -6219,18 +6363,23 @@ static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
>  	return 0;
>  }
>  
> +static void destroy_io_percpu_thread(struct io_ring_ctx *ctx, int cpu);
> +
>  static void io_sq_thread_stop(struct io_ring_ctx *ctx)
>  {
>  	if (ctx->sqo_thread) {
> -		wait_for_completion(&ctx->completions[1]);
> -		/*
> -		 * The park is a bit of a work-around, without it we get
> -		 * warning spews on shutdown with SQPOLL set and affinity
> -		 * set to a single CPU.
> -		 */
> -		kthread_park(ctx->sqo_thread);
> -		kthread_stop(ctx->sqo_thread);
> -		ctx->sqo_thread = NULL;
> +		if (!(ctx->flags & IORING_SETUP_SQ_AFF)) {
> +			wait_for_completion(&ctx->completions[1]);
> +			/*
> +			 * The park is a bit of a work-around, without it we get
> +			 * warning spews on shutdown with SQPOLL set and affinity
> +			 * set to a single CPU.
> +			 */
> +			kthread_park(ctx->sqo_thread);
> +			kthread_stop(ctx->sqo_thread);
> +			ctx->sqo_thread = NULL;
> +		} else
> +			destroy_io_percpu_thread(ctx, ctx->sq_thread_cpu);
>  	}
>  }
>  
> @@ -6841,6 +6990,52 @@ static int io_init_wq_offload(struct io_ring_ctx *ctx,
>  	return ret;
>  }
>  
> +static void create_io_percpu_thread(struct io_ring_ctx *ctx, int cpu)
> +{
> +	struct io_percpu_thread *t;
> +
> +	t = per_cpu_ptr(percpu_threads, cpu);
> +	mutex_lock(&t->lock);
> +	if (!t->sqo_thread) {
> +		t->sqo_thread = kthread_create_on_cpu(io_sq_percpu_thread, t,
> +					cpu, "io_uring_percpu-sq");
> +		if (IS_ERR(t->sqo_thread)) {
> +			ctx->sqo_thread = t->sqo_thread;
> +			t->sqo_thread = NULL;
> +			mutex_unlock(&t->lock);
> +			return;
> +		}
> +	}
> +
> +	if (t->sq_thread_idle < ctx->sq_thread_idle)
> +		t->sq_thread_idle = ctx->sq_thread_idle;
> +	ctx->sqo_wait = &t->sqo_percpu_wait;
> +	ctx->sq_thread_cpu = cpu;
> +	list_add_tail(&ctx->node, &t->ctx_list);
> +	ctx->sqo_thread = t->sqo_thread;
> +	mutex_unlock(&t->lock);
> +}
> +
> +static void destroy_io_percpu_thread(struct io_ring_ctx *ctx, int cpu)
> +{
> +	struct io_percpu_thread *t;
> +	struct task_struct *sqo_thread = NULL;
> +
> +	t = per_cpu_ptr(percpu_threads, cpu);
> +	mutex_lock(&t->lock);
> +	list_del(&ctx->node);
> +	if (list_empty(&t->ctx_list)) {
> +		sqo_thread = t->sqo_thread;
> +		t->sqo_thread = NULL;
> +	}
> +	mutex_unlock(&t->lock);
> +
> +	if (sqo_thread) {
> +		kthread_park(sqo_thread);
> +		kthread_stop(sqo_thread);
> +	}
> +}
> +
>  static int io_sq_offload_start(struct io_ring_ctx *ctx,
>  			       struct io_uring_params *p)
>  {
> @@ -6867,9 +7062,7 @@ static int io_sq_offload_start(struct io_ring_ctx *ctx,
>  			if (!cpu_online(cpu))
>  				goto err;
>  
> -			ctx->sqo_thread = kthread_create_on_cpu(io_sq_thread,
> -							ctx, cpu,
> -							"io_uring-sq");
> +			create_io_percpu_thread(ctx, cpu);
>  		} else {
>  			ctx->sqo_thread = kthread_create(io_sq_thread, ctx,
>  							"io_uring-sq");
> @@ -7516,7 +7709,7 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
>  		if (!list_empty_careful(&ctx->cq_overflow_list))
>  			io_cqring_overflow_flush(ctx, false);
>  		if (flags & IORING_ENTER_SQ_WAKEUP)
> -			wake_up(&ctx->sqo_wait);
> +			wake_up(ctx->sqo_wait);
>  		submitted = to_submit;
>  	} else if (to_submit) {
>  		mutex_lock(&ctx->uring_lock);
> @@ -8102,6 +8295,8 @@ SYSCALL_DEFINE4(io_uring_register, unsigned int, fd, unsigned int, opcode,
>  
>  static int __init io_uring_init(void)
>  {
> +	int cpu;
> +
>  #define __BUILD_BUG_VERIFY_ELEMENT(stype, eoffset, etype, ename) do { \
>  	BUILD_BUG_ON(offsetof(stype, ename) != eoffset); \
>  	BUILD_BUG_ON(sizeof(etype) != sizeof_field(stype, ename)); \
> @@ -8141,6 +8336,18 @@ static int __init io_uring_init(void)
>  	BUILD_BUG_ON(ARRAY_SIZE(io_op_defs) != IORING_OP_LAST);
>  	BUILD_BUG_ON(__REQ_F_LAST_BIT >= 8 * sizeof(int));
>  	req_cachep = KMEM_CACHE(io_kiocb, SLAB_HWCACHE_ALIGN | SLAB_PANIC);
> +
> +	percpu_threads = alloc_percpu(struct io_percpu_thread);
> +	for_each_possible_cpu(cpu) {
> +		struct io_percpu_thread *t;
> +
> +		t = per_cpu_ptr(percpu_threads, cpu);
> +		INIT_LIST_HEAD(&t->ctx_list);
> +		init_waitqueue_head(&t->sqo_percpu_wait);
> +		mutex_init(&t->lock);
> +		t->sqo_thread = NULL;
> +		t->sq_thread_idle = 0;
> +	}
>  	return 0;
>  };
>  __initcall(io_uring_init);
> 

-- 
Pavel Begunkov
