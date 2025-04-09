Return-Path: <io-uring+bounces-7443-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 044E9A8267B
	for <lists+io-uring@lfdr.de>; Wed,  9 Apr 2025 15:42:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ECB331BA8063
	for <lists+io-uring@lfdr.de>; Wed,  9 Apr 2025 13:41:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6FE426562A;
	Wed,  9 Apr 2025 13:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="PHAtXMI9"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8A74264627
	for <io-uring@vger.kernel.org>; Wed,  9 Apr 2025 13:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744206070; cv=none; b=rdTWLJD1JTh2unHXtiE6CUDLqayo4gefzXu+oOW6x9vQSwYy5DuO8Xh9uCvJsAWRrneiLwpk3XSZ/8q0+Fmtka8FNJzJo2t5T/8gLC3mHYIzF+nZIH80kwnhVc9GkEC+B+kUmwV9LuHM+kXj+qA973qWJS3rY65wyOH4gs3rsoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744206070; c=relaxed/simple;
	bh=bNUswGMrRBywSA9q8tHpCOtLHsm0JdawTIqhKFbCOXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RYV0gj4ee0VZ3M44ON54gW8edeoYMROQMnBUxRktILIL6BRwZ0/pQSiYE9gUO5lY8+sGajTfMWVYCLWmTH6zFSTOjPIqaffIhK23OJI83ai5NoD28gbCDt1sLK1G9Ta3axhe1sfPaicqPop1/qxVFt5DvpfUp3UolH4mNqOPcBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=PHAtXMI9; arc=none smtp.client-ip=209.85.166.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f42.google.com with SMTP id ca18e2360f4ac-86142446f3fso81035539f.2
        for <io-uring@vger.kernel.org>; Wed, 09 Apr 2025 06:41:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1744206067; x=1744810867; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P2ddNOKe/CjnvbH2FCKVac1wky9jTUmQl0vfrBQN8UU=;
        b=PHAtXMI9+5LUiYWwg/KftzwtxEinZ0H0FQYPsTWEFTuZMahwOEyGxNr9P8gN2Pzf9B
         Tv3ucKoFribONCsjMrU3uFYUwLE+haVFAqOr+va2eHeIRTkUilIcU5KE81xBoZghuhar
         hNLytURMdwfok2hkEqzuA3IN9cxh62xl3JfFpU1eMtskvgMcwB9ITtSU5+dyyNYjWNyF
         yBP81Ehd3AY438uoUurOnZNygVz0FUlfky7k9hGOzIhEoKw1LB9D7/FQHH3pwAT7Ix0e
         xePQKgGlVYuHhlta92s95lh4MER2flndr46lcVXvYLnhypcS6537UQCdRvp0goQaZziq
         PNTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744206067; x=1744810867;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=P2ddNOKe/CjnvbH2FCKVac1wky9jTUmQl0vfrBQN8UU=;
        b=QncQGUw9/YHVwKBwjCL1KCfQeLgYwlzBVgmo/0V+StmhXumSrN3W2u8x21UQdlQRBn
         XVHWUv6CuQixZdS822JEvM0xLaED1DkoTV5MhT2ORhufAZVlxrGY9KC/sd3T9Q/S4m1G
         ipt8r9hxadqoo4aynNGWvARgQbnlP6Boc4m5lbovHnSztVoFYN+7xsCGNaDRBUxvLk33
         mznIzzhNK+Mbx0VjFXh5pq5jtwTget/hBotkESdjr90wo+I76B8TjGEqUFue2T7WLH8J
         69ex6iSNruOL3ZDCcClRSHPvdvNgyfh4HcWL09B7h0gYzlZgorBcl2p8/jCoWMGTgD2U
         HV6A==
X-Gm-Message-State: AOJu0YzTWjii0tY2ZrTO+zjTG2Da5n/l2nxFB0NULIM6HfG/tCmdCnQO
	2fmUijRmxTTvwu0PNHCCZnIQsfmOoDSh5u/NnxP2wYh6xFDO6cYrgxEqn3UCJu5VWPBnBgbKIDt
	l
