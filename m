Return-Path: <io-uring+bounces-2889-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C6C2C95ADA2
	for <lists+io-uring@lfdr.de>; Thu, 22 Aug 2024 08:37:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 61CADB221D4
	for <lists+io-uring@lfdr.de>; Thu, 22 Aug 2024 06:37:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13B2913A879;
	Thu, 22 Aug 2024 06:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="pA8e96YP"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D6C113AA46;
	Thu, 22 Aug 2024 06:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724308634; cv=none; b=BB1/YqMBAUDwAolk1bBdMe/AwXC2uaiwWW1fEGoQYkR55Knqie+hYJlgFyY6np/Kxk19IOMd0HUZ48EUXZUzzkrwYobl6afoiFEGn7h83BW179puIdOO2ldpYez+i5aN7PuU3spu9SribGG3kVMVnW0yX4my/cvldzOpxjzoDjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724308634; c=relaxed/simple;
	bh=SvnbOHj0IazUFTRI/1Y5Y5ADWCANL9v5iijTOuSmdPM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RkGkiWxvUyB6/lTIC5xL6jZwf+4Pyt3y+rJktSM44v4H7C5wVKYA3Wtnqv3RyFx0GvJ5gV84mKz4bCV3VZpLcu0zXIBgTlomGofSMGzk0Y6FMjGqTUL1t1amiAgYYqs98SgeVIzJmOdMJpQXIvtPP4YUpgB4tHyu9jSTR7aIvj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=pA8e96YP; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=YVqmFfkyhwbFCPM/4edvmn3bk8ddwJ9D/OM4QCDt1Gc=; b=pA8e96YPaXfS6Dyb6ttOptHB+n
	oOV+XXXxrrVqKUbaJ7F3ifCCWLsspD0D16W0BAwroSghWHiKY8m8Ry7XVtJp3njJDWPj7VGObTe2n
	YKDW0Vwse/d3qoUzUNunwDRnfUjrx6sjx7h7kklclOKTuXjNy+iz852SGgfz2nyzt5G9fpspzna24
	xrsD+w+cPmP4iL55M3ZpvTTQ3jXr+En0eKAp6VRB6pIg+Y7XmJd5gjjriSdhSuEJuSE42wg2VdUqr
	++5UI71CMvz/TSHIrD5yy1sIO87OiVKwT5uDObmB/podN/BrlwR/c+Mds9lr+IfTjrERfUHkxfnnM
	aMVrxTGQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sh1RY-0000000Bdc4-04bN;
	Thu, 22 Aug 2024 06:37:12 +0000
Date: Wed, 21 Aug 2024 23:37:11 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	Conrad Meyer <conradmeyer@meta.com>, linux-block@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v2 3/7] filemap: introduce filemap_invalidate_pages
Message-ID: <ZsbclxkmhnBQvYih@infradead.org>
References: <cover.1724297388.git.asml.silence@gmail.com>
 <5bf2b0f08ec25fa649f04c0847722c6b028f660c.1724297388.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5bf2b0f08ec25fa649f04c0847722c6b028f660c.1724297388.git.asml.silence@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Aug 22, 2024 at 04:35:53AM +0100, Pavel Begunkov wrote:
> kiocb_invalidate_pages() is useful for the write path, however not
> everything is backed by kiocb and we want to reuse the function for bio
> based discard implementation. Extract and and reuse a new helper called
> filemap_invalidate_pages(), which takes a argument indicating whether it
> should be non-blocking and might return -EAGAIN.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  include/linux/pagemap.h |  2 ++
>  mm/filemap.c            | 18 +++++++++++++-----
>  2 files changed, 15 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
> index d9c7edb6422b..e39c3a7ce33c 100644
> --- a/include/linux/pagemap.h
> +++ b/include/linux/pagemap.h
> @@ -32,6 +32,8 @@ int invalidate_inode_pages2_range(struct address_space *mapping,
>  		pgoff_t start, pgoff_t end);
>  int kiocb_invalidate_pages(struct kiocb *iocb, size_t count);
>  void kiocb_invalidate_post_direct_write(struct kiocb *iocb, size_t count);
> +int filemap_invalidate_pages(struct address_space *mapping,
> +			     loff_t pos, loff_t end, bool nowait);
>  
>  int write_inode_now(struct inode *, int sync);
>  int filemap_fdatawrite(struct address_space *);
> diff --git a/mm/filemap.c b/mm/filemap.c
> index d62150418b91..74baec119239 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -2712,14 +2712,12 @@ int kiocb_write_and_wait(struct kiocb *iocb, size_t count)
>  }
>  EXPORT_SYMBOL_GPL(kiocb_write_and_wait);
>  
> -int kiocb_invalidate_pages(struct kiocb *iocb, size_t count)
> +int filemap_invalidate_pages(struct address_space *mapping,
> +			     loff_t pos, loff_t end, bool nowait)
>  {
> -	struct address_space *mapping = iocb->ki_filp->f_mapping;
> -	loff_t pos = iocb->ki_pos;
> -	loff_t end = pos + count - 1;
>  	int ret;
>  
> -	if (iocb->ki_flags & IOCB_NOWAIT) {
> +	if (nowait) {
>  		/* we could block if there are any pages in the range */
>  		if (filemap_range_has_page(mapping, pos, end))
>  			return -EAGAIN;
> @@ -2738,6 +2736,16 @@ int kiocb_invalidate_pages(struct kiocb *iocb, size_t count)
>  	return invalidate_inode_pages2_range(mapping, pos >> PAGE_SHIFT,
>  					     end >> PAGE_SHIFT);
>  }
> +
> +int kiocb_invalidate_pages(struct kiocb *iocb, size_t count)
> +{
> +	struct address_space *mapping = iocb->ki_filp->f_mapping;
> +	loff_t pos = iocb->ki_pos;
> +	loff_t end = pos + count - 1;
> +
> +	return filemap_invalidate_pages(mapping, pos, end,

No real need for the end variable here.  And maybe not for pos either.


