Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 684DB7B23D8
	for <lists+io-uring@lfdr.de>; Thu, 28 Sep 2023 19:25:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231932AbjI1RZi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 28 Sep 2023 13:25:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231958AbjI1RZf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 28 Sep 2023 13:25:35 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 315611AE
        for <io-uring@vger.kernel.org>; Thu, 28 Sep 2023 10:25:31 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id 4fb4d7f45d1cf-5221bd8f62eso3186851a12.1
        for <io-uring@vger.kernel.org>; Thu, 28 Sep 2023 10:25:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1695921929; x=1696526729; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oUDAZatb2usVAAqKXyRcat3hmGorqbvXZ1XnWxWEmmY=;
        b=fmSQj+OWf5w+mde6nH8a/7wUIT537p4hgjtMuN73WaS2//FHIGAaZ9ocuwloD3wOyt
         s/dmCWtj2aUX4zoxed8C5gvM/1WQLcSpPLI8uADpPL3231nbTfD0DqErCqvaqUneOjdp
         DtVZTd23frKmVerwDrMaQdXDdBzBqVGVZJHNTZhCg94iFWyyu8wP6hZHS5bGIqwh3/W/
         4ovVmiK9q0KzaxNSoliaqd3Bt7oXDTTIYaZ6AD0gsRtQcnp+ICTZIv5C0LZxIVyJGv4W
         LaZRIP4hfQVgrtu0GZgo8FVd8yKr5npcAQIjxkPzGvEEAYCDpYdNbIh0qVPE5tgL+HIW
         xUIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695921929; x=1696526729;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oUDAZatb2usVAAqKXyRcat3hmGorqbvXZ1XnWxWEmmY=;
        b=GHPIH9G1LbYmz1wbdOTwOQ7+UlNlo91wmci9u6dKyirRVGN/V0mz003H346A1OaPcr
         pM346VOEgIaAiRwwBXjGh2EnHx8kGqZVKN4UVqmodDCyJx7LFKZDNwyKLsGSUrIr/IdV
         M4OVO8C2inRfnlj9Zx/Lu+OtJJ5P937X3iujqnHzw7uQoR5MNXA6NNOGu9tbYZKOq5X4
         I2KG+cB9TgGzY/Iy+ZbIRUydFGbtdGGyht6LbHu9hHumPKkZD1tid1IA+8P4vRIhxMqc
         PlKZGPaUgacJF4kRmDIDpzZpUr5kFi0oJhltanvzZOoh0xQyjTAIO3jdP1/DMsOWwQ/a
         yVzA==
X-Gm-Message-State: AOJu0YwwFGLHU/dBV3itKjn3pTRNDjrnyRtXPW3HB2gykDK7L8XlDxOj
        nNl+nRykDhgl7WimqrAEfw4v7zWdH9CY7M2MevJqKJkJ
X-Google-Smtp-Source: AGHT+IGlfXV+00wOTKUOatB9Ul15G+8LTPVo6raD1qwE8CrqN3Vn9o+/FNQ0Paf6dtuFMgb0f2guzw==
X-Received: by 2002:a17:906:519a:b0:9a1:b4f9:b1db with SMTP id y26-20020a170906519a00b009a1b4f9b1dbmr1877973ejk.1.1695921928860;
        Thu, 28 Sep 2023 10:25:28 -0700 (PDT)
Received: from localhost.localdomain ([45.147.210.162])
        by smtp.gmail.com with ESMTPSA id j17-20020a170906279100b0099329b3ab67sm11151788ejc.71.2023.09.28.10.25.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Sep 2023 10:25:27 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     peterz@infradead.org, andres@anarazel.de, tglx@linutronix.de,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/8] io_uring: add support for futex wake and wait
Date:   Thu, 28 Sep 2023 11:25:13 -0600
Message-Id: <20230928172517.961093-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230928172517.961093-1-axboe@kernel.dk>
References: <20230928172517.961093-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
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

For both of them, they are using the futex2 interface.

FUTEX_WAKE is straight forward, as those can always be done directly from
the io_uring submission without needing async handling. For FUTEX_WAIT,
things are a bit more complicated. If the futex isn't ready, then we
rely on a callback via futex_queue->wake() when someone wakes up the
futex. From that calback, we queue up task_work with the original task,
which will post a CQE and wake it, if necessary.

