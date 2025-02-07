Return-Path: <io-uring+bounces-6311-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BD708A2CA58
	for <lists+io-uring@lfdr.de>; Fri,  7 Feb 2025 18:37:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 66FF416B9D3
	for <lists+io-uring@lfdr.de>; Fri,  7 Feb 2025 17:37:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBE8219D072;
	Fri,  7 Feb 2025 17:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="rX1ViygU"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96D201A3144
	for <io-uring@vger.kernel.org>; Fri,  7 Feb 2025 17:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738949815; cv=none; b=YBAIbaCiISanJJV4/BuSL9l8MQkEkqd03lYSJx+Yp2anV/qFrS15zy0ERkwxtea0FDbqnIKEbaN6yHlHJNvY4N5QSSPobL2XA4iN0nWXxxkW7lx9IwAXpUMp2j5efWkVvdlVxE8x4vaTiVe0lkgj+rkQzwssP5sE5yaL0fuLHdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738949815; c=relaxed/simple;
	bh=/wc5aGUcFs1HMlPcN4lPleOhlLs4Z6Y3krXMU90FQ5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nra4P84rGkDSjYzw3LjB7ifHjCEN9+X/QSZgO4/Tjb5vpjdedArTHzmF4Kqp3FrZI/e286+M87pHlPwuaj7dkkGueL3HT4a/bjuHIVZ8gHXaDYOMpZ/KSLHrL1khm6ubOtpUjG8lMOvWiL7ePoNCgPCf8EPLP4TAsvdWLrZPx1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=rX1ViygU; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-844ef6275c5so68253339f.0
        for <io-uring@vger.kernel.org>; Fri, 07 Feb 2025 09:36:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1738949812; x=1739554612; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7qbvtsfwyIZePBB7edcFoY3EkzIhOm6ji2xaEWPLWTg=;
        b=rX1ViygU+6mtbKC1K1dzq/cgWDMZ5vAXz8Kd54gsDIxnG+XCHq109PcMiUk17Eoa5A
         urLIAne3jgQlJsLjReGsS1XD2FObXCWAwYXJlZTAcL53y8mZ8rLwAICyT29LNJEbvMv8
         22gyZ9ff3s5G7dGaB2V/mZSHCiANIGpHzfK0bw/rBSOcL2xz9pRfdZ/zXlhHKnD3rXq4
         beIuvDYSpYuwv/T3gYVAF0fiW1IGA+hDLq295Q4qUw7A1I+qwDYBFfViB4dNJ8ML2t+v
         are2j05u95yoWdRu2XkYY8uQZ9miTeMyo4XKr4H8Abkqi9O2rQI4mJFleg2t/42Imckm
         lAMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738949812; x=1739554612;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7qbvtsfwyIZePBB7edcFoY3EkzIhOm6ji2xaEWPLWTg=;
        b=V/Tr15pGmqV3ruk6pS743Qtgf98yoD9hXfXOZGQ7AlV2QLd9ctDqXSsQuicQLce5gL
         LTtqATtPLg+jGYsKJhiiTfIbFGEGJcSE5lHj60QilqzoxFaKKir3EqT8j04+Z++P9uRm
         JFMoF60xArSuLXuqkR9pKXXf7Ytv1nA6KKihn/Onmdz7Y+FPxYzmfIogIPZcaEcJa3b1
         aNTl+UPW/bu4BrQ4xLuXT7a67Kj84+cFyIVAYq+rylvYaf5bXSpqOjqrsTPyjrr0QW07
         w1W99/UVv/Jedcgzkf1JObhkt0cJCaJU4YkohfO5y6KmUhiv6+rkH064MKLQIV+SdoNe
         mirw==
X-Gm-Message-State: AOJu0YwS8mGbkjGvl6e8RmgzHWSMRldYNS5DtwHtvWXdqkXO482m4Vjb
	fVKR4LKS2KK7y+3qsaIl9zMeawMIgtOCLW5z+cu94yiy/0/2jw/xf6voGGAWXQMX10cTki4OhTk
	U
X-Gm-Gg: ASbGncuxxH1aukx+fz07s1qzo8n8461BixCz7Aul9TAPtKBKIMEZzvmUlTBw/WEQjzG
	S7Ce9s9qILzJs9FHayi61Y8FaM756t7JmBBT6LviZTUJv3giCNNbLEOrVtatB7m+YIV2JEEZpW4
	qsURQoFz6bWpv3DM0TiYDVu1Ok81u/mhMFmO8gVojHlMryEBIkcbqjDk0M5gmSkOzeoXWngHl16
	FPtDQp6wno89HtY/n+p2+CQF1uadulylG/Pn5xqNxWHf/kEmLgc+nqpUlm0VTYoutJ7PCqfgKqe
	qD3xeqRghuNG0wtxGQY=
