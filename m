Return-Path: <io-uring+bounces-5288-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D94469E7BDB
	for <lists+io-uring@lfdr.de>; Fri,  6 Dec 2024 23:36:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 61021284080
	for <lists+io-uring@lfdr.de>; Fri,  6 Dec 2024 22:36:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E0021FBEAF;
	Fri,  6 Dec 2024 22:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="H9nCgfup"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28A7622C6D9
	for <io-uring@vger.kernel.org>; Fri,  6 Dec 2024 22:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733524598; cv=none; b=r7LdjTR1s83I07ln9bbaUcP4osuZDlrjJ54j1pjn6fEyq+GsNRaLpLg1tjYk1/zIYIgz/pJ545oZTNvP9aor2uw89Y5wuX7/EgGFh10OqE6a1D25g4uztYXTV7mgzY4wKLuRtj3HvDeqY+JBf3mkDTB48q9nbwrwXhDgN+YzyqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733524598; c=relaxed/simple;
	bh=roA9MJz3NEVEn2KFgHV5G25yCwgCNSCbMZDFMHVZt7E=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eoEO0r58kEH9Nkdo95qam6x4y7Cc7WYgLbdCImIS/RqmwEE4csTTQdtvAoZNZsDk/67nbSQBwa90jvetVW4V6NC/K1KHccUzDe+mZjL+Sr6DtL6YJ1PUEcf7Kw7V6jB5CiWfKdXk9TeNa8iCBSOnYhYzr3EegQ6Vn0zHjSikHuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=H9nCgfup; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4B6MaRT4002274
	for <io-uring@vger.kernel.org>; Fri, 6 Dec 2024 14:36:35 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2021-q4;
	 bh=l06P/hzIb97V1tm7MFuefws7PCOG+jrPqbqmapoufhw=; b=H9nCgfuppHs9
	hH8SeWLqrynsFmxL5Eb7peZGx08lADHP80Bh6nC/2gVJVWQAtHR7VSSf6R8HjgwN
	iB3Lld3YJ2EAoHNSFdGh+Oq2Jqv3mo3LvjIljO2oY2XkiJRUw2f6NwSKGQ5+mmK4
	ClvyoQYL4SnAhhpt2tlj4e4TqIva6xJzpjODbVDSZHDfNkbj33lGxxqmCATyh1gn
	qENl/EdbEzdioLhsXSvS1GLdxCzoKAgkejXg++TmMtp/MxSR/oFdzHDUwbf04gzn
	8vmj+cyU3fj0cJMnFQFtjoYbN0A8MirAv8yrupl8CSffDdrNWt3hZFxPTNQlRTqh
	iH5sLdaBWw==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 43c8kv8nyk-9
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Fri, 06 Dec 2024 14:36:34 -0800 (PST)
Received: from twshared7122.08.ash9.facebook.com (2620:10d:c0a8:1c::1b) by
 mail.thefacebook.com (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.11; Fri, 6 Dec 2024 22:35:50 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id 5FAD215B8CB8A; Fri,  6 Dec 2024 14:18:27 -0800 (PST)
From: Keith Busch <kbusch@meta.com>
To: <axboe@kernel.dk>, <hch@lst.de>, <linux-block@vger.kernel.org>,
        <linux-nvme@lists.infradead.org>, <linux-fsdevel@vger.kernel.org>,
        <io-uring@vger.kernel.org>
CC: <sagi@grimberg.me>, <asml.silence@gmail.com>, <anuj20.g@samsung.com>,
        <joshi.k@samsung.com>, Keith Busch <kbusch@kernel.org>
Subject: [PATCHv12 10/12] nvme.h: add FDP definitions
Date: Fri, 6 Dec 2024 14:17:59 -0800
Message-ID: <20241206221801.790690-11-kbusch@meta.com>
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
X-Proofpoint-GUID: 4aJHk2y7URpnKGrHIVTicpylTvWVeuIQ
X-Proofpoint-ORIG-GUID: 4aJHk2y7URpnKGrHIVTicpylTvWVeuIQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-05_03,2024-10-04_01,2024-09-30_01

From: Christoph Hellwig <hch@lst.de>

Add the config feature result, config log page, and management receive
commands needed for FDP.

Partially based on a patch from Kanchan Joshi <joshi.k@samsung.com>.

Signed-off-by: Christoph Hellwig <hch@lst.de>
[kbusch: renamed some fields to match spec]
Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 include/linux/nvme.h | 77 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 77 insertions(+)

diff --git a/include/linux/nvme.h b/include/linux/nvme.h
index 13377dde4527b..7680078fa67fd 100644
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
@@ -661,6 +662,44 @@ struct nvme_rotational_media_log {
 	__u8	rsvd24[488];
 };
=20
+struct nvme_fdp_config {
+	__u8			flags;
+#define FDPCFG_FDPE	(1U << 0)
+	__u8			fdpcidx;
+	__le16			reserved;
+};
+
+struct nvme_fdp_ruh_desc {
+	__u8			ruht;
+	__u8			reserved[3];
+};
+
+struct nvme_fdp_config_desc {
+	__le16			dsze;
+	__u8			fdpa;
+	__u8			vss;
+	__le32			nrg;
+	__le16			nruh;
+	__le16			maxpids;
+	__le32			nns;
+	__le64			runs;
+	__le32			erutl;
+	__u8			rsvd28[36];
+	struct nvme_fdp_ruh_desc ruhs[];
+};
+
+struct nvme_fdp_config_log {
+	__le16			numfdpc;
+	__u8			ver;
+	__u8			rsvd3;
+	__le32			sze;
+	__u8			rsvd8[8];
+	/*
+	 * This is followed by variable number of nvme_fdp_config_desc
+	 * structures, but sparse doesn't like nested variable sized arrays.
+	 */
+};
+
 struct nvme_smart_log {
 	__u8			critical_warning;
 	__u8			temperature[2];
@@ -887,6 +926,7 @@ enum nvme_opcode {
 	nvme_cmd_resv_register	=3D 0x0d,
 	nvme_cmd_resv_report	=3D 0x0e,
 	nvme_cmd_resv_acquire	=3D 0x11,
+	nvme_cmd_io_mgmt_recv	=3D 0x12,
 	nvme_cmd_resv_release	=3D 0x15,
 	nvme_cmd_zone_mgmt_send	=3D 0x79,
 	nvme_cmd_zone_mgmt_recv	=3D 0x7a,
@@ -908,6 +948,7 @@ enum nvme_opcode {
 		nvme_opcode_name(nvme_cmd_resv_register),	\
 		nvme_opcode_name(nvme_cmd_resv_report),		\
 		nvme_opcode_name(nvme_cmd_resv_acquire),	\
+		nvme_opcode_name(nvme_cmd_io_mgmt_recv),	\
 		nvme_opcode_name(nvme_cmd_resv_release),	\
 		nvme_opcode_name(nvme_cmd_zone_mgmt_send),	\
 		nvme_opcode_name(nvme_cmd_zone_mgmt_recv),	\
@@ -1059,6 +1100,7 @@ enum {
 	NVME_RW_PRINFO_PRCHK_GUARD	=3D 1 << 12,
 	NVME_RW_PRINFO_PRACT		=3D 1 << 13,
 	NVME_RW_DTYPE_STREAMS		=3D 1 << 4,
+	NVME_RW_DTYPE_DPLCMT		=3D 2 << 4,
 	NVME_WZ_DEAC			=3D 1 << 9,
 };
=20
@@ -1146,6 +1188,38 @@ struct nvme_zone_mgmt_recv_cmd {
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
+	__le16			pid;
+	__le16			ruhid;
+	__le32			earutr;
+	__le64			ruamw;
+	__u8			reserved[16];
+};
+
+struct nvme_fdp_ruh_status {
+	__u8			rsvd0[14];
+	__le16			nruhsd;
+	struct nvme_fdp_ruh_status_desc ruhsd[];
+};
+
 enum {
 	NVME_ZRA_ZONE_REPORT		=3D 0,
 	NVME_ZRASF_ZONE_REPORT_ALL	=3D 0,
@@ -1281,6 +1355,7 @@ enum {
 	NVME_FEAT_PLM_WINDOW	=3D 0x14,
 	NVME_FEAT_HOST_BEHAVIOR	=3D 0x16,
 	NVME_FEAT_SANITIZE	=3D 0x17,
+	NVME_FEAT_FDP		=3D 0x1d,
 	NVME_FEAT_SW_PROGRESS	=3D 0x80,
 	NVME_FEAT_HOST_ID	=3D 0x81,
 	NVME_FEAT_RESV_MASK	=3D 0x82,
@@ -1301,6 +1376,7 @@ enum {
 	NVME_LOG_ANA		=3D 0x0c,
 	NVME_LOG_FEATURES	=3D 0x12,
 	NVME_LOG_RMI		=3D 0x16,
+	NVME_LOG_FDP_CONFIGS	=3D 0x20,
 	NVME_LOG_DISC		=3D 0x70,
 	NVME_LOG_RESERVATION	=3D 0x80,
 	NVME_FWACT_REPL		=3D (0 << 3),
@@ -1888,6 +1964,7 @@ struct nvme_command {
 		struct nvmf_auth_receive_command auth_receive;
 		struct nvme_dbbuf dbbuf;
 		struct nvme_directive_cmd directive;
+		struct nvme_io_mgmt_recv_cmd imr;
 	};
 };
=20
--=20
2.43.5


