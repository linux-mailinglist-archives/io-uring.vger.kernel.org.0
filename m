Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16B905AA359
	for <lists+io-uring@lfdr.de>; Fri,  2 Sep 2022 00:54:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234659AbiIAWy1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Sep 2022 18:54:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234373AbiIAWy0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Sep 2022 18:54:26 -0400
Received: from out1.migadu.com (out1.migadu.com [91.121.223.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDBF275FEE;
        Thu,  1 Sep 2022 15:54:24 -0700 (PDT)
Date:   Thu, 1 Sep 2022 15:53:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1662072863;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HsNTuFQ7XbCclBZlUbN3U5MkNcD4kydlxiKj9ag/mqM=;
        b=oPzrWlMu1zttBKXqMooMVKLQBDEeBWlyjX9vsDJkAXG+i91talZG3CnOLGZqJ/j7NVGRKB
        wZTWLVRasLoef5Won/PgGguSqmh0FC7JUNFBw6OgxkY16iM6YRuGaquB3T/TIBb4G8gtzw
        fhM8xA0vhhBp50IAflanG0eJ5LKzxK0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Roman Gushchin <roman.gushchin@linux.dev>
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     Yosry Ahmed <yosryahmed@google.com>,
        Michal Hocko <mhocko@suse.com>, Mel Gorman <mgorman@suse.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, dave@stgolabs.net,
        Matthew Wilcox <willy@infradead.org>, liam.howlett@oracle.com,
        void@manifault.com, juri.lelli@redhat.com, ldufour@linux.ibm.com,
        Peter Xu <peterx@redhat.com>,
        David Hildenbrand <david@redhat.com>, axboe@kernel.dk,
        mcgrof@kernel.org, masahiroy@kernel.org, nathan@kernel.org,
        changbin.du@intel.com, ytcoode@gmail.com,
        vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
        Steven Rostedt <rostedt@goodmis.org>, bsegall@google.com,
        bristot@redhat.com, vschneid@redhat.com,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, 42.hyeyoo@gmail.com,
        glider@google.com, elver@google.com, dvyukov@google.com,
        Shakeel Butt <shakeelb@google.com>,
        Muchun Song <songmuchun@bytedance.com>, arnd@arndb.de,
        jbaron@akamai.com, David Rientjes <rientjes@google.com>,
        minchan@google.com, kaleshsingh@google.com,
        kernel-team@android.com, Linux-MM <linux-mm@kvack.org>,
        iommu@lists.linux.dev, kasan-dev@googlegroups.com,
        io-uring@vger.kernel.org, linux-arch@vger.kernel.org,
        xen-devel@lists.xenproject.org, linux-bcache@vger.kernel.org,
        linux-modules@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 00/30] Code tagging framework and applications
Message-ID: <YxE4BXw5i+BkxxD8@P9FQF9L96D.corp.robot.car>
References: <20220830214919.53220-1-surenb@google.com>
 <Yw8P8xZ4zqu121xL@hirez.programming.kicks-ass.net>
 <20220831084230.3ti3vitrzhzsu3fs@moria.home.lan>
 <20220831101948.f3etturccmp5ovkl@suse.de>
 <Yw88RFuBgc7yFYxA@dhcp22.suse.cz>
 <20220831190154.qdlsxfamans3ya5j@moria.home.lan>
 <CAJD7tkaev9B=UDYj2RL6pz-1454J8tv4gEr9y-2dnCksoLK0bw@mail.gmail.com>
 <YxExz+c1k3nbQMh4@P9FQF9L96D.corp.robot.car>
 <20220901223720.e4gudprscjtwltif@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220901223720.e4gudprscjtwltif@moria.home.lan>
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

On Thu, Sep 01, 2022 at 06:37:20PM -0400, Kent Overstreet wrote:
> On Thu, Sep 01, 2022 at 03:27:27PM -0700, Roman Gushchin wrote:
> > On Wed, Aug 31, 2022 at 01:56:08PM -0700, Yosry Ahmed wrote:
> > > This is very interesting work! Do you have any data about the overhead
> > > this introduces, especially in a production environment? I am
> > > especially interested in memory allocations tracking and detecting
> > > leaks.
> > 
> > +1
> > 
> > I think the question whether it indeed can be always turned on in the production
> > or not is the main one. If not, the advantage over ftrace/bpf/... is not that
> > obvious. Otherwise it will be indeed a VERY useful thing.
> 
> Low enough overhead to run in production was my primary design goal.
> 
> Stats are kept in a struct that's defined at the callsite. So this adds _no_
> pointer chasing to the allocation path, unless we've switch to percpu counters
> at that callsite (see the lazy percpu counters patch), where we need to deref
> one percpu pointer to save an atomic.
> 
> Then we need to stash a pointer to the alloc_tag, so that kfree() can find it.
> For slab allocations this uses the same storage area as memcg, so for
> allocations that are using that we won't be touching any additional cachelines.
> (I wanted the pointer to the alloc_tag to be stored inline with the allocation,
> but that would've caused alignment difficulties).
> 
> Then there's a pointer deref introduced to the kfree() path, to get back to the
> original alloc_tag and subtract the allocation from that callsite. That one
> won't be free, and with percpu counters we've got another dependent load too -
> hmm, it might be worth benchmarking with just atomics, skipping the percpu
> counters.
> 
> So the overhead won't be zero, I expect it'll show up in some synthetic
> benchmarks, but yes I do definitely expect this to be worth enabling in
> production in many scenarios.

I'm somewhat sceptical, but I usually am. And in this case I'll be really happy
to be wrong.

On a bright side, maybe most of the overhead will come from few allocations,
so an option to explicitly exclude them will do the trick.

I'd suggest to run something like iperf on a fast hardware. And maybe some
io_uring stuff too. These are two places which were historically most sensitive
to the (kernel) memory accounting speed.

Thanks!
