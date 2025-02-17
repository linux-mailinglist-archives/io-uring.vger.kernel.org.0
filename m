Return-Path: <io-uring+bounces-6478-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 00394A379B5
	for <lists+io-uring@lfdr.de>; Mon, 17 Feb 2025 03:25:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 14F7D3AAB5D
	for <lists+io-uring@lfdr.de>; Mon, 17 Feb 2025 02:25:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00EBE7DA66;
	Mon, 17 Feb 2025 02:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="EgBsKQn+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f98.google.com (mail-pj1-f98.google.com [209.85.216.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7930329D0E
	for <io-uring@vger.kernel.org>; Mon, 17 Feb 2025 02:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739759122; cv=none; b=MdLy2olNyp2JQ3eXfOHQVWGtInCpgLPb8AMCIN4R3ZfSOFdLZ1YD/G7Rc4Xifzx1IgT/XvAVywM6wOrNIwkESDiJRGudNY/rl4XOBI7iHPFmwoSGVAwkXHbSYLHeVw1AdJ06JSXDO4ejAECBgu/11V2VbbiZQv+3Zdi+k20A1dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739759122; c=relaxed/simple;
	bh=nlVXIMrpsnmQyGgRJtUzjmd0EwMi6IV4rs8GnFovCUc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=guG5Xar+WyYY8QC9YcWZ7FSaMdV4asappkBICDkoxIDL/ibipJqq+Ys+QB4u6FIvblw4Rig/TENthis3WxuGZWYNrp1uTHlaUqHotllTnm+avF4b3X2J7ZKqUbEYSSSRhtoXA4fm/55duz8pR6vzYVfYHTHeopB22zF66pcNRmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=EgBsKQn+; arc=none smtp.client-ip=209.85.216.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pj1-f98.google.com with SMTP id 98e67ed59e1d1-2fc383a11cdso572961a91.2
        for <io-uring@vger.kernel.org>; Sun, 16 Feb 2025 18:25:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1739759119; x=1740363919; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=cw2INvVRBw7Ib4jV3MdgYad7yCM8jTSrd1Tm773Yjw0=;
        b=EgBsKQn+uf72KAJ39RNgW3fZwgBtSjBa2gq9xqzmgw6EwcFnjZ3Cjey5sYRqxfcAGf
         jUWtfnV96mTO0wFBDHQWBw0cyg9uSJhLFJyC2rIMC/e4aQ9x3Zc+GeeEcmile4AZRW22
         ycIeB8VeHqz6K5dd17Z1WG0iPEVBXOBriNaOcsB/PyCQCoxe/tg0mmirW1pNIVAv9jak
         Aj4h6BhAU4Hs3sk9s6AfoRW2ig6gccCCMQ1JiSgsRZhrafsQwxvDhqJtVHvsvrbjpOt1
         jRshkFYAEHglzsNlLcHRCL2+YVUK1DSkBbBDXFRws9PVF9OLVWFUborwrYf8+0zvCubm
         hUPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739759119; x=1740363919;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cw2INvVRBw7Ib4jV3MdgYad7yCM8jTSrd1Tm773Yjw0=;
        b=sMkj6u2AccRQHFEnL9o8w3nF1QKH91Ek2tnwudCa/ZDcUs7pEVV/nhaQegRMa20J8B
         1tsTvHTdPwStAWviSbT73hErJ5hearETixNHuCi2GM6QV7Cqu6Di4XDB0ueLF7YyOZqh
         ul34LJ7LLXEbgTIEd1g7YGGv1h/x1NA0xPR2m5O8u3hW905QSX8hT7LoUhpZVsUfRMS3
         CpbVuuc6nbvOLgnvBWvp6w7rD2YExNZh/Ij6ChdtQmxBenTDhm0oQJvdXEg7H7gJDHOA
         vEkGU70YKwARpveZPXoUWGBDHTpzcPf7IXRbX7hPdn0xxW4HXpEE/Ad5ddOjnZj/q+3V
         d8Ug==
X-Forwarded-Encrypted: i=1; AJvYcCUhibkj+eJ53Hv9RxCtG6GfzFgJpI3vgmU31xFTnACnzkZgrj1IrF/P2w2MDoODfln07fxjQBPUZw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxZ+cUPX+Pk9Dw8efAkCMSMfVpcjApaF4wkDkP/qTgm6s6Bc2lp
	OKIe23yIsmQqepWRlY2L17rqHlIMgrt524lr8es+4UsliNvhTgCyz/844F6foh1JtmJOGNVWBU1
	kIp6o3ZMnQKX5GzFMf1ntpCUmKEWP+5zV
