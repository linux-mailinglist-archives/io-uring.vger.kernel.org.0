Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68CC17999B3
	for <lists+io-uring@lfdr.de>; Sat,  9 Sep 2023 18:25:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231640AbjIIQZe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 9 Sep 2023 12:25:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346572AbjIIPLs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 9 Sep 2023 11:11:48 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60F8D1AA
        for <io-uring@vger.kernel.org>; Sat,  9 Sep 2023 08:11:42 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id d9443c01a7336-1bf095e1becso5165675ad.1
        for <io-uring@vger.kernel.org>; Sat, 09 Sep 2023 08:11:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1694272301; x=1694877101; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F0Lv90AyqtmMgsKR1/HH7kPu6rHhpqz2YuJwmoi1XO0=;
        b=d+q/eCc/1ielS3/O76NodZNXAFSpqQ0xZP1h7o94mgVlwhcMKGCvGkkGVtY+sd3dBQ
         tOrmQgQ+v5RMWA5NLEdLRNseUiIfpHTKtx5a9hX2v88sPqAHMAYl8rmYNmn5nVYS1qIC
         zkAj8rN0jgbcSUxNbRrnxcNTAF0CeoWE9adZw4k2395Dazjqc9rpvX3v78hilS7QHkht
         vr8ujSkbaBT+aoDzPaHrHCrtvDeDnB8NW9c7/+FdvNPry81qLNmOCxkrH4Bdsx/NJTFg
         DH7L/h2lmodoKS9XE6ROUMsMyRPgw+Z1DJJbtu350yDnmSBh/fInjc+qnha/etDUaUxh
         ecYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694272301; x=1694877101;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=F0Lv90AyqtmMgsKR1/HH7kPu6rHhpqz2YuJwmoi1XO0=;
        b=YLjvYdltcUNaeENsZ+a44GVF6V0E1R7fq7BLZ3kmoIwRUj9jPOuy4BswymlamdZLhG
         kcHKVB0QSt06gR3KtN6n4oSdUkEkcho06oainnWJ0Icpdnd5yHmg5cgH0hj1hGVSAqCj
         aOV6AhcWLC6Rqo+q6p7v5xUyrP1G76oc1s3JRrfnsf4QJASGrhq2Q6xXq7rUO91QCdJh
         AskDUP+Fxhwr0Z+DIyWa6EDLTpU1Zuly43QESq3cGhyp0eW32OpowqUMgdaOCbj25ab6
         Uy7NxTiaeOLDIQOonSqT8xQEobzpg8Y9Vlj45bPvZz7jNozkvJjCXPW/3Ebr7Qf790K/
         mOlw==
X-Gm-Message-State: AOJu0YxQH+VIEosCXs04DaDNUiyI+9f1dBaH7D3FaL1ZitxgilW12XWH
        kJJPVCdzSZ7GaO/MukYkGb3etTjj8zTI+O+M1mkNhQ==
X-Google-Smtp-Source: AGHT+IGXEJroJhr2GIF0zCQZ2nDWNIJ0JS2+nrjg+9N6XU5lALNhJt5XscXO9BTsvF5MW5KJBOYtxg==
X-Received: by 2002:a17:902:d48d:b0:1c2:c60:8388 with SMTP id c13-20020a170902d48d00b001c20c608388mr6525036plg.6.1694272301376;
        Sat, 09 Sep 2023 08:11:41 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id f15-20020a170902ff0f00b001bdb0483e65sm3371450plj.265.2023.09.09.08.11.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Sep 2023 08:11:40 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     brauner@kernel.org, arnd@arndb.de, asml.silence@gmail.com,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5/5] io_uring: add IORING_OP_WAITID support
