Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 873185AA18F
	for <lists+io-uring@lfdr.de>; Thu,  1 Sep 2022 23:38:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233663AbiIAViV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Sep 2022 17:38:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbiIAViU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Sep 2022 17:38:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5677A754A4;
        Thu,  1 Sep 2022 14:38:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E2AB061F79;
        Thu,  1 Sep 2022 21:38:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13146C433D6;
        Thu,  1 Sep 2022 21:38:12 +0000 (UTC)
Date:   Thu, 1 Sep 2022 17:38:44 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Suren Baghdasaryan <surenb@google.com>
Cc:     akpm@linux-foundation.org, kent.overstreet@linux.dev,
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
Message-ID: <20220901173844.36e1683c@gandalf.local.home>
In-Reply-To: <20220830214919.53220-28-surenb@google.com>
References: <20220830214919.53220-1-surenb@google.com>
        <20220830214919.53220-28-surenb@google.com>
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

On Tue, 30 Aug 2022 14:49:16 -0700
Suren Baghdasaryan <surenb@google.com> wrote:

> From: Kent Overstreet <kent.overstreet@linux.dev>
> 
> This adds the ability to easily instrument code for measuring latency.
> To use, add the following to calls to your code, at the start and end of
> the event you wish to measure:
> 
>   code_tag_time_stats_start(start_time);
>   code_tag_time_stats_finish(start_time);

So you need to modify the code to see what you want?

> 
> Stastistics will then show up in debugfs under
> /sys/kernel/debug/time_stats, listed by file and line number.
> 
> Stastics measured include weighted averages of frequency, duration, max
> duration, as well as quantiles.
> 
> This patch also instruments all calls to init_wait and finish_wait,
> which includes all calls to wait_event. Example debugfs output:
> 
> fs/xfs/xfs_trans_ail.c:746 module:xfs func:xfs_ail_push_all_sync
> count:          17
> rate:           0/sec
> frequency:      2 sec
> avg duration:   10 us
> max duration:   232 us
> quantiles (ns): 128 128 128 128 128 128 128 128 128 128 128 128 128 128 128
> 
> lib/sbitmap.c:813 module:sbitmap func:sbitmap_finish_wait
> count:          3
> rate:           0/sec
> frequency:      4 sec
> avg duration:   4 sec
> max duration:   4 sec
> quantiles (ns): 0 4288669120 4288669120 5360836048 5360836048 5360836048 5360836048 5360836048 5360836048 5360836048 5360836048 5360836048 5360836048 5360836048 5360836048
> 
> net/core/datagram.c:122 module:datagram func:__skb_wait_for_more_packets
> count:          10
> rate:           1/sec
> frequency:      859 ms
> avg duration:   472 ms
> max duration:   30 sec
> quantiles (ns): 0 12279 12279 15669 15669 15669 15669 17217 17217 17217 17217 17217 17217 17217 17217

For function length you could just do something like this:

 # cd /sys/kernel/tracing
 # echo __skb_wait_for_more_packets > set_ftrace_filter
 # echo 1 > function_profile_enabled
 # cat trace_stat/function*
  Function                               Hit    Time            Avg             s^2
  --------                               ---    ----            ---             ---
  __skb_wait_for_more_packets              1    0.000 us        0.000 us        0.000 us    
  Function                               Hit    Time            Avg             s^2
  --------                               ---    ----            ---             ---
  __skb_wait_for_more_packets              1    74.813 us       74.813 us       0.000 us    
  Function                               Hit    Time            Avg             s^2
  --------                               ---    ----            ---             ---
  Function                               Hit    Time            Avg             s^2
  --------                               ---    ----            ---             ---

The above is for a 4 CPU machine. The s^2 is the square of the standard
deviation (makes not having to do divisions while it runs).

But if you are looking for latency between two events (which can be kprobes
too, where you do not need to rebuild your kernel):

From: https://man.archlinux.org/man/sqlhist.1.en
which comes in: https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
  if not already installed on your distro.

 # sqlhist -e -n wakeup_lat 'select end.next_comm as comm,start.pid,start.prio,(end.TIMESTAMP_USECS - start.TIMESTAMP_USECS) as delta from sched_waking as start join sched_switch as end on start.pid = end.next_pid where start.prio < 100'

The above creates a synthetic event called "wakeup_lat" that joins two
events (sched_waking and sched_switch) when the pid field of sched_waking
matches the next_pid field of sched_switch. When there is a match, it will
trigger the wakeup_lat event only if the prio of the sched_waking event is
less than 100 (which in the kernel means any real-time task). The
wakeup_lat event will record the next_comm (as comm field), the pid of
woken task and the time delta in microseconds between the two events.

 # echo 'hist:keys=comm,prio,delta.buckets=10:sort=delta' > /sys/kernel/tracing/events/synthetic/wakeup_lat/trigger

The above starts a histogram tracing the name of the woken task, the
priority and the delta (but placing the delta in buckets of size 10, as we
do not need to see every latency number).

 # chrt -f 20 sleep 1

Force something to be woken up that is interesting.

 # cat /sys/kernel/tracing/events/synthetic/wakeup_lat/hist
# event histogram
#
# trigger info: hist:keys=comm,prio,delta.buckets=10:vals=hitcount:sort=delta.buckets=10:size=2048 [active]
#

{ comm: migration/5                                       , prio:          0, delta: ~ 10-19 } hitcount:          1
{ comm: migration/2                                       , prio:          0, delta: ~ 10-19 } hitcount:          1
{ comm: sleep                                             , prio:         79, delta: ~ 10-19 } hitcount:          1
{ comm: migration/7                                       , prio:          0, delta: ~ 10-19 } hitcount:          1
{ comm: migration/4                                       , prio:          0, delta: ~ 10-19 } hitcount:          1
{ comm: migration/6                                       , prio:          0, delta: ~ 10-19 } hitcount:          1
{ comm: migration/1                                       , prio:          0, delta: ~ 10-19 } hitcount:          2
{ comm: migration/0                                       , prio:          0, delta: ~ 10-19 } hitcount:          1
{ comm: migration/2                                       , prio:          0, delta: ~ 20-29 } hitcount:          1
{ comm: migration/0                                       , prio:          0, delta: ~ 20-29 } hitcount:          1

Totals:
    Hits: 11
    Entries: 10
    Dropped: 0

That is a histogram of the wakeup latency of all real time tasks that woke
up. Oh, and it does not drop events unless the number of entries is bigger
than the size of the count of buckets, which I haven't actually
encountered, as there's 2048 buckets. But you can make it bigger with the
"size" attribute in the creation of the histogram.

-- Steve




