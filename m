Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF3CD4FE373
	for <lists+io-uring@lfdr.de>; Tue, 12 Apr 2022 16:10:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355432AbiDLOM4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 12 Apr 2022 10:12:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355128AbiDLOMy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 12 Apr 2022 10:12:54 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8E2F1CFF1
        for <io-uring@vger.kernel.org>; Tue, 12 Apr 2022 07:10:35 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id c7so27994914wrd.0
        for <io-uring@vger.kernel.org>; Tue, 12 Apr 2022 07:10:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QVjNlteansy7GCYWjDfPIqBZwzCN9mN9Lvf5vzuMe04=;
        b=RY6mTgpst6Pz5ZmD4UIGLGtF5Hp3fEscMq8OaDacbUiDWlzIv+7x5Kif4AuhiqeRiS
         OcBAn91SlDwp/M0T3NjW2r+M6ICtnFwlzChd0ihP5N34NtY6pEVjlZ2OXIZbnezc4oyw
         rgtPgEyT9H9GKWz3LBK0ZsSKeKPLk5jZDRYku68N/RMrg9C1Ewp+Ed448JWc+H8DwuyU
         2RcMhOfeK91JnEiYrR2vd5F2rYLHlEjJAIZ6X9tpzUdGzu6lL/lCPUcmVTNfwdqtmk2D
         APqwr2Kxe8qOpmd9TNKV9mDBNQUCbmdHC5tpFqsGPjRwAe2IX5pJJNenmwvkcTBNAuZl
         NKtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QVjNlteansy7GCYWjDfPIqBZwzCN9mN9Lvf5vzuMe04=;
        b=FCc5JD25CiZpAFzK1F86Djsc4ShGNcYD6VIgfOR9eDkyBbgcs+Ceu7xMjhwzyGlB/A
         XXTra3EeFDhhmMdFdxBd9Y+j0zyneJpFhfXHyBQ8weVwdMIWw9jqG5cUXwE4phAcsQe4
         4QELuVQsgpeeCiwV0X/OUC40PVh7zLdx36yukZJte3tfJwCV2TogynXwQtjHBUNWOTIj
         IbFfNXNN76tDXFdXYQ54BO21PiY4rqAWn5lJnuuDCVeOVFCcmbGHb52VinnFSK8Sdi4q
         TSNK9trvSIBD41g22e9njR0pYfuHnkaIVVgWcF9M1mxc0Qawfc4VNHTHPeR07vio0mNk
         +zzA==
X-Gm-Message-State: AOAM531PJFOwnsy8r3g98DUoamvT6PqXXEH+FlBrD/TbNSbFN+94QNjZ
        6UcxMDCOIktoeoGcIE3cjVjIBgUzgtE=
X-Google-Smtp-Source: ABdhPJxNpGY5Iv1kBAZY+qXPT7RkTvrM7v1q/D3QyyQg/nk0yh/l7nkHP78dntm/PsQnka7vCujsXA==
X-Received: by 2002:a5d:594d:0:b0:207:ae4b:baae with SMTP id e13-20020a5d594d000000b00207ae4bbaaemr2945635wri.162.1649772634144;
        Tue, 12 Apr 2022 07:10:34 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.129.222])
        by smtp.gmail.com with ESMTPSA id ay41-20020a05600c1e2900b0038e75fda4edsm2363703wmb.47.2022.04.12.07.10.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 07:10:33 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 1/9] io_uring: explicitly keep a CQE in io_kiocb
