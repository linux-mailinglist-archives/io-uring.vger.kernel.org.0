Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0096240FFEA
	for <lists+io-uring@lfdr.de>; Fri, 17 Sep 2021 21:38:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243245AbhIQTj6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 17 Sep 2021 15:39:58 -0400
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:33933 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243123AbhIQTju (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 17 Sep 2021 15:39:50 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UoidwXr_1631907500;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UoidwXr_1631907500)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 18 Sep 2021 03:38:27 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 5/5] io_uring: leverage completion cache for poll requests
Date:   Sat, 18 Sep 2021 03:38:20 +0800
Message-Id: <20210917193820.224671-6-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
In-Reply-To: <20210917193820.224671-1-haoxu@linux.alibaba.com>
References: <20210917193820.224671-1-haoxu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Leverage completion cache to handle completions of poll requests in a
batch.
Good thing is we save compl_nr - 1 completion_lock and
io_cqring_ev_posted.
Bad thing is compl_nr extra ifs in flush_completion.

Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---
 fs/io_uring.c | 64 +++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 49 insertions(+), 15 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index b1d6c3a1d3cd..0f72cb0bf79a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1099,6 +1099,8 @@ static int io_install_fixed_file(struct io_kiocb *req, struct file *file,
 				 unsigned int issue_flags, u32 slot_index);
 static enum hrtimer_restart io_link_timeout_fn(struct hrtimer *timer);
 
+static bool io_complete_poll(struct io_kiocb *req);
+
 static struct kmem_cache *req_cachep;
 
 static const struct file_operations io_uring_fops;
@@ -2333,6 +2335,11 @@ static void __io_submit_flush_completions(struct io_ring_ctx *ctx)
 	for (i = 0; i < nr; i++) {
 		struct io_kiocb *req = state->compl_reqs[i];
 
+		if (req->opcode == IORING_OP_POLL_ADD) {
+			if (!io_complete_poll(req))
+				state->compl_reqs[i] = NULL;
+			continue;
+		}
 		__io_cqring_fill_event(ctx, req->user_data, req->result,
 					req->compl.cflags);
 	}
@@ -2344,7 +2351,7 @@ static void __io_submit_flush_completions(struct io_ring_ctx *ctx)
 	for (i = 0; i < nr; i++) {
 		struct io_kiocb *req = state->compl_reqs[i];
 
-		if (req_ref_put_and_test(req))
+		if (req && req_ref_put_and_test(req))
 			io_req_free_batch(&rb, req, &ctx->submit_state);
 	}
 
@@ -5360,6 +5367,23 @@ static inline void io_poll_complete(struct io_kiocb *req, __poll_t mask)
 	return;
 }
 
+static bool io_complete_poll(struct io_kiocb *req)
+{
+	bool done;
+
+	done = __io_poll_complete(req, req->result);
+	if (done) {
+		io_poll_remove_double(req);
+		hash_del(&req->hash_node);
+		req->poll.done = true;
+	} else {
+		req->result = 0;
+		add_wait_queue(req->poll.head, &req->poll.wait);
+	}
+
+	return done;
+}
+
 static void io_poll_task_func(struct io_kiocb *req, bool *locked)
 {
 	struct io_ring_ctx *ctx = req->ctx;
@@ -5367,18 +5391,10 @@ static void io_poll_task_func(struct io_kiocb *req, bool *locked)
 
 	if (io_poll_rewait(req, &req->poll)) {
 		spin_unlock(&ctx->completion_lock);
-	} else {
+	} else if (!*locked) {
 		bool done;
 
-		done = __io_poll_complete(req, req->result);
-		if (done) {
-			io_poll_remove_double(req);
-			hash_del(&req->hash_node);
-			req->poll.done = true;
-		} else {
-			req->result = 0;
-			add_wait_queue(req->poll.head, &req->poll.wait);
-		}
+		done = io_complete_poll(req);
 		io_commit_cqring(ctx);
 		spin_unlock(&ctx->completion_lock);
 		io_cqring_ev_posted(ctx);
@@ -5388,6 +5404,13 @@ static void io_poll_task_func(struct io_kiocb *req, bool *locked)
 			if (nxt)
 				io_req_task_submit(nxt, locked);
 		}
+	} else {
+		struct io_submit_state *state = &ctx->submit_state;
+
+		spin_unlock(&ctx->completion_lock);
+		state->compl_reqs[state->compl_nr++] = req;
+		if (state->compl_nr == ARRAY_SIZE(state->compl_reqs))
+			io_submit_flush_completions(ctx);
 	}
 }
 
@@ -5833,6 +5856,7 @@ static int io_poll_add(struct io_kiocb *req, unsigned int issue_flags)
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_poll_table ipt;
 	__poll_t mask;
+	bool locked = current == req->task;
 
 	ipt.pt._qproc = io_poll_queue_proc;
 
@@ -5841,14 +5865,24 @@ static int io_poll_add(struct io_kiocb *req, unsigned int issue_flags)
 
 	if (mask) { /* no async, we'd stolen it */
 		ipt.error = 0;
-		io_poll_complete(req, mask);
+		if (!locked)
+			io_poll_complete(req, mask);
 	}
 	spin_unlock(&ctx->completion_lock);
 
 	if (mask) {
-		io_cqring_ev_posted(ctx);
-		if (poll->events & EPOLLONESHOT)
-			io_put_req(req);
+		if (!locked) {
+			io_cqring_ev_posted(ctx);
+			if (poll->events & EPOLLONESHOT)
+				io_put_req(req);
+		} else {
+			struct io_submit_state *state = &ctx->submit_state;
+
+			req->result = mask;
+			state->compl_reqs[state->compl_nr++] = req;
+			if (state->compl_nr == ARRAY_SIZE(state->compl_reqs))
+				io_submit_flush_completions(ctx);
+		}
 	}
 	return ipt.error;
 }
-- 
2.24.4

