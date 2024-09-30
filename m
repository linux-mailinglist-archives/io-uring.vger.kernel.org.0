Return-Path: <io-uring+bounces-3331-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 42D5098ABF9
	for <lists+io-uring@lfdr.de>; Mon, 30 Sep 2024 20:23:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6752F1C22B28
	for <lists+io-uring@lfdr.de>; Mon, 30 Sep 2024 18:23:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D66BD199930;
	Mon, 30 Sep 2024 18:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="gb8O/I13"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FB911991C8
	for <io-uring@vger.kernel.org>; Mon, 30 Sep 2024 18:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727720463; cv=none; b=te5XVD2P/2Kg0DzvkMkNWqAt1BfBbm5++H/59GoLvaZtoEB/5Eb8MPGnWTFOyT/Sg/bkVFVS3TTM3r35O4DkRcRJT1aOgabhjwFouKuSuqW70vE8roxT4dnyWy8Jz7QiP3kdbCkmWOiXea3JJG6jN+fWM0NPMJIeg0P1mSKUfnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727720463; c=relaxed/simple;
	bh=QXZmtTa54bJ85rbSobh6OJX/HTM7hSX1j/7oqU5Fr7s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=ToeiYDpTY5HWciBuoDVJN24aPCmjPQjREOASaw3Q/+LyA3LZ2Ef0yxmECmwVlc9bazhyfMQZJlNRZ3cjVWEQmI9Dc9gXga5hWyrWiHcUB9aWUmEdLnvHgkxO4FpuJ7X51gPH4AOv6/7n5VcHNn7ItDCS9dfETvHdvLUAcUZG7H4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=gb8O/I13; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20240930182059epoutp019616f033949a7097fc5d5d6d0e63c505~6GJqqEHOV1811418114epoutp01z
	for <io-uring@vger.kernel.org>; Mon, 30 Sep 2024 18:20:59 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20240930182059epoutp019616f033949a7097fc5d5d6d0e63c505~6GJqqEHOV1811418114epoutp01z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1727720459;
	bh=ugKqO1XFUpHgwZ5i6JKfBEHH4QrChnfUh9oyqrxgCrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gb8O/I13LoswAsGyFwezFrs0QmXfhr+RhEjfaBXhgieY6/5Q5SmndXjA4hsmy9FMt
	 YDbGux7mxBJ8b39NGeG4zBYdg+auFVI4Nq8R9L5ocnTH/EZRTfluWtrZ2oTr1+UbpG
	 G27vibpAvcIaBQXcuaR5hY2jPwSPD5k06rfbB960=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20240930182058epcas5p21a572a75fb889e9dfd9f1f6e7bca40e6~6GJp_rk232779327793epcas5p2c;
	Mon, 30 Sep 2024 18:20:58 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.175]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4XHTsP1RKlz4x9Pt; Mon, 30 Sep
	2024 18:20:57 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	CD.88.08574.90CEAF66; Tue,  1 Oct 2024 03:20:57 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20240930182056epcas5p33f823c00caadf9388b509bafcad86f3d~6GJnznHct2353623536epcas5p33;
	Mon, 30 Sep 2024 18:20:56 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240930182056epsmtrp1b5da6756e02254e023ec676f183c2fbc~6GJnyjqDR1255412554epsmtrp1T;
	Mon, 30 Sep 2024 18:20:56 +0000 (GMT)
X-AuditID: b6c32a44-93ffa7000000217e-dc-66faec098f95
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	2E.F8.08227.80CEAF66; Tue,  1 Oct 2024 03:20:56 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20240930182052epsmtip24ca5d5c423d8b7db912adba64a332aac~6GJkeXXT42505325053epsmtip2L;
	Mon, 30 Sep 2024 18:20:52 +0000 (GMT)
From: Kanchan Joshi <joshi.k@samsung.com>
To: axboe@kernel.dk, kbusch@kernel.org, hch@lst.de, hare@suse.de,
	sagi@grimberg.me, martin.petersen@oracle.com, brauner@kernel.org,
	viro@zeniv.linux.org.uk, jack@suse.cz, jaegeuk@kernel.org, bcrl@kvack.org,
	dhowells@redhat.com, bvanassche@acm.org, asml.silence@gmail.com
