Return-Path: <io-uring+bounces-6231-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A73FA26019
	for <lists+io-uring@lfdr.de>; Mon,  3 Feb 2025 17:32:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 733451672DE
	for <lists+io-uring@lfdr.de>; Mon,  3 Feb 2025 16:31:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B21EA20B1E6;
	Mon,  3 Feb 2025 16:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Qn/rhjzR"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C63A620B803
	for <io-uring@vger.kernel.org>; Mon,  3 Feb 2025 16:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738600294; cv=none; b=AbicXWdEKXuZp7mzMlzQlB1wmPY1q7CuOu/MRxMQW7xBASYTsTyZxMxj1OT6XLr1LFdQLkIbS8A8Q864Ykre96PiYKT3SXhTgO1m2qMDzENnGHf88aVqh1Pce1wSe7fjopXvDYFUL9+UoBfXaZdZ53MLbBIjRMhtLblfkI9ALzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738600294; c=relaxed/simple;
	bh=CMTEnTPWpb05BVNxeVZlHIui6WHm7CkjMUZktWehDB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hdQ6sUKvwpnvaNnBTvaFZPqUnKYKYVbFfNL31y/F9YnfB84eKIxLoki3rRm9YRSHse8Oraz4Ns4FYzqOdg0oOX/smoMhAtK4v9+mdioifsnnyhTXSjz3RRECEWGiZ6NmE6fHLqqlw/jluXVvzw4wa7LoBJuRduN4+J6o0eXyx3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Qn/rhjzR; arc=none smtp.client-ip=209.85.166.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-844e10ef3cfso328011039f.2
        for <io-uring@vger.kernel.org>; Mon, 03 Feb 2025 08:31:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1738600291; x=1739205091; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K+AXd57b1JzBRkx41X4hZ11sGTsVxTuoF3YRV66XCYw=;
        b=Qn/rhjzRs4X75LGahxyx+RRkNnVmbBGzs0MawPHukZ5PchEG2Lu5foDXVr3v2N+tb1
         4ilnPdVFYN+ytlhqnsBo4ZCaxMUEzssHwNypWnvvnIKsbhO8ZsdxRqZIr9c3sYhVic0W
         iTh29BQlJjLBYak2TYtbJL6fwUxoHlTmfuSAiy1TNSyqlEiswjooN+C+EPkTCqkHaxW1
         SLHwRMtgzKv+Vm1FEJY6VES7sL2OJZOH0n11H9V7eyyAwfzKXlCmK+USSa+SZEHQ6AG5
         DB3MVKeP113Lh2g+fuUK0PHATbUlKaWqVIbGFszky8S1dg0/diAVr5/fC1rASOLduISI
         62Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738600291; x=1739205091;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=K+AXd57b1JzBRkx41X4hZ11sGTsVxTuoF3YRV66XCYw=;
        b=Gicka/0mBCe2YuwSLtxNgQ2CJM6Zr8B5ms5QEoA3iuGtrY2DVPMRB65gHyZMCnUUrm
         TTFvOretYoX531CJ+7NLkE2BbjS+cZTfDYnRuUWg3wnQn693Y22epjrnqHtodx3A0jKx
         wLF5yGM6ofiO7cAwLy1BdZg0yeTWvlr5FYMcJGyQMEijsh+VYDosSNIyz86M7WlLnOfv
         EUnO7UFig8tsomtakIFgMzbwjWN7i9H+cMuBHz1wCPlhXCssjYiW1HrOw7qNaiSnozMs
         tFzxO6QOfbouz/SgVwntdCIp/uN81HjLCbDRbBfi1fGpb9ekmxXQegiWOOYQ/6XFSEEl
         4VAQ==
X-Gm-Message-State: AOJu0Yzd+1tcDJ0ynxiEEQglCvFmHE8jSgt9flAvLOZXZgJHomkLo0pf
	/+sbAJEzaePc1GA4mIwBqPr58qA2ELEF+pYV1vRNaADbaL/s+J5MFZcI2WnTgNY3ZhtF8lv/ohl
	Rkac=
