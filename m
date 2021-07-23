Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4EAC3D3A5D
	for <lists+io-uring@lfdr.de>; Fri, 23 Jul 2021 14:41:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234845AbhGWMA4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 23 Jul 2021 08:00:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:60474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234601AbhGWMA4 (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Fri, 23 Jul 2021 08:00:56 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 726A060E53;
        Fri, 23 Jul 2021 12:41:29 +0000 (UTC)
Date:   Fri, 23 Jul 2021 08:41:22 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Stefan Metzmacher <metze@samba.org>
Cc:     Ingo Molnar <mingo@redhat.com>, linux-trace-devel@vger.kernel.org,
        io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: sched_waking vs. set_event_pid crash (Re: Tracing busy
 processes/threads freezes/stalls the whole machine)
Message-ID: <20210723084122.1ed6b27f@oasis.local.home>
In-Reply-To: <e3abc707-51d3-2543-f176-7641f916c53d@samba.org>
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
        <20210723072906.4f4e7bd5@gandalf.local.home>
        <e3abc707-51d3-2543-f176-7641f916c53d@samba.org>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, 23 Jul 2021 13:53:41 +0200
Stefan Metzmacher <metze@samba.org> wrote:

> Hi Steve,
> 
> >>> Assuming this does fix your issue, I sent out a real patch with the
> >>> explanation of what happened in the change log, so that you can see why
> >>> that change was your issue.    
> >>
> >> Yes, it does the trick, thanks very much!  
> > 
> > Can I get a "Tested-by" from you?  
> 
> Sure!

Thanks.

> 
> Can you check if the static_key_disable() and static_key_enable()
> calls are correctly ordered compared to rcu_assign_pointer()
> and explain why they are, as I not really understand that it's different
> from tracepoint_update_call vs. rcu_assign_pointer

The order doesn't even matter. I'm assuming you are talking about the
static_key_disable/enable with respect to enabling the tracepoint.

The reason it doesn't matter is because the rcu_assign_pointer is
updating an array of elements that hold both the function to call and
the data it needs. Inside the tracepoint loop where the callbacks are
called, in the iterator code (not the static call), you will see:

		it_func_ptr =						\
			rcu_dereference_raw((&__tracepoint_##_name)->funcs); \
		if (it_func_ptr) {					\
			do {						\
				it_func = READ_ONCE((it_func_ptr)->func); \
				__data = (it_func_ptr)->data;		\
				((void(*)(void *, proto))(it_func))(__data, args); \
			} while ((++it_func_ptr)->func);		\
		}

What that does is to get either the old array, or the new array and
places that array into it_func_ptr. Each element of this array contains
the callback (in .func) and the callback's data (in .data).

The enabling or disabling of the tracepoint doesn't really make a
difference with respect to the order of updating the funcs array.
That's because the users of this will either see the old array, the new
array, or NULL, in that it_func_ptr. This is how RCU works.

The bug we hit was because the static_call was updated separately from
the array. That makes it more imperative that you get the order
correct. As my email stated, with static_calls we have this:

		it_func_ptr =						\
			rcu_dereference_raw((&__tracepoint_##name)->funcs); \
		if (it_func_ptr) {					\
			__data = (it_func_ptr)->data;			\
			static_call(tp_func_##name)(__data, args);	\
		}

Where the issue is that the static_call which chooses which callback to
make, is updated asynchronously from the update of the array.

> 
> >> Now I can finally use:
> >>
> >> trace-cmd record -e all -P $(pidof io_uring-cp-forever)
> >>
> >> But that doesn't include the iou-wrk-* threads
> >> and the '-c' option seems to only work with forking.  
> > 
> > Have you tried it? It should work for threads as well. It hooks to the
> > sched_process_fork tracepoint, which should be triggered even when a new
> > thread is created.
> > 
> > Or do you mean that you want that process and all its threads too that are
> > already running? I could probably have it try to add it via the /proc file
> > system in that case.
> > 
> > Can you start the task via trace-cmd?
> > 
> >   trace-cmd record -e all -F -c io_uring-cp-forever ...  
> 
> I think that would work, but I typically want to analyze a process
> that is already running.
> 
> >> Is there a way to specify "trace *all* threads of the given pid"?
> >> (Note the threads are comming and going, so it's not possible to
> >> specifiy -P more than once)  
> > 
> > Right, although, you could append tasks manually to the set_event_pid file
> > from another terminal after starting trace-cmd. Once a pid is added to that
> > file, all children it makes will also be added. That could be a work around
> > until we have trace-cmd do it.  
> 
> Sure, but it will always be racy.

Not really. Matters what you mean by "racy". You wont be able to
"instantaneously" enable a process and all its threads, but you can
capture all of them after a given point. As you are attaching to a
process already running, you already missed events because you were not
yet tracing. But once you have a thread, you will always have it. 

> 
> With children, does new threads also count as children or only fork() children?

New threads. It's the kernel point of view of a task, which does not
differentiate processes from threads. Everything that can be scheduled
on a CPU is called a "task". How a task interacts with other tasks is
what defines it being a "thread" or a "process".

> 
> > Care to write a bugzilla report for this feature?
> > 
> >   https://bugzilla.kernel.org/buglist.cgi?component=Trace-cmd%2FKernelshark&list_id=1088173  
> 
> I may do later...
> 

Thanks,

-- Steve
