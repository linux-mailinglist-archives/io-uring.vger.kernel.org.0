Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C37F574F93A
	for <lists+io-uring@lfdr.de>; Tue, 11 Jul 2023 22:44:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230295AbjGKUoK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 11 Jul 2023 16:44:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230305AbjGKUoJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 11 Jul 2023 16:44:09 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4A971734
        for <io-uring@vger.kernel.org>; Tue, 11 Jul 2023 13:44:06 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id d2e1a72fcca58-66d6a9851f3so980767b3a.0
        for <io-uring@vger.kernel.org>; Tue, 11 Jul 2023 13:44:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689108245; x=1691700245;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4n2XJYve3gudseqRv7072PVt+VBZ9vLHlAyLPSwsN/I=;
        b=hoqlSJMXDZRjzpvMprCZFtEPTuYFxntpTMkogVqVpJuYzu8Z7VT4qsPYmgexTPgYf1
         91L7Ks/8w2OrPNdC+VctUI+jIEDikGki82svmKpbv0WvfqCR40J5LPHMc0hYj3FhTEbb
         0WbF5XbluoHDZ6RqEFwHA1YMcxM8rbapIIi5iHBiGXT3oDIQ6T7UiftevGB9Z2TpRc8J
         WsAjaSeSY1+pF0GoZ3YtIy75LmKD+WnbbObBSPPXWaFNUnTbe8uZRapkkvgsagApRp6l
         m67C1BAzGlrmly7Vbjjw8uKBLGPdCoLxB9Gufo+KD4ODCfLxziMEo+K+pVMsFaLScI7/
         /kUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689108245; x=1691700245;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4n2XJYve3gudseqRv7072PVt+VBZ9vLHlAyLPSwsN/I=;
        b=UMqdvvxN16Q3aIXrdteAGWpgr30qN/E9Gumnz9imDmHoKW3XFlqcxGMsdlZL2Nb4ql
         Axbs+WS3XJuB5VaZWn9fOncwXXFimovhWOiwd0P2r6XwyGNO2yccfkZvL82u7T8cZXEM
         AN+f0Vf84ro6BB8SZfdS0pWojmP/JA/6F65CsU5SsVkRFWQ0Zv2NvQ++B8t2Rq+vIObk
         iSaqhZRmwS3Fiyaab0lg9+8tiarw9/Y8mYRWVbLdaq3QdM6xkcoT6GzY8LtMI7Klscq6
         b6N0twBE7S1cYLqn5Eo94U01zkmqpeo/OKuVJqYHo1UVlcdlly1fMA1Ql38c6VRaqPVY
         +sJg==
X-Gm-Message-State: ABy/qLZ9/hqcNQXzftwYZHyq0OxQYmiBq880ucgJh28vuGPZsBemGqqW
        GwdGOzF6408f1vOuti6M8MZyWtU/mJTSAC0r+CM=
X-Google-Smtp-Source: APBJJlE4LNVpMmixgzJr9gZpxGsYoLsbC6xiug0URkD++caxIcUtwzXVNjRxNFEYXRn/HKO4NsRg/A==
X-Received: by 2002:a05:6a00:308f:b0:677:bb4c:c321 with SMTP id bh15-20020a056a00308f00b00677bb4cc321mr16851831pfb.0.1689108245363;
        Tue, 11 Jul 2023 13:44:05 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id f7-20020aa78b07000000b00640ddad2e0dsm2124461pfd.47.2023.07.11.13.44.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jul 2023 13:44:04 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     brauner@kernel.org, arnd@arndb.de, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5/5] io_uring: add IORING_OP_WAITID support
Date:   Tue, 11 Jul 2023 14:43:52 -0600
Message-Id: <20230711204352.214086-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230711204352.214086-1-axboe@kernel.dk>
References: <20230711204352.214086-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This adds support for an async version of waitid(2), in a fully async
version. If an event isn't immediately available, wait for a callback
to trigger a retry.

The format of the sqe is as follows:

