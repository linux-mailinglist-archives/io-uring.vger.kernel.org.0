Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D9EC5882A2
	for <lists+io-uring@lfdr.de>; Tue,  2 Aug 2022 21:37:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbiHBThJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 2 Aug 2022 15:37:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230199AbiHBTg5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 2 Aug 2022 15:36:57 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34FE652FD5
        for <io-uring@vger.kernel.org>; Tue,  2 Aug 2022 12:36:56 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 272I2lr7008245
        for <io-uring@vger.kernel.org>; Tue, 2 Aug 2022 12:36:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=9t6mf6sLcYSCrBL80uzyjH2yLvQxjclfMoyLt77c6KY=;
 b=iMZbaguQ09ujTHKruTYuQWJN5Wcg//lCH44u+pTMJdylp9HR42iPuR5lgMWmdzrlxVJL
 hw9afnLcb2rbnXGHBcccKkJ7xMbd3DuDqyEzw/+/LjfD27vzWTPn1LhScLQDX5rGPUVY
 sEYhsyGZOBeWlL3qGbGLpNzqt66ksEV1y2I= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hpq1perfq-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 02 Aug 2022 12:36:55 -0700
Received: from twshared8442.02.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Tue, 2 Aug 2022 12:36:51 -0700
Received: by devbig007.nao1.facebook.com (Postfix, from userid 544533)
        id 10A7B6E59F06; Tue,  2 Aug 2022 12:36:38 -0700 (PDT)
From:   Keith Busch <kbusch@fb.com>
To:     <linux-nvme@lists.infradead.org>, <linux-block@vger.kernel.org>,
        <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>
CC:     <axboe@kernel.dk>, <hch@lst.de>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Kernel Team <Kernel-team@fb.com>,
        Keith Busch <kbusch@kernel.org>
Subject: [PATCHv2 6/7] io_uring: add support for dma pre-mapping
Date:   Tue, 2 Aug 2022 12:36:32 -0700
Message-ID: <20220802193633.289796-7-kbusch@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220802193633.289796-1-kbusch@fb.com>
References: <20220802193633.289796-1-kbusch@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: jc9YlddLcnw0BY9kcYuTfbZxtCMdliBd
X-Proofpoint-ORIG-GUID: jc9YlddLcnw0BY9kcYuTfbZxtCMdliBd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-02_14,2022-08-02_01,2022-06-22_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Keith Busch <kbusch@kernel.org>

Provide a new register operation that can request to pre-map a known
bvec to the requested fixed file's specific implementation. If
successful, io_uring will use the returned dma tag for future fixed
buffer requests to the same file.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 include/linux/io_uring_types.h |   2 +
 include/uapi/linux/io_uring.h  |  12 +++
 io_uring/filetable.c           |   7 +-
 io_uring/filetable.h           |   7 +-
 io_uring/io_uring.c            | 137 +++++++++++++++++++++++++++++++++
 io_uring/net.c                 |   2 +-
 io_uring/rsrc.c                |  21 +++--
 io_uring/rsrc.h                |  10 ++-
 io_uring/rw.c                  |   2 +-
 9 files changed, 185 insertions(+), 15 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_type=
s.h
index f7fab3758cb9..f62ea17cc480 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -23,6 +23,8 @@ struct io_wq_work {
 	int cancel_seq;
 };
