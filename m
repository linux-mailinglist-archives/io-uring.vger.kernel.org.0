Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5AD45A9BF3
	for <lists+io-uring@lfdr.de>; Thu,  1 Sep 2022 17:45:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232065AbiIAPnn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Sep 2022 11:43:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232994AbiIAPnf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Sep 2022 11:43:35 -0400
Received: from out1.migadu.com (out1.migadu.com [91.121.223.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E261719AC;
        Thu,  1 Sep 2022 08:43:31 -0700 (PDT)
Date:   Thu, 1 Sep 2022 11:43:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1662047009;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OCuFL4N5GVZjONQAdChOE7OJr7ThTUJDCIIbzLkwFEk=;
        b=Zug2Ft4Qd/net99BOTd8W8Yfuju//gSHL3gkzYXZLEVciKsEhf1UkIyXgrPgVXlVt/CoSK
        WIJngXjsqZ/WvBYvq+hwDukTtw4VIC1L39QDy0ARuz5vTfzc62/XGVpvD13hkozhflqLO3
        W0o6TaATn9DtFDXStAFl/opHuur0FVU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Suren Baghdasaryan <surenb@google.com>,
        akpm@linux-foundation.org, mhocko@suse.com, vbabka@suse.cz,
        hannes@cmpxchg.org, roman.gushchin@linux.dev, mgorman@suse.de,
        dave@stgolabs.net, willy@infradead.org, liam.howlett@oracle.com,
        void@manifault.com, juri.lelli@redhat.com, ldufour@linux.ibm.com,
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
Subject: Re: [RFC PATCH 03/30] Lazy percpu counters
Message-ID: <20220901154321.apyq7246srkjthfr@moria.home.lan>
References: <20220830214919.53220-1-surenb@google.com>
 <20220830214919.53220-4-surenb@google.com>
 <YxBWczNCbZbj+reQ@hirez.programming.kicks-ass.net>
 <20220901143219.n7jg7cbp47agqnwn@moria.home.lan>
 <20220901104839.5691e1c9@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220901104839.5691e1c9@gandalf.local.home>
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

On Thu, Sep 01, 2022 at 10:48:39AM -0400, Steven Rostedt wrote:
> On Thu, 1 Sep 2022 10:32:19 -0400
> Kent Overstreet <kent.overstreet@linux.dev> wrote:
> 
> > On Thu, Sep 01, 2022 at 08:51:31AM +0200, Peter Zijlstra wrote:
> > > On Tue, Aug 30, 2022 at 02:48:52PM -0700, Suren Baghdasaryan wrote:  
> > > > +static void lazy_percpu_counter_switch_to_pcpu(struct raw_lazy_percpu_counter *c)
> > > > +{
> > > > +	u64 __percpu *pcpu_v = alloc_percpu_gfp(u64, GFP_ATOMIC|__GFP_NOWARN);  
> > > 
> > > Realize that this is incorrect when used under a raw_spinlock_t.  
> > 
> > Can you elaborate?
> 
> All allocations (including GFP_ATOMIC) grab normal spin_locks. When
> PREEMPT_RT is configured, normal spin_locks turn into a mutex, where as
> raw_spinlock's do not.
> 
> Thus, if this is done within a raw_spinlock with PREEMPT_RT configured, it
> can cause a schedule while holding a spinlock.

Thanks, I think we should be good here but I'll document it anyways.