X-Google-Smtp-Source: AGHT+IEhNjgBKE9AcXHRNWx2yEx4kJJe7LB6Frs7X1I9sitvExI/LF4qPxS9MDRcfcLNcaO/qNB7zQ==
X-Received: by 2002:a05:6602:7509:b0:844:debf:24dc with SMTP id ca18e2360f4ac-854fd8a0a0cmr475959439f.5.1738949812085;
        Fri, 07 Feb 2025 09:36:52 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ece0186151sm206241173.111.2025.02.07.09.36.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Feb 2025 09:36:51 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org,
	brauner@kernel.org,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7/7] io_uring/epoll: add support for IORING_OP_EPOLL_WAIT
Date: Fri,  7 Feb 2025 10:32:30 -0700
Message-ID: <20250207173639.884745-8-axboe@kernel.dk>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250207173639.884745-1-axboe@kernel.dk>
References: <20250207173639.884745-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For existing epoll event loops that can't fully convert to io_uring,
the used approach is usually to add the io_uring fd to the epoll
instance and use epoll_wait() to wait on both "legacy" and io_uring
events. While this work, it isn't optimal as:

1) epoll_wait() is pretty limited in what it can do. It does not support
   partial reaping of events, or waiting on a batch of events.

2) When an io_uring ring is added to an epoll instance, it activates the
   io_uring "I'm being polled" logic which slows things down.

Rather than use this approach, with EPOLL_WAIT support added to io_uring,
event loops can use the normal io_uring wait logic for everything, as
long as an epoll wait request has been armed with io_uring.

Note that IORING_OP_EPOLL_WAIT does NOT take a timeout value, as this
is an async request. Waiting on io_uring events in general has various
timeout parameters, and those are the ones that should be used when
waiting on any kind of request. If events are immediately available for
reaping, then This opcode will return those immediately. If none are
available, then it will post an async completion when they become
available.

cqe->res will contain either an error code (< 0 value) for a malformed
request, invalid epoll instance, etc. It will return a positive result
indicating how many events were reaped.

