Return-Path: <io-uring+bounces-13179-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OLuDKbIl8mm/oQEAu9opvQ
	(envelope-from <io-uring+bounces-13179-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 29 Apr 2026 17:37:22 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BD80497120
	for <lists+io-uring@lfdr.de>; Wed, 29 Apr 2026 17:37:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 62A8B300C9A5
	for <lists+io-uring@lfdr.de>; Wed, 29 Apr 2026 15:27:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 638BF37CD25;
	Wed, 29 Apr 2026 15:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k0wwavOr"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1931B3815FE
	for <io-uring@vger.kernel.org>; Wed, 29 Apr 2026 15:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777476419; cv=none; b=vCAl3WHkgFBHzrT7Zfo3vW/y+oDaIEBLfN5Tf2Txc1f8fxbeT08AOcRZ/86lBIr+9JQC2nJuqfUF74+XrSG7ypiYma4R8840o2V1cw55NOxqZiuXmnNhlmPFoE3wKP/aMIiRQLeOmy+swWRxR/tAGvJMhBV+0gif2UwTfrhPKVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777476419; c=relaxed/simple;
	bh=Wh6RxPyI66yH5ETIHW2PWMsa8ELteQ8VlbfRUpAojEw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pEu5fwKyovxADyCvgBRwVc9JLn4NqmpkqDHYPhNbOEAfRjiTGsimwjaHuqv2gmrzVtGCALFlbQD4TRD6mszPiDFc8lxAGgU26iFAoeYLGsn5Yiorp7INNSBkeitbi1/9GU4d91z01HALMcuwade+NB8uAWMfdj3Qis6U+BeCTgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k0wwavOr; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-43d70b3e159so6820143f8f.0
        for <io-uring@vger.kernel.org>; Wed, 29 Apr 2026 08:26:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777476415; x=1778081215; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5tNLlPR5H1MSAY4d3fHMpPecWT4SmT3leRzkE1JmSrg=;
        b=k0wwavOrhL2+fKFQ6mIy4Q3Gyn/rsRnsOeI2ie/YQMPwx9X7Ymh6lhDPq9Rn5WzIKC
         0yDfOrUZSb64tta39Sw0I4AH118wpEuIM9bt/5i0QrXpcQeQb2TWjetmp5rSsTdb6vL+
         nf5weWE/ZW4HvkzRFaO7oc52iA3iI8CG3ZURJiIEpRP0fKvZQONkrv+72B7vfeo8s/j+
         iDQE469DaOKL2qkYwXBbtXTr4Qmg7mvROQKJEHjteR+I3dO3Lwzp4QDb2i/gKpQfKeEd
         fwHBzdi4NygkgsJGhazvKYe7+nRG8nVgNp99I0TTthpP39SJkfiXWxTEDmRz5qiRlS1M
         DrkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777476415; x=1778081215;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5tNLlPR5H1MSAY4d3fHMpPecWT4SmT3leRzkE1JmSrg=;
        b=WdbT/ZfN8AQQY+ERYxeScUsf+PWv60iBPstmvgw+ZlLpAPF0J5KPBLFFLHuT192t7A
         qe0ok5BC2u+pAGlCKCJaTJ+sMk/DdmCMXGmE+Rh+Of2u3xH4f9DMfvJwhFL71A9LOEcD
         inv2eBqp0n3K9cvpolJAfXQhrGzDaPIOJrfv7/HU++BE7i9atbOupIbv3BmWtvKurnzB
         WnVXfRIbWPNZm2lEEJbiTX+ygP4W0aBi6PYC5ci4ED20sK1wAIZVo/8qUDEIvJpoVQou
         NMmOQr7IDczj8n1uQnd/BNdVaLguxqjCZeIcZYoJ/ymcRgFWTWSuQCMdB9GURE5RU8f1
         0ExQ==
X-Forwarded-Encrypted: i=1; AFNElJ9IOoZFeo7Tt7pKlNo7jsUNaNuQm2BwqDtjBxupigbwr/gSGgt2WPUtlDMYXMrSbrPx6VmE6sr+Ew==@vger.kernel.org
X-Gm-Message-State: AOJu0YxHZd4aQqlkatIVYQzHvQt6GQ6pR4CISN5CVp6UbS87CkISty/Q
	xLRouwmfnNHdlcoOzBGNfZxDsphRe/HgbJ422wrg4bM7L3DCrA9bspTs
X-Gm-Gg: AeBDieuRNetEYAGwIxCjuQyzbpik5OnBimgbqrWRTQXwu6fT+q9NtCsm7ctC0SZkTm6
	qbOJhMq5Kn7fM7BCRwELL1OGvrmpTQhamlHey3SLWtDb6no0ESBRi5XkUsPWwnZ7nBiasD0ewx3
	W/2aDGj8eBO+3Byxz/j+emY9elNoFQzubGvxrDDw3YbooG5u+P9k3ZI+5Vo7DDVCHxpADbdPK04
	2hNmscOKZ6cG2O00mOfHQzG9aduj6F4STxeLpQWtzqC1u6+C28oNr9GOBl+JBfwfznGRbudhiqy
	3zPKza9xm9m41gIB6d9WZ5ZPqM+11d8B/gHpL8c2wssvoeArwp+ljExLSPdWieMxu0h8wYz3+VA
	0m2bvcOQXIlrK/vCksGe/MK0OwIxIVphi5/pTY6yXlTOBOGPYiYAQHhVvztz/wZF5aBZsFoDnmd
	495VleazwnH7eC0gQkyzKs1ydQgOzWckjiveUPfsqJVk10z/xaVWdQg6QjFL/qLlqjYQZToPYPq
	wSqm440t4jV9IMvqkLfHMDKn7W4wq95i4KaXzJGFWqy
X-Received: by 2002:a05:6000:601:b0:43f:e22d:9a73 with SMTP id ffacd0b85a97d-44647808b94mr14223288f8f.2.1777476415006;
        Wed, 29 Apr 2026 08:26:55 -0700 (PDT)
Received: from 127.0.0.1localhost ([82.132.184.31])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-447b76e5c22sm6382951f8f.28.2026.04.29.08.26.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2026 08:26:54 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>,
	Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org,
	linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org
Cc: asml.silence@gmail.com,
	Nitesh Shetty <nj.shetty@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Anuj Gupta <anuj20.g@samsung.com>,
	Tushar Gohad <tushar.gohad@intel.com>,
	William Power <william.power@intel.com>,
	Phil Cayton <phil.cayton@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH v3 07/10] nvme-pci: implement dma_token backed requests
