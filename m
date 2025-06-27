Return-Path: <io-uring+bounces-8505-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B37ACAEBB24
	for <lists+io-uring@lfdr.de>; Fri, 27 Jun 2025 17:10:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EB75856120A
	for <lists+io-uring@lfdr.de>; Fri, 27 Jun 2025 15:10:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34E8E2E8E14;
	Fri, 27 Jun 2025 15:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D50sIDy4"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52F432E8DFE;
	Fri, 27 Jun 2025 15:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751036972; cv=none; b=N5KhD4wAT7WQ1fY8bsD+uzb5oOEq6wgm3i99PP8xSluQIk2rP5B4volqwvl9a8FVNmCjCYEIKXEoSTFJRhKhcSUUtijN1uHBTFdma37QW4lm74k1sVD89UORJUHjChmC85QfW2HEF6IQWyrp4dx3RoLe5mZHUmGy526ZNoIToF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751036972; c=relaxed/simple;
	bh=M6syuuIeq/Ab7tyBsaLxwR1s1WYEVu/toDJ6GT3LAIg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=auxaXzPs6al0W4+qs4gkPqq/tebYVQYoe+cVUGbGfz5R9UFgHi5z+UitRxh7MAHs8kP74/Z3ckyTO3bOOwQ6BhQIsZIhomFRVAPbcRKSp0w9rjG6iaG1UdEBefW0GVA59v/v3O8xUI3KIR6UDD2Gk9hbnrMK0HejOP5uL4ZsDVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=D50sIDy4; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-60700a745e5so4116871a12.3;
        Fri, 27 Jun 2025 08:09:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751036968; x=1751641768; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c/bkRqK8NAvWHq4Cw69JTp0ceULHBK86bpIhKanOsjI=;
        b=D50sIDy4SErdzD5MSxdVPr3ni9utJCLmagYr8dYp/lEoShpGzuo4fjvRsqW+ztgpQF
         zo4mwwiBIOEPdFXxwZEdGmR2UpDzmbwfugMWgB60IXeMZ2EPe2/hkX5NDG2I6WP9SykG
         711AC/4TyUFN+4w8LzW6SQpXf9Werg7daa6yx/E8JjPRoDlQqdA6cyTrnhyItKC3yZLJ
         Vc97uN6yP5ZOzE05bCj+AWcxHUY5JlzcCMty4KHNARtnVi9mxET95BM1nqtZOMzgbaCx
         5L+tLhJRK3q9PL+hWUIfHGuWhdyzz8modJC9p6nPWWPdbtb+aauosycJjvxcf0PNLZFj
         RNtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751036968; x=1751641768;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c/bkRqK8NAvWHq4Cw69JTp0ceULHBK86bpIhKanOsjI=;
        b=uew0Y9Xbf6Zcv9olaHM6FEvTTWFs8oGO4gOmukyuXTkfrC7t2ZKLB4Mc+sqRPk0Iw+
         u9Htc4+uKkioug01XesUB3r3NXbjZwWOHovw4iREoQ37zhAveuVobjW2OLdLhXBW1TGT
         UmCOURCu8GzRMhccOtloqaEizHLEUoa/6moAsB0TdTtT8/t+Ar2hVN1/OADnevvjML8p
         zJBGGtFFgsNPy5MbrkkSO7wcyzR0yTLffJiPX4JCgnhq6FzdpnMaW1tbbBRdQwDNI7R2
         RFX0WM4csEywP6gaCXxd6sWoC/Z5NbN0VlsV+I09JveiGIu+VnNpbU5mku13G4a6xk8D
         pJpw==
X-Forwarded-Encrypted: i=1; AJvYcCUdB0RtflhCo9GG9IK4PcleRB3OEkpmd5sHH7x7Q4vTX4iussX4j/8il7Q6idRhXmCRfLBHztg4hjfdTQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywe2So4JdnndjoOzK4aoLpnQ14OG8J/30l6rKYMGUk6UrP/X0Ch
	jASZQFkTtC1L8Tvl265/UzJD8PXsEthYI9oWqxv0kwNPAe+665CQ9Sr5kTCjXw==
