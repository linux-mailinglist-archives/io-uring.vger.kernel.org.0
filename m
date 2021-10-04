Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 935AA4216FD
	for <lists+io-uring@lfdr.de>; Mon,  4 Oct 2021 21:04:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237779AbhJDTF4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 Oct 2021 15:05:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238889AbhJDTFy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 Oct 2021 15:05:54 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 863F8C061745
        for <io-uring@vger.kernel.org>; Mon,  4 Oct 2021 12:04:04 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id p11so15948243edy.10
        for <io-uring@vger.kernel.org>; Mon, 04 Oct 2021 12:04:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5QPFF95mlNfFol+3eXJgH/BG/NlAOeLoW9GjZ9R/hSI=;
        b=gUIijHxa2hm4DGoDZTf3pK/FIhHuI3G+UtpGfwe5syLzFxLMgJOsd7o4zXQQ0GujBX
         Ht1FSdjjm8GoZDXsKXpLaE24TxXBnhxB3ENGtHiUdsfmxYI5WpsE62m01u7HoBZQIXS9
         5eIs8rOqLHNlDjjhJsgQO/keL5EY6W0GIs2a+mVmNoGb5Cj3mLPZNNQeyVyNTv8VMKZm
         uSudqUxra5j0oZYMuvCOxzgaeaZn+vneKfyrwRrwwv7MGoZq4UfVoNUQY/C8G2eX4QHs
         jlWNfpsFJs8Rttews/k0d3cGB8fnMJbuUd6gDK5UEe6AJijIp9qoV6/+715b/p3bDjaO
         JqAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5QPFF95mlNfFol+3eXJgH/BG/NlAOeLoW9GjZ9R/hSI=;
        b=kVv0XIr7L7lc8rNp+OVXYMQIHx0wM6tFbou5gvmTgkhHQ1bUl+qoh1ae7q+YRVVoV3
         lOQGBtL717vgORLCogh92PJ/oDrFWwOx3CozHbAUM0467SItScYtbhVVmnag2CUdAEAc
         j2kWek950IHP4HAvEeDG8ChqZQRBEmwVu/r+tbRjfE7MiVRjtoI2rXBH3+2047MoyoRo
         KK960T5DPRuu2+9WosRNoaPVxTXKVDC4F4SPTID/nT+8S4o/6Ul8e9ITPKpADdaGJEWP
         DvSkeQJ7MU8CzV0Xbb9kmtrigMN83aIssJCKmcLKuvI6yTqsHm30hVvwN5PTSWIKhha4
         OU9w==
X-Gm-Message-State: AOAM530OAeMf/7oobDYzEYDji3aabIp4ppeyL9wc5mx2IoOTQaoc9yVB
        5vbLU6zR100wLk6ESxR1bbvuSbHDpdw=
X-Google-Smtp-Source: ABdhPJxfBSvvVwN5rAdiIMNzhNEMDF+GPjXwS+S2V76E5aAV3mWjJ2UbpdQY/ZjgR3ajRdbzYhkEpg==
X-Received: by 2002:aa7:c48d:: with SMTP id m13mr20303390edq.364.1633374242833;
        Mon, 04 Oct 2021 12:04:02 -0700 (PDT)
Received: from localhost.localdomain ([85.255.237.101])
        by smtp.gmail.com with ESMTPSA id k12sm6855045ejk.63.2021.10.04.12.04.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 12:04:02 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 16/16] io_uring: mark hot functions
Date:   Mon,  4 Oct 2021 20:03:01 +0100
Message-Id: <0d4196a32fdae67f5ba0dd7d14680d1daa0c923f.1633373302.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1633373302.git.asml.silence@gmail.com>
References: <cover.1633373302.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

It can be quite beneficial to mark appropriate functions with
__attribute__((hot)), it mostly helps to rearrange functions so they are
cached better. E.g. nops test showed 31->32 MIOPS improvement with it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 34 ++++++++++++++++++----------------
 1 file changed, 18 insertions(+), 16 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 62dc128e9b6b..e35569df7f80 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -114,6 +114,8 @@
 
 #define IO_TCTX_REFS_CACHE_NR	(1U << 10)
 
