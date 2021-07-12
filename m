Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 467393C5E7B
	for <lists+io-uring@lfdr.de>; Mon, 12 Jul 2021 16:38:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235026AbhGLOlU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 12 Jul 2021 10:41:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231194AbhGLOlU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 12 Jul 2021 10:41:20 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE908C0613DD;
        Mon, 12 Jul 2021 07:38:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Zi6WvyUoRpg2h8P9u2NqZlcgTX1hCKKGUHrSN74lVfY=; b=ctN8+h0TXRH6w4a8PvJ0G554pM
        P0I+WXOy/gAJ0Kro6EZwZjr3GHXEuZyNTMzV6rpjI7s6BCCTLPyj2iMhxjIiargWCLPVsz5MnWOfj
        dqJxG2XFhuWWnug9x2ZC2/C/jidp5WIoC9M19NIzVZojsmLcQmbJocT/zopAdCI2D9OC5w4iAxnR9
        Iq3sKs+iEtMqRLUKBXkaXigQ+qfAzasspLGs1O6ObsDNvhak+sqA6R/VerdWgj7We/TLHIgxkhE5a
        JXg5hXT2yPL2fIvQA46PzkbGC7af8kym/ZASLyNAkEASfykDnj1u6/vNjDt2h0AaRvgwqzFpyNj/o
        qZ2FfYBQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m2x43-0007lL-H9; Mon, 12 Jul 2021 14:37:52 +0000
Date:   Mon, 12 Jul 2021 15:37:43 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-aio@kvack.org
Subject: Re: [PATCH 1/2] mm/readahead: Add gfp_flags to ractl
Message-ID: <YOxTt4nMFP+uFIM3@casper.infradead.org>
References: <20210711150927.3898403-1-willy@infradead.org>
 <20210711150927.3898403-2-willy@infradead.org>
 <YOwov+dVx5RxIyFw@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YOwov+dVx5RxIyFw@infradead.org>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Jul 12, 2021 at 12:34:23PM +0100, Christoph Hellwig wrote:
> On Sun, Jul 11, 2021 at 04:09:26PM +0100, Matthew Wilcox (Oracle) wrote:
> > It is currently possible for an I/O request that specifies IOCB_NOWAIT
> > to sleep waiting for I/O to complete in order to allocate pages for
> > readahead.  In order to fix that, we need the caller to be able to
> > specify the GFP flags to use for memory allocation in the rest of the
> > readahead path.
> 
> The file systems also need to respect it for their bio or private
> data allocation.  And be able to cope with failure, which they currently
> don't have to for sleeping bio allocations.

Yes, they should.  This patch doesn't make that problem worse than it is
today, and gets the desired GFP flags down to the file systems, which is
needed for the full fix.
