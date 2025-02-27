Return-Path: <io-uring+bounces-6846-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BECC8A48BCF
	for <lists+io-uring@lfdr.de>; Thu, 27 Feb 2025 23:41:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AC78B3B7D1E
	for <lists+io-uring@lfdr.de>; Thu, 27 Feb 2025 22:41:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B877227FE99;
	Thu, 27 Feb 2025 22:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="aIPfjGx1"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0289927FE8E
	for <io-uring@vger.kernel.org>; Thu, 27 Feb 2025 22:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740695992; cv=none; b=H0sBpcL2xbt4micUUzyoqluX6MdP4n9knqt/893bsp5oJbfkUT5T4tdP/czE17QbJ/s6zkSzRpOBCUcSS3WF7CQeZo95rogf4/wUnLKIhS8qXBKKeRA/Uwg6uDn7GO2Zi5w8xmJNaC5EJQjHnxvI+TPbLkBmlQwCPRK7mmBpnUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740695992; c=relaxed/simple;
	bh=dHxCVDya3+j5PBBwUvC3UohhRNjgvI3ccXZHig0pYfE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sI9ZLiADLAK0630JBuvdGWlpKvGLMw0ulSNIA7/PJA1iRP5p30SV0zd8gcTZGu7wGKN6EioB7KlwZEln1VAI3oIcdT6CLliBtBKmXKLlxVYWd7vnenWHi0MKTvwtpAVabfE1akWH8vMJChURtvRop/52h6HsaFI/ND4cJupA3uM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=aIPfjGx1; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51RMdi6U011870
	for <io-uring@vger.kernel.org>; Thu, 27 Feb 2025 14:39:49 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2021-q4;
	 bh=717Fucz3MwnGMkuf5ctouUv4BVsW93ozRQBD9opCJkQ=; b=aIPfjGx1z/yV
	5TRQN8Qjk/WqZZSDDuNdIFzdWFk0Gy7NfDnXp9GMaB/r+bEgwPL5MvZPTBzCM5u5
	AoRF13MrFDX9FRaUygErP2dXgM0hf1DGj4f1d6pTClkFBhyUig4FjryZ50kUpBGU
	SQP1Sq4hakF3cfgWmmqOC+9Qa7/xd4TSfB2tf/OMmZZ37XMM5GzqqfzL1ezDr69O
	C4/n28L2+MzlNp8Z0ZwOGYochL6Si4+ZEp+L/qt7Q5lrtJhhwXhrHEfAwMqER90u
	fCFgdRTihblFGkkQfHcjzg9ZoT8ZYCcqqbdJng3L5ykKIgi4gQzTL6eBxJJoTsHo
	fx5nFy7gqQ==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 452wtb9ntv-8
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Thu, 27 Feb 2025 14:39:49 -0800 (PST)
Received: from twshared40462.17.frc2.facebook.com (2620:10d:c0a8:1b::2d) by
 mail.thefacebook.com (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.14; Thu, 27 Feb 2025 22:39:14 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id 6DE311888280C; Thu, 27 Feb 2025 14:39:17 -0800 (PST)
From: Keith Busch <kbusch@meta.com>
To: <ming.lei@redhat.com>, <axboe@kernel.dk>, <asml.silence@gmail.com>,
        <linux-block@vger.kernel.org>, <io-uring@vger.kernel.org>
CC: <linux-nvme@lists.infradead.org>, <csander@purestorage.com>,
        Keith Busch
	<kbusch@kernel.org>
Subject: [PATCHv8 1/6] io_uring/rw: move buffer_select outside generic prep
Date: Thu, 27 Feb 2025 14:39:11 -0800
Message-ID: <20250227223916.143006-2-kbusch@meta.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250227223916.143006-1-kbusch@meta.com>
References: <20250227223916.143006-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: q4n5a7dtYgeiII92u-ydMcYk9-G-4nzl
X-Proofpoint-ORIG-GUID: q4n5a7dtYgeiII92u-ydMcYk9-G-4nzl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-27_08,2025-02-27_01,2024-11-22_01

From: Keith Busch <kbusch@kernel.org>

Cleans up the generic rw prep to not require the do_import flag. Use a
different prep function for callers that might need buffer select.

Based-on-a-patch-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 io_uring/rw.c | 45 ++++++++++++++++++++++++++++-----------------
 1 file changed, 28 insertions(+), 17 deletions(-)

diff --git a/io_uring/rw.c b/io_uring/rw.c
index 788f06fbd7db1..b21b423b3cf8f 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -248,8 +248,8 @@ static int io_prep_rw_pi(struct io_kiocb *req, struct=
 io_rw *rw, int ddir,
 	return ret;
 }
=20
-static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *s=
qe,
-		      int ddir, bool do_import)
+static int __io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe =
*sqe,
+			int ddir)
 {
 	struct io_rw *rw =3D io_kiocb_to_cmd(req, struct io_rw);
 	unsigned ioprio;
@@ -285,14 +285,6 @@ static int io_prep_rw(struct io_kiocb *req, const st=
ruct io_uring_sqe *sqe,
 	rw->len =3D READ_ONCE(sqe->len);
 	rw->flags =3D READ_ONCE(sqe->rw_flags);
=20
-	if (do_import && !io_do_buffer_select(req)) {
-		struct io_async_rw *io =3D req->async_data;
-
-		ret =3D io_import_rw_buffer(ddir, req, io, 0);
-		if (unlikely(ret))
-			return ret;
-	}
-
 	attr_type_mask =3D READ_ONCE(sqe->attr_type_mask);
 	if (attr_type_mask) {
 		u64 attr_ptr;
@@ -307,26 +299,45 @@ static int io_prep_rw(struct io_kiocb *req, const s=
truct io_uring_sqe *sqe,
 	return 0;
 }
=20
+static int io_rw_do_import(struct io_kiocb *req, int ddir)
+{
+	if (io_do_buffer_select(req))
+		return 0;
+
+	return io_import_rw_buffer(ddir, req, req->async_data, 0);
+}
+
+static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *s=
qe,
+		      int ddir)
+{
+	int ret;
+
+	ret =3D __io_prep_rw(req, sqe, ddir);
+	if (unlikely(ret))
+		return ret;
+
+	return io_rw_do_import(req, ddir);
+}
+
 int io_prep_read(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
-	return io_prep_rw(req, sqe, ITER_DEST, true);
+	return io_prep_rw(req, sqe, ITER_DEST);
 }
=20
 int io_prep_write(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
-	return io_prep_rw(req, sqe, ITER_SOURCE, true);
+	return io_prep_rw(req, sqe, ITER_SOURCE);
 }
=20
 static int io_prep_rwv(struct io_kiocb *req, const struct io_uring_sqe *=
sqe,
 		       int ddir)
 {
-	const bool do_import =3D !(req->flags & REQ_F_BUFFER_SELECT);
 	int ret;
=20
-	ret =3D io_prep_rw(req, sqe, ddir, do_import);
+	ret =3D io_prep_rw(req, sqe, ddir);
 	if (unlikely(ret))
 		return ret;
-	if (do_import)
+	if (!(req->flags & REQ_F_BUFFER_SELECT))
 		return 0;
=20
 	/*
@@ -353,7 +364,7 @@ static int io_prep_rw_fixed(struct io_kiocb *req, con=
st struct io_uring_sqe *sqe
 	struct io_async_rw *io;
 	int ret;
=20
-	ret =3D io_prep_rw(req, sqe, ddir, false);
+	ret =3D __io_prep_rw(req, sqe, ddir);
 	if (unlikely(ret))
 		return ret;
=20
@@ -386,7 +397,7 @@ int io_read_mshot_prep(struct io_kiocb *req, const st=
ruct io_uring_sqe *sqe)
 	if (!(req->flags & REQ_F_BUFFER_SELECT))
 		return -EINVAL;
=20
-	ret =3D io_prep_rw(req, sqe, ITER_DEST, false);
+	ret =3D __io_prep_rw(req, sqe, ITER_DEST);
 	if (unlikely(ret))
 		return ret;
=20
--=20
2.43.5