Cc: linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org, linux-block@vger.kernel.org, linux-aio@kvack.org,
	gost.dev@samsung.com, vishak.g@samsung.com, javier.gonz@samsung.com, Kanchan
	Joshi <joshi.k@samsung.com>, Hui Qi <hui81.qi@samsung.com>, Nitesh Shetty
	<nj.shetty@samsung.com>
Subject: [PATCH v7 1/3] nvme: enable FDP support
Date: Mon, 30 Sep 2024 23:43:03 +0530
Message-Id: <20240930181305.17286-2-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240930181305.17286-1-joshi.k@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01Ta0xTZxjOd85pTwvB1QLjg0RljYyAA+mA8mEER2R6IouQ8GMbc2MdHAsC
	bdcW3NySMTvuA5UijALhMoRRcLCKCCJzlpHiHJdwRy5BuQxEkMumMgas5eDmv+f53ud5b19e
	Ds5PJx040VIVrZCKYwVsC6Kh1cXZjfv479MeMz+wUKGuAaDqsQtslL5ZT6D51hWAcpfWcLR4
	fp1Aw780YehWWTaGqqrbMNRUcZVEi0mdBCrIU2NoqlaLo8nRVRK1bS2wUbZhAKCc3PMAtdw/
	gG613CVQccU0iSqNmxhqWC/G0Y/zTwjUtWFkoS5tIfmWPdXbF0Q1acdIqmv8J4Lq7Yin9Lo0
	NqVfySapa+VfUc3DiWxqefo+QT35uZ9NZdXrAPV7ya+m4L0vqFX9Xko/tYCFvBIWcziKFkfS
	CkdaGiGLjJZK/ARBoeFHw71FHkI3oS/yEThKxXG0nyDwnRC3Y9Gxpm0IHBPEsfGmpxCxUik4
	6H9YIYtX0Y5RMqXKT0DLI2PlXnJ3pThOGS+VuEtp1SGhh8eb3ibhxzFRFe01mFzj+VlR4Sgr
	ETS7pAMuB/K8oEG/hKUDCw6f1wxge30DmyErAI6WLu+QpwCW/3ab/cJSVH4ZZwItAOY/XmYx
	ZNVkSSsE6YDDYfNcYLcm3vxuw8vB4HC1jjATnNeGwdTnQ9uprHke0FDwNTBjgucES+6M4mZs
	xUMwryIDY8rtg/k9z0gz5vJ8oaY3dUezG97NnyLMGDdp1NcLtluCvFou7KvrIc1dQF4grPwm
	mMljDR8Z60kGO8C5C8k7OAZOPJwgGPwlbLyWxWLwEZj4zxDLnAY3DVN78yBTahfMXJ/CmOxW
	MDWZz6hfg+PZ0ztOO/jgu3IWI6HgvaehzHq+BfDKXy3gItinfWkA7UsDaP8vVgJwHbCn5co4
	CR3hLRdK6bP/fWyELE4Pto/CNbARDBVvuhsAxgEGADm4wMZq3LB2mm8VKf78HK2QhSviY2ml
	AXibNnwJd7CNkJmuSqoKF3r5eniJRCIvX0+RUGBnNZ9UFMnnScQqOoam5bTihQ/jcB0SMcEN
	dWm3Wk9qZD1+/hLSribJKePTgY/K47bu2Mx65or8LSz7Nm68bVmZ1L88k8dHCR1Hgrw/qJi8
	7DS5/CBgLWfemLa2mvLMIsH+krH1uv8ui5GUT2KpTPexjvaeTO1KvqR//HtUdcL4qImbtN/V
	2GG9+EZplSz4UPdVdcCHk6c2RkQz1a8uL+13NmaFj2hm58oG/9QdfX2gOfR4XxZQGzIb0yer
	TpbNlWpn93YX3Q6uf9d7wadm0OEP32LN7JmCAM6xZAF368SE7bnOPWmnOlLszzSiwYvzdSd9
	+i0vhO7pLK2Ls3sv7ID/wzFYeWX9rNdN1CAN65973kJmOO9WvG8bJCCUUWKhK65Qiv8FFU3g
	fJ0EAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA02RfyyUcRzH932ex/M8bjOPk/meUuu2fgnpl3016ZfqWfVHf5XVmi4eunLu
	duekQiLDtVSUcs7cDNWV1OFk1HIlSXES0Y4tTs0uPy79cJVTTm399/7s9f7xx4fG+e2EDy2O
	T+Dk8aI4IckjDE+EiwLoTz9igoY7vZBGZwDodv9FEqkcNQSyPvkMUMGEHUdj6T8J1Pe4HkON
	pXkYunW7GUP1FZUUGstsJ1DRtQwMWarUOBoyT1KoeWaURHnGHoCuFKQD9PDdStT4sJVAJRXD
	FLrR4sCQ4WcJju5axwnUMd3igjrUGmqzgO16s5utV/dTbMfAfYLteqVk9bocktV/zqPY6rIz
	bENfGsnaht8R7PijbpLNrdEB9qX26R/Ydpqd1C9k9ZZRbK/7AV5oNBcnTuTkq8IO845WPL+D
	yfLXJhVrzC5poGGFCrjSkFkHi8uu4irAo/lMA4CmystgDnjDjJ4pak57wluOj07NZ2wA3rQI
	VICmSWYFNOUrZ7PzmJsYNFimidkDZzoxOJPzhZgNeDJB0Fh01llKMEugtsmMz2o3BsFrFeex
	uYFFsPD1d+eAKxMC87uy8bkxBM1TWX/9HrC10OLsxP/4M2qL8EuAUf+H1P8hLcB0QMDJFJJY
	iWK1bE08dyJQIZIolPGxgVFSiR44X+7n9wA06iYCjQCjgRFAGhfOcxsw2mP4btGik6c4uTRS
	rozjFEYwnyaE3m7frBei+UysKIE7znEyTv6PYrSrTxq20edMqriXKxdm7herA2JGpqis3Kxd
	Xh5bOnPFe5I6wuxILti7CW/LaKmRTha4hy53X5/Ns2p7l5S6LO9rX3ck5eBQuWH718Ha95kn
	wyZfNAUN1y0zSMnCc4XBd3oSiweGjh0UrG+v+qH+cAH3/TBtWpqki4ycHnl72VdpspJDdpTs
	+FW6Mz88yFdaO2pO2RbcHbHU9H1BaP9i3ZcDqVesO7pKYiZWpWyty3XZ5xHy2P9Zr6altlp1
	XSeNNNrnO+7FVb4WN01s6N5CWZIvRQV7RKT02gRJAebicLkmxPbW/1VVk8wmiX7p6XMo29rc
	kKYtSkgI+LYxMD19sHQmOYIvJBRHRav9cLlC9BvzoyWIYQMAAA==
