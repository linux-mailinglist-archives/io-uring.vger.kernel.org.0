Return-Path: <io-uring+bounces-5488-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 756FB9F152D
	for <lists+io-uring@lfdr.de>; Fri, 13 Dec 2024 19:45:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 26DBC283D90
	for <lists+io-uring@lfdr.de>; Fri, 13 Dec 2024 18:45:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E8CA1E766F;
	Fri, 13 Dec 2024 18:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b="FTDWIBfT"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 431581E7648
	for <io-uring@vger.kernel.org>; Fri, 13 Dec 2024 18:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734115508; cv=none; b=thbNAudCFuf7A0yEZK5sk1QeIncCebWJBZM7u9mLbO0MxOIu4xzLSAT1iHh1Xgp4lFaNH4Xh1gvZIoq2Xc37jkWr7iKMYMAuC8UYTSFLZgNe9nfdH653/aL13E6EQWL4h8aIvS/fec3o9n5IN+Fmgv7+OHU/B39O2MJ2bTz7gPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734115508; c=relaxed/simple;
	bh=5RiSR2jHkULy/C3STs8HBELX2lmfMW1FrSgnU1R1SZA=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=oZddk6RZpqlFUB7MkF8wwzr9wd2GV2AdA1uM2FMvhkwjcRSSv/MhndN35bwGNeB6FfYxtVpIt1czyvfYaSgMMUB9Nm+UJmK3NdESgsgMlfAf5NtHshtE0ciUGVto6/TCZCzet3I1uFjCBugEaAV5aZ8HMREKjEMQ76rlpsA+gRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b=FTDWIBfT; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BDITA2S010662
	for <io-uring@vger.kernel.org>; Fri, 13 Dec 2024 10:45:05 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=facebook; bh=was9xGBUPcfpW0SgGblPpfG
	xfTN/fhXSAAyToKVn42k=; b=FTDWIBfTwcFcXvcT3uCvqS1r3dMQQJtrlFxgfu5
	CnLC+G/oEVAC5Q47XnDZ7WI5vW1+QakeCV8DO+yWjlKKq27lVAqMk2+1ywWEJk+0
	RU9Iwu2pNqxVHcb2SWEaLgNX39f9uaMoMtPmASybfIuj8V29RqtUwZf0wuEcstr0
	1Tg0=
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 43gpqt9tvr-16
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Fri, 13 Dec 2024 10:45:04 -0800 (PST)
Received: from twshared3815.08.ash9.facebook.com (2620:10d:c0a8:1b::30) by
 mail.thefacebook.com (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.11; Fri, 13 Dec 2024 18:44:51 +0000
Received: by devbig276.nha1.facebook.com (Postfix, from userid 660015)
	id 72E1C9868CAE; Fri, 13 Dec 2024 18:44:49 +0000 (GMT)
From: Mark Harmstone <maharmstone@fb.com>
To: <linux-btrfs@vger.kernel.org>, <io-uring@vger.kernel.org>
CC: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v2 1/3] io_uring/cmd: rename struct uring_cache to io_uring_cmd_data
Date: Fri, 13 Dec 2024 18:44:28 +0000
Message-ID: <20241213184444.2112559-1-maharmstone@fb.com>
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
X-Proofpoint-GUID: Uz7Wyn8i7kc4zKKJGh81WqFkzKpWFmVH
X-Proofpoint-ORIG-GUID: Uz7Wyn8i7kc4zKKJGh81WqFkzKpWFmVH
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


