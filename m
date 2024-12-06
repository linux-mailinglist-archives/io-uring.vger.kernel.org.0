Return-Path: <io-uring+bounces-5276-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E3AA49E7BA6
	for <lists+io-uring@lfdr.de>; Fri,  6 Dec 2024 23:24:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A42CA283BBC
	for <lists+io-uring@lfdr.de>; Fri,  6 Dec 2024 22:24:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63D0C203D45;
	Fri,  6 Dec 2024 22:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="KZ/WZCSS"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CA201714DF
	for <io-uring@vger.kernel.org>; Fri,  6 Dec 2024 22:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733523839; cv=none; b=baapU33FETHPJ4bhhbYGEcqXdw+vBnFRWWwoZHLaEGUBi/zNLHb8/hRcJvzCc5/FQMGofyRD1W+6zIJzf2JzYqHPxVHkXeZv9UfDZ2wL2Mp5TFUIM+9eKvqT8ny+4MHqpLhvYEMW/gBdnAo/dFovWzHrslRzhwQwl1qS6ad2ef8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733523839; c=relaxed/simple;
	bh=X03FMPt3YRruUGWT/ETkFQmoWtcDIiXUMKL9Tc4WryA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XN6OotNqLuCe5/V3Rum8hErl1y65+8VqPuUUmWmJTc5rtCBu6Kzg0gfVuoJ39lnoPMQzOkw88NX5i9SPVT6BPzv+7CZkfu+POZ82cmQGpKRqLU4xmwGEsEl1WooGJGHKVjjYDL30UkfOwQVMFF4Wj8tCM6UHhbO6At7QXUEBlG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=KZ/WZCSS; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4B6Lh29F015724
	for <io-uring@vger.kernel.org>; Fri, 6 Dec 2024 14:23:56 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2021-q4;
	 bh=/nE2U8jG/bZjifVEojFrO7fPI6rw7U6tKwDNJZHWRpQ=; b=KZ/WZCSSsx3B
	yv6GBsOv49NpVtTqF/lxgBegB1G2TPhxWdxv1Dw0Sp+m/bKxWjy3VdZ5wmSLIev2
	vaLFHK1/I1HhOtegUlCMiNk8ZZe1tMSYJAGLt3wDyANC5pVKiWvBYy1zOXrIrSSg
	0YAnmvfCkWZ7zPf8ZfQFUZZlpMUmi8C1EtCDevhzlYGmBiez0Pz6whtYXcoftneY
	KqTENp3ZEaZBzU+SDznOD80+fnfI2rsFqm5ek8MiL0uFWS4Io4R1ZzLjJLejQQVR
	nIyOSeLXt5jfmWUwWjtEimyIkiVk2iPdE1pzwEks7h4kyMPdSPb5LScNJ+7mZ4pL
	hBIMjRICLA==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 43c2xhbch6-4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Fri, 06 Dec 2024 14:23:56 -0800 (PST)
