Return-Path: <io-uring+bounces-6440-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 74738A36219
	for <lists+io-uring@lfdr.de>; Fri, 14 Feb 2025 16:46:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BE7963B27CF
	for <lists+io-uring@lfdr.de>; Fri, 14 Feb 2025 15:44:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 168B02676CD;
	Fri, 14 Feb 2025 15:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="nH/5Y1qE"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D97B5266EE4
	for <io-uring@vger.kernel.org>; Fri, 14 Feb 2025 15:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739547842; cv=none; b=bQV1fLWDZWonNMm0RiR6vgWLs1LTGIK/OgUU3D7klqG+stGOdmzpoD2qm/cj20Dei5bSyRRSRPFVFR42AffdZvXHmvzbhq8Cvr/O2Yf8DrbLTArdgG2mX9cHIHdEPCcWxZw3nMBqNqPggUZhwaHVqADUdE6TGpZ+cmI5dY6Y+MM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739547842; c=relaxed/simple;
	bh=xsrBqHiuvFUwzSrLc3k0BFfN6WZQVwVl9qZ5dCqSZrY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oR3GMPt9x1Nkl6/G2wjFStjOVrL5wVj0eA4Un2V0BLgPoE6ozGpvU4ayFSMpgMBNWMWN/xxImM0V0IMY+2LqZPZsqSAo+n2XHrNq0DpDbw06Z86HY8+ZyeCRO89nn7C7hs8tvy2cpQ4B6PIAWvv/ga/AnC2Oa80gOGwrRfPt1J0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=nH/5Y1qE; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51EEXxdW017214
	for <io-uring@vger.kernel.org>; Fri, 14 Feb 2025 07:43:59 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2021-q4;
	 bh=atPJJ3djqBMM6K38y3BqY5+C7mwgExugWJAhQ6jV2RA=; b=nH/5Y1qElskQ
	+rtte5RqoYfL9ph2KpLEagDhsY8OWVc2lRSbadzOyaua46Y4qiD/I/nUB/lrfEr0
	j865alhFvLKBg0kcP+cc5e1kWVvHVNNfPRl2AEdf/VsEZdRqapeNiFXWJycM7iHh
	h8r2vsNeyff6DkssAMa9Mf9bvBhtGV7lNkdAL0AstbG4+2wK6M1v8KlADsH0xIY8
	SkARp994zTQF9e6aRHd6QB2NaoZ0yZWn+fSwkADQ72xRqIiIO7O764RMo7zZKIqP
	P6lgJuTh4CW6qCqDduYJbVtq8i3NF59Yaw9MPhrgbjFVwq2lWBVqXP5o+oPCkj5d
	42Cyb2XNtA==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 44t7q0ggys-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Fri, 14 Feb 2025 07:43:58 -0800 (PST)
