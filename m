Return-Path: <io-uring+bounces-12621-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QDk2GcYzsGl2hAIAu9opvQ
	(envelope-from <io-uring+bounces-12621-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 10 Mar 2026 16:07:50 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0607F252E28
	for <lists+io-uring@lfdr.de>; Tue, 10 Mar 2026 16:07:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 368E6330840C
	for <lists+io-uring@lfdr.de>; Tue, 10 Mar 2026 14:57:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8151A325704;
	Tue, 10 Mar 2026 14:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YW8YpOSy"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5056C3064BA;
	Tue, 10 Mar 2026 14:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773154597; cv=none; b=hA0Z5XYRBMAMOJ/IBA3vXpbVVdMiduT/IBXtVHfxzgthVB7+/9D7xNE1KGSbtepV4jkO+D03Dp0QPgm7HWZnxXrqlnev60CsE6YN8IyU9jcXs1s4MAmdXXOsT7+KnTAfCr1J8AzG7FzEZb7DKVbmfaSVVOF2497xWYhGaf2aOp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773154597; c=relaxed/simple;
	bh=QoaJCBj1s9g/xyFIAyObrXd6nrQ2gvM8T6BHB0KJ80I=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=RIw/2+rncFWqcywVvLZ9TarMsJdtZs+0ldxTGLZ41kexX/Jpt95WDpeXXTyJYgh6fkaSW10RJxW+gnYgSoZSrlbwcyzMThxHjaXFc9w9o11O0vlfU/gJamWZNTcGV3TGaEROFyMfcxz6hkvHr+r7AC5Z4LpPjE7MmiXO4+S5+Ck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YW8YpOSy; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71128C19425;
	Tue, 10 Mar 2026 14:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773154596;
	bh=QoaJCBj1s9g/xyFIAyObrXd6nrQ2gvM8T6BHB0KJ80I=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=YW8YpOSyhe9sEg81UOmuFrfMdCa9oqYGJeGRUujdbkfg5ST+LwiA57l3KC+4UHgpS
	 0m7XFH6UcGFIoI9ZTmGmh/djNyMGCcMT2tcmy4kCQ//x+fSPvTsrxvdVe834m1qYp4
	 1a2hRJeX/MDTzgri8GsFfof6sZQujVMEOCMs/15pZJlpi/UiElMLVaj1fL4HOKNAVb
	 0+3dEuErIj+t/e7ynCk7dVRd2A59tFf9TYFxsG1DU8J9fMSZVd6vL+Dd71tuR3jc+O
	 lNu+wSnEB8SljhQiQjQBwlMBnWAdp635rBQ2l+Dh/YHxlecRmvbx7WRsTB8eVL+fMT
	 FSjeJUK5n7Dzg==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 10 Mar 2026 15:56:10 +0100
Subject: [PATCH v2 2/2] tree-wide: rename do_exit() to task_exit()
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260310-work-kernel-exit-v2-2-30711759d87b@kernel.org>
References: <20260310-work-kernel-exit-v2-0-30711759d87b@kernel.org>
In-Reply-To: <20260310-work-kernel-exit-v2-0-30711759d87b@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-modules@vger.kernel.org, 
 linux-nfs@vger.kernel.org, bpf@vger.kernel.org, kunit-dev@googlegroups.com, 
 linux-doc@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
 netfs@lists.linux.dev, io-uring@vger.kernel.org, audit@vger.kernel.org, 
 rcu@vger.kernel.org, kvm@vger.kernel.org, virtualization@lists.linux.dev, 
 netdev@vger.kernel.org, linux-mm@kvack.org, 
 linux-security-module@vger.kernel.org, 
 Christian Loehle <christian.loehle@arm.com>, linux-fsdevel@vger.kernel.org, 
 Christian Brauner <brauner@kernel.org>
X-Mailer: b4 0.15-dev-9fd7c
X-Developer-Signature: v=1; a=openpgp-sha256; l=28821; i=brauner@kernel.org;
 h=from:subject:message-id; bh=QoaJCBj1s9g/xyFIAyObrXd6nrQ2gvM8T6BHB0KJ80I=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWRuMBRbL/ekVEZSePtOuYpdLs3O7xJ5xWQcY1d1rXd98
 YY/O4O1o5SFQYyLQVZMkcWh3SRcbjlPxWajTA2YOaxMIEMYuDgFYCI7nzMyHGOd6iEpzPo98a/c
 xeg0yWu1Md0/bVtFgtKNGp8FCH95zfBXuNAsTmCNeM/yXZWObe3aKw5vP7bvaNS5tBlpWpf9dA7
 wAwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Queue-Id: 0607F252E28
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12621-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[20];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[brauner@kernel.org,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

Rename do_exit() to task_exit() so it's clear that this is an api and
not a hidden internal helper.

Signed-off-by: Christian Brauner <brauner@kernel.org>
---
 Documentation/accounting/taskstats-struct.rst                |  2 +-
 Documentation/locking/robust-futexes.rst                     |  8 ++++----
 Documentation/trace/kprobes.rst                              |  2 +-
 fs/cachefiles/namei.c                                        |  2 +-
 include/linux/kernel.h                                       |  2 +-
 include/linux/module.h                                       |  2 +-
 include/linux/sunrpc/svc.h                                   |  2 +-
 io_uring/io-wq.c                                             |  2 +-
 io_uring/sqpoll.c                                            |  2 +-
 kernel/acct.c                                                |  2 +-
 kernel/auditsc.c                                             |  4 ++--
 kernel/bpf/verifier.c                                        |  2 +-
 kernel/exit.c                                                | 10 +++++-----
 kernel/futex/futex.h                                         |  2 +-
 kernel/futex/pi.c                                            |  2 +-
 kernel/futex/syscalls.c                                      |  2 +-
 kernel/kthread.c                                             |  8 ++++----
 kernel/locking/rwsem.c                                       |  2 +-
 kernel/module/main.c                                         |  2 +-
 kernel/pid_namespace.c                                       |  2 +-
 kernel/rcu/tasks.h                                           | 12 ++++++------
 kernel/reboot.c                                              |  6 +++---
 kernel/seccomp.c                                             |  8 ++++----
 kernel/signal.c                                              |  4 ++--
 kernel/time/posix-timers.c                                   |  2 +-
 kernel/umh.c                                                 |  2 +-
 kernel/vhost_task.c                                          |  2 +-
 lib/kunit/try-catch.c                                        |  2 +-
 mm/hugetlb.c                                                 |  2 +-
 security/tomoyo/gc.c                                         |  2 +-
 tools/objtool/noreturns.h                                    |  2 +-
 tools/testing/selftests/bpf/prog_tests/tracing_failure.c     |  2 +-
 tools/testing/selftests/bpf/progs/tracing_failure.c          |  2 +-
 .../selftests/ftrace/test.d/dynevent/fprobe_syntax_errors.tc |  2 +-
 .../selftests/ftrace/test.d/kprobe/kprobe_multiprobe.tc      |  2 +-
 .../selftests/ftrace/test.d/kprobe/kprobe_syntax_errors.tc   |  2 +-
 36 files changed, 58 insertions(+), 58 deletions(-)

diff --git a/Documentation/accounting/taskstats-struct.rst b/Documentation/accounting/taskstats-struct.rst
index acca51c34157..a09ec032da81 100644
--- a/Documentation/accounting/taskstats-struct.rst
+++ b/Documentation/accounting/taskstats-struct.rst
@@ -9,7 +9,7 @@ There are three different groups of fields in the struct taskstats:
 1) Common and basic accounting fields
     If CONFIG_TASKSTATS is set, the taskstats interface is enabled and
     the common fields and basic accounting fields are collected for
-    delivery at do_exit() of a task.
+    delivery at task_exit() of a task.
 2) Delay accounting fields
     These fields are placed between::
 