sqe->len		The 'which', the idtype being queried/waited for.
sqe->fd			The 'pid' (or id) being waited for.
sqe->file_index		The 'options' being set.
sqe->addr2		A pointer to siginfo_t, if any, being filled in.

buf_index, add3, and waitid_flags are reserved/unused for now.
waitid_flags will be used for options for this request type. One
interesting use case may be to add multi-shot support, so that the
request stays armed and posts a notification every time a monitored
process state change occurs.

Note that this does not support rusage, on Arnd's recommendation.

See the waitid(2) man page for details on the arguments.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/io_uring_types.h |   2 +
 include/uapi/linux/io_uring.h  |   2 +
 io_uring/Makefile              |   2 +-
 io_uring/cancel.c              |   5 +
 io_uring/io_uring.c            |   3 +
 io_uring/opdef.c               |   9 ++
 io_uring/waitid.c              | 271 +++++++++++++++++++++++++++++++++
 io_uring/waitid.h              |  15 ++
 8 files changed, 308 insertions(+), 1 deletion(-)
 create mode 100644 io_uring/waitid.c
 create mode 100644 io_uring/waitid.h

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index a7f03d8d879f..598553877fc2 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -276,6 +276,8 @@ struct io_ring_ctx {
 	struct hlist_head	futex_list;
 	struct io_alloc_cache	futex_cache;
 
+	struct hlist_head	waitid_list;
+
 	const struct cred	*sq_creds;	/* cred used for __io_sq_thread() */
 	struct io_sq_data	*sq_data;	/* if using sq thread polling */
 
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 420f38675769..8fca2cffc343 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -66,6 +66,7 @@ struct io_uring_sqe {
 		__u32		msg_ring_flags;
 		__u32		uring_cmd_flags;
 		__u32		futex_flags;
+		__u32		waitid_flags;
 	};
 	__u64	user_data;	/* data to be passed back at completion time */
 	/* pack this to avoid bogus arm OABI complaints */
@@ -239,6 +240,7 @@ enum io_uring_op {
 	IORING_OP_FUTEX_WAIT,
 	IORING_OP_FUTEX_WAKE,
 	IORING_OP_FUTEX_WAITV,
+	IORING_OP_WAITID,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
diff --git a/io_uring/Makefile b/io_uring/Makefile
index 2e4779bc550c..e5be47e4fc3b 100644
--- a/io_uring/Makefile
+++ b/io_uring/Makefile
@@ -8,6 +8,6 @@ obj-$(CONFIG_IO_URING)		+= io_uring.o xattr.o nop.o fs.o splice.o \
 					statx.o net.o msg_ring.o timeout.o \
 					sqpoll.o fdinfo.o tctx.o poll.o \
 					cancel.o kbuf.o rsrc.o rw.o opdef.o \
-					notif.o
+					notif.o waitid.o
 obj-$(CONFIG_IO_WQ)		+= io-wq.o
 obj-$(CONFIG_FUTEX)		+= futex.o
diff --git a/io_uring/cancel.c b/io_uring/cancel.c
index 3dba8ccb1cd8..a01f3f41012b 100644
--- a/io_uring/cancel.c
+++ b/io_uring/cancel.c
@@ -16,6 +16,7 @@
 #include "poll.h"
 #include "timeout.h"
 #include "futex.h"
+#include "waitid.h"
 #include "cancel.h"
 
 struct io_cancel {
@@ -124,6 +125,10 @@ int io_try_cancel(struct io_uring_task *tctx, struct io_cancel_data *cd,
 	if (ret != -ENOENT)
 		return ret;
 
+	ret = io_waitid_cancel(ctx, cd, issue_flags);
+	if (ret != -ENOENT)
+		return ret;
+
 	spin_lock(&ctx->completion_lock);
 	if (!(cd->flags & IORING_ASYNC_CANCEL_FD))
 		ret = io_timeout_cancel(ctx, cd);
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 67ff148bc394..6d99d51b84e6 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -93,6 +93,7 @@
 #include "net.h"
 #include "notif.h"
 #include "futex.h"
+#include "waitid.h"
 
 #include "timeout.h"
 #include "poll.h"
@@ -336,6 +337,7 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	ctx->submit_state.free_list.next = NULL;
 	INIT_WQ_LIST(&ctx->locked_free_list);
 	INIT_HLIST_HEAD(&ctx->futex_list);
+	INIT_HLIST_HEAD(&ctx->waitid_list);
 	INIT_DELAYED_WORK(&ctx->fallback_work, io_fallback_req_func);
 	INIT_WQ_LIST(&ctx->submit_state.compl_reqs);
 	return ctx;
@@ -3259,6 +3261,7 @@ static __cold bool io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 	mutex_lock(&ctx->uring_lock);
 	ret |= io_poll_remove_all(ctx, task, cancel_all);
 	ret |= io_futex_remove_all(ctx, task, cancel_all);
+	ret |= io_waitid_remove_all(ctx, task, cancel_all);
 	mutex_unlock(&ctx->uring_lock);
 	ret |= io_kill_timeouts(ctx, task, cancel_all);
 	if (task)
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index 2034acfe10d0..2fbdf6a6c24a 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -34,6 +34,7 @@
 #include "cancel.h"
 #include "rw.h"
 #include "futex.h"
+#include "waitid.h"
 
 static int io_no_issue(struct io_kiocb *req, unsigned int issue_flags)
 {
@@ -453,6 +454,10 @@ const struct io_issue_def io_issue_defs[] = {
 		.prep			= io_eopnotsupp_prep,
 #endif
 	},
+	[IORING_OP_WAITID] = {
+		.prep			= io_waitid_prep,
+		.issue			= io_waitid,
+	},
 };
 
 const struct io_cold_def io_cold_defs[] = {
@@ -681,6 +686,10 @@ const struct io_cold_def io_cold_defs[] = {
 	[IORING_OP_FUTEX_WAITV] = {
 		.name			= "FUTEX_WAITV",
 	},
+	[IORING_OP_WAITID] = {
+		.name			= "WAITID",
+		.async_size		= sizeof(struct io_waitid_async),
+	},
 };
 
 const char *io_uring_get_opcode(u8 opcode)
diff --git a/io_uring/waitid.c b/io_uring/waitid.c
new file mode 100644
index 000000000000..8d6ac22113dd
--- /dev/null
+++ b/io_uring/waitid.c
@@ -0,0 +1,271 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Support for async notification of waitid
+ */
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/fs.h>
+#include <linux/file.h>
+#include <linux/io_uring.h>
+
+#include <uapi/linux/io_uring.h>
+
+#include "io_uring.h"
+#include "cancel.h"
+#include "waitid.h"
+#include "../kernel/exit.h"
+
+struct io_waitid {
+	struct file *file;
+	int which;
+	pid_t upid;
+	int options;
+	struct wait_queue_head *head;
+	struct siginfo __user *infop;
+	struct waitid_info info;
+};
+
+static void io_waitid_free(struct io_kiocb *req)
+{
+	struct io_waitid_async *iwa = req->async_data;
+
+	put_pid(iwa->wo.wo_pid);
+	kfree(req->async_data);
+	req->async_data = NULL;
+	req->flags &= ~REQ_F_ASYNC_DATA;
+}
+
+static int io_waitid_finish(struct io_kiocb *req, int ret)
+{
+	struct io_waitid *iw = io_kiocb_to_cmd(req, struct io_waitid);
+	int signo = 0;
+
+	if (ret > 0) {
+		signo = SIGCHLD;
+		ret = 0;
+	}
+	if (!iw->infop)
+		goto done;
+
+	if (!user_write_access_begin(iw->infop, sizeof(*iw->infop))) {
+		ret = -EFAULT;
+		goto done;
+	}
+
+	unsafe_put_user(signo, &iw->infop->si_signo, Efault);
+	unsafe_put_user(0, &iw->infop->si_errno, Efault);
+	unsafe_put_user(iw->info.cause, &iw->infop->si_code, Efault);
+	unsafe_put_user(iw->info.pid, &iw->infop->si_pid, Efault);
+	unsafe_put_user(iw->info.uid, &iw->infop->si_uid, Efault);
+	unsafe_put_user(iw->info.status, &iw->infop->si_status, Efault);
+done:
+	user_write_access_end();
+	io_waitid_free(req);
+	return ret;
+Efault:
+	ret = -EFAULT;
+	goto done;
+}
+
+static void io_waitid_complete(struct io_kiocb *req, int ret)
+{
+	struct io_tw_state ts = { .locked = true };
+
+	lockdep_assert_held(&req->ctx->uring_lock);
+
+	/*
+	 * Did cancel find it meanwhile?
+	 */
+	if (hlist_unhashed(&req->hash_node))
+		return;
+
+	hlist_del_init(&req->hash_node);
+
+	ret = io_waitid_finish(req, ret);
+	if (ret < 0)
+		req_set_fail(req);
+	io_req_set_res(req, ret, 0);
+	io_req_task_complete(req, &ts);
+}
+
+static bool __io_waitid_cancel(struct io_ring_ctx *ctx, struct io_kiocb *req)
+{
+	struct io_waitid *iw = io_kiocb_to_cmd(req, struct io_waitid);
+	struct wait_queue_head *head;
+
+	head = READ_ONCE(iw->head);
+	if (head) {
+		struct io_waitid_async *iwa = req->async_data;
+
+		spin_lock_irq(&head->lock);
+		list_del_init(&iwa->wo.child_wait.entry);
+		iw->head = NULL;
+		spin_unlock_irq(&head->lock);
+		io_waitid_complete(req, -ECANCELED);
+		return true;
+	}
+
+	return false;
+}
+
+int io_waitid_cancel(struct io_ring_ctx *ctx, struct io_cancel_data *cd,
+		     unsigned int issue_flags)
+{
+	struct hlist_node *tmp;
+	struct io_kiocb *req;
+	int nr = 0;
+
+	if (cd->flags & (IORING_ASYNC_CANCEL_FD|IORING_ASYNC_CANCEL_FD_FIXED))
+		return -ENOENT;
+
+	io_ring_submit_lock(ctx, issue_flags);
+	hlist_for_each_entry_safe(req, tmp, &ctx->waitid_list, hash_node) {
+		if (req->cqe.user_data != cd->data &&
+		    !(cd->flags & IORING_ASYNC_CANCEL_ANY))
+			continue;
+		if (__io_waitid_cancel(ctx, req))
+			nr++;
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
+bool io_waitid_remove_all(struct io_ring_ctx *ctx, struct task_struct *task,
+			  bool cancel_all)
+{
+	struct hlist_node *tmp;
+	struct io_kiocb *req;
+	bool found = false;
+
+	lockdep_assert_held(&ctx->uring_lock);
+
+	hlist_for_each_entry_safe(req, tmp, &ctx->waitid_list, hash_node) {
+		if (!io_match_task_safe(req, task, cancel_all))
+			continue;
+		__io_waitid_cancel(ctx, req);
+		found = true;
+	}
+
+	return found;
+}
+
+static void io_waitid_cb(struct io_kiocb *req, struct io_tw_state *ts)
+{
+	struct io_waitid_async *iwa = req->async_data;
+	struct io_ring_ctx *ctx = req->ctx;
+	int ret;
+
+	/*
+	 * If we get -ERESTARTSYS here, we need to re-arm and check again
+	 * to ensure we get another callback. If the retry works, then we can
+	 * just remove ourselves from the waitqueue again and finish the
+	 * request.
+	 */
+	ret = __do_wait(&iwa->wo);
+	if (unlikely(ret == -ERESTARTSYS)) {
+		struct io_waitid *iw = io_kiocb_to_cmd(req, struct io_waitid);
+
+		io_tw_lock(ctx, ts);
+		iw->head = &current->signal->wait_chldexit;
+		add_wait_queue(iw->head, &iwa->wo.child_wait);
+		ret = __do_wait(&iwa->wo);
+		if (ret == -ERESTARTSYS)
+			return;
+
+		remove_wait_queue(iw->head, &iwa->wo.child_wait);
+		iw->head = NULL;
+	}
+
+	io_tw_lock(ctx, ts);
+	io_waitid_complete(req, ret);
+}
+
+static int io_waitid_wait(struct wait_queue_entry *wait, unsigned mode,
+			  int sync, void *key)
+{
+	struct wait_opts *wo = container_of(wait, struct wait_opts, child_wait);
+	struct io_waitid_async *iwa = container_of(wo, struct io_waitid_async, wo);
+	struct io_kiocb *req = iwa->req;
+	struct io_waitid *iw = io_kiocb_to_cmd(req, struct io_waitid);
+	struct task_struct *p = key;
+
+	if (!pid_child_should_wake(wo, p))
+		return 0;
+
+	req->io_task_work.func = io_waitid_cb;
+	io_req_task_work_add(req);
+	iw->head = NULL;
+	list_del_init(&wait->entry);
+	return 1;
+}
+
+int io_waitid_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	struct io_waitid *iw = io_kiocb_to_cmd(req, struct io_waitid);
+
+	if (sqe->addr || sqe->buf_index || sqe->addr3 || sqe->waitid_flags)
+		return -EINVAL;
+
+	iw->which = READ_ONCE(sqe->len);
+	iw->options = READ_ONCE(sqe->file_index);
+	iw->upid = READ_ONCE(sqe->fd);
+	iw->infop = u64_to_user_ptr(READ_ONCE(sqe->addr2));
+	iw->head = NULL;
+	return 0;
+}
+
+int io_waitid(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_waitid *iw = io_kiocb_to_cmd(req, struct io_waitid);
+	struct io_ring_ctx *ctx = req->ctx;
+	struct io_waitid_async *iwa;
+	unsigned int f_flags = 0;
+	int ret;
+
+	if (io_alloc_async_data(req))
+		return -ENOMEM;
+
+	iwa = req->async_data;
+	iwa->req = req;
+
+	ret = kernel_waitid_prepare(&iwa->wo, iw->which, iw->upid, &iw->info,
+					iw->options, NULL, &f_flags);
+	if (ret)
+		goto done;
+
+	/*
+	 * Arm our callback and add us to the waitqueue, in case no events
+	 * are available.
+	 */
+	init_waitqueue_func_entry(&iwa->wo.child_wait, io_waitid_wait);
+	iwa->wo.child_wait.private = req->task;
+	iw->head = &current->signal->wait_chldexit;
+	add_wait_queue(iw->head, &iwa->wo.child_wait);
+
+	io_ring_submit_lock(ctx, issue_flags);
+	hlist_add_head(&req->hash_node, &ctx->waitid_list);
+
+	ret = __do_wait(&iwa->wo);
+	if (ret == -ERESTARTSYS) {
+		io_ring_submit_unlock(ctx, issue_flags);
+		return IOU_ISSUE_SKIP_COMPLETE;
+	}
+
+	hlist_del_init(&req->hash_node);
+	remove_wait_queue(iw->head, &iwa->wo.child_wait);
+	iw->head = NULL;
+	ret = io_waitid_finish(req, ret);
+
+	io_ring_submit_unlock(ctx, issue_flags);
+done:
+	if (ret < 0)
+		req_set_fail(req);
+	io_req_set_res(req, ret, 0);
+	return IOU_OK;
+}
diff --git a/io_uring/waitid.h b/io_uring/waitid.h
new file mode 100644
index 000000000000..956a8adafe8c
--- /dev/null
+++ b/io_uring/waitid.h
@@ -0,0 +1,15 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include "../kernel/exit.h"
+
+struct io_waitid_async {
+	struct io_kiocb *req;
+	struct wait_opts wo;
+};
+
+int io_waitid_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
+int io_waitid(struct io_kiocb *req, unsigned int issue_flags);
+int io_waitid_cancel(struct io_ring_ctx *ctx, struct io_cancel_data *cd,
+		     unsigned int issue_flags);
+bool io_waitid_remove_all(struct io_ring_ctx *ctx, struct task_struct *task,
+			  bool cancel_all);
-- 
2.40.1

