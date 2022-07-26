Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 654F9581879
	for <lists+io-uring@lfdr.de>; Tue, 26 Jul 2022 19:38:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239452AbiGZRi1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Jul 2022 13:38:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238661AbiGZRi0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Jul 2022 13:38:26 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02FCA2E9DB
        for <io-uring@vger.kernel.org>; Tue, 26 Jul 2022 10:38:23 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26QEJjja001473
        for <io-uring@vger.kernel.org>; Tue, 26 Jul 2022 10:38:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=upFvUplL9WdQZWsooaut7tyuD9AcqX5PVtTEGpxNelI=;
 b=e5hbVdD/ed7NyPaNMj2hRayAJBf3EQpIyC4KxiilOcmLx5tjxHzCy6SCbMBUXxTppJfb
 wxNyLI9wrHFbcsB5N/ia3m1MTpyDFVKnd9UoFxJMtLEz2FvKHw6Nn/VeYjpkHu9eOw+b
 Ct1e8ZkHA3XbESBfhz9lT43c9mIqI5+00X4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hjhxashns-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 26 Jul 2022 10:38:22 -0700
Received: from twshared7556.02.ash8.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Tue, 26 Jul 2022 10:38:21 -0700
Received: by devbig007.nao1.facebook.com (Postfix, from userid 544533)
        id 78B33698E4B0; Tue, 26 Jul 2022 10:38:15 -0700 (PDT)
From:   Keith Busch <kbusch@fb.com>
To:     <linux-nvme@lists.infradead.org>, <linux-block@vger.kernel.org>,
        <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>
CC:     <axboe@kernel.dk>, <hch@lst.de>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Keith Busch <kbusch@kernel.org>
Subject: [PATCH 4/5] io_uring: add support for dma pre-mapping
Date:   Tue, 26 Jul 2022 10:38:13 -0700
Message-ID: <20220726173814.2264573-5-kbusch@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220726173814.2264573-1-kbusch@fb.com>
References: <20220726173814.2264573-1-kbusch@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 16xvYgdSh3-L6l8uIrkVMaJrWyYoUrXK
X-Proofpoint-GUID: 16xvYgdSh3-L6l8uIrkVMaJrWyYoUrXK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-26_05,2022-07-26_01,2022-06-22_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Keith Busch <kbusch@kernel.org>

Provide a new register operation that can request to pre-map a known
bvec to the driver of the requested file descriptor's specific
implementation. If successful, io_uring will use the returned dma tag
for future fixed buffer requests to the same file.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 include/uapi/linux/io_uring.h |  12 ++++
 io_uring/io_uring.c           | 129 ++++++++++++++++++++++++++++++++++
 io_uring/net.c                |   2 +-
 io_uring/rsrc.c               |  13 +++-
 io_uring/rsrc.h               |  16 ++++-
 io_uring/rw.c                 |   2 +-
 6 files changed, 166 insertions(+), 8 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.=
h
index 1463cfecb56b..daacbe899d1d 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -485,6 +485,10 @@ enum {
 	IORING_REGISTER_NOTIFIERS		=3D 26,
 	IORING_UNREGISTER_NOTIFIERS		=3D 27,
=20
+	/* dma map registered buffers */
+	IORING_REGISTER_MAP_BUFFERS		=3D 28,
+	IORING_REGISTER_UNMAP_BUFFERS		=3D 29,
+
 	/* this goes last */
 	IORING_REGISTER_LAST
 };
@@ -661,4 +665,12 @@ struct io_uring_recvmsg_out {
 	__u32 flags;
 };
=20
+struct io_uring_map_buffers {
+	__s32	fd;
+	__s32	buf_start;
+	__s32	buf_end;
+	__u32	flags;
+	__u64	rsvd[2];
+};
+
 #endif
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 1d600a63643b..12f7354e0423 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3704,6 +3704,123 @@ static __cold int io_register_iowq_max_workers(st=
ruct io_ring_ctx *ctx,
 	return ret;
 }
