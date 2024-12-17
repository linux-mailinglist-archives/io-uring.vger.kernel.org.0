Return-Path: <io-uring+bounces-5524-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BA989F55A2
	for <lists+io-uring@lfdr.de>; Tue, 17 Dec 2024 19:08:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 44A7918924A1
	for <lists+io-uring@lfdr.de>; Tue, 17 Dec 2024 18:04:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88753145B16;
	Tue, 17 Dec 2024 18:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b="aMTXKNeB"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94ACB1F869E
	for <io-uring@vger.kernel.org>; Tue, 17 Dec 2024 18:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734458541; cv=none; b=Vg+Gw/o9KxB9/v8MJuQR81ibXgFb2IdUgUuBYhShKEsU0gGOZAZVsFIY5HMu2eYb+gT8/9qIzLoLHMcRagtIQ0MQk3/1Y8xYTqd7KJYE2p5ZTTNdaHEWFACon0ErD0xpcc0LHNxk7NXrV7IWwFXnIzEDuOGQ0epDGrE+eLb9q3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734458541; c=relaxed/simple;
	bh=5RiSR2jHkULy/C3STs8HBELX2lmfMW1FrSgnU1R1SZA=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=bj85TGy4Qik5ikkeWt3XuQL9WhjadNJRzf03ujrrz7wW4rjQj0FYAV65DlewaEh5t5JpcnIMI9K3IeJZ/akK8NomuEU7ZJY6gTqlR0jGDPcLEd11UMYVfiJtnMcot9xOBswVvEVxawqvIvBNxLhj0cwrZA9JxBq7np4rYehxIhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b=aMTXKNeB; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BHGsL3i002666
	for <io-uring@vger.kernel.org>; Tue, 17 Dec 2024 10:02:18 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=facebook; bh=was9xGBUPcfpW0SgGblPpfG
	xfTN/fhXSAAyToKVn42k=; b=aMTXKNeBqZh+fs9SCLXnn0WWN8lnfvkouym9skr
	6oNQpxVMjs9mPZq2AeDH9FWQ2Q6pneo5bb+tG9KPJkd1EjxIuUERTobGIA/6UK64
	nDTNJiGtNKIYNItKk/EZWiaxNyRxHBGDUfHG+xRfPc0bO3A+cok+vCxJUU6bUKSx
	ouCE=
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 43kaym1sdm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Tue, 17 Dec 2024 10:02:18 -0800 (PST)
Received: from twshared53813.03.ash8.facebook.com (2620:10d:c0a8:1b::2d) by
 mail.thefacebook.com (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.11; Tue, 17 Dec 2024 18:02:17 +0000
Received: by devbig276.nha1.facebook.com (Postfix, from userid 660015)
	id 471B79A4114C; Tue, 17 Dec 2024 18:02:12 +0000 (GMT)
From: Mark Harmstone <maharmstone@fb.com>
To: <linux-btrfs@vger.kernel.org>, <io-uring@vger.kernel.org>
CC: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v3 1/4] io_uring/cmd: rename struct uring_cache to io_uring_cmd_data
Date: Tue, 17 Dec 2024 18:01:59 +0000
Message-ID: <20241217180210.4044318-1-maharmstone@fb.com>
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
X-Proofpoint-ORIG-GUID: 0A9PzhemYX_CXnrHtZ9ZwM-DkwWGWxj_
X-Proofpoint-GUID: 0A9PzhemYX_CXnrHtZ9ZwM-DkwWGWxj_
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
index 06ff41484e29..8bac014ed631 100644
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


