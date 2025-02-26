Return-Path: <io-uring+bounces-6778-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E6281A45D5C
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2025 12:39:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7794A1892FB8
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2025 11:40:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FB4321577D;
	Wed, 26 Feb 2025 11:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shopee.com header.i=@shopee.com header.b="aB+tigxd"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EED419C54E
	for <io-uring@vger.kernel.org>; Wed, 26 Feb 2025 11:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740569986; cv=none; b=gqcL/0ePMDaG6kVSM38X88Ja7GC7W0RQt2OeUuYXoxpGRqUPFpZYtKPfLR0LIDv7iJDls7gOHIZDAqr5pjt9gdaq6Ot+B8PWdLsSGILUdxlAZkF6hKN+/cNP3pgwUyR7V0858GnoOEFVJprrFMBrI/79iMixyz1gcsbKMj0VXbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740569986; c=relaxed/simple;
	bh=nxXKSrBkcEctdHXJ1EIDy5SMRGntL5ukUQhgK9FCjtw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PF8FOBrZp+tp0ewZxN9/jEhzksupSutPEyTY+tKMjmkGSnGijJpmbY4G91eK2fQorf6yT5ZECAx+bOCkiJAcGxbQynFcslngB67GqymlTcysKpFANRuZlUT5UVu96e217G551NwdvRu6wQ++qMmcr/zlJSbbUhRcJRErSrY8+r4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=shopee.com; spf=pass smtp.mailfrom=shopee.com; dkim=pass (2048-bit key) header.d=shopee.com header.i=@shopee.com header.b=aB+tigxd; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=shopee.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shopee.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2210d92292eso47247655ad.1
        for <io-uring@vger.kernel.org>; Wed, 26 Feb 2025 03:39:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shopee.com; s=shopee.com; t=1740569982; x=1741174782; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=RvZRoCysp+rlQWcsd6zeQXMTiABhtLdxvlTgkNMlriQ=;
        b=aB+tigxdxeuiWucGJkDQkRXbT2EWBxCCvdwqB0rEtrikTXWYvtQ1e2fEXZ0/WTI7v1
         MYl0cBZ74OapLA+8g4SXAmc+GL2KQHRdETSbQWAcCBuFP/oraSBC3O23EcyE5LRTSYv3
         AXzJjYp8dlHr2anbR9as8M9pYXZtgxw7jiEFchaTLHw4mxt1sfT93Y+cuhf0Sdy8ISrw
         OfxMN3x+6uWaX0F7SoxUyUXSVV0tt9ZFUVPQOX3iL/2nacPpQzpoMi7J2szGWH1Hvcz8
         OU0VzO8dtEIKEDLMZyQ06+ipoB+mkRT1++8y8oPYjlupOG3xot8nyrYi69jLwjgBYDz8
         1pFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740569982; x=1741174782;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RvZRoCysp+rlQWcsd6zeQXMTiABhtLdxvlTgkNMlriQ=;
        b=BJpMvXWZqHRwkJM9pG4ffydjAO4KAJVm0W8SUSt7XGM/WnjfvXWJte9EZs50bwoMNU
         yH50+NGge4L8Xku0WqJibPQCptOssQ8CN+mOmaxDSw0zCyL6KIQHAGO9yx/LAMM716fF
         dvgwCc26zBGeXL/VS2W+HYeCaO101XhczeiZZefaN3bdQHPRK2BDDxR28SDzN8/So1H7
         5Kmkt5k+w1P2qY65fGk/DjVSXpDm2brZ2SHTDXvncOBjmvcRQOoEqvVYbeoHen9AIrYh
         n/UqFBmGyIXlWOgu/CUsJbJDYC1Qb1MkoS1qM4ncfYzvanaVzRhN/xHOI2j/1lyydPoc
         iKLA==
X-Forwarded-Encrypted: i=1; AJvYcCUWUyK1mrMN2ejdvuvSNI1BRoLGUPFI2Lz2UZdR/iTOqgt9RQslwpZ/k+Gb56hn3+O8EFnBNeSLFw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyM6GBQEVZ5eDdqzbwIGW0qfI7LluKgDm7j8sTZqM7F1yUXJVV7
	3p0OkeL8ptvnoqHyDMt0X1CwFW8GEChUh04sy6HFIrQD17wGFg9JxpWoLqSSmlI=
X-Gm-Gg: ASbGncsK7ipgw9ImVnhhwXaNdzOUFQHG45KMynAdCtCpuIETjufWLd3peemS9HwqMk/
	5LPy/qDNb6Ch5GYNI+6tY8/5HyGaFJVS2foROUuvUhJQiXeK2zy9TfpTYQfwiUQcHlmhunk59M0
	SvpCb+6s5lr+4Z+kHRytCMDduxtHRwweCLwTRe1N+m5AECwhCq3ZleHVrpa0wxJoxr4DGQw9oFO
	IV+Foeej4uooyPqaiKBUG8XBtU0qE8GI/EgzgJl18MzGHAlgbe4GC9NHYvxd/z9ZgjnwrkNz/Ee
	/h01dB0hxpPcyEEIm1rKqNBTozr1V+qafnd577o=
