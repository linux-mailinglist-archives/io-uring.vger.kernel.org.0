Return-Path: <io-uring+bounces-13184-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +GJVE3Eu8mlvogEAu9opvQ
	(envelope-from <io-uring+bounces-13184-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 29 Apr 2026 18:14:41 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id DD5BC49790E
	for <lists+io-uring@lfdr.de>; Wed, 29 Apr 2026 18:14:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 54D0F312EE40
	for <lists+io-uring@lfdr.de>; Wed, 29 Apr 2026 16:08:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91B3B3FB7FB;
	Wed, 29 Apr 2026 16:08:12 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from arkamax.eu (128-116-240-228.dyn.eolo.it [128.116.240.228])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 907B33A5E69;
	Wed, 29 Apr 2026 16:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=128.116.240.228
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777478891; cv=none; b=A3jXbt+xqBO7cPKOH06PmPq1lS6WmOeMBzYTYW6ZiLpfsk8aAqvaC3HcNimldOn+pq5vfa8a+h9oVwuYBaaBk9/KElJc5XHfBQaAKB+Qz0h3kE/DypWoWfVXy1C12HcByQwVTAB859i0j8pmmpO9LcXNhUR1tO5F+lhGj85C164=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777478891; c=relaxed/simple;
	bh=2OxDRuVuRYUIezquhVk6qf5m05LQJvebSzdYBe3fKkI=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:To:Cc:Subject:
	 References:In-Reply-To; b=nZkjf4RIvlCOQ6GtwMWgu6VLkq2nSZatDaRU9bSrY3pc3I2ywjsINE6o27KThHJd9oiT5+3rfhrHigNhDLmC1KNuijyo3BgLEtWoQj+W0yLIbiBcUsLASVX/TvyKJtR/9U4tsh+YhFfiWJI60f3LA1vows69ZPZoqEKn8qGXNVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=arkamax.eu; spf=pass smtp.mailfrom=arkamax.eu; arc=none smtp.client-ip=128.116.240.228
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=arkamax.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arkamax.eu
Received: from localhost (128-116-240-228.dyn.eolo.it [128.116.240.228])
	by arkamax.eu (OpenSMTPD) with ESMTPSA id 8ebc5e10 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Wed, 29 Apr 2026 18:07:48 +0200 (CEST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 29 Apr 2026 18:07:47 +0200
Message-Id: <DI5RO76D5IWR.19K0ES58HUIVS@arkamax.eu>
From: "Maurizio Lombardi" <mlombard@arkamax.eu>
To: "Pavel Begunkov" <asml.silence@gmail.com>, "Jens Axboe"
 <axboe@kernel.dk>, "Keith Busch" <kbusch@kernel.org>, "Christoph Hellwig"
 <hch@lst.de>, "Sagi Grimberg" <sagi@grimberg.me>, "Alexander Viro"
 <viro@zeniv.linux.org.uk>, "Christian Brauner" <brauner@kernel.org>,
 "Andrew Morton" <akpm@linux-foundation.org>, "Sumit Semwal"
 <sumit.semwal@linaro.org>, =?utf-8?q?Christian_K=C3=B6nig?=
 <christian.koenig@amd.com>, <linux-block@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
 <linux-fsdevel@vger.kernel.org>, <io-uring@vger.kernel.org>,
 <linux-media@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
 <linaro-mm-sig@lists.linaro.org>
Cc: "Nitesh Shetty" <nj.shetty@samsung.com>, "Kanchan Joshi"
 <joshi.k@samsung.com>, "Anuj Gupta" <anuj20.g@samsung.com>, "Tushar Gohad"
 <tushar.gohad@intel.com>, "William Power" <william.power@intel.com>, "Phil
 Cayton" <phil.cayton@intel.com>, "Jason Gunthorpe" <jgg@nvidia.com>
Subject: Re: [PATCH v3 07/10] nvme-pci: implement dma_token backed requests
X-Mailer: aerc 0.21.0
References: <cover.1777475843.git.asml.silence@gmail.com>
 <5cecb1157ab784f9f303a91449fdf11b03aa6002.1777475843.git.asml.silence@gmail.com>
In-Reply-To: <5cecb1157ab784f9f303a91449fdf11b03aa6002.1777475843.git.asml.silence@gmail.com>
X-Rspamd-Queue-Id: DD5BC49790E
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.54 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FREEMAIL_TO(0.00)[gmail.com,kernel.dk,kernel.org,lst.de,grimberg.me,zeniv.linux.org.uk,linux-foundation.org,linaro.org,amd.com,vger.kernel.org,lists.infradead.org,lists.freedesktop.org,lists.linaro.org];
	TAGGED_FROM(0.00)[bounces-13184-lists,io-uring=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[25];
	DMARC_NA(0.00)[arkamax.eu];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_SPAM(0.00)[0.848];
	R_DKIM_NA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mlombard@arkamax.eu,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,arkamax.eu:mid]

On Wed Apr 29, 2026 at 5:25 PM CEST, Pavel Begunkov wrote:
> Enable BIO_DMABUF_MAP backed requests. It creates a prp list for the
> dmabuf when it's mapped, which is then used to initialise requests.
>
> Suggested-by: Keith Busch <kbusch@kernel.org>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  drivers/nvme/host/pci.c | 282 ++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 282 insertions(+)
>
> diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
> index db5fc9bf6627..d2629853a972 100644
> --- a/drivers/nvme/host/pci.c
> +++ b/drivers/nvme/host/pci.c
> @@ -27,6 +27,8 @@
>  #include <linux/io-64-nonatomic-lo-hi.h>
>  #include <linux/io-64-nonatomic-hi-lo.h>
>  #include <linux/sed-opal.h>
> +#include <linux/io_dmabuf_token.h>
> +#include <linux/dma-resv.h>
> =20
>  #include "trace.h"
>  #include "nvme.h"
> @@ -393,6 +395,17 @@ struct nvme_queue {
>  	struct completion delete_done;
>  };
> =20
> +struct nvme_dmabuf_token {
> +	struct dma_buf_attachment *attach;
> +};
> +
> +struct nvme_dmabuf_map {
> +	struct io_dmabuf_map base;
> +	dma_addr_t *dma_list;
> +	struct sg_table *sgt;
> +	unsigned nr_entries;
> +};
> +
>  /* bits for iod->flags */
>  enum nvme_iod_flags {
>  	/* this command has been aborted by the timeout handler */
> @@ -854,6 +867,134 @@ static void nvme_free_descriptors(struct request *r=
eq)
>  	}
>  }
> =20
> +static void nvme_dmabuf_map_sync(struct nvme_dev *nvme_dev, struct reque=
st *req,
> +				 bool for_cpu)
> +{
> +	int length =3D blk_rq_payload_bytes(req);
> +	struct device *dev =3D nvme_dev->dev;
> +	enum dma_data_direction dma_dir;
> +	struct bio *bio =3D req->bio;
> +	struct nvme_dmabuf_map *map;
> +	dma_addr_t *dma_list;
> +	int offset, map_idx;
> +
> +	dma_dir =3D rq_data_dir(req) =3D=3D READ ? DMA_FROM_DEVICE : DMA_TO_DEV=
ICE;
> +	map =3D container_of(bio->dmabuf_map, struct nvme_dmabuf_map, base);
> +	dma_list =3D map->dma_list;
> +
> +	offset =3D bio->bi_iter.bi_bvec_done;
> +	map_idx =3D offset / NVME_CTRL_PAGE_SIZE;
> +	length +=3D offset & (NVME_CTRL_PAGE_SIZE - 1);
> +
> +	while (length > 0) {
> +		u64 dma_addr =3D dma_list[map_idx++];
> +
> +		if (for_cpu)
> +			__dma_sync_single_for_cpu(dev, dma_addr,
> +						  NVME_CTRL_PAGE_SIZE, dma_dir);
> +		else
> +			__dma_sync_single_for_device(dev, dma_addr,
> +						     NVME_CTRL_PAGE_SIZE,
> +						     dma_dir);
> +		length -=3D NVME_CTRL_PAGE_SIZE;
> +	}
> +}
> +
> +static void nvme_rq_clean_dmabuf_map(struct nvme_dev *dev,
> +				      struct request *req)
> +{
> +	struct nvme_iod *iod =3D blk_mq_rq_to_pdu(req);
> +
> +	nvme_dmabuf_map_sync(dev, req, true);
> +
> +	if (!(iod->flags & IOD_SINGLE_SEGMENT))
> +		nvme_free_descriptors(req);
> +}
> +
> +static blk_status_t nvme_rq_setup_dmabuf_map(struct request *req,
> +					     struct nvme_queue *nvmeq)
> +{
> +	struct nvme_iod *iod =3D blk_mq_rq_to_pdu(req);
> +	int length =3D blk_rq_payload_bytes(req);
> +	u64 dma_addr, prp1_dma, prp2_dma;
> +	struct bio *bio =3D req->bio;
> +	struct nvme_dmabuf_map *map;
> +	dma_addr_t *dma_list;
> +	dma_addr_t prp_dma;
> +	__le64 *prp_list;
> +	int i, map_idx;
> +	int offset;
> +
> +	nvme_dmabuf_map_sync(nvmeq->dev, req, false);
> +
> +	map =3D container_of(bio->dmabuf_map, struct nvme_dmabuf_map, base);
> +	dma_list =3D map->dma_list;
> +
> +	offset =3D bio->bi_iter.bi_bvec_done;
> +	map_idx =3D offset / NVME_CTRL_PAGE_SIZE;
> +	offset &=3D (NVME_CTRL_PAGE_SIZE - 1);
> +	prp1_dma =3D dma_list[map_idx++] + offset;
> +
> +	length -=3D (NVME_CTRL_PAGE_SIZE - offset);
> +	if (length <=3D 0) {
> +		prp2_dma =3D 0;
> +		goto done;
> +	}
> +
> +	if (length <=3D NVME_CTRL_PAGE_SIZE) {
> +		prp2_dma =3D dma_list[map_idx];
> +		goto done;
> +	}
> +
> +	if (DIV_ROUND_UP(length, NVME_CTRL_PAGE_SIZE) <=3D
> +	    NVME_SMALL_POOL_SIZE / sizeof(__le64))
> +		iod->flags |=3D IOD_SMALL_DESCRIPTOR;
> +
> +	prp_list =3D dma_pool_alloc(nvme_dma_pool(nvmeq, iod), GFP_ATOMIC,
> +			&prp_dma);
> +	if (!prp_list)
> +		return BLK_STS_RESOURCE;
> +
> +	iod->descriptors[iod->nr_descriptors++] =3D prp_list;
> +	prp2_dma =3D prp_dma;
> +	i =3D 0;
> +	for (;;) {
> +		if (i =3D=3D NVME_CTRL_PAGE_SIZE >> 3) {
> +			__le64 *old_prp_list =3D prp_list;
> +
> +			prp_list =3D dma_pool_alloc(nvmeq->descriptor_pools.large,
> +					GFP_ATOMIC, &prp_dma);
> +			if (!prp_list)
> +				goto free_prps;
> +			iod->descriptors[iod->nr_descriptors++] =3D prp_list;
> +			prp_list[0] =3D old_prp_list[i - 1];
> +			old_prp_list[i - 1] =3D cpu_to_le64(prp_dma);
> +			i =3D 1;
> +		}
> +
> +		dma_addr =3D dma_list[map_idx++];
> +		prp_list[i++] =3D cpu_to_le64(dma_addr);
> +
> +		length -=3D NVME_CTRL_PAGE_SIZE;
> +		if (length <=3D 0)
> +			break;
> +	}
> +done:
> +	iod->cmd.common.dptr.prp1 =3D cpu_to_le64(prp1_dma);
> +	iod->cmd.common.dptr.prp2 =3D cpu_to_le64(prp2_dma);
> +	return BLK_STS_OK;
> +free_prps:
> +	nvme_free_descriptors(req);
> +	return BLK_STS_RESOURCE;
> +}
> +
> +static inline bool nvme_rq_is_dmabuf_attached(struct request *req)
> +{
> +	if (!IS_ENABLED(CONFIG_DMABUF_TOKEN))
> +		return false;
> +	return req->bio && bio_flagged(req->bio, BIO_DMABUF_MAP);
> +}
> +
>  static void nvme_free_prps(struct request *req, unsigned int attrs)
>  {
>  	struct nvme_iod *iod =3D blk_mq_rq_to_pdu(req);
> @@ -932,6 +1073,11 @@ static void nvme_unmap_data(struct request *req)
>  	struct device *dma_dev =3D nvmeq->dev->dev;
>  	unsigned int attrs =3D 0;
> =20
> +	if (nvme_rq_is_dmabuf_attached(req)) {
> +		nvme_rq_clean_dmabuf_map(nvmeq->dev, req);
> +		return;
> +	}
> +
>  	if (iod->flags & IOD_SINGLE_SEGMENT) {
>  		static_assert(offsetof(union nvme_data_ptr, prp1) =3D=3D
>  				offsetof(union nvme_data_ptr, sgl.addr));
> @@ -1222,6 +1368,9 @@ static blk_status_t nvme_map_data(struct request *r=
eq)
>  	struct blk_dma_iter iter;
>  	blk_status_t ret;
> =20
> +	if (nvme_rq_is_dmabuf_attached(req))
> +		return nvme_rq_setup_dmabuf_map(req, nvmeq);
> +
>  	/*
>  	 * Try to skip the DMA iterator for single segment requests, as that
>  	 * significantly improves performances for small I/O sizes.
> @@ -2238,6 +2387,134 @@ static int nvme_create_queue(struct nvme_queue *n=
vmeq, int qid, bool polled)
>  	return result;
>  }
> =20
> +#ifdef CONFIG_DMABUF_TOKEN
> +static void nvme_dmabuf_invalidate_mappings(struct dma_buf_attachment *a=
ttach)
> +{
> +	struct io_dmabuf_token *token =3D attach->importer_priv;
> +
> +	io_dmabuf_token_invalidate_mappings(token);
> +}
> +
> +const struct dma_buf_attach_ops nvme_dmabuf_importer_ops =3D {
> +	.invalidate_mappings	=3D nvme_dmabuf_invalidate_mappings,
> +	.allow_peer2peer	=3D true,
> +};
> +
> +static struct io_dmabuf_map *nvme_dmabuf_token_map(struct io_dmabuf_toke=
n *token)
> +{
> +	struct nvme_dmabuf_token *data =3D token->dev_priv;
> +	struct dma_buf_attachment *attach =3D data->attach;
> +	dma_addr_t *dma_list =3D NULL;
> +	unsigned long tmp, i =3D 0;
> +	struct nvme_dmabuf_map *map;
> +	struct scatterlist *sg;
> +	struct sg_table *sgt;
> +	unsigned nr_entries;
> +	int ret;
> +
> +	dma_resv_assert_held(token->dmabuf->resv);
> +
> +	map =3D kmalloc(sizeof(*map), GFP_KERNEL);
> +	if (!map)
> +		return ERR_PTR(-ENOMEM);
> +
> +	nr_entries =3D token->dmabuf->size / NVME_CTRL_PAGE_SIZE;
> +	dma_list =3D kmalloc_array(nr_entries, sizeof(dma_list[0]), GFP_KERNEL)=
;
> +	if (!dma_list) {
> +		ret =3D -ENOMEM;
> +		goto err;
> +	}
> +
> +	sgt =3D dma_buf_map_attachment(attach, token->dir);
> +	if (IS_ERR(sgt)) {
> +		ret =3D PTR_ERR(sgt);
> +		sgt =3D NULL;
> +		goto err;
> +	}
> +
> +	for_each_sgtable_dma_sg(sgt, sg, tmp) {
> +		dma_addr_t dma_addr =3D sg_dma_address(sg);
> +		unsigned long sg_len =3D sg_dma_len(sg);
> +
> +		if (sg_len % NVME_CTRL_PAGE_SIZE) {
> +			ret =3D -EINVAL;
> +			goto err;
> +		}
> +
> +		while (sg_len) {
> +			dma_list[i++] =3D dma_addr;
> +			dma_addr +=3D NVME_CTRL_PAGE_SIZE;
> +			sg_len -=3D NVME_CTRL_PAGE_SIZE;
> +		}
> +	}
> +
> +	ret =3D io_dmabuf_init_map(token, &map->base);
> +	if (ret)
> +		goto err;
> +	map->nr_entries =3D nr_entries;
> +	map->dma_list =3D dma_list;
> +	map->sgt =3D sgt;
> +	return &map->base;
> +err:
> +	if (sgt)
> +		dma_buf_unmap_attachment(attach, sgt, token->dir);
> +	kfree(map);
> +	kfree(dma_list);
> +	return ERR_PTR(ret);
> +}
> +
> +static void nvme_dmabuf_token_unmap(struct io_dmabuf_token *token,
> +				 struct io_dmabuf_map *map_base)
> +{
> +	struct nvme_dmabuf_token *data =3D token->dev_priv;
> +	struct nvme_dmabuf_map *map =3D container_of(map_base,
> +						struct nvme_dmabuf_map, base);
> +
> +	dma_resv_assert_held(token->dmabuf->resv);
> +
> +	dma_buf_unmap_attachment(data->attach, map->sgt, token->dir);
> +	kfree(map->dma_list);
> +}
> +
> +static void nvme_dmabuf_token_release(struct io_dmabuf_token *token)
> +{
> +	struct nvme_dmabuf_token *data =3D token->dev_priv;
> +
> +	dma_buf_detach(token->dmabuf, data->attach);
> +	kfree(data);
> +}
> +
> +const struct io_dmabuf_token_dev_ops nvme_dma_token_ops =3D {
> +	.map		=3D nvme_dmabuf_token_map,
> +	.unmap		=3D nvme_dmabuf_token_unmap,
> +	.release	=3D nvme_dmabuf_token_release,
> +};
> +
> +static int nvme_create_dmabuf_token(struct request_queue *q,
> +				 struct io_dmabuf_token *token)
> +{
> +	struct nvme_dmabuf_token *data;
> +	struct dma_buf_attachment *attach;
> +	struct nvme_ns *ns =3D q->queuedata;
> +	struct nvme_dev *dev =3D to_nvme_dev(ns->ctrl);
> +	struct dma_buf *dmabuf =3D token->dmabuf;
> +
> +	data =3D kzalloc(sizeof(data), GFP_KERNEL);
> +	if (!data)
> +		return -ENOMEM;

Shouldn't this be kzalloc(sizeof(*data)...) ?

Also, checkpatch generates a warning because kzalloc_obj() should be
preferred for this kind of memory allocations over kzalloc().

> +
> +	token->dev_priv =3D data;
> +	token->dev_ops =3D &nvme_dma_token_ops;
> +
> +	attach =3D dma_buf_dynamic_attach(dmabuf, dev->dev,
> +					&nvme_dmabuf_importer_ops, token);
> +	if (IS_ERR(attach))
> +		return PTR_ERR(attach);

Supposing dma_buf_dynamic_attach() returns an error, won't the 'data'
pointer be leaked?

Maurizio

