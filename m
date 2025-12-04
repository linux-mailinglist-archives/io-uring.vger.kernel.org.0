Return-Path: <io-uring+bounces-10953-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F5A6CA35D3
	for <lists+io-uring@lfdr.de>; Thu, 04 Dec 2025 12:01:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 09F1F3028F69
	for <lists+io-uring@lfdr.de>; Thu,  4 Dec 2025 11:00:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C2BB33A01B;
	Thu,  4 Dec 2025 11:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="j4xMVX6Z"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAD4F339709;
	Thu,  4 Dec 2025 11:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764846004; cv=none; b=bOwzbh04qIfz4DZeg14PETJSBT3WHq9c8KT2DwrltIMBQ6xMmDIKMYn0brsfJoYoMNZe8W+ZRKKPacZCod5AWYXxXoLfmKW8qpblSKz9w+jOGyhsQQ3ocfR9vF9PZcnVqnEkwbpiEfgLixRc3SHL9DLK75ffXJ5sF+rEOYzoYgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764846004; c=relaxed/simple;
	bh=PcKyBqinvAI6N+VdlDC84V66ovJxPXuGvACfNnlui4U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PcOtc2rDsrEbqCZjJ2Tzd3X370xudRuRBXGyi3olZWF39PzPNvJjY+oKgFait+Vb24o+x9ojZZJcHIhJnqGCbIIP4eeBcBKPDPkvZT+DcIzNhHbtWn+9vzXYG6vhyT2lcjEAkCgHRu3zlJP7crI+WDqKBsKV1K6r0PDQlm+gwPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=j4xMVX6Z; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=CPr0hvEES4qg8auZHNPhlav8VYvcjZHHtnyCgzRk7/Q=; b=j4xMVX6ZqZNzIKK7H67VWZejnQ
	Kgu78x5aQjjrblW6go6clzkBgsCDWr97rkpZlveFVGe/BDl4XA8cQfZjkJkhRSB+VKhxW4YHvFaTj
	JUjNIDgbI+mfFbj6rLWt6yZef2J9Waj9nNQr/kP0usxMgvPWhTzFitvmCs6XBhrmJExYVJt7BujRY
	z7x/LW1+PP0TpGBKiS6kxRgsLeUyWTcTq/mnV3W3YVhSX05yFPyNREe6hkKqVcUAsZkStxTjqC399
	hY4PIvozZep5fClhJPCsdOsCMmyDwNMVpqYHUIeopPmVoKLAymEx3HQRIY/gwcvE10CS32FEzNY0V
	Eggmh0TQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vR746-00000007t0z-3wxL;
	Thu, 04 Dec 2025 11:00:02 +0000
Date: Thu, 4 Dec 2025 03:00:02 -0800
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
Subject: Re: [RFC v2 06/11] nvme-pci: add support for dmabuf reggistration
Message-ID: <aTFpsl3o7IoJ_xPg@infradead.org>
References: <cover.1763725387.git.asml.silence@gmail.com>
 <9bc25f46d2116436d73140cd8e8554576de2caca.1763725388.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9bc25f46d2116436d73140cd8e8554576de2caca.1763725388.git.asml.silence@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Splitting this trivial stub from the substantial parts in the next patch
feels odd.  Please merge them.

(and better commit logs and comments really would be useful for others
to understand what you've done).

> +const struct dma_buf_attach_ops nvme_dmabuf_importer_ops = {
> +	.move_notify = nvme_dmabuf_move_notify,
> +	.allow_peer2peer = true,
> +};

Tab-align the =, please.

> +static int nvme_init_dma_token(struct request_queue *q,
> +				struct blk_mq_dma_token *token)
> +{
> +	struct dma_buf_attachment *attach;
> +	struct nvme_ns *ns = q->queuedata;
> +	struct nvme_dev *dev = to_nvme_dev(ns->ctrl);
> +	struct dma_buf *dmabuf = token->dmabuf;
> +
> +	if (dmabuf->size % NVME_CTRL_PAGE_SIZE)
> +		return -EINVAL;

Why do you care about alignment to the controller page size?

> +	for_each_sgtable_dma_sg(sgt, sg, tmp) {
> +		dma_addr_t dma = sg_dma_address(sg);
> +		unsigned long sg_len = sg_dma_len(sg);
> +
> +		while (sg_len) {
> +			dma_list[i++] = dma;
> +			dma += NVME_CTRL_PAGE_SIZE;
> +			sg_len -= NVME_CTRL_PAGE_SIZE;
> +		}
> +	}

Why does this build controller pages sized chunks?


