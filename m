Return-Path: <io-uring+bounces-6340-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 060CEA2FFD2
	for <lists+io-uring@lfdr.de>; Tue, 11 Feb 2025 01:58:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F29C83A190E
	for <lists+io-uring@lfdr.de>; Tue, 11 Feb 2025 00:57:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3660541C7F;
	Tue, 11 Feb 2025 00:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="Ln69X+4t"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71D691386C9
	for <io-uring@vger.kernel.org>; Tue, 11 Feb 2025 00:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739235441; cv=none; b=VyZvUBvMd0RPedulnIM7+uPrm+9trYxEMBTUr697WKq4L4bJWacUesHzG/WsK6pAyPzrW2glKWuGMFpZneQ8OQ2ShgtwOr1l7ndmNZpnDFbOJXhLHdkLaFTxMnig+s+9iPfrVKJCzcHArf7rfT8UKHmM059oifDp6Et9+EZd9R4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739235441; c=relaxed/simple;
	bh=lMan0NY60W7Qk75Q1M2IOUcc64e8qyCVkjp55PH55Qc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GNjTpka9+4G6kQMea9aIijpQ8hYVSkAJLoGGxrHBFO9CKoCkZv9xl3C9CjEgMrthzf0oNgqYe6CSWs1KBpV+EN7IlICtRiNjDtsL6Y8YS2n9UloyzT0AANOUb5i/lWGcvE5YbOlimjZqKKSaA4Hy5ausCsoHTMPoQ8iLjbcRTG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=Ln69X+4t; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51B0ogKk026613
	for <io-uring@vger.kernel.org>; Mon, 10 Feb 2025 16:57:18 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2021-q4;
	 bh=Sr6NkfMFcqzBDW1Q2ijpBNbY7WcpN+fJ9t7PtRC1+S4=; b=Ln69X+4tYZkG
	YKEYo2gtS9LOGAeeT56BkZxdVMllmGoHFGh3FKNZ79KotJK8lmEjGWZRFqqff4QB
	XXzISU/MQXos+zjRPfWcvDbiXf7PnTigozy7kKDCZiG5tJHGEdURED1LNPk8h31O
	5JLKLu7TLvByazGBHPqtlA/evqoXjQ5NogUoecabDl8oSilpQq8FcvFKJ95Br9L8
	VsZdyJMxBwVhWLOjN4Hx0SWVnvsi68BQhhacEaanCXa5cR40U+Cx7DLckddFIpHa
	CgYDbHehlIsQ1MllAdnPU9u7u65HaGie18OX7c/fyZ7mRgFo5kp1ieS5LvuzZ2It
	mZSxn2fFOA==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 44qqg2jc01-20
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Mon, 10 Feb 2025 16:57:18 -0800 (PST)
Received: from twshared3076.40.frc1.facebook.com (2620:10d:c0a8:fe::f072) by
 mail.thefacebook.com (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.14; Tue, 11 Feb 2025 00:57:02 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id 9157A17E18F82; Mon, 10 Feb 2025 16:56:48 -0800 (PST)
From: Keith Busch <kbusch@meta.com>
To: <ming.lei@redhat.com>, <asml.silence@gmail.com>, <axboe@kernel.dk>,
        <linux-block@vger.kernel.org>, <io-uring@vger.kernel.org>
CC: <bernd@bsbernd.com>, Keith Busch <kbusch@kernel.org>
Subject: [PATCHv2 3/6] io_uring: add support for kernel registered bvecs
Date: Mon, 10 Feb 2025 16:56:43 -0800
Message-ID: <20250211005646.222452-4-kbusch@meta.com>
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
X-Proofpoint-GUID: shgBRxI_z7JLdHzWxG2B0R5mxw83XW3y
X-Proofpoint-ORIG-GUID: shgBRxI_z7JLdHzWxG2B0R5mxw83XW3y
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-10_12,2025-02-10_01,2024-11-22_01

From: Keith Busch <kbusch@kernel.org>

Provide an interface for the kernel to leverage the existing
pre-registered buffers that io_uring provides. User space can reference
these later to achieve zero-copy IO.

User space must register an empty fixed buffer table with io_uring in
order for the kernel to make use of it.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 include/linux/io_uring.h       |   1 +
 include/linux/io_uring_types.h |   4 ++
 io_uring/rsrc.c                | 100 +++++++++++++++++++++++++++++++--
 io_uring/rsrc.h                |   1 +
 4 files changed, 100 insertions(+), 6 deletions(-)

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
index e2fef264ff8b8..99aac2d52fbae 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -693,4 +693,8 @@ static inline bool io_ctx_cqe32(struct io_ring_ctx *c=
tx)
 	return ctx->flags & IORING_SETUP_CQE32;
 }
=20
+int io_buffer_register_bvec(struct io_ring_ctx *ctx, struct request *rq,
+			    void (*release)(void *), unsigned int index);
+void io_buffer_unregister_bvec(struct io_ring_ctx *ctx, unsigned int tag=
);
+
 #endif
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 30f08cf13ef60..14efec8587888 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -110,8 +110,9 @@ static void io_buffer_unmap(struct io_ring_ctx *ctx, =
struct io_rsrc_node *node)
=20
 		if (!refcount_dec_and_test(&imu->refs))
 			return;