diff --git a/Documentation/locking/robust-futexes.rst b/Documentation/locking/robust-futexes.rst
index 6361fb01c9c1..c10a2fabf3f9 100644
--- a/Documentation/locking/robust-futexes.rst
+++ b/Documentation/locking/robust-futexes.rst
@@ -55,7 +55,7 @@ To solve this problem, the traditional approach was to extend the vma
 (virtual memory area descriptor) concept to have a notion of 'pending
 robust futexes attached to this area'. This approach requires 3 new
 syscall variants to sys_futex(): FUTEX_REGISTER, FUTEX_DEREGISTER and
-FUTEX_RECOVER. At do_exit() time, all vmas are searched to see whether
+FUTEX_RECOVER. At task_exit() time, all vmas are searched to see whether
 they have a robust_head set. This approach has two fundamental problems
 left:
 
@@ -89,11 +89,11 @@ New approach to robust futexes
 At the heart of this new approach there is a per-thread private list of
 robust locks that userspace is holding (maintained by glibc) - which
 userspace list is registered with the kernel via a new syscall [this
-registration happens at most once per thread lifetime]. At do_exit()
+registration happens at most once per thread lifetime]. At task_exit()
 time, the kernel checks this user-space list: are there any robust futex
 locks to be cleaned up?
 
