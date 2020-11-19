Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C33482B9A33
	for <lists+io-uring@lfdr.de>; Thu, 19 Nov 2020 18:56:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727535AbgKSRzV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 19 Nov 2020 12:55:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727025AbgKSRzV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 19 Nov 2020 12:55:21 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC4CFC0613CF;
        Thu, 19 Nov 2020 09:55:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=JjQyKuzDtffJI6b/I1nWPbVBd/Nq93Zr9O4+9ZYVD34=; b=i0fi1C592zMyTAmKZS5NpOYcZU
        U0qjFhkvVaekIrCc9actnnssLTWaaY8hcv2bV5+XBzKauAfaX6ssU3blBGy1CMZXrVF7ZTdaRvtpv
        xN8r0lptBwuJ5D1AO6gdaXCTWH2xiLmAJP3lY9FGw6EdHjBU7yF4aeLKCMDazDBwedvNqsftaGRrW
        c7a1uoOEhfoIByWf5lF2ZAZzrW2L9s7qf6HX8UqlJFKHRFlc9b4HxF1TpmacDaceOdFb/0/eIlIUo
        iOOXbgdi9CBPaiLxycU+oLrpARqx+Mka94pEoXpEwIit3q3kvhAVugJ6Cl3XJJL+masMYmTShxg8z
        Uc35PMMQ==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kfo9M-0005wK-Ft; Thu, 19 Nov 2020 17:55:16 +0000
Date:   Thu, 19 Nov 2020 17:55:16 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Jeffle Xu <jefflexu@linux.alibaba.com>
Cc:     axboe@kernel.dk, hch@infradead.org, ming.lei@redhat.com,
        linux-block@vger.kernel.org, io-uring@vger.kernel.org,
        joseph.qi@linux.alibaba.com
Subject: Re: [PATCH v4 2/2] block,iomap: disable iopoll when split needed
Message-ID: <20201119175516.GB20944@infradead.org>
References: <20201117075625.46118-1-jefflexu@linux.alibaba.com>
 <20201117075625.46118-3-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201117075625.46118-3-jefflexu@linux.alibaba.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

> diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
> index 933f234d5bec..396ac0f91a43 100644
> --- a/fs/iomap/direct-io.c
> +++ b/fs/iomap/direct-io.c
> @@ -309,6 +309,16 @@ iomap_dio_bio_actor(struct inode *inode, loff_t pos, loff_t length,
>  		copied += n;
>  
>  		nr_pages = iov_iter_npages(dio->submit.iter, BIO_MAX_PAGES);
> +		/*
> +		 * The current dio needs to be split into multiple bios here.
> +		 * iopoll for split bio will cause subtle trouble such as
> +		 * hang when doing sync polling, while iopoll is initially
> +		 * for small size, latency sensitive IO. Thus disable iopoll
> +		 * if split needed.
> +		 */
> +		if (nr_pages)
> +			dio->iocb->ki_flags &= ~IOCB_HIPRI;

I think this is confusing two things.  One is that we don't handle
polling well when there are multiple bios.  For this I think we should
only call bio_set_polled when we know there is a single bio.  But it
has nothing to do with a bio being split, as we can't know that at this
level.
