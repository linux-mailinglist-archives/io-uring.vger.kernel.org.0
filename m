Return-Path: <io-uring+bounces-5662-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C1111A00B03
	for <lists+io-uring@lfdr.de>; Fri,  3 Jan 2025 16:03:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 414723A45DB
	for <lists+io-uring@lfdr.de>; Fri,  3 Jan 2025 15:03:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA7FF1FA851;
	Fri,  3 Jan 2025 15:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b="HA6k7VdW"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F31161FA25D
	for <io-uring@vger.kernel.org>; Fri,  3 Jan 2025 15:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735916574; cv=none; b=J7F58WQRYZRghpqx3TqsuScjBPTNzq67UZUscYpJcQ2gCMT5t6qOoIJ/FL7542g2tmcq+MbsbQNXbf/ES2d2qnC5v8686qGfo2rWBJH9GjfMkLu0Wl6HVUtXXcCuSO5zEaTmvUxWukTVB2Z8llYCaNdXNq/pSCyrtDvLkCoTINc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735916574; c=relaxed/simple;
	bh=rT++9iJ6ZQNB8q5DWeR2FUycNTru/sqFL0Cz2X7ZSvw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qE+m4GKSUY/M08lc8E/dxk6euf0UVbbz0IgoVu/bZVCovv+DRxhcH/1eQJ97haoUvy6Lrz97jINKfpj45enJ8Q1v/wqprq0pqNL/0HKFtXTRg95RBAW6sRQTf4qZGAiiou2KLpEmTLQyrk0DPmnBGLewbdZaNdI/xuGn2llg+Y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b=HA6k7VdW; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 503F0psl027350
	for <io-uring@vger.kernel.org>; Fri, 3 Jan 2025 07:02:51 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=facebook; bh=p
	rt3/yOItv2hOwJMePcR62drvYabi2Oe7HXQ5W1t2qA=; b=HA6k7VdWaQW02PXP+
	ktKyrno6leOyjrEAjYYUS7/+EyXRx2D8WlxXzjzZaqD2JMbyybk01rX4rBkACutU
	Ux+qzOwc/nxrCGT+jFzGAXdng8QofN0zj/gYoz3UB1/HerQxJ4YOj0y5NUfyysGB
	0R3g1VGtqN68o7tTDgVunqLVUs=
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 43xhcyr8mn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Fri, 03 Jan 2025 07:02:51 -0800 (PST)
Received: from twshared3076.40.frc1.facebook.com (2620:10d:c0a8:1c::11) by
 mail.thefacebook.com (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.14; Fri, 3 Jan 2025 15:02:50 +0000
Received: by devbig276.nha1.facebook.com (Postfix, from userid 660015)
	id 68EABA240683; Fri,  3 Jan 2025 15:02:34 +0000 (GMT)
From: Mark Harmstone <maharmstone@fb.com>
To: <linux-btrfs@vger.kernel.org>, <io-uring@vger.kernel.org>
CC: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/4] io_uring/cmd: rename struct uring_cache to io_uring_cmd_data
Date: Fri, 3 Jan 2025 15:02:23 +0000
Message-ID: <20250103150233.2340306-2-maharmstone@fb.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250103150233.2340306-1-maharmstone@fb.com>
References: <20250103150233.2340306-1-maharmstone@fb.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: ZlOEnxbLlEyTQVKenoaCYSdPMjV-KL9p
X-Proofpoint-GUID: ZlOEnxbLlEyTQVKenoaCYSdPMjV-KL9p
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
 io_uring/opdef.c             |  3 ++-
 io_uring/uring_cmd.c         | 10 +++++-----
 io_uring/uring_cmd.h         |  4 ----
 5 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
index 0d5448c0b86c..61f97a398e9d 100644
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
index d3403c8216db..ff691f37462c 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -320,7 +320,7 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(s=
truct io_uring_params *p)
 	ret |=3D io_alloc_cache_init(&ctx->rw_cache, IO_ALLOC_CACHE_MAX,
 			    sizeof(struct io_async_rw));
 	ret |=3D io_alloc_cache_init(&ctx->uring_cache, IO_ALLOC_CACHE_MAX,
-			    sizeof(struct uring_cache));
+			    sizeof(struct io_uring_cmd_data));
 	spin_lock_init(&ctx->msg_lock);
 	ret |=3D io_alloc_cache_init(&ctx->msg_cache, IO_ALLOC_CACHE_MAX,
 			    sizeof(struct io_kiocb));
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index 3de75eca1c92..e8baef4e5146 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -7,6 +7,7 @@
 #include <linux/fs.h>
 #include <linux/file.h>
 #include <linux/io_uring.h>
+#include <linux/io_uring/cmd.h>
=20
 #include "io_uring.h"
 #include "opdef.h"
@@ -414,7 +415,7 @@ const struct io_issue_def io_issue_defs[] =3D {
 		.plug			=3D 1,
 		.iopoll			=3D 1,
 		.iopoll_queue		=3D 1,
-		.async_size		=3D 2 * sizeof(struct io_uring_sqe),
+		.async_size		=3D sizeof(struct io_uring_cmd_data),
 		.prep			=3D io_uring_cmd_prep,
 		.issue			=3D io_uring_cmd,
 	},
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index af842e9b4eb9..629cb4266da6 100644
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
@@ -260,7 +260,7 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int i=
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
index 7dba0f1efc58..f6837ee0955b 100644
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


