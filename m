Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 231D75A9BC5
	for <lists+io-uring@lfdr.de>; Thu,  1 Sep 2022 17:33:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231447AbiIAPde (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Sep 2022 11:33:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233602AbiIAPdd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Sep 2022 11:33:33 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E73DC883DB
        for <io-uring@vger.kernel.org>; Thu,  1 Sep 2022 08:33:31 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id c9so9128304ybf.5
        for <io-uring@vger.kernel.org>; Thu, 01 Sep 2022 08:33:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=cuZ+nGX7dbAKHVSMzM9WDnRxW6f4Hrbmbun1Vl7XZUY=;
        b=nPy2aaUnPlKN9168rAezb9LSPcW4fo9+X5T3qYP77vPFcpzl+GhEzMZUxcz6J/8TiE
         IizY0PKy2tILVlboBx4hOHtK6o3BgdgdGqsyzqTvhnIsClaTwjg++DGXEdjbBPa8JR6s
         MIO2ZCktfdOzY88zke9nN4gcVwpbigx1IRCHgdE2F2Mq1597r9VFdc/4HIbMkV/CeG8x
         zsKr4C+BAyJ34f5F1Hb/vV3IvHxRb8IEQg4iOBO9diUXfW6M3nrOExLvEuVNGqzKErqg
         hzqElImWPPWWViyded2pBo3h+cgyvOivEpW732ttVGvmx+I0KmbeGYZvy64qW3Me0ncH
         pw1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=cuZ+nGX7dbAKHVSMzM9WDnRxW6f4Hrbmbun1Vl7XZUY=;
        b=RDDp0qmZf94iAZJTP6eg98ik/QZb60WF3qalS2818tvtbCsUEVWBOok7GiEcLsvwXx
         RdpQb+OufyXn/sBrjs2u/Mwl7b3f1UfhSXea+OCD8DGl6LBMV38KyX2ajJFJrHFaf0Ks
         ymar3Y0KuEWFBLQTfOgcZT+i5eyWkEBmrKKjKeLPpZLxbR7+G5LDpw9l3sjs6c9USai2
         85Yu1piy4Xp2UTp1pKYa2EibgNg3rvtvKPyozsMjSRotuJRxu6cgGgDTf6HzPezNGcdZ
         b1oLpRJX7k1Cjfnr+vnmdYHnh8SjjKBcv04vKu8kAGaom17HLgKBlK91xILKYcxmyK9z
         F/UA==
X-Gm-Message-State: ACgBeo0HB40AIkCikF7qYT3TtH58LfqyWASDmIQ87kDjYZFxviLlTtT4
        2uNF2PLMx31PWxsoINaefy20shfRUJHJ8FZK2Z0NIg==
X-Google-Smtp-Source: AA6agR7nkVcaAE7evofOhQO8CQyYLS6FGoseisRuE7p9aju3ICNx4/ZUVa/hlS8HLwBhdw8j7iOCWiWLZKuRzYzC+BI=
X-Received: by 2002:a05:6902:705:b0:695:b3b9:41bc with SMTP id
 k5-20020a056902070500b00695b3b941bcmr19699146ybt.426.1662046410779; Thu, 01
 Sep 2022 08:33:30 -0700 (PDT)
MIME-Version: 1.0
References: <20220830214919.53220-1-surenb@google.com> <Yw8P8xZ4zqu121xL@hirez.programming.kicks-ass.net>
 <20220831084230.3ti3vitrzhzsu3fs@moria.home.lan> <20220831101948.f3etturccmp5ovkl@suse.de>
 <Yw88RFuBgc7yFYxA@dhcp22.suse.cz> <20220831190154.qdlsxfamans3ya5j@moria.home.lan>
 <YxBc1xuGbB36f8zC@dhcp22.suse.cz>
In-Reply-To: <YxBc1xuGbB36f8zC@dhcp22.suse.cz>
From:   Suren Baghdasaryan <surenb@google.com>
Date:   Thu, 1 Sep 2022 08:33:19 -0700
Message-ID: <CAJuCfpGhwPFYdkOLjwwD4ra9JxPqq1T5d1jd41Jy3LJnVnhNdg@mail.gmail.com>
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
        Marco Elver <elver@google.com>, dvyukov@google.com,
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

On Thu, Sep 1, 2022 at 12:18 AM Michal Hocko <mhocko@suse.com> wrote:
>
> On Wed 31-08-22 15:01:54, Kent Overstreet wrote:
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
>
> A big ad on a banner. But more seriously.
>
> This patchset is _huge_ and touching a lot of different areas. It will
> be not only hard to review but even harder to maintain longterm. So
> it is completely reasonable to ask for potential alternatives with a
> smaller code footprint. I am pretty sure you are aware of that workflow.

The patchset is huge because it introduces a reusable part (the first
6 patches introducing code tagging) and 6 different applications in
very different areas of the kernel. We wanted to present all of them
in the RFC to show the variety of cases this mechanism can be reused
for. If the code tagging is accepted, each application can be posted
separately to the appropriate group of people. Hopefully that makes it
easier to review. Those first 6 patches are not that big and are quite
isolated IMHO:

 include/linux/codetag.h             |  83 ++++++++++
 include/linux/lazy-percpu-counter.h |  67 ++++++++
 include/linux/module.h              |   1 +
 kernel/module/internal.h            |   1 -
 kernel/module/main.c                |   4 +
 lib/Kconfig                         |   3 +
 lib/Kconfig.debug                   |   4 +
 lib/Makefile                        |   3 +
 lib/codetag.c                       | 248 ++++++++++++++++++++++++++++
 lib/lazy-percpu-counter.c           | 141 ++++++++++++++++
 lib/string_helpers.c                |   3 +-
 scripts/kallsyms.c                  |  13 ++

>
> So I find Peter's question completely appropriate while your response to
> that not so much! Maybe ftrace is not the right tool for the intented
> job. Maybe there are other ways and it would be really great to show
> that those have been evaluated and they are not suitable for a), b) and
> c) reasons.

That's fair.
For memory tracking I looked into using kmemleak and page_owner which
can't match the required functionality at an overhead acceptable for
production and pre-production testing environments. traces + BPF I
haven't evaluated myself but heard from other members of my team who
tried using that in production environment with poor results. I'll try
to get more specific information on that.

>
> E.g. Oscar has been working on extending page_ext to track number of
> allocations for specific calltrace[1]. Is this 1:1 replacement? No! But
> it can help in environments where page_ext can be enabled and it is
> completely non-intrusive to the MM code.

Thanks for pointing out this work. I'll need to review and maybe
profile it before making any claims.

>
> If the page_ext overhead is not desirable/acceptable then I am sure
> there are other options. E.g. kprobes/LivePatching framework can hook
> into functions and alter their behavior. So why not use that for data
> collection? Has this been evaluated at all?

I'm not sure how I can hook into say alloc_pages() to find out where
it was called from without capturing the call stack (which would
introduce an overhead at every allocation). Would love to discuss this
or other alternatives if they can be done with low enough overhead.
Thanks,
Suren.

>
> And please note that I am not claiming the presented work is approaching
> the problem from a wrong direction. It might very well solve multiple
> problems in a single go _but_ the long term code maintenance burden
> really has to to be carefully evaluated and if we can achieve a
> reasonable subset of the functionality with an existing infrastructure
> then I would be inclined to sacrifice some portions with a considerably
> smaller code footprint.
>
> [1] http://lkml.kernel.org/r/20220901044249.4624-1-osalvador@suse.de
>
> --
> Michal Hocko
> SUSE Labs
