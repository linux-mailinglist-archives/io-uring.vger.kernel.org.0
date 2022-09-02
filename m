Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97EB95AA441
	for <lists+io-uring@lfdr.de>; Fri,  2 Sep 2022 02:22:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232086AbiIBAWx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Sep 2022 20:22:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230091AbiIBAWv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Sep 2022 20:22:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53D026F260;
        Thu,  1 Sep 2022 17:22:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D5F40B82966;
        Fri,  2 Sep 2022 00:22:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C920C433D6;
        Fri,  2 Sep 2022 00:22:40 +0000 (UTC)
Date:   Thu, 1 Sep 2022 20:23:11 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org,
        mhocko@suse.com, vbabka@suse.cz, hannes@cmpxchg.org,
        roman.gushchin@linux.dev, mgorman@suse.de, dave@stgolabs.net,
        willy@infradead.org, liam.howlett@oracle.com, void@manifault.com,
        peterz@infradead.org, juri.lelli@redhat.com, ldufour@linux.ibm.com,
        peterx@redhat.com, david@redhat.com, axboe@kernel.dk,
        mcgrof@kernel.org, masahiroy@kernel.org, nathan@kernel.org,
        changbin.du@intel.com, ytcoode@gmail.com,
        vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
        bsegall@google.com, bristot@redhat.com, vschneid@redhat.com,
        cl@linux.com, penberg@kernel.org, iamjoonsoo.kim@lge.com,
        42.hyeyoo@gmail.com, glider@google.com, elver@google.com,
        dvyukov@google.com, shakeelb@google.com, songmuchun@bytedance.com,
        arnd@arndb.de, jbaron@akamai.com, rientjes@google.com,
        minchan@google.com, kaleshsingh@google.com,
        kernel-team@android.com, linux-mm@kvack.org, iommu@lists.linux.dev,
        kasan-dev@googlegroups.com, io-uring@vger.kernel.org,
        linux-arch@vger.kernel.org, xen-devel@lists.xenproject.org,
        linux-bcache@vger.kernel.org, linux-modules@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 27/30] Code tagging based latency tracking
Message-ID: <20220901202311.546a53b5@gandalf.local.home>
In-Reply-To: <20220901225515.ogg7pyljmfzezamr@moria.home.lan>
References: <20220830214919.53220-1-surenb@google.com>
        <20220830214919.53220-28-surenb@google.com>
        <20220901173844.36e1683c@gandalf.local.home>
        <20220901215438.gy3bgqa4ghhm6ztm@moria.home.lan>
        <20220901183430.120311ce@gandalf.local.home>
        <20220901225515.ogg7pyljmfzezamr@moria.home.lan>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, 1 Sep 2022 18:55:15 -0400
Kent Overstreet <kent.overstreet@linux.dev> wrote:

> On Thu, Sep 01, 2022 at 06:34:30PM -0400, Steven Rostedt wrote:
> > On Thu, 1 Sep 2022 17:54:38 -0400
> > Kent Overstreet <kent.overstreet@linux.dev> wrote:  
> > > 
> > > So this looks like it's gotten better since I last looked, but it's still not
> > > there yet.
> > > 
> > > Part of the problem is that the tracepoints themselves are in the wrong place:
> > > your end event is when a task is woken up, but that means spurious wakeups will  
> > 
> > The end event is when a task is scheduled onto the CPU. The start event is
> > the first time it is woken up.  
> 
> Yeah, that's not what I want. You're just tracing latency due to having more
> processes runnable than CPUs.
> 
> I don't care about that for debugging, though! I specifically want latency at
> the wait_event() level, and related - every time a process blocked _on some
> condition_, until that condition became true. Not until some random, potentially
> spurious wakeup.

Ideally this would be better if we could pass the stack trace from one
event to the next, but that wouldn't be too hard to implement. It just
needs to be done.

But anyway:

 # echo 'p:wait prepare_to_wait_event' > /sys/kernel/tracing/kprobe_events