X-CMS-MailID: 20240930182056epcas5p33f823c00caadf9388b509bafcad86f3d
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240930182056epcas5p33f823c00caadf9388b509bafcad86f3d
References: <20240930181305.17286-1-joshi.k@samsung.com>
	<CGME20240930182056epcas5p33f823c00caadf9388b509bafcad86f3d@epcas5p3.samsung.com>

Flexible Data Placement (FDP), as ratified in TP 4146a, allows the host
to control the placement of logical blocks so as to reduce the SSD WAF.

Userspace can send the data lifetime information using the write hints.
The SCSI driver (sd) can already pass this information to the SCSI
devices. This patch does the same for NVMe.

Fetch the placement-identifiers if the device supports FDP.
The incoming write-hint is mapped to a placement-identifier, which in
turn is set in the DSPEC field of the write command.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Hui Qi <hui81.qi@samsung.com>
Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
Nacked-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/nvme/host/core.c | 70 ++++++++++++++++++++++++++++++++++++++++
 drivers/nvme/host/nvme.h |  4 +++
 include/linux/nvme.h     | 19 +++++++++++
 3 files changed, 93 insertions(+)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index ba6508455e18..ad5cc1ec8c4f 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -44,6 +44,20 @@ struct nvme_ns_info {
 	bool is_removed;
 };
 
