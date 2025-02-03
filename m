Return-Path: <io-uring+bounces-6242-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FF67A26316
	for <lists+io-uring@lfdr.de>; Mon,  3 Feb 2025 19:53:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 092A01881935
	for <lists+io-uring@lfdr.de>; Mon,  3 Feb 2025 18:53:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5702F1CAA80;
	Mon,  3 Feb 2025 18:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="cmJuY00J"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E58D1CAA8F
	for <io-uring@vger.kernel.org>; Mon,  3 Feb 2025 18:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738608797; cv=none; b=gVwp4iIwlhoRZIni7LNGVzKZL1XiR5eqKkdGkBe0qDveovJ9HgZrBcyEFHCS+EVHFSJ6NbE0RWDRYRZdlexSWowkhZrdEfnfJbHpcxRrqZUIRt0dsMjxLPzkHC/bMmDNE0kZ3MeEbUmPa15coRtbp8e3hiMqAGpXCF85pLCroLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738608797; c=relaxed/simple;
	bh=NNZ2mDDltxQ3JAcgvMWq2vU8Ez6XuzoSFu9QtEsseHM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dyQujt8AmEcHAGkUAZLzhEcfeRsciiKVPkb03NZrjFom2/jeBvidMeCesYIKotFvsz4FZtiR7kKTN6Phck2MpGkZbsZrioDTCut1euaCJBs77SEA80EBAY6N3rqg5/u4sOloVlI3trPKp4xDu/0BRm2d0K6oWvfEPwrvowkznzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=cmJuY00J; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 513Iqjaf005147
	for <io-uring@vger.kernel.org>; Mon, 3 Feb 2025 10:53:14 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2021-q4;
	 bh=9flNTk3SjhSenvUMKVuno4iemuve4oEwOqiYTm3Uods=; b=cmJuY00J+3PQ
	KaPfF3ZF1xS+2rxEKAu967P7siO8nUdw9+0DOL6zjzV/vW9+GYK8We6M9r+oju+1
	Sx4uXOw6OiTBGStAT5gGVJEMxMjc/JB9emPnINWlIUpAWqw4DYlcDCCPdaydqj5B
	T7P5A7G4tMuVbkvN2Vym3pOOWxzQAGbguCt1Ca+f95x5LhliwmNd0eUUANgtN0jk
	8u1yvbExdCEFcfCbf9YKzcgviIJEJw+u3SvnP9n8cj6pUHbFexbS0Kv8SfC8RmYB
	eGlK7pti8nmblJPBy0KDT+pwHmy9C8o8+f6K91ax7PaWjbk+iUk/cBmm7BItT5gu
	IoSMEmA7JA==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 44k3f6g04q-13
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Mon, 03 Feb 2025 10:53:14 -0800 (PST)
Received: from twshared32179.32.frc3.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c08b:78::c78f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.14; Mon, 3 Feb 2025 18:52:52 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id DE67E179C2635; Mon,  3 Feb 2025 10:41:34 -0800 (PST)
From: Keith Busch <kbusch@meta.com>
To: <linux-nvme@lists.infradead.org>, <io-uring@vger.kernel.org>,
        <linux-block@vger.kernel.org>
CC: <linux-fsdevel@vger.kernel.org>, <asml.silence@gmail.com>,
        <axboe@kernel.dk>, <hch@lst.de>, <sagi@grimberg.me>,
        Hannes Reinecke
	<hare@suse.de>, Nitesh Shetty <nj.shetty@samsung.com>,
        Keith Busch
	<kbusch@kernel.org>
Subject: [PATCHv2 09/11] nvme: add FDP definitions
Date: Mon, 3 Feb 2025 10:41:27 -0800
Message-ID: <20250203184129.1829324-10-kbusch@meta.com>
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
X-Proofpoint-ORIG-GUID: 105iygOxSp-ycBI4i8YswkNHKP8ntkDf
X-Proofpoint-GUID: 105iygOxSp-ycBI4i8YswkNHKP8ntkDf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-03_08,2025-01-31_02,2024-11-22_01

From: Christoph Hellwig <hch@lst.de>

