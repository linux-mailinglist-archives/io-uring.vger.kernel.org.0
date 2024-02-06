Return-Path: <io-uring+bounces-547-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BB46E84BAE6
	for <lists+io-uring@lfdr.de>; Tue,  6 Feb 2024 17:27:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 73DD02890DD
	for <lists+io-uring@lfdr.de>; Tue,  6 Feb 2024 16:27:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11D4A134742;
	Tue,  6 Feb 2024 16:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="CWMxgj1Z"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 601E6134CD3
	for <io-uring@vger.kernel.org>; Tue,  6 Feb 2024 16:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707236863; cv=none; b=eQ6lavkZuZa5HszA0a7xLMRoICuzfVLEp4GIfwpHNhwQNmsOiDqHSIKFszEYxHkfMTqWsQX0gOlYiH9c1RUiN6X6tOpMFP1zHDWmAnARDtafi6rjOhvRttTa10fU6vWeDZO5MUq+9WoizNBenj4a9A5khZfL2V6l0pivKB4LO08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707236863; c=relaxed/simple;
	bh=R/LRAEJbwwD4YpGLmurq5+6JxPXE9VAoQNs2IVMBpN8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SmGgGdqNJsTftqc/wvOg90iYRWo8yqIsqFWQ5tMLiwE/Fw290vx+3No+/frxUGIIZ5M2ANhKeS+y8gK4AFE5YgQqRF1qD+Uakxlm9/UC4UKCU12c3/+fSRuCr+12xqA9HpWLyoecdZeOcdUiUbSmRbhYaN1E0+287TSoP+eMdz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=CWMxgj1Z; arc=none smtp.client-ip=209.85.166.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-7bff8f21b74so59143039f.0
        for <io-uring@vger.kernel.org>; Tue, 06 Feb 2024 08:27:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1707236860; x=1707841660; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fTAxBwS/Fp2VZ+CgFOoX1nsp4BW/P+isZyL7ajilrwQ=;
        b=CWMxgj1Z9CMWwFle2h60qw/vJwY/uv0JGhOzaM6InT0cSJyz5IdrpJjbWlGJfGeO/6
         zdyQ3acLBEtZ2nphqlBBY1B16FgpnAS1RpwIXcBB+FY5tbU00IM6M6uRNdfNn6pMrtHl
         k/nne3qWI+9ytyxN2Q/nqoaf+tU1MEOWZ/Va4ROVgfzbH943YkG/bsryhpu5lXCQEaRo
         CMkCmwP+/mD5apvCu2skQYxG5E7dH7/tDte5rikLFez9APsr/oOa4GM/aTREvh/Q0nfr
         2pA6obrlwD/izXgQ3BdwQVrH8wVgBsTh1AkOL9611maPdY6R0h7yrjXgXazzxpZACfqB
         gC5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707236860; x=1707841660;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fTAxBwS/Fp2VZ+CgFOoX1nsp4BW/P+isZyL7ajilrwQ=;
        b=X90wrOtoV61cLrviuu59TosucOaeCU72cUhifblx2+IKelg0GxlSfvEGnqqwyHFdcq
         LolG8LfFAqGFfd+6Uj1actEl9hWEobNQOuX+0PmJ3CtyVNtaRaIICei0cxeXlzbnGNKY
         gaG/t8LELWBGGAx2TPAvLPs95p2y/CYqoKmXxm9dasvTK3zcLhapWz5H4T2zG6ik1P9J
         Z22qDW/K8X+5IWTXRtCuC62a20YYX5F/13JnSOCpY7scHuQ597DnWoZuEAxcdFRn6qU7
         m8LIROYl0fbUh7CZ8C84nuqw7sGZNi5Jiv28zDBo0Bb6U4MBTmFM+TQmLrqGVYXHzPJX
         kefg==
X-Gm-Message-State: AOJu0Yw+LsYx66RSgyjHb0huCiQ0ginrFlXOWy68PsZjcbyL5NFfPc4b
	oB8SrPwP51QOfMZjRRhVKzGIZb0hPPFNBpEXe50JJPKFLYWv/qcz/vR/CHfRiaNq8qTJJktO0+A
	iMM8=
X-Google-Smtp-Source: AGHT+IHXhOKebVgDefnglOOOa+whcp8jJIxR5AgWiIW3eIVJenXtD2Q36WeHwi1ylFqJXxZ1HSvrlg==
X-Received: by 2002:a05:6602:123a:b0:7c0:2ea0:b046 with SMTP id z26-20020a056602123a00b007c02ea0b046mr3677517iot.1.1707236860179;
        Tue, 06 Feb 2024 08:27:40 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id a1-20020a6b6601000000b007bffd556183sm513309ioc.14.2024.02.06.08.27.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Feb 2024 08:27:38 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 06/10] io_uring: remove unconditional looping in local task_work handling
Date: Tue,  6 Feb 2024 09:24:40 -0700
Message-ID: <20240206162726.644202-7-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240206162726.644202-1-axboe@kernel.dk>
References: <20240206162726.644202-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If we have a ton of notifications coming in, we can be looping in here
for a long time. This can be problematic for various reasons, mostly
because we can starve userspace. If the application is waiting on N
events, then only re-run if we need more events.

Fixes: c0e0d6ba25f1 ("io_uring: add IORING_SETUP_DEFER_TASKRUN")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 44 +++++++++++++++++++++++++++++---------------
 1 file changed, 29 insertions(+), 15 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index a587b240fa48..ddbce269b6a7 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1386,7 +1386,20 @@ static void __cold io_move_task_work_from_local(struct io_ring_ctx *ctx)
 	}
 }
 
