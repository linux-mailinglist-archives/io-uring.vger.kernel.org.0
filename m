Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0F3E6C7F38
	for <lists+io-uring@lfdr.de>; Fri, 24 Mar 2023 14:59:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231926AbjCXN7T (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Mar 2023 09:59:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231923AbjCXN7R (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Mar 2023 09:59:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 979181689F
        for <io-uring@vger.kernel.org>; Fri, 24 Mar 2023 06:58:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679666311;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xzZ+wuPBi9+dQS3sJDeNSKtl4V9pbm62rly4KXDbmfY=;
        b=fFb1e7I4YcYKK2wIEAhkz3WRupRNO2/7IlPG5ADvtjmQ7K8svyCWvVRucx6T4YlxOSCbxq
        ghHM9B/5e3vbUt80foLu3rYhLZZStl0xNyI+RtuYSE9Orcw6Llf3gZM7PBV+ShNe8SLLaR
        OnvsZdH0M325Tf6Zoh+HXmC9NGVRrWA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-246-dE6P3biwNJiV7AA7HcfGRg-1; Fri, 24 Mar 2023 09:58:29 -0400
X-MC-Unique: dE6P3biwNJiV7AA7HcfGRg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9A21B3828898;
        Fri, 24 Mar 2023 13:58:28 +0000 (UTC)
Received: from localhost (ovpn-8-20.pek2.redhat.com [10.72.8.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 41E6318EC7;
        Fri, 24 Mar 2023 13:58:26 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Bernd Schubert <bschubert@ddn.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V4 02/17] io_uring: add IORING_OP_FUSED_CMD
Date:   Fri, 24 Mar 2023 21:57:53 +0800
Message-Id: <20230324135808.855245-3-ming.lei@redhat.com>
In-Reply-To: <20230324135808.855245-1-ming.lei@redhat.com>
References: <20230324135808.855245-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add IORING_OP_FUSED_CMD, it is one special URING_CMD, which has to
be SQE128. The 1st SQE(master) is one 64byte URING_CMD, and the 2nd
64byte SQE(slave) is another normal 64byte OP. For any OP which needs
to support slave OP, io_issue_defs[op].fused_slave has to be set as 1,
and its ->issue() needs to retrieve buffer from master request's
fused_cmd_kbuf.

Follows the key points of the design/implementation:

1) The master uring command produces and provides immutable command
buffer(struct io_uring_bvec_buf) to the slave request, and the slave
OP can retrieve any part of this buffer by sqe->addr and sqe->len.

2) Master command is always completed after the slave request is
completed, so slave request can be thought as serving for master
command.

- slave request borrows master command's buffer(io_uring_bvec_buf), after
slave request is completed, the buffer is returned back to master request.

- This way also guarantees correct SQE order since the master
request uses slave request's LINK flag.

3) Master request completion is always notified to driver, so that driver
can know when the buffer is done with slave quest. This way is important
since io_uring_bvec_buf represents reference of device io command buffer,
and we have to gurantee that reference can not outlive the referent buffer,
so far which is represented by bvec.

4) kernel API of io_fused_cmd_start_slave_req is called by driver for
making the buffer of io_uring_bvec_buf and starting to submit slave
request with the provided buffer.

The motivation is for supporting zero copy for fuse/ublk, in which
the device holds IO request buffer, and IO handling is often normal
IO OP(fs, net, ..). With IORING_OP_FUSED_CMD, we can implement this kind
of zero copy easily & reliably.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 include/linux/io_uring.h       |  49 ++++++-
 include/linux/io_uring_types.h |  15 +++
 include/uapi/linux/io_uring.h  |   1 +
 io_uring/Makefile              |   2 +-
 io_uring/fused_cmd.c           | 233 +++++++++++++++++++++++++++++++++
 io_uring/fused_cmd.h           |  11 ++
 io_uring/io_uring.c            |  26 +++-
 io_uring/io_uring.h            |   3 +
 io_uring/opdef.c               |  12 ++
 io_uring/opdef.h               |   7 +
 10 files changed, 353 insertions(+), 6 deletions(-)
 create mode 100644 io_uring/fused_cmd.c
 create mode 100644 io_uring/fused_cmd.h

diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index 934e5dd4ccc0..45253a5b9fc2 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -4,6 +4,7 @@
 
 #include <linux/sched.h>
 #include <linux/xarray.h>
+#include <linux/bvec.h>
 #include <uapi/linux/io_uring.h>
 
 enum io_uring_cmd_flags {
@@ -20,6 +21,26 @@ enum io_uring_cmd_flags {
 	IO_URING_F_SQE128		= (1 << 8),
 	IO_URING_F_CQE32		= (1 << 9),
 	IO_URING_F_IOPOLL		= (1 << 10),
+
+	/* for FUSED_CMD only */
+	IO_URING_F_FUSED_BUF_DEST		= (1 << 11), /* slave writes to buffer */
+	IO_URING_F_FUSED_BUF_SRC		= (1 << 12), /* slave reads from buffer */
+	/* driver incapable of FUSED_CMD should fail cmd when seeing F_FUSED */
+	IO_URING_F_FUSED		= IO_URING_F_FUSED_BUF_DEST |
+		IO_URING_F_FUSED_BUF_SRC,
+};
+
+union io_uring_fused_cmd_data {
+	/*
+	 * In case of slave request IOSQE_CQE_SKIP_SUCCESS, return slave
+	 * result via master command; otherwise we simply return success
+	 * if buffer is provided, and slave request will return its result
+	 * via its CQE
+	 */
+	s32 slave_res;
+
+	/* fused cmd private, driver do not touch it */
+	struct io_kiocb *__slave;
 };
 
 struct io_uring_cmd {
@@ -33,10 +54,31 @@ struct io_uring_cmd {
 	};
 	u32		cmd_op;
 	u32		flags;
-	u8		pdu[32]; /* available inline for free use */
+
+	/* for fused command, the available pdu is a bit less */
+	union {
+		struct {
+			union io_uring_fused_cmd_data data;
+			u8	pdu[24]; /* available inline for free use */
+		} fused;
+		u8		pdu[32]; /* available inline for free use */
+	};
+};
+
+struct io_uring_bvec_buf {
+	unsigned long	len;
+	unsigned int	nr_bvecs;
+
+	/* offset in the 1st bvec */
+	unsigned int	offset;
+	const struct bio_vec	*bvec;
+	struct bio_vec	__bvec[];
 };
 
 #if defined(CONFIG_IO_URING)
+void io_fused_cmd_start_slave_req(struct io_uring_cmd *ioucmd, bool locked,
+		const struct io_uring_bvec_buf *imu,
+		void (*complete_tw_cb)(struct io_uring_cmd *));
 int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
 			      struct iov_iter *iter, void *ioucmd);
 void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret, ssize_t res2);
@@ -66,6 +108,11 @@ static inline void io_uring_free(struct task_struct *tsk)
 		__io_uring_free(tsk);
 }
 #else
