Return-Path: <io-uring+bounces-6799-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 06100A4691F
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2025 19:12:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 322597A92A4
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2025 18:10:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1F4A2356A4;
	Wed, 26 Feb 2025 18:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="Dd3NM7ZA"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96ED422F163
	for <io-uring@vger.kernel.org>; Wed, 26 Feb 2025 18:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740593421; cv=none; b=ARYKKR6/3C65mgJkVZeSRPsCcsKCGGUcNX4eJB9z0AIHzSTUCoGUUdsXeJriWjIvh1NWWktfZw+W4iRNk3Fg2ZBd72IHbswSru/jVx8OaVyX4Jb4lFDMk6imSocHNsMXcFWOnp5bZEyFKUuXyzrTbjJ6+6Q5PVuugkVcKppDvuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740593421; c=relaxed/simple;
	bh=Dt4ivYC3SR2/vPzCzMkzFgxjvTtJGc+6CyD7PH7YyEk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a9jK4GulX6QjG0ZVjYkl59eC2MH7RyXH0IHAiH7P9q1CRWQwM3qHUzstFMqYLuPaJNG4E8Tjvq7Ac00uLdah9eXdGy3zTGB6X38yBb3ojw5tJurCxdZXWHZ7fkFsOcukVZ6Ax/90om755uFv3QuHQWNNQGZXF/Rx7GWVtxU1wxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=Dd3NM7ZA; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51QF0jRE019840
	for <io-uring@vger.kernel.org>; Wed, 26 Feb 2025 10:10:18 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2021-q4;
	 bh=hbunRQgRX+ReeqwUe8G8nMtr7PKoD5fxxeT5ERKFNGQ=; b=Dd3NM7ZA7oRh
	eFW5/kUo6oevtHZOEOHzkFIqG1Dhc+a+cIfqy60De1qw5+qT6ywMifET66lRBq1m
	53OMRduI2EQtCX84nM+hHRmZAW2uKyXO0i4B/srZS58vqFBWlpkkJoOgm/FSOr1E
	AsjpK6m9cngh1DKuX6jhCx5dwcE/xIj0WboI47tNS87DRRjY25DfZCYqs1oDtIwu
	vng5i0doRB8JF7PdTSW6bZ3Un7dMSHcZoHJfaCx99KAnCVuZehAFTMeR2WSH5U/q
	+0kJ2oUUpqUFbw5qUfEQSUuLaXY70FGCKRUsUk+zbMqgg8p7ym0jgW6zSREtvhCv
	rQ49pRIBpQ==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 45257j1ewn-13
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Wed, 26 Feb 2025 10:10:17 -0800 (PST)
Received: from twshared55211.03.ash8.facebook.com (2620:10d:c0a8:1c::1b) by
 mail.thefacebook.com (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.14; Wed, 26 Feb 2025 18:10:02 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id 2468D187C4AEA; Wed, 26 Feb 2025 10:10:07 -0800 (PST)
From: Keith Busch <kbusch@meta.com>
To: <ming.lei@redhat.com>, <asml.silence@gmail.com>, <axboe@kernel.dk>,
        <linux-block@vger.kernel.org>, <io-uring@vger.kernel.org>
CC: <bernd@bsbernd.com>, <csander@purestorage.com>,
        <linux-nvme@lists.infradead.org>, Keith Busch <kbusch@kernel.org>
Subject: [PATCHv6 6/6] io_uring: cache nodes and mapped buffers
Date: Wed, 26 Feb 2025 10:10:02 -0800
Message-ID: <20250226181002.2574148-12-kbusch@meta.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250226181002.2574148-1-kbusch@meta.com>
References: <20250226181002.2574148-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: EwNax3Kvc2m2CXYaZAOy89_uZKgnBkKK
X-Proofpoint-GUID: EwNax3Kvc2m2CXYaZAOy89_uZKgnBkKK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-26_04,2025-02-26_01,2024-11-22_01

From: Keith Busch <kbusch@kernel.org>

Frequent alloc/free cycles on these is pretty costly. Use an io cache to
more efficiently reuse these buffers.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 include/linux/io_uring_types.h |  18 ++---
 io_uring/filetable.c           |   2 +-
 io_uring/rsrc.c                | 123 +++++++++++++++++++++++++--------
 io_uring/rsrc.h                |   2 +-
 4 files changed, 107 insertions(+), 38 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_type=
s.h
index a05ae4cb98a4c..fda3221de2174 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -69,8 +69,18 @@ struct io_file_table {
 	unsigned int alloc_hint;
 };
=20
+struct io_alloc_cache {
+	void			**entries;
+	unsigned int		nr_cached;
+	unsigned int		max_cached;
+	unsigned int		elem_size;
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
@@ -224,14 +234,6 @@ struct io_submit_state {
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
index c30a5cda08f3e..8823f15d8fe2e 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -33,6 +33,9 @@ static struct io_rsrc_node *io_sqe_buffer_register(stru=
ct io_ring_ctx *ctx,
 #define IORING_MAX_FIXED_FILES	(1U << 20)
 #define IORING_MAX_REG_BUFFERS	(1U << 14)
=20
+#define IO_CACHED_BVECS_SEGS	32
+#define IO_CACHED_ELEMS		64
+
 int __io_account_mem(struct user_struct *user, unsigned long nr_pages)
 {
 	unsigned long page_limit, cur_pages, new_pages;
@@ -102,6 +105,22 @@ int io_buffer_validate(struct iovec *iov)
 	return 0;
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
+static void io_free_imu(struct io_ring_ctx *ctx, struct io_mapped_ubuf *=
imu)
+{
+	if (imu->nr_bvecs > IO_CACHED_BVECS_SEGS ||
+	    !io_alloc_cache_put(&ctx->buf_table.imu_cache, imu))
+		kvfree(imu);
+}
+
 static void io_buffer_unmap(struct io_ring_ctx *ctx, struct io_rsrc_node=
 *node)
 {
 	struct io_mapped_ubuf *imu =3D node->buf;
@@ -120,22 +139,35 @@ static void io_buffer_unmap(struct io_ring_ctx *ctx=
, struct io_rsrc_node *node)
 			io_unaccount_mem(ctx, imu->acct_pages);
 	}
=20
-	kvfree(imu);
+	io_free_imu(ctx, imu);
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
+		node =3D io_cache_alloc(&ctx->buf_table.node_cache, GFP_KERNEL);
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
@@ -143,9 +175,7 @@ __cold void io_rsrc_data_free(struct io_ring_ctx *ctx=
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
@@ -159,6 +189,33 @@ __cold int io_rsrc_data_alloc(struct io_rsrc_data *d=
ata, unsigned nr)
 	return -ENOMEM;
 }
=20
+static __cold int io_rsrc_buffer_alloc(struct io_buf_table *table, unsig=
ned nr)
+{
+	const int imu_cache_size =3D struct_size_t(struct io_mapped_ubuf, bvec,
+						 IO_CACHED_BVECS_SEGS);
+	const int node_size =3D sizeof(struct io_rsrc_node);
+	int ret;
+
+	ret =3D io_rsrc_data_alloc(&table->data, nr);
+	if (ret)
+		return ret;
+
+	if (io_alloc_cache_init(&table->node_cache, IO_CACHED_ELEMS,
+				node_size, 0))
+		goto free_data;
+
+	if (io_alloc_cache_init(&table->imu_cache, IO_CACHED_ELEMS,
+				imu_cache_size, 0))
+		goto free_cache;
+
+	return 0;
+free_cache:
+	io_alloc_cache_free(&table->node_cache, kfree);
+free_data:
+	__io_rsrc_data_free(&table->data);
+	return -ENOMEM;
+}
+
 static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 				 struct io_uring_rsrc_update2 *up,
 				 unsigned nr_args)
@@ -208,7 +265,7 @@ static int __io_sqe_files_update(struct io_ring_ctx *=
ctx,
 				err =3D -EBADF;
 				break;
 			}
-			node =3D io_rsrc_node_alloc(IORING_RSRC_FILE);
+			node =3D io_rsrc_node_alloc(ctx, IORING_RSRC_FILE);
 			if (!node) {
 				err =3D -ENOMEM;
 				fput(file);
@@ -460,6 +517,8 @@ void io_free_rsrc_node(struct io_ring_ctx *ctx, struc=
t io_rsrc_node *node)
 	case IORING_RSRC_BUFFER:
 		if (node->buf)
 			io_buffer_unmap(ctx, node);
+		if (io_alloc_cache_put(&ctx->buf_table.node_cache, node))
+			return;
 		break;
 	default:
 		WARN_ON_ONCE(1);
@@ -528,7 +587,7 @@ int io_sqe_files_register(struct io_ring_ctx *ctx, vo=
id __user *arg,
 			goto fail;
 		}
 		ret =3D -ENOMEM;
-		node =3D io_rsrc_node_alloc(IORING_RSRC_FILE);
+		node =3D io_rsrc_node_alloc(ctx, IORING_RSRC_FILE);
 		if (!node) {
 			fput(file);
 			goto fail;
@@ -548,11 +607,19 @@ int io_sqe_files_register(struct io_ring_ctx *ctx, =
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
@@ -733,7 +800,7 @@ static struct io_rsrc_node *io_sqe_buffer_register(st=
ruct io_ring_ctx *ctx,
 	if (!iov->iov_base)
 		return NULL;
=20
-	node =3D io_rsrc_node_alloc(IORING_RSRC_BUFFER);
+	node =3D io_rsrc_node_alloc(ctx, IORING_RSRC_BUFFER);
 	if (!node)
 		return ERR_PTR(-ENOMEM);
 	node->buf =3D NULL;
@@ -753,7 +820,7 @@ static struct io_rsrc_node *io_sqe_buffer_register(st=
ruct io_ring_ctx *ctx,
 			coalesced =3D io_coalesce_buffer(&pages, &nr_pages, &data);
 	}
=20
-	imu =3D kvmalloc(struct_size(imu, bvec, nr_pages), GFP_KERNEL);
+	imu =3D io_alloc_imu(ctx, nr_pages);
 	if (!imu)
 		goto done;
=20
@@ -789,7 +856,7 @@ static struct io_rsrc_node *io_sqe_buffer_register(st=
ruct io_ring_ctx *ctx,
 	}
 done:
 	if (ret) {
-		kvfree(imu);
+		io_free_imu(ctx, imu);
 		if (node)
 			io_put_rsrc_node(ctx, node);
 		node =3D ERR_PTR(ret);
@@ -802,9 +869,9 @@ int io_sqe_buffers_register(struct io_ring_ctx *ctx, =
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
@@ -813,13 +880,14 @@ int io_sqe_buffers_register(struct io_ring_ctx *ctx=
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
@@ -859,10 +927,8 @@ int io_sqe_buffers_register(struct io_ring_ctx *ctx,=
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
@@ -893,14 +959,15 @@ int io_buffer_register_bvec(struct io_uring_cmd *cm=
d, struct request *rq,
 		goto unlock;
 	}
=20
-	node =3D io_rsrc_node_alloc(IORING_RSRC_BUFFER);
+	node =3D io_rsrc_node_alloc(ctx, IORING_RSRC_BUFFER);
 	if (!node) {
 		ret =3D -ENOMEM;
 		goto unlock;
 	}
=20
 	nr_bvecs =3D blk_rq_nr_phys_segments(rq);
-	imu =3D kvmalloc(struct_size(imu, bvec, nr_bvecs), GFP_KERNEL);
+
+	imu =3D io_alloc_imu(ctx, nr_bvecs);
 	if (!imu) {
 		kfree(node);
 		ret =3D -ENOMEM;
@@ -1066,7 +1133,7 @@ static void lock_two_rings(struct io_ring_ctx *ctx1=
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
@@ -1097,7 +1164,7 @@ static int io_clone_buffers(struct io_ring_ctx *ctx=
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
@@ -1106,7 +1173,7 @@ static int io_clone_buffers(struct io_ring_ctx *ctx=
, struct io_ring_ctx *src_ctx
 		struct io_rsrc_node *src_node =3D ctx->buf_table.data.nodes[i];
=20
 		if (src_node) {
-			data.nodes[i] =3D src_node;
+			table.data.nodes[i] =3D src_node;
 			src_node->refs++;
 		}
 	}
@@ -1136,7 +1203,7 @@ static int io_clone_buffers(struct io_ring_ctx *ctx=
, struct io_ring_ctx *src_ctx
 		if (!src_node) {
 			dst_node =3D NULL;
 		} else {
-			dst_node =3D io_rsrc_node_alloc(IORING_RSRC_BUFFER);
+			dst_node =3D io_rsrc_node_alloc(ctx, IORING_RSRC_BUFFER);
 			if (!dst_node) {
 				ret =3D -ENOMEM;
 				goto out_free;
@@ -1145,12 +1212,12 @@ static int io_clone_buffers(struct io_ring_ctx *c=
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
@@ -1163,10 +1230,10 @@ static int io_clone_buffers(struct io_ring_ctx *c=
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
index 9668804afddc4..4b39d8104df19 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -47,7 +47,7 @@ struct io_imu_folio_data {
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


