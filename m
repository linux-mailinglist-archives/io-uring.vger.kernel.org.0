Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDAC75A8831
	for <lists+io-uring@lfdr.de>; Wed, 31 Aug 2022 23:38:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231210AbiHaViZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 31 Aug 2022 17:38:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbiHaViW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 31 Aug 2022 17:38:22 -0400
Received: from mail-yw1-x1132.google.com (mail-yw1-x1132.google.com [IPv6:2607:f8b0:4864:20::1132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A098EBC817
        for <io-uring@vger.kernel.org>; Wed, 31 Aug 2022 14:38:20 -0700 (PDT)
Received: by mail-yw1-x1132.google.com with SMTP id 00721157ae682-33dc31f25f9so319332677b3.11
        for <io-uring@vger.kernel.org>; Wed, 31 Aug 2022 14:38:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=6E7G6kJMNs5Us6NEnCBcT2HO6AKiMVb4bH/0vpPA/4U=;
        b=kAtSEhj7BWkD6SMRdd1t39qS+hQKouRS4qaWZ/zCB6oGUrFNrc2cBDYGv9jQ+MdF0J
         uxQpVt2B9TyIrWXDxJ2lE/5kGqIlaGR3KL1ZUwaFBmwiXzmcYyLDuUovokIJ5gP+z9l0
         0yNTpmhlKudmxd6FSbYJNy7iPqg2dLLVGTx3y1J7sDru+O7/1p0gaM3HCn5KVfOBeHdH
         7y51BAxidLFb2zqNvKSOOe8d+T3vU43qoJCQXNWAECkcBOpBA8zLImxhZz3blz38Sv8b
         A0VOTCczeuCjB41nhG0Ij40swVSwGGlY/9vVEbUAh5KhCZEJca7FVQKBTYw0uiQMXn3I
         8fkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=6E7G6kJMNs5Us6NEnCBcT2HO6AKiMVb4bH/0vpPA/4U=;
        b=DbZZV3joHYv69NhZhxxubN9UHuKMUcDNt92ZecOqq7Pi0unI8vdlUZz7CNHPxX6wtr
         pBs68e9BFk+BQKe/VxvRIwElLX/kDOgQsJpKAFVpFjz0QFFN+sbYob7Ipeu4z01ID4Ek
         XjgWWeLjcRaUTKRq16K2cbrB692ZF7VjSzlqtiiev3m0U+g2DSl84UKHM2s0R92nAqmz
         mNc2rhIlMgCTst/tMW534aBnnKMUNTbRlYGAM4V8XIQ6OeDouGSK57Vb1CIkDPs3ngAo
         g+HOrTyXAsU1LY2xzR3I5QQY1Ruy1FYubi46bp/5X5M8Q7JMIzorCF2JyjMkZLdmvo27
         QmTg==
X-Gm-Message-State: ACgBeo0feqAAAZL7HttP8NAUNdRb/W00Pcy1buTLfTkqCKftItBsKhVo
        /Lwjdf6FlBmz5SVRQniW6LgKcpUfGc6d5qN3hUrtJQ==
X-Google-Smtp-Source: AA6agR71/tBRa7ErmmsvPBq7WvGBz62OVsrJ1soclQl+ncNHwGSnn/9fM5Y5i7G0A989GWlS6M/O5IwMTPKxavhJCfc=
X-Received: by 2002:a81:85c3:0:b0:33d:a4d9:4599 with SMTP id
 v186-20020a8185c3000000b0033da4d94599mr19726685ywf.237.1661981899638; Wed, 31
 Aug 2022 14:38:19 -0700 (PDT)
MIME-Version: 1.0
References: <20220830214919.53220-1-surenb@google.com> <Yw8P8xZ4zqu121xL@hirez.programming.kicks-ass.net>
 <20220831084230.3ti3vitrzhzsu3fs@moria.home.lan> <20220831101948.f3etturccmp5ovkl@suse.de>
 <Yw88RFuBgc7yFYxA@dhcp22.suse.cz> <20220831190154.qdlsxfamans3ya5j@moria.home.lan>
 <CAJD7tkaev9B=UDYj2RL6pz-1454J8tv4gEr9y-2dnCksoLK0bw@mail.gmail.com>
In-Reply-To: <CAJD7tkaev9B=UDYj2RL6pz-1454J8tv4gEr9y-2dnCksoLK0bw@mail.gmail.com>
From:   Suren Baghdasaryan <surenb@google.com>
Date:   Wed, 31 Aug 2022 14:38:08 -0700
Message-ID: <CAJuCfpELZBoM8uG9prkra1sJ7tDiy_eF9TwetXSSN3XDssp8CQ@mail.gmail.com>
Subject: Re: [RFC PATCH 00/30] Code tagging framework and applications
To:     Yosry Ahmed <yosryahmed@google.com>
Cc:     Kent Overstreet <kent.overstreet@linux.dev>,
        Michal Hocko <mhocko@suse.com>, Mel Gorman <mgorman@suse.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Matthew Wilcox <willy@infradead.org>,
        "Liam R. Howlett" <liam.howlett@oracle.com>,
        David Vernet <void@manifault.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Laurent Dufour <ldufour@linux.ibm.com>,
        Peter Xu <peterx@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, mcgrof@kernel.org,
        masahiroy@kernel.org, nathan@kernel.org, changbin.du@intel.com,
        ytcoode@gmail.com, Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Benjamin Segall <bsegall@google.com>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Valentin Schneider <vschneid@redhat.com>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, 42.hyeyoo@gmail.com,
        Alexander Potapenko <glider@google.com>,
        Marco Elver <elver@google.com>, dvyukov@google.com,
        Shakeel Butt <shakeelb@google.com>,
        Muchun Song <songmuchun@bytedance.com>, arnd@arndb.de,
        jbaron@akamai.com, David Rientjes <rientjes@google.com>,
        Minchan Kim <minchan@google.com>,
        Kalesh Singh <kaleshsingh@google.com>,
        kernel-team <kernel-team@android.com>,
        Linux-MM <linux-mm@kvack.org>, iommu@lists.linux.dev,
        kasan-dev@googlegroups.com, io-uring@vger.kernel.org,
        linux-arch@vger.kernel.org, xen-devel@lists.xenproject.org,
        linux-bcache@vger.kernel.org, linux-modules@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Aug 31, 2022 at 1:56 PM Yosry Ahmed <yosryahmed@google.com> wrote:
>
> On Wed, Aug 31, 2022 at 12:02 PM Kent Overstreet
> <kent.overstreet@linux.dev> wrote:
> >
> > On Wed, Aug 31, 2022 at 12:47:32PM +0200, Michal Hocko wrote:
> > > On Wed 31-08-22 11:19:48, Mel Gorman wrote:
> > > > Whatever asking for an explanation as to why equivalent functionality
> > > > cannot not be created from ftrace/kprobe/eBPF/whatever is reasonable.
> > >
> > > Fully agreed and this is especially true for a change this size
> > > 77 files changed, 3406 insertions(+), 703 deletions(-)
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
> >
> > And once we've got that, the time stats code is _also_ far simpler than doing it
> > with ftrace would be. If anyone here has successfully debugged latency issues
> > with ftrace, I'd really like to hear it. Again, for debugging latency issues you
> > want something that can always be on, and that's not cheap with ftrace - and
> > never mind the hassle of correlating start and end wait trace events, builting
> > up histograms, etc. - that's all handled here.
> >
> > Cheap, simple, easy to use. What more could you want?
> >
>
> This is very interesting work! Do you have any data about the overhead
> this introduces, especially in a production environment? I am
> especially interested in memory allocations tracking and detecting
> leaks.

I had the numbers for my previous implementation, before we started using the
lazy percpu counters but that would not apply to the new implementation. I'll
rerun the measurements and will post the exact numbers in a day or so.

> (Sorry if you already posted this kind of data somewhere that I missed)
