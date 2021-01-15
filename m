Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A51072F7F06
	for <lists+io-uring@lfdr.de>; Fri, 15 Jan 2021 16:09:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731879AbhAOPIm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 Jan 2021 10:08:42 -0500
Received: from raptor.unsafe.ru ([5.9.43.93]:33422 "EHLO raptor.unsafe.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731880AbhAOPIm (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Fri, 15 Jan 2021 10:08:42 -0500
Received: from comp-core-i7-2640m-0182e6.redhat.com (ip-89-103-122-167.net.upcbroadband.cz [89.103.122.167])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by raptor.unsafe.ru (Postfix) with ESMTPSA id B17B720A1E;
        Fri, 15 Jan 2021 14:59:12 +0000 (UTC)
From:   Alexey Gladkov <gladkov.alexey@gmail.com>
To:     LKML <linux-kernel@vger.kernel.org>, io-uring@vger.kernel.org,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        linux-mm@kvack.org
Cc:     Alexey Gladkov <legion@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Jann Horn <jannh@google.com>, Jens Axboe <axboe@kernel.dk>,
        Kees Cook <keescook@chromium.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: [RFC PATCH v3 5/8] Move RLIMIT_SIGPENDING counter to ucounts
Date:   Fri, 15 Jan 2021 15:57:26 +0100
Message-Id: <cc99947c04d29821b7856770845c1191d50ff71c.1610722474.git.gladkov.alexey@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1610722473.git.gladkov.alexey@gmail.com>
References: <cover.1610722473.git.gladkov.alexey@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.1 (raptor.unsafe.ru [5.9.43.93]); Fri, 15 Jan 2021 14:59:13 +0000 (UTC)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Signed-off-by: Alexey Gladkov <gladkov.alexey@gmail.com>
---
 fs/proc/array.c                |  2 +-
 include/linux/sched/user.h     |  1 -
 include/linux/signal_types.h   |  4 ++-
 include/linux/user_namespace.h |  1 +
 kernel/fork.c                  |  1 +
 kernel/signal.c                | 53 ++++++++++++++--------------------
 kernel/ucount.c                |  1 +
 kernel/user.c                  |  1 -
 kernel/user_namespace.c        |  1 +
 9 files changed, 30 insertions(+), 35 deletions(-)

diff --git a/fs/proc/array.c b/fs/proc/array.c
index bb87e4d89cd8..74b0ea4b7e38 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -284,7 +284,7 @@ static inline void task_sig(struct seq_file *m, struct task_struct *p)
 		collect_sigign_sigcatch(p, &ignored, &caught);
 		num_threads = get_nr_threads(p);
 		rcu_read_lock();  /* FIXME: is this correct? */
-		qsize = atomic_read(&__task_cred(p)->user->sigpending);
+		qsize = get_ucounts_value(task_ucounts(p), UCOUNT_RLIMIT_SIGPENDING);
 		rcu_read_unlock();
 		qlim = task_rlimit(p, RLIMIT_SIGPENDING);
 		unlock_task_sighand(p, &flags);
diff --git a/include/linux/sched/user.h b/include/linux/sched/user.h
index 8a34446681aa..8ba9cec4fb99 100644
--- a/include/linux/sched/user.h
+++ b/include/linux/sched/user.h
@@ -12,7 +12,6 @@
  */
 struct user_struct {
 	refcount_t __count;	/* reference count */
-	atomic_t sigpending;	/* How many pending signals does this user have? */
 #ifdef CONFIG_FANOTIFY
 	atomic_t fanotify_listeners;
 #endif
diff --git a/include/linux/signal_types.h b/include/linux/signal_types.h
index 68e06c75c5b2..34cb28b8f16c 100644
--- a/include/linux/signal_types.h
+++ b/include/linux/signal_types.h
@@ -13,6 +13,8 @@ typedef struct kernel_siginfo {
 	__SIGINFO;
 } kernel_siginfo_t;
 
+struct ucounts;
+
 /*
  * Real Time signals may be queued.
  */
@@ -21,7 +23,7 @@ struct sigqueue {
 	struct list_head list;
 	int flags;
 	kernel_siginfo_t info;
-	struct user_struct *user;
+	struct ucounts *ucounts;
 };
 
 /* flags values. */
diff --git a/include/linux/user_namespace.h b/include/linux/user_namespace.h
index ff96a906d7da..852b7bc40318 100644
--- a/include/linux/user_namespace.h
+++ b/include/linux/user_namespace.h
@@ -52,6 +52,7 @@ enum ucount_type {
 #endif
 	UCOUNT_RLIMIT_NPROC,
 	UCOUNT_RLIMIT_MSGQUEUE,
+	UCOUNT_RLIMIT_SIGPENDING,
 	UCOUNT_COUNTS,
 };
 
diff --git a/kernel/fork.c b/kernel/fork.c
index f61a5a3dc02f..a7be5790392e 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -825,6 +825,7 @@ void __init fork_init(void)
 
 	init_user_ns.ucount_max[UCOUNT_RLIMIT_NPROC] = task_rlimit(&init_task, RLIMIT_NPROC);
 	init_user_ns.ucount_max[UCOUNT_RLIMIT_MSGQUEUE] = task_rlimit(&init_task, RLIMIT_MSGQUEUE);
+	init_user_ns.ucount_max[UCOUNT_RLIMIT_SIGPENDING] = task_rlimit(&init_task, RLIMIT_SIGPENDING);
 
 #ifdef CONFIG_VMAP_STACK
 	cpuhp_setup_state(CPUHP_BP_PREPARE_DYN, "fork:vm_stack_cache",
diff --git a/kernel/signal.c b/kernel/signal.c
index 5736c55aaa1a..b01c2007a282 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -412,49 +412,40 @@ void task_join_group_stop(struct task_struct *task)
 static struct sigqueue *
 __sigqueue_alloc(int sig, struct task_struct *t, gfp_t flags, int override_rlimit)
 {
-	struct sigqueue *q = NULL;
-	struct user_struct *user;
-	int sigpending;
+	struct sigqueue *q = kmem_cache_alloc(sigqueue_cachep, flags);
 
-	/*
-	 * Protect access to @t credentials. This can go away when all
-	 * callers hold rcu read lock.
-	 *
-	 * NOTE! A pending signal will hold on to the user refcount,
-	 * and we get/put the refcount only when the sigpending count
-	 * changes from/to zero.
-	 */
-	rcu_read_lock();
-	user = __task_cred(t)->user;
-	sigpending = atomic_inc_return(&user->sigpending);
-	if (sigpending == 1)
-		get_uid(user);
-	rcu_read_unlock();
+	if (likely(q != NULL)) {
+		bool overlimit;
 
-	if (override_rlimit || likely(sigpending <= task_rlimit(t, RLIMIT_SIGPENDING))) {
-		q = kmem_cache_alloc(sigqueue_cachep, flags);
-	} else {
-		print_dropped_signal(sig);
-	}
-
-	if (unlikely(q == NULL)) {
-		if (atomic_dec_and_test(&user->sigpending))
-			free_uid(user);
-	} else {
 		INIT_LIST_HEAD(&q->list);
 		q->flags = 0;
-		q->user = user;
+
+		/*
+		 * Protect access to @t credentials. This can go away when all
+		 * callers hold rcu read lock.
+		 */
+		rcu_read_lock();
+		q->ucounts = get_ucounts(task_ucounts(t));
+		overlimit = inc_rlimit_ucounts_and_test(q->ucounts, UCOUNT_RLIMIT_SIGPENDING,
+				1, task_rlimit(t, RLIMIT_SIGPENDING));
+
+		if (override_rlimit || likely(!overlimit)) {
+			rcu_read_unlock();
+			return q;
+		}
+		rcu_read_unlock();
 	}
 
-	return q;
+	print_dropped_signal(sig);
+	return NULL;
 }
 
 static void __sigqueue_free(struct sigqueue *q)
 {
 	if (q->flags & SIGQUEUE_PREALLOC)
 		return;
-	if (atomic_dec_and_test(&q->user->sigpending))
-		free_uid(q->user);
+	dec_rlimit_ucounts(q->ucounts, UCOUNT_RLIMIT_SIGPENDING, 1);
+	put_ucounts(q->ucounts);
 	kmem_cache_free(sigqueue_cachep, q);
 }
 
diff --git a/kernel/ucount.c b/kernel/ucount.c
index daeb657d4989..86f6c67ec147 100644
--- a/kernel/ucount.c
+++ b/kernel/ucount.c
@@ -75,6 +75,7 @@ static struct ctl_table user_table[] = {
 	UCOUNT_ENTRY("max_inotify_instances"),
 	UCOUNT_ENTRY("max_inotify_watches"),
 #endif
+	{ },
 	{ },
 	{ },
 	{ }
diff --git a/kernel/user.c b/kernel/user.c
index 7f5ff498207a..6737327f83be 100644
--- a/kernel/user.c
+++ b/kernel/user.c
@@ -98,7 +98,6 @@ static DEFINE_SPINLOCK(uidhash_lock);
 /* root_user.__count is 1, for init task cred */
 struct user_struct root_user = {
 	.__count	= REFCOUNT_INIT(1),
-	.sigpending	= ATOMIC_INIT(0),
 	.locked_shm     = 0,
 	.uid		= GLOBAL_ROOT_UID,
 	.ratelimit	= RATELIMIT_STATE_INIT(root_user.ratelimit, 0, 0),
diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index 9ace2a45a25d..eeff7f6d81c0 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -123,6 +123,7 @@ int create_user_ns(struct cred *new)
 	}
 	ns->ucount_max[UCOUNT_RLIMIT_NPROC] = rlimit(RLIMIT_NPROC);
 	ns->ucount_max[UCOUNT_RLIMIT_MSGQUEUE] = rlimit(RLIMIT_MSGQUEUE);
+	ns->ucount_max[UCOUNT_RLIMIT_SIGPENDING] = rlimit(RLIMIT_SIGPENDING);
 	ns->ucounts = ucounts;
 
 	/* Inherit USERNS_SETGROUPS_ALLOWED from our parent */
-- 
2.29.2

