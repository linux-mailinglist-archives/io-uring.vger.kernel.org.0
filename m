Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DB2077E111
	for <lists+io-uring@lfdr.de>; Wed, 16 Aug 2023 14:06:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243957AbjHPMFs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Aug 2023 08:05:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245053AbjHPMFq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Aug 2023 08:05:46 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7EE9212E
        for <io-uring@vger.kernel.org>; Wed, 16 Aug 2023 05:05:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=96x4loGaNUixmyh7uTKcw82R2aq4GTzQxVccob+Q9PI=; b=KAz903JcvTLuiQ0fDYAEplCiiR
        N286TDjnVBOLlHyNg82P/uJHG7uIlAEj3NLJz/096BJ2bWuZttLYYBfDRICOibJNhcrrqYeUj86xx
        zfLfdqdIaif0QbdWnSr1x4kJ9Fr8JsbfNh3hduyeeVznEl9JLaii17se2DMDGGRyZA0Vkg6ONEMgw
        Psek39xuvvosd7QlZos+gAU8g1bCa7in6FvXOPq6Ldy97mgkCNeUwejlhxOuCe30tgsz93R1A0N2u
        YAsAujVxJKGOTyXF/wLeW+tOcc8oT3s6Jr/awIdkdjqJPUdpMocdyJf0PT83ENLh80ZeNeFpoKzwV
        Hqkj/17g==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qWFHI-00EYPy-I7; Wed, 16 Aug 2023 12:05:32 +0000
Date:   Wed, 16 Aug 2023 13:05:32 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     David Hildenbrand <david@redhat.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 7/9] mm: Add deferred_list page flag
Message-ID: <ZNy7jBAjO+SCHaoE@casper.infradead.org>
References: <20230815032645.1393700-1-willy@infradead.org>
 <20230815032645.1393700-8-willy@infradead.org>
 <7c1bb01d-620c-ca97-c4a2-2bb7c126c687@redhat.com>
 <ZNuaiY483XCq1K1/@casper.infradead.org>
 <88bdc3d2-56e4-4c09-77fe-74fb4c116893@redhat.com>
 <ZNuwm2kPzmeHo2bU@casper.infradead.org>
 <aac4404a-1012-fe7f-4337-cace30795176@redhat.com>
 <ZNvY4AbRCwjwVY7f@casper.infradead.org>
 <ZNw/FEDndlAsHlVm@casper.infradead.org>
 <fc1372e6-d64a-1788-fab8-bc0fdb12587d@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fc1372e6-d64a-1788-fab8-bc0fdb12587d@redhat.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Aug 16, 2023 at 12:12:44PM +0200, David Hildenbrand wrote:
> On 16.08.23 05:14, Matthew Wilcox wrote:
> > >   * Are managed on the LRU
> > 
> > I think this is the best one to go with.  Either that or "managed by
> > rmap".  That excludes compoud pages which are allocated from vmalloc()
> > (which can be mmaped), page tables, slab, etc.  It includes both file
> > and anon folios.
> > 
> > I have a handy taxonomy here: https://kernelnewbies.org/MemoryTypes
> > 
> > Unfortunately, folio_test_lru() already exists and means something
> > different ("Is this folio on an LRU list").  I fear folio_test_rmap()
> > would have a similar confusion -- "Is this folio currently findable by
> > rmap", or some such. folio_test_rmappable()?
> But what about hugetlb, they are also remappable? We could have
> folio_test_rmappable(), but that would then also better include hugetlb ...

We could do that!  Have both hugetlb & huge_memory.c set the rmappable
flag.  We'd still know which destructor to call because hugetlb also sets
the hugetlb flag.

> Starting at the link you provided, I guess "vmalloc" and "net pool" would
> not fall under that category, or would they? (I'm assuming they don't get
> mapped using the rmap, so they are "different", and they are not managed by
> lru).

Right, neither type of page ends up on the LRU, and neither is added to
rmap.

> So I assume we only care about anon+file (lru-managed). Only these are
> rmappable (besides hugetlb), correct?
> 
> folio_test_lru_managed()
> 
> Might be cleanest to describe anon+file that are managed by the lru, just
> might not be on a lru list right now (difference to folio_test_lru()).

Something I didn't think about last night is that this flag only
_exists_ for large folios.  folio_test_lru_managed() (and
folio_test_rmappable()) both sound like they might work if you call them
on single-page folios, but we BUG if you do (see folio_flags()) 

> I've been also thinking about
> 
> "folio_test_normal"
> 
> But it only makes sense when "all others (including hugetlb) are the odd
> one".

Who's to say slab is abnormal?  ;-)  But this one also fails to
communicate "only call this on large folios".  folio_test_splittable()
does at least communicate that this is related to large folios, although
one might simply expect it to return false for single-page folios rather
than BUG.

folio_test_large_rmappable()?
