Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BB765A821C
	for <lists+io-uring@lfdr.de>; Wed, 31 Aug 2022 17:47:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231872AbiHaPrQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 31 Aug 2022 11:47:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229927AbiHaPqz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 31 Aug 2022 11:46:55 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F8368FD48
        for <io-uring@vger.kernel.org>; Wed, 31 Aug 2022 08:45:28 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id g5so4737268ybg.11
        for <io-uring@vger.kernel.org>; Wed, 31 Aug 2022 08:45:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=Yg5lEIxwkC8L9g2KyGsqswRBhk4gAo50nJ7nWIpcdXc=;
        b=f3+0Eh/W8OX4KuooBQ0WgBNbVwjJbAXBKTWgD/1rnSxw8Or+o0OJFGSWtlhyJfP9gD
         QCFEtC0rc3uk17x5AtGX0ukxT/fwVuDehIBS7C3A9pMG33oU0ZJGMmly+vrXS5p4by0+
         jDT69+FR9RtMW6e1SjrFZnroYNBot0xZKZX0R51jheU+mrpvrFLrGntTcPsTHaijk6mV
         iKPavpo7jboK8+tsNQ9Az/YAZSJr40a0Ai7H69DS5U2PS7wmYchRHvmW2/w/UajBDN7Y
         I8Esb137FVo77guaGTuDVZBl6klQw58Xua4rWyO6cGYeV+DdQ1NJpxEpQh+0pcY1wICS
         8E3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=Yg5lEIxwkC8L9g2KyGsqswRBhk4gAo50nJ7nWIpcdXc=;
        b=c4jsQyY1mjJlgQ5K4lLxoq6dmBCUeWelYr11O5RaqAz8PKl21PuQM0koXX37bjdyEw
         xkYEwHxZ7sPwARWjgZ/IZQsuUEDoHnOLkn74aW+ymbSibpLmsyXa4DGWodWkBRzPKVjI
         wR6AaEjajYab/TdrCPBGCx063spuSaoZySlfKCZxva9n4YyXjo91yE7TgXdt5Zvut3e8
         r2VW92bdDAadBM4xBKTLqj8EXBH2cXeo4CWFRx+MMFBxC0oozWYZ9yY7n9YeuuNonTHQ
         HwgLUVj5obO+OEK2wdLSQdOg05bMkG/QeH/92M7vUGpzpbU4Po1NMh2andHeknJqfGYT
         rMAw==
X-Gm-Message-State: ACgBeo15m4kHEI5JsQYVyjvJ1r1sZkvh+jo4aXr9m5tEcdrCiUSrX0Pa
        z/GeiTc02udZve3+8s05nBfcU2DliTTJsBvEiAAavQ==
X-Google-Smtp-Source: AA6agR7eJQcze4oyVJ5u+oBz3mWkBzYq0MHuMfNSxceWOgOVlxBCkZ6NIfrADtyTqEPi+FGZK0IDnHN5ZKC4stom7pQ=
X-Received: by 2002:a05:6902:705:b0:695:b3b9:41bc with SMTP id
 k5-20020a056902070500b00695b3b941bcmr16070987ybt.426.1661960727041; Wed, 31
 Aug 2022 08:45:27 -0700 (PDT)
MIME-Version: 1.0
References: <20220830214919.53220-1-surenb@google.com> <20220830214919.53220-11-surenb@google.com>
 <20220831101103.fj5hjgy3dbb44fit@suse.de>
In-Reply-To: <20220831101103.fj5hjgy3dbb44fit@suse.de>
From:   Suren Baghdasaryan <surenb@google.com>
Date:   Wed, 31 Aug 2022 08:45:16 -0700
Message-ID: <CAJuCfpHwUUc_VphqBY9KmWvZJDrsBG6Za+kG_MW=J-abjuM4Lw@mail.gmail.com>
Subject: Re: [RFC PATCH 10/30] mm: enable page allocation tagging for
 __get_free_pages and alloc_pages
