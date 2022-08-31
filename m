Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9C0C5A793B
	for <lists+io-uring@lfdr.de>; Wed, 31 Aug 2022 10:43:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbiHaInP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 31 Aug 2022 04:43:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231578AbiHaImv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 31 Aug 2022 04:42:51 -0400
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCA9FC228D;
        Wed, 31 Aug 2022 01:42:40 -0700 (PDT)
Date:   Wed, 31 Aug 2022 04:42:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1661935359;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mmxSzJIEbF0byhuM+VO8IRNgyEUbvUgCaJEiam4Pxpk=;
        b=n/WRdO6wsbcgzM9IZmiTOpoQilc55+w4Qjuqwl1Dpnv4eEgQ85RLBu7SGRYgk8JFEOmxmG
        9NkKta+Gf2utqPzv5rM3bIlfQN3qtDLursIA2MwCGrMNSc7KVtiJCfMkW0/8k5e3nZiAGS
        tjj529y20oHTMERlcuL/JelsPUM2hZU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org,
        mhocko@suse.com, vbabka@suse.cz, hannes@cmpxchg.org,
        roman.gushchin@linux.dev, mgorman@suse.de, dave@stgolabs.net,
        willy@infradead.org, liam.howlett@oracle.com, void@manifault.com,
        juri.lelli@redhat.com, ldufour@linux.ibm.com, peterx@redhat.com,
        david@redhat.com, axboe@kernel.dk, mcgrof@kernel.org,
        masahiroy@kernel.org, nathan@kernel.org, changbin.du@intel.com,
        ytcoode@gmail.com, vincent.guittot@linaro.org,
        dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com,
        bristot@redhat.com, vschneid@redhat.com, cl@linux.com,
        penberg@kernel.org, iamjoonsoo.kim@lge.com, 42.hyeyoo@gmail.com,
        glider@google.com, elver@google.com, dvyukov@google.com,
        shakeelb@google.com, songmuchun@bytedance.com, arnd@arndb.de,
        jbaron@akamai.com, rientjes@google.com, minchan@google.com,
        kaleshsingh@google.com, kernel-team@android.com,
        linux-mm@kvack.org, iommu@lists.linux.dev,
        kasan-dev@googlegroups.com, io-uring@vger.kernel.org,
        linux-arch@vger.kernel.org, xen-devel@lists.xenproject.org,
        linux-bcache@vger.kernel.org, linux-modules@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 00/30] Code tagging framework and applications
Message-ID: <20220831084230.3ti3vitrzhzsu3fs@moria.home.lan>
References: <20220830214919.53220-1-surenb@google.com>
 <Yw8P8xZ4zqu121xL@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yw8P8xZ4zqu121xL@hirez.programming.kicks-ass.net>
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

On Wed, Aug 31, 2022 at 09:38:27AM +0200, Peter Zijlstra wrote:
> On Tue, Aug 30, 2022 at 02:48:49PM -0700, Suren Baghdasaryan wrote:
> > ===========================
> > Code tagging framework
> > ===========================
> > Code tag is a structure identifying a specific location in the source code
> > which is generated at compile time and can be embedded in an application-
> > specific structure. Several applications of code tagging are included in
> > this RFC, such as memory allocation tracking, dynamic fault injection,
> > latency tracking and improved error code reporting.
> > Basically, it takes the old trick of "define a special elf section for
> > objects of a given type so that we can iterate over them at runtime" and
> > creates a proper library for it.
> 
> I might be super dense this morning, but what!? I've skimmed through the
> set and I don't think I get it.
> 
> What does this provide that ftrace/kprobes don't already allow?

You're kidding, right?
