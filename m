Return-Path: <io-uring+bounces-6232-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6AE01A2601A
	for <lists+io-uring@lfdr.de>; Mon,  3 Feb 2025 17:32:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D0B5A16721A
	for <lists+io-uring@lfdr.de>; Mon,  3 Feb 2025 16:32:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1382120B20B;
	Mon,  3 Feb 2025 16:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="eDun3atx"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A26B20B1F2
	for <io-uring@vger.kernel.org>; Mon,  3 Feb 2025 16:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738600297; cv=none; b=Yv+qqaiR3lnqrcTOlu0gd0QLBphggbzLiqiq14OVJ0azyZrO8gYBq5kGo5o5jXOduM6yifgfeJe6YDTQ4hCCS9/K87mP9e9myP/+E5lfu2JU14MIynfDhACbdUu/019MvdBCulb4CKkgCQd+iSMOp/E2pX5FeeMo64gqRArMw1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738600297; c=relaxed/simple;
	bh=SiJFHOGW3I3zFqN3kp56SHJQkVmhHehxUSx0Yzr7T3E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SIVf5OHQ6qOA5cgKsZ3fjggEKtCQuyiu1vpJmDedhz1o06dWXahICAMwDcwk7a4jQ3BDvXufa5RjSOtqTFlYfeW+GcQ6eh1uUoDKT9/lYJ4/LOKwQ9JnHzN+ckrfTzLUJw+DROYYs5nEGNxK47S4fRk2c4ObeD16sD2iAvmeyNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=eDun3atx; arc=none smtp.client-ip=209.85.166.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-844ce213af6so125468739f.1
        for <io-uring@vger.kernel.org>; Mon, 03 Feb 2025 08:31:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1738600294; x=1739205094; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0/fjiuRElsEUMm3xq1l9P9axtS1BBAUWMYirAwWU00g=;
        b=eDun3atxS7vxUznNqvzlHscmKmp+culWjhLBvNJamQbJNI3zSSllnwE6H20E5RhVlC
         GdeexBEgDdaMRNCM0Rp/xsAiKCBkwWytUDtmeOf2qjZjDClIS86rNr7jCmP9m3ThkGAD
         adgOQ+QR+e+dKkHlVgbT2H67SmahIgrsqwb9k7hFeB/HZSJJkEYywJAC9x+DKMbNhw95
         8wkvfAy10YfwYLhmM+FvoT1up2XAi/FoX6I93aWMYrr/8NyxiYRy6iPpCSfrO5dS6Dru
         ylXEMNStmLLB4J1BgnhhXJy7PoJayyYxNNKHoX0VSpb0KzFwEgDZTYvF78m3dt+sg9UK
         bq+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738600294; x=1739205094;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0/fjiuRElsEUMm3xq1l9P9axtS1BBAUWMYirAwWU00g=;
        b=YfQziGeH+eM1kvyLRvMYrHEFMaz17LW1T8sYwnrpSldouebxuQKun+9CqLffUCz1DH
         46qcBCxiMOzeqRZmjIMhYEqpMJA/L3iTH2/ODg2gzbpEZDgxInArAio+H+4je5Gh+DFT
         SJwZpihJ8w7RT1EKAVZoc97vljQ0afLyjhBDrVUgaJkZMTZABY3w96y+EOciwlwl9N+I
         dl1Oa7HwITj/vwzRCOdkV/LCWQy+kdyMhLps3P/7iLRtrWmw8WKSBncXI5pWdukgcrq0
         cbqmbzXDOf+l2ewrg0Svn54ebiIXf7XZ97mJJ5U5C+9MX77u3F5Z+FGZjqRfEx7rHJs5
         9tSA==
X-Gm-Message-State: AOJu0Yz5sylBAoTFd6iYTjnREL+ID1/1dJ6LXPUi0qDsQiRMhw0W7xYU
	i+ZBvbK7lVdfDSULkAeTZngNbJcH/e9IA2GZkM4nsZrALGe/ejxQ6Hf+TtLjlLAPwhA1gqGUZjU
	ZT+E=
