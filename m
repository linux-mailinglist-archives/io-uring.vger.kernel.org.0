Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6CCC3D65E1
	for <lists+io-uring@lfdr.de>; Mon, 26 Jul 2021 19:39:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231727AbhGZQ6w (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 26 Jul 2021 12:58:52 -0400
Received: from mail.efficios.com ([167.114.26.124]:48570 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232631AbhGZQ6v (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 26 Jul 2021 12:58:51 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 6C59F30803A;
        Mon, 26 Jul 2021 13:39:19 -0400 (EDT)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id q-9tp644Uuus; Mon, 26 Jul 2021 13:39:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id D82A13384B6;
        Mon, 26 Jul 2021 13:39:18 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com D82A13384B6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1627321158;
        bh=gd9CjvBnkyrHwjvM+DTZ+r2zj0/ngHmCKr3D2UF0nIY=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=MDIgrcDCG4jL285bWF0y12/yu+sjl03ij4SHGf+FTqJD6+iiBSfNBLtkD54NHDvN2
         /Tsm62rb8d+R/3vtAwlR3sSmT9cj8eYqcccKQUmghsO5mRL0sCE67cEM3R/1AJ/fj6
         PTaj8ltrr3WLJp2QmJ7QrsC1VzD/Emqu6hkk9Cu9BnJVQ0wPpdZxWNFMi+4Yd/24Xl
         M6Z0K8BFW7mwg/foHKCS7ZPmvtSxZD+1wMefxbpDhKLW8KWLiQMrcWoS6DdxHFVR2X
         6PR5Vao70xWyLvn9f4aPM32CwyIjQs/DFOXZ40Nn8t8gsZUWIEOcF+yziEigD4TTDB
         oOHQlJURcs92g==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id gARNofEw88Ep; Mon, 26 Jul 2021 13:39:18 -0400 (EDT)
Received: from mail03.efficios.com (mail03.efficios.com [167.114.26.124])
        by mail.efficios.com (Postfix) with ESMTP id C6C233384B5;
        Mon, 26 Jul 2021 13:39:18 -0400 (EDT)
Date:   Mon, 26 Jul 2021 13:39:18 -0400 (EDT)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     rostedt <rostedt@goodmis.org>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        linux-trace-devel <linux-trace-devel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stefan Metzmacher <metze@samba.org>,
        io-uring <io-uring@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        paulmck <paulmck@kernel.org>
Message-ID: <682927571.6760.1627321158652.JavaMail.zimbra@efficios.com>
In-Reply-To: <20210726125604.55bb6655@oasis.local.home>
References: <20210722223320.53900ddc@rorschach.local.home> <715282075.6481.1627314401745.JavaMail.zimbra@efficios.com> <20210726125604.55bb6655@oasis.local.home>
Subject: Re: [PATCH] tracepoints: Update static_call before tp_funcs when
 adding a tracepoint
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [167.114.26.124]
X-Mailer: Zimbra 8.8.15_GA_4059 (ZimbraWebClient - FF90 (Linux)/8.8.15_GA_4059)
Thread-Topic: tracepoints: Update static_call before tp_funcs when adding a tracepoint
Thread-Index: ZSqsplsYKjUcEmoRQTVLJV+sHGtb3Q==
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

----- On Jul 26, 2021, at 12:56 PM, rostedt rostedt@goodmis.org wrote:

> On Mon, 26 Jul 2021 11:46:41 -0400 (EDT)
> Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
[...]
> 
>> 
>> My second conclusion is that it's odd that transition 1->0 leaves the
>> prior function call in place even after it's been removed. When we go
>> back to 0->1, that function call may still be called even though the
>> function is not there anymore. And there is no RCU synchronization on
>> these transitions, so those are all possible scenarios.
> 
> How so? When doing this transition we have:
> 
>	tracepoint_update_call(tp, tp_funcs, false);
>	rcu_assign_pointer(tp->funcs, tp_funcs);
>	static_key_enable(&tp->key);
> 
> Where that tracepoint_update_call() will reinstall the iterator, and
> that's a full memory barrier. It even sends IPIs to all other CPUs to
> make sure all CPUs are synchronized before continuing.
> 
> By the time we get to static_key_enable(), there will not be any CPUs
> that see the old function. And the process of updating a static_key
> also does the same kind of synchronization.

Actually, my explanation was inaccurate. The issue is that the _new_ callback
may see the _old_ data.

Considering __DO_TRACE_CALL:

        do {                                                            \
                struct tracepoint_func *it_func_ptr;                    \
                void *__data;                                           \
                it_func_ptr =                                           \
                        rcu_dereference_raw((&__tracepoint_##name)->funcs); \
                if (it_func_ptr) {                                      \
                        __data = (it_func_ptr)->data;                   \

----> [ delayed here on one CPU (e.g. vcpu preempted by the host) ]

                        static_call(tp_func_##name)(__data, args);      \
                }                                                       \
        } while (0)

It has loaded the tp->funcs of the old callback (so it will try to use the old
data).

AFAIU, none of the synchronization mechanisms you refer to here (memory barrier,
IPIs..) will change the fact that this CPU may still be delayed across the entire
1->0->1 transition sequence, and may end up calling the new callback with the
old data. Unless an explicit RCU-sync is done.

> 
>> 
>> My third conclusion is that we'd need synchronize RCU whenever tp_funcs[0].data
>> changes for transitions 1->2, 2->1, and 1->2 because the priorities don't
>> guarantee
>> that the first callback stays in the first position, and we also need to rcu
>> sync
>> unconditionally on transition 1->0. We currently only have sync RCU on
>> transition
>> from 2->1 when tp_funcs[0].func changes, which is bogus in many ways.
> 
> Going from 1 to 2, there's no issue. We switch to the iterator, which
> is the old method anyway. It looks directly at the array and matches
> the data with the func for each element of that array, and the data
> read initially (before calling the iterator) is ignored.

This relies on ordering guarantees between RCU assign/dereference and static_call
updates/call. It may well be the case, but I'm asking anyway.

Are we guaranteed of the following ordering ?

CPU A                             CPU B

                                  static_call_update()
y = rcu_dereference(x)            rcu_assign_pointer(x, ...)
do_static_call(y)                 

That load of "x" should never happen after the CPU fetches the new static call
instruction.

Also, I suspect that transition 2->1 needs an unconditional rcu-sync because you
may have a sequence of 3->2->1 (or 1->2->1) where the element 0 data is unchanged
between 2->1, but was changed from 3->2 (or from 1->2), which may be observed by the
static call.

Thanks,

Mathieu

> 
>> 
>> Basically, transitions from the iterator to a specific function should be
>> handled
>> with care (making sure the tp_funcs array is updated and rcu-sync is done),
>> except
>> in the specific case where the prior tp->funcs was NULL, which skips the
>> function
>> call. And unless there is a rcu-sync between the state transitions, we need to
>> consider
>> all prior states as additional original state as well. Therefore, in a 1->0->1
>> transition sequence, it's very much possible that the old function ends up
>> observing
>> the new callback's data unless we add some rcu sync in between.
> 
> I disagree with the last part, as I explained above.
> 
> But I do agree that comparing data is probably the better check.
> 
> -- Steve
> 
>> 
>> Thoughts ?
>> 
>> Thanks,
>> 
>> Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
