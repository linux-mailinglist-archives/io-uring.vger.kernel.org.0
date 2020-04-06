Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72CB619FE6A
	for <lists+io-uring@lfdr.de>; Mon,  6 Apr 2020 21:49:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725895AbgDFTtC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 6 Apr 2020 15:49:02 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:45154 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726084AbgDFTtC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 6 Apr 2020 15:49:02 -0400
Received: by mail-pl1-f196.google.com with SMTP id t4so234902plq.12
        for <io-uring@vger.kernel.org>; Mon, 06 Apr 2020 12:49:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zl/di8o8d7dyenlpyQz2FxzZaJCqjImpLDhJoV0B+EA=;
        b=VyE7+HE286JlsSql0+IOsliBRG1gQMlaMYUJv+VPaOl3bX9Ni/KgLt+lumA/SMSwSa
         f1tlv9GRJ34OnIQsGMNoYgkvfa2aX40YgvBFKqG74hopBaG9hxLQsMkkfmpcpSZT7ZHX
         nEsC74zT6kuGFQWjKN8KaLirpsn0PjEe1BKKexiq4hZua2RSLvP+/KH90Ck+vTXPk3Ei
         Di8TsUCLvXobgdRbZCLbq8kqQwlR3+pfD8tcxySmvN4uIIEMO7p84lVCh3iMOUw8hCvN
         RRJwf8hb/KPMQHiJyzeWDZjF66ojA2daBBCZr2R+tlBLQEIaRqmgLeuDPoi2PVWX14Tz
         jZXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zl/di8o8d7dyenlpyQz2FxzZaJCqjImpLDhJoV0B+EA=;
        b=Hztyg/62K2h+WRM4wISnsUHCZ9xkozVu24jnDlgQbaThG7HSK5GNFJ5fzJj1gEHmNT
         SOlW6ypqGxHUvMG/dqTAFgH/2b57eo8+8YzZuoSQ9L5S8469unZQ/wqZkeg95uO5VMj1
         gu5yJnygMtxHxafIKIDSFoFzgxVL0Oycwy3bIRzr7+eyuz3Xw2k9Ki45F+8Ca2IEEUU8
         S1yTWC85Rnyr3xT23vpD2XB0v3EtNvYg5KXCieeGKdYYk+VqQf1ioAYT3I+nEEWmb/Cd
         UgzmU2tOxxQSmyklYb8LppHkvxaeefERtH9ICaou8segg472hUdLsW+8+ZAygh3aZYkC
         l+oA==
X-Gm-Message-State: AGi0Pua3+4t6pzdBT9qG3WcaVVjMHyf5j9Unrup3JNFjKbhHq7Hv5quj
        miyFnuIinTIMurDwIvTqyaN82PkGHq4QeQ==
X-Google-Smtp-Source: APiQypLJ0lH/hzdiLAsCZposK/w9jFZxcB9QjWcbQWQlr+k/3EZ2vKoIHOSpX/42N17YaytNeFd7Dg==
X-Received: by 2002:a17:902:760f:: with SMTP id k15mr23085762pll.0.1586202539956;
        Mon, 06 Apr 2020 12:48:59 -0700 (PDT)
Received: from x1.lan ([2605:e000:100e:8c61:7d7c:3a38:f0f8:3951])
        by smtp.gmail.com with ESMTPSA id g11sm362620pjs.17.2020.04.06.12.48.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Apr 2020 12:48:59 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     peterz@infradead.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/4] task_work: kill current->task_works checking in callers
Date:   Mon,  6 Apr 2020 13:48:52 -0600
Message-Id: <20200406194853.9896-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200406194853.9896-1-axboe@kernel.dk>
References: <20200406194853.9896-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If the callsite cares, use task_work_pending(). If not, just call
task_work_run() unconditionally, that makes the check inline and
doesn't add any extra overhead.

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
index 79bd22289d73..1579390c7c53 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5967,8 +5967,7 @@ static int io_sq_thread(void *data)
 			if (!list_empty(&ctx->poll_list) ||
 			    (!time_after(jiffies, timeout) && ret != -EBUSY &&
 			    !percpu_ref_is_dying(&ctx->refs))) {
-				if (current->task_works)
-					task_work_run();
+				task_work_run();
 				cond_resched();
 				continue;
 			}
@@ -6000,8 +5999,8 @@ static int io_sq_thread(void *data)
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
@@ -6024,8 +6023,7 @@ static int io_sq_thread(void *data)
 		timeout = jiffies + ctx->sq_thread_idle;
 	}
 
-	if (current->task_works)
-		task_work_run();
+	task_work_run();
 
 	set_fs(old_fs);
 	if (cur_mm) {
@@ -6094,9 +6092,9 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
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
@@ -6117,8 +6115,7 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 	do {
 		prepare_to_wait_exclusive(&ctx->wait, &iowq.wq,
 						TASK_INTERRUPTIBLE);
-		if (current->task_works)
-			task_work_run();
+		task_work_run();
 		if (io_should_wake(&iowq, false))
 			break;
 		schedule();
@@ -7467,8 +7464,7 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
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
index e58a6c619824..d62b7a3f2045 100644
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

