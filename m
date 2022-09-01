Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29F355A9A37
	for <lists+io-uring@lfdr.de>; Thu,  1 Sep 2022 16:27:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234797AbiIAOYi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Sep 2022 10:24:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234722AbiIAOYP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Sep 2022 10:24:15 -0400
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 514294DB07;
        Thu,  1 Sep 2022 07:23:55 -0700 (PDT)
Date:   Thu, 1 Sep 2022 10:23:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1662042233;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JsB2G8WqLnYprEF0GcA9GFFIGkQht/MFH67dN0NC9t0=;
        b=P+qdlVJWY093c1JvjMpoBsAhuM3mvnI3jUKrYjXhcXjA7JDkTxBBu4A2hC17CCO8ZZ5R3D
        rLH5U4BLaxZ5HSxD5hP6U1jUXGFLfAJiihxtZ+Hfa0QaSzmc2WzHuvOvPKzjVyoQ9DuTBc
        CcLrAriFlVtUQ4Ne/7Ga0hI19yi31Mw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     David Hildenbrand <david@redhat.com>
Cc:     Michal Hocko <mhocko@suse.com>, Mel Gorman <mgorman@suse.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Suren Baghdasaryan <surenb@google.com>,
        akpm@linux-foundation.org, vbabka@suse.cz, hannes@cmpxchg.org,
        roman.gushchin@linux.dev, dave@stgolabs.net, willy@infradead.org,
        liam.howlett@oracle.com, void@manifault.com, juri.lelli@redhat.com,
        ldufour@linux.ibm.com, peterx@redhat.com, axboe@kernel.dk,
        mcgrof@kernel.org, masahiroy@kernel.org, nathan@kernel.org,
        changbin.du@intel.com, ytcoode@gmail.com,
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
Message-ID: <20220901142345.agkfp2d5lijdp6pt@moria.home.lan>
References: <20220830214919.53220-1-surenb@google.com>
 <Yw8P8xZ4zqu121xL@hirez.programming.kicks-ass.net>
 <20220831084230.3ti3vitrzhzsu3fs@moria.home.lan>
 <20220831101948.f3etturccmp5ovkl@suse.de>
 <Yw88RFuBgc7yFYxA@dhcp22.suse.cz>
 <20220831190154.qdlsxfamans3ya5j@moria.home.lan>
 <404e947a-e1b2-0fae-8b4f-6f2e3ba6328d@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <404e947a-e1b2-0fae-8b4f-6f2e3ba6328d@redhat.com>
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

On Thu, Sep 01, 2022 at 10:05:03AM +0200, David Hildenbrand wrote:
> On 31.08.22 21:01, Kent Overstreet wrote:
> > On Wed, Aug 31, 2022 at 12:47:32PM +0200, Michal Hocko wrote:
> >> On Wed 31-08-22 11:19:48, Mel Gorman wrote:
> >>> Whatever asking for an explanation as to why equivalent functionality
> >>> cannot not be created from ftrace/kprobe/eBPF/whatever is reasonable.
> >>
> >> Fully agreed and this is especially true for a change this size
> >> 77 files changed, 3406 insertions(+), 703 deletions(-)
> > 
> > In the case of memory allocation accounting, you flat cannot do this with ftrace
> > - you could maybe do a janky version that isn't fully accurate, much slower,
> > more complicated for the developer to understand and debug and more complicated
> > for the end user.
> > 
> > But please, I invite anyone who's actually been doing this with ftrace to
> > demonstrate otherwise.
> > 
> > Ftrace just isn't the right tool for the job here - we're talking about adding
> > per callsite accounting to some of the fastest fast paths in the kernel.
> > 
> > And the size of the changes for memory allocation accounting are much more
> > reasonable:
> >  33 files changed, 623 insertions(+), 99 deletions(-)
> > 
> > The code tagging library should exist anyways, it's been open coded half a dozen
> > times in the kernel already.
> 
> Hi Kent,
> 
> independent of the other discussions, if it's open coded already, does
> it make sense to factor that already-open-coded part out independently
> of the remainder of the full series here?

It's discussed in the cover letter, that is exactly how the patch series is
structured.
 
> [I didn't immediately spot if this series also attempts already to
> replace that open-coded part]

Uh huh.

Honestly, some days it feels like lkml is just as bad as slashdot, with people
wanting to get in their two cents without actually reading...
