Return-Path: <io-uring+bounces-6218-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AA3C2A25F1B
	for <lists+io-uring@lfdr.de>; Mon,  3 Feb 2025 16:45:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BCB813A1372
	for <lists+io-uring@lfdr.de>; Mon,  3 Feb 2025 15:45:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B290420A5CB;
	Mon,  3 Feb 2025 15:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="W32OAkFU"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00FE3209F51
	for <io-uring@vger.kernel.org>; Mon,  3 Feb 2025 15:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738597534; cv=none; b=norVBTfcQNmDP4kXmxMG4vbYbqrA76fHaIwYZNj7QEAoVCnr+nCnZwxOjLuRD7Peh6b4Yd2JMV7RDIeTokqUBoQWu0zJGuYOiN0nQcExicEbLH9NiFLhnUUoONFF409pn5gZwIv57jrba+UtvtnL4pwCfQi0wPg5GhyNHNB7y9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738597534; c=relaxed/simple;
	bh=iGwJy0xxxT4cW2JStwaaWKDfqCALgv7350+0pJtcn5U=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I8rp4+0z3EmxEMqz5ICPOPvqwineBK2eMFza9mdTjgtgWaGY+HGqds2TXR0a6R1N2vSeqm8etxK3M73ewVKoDVaYg5TBYi5ATDPr9zf+tzuP8QMdBkds2RwTsLWgUmYuOPq8Ef8OIyx/0EM3ZQujuz7uclQR5So6AY+ydME7tCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=W32OAkFU; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 513EgrgA024327
	for <io-uring@vger.kernel.org>; Mon, 3 Feb 2025 07:45:32 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2021-q4;
	 bh=UeW6u/xHhzsFPWCGNHvAmyxD0N+OyrFYsJKAK1Frqxw=; b=W32OAkFUj+83
	4dfzPAxt3gof8iqjMhHlmLF36kDzi3e1LhgBVPCU7ePFCZzYwazse0aBlBMv6lNk
	rp63HT4ze9mib4mwasev4PNwvaq6YKHymwe9rV6eP6nCDsAw2jCEpWy3OAvUtacZ
	mpzsICRmAw3g2lGsPbhIqhCFi+h99281yTCrKRA9Q65nBX9dq/UxTaA0iMRDnVn4
	rVXqo8MF8cH/buSWKI+aVUfkLMUlDFjDDAWoey53Oz+MuUcYM4JiAPa20FhkxxHL
	IZ9e8Edyqt2rcAyIgq+dWfxXefgJFlNzEi1tuH0f50kRZBiQaCHBVEbize4JWMmW
	cRGp5QDX1A==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 44jwu4s7r7-12
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Mon, 03 Feb 2025 07:45:32 -0800 (PST)
Received: from twshared55211.03.ash8.facebook.com (2620:10d:c085:208::7cb7) by
 mail.thefacebook.com (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.14; Mon, 3 Feb 2025 15:45:27 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id 13095179A984D; Mon,  3 Feb 2025 07:45:21 -0800 (PST)
From: Keith Busch <kbusch@meta.com>
To: <io-uring@vger.kernel.org>, <linux-block@vger.kernel.org>,
        <ming.lei@redhat.com>, <axboe@kernel.dk>, <asml.silence@gmail.com>
CC: Keith Busch <kbusch@kernel.org>
Subject: [PATCH 3/6] io_uring: add support for kernel registered bvecs
Date: Mon, 3 Feb 2025 07:45:14 -0800
Message-ID: <20250203154517.937623-4-kbusch@meta.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250203154517.937623-1-kbusch@meta.com>
References: <20250203154517.937623-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: TxsDFwWSN_byaJrMg9ozLXFdFGslu2J3
X-Proofpoint-GUID: TxsDFwWSN_byaJrMg9ozLXFdFGslu2J3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-03_06,2025-01-31_02,2024-11-22_01

From: Keith Busch <kbusch@kernel.org>

Provide an interface for the kernel to leverage the existing
pre-registered buffers that io_uring provides. User space can reference
these later to achieve zero-copy IO.

User space must register an empty fixed buffer table with io_uring in
order for the kernel to make use of it.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 include/linux/io_uring.h       |   1 +
 include/linux/io_uring_types.h |   3 +
 io_uring/rsrc.c                | 114 +++++++++++++++++++++++++++++++--
 io_uring/rsrc.h                |   1 +
 4 files changed, 114 insertions(+), 5 deletions(-)

diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index 85fe4e6b275c7..b5637a2aae340 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -5,6 +5,7 @@
 #include <linux/sched.h>
 #include <linux/xarray.h>
 #include <uapi/linux/io_uring.h>
+#include <linux/blk-mq.h>
=20
 #if defined(CONFIG_IO_URING)
 void __io_uring_cancel(bool cancel_all);
diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_type=
s.h
index 623d8e798a11a..7e5a5a70c35f2 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -695,4 +695,7 @@ static inline bool io_ctx_cqe32(struct io_ring_ctx *c=
tx)
 	return ctx->flags & IORING_SETUP_CQE32;
 }