+struct nvme_fdp_ruh_status_desc {
+	u16 pid;
+	u16 ruhid;
+	u32 earutr;
+	u64 ruamw;
+	u8  rsvd16[16];
+};
+
+struct nvme_fdp_ruh_status {
+	u8  rsvd0[14];
+	__le16 nruhsd;
+	struct nvme_fdp_ruh_status_desc ruhsd[];
+};
+
 unsigned int admin_timeout = 60;
 module_param(admin_timeout, uint, 0644);
 MODULE_PARM_DESC(admin_timeout, "timeout in seconds for admin commands");
@@ -959,6 +973,19 @@ static bool nvme_valid_atomic_write(struct request *req)
 	return true;
 }
 
+static inline void nvme_assign_placement_id(struct nvme_ns *ns,
+					struct request *req,
+					struct nvme_command *cmd)
+{
+	enum rw_hint h = req->write_hint;
+
+	if (h >= ns->head->nr_plids)
+		return;
+
+	cmd->rw.control |= cpu_to_le16(NVME_RW_DTYPE_DPLCMT);
+	cmd->rw.dsmgmt |= cpu_to_le32(ns->head->plids[h] << 16);
+}
+
 static inline blk_status_t nvme_setup_rw(struct nvme_ns *ns,
 		struct request *req, struct nvme_command *cmnd,
 		enum nvme_opcode op)
@@ -1078,6 +1105,8 @@ blk_status_t nvme_setup_cmd(struct nvme_ns *ns, struct request *req)
 		break;
 	case REQ_OP_WRITE:
 		ret = nvme_setup_rw(ns, req, cmd, nvme_cmd_write);
+		if (!ret && ns->head->nr_plids)
+			nvme_assign_placement_id(ns, req, cmd);
 		break;
 	case REQ_OP_ZONE_APPEND:
 		ret = nvme_setup_rw(ns, req, cmd, nvme_cmd_zone_append);
@@ -2114,6 +2143,40 @@ static int nvme_update_ns_info_generic(struct nvme_ns *ns,
 	return ret;
 }
 