// created an event on prepare_to_wait_event as that's usually called just
// before wait event.

 # sqlhist -e -n wait_sched 'select start.common_pid as pid,(end.TIMESTAMP_USECS - start.TIMESTAMP_USECS) as delta from wait as start join sched_switch as end on start.common_pid = end.prev_pid where end.prev_state & 3'

// Create a "wait_sched" event that traces the time between the
// prepare_to_wait_event call and the scheduler. Only trigger it if the
// schedule happens in the interruptible or uninterruptible states.

 # sqlhist -e -n wake_sched 'select start.pid,(end.TIMESTAMP_USECS - start.TIMESTAMP_USECS) as delta2 from wait_sched as start join sched_switch as end on start.pid = end.next_pid where start.delta < 50'

// Now attach the wait_event to the sched_switch where the task gets
// scheduled back in. But we are only going to care if the delta between
// the prepare_to_wait_event and the schedule is less that 50us. This is a
// hack to just care about where a prepare_to_wait_event was done just before
// scheduling out.

 # echo 'hist:keys=pid,delta2.buckets=10:sort=delta2' > /sys/kernel/tracing/events/synthetic/wake_sched/trigger

// Now we are going to look at the deltas that the task was sleeping for an
// event. But this just gives pids and deltas.

 # echo 'hist:keys=pid,stacktrace if delta < 50' >> /sys/kernel/tracing/events/synthetic/wait_sched/trigger

// And this is to get the backtraces of where the task was. This is because
// the stack trace is not available at the schedule in, because the
// sched_switch can only give the stack trace of when a task schedules out.
// Again, this is somewhat a hack.

 # cat /sys/kernel/tracing/events/synthetic/wake_sched/hist
# event histogram
#
# trigger info: hist:keys=pid,delta2.buckets=10:vals=hitcount:sort=delta2.buckets=10:size=2048 [active]
#

