Return-Path: <io-uring+bounces-6262-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 33BF8A27BEB
	for <lists+io-uring@lfdr.de>; Tue,  4 Feb 2025 20:49:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A160A3A15B9
	for <lists+io-uring@lfdr.de>; Tue,  4 Feb 2025 19:49:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8668621A44F;
	Tue,  4 Feb 2025 19:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="wUYGxhdq"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f171.google.com (mail-il1-f171.google.com [209.85.166.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9655E21A443
	for <io-uring@vger.kernel.org>; Tue,  4 Feb 2025 19:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738698512; cv=none; b=FssTp2WbwHtbXJTEqKVToH2XmvL/EI17lAs0amPGQb/QF3s4c2qYZl2np2jq6p5CfAOQKSKtx2iyZtZ/0aRyD/86xTwbmKv0a/JK4rpieH5pix9jZ8FUZ1BsxU0G4CKVvrPuGM2Wxg1mnrQJ8vTeuKcOcycPGDh14Q/rRWyA/W8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738698512; c=relaxed/simple;
	bh=Rzi4n7BnGBjUIYN0OxwHtFC3zQZ/7IVkoBCMx/gBgAw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rzP5nKl/BdQ1o/3+T1okJZ6qhnjTQVSEPaLiyh2qVtBNvQ8aCTidwbw6JZPxfQMlTqpkNQ4h/R+VBN21cs59NedGgHt/Xp726tcChAqII2/Sy0sIRYWnvhH/tlO2uAGdt0LF3qJcvDLUaa648cPAMYA3dejHmHEnC1YhLlZtT4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=wUYGxhdq; arc=none smtp.client-ip=209.85.166.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f171.google.com with SMTP id e9e14a558f8ab-3ce886a2d5bso50610915ab.1
        for <io-uring@vger.kernel.org>; Tue, 04 Feb 2025 11:48:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1738698509; x=1739303309; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NI6IDh8GTM14O03ITyxFHnMkqCbc9YajSaStyhMKY54=;
        b=wUYGxhdqBlckqeYszEpke9XaBMzvqX6gTTWjLzNEnkFNWSNbanp2Nhai7Xr6DRT5Qq
         TX1WMXZR/5YXQ83cRrqa652nwYRg8FmgfGTZ0u2I52T6psehwO45cxyNYNGDW40Dwcwk
         GUaAZdSQkO+TfvqPPSfZgfo/Wnh2U9g3/bLoKYLQH6Qi+T2fHhgiRpwY8OaaPuj+hNJt
         L1OKB79sAzZnQiqUFRr8rm+3ZLPH7W08BnK9UFPqHYpmdEQVK4NdmBiQNh9hUt1Io9qb
         o6SVe/YtFHEH3pA+rjh3LeC9kdImxog4JZlPRz8Sf7ClZt0PXTLQxN8ves4U7EIaCzrM
         ifxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738698509; x=1739303309;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NI6IDh8GTM14O03ITyxFHnMkqCbc9YajSaStyhMKY54=;
        b=XNujPsJR6UFgX570qt5eYjMqTmZElcV89i4xBMjVQrWm5OngrhtbHsdMJGkKr/T3y3
         ON3XYguUD5ltFx7vywV+zuX/UkAWl8uPjyDUOEuGtslAj7zUaFGU2pN0MNtrCHcvAvN6
         1NEG0g3q2FS00U3GKkKHezSKa6X+10G+7fC/fVGdKYK+yWyve6m/3NlvlL3PcgCAwW7T
         jU1m9E1VbXEk1Y6mM/0sJyqjmzaZMPoAN9Ha+fOcydZTxflB25kYf4hyVkRPdISQvOeG
         QOZP8tLrzZPGZVyjluIBv8VwvCNcluowk9PE/FidTDF2PcQRD0YRP3/6V9+9O27/Llcm
         Z4Sg==
X-Gm-Message-State: AOJu0Yykcq4I4ncDSMkT1KRpCY1UqyMBuqwIl2pF1jkneGWXtIBzk3b5
	tPZ5wThwdN0Dxu22WNRrXZlPUQxnSqYQD2qUX9ISS4qq7Rkxdvm+K3rrKj1pUImLmNYvB9vLiJ0
	7
X-Gm-Gg: ASbGncsNYWfJDPLSqJ5HYFHdAhRIz06OLT/+UB9kUuBDyInq0jlLzdeM8BSIlyKbcr+
	ZvH9tp0RLDFUR3Tzlwz1+DQ7s/tFFU1gNarNSyr7NVOo45rlCqWtI/Eyb29i88eg8VPWacD7NOL
	bYSnshtlywH8CWYZwINcBjXiZvazmik0N/8uHwqbnSKZ0lG006pd/JEFjSb2zn/BzEiYC1D4Yvc
	6axikdYphFCqrSOGek3vjOLAlbAOVF/WWEfDgoIhjAFgN/Q6+wl6BZfpuU+ChJnVu+Bwstw87Ao
	0DWUmD+2ttEkeKFM28M=
X-Google-Smtp-Source: AGHT+IGk/L0GfIidAS69VEUawevznso8/J9/9a0NNkUKQpGh8FZKaQywp1szfXpo+wo39blZLaGRNw==
X-Received: by 2002:a05:6e02:1989:b0:3cf:b6c9:5fc9 with SMTP id e9e14a558f8ab-3d04f417460mr2712465ab.8.1738698509070;
        Tue, 04 Feb 2025 11:48:29 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ec746c95c4sm2841466173.127.2025.02.04.11.48.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2025 11:48:28 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org,
	brauner@kernel.org,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 09/11] io_uring/epoll: add support for IORING_OP_EPOLL_WAIT
Date: Tue,  4 Feb 2025 12:46:43 -0700
Message-ID: <20250204194814.393112-10-axboe@kernel.dk>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250204194814.393112-1-axboe@kernel.dk>
References: <20250204194814.393112-1-axboe@kernel.dk>
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
 io_uring/cancel.c              |   5 +
 io_uring/epoll.c               | 169 +++++++++++++++++++++++++++++++++
 io_uring/epoll.h               |  22 +++++
 io_uring/io_uring.c            |   5 +
 io_uring/opdef.c               |  14 +++
 7 files changed, 220 insertions(+)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 3def525a1da3..ee56992d31d5 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -370,6 +370,10 @@ struct io_ring_ctx {
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
index 484193567839..9cebd0145cb4 100644
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
index 7848d9cc073d..5a47f0cce647 100644
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
@@ -57,3 +65,164 @@ int io_epoll_ctl(struct io_kiocb *req, unsigned int issue_flags)
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
+static void __io_epoll_wait_cancel(struct io_kiocb *req)
+{
+	io_poll_mark_cancelled(req);
+	if (io_poll_get_ownership(req))
+		__io_epoll_cancel(req);
+}
+
+bool io_epoll_wait_remove_all(struct io_ring_ctx *ctx, struct io_uring_task *tctx,
+			      bool cancel_all)
+{
+	struct hlist_node *tmp;
+	struct io_kiocb *req;
+	bool found = false;
+
+	lockdep_assert_held(&ctx->uring_lock);
+
+	hlist_for_each_entry_safe(req, tmp, &ctx->epoll_list, hash_node) {
+		if (!io_match_task_safe(req, tctx, cancel_all))
+			continue;
+		__io_epoll_wait_cancel(req);
+		found = true;
+	}
+
+	return found;
+}
+
+int io_epoll_wait_cancel(struct io_ring_ctx *ctx, struct io_cancel_data *cd,
+			 unsigned int issue_flags)
+{
+	struct hlist_node *tmp;
+	struct io_kiocb *req;
+	int nr = 0;
+
+	io_ring_submit_lock(ctx, issue_flags);
+	hlist_for_each_entry_safe(req, tmp, &ctx->epoll_list, hash_node) {
+		if (!io_cancel_req_match(req, cd))
+			continue;
+		__io_epoll_wait_cancel(req);
+		nr++;
+	}
+	io_ring_submit_unlock(ctx, issue_flags);
+	return nr ?: -ENOENT;
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
+			if (v & IO_POLL_FINISH_FLAG)
+				return;
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
+	ret = epoll_wait(req->file, iew->events, iew->maxevents, NULL, &iew->wait);
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
index e34a92c73a5d..78375981907d 100644
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
@@ -358,6 +359,9 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	INIT_HLIST_HEAD(&ctx->waitid_list);
 #ifdef CONFIG_FUTEX
 	INIT_HLIST_HEAD(&ctx->futex_list);
+#endif
+#ifdef CONFIG_EPOLL
+	INIT_HLIST_HEAD(&ctx->epoll_list);
 #endif
 	INIT_DELAYED_WORK(&ctx->fallback_work, io_fallback_req_func);
 	INIT_WQ_LIST(&ctx->submit_state.compl_reqs);
@@ -3084,6 +3088,7 @@ static __cold bool io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
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


