Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E76315AB8F3
	for <lists+io-uring@lfdr.de>; Fri,  2 Sep 2022 21:48:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229839AbiIBTsw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 2 Sep 2022 15:48:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiIBTsv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 2 Sep 2022 15:48:51 -0400
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F3F120BEB;
        Fri,  2 Sep 2022 12:48:50 -0700 (PDT)
Date:   Fri, 2 Sep 2022 15:48:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1662148127;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=n3Vt2n+PBD0eNIsvGTR1l3JrOeVtWEjP88FVSBBEvEY=;
        b=mPyxzHSCWJDs7FY0KQSQlCnTELLgR0D5y3QUtw1jP0xws7G95PlcumsBf40lKyXM7CpTgQ
        EQ03B0NpMd3GmyUjL7/LRRu2b7P7CYcc/5drjtaORm2I0b47gBiN9Kk3SiUGyi3Al05Eo0
        A5b6cgfMPf2NEURa1fE7EOtxMOAAjIs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Roman Gushchin <roman.gushchin@linux.dev>,
        Yosry Ahmed <yosryahmed@google.com>,
        Michal Hocko <mhocko@suse.com>, Mel Gorman <mgorman@suse.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, dave@stgolabs.net,
        Matthew Wilcox <willy@infradead.org>, liam.howlett@oracle.com,
        void@manifault.com, juri.lelli@redhat.com, ldufour@linux.ibm.com,
        Peter Xu <peterx@redhat.com>,
        David Hildenbrand <david@redhat.com>, mcgrof@kernel.org,
        masahiroy@kernel.org, nathan@kernel.org, changbin.du@intel.com,
        ytcoode@gmail.com, vincent.guittot@linaro.org,
        dietmar.eggemann@arm.com, Steven Rostedt <rostedt@goodmis.org>,
        bsegall@google.com, bristot@redhat.com, vschneid@redhat.com,
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
Message-ID: <20220902194839.xqzgsoowous72jkz@moria.home.lan>
References: <20220831101948.f3etturccmp5ovkl@suse.de>
 <Yw88RFuBgc7yFYxA@dhcp22.suse.cz>
 <20220831190154.qdlsxfamans3ya5j@moria.home.lan>
 <CAJD7tkaev9B=UDYj2RL6pz-1454J8tv4gEr9y-2dnCksoLK0bw@mail.gmail.com>
 <YxExz+c1k3nbQMh4@P9FQF9L96D.corp.robot.car>
 <20220901223720.e4gudprscjtwltif@moria.home.lan>
 <YxE4BXw5i+BkxxD8@P9FQF9L96D.corp.robot.car>
 <20220902001747.qqsv2lzkuycffuqe@moria.home.lan>
 <YxFWrka+Wx0FfLXU@P9FQF9L96D.lan>
 <3a41b9fc-05f1-3f56-ecd0-70b9a2912a31@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3a41b9fc-05f1-3f56-ecd0-70b9a2912a31@kernel.dk>
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

On Fri, Sep 02, 2022 at 06:02:12AM -0600, Jens Axboe wrote:
> On 9/1/22 7:04 PM, Roman Gushchin wrote:
> > On Thu, Sep 01, 2022 at 08:17:47PM -0400, Kent Overstreet wrote:
> >> On Thu, Sep 01, 2022 at 03:53:57PM -0700, Roman Gushchin wrote:
> >>> I'd suggest to run something like iperf on a fast hardware. And maybe some
> >>> io_uring stuff too. These are two places which were historically most sensitive
> >>> to the (kernel) memory accounting speed.
> >>
> >> I'm getting wildly inconsistent results with iperf.
> >>
> >> io_uring-echo-server and rust_echo_bench gets me:
> >> Benchmarking: 127.0.0.1:12345
> >> 50 clients, running 512 bytes, 60 sec.
> >>
> >> Without alloc tagging:	120547 request/sec
> >> With:			116748 request/sec
> >>
> >> https://github.com/frevib/io_uring-echo-server
> >> https://github.com/haraldh/rust_echo_bench
> >>
> >> How's that look to you? Close enough? :)
> > 
> > Yes, this looks good (a bit too good).
> > 
> > I'm not that familiar with io_uring, Jens and Pavel should have a better idea
> > what and how to run (I know they've workarounded the kernel memory accounting
> > because of the performance in the past, this is why I suspect it might be an
> > issue here as well).
> 
> io_uring isn't alloc+free intensive on a per request basis anymore, it
> would not be a good benchmark if the goal is to check for regressions in
> that area.

Good to know. The benchmark is still a TCP benchmark though, so still useful.

Matthew suggested
  while true; do echo 1 >/tmp/foo; rm /tmp/foo; done

I ran that on tmpfs, and the numbers with and without alloc tagging were
statistically equal - there was a fair amount of variation, it wasn't a super
controlled test, anywhere from 38-41 seconds with 100000 iterations (and alloc
tagging was some of the faster runs).

But with memcg off, it ran in 32-33 seconds. We're piggybacking on the same
mechanism memcg uses for stashing per-object pointers, so it looks like that's
the bigger cost.