Date:   Sat,  9 Sep 2023 09:11:24 -0600
Message-Id: <20230909151124.1229695-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230909151124.1229695-1-axboe@kernel.dk>
References: <20230909151124.1229695-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
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
 io_uring/Makefile              |   3 +-
 io_uring/cancel.c              |   5 +
 io_uring/io_uring.c            |   3 +
 io_uring/opdef.c               |  10 +-
 io_uring/waitid.c              | 372 +++++++++++++++++++++++++++++++++
 io_uring/waitid.h              |  15 ++
 8 files changed, 410 insertions(+), 2 deletions(-)
 create mode 100644 io_uring/waitid.c
 create mode 100644 io_uring/waitid.h

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 13d19b9be9f4..fe1c5d4ec56c 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -313,6 +313,8 @@ struct io_ring_ctx {
 	struct list_head	cq_overflow_list;
 	struct io_hash_table	cancel_table;
 
+	struct hlist_head	waitid_list;
+
 	const struct cred	*sq_creds;	/* cred used for __io_sq_thread() */
 	struct io_sq_data	*sq_data;	/* if using sq thread polling */
 
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 8e61f8b7c2ce..90d5c7ceaedb 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -65,6 +65,7 @@ struct io_uring_sqe {
 		__u32		xattr_flags;
 		__u32		msg_ring_flags;
 		__u32		uring_cmd_flags;
+		__u32		waitid_flags;
 	};
 	__u64	user_data;	/* data to be passed back at completion time */
 	/* pack this to avoid bogus arm OABI complaints */
@@ -240,6 +241,7 @@ enum io_uring_op {
 	IORING_OP_URING_CMD,
 	IORING_OP_SEND_ZC,
 	IORING_OP_SENDMSG_ZC,
+	IORING_OP_WAITID,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
diff --git a/io_uring/Makefile b/io_uring/Makefile
index 8cc8e5387a75..7bd64e442567 100644
--- a/io_uring/Makefile
+++ b/io_uring/Makefile
@@ -7,5 +7,6 @@ obj-$(CONFIG_IO_URING)		+= io_uring.o xattr.o nop.o fs.o splice.o \
 					openclose.o uring_cmd.o epoll.o \
 					statx.o net.o msg_ring.o timeout.o \
 					sqpoll.o fdinfo.o tctx.o poll.o \
-					cancel.o kbuf.o rsrc.o rw.o opdef.o notif.o
+					cancel.o kbuf.o rsrc.o rw.o opdef.o \
+					notif.o waitid.o
 obj-$(CONFIG_IO_WQ)		+= io-wq.o
diff --git a/io_uring/cancel.c b/io_uring/cancel.c
index 7b23607cf4af..eb77a51c5a79 100644
--- a/io_uring/cancel.c
+++ b/io_uring/cancel.c
@@ -15,6 +15,7 @@
 #include "tctx.h"
 #include "poll.h"
 #include "timeout.h"
+#include "waitid.h"
 #include "cancel.h"
 
 struct io_cancel {
@@ -119,6 +120,10 @@ int io_try_cancel(struct io_uring_task *tctx, struct io_cancel_data *cd,
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
index 783ed0fff71b..2dff4772bf14 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -92,6 +92,7 @@
 #include "cancel.h"
 #include "net.h"
 #include "notif.h"
+#include "waitid.h"
 
 #include "timeout.h"
 #include "poll.h"
@@ -348,6 +349,7 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	INIT_LIST_HEAD(&ctx->tctx_list);
 	ctx->submit_state.free_list.next = NULL;
 	INIT_WQ_LIST(&ctx->locked_free_list);
+	INIT_HLIST_HEAD(&ctx->waitid_list);
 	INIT_DELAYED_WORK(&ctx->fallback_work, io_fallback_req_func);
 	INIT_WQ_LIST(&ctx->submit_state.compl_reqs);
 	return ctx;
@@ -3303,6 +3305,7 @@ static __cold bool io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 	ret |= io_cancel_defer_files(ctx, task, cancel_all);
 	mutex_lock(&ctx->uring_lock);
 	ret |= io_poll_remove_all(ctx, task, cancel_all);
+	ret |= io_waitid_remove_all(ctx, task, cancel_all);
 	mutex_unlock(&ctx->uring_lock);
 	ret |= io_kill_timeouts(ctx, task, cancel_all);
 	if (task)
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index 3b9c6489b8b6..84e55b325d21 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -33,6 +33,7 @@
 #include "poll.h"
 #include "cancel.h"
 #include "rw.h"
+#include "waitid.h"
 
 static int io_no_issue(struct io_kiocb *req, unsigned int issue_flags)
 {
@@ -428,9 +429,12 @@ const struct io_issue_def io_issue_defs[] = {
 		.prep			= io_eopnotsupp_prep,
 #endif
 	},
+	[IORING_OP_WAITID] = {
+		.prep			= io_waitid_prep,
+		.issue			= io_waitid,
+	},
 };
 
-
 const struct io_cold_def io_cold_defs[] = {
 	[IORING_OP_NOP] = {
 		.name			= "NOP",
@@ -648,6 +652,10 @@ const struct io_cold_def io_cold_defs[] = {
 		.fail			= io_sendrecv_fail,
 #endif
 	},
+	[IORING_OP_WAITID] = {
+		.name			= "WAITID",
+		.async_size		= sizeof(struct io_waitid_async),
+	},
 };
 
 const char *io_uring_get_opcode(u8 opcode)
diff --git a/io_uring/waitid.c b/io_uring/waitid.c
new file mode 100644
index 000000000000..6f851978606d
--- /dev/null
+++ b/io_uring/waitid.c
@@ -0,0 +1,372 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Support for async notification of waitid
+ */
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/fs.h>
+#include <linux/file.h>
+#include <linux/compat.h>
+#include <linux/io_uring.h>
+
+#include <uapi/linux/io_uring.h>
+
+#include "io_uring.h"
+#include "cancel.h"
+#include "waitid.h"
+#include "../kernel/exit.h"
+
+static void io_waitid_cb(struct io_kiocb *req, struct io_tw_state *ts);
+
+#define IO_WAITID_CANCEL_FLAG	BIT(31)
+#define IO_WAITID_REF_MASK	GENMASK(30, 0)
+
+struct io_waitid {
+	struct file *file;
+	int which;
+	pid_t upid;
+	int options;
+	atomic_t refs;
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
+#ifdef CONFIG_COMPAT
+static bool io_waitid_compat_copy_si(struct io_waitid *iw, int signo)
+{
+	struct compat_siginfo __user *infop;
+	bool ret;
+
+	infop = (struct compat_siginfo __user *) iw->infop;
+
+	if (!user_write_access_begin(infop, sizeof(*infop)))
+		return false;
+
+	unsafe_put_user(signo, &infop->si_signo, Efault);
+	unsafe_put_user(0, &infop->si_errno, Efault);
+	unsafe_put_user(iw->info.cause, &infop->si_code, Efault);
+	unsafe_put_user(iw->info.pid, &infop->si_pid, Efault);
+	unsafe_put_user(iw->info.uid, &infop->si_uid, Efault);
+	unsafe_put_user(iw->info.status, &infop->si_status, Efault);
+	ret = true;
+done:
+	user_write_access_end();
+	return ret;
+Efault:
+	ret = false;
+	goto done;
+}
+#endif
+
+static bool io_waitid_copy_si(struct io_kiocb *req, int signo)
+{
+	struct io_waitid *iw = io_kiocb_to_cmd(req, struct io_waitid);
+	bool ret;
+
+	if (!iw->infop)
+		return true;
+
+#ifdef CONFIG_COMPAT
+	if (req->ctx->compat)
+		return io_waitid_compat_copy_si(iw, signo);
+#endif
+
+	if (!user_write_access_begin(iw->infop, sizeof(*iw->infop)))
+		return false;
+
+	unsafe_put_user(signo, &iw->infop->si_signo, Efault);
+	unsafe_put_user(0, &iw->infop->si_errno, Efault);
+	unsafe_put_user(iw->info.cause, &iw->infop->si_code, Efault);
+	unsafe_put_user(iw->info.pid, &iw->infop->si_pid, Efault);
+	unsafe_put_user(iw->info.uid, &iw->infop->si_uid, Efault);
+	unsafe_put_user(iw->info.status, &iw->infop->si_status, Efault);
+	ret = true;
+done:
+	user_write_access_end();
+	return ret;
+Efault:
+	ret = false;
+	goto done;
+}
+
+static int io_waitid_finish(struct io_kiocb *req, int ret)
+{
+	int signo = 0;
+
+	if (ret > 0) {
+		signo = SIGCHLD;
+		ret = 0;
+	}
+
+	if (!io_waitid_copy_si(req, signo))
+		ret = -EFAULT;
+	io_waitid_free(req);
+	return ret;
+}
+
+static void io_waitid_complete(struct io_kiocb *req, int ret)
+{
+	struct io_waitid *iw = io_kiocb_to_cmd(req, struct io_waitid);
+	struct io_tw_state ts = { .locked = true };
+
+	/* anyone completing better be holding a reference */
+	WARN_ON_ONCE(!(atomic_read(&iw->refs) & IO_WAITID_REF_MASK));
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
+	struct io_waitid_async *iwa = req->async_data;
+
+	/*
+	 * Mark us canceled regardless of ownership. This will prevent a
+	 * potential retry from a spurious wakeup.
+	 */
+	atomic_or(IO_WAITID_CANCEL_FLAG, &iw->refs);
+
+	/* claim ownership */
+	if (atomic_fetch_inc(&iw->refs) & IO_WAITID_REF_MASK)
+		return false;
+
+	spin_lock_irq(&iw->head->lock);
+	list_del_init(&iwa->wo.child_wait.entry);
+	spin_unlock_irq(&iw->head->lock);
+	io_waitid_complete(req, -ECANCELED);
+	return true;
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
+static inline bool io_waitid_drop_issue_ref(struct io_kiocb *req)
+{
+	struct io_waitid *iw = io_kiocb_to_cmd(req, struct io_waitid);
+	struct io_waitid_async *iwa = req->async_data;
+
+	if (!atomic_sub_return(1, &iw->refs))
+		return false;
+
+	/*
+	 * Wakeup triggered, racing with us. It was prevented from
+	 * completing because of that, queue up the tw to do that.
+	 */
+	req->io_task_work.func = io_waitid_cb;
+	io_req_task_work_add(req);
+	remove_wait_queue(iw->head, &iwa->wo.child_wait);
+	return true;
+}
+
+static void io_waitid_cb(struct io_kiocb *req, struct io_tw_state *ts)
+{
+	struct io_waitid_async *iwa = req->async_data;
+	struct io_ring_ctx *ctx = req->ctx;
+	int ret;
+
+	io_tw_lock(ctx, ts);
+
+	ret = __do_wait(&iwa->wo);
+
+	/*
+	 * If we get -ERESTARTSYS here, we need to re-arm and check again
+	 * to ensure we get another callback. If the retry works, then we can
+	 * just remove ourselves from the waitqueue again and finish the
+	 * request.
+	 */
+	if (unlikely(ret == -ERESTARTSYS)) {
+		struct io_waitid *iw = io_kiocb_to_cmd(req, struct io_waitid);
+
+		/* Don't retry if cancel found it meanwhile */
+		ret = -ECANCELED;
+		if (!(atomic_read(&iw->refs) & IO_WAITID_CANCEL_FLAG)) {
+			iw->head = &current->signal->wait_chldexit;
+			add_wait_queue(iw->head, &iwa->wo.child_wait);
+			ret = __do_wait(&iwa->wo);
+			if (ret == -ERESTARTSYS) {
+				/* retry armed, drop our ref */
+				io_waitid_drop_issue_ref(req);
+				return;
+			}
+
+			remove_wait_queue(iw->head, &iwa->wo.child_wait);
+		}
+	}
+
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
+	/* cancel is in progress */
+	if (atomic_fetch_inc(&iw->refs) & IO_WAITID_REF_MASK)
+		return 1;
+
+	req->io_task_work.func = io_waitid_cb;
+	io_req_task_work_add(req);
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
+	iw->upid = READ_ONCE(sqe->fd);
+	iw->options = READ_ONCE(sqe->file_index);
+	iw->infop = u64_to_user_ptr(READ_ONCE(sqe->addr2));
+	return 0;
+}
+
+int io_waitid(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_waitid *iw = io_kiocb_to_cmd(req, struct io_waitid);
+	struct io_ring_ctx *ctx = req->ctx;
+	struct io_waitid_async *iwa;
+	int ret;
+
+	if (io_alloc_async_data(req))
+		return -ENOMEM;
+
+	iwa = req->async_data;
+	iwa->req = req;
+
+	ret = kernel_waitid_prepare(&iwa->wo, iw->which, iw->upid, &iw->info,
+					iw->options, NULL);
+	if (ret)
+		goto done;
+
+	/*
+	 * Mark the request as busy upfront, in case we're racing with the
+	 * wakeup. If we are, then we'll notice when we drop this initial
+	 * reference again after arming.
+	 */
+	atomic_set(&iw->refs, 1);
+
+	/*
+	 * Cancel must hold the ctx lock, so there's no risk of cancelation
+	 * finding us until a) we remain on the list, and b) the lock is
+	 * dropped. We only need to worry about racing with the wakeup
+	 * callback.
+	 */
+	io_ring_submit_lock(ctx, issue_flags);
+	hlist_add_head(&req->hash_node, &ctx->waitid_list);
+
+	init_waitqueue_func_entry(&iwa->wo.child_wait, io_waitid_wait);
+	iwa->wo.child_wait.private = req->task;
+	iw->head = &current->signal->wait_chldexit;
+	add_wait_queue(iw->head, &iwa->wo.child_wait);
+
+	ret = __do_wait(&iwa->wo);
+	if (ret == -ERESTARTSYS) {
+		/*
+		 * Nobody else grabbed a reference, it'll complete when we get
+		 * a waitqueue callback, or if someone cancels it.
+		 */
+		if (!io_waitid_drop_issue_ref(req)) {
+			io_ring_submit_unlock(ctx, issue_flags);
+			return IOU_ISSUE_SKIP_COMPLETE;
+		}
+
+		/*
+		 * Wakeup triggered, racing with us. It was prevented from
+		 * completing because of that, queue up the tw to do that.
+		 */
+		io_ring_submit_unlock(ctx, issue_flags);
+		return IOU_ISSUE_SKIP_COMPLETE;
+	}
+
+	hlist_del_init(&req->hash_node);
+	remove_wait_queue(iw->head, &iwa->wo.child_wait);
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