X-Gm-Gg: ASbGncuJJGSiLhs5CSUvPgfbTnSZxrCWe1BmYXFP3OZms3DmbPNbLBOOJcZcXZLhtb9
	43qUWI8wBYWREg2nsBDZMGtjvDOh5AZWtFb916ZfWrZtXNdNY3Gco2aKrJukoP9P2+C1WQtK0Vo
	HbhoblrEFY4AV9tQX2ohXsW03aUt0n1NcjRdcZf1R4rU712Cn3XR8LN0lkxxZoldsj6ZbFTg7rW
	rS8aTL+/cy2J7n3V0Rq3r5wX+We6vH9GC9vCYLQYoFqA7CG+CTslS4yJ/Wmx47LWaToSsZDfqNs
	Az3eXgktQxA3u6lGux8=
X-Google-Smtp-Source: AGHT+IF07yJPQjHqGkR2Cwji/yqUbjc61jgaBnPgFRqP63HHV9IkZQsnLBjH7Osln4jmhTHcVdSujQ==
X-Received: by 2002:a05:6602:1696:b0:849:c82e:c084 with SMTP id ca18e2360f4ac-854111121f5mr2081287439f.6.1738600291215;
        Mon, 03 Feb 2025 08:31:31 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-854a16123c6sm243748139f.24.2025.02.03.08.31.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Feb 2025 08:31:30 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org,
	brauner@kernel.org,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 8/9] io_uring/epoll: add support for IORING_OP_EPOLL_WAIT
Date: Mon,  3 Feb 2025 09:23:46 -0700
Message-ID: <20250203163114.124077-9-axboe@kernel.dk>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250203163114.124077-1-axboe@kernel.dk>
References: <20250203163114.124077-1-axboe@kernel.dk>
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
 io_uring/epoll.c               | 168 +++++++++++++++++++++++++++++++++
 io_uring/epoll.h               |  22 +++++
 io_uring/io_uring.c            |   5 +
 io_uring/opdef.c               |  14 +++
 7 files changed, 219 insertions(+)

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
index 7848d9cc073d..2a9c679516c8 100644
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
@@ -57,3 +65,163 @@ int io_epoll_ctl(struct io_kiocb *req, unsigned int issue_flags)
 	io_req_set_res(req, ret, 0);
 	return IOU_OK;
 }
+
+static void __io_epoll_cancel(struct io_kiocb *req)
+{
+	struct io_epoll_wait *iew = io_kiocb_to_cmd(req, struct io_epoll_wait);
+
+	epoll_wait_remove(req->file, &iew->wait);
+	hlist_del_init(&req->hash_node);
+	io_req_set_res(req, -ECANCELED, 0);
+	req->io_task_work.func = io_req_task_complete;
+	io_req_task_work_add(req);
+}
+
+static void __io_epoll_wait_cancel(struct io_kiocb *req)
+{
+	io_poll_mark_cancelled(req);
+	if (io_poll_get_ownership(req)) {
+		__io_epoll_cancel(req);
+		io_req_set_res(req, -ECANCELED, 0);
+		req->io_task_work.func = io_req_task_complete;
+		io_req_task_work_add(req);
+	}
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
+	if (io_poll_get_ownership(req)) {
+		list_del_init_careful(&iew->wait.entry);
+		req->io_task_work.func = io_epoll_retry;
+		io_req_task_work_add(req);
+		return 1;
+	}
+
+	return 0;
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
+	hlist_add_head(&req->hash_node, &ctx->epoll_list);
+	io_ring_submit_unlock(ctx, issue_flags);
+
+	/*
+	 * Timeout is fake here, it doesn't indicate any kind of sleep time.
+	 * It's just set to something that is non-zero, so that wait queue
+	 * wakeup is armed if no events are available.
+	 */
+	ret = epoll_wait(req->file, iew->events, iew->maxevents, NULL, &iew->wait);
+	if (ret == -EIOCBQUEUED)
+		return IOU_ISSUE_SKIP_COMPLETE;
+	else if (ret < 0)
+		req_set_fail(req);
+	io_ring_submit_lock(ctx, issue_flags);
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
index 2f311aeb536f..a17abdbae7ee 100644
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
@@ -3095,6 +3099,7 @@ static __cold bool io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
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