Received: from twshared53813.03.ash8.facebook.com (2620:10d:c085:208::7cb7) by
 mail.thefacebook.com (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.14; Fri, 14 Feb 2025 15:43:53 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id 22E4518060B58; Fri, 14 Feb 2025 07:43:49 -0800 (PST)
From: Keith Busch <kbusch@meta.com>
To: <ming.lei@redhat.com>, <asml.silence@gmail.com>, <axboe@kernel.dk>,
        <linux-block@vger.kernel.org>, <io-uring@vger.kernel.org>
CC: <bernd@bsbernd.com>, Keith Busch <kbusch@kernel.org>
Subject: [PATCHv3 1/5] io_uring: move fixed buffer import to issue path
Date: Fri, 14 Feb 2025 07:43:44 -0800
Message-ID: <20250214154348.2952692-2-kbusch@meta.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250214154348.2952692-1-kbusch@meta.com>
References: <20250214154348.2952692-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: giiS6NNVeFqos024-XEpo2wJtUJZ6Zz-
X-Proofpoint-GUID: giiS6NNVeFqos024-XEpo2wJtUJZ6Zz-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-14_06,2025-02-13_01,2024-11-22_01

From: Keith Busch <kbusch@kernel.org>

Similiar to the fixed file path, requests may depend on a previous
command to set up an index, so we need to allow linking them. The prep
callback happens too soon for linked commands, so the lookup needs to be
defered to the issue path. Change the prep callbacks to just set the
buf_index and let generic io_uring code handle the fixed buffer node
setup, just like it does for fixed files.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 include/linux/io_uring_types.h |  3 +++
 io_uring/io_uring.c            | 19 ++++++++++++++
 io_uring/net.c                 | 25 ++++++-------------
 io_uring/nop.c                 | 22 +++--------------
 io_uring/rw.c                  | 45 ++++++++++++++++++++++++----------
 io_uring/uring_cmd.c           | 16 ++----------
 6 files changed, 67 insertions(+), 63 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_type=
s.h
index e2fef264ff8b8..d5bf336882aa8 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -469,6 +469,7 @@ enum {
 	REQ_F_DOUBLE_POLL_BIT,
 	REQ_F_APOLL_MULTISHOT_BIT,
 	REQ_F_CLEAR_POLLIN_BIT,
+	REQ_F_FIXED_BUFFER_BIT,
 	/* keep async read/write and isreg together and in order */
 	REQ_F_SUPPORT_NOWAIT_BIT,
 	REQ_F_ISREG_BIT,
@@ -561,6 +562,8 @@ enum {
 	REQ_F_BUF_NODE		=3D IO_REQ_FLAG(REQ_F_BUF_NODE_BIT),
 	/* request has read/write metadata assigned */
 	REQ_F_HAS_METADATA	=3D IO_REQ_FLAG(REQ_F_HAS_METADATA_BIT),
+	/* request has a fixed buffer at buf_index */
+	REQ_F_FIXED_BUFFER	=3D IO_REQ_FLAG(REQ_F_FIXED_BUFFER_BIT),
 };
=20
 typedef void (*io_req_tw_func_t)(struct io_kiocb *req, struct io_tw_stat=
e *ts);
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 4a0944a57d963..a5be6ec99d153 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1720,6 +1720,23 @@ static bool io_assign_file(struct io_kiocb *req, c=
onst struct io_issue_def *def,
 	return !!req->file;
 }
=20
+static bool io_assign_buffer(struct io_kiocb *req, unsigned int issue_fl=
ags)
+{
+	struct io_ring_ctx *ctx =3D req->ctx;
+	struct io_rsrc_node *node;
+
+	if (req->buf_node || !(req->flags & REQ_F_FIXED_BUFFER))
+		return true;
+
+	io_ring_submit_lock(ctx, issue_flags);
+	node =3D io_rsrc_node_lookup(&ctx->buf_table.data, req->buf_index);
+	if (node)
+		io_req_assign_buf_node(req, node);
+	io_ring_submit_unlock(ctx, issue_flags);
+
+	return !!node;
+}
+
 static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 {
 	const struct io_issue_def *def =3D &io_issue_defs[req->opcode];
@@ -1728,6 +1745,8 @@ static int io_issue_sqe(struct io_kiocb *req, unsig=
ned int issue_flags)
=20
 	if (unlikely(!io_assign_file(req, def, issue_flags)))
 		return -EBADF;
+	if (unlikely(!io_assign_buffer(req, issue_flags)))
+		return -EFAULT;
=20
 	if (unlikely((req->flags & REQ_F_CREDS) && req->creds !=3D current_cred=
()))
 		creds =3D override_creds(req->creds);
diff --git a/io_uring/net.c b/io_uring/net.c
index 10344b3a6d89c..0185925e40bfb 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1299,6 +1299,10 @@ int io_send_zc_prep(struct io_kiocb *req, const st=
ruct io_uring_sqe *sqe)
 #endif
 	if (unlikely(!io_msg_alloc_async(req)))
 		return -ENOMEM;
+	if (zc->flags & IORING_RECVSEND_FIXED_BUF) {
+		req->buf_index =3D zc->buf_index;
+		req->flags |=3D REQ_F_FIXED_BUFFER;
+	}
 	if (req->opcode !=3D IORING_OP_SENDMSG_ZC)
 		return io_send_setup(req, sqe);
 	return io_sendmsg_setup(req, sqe);
@@ -1360,25 +1364,10 @@ static int io_send_zc_import(struct io_kiocb *req=
, unsigned int issue_flags)
 	struct io_async_msghdr *kmsg =3D req->async_data;
 	int ret;
=20
-	if (sr->flags & IORING_RECVSEND_FIXED_BUF) {
-		struct io_ring_ctx *ctx =3D req->ctx;
-		struct io_rsrc_node *node;
-
-		ret =3D -EFAULT;
-		io_ring_submit_lock(ctx, issue_flags);
-		node =3D io_rsrc_node_lookup(&ctx->buf_table, sr->buf_index);
-		if (node) {
-			io_req_assign_buf_node(sr->notif, node);
-			ret =3D 0;
-		}
-		io_ring_submit_unlock(ctx, issue_flags);
-
-		if (unlikely(ret))
-			return ret;
-
+	if (req->flags & REQ_F_FIXED_BUFFER) {
 		ret =3D io_import_fixed(ITER_SOURCE, &kmsg->msg.msg_iter,
-					node->buf, (u64)(uintptr_t)sr->buf,
-					sr->len);
+					req->buf_node->buf,
+					(u64)(uintptr_t)sr->buf, sr->len);
 		if (unlikely(ret))
 			return ret;
 		kmsg->msg.sg_from_iter =3D io_sg_from_iter;
diff --git a/io_uring/nop.c b/io_uring/nop.c
index 5e5196df650a1..989908603112f 100644
--- a/io_uring/nop.c
+++ b/io_uring/nop.c
@@ -16,7 +16,6 @@ struct io_nop {
 	struct file     *file;
 	int             result;
 	int		fd;
-	int		buffer;
 	unsigned int	flags;
 };
=20
@@ -39,10 +38,10 @@ int io_nop_prep(struct io_kiocb *req, const struct io=
_uring_sqe *sqe)
 		nop->fd =3D READ_ONCE(sqe->fd);
 	else
 		nop->fd =3D -1;
-	if (nop->flags & IORING_NOP_FIXED_BUFFER)
-		nop->buffer =3D READ_ONCE(sqe->buf_index);
-	else
-		nop->buffer =3D -1;
+	if (nop->flags & IORING_NOP_FIXED_BUFFER) {
+		req->buf_index =3D READ_ONCE(sqe->buf_index);
+		req->flags |=3D REQ_F_FIXED_BUFFER;
+	}
 	return 0;
 }
=20
@@ -63,19 +62,6 @@ int io_nop(struct io_kiocb *req, unsigned int issue_fl=
ags)
 			goto done;
 		}
 	}
-	if (nop->flags & IORING_NOP_FIXED_BUFFER) {
-		struct io_ring_ctx *ctx =3D req->ctx;
-		struct io_rsrc_node *node;
-
-		ret =3D -EFAULT;
-		io_ring_submit_lock(ctx, issue_flags);
-		node =3D io_rsrc_node_lookup(&ctx->buf_table, nop->buffer);
-		if (node) {
-			io_req_assign_buf_node(req, node);
-			ret =3D 0;
-		}
-		io_ring_submit_unlock(ctx, issue_flags);
-	}
 done:
 	if (ret < 0)
 		req_set_fail(req);
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 7aa1e4c9f64a3..f37cd883d1625 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -353,25 +353,14 @@ int io_prep_writev(struct io_kiocb *req, const stru=
ct io_uring_sqe *sqe)
 static int io_prep_rw_fixed(struct io_kiocb *req, const struct io_uring_=
sqe *sqe,
 			    int ddir)
 {
-	struct io_rw *rw =3D io_kiocb_to_cmd(req, struct io_rw);
-	struct io_ring_ctx *ctx =3D req->ctx;
-	struct io_rsrc_node *node;
-	struct io_async_rw *io;
 	int ret;
=20
 	ret =3D io_prep_rw(req, sqe, ddir, false);
 	if (unlikely(ret))
 		return ret;
=20
-	node =3D io_rsrc_node_lookup(&ctx->buf_table, req->buf_index);
-	if (!node)
-		return -EFAULT;
-	io_req_assign_buf_node(req, node);
-
-	io =3D req->async_data;
-	ret =3D io_import_fixed(ddir, &io->iter, node->buf, rw->addr, rw->len);
-	iov_iter_save_state(&io->iter, &io->iter_state);
-	return ret;
+	req->flags |=3D REQ_F_FIXED_BUFFER;
+	return 0;
 }
=20
 int io_prep_read_fixed(struct io_kiocb *req, const struct io_uring_sqe *=
sqe)
@@ -954,10 +943,36 @@ static int __io_read(struct io_kiocb *req, unsigned=
 int issue_flags)
 	return ret;
 }
