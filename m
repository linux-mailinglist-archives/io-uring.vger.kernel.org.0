Return-Path: <io-uring+bounces-11050-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CD1BDCBFB4B
	for <lists+io-uring@lfdr.de>; Mon, 15 Dec 2025 21:14:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 77C2E305A607
	for <lists+io-uring@lfdr.de>; Mon, 15 Dec 2025 20:10:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B9B43126B8;
	Mon, 15 Dec 2025 20:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="CQgFxq9+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f225.google.com (mail-pl1-f225.google.com [209.85.214.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A69253093A8
	for <io-uring@vger.kernel.org>; Mon, 15 Dec 2025 20:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765829431; cv=none; b=SK3/dIY3R7EcyElBkKqHaDLAWg8//O0db/lHPELugxiFDYbtXX1ySNT1PbQGylwiBZbPWdiix6u8FANqKd8QN+9fdG3eqFZS8nSIq+enbtSM7VCWQBAcVO4hg6h9TCMK5tUB4595682NaZLcHpu5qVxfNAcjRc7mImSUnyPD9EI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765829431; c=relaxed/simple;
	bh=Th3x1GnVLvyWsIs7o2mH3MO7rmVc9JYDl4IXg7VFffc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NzXT/Fc48YJHi1CGkvuADPQQnHggIXKY3gKu+Ckc7ecYMKqzDkxzh+f+QzNEbTwAm7E5OTbwAYiM/Q912eX+hzbvCGt1l/IydoJfFFBy8N7BIUGCkJnJNwptHqUHk8NxJ7kelL/9EdR/huN0r2P27pJfM+IqMAWy8fh2LjBnTUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=CQgFxq9+; arc=none smtp.client-ip=209.85.214.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pl1-f225.google.com with SMTP id d9443c01a7336-2a07fb1527cso6462555ad.3
        for <io-uring@vger.kernel.org>; Mon, 15 Dec 2025 12:10:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1765829429; x=1766434229; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ko/LClSHTdkG76HWn8DkHdX7BBXIyp6DFUvzQNarTeQ=;
        b=CQgFxq9+TSpOX3XyaEdLPrdGb4q+/TRFyBcJOh2GuCWiN3TVfcVp8uEW0+O1uLHrMg
         TrX0pd2HxJRamiu/FhvF7gndfsM6IFqJo4Zd6wyqslB8Q1KOCuHrcBiXCYg9YXddWEMZ
         eJOnmLdKVk++75Ldyjw93r6d+HiWbwxctWNjjfm2Ft1iGvVjrzlvmGWPg9+B9c5cvzn3
         GH8H9OpdLOzTZVQiKyQqRx4OCek/E3W49EPo2+NAT0pJ8pFdoWJt3Lh8aOyAYxWcV+4p
         kZmNUIemh1jysAp6ZE77ksb65XNZ/QngpHRwApfFceQvbxx9+xJ9X34YNeeywo9vJp51
         Qbww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765829429; x=1766434229;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Ko/LClSHTdkG76HWn8DkHdX7BBXIyp6DFUvzQNarTeQ=;
        b=DO1W1CvWHZjRRaFoDMt+YVcuUn3Sz4xK+v+rchpKQ+KzRljVXQQsTGxi5Cg34LRB3X
         HeogLU2Bj9XZbH4OYt/2ruXcABlA52YE3raUDNl/HqVWk0Uif47A4UAl/yxUagylY6df
         0HSyikJ1s+f6f8b3d+XW12HPkocecDZsVjuByzewH79ryIk8L49wqlsCtdQLw3uC04QK
         PswvzLz02f/5HocOz+HwNjaRSS1srV5FUpOqP06YNd2Suv8PsRYIuuzvAyQ4TJwFM03Z
         pU/5QshBPXVz2BJ5vemsEkB+zbSJqdwuE+YIF8893VDHjedUz5LCdN8ryqQpjl0gGZ2E
         mMCw==
