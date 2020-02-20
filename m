Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 130BE166549
	for <lists+io-uring@lfdr.de>; Thu, 20 Feb 2020 18:49:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728173AbgBTRts (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Feb 2020 12:49:48 -0500
Received: from merlin.infradead.org ([205.233.59.134]:54194 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727285AbgBTRts (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Feb 2020 12:49:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=aGcHmzWE84W3JqLraPuYXXclbO+5vndrw/ZG+wK5kR8=; b=txs39TA+bSs+Mwwn/WxsyWjJHR
        gH37hbtTtz4zPO6v6UxYFKpGUP9Gn/zi6+N32cs/KGwg/RlOuevCEkoGGY07qpwMnnTj0idCjWr1L
        0IE/AIGOP6sTnHSlzXr7pS99lKKjQbbHwJILALesXUjNAspgS3aoEPKJZAYffJs86XDB0hPW4se4e
        aSNz3ExK+Xqt8JK1/m/JVuGmPccJN/K7JAuKrhHf7+7QbniVBK3N8O4ZTtS8OtRvuS5VN3UymCfA4
        hYv6tNibqk6YuklzSsYuHujBgvhjwMuAZNeW/hWF+B/ZotcrrK/iwhjohz/zyGoQXRh/3dtzEUiaR
        BNWRF7HQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j4pxD-0001lC-FC; Thu, 20 Feb 2020 17:49:39 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 3583D30008D;
        Thu, 20 Feb 2020 18:47:39 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 417FD2B4C8AB0; Thu, 20 Feb 2020 18:49:32 +0100 (CET)
Date:   Thu, 20 Feb 2020 18:49:32 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Oleg Nesterov <oleg@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Carter Li =?utf-8?B?5p2O6YCa5rSy?= <carter.li@eoitek.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
Subject: Re: [PATCH] task_work_run: don't take ->pi_lock unconditionally
Message-ID: <20200220174932.GB18400@hirez.programming.kicks-ass.net>
References: <53de3581-b902-89ba-3f53-fd46b052df40@kernel.dk>
 <43c066d1-a892-6a02-82e7-7be850d9454d@kernel.dk>
 <20200217174610.GU14897@hirez.programming.kicks-ass.net>
 <592cf069-41ee-0bc1-1f83-e058e5dd53ff@kernel.dk>
 <20200218131310.GZ14914@hirez.programming.kicks-ass.net>
 <20200218145645.GB3466@redhat.com>
 <20200218150756.GC14914@hirez.programming.kicks-ass.net>
 <20200218155017.GD3466@redhat.com>
 <20200220163938.GA18400@hirez.programming.kicks-ass.net>
 <20200220172201.GC27143@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200220172201.GC27143@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Feb 20, 2020 at 06:22:02PM +0100, Oleg Nesterov wrote:
> On 02/20, Peter Zijlstra wrote:

> > +		work = READ_ONCE(task->task_works);
> > +		if (!work) {
> > +			if (!(task->flags & PF_EXITING))
> > +				return;
> > +
> > +			/*
> > +			 * work->func() can do task_work_add(), do not set
> > +			 * work_exited unless the list is empty.
> > +			 */
> > +			if (try_cmpxchg(&task->task_works, &work, &work_exited))
> > +				return;
> > +		}
> > +
> > +		work = xchg(&task->task_works, NULL);
> >  
> > -		if (!work)
> > -			break;
> 
> You can't remove the "if (!work)" check, cancel_task_work() can remove
> a single callback between READ_ONCE() and xchg().

Argh!

> Oleg.
> 
> --- a/kernel/task_work.c
> +++ b/kernel/task_work.c
> @@ -27,14 +27,11 @@ static struct callback_head work_exited; /* all we need is ->next == NULL */
>  int
>  task_work_add(struct task_struct *task, struct callback_head *work, bool notify)
>  {
> -	struct callback_head *head;
> -
> +	work->next = READ_ONCE(task->task_works);
>  	do {
> -		head = READ_ONCE(task->task_works);
> -		if (unlikely(head == &work_exited))
> +		if (unlikely(work->next == &work_exited))
>  			return -ESRCH;
> -		work->next = head;
> -	} while (cmpxchg(&task->task_works, head, work) != head);
> +	} while (!try_cmpxchg(&task->task_works, &work->next, work));
>  
>  	if (notify)
>  		set_notify_resume(task);

Cute, that should work.

> @@ -68,10 +65,10 @@ task_work_cancel(struct task_struct *task, task_work_func_t func)
>  	 * we raced with task_work_run(), *pprev == NULL/exited.
>  	 */
>  	raw_spin_lock_irqsave(&task->pi_lock, flags);
> +	for (work = READ_ONCE(*pprev); work; ) {
>  		if (work->func != func)
>  			pprev = &work->next;

But didn't you loose the READ_ONCE() of *pprev in this branch?

> +		else if (try_cmpxchg(pprev, &work, work->next))
>  			break;
>  	}
>  	raw_spin_unlock_irqrestore(&task->pi_lock, flags);


> @@ -97,16 +94,16 @@ void task_work_run(void)
>  		 * work->func() can do task_work_add(), do not set
>  		 * work_exited unless the list is empty.
>  		 */
> +		work = READ_ONCE(task->task_works);
>  		do {
>  			head = NULL;
>  			if (!work) {
>  				if (task->flags & PF_EXITING)
>  					head = &work_exited;
>  				else
>  					break;
>  			}
> +		} while (!try_cmpxchg(&task->task_works, &work, head));
>  
>  		if (!work)
>  			break;

But given that, as you say, cancel() could have gone and stole our head,
should we not try and install &work_exiting when PF_EXITING in that
case?

That is; should we not do continue in that case, instead of break.

---

--- a/kernel/task_work.c
+++ b/kernel/task_work.c
@@ -27,14 +27,13 @@ static struct callback_head work_exited;
 int
 task_work_add(struct task_struct *task, struct callback_head *work, bool notify)
 {
-	struct callback_head *head;
+	struct callback_head *head = READ_ONCE(tsk->task_works);
 
 	do {
-		head = READ_ONCE(task->task_works);
 		if (unlikely(head == &work_exited))
 			return -ESRCH;
 		work->next = head;
-	} while (cmpxchg(&task->task_works, head, work) != head);
+	} while (!try_cmpxchg(&task->task_works, &head, work))
 
 	if (notify)
 		set_notify_resume(task);
@@ -69,9 +68,12 @@ task_work_cancel(struct task_struct *tas
 	 */
 	raw_spin_lock_irqsave(&task->pi_lock, flags);
 	while ((work = READ_ONCE(*pprev))) {
-		if (work->func != func)
+		if (work->func != func) {
 			pprev = &work->next;
-		else if (cmpxchg(pprev, work, work->next) == work)
+			continue;
+		}
+
+		if (try_cmpxchg(pprev, &work, work->next))
 			break;
 	}
 	raw_spin_unlock_irqrestore(&task->pi_lock, flags);
@@ -90,26 +92,26 @@ task_work_cancel(struct task_struct *tas
 void task_work_run(void)
 {
 	struct task_struct *task = current;
-	struct callback_head *work, *head, *next;
+	struct callback_head *work, *next;
 
 	for (;;) {
-		/*
-		 * work->func() can do task_work_add(), do not set
-		 * work_exited unless the list is empty.
-		 */
-		do {
-			head = NULL;
-			work = READ_ONCE(task->task_works);
-			if (!work) {
-				if (task->flags & PF_EXITING)
-					head = &work_exited;
-				else
-					break;
-			}
-		} while (cmpxchg(&task->task_works, work, head) != work);
+		work = READ_ONCE(task->task_works);
+		if (!work) {
+			if (!(task->flags & PF_EXITING))
+				return;
+
+			/*
+			 * work->func() can do task_work_add(), do not set
+			 * work_exited unless the list is empty.
+			 */
+			if (try_cmpxchg(&task->task_works, &work, &work_exited))
+				return;
+		}
+
+		work = xchg(&task->task_works, NULL);
+		if (!work)
+			continue;
 
-		if (!work)
-			break;
 		/*
 		 * Synchronize with task_work_cancel(). It can not remove
 		 * the first entry == work, cmpxchg(task_works) must fail.