=20
+static int io_import_fixed_buffer(struct io_kiocb *req, int ddir)
+{
+	struct io_rw *rw =3D io_kiocb_to_cmd(req, struct io_rw);
+	struct io_async_rw *io;
+	int ret;
+
+	if (!(req->flags & REQ_F_FIXED_BUFFER))
+		return 0;
+
+	io =3D req->async_data;
+	if (io->bytes_done)
+		return 0;
+
+	ret =3D io_import_fixed(ddir, &io->iter, req->buf_node->buf, rw->addr,
+			      rw->len);
+	if (ret)
+		return ret;
+
+	iov_iter_save_state(&io->iter, &io->iter_state);
+	return 0;
+}
+
 int io_read(struct io_kiocb *req, unsigned int issue_flags)
 {
 	int ret;
=20
+	ret =3D io_import_fixed_buffer(req, READ);
+	if (unlikely(ret))
+		return ret;
+
 	ret =3D __io_read(req, issue_flags);
 	if (ret >=3D 0)
 		return kiocb_done(req, ret, issue_flags);
@@ -1062,6 +1077,10 @@ int io_write(struct io_kiocb *req, unsigned int is=
sue_flags)
 	ssize_t ret, ret2;
 	loff_t *ppos;
=20
+	ret =3D io_import_fixed_buffer(req, WRITE);
+	if (unlikely(ret))
+		return ret;
+
 	ret =3D io_rw_init_file(req, FMODE_WRITE, WRITE);
 	if (unlikely(ret))
 		return ret;
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 1f6a82128b475..70210b4e0b0f6 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -202,19 +202,8 @@ int io_uring_cmd_prep(struct io_kiocb *req, const st=
ruct io_uring_sqe *sqe)
 		return -EINVAL;
=20
 	if (ioucmd->flags & IORING_URING_CMD_FIXED) {
-		struct io_ring_ctx *ctx =3D req->ctx;
-		struct io_rsrc_node *node;
-		u16 index =3D READ_ONCE(sqe->buf_index);
-
-		node =3D io_rsrc_node_lookup(&ctx->buf_table, index);
-		if (unlikely(!node))
-			return -EFAULT;
-		/*
-		 * Pi node upfront, prior to io_uring_cmd_import_fixed()
-		 * being called. This prevents destruction of the mapped buffer
-		 * we'll need at actual import time.
-		 */
-		io_req_assign_buf_node(req, node);
+		req->buf_index =3D READ_ONCE(sqe->buf_index);
+		req->flags |=3D REQ_F_FIXED_BUFFER;
 	}
 	ioucmd->cmd_op =3D READ_ONCE(sqe->cmd_op);
=20
@@ -272,7 +261,6 @@ int io_uring_cmd_import_fixed(u64 ubuf, unsigned long=
 len, int rw,
 	struct io_kiocb *req =3D cmd_to_io_kiocb(ioucmd);
 	struct io_rsrc_node *node =3D req->buf_node;
=20
-	/* Must have had rsrc_node assigned at prep time */
 	if (node)
 		return io_import_fixed(rw, iter, node->buf, ubuf, len);
=20
--=20
2.43.5


