Return-Path: <io-uring+bounces-6220-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B32BA25F21
	for <lists+io-uring@lfdr.de>; Mon,  3 Feb 2025 16:46:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CC4B63A1DFD
	for <lists+io-uring@lfdr.de>; Mon,  3 Feb 2025 15:45:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D63D620ADCB;
	Mon,  3 Feb 2025 15:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="HQvVRfGT"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D443E20A5F3
	for <io-uring@vger.kernel.org>; Mon,  3 Feb 2025 15:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738597539; cv=none; b=rLPddh0upkbq7P0KRqFX+wFQL/AICc4LvclOxU8ZZkizqhOZZa5PCnviSdeMHhoC5YOFomNHmiNAn74I/Ln4bd1QIuVtbQTJFFc+M4ubZUHGW+GQVj4cz1kj7sQm1V5t4oANmvajlKpsxVkGY9ZkEsxqozuTDA5nPoFcAsH/fC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738597539; c=relaxed/simple;
	bh=mn+CY3dTAGazV9JQYW/9hNHqGStvNKf5F/Qe3qx9n28=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rZowqGrqlPXMjSuMCe6Pesz64ruIjkWLIygNK5TD4TB+5yeAQ39BbAFtwVceJ3unAFJ6Sz/UUmjfl8VEW3Kzw19Niz4J0BIZ3DX4gxTtgc6y9RZM2YlWTsL26pl0ta7uDeoxYshtGzzm3I7Yb2qcLJLgFf/pfGZoQM+Nku6C5PI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=HQvVRfGT; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 513FjCw1004352
	for <io-uring@vger.kernel.org>; Mon, 3 Feb 2025 07:45:36 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2021-q4;
	 bh=xT9bYyhPiIjW1fRj+7v8fy9G12JyuUUWgtfu26pK2PA=; b=HQvVRfGTbkBH
	9CXBd9XHZzNCH8/YauHuv2aeFRjhKRy62AVoaAgWeYVzgSdkuD2uMtZOTAVtbToU
	Ku2Lo0cwnrKjp0VxfC6PNZ/swiKvTBlSVyek4fLVevDvH5mJvnupY7ZQQTTBq0IX
	7MvoDl/YfWxdkNBY6kQL/ExBVpThBDDjzNm5dlqrAXTkDA/Qo+hUVHNo/9qWXXDB
	b0PftaG9/6Mp8UIYV1YYhkjGgIZU3W3gvz0gDKV1ELSqzmCwpw05Ov+SCnNHYFQx
	WzDNPdWwAws74/uODMgbMkYwLQDWBetjjo5vYhR4r4+L5OtxFdDLOHxgYv/bGqau
	UfFcnRdntQ==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 44k0q6r041-14
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Mon, 03 Feb 2025 07:45:36 -0800 (PST)
Received: from twshared55211.03.ash8.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c08b:78::c78f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.14; Mon, 3 Feb 2025 15:45:27 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id 3D158179A9858; Mon,  3 Feb 2025 07:45:22 -0800 (PST)
From: Keith Busch <kbusch@meta.com>
To: <io-uring@vger.kernel.org>, <linux-block@vger.kernel.org>,
        <ming.lei@redhat.com>, <axboe@kernel.dk>, <asml.silence@gmail.com>
CC: Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6/6] io_uring: cache nodes and mapped buffers
Date: Mon, 3 Feb 2025 07:45:17 -0800
Message-ID: <20250203154517.937623-7-kbusch@meta.com>
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
X-Proofpoint-ORIG-GUID: OlCVR0bNA2oT0WFGEOktbkZjfAVxcdKm
X-Proofpoint-GUID: OlCVR0bNA2oT0WFGEOktbkZjfAVxcdKm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-03_06,2025-01-31_02,2024-11-22_01

From: Keith Busch <kbusch@kernel.org>

Frequent alloc/free cycles on these is pretty costly. Use an io cache to
more efficiently reuse these buffers.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 include/linux/io_uring_types.h |  16 ++---
 io_uring/filetable.c           |   2 +-
 io_uring/rsrc.c                | 108 ++++++++++++++++++++++++---------
 io_uring/rsrc.h                |   2 +-
 4 files changed, 92 insertions(+), 36 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_type=
s.h
index aa661ebfd6568..c0e0c1f92e5b1 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -67,8 +67,17 @@ struct io_file_table {
 	unsigned int alloc_hint;
 };