-		for (i =3D 0; i < imu->nr_bvecs; i++)
-			unpin_user_page(imu->bvec[i].bv_page);
+		if (node->type =3D=3D IORING_RSRC_BUFFER)
+			for (i =3D 0; i < imu->nr_bvecs; i++)
+				unpin_user_page(imu->bvec[i].bv_page);
 		if (imu->acct_pages)
 			io_unaccount_mem(ctx, imu->acct_pages);
 		kvfree(imu);
@@ -240,6 +241,13 @@ static int __io_sqe_buffers_update(struct io_ring_ct=
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
@@ -265,7 +273,6 @@ static int __io_sqe_buffers_update(struct io_ring_ctx=
 *ctx,
 			}
 			node->tag =3D tag;
 		}
-		i =3D array_index_nospec(up->offset + done, ctx->buf_table.nr);
 		io_reset_rsrc_node(ctx, &ctx->buf_table, i);
 		ctx->buf_table.nodes[i] =3D node;
 		if (ctx->compat)
@@ -452,6 +459,7 @@ void io_free_rsrc_node(struct io_ring_ctx *ctx, struc=
t io_rsrc_node *node)
 		if (io_slot_file(node))
 			fput(io_slot_file(node));
 		break;
+	case IORING_RSRC_KBUFFER:
 	case IORING_RSRC_BUFFER:
 		if (node->buf)
 			io_buffer_unmap(ctx, node);
@@ -862,6 +870,79 @@ int io_sqe_buffers_register(struct io_ring_ctx *ctx,=
 void __user *arg,
 	return ret;
 }
=20
+int io_buffer_register_bvec(struct io_ring_ctx *ctx, struct request *rq,
+			    void (*release)(void *), unsigned int index)
+{
+	struct io_rsrc_data *data =3D &ctx->buf_table;
+	struct req_iterator rq_iter;
+	struct io_mapped_ubuf *imu;
+	struct io_rsrc_node *node;
+	struct bio_vec bv;
+	u16 nr_bvecs;
+	int i =3D 0;
+
+	lockdep_assert_held(&ctx->uring_lock);
+
+	if (!data->nr)
+		return -EINVAL;
+	if (index >=3D data->nr)
+		return -EINVAL;
+
+	node =3D data->nodes[index];
+	if (node)
+		return -EBUSY;
+
+	node =3D io_rsrc_node_alloc(IORING_RSRC_KBUFFER);
+	if (!node)
+		return -ENOMEM;
+
+	node->release =3D release;
+	node->priv =3D rq;
+
+	nr_bvecs =3D blk_rq_nr_phys_segments(rq);
+	imu =3D kvmalloc(struct_size(imu, bvec, nr_bvecs), GFP_KERNEL);
+	if (!imu) {
+		kfree(node);
+		return -ENOMEM;
+	}
+
+	imu->ubuf =3D 0;
+	imu->len =3D blk_rq_bytes(rq);
+	imu->acct_pages =3D 0;
+	imu->nr_bvecs =3D nr_bvecs;
+	refcount_set(&imu->refs, 1);
+	node->buf =3D imu;
+
+	rq_for_each_bvec(bv, rq, rq_iter)
+		bvec_set_page(&node->buf->bvec[i++], bv.bv_page, bv.bv_len,
+			      bv.bv_offset);
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
+	if (!data->nr)
+		return;
+	if (index >=3D data->nr)
+		return;
+
+	node =3D data->nodes[index];
+	if (!node || !node->buf)
+		return;
+	if (node->type !=3D IORING_RSRC_KBUFFER)
+		return;
+	io_reset_rsrc_node(ctx, data, index);
+}
+EXPORT_SYMBOL_GPL(io_buffer_unregister_bvec);
+
 int io_import_fixed(int ddir, struct iov_iter *iter, struct io_rsrc_node=
 *node,
 		    u64 buf_addr, size_t len)
 {
@@ -888,8 +969,8 @@ int io_import_fixed(int ddir, struct iov_iter *iter, =
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
@@ -903,8 +984,15 @@ int io_import_fixed(int ddir, struct iov_iter *iter,=
 struct io_rsrc_node *node,
 		 */
 		const struct bio_vec *bvec =3D imu->bvec;
=20
+		/*
+		 * Kernel buffer bvecs, on the other hand, don't necessarily
+		 * have the size property of user registered ones, so we have
+		 * to use the slow iter advance.
+		 */
 		if (offset < bvec->bv_len) {
 			iter->iov_offset =3D offset;
+		} else if (node->type =3D=3D IORING_RSRC_KBUFFER) {
+			iov_iter_advance(iter, offset);
 		} else {
 			unsigned long seg_skip;
=20
@@ -1004,7 +1092,7 @@ static int io_clone_buffers(struct io_ring_ctx *ctx=
, struct io_ring_ctx *src_ctx
 		if (!src_node) {
 			dst_node =3D NULL;
 		} else {
-			dst_node =3D io_rsrc_node_alloc(IORING_RSRC_BUFFER);
+			dst_node =3D io_rsrc_node_alloc(src_node->type);
 			if (!dst_node) {
 				ret =3D -ENOMEM;
 				goto out_free;
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index a3826ab84e666..8147dfc26f737 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -13,6 +13,7 @@
 enum {
 	IORING_RSRC_FILE		=3D 0,
 	IORING_RSRC_BUFFER		=3D 1,
+	IORING_RSRC_KBUFFER		=3D 2,
 };
=20
 struct io_rsrc_node {
--=20
2.43.5