=20
+#ifdef CONFIG_BLOCK
+static int get_map_range(struct io_ring_ctx *ctx,
+			 struct io_uring_map_buffers *map, void __user *arg)
+{
+	int ret;
+
+	if (copy_from_user(map, arg, sizeof(*map)))
+		return -EFAULT;
+	if (map->flags || map->rsvd[0] || map->rsvd[1])
+		return -EINVAL;
+	if (map->buf_start < 0)
+		return -EINVAL;
+	if (map->buf_start >=3D ctx->nr_user_bufs)
+		return -EINVAL;
+	if (map->buf_end > ctx->nr_user_bufs)
+		map->buf_end =3D ctx->nr_user_bufs;
+
+	ret =3D map->buf_end - map->buf_start;
+	if (ret <=3D 0)
+		return -EINVAL;
+
+	return ret;
+}
+
+void io_dma_unmap(struct io_mapped_ubuf *imu)
+{
+	if (imu->dma_tag)
+		block_dma_unmap(imu->bdev, imu->dma_tag);
+}
+
+static int io_register_unmap_buffers(struct io_ring_ctx *ctx, void __use=
r *arg)
+{
+	struct io_uring_map_buffers map;
+	int i, ret;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+	ret =3D get_map_range(ctx, &map, arg);
+	if (ret < 0)
+		return ret;
+
+	for (i =3D map.buf_start; i < map.buf_end; i++) {
+		struct io_mapped_ubuf *imu =3D ctx->user_bufs[i];
+
+		io_dma_unmap(imu);
+	}
+
+	return 0;
+}
+
+static int io_register_map_buffers(struct io_ring_ctx *ctx, void __user =
*arg)
+{
+	struct io_uring_map_buffers map;
+	struct block_device *bdev;
+	struct file *file;
+	int ret, i;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	ret =3D get_map_range(ctx, &map, arg);
+	if (ret < 0)
+		return ret;
+
+	file =3D fget(map.fd);
+	if (!file)
+		return -EBADF;
+
+	if (S_ISBLK(file_inode(file)->i_mode))
+		bdev =3D I_BDEV(file->f_mapping->host);
+	else if (S_ISREG(file_inode(file)->i_mode))
+		bdev =3D file->f_inode->i_sb->s_bdev;
+	else
+		return -EOPNOTSUPP;
+
+	for (i =3D map.buf_start; i < map.buf_end; i++) {
+		struct io_mapped_ubuf *imu =3D ctx->user_bufs[i];
+		void *tag;
+
+		if (imu->dma_tag) {
+			ret =3D -EBUSY;
+			goto err;
+		}
+
+		tag =3D block_dma_map(bdev, imu->bvec, imu->nr_bvecs);
+		if (IS_ERR(tag)) {
+			ret =3D PTR_ERR(tag);
+			goto err;
+		}
+
+		imu->dma_tag =3D tag;
+		imu->dma_file =3D file;
+		imu->bdev =3D bdev;
+	}
+
+	fput(file);
+	return 0;
+err:
+	while (--i >=3D map.buf_start) {
+		struct io_mapped_ubuf *imu =3D ctx->user_bufs[i];
+
+		io_dma_unmap(imu);
+	}
+	fput(file);
+	return ret;
+}
+#else /* CONFIG_BLOCK */
+static int io_register_map_buffers(struct io_ring_ctx *ctx, void __user =
*arg)
+{
+	return -EOPNOTSUPP;
+}
+static int io_register_unmap_buffers(struct io_ring_ctx *ctx, void __use=
r *arg)
+{
+	return -EOPNOTSUPP;
+}
+#endif /* CONFIG_BLOCK */
+
 static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 			       void __user *arg, unsigned nr_args)
 	__releases(ctx->uring_lock)