-In the common case, at do_exit() time, there is no list registered, so
+In the common case, at task_exit() time, there is no list registered, so
 the cost of robust futexes is just a simple current->robust_list != NULL
 comparison. If the thread has registered a list, then normally the list
 is empty. If the thread/process crashed or terminated in some incorrect
@@ -102,7 +102,7 @@ walks the list [not trusting it], and marks all locks that are owned by
 this thread with the FUTEX_OWNER_DIED bit, and wakes up one waiter (if
 any).
 
-The list is guaranteed to be private and per-thread at do_exit() time,
+The list is guaranteed to be private and per-thread at task_exit() time,
 so it can be accessed by the kernel in a lockless way.
 
 There is one race possible though: since adding to and removing from the
diff --git a/Documentation/trace/kprobes.rst b/Documentation/trace/kprobes.rst
index 5e606730cec6..ca9c22588dff 100644
--- a/Documentation/trace/kprobes.rst
+++ b/Documentation/trace/kprobes.rst
@@ -593,7 +593,7 @@ produce undesirable results. In such a case, a line:
 kretprobe BUG!: Processing kretprobe d000000000041aa8 @ c00000000004f48c
 gets printed. With this information, one will be able to correlate the
 exact instance of the kretprobe that caused the problem. We have the
-do_exit() case covered. do_execve() and do_fork() are not an issue.
+task_exit() case covered. do_execve() and do_fork() are not an issue.
 We're unaware of other specific cases where this could be a problem.
 
 If, upon entry to or exit from a function, the CPU is running on
diff --git a/fs/cachefiles/namei.c b/fs/cachefiles/namei.c
index e5ec90dccc27..803657450f6b 100644
--- a/fs/cachefiles/namei.c
+++ b/fs/cachefiles/namei.c
@@ -555,7 +555,7 @@ static bool cachefiles_open_file(struct cachefiles_object *object,
 	}
 
 	/* We need to open a file interface onto a data file now as we can't do
-	 * it on demand because writeback called from do_exit() sees
+	 * it on demand because writeback called from task_exit() sees
 	 * current->fs == NULL - which breaks d_path() called from ext4 open.
 	 */
 	path.mnt = cache->mnt;
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index e5570a16cbb1..91ce3abd65ad 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -148,7 +148,7 @@ void __might_fault(const char *file, int line);
 static inline void might_fault(void) { }
 #endif
 
-void do_exit(long error_code) __noreturn;
+void task_exit(long error_code) __noreturn;
 
 extern int core_kernel_text(unsigned long addr);
 extern int __kernel_text_address(unsigned long addr);
diff --git a/include/linux/module.h b/include/linux/module.h
index 79ac4a700b39..61254c7af4b8 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -855,7 +855,7 @@ static inline int unregister_module_notifier(struct notifier_block *nb)
 	return 0;
 }
 
-#define module_put_and_kthread_exit(code) do_exit(code)
+#define module_put_and_kthread_exit(code) task_exit(code)
 
 static inline void print_modules(void)
 {
diff --git a/include/linux/sunrpc/svc.h b/include/linux/sunrpc/svc.h
index c86fc8a87eae..41cc1a8bfc95 100644
--- a/include/linux/sunrpc/svc.h
+++ b/include/linux/sunrpc/svc.h
@@ -338,7 +338,7 @@ static inline void svc_thread_init_status(struct svc_rqst *rqstp, int err)
 {
 	store_release_wake_up(&rqstp->rq_err, err);
 	if (err)
-		do_exit(1);
+		task_exit(1);
 }
 
 struct svc_deferred_req {
diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index 7a9f94a0ce6f..6befba7b9473 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -261,7 +261,7 @@ static void io_worker_exit(struct io_worker *worker)
 
 	kfree_rcu(worker, rcu);
 	io_worker_ref_put(wq);
-	do_exit(0);
+	task_exit(0);
 }
 
 static inline bool __io_acct_run_queue(struct io_wq_acct *acct)
diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
index c6bb938ec5ea..b7968a0aa748 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -423,7 +423,7 @@ static int io_sq_thread(void *data)
 	mutex_unlock(&sqd->lock);
 err_out:
 	complete(&sqd->exited);
-	do_exit(0);
+	task_exit(0);
 }
 
 void io_sqpoll_wait_sq(struct io_ring_ctx *ctx)
diff --git a/kernel/acct.c b/kernel/acct.c
index 1e19722c64c3..0c9a2280b1ff 100644
--- a/kernel/acct.c
+++ b/kernel/acct.c
@@ -424,7 +424,7 @@ static u32 encode_float(u64 value)
  *  The acct_process() call is the workhorse of the process
  *  accounting system. The struct acct is built here and then written
  *  into the accounting file. This function should only be called from
