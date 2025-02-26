Return-Path: <io-uring+bounces-6813-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BB86DA469B2
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2025 19:27:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3D1A37A5702
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2025 18:26:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5BC623F41A;
	Wed, 26 Feb 2025 18:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="XP4jziY3"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 216532405E4
	for <io-uring@vger.kernel.org>; Wed, 26 Feb 2025 18:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740594092; cv=none; b=nm6VqAv+jUZ9jczkzJvFO5NG09kptmIshxao6G/Aokv1ofhUUece9I76ZtaYlNdTSJSr3LbETg1NZbX1E99DAZRDanlR+jpH7rf0TJQXTOre0opMot1Cwugh3tw/5bjTyFhpsMRH0KZ4z6uIEInErLfLyyl0BDZLWQVQT331l3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740594092; c=relaxed/simple;
	bh=ACrMtJ48BLf0lS9Oq2SBzkvrIp8x6BzOepzTjwKE+MU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=joaUu6p6c5OXPl72/fAcZYV03BfccLPIzdFU7lRp7G9YfWsK2+Dwll0awHeDS8MA14G6KZww08lHUYOvllkA+gV6RsSKdP24us2PFPP6qSKDyItAGovFAIyySHFhyvQh9plpwRksnZB50blr/rQsn9LlNd1LLMwIejEN+lB98Eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=XP4jziY3; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51QF0nIT019916
	for <io-uring@vger.kernel.org>; Wed, 26 Feb 2025 10:21:30 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2021-q4;
	 bh=VdThkb+RRcWXrvMKEbaOWgaU8H96LXHKVFz/+nZDMjc=; b=XP4jziY3Q87+
	P3grrcK0pZ7iiQJKXM7Pv0iVTphmp5yLx8MB/TIS9AtwNpUsMjNe4Rm6ViPS24qo
	NTopb7a7sYY1vnD+7gwxi3sl8XUVEWjk3ePKof7RBk7YtrDNXedJYgqc0EdrAn1x
	cPe4QUr3+q63mURgnSk7wbmWGQkBDm73To/Hch4+JS8Oy3fGdAM9ASxP2xF0LIYg
	wA8byfVHNiQKpm8ZHCk5BNZ3Le0VD7EIkeEWOdwUNoIW9VtwNxnsTvH4gFvNbaWd
	vc/3fykJTKqbUIO+tPg7vCj4PbUbwq1QeLPsJKESYqB4JvlOShSHIX3ju/GHLj3C
	TaoIPp8ysw==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 45257j1hut-13
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Wed, 26 Feb 2025 10:21:29 -0800 (PST)
Received: from twshared8234.09.ash9.facebook.com (2620:10d:c085:108::150d) by
 mail.thefacebook.com (2620:10d:c08b:78::c78f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.14; Wed, 26 Feb 2025 18:21:09 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id AE672187C82C4; Wed, 26 Feb 2025 10:21:04 -0800 (PST)
From: Keith Busch <kbusch@meta.com>
To: <ming.lei@redhat.com>, <asml.silence@gmail.com>, <axboe@kernel.dk>,
        <linux-block@vger.kernel.org>, <io-uring@vger.kernel.org>
CC: <bernd@bsbernd.com>, <csander@purestorage.com>,
        <linux-nvme@lists.infradead.org>, Keith Busch <kbusch@kernel.org>
Subject: [PATCHv7 1/6] io_uring/rw: move fixed buffer import to issue path
Date: Wed, 26 Feb 2025 10:20:56 -0800
Message-ID: <20250226182102.2631321-2-kbusch@meta.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250226182102.2631321-1-kbusch@meta.com>
References: <20250226182102.2631321-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: fQ5QhZ-DHJktcAZM9zqtTAiNd-bBJ5Q9
X-Proofpoint-GUID: fQ5QhZ-DHJktcAZM9zqtTAiNd-bBJ5Q9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-26_04,2025-02-26_01,2024-11-22_01

From: Keith Busch <kbusch@kernel.org>

Registered buffers may depend on a linked command, which makes the prep
path too early to import. Move to the issue path when the node is
actually needed like all the other users of fixed buffers.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 io_uring/opdef.c |  4 ++--
 io_uring/rw.c    | 39 ++++++++++++++++++++++++++++++---------
 io_uring/rw.h    |  2 ++
 3 files changed, 34 insertions(+), 11 deletions(-)

diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index 9344534780a02..db77df513d55b 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -105,7 +105,7 @@ const struct io_issue_def io_issue_defs[] =3D {
 		.iopoll_queue		=3D 1,
 		.async_size		=3D sizeof(struct io_async_rw),
 		.prep			=3D io_prep_read_fixed,
-		.issue			=3D io_read,
+		.issue			=3D io_read_fixed,
 	},
 	[IORING_OP_WRITE_FIXED] =3D {
 		.needs_file		=3D 1,
@@ -119,7 +119,7 @@ const struct io_issue_def io_issue_defs[] =3D {
 		.iopoll_queue		=3D 1,
 		.async_size		=3D sizeof(struct io_async_rw),
 		.prep			=3D io_prep_write_fixed,
-		.issue			=3D io_write,
+		.issue			=3D io_write_fixed,
 	},
 	[IORING_OP_POLL_ADD] =3D {
 		.needs_file		=3D 1,
diff --git a/io_uring/rw.c b/io_uring/rw.c
index eb369142d64ad..728d695d2552a 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -346,31 +346,30 @@ int io_prep_writev(struct io_kiocb *req, const stru=
ct io_uring_sqe *sqe)
 	return io_prep_rwv(req, sqe, ITER_SOURCE);
 }
=20
-static int io_prep_rw_fixed(struct io_kiocb *req, const struct io_uring_=
sqe *sqe,
+static int io_init_rw_fixed(struct io_kiocb *req, unsigned int issue_fla=
gs,
 			    int ddir)
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
-	ret =3D io_import_reg_buf(req, &io->iter, rw->addr, rw->len, ddir, 0);
+	ret =3D io_import_reg_buf(req, &io->iter, rw->addr, rw->len, ddir,
+				issue_flags);
 	iov_iter_save_state(&io->iter, &io->iter_state);
 	return ret;
 }
=20
 int io_prep_read_fixed(struct io_kiocb *req, const struct io_uring_sqe *=
sqe)
 {
-	return io_prep_rw_fixed(req, sqe, ITER_DEST);
+	return io_prep_rw(req, sqe, ITER_DEST, false);
 }
=20
 int io_prep_write_fixed(struct io_kiocb *req, const struct io_uring_sqe =
*sqe)
 {
-	return io_prep_rw_fixed(req, sqe, ITER_SOURCE);
+	return io_prep_rw(req, sqe, ITER_SOURCE, false);
 }
=20
 /*
@@ -1136,6 +1135,28 @@ int io_write(struct io_kiocb *req, unsigned int is=
sue_flags)
 	}
 }
=20
+int io_read_fixed(struct io_kiocb *req, unsigned int issue_flags)
+{
+	int ret;
+
+	ret =3D io_init_rw_fixed(req, issue_flags, ITER_DEST);
+	if (unlikely(ret))
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
+	if (unlikely(ret))
+		return ret;
+
+	return io_write(req, issue_flags);
+}
+
 void io_rw_fail(struct io_kiocb *req)
 {
 	int res;
diff --git a/io_uring/rw.h b/io_uring/rw.h
index a45e0c71b59d6..bf121b81ebe84 100644
--- a/io_uring/rw.h
+++ b/io_uring/rw.h
@@ -38,6 +38,8 @@ int io_prep_read(struct io_kiocb *req, const struct io_=
uring_sqe *sqe);
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


