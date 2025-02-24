Return-Path: <io-uring+bounces-6715-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 78373A42F21
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 22:31:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 606C916EB57
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 21:31:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93830487BF;
	Mon, 24 Feb 2025 21:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="iFS7RaV8"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0A963B784
	for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 21:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740432695; cv=none; b=I1ztCFrCcco/s6WCEpQUuR8ddjdqv42qWRpgW7YUO0xZBG+31gTJMk05+6UwbMPUG/if3+MaPPaV9nfQxhpE4wuSdtlRURoYm/Y0LH2VX0gMOf0m9V09MfC+IVNxQpD9+bONXsn1Xz9W6MwdFkrkdK6snzrYqYLK4DrQMRXMgos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740432695; c=relaxed/simple;
	bh=4QXO9kgSaFBs3zesSCvMupj6jtAvlDHwv0HHIWiATBs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h2V12Utk5U+zkHTme1PlVmiKwcG/O1hQiYVzG8wQKL2npY4urhVVZBXuAOWj8h66cafPd3AYHBqJXVrzfoCqaHaO3jVmMW4zxsXRXob9xIDY8CftxHwnozzCUfzIZ5dtjaYyQghEcxEJ/pGYvrBNhNPM+jheNLfBnUObGJ8E4+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=iFS7RaV8; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51OFDHRk023683
	for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 13:31:32 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2021-q4;
	 bh=SzPTxtOY366aymp192PDyGyrXvJFVFKdQu4O1jQw+mg=; b=iFS7RaV835OF
	e4j+FzB8YqpqGJYRXYpRzoavMfXqr5kTAbJev/3+OCjhNsoR5pV2brT6HGWyE907
	dxChBY1SciSBaH+/L2XeTReBnJlBQ/T2yPnogQ7YLeV2qa06WUB5FojQYM9XcBZt
	L2cBl7FhEXQ+hNxQ7gIT/5zfVVJGRza6gFOplH6qaru4e0ZQSdXdHNodLFmWM3x3
	P0tlnbXbDn5lSmu1kJil4ZUkkDE53nPKh+/lg7OuXJqBWykV0VEKZZVT8Nra8m95
	GRbopvd8dheNaJqEp6xE3r58mbl1RgsQf00Mb9/CEwDvhZP+ehsX1vjv/X6HTMd7
	Umg2sdpGgw==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 450tdcufr4-17
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 13:31:32 -0800 (PST)
Received: from twshared7122.08.ash9.facebook.com (2620:10d:c0a8:1b::2d) by
 mail.thefacebook.com (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.14; Mon, 24 Feb 2025 21:31:18 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id A3DD01868C4FA; Mon, 24 Feb 2025 13:31:17 -0800 (PST)
From: Keith Busch <kbusch@meta.com>
To: <ming.lei@redhat.com>, <asml.silence@gmail.com>, <axboe@kernel.dk>,
        <linux-block@vger.kernel.org>, <io-uring@vger.kernel.org>
CC: <bernd@bsbernd.com>, <csander@purestorage.com>,
        Keith Busch
	<kbusch@kernel.org>
Subject: [PATCHv5 10/11] io_uring: add abstraction for buf_table rsrc data
Date: Mon, 24 Feb 2025 13:31:15 -0800
Message-ID: <20250224213116.3509093-11-kbusch@meta.com>
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
X-Proofpoint-GUID: BxI00-o8a8INk3k_TNHFlFdOAoH842Cv
X-Proofpoint-ORIG-GUID: BxI00-o8a8INk3k_TNHFlFdOAoH842Cv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-24_10,2025-02-24_02,2024-11-22_01

From: Keith Busch <kbusch@kernel.org>

We'll need to add more fields specific to the registered buffers, so
make a layer for it now. No functional change in this patch.

Reviewed-by: Caleb Sander Mateos <csander@purestorage.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 include/linux/io_uring_types.h |  6 +++-
 io_uring/fdinfo.c              |  8 +++---
 io_uring/nop.c                 |  2 +-
 io_uring/register.c            |  2 +-
 io_uring/rsrc.c                | 51 +++++++++++++++++-----------------
 5 files changed, 36 insertions(+), 33 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_type=
s.h
index c0fe8a00fe53a..a05ae4cb98a4c 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -69,6 +69,10 @@ struct io_file_table {
 	unsigned int alloc_hint;
 };
=20
+struct io_buf_table {
+	struct io_rsrc_data	data;
+};
+
 struct io_hash_bucket {
 	struct hlist_head	list;
 } ____cacheline_aligned_in_smp;
@@ -293,7 +297,7 @@ struct io_ring_ctx {
 		struct io_wq_work_list	iopoll_list;
=20
 		struct io_file_table	file_table;
-		struct io_rsrc_data	buf_table;
+		struct io_buf_table	buf_table;
=20
 		struct io_submit_state	submit_state;
=20
diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
index f60d0a9d505e2..d389c06cbce10 100644
--- a/io_uring/fdinfo.c
+++ b/io_uring/fdinfo.c
@@ -217,12 +217,12 @@ __cold void io_uring_show_fdinfo(struct seq_file *m=
, struct file *file)
 			seq_puts(m, "\n");
 		}
 	}
