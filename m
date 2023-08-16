Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD0B277D8E2
	for <lists+io-uring@lfdr.de>; Wed, 16 Aug 2023 05:15:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237701AbjHPDOt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Aug 2023 23:14:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241521AbjHPDOh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Aug 2023 23:14:37 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 798BE1FCA
        for <io-uring@vger.kernel.org>; Tue, 15 Aug 2023 20:14:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=3/5OOSSR7L2QZeFStIYGZJcEey6dQJOslu2z0mkyYG8=; b=WactNgs1x7ZGqFAOaO2iLcZupF
        yg3qa0d0R7Kkf3k41DGB7lzp1mcUnEB2pe75dy1++FbpdHoMHlkJNLA1rAUi5eIKXK9QAccQIeLo1
        DcxDzigkAaU8oEmZP3ZVAakEHEgprRkMD2o9uQ///JF9JqsRdbU6D9HUbmy1pMZE4QzIH9qxJ1+nj
        gBV3UPAYINF9TLeWGrVuBBScSvYQIQ5nFLlsraMqgI+sXuACermnUC623R6Vde7sIhd8XePfEjrPN
        hSji4e/WBzC5xDf7Ig69CzK4JEofL7TzY+q1e+QHA2zDOhA5E+RmiT2aHcCGHsP5IrtFM281PZwax
        oZR3QHlQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qW6zM-00CDjw-KV; Wed, 16 Aug 2023 03:14:28 +0000
Date:   Wed, 16 Aug 2023 04:14:28 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     David Hildenbrand <david@redhat.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 7/9] mm: Add deferred_list page flag
Message-ID: <ZNw/FEDndlAsHlVm@casper.infradead.org>
References: <20230815032645.1393700-1-willy@infradead.org>
 <20230815032645.1393700-8-willy@infradead.org>
 <7c1bb01d-620c-ca97-c4a2-2bb7c126c687@redhat.com>
 <ZNuaiY483XCq1K1/@casper.infradead.org>
 <88bdc3d2-56e4-4c09-77fe-74fb4c116893@redhat.com>
 <ZNuwm2kPzmeHo2bU@casper.infradead.org>
 <aac4404a-1012-fe7f-4337-cace30795176@redhat.com>
 <ZNvY4AbRCwjwVY7f@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZNvY4AbRCwjwVY7f@casper.infradead.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Aug 15, 2023 at 08:58:24PM +0100, Matthew Wilcox wrote:
> On Tue, Aug 15, 2023 at 07:27:26PM +0200, David Hildenbrand wrote:
> > On 15.08.23 19:06, Matthew Wilcox wrote:
> > > Theree are a lot of counters called THP and TransHuge and other variants
> > > which are exposed to userspace, and the (user) assumption is that this counts
> > > PMD-sized folios.  If you grep around for folio_test_pmd_mappable(),
> > > you'll find them.  If we have folio_test_thp(), people will write:
> > > 
> > > 	if (folio_test_thp(folio))
> > > 		__mod_lruvec_state(lruvec, NR_SHMEM_THPS, nr);
> > > 
> > > instead of using folio_test_pmd_mappable().
> > 
> > So if we *really* don't want to use THP to express that we have a page, then
> > let's see what these pages are:
> > * can be mapped to user space
> > * are transparent to most MM-related systemcalls by (un) mapping
> >   them in system page size (PTEs)
> 
>  * Are managed on the LRU

I think this is the best one to go with.  Either that or "managed by
rmap".  That excludes compoud pages which are allocated from vmalloc()
(which can be mmaped), page tables, slab, etc.  It includes both file
and anon folios.

I have a handy taxonomy here: https://kernelnewbies.org/MemoryTypes

Unfortunately, folio_test_lru() already exists and means something
different ("Is this folio on an LRU list").  I fear folio_test_rmap()
would have a similar confusion -- "Is this folio currently findable by
rmap", or some such. folio_test_rmappable()?

