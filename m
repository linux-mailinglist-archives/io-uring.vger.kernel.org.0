Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 946EF5A9A50
	for <lists+io-uring@lfdr.de>; Thu,  1 Sep 2022 16:30:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234582AbiIAO35 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Sep 2022 10:29:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234743AbiIAO3y (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Sep 2022 10:29:54 -0400
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F55DB05;
        Thu,  1 Sep 2022 07:29:46 -0700 (PDT)
Date:   Thu, 1 Sep 2022 10:29:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1662042584;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=M1aDaZlKYEwz8CxoGUE2hJszPL7mnQtqrJRQw3RcAgQ=;
        b=IK9QhIOZDhvhIHgjJAvozZeyNVUxpRDuv2a80UYwf9PmUNDsSXvx244cHMitGbjR3T3iGp
        7sTtqClKi3PdI+46+oiLp/x5eTOLPULJGYd7PsGYsaj8KjDdrdJudl3cyWqngQc55MFiX/
        TzPtdYtHcCsYBcEyFw2g+cdlpMBvH8I=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Mel Gorman <mgorman@suse.de>,
        Suren Baghdasaryan <surenb@google.com>,
        akpm@linux-foundation.org, mhocko@suse.com, vbabka@suse.cz,
        hannes@cmpxchg.org, roman.gushchin@linux.dev, dave@stgolabs.net,
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
Message-ID: <20220901142937.vsnq62e6gqytyth2@moria.home.lan>
References: <20220830214919.53220-1-surenb@google.com>
 <Yw8P8xZ4zqu121xL@hirez.programming.kicks-ass.net>
 <20220831084230.3ti3vitrzhzsu3fs@moria.home.lan>
 <20220831101948.f3etturccmp5ovkl@suse.de>
 <YxBYgcyP7IvMLJwq@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YxBYgcyP7IvMLJwq@hirez.programming.kicks-ass.net>
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

On Thu, Sep 01, 2022 at 09:00:17AM +0200, Peter Zijlstra wrote:
> On Wed, Aug 31, 2022 at 11:19:48AM +0100, Mel Gorman wrote:
> 
> > It's also unclear *who* would enable this. It looks like it would mostly
> > have value during the development stage of an embedded platform to track
> > kernel memory usage on a per-application basis in an environment where it
> > may be difficult to setup tracing and tracking. Would it ever be enabled
> > in production? 
> 
> Afaict this is developer only; it is all unconditional code.
> 
> > Would a distribution ever enable this? 
> 
> I would sincerely hope not. Because:
> 
> > If it's enabled, any overhead cannot be disabled/enabled at run or
> > boot time so anyone enabling this would carry the cost without never
> > necessarily consuming the data.
> 
> this.

We could make it a boot parameter, with the alternatives infrastructure - with a
bit of refactoring there'd be a single function call to nop out, and then we
could also drop the elf sections as well, so that when built in but disabled the
overhead would be practically nil.