IORING_OP_EPOLL_WAIT requests may be canceled using the normal io_uring
cancelation infrastructure. The poll logic for managing ownership is
adopted to guard the epoll side too.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/io_uring_types.h |   4 +
 include/uapi/linux/io_uring.h  |   1 +
 io_uring/cancel.c              |   5 ++
 io_uring/epoll.c               | 143 +++++++++++++++++++++++++++++++++
 io_uring/epoll.h               |  22 +++++
 io_uring/io_uring.c            |   5 ++
 io_uring/opdef.c               |  14 ++++
 7 files changed, 194 insertions(+)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index e2fef264ff8b..031ba708a81d 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -369,6 +369,10 @@ struct io_ring_ctx {
 	struct io_alloc_cache	futex_cache;
 #endif
 
+#ifdef CONFIG_EPOLL
+	struct hlist_head	epoll_list;
+#endif
+
 	const struct cred	*sq_creds;	/* cred used for __io_sq_thread() */
 	struct io_sq_data	*sq_data;	/* if using sq thread polling */
 
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index e11c82638527..a559e1e1544a 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -278,6 +278,7 @@ enum io_uring_op {
 	IORING_OP_FTRUNCATE,
 	IORING_OP_BIND,
 	IORING_OP_LISTEN,
+	IORING_OP_EPOLL_WAIT,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
diff --git a/io_uring/cancel.c b/io_uring/cancel.c
index 0870060bac7c..d1af9496d9b3 100644
--- a/io_uring/cancel.c
+++ b/io_uring/cancel.c
@@ -17,6 +17,7 @@
 #include "timeout.h"
 #include "waitid.h"
 #include "futex.h"
+#include "epoll.h"
 #include "cancel.h"
 
 struct io_cancel {
@@ -128,6 +129,10 @@ int io_try_cancel(struct io_uring_task *tctx, struct io_cancel_data *cd,
 	if (ret != -ENOENT)
 		return ret;
 
+	ret = io_epoll_wait_cancel(ctx, cd, issue_flags);
+	if (ret != -ENOENT)
+		return ret;
+
 	spin_lock(&ctx->completion_lock);
 	if (!(cd->flags & IORING_ASYNC_CANCEL_FD))
 		ret = io_timeout_cancel(ctx, cd);
diff --git a/io_uring/epoll.c b/io_uring/epoll.c
index 7848d9cc073d..8f54bb1c39de 100644
--- a/io_uring/epoll.c
+++ b/io_uring/epoll.c
@@ -11,6 +11,7 @@
 
 #include "io_uring.h"
 #include "epoll.h"
+#include "poll.h"
 
 struct io_epoll {
 	struct file			*file;
@@ -20,6 +21,13 @@ struct io_epoll {
 	struct epoll_event		event;
 };
 
+struct io_epoll_wait {
+	struct file			*file;
+	int				maxevents;
+	struct epoll_event __user	*events;
+	struct wait_queue_entry		wait;
+};
+
 int io_epoll_ctl_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_epoll *epoll = io_kiocb_to_cmd(req, struct io_epoll);
@@ -57,3 +65,138 @@ int io_epoll_ctl(struct io_kiocb *req, unsigned int issue_flags)
 	io_req_set_res(req, ret, 0);
 	return IOU_OK;
 }
+
+static void __io_epoll_finish(struct io_kiocb *req, int res)
+{
+	struct io_epoll_wait *iew = io_kiocb_to_cmd(req, struct io_epoll_wait);
+
+	lockdep_assert_held(&req->ctx->uring_lock);
+
+	epoll_wait_remove(req->file, &iew->wait);
+	hlist_del_init(&req->hash_node);
+	io_req_set_res(req, res, 0);
+	req->io_task_work.func = io_req_task_complete;
+	io_req_task_work_add(req);
+}
+
+static void __io_epoll_cancel(struct io_kiocb *req)
+{
+	__io_epoll_finish(req, -ECANCELED);
+}
+
+static bool __io_epoll_wait_cancel(struct io_kiocb *req)
+{
+	io_poll_mark_cancelled(req);
+	if (io_poll_get_ownership(req))
+		__io_epoll_cancel(req);
+	return true;
+}
+
+bool io_epoll_wait_remove_all(struct io_ring_ctx *ctx, struct io_uring_task *tctx,
+			      bool cancel_all)
+{
+	return io_cancel_remove_all(ctx, tctx, &ctx->epoll_list, cancel_all, __io_epoll_wait_cancel);
+}
+
+int io_epoll_wait_cancel(struct io_ring_ctx *ctx, struct io_cancel_data *cd,
+			 unsigned int issue_flags)
+{
+	return io_cancel_remove(ctx, cd, issue_flags, &ctx->epoll_list, __io_epoll_wait_cancel);
+}
+
+static void io_epoll_retry(struct io_kiocb *req, struct io_tw_state *ts)
+{
+	int v;
+
+	do {
+		v = atomic_read(&req->poll_refs);
+		if (unlikely(v != 1)) {
+			if (WARN_ON_ONCE(!(v & IO_POLL_REF_MASK)))
+				return;
+			if (v & IO_POLL_CANCEL_FLAG) {
+				__io_epoll_cancel(req);
+				return;
+			}
+		}
+		v &= IO_POLL_REF_MASK;
+	} while (atomic_sub_return(v, &req->poll_refs) & IO_POLL_REF_MASK);
+
+	io_req_task_submit(req, ts);
+}
+
+static int io_epoll_execute(struct io_kiocb *req)
+{
+	struct io_epoll_wait *iew = io_kiocb_to_cmd(req, struct io_epoll_wait);
+
+	list_del_init_careful(&iew->wait.entry);
+	if (io_poll_get_ownership(req)) {
+		req->io_task_work.func = io_epoll_retry;
+		io_req_task_work_add(req);
+	}
+
+	return 1;
+}
+
+static __cold int io_epoll_pollfree_wake(struct io_kiocb *req)
+{
+	struct io_epoll_wait *iew = io_kiocb_to_cmd(req, struct io_epoll_wait);
+
+	io_poll_mark_cancelled(req);
+	list_del_init_careful(&iew->wait.entry);
+	io_epoll_execute(req);
+	return 1;
+}
+
+static int io_epoll_wait_fn(struct wait_queue_entry *wait, unsigned mode,
+			    int sync, void *key)
+{
+	struct io_kiocb *req = wait->private;
+	__poll_t mask = key_to_poll(key);
+
+	if (unlikely(mask & POLLFREE))
+		return io_epoll_pollfree_wake(req);
+
+	return io_epoll_execute(req);
+}
+
+int io_epoll_wait_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	struct io_epoll_wait *iew = io_kiocb_to_cmd(req, struct io_epoll_wait);
+
+	if (sqe->off || sqe->rw_flags || sqe->buf_index || sqe->splice_fd_in)
+		return -EINVAL;
+
+	iew->maxevents = READ_ONCE(sqe->len);
+	iew->events = u64_to_user_ptr(READ_ONCE(sqe->addr));
+
+	iew->wait.flags = 0;
+	iew->wait.private = req;
+	iew->wait.func = io_epoll_wait_fn;
+	INIT_LIST_HEAD(&iew->wait.entry);
+	INIT_HLIST_NODE(&req->hash_node);
+	atomic_set(&req->poll_refs, 0);
+	return 0;
+}
+
+int io_epoll_wait(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_epoll_wait *iew = io_kiocb_to_cmd(req, struct io_epoll_wait);
+	struct io_ring_ctx *ctx = req->ctx;
+	int ret;
+
+	io_ring_submit_lock(ctx, issue_flags);
+
+	ret = epoll_queue(req->file, iew->events, iew->maxevents, &iew->wait);
+	if (ret == -EIOCBQUEUED) {
+		if (hlist_unhashed(&req->hash_node))
+			hlist_add_head(&req->hash_node, &ctx->epoll_list);
+		io_ring_submit_unlock(ctx, issue_flags);
+		return IOU_ISSUE_SKIP_COMPLETE;
+	} else if (ret < 0) {
+		req_set_fail(req);
+	}
+	hlist_del_init(&req->hash_node);
+	io_ring_submit_unlock(ctx, issue_flags);
+	io_req_set_res(req, ret, 0);
+	return IOU_OK;
+}
diff --git a/io_uring/epoll.h b/io_uring/epoll.h
index 870cce11ba98..296940d89063 100644
--- a/io_uring/epoll.h
+++ b/io_uring/epoll.h
@@ -1,6 +1,28 @@
 // SPDX-License-Identifier: GPL-2.0
 
+#include "cancel.h"
+
 #if defined(CONFIG_EPOLL)
+int io_epoll_wait_cancel(struct io_ring_ctx *ctx, struct io_cancel_data *cd,
+			 unsigned int issue_flags);
+bool io_epoll_wait_remove_all(struct io_ring_ctx *ctx, struct io_uring_task *tctx,
+			      bool cancel_all);
+
 int io_epoll_ctl_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_epoll_ctl(struct io_kiocb *req, unsigned int issue_flags);
+int io_epoll_wait_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
+int io_epoll_wait(struct io_kiocb *req, unsigned int issue_flags);
+#else
+static inline bool io_epoll_wait_remove_all(struct io_ring_ctx *ctx,
+					    struct io_uring_task *tctx,
+					    bool cancel_all)
+{
+	return false;
+}
+static inline int io_epoll_wait_cancel(struct io_ring_ctx *ctx,
+				       struct io_cancel_data *cd,
+				       unsigned int issue_flags)
+{
+	return 0;
+}
 #endif
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index ec98a0ec6f34..73b9246eaa50 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -93,6 +93,7 @@
 #include "notif.h"
 #include "waitid.h"
 #include "futex.h"
+#include "epoll.h"
 #include "napi.h"
 #include "uring_cmd.h"
 #include "msg_ring.h"
@@ -356,6 +357,9 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	INIT_HLIST_HEAD(&ctx->waitid_list);
 #ifdef CONFIG_FUTEX
 	INIT_HLIST_HEAD(&ctx->futex_list);
+#endif
+#ifdef CONFIG_EPOLL
+	INIT_HLIST_HEAD(&ctx->epoll_list);
 #endif
 	INIT_DELAYED_WORK(&ctx->fallback_work, io_fallback_req_func);
 	INIT_WQ_LIST(&ctx->submit_state.compl_reqs);
@@ -3079,6 +3083,7 @@ static __cold bool io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 	ret |= io_poll_remove_all(ctx, tctx, cancel_all);
 	ret |= io_waitid_remove_all(ctx, tctx, cancel_all);
 	ret |= io_futex_remove_all(ctx, tctx, cancel_all);
+	ret |= io_epoll_wait_remove_all(ctx, tctx, cancel_all);
 	ret |= io_uring_try_cancel_uring_cmd(ctx, tctx, cancel_all);
 	mutex_unlock(&ctx->uring_lock);
 	ret |= io_kill_timeouts(ctx, tctx, cancel_all);
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index e8baef4e5146..44553a657476 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -514,6 +514,17 @@ const struct io_issue_def io_issue_defs[] = {
 		.async_size		= sizeof(struct io_async_msghdr),
 #else
 		.prep			= io_eopnotsupp_prep,
+#endif
+	},
+	[IORING_OP_EPOLL_WAIT] = {
+		.needs_file		= 1,
+		.unbound_nonreg_file	= 1,
+		.audit_skip		= 1,
+#if defined(CONFIG_EPOLL)
+		.prep			= io_epoll_wait_prep,
+		.issue			= io_epoll_wait,
+#else
+		.prep			= io_eopnotsupp_prep,
 #endif
 	},
 };
@@ -745,6 +756,9 @@ const struct io_cold_def io_cold_defs[] = {
 	[IORING_OP_LISTEN] = {
 		.name			= "LISTEN",
 	},
+	[IORING_OP_EPOLL_WAIT] = {
+		.name			= "EPOLL_WAIT",
+	},
 };
 
 const char *io_uring_get_opcode(u8 opcode)
-- 
2.47.2