+#define __hot			__attribute__((__hot__))
+
 struct io_uring {
 	u32 head ____cacheline_aligned_in_smp;
 	u32 tail ____cacheline_aligned_in_smp;
@@ -1816,8 +1818,8 @@ static void io_req_complete_post(struct io_kiocb *req, s32 res,
 	io_cqring_ev_posted(ctx);
 }
 
-static inline void io_req_complete_state(struct io_kiocb *req, s32 res,
-					 u32 cflags)
+static inline __hot void io_req_complete_state(struct io_kiocb *req,
+					       s32 res, u32 cflags)
 {
 	req->result = res;
 	req->cflags = cflags;
@@ -2260,8 +2262,8 @@ static void io_free_req_work(struct io_kiocb *req, bool *locked)
 	io_free_req(req);
 }
 
-static void io_free_batch_list(struct io_ring_ctx *ctx,
-				struct io_wq_work_node *node)
+static __hot void io_free_batch_list(struct io_ring_ctx *ctx,
+				     struct io_wq_work_node *node)
 	__must_hold(&ctx->uring_lock)
 {
 	struct task_struct *task = NULL;
@@ -2294,7 +2296,7 @@ static void io_free_batch_list(struct io_ring_ctx *ctx,
 		io_put_task(task, task_refs);
 }
 
-static void __io_submit_flush_completions(struct io_ring_ctx *ctx)
+static __hot void __io_submit_flush_completions(struct io_ring_ctx *ctx)
 	__must_hold(&ctx->uring_lock)
 {
 	struct io_wq_work_node *node, *prev;
@@ -2389,7 +2391,7 @@ static inline bool io_run_task_work(void)
 	return false;
 }
 
-static int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
+static __hot int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
 {
 	struct io_wq_work_node *pos, *start, *prev;
 	int nr_events = 0;
@@ -2479,7 +2481,7 @@ static __cold void io_iopoll_try_reap_events(struct io_ring_ctx *ctx)
 	mutex_unlock(&ctx->uring_lock);
 }
 
-static int io_iopoll_check(struct io_ring_ctx *ctx, long min)
+static __hot int io_iopoll_check(struct io_ring_ctx *ctx, long min)
 {
 	unsigned int nr_events = 0;
 	int ret = 0;
@@ -6541,7 +6543,7 @@ static void io_clean_op(struct io_kiocb *req)
 	req->flags &= ~IO_REQ_CLEAN_FLAGS;
 }
 
-static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
+static __hot int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	const struct cred *creds = NULL;
@@ -6882,7 +6884,7 @@ static void io_queue_sqe_arm_apoll(struct io_kiocb *req)
 		io_queue_linked_timeout(linked_timeout);
 }
 
-static inline void __io_queue_sqe(struct io_kiocb *req)
+static inline __hot void __io_queue_sqe(struct io_kiocb *req)
 	__must_hold(&req->ctx->uring_lock)
 {
 	struct io_kiocb *linked_timeout;
@@ -6926,7 +6928,7 @@ static void io_queue_sqe_fallback(struct io_kiocb *req)
 	}
 }
 
-static inline void io_queue_sqe(struct io_kiocb *req)
+static inline __hot void io_queue_sqe(struct io_kiocb *req)
 	__must_hold(&req->ctx->uring_lock)
 {
 	if (likely(!(req->flags & (REQ_F_FORCE_ASYNC | REQ_F_FAIL))))
@@ -6977,8 +6979,8 @@ static void io_init_req_drain(struct io_kiocb *req)
 	}
 }
 
-static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
-		       const struct io_uring_sqe *sqe)
+static __hot int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
+			     const struct io_uring_sqe *sqe)
 	__must_hold(&ctx->uring_lock)
 {
 	struct io_submit_state *state;
@@ -7050,8 +7052,8 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	return io_req_prep(req, sqe);
 }
 
-static int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
-			 const struct io_uring_sqe *sqe)
+static __hot int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
+			       const struct io_uring_sqe *sqe)
 	__must_hold(&ctx->uring_lock)
 {
 	struct io_submit_link *link = &ctx->submit_state.link;
@@ -7174,7 +7176,7 @@ static void io_commit_sqring(struct io_ring_ctx *ctx)
  * used, it's important that those reads are done through READ_ONCE() to
  * prevent a re-load down the line.
  */
-static const struct io_uring_sqe *io_get_sqe(struct io_ring_ctx *ctx)
+static inline const struct io_uring_sqe *io_get_sqe(struct io_ring_ctx *ctx)
 {
 	unsigned head, mask = ctx->sq_entries - 1;
 	unsigned sq_idx = ctx->cached_sq_head++ & mask;
@@ -7198,7 +7200,7 @@ static const struct io_uring_sqe *io_get_sqe(struct io_ring_ctx *ctx)
 	return NULL;
 }
 
-static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
+static __hot int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 	__must_hold(&ctx->uring_lock)
 {
 	unsigned int entries = io_sqring_entries(ctx);
-- 
2.33.0

