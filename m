Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 067C25AEFFF
	for <lists+io-uring@lfdr.de>; Tue,  6 Sep 2022 18:11:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234760AbiIFQLk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 6 Sep 2022 12:11:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234771AbiIFQLN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 6 Sep 2022 12:11:13 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CBB39DF92
        for <io-uring@vger.kernel.org>; Tue,  6 Sep 2022 08:35:52 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id y187so9274685iof.0
        for <io-uring@vger.kernel.org>; Tue, 06 Sep 2022 08:35:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=GqM67eToD1ny8VVx70XQz+yqa9cCdNaLyhnIUfKzWx0=;
        b=o3N3QM1fYFh9QHqMEdh1kjn5ZTr3F8RtlpM5O2++y+WOWtF5VqFnmXM7INH/3C3eUV
         rtXiQP5g7p+1RoMGkcw8HpDxL1pIoLr71CH6AjbQWmEBhVb8u4LGn4/JVRQUuf+w77de
         2tDN6e9GHnPV23R5EjAA9O+pg1qluKyo7jxsmW8SNYXPzCoVSh4f84J4gtZ4tZnhWZiK
         26iwawWesNsxFg0dhAaf6JAFTmg9hfjLKKg0EVBzsaVgBhhTWcI8VbgoxxYwcOBeZkXo
         2Fqq2sP/TfasoLql4YXx1PjqBffK+ktlknPqDflzAqCaK7N0WDBoy9seeNTqaG/m1+h6
         JdKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=GqM67eToD1ny8VVx70XQz+yqa9cCdNaLyhnIUfKzWx0=;
        b=L78+FTta0oky3Tmd2dbSVik1lSHs5CCGgksb+28VDhRj02NcuJxrQlt8w/JuHRafF9
         hkKG7/FibOOngmq0DIUJ9RxJOP9VUQcYwNdojr7arG/pG+YjQ90gIKzWXBfXxm94r9Hm
         ECZUWbTjKX+dUZgFRMOzTHPC0nsjjgCVz1rxwX1J3kzeGJ0ZYJQr1v39ZEAWXtzlnguB
         p2s60A7O27D0t5Wi8ere0fmTEuInHkNkcuY+VmyoOF2jy0T3nRjZ/iOJGNDvr1chih9f
         x1TzZyvV6rq+C/zDwQH18MdwZ0Tl16KMbfSsG4pmxRmSD6Euik2jKFrpwrLgWr2m9Vjk
         BvVQ==
X-Gm-Message-State: ACgBeo2b5oqymyz6gyCGI9+7QYY86l/sbOaE+Jzq5EmpgXbieLPvri5T
        Oz0S9T2Otv6Qi0Bh2RMxLQtXz0XIUVwP7c/oc5OTZw==
X-Google-Smtp-Source: AA6agR7WoNKp8qX4Lx0DqP9V0mYU3T/qwubSi65FPamgmh5UtOzupuJjLfCYByP2mN5n26WVgQyFhPUIZ+awIHTyQbo=
X-Received: by 2002:a02:740b:0:b0:349:bcdd:ca20 with SMTP id
 o11-20020a02740b000000b00349bcddca20mr30610852jac.110.1662478551322; Tue, 06
 Sep 2022 08:35:51 -0700 (PDT)
MIME-Version: 1.0
References: <20220831084230.3ti3vitrzhzsu3fs@moria.home.lan>
 <20220831101948.f3etturccmp5ovkl@suse.de> <Yw88RFuBgc7yFYxA@dhcp22.suse.cz>
 <20220831190154.qdlsxfamans3ya5j@moria.home.lan> <YxBc1xuGbB36f8zC@dhcp22.suse.cz>
 <CAJuCfpGhwPFYdkOLjwwD4ra9JxPqq1T5d1jd41Jy3LJnVnhNdg@mail.gmail.com>
 <YxEE1vOwRPdzKxoq@dhcp22.suse.cz> <CAJuCfpFrRwXXQ=wAvZ-oUNKXUJ=uUA=fiDrkhRu5VGXcM+=cuA@mail.gmail.com>
 <YxWvbMYLkPoJrQyr@dhcp22.suse.cz> <CAJuCfpHJsfe172YUQbOqkkpNEEF7B6pJZuWnMa2BsdZwwEGKmA@mail.gmail.com>
 <Yxb+PWN9kbfHSN8T@dhcp22.suse.cz>
