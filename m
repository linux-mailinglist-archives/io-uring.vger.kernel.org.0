Return-Path: <io-uring+bounces-9552-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F2360B412E5
	for <lists+io-uring@lfdr.de>; Wed,  3 Sep 2025 05:27:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 81A3E1B24442
	for <lists+io-uring@lfdr.de>; Wed,  3 Sep 2025 03:27:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 903FD2D0634;
	Wed,  3 Sep 2025 03:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="H02xFUjQ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yb1-f226.google.com (mail-yb1-f226.google.com [209.85.219.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21D3C2C3245
	for <io-uring@vger.kernel.org>; Wed,  3 Sep 2025 03:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756870023; cv=none; b=jhJdCmFA4pTuD/OC2VgSVwyMbr0hNxL9n5IEIQpzhU1l3s+fP9GzWFy5+6Dt7CHvK+ECNqSA1Nqqk/cDkmtQeUeQgcG8xJRqsYD26TiMcePX7ElLBB7BTqU9dAoGui5nbE3vfd+Xy0jQ4ob6VH7BFEEs65IywBo4+sP+7TW95AA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756870023; c=relaxed/simple;
	bh=VGhRdcgIPamkVki4XU7NEO9Cf8tfJP+zcLBPTF0R5ZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q594wqkf4DKG9efFLkFhvITz3HjHy5oRLibLqsbW1Pgn3PzlPLIboKwnQ4NRiR8+tVw+rzy7vXE723W6Jm0DCigckv3JgdFIemCenUShno5/Elmk9UuWvq0Enx3Oqk77z+8z1vSnfmNiLdsbdgBplmJbOIofnkl1E3jOxCKc6sU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=H02xFUjQ; arc=none smtp.client-ip=209.85.219.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-yb1-f226.google.com with SMTP id 3f1490d57ef6-e96dbef51e8so927502276.2
        for <io-uring@vger.kernel.org>; Tue, 02 Sep 2025 20:27:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1756870020; x=1757474820; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uQvmwor8x7PnbCSbpEzXCUbcOnrK52uWsyerHQsV0X4=;
        b=H02xFUjQUlx80ZkphFnH7LBLXzMKCF7RbkhwNCy4z+i9GCzzDclUYolt2c5Rzv/6kc
         UzE+npsoyJzXSlUJAtdX9CbZRWAtaI7OWqC8LZNYCQZSY3CYpgTHiftHfLB1MJZZHyB5
         TnLN6c4/AUOvkYTLxwDGxkiv1UbUZoDFP+0fhHtSvHg8tyGcejXfBxBUD0E79mG4Ppxu
         CkYW6mZVgHsY9Qs69NHWuEtM/CGb0TEL2jnOHBj/I5RqXaUYscytboVHmHdpfdG0jsQQ
         tuf7jIDU5E+gKDQto8b6Cxi3/csjd3pQmwqOT5Z4uyzTAvmVpiw88yg3dHi0pZ6VrZik
         nhnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756870020; x=1757474820;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uQvmwor8x7PnbCSbpEzXCUbcOnrK52uWsyerHQsV0X4=;
        b=cvN+X1EsAZBefzQ6Zd4v5tup/L4vpFuSnii2j+l2N8PGs6L1rCpVoE/MHXi+rVDTPp
         KYJ4xt71OrPpJaQt/NkMwxdj0lVmtOgaB5VgXlxVcjikpmI/Dj8r3nHh4fvsCzwlZJZY
         Sj6qZ2x11YIjC660xx6CYS4N1NSTgj3BXkyy518rGGHNNCUQAuSX2mA4h7vxsUCq2IbO
         7XMXpma1mlb3FoQCVe8cqY3sgw7U1unZwWy/aq2QYXrzQxGr2J2++B9apuH6hGkS666q
         AIcsOFZ0c1WwGeJbPgmyRkASg4FJ/SfBv9436p0Igh9QqAahFSTPl8vxAnDPsU41u4ja
         obeQ==
