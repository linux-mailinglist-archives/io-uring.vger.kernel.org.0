Return-Path: <io-uring+bounces-7853-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 134EEAAC41D
	for <lists+io-uring@lfdr.de>; Tue,  6 May 2025 14:31:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0C1BC1C27484
	for <lists+io-uring@lfdr.de>; Tue,  6 May 2025 12:31:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 845912853E6;
	Tue,  6 May 2025 12:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Cfg59xa3"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F26A428153A
	for <io-uring@vger.kernel.org>; Tue,  6 May 2025 12:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746534416; cv=none; b=c2Evd+SBfhKvmecOVrOfu6resTwJO3tRFoYxg69OTcBS6EJcXxX3nmIdJj5I1lKOPXGZw3sqTGEA1LlfRVJXhFD64WraD5gJ2EcKNNSiUBIiW2QgfbBCd2tHgXOXSSGNE+6/+7b+ujPYkhlACUK0yADM4HFChYrMVCeicmjS54U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746534416; c=relaxed/simple;
	bh=7sLPRrU3oIzJC/KkjNaKpExR9NAtaXcX6VWwAPNpNZQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=jD6KTNQfIFyYYcQfdfV7lcLEmPmXrW7rpdzRdLi9dp19fotMavYW+90TsYFfjIcXZgBtpHd/fE7z4fNUOo2o6TZFUvUmPWsTTVyAnv/EMMBUiZ9qkLUsc4xVXk41Niv3Z4mXs9ve4aSv9KjJW6iSfnau0WqgJ7B1nCnHXYP6mM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=Cfg59xa3; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20250506122652epoutp02afb49851c1ea58fcd5840da56c3f6131~878tVbneh0500105001epoutp02H
	for <io-uring@vger.kernel.org>; Tue,  6 May 2025 12:26:52 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20250506122652epoutp02afb49851c1ea58fcd5840da56c3f6131~878tVbneh0500105001epoutp02H
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1746534412;
	bh=hQ558UFkkMsgoK6EW4IQmznV6d1CVID5eydr5s05kY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cfg59xa3E6AfPczKMPOhnex/YzGyvOFd8pYNaJUVDkaLHyLk56DD1RCDNfvm9tVHT
	 Dg8kPMsHcsVlR6A9MYpKGEIjIpQwvxgMZJtl5ZekbKuvIuQfoVHQVnCvNbCBck7oYi
	 TjdufjL96SqnKtaQP+KdF8W/JK/hKLBrkyTsqwak=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20250506122651epcas5p4b369a38a55dd499052ac2efc71cf593a~878sqOBer2065220652epcas5p48;
	Tue,  6 May 2025 12:26:51 +0000 (GMT)
