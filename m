Return-Path: <io-uring+bounces-6795-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5DB8AA4690A
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2025 19:10:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 53A78173D4D
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2025 18:10:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA9BA2356B8;
	Wed, 26 Feb 2025 18:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="UXlmkX87"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B731233723
	for <io-uring@vger.kernel.org>; Wed, 26 Feb 2025 18:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740593417; cv=none; b=MpKBecDnBx07L1DdqYYbD8dkiZ1jA4m21S5kEnw3tcW6/MgDMcy+ODWH2gVGdkAxY4jLR+jz56HvvoTytOV0iu4vi42jSFpPwWeW1YH2/k2b6Ue4AZ5b4VA0A1emzbZOQuuOaMxSqdqR7SOKcBLdrX2VeyIv+Y3GFx8mOIu5ZjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740593417; c=relaxed/simple;
	bh=42doPWHs01cCRK+7iQ8nxJijoXH+EnGvaHbI6a7w6GI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z2b4Tv2PbyTamH3tauGXWbR4V+Eke/3aqxRltZAkGie/jKQKdibw458NmuZKPyCNyeJkA6XJzg8LeCt42DF7k+Z/ZVRGeiqo498P2uQi7auQ5loLO5XB4dVe6vRU2DRH5+PlGQWs8eb8rqNP2N/h5Zf2WuvzB1L/zk5f+iWVt2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=UXlmkX87; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51QF0jR8019840
	for <io-uring@vger.kernel.org>; Wed, 26 Feb 2025 10:10:14 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2021-q4;
	 bh=y0Y/ECEqgQaIDn98rUw+oY23UvTFuskrGecxUwUlobU=; b=UXlmkX872RvS
	fVZcwbzR8w10azLWTVmP21uM57kD9h7g02SPvgGZA/QfscBFe/gCsjH8k4Ly+U4Q
	EbMRDLYZYKTPWGuJKJy7Sl1rUpBTEyioe7inTk8yPFj6wIcUnrZAWZJ2P2ooAg8J
	cpKAc1xTwWs9VsG+dZOxJfNVWvBGMjfcSBIf+VyqVYoUjXNinddj+NDoJwMKOeL2
	/P8IuxIBbEY3eOMboBoh5AKMrHXcfzZTGLJ3wGrfPvNmTzz3reBWYNeeMrdtIPFO
	Y3VpUa2Mno3GXt8VdEy38Qdpyl9jnpNsmFVYBZqYEe4uNRXfYd+PdzjV5Ie8Jk/J
	hKAJcpesEA==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 45257j1ewn-7
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Wed, 26 Feb 2025 10:10:13 -0800 (PST)
Received: from twshared55211.03.ash8.facebook.com (2620:10d:c0a8:1b::2d) by
 mail.thefacebook.com (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.14; Wed, 26 Feb 2025 18:10:02 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id B189E187C4ACF; Wed, 26 Feb 2025 10:10:05 -0800 (PST)
From: Keith Busch <kbusch@meta.com>
To: <ming.lei@redhat.com>, <asml.silence@gmail.com>, <axboe@kernel.dk>,
        <linux-block@vger.kernel.org>, <io-uring@vger.kernel.org>
CC: <bernd@bsbernd.com>, <csander@purestorage.com>,
        <linux-nvme@lists.infradead.org>, Keith Busch <kbusch@kernel.org>
Subject: [PATCHv6 1/5] io_uring: add support for kernel registered bvecs
Date: Wed, 26 Feb 2025 10:09:52 -0800
Message-ID: <20250226181002.2574148-2-kbusch@meta.com>
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
X-Proofpoint-ORIG-GUID: Gf9QXlAnbvssPuQmj3VfmM7IYfeSnZIX
X-Proofpoint-GUID: Gf9QXlAnbvssPuQmj3VfmM7IYfeSnZIX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-26_04,2025-02-26_01,2024-11-22_01

From: Keith Busch <kbusch@kernel.org>

Provide an interface for the kernel to leverage the existing
pre-registered buffers that io_uring provides. User space can reference
these later to achieve zero-copy IO.

User space must register an empty fixed buffer table with io_uring in
order for the kernel to make use of it.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 include/linux/io_uring/cmd.h |   7 ++
 io_uring/io_uring.c          |   3 +
 io_uring/rsrc.c              | 122 +++++++++++++++++++++++++++++++++--
 io_uring/rsrc.h              |   8 +++
 4 files changed, 133 insertions(+), 7 deletions(-)

diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
index 87150dc0a07cf..cf8d80d847344 100644
--- a/include/linux/io_uring/cmd.h
+++ b/include/linux/io_uring/cmd.h
@@ -4,6 +4,7 @@
=20
 #include <uapi/linux/io_uring.h>
 #include <linux/io_uring_types.h>
+#include <linux/blk-mq.h>
=20
 /* only top 8 bits of sqe->uring_cmd_flags for kernel internal use */
 #define IORING_URING_CMD_CANCELABLE	(1U << 30)
@@ -125,4 +126,10 @@ static inline struct io_uring_cmd_data *io_uring_cmd=
_get_async_data(struct io_ur
 	return cmd_to_io_kiocb(cmd)->async_data;
 }
=20
+int io_buffer_register_bvec(struct io_uring_cmd *cmd, struct request *rq=
,
+			    void (*release)(void *), unsigned int index,
+			    unsigned int issue_flags);
+void io_buffer_unregister_bvec(struct io_uring_cmd *cmd, unsigned int in=
dex,
+			       unsigned int issue_flags);
+
 #endif /* _LINUX_IO_URING_CMD_H */
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index db1c0792def63..31e936d468051 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3947,6 +3947,9 @@ static int __init io_uring_init(void)
=20
 	io_uring_optable_init();
=20
+	/* imu->perm is u8 */
+	BUILD_BUG_ON((IO_IMU_DEST | IO_IMU_SOURCE) > U8_MAX);
+
 	/*
 	 * Allow user copy in the per-command field, which starts after the
 	 * file in io_kiocb and until the opcode field. The openat2 handling
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index f814526982c36..5b234e84dcba6 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -9,6 +9,7 @@
 #include <linux/hugetlb.h>
 #include <linux/compat.h>
 #include <linux/io_uring.h>
+#include <linux/io_uring/cmd.h>
=20
 #include <uapi/linux/io_uring.h>
=20
@@ -104,14 +105,21 @@ int io_buffer_validate(struct iovec *iov)
 static void io_buffer_unmap(struct io_ring_ctx *ctx, struct io_rsrc_node=
 *node)
 {
 	struct io_mapped_ubuf *imu =3D node->buf;
-	unsigned int i;
=20
 	if (!refcount_dec_and_test(&imu->refs))
 		return;
-	for (i =3D 0; i < imu->nr_bvecs; i++)
-		unpin_user_page(imu->bvec[i].bv_page);
-	if (imu->acct_pages)
-		io_unaccount_mem(ctx, imu->acct_pages);
+
+	if (imu->release) {
+		imu->release(imu->priv);
+	} else {
+		unsigned int i;
+
+		for (i =3D 0; i < imu->nr_bvecs; i++)
+			unpin_user_page(imu->bvec[i].bv_page);
+		if (imu->acct_pages)
+			io_unaccount_mem(ctx, imu->acct_pages);
+	}
+
 	kvfree(imu);
 }
=20
@@ -761,6 +769,9 @@ static struct io_rsrc_node *io_sqe_buffer_register(st=
ruct io_ring_ctx *ctx,
 	imu->len =3D iov->iov_len;
 	imu->nr_bvecs =3D nr_pages;
 	imu->folio_shift =3D PAGE_SHIFT;
+	imu->release =3D NULL;
+	imu->priv =3D NULL;
+	imu->perm =3D IO_IMU_DEST	| IO_IMU_SOURCE;
 	if (coalesced)
 		imu->folio_shift =3D data.folio_shift;
 	refcount_set(&imu->refs, 1);
@@ -857,6 +868,94 @@ int io_sqe_buffers_register(struct io_ring_ctx *ctx,=
 void __user *arg,
 	return ret;
 }
=20
+int io_buffer_register_bvec(struct io_uring_cmd *cmd, struct request *rq=
,
+			    void (*release)(void *), unsigned int index,
+			    unsigned int issue_flags)
+{
+	struct io_ring_ctx *ctx =3D cmd_to_io_kiocb(cmd)->ctx;
+	struct io_rsrc_data *data =3D &ctx->buf_table;
+	struct req_iterator rq_iter;
+	struct io_mapped_ubuf *imu;
+	struct io_rsrc_node *node;
+	struct bio_vec bv, *bvec;
+	u16 nr_bvecs;
+	int ret =3D 0;
+
+	io_ring_submit_lock(ctx, issue_flags);
+	if (index >=3D data->nr) {
+		ret =3D -EINVAL;
+		goto unlock;
+	}
+	index =3D array_index_nospec(index, data->nr);
+
+	if (data->nodes[index]) {
+		ret =3D -EBUSY;
+		goto unlock;
+	}
+
+	node =3D io_rsrc_node_alloc(IORING_RSRC_BUFFER);
+	if (!node) {
+		ret =3D -ENOMEM;
+		goto unlock;
+	}
+
+	nr_bvecs =3D blk_rq_nr_phys_segments(rq);
+	imu =3D kvmalloc(struct_size(imu, bvec, nr_bvecs), GFP_KERNEL);
+	if (!imu) {
+		kfree(node);
+		ret =3D -ENOMEM;
+		goto unlock;
+	}
+
+	imu->ubuf =3D 0;
+	imu->len =3D blk_rq_bytes(rq);
+	imu->acct_pages =3D 0;
+	imu->folio_shift =3D PAGE_SHIFT;
+	imu->nr_bvecs =3D nr_bvecs;
+	refcount_set(&imu->refs, 1);
+	imu->release =3D release;
+	imu->priv =3D rq;
+
+	if (op_is_write(req_op(rq)))
+		imu->perm =3D IO_IMU_SOURCE;
+	else
+		imu->perm =3D IO_IMU_DEST;
+
+	bvec =3D imu->bvec;
+	rq_for_each_bvec(bv, rq, rq_iter)
+		*bvec++ =3D bv;
+
+	node->buf =3D imu;
+	data->nodes[index] =3D node;
+unlock:
+	io_ring_submit_unlock(ctx, issue_flags);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(io_buffer_register_bvec);
+
+void io_buffer_unregister_bvec(struct io_uring_cmd *cmd, unsigned int in=
dex,
+			       unsigned int issue_flags)
+{
+	struct io_ring_ctx *ctx =3D cmd_to_io_kiocb(cmd)->ctx;
+	struct io_rsrc_data *data =3D &ctx->buf_table;
+	struct io_rsrc_node *node;
+
+	io_ring_submit_lock(ctx, issue_flags);
+	if (index >=3D data->nr)
+		goto unlock;
+	index =3D array_index_nospec(index, data->nr);
+
+	node =3D data->nodes[index];
+	if (!node || !node->buf->release)
+		goto unlock;
+
+	io_put_rsrc_node(ctx, node);
+	data->nodes[index] =3D NULL;
+unlock:
+	io_ring_submit_unlock(ctx, issue_flags);
+}
+EXPORT_SYMBOL_GPL(io_buffer_unregister_bvec);
+
 static int io_import_fixed(int ddir, struct iov_iter *iter,
 			   struct io_mapped_ubuf *imu,
 			   u64 buf_addr, size_t len)
@@ -871,6 +970,8 @@ static int io_import_fixed(int ddir, struct iov_iter =
*iter,
 	/* not inside the mapped region */
 	if (unlikely(buf_addr < imu->ubuf || buf_end > (imu->ubuf + imu->len)))
 		return -EFAULT;
+	if (!(imu->perm & (1 << ddir)))
+		return -EFAULT;
=20
 	/*
 	 * Might not be a start of buffer, set size appropriately
@@ -883,8 +984,8 @@ static int io_import_fixed(int ddir, struct iov_iter =
*iter,
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
@@ -898,8 +999,15 @@ static int io_import_fixed(int ddir, struct iov_iter=
 *iter,
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
+		} else if (imu->release) {
+			iov_iter_advance(iter, offset);
 		} else {
 			unsigned long seg_skip;
=20
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index f0e9080599646..9668804afddc4 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -20,6 +20,11 @@ struct io_rsrc_node {
 	};
 };
=20
+enum {
+	IO_IMU_DEST	=3D 1 << ITER_DEST,
+	IO_IMU_SOURCE	=3D 1 << ITER_SOURCE,
+};
+
 struct io_mapped_ubuf {
 	u64		ubuf;
 	unsigned int	len;
@@ -27,6 +32,9 @@ struct io_mapped_ubuf {
 	unsigned int    folio_shift;
 	refcount_t	refs;
 	unsigned long	acct_pages;
+	void		(*release)(void *);
+	void		*priv;
+	u8		perm;
 	struct bio_vec	bvec[] __counted_by(nr_bvecs);
 };
=20
--=20
2.43.5