+static inline void io_fused_cmd_start_slave_req(struct io_uring_cmd *ioucmd,
+		bool locked, const struct io_uring_bvec_buf *fused_cmd_kbuf,
+		unsigned int len, void (*complete_tw_cb)(struct io_uring_cmd *))
+{
+}
 static inline int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
 			      struct iov_iter *iter, void *ioucmd)
 {
diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index aab657cd2b77..22920d7b12a5 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -402,6 +402,7 @@ enum {
 	/* keep async read/write and isreg together and in order */
 	REQ_F_SUPPORT_NOWAIT_BIT,
 	REQ_F_ISREG_BIT,
+	REQ_F_FUSED_SLAVE_BIT,
 
 	/* not a real bit, just to check we're not overflowing the space */
 	__REQ_F_LAST_BIT,
@@ -471,6 +472,8 @@ enum {
 	REQ_F_CLEAR_POLLIN	= BIT_ULL(REQ_F_CLEAR_POLLIN_BIT),
 	/* hashed into ->cancel_hash_locked, protected by ->uring_lock */
 	REQ_F_HASH_LOCKED	= BIT_ULL(REQ_F_HASH_LOCKED_BIT),
+	/* slave request in fused cmd, won't be one uring cmd */
+	REQ_F_FUSED_SLAVE	= BIT_ULL(REQ_F_FUSED_SLAVE_BIT),
 };
 
 typedef void (*io_req_tw_func_t)(struct io_kiocb *req, bool *locked);
@@ -553,6 +556,18 @@ struct io_kiocb {
 		 * REQ_F_BUFFER_RING is set.
 		 */
 		struct io_buffer_list	*buf_list;
+
+		/*
+		 * store kernel (sub)buffer of fused master request which OP
+		 * is IORING_OP_FUSED_CMD
+		 */
+		const struct io_uring_bvec_buf *fused_cmd_kbuf;
+
+		/*
+		 * store fused command master request for fuse slave request,
+		 * which uses fuse master's io buffer for handling slave OP
+		 */
+		struct io_kiocb *fused_master_req;
 	};
 
 	union {
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 1d59c816a5b8..9762a2989747 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -223,6 +223,7 @@ enum io_uring_op {
 	IORING_OP_URING_CMD,
 	IORING_OP_SEND_ZC,
 	IORING_OP_SENDMSG_ZC,
+	IORING_OP_FUSED_CMD,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
diff --git a/io_uring/Makefile b/io_uring/Makefile
index 8cc8e5387a75..5301077e61c5 100644
--- a/io_uring/Makefile
+++ b/io_uring/Makefile
@@ -7,5 +7,5 @@ obj-$(CONFIG_IO_URING)		+= io_uring.o xattr.o nop.o fs.o splice.o \
 					openclose.o uring_cmd.o epoll.o \
 					statx.o net.o msg_ring.o timeout.o \
 					sqpoll.o fdinfo.o tctx.o poll.o \
-					cancel.o kbuf.o rsrc.o rw.o opdef.o notif.o
+					cancel.o kbuf.o rsrc.o rw.o opdef.o notif.o fused_cmd.o
 obj-$(CONFIG_IO_WQ)		+= io-wq.o
diff --git a/io_uring/fused_cmd.c b/io_uring/fused_cmd.c
new file mode 100644
index 000000000000..ff3921f6a5df
--- /dev/null
+++ b/io_uring/fused_cmd.c
@@ -0,0 +1,233 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/fs.h>
+#include <linux/file.h>
+#include <linux/mm.h>
+#include <linux/slab.h>
+#include <linux/io_uring.h>
+
+#include <uapi/linux/io_uring.h>
+
+#include "io_uring.h"
+#include "opdef.h"
+#include "rsrc.h"
+#include "uring_cmd.h"
+#include "fused_cmd.h"
+
+static bool io_fused_slave_valid(const struct io_uring_sqe *sqe, u8 op)
+{
+	unsigned int sqe_flags = READ_ONCE(sqe->flags);
+
+	if (op == IORING_OP_FUSED_CMD || op == IORING_OP_URING_CMD)
+		return false;
+
+	if (sqe_flags & REQ_F_BUFFER_SELECT)
+		return false;
+
+	if (!io_issue_defs[op].fused_slave)
+		return false;
+
+	return true;
+}
+
+static inline void io_fused_cmd_update_link_flags(struct io_kiocb *req,
+		const struct io_kiocb *slave)
+{
+	/*
+	 * We have to keep slave SQE in order, so update master link flags
+	 * with slave request's given master command isn't completed until
+	 * the slave request is done
+	 */
+	if (slave->flags & (REQ_F_LINK | REQ_F_HARDLINK))
+		req->flags |= REQ_F_LINK;
+}
+
+int io_fused_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+	__must_hold(&req->ctx->uring_lock)
+{
+	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
+	const struct io_uring_sqe *slave_sqe = sqe + 1;
+	struct io_ring_ctx *ctx = req->ctx;
+	struct io_kiocb *slave;
+	u8 slave_op;
+	int ret;
+
+	if (unlikely(!(ctx->flags & IORING_SETUP_SQE128)))
+		return -EINVAL;
+
+	if (unlikely(sqe->__pad1))
+		return -EINVAL;
+
+	ioucmd->flags = READ_ONCE(sqe->uring_cmd_flags);
+	if (unlikely(ioucmd->flags))
+		return -EINVAL;
+
+	slave_op = READ_ONCE(slave_sqe->opcode);
+	if (unlikely(!io_fused_slave_valid(slave_sqe, slave_op)))
+		return -EINVAL;
+
+	ioucmd->cmd = sqe->cmd;
+	ioucmd->cmd_op = READ_ONCE(sqe->cmd_op);
+	req->fused_cmd_kbuf = NULL;
+
+	/* take one extra reference for the slave request */
+	io_get_task_refs(1);
+
+	ret = -ENOMEM;
+	if (unlikely(!io_alloc_req(ctx, &slave)))
+		goto fail;
+
+	ret = io_init_slave_req(ctx, slave, slave_sqe);
+	if (unlikely(ret))
+		goto fail_free_req;
+
+	/*
+	 * The slave request won't be linked to io_uring submission link list,
+	 * so it can't be handled by IORING_OP_LINK_TIMEOUT, however, we can do
+	 * that on master command directly
+	 */
+	io_fused_cmd_update_link_flags(req, slave);
+
+	ioucmd->fused.data.__slave = slave;
+
+	return 0;
+
+fail_free_req:
+	io_free_req(slave);
+fail:
+	current->io_uring->cached_refs += 1;
+	return ret;
+}
+
+int io_fused_cmd(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
+	const struct io_kiocb *slave = ioucmd->fused.data.__slave;
+	int ret = -EINVAL;
+
+	/*
+	 * Pass buffer direction for driver to validate if the requested buffer
+	 * direction is legal
+	 */
+	if (io_issue_defs[slave->opcode].buf_dir)
+		issue_flags |= IO_URING_F_FUSED_BUF_DEST;
+	else
+		issue_flags |= IO_URING_F_FUSED_BUF_SRC;
+
+	ret = io_uring_cmd(req, issue_flags);
+	if (ret != IOU_ISSUE_SKIP_COMPLETE)
+		io_free_req(ioucmd->fused.data.__slave);
+
+	return ret;
+}
+
+int io_import_buf_for_slave(unsigned long buf_off, unsigned int len, int dir,
+		struct iov_iter *iter, struct io_kiocb *slave)
+{
+	struct io_kiocb *req = slave->fused_master_req;
+	const struct io_uring_bvec_buf *kbuf;
+	unsigned long offset;
+
+	if (unlikely(!(slave->flags & REQ_F_FUSED_SLAVE) || !req))
+		return -EINVAL;
+
+	if (unlikely(!req->fused_cmd_kbuf))
+		return -EINVAL;
+
+	/* req->fused_cmd_kbuf is immutable */
+	kbuf = req->fused_cmd_kbuf;
+	offset = kbuf->offset;
+
+	if (!kbuf->bvec)
+		return -EINVAL;
+
+	if (unlikely(buf_off > kbuf->len))
+		return -EFAULT;
+
+	if (unlikely(len > kbuf->len - buf_off))
+		return -EFAULT;
+
+	/* don't use io_import_fixed which doesn't support multipage bvec */
+	offset += buf_off;
+	iov_iter_bvec(iter, dir, kbuf->bvec, kbuf->nr_bvecs, offset + len);
+
+	if (offset)
+		iov_iter_advance(iter, offset);
+
+	return 0;
+}
+
+/*
+ * Called after slave request is completed,
+ *
+ * Return back master's fused_cmd kbuf, and notify master request by
+ * the saved callback.
+ */
+void io_fused_cmd_return_buf(struct io_kiocb *slave)
+{
+	struct io_kiocb *req = slave->fused_master_req;
+	struct io_uring_cmd *ioucmd;
+
+	if (unlikely(!req || !(slave->flags & REQ_F_FUSED_SLAVE)))
+		return;
+
+	/* return back the buffer */
+	slave->fused_master_req = NULL;
+	ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
+	ioucmd->fused.data.__slave = NULL;
+
+	/*
+	 * If slave OP skips CQE, return the result via master command; or
+	 * if slave request is failed, REQ_F_CQE_SKIP will be cleared, return
+	 * result too
+	 */
+	if ((slave->flags & REQ_F_CQE_SKIP) || slave->cqe.res < 0)
+		ioucmd->fused.data.slave_res = slave->cqe.res;
+	else
+		ioucmd->fused.data.slave_res = 0;
+	io_uring_cmd_complete_in_task(ioucmd, ioucmd->task_work_cb);
+}
+
+/*
+ * Called for starting slave request after master command prepared io buffer.
+ *
+ * The io buffer is represented by @fused_cmd_kbuf, which is read only for
+ * slave request, however slave request can retrieve any sub-buffer by its
+ * sqe->addr(offset) & sqe->len. For slave request, io buffer is imported
+ * by io_import_buf_for_slave().
+ *
+ * Slave request borrows master's io buffer for handling the slave operation,
+ * and the buffer is returned back via io_fused_cmd_return_buf after the slave
+ * request is completed. Meantime the master command is completed from
+ * io_fused_cmd_return_buf(). And driver gets completion notification by
+ * the passed callback of @complete_tw_cb.
+ */
+void io_fused_cmd_start_slave_req(struct io_uring_cmd *ioucmd, bool locked,
+		const struct io_uring_bvec_buf *fused_cmd_kbuf,
+		void (*complete_tw_cb)(struct io_uring_cmd *))
+{
+	struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
+	struct io_kiocb *slave = ioucmd->fused.data.__slave;
+
+	if (WARN_ON_ONCE(unlikely(!slave ||
+					!(slave->flags & REQ_F_FUSED_SLAVE))))
+		return;
+
+	/*
+	 * Once the fused slave request is completed and the buffer isn't be
+	 * used, the driver will be notified by callback of complete_tw_cb
+	 */
+	ioucmd->task_work_cb = complete_tw_cb;
+
+	/* now we get the buffer */
+	req->fused_cmd_kbuf = fused_cmd_kbuf;
+	slave->fused_master_req = req;
+
+	trace_io_uring_submit_sqe(slave, true);
+	if (locked)
+		io_req_task_submit(slave, &locked);
+	else
+		io_req_task_queue(slave);
+}
+EXPORT_SYMBOL_GPL(io_fused_cmd_start_slave_req);
diff --git a/io_uring/fused_cmd.h b/io_uring/fused_cmd.h
new file mode 100644
index 000000000000..0a3fc8c69870
--- /dev/null
+++ b/io_uring/fused_cmd.h
@@ -0,0 +1,11 @@
+// SPDX-License-Identifier: GPL-2.0
+#ifndef IOU_FUSED_CMD_H
+#define IOU_FUSED_CMD_H
+
+int io_fused_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
+int io_fused_cmd(struct io_kiocb *req, unsigned int issue_flags);
+void io_fused_cmd_return_buf(struct io_kiocb *slave);
+int io_import_buf_for_slave(unsigned long buf, unsigned int len, int dir,
+		struct iov_iter *iter, struct io_kiocb *slave);
+
+#endif
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 449508912a9c..e5e43637d313 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -92,6 +92,7 @@
 #include "cancel.h"
 #include "net.h"
 #include "notif.h"
+#include "fused_cmd.h"
 
 #include "timeout.h"
 #include "poll.h"
@@ -111,7 +112,7 @@
 
 #define IO_REQ_CLEAN_FLAGS (REQ_F_BUFFER_SELECTED | REQ_F_NEED_CLEANUP | \
 				REQ_F_POLLED | REQ_F_INFLIGHT | REQ_F_CREDS | \
-				REQ_F_ASYNC_DATA)
+				REQ_F_ASYNC_DATA | REQ_F_FUSED_SLAVE)
 
 #define IO_REQ_CLEAN_SLOW_FLAGS (REQ_F_REFCOUNT | REQ_F_LINK | REQ_F_HARDLINK |\
 				 IO_REQ_CLEAN_FLAGS)
@@ -971,6 +972,9 @@ static void __io_req_complete_post(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 
+	if (req->flags & REQ_F_FUSED_SLAVE)
+		io_fused_cmd_return_buf(req);
+
 	io_cq_lock(ctx);
 	if (!(req->flags & REQ_F_CQE_SKIP))
 		io_fill_cqe_req(ctx, req);
@@ -1855,6 +1859,8 @@ static void io_clean_op(struct io_kiocb *req)
 		spin_lock(&req->ctx->completion_lock);
 		io_put_kbuf_comp(req);
 		spin_unlock(&req->ctx->completion_lock);
+	} else if (req->flags & REQ_F_FUSED_SLAVE) {
+		io_fused_cmd_return_buf(req);
 	}
 
 	if (req->flags & REQ_F_NEED_CLEANUP) {
@@ -2163,8 +2169,8 @@ static void io_init_req_drain(struct io_kiocb *req)
 	}
 }
 
