Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF274403420
	for <lists+io-uring@lfdr.de>; Wed,  8 Sep 2021 08:15:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347663AbhIHGQm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Sep 2021 02:16:42 -0400
Received: from verein.lst.de ([213.95.11.211]:38046 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232146AbhIHGQm (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Wed, 8 Sep 2021 02:16:42 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id C1A8D67373; Wed,  8 Sep 2021 08:15:30 +0200 (CEST)
Date:   Wed, 8 Sep 2021 08:15:30 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Kanchan Joshi <joshiiitr@gmail.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Kanchan Joshi <joshi.k@samsung.com>,
        Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        anuj20.g@samsung.com, Javier Gonzalez <javier.gonz@samsung.com>,
        hare@suse.de
Subject: Re: [RFC PATCH 2/6] nvme: wire-up support for async-passthru on
 char-device.
Message-ID: <20210908061530.GA28505@lst.de>
References: <20210805125539.66958-1-joshi.k@samsung.com> <CGME20210805125923epcas5p10e6c1b95475440be68f58244d5a3cb9a@epcas5p1.samsung.com> <20210805125539.66958-3-joshi.k@samsung.com> <20210907074650.GB29874@lst.de> <CA+1E3rJAav=4abJXs8fO49aiMNPqjv6dD7HBfhB+JQrNbaX3=A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+1E3rJAav=4abJXs8fO49aiMNPqjv6dD7HBfhB+JQrNbaX3=A@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Sep 07, 2021 at 09:50:27PM +0530, Kanchan Joshi wrote:
> > A few other notes:
> >
> >  - I suspect the ioctl_cmd really should move into the core using_cmd
> >    infrastructure
> 
> Yes, that seems possible by creating that field outside by combining
> "op" and "unused" below.
> +struct io_uring_cmd {
> + struct file *file;
> + __u16 op;
> + __u16 unused;
> + __u32 len;
> + __u64 pdu[5]; /* 40 bytes available inline for free use */
> +};

Two different issues here:

 - the idea of having a two layer indirection with op and a cmd doesn't
   really make much sense
 - if we want to avoid conflicts using 32-bit probably makes sense

So I'd turn op and unused into a single cmd field, use the ioctl encoding
macros for it (but preferably pick different numbers than the existing
ioctls).

> >  - that whole mix of user space interface and internal data in the
> >    ->pdu field is a mess.  What is the problem with deferring the
> >    request freeing into the user context, which would clean up
> >    quite a bit of that, especially if io_uring_cmd grows a private
> >    field.
> 
> That mix isn't great but the attempt was to save the allocation.
> And I was not very sure if it'd be fine to defer freeing the request
> until task-work fires up.

What would be the problem with the delaying?

> Even if we take that route, we would still need a place to store bio
> pointer (hopefully meta pointer can be extracted out of bio).
> Do you see it differently?

We don't need the bio pointer at all.  The old passthrough code needed
it when we still used block layer bonuce buffering for it.  But that
bounce buffering for passthrough commands got removed a while ago,
and even before nvme never used it.
