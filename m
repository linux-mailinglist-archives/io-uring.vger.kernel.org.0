Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 564FD5AA324
	for <lists+io-uring@lfdr.de>; Fri,  2 Sep 2022 00:34:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234920AbiIAWeK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Sep 2022 18:34:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233374AbiIAWeJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Sep 2022 18:34:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90F7D11D;
        Thu,  1 Sep 2022 15:34:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3B02BB82962;
        Thu,  1 Sep 2022 22:34:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9A46C433C1;
        Thu,  1 Sep 2022 22:33:59 +0000 (UTC)
Date:   Thu, 1 Sep 2022 18:34:30 -0400
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
Message-ID: <20220901183430.120311ce@gandalf.local.home>
In-Reply-To: <20220901215438.gy3bgqa4ghhm6ztm@moria.home.lan>
References: <20220830214919.53220-1-surenb@google.com>
        <20220830214919.53220-28-surenb@google.com>
        <20220901173844.36e1683c@gandalf.local.home>
        <20220901215438.gy3bgqa4ghhm6ztm@moria.home.lan>
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

On Thu, 1 Sep 2022 17:54:38 -0400
Kent Overstreet <kent.overstreet@linux.dev> wrote:
> 
> So this looks like it's gotten better since I last looked, but it's still not
> there yet.
> 
> Part of the problem is that the tracepoints themselves are in the wrong place:
> your end event is when a task is woken up, but that means spurious wakeups will

The end event is when a task is scheduled onto the CPU. The start event is
the first time it is woken up.

> cause one wait_event() call to be reported as multiple smaller waits, not one
> long wait - oops, now I can't actually find the thing that's causing my
> multi-second delay.
> 
> Also, in your example you don't have it broken out by callsite. That would be
> the first thing I'd need for any real world debugging.

OK, how about this (currently we can only have 3 keys, but you can create
multiple histograms on the same event).

 # echo 'hist:keys=comm,stacktrace,delta.buckets=10:sort=delta' > /sys/kernel/tracing/events/synthetic/wakeup_lat/trigger

(notice the "stacktrace" in the keys)

# cat /sys/kernel/tracing/events/synthetic/wakeup_lat/hist
# event histogram
#
# trigger info: hist:keys=comm,stacktrace,delta.buckets=10:vals=hitcount:sort=delta.buckets=10:size=2048 [active]
#

