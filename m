Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB5C03D397B
	for <lists+io-uring@lfdr.de>; Fri, 23 Jul 2021 13:29:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233315AbhGWKsy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 23 Jul 2021 06:48:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:35810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231703AbhGWKsx (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Fri, 23 Jul 2021 06:48:53 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6BF4D60E75;
        Fri, 23 Jul 2021 11:29:24 +0000 (UTC)
Date:   Fri, 23 Jul 2021 07:29:06 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Stefan Metzmacher <metze@samba.org>
Cc:     Ingo Molnar <mingo@redhat.com>, linux-trace-devel@vger.kernel.org,
        io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: sched_waking vs. set_event_pid crash (Re: Tracing busy
 processes/threads freezes/stalls the whole machine)
Message-ID: <20210723072906.4f4e7bd5@gandalf.local.home>
In-Reply-To: <d803b3a6-b8cd-afe1-4f85-e5301bcb793a@samba.org>
References: <293cfb1d-8a53-21e1-83c1-cdb6e2f32c65@samba.org>
        <20210504092404.6b12aba4@gandalf.local.home>
        <f590b26d-c027-cc5a-bcbd-1dc734f72e7e@samba.org>
        <20210504093550.5719d4bd@gandalf.local.home>
        <f351bdfa-5223-e457-0396-a24ffa09d6b5@samba.org>
        <8bb757fb-a83b-0ed5-5247-8273be3925c5@samba.org>
        <90c806a0-8a2f-1257-7337-6761100217c9@samba.org>
        <4ebea8f0-58c9-e571-fd30-0ce4f6f09c70@samba.org>
        <20210722225124.6d7d7153@rorschach.local.home>
        <d803b3a6-b8cd-afe1-4f85-e5301bcb793a@samba.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, 23 Jul 2021 12:35:09 +0200
Stefan Metzmacher <metze@samba.org> wrote:

> > Assuming this does fix your issue, I sent out a real patch with the
> > explanation of what happened in the change log, so that you can see why
> > that change was your issue.  
> 
> Yes, it does the trick, thanks very much!

Can I get a "Tested-by" from you?

> Now I can finally use:
> 
> trace-cmd record -e all -P $(pidof io_uring-cp-forever)
> 
> But that doesn't include the iou-wrk-* threads
> and the '-c' option seems to only work with forking.

Have you tried it? It should work for threads as well. It hooks to the
sched_process_fork tracepoint, which should be triggered even when a new
thread is created.

Or do you mean that you want that process and all its threads too that are
already running? I could probably have it try to add it via the /proc file
system in that case.

Can you start the task via trace-cmd?

  trace-cmd record -e all -F -c io_uring-cp-forever ...


> 
> Is there a way to specify "trace *all* threads of the given pid"?
> (Note the threads are comming and going, so it's not possible to
> specifiy -P more than once)

Right, although, you could append tasks manually to the set_event_pid file
from another terminal after starting trace-cmd. Once a pid is added to that
file, all children it makes will also be added. That could be a work around
until we have trace-cmd do it.

Care to write a bugzilla report for this feature?

  https://bugzilla.kernel.org/buglist.cgi?component=Trace-cmd%2FKernelshark&list_id=1088173

-- Steve