- *  do_exit() or when switching to a different output file.
+ *  task_exit() or when switching to a different output file.
  */
 
 static void fill_ac(struct bsd_acct_struct *acct)
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index f6af6a8f68c4..921acd5c8e77 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -1797,7 +1797,7 @@ static void audit_log_exit(void)
  * __audit_free - free a per-task audit context
  * @tsk: task whose audit context block to free
  *
- * Called from copy_process, do_exit, and the io_uring code
+ * Called from copy_process, task_exit, and the io_uring code
  */
 void __audit_free(struct task_struct *tsk)
 {
@@ -1810,7 +1810,7 @@ void __audit_free(struct task_struct *tsk)
 	if (!list_empty(&context->killed_trees))
 		audit_kill_trees(context);
 
-	/* We are called either by do_exit() or the fork() error handling code;
+	/* We are called either by task_exit() or the fork() error handling code;
 	 * in the former case tsk == current and in the latter tsk is a
 	 * random task_struct that doesn't have any meaningful data we
 	 * need to log via audit_log_exit().
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 159b25f8269d..4dff24eb86b0 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -25289,10 +25289,10 @@ BTF_ID(func, __module_put_and_kthread_exit)
 BTF_ID(func, __x64_sys_exit)
 BTF_ID(func, __x64_sys_exit_group)
 #endif
-BTF_ID(func, do_exit)
 BTF_ID(func, do_group_exit)
 BTF_ID(func, kthread_complete_and_exit)
 BTF_ID(func, make_task_dead)
+BTF_ID(func, task_exit)
 BTF_SET_END(noreturn_deny)
 
 static bool can_be_sleepable(struct bpf_prog *prog)
diff --git a/kernel/exit.c b/kernel/exit.c
index ede3117fa7d4..6c5c0968da14 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -893,7 +893,7 @@ static void synchronize_group_exit(struct task_struct *tsk, long code)
 		coredump_task_exit(tsk, core_state);
 }
 
-void __noreturn do_exit(long code)
+void __noreturn task_exit(long code)
 {
 	struct task_struct *tsk = current;
 	struct kthread *kthread;
@@ -1018,7 +1018,7 @@ void __noreturn do_exit(long code)
 	lockdep_free_task(tsk);
 	do_task_dead();
 }
-EXPORT_SYMBOL(do_exit);
+EXPORT_SYMBOL(task_exit);
 
 void __noreturn make_task_dead(int signr)
 {
@@ -1077,12 +1077,12 @@ void __noreturn make_task_dead(int signr)
 		do_task_dead();
 	}
 
-	do_exit(signr);
+	task_exit(signr);
 }
 
 SYSCALL_DEFINE1(exit, int, error_code)
 {
-	do_exit((error_code&0xff)<<8);
+	task_exit((error_code&0xff)<<8);
 }
 
 /*
@@ -1115,7 +1115,7 @@ do_group_exit(int exit_code)
 		spin_unlock_irq(&sighand->siglock);
 	}
 
-	do_exit(exit_code);
+	task_exit(exit_code);
 	/* NOTREACHED */
 }
 
diff --git a/kernel/futex/futex.h b/kernel/futex/futex.h
index 30c2afa03889..00fb2fc6579c 100644
--- a/kernel/futex/futex.h
+++ b/kernel/futex/futex.h
@@ -144,7 +144,7 @@ struct futex_hash_bucket {
 struct futex_pi_state {
 	/*
 	 * list of 'owned' pi_state instances - these have to be
-	 * cleaned up in do_exit() if the task exits prematurely:
+	 * cleaned up in task_exit() if the task exits prematurely:
 	 */
 	struct list_head list;
 
diff --git a/kernel/futex/pi.c b/kernel/futex/pi.c
index bc1f7e83a37e..735b117574af 100644
--- a/kernel/futex/pi.c
+++ b/kernel/futex/pi.c
@@ -336,7 +336,7 @@ static int handle_exit_race(u32 __user *uaddr, u32 uval,
 	 * CPU0				CPU1
 	 *
 	 * sys_exit()			sys_futex()
-	 *  do_exit()			 futex_lock_pi()
+	 *  task_exit()			 futex_lock_pi()
 	 *                                futex_lock_pi_atomic()
 	 *   exit_signals(tsk)		    No waiters:
 	 *    tsk->flags |= PF_EXITING;	    *uaddr == 0x00000PID
diff --git a/kernel/futex/syscalls.c b/kernel/futex/syscalls.c
index 743c7a728237..0ab5af6b9caf 100644
--- a/kernel/futex/syscalls.c
+++ b/kernel/futex/syscalls.c
@@ -10,7 +10,7 @@
  * thread exit time.
  *
  * Implementation: user-space maintains a per-thread list of locks it
- * is holding. Upon do_exit(), the kernel carefully walks this list,
+ * is holding. Upon task_exit(), the kernel carefully walks this list,
  * and marks all locks that are owned by this thread with the
  * FUTEX_OWNER_DIED bit, and wakes up a waiter (if any). The list is
  * always manipulated with the lock held, so the list is private and
diff --git a/kernel/kthread.c b/kernel/kthread.c
index 1447c14c8540..e3d456e8d1e4 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -323,7 +323,7 @@ void __noreturn kthread_complete_and_exit(struct completion *comp, long code)
 	if (comp)
 		complete(comp);
 
-	do_exit(code);
+	task_exit(code);
 }
 EXPORT_SYMBOL(kthread_complete_and_exit);
 
@@ -395,7 +395,7 @@ static int kthread(void *_create)
 	if (!done) {
 		kfree(create->full_name);
 		kfree(create);
-		do_exit(-EINTR);
+		task_exit(-EINTR);
 	}
 
 	self->full_name = create->full_name;
@@ -435,7 +435,7 @@ static int kthread(void *_create)
 		__kthread_parkme(self);
 		ret = threadfn(data);
 	}
-	do_exit(ret);
+	task_exit(ret);
 }
 
 /* called from kernel_clone() to get node information for about to be created task */
