Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FF693D315C
	for <lists+io-uring@lfdr.de>; Fri, 23 Jul 2021 03:41:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232892AbhGWBBC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 22 Jul 2021 21:01:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:57344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230318AbhGWBBC (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Thu, 22 Jul 2021 21:01:02 -0400
Received: from rorschach.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 11B8060E9A;
        Fri, 23 Jul 2021 01:41:35 +0000 (UTC)
Date:   Thu, 22 Jul 2021 21:41:34 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Stefan Metzmacher <metze@samba.org>
Cc:     Ingo Molnar <mingo@redhat.com>, linux-trace-devel@vger.kernel.org,
        io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: sched_waking vs. set_event_pid crash (Re: Tracing busy
 processes/threads freezes/stalls the whole machine)
Message-ID: <20210722214134.11bc2a6d@rorschach.local.home>
In-Reply-To: <4ebea8f0-58c9-e571-fd30-0ce4f6f09c70@samba.org>
References: <293cfb1d-8a53-21e1-83c1-cdb6e2f32c65@samba.org>
        <20210504092404.6b12aba4@gandalf.local.home>
        <f590b26d-c027-cc5a-bcbd-1dc734f72e7e@samba.org>
        <20210504093550.5719d4bd@gandalf.local.home>
        <f351bdfa-5223-e457-0396-a24ffa09d6b5@samba.org>
        <8bb757fb-a83b-0ed5-5247-8273be3925c5@samba.org>
        <90c806a0-8a2f-1257-7337-6761100217c9@samba.org>
        <4ebea8f0-58c9-e571-fd30-0ce4f6f09c70@samba.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, 23 Jul 2021 00:43:13 +0200
Stefan Metzmacher <metze@samba.org> wrote:

> Hi Steve,

Hi Stefan,

> 
> After some days of training:
> https://training.linuxfoundation.org/training/linux-kernel-debugging-and-security/
> I was able to get much closer to the problem :-)
> 
> In order to reproduce it and get reliable kexec crash dumps,
> I needed to give the VM at least 3 cores.
> 
> While running './io-uring_cp-forever link-cp.c file' (from:
> https://github.com/metze-samba/liburing/commits/io_uring-cp-forever )
> in one window, the following simple sequence triggered the problem in most cases:
> 
> echo 1 > /sys/kernel/tracing/events/sched/sched_waking/enable
> echo 1 > /sys/kernel/tracing/set_event_pid

I was able to reproduce it with running hackbench in a while loop and
in another terminal, executing the above two lines.

I think I found the bug. Can you test this patch?

Thanks,

-- Steve

diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index 976bf8ce8039..fc32821f8240 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -299,8 +299,8 @@ static int tracepoint_add_func(struct tracepoint *tp,
 	 * a pointer to it.  This array is referenced by __DO_TRACE from
 	 * include/linux/tracepoint.h using rcu_dereference_sched().
 	 */
-	rcu_assign_pointer(tp->funcs, tp_funcs);
 	tracepoint_update_call(tp, tp_funcs, false);
+	rcu_assign_pointer(tp->funcs, tp_funcs);
 	static_key_enable(&tp->key);
 
 	release_probes(old);
