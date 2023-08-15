Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B118D77D3EB
	for <lists+io-uring@lfdr.de>; Tue, 15 Aug 2023 22:08:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233774AbjHOUHm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Aug 2023 16:07:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240175AbjHOUHh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Aug 2023 16:07:37 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE4AD83
        for <io-uring@vger.kernel.org>; Tue, 15 Aug 2023 13:07:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=eHSlXXQjPck8Fcx5Whhqhl8V7B9SR3BAERky3PV+PAQ=; b=inE408hAP8QYWNOne/4CmKKEva
        r/OJh5QBPUD+Dan6Sxqk/toBvQQExFZPZAGQ5VnVzz8ED/Ht9CGiS1wBVXZIEckqx6hZRVmeXTo+F
        z5Xe0u8C45iq+D/ydhEi5LUk6I7eDWOMP+DxaI29zUgU/JHv+e8BG8aCcrggqlDk7i8qc8/Svt/fR
        LuO5AG50jE6sQ+5P1ahCElfazbKoIOApklFvb+lnMr24bwRoqV3lxNNz+SWkWS9l7e+3uphJg6TS4
        6iW7GBIci6GNDCWQBDaJb2J4zSobX3HHXOOgtz1Dp6S5R3h1MMxGoyJitrhuMCsleVekUiLkDaa63
        qMG3v8Lg==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qW0KA-00AAXM-TM; Tue, 15 Aug 2023 20:07:30 +0000
Date:   Tue, 15 Aug 2023 21:07:30 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Peter Xu <peterx@redhat.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 8/9] mm: Rearrange page flags
Message-ID: <ZNvbApJbLanU55Ze@casper.infradead.org>
References: <20230815032645.1393700-1-willy@infradead.org>
 <20230815032645.1393700-9-willy@infradead.org>
 <ZNvQ4EbQh/aAwK8L@x1n>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZNvQ4EbQh/aAwK8L@x1n>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Aug 15, 2023 at 03:24:16PM -0400, Peter Xu wrote:
> On Tue, Aug 15, 2023 at 04:26:44AM +0100, Matthew Wilcox (Oracle) wrote:
> > +++ b/include/linux/page-flags.h
> > @@ -99,13 +99,15 @@
> >   */
> >  enum pageflags {
> >  	PG_locked,		/* Page is locked. Don't touch. */
> > +	PG_writeback,		/* Page is under writeback */
> >  	PG_referenced,
> >  	PG_uptodate,
> >  	PG_dirty,
> >  	PG_lru,
> > +	PG_head,		/* Must be in bit 6 */
> 
> Could there be some explanation on "must be in bit 6" here?

Not on this line, no.  You get 40-50 characters to say something useful.
Happy to elaborate further in some other comment or in the commit log,
but not on this line.

The idea behind all of this is that _folio_order moves into the bottom
byte of _flags_1.  Because the order can never be greater than 63 (and
in practice I think the largest we're going to see is about 30 -- a 16GB
hugetlb page on some architectures), we know that PG_head and PG_waiters
will be clear, so we can write (folio->_flags_1 & 0xff) and the compiler
will just load a byte; it won't actually load the word and mask it.

We can't move PG_head any lower, or we'll risk having a tail page with
PG_head set (which can happen with the vmemmmap optimisation, but eugh).
And we don't want to move it any higher because then we'll have a flag
that cannot be reused in a tail page.  Bit 6 is the perfect spot for it.
