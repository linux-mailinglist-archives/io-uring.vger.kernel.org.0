Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A109B5A865C
	for <lists+io-uring@lfdr.de>; Wed, 31 Aug 2022 21:02:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232600AbiHaTCc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 31 Aug 2022 15:02:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232536AbiHaTCN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 31 Aug 2022 15:02:13 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95EF4CB5E0;
        Wed, 31 Aug 2022 12:02:05 -0700 (PDT)
Date:   Wed, 31 Aug 2022 15:01:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1661972523;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/S1Z12zwQROoKfTz1twMnESk8KqrSv9O32o/CoebBns=;
        b=sF/L6ogajTfppllZKwsY3yAp/F+VbzSHnCHZx0MwHJq3wLBzznsc7Lb2ZsCP4rEQgcNT28
        rLvWmn6gmqWCcSF6VIihZIZ70OK4+CXbASmvLSrwtHuf1uHUi1DngGVeWjfIGxIWF0Ihh2
        Si0kCu7ZLzOp8dHrcYN8kmqyIqxg/Wk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Michal Hocko <mhocko@suse.com>
Cc:     Mel Gorman <mgorman@suse.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Suren Baghdasaryan <surenb@google.com>,
        akpm@linux-foundation.org, vbabka@suse.cz, hannes@cmpxchg.org,
        roman.gushchin@linux.dev, dave@stgolabs.net, willy@infradead.org,
        liam.howlett@oracle.com, void@manifault.com, juri.lelli@redhat.com,
        ldufour@linux.ibm.com, peterx@redhat.com, david@redhat.com,
        axboe@kernel.dk, mcgrof@kernel.org, masahiroy@kernel.org,
        nathan@kernel.org, changbin.du@intel.com, ytcoode@gmail.com,
        vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
        rostedt@goodmis.org, bsegall@google.com, bristot@redhat.com,
        vschneid@redhat.com, cl@linux.com, penberg@kernel.org,
        iamjoonsoo.kim@lge.com, 42.hyeyoo@gmail.com, glider@google.com,
        elver@google.com, dvyukov@google.com, shakeelb@google.com,
        songmuchun@bytedance.com, arnd@arndb.de, jbaron@akamai.com,
        rientjes@google.com, minchan@google.com, kaleshsingh@google.com,
        kernel-team@android.com, linux-mm@kvack.org, iommu@lists.linux.dev,
        kasan-dev@googlegroups.com, io-uring@vger.kernel.org,
        linux-arch@vger.kernel.org, xen-devel@lists.xenproject.org,
        linux-bcache@vger.kernel.org, linux-modules@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 00/30] Code tagging framework and applications
Message-ID: <20220831190154.qdlsxfamans3ya5j@moria.home.lan>
References: <20220830214919.53220-1-surenb@google.com>
 <Yw8P8xZ4zqu121xL@hirez.programming.kicks-ass.net>
 <20220831084230.3ti3vitrzhzsu3fs@moria.home.lan>
 <20220831101948.f3etturccmp5ovkl@suse.de>
 <Yw88RFuBgc7yFYxA@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yw88RFuBgc7yFYxA@dhcp22.suse.cz>
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

On Wed, Aug 31, 2022 at 12:47:32PM +0200, Michal Hocko wrote:
> On Wed 31-08-22 11:19:48, Mel Gorman wrote:
> > Whatever asking for an explanation as to why equivalent functionality
> > cannot not be created from ftrace/kprobe/eBPF/whatever is reasonable.
> 
> Fully agreed and this is especially true for a change this size
> 77 files changed, 3406 insertions(+), 703 deletions(-)

In the case of memory allocation accounting, you flat cannot do this with ftrace
- you could maybe do a janky version that isn't fully accurate, much slower,
more complicated for the developer to understand and debug and more complicated
for the end user.

But please, I invite anyone who's actually been doing this with ftrace to
demonstrate otherwise.

Ftrace just isn't the right tool for the job here - we're talking about adding
per callsite accounting to some of the fastest fast paths in the kernel.

And the size of the changes for memory allocation accounting are much more
reasonable:
 33 files changed, 623 insertions(+), 99 deletions(-)

The code tagging library should exist anyways, it's been open coded half a dozen
times in the kernel already.

And once we've got that, the time stats code is _also_ far simpler than doing it
with ftrace would be. If anyone here has successfully debugged latency issues
with ftrace, I'd really like to hear it. Again, for debugging latency issues you
want something that can always be on, and that's not cheap with ftrace - and
never mind the hassle of correlating start and end wait trace events, builting
up histograms, etc. - that's all handled here.

Cheap, simple, easy to use. What more could you want?
