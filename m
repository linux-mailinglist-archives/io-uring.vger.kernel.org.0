Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 595C777D3B9
	for <lists+io-uring@lfdr.de>; Tue, 15 Aug 2023 21:59:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233685AbjHOT6e (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Aug 2023 15:58:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234858AbjHOT63 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Aug 2023 15:58:29 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B95E83
        for <io-uring@vger.kernel.org>; Tue, 15 Aug 2023 12:58:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=REO/NuxNjKd1RI6P6mRiynN2pl2P7FWcjgXGh2Ezuqk=; b=r2OD9Rs4DfxSbofmquM9xQUsLU
        5jLFZbX8XLKxE0n4Thj5T6NQYMoh1a+8ibUhXkb4IUyRIslrKvVtvGhwmK7ux230+vjQ07eiBlP0A
        uJiSI6Grug9Ao7cWQnnTXHoFrNrQHMkP0HVOVEr7/ZK2NZqsCms/mcoq8J/awNrgHU1anSYhlvUNY
        pcu1FAsgVWY9pP6txL0H1tSoddx0ndrg7+/84OS5STTCXRBUu5bL94inP2NQwc+m//aP5MGEWKhpM
        6fCU3mC4+KkHumnXQo//dmLHFlZyjfMJrBd0JT7hdQDr7ORPrBSIn1YQkbcKF4IFci7b5sKoD++y7
        UUXvhxew==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qW0BM-00A7t8-9s; Tue, 15 Aug 2023 19:58:24 +0000
Date:   Tue, 15 Aug 2023 20:58:24 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     David Hildenbrand <david@redhat.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 7/9] mm: Add deferred_list page flag
Message-ID: <ZNvY4AbRCwjwVY7f@casper.infradead.org>
References: <20230815032645.1393700-1-willy@infradead.org>
 <20230815032645.1393700-8-willy@infradead.org>
 <7c1bb01d-620c-ca97-c4a2-2bb7c126c687@redhat.com>
 <ZNuaiY483XCq1K1/@casper.infradead.org>
 <88bdc3d2-56e4-4c09-77fe-74fb4c116893@redhat.com>
 <ZNuwm2kPzmeHo2bU@casper.infradead.org>
 <aac4404a-1012-fe7f-4337-cace30795176@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aac4404a-1012-fe7f-4337-cace30795176@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Aug 15, 2023 at 07:27:26PM +0200, David Hildenbrand wrote:
> On 15.08.23 19:06, Matthew Wilcox wrote:
> > Theree are a lot of counters called THP and TransHuge and other variants
> > which are exposed to userspace, and the (user) assumption is that this counts
> > PMD-sized folios.  If you grep around for folio_test_pmd_mappable(),
> > you'll find them.  If we have folio_test_thp(), people will write:
> > 
> > 	if (folio_test_thp(folio))
> > 		__mod_lruvec_state(lruvec, NR_SHMEM_THPS, nr);
> > 
> > instead of using folio_test_pmd_mappable().
> 
> So if we *really* don't want to use THP to express that we have a page, then
> let's see what these pages are:
> * can be mapped to user space
> * are transparent to most MM-related systemcalls by (un) mapping
>   them in system page size (PTEs)

 * Are managed on the LRU
 * Can be dirtied, written back

> That we can split these pages (not PTE-map, but convert from large folio to
> small folios) is one characteristic, but IMHO not the main one (and maybe
> not even required at all!).

It's the one which distinguishes them from, say, compound pages used for
slab.  Or used by device drivers.  Or net pagepool, or vmalloc.  There's
a lot of compound allocations out there, and the only ones which need
special treatment here are the ones which are splittable.

> Maybe we can come up with a better term for "THP, but not necessarily
> PMD-sized".
> 
> "Large folio" is IMHO bad. A hugetlb page is a large folio and not all large
> folios can be mapped to user space.
> 
> "Transparent large folios" ? Better IMHO.

I think this goes back to Johannes' point many months ago that we need
separate names for some things.  He wants to split anon & file memory
apart (who gets to keep the name "folio" in the divorce?  what do we
name the type that encompasses both folios and the other one?  or do
they both get different names?)

> > Perhaps the key difference between normal compound pages and file/anon
> > compound pages is that the latter are splittable?  So we can name all
> > of this:
> > 
> > 	folio_init_splittable()
> > 	folio_test_splittable()
> > 	folio_fini_splittable()
> > 
> > Maybe that's still too close to an implementation detail, but it's at
> > least talking about _a_ characteristic of the folio, even if it's not
> > the _only_ characteristic of the folio.
> 
> Maybe folio_init_transparent() ... avoiding the "huge" part of it.
> 
> Very open for alternatives. As expressed in other context, we really should
> figure this out soon.

Yeah, I'm open to better naming too.  At this point in the flow we're
trying to distinguish between compound pages used for slab and compound
pages used for anon/file, but that's not always going to be the case
elsewhere.
