Return-Path: <io-uring+bounces-4827-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B35089D2595
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 13:21:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 14200B26A61
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 12:21:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D0351D0DDF;
	Tue, 19 Nov 2024 12:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="sZ8feOWB"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFB3C1CC88B;
	Tue, 19 Nov 2024 12:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732018637; cv=none; b=Miv0QstU9wBlJ8HG02aWMfIHvc+0ONO3yA29+o1GceGZEJiF8JFIVF2MhVq8CtUF+lBEn3YHL60Doocpwy+RcfXdu1asyCN6zwWxB3Y9dHMDfS9gA83HgtX5f0u59K1OKrehRcqcJHcnJMoOJ+WdUbvtexpso6LuyITen1Jmjyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732018637; c=relaxed/simple;
	bh=aqU70x+8JE4cK6pEiSOjRyQrfvHp/gG8+/zpYsNt59U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gdpjVCPOnM+jhWRkUYbCH86VZFxkOarOmUVCZ5Yjn10ZJeKOyXFp+Lo06h8BzMQ4tBdL3CeweNlQDPxQRx7ULu9E7viOwiD4YWUgUFtyLSA4TC24/sH9C+DKk8IWLnF98cdzFpeGdUSSMqzG4wKGDrp/uCN8PbuAkdsD0rOdZrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=sZ8feOWB; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=/D7d7RbaAdY6pT96Lch3FWUHj0+0Tnm1oMwJv1RL0mM=; b=sZ8feOWBJgRHUWno1tFS9M53vp
	n8Ne0smuC5Co1pbsKu/Sxz8ru8ylt9WMnskOaI8ADHHhH8i+pSgjsGBBEkSMTZKjvewKf1XOzMNXd
	TIIDeXkNKanZwBupnwGsm2fFB46hheCO3a0/cN+dNZyVgE9i8McMnM+Dg9zN6hudKqdGSfERFV5xC
	QaVZrezrNKWqKDEkRlgGw06X72NGWhPp82S5ziX1t16A1w7cTpueMIXtz8nXYgqk5S9HLHCIrwYpA
	fVKePr+y7rKngxqq/GkAn/ptLuWvIhMzPG3znieHHBzTNuD3qVqxX8m+9zw0RsnYx3docdAj1eDej
	7yYZ0J9Q==;
Received: from 2a02-8389-2341-5b80-1731-a089-d2b1-3edf.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:1731:a089:d2b1:3edf] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tDNAO-0000000CJJV-2vTw;
	Tue, 19 Nov 2024 12:17:13 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Christian Brauner <brauner@kernel.org>,
	Keith Busch <kbusch@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Hui Qi <hui81.qi@samsung.com>,
	Nitesh Shetty <nj.shetty@samsung.com>,
	Jan Kara <jack@suse.cz>,
	Pavel Begunkov <asml.silence@gmail.com>,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org
Subject: [PATCH 13/15] nvme.h: add FDP definitions
Date: Tue, 19 Nov 2024 13:16:27 +0100
Message-ID: <20241119121632.1225556-14-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241119121632.1225556-1-hch@lst.de>
References: <20241119121632.1225556-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Add the config feature result, config log page, and management receive
commands needed for FDP.

Partially based on a patch from Kanchan Joshi <joshi.k@samsung.com>.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/nvme.h | 77 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 77 insertions(+)

