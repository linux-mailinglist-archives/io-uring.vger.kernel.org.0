Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECFA977CF2D
	for <lists+io-uring@lfdr.de>; Tue, 15 Aug 2023 17:33:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbjHOPcz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Aug 2023 11:32:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238176AbjHOPct (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Aug 2023 11:32:49 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A12251BCF
        for <io-uring@vger.kernel.org>; Tue, 15 Aug 2023 08:32:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=q5wk83xdysE8z0uq3teCC6Wat5W06qSOKL17sNuBLdQ=; b=oz7Ch3Qd9zSWohQJDHFLQS2rq2
        n53BuX5w/26/qPIQfHoRwjojwr5Q6srtzfON3zk1x7KoS5ojxyTwBawEPZS608jDw0HyURjfDsSlM
        lmA4/u+fhNuRCsReiJQnzOVLi+7AJjRNlw9kRXokFg5JqCgJDhaZmPmWBqymkgWlCo2KD5V+oVlrj
        hcs1pzPcm/y5NCzUk3v6q+IcS/ZmTTnC8HkliOaopDU5VtvtMpQHoRAhmoUbp0VHnolJsHTaCO+mS
        2yRNAghrGG+KouDkB3Y93zqbC88UMIOJzAkBRmODDLq+wqgNr5DRiHYICnwsDtJ3thxuG8L/A5M9+
        1fZbQ1vg==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qVw1x-008xbP-GG; Tue, 15 Aug 2023 15:32:25 +0000
Date:   Tue, 15 Aug 2023 16:32:25 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     David Hildenbrand <david@redhat.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 7/9] mm: Add deferred_list page flag
Message-ID: <ZNuaiY483XCq1K1/@casper.infradead.org>
References: <20230815032645.1393700-1-willy@infradead.org>
 <20230815032645.1393700-8-willy@infradead.org>
 <7c1bb01d-620c-ca97-c4a2-2bb7c126c687@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c1bb01d-620c-ca97-c4a2-2bb7c126c687@redhat.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Aug 15, 2023 at 09:54:36AM +0200, David Hildenbrand wrote:
> On 15.08.23 05:26, Matthew Wilcox (Oracle) wrote:
> > Stored in the first tail page's flags, this flag replaces the destructor.
> > That removes the last of the destructors, so remove all references to
> > folio_dtor and compound_dtor.
> > 
> > Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> > ---
> 
> [...]
> 
> > +	/* Has a deferred list (may be empty).  First tail page. */
> > +	PG_deferred_list = PG_reclaim,
> > +
> 
> If PG_deferred_list implies thp (and replaces the thp dtor), should we
> rather name this PG_thp or something along those lines?

We're trying to use 'thp' to mean 'a folio which is pmd mappable',
so I'd rather not call it that.

> The sequence of
> 
> 	if (folio_test_deferred_list(folio))
> 		free_transhuge_folio(folio);
> 
> Looks less clear to what we had before.

I can rename that.  How about

	if (folio_test_deferred_list(folio))
		folio_remove_deferred(folio);

