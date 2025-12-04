Return-Path: <io-uring+bounces-10952-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 039E4CA3593
	for <lists+io-uring@lfdr.de>; Thu, 04 Dec 2025 11:59:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9C7D130D78C6
	for <lists+io-uring@lfdr.de>; Thu,  4 Dec 2025 10:57:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E823E337689;
	Thu,  4 Dec 2025 10:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="B0ieOXMA"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D458334374;
	Thu,  4 Dec 2025 10:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764845822; cv=none; b=pERGA2nwGXJTrKGFUPztC1gVm0+ZFQEysREwZDLzXzRle4evrIiuzEtyVpiuI5Yevi+bEUz1sIWgzuEqZGWCJHOa4xd3QWwZPE4gRj3uQ9tR2u3SIwbaXVEsXZMblEaQGMYpqOcjyVFKLujpoA4W8csLjHj5QxJcKxoEICDl6PA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764845822; c=relaxed/simple;
	bh=fEvqyFs9ykiug5QbSOX8vZfdyFoDr5q2q07OLF+ruLk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RtFeA/EpjswRTpUyZcqUX4dMZnLZnekqnhbdvjWStpKSNlr0l4yJplNDrik1gVJh+T/H0ZXCz/v30DpPYCysPzmKHbYM/FP5o+y3wizOuaeQhMEH0BRBdoVVrPYW9wV/uwyUyd3nRCOVpu2grgNYPeMyoVt2HHvQhQHrMXLa8X0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=B0ieOXMA; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=htG5helYPRZeOE+g4oA9RANRm8weBs+7p0pVyLxQe2g=; b=B0ieOXMAYXJdlPHXV7V4nMYUq4
	VLEycv7k2YMzsXO9f4pJFjGny4vY4NfP8epkdhF8F38h/+6fuV6iE0gXTkh21rb/Euo7s9NNXKYYk
	jUGj2Oa358FRSerVYREYFAFFTZJxVpE+JFBwPWaISBzTDks2d3hZLzyz2S7CYoHr1Z9X0Ae9y6VRN
	2scK3Uza7PxJiVMSjoImUuRP422HIsinlaDCL/FBlW0s0ZJaNo9nCNO17ZDdgYNg3HKZ7Oz3GxSrX
	VazDtqvvKZK/WNu+J1TtwVImyE1a4yvSxyPKo+giez0CfJoEdNAzNyUrMjEIwBU8TPP/zWGBbDg5W
	PrTftRUQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vR71A-00000007sn7-00ap;
	Thu, 04 Dec 2025 10:57:00 +0000
Date: Thu, 4 Dec 2025 02:56:59 -0800
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
Subject: Re: [RFC v2 05/11] block: add infra to handle dmabuf tokens
Message-ID: <aTFo-7ufbyZnEUzd@infradead.org>
References: <cover.1763725387.git.asml.silence@gmail.com>
 <51cddd97b31d80ec8842a88b9f3c9881419e8a7b.1763725387.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51cddd97b31d80ec8842a88b9f3c9881419e8a7b.1763725387.git.asml.silence@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sun, Nov 23, 2025 at 10:51:25PM +0000, Pavel Begunkov wrote:
> Add blk-mq infrastructure to handle dmabuf tokens. There are two main

Please spell out infrastructure in the subject as well.

> +struct dma_token *blkdev_dma_map(struct file *file,
> +				 struct dma_token_params *params)
> +{
> +	struct request_queue *q = bdev_get_queue(file_bdev(file));
> +
> +	if (!(file->f_flags & O_DIRECT))
> +		return ERR_PTR(-EINVAL);

Shouldn't the O_DIRECT check be in the caller?

> +++ b/block/blk-mq-dma-token.c

Missing SPDX and Copyright statement.

> @@ -0,0 +1,236 @@
> +#include <linux/blk-mq-dma-token.h>
> +#include <linux/dma-resv.h>
> +
> +struct blk_mq_dma_fence {
> +	struct dma_fence base;
> +	spinlock_t lock;
> +};

And a high-level comment explaining the fencing logic would be nice
as well.

> +	struct blk_mq_dma_map *map = container_of(ref, struct blk_mq_dma_map, refs);

Overly long line.

> +static struct blk_mq_dma_map *blk_mq_alloc_dma_mapping(struct blk_mq_dma_token *token)

Another one.  Also kinda inconsistent between _map in the data structure
and _mapping in the function name.

> +static inline
> +struct blk_mq_dma_map *blk_mq_get_token_map(struct blk_mq_dma_token *token)

Really odd return value / scope formatting.

> +{
> +	struct blk_mq_dma_map *map;
> +
> +	guard(rcu)();
> +
> +	map = rcu_dereference(token->map);
> +	if (unlikely(!map || !percpu_ref_tryget_live_rcu(&map->refs)))
> +		return NULL;
> +	return map;

Please use good old rcu_read_unlock to make this readable.

> +	guard(mutex)(&token->mapping_lock);

Same.

> +
> +	map = blk_mq_get_token_map(token);
> +	if (map)
> +		return map;
> +
> +	map = blk_mq_alloc_dma_mapping(token);
> +	if (IS_ERR(map))
> +		return NULL;
> +
> +	dma_resv_lock(dmabuf->resv, NULL);
> +	ret = dma_resv_wait_timeout(dmabuf->resv, DMA_RESV_USAGE_BOOKKEEP,
> +				    true, MAX_SCHEDULE_TIMEOUT);
> +	ret = ret ? ret : -ETIME;

	if (!ret)
		ret = -ETIME;

> +blk_status_t blk_rq_assign_dma_map(struct request *rq,
> +				   struct blk_mq_dma_token *token)
> +{
> +	struct blk_mq_dma_map *map;
> +
> +	map = blk_mq_get_token_map(token);
> +	if (map)
> +		goto complete;
> +
> +	if (rq->cmd_flags & REQ_NOWAIT)
> +		return BLK_STS_AGAIN;
> +
> +	map = blk_mq_create_dma_map(token);
> +	if (IS_ERR(map))
> +		return BLK_STS_RESOURCE;

Having a few comments, that say this is creating the map lazily
would probably helper the reader.  Also why not keep the !map
case in the branch, as the map case should be the fast path and
thus usually be straight line in the function?

> +void blk_mq_dma_map_move_notify(struct blk_mq_dma_token *token)
> +{
> +	blk_mq_dma_map_remove(token);
> +}

Is there a good reason for having this blk_mq_dma_map_move_notify
wrapper?

> +	if (bio_flagged(bio, BIO_DMA_TOKEN)) {
> +		struct blk_mq_dma_token *token;
> +		blk_status_t ret;
> +
> +		token = dma_token_to_blk_mq(bio->dma_token);
> +		ret = blk_rq_assign_dma_map(rq, token);
> +		if (ret) {
> +			if (ret == BLK_STS_AGAIN) {
> +				bio_wouldblock_error(bio);
> +			} else {
> +				bio->bi_status = BLK_STS_RESOURCE;
> +				bio_endio(bio);
> +			}
> +			goto queue_exit;
> +		}
> +	}

Any reason to not just keep the dma_token_to_blk_mq?  Also why is this
overriding non-BLK_STS_AGAIN errors with BLK_STS_RESOURCE?

(I really wish we could make all BLK_STS_AGAIN errors be quiet without
the explicit setting of BIO_QUIET, which is a bit annoying, but that's
not for this patch).

> +static inline
> +struct blk_mq_dma_token *dma_token_to_blk_mq(struct dma_token *token)

More odd formatting.