X-Gm-Gg: ASbGncvzEOd+dYUDCKZT/DFrow/FqUNn2Al2fIKF5xDDtNGf+UpA7LvzlJDT/ntKc6z
	F3MuklcK1ZSlH8doy8LONnHhdG+0jDS8I1biaJMH/yh5yQWXxXM+sle0cArm3yJRNkGvaO2bHZ+
	d827hnLNMrEey/HkQuk6twCKH7Jml0SNWWwyAwUhroU0qa6c9p/iP3OOBAM3j6pP5VXYOZMBVsi
	IjakJ7mFlt6Lmx8Vjzr1hgOZ+p06vANK/ZtFlO9hoX+Mu+cFhKu8kSWvwDGAxH+e4zPU/aC7ytK
	nCq9NFXWojnPGN8aEy4WjHyCwLwIoWPl7/ls5pvyV23Fe4Kejt0WQQA=
X-Google-Smtp-Source: AGHT+IEN3JUq4v6oDxM51FqvQxj3GrioM+dxBZerBvqnUOao/pNwkPCyLmECD6Z3/lbRjnvehjTJkg==
X-Received: by 2002:a05:6602:358c:b0:855:5e3a:e56b with SMTP id ca18e2360f4ac-86161288497mr343783839f.12.1744206067402;
        Wed, 09 Apr 2025 06:41:07 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f505e2eaeesm242546173.126.2025.04.09.06.41.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Apr 2025 06:41:06 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	brauner@kernel.org,
	linux-fsdevel@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5/5] io_uring: switch away from percpu refcounts
Date: Wed,  9 Apr 2025 07:35:23 -0600
Message-ID: <20250409134057.198671-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250409134057.198671-1-axboe@kernel.dk>
References: <20250409134057.198671-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For the common cases, the io_uring ref counts are all batched and hence
need not be a percpu reference. This saves some memory on systems, but
outside of that, it gets rid of needing a full RCU grace period on
tearing down the reference. With io_uring now waiting on cancelations
and IO during exit, this slows down the tear down a lot, up to 100x
as slow.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/io_uring_types.h |  2 +-
 io_uring/io_uring.c            | 47 ++++++++++++----------------------
 io_uring/io_uring.h            |  3 ++-
 io_uring/msg_ring.c            |  4 +--
 io_uring/refs.h                | 43 +++++++++++++++++++++++++++++++
 io_uring/register.c            |  2 +-
 io_uring/rw.c                  |  2 +-
 io_uring/sqpoll.c              |  2 +-
 io_uring/zcrx.c                |  4 +--
 9 files changed, 70 insertions(+), 39 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 4d26aef281fb..bcafd7cc8c26 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -256,7 +256,7 @@ struct io_ring_ctx {
 
 		struct task_struct	*submitter_task;
 		struct io_rings		*rings;
-		struct percpu_ref	refs;
+		atomic_long_t		refs;
 
 		clockid_t		clockid;
 		enum tk_offsets		clock_offset;
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 4b3e3ff774d6..8b2f8a081ef6 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -252,13 +252,6 @@ static __cold void io_kworker_tw_end(void)
 	current->flags |= PF_NO_TASKWORK;
 }
 