@@ -738,7 +738,7 @@ EXPORT_SYMBOL_GPL(kthread_park);
  * instead of calling wake_up_process(): the thread will exit without
  * calling threadfn().
  *
- * If threadfn() may call do_exit() itself, the caller must ensure
+ * If threadfn() may call task_exit() itself, the caller must ensure
  * task_struct can't go away.
  *
  * Returns the result of threadfn(), or %-EINTR if wake_up_process()
diff --git a/kernel/locking/rwsem.c b/kernel/locking/rwsem.c
index 24df4d98f7d2..390170de66af 100644
--- a/kernel/locking/rwsem.c
+++ b/kernel/locking/rwsem.c
@@ -554,7 +554,7 @@ static void rwsem_mark_wake(struct rw_semaphore *sem,
 		/*
 		 * Ensure calling get_task_struct() before setting the reader
 		 * waiter to nil such that rwsem_down_read_slowpath() cannot
-		 * race with do_exit() by always holding a reference count
+		 * race with task_exit() by always holding a reference count
 		 * to the task to wakeup.
 		 */
 		smp_store_release(&waiter->task, NULL);
diff --git a/kernel/module/main.c b/kernel/module/main.c
index 340b4dc5c692..a06b6cc7402f 100644
--- a/kernel/module/main.c
+++ b/kernel/module/main.c
@@ -228,7 +228,7 @@ static int mod_strncmp(const char *str_a, const char *str_b, size_t n)
 void __noreturn __module_put_and_kthread_exit(struct module *mod, long code)
 {
 	module_put(mod);
-	do_exit(code);
+	task_exit(code);
 }
 EXPORT_SYMBOL(__module_put_and_kthread_exit);
 
diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
index e48f5de41361..ef84e15530f3 100644
--- a/kernel/pid_namespace.c
+++ b/kernel/pid_namespace.c
@@ -339,7 +339,7 @@ int reboot_pid_ns(struct pid_namespace *pid_ns, int cmd)
 	send_sig(SIGKILL, pid_ns->child_reaper, 1);
 	read_unlock(&tasklist_lock);
 
-	do_exit(0);
+	task_exit(0);
 
 	/* Not reached */
 	return 0;
diff --git a/kernel/rcu/tasks.h b/kernel/rcu/tasks.h
index 2b55e6acf3c1..657770e8b1cc 100644
--- a/kernel/rcu/tasks.h
+++ b/kernel/rcu/tasks.h
@@ -32,7 +32,7 @@ typedef void (*postgp_func_t)(struct rcu_tasks *rtp);
  * @rtp_irq_work: IRQ work queue for deferred wakeups.
  * @barrier_q_head: RCU callback for barrier operation.
  * @rtp_blkd_tasks: List of tasks blocked as readers.
- * @rtp_exit_list: List of tasks in the latter portion of do_exit().
+ * @rtp_exit_list: List of tasks in the latter portion of task_exit().
  * @cpu: CPU number corresponding to this entry.
  * @index: Index of this CPU in rtpcp_array of the rcu_tasks structure.
  * @rtpp: Pointer to the rcu_tasks structure.
@@ -922,12 +922,12 @@ static void rcu_tasks_wait_gp(struct rcu_tasks *rtp)
 //	number of voluntary context switches, and add that task to the
 //	holdout list.
 // rcu_tasks_postscan():
-//	Gather per-CPU lists of tasks in do_exit() to ensure that all
+//	Gather per-CPU lists of tasks in task_exit() to ensure that all
 //	tasks that were in the process of exiting (and which thus might
 //	not know to synchronize with this RCU Tasks grace period) have
 //	completed exiting.  The synchronize_rcu() in rcu_tasks_postgp()
 //	will take care of any tasks stuck in the non-preemptible region
-//	of do_exit() following its call to exit_tasks_rcu_finish().
+//	of task_exit() following its call to exit_tasks_rcu_finish().
 // check_all_holdout_tasks(), repeatedly until holdout list is empty:
 //	Scans the holdout list, attempting to identify a quiescent state
 //	for each task on the list.  If there is a quiescent state, the
@@ -1038,10 +1038,10 @@ static void rcu_tasks_postscan(struct list_head *hop)
 	 *
 	 * 1) A task_struct list addition before calling exit_notify(),
 	 *    which may remove the task from the tasklist, with the