-	seq_printf(m, "UserBufs:\t%u\n", ctx->buf_table.nr);
-	for (i =3D 0; has_lock && i < ctx->buf_table.nr; i++) {
+	seq_printf(m, "UserBufs:\t%u\n", ctx->buf_table.data.nr);
+	for (i =3D 0; has_lock && i < ctx->buf_table.data.nr; i++) {
 		struct io_mapped_ubuf *buf =3D NULL;
=20
-		if (ctx->buf_table.nodes[i])
-			buf =3D ctx->buf_table.nodes[i]->buf;
+		if (ctx->buf_table.data.nodes[i])
+			buf =3D ctx->buf_table.data.nodes[i]->buf;
 		if (buf)
 			seq_printf(m, "%5u: 0x%llx/%u\n", i, buf->ubuf, buf->len);
 		else
diff --git a/io_uring/nop.c b/io_uring/nop.c
index ea539531cb5f6..da8870e00eee7 100644
--- a/io_uring/nop.c
+++ b/io_uring/nop.c
@@ -66,7 +66,7 @@ int io_nop(struct io_kiocb *req, unsigned int issue_fla=
gs)
=20
 		ret =3D -EFAULT;
 		io_ring_submit_lock(ctx, issue_flags);
-		node =3D io_rsrc_node_lookup(&ctx->buf_table, req->buf_index);
+		node =3D io_rsrc_node_lookup(&ctx->buf_table.data, req->buf_index);
 		if (node) {
 			io_req_assign_buf_node(req, node);
 			ret =3D 0;
diff --git a/io_uring/register.c b/io_uring/register.c
index cc23a4c205cd4..f15a8d52ad30f 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -926,7 +926,7 @@ SYSCALL_DEFINE4(io_uring_register, unsigned int, fd, =
unsigned int, opcode,
 	ret =3D __io_uring_register(ctx, opcode, arg, nr_args);
=20
 	trace_io_uring_register(ctx, opcode, ctx->file_table.data.nr,
-				ctx->buf_table.nr, ret);
+				ctx->buf_table.data.nr, ret);
 	mutex_unlock(&ctx->uring_lock);
=20
 	fput(file);
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index e0c6ed3aef5b5..70558317fbb2b 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -236,9 +236,9 @@ static int __io_sqe_buffers_update(struct io_ring_ctx=
 *ctx,
 	__u32 done;
 	int i, err;
=20
-	if (!ctx->buf_table.nr)
+	if (!ctx->buf_table.data.nr)
 		return -ENXIO;
-	if (up->offset + nr_args > ctx->buf_table.nr)
+	if (up->offset + nr_args > ctx->buf_table.data.nr)
 		return -EINVAL;
=20
 	for (done =3D 0; done < nr_args; done++) {
@@ -270,9 +270,9 @@ static int __io_sqe_buffers_update(struct io_ring_ctx=
 *ctx,
 			}
 			node->tag =3D tag;
 		}
-		i =3D array_index_nospec(up->offset + done, ctx->buf_table.nr);
-		io_reset_rsrc_node(ctx, &ctx->buf_table, i);
-		ctx->buf_table.nodes[i] =3D node;
+		i =3D array_index_nospec(up->offset + done, ctx->buf_table.data.nr);
+		io_reset_rsrc_node(ctx, &ctx->buf_table.data, i);
+		ctx->buf_table.data.nodes[i] =3D node;
 		if (ctx->compat)
 			user_data +=3D sizeof(struct compat_iovec);
 		else
@@ -550,9 +550,9 @@ int io_sqe_files_register(struct io_ring_ctx *ctx, vo=
id __user *arg,
=20
 int io_sqe_buffers_unregister(struct io_ring_ctx *ctx)
 {
-	if (!ctx->buf_table.nr)
+	if (!ctx->buf_table.data.nr)
 		return -ENXIO;
-	io_rsrc_data_free(ctx, &ctx->buf_table);
+	io_rsrc_data_free(ctx, &ctx->buf_table.data);
 	return 0;
 }
=20
@@ -579,8 +579,8 @@ static bool headpage_already_acct(struct io_ring_ctx =
*ctx, struct page **pages,
 	}
=20
 	/* check previously registered pages */
-	for (i =3D 0; i < ctx->buf_table.nr; i++) {
-		struct io_rsrc_node *node =3D ctx->buf_table.nodes[i];
+	for (i =3D 0; i < ctx->buf_table.data.nr; i++) {
+		struct io_rsrc_node *node =3D ctx->buf_table.data.nodes[i];
 		struct io_mapped_ubuf *imu;
=20
 		if (!node)
@@ -809,7 +809,7 @@ int io_sqe_buffers_register(struct io_ring_ctx *ctx, =
void __user *arg,
=20
 	BUILD_BUG_ON(IORING_MAX_REG_BUFFERS >=3D (1u << 16));
=20
-	if (ctx->buf_table.nr)
+	if (ctx->buf_table.data.nr)
 		return -EBUSY;
 	if (!nr_args || nr_args > IORING_MAX_REG_BUFFERS)
 		return -EINVAL;
@@ -862,7 +862,7 @@ int io_sqe_buffers_register(struct io_ring_ctx *ctx, =
void __user *arg,
 		data.nodes[i] =3D node;
 	}
=20
-	ctx->buf_table =3D data;
+	ctx->buf_table.data =3D data;
 	if (ret)
 		io_sqe_buffers_unregister(ctx);
 	return ret;
@@ -873,7 +873,7 @@ int io_buffer_register_bvec(struct io_uring_cmd *cmd,=
 struct request *rq,
 			    unsigned int issue_flags)
 {
 	struct io_ring_ctx *ctx =3D cmd_to_io_kiocb(cmd)->ctx;
-	struct io_rsrc_data *data =3D &ctx->buf_table;
+	struct io_rsrc_data *data =3D &ctx->buf_table.data;
 	struct req_iterator rq_iter;
 	struct io_mapped_ubuf *imu;
 	struct io_rsrc_node *node;
@@ -938,7 +938,7 @@ void io_buffer_unregister_bvec(struct io_uring_cmd *c=
md, unsigned int index,
 			       unsigned int issue_flags)
 {
 	struct io_ring_ctx *ctx =3D cmd_to_io_kiocb(cmd)->ctx;
-	struct io_rsrc_data *data =3D &ctx->buf_table;
+	struct io_rsrc_data *data =3D &ctx->buf_table.data;
 	struct io_rsrc_node *node;
=20
 	io_ring_submit_lock(ctx, issue_flags);
@@ -1035,7 +1035,7 @@ static inline struct io_rsrc_node *io_find_buf_node=
(struct io_kiocb *req,
 		return req->buf_node;
=20
 	io_ring_submit_lock(ctx, issue_flags);
-	node =3D io_rsrc_node_lookup(&ctx->buf_table, req->buf_index);
+	node =3D io_rsrc_node_lookup(&ctx->buf_table.data, req->buf_index);
 	if (node)
 		io_req_assign_buf_node(req, node);
 	io_ring_submit_unlock(ctx, issue_flags);
@@ -1085,10 +1085,10 @@ static int io_clone_buffers(struct io_ring_ctx *c=
tx, struct io_ring_ctx *src_ctx
 	if (!arg->nr && (arg->dst_off || arg->src_off))
 		return -EINVAL;
 	/* not allowed unless REPLACE is set */
-	if (ctx->buf_table.nr && !(arg->flags & IORING_REGISTER_DST_REPLACE))
+	if (ctx->buf_table.data.nr && !(arg->flags & IORING_REGISTER_DST_REPLAC=
E))
 		return -EBUSY;
=20
-	nbufs =3D src_ctx->buf_table.nr;
+	nbufs =3D src_ctx->buf_table.data.nr;
 	if (!arg->nr)
 		arg->nr =3D nbufs;
 	else if (arg->nr > nbufs)
@@ -1098,13 +1098,13 @@ static int io_clone_buffers(struct io_ring_ctx *c=
tx, struct io_ring_ctx *src_ctx
 	if (check_add_overflow(arg->nr, arg->dst_off, &nbufs))
 		return -EOVERFLOW;
=20
-	ret =3D io_rsrc_data_alloc(&data, max(nbufs, ctx->buf_table.nr));
+	ret =3D io_rsrc_data_alloc(&data, max(nbufs, ctx->buf_table.data.nr));
 	if (ret)
 		return ret;
=20
 	/* Fill entries in data from dst that won't overlap with src */
-	for (i =3D 0; i < min(arg->dst_off, ctx->buf_table.nr); i++) {
-		struct io_rsrc_node *src_node =3D ctx->buf_table.nodes[i];
+	for (i =3D 0; i < min(arg->dst_off, ctx->buf_table.data.nr); i++) {
+		struct io_rsrc_node *src_node =3D ctx->buf_table.data.nodes[i];
=20
 		if (src_node) {
 			data.nodes[i] =3D src_node;
@@ -1113,7 +1113,7 @@ static int io_clone_buffers(struct io_ring_ctx *ctx=
, struct io_ring_ctx *src_ctx
 	}
=20
 	ret =3D -ENXIO;
-	nbufs =3D src_ctx->buf_table.nr;
+	nbufs =3D src_ctx->buf_table.data.nr;
 	if (!nbufs)
 		goto out_free;
 	ret =3D -EINVAL;
@@ -1133,7 +1133,7 @@ static int io_clone_buffers(struct io_ring_ctx *ctx=
, struct io_ring_ctx *src_ctx
 	while (nr--) {
 		struct io_rsrc_node *dst_node, *src_node;
=20
-		src_node =3D io_rsrc_node_lookup(&src_ctx->buf_table, i);
+		src_node =3D io_rsrc_node_lookup(&src_ctx->buf_table.data, i);
 		if (!src_node) {
 			dst_node =3D NULL;
 		} else {
@@ -1155,7 +1155,7 @@ static int io_clone_buffers(struct io_ring_ctx *ctx=
, struct io_ring_ctx *src_ctx
 	 * old and new nodes at this point.
 	 */
 	if (arg->flags & IORING_REGISTER_DST_REPLACE)
-		io_rsrc_data_free(ctx, &ctx->buf_table);
+		io_sqe_buffers_unregister(ctx);
=20
 	/*
 	 * ctx->buf_table must be empty now - either the contents are being
@@ -1163,10 +1163,9 @@ static int io_clone_buffers(struct io_ring_ctx *ct=
x, struct io_ring_ctx *src_ctx
 	 * copied to a ring that does not have buffers yet (checked at function
 	 * entry).
 	 */
-	WARN_ON_ONCE(ctx->buf_table.nr);
-	ctx->buf_table =3D data;
+	WARN_ON_ONCE(ctx->buf_table.data.nr);
+	ctx->buf_table.data =3D data;
 	return 0;
-
 out_free:
 	io_rsrc_data_free(ctx, &data);
 	return ret;
@@ -1191,7 +1190,7 @@ int io_register_clone_buffers(struct io_ring_ctx *c=
tx, void __user *arg)
 		return -EFAULT;
 	if (buf.flags & ~(IORING_REGISTER_SRC_REGISTERED|IORING_REGISTER_DST_RE=
PLACE))
 		return -EINVAL;
-	if (!(buf.flags & IORING_REGISTER_DST_REPLACE) && ctx->buf_table.nr)
+	if (!(buf.flags & IORING_REGISTER_DST_REPLACE) && ctx->buf_table.data.n=
r)
 		return -EBUSY;
 	if (memchr_inv(buf.pad, 0, sizeof(buf.pad)))
 		return -EINVAL;
--=20
2.43.5