-static __cold void io_ring_ctx_ref_free(struct percpu_ref *ref)
-{
-	struct io_ring_ctx *ctx = container_of(ref, struct io_ring_ctx, refs);
-
-	complete(&ctx->ref_comp);
-}
-
 static __cold void io_fallback_req_func(struct work_struct *work)
 {
 	struct io_ring_ctx *ctx = container_of(work, struct io_ring_ctx,
@@ -269,13 +262,13 @@ static __cold void io_fallback_req_func(struct work_struct *work)
 
 	io_kworker_tw_start();
 
-	percpu_ref_get(&ctx->refs);
+	io_ring_ref_get(ctx);
 	mutex_lock(&ctx->uring_lock);
 	llist_for_each_entry_safe(req, tmp, node, io_task_work.node)
 		req->io_task_work.func(req, ts);
 	io_submit_flush_completions(ctx);
 	mutex_unlock(&ctx->uring_lock);
-	percpu_ref_put(&ctx->refs);
+	io_ring_ref_put(ctx);
 	io_kworker_tw_end();
 }
 
@@ -333,10 +326,8 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	hash_bits = clamp(hash_bits, 1, 8);
 	if (io_alloc_hash_table(&ctx->cancel_table, hash_bits))
 		goto err;
-	if (percpu_ref_init(&ctx->refs, io_ring_ctx_ref_free,
-			    0, GFP_KERNEL))
-		goto err;
 
+	io_ring_ref_init(ctx);
 	ctx->flags = p->flags;
 	ctx->hybrid_poll_time = LLONG_MAX;
 	atomic_set(&ctx->cq_wait_nr, IO_CQ_WAKE_INIT);
@@ -360,7 +351,7 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	ret |= io_futex_cache_init(ctx);
 	ret |= io_rsrc_cache_init(ctx);
 	if (ret)
-		goto free_ref;
+		goto err;
 	init_completion(&ctx->ref_comp);
 	xa_init_flags(&ctx->personalities, XA_FLAGS_ALLOC1);
 	mutex_init(&ctx->uring_lock);
@@ -386,9 +377,6 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	mutex_init(&ctx->mmap_lock);
 
 	return ctx;
-
-free_ref:
-	percpu_ref_exit(&ctx->refs);
 err:
 	io_free_alloc_caches(ctx);
 	kvfree(ctx->cancel_table.hbs);
@@ -556,7 +544,7 @@ static void io_queue_iowq(struct io_kiocb *req)
 	 * worker for it).
 	 */
 	if (WARN_ON_ONCE(!same_thread_group(tctx->task, current) ||
-			 percpu_ref_is_dying(&req->ctx->refs)))
+			 io_ring_ref_is_dying(req->ctx)))
 		atomic_or(IO_WQ_WORK_CANCEL, &req->work.flags);
 
 	trace_io_uring_queue_async_work(req, io_wq_is_hashed(&req->work));
@@ -991,7 +979,7 @@ __cold bool __io_alloc_req_refill(struct io_ring_ctx *ctx)
 		ret = 1;
 	}
 
-	percpu_ref_get_many(&ctx->refs, ret);
+	io_ring_ref_get_many(ctx, ret);
 	while (ret--) {
 		struct io_kiocb *req = reqs[ret];
 
@@ -1046,7 +1034,7 @@ static void ctx_flush_and_put(struct io_ring_ctx *ctx, io_tw_token_t tw)
 
 	io_submit_flush_completions(ctx);
 	mutex_unlock(&ctx->uring_lock);
-	percpu_ref_put(&ctx->refs);
+	io_ring_ref_put(ctx);
 }
 
 /*
@@ -1070,7 +1058,7 @@ struct llist_node *io_handle_tw_list(struct llist_node *node,
 			ctx_flush_and_put(ctx, ts);
 			ctx = req->ctx;
 			mutex_lock(&ctx->uring_lock);
-			percpu_ref_get(&ctx->refs);
+			io_ring_ref_get(ctx);
 		}
 		INDIRECT_CALL_2(req->io_task_work.func,
 				io_poll_task_func, io_req_rw_complete,
@@ -1099,10 +1087,10 @@ static __cold void __io_fallback_tw(struct llist_node *node, bool sync)
 		if (sync && last_ctx != req->ctx) {
 			if (last_ctx) {
 				flush_delayed_work(&last_ctx->fallback_work);
-				percpu_ref_put(&last_ctx->refs);
+				io_ring_ref_put(last_ctx);
 			}
 			last_ctx = req->ctx;
-			percpu_ref_get(&last_ctx->refs);
+			io_ring_ref_get(last_ctx);
 		}
 		if (llist_add(&req->io_task_work.node,
 			      &req->ctx->fallback_llist))
@@ -1111,7 +1099,7 @@ static __cold void __io_fallback_tw(struct llist_node *node, bool sync)
 
 	if (last_ctx) {
 		flush_delayed_work(&last_ctx->fallback_work);
-		percpu_ref_put(&last_ctx->refs);
+		io_ring_ref_put(last_ctx);
 	}
 }
 
@@ -1247,7 +1235,7 @@ static void io_req_normal_work_add(struct io_kiocb *req)
 		return;
 	}
 
-	if (!percpu_ref_is_dying(&ctx->refs) &&
+	if (!io_ring_ref_is_dying(ctx) &&
 	    !task_work_add(tctx->task, &tctx->task_work, ctx->notify_method))
 		return;
 
@@ -2736,7 +2724,7 @@ static void io_req_caches_free(struct io_ring_ctx *ctx)
 		nr++;
 	}
 	if (nr)
-		percpu_ref_put_many(&ctx->refs, nr);
+		io_ring_ref_put_many(ctx, nr);
 	mutex_unlock(&ctx->uring_lock);
 }
 
@@ -2770,7 +2758,6 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	if (!(ctx->flags & IORING_SETUP_NO_SQARRAY))
 		static_branch_dec(&io_key_has_sqarray);
 
-	percpu_ref_exit(&ctx->refs);
 	free_uid(ctx->user);
 	io_req_caches_free(ctx);
 	if (ctx->hash_map)
@@ -2795,7 +2782,7 @@ static __cold void io_activate_pollwq_cb(struct callback_head *cb)
 	 * might've been lost due to loose synchronisation.
 	 */
 	wake_up_all(&ctx->poll_wq);
