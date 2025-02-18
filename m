Return-Path: <io-uring+bounces-6530-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B4AA5A3ABE8
	for <lists+io-uring@lfdr.de>; Tue, 18 Feb 2025 23:43:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A5A913AA639
	for <lists+io-uring@lfdr.de>; Tue, 18 Feb 2025 22:42:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1579C286297;
	Tue, 18 Feb 2025 22:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="gkXeTAiR"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31024286284
	for <io-uring@vger.kernel.org>; Tue, 18 Feb 2025 22:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739918585; cv=none; b=HQXcDSly94SYlJtkjhn5Ah5q7J7B/OgA5v/V6YYpg/G70nYpXPF2iWDLWu5sUuaBMGpfTr8Ah/McGOBfuYg3k7E6EzmD5FsajvkcDm6n5Nh+FdM/+UT/3XBiAGrOJ0K0w15bAczTeJNP00BEpeg1D/i16XDA2sIZSI09zmrHDjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739918585; c=relaxed/simple;
	bh=AeavXwN8CQhduLD67hGYrGDLDXyi8wXPI9d83VYuSx4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DG/EkpCa6SisAI3QQjkFUaNs5VySfNybL58Le10+HjM1t6y8vndGwn9F8DK3TqjLrz4g/pyGNEqDYcfwB9dwG3cDnC9MrEfr5b7uDn7bjHJjbylKsIukYBtol0/RTPPZbd7nsjY5xTAQzcGYOGmMKxyP7GurPB0O/LsusXZhVbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=gkXeTAiR; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51IM80hT030431
	for <io-uring@vger.kernel.org>; Tue, 18 Feb 2025 14:43:02 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2021-q4;
	 bh=BSKYbCE/BupWIdIF0IoSfE5tfwwNFqjd3tZVJ7HYn6I=; b=gkXeTAiRY+Nu
	MGltEXs+GzSL8TCCNfKWnOwPOGJ3588cF2QmxGaDCCgwg7eTQYfE2+fXIXBb74nd
	NawIEk+AOHpXWl3zhJue9nFWqlwL2FZuvn1ZC+1u+RDiE5rx5iabv3rjNl/Uc7Uc
	GX0+AGrb00bVMh1iyB13G2XA2WvT5W0WPGgNzm5+Awyx8GOg8r0rA/BosYnvGtbT
	FpUs1stIwCRmYCc/b/f0L8FgFncSOInZViuK9bgqcTw02jNdut5vCCoz8DhTJZwD
	nv5FVecR+WdeoOqf/hpuaDZUY5rwd4CsUql5RD96J4LfepAMSFA6hrf7kD4zwjT7
	49B15GDUZA==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 44w01bf90g-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Tue, 18 Feb 2025 14:43:01 -0800 (PST)
Received: from twshared8234.09.ash9.facebook.com (2620:10d:c0a8:1c::11) by
 mail.thefacebook.com (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.14; Tue, 18 Feb 2025 22:42:55 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id 6EE76182F61C4; Tue, 18 Feb 2025 14:42:49 -0800 (PST)
From: Keith Busch <kbusch@meta.com>
To: <ming.lei@redhat.com>, <asml.silence@gmail.com>, <axboe@kernel.dk>,
        <linux-block@vger.kernel.org>, <io-uring@vger.kernel.org>
CC: <bernd@bsbernd.com>, <csander@purestorage.com>,
        Keith Busch
	<kbusch@kernel.org>
Subject: [PATCHv4 1/5] io_uring: move fixed buffer import to issue path
Date: Tue, 18 Feb 2025 14:42:25 -0800
Message-ID: <20250218224229.837848-2-kbusch@meta.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250218224229.837848-1-kbusch@meta.com>
References: <20250218224229.837848-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: jBjz8eeaZqnrCcJ40PYsWtFkOX10ZY8d
X-Proofpoint-GUID: jBjz8eeaZqnrCcJ40PYsWtFkOX10ZY8d
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-18_10,2025-02-18_01,2024-11-22_01

From: Keith Busch <kbusch@kernel.org>

Similar to the fixed file path, requests may depend on a previous one
to set up an index, so we need to allow linking them. The prep callback
happens too soon for linked commands, so the lookup needs to be deferred
to the issue path. Change the prep callbacks to just set the buf_index
and let generic io_uring code handle the fixed buffer node setup, just
like it already does for fixed files.

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
index c0fe8a00fe53a..0bcaefc4ffe02 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -482,6 +482,7 @@ enum {
 	REQ_F_DOUBLE_POLL_BIT,
 	REQ_F_APOLL_MULTISHOT_BIT,
 	REQ_F_CLEAR_POLLIN_BIT,
+	REQ_F_FIXED_BUFFER_BIT,
 	/* keep async read/write and isreg together and in order */
 	REQ_F_SUPPORT_NOWAIT_BIT,
 	REQ_F_ISREG_BIT,
@@ -574,6 +575,8 @@ enum {
 	REQ_F_BUF_NODE		=3D IO_REQ_FLAG(REQ_F_BUF_NODE_BIT),
 	/* request has read/write metadata assigned */
 	REQ_F_HAS_METADATA	=3D IO_REQ_FLAG(REQ_F_HAS_METADATA_BIT),
+	/* request has a fixed buffer at buf_index */
+	REQ_F_FIXED_BUFFER	=3D IO_REQ_FLAG(REQ_F_FIXED_BUFFER_BIT),
 };
=20
 typedef void (*io_req_tw_func_t)(struct io_kiocb *req, io_tw_token_t tw)=
;
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 58528bf61638e..7800edbc57279 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1721,6 +1721,23 @@ static bool io_assign_file(struct io_kiocb *req, c=
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
+	node =3D io_rsrc_node_lookup(&ctx->buf_table, req->buf_index);
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
@@ -1729,6 +1746,8 @@ static int io_issue_sqe(struct io_kiocb *req, unsig=
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
index 000dc70d08d0d..39838e8575b53 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1373,6 +1373,10 @@ int io_send_zc_prep(struct io_kiocb *req, const st=
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
@@ -1434,25 +1438,10 @@ static int io_send_zc_import(struct io_kiocb *req=
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
index 16f12f94943f7..2d8910d9197a0 100644
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
index 8bdf2c9b3fef9..112b49fde23e5 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -200,19 +200,8 @@ int io_uring_cmd_prep(struct io_kiocb *req, const st=
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
@@ -262,7 +251,6 @@ int io_uring_cmd_import_fixed(u64 ubuf, unsigned long=
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


