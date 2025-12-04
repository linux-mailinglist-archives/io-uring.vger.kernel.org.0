Return-Path: <io-uring+bounces-10951-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A8B5CA34DF
	for <lists+io-uring@lfdr.de>; Thu, 04 Dec 2025 11:51:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D603B30BA6E2
	for <lists+io-uring@lfdr.de>; Thu,  4 Dec 2025 10:48:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48B0833A702;
	Thu,  4 Dec 2025 10:48:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="M8iBbu9P"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9079A33A6FB;
	Thu,  4 Dec 2025 10:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764845291; cv=none; b=L/r0i+dLaDcYCDkG5wxHQX5rWnZUs3GSYwRAHuy7HC57siY65kb1sn1fYJ2JxqC0NAz1dpd1kEb0pXpLMBy7kr0cq+QCBQ/MugAqAX9isK/VcF8t2dG2TApSGeE5LDZ6igHiOuDNWrIjLqYpZdnzfjNWW1zVRuIbh0tE2vK6Td4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764845291; c=relaxed/simple;
	bh=MbL07Na+LynNXW1vFHtM/jzEkDQ36ogD3hpSXwl2/4w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fLEyzcouqBPNsDFmnEfaE7QcCiiNgoqSquQee4F1cynxJd6ulBiA/ZoiS6Iq2d9hctgzgG4+mOHGy6GzEoqcXS1mD99nLu3CYTfcM2aX+hfdD+gvm76QCSlxc7uGf8m+N/cSwnDFivE8CjDewGaNAjO7gu/2RNl56xkmDIDwv7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=M8iBbu9P; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=qChLaZR5s/GOpATx/ro3bLhyDBLy5vLepXdMy3KpsPw=; b=M8iBbu9PONMlpy6WlRxFuR4Ird
	98MVr8TkAx0Sgemgdq3Gu41MKeQPWi1aaNa50zkkYIyi5pG+WGKlMBygLzm+NAJRi3rGibTu65dmT
	Dz5l9oFrIwraG/+DFZcvGP6hOXtxX00lCB9HhOR/drO26CMYRuuxCgvuiTl4JfFPokU5knc0O62X0
	LgK2ulE/AGz9lYClwgZtmEGLsfv6BmVifbsy4ArB6FOnet9t+1l0d9xYGHg6t1KLqr5mXgIMH5Bio
	G2nqv9ApYUOWrniW3EdFQS0+jjSlmK1UCcAUOQvAst8P5C+u3YPS8b4cHGdz/CriIIYL++uYjs2n4
	5qmYwVmQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vR6sX-00000007rlX-2Wlb;
	Thu, 04 Dec 2025 10:48:05 +0000
Date: Thu, 4 Dec 2025 02:48:05 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: linux-block@vger.kernel.org, io-uring@vger.kernel.org,
	Vishal Verma <vishal1.verma@intel.com>, tushar.gohad@intel.com,
	Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org
Subject: Re: [RFC v2 04/11] block: introduce dma token backed bio type
Message-ID: <aTFm5dHzH3IRID8o@infradead.org>
References: <cover.1763725387.git.asml.silence@gmail.com>
 <12530de6d1907afb44be3e76e7668b935f1fd441.1763725387.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12530de6d1907afb44be3e76e7668b935f1fd441.1763725387.git.asml.silence@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> diff --git a/block/bio.c b/block/bio.c
> index 7b13bdf72de0..8793f1ee559d 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -843,6 +843,11 @@ static int __bio_clone(struct bio *bio, struct bio *bio_src, gfp_t gfp)
>  		bio_clone_blkg_association(bio, bio_src);
>  	}
>  
> +	if (bio_flagged(bio_src, BIO_DMA_TOKEN)) {
> +		bio->dma_token = bio_src->dma_token;
> +		bio_set_flag(bio, BIO_DMA_TOKEN);
> +	}

Historically __bio_clone itself does not clone the payload, just the
bio.  But we got rid of the callers that want to clone a bio but not
the payload long time ago.

I'd suggest a prep patch that moves assigning bi_io_vec from
bio_alloc_clone and bio_init_clone into __bio_clone, and given that they
are the same field that'll take carw of the dma token as well.
Alternatively do it in an if/else that the compiler will hopefully
optimize away.

> @@ -1349,6 +1366,10 @@ int bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter,
>  		bio_iov_bvec_set(bio, iter);
>  		iov_iter_advance(iter, bio->bi_iter.bi_size);
>  		return 0;
> +	} else if (iov_iter_is_dma_token(iter)) {

No else after an return please.

> +++ b/block/blk-merge.c
> @@ -328,6 +328,29 @@ int bio_split_io_at(struct bio *bio, const struct queue_limits *lim,
>  	unsigned nsegs = 0, bytes = 0, gaps = 0;
>  	struct bvec_iter iter;
>  
> +	if (bio_flagged(bio, BIO_DMA_TOKEN)) {

Please split the dmabuf logic into a self-contained
helper here.

> +		int offset = offset_in_page(bio->bi_iter.bi_bvec_done);
> +
> +		nsegs = ALIGN(bio->bi_iter.bi_size + offset, PAGE_SIZE);
> +		nsegs >>= PAGE_SHIFT;

Why are we hardcoding PAGE_SIZE based "segments" here?

> +
> +		if (offset & lim->dma_alignment || bytes & len_align_mask)
> +			return -EINVAL;
> +
> +		if (bio->bi_iter.bi_size > max_bytes) {
> +			bytes = max_bytes;
> +			nsegs = (bytes + offset) >> PAGE_SHIFT;
> +			goto split;
> +		} else if (nsegs > lim->max_segments) {

No else after a goto either.