@@ -3870,6 +3987,18 @@ static int __io_uring_register(struct io_ring_ctx =
*ctx, unsigned opcode,
 			break;
 		ret =3D io_notif_unregister(ctx);
 		break;
+	case IORING_REGISTER_MAP_BUFFERS:
+		ret =3D -EINVAL;
+		if (!arg || nr_args !=3D 1)
+			break;
+		ret =3D io_register_map_buffers(ctx, arg);
+		break;
+	case IORING_REGISTER_UNMAP_BUFFERS:
+		ret =3D -EINVAL;
+		if (!arg || nr_args !=3D 1)
+			break;
+		ret =3D io_register_unmap_buffers(ctx, arg);
+		break;
 	default:
 		ret =3D -EINVAL;
 		break;
diff --git a/io_uring/net.c b/io_uring/net.c
index 8276b9537194..68a996318959 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -977,7 +977,7 @@ int io_sendzc(struct io_kiocb *req, unsigned int issu=
e_flags)
=20
 	if (zc->flags & IORING_RECVSEND_FIXED_BUF) {
 		ret =3D io_import_fixed(WRITE, &msg.msg_iter, req->imu,
-					(u64)(uintptr_t)zc->buf, zc->len);
+					(u64)(uintptr_t)zc->buf, zc->len, NULL);
 		if (unlikely(ret))
 				return ret;
 	} else {
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 59704b9ac537..1a7a8dedbbd5 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -148,6 +148,7 @@ static void io_buffer_unmap(struct io_ring_ctx *ctx, =
struct io_mapped_ubuf **slo
 			unpin_user_page(imu->bvec[i].bv_page);
 		if (imu->acct_pages)
 			io_unaccount_mem(ctx, imu->acct_pages);
+		io_dma_unmap(imu);
 		kvfree(imu);
 	}
 	*slot =3D NULL;
@@ -1285,6 +1286,7 @@ static int io_sqe_buffer_register(struct io_ring_ct=
x *ctx, struct iovec *iov,
 	imu->ubuf =3D (unsigned long) iov->iov_base;
 	imu->ubuf_end =3D imu->ubuf + iov->iov_len;
 	imu->nr_bvecs =3D nr_pages;
+	imu->dma_tag =3D NULL;
 	*pimu =3D imu;
 	ret =3D 0;
 done:
@@ -1359,9 +1361,8 @@ int io_sqe_buffers_register(struct io_ring_ctx *ctx=
, void __user *arg,
 	return ret;
 }
=20
-int io_import_fixed(int ddir, struct iov_iter *iter,
-			   struct io_mapped_ubuf *imu,
-			   u64 buf_addr, size_t len)
+int io_import_fixed(int ddir, struct iov_iter *iter, struct io_mapped_ub=
uf *imu,
+		    u64 buf_addr, size_t len, struct file *file)
 {
 	u64 buf_end;
 	size_t offset;
@@ -1379,6 +1380,12 @@ int io_import_fixed(int ddir, struct iov_iter *ite=
r,
 	 * and advance us to the beginning.
 	 */
 	offset =3D buf_addr - imu->ubuf;
+	if (imu->dma_tag && file =3D=3D imu->dma_file) {
+		unsigned long nr_segs =3D (buf_addr & (PAGE_SIZE - 1)) +
+					(len >> PAGE_SHIFT);
+		iov_iter_dma_tag(iter, ddir, imu->dma_tag, offset, nr_segs, len);
+		return 0;
+	}
 	iov_iter_bvec(iter, ddir, imu->bvec, imu->nr_bvecs, offset + len);
=20
 	if (offset) {
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index f3a9a177941f..6e63b7a57b34 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -50,6 +50,11 @@ struct io_mapped_ubuf {
 	u64		ubuf_end;
 	unsigned int	nr_bvecs;
 	unsigned long	acct_pages;
+	void		*dma_tag;
+	struct file	*dma_file;
+#ifdef CONFIG_BLOCK
+	struct block_device *bdev;
+#endif
 	struct bio_vec	bvec[];
 };
=20
@@ -64,9 +69,14 @@ int io_queue_rsrc_removal(struct io_rsrc_data *data, u=
nsigned idx,
 void io_rsrc_node_switch(struct io_ring_ctx *ctx,
 			 struct io_rsrc_data *data_to_kill);
=20
-int io_import_fixed(int ddir, struct iov_iter *iter,
-			   struct io_mapped_ubuf *imu,
-			   u64 buf_addr, size_t len);
+int io_import_fixed(int ddir, struct iov_iter *iter, struct io_mapped_ub=
uf *imu,
+		    u64 buf_addr, size_t len, struct file *file);
+
+#ifdef CONFIG_BLOCK
+void io_dma_unmap(struct io_mapped_ubuf *imu);
+#else
+static inline void io_dma_unmap(struct io_mapped_ubuf *imu) {}
+#endif
=20
 void __io_sqe_buffers_unregister(struct io_ring_ctx *ctx);
 int io_sqe_buffers_unregister(struct io_ring_ctx *ctx);
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 2b784795103c..9e2164d09adb 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -359,7 +359,7 @@ static struct iovec *__io_import_iovec(int ddir, stru=
ct io_kiocb *req,
 	ssize_t ret;
=20
 	if (opcode =3D=3D IORING_OP_READ_FIXED || opcode =3D=3D IORING_OP_WRITE=
_FIXED) {
-		ret =3D io_import_fixed(ddir, iter, req->imu, rw->addr, rw->len);
+		ret =3D io_import_fixed(ddir, iter, req->imu, rw->addr, rw->len, req->=
file);
 		if (ret)
 			return ERR_PTR(ret);
 		return NULL;
--=20
2.30.2

