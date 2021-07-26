Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 106B53D66E8
	for <lists+io-uring@lfdr.de>; Mon, 26 Jul 2021 20:49:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231250AbhGZSIi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 26 Jul 2021 14:08:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:54006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229489AbhGZSIi (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Mon, 26 Jul 2021 14:08:38 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F5AF60F5B;
        Mon, 26 Jul 2021 18:49:05 +0000 (UTC)
Date:   Mon, 26 Jul 2021 14:49:03 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        linux-trace-devel <linux-trace-devel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stefan Metzmacher <metze@samba.org>,
        io-uring <io-uring@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        paulmck <paulmck@kernel.org>
Subject: Re: [PATCH] tracepoints: Update static_call before tp_funcs when
 adding a tracepoint
Message-ID: <20210726144903.7736b9ad@oasis.local.home>
In-Reply-To: <682927571.6760.1627321158652.JavaMail.zimbra@efficios.com>
References: <20210722223320.53900ddc@rorschach.local.home>
        <715282075.6481.1627314401745.JavaMail.zimbra@efficios.com>
        <20210726125604.55bb6655@oasis.local.home>
        <682927571.6760.1627321158652.JavaMail.zimbra@efficios.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, 26 Jul 2021 13:39:18 -0400 (EDT)
Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:

> ----- On Jul 26, 2021, at 12:56 PM, rostedt rostedt@goodmis.org wrote:
> 
> > On Mon, 26 Jul 2021 11:46:41 -0400 (EDT)
> > Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:  
> [...]
> >   
> >> 
> >> My second conclusion is that it's odd that transition 1->0 leaves the
> >> prior function call in place even after it's been removed. When we go
> >> back to 0->1, that function call may still be called even though the
> >> function is not there anymore. And there is no RCU synchronization on
> >> these transitions, so those are all possible scenarios.  
> > 
> > How so? When doing this transition we have:
> > 
> >	tracepoint_update_call(tp, tp_funcs, false);
> >	rcu_assign_pointer(tp->funcs, tp_funcs);
> >	static_key_enable(&tp->key);
> > 
> > Where that tracepoint_update_call() will reinstall the iterator, and
> > that's a full memory barrier. It even sends IPIs to all other CPUs to
> > make sure all CPUs are synchronized before continuing.
> > 
> > By the time we get to static_key_enable(), there will not be any CPUs
> > that see the old function. And the process of updating a static_key
> > also does the same kind of synchronization.  
> 
> Actually, my explanation was inaccurate. The issue is that the _new_ callback
> may see the _old_ data.
> 
> Considering __DO_TRACE_CALL:
> 
>         do {                                                            \
>                 struct tracepoint_func *it_func_ptr;                    \
>                 void *__data;                                           \
>                 it_func_ptr =                                           \
>                         rcu_dereference_raw((&__tracepoint_##name)->funcs); \
>                 if (it_func_ptr) {                                      \
>                         __data = (it_func_ptr)->data;                   \
> 
> ----> [ delayed here on one CPU (e.g. vcpu preempted by the host) ]  
> 
>                         static_call(tp_func_##name)(__data, args);      \
>                 }                                                       \
>         } while (0)
> 
> It has loaded the tp->funcs of the old callback (so it will try to use the old
> data).
> 
> AFAIU, none of the synchronization mechanisms you refer to here (memory barrier,
> IPIs..) will change the fact that this CPU may still be delayed across the entire
> 1->0->1 transition sequence, and may end up calling the new callback with the
> old data. Unless an explicit RCU-sync is done.

OK. I see the issue you are saying. And this came from my assumption
that the tracepoint code did a synchronization when unregistering the
last callback. But of course it wont because that would make a lot of
back to back synchronizations of a large number of tracepoints being
unregistered at once.

And doing it for all 0->1 or 1->0 or even a 1->0->1 can be costly.

One way to handle this is when going from 1->0, set off a worker that
will do the synchronization asynchronously, and if a 0->1 comes in,
have that block until the synchronization is complete. This should
work, and not have too much of an overhead.

If one 1->0 starts the synchronization, and one or more 1->0
transitions happen, it will be recorded where the worker will do
another synchronization, to make sure all 1->0 have went through a full
synchronization before a 0->1 can happen.

If a 0->1 comes in while a synchronization is happening, it will note
the current "number" for the synchronizations (if another one is
queued, it will wait for one more), before it can begin. As locks will
be held while waiting for synchronizations to finish, we don't need to
worry about another 1->0 coming in while a 0->1 is waiting.

Shouldn't be too hard to implement.

static unsigned long sync_number;
static unsigned long last_sync_number;

Going from 1->0:

	/* tracepoint_mutex held */

	mutex_lock(&sync_mutex);
	sync_number++;
	mutex_unlock(&sync_mutex);
	queue_worker(sync_worker);


sync_worker()

  again:
	run = false;

	mutex_lock(&sync_mutex);
	if (last_sync_number != sync_number) {
		last_sync_number = sync_number;
		run = true;
	}
	mutex_unlock(&sync_mutex);

	if (!run)
		return;

	tracepoint_synchronization_unregister();

	wake_up(waiters);

	goto again;


Going from 0->1

 again:
	mutex_lock(&sync_mutex);
	if (last_sync_number != sync_number) {
		prepare_to_wait(waiters);
		block = true;
	}
	mutex_unlock(&sync_mutex);

	/* tracepoint_mutex held, sync_number will not increase */
	if (block) {
		schedule();
		/* in case we were woken up by an exiting worker */
		goto again;
	}
	
> 
> >   
> >> 
> >> My third conclusion is that we'd need synchronize RCU whenever tp_funcs[0].data
> >> changes for transitions 1->2, 2->1, and 1->2 because the priorities don't
> >> guarantee
> >> that the first callback stays in the first position, and we also need to rcu
> >> sync
> >> unconditionally on transition 1->0. We currently only have sync RCU on
> >> transition
> >> from 2->1 when tp_funcs[0].func changes, which is bogus in many ways.  
> > 
> > Going from 1 to 2, there's no issue. We switch to the iterator, which
> > is the old method anyway. It looks directly at the array and matches
> > the data with the func for each element of that array, and the data
> > read initially (before calling the iterator) is ignored.  
> 
> This relies on ordering guarantees between RCU assign/dereference and static_call
> updates/call. It may well be the case, but I'm asking anyway.
> 
> Are we guaranteed of the following ordering ?
> 
> CPU A                             CPU B
> 
>                                   static_call_update()

The static_call_update() triggers an IPI on all CPUs that perform a full memory barrier.

That is, nothing on any CPU will cross the static_call_update().

> y = rcu_dereference(x)            rcu_assign_pointer(x, ...)
> do_static_call(y)                 
> 
> That load of "x" should never happen after the CPU fetches the new static call
> instruction.

The 'y' will always be the new static call (which is the iterator in
this case), and it doesn't matter which x it read, because the iterator
will read the array just like it was done without static calls.

> 
> Also, I suspect that transition 2->1 needs an unconditional rcu-sync because you
> may have a sequence of 3->2->1 (or 1->2->1) where the element 0 data is unchanged
> between 2->1, but was changed from 3->2 (or from 1->2), which may be observed by the
> static call.


I'll agree that we need to add synchronization between 1->0->1, but you
have not convinced me on this second part.

-- Steve
