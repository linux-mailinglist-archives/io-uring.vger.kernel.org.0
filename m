Return-Path: <io-uring+bounces-6845-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E3B5EA48BC4
	for <lists+io-uring@lfdr.de>; Thu, 27 Feb 2025 23:41:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C41DB3B761B
	for <lists+io-uring@lfdr.de>; Thu, 27 Feb 2025 22:40:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DB0023E349;
	Thu, 27 Feb 2025 22:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="NOGrHNhK"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ED8F274259
	for <io-uring@vger.kernel.org>; Thu, 27 Feb 2025 22:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740695978; cv=none; b=Q1Cn0PSWKbHjcX3CBx6nus0oo7PQjjzZtD5A1GWKPaszTaruUUUMF6a3RrpA+kl0E4/21FSYKAsTNeWWIppppwbOvp/NAop0mufx3LAsRUkCfVklt6RBHqnyZJ6S47dSDAxdOMjfkKbs7a5LMlktLse5XiXbKEI9oqOYcE/lFOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740695978; c=relaxed/simple;
	bh=CTqOkhMmDRNpT9rLqdAGDeq34k3ZtCMxmHRaMLiexZA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DuM/8aNEjRBdFwFI5A2r9TRs6V0bNMLkQSrHM1AsbrTeJejxWwS7RKY6tJ8r18b1EXDE3OwarwI284CsDbwpUD9GxkflcFFOizJS2bETbgq7UUQbbZPo6Y4OgeKO3jgH12WHL789M0V5EAFDB15cZ/XZvYucAsGsC/gOfoewGVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=NOGrHNhK; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
	by m0001303.ppops.net (8.18.1.2/8.18.1.2) with ESMTP id 51RMbZ5C025607
	for <io-uring@vger.kernel.org>; Thu, 27 Feb 2025 14:39:35 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2021-q4;
	 bh=UK4VKrnbbqRbsvlFbP+kOC2S+sGsNhIP2BWp/9Ksa3U=; b=NOGrHNhKfI1T
	By7qcndvAVJqWeQXauCmBIF6mP6FRyBDf69DzRKde/y8lTgD6BXDa8+NYkb+tdHo
	IdfYDKYHAbUBlnOGoWimnMlz2LcSRlO+4c+WTQZFvnjAuETBAhiAmXZhppEKY7aN
	c92Jwi9UkpLdKTM3jxUcvmB9CpRAxL8z9GlGU/KoUUIHy5xQHZx17dp4nieYQ30c
	JLBphyyhxkBlM6MGE6U08Kk6haVhhqXRjkpL0XTTcvQMiZ3U+klTeynvPP73g+Pp
	bSfMHRxEAb1tp5tRBf7p9OxWzpUzA57kQFf8v9AdHcRXa5ukV8hK4SlxuKtuoxow
	2KvAAmgEsw==
Received: from mail.thefacebook.com ([163.114.134.16])
	by m0001303.ppops.net (PPS) with ESMTPS id 452w27j4a9-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Thu, 27 Feb 2025 14:39:35 -0800 (PST)
Received: from twshared18153.09.ash9.facebook.com (2620:10d:c085:108::150d) by
 mail.thefacebook.com (2620:10d:c08b:78::c78f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.14; Thu, 27 Feb 2025 22:39:24 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id 8A5E21888281A; Thu, 27 Feb 2025 14:39:18 -0800 (PST)
From: Keith Busch <kbusch@meta.com>
To: <ming.lei@redhat.com>, <axboe@kernel.dk>, <asml.silence@gmail.com>,
        <linux-block@vger.kernel.org>, <io-uring@vger.kernel.org>
CC: <linux-nvme@lists.infradead.org>, <csander@purestorage.com>,
        Keith Busch
	<kbusch@kernel.org>
Subject: [PATCHv8 6/6] io_uring: cache nodes and mapped buffers
Date: Thu, 27 Feb 2025 14:39:16 -0800
Message-ID: <20250227223916.143006-7-kbusch@meta.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250227223916.143006-1-kbusch@meta.com>
References: <20250227223916.143006-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 6po2IQL67PAJSKZnHz6nI2W4pY1l2XlR
X-Proofpoint-GUID: 6po2IQL67PAJSKZnHz6nI2W4pY1l2XlR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-27_08,2025-02-27_01,2024-11-22_01

From: Keith Busch <kbusch@kernel.org>

Frequent alloc/free cycles on these is pretty costly. Use an io cache to
more efficiently reuse these buffers.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 include/linux/io_uring_types.h |  2 +
 io_uring/filetable.c           |  2 +-
 io_uring/io_uring.c            |  2 +
 io_uring/rsrc.c                | 70 +++++++++++++++++++++++++++-------
 io_uring/rsrc.h                |  4 +-
 5 files changed, 64 insertions(+), 16 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_type=
s.h
index c0fe8a00fe53a..3ce87dcd99eec 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -294,6 +294,8 @@ struct io_ring_ctx {
=20
 		struct io_file_table	file_table;
 		struct io_rsrc_data	buf_table;
+		struct io_alloc_cache	node_cache;
+		struct io_alloc_cache	imu_cache;
=20
 		struct io_submit_state	submit_state;
=20
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
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 2f5dd47e7dbf5..8f542a5f20a60 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -292,6 +292,7 @@ static void io_free_alloc_caches(struct io_ring_ctx *=
ctx)
 	io_alloc_cache_free(&ctx->uring_cache, kfree);
 	io_alloc_cache_free(&ctx->msg_cache, kfree);
 	io_futex_cache_free(ctx);
+	io_rsrc_cache_free(ctx);
 }
=20
 static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_para=
ms *p)
@@ -339,6 +340,7 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(s=
truct io_uring_params *p)
 	ret |=3D io_alloc_cache_init(&ctx->msg_cache, IO_ALLOC_CACHE_MAX,
 			    sizeof(struct io_kiocb), 0);
 	ret |=3D io_futex_cache_init(ctx);
