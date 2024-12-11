Return-Path: <io-uring+bounces-5447-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F0F4B9ED633
	for <lists+io-uring@lfdr.de>; Wed, 11 Dec 2024 20:16:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A9F90283D8E
	for <lists+io-uring@lfdr.de>; Wed, 11 Dec 2024 19:16:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F777211A0B;
	Wed, 11 Dec 2024 19:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="ByRXSEzw"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76143259499
	for <io-uring@vger.kernel.org>; Wed, 11 Dec 2024 19:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733943766; cv=none; b=PlKTpcSOiOCSuiEa69Ky0dtqTdUVPqM3L0J1nGgzwdJ9ee/TBA5zJAlEzYavM3oEmbhyca+4IfxolJaVmTl7ZSgpynkhCc6+t6Xb94Tr1MF+ccVH2Tub3sEUsoEh/e+flcBTvP3wUOKRth2MrnPGdHvhmJMrchtNsQ4uq7brVtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733943766; c=relaxed/simple;
	bh=qjXJgfjQRFp9lJBgXy4DNXpuzCwTnSa/v3b8lFIf7Ek=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=puSz57i73QvL5lUaPQat1YVUJU4blWAvEFu1E952ChKTXl9NWea3vU6DpE7BMWxYZnBsD94aRw5sEfmANMj8njvSRPy9DgDjTseIxqTIyX/oXMeijFHgUcWlUU6y3Tj4ikMzH4luAGfdXUCAcGGxvvr7eQ0AGyFJY9e0ybbOOPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=ByRXSEzw; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BBFI6tJ009936
	for <io-uring@vger.kernel.org>; Wed, 11 Dec 2024 11:02:43 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2021-q4;
	 bh=wdIXVfv5tgPyz+aLffvm4RUzt3ZQy9aZI+7AbO2W0P0=; b=ByRXSEzweB1c
	7O9PthG/yY8Bo4dZixP9fnUpL0HlKKxMDrVPXwxSl1SmlcMPT8d5GMLmjt/WpeZj
	0hCe9Nf9RvK2vTpUTuQmWPdkPJ8lg3YJwTEERMr3KdSoP8ZuhwDmTQhzayv8zWnq
	DFk3ZpmuQeFM3s2W1mN0+cp6Vj5NBgYJLlDNsTvPLUA7y/q0BesEGjez33yc8hUm
	9k1vnsboI/c5Yblilf98/aSYVzuNt2I8eWRCDoL9e11i93OPY9JkVz4/53bnJGXS
	VnwmO5DlYp2s9zfigmKYcH5NUtInJGmwt++Bzd45sbE7XQ2eGq/UHxisao1aaE6z
	FBkPh/BdxA==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 43fcd128qr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Wed, 11 Dec 2024 11:02:43 -0800 (PST)
