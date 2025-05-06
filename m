Return-Path: <io-uring+bounces-7855-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6653EAAC422
	for <lists+io-uring@lfdr.de>; Tue,  6 May 2025 14:31:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B982B16A632
	for <lists+io-uring@lfdr.de>; Tue,  6 May 2025 12:31:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CA4728152D;
	Tue,  6 May 2025 12:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="i7zVDeJO"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 828572820B1
	for <io-uring@vger.kernel.org>; Tue,  6 May 2025 12:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746534420; cv=none; b=c6f/4G6qDtyzBIMj5sXdJVamHfKTuueHXHiXjgYHnveR+UJ64nYvtkhfYfd+4fxUmO+tdiIrfYCpWLU9dcOhVFGQ8XK+tuq2G/Tq2dOKpZ4xgvjTtKa3JD+Ry30Ouk3xNVEjWPTJZMcABVhTf6lFfDvWWcVhFlOGRSfxO/e0boM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746534420; c=relaxed/simple;
	bh=vewPJdjU5s+o8yNwQfLBuulyfx4f2o/6rqBiNVLsMHA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=TIMB8Rm6c+qsWGic4N24P9BFKqc4Ruuh8s2DkxRK2hYESTVDuvkPluaQJJusD7oF8XL6hcg2ihSr151gTfrF6M7hu/CEqqFowGFpfUuKBFEUYX6x5WeyblxqoSbz1EYYUhyhJfynd1xwUQuO3QTJXxV1KzPoV6gpuWUTeUf9iik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=i7zVDeJO; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20250506122656epoutp040f2b32e03ce39ab5cdf7cd1c2ec2e6dd~878xX-NeL1132311323epoutp04-
	for <io-uring@vger.kernel.org>; Tue,  6 May 2025 12:26:56 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20250506122656epoutp040f2b32e03ce39ab5cdf7cd1c2ec2e6dd~878xX-NeL1132311323epoutp04-
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1746534416;
	bh=eC+BYkDaXIs3TFD20c2Zh9U2uEjdhsHiGkyPiK1m93w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i7zVDeJOJn3NFzVtxmeT9zKw80p+eYDSfpFg+5UppXxEpYxKaLWkrnOpyagZThSpf
	 B21Nq/OYYcf82U7+DIiTHCj4KkmcNmqPHSS1tn5sZiS0ZsWxRew834OIdo16v0mywa
	 VDZ7furAUwSW46gKDr0J0Nync88An62YZp+4WpMU=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20250506122654epcas5p41350f5e4ce3dede56b0b5cb47b1a7a0f~878wB_B331362913629epcas5p4L;
	Tue,  6 May 2025 12:26:54 +0000 (GMT)
