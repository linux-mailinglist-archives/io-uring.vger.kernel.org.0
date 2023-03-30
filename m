Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D08A66D0355
	for <lists+io-uring@lfdr.de>; Thu, 30 Mar 2023 13:38:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbjC3LiZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Mar 2023 07:38:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231365AbjC3LiT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Mar 2023 07:38:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BB008A5A
        for <io-uring@vger.kernel.org>; Thu, 30 Mar 2023 04:37:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680176220;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VQi6njH9VN4yh3PTrkwsLfBw19YGg6a/qkL/QjHlhgw=;
        b=YRsbW993EXLbjoHuSGSQMhowbYnK1uVePlvvTYWsbW6SiUkczALz1kOqcEUlfoTsdm7brF
        xs9w+IpXWbPzfYRSP2bT5qDXOrRqiPqud9q1hs3FcdRZKXI+zzqLwhC+WYeWSu6NdpaP4Y
        c7qfXjJCKZ1/v1l9otg4FWNpdS+Cadw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-379-xeMwM1A4O1ilQ1xUzIEo6w-1; Thu, 30 Mar 2023 07:36:59 -0400
X-MC-Unique: xeMwM1A4O1ilQ1xUzIEo6w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5648F3C025C4;
        Thu, 30 Mar 2023 11:36:58 +0000 (UTC)
Received: from localhost (ovpn-8-19.pek2.redhat.com [10.72.8.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 042862166B33;
        Thu, 30 Mar 2023 11:36:56 +0000 (UTC)
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
Subject: [PATCH V6 03/17] io_uring: add generic IORING_OP_FUSED_CMD
Date:   Thu, 30 Mar 2023 19:36:16 +0800
Message-Id: <20230330113630.1388860-4-ming.lei@redhat.com>
In-Reply-To: <20230330113630.1388860-1-ming.lei@redhat.com>
References: <20230330113630.1388860-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Multiple requests submitted as one whole request logically, and the 1st one
is primary command(IORING_OP_FUSED_CMD), and the others are secondary
requests, which number can be retrieved from primary SQE.

Primary command is responsible for providing resources and submitting
secondary requests, which depends on primary command's resources, and
primary command won't be completed until all secondary requests are done.

The provided resource has same lifetime with primary command, and it
lifetime won't cross multiple OPs, and this way provides safe way for
secondary OPs to use the resource.

Add generic IORING_OP_FUSED_CMD for modeling this primary/secondary
relationship among requests.

So far, the motivation is for supporting ublk zero copy, but it is one
generic framework which could be used for other use cases.

This way actually provides one generic interface for doing something
efficiently:

1) offload complicated logic to userspace, such as one generic lvm

- one read IO request is coming to this lvm block device
- the kernel driver gets notified, and start to handle the read request
- the driver finds that mapping for this IO isn't cached, so wakeup userspace
daemon, which calls KV store or generic btree mapping API to get the mapped
offset/len, then call IORING_OP_FUSED_CMD to handle the read request in
zero copy style
- when IORING_OP_FUSED_CMD is completed, the read IO request is completed

2) decouple kernel subsystems
- subsystem A wants to use subsystem B's service
- subsystem B doesn't provide kernel internal APIs, since it may be
  hard to support, but anytime generic syscalls are provided for userspace
- subsystem A can notify userspace proxy to call IORING_OP_FUSED_CMD for
  using subsystem B's service in resource-sharing way, such as zero copy

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 include/linux/io_uring.h       |  15 ++++-
 include/linux/io_uring_types.h |   6 ++
 include/uapi/linux/io_uring.h  |  14 ++++
 io_uring/Makefile              |   2 +-
 io_uring/fused_cmd.c           | 119 +++++++++++++++++++++++++++++++++
 io_uring/fused_cmd.h           |   9 +++
 io_uring/io_uring.c            |  41 ++++++++++--
 io_uring/io_uring.h            |   5 ++
 io_uring/opdef.c               |  12 ++++
 io_uring/opdef.h               |   2 +
 10 files changed, 216 insertions(+), 9 deletions(-)
 create mode 100644 io_uring/fused_cmd.c
 create mode 100644 io_uring/fused_cmd.h

diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index 35b9328ca335..1a7e93b20fbf 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -22,6 +22,11 @@ enum io_uring_cmd_flags {
 	IO_URING_F_IOPOLL		= (1 << 10),
 };
 
