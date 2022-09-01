Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A1915A9BD9
	for <lists+io-uring@lfdr.de>; Thu,  1 Sep 2022 17:40:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234058AbiIAPkD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Sep 2022 11:40:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232629AbiIAPkC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Sep 2022 11:40:02 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFDA313EB7
        for <io-uring@vger.kernel.org>; Thu,  1 Sep 2022 08:40:00 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id l196so9152207ybl.12
        for <io-uring@vger.kernel.org>; Thu, 01 Sep 2022 08:40:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=3cE853tliEpPWpHjkdjBsm55bguibJ1NOZ2l+ytqvIs=;
        b=CNR1NtmysqZN43aw5siPQxQB15yoyKxn0UtAt1eFrCVSTrqVXrck0MJQ5rF0EE8Iqy
         FECYDZNtaf4xFqIfRFeGfncBEzgsXCtgfPFQ9NnPdVRFkAf7PTRy+isa8Q/3u9s63jFF
         Bkv08GJGttRtk8ihR4u9G9sfgOvnbQBOURRSewgh7NzkPEQgVbW8k9NY5ToRU0fk16sO
         KDQeEwKDvn2AZgblfu2tmDll7zNnUGlKeUzAPAS8k31d+CGKhmmtzNe2LpeGY2e9A3T2
         OyHR4dbvshaM9SSwkyP8U36LLaknoM2MMTtTCDpp5f48zXa2ecNcsCYbrEUZ3+gtqLOE
         C5XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=3cE853tliEpPWpHjkdjBsm55bguibJ1NOZ2l+ytqvIs=;
        b=IYzg2v9HjAB9yGhwscb3GTY21fRNBOyQOG/fpRw+e+FAir73IdhSTiXSoiQBDC1Gd4
         rw0FRXXktx0NL1Oq9sai/8srwV0Xq9y0YGwp5r12VqP/WVBhleHwqxxinGugcw2jbmRj
         LGddG3ioplzv4gD/YiJlnbhjq5cOB/eXmEgP4yXYM9NbhTa9hK9Dwrkf79WG/IFbnTVg
         y/CbEUvA1ZvDD+iqQkTmtxUbaOgW/aPgMM0PECiROAC2C2Feho86fgEgmMO3GtUdj70L
         KjQENAh6eSeAr0BxMCciNJDurnYKjqM5biWh4cEfN7yK2q2pooF7EIEqWeHpKpIqwcXb
         3FzQ==
X-Gm-Message-State: ACgBeo0K8nHLwhroZTldPX939uk0zQsHYKoAwpSSqJcynDK2n4L7Y3ZN
        0KkHhu/wGZR67E1msyPumVQ/15wjP5PoJBC+Kvlqzg==
X-Google-Smtp-Source: AA6agR5aFHV5oWy3bOo2eVd0PIajtlCyUMrAF/y9Oh7oqrhvwnrJM9jnSE6k3ZmfRfh8uK89oJZlft1zkj3aGLobpWw=
X-Received: by 2002:a25:b983:0:b0:695:d8b4:a5a3 with SMTP id
 r3-20020a25b983000000b00695d8b4a5a3mr20405655ybg.553.1662046799565; Thu, 01
 Sep 2022 08:39:59 -0700 (PDT)
MIME-Version: 1.0
References: <20220830214919.53220-1-surenb@google.com> <Yw8P8xZ4zqu121xL@hirez.programming.kicks-ass.net>
 <20220831084230.3ti3vitrzhzsu3fs@moria.home.lan> <20220831101948.f3etturccmp5ovkl@suse.de>
 <Yw88RFuBgc7yFYxA@dhcp22.suse.cz> <20220831190154.qdlsxfamans3ya5j@moria.home.lan>
 <404e947a-e1b2-0fae-8b4f-6f2e3ba6328d@redhat.com> <20220901142345.agkfp2d5lijdp6pt@moria.home.lan>
 <78e55029-0eaf-b4b3-7e86-1086b97c60c6@redhat.com>
In-Reply-To: <78e55029-0eaf-b4b3-7e86-1086b97c60c6@redhat.com>
From:   Suren Baghdasaryan <surenb@google.com>
Date:   Thu, 1 Sep 2022 08:39:48 -0700
Message-ID: <CAJuCfpEgWx4mmiSCvcMOF0+Luyw1w-hVyLV-cvhbxnwsN6qg0g@mail.gmail.com>
Subject: Re: [RFC PATCH 00/30] Code tagging framework and applications
To:     David Hildenbrand <david@redhat.com>
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
        Peter Xu <peterx@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        mcgrof@kernel.org, masahiroy@kernel.org, nathan@kernel.org,
        changbin.du@intel.com, ytcoode@gmail.com,
        Vincent Guittot <vincent.guittot@linaro.org>,
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

On Thu, Sep 1, 2022 at 8:07 AM David Hildenbrand <david@redhat.com> wrote:
>
> On 01.09.22 16:23, Kent Overstreet wrote:
> > On Thu, Sep 01, 2022 at 10:05:03AM +0200, David Hildenbrand wrote:
> >> On 31.08.22 21:01, Kent Overstreet wrote:
> >>> On Wed, Aug 31, 2022 at 12:47:32PM +0200, Michal Hocko wrote:
> >>>> On Wed 31-08-22 11:19:48, Mel Gorman wrote:
> >>>>> Whatever asking for an explanation as to why equivalent functionality
> >>>>> cannot not be created from ftrace/kprobe/eBPF/whatever is reasonable.
> >>>>
> >>>> Fully agreed and this is especially true for a change this size
> >>>> 77 files changed, 3406 insertions(+), 703 deletions(-)
> >>>
> >>> In the case of memory allocation accounting, you flat cannot do this with ftrace
> >>> - you could maybe do a janky version that isn't fully accurate, much slower,
> >>> more complicated for the developer to understand and debug and more complicated
> >>> for the end user.
> >>>
> >>> But please, I invite anyone who's actually been doing this with ftrace to
> >>> demonstrate otherwise.
> >>>
> >>> Ftrace just isn't the right tool for the job here - we're talking about adding
> >>> per callsite accounting to some of the fastest fast paths in the kernel.
> >>>
> >>> And the size of the changes for memory allocation accounting are much more
> >>> reasonable:
> >>>  33 files changed, 623 insertions(+), 99 deletions(-)
> >>>
> >>> The code tagging library should exist anyways, it's been open coded half a dozen
> >>> times in the kernel already.
> >>
> >> Hi Kent,
> >>
> >> independent of the other discussions, if it's open coded already, does
> >> it make sense to factor that already-open-coded part out independently
> >> of the remainder of the full series here?
> >
> > It's discussed in the cover letter, that is exactly how the patch series is
> > structured.
>
> Skimming over the patches (that I was CCed on) and skimming over the
> cover letter, I got the impression that everything after patch 7 is
> introducing something new instead of refactoring something out.

Hi David,
Yes, you are right, the RFC does incorporate lots of parts which can
be considered separately. They are sent together to present the
overall scope of the proposal but I do intend to send them separately
once we decide if it's worth working on.
Thanks,
Suren.

>
> >
> >> [I didn't immediately spot if this series also attempts already to
> >> replace that open-coded part]
> >
> > Uh huh.
> >
> > Honestly, some days it feels like lkml is just as bad as slashdot, with people
> > wanting to get in their two cents without actually reading...
>
> ... and of course you had to reply like that. I should just have learned
> from my last upstream experience with you and kept you on my spam list.
>
> Thanks, bye
>
> --
> Thanks,
>
> David / dhildenb
>