{ pid:       2114, delta2: ~ 10-19 } hitcount:          1
{ pid:       1389, delta2: ~ 160-169 } hitcount:          1
{ pid:       1389, delta2: ~ 660-669 } hitcount:          1
{ pid:       1389, delta2: ~ 1020-1029 } hitcount:          1
{ pid:       1189, delta2: ~ 500020-500029 } hitcount:          1
{ pid:       1189, delta2: ~ 500030-500039 } hitcount:          1
{ pid:       1195, delta2: ~ 500030-500039 } hitcount:          2
{ pid:       1189, delta2: ~ 500040-500049 } hitcount:         10
{ pid:       1193, delta2: ~ 500040-500049 } hitcount:          3
{ pid:       1197, delta2: ~ 500040-500049 } hitcount:          3
{ pid:       1195, delta2: ~ 500040-500049 } hitcount:          9
{ pid:       1190, delta2: ~ 500050-500059 } hitcount:         55
{ pid:       1197, delta2: ~ 500050-500059 } hitcount:         51
{ pid:       1191, delta2: ~ 500050-500059 } hitcount:         61
{ pid:       1198, delta2: ~ 500050-500059 } hitcount:         56
{ pid:       1195, delta2: ~ 500050-500059 } hitcount:         48
{ pid:       1192, delta2: ~ 500050-500059 } hitcount:         54
{ pid:       1194, delta2: ~ 500050-500059 } hitcount:         50
{ pid:       1196, delta2: ~ 500050-500059 } hitcount:         57
{ pid:       1189, delta2: ~ 500050-500059 } hitcount:         48
{ pid:       1193, delta2: ~ 500050-500059 } hitcount:         52
{ pid:       1194, delta2: ~ 500060-500069 } hitcount:         12
{ pid:       1191, delta2: ~ 500060-500069 } hitcount:          2
{ pid:       1190, delta2: ~ 500060-500069 } hitcount:          7
{ pid:       1198, delta2: ~ 500060-500069 } hitcount:          9
{ pid:       1193, delta2: ~ 500060-500069 } hitcount:          6
{ pid:       1196, delta2: ~ 500060-500069 } hitcount:          5
{ pid:       1192, delta2: ~ 500060-500069 } hitcount:          9
{ pid:       1197, delta2: ~ 500060-500069 } hitcount:          9
{ pid:       1195, delta2: ~ 500060-500069 } hitcount:          6
{ pid:       1189, delta2: ~ 500060-500069 } hitcount:          6
{ pid:       1198, delta2: ~ 500070-500079 } hitcount:          1
{ pid:       1192, delta2: ~ 500070-500079 } hitcount:          2
{ pid:       1193, delta2: ~ 500070-500079 } hitcount:          3
{ pid:       1194, delta2: ~ 500070-500079 } hitcount:          2
{ pid:       1191, delta2: ~ 500070-500079 } hitcount:          3
{ pid:       1190, delta2: ~ 500070-500079 } hitcount:          1
{ pid:       1196, delta2: ~ 500070-500079 } hitcount:          1
{ pid:       1193, delta2: ~ 500080-500089 } hitcount:          1
{ pid:       1192, delta2: ~ 500080-500089 } hitcount:          1
{ pid:       1196, delta2: ~ 500080-500089 } hitcount:          2
{ pid:       1194, delta2: ~ 500090-500099 } hitcount:          1
{ pid:       1197, delta2: ~ 500090-500099 } hitcount:          1
{ pid:       1193, delta2: ~ 500090-500099 } hitcount:          1
{ pid:         61, delta2: ~ 503910-503919 } hitcount:          1
{ pid:         61, delta2: ~ 503920-503929 } hitcount:          1
{ pid:         61, delta2: ~ 503930-503939 } hitcount:          1
{ pid:         61, delta2: ~ 503960-503969 } hitcount:         15
{ pid:         61, delta2: ~ 503970-503979 } hitcount:         18
{ pid:         61, delta2: ~ 503980-503989 } hitcount:         20
{ pid:         61, delta2: ~ 504010-504019 } hitcount:          2
{ pid:         61, delta2: ~ 504020-504029 } hitcount:          1
{ pid:         61, delta2: ~ 504030-504039 } hitcount:          2
{ pid:         58, delta2: ~ 43409960-43409969 } hitcount:          1

Totals:
    Hits: 718
    Entries: 54
    Dropped: 0

The above is useless without the following:

# cat /sys/kernel/tracing/events/synthetic/wait_sched/hist 
# event histogram
#
# trigger info: hist:keys=pid:vals=hitcount:__arg_1618_2=pid,__arg_1618_3=common_timestamp.usecs:sort=hitcount:size=2048:clock=global if delta < 10 [active]
#

{ pid:        612 } hitcount:          1
{ pid:        889 } hitcount:          2
{ pid:       1389 } hitcount:          3
{ pid:         58 } hitcount:          3
{ pid:       2096 } hitcount:          5
{ pid:         61 } hitcount:        145
{ pid:       1196 } hitcount:        151
{ pid:       1190 } hitcount:        151
{ pid:       1198 } hitcount:        153
{ pid:       1197 } hitcount:        153
{ pid:       1195 } hitcount:        153
{ pid:       1194 } hitcount:        153
{ pid:       1191 } hitcount:        153
{ pid:       1192 } hitcount:        153
{ pid:       1189 } hitcount:        153
{ pid:       1193 } hitcount:        153

Totals:
    Hits: 1685
    Entries: 16
    Dropped: 0


# event histogram
#
# trigger info: hist:keys=pid,stacktrace:vals=hitcount:sort=hitcount:size=2048 if delta < 10 [active]
#

