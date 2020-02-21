Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B16E51680D3
	for <lists+io-uring@lfdr.de>; Fri, 21 Feb 2020 15:53:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728798AbgBUOxE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Feb 2020 09:53:04 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:21494 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728792AbgBUOxD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Feb 2020 09:53:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582296782;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AVqNx+0eU3fDtEoscmzZDGxJ0XeCviHqK6gLgBUKosk=;
        b=eVPQRG43LIxSF3TUv43KTPeZdkN/lFY+5K2cTlOIOUyYiXCn7YFznQ/0M1Tjsta3StTZ0T
        WFlYA/4ZO6m9Mb8o+NTpymV+nEWEWejIWfw8ph8k06FVoIGk8UWiVlOHkUqCah6OMcqdOU
        VIgB/2NzvCtZ3js27joiTSTC1jJztLE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-102-ZQBDzOefO1i-u_d6HU89Bw-1; Fri, 21 Feb 2020 09:53:00 -0500
X-MC-Unique: ZQBDzOefO1i-u_d6HU89Bw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E4FA2477;
        Fri, 21 Feb 2020 14:52:58 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.43.17.70])
        by smtp.corp.redhat.com (Postfix) with SMTP id 8815360BE0;
        Fri, 21 Feb 2020 14:52:57 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
        oleg@redhat.com; Fri, 21 Feb 2020 15:52:58 +0100 (CET)
Date:   Fri, 21 Feb 2020 15:52:56 +0100
From:   Oleg Nesterov <oleg@redhat.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Carter Li =?utf-8?B?5p2O6YCa5rSy?= <carter.li@eoitek.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
Subject: Re: [PATCH] task_work_run: don't take ->pi_lock unconditionally
Message-ID: <20200221145256.GA16646@redhat.com>
References: <43c066d1-a892-6a02-82e7-7be850d9454d@kernel.dk>
 <20200217174610.GU14897@hirez.programming.kicks-ass.net>
 <592cf069-41ee-0bc1-1f83-e058e5dd53ff@kernel.dk>
 <20200218131310.GZ14914@hirez.programming.kicks-ass.net>
 <20200218145645.GB3466@redhat.com>
 <20200218150756.GC14914@hirez.programming.kicks-ass.net>
 <20200218155017.GD3466@redhat.com>
 <20200220163938.GA18400@hirez.programming.kicks-ass.net>
 <20200220172201.GC27143@redhat.com>
 <20200220174932.GB18400@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200220174932.GB18400@hirez.programming.kicks-ass.net>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 02/20, Peter Zijlstra wrote:
>
> On Thu, Feb 20, 2020 at 06:22:02PM +0100, Oleg Nesterov wrote:
> > @@ -68,10 +65,10 @@ task_work_cancel(struct task_struct *task, task_work_func_t func)
> >  	 * we raced with task_work_run(), *pprev == NULL/exited.
> >  	 */
> >  	raw_spin_lock_irqsave(&task->pi_lock, flags);
> > +	for (work = READ_ONCE(*pprev); work; ) {
> >  		if (work->func != func)
> >  			pprev = &work->next;
>
> But didn't you loose the READ_ONCE() of *pprev in this branch?

Argh, yes ;)

> > @@ -97,16 +94,16 @@ void task_work_run(void)
> >  		 * work->func() can do task_work_add(), do not set
> >  		 * work_exited unless the list is empty.
> >  		 */
> > +		work = READ_ONCE(task->task_works);
> >  		do {
> >  			head = NULL;
> >  			if (!work) {
> >  				if (task->flags & PF_EXITING)
> >  					head = &work_exited;
> >  				else
> >  					break;
> >  			}
> > +		} while (!try_cmpxchg(&task->task_works, &work, head));
> >
> >  		if (!work)
> >  			break;
>
> But given that, as you say, cancel() could have gone and stole our head,
> should we not try and install &work_exiting when PF_EXITING in that
> case?

cancel() can't do this, as long as we use cmpxchg/try_cmpxchg, not xchg().
This is what the comment before lock/unlock below tries to explain.

> That is; should we not do continue in that case, instead of break.

This is what we should do if we use xchg() like your previous version did.
Or I am totally confused. Hmm, and when I re-read my words it looks as if
I am trying to confuse you.

So lets "simplify" this code assuming that PF_EXITING is set:

		work = READ_ONCE(task->task_works);
		do {
			head = NULL;
			if (!work)
				head = &work_exited;
		} while (!try_cmpxchg(&task->task_works, &work, head));

		if (!work)
			break;

If work == NULL after try_cmpxchg() _succeeds_, then the new "head" must
be work_exited and we have nothing to do.

If it was nullified by try_cmpxchg(&work) because we raced with cancel_(),
then this try_cmpxchg() should have been failed.

Right?

> @@ -69,9 +68,12 @@ task_work_cancel(struct task_struct *tas
>  	 */
>  	raw_spin_lock_irqsave(&task->pi_lock, flags);
>  	while ((work = READ_ONCE(*pprev))) {
> -		if (work->func != func)
> +		if (work->func != func) {
>  			pprev = &work->next;
> -		else if (cmpxchg(pprev, work, work->next) == work)
> +			continue;
> +		}
> +
> +		if (try_cmpxchg(pprev, &work, work->next))
>  			break;

perhaps I misread this code, but it looks a bit strange to me... it doesn't
differ from

	while ((work = READ_ONCE(*pprev))) {
		if (work->func != func)
			pprev = &work->next;
		else if (try_cmpxchg(pprev, &work, work->next))
			break;
	}

either way it is correct, the only problem is that we do not need (want)
another READ_ONCE() if try_cmpxchg() fails.

>  void task_work_run(void)
>  {
>  	struct task_struct *task = current;
> -	struct callback_head *work, *head, *next;
> +	struct callback_head *work, *next;
>  
>  	for (;;) {
> -		/*
> -		 * work->func() can do task_work_add(), do not set
> -		 * work_exited unless the list is empty.
> -		 */
> -		do {
> -			head = NULL;
> -			work = READ_ONCE(task->task_works);
> -			if (!work) {
> -				if (task->flags & PF_EXITING)
> -					head = &work_exited;
> -				else
> -					break;
> -			}
> -		} while (cmpxchg(&task->task_works, work, head) != work);
> +		work = READ_ONCE(task->task_works);
> +		if (!work) {
> +			if (!(task->flags & PF_EXITING))
> +				return;
> +
> +			/*
> +			 * work->func() can do task_work_add(), do not set
> +			 * work_exited unless the list is empty.
> +			 */
> +			if (try_cmpxchg(&task->task_works, &work, &work_exited))
> +				return;
> +		}
> +
> +		work = xchg(&task->task_works, NULL);
> +		if (!work)
> +			continue;

looks correct...

Oleg.

