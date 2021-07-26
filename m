Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78C6E3D64FA
	for <lists+io-uring@lfdr.de>; Mon, 26 Jul 2021 18:59:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233591AbhGZQSJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 26 Jul 2021 12:18:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:50240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241919AbhGZQQr (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Mon, 26 Jul 2021 12:16:47 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8994260F5D;
        Mon, 26 Jul 2021 16:56:11 +0000 (UTC)
Date:   Mon, 26 Jul 2021 12:56:04 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        linux-trace-devel <linux-trace-devel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stefan Metzmacher <metze@samba.org>,
        io-uring <io-uring@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] tracepoints: Update static_call before tp_funcs when
 adding a tracepoint
Message-ID: <20210726125604.55bb6655@oasis.local.home>
In-Reply-To: <715282075.6481.1627314401745.JavaMail.zimbra@efficios.com>
References: <20210722223320.53900ddc@rorschach.local.home>
        <715282075.6481.1627314401745.JavaMail.zimbra@efficios.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, 26 Jul 2021 11:46:41 -0400 (EDT)
Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> 
> [...]
> 
> Looking into the various transitions, I suspect the issue runs much deeper than
> this.
> 
> The sequence of transitions (number of probes) I'm considering is:
> 
> 0->1
> 1->2
> 2->1
> 1->0
> 0->1
> 1->2
> 
> I come to three conclusions:
> 
> Where we have:
> 
> tracepoint_remove_func()
> 
>                 tracepoint_update_call(tp, tp_funcs,
>                                        tp_funcs[0].func != old[0].func);
> 
> We should be comparing .data rather than .func, because the same callback
> can be registered twice with different data, and what we care about here
> is that the data of array element 0 is unchanged to skip rcu sync.

I guess we could do that, as you are right, we are worried about
passing the wrong data to the wrong function. If the function is the
same, at least it wont crash the kernel as the function can handle that
data. But, it could miss the callback that is staying while calling the
one that is going instead.

Unlikely to happen, but in theory it is enough to fix.

> 
> My second conclusion is that it's odd that transition 1->0 leaves the
> prior function call in place even after it's been removed. When we go
> back to 0->1, that function call may still be called even though the
> function is not there anymore. And there is no RCU synchronization on
> these transitions, so those are all possible scenarios.

How so? When doing this transition we have:

	tracepoint_update_call(tp, tp_funcs, false);
	rcu_assign_pointer(tp->funcs, tp_funcs);
	static_key_enable(&tp->key);

Where that tracepoint_update_call() will reinstall the iterator, and
that's a full memory barrier. It even sends IPIs to all other CPUs to
make sure all CPUs are synchronized before continuing.

By the time we get to static_key_enable(), there will not be any CPUs
that see the old function. And the process of updating a static_key
also does the same kind of synchronization.

> 
> My third conclusion is that we'd need synchronize RCU whenever tp_funcs[0].data
> changes for transitions 1->2, 2->1, and 1->2 because the priorities don't guarantee
> that the first callback stays in the first position, and we also need to rcu sync
> unconditionally on transition 1->0. We currently only have sync RCU on transition
> from 2->1 when tp_funcs[0].func changes, which is bogus in many ways.

Going from 1 to 2, there's no issue. We switch to the iterator, which
is the old method anyway. It looks directly at the array and matches
the data with the func for each element of that array, and the data
read initially (before calling the iterator) is ignored.

> 
> Basically, transitions from the iterator to a specific function should be handled
> with care (making sure the tp_funcs array is updated and rcu-sync is done), except
> in the specific case where the prior tp->funcs was NULL, which skips the function
> call. And unless there is a rcu-sync between the state transitions, we need to consider
> all prior states as additional original state as well. Therefore, in a 1->0->1
> transition sequence, it's very much possible that the old function ends up observing
> the new callback's data unless we add some rcu sync in between.

I disagree with the last part, as I explained above.

But I do agree that comparing data is probably the better check.

-- Steve

> 
> Thoughts ?
> 
> Thanks,
> 
> Mathieu
> 

