Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C35643D4924
	for <lists+io-uring@lfdr.de>; Sat, 24 Jul 2021 20:22:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229672AbhGXRmG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 24 Jul 2021 13:42:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbhGXRmG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 24 Jul 2021 13:42:06 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EE6EC061575;
        Sat, 24 Jul 2021 11:22:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=q16vN20drSq73+cubZqjYZ5dEuIK62CsrBgg1E6PqNM=; b=nU5tZaJmbBavWe3djLe4y6QjBr
        0WfdGlp6eIQUFg3oPsY4KheMlablb9VIsounTAr2YIiz0JhWNyPlKpAo20JCdFFQeNcmjI2Mxwyfi
        n3iGrFaETZUevA8aWdLDbrpolOMPAweiZG6bR+ToVXRwHh4HZiIkMNEMM5VhKB2ZZf9MtWexh+HrM
        6mK9CbUJY/V+MCWUmWje3GcPMJ5F9nmfA9exxhrep/pqNYF9wa7DQXhJec2rLyUouPBMjo2V8yxm1
        Ss6sz1HJmhNJ6tg9Uz664bk2TVezn9Y894GQeIzdZY7Dsl9ayIfEBgZDq2xy5z76TheI/1jkExD8w
        X7CfsP3A==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m7MI0-00CSZF-OC; Sat, 24 Jul 2021 18:22:26 +0000
Date:   Sat, 24 Jul 2021 19:22:20 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-aio@kvack.org
Subject: Re: [PATCH 0/2] Close a hole where IOCB_NOWAIT reads could sleep
Message-ID: <YPxaXE0mf26aqy/O@casper.infradead.org>
References: <20210711150927.3898403-1-willy@infradead.org>
 <a3d0f8da-ffb4-25a3-07a1-79987ce788c5@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a3d0f8da-ffb4-25a3-07a1-79987ce788c5@kernel.dk>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sun, Jul 11, 2021 at 07:44:07PM -0600, Jens Axboe wrote:
> On 7/11/21 9:09 AM, Matthew Wilcox (Oracle) wrote:
> > I noticed a theoretical case where an IOCB_NOWAIT read could sleep:
> > 
> > filemap_get_pages
> >   filemap_get_read_batch
> >   page_cache_sync_readahead
> >     page_cache_sync_ra
> >       ondemand_readahead
> >         do_page_cache_ra
> >         page_cache_ra_unbounded
> >           gfp_t gfp_mask = readahead_gfp_mask(mapping);
> >           memalloc_nofs_save()
> >           __page_cache_alloc(gfp_mask);
> > 
> > We're in a nofs context, so we're not going to start new IO, but we might
> > wait for writeback to complete.  We generally don't want to sleep for IO,
> > particularly not for IO that isn't related to us.
> > 
> > Jens, can you run this through your test rig and see if it makes any
> > practical difference?
> 
> You bet, I'll see if I can trigger this condition and verify we're no
> longer blocking on writeback. Thanks for hacking this up.

Did you have any success yet?
