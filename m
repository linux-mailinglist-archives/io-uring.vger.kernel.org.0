Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECB776D035E
	for <lists+io-uring@lfdr.de>; Thu, 30 Mar 2023 13:38:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231728AbjC3Lie (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Mar 2023 07:38:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231708AbjC3Lic (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Mar 2023 07:38:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E4E19753
        for <io-uring@vger.kernel.org>; Thu, 30 Mar 2023 04:37:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680176226;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DEe+vDwEwzlvXLXI1gYaM1J67EduYigxbE9AKFJD9iM=;
        b=DoZHgZ5r6KvT8sW8WIPQ70AKsxA5ohii9xEz275EqArZSoDK+CVhhIuX8CPKH+b6CP3QJ4
        F/vAjg3Kg+wgFRq6TrIpByyc4B6CTqzVAfBpmYpR/Cb+AxNGuFKcA+oK2Uqc9RKnc4vVh0
        LayjYeYTIVd2Mocw/zjq1YnIft+CaXY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-235-D-w5YyKCMXWvH1U7Fka--g-1; Thu, 30 Mar 2023 07:37:03 -0400
X-MC-Unique: D-w5YyKCMXWvH1U7Fka--g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7E57C185A78B;
        Thu, 30 Mar 2023 11:37:02 +0000 (UTC)
Received: from localhost (ovpn-8-19.pek2.redhat.com [10.72.8.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 835EC1121330;
        Thu, 30 Mar 2023 11:37:01 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Bernd Schubert <bschubert@ddn.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V6 04/17] io_uring: support providing buffer by IORING_OP_FUSED_CMD
Date:   Thu, 30 Mar 2023 19:36:17 +0800
Message-Id: <20230330113630.1388860-5-ming.lei@redhat.com>
In-Reply-To: <20230330113630.1388860-1-ming.lei@redhat.com>
References: <20230330113630.1388860-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add UAPI flag of IORING_FUSED_CMD_BUF so that primary command can provide
buffer to secondary OPs. And this is just one of fused command use cases,
and more use cases can be supported by passing different uring_command flags.

This way is like one plugin of IORING_OP_FUSED_CMD, and in future we
could add more plugins.

The primary command provides buffer to secondary OPs, and secondary OPs
can use the buffer in safe way because:

- the primary command is always completed after all secondary OPs
are completed
- the provided buffer has same lifetime with primary command
- buffer lifetime won't cross multiple OPs

The motivation is for supporting zero copy for fuse/ublk, in which
the device holds IO request buffer, and IO handling is often normal
IO OP(fs, net, ..). IORING_OP_FUSED_CMD/IORING_FUSED_CMD_BUF may help
to support zero copy for any userspace driver/device.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 include/linux/io_uring.h       |  26 +++++++
 include/linux/io_uring_types.h |   5 ++
 include/uapi/linux/io_uring.h  |   8 ++-
 io_uring/fused_cmd.c           | 124 ++++++++++++++++++++++++++++++++-
 io_uring/fused_cmd.h           |   7 ++
 io_uring/opdef.h               |   5 ++
 6 files changed, 172 insertions(+), 3 deletions(-)

diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index 1a7e93b20fbf..be5e00be5201 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -4,6 +4,7 @@
 
 #include <linux/sched.h>
 #include <linux/xarray.h>
+#include <linux/bvec.h>
 #include <uapi/linux/io_uring.h>
 
 enum io_uring_cmd_flags {
@@ -20,6 +21,23 @@ enum io_uring_cmd_flags {
 	IO_URING_F_SQE128		= (1 << 8),
 	IO_URING_F_CQE32		= (1 << 9),
 	IO_URING_F_IOPOLL		= (1 << 10),
+
+	/* for FUSED_CMD with IORING_FUSED_CMD_BUF only */
+	IO_URING_F_FUSED_BUF_DEST		= (1 << 11), /* secondary write to buffer */
+	IO_URING_F_FUSED_BUF_SRC		= (1 << 12), /* secondary read from buffer */
+	/* driver incapable of FUSED_CMD should fail cmd when seeing F_FUSED */
+	IO_URING_F_FUSED_BUF		= IO_URING_F_FUSED_BUF_DEST |
+		IO_URING_F_FUSED_BUF_SRC,
+};
+
+struct io_uring_bvec_buf {
+	unsigned long	len;
+	unsigned int	nr_bvecs;
+
+	/* offset in the 1st bvec */
+	unsigned int		offset;
+	const struct bio_vec	*bvec;
+	struct bio_vec		__bvec[];
 };
 
 union io_uring_fused_cmd_data {
@@ -50,6 +68,9 @@ struct io_uring_cmd {
 };
 
 #if defined(CONFIG_IO_URING)
+void io_fused_provide_buf_and_start(struct io_uring_cmd *cmd,
+		unsigned issue_flags, const struct io_uring_bvec_buf *buf,
+		void (*complete_tw_cb)(struct io_uring_cmd *, unsigned));
 int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
 			      struct iov_iter *iter, void *ioucmd);
 void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret, ssize_t res2,
@@ -80,6 +101,11 @@ static inline void io_uring_free(struct task_struct *tsk)
 		__io_uring_free(tsk);
 }
 #else
+static inline void io_fused_provide_buf_and_start(struct io_uring_cmd *cmd,
+		unsigned issue_flags, const struct io_uring_bvec_buf *buf,
+		void (*complete_tw_cb)(struct io_uring_cmd *, unsigned))
+{
+}
 static inline int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
 			      struct iov_iter *iter, void *ioucmd)
 {
diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index e7449d2d8f3c..9cff455bfe6f 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -562,6 +562,11 @@ struct io_kiocb {
 		 */
 		struct io_buffer_list	*buf_list;
 
+		/*
+		 * store kernel buffer provided by fused primary request
+		 */
+		const struct io_uring_bvec_buf *fused_cmd_kbuf;
+
 		/* store fused command's primary request for the secondary */
 		struct io_kiocb *fused_primary_req;
 	};
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index ee7d413e43fc..d200906c1a21 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -245,8 +245,14 @@ enum io_uring_op {
  * sqe->uring_cmd_flags
  * IORING_URING_CMD_FIXED	use registered buffer; pass this flag
  *				along with setting sqe->buf_index.
+ *
+ * IORING_FUSED_CMD_BUF		fused primary command provides buffer
+ *				for secondary requests which can retrieve
+ *				any sub-buffer with offset(sqe->addr) and
+ *				len(sqe->len)
  */
-#define IORING_URING_CMD_FIXED	(1U << 0)
+#define IORING_URING_CMD_FIXED		(1U << 0)
+#define IORING_FUSED_CMD_BUF		(1U << 1)
 
 
 /*
diff --git a/io_uring/fused_cmd.c b/io_uring/fused_cmd.c
index f964e69fa4aa..46e2e8640e30 100644
--- a/io_uring/fused_cmd.c
+++ b/io_uring/fused_cmd.c
@@ -25,6 +25,23 @@ static bool io_fused_secondary_valid(u8 op)
 	return true;
 }
 
+static int io_fused_prep_provide_buf(struct io_uring_cmd *ioucmd,
+		const struct io_uring_sqe *sqe)
+{
+	struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
+	unsigned int sqe_flags = READ_ONCE(sqe->flags);
+
+	/*
+	 * Primary command is for providing buffer, non-sense to
+	 * set buffer select any more
+	 */
+	if (sqe_flags & REQ_F_BUFFER_SELECT)
+		return -EINVAL;
+
+	req->fused_cmd_kbuf = NULL;
+	return 0;
+}
+
 int io_fused_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	__must_hold(&req->ctx->uring_lock)
 {
@@ -50,8 +67,14 @@ int io_fused_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return -EINVAL;
 
 	ioucmd->flags = READ_ONCE(sqe->uring_cmd_flags);
-	if (unlikely(ioucmd->flags))
-		return -EINVAL;
+
+	/* so far, only support plugin of providing buffer */
+	if (ioucmd->flags & IORING_FUSED_CMD_BUF)
+		ret = io_fused_prep_provide_buf(ioucmd, sqe);
+	else
+		ret = -EINVAL;
+	if (ret)
+		return ret;
 
 	if (unlikely(!io_get_secondary_sqe(ctx, &secondary_sqe)))
 		return -EINVAL;
@@ -88,8 +111,20 @@ int io_fused_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 int io_fused_cmd(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
+	const struct io_kiocb *secondary = ioucmd->fused.data.__secondary;
 	int ret = -EINVAL;
 
+	if (ioucmd->flags & IORING_FUSED_CMD_BUF) {
+		/*
+		 * Pass buffer direction for driver for validating if the
+		 * requested buffer direction is legal
+		 */
+		if (io_issue_defs[secondary->opcode].buf_dir)
+			issue_flags |= IO_URING_F_FUSED_BUF_DEST;
+		else
+			issue_flags |= IO_URING_F_FUSED_BUF_SRC;
+	}
+
 	ret = io_uring_cmd(req, issue_flags);
 	if (ret != IOU_ISSUE_SKIP_COMPLETE)
 		io_free_req(ioucmd->fused.data.__secondary);
@@ -117,3 +152,88 @@ void io_fused_cmd_complete_secondary(struct io_kiocb *secondary)
 
 	io_uring_cmd_complete_in_task(ioucmd, ioucmd->task_work_cb);
 }
+
+/* only for IORING_FUSED_CMD_BUF */
+int io_import_buf_from_fused(unsigned long buf_off, unsigned int len,
+		int dir, struct iov_iter *iter, struct io_kiocb *secondary)
+{
+	struct io_kiocb *req = secondary->fused_primary_req;
+	const struct io_uring_bvec_buf *kbuf;
+	struct io_uring_cmd *primary;
+	unsigned long offset;
+
+	if (unlikely(!(secondary->flags & REQ_F_FUSED_SECONDARY) || !req))
+		return -EINVAL;
+
+	if (unlikely(!req->fused_cmd_kbuf))
+		return -EINVAL;
+
+	primary = io_kiocb_to_cmd(req, struct io_uring_cmd);
+	if (unlikely(!(primary->flags & IORING_FUSED_CMD_BUF)))
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
+ * Called for starting secondary request after primary command prepared io
+ * buffer, only for IORING_FUSED_CMD_BUF
+ *
+ * Secondary request borrows primary's io buffer for handling the secondary
+ * operation, and the buffer is returned back via io_fused_complete_secondary
+ * after the secondary request is completed. Meantime the primary command is
+ * completed. And driver gets completion notification by the passed callback
+ * of @complete_tw_cb.
+ */
+void io_fused_provide_buf_and_start(struct io_uring_cmd *ioucmd,
+		unsigned issue_flags,
+		const struct io_uring_bvec_buf *fused_cmd_kbuf,
+		void (*complete_tw_cb)(struct io_uring_cmd *, unsigned))
+{
+	struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
+	struct io_kiocb *secondary = ioucmd->fused.data.__secondary;
+	struct io_tw_state ts = {
+		.locked = !(issue_flags & IO_URING_F_UNLOCKED),
+	};
+
+	if (unlikely(!(ioucmd->flags & IORING_FUSED_CMD_BUF)))
+		return;
+
+	if (WARN_ON_ONCE(unlikely(!secondary || !(secondary->flags &
+						REQ_F_FUSED_SECONDARY))))
+		return;
+
+	/*
+	 * Once the fused secondary request is completed and the buffer isn't be
+	 * used, the driver will be notified by callback of complete_tw_cb
+	 */
+	ioucmd->task_work_cb = complete_tw_cb;
+
+	/* now we get the buffer */
+	req->fused_cmd_kbuf = fused_cmd_kbuf;
+	secondary->fused_primary_req = req;
+
+	trace_io_uring_submit_sqe(secondary, true);
+	io_req_task_submit(secondary, &ts);
+}
+EXPORT_SYMBOL_GPL(io_fused_provide_buf_and_start);
diff --git a/io_uring/fused_cmd.h b/io_uring/fused_cmd.h
index 162a4d70b12e..fef491757356 100644
--- a/io_uring/fused_cmd.h
+++ b/io_uring/fused_cmd.h
@@ -5,5 +5,12 @@
 int io_fused_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_fused_cmd(struct io_kiocb *req, unsigned int issue_flags);
 void io_fused_cmd_complete_secondary(struct io_kiocb *secondary);
+int io_import_buf_from_fused(unsigned long buf_off, unsigned int len,
+		int dir, struct iov_iter *iter, struct io_kiocb *secondary);
+
+static inline bool io_req_use_fused_buf(struct io_kiocb *req)
+{
+	return (req->flags & REQ_F_FUSED_SECONDARY) && req->fused_primary_req;
+}
 
 #endif
diff --git a/io_uring/opdef.h b/io_uring/opdef.h
index feaf0ff90c5d..bded61ebcbfc 100644
--- a/io_uring/opdef.h
+++ b/io_uring/opdef.h
@@ -31,6 +31,11 @@ struct io_issue_def {
 	unsigned		manual_alloc : 1;
 	/* can be secondary op of fused command */
 	unsigned		fused_secondary : 1;
+	/*
+	 * buffer direction, 0 : read from buffer, 1: write to buffer, used
+	 * for fused_secondary only
+	 */
+	unsigned		buf_dir : 1;
 
 	int (*issue)(struct io_kiocb *, unsigned int);
 	int (*prep)(struct io_kiocb *, const struct io_uring_sqe *);
-- 
2.39.2