X-Forwarded-Encrypted: i=1; AJvYcCURcFHfuh5buAqgyRhAEjYc8mBU+mAmtNZ8toaGEBZmPdMAOgzFIIXvKwlbKmSp5H/jnmemFI8cyw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy3fELuiAVEj4Dzj28KGdHBHbcvBr6BeTYRwWRCKQUpJhKbxAvf
	cxiRwKoBRaX5zb6rz8VHE8FxaVqSTlM9JaodXxbvjw6HgHgrom9kPnTlIWfI+KP/ioivBzj072f
	koXu23NbbCaQXG1vfqn0gCSBpJRBETI1Nu/JqGZlJXvZqxvDzQtpH
X-Gm-Gg: AY/fxX7CPLxaACFCVNdHe9QeuMpkViZhxXCZS9JgcegV8TZOwbk4iL9GeaUmWTmaA+8
	YDLAmGYSSk6HM09b5pSmJUBYuQ6XcFV6qH5FduOnyWkQ4K5B3FJAuJ07o7VYNtQe40I71pDH6OZ
	XDW5OMpVKOoLXMLmnkxW+zUooq1sU+gg4to7mhwND+o/pt7r7DY/KwHXr2TzTSkP5sx+bXrsXgV
	w3p7jc0a+2cr8ClCjl1OVbr+opRHaYAXL/0hiDZ/SXDf6vkDobksEXpZbpj9m01yG/VLkl2XI8K
	JGyIuh+3R//7hDFSA0w4mNUdqs13o0+6fZMnaXp/L9eHwnD6+IGINqbvSkriEuj5ODbRnr3XHaS
	T2ZBbBEpswAxKNXaOLK3vpRr9Ohg=
X-Google-Smtp-Source: AGHT+IEZQLFh/AgKtPTPGty6OJt5+mqM9TvDA8qf8mzAk9jAKV7/9jzHrUr8dG3UFHhpYJiCs2Be0je2xaqc
X-Received: by 2002:a17:903:1510:b0:2a0:b7cd:d9c6 with SMTP id d9443c01a7336-2a0b7cddbb1mr54185655ad.6.1765829428629;
        Mon, 15 Dec 2025 12:10:28 -0800 (PST)
Received: from c7-smtp-2023.dev.purestorage.com ([2620:125:9017:12:36:3:5:0])
        by smtp-relay.gmail.com with ESMTPS id d9443c01a7336-2a0d72620f2sm7448815ad.6.2025.12.15.12.10.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Dec 2025 12:10:28 -0800 (PST)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.7.70.37])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id F1EB4340644;
	Mon, 15 Dec 2025 13:10:27 -0700 (MST)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id EE9EFE41D23; Mon, 15 Dec 2025 13:10:27 -0700 (MST)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Joanne Koong <joannelkoong@gmail.com>,
	Caleb Sander Mateos <csander@purestorage.com>,
	syzbot@syzkaller.appspotmail.com
Subject: [PATCH v5 6/6] io_uring: avoid uring_lock for IORING_SETUP_SINGLE_ISSUER
Date: Mon, 15 Dec 2025 13:09:09 -0700
Message-ID: <20251215200909.3505001-7-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20251215200909.3505001-1-csander@purestorage.com>
References: <20251215200909.3505001-1-csander@purestorage.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_ring_ctx's mutex uring_lock can be quite expensive in high-IOPS
workloads. Even when only one thread pinned to a single CPU is accessing
the io_ring_ctx, the atomic CASes required to lock and unlock the mutex
are very hot instructions. The mutex's primary purpose is to prevent
concurrent io_uring system calls on the same io_ring_ctx. However, there
is already a flag IORING_SETUP_SINGLE_ISSUER that promises only one
task will make io_uring_enter() and io_uring_register() system calls on
the io_ring_ctx once it's enabled.
So if the io_ring_ctx is setup with IORING_SETUP_SINGLE_ISSUER, skip the
uring_lock mutex_lock() and mutex_unlock() on the submitter_task. On
other tasks acquiring the ctx uring lock, use a task work item to
suspend the submitter_task for the critical section.
If the io_ring_ctx is IORING_SETUP_R_DISABLED (possible during
io_uring_setup(), io_uring_register(), or io_uring exit), submitter_task
may be set concurrently, so acquire the uring_lock before checking it.
If submitter_task isn't set yet, the uring_lock suffices to provide
mutual exclusion.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
Tested-by: syzbot@syzkaller.appspotmail.com
---
 io_uring/io_uring.c |  12 +++++
 io_uring/io_uring.h | 114 ++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 123 insertions(+), 3 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index ac71350285d7..9a9dfcb0476e 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -363,10 +363,22 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	xa_destroy(&ctx->io_bl_xa);
 	kfree(ctx);
 	return NULL;
 }
 