X-Gm-Gg: ASbGnctM96J4l6IcXDwO/l/w5dvjd9zdDrp1YFlDJD9e3IhsX38uYV3aCNbDvR57rAe
	W34eqytVILmLTsW4U7Me/YC+s0/xHKKwTn/axaYWTFPsa5FhPxvktKlu+jYTAM/HaIi8VA12pDG
	WtzyFp9jkeLXb9E/FjgaOaNcU+7ifAgFB2ip9XkN2X2R+Hi7gU8yXc2mhFci8dQLS02DUGDQ0H3
	GTVGKgBlS+nZ1qJKyPa8nFrbr9/pbybj2fw3ze/P+JoGF6mtwkDQ8hmVse/VD+y/eKQ2ar1tuDt
	ToSbiwrWlF0O4h2zw4k=
X-Google-Smtp-Source: AGHT+IH2wV2mJH512YPftlISVyZWUOTcz9QVi4y2nD/702D7EXmTUdDrOmfIKi7tAhOGaOpiBEGhqg==
X-Received: by 2002:a05:6602:3990:b0:844:debf:24dc with SMTP id ca18e2360f4ac-85411111991mr2269268639f.5.1738600292695;
        Mon, 03 Feb 2025 08:31:32 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-854a16123c6sm243748139f.24.2025.02.03.08.31.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Feb 2025 08:31:31 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org,
	brauner@kernel.org,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 9/9] io_uring/epoll: add multishot support for IORING_OP_EPOLL_WAIT
Date: Mon,  3 Feb 2025 09:23:47 -0700
Message-ID: <20250203163114.124077-10-axboe@kernel.dk>
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

As with other multishot requests, submitting a multishot epoll wait
request will keep it re-armed post the initial trigger. This allows
multiple epoll wait completions per request submitted, every time
events are available. If more completions are expected for this
epoll wait request, then IORING_CQE_F_MORE will be set in the posted
cqe->flags.

For multishot, the request remains on the epoll callback waitqueue
head. This means that epoll doesn't need to juggle the ep->lock
writelock (and disable/enable IRQs) for each invocation of the
reaping loop. That should translate into nice efficiency gains.

Use by setting IORING_EPOLL_WAIT_MULTISHOT in the sqe->epoll_flags
member.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/uapi/linux/io_uring.h |  6 ++++++
 io_uring/epoll.c              | 40 ++++++++++++++++++++++++++---------
 2 files changed, 36 insertions(+), 10 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index a559e1e1544a..93f504b6d4ec 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -73,6 +73,7 @@ struct io_uring_sqe {
 		__u32		futex_flags;
 		__u32		install_fd_flags;
 		__u32		nop_flags;
+		__u32		epoll_flags;
 	};
 	__u64	user_data;	/* data to be passed back at completion time */
 	/* pack this to avoid bogus arm OABI complaints */