-	 *    removal after the final preempt_disable() call in do_exit().
+	 *    removal after the final preempt_disable() call in task_exit().
 	 *
 	 * 2) An _RCU_ read side starting with the final preempt_disable()
-	 *    call in do_exit() and ending with the final call to schedule()
+	 *    call in task_exit() and ending with the final call to schedule()
 	 *    with TASK_DEAD state.
 	 *
 	 * This handles the part 1). And postgp will handle part 2) with a
@@ -1301,7 +1301,7 @@ void exit_tasks_rcu_start(void)
 }
 
 /*
- * Remove the task from the "yet another list" because do_exit() is now
+ * Remove the task from the "yet another list" because task_exit() is now
  * non-preemptible, allowing synchronize_rcu() to wait beyond this point.
  */
 void exit_tasks_rcu_finish(void)
diff --git a/kernel/reboot.c b/kernel/reboot.c
index 695c33e75efd..ceaf725bb423 100644
--- a/kernel/reboot.c
+++ b/kernel/reboot.c
@@ -747,7 +747,7 @@ SYSCALL_DEFINE4(reboot, int, magic1, int, magic2, unsigned int, cmd,
 	/*
 	 * If pid namespaces are enabled and the current task is in a child
 	 * pid_namespace, the command is handled by reboot_pid_ns() which will
-	 * call do_exit().
+	 * call task_exit().
 	 */
 	ret = reboot_pid_ns(pid_ns, cmd);
 	if (ret)
@@ -777,11 +777,11 @@ SYSCALL_DEFINE4(reboot, int, magic1, int, magic2, unsigned int, cmd,
 
 	case LINUX_REBOOT_CMD_HALT:
 		kernel_halt();
-		do_exit(0);
+		task_exit(0);
 
 	case LINUX_REBOOT_CMD_POWER_OFF:
 		kernel_power_off();
-		do_exit(0);
+		task_exit(0);
 		break;
 
 	case LINUX_REBOOT_CMD_RESTART2:
diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index 066909393c38..f55d1c242e41 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -1081,7 +1081,7 @@ static void __secure_computing_strict(int this_syscall)
 #endif
 	current->seccomp.mode = SECCOMP_MODE_DEAD;
 	seccomp_log(this_syscall, SIGKILL, SECCOMP_RET_KILL_THREAD, true);
-	do_exit(SIGKILL);
+	task_exit(SIGKILL);
 }
 
 #ifndef CONFIG_HAVE_ARCH_SECCOMP_FILTER
@@ -1365,7 +1365,7 @@ static int __seccomp_filter(int this_syscall, const bool recheck_after_trace)
 			/* Trigger a coredump with SIGSYS */
 			force_sig_seccomp(this_syscall, data, true);
 		} else {
-			do_exit(SIGSYS);
+			task_exit(SIGSYS);
 		}
 		return -1; /* skip the syscall go directly to signal handling */
 	}
