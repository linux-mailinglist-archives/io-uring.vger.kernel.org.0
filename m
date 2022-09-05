Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 297425AD8BD
	for <lists+io-uring@lfdr.de>; Mon,  5 Sep 2022 20:03:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbiIESDu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 5 Sep 2022 14:03:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230314AbiIESDt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 5 Sep 2022 14:03:49 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DB8D40557
        for <io-uring@vger.kernel.org>; Mon,  5 Sep 2022 11:03:47 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id m16so1927544ilg.3
        for <io-uring@vger.kernel.org>; Mon, 05 Sep 2022 11:03:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=T67TRgbvL4Ai6kaNg3fck6vcoHVKT+0s4pwJ/NSZTGA=;
        b=cPF8g7Tq5Xr7vWwWPXlAIGbvK841YSQ7JL9eISWcCc1GmuozWN4LmUfAHYFGsC3plp
         xbkMUOOnQhpFxa0XIBosBwjnD4RAr2Kl5FqcTcUiqI63BnVfEWkAAfAMPK2+2D9jC4rI
         SBcZs3gwdK8qGIp1MV9X/fGPGkKuR5qRQqaUNUEfXT08Tya/qRlmc89AlTJ5Ml7Xorrw
         xo1/RpLc8BQEQ206qriFaMJIssLZDxhxOljYpigcvkdlTlPx06einaUW7/uPd1dNz5in
         HXBRJcn7nXiV8BlMPqUAxSW6U9l+lE6gj/Oi85wJcyYJwIvqaZZYLOTvZP+kHnJ13k+5
         7W5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=T67TRgbvL4Ai6kaNg3fck6vcoHVKT+0s4pwJ/NSZTGA=;
        b=nQxRLRgARqZrUabeg3Zy4J2Xtxx1pzcga+CMxzq6Pw3Ys35boMmd4If5/J6SIbo4LY
         OTY+c8oAl/UgPQtumoGQCBye52J06XkYWj2nZx2BQ377LE0YtnQ67HU6HoBawlM5BgCK
         g6LfTjolj2CPwew35BiPXZXQeCIOSgtQtZw7s6vN9QSc6cF0TQSq+uPhDM8q9NYkJXyS
         fOT3qnNs31NQRGVvrOlxsUDvqJMjbEAYL4f26p18C4r/5U0wWY5uQBIJn/tO0N+Gu6PK
         Pb2W0/IB2jO2kNabWZA4/BSbLpXXA9d0t1V2v+f5XG7+JMcLpznCfhHt3KChQm+3lh/D
         Jglg==
X-Gm-Message-State: ACgBeo2eyohLw8KUqD1Tn5clRSiWJSaKymmEU9iZwURRIgeXnUgA/wWx
        C8+SP2mGQlX+iOT0Bh8foaENRqxMMFt5Q3pgW5DWPg==
X-Google-Smtp-Source: AA6agR4B7x+HXZFIStbcPiXGjinnhf/x5VSF8+h0pcx1isIR3eJmYhiMXqo5jfQScJCtZZmLuVhzCMYw0KB/RJ8mvlI=
X-Received: by 2002:a05:6e02:1ba8:b0:2eb:7d50:5fb8 with SMTP id
 n8-20020a056e021ba800b002eb7d505fb8mr14014798ili.296.1662401026346; Mon, 05
 Sep 2022 11:03:46 -0700 (PDT)
MIME-Version: 1.0
References: <20220830214919.53220-1-surenb@google.com> <Yw8P8xZ4zqu121xL@hirez.programming.kicks-ass.net>
 <20220831084230.3ti3vitrzhzsu3fs@moria.home.lan> <20220831101948.f3etturccmp5ovkl@suse.de>
 <Yw88RFuBgc7yFYxA@dhcp22.suse.cz> <20220831190154.qdlsxfamans3ya5j@moria.home.lan>
 <YxBc1xuGbB36f8zC@dhcp22.suse.cz> <CAJuCfpGhwPFYdkOLjwwD4ra9JxPqq1T5d1jd41Jy3LJnVnhNdg@mail.gmail.com>
 <YxEE1vOwRPdzKxoq@dhcp22.suse.cz> <CAJuCfpFrRwXXQ=wAvZ-oUNKXUJ=uUA=fiDrkhRu5VGXcM+=cuA@mail.gmail.com>
 <YxWvbMYLkPoJrQyr@dhcp22.suse.cz>