Received: from twshared3815.08.ash9.facebook.com (2620:10d:c0a8:1c::11) by
 mail.thefacebook.com (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.11; Wed, 11 Dec 2024 19:02:40 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id B2D7315DE3967; Wed, 11 Dec 2024 10:35:16 -0800 (PST)
From: Keith Busch <kbusch@meta.com>
To: <axboe@kernel.dk>, <hch@lst.de>, <linux-block@vger.kernel.org>,
        <linux-nvme@lists.infradead.org>, <linux-fsdevel@vger.kernel.org>,
        <io-uring@vger.kernel.org>
CC: <sagi@grimberg.me>, <asml.silence@gmail.com>, <anuj20.g@samsung.com>,
        <joshi.k@samsung.com>, Keith Busch <kbusch@kernel.org>
Subject: [PATCHv14 10/11] nvme: register fdp parameters with the block layer
Date: Wed, 11 Dec 2024 10:35:13 -0800
Message-ID: <20241211183514.64070-11-kbusch@meta.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241211183514.64070-1-kbusch@meta.com>
References: <20241211183514.64070-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: D5SUrc5v04f4oQhfLdpErhi4-lZ3prka
X-Proofpoint-GUID: D5SUrc5v04f4oQhfLdpErhi4-lZ3prka
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-05_02,2024-10-04_01,2024-09-30_01

From: Keith Busch <kbusch@kernel.org>

Register the device data placement limits if supported. This is just
registering the limits with the block layer. Nothing beyond reporting
these attributes is happening in this patch.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 drivers/nvme/host/core.c | 145 +++++++++++++++++++++++++++++++++++++++
 drivers/nvme/host/nvme.h |   2 +
 2 files changed, 147 insertions(+)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index c2a3585a3fa59..2392373415fd6 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -23,6 +23,7 @@
 #include <linux/pm_qos.h>
 #include <linux/ratelimit.h>
 #include <linux/unaligned.h>
+#include <linux/vmalloc.h>
=20
 #include "nvme.h"
 #include "fabrics.h"
@@ -38,6 +39,8 @@ struct nvme_ns_info {
 	u32 nsid;
 	__le32 anagrpid;
 	u8 pi_offset;
+	u16 endgid;
+	u64 runs;
 	bool is_shared;
 	bool is_readonly;
 	bool is_ready;
@@ -1613,6 +1616,7 @@ static int nvme_ns_info_from_identify(struct nvme_c=
trl *ctrl,
 	info->is_shared =3D id->nmic & NVME_NS_NMIC_SHARED;
 	info->is_readonly =3D id->nsattr & NVME_NS_ATTR_RO;
 	info->is_ready =3D true;
+	info->endgid =3D le16_to_cpu(id->endgid);
 	if (ctrl->quirks & NVME_QUIRK_BOGUS_NID) {
 		dev_info(ctrl->device,
 			 "Ignoring bogus Namespace Identifiers\n");
@@ -1653,6 +1657,7 @@ static int nvme_ns_info_from_id_cs_indep(struct nvm=
e_ctrl *ctrl,
 		info->is_ready =3D id->nstat & NVME_NSTAT_NRDY;
 		info->is_rotational =3D id->nsfeat & NVME_NS_ROTATIONAL;
 		info->no_vwc =3D id->nsfeat & NVME_NS_VWC_NOT_PRESENT;
+		info->endgid =3D le16_to_cpu(id->endgid);
 	}
 	kfree(id);
 	return ret;
@@ -2147,6 +2152,132 @@ static int nvme_update_ns_info_generic(struct nvm=
e_ns *ns,
 	return ret;
 }
=20
+static int nvme_query_fdp_granularity(struct nvme_ctrl *ctrl,
+				      struct nvme_ns_info *info, u8 fdp_idx)
+{
+	struct nvme_fdp_config_log hdr, *h;
+	struct nvme_fdp_config_desc *desc;
+	size_t size =3D sizeof(hdr);
+	void *log, *end;
+	int i, n, ret;
+
+	ret =3D nvme_get_log_lsi(ctrl, 0, NVME_LOG_FDP_CONFIGS, 0,
+			       NVME_CSI_NVM, &hdr, size, 0, info->endgid);
+	if (ret) {
+		dev_warn(ctrl->device,
+			 "FDP configs log header status:0x%x endgid:%d\n", ret,
+			 info->endgid);
+		return ret;
+	}
+
+	size =3D le32_to_cpu(hdr.sze);
+	if (size > PAGE_SIZE * MAX_ORDER_NR_PAGES) {
+		dev_warn(ctrl->device, "FDP config size too large:%zu\n",
+			 size);
+		return 0;
+	}
+
+	h =3D vmalloc(size);
+	if (!h)
+		return -ENOMEM;
+
+	ret =3D nvme_get_log_lsi(ctrl, 0, NVME_LOG_FDP_CONFIGS, 0,
+			       NVME_CSI_NVM, h, size, 0, info->endgid);
+	if (ret) {
+		dev_warn(ctrl->device,
+			 "FDP configs log status:0x%x endgid:%d\n", ret,
+			 info->endgid);
+		goto out;
+	}
+
+	n =3D le16_to_cpu(h->numfdpc) + 1;
+	if (fdp_idx > n) {
+		dev_warn(ctrl->device, "FDP index:%d out of range:%d\n",
+			 fdp_idx, n);
+		/* Proceed without registering FDP streams */
+		ret =3D 0;
+		goto out;
+	}
+
+	log =3D h + 1;
+	desc =3D log;
+	end =3D log + size - sizeof(*h);
+	for (i =3D 0; i < fdp_idx; i++) {
+		log +=3D le16_to_cpu(desc->dsze);
+		desc =3D log;
+		if (log >=3D end) {
+			dev_warn(ctrl->device,
+				 "FDP invalid config descriptor list\n");
+			ret =3D 0;
+			goto out;
+		}
+	}
+
+	if (le32_to_cpu(desc->nrg) > 1) {
+		dev_warn(ctrl->device, "FDP NRG > 1 not supported\n");
+		ret =3D 0;
+		goto out;
+	}
+
+	info->runs =3D le64_to_cpu(desc->runs);
+out:
+	kvfree(h);
+	return ret;
+}
+
+static int nvme_query_fdp_info(struct nvme_ns *ns, struct nvme_ns_info *=
info)
+{
+	struct nvme_ns_head *head =3D ns->head;
+	struct nvme_ctrl *ctrl =3D ns->ctrl;
+	struct nvme_fdp_ruh_status *ruhs;
+	struct nvme_fdp_config fdp;
+	struct nvme_command c =3D {};
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
+	ret =3D nvme_get_features(ctrl, NVME_FEAT_FDP, info->endgid, NULL, 0,
+				&fdp);
+	if (ret) {
+		dev_warn(ctrl->device, "FDP get feature status:0x%x\n", ret);
+		return ret;
+	}
+
+	if (!(fdp.flags & FDPCFG_FDPE))
+		return 0;
+
+	ret =3D nvme_query_fdp_granularity(ctrl, info, fdp.fdpcidx);
+	if (!info->runs)
+		return ret;
+
+	size =3D struct_size(ruhs, ruhsd, S8_MAX - 1);
+	ruhs =3D kzalloc(size, GFP_KERNEL);
+	if (!ruhs)
+		return -ENOMEM;
+
+	c.imr.opcode =3D nvme_cmd_io_mgmt_recv;
+	c.imr.nsid =3D cpu_to_le32(head->ns_id);
+	c.imr.mo =3D NVME_IO_MGMT_RECV_MO_RUHS;
+	c.imr.numd =3D cpu_to_le32(nvme_bytes_to_numd(size));
+	ret =3D nvme_submit_sync_cmd(ns->queue, &c, ruhs, size);
+	if (ret) {
+		dev_warn(ctrl->device, "FDP io-mgmt status:0x%x\n", ret);
+		goto free;
+	}
+
+	head->nr_plids =3D le16_to_cpu(ruhs->nruhsd);
+free:
+	kfree(ruhs);
+	return ret;
+}
+
 static int nvme_update_ns_info_block(struct nvme_ns *ns,
 		struct nvme_ns_info *info)
 {
@@ -2183,6 +2314,12 @@ static int nvme_update_ns_info_block(struct nvme_n=
s *ns,
 			goto out;
 	}
=20
+	if (ns->ctrl->ctratt & NVME_CTRL_ATTR_FDPS) {
+		ret =3D nvme_query_fdp_info(ns, info);
+		if (ret < 0)
+			goto out;
+	}
+
 	blk_mq_freeze_queue(ns->disk->queue);
 	ns->head->lba_shift =3D id->lbaf[lbaf].ds;
 	ns->head->nuse =3D le64_to_cpu(id->nuse);
@@ -2216,6 +2353,12 @@ static int nvme_update_ns_info_block(struct nvme_n=
s *ns,
 	if (!nvme_init_integrity(ns->head, &lim, info))
 		capacity =3D 0;
=20
+	lim.max_write_streams =3D ns->head->nr_plids;
+	if (lim.max_write_streams)
+		lim.write_stream_granularity =3D max(info->runs, U32_MAX);
+	else
+		lim.write_stream_granularity =3D 0;
+
 	ret =3D queue_limits_commit_update(ns->disk->queue, &lim);
 	if (ret) {
 		blk_mq_unfreeze_queue(ns->disk->queue);
@@ -2318,6 +2461,8 @@ static int nvme_update_ns_info(struct nvme_ns *ns, =
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
index c1995d89ffdb8..4b412cd8001f1 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -491,6 +491,8 @@ struct nvme_ns_head {
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


