Return-Path: <io-uring+bounces-6341-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 59CEAA2FFC9
	for <lists+io-uring@lfdr.de>; Tue, 11 Feb 2025 01:57:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DD7A81644DF
	for <lists+io-uring@lfdr.de>; Tue, 11 Feb 2025 00:57:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB0ED3EA98;
	Tue, 11 Feb 2025 00:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="fqnrrutf"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4BA81420DD
	for <io-uring@vger.kernel.org>; Tue, 11 Feb 2025 00:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739235441; cv=none; b=KR4Z7xH/WWC6MG7N/BCLwmwlbMkBgMQu4Xs+Y9POodUCeubnygvSt/W2e8o/ds6m8RuqV40JxECyMKY96ejvGLgnQblT4Mnag5KLllkWQHV/e0VFaubZZLF2xiw0Vt+Y5TvsnmGpceafFto3d+aBmJJ3rgpALrW0rrTgUuWSjM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739235441; c=relaxed/simple;
	bh=R6ezdbb1SZGK6TaSG5laRh7MNR6umGNnOH1qxUnqoW8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Zy8mS0ZpYpnZM+yLCKP4nVvqtmbfVpD3gGIyDqU0y49wfN+RxSxyRhDqLkUCLobwR5T89FI71HTfvKdpzojeuRseDEcte3N4he7FDYfTQXuB2o36Wox3L+j0KyO8SKN6y28Tz3nftKkqgGBb6SsTorJdwhh3T0zuv3c37EWtgNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=fqnrrutf; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51B0oYfw027464
	for <io-uring@vger.kernel.org>; Mon, 10 Feb 2025 16:57:19 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2021-q4;
	 bh=DktvP6+nkYX2C0FR/dkgSu1ncTUJ2KmCUq8qXVB1v2o=; b=fqnrrutfegsP
	yT3m6+UKpB8qNN+ZrrhD0fC1lg1B0dQI0pPDlvr1q3St3ZeLW9ZJ+SC9dBdgFXyI
	trjaqHU18PFNrP/b7WlTAR7U08lIWZbkuf8BJd0wij8REF8FJJXF1Hqq6J3uiaet
	bA7uAI6/3LUIi9DNtKv4ZlMLzHevn4oIgU5U0j97nELKdwwiDlHFgpiqA0v1ea/C
	W91o9GXw8LDB0H9hDML+UDVU94OxwcOplI92xP1sbqPu6DaE0l49u35owRd+d++a
	JTdcuXJfk4b2P7bqgS3mKdCqZXA4FnATJ/+BQPt+sXl2Wx2nPlU0+oa9OBxcwhE4
	gI9NJKbNXw==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 44qpm92u4s-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Mon, 10 Feb 2025 16:57:19 -0800 (PST)