-	percpu_ref_put(&ctx->refs);
+	io_ring_ref_put(ctx);
 }
 
 __cold void io_activate_pollwq(struct io_ring_ctx *ctx)
@@ -2813,9 +2800,9 @@ __cold void io_activate_pollwq(struct io_ring_ctx *ctx)
 	 * only need to sync with it, which is done by injecting a tw
 	 */
 	init_task_work(&ctx->poll_wq_task_work, io_activate_pollwq_cb);
-	percpu_ref_get(&ctx->refs);
+	io_ring_ref_get(ctx);
 	if (task_work_add(ctx->submitter_task, &ctx->poll_wq_task_work, TWA_SIGNAL))
-		percpu_ref_put(&ctx->refs);
+		io_ring_ref_put(ctx);
 out:
 	spin_unlock(&ctx->completion_lock);
 }
@@ -3002,7 +2989,7 @@ static __cold void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
 	struct creds *creds;
 
 	mutex_lock(&ctx->uring_lock);
-	percpu_ref_kill(&ctx->refs);
+	io_ring_ref_kill(ctx);
 	xa_for_each(&ctx->personalities, index, creds)
 		io_unregister_personality(ctx, index);
 	mutex_unlock(&ctx->uring_lock);
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index e4050b2d0821..f8500221dd82 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -13,6 +13,7 @@
 #include "slist.h"
 #include "filetable.h"
 #include "opdef.h"
+#include "refs.h"
 
 #ifndef CREATE_TRACE_POINTS
 #include <trace/events/io_uring.h>
@@ -142,7 +143,7 @@ static inline void io_lockdep_assert_cq_locked(struct io_ring_ctx *ctx)
 		 * Not from an SQE, as those cannot be submitted, but via
 		 * updating tagged resources.
 		 */
-		if (!percpu_ref_is_dying(&ctx->refs))
+		if (!io_ring_ref_is_dying(ctx))
 			lockdep_assert(current == ctx->submitter_task);
 	}
 #endif
diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
index 50a958e9c921..00d6a9ed2431 100644
--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -83,7 +83,7 @@ static void io_msg_tw_complete(struct io_kiocb *req, io_tw_token_t tw)
 	}
 	if (req)
 		kmem_cache_free(req_cachep, req);
