Return-Path: <io-uring+bounces-13264-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2PKULL6LAGodKAEAu9opvQ
	(envelope-from <io-uring+bounces-13264-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sun, 10 May 2026 15:44:30 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F5B250459B
	for <lists+io-uring@lfdr.de>; Sun, 10 May 2026 15:44:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 152AE302BE95
	for <lists+io-uring@lfdr.de>; Sun, 10 May 2026 13:41:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C054638F922;
	Sun, 10 May 2026 13:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ilw96TkY"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8454388E63
	for <io-uring@vger.kernel.org>; Sun, 10 May 2026 13:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778420492; cv=none; b=ZQNWA/fVHk/w4Y8xDjk/Elo7kQKWUUyW0OuBcODA1LTU4H0roqLHPgvyrWd4BbSKEb1PjlOyPIP7RBmMqL5C53M5ha4DLOOCBvtMpx8oG7hBeJY/IumS1lhHRKsUM0fwaTBB+WKJiTo/hSBqaHgaxvGWBi0LgnCw6fMmggNPgd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778420492; c=relaxed/simple;
	bh=AZr8rIQ1ubNmwJuBVike4Leb5tE6j84Hc44G5ztyCvs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oNYLryr2Xuw/ht5iLEJgJteMO1z7qsYuo/i8MAi/0fYHmWWKKWrFWZCg/v/3tI3PypjAMXMCKOIe0SO1bKD6b0B93v/RNFFWCTFDHoI9Rl48x8ndfQVp9W3eh69L1UraaU1pHoXMzj2WsHq2c5r5DmZU5GPtHVV7lG4uPHu5RxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--aliceryhl.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ilw96TkY; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aliceryhl.bounces.google.com
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-44d9ace59efso2311565f8f.1
        for <io-uring@vger.kernel.org>; Sun, 10 May 2026 06:41:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778420488; x=1779025288; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cmhcPqIDcr/VmaJfBaD4MTK3AqhVyijG/EOTeXKKd6g=;
        b=ilw96TkY58wtEsHIB37QSWOy3w3rEjsKJL7OTGeBgGYcsRcGpFaoIh0cDcZBofjEB/
         tb1YOUVxlGcltY0qH1oYZLnpIW1CS/h8yvfiyVrpDtT7aXgyBU0pd3/QtlxgeH/rFXfx
         9qgZjGpY4Ddva780ITP331YtgZ/3kZkCmn0hbC/a+Xu6X0dI2YcZYcFk4ii6h7482vKW
         zKiritBJOFRFQe6sf/c4/5CHFA/PdkP7y6cYXSTBjEWj6Gr6qLhos0+hIaRawKBp5rbX
         lVHNqCdG2FVmtNGh9auZbwang0Y5r7s601fwMvZZx42pVv0fRYeKqRN97uQvfJn9TquH
         z1Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778420488; x=1779025288;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cmhcPqIDcr/VmaJfBaD4MTK3AqhVyijG/EOTeXKKd6g=;
        b=Ve3oRVT3Lav2nR2G8CmM86KP8wUPNZsdgTu31l3wNXmID9QtY8MyO4zE1X1n7OOEWV
         /N5oEVqSih3UdApY6DrVHkB+aJ9gW60k5b4b7T+0/kTTZkYbLWj/9efi4h7pEuRGOIP/
         tNC3gRa/Mqv/Xep6RmSa6F0n5or5/BIooImXzzAPW83bFv3p1l7mEbqLpnUf6AC5Qs/B
         0Uk6G2mAx611AIlw6dhI+KPxAxvZS1li1FE8C3+bSzJPG9LhkHhyPPeZgFdl23p4skTV
         ZJPnCwa9qlY4qZEQ68mmlv5TrjXY/SNHbrZoaBkD9oNa4QdqnMqOz9DXQLTilp2CxDGs
         EVEA==
X-Forwarded-Encrypted: i=1; AFNElJ9kka4aNAoOqlfzpKfhdxd1OKpn4kId1lE2Kro9co/2j1oWzK4yhjlodX9KPAwKlWTuSH2ywCEz3g==@vger.kernel.org
X-Gm-Message-State: AOJu0YzGkZHoglXT/A0P59jdGE0Cv4k7QY5BswWvZM8dMkacJVMYZnCM
	aX+XYacTcVVVqWMfHM4EaJnyjeFv8xO934YTudMUd28m4FxCLfoiRvXkjz/taBcfvzw7fpzYzN/
	9Abj4CMX3jkHAcilh6A==
X-Received: from wmxb15-n2.prod.google.com ([2002:a05:600d:844f:20b0:486:fe68:2045])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:c091:b0:488:a977:8de with SMTP id 5b1f17b1804b1-48e706b264cmr73095925e9.16.1778420488316;
 Sun, 10 May 2026 06:41:28 -0700 (PDT)
Date: Sun, 10 May 2026 13:41:27 +0000
In-Reply-To: <af5XymUlyE0Jsi2t@gpd4>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260508-put-task-struct-many-v1-1-8341c18141a6@google.com> <af5XymUlyE0Jsi2t@gpd4>
Message-ID: <agCLBxHEUqWIepx8@google.com>
Subject: Re: [PATCH] sched/task: always defer 'struct task_struct' destruction
 via RCU
From: Alice Ryhl <aliceryhl@google.com>
To: Andrea Righi <arighi@nvidia.com>
Cc: "Paul E. McKenney" <paulmck@kernel.org>, Boqun Feng <boqun@kernel.org>, 
	Changwoo Min <changwoo@igalia.com>, Clark Williams <clrkwllms@kernel.org>, 
	David Vernet <void@manifault.com>, Frederic Weisbecker <frederic@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Jens Axboe <axboe@kernel.dk>, Joel Fernandes <joelagnelf@nvidia.com>, 
	Josh Triplett <josh@joshtriplett.org>, Lai Jiangshan <jiangshanlai@gmail.com>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Steven Rostedt <rostedt@goodmis.org>, Tejun Heo <tj@kernel.org>, 
	Uladzislau Rezki <urezki@gmail.com>, Zqiang <qiang.zhang@linux.dev>, io-uring@vger.kernel.org, 
	rcu@vger.kernel.org, sched-ext@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: 4F5B250459B
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13264-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[kernel.org,igalia.com,manifault.com,redhat.com,kernel.dk,nvidia.com,joshtriplett.org,gmail.com,efficios.com,infradead.org,linutronix.de,goodmis.org,linux.dev,vger.kernel.org,lists.linux.dev];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[25];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[aliceryhl@google.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Action: no action

On Fri, May 08, 2026 at 11:38:18PM +0200, Andrea Righi wrote:
> Hi Alice,
> 
> On Fri, May 08, 2026 at 02:02:45PM +0000, Alice Ryhl wrote:
> > The sched/task.h header file currently exposes a tryget_task_struct()
> > function, but it is very risky to use it: If the last refcount of the
> > task is dropped using put_task_struct_many(), then the task is freed
> > right away without an RCU grace period.
> > 
> > This means that if the kernel contains a code path anywhere such that
> > the last refcount of a task may be dropped with put_task_struct_many(),
> > and it also contains a code path anywhere that tries to stash a task
> > pointer under rcu and use tryget_task_struct() on it, then if they ever
> > execute on the same 'struct task_struct', it results in a
> > use-after-free.
> > 
> > The above applies even if the RCU user drops its own task reference with
> > put_task_struct(), because if that is not the last reference, then it's
> > possible for another thread to invoke put_task_struct_many() and free
> > the task less than a grace period after the RCU user called
> > put_task_struct().
> > 
> > There does not appear to be an actual problem in the kernel tree right
> > now because there are no in-tree users of put_task_struct_many() where
> > refcount_sub_and_test() might return 'true'. Io-uring invokes the
> > function from task work while the task is still running, so it will not
> > decrement it all the way to zero. (Note that if I'm wrong about this,
> > then it's probably possible to trigger UAF by combining this codepath in
> > io-uring with the tryget_task_struct() call in sched-ext.)
> > 
> > However, the current situation is fragile and error-prone.
> > - If you look at put_task_struct_many() in isolation, it looks like it
> >   would be okay to call it in a situation where refcount_sub_and_test()
> >   might return 'true'.
> > - Similarly, if you look at tryget_task_struct(), you would assume that
> >   you are allowed to call this method for a grace period after 'users'
> >   hitting zero. (If not, why does it exist?)
> > But if two different kernel developers anywhere in the kernel make these
> > conflicting assumptions at any point in the future, then the combination
> > of their code may lead to a use-after-free if there is any way for them
> > to interact via the same 'struct task_struct'.
> > 
> > Thus, as a defensive measure, we should either make
> > put_task_struct_many() use call_rcu(), or we should delete
> > tryget_task_struct(). This patch suggests the former because it does not
> > change anything for any callers that exist today. (As argued previously,
> > the body of the 'if' statement is dead code in the kernel today.)
> > 
> > The comment in put_task_struct() is also updated so that nobody changes
> > its implementation to only use call_rcu() under PREEMPT_RT in the
> > future. The current comment suggests that would be a legal change, but
> > it is similarly incompatible with anyone using tryget_task_struct().
> > 
> > Signed-off-by: Alice Ryhl <aliceryhl@google.com>
> > ---
> > Including sched-ext and io-uring in the cc list as they are the only
> > users of tryget_task_struct() and put_task_struct_many() respectively.
> 
> For sched_ext I think we should be already protected by scx_tasks_lock.
> 
> From kernel/sched/core.c:
> 
>   finish_task_switch():
>       if (prev_state == TASK_DEAD) {
>           prev->sched_class->task_dead(prev);
>           sched_ext_dead(prev);
>           cgroup_task_dead(prev);
>           put_task_stack(prev);
>           ...
>           put_task_struct_rcu_user(prev);
>       }
> 
>  And sched_ext_dead() in kernel/sched/ext.c:
> 
>   scoped_guard(raw_spinlock_irqsave, &scx_tasks_lock) {
>       list_del_init(&p->scx.tasks_node);
>       ...
>   }
> 
> Now on the sched_ext iter side:
> 
>   scx_task_iter_start();                     /* takes scx_tasks_lock */
>   while ((p = scx_task_iter_next_locked()))
>       if (!tryget_task_struct(p))            /* still under scx_tasks_lock */
>          ...
> 
> So, the locking gives us the invariant: while the iter holds scx_tasks_lock and
> observes p on the list, sched_ext_dead(p) cannot have completed.

Correct my if I'm wrong, but this sounds like you don't need the tryget
variant. The 'users' counter is guaranteed be non-zero for one grace
period after put_task_struct_rcu_user(prev).

Alice

> And the css_task_iter paths have the analogous ordering.
> 
> That said, I think this patch still makes sense to provide a consistent
> semantics between put_task_struct() and put_task_struct_many(), as mentioned by
> Sebastian. So, maybe reword the message around consistency rather than UAF?
> 
> Thanks,
> -Andrea
> 
> > ---
> >  include/linux/sched/task.h | 24 +++++++++++++++---------
> >  1 file changed, 15 insertions(+), 9 deletions(-)
> > 
> > diff --git a/include/linux/sched/task.h b/include/linux/sched/task.h
> > index 41ed884cffc9..da2fbd17b676 100644
> > --- a/include/linux/sched/task.h
> > +++ b/include/linux/sched/task.h
> > @@ -131,19 +131,25 @@ static inline void put_task_struct(struct task_struct *t)
> >  		return;
> >  
> >  	/*
> > -	 * Under PREEMPT_RT, we can't call __put_task_struct
> > -	 * in atomic context because it will indirectly
> > -	 * acquire sleeping locks. The same is true if the
> > -	 * current process has a mutex enqueued (blocked on
> > -	 * a PI chain).
> > +	 * Delay __put_task_struct() for one grace period so
> > +	 * that tryget_task_struct() may be used for one
> > +	 * grace period after any call to put_task_struct().
> >  	 *
> > -	 * In !RT, it is always safe to call __put_task_struct().
> > -	 * Though, in order to simplify the code, resort to the
> > -	 * deferred call too.
> > +	 * This also has the benefit of making it legal to
> > +	 * call put_task_struct() in atomic context. We
> > +	 * can't do that under PREEMPT_RT because it will
> > +	 * indirectly acquire sleeping locks. The same is
> > +	 * true if the current process has a mutex enqueued
> > +	 * (blocked on a PI chain).
> >  	 *
> >  	 * call_rcu() will schedule __put_task_struct_rcu_cb()
> >  	 * to be called in process context.
> >  	 *
> > +	 * In !RT, it is safe to call __put_task_struct()
> > +	 * from atomic context, but we still need to delay
> > +	 * cleanup for a grace period to accommodate
> > +	 * tryget_task_struct() callers.
> > +	 *
> >  	 * __put_task_struct() is called when
> >  	 * refcount_dec_and_test(&t->usage) succeeds.
> >  	 *
> > @@ -164,7 +170,7 @@ DEFINE_FREE(put_task, struct task_struct *, if (_T) put_task_struct(_T))
> >  static inline void put_task_struct_many(struct task_struct *t, int nr)
> >  {
> >  	if (refcount_sub_and_test(nr, &t->usage))
> > -		__put_task_struct(t);
> > +		call_rcu(&t->rcu, __put_task_struct_rcu_cb);
> >  }
> >  
> >  void put_task_struct_rcu_user(struct task_struct *task);
> > 
> > ---
> > base-commit: 7fd2df204f342fc17d1a0bfcd474b24232fb0f32
> > change-id: 20260508-put-task-struct-many-5b5b2f4ae174
> > 
> > Best regards,
> > -- 
> > Alice Ryhl <aliceryhl@google.com>
> > 