X-Gm-Message-State: AOJu0YwcRdJSwTD77x0y4iRI9YHdjRM0NK3HcCpddMW+H5gi7it9e9Zz
	QEYNATeXtg9K8SOW0DA4vMaK4hn9vUdQBSYKVEbxMbTo7UN+7V2ObRFYM32XOzFfx1EUjxirLFf
	IvupZu5kxXI1kk76LugJdGvVzM/C8Wgpt+CKm
X-Gm-Gg: ASbGnctFUEMRWiEOF7Cq2GbBszz8msQmIdDIIgvBsYI6euUuEJNHCGN7takW7ZAanV6
	BdLQnoLXqnIGT8K72ur5Ic+kgzdB/x4ehOWHHRzIx8v2Lb+3d8BiT9LJHwdMcUi8Q3923t6wxIs
	q6jMtZTngnjOL2vZBXp7P5KnBaD7LLXC91sJ/z0AU5i9ZeSRjtKDSuPKaRhLDHAC4+pI1IGyWpp
	APyKehXLlSSDJQbqcjJxzEjT+omgJGDhrzQUYcoI1thh4szlVG2lM4UBPoxklWIwbVJn0auv1nI
	io6w0NxrsJnCSK6en+UiDJ0fMQH/kVy6oPWeXDRm5XEzCkeDA0UUCqJLWVb0kJVgYI9rZ4wN
X-Google-Smtp-Source: AGHT+IGBqr10WvIKh9YRjMH6vAho8CO+frP1+TdiO5aBt99ESoONK7h28C9iEpVtu2Igo0Xx4ZC/7CdO1gxi
X-Received: by 2002:a05:6902:1896:b0:e97:d40:4745 with SMTP id 3f1490d57ef6-e989be977efmr11484179276.2.1756870020022;
        Tue, 02 Sep 2025 20:27:00 -0700 (PDT)
Received: from c7-smtp-2023.dev.purestorage.com ([208.88.159.128])
        by smtp-relay.gmail.com with ESMTPS id 3f1490d57ef6-e9bbdf67835sm265156276.8.2025.09.02.20.26.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Sep 2025 20:27:00 -0700 (PDT)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (unknown [IPv6:2620:125:9007:640:ffff::1199])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id 2A8BE3404DD;
	Tue,  2 Sep 2025 21:26:59 -0600 (MDT)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id 28979E41964; Tue,  2 Sep 2025 21:26:59 -0600 (MDT)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Caleb Sander Mateos <csander@purestorage.com>
Subject: [PATCH 3/4] io_uring: factor out uring_lock helpers
Date: Tue,  2 Sep 2025 21:26:55 -0600
Message-ID: <20250903032656.2012337-4-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250903032656.2012337-1-csander@purestorage.com>
References: <20250903032656.2012337-1-csander@purestorage.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A subsequent commit will skip acquiring the io_ring_ctx uring_lock in
io_uring_enter() and io_handle_tw_list() for IORING_SETUP_SINGLE_ISSUER.
Prepare for this change by factoring out the uring_lock accesses under
these functions into helper functions:
- io_ring_ctx_lock() for mutex_lock(&ctx->uring_lock)
- io_ring_ctx_unlock() for mutex_unlock(&ctx->uring_lock)
- io_ring_ctx_assert_locked() for lockdep_assert_held(&ctx->uring_lock)

For now, the helpers unconditionally call the mutex functions. But a
subsequent commit will condition them on !IORING_SETUP_SINGLE_ISSUER.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
---
 io_uring/filetable.c |  3 ++-
 io_uring/io_uring.c  | 51 ++++++++++++++++++++++++++------------------
 io_uring/io_uring.h  | 28 ++++++++++++++++++------
 io_uring/kbuf.c      |  6 +++---
 io_uring/notif.c     |  5 +++--
 io_uring/notif.h     |  3 ++-
 io_uring/poll.c      |  2 +-
 io_uring/rsrc.c      |  2 +-
 io_uring/rsrc.h      |  3 ++-
 io_uring/rw.c        |  2 +-
 io_uring/waitid.c    |  2 +-
 11 files changed, 67 insertions(+), 40 deletions(-)

