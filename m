Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29F6177D67C
	for <lists+io-uring@lfdr.de>; Wed, 16 Aug 2023 01:01:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240494AbjHOXBP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Aug 2023 19:01:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240590AbjHOXBN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Aug 2023 19:01:13 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2B311FCF
        for <io-uring@vger.kernel.org>; Tue, 15 Aug 2023 16:01:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=j4qmcEFXn/HEwzzgmOFjWOT+QdvX9TIUsfVg64W1WDE=; b=Uq6gvG3VyCgwcrY/X4VzU0IJuT
        wyTXYwGqZf7L/af+6LEuugLRbuKvL18dFAscfi5kTzSH/9FJ76WNRtTPntZfvCoI5hmDXGwoj2OLP
        5TkP4mOYtgXXpKMJNJJ3gre2/6ztaLJxjjDtF8+lrRGlhqNIQUWgGJMlKiNOAHKPUhmSY0JOzN5sH
        3Y06pyE8o+Ddn9UzLUWHuiCaM6M/ZxR0fxYz0KUkrf+3ylpw9hkHJ4Drf834Z3mCov10Ps0HFFMMd
        miCxQGqTgmMbSYIBz1510WLQlSxiAPE0ct2Z2T9Bn5E/P/evhZrZ+yxEUiOJcKSsfbSV8aZZAPYhg
        UjuQo7mg==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qW32C-00B1sa-8f; Tue, 15 Aug 2023 23:01:08 +0000
Date:   Wed, 16 Aug 2023 00:01:08 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Yosry Ahmed <yosryahmed@google.com>
Cc:     Peter Xu <peterx@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 8/9] mm: Rearrange page flags
Message-ID: <ZNwDtHqFw1SLDw7m@casper.infradead.org>
References: <20230815032645.1393700-1-willy@infradead.org>
 <20230815032645.1393700-9-willy@infradead.org>
 <ZNvQ4EbQh/aAwK8L@x1n>
 <ZNvbApJbLanU55Ze@casper.infradead.org>
 <CAJD7tkY=-Mmrbe5_Z8rKA--zUMo83mTyY1frZEFy6C5NFP-y7A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJD7tkY=-Mmrbe5_Z8rKA--zUMo83mTyY1frZEFy6C5NFP-y7A@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Aug 15, 2023 at 03:31:42PM -0700, Yosry Ahmed wrote:
> On Tue, Aug 15, 2023 at 1:07 PM Matthew Wilcox <willy@infradead.org> wrote:
> >
> > On Tue, Aug 15, 2023 at 03:24:16PM -0400, Peter Xu wrote:
> > > On Tue, Aug 15, 2023 at 04:26:44AM +0100, Matthew Wilcox (Oracle) wrote:
> > > > +++ b/include/linux/page-flags.h
> > > > @@ -99,13 +99,15 @@
> > > >   */
> > > >  enum pageflags {
> > > >     PG_locked,              /* Page is locked. Don't touch. */
> > > > +   PG_writeback,           /* Page is under writeback */
> > > >     PG_referenced,
> > > >     PG_uptodate,
> > > >     PG_dirty,
> > > >     PG_lru,
> > > > +   PG_head,                /* Must be in bit 6 */
> > >
> > > Could there be some explanation on "must be in bit 6" here?
> >
> > Not on this line, no.  You get 40-50 characters to say something useful.
> > Happy to elaborate further in some other comment or in the commit log,
> > but not on this line.
> >
> > The idea behind all of this is that _folio_order moves into the bottom
> > byte of _flags_1.  Because the order can never be greater than 63 (and
> > in practice I think the largest we're going to see is about 30 -- a 16GB
> > hugetlb page on some architectures), we know that PG_head and PG_waiters
> > will be clear, so we can write (folio->_flags_1 & 0xff) and the compiler
> > will just load a byte; it won't actually load the word and mask it.
> >
> > We can't move PG_head any lower, or we'll risk having a tail page with
> > PG_head set (which can happen with the vmemmmap optimisation, but eugh).
> > And we don't want to move it any higher because then we'll have a flag
> > that cannot be reused in a tail page.  Bit 6 is the perfect spot for it.
> 
> Is there some compile time assertion that the order cannot overflow into bit 6?

An order-64 folio on a machine with a 4kB page size would be 64
zettabytes.  I intend to retire before we're managing memory in chunks
that large.
