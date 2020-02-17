Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 448AE1611A6
	for <lists+io-uring@lfdr.de>; Mon, 17 Feb 2020 13:09:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728929AbgBQMJZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 17 Feb 2020 07:09:25 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:34258 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728897AbgBQMJZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 17 Feb 2020 07:09:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=9wKoI19EOQ4d3vXVB3GC2wc5fK0QCJuiLG4BM06RzH4=; b=oMTIHsZG5T1HDjAYnbNAzhFcwh
        dhQVelo3ddOJ8b5XeHmCmMvzbM7+0m6gdoAicsuQLeNAxEZ129M5qWzu04kTdm2hx1E0t+oToZZZq
        r78AckB1mR0TIPBKRki1SHlN1XxlSFD4/Rsg+ucXddRsF4j9P9+WldLvxhxv67mEq+5NfViuR9hDR
        MD0xBG+hbUrgsw3xrIQNutdsM5w8dBOGrSXXCRNUYF306GMYWuLwnY1z63qvWoWFAayth1/jOydnR
        4NR29o8pQ24RtysfOOfT2FJB+4dASpVYNmwRatmIeDIi8ERPHtkxICozMRQiKAH02I0K+XRcmPUui
        dPadYOWA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j3fDH-0006M4-5D; Mon, 17 Feb 2020 12:09:23 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 96B1A300606;
        Mon, 17 Feb 2020 13:07:29 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id C36BA20206D63; Mon, 17 Feb 2020 13:09:20 +0100 (CET)
Date:   Mon, 17 Feb 2020 13:09:20 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Carter Li =?utf-8?B?5p2O6YCa5rSy?= <carter.li@eoitek.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
Subject: Re: [ISSUE] The time cost of IOSQE_IO_LINK
Message-ID: <20200217120920.GQ14914@hirez.programming.kicks-ass.net>
References: <5f09d89a-0c6d-47c2-465c-993af0c7ae71@kernel.dk>
 <7E66D70C-BE4E-4236-A49B-9843F66EA322@eoitek.com>
 <671A3FE3-FA12-43D8-ADF0-D1DB463B053F@eoitek.com>
 <217eda7b-3742-a50b-7d6a-c1294a85c8e0@kernel.dk>
 <1b9a7390-7539-a8bc-d437-493253b13d77@kernel.dk>
 <20200214153218.GM14914@hirez.programming.kicks-ass.net>
 <5995f84e-8a6c-e774-6bb5-5b9b87a9cd3c@kernel.dk>
 <7c4c3996-4886-eb58-cdee-fe0951907ab5@kernel.dk>
 <addcd44e-ed9b-5f82-517d-c1ed3ee2d85c@kernel.dk>
 <b8069e62-7ea4-c7f3-55a3-838241951068@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b8069e62-7ea4-c7f3-55a3-838241951068@kernel.dk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Feb 14, 2020 at 01:44:32PM -0700, Jens Axboe wrote:

I've not looked at git trees yet, but the below doesn't apply to
anything I have at hand.

Anyway, I think I can still make sense of it -- just a rename or two
seems to be missing.

A few notes on the below...

> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 04278493bf15..447b06c6bed0 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -685,6 +685,11 @@ struct task_struct {
>  #endif
>  	struct sched_dl_entity		dl;
>  
> +#ifdef CONFIG_IO_URING
> +	struct list_head		uring_work;
> +	raw_spinlock_t			uring_lock;
> +#endif
> +

Could we pretty please use struct callback_head for this, just like
task_work() and RCU ? Look at task_work_add() for inspiration.

And maybe remove the uring naming form this.

>  #ifdef CONFIG_UCLAMP_TASK
>  	/* Clamp values requested for a scheduling entity */
>  	struct uclamp_se		uclamp_req[UCLAMP_CNT];
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 51ca491d99ed..170fefa1caf8 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -2717,6 +2717,11 @@ static void __sched_fork(unsigned long clone_flags, struct task_struct *p)
>  	INIT_HLIST_HEAD(&p->preempt_notifiers);
>  #endif
>  
> +#ifdef CONFIG_IO_URING
> +	INIT_LIST_HEAD(&p->uring_work);
> +	raw_spin_lock_init(&p->uring_lock);
> +#endif
> +
>  #ifdef CONFIG_COMPACTION
>  	p->capture_control = NULL;
>  #endif
> @@ -4104,6 +4109,20 @@ void __noreturn do_task_dead(void)
>  		cpu_relax();
>  }
>  
> +#ifdef CONFIG_IO_URING
> +extern void io_uring_task_handler(struct task_struct *tsk);
> +
> +static inline void io_uring_handler(struct task_struct *tsk)
> +{
> +	if (!list_empty(&tsk->uring_work))
> +		io_uring_task_handler(tsk);
> +}
> +#else /* !CONFIG_IO_URING */
> +static inline void io_uring_handler(struct task_struct *tsk)
> +{
> +}
> +#endif
> +
>  static void sched_out_update(struct task_struct *tsk)
>  {
>  	/*
> @@ -4121,6 +4140,7 @@ static void sched_out_update(struct task_struct *tsk)
>  			io_wq_worker_sleeping(tsk);
>  		preempt_enable_no_resched();
>  	}
> +	io_uring_handler(tsk);
>  }
>  
>  static void sched_in_update(struct task_struct *tsk)
> @@ -4131,6 +4151,7 @@ static void sched_in_update(struct task_struct *tsk)
>  		else
>  			io_wq_worker_running(tsk);
>  	}
> +	io_uring_handler(tsk);
>  }

The problem I have here is that we have an unconditional load of the
cacheline that has ->uring_work in.

/me curses about how nobody seems interested in building useful
cacheline analyis tools :/

Lemme see if I can find a spot for this... perhaps something like so?



diff --git a/include/linux/sched.h b/include/linux/sched.h
index 0918904c939d..4fba93293fa1 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -649,6 +649,7 @@ struct task_struct {
 	/* Per task flags (PF_*), defined further below: */
 	unsigned int			flags;
 	unsigned int			ptrace;
+	int				on_rq;
 
 #ifdef CONFIG_SMP
 	struct llist_node		wake_entry;
@@ -671,14 +672,16 @@ struct task_struct {
 	int				recent_used_cpu;
 	int				wake_cpu;
 #endif
-	int				on_rq;
 
 	int				prio;
 	int				static_prio;
 	int				normal_prio;
 	unsigned int			rt_priority;
 
+	struct callbach_head		*sched_work;
+
 	const struct sched_class	*sched_class;
+
 	struct sched_entity		se;
 	struct sched_rt_entity		rt;
 #ifdef CONFIG_CGROUP_SCHED


