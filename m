Return-Path: <io-uring+bounces-2891-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B3FCB95ADFD
	for <lists+io-uring@lfdr.de>; Thu, 22 Aug 2024 08:50:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6F8BF280F7F
	for <lists+io-uring@lfdr.de>; Thu, 22 Aug 2024 06:50:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C81E3B290;
	Thu, 22 Aug 2024 06:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nwRRN2fL"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EF8A13C67A;
	Thu, 22 Aug 2024 06:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724309442; cv=none; b=tgPN398OUngJtd/0Dhg3FT9fPWok4QWgsDYDWomC7JaG0Vnqra/dkYmHEN0+Pd6FU9w0yCM2FDXphXquoQEWp1Jdi66nKyL801bV4t6JHkJUJAOq5wGUJn0tezrvXGd7KzBN2SVZMhHN1y8vpuB4jKnNfJoQDZySXc2A8lrN+fA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724309442; c=relaxed/simple;
	bh=UZR/hpnb6NC+W2pLhDE5H3jUDisikDAzw0UGUdWcbg4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uTY/ayzNi2n/TVYQhyDSWlOkfG6P01aCT3fVpXPkBi5CvyDTTrN98SvnrafKKowvu3ZCOhJk/zLNs1i4CL1Z0TWbZGaIo2mPL9NzN8iyDlrxNTjjAFnw3PtKeBRp8tSbla2Mqe+cEhKGlXKblvH5Bt/cuN9/SHVThef+v/h1giE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=nwRRN2fL; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Hh3lK7YA6tMyNt0NgMPClW6TkjPTd/Pcc2Kjk9ny2+k=; b=nwRRN2fLTCTe+ngKU1+o3kckPb
	zTTiHZIsNbmSEnHWnLcQBFTW1gla0Yum+4VDz2yoS+tjovRcVPptiExldtNBBj+MdwqWdw/8fZjJo
	sB++dNsqczkxj8/VzdyFpedBaqJ3bvnlUFVPFD4YXLBozzzc4Wrb2UbhXmNhvd3V4dfFr9En2OUTA
	ufaN23HEzOcFKPDxlyR/fGITUGY17pf7VbnaL49UHyduQrl0MyYQRvedpvcFSOc8xHUuU6qqX5dg9
	skqMEMcdBMA6chGJY/HTPsGdnsxYpCn7t+qtd2NIJbcxqDP308nhB6pfPvb6gY9OmPZL6FjU0zSFY
	2LqQVcBA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sh1ea-0000000Bh9n-2pCE;
	Thu, 22 Aug 2024 06:50:40 +0000
Date: Wed, 21 Aug 2024 23:50:40 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	Conrad Meyer <conradmeyer@meta.com>, linux-block@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v2 6/7] block: implement async wire write zeroes
Message-ID: <ZsbfwKgdLZKVHOMD@infradead.org>
References: <cover.1724297388.git.asml.silence@gmail.com>
 <09c5ef75c04c17ee2fd551da50fc9aae3bfce50a.1724297388.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <09c5ef75c04c17ee2fd551da50fc9aae3bfce50a.1724297388.git.asml.silence@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Aug 22, 2024 at 04:35:56AM +0100, Pavel Begunkov wrote:
> Add another io_uring cmd for block layer implementing asynchronous write
> zeroes. It reuses helpers we've added for async discards, and inherits
> the code structure as well as all considerations in regards to page
> cache races.

Most comments from discard apply here as well.

> +static int blkdev_queue_cmd(struct io_uring_cmd *cmd, struct block_device *bdev,
> +			    uint64_t start, uint64_t len, sector_t limit,
> +			    blk_opf_t opf)

This feels a little over generic as it doesn't just queue any random
command.

> +static int blkdev_cmd_write_zeroes(struct io_uring_cmd *cmd,
> +				   struct block_device *bdev,
> +				   uint64_t start, uint64_t len, bool nowait)
> +{
> +	blk_opf_t opf = REQ_OP_WRITE_ZEROES | REQ_NOUNMAP;
> +
> +	if (nowait)
> +		opf |= REQ_NOWAIT;
> +	return blkdev_queue_cmd(cmd, bdev, start, len,
> +				bdev_write_zeroes_sectors(bdev), opf);

So no support for fallback to Write of zero page here?  That's probably
the case where the async offload is needed most.

> +struct bio *blk_alloc_write_zeroes_bio(struct block_device *bdev,
> +					sector_t *sector, sector_t *nr_sects,
> +					gfp_t gfp_mask);

Please keep this in block/blk.h, no need to expose it to the entire
kernel.


