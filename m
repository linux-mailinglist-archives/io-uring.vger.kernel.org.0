Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81F6F5882AF
	for <lists+io-uring@lfdr.de>; Tue,  2 Aug 2022 21:37:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234303AbiHBThh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 2 Aug 2022 15:37:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233477AbiHBThE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 2 Aug 2022 15:37:04 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BEDE52DDB
        for <io-uring@vger.kernel.org>; Tue,  2 Aug 2022 12:37:02 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 272I2T9F021416
        for <io-uring@vger.kernel.org>; Tue, 2 Aug 2022 12:37:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=/tSE1EYj8ZALKJUlPJ9Sl1+4DKODfpI5WLuyZxKEnJs=;
 b=DS4LuGlSrgwYWriHxeGvQ1bKF7EfV2PfpZ2/xnnGwUr1bMDYiVGPZNI1HNPSvDjdz6vF
 V16OCfUWScoZeQbgF4FcEmf7LLCJ2QXKNvjf+3TSaeJezaJlIVVhvpr1O7I1aV1wyVKl
 YwyHpjIwZb8VL/OTz7ELO/7LaMWpVHhWfb8= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hq477k7b6-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 02 Aug 2022 12:37:01 -0700
Received: from snc-exhub201.TheFacebook.com (2620:10d:c085:21d::7) by
 snc-exhub204.TheFacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Tue, 2 Aug 2022 12:37:00 -0700
Received: from twshared7556.02.ash8.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Tue, 2 Aug 2022 12:36:59 -0700
Received: by devbig007.nao1.facebook.com (Postfix, from userid 544533)
        id 18D406E59F08; Tue,  2 Aug 2022 12:36:38 -0700 (PDT)
From:   Keith Busch <kbusch@fb.com>
To:     <linux-nvme@lists.infradead.org>, <linux-block@vger.kernel.org>,
        <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>
CC:     <axboe@kernel.dk>, <hch@lst.de>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Kernel Team <Kernel-team@fb.com>,
        Keith Busch <kbusch@kernel.org>
Subject: [PATCHv2 7/7] nvme-pci: implement dma_map support
Date:   Tue, 2 Aug 2022 12:36:33 -0700
Message-ID: <20220802193633.289796-8-kbusch@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220802193633.289796-1-kbusch@fb.com>
References: <20220802193633.289796-1-kbusch@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: ogrfNi1OpY1keOq2KlBYK4udYCRYaWzU
X-Proofpoint-ORIG-GUID: ogrfNi1OpY1keOq2KlBYK4udYCRYaWzU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-02_14,2022-08-02_01,2022-06-22_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Keith Busch <kbusch@kernel.org>

Implement callbacks to convert a registered bio_vec to a prp list, and
use this for each IO that uses the returned tag. This saves repeated IO
conversions and dma mapping/unmapping. In many cases, the driver can
skip per-IO pool allocations entirely, saving potentially signficant CPU
cycles.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 drivers/nvme/host/pci.c | 302 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 292 insertions(+), 10 deletions(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 644664098ae7..2df2b9bde7d7 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -110,6 +110,14 @@ struct nvme_queue;
 static void nvme_dev_disable(struct nvme_dev *dev, bool shutdown);
 static bool __nvme_disable_io_queues(struct nvme_dev *dev, u8 opcode);
=20
+struct nvme_dma_mapping {
+	int nr_pages;
+	u16 offset;
+	u8  rsvd[2];
+	dma_addr_t prp_dma_addr;
+	__le64 *prps;
+};
+
 /*
  * Represents an NVM Express device.  Each nvme_dev is a PCI function.
  */
@@ -544,6 +552,34 @@ static inline bool nvme_pci_use_sgls(struct nvme_dev=
 *dev, struct request *req)
 	return true;
 }