{ pid:       1389, stacktrace:
         event_hist_trigger+0x290/0x2b0
         event_triggers_call+0x52/0xe0
         trace_event_buffer_commit+0x193/0x240
         trace_event_raw_event_sched_switch+0x120/0x180
         __traceiter_sched_switch+0x39/0x50
         __schedule+0x310/0x700
         schedule+0x72/0x110
         pipe_read+0x318/0x420
         new_sync_read+0x18b/0x1a0
         vfs_read+0xf5/0x190
         ksys_read+0xab/0xe0
         do_syscall_64+0x3b/0x90
         entry_SYSCALL_64_after_hwframe+0x61/0xcb
} hitcount:          3
{ pid:       1189, stacktrace:
         event_hist_trigger+0x290/0x2b0
         event_triggers_call+0x52/0xe0
         trace_event_buffer_commit+0x193/0x240
         trace_event_raw_event_sched_switch+0x120/0x180
         __traceiter_sched_switch+0x39/0x50
         __schedule+0x310/0x700
         schedule+0x72/0x110
         read_events+0x119/0x190
         do_io_getevents+0x72/0xe0
         __x64_sys_io_getevents+0x59/0xc0
         do_syscall_64+0x3b/0x90
         entry_SYSCALL_64_after_hwframe+0x61/0xcb
} hitcount:         28
{ pid:         61, stacktrace:
         event_hist_trigger+0x290/0x2b0
         event_triggers_call+0x52/0xe0
         trace_event_buffer_commit+0x193/0x240
         trace_event_raw_event_sched_switch+0x120/0x180
         __traceiter_sched_switch+0x39/0x50
         __schedule+0x310/0x700
         schedule+0x72/0x110
         schedule_timeout+0x88/0x160
         kcompactd+0x364/0x3f0
         kthread+0x141/0x170
         ret_from_fork+0x22/0x30
} hitcount:         28
{ pid:       1194, stacktrace:
         event_hist_trigger+0x290/0x2b0
         event_triggers_call+0x52/0xe0
         trace_event_buffer_commit+0x193/0x240
         trace_event_raw_event_sched_switch+0x120/0x180
         __traceiter_sched_switch+0x39/0x50
         __schedule+0x310/0x700
         schedule+0x72/0x110
         read_events+0x119/0x190
         do_io_getevents+0x72/0xe0
         __x64_sys_io_getevents+0x59/0xc0
         do_syscall_64+0x3b/0x90
         entry_SYSCALL_64_after_hwframe+0x61/0xcb
} hitcount:         28
{ pid:       1197, stacktrace:
         event_hist_trigger+0x290/0x2b0
         event_triggers_call+0x52/0xe0
         trace_event_buffer_commit+0x193/0x240
         trace_event_raw_event_sched_switch+0x120/0x180
         __traceiter_sched_switch+0x39/0x50
         __schedule+0x310/0x700
         schedule+0x72/0x110
         read_events+0x119/0x190
         do_io_getevents+0x72/0xe0
         __x64_sys_io_getevents+0x59/0xc0
         do_syscall_64+0x3b/0x90
         entry_SYSCALL_64_after_hwframe+0x61/0xcb
} hitcount:         28
{ pid:       1198, stacktrace:
         event_hist_trigger+0x290/0x2b0
         event_triggers_call+0x52/0xe0
         trace_event_buffer_commit+0x193/0x240
         trace_event_raw_event_sched_switch+0x120/0x180
         __traceiter_sched_switch+0x39/0x50
         __schedule+0x310/0x700
         schedule+0x72/0x110
         read_events+0x119/0x190
         do_io_getevents+0x72/0xe0
         __x64_sys_io_getevents+0x59/0xc0
         do_syscall_64+0x3b/0x90
         entry_SYSCALL_64_after_hwframe+0x61/0xcb
} hitcount:         28
{ pid:       1191, stacktrace:
         event_hist_trigger+0x290/0x2b0
         event_triggers_call+0x52/0xe0
         trace_event_buffer_commit+0x193/0x240
         trace_event_raw_event_sched_switch+0x120/0x180
         __traceiter_sched_switch+0x39/0x50
         __schedule+0x310/0x700
         schedule+0x72/0x110
         read_events+0x119/0x190
         do_io_getevents+0x72/0xe0
         __x64_sys_io_getevents+0x59/0xc0
         do_syscall_64+0x3b/0x90
         entry_SYSCALL_64_after_hwframe+0x61/0xcb
} hitcount:         28
{ pid:       1196, stacktrace:
         event_hist_trigger+0x290/0x2b0
         event_triggers_call+0x52/0xe0
         trace_event_buffer_commit+0x193/0x240
         trace_event_raw_event_sched_switch+0x120/0x180
         __traceiter_sched_switch+0x39/0x50
         __schedule+0x310/0x700
         schedule+0x72/0x110
         read_events+0x119/0x190
         do_io_getevents+0x72/0xe0
         __x64_sys_io_getevents+0x59/0xc0
         do_syscall_64+0x3b/0x90
         entry_SYSCALL_64_after_hwframe+0x61/0xcb
} hitcount:         28
{ pid:       1192, stacktrace:
         event_hist_trigger+0x290/0x2b0
         event_triggers_call+0x52/0xe0
         trace_event_buffer_commit+0x193/0x240
         trace_event_raw_event_sched_switch+0x120/0x180
         __traceiter_sched_switch+0x39/0x50
         __schedule+0x310/0x700
         schedule+0x72/0x110
         read_events+0x119/0x190
         do_io_getevents+0x72/0xe0
         __x64_sys_io_getevents+0x59/0xc0
         do_syscall_64+0x3b/0x90
         entry_SYSCALL_64_after_hwframe+0x61/0xcb
} hitcount:         28
{ pid:       1195, stacktrace:
         event_hist_trigger+0x290/0x2b0
         event_triggers_call+0x52/0xe0
         trace_event_buffer_commit+0x193/0x240
         trace_event_raw_event_sched_switch+0x120/0x180
         __traceiter_sched_switch+0x39/0x50
         __schedule+0x310/0x700
         schedule+0x72/0x110
         read_events+0x119/0x190
         do_io_getevents+0x72/0xe0
         __x64_sys_io_getevents+0x59/0xc0
         do_syscall_64+0x3b/0x90
         entry_SYSCALL_64_after_hwframe+0x61/0xcb
} hitcount:         28
{ pid:       1190, stacktrace:
         event_hist_trigger+0x290/0x2b0
         event_triggers_call+0x52/0xe0
         trace_event_buffer_commit+0x193/0x240
         trace_event_raw_event_sched_switch+0x120/0x180
         __traceiter_sched_switch+0x39/0x50
         __schedule+0x310/0x700
         schedule+0x72/0x110
         read_events+0x119/0x190
         do_io_getevents+0x72/0xe0
         __x64_sys_io_getevents+0x59/0xc0
         do_syscall_64+0x3b/0x90
         entry_SYSCALL_64_after_hwframe+0x61/0xcb
} hitcount:         28
{ pid:       1193, stacktrace:
         event_hist_trigger+0x290/0x2b0
         event_triggers_call+0x52/0xe0
         trace_event_buffer_commit+0x193/0x240
         trace_event_raw_event_sched_switch+0x120/0x180
         __traceiter_sched_switch+0x39/0x50
         __schedule+0x310/0x700
         schedule+0x72/0x110
         read_events+0x119/0x190
         do_io_getevents+0x72/0xe0
         __x64_sys_io_getevents+0x59/0xc0
         do_syscall_64+0x3b/0x90
         entry_SYSCALL_64_after_hwframe+0x61/0xcb
} hitcount:         28