=20
+struct io_mapped_ubuf;
+
 struct io_fixed_file {
 	/* file * with additional FFS_* flags */
 	unsigned long file_ptr;
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
diff --git a/io_uring/filetable.c b/io_uring/filetable.c
index 1b8db1918678..5ca2f27f317f 100644
--- a/io_uring/filetable.c
+++ b/io_uring/filetable.c
@@ -189,9 +189,10 @@ int io_file_slot_queue_removal(struct io_ring_ctx *c=
tx,
 	struct file *file;
 	int ret;
=20
-	file =3D (struct file *)(file_slot->file_ptr & FFS_MASK);
-	ret =3D io_queue_rsrc_removal(ctx->file_data, slot_index,
-				    ctx->rsrc_node, file);
+	file =3D io_file_from_fixed(file_slot);
+	io_dma_unmap_file(ctx, file_slot);
+	ret =3D io_queue_rsrc_removal(ctx->file_data, slot_index, ctx->rsrc_nod=
e,
+				    file);
 	if (ret)
 		return ret;
=20
diff --git a/io_uring/filetable.h b/io_uring/filetable.h
index e52ecf359199..3b2aae5bff76 100644
--- a/io_uring/filetable.h
+++ b/io_uring/filetable.h
@@ -58,12 +58,17 @@ io_fixed_file_slot(struct io_file_table *table, unsig=
ned i)
 	return &table->files[i];
 }
=20
+static inline struct file *io_file_from_fixed(struct io_fixed_file *f)
+{
+	return (struct file *) (f->file_ptr & FFS_MASK);
+}
+
 static inline struct file *io_file_from_index(struct io_file_table *tabl=
e,
 					      int index)
 {
 	struct io_fixed_file *slot =3D io_fixed_file_slot(table, index);
=20
-	return (struct file *) (slot->file_ptr & FFS_MASK);
+	return io_file_from_fixed(slot);
 }
=20
 static inline void io_fixed_file_set(struct io_fixed_file *file_slot,
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index b54218da075c..f5be488eaf21 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3681,6 +3681,131 @@ static __cold int io_register_iowq_max_workers(st=
ruct io_ring_ctx *ctx,
 	return ret;
 }
=20
+static int get_map_range(struct io_ring_ctx *ctx,
+			 struct io_uring_map_buffers *map, void __user *arg)
+{
+	int ret;
+
+	if (copy_from_user(map, arg, sizeof(*map)))
+		return -EFAULT;
+	if (map->flags || map->rsvd[0] || map->rsvd[1])
+		return -EINVAL;
+	if (map->fd >=3D ctx->nr_user_files)
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
+	struct file *file;
+
+	if (!imu->dma_tag)
+		return;
+
+	file =3D io_file_from_fixed(imu->dma_file);
+	file_dma_unmap(file, imu->dma_tag);
+	imu->dma_file =3D NULL;
+	imu->dma_tag =3D NULL;
+}
+
+void io_dma_unmap_file(struct io_ring_ctx *ctx, struct io_fixed_file *fi=
le_slot)
+{
+	int i;
+
+	for (i =3D 0; i < ctx->nr_user_bufs; i++) {
+		struct io_mapped_ubuf *imu =3D ctx->user_bufs[i];
+
+		if (!imu->dma_tag)
+			continue;
+
+		if (imu->dma_file =3D=3D file_slot)
+			io_dma_unmap(imu);
+	}
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
+	struct io_fixed_file *file_slot;
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
+	file_slot =3D io_fixed_file_slot(&ctx->file_table,
+			array_index_nospec(map.fd, ctx->nr_user_files));
+	if (!file_slot || !file_slot->file_ptr)
+		return -EBADF;
+
+	file =3D io_file_from_fixed(file_slot);
+	if (!(file->f_flags & O_DIRECT))
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
+		tag =3D file_dma_map(file, imu->bvec, imu->nr_bvecs);
+		if (IS_ERR(tag)) {
+			ret =3D PTR_ERR(tag);
+			goto err;
+		}
+
+		imu->dma_tag =3D tag;
+		imu->dma_file =3D file_slot;
+	}
+
+	return 0;
+err:
+	while (--i >=3D map.buf_start) {
+		struct io_mapped_ubuf *imu =3D ctx->user_bufs[i];
+
+		io_dma_unmap(imu);
+	}
+	return ret;
+}
+
 static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 			       void __user *arg, unsigned nr_args)
 	__releases(ctx->uring_lock)
@@ -3847,6 +3972,18 @@ static int __io_uring_register(struct io_ring_ctx =
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
index 32fc3da04e41..2793fd7d99d5 100644
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
index 1f10eecad4d7..ee5e5284203d 100644
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
@@ -809,12 +810,16 @@ void __io_sqe_files_unregister(struct io_ring_ctx *=
ctx)
 	int i;
=20
 	for (i =3D 0; i < ctx->nr_user_files; i++) {
-		struct file *file =3D io_file_from_index(&ctx->file_table, i);
+		struct io_fixed_file *f =3D io_fixed_file_slot(&ctx->file_table, i);
+		struct file *file;
=20
-		if (!file)
+		if (!f)
 			continue;
-		if (io_fixed_file_slot(&ctx->file_table, i)->file_ptr & FFS_SCM)
+		if (f->file_ptr & FFS_SCM)
 			continue;
+
+		io_dma_unmap_file(ctx, f);
+		file =3D io_file_from_fixed(f);
 		io_file_bitmap_clear(&ctx->file_table, i);
 		fput(file);
 	}
@@ -1282,6 +1287,7 @@ static int io_sqe_buffer_register(struct io_ring_ct=
x *ctx, struct iovec *iov,
 	imu->ubuf =3D (unsigned long) iov->iov_base;
 	imu->ubuf_end =3D imu->ubuf + iov->iov_len;
 	imu->nr_bvecs =3D nr_pages;
+	imu->dma_tag =3D NULL;
 	*pimu =3D imu;
 	ret =3D 0;
 done:
@@ -1356,9 +1362,8 @@ int io_sqe_buffers_register(struct io_ring_ctx *ctx=
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
@@ -1376,6 +1381,10 @@ int io_import_fixed(int ddir, struct iov_iter *ite=
r,
 	 * and advance us to the beginning.
 	 */
 	offset =3D buf_addr - imu->ubuf;
+	if (imu->dma_tag && file =3D=3D io_file_from_fixed(imu->dma_file)) {
+		iov_iter_dma_tag(iter, ddir, imu->dma_tag, offset, len);
+		return 0;
+	}
 	iov_iter_bvec(iter, ddir, imu->bvec, imu->nr_bvecs, offset + len);
=20
 	if (offset) {
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index f3a9a177941f..47a2942aa537 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -50,6 +50,8 @@ struct io_mapped_ubuf {
 	u64		ubuf_end;
 	unsigned int	nr_bvecs;
 	unsigned long	acct_pages;
+	void		*dma_tag;
+	struct io_fixed_file	*dma_file;
 	struct bio_vec	bvec[];
 };
=20
@@ -64,9 +66,11 @@ int io_queue_rsrc_removal(struct io_rsrc_data *data, u=
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
+void io_dma_unmap(struct io_mapped_ubuf *imu);
+void io_dma_unmap_file(struct io_ring_ctx *ctx, struct io_fixed_file *fi=
le_slot);
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