-static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
-		       const struct io_uring_sqe *sqe)
+static inline int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
+		const struct io_uring_sqe *sqe, bool slave)
 	__must_hold(&ctx->uring_lock)
 {
 	const struct io_issue_def *def;
@@ -2217,6 +2223,12 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 		}
 	}
 
+	if (slave) {
+		if (!def->fused_slave)
+		       return -EINVAL;
+		req->flags |= REQ_F_FUSED_SLAVE;
+	}
+
 	if (!def->ioprio && sqe->ioprio)
 		return -EINVAL;
 	if (!def->iopoll && (ctx->flags & IORING_SETUP_IOPOLL))
@@ -2257,6 +2269,12 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	return def->prep(req, sqe);
 }
 
+int io_init_slave_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
+		const struct io_uring_sqe *sqe)
+{
+	return io_init_req(ctx, req, sqe, true);
+}
+
 static __cold int io_submit_fail_init(const struct io_uring_sqe *sqe,
 				      struct io_kiocb *req, int ret)
 {
@@ -2301,7 +2319,7 @@ static inline int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	struct io_submit_link *link = &ctx->submit_state.link;
 	int ret;
 
-	ret = io_init_req(ctx, req, sqe);
+	ret = io_init_req(ctx, req, sqe, false);
 	if (unlikely(ret))
 		return io_submit_fail_init(sqe, req, ret);
 
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 2711865f1e19..637e12e4fb9f 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -78,6 +78,9 @@ bool __io_alloc_req_refill(struct io_ring_ctx *ctx);
 bool io_match_task_safe(struct io_kiocb *head, struct task_struct *task,
 			bool cancel_all);
 
+int io_init_slave_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
+		const struct io_uring_sqe *sqe);
+
 #define io_lockdep_assert_cq_locked(ctx)				\
 	do {								\
 		if (ctx->flags & IORING_SETUP_IOPOLL) {			\
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index cca7c5b55208..63b90e8e65f8 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -33,6 +33,7 @@
 #include "poll.h"
 #include "cancel.h"
 #include "rw.h"
+#include "fused_cmd.h"
 
 static int io_no_issue(struct io_kiocb *req, unsigned int issue_flags)
 {
@@ -428,6 +429,12 @@ const struct io_issue_def io_issue_defs[] = {
 		.prep			= io_eopnotsupp_prep,
 #endif
 	},
+	[IORING_OP_FUSED_CMD] = {
+		.needs_file		= 1,
+		.plug			= 1,
+		.prep			= io_fused_cmd_prep,
+		.issue			= io_fused_cmd,
+	},
 };
 
 
@@ -648,6 +655,11 @@ const struct io_cold_def io_cold_defs[] = {
 		.fail			= io_sendrecv_fail,
 #endif
 	},
+	[IORING_OP_FUSED_CMD] = {
+		.name			= "FUSED_CMD",
+		.async_size		= uring_cmd_pdu_size(1),
+		.prep_async		= io_uring_cmd_prep_async,
+	},
 };
 
 const char *io_uring_get_opcode(u8 opcode)
diff --git a/io_uring/opdef.h b/io_uring/opdef.h
index c22c8696e749..ab81c54e9cad 100644
--- a/io_uring/opdef.h
+++ b/io_uring/opdef.h
@@ -29,6 +29,13 @@ struct io_issue_def {
 	unsigned		iopoll_queue : 1;
 	/* opcode specific path will handle ->async_data allocation if needed */
 	unsigned		manual_alloc : 1;
+	/* can be slave op of fused command */
+	unsigned		fused_slave : 1;
+	/*
+	 * buffer direction, 0 : read from buffer, 1: write to buffer, used
+	 * for fused_slave only
+	*/
+	unsigned		buf_dir : 1;
 
 	int (*issue)(struct io_kiocb *, unsigned int);
 	int (*prep)(struct io_kiocb *, const struct io_uring_sqe *);
-- 
2.39.2

