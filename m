Return-Path: <io-uring+bounces-2628-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D386C943C25
	for <lists+io-uring@lfdr.de>; Thu,  1 Aug 2024 02:34:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0E1561C21D6C
	for <lists+io-uring@lfdr.de>; Thu,  1 Aug 2024 00:34:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AFDA1A4F31;
	Thu,  1 Aug 2024 00:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dPPE5x0K"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66E111A4F2A;
	Thu,  1 Aug 2024 00:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722471389; cv=none; b=s0Zb9tOe49hMVvhaU4r+8R079dnQ9iheKrFnvUGlZD2dbaxLgR1nGw1OUTIIL5YT9DTF1y/tvOCWbhjC3rAUfl8NU5aVQWITp6908VhNhFUF7ZQZuYiZJyLtklUnDUpTU+IooSH2djilWfbvBAd+gdwohq9FS1sXNh0H5OyyD5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722471389; c=relaxed/simple;
	bh=QLcTNm+RBtlSWiQhNrt10XbpFP9m/MvdWMz1GAJ+/ts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OFEJyNdeocEYVwhNBE8ieUzUEjTUPNdrIXUy7LqUJRily6/KIuzjQ7Fbyb50UmOJu2uKXmjQgbLz9PphZ8CxjIFAgA0V5A2jBxnM3X+s+X3pMH7YoCGoEBVFBCVJFuqrtVZ+eL2PZK0ePThWW9Pae2Rt/dPa+K0R/Ok2Oii01X4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dPPE5x0K; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68F31C116B1;
	Thu,  1 Aug 2024 00:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722471389;
	bh=QLcTNm+RBtlSWiQhNrt10XbpFP9m/MvdWMz1GAJ+/ts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dPPE5x0KclP6YB+czP4L/kJ/4gjUCkiJ17fPym51sR8en3EIhlHbpKIdtvr2/KOUQ
	 cdNnnEdBdky2okMvFXYvqmOTrFLO+2OV3ZFWcodem3EuKNbOitYgu76MqszbvLUV/1
	 n+xoPto+FLxivfjjLbBwWgVEHCBIO+MRkUvqoVxYtEt4qT8kOUOL8iDSFOBOeCFZlQ
	 d6b8cetyfKA4vGhj94xjfXFZqiaaTHwJF/+2gEDa758DXuiMsCwS/fiEAXANteg326
	 p+pzz1bTxzoKURndUR7FEHR/5WzoReoiesp7OIm+EF7Uf33zcfJTmASSWK44nEUQ24
	 gPdikcT2oaw+w==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Jens Axboe <axboe@r7625.kernel.dk>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org
Subject: [PATCH AUTOSEL 6.10 082/121] io_uring/io-wq: make io_wq_work flags atomic
Date: Wed, 31 Jul 2024 20:00:20 -0400
Message-ID: <20240801000834.3930818-82-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240801000834.3930818-1-sashal@kernel.org>
References: <20240801000834.3930818-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.10.2
Content-Transfer-Encoding: 8bit

From: Jens Axboe <axboe@r7625.kernel.dk>

[ Upstream commit 3474d1b93f897ab33ce160e759afd47d5f412de4 ]

