Return-Path: <io-uring+bounces-3796-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B0AB9A2850
	for <lists+io-uring@lfdr.de>; Thu, 17 Oct 2024 18:16:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B68BB1F22F3B
	for <lists+io-uring@lfdr.de>; Thu, 17 Oct 2024 16:16:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C15F1DEFED;
	Thu, 17 Oct 2024 16:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="cn+CituJ"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21F9A1DEFE3
	for <io-uring@vger.kernel.org>; Thu, 17 Oct 2024 16:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729181770; cv=none; b=m70nMuWJE4pliltz/EDoQ2tgs/7PE1yMoHXVFTVazwSHJqljR3zqWRULleRjs8QgLyyMFoqH7yr1Se6oCrlHZ8LkyV40rsr3faNtrGQLzPHvrCn/JAgaw/A245QhCZiAT83SdD1Q7sGiQcY9A1pQ7K3X7AzwWeWMkkvBP/q1HRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729181770; c=relaxed/simple;
	bh=OcGVtyrzhVu2x88GuEyv6IQ88OnuyHPqZaMqYeLXeVc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CUjCo31/6cqhschiA6Waiq9YOyX9HD5HlHPUhohZT1hCM/jsryph21znj/ODNvmJNJAb9Av6HwbsGFAbtzGEP1qzS+b9GZPLEZf9YxwdZvrsGYHg9lDK7DAtkdlNB+yaG7Np/laZ1fiu3RYkzFvXOyhOeHuwvsvfCxlg1epWqrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=cn+CituJ; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49HCh1El007042
	for <io-uring@vger.kernel.org>; Thu, 17 Oct 2024 09:16:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2021-q4;
	 bh=gfjX4gdVpoRZdOrqZPFH61tH5y9pgFNLY8DXmPMq2Fc=; b=cn+CituJl8mz
	SgWMJ/89fxaA4HYSuRkGCgOD/MxuxZUlwI16NzoLaiX45g0txojmnNDawO6ljnpo
	LgsXLyNV6uzU7QaG13o3kww32jCFeJbxKduJW/gN33DUtP+xGa4F+NlW9BtGDQlR
	5PcD5xjXxZzlE77fVjyHYOmL1VJ/tjomFirTG1g0AL+1mXaJ8Qk6aPCXpBFhX4Mi
	oQThtQo0MXm+0Ffly8pgQSlZiyIkCUC2kpKtbBBY79lMCGYo+OJy+1EAF0iQ60Nh
	RJArAaGlhPKQvsxMuszZZv7WQCaKEYTXVjfVilxy0rqFR19lHBK6tC4STIlQU2m7
	r0E7WnvJcw==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 42ar0mn5e4-6
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Thu, 17 Oct 2024 09:16:04 -0700 (PDT)
Received: from twshared10900.35.frc1.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.11; Thu, 17 Oct 2024 16:16:00 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id 99136143A4B18; Thu, 17 Oct 2024 09:10:19 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <linux-block@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <axboe@kernel.dk>, <hch@lst.de>, <io-uring@vger.kernel.org>
CC: <linux-fsdevel@vger.kernel.org>, <joshi.k@samsung.com>,
        <javier.gonz@samsung.com>, Hui Qi <hui81.qi@samsung.com>,
        Nitesh Shetty
	<nj.shetty@samsung.com>, Hannes Reinecke <hare@suse.de>,
        Keith Busch
	<kbusch@kernel.org>
Subject: [PATCHv8 6/6] nvme: enable FDP support
Date: Thu, 17 Oct 2024 09:09:37 -0700
Message-ID: <20241017160937.2283225-7-kbusch@meta.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241017160937.2283225-1-kbusch@meta.com>
References: <20241017160937.2283225-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: YO81mqgEz7yRhL1JmMSkQJaZcoPDQ9Ji
X-Proofpoint-GUID: YO81mqgEz7yRhL1JmMSkQJaZcoPDQ9Ji
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-05_02,2024-10-04_01,2024-09-30_01

From: Kanchan Joshi <joshi.k@samsung.com>

Flexible Data Placement (FDP), as ratified in TP 4146a, allows the host
to control the placement of logical blocks so as to reduce the SSD WAF.
Userspace can send the write hint information using io_uring or fcntl.