Totals:
    Hits: 311
    Entries: 12
    Dropped: 0

Now we just need a tool to map the pids of the delta histogram to the pids
of the stack traces to figure out where the issues may happen.

The above is just to show that there's a lot of infrastructure already
there that does a lot of this work, but needs improvement. My theme to this
email is to modify what's there to make it work for you before just doing
everything from scratch, and then we have a bunch of stuff that only does
what we want, but is not flexible to do what others may want.

> 
> 
> > Not the prettiest thing to read. But hey, we got the full stack of where
> > these latencies happened!  
> 
> Most of the time I _don't_ want full stacktraces, though!

We could easily add a feature to limit how much you want to trace. Perhaps even
a skip level. That is, add skip and depth options to the stacktrace field.

> 
> That means I have a ton more output to sort through, and the data is far more
> expensive to collect.

That's what user space tools are for ;-)

> 
> I don't know why it's what people go to first - see the page_owner stuff - but
> that doesn't get used much either because the output is _really hard to sort
> through_.
> 
> Most of the time, just a single file and line number is all you want - and
> tracing has always made it hard to get at that.

Because we would need to store too much dwarf information in the kernel to
do so. But user space could do this for you with the function/offset
information.

> 
> 
> > Yes, it adds some overhead when the events are triggered due to the
> > stacktrace code, but it's extremely useful information.
> >   
> > > 
> > > So, it looks like tracing has made some progress over the past 10
> > > years, but for debugging latency issues it's still not there yet in
> > > general. I  
> > 
> > I call BS on that statement. Just because you do not know what has been
> > added to the kernel in the last 10 years (like you had no idea about
> > seq_buf and that was added in 2014) means to me that you are totally
> > clueless on what tracing can and can not do.
> > 
> > It appears to me that you are too focused on inventing your own wheel
> > that does exactly what you want before looking to see how things are
> > today. Just because something didn't fit your needs 10 years ago
> > doesn't mean that it can't fit your needs today.  
> 
> ...And the ad hominem attacks start.