-static int __io_run_local_work(struct io_ring_ctx *ctx, struct io_tw_state *ts)
+static bool io_run_local_work_continue(struct io_ring_ctx *ctx, int events,
+				       int min_events)
+{
+	if (llist_empty(&ctx->work_llist))
+		return false;
+	if (events < min_events)
+		return true;
+	if (ctx->flags & IORING_SETUP_TASKRUN_FLAG)
+		atomic_or(IORING_SQ_TASKRUN, &ctx->rings->sq_flags);
+	return false;
+}
+
+static int __io_run_local_work(struct io_ring_ctx *ctx, struct io_tw_state *ts,
+			       int min_events)
 {
 	struct llist_node *node;
 	unsigned int loops = 0;
@@ -1414,18 +1427,20 @@ static int __io_run_local_work(struct io_ring_ctx *ctx, struct io_tw_state *ts)
 	}
 	loops++;
 
-	if (!llist_empty(&ctx->work_llist))
+	if (io_run_local_work_continue(ctx, ret, min_events))
 		goto again;
 	if (ts->locked) {
 		io_submit_flush_completions(ctx);
-		if (!llist_empty(&ctx->work_llist))
+		if (io_run_local_work_continue(ctx, ret, min_events))
 			goto again;
 	}
+
 	trace_io_uring_local_work_run(ctx, ret, loops);
 	return ret;
 }
 
-static inline int io_run_local_work_locked(struct io_ring_ctx *ctx)
+static inline int io_run_local_work_locked(struct io_ring_ctx *ctx,
+					   int min_events)
 {
 	struct io_tw_state ts = { .locked = true, };
 	int ret;
@@ -1433,20 +1448,20 @@ static inline int io_run_local_work_locked(struct io_ring_ctx *ctx)
 	if (llist_empty(&ctx->work_llist))
 		return 0;
 
-	ret = __io_run_local_work(ctx, &ts);
+	ret = __io_run_local_work(ctx, &ts, min_events);
 	/* shouldn't happen! */
 	if (WARN_ON_ONCE(!ts.locked))
 		mutex_lock(&ctx->uring_lock);
 	return ret;
 }
 
-static int io_run_local_work(struct io_ring_ctx *ctx)
+static int io_run_local_work(struct io_ring_ctx *ctx, int min_events)
 {
 	struct io_tw_state ts = {};
 	int ret;
 
 	ts.locked = mutex_trylock(&ctx->uring_lock);
-	ret = __io_run_local_work(ctx, &ts);
+	ret = __io_run_local_work(ctx, &ts, min_events);
 	if (ts.locked)
 		mutex_unlock(&ctx->uring_lock);
 
@@ -1642,7 +1657,7 @@ static int io_iopoll_check(struct io_ring_ctx *ctx, long min)
 		    io_task_work_pending(ctx)) {
 			u32 tail = ctx->cached_cq_tail;
 
-			(void) io_run_local_work_locked(ctx);
+			(void) io_run_local_work_locked(ctx, min);
 
 			if (task_work_pending(current) ||
 			    wq_list_empty(&ctx->iopoll_list)) {
@@ -2486,7 +2501,7 @@ int io_run_task_work_sig(struct io_ring_ctx *ctx)
 {
 	if (!llist_empty(&ctx->work_llist)) {
 		__set_current_state(TASK_RUNNING);
-		if (io_run_local_work(ctx) > 0)
+		if (io_run_local_work(ctx, INT_MAX) > 0)
 			return 0;
 	}
 	if (io_run_task_work() > 0)
@@ -2554,7 +2569,7 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 	if (!io_allowed_run_tw(ctx))
 		return -EEXIST;
 	if (!llist_empty(&ctx->work_llist))
-		io_run_local_work(ctx);
+		io_run_local_work(ctx, min_events);
 	io_run_task_work();
 	io_cqring_overflow_flush(ctx);
 	/* if user messes with these they will just get an early return */
@@ -2592,11 +2607,10 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 
 	trace_io_uring_cqring_wait(ctx, min_events);
 	do {
+		int nr_wait = (int) iowq.cq_tail - READ_ONCE(ctx->rings->cq.tail);
 		unsigned long check_cq;
 
 		if (ctx->flags & IORING_SETUP_DEFER_TASKRUN) {
-			int nr_wait = (int) iowq.cq_tail - READ_ONCE(ctx->rings->cq.tail);
-
 			atomic_set(&ctx->cq_wait_nr, nr_wait);
 			set_current_state(TASK_INTERRUPTIBLE);
 		} else {
@@ -2615,7 +2629,7 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 		 */
 		io_run_task_work();
 		if (!llist_empty(&ctx->work_llist))
-			io_run_local_work(ctx);
+			io_run_local_work(ctx, nr_wait);
 
 		/*
 		 * Non-local task_work will be run on exit to userspace, but
@@ -3270,7 +3284,7 @@ static __cold bool io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 
 	if ((ctx->flags & IORING_SETUP_DEFER_TASKRUN) &&
 	    io_allowed_defer_tw_run(ctx))
-		ret |= io_run_local_work(ctx) > 0;
+		ret |= io_run_local_work(ctx, INT_MAX) > 0;
 	ret |= io_cancel_defer_files(ctx, task, cancel_all);
 	mutex_lock(&ctx->uring_lock);
 	ret |= io_poll_remove_all(ctx, task, cancel_all);
@@ -3632,7 +3646,7 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 			 * it should handle ownership problems if any.
 			 */
 			if (ctx->flags & IORING_SETUP_DEFER_TASKRUN)
-				(void)io_run_local_work_locked(ctx);
+				(void)io_run_local_work_locked(ctx, min_complete);
 		}
 		mutex_unlock(&ctx->uring_lock);
 	}
-- 
2.43.0