=20
+int io_buffer_register_bvec(struct io_ring_ctx *ctx, const struct reques=
t *rq, unsigned int tag);
+void io_buffer_unregister_bvec(struct io_ring_ctx *ctx, unsigned int tag=
);
+
 #endif
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 4d0e1c06c8bc6..8c4c374abcc10 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -111,7 +111,10 @@ static void io_buffer_unmap(struct io_ring_ctx *ctx,=
 struct io_rsrc_node *node)
 		if (!refcount_dec_and_test(&imu->refs))
 			return;
 		for (i =3D 0; i < imu->nr_bvecs; i++)
-			unpin_user_page(imu->bvec[i].bv_page);
+			if (node->type =3D=3D IORING_RSRC_KBUF)
+				put_page(imu->bvec[i].bv_page);
+			else
+				unpin_user_page(imu->bvec[i].bv_page);
 		if (imu->acct_pages)
 			io_unaccount_mem(ctx, imu->acct_pages);
 		kvfree(imu);
@@ -240,6 +243,13 @@ static int __io_sqe_buffers_update(struct io_ring_ct=
x *ctx,
 		struct io_rsrc_node *node;
 		u64 tag =3D 0;
=20
+		i =3D array_index_nospec(up->offset + done, ctx->buf_table.nr);
+		node =3D io_rsrc_node_lookup(&ctx->buf_table, i);
+		if (node && node->type !=3D IORING_RSRC_BUFFER) {
+			err =3D -EBUSY;
+			break;
+		}
+
 		uvec =3D u64_to_user_ptr(user_data);
 		iov =3D iovec_from_user(uvec, 1, 1, &fast_iov, ctx->compat);
 		if (IS_ERR(iov)) {
@@ -258,6 +268,7 @@ static int __io_sqe_buffers_update(struct io_ring_ctx=
 *ctx,
 			err =3D PTR_ERR(node);
 			break;
 		}
+
 		if (tag) {
 			if (!node) {
 				err =3D -EINVAL;
@@ -265,7 +276,6 @@ static int __io_sqe_buffers_update(struct io_ring_ctx=
 *ctx,
 			}
 			node->tag =3D tag;
 		}
-		i =3D array_index_nospec(up->offset + done, ctx->buf_table.nr);
 		io_reset_rsrc_node(ctx, &ctx->buf_table, i);
 		ctx->buf_table.nodes[i] =3D node;
 		if (ctx->compat)
@@ -453,6 +463,7 @@ void io_free_rsrc_node(struct io_ring_ctx *ctx, struc=
t io_rsrc_node *node)
 			fput(io_slot_file(node));
 		break;
 	case IORING_RSRC_BUFFER:
+	case IORING_RSRC_KBUF:
 		if (node->buf)
 			io_buffer_unmap(ctx, node);
 		break;
@@ -860,6 +871,92 @@ int io_sqe_buffers_register(struct io_ring_ctx *ctx,=
 void __user *arg,
 	return ret;
 }
=20
+static struct io_rsrc_node *io_buffer_alloc_node(struct io_ring_ctx *ctx=
,
+						 unsigned int nr_bvecs,
+						 unsigned int len)
+{
+	struct io_mapped_ubuf *imu;
+	struct io_rsrc_node *node;
+
+	node =3D io_rsrc_node_alloc(IORING_RSRC_KBUF);
+	if (!node)
+		return NULL;
+
+	imu =3D kvmalloc(struct_size(imu, bvec, nr_bvecs), GFP_KERNEL);
+	if (!imu) {
+		io_put_rsrc_node(ctx, node);
+		return NULL;
+	}
+
+	imu->ubuf =3D 0;
+	imu->len =3D len;
+	imu->acct_pages =3D 0;
+	imu->nr_bvecs =3D nr_bvecs;
+	refcount_set(&imu->refs, 1);
+
+	node->buf =3D imu;
+	return node;
+}
+
+int io_buffer_register_bvec(struct io_ring_ctx *ctx, const struct reques=
t *rq,
+			    unsigned int index)
+{
+	struct io_rsrc_data *data =3D &ctx->buf_table;
+	u16 nr_bvecs =3D blk_rq_nr_phys_segments(rq);
+	struct req_iterator rq_iter;
+	struct io_rsrc_node *node;
+	struct bio_vec bv;
+	int i =3D 0;
+
+	lockdep_assert_held(&ctx->uring_lock);
+
+	if (WARN_ON_ONCE(!data->nr))
+		return -EINVAL;
+	if (WARN_ON_ONCE(index >=3D data->nr))
+		return -EINVAL;
+
+	node =3D data->nodes[index];
+	if (WARN_ON_ONCE(node))
+		return -EBUSY;
+
+	node =3D io_buffer_alloc_node(ctx, nr_bvecs, blk_rq_bytes(rq));
+	if (!node)
+		return -ENOMEM;
+
+	rq_for_each_bvec(bv, rq, rq_iter) {
+		get_page(bv.bv_page);
+		node->buf->bvec[i].bv_page =3D bv.bv_page;
+		node->buf->bvec[i].bv_len =3D bv.bv_len;
+		node->buf->bvec[i].bv_offset =3D bv.bv_offset;
+		i++;
+	}
+	data->nodes[index] =3D node;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(io_buffer_register_bvec);
+
+void io_buffer_unregister_bvec(struct io_ring_ctx *ctx, unsigned int ind=
ex)
+{
+	struct io_rsrc_data *data =3D &ctx->buf_table;
+	struct io_rsrc_node *node;
+
+	lockdep_assert_held(&ctx->uring_lock);
+
+	if (WARN_ON_ONCE(!data->nr))
+		return;
+	if (WARN_ON_ONCE(index >=3D data->nr))
+		return;
+
+	node =3D data->nodes[index];
+	if (WARN_ON_ONCE(!node || !node->buf))
+		return;
+	if (WARN_ON_ONCE(node->type !=3D IORING_RSRC_KBUF))
+		return;
+	io_reset_rsrc_node(ctx, data, index);
+}
+EXPORT_SYMBOL_GPL(io_buffer_unregister_bvec);
+
 int io_import_fixed(int ddir, struct iov_iter *iter, struct io_rsrc_node=
 *node,
 		    u64 buf_addr, size_t len)
 {
@@ -886,8 +983,8 @@ int io_import_fixed(int ddir, struct iov_iter *iter, =
struct io_rsrc_node *node,
 		/*
 		 * Don't use iov_iter_advance() here, as it's really slow for
 		 * using the latter parts of a big fixed buffer - it iterates
-		 * over each segment manually. We can cheat a bit here, because
-		 * we know that:
+		 * over each segment manually. We can cheat a bit here for user
+		 * registered nodes, because we know that:
 		 *
 		 * 1) it's a BVEC iter, we set it up
 		 * 2) all bvecs are the same in size, except potentially the
@@ -901,7 +998,14 @@ int io_import_fixed(int ddir, struct iov_iter *iter,=
 struct io_rsrc_node *node,
 		 */
 		const struct bio_vec *bvec =3D imu->bvec;
=20
-		if (offset < bvec->bv_len) {
+		/*
+		 * Kernel buffer bvecs, on the other hand, don't necessarily
+		 * have the size property of user registered ones, so we have
+		 * to use the slow iter advance.
+		 */
+		if (node->type =3D=3D IORING_RSRC_KBUF)
+			iov_iter_advance(iter, offset);
+		else if (offset < bvec->bv_len) {
 			iter->iov_offset =3D offset;
 		} else {
 			unsigned long seg_skip;
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index abd0d5d42c3e1..d1d90d9cd2b43 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -13,6 +13,7 @@
 enum {
 	IORING_RSRC_FILE		=3D 0,
 	IORING_RSRC_BUFFER		=3D 1,
+	IORING_RSRC_KBUF		=3D 2,
 };
=20
 struct io_rsrc_node {
--=20
2.43.5