X-Gm-Gg: ASbGncstd0YMVYoozgMN+S/kd/d+lE0dGcNpgDCCixycCBL4gnAAONPgA0XrmMTTfAB
	Z+zs6b4/30wO4Rg9PMuKHd7CuFCT0v/vVrlETWP7SSz4FR5HKAXcZlcY4C1xWuETQslNris7Wda
	9jSUOmhLvC3DZeL5/2NIrAtDIfM3bdVziDZ9T6uDjDV2sgF6RpRaOyQdyzsxSUUo+HrEgtrqMeQ
	be31BSJCtYWkawVtwXyq5EEZG00H4wlrkRuQmkFkKAFDqVga/yN5WSmN8Iav0j+BcHfbcE3RlNJ
	Xhw7KaRiHC7PEWHsiA+sqpHW5+9zqiFQRXiOst8deEU45nyzLIrz3jUG/dDzBzRbGGqjTtes8ZH
	x
X-Google-Smtp-Source: AGHT+IHCVUiFLokvtiYXB1dtfmvpRS0CvWWt48eLG5ozzTOt4+Wf1x/l5tuZe3MRXqZDGA9jBYw9NA==
X-Received: by 2002:a17:906:794e:b0:ae3:4f57:2110 with SMTP id a640c23a62f3a-ae35017b2cfmr334590966b.54.1751036967930;
        Fri, 27 Jun 2025 08:09:27 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.147.145])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae353c014fbsm135802866b.86.2025.06.27.08.09.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jun 2025 08:09:27 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org
Cc: linux-fsdevel@vger.kernel.org,
	Keith Busch <kbusch@kernel.org>,
	David Wei <dw@davidwei.uk>,
	Vishal Verma <vishal1.verma@intel.com>,
	asml.silence@gmail.com
Subject: [RFC 06/12] nvme-pci: add support for user passed dma vectors
Date: Fri, 27 Jun 2025 16:10:33 +0100
Message-ID: <0803e60c420ad80570abd736a1549fffaeb6435d.1751035820.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1751035820.git.asml.silence@gmail.com>
References: <cover.1751035820.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Implement ->get_dma_device blk-mq callback and add BIO_DMAVEC handling.
If the drivers see BIO_DMAVEC, instead of mapping pages, it'll directly
populate the prp list with the provided dma addresses.

Suggested-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 drivers/nvme/host/pci.c | 158 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 158 insertions(+)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 8ff12e415cb5..44a6366f2d9a 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -637,11 +637,59 @@ static void nvme_free_descriptors(struct nvme_queue *nvmeq, struct request *req)
 	}
 }
 