diff --git a/include/linux/nvme.h b/include/linux/nvme.h
index 0a6e22038ce3..0c4a81bf878e 100644
--- a/include/linux/nvme.h
+++ b/include/linux/nvme.h
@@ -275,6 +275,7 @@ enum nvme_ctrl_attr {
 	NVME_CTRL_ATTR_HID_128_BIT	= (1 << 0),
 	NVME_CTRL_ATTR_TBKAS		= (1 << 6),
 	NVME_CTRL_ATTR_ELBAS		= (1 << 15),
+	NVME_CTRL_ATTR_FDPS		= (1 << 19),
 };
 
 struct nvme_id_ctrl {
@@ -656,6 +657,44 @@ struct nvme_rotational_media_log {
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
+	__le16			size;
+	__u8			fdpa;
+	__u8			vss;
+	__le32			nrg;
+	__le16			nruh;
+	__le16			maxpids;
+	__le32			nnss;
+	__le64			runs;
+	__le32			erutl;
+	__u8			reserved[36];
+	struct nvme_fdp_ruh_desc ruhs[];
+};
+
+struct nvme_fdp_config_log {
+	__le16			n;
+	__u8			version;
+	__u8			reserved;
+	__le32			size;
+	__u8			reserved2[8];
+	/*
+	 * This is followed by variable number of nvme_fdp_config_desc
+	 * structures, but sparse doesn't like nested variable sized arrays.
+	 */
+};
+
 struct nvme_smart_log {
 	__u8			critical_warning;
 	__u8			temperature[2];
@@ -882,6 +921,7 @@ enum nvme_opcode {
 	nvme_cmd_resv_register	= 0x0d,
 	nvme_cmd_resv_report	= 0x0e,
 	nvme_cmd_resv_acquire	= 0x11,
+	nvme_cmd_io_mgmt_recv	= 0x12,
 	nvme_cmd_resv_release	= 0x15,
 	nvme_cmd_zone_mgmt_send	= 0x79,
 	nvme_cmd_zone_mgmt_recv	= 0x7a,
@@ -903,6 +943,7 @@ enum nvme_opcode {
 		nvme_opcode_name(nvme_cmd_resv_register),	\
 		nvme_opcode_name(nvme_cmd_resv_report),		\
 		nvme_opcode_name(nvme_cmd_resv_acquire),	\
+		nvme_opcode_name(nvme_cmd_io_mgmt_recv),	\
 		nvme_opcode_name(nvme_cmd_resv_release),	\
 		nvme_opcode_name(nvme_cmd_zone_mgmt_send),	\
 		nvme_opcode_name(nvme_cmd_zone_mgmt_recv),	\
@@ -1054,6 +1095,7 @@ enum {
 	NVME_RW_PRINFO_PRCHK_GUARD	= 1 << 12,
 	NVME_RW_PRINFO_PRACT		= 1 << 13,
 	NVME_RW_DTYPE_STREAMS		= 1 << 4,
+	NVME_RW_DTYPE_DPLCMT		= 2 << 4,
 	NVME_WZ_DEAC			= 1 << 9,
 };
 
@@ -1141,6 +1183,38 @@ struct nvme_zone_mgmt_recv_cmd {
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
@@ -1276,6 +1350,7 @@ enum {
 	NVME_FEAT_PLM_WINDOW	= 0x14,
 	NVME_FEAT_HOST_BEHAVIOR	= 0x16,
 	NVME_FEAT_SANITIZE	= 0x17,
+	NVME_FEAT_FDP		= 0x1d,
 	NVME_FEAT_SW_PROGRESS	= 0x80,
 	NVME_FEAT_HOST_ID	= 0x81,
 	NVME_FEAT_RESV_MASK	= 0x82,
@@ -1296,6 +1371,7 @@ enum {
 	NVME_LOG_ANA		= 0x0c,
 	NVME_LOG_FEATURES	= 0x12,
 	NVME_LOG_RMI		= 0x16,
+	NVME_LOG_FDP_CONFIGS	= 0x20,
 	NVME_LOG_DISC		= 0x70,
 	NVME_LOG_RESERVATION	= 0x80,
 	NVME_FWACT_REPL		= (0 << 3),
@@ -1883,6 +1959,7 @@ struct nvme_command {
 		struct nvmf_auth_receive_command auth_receive;
 		struct nvme_dbbuf dbbuf;
 		struct nvme_directive_cmd directive;
+		struct nvme_io_mgmt_recv_cmd imr;
 	};
 };
 
-- 
2.45.2


