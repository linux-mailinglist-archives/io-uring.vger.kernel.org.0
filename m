Return-Path: <io-uring+bounces-6243-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9112BA26315
	for <lists+io-uring@lfdr.de>; Mon,  3 Feb 2025 19:53:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2DD6D3A66D5
	for <lists+io-uring@lfdr.de>; Mon,  3 Feb 2025 18:53:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D31E315383A;
	Mon,  3 Feb 2025 18:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="LfICLbki"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1433E1CAA87
	for <io-uring@vger.kernel.org>; Mon,  3 Feb 2025 18:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738608799; cv=none; b=IopNiv4x+/ai1AqCRnzXL4MQzmcYlrok4QUNWqYYC3APQKnTSjfITCiOC66cyA6jtxOSD25RHPclc8HbLrMVCTLA/stC47ccQqswRaVnWB7qPSojJ3RXXBY1P5K5pxonhHzlt67tU5E8Eg1stoL1Sr+ca84XZrhCKD2GiFBmZNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738608799; c=relaxed/simple;
	bh=e48qGz4Bn9dLz1jhIp22OY8TYaa84UEgiCOtD/JkPtI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Haw5rgRUewm+YIqKbK7XZP3JxWRRechVrvo6vRkwmNNTSqSEA2CJ9FHNRChKDsgWiPYAYuoJ1byu3NWX2I5odNGP8jFEkQ0P+0jpRx97yRnZWupBw+HRnrQMlM57aK3mQNk0TodLerV6I/UFTa7YoIpeyEnLNAS4D5WVOfd/2rY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=LfICLbki; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 513Iqjaj005147
	for <io-uring@vger.kernel.org>; Mon, 3 Feb 2025 10:53:16 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2021-q4;
	 bh=zDEOW7LJg7nneqe6AczoyAnreUYckVlEV/38sgV30U4=; b=LfICLbkiTCJ3
	NH47CX8AgYCAHePci/2Ri3s9NAR3LNPcT25ngDkND4zrkdi3JsQbdpwyBrJBSjvo
	DcUfRUqAAQwNbx78tpIzY6w4wA9sf3PGnV4czWurn81HKatJXE8pEADj6WMhCwsA
	ZAFTZDNP0EJm3fEZSDCowMdpIYn0MryPf5tDbYlCPT5r0KpH7GRxJ4hmF4CCH/bd
	puQqzPBHMpSjd+kpuKee6ILr9pgIEu77fYSCCTsycOgfGYPq+RedCvr8lrJ9lPaz
	gxRhNA5QkSg9XygdrWqS3mVXNYv4T3jaWPXpSvFB9rxPvHMpCdqVa5uyhJ4fUNM4
	J4ZCcyze8Q==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 44k3f6g04q-17
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Mon, 03 Feb 2025 10:53:16 -0800 (PST)
Received: from twshared7122.08.ash9.facebook.com (2620:10d:c085:108::150d) by
 mail.thefacebook.com (2620:10d:c08b:78::c78f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.14; Mon, 3 Feb 2025 18:52:57 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id EEB09179C2638; Mon,  3 Feb 2025 10:41:34 -0800 (PST)
From: Keith Busch <kbusch@meta.com>
To: <linux-nvme@lists.infradead.org>, <io-uring@vger.kernel.org>,
        <linux-block@vger.kernel.org>
CC: <linux-fsdevel@vger.kernel.org>, <asml.silence@gmail.com>,
        <axboe@kernel.dk>, <hch@lst.de>, <sagi@grimberg.me>,
        Keith Busch
	<kbusch@kernel.org>, Hannes Reinecke <hare@suse.de>,
        Nitesh Shetty
	<nj.shetty@samsung.com>
Subject: [PATCHv2 10/11] nvme: register fdp parameters with the block layer
Date: Mon, 3 Feb 2025 10:41:28 -0800
Message-ID: <20250203184129.1829324-11-kbusch@meta.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250203184129.1829324-1-kbusch@meta.com>
References: <20250203184129.1829324-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 6v4OYMbc0DzwEXnKECvJMPFgW65oUKf_
X-Proofpoint-GUID: 6v4OYMbc0DzwEXnKECvJMPFgW65oUKf_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-03_08,2025-01-31_02,2024-11-22_01

From: Keith Busch <kbusch@kernel.org>

Register the device data placement limits if supported. This is just
registering the limits with the block layer. Nothing beyond reporting
these attributes is happening in this patch.

Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Nitesh Shetty <nj.shetty@samsung.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 drivers/nvme/host/core.c | 144 +++++++++++++++++++++++++++++++++++++++
 drivers/nvme/host/nvme.h |   2 +
 2 files changed, 146 insertions(+)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 324b31ba270a6..c8bc58b8ee3aa 100644
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
@@ -2156,6 +2160,132 @@ static int nvme_update_ns_info_generic(struct nvm=
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
+	h =3D kvmalloc(size, GFP_KERNEL);
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
@@ -2194,6 +2324,12 @@ static int nvme_update_ns_info_block(struct nvme_n=
s *ns,
=20
 	lim =3D queue_limits_start_update(ns->disk->queue);
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
@@ -2225,6 +2361,12 @@ static int nvme_update_ns_info_block(struct nvme_n=
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
@@ -2327,6 +2469,8 @@ static int nvme_update_ns_info(struct nvme_ns *ns, =
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
index 9c94c1085869b..b63164cf6b274 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -496,6 +496,8 @@ struct nvme_ns_head {
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


