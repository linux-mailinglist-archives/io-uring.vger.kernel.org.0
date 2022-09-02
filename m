Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A7325AA527
	for <lists+io-uring@lfdr.de>; Fri,  2 Sep 2022 03:35:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235184AbiIBBfp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Sep 2022 21:35:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234557AbiIBBfn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Sep 2022 21:35:43 -0400
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BB4587696;
        Thu,  1 Sep 2022 18:35:40 -0700 (PDT)
Date:   Thu, 1 Sep 2022 21:35:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1662082539;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DKbeuQ0KEVmGJmd1nxH6IkYl6hlcE8fBK782zCfa3dY=;
        b=djK/rzc16o2I5st6iLU+mmFycopk8nXeACxAiaLCYMzWJYltipsNT6kJ+bcD6p5dv0fhQK
        tsO6ER4nJ6etmNpcfsjSsEGbvTpJzvOlYT1SEGzRruYg/z2yOc4vkCLRQmY8hz09hO4/JQ
        EYL/angxfkhwhSI7Gv5opBj0F7OyMnA=
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
Message-ID: <20220902013532.6n5cyf3oofntljho@moria.home.lan>
References: <20220830214919.53220-1-surenb@google.com>
 <20220830214919.53220-28-surenb@google.com>
 <20220901173844.36e1683c@gandalf.local.home>
 <20220901215438.gy3bgqa4ghhm6ztm@moria.home.lan>
 <20220901183430.120311ce@gandalf.local.home>
 <20220901225515.ogg7pyljmfzezamr@moria.home.lan>
 <20220901202311.546a53b5@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220901202311.546a53b5@gandalf.local.home>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Sep 01, 2022 at 08:23:11PM -0400, Steven Rostedt wrote:
> If ftrace, perf, bpf can't do what you want, take a harder look to see if
> you can modify them to do so.

Maybe we can use this exchange to make both of our tools better. I like your
histograms - the quantiles algorithm I've had for years is janky, I've been
meaning to rip that out, I'd love to take a look at your code for that. And
having an on/off switch is a good idea, I'll try to add that at some point.
Maybe you got some ideas from my stuff too.

I'd love to get better tracepoints for measuring latency - what I added to
init_wait() and finish_wait() was really only a starting point. Figuring out
the right places to measure is where I'd like to be investing my time in this
area, and there's no reason we couldn't both be making use of that.

e.g. with kernel waitqueues, I looked at hooking prepare_to_wait() first but not
all code uses that, init_wait() got me better coverage. But I've already seen
that that misses things, too, there's more work to be done.

random thought: might try adding a warning in schedule() any time it's called
and codetag_time_stats_start() hasn't been called, that'll be a starting
point...
