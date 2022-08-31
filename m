Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C08BB5A7B3B
	for <lists+io-uring@lfdr.de>; Wed, 31 Aug 2022 12:20:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbiHaKUA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 31 Aug 2022 06:20:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230160AbiHaKT5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 31 Aug 2022 06:19:57 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2857912D3A;
        Wed, 31 Aug 2022 03:19:56 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 4C44B1FA26;
        Wed, 31 Aug 2022 10:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1661941194; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MGhHW6rYwZ48K8Xu0V7K4ggzBnb/NvfN0ZoK0gCAlbg=;
        b=xpV4nSzhu6hvYfjU/RLa/UyemQVmGwiOcDFsrJdhN97teD4R9U9wjv5LdPHR1gp6HxZHrR
        FuW3p4ucqUMUwZb45aW7yTZl3JtVfhUQLK0ZspCBA49v5PTxSs3KgEJ1zQrfNzrY2q8f4S
        /dKh99Nx5lVJ58bV5Rkgoeu5X/hmj10=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1661941194;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MGhHW6rYwZ48K8Xu0V7K4ggzBnb/NvfN0ZoK0gCAlbg=;
        b=MQGQw9Blw5WX5WebctrJKgEeQJwREstTopCuw8w6jMH4yRF3LbubiWsssQhgo9xhnEFLYy
        ZeYNgM1N1XvLnJAQ==
Received: from suse.de (unknown [10.163.43.106])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 085222C141;
        Wed, 31 Aug 2022 10:19:49 +0000 (UTC)
Date:   Wed, 31 Aug 2022 11:19:48 +0100
From:   Mel Gorman <mgorman@suse.de>
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     Peter Zijlstra <peterz@infradead.org>,
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
Message-ID: <20220831101948.f3etturccmp5ovkl@suse.de>
References: <20220830214919.53220-1-surenb@google.com>
 <Yw8P8xZ4zqu121xL@hirez.programming.kicks-ass.net>
 <20220831084230.3ti3vitrzhzsu3fs@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20220831084230.3ti3vitrzhzsu3fs@moria.home.lan>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Aug 31, 2022 at 04:42:30AM -0400, Kent Overstreet wrote:
> On Wed, Aug 31, 2022 at 09:38:27AM +0200, Peter Zijlstra wrote:
> > On Tue, Aug 30, 2022 at 02:48:49PM -0700, Suren Baghdasaryan wrote:
> > > ===========================
> > > Code tagging framework
> > > ===========================
> > > Code tag is a structure identifying a specific location in the source code
> > > which is generated at compile time and can be embedded in an application-
> > > specific structure. Several applications of code tagging are included in
> > > this RFC, such as memory allocation tracking, dynamic fault injection,
> > > latency tracking and improved error code reporting.
> > > Basically, it takes the old trick of "define a special elf section for
> > > objects of a given type so that we can iterate over them at runtime" and
> > > creates a proper library for it.
> > 
> > I might be super dense this morning, but what!? I've skimmed through the
> > set and I don't think I get it.
> > 
> > What does this provide that ftrace/kprobes don't already allow?
> 
> You're kidding, right?

It's a valid question. From the description, it main addition that would
be hard to do with ftrace or probes is catching where an error code is
returned. A secondary addition would be catching all historical state and
not just state since the tracing started.

It's also unclear *who* would enable this. It looks like it would mostly
have value during the development stage of an embedded platform to track
kernel memory usage on a per-application basis in an environment where it
may be difficult to setup tracing and tracking. Would it ever be enabled
in production? Would a distribution ever enable this? If it's enabled, any
overhead cannot be disabled/enabled at run or boot time so anyone enabling
this would carry the cost without never necessarily consuming the data.

It might be an ease-of-use thing. Gathering the information from traces
is tricky and would need combining multiple different elements and that
is development effort but not impossible.

Whatever asking for an explanation as to why equivalent functionality
cannot not be created from ftrace/kprobe/eBPF/whatever is reasonable.

-- 
Mel Gorman
SUSE Labs