X-Gm-Gg: ASbGncvaXkUonwe+Gs0urjiFUjM/GjUKbDnz/+qIG7IggQ27Hq+3Iwqh1jluuqWDYBX
	xSfaoIPuDRk/FZqlATsFkZyHOpv9rAMiSKbYEOUFsYQM8+KdnBQkLSO7tkqsA2JsEZG9F8NH/58
	skg3IGAK6dcLSUzhXI2oCeRPsvNpBv5Ky+Pkijxhlz+Cu1qktxYVfKTBlilLRTjEjJG4TJWOHON
	2txLg5QR4jnv6pIjtK0KbYIz/qVMLVJgzMAFV2XGleXbDHs4oVlVBgbih3Am5OgfpXyLWjW5L+O
	z8W+4Xb3hs7XytJN7GoJQcZoaGrXDsOMGB80MA==
X-Google-Smtp-Source: AGHT+IF5XZVyAk+9gEre4hPmBRVLb+5q6XuiNe2D8V1KKqvx/yreeUu/uRONDImj1zyohfbyXaS8HoZUbAPz
X-Received: by 2002:a17:90b:33c6:b0:2fc:34a8:d324 with SMTP id 98e67ed59e1d1-2fc41045e73mr4850470a91.4.1739759119495;
        Sun, 16 Feb 2025 18:25:19 -0800 (PST)
Received: from c7-smtp-2023.dev.purestorage.com ([208.88.159.129])
        by smtp-relay.gmail.com with ESMTPS id d9443c01a7336-220d530826csm4157545ad.37.2025.02.16.18.25.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Feb 2025 18:25:19 -0800 (PST)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.7.70.37])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id D07A8340357;
	Sun, 16 Feb 2025 19:25:18 -0700 (MST)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id CB412E4155E; Sun, 16 Feb 2025 19:25:18 -0700 (MST)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Cc: Caleb Sander Mateos <csander@purestorage.com>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] io_uring: introduce type alias for io_tw_state
Date: Sun, 16 Feb 2025 19:25:04 -0700
Message-ID: <20250217022511.1150145-1-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In preparation for changing how io_tw_state is passed, introduce a type
alias io_tw_token_t for struct io_tw_state *. This allows for changing
the representation in one place, without having to update the many
functions that just forward their struct io_tw_state * argument.

Also add a comment to struct io_tw_state to explain its purpose.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
---
 include/linux/io_uring_types.h |  9 ++++++++-
 io_uring/futex.c               | 16 ++++++++--------
 io_uring/io_uring.c            | 28 ++++++++++++++--------------
 io_uring/io_uring.h            |  8 ++++----
 io_uring/msg_ring.c            |  2 +-
 io_uring/notif.c               |  4 ++--
 io_uring/poll.c                | 18 +++++++++---------
 io_uring/poll.h                |  4 +++-
 io_uring/rw.c                  |  4 ++--
 io_uring/rw.h                  |  3 ++-
 io_uring/timeout.c             | 16 ++++++++--------
 io_uring/uring_cmd.c           |  2 +-
 io_uring/waitid.c              |  8 ++++----
 13 files changed, 66 insertions(+), 56 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index e2fef264ff8b..ea4694ee9d19 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -434,12 +434,19 @@ struct io_ring_ctx {
 	struct io_mapped_region		ring_region;
 	/* used for optimised request parameter and wait argument passing  */
 	struct io_mapped_region		param_region;
 };
 
+/*
+ * Token indicating function is called in task work context:
+ * ctx->uring_lock is held and any completions generated will be flushed.
+ * ONLY core io_uring.c should instantiate this struct.
+ */
 struct io_tw_state {
 };