Look, you keep making comments about the tracing infrastructure that you
clearly do not understand. And that is pretty insulting. Sorry, I'm not
sure you realize this, but those comments do turn people off and their
responses will start to become stronger.

> 
> Steve, I'm not attacking you, and there's room enough in this world for
> the both of us to be doing our thing creating new and useful tools.

You seem to push back hard when people suggest improving other utilities
to suite your needs.

> 
> > I'm already getting complaints from customers/users that are saying
> > there's too many tools in the toolbox already. (Do we use
> > ftrace/perf/bpf?). The idea is to have the tools using mostly the same
> > infrastructure, and not be 100% off on its own, unless there's a clear
> > reason to invent a new wheel that several people are asking for, not
> > just one or two.  
> 
> I would like to see more focus on usability.

Then lets make the current tools more usable. For example, the synthetic
event kernel interface is horrible. It's an awesome feature that wasn't
getting used due to the interface. This is why I created "sqlhist". It's
now really easy to create synthetic events with that tool. I agree, focus
on usability, but that doesn't always mean to create yet another tool. This
reminds me of:

   https://xkcd.com/927/


> 
> That means, in a best case scenario, always-on data collection that I can
> just look at, and it'll already be in the format most likely to be useful.
> 
> Surely you can appreciate the usefulness of that..?

I find "runtime turn on and off" better than "always on". We have
static_branches today (aka jump labels). I would strongly suggest using
them. You get them automatically from tracepoints . Even sched_stats are
using these.

> 
> Tracing started out as a tool for efficiently getting lots of data out of
> the kernel, and it's great for that. But I think your focus on the cool
> thing you built may be blinding you a bit to alternative approaches...

I actually work hard to have the tracing infrastructure help out other
approaches. perf and bpf use the ftrace infrastructure because it is
designed to be modular. Nothing is "must be the ftrace way". I'm not against
the new features you are adding, I just want you to make a little more
effort in incorporating other infrastructures (and perhaps even improving
that infrastructure) to suite your needs.

If ftrace, perf, bpf can't do what you want, take a harder look to see if
you can modify them to do so.

-- Steve
