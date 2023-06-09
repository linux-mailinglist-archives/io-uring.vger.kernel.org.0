Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7564F72A244
	for <lists+io-uring@lfdr.de>; Fri,  9 Jun 2023 20:31:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230299AbjFISbq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 9 Jun 2023 14:31:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230283AbjFISbp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 9 Jun 2023 14:31:45 -0400
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E72D35B3
        for <io-uring@vger.kernel.org>; Fri,  9 Jun 2023 11:31:37 -0700 (PDT)
Received: by mail-il1-x131.google.com with SMTP id e9e14a558f8ab-33dbad61311so1754135ab.0
        for <io-uring@vger.kernel.org>; Fri, 09 Jun 2023 11:31:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1686335496; x=1688927496;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HMTV1MvEKKYKZqTI3o6o/uh1NWf3aebrfhj1tOoeR18=;
        b=FFInjZKBs19vz4rK5wMPcC8oPROsFuOblpQIjNXWJNmbxNRCzJbTjCmJ5ujcpUbxpH
         ld7RH5H8wHiEbuGEQQt2r6XhpISFNSSGKbedbbaKBYcuceVEOlY1dqSBv470e8uwkKw0
         5//l4PugnknZZdSAkaFi3I5Ah5fvVYsFgCAENMWjExmaECEgm168sVViLa+MmEvR0R9Q
         G6I3JW0mAJGG6eFkeMVhAzN2dlc0xOuHiwO3MkW6k/nyfaTXeGHGj7yfgaMeUhj4CF2k
         TmO0zK3VRYstwGPv0egUR0aQJDD3DIXL61tHOOkhzA2c3sa1G8c/hp3HHxMrNLfhx0AZ
         LsTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686335496; x=1688927496;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HMTV1MvEKKYKZqTI3o6o/uh1NWf3aebrfhj1tOoeR18=;
        b=J7FWqbLtnpwhjGINJCfxGi1Qw9OqLVt42TekL/K21zODhUnh/6wh8kuDddEchBhy4L
         P6HGpRdY4Dp+/2rqm3kM71DUwP34jjZ2RdmqDkAL/dZJJwls5QcZbk66VELCyk0D/InR
         tOkedflslbg5JaXX/rcJumw00V8oqkDKREgW90Kjk1w65JOcc7RgTJgU1muprK1Oh6ig
         3pjInbUaVZA+fpZxeLK0rwotugKtL/EWur9eVUR6q8ad/1gx6lKo22vyX9zC2FtWQulI
         zWXgcCa89o00uAdzM5WtPWOwuPMfRvRmP3XjVTLE8VsMPMKs5jS+Ptc6BepvZfGz0hpb
         dwGQ==
X-Gm-Message-State: AC+VfDwSRSrV1YMbdktunQ69lya1TTdU3R2U2Gs3px09lyfCWYVCVvZT
        aO0QjsDOQBibAZYD5nF36fgDwxuFESYPWwusgac=
X-Google-Smtp-Source: ACHHUZ5pBGNdYFXHVBGTQJhND5SuYMtKgUzAMB4CFCxdvOsIhfH6Nf9wDXVYQrXcjI590ZVgdQMEHg==
X-Received: by 2002:a05:6602:1545:b0:774:93a3:f163 with SMTP id h5-20020a056602154500b0077493a3f163mr1814238iow.0.1686335495877;
        Fri, 09 Jun 2023 11:31:35 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id j4-20020a02a684000000b0040fb2ba7357sm1103124jam.4.2023.06.09.11.31.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jun 2023 11:31:35 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     andres@anarazel.de, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5/6] io_uring: add support for futex wake and wait
Date:   Fri,  9 Jun 2023 12:31:24 -0600
Message-Id: <20230609183125.673140-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230609183125.673140-1-axboe@kernel.dk>
References: <20230609183125.673140-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add support for FUTEX_WAKE/WAIT primitives.