In-Reply-To: <Yxb+PWN9kbfHSN8T@dhcp22.suse.cz>
From:   Suren Baghdasaryan <surenb@google.com>
Date:   Tue, 6 Sep 2022 08:35:40 -0700
Message-ID: <CAJuCfpGeEc9_fTCCRj9DtwQEu3u0fecc4DJuOjZzrTPfnNbOKw@mail.gmail.com>
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
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Sep 6, 2022 at 1:01 AM Michal Hocko <mhocko@suse.com> wrote:
>
> On Mon 05-09-22 11:03:35, Suren Baghdasaryan wrote:
> > On Mon, Sep 5, 2022 at 1:12 AM Michal Hocko <mhocko@suse.com> wrote:
> > >
> > > On Sun 04-09-22 18:32:58, Suren Baghdasaryan wrote:
> > > > On Thu, Sep 1, 2022 at 12:15 PM Michal Hocko <mhocko@suse.com> wrote:
> > > [...]
> > > > > Yes, tracking back the call trace would be really needed. The question
> > > > > is whether this is really prohibitively expensive. How much overhead are
> > > > > we talking about? There is no free lunch here, really.  You either have
> > > > > the overhead during runtime when the feature is used or on the source
> > > > > code level for all the future development (with a maze of macros and
> > > > > wrappers).
> > > >
> > > > As promised, I profiled a simple code that repeatedly makes 10
> > > > allocations/frees in a loop and measured overheads of code tagging,
> > > > call stack capturing and tracing+BPF for page and slab allocations.
> > > > Summary:
> > > >
> > > > Page allocations (overheads are compared to get_free_pages() duration):
> > > > 6.8% Codetag counter manipulations (__lazy_percpu_counter_add + __alloc_tag_add)
> > > > 8.8% lookup_page_ext
> > > > 1237% call stack capture
> > > > 139% tracepoint with attached empty BPF program
> > >
> > > Yes, I am not surprised that the call stack capturing is really
> > > expensive comparing to the allocator fast path (which is really highly
> > > optimized and I suspect that with 10 allocation/free loop you mostly get
> > > your memory from the pcp lists). Is this overhead still _that_ visible
> > > for somehow less microoptimized workloads which have to take slow paths
> > > as well?
> >
> > Correct, it's a comparison with the allocation fast path, so in a
> > sense represents the worst case scenario. However at the same time the
> > measurements are fair because they measure the overheads against the
> > same meaningful baseline, therefore can be used for comparison.
>
> Yes, I am not saying it is an unfair comparision. It is just not a
> particularly practical one for real life situations. So I am not sure
> you can draw many conclusions from that. Or let me put it differently.
> There is not real point comparing the code tagging and stack unwiding
> approaches because the later is simply more complex because it collects
> more state. The main question is whether that additional state
> collection is too expensive to be practically used.

You asked me to provide the numbers in one of your replies, that's what I did.

>
> > > Also what kind of stack unwinder is configured (I guess ORC)? This is
> > > not my area but from what I remember the unwinder overhead varies
> > > between ORC and FP.
> >
> > I used whatever is default and didn't try other mechanisms. Don't
> > think the difference would be orders of magnitude better though.
> >
> > >
> > > And just to make it clear. I do realize that an overhead from the stack
> > > unwinding is unavoidable. And code tagging would logically have lower
> > > overhead as it performs much less work. But the main point is whether
> > > our existing stack unwiding approach is really prohibitively expensive
> > > to be used for debugging purposes on production systems. I might
> > > misremember but I recall people having bigger concerns with page_owner
> > > memory footprint than the actual stack unwinder overhead.
> >
> > That's one of those questions which are very difficult to answer (if
> > even possible) because that would depend on the use scenario. If the
> > workload allocates frequently then adding the overhead will likely
> > affect it, otherwise might not be even noticeable. In general, in
> > pre-production testing we try to minimize the difference in
> > performance and memory profiles between the software we are testing
> > and the production one. From that point of view, the smaller the
> > overhead, the better. I know it's kinda obvious but unfortunately I
> > have no better answer to that question.
>
> This is clear but it doesn't really tell whether the existing tooling is
> unusable for _your_ or any specific scenarios. Because when we are
> talking about adding quite a lot of code and make our allocators APIs
> more complicated to track the state then we should carefully weigh the
> benefit and the cost. As replied to other email I am really skeptical
> this patchset is at the final stage and the more allocators get covered
> the more code we have to maintain. So there must be a very strong reason
> to add it.

The patchset is quite complete at this point. Instrumenting new
allocators takes 3 lines of code, see how kmalloc_hooks macro is used
in https://lore.kernel.org/all/20220830214919.53220-17-surenb@google.com/

>
> > For the memory overhead, in my early internal proposal with assumption
> > of 10000 instrumented allocation call sites, I've made some
> > calculations for an 8GB 8-core system (quite typical for Android) and
> > ended up with the following:
> >
> >                                     per-cpu counters      atomic counters
> > page_ext references     16MB                      16MB
> > slab object references   10.5MB                   10.5MB
> > alloc_tags                      900KB                    312KB
> > Total memory overhead 27.4MB                  26.8MB
>
> I do not really think this is all that interesting because the major
> memory overhead contributors (page_ext and objcg are going to be there
> with other approaches that want to match alloc and free as that clearly
> requires to store the allocator objects somewhere).

You mentioned that memory consumption in the page_owner approach was
more important overhead, so I provided the numbers for that part of
the discussion.

>
> > so, about 0.34% of the total memory. Our implementation has changed
> > since then and the number might not be completely correct but it
> > should be in the ballpark.
> > I just checked the number of instrumented calls that we currently have
> > in the 6.0-rc3 built with defconfig and it's 165 page allocation and
> > 2684 slab allocation sites. I readily accept that we are probably
> > missing some allocations and additional modules can also contribute to
> > these numbers but my guess it's still less than 10000 that I used in
> > my calculations.
>
> yes, in the current implementation you are missing most indirect users
> of the page allocator as stated elsewhere so the usefulness can be
> really limited. A better coverege will not increase the memory
> consumption much but it will add an additional maintenance burden that
> will scale with different usecases.

Your comments in the last two letters about needing the stack tracing
and covering indirect users of the allocators makes me think that you
missed my reply here:
https://lore.kernel.org/all/CAJuCfpGZ==v0HGWBzZzHTgbo4B_ZBe6V6U4T_788LVWj8HhCRQ@mail.gmail.com/.
I messed up with formatting but hopefully it's still readable. The
idea of having two stage tracking - first one very cheap and the
second one more in-depth I think should address your concerns about
indirect users.
Thanks,
Suren.

> --
> Michal Hocko
> SUSE Labs
