Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44A915AA35F
	for <lists+io-uring@lfdr.de>; Fri,  2 Sep 2022 00:56:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234608AbiIAW4P (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Sep 2022 18:56:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234217AbiIAW4N (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Sep 2022 18:56:13 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B94D3A4A3;
        Thu,  1 Sep 2022 15:55:24 -0700 (PDT)
Date:   Thu, 1 Sep 2022 18:55:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1662072922;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bm+owKdXaA8Za4y2gNPpxqBECptJMMdY3T6zMUdS1uA=;
        b=Fj1UwT1LlnomuaYWyJX83g2eH1NGu9VGY3Z1XYuS7iWaeij+fOtjqjeNP5fRtDcipgANPk
        YblJyNeS8G+qSLk518WRLg7ZbAtUOZTxhs39TzCOzZh/6MJ4QyTPUYlr6G2HzUttGddpDz
        LgogK35WkmL6KTZCFbHByp017VQO0KE=
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
Message-ID: <20220901225515.ogg7pyljmfzezamr@moria.home.lan>
References: <20220830214919.53220-1-surenb@google.com>
 <20220830214919.53220-28-surenb@google.com>
 <20220901173844.36e1683c@gandalf.local.home>
 <20220901215438.gy3bgqa4ghhm6ztm@moria.home.lan>
 <20220901183430.120311ce@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220901183430.120311ce@gandalf.local.home>
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

On Thu, Sep 01, 2022 at 06:34:30PM -0400, Steven Rostedt wrote:
> On Thu, 1 Sep 2022 17:54:38 -0400
> Kent Overstreet <kent.overstreet@linux.dev> wrote:
> > 
> > So this looks like it's gotten better since I last looked, but it's still not
> > there yet.
> > 
> > Part of the problem is that the tracepoints themselves are in the wrong place:
> > your end event is when a task is woken up, but that means spurious wakeups will
> 
> The end event is when a task is scheduled onto the CPU. The start event is
> the first time it is woken up.

Yeah, that's not what I want. You're just tracing latency due to having more
processes runnable than CPUs.

I don't care about that for debugging, though! I specifically want latency at
the wait_event() level, and related - every time a process blocked _on some
condition_, until that condition became true. Not until some random, potentially
spurious wakeup.


> Not the prettiest thing to read. But hey, we got the full stack of where
> these latencies happened!

Most of the time I _don't_ want full stacktraces, though!

That means I have a ton more output to sort through, and the data is far more
expensive to collect.

I don't know why it's what people go to first - see the page_owner stuff - but
that doesn't get used much either because the output is _really hard to sort
through_.

Most of the time, just a single file and line number is all you want - and
tracing has always made it hard to get at that.


> Yes, it adds some overhead when the events are triggered due to the
> stacktrace code, but it's extremely useful information.
> 
> > 
> > So, it looks like tracing has made some progress over the past 10 years,
> > but for debugging latency issues it's still not there yet in general. I
> 
> I call BS on that statement. Just because you do not know what has been
> added to the kernel in the last 10 years (like you had no idea about
> seq_buf and that was added in 2014) means to me that you are totally
> clueless on what tracing can and can not do.
> 
> It appears to me that you are too focused on inventing your own wheel that
> does exactly what you want before looking to see how things are today. Just
> because something didn't fit your needs 10 years ago doesn't mean that it
> can't fit your needs today.

...And the ad hominem attacks start.

Steve, I'm not attacking you, and there's room enough in this world for the both
of us to be doing our thing creating new and useful tools.

> I'm already getting complaints from customers/users that are saying there's
> too many tools in the toolbox already. (Do we use ftrace/perf/bpf?). The
> idea is to have the tools using mostly the same infrastructure, and not be
> 100% off on its own, unless there's a clear reason to invent a new wheel
> that several people are asking for, not just one or two.

I would like to see more focus on usability.

That means, in a best case scenario, always-on data collection that I can just
look at, and it'll already be in the format most likely to be useful.

Surely you can appreciate the usefulness of that..?

Tracing started out as a tool for efficiently getting lots of data out of the
kernel, and it's great for that. But I think your focus on the cool thing you
built may be blinding you a bit to alternative approaches...
