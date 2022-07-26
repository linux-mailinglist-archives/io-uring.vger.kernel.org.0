Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37386581888
	for <lists+io-uring@lfdr.de>; Tue, 26 Jul 2022 19:38:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238101AbiGZRig (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Jul 2022 13:38:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239432AbiGZRia (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Jul 2022 13:38:30 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E2942B279
        for <io-uring@vger.kernel.org>; Tue, 26 Jul 2022 10:38:28 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26QEJndW001509
        for <io-uring@vger.kernel.org>; Tue, 26 Jul 2022 10:38:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=xXA4PeA+Ixr6EVwKEP8AkMKM0BHBogXynqcDNFl5W98=;
 b=FoGwSyh9qZ4SxN67Vue0TY6aaADsWFs8DPoqTqRgFdR85fBrM4FfU/E5+XNej4twOLx2
 dmuS5PKtiKfyAUGkqNYzDb0RlmCpn9Wyd2lXzRBnOqMiwlupza77UTNhNxu0GBhI6OBY
 WUPvRdjrPLqe3LOEG6mD7GJY8NK1Iobwrg4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hjhxashpa-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 26 Jul 2022 10:38:27 -0700
Received: from twshared22413.18.frc3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Tue, 26 Jul 2022 10:38:26 -0700
Received: by devbig007.nao1.facebook.com (Postfix, from userid 544533)
        id 8D0D1698E4B2; Tue, 26 Jul 2022 10:38:15 -0700 (PDT)
From:   Keith Busch <kbusch@fb.com>
To:     <linux-nvme@lists.infradead.org>, <linux-block@vger.kernel.org>,
        <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>
CC:     <axboe@kernel.dk>, <hch@lst.de>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Keith Busch <kbusch@kernel.org>
Subject: [PATCH 5/5] nvme-pci: implement dma_map support
Date:   Tue, 26 Jul 2022 10:38:14 -0700
Message-ID: <20220726173814.2264573-6-kbusch@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220726173814.2264573-1-kbusch@fb.com>
References: <20220726173814.2264573-1-kbusch@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: M7Ejgf-TIjQlFKBm-MWsirGhTbvWhmcp
X-Proofpoint-GUID: M7Ejgf-TIjQlFKBm-MWsirGhTbvWhmcp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-26_05,2022-07-26_01,2022-06-22_01
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
 drivers/nvme/host/pci.c | 291 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 283 insertions(+), 8 deletions(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 644664098ae7..571d955eaef0 100644
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
@@ -544,6 +552,35 @@ static inline bool nvme_pci_use_sgls(struct nvme_dev=
 *dev, struct request *req)
 	return true;
 }
=20
+static void nvme_sync_dma(struct nvme_dev *dev, struct request *req)
+{
+	int index, offset, i, length, nprps;
+	struct nvme_dma_mapping *mapping;
+	bool needs_sync;
+
+	mapping =3D blk_rq_dma_tag(req);
+	offset =3D blk_rq_dma_offset(req) + mapping->offset;
+	index =3D offset >> NVME_CTRL_PAGE_SHIFT;
+	needs_sync =3D rq_data_dir(req) =3D=3D READ &&
+		 dma_need_sync(dev->dev, le64_to_cpu(mapping->prps[index]));
+
+	if (!needs_sync)
+		return;
+
+	offset =3D offset & (NVME_CTRL_PAGE_SIZE - 1);
+	length =3D blk_rq_payload_bytes(req) - (NVME_CTRL_PAGE_SIZE - offset);
+	nprps =3D DIV_ROUND_UP(length, NVME_CTRL_PAGE_SIZE);
+
+	dma_sync_single_for_cpu(dev->dev,
+		le64_to_cpu(mapping->prps[index++]),
+		NVME_CTRL_PAGE_SIZE - offset, DMA_FROM_DEVICE);
+	for (i =3D 1; i < nprps; i++) {
+		dma_sync_single_for_cpu(dev->dev,
+			le64_to_cpu(mapping->prps[index++]),
+			NVME_CTRL_PAGE_SIZE, DMA_FROM_DEVICE);
+	}
+}
+
 static void nvme_free_prps(struct nvme_dev *dev, struct request *req)
 {
 	const int last_prp =3D NVME_CTRL_PAGE_SIZE / sizeof(__le64) - 1;
@@ -576,6 +613,21 @@ static void nvme_free_sgls(struct nvme_dev *dev, str=
uct request *req)
 	}
 }
=20
+static void nvme_free_prp_chain(struct nvme_dev *dev, struct request *re=
q,
+				struct nvme_iod *iod)
+{
+	if (iod->npages < 0)
+		return;
+
+	if (iod->npages =3D=3D 0)
+		dma_pool_free(dev->prp_small_pool, nvme_pci_iod_list(req)[0],
+			      iod->first_dma);
+	else if (iod->use_sgl)
+		nvme_free_sgls(dev, req);
+	else
+		nvme_free_prps(dev, req);
+}
+
 static void nvme_unmap_sg(struct nvme_dev *dev, struct request *req)
 {
 	struct nvme_iod *iod =3D blk_mq_rq_to_pdu(req);
@@ -595,18 +647,15 @@ static void nvme_unmap_data(struct nvme_dev *dev, s=
truct request *req)
 		dma_unmap_page(dev->dev, iod->first_dma, iod->dma_len,
 			       rq_dma_dir(req));
 		return;
+	} else if (blk_rq_dma_tag(req)) {
+		nvme_sync_dma(dev, req);
+		nvme_free_prp_chain(dev, req, iod);
+		return;
 	}
=20
 	WARN_ON_ONCE(!iod->nents);
-
 	nvme_unmap_sg(dev, req);
-	if (iod->npages =3D=3D 0)
-		dma_pool_free(dev->prp_small_pool, nvme_pci_iod_list(req)[0],
-			      iod->first_dma);
-	else if (iod->use_sgl)
-		nvme_free_sgls(dev, req);
-	else
-		nvme_free_prps(dev, req);
+	nvme_free_prp_chain(dev, req, iod);
 	mempool_free(iod->sg, dev->iod_mempool);
 }
