Return-Path: <io-uring+bounces-13304-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IHkfC4k4BGoqFgIAu9opvQ
	(envelope-from <io-uring+bounces-13304-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 13 May 2026 10:38:33 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id B4A7B52FC2B
	for <lists+io-uring@lfdr.de>; Wed, 13 May 2026 10:38:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id D97B630054CF
	for <lists+io-uring@lfdr.de>; Wed, 13 May 2026 08:38:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 125BD3DD858;
	Wed, 13 May 2026 08:38:28 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7956A38D3F3;
	Wed, 13 May 2026 08:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778661508; cv=none; b=j3CvAUatsqjFd1Pqrw9rFv7j6j2Ku+jypou+HerlrTsKkuhZSqd4ySK+Syjh54eq89LBEIi4hJuCcyBFC6rLm8ZmMt60C9ut96Y2SRVBtcVO6bv0tjJiQyy5SPBo5fp96EV92oyQ87OqNM8EbsPS3Q6s2f3XwLGPgTbznnaJvB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778661508; c=relaxed/simple;
	bh=Ls2YffBy5iXoZZDKZ10w4tTcOcMvKTziJQ6Yd+1NEpk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BuWbLjgM/O+P7/E2Unxvc7kk2A1p6WWnMwf/eRfS+4UxqyMvCYyYGxLvPQWUJvjCIQG1bVWlbujLxI5IhYJI9CVJmdPLIWEHmHm1f1MEdJfADHNk/Gxwa7/iu8B/fKd0aUVo1zWX8VFjZLAHUdT1XMTEG/NgX2QvvIhjObu5HxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 817E368CFE; Wed, 13 May 2026 10:38:17 +0200 (CEST)
Date: Wed, 13 May 2026 10:38:17 +0200
From: Christoph Hellwig <hch@lst.de>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
	Nitesh Shetty <nj.shetty@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Anuj Gupta <anuj20.g@samsung.com>,
	Tushar Gohad <tushar.gohad@intel.com>,
	William Power <william.power@intel.com>,
	Phil Cayton <phil.cayton@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH v3 07/10] nvme-pci: implement dma_token backed requests
