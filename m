Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86F9F2D48ED
	for <lists+io-uring@lfdr.de>; Wed,  9 Dec 2020 19:28:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733012AbgLISZs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Dec 2020 13:25:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732999AbgLISZj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Dec 2020 13:25:39 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 960DFC061794;
        Wed,  9 Dec 2020 10:24:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=pcAaVjDl49Iamy5QPMGXn9DbU0vRfNVF7xcOe8VbuB4=; b=WPu8mGcvy9y+VElW9HrVYxZoIB
        aX9/2rIN6cL9+t3qvpy2ct5WkcmU6WDT/rl64guoJfIv+o6lcxcohGcDUZ0G+lPEme3WcJcsVzv4b
        9EdMc1siLwb9KNN89rpHojP5m8McqAyPica3DbLXi3KLYmu8oyygBSmy5Kc7VyU3CNeluTMYisgGU
        NZUCPBzx8X/UIc18emuQUF3YReHHtRA3YurT0E091hBbJtylK7+Ix3Wljd0Kem+GcGtDeB5PLmboZ
        RoPyz0lSSXKfuhociMcvByp+HU9DZq9lLzrdSNcGdvfIdRQsYT6h3nGyUc0dTTzjx4E3Hudc/VTVM
        ghACqIPg==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kn492-0000Fn-7a; Wed, 09 Dec 2020 18:24:56 +0000
Date:   Wed, 9 Dec 2020 18:24:56 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
        io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] iov: introduce ITER_BVEC_FLAG_FIXED
Message-ID: <20201209182456.GR7338@casper.infradead.org>
References: <cover.1607477897.git.asml.silence@gmail.com>
 <de27dbca08f8005a303e5efd81612c9a5cdcf196.1607477897.git.asml.silence@gmail.com>
 <20201209083645.GB21968@infradead.org>
 <20201209130723.GL3579531@ZenIV.linux.org.uk>
 <b6cd4108-dbfe-5753-768f-92f55f38d6cd@gmail.com>
 <20201209175553.GA26252@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201209175553.GA26252@infradead.org>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Dec 09, 2020 at 05:55:53PM +0000, Christoph Hellwig wrote:
> On Wed, Dec 09, 2020 at 01:37:05PM +0000, Pavel Begunkov wrote:
> > Yeah, I had troubles to put comments around, and it's still open.
> > 
> > For current cases it can be bound to kiocb, e.g. "if an bvec iter passed
> > "together" with kiocb then the vector should stay intact up to 
> > ->ki_complete()". But that "together" is rather full of holes.
> 
> What about: "For bvec based iters the bvec must not be freed until the
> I/O has completed.  For asynchronous I/O that means it must be freed
> no earlier than from ->ki_complete."

Perhaps for the second sentence "If the I/O is completed asynchronously,
the bvec must not be freed before ->ki_complete() has been called"?
