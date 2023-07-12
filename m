Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78DEB74FC55
	for <lists+io-uring@lfdr.de>; Wed, 12 Jul 2023 02:47:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231285AbjGLArW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 11 Jul 2023 20:47:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229945AbjGLArS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 11 Jul 2023 20:47:18 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB54610D4
        for <io-uring@vger.kernel.org>; Tue, 11 Jul 2023 17:47:16 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id d9443c01a7336-1b898cfa6a1so9141065ad.1
        for <io-uring@vger.kernel.org>; Tue, 11 Jul 2023 17:47:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689122836; x=1689727636;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ceQzGCPNst+4GlWUlUZP0RISAT734e1HDBQMt1evUDU=;
        b=ddq+ANYGvujKOUtXjecxaLI5DXztouTYpNq8GAIrz1H6iPTUv3MbTzUbk2ARr2Iw3w
         AHC3UAiff3umcY/Rugtx+vIf8vf40IPc+HaEqBqg9fjGYhIMpSodwAeMaz3lOtYXtGVy
         xhH3Fm9wxFdBKlS9DBiQFCnPah5j75Pr2hmpj/KUftmIq+fhdCLJERx/zpTvPFgkyVnS
         48wL7TrrfwKKLkNFV39q0lLQ/A41hWEDvMnnrod2dZbyFZXJjbmMpWJRsPZLCFfs9BqX
         Ihw6AmZSgTFUNMLabbbHp3aF9dZblE9Hk+hlX8K98THxo3NO0ue3Ymqo8T8Ze83U3mYy
         gtJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689122836; x=1689727636;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ceQzGCPNst+4GlWUlUZP0RISAT734e1HDBQMt1evUDU=;
        b=LIRc65He3R30PrGYtvathb6zuMyCeYLT7ofjoADFPcMdG77WNp0RmCrYM8liHOUNQr
         gvQa2998qBIqZL4ebEBXY1DdMl2YTMkZJsWcAvbq1Cg8paI5+qiGWhDBaSTsYc0D3itG
         g/wrDcG1XVIHQktqMBxSptz97BY3c3Bidhi8rVd32qEr72n4vZhAzBQ7FefRu5mhaGU4
         +11k0iA+Hp/mmmNSHSXv1pFTcQnHvRz5GK2unnKK1+eWZowdoDkCB9ChRBzb97i6SWVz
         g4SvrNRaubytgHpRTfZUhcY2HjldBuVDoxgb4KvrnH/XG4uYWyfX2sd8KuR0BXWn94dc
         9Pxg==
X-Gm-Message-State: ABy/qLY3h4mZwvMJKrcNT8ZeFJyOPtl35aPkYBS8oP0/fXHI+4ErQJhv
        IdhCI9GIB0PL3FvzmA3RQ1exKCu2fGA53gQkwXk=
X-Google-Smtp-Source: APBJJlGhtVtPfEatzJ1RbPxVjY0PqbRjHsR20pVh4fV0TVhAUMItaUwjSOBxObRTA2DsaDE3Zu4SRg==
X-Received: by 2002:a17:902:da92:b0:1b3:d8ac:8db3 with SMTP id j18-20020a170902da9200b001b3d8ac8db3mr21326179plx.6.1689122835577;
        Tue, 11 Jul 2023 17:47:15 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id s8-20020a170902b18800b001b694140d96sm2543542plr.170.2023.07.11.17.47.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jul 2023 17:47:14 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, peterz@infradead.org,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/7] io_uring: add support for futex wake and wait
Date:   Tue, 11 Jul 2023 18:47:01 -0600
Message-Id: <20230712004705.316157-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230712004705.316157-1-axboe@kernel.dk>
References: <20230712004705.316157-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
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

This is just the barebones wait/wake support. PI or REQUEUE support is
not added at this point, unclear if we might look into that later.

