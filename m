Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 324E43D5E48
	for <lists+io-uring@lfdr.de>; Mon, 26 Jul 2021 17:47:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236291AbhGZPGr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 26 Jul 2021 11:06:47 -0400
Received: from mail.efficios.com ([167.114.26.124]:36870 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236181AbhGZPGO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 26 Jul 2021 11:06:14 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 7213B30774D;
        Mon, 26 Jul 2021 11:46:42 -0400 (EDT)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id rVkDnI2Le0ic; Mon, 26 Jul 2021 11:46:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id EC6453074C5;
        Mon, 26 Jul 2021 11:46:41 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com EC6453074C5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1627314401;
        bh=/cSIhdNpE9d/IJCbJVUKTogV0kkL1SnL8c9M41psFoo=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=eAFKB1MNv2tLnxWSxSEPcWMAWMF6Hn/lDqleDT/0HaWt/KarN0OZmBsoC0+x+adEl
         vQineGCzchUEo/De/T4OhQqIvgilIbFuc/oKJhHmuME4217/OjM8I9otQfCHQXhnb7
         mHMGPiOqT656D/T6LzN+U0s1PhITUMOFCX8EEhh2/KFFuvFuCGlDqg6nyiuRK2EzMS
         fv7Wir6gIwfwcE8cyEH6GF19a20qpLgXTqnENpazy34xQeQ3EwCuF1AvJTpJMAEdgv
         PVn+68gDM4HXOV/m+9mr0zPywI0ZJYwxCz+y7RRz00uu1USBAzTwRSKDyyJe+5RFoA
         N/RhnaTJaE4Tg==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id TSyN0HN6ElYE; Mon, 26 Jul 2021 11:46:41 -0400 (EDT)
Received: from mail03.efficios.com (mail03.efficios.com [167.114.26.124])
        by mail.efficios.com (Postfix) with ESMTP id DADC6307746;
        Mon, 26 Jul 2021 11:46:41 -0400 (EDT)
Date:   Mon, 26 Jul 2021 11:46:41 -0400 (EDT)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     rostedt <rostedt@goodmis.org>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        linux-trace-devel <linux-trace-devel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stefan Metzmacher <metze@samba.org>,
        io-uring <io-uring@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Message-ID: <715282075.6481.1627314401745.JavaMail.zimbra@efficios.com>
In-Reply-To: <20210722223320.53900ddc@rorschach.local.home>
References: <20210722223320.53900ddc@rorschach.local.home>
Subject: Re: [PATCH] tracepoints: Update static_call before tp_funcs when
 adding a tracepoint
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [167.114.26.124]
X-Mailer: Zimbra 8.8.15_GA_4059 (ZimbraWebClient - FF90 (Linux)/8.8.15_GA_4059)
Thread-Topic: tracepoints: Update static_call before tp_funcs when adding a tracepoint
Thread-Index: xLspdzF/fBstI2n/Tvg2L32lUgayvQ==
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

----- On Jul 22, 2021, at 10:33 PM, rostedt rostedt@goodmis.org wrote:

> From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
> 
> Because of the significant overhead that retpolines pose on indirect
> calls, the tracepoint code was updated to use the new "static_calls" that
> can modify the running code to directly call a function instead of using
> an indirect caller, and this function can be changed at runtime.
> 
> In the tracepoint code that calls all the registered callbacks that are
> attached to a tracepoint, the following is done:
> 
>	it_func_ptr = rcu_dereference_raw((&__tracepoint_##name)->funcs);
>	if (it_func_ptr) {
>		__data = (it_func_ptr)->data;
>		static_call(tp_func_##name)(__data, args);
>	}
> 
> If there's just a single callback, the static_call is updated to just call
> that callback directly. Once another handler is added, then the static
> caller is updated to call the iterator, that simply loops over all the
> funcs in the array and calls each of the callbacks like the old method
> using indirect calling.
> 
> The issue was discovered with a race between updating the funcs array and
> updating the static_call. The funcs array was updated first and then the
> static_call was updated. This is not an issue as long as the first element
> in the old array is the same as the first element in the new array. But
> that assumption is incorrect, because callbacks also have a priority
> field, and if there's a callback added that has a higher priority than the
> callback on the old array, then it will become the first callback in the
> new array. This means that it is possible to call the old callback with
> the new callback data element, which can cause a kernel panic.
> 

[...]

Looking into the various transitions, I suspect the issue runs much deeper than
this.

The sequence of transitions (number of probes) I'm considering is:

0->1
1->2
2->1
1->0
0->1
1->2

I come to three conclusions:

Where we have:

tracepoint_remove_func()

                tracepoint_update_call(tp, tp_funcs,
                                       tp_funcs[0].func != old[0].func);

We should be comparing .data rather than .func, because the same callback
can be registered twice with different data, and what we care about here
is that the data of array element 0 is unchanged to skip rcu sync.

My second conclusion is that it's odd that transition 1->0 leaves the
prior function call in place even after it's been removed. When we go
back to 0->1, that function call may still be called even though the
function is not there anymore. And there is no RCU synchronization on
these transitions, so those are all possible scenarios.

My third conclusion is that we'd need synchronize RCU whenever tp_funcs[0].data
changes for transitions 1->2, 2->1, and 1->2 because the priorities don't guarantee
that the first callback stays in the first position, and we also need to rcu sync
unconditionally on transition 1->0. We currently only have sync RCU on transition
from 2->1 when tp_funcs[0].func changes, which is bogus in many ways.

Basically, transitions from the iterator to a specific function should be handled
with care (making sure the tp_funcs array is updated and rcu-sync is done), except
in the specific case where the prior tp->funcs was NULL, which skips the function
call. And unless there is a rcu-sync between the state transitions, we need to consider
all prior states as additional original state as well. Therefore, in a 1->0->1
transition sequence, it's very much possible that the old function ends up observing
the new callback's data unless we add some rcu sync in between.

Thoughts ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