diff --git a/io_uring/filetable.c b/io_uring/filetable.c
index a21660e3145a..aae283e77856 100644
--- a/io_uring/filetable.c
+++ b/io_uring/filetable.c
@@ -55,14 +55,15 @@ void io_free_file_tables(struct io_ring_ctx *ctx, struct io_file_table *table)
 	table->bitmap = NULL;
 }
 
 static int io_install_fixed_file(struct io_ring_ctx *ctx, struct file *file,
 				 u32 slot_index)
-	__must_hold(&req->ctx->uring_lock)
 {
 	struct io_rsrc_node *node;
 
+	io_ring_ctx_assert_locked(ctx);
+
 	if (io_is_uring_fops(file))
 		return -EBADF;
 	if (!ctx->file_table.data.nr)
 		return -ENXIO;
 	if (slot_index >= ctx->file_table.data.nr)
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 9c1190b19adf..7f19b6da5d3d 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -554,11 +554,11 @@ static unsigned io_linked_nr(struct io_kiocb *req)
 
 static __cold noinline void io_queue_deferred(struct io_ring_ctx *ctx)
 {
 	bool drain_seen = false, first = true;
 
-	lockdep_assert_held(&ctx->uring_lock);
+	io_ring_ctx_assert_locked(ctx);
 	__io_req_caches_free(ctx);
 
 	while (!list_empty(&ctx->defer_list)) {
 		struct io_defer_entry *de = list_first_entry(&ctx->defer_list,
 						struct io_defer_entry, list);
@@ -925,11 +925,11 @@ bool io_post_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags
  * Must be called from inline task_work so we now a flush will happen later,
  * and obviously with ctx->uring_lock held (tw always has that).
  */
 void io_add_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags)
 {
-	lockdep_assert_held(&ctx->uring_lock);
+	io_ring_ctx_assert_locked(ctx);
 	lockdep_assert(ctx->lockless_cq);
 
 	if (!io_fill_cqe_aux(ctx, user_data, res, cflags)) {
 		struct io_cqe cqe = io_init_cqe(user_data, res, cflags);
 
@@ -954,11 +954,11 @@ bool io_req_post_cqe(struct io_kiocb *req, s32 res, u32 cflags)
 	 */
 	if (!wq_list_empty(&ctx->submit_state.compl_reqs))
 		__io_submit_flush_completions(ctx);
 
 	lockdep_assert(!io_wq_current_is_worker());
-	lockdep_assert_held(&ctx->uring_lock);
+	io_ring_ctx_assert_locked(ctx);
 
 	if (!ctx->lockless_cq) {
 		spin_lock(&ctx->completion_lock);
 		posted = io_fill_cqe_aux(ctx, req->cqe.user_data, res, cflags);
 		spin_unlock(&ctx->completion_lock);
@@ -978,11 +978,11 @@ bool io_req_post_cqe32(struct io_kiocb *req, struct io_uring_cqe cqe[2])
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	bool posted;
 
 	lockdep_assert(!io_wq_current_is_worker());
-	lockdep_assert_held(&ctx->uring_lock);
+	io_ring_ctx_assert_locked(ctx);
 
 	cqe[0].user_data = req->cqe.user_data;
 	if (!ctx->lockless_cq) {
 		spin_lock(&ctx->completion_lock);
 		posted = io_fill_cqe_aux32(ctx, cqe);
@@ -1032,15 +1032,14 @@ static void io_req_complete_post(struct io_kiocb *req, unsigned issue_flags)
 	 */
 	req_ref_put(req);
 }
 
 void io_req_defer_failed(struct io_kiocb *req, s32 res)
-	__must_hold(&ctx->uring_lock)
 {
 	const struct io_cold_def *def = &io_cold_defs[req->opcode];
 
-	lockdep_assert_held(&req->ctx->uring_lock);
+	io_ring_ctx_assert_locked(req->ctx);
 
 	req_set_fail(req);
 	io_req_set_res(req, res, io_put_kbuf(req, res, NULL));
 	if (def->fail)
 		def->fail(req);
@@ -1052,16 +1051,17 @@ void io_req_defer_failed(struct io_kiocb *req, s32 res)
  * handlers and io_issue_sqe() are done with it, e.g. inline completion path.
  * Because of that, io_alloc_req() should be called only under ->uring_lock
  * and with extra caution to not get a request that is still worked on.
  */
 __cold bool __io_alloc_req_refill(struct io_ring_ctx *ctx)
-	__must_hold(&ctx->uring_lock)
 {
 	gfp_t gfp = GFP_KERNEL | __GFP_NOWARN | __GFP_ZERO;
 	void *reqs[IO_REQ_ALLOC_BATCH];
 	int ret;
 
+	io_ring_ctx_assert_locked(ctx);
+
 	ret = kmem_cache_alloc_bulk(req_cachep, gfp, ARRAY_SIZE(reqs), reqs);
 
 	/*
 	 * Bulk alloc is all-or-nothing. If we fail to get a batch,
 	 * retry single alloc to be on the safe side.
@@ -1126,11 +1126,11 @@ static void ctx_flush_and_put(struct io_ring_ctx *ctx, io_tw_token_t tw)
 		return;
 	if (ctx->flags & IORING_SETUP_TASKRUN_FLAG)
 		atomic_andnot(IORING_SQ_TASKRUN, &ctx->rings->sq_flags);
 
 	io_submit_flush_completions(ctx);
-	mutex_unlock(&ctx->uring_lock);
+	io_ring_ctx_unlock(ctx);
 	percpu_ref_put(&ctx->refs);
 }
 
 /*
  * Run queued task_work, returning the number of entries processed in *count.
@@ -1150,11 +1150,11 @@ struct llist_node *io_handle_tw_list(struct llist_node *node,
 						    io_task_work.node);
 
 		if (req->ctx != ctx) {
 			ctx_flush_and_put(ctx, ts);
 			ctx = req->ctx;
-			mutex_lock(&ctx->uring_lock);
+			io_ring_ctx_lock(ctx);
 			percpu_ref_get(&ctx->refs);
 		}
 		INDIRECT_CALL_2(req->io_task_work.func,
 				io_poll_task_func, io_req_rw_complete,
 				req, ts);
@@ -1502,12 +1502,13 @@ static inline void io_req_put_rsrc_nodes(struct io_kiocb *req)
 		io_put_rsrc_node(req->ctx, req->buf_node);
 }
 
 static void io_free_batch_list(struct io_ring_ctx *ctx,
 			       struct io_wq_work_node *node)
-	__must_hold(&ctx->uring_lock)
 {
+	io_ring_ctx_assert_locked(ctx);
+
 	do {
 		struct io_kiocb *req = container_of(node, struct io_kiocb,
 						    comp_list);
 
 		if (unlikely(req->flags & IO_REQ_CLEAN_SLOW_FLAGS)) {
@@ -1543,15 +1544,16 @@ static void io_free_batch_list(struct io_ring_ctx *ctx,
 		io_req_add_to_cache(req, ctx);
 	} while (node);
 }
 
 void __io_submit_flush_completions(struct io_ring_ctx *ctx)
-	__must_hold(&ctx->uring_lock)
 {
 	struct io_submit_state *state = &ctx->submit_state;
 	struct io_wq_work_node *node;
 
+	io_ring_ctx_assert_locked(ctx);
+
 	__io_cq_lock(ctx);
 	__wq_list_for_each(node, &state->compl_reqs) {
 		struct io_kiocb *req = container_of(node, struct io_kiocb,
 					    comp_list);
 
@@ -1767,16 +1769,17 @@ io_req_flags_t io_file_get_flags(struct file *file)
 		res |= REQ_F_SUPPORT_NOWAIT;
 	return res;
 }
 
 static __cold void io_drain_req(struct io_kiocb *req)
-	__must_hold(&ctx->uring_lock)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	bool drain = req->flags & IOSQE_IO_DRAIN;
 	struct io_defer_entry *de;
 
+	io_ring_ctx_assert_locked(ctx);
+
 	de = kmalloc(sizeof(*de), GFP_KERNEL_ACCOUNT);
 	if (!de) {
 		io_req_defer_failed(req, -ENOMEM);
 		return;
 	}
@@ -2043,12 +2046,13 @@ static int io_req_sqe_copy(struct io_kiocb *req, unsigned int issue_flags)
 	def->sqe_copy(req);
 	return 0;
 }
 
 static void io_queue_async(struct io_kiocb *req, unsigned int issue_flags, int ret)
-	__must_hold(&req->ctx->uring_lock)
 {
+	io_ring_ctx_assert_locked(req->ctx);
+
 	if (ret != -EAGAIN || (req->flags & REQ_F_NOWAIT)) {
 fail:
 		io_req_defer_failed(req, ret);
 		return;
 	}
@@ -2068,16 +2072,17 @@ static void io_queue_async(struct io_kiocb *req, unsigned int issue_flags, int r
 		break;
 	}
 }
 
 static inline void io_queue_sqe(struct io_kiocb *req, unsigned int extra_flags)
-	__must_hold(&req->ctx->uring_lock)
 {
 	unsigned int issue_flags = IO_URING_F_NONBLOCK |
 				   IO_URING_F_COMPLETE_DEFER | extra_flags;
 	int ret;
 
+	io_ring_ctx_assert_locked(req->ctx);
+
 	ret = io_issue_sqe(req, issue_flags);
 
 	/*
 	 * We async punt it if the file wasn't marked NOWAIT, or if the file
 	 * doesn't support non-blocking read/write attempts
@@ -2085,12 +2090,13 @@ static inline void io_queue_sqe(struct io_kiocb *req, unsigned int extra_flags)
 	if (unlikely(ret))
 		io_queue_async(req, issue_flags, ret);
 }
 
 static void io_queue_sqe_fallback(struct io_kiocb *req)
-	__must_hold(&req->ctx->uring_lock)
 {
+	io_ring_ctx_assert_locked(req->ctx);
+
 	if (unlikely(req->flags & REQ_F_FAIL)) {
 		/*
 		 * We don't submit, fail them all, for that replace hardlinks
 		 * with normal links. Extra REQ_F_LINK is tolerated.
 		 */
@@ -2155,17 +2161,18 @@ static __cold int io_init_fail_req(struct io_kiocb *req, int err)
 	return err;
 }
 
 static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 		       const struct io_uring_sqe *sqe)
-	__must_hold(&ctx->uring_lock)
 {
 	const struct io_issue_def *def;
 	unsigned int sqe_flags;
 	int personality;
 	u8 opcode;
 
+	io_ring_ctx_assert_locked(ctx);
+
 	req->ctx = ctx;
 	req->opcode = opcode = READ_ONCE(sqe->opcode);
 	/* same numerical values with corresponding REQ_F_*, safe to copy */
 	sqe_flags = READ_ONCE(sqe->flags);
 	req->flags = (__force io_req_flags_t) sqe_flags;
@@ -2290,15 +2297,16 @@ static __cold int io_submit_fail_init(const struct io_uring_sqe *sqe,
 	return 0;
 }
 
 static inline int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
 			 const struct io_uring_sqe *sqe)
-	__must_hold(&ctx->uring_lock)
 {
 	struct io_submit_link *link = &ctx->submit_state.link;
 	int ret;
 
+	io_ring_ctx_assert_locked(ctx);
+
 	ret = io_init_req(ctx, req, sqe);
 	if (unlikely(ret))
 		return io_submit_fail_init(sqe, req, ret);
 
 	trace_io_uring_submit_req(req);
@@ -2419,16 +2427,17 @@ static bool io_get_sqe(struct io_ring_ctx *ctx, const struct io_uring_sqe **sqe)
 	*sqe = &ctx->sq_sqes[head];
 	return true;
 }
 
 int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
-	__must_hold(&ctx->uring_lock)
 {
 	unsigned int entries = io_sqring_entries(ctx);
 	unsigned int left;
 	int ret;
 
+	io_ring_ctx_assert_locked(ctx);
+
 	if (unlikely(!entries))
 		return 0;
 	/* make sure SQ entry isn't read before tail */
 	ret = left = min(nr, entries);
 	io_get_task_refs(left);
@@ -3518,14 +3527,14 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 	} else if (to_submit) {
 		ret = io_uring_add_tctx_node(ctx);
 		if (unlikely(ret))
 			goto out;
 
-		mutex_lock(&ctx->uring_lock);
+		io_ring_ctx_lock(ctx);
 		ret = io_submit_sqes(ctx, to_submit);
 		if (ret != to_submit) {
-			mutex_unlock(&ctx->uring_lock);
+			io_ring_ctx_unlock(ctx);
 			goto out;
 		}
 		if (flags & IORING_ENTER_GETEVENTS) {
 			if (ctx->syscall_iopoll)
 				goto iopoll_locked;
@@ -3534,11 +3543,11 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 			 * it should handle ownership problems if any.
 			 */
 			if (ctx->flags & IORING_SETUP_DEFER_TASKRUN)
 				(void)io_run_local_work_locked(ctx, min_complete);
 		}
-		mutex_unlock(&ctx->uring_lock);
+		io_ring_ctx_unlock(ctx);
 	}
 
 	if (flags & IORING_ENTER_GETEVENTS) {
 		int ret2;
 
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index d62b7d9fafed..a0580a1bf6b5 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -119,20 +119,35 @@ bool __io_alloc_req_refill(struct io_ring_ctx *ctx);
 bool io_match_task_safe(struct io_kiocb *head, struct io_uring_task *tctx,
 			bool cancel_all);
 
 void io_activate_pollwq(struct io_ring_ctx *ctx);
 
+static inline void io_ring_ctx_lock(struct io_ring_ctx *ctx)
+{
+	mutex_lock(&ctx->uring_lock);
+}
+
+static inline void io_ring_ctx_unlock(struct io_ring_ctx *ctx)
+{
+	mutex_unlock(&ctx->uring_lock);
+}
+
+static inline void io_ring_ctx_assert_locked(const struct io_ring_ctx *ctx)
+{
+	lockdep_assert_held(&ctx->uring_lock);
+}
+
 static inline void io_lockdep_assert_cq_locked(struct io_ring_ctx *ctx)
 {
 #if defined(CONFIG_PROVE_LOCKING)
 	lockdep_assert(in_task());
 
 	if (ctx->flags & IORING_SETUP_DEFER_TASKRUN)
-		lockdep_assert_held(&ctx->uring_lock);
+		io_ring_ctx_assert_locked(ctx);
 
 	if (ctx->flags & IORING_SETUP_IOPOLL) {
-		lockdep_assert_held(&ctx->uring_lock);
+		io_ring_ctx_assert_locked(ctx);
 	} else if (!ctx->task_complete) {
 		lockdep_assert_held(&ctx->completion_lock);
 	} else if (ctx->submitter_task) {
 		/*
 		 * ->submitter_task may be NULL and we can still post a CQE,
@@ -300,11 +315,11 @@ static inline void io_put_file(struct io_kiocb *req)
 }
 
 static inline void io_ring_submit_unlock(struct io_ring_ctx *ctx,
 					 unsigned issue_flags)
 {
-	lockdep_assert_held(&ctx->uring_lock);
+	io_ring_ctx_assert_locked(ctx);
 	if (unlikely(issue_flags & IO_URING_F_UNLOCKED))
 		mutex_unlock(&ctx->uring_lock);
 }
 
 static inline void io_ring_submit_lock(struct io_ring_ctx *ctx,
@@ -316,11 +331,11 @@ static inline void io_ring_submit_lock(struct io_ring_ctx *ctx,
 	 * The only exception is when we've detached the request and issue it
 	 * from an async worker thread, grab the lock for that case.
 	 */
 	if (unlikely(issue_flags & IO_URING_F_UNLOCKED))
 		mutex_lock(&ctx->uring_lock);
-	lockdep_assert_held(&ctx->uring_lock);
+	io_ring_ctx_assert_locked(ctx);
 }
 
 static inline void io_commit_cqring(struct io_ring_ctx *ctx)
 {
 	/* order cqe stores with ring update */
@@ -428,24 +443,23 @@ static inline bool io_task_work_pending(struct io_ring_ctx *ctx)
 	return task_work_pending(current) || io_local_work_pending(ctx);
 }
 
 static inline void io_tw_lock(struct io_ring_ctx *ctx, io_tw_token_t tw)
 {
-	lockdep_assert_held(&ctx->uring_lock);
+	io_ring_ctx_assert_locked(ctx);
 }
 
 /*
  * Don't complete immediately but use deferred completion infrastructure.
  * Protected by ->uring_lock and can only be used either with
  * IO_URING_F_COMPLETE_DEFER or inside a tw handler holding the mutex.
  */
 static inline void io_req_complete_defer(struct io_kiocb *req)
-	__must_hold(&req->ctx->uring_lock)
 {
 	struct io_submit_state *state = &req->ctx->submit_state;
 
-	lockdep_assert_held(&req->ctx->uring_lock);
+	io_ring_ctx_assert_locked(req->ctx);
 
 	wq_list_add_tail(&req->comp_list, &state->compl_reqs);
 }
 
 static inline void io_commit_cqring_flush(struct io_ring_ctx *ctx)
diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 3e9aab21af9d..ea6f3588d875 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -68,11 +68,11 @@ bool io_kbuf_commit(struct io_kiocb *req,
 }
 
 static inline struct io_buffer_list *io_buffer_get_list(struct io_ring_ctx *ctx,
 							unsigned int bgid)
 {
-	lockdep_assert_held(&ctx->uring_lock);
+	io_ring_ctx_assert_locked(ctx);
 
 	return xa_load(&ctx->io_bl_xa, bgid);
 }
 
 static int io_buffer_add_list(struct io_ring_ctx *ctx,
@@ -337,11 +337,11 @@ int io_buffers_peek(struct io_kiocb *req, struct buf_sel_arg *arg,
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_buffer_list *bl;
 	int ret;
 
-	lockdep_assert_held(&ctx->uring_lock);
+	io_ring_ctx_assert_locked(ctx);
 
 	bl = io_buffer_get_list(ctx, arg->buf_group);
 	if (unlikely(!bl))
 		return -ENOENT;
 
@@ -393,11 +393,11 @@ static int io_remove_buffers_legacy(struct io_ring_ctx *ctx,
 {
 	unsigned long i = 0;
 	struct io_buffer *nxt;
 
 	/* protects io_buffers_cache */
-	lockdep_assert_held(&ctx->uring_lock);
+	io_ring_ctx_assert_locked(ctx);
 	WARN_ON_ONCE(bl->flags & IOBL_BUF_RING);
 
 	for (i = 0; i < nbufs && !list_empty(&bl->buf_list); i++) {
 		nxt = list_first_entry(&bl->buf_list, struct io_buffer, list);
 		list_del(&nxt->list);
diff --git a/io_uring/notif.c b/io_uring/notif.c
index 8c92e9cde2c6..9dd248fcb213 100644
--- a/io_uring/notif.c
+++ b/io_uring/notif.c
@@ -14,11 +14,11 @@ static const struct ubuf_info_ops io_ubuf_ops;
 static void io_notif_tw_complete(struct io_kiocb *notif, io_tw_token_t tw)
 {
 	struct io_notif_data *nd = io_notif_to_data(notif);
 	struct io_ring_ctx *ctx = notif->ctx;
 
-	lockdep_assert_held(&ctx->uring_lock);
+	io_ring_ctx_assert_locked(ctx);
 
 	do {
 		notif = cmd_to_io_kiocb(nd);
 
 		if (WARN_ON_ONCE(ctx != notif->ctx))
@@ -108,15 +108,16 @@ static const struct ubuf_info_ops io_ubuf_ops = {
 	.complete = io_tx_ubuf_complete,
 	.link_skb = io_link_skb,
 };
 
 struct io_kiocb *io_alloc_notif(struct io_ring_ctx *ctx)
-	__must_hold(&ctx->uring_lock)
 {
 	struct io_kiocb *notif;
 	struct io_notif_data *nd;
 
+	io_ring_ctx_assert_locked(ctx);
+
 	if (unlikely(!io_alloc_req(ctx, &notif)))
 		return NULL;
 	notif->ctx = ctx;
 	notif->opcode = IORING_OP_NOP;
 	notif->flags = 0;
diff --git a/io_uring/notif.h b/io_uring/notif.h
index f3589cfef4a9..c33c9a1179c9 100644
--- a/io_uring/notif.h
+++ b/io_uring/notif.h
@@ -31,14 +31,15 @@ static inline struct io_notif_data *io_notif_to_data(struct io_kiocb *notif)
 {
 	return io_kiocb_to_cmd(notif, struct io_notif_data);
 }
 
 static inline void io_notif_flush(struct io_kiocb *notif)
-	__must_hold(&notif->ctx->uring_lock)
 {
 	struct io_notif_data *nd = io_notif_to_data(notif);
 
+	io_ring_ctx_assert_locked(notif->ctx);
+
 	io_tx_ubuf_complete(NULL, &nd->uarg, true);
 }
 
 static inline int io_notif_account_mem(struct io_kiocb *notif, unsigned len)
 {
diff --git a/io_uring/poll.c b/io_uring/poll.c
index ea75c5cd81a0..ba71403c8fd8 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -121,11 +121,11 @@ static struct io_poll *io_poll_get_single(struct io_kiocb *req)
 static void io_poll_req_insert(struct io_kiocb *req)
 {
 	struct io_hash_table *table = &req->ctx->cancel_table;
 	u32 index = hash_long(req->cqe.user_data, table->hash_bits);
 
-	lockdep_assert_held(&req->ctx->uring_lock);
+	io_ring_ctx_assert_locked(req->ctx);
 
 	hlist_add_head(&req->hash_node, &table->hbs[index].list);
 }
 
 static void io_init_poll_iocb(struct io_poll *poll, __poll_t events)
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 1e5b7833076a..1c1753de7340 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -347,11 +347,11 @@ static int __io_register_rsrc_update(struct io_ring_ctx *ctx, unsigned type,
 				     struct io_uring_rsrc_update2 *up,
 				     unsigned nr_args)
 {
 	__u32 tmp;
 
-	lockdep_assert_held(&ctx->uring_lock);
+	io_ring_ctx_assert_locked(ctx);
 
 	if (check_add_overflow(up->offset, nr_args, &tmp))
 		return -EOVERFLOW;
 
 	switch (type) {
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index a3ca6ba66596..d537a3b895d6 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -2,10 +2,11 @@
 #ifndef IOU_RSRC_H
 #define IOU_RSRC_H
 
 #include <linux/io_uring_types.h>
 #include <linux/lockdep.h>
+#include "io_uring.h"
 
 #define IO_VEC_CACHE_SOFT_CAP		256
 
 enum {
 	IORING_RSRC_FILE		= 0,
@@ -97,11 +98,11 @@ static inline struct io_rsrc_node *io_rsrc_node_lookup(struct io_rsrc_data *data
 	return NULL;
 }
 
 static inline void io_put_rsrc_node(struct io_ring_ctx *ctx, struct io_rsrc_node *node)
 {
-	lockdep_assert_held(&ctx->uring_lock);
+	io_ring_ctx_assert_locked(ctx);
 	if (!--node->refs)
 		io_free_rsrc_node(ctx, node);
 }
 
 static inline bool io_reset_rsrc_node(struct io_ring_ctx *ctx,
diff --git a/io_uring/rw.c b/io_uring/rw.c
index ab6b4afccec3..f00e02a02dc7 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -461,11 +461,11 @@ int io_read_mshot_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	return 0;
 }
 
 void io_readv_writev_cleanup(struct io_kiocb *req)
 {
-	lockdep_assert_held(&req->ctx->uring_lock);
+	io_ring_ctx_assert_locked(req->ctx);
 	io_rw_recycle(req, 0);
 }
 
 static inline loff_t *io_kiocb_update_pos(struct io_kiocb *req)
 {
diff --git a/io_uring/waitid.c b/io_uring/waitid.c
index 26c118f3918d..f7a5054d4d81 100644
--- a/io_uring/waitid.c
+++ b/io_uring/waitid.c
@@ -114,11 +114,11 @@ static void io_waitid_complete(struct io_kiocb *req, int ret)
 	struct io_waitid *iw = io_kiocb_to_cmd(req, struct io_waitid);
 
 	/* anyone completing better be holding a reference */
 	WARN_ON_ONCE(!(atomic_read(&iw->refs) & IO_WAITID_REF_MASK));
 
-	lockdep_assert_held(&req->ctx->uring_lock);
+	io_ring_ctx_assert_locked(req->ctx);
 
 	hlist_del_init(&req->hash_node);
 
 	ret = io_waitid_finish(req, ret);
 	if (ret < 0)
-- 
2.45.2


