Return-Path: <io-uring+bounces-10954-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 29982CA35FD
	for <lists+io-uring@lfdr.de>; Thu, 04 Dec 2025 12:04:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 195BB302A1D1
	for <lists+io-uring@lfdr.de>; Thu,  4 Dec 2025 11:04:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B28733B6D0;
	Thu,  4 Dec 2025 11:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mDHHlQMb"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EF15324713;
	Thu,  4 Dec 2025 11:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764846256; cv=none; b=tYHPBwjK42ZZRH8iRq5SpN1AaIQblFiQiXlH2r2uYUUXT+0dwuHSpbDa8cQdP+6G8EZWL05zj1piGmOSCyo6tr6Z/cuo2hYsuCQhLlAZz5e3oR4i8k9DW99hBWL/7NYQ5XpvtrIhE6+7ReiEkXMQz+6+DKsBpxhQCQI6yn/kYIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764846256; c=relaxed/simple;
	bh=TzysilqXOjLtCrRuSuiyww3cknmFSg1raJptQ/Up+VU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hsyhHVXgtrb3nNRM7owh29qoIMVVtNBuFt1niJ91euiJJ3geZbFSfMs6fkb/wnrxP9C14H+Z8Uen4c9yR0AMbYfYJtK75jh3jVrljRDgDGNnyh/nBgohY2VguHNEr/r0JBssoGy30cRrmVKiZwGdVVNvwoXDe46WIIx6WUrDme8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=mDHHlQMb; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=QdqWywYRLnjOqYVHKgtj3N4//GIROBVw9oqa0ZS355g=; b=mDHHlQMbDwfREYyLCJJdJ8aJmE
	6GyenRcqCkKxRoFrZtrTAzkuJmDPx9SnpyYywEoSFynjyN9SklwoSdmSDfowZxY50W3FqzmHljPQU
	t5KiPaxqmH4Y/15kkfsN8pB9jttHPhePJxU9O3HOA3hfVi9o1hxy4/01QC2VUpNfRusoh7Di2sD66
	gFWlkzoJleKZVr4brAQNrUvATdbJsXvfyJhCjOsX55GYdogNpXnCY701gwoLKGR0dWMyhhxMmY1lC
	Ua2kSeQx5lg+kXy0hUoSBoAj8KgiZtc9wukhjkjBc+5wjKEn6sKI8Li0GmY91Ro/0uVhETp3HSqbU
	84isKhKQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vR784-00000007tIE-2op0;
	Thu, 04 Dec 2025 11:04:08 +0000
Date: Thu, 4 Dec 2025 03:04:08 -0800
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
Subject: Re: [RFC v2 07/11] nvme-pci: implement dma_token backed requests
Message-ID: <aTFqqNMR9i89puxB@infradead.org>
References: <cover.1763725387.git.asml.silence@gmail.com>
 <a86bbe2d8d105ed2c342749cd46ece2d1c537821.1763725388.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a86bbe2d8d105ed2c342749cd46ece2d1c537821.1763725388.git.asml.silence@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> +static void nvme_sync_dma(struct nvme_dev *nvme_dev, struct request *req,
> +			  enum dma_data_direction dir)
> +{
> +	struct blk_mq_dma_map *map = req->dma_map;
> +	int length = blk_rq_payload_bytes(req);
> +	bool for_cpu = dir == DMA_FROM_DEVICE;
> +	struct device *dev = nvme_dev->dev;
> +	dma_addr_t *dma_list = map->private;
> +	struct bio *bio = req->bio;
> +	int offset, map_idx;
> +
> +	offset = bio->bi_iter.bi_bvec_done;
> +	map_idx = offset / NVME_CTRL_PAGE_SIZE;
> +	length += offset & (NVME_CTRL_PAGE_SIZE - 1);
> +
> +	while (length > 0) {
> +		u64 dma_addr = dma_list[map_idx++];
> +
> +		if (for_cpu)
> +			__dma_sync_single_for_cpu(dev, dma_addr,
> +						  NVME_CTRL_PAGE_SIZE, dir);
> +		else
> +			__dma_sync_single_for_device(dev, dma_addr,
> +						     NVME_CTRL_PAGE_SIZE, dir);
> +		length -= NVME_CTRL_PAGE_SIZE;
> +	}

This looks really inefficient.  Usually the ranges in the dmabuf should
be much larger than a controller page.


> +static void nvme_unmap_premapped_data(struct nvme_dev *dev,
> +				      struct request *req)
> +{
> +	struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
> +
> +	if (rq_data_dir(req) == READ)
> +		nvme_sync_dma(dev, req, DMA_FROM_DEVICE);
> +	if (!(iod->flags & IOD_SINGLE_SEGMENT))
> +		nvme_free_descriptors(req);
> +}

This doesn't really unmap anything :)

Also the dma ownership rules say that you always need to call the
sync_to_device helpers before I/O and the sync_to_cpu helpers after I/O,
no matters if it is a read or write.  The implementations then makes
them a no-op where possible.

> +
> +	offset = bio->bi_iter.bi_bvec_done;
> +	map_idx = offset / NVME_CTRL_PAGE_SIZE;
> +	offset &= (NVME_CTRL_PAGE_SIZE - 1);
> +
> +	prp1_dma = dma_list[map_idx++] + offset;
> +
> +	length -= (NVME_CTRL_PAGE_SIZE - offset);
> +	if (length <= 0) {
> +		prp2_dma = 0;

Urgg, why is this building PRPs instead of SGLs?  Yes, SGLs are an
optional feature, but for devices where you want to micro-optimize
like this I think we should simply require them.  This should cut
down on both the memory use and the amount of special mapping code.


