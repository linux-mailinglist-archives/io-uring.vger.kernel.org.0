Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17BA3219D5F
	for <lists+io-uring@lfdr.de>; Thu,  9 Jul 2020 12:16:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726345AbgGIKQO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Jul 2020 06:16:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726140AbgGIKQN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Jul 2020 06:16:13 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 337FAC061A0B;
        Thu,  9 Jul 2020 03:16:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=+4y1tH7JgQGg/m4Y2HPNpPcl0NpQqyVNAfEoubft9uY=; b=kfAlLVsRpqnbZQEAK40SMcQERa
        AJ3dkC/7hx9RCDtrf0/3gke1gSrkFxyJf+EkHzqRSG2oK+901gljldEXBKdkGbomGpYn1EapFRu6Q
        HtpsebXW3mT3AJ7A/iUdncW27w3voAXB1ykeDfelYyIfxvgjmF32l4dB+dqkg6GDU3HVaDCf1B3VM
        hl9DInOwoFkeAlr6t+Hz9maFrGkMHr+BcG6SApp1XiUze3uBczRlS9d45yOfyfdaQ8BymLq8TlYfV
        Bp9/pC3nrvuEJg/IaqP0CHEfyJgNA9ZAl4XPHDXNx6u58PfGJvJfsmDwELO/eD2GabcXZTwTR2gff
        AFhDMLkg==;
Received: from [2001:4bb8:188:5f50:7053:304b:bf82:82cf] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jtTax-0000ZA-F3; Thu, 09 Jul 2020 10:15:59 +0000
Date:   Thu, 9 Jul 2020 12:15:59 +0200
From:   Christoph Hellwig <hch@infradead.org>
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
Message-ID: <20200709085501.GA64935@infradead.org>
References: <1593974870-18919-1-git-send-email-joshi.k@samsung.com>
 <CGME20200705185227epcas5p16fba3cb92561794b960184c89fdf2bb7@epcas5p1.samsung.com>
 <1593974870-18919-5-git-send-email-joshi.k@samsung.com>
 <fe0066b7-5380-43ee-20b2-c9b17ba18e4f@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fe0066b7-5380-43ee-20b2-c9b17ba18e4f@kernel.dk>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sun, Jul 05, 2020 at 03:00:47PM -0600, Jens Axboe wrote:
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

We don't actually need any new field at all.  By the time the write
returned ki_pos contains the offset after the write, and the res
argument to ->ki_complete contains the amount of bytes written, which
allow us to trivially derive the starting position.
