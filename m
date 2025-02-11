Return-Path: <io-uring+bounces-6337-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F0AEBA2FFCF
	for <lists+io-uring@lfdr.de>; Tue, 11 Feb 2025 01:58:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2B50D3A43C0
	for <lists+io-uring@lfdr.de>; Tue, 11 Feb 2025 00:57:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EDEC3EA98;
	Tue, 11 Feb 2025 00:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="g6MMfPJn"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 565F614F6C
	for <io-uring@vger.kernel.org>; Tue, 11 Feb 2025 00:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739235429; cv=none; b=LWemsIACJSA/Wn/rWq0wQK2bRj1TSosc2V4rUjsIT50Cxb1w01Cb6N1TKa3LJqiD0uN09OG+B6jFUDweAA1f6+2a5sJRLzWBHEuibiEBe+g3DhFpJr/l5VguALpxhFV8kgg+TOBYt44Eu8UaartznMvbUL57CPuBVl1ALLPk3jY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739235429; c=relaxed/simple;
	bh=aDx84VkQIL5gCLLyhuqIDrykvPd3HZ/Lifqgzd+YN1E=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sKMS1/OHa0OJb8H6PBKfqHO8gwSL/f0M7IM1xOj9PEY59uRa7Hd/ZwSRIDeDdu4o/ZsjHsppQgXuLUWfd3lp3rXap8r/6s49/lJbwp2ATJSifQPtkxIUTennurCXPBH8BT1SBtsbwW59SwlhI5ATNM8cJNk4UzRlZnMql9727mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=g6MMfPJn; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51B0r2ea000380
	for <io-uring@vger.kernel.org>; Mon, 10 Feb 2025 16:57:06 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2021-q4;
	 bh=tjUaNQokNtVIUdBrkdaK5QxUMaL13Zgxdko+X2qAKTY=; b=g6MMfPJnL1nv
	oQLwuxUcyVXwGrRUmPwm4vYY9YtibIFqccjw64MlgiE44cRT5qVj7MMOz0pK2lnO
	137/zyq+vpliyINr0ljHEtEE+nNt6yrAcFSq3EivPwnVMTFkhYxVcfJrNyOmI1zQ
	N8vQFhX19TMoOvlexQqvJy0VKx8227dkZptVVNJZXCH30LCr5LEPX9erb2mjcLkz
	MEriRgs6oXhd9405TwTOe2YdO9l6jXwwsnl/sNHEppAGZV06JjDCNV4ehAHIaPq/
	041q3fQhST3AavHUJ8Ubgb69hLnb1U5XNFO5K8Q1mMwXEeoi+bwb7/oO0lLb4ios
	bJlrBaUhPQ==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 44qvcf00ra-4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Mon, 10 Feb 2025 16:57:05 -0800 (PST)
