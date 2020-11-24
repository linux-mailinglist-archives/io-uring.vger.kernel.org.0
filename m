Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C91E12C240D
	for <lists+io-uring@lfdr.de>; Tue, 24 Nov 2020 12:28:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728711AbgKXLZw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 24 Nov 2020 06:25:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728346AbgKXLZw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 24 Nov 2020 06:25:52 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5879EC0613D6;
        Tue, 24 Nov 2020 03:25:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=1Dpp35VNzzVY1mp0WA/1Cvo1UHAnm1YWWDrLG3ha8rE=; b=MFZotgzjDln27OPQ2DNNT42slG
        6vQ5a/ewh8C1T8ij73qDW+8f9nfl/3jWUnhcflW4k8GnUn6HINjYaQUMUqT2LAruEJj9+VhaBwSan
        P7aHYs+TIVXrKl/H505uH3yUZmlOmn1TvUCeLnRal+jspF5EbSzJXihplXNSlsl2bpNKKnGzBfXN3
        w1w9hLNVdVlb6rVAH1CKu34Yy9eULOSK6q27s4+w85kaNRttS3kaRaMILPvi70rGK6Do7h8eyZeCi
        QI/QHq2YCKdD+Hah/GPLIZYdApXrUrRKlYz/Ygz0se8V/BjWhgr6vUswjI4oZVZ4wTuJ/Z1qzHEaL
        XR8dtOSQ==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1khWSB-0007Cm-Vv; Tue, 24 Nov 2020 11:25:48 +0000
Date:   Tue, 24 Nov 2020 11:25:47 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     JeffleXu <jefflexu@linux.alibaba.com>
Cc:     Christoph Hellwig <hch@infradead.org>, axboe@kernel.dk,
        ming.lei@redhat.com, linux-block@vger.kernel.org,
        io-uring@vger.kernel.org, joseph.qi@linux.alibaba.com
Subject: Re: [PATCH v4 2/2] block,iomap: disable iopoll when split needed
Message-ID: <20201124112547.GA26805@infradead.org>
References: <20201117075625.46118-1-jefflexu@linux.alibaba.com>
 <20201117075625.46118-3-jefflexu@linux.alibaba.com>
 <20201119175516.GB20944@infradead.org>
 <ed355fc8-6fc8-5ffd-f1e9-6ba19f761a09@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ed355fc8-6fc8-5ffd-f1e9-6ba19f761a09@linux.alibaba.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Nov 20, 2020 at 06:06:54PM +0800, JeffleXu wrote:
> 
> On 11/20/20 1:55 AM, Christoph Hellwig wrote:
> > > diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
> > > index 933f234d5bec..396ac0f91a43 100644
> > > --- a/fs/iomap/direct-io.c
> > > +++ b/fs/iomap/direct-io.c
> > > @@ -309,6 +309,16 @@ iomap_dio_bio_actor(struct inode *inode, loff_t pos, loff_t length,
> > >   		copied += n;
> > >   		nr_pages = iov_iter_npages(dio->submit.iter, BIO_MAX_PAGES);
> > > +		/*
> > > +		 * The current dio needs to be split into multiple bios here.
> > > +		 * iopoll for split bio will cause subtle trouble such as
> > > +		 * hang when doing sync polling, while iopoll is initially
> > > +		 * for small size, latency sensitive IO. Thus disable iopoll
> > > +		 * if split needed.
> > > +		 */
> > > +		if (nr_pages)
> > > +			dio->iocb->ki_flags &= ~IOCB_HIPRI;
> > I think this is confusing two things.
> 
> Indeed there's two level of split concerning this issue when doing sync
> iopoll.
> 
> 
> The first is that one bio got split in block-core, and patch 1 of this patch
> set just fixes this.
> 
> 
> Second is that one dio got split into multiple bios in fs layer, and patch 2
> fixes this.
> 
> 
> >   One is that we don't handle
> > polling well when there are multiple bios.  For this I think we should
> > only call bio_set_polled when we know there is a single bio.
> 
> 
> How about the following patch:
> 
> 
> --- a/fs/iomap/direct-io.c
> +++ b/fs/iomap/direct-io.c
> @@ -60,12 +60,12 @@ int iomap_dio_iopoll(struct kiocb *kiocb, bool spin)
> ??EXPORT_SYMBOL_GPL(iomap_dio_iopoll);
> 
> ??static void iomap_dio_submit_bio(struct iomap_dio *dio, struct iomap
> *iomap,
> -???????????????????????????? struct bio *bio, loff_t pos)
> +???????????????????????????? struct bio *bio, loff_t pos, bool split)

This seems pretty messed up by your mailer and I have a hard time
reading it.  Can you resend it?