In-Reply-To: <YxWvbMYLkPoJrQyr@dhcp22.suse.cz>
From:   Suren Baghdasaryan <surenb@google.com>
Date:   Mon, 5 Sep 2022 11:03:35 -0700
Message-ID: <CAJuCfpHJsfe172YUQbOqkkpNEEF7B6pJZuWnMa2BsdZwwEGKmA@mail.gmail.com>
Subject: Re: [RFC PATCH 00/30] Code tagging framework and applications
To:     Michal Hocko <mhocko@suse.com>
Cc:     Kent Overstreet <kent.overstreet@linux.dev>,
        Mel Gorman <mgorman@suse.de>,
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
        Christopher Lameter <cl@linux.com>,
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
        linux-mm <linux-mm@kvack.org>, iommu@lists.linux.dev,
        kasan-dev@googlegroups.com, io-uring@vger.kernel.org,
        linux-arch@vger.kernel.org, xen-devel@lists.xenproject.org,
        linux-bcache@vger.kernel.org, linux-modules@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
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

On Mon, Sep 5, 2022 at 1:12 AM Michal Hocko <mhocko@suse.com> wrote:
>
> On Sun 04-09-22 18:32:58, Suren Baghdasaryan wrote:
> > On Thu, Sep 1, 2022 at 12:15 PM Michal Hocko <mhocko@suse.com> wrote:
> [...]
> > > Yes, tracking back the call trace would be really needed. The question
> > > is whether this is really prohibitively expensive. How much overhead are
> > > we talking about? There is no free lunch here, really.  You either have
> > > the overhead during runtime when the feature is used or on the source
> > > code level for all the future development (with a maze of macros and
> > > wrappers).
> >
> > As promised, I profiled a simple code that repeatedly makes 10
> > allocations/frees in a loop and measured overheads of code tagging,
> > call stack capturing and tracing+BPF for page and slab allocations.
> > Summary:
> >
> > Page allocations (overheads are compared to get_free_pages() duration):
> > 6.8% Codetag counter manipulations (__lazy_percpu_counter_add + __alloc_tag_add)
> > 8.8% lookup_page_ext
> > 1237% call stack capture
> > 139% tracepoint with attached empty BPF program
>
> Yes, I am not surprised that the call stack capturing is really
> expensive comparing to the allocator fast path (which is really highly
> optimized and I suspect that with 10 allocation/free loop you mostly get
> your memory from the pcp lists). Is this overhead still _that_ visible
> for somehow less microoptimized workloads which have to take slow paths
> as well?

Correct, it's a comparison with the allocation fast path, so in a
sense represents the worst case scenario. However at the same time the
measurements are fair because they measure the overheads against the
same meaningful baseline, therefore can be used for comparison.

>
> Also what kind of stack unwinder is configured (I guess ORC)? This is
> not my area but from what I remember the unwinder overhead varies
> between ORC and FP.

I used whatever is default and didn't try other mechanisms. Don't
think the difference would be orders of magnitude better though.

>
> And just to make it clear. I do realize that an overhead from the stack
> unwinding is unavoidable. And code tagging would logically have lower
> overhead as it performs much less work. But the main point is whether
> our existing stack unwiding approach is really prohibitively expensive
> to be used for debugging purposes on production systems. I might
> misremember but I recall people having bigger concerns with page_owner
> memory footprint than the actual stack unwinder overhead.

That's one of those questions which are very difficult to answer (if
even possible) because that would depend on the use scenario. If the
workload allocates frequently then adding the overhead will likely
affect it, otherwise might not be even noticeable. In general, in
pre-production testing we try to minimize the difference in
performance and memory profiles between the software we are testing
and the production one. From that point of view, the smaller the
overhead, the better. I know it's kinda obvious but unfortunately I
have no better answer to that question.

For the memory overhead, in my early internal proposal with assumption
of 10000 instrumented allocation call sites, I've made some
calculations for an 8GB 8-core system (quite typical for Android) and
ended up with the following:

                                    per-cpu counters      atomic counters
page_ext references     16MB                      16MB
slab object references   10.5MB                   10.5MB
alloc_tags                      900KB                    312KB
Total memory overhead 27.4MB                  26.8MB

so, about 0.34% of the total memory. Our implementation has changed
since then and the number might not be completely correct but it
should be in the ballpark.
I just checked the number of instrumented calls that we currently have
in the 6.0-rc3 built with defconfig and it's 165 page allocation and
2684 slab allocation sites. I readily accept that we are probably
missing some allocations and additional modules can also contribute to
these numbers but my guess it's still less than 10000 that I used in
my calculations.
I don't claim that 0.34% overhead is low enough to be always
acceptable, just posting the numbers to provide some reference points.

> --
> Michal Hocko
> SUSE Labs
