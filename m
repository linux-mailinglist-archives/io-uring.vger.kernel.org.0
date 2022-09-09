Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EE3B5B37B0
	for <lists+io-uring@lfdr.de>; Fri,  9 Sep 2022 14:24:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231219AbiIIMWf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 9 Sep 2022 08:22:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230473AbiIIMWG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 9 Sep 2022 08:22:06 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAACD8E0FB;
        Fri,  9 Sep 2022 05:21:04 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 9315656C77;
        Fri,  9 Sep 2022 12:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received:received; s=
        mta-01; t=1662726061; x=1664540462; bh=M6O3dhYY3Lt3H5OaOzak3bAki
        g6icOTAv5udRAX/Rjs=; b=kOdM5aBryAsJ5QM2sc5xLQe+4MlD0GyyeKcFsYIct
        saTdvLnxivA3o1sFFYq0DsStx/lzt/NPuT+7mpnetg0hU870CrP5JZVHPggKWMk4
        Pm9g9SeNVBPJK1us5/RXE0tq29VsaOnbcT60rEps0v3t9O+DUR7JW/o+bYzydqMc
        LY=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id pmBizxpKLmvS; Fri,  9 Sep 2022 15:21:01 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (T-EXCH-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id EEBAA56CF4;
        Fri,  9 Sep 2022 15:21:00 +0300 (MSK)
Received: from T-EXCH-09.corp.yadro.com (172.17.11.59) by
 T-EXCH-02.corp.yadro.com (172.17.10.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Fri, 9 Sep 2022 15:21:00 +0300
Received: from altair.lan (10.199.18.119) by T-EXCH-09.corp.yadro.com
 (172.17.11.59) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1118.9; Fri, 9 Sep 2022
 15:20:59 +0300
From:   "Alexander V. Buev" <a.buev@yadro.com>
To:     <linux-block@vger.kernel.org>
CC:     <io-uring@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
        "Christoph Hellwig" <hch@lst.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Mikhail Malygin <m.malygin@yadro.com>, <linux@yadro.com>,
        "Alexander V. Buev" <a.buev@yadro.com>
Subject: [PATCH v4 2/3] block: io-uring: add READV_PI/WRITEV_PI operations
Date:   Fri, 9 Sep 2022 15:20:39 +0300
Message-ID: <20220909122040.1098696-3-a.buev@yadro.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220909122040.1098696-1-a.buev@yadro.com>
References: <20220909122040.1098696-1-a.buev@yadro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.199.18.119]
X-ClientProxiedBy: T-EXCH-02.corp.yadro.com (172.17.10.102) To
 T-EXCH-09.corp.yadro.com (172.17.11.59)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Added new READV_PI/WRITEV_PI operations to io_uring.
Added new pi_addr & pi_len fields to SQE struct.
Added new IOCB_USE_PI flag to kiocb struct.
Use kiocb->private pointer to pass PI data
iterator to low layer.

Signed-off-by: Alexander V. Buev <a.buev@yadro.com>
---
 include/linux/fs.h            |   1 +
 include/uapi/linux/io_uring.h |   6 +
 include/uapi/linux/uio.h      |   3 +-
 io_uring/Makefile             |   3 +-
 io_uring/io_uring.c           |   2 +
 io_uring/opdef.c              |  27 ++
 io_uring/rw.h                 |   4 +
 io_uring/rw_pi.c              | 619 ++++++++++++++++++++++++++++++++++
 io_uring/rw_pi.h              |  34 ++
 9 files changed, 697 insertions(+), 2 deletions(-)
 create mode 100644 io_uring/rw_pi.c
 create mode 100644 io_uring/rw_pi.h

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 9eced4cc286e..a28b12a22750 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -337,6 +337,7 @@ enum rw_hint {
 #define IOCB_NOIO		(1 << 20)
 /* can use bio alloc cache */
 #define IOCB_ALLOC_CACHE	(1 << 21)
+#define IOCB_USE_PI		(1 << 22)
 
 struct kiocb {
 	struct file		*ki_filp;
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 6b83177fd41d..a4158e48cecb 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -80,6 +80,10 @@ struct io_uring_sqe {
 			__u64	addr3;
 			__u64	__pad2[1];
 		};
+		struct {
+			__u64	pi_addr;
+			__u32	pi_len;
+		};
 		/*
 		 * If the ring is initialized with IORING_SETUP_SQE128, then
 		 * this field is used for 80 bytes of arbitrary command data
@@ -206,6 +210,8 @@ enum io_uring_op {
 	IORING_OP_SOCKET,
 	IORING_OP_URING_CMD,
 	IORING_OP_SEND_ZC,
+	IORING_OP_READV_PI,
+	IORING_OP_WRITEV_PI,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
diff --git a/include/uapi/linux/uio.h b/include/uapi/linux/uio.h
index 059b1a9147f4..c9eaaa6cdb0f 100644
--- a/include/uapi/linux/uio.h
+++ b/include/uapi/linux/uio.h
@@ -23,9 +23,10 @@ struct iovec
 /*
  *	UIO_MAXIOV shall be at least 16 1003.1g (5.4.1.1)
  */
- 
+
 #define UIO_FASTIOV	8
 #define UIO_MAXIOV	1024
+#define UIO_FASTIOV_PI	1
 
 
 #endif /* _UAPI__LINUX_UIO_H */
diff --git a/io_uring/Makefile b/io_uring/Makefile
index 8cc8e5387a75..8c01546c2bcf 100644
--- a/io_uring/Makefile
+++ b/io_uring/Makefile
@@ -7,5 +7,6 @@ obj-$(CONFIG_IO_URING)		+= io_uring.o xattr.o nop.o fs.o splice.o \
 					openclose.o uring_cmd.o epoll.o \
 					statx.o net.o msg_ring.o timeout.o \
 					sqpoll.o fdinfo.o tctx.o poll.o \
-					cancel.o kbuf.o rsrc.o rw.o opdef.o notif.o
+					cancel.o kbuf.o rsrc.o rw.o opdef.o \
+					notif.o rw_pi.o
 obj-$(CONFIG_IO_WQ)		+= io-wq.o
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index f9be9b7eb654..1736a85f8c95 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3926,7 +3926,9 @@ static int __init io_uring_init(void)
 	BUILD_BUG_SQE_ELEM(44, __u16,  addr_len);
 	BUILD_BUG_SQE_ELEM(46, __u16,  __pad3[0]);
 	BUILD_BUG_SQE_ELEM(48, __u64,  addr3);
+	BUILD_BUG_SQE_ELEM(48, __u64,  pi_addr);
 	BUILD_BUG_SQE_ELEM_SIZE(48, 0, cmd);
+	BUILD_BUG_SQE_ELEM(56, __u32,  pi_len);
 	BUILD_BUG_SQE_ELEM(56, __u64,  __pad2);
 
 	BUILD_BUG_ON(sizeof(struct io_uring_files_update) !=
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index c61494e0a602..da2b12a44995 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -33,6 +33,7 @@
 #include "poll.h"
 #include "cancel.h"
 #include "rw.h"
+#include "rw_pi.h"
 
 static int io_no_issue(struct io_kiocb *req, unsigned int issue_flags)
 {
@@ -488,6 +489,32 @@ const struct io_op_def io_op_defs[] = {
 		.prep			= io_eopnotsupp_prep,
 #endif
 	},
+	[IORING_OP_READV_PI] = {
+		.needs_file		= 1,
+		.plug			= 1,
+		.audit_skip		= 1,
+		.ioprio			= 1,
+		.iopoll			= 1,
+		.async_size		= sizeof(struct io_async_rw_pi),
+		.name			= "READV_PI",
+		.prep			= io_prep_rw_pi,
+		.issue			= io_readv_pi,
+		.prep_async		= io_readv_pi_prep_async,
+		.cleanup		= io_readv_writev_cleanup,
+	},
+	[IORING_OP_WRITEV_PI] = {
+		.needs_file		= 1,
+		.plug			= 1,
+		.audit_skip		= 1,
+		.ioprio			= 1,
+		.iopoll			= 1,
+		.async_size		= sizeof(struct io_async_rw_pi),
+		.name			= "WRITEV_PI",
+		.prep			= io_prep_rw_pi,
+		.issue			= io_writev_pi,
+		.prep_async		= io_writev_pi_prep_async,
+		.cleanup		= io_readv_writev_cleanup,
+	},
 };
 
 const char *io_uring_get_opcode(u8 opcode)
diff --git a/io_uring/rw.h b/io_uring/rw.h
index 0204c3fcafa5..c00ece398540 100644
--- a/io_uring/rw.h
+++ b/io_uring/rw.h
@@ -1,4 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
+#ifndef IOU_RW_H
+#define IOU_RW_H
 
 #include <linux/pagemap.h>
 
@@ -21,3 +23,5 @@ int io_readv_prep_async(struct io_kiocb *req);
 int io_write(struct io_kiocb *req, unsigned int issue_flags);
 int io_writev_prep_async(struct io_kiocb *req);
 void io_readv_writev_cleanup(struct io_kiocb *req);
+
+#endif
diff --git a/io_uring/rw_pi.c b/io_uring/rw_pi.c
new file mode 100644
index 000000000000..58ea9fcd062c
--- /dev/null
+++ b/io_uring/rw_pi.c
@@ -0,0 +1,619 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/fs.h>
+#include <linux/file.h>
+#include <linux/blk-mq.h>
+#include <linux/mm.h>
+#include <linux/slab.h>
+#include <linux/fsnotify.h>
+#include <linux/poll.h>
+#include <linux/nospec.h>
+#include <linux/compat.h>
+#include <linux/io_uring.h>
+
+#include <uapi/linux/io_uring.h>
+
+#include "io_uring.h"
+#include "opdef.h"
+#include "kbuf.h"
+#include "rsrc.h"
+#include "rw_pi.h"
+
+#define io_kiocb_to_kiocb(req, type) \
+				(&((type *)io_kiocb_to_cmd(req, type))->kiocb)
+#define DATA	(0)
+#define PI	(1)
+
+struct io_rw_pi {
+	struct kiocb			kiocb;
+	u64				addr;
+	u32				nr_segs;
+	u32				nr_pi_segs;
+};
+
+static inline
+void io_rw_pi_state_iter_restore(struct io_rw_state *data, struct __io_rw_pi_state *pi)
+{
+	iov_iter_restore(&data->iter, &data->iter_state);
+	iov_iter_restore(&pi->iter, &pi->iter_state);
+}
+
+static inline
+void io_rw_pi_state_iter_save(struct io_rw_state *data, struct __io_rw_pi_state *pi)
+{
+	iov_iter_save_state(&data->iter, &data->iter_state);
+	iov_iter_save_state(&pi->iter, &pi->iter_state);
+}
+
+static inline bool io_file_supports_nowait(struct io_kiocb *req)
+{
+	return req->flags & REQ_F_SUPPORT_NOWAIT;
+}
+
+static inline void io_rw_done(struct kiocb *kiocb, ssize_t ret)
+{
+	switch (ret) {
+	case -EIOCBQUEUED:
+		break;
+	case -ERESTARTSYS:
+	case -ERESTARTNOINTR:
+	case -ERESTARTNOHAND:
+	case -ERESTART_RESTARTBLOCK:
+		/*
+		 * We can't just restart the syscall, since previously
+		 * submitted sqes may already be in progress. Just fail this
+		 * IO with EINTR.
+		 */
+		ret = -EINTR;
+		fallthrough;
+	default:
+		kiocb->ki_complete(kiocb, ret);
+	}
+}
+
+static inline loff_t *io_kiocb_update_pos(struct io_kiocb *req)
+{
+	struct io_rw_pi *rw = io_kiocb_to_cmd(req, struct io_rw_pi);
+
+	if (rw->kiocb.ki_pos != -1)
+		return &rw->kiocb.ki_pos;
+
+	if (!(req->file->f_mode & FMODE_STREAM)) {
+		req->flags |= REQ_F_CUR_POS;
+		rw->kiocb.ki_pos = req->file->f_pos;
+		return &rw->kiocb.ki_pos;
+	}
+
+	rw->kiocb.ki_pos = 0;
+	return NULL;
+}
+
+static void io_req_task_queue_reissue(struct io_kiocb *req)
+{
+	req->io_task_work.func = io_queue_iowq;
+	io_req_task_work_add(req);
+}
+
+static bool io_resubmit_prep(struct io_kiocb *req)
+{
+	struct io_async_rw_pi *arw = req->async_data;
+
+	if (!req_has_async_data(req))
+		return !io_req_prep_async(req);
+	io_rw_pi_state_iter_restore(&arw->data.s, &arw->pi.s);
+	return true;
+}
+
+static bool io_rw_should_reissue(struct io_kiocb *req)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+
+	if ((req->flags & REQ_F_NOWAIT) || (io_wq_current_is_worker() &&
+	    !(ctx->flags & IORING_SETUP_IOPOLL)))
+		return false;
+	/*
+	 * If ref is dying, we might be running poll reap from the exit work.
+	 * Don't attempt to reissue from that path, just let it fail with
+	 * -EAGAIN.
+	 */
+	if (percpu_ref_is_dying(&ctx->refs))
+		return false;
+	/*
+	 * Play it safe and assume not safe to re-import and reissue if we're
+	 * not in the original thread group (or in task context).
+	 */
+	if (!same_thread_group(req->task, current) || !in_task())
+		return false;
+	return true;
+}
+
+static bool __io_complete_rw_common(struct io_kiocb *req, long res)
+{
+	struct io_rw_pi *rw = io_kiocb_to_cmd(req, struct io_rw_pi);
+
+	if (rw->kiocb.ki_flags & IOCB_WRITE)
+		fsnotify_modify(req->file);
+	else
+		fsnotify_access(req->file);
+
+	if (unlikely(res != req->cqe.res)) {
+		if ((res == -EAGAIN || res == -EOPNOTSUPP) &&
+		    io_rw_should_reissue(req)) {
+			req->flags |= REQ_F_REISSUE | REQ_F_PARTIAL_IO;
+			return true;
+		}
+		req_set_fail(req);
+		req->cqe.res = res;
+	}
+	return false;
+}
+
+static void io_complete_rw(struct kiocb *kiocb, long res)
+{
+	struct io_rw_pi *rw = container_of(kiocb, struct io_rw_pi, kiocb);
+	struct io_kiocb *req = cmd_to_io_kiocb(rw);
+
+	if (__io_complete_rw_common(req, res))
+		return;
+	io_req_set_res(req, res, 0);
+	req->io_task_work.func = io_req_task_complete;
+	io_req_task_work_add(req);
+}
+
+static void io_complete_rw_iopoll(struct kiocb *kiocb, long res)
+{
+	struct io_rw_pi *rw = container_of(kiocb, struct io_rw_pi, kiocb);
+	struct io_kiocb *req = cmd_to_io_kiocb(rw);
+
+	if (unlikely(res != req->cqe.res)) {
+		if (res == -EAGAIN && io_rw_should_reissue(req)) {
+			req->flags |= REQ_F_REISSUE | REQ_F_PARTIAL_IO;
+			return;
+		}
+		req->cqe.res = res;
+	}
+
+	/* order with io_iopoll_complete() checking ->iopoll_completed */
+	smp_store_release(&req->iopoll_completed, 1);
+}
+
+static int kiocb_done(struct io_kiocb *req, ssize_t ret,
+		       unsigned int issue_flags)
+{
+	struct io_async_rw_pi *arw = req->async_data;
+	struct io_rw_pi *rw = io_kiocb_to_cmd(req, struct io_rw_pi);
+
+	/* add previously done IO, if any */
+	if (req_has_async_data(req) && arw->data.bytes_done > 0) {
+		if (ret < 0)
+			ret = arw->data.bytes_done;
+		else
+			ret += arw->data.bytes_done;
+	}
+
+	if (req->flags & REQ_F_CUR_POS)
+		req->file->f_pos = rw->kiocb.ki_pos;
+	if (ret >= 0 && (rw->kiocb.ki_complete == io_complete_rw)) {
+		if (!__io_complete_rw_common(req, ret)) {
+			io_req_set_res(req, req->cqe.res, 0);
+			return IOU_OK;
+		}
+	} else {
+		io_rw_done(&rw->kiocb, ret);
+	}
+
+	if (req->flags & REQ_F_REISSUE) {
+		req->flags &= ~REQ_F_REISSUE;
+		if (io_resubmit_prep(req))
+			io_req_task_queue_reissue(req);
+		else
+			io_req_task_queue_fail(req, ret);
+	}
+	return IOU_ISSUE_SKIP_COMPLETE;
+}
+
+int io_prep_rw_pi(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	struct io_rw_pi *rw = io_kiocb_to_cmd(req, struct io_rw_pi);
+	struct kiocb *kiocb = &rw->kiocb;
+	unsigned int ioprio;
+	int ret;
+
+	kiocb->ki_flags = 0;
+	ret = kiocb_set_rw_flags(kiocb, READ_ONCE(sqe->rw_flags));
+	if (unlikely(ret))
+		return ret;
+
+	kiocb->ki_pos = READ_ONCE(sqe->off);
+
+	ioprio = READ_ONCE(sqe->ioprio);
+	if (ioprio) {
+		ret = ioprio_check_cap(ioprio);
+		if (ret)
+			return ret;
+
+		kiocb->ki_ioprio = ioprio;
+	} else {
+		kiocb->ki_ioprio = get_current_ioprio();
+	}
+
+	req->imu = NULL;
+
+	/* save data iovec pointer & len */
+	rw->addr = (uintptr_t)READ_ONCE(sqe->addr);
+	rw->nr_segs = READ_ONCE(sqe->len);
+
+	/* save pi iovec pointer & len */
+	rw->kiocb.private = u64_to_user_ptr(READ_ONCE(sqe->pi_addr));
+	rw->nr_pi_segs = READ_ONCE(sqe->pi_len);
+
+	kiocb->ki_flags |= IOCB_USE_PI;
+
+	return 0;
+}
+
+
+static inline int
+io_import_iovecs_pi(int io_dir, struct io_kiocb *req, struct iovec **iovec,
+			struct io_rw_state *s_data, struct __io_rw_pi_state *s_pi)
+{
+	struct io_rw_pi *rw = io_kiocb_to_cmd(req, struct io_rw_pi);
+	struct iovec __user *uvec;
+	ssize_t ret;
+
+	/* data */
+	uvec = (struct iovec *)u64_to_user_ptr(rw->addr);
+	iovec[DATA] = s_data->fast_iov;
+	ret = __import_iovec(io_dir, uvec, rw->nr_segs,
+				UIO_FASTIOV, iovec + DATA,
+				&s_data->iter, req->ctx->compat);
+
+	if (unlikely(ret <= 0))
+		return (ret) ? ret : -EINVAL;
+	/* pi */
+	uvec = (struct iovec *)rw->kiocb.private;
+	iovec[PI] = s_pi->fast_iov;
+	ret = __import_iovec(io_dir, uvec, rw->nr_pi_segs,
+				UIO_FASTIOV_PI, iovec + PI,
+				&s_pi->iter, req->ctx->compat);
+	if (unlikely(ret <= 0)) {
+		if (iovec[DATA])
+			kfree(iovec[DATA]);
+		return (ret) ? ret : -EINVAL;
+	}
+
+	/* save states */
+	io_rw_pi_state_iter_save(s_data, s_pi);
+
+	return 0;
+}
+
+static inline void
+io_setup_async_state(struct io_rw_state *async_s, const struct io_rw_state *s)
+{
+	unsigned int iov_off = 0;
+
+	async_s->iter.iov = async_s->fast_iov;
+	if (s->iter.iov != s->fast_iov) {
+		iov_off = s->iter.iov - s->fast_iov;
+		async_s->iter.iov += iov_off;
+	}
+	if (async_s->fast_iov != s->fast_iov) {
+		memcpy(async_s->fast_iov + iov_off, s->fast_iov + iov_off,
+			       sizeof(struct iovec) * s->iter.nr_segs);
+	}
+}
+
+static int
+io_setup_async_rw_pi(struct io_kiocb *req, struct iovec * const *iovec,
+			struct io_rw_state *s_data,
+			struct __io_rw_pi_state *s_pi)
+{
+	struct io_async_rw_pi *arw;
+
+	if (req_has_async_data(req))
+		return 0;
+
+	if (io_alloc_async_data(req))
+		return -ENOMEM;
+
+	arw = req->async_data;
+
+	/* data */
+	arw->data.s.iter = s_data->iter;
+	arw->data.free_iovec = iovec[DATA];
+	arw->data.bytes_done = 0;
+
+	if (iovec[DATA])
+		req->flags |= REQ_F_NEED_CLEANUP;
+	else
+		io_setup_async_state(&arw->data.s, s_data);
+
+	/* pi */
+	arw->pi.s.iter = s_pi->iter;
+	arw->pi.free_iovec = iovec[PI];
+
+	if (iovec[PI])
+		req->flags |= REQ_F_NEED_CLEANUP;
+	else {
+		io_setup_async_state((struct io_rw_state *)&arw->pi.s,
+					(const struct io_rw_state *)s_pi);
+	}
+
+	/* save states */
+	io_rw_pi_state_iter_save(&arw->data.s, &arw->pi.s);
+
+	return 0;
+}
+
+static inline int io_rw_pi_prep_async(struct io_kiocb *req, int io_dir)
+{
+	int ret = 0;
+	struct io_async_rw_pi *arw = req->async_data;
+	struct iovec *iovec[2];
+
+	ret = io_import_iovecs_pi(io_dir, req, iovec,
+					&arw->data.s, &arw->pi.s);
+	if (unlikely(ret < 0))
+		return ret;
+
+	arw->data.bytes_done = 0;
+	arw->data.free_iovec = iovec[DATA];
+	arw->pi.free_iovec = iovec[PI];
+
+	if (iovec[DATA] || iovec[PI])
+		req->flags |= REQ_F_NEED_CLEANUP;
+
+	return 0;
+}
+
+
+int io_readv_pi_prep_async(struct io_kiocb *req)
+{
+	return io_rw_pi_prep_async(req, READ);
+}
+
+int io_writev_pi_prep_async(struct io_kiocb *req)
+{
+	return io_rw_pi_prep_async(req, WRITE);
+}
+
+static int io_rw_pi_init_file(struct io_kiocb *req, fmode_t mode)
+{
+	struct kiocb *kiocb = io_kiocb_to_kiocb(req, struct io_rw_pi);
+	struct io_ring_ctx *ctx = req->ctx;
+	struct file *file = req->file;
+	int flags;
+
+	if (unlikely(!file || !(file->f_mode & mode)))
+		return -EBADF;
+
+	if (unlikely(!S_ISBLK(file_inode(req->file)->i_mode)))
+		return -EINVAL;
+
+	if (unlikely(!(file->f_flags & O_DIRECT)))
+		return -EINVAL;
+
+	if (!io_req_ffs_set(req))
+		req->flags |= io_file_get_flags(file) << REQ_F_SUPPORT_NOWAIT_BIT;
+
+	flags = kiocb->ki_flags;
+	kiocb->ki_flags = iocb_flags(file);
+	kiocb->ki_flags |= flags;
+
+	/*
+	 * If the file is marked O_NONBLOCK, still allow retry for it if it
+	 * supports async. Otherwise it's impossible to use O_NONBLOCK files
+	 * reliably. If not, or it IOCB_NOWAIT is set, don't retry.
+	 */
+	if ((kiocb->ki_flags & IOCB_NOWAIT) ||
+	    ((file->f_flags & O_NONBLOCK) && !io_file_supports_nowait(req)))
+		req->flags |= REQ_F_NOWAIT;
+
+	if (ctx->flags & IORING_SETUP_IOPOLL) {
+		if (!(kiocb->ki_flags & IOCB_DIRECT) || !file->f_op->iopoll)
+			return -EOPNOTSUPP;
+
+		kiocb->ki_flags |= IOCB_HIPRI | IOCB_ALLOC_CACHE;
+		kiocb->ki_complete = io_complete_rw_iopoll;
+		req->iopoll_completed = 0;
+	} else {
+		if (kiocb->ki_flags & IOCB_HIPRI)
+			return -EINVAL;
+		kiocb->ki_complete = io_complete_rw;
+	}
+
+	return 0;
+}
+
+void io_readv_writev_pi_cleanup(struct io_kiocb *req)
+{
+	struct io_async_rw_pi *arw = req->async_data;
+
+	kfree(arw->data.free_iovec);
+	kfree(arw->pi.free_iovec);
+}
+
+int io_readv_pi(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_rw_pi_state s;
+	struct io_rw_state *s_data;
+	struct __io_rw_pi_state *s_pi;
+	struct iovec *iovec[2];
+	struct kiocb *kiocb = io_kiocb_to_kiocb(req, struct io_rw_pi);
+	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
+	ssize_t ret;
+	loff_t *ppos;
+
+	if (!req_has_async_data(req)) {
+		s_data = &s.data;
+		s_pi = &s.pi;
+		ret = io_import_iovecs_pi(READ, req, iovec, s_data, s_pi);
+		if (unlikely(ret < 0))
+			return ret;
+	} else {
+		struct io_async_rw_pi *arw = req->async_data;
+
+		iovec[DATA] = iovec[PI] = 0;
+		s_data = &arw->data.s;
+		s_pi = &arw->pi.s;
+		io_rw_pi_state_iter_restore(s_data, s_pi);
+	}
+	kiocb->private = &s_pi->iter;
+
+	ret = io_rw_pi_init_file(req, FMODE_READ);
+	if (unlikely(ret))
+		goto out_free;
+
+	req->cqe.res = iov_iter_count(&s_data->iter);
+	if (force_nonblock) {
+		/* If the file doesn't support async, just async punt */
+		if (unlikely(!io_file_supports_nowait(req))) {
+			ret = io_setup_async_rw_pi(req, iovec, s_data, s_pi);
+			return ret ?: -EAGAIN;
+		}
+		kiocb->ki_flags |= IOCB_NOWAIT;
+	} else {
+		/* Ensure we clear previously set non-block flag */
+		kiocb->ki_flags &= ~IOCB_NOWAIT;
+	}
+
+	ppos = io_kiocb_update_pos(req);
+
+	ret = rw_verify_area(READ, req->file, ppos, req->cqe.res);
+	if (unlikely(ret))
+		goto out_free;
+
+	if (likely(req->file->f_op->read_iter))
+		ret = call_read_iter(req->file, kiocb, &s_data->iter);
+	else
+		ret = -EINVAL;
+
+	if (ret == -EAGAIN || (req->flags & REQ_F_REISSUE)) {
+		req->flags &= ~REQ_F_REISSUE;
+
+		/* IOPOLL retry should happen for io-wq threads */
+		if (!force_nonblock && !(req->ctx->flags & IORING_SETUP_IOPOLL))
+			goto done;
+		/* no retry on NONBLOCK nor RWF_NOWAIT */
+		if (req->flags & REQ_F_NOWAIT)
+			goto done;
+		ret = 0;
+	} else if (ret == -EIOCBQUEUED) {
+		ret = IOU_ISSUE_SKIP_COMPLETE;
+		goto out_free;
+	}
+
+done:
+	/* it's faster to check here then delegate to kfree */
+	if (iovec[DATA])
+		kfree(iovec[DATA]);
+	if (iovec[PI])
+		kfree(iovec[PI]);
+	return kiocb_done(req, ret, issue_flags);
+out_free:
+	if (iovec[DATA])
+		kfree(iovec[DATA]);
+	if (iovec[PI])
+		kfree(iovec[PI]);
+	return ret;
+}
+
+int io_writev_pi(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_rw_pi_state s;
+	struct io_rw_state *s_data;
+	struct __io_rw_pi_state *s_pi;
+	struct iovec *iovec[2];
+	struct kiocb *kiocb = io_kiocb_to_kiocb(req, struct io_rw_pi);
+	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
+	ssize_t ret, ret2;
+	loff_t *ppos;
+
+	if (!req_has_async_data(req)) {
+		s_data = &s.data;
+		s_pi = &s.pi;
+		ret = io_import_iovecs_pi(WRITE, req, iovec, s_data, s_pi);
+		if (unlikely(ret < 0))
+			return ret;
+	} else {
+		struct io_async_rw_pi *arw = req->async_data;
+
+		iovec[DATA] = iovec[PI] = 0;
+		s_data = &arw->data.s;
+		s_pi = &arw->pi.s;
+		io_rw_pi_state_iter_restore(s_data, s_pi);
+	}
+	kiocb->private = &s_pi->iter;
+
+	ret = io_rw_pi_init_file(req, FMODE_WRITE);
+	if (unlikely(ret))
+		goto out_free;
+
+	req->cqe.res = iov_iter_count(&s_data->iter);
+
+	if (force_nonblock) {
+		/* If the file doesn't support async, just async punt */
+		if (unlikely(!io_file_supports_nowait(req)))
+			goto copy_iov;
+
+		kiocb->ki_flags |= IOCB_NOWAIT;
+	} else {
+		/* Ensure we clear previously set non-block flag */
+		kiocb->ki_flags &= ~IOCB_NOWAIT;
+	}
+
+	ppos = io_kiocb_update_pos(req);
+
+	ret = rw_verify_area(WRITE, req->file, ppos, req->cqe.res);
+	if (unlikely(ret))
+		goto out_free;
+
+	kiocb->ki_flags |= IOCB_WRITE;
+
+	if (likely(req->file->f_op->write_iter))
+		ret2 = call_write_iter(req->file, kiocb, &s_data->iter);
+	else
+		ret2 = -EINVAL;
+
+	if (req->flags & REQ_F_REISSUE) {
+		req->flags &= ~REQ_F_REISSUE;
+		ret2 = -EAGAIN;
+	}
+
+	/*
+	 * Raw bdev writes will return -EOPNOTSUPP for IOCB_NOWAIT. Just
+	 * retry them without IOCB_NOWAIT.
+	 */
+	if (ret2 == -EOPNOTSUPP && (kiocb->ki_flags & IOCB_NOWAIT))
+		ret2 = -EAGAIN;
+	/* no retry on NONBLOCK nor RWF_NOWAIT */
+	if (ret2 == -EAGAIN && (req->flags & REQ_F_NOWAIT))
+		goto done;
+	if (!force_nonblock || ret2 != -EAGAIN) {
+		if (ret2 == -EIOCBQUEUED) {
+			ret = IOU_ISSUE_SKIP_COMPLETE;
+			goto out_free;
+		}
+		/* IOPOLL retry should happen for io-wq threads */
+		if (ret2 == -EAGAIN && (req->ctx->flags & IORING_SETUP_IOPOLL))
+			goto copy_iov;
+
+done:
+		ret = kiocb_done(req, ret2, issue_flags);
+	} else {
+copy_iov:
+		io_rw_pi_state_iter_restore(s_data, s_pi);
+		ret = io_setup_async_rw_pi(req, iovec, s_data, s_pi);
+		return ret ?: -EAGAIN;
+	}
+out_free:
+	/* it's reportedly faster than delegating the null check to kfree() */
+	if (iovec[DATA])
+		kfree(iovec[DATA]);
+	if (iovec[PI])
+		kfree(iovec[PI]);
+	return ret;
+}
+
diff --git a/io_uring/rw_pi.h b/io_uring/rw_pi.h
new file mode 100644
index 000000000000..f635da982484
--- /dev/null
+++ b/io_uring/rw_pi.h
@@ -0,0 +1,34 @@
+// SPDX-License-Identifier: GPL-2.0
+#ifndef IOU_RW_PI_H
+#define IOU_RW_PI_H
+
+#include "rw.h"
+
+struct __io_rw_pi_state {
+	struct iov_iter			iter;
+	struct iov_iter_state		iter_state;
+	struct iovec			fast_iov[UIO_FASTIOV_PI];
+};
+
+struct io_rw_pi_state {
+	struct io_rw_state		data;
+	struct __io_rw_pi_state		pi;
+};
+
+struct __io_async_rw_pi {
+	const struct iovec		*free_iovec;
+	struct __io_rw_pi_state		s;
+};
+
+struct io_async_rw_pi {
+	struct io_async_rw		data;
+	struct __io_async_rw_pi		pi;
+};
+
+int io_prep_rw_pi(struct io_kiocb *req, const struct io_uring_sqe *sqe);
+int io_readv_pi(struct io_kiocb *req, unsigned int issue_flags);
+int io_readv_pi_prep_async(struct io_kiocb *req);
+int io_writev_pi(struct io_kiocb *req, unsigned int issue_flags);
+int io_writev_pi_prep_async(struct io_kiocb *req);
+void io_readv_writev_pi_cleanup(struct io_kiocb *req);
+#endif
-- 
2.30.2