Received: from twshared9216.15.frc2.facebook.com (2620:10d:c0a8:1b::30) by
 mail.thefacebook.com (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.11; Fri, 6 Dec 2024 22:23:53 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id 7C16515B8CB94; Fri,  6 Dec 2024 14:18:27 -0800 (PST)
From: Keith Busch <kbusch@meta.com>
To: <axboe@kernel.dk>, <hch@lst.de>, <linux-block@vger.kernel.org>,
        <linux-nvme@lists.infradead.org>, <linux-fsdevel@vger.kernel.org>,
        <io-uring@vger.kernel.org>
CC: <sagi@grimberg.me>, <asml.silence@gmail.com>, <anuj20.g@samsung.com>,
        <joshi.k@samsung.com>, Keith Busch <kbusch@kernel.org>
Subject: [PATCHv12 12/12] nvme: use fdp streams if write stream is provided
Date: Fri, 6 Dec 2024 14:18:01 -0800
Message-ID: <20241206221801.790690-13-kbusch@meta.com>
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
X-Proofpoint-GUID: p1VKMUQy2q-hz887tJ8Fo6LCigkSLJCe
X-Proofpoint-ORIG-GUID: p1VKMUQy2q-hz887tJ8Fo6LCigkSLJCe
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-05_03,2024-10-04_01,2024-09-30_01

From: Keith Busch <kbusch@kernel.org>

Maps a user requested write stream to an FDP placement ID if possible.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 drivers/nvme/host/core.c | 32 +++++++++++++++++++++++++++++++-
 drivers/nvme/host/nvme.h |  1 +
 2 files changed, 32 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 5f802e243736a..63c8a117b3b4a 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -997,6 +997,18 @@ static inline blk_status_t nvme_setup_rw(struct nvme=
_ns *ns,
 	if (req->cmd_flags & REQ_RAHEAD)
 		dsmgmt |=3D NVME_RW_DSM_FREQ_PREFETCH;
=20
+	if (op =3D=3D nvme_cmd_write && ns->head->nr_plids) {
+		u16 write_stream =3D req->bio->bi_write_stream;
+
+		if (WARN_ON_ONCE(write_stream > ns->head->nr_plids))
+			return BLK_STS_INVAL;
+
+		if (write_stream) {
+			dsmgmt |=3D ns->head->plids[write_stream - 1] << 16;
+			control |=3D NVME_RW_DTYPE_DPLCMT;
+		}
+	}
+
 	if (req->cmd_flags & REQ_ATOMIC && !nvme_valid_atomic_write(req))
 		return BLK_STS_INVAL;
=20
@@ -2194,11 +2206,12 @@ static int nvme_check_fdp(struct nvme_ns *ns, str=
uct nvme_ns_info *info,
=20
 static int nvme_query_fdp_info(struct nvme_ns *ns, struct nvme_ns_info *=
info)
 {
+	struct nvme_fdp_ruh_status_desc *ruhsd;
 	struct nvme_ns_head *head =3D ns->head;
 	struct nvme_fdp_ruh_status *ruhs;
 	struct nvme_fdp_config fdp;
 	struct nvme_command c =3D {};
-	int size, ret;
+	int size, ret, i;
=20
 	ret =3D nvme_get_features(ns->ctrl, NVME_FEAT_FDP, info->endgid, NULL, =
0,
 				&fdp);
@@ -2231,6 +2244,19 @@ static int nvme_query_fdp_info(struct nvme_ns *ns,=
 struct nvme_ns_info *info)
 	if (!head->nr_plids)
 		goto free;
=20
+	head->nr_plids =3D min(head->nr_plids, NVME_MAX_PLIDS);
+	head->plids =3D kcalloc(head->nr_plids, sizeof(head->plids),
+			      GFP_KERNEL);
+	if (!head->plids) {
+		ret =3D -ENOMEM;
+		goto free;
+	}
+
+	for (i =3D 0; i < head->nr_plids; i++) {
+		ruhsd =3D &ruhs->ruhsd[i];
+		head->plids[i] =3D le16_to_cpu(ruhsd->pid);
+	}
+
 	kfree(ruhs);
 	return 0;
=20
@@ -2285,6 +2311,10 @@ static int nvme_update_ns_info_block(struct nvme_n=
s *ns,
 				"FDP failure status:0x%x\n", ret);
 		if (ret < 0)
 			goto out;
+	} else {
+		ns->head->nr_plids =3D 0;
+		kfree(ns->head->plids);
+		ns->head->plids =3D NULL;
 	}
=20
 	blk_mq_freeze_queue(ns->disk->queue);
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 914cc93e91f6d..49b234bfb42c4 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -495,6 +495,7 @@ struct nvme_ns_head {
 	struct gendisk		*disk;
=20
 	u16			nr_plids;
+	u16			*plids;
 #ifdef CONFIG_NVME_MULTIPATH
 	struct bio_list		requeue_list;
 	spinlock_t		requeue_lock;
--=20
2.43.5


