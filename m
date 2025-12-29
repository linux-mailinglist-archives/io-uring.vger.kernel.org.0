Return-Path: <io-uring+bounces-11318-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 37E30CE81E6
	for <lists+io-uring@lfdr.de>; Mon, 29 Dec 2025 21:20:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B477A301274E
	for <lists+io-uring@lfdr.de>; Mon, 29 Dec 2025 20:20:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7AAA265CC2;
	Mon, 29 Dec 2025 20:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=negrel.dev header.i=@negrel.dev header.b="n5lk7dnP"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-07.mail-europe.com (mail-0701.mail-europe.com [51.83.17.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0D462620FC
	for <io-uring@vger.kernel.org>; Mon, 29 Dec 2025 20:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=51.83.17.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767039612; cv=none; b=YI1fEhPNI6Bz067IJdBWpPv+fBi08pLmes/7+GRavdMm4mSQbayQnftFQGNO/cAH4/1SwbITd9kH8DpIUENGeXDgyKg5GO1s1BlXxjrqk57/0a0RWwG2buqBmiDkb9nsCLP6qFr+nqKjWakCs0vpKgnTKE+DVDTjKshBE/ZRBmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767039612; c=relaxed/simple;
	bh=IWu3MAeD3/WMz4e7q5saRhsia5qvPI7edtACYhihtac=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=t4tRkNte1qaeRMva6IO0vuGscWff+PMk/BsUa+abOI43M4DYDbhPbmlpmzdHeYP5UOKE2QC1J10lvtCAOlLzD0IBVQmrPckfItKoFz6Lp+9koqI9s3xh6SWnTq1SqzA9azCuiIoxq/b/CnROJuDOoGih1CwiVQlNFnZcxCyCrFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=negrel.dev; spf=fail smtp.mailfrom=negrel.dev; dkim=pass (2048-bit key) header.d=negrel.dev header.i=@negrel.dev header.b=n5lk7dnP; arc=none smtp.client-ip=51.83.17.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=negrel.dev
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=negrel.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=negrel.dev;
	s=protonmail3; t=1767039592; x=1767298792;
	bh=Cgj4ETYISZLgwm4jh92CERxslUoW25giOYydEquO9Ks=;
	h=From:To:Cc:Subject:Date:Message-ID:From:To:Cc:Date:Subject:
	 Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=n5lk7dnPfDuJN0LgYGG+BXbTwlLjcQicegNXS80UjTvzs/tf+zZd1GOBk3/Y8BYOJ
	 WG8uEnj2qinmQJJmUfyJ9gJVEljJCA0F+aqzkasd3V7MNX5M1JQ2hnmZMOLsyvhs6c
	 6vuvUK0JodKzYDCYogNFoyPL3Yn8+xnLzPLvMebk1BNf1OLUXZtiZK/ceorXm1nwge
	 H2CquG2lRHwvla6EKYKO7pWDZaWyhZrk0NNESsV8pk12Z1/3Q56iF4aT+JLxxBgwht
	 RrCQ/K/bE++OqmG01oJ5n7GpEtf8yqsT6XjVU+QOX9rOnf10bVeXQNkQy9zb7WRIm9
	 NqM32YAUJTl6Q==
X-Pm-Submission-Id: 4dg6yY2ySlz2Scq3
From: Alexandre Negrel <alexandre@negrel.dev>
To: axboe@kernel.dk,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Alexandre Negrel <alexandre@negrel.dev>
Subject: [PATCH] io_uring: make overflowing cqe subject to OOM
Date: Mon, 29 Dec 2025 21:19:00 +0100
Message-ID: <20251229201933.515797-1-alexandre@negrel.dev>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Overflowing CQE are now allocated with GFP_KERNEL instead of GFP_ATOMIC.
OOM killer is triggered on overflow and is not possible to exceed cgroup
memory limits anymore.

Closes: https://bugzilla.kernel.org/show_bug.cgi?id=220794
Signed-off-by: Alexandre Negrel <alexandre@negrel.dev>
---
 io_uring/io_uring.c | 34 +++++++++-------------------------
 1 file changed, 9 insertions(+), 25 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 6cb24cdf8e68..5ff1a13fed1c 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -545,31 +545,12 @@ void __io_commit_cqring_flush(struct io_ring_ctx *ctx)
 		io_eventfd_signal(ctx, true);
 }
 
-static inline void __io_cq_lock(struct io_ring_ctx *ctx)
-{
-	if (!ctx->lockless_cq)
-		spin_lock(&ctx->completion_lock);
-}
-
 static inline void io_cq_lock(struct io_ring_ctx *ctx)
 	__acquires(ctx->completion_lock)
 {
 	spin_lock(&ctx->completion_lock);
 }
 
-static inline void __io_cq_unlock_post(struct io_ring_ctx *ctx)
-{
-	io_commit_cqring(ctx);
-	if (!ctx->task_complete) {
-		if (!ctx->lockless_cq)
-			spin_unlock(&ctx->completion_lock);
-		/* IOPOLL rings only need to wake up if it's also SQPOLL */
-		if (!ctx->syscall_iopoll)
-			io_cqring_wake(ctx);
-	}
-	io_commit_cqring_flush(ctx);
-}
-
 static void io_cq_unlock_post(struct io_ring_ctx *ctx)
 	__releases(ctx->completion_lock)
 {
@@ -1513,7 +1494,6 @@ void __io_submit_flush_completions(struct io_ring_ctx *ctx)
 	struct io_submit_state *state = &ctx->submit_state;
 	struct io_wq_work_node *node;
 
-	__io_cq_lock(ctx);
 	__wq_list_for_each(node, &state->compl_reqs) {
 		struct io_kiocb *req = container_of(node, struct io_kiocb,
 					    comp_list);
@@ -1525,13 +1505,17 @@ void __io_submit_flush_completions(struct io_ring_ctx *ctx)
 		 */
 		if (!(req->flags & (REQ_F_CQE_SKIP | REQ_F_REISSUE)) &&
 		    unlikely(!io_fill_cqe_req(ctx, req))) {
-			if (ctx->lockless_cq)
-				io_cqe_overflow(ctx, &req->cqe, &req->big_cqe);
-			else
-				io_cqe_overflow_locked(ctx, &req->cqe, &req->big_cqe);
+			io_cqe_overflow(ctx, &req->cqe, &req->big_cqe);
 		}
 	}
-	__io_cq_unlock_post(ctx);
+
+	io_commit_cqring(ctx);
+	if (!ctx->task_complete) {
+		/* IOPOLL rings only need to wake up if it's also SQPOLL */
+		if (!ctx->syscall_iopoll)
+			io_cqring_wake(ctx);
+	}
+	io_commit_cqring_flush(ctx);
 
 	if (!wq_list_empty(&state->compl_reqs)) {
 		io_free_batch_list(ctx, state->compl_reqs.first);
-- 
2.51.0