Received: from epcas5p3.samsung.com (unknown [182.195.38.175]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4ZsHhB17Dhz2SSKY; Tue,  6 May
	2025 12:26:50 +0000 (GMT)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20250506122649epcas5p1294652bcfc93f08dd12e6ba8a497c55b~878rBbl4u0911609116epcas5p1B;
	Tue,  6 May 2025 12:26:49 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20250506122649epsmtrp262ea50c65204de25f1f3a186110a90ed~878rAuOmx0521905219epsmtrp2X;
	Tue,  6 May 2025 12:26:49 +0000 (GMT)
X-AuditID: b6c32a2a-d63ff70000002265-6a-681a00096753
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	33.6E.08805.9000A186; Tue,  6 May 2025 21:26:49 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250506122647epsmtip2ed850290d0cc40fa92afdf6e15605f31~878pcVnnz1679416794epsmtip2e;
	Tue,  6 May 2025 12:26:47 +0000 (GMT)
From: Kanchan Joshi <joshi.k@samsung.com>
To: axboe@kernel.dk, kbusch@kernel.org, hch@lst.de, asml.silence@gmail.com
Cc: io-uring@vger.kernel.org, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-nvme@lists.infradead.org, Hannes
	Reinecke <hare@suse.de>, Nitesh Shetty <nj.shetty@samsung.com>, Kanchan
	Joshi <joshi.k@samsung.com>
Subject: [PATCH v16 09/11] nvme: add FDP definitions
Date: Tue,  6 May 2025 17:47:30 +0530
Message-Id: <20250506121732.8211-10-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250506121732.8211-1-joshi.k@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKLMWRmVeSWpSXmKPExsWy7bCSvC4ng1SGwdnXihZzVm1jtFh9t5/N
	Ys+iSUwWK1cfZbJ413qOxeLo/7dsFpMOXWO02HtL22LP3pMsFvOXPWW32PZ7PrMDt8fOWXfZ
	PS6fLfXYtKqTzWPzknqP3Tcb2Dz6tqxi9Nh8utrj8ya5AI4oLpuU1JzMstQifbsErozOk8tY
	Cw4pVJz7P425gfGyZBcjJ4eEgInEtmkzmLsYuTiEBHYzSnydsZMFIiEu0XztBzuELSyx8t9z
	doiij4wSE16cY+1i5OBgE9CUuDC5FKRGRCBA4uXix2CDmAU+MErsmTibESQhDLLhwDawehYB
	VYkJG3lAwrwCFhIbbpxmhZgvLzHz0newXZxA8eV7ZoG1CgmYS7w4eoQdol5Q4uTMJ2C3MQPV
	N2+dzTyBUWAWktQsJKkFjEyrGCVTC4pz03OLDQuM8lLL9YoTc4tL89L1kvNzNzGCY0JLawfj
	nlUf9A4xMnEwHmKU4GBWEuG9f18yQ4g3JbGyKrUoP76oNCe1+BCjNAeLkjjvt9e9KUIC6Ykl
	qdmpqQWpRTBZJg5OqQamIu8AN32DznWH/x/mf30/VS5y9r+FTj8KLEOm9xS3PTnixu+ylnOX
	8nyFkwf1X72XWH7o12kOgRymJOFbvWyiJ5km2Vwt+XXqmLG+9QzVaZOUT5w6tmK6dtaWXeve
	ZXu7Rflp3fuQ2Hb3SdPz2P7XQbazp7412OzwWlqaVf3tmm/FE9cJxnJNvuC8avfXswn3jbpf
	Kh1Mmv8w7sT5c60S9cud/detuCTrvKek1PTopHSh8xKTvmvaPoia/trXf5LfjG0OHs9EQg0m
	uiV2udyX82/UW7B2dcg+nhcPC+QdTd6fmsjKbjDhduLFP5H7z2clvV7q/uvPZO1pF+dcOKp5
	UXu3X7Hbz0ezbHV327+LOqHEUpyRaKjFXFScCABw252y+AIAAA==
X-CMS-MailID: 20250506122649epcas5p1294652bcfc93f08dd12e6ba8a497c55b
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250506122649epcas5p1294652bcfc93f08dd12e6ba8a497c55b
References: <20250506121732.8211-1-joshi.k@samsung.com>
	<CGME20250506122649epcas5p1294652bcfc93f08dd12e6ba8a497c55b@epcas5p1.samsung.com>

From: Christoph Hellwig <hch@lst.de>

Add the config feature result, config log page, and management receive
commands needed for FDP.

Partially based on a patch from Kanchan Joshi <joshi.k@samsung.com>.

Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Nitesh Shetty <nj.shetty@samsung.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 include/linux/nvme.h | 77 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 77 insertions(+)

diff --git a/include/linux/nvme.h b/include/linux/nvme.h
index 2479ed10f53e..51308f65b72f 100644
--- a/include/linux/nvme.h
+++ b/include/linux/nvme.h
@@ -303,6 +303,7 @@ enum nvme_ctrl_attr {
 	NVME_CTRL_ATTR_TBKAS		= (1 << 6),
 	NVME_CTRL_ATTR_ELBAS		= (1 << 15),
 	NVME_CTRL_ATTR_RHII		= (1 << 18),
+	NVME_CTRL_ATTR_FDPS		= (1 << 19),
 };
 
 struct nvme_id_ctrl {
@@ -689,6 +690,44 @@ struct nvme_rotational_media_log {
 	__u8	rsvd24[488];
 };
 
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
@@ -915,6 +954,7 @@ enum nvme_opcode {
 	nvme_cmd_resv_register	= 0x0d,
 	nvme_cmd_resv_report	= 0x0e,
 	nvme_cmd_resv_acquire	= 0x11,
+	nvme_cmd_io_mgmt_recv	= 0x12,
 	nvme_cmd_resv_release	= 0x15,
 	nvme_cmd_zone_mgmt_send	= 0x79,
 	nvme_cmd_zone_mgmt_recv	= 0x7a,
@@ -936,6 +976,7 @@ enum nvme_opcode {
 		nvme_opcode_name(nvme_cmd_resv_register),	\
 		nvme_opcode_name(nvme_cmd_resv_report),		\
 		nvme_opcode_name(nvme_cmd_resv_acquire),	\
+		nvme_opcode_name(nvme_cmd_io_mgmt_recv),	\
 		nvme_opcode_name(nvme_cmd_resv_release),	\
 		nvme_opcode_name(nvme_cmd_zone_mgmt_send),	\
 		nvme_opcode_name(nvme_cmd_zone_mgmt_recv),	\
@@ -1087,6 +1128,7 @@ enum {
 	NVME_RW_PRINFO_PRCHK_GUARD	= 1 << 12,
 	NVME_RW_PRINFO_PRACT		= 1 << 13,
 	NVME_RW_DTYPE_STREAMS		= 1 << 4,
+	NVME_RW_DTYPE_DPLCMT		= 2 << 4,
 	NVME_WZ_DEAC			= 1 << 9,
 };
 
@@ -1174,6 +1216,38 @@ struct nvme_zone_mgmt_recv_cmd {
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
+enum {
+	NVME_IO_MGMT_RECV_MO_RUHS	= 1,
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
 	NVME_ZRA_ZONE_REPORT		= 0,
 	NVME_ZRASF_ZONE_REPORT_ALL	= 0,
@@ -1309,6 +1383,7 @@ enum {
 	NVME_FEAT_PLM_WINDOW	= 0x14,
 	NVME_FEAT_HOST_BEHAVIOR	= 0x16,
 	NVME_FEAT_SANITIZE	= 0x17,
+	NVME_FEAT_FDP		= 0x1d,
 	NVME_FEAT_SW_PROGRESS	= 0x80,
 	NVME_FEAT_HOST_ID	= 0x81,
 	NVME_FEAT_RESV_MASK	= 0x82,
@@ -1329,6 +1404,7 @@ enum {
 	NVME_LOG_ANA		= 0x0c,
 	NVME_LOG_FEATURES	= 0x12,
 	NVME_LOG_RMI		= 0x16,
+	NVME_LOG_FDP_CONFIGS	= 0x20,
 	NVME_LOG_DISC		= 0x70,
 	NVME_LOG_RESERVATION	= 0x80,
 	NVME_FWACT_REPL		= (0 << 3),
@@ -1923,6 +1999,7 @@ struct nvme_command {
 		struct nvmf_auth_receive_command auth_receive;
 		struct nvme_dbbuf dbbuf;
 		struct nvme_directive_cmd directive;
+		struct nvme_io_mgmt_recv_cmd imr;
 	};
 };
 
-- 
2.25.1


