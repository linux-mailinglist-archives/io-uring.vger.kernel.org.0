Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEF065AA565
	for <lists+io-uring@lfdr.de>; Fri,  2 Sep 2022 03:59:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232014AbiIBB7E (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Sep 2022 21:59:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229839AbiIBB7E (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Sep 2022 21:59:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3516A98F4;
        Thu,  1 Sep 2022 18:59:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8C6ACB8298F;
        Fri,  2 Sep 2022 01:59:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 171BAC433C1;
        Fri,  2 Sep 2022 01:58:53 +0000 (UTC)
Date:   Thu, 1 Sep 2022 21:59:25 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Kent Overstreet <kent.overstreet@linux.dev>
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
Message-ID: <20220901215925.59ae5cb0@gandalf.local.home>
In-Reply-To: <20220902013532.6n5cyf3oofntljho@moria.home.lan>
References: <20220830214919.53220-1-surenb@google.com>
        <20220830214919.53220-28-surenb@google.com>
        <20220901173844.36e1683c@gandalf.local.home>
        <20220901215438.gy3bgqa4ghhm6ztm@moria.home.lan>
        <20220901183430.120311ce@gandalf.local.home>
        <20220901225515.ogg7pyljmfzezamr@moria.home.lan>
        <20220901202311.546a53b5@gandalf.local.home>
        <20220902013532.6n5cyf3oofntljho@moria.home.lan>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, 1 Sep 2022 21:35:32 -0400
Kent Overstreet <kent.overstreet@linux.dev> wrote:

> On Thu, Sep 01, 2022 at 08:23:11PM -0400, Steven Rostedt wrote:
> > If ftrace, perf, bpf can't do what you want, take a harder look to see if
> > you can modify them to do so.  
> 
> Maybe we can use this exchange to make both of our tools better. I like your
> histograms - the quantiles algorithm I've had for years is janky, I've been
> meaning to rip that out, I'd love to take a look at your code for that. And
> having an on/off switch is a good idea, I'll try to add that at some point.
> Maybe you got some ideas from my stuff too.
> 
> I'd love to get better tracepoints for measuring latency - what I added to
> init_wait() and finish_wait() was really only a starting point. Figuring out
> the right places to measure is where I'd like to be investing my time in this
> area, and there's no reason we couldn't both be making use of that.

Yes, this is exactly what I'm talking about. I'm not against your work, I
just want you to work more with everyone to come up with ideas that can
help everyone as a whole. That's how "open source communities" is suppose
to work ;-)

The histogram and synthetic events can use some more clean ups. There's a
lot of places that can be improved in that code. But I feel the ideas
behind that code is sound. It's just getting the implementation to be a bit
more efficient.

> 
> e.g. with kernel waitqueues, I looked at hooking prepare_to_wait() first but not
> all code uses that, init_wait() got me better coverage. But I've already seen
> that that misses things, too, there's more work to be done.

I picked prepare_to_wait() just because I was hacking up something quick
and thought that was "close enough" ;-)

-- Steve

