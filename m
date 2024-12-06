Return-Path: <io-uring+bounces-5280-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E86E99E7BAD
	for <lists+io-uring@lfdr.de>; Fri,  6 Dec 2024 23:24:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A33F4283F64
	for <lists+io-uring@lfdr.de>; Fri,  6 Dec 2024 22:24:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E9291AAA0C;
	Fri,  6 Dec 2024 22:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="mFr6+LmW"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C23D71F4706
	for <io-uring@vger.kernel.org>; Fri,  6 Dec 2024 22:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733523852; cv=none; b=TD+45R307dKV5KBeIASOE9rEmjCFPkW63r2Ge7XivUyeKCdOWRh14iV2IJMi+4drgTS6VMxK3nIdBkhbPHnIGphe9h7mRZGry6QbkY926u0pUfsO5U8aKqszAMZj4+HIhcx6Crc+uYGKShgYjD9/9iwwFw0kgt7nIc9/snkjbl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733523852; c=relaxed/simple;
	bh=JsMzda1dvXfpyghJIWfKFzT7koDgfcrNk8Dhgd6Jr9Y=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eRzHOZOuAEU6KkiwVfhI3ThIO5CI7IVd361rKgWeFoTt2q4gyUaeMqCM08GHI/pgTiCfpeb65tO44wwVh1usUHbPWF3I4q2B9jcYoORNIrJ1EsWiaJxSY0It7CEDZgVE1UVoMy9Mp9VE+NYv7RirfUrZd3Kv0mCl8Ed7Lu8ZwsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=mFr6+LmW; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4B6Lh9qK030333
	for <io-uring@vger.kernel.org>; Fri, 6 Dec 2024 14:24:10 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2021-q4;
	 bh=MJQ0doaTU1YUYAXmnq5fwawovv+/QcSek5SvLrqvpew=; b=mFr6+LmWur0R
	NzPpRIRb6w4hXHUIaEybf4/II40R7VSH0TmYOJu2pQeOC0WShV8Klt/yiDgTz6zH
	NjLZFz19TMtwRkjdcaySQE7YyLOD4U6WrnZm7aaYwieFGG46KW7mIl9RiKhKpTvt
	UYvRFqLg3Ov2PiJbLCqWtJAnjsyhEneNEZUIE9Ji9Fk9b0uvQyNBNJmDbzjWmv/b
	6FUOU0uZKX27pCne0V99e5u5ISQy+/vHjZ/f3o2lzcLxAk34rGdgl4LfAPRB1PC3
	gILNTM7eLbYKZhyPWU/Jz5uaUp143rJK92Nj5W8BnyOBd462YyUMr3qiHKZYSVGW
	z2/0wGakyA==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 43c592taq2-13
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Fri, 06 Dec 2024 14:24:09 -0800 (PST)
Received: from twshared3076.40.frc1.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c08b:78::c78f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.11; Fri, 6 Dec 2024 22:24:03 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id 71FC015B8CB92; Fri,  6 Dec 2024 14:18:27 -0800 (PST)
From: Keith Busch <kbusch@meta.com>
To: <axboe@kernel.dk>, <hch@lst.de>, <linux-block@vger.kernel.org>,
        <linux-nvme@lists.infradead.org>, <linux-fsdevel@vger.kernel.org>,
        <io-uring@vger.kernel.org>
CC: <sagi@grimberg.me>, <asml.silence@gmail.com>, <anuj20.g@samsung.com>,
        <joshi.k@samsung.com>, Keith Busch <kbusch@kernel.org>
Subject: [PATCHv12 11/12] nvme: register fdp parameters with the block layer
Date: Fri, 6 Dec 2024 14:18:00 -0800
Message-ID: <20241206221801.790690-12-kbusch@meta.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241206221801.790690-1-kbusch@meta.com>
References: <20241206221801.790690-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: w83W2D6J9RwttIUqzGtnNwy_2FHh7_2V
X-Proofpoint-ORIG-GUID: w83W2D6J9RwttIUqzGtnNwy_2FHh7_2V
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-05_03,2024-10-04_01,2024-09-30_01