Date:   Tue, 12 Apr 2022 15:09:43 +0100
Message-Id: <e1efe65d5005cd6a9ec3440767eb15a9fa9351cf.1649771823.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1649771823.git.asml.silence@gmail.com>
References: <cover.1649771823.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We already have req->{result,user_data,cflags}, which mimic struct
io_uring_cqe and are intended to store CQE data. Combine them into a
struct io_uring_cqe field.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 123 ++++++++++++++++++++++++--------------------------
 1 file changed, 60 insertions(+), 63 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index a28eb7aec84d..ce5d7ebc34aa 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -909,10 +909,7 @@ struct io_kiocb {
 	u16				buf_index;
 	unsigned int			flags;
 
-	u64				user_data;
-	u32				result;
-	u32				cflags;
-
+	struct io_uring_cqe		cqe;
 	struct io_ring_ctx		*ctx;
 	struct task_struct		*task;
 
@@ -1493,7 +1490,7 @@ static inline void req_set_fail(struct io_kiocb *req)
 static inline void req_fail_link_node(struct io_kiocb *req, int res)
 {
 	req_set_fail(req);
-	req->result = res;
+	req->cqe.res = res;
 }
 
 static __cold void io_ring_ctx_ref_free(struct percpu_ref *ref)
@@ -1725,7 +1722,7 @@ static void io_queue_async_work(struct io_kiocb *req, bool *dont_use)
 	if (WARN_ON_ONCE(!same_thread_group(req->task, current)))
 		req->work.flags |= IO_WQ_WORK_CANCEL;
 
-	trace_io_uring_queue_async_work(ctx, req, req->user_data, req->opcode, req->flags,
+	trace_io_uring_queue_async_work(ctx, req, req->cqe.user_data, req->opcode, req->flags,
 					&req->work, io_wq_is_hashed(&req->work));
 	io_wq_enqueue(tctx->io_wq, &req->work);
 	if (link)
@@ -2067,8 +2064,8 @@ static inline bool __io_fill_cqe(struct io_ring_ctx *ctx, u64 user_data,
 
 static inline bool __io_fill_cqe_req(struct io_kiocb *req, s32 res, u32 cflags)
 {
-	trace_io_uring_complete(req->ctx, req, req->user_data, res, cflags);
-	return __io_fill_cqe(req->ctx, req->user_data, res, cflags);
+	trace_io_uring_complete(req->ctx, req, req->cqe.user_data, res, cflags);
+	return __io_fill_cqe(req->ctx, req->cqe.user_data, res, cflags);
 }
 
 static noinline void io_fill_cqe_req(struct io_kiocb *req, s32 res, u32 cflags)
@@ -2134,8 +2131,8 @@ static void io_req_complete_post(struct io_kiocb *req, s32 res,
 static inline void io_req_complete_state(struct io_kiocb *req, s32 res,
 					 u32 cflags)
 {
-	req->result = res;
-	req->cflags = cflags;
+	req->cqe.res = res;
+	req->cqe.flags = cflags;
 	req->flags |= REQ_F_COMPLETE_INLINE;
 }
 
@@ -2167,7 +2164,7 @@ static void io_req_complete_fail_submit(struct io_kiocb *req)
 	 */
 	req->flags &= ~REQ_F_HARDLINK;
 	req->flags |= REQ_F_LINK;
-	io_req_complete_failed(req, req->result);
+	io_req_complete_failed(req, req->cqe.res);
 }
 
 /*
@@ -2180,7 +2177,7 @@ static void io_preinit_req(struct io_kiocb *req, struct io_ring_ctx *ctx)
 	req->link = NULL;
 	req->async_data = NULL;
 	/* not necessary, but safer to zero */
-	req->result = 0;
+	req->cqe.res = 0;
 }
 
 static void io_flush_cached_locked_reqs(struct io_ring_ctx *ctx,
@@ -2334,12 +2331,12 @@ static void io_fail_links(struct io_kiocb *req)
 		long res = -ECANCELED;
 
 		if (link->flags & REQ_F_FAIL)
-			res = link->result;
+			res = link->cqe.res;
 
 		nxt = link->link;
 		link->link = NULL;
 
-		trace_io_uring_fail_link(req->ctx, req, req->user_data,
+		trace_io_uring_fail_link(req->ctx, req, req->cqe.user_data,
 					req->opcode, link);
 
 		if (!ignore_cqes) {
@@ -2459,7 +2456,7 @@ static void handle_prev_tw_list(struct io_wq_work_node *node,
 		if (likely(*uring_locked))
 			req->io_task_work.func(req, uring_locked);
 		else
-			__io_req_complete_post(req, req->result,
+			__io_req_complete_post(req, req->cqe.res,
 						io_put_kbuf_comp(req));
 		node = next;
 	} while (node);
@@ -2589,7 +2586,7 @@ static void io_req_task_cancel(struct io_kiocb *req, bool *locked)
 
 	/* not needed for normal modes, but SQPOLL depends on it */
 	io_tw_lock(ctx, locked);
-	io_req_complete_failed(req, req->result);
+	io_req_complete_failed(req, req->cqe.res);
 }
 
 static void io_req_task_submit(struct io_kiocb *req, bool *locked)
@@ -2606,7 +2603,7 @@ static void io_req_task_submit(struct io_kiocb *req, bool *locked)
 
 static void io_req_task_queue_fail(struct io_kiocb *req, int ret)
 {
-	req->result = ret;
+	req->cqe.res = ret;
 	req->io_task_work.func = io_req_task_cancel;
 	io_req_task_work_add(req, false);
 }
@@ -2706,7 +2703,7 @@ static void __io_submit_flush_completions(struct io_ring_ctx *ctx)
 						    comp_list);
 
 			if (!(req->flags & REQ_F_CQE_SKIP))
-				__io_fill_cqe_req(req, req->result, req->cflags);
+				__io_fill_cqe_req(req, req->cqe.res, req->cqe.flags);
 		}
 
 		io_commit_cqring(ctx);
@@ -2831,7 +2828,7 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
 		if (unlikely(req->flags & REQ_F_CQE_SKIP))
 			continue;
 
-		__io_fill_cqe_req(req, req->result, io_put_kbuf(req, 0));
+		__io_fill_cqe_req(req, req->cqe.res, io_put_kbuf(req, 0));
 		nr_events++;
 	}
 
@@ -2990,21 +2987,21 @@ static bool __io_complete_rw_common(struct io_kiocb *req, long res)
 	} else {
 		fsnotify_access(req->file);
 	}
-	if (unlikely(res != req->result)) {
+	if (unlikely(res != req->cqe.res)) {
 		if ((res == -EAGAIN || res == -EOPNOTSUPP) &&
 		    io_rw_should_reissue(req)) {
 			req->flags |= REQ_F_REISSUE;
 			return true;
 		}
 		req_set_fail(req);
-		req->result = res;
+		req->cqe.res = res;
 	}
 	return false;
 }
 
 static inline void io_req_task_complete(struct io_kiocb *req, bool *locked)
 {
-	int res = req->result;
+	int res = req->cqe.res;
 
 	if (*locked) {
 		io_req_complete_state(req, res, io_put_kbuf(req, 0));
@@ -3020,7 +3017,7 @@ static void __io_complete_rw(struct io_kiocb *req, long res,
 {
 	if (__io_complete_rw_common(req, res))
 		return;
-	__io_req_complete(req, issue_flags, req->result,
+	__io_req_complete(req, issue_flags, req->cqe.res,
 				io_put_kbuf(req, issue_flags));
 }
 
@@ -3030,7 +3027,7 @@ static void io_complete_rw(struct kiocb *kiocb, long res)
 
 	if (__io_complete_rw_common(req, res))
 		return;
-	req->result = res;
+	req->cqe.res = res;
 	req->io_task_work.func = io_req_task_complete;
 	io_req_task_work_add(req, !!(req->ctx->flags & IORING_SETUP_SQPOLL));
 }
@@ -3041,12 +3038,12 @@ static void io_complete_rw_iopoll(struct kiocb *kiocb, long res)
 
 	if (kiocb->ki_flags & IOCB_WRITE)
 		kiocb_end_write(req);
-	if (unlikely(res != req->result)) {
+	if (unlikely(res != req->cqe.res)) {
 		if (res == -EAGAIN && io_rw_should_reissue(req)) {
 			req->flags |= REQ_F_REISSUE;
 			return;
 		}
-		req->result = res;
+		req->cqe.res = res;
 	}
 
 	/* order with io_iopoll_complete() checking ->iopoll_completed */
@@ -3838,7 +3835,7 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
 	ret = io_rw_init_file(req, FMODE_READ);
 	if (unlikely(ret))
 		return ret;
-	req->result = iov_iter_count(&s->iter);
+	req->cqe.res = iov_iter_count(&s->iter);
 
 	if (force_nonblock) {
 		/* If the file doesn't support async, just async punt */
@@ -3854,7 +3851,7 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
 
 	ppos = io_kiocb_update_pos(req);
 
-	ret = rw_verify_area(READ, req->file, ppos, req->result);
+	ret = rw_verify_area(READ, req->file, ppos, req->cqe.res);
 	if (unlikely(ret)) {
 		kfree(iovec);
 		return ret;
@@ -3876,7 +3873,7 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
 		ret = 0;
 	} else if (ret == -EIOCBQUEUED) {
 		goto out_free;
-	} else if (ret == req->result || ret <= 0 || !force_nonblock ||
+	} else if (ret == req->cqe.res || ret <= 0 || !force_nonblock ||
 		   (req->flags & REQ_F_NOWAIT) || !need_read_all(req)) {
 		/* read all, failed, already did sync or don't want to retry */
 		goto done;
@@ -3964,7 +3961,7 @@ static int io_write(struct io_kiocb *req, unsigned int issue_flags)
 	ret = io_rw_init_file(req, FMODE_WRITE);
 	if (unlikely(ret))
 		return ret;
-	req->result = iov_iter_count(&s->iter);
+	req->cqe.res = iov_iter_count(&s->iter);
 
 	if (force_nonblock) {
 		/* If the file doesn't support async, just async punt */
@@ -3984,7 +3981,7 @@ static int io_write(struct io_kiocb *req, unsigned int issue_flags)
 
 	ppos = io_kiocb_update_pos(req);
 
-	ret = rw_verify_area(WRITE, req->file, ppos, req->result);
+	ret = rw_verify_area(WRITE, req->file, ppos, req->cqe.res);
 	if (unlikely(ret))
 		goto out_free;
 
@@ -5769,7 +5766,7 @@ static void io_poll_req_insert(struct io_kiocb *req)
 	struct io_ring_ctx *ctx = req->ctx;
 	struct hlist_head *list;
 
-	list = &ctx->cancel_hash[hash_long(req->user_data, ctx->cancel_hash_bits)];
+	list = &ctx->cancel_hash[hash_long(req->cqe.user_data, ctx->cancel_hash_bits)];
 	hlist_add_head(&req->hash_node, list);
 }
 
@@ -5834,7 +5831,7 @@ static void io_poll_remove_entries(struct io_kiocb *req)
  *
  * Returns a negative error on failure. >0 when no action require, which is
  * either spurious wakeup or multishot CQE is served. 0 when it's done with
- * the request, then the mask is stored in req->result.
+ * the request, then the mask is stored in req->cqe.res.
  */
 static int io_poll_check_events(struct io_kiocb *req, bool locked)
 {
@@ -5855,29 +5852,29 @@ static int io_poll_check_events(struct io_kiocb *req, bool locked)
 		if (v & IO_POLL_CANCEL_FLAG)
 			return -ECANCELED;
 
-		if (!req->result) {
-			struct poll_table_struct pt = { ._key = req->cflags };
+		if (!req->cqe.res) {
+			struct poll_table_struct pt = { ._key = req->cqe.flags };
 
 			if (unlikely(!io_assign_file(req, IO_URING_F_UNLOCKED)))
-				req->result = -EBADF;
+				req->cqe.res = -EBADF;
 			else
-				req->result = vfs_poll(req->file, &pt) & req->cflags;
+				req->cqe.res = vfs_poll(req->file, &pt) & req->cqe.flags;
 		}
 
 		/* multishot, just fill an CQE and proceed */
-		if (req->result && !(req->cflags & EPOLLONESHOT)) {
-			__poll_t mask = mangle_poll(req->result & poll->events);
+		if (req->cqe.res && !(req->cqe.flags & EPOLLONESHOT)) {
+			__poll_t mask = mangle_poll(req->cqe.res & poll->events);
 			bool filled;
 
 			spin_lock(&ctx->completion_lock);
-			filled = io_fill_cqe_aux(ctx, req->user_data, mask,
+			filled = io_fill_cqe_aux(ctx, req->cqe.user_data, mask,
 						 IORING_CQE_F_MORE);
 			io_commit_cqring(ctx);
 			spin_unlock(&ctx->completion_lock);
 			if (unlikely(!filled))
 				return -ECANCELED;
 			io_cqring_ev_posted(ctx);
-		} else if (req->result) {
+		} else if (req->cqe.res) {
 			return 0;
 		}
 
@@ -5900,16 +5897,16 @@ static void io_poll_task_func(struct io_kiocb *req, bool *locked)
 		return;
 
 	if (!ret) {
-		req->result = mangle_poll(req->result & req->poll.events);
+		req->cqe.res = mangle_poll(req->cqe.res & req->poll.events);
 	} else {
-		req->result = ret;
+		req->cqe.res = ret;
 		req_set_fail(req);
 	}
 
 	io_poll_remove_entries(req);
 	spin_lock(&ctx->completion_lock);
 	hash_del(&req->hash_node);
-	__io_req_complete_post(req, req->result, 0);
+	__io_req_complete_post(req, req->cqe.res, 0);
 	io_commit_cqring(ctx);
 	spin_unlock(&ctx->completion_lock);
 	io_cqring_ev_posted(ctx);
@@ -5937,20 +5934,20 @@ static void io_apoll_task_func(struct io_kiocb *req, bool *locked)
 
 static void __io_poll_execute(struct io_kiocb *req, int mask, int events)
 {
-	req->result = mask;
+	req->cqe.res = mask;
 	/*
 	 * This is useful for poll that is armed on behalf of another
 	 * request, and where the wakeup path could be on a different
 	 * CPU. We want to avoid pulling in req->apoll->events for that
 	 * case.
 	 */
-	req->cflags = events;
+	req->cqe.flags = events;
 	if (req->opcode == IORING_OP_POLL_ADD)
 		req->io_task_work.func = io_poll_task_func;
 	else
 		req->io_task_work.func = io_apoll_task_func;
 
-	trace_io_uring_task_add(req->ctx, req, req->user_data, req->opcode, mask);
+	trace_io_uring_task_add(req->ctx, req, req->cqe.user_data, req->opcode, mask);
 	io_req_task_work_add(req, false);
 }
 
@@ -6200,7 +6197,7 @@ static int io_arm_poll_handler(struct io_kiocb *req, unsigned issue_flags)
 	if (ret || ipt.error)
 		return ret ? IO_APOLL_READY : IO_APOLL_ABORTED;
 
-	trace_io_uring_poll_arm(ctx, req, req->user_data, req->opcode,
+	trace_io_uring_poll_arm(ctx, req, req->cqe.user_data, req->opcode,
 				mask, apoll->poll.events);
 	return IO_APOLL_OK;
 }
@@ -6242,7 +6239,7 @@ static struct io_kiocb *io_poll_find(struct io_ring_ctx *ctx, __u64 sqe_addr,
 
 	list = &ctx->cancel_hash[hash_long(sqe_addr, ctx->cancel_hash_bits)];
 	hlist_for_each_entry(req, list, hash_node) {
-		if (sqe_addr != req->user_data)
+		if (sqe_addr != req->cqe.user_data)
 			continue;
 		if (poll_only && req->opcode != IORING_OP_POLL_ADD)
 			continue;
@@ -6336,7 +6333,7 @@ static int io_poll_add_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
 		return -EINVAL;
 
 	io_req_set_refcount(req);
-	req->cflags = poll->events = io_poll_parse_events(sqe, flags);
+	req->cqe.flags = poll->events = io_poll_parse_events(sqe, flags);
 	return 0;
 }
 
@@ -6379,7 +6376,7 @@ static int io_poll_update(struct io_kiocb *req, unsigned int issue_flags)
 			preq->poll.events |= IO_POLL_UNMASK;
 		}
 		if (req->poll_update.update_user_data)
-			preq->user_data = req->poll_update.new_user_data;
+			preq->cqe.user_data = req->poll_update.new_user_data;
 
 		ret2 = io_poll_add(preq, issue_flags);
 		/* successfully updated, don't complete poll request */
@@ -6388,7 +6385,7 @@ static int io_poll_update(struct io_kiocb *req, unsigned int issue_flags)
 	}
 
 	req_set_fail(preq);
-	preq->result = -ECANCELED;
+	preq->cqe.res = -ECANCELED;
 	locked = !(issue_flags & IO_URING_F_UNLOCKED);
 	io_req_task_complete(preq, &locked);
 out:
@@ -6416,7 +6413,7 @@ static enum hrtimer_restart io_timeout_fn(struct hrtimer *timer)
 	if (!(data->flags & IORING_TIMEOUT_ETIME_SUCCESS))
 		req_set_fail(req);
 
-	req->result = -ETIME;
+	req->cqe.res = -ETIME;
 	req->io_task_work.func = io_req_task_complete;
 	io_req_task_work_add(req, false);
 	return HRTIMER_NORESTART;
@@ -6431,7 +6428,7 @@ static struct io_kiocb *io_timeout_extract(struct io_ring_ctx *ctx,
 	bool found = false;
 
 	list_for_each_entry(req, &ctx->timeout_list, timeout.list) {
-		found = user_data == req->user_data;
+		found = user_data == req->cqe.user_data;
 		if (found)
 			break;
 	}
@@ -6482,7 +6479,7 @@ static int io_linked_timeout_update(struct io_ring_ctx *ctx, __u64 user_data,
 	bool found = false;
 
 	list_for_each_entry(req, &ctx->ltimeout_list, timeout.list) {
-		found = user_data == req->user_data;
+		found = user_data == req->cqe.user_data;
 		if (found)
 			break;
 	}
@@ -6707,7 +6704,7 @@ static bool io_cancel_cb(struct io_wq_work *work, void *data)
 	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
 	struct io_cancel_data *cd = data;
 
-	return req->ctx == cd->ctx && req->user_data == cd->user_data;
+	return req->ctx == cd->ctx && req->cqe.user_data == cd->user_data;
 }
 
 static int io_async_cancel_one(struct io_uring_task *tctx, u64 user_data,
@@ -7007,7 +7004,7 @@ static __cold void io_drain_req(struct io_kiocb *req)
 		goto queue;
 	}
 
-	trace_io_uring_defer(ctx, req, req->user_data, req->opcode);
+	trace_io_uring_defer(ctx, req, req->cqe.user_data, req->opcode);
 	de->req = req;
 	de->seq = seq;
 	list_add_tail(&de->list, &ctx->defer_list);
@@ -7098,7 +7095,7 @@ static bool io_assign_file(struct io_kiocb *req, unsigned int issue_flags)
 		return true;
 
 	req_set_fail(req);
-	req->result = -EBADF;
+	req->cqe.res = -EBADF;
 	return false;
 }
 
@@ -7384,7 +7381,7 @@ static struct file *io_file_get_normal(struct io_kiocb *req, int fd)
 {
 	struct file *file = fget(fd);
 
-	trace_io_uring_file_get(req->ctx, req, req->user_data, fd);
+	trace_io_uring_file_get(req->ctx, req, req->cqe.user_data, fd);
 
 	/* we don't allow fixed io_uring files */
 	if (file && file->f_op == &io_uring_fops)
@@ -7399,7 +7396,7 @@ static void io_req_task_link_timeout(struct io_kiocb *req, bool *locked)
 
 	if (prev) {
 		if (!(req->task->flags & PF_EXITING))
-			ret = io_try_cancel_userdata(req, prev->user_data);
+			ret = io_try_cancel_userdata(req, prev->cqe.user_data);
 		io_req_complete_post(req, ret ?: -ETIME, 0);
 		io_put_req(prev);
 	} else {
@@ -7590,7 +7587,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	req->opcode = opcode = READ_ONCE(sqe->opcode);
 	/* same numerical values with corresponding REQ_F_*, safe to copy */
 	req->flags = sqe_flags = READ_ONCE(sqe->flags);
-	req->user_data = READ_ONCE(sqe->user_data);
+	req->cqe.user_data = READ_ONCE(sqe->user_data);
 	req->file = NULL;
 	req->fixed_rsrc_refs = NULL;
 	req->task = current;
@@ -7680,7 +7677,7 @@ static int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
 			 * we can judge a link req is failed or cancelled by if
 			 * REQ_F_FAIL is set, but the head is an exception since
 			 * it may be set REQ_F_FAIL because of other req's failure
-			 * so let's leverage req->result to distinguish if a head
+			 * so let's leverage req->cqe.res to distinguish if a head
 			 * is set REQ_F_FAIL because of its failure or other req's
 			 * failure so that we can set the correct ret code for it.
 			 * init result here to avoid affecting the normal path.
@@ -7699,7 +7696,7 @@ static int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	}
 
 	/* don't need @sqe from now on */
-	trace_io_uring_submit_sqe(ctx, req, req->user_data, req->opcode,
+	trace_io_uring_submit_sqe(ctx, req, req->cqe.user_data, req->opcode,
 				  req->flags, true,
 				  ctx->flags & IORING_SETUP_SQPOLL);
 
-- 
2.35.1