+union io_uring_fused_cmd_data {
+	/* secondary list, fused cmd private, driver do not touch it */
+	struct io_kiocb *__secondary;
+};
+
 struct io_uring_cmd {
 	struct file	*file;
 	const void	*cmd;
@@ -33,7 +38,15 @@ struct io_uring_cmd {
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
 };
 
 #if defined(CONFIG_IO_URING)
diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index dd8ef886730b..e7449d2d8f3c 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -407,6 +407,7 @@ enum {
 	/* keep async read/write and isreg together and in order */
 	REQ_F_SUPPORT_NOWAIT_BIT,
 	REQ_F_ISREG_BIT,
+	REQ_F_FUSED_SECONDARY_BIT,
 
 	/* not a real bit, just to check we're not overflowing the space */
 	__REQ_F_LAST_BIT,
@@ -476,6 +477,8 @@ enum {
 	REQ_F_CLEAR_POLLIN	= BIT_ULL(REQ_F_CLEAR_POLLIN_BIT),
 	/* hashed into ->cancel_hash_locked, protected by ->uring_lock */
 	REQ_F_HASH_LOCKED	= BIT_ULL(REQ_F_HASH_LOCKED_BIT),
+	/* secondary request in fused cmd, won't be one uring cmd */
+	REQ_F_FUSED_SECONDARY	= BIT_ULL(REQ_F_FUSED_SECONDARY_BIT),
 };
 
 typedef void (*io_req_tw_func_t)(struct io_kiocb *req, struct io_tw_state *ts);
@@ -558,6 +561,9 @@ struct io_kiocb {
 		 * REQ_F_BUFFER_RING is set.
 		 */
 		struct io_buffer_list	*buf_list;
+
+		/* store fused command's primary request for the secondary */
+		struct io_kiocb *fused_primary_req;
 	};
 
 	union {
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index f8d14d1c58d3..ee7d413e43fc 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -73,6 +73,8 @@ struct io_uring_sqe {
 		__u16	buf_index;
 		/* for grouped buffer selection */
 		__u16	buf_group;
+		/* how many secondary normal SQEs following this fused SQE */
+		__u16	nr_secondary;
 	} __attribute__((packed));
 	/* personality to use, if used */
 	__u16	personality;
@@ -173,6 +175,16 @@ enum {
  */
 #define IORING_SETUP_DEFER_TASKRUN	(1U << 13)
 
+/*
+ * Multiple requests submitted as one whole request logically, and the 1st
+ * one is primary request, and the others are secondary requests, which number
+ * can be retrieved from primary SQE.
+ *
+ * Primary request is responsible for submitting secondary requests, and it
+ * won't be completed until all secondary requests are done.
+ */
+#define IORING_SETUP_FUSED_REQ		(1U << 14)
+
 enum io_uring_op {
 	IORING_OP_NOP,
 	IORING_OP_READV,
@@ -223,6 +235,7 @@ enum io_uring_op {
 	IORING_OP_URING_CMD,
 	IORING_OP_SEND_ZC,
 	IORING_OP_SENDMSG_ZC,
+	IORING_OP_FUSED_CMD,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
@@ -476,6 +489,7 @@ struct io_uring_params {
 #define IORING_FEAT_CQE_SKIP		(1U << 11)
 #define IORING_FEAT_LINKED_FILE		(1U << 12)
 #define IORING_FEAT_REG_REG_RING	(1U << 13)
+#define IORING_FEAT_FUSED_REQ		(1U << 14)
 
 /*
  * io_uring_register(2) opcodes and arguments
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
index 000000000000..f964e69fa4aa
--- /dev/null
+++ b/io_uring/fused_cmd.c
@@ -0,0 +1,119 @@
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
+#include "uring_cmd.h"
+#include "fused_cmd.h"
+
+static bool io_fused_secondary_valid(u8 op)
+{
+	if (op == IORING_OP_FUSED_CMD)
+		return false;
+
+	if (!io_issue_defs[op].fused_secondary)
+		return false;
+
+	return true;
+}
+
+int io_fused_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+	__must_hold(&req->ctx->uring_lock)
+{
+	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
+	const struct io_uring_sqe *secondary_sqe = NULL;
+	struct io_ring_ctx *ctx = req->ctx;
+	struct io_kiocb *secondary;
+	u8 secondary_op;
+	int ret;
+
+	if (!(ctx->flags & IORING_SETUP_FUSED_REQ))
+		return -EINVAL;
+
+	if (unlikely(sqe->__pad1))
+		return -EINVAL;
+
+	/*
+	 * Only support single secondary request, in future we may extend to
+	 * support multiple secondary requests, which can be covered by
+	 * multiple fused command now.
+	 */
+	if (unlikely(sqe->nr_secondary != 1))
+		return -EINVAL;
+
+	ioucmd->flags = READ_ONCE(sqe->uring_cmd_flags);
+	if (unlikely(ioucmd->flags))
+		return -EINVAL;
+
+	if (unlikely(!io_get_secondary_sqe(ctx, &secondary_sqe)))
+		return -EINVAL;
+
+	if (unlikely(!secondary_sqe))
+		return -EINVAL;
+
+	secondary_op = READ_ONCE(secondary_sqe->opcode);
+	if (unlikely(!io_fused_secondary_valid(secondary_op)))
+		return -EINVAL;
+
+	ioucmd->cmd = sqe->cmd;
+	ioucmd->cmd_op = READ_ONCE(sqe->cmd_op);
+
+	ret = -ENOMEM;
+	if (unlikely(!io_alloc_req(ctx, &secondary)))
+		goto fail;
+
+	ret = io_init_secondary_req(ctx, secondary, secondary_sqe,
+			REQ_F_FUSED_SECONDARY);
+	if (unlikely(ret))
+		goto fail_free_req;
+
+	ioucmd->fused.data.__secondary = secondary;
+
+	return 0;
+
+fail_free_req:
+	io_free_req(secondary);
+fail:
+	return ret;
+}
+
+int io_fused_cmd(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
+	int ret = -EINVAL;
+
+	ret = io_uring_cmd(req, issue_flags);
+	if (ret != IOU_ISSUE_SKIP_COMPLETE)
+		io_free_req(ioucmd->fused.data.__secondary);
+
+	return ret;
+}
+
+/*
+ * Called after secondary request is completed,
+ *
+ * Notify primary request by the saved callback that we are done
+ */
+void io_fused_cmd_complete_secondary(struct io_kiocb *secondary)
+{
+	struct io_kiocb *req = secondary->fused_primary_req;
+	struct io_uring_cmd *ioucmd;
+
+	if (unlikely(!req || !(secondary->flags & REQ_F_FUSED_SECONDARY)))
+		return;
+
+	/* notify primary command that we are done */
+	secondary->fused_primary_req = NULL;
+	ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
+	ioucmd->fused.data.__secondary = NULL;
+
+	io_uring_cmd_complete_in_task(ioucmd, ioucmd->task_work_cb);
+}
diff --git a/io_uring/fused_cmd.h b/io_uring/fused_cmd.h
new file mode 100644
index 000000000000..162a4d70b12e
--- /dev/null
+++ b/io_uring/fused_cmd.h
@@ -0,0 +1,9 @@
+// SPDX-License-Identifier: GPL-2.0
+#ifndef IOU_FUSED_CMD_H
+#define IOU_FUSED_CMD_H
+
+int io_fused_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
+int io_fused_cmd(struct io_kiocb *req, unsigned int issue_flags);
+void io_fused_cmd_complete_secondary(struct io_kiocb *secondary);
+
+#endif
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 25a940f0ab68..0aaf26bdc72a 100644
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
+				REQ_F_ASYNC_DATA | REQ_F_FUSED_SECONDARY)
 
 #define IO_REQ_CLEAN_SLOW_FLAGS (REQ_F_REFCOUNT | REQ_F_LINK | REQ_F_HARDLINK |\
 				 IO_REQ_CLEAN_FLAGS)
@@ -971,6 +972,9 @@ static void __io_req_complete_post(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 
+	if (req->flags & REQ_F_FUSED_SECONDARY)
+		io_fused_cmd_complete_secondary(req);
+
 	io_cq_lock(ctx);
 	if (!(req->flags & REQ_F_CQE_SKIP))
 		io_fill_cqe_req(ctx, req);
@@ -1855,6 +1859,8 @@ static void io_clean_op(struct io_kiocb *req)
 		spin_lock(&req->ctx->completion_lock);
 		io_put_kbuf_comp(req);
 		spin_unlock(&req->ctx->completion_lock);
+	} else if (req->flags & REQ_F_FUSED_SECONDARY) {
+		io_fused_cmd_complete_secondary(req);
 	}
 
 	if (req->flags & REQ_F_NEED_CLEANUP) {
@@ -2163,8 +2169,8 @@ static void io_init_req_drain(struct io_kiocb *req)
 	}
 }
 
-static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
-		       const struct io_uring_sqe *sqe)
+static inline int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
+		const struct io_uring_sqe *sqe, u64 secondary_flags)
 	__must_hold(&ctx->uring_lock)
 {
 	const struct io_issue_def *def;
@@ -2217,6 +2223,12 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 		}
 	}
 