From: Keith Busch <kbusch@kernel.org>

Register the device data placement limits if supported. This is just
registering the limits with the block layer. Nothing beyond reporting
these attributes is happening in this patch.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 drivers/nvme/host/core.c | 112 +++++++++++++++++++++++++++++++++++++++
 drivers/nvme/host/nvme.h |   4 ++
 2 files changed, 116 insertions(+)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index c2a3585a3fa59..5f802e243736a 100644
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
@@ -1613,6 +1615,7 @@ static int nvme_ns_info_from_identify(struct nvme_c=
trl *ctrl,
 	info->is_shared =3D id->nmic & NVME_NS_NMIC_SHARED;
 	info->is_readonly =3D id->nsattr & NVME_NS_ATTR_RO;
 	info->is_ready =3D true;
+	info->endgid =3D le16_to_cpu(id->endgid);
 	if (ctrl->quirks & NVME_QUIRK_BOGUS_NID) {
 		dev_info(ctrl->device,
 			 "Ignoring bogus Namespace Identifiers\n");
@@ -1653,6 +1656,7 @@ static int nvme_ns_info_from_id_cs_indep(struct nvm=
e_ctrl *ctrl,
 		info->is_ready =3D id->nstat & NVME_NSTAT_NRDY;
 		info->is_rotational =3D id->nsfeat & NVME_NS_ROTATIONAL;
 		info->no_vwc =3D id->nsfeat & NVME_NS_VWC_NOT_PRESENT;
+		info->endgid =3D le16_to_cpu(id->endgid);
 	}
 	kfree(id);
 	return ret;
@@ -2147,6 +2151,97 @@ static int nvme_update_ns_info_generic(struct nvme=
_ns *ns,
 	return ret;
 }
=20
+static int nvme_check_fdp(struct nvme_ns *ns, struct nvme_ns_info *info,
+			  u8 fdp_idx)
+{
+	struct nvme_fdp_config_log hdr, *h;
+	struct nvme_fdp_config_desc *desc;
+	size_t size =3D sizeof(hdr);
+	int i, n, ret;
+	void *log;
+
+	info->runs =3D 0;
+	ret =3D nvme_get_log_lsi(ns->ctrl, 0, NVME_LOG_FDP_CONFIGS, 0, NVME_CSI=
_NVM,
+			   (void *)&hdr, size, 0, info->endgid);
+	if (ret)
+		return ret;
+
+	size =3D le32_to_cpu(hdr.sze);
+	h =3D kzalloc(size, GFP_KERNEL);
+	if (!h)
+		return 0;
+
+	ret =3D nvme_get_log_lsi(ns->ctrl, 0, NVME_LOG_FDP_CONFIGS, 0, NVME_CSI=
_NVM,
+			   h, size, 0, info->endgid);
+	if (ret)
+		goto out;
+
+	n =3D le16_to_cpu(h->numfdpc) + 1;
+	if (fdp_idx > n)
+		goto out;
+
+	log =3D h + 1;
+	do {
+		desc =3D log;
+		log +=3D le16_to_cpu(desc->dsze);
+	} while (i++ < fdp_idx);
+
+	info->runs =3D le64_to_cpu(desc->runs);
+out:
+	kfree(h);
+	return ret;
+}
+
+static int nvme_query_fdp_info(struct nvme_ns *ns, struct nvme_ns_info *=
info)
+{
+	struct nvme_ns_head *head =3D ns->head;
+	struct nvme_fdp_ruh_status *ruhs;
+	struct nvme_fdp_config fdp;
+	struct nvme_command c =3D {};
+	int size, ret;
+
+	ret =3D nvme_get_features(ns->ctrl, NVME_FEAT_FDP, info->endgid, NULL, =
0,
+				&fdp);
+	if (ret)
+		goto err;
+
+	if (!(fdp.flags & FDPCFG_FDPE))
+		goto err;
+
+	ret =3D nvme_check_fdp(ns, info, fdp.fdpcidx);
+	if (ret || !info->runs)
+		goto err;
+
+	size =3D struct_size(ruhs, ruhsd, NVME_MAX_PLIDS);
+	ruhs =3D kzalloc(size, GFP_KERNEL);
+	if (!ruhs) {
+		ret =3D -ENOMEM;
+		goto err;
+	}
+
+	c.imr.opcode =3D nvme_cmd_io_mgmt_recv;
+	c.imr.nsid =3D cpu_to_le32(head->ns_id);
+	c.imr.mo =3D NVME_IO_MGMT_RECV_MO_RUHS;
+	c.imr.numd =3D cpu_to_le32(nvme_bytes_to_numd(size));
+	ret =3D nvme_submit_sync_cmd(ns->queue, &c, ruhs, size);
+	if (ret)
+		goto free;
+
+	head->nr_plids =3D le16_to_cpu(ruhs->nruhsd);
+	if (!head->nr_plids)
+		goto free;
+
+	kfree(ruhs);
+	return 0;
+
+free:
+	kfree(ruhs);
+err:
+	head->nr_plids =3D 0;
+	info->runs =3D 0;
+	return ret;
+}
+
 static int nvme_update_ns_info_block(struct nvme_ns *ns,
 		struct nvme_ns_info *info)
 {
@@ -2183,6 +2278,15 @@ static int nvme_update_ns_info_block(struct nvme_n=
s *ns,
 			goto out;
 	}
=20
+	if (ns->ctrl->ctratt & NVME_CTRL_ATTR_FDPS) {
+		ret =3D nvme_query_fdp_info(ns, info);
+		if (ret)
+			dev_warn(ns->ctrl->device,
+				"FDP failure status:0x%x\n", ret);
+		if (ret < 0)
+			goto out;
+	}
+
 	blk_mq_freeze_queue(ns->disk->queue);
 	ns->head->lba_shift =3D id->lbaf[lbaf].ds;
 	ns->head->nuse =3D le64_to_cpu(id->nuse);
@@ -2216,6 +2320,12 @@ static int nvme_update_ns_info_block(struct nvme_n=
s *ns,
 	if (!nvme_init_integrity(ns->head, &lim, info))
 		capacity =3D 0;
=20
+	lim.max_write_streams =3D ns->head->nr_plids;
+	if (lim.max_write_streams)
+		lim.write_stream_granularity =3D info->runs;
+	else
+		lim.write_stream_granularity =3D 0;
+
 	ret =3D queue_limits_commit_update(ns->disk->queue, &lim);
 	if (ret) {
 		blk_mq_unfreeze_queue(ns->disk->queue);
@@ -2318,6 +2428,8 @@ static int nvme_update_ns_info(struct nvme_ns *ns, =
struct nvme_ns_info *info)
 			ns->head->disk->flags |=3D GENHD_FL_HIDDEN;
 		else
 			nvme_init_integrity(ns->head, &lim, info);
+		lim.max_write_streams =3D ns_lim->max_write_streams;
+		lim.write_stream_granularity =3D ns_lim->write_stream_granularity;
 		ret =3D queue_limits_commit_update(ns->head->disk->queue, &lim);
=20
 		set_capacity_and_notify(ns->head->disk, get_capacity(ns->disk));
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index c1995d89ffdb8..914cc93e91f6d 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -454,6 +454,8 @@ struct nvme_ns_ids {
 	u8	csi;
 };
=20
+#define NVME_MAX_PLIDS   (S8_MAX - 1)
+
 /*
  * Anchor structure for namespaces.  There is one for each namespace in =
a
  * NVMe subsystem that any of our controllers can see, and the namespace
@@ -491,6 +493,8 @@ struct nvme_ns_head {
 	struct device		cdev_device;
=20
 	struct gendisk		*disk;
+
+	u16			nr_plids;
 #ifdef CONFIG_NVME_MULTIPATH
 	struct bio_list		requeue_list;
 	spinlock_t		requeue_lock;
--=20
2.43.5