+static void nvme_sync_dma(struct nvme_dev *nvme_dev, struct request *req,
+			  enum dma_data_direction dir)
+{
+	bool for_cpu = dir == DMA_FROM_DEVICE;
+	struct device *dev = nvme_dev->dev;
+	struct bio *bio = req->bio;
+	int offset, length;
+	struct dmavec *dmav;
+
+	if (!dma_dev_need_sync(dev))
+		return;
+
+	offset = bio->bi_iter.bi_bvec_done;
+	length = blk_rq_payload_bytes(req);
+	dmav = &bio->bi_dmavec[bio->bi_iter.bi_idx];
+
+	while (length) {
+		u64 dma_addr = dmav->addr + offset;
+		int dma_len = min(dmav->len - offset, length);
+
+		if (for_cpu)
+			__dma_sync_single_for_cpu(dev, dma_addr, dma_len, dir);
+		else
+			__dma_sync_single_for_device(dev, dma_addr,
+						     dma_len, dir);
+
+		length -= dma_len;
+	}
+}
+
+static void nvme_unmap_premapped_data(struct nvme_dev *dev,
+				      struct nvme_queue *nvmeq,
+				      struct request *req)
+{
+	struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
+
+	if (rq_data_dir(req) == READ)
+		nvme_sync_dma(dev, req, DMA_FROM_DEVICE);
+
+	if (!iod->dma_len)
+		nvme_free_descriptors(nvmeq, req);
+}
+
 static void nvme_unmap_data(struct nvme_dev *dev, struct nvme_queue *nvmeq,
 			    struct request *req)
 {
 	struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
 
+	if (req->bio && bio_flagged(req->bio, BIO_DMAVEC)) {
+		nvme_unmap_premapped_data(dev, nvmeq, req);
+		return;
+	}
+
 	if (iod->dma_len) {
 		dma_unmap_page(dev->dev, iod->first_dma, iod->dma_len,
 			       rq_dma_dir(req));
@@ -846,6 +894,104 @@ static blk_status_t nvme_setup_sgl_simple(struct nvme_dev *dev,
 	return BLK_STS_OK;
 }
 
+static blk_status_t nvme_dma_premapped(struct nvme_dev *dev, struct request *req,
+				   struct nvme_queue *nvmeq,
+				   struct nvme_rw_command *cmnd)
+{
+	struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
+	int length = blk_rq_payload_bytes(req);
+	u64 dma_addr, first_dma_addr;
+	struct bio *bio = req->bio;
+	int dma_len, offset;
+	struct dmavec *dmav;
+	dma_addr_t prp_dma;
+	__le64 *prp_list;
+	int i;
+
+	if (rq_data_dir(req) == WRITE)
+		nvme_sync_dma(dev, req, DMA_TO_DEVICE);
+
+	offset = bio->bi_iter.bi_bvec_done;
+	dmav = &bio->bi_dmavec[bio->bi_iter.bi_idx];
+	dma_addr = dmav->addr + offset;
+	dma_len = dmav->len - offset;
+	first_dma_addr = dma_addr;
+	offset = dma_addr & (NVME_CTRL_PAGE_SIZE - 1);
+
+	length -= (NVME_CTRL_PAGE_SIZE - offset);
+	if (length <= 0) {
+		iod->first_dma = 0;
+		goto done;
+	}
+
+	dma_len -= (NVME_CTRL_PAGE_SIZE - offset);
+	if (dma_len) {
+		dma_addr += (NVME_CTRL_PAGE_SIZE - offset);
+	} else {
+		dmav++;
+		dma_addr = dmav->addr;
+		dma_len = dmav->len;
+	}
+
+	if (length <= NVME_CTRL_PAGE_SIZE) {
+		iod->first_dma = dma_addr;
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
+	iod->first_dma = prp_dma;
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
+		prp_list[i++] = cpu_to_le64(dma_addr);
+		dma_len -= NVME_CTRL_PAGE_SIZE;
+		dma_addr += NVME_CTRL_PAGE_SIZE;
+		length -= NVME_CTRL_PAGE_SIZE;
+		if (length <= 0)
+			break;
+		if (dma_len > 0)
+			continue;
+		if (unlikely(dma_len < 0))
+			goto bad_sgl;
+		dmav++;
+		dma_addr = dmav->addr;
+		dma_len = dmav->len;
+	}
+done:
+	cmnd->dptr.prp1 = cpu_to_le64(first_dma_addr);
+	cmnd->dptr.prp2 = cpu_to_le64(iod->first_dma);
+	return BLK_STS_OK;
+free_prps:
+	nvme_free_descriptors(nvmeq, req);
+	return BLK_STS_RESOURCE;
+bad_sgl:
+	WARN(DO_ONCE(nvme_print_sgl, iod->sgt.sgl, iod->sgt.nents),
+			"Invalid SGL for payload:%d nents:%d\n",
+			blk_rq_payload_bytes(req), iod->sgt.nents);
+	return BLK_STS_IOERR;
+}
+
 static blk_status_t nvme_map_data(struct nvme_dev *dev, struct request *req,
 		struct nvme_command *cmnd)
 {
@@ -854,6 +1000,9 @@ static blk_status_t nvme_map_data(struct nvme_dev *dev, struct request *req,
 	blk_status_t ret = BLK_STS_RESOURCE;
 	int rc;
 
+	if (req->bio && bio_flagged(req->bio, BIO_DMAVEC))
+		return nvme_dma_premapped(dev, req, nvmeq, &cmnd->rw);
+
 	if (blk_rq_nr_phys_segments(req) == 1) {
 		struct bio_vec bv = req_bvec(req);
 
@@ -1874,6 +2023,14 @@ static int nvme_create_queue(struct nvme_queue *nvmeq, int qid, bool polled)
 	return result;
 }
 
+static struct device *nvme_pci_get_dma_device(struct request_queue *q)
+{
+	struct nvme_ns *ns = q->queuedata;
+	struct nvme_dev *dev = to_nvme_dev(ns->ctrl);
+
+	return dev->dev;
+}
+
 static const struct blk_mq_ops nvme_mq_admin_ops = {
 	.queue_rq	= nvme_queue_rq,
 	.complete	= nvme_pci_complete_rq,
@@ -1892,6 +2049,7 @@ static const struct blk_mq_ops nvme_mq_ops = {
 	.map_queues	= nvme_pci_map_queues,
 	.timeout	= nvme_timeout,
 	.poll		= nvme_poll,
+	.get_dma_device = nvme_pci_get_dma_device,
 };
 
 static void nvme_dev_remove_admin(struct nvme_dev *dev)
-- 
2.49.0


