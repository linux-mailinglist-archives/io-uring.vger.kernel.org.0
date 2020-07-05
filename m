Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DEBB214FC4
	for <lists+io-uring@lfdr.de>; Sun,  5 Jul 2020 23:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728517AbgGEVKB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 5 Jul 2020 17:10:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727894AbgGEVJ7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 5 Jul 2020 17:09:59 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A1B7C061794;
        Sun,  5 Jul 2020 14:09:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=inEU3oQ+fuWuXfgS+GP0UuqV3tTNV60gtBVc6wGf3Ok=; b=HR+x47TMeyPHIiGV39gQ2Eb4O7
        4xn/to8UIqb9ftEyDpin0981+exRR3sVrjFtyGGT7pRo7fKAlq8c31K24Bs6evBOzctgktXIlX7Tf
        ygQACE7/o+8v6j+WNbkgVoWNhSiNDK++kNo27iUr0EDlXEQVS4azhIX9d7YS/+MTW4LmxUdP0T+Vr
        jWXpzu09rr3rYiZbfDGEXDeyM3fZTMRz4/mLClbEd2Hq5+5Qw+8YcBXu9f/7ZXFzojqizagexJR6Y
        2WMHQJPP8HbqkU2bU03r7rkLOAxN/jFoOD6JazojpBBiGedzP4a00iYzFvxZPPzgfT/z+xpe5/Whm
        w19qQPyA==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jsBtT-0000IB-CY; Sun, 05 Jul 2020 21:09:47 +0000
Date:   Sun, 5 Jul 2020 22:09:47 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Kanchan Joshi <joshi.k@samsung.com>, viro@zeniv.linux.org.uk,
        bcrl@kvack.org, hch@infradead.org, Damien.LeMoal@wdc.com,
        asml.silence@gmail.com, linux-fsdevel@vger.kernel.org,
        mb@lightnvm.io, linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        Selvakumar S <selvakuma.s1@samsung.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
Subject: Re: [PATCH v3 4/4] io_uring: add support for zone-append
Message-ID: <20200705210947.GW25523@casper.infradead.org>
References: <1593974870-18919-1-git-send-email-joshi.k@samsung.com>
 <CGME20200705185227epcas5p16fba3cb92561794b960184c89fdf2bb7@epcas5p1.samsung.com>
 <1593974870-18919-5-git-send-email-joshi.k@samsung.com>
 <fe0066b7-5380-43ee-20b2-c9b17ba18e4f@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fe0066b7-5380-43ee-20b2-c9b17ba18e4f@kernel.dk>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sun, Jul 05, 2020 at 03:00:47PM -0600, Jens Axboe wrote:
> On 7/5/20 12:47 PM, Kanchan Joshi wrote:
> > From: Selvakumar S <selvakuma.s1@samsung.com>
> > 
> > For zone-append, block-layer will return zone-relative offset via ret2
> > of ki_complete interface. Make changes to collect it, and send to
> > user-space using cqe->flags.
> > 
> > Signed-off-by: Selvakumar S <selvakuma.s1@samsung.com>
> > Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
> > Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
> > Signed-off-by: Javier Gonzalez <javier.gonz@samsung.com>
> > ---
> >  fs/io_uring.c | 21 +++++++++++++++++++--
> >  1 file changed, 19 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/io_uring.c b/fs/io_uring.c
> > index 155f3d8..cbde4df 100644
> > --- a/fs/io_uring.c
> > +++ b/fs/io_uring.c
> > @@ -402,6 +402,8 @@ struct io_rw {
> >  	struct kiocb			kiocb;
> >  	u64				addr;
> >  	u64				len;
> > +	/* zone-relative offset for append, in sectors */
> > +	u32			append_offset;
> >  };
> 
> I don't like this very much at all. As it stands, the first cacheline
> of io_kiocb is set aside for request-private data. io_rw is already
> exactly 64 bytes, which means that you're now growing io_rw beyond
> a cacheline and increasing the size of io_kiocb as a whole.
> 
> Maybe you can reuse io_rw->len for this, as that is only used on the
> submission side of things.

I'm surprised you aren't more upset by the abuse of cqe->flags for the
address.

What do you think to my idea of interpreting the user_data as being a
pointer to somewhere to store the address?  Obviously other things
can be stored after the address in the user_data.

Or we could have a separate flag to indicate that is how to interpret
the user_data.
