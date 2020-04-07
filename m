Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E31AE1A10E3
	for <lists+io-uring@lfdr.de>; Tue,  7 Apr 2020 18:03:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726889AbgDGQDI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Apr 2020 12:03:08 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:37752 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727991AbgDGQDI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Apr 2020 12:03:08 -0400
Received: by mail-pg1-f193.google.com with SMTP id r4so1938733pgg.4
        for <io-uring@vger.kernel.org>; Tue, 07 Apr 2020 09:03:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=151owXNTO53jByuuGSr5GWu4XC2mXE43fBblB5HhEno=;
        b=OY+o5Kl2wRP4YUXEIdYYuK8hE7brEtaS7WwrCHTtQ28ywV3po50N+au6Dd372AdWCw
         FhHPFQ5ZPbLru6o2a0A9NgtuV2v3r61QldAV96NYLhRfTokTvE5fj0OdavVknzXCn55k
         8dv7v660higYF+SkPLu+CqJ0Bl4PJ5TKWQ2Wo/1NYXmzatH8hdSQ8umF8otg0HNohGlM
         jTst8h/8Cb8FcuqMlS17t9/RYDR2QrkdRKjSToglY1egafxza9eJqkf92wMjWJUnBLgY
         0GoKbl6hU2L1FOA+hDu7JHWrUB8/inpyoozAMgsI/BN2pp+ZaVT13AVbl3YAkAukMdVy
         zIrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=151owXNTO53jByuuGSr5GWu4XC2mXE43fBblB5HhEno=;
        b=fcYZyfaNresr4TeaLPEryQ2y0iQjYC/9DE41v242Cq75+VVT2+7m2FDRJiPiRsoOfe
         m/adVh3Szt5Zo5oV08O9UpOddKtZIOCUIIZ86nsm6kCzFP0YO9xKsWDWuH6nAIOwofUN
         H6EUZd4gaaBhgTIV28xy/Nx7ozk/0zSZEqTSGViccCRQWbpk8/FuW45vuuE8ogTmOHRp
         EWgR8fpZnULMEhc0UE7zaNhvwpg/SrP0z9GVQ8wZzJ+GqufDIbn8lvNWnTvdsAyxIPC0
         IJe1ErymDcMM+8RyzCEH46J+kLj9lfLhKfKl2KA4r2W1YBggbT2jQ7Ndue+PnHjCUVfZ
         y3jA==
X-Gm-Message-State: AGi0PuY7BcwSr7oDP2LBh8TDjHq3P0cwgVLsN+CVIoCdDQ7e1S7p1ORL
        lbAYYW/Jbj3u3/lAS5sTXSNsYzBRvQny4Q==
X-Google-Smtp-Source: APiQypLBbRatft4nupqcNiU2zQxxPySHqLHcaR+nzDfGMmvAZDtnC6yie1XsCEAEzHLpG16utACQHg==
X-Received: by 2002:a63:7e58:: with SMTP id o24mr23849pgn.3.1586275383560;
        Tue, 07 Apr 2020 09:03:03 -0700 (PDT)
Received: from x1.lan ([2605:e000:100e:8c61:ec7d:96d3:6e2d:dcab])
        by smtp.gmail.com with ESMTPSA id y22sm14366955pfr.68.2020.04.07.09.03.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Apr 2020 09:03:03 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     viro@zeniv.linux.org.uk, Jens Axboe <axboe@kernel.dk>,
        Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 2/4] task_work: kill current->task_works checking in callers