=20
+struct io_alloc_cache {
+	void			**entries;
+	unsigned int		nr_cached;
+	unsigned int		max_cached;
+	size_t			elem_size;
+};
+
 struct io_buf_table {
 	struct io_rsrc_data	data;
+	struct io_alloc_cache	node_cache;
+	struct io_alloc_cache	imu_cache;
 };
=20
 struct io_hash_bucket {
@@ -222,13 +231,6 @@ struct io_submit_state {
 	struct blk_plug		plug;
 };
=20
-struct io_alloc_cache {
-	void			**entries;
-	unsigned int		nr_cached;
-	unsigned int		max_cached;
-	size_t			elem_size;
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
index 864c2eabf8efd..5434b0d992d62 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -117,23 +117,39 @@ static void io_buffer_unmap(struct io_ring_ctx *ctx=
, struct io_rsrc_node *node)
 				unpin_user_page(imu->bvec[i].bv_page);
 		if (imu->acct_pages)
 			io_unaccount_mem(ctx, imu->acct_pages);
-		kvfree(imu);
+		if (struct_size(imu, bvec, imu->nr_bvecs) >
+				ctx->buf_table.imu_cache.elem_size ||
+		    !io_alloc_cache_put(&ctx->buf_table.imu_cache, imu))
+			kvfree(imu);
 	}
 }
