Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3049A2069AB
	for <lists+io-uring@lfdr.de>; Wed, 24 Jun 2020 03:47:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388002AbgFXBrD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Jun 2020 21:47:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387780AbgFXBrC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Jun 2020 21:47:02 -0400
Received: from casper.infradead.org (unknown [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E036C061573;
        Tue, 23 Jun 2020 18:47:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=SV+FHOxoc0B38PSkoJCLzzz/s0XSVgJTssyo0SVm0sM=; b=PsqGQVo7omY1pxGM+gvcBcWALS
        XgPC65w1lx+gweE8FT9WbQa61YMqc1NWr8MbKmZAhHhqxuj6958RXXQZboI78otwpXDNLnqTAUHlP
        55SEAEVkaFfu/7rKrH8PXcKOWkuS2e+f1R5KpEtHTmQOeNgWaf5DVfaPQDkhyT06oWz5S0oIY1bWJ
        WN24Lt+VysG+NlToqAZOTvQgNiEA+bXkwTf+IRBJ6PLclnSPAsAWCQrJlh9gzY53o+HLBvZJga7wG
        YcjeYTcdiIzPwqP72ly39bJmPwPvx41iBdGDxG4kfGJqCPaWyig9a+DRgJ/ZNeK1OYK1iLvlDOEcK
        d9tH4IsA==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jnuUv-0005LA-50; Wed, 24 Jun 2020 01:46:45 +0000
Date:   Wed, 24 Jun 2020 02:46:45 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Add@vger.kernel.org, support@vger.kernel.org, for@vger.kernel.org,
        async@vger.kernel.org, buffered@vger.kernel.org,
        reads@vger.kernel.org, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, akpm@linux-foundation.org,
        Jens Axboe <axboe@kernel.dk>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 05/15] mm: allow read-ahead with IOCB_NOWAIT set
Message-ID: <20200624014645.GJ21350@casper.infradead.org>
References: <20200618144355.17324-1-axboe@kernel.dk>
 <20200618144355.17324-6-axboe@kernel.dk>
 <20200624010253.GB5369@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200624010253.GB5369@dread.disaster.area>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Jun 24, 2020 at 11:02:53AM +1000, Dave Chinner wrote:
> On Thu, Jun 18, 2020 at 08:43:45AM -0600, Jens Axboe wrote:
> > The read-ahead shouldn't block, so allow it to be done even if
> > IOCB_NOWAIT is set in the kiocb.
> 
> Doesn't think break preadv2(RWF_NOWAIT) semantics for on buffered
> reads? i.e. this can now block on memory allocation for the page
> cache, which is something RWF_NOWAIT IO should not do....

Yes.  This eventually ends up in page_cache_readahead_unbounded()
which gets its gfp flags from readahead_gfp_mask(mapping).

I'd be quite happy to add a gfp_t to struct readahead_control.
The other thing I've been looking into for other reasons is adding
a memalloc_nowait_{save,restore}, which would avoid passing down
the gfp_t.