Received: from epcas5p2.samsung.com (unknown [182.195.38.183]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4ZsHhD0XJ2z6B9m5; Tue,  6 May
	2025 12:26:52 +0000 (GMT)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20250506122651epcas5p4100fd5435ce6e6686318265b414c1176~878syGeBg0663906639epcas5p4-;
	Tue,  6 May 2025 12:26:51 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20250506122651epsmtrp105f718a54995a878ab6c6bf67204f459~878sxcWTT2592625926epsmtrp1F;
	Tue,  6 May 2025 12:26:51 +0000 (GMT)
X-AuditID: b6c32a28-460ee70000001e8a-f8-681a000bd010
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	C0.F5.07818.B000A186; Tue,  6 May 2025 21:26:51 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250506122649epsmtip2de630352965f80d9bf79e25c30b36e7d~878rLmFH-1704417044epsmtip2W;
	Tue,  6 May 2025 12:26:49 +0000 (GMT)
From: Kanchan Joshi <joshi.k@samsung.com>
To: axboe@kernel.dk, kbusch@kernel.org, hch@lst.de, asml.silence@gmail.com
Cc: io-uring@vger.kernel.org, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-nvme@lists.infradead.org, Hannes
	Reinecke <hare@suse.de>, Nitesh Shetty <nj.shetty@samsung.com>, Kanchan
	Joshi <joshi.k@samsung.com>
Subject: [PATCH v16 10/11] nvme: register fdp parameters with the block
 layer
Date: Tue,  6 May 2025 17:47:31 +0530
Message-Id: <20250506121732.8211-11-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250506121732.8211-1-joshi.k@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGLMWRmVeSWpSXmKPExsWy7bCSvC43g1SGweed4hZzVm1jtFh9t5/N
	Ys+iSUwWK1cfZbJ413qOxeLo/7dsFpMOXWO02HtL22LP3pMsFvOXPWW32PZ7PrMDt8fOWXfZ
	PS6fLfXYtKqTzWPzknqP3Tcb2Dz6tqxi9Nh8utrj8ya5AI4oLpuU1JzMstQifbsErox5T74z
	Fhwzqdh2ZidrA+MxrS5GTg4JAROJz1d7GbsYuTiEBHYzSuz+uYEVIiEu0XztBzuELSyx8t9z
	doiij4wS32e8Z+li5OBgE9CUuDC5FKRGRCBA4uXix8wgNcwCHxgl9kyczQiSEBbwlTh45wcb
	iM0ioCpx+VcHC4jNK2AhsWRPP9QCeYmZl76D2ZxA8eV7ZoH1CgmYS7w4eoQdol5Q4uTMJ2C9
	zED1zVtnM09gFJiFJDULSWoBI9MqRsnUguLc9NxkwwLDvNRyveLE3OLSvHS95PzcTYzgqNDS
	2MH47luT/iFGJg7GQ4wSHMxKIrz370tmCPGmJFZWpRblxxeV5qQWH2KU5mBREuddaRiRLiSQ
	nliSmp2aWpBaBJNl4uCUamDSMXGcGfA0QmSpv9ji4hPPxWYsUX+x+axvNs+Fw6vfFXkGMOls
	i3wo9FndSSpL1MP0oFXp87I7XTMuLO4NmO7HEiv/wddJsWKbdO5x74j3r2QSHwmti49LO6Lq
	nsnpsljHuCFjb/+cPWxqJikbbp3w3azeMM1sUbVB7KJUq8SCxRoT7nUYnmK+mHRbPdhy0QO7
	tuJTx2euO1T7hufqNIdnbJv8FhmFmHwsPn443OT/8sVZp9uMFjnMmHPk3rr5jhPS/z+evmPd
	yvmnG1aEXWJ4Z7z0Xs0Zuabe9D+MiaflBdwLwzor2Y5bzxU5E/Xm9Uk228bTTBribc6beDZN
	PWv4QOKqllHlcbF3UzOfZ5UpsRRnJBpqMRcVJwIA1IsSHfkCAAA=
X-CMS-MailID: 20250506122651epcas5p4100fd5435ce6e6686318265b414c1176
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250506122651epcas5p4100fd5435ce6e6686318265b414c1176
References: <20250506121732.8211-1-joshi.k@samsung.com>
	<CGME20250506122651epcas5p4100fd5435ce6e6686318265b414c1176@epcas5p4.samsung.com>

From: Keith Busch <kbusch@kernel.org>

Register the device data placement limits if supported. This is just
registering the limits with the block layer. Nothing beyond reporting
these attributes is happening in this patch.

Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Nitesh Shetty <nj.shetty@samsung.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 drivers/nvme/host/core.c | 144 +++++++++++++++++++++++++++++++++++++++
 drivers/nvme/host/nvme.h |   2 +
 2 files changed, 146 insertions(+)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index dd71b4c2b7b7..f25e03ff03df 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -38,6 +38,8 @@ struct nvme_ns_info {
 	u32 nsid;
 	__le32 anagrpid;
 	u8 pi_offset;
+	u16 endgid;
+	u64 runs;
 	bool is_shared;
 	bool is_readonly;
 	bool is_ready;
@@ -1611,6 +1613,7 @@ static int nvme_ns_info_from_identify(struct nvme_ctrl *ctrl,
 	info->is_shared = id->nmic & NVME_NS_NMIC_SHARED;
 	info->is_readonly = id->nsattr & NVME_NS_ATTR_RO;
 	info->is_ready = true;
+	info->endgid = le16_to_cpu(id->endgid);
 	if (ctrl->quirks & NVME_QUIRK_BOGUS_NID) {
 		dev_info(ctrl->device,
 			 "Ignoring bogus Namespace Identifiers\n");
@@ -1651,6 +1654,7 @@ static int nvme_ns_info_from_id_cs_indep(struct nvme_ctrl *ctrl,
 		info->is_ready = id->nstat & NVME_NSTAT_NRDY;
 		info->is_rotational = id->nsfeat & NVME_NS_ROTATIONAL;
 		info->no_vwc = id->nsfeat & NVME_NS_VWC_NOT_PRESENT;
+		info->endgid = le16_to_cpu(id->endgid);
 	}
 	kfree(id);
 	return ret;
@@ -2155,6 +2159,132 @@ static int nvme_update_ns_info_generic(struct nvme_ns *ns,
 	return ret;
 }
 
+static int nvme_query_fdp_granularity(struct nvme_ctrl *ctrl,
+				      struct nvme_ns_info *info, u8 fdp_idx)
+{
+	struct nvme_fdp_config_log hdr, *h;
+	struct nvme_fdp_config_desc *desc;
+	size_t size = sizeof(hdr);
+	void *log, *end;
+	int i, n, ret;
+
+	ret = nvme_get_log_lsi(ctrl, 0, NVME_LOG_FDP_CONFIGS, 0,
+			       NVME_CSI_NVM, &hdr, size, 0, info->endgid);
+	if (ret) {
+		dev_warn(ctrl->device,
+			 "FDP configs log header status:0x%x endgid:%d\n", ret,
+			 info->endgid);
+		return ret;
+	}
+
+	size = le32_to_cpu(hdr.sze);
+	if (size > PAGE_SIZE * MAX_ORDER_NR_PAGES) {
+		dev_warn(ctrl->device, "FDP config size too large:%zu\n",
+			 size);
+		return 0;
+	}
+
+	h = kvmalloc(size, GFP_KERNEL);
+	if (!h)
+		return -ENOMEM;
+
+	ret = nvme_get_log_lsi(ctrl, 0, NVME_LOG_FDP_CONFIGS, 0,
+			       NVME_CSI_NVM, h, size, 0, info->endgid);
+	if (ret) {
+		dev_warn(ctrl->device,
+			 "FDP configs log status:0x%x endgid:%d\n", ret,
+			 info->endgid);
+		goto out;
+	}
+
+	n = le16_to_cpu(h->numfdpc) + 1;
+	if (fdp_idx > n) {
+		dev_warn(ctrl->device, "FDP index:%d out of range:%d\n",
+			 fdp_idx, n);
+		/* Proceed without registering FDP streams */
+		ret = 0;
+		goto out;
+	}
+
+	log = h + 1;
+	desc = log;
+	end = log + size - sizeof(*h);
+	for (i = 0; i < fdp_idx; i++) {
+		log += le16_to_cpu(desc->dsze);
+		desc = log;
+		if (log >= end) {
+			dev_warn(ctrl->device,
+				 "FDP invalid config descriptor list\n");
+			ret = 0;
+			goto out;
+		}
+	}
+
+	if (le32_to_cpu(desc->nrg) > 1) {
+		dev_warn(ctrl->device, "FDP NRG > 1 not supported\n");
+		ret = 0;
+		goto out;
+	}
+
+	info->runs = le64_to_cpu(desc->runs);
+out:
+	kvfree(h);
+	return ret;
+}
+
+static int nvme_query_fdp_info(struct nvme_ns *ns, struct nvme_ns_info *info)
+{
+	struct nvme_ns_head *head = ns->head;
+	struct nvme_ctrl *ctrl = ns->ctrl;
+	struct nvme_fdp_ruh_status *ruhs;
+	struct nvme_fdp_config fdp;
+	struct nvme_command c = {};
+	size_t size;
+	int ret;
+
+	/*
+	 * The FDP configuration is static for the lifetime of the namespace,
+	 * so return immediately if we've already registered this namespace's
+	 * streams.
+	 */
+	if (head->nr_plids)
+		return 0;
+
+	ret = nvme_get_features(ctrl, NVME_FEAT_FDP, info->endgid, NULL, 0,
+				&fdp);
+	if (ret) {
+		dev_warn(ctrl->device, "FDP get feature status:0x%x\n", ret);
+		return ret;
+	}
+
+	if (!(fdp.flags & FDPCFG_FDPE))
+		return 0;
+
+	ret = nvme_query_fdp_granularity(ctrl, info, fdp.fdpcidx);
+	if (!info->runs)
+		return ret;
+
+	size = struct_size(ruhs, ruhsd, S8_MAX - 1);
+	ruhs = kzalloc(size, GFP_KERNEL);
+	if (!ruhs)
+		return -ENOMEM;
+
+	c.imr.opcode = nvme_cmd_io_mgmt_recv;
+	c.imr.nsid = cpu_to_le32(head->ns_id);
+	c.imr.mo = NVME_IO_MGMT_RECV_MO_RUHS;
+	c.imr.numd = cpu_to_le32(nvme_bytes_to_numd(size));
+	ret = nvme_submit_sync_cmd(ns->queue, &c, ruhs, size);
+	if (ret) {
+		dev_warn(ctrl->device, "FDP io-mgmt status:0x%x\n", ret);
+		goto free;
+	}
+
+	head->nr_plids = le16_to_cpu(ruhs->nruhsd);
+free:
+	kfree(ruhs);
+	return ret;
+}
+
 static int nvme_update_ns_info_block(struct nvme_ns *ns,
 		struct nvme_ns_info *info)
 {
@@ -2192,6 +2322,12 @@ static int nvme_update_ns_info_block(struct nvme_ns *ns,
 			goto out;
 	}
 
+	if (ns->ctrl->ctratt & NVME_CTRL_ATTR_FDPS) {
+		ret = nvme_query_fdp_info(ns, info);
+		if (ret < 0)
+			goto out;
+	}
+
 	lim = queue_limits_start_update(ns->disk->queue);
 
 	memflags = blk_mq_freeze_queue(ns->disk->queue);
@@ -2225,6 +2361,12 @@ static int nvme_update_ns_info_block(struct nvme_ns *ns,
 	if (!nvme_init_integrity(ns->head, &lim, info))
 		capacity = 0;
 
+	lim.max_write_streams = ns->head->nr_plids;
+	if (lim.max_write_streams)
+		lim.write_stream_granularity = max(info->runs, U32_MAX);
+	else
+		lim.write_stream_granularity = 0;
+
 	ret = queue_limits_commit_update(ns->disk->queue, &lim);
 	if (ret) {
 		blk_mq_unfreeze_queue(ns->disk->queue, memflags);
@@ -2328,6 +2470,8 @@ static int nvme_update_ns_info(struct nvme_ns *ns, struct nvme_ns_info *info)
 			ns->head->disk->flags |= GENHD_FL_HIDDEN;
 		else
 			nvme_init_integrity(ns->head, &lim, info);
+		lim.max_write_streams = ns_lim->max_write_streams;
+		lim.write_stream_granularity = ns_lim->write_stream_granularity;
 		ret = queue_limits_commit_update(ns->head->disk->queue, &lim);
 
 		set_capacity_and_notify(ns->head->disk, get_capacity(ns->disk));
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index aedb734283b8..3e14daa4ed3e 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -496,6 +496,8 @@ struct nvme_ns_head {
 	struct device		cdev_device;
 
 	struct gendisk		*disk;
+
+	u16			nr_plids;
 #ifdef CONFIG_NVME_MULTIPATH
 	struct bio_list		requeue_list;
 	spinlock_t		requeue_lock;
-- 
2.25.1


