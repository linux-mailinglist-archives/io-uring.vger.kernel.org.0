Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 133FC15DB02
	for <lists+io-uring@lfdr.de>; Fri, 14 Feb 2020 16:32:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387438AbgBNPcY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 14 Feb 2020 10:32:24 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:51542 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387435AbgBNPcX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 14 Feb 2020 10:32:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=MNsKvUSIS+yRYAE3qRhpn/J5RBbYFVWQg/XQqI9qVr4=; b=KtVekxNnJunr+Eo0QFu94N6Vkg
        cn82TLQCkan+3/ONFJda6fc8mCM3mDNhrOhv75nmBFu7vGuYZy89n8L587j/JofLNzqshGHe3ypAm
        B/b67pykBEdwBwm9IvRqTlh4yxktTQQvOpLlBSAZ+fw1/aZpuTYGQ9yBoXMiRwyLSzU0H+6wyYW6Z
        6CajiBVcNsSnmDHYRrDsnmap2Gh/V8eeOLhZDjOG4BitOavbsEcl+xwmYSmN3u1k3obkHGAxY1MhT
        4gEa1J9b1qVIBX/ZVpthi+VER30WIvyqs47xjuFBhnstWDJTCZuS4buNYkEhx22t45O3ba40ng4CI
        /wvLeMIQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j2cx2-0007xT-RG; Fri, 14 Feb 2020 15:32:21 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 292AD300606;
        Fri, 14 Feb 2020 16:30:28 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id D84132B7863CA; Fri, 14 Feb 2020 16:32:18 +0100 (CET)
Date:   Fri, 14 Feb 2020 16:32:18 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Carter Li =?utf-8?B?5p2O6YCa5rSy?= <carter.li@eoitek.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
Subject: Re: [ISSUE] The time cost of IOSQE_IO_LINK
Message-ID: <20200214153218.GM14914@hirez.programming.kicks-ass.net>
References: <9FEF0D34-A012-4505-AA4E-FF97CC302A33@eoitek.com>
 <8a3ee653-77ed-105d-c1c3-87087451914e@kernel.dk>
 <ADF462D7-A381-4314-8931-DDB0A2C18761@eoitek.com>
 <9a8e4c8a-f8b2-900d-92b6-cc69b6adf324@gmail.com>
 <5f09d89a-0c6d-47c2-465c-993af0c7ae71@kernel.dk>
 <7E66D70C-BE4E-4236-A49B-9843F66EA322@eoitek.com>
 <671A3FE3-FA12-43D8-ADF0-D1DB463B053F@eoitek.com>
 <217eda7b-3742-a50b-7d6a-c1294a85c8e0@kernel.dk>
 <1b9a7390-7539-a8bc-d437-493253b13d77@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1b9a7390-7539-a8bc-d437-493253b13d77@kernel.dk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Feb 13, 2020 at 10:03:54PM -0700, Jens Axboe wrote:

> CC'ing peterz for some cluebat knowledge. Peter, is there a nice way to
> currently do something like this? Only thing I'm currently aware of is
> the preempt in/out notifiers, but they don't quite provide what I need,
> since I need to pass some data (a request) as well.

Whee, nothing quite like this around I think.

> The full detail on what I'm trying here is:
> 
> io_uring can have linked requests. One obvious use case for that is to
> queue a POLLIN on a socket, and then link a read/recv to that. When the
> poll completes, we want to run the read/recv. io_uring hooks into the
> waitqueue wakeup handler to finish the poll request, and since we're
> deep in waitqueue wakeup code, it queues the linked read/recv for
> execution via an async thread. This is not optimal, obviously, as it
> relies on a switch to a new thread to perform this read. This hack
> queues a backlog to the task itself, and runs it when it's scheduled in.
> Probably want to do the same for sched out as well, currently I just
> hack that in the io_uring wait part...

I'll definitely need to think more about this, but a few comments on the
below.

> +static void __io_uring_task_handler(struct list_head *list)
> +{
> +	struct io_kiocb *req;
> +
> +	while (!list_empty(list)) {
> +		req = list_first_entry(list, struct io_kiocb, list);
> +		list_del(&req->list);
> +
> +		__io_queue_sqe(req, NULL);
> +	}
> +}
> +
> +void io_uring_task_handler(struct task_struct *tsk)
> +{
> +	LIST_HEAD(list);
> +
> +	raw_spin_lock_irq(&tsk->uring_lock);
> +	if (!list_empty(&tsk->uring_work))
> +		list_splice_init(&tsk->uring_work, &list);
> +	raw_spin_unlock_irq(&tsk->uring_lock);
> +
> +	__io_uring_task_handler(&list);
> +}

> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index fc1dfc007604..b60f081cac17 100644
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
> @@ -3069,6 +3074,20 @@ fire_sched_out_preempt_notifiers(struct task_struct *curr,
>  
>  #endif /* CONFIG_PREEMPT_NOTIFIERS */
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
>  static inline void prepare_task(struct task_struct *next)
>  {
>  #ifdef CONFIG_SMP
> @@ -3322,6 +3341,8 @@ asmlinkage __visible void schedule_tail(struct task_struct *prev)
>  	balance_callback(rq);
>  	preempt_enable();
>  
> +	io_uring_handler(current);
> +
>  	if (current->set_child_tid)
>  		put_user(task_pid_vnr(current), current->set_child_tid);
>  

I suspect you meant to put that in finish_task_switch() which is the
tail end of every schedule(), schedule_tail() is the tail end of
clone().

Or maybe you meant to put it in (and rename) sched_update_worker() which
is after every schedule() but in a preemptible context -- much saner
since you don't want to go add an unbounded amount of work in a
non-preemptible context.

At which point you already have your callback: io_wq_worker_running(),
or is this for any random task?