Message-ID: <20260513083817.GC6461@lst.de>
References: <cover.1777475843.git.asml.silence@gmail.com> <5cecb1157ab784f9f303a91449fdf11b03aa6002.1777475843.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5cecb1157ab784f9f303a91449fdf11b03aa6002.1777475843.git.asml.silence@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Queue-Id: B4A7B52FC2B
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.14 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	DMARC_POLICY_SOFTFAIL(0.10)[lst.de : SPF not aligned (relaxed), No valid DKIM,none];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FREEMAIL_TO(0.00)[gmail.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13304-lists,io-uring=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[25];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[hch@lst.de,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	MID_RHS_MATCH_FROM(0.00)[];
	R_DKIM_NA(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,lst.de:mid]
X-Rspamd-Action: no action

FYI, I really want SGL support before this get merged, but ignoring that
for now:

> +struct nvme_dmabuf_map {
> +	struct io_dmabuf_map base;
> +	dma_addr_t *dma_list;
> +	struct sg_table *sgt;
> +	unsigned nr_entries;

I'd make dma_list a variable-sized array at the end of the struture to avoid
an extra allocation and pointer derefernece.

>  
> +static void nvme_dmabuf_map_sync(struct nvme_dev *nvme_dev, struct request *req,
> +				 bool for_cpu)
> +{
> +	int length = blk_rq_payload_bytes(req);
> +	struct device *dev = nvme_dev->dev;
> +	enum dma_data_direction dma_dir;
> +	struct bio *bio = req->bio;
> +	struct nvme_dmabuf_map *map;
> +	dma_addr_t *dma_list;
> +	int offset, map_idx;
> +
> +	dma_dir = rq_data_dir(req) == READ ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
> +	map = container_of(bio->dmabuf_map, struct nvme_dmabuf_map, base);
> +	dma_list = map->dma_list;
> +
> +	offset = bio->bi_iter.bi_bvec_done;
> +	map_idx = offset / NVME_CTRL_PAGE_SIZE;
> +	length += offset & (NVME_CTRL_PAGE_SIZE - 1);

Please initialize the variable at declaration time and use or add proper
helpers to simplify this:

static inline struct nvme_dmabuf_map *
to_nvme_dmabuf_map(struct io_dmabuf_map *map)
{
	return container_of(map, struct nvme_dmabuf_map, base);
}

....

	enum dma_data_direction dma_dir = rq_dma_dir(req);
	struct device *dev = nvme_dev->dev;
	struct bio *bio = req->bio;
	struct nvme_dmabuf_map *map = to_nvme_dmabuf_map(bio->bi_dmabuf_map);
	dma_addr_t *dma_list = map->dma_list;
	int offset = bio->bi_iter.bi_bvec_done;
	int mmap_idx = offset / NVME_CTRL_PAGE_SIZE;
	int length = blk_rq_payload_bytes(req) +
		offset & (NVME_CTRL_PAGE_SIZE - 1);

Also a lot of these ints sound like they should be unsigned.

> +
> +	while (length > 0) {
> +		u64 dma_addr = dma_list[map_idx++];
> +
> +		if (for_cpu)
> +			__dma_sync_single_for_cpu(dev, dma_addr,
> +						  NVME_CTRL_PAGE_SIZE, dma_dir);
> +		else
> +			__dma_sync_single_for_device(dev, dma_addr,
> +						     NVME_CTRL_PAGE_SIZE,
> +						     dma_dir);
> +		length -= NVME_CTRL_PAGE_SIZE;
> +	}
> +}

Nothing should be using these __dma_sync helpers that are internal
details. Using them means you call into sync code that should be skipped
on most common server class systems.

Also the for_cpu argument is a bit ugly.  I'd rather have separate
routines as in the core dma-mapping code, even if that means a little bit
of code duplication.

> +static blk_status_t nvme_rq_setup_dmabuf_map(struct request *req,
> +					     struct nvme_queue *nvmeq)
> +{
> +	struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
> +	int length = blk_rq_payload_bytes(req);
> +	u64 dma_addr, prp1_dma, prp2_dma;
> +	struct bio *bio = req->bio;
> +	struct nvme_dmabuf_map *map;
> +	dma_addr_t *dma_list;
> +	dma_addr_t prp_dma;
> +	__le64 *prp_list;
> +	int i, map_idx;
> +	int offset;
> +
> +	nvme_dmabuf_map_sync(nvmeq->dev, req, false);
> +
> +	map = container_of(bio->dmabuf_map, struct nvme_dmabuf_map, base);
> +	dma_list = map->dma_list;
> +
> +	offset = bio->bi_iter.bi_bvec_done;
> +	map_idx = offset / NVME_CTRL_PAGE_SIZE;
> +	offset &= (NVME_CTRL_PAGE_SIZE - 1);
> +	prp1_dma = dma_list[map_idx++] + offset;

Same comments as for the sync helper above.

> +	length -= (NVME_CTRL_PAGE_SIZE - offset);
> +	if (length <= 0) {
> +		prp2_dma = 0;
> +		goto done;
> +	}
> +
> +	if (length <= NVME_CTRL_PAGE_SIZE) {
> +		prp2_dma = dma_list[map_idx];
> +		goto done;
> +	}
> +
> +	if (DIV_ROUND_UP(length, NVME_CTRL_PAGE_SIZE) <=
> +	    NVME_SMALL_POOL_SIZE / sizeof(__le64))
> +		iod->flags |= IOD_SMALL_DESCRIPTOR;
> +
> +	prp_list = dma_pool_alloc(nvme_dma_pool(nvmeq, iod), GFP_ATOMIC,
> +			&prp_dma);
> +	if (!prp_list)
> +		return BLK_STS_RESOURCE;
> +
> +	iod->descriptors[iod->nr_descriptors++] = prp_list;
> +	prp2_dma = prp_dma;

And I really hate how this duplicates all the nasty PRP building logic,
although right now I don't have a good answer to that.

> +static inline bool nvme_rq_is_dmabuf_attached(struct request *req)
> +{
> +	if (!IS_ENABLED(CONFIG_DMABUF_TOKEN))
> +		return false;
> +	return req->bio && bio_flagged(req->bio, BIO_DMABUF_MAP);
> +}

This is something that should go into the block layer.