+	if (secondary_flags) {
+		if (!def->fused_secondary)
+			return -EINVAL;
+		req->flags |= secondary_flags;
+	}
+
 	if (!def->ioprio && sqe->ioprio)
 		return -EINVAL;
 	if (!def->iopoll && (ctx->flags & IORING_SETUP_IOPOLL))
@@ -2257,6 +2269,12 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	return def->prep(req, sqe);
 }
 
+int io_init_secondary_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
+		const struct io_uring_sqe *sqe, u64 flags)
+{
+	return io_init_req(ctx, req, sqe, flags);
+}
+
 static __cold int io_submit_fail_init(const struct io_uring_sqe *sqe,
 				      struct io_kiocb *req, int ret)
 {
@@ -2301,7 +2319,7 @@ static inline int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	struct io_submit_link *link = &ctx->submit_state.link;
 	int ret;
 
-	ret = io_init_req(ctx, req, sqe);
+	ret = io_init_req(ctx, req, sqe, 0);
 	if (unlikely(ret))
 		return io_submit_fail_init(sqe, req, ret);
 
@@ -2396,7 +2414,8 @@ static void io_commit_sqring(struct io_ring_ctx *ctx)
  * used, it's important that those reads are done through READ_ONCE() to
  * prevent a re-load down the line.
  */
-static bool io_get_sqe(struct io_ring_ctx *ctx, const struct io_uring_sqe **sqe)
+static inline bool io_get_sqe(struct io_ring_ctx *ctx,
+		const struct io_uring_sqe **sqe)
 {
 	unsigned head, mask = ctx->sq_entries - 1;
 	unsigned sq_idx = ctx->cached_sq_head++ & mask;
@@ -2425,6 +2444,12 @@ static bool io_get_sqe(struct io_ring_ctx *ctx, const struct io_uring_sqe **sqe)
 	return false;
 }
 
+bool io_get_secondary_sqe(struct io_ring_ctx *ctx,
+		const struct io_uring_sqe **sqe)
+{
+	return io_get_sqe(ctx, sqe);
+}
+
 int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 	__must_hold(&ctx->uring_lock)
 {
@@ -3855,7 +3880,8 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
 			IORING_FEAT_POLL_32BITS | IORING_FEAT_SQPOLL_NONFIXED |
 			IORING_FEAT_EXT_ARG | IORING_FEAT_NATIVE_WORKERS |
 			IORING_FEAT_RSRC_TAGS | IORING_FEAT_CQE_SKIP |
-			IORING_FEAT_LINKED_FILE | IORING_FEAT_REG_REG_RING;
+			IORING_FEAT_LINKED_FILE | IORING_FEAT_REG_REG_RING |
+			IORING_FEAT_FUSED_REQ;
 
 	if (copy_to_user(params, p, sizeof(*p))) {
 		ret = -EFAULT;
@@ -3913,7 +3939,8 @@ static long io_uring_setup(u32 entries, struct io_uring_params __user *params)
 			IORING_SETUP_R_DISABLED | IORING_SETUP_SUBMIT_ALL |
 			IORING_SETUP_COOP_TASKRUN | IORING_SETUP_TASKRUN_FLAG |
 			IORING_SETUP_SQE128 | IORING_SETUP_CQE32 |
-			IORING_SETUP_SINGLE_ISSUER | IORING_SETUP_DEFER_TASKRUN))
+			IORING_SETUP_SINGLE_ISSUER | IORING_SETUP_DEFER_TASKRUN |
+			IORING_SETUP_FUSED_REQ))
 		return -EINVAL;
 
 	return io_uring_create(entries, &p, params);
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index c33f719731ac..0a6fb37489b0 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -78,6 +78,11 @@ bool __io_alloc_req_refill(struct io_ring_ctx *ctx);
 bool io_match_task_safe(struct io_kiocb *head, struct task_struct *task,
 			bool cancel_all);
 
+bool io_get_secondary_sqe(struct io_ring_ctx *ctx,
+		const struct io_uring_sqe **sqe);
+int io_init_secondary_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
+		const struct io_uring_sqe *sqe, u64 flags);
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
index c22c8696e749..feaf0ff90c5d 100644
--- a/io_uring/opdef.h
+++ b/io_uring/opdef.h
@@ -29,6 +29,8 @@ struct io_issue_def {
 	unsigned		iopoll_queue : 1;
 	/* opcode specific path will handle ->async_data allocation if needed */
 	unsigned		manual_alloc : 1;
+	/* can be secondary op of fused command */
+	unsigned		fused_secondary : 1;
 
 	int (*issue)(struct io_kiocb *, unsigned int);
 	int (*prep)(struct io_kiocb *, const struct io_uring_sqe *);
-- 
2.39.2