Cancelations are supported, both from the application point-of-view,
but also to be able to cancel pending waits if the ring exits before
all events have occurred. The return value of futex_unqueue() is used
to gate who wins the potential race between cancelation and futex
wakeups. Whomever gets a 'ret == 1' return from that claims ownership
of the io_uring futex request.

This is just the barebones wait/wake support. PI or REQUEUE support is
not added at this point, unclear if we might look into that later.

Likewise, explicit timeouts are not supported either. It is expected
that users that need timeouts would do so via the usual io_uring
mechanism to do that using linked timeouts.

The SQE format is as follows:

`addr`		Address of futex
`fd`		futex2(2) FUTEX2_* flags
`futex_flags`	io_uring specific command flags. None valid now.
`addr2`		Value of futex
`addr3`		Mask to wake/wait

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/io_uring_types.h |   5 +
 include/uapi/linux/io_uring.h  |   3 +
 io_uring/Makefile              |   1 +
 io_uring/cancel.c              |   5 +
 io_uring/cancel.h              |   4 +
 io_uring/futex.c               | 235 +++++++++++++++++++++++++++++++++
 io_uring/futex.h               |  34 +++++
 io_uring/io_uring.c            |   7 +
 io_uring/opdef.c               |  23 ++++
 9 files changed, 317 insertions(+)
 create mode 100644 io_uring/futex.c
 create mode 100644 io_uring/futex.h

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index e178461fa513..990984614fca 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -321,6 +321,11 @@ struct io_ring_ctx {
 
 	struct hlist_head	waitid_list;
 
+#ifdef CONFIG_FUTEX
+	struct hlist_head	futex_list;
+	struct io_alloc_cache	futex_cache;
+#endif
+
 	const struct cred	*sq_creds;	/* cred used for __io_sq_thread() */
 	struct io_sq_data	*sq_data;	/* if using sq thread polling */
 
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 425f64eee44e..04f9fba38d4b 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -66,6 +66,7 @@ struct io_uring_sqe {
 		__u32		msg_ring_flags;
 		__u32		uring_cmd_flags;
 		__u32		waitid_flags;
+		__u32		futex_flags;
 	};
 	__u64	user_data;	/* data to be passed back at completion time */
 	/* pack this to avoid bogus arm OABI complaints */
@@ -243,6 +244,8 @@ enum io_uring_op {
 	IORING_OP_SENDMSG_ZC,
 	IORING_OP_READ_MULTISHOT,
 	IORING_OP_WAITID,
+	IORING_OP_FUTEX_WAIT,
+	IORING_OP_FUTEX_WAKE,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
diff --git a/io_uring/Makefile b/io_uring/Makefile
index 7bd64e442567..e5be47e4fc3b 100644
--- a/io_uring/Makefile
+++ b/io_uring/Makefile
@@ -10,3 +10,4 @@ obj-$(CONFIG_IO_URING)		+= io_uring.o xattr.o nop.o fs.o splice.o \
 					cancel.o kbuf.o rsrc.o rw.o opdef.o \
 					notif.o waitid.o
 obj-$(CONFIG_IO_WQ)		+= io-wq.o
+obj-$(CONFIG_FUTEX)		+= futex.o
diff --git a/io_uring/cancel.c b/io_uring/cancel.c
index eb77a51c5a79..3c19cccb1aec 100644
--- a/io_uring/cancel.c
+++ b/io_uring/cancel.c
@@ -16,6 +16,7 @@
 #include "poll.h"
 #include "timeout.h"
 #include "waitid.h"
+#include "futex.h"
 #include "cancel.h"
 
 struct io_cancel {
@@ -124,6 +125,10 @@ int io_try_cancel(struct io_uring_task *tctx, struct io_cancel_data *cd,
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
index 000000000000..eb4406ac46fb
--- /dev/null
+++ b/io_uring/futex.c
@@ -0,0 +1,235 @@
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
+	unsigned long	futex_val;
+	unsigned long	futex_mask;
+	u32		futex_flags;
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
+	u32 flags;
+
+	if (unlikely(sqe->len || sqe->futex_flags || sqe->buf_index ||
+		     sqe->file_index))
+		return -EINVAL;
+
+	iof->uaddr = u64_to_user_ptr(READ_ONCE(sqe->addr));
+	iof->futex_val = READ_ONCE(sqe->addr2);
+	iof->futex_mask = READ_ONCE(sqe->addr3);
+	flags = READ_ONCE(sqe->fd);
+
+	if (flags & ~FUTEX2_VALID_MASK)
+		return -EINVAL;
+
+	iof->futex_flags = futex2_to_flags(flags);
+	if (!futex_flags_valid(iof->futex_flags))
+		return -EINVAL;
+
+	if (!futex_validate_input(iof->futex_flags, iof->futex_val) ||
+	    !futex_validate_input(iof->futex_flags, iof->futex_mask))
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
+	if (unlikely(!__futex_wake_mark(q)))
+		return;
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
+	int ret;
+
+	if (!iof->futex_mask) {
+		ret = -EINVAL;
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
+	ret = futex_wait_setup(iof->uaddr, iof->futex_val, iof->futex_flags,
+			       &ifd->q, &hb);
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
+	int ret;
+
+	/*
+	 * Strict flags - ensure that waking 0 futexes yields a 0 result.
+	 * See commit 43adf8449510 ("futex: FLAGS_STRICT") for details.
+	 */
+	ret = futex_wake(iof->uaddr, FLAGS_STRICT | iof->futex_flags,
+			 iof->futex_val, iof->futex_mask);
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
index 08c9ea46bb95..3c1c111d02cb 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -93,6 +93,7 @@
 #include "net.h"
 #include "notif.h"
 #include "waitid.h"
+#include "futex.h"
 
 #include "timeout.h"
 #include "poll.h"
@@ -330,6 +331,7 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 			    sizeof(struct async_poll));
 	io_alloc_cache_init(&ctx->netmsg_cache, IO_ALLOC_CACHE_MAX,
 			    sizeof(struct io_async_msghdr));
+	io_futex_cache_init(ctx);
 	init_completion(&ctx->ref_comp);
 	xa_init_flags(&ctx->personalities, XA_FLAGS_ALLOC1);
 	mutex_init(&ctx->uring_lock);
@@ -350,6 +352,9 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	ctx->submit_state.free_list.next = NULL;
 	INIT_WQ_LIST(&ctx->locked_free_list);
 	INIT_HLIST_HEAD(&ctx->waitid_list);
+#ifdef CONFIG_FUTEX
+	INIT_HLIST_HEAD(&ctx->futex_list);
+#endif
 	INIT_DELAYED_WORK(&ctx->fallback_work, io_fallback_req_func);
 	INIT_WQ_LIST(&ctx->submit_state.compl_reqs);
 	INIT_HLIST_HEAD(&ctx->cancelable_uring_cmd);
@@ -2895,6 +2900,7 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	io_eventfd_unregister(ctx);
 	io_alloc_cache_free(&ctx->apoll_cache, io_apoll_cache_free);
 	io_alloc_cache_free(&ctx->netmsg_cache, io_netmsg_cache_free);
+	io_futex_cache_free(ctx);
 	io_destroy_buffers(ctx);
 	mutex_unlock(&ctx->uring_lock);
 	if (ctx->sq_creds)
@@ -3338,6 +3344,7 @@ static __cold bool io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 	mutex_lock(&ctx->uring_lock);
 	ret |= io_poll_remove_all(ctx, task, cancel_all);
 	ret |= io_waitid_remove_all(ctx, task, cancel_all);
+	ret |= io_futex_remove_all(ctx, task, cancel_all);
 	ret |= io_uring_try_cancel_uring_cmd(ctx, task, cancel_all);
 	mutex_unlock(&ctx->uring_lock);
 	ret |= io_kill_timeouts(ctx, task, cancel_all);
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index aadcbf7136b0..31a3a421e94d 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -34,6 +34,7 @@
 #include "cancel.h"
 #include "rw.h"
 #include "waitid.h"
+#include "futex.h"
 
 static int io_no_issue(struct io_kiocb *req, unsigned int issue_flags)
 {
@@ -444,6 +445,22 @@ const struct io_issue_def io_issue_defs[] = {
 		.prep			= io_waitid_prep,
 		.issue			= io_waitid,
 	},
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
+#endif
+	},
 };
 
 const struct io_cold_def io_cold_defs[] = {
@@ -670,6 +687,12 @@ const struct io_cold_def io_cold_defs[] = {
 		.name			= "WAITID",
 		.async_size		= sizeof(struct io_waitid_async),
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

