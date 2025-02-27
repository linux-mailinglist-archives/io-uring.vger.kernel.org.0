Return-Path: <io-uring+bounces-6847-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BC73DA48BD1
	for <lists+io-uring@lfdr.de>; Thu, 27 Feb 2025 23:42:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A555E3B7D77
	for <lists+io-uring@lfdr.de>; Thu, 27 Feb 2025 22:41:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E97423E323;
	Thu, 27 Feb 2025 22:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="hA9zVb0s"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4749B22B5BC
	for <io-uring@vger.kernel.org>; Thu, 27 Feb 2025 22:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740696003; cv=none; b=rtHcMNBeOQXCFY0wZWD43SvRa1L+0ek2t7veqX5zhbVbZjEZN/6kJ96QoIb9qqSZf32v8Nv+eCI3TMQy9OpFwcfHJ1DPaeiVHDvNJLmunLOjdG7LQoaTddH0HjNvmudpgqPcppWvZfp/Nj7PRd/8IHTzIWPsZcsb2Eww+yy+JFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740696003; c=relaxed/simple;
	bh=WdX7C6heYWDbxjcINIFdpEstg6W2EbKyUpQ9SZC8K1E=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZmqriHYjRpiwEqqEAXcmi1tPhDqy98670fuXL6p0FT3iLrunMpHPK8YdlCD+IecgCspDbb5ngGydkBsqFNiKJxE/OkbrkcXvYTA0kluqHqKA2gKxQYdqNxemdHX3vJhWHubXVv51xbZOdh357oE3NgPRNk1hu86YfnIFK1wO198=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=hA9zVb0s; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51RMdiR2011881
	for <io-uring@vger.kernel.org>; Thu, 27 Feb 2025 14:40:00 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2021-q4;
	 bh=ElZ0wok2zPHHu3RVXvRiuOKG8By28N0zN2EuqI29MbQ=; b=hA9zVb0s7SGf
	U1MYAirrfOcnlQqIr6zXMSGjlFEU2zwi6GC8y9+opAPtFLvrCORPb/3QC3IcMuEv
	okLPUlQIjYd75FFPWmD74ZLgJsc21cOn+hPfqbzmUP2iRhe4hcZ9uzGO5Iz/MwhK
	oBcLPLpn1MSo3HkR+vc1KECy8Tf2OBvMqQkhzqgt+qHFH2sIWaucF8vgZZAlcIYz
	dyVCRbnmb93eGWoBBhArQKxsDhEuVtCz5fHVFxBKxifqWprXe5GGz5dH1sI4oLLs
	CO1YF2iE8AdlKJWdu5GofwPXoR/0kX/SlWrVsHqAmZDfUhv6htNAP+fJWol19VQq
	vGnhck+9wA==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 452wtb9nsk-11
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Thu, 27 Feb 2025 14:39:59 -0800 (PST)
Received: from twshared40462.17.frc2.facebook.com (2620:10d:c0a8:fe::f072) by
 mail.thefacebook.com (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.14; Thu, 27 Feb 2025 22:39:14 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id 1A82518882814; Thu, 27 Feb 2025 14:39:17 -0800 (PST)
From: Keith Busch <kbusch@meta.com>
To: <ming.lei@redhat.com>, <axboe@kernel.dk>, <asml.silence@gmail.com>,
        <linux-block@vger.kernel.org>, <io-uring@vger.kernel.org>
CC: <linux-nvme@lists.infradead.org>, <csander@purestorage.com>,
        Keith Busch
	<kbusch@kernel.org>
Subject: [PATCHv8 4/6] io_uring: add support for kernel registered bvecs
Date: Thu, 27 Feb 2025 14:39:14 -0800
Message-ID: <20250227223916.143006-5-kbusch@meta.com>
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
X-Proofpoint-GUID: VtZoIV1DKzfYt5Qaqw3SR2zb8xfOWFiX
X-Proofpoint-ORIG-GUID: VtZoIV1DKzfYt5Qaqw3SR2zb8xfOWFiX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-27_08,2025-02-27_01,2024-11-22_01

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
 io_uring/rsrc.c              | 123 +++++++++++++++++++++++++++++++++--
 io_uring/rsrc.h              |   9 +++
 io_uring/rw.c                |   3 +
 5 files changed, 138 insertions(+), 7 deletions(-)

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
index db1c0792def63..2f5dd47e7dbf5 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3947,6 +3947,9 @@ static int __init io_uring_init(void)
=20
 	io_uring_optable_init();
=20
+	/* imu->dir is u8 */
+	BUILD_BUG_ON((IO_IMU_DEST | IO_IMU_SOURCE) > U8_MAX);
+
 	/*
 	 * Allow user copy in the per-command field, which starts after the
 	 * file in io_kiocb and until the opcode field. The openat2 handling
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index f814526982c36..0eceaf2e03777 100644
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
@@ -101,17 +102,23 @@ int io_buffer_validate(struct iovec *iov)
 	return 0;
 }
=20
-static void io_buffer_unmap(struct io_ring_ctx *ctx, struct io_rsrc_node=
 *node)
+static void io_release_ubuf(void *priv)
 {
-	struct io_mapped_ubuf *imu =3D node->buf;
+	struct io_mapped_ubuf *imu =3D priv;
 	unsigned int i;
=20
-	if (!refcount_dec_and_test(&imu->refs))
-		return;
 	for (i =3D 0; i < imu->nr_bvecs; i++)
 		unpin_user_page(imu->bvec[i].bv_page);
+}
+
+static void io_buffer_unmap(struct io_ring_ctx *ctx, struct io_mapped_ub=
uf *imu)
+{
+	if (!refcount_dec_and_test(&imu->refs))
+		return;
+
 	if (imu->acct_pages)
 		io_unaccount_mem(ctx, imu->acct_pages);
+	imu->release(imu->priv);
 	kvfree(imu);
 }
=20
@@ -451,7 +458,7 @@ void io_free_rsrc_node(struct io_ring_ctx *ctx, struc=
t io_rsrc_node *node)
 		break;
 	case IORING_RSRC_BUFFER:
 		if (node->buf)
-			io_buffer_unmap(ctx, node);
+			io_buffer_unmap(ctx, node->buf);
 		break;
 	default:
 		WARN_ON_ONCE(1);
@@ -761,6 +768,10 @@ static struct io_rsrc_node *io_sqe_buffer_register(s=
truct io_ring_ctx *ctx,
 	imu->len =3D iov->iov_len;
 	imu->nr_bvecs =3D nr_pages;
 	imu->folio_shift =3D PAGE_SHIFT;
+	imu->release =3D io_release_ubuf;
+	imu->priv =3D imu;
+	imu->is_kbuf =3D false;
+	imu->dir =3D IO_IMU_DEST | IO_IMU_SOURCE;
 	if (coalesced)
 		imu->folio_shift =3D data.folio_shift;
 	refcount_set(&imu->refs, 1);
@@ -857,6 +868,95 @@ int io_sqe_buffers_register(struct io_ring_ctx *ctx,=
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
+	imu->is_kbuf =3D true;
+
+	if (op_is_write(req_op(rq)))
+		imu->dir =3D IO_IMU_SOURCE;
+	else
+		imu->dir =3D IO_IMU_DEST;
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
+	if (!node || !node->buf->is_kbuf)
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
@@ -871,6 +971,8 @@ static int io_import_fixed(int ddir, struct iov_iter =
*iter,
 	/* not inside the mapped region */
 	if (unlikely(buf_addr < imu->ubuf || buf_end > (imu->ubuf + imu->len)))
 		return -EFAULT;
+	if (!(imu->dir & (1 << ddir)))
+		return -EFAULT;
=20
 	/*
 	 * Might not be a start of buffer, set size appropriately
@@ -883,8 +985,8 @@ static int io_import_fixed(int ddir, struct iov_iter =
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
@@ -898,8 +1000,15 @@ static int io_import_fixed(int ddir, struct iov_ite=
r *iter,
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
+		} else if (imu->is_kbuf) {
+			iov_iter_advance(iter, offset);
 		} else {
 			unsigned long seg_skip;
=20
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index f0e9080599646..7600e2736eeb3 100644
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
@@ -27,6 +32,10 @@ struct io_mapped_ubuf {
 	unsigned int    folio_shift;
 	refcount_t	refs;
 	unsigned long	acct_pages;
+	void		(*release)(void *);
+	void		*priv;
+	bool		is_kbuf;
+	u8		dir;
 	struct bio_vec	bvec[] __counted_by(nr_bvecs);
 };
=20
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 7bc23802a388e..5ee9f8949e8ba 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -629,6 +629,7 @@ static inline loff_t *io_kiocb_ppos(struct kiocb *kio=
cb)
  */
 static ssize_t loop_rw_iter(int ddir, struct io_rw *rw, struct iov_iter =
*iter)
 {
+	struct io_kiocb *req =3D cmd_to_io_kiocb(rw);
 	struct kiocb *kiocb =3D &rw->kiocb;
 	struct file *file =3D kiocb->ki_filp;
 	ssize_t ret =3D 0;
@@ -644,6 +645,8 @@ static ssize_t loop_rw_iter(int ddir, struct io_rw *r=
w, struct iov_iter *iter)
 	if ((kiocb->ki_flags & IOCB_NOWAIT) &&
 	    !(kiocb->ki_filp->f_flags & O_NONBLOCK))
 		return -EAGAIN;
+	if ((req->flags & REQ_F_BUF_NODE) && req->buf_node->buf->is_kbuf)
+		return -EFAULT;
=20
 	ppos =3D io_kiocb_ppos(kiocb);
=20
--=20
2.43.5


