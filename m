Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D81175A84A7
	for <lists+io-uring@lfdr.de>; Wed, 31 Aug 2022 19:46:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229877AbiHaRqk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 31 Aug 2022 13:46:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbiHaRqj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 31 Aug 2022 13:46:39 -0400
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2643FB941B;
        Wed, 31 Aug 2022 10:46:38 -0700 (PDT)
Date:   Wed, 31 Aug 2022 13:46:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1661967996;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cNGQu2INYppvwn/vrI+H9fLNjZAQ9LEc2ZMlyG9+b7I=;
        b=UvGgvRFFFCjI/MJ+R56HoYOSRVpisoRSFrlM+Tnr28bYpzjswOUst1RZvoLN2iOla1UOYk
        AhrqjPYHyPNC9OtSTSv8bCcogGpeWso0AVnHwUd3AWn+b9IVre9e619KvqRphXZ15fsktW
        AqO9MlFcMAgNkcSNSSA7HGEzQFUhYiE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Mel Gorman <mgorman@suse.de>
Cc:     Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org,
        mhocko@suse.com, vbabka@suse.cz, hannes@cmpxchg.org,
        roman.gushchin@linux.dev, dave@stgolabs.net, willy@infradead.org,
        liam.howlett@oracle.com, void@manifault.com, peterz@infradead.org,
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
Subject: Re: [RFC PATCH 10/30] mm: enable page allocation tagging for
 __get_free_pages and alloc_pages
Message-ID: <20220831174629.zpa2pu6hpxmytqya@moria.home.lan>
References: <20220830214919.53220-1-surenb@google.com>
 <20220830214919.53220-11-surenb@google.com>
 <20220831101103.fj5hjgy3dbb44fit@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220831101103.fj5hjgy3dbb44fit@suse.de>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Aug 31, 2022 at 11:11:03AM +0100, Mel Gorman wrote:
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
> >  		alloc_tag_sub(get_page_tag_ref(page), PAGE_SIZE << order);
> >  }
> >  
> > +/*
> > + * Redefinitions of the common page allocators/destructors
> > + */
> > +#define pgtag_alloc_pages(gfp, order)					\
> > +({									\
> > +	struct page *_page = _alloc_pages((gfp), (order));		\
> > +									\
> > +	if (_page)							\
> > +		alloc_tag_add(get_page_tag_ref(_page), PAGE_SIZE << (order));\
> > +	_page;								\
> > +})
> > +
> 
> Instead of renaming alloc_pages, why is the tagging not done in
> __alloc_pages()? At least __alloc_pages_bulk() is also missed. The branch
> can be guarded with IS_ENABLED.

It can't be in a function, it has to be in a wrapper macro.

alloc_tag_add() is a macro that defines a static struct in a special elf
section. That struct holds the allocation counters, and putting it in a special
elf section is how the code to list it in debugfs finds it.

Look at the dynamic debug code for prior precedence for this trick in the kernel
- that's how it makes pr_debug() calls dynamically controllable at runtime, from
debugfs. We're taking that method and turning it into a proper library.

Because all the counters are statically allocated, without even a pointer deref
to get to them in the allocation path (one pointer deref to get to them in the
deallocate path), that makes this _much, much_ cheaper than anything that could
be done with tracing - cheap enough that I expect many users will want to enable
it in production.