+static int nvme_fetch_fdp_plids(struct nvme_ns *ns, u32 nsid)
+{
+	struct nvme_command c = {};
+	struct nvme_fdp_ruh_status *ruhs;
+	struct nvme_fdp_ruh_status_desc *ruhsd;
+	int size, ret, i;
+
+	size = struct_size(ruhs, ruhsd, NVME_MAX_PLIDS);
+	ruhs = kzalloc(size, GFP_KERNEL);
+	if (!ruhs)
+		return -ENOMEM;
+
+	c.imr.opcode = nvme_cmd_io_mgmt_recv;
+	c.imr.nsid = cpu_to_le32(nsid);
+	c.imr.mo = 0x1;
+	c.imr.numd =  cpu_to_le32((size >> 2) - 1);
+
+	ret = nvme_submit_sync_cmd(ns->queue, &c, ruhs, size);
+	if (ret)
+		goto out;
+
+	ns->head->nr_plids = le16_to_cpu(ruhs->nruhsd);
+	ns->head->nr_plids =
+		min_t(u16, ns->head->nr_plids, NVME_MAX_PLIDS);
+
+	for (i = 0; i < ns->head->nr_plids; i++) {
+		ruhsd = &ruhs->ruhsd[i];
+		ns->head->plids[i] = le16_to_cpu(ruhsd->pid);
+	}
+out:
+	kfree(ruhs);
+	return ret;
+}
+
 static int nvme_update_ns_info_block(struct nvme_ns *ns,
 		struct nvme_ns_info *info)
 {
@@ -2205,6 +2268,13 @@ static int nvme_update_ns_info_block(struct nvme_ns *ns,
 		if (ret && !nvme_first_scan(ns->disk))
 			goto out;
 	}
+	if (ns->ctrl->ctratt & NVME_CTRL_ATTR_FDPS) {
+		ret = nvme_fetch_fdp_plids(ns, info->nsid);
+		if (ret)
+			dev_warn(ns->ctrl->device,
+				"FDP failure status:0x%x\n", ret);
+	}
+
 
 	ret = 0;
 out:
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 313a4f978a2c..a959a9859e8b 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -454,6 +454,8 @@ struct nvme_ns_ids {
 	u8	csi;
 };
 
+#define NVME_MAX_PLIDS   (WRITE_LIFE_EXTREME + 1)
+
 /*
  * Anchor structure for namespaces.  There is one for each namespace in a
  * NVMe subsystem that any of our controllers can see, and the namespace
@@ -490,6 +492,8 @@ struct nvme_ns_head {
 	struct device		cdev_device;
 
 	struct gendisk		*disk;
+	u16			nr_plids;
+	u16			plids[NVME_MAX_PLIDS];
 #ifdef CONFIG_NVME_MULTIPATH
 	struct bio_list		requeue_list;
 	spinlock_t		requeue_lock;
diff --git a/include/linux/nvme.h b/include/linux/nvme.h
index b58d9405d65e..a954eaee5b0f 100644
--- a/include/linux/nvme.h
+++ b/include/linux/nvme.h
@@ -275,6 +275,7 @@ enum nvme_ctrl_attr {
 	NVME_CTRL_ATTR_HID_128_BIT	= (1 << 0),
 	NVME_CTRL_ATTR_TBKAS		= (1 << 6),
 	NVME_CTRL_ATTR_ELBAS		= (1 << 15),
+	NVME_CTRL_ATTR_FDPS		= (1 << 19),
 };
 
 struct nvme_id_ctrl {
@@ -843,6 +844,7 @@ enum nvme_opcode {
 	nvme_cmd_resv_register	= 0x0d,
 	nvme_cmd_resv_report	= 0x0e,
 	nvme_cmd_resv_acquire	= 0x11,
+	nvme_cmd_io_mgmt_recv	= 0x12,
 	nvme_cmd_resv_release	= 0x15,
 	nvme_cmd_zone_mgmt_send	= 0x79,
 	nvme_cmd_zone_mgmt_recv	= 0x7a,
@@ -864,6 +866,7 @@ enum nvme_opcode {
 		nvme_opcode_name(nvme_cmd_resv_register),	\
 		nvme_opcode_name(nvme_cmd_resv_report),		\
 		nvme_opcode_name(nvme_cmd_resv_acquire),	\
+		nvme_opcode_name(nvme_cmd_io_mgmt_recv),	\
 		nvme_opcode_name(nvme_cmd_resv_release),	\
 		nvme_opcode_name(nvme_cmd_zone_mgmt_send),	\
 		nvme_opcode_name(nvme_cmd_zone_mgmt_recv),	\
@@ -1015,6 +1018,7 @@ enum {
 	NVME_RW_PRINFO_PRCHK_GUARD	= 1 << 12,
 	NVME_RW_PRINFO_PRACT		= 1 << 13,
 	NVME_RW_DTYPE_STREAMS		= 1 << 4,
+	NVME_RW_DTYPE_DPLCMT		= 2 << 4,
 	NVME_WZ_DEAC			= 1 << 9,
 };
 
@@ -1102,6 +1106,20 @@ struct nvme_zone_mgmt_recv_cmd {
 	__le32			cdw14[2];
 };
 
+struct nvme_io_mgmt_recv_cmd {
+	__u8			opcode;
+	__u8			flags;
+	__u16			command_id;
+	__le32			nsid;
+	__le64			rsvd2[2];
+	union nvme_data_ptr	dptr;
+	__u8			mo;
+	__u8			rsvd11;
+	__u16			mos;
+	__le32			numd;
+	__le32			cdw12[4];
+};
+
 enum {
 	NVME_ZRA_ZONE_REPORT		= 0,
 	NVME_ZRASF_ZONE_REPORT_ALL	= 0,
@@ -1822,6 +1840,7 @@ struct nvme_command {
 		struct nvmf_auth_receive_command auth_receive;
 		struct nvme_dbbuf dbbuf;
 		struct nvme_directive_cmd directive;
+		struct nvme_io_mgmt_recv_cmd imr;
 	};
 };
 
-- 
2.25.1