Received: from twshared11082.06.ash8.facebook.com (2620:10d:c0a8:1b::30) by
 mail.thefacebook.com (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.14; Tue, 11 Feb 2025 00:56:58 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id 9F97717E18F85; Mon, 10 Feb 2025 16:56:48 -0800 (PST)
From: Keith Busch <kbusch@meta.com>
To: <ming.lei@redhat.com>, <asml.silence@gmail.com>, <axboe@kernel.dk>,
        <linux-block@vger.kernel.org>, <io-uring@vger.kernel.org>
CC: <bernd@bsbernd.com>, Keith Busch <kbusch@kernel.org>
Subject: [PATCHv2 5/6] io_uring: add abstraction for buf_table rsrc data
Date: Mon, 10 Feb 2025 16:56:45 -0800
Message-ID: <20250211005646.222452-6-kbusch@meta.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250211005646.222452-1-kbusch@meta.com>
References: <20250211005646.222452-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: 9RiCutx4PgZ_jAqocjj0u0iXg8Wjz2VT
X-Proofpoint-ORIG-GUID: 9RiCutx4PgZ_jAqocjj0u0iXg8Wjz2VT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-10_12,2025-02-10_01,2024-11-22_01

From: Keith Busch <kbusch@kernel.org>

We'll need to add more fields specific to the registered buffers, so
make a layer for it now. No functional change in this patch.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 include/linux/io_uring_types.h |  6 +++-
 io_uring/fdinfo.c              |  8 +++---
 io_uring/net.c                 |  2 +-
 io_uring/nop.c                 |  2 +-
 io_uring/register.c            |  2 +-
 io_uring/rsrc.c                | 51 +++++++++++++++++-----------------
 io_uring/rw.c                  |  2 +-
 io_uring/uring_cmd.c           |  2 +-
 8 files changed, 39 insertions(+), 36 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_type=
s.h
index 99aac2d52fbae..4f4b7ad21500d 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -67,6 +67,10 @@ struct io_file_table {
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
@@ -291,7 +295,7 @@ struct io_ring_ctx {
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
diff --git a/io_uring/net.c b/io_uring/net.c
index 280d576e89249..c1020c857333d 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1366,7 +1366,7 @@ static int io_send_zc_import(struct io_kiocb *req, =
unsigned int issue_flags)
=20
 		ret =3D -EFAULT;
 		io_ring_submit_lock(ctx, issue_flags);
-		node =3D io_rsrc_node_lookup(&ctx->buf_table, sr->buf_index);
+		node =3D io_rsrc_node_lookup(&ctx->buf_table.data, sr->buf_index);
 		if (node) {
 			io_req_assign_buf_node(sr->notif, node);
 			ret =3D 0;
diff --git a/io_uring/nop.c b/io_uring/nop.c
index 5e5196df650a1..e3ebe5f019076 100644
--- a/io_uring/nop.c
+++ b/io_uring/nop.c
@@ -69,7 +69,7 @@ int io_nop(struct io_kiocb *req, unsigned int issue_fla=
gs)
=20
 		ret =3D -EFAULT;
 		io_ring_submit_lock(ctx, issue_flags);
-		node =3D io_rsrc_node_lookup(&ctx->buf_table, nop->buffer);
+		node =3D io_rsrc_node_lookup(&ctx->buf_table.data, nop->buffer);
 		if (node) {
 			io_req_assign_buf_node(req, node);
 			ret =3D 0;
diff --git a/io_uring/register.c b/io_uring/register.c
index 9a4d2fbce4aec..fa922b1b26583 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -919,7 +919,7 @@ SYSCALL_DEFINE4(io_uring_register, unsigned int, fd, =
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
index 14efec8587888..b3f36f1b2a668 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -232,17 +232,17 @@ static int __io_sqe_buffers_update(struct io_ring_c=
tx *ctx,
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
 		struct io_rsrc_node *node;
 		u64 tag =3D 0;
=20
-		i =3D array_index_nospec(up->offset + done, ctx->buf_table.nr);
-		node =3D io_rsrc_node_lookup(&ctx->buf_table, i);
+		i =3D array_index_nospec(up->offset + done, ctx->buf_table.data.nr);
+		node =3D io_rsrc_node_lookup(&ctx->buf_table.data, i);
 		if (node && node->type !=3D IORING_RSRC_BUFFER) {
 			err =3D -EBUSY;
 			break;
@@ -273,8 +273,8 @@ static int __io_sqe_buffers_update(struct io_ring_ctx=
 *ctx,
 			}
 			node->tag =3D tag;
 		}
-		io_reset_rsrc_node(ctx, &ctx->buf_table, i);
-		ctx->buf_table.nodes[i] =3D node;
+		io_reset_rsrc_node(ctx, &ctx->buf_table.data, i);
+		ctx->buf_table.data.nodes[i] =3D node;
 		if (ctx->compat)
 			user_data +=3D sizeof(struct compat_iovec);
 		else
@@ -555,9 +555,9 @@ int io_sqe_files_register(struct io_ring_ctx *ctx, vo=
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
@@ -584,8 +584,8 @@ static bool headpage_already_acct(struct io_ring_ctx =
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
@@ -811,7 +811,7 @@ int io_sqe_buffers_register(struct io_ring_ctx *ctx, =
void __user *arg,
=20
 	BUILD_BUG_ON(IORING_MAX_REG_BUFFERS >=3D (1u << 16));
=20
-	if (ctx->buf_table.nr)
+	if (ctx->buf_table.data.nr)
 		return -EBUSY;
 	if (!nr_args || nr_args > IORING_MAX_REG_BUFFERS)
 		return -EINVAL;
@@ -864,7 +864,7 @@ int io_sqe_buffers_register(struct io_ring_ctx *ctx, =
void __user *arg,
 		data.nodes[i] =3D node;
 	}
=20
-	ctx->buf_table =3D data;
+	ctx->buf_table.data =3D data;
 	if (ret)
 		io_sqe_buffers_unregister(ctx);
 	return ret;
@@ -873,7 +873,7 @@ int io_sqe_buffers_register(struct io_ring_ctx *ctx, =
void __user *arg,
 int io_buffer_register_bvec(struct io_ring_ctx *ctx, struct request *rq,
 			    void (*release)(void *), unsigned int index)
 {
-	struct io_rsrc_data *data =3D &ctx->buf_table;
+	struct io_rsrc_data *data =3D &ctx->buf_table.data;
 	struct req_iterator rq_iter;
 	struct io_mapped_ubuf *imu;
 	struct io_rsrc_node *node;
@@ -924,7 +924,7 @@ EXPORT_SYMBOL_GPL(io_buffer_register_bvec);
=20
 void io_buffer_unregister_bvec(struct io_ring_ctx *ctx, unsigned int ind=
ex)
 {
-	struct io_rsrc_data *data =3D &ctx->buf_table;
+	struct io_rsrc_data *data =3D &ctx->buf_table.data;
 	struct io_rsrc_node *node;
=20
 	lockdep_assert_held(&ctx->uring_lock);
@@ -1040,10 +1040,10 @@ static int io_clone_buffers(struct io_ring_ctx *c=
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
@@ -1053,13 +1053,13 @@ static int io_clone_buffers(struct io_ring_ctx *c=
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
@@ -1068,7 +1068,7 @@ static int io_clone_buffers(struct io_ring_ctx *ctx=
, struct io_ring_ctx *src_ctx
 	}
=20
 	ret =3D -ENXIO;
-	nbufs =3D src_ctx->buf_table.nr;
+	nbufs =3D src_ctx->buf_table.data.nr;
 	if (!nbufs)
 		goto out_free;
 	ret =3D -EINVAL;
@@ -1088,7 +1088,7 @@ static int io_clone_buffers(struct io_ring_ctx *ctx=
, struct io_ring_ctx *src_ctx
 	while (nr--) {
 		struct io_rsrc_node *dst_node, *src_node;
=20
-		src_node =3D io_rsrc_node_lookup(&src_ctx->buf_table, i);
+		src_node =3D io_rsrc_node_lookup(&src_ctx->buf_table.data, i);
 		if (!src_node) {
 			dst_node =3D NULL;
 		} else {
@@ -1110,7 +1110,7 @@ static int io_clone_buffers(struct io_ring_ctx *ctx=
, struct io_ring_ctx *src_ctx
 	 * old and new nodes at this point.
 	 */
 	if (arg->flags & IORING_REGISTER_DST_REPLACE)
-		io_rsrc_data_free(ctx, &ctx->buf_table);
+		io_sqe_buffers_unregister(ctx);
=20
 	/*
 	 * ctx->buf_table must be empty now - either the contents are being
@@ -1118,10 +1118,9 @@ static int io_clone_buffers(struct io_ring_ctx *ct=
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
@@ -1146,7 +1145,7 @@ int io_register_clone_buffers(struct io_ring_ctx *c=
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
diff --git a/io_uring/rw.c b/io_uring/rw.c
index c25e0ab5c996b..38ec32401a558 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -363,7 +363,7 @@ static int io_prep_rw_fixed(struct io_kiocb *req, con=
st struct io_uring_sqe *sqe
 	if (unlikely(ret))
 		return ret;
=20
-	node =3D io_rsrc_node_lookup(&ctx->buf_table, req->buf_index);
+	node =3D io_rsrc_node_lookup(&ctx->buf_table.data, req->buf_index);
 	if (!node)
 		return -EFAULT;
 	io_req_assign_buf_node(req, node);
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index aebbe2a4c7183..5d9719402b49b 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -206,7 +206,7 @@ int io_uring_cmd_prep(struct io_kiocb *req, const str=
uct io_uring_sqe *sqe)
 		struct io_rsrc_node *node;
 		u16 index =3D READ_ONCE(sqe->buf_index);
=20
-		node =3D io_rsrc_node_lookup(&ctx->buf_table, index);
+		node =3D io_rsrc_node_lookup(&ctx->buf_table.data, index);
 		if (unlikely(!node))
 			return -EFAULT;
 		/*
--=20
2.43.5


