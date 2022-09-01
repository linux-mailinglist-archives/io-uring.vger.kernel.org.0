Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 446B75AA1C7
	for <lists+io-uring@lfdr.de>; Thu,  1 Sep 2022 23:55:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234205AbiIAVyw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Sep 2022 17:54:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234101AbiIAVyv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Sep 2022 17:54:51 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F2DA2A7;
        Thu,  1 Sep 2022 14:54:47 -0700 (PDT)
Date:   Thu, 1 Sep 2022 17:54:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1662069286;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cwEaHM2MLzWFSTyYX5D3U7h9xVWN0G5HRpYdRjufwn0=;
        b=Twh7nBps+XmX0981JwFQK7PMJW17CAHEz4A60UGJ6tfnVJLg6TZy5G0xn6V03JWw5jzP+B
        3RE93gZ+MZBUwxCNryz2EldJWBau/or+sfFVuw+2kP1flYXFxRkrg7pE3b74SSfBEB2oWB
        lummEMiyswsHuVB+uMrViWPiyxSgtyk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Steven Rostedt <rostedt@goodmis.org>
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
Message-ID: <20220901215438.gy3bgqa4ghhm6ztm@moria.home.lan>
References: <20220830214919.53220-1-surenb@google.com>
 <20220830214919.53220-28-surenb@google.com>
 <20220901173844.36e1683c@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220901173844.36e1683c@gandalf.local.home>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Sep 01, 2022 at 05:38:44PM -0400, Steven Rostedt wrote:
> On Tue, 30 Aug 2022 14:49:16 -0700
> Suren Baghdasaryan <surenb@google.com> wrote:
> 
> > From: Kent Overstreet <kent.overstreet@linux.dev>
> > 
> > This adds the ability to easily instrument code for measuring latency.
> > To use, add the following to calls to your code, at the start and end of
> > the event you wish to measure:
> > 
> >   code_tag_time_stats_start(start_time);
> >   code_tag_time_stats_finish(start_time);
> 
> So you need to modify the code to see what you want?

Figuring out the _correct_ place to measure is often a significant amount of the
total effort.

Having done so once, why not annotate that in the source code?

> For function length you could just do something like this:
> 
>  # cd /sys/kernel/tracing
>  # echo __skb_wait_for_more_packets > set_ftrace_filter
>  # echo 1 > function_profile_enabled
>  # cat trace_stat/function*
>   Function                               Hit    Time            Avg             s^2
>   --------                               ---    ----            ---             ---
>   __skb_wait_for_more_packets              1    0.000 us        0.000 us        0.000 us    
>   Function                               Hit    Time            Avg             s^2
>   --------                               ---    ----            ---             ---
>   __skb_wait_for_more_packets              1    74.813 us       74.813 us       0.000 us    
>   Function                               Hit    Time            Avg             s^2
>   --------                               ---    ----            ---             ---
>   Function                               Hit    Time            Avg             s^2
>   --------                               ---    ----            ---             ---
> 
> The above is for a 4 CPU machine. The s^2 is the square of the standard
> deviation (makes not having to do divisions while it runs).
> 
> But if you are looking for latency between two events (which can be kprobes
> too, where you do not need to rebuild your kernel):
> 
> From: https://man.archlinux.org/man/sqlhist.1.en
> which comes in: https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
>   if not already installed on your distro.
> 
>  # sqlhist -e -n wakeup_lat 'select end.next_comm as comm,start.pid,start.prio,(end.TIMESTAMP_USECS - start.TIMESTAMP_USECS) as delta from sched_waking as start join sched_switch as end on start.pid = end.next_pid where start.prio < 100'
> 
> The above creates a synthetic event called "wakeup_lat" that joins two
> events (sched_waking and sched_switch) when the pid field of sched_waking
> matches the next_pid field of sched_switch. When there is a match, it will
> trigger the wakeup_lat event only if the prio of the sched_waking event is
> less than 100 (which in the kernel means any real-time task). The
> wakeup_lat event will record the next_comm (as comm field), the pid of
> woken task and the time delta in microseconds between the two events.

So this looks like it's gotten better since I last looked, but it's still not
there yet.

Part of the problem is that the tracepoints themselves are in the wrong place:
your end event is when a task is woken up, but that means spurious wakeups will
cause one wait_event() call to be reported as multiple smaller waits, not one
long wait - oops, now I can't actually find the thing that's causing my
multi-second delay.

Also, in your example you don't have it broken out by callsite. That would be
the first thing I'd need for any real world debugging.

So, it looks like tracing has made some progress over the past 10 years, but
for debugging latency issues it's still not there yet in general. I will
definitely remember function latency tracing the next time I'm doing performance
work, but I expect that to be far too heavy to enable on a live server.

This thing is only a couple hundred lines of code though, so perhaps tracing
shouldn't be the only tool in our toolbox :)