IORING_OP_FUTEX_WAKE is mix of FUTEX_WAKE and FUTEX_WAKE_BITSET, as
it does support passing in a bitset.

Similary, IORING_OP_FUTEX_WAIT is a mix of FUTEX_WAIT and
FUTEX_WAIT_BITSET.

FUTEX_WAKE is straight forward, as we can always just do those inline.
FUTEX_WAIT will queue the futex with an appropriate callback, and
that callback will in turn post a CQE when it has triggered.

Cancelations are supported, both from the application point-of-view,
but also to be able to cancel pending waits if the ring exits before
all events have occurred.

This is just the barebones wait/wake support. Features to be added
later:

- We do not support the PI or requeue operations. The immediate use
  case don't need them, unsure if future support for these would be
  useful.

- Should we support futex wait with timeout? Not clear if this is
  necessary, as the usual io_uring linked timeouts could fill this
  purpose.

- Would be nice to support registered futexes, just like we do buffers.
  This would avoid mapping in user memory for each operation.

- Probably lots more that I just didn't think of.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/io_uring_types.h |   2 +
 include/uapi/linux/io_uring.h  |   3 +
 io_uring/Makefile              |   4 +-
 io_uring/cancel.c              |   5 +
 io_uring/cancel.h              |   4 +
 io_uring/futex.c               | 194 +++++++++++++++++++++++++++++++++
 io_uring/futex.h               |  26 +++++
 io_uring/io_uring.c            |   3 +
 io_uring/opdef.c               |  25 ++++-
 9 files changed, 264 insertions(+), 2 deletions(-)
 create mode 100644 io_uring/futex.c
 create mode 100644 io_uring/futex.h

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index f04ce513fadb..d796b578c129 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -273,6 +273,8 @@ struct io_ring_ctx {
 	struct io_wq_work_list	locked_free_list;
 	unsigned int		locked_free_nr;
 
+	struct hlist_head	futex_list;
+
 	const struct cred	*sq_creds;	/* cred used for __io_sq_thread() */
 	struct io_sq_data	*sq_data;	/* if using sq thread polling */
 
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index f222d263bc55..b1a151ab8150 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -65,6 +65,7 @@ struct io_uring_sqe {
 		__u32		xattr_flags;
 		__u32		msg_ring_flags;
 		__u32		uring_cmd_flags;
+		__u32		futex_flags;
 	};
 	__u64	user_data;	/* data to be passed back at completion time */
 	/* pack this to avoid bogus arm OABI complaints */
@@ -235,6 +236,8 @@ enum io_uring_op {
 	IORING_OP_URING_CMD,
 	IORING_OP_SEND_ZC,
 	IORING_OP_SENDMSG_ZC,
+	IORING_OP_FUTEX_WAIT,
+	IORING_OP_FUTEX_WAKE,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
diff --git a/io_uring/Makefile b/io_uring/Makefile
index 8cc8e5387a75..2e4779bc550c 100644
--- a/io_uring/Makefile
+++ b/io_uring/Makefile
@@ -7,5 +7,7 @@ obj-$(CONFIG_IO_URING)		+= io_uring.o xattr.o nop.o fs.o splice.o \
 					openclose.o uring_cmd.o epoll.o \
 					statx.o net.o msg_ring.o timeout.o \
 					sqpoll.o fdinfo.o tctx.o poll.o \
-					cancel.o kbuf.o rsrc.o rw.o opdef.o notif.o
+					cancel.o kbuf.o rsrc.o rw.o opdef.o \
+					notif.o
 obj-$(CONFIG_IO_WQ)		+= io-wq.o
+obj-$(CONFIG_FUTEX)		+= futex.o
diff --git a/io_uring/cancel.c b/io_uring/cancel.c
index b4f5dfacc0c3..280fb83145d3 100644
--- a/io_uring/cancel.c
+++ b/io_uring/cancel.c
@@ -15,6 +15,7 @@
 #include "tctx.h"
 #include "poll.h"
 #include "timeout.h"
+#include "futex.h"
 #include "cancel.h"
 
 struct io_cancel {
@@ -98,6 +99,10 @@ int io_try_cancel(struct io_uring_task *tctx, struct io_cancel_data *cd,
 	if (ret != -ENOENT)
 		return ret;
 
+	ret = io_futex_cancel(ctx, cd, issue_flags);
+	if (ret != -ENOENT)
+		return ret;
+
 	spin_lock(&ctx->completion_lock);
 	if (!(cd->flags & IORING_ASYNC_CANCEL_FD))
 		ret = io_timeout_cancel(ctx, cd);
diff --git a/io_uring/cancel.h b/io_uring/cancel.h
index 6a59ee484d0c..6a2a38df7159 100644
--- a/io_uring/cancel.h
+++ b/io_uring/cancel.h
@@ -1,4 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
+#ifndef IORING_CANCEL_H
+#define IORING_CANCEL_H
 
 #include <linux/io_uring_types.h>
 
@@ -21,3 +23,5 @@ int io_try_cancel(struct io_uring_task *tctx, struct io_cancel_data *cd,
 void init_hash_table(struct io_hash_table *table, unsigned size);
 
 int io_sync_cancel(struct io_ring_ctx *ctx, void __user *arg);
+
+#endif
diff --git a/io_uring/futex.c b/io_uring/futex.c
new file mode 100644
index 000000000000..a1d50145927a
--- /dev/null
+++ b/io_uring/futex.c
@@ -0,0 +1,194 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/fs.h>
+#include <linux/file.h>
+#include <linux/io_uring.h>
+
+#include <uapi/linux/io_uring.h>
+
+#include "../kernel/futex/futex.h"
+#include "io_uring.h"
+#include "futex.h"
+
+struct io_futex {
+	struct file	*file;
+	u32 __user	*uaddr;
+	int		futex_op;
+	unsigned int	futex_val;
+	unsigned int	futex_flags;
+	unsigned int	futex_mask;
+	bool		has_timeout;
+	ktime_t		timeout;
+};
+
+static void io_futex_complete(struct io_kiocb *req, struct io_tw_state *ts)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+
+	kfree(req->async_data);
+	io_tw_lock(ctx, ts);
+	hlist_del_init(&req->hash_node);
+	io_req_task_complete(req, ts);
+}
+
+static bool __io_futex_cancel(struct io_ring_ctx *ctx, struct io_kiocb *req)
+{
+	struct futex_q *q = req->async_data;
+
+	/* futex wake already done or in progress */
+	if (!futex_unqueue(q))
+		return false;
+
+	hlist_del_init(&req->hash_node);
+	io_req_set_res(req, -ECANCELED, 0);
+	req->io_task_work.func = io_futex_complete;
+	io_req_task_work_add(req);
+	return true;
+}
+
+int io_futex_cancel(struct io_ring_ctx *ctx, struct io_cancel_data *cd,
+		    unsigned int issue_flags)
+{
+	struct hlist_node *tmp;
+	struct io_kiocb *req;
+	int nr = 0;
+
+	if (cd->flags & (IORING_ASYNC_CANCEL_FD|IORING_ASYNC_CANCEL_FD_FIXED))
+		return 0;
+
+	io_ring_submit_lock(ctx, issue_flags);
+	hlist_for_each_entry_safe(req, tmp, &ctx->futex_list, hash_node) {
+		if (req->cqe.user_data != cd->data &&
+		    !(cd->flags & IORING_ASYNC_CANCEL_ANY))
+			continue;
+		if (__io_futex_cancel(ctx, req))
+			nr++;
+		nr++;
+		if (!(cd->flags & IORING_ASYNC_CANCEL_ALL))
+			break;
+	}
+	io_ring_submit_unlock(ctx, issue_flags);
+
+	if (nr)
+		return nr;
+
+	return -ENOENT;
+}
+
+bool io_futex_remove_all(struct io_ring_ctx *ctx, struct task_struct *task,
+			 bool cancel_all)
+{
+	struct hlist_node *tmp;
+	struct io_kiocb *req;
+	bool found = false;
+
+	lockdep_assert_held(&ctx->uring_lock);
+
+	hlist_for_each_entry_safe(req, tmp, &ctx->futex_list, hash_node) {
+		if (!io_match_task_safe(req, task, cancel_all))
+			continue;
+		__io_futex_cancel(ctx, req);
+		found = true;
+	}
+
+	return found;
+}
+
+int io_futex_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	struct io_futex *iof = io_kiocb_to_cmd(req, struct io_futex);
+	struct __kernel_timespec __user *utime;
+	struct timespec64 t;
+
+	iof->futex_op = READ_ONCE(sqe->fd);
+	iof->uaddr = u64_to_user_ptr(READ_ONCE(sqe->addr));
+	iof->futex_val = READ_ONCE(sqe->len);
+	iof->has_timeout = false;
+	iof->futex_mask = READ_ONCE(sqe->file_index);
+	utime = u64_to_user_ptr(READ_ONCE(sqe->addr2));
+	if (utime) {
+		if (get_timespec64(&t, utime))
+			return -EFAULT;
+		iof->timeout = timespec64_to_ktime(t);
+		iof->timeout = ktime_add_safe(ktime_get(), iof->timeout);
+		iof->has_timeout = true;
+	}
+	iof->futex_flags = READ_ONCE(sqe->futex_flags);
+	if (iof->futex_flags & FUTEX_CMD_MASK)
+		return -EINVAL;
+
+	return 0;
+}
+
+static void io_futex_wake_fn(struct wake_q_head *wake_q, struct futex_q *q)
+{
+	struct io_kiocb *req = q->wake_data;
+
+	__futex_unqueue(q);
+	smp_store_release(&q->lock_ptr, NULL);
+
+	io_req_set_res(req, 0, 0);
+	req->io_task_work.func = io_futex_complete;
+	io_req_task_work_add(req);
+}
+
+int io_futex_wait(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_futex *iof = io_kiocb_to_cmd(req, struct io_futex);
+	struct io_ring_ctx *ctx = req->ctx;
+	unsigned int flags = 0;
+	struct futex_q *q;
+	int ret;
+
+	if (!futex_op_to_flags(FUTEX_WAIT, iof->futex_flags, &flags)) {
+		ret = -ENOSYS;
+		goto done;
+	}
+
+	q = kmalloc(sizeof(*q), GFP_NOWAIT);
+	if (!q) {
+		ret = -ENOMEM;
+		goto done;
+	}
+
+	req->async_data = q;
+	*q = futex_q_init;
+	q->bitset = iof->futex_mask;
+	q->wake = io_futex_wake_fn;
+	q->wake_data = req;
+
+	io_ring_submit_lock(ctx, issue_flags);
+	hlist_add_head(&req->hash_node, &ctx->futex_list);
+	io_ring_submit_unlock(ctx, issue_flags);
+
+	ret = futex_queue_wait(q, iof->uaddr, flags, iof->futex_val);
+	if (ret)
+		goto done;
+
+	return IOU_ISSUE_SKIP_COMPLETE;
+done:
+	if (ret < 0)
+		req_set_fail(req);
+	io_req_set_res(req, ret, 0);
+	return IOU_OK;
+}
+
+int io_futex_wake(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_futex *iof = io_kiocb_to_cmd(req, struct io_futex);
+	unsigned int flags = 0;
+	int ret;
+
+	if (!futex_op_to_flags(FUTEX_WAKE, iof->futex_flags, &flags)) {
+		ret = -ENOSYS;
+		goto done;
+	}
+
+	ret = futex_wake(iof->uaddr, flags, iof->futex_val, iof->futex_mask);
+done:
+	if (ret < 0)
+		req_set_fail(req);
+	io_req_set_res(req, ret, 0);
+	return IOU_OK;
+}
diff --git a/io_uring/futex.h b/io_uring/futex.h
new file mode 100644
index 000000000000..16add2c069cc
--- /dev/null
+++ b/io_uring/futex.h
@@ -0,0 +1,26 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include "cancel.h"
+
+int io_futex_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
+int io_futex_wait(struct io_kiocb *req, unsigned int issue_flags);
+int io_futex_wake(struct io_kiocb *req, unsigned int issue_flags);
+
+#if defined(CONFIG_FUTEX)
+int io_futex_cancel(struct io_ring_ctx *ctx, struct io_cancel_data *cd,
+		    unsigned int issue_flags);
+bool io_futex_remove_all(struct io_ring_ctx *ctx, struct task_struct *task,
+			 bool cancel_all);
+#else
+static inline int io_futex_cancel(struct io_ring_ctx *ctx,
+				  struct io_cancel_data *cd,
+				  unsigned int issue_flags);
+{
+	return 0;
+}
+static inline bool io_futex_remove_all(struct io_ring_ctx *ctx,
+				       struct task_struct *task, bool cancel_all)
+{
+	return false;
+}
+#endif
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index a467064da1af..8270f37c312d 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -92,6 +92,7 @@
 #include "cancel.h"
 #include "net.h"
 #include "notif.h"
+#include "futex.h"
 
 #include "timeout.h"
 #include "poll.h"
@@ -336,6 +337,7 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	INIT_LIST_HEAD(&ctx->tctx_list);
 	ctx->submit_state.free_list.next = NULL;
 	INIT_WQ_LIST(&ctx->locked_free_list);
+	INIT_HLIST_HEAD(&ctx->futex_list);
 	INIT_DELAYED_WORK(&ctx->fallback_work, io_fallback_req_func);
 	INIT_WQ_LIST(&ctx->submit_state.compl_reqs);
 	return ctx;
@@ -3309,6 +3311,7 @@ static __cold bool io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 	ret |= io_cancel_defer_files(ctx, task, cancel_all);
 	mutex_lock(&ctx->uring_lock);
 	ret |= io_poll_remove_all(ctx, task, cancel_all);
+	ret |= io_futex_remove_all(ctx, task, cancel_all);
 	mutex_unlock(&ctx->uring_lock);
 	ret |= io_kill_timeouts(ctx, task, cancel_all);
 	if (task)
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index 3b9c6489b8b6..e6b03d7f82e5 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -33,6 +33,7 @@
 #include "poll.h"
 #include "cancel.h"
 #include "rw.h"
+#include "futex.h"
 
 static int io_no_issue(struct io_kiocb *req, unsigned int issue_flags)
 {
@@ -426,11 +427,26 @@ const struct io_issue_def io_issue_defs[] = {
 		.issue			= io_sendmsg_zc,
 #else
 		.prep			= io_eopnotsupp_prep,
+#endif
+	},
+	[IORING_OP_FUTEX_WAIT] = {
+#if defined(CONFIG_FUTEX)
+		.prep			= io_futex_prep,
+		.issue			= io_futex_wait,
+#else
+		.prep			= io_eopnotsupp_prep,
+#endif
+	},
+	[IORING_OP_FUTEX_WAKE] = {
+#if defined(CONFIG_FUTEX)
+		.prep			= io_futex_prep,
+		.issue			= io_futex_wake,
+#else
+		.prep			= io_eopnotsupp_prep,
 #endif
 	},
 };
 
-
 const struct io_cold_def io_cold_defs[] = {
 	[IORING_OP_NOP] = {
 		.name			= "NOP",
@@ -648,6 +664,13 @@ const struct io_cold_def io_cold_defs[] = {
 		.fail			= io_sendrecv_fail,
 #endif
 	},
+	[IORING_OP_FUTEX_WAIT] = {
+		.name			= "FUTEX_WAIT",
+	},
+
+	[IORING_OP_FUTEX_WAKE] = {
+		.name			= "FUTEX_WAKE",
+	},
 };
 
 const char *io_uring_get_opcode(u8 opcode)
-- 
2.39.2