Date: Wed, 29 Apr 2026 16:25:53 +0100
Message-ID: <5cecb1157ab784f9f303a91449fdf11b03aa6002.1777475843.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1777475843.git.asml.silence@gmail.com>
References: <cover.1777475843.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3BD80497120
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[25];
	FREEMAIL_FROM(0.00)[gmail.com];
	TAGGED_FROM(0.00)[bounces-13179-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,samsung.com,intel.com,nvidia.com];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[]

Enable BIO_DMABUF_MAP backed requests. It creates a prp list for the
dmabuf when it's mapped, which is then used to initialise requests.

Suggested-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 drivers/nvme/host/pci.c | 282 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 282 insertions(+)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index db5fc9bf6627..d2629853a972 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -27,6 +27,8 @@
 #include <linux/io-64-nonatomic-lo-hi.h>
 #include <linux/io-64-nonatomic-hi-lo.h>
 #include <linux/sed-opal.h>
+#include <linux/io_dmabuf_token.h>
+#include <linux/dma-resv.h>
 
 #include "trace.h"
 #include "nvme.h"
@@ -393,6 +395,17 @@ struct nvme_queue {
 	struct completion delete_done;
 };
 
+struct nvme_dmabuf_token {
+	struct dma_buf_attachment *attach;
+};
+
+struct nvme_dmabuf_map {
+	struct io_dmabuf_map base;
+	dma_addr_t *dma_list;
+	struct sg_table *sgt;
+	unsigned nr_entries;
+};
+
 /* bits for iod->flags */
 enum nvme_iod_flags {
 	/* this command has been aborted by the timeout handler */
@@ -854,6 +867,134 @@ static void nvme_free_descriptors(struct request *req)
 	}
 }
 