To:     Mel Gorman <mgorman@suse.de>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Kent Overstreet <kent.overstreet@linux.dev>,
        Michal Hocko <mhocko@suse.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Matthew Wilcox <willy@infradead.org>,
        "Liam R. Howlett" <liam.howlett@oracle.com>,
        David Vernet <void@manifault.com>,
        Peter Zijlstra <peterz@infradead.org>,
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
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Aug 31, 2022 at 3:11 AM Mel Gorman <mgorman@suse.de> wrote:
>
> On Tue, Aug 30, 2022 at 02:48:59PM -0700, Suren Baghdasaryan wrote:
> > Redefine alloc_pages, __get_free_pages to record allocations done by
> > these functions. Instrument deallocation hooks to record object freeing.
> >
> > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > +#ifdef CONFIG_PAGE_ALLOC_TAGGING
> > +
> >  #include <linux/alloc_tag.h>
> >  #include <linux/page_ext.h>
> >
> > @@ -25,4 +27,37 @@ static inline void pgalloc_tag_dec(struct page *page, unsigned int order)
> >               alloc_tag_sub(get_page_tag_ref(page), PAGE_SIZE << order);
> >  }
> >
> > +/*
> > + * Redefinitions of the common page allocators/destructors
> > + */
> > +#define pgtag_alloc_pages(gfp, order)                                        \
> > +({                                                                   \
> > +     struct page *_page = _alloc_pages((gfp), (order));              \
> > +                                                                     \
> > +     if (_page)                                                      \
> > +             alloc_tag_add(get_page_tag_ref(_page), PAGE_SIZE << (order));\
> > +     _page;                                                          \
> > +})
> > +
>
> Instead of renaming alloc_pages, why is the tagging not done in
> __alloc_pages()? At least __alloc_pages_bulk() is also missed. The branch
> can be guarded with IS_ENABLED.

Hmm. Assuming all the other allocators using __alloc_pages are inlined, that
should work. I'll try that and if that works will incorporate in the
next respin.
Thanks!

I don't think IS_ENABLED is required because the tagging functions are already
defined as empty if the appropriate configs are not enabled. Unless I
misunderstood
your node.

>
> > +#define pgtag_get_free_pages(gfp_mask, order)                                \
> > +({                                                                   \
> > +     struct page *_page;                                             \
> > +     unsigned long _res = _get_free_pages((gfp_mask), (order), &_page);\
> > +                                                                     \
> > +     if (_res)                                                       \
> > +             alloc_tag_add(get_page_tag_ref(_page), PAGE_SIZE << (order));\
> > +     _res;                                                           \
> > +})
> > +
>
> Similar, the tagging could happen in a core function instead of a wrapper.
>
> > +#else /* CONFIG_PAGE_ALLOC_TAGGING */
> > +
> > +#define pgtag_alloc_pages(gfp, order) _alloc_pages(gfp, order)
> > +
> > +#define pgtag_get_free_pages(gfp_mask, order) \
> > +     _get_free_pages((gfp_mask), (order), NULL)
> > +
> > +#define pgalloc_tag_dec(__page, __size)              do {} while (0)
> > +
> > +#endif /* CONFIG_PAGE_ALLOC_TAGGING */
> > +
> >  #endif /* _LINUX_PGALLOC_TAG_H */
> > diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> > index b73d3248d976..f7e6d9564a49 100644
> > --- a/mm/mempolicy.c
> > +++ b/mm/mempolicy.c
> > @@ -2249,7 +2249,7 @@ EXPORT_SYMBOL(vma_alloc_folio);
> >   * flags are used.
> >   * Return: The page on success or NULL if allocation fails.
> >   */
> > -struct page *alloc_pages(gfp_t gfp, unsigned order)
> > +struct page *_alloc_pages(gfp_t gfp, unsigned int order)
> >  {
> >       struct mempolicy *pol = &default_policy;
> >       struct page *page;
> > @@ -2273,7 +2273,7 @@ struct page *alloc_pages(gfp_t gfp, unsigned order)
> >
> >       return page;
> >  }
> > -EXPORT_SYMBOL(alloc_pages);
> > +EXPORT_SYMBOL(_alloc_pages);
> >
> >  struct folio *folio_alloc(gfp_t gfp, unsigned order)
> >  {
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index e5486d47406e..165daba19e2a 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -763,6 +763,7 @@ static inline bool pcp_allowed_order(unsigned int order)
> >
> >  static inline void free_the_page(struct page *page, unsigned int order)
> >  {
> > +
> >       if (pcp_allowed_order(order))           /* Via pcp? */
> >               free_unref_page(page, order);
> >       else
>
> Spurious wide-space change.
>
> --
> Mel Gorman
> SUSE Labs