Add the config feature result, config log page, and management receive
commands needed for FDP.

Partially based on a patch from Kanchan Joshi <joshi.k@samsung.com>.

Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Nitesh Shetty <nj.shetty@samsung.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 include/linux/nvme.h | 77 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 77 insertions(+)

diff --git a/include/linux/nvme.h b/include/linux/nvme.h
index fe3b60818fdcf..96962c95b7d12 100644
--- a/include/linux/nvme.h
+++ b/include/linux/nvme.h
@@ -277,6 +277,7 @@ enum nvme_ctrl_attr {
 	NVME_CTRL_ATTR_TBKAS		=3D (1 << 6),
 	NVME_CTRL_ATTR_ELBAS		=3D (1 << 15),
 	NVME_CTRL_ATTR_RHII		=3D (1 << 18),
+	NVME_CTRL_ATTR_FDPS		=3D (1 << 19),
 };
=20
 struct nvme_id_ctrl {
@@ -663,6 +664,44 @@ struct nvme_rotational_media_log {
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
@@ -889,6 +928,7 @@ enum nvme_opcode {
 	nvme_cmd_resv_register	=3D 0x0d,
 	nvme_cmd_resv_report	=3D 0x0e,
 	nvme_cmd_resv_acquire	=3D 0x11,
+	nvme_cmd_io_mgmt_recv	=3D 0x12,
 	nvme_cmd_resv_release	=3D 0x15,
 	nvme_cmd_zone_mgmt_send	=3D 0x79,
 	nvme_cmd_zone_mgmt_recv	=3D 0x7a,
@@ -910,6 +950,7 @@ enum nvme_opcode {
 		nvme_opcode_name(nvme_cmd_resv_register),	\
 		nvme_opcode_name(nvme_cmd_resv_report),		\
 		nvme_opcode_name(nvme_cmd_resv_acquire),	\
+		nvme_opcode_name(nvme_cmd_io_mgmt_recv),	\
 		nvme_opcode_name(nvme_cmd_resv_release),	\
 		nvme_opcode_name(nvme_cmd_zone_mgmt_send),	\
 		nvme_opcode_name(nvme_cmd_zone_mgmt_recv),	\
@@ -1061,6 +1102,7 @@ enum {
 	NVME_RW_PRINFO_PRCHK_GUARD	=3D 1 << 12,
 	NVME_RW_PRINFO_PRACT		=3D 1 << 13,
 	NVME_RW_DTYPE_STREAMS		=3D 1 << 4,
+	NVME_RW_DTYPE_DPLCMT		=3D 2 << 4,
 	NVME_WZ_DEAC			=3D 1 << 9,
 };
=20
@@ -1148,6 +1190,38 @@ struct nvme_zone_mgmt_recv_cmd {
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
@@ -1283,6 +1357,7 @@ enum {
 	NVME_FEAT_PLM_WINDOW	=3D 0x14,
 	NVME_FEAT_HOST_BEHAVIOR	=3D 0x16,
 	NVME_FEAT_SANITIZE	=3D 0x17,
+	NVME_FEAT_FDP		=3D 0x1d,
 	NVME_FEAT_SW_PROGRESS	=3D 0x80,
 	NVME_FEAT_HOST_ID	=3D 0x81,
 	NVME_FEAT_RESV_MASK	=3D 0x82,
@@ -1303,6 +1378,7 @@ enum {
 	NVME_LOG_ANA		=3D 0x0c,
 	NVME_LOG_FEATURES	=3D 0x12,
 	NVME_LOG_RMI		=3D 0x16,
+	NVME_LOG_FDP_CONFIGS	=3D 0x20,
 	NVME_LOG_DISC		=3D 0x70,
 	NVME_LOG_RESERVATION	=3D 0x80,
 	NVME_FWACT_REPL		=3D (0 << 3),
@@ -1890,6 +1966,7 @@ struct nvme_command {
 		struct nvmf_auth_receive_command auth_receive;
 		struct nvme_dbbuf dbbuf;
 		struct nvme_directive_cmd directive;
+		struct nvme_io_mgmt_recv_cmd imr;
 	};
 };
=20
--=20
2.43.5