=20
+static void nvme_sync_dma(struct nvme_dev *dev, struct request *req,
+			  struct nvme_dma_mapping *mapping)
+{
+	int offset, i, j, length, nprps;
+	bool needs_sync;
+
+	offset =3D blk_rq_dma_offset(req) + mapping->offset;
+	i =3D offset >> NVME_CTRL_PAGE_SHIFT;
+	needs_sync =3D rq_data_dir(req) =3D=3D READ &&
+		 dma_need_sync(dev->dev, le64_to_cpu(mapping->prps[i]));
+
+	if (!needs_sync)
+		return;
+
+	offset =3D offset & (NVME_CTRL_PAGE_SIZE - 1);
+	length =3D blk_rq_payload_bytes(req) - (NVME_CTRL_PAGE_SIZE - offset);
+	nprps =3D DIV_ROUND_UP(length, NVME_CTRL_PAGE_SIZE);
+
+	dma_sync_single_for_cpu(dev->dev,
+		le64_to_cpu(mapping->prps[i++]),
+		NVME_CTRL_PAGE_SIZE - offset, DMA_FROM_DEVICE);
+	for (j =3D 1; j < nprps; j++) {
+		dma_sync_single_for_cpu(dev->dev,
+			le64_to_cpu(mapping->prps[i++]),
+			NVME_CTRL_PAGE_SIZE, DMA_FROM_DEVICE);
+	}
+}
+
 static void nvme_free_prps(struct nvme_dev *dev, struct request *req)
 {
 	const int last_prp =3D NVME_CTRL_PAGE_SIZE / sizeof(__le64) - 1;
@@ -576,10 +612,24 @@ static void nvme_free_sgls(struct nvme_dev *dev, st=
ruct request *req)
 	}
 }