Likewise, explicit timeouts are not supported either. It is expected
that users that need timeouts would do so via the usual io_uring
mechanism to do that using linked timeouts.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/io_uring_types.h |   3 +
 include/uapi/linux/io_uring.h  |   3 +
 io_uring/Makefile              |   4 +-
 io_uring/cancel.c              |   5 +
 io_uring/cancel.h              |   4 +
 io_uring/futex.c               | 232 +++++++++++++++++++++++++++++++++
 io_uring/futex.h               |  34 +++++
 io_uring/io_uring.c            |   5 +
 io_uring/opdef.c               |  24 +++-
 9 files changed, 312 insertions(+), 2 deletions(-)
 create mode 100644 io_uring/futex.c
 create mode 100644 io_uring/futex.h

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index f04ce513fadb..a7f03d8d879f 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -273,6 +273,9 @@ struct io_ring_ctx {
 	struct io_wq_work_list	locked_free_list;
 	unsigned int		locked_free_nr;
 
+	struct hlist_head	futex_list;
+	struct io_alloc_cache	futex_cache;
+
 	const struct cred	*sq_creds;	/* cred used for __io_sq_thread() */
 	struct io_sq_data	*sq_data;	/* if using sq thread polling */
 
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 36f9c73082de..3bd2d765f593 100644
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
index 7b23607cf4af..3dba8ccb1cd8 100644
--- a/io_uring/cancel.c
+++ b/io_uring/cancel.c
@@ -15,6 +15,7 @@
 #include "tctx.h"
 #include "poll.h"
 #include "timeout.h"
+#include "futex.h"
 #include "cancel.h"
 
 struct io_cancel {
@@ -119,6 +120,10 @@ int io_try_cancel(struct io_uring_task *tctx, struct io_cancel_data *cd,
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
index fc98622e6166..c0a8e7c520b6 100644
--- a/io_uring/cancel.h
+++ b/io_uring/cancel.h
@@ -1,4 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
+#ifndef IORING_CANCEL_H
+#define IORING_CANCEL_H
 
 #include <linux/io_uring_types.h>
 
@@ -22,3 +24,5 @@ void init_hash_table(struct io_hash_table *table, unsigned size);
 
 int io_sync_cancel(struct io_ring_ctx *ctx, void __user *arg);
 bool io_cancel_req_match(struct io_kiocb *req, struct io_cancel_data *cd);
+
+#endif
diff --git a/io_uring/futex.c b/io_uring/futex.c
new file mode 100644
index 000000000000..ff0f6b394756
--- /dev/null
+++ b/io_uring/futex.c
@@ -0,0 +1,232 @@
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
+#include "rsrc.h"
+#include "futex.h"
+
+struct io_futex {
+	struct file	*file;
+	u32 __user	*uaddr;
+	int		futex_op;
+	unsigned int	futex_val;
+	unsigned int	futex_flags;
+	unsigned int	futex_mask;
+};
+
+struct io_futex_data {
+	union {
+		struct futex_q		q;
+		struct io_cache_entry	cache;
+	};
+	struct io_kiocb	*req;
+};
+
+void io_futex_cache_init(struct io_ring_ctx *ctx)
+{
+	io_alloc_cache_init(&ctx->futex_cache, IO_NODE_ALLOC_CACHE_MAX,
+				sizeof(struct io_futex_data));
+}
+
+static void io_futex_cache_entry_free(struct io_cache_entry *entry)
+{
+	kfree(container_of(entry, struct io_futex_data, cache));
+}
+
+void io_futex_cache_free(struct io_ring_ctx *ctx)
+{
+	io_alloc_cache_free(&ctx->futex_cache, io_futex_cache_entry_free);
+}
+
+static void io_futex_complete(struct io_kiocb *req, struct io_tw_state *ts)
+{
+	struct io_futex_data *ifd = req->async_data;
+	struct io_ring_ctx *ctx = req->ctx;
+
+	io_tw_lock(ctx, ts);
+	if (!io_alloc_cache_put(&ctx->futex_cache, &ifd->cache))
+		kfree(ifd);
+	req->async_data = NULL;
+	hlist_del_init(&req->hash_node);
+	io_req_task_complete(req, ts);
+}
+
+static bool __io_futex_cancel(struct io_ring_ctx *ctx, struct io_kiocb *req)
+{
+	struct io_futex_data *ifd = req->async_data;
+
+	/* futex wake already done or in progress */
+	if (!futex_unqueue(&ifd->q))
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
+		return -ENOENT;
+
+	io_ring_submit_lock(ctx, issue_flags);
+	hlist_for_each_entry_safe(req, tmp, &ctx->futex_list, hash_node) {
+		if (req->cqe.user_data != cd->data &&
+		    !(cd->flags & IORING_ASYNC_CANCEL_ANY))
+			continue;
+		if (__io_futex_cancel(ctx, req))
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
+
+	if (unlikely(sqe->addr2 || sqe->buf_index || sqe->addr3))
+		return -EINVAL;
+
+	iof->futex_op = READ_ONCE(sqe->fd);
+	iof->uaddr = u64_to_user_ptr(READ_ONCE(sqe->addr));
+	iof->futex_val = READ_ONCE(sqe->len);
+	iof->futex_mask = READ_ONCE(sqe->file_index);
+	iof->futex_flags = READ_ONCE(sqe->futex_flags);
+	if (iof->futex_flags & FUTEX_CMD_MASK)
+		return -EINVAL;
+
+	return 0;
+}
+
+static void io_futex_wake_fn(struct wake_q_head *wake_q, struct futex_q *q)
+{
+	struct io_futex_data *ifd = container_of(q, struct io_futex_data, q);
+	struct io_kiocb *req = ifd->req;
+
+	__futex_unqueue(q);
+	smp_store_release(&q->lock_ptr, NULL);
+
+	io_req_set_res(req, 0, 0);
+	req->io_task_work.func = io_futex_complete;
+	io_req_task_work_add(req);
+}
+
+static struct io_futex_data *io_alloc_ifd(struct io_ring_ctx *ctx)
+{
+	struct io_cache_entry *entry;
+
+	entry = io_alloc_cache_get(&ctx->futex_cache);
+	if (entry)
+		return container_of(entry, struct io_futex_data, cache);
+
+	return kmalloc(sizeof(struct io_futex_data), GFP_NOWAIT);
+}
+
+int io_futex_wait(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_futex *iof = io_kiocb_to_cmd(req, struct io_futex);
+	struct io_ring_ctx *ctx = req->ctx;
+	struct io_futex_data *ifd = NULL;
+	struct futex_hash_bucket *hb;
+	unsigned int flags = 0;
+	int ret;
+
+	if (!iof->futex_mask) {
+		ret = -EINVAL;
+		goto done;
+	}
+	if (!futex_op_to_flags(FUTEX_WAIT, iof->futex_flags, &flags)) {
+		ret = -ENOSYS;
+		goto done;
+	}
+
+	io_ring_submit_lock(ctx, issue_flags);
+	ifd = io_alloc_ifd(ctx);
+	if (!ifd) {
+		ret = -ENOMEM;
+		goto done_unlock;
+	}
+
+	req->async_data = ifd;
+	ifd->q = futex_q_init;
+	ifd->q.bitset = iof->futex_mask;
+	ifd->q.wake = io_futex_wake_fn;
+	ifd->req = req;
+
+	ret = futex_wait_setup(iof->uaddr, iof->futex_val, flags, &ifd->q, &hb);
+	if (!ret) {
+		hlist_add_head(&req->hash_node, &ctx->futex_list);
+		io_ring_submit_unlock(ctx, issue_flags);
+
+		futex_queue(&ifd->q, hb);
+		return IOU_ISSUE_SKIP_COMPLETE;
+	}
+
+done_unlock:
+	io_ring_submit_unlock(ctx, issue_flags);
+done:
+	if (ret < 0)
+		req_set_fail(req);
+	io_req_set_res(req, ret, 0);
+	kfree(ifd);
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
index 000000000000..ddc9e0d73c52
--- /dev/null
+++ b/io_uring/futex.h
@@ -0,0 +1,34 @@
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
+void io_futex_cache_init(struct io_ring_ctx *ctx);
+void io_futex_cache_free(struct io_ring_ctx *ctx);
+#else
+static inline int io_futex_cancel(struct io_ring_ctx *ctx,
+				  struct io_cancel_data *cd,
+				  unsigned int issue_flags)
+{
+	return 0;
+}
+static inline bool io_futex_remove_all(struct io_ring_ctx *ctx,
+				       struct task_struct *task, bool cancel_all)
+{
+	return false;
+}
+static inline void io_futex_cache_init(struct io_ring_ctx *ctx)
+{
+}
+static inline void io_futex_cache_free(struct io_ring_ctx *ctx)
+{
+}
+#endif
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index e8096d502a7c..67ff148bc394 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -92,6 +92,7 @@
 #include "cancel.h"
 #include "net.h"
 #include "notif.h"
+#include "futex.h"
 
 #include "timeout.h"
 #include "poll.h"
@@ -314,6 +315,7 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 			    sizeof(struct async_poll));
 	io_alloc_cache_init(&ctx->netmsg_cache, IO_ALLOC_CACHE_MAX,
 			    sizeof(struct io_async_msghdr));
+	io_futex_cache_init(ctx);
 	init_completion(&ctx->ref_comp);
 	xa_init_flags(&ctx->personalities, XA_FLAGS_ALLOC1);
 	mutex_init(&ctx->uring_lock);
@@ -333,6 +335,7 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	INIT_LIST_HEAD(&ctx->tctx_list);
 	ctx->submit_state.free_list.next = NULL;
 	INIT_WQ_LIST(&ctx->locked_free_list);
+	INIT_HLIST_HEAD(&ctx->futex_list);
 	INIT_DELAYED_WORK(&ctx->fallback_work, io_fallback_req_func);
 	INIT_WQ_LIST(&ctx->submit_state.compl_reqs);
 	return ctx;
@@ -2842,6 +2845,7 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	io_eventfd_unregister(ctx);
 	io_alloc_cache_free(&ctx->apoll_cache, io_apoll_cache_free);
 	io_alloc_cache_free(&ctx->netmsg_cache, io_netmsg_cache_free);
+	io_futex_cache_free(ctx);
 	io_destroy_buffers(ctx);
 	mutex_unlock(&ctx->uring_lock);
 	if (ctx->sq_creds)
@@ -3254,6 +3258,7 @@ static __cold bool io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 	ret |= io_cancel_defer_files(ctx, task, cancel_all);
 	mutex_lock(&ctx->uring_lock);
 	ret |= io_poll_remove_all(ctx, task, cancel_all);
+	ret |= io_futex_remove_all(ctx, task, cancel_all);
 	mutex_unlock(&ctx->uring_lock);
 	ret |= io_kill_timeouts(ctx, task, cancel_all);
 	if (task)
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index 3b9c6489b8b6..c9f23c21a031 100644
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
@@ -648,6 +664,12 @@ const struct io_cold_def io_cold_defs[] = {
 		.fail			= io_sendrecv_fail,
 #endif
 	},
+	[IORING_OP_FUTEX_WAIT] = {
+		.name			= "FUTEX_WAIT",
+	},
+	[IORING_OP_FUTEX_WAKE] = {
+		.name			= "FUTEX_WAKE",
+	},
 };
 
 const char *io_uring_get_opcode(u8 opcode)
-- 
2.40.1