Received: from twshared3076.40.frc1.facebook.com (2620:10d:c0a8:1b::30) by
 mail.thefacebook.com (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.14; Tue, 11 Feb 2025 00:57:02 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id ABD4917E18F8B; Mon, 10 Feb 2025 16:56:48 -0800 (PST)
From: Keith Busch <kbusch@meta.com>
To: <ming.lei@redhat.com>, <asml.silence@gmail.com>, <axboe@kernel.dk>,
        <linux-block@vger.kernel.org>, <io-uring@vger.kernel.org>
CC: <bernd@bsbernd.com>, Keith Busch <kbusch@kernel.org>
Subject: [PATCHv2 6/6] io_uring: cache nodes and mapped buffers
Date: Mon, 10 Feb 2025 16:56:46 -0800
Message-ID: <20250211005646.222452-7-kbusch@meta.com>
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
X-Proofpoint-GUID: cQCJMG2FDzlMAbgwQ0hYVELr_u97tMz-
X-Proofpoint-ORIG-GUID: cQCJMG2FDzlMAbgwQ0hYVELr_u97tMz-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-11_01,2025-02-10_01,2024-11-22_01

From: Keith Busch <kbusch@kernel.org>

Frequent alloc/free cycles on these is pretty costly. Use an io cache to
more efficiently reuse these buffers.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 include/linux/io_uring_types.h |  18 +++---
 io_uring/filetable.c           |   2 +-
 io_uring/rsrc.c                | 115 +++++++++++++++++++++++++--------
 io_uring/rsrc.h                |   2 +-
 4 files changed, 101 insertions(+), 36 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_type=
s.h
index 4f4b7ad21500d..a6e525b756d10 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -67,8 +67,18 @@ struct io_file_table {
 	unsigned int alloc_hint;
 };
=20
+struct io_alloc_cache {
+	void			**entries;
+	unsigned int		nr_cached;
+	unsigned int		max_cached;
+	size_t			elem_size;
+	unsigned int		init_clear;
+};
+
 struct io_buf_table {
 	struct io_rsrc_data	data;
+	struct io_alloc_cache	node_cache;
+	struct io_alloc_cache	imu_cache;
 };
=20
 struct io_hash_bucket {
@@ -222,14 +232,6 @@ struct io_submit_state {
 	struct blk_plug		plug;
 };
=20
-struct io_alloc_cache {
-	void			**entries;
-	unsigned int		nr_cached;
-	unsigned int		max_cached;
-	unsigned int		elem_size;
-	unsigned int		init_clear;
-};
-
 struct io_ring_ctx {
 	/* const or read-mostly hot data */
 	struct {
diff --git a/io_uring/filetable.c b/io_uring/filetable.c
index dd8eeec97acf6..a21660e3145ab 100644
--- a/io_uring/filetable.c
+++ b/io_uring/filetable.c
@@ -68,7 +68,7 @@ static int io_install_fixed_file(struct io_ring_ctx *ct=
x, struct file *file,
 	if (slot_index >=3D ctx->file_table.data.nr)
 		return -EINVAL;
=20
-	node =3D io_rsrc_node_alloc(IORING_RSRC_FILE);
+	node =3D io_rsrc_node_alloc(ctx, IORING_RSRC_FILE);
 	if (!node)
 		return -ENOMEM;
=20
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index b3f36f1b2a668..88a67590c67d4 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -32,6 +32,8 @@ static struct io_rsrc_node *io_sqe_buffer_register(stru=
ct io_ring_ctx *ctx,
 #define IORING_MAX_FIXED_FILES	(1U << 20)
 #define IORING_MAX_REG_BUFFERS	(1U << 14)
=20
+#define IO_CACHED_BVECS_SEGS	30
+
 int __io_account_mem(struct user_struct *user, unsigned long nr_pages)
 {
 	unsigned long page_limit, cur_pages, new_pages;
@@ -119,19 +121,35 @@ static void io_buffer_unmap(struct io_ring_ctx *ctx=
, struct io_rsrc_node *node)
 	}
 }
=20
-struct io_rsrc_node *io_rsrc_node_alloc(int type)
+
+struct io_rsrc_node *io_rsrc_node_alloc(struct io_ring_ctx *ctx, int typ=
e)
 {
 	struct io_rsrc_node *node;
=20
-	node =3D kzalloc(sizeof(*node), GFP_KERNEL);
+	if (type =3D=3D IORING_RSRC_FILE)
+		node =3D kmalloc(sizeof(*node), GFP_KERNEL);
+	else
+		node =3D io_cache_alloc(&ctx->buf_table.node_cache, GFP_KERNEL);
 	if (node) {
 		node->type =3D type;
 		node->refs =3D 1;
+		node->tag =3D 0;
+		node->file_ptr =3D 0;
+		node->release =3D NULL;
+		node->priv =3D NULL;
 	}
 	return node;
 }
=20
-__cold void io_rsrc_data_free(struct io_ring_ctx *ctx, struct io_rsrc_da=
ta *data)
+static __cold void __io_rsrc_data_free(struct io_rsrc_data *data)
+{
+	kvfree(data->nodes);
+	data->nodes =3D NULL;
+	data->nr =3D 0;
+}
+
+__cold void io_rsrc_data_free(struct io_ring_ctx *ctx,
+			      struct io_rsrc_data *data)
 {
 	if (!data->nr)
 		return;
@@ -139,9 +157,7 @@ __cold void io_rsrc_data_free(struct io_ring_ctx *ctx=
, struct io_rsrc_data *data
 		if (data->nodes[data->nr])
 			io_put_rsrc_node(ctx, data->nodes[data->nr]);
 	}
-	kvfree(data->nodes);
-	data->nodes =3D NULL;
-	data->nr =3D 0;
+	__io_rsrc_data_free(data);
 }
=20
 __cold int io_rsrc_data_alloc(struct io_rsrc_data *data, unsigned nr)
@@ -155,6 +171,34 @@ __cold int io_rsrc_data_alloc(struct io_rsrc_data *d=
ata, unsigned nr)
 	return -ENOMEM;
 }
=20
+static __cold int io_rsrc_buffer_alloc(struct io_buf_table *table, unsig=
ned nr)
+{
+	const int imu_cache_size =3D struct_size_t(struct io_mapped_ubuf, bvec,
+						 IO_CACHED_BVECS_SEGS);
+	int ret;
+
+	BUILD_BUG_ON(imu_cache_size !=3D 512);
+	ret =3D io_rsrc_data_alloc(&table->data, nr);
+	if (ret)
+		return ret;
+
+	ret =3D io_alloc_cache_init(&table->node_cache, nr,
+				  sizeof(struct io_rsrc_node), 0);
+	if (ret)
+		goto out_1;
+
+	ret =3D io_alloc_cache_init(&table->imu_cache, nr, imu_cache_size, 0);
+	if (ret)
+		goto out_2;
+
+	return 0;
+out_2:
+	io_alloc_cache_free(&table->node_cache, kfree);
+out_1:
+	__io_rsrc_data_free(&table->data);
+	return ret;
+}
+
 static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 				 struct io_uring_rsrc_update2 *up,
 				 unsigned nr_args)
@@ -204,7 +248,7 @@ static int __io_sqe_files_update(struct io_ring_ctx *=
ctx,
 				err =3D -EBADF;
 				break;
 			}
-			node =3D io_rsrc_node_alloc(IORING_RSRC_FILE);
+			node =3D io_rsrc_node_alloc(ctx, IORING_RSRC_FILE);
 			if (!node) {
 				err =3D -ENOMEM;
 				fput(file);
@@ -465,6 +509,8 @@ void io_free_rsrc_node(struct io_ring_ctx *ctx, struc=
t io_rsrc_node *node)
 			io_buffer_unmap(ctx, node);
 		if (node->release)
 			node->release(node->priv);
+		if (io_alloc_cache_put(&ctx->buf_table.node_cache, node))
+			return;
 		break;
 	default:
 		WARN_ON_ONCE(1);
@@ -533,7 +579,7 @@ int io_sqe_files_register(struct io_ring_ctx *ctx, vo=
id __user *arg,
 			goto fail;
 		}
 		ret =3D -ENOMEM;
-		node =3D io_rsrc_node_alloc(IORING_RSRC_FILE);
+		node =3D io_rsrc_node_alloc(ctx, IORING_RSRC_FILE);
 		if (!node) {
 			fput(file);
 			goto fail;
@@ -553,11 +599,19 @@ int io_sqe_files_register(struct io_ring_ctx *ctx, =
void __user *arg,
 	return ret;
 }
=20
+static void io_rsrc_buffer_free(struct io_ring_ctx *ctx,
+				struct io_buf_table *table)
+{
+	io_rsrc_data_free(ctx, &table->data);
+	io_alloc_cache_free(&table->node_cache, kfree);
+	io_alloc_cache_free(&table->imu_cache, kfree);
+}
+
 int io_sqe_buffers_unregister(struct io_ring_ctx *ctx)
 {
 	if (!ctx->buf_table.data.nr)
 		return -ENXIO;
-	io_rsrc_data_free(ctx, &ctx->buf_table.data);
+	io_rsrc_buffer_free(ctx, &ctx->buf_table);
 	return 0;
 }
=20
@@ -722,6 +776,15 @@ bool io_check_coalesce_buffer(struct page **page_arr=
ay, int nr_pages,
 	return true;
 }
=20
+static struct io_mapped_ubuf *io_alloc_imu(struct io_ring_ctx *ctx,
+					   int nr_bvecs)
+{
+	if (nr_bvecs <=3D IO_CACHED_BVECS_SEGS)
+		return io_cache_alloc(&ctx->buf_table.imu_cache, GFP_KERNEL);
+	return kvmalloc(struct_size_t(struct io_mapped_ubuf, bvec, nr_bvecs),
+			GFP_KERNEL);
+}
+
 static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *c=
tx,
 						   struct iovec *iov,
 						   struct page **last_hpage)
@@ -738,7 +801,7 @@ static struct io_rsrc_node *io_sqe_buffer_register(st=
ruct io_ring_ctx *ctx,
 	if (!iov->iov_base)
 		return NULL;
=20
-	node =3D io_rsrc_node_alloc(IORING_RSRC_BUFFER);
+	node =3D io_rsrc_node_alloc(ctx, IORING_RSRC_BUFFER);
 	if (!node)
 		return ERR_PTR(-ENOMEM);
 	node->buf =3D NULL;
@@ -758,7 +821,7 @@ static struct io_rsrc_node *io_sqe_buffer_register(st=
ruct io_ring_ctx *ctx,
 			coalesced =3D io_coalesce_buffer(&pages, &nr_pages, &data);
 	}
=20
-	imu =3D kvmalloc(struct_size(imu, bvec, nr_pages), GFP_KERNEL);
+	imu =3D io_alloc_imu(ctx, nr_pages);
 	if (!imu)
 		goto done;
=20
@@ -804,9 +867,9 @@ int io_sqe_buffers_register(struct io_ring_ctx *ctx, =
void __user *arg,
 			    unsigned int nr_args, u64 __user *tags)
 {
 	struct page *last_hpage =3D NULL;
-	struct io_rsrc_data data;
 	struct iovec fast_iov, *iov =3D &fast_iov;
 	const struct iovec __user *uvec;
+	struct io_buf_table table;
 	int i, ret;
=20
 	BUILD_BUG_ON(IORING_MAX_REG_BUFFERS >=3D (1u << 16));
@@ -815,13 +878,14 @@ int io_sqe_buffers_register(struct io_ring_ctx *ctx=
, void __user *arg,
 		return -EBUSY;
 	if (!nr_args || nr_args > IORING_MAX_REG_BUFFERS)
 		return -EINVAL;
-	ret =3D io_rsrc_data_alloc(&data, nr_args);
+	ret =3D io_rsrc_buffer_alloc(&table, nr_args);
 	if (ret)
 		return ret;
=20
 	if (!arg)
 		memset(iov, 0, sizeof(*iov));
=20
+	ctx->buf_table =3D table;
 	for (i =3D 0; i < nr_args; i++) {
 		struct io_rsrc_node *node;
 		u64 tag =3D 0;
@@ -861,10 +925,8 @@ int io_sqe_buffers_register(struct io_ring_ctx *ctx,=
 void __user *arg,
 			}
 			node->tag =3D tag;
 		}
-		data.nodes[i] =3D node;
+		table.data.nodes[i] =3D node;
 	}
-
-	ctx->buf_table.data =3D data;
 	if (ret)
 		io_sqe_buffers_unregister(ctx);
 	return ret;
@@ -892,7 +954,7 @@ int io_buffer_register_bvec(struct io_ring_ctx *ctx, =
struct request *rq,
 	if (node)
 		return -EBUSY;
=20
-	node =3D io_rsrc_node_alloc(IORING_RSRC_KBUFFER);
+	node =3D io_rsrc_node_alloc(ctx, IORING_RSRC_KBUFFER);
 	if (!node)
 		return -ENOMEM;
=20
@@ -900,7 +962,8 @@ int io_buffer_register_bvec(struct io_ring_ctx *ctx, =
struct request *rq,
 	node->priv =3D rq;
=20
 	nr_bvecs =3D blk_rq_nr_phys_segments(rq);
-	imu =3D kvmalloc(struct_size(imu, bvec, nr_bvecs), GFP_KERNEL);
+
+	imu =3D io_alloc_imu(ctx, nr_bvecs);
 	if (!imu) {
 		kfree(node);
 		return -ENOMEM;
@@ -1022,7 +1085,7 @@ static void lock_two_rings(struct io_ring_ctx *ctx1=
, struct io_ring_ctx *ctx2)
 static int io_clone_buffers(struct io_ring_ctx *ctx, struct io_ring_ctx =
*src_ctx,
 			    struct io_uring_clone_buffers *arg)
 {
-	struct io_rsrc_data data;
+	struct io_buf_table table;
 	int i, ret, off, nr;
 	unsigned int nbufs;
=20
@@ -1053,7 +1116,7 @@ static int io_clone_buffers(struct io_ring_ctx *ctx=
, struct io_ring_ctx *src_ctx
 	if (check_add_overflow(arg->nr, arg->dst_off, &nbufs))
 		return -EOVERFLOW;
=20
-	ret =3D io_rsrc_data_alloc(&data, max(nbufs, ctx->buf_table.data.nr));
+	ret =3D io_rsrc_buffer_alloc(&table, max(nbufs, ctx->buf_table.data.nr)=
);
 	if (ret)
 		return ret;
=20
@@ -1062,7 +1125,7 @@ static int io_clone_buffers(struct io_ring_ctx *ctx=
, struct io_ring_ctx *src_ctx
 		struct io_rsrc_node *src_node =3D ctx->buf_table.data.nodes[i];
=20
 		if (src_node) {
-			data.nodes[i] =3D src_node;
+			table.data.nodes[i] =3D src_node;
 			src_node->refs++;
 		}
 	}
@@ -1092,7 +1155,7 @@ static int io_clone_buffers(struct io_ring_ctx *ctx=
, struct io_ring_ctx *src_ctx
 		if (!src_node) {
 			dst_node =3D NULL;
 		} else {
-			dst_node =3D io_rsrc_node_alloc(src_node->type);
+			dst_node =3D io_rsrc_node_alloc(ctx, src_node->type);
 			if (!dst_node) {
 				ret =3D -ENOMEM;
 				goto out_free;
@@ -1101,12 +1164,12 @@ static int io_clone_buffers(struct io_ring_ctx *c=
tx, struct io_ring_ctx *src_ctx
 			refcount_inc(&src_node->buf->refs);
 			dst_node->buf =3D src_node->buf;
 		}
-		data.nodes[off++] =3D dst_node;
+		table.data.nodes[off++] =3D dst_node;
 		i++;
 	}
=20
 	/*
-	 * If asked for replace, put the old table. data->nodes[] holds both
+	 * If asked for replace, put the old table. table.data->nodes[] holds b=
oth
 	 * old and new nodes at this point.
 	 */
 	if (arg->flags & IORING_REGISTER_DST_REPLACE)
@@ -1119,10 +1182,10 @@ static int io_clone_buffers(struct io_ring_ctx *c=
tx, struct io_ring_ctx *src_ctx
 	 * entry).
 	 */
 	WARN_ON_ONCE(ctx->buf_table.data.nr);
-	ctx->buf_table.data =3D data;
+	ctx->buf_table =3D table;
 	return 0;
 out_free:
-	io_rsrc_data_free(ctx, &data);
+	io_rsrc_buffer_free(ctx, &table);
 	return ret;
 }
=20
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index 8147dfc26f737..751db2ce9affb 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -49,7 +49,7 @@ struct io_imu_folio_data {
 	unsigned int	nr_folios;
 };
=20
-struct io_rsrc_node *io_rsrc_node_alloc(int type);
+struct io_rsrc_node *io_rsrc_node_alloc(struct io_ring_ctx *ctx, int typ=
e);
 void io_free_rsrc_node(struct io_ring_ctx *ctx, struct io_rsrc_node *nod=
e);
 void io_rsrc_data_free(struct io_ring_ctx *ctx, struct io_rsrc_data *dat=
a);
 int io_rsrc_data_alloc(struct io_rsrc_data *data, unsigned nr);
--=20
2.43.5


