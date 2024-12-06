Return-Path: <io-uring+bounces-5260-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BEDDF9E63C6
	for <lists+io-uring@lfdr.de>; Fri,  6 Dec 2024 02:54:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9FF521886718
	for <lists+io-uring@lfdr.de>; Fri,  6 Dec 2024 01:54:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E91DB154C0D;
	Fri,  6 Dec 2024 01:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="FU4gvn30"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB32B15098A
	for <io-uring@vger.kernel.org>; Fri,  6 Dec 2024 01:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733450013; cv=none; b=S5zhM35t1y4ljwl4IvwBiIME0HL4ezkmxMCoiM8DrXMGhZdN4pC9IzzMx0jBAQHEqmN5hHHReDHvXE/DERbsCCGSkkZM/Ldh/99w3YG4ennEyRLGN4xFXfdhMK9FBNEatGkrR3K3jCldbElU1PkEZtMbq7CSuYsVUVDXunpC7sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733450013; c=relaxed/simple;
	bh=jEkhKFWSiOGNqmafZm5rrOk42Ci3nP8BRG3OYmsRfC4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S/sagpmmVat3O+37dNFaYeNy9mVjoAeLKtqouJkGztDwZ+WuGGemjjBqa2QRELiXxejWk/kJwvSMBafVxrtjABWhBymLpDRWMA19I05gZu509rSOq10yf4g/ip2BXkZqjSDndYY6zeePfqt+Mbnx7Y5zyyzHkq+Vo9834gLbLPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=FU4gvn30; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4B603Jge014117
	for <io-uring@vger.kernel.org>; Thu, 5 Dec 2024 17:53:31 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2021-q4;
	 bh=/QfY4VuKFEqf3WK6nWx5RQXvAMdSdKErUcPPW9/w71A=; b=FU4gvn306t3k
	Nbl3PStj8eXWBYzoPkPCc+HoLsYN3OfBsqg/GGSvWy3sQFkyyJ0h85FLPKOMdbTx
	NzRoL5uTnLS07y38ZcmJgExeyC0Vx+0kv8AjyFenI/ZHUo5A6uM7SAT4n5SxUYxM
	yJfTW1W7H/Bask9xm5t/raBYT8Y39BMF6ctB4c6pZx+a6Eu+fmhU7mQoismzodJs
	NmF3zG4j0x0DbpeLtlWtik/RACZPrew+hpFH3CqaA/PCs2t83jypiGSiuALUAqBG
	FDaKV2B3bRcuAJKw5ilqMJ86BAAyJGA4gIVy6Q/sfqx6crb2wJxfXcYgPz1MuNUY
	hY0pXu3rdw==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 43bmru153e-9
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Thu, 05 Dec 2024 17:53:30 -0800 (PST)
Received: from twshared32179.32.frc3.facebook.com (2620:10d:c0a8:1b::2d) by
 mail.thefacebook.com (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.11; Fri, 6 Dec 2024 01:53:22 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id 5C0A115B2115C; Thu,  5 Dec 2024 17:53:09 -0800 (PST)
From: Keith Busch <kbusch@meta.com>
To: <axboe@kernel.dk>, <hch@lst.de>, <linux-block@vger.kernel.org>,
        <linux-nvme@lists.infradead.org>, <linux-fsdevel@vger.kernel.org>,
        <io-uring@vger.kernel.org>
CC: <sagi@grimberg.me>, <asml.silence@gmail.com>,
        Keith Busch
	<kbusch@kernel.org>, Keith Busch <kbsuch@kernel.org>
Subject: [PATCHv11 09/10] nvme: register fdp queue limits
Date: Thu, 5 Dec 2024 17:53:07 -0800
Message-ID: <20241206015308.3342386-10-kbusch@meta.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241206015308.3342386-1-kbusch@meta.com>
References: <20241206015308.3342386-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: uFNW_Wyo5Bv1P7fgoCC_LYPUEIC7p1E6
X-Proofpoint-ORIG-GUID: uFNW_Wyo5Bv1P7fgoCC_LYPUEIC7p1E6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-05_03,2024-10-04_01,2024-09-30_01

From: Keith Busch <kbusch@kernel.org>

Register the device data placement limits if supported. This is just
registering the limits with the block layer. Nothing beyond reporting
these attributes is happening in this patch.

Signed-off-by: Keith Busch <kbsuch@kernel.org>
---
 drivers/nvme/host/core.c | 116 +++++++++++++++++++++++++++++++++++++++
 drivers/nvme/host/nvme.h |   4 ++
 include/linux/nvme.h     |  73 ++++++++++++++++++++++++
 3 files changed, 193 insertions(+)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 36c44be98e38c..410a77de92f88 100644
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
@@ -2147,6 +2151,101 @@ static int nvme_update_ns_info_generic(struct nvm=
e_ns *ns,
 	return ret;
 }
=20
+static int nvme_check_fdp(struct nvme_ns *ns, struct nvme_ns_info *info,
+			  u8 fdp_idx)
+{
+	struct nvme_fdp_config_log hdr, *h;
+	size_t size =3D sizeof(hdr);
+	int i, n, ret;
+	void *log;
+
+	info->runs =3D 0;
+	ret =3D nvme_get_log_lsi(ns->ctrl, 0, NVME_LOG_FDP_CONFIG, 0, NVME_CSI_=
NVM,
+			   (void *)&hdr, size, 0, info->endgid);
+	if (ret)
+		return ret;
+
+	size =3D le32_to_cpu(hdr.sze);
+	log =3D kzalloc(size, GFP_KERNEL);
+	if (!log)
+		return 0;
+
+	ret =3D nvme_get_log_lsi(ns->ctrl, 0, NVME_LOG_FDP_CONFIG, 0, NVME_CSI_=
NVM,
+			   log, size, 0, info->endgid);
+	if (ret)
+		goto out;
+
+	n =3D le16_to_cpu(h->numfdpc) + 1;
+	if (fdp_idx > n)
+		goto out;
+
+	h =3D log;
+	log =3D h->configs;
+	for (i =3D 0; i < n; i++) {
+		struct nvme_fdp_config_desc *config =3D log;
+
+		if (i =3D=3D fdp_idx) {
+			info->runs =3D le64_to_cpu(config->runs);
+			break;
+		}
+		log +=3D le16_to_cpu(config->size);
+	}
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
+	struct nvme_command c =3D {};
+	u32 fdp, fdp_idx;
+	int size, ret;
+
+	ret =3D nvme_get_features(ns->ctrl, NVME_FEAT_FDP, info->endgid, NULL, =
0,
+				&fdp);
+	if (ret)
+		goto err;
+
+	if (!(fdp & NVME_FDP_FDPE))
+		goto err;
+
+	fdp_idx =3D (fdp >> NVME_FDP_FDPCIDX_SHIFT) & NVME_FDP_FDPCIDX_MASK;
+	ret =3D nvme_check_fdp(ns, info, fdp_idx);
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
@@ -2183,6 +2282,15 @@ static int nvme_update_ns_info_block(struct nvme_n=
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
@@ -2216,6 +2324,12 @@ static int nvme_update_ns_info_block(struct nvme_n=
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
@@ -2318,6 +2432,8 @@ static int nvme_update_ns_info(struct nvme_ns *ns, =
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
index 611b02c8a8b37..5c8bdaa2c8824 100644
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
diff --git a/include/linux/nvme.h b/include/linux/nvme.h
index 13377dde4527b..78657a8e39561 100644
--- a/include/linux/nvme.h
+++ b/include/linux/nvme.h
@@ -275,6 +275,7 @@ enum nvme_ctrl_attr {
 	NVME_CTRL_ATTR_HID_128_BIT	=3D (1 << 0),
 	NVME_CTRL_ATTR_TBKAS		=3D (1 << 6),
 	NVME_CTRL_ATTR_ELBAS		=3D (1 << 15),
+	NVME_CTRL_ATTR_FDPS		=3D (1 << 19),
 };
=20
 struct nvme_id_ctrl {
@@ -761,6 +762,34 @@ struct nvme_zone_report {
 	struct nvme_zone_descriptor entries[];
 };
=20
+struct nvme_fdp_ruh_desc {
+	__u8 ruht;
+	__u8 rsvd1[3];
+};
+
+struct nvme_fdp_config_desc {
+	__le16 size;
+	__u8  fdpa;
+	__u8  vss;
+	__le32 nrg;
+	__le16 nruh;
+	__le16 maxpids;
+	__le32 nnss;
+	__le64 runs;
+	__le32 erutl;
+	__u8  rsvd28[36];
+	struct nvme_fdp_ruh_desc ruhs[];
+};
+
+struct nvme_fdp_config_log {
+	__le16 numfdpc;
+	__u8  ver;
+	__u8  rsvd3;
+	__le32 sze;
+	__u8  rsvd8[8];
+	struct nvme_fdp_config_desc configs[];
+};
+
 enum {
 	NVME_SMART_CRIT_SPARE		=3D 1 << 0,
 	NVME_SMART_CRIT_TEMPERATURE	=3D 1 << 1,
@@ -887,6 +916,7 @@ enum nvme_opcode {
 	nvme_cmd_resv_register	=3D 0x0d,
 	nvme_cmd_resv_report	=3D 0x0e,
 	nvme_cmd_resv_acquire	=3D 0x11,
+	nvme_cmd_io_mgmt_recv	=3D 0x12,
 	nvme_cmd_resv_release	=3D 0x15,
 	nvme_cmd_zone_mgmt_send	=3D 0x79,
 	nvme_cmd_zone_mgmt_recv	=3D 0x7a,
@@ -908,6 +938,7 @@ enum nvme_opcode {
 		nvme_opcode_name(nvme_cmd_resv_register),	\
 		nvme_opcode_name(nvme_cmd_resv_report),		\
 		nvme_opcode_name(nvme_cmd_resv_acquire),	\
+		nvme_opcode_name(nvme_cmd_io_mgmt_recv),	\
 		nvme_opcode_name(nvme_cmd_resv_release),	\
 		nvme_opcode_name(nvme_cmd_zone_mgmt_send),	\
 		nvme_opcode_name(nvme_cmd_zone_mgmt_recv),	\
@@ -1059,6 +1090,7 @@ enum {
 	NVME_RW_PRINFO_PRCHK_GUARD	=3D 1 << 12,
 	NVME_RW_PRINFO_PRACT		=3D 1 << 13,
 	NVME_RW_DTYPE_STREAMS		=3D 1 << 4,
+	NVME_RW_DTYPE_DPLCMT		=3D 2 << 4,
 	NVME_WZ_DEAC			=3D 1 << 9,
 };
=20
@@ -1146,6 +1178,38 @@ struct nvme_zone_mgmt_recv_cmd {
 	__le32			cdw14[2];
 };
=20
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
+enum {
+	NVME_IO_MGMT_RECV_MO_RUHS	=3D 1,
+};
+
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
 enum {
 	NVME_ZRA_ZONE_REPORT		=3D 0,
 	NVME_ZRASF_ZONE_REPORT_ALL	=3D 0,
@@ -1281,6 +1345,7 @@ enum {
 	NVME_FEAT_PLM_WINDOW	=3D 0x14,
 	NVME_FEAT_HOST_BEHAVIOR	=3D 0x16,
 	NVME_FEAT_SANITIZE	=3D 0x17,
+	NVME_FEAT_FDP		=3D 0x1d,
 	NVME_FEAT_SW_PROGRESS	=3D 0x80,
 	NVME_FEAT_HOST_ID	=3D 0x81,
 	NVME_FEAT_RESV_MASK	=3D 0x82,
@@ -1301,6 +1366,7 @@ enum {
 	NVME_LOG_ANA		=3D 0x0c,
 	NVME_LOG_FEATURES	=3D 0x12,
 	NVME_LOG_RMI		=3D 0x16,
+	NVME_LOG_FDP_CONFIG	=3D 0x20,
 	NVME_LOG_DISC		=3D 0x70,
 	NVME_LOG_RESERVATION	=3D 0x80,
 	NVME_FWACT_REPL		=3D (0 << 3),
@@ -1326,6 +1392,12 @@ enum {
 	NVME_FIS_CSCPE	=3D 1 << 21,
 };
=20
+enum {
+	NVME_FDP_FDPE		=3D 1 << 0,
+	NVME_FDP_FDPCIDX_SHIFT	=3D 8,
+	NVME_FDP_FDPCIDX_MASK	=3D 0xff,
+};
+
 /* NVMe Namespace Write Protect State */
 enum {
 	NVME_NS_NO_WRITE_PROTECT =3D 0,
@@ -1888,6 +1960,7 @@ struct nvme_command {
 		struct nvmf_auth_receive_command auth_receive;
 		struct nvme_dbbuf dbbuf;
 		struct nvme_directive_cmd directive;
+		struct nvme_io_mgmt_recv_cmd imr;
 	};
 };
=20
--=20
2.43.5