Date:   Tue,  7 Apr 2020 10:02:56 -0600
Message-Id: <20200407160258.933-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200407160258.933-1-axboe@kernel.dk>
References: <20200407160258.933-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If the callsite cares, use task_work_pending(). If not, just call
task_work_run() unconditionally, that makes the check inline and
doesn't add any extra overhead.

Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io-wq.c                |  7 ++-----
 fs/io_uring.c             | 20 ++++++++------------
 include/linux/tracehook.h |  3 +--
 kernel/signal.c           |  7 +++----
 4 files changed, 14 insertions(+), 23 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 4023c9846860..5bee3f5f67e1 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -717,8 +717,7 @@ static int io_wq_manager(void *data)
 	complete(&wq->done);
 
 	while (!kthread_should_stop()) {
-		if (current->task_works)
-			task_work_run();
+		task_work_run();
 
 		for_each_node(node) {
 			struct io_wqe *wqe = wq->wqes[node];
@@ -742,9 +741,7 @@ static int io_wq_manager(void *data)
 		schedule_timeout(HZ);
 	}
 
-	if (current->task_works)
-		task_work_run();
-
+	task_work_run();
 	return 0;
 err:
 	set_bit(IO_WQ_BIT_ERROR, &wq->state);
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 773f55c49cd8..7fb51c383e51 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5964,8 +5964,7 @@ static int io_sq_thread(void *data)
 			if (!list_empty(&ctx->poll_list) ||
 			    (!time_after(jiffies, timeout) && ret != -EBUSY &&
 			    !percpu_ref_is_dying(&ctx->refs))) {
-				if (current->task_works)
-					task_work_run();
+				task_work_run();
 				cond_resched();
 				continue;
 			}
@@ -5997,8 +5996,8 @@ static int io_sq_thread(void *data)
 					finish_wait(&ctx->sqo_wait, &wait);
 					break;
 				}
-				if (current->task_works) {
-					task_work_run();
+				if (task_work_pending()) {
+					__task_work_run();
 					finish_wait(&ctx->sqo_wait, &wait);
 					continue;
 				}
@@ -6021,8 +6020,7 @@ static int io_sq_thread(void *data)
 		timeout = jiffies + ctx->sq_thread_idle;
 	}
 
-	if (current->task_works)
-		task_work_run();
+	task_work_run();
 
 	set_fs(old_fs);
 	if (cur_mm) {
@@ -6091,9 +6089,9 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 	do {
 		if (io_cqring_events(ctx, false) >= min_events)
 			return 0;
-		if (!current->task_works)
+		if (!task_work_pending())
 			break;
-		task_work_run();
+		__task_work_run();
 	} while (1);
 
 	if (sig) {
@@ -6114,8 +6112,7 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 	do {
 		prepare_to_wait_exclusive(&ctx->wait, &iowq.wq,
 						TASK_INTERRUPTIBLE);
-		if (current->task_works)
-			task_work_run();
+		task_work_run();
 		if (io_should_wake(&iowq, false))
 			break;
 		schedule();
@@ -7465,8 +7462,7 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 	int submitted = 0;
 	struct fd f;
 
-	if (current->task_works)
-		task_work_run();
+	task_work_run();
 
 	if (flags & ~(IORING_ENTER_GETEVENTS | IORING_ENTER_SQ_WAKEUP))
 		return -EINVAL;
diff --git a/include/linux/tracehook.h b/include/linux/tracehook.h
index 36fb3bbed6b2..608a2d12bc14 100644
--- a/include/linux/tracehook.h
+++ b/include/linux/tracehook.h
@@ -184,8 +184,7 @@ static inline void tracehook_notify_resume(struct pt_regs *regs)
 	 * hlist_add_head(task->task_works);
 	 */
 	smp_mb__after_atomic();
-	if (unlikely(current->task_works))
-		task_work_run();
+	task_work_run();
 
 #ifdef CONFIG_KEYS_REQUEST_CACHE
 	if (unlikely(current->cached_requested_key)) {
diff --git a/kernel/signal.c b/kernel/signal.c
index 5b2396350dd1..e927cfae3151 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2271,8 +2271,8 @@ static void ptrace_do_notify(int signr, int exit_code, int why)
 void ptrace_notify(int exit_code)
 {
 	BUG_ON((exit_code & (0x7f | ~0xffff)) != SIGTRAP);
-	if (unlikely(current->task_works))
-		task_work_run();
+
+	task_work_run();
 
 	spin_lock_irq(&current->sighand->siglock);
 	ptrace_do_notify(SIGTRAP, exit_code, CLD_TRAPPED);
@@ -2529,8 +2529,7 @@ bool get_signal(struct ksignal *ksig)
 	struct signal_struct *signal = current->signal;
 	int signr;
 
-	if (unlikely(current->task_works))
-		task_work_run();
+	task_work_run();
 
 	if (unlikely(uprobe_deny_signal()))
 		return false;
-- 
2.26.0