@@ -1398,14 +1398,14 @@ int __secure_computing(void)
 
 	switch (mode) {
 	case SECCOMP_MODE_STRICT:
-		__secure_computing_strict(this_syscall);  /* may call do_exit */
+		__secure_computing_strict(this_syscall);  /* may call task_exit */
 		return 0;
 	case SECCOMP_MODE_FILTER:
 		return __seccomp_filter(this_syscall, false);
 	/* Surviving SECCOMP_RET_KILL_* must be proactively impossible. */
 	case SECCOMP_MODE_DEAD:
 		WARN_ON_ONCE(1);
-		do_exit(SIGKILL);
+		task_exit(SIGKILL);
 		return -1;
 	default:
 		BUG();
diff --git a/kernel/signal.c b/kernel/signal.c
index d65d0fe24bfb..675f222074e1 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2238,7 +2238,7 @@ bool do_notify_parent(struct task_struct *tsk, int sig)
 		 * or setting the SA_NOCLDWAIT flag: we should be reaped
 		 * automatically and not left for our parent's wait4 call.
 		 * Rather than having the parent do it as a magic kind of
-		 * signal handler, we just set this to tell do_exit that we
+		 * signal handler, we just set this to tell task_exit that we
 		 * can be cleaned up without becoming a zombie.  Note that
 		 * we still call __wake_up_parent in this case, because a
 		 * blocked sys_wait4 might now return -ECHILD.
@@ -3022,7 +3022,7 @@ bool get_signal(struct ksignal *ksig)
 		/*
 		 * PF_USER_WORKER threads will catch and exit on fatal signals
 		 * themselves. They have cleanup that must be performed, so we
-		 * cannot call do_exit() on their behalf. Note that ksig won't
+		 * cannot call task_exit() on their behalf. Note that ksig won't
 		 * be properly initialized, PF_USER_WORKER's shouldn't use it.
 		 */
 		if (current->flags & PF_USER_WORKER)
diff --git a/kernel/time/posix-timers.c b/kernel/time/posix-timers.c
index 413e2389f0a5..08657975d714 100644
--- a/kernel/time/posix-timers.c
+++ b/kernel/time/posix-timers.c
@@ -1063,7 +1063,7 @@ SYSCALL_DEFINE1(timer_delete, timer_t, timer_id)
 }
 
 /*
- * Invoked from do_exit() when the last thread of a thread group exits.
+ * Invoked from task_exit() when the last thread of a thread group exits.
  * At that point no other task can access the timers of the dying
  * task anymore.
  */
diff --git a/kernel/umh.c b/kernel/umh.c
index cffda97d961c..69ee75ca9340 100644
--- a/kernel/umh.c
+++ b/kernel/umh.c
@@ -119,7 +119,7 @@ static int call_usermodehelper_exec_async(void *data)
 		umh_complete(sub_info);
 	if (!retval)
 		return 0;
-	do_exit(0);
+	task_exit(0);
 }
 
 /* Handles UMH_WAIT_PROC.  */
diff --git a/kernel/vhost_task.c b/kernel/vhost_task.c
index 3f1ed7ef0582..554ec8fe7f5a 100644
--- a/kernel/vhost_task.c
+++ b/kernel/vhost_task.c
@@ -64,7 +64,7 @@ static int vhost_task_fn(void *data)
 	mutex_unlock(&vtsk->exit_mutex);
 	complete(&vtsk->exited);
 
-	do_exit(0);
+	task_exit(0);
 }
 
 /**
diff --git a/lib/kunit/try-catch.c b/lib/kunit/try-catch.c
index 99d9603a2cfd..e5de71d68ef4 100644
--- a/lib/kunit/try-catch.c
+++ b/lib/kunit/try-catch.c
@@ -18,7 +18,7 @@
 void __noreturn kunit_try_catch_throw(struct kunit_try_catch *try_catch)
 {
 	try_catch->try_result = -EFAULT;
-	do_exit(0);
+	task_exit(0);
 }
 EXPORT_SYMBOL_GPL(kunit_try_catch_throw);
 
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 0beb6e22bc26..a7ca30d533e7 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5294,7 +5294,7 @@ void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		 * Adjust the reservation for the region that will have the
 		 * reserve restored. Keep in mind that vma_needs_reservation() changes
 		 * resv->adds_in_progress if it succeeds. If this is not done,
-		 * do_exit() will not see it, and will keep the reservation
+		 * task_exit() will not see it, and will keep the reservation
 		 * forever.
 		 */
 		if (adjust_reservation) {
diff --git a/security/tomoyo/gc.c b/security/tomoyo/gc.c
index 8e2008863af8..e0b72661d6bf 100644
--- a/security/tomoyo/gc.c
+++ b/security/tomoyo/gc.c
@@ -640,7 +640,7 @@ static int tomoyo_gc_thread(void *unused)
 	}
 	mutex_unlock(&tomoyo_gc_mutex);
 out:
-	/* This acts as do_exit(0). */
+	/* This acts as task_exit(0). */
 	return 0;
 }
 
diff --git a/tools/objtool/noreturns.h b/tools/objtool/noreturns.h
index 40c0b05c6726..48fc90f30769 100644
--- a/tools/objtool/noreturns.h
+++ b/tools/objtool/noreturns.h
@@ -23,7 +23,6 @@ NORETURN(bch2_trans_restart_error)
 NORETURN(bch2_trans_unlocked_or_in_restart_error)
 NORETURN(cpu_bringup_and_idle)
 NORETURN(cpu_startup_entry)