@@ -405,6 +406,11 @@ enum io_uring_op {
 #define IORING_ACCEPT_DONTWAIT	(1U << 1)
 #define IORING_ACCEPT_POLL_FIRST	(1U << 2)
 
+/*
+ * epoll_wait flags, stored in sqe->epoll_flags
+ */
+#define IORING_EPOLL_WAIT_MULTISHOT	(1U << 0)
+
 /*
  * IORING_OP_MSG_RING command types, stored in sqe->addr
  */
diff --git a/io_uring/epoll.c b/io_uring/epoll.c
index 2a9c679516c8..730f4b729f5b 100644
--- a/io_uring/epoll.c
+++ b/io_uring/epoll.c
@@ -24,6 +24,7 @@ struct io_epoll {
 struct io_epoll_wait {
 	struct file			*file;
 	int				maxevents;
+	int				flags;
 	struct epoll_event __user	*events;
 	struct wait_queue_entry		wait;
 };
@@ -145,12 +146,15 @@ static void io_epoll_retry(struct io_kiocb *req, struct io_tw_state *ts)
 	io_req_task_submit(req, ts);
 }
 
-static int io_epoll_execute(struct io_kiocb *req)
+static int io_epoll_execute(struct io_kiocb *req, __poll_t mask)
 {
 	struct io_epoll_wait *iew = io_kiocb_to_cmd(req, struct io_epoll_wait);
 
 	if (io_poll_get_ownership(req)) {
-		list_del_init_careful(&iew->wait.entry);
+		if (mask & EPOLL_URING_WAKE)
+			req->flags &= ~REQ_F_APOLL_MULTISHOT;
+		if (!(req->flags & REQ_F_APOLL_MULTISHOT))
+			list_del_init_careful(&iew->wait.entry);
 		req->io_task_work.func = io_epoll_retry;
 		io_req_task_work_add(req);
 		return 1;
@@ -159,13 +163,13 @@ static int io_epoll_execute(struct io_kiocb *req)
 	return 0;
 }
 
-static __cold int io_epoll_pollfree_wake(struct io_kiocb *req)
+static __cold int io_epoll_pollfree_wake(struct io_kiocb *req, __poll_t mask)
 {
 	struct io_epoll_wait *iew = io_kiocb_to_cmd(req, struct io_epoll_wait);
 
 	io_poll_mark_cancelled(req);
 	list_del_init_careful(&iew->wait.entry);
-	io_epoll_execute(req);
+	io_epoll_execute(req, mask);
 	return 1;
 }
 
@@ -176,18 +180,23 @@ static int io_epoll_wait_fn(struct wait_queue_entry *wait, unsigned mode,
 	__poll_t mask = key_to_poll(key);
 
 	if (unlikely(mask & POLLFREE))
-		return io_epoll_pollfree_wake(req);
+		return io_epoll_pollfree_wake(req, mask);
 
-	return io_epoll_execute(req);
+	return io_epoll_execute(req, mask);
 }
 
 int io_epoll_wait_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_epoll_wait *iew = io_kiocb_to_cmd(req, struct io_epoll_wait);
 
-	if (sqe->off || sqe->rw_flags || sqe->buf_index || sqe->splice_fd_in)
+	if (sqe->off || sqe->buf_index || sqe->splice_fd_in)
 		return -EINVAL;
 
+	iew->flags = READ_ONCE(sqe->epoll_flags);
+	if (iew->flags & ~IORING_EPOLL_WAIT_MULTISHOT)
+		return -EINVAL;
+	else if (iew->flags & IORING_EPOLL_WAIT_MULTISHOT)
+		req->flags |= REQ_F_APOLL_MULTISHOT;
 	iew->maxevents = READ_ONCE(sqe->len);
 	iew->events = u64_to_user_ptr(READ_ONCE(sqe->addr));
 
@@ -195,6 +204,7 @@ int io_epoll_wait_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	iew->wait.private = req;
 	iew->wait.func = io_epoll_wait_fn;
 	INIT_LIST_HEAD(&iew->wait.entry);
+	INIT_HLIST_NODE(&req->hash_node);
 	atomic_set(&req->poll_refs, 0);
 	return 0;
 }
@@ -205,9 +215,11 @@ int io_epoll_wait(struct io_kiocb *req, unsigned int issue_flags)
 	struct io_ring_ctx *ctx = req->ctx;
 	int ret;
 
-	io_ring_submit_lock(ctx, issue_flags);
-	hlist_add_head(&req->hash_node, &ctx->epoll_list);
-	io_ring_submit_unlock(ctx, issue_flags);
+	if (hlist_unhashed(&req->hash_node)) {
+		io_ring_submit_lock(ctx, issue_flags);
+		hlist_add_head(&req->hash_node, &ctx->epoll_list);
+		io_ring_submit_unlock(ctx, issue_flags);
+	}
 
 	/*
 	 * Timeout is fake here, it doesn't indicate any kind of sleep time.
@@ -219,9 +231,17 @@ int io_epoll_wait(struct io_kiocb *req, unsigned int issue_flags)
 		return IOU_ISSUE_SKIP_COMPLETE;
 	else if (ret < 0)
 		req_set_fail(req);
+
+	if (ret >= 0 && req->flags & REQ_F_APOLL_MULTISHOT &&
+	    io_req_post_cqe(req, ret, IORING_CQE_F_MORE))
+		return IOU_ISSUE_SKIP_COMPLETE;
+
 	io_ring_submit_lock(ctx, issue_flags);
 	hlist_del_init(&req->hash_node);
 	io_ring_submit_unlock(ctx, issue_flags);
 	io_req_set_res(req, ret, 0);
+
+	if (issue_flags & IO_URING_F_MULTISHOT)
+		return IOU_STOP_MULTISHOT;
 	return IOU_OK;
 }
-- 
2.47.2