Fetch the placement-identifiers if the device supports FDP. The incoming
write-hint is mapped to a placement-identifier, which in turn is set in
the DSPEC field of the write command.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Hui Qi <hui81.qi@samsung.com>
Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
Nacked-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 drivers/nvme/host/core.c | 82 ++++++++++++++++++++++++++++++++++++++++
 drivers/nvme/host/nvme.h |  5 +++
 include/linux/nvme.h     | 19 ++++++++++
 3 files changed, 106 insertions(+)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 43d73d31c66f3..02a36032c835f 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -44,6 +44,20 @@ struct nvme_ns_info {
 	bool is_removed;
 };
=20
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
 unsigned int admin_timeout =3D 60;
 module_param(admin_timeout, uint, 0644);
 MODULE_PARM_DESC(admin_timeout, "timeout in seconds for admin commands")=
;
@@ -657,6 +671,7 @@ static void nvme_free_ns_head(struct kref *ref)
 	ida_free(&head->subsys->ns_ida, head->instance);
 	cleanup_srcu_struct(&head->srcu);
 	nvme_put_subsystem(head->subsys);
+	kfree(head->plids);
 	kfree(head);
 }
=20
@@ -974,6 +989,13 @@ static inline blk_status_t nvme_setup_rw(struct nvme=
_ns *ns,
 	if (req->cmd_flags & REQ_RAHEAD)
 		dsmgmt |=3D NVME_RW_DSM_FREQ_PREFETCH;
=20
+	if (req->write_hint !=3D WRITE_LIFE_NOT_SET && ns->head->nr_plids) {
+		u16 hint =3D max(req->write_hint, ns->head->nr_plids);
+
+		dsmgmt |=3D ns->head->plids[hint - 1] << 16;
+		control |=3D NVME_RW_DTYPE_DPLCMT;
+	}
+
 	if (req->cmd_flags & REQ_ATOMIC && !nvme_valid_atomic_write(req))
 		return BLK_STS_INVAL;
=20
@@ -2114,6 +2136,52 @@ static int nvme_update_ns_info_generic(struct nvme=
_ns *ns,
 	return ret;
 }
=20
+static int nvme_fetch_fdp_plids(struct nvme_ns *ns, u32 nsid)
+{
+	struct nvme_fdp_ruh_status_desc *ruhsd;
+	struct nvme_ns_head *head =3D ns->head;
+	struct nvme_fdp_ruh_status *ruhs;
+	struct nvme_command c =3D {};
+	int size, ret, i;
+
+	if (head->plids)
+		return 0;
+
+	size =3D struct_size(ruhs, ruhsd, NVME_MAX_PLIDS);
+	ruhs =3D kzalloc(size, GFP_KERNEL);
+	if (!ruhs)
+		return -ENOMEM;
+
+	c.imr.opcode =3D nvme_cmd_io_mgmt_recv;
+	c.imr.nsid =3D cpu_to_le32(nsid);
+	c.imr.mo =3D 0x1;
+	c.imr.numd =3D  cpu_to_le32((size >> 2) - 1);
+
+	ret =3D nvme_submit_sync_cmd(ns->queue, &c, ruhs, size);
+	if (ret)
+		goto out;
+
+	i =3D le16_to_cpu(ruhs->nruhsd);
+	if (!i)
+		goto out;
+
+	ns->head->nr_plids =3D min_t(u16, i, NVME_MAX_PLIDS);
+	head->plids =3D kcalloc(ns->head->nr_plids, sizeof(head->plids),
+			      GFP_KERNEL);
+	if (!head->plids) {
+		ret =3D -ENOMEM;
+		goto out;
+	}
+
+	for (i =3D 0; i < ns->head->nr_plids; i++) {
+		ruhsd =3D &ruhs->ruhsd[i];
+		head->plids[i] =3D le16_to_cpu(ruhsd->pid);
+	}
+out:
+	kfree(ruhs);
+	return ret;
+}
+
 static int nvme_update_ns_info_block(struct nvme_ns *ns,
 		struct nvme_ns_info *info)
 {
@@ -2150,6 +2218,19 @@ static int nvme_update_ns_info_block(struct nvme_n=
s *ns,
 			goto out;
 	}
=20
+	if (ns->ctrl->ctratt & NVME_CTRL_ATTR_FDPS) {
+		ret =3D nvme_fetch_fdp_plids(ns, info->nsid);
+		if (ret)
+			dev_warn(ns->ctrl->device,
+				"FDP failure status:0x%x\n", ret);
+		if (ret < 0)
+			goto out;
+	} else {
+		ns->head->nr_plids =3D 0;
+		kfree(ns->head->plids);
+		ns->head->plids =3D NULL;
+	}
+
 	blk_mq_freeze_queue(ns->disk->queue);
 	ns->head->lba_shift =3D id->lbaf[lbaf].ds;
 	ns->head->nuse =3D le64_to_cpu(id->nuse);
@@ -2180,6 +2261,7 @@ static int nvme_update_ns_info_block(struct nvme_ns=
 *ns,
 	if (!nvme_init_integrity(ns->head, &lim, info))
 		capacity =3D 0;
=20
+	lim.max_write_hints =3D ns->head->nr_plids;
 	ret =3D queue_limits_commit_update(ns->disk->queue, &lim);
 	if (ret) {
 		blk_mq_unfreeze_queue(ns->disk->queue);
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 313a4f978a2cf..d6b516c0e502c 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -454,6 +454,8 @@ struct nvme_ns_ids {
 	u8	csi;
 };
=20
+#define NVME_MAX_PLIDS   (NVME_CTRL_PAGE_SIZE / sizeof(16))
+
 /*
  * Anchor structure for namespaces.  There is one for each namespace in =
a
  * NVMe subsystem that any of our controllers can see, and the namespace
@@ -490,6 +492,9 @@ struct nvme_ns_head {
 	struct device		cdev_device;
=20
 	struct gendisk		*disk;
+
+	u16                     nr_plids;
+	u16			*plids;
 #ifdef CONFIG_NVME_MULTIPATH
 	struct bio_list		requeue_list;
 	spinlock_t		requeue_lock;
diff --git a/include/linux/nvme.h b/include/linux/nvme.h
index b58d9405d65e0..a954eaee5b0f3 100644
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
@@ -843,6 +844,7 @@ enum nvme_opcode {
 	nvme_cmd_resv_register	=3D 0x0d,
 	nvme_cmd_resv_report	=3D 0x0e,
 	nvme_cmd_resv_acquire	=3D 0x11,
+	nvme_cmd_io_mgmt_recv	=3D 0x12,
 	nvme_cmd_resv_release	=3D 0x15,
 	nvme_cmd_zone_mgmt_send	=3D 0x79,
 	nvme_cmd_zone_mgmt_recv	=3D 0x7a,
@@ -864,6 +866,7 @@ enum nvme_opcode {
 		nvme_opcode_name(nvme_cmd_resv_register),	\
 		nvme_opcode_name(nvme_cmd_resv_report),		\
 		nvme_opcode_name(nvme_cmd_resv_acquire),	\
+		nvme_opcode_name(nvme_cmd_io_mgmt_recv),	\
 		nvme_opcode_name(nvme_cmd_resv_release),	\
 		nvme_opcode_name(nvme_cmd_zone_mgmt_send),	\
 		nvme_opcode_name(nvme_cmd_zone_mgmt_recv),	\
@@ -1015,6 +1018,7 @@ enum {
 	NVME_RW_PRINFO_PRCHK_GUARD	=3D 1 << 12,
 	NVME_RW_PRINFO_PRACT		=3D 1 << 13,
 	NVME_RW_DTYPE_STREAMS		=3D 1 << 4,
+	NVME_RW_DTYPE_DPLCMT		=3D 2 << 4,
 	NVME_WZ_DEAC			=3D 1 << 9,
 };
=20
@@ -1102,6 +1106,20 @@ struct nvme_zone_mgmt_recv_cmd {
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
 enum {
 	NVME_ZRA_ZONE_REPORT		=3D 0,
 	NVME_ZRASF_ZONE_REPORT_ALL	=3D 0,
@@ -1822,6 +1840,7 @@ struct nvme_command {
 		struct nvmf_auth_receive_command auth_receive;
 		struct nvme_dbbuf dbbuf;
 		struct nvme_directive_cmd directive;
+		struct nvme_io_mgmt_recv_cmd imr;
 	};
 };
=20
--=20
2.43.5