=20
-struct io_rsrc_node *io_rsrc_node_alloc(int type)
+struct io_rsrc_node *io_rsrc_node_alloc(struct io_ring_ctx *ctx, int typ=
e)
 {
 	struct io_rsrc_node *node;
=20
-	node =3D kzalloc(sizeof(*node), GFP_KERNEL);
+	if (type =3D=3D IORING_RSRC_FILE)
+		node =3D kmalloc(sizeof(*node), GFP_KERNEL);
+	else
+		node =3D io_cache_alloc(&ctx->buf_table.node_cache, GFP_KERNEL, NULL);
 	if (node) {
 		node->type =3D type;
 		node->refs =3D 1;
+		node->tag =3D 0;
+		node->file_ptr =3D 0;
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
@@ -141,9 +157,7 @@ __cold void io_rsrc_data_free(struct io_ring_ctx *ctx=
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
@@ -157,6 +171,31 @@ __cold int io_rsrc_data_alloc(struct io_rsrc_data *d=
ata, unsigned nr)
 	return -ENOMEM;
 }
=20
+static __cold int io_rsrc_buffer_alloc(struct io_buf_table *table, unsig=
ned nr)
+{
+	int ret;
+
+	ret =3D io_rsrc_data_alloc(&table->data, nr);
+	if (ret)
+		return ret;
+
+	ret =3D io_alloc_cache_init(&table->node_cache, nr,
+				  sizeof(struct io_rsrc_node));
+	if (ret)
+		goto out_1;
+
+	ret =3D io_alloc_cache_init(&table->imu_cache, nr, 512);
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
@@ -206,7 +245,7 @@ static int __io_sqe_files_update(struct io_ring_ctx *=
ctx,
 				err =3D -EBADF;
 				break;
 			}
-			node =3D io_rsrc_node_alloc(IORING_RSRC_FILE);
+			node =3D io_rsrc_node_alloc(ctx, IORING_RSRC_FILE);
 			if (!node) {
 				err =3D -ENOMEM;
 				fput(file);
@@ -466,6 +505,8 @@ void io_free_rsrc_node(struct io_ring_ctx *ctx, struc=
t io_rsrc_node *node)
 	case IORING_RSRC_KBUF:
 		if (node->buf)
 			io_buffer_unmap(ctx, node);
+		if (io_alloc_cache_put(&ctx->buf_table.node_cache, node))
+			return;
 		break;
 	default:
 		WARN_ON_ONCE(1);
@@ -534,7 +575,7 @@ int io_sqe_files_register(struct io_ring_ctx *ctx, vo=
id __user *arg,
 			goto fail;
 		}
 		ret =3D -ENOMEM;
-		node =3D io_rsrc_node_alloc(IORING_RSRC_FILE);
+		node =3D io_rsrc_node_alloc(ctx, IORING_RSRC_FILE);
 		if (!node) {
 			fput(file);
 			goto fail;
@@ -554,11 +595,19 @@ int io_sqe_files_register(struct io_ring_ctx *ctx, =
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
@@ -739,7 +788,7 @@ static struct io_rsrc_node *io_sqe_buffer_register(st=
ruct io_ring_ctx *ctx,
 	if (!iov->iov_base)
 		return NULL;
=20
-	node =3D io_rsrc_node_alloc(IORING_RSRC_BUFFER);
+	node =3D io_rsrc_node_alloc(ctx, IORING_RSRC_BUFFER);
 	if (!node)
 		return ERR_PTR(-ENOMEM);
 	node->buf =3D NULL;
@@ -759,7 +808,10 @@ static struct io_rsrc_node *io_sqe_buffer_register(s=
truct io_ring_ctx *ctx,
 			coalesced =3D io_coalesce_buffer(&pages, &nr_pages, &data);
 	}
=20
-	imu =3D kvmalloc(struct_size(imu, bvec, nr_pages), GFP_KERNEL);
+	if (struct_size(imu, bvec, nr_pages) > ctx->buf_table.imu_cache.elem_si=
ze)
+		imu =3D kvmalloc(struct_size(imu, bvec, nr_pages), GFP_KERNEL);
+	else
+		imu =3D io_cache_alloc(&ctx->buf_table.imu_cache, GFP_KERNEL, NULL);
 	if (!imu)
 		goto done;
=20
@@ -805,9 +857,9 @@ int io_sqe_buffers_register(struct io_ring_ctx *ctx, =
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
@@ -816,13 +868,14 @@ int io_sqe_buffers_register(struct io_ring_ctx *ctx=
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
@@ -862,10 +915,8 @@ int io_sqe_buffers_register(struct io_ring_ctx *ctx,=
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
@@ -878,11 +929,14 @@ static struct io_rsrc_node *io_buffer_alloc_node(st=
ruct io_ring_ctx *ctx,
 	struct io_mapped_ubuf *imu;
 	struct io_rsrc_node *node;
=20
-	node =3D io_rsrc_node_alloc(IORING_RSRC_KBUF);
+	node =3D io_rsrc_node_alloc(ctx, IORING_RSRC_KBUF);
 	if (!node)
 		return NULL;
=20
-	imu =3D kvmalloc(struct_size(imu, bvec, nr_bvecs), GFP_KERNEL);
+	if (struct_size(imu, bvec, nr_bvecs) > ctx->buf_table.imu_cache.elem_si=
ze)
+		imu =3D kvmalloc(struct_size(imu, bvec, nr_bvecs), GFP_KERNEL);
+	else
+		imu =3D io_cache_alloc(&ctx->buf_table.imu_cache, GFP_KERNEL, NULL);
 	if (!imu) {
 		io_put_rsrc_node(ctx, node);
 		return NULL;
@@ -1036,7 +1090,7 @@ static void lock_two_rings(struct io_ring_ctx *ctx1=
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
@@ -1067,7 +1121,7 @@ static int io_clone_buffers(struct io_ring_ctx *ctx=
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
@@ -1076,7 +1130,7 @@ static int io_clone_buffers(struct io_ring_ctx *ctx=
, struct io_ring_ctx *src_ctx
 		struct io_rsrc_node *src_node =3D ctx->buf_table.data.nodes[i];
=20
 		if (src_node) {
-			data.nodes[i] =3D src_node;
+			table.data.nodes[i] =3D src_node;
 			src_node->refs++;
 		}
 	}
@@ -1106,7 +1160,7 @@ static int io_clone_buffers(struct io_ring_ctx *ctx=
, struct io_ring_ctx *src_ctx
 		if (!src_node) {
 			dst_node =3D NULL;
 		} else {
-			dst_node =3D io_rsrc_node_alloc(IORING_RSRC_BUFFER);
+			dst_node =3D io_rsrc_node_alloc(ctx, IORING_RSRC_BUFFER);
 			if (!dst_node) {
 				ret =3D -ENOMEM;
 				goto out_free;
@@ -1115,12 +1169,12 @@ static int io_clone_buffers(struct io_ring_ctx *c=
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
@@ -1133,10 +1187,10 @@ static int io_clone_buffers(struct io_ring_ctx *c=
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
index d1d90d9cd2b43..759ac373b0dc6 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -46,7 +46,7 @@ struct io_imu_folio_data {
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