The work flags can be set/accessed from different tasks, both the
originator of the request, and the io-wq workers. While modifications
aren't concurrent, it still makes KMSAN unhappy. There's no real
downside to just making the flag reading/manipulation use proper
atomics here.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/io_uring_types.h |  2 +-
 io_uring/io-wq.c               | 19 ++++++++++---------
 io_uring/io-wq.h               |  2 +-
 io_uring/io_uring.c            | 12 ++++++------
 4 files changed, 18 insertions(+), 17 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 7abdc09271245..abf5c6622af6d 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -50,7 +50,7 @@ struct io_wq_work_list {
 
 struct io_wq_work {
 	struct io_wq_work_node list;
-	unsigned flags;
+	atomic_t flags;
 	/* place it here instead of io_kiocb as it fills padding and saves 4B */
 	int cancel_seq;
 };
diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index 7d3316fe9bfc4..913c92249522e 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -159,7 +159,7 @@ static inline struct io_wq_acct *io_get_acct(struct io_wq *wq, bool bound)
 static inline struct io_wq_acct *io_work_get_acct(struct io_wq *wq,
 						  struct io_wq_work *work)
 {
-	return io_get_acct(wq, !(work->flags & IO_WQ_WORK_UNBOUND));
+	return io_get_acct(wq, !(atomic_read(&work->flags) & IO_WQ_WORK_UNBOUND));
 }
 
 static inline struct io_wq_acct *io_wq_get_acct(struct io_worker *worker)
@@ -451,7 +451,7 @@ static void __io_worker_idle(struct io_wq *wq, struct io_worker *worker)
 
 static inline unsigned int io_get_work_hash(struct io_wq_work *work)
 {
-	return work->flags >> IO_WQ_HASH_SHIFT;
+	return atomic_read(&work->flags) >> IO_WQ_HASH_SHIFT;
 }
 
 static bool io_wait_on_hash(struct io_wq *wq, unsigned int hash)
@@ -592,8 +592,9 @@ static void io_worker_handle_work(struct io_wq_acct *acct,
 
 			next_hashed = wq_next_work(work);
 
-			if (unlikely(do_kill) && (work->flags & IO_WQ_WORK_UNBOUND))
-				work->flags |= IO_WQ_WORK_CANCEL;
+			if (do_kill &&
+			    (atomic_read(&work->flags) & IO_WQ_WORK_UNBOUND))
+				atomic_or(IO_WQ_WORK_CANCEL, &work->flags);
 			wq->do_work(work);
 			io_assign_current_work(worker, NULL);
 
@@ -891,7 +892,7 @@ static bool io_wq_worker_wake(struct io_worker *worker, void *data)
 static void io_run_cancel(struct io_wq_work *work, struct io_wq *wq)
 {
 	do {
-		work->flags |= IO_WQ_WORK_CANCEL;
+		atomic_or(IO_WQ_WORK_CANCEL, &work->flags);
 		wq->do_work(work);
 		work = wq->free_work(work);
 	} while (work);
@@ -926,7 +927,7 @@ static bool io_wq_work_match_item(struct io_wq_work *work, void *data)
 void io_wq_enqueue(struct io_wq *wq, struct io_wq_work *work)
 {
 	struct io_wq_acct *acct = io_work_get_acct(wq, work);
-	unsigned long work_flags = work->flags;
+	unsigned int work_flags = atomic_read(&work->flags);
 	struct io_cb_cancel_data match = {
 		.fn		= io_wq_work_match_item,
 		.data		= work,
@@ -939,7 +940,7 @@ void io_wq_enqueue(struct io_wq *wq, struct io_wq_work *work)
 	 * been marked as one that should not get executed, cancel it here.
 	 */
 	if (test_bit(IO_WQ_BIT_EXIT, &wq->state) ||
-	    (work->flags & IO_WQ_WORK_CANCEL)) {
+	    (work_flags & IO_WQ_WORK_CANCEL)) {
 		io_run_cancel(work, wq);
 		return;
 	}
@@ -982,7 +983,7 @@ void io_wq_hash_work(struct io_wq_work *work, void *val)
 	unsigned int bit;
 
 	bit = hash_ptr(val, IO_WQ_HASH_ORDER);
-	work->flags |= (IO_WQ_WORK_HASHED | (bit << IO_WQ_HASH_SHIFT));
+	atomic_or(IO_WQ_WORK_HASHED | (bit << IO_WQ_HASH_SHIFT), &work->flags);
 }
 
 static bool __io_wq_worker_cancel(struct io_worker *worker,
@@ -990,7 +991,7 @@ static bool __io_wq_worker_cancel(struct io_worker *worker,
 				  struct io_wq_work *work)
 {
 	if (work && match->fn(work, match->data)) {
-		work->flags |= IO_WQ_WORK_CANCEL;
+		atomic_or(IO_WQ_WORK_CANCEL, &work->flags);
 		__set_notify_signal(worker->task);
 		return true;
 	}
diff --git a/io_uring/io-wq.h b/io_uring/io-wq.h
index 2b2a6406dd8ee..b3b004a7b6252 100644
--- a/io_uring/io-wq.h
+++ b/io_uring/io-wq.h
@@ -56,7 +56,7 @@ bool io_wq_worker_stopped(void);
 
 static inline bool io_wq_is_hashed(struct io_wq_work *work)
 {
-	return work->flags & IO_WQ_WORK_HASHED;
+	return atomic_read(&work->flags) & IO_WQ_WORK_HASHED;
 }
 
 typedef bool (work_cancel_fn)(struct io_wq_work *, void *);
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index c326e2127dd4d..846c1cecdb0aa 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -461,9 +461,9 @@ static void io_prep_async_work(struct io_kiocb *req)
 	}
 
 	req->work.list.next = NULL;
-	req->work.flags = 0;
+	atomic_set(&req->work.flags, 0);
 	if (req->flags & REQ_F_FORCE_ASYNC)
-		req->work.flags |= IO_WQ_WORK_CONCURRENT;
+		atomic_or(IO_WQ_WORK_CONCURRENT, &req->work.flags);
 
 	if (req->file && !(req->flags & REQ_F_FIXED_FILE))
 		req->flags |= io_file_get_flags(req->file);
@@ -479,7 +479,7 @@ static void io_prep_async_work(struct io_kiocb *req)
 			io_wq_hash_work(&req->work, file_inode(req->file));
 	} else if (!req->file || !S_ISBLK(file_inode(req->file)->i_mode)) {
 		if (def->unbound_nonreg_file)
-			req->work.flags |= IO_WQ_WORK_UNBOUND;
+			atomic_or(IO_WQ_WORK_UNBOUND, &req->work.flags);
 	}
 }
 
@@ -519,7 +519,7 @@ static void io_queue_iowq(struct io_kiocb *req)
 	 * worker for it).
 	 */
 	if (WARN_ON_ONCE(!same_thread_group(req->task, current)))
-		req->work.flags |= IO_WQ_WORK_CANCEL;
+		atomic_or(IO_WQ_WORK_CANCEL, &req->work.flags);
 
 	trace_io_uring_queue_async_work(req, io_wq_is_hashed(&req->work));
 	io_wq_enqueue(tctx->io_wq, &req->work);
@@ -1813,14 +1813,14 @@ void io_wq_submit_work(struct io_wq_work *work)
 	io_arm_ltimeout(req);
 
 	/* either cancelled or io-wq is dying, so don't touch tctx->iowq */
-	if (work->flags & IO_WQ_WORK_CANCEL) {
+	if (atomic_read(&work->flags) & IO_WQ_WORK_CANCEL) {
 fail:
 		io_req_task_queue_fail(req, err);
 		return;
 	}
 	if (!io_assign_file(req, def, issue_flags)) {
 		err = -EBADF;
-		work->flags |= IO_WQ_WORK_CANCEL;
+		atomic_or(IO_WQ_WORK_CANCEL, &work->flags);
 		goto fail;
 	}
 
-- 
2.43.0