X-Google-Smtp-Source: AGHT+IHcn4EEo4WPTpfgcEsDlsTsz+oaWbJGqi2HHp7v/+pSfj1SHXoJSq3noFhxaJx0MCPmKPT7ag==
X-Received: by 2002:a05:6a00:928d:b0:732:7fc1:92b with SMTP id d2e1a72fcca58-7348bdd9611mr4958392b3a.14.1740569981842;
        Wed, 26 Feb 2025 03:39:41 -0800 (PST)
Received: from localhost.localdomain ([143.92.64.17])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7347a83cd83sm3306520b3a.177.2025.02.26.03.39.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2025 03:39:41 -0800 (PST)
From: Haifeng Xu <haifeng.xu@shopee.com>
To: asml.silence@gmail.com,
	axboe@kernel.dk,
	ebiederm@xmission.com
Cc: olivier@trillion01.com,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Haifeng Xu <haifeng.xu@shopee.com>
Subject: [RFC] io_uring: fix the dead lock between io_uring and core dump
Date: Wed, 26 Feb 2025 19:39:36 +0800
Message-ID: <20250226113936.385747-1-haifeng.xu@shopee.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In our production environment, we found many hung tasks.

	Thead A (exit_mm)
	...
		if (core_state) {
		struct core_thread self;

		mmap_read_unlock(mm);

		self.task = current;
		if (self.task->flags & PF_SIGNALED)
			self.next = xchg(&core_state->dumper.next, &self);
		else
			self.task = NULL;
		/*
		 * Implies mb(), the result of xchg() must be visible
		 * to core_state->dumper.
		 */
		if (atomic_dec_and_test(&core_state->nr_threads))
			complete(&core_state->startup);

		for (;;) {
			set_current_state(TASK_UNINTERRUPTIBLE);
			if (!self.task) /* see coredump_finish() */
				break;
			freezable_schedule();
		}
		__set_current_state(TASK_RUNNING);
		mmap_read_lock(mm);
	}
	...

	Thead B (coredump_wait)
	...
		if (core_waiters > 0) {
		struct core_thread *ptr;

		freezer_do_not_count();
		wait_for_completion(&core_state->startup);
		freezer_count();
		/*
		 * Wait for all the threads to become inactive, so that
		 * all the thread context (extended register state, like
		 * fpu etc) gets copied to the memory.
		 */
		ptr = core_state->dumper.next;
		while (ptr != NULL) {
			wait_task_inactive(ptr->task, 0);
			ptr = ptr->next;
		}
	...

	Thead C (io_worker_exit)
	...
		if (refcount_dec_and_test(&worker->ref))
		complete(&worker->ref_done);
		wait_for_completion(&worker->ref_done);
	...

Thread A is waiting Thead B to finish core dump, but Thead B found that there is
still one thread which doesn't step into exit_mm() to dec core_state->nr_threads.
The thead is Thread C, it has submitted a task_work (create_worker_cb) to Thread B
and then wait Thread B to execute or cancel the work. So this causes deadlock between
io_uring and core dump.

Our kernel vesion is stable 5.15.125, and the commit 1d5f5ea7cb7d ("io-wq: remove worker to owner tw dependency")
is included. When the last io woker exits, it doesn't find any callback. Once scheduled out,
it will invoke io_wq_worker_sleeping() to submit a task work to the master thread. So the
commit 1d5f5ea7cb7d ("io-wq: remove worker to owner tw dependency") won't help in this case.

For the core dump thread, we can set a timeout to check whether the taks_work callback exists,
If needed, cancel the task_work and wake up the io worker, so the dead lock will be resolved.

Signed-off-by: Haifeng Xu <haifeng.xu@shopee.com>
---
 fs/coredump.c              |  6 ++++--
 include/linux/completion.h |  2 ++
 io_uring/io-wq.c           |  3 +--
 io_uring/io-wq.h           |  1 +
 kernel/sched/completion.c  | 11 +++++++++++
 kernel/sched/core.c        |  6 ++++++
 6 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/fs/coredump.c b/fs/coredump.c
index 591700e1b2ce..1d972d5882f0 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -42,6 +42,7 @@
 #include <linux/path.h>
 #include <linux/timekeeping.h>
 #include <linux/sysctl.h>
+#include <linux/sched/sysctl.h>
 #include <linux/elf.h>
 
 #include <linux/uaccess.h>
@@ -406,6 +407,7 @@ static int coredump_wait(int exit_code, struct core_state *core_state)
 {
 	struct task_struct *tsk = current;
 	int core_waiters = -EBUSY;
+	unsigned long hang_check = sysctl_hung_task_timeout_secs;
 
 	init_completion(&core_state->startup);
 	core_state->dumper.task = tsk;
@@ -415,8 +417,8 @@ static int coredump_wait(int exit_code, struct core_state *core_state)
 	if (core_waiters > 0) {
 		struct core_thread *ptr;
 
-		wait_for_completion_state(&core_state->startup,
-					  TASK_UNINTERRUPTIBLE|TASK_FREEZABLE);
+		wait_for_completion_state_timeout(&core_state->startup, TASK_UNINTERRUPTIBLE|TASK_FREEZABLE,
+						  hang_check * (HZ/2));
 		/*
 		 * Wait for all the threads to become inactive, so that
 		 * all the thread context (extended register state, like
diff --git a/include/linux/completion.h b/include/linux/completion.h
index fb2915676574..432de8ecc32d 100644
--- a/include/linux/completion.h
+++ b/include/linux/completion.h
@@ -104,6 +104,8 @@ extern void wait_for_completion_io(struct completion *);
 extern int wait_for_completion_interruptible(struct completion *x);
 extern int wait_for_completion_killable(struct completion *x);
 extern int wait_for_completion_state(struct completion *x, unsigned int state);
+extern int wait_for_completion_state_timeout(struct completion *x, unsigned int state,
+					     unsigned long timeout);
 extern unsigned long wait_for_completion_timeout(struct completion *x,
 						   unsigned long timeout);
 extern unsigned long wait_for_completion_io_timeout(struct completion *x,
diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index 91019b4d0308..1c03dc57a3b3 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -141,7 +141,6 @@ static bool io_acct_cancel_pending_work(struct io_wq *wq,
 					struct io_wq_acct *acct,
 					struct io_cb_cancel_data *match);
 static void create_worker_cb(struct callback_head *cb);
-static void io_wq_cancel_tw_create(struct io_wq *wq);
 
 static bool io_worker_get(struct io_worker *worker)
 {
@@ -1230,7 +1229,7 @@ void io_wq_exit_start(struct io_wq *wq)
 	set_bit(IO_WQ_BIT_EXIT, &wq->state);
 }
 
-static void io_wq_cancel_tw_create(struct io_wq *wq)
+void io_wq_cancel_tw_create(struct io_wq *wq)
 {
 	struct callback_head *cb;
 
diff --git a/io_uring/io-wq.h b/io_uring/io-wq.h
index b3b004a7b625..48ba66b5d0bd 100644
--- a/io_uring/io-wq.h
+++ b/io_uring/io-wq.h
@@ -43,6 +43,7 @@ struct io_wq_data {
 	free_work_fn *free_work;
 };
 
+void io_wq_cancel_tw_create(struct io_wq *wq);
 struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data);
 void io_wq_exit_start(struct io_wq *wq);
 void io_wq_put_and_exit(struct io_wq *wq);
diff --git a/kernel/sched/completion.c b/kernel/sched/completion.c
index 3561ab533dd4..9e7936a3cad4 100644
--- a/kernel/sched/completion.c
+++ b/kernel/sched/completion.c
@@ -269,6 +269,17 @@ int __sched wait_for_completion_state(struct completion *x, unsigned int state)
 }
 EXPORT_SYMBOL(wait_for_completion_state);
 
+int __sched wait_for_completion_state_timeout(struct completion *x, unsigned int state,
+					      unsigned long timeout)
+{
+	long t = wait_for_common(x, timeout, state);
+
+	if (t == -ERESTARTSYS)
+		return t;
+	return 0;
+}
+EXPORT_SYMBOL(wait_for_completion_state_timeout);
+
 /**
  * wait_for_completion_killable_timeout: - waits for completion of a task (w/(to,killable))
  * @x:  holds the state of this particular completion
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 9aecd914ac69..1cbe48559163 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6790,6 +6790,7 @@ static inline void sched_submit_work(struct task_struct *tsk)
 {
 	static DEFINE_WAIT_OVERRIDE_MAP(sched_map, LD_WAIT_CONFIG);
 	unsigned int task_flags;
+	struct io_uring_task *io_uring = tsk->io_uring;
 
 	/*
 	 * Establish LD_WAIT_CONFIG context to ensure none of the code called
@@ -6806,6 +6807,11 @@ static inline void sched_submit_work(struct task_struct *tsk)
 		wq_worker_sleeping(tsk);
 	else if (task_flags & PF_IO_WORKER)
 		io_wq_worker_sleeping(tsk);
+	else if ((task_flags & PF_DUMPCORE) && io_uring) {
+		struct io_wq *wq = io_uring->io_wq;
+
+		io_wq_cancel_tw_create(wq);
+	}
 
 	/*
 	 * spinlock and rwlock must not flush block requests.  This will
-- 
2.43.0