-	percpu_ref_put(&ctx->refs);
+	io_ring_ref_put(ctx);
 }
 
 static int io_msg_remote_post(struct io_ring_ctx *ctx, struct io_kiocb *req,
@@ -96,7 +96,7 @@ static int io_msg_remote_post(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	req->opcode = IORING_OP_NOP;
 	req->cqe.user_data = user_data;
 	io_req_set_res(req, res, cflags);
-	percpu_ref_get(&ctx->refs);
+	io_ring_ref_get(ctx);
 	req->ctx = ctx;
 	req->tctx = NULL;
 	req->io_task_work.func = io_msg_tw_complete;
diff --git a/io_uring/refs.h b/io_uring/refs.h
index 0d928d87c4ed..9cda88a0a0d5 100644
--- a/io_uring/refs.h
+++ b/io_uring/refs.h
@@ -59,4 +59,47 @@ static inline void io_req_set_refcount(struct io_kiocb *req)
 {
 	__io_req_set_refcount(req, 1);
 }
+
+#define IO_RING_REF_DEAD	(1UL << (BITS_PER_LONG - 1))
+#define IO_RING_REF_MASK	(~IO_RING_REF_DEAD)
+
+static inline bool io_ring_ref_is_dying(struct io_ring_ctx *ctx)
+{
+	return atomic_long_read(&ctx->refs) & IO_RING_REF_DEAD;
+}
+
+static inline void io_ring_ref_put_many(struct io_ring_ctx *ctx, int nr_refs)
+{
+	unsigned long refs;
+
+	refs = atomic_long_sub_return(nr_refs, &ctx->refs);
+	if (!(refs & IO_RING_REF_MASK))
+		complete(&ctx->ref_comp);
+}
+
+static inline void io_ring_ref_put(struct io_ring_ctx *ctx)
+{
+	io_ring_ref_put_many(ctx, 1);
+}
+
+static inline void io_ring_ref_kill(struct io_ring_ctx *ctx)
+{
+	atomic_long_xor(IO_RING_REF_DEAD, &ctx->refs);
+	io_ring_ref_put(ctx);
+}
+
+static inline void io_ring_ref_init(struct io_ring_ctx *ctx)
+{
+	atomic_long_set(&ctx->refs, 1);
+}
+
+static inline void io_ring_ref_get_many(struct io_ring_ctx *ctx, int nr_refs)
+{
+	atomic_long_add(nr_refs, &ctx->refs);
+}
+
+static inline void io_ring_ref_get(struct io_ring_ctx *ctx)
+{
+	atomic_long_inc(&ctx->refs);
+}
 #endif
diff --git a/io_uring/register.c b/io_uring/register.c
index cc23a4c205cd..54fe94a0101b 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -637,7 +637,7 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 	 * We don't quiesce the refs for register anymore and so it can't be
 	 * dying as we're holding a file ref here.
 	 */
-	if (WARN_ON_ONCE(percpu_ref_is_dying(&ctx->refs)))
+	if (WARN_ON_ONCE(io_ring_ref_is_dying(ctx)))
 		return -ENXIO;
 
 	if (ctx->submitter_task && ctx->submitter_task != current)
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 039e063f7091..e010d548edea 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -496,7 +496,7 @@ static bool io_rw_should_reissue(struct io_kiocb *req)
 	 * Don't attempt to reissue from that path, just let it fail with
 	 * -EAGAIN.
 	 */
-	if (percpu_ref_is_dying(&ctx->refs))
+	if (io_ring_ref_is_dying(ctx))
 		return false;
 
 	io_meta_restore(io, &rw->kiocb);
diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
index d037cc68e9d3..b71f8d52386e 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -184,7 +184,7 @@ static int __io_sq_thread(struct io_ring_ctx *ctx, bool cap_entries)
 		 * Don't submit if refs are dying, good for io_uring_register(),
 		 * but also it is relied upon by io_ring_exit_work()
 		 */
-		if (to_submit && likely(!percpu_ref_is_dying(&ctx->refs)) &&
+		if (to_submit && likely(!io_ring_ref_is_dying(ctx)) &&
 		    !(ctx->flags & IORING_SETUP_R_DISABLED))
 			ret = io_submit_sqes(ctx, to_submit);
 		mutex_unlock(&ctx->uring_lock);
diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 0f46e0404c04..e8dbed7b8171 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -630,7 +630,7 @@ static int io_pp_zc_init(struct page_pool *pp)
 	if (pp->p.dma_dir != DMA_FROM_DEVICE)
 		return -EOPNOTSUPP;
 
-	percpu_ref_get(&ifq->ctx->refs);
+	io_ring_ref_get(ifq->ctx);
 	return 0;
 }
 
@@ -641,7 +641,7 @@ static void io_pp_zc_destroy(struct page_pool *pp)
 
 	if (WARN_ON_ONCE(area->free_count != area->nia.num_niovs))
 		return;
-	percpu_ref_put(&ifq->ctx->refs);
+	io_ring_ref_put(ifq->ctx);
 }
 
 static int io_pp_nl_fill(void *mp_priv, struct sk_buff *rsp,
-- 
2.49.0


