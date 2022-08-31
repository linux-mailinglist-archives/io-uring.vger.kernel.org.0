Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D59835A8462
	for <lists+io-uring@lfdr.de>; Wed, 31 Aug 2022 19:30:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230288AbiHaRa3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 31 Aug 2022 13:30:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbiHaRa1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 31 Aug 2022 13:30:27 -0400
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2686833352;
        Wed, 31 Aug 2022 10:30:25 -0700 (PDT)
Date:   Wed, 31 Aug 2022 13:30:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1661967023;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=akPUYJQ75fwIwMQFIb22LwWbtwnw5UTZVlPBgEDeTMs=;
        b=vE3CF/hYHXAE/K4932q4ajXNld0qKiFjAcWoi7fiBYp/VCovZl1Zx/Bw+pURhB6ZWUguOM
        yEECHfCMBhWuOS+8pPpB6WgHDKJe+QP39AFR9pm6A02T9tr9GTZUhFMtmSYMptto4Yr//a
        Edg/I2CSqagd7R1KnuqkPz3zjkZJkHU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org,
        mhocko@suse.com, vbabka@suse.cz, hannes@cmpxchg.org,
        roman.gushchin@linux.dev, mgorman@suse.de, dave@stgolabs.net,
        willy@infradead.org, liam.howlett@oracle.com, void@manifault.com,
        peterz@infradead.org, juri.lelli@redhat.com, ldufour@linux.ibm.com,
        peterx@redhat.com, david@redhat.com, axboe@kernel.dk,
        mcgrof@kernel.org, masahiroy@kernel.org, nathan@kernel.org,
        changbin.du@intel.com, ytcoode@gmail.com,
        vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
        rostedt@goodmis.org, bsegall@google.com, bristot@redhat.com,
        vschneid@redhat.com, cl@linux.com, penberg@kernel.org,
        iamjoonsoo.kim@lge.com, 42.hyeyoo@gmail.com, glider@google.com,
        elver@google.com, shakeelb@google.com, songmuchun@bytedance.com,
        arnd@arndb.de, jbaron@akamai.com, rientjes@google.com,
        minchan@google.com, kaleshsingh@google.com,
        kernel-team@android.com, linux-mm@kvack.org, iommu@lists.linux.dev,
        kasan-dev@googlegroups.com, io-uring@vger.kernel.org,
        linux-arch@vger.kernel.org, xen-devel@lists.xenproject.org,
        linux-bcache@vger.kernel.org, linux-modules@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 22/30] Code tagging based fault injection
Message-ID: <20220831173010.wc5j3ycmfjx6ezfu@moria.home.lan>
References: <20220830214919.53220-1-surenb@google.com>
 <20220830214919.53220-23-surenb@google.com>
 <CACT4Y+ZX3U1=cAPXPhoOy6xrngSCfSmyFagXK-9fWtWWODfsew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACT4Y+ZX3U1=cAPXPhoOy6xrngSCfSmyFagXK-9fWtWWODfsew@mail.gmail.com>
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

On Wed, Aug 31, 2022 at 12:37:14PM +0200, Dmitry Vyukov wrote:
> On Tue, 30 Aug 2022 at 23:50, Suren Baghdasaryan <surenb@google.com> wrote:
> >
> > From: Kent Overstreet <kent.overstreet@linux.dev>
> >
> > This adds a new fault injection capability, based on code tagging.
> >
> > To use, simply insert somewhere in your code
> >
> >   dynamic_fault("fault_class_name")
> >
> > and check whether it returns true - if so, inject the error.
> > For example
> >
> >   if (dynamic_fault("init"))
> >       return -EINVAL;
> 
> Hi Suren,
> 
> If this is going to be used by mainline kernel, it would be good to
> integrate this with fail_nth systematic fault injection:
> https://elixir.bootlin.com/linux/latest/source/lib/fault-inject.c#L109
> 
> Otherwise these dynamic sites won't be tested by testing systems doing
> systematic fault injection testing.

That's a discussion we need to have, yeah. We don't want two distinct fault
injection frameworks, we'll have to have a discussion as to whether this is (or
can be) better enough to make a switch worthwhile, and whether a compatibility
interface is needed - or maybe there's enough distinct interesting bits in both
to make merging plausible?

The debugfs interface for this fault injection code is necessarily different
from our existing fault injection - this gives you a fault injection point _per
callsite_, which is huge - e.g. for filesystem testing what I need is to be able
to enable fault injection points within a given module. I can do that easily
with this, not with our current fault injection.

I think the per-callsite fault injection points would also be pretty valuable
for CONFIG_FAULT_INJECTION_USERCOPY, too.

OTOH, existing kernel fault injection can filter based on task - this fault
injection framework doesn't have that. Easy enough to add, though. Similar for
the interval/probability/ratelimit stuff.

fail_function is the odd one out, I'm not sure how that would fit into this
model. Everything else I've seen I think fits into this model.

Also, it sounds like you're more familiar with our existing fault injection than
I am, so if I've misunderstood anything about what it can do please do correct
me.

Interestingly: I just discovered from reading the code that
CONFIG_FAULT_INJECTION_STACKTRACE_FILTER is a thing (hadn't before because it
depends on !X86_64 - what?). That's cool, though.