=20
+static void nvme_free_prp_chain(struct nvme_dev *dev, struct request *re=
q,
+				struct nvme_iod *iod)
+{
+	if (iod->npages =3D=3D 0)
+		dma_pool_free(dev->prp_small_pool, nvme_pci_iod_list(req)[0],
+			      iod->first_dma);
+	else if (iod->use_sgl)
+		nvme_free_sgls(dev, req);
+	else
+		nvme_free_prps(dev, req);
+	mempool_free(iod->sg, dev->iod_mempool);
+}
+
 static void nvme_unmap_sg(struct nvme_dev *dev, struct request *req)
 {
 	struct nvme_iod *iod =3D blk_mq_rq_to_pdu(req);
=20
+	WARN_ON_ONCE(!iod->nents);
 	if (is_pci_p2pdma_page(sg_page(iod->sg)))
 		pci_p2pdma_unmap_sg(dev->dev, iod->sg, iod->nents,
 				    rq_dma_dir(req));
@@ -589,25 +639,24 @@ static void nvme_unmap_sg(struct nvme_dev *dev, str=
uct request *req)
=20
 static void nvme_unmap_data(struct nvme_dev *dev, struct request *req)
 {
+	struct nvme_dma_mapping *mapping =3D blk_rq_dma_tag(req);
 	struct nvme_iod *iod =3D blk_mq_rq_to_pdu(req);
=20
+	if (mapping) {
+		nvme_sync_dma(dev, req, mapping);
+		if (iod->npages >=3D 0)
+			nvme_free_prp_chain(dev, req, iod);
+		return;
+	}
+
 	if (iod->dma_len) {
 		dma_unmap_page(dev->dev, iod->first_dma, iod->dma_len,
 			       rq_dma_dir(req));
 		return;
 	}
=20
-	WARN_ON_ONCE(!iod->nents);
-
 	nvme_unmap_sg(dev, req);
-	if (iod->npages =3D=3D 0)
-		dma_pool_free(dev->prp_small_pool, nvme_pci_iod_list(req)[0],
-			      iod->first_dma);
-	else if (iod->use_sgl)
-		nvme_free_sgls(dev, req);
-	else
-		nvme_free_prps(dev, req);
-	mempool_free(iod->sg, dev->iod_mempool);
+	nvme_free_prp_chain(dev, req, iod);
 }
=20
 static void nvme_print_sgl(struct scatterlist *sgl, int nents)
@@ -835,13 +884,136 @@ static blk_status_t nvme_setup_sgl_simple(struct n=
vme_dev *dev,
 	return BLK_STS_OK;
 }
=20
+static blk_status_t nvme_premapped(struct nvme_dev *dev, struct request =
*req,
+				   struct nvme_rw_command *cmnd,
+				   struct nvme_iod *iod,
+				   struct nvme_dma_mapping *mapping)
+{
+	static const int last_prp =3D NVME_CTRL_PAGE_SIZE / sizeof(__le64) - 1;
+	dma_addr_t prp_list_start, prp_list_end, prp_dma;
+	int i, offset, j, length, nprps, nprps_left;
+	struct dma_pool *pool;
+	__le64 *prp_list;
+	bool needs_sync;
+	void **list;
+
+	offset =3D blk_rq_dma_offset(req) + mapping->offset;
+	i =3D offset >> NVME_CTRL_PAGE_SHIFT;
+	offset =3D offset & (NVME_CTRL_PAGE_SIZE - 1);
+	needs_sync =3D rq_data_dir(req) =3D=3D WRITE &&
+		 dma_need_sync(dev->dev, le64_to_cpu(mapping->prps[i]));
+
+	if (needs_sync) {
+		dma_sync_single_for_device(dev->dev,
+			le64_to_cpu(mapping->prps[i]),
+			NVME_CTRL_PAGE_SIZE - offset, DMA_TO_DEVICE);
+	}
+
+	length =3D blk_rq_payload_bytes(req) - (NVME_CTRL_PAGE_SIZE - offset);
+	cmnd->dptr.prp1 =3D cpu_to_le64(le64_to_cpu(mapping->prps[i++]) + offse=
t);
+
+	if (length <=3D 0)
+		return BLK_STS_OK;
+
+	if (length <=3D NVME_CTRL_PAGE_SIZE) {
+		if (needs_sync)
+			dma_sync_single_for_device(dev->dev,
+				le64_to_cpu(mapping->prps[i]),
+				NVME_CTRL_PAGE_SIZE, DMA_TO_DEVICE);
+		cmnd->dptr.prp2 =3D mapping->prps[i];
+		return BLK_STS_OK;
+	}
+
+	nprps =3D DIV_ROUND_UP(length, NVME_CTRL_PAGE_SIZE);
+	prp_list_start =3D mapping->prp_dma_addr + 8 * i;
+	prp_list_end =3D prp_list_start + 8 * nprps;
+
+	/* Optimization when remaining list fits in one nvme page */
+	if ((prp_list_start >> NVME_CTRL_PAGE_SHIFT) =3D=3D
+	    (prp_list_end >> NVME_CTRL_PAGE_SHIFT)) {
+		cmnd->dptr.prp2 =3D cpu_to_le64(prp_list_start);
+		goto sync;
+	}
+
+	iod->sg =3D mempool_alloc(dev->iod_mempool, GFP_ATOMIC);
+	if (!iod->sg)
+		return BLK_STS_RESOURCE;
+
+	if (nprps <=3D (256 / 8)) {
+		pool =3D dev->prp_small_pool;
+		iod->npages =3D 0;
+	} else {
+		pool =3D dev->prp_page_pool;
+		iod->npages =3D 1;
+	}
+
+	prp_list =3D dma_pool_alloc(pool, GFP_ATOMIC, &prp_dma);
+	if (!prp_list) {
+		iod->npages =3D -1;
+		goto out_free_sg;
+	}
+
+	list =3D nvme_pci_iod_list(req);
+	list[0] =3D prp_list;
+	iod->first_dma =3D prp_dma;
+
+	for (;;) {
+		dma_addr_t next_prp_dma;
+		__le64 *next_prp_list;
+
+		if (nprps_left <=3D last_prp + 1) {
+			memcpy(prp_list, &mapping->prps[i], nprps_left * 8);
+			break;
+		}
+
+		memcpy(prp_list, &mapping->prps[i],
+		       NVME_CTRL_PAGE_SIZE - 8);
+		nprps_left -=3D last_prp;
+		i +=3D last_prp;
+
+		next_prp_list =3D dma_pool_alloc(pool, GFP_ATOMIC, &next_prp_dma);
+		if (!next_prp_list)
+			goto free_prps;
+
+		prp_list[last_prp] =3D cpu_to_le64(next_prp_dma);
+		prp_list =3D next_prp_list;
+		prp_dma =3D next_prp_dma;
+		list[iod->npages++] =3D prp_list;
+	}
+	cmnd->dptr.prp2 =3D cpu_to_le64(iod->first_dma);
+
+sync:
+	if (!needs_sync)
+		return BLK_STS_OK;
+
+	i =3D offset >> NVME_CTRL_PAGE_SHIFT;
+	for (j =3D 0; j < nprps; j++)
+		dma_sync_single_for_device(dev->dev,
+			le64_to_cpu(mapping->prps[i++]),
+			NVME_CTRL_PAGE_SIZE, DMA_TO_DEVICE);
+	return BLK_STS_OK;
+
+free_prps:
+	nvme_free_prps(dev, req);
+out_free_sg:
+	mempool_free(iod->sg, dev->iod_mempool);
+	return BLK_STS_RESOURCE;
+}
+
 static blk_status_t nvme_map_data(struct nvme_dev *dev, struct request *=
req,
 		struct nvme_command *cmnd)
 {
+	struct nvme_dma_mapping *mapping =3D blk_rq_dma_tag(req);
 	struct nvme_iod *iod =3D blk_mq_rq_to_pdu(req);
 	blk_status_t ret =3D BLK_STS_RESOURCE;
 	int nr_mapped;
=20
+	if (mapping) {
+		iod->dma_len =3D 0;
+		iod->use_sgl =3D false;
+		return nvme_premapped(dev, req, &cmnd->rw, iod, mapping);
+	}
+
 	if (blk_rq_nr_phys_segments(req) =3D=3D 1) {
 		struct bio_vec bv =3D req_bvec(req);
=20
@@ -1732,6 +1904,112 @@ static int nvme_create_queue(struct nvme_queue *n=
vmeq, int qid, bool polled)
 	return result;
 }
=20
+#ifdef CONFIG_HAS_DMA
+/*
+ * Important: bvec must be describing a virtually contiguous buffer.
+ */
+static void *nvme_pci_dma_map(struct request_queue *q,
+			       struct bio_vec *bvec, int nr_vecs)
+{
+	const int nvme_pages =3D 1 << (PAGE_SIZE - NVME_CTRL_PAGE_SIZE);
+	struct nvme_ns *ns =3D q->queuedata;
+	struct nvme_dev *dev =3D to_nvme_dev(ns->ctrl);
+	struct nvme_dma_mapping *mapping;
+	int i, j, k, size, ppv, ret =3D -ENOMEM;
+
+	if (!nr_vecs)
+		return ERR_PTR(-EINVAL);
+
+	mapping =3D kzalloc(sizeof(*mapping), GFP_KERNEL);
+	if (!mapping)
+		return ERR_PTR(-ENOMEM);
+
+	mapping->nr_pages =3D nr_vecs * nvme_pages;
+	size =3D sizeof(*mapping->prps) * mapping->nr_pages;
+	mapping->prps =3D dma_alloc_coherent(dev->dev, size,
+				&mapping->prp_dma_addr, GFP_KERNEL);
+	if (!mapping->prps)
+		goto free_mapping;
+
+	for (i =3D 0, k =3D 0; i < nr_vecs; i++) {
+		struct bio_vec *bv =3D bvec + i;
+		dma_addr_t dma_addr;
+
+		ppv =3D nvme_pages;
+		if (i =3D=3D 0) {
+			mapping->offset =3D bv->bv_offset;
+			ppv -=3D mapping->offset >> NVME_CTRL_PAGE_SHIFT;
+		} else if (bv->bv_offset) {
+			ret =3D -EINVAL;
+			goto err;
+		}
+
+		if (bv->bv_offset + bv->bv_len !=3D PAGE_SIZE &&
+		    i < nr_vecs - 1) {
+			ret =3D -EINVAL;
+			goto err;
+		}
+
+		dma_addr =3D dma_map_bvec(dev->dev, bv, 0, 0);
+		if (dma_mapping_error(dev->dev, dma_addr)) {
+			ret =3D -EIO;
+			goto err;
+		}
+
+		if (i =3D=3D 0)
+			dma_addr -=3D mapping->offset;
+
+		for (j =3D 0; j < ppv; j++)
+			mapping->prps[k++] =3D cpu_to_le64(dma_addr +
+						j * NVME_CTRL_PAGE_SIZE);
+	}
+
+	get_device(dev->dev);
+	return mapping;
+
+err:
+	for (i =3D 0; i < k; i +=3D ppv) {
+		__u64 dma_addr =3D le64_to_cpu(mapping->prps[i]);
+		ppv =3D nvme_pages;
+
+		if (i =3D=3D 0)
+			ppv -=3D mapping->offset >> NVME_CTRL_PAGE_SHIFT;
+		dma_unmap_page(dev->dev, dma_addr,
+			       PAGE_SIZE - offset_in_page(dma_addr), 0);
+	}
+
+	dma_free_coherent(dev->dev, size, (void *)mapping->prps,
+			  mapping->prp_dma_addr);
+free_mapping:
+	kfree(mapping);
+	return ERR_PTR(ret);
+}
+
+static void nvme_pci_dma_unmap(struct request_queue *q, void *dma_tag)
+{
+	const int nvme_pages =3D 1 << (PAGE_SIZE - NVME_CTRL_PAGE_SIZE);
+	struct nvme_ns *ns =3D q->queuedata;
+	struct nvme_dev *dev =3D to_nvme_dev(ns->ctrl);
+	struct nvme_dma_mapping *mapping =3D dma_tag;
+	int i, ppv;
+
+	for (i =3D 0; i < mapping->nr_pages; i +=3D nvme_pages) {
+		__u64 dma_addr =3D le64_to_cpu(mapping->prps[i]);
+		ppv =3D nvme_pages;
+
+		if (i =3D=3D 0)
+			ppv -=3D mapping->offset >> NVME_CTRL_PAGE_SHIFT;
+		dma_unmap_page(dev->dev, dma_addr,
+			       PAGE_SIZE - offset_in_page(dma_addr), 0);
+	}
+
+	dma_free_coherent(dev->dev, mapping->nr_pages * sizeof(*mapping->prps),
+			  (void *)mapping->prps, mapping->prp_dma_addr);
+	kfree(mapping);
+	put_device(dev->dev);
+}
+#endif
+
 static const struct blk_mq_ops nvme_mq_admin_ops =3D {
 	.queue_rq	=3D nvme_queue_rq,
 	.complete	=3D nvme_pci_complete_rq,
@@ -1750,6 +2028,10 @@ static const struct blk_mq_ops nvme_mq_ops =3D {
 	.map_queues	=3D nvme_pci_map_queues,
 	.timeout	=3D nvme_timeout,
 	.poll		=3D nvme_poll,
+#ifdef CONFIG_HAS_DMA
+	.dma_map	=3D nvme_pci_dma_map,
+	.dma_unmap	=3D nvme_pci_dma_unmap,
+#endif
 };
=20
 static void nvme_dev_remove_admin(struct nvme_dev *dev)
--=20
2.30.2