-NORETURN(do_exit)
 NORETURN(do_group_exit)
 NORETURN(do_task_dead)
 NORETURN(ex_handler_msr_mce)
@@ -47,6 +46,7 @@ NORETURN(rust_helper_BUG)
 NORETURN(sev_es_terminate)
 NORETURN(start_kernel)
 NORETURN(stop_this_cpu)
+NORETURN(task_exit)
 NORETURN(usercopy_abort)
 NORETURN(x86_64_start_kernel)
 NORETURN(x86_64_start_reservations)
diff --git a/tools/testing/selftests/bpf/prog_tests/tracing_failure.c b/tools/testing/selftests/bpf/prog_tests/tracing_failure.c
index f9f9e1cb87bf..1a97e71fd68d 100644
--- a/tools/testing/selftests/bpf/prog_tests/tracing_failure.c
+++ b/tools/testing/selftests/bpf/prog_tests/tracing_failure.c
@@ -73,7 +73,7 @@ static void test_tracing_deny(void)
 static void test_fexit_noreturns(void)
 {
 	test_tracing_fail_prog("fexit_noreturns",
-			       "Attaching fexit/fsession/fmod_ret to __noreturn function 'do_exit' is rejected.");
+			       "Attaching fexit/fsession/fmod_ret to __noreturn function 'task_exit' is rejected.");
 }
 
 void test_tracing_failure(void)
diff --git a/tools/testing/selftests/bpf/progs/tracing_failure.c b/tools/testing/selftests/bpf/progs/tracing_failure.c
index 65e485c4468c..5144f4cc5787 100644
--- a/tools/testing/selftests/bpf/progs/tracing_failure.c
+++ b/tools/testing/selftests/bpf/progs/tracing_failure.c
@@ -25,7 +25,7 @@ int BPF_PROG(tracing_deny)
 	return 0;
 }
 
-SEC("?fexit/do_exit")
+SEC("?fexit/task_exit")
 int BPF_PROG(fexit_noreturns)
 {
 	return 0;
diff --git a/tools/testing/selftests/ftrace/test.d/dynevent/fprobe_syntax_errors.tc b/tools/testing/selftests/ftrace/test.d/dynevent/fprobe_syntax_errors.tc
index fee479295e2f..7e00d8ecd110 100644
--- a/tools/testing/selftests/ftrace/test.d/dynevent/fprobe_syntax_errors.tc
+++ b/tools/testing/selftests/ftrace/test.d/dynevent/fprobe_syntax_errors.tc
@@ -82,7 +82,7 @@ check_error 'f vfs_read arg1=^'			# NO_ARG_BODY
 # multiprobe errors
 if grep -q "Create/append/" README && grep -q "imm-value" README; then
 echo "f:fprobes/testevent $FUNCTION_FORK" > dynamic_events
-check_error '^f:fprobes/testevent do_exit%return'	# DIFF_PROBE_TYPE
+check_error '^f:fprobes/testevent task_exit%return'	# DIFF_PROBE_TYPE
 
 # Explicitly use printf "%s" to not interpret \1
 printf "%s" "f:fprobes/testevent $FUNCTION_FORK abcd=\\1" > dynamic_events
diff --git a/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_multiprobe.tc b/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_multiprobe.tc
index f0d5b7777ed7..a95e3824690a 100644
--- a/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_multiprobe.tc
+++ b/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_multiprobe.tc
@@ -5,7 +5,7 @@
 
 # Choose 2 symbols for target
 SYM1=$FUNCTION_FORK
-SYM2=do_exit
+SYM2=task_exit
 EVENT_NAME=kprobes/testevent
 
 DEF1="p:$EVENT_NAME $SYM1"
diff --git a/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_syntax_errors.tc b/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_syntax_errors.tc
index 8f1c58f0c239..b55ea3c05cfa 100644
--- a/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_syntax_errors.tc
+++ b/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_syntax_errors.tc
@@ -87,7 +87,7 @@ esac
 # multiprobe errors
 if grep -q "Create/append/" README && grep -q "imm-value" README; then
 echo "p:kprobes/testevent $FUNCTION_FORK" > kprobe_events
-check_error '^r:kprobes/testevent do_exit'	# DIFF_PROBE_TYPE
+check_error '^r:kprobes/testevent task_exit'	# DIFF_PROBE_TYPE
 
 # Explicitly use printf "%s" to not interpret \1
 printf "%s" "p:kprobes/testevent $FUNCTION_FORK abcd=\\1" > kprobe_events

-- 
2.47.3