+/* Alias to use in code that doesn't instantiate struct io_tw_state */
+typedef struct io_tw_state *io_tw_token_t;
 
 enum {
 	REQ_F_FIXED_FILE_BIT	= IOSQE_FIXED_FILE_BIT,
 	REQ_F_IO_DRAIN_BIT	= IOSQE_IO_DRAIN_BIT,
 	REQ_F_LINK_BIT		= IOSQE_IO_LINK_BIT,
@@ -561,11 +568,11 @@ enum {
 	REQ_F_BUF_NODE		= IO_REQ_FLAG(REQ_F_BUF_NODE_BIT),
 	/* request has read/write metadata assigned */
 	REQ_F_HAS_METADATA	= IO_REQ_FLAG(REQ_F_HAS_METADATA_BIT),
 };
 
-typedef void (*io_req_tw_func_t)(struct io_kiocb *req, struct io_tw_state *ts);
+typedef void (*io_req_tw_func_t)(struct io_kiocb *req, io_tw_token_t tw);
 
 struct io_task_work {
 	struct llist_node		node;
 	io_req_tw_func_t		func;
 };
diff --git a/io_uring/futex.c b/io_uring/futex.c
index 54b9760f2aa6..95d4e59674eb 100644
--- a/io_uring/futex.c
+++ b/io_uring/futex.c
@@ -42,34 +42,34 @@ bool io_futex_cache_init(struct io_ring_ctx *ctx)
 void io_futex_cache_free(struct io_ring_ctx *ctx)
 {
 	io_alloc_cache_free(&ctx->futex_cache, kfree);
 }
 
-static void __io_futex_complete(struct io_kiocb *req, struct io_tw_state *ts)
+static void __io_futex_complete(struct io_kiocb *req, io_tw_token_t tw)
 {
 	req->async_data = NULL;
 	hlist_del_init(&req->hash_node);
-	io_req_task_complete(req, ts);
+	io_req_task_complete(req, tw);
 }
 
-static void io_futex_complete(struct io_kiocb *req, struct io_tw_state *ts)
+static void io_futex_complete(struct io_kiocb *req, io_tw_token_t tw)
 {
 	struct io_futex_data *ifd = req->async_data;
 	struct io_ring_ctx *ctx = req->ctx;
 
-	io_tw_lock(ctx, ts);
+	io_tw_lock(ctx, tw);
 	if (!io_alloc_cache_put(&ctx->futex_cache, ifd))
 		kfree(ifd);
-	__io_futex_complete(req, ts);
+	__io_futex_complete(req, tw);
 }
 
-static void io_futexv_complete(struct io_kiocb *req, struct io_tw_state *ts)
+static void io_futexv_complete(struct io_kiocb *req, io_tw_token_t tw)
 {
 	struct io_futex *iof = io_kiocb_to_cmd(req, struct io_futex);
 	struct futex_vector *futexv = req->async_data;
 
-	io_tw_lock(req->ctx, ts);
+	io_tw_lock(req->ctx, tw);
 
 	if (!iof->futexv_unqueued) {
 		int res;
 
 		res = futex_unqueue_multiple(futexv, iof->futex_nr);
@@ -77,11 +77,11 @@ static void io_futexv_complete(struct io_kiocb *req, struct io_tw_state *ts)
 			io_req_set_res(req, res, 0);
 	}
 
 	kfree(req->async_data);
 	req->flags &= ~REQ_F_ASYNC_DATA;
-	__io_futex_complete(req, ts);
+	__io_futex_complete(req, tw);
 }
 
 static bool io_futexv_claim(struct io_futex *iof)
 {
 	if (test_bit(0, &iof->futexv_owned) ||
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 4a0944a57d96..b44ff8871725 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -541,11 +541,11 @@ static void io_queue_iowq(struct io_kiocb *req)
 	io_wq_enqueue(tctx->io_wq, &req->work);
 	if (link)
 		io_queue_linked_timeout(link);
 }
 
-static void io_req_queue_iowq_tw(struct io_kiocb *req, struct io_tw_state *ts)
+static void io_req_queue_iowq_tw(struct io_kiocb *req, io_tw_token_t tw)
 {
 	io_queue_iowq(req);
 }
 
 void io_req_queue_iowq(struct io_kiocb *req)
@@ -1020,11 +1020,11 @@ static inline struct io_kiocb *io_req_find_next(struct io_kiocb *req)
 	nxt = req->link;
 	req->link = NULL;
 	return nxt;
 }
 
-static void ctx_flush_and_put(struct io_ring_ctx *ctx, struct io_tw_state *ts)
+static void ctx_flush_and_put(struct io_ring_ctx *ctx, io_tw_token_t tw)
 {
 	if (!ctx)
 		return;
 	if (ctx->flags & IORING_SETUP_TASKRUN_FLAG)
 		atomic_andnot(IORING_SQ_TASKRUN, &ctx->rings->sq_flags);
@@ -1275,31 +1275,31 @@ static bool io_run_local_work_continue(struct io_ring_ctx *ctx, int events,
 		atomic_or(IORING_SQ_TASKRUN, &ctx->rings->sq_flags);
 	return false;
 }
 
 static int __io_run_local_work_loop(struct llist_node **node,
-				    struct io_tw_state *ts,
+				    io_tw_token_t tw,
 				    int events)
 {
 	int ret = 0;
 
 	while (*node) {
 		struct llist_node *next = (*node)->next;
 		struct io_kiocb *req = container_of(*node, struct io_kiocb,
 						    io_task_work.node);
 		INDIRECT_CALL_2(req->io_task_work.func,
 				io_poll_task_func, io_req_rw_complete,
-				req, ts);
+				req, tw);
 		*node = next;
 		if (++ret >= events)
 			break;
 	}
 
 	return ret;
 }
 
-static int __io_run_local_work(struct io_ring_ctx *ctx, struct io_tw_state *ts,
+static int __io_run_local_work(struct io_ring_ctx *ctx, io_tw_token_t tw,
 			       int min_events, int max_events)
 {
 	struct llist_node *node;
 	unsigned int loops = 0;
 	int ret = 0;
@@ -1308,20 +1308,20 @@ static int __io_run_local_work(struct io_ring_ctx *ctx, struct io_tw_state *ts,
 		return -EEXIST;
 	if (ctx->flags & IORING_SETUP_TASKRUN_FLAG)
 		atomic_andnot(IORING_SQ_TASKRUN, &ctx->rings->sq_flags);
 again:
 	min_events -= ret;
-	ret = __io_run_local_work_loop(&ctx->retry_llist.first, ts, max_events);
+	ret = __io_run_local_work_loop(&ctx->retry_llist.first, tw, max_events);
 	if (ctx->retry_llist.first)
 		goto retry_done;
 
 	/*
 	 * llists are in reverse order, flip it back the right way before
 	 * running the pending items.
 	 */
 	node = llist_reverse_order(llist_del_all(&ctx->work_llist));
-	ret += __io_run_local_work_loop(&node, ts, max_events - ret);
+	ret += __io_run_local_work_loop(&node, tw, max_events - ret);
 	ctx->retry_llist.first = node;
 	loops++;
 
 	if (io_run_local_work_continue(ctx, ret, min_events))
 		goto again;
@@ -1355,19 +1355,19 @@ static int io_run_local_work(struct io_ring_ctx *ctx, int min_events,
 	ret = __io_run_local_work(ctx, &ts, min_events, max_events);
 	mutex_unlock(&ctx->uring_lock);
 	return ret;
 }
 
-static void io_req_task_cancel(struct io_kiocb *req, struct io_tw_state *ts)
+static void io_req_task_cancel(struct io_kiocb *req, io_tw_token_t tw)
 {
-	io_tw_lock(req->ctx, ts);
+	io_tw_lock(req->ctx, tw);
 	io_req_defer_failed(req, req->cqe.res);
 }
 
-void io_req_task_submit(struct io_kiocb *req, struct io_tw_state *ts)
+void io_req_task_submit(struct io_kiocb *req, io_tw_token_t tw)
 {
-	io_tw_lock(req->ctx, ts);
+	io_tw_lock(req->ctx, tw);
 	if (unlikely(io_should_terminate_tw()))
 		io_req_defer_failed(req, -EFAULT);
 	else if (req->flags & REQ_F_FORCE_ASYNC)
 		io_queue_iowq(req);
 	else
@@ -1581,11 +1581,11 @@ static int io_iopoll_check(struct io_ring_ctx *ctx, long min)
 	} while (nr_events < min);
 
 	return 0;
 }
 
-void io_req_task_complete(struct io_kiocb *req, struct io_tw_state *ts)
+void io_req_task_complete(struct io_kiocb *req, io_tw_token_t tw)
 {
 	io_req_complete_defer(req);
 }
 
 /*
@@ -1761,13 +1761,13 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 			io_iopoll_req_issued(req, issue_flags);
 	}
 	return ret;
 }
 
-int io_poll_issue(struct io_kiocb *req, struct io_tw_state *ts)
+int io_poll_issue(struct io_kiocb *req, io_tw_token_t tw)
 {
-	io_tw_lock(req->ctx, ts);
+	io_tw_lock(req->ctx, tw);
 	return io_issue_sqe(req, IO_URING_F_NONBLOCK|IO_URING_F_MULTISHOT|
 				 IO_URING_F_COMPLETE_DEFER);
 }
 
 struct io_wq_work *io_wq_free_work(struct io_wq_work *work)
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 85bc8f76ca19..6c46d9cdd7aa 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -88,13 +88,13 @@ struct file *io_file_get_fixed(struct io_kiocb *req, int fd,
 void __io_req_task_work_add(struct io_kiocb *req, unsigned flags);
 void io_req_task_work_add_remote(struct io_kiocb *req, struct io_ring_ctx *ctx,
 				 unsigned flags);
 bool io_alloc_async_data(struct io_kiocb *req);
 void io_req_task_queue(struct io_kiocb *req);
-void io_req_task_complete(struct io_kiocb *req, struct io_tw_state *ts);
+void io_req_task_complete(struct io_kiocb *req, io_tw_token_t tw);
 void io_req_task_queue_fail(struct io_kiocb *req, int ret);
-void io_req_task_submit(struct io_kiocb *req, struct io_tw_state *ts);
+void io_req_task_submit(struct io_kiocb *req, io_tw_token_t tw);
 struct llist_node *io_handle_tw_list(struct llist_node *node, unsigned int *count, unsigned int max_entries);
 struct llist_node *tctx_task_work_run(struct io_uring_task *tctx, unsigned int max_entries, unsigned int *count);
 void tctx_task_work(struct callback_head *cb);
 __cold void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd);
 int io_uring_alloc_task_context(struct task_struct *task,
@@ -102,11 +102,11 @@ int io_uring_alloc_task_context(struct task_struct *task,
 
 int io_ring_add_registered_file(struct io_uring_task *tctx, struct file *file,
 				     int start, int end);
 void io_req_queue_iowq(struct io_kiocb *req);
 
-int io_poll_issue(struct io_kiocb *req, struct io_tw_state *ts);
+int io_poll_issue(struct io_kiocb *req, io_tw_token_t tw);
 int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr);
 int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin);
 void __io_submit_flush_completions(struct io_ring_ctx *ctx);
 
 struct io_wq_work *io_wq_free_work(struct io_wq_work *work);
@@ -374,11 +374,11 @@ static inline bool io_local_work_pending(struct io_ring_ctx *ctx)
 static inline bool io_task_work_pending(struct io_ring_ctx *ctx)
 {
 	return task_work_pending(current) || io_local_work_pending(ctx);
 }
 
-static inline void io_tw_lock(struct io_ring_ctx *ctx, struct io_tw_state *ts)
+static inline void io_tw_lock(struct io_ring_ctx *ctx, io_tw_token_t tw)
 {
 	lockdep_assert_held(&ctx->uring_lock);
 }
 
 /*
diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
index 7e6f68e911f1..0bbcbbcdebfd 100644
--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -69,11 +69,11 @@ void io_msg_ring_cleanup(struct io_kiocb *req)
 static inline bool io_msg_need_remote(struct io_ring_ctx *target_ctx)
 {
 	return target_ctx->task_complete;
 }
 
-static void io_msg_tw_complete(struct io_kiocb *req, struct io_tw_state *ts)
+static void io_msg_tw_complete(struct io_kiocb *req, io_tw_token_t tw)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 
 	io_add_aux_cqe(ctx, req->cqe.user_data, req->cqe.res, req->cqe.flags);
 	if (spin_trylock(&ctx->msg_lock)) {
diff --git a/io_uring/notif.c b/io_uring/notif.c
index ee3a33510b3c..7bd92538dccb 100644
--- a/io_uring/notif.c
+++ b/io_uring/notif.c
@@ -9,11 +9,11 @@
 #include "notif.h"
 #include "rsrc.h"
 
 static const struct ubuf_info_ops io_ubuf_ops;
 
-static void io_notif_tw_complete(struct io_kiocb *notif, struct io_tw_state *ts)
+static void io_notif_tw_complete(struct io_kiocb *notif, io_tw_token_t tw)
 {
 	struct io_notif_data *nd = io_notif_to_data(notif);
 
 	do {
 		notif = cmd_to_io_kiocb(nd);
@@ -27,11 +27,11 @@ static void io_notif_tw_complete(struct io_kiocb *notif, struct io_tw_state *ts)
 			__io_unaccount_mem(notif->ctx->user, nd->account_pages);
 			nd->account_pages = 0;
 		}
 
 		nd = nd->next;
-		io_req_task_complete(notif, ts);
+		io_req_task_complete(notif, tw);
 	} while (nd);
 }
 
 void io_tx_ubuf_complete(struct sk_buff *skb, struct ubuf_info *uarg,
 			 bool success)
diff --git a/io_uring/poll.c b/io_uring/poll.c
index bb1c0cd4f809..176854882ba6 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -218,11 +218,11 @@ static inline void io_poll_execute(struct io_kiocb *req, int res)
  * require, which is either spurious wakeup or multishot CQE is served.
  * IOU_POLL_DONE when it's done with the request, then the mask is stored in
  * req->cqe.res. IOU_POLL_REMOVE_POLL_USE_RES indicates to remove multishot
  * poll and that the result is stored in req->cqe.
  */
-static int io_poll_check_events(struct io_kiocb *req, struct io_tw_state *ts)
+static int io_poll_check_events(struct io_kiocb *req, io_tw_token_t tw)
 {
 	int v;
 
 	if (unlikely(io_should_terminate_tw()))
 		return -ECANCELED;
@@ -286,11 +286,11 @@ static int io_poll_check_events(struct io_kiocb *req, struct io_tw_state *ts)
 			if (!io_req_post_cqe(req, mask, IORING_CQE_F_MORE)) {
 				io_req_set_res(req, mask, 0);
 				return IOU_POLL_REMOVE_POLL_USE_RES;
 			}
 		} else {
-			int ret = io_poll_issue(req, ts);
+			int ret = io_poll_issue(req, tw);
 			if (ret == IOU_STOP_MULTISHOT)
 				return IOU_POLL_REMOVE_POLL_USE_RES;
 			else if (ret == IOU_REQUEUE)
 				return IOU_POLL_REQUEUE;
 			if (ret < 0)
@@ -309,15 +309,15 @@ static int io_poll_check_events(struct io_kiocb *req, struct io_tw_state *ts)
 
 	io_napi_add(req);
 	return IOU_POLL_NO_ACTION;
 }
 
-void io_poll_task_func(struct io_kiocb *req, struct io_tw_state *ts)
+void io_poll_task_func(struct io_kiocb *req, io_tw_token_t tw)
 {
 	int ret;
 
-	ret = io_poll_check_events(req, ts);
+	ret = io_poll_check_events(req, tw);
 	if (ret == IOU_POLL_NO_ACTION) {
 		io_kbuf_recycle(req, 0);
 		return;
 	} else if (ret == IOU_POLL_REQUEUE) {
 		io_kbuf_recycle(req, 0);
@@ -333,26 +333,26 @@ void io_poll_task_func(struct io_kiocb *req, struct io_tw_state *ts)
 			struct io_poll *poll;
 
 			poll = io_kiocb_to_cmd(req, struct io_poll);
 			req->cqe.res = mangle_poll(req->cqe.res & poll->events);
 		} else if (ret == IOU_POLL_REISSUE) {
-			io_req_task_submit(req, ts);
+			io_req_task_submit(req, tw);
 			return;
 		} else if (ret != IOU_POLL_REMOVE_POLL_USE_RES) {
 			req->cqe.res = ret;
 			req_set_fail(req);
 		}
 
 		io_req_set_res(req, req->cqe.res, 0);
-		io_req_task_complete(req, ts);
+		io_req_task_complete(req, tw);
 	} else {
-		io_tw_lock(req->ctx, ts);
+		io_tw_lock(req->ctx, tw);
 
 		if (ret == IOU_POLL_REMOVE_POLL_USE_RES)
-			io_req_task_complete(req, ts);
+			io_req_task_complete(req, tw);
 		else if (ret == IOU_POLL_DONE || ret == IOU_POLL_REISSUE)
-			io_req_task_submit(req, ts);
+			io_req_task_submit(req, tw);
 		else
 			io_req_defer_failed(req, ret);
 	}
 }
 
diff --git a/io_uring/poll.h b/io_uring/poll.h
index 04ede93113dc..27e2db2ed4ae 100644
--- a/io_uring/poll.h
+++ b/io_uring/poll.h
@@ -1,7 +1,9 @@
 // SPDX-License-Identifier: GPL-2.0
 
+#include <linux/io_uring_types.h>
+
 #define IO_POLL_ALLOC_CACHE_MAX 32
 
 enum {
 	IO_APOLL_OK,
 	IO_APOLL_ABORTED,
@@ -41,6 +43,6 @@ int io_poll_cancel(struct io_ring_ctx *ctx, struct io_cancel_data *cd,
 		   unsigned issue_flags);
 int io_arm_poll_handler(struct io_kiocb *req, unsigned issue_flags);
 bool io_poll_remove_all(struct io_ring_ctx *ctx, struct io_uring_task *tctx,
 			bool cancel_all);
 
-void io_poll_task_func(struct io_kiocb *req, struct io_tw_state *ts);
+void io_poll_task_func(struct io_kiocb *req, io_tw_token_t tw);
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 7aa1e4c9f64a..16f12f94943f 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -509,11 +509,11 @@ static inline int io_fixup_rw_res(struct io_kiocb *req, long res)
 			res += io->bytes_done;
 	}
 	return res;
 }
 
-void io_req_rw_complete(struct io_kiocb *req, struct io_tw_state *ts)
+void io_req_rw_complete(struct io_kiocb *req, io_tw_token_t tw)
 {
 	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
 	struct kiocb *kiocb = &rw->kiocb;
 
 	if ((kiocb->ki_flags & IOCB_DIO_CALLER_COMP) && kiocb->dio_complete) {
@@ -526,11 +526,11 @@ void io_req_rw_complete(struct io_kiocb *req, struct io_tw_state *ts)
 
 	if (req->flags & (REQ_F_BUFFER_SELECTED|REQ_F_BUFFER_RING))
 		req->cqe.flags |= io_put_kbuf(req, req->cqe.res, 0);
 
 	io_req_rw_cleanup(req, 0);
-	io_req_task_complete(req, ts);
+	io_req_task_complete(req, tw);
 }
 
 static void io_complete_rw(struct kiocb *kiocb, long res)
 {
 	struct io_rw *rw = container_of(kiocb, struct io_rw, kiocb);
diff --git a/io_uring/rw.h b/io_uring/rw.h
index eaa59bd64870..a45e0c71b59d 100644
--- a/io_uring/rw.h
+++ b/io_uring/rw.h
@@ -1,7 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0
 
+#include <linux/io_uring_types.h>
 #include <linux/pagemap.h>
 
 struct io_meta_state {
 	u32			seed;
 	struct iov_iter_state	iter_meta;
@@ -37,9 +38,9 @@ int io_prep_read(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_prep_write(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_read(struct io_kiocb *req, unsigned int issue_flags);
 int io_write(struct io_kiocb *req, unsigned int issue_flags);
 void io_readv_writev_cleanup(struct io_kiocb *req);
 void io_rw_fail(struct io_kiocb *req);
-void io_req_rw_complete(struct io_kiocb *req, struct io_tw_state *ts);
+void io_req_rw_complete(struct io_kiocb *req, io_tw_token_t tw);
 int io_read_mshot_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_read_mshot(struct io_kiocb *req, unsigned int issue_flags);
 void io_rw_cache_free(const void *entry);
diff --git a/io_uring/timeout.c b/io_uring/timeout.c
index 48fc8cf70784..fec6ec7beb62 100644
--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -63,11 +63,11 @@ static inline bool io_timeout_finish(struct io_timeout *timeout,
 	return true;
 }
 
 static enum hrtimer_restart io_timeout_fn(struct hrtimer *timer);
 
-static void io_timeout_complete(struct io_kiocb *req, struct io_tw_state *ts)
+static void io_timeout_complete(struct io_kiocb *req, io_tw_token_t tw)
 {
 	struct io_timeout *timeout = io_kiocb_to_cmd(req, struct io_timeout);
 	struct io_timeout_data *data = req->async_data;
 	struct io_ring_ctx *ctx = req->ctx;
 
@@ -80,11 +80,11 @@ static void io_timeout_complete(struct io_kiocb *req, struct io_tw_state *ts)
 			raw_spin_unlock_irq(&ctx->timeout_lock);
 			return;
 		}
 	}
 
-	io_req_task_complete(req, ts);
+	io_req_task_complete(req, tw);
 }
 
 static __cold bool io_flush_killed_timeouts(struct list_head *list, int err)
 {
 	if (list_empty(list))
@@ -152,22 +152,22 @@ __cold void io_flush_timeouts(struct io_ring_ctx *ctx)
 	ctx->cq_last_tm_flush = seq;
 	raw_spin_unlock_irq(&ctx->timeout_lock);
 	io_flush_killed_timeouts(&list, 0);
 }
 
-static void io_req_tw_fail_links(struct io_kiocb *link, struct io_tw_state *ts)
+static void io_req_tw_fail_links(struct io_kiocb *link, io_tw_token_t tw)
 {
-	io_tw_lock(link->ctx, ts);
+	io_tw_lock(link->ctx, tw);
 	while (link) {
 		struct io_kiocb *nxt = link->link;
 		long res = -ECANCELED;
 
 		if (link->flags & REQ_F_FAIL)
 			res = link->cqe.res;
 		link->link = NULL;
 		io_req_set_res(link, res, 0);
-		io_req_task_complete(link, ts);
+		io_req_task_complete(link, tw);
 		link = nxt;
 	}
 }
 
 static void io_fail_links(struct io_kiocb *req)
@@ -310,11 +310,11 @@ int io_timeout_cancel(struct io_ring_ctx *ctx, struct io_cancel_data *cd)
 		return PTR_ERR(req);
 	io_req_task_queue_fail(req, -ECANCELED);
 	return 0;
 }
 
-static void io_req_task_link_timeout(struct io_kiocb *req, struct io_tw_state *ts)
+static void io_req_task_link_timeout(struct io_kiocb *req, io_tw_token_t tw)
 {
 	struct io_timeout *timeout = io_kiocb_to_cmd(req, struct io_timeout);
 	struct io_kiocb *prev = timeout->prev;
 	int ret;
 
@@ -328,15 +328,15 @@ static void io_req_task_link_timeout(struct io_kiocb *req, struct io_tw_state *t
 			ret = io_try_cancel(req->tctx, &cd, 0);
 		} else {
 			ret = -ECANCELED;
 		}
 		io_req_set_res(req, ret ?: -ETIME, 0);
-		io_req_task_complete(req, ts);
+		io_req_task_complete(req, tw);
 		io_put_req(prev);
 	} else {
 		io_req_set_res(req, -ETIME, 0);
-		io_req_task_complete(req, ts);
+		io_req_task_complete(req, tw);
 	}
 }
 
 static enum hrtimer_restart io_link_timeout_fn(struct hrtimer *timer)
 {
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 1f6a82128b47..ec0c925a991f 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -103,11 +103,11 @@ void io_uring_cmd_mark_cancelable(struct io_uring_cmd *cmd,
 		io_ring_submit_unlock(ctx, issue_flags);
 	}
 }
 EXPORT_SYMBOL_GPL(io_uring_cmd_mark_cancelable);
 
-static void io_uring_cmd_work(struct io_kiocb *req, struct io_tw_state *ts)
+static void io_uring_cmd_work(struct io_kiocb *req, io_tw_token_t tw)
 {
 	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
 	unsigned int flags = IO_URING_F_COMPLETE_DEFER;
 
 	if (io_should_terminate_tw())
diff --git a/io_uring/waitid.c b/io_uring/waitid.c
index a9dc336236f1..981a9af35fc5 100644
--- a/io_uring/waitid.c
+++ b/io_uring/waitid.c
@@ -14,11 +14,11 @@
 #include "io_uring.h"
 #include "cancel.h"
 #include "waitid.h"
 #include "../kernel/exit.h"
 
-static void io_waitid_cb(struct io_kiocb *req, struct io_tw_state *ts);
+static void io_waitid_cb(struct io_kiocb *req, io_tw_token_t tw);
 
 #define IO_WAITID_CANCEL_FLAG	BIT(31)
 #define IO_WAITID_REF_MASK	GENMASK(30, 0)
 
 struct io_waitid {
@@ -183,17 +183,17 @@ static inline bool io_waitid_drop_issue_ref(struct io_kiocb *req)
 	io_req_task_work_add(req);
 	remove_wait_queue(iw->head, &iwa->wo.child_wait);
 	return true;
 }
 
-static void io_waitid_cb(struct io_kiocb *req, struct io_tw_state *ts)
+static void io_waitid_cb(struct io_kiocb *req, io_tw_token_t tw)
 {
 	struct io_waitid_async *iwa = req->async_data;
 	struct io_ring_ctx *ctx = req->ctx;
 	int ret;
 
-	io_tw_lock(ctx, ts);
+	io_tw_lock(ctx, tw);
 
 	ret = __do_wait(&iwa->wo);
 
 	/*
 	 * If we get -ERESTARTSYS here, we need to re-arm and check again
@@ -219,11 +219,11 @@ static void io_waitid_cb(struct io_kiocb *req, struct io_tw_state *ts)
 			remove_wait_queue(iw->head, &iwa->wo.child_wait);
 		}
 	}
 
 	io_waitid_complete(req, ret);
-	io_req_task_complete(req, ts);
+	io_req_task_complete(req, tw);
 }
 
 static int io_waitid_wait(struct wait_queue_entry *wait, unsigned mode,
 			  int sync, void *key)
 {
-- 
2.45.2