+	ret |=3D io_rsrc_cache_init(ctx);
 	if (ret)
 		goto free_ref;
 	init_completion(&ctx->ref_comp);
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 0eceaf2e03777..450b4c039334d 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -33,6 +33,8 @@ static struct io_rsrc_node *io_sqe_buffer_register(stru=
ct io_ring_ctx *ctx,
 #define IORING_MAX_FIXED_FILES	(1U << 20)
 #define IORING_MAX_REG_BUFFERS	(1U << 14)
=20
+#define IO_CACHED_BVECS_SEGS	32
+
 int __io_account_mem(struct user_struct *user, unsigned long nr_pages)
 {
 	unsigned long page_limit, cur_pages, new_pages;
@@ -111,6 +113,22 @@ static void io_release_ubuf(void *priv)
 		unpin_user_page(imu->bvec[i].bv_page);
 }
=20
+static struct io_mapped_ubuf *io_alloc_imu(struct io_ring_ctx *ctx,
+					   int nr_bvecs)
+{
+	if (nr_bvecs <=3D IO_CACHED_BVECS_SEGS)
+		return io_cache_alloc(&ctx->imu_cache, GFP_KERNEL);
+	return kvmalloc(struct_size_t(struct io_mapped_ubuf, bvec, nr_bvecs),
+			GFP_KERNEL);
+}
+
+static void io_free_imu(struct io_ring_ctx *ctx, struct io_mapped_ubuf *=
imu)
+{
+	if (imu->nr_bvecs > IO_CACHED_BVECS_SEGS ||
+	    !io_alloc_cache_put(&ctx->imu_cache, imu))
+		kvfree(imu);
+}
+
 static void io_buffer_unmap(struct io_ring_ctx *ctx, struct io_mapped_ub=
uf *imu)
 {
 	if (!refcount_dec_and_test(&imu->refs))
@@ -119,22 +137,44 @@ static void io_buffer_unmap(struct io_ring_ctx *ctx=
, struct io_mapped_ubuf *imu)
 	if (imu->acct_pages)
 		io_unaccount_mem(ctx, imu->acct_pages);
 	imu->release(imu->priv);
-	kvfree(imu);
 }
=20
-struct io_rsrc_node *io_rsrc_node_alloc(int type)
+struct io_rsrc_node *io_rsrc_node_alloc(struct io_ring_ctx *ctx, int typ=
e)
 {
 	struct io_rsrc_node *node;
=20
-	node =3D kzalloc(sizeof(*node), GFP_KERNEL);
+	node =3D io_cache_alloc(&ctx->node_cache, GFP_KERNEL);
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
+bool io_rsrc_cache_init(struct io_ring_ctx *ctx)
+{
+	const int imu_cache_size =3D struct_size_t(struct io_mapped_ubuf, bvec,
+						 IO_CACHED_BVECS_SEGS);
+	const int node_size =3D sizeof(struct io_rsrc_node);
+	bool ret;
+
+	ret =3D io_alloc_cache_init(&ctx->node_cache, IO_ALLOC_CACHE_MAX,
+				  node_size, 0);
+	ret |=3D io_alloc_cache_init(&ctx->imu_cache, IO_ALLOC_CACHE_MAX,
+				   imu_cache_size, 0);
+	return ret;
+}
+
+void io_rsrc_cache_free(struct io_ring_ctx *ctx)
+{
+	io_alloc_cache_free(&ctx->node_cache, kfree);
+	io_alloc_cache_free(&ctx->imu_cache, kfree);
+}
+
+__cold void io_rsrc_data_free(struct io_ring_ctx *ctx,
+			      struct io_rsrc_data *data)
 {
 	if (!data->nr)
 		return;
@@ -207,7 +247,7 @@ static int __io_sqe_files_update(struct io_ring_ctx *=
ctx,
 				err =3D -EBADF;
 				break;
 			}
-			node =3D io_rsrc_node_alloc(IORING_RSRC_FILE);
+			node =3D io_rsrc_node_alloc(ctx, IORING_RSRC_FILE);
 			if (!node) {
 				err =3D -ENOMEM;
 				fput(file);
@@ -465,7 +505,8 @@ void io_free_rsrc_node(struct io_ring_ctx *ctx, struc=
t io_rsrc_node *node)
 		break;
 	}
=20
-	kfree(node);
+	if (!io_alloc_cache_put(&ctx->node_cache, node))
+		kvfree(node);
 }
=20
 int io_sqe_files_unregister(struct io_ring_ctx *ctx)
@@ -527,7 +568,7 @@ int io_sqe_files_register(struct io_ring_ctx *ctx, vo=
id __user *arg,
 			goto fail;
 		}
 		ret =3D -ENOMEM;
-		node =3D io_rsrc_node_alloc(IORING_RSRC_FILE);
+		node =3D io_rsrc_node_alloc(ctx, IORING_RSRC_FILE);
 		if (!node) {
 			fput(file);
 			goto fail;
@@ -732,7 +773,7 @@ static struct io_rsrc_node *io_sqe_buffer_register(st=
ruct io_ring_ctx *ctx,
 	if (!iov->iov_base)
 		return NULL;
=20
-	node =3D io_rsrc_node_alloc(IORING_RSRC_BUFFER);
+	node =3D io_rsrc_node_alloc(ctx, IORING_RSRC_BUFFER);
 	if (!node)
 		return ERR_PTR(-ENOMEM);
 	node->buf =3D NULL;
@@ -752,10 +793,11 @@ static struct io_rsrc_node *io_sqe_buffer_register(=
struct io_ring_ctx *ctx,
 			coalesced =3D io_coalesce_buffer(&pages, &nr_pages, &data);
 	}
=20
-	imu =3D kvmalloc(struct_size(imu, bvec, nr_pages), GFP_KERNEL);
+	imu =3D io_alloc_imu(ctx, nr_pages);
 	if (!imu)
 		goto done;
=20
+	imu->nr_bvecs =3D nr_pages;
 	ret =3D io_buffer_account_pin(ctx, pages, nr_pages, imu, last_hpage);
 	if (ret) {
 		unpin_user_pages(pages, nr_pages);
@@ -766,7 +808,6 @@ static struct io_rsrc_node *io_sqe_buffer_register(st=
ruct io_ring_ctx *ctx,
 	/* store original address for later verification */
 	imu->ubuf =3D (unsigned long) iov->iov_base;
 	imu->len =3D iov->iov_len;
-	imu->nr_bvecs =3D nr_pages;
 	imu->folio_shift =3D PAGE_SHIFT;
 	imu->release =3D io_release_ubuf;
 	imu->priv =3D imu;
@@ -789,7 +830,8 @@ static struct io_rsrc_node *io_sqe_buffer_register(st=
ruct io_ring_ctx *ctx,
 	}
 done:
 	if (ret) {
-		kvfree(imu);
+		if (imu)
+			io_free_imu(ctx, imu);
 		if (node)
 			io_put_rsrc_node(ctx, node);
 		node =3D ERR_PTR(ret);
@@ -893,14 +935,14 @@ int io_buffer_register_bvec(struct io_uring_cmd *cm=
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
+	imu =3D io_alloc_imu(ctx, nr_bvecs);
 	if (!imu) {
 		kfree(node);
 		ret =3D -ENOMEM;
@@ -1137,7 +1179,7 @@ static int io_clone_buffers(struct io_ring_ctx *ctx=
, struct io_ring_ctx *src_ctx
 		if (!src_node) {
 			dst_node =3D NULL;
 		} else {
-			dst_node =3D io_rsrc_node_alloc(IORING_RSRC_BUFFER);
+			dst_node =3D io_rsrc_node_alloc(ctx, IORING_RSRC_BUFFER);
 			if (!dst_node) {
 				ret =3D -ENOMEM;
 				goto out_free;
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index 7600e2736eeb3..27e545694d01e 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -48,7 +48,9 @@ struct io_imu_folio_data {
 	unsigned int	nr_folios;
 };
=20
-struct io_rsrc_node *io_rsrc_node_alloc(int type);
+bool io_rsrc_cache_init(struct io_ring_ctx *ctx);
+void io_rsrc_cache_free(struct io_ring_ctx *ctx);
+struct io_rsrc_node *io_rsrc_node_alloc(struct io_ring_ctx *ctx, int typ=
e);
 void io_free_rsrc_node(struct io_ring_ctx *ctx, struct io_rsrc_node *nod=
e);
 void io_rsrc_data_free(struct io_ring_ctx *ctx, struct io_rsrc_data *dat=
a);
 int io_rsrc_data_alloc(struct io_rsrc_data *data, unsigned nr);
--=20
2.43.5


