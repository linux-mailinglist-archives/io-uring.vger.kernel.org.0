Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED4C0414901
	for <lists+io-uring@lfdr.de>; Wed, 22 Sep 2021 14:34:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235335AbhIVMgG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 22 Sep 2021 08:36:06 -0400
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:36716 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235821AbhIVMf7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 22 Sep 2021 08:35:59 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UpEU-50_1632314067;
Received: from localhost(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0UpEU-50_1632314067)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 22 Sep 2021 20:34:28 +0800
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, asml.silence@gmail.com,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Subject: [RFC 3/3] io_uring: try to batch poll request completion
Date:   Wed, 22 Sep 2021 20:34:17 +0800
Message-Id: <20210922123417.2844-4-xiaoguang.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20210922123417.2844-1-xiaoguang.wang@linux.alibaba.com>
References: <20210922123417.2844-1-xiaoguang.wang@linux.alibaba.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

For an echo-server based on io_uring's IORING_POLL_ADD_MULTI feature,
only poll request are completed in task work, normal read/write
requests are issued when user app sees cqes on corresponding poll
requests, and they will mostly read/write data successfully, which
don't need task work. So at least for echo-server model, batching
poll request completion properly will give benefits.

Currently don't find any appropriate place to store batched poll
requests, put them in struct io_submit_state temporarily, which I
think it'll need rework in future.

Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
---
 fs/io_uring.c | 64 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 63 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 6fdfb688cf91..14118388bfc6 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -321,6 +321,11 @@ struct io_submit_state {
 	 */
 	struct io_kiocb		*compl_reqs[IO_COMPL_BATCH];
 	unsigned int		compl_nr;
+
+	struct io_kiocb		*poll_compl_reqs[IO_COMPL_BATCH];
+	bool			poll_req_status[IO_COMPL_BATCH];
+	unsigned int		poll_compl_nr;
+
 	/* inline/task_work completion list, under ->uring_lock */
 	struct list_head	free_list;
 
@@ -2093,6 +2098,8 @@ static void ctx_flush_and_put(struct io_ring_ctx *ctx, bool *locked)
 	percpu_ref_put(&ctx->refs);
 }
 
+static void io_poll_flush_completions(struct io_ring_ctx *ctx, bool *locked);
+
 static void tctx_task_work(struct callback_head *cb)
 {
 	bool locked = false;
@@ -2103,8 +2110,11 @@ static void tctx_task_work(struct callback_head *cb)
 	while (1) {
 		struct io_wq_work_node *node;
 
-		if (!tctx->task_list.first && locked && ctx->submit_state.compl_nr)
+		if (!tctx->task_list.first && locked && (ctx->submit_state.compl_nr ||
+		    ctx->submit_state.poll_compl_nr)) {
 			io_submit_flush_completions(ctx);
+			io_poll_flush_completions(ctx, &locked);
+		}
 
 		spin_lock_irq(&tctx->task_lock);
 		node = tctx->task_list.first;
@@ -5134,6 +5144,49 @@ static inline bool io_poll_complete(struct io_kiocb *req, __poll_t mask)
 static bool __io_poll_remove_one(struct io_kiocb *req,
 				 struct io_poll_iocb *poll, bool do_cancel);
 
+static void io_poll_flush_completions(struct io_ring_ctx *ctx, bool *locked)
+	__must_hold(&ctx->uring_lock)
+{
+	struct io_submit_state *state = &ctx->submit_state;
+	struct io_kiocb *req, *nxt;
+	int i, nr = state->poll_compl_nr;
+	bool done, skip_done = true;
+
+	spin_lock(&ctx->completion_lock);
+	for (i = 0; i < nr; i++) {
+		req = state->poll_compl_reqs[i];
+		done = __io_poll_complete(req, req->result);
+		if (done) {
+			io_poll_remove_double(req);
+			__io_poll_remove_one(req, io_poll_get_single(req), true);
+			hash_del(&req->hash_node);
+			state->poll_req_status[i] = true;
+			if (skip_done)
+				skip_done = false;
+		} else {
+			req->result = 0;
+			state->poll_req_status[i] = false;
+			WRITE_ONCE(req->poll.active, true);
+		}
+	}
+	io_commit_cqring(ctx);
+	spin_unlock(&ctx->completion_lock);
+	io_cqring_ev_posted(ctx);
+	state->poll_compl_nr = 0;
+
+	if (skip_done)
+		return;
+
+	for (i = 0; i < nr; i++) {
+		if (state->poll_req_status[i]) {
+			req = state->poll_compl_reqs[i];
+			nxt = io_put_req_find_next(req);
+			if (nxt)
+				io_req_task_submit(nxt, locked);
+		}
+	}
+}
+
 static void io_poll_task_func(struct io_kiocb *req, bool *locked)
 {
 	struct io_ring_ctx *ctx = req->ctx;
@@ -5143,6 +5196,15 @@ static void io_poll_task_func(struct io_kiocb *req, bool *locked)
 	if (io_poll_rewait(req, &req->poll))
 		return;
 
+	if (*locked) {
+		struct io_submit_state *state = &ctx->submit_state;
+
+		state->poll_compl_reqs[state->poll_compl_nr++] = req;
+		if (state->poll_compl_nr == ARRAY_SIZE(state->poll_compl_reqs))
+			io_poll_flush_completions(ctx, locked);
+		return;
+	}
+
 	spin_lock(&ctx->completion_lock);
 	done = __io_poll_complete(req, req->result);
 	if (done) {
-- 
2.14.4.44.g2045bb6

