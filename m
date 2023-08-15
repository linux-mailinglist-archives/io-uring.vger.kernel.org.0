Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5685977D097
	for <lists+io-uring@lfdr.de>; Tue, 15 Aug 2023 19:07:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238620AbjHORHK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Aug 2023 13:07:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238625AbjHORGm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Aug 2023 13:06:42 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34DC51990
        for <io-uring@vger.kernel.org>; Tue, 15 Aug 2023 10:06:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=vZqPRg3r0m5C1a2IsUiQeDDBtBFofgrb7BHNPuc4+8E=; b=ay03J/B2Fx0p2iGHY4Nyfg/Hor
        wUdxyG7UOgsk+vljXcadenka3BHlsnb604xTvvd6KRflAKI9gSLVa8PsnsnN6s93eFiOMXSGLrZrw
        40yCOprE0w7Yuqsfz4AFsPpFgELv/GyTPDERzv/ZmCE8B4oRyb4m/9vYsoXiEVbKRvWExkfyIKUnT
        jzrRIyQc5IyBfVrmws2/TdMLcqJys9tfXhPrqIloqHiHfDg5iKJcqDnBia/FzxulTDKEVkaT6oFwR
        hIKccArwWkdefAJN6FzWXCZz32ll1MMwxR8OxprNfb4sZNOTZTlvoHMdnYjRodPcd1+2Tzpu1PMIY
        z9lNvBHw==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qVxV5-009O6Q-Sn; Tue, 15 Aug 2023 17:06:35 +0000
Date:   Tue, 15 Aug 2023 18:06:35 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     David Hildenbrand <david@redhat.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 7/9] mm: Add deferred_list page flag
Message-ID: <ZNuwm2kPzmeHo2bU@casper.infradead.org>
References: <20230815032645.1393700-1-willy@infradead.org>
 <20230815032645.1393700-8-willy@infradead.org>
 <7c1bb01d-620c-ca97-c4a2-2bb7c126c687@redhat.com>
 <ZNuaiY483XCq1K1/@casper.infradead.org>
 <88bdc3d2-56e4-4c09-77fe-74fb4c116893@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <88bdc3d2-56e4-4c09-77fe-74fb4c116893@redhat.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Aug 15, 2023 at 06:40:55PM +0200, David Hildenbrand wrote:
> On 15.08.23 17:32, Matthew Wilcox wrote:
> > On Tue, Aug 15, 2023 at 09:54:36AM +0200, David Hildenbrand wrote:
> > > On 15.08.23 05:26, Matthew Wilcox (Oracle) wrote:
> > > > Stored in the first tail page's flags, this flag replaces the destructor.
> > > > That removes the last of the destructors, so remove all references to
> > > > folio_dtor and compound_dtor.
> > > > 
> > > > Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> > > > ---
> > > 
> > > [...]
> > > 
> > > > +	/* Has a deferred list (may be empty).  First tail page. */
> > > > +	PG_deferred_list = PG_reclaim,
> > > > +
> > > 
> > > If PG_deferred_list implies thp (and replaces the thp dtor), should we
> > > rather name this PG_thp or something along those lines?
> > 
> > We're trying to use 'thp' to mean 'a folio which is pmd mappable',
> > so I'd rather not call it that.
> 
> There is no conclusion on that.

Theree are a lot of counters called THP and TransHuge and other variants
which are exposed to userspace, and the (user) assumption is that this counts
PMD-sized folios.  If you grep around for folio_test_pmd_mappable(),
you'll find them.  If we have folio_test_thp(), people will write:

	if (folio_test_thp(folio))
		__mod_lruvec_state(lruvec, NR_SHMEM_THPS, nr);

instead of using folio_test_pmd_mappable().

> After all, the deferred split queue is just an implementation detail, and it
> happens to live in tailpage 2, no?
> 
> Once we would end up initializing something else in prep_transhuge_page(),
> it would turn out pretty confusing if that is called folio_remove_deferred()
> ...

Perhaps the key difference between normal compound pages and file/anon
compound pages is that the latter are splittable?  So we can name all
of this:

	folio_init_splittable()
	folio_test_splittable()
	folio_fini_splittable()

Maybe that's still too close to an implementation detail, but it's at
least talking about _a_ characteristic of the folio, even if it's not
the _only_ characteristic of the folio.