+void io_ring_suspend_work(struct callback_head *cb_head)
+{
+	struct io_ring_suspend_work *suspend_work =
+		container_of(cb_head, struct io_ring_suspend_work, cb_head);
+	DECLARE_COMPLETION_ONSTACK(suspend_end);
+
+	*suspend_work->suspend_end = &suspend_end;
+	complete(&suspend_work->suspend_start);
+
+	wait_for_completion(&suspend_end);
+}
+
 static void io_clean_op(struct io_kiocb *req)
 {
 	if (unlikely(req->flags & REQ_F_BUFFER_SELECTED))
 		io_kbuf_drop_legacy(req);
 
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 57c3eef26a88..2b08d0ddab30 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -1,8 +1,9 @@
 #ifndef IOU_CORE_H
 #define IOU_CORE_H
 
+#include <linux/completion.h>
 #include <linux/errno.h>
 #include <linux/lockdep.h>
 #include <linux/resume_user_mode.h>
 #include <linux/kasan.h>
 #include <linux/poll.h>
@@ -195,19 +196,85 @@ void io_queue_next(struct io_kiocb *req);
 void io_task_refs_refill(struct io_uring_task *tctx);
 bool __io_alloc_req_refill(struct io_ring_ctx *ctx);
 
 void io_activate_pollwq(struct io_ring_ctx *ctx);
 
+/*
+ * The ctx uring lock protects most of the mutable struct io_ring_ctx state
+ * accessed in the struct io_kiocb issue path. In the I/O path, it is typically
+ * acquired in the io_uring_enter() syscall and in io_handle_tw_list(). For
+ * IORING_SETUP_SQPOLL, it's acquired by io_sq_thread() instead. io_kiocb's
+ * issued with IO_URING_F_UNLOCKED in issue_flags (e.g. by io_wq_submit_work())
+ * acquire and release the ctx uring lock whenever they must touch io_ring_ctx
+ * state. io_uring_register() also acquires the ctx uring lock because most
+ * opcodes mutate io_ring_ctx state accessed in the issue path.
+ *
+ * For !IORING_SETUP_SINGLE_ISSUER io_ring_ctx's, acquiring the ctx uring lock
+ * is done via mutex_(try)lock(&ctx->uring_lock).
+ *
+ * However, for IORING_SETUP_SINGLE_ISSUER, we can avoid the mutex_lock() +
+ * mutex_unlock() overhead on submitter_task because a single thread can't race
+ * with itself. In the uncommon case where the ctx uring lock is needed on
+ * another thread, it must suspend submitter_task by scheduling a task work item
+ * on it. io_ring_ctx_lock() returns once the task work item has started.
+ * io_ring_ctx_unlock() allows the task work item to complete.
+ * If io_ring_ctx_lock() is called while the ctx is IORING_SETUP_R_DISABLED
+ * (e.g. during ctx create or exit), io_ring_ctx_lock() must acquire uring_lock
+ * because submitter_task isn't set yet. submitter_task can be accessed once
+ * uring_lock is held. If submitter_task exists, we do the same thing as in the
+ * non-IORING_SETUP_R_DISABLED case (except with uring_lock also held). If
+ * submitter_task isn't set, all other io_ring_ctx_lock() callers will also
+ * acquire uring_lock, so it suffices for mutual exclusion.
+ */
+
+struct io_ring_suspend_work {
+	struct callback_head cb_head;
+	struct completion suspend_start;
+	struct completion **suspend_end;
+};
+
+void io_ring_suspend_work(struct callback_head *cb_head);
+
 struct io_ring_ctx_lock_state {
+	bool need_mutex;
+	struct completion *suspend_end;
 };
 
 /* Acquire the ctx uring lock with the given nesting level */
 static inline void io_ring_ctx_lock_nested(struct io_ring_ctx *ctx,
 					   unsigned int subclass,
 					   struct io_ring_ctx_lock_state *state)
 {
-	mutex_lock_nested(&ctx->uring_lock, subclass);
+	struct io_ring_suspend_work suspend_work;
+
+	if (!(ctx->flags & IORING_SETUP_SINGLE_ISSUER)) {
+		mutex_lock_nested(&ctx->uring_lock, subclass);
+		return;
+	}
+
+	state->suspend_end = NULL;
+	state->need_mutex =
+		!!(smp_load_acquire(&ctx->flags) & IORING_SETUP_R_DISABLED);
+	if (unlikely(state->need_mutex)) {
+		mutex_lock_nested(&ctx->uring_lock, subclass);
+		if (likely(!ctx->submitter_task))
+			return;
+	}
+
+	if (likely(current == ctx->submitter_task))
+		return;
+
+	/* Use task work to suspend submitter_task */
+	init_task_work(&suspend_work.cb_head, io_ring_suspend_work);
+	init_completion(&suspend_work.suspend_start);
+	suspend_work.suspend_end = &state->suspend_end;
+	/* If task_work_add() fails, task is exiting, so no need to suspend */
+	if (unlikely(task_work_add(ctx->submitter_task, &suspend_work.cb_head,
+				   TWA_SIGNAL)))
+		return;
+
+	wait_for_completion(&suspend_work.suspend_start);
 }
 
 /* Acquire the ctx uring lock */
 static inline void io_ring_ctx_lock(struct io_ring_ctx *ctx,
 				    struct io_ring_ctx_lock_state *state)
@@ -217,29 +284,70 @@ static inline void io_ring_ctx_lock(struct io_ring_ctx *ctx,
 
 /* Attempt to acquire the ctx uring lock without blocking */
 static inline bool io_ring_ctx_trylock(struct io_ring_ctx *ctx,
 				       struct io_ring_ctx_lock_state *state)
 {
-	return mutex_trylock(&ctx->uring_lock);
+	if (!(ctx->flags & IORING_SETUP_SINGLE_ISSUER))
+		return mutex_trylock(&ctx->uring_lock);
+
+	state->suspend_end = NULL;
+	state->need_mutex =
+		!!(smp_load_acquire(&ctx->flags) & IORING_SETUP_R_DISABLED);
+	if (unlikely(state->need_mutex)) {
+		if (!mutex_trylock(&ctx->uring_lock))
+			return false;
+		if (likely(!ctx->submitter_task))
+			return true;
+	}
+
+	if (unlikely(current != ctx->submitter_task))
+		goto unlock;
+
+	return true;
+
+unlock:
+	if (unlikely(state->need_mutex))
+		mutex_unlock(&ctx->uring_lock);
+	return false;
 }
 
 /* Release the ctx uring lock */
 static inline void io_ring_ctx_unlock(struct io_ring_ctx *ctx,
 				      struct io_ring_ctx_lock_state *state)
 {
-	mutex_unlock(&ctx->uring_lock);
+	if (!(ctx->flags & IORING_SETUP_SINGLE_ISSUER)) {
+		mutex_unlock(&ctx->uring_lock);
+		return;
+	}
+
+	if (unlikely(state->need_mutex))
+		mutex_unlock(&ctx->uring_lock);
+	if (unlikely(state->suspend_end))
+		complete(state->suspend_end);
 }
 
 /* Return (if CONFIG_LOCKDEP) whether the ctx uring lock is held */
 static inline bool io_ring_ctx_lock_held(const struct io_ring_ctx *ctx)
 {
+	/*
+	 * No straightforward way to check that submitter_task is suspended
+	 * without access to struct io_ring_ctx_lock_state
+	 */
+	if (ctx->flags & IORING_SETUP_SINGLE_ISSUER &&
+	    !(ctx->flags & IORING_SETUP_R_DISABLED))
+		return true;
+
 	return lockdep_is_held(&ctx->uring_lock);
 }
 
 /* Assert (if CONFIG_LOCKDEP) that the ctx uring lock is held */
 static inline void io_ring_ctx_assert_locked(const struct io_ring_ctx *ctx)
 {
+	if (ctx->flags & IORING_SETUP_SINGLE_ISSUER &&
+	    !(ctx->flags & IORING_SETUP_R_DISABLED))
+		return;
+
 	lockdep_assert_held(&ctx->uring_lock);
 }
 
 static inline void io_lockdep_assert_cq_locked(struct io_ring_ctx *ctx)
 {
-- 
2.45.2


