Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC9A65AA3CC
	for <lists+io-uring@lfdr.de>; Fri,  2 Sep 2022 01:37:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235163AbiIAXgk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Sep 2022 19:36:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235124AbiIAXgi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Sep 2022 19:36:38 -0400
Received: from mail-yw1-x112e.google.com (mail-yw1-x112e.google.com [IPv6:2607:f8b0:4864:20::112e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 363D6A4056
        for <io-uring@vger.kernel.org>; Thu,  1 Sep 2022 16:36:36 -0700 (PDT)
Received: by mail-yw1-x112e.google.com with SMTP id 00721157ae682-3413ad0640dso2006627b3.13
        for <io-uring@vger.kernel.org>; Thu, 01 Sep 2022 16:36:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=5pc1SgOf8Owl6sShRuirH1QWrWtPdJIgt3qepozMpkE=;
        b=QPtBN+jZZjR+fJQ+f+TgwZFy47TE1rR8gr1i8rB6mNu2nigO0JdCAAjMoUMaOVDYnd
         PiHulcKqQEwjGxjDADddZzXOUg5TYr/Y37FY0mLnlnZh9oqDpuWtb21NiE8K+MvKfMRy
         5X2JycO4tSVca0qzV4Yx+TBoNNmpSKbKbCfgMYwA7K5CFp+VszB2v0xi3C2mZ4ZpAFpk
         VGoNBkpcZXTh7tuDysjYq/uSfLBayYSiQwhTFjGtzTF3WK2rRSdy71A7E9l9S18szgn+
         hw0Qy3jClG1SDJCQ3AEQ+kyF5TgjSC7WKM1l7PFAPgZmXyevNIAyCBELnZOO/Zt3zo42
         CuWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=5pc1SgOf8Owl6sShRuirH1QWrWtPdJIgt3qepozMpkE=;
        b=f5SAyniSzMORj2w672MigKTQNJcN5XhPZixJCjNW2AQNeS9PS0XPQbOQwTj9Vr3qs1
         U6w/y6rffHYhU7bVbB4/6lP/0VhC2ynFVQH7RIy6ncBrebgOMu/eyiUAC1ITsX/XKiHi
         9SoE/em2JGO9ABrmxcDqdgk0hntX3jYz0ynS3wIQV2qtnGh9rX8k0sznc1Jqdd7QGwmr
         QPM0nT6gyeoovBkquBmtVwdc+cdQMAuMOaVpjphU/kG3GOYLvll1p2Ew9FQY2NMvlf9F
         PTRNj5wA5s07ipq3T6U1V1UCP4auoN+1kGF8V2wRINqRcohwxGu2Bt5yS0ZYDzTNrGIe
         yWOA==
X-Gm-Message-State: ACgBeo1HaYnTj9+xMqU+x3916QFoCZoXdLX8JWP2Osz4E3V3ayJUBQBW
        WYvxImAFUzyi6FcOCAqQZVWBw1MaiTvtul4g5Mc+bA==
X-Google-Smtp-Source: AA6agR6KXscPx8LI6183+UcafzSZSBU2Me59d4tUPUgAjsDK3Cl3Xie4I9qREIbKygjbUBWHlz0pZa86okKUwdzJLtw=
X-Received: by 2002:a0d:c981:0:b0:330:dc03:7387 with SMTP id
 l123-20020a0dc981000000b00330dc037387mr25216063ywd.380.1662075395130; Thu, 01
 Sep 2022 16:36:35 -0700 (PDT)
MIME-Version: 1.0
References: <20220830214919.53220-1-surenb@google.com> <Yw8P8xZ4zqu121xL@hirez.programming.kicks-ass.net>
 <20220831084230.3ti3vitrzhzsu3fs@moria.home.lan> <20220831101948.f3etturccmp5ovkl@suse.de>
 <Yw88RFuBgc7yFYxA@dhcp22.suse.cz> <20220831190154.qdlsxfamans3ya5j@moria.home.lan>
 <CAJD7tkaev9B=UDYj2RL6pz-1454J8tv4gEr9y-2dnCksoLK0bw@mail.gmail.com>
 <YxExz+c1k3nbQMh4@P9FQF9L96D.corp.robot.car> <20220901223720.e4gudprscjtwltif@moria.home.lan>
 <YxE4BXw5i+BkxxD8@P9FQF9L96D.corp.robot.car>
In-Reply-To: <YxE4BXw5i+BkxxD8@P9FQF9L96D.corp.robot.car>
From:   Suren Baghdasaryan <surenb@google.com>
Date:   Thu, 1 Sep 2022 16:36:23 -0700
Message-ID: <CAJuCfpF=67THWzoE+TGW_VbBHMRvuC5BVVGnkLPmKtG3ZuS2Jw@mail.gmail.com>
Subject: Re: [RFC PATCH 00/30] Code tagging framework and applications
To:     Roman Gushchin <roman.gushchin@linux.dev>
Cc:     Kent Overstreet <kent.overstreet@linux.dev>,
        Yosry Ahmed <yosryahmed@google.com>,
        Michal Hocko <mhocko@suse.com>, Mel Gorman <mgorman@suse.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>,
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
        Marco Elver <elver@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
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
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Sep 1, 2022 at 3:54 PM Roman Gushchin <roman.gushchin@linux.dev> wrote:
>
> On Thu, Sep 01, 2022 at 06:37:20PM -0400, Kent Overstreet wrote:
> > On Thu, Sep 01, 2022 at 03:27:27PM -0700, Roman Gushchin wrote:
> > > On Wed, Aug 31, 2022 at 01:56:08PM -0700, Yosry Ahmed wrote:
> > > > This is very interesting work! Do you have any data about the overhead
> > > > this introduces, especially in a production environment? I am
> > > > especially interested in memory allocations tracking and detecting
> > > > leaks.
> > >
> > > +1
> > >
> > > I think the question whether it indeed can be always turned on in the production
> > > or not is the main one. If not, the advantage over ftrace/bpf/... is not that
> > > obvious. Otherwise it will be indeed a VERY useful thing.
> >
> > Low enough overhead to run in production was my primary design goal.
> >
> > Stats are kept in a struct that's defined at the callsite. So this adds _no_
> > pointer chasing to the allocation path, unless we've switch to percpu counters
> > at that callsite (see the lazy percpu counters patch), where we need to deref
> > one percpu pointer to save an atomic.
> >
> > Then we need to stash a pointer to the alloc_tag, so that kfree() can find it.
> > For slab allocations this uses the same storage area as memcg, so for
> > allocations that are using that we won't be touching any additional cachelines.
> > (I wanted the pointer to the alloc_tag to be stored inline with the allocation,
> > but that would've caused alignment difficulties).
> >
> > Then there's a pointer deref introduced to the kfree() path, to get back to the
> > original alloc_tag and subtract the allocation from that callsite. That one
> > won't be free, and with percpu counters we've got another dependent load too -
> > hmm, it might be worth benchmarking with just atomics, skipping the percpu
> > counters.
> >
> > So the overhead won't be zero, I expect it'll show up in some synthetic
> > benchmarks, but yes I do definitely expect this to be worth enabling in
> > production in many scenarios.
>
> I'm somewhat sceptical, but I usually am. And in this case I'll be really happy
> to be wrong.
>
> On a bright side, maybe most of the overhead will come from few allocations,
> so an option to explicitly exclude them will do the trick.
>
> I'd suggest to run something like iperf on a fast hardware. And maybe some
> io_uring stuff too. These are two places which were historically most sensitive
> to the (kernel) memory accounting speed.

Thanks for the suggestions, Roman. I'll see how I can get this done.
I'll have to find someone with access to fast hardware (Android is not
great for that) and backporting the patchset to the supported kernel
version. Will do my best.
Thanks,
Suren.

>
> Thanks!
>
> --
> To unsubscribe from this group and stop receiving emails from it, send an email to kernel-team+unsubscribe@android.com.
>
