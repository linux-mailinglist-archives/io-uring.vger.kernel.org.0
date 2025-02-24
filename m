Return-Path: <io-uring+bounces-6718-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A01E1A42F29
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 22:32:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DFAD03AF39D
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 21:31:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65E6C1DE3AD;
	Mon, 24 Feb 2025 21:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="G+lwOdZJ"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 984281DDC18
	for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 21:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740432699; cv=none; b=JoKiqLNq/fwjw/1agonib1/5PDr8lOKhojSGgeZgXpd0ktOxk2AeRpDOsQ3mcxrSsblTBkUenR8wLr8n0yKSkjkyaNYjdLj14boWE5WKmobPC/bxu3fgPGw6XvkSnLYVytAPEvGAobiEy99AJQ0avSia7tulmissZdn+z4jlD64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740432699; c=relaxed/simple;
	bh=aN9JMzH6z1RoQi0QWuvJ00ZmnO8a7FIO+8Ar0zkLmWk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HhPnfZIpGNa5t0Hk3YhIHpTjc2ELdUsWQAkeZdBkikStAR5BMty2ZndJ1FPPLwxSYAyT71wYyWCnghpKcOSXhgVX31pMZ8KRRNTwrLY4UctM3UWG8XJEZD56fArOzTMVBq0S+rtBuZ/92bSfZoHnTIP1oALj78Gkxo+FHLfmkKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=G+lwOdZJ; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51OFDF26023467
	for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 13:31:36 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2021-q4;
	 bh=3JMiX14eSnJL69aRaWySip1q69b2nPk9mQ9nxLakszk=; b=G+lwOdZJmwqv
	iqRLI2ajAZy1aKzHrTT5yaEmMsfGFT/Z+JHo4plwSZ9nPGYnGLDoT+HWIbdQrnFO
	sXSQUR+dytgMP8F5kV1ADxAUMpgsGpFT9owYsvIF/mDZaFdwS8cXUnMOEWMYlVDj
	Ly/Gr1GxDZuVe4EYL18gqafuQFjAz1FvANJ2ZUzgBIC84g959rzHRV2V6kIJ5NeT
	XEV5KwwOdOJl329LLVBFajM/GBgjzCu8MHcC+uo4haLBjpj/sIQ3UWYioiZfD1Pm
	NBcj8eXYTDujwZu8hnueQYKgaLEELSS2RCcTql4FEmRnhYf8bv0ejJoIm6aZVpsI
	d0QW4j6eEA==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 450tdcufs5-7
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 13:31:36 -0800 (PST)
Received: from twshared8234.09.ash9.facebook.com (2620:10d:c0a8:1c::11) by
 mail.thefacebook.com (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.14; Mon, 24 Feb 2025 21:31:23 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id 710671868C4F0; Mon, 24 Feb 2025 13:31:17 -0800 (PST)
From: Keith Busch <kbusch@meta.com>
To: <ming.lei@redhat.com>, <asml.silence@gmail.com>, <axboe@kernel.dk>,
        <linux-block@vger.kernel.org>, <io-uring@vger.kernel.org>
CC: <bernd@bsbernd.com>, <csander@purestorage.com>,
        Keith Busch
	<kbusch@kernel.org>
Subject: [PATCHv5 05/11] io_uring: combine buffer lookup and import
Date: Mon, 24 Feb 2025 13:31:10 -0800
Message-ID: <20250224213116.3509093-6-kbusch@meta.com>
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
X-Proofpoint-GUID: _jsdvSefCzlCi40viLaaDrbzok5HxASf
X-Proofpoint-ORIG-GUID: _jsdvSefCzlCi40viLaaDrbzok5HxASf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-24_10,2025-02-24_02,2024-11-22_01

From: Pavel Begunkov <asml.silence@gmail.com>

Registered buffer are currently imported in two steps, first we lookup
a rsrc node and then use it to set up the iterator. The first part is
usually done at the prep stage, and import happens whenever it's needed.
As we want to defer binding to a node so that it works with linked
requests, combine both steps into a single helper.

Reviewed-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c       | 22 ++++------------------
 io_uring/rsrc.c      | 31 ++++++++++++++++++++++++++++++-
 io_uring/rsrc.h      |  6 +++---
 io_uring/rw.c        |  9 +--------
 io_uring/uring_cmd.c | 25 ++++---------------------
 5 files changed, 42 insertions(+), 51 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index fa35a6b58d472..f223721418fac 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1441,24 +1441,10 @@ static int io_send_zc_import(struct io_kiocb *req=
, unsigned int issue_flags)
 	int ret;
=20
 	if (sr->flags & IORING_RECVSEND_FIXED_BUF) {
-		struct io_ring_ctx *ctx =3D req->ctx;
-		struct io_rsrc_node *node;
-
-		ret =3D -EFAULT;
-		io_ring_submit_lock(ctx, issue_flags);
-		node =3D io_rsrc_node_lookup(&ctx->buf_table, req->buf_index);
-		if (node) {
-			io_req_assign_buf_node(sr->notif, node);
-			ret =3D 0;
-		}
-		io_ring_submit_unlock(ctx, issue_flags);
-
-		if (unlikely(ret))
-			return ret;
-
-		ret =3D io_import_fixed(ITER_SOURCE, &kmsg->msg.msg_iter,
-					node->buf, (u64)(uintptr_t)sr->buf,
-					sr->len);
+		sr->notif->buf_index =3D req->buf_index;
+		ret =3D io_import_reg_buf(sr->notif, &kmsg->msg.msg_iter,
+					(u64)(uintptr_t)sr->buf, sr->len,
+					ITER_SOURCE, issue_flags);
 		if (unlikely(ret))
 			return ret;
 		kmsg->msg.sg_from_iter =3D io_sg_from_iter;
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index efef29352dcfb..f814526982c36 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -857,7 +857,7 @@ int io_sqe_buffers_register(struct io_ring_ctx *ctx, =
void __user *arg,
 	return ret;
 }
=20
-int io_import_fixed(int ddir, struct iov_iter *iter,
+static int io_import_fixed(int ddir, struct iov_iter *iter,
 			   struct io_mapped_ubuf *imu,
 			   u64 buf_addr, size_t len)
 {
@@ -916,6 +916,35 @@ int io_import_fixed(int ddir, struct iov_iter *iter,
 	return 0;
 }
=20
+static inline struct io_rsrc_node *io_find_buf_node(struct io_kiocb *req=
,
+						    unsigned issue_flags)
+{
+	struct io_ring_ctx *ctx =3D req->ctx;
+	struct io_rsrc_node *node;
+
+	if (req->flags & REQ_F_BUF_NODE)
+		return req->buf_node;
+
+	io_ring_submit_lock(ctx, issue_flags);
+	node =3D io_rsrc_node_lookup(&ctx->buf_table, req->buf_index);
+	if (node)
+		io_req_assign_buf_node(req, node);
+	io_ring_submit_unlock(ctx, issue_flags);
+	return node;
+}
+
+int io_import_reg_buf(struct io_kiocb *req, struct iov_iter *iter,
+			u64 buf_addr, size_t len, int ddir,
+			unsigned issue_flags)
+{
+	struct io_rsrc_node *node;
+
+	node =3D io_find_buf_node(req, issue_flags);
+	if (!node)
+		return -EFAULT;
+	return io_import_fixed(ddir, iter, node->buf, buf_addr, len);
+}
+
 /* Lock two rings at once. The rings must be different! */
 static void lock_two_rings(struct io_ring_ctx *ctx1, struct io_ring_ctx =
*ctx2)
 {
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index 2b1e258954092..f0e9080599646 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -44,9 +44,9 @@ void io_free_rsrc_node(struct io_ring_ctx *ctx, struct =
io_rsrc_node *node);
 void io_rsrc_data_free(struct io_ring_ctx *ctx, struct io_rsrc_data *dat=
a);
 int io_rsrc_data_alloc(struct io_rsrc_data *data, unsigned nr);
=20
-int io_import_fixed(int ddir, struct iov_iter *iter,
-			   struct io_mapped_ubuf *imu,
-			   u64 buf_addr, size_t len);
+int io_import_reg_buf(struct io_kiocb *req, struct iov_iter *iter,
+			u64 buf_addr, size_t len, int ddir,
+			unsigned issue_flags);
=20
 int io_register_clone_buffers(struct io_ring_ctx *ctx, void __user *arg)=
;
 int io_sqe_buffers_unregister(struct io_ring_ctx *ctx);
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 3443f418d9120..db24bcd4c6335 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -352,8 +352,6 @@ static int io_prep_rw_fixed(struct io_kiocb *req, con=
st struct io_uring_sqe *sqe
 			    int ddir)
 {
 	struct io_rw *rw =3D io_kiocb_to_cmd(req, struct io_rw);
-	struct io_ring_ctx *ctx =3D req->ctx;
-	struct io_rsrc_node *node;
 	struct io_async_rw *io;
 	int ret;
=20
@@ -361,13 +359,8 @@ static int io_prep_rw_fixed(struct io_kiocb *req, co=
nst struct io_uring_sqe *sqe
 	if (unlikely(ret))
 		return ret;
=20
-	node =3D io_rsrc_node_lookup(&ctx->buf_table, req->buf_index);
-	if (!node)
-		return -EFAULT;
-	io_req_assign_buf_node(req, node);
-
 	io =3D req->async_data;
-	ret =3D io_import_fixed(ddir, &io->iter, node->buf, rw->addr, rw->len);
+	ret =3D io_import_reg_buf(req, &io->iter, rw->addr, rw->len, ddir, 0);
 	iov_iter_save_state(&io->iter, &io->iter_state);
 	return ret;
 }
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 28ed69c40756e..31d5e0948af14 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -199,21 +199,9 @@ int io_uring_cmd_prep(struct io_kiocb *req, const st=
ruct io_uring_sqe *sqe)
 	if (ioucmd->flags & ~IORING_URING_CMD_MASK)
 		return -EINVAL;
=20
-	if (ioucmd->flags & IORING_URING_CMD_FIXED) {
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
-	}
+	if (ioucmd->flags & IORING_URING_CMD_FIXED)
+		req->buf_index =3D READ_ONCE(sqe->buf_index);
+
 	ioucmd->cmd_op =3D READ_ONCE(sqe->cmd_op);
=20
 	return io_uring_cmd_prep_setup(req, sqe);
@@ -261,13 +249,8 @@ int io_uring_cmd_import_fixed(u64 ubuf, unsigned lon=
g len, int rw,
 			      unsigned int issue_flags)
 {
 	struct io_kiocb *req =3D cmd_to_io_kiocb(ioucmd);
-	struct io_rsrc_node *node =3D req->buf_node;
-
-	/* Must have had rsrc_node assigned at prep time */
-	if (node)
-		return io_import_fixed(rw, iter, node->buf, ubuf, len);
=20
-	return -EFAULT;
+	return io_import_reg_buf(req, iter, ubuf, len, rw, issue_flags);
 }
 EXPORT_SYMBOL_GPL(io_uring_cmd_import_fixed);
=20
--=20
2.43.5


