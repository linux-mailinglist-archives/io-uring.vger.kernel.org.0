Return-Path: <io-uring+bounces-6712-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F0E0A42F1A
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 22:31:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 04AFE16E9F9
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 21:31:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E70461DE2DB;
	Mon, 24 Feb 2025 21:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="Nj97IKuO"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AB863B784
	for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 21:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740432690; cv=none; b=Og+4UR0/rTx3flHMsDRbK+3H9L6Zxfo/NG3bS09uCU8kWLEUsa66DYm7WfufRkKmPxu0b4v8hIcEYLR5M+surOPfbcd79RPzPhfT6Fq0Mby2SqBqPUSxFbLcMeFgUId200piASb+QkIrz6SnZ8Hl8FcbabmjCNVMxpGkkQB02vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740432690; c=relaxed/simple;
	bh=Zf7av2i8gZ2F3ccYuK2w9dvC9qLf0USt/oGZoxDNh6g=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l2FLVbl7f+ePDTFZI4/MZmBRuUf415A6GJk4aYshLG8AX4aKhwLmSOCw8IhvwFGwlv8RO+nDjLYgC/N9xuASk+XkQT+efbx8VTiry+k+b9huB2UhCxk5Ts0yNlkU7phtuTz2c4xQ073h+BtY5LkpYN3zq40sYVYmFMT9fwfkEgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=Nj97IKuO; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51OHU0gA017335
	for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 13:31:28 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2021-q4;
	 bh=9YQLxrsAHFYEHHYXruXDo+6XMIzEP3PCd3c1VhEwHgs=; b=Nj97IKuOMRl7
	op71LZuA1XD1I0vJQjyHrM0vto+Cz2FykLe5y9lhlvbxWTUsSlLgUQYlbDr/awLd
	ckL3mwPeA9Pm8mfLxEjg0tbRxDedzJdPdUET/1UUsLxnj53SMvii7lyTAAQx3MZa
	tCHOXhCXhEA18RSwg0oJLDHBTMX6qgE8qyhNnwnhYHJs+NKyeyCV3/LtgOvbcGeA
	TLWbF2UzlO6kqIbjhKXLKOQjqj+Po2GXFLPjpjtXyKFyyE5cmXc1Tp/zN0i16svc
	BXN+YgLXzQCrdOv6RfYNeLbCijLOI0u31ET+1coTQpJ26KmTdjIeqJBjIzqpemi4
	dK+cgu01dw==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 450w7fhx72-4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 13:31:28 -0800 (PST)
Received: from twshared11145.37.frc1.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c08b:78::c78f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.14; Mon, 24 Feb 2025 21:31:18 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id 7D3A41868C4F2; Mon, 24 Feb 2025 13:31:17 -0800 (PST)
From: Keith Busch <kbusch@meta.com>
To: <ming.lei@redhat.com>, <asml.silence@gmail.com>, <axboe@kernel.dk>,
        <linux-block@vger.kernel.org>, <io-uring@vger.kernel.org>
CC: <bernd@bsbernd.com>, <csander@purestorage.com>,
        Keith Busch
	<kbusch@kernel.org>
Subject: [PATCHv5 06/11] io_uring/rw: move fixed buffer import to issue path
Date: Mon, 24 Feb 2025 13:31:11 -0800
Message-ID: <20250224213116.3509093-7-kbusch@meta.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250224213116.3509093-1-kbusch@meta.com>
References: <20250224213116.3509093-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: _9H-6-qu5bhJupYizNkmryHYzVaA3wt2
X-Proofpoint-ORIG-GUID: _9H-6-qu5bhJupYizNkmryHYzVaA3wt2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-24_10,2025-02-24_02,2024-11-22_01

From: Keith Busch <kbusch@kernel.org>

Registered buffers may depend on a linked command, which makes the prep
path too early to import. Move to the issue path when the node is
actually needed like all the other users of fixed buffers.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 io_uring/opdef.c |  8 ++++----
 io_uring/rw.c    | 43 ++++++++++++++++++++++++++-----------------
 io_uring/rw.h    |  4 ++--
 3 files changed, 32 insertions(+), 23 deletions(-)

diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index 9344534780a02..5369ae33b5ad9 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -104,8 +104,8 @@ const struct io_issue_def io_issue_defs[] =3D {
 		.iopoll			=3D 1,
 		.iopoll_queue		=3D 1,
 		.async_size		=3D sizeof(struct io_async_rw),
-		.prep			=3D io_prep_read_fixed,
-		.issue			=3D io_read,
+		.prep			=3D io_prep_read,
+		.issue			=3D io_read_fixed,
 	},
 	[IORING_OP_WRITE_FIXED] =3D {
 		.needs_file		=3D 1,
@@ -118,8 +118,8 @@ const struct io_issue_def io_issue_defs[] =3D {
 		.iopoll			=3D 1,
 		.iopoll_queue		=3D 1,
 		.async_size		=3D sizeof(struct io_async_rw),
-		.prep			=3D io_prep_write_fixed,
-		.issue			=3D io_write,
+		.prep			=3D io_prep_write,
+		.issue			=3D io_write_fixed,
 	},
 	[IORING_OP_POLL_ADD] =3D {
 		.needs_file		=3D 1,
diff --git a/io_uring/rw.c b/io_uring/rw.c
index db24bcd4c6335..5f37fa48fdd9b 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -348,33 +348,20 @@ int io_prep_writev(struct io_kiocb *req, const stru=
ct io_uring_sqe *sqe)
 	return io_prep_rwv(req, sqe, ITER_SOURCE);
 }
=20
-static int io_prep_rw_fixed(struct io_kiocb *req, const struct io_uring_=
sqe *sqe,
-			    int ddir)
+static int io_init_rw_fixed(struct io_kiocb *req, unsigned int issue_fla=
gs, int ddir)
 {
 	struct io_rw *rw =3D io_kiocb_to_cmd(req, struct io_rw);
-	struct io_async_rw *io;
+	struct io_async_rw *io =3D req->async_data;
 	int ret;
=20
-	ret =3D io_prep_rw(req, sqe, ddir, false);
-	if (unlikely(ret))
-		return ret;
+	if (io->bytes_done)
+		return 0;
=20
-	io =3D req->async_data;
 	ret =3D io_import_reg_buf(req, &io->iter, rw->addr, rw->len, ddir, 0);
 	iov_iter_save_state(&io->iter, &io->iter_state);
 	return ret;
 }
=20
-int io_prep_read_fixed(struct io_kiocb *req, const struct io_uring_sqe *=
sqe)
-{
-	return io_prep_rw_fixed(req, sqe, ITER_DEST);
-}
-
-int io_prep_write_fixed(struct io_kiocb *req, const struct io_uring_sqe =
*sqe)
-{
-	return io_prep_rw_fixed(req, sqe, ITER_SOURCE);
-}
-
 /*
  * Multishot read is prepared just like a normal read/write request, onl=
y
  * difference is that we set the MULTISHOT flag.
@@ -1138,6 +1125,28 @@ int io_write(struct io_kiocb *req, unsigned int is=
sue_flags)
 	}
 }
=20
+int io_read_fixed(struct io_kiocb *req, unsigned int issue_flags)
+{
+	int ret;
+
+	ret =3D io_init_rw_fixed(req, issue_flags, ITER_DEST);
+	if (ret)
+		return ret;
+
+	return io_read(req, issue_flags);
+}
+
+int io_write_fixed(struct io_kiocb *req, unsigned int issue_flags)
+{
+	int ret;
+
+	ret =3D io_init_rw_fixed(req, issue_flags, ITER_SOURCE);
+	if (ret)
+		return ret;
+
+	return io_write(req, issue_flags);
+}
+
 void io_rw_fail(struct io_kiocb *req)
 {
 	int res;
diff --git a/io_uring/rw.h b/io_uring/rw.h
index a45e0c71b59d6..42a491d277273 100644
--- a/io_uring/rw.h
+++ b/io_uring/rw.h
@@ -30,14 +30,14 @@ struct io_async_rw {
 	);
 };
=20
-int io_prep_read_fixed(struct io_kiocb *req, const struct io_uring_sqe *=
sqe);
-int io_prep_write_fixed(struct io_kiocb *req, const struct io_uring_sqe =
*sqe);
 int io_prep_readv(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_prep_writev(struct io_kiocb *req, const struct io_uring_sqe *sqe)=
;
 int io_prep_read(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_prep_write(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_read(struct io_kiocb *req, unsigned int issue_flags);
 int io_write(struct io_kiocb *req, unsigned int issue_flags);
+int io_read_fixed(struct io_kiocb *req, unsigned int issue_flags);
+int io_write_fixed(struct io_kiocb *req, unsigned int issue_flags);
 void io_readv_writev_cleanup(struct io_kiocb *req);
 void io_rw_fail(struct io_kiocb *req);
 void io_req_rw_complete(struct io_kiocb *req, io_tw_token_t tw);
--=20
2.43.5