+static void nvme_dmabuf_map_sync(struct nvme_dev *nvme_dev, struct request *req,
+				 bool for_cpu)
+{
+	int length = blk_rq_payload_bytes(req);
+	struct device *dev = nvme_dev->dev;
+	enum dma_data_direction dma_dir;
+	struct bio *bio = req->bio;
+	struct nvme_dmabuf_map *map;
+	dma_addr_t *dma_list;
+	int offset, map_idx;
+
+	dma_dir = rq_data_dir(req) == READ ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
+	map = container_of(bio->dmabuf_map, struct nvme_dmabuf_map, base);
+	dma_list = map->dma_list;
+
+	offset = bio->bi_iter.bi_bvec_done;
+	map_idx = offset / NVME_CTRL_PAGE_SIZE;
+	length += offset & (NVME_CTRL_PAGE_SIZE - 1);
+
+	while (length > 0) {
+		u64 dma_addr = dma_list[map_idx++];
+
+		if (for_cpu)
+			__dma_sync_single_for_cpu(dev, dma_addr,
+						  NVME_CTRL_PAGE_SIZE, dma_dir);
+		else
+			__dma_sync_single_for_device(dev, dma_addr,
+						     NVME_CTRL_PAGE_SIZE,
+						     dma_dir);
+		length -= NVME_CTRL_PAGE_SIZE;
+	}
+}
+
+static void nvme_rq_clean_dmabuf_map(struct nvme_dev *dev,
+				      struct request *req)
+{
+	struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
+
+	nvme_dmabuf_map_sync(dev, req, true);
+
+	if (!(iod->flags & IOD_SINGLE_SEGMENT))
+		nvme_free_descriptors(req);
+}
+
+static blk_status_t nvme_rq_setup_dmabuf_map(struct request *req,
+					     struct nvme_queue *nvmeq)
+{
+	struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
+	int length = blk_rq_payload_bytes(req);
+	u64 dma_addr, prp1_dma, prp2_dma;
+	struct bio *bio = req->bio;
+	struct nvme_dmabuf_map *map;
+	dma_addr_t *dma_list;
+	dma_addr_t prp_dma;
+	__le64 *prp_list;
+	int i, map_idx;
+	int offset;
+
+	nvme_dmabuf_map_sync(nvmeq->dev, req, false);
+
+	map = container_of(bio->dmabuf_map, struct nvme_dmabuf_map, base);
+	dma_list = map->dma_list;
+
+	offset = bio->bi_iter.bi_bvec_done;
+	map_idx = offset / NVME_CTRL_PAGE_SIZE;
+	offset &= (NVME_CTRL_PAGE_SIZE - 1);
+	prp1_dma = dma_list[map_idx++] + offset;
+
+	length -= (NVME_CTRL_PAGE_SIZE - offset);
+	if (length <= 0) {
+		prp2_dma = 0;
+		goto done;
+	}
+
+	if (length <= NVME_CTRL_PAGE_SIZE) {
+		prp2_dma = dma_list[map_idx];
+		goto done;
+	}
+
+	if (DIV_ROUND_UP(length, NVME_CTRL_PAGE_SIZE) <=
+	    NVME_SMALL_POOL_SIZE / sizeof(__le64))
+		iod->flags |= IOD_SMALL_DESCRIPTOR;
+
+	prp_list = dma_pool_alloc(nvme_dma_pool(nvmeq, iod), GFP_ATOMIC,
+			&prp_dma);
+	if (!prp_list)
+		return BLK_STS_RESOURCE;
+
+	iod->descriptors[iod->nr_descriptors++] = prp_list;
+	prp2_dma = prp_dma;
+	i = 0;
+	for (;;) {
+		if (i == NVME_CTRL_PAGE_SIZE >> 3) {
+			__le64 *old_prp_list = prp_list;
+
+			prp_list = dma_pool_alloc(nvmeq->descriptor_pools.large,
+					GFP_ATOMIC, &prp_dma);
+			if (!prp_list)
+				goto free_prps;
+			iod->descriptors[iod->nr_descriptors++] = prp_list;
+			prp_list[0] = old_prp_list[i - 1];
+			old_prp_list[i - 1] = cpu_to_le64(prp_dma);
+			i = 1;
+		}
+
+		dma_addr = dma_list[map_idx++];
+		prp_list[i++] = cpu_to_le64(dma_addr);
+
+		length -= NVME_CTRL_PAGE_SIZE;
+		if (length <= 0)
+			break;
+	}
+done:
+	iod->cmd.common.dptr.prp1 = cpu_to_le64(prp1_dma);
+	iod->cmd.common.dptr.prp2 = cpu_to_le64(prp2_dma);
+	return BLK_STS_OK;
+free_prps:
+	nvme_free_descriptors(req);
+	return BLK_STS_RESOURCE;
+}
+
+static inline bool nvme_rq_is_dmabuf_attached(struct request *req)
+{
+	if (!IS_ENABLED(CONFIG_DMABUF_TOKEN))
+		return false;
+	return req->bio && bio_flagged(req->bio, BIO_DMABUF_MAP);
+}
+
 static void nvme_free_prps(struct request *req, unsigned int attrs)
 {
 	struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
@@ -932,6 +1073,11 @@ static void nvme_unmap_data(struct request *req)
 	struct device *dma_dev = nvmeq->dev->dev;
 	unsigned int attrs = 0;
 
+	if (nvme_rq_is_dmabuf_attached(req)) {
+		nvme_rq_clean_dmabuf_map(nvmeq->dev, req);
+		return;
+	}
+
 	if (iod->flags & IOD_SINGLE_SEGMENT) {
 		static_assert(offsetof(union nvme_data_ptr, prp1) ==
 				offsetof(union nvme_data_ptr, sgl.addr));
@@ -1222,6 +1368,9 @@ static blk_status_t nvme_map_data(struct request *req)
 	struct blk_dma_iter iter;
 	blk_status_t ret;
 
+	if (nvme_rq_is_dmabuf_attached(req))
+		return nvme_rq_setup_dmabuf_map(req, nvmeq);
+
 	/*
 	 * Try to skip the DMA iterator for single segment requests, as that
 	 * significantly improves performances for small I/O sizes.
@@ -2238,6 +2387,134 @@ static int nvme_create_queue(struct nvme_queue *nvmeq, int qid, bool polled)
 	return result;
 }
 
+#ifdef CONFIG_DMABUF_TOKEN
+static void nvme_dmabuf_invalidate_mappings(struct dma_buf_attachment *attach)
+{
+	struct io_dmabuf_token *token = attach->importer_priv;
+
+	io_dmabuf_token_invalidate_mappings(token);
+}
+
+const struct dma_buf_attach_ops nvme_dmabuf_importer_ops = {
+	.invalidate_mappings	= nvme_dmabuf_invalidate_mappings,
+	.allow_peer2peer	= true,
+};
+
+static struct io_dmabuf_map *nvme_dmabuf_token_map(struct io_dmabuf_token *token)
+{
+	struct nvme_dmabuf_token *data = token->dev_priv;
+	struct dma_buf_attachment *attach = data->attach;
+	dma_addr_t *dma_list = NULL;
+	unsigned long tmp, i = 0;
+	struct nvme_dmabuf_map *map;
+	struct scatterlist *sg;
+	struct sg_table *sgt;
+	unsigned nr_entries;
+	int ret;
+
+	dma_resv_assert_held(token->dmabuf->resv);
+
+	map = kmalloc(sizeof(*map), GFP_KERNEL);
+	if (!map)
+		return ERR_PTR(-ENOMEM);
+
+	nr_entries = token->dmabuf->size / NVME_CTRL_PAGE_SIZE;
+	dma_list = kmalloc_array(nr_entries, sizeof(dma_list[0]), GFP_KERNEL);
+	if (!dma_list) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	sgt = dma_buf_map_attachment(attach, token->dir);
+	if (IS_ERR(sgt)) {
+		ret = PTR_ERR(sgt);
+		sgt = NULL;
+		goto err;
+	}
+
+	for_each_sgtable_dma_sg(sgt, sg, tmp) {
+		dma_addr_t dma_addr = sg_dma_address(sg);
+		unsigned long sg_len = sg_dma_len(sg);
+
+		if (sg_len % NVME_CTRL_PAGE_SIZE) {
+			ret = -EINVAL;
+			goto err;
+		}
+
+		while (sg_len) {
+			dma_list[i++] = dma_addr;
+			dma_addr += NVME_CTRL_PAGE_SIZE;
+			sg_len -= NVME_CTRL_PAGE_SIZE;
+		}
+	}
+
+	ret = io_dmabuf_init_map(token, &map->base);
+	if (ret)
+		goto err;
+	map->nr_entries = nr_entries;
+	map->dma_list = dma_list;
+	map->sgt = sgt;
+	return &map->base;
+err:
+	if (sgt)
+		dma_buf_unmap_attachment(attach, sgt, token->dir);
+	kfree(map);
+	kfree(dma_list);
+	return ERR_PTR(ret);
+}
+
+static void nvme_dmabuf_token_unmap(struct io_dmabuf_token *token,
+				 struct io_dmabuf_map *map_base)
+{
+	struct nvme_dmabuf_token *data = token->dev_priv;
+	struct nvme_dmabuf_map *map = container_of(map_base,
+						struct nvme_dmabuf_map, base);
+
+	dma_resv_assert_held(token->dmabuf->resv);
+
+	dma_buf_unmap_attachment(data->attach, map->sgt, token->dir);
+	kfree(map->dma_list);
+}
+
+static void nvme_dmabuf_token_release(struct io_dmabuf_token *token)
+{
+	struct nvme_dmabuf_token *data = token->dev_priv;
+
+	dma_buf_detach(token->dmabuf, data->attach);
+	kfree(data);
+}
+
+const struct io_dmabuf_token_dev_ops nvme_dma_token_ops = {
+	.map		= nvme_dmabuf_token_map,
+	.unmap		= nvme_dmabuf_token_unmap,
+	.release	= nvme_dmabuf_token_release,
+};
+
+static int nvme_create_dmabuf_token(struct request_queue *q,
+				 struct io_dmabuf_token *token)
+{
+	struct nvme_dmabuf_token *data;
+	struct dma_buf_attachment *attach;
+	struct nvme_ns *ns = q->queuedata;
+	struct nvme_dev *dev = to_nvme_dev(ns->ctrl);
+	struct dma_buf *dmabuf = token->dmabuf;
+
+	data = kzalloc(sizeof(data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	token->dev_priv = data;
+	token->dev_ops = &nvme_dma_token_ops;
+
+	attach = dma_buf_dynamic_attach(dmabuf, dev->dev,
+					&nvme_dmabuf_importer_ops, token);
+	if (IS_ERR(attach))
+		return PTR_ERR(attach);
+	data->attach = attach;
+	return 0;
+}
+#endif
+
 static const struct blk_mq_ops nvme_mq_admin_ops = {
 	.queue_rq	= nvme_queue_rq,
 	.complete	= nvme_pci_complete_rq,
@@ -2256,6 +2533,10 @@ static const struct blk_mq_ops nvme_mq_ops = {
 	.map_queues	= nvme_pci_map_queues,
 	.timeout	= nvme_timeout,
 	.poll		= nvme_poll,
+
+#ifdef CONFIG_DMABUF_TOKEN
+	.create_dmabuf_token = nvme_create_dmabuf_token,
+#endif
 };
 
 static void nvme_dev_remove_admin(struct nvme_dev *dev)
@@ -4289,5 +4570,6 @@ MODULE_AUTHOR("Matthew Wilcox <willy@linux.intel.com>");
 MODULE_LICENSE("GPL");
 MODULE_VERSION("1.0");
 MODULE_DESCRIPTION("NVMe host PCIe transport driver");
+MODULE_IMPORT_NS("DMA_BUF");
 module_init(nvme_init);
 module_exit(nvme_exit);
-- 
2.53.0


