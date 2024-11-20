Return-Path: <io-uring+bounces-4875-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 385C69D3F99
	for <lists+io-uring@lfdr.de>; Wed, 20 Nov 2024 17:03:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F1ADB283DF2
	for <lists+io-uring@lfdr.de>; Wed, 20 Nov 2024 16:03:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93035154439;
	Wed, 20 Nov 2024 16:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b="qANyVPnD"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECBD614F9F3
	for <io-uring@vger.kernel.org>; Wed, 20 Nov 2024 16:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732118571; cv=none; b=ISVKv8G7LZG06xFk6hFAsUGrH8N+eYYSkaGpJlMKdkZT3WhweN33xsXObsMRPKn/l/7Qcuy8KmrRB6LX+jkS9na7TtHD638qQypsaT908h/uC2H6RtJGdiHZnMrq/wHJkDSGb1BqVZWl1bJSWlq8IfUg3795Ara0OP99aWF7asQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732118571; c=relaxed/simple;
	bh=G8z/M1kChHgPyNMw/9pKFuBFRyCJ96/4TDuz3XBMUeU=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Zp1w4+OdZTGRt+9GL+QbtB484w+CRBNGHucSS2vfg3PpqC6jm3ZeRYrXU5tXMDUGcdiaEUJMknknqS/iCMo874xa2yTy2viK2ys75gn/QUJ+tHO4TRWAwNrLVKSYt7xntgjhowp5tFXSNWIzff9qOU0dV8J3P1eUswZLEqNtEl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b=qANyVPnD; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AKEoVAd025849
	for <io-uring@vger.kernel.org>; Wed, 20 Nov 2024 08:02:49 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=facebook; bh=KgEEX7cGkZNkZVS8c3cuZuK
	Vnj1d4xHiRDgJpKqhPkA=; b=qANyVPnDv49+iCWhVBEibBI76g/uRDQbDcqwtLR
	ccVOZaGIcXqHqtbDaTtymFe25cY4vHaSwcTqmHpgWPBb7BnY+vulZARLthMIsIcL
	7AAYx8SN5VU3J9EBjgOVBJ/SsU9B6R0si/0X3UJ3rAji7Y1GJaf06pZBdHhx/oD0
	UcZM=
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 431dmc9xem-9
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Wed, 20 Nov 2024 08:02:48 -0800 (PST)
Received: from twshared35181.07.ash9.facebook.com (2620:10d:c085:208::7cb7) by
 mail.thefacebook.com (2620:10d:c08b:78::c78f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.11; Wed, 20 Nov 2024 16:02:44 +0000
Received: by devbig276.nha1.facebook.com (Postfix, from userid 660015)
	id C47138D1CF05; Wed, 20 Nov 2024 16:02:35 +0000 (GMT)
From: Mark Harmstone <maharmstone@fb.com>
To: <linux-btrfs@vger.kernel.org>, <io-uring@vger.kernel.org>
CC: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/4] io_uring/cmd: rename struct uring_cache to io_uring_cmd_data
Date: Wed, 20 Nov 2024 16:02:19 +0000
Message-ID: <20241120160231.1106844-1-maharmstone@fb.com>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: G1ghU4wnmNWpth6Lr4_RQCdGeIzmhMXQ
X-Proofpoint-GUID: G1ghU4wnmNWpth6Lr4_RQCdGeIzmhMXQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-05_03,2024-10-04_01,2024-09-30_01

From: Jens Axboe <axboe@kernel.dk>

In preparation for making this more generically available for
->uring_cmd() usage that needs stable command data, rename it and move
it to io_uring/cmd.h instead.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/io_uring/cmd.h |  4 ++++
 io_uring/io_uring.c          |  2 +-
 io_uring/uring_cmd.c         | 10 +++++-----
 io_uring/uring_cmd.h         |  4 ----
 4 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
index c189d36ad55e..24cff2b9b9d4 100644
--- a/include/linux/io_uring/cmd.h
+++ b/include/linux/io_uring/cmd.h
@@ -18,6 +18,10 @@ struct io_uring_cmd {
 	u8		pdu[32]; /* available inline for free use */
 };
=20
+struct io_uring_cmd_data {
+	struct io_uring_sqe	sqes[2];
+};
+
 static inline const void *io_uring_sqe_cmd(const struct io_uring_sqe *sq=
e)
 {
 	return sqe->cmd;
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index b2736e3491b8..8ae6bf746fcc 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -315,7 +315,7 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(s=
truct io_uring_params *p)
 	ret |=3D io_alloc_cache_init(&ctx->rw_cache, IO_ALLOC_CACHE_MAX,
 			    sizeof(struct io_async_rw));
 	ret |=3D io_alloc_cache_init(&ctx->uring_cache, IO_ALLOC_CACHE_MAX,
-			    sizeof(struct uring_cache));
+			    sizeof(struct io_uring_cmd_data));
 	spin_lock_init(&ctx->msg_lock);
 	ret |=3D io_alloc_cache_init(&ctx->msg_cache, IO_ALLOC_CACHE_MAX,
 			    sizeof(struct io_kiocb));
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index e2e8485932d6..eefc203a1214 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -16,10 +16,10 @@
 #include "rsrc.h"
 #include "uring_cmd.h"
=20
-static struct uring_cache *io_uring_async_get(struct io_kiocb *req)
+static struct io_uring_cmd_data *io_uring_async_get(struct io_kiocb *req=
)
 {
 	struct io_ring_ctx *ctx =3D req->ctx;
-	struct uring_cache *cache;
+	struct io_uring_cmd_data *cache;
=20
 	cache =3D io_alloc_cache_get(&ctx->uring_cache);
 	if (cache) {
@@ -35,7 +35,7 @@ static struct uring_cache *io_uring_async_get(struct io=
_kiocb *req)
 static void io_req_uring_cleanup(struct io_kiocb *req, unsigned int issu=
e_flags)
 {
 	struct io_uring_cmd *ioucmd =3D io_kiocb_to_cmd(req, struct io_uring_cm=
d);
-	struct uring_cache *cache =3D req->async_data;
+	struct io_uring_cmd_data *cache =3D req->async_data;
=20
 	if (issue_flags & IO_URING_F_UNLOCKED)
 		return;
@@ -183,7 +183,7 @@ static int io_uring_cmd_prep_setup(struct io_kiocb *r=
eq,
 				   const struct io_uring_sqe *sqe)
 {
 	struct io_uring_cmd *ioucmd =3D io_kiocb_to_cmd(req, struct io_uring_cm=
d);
-	struct uring_cache *cache;
+	struct io_uring_cmd_data *cache;
=20
 	cache =3D io_uring_async_get(req);
 	if (unlikely(!cache))
@@ -256,7 +256,7 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int i=
ssue_flags)
=20
 	ret =3D file->f_op->uring_cmd(ioucmd, issue_flags);
 	if (ret =3D=3D -EAGAIN) {
-		struct uring_cache *cache =3D req->async_data;
+		struct io_uring_cmd_data *cache =3D req->async_data;
=20
 		if (ioucmd->sqe !=3D (void *) cache)
 			memcpy(cache, ioucmd->sqe, uring_sqe_size(req->ctx));
diff --git a/io_uring/uring_cmd.h b/io_uring/uring_cmd.h
index a361f98664d2..515823ca68b8 100644
--- a/io_uring/uring_cmd.h
+++ b/io_uring/uring_cmd.h
@@ -1,9 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
=20
-struct uring_cache {
-	struct io_uring_sqe sqes[2];
-};
-
 int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags);
 int io_uring_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *s=
qe);
=20
--=20
2.45.2


