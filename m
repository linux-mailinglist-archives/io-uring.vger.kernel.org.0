Return-Path: <io-uring+bounces-10805-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DD38C877B4
	for <lists+io-uring@lfdr.de>; Wed, 26 Nov 2025 00:40:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 6F3F74E2FA7
	for <lists+io-uring@lfdr.de>; Tue, 25 Nov 2025 23:40:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D40892F618B;
	Tue, 25 Nov 2025 23:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="HCDhzo4Y"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qk1-f227.google.com (mail-qk1-f227.google.com [209.85.222.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B01EC2F290B
	for <io-uring@vger.kernel.org>; Tue, 25 Nov 2025 23:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764113985; cv=none; b=uBoTjRiNiGZOm2pTC+S9XE2QgaaghYA9chdSDZgvb4K+HL7mQXDoFai41HrY6ZbajMGaqc2xEQsVozsnvOqf98AdArqzmd1iU+K/YFQh2Lre6kTjoz+uCd03IJYcLPphSkkc+i4d4fV4q6Pav2fbZ/H/TWT1kA8d0JVbY8PswHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764113985; c=relaxed/simple;
	bh=Tc9M7XOLzN3MKCvdvFx/ylZfkBG+8HRcgSWv13XC13k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ezD+ZwLNgG4wdiddltQsbQ8T98CHU0c8Uxjs+GTCe+p4fVfkTmc8m4sk+Uy695SdZpH24c6iuBw12IHaalmukxdjbaYocggBueiM1qta+DqZH8hY3nBhXKY3FegWshNBzMX2wm/n2Rtg2MKqvwcXVP4OYRFjdX/oHzVCLDgH9T0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=HCDhzo4Y; arc=none smtp.client-ip=209.85.222.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-qk1-f227.google.com with SMTP id af79cd13be357-8b2df1e0c10so110101985a.0
        for <io-uring@vger.kernel.org>; Tue, 25 Nov 2025 15:39:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1764113982; x=1764718782; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uyOg0feMqAK4/apdTc/BWDHfN53hYCUTgX4vLDoCsVk=;
        b=HCDhzo4YF9AoNARL+ZcqmCFr+3W3zlR17LUERaHE5IRyn0Ab0+Q34V+qaiUoblYA50
         CkUVd6cGuEV7qc2PiOQsaAD6KSK2yk3mJa47FQeXjLXNTA36Rdo1eCSoLbyn9s/93DfJ
         Lv2bj5FsujwVmuZr7+bVrIEOGa9A/OBVNIs+voTZh98hlgoRr5w5mcREVMjGgKWLGGUx
         XYIinTMilPjOkTwnMigw9Bf55BWYZS1dW6oBN+0CGVMIuOj+dIbiIn9FuCC6fHLsBslG
         UPQe3kDLy9vv6jzA7aAl+MZzYcFusFyP0dRYGrp1U7M9Ecmn3iyvyUz30D/EAk4fqdyw
         9Ikw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764113982; x=1764718782;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=uyOg0feMqAK4/apdTc/BWDHfN53hYCUTgX4vLDoCsVk=;
        b=hu4CgVHpH0ahxZ+dHIQHxmcGnT/NxVgLzZ2C1361kB7KlULCam1uxw+OCETszwXIhs
         4y62ZiUcOUX/S5d1eNGht5EPnFva9GuysUKYB5hDlAV2KtOCzkB4SNr6jBoUxCEUwZ+z
         wT43gafELyFMI0tamMt2c4wD8TkIyIBFn4a1CTtab9+ftFIQ23lezWyV01vfuaUabwai
         UY84lj1cGXrEDHnncLmuEXrIEpDzeq9Ix755ZedXVTqs7Xb05DW/SbdgMwQDJDLqX17G
         G6Q4FKp/XQL0GHnJ8B5nGcKox/c5A2YqsmDH/dLVfMaIWXVB5aN517IW3X3J2RoRPMzr
         qEtA==
X-Gm-Message-State: AOJu0YwuVLbpTDbgml1wBhTtRt4Xhn/zrNTgfaMKqbxywtu0xBzbN8IW
	U8xNvfCWu8xO36hMN0b+xy+nEyrMuTCEgrHxVfXCCQKL9o9YBWO1thYjauvGIkkSIWIDz8qH7c/
	BHq7FV97sSk0F3hyam+j7NeacbXShdH0GZX/KpiGrbFAyTkIwbXSz
X-Gm-Gg: ASbGnctTHuEvrrwJcCtkou3/nMHjiH18k+CaL/jdS96SMHCOSPBa8iN4slZgxeRjhWt
	BCbA+kJTPbrytUUIWwh8IN9DFBgv9YgVAoseTTKj5JYJw+FE4U92tmJGu+gPc1ztUb1Hdh3yqy5
	4baMoQ4H13TJULsx5qnThjh4AZ82IHoa++ZhwCzdT3gL1f3biS/gZtY4CFTu+Y3DYmaBPpGawFU
	KmFPjep6TcPB18kSwJWxceo9SzyNhtCj3w88m1B/BJk2vaV8NzX7hEfNdpDbiiuQ93qCeUMr4hC
	HvzmmeaGIlSD4qVqj3hZUR5XwFqkEgDMrWpTAbsrHh3kYi2/QN2xDGIEnQGROj/Wja7E91KAhoy
	64UyJC8bfAvEJpTyvXcbU/LmTVrE=
X-Google-Smtp-Source: AGHT+IEqcoLxP9btPk8rF40Uuvw6WMHO2Hop7Z9kE77zxfDpmhyzspv5F1buVGRy8r+tzzqM1cup7mKYmwKj
X-Received: by 2002:a05:620a:444e:b0:8a3:d644:6930 with SMTP id af79cd13be357-8b341ccaae3mr1675591485a.5.1764113982406;
        Tue, 25 Nov 2025 15:39:42 -0800 (PST)
Received: from c7-smtp-2023.dev.purestorage.com ([2620:125:9017:12:36:3:5:0])
        by smtp-relay.gmail.com with ESMTPS id af79cd13be357-8b3293255cbsm176858485a.2.2025.11.25.15.39.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Nov 2025 15:39:42 -0800 (PST)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (unknown [IPv6:2620:125:9007:640:ffff::1199])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id 3FBE33400AF;
	Tue, 25 Nov 2025 16:39:41 -0700 (MST)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id 3DB1AE41EF2; Tue, 25 Nov 2025 16:39:41 -0700 (MST)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Caleb Sander Mateos <csander@purestorage.com>
Subject: [PATCH v3 4/4] io_uring: avoid uring_lock for IORING_SETUP_SINGLE_ISSUER
Date: Tue, 25 Nov 2025 16:39:28 -0700
Message-ID: <20251125233928.3962947-5-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20251125233928.3962947-1-csander@purestorage.com>
References: <20251125233928.3962947-1-csander@purestorage.com>
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
In io_uring_register(), continue to always acquire the uring_lock mutex.
io_uring_register() can be called on a disabled io_ring_ctx (indeed,
it's required to enable it), when submitter_task isn't set yet. After
submitter_task is set, io_uring_register() is only permitted on
submitter_task, so uring_lock suffices to exclude all other users.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
---
 io_uring/io_uring.c |  11 +++++
 io_uring/io_uring.h | 101 ++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 109 insertions(+), 3 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index e05e56a840f9..64e4e57e2c11 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -363,10 +363,21 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
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
+	suspend_work->lock_state->suspend_end = &suspend_end;
+	complete(&suspend_work->suspend_start);
+	wait_for_completion(&suspend_end);
+}
+
 static void io_clean_op(struct io_kiocb *req)
 {
 	if (unlikely(req->flags & REQ_F_BUFFER_SELECTED))
 		io_kbuf_drop_legacy(req);
 
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 23dae0af530b..262971224cc6 100644
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
@@ -195,36 +196,130 @@ void io_queue_next(struct io_kiocb *req);
 void io_task_refs_refill(struct io_uring_task *tctx);
 bool __io_alloc_req_refill(struct io_ring_ctx *ctx);
 
 void io_activate_pollwq(struct io_ring_ctx *ctx);
 
+/*
+ * The ctx uring lock protects most of the mutable struct io_ring_ctx state
+ * accessed in the struct io_kiocb issue path. In the I/O path, it is typically
+ * acquired in the io_uring_enter() syscall and io_handle_tw_list(). For
+ * IORING_SETUP_SQPOLL, it's acquired by io_sq_thread() instead. io_kiocb's
+ * issued with IO_URING_F_UNLOCKED in issue_flags (e.g. by io_wq_submit_work())
+ * acquire and release the ctx uring lock whenever they must touch io_ring_ctx
+ * state. io_uring_register() also acquires the ctx uring lock because most
+ * opcodes mutate io_ring_ctx state accessed in the issue path.
+ *
+ * For !IORING_SETUP_SINGLE_ISSUER io_ring_ctx's, acquiring the ctx uring lock
+ * is always done via mutex_(try)lock(&ctx->uring_lock).
+ *
+ * However, for IORING_SETUP_SINGLE_ISSUER, we can avoid the mutex_lock() +
+ * mutex_unlock() overhead on submitter_task because a single thread can't race
+ * with itself. In the uncommon case where the ctx uring lock is needed on
+ * another thread, it must suspend submitter_task by scheduling a task work item
+ * on it. io_ring_ctx_lock() returns once the task work item has started.
+ * submitter_task is unblocked once io_ring_ctx_unlock() is called.
+ *
+ * io_uring_register() requires special treatment for IORING_SETUP_SINGLE_ISSUER
+ * since it's allowed on a IORING_SETUP_R_DISABLED io_ring_ctx, where
+ * submitter_task isn't set yet. Hence the io_ring_register_ctx_*() family
+ * of helpers. They unconditionally acquire the uring_lock mutex, which always
+ * works to exclude other ctx uring lock users:
+ * - For !IORING_SETUP_SINGLE_ISSUER, all users acquire the ctx uring lock via
+ *   the uring_lock mutex
+ * - For IORING_SETUP_SINGLE_ISSUER and IORING_SETUP_R_DISABLED, only
+ *   io_uring_register() is allowed before the io_ring_ctx is enabled.
+ *   So again, all ctx uring lock users acquire the uring_lock mutex.
+ * - For IORING_SETUP_SINGLE_ISSUER and !IORING_SETUP_R_DISABLED,
+ *   io_uring_register() is only permitted on submitter_task, which is always
+ *   granted the ctx uring lock unless suspended.
+ *   Acquiring the uring_lock mutex is unnecessary but still correct.
+ */
+
 struct io_ring_ctx_lock_state {
+	struct completion *suspend_end;
 };
 
+struct io_ring_suspend_work {
+	struct callback_head cb_head;
+	struct completion suspend_start;
+	struct io_ring_ctx_lock_state *lock_state;
+};
+
+void io_ring_suspend_work(struct callback_head *cb_head);
+
 /* Acquire the ctx uring lock */
 static inline void io_ring_ctx_lock(struct io_ring_ctx *ctx,
 				    struct io_ring_ctx_lock_state *state)
 {
-	mutex_lock(&ctx->uring_lock);
+	struct io_ring_suspend_work suspend_work;
+	struct task_struct *submitter_task;
+
+	if (!(ctx->flags & IORING_SETUP_SINGLE_ISSUER)) {
+		mutex_lock(&ctx->uring_lock);
+		return;
+	}
+
+	submitter_task = ctx->submitter_task;
+	/*
+	 * Not suitable for use while IORING_SETUP_R_DISABLED.
+	 * Must use io_ring_register_ctx_lock() in that case.
+	 */
+	WARN_ON_ONCE(!submitter_task);
+	if (likely(current == submitter_task))
+		return;
+
+	/* Use task work to suspend submitter_task */
+	init_task_work(&suspend_work.cb_head, io_ring_suspend_work);
+	init_completion(&suspend_work.suspend_start);
+	suspend_work.lock_state = state;
+	/* If task_work_add() fails, task is exiting, so no need to suspend */
+	if (unlikely(task_work_add(submitter_task, &suspend_work.cb_head,
+				   TWA_SIGNAL))) {
+		state->suspend_end = NULL;
+		return;
+	}
+
+	wait_for_completion(&suspend_work.suspend_start);
 }
 
 /* Attempt to acquire the ctx uring lock without blocking */
 static inline bool io_ring_ctx_trylock(struct io_ring_ctx *ctx)
 {
-	return mutex_trylock(&ctx->uring_lock);
+	if (!(ctx->flags & IORING_SETUP_SINGLE_ISSUER))
+		return mutex_trylock(&ctx->uring_lock);
+
+	/* Not suitable for use while IORING_SETUP_R_DISABLED */
+	WARN_ON_ONCE(!ctx->submitter_task);
+	return current == ctx->submitter_task;
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
+	if (likely(current == ctx->submitter_task))
+		return;
+
+	if (likely(state->suspend_end))
+		complete(state->suspend_end);
 }
 
 /* Assert (if CONFIG_LOCKDEP) that the ctx uring lock is held */
 static inline void io_ring_ctx_assert_locked(const struct io_ring_ctx *ctx)
 {
+	/*
+	 * No straightforward way to check that submitter_task is suspended
+	 * without access to struct io_ring_ctx_lock_state
+	 */
+	if (ctx->flags & IORING_SETUP_SINGLE_ISSUER)
+		return;
+
 	lockdep_assert_held(&ctx->uring_lock);
 }
 
 /* Acquire the ctx uring lock during the io_uring_register() syscall */
 static inline void io_ring_register_ctx_lock(struct io_ring_ctx *ctx)
-- 
2.45.2


