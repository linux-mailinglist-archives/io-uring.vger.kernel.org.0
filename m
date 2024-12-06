Return-Path: <io-uring+bounces-5262-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 532719E63BF
	for <lists+io-uring@lfdr.de>; Fri,  6 Dec 2024 02:54:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B93C716A721
	for <lists+io-uring@lfdr.de>; Fri,  6 Dec 2024 01:54:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C2F61714A1;
	Fri,  6 Dec 2024 01:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="QpbdAmJk"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A1F7154C12
	for <io-uring@vger.kernel.org>; Fri,  6 Dec 2024 01:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733450016; cv=none; b=hJhGDzMB+KhzfpCR2JX94jQY/bJIIh/nbjaVt9UNHKKdsiAcAo/ZbTAaADHGkFysw6m9rz80Cp/1nBhPa0d5q1Mk4CJ131nnZDXZTjOVJQvWcvFqaxL0ENV2YFihxdFcTTcw7PFOyULFap4AHWiPDzp4NsaKan2Qj04BugCzCfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733450016; c=relaxed/simple;
	bh=a6bic9lWReIENxTHeZoG8ChH6lXRFB7Rkje1NanJ8/Q=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fXxudbw0kbzeBOBC8wuEFihRxoVbFDGmmFzvrWr2tOHlNbU2XQ2A93nvZFButYq8aw7M0IfyqlzHy1BRYTrjXCIwcgnwHoLPTpWRVGUJgvLQr7kYaM6Ha7UxwpB/RIzzoRms9Otd78leYfZ+o7ra/7qgAV+8DzeNFSy3qsWqw7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=QpbdAmJk; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4B603MMu014363
	for <io-uring@vger.kernel.org>; Thu, 5 Dec 2024 17:53:33 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2021-q4;
	 bh=aqSWgHfWMagd/tVBxU1j+3PESQendeFXQhXEUWomWZI=; b=QpbdAmJkjzgF
	iYh3gGcrBDjNQGDCBSqOonvTJo9dHOHxO5skvx61cilBsjAGLYhg2i0kDvjAutvl
	TB0NzDbaLrSj2TftKl5ETJu05MWWmf2dFjLDCff1rI/r4o+1Xp9067sHobFlgQWg
	lqTVpswYJE4snjQ8YP5gn0GVukU95RqiZNroCilgxmIq4Vp1O4YVu54Jf/Vub8uV
	5QhzQfUWj93gckRapfcZVqQ6+/PxLBeQhIkjYaR4vDpXKCzdDs7D201SX1s4Zzio
	JeNOSvGY8o3KkBYxu68SyLYzlY39I2LRJLa3XJDp3C95Z96RqU2sgSfJKJFJFTk8
	4EB0Rqbe9w==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 43bmru153t-6
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Thu, 05 Dec 2024 17:53:33 -0800 (PST)
Received: from twshared11082.06.ash8.facebook.com (2620:10d:c085:108::150d) by
 mail.thefacebook.com (2620:10d:c08b:78::c78f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.11; Fri, 6 Dec 2024 01:53:24 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id 4791315B2115A; Thu,  5 Dec 2024 17:53:09 -0800 (PST)
From: Keith Busch <kbusch@meta.com>
To: <axboe@kernel.dk>, <hch@lst.de>, <linux-block@vger.kernel.org>,
        <linux-nvme@lists.infradead.org>, <linux-fsdevel@vger.kernel.org>,
        <io-uring@vger.kernel.org>
CC: <sagi@grimberg.me>, <asml.silence@gmail.com>,
        Keith Busch
	<kbusch@kernel.org>
Subject: [PATCHv11 08/10] nvme: add a nvme_get_log_lsi helper
Date: Thu, 5 Dec 2024 17:53:06 -0800
Message-ID: <20241206015308.3342386-9-kbusch@meta.com>
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
X-Proofpoint-GUID: BaZd6h2OjSefDJpd1nWSwrMN8GDFKetf
X-Proofpoint-ORIG-GUID: BaZd6h2OjSefDJpd1nWSwrMN8GDFKetf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-05_03,2024-10-04_01,2024-09-30_01

From: Christoph Hellwig <hch@lst.de>

For log pages that need to pass in a LSI value, while at the same time
not touching all the existing nvme_get_log callers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 drivers/nvme/host/core.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 571d4106d256d..36c44be98e38c 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -150,6 +150,8 @@ static void nvme_remove_invalid_namespaces(struct nvm=
e_ctrl *ctrl,
 					   unsigned nsid);
 static void nvme_update_keep_alive(struct nvme_ctrl *ctrl,
 				   struct nvme_command *cmd);
+static int nvme_get_log_lsi(struct nvme_ctrl *ctrl, u32 nsid, u8 log_pag=
e,
+		u8 lsp, u8 csi, void *log, size_t size, u64 offset, u16 lsi);
=20
 void nvme_queue_scan(struct nvme_ctrl *ctrl)
 {
@@ -3074,8 +3076,8 @@ static int nvme_init_subsystem(struct nvme_ctrl *ct=
rl, struct nvme_id_ctrl *id)
 	return ret;
 }
=20
-int nvme_get_log(struct nvme_ctrl *ctrl, u32 nsid, u8 log_page, u8 lsp, =
u8 csi,
-		void *log, size_t size, u64 offset)
+static int nvme_get_log_lsi(struct nvme_ctrl *ctrl, u32 nsid, u8 log_pag=
e,
+		u8 lsp, u8 csi, void *log, size_t size, u64 offset, u16 lsi)
 {
 	struct nvme_command c =3D { };
 	u32 dwlen =3D nvme_bytes_to_numd(size);
@@ -3089,10 +3091,18 @@ int nvme_get_log(struct nvme_ctrl *ctrl, u32 nsid=
, u8 log_page, u8 lsp, u8 csi,
 	c.get_log_page.lpol =3D cpu_to_le32(lower_32_bits(offset));
 	c.get_log_page.lpou =3D cpu_to_le32(upper_32_bits(offset));
 	c.get_log_page.csi =3D csi;
+	c.get_log_page.lsi =3D cpu_to_le16(lsi);
=20
 	return nvme_submit_sync_cmd(ctrl->admin_q, &c, log, size);
 }
=20
+int nvme_get_log(struct nvme_ctrl *ctrl, u32 nsid, u8 log_page, u8 lsp, =
u8 csi,
+		void *log, size_t size, u64 offset)
+{
+	return nvme_get_log_lsi(ctrl, nsid, log_page, lsp, csi, log, size,
+			offset, 0);
+}
+
 static int nvme_get_effects_log(struct nvme_ctrl *ctrl, u8 csi,
 				struct nvme_effects_log **log)
 {
--=20
2.43.5