=20
@@ -835,6 +884,122 @@ static blk_status_t nvme_setup_sgl_simple(struct nv=
me_dev *dev,
 	return BLK_STS_OK;
 }
=20
+static blk_status_t nvme_premapped(struct nvme_dev *dev, struct request =
*req,
+				   struct nvme_rw_command *cmnd,
+				   struct nvme_iod *iod)
+{
+	static const int last_prp =3D NVME_CTRL_PAGE_SIZE / sizeof(__le64) - 1;
+	dma_addr_t prp_list_start, prp_list_end, prp_dma;
+	int index, offset, i, length, nprps, nprps_left;
+	void **list =3D nvme_pci_iod_list(req);
+	struct nvme_dma_mapping *mapping;
+	struct dma_pool *pool;
+	__le64 *prp_list;
+	bool needs_sync;
+
+	mapping =3D blk_rq_dma_tag(req);
+	offset =3D blk_rq_dma_offset(req) + mapping->offset;
+	index =3D offset >> NVME_CTRL_PAGE_SHIFT;
+	offset =3D offset & (NVME_CTRL_PAGE_SIZE - 1);
+	needs_sync =3D rq_data_dir(req) =3D=3D WRITE &&
+		 dma_need_sync(dev->dev, le64_to_cpu(mapping->prps[index]));
+
+	/*
+	 * XXX: For PAGE_SIZE > NVME_CTRL_PAGE_SIZE, is it faster to save the
+	 * PRP list implementation and sync multiple partial pages, more
+	 * efficient to sync PAGE_SIZE and build the PRP list per-IO from a
+	 * host PAGE_SIZE representation, or cleverly sync physically
+	 * contiguous regions?
+	 */
+	if (needs_sync) {
+		dma_sync_single_for_device(dev->dev,
+			le64_to_cpu(mapping->prps[index]),
+			NVME_CTRL_PAGE_SIZE - offset, DMA_TO_DEVICE);
+	}
+
+	length =3D blk_rq_payload_bytes(req) - (NVME_CTRL_PAGE_SIZE - offset);
+	cmnd->dptr.prp1 =3D cpu_to_le64(le64_to_cpu(mapping->prps[index++]) + o=
ffset);
+
+	if (length <=3D 0)
+		return BLK_STS_OK;
+
+	if (length <=3D NVME_CTRL_PAGE_SIZE) {
+		if (needs_sync)
+			dma_sync_single_for_device(dev->dev,
+				le64_to_cpu(mapping->prps[index]),
+				NVME_CTRL_PAGE_SIZE, DMA_TO_DEVICE);
+		cmnd->dptr.prp2 =3D mapping->prps[index];
+		return BLK_STS_OK;
+	}
+
+	nprps =3D DIV_ROUND_UP(length, NVME_CTRL_PAGE_SIZE);
+	prp_list_start =3D mapping->prp_dma_addr + 8 * index;
+	prp_list_end =3D prp_list_start + 8 * nprps;
+
+	/* Optimization when remaining list fits in one nvme page */
+	if ((prp_list_start >> NVME_CTRL_PAGE_SHIFT) =3D=3D
+	    (prp_list_end >> NVME_CTRL_PAGE_SHIFT)) {
+		cmnd->dptr.prp2 =3D cpu_to_le64(prp_list_start);
+		goto sync;
+	}
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
+		return BLK_STS_RESOURCE;
+	}
+
+	list[0] =3D prp_list;
+	iod->first_dma =3D prp_dma;
+	i =3D 0;
+	for (;;) {
+		dma_addr_t next_prp_dma;
+		__le64 *next_prp_list;
+
+		if (nprps_left <=3D last_prp + 1) {
+			memcpy(prp_list, &mapping->prps[index], nprps_left * 8);
+			break;
+		}
+
+		memcpy(prp_list, &mapping->prps[index],
+		       NVME_CTRL_PAGE_SIZE - 8);
+		nprps_left -=3D last_prp;
+		index +=3D last_prp;
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
+	for (i =3D 0; i < nprps; i++)
+		dma_sync_single_for_device(dev->dev,
+			le64_to_cpu(mapping->prps[index++]),
+			NVME_CTRL_PAGE_SIZE, DMA_TO_DEVICE);
+	return BLK_STS_OK;
+
+free_prps:
+	nvme_free_prps(dev, req);
+	return BLK_STS_RESOURCE;
+}
+
 static blk_status_t nvme_map_data(struct nvme_dev *dev, struct request *=
req,
 		struct nvme_command *cmnd)
 {
@@ -842,6 +1007,12 @@ static blk_status_t nvme_map_data(struct nvme_dev *=
dev, struct request *req,
 	blk_status_t ret =3D BLK_STS_RESOURCE;
 	int nr_mapped;
=20
+	if (blk_rq_dma_tag(req)) {
+		iod->dma_len =3D 0;
+		iod->use_sgl =3D false;
+		return nvme_premapped(dev, req, &cmnd->rw, iod);
+	}
+
 	if (blk_rq_nr_phys_segments(req) =3D=3D 1) {
 		struct bio_vec bv =3D req_bvec(req);
=20
@@ -1732,6 +1903,106 @@ static int nvme_create_queue(struct nvme_queue *n=
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
+	int i, j, k, size, ret =3D -ENOMEM;
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
+		int pages_per =3D nvme_pages;
+		dma_addr_t dma_addr;
+
+		if (i =3D=3D 0) {
+			mapping->offset =3D bv->bv_offset;
+			pages_per -=3D mapping->offset >> NVME_CTRL_PAGE_SHIFT;
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
+		for (j =3D 0; j < nvme_pages; j++)
+			mapping->prps[k++] =3D cpu_to_le64(dma_addr +
+						j * NVME_CTRL_PAGE_SIZE);
+	}
+
+	get_device(dev->dev);
+	return mapping;
+
+err:
+	for (i =3D 0; i < k; i +=3D nvme_pages) {
+		__u64 dma_addr =3D le64_to_cpu(mapping->prps[i]);
+
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
+	int i;
+
+	for (i =3D 0; i < mapping->nr_pages; i +=3D nvme_pages) {
+		__u64 dma_addr =3D le64_to_cpu(mapping->prps[i]);
+
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
@@ -1750,6 +2021,10 @@ static const struct blk_mq_ops nvme_mq_ops =3D {
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