{ comm: migration/2                                       , stacktrace:
         event_hist_trigger+0x290/0x2b0
         event_triggers_call+0x52/0xe0
         trace_event_buffer_commit+0x193/0x240
         trace_event_raw_event_sched_switch+0x120/0x180
         __traceiter_sched_switch+0x39/0x50
         __schedule+0x310/0x700
         schedule_idle+0x26/0x40
         do_idle+0xb4/0xd0
         cpu_startup_entry+0x19/0x20
         secondary_startup_64_no_verify+0xc2/0xcb
, delta: ~ 10-19} hitcount:          7
{ comm: migration/5                                       , stacktrace:
         event_hist_trigger+0x290/0x2b0
         event_triggers_call+0x52/0xe0
         trace_event_buffer_commit+0x193/0x240
         trace_event_raw_event_sched_switch+0x120/0x180
         __traceiter_sched_switch+0x39/0x50
         __schedule+0x310/0x700
         schedule_idle+0x26/0x40
         do_idle+0xb4/0xd0
         cpu_startup_entry+0x19/0x20
         secondary_startup_64_no_verify+0xc2/0xcb
, delta: ~ 10-19} hitcount:          7
{ comm: migration/1                                       , stacktrace:
         event_hist_trigger+0x290/0x2b0
         event_triggers_call+0x52/0xe0
         trace_event_buffer_commit+0x193/0x240
         trace_event_raw_event_sched_switch+0x120/0x180
         __traceiter_sched_switch+0x39/0x50
         __schedule+0x310/0x700
         schedule_idle+0x26/0x40
         do_idle+0xb4/0xd0
         cpu_startup_entry+0x19/0x20
         secondary_startup_64_no_verify+0xc2/0xcb
, delta: ~ 10-19} hitcount:          7
{ comm: migration/7                                       , stacktrace:
         event_hist_trigger+0x290/0x2b0
         event_triggers_call+0x52/0xe0
         trace_event_buffer_commit+0x193/0x240
         trace_event_raw_event_sched_switch+0x120/0x180
         __traceiter_sched_switch+0x39/0x50
         __schedule+0x310/0x700
         schedule_idle+0x26/0x40
         do_idle+0xb4/0xd0
         cpu_startup_entry+0x19/0x20
         secondary_startup_64_no_verify+0xc2/0xcb
, delta: ~ 10-19} hitcount:          7
{ comm: migration/0                                       , stacktrace:
         event_hist_trigger+0x290/0x2b0
         event_triggers_call+0x52/0xe0
         trace_event_buffer_commit+0x193/0x240
         trace_event_raw_event_sched_switch+0x120/0x180
         __traceiter_sched_switch+0x39/0x50
         __schedule+0x310/0x700
         schedule_idle+0x26/0x40
         do_idle+0xb4/0xd0
         cpu_startup_entry+0x19/0x20
         start_kernel+0x595/0x5be
         secondary_startup_64_no_verify+0xc2/0xcb
, delta: ~ 10-19} hitcount:          7
{ comm: migration/4                                       , stacktrace:
         event_hist_trigger+0x290/0x2b0
         event_triggers_call+0x52/0xe0
         trace_event_buffer_commit+0x193/0x240
         trace_event_raw_event_sched_switch+0x120/0x180
         __traceiter_sched_switch+0x39/0x50
         __schedule+0x310/0x700
         schedule_idle+0x26/0x40
         do_idle+0xb4/0xd0
         cpu_startup_entry+0x19/0x20
         secondary_startup_64_no_verify+0xc2/0xcb
, delta: ~ 10-19} hitcount:          7
{ comm: rtkit-daemon                                      , stacktrace:
         event_hist_trigger+0x290/0x2b0
         event_triggers_call+0x52/0xe0
         trace_event_buffer_commit+0x193/0x240
         trace_event_raw_event_sched_switch+0x120/0x180
         __traceiter_sched_switch+0x39/0x50
         __schedule+0x310/0x700
         preempt_schedule_common+0x2d/0x70
         preempt_schedule_thunk+0x16/0x18
         _raw_spin_unlock_irq+0x2e/0x40
         eventfd_write+0xc8/0x290
         vfs_write+0xc0/0x2a0
         ksys_write+0x5f/0xe0
         do_syscall_64+0x3b/0x90
         entry_SYSCALL_64_after_hwframe+0x61/0xcb
, delta: ~ 10-19} hitcount:          1
{ comm: migration/6                                       , stacktrace:
         event_hist_trigger+0x290/0x2b0
         event_triggers_call+0x52/0xe0
         trace_event_buffer_commit+0x193/0x240
         trace_event_raw_event_sched_switch+0x120/0x180
         __traceiter_sched_switch+0x39/0x50
         __schedule+0x310/0x700
         schedule_idle+0x26/0x40
         do_idle+0xb4/0xd0
         cpu_startup_entry+0x19/0x20
         secondary_startup_64_no_verify+0xc2/0xcb
, delta: ~ 10-19} hitcount:          7
{ comm: rtkit-daemon                                      , stacktrace:
         event_hist_trigger+0x290/0x2b0
         event_triggers_call+0x52/0xe0
         trace_event_buffer_commit+0x193/0x240
         trace_event_raw_event_sched_switch+0x120/0x180
         __traceiter_sched_switch+0x39/0x50
         __schedule+0x310/0x700
         schedule_idle+0x26/0x40
         do_idle+0xb4/0xd0
         cpu_startup_entry+0x19/0x20
         secondary_startup_64_no_verify+0xc2/0xcb
, delta: ~ 20-29} hitcount:          1
{ comm: rtkit-daemon                                      , stacktrace:
         event_hist_trigger+0x290/0x2b0
         event_triggers_call+0x52/0xe0
         trace_event_buffer_commit+0x193/0x240
         trace_event_raw_event_sched_switch+0x120/0x180
         __traceiter_sched_switch+0x39/0x50
         __schedule+0x310/0x700
         preempt_schedule_common+0x2d/0x70
         preempt_schedule_thunk+0x16/0x18
         _raw_spin_unlock_irq+0x2e/0x40
         eventfd_write+0xc8/0x290
         vfs_write+0xc0/0x2a0
         ksys_write+0x5f/0xe0
         do_syscall_64+0x3b/0x90
         entry_SYSCALL_64_after_hwframe+0x61/0xcb
, delta: ~ 30-39} hitcount:          1
{ comm: rtkit-daemon                                      , stacktrace:
         event_hist_trigger+0x290/0x2b0
         event_triggers_call+0x52/0xe0
         trace_event_buffer_commit+0x193/0x240
         trace_event_raw_event_sched_switch+0x120/0x180
         __traceiter_sched_switch+0x39/0x50
         __schedule+0x310/0x700
         schedule_idle+0x26/0x40
         do_idle+0xb4/0xd0
         cpu_startup_entry+0x19/0x20
         secondary_startup_64_no_verify+0xc2/0xcb
, delta: ~ 40-49} hitcount:          1

Totals:
    Hits: 53
    Entries: 11
    Dropped: 0


Not the prettiest thing to read. But hey, we got the full stack of where
these latencies happened!

Yes, it adds some overhead when the events are triggered due to the
stacktrace code, but it's extremely useful information.

> 
> So, it looks like tracing has made some progress over the past 10 years,
> but for debugging latency issues it's still not there yet in general. I

I call BS on that statement. Just because you do not know what has been
added to the kernel in the last 10 years (like you had no idea about
seq_buf and that was added in 2014) means to me that you are totally
clueless on what tracing can and can not do.

It appears to me that you are too focused on inventing your own wheel that
does exactly what you want before looking to see how things are today. Just
because something didn't fit your needs 10 years ago doesn't mean that it
can't fit your needs today.


> will definitely remember function latency tracing the next time I'm doing
> performance work, but I expect that to be far too heavy to enable on a
> live server.

I run it on production machines all the time. With the filtering in place
it has very little overhead. Mostly in the noise. The best part is that it
has practically zero overhead (but can add some cache pressure) when it's
off, and can be turned on at run time.

The tracing infrastructure is very modular, you can use parts of it that
you need, without the overhead of other parts. Like you found out this week
that tracepoints are not the same as trace events. Because tracepoints are
just a hook in the code that anything can attach to (that's what Daniel's
RV work does). Trace events provide the stored data to be recorded.

I will note that the current histogram code overhead has increased due to
retpolines, but I have code to convert them from indirect calls to direct
calls via a switch statement which drops the overhead by 20%!

  https://lore.kernel.org/all/20220823214606.344269352@goodmis.org/


> 
> This thing is only a couple hundred lines of code though, so perhaps
> tracing shouldn't be the only tool in our toolbox :)

I'm already getting complaints from customers/users that are saying there's
too many tools in the toolbox already. (Do we use ftrace/perf/bpf?). The
idea is to have the tools using mostly the same infrastructure, and not be
100% off on its own, unless there's a clear reason to invent a new wheel
that several people are asking for, not just one or two.

-- Steve
