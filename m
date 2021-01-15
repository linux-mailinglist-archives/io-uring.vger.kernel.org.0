Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C9AB2F7F08
	for <lists+io-uring@lfdr.de>; Fri, 15 Jan 2021 16:09:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730505AbhAOPIm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 Jan 2021 10:08:42 -0500
Received: from raptor.unsafe.ru ([5.9.43.93]:33428 "EHLO raptor.unsafe.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731683AbhAOPIm (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Fri, 15 Jan 2021 10:08:42 -0500
Received: from comp-core-i7-2640m-0182e6.redhat.com (ip-89-103-122-167.net.upcbroadband.cz [89.103.122.167])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by raptor.unsafe.ru (Postfix) with ESMTPSA id 9EFD420A18;
        Fri, 15 Jan 2021 14:59:11 +0000 (UTC)
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
Subject: [RFC PATCH v3 3/8] Move RLIMIT_NPROC counter to ucounts
Date:   Fri, 15 Jan 2021 15:57:24 +0100
Message-Id: <eea77b250695e05cb0d440d0a9fa203a2b86a643.1610722474.git.gladkov.alexey@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1610722473.git.gladkov.alexey@gmail.com>
References: <cover.1610722473.git.gladkov.alexey@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.1 (raptor.unsafe.ru [5.9.43.93]); Fri, 15 Jan 2021 14:59:12 +0000 (UTC)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

RLIMIT_NPROC is implemented on top of ucounts. The process counter is
tied to the user in the user namespace. Therefore, there is no longer
one single counter for the user. Instead, there is now one counter for
each user namespace. Thus, getting the RLIMIT_NPROC counter value to
check the rlimit becomes meaningless.

We cannot use existing inc_ucounts / dec_ucounts because they do not
allow us to exceed the maximum for the counter. Some rlimits can be
overlimited if the user has the appropriate capability.

Signed-off-by: Alexey Gladkov <gladkov.alexey@gmail.com>
---
 fs/exec.c                      |  2 +-
 fs/io-wq.c                     | 22 ++++++-------
 fs/io-wq.h                     |  2 +-
 fs/io_uring.c                  |  2 +-
 include/linux/cred.h           |  2 ++
 include/linux/sched/user.h     |  1 -
 include/linux/user_namespace.h | 13 ++++++++
 kernel/cred.c                  | 10 +++---
 kernel/exit.c                  |  2 +-
 kernel/fork.c                  |  9 ++---
 kernel/sys.c                   |  2 +-
 kernel/ucount.c                | 60 ++++++++++++++++++++++++++++++++++
 kernel/user.c                  |  1 -
 kernel/user_namespace.c        |  3 +-
 14 files changed, 102 insertions(+), 29 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 5d4d52039105..f62fd2632104 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1870,7 +1870,7 @@ static int do_execveat_common(int fd, struct filename *filename,
 	 * whether NPROC limit is still exceeded.
 	 */
 	if ((current->flags & PF_NPROC_EXCEEDED) &&
-	    atomic_read(&current_user()->processes) > rlimit(RLIMIT_NPROC)) {
+	    is_ucounts_overlimit(current_ucounts(), UCOUNT_RLIMIT_NPROC, rlimit(RLIMIT_NPROC))) {
 		retval = -EAGAIN;
 		goto out_ret;
 	}
diff --git a/fs/io-wq.c b/fs/io-wq.c
index a564f36e260c..5b6940c90c61 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -20,6 +20,7 @@
 #include <linux/blk-cgroup.h>
 #include <linux/audit.h>
 #include <linux/cpu.h>
+#include <linux/user_namespace.h>
 
 #include "../kernel/sched/sched.h"
 #include "io-wq.h"
@@ -120,7 +121,7 @@ struct io_wq {
 	io_wq_work_fn *do_work;
 
 	struct task_struct *manager;
-	struct user_struct *user;
+	const struct cred *cred;
 	refcount_t refs;
 	struct completion done;
 
@@ -234,7 +235,7 @@ static void io_worker_exit(struct io_worker *worker)
 	if (worker->flags & IO_WORKER_F_RUNNING)
 		atomic_dec(&acct->nr_running);
 	if (!(worker->flags & IO_WORKER_F_BOUND))
-		atomic_dec(&wqe->wq->user->processes);
+		dec_rlimit_ucounts(wqe->wq->cred->ucounts, UCOUNT_RLIMIT_NPROC, 1);
 	worker->flags = 0;
 	preempt_enable();
 
@@ -364,15 +365,15 @@ static void __io_worker_busy(struct io_wqe *wqe, struct io_worker *worker,
 			worker->flags |= IO_WORKER_F_BOUND;
 			wqe->acct[IO_WQ_ACCT_UNBOUND].nr_workers--;
 			wqe->acct[IO_WQ_ACCT_BOUND].nr_workers++;
-			atomic_dec(&wqe->wq->user->processes);
+			dec_rlimit_ucounts(wqe->wq->cred->ucounts, UCOUNT_RLIMIT_NPROC, 1);
 		} else {
 			worker->flags &= ~IO_WORKER_F_BOUND;
 			wqe->acct[IO_WQ_ACCT_UNBOUND].nr_workers++;
 			wqe->acct[IO_WQ_ACCT_BOUND].nr_workers--;
-			atomic_inc(&wqe->wq->user->processes);
+			inc_rlimit_ucounts(wqe->wq->cred->ucounts, UCOUNT_RLIMIT_NPROC, 1);
 		}
 		io_wqe_inc_running(wqe, worker);
-	 }
+	}
 }
 
 /*
@@ -707,7 +708,7 @@ static bool create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index)
 	raw_spin_unlock_irq(&wqe->lock);
 
 	if (index == IO_WQ_ACCT_UNBOUND)
-		atomic_inc(&wq->user->processes);
+		inc_rlimit_ucounts(wq->cred->ucounts, UCOUNT_RLIMIT_NPROC, 1);
 
 	refcount_inc(&wq->refs);
 	wake_up_process(worker->task);
@@ -838,7 +839,7 @@ static bool io_wq_can_queue(struct io_wqe *wqe, struct io_wqe_acct *acct,
 	if (free_worker)
 		return true;
 
-	if (atomic_read(&wqe->wq->user->processes) >= acct->max_workers &&
+	if (is_ucounts_overlimit(wqe->wq->cred->ucounts, UCOUNT_RLIMIT_NPROC, acct->max_workers) &&
 	    !(capable(CAP_SYS_RESOURCE) || capable(CAP_SYS_ADMIN)))
 		return false;
 
@@ -1074,7 +1075,7 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 	wq->do_work = data->do_work;
 
 	/* caller must already hold a reference to this */
-	wq->user = data->user;
+	wq->cred = data->cred;
 
 	ret = -ENOMEM;
 	for_each_node(node) {
@@ -1090,10 +1091,7 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 		wqe->node = alloc_node;
 		wqe->acct[IO_WQ_ACCT_BOUND].max_workers = bounded;
 		atomic_set(&wqe->acct[IO_WQ_ACCT_BOUND].nr_running, 0);
-		if (wq->user) {
-			wqe->acct[IO_WQ_ACCT_UNBOUND].max_workers =
-					task_rlimit(current, RLIMIT_NPROC);
-		}
+		wqe->acct[IO_WQ_ACCT_UNBOUND].max_workers = task_rlimit(current, RLIMIT_NPROC);
 		atomic_set(&wqe->acct[IO_WQ_ACCT_UNBOUND].nr_running, 0);
 		wqe->wq = wq;
 		raw_spin_lock_init(&wqe->lock);
diff --git a/fs/io-wq.h b/fs/io-wq.h
index b158f8addcf3..4130e247c556 100644
--- a/fs/io-wq.h
+++ b/fs/io-wq.h
@@ -111,7 +111,7 @@ typedef void (free_work_fn)(struct io_wq_work *);
 typedef struct io_wq_work *(io_wq_work_fn)(struct io_wq_work *);
 
 struct io_wq_data {
-	struct user_struct *user;
+	const struct cred *cred;
 
 	io_wq_work_fn *do_work;
 	free_work_fn *free_work;
diff --git a/fs/io_uring.c b/fs/io_uring.c
index ca46f314640b..7e463dd5f3d0 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7985,7 +7985,7 @@ static int io_init_wq_offload(struct io_ring_ctx *ctx,
 	unsigned int concurrency;
 	int ret = 0;
 
-	data.user = ctx->user;
+	data.cred = ctx->creds;
 	data.free_work = io_free_work;
 	data.do_work = io_wq_submit_work;
 
diff --git a/include/linux/cred.h b/include/linux/cred.h
index 307744fcc387..2ca545b8669b 100644
--- a/include/linux/cred.h
+++ b/include/linux/cred.h
@@ -371,6 +371,7 @@ static inline void put_cred(const struct cred *_cred)
 
 #define task_uid(task)		(task_cred_xxx((task), uid))
 #define task_euid(task)		(task_cred_xxx((task), euid))
+#define task_ucounts(task)	(task_cred_xxx((task), ucounts))
 
 #define current_cred_xxx(xxx)			\
 ({						\
@@ -387,6 +388,7 @@ static inline void put_cred(const struct cred *_cred)
 #define current_fsgid() 	(current_cred_xxx(fsgid))
 #define current_cap()		(current_cred_xxx(cap_effective))
 #define current_user()		(current_cred_xxx(user))
+#define current_ucounts()	(current_cred_xxx(ucounts))
 
 extern struct user_namespace init_user_ns;
 #ifdef CONFIG_USER_NS
diff --git a/include/linux/sched/user.h b/include/linux/sched/user.h
index a8ec3b6093fc..d33d867ad6c1 100644
--- a/include/linux/sched/user.h
+++ b/include/linux/sched/user.h
@@ -12,7 +12,6 @@
  */
 struct user_struct {
 	refcount_t __count;	/* reference count */
-	atomic_t processes;	/* How many processes does this user have? */
 	atomic_t sigpending;	/* How many pending signals does this user have? */
 #ifdef CONFIG_FANOTIFY
 	atomic_t fanotify_listeners;
diff --git a/include/linux/user_namespace.h b/include/linux/user_namespace.h
index 9a3ba69e9223..bca6d28c85ce 100644
--- a/include/linux/user_namespace.h
+++ b/include/linux/user_namespace.h
@@ -50,9 +50,12 @@ enum ucount_type {
 	UCOUNT_INOTIFY_INSTANCES,
 	UCOUNT_INOTIFY_WATCHES,
 #endif
+	UCOUNT_RLIMIT_NPROC,
 	UCOUNT_COUNTS,
 };
 
+#define MAX_PER_NAMESPACE_UCOUNTS UCOUNT_RLIMIT_NPROC
+
 struct user_namespace {
 	struct uid_gid_map	uid_map;
 	struct uid_gid_map	gid_map;
@@ -112,6 +115,16 @@ static inline struct ucounts *get_ucounts(struct ucounts *ucounts)
 	return ucounts;
 }
 
+static inline long get_ucounts_value(struct ucounts *ucounts, enum ucount_type type)
+{
+	return atomic_long_read(&ucounts->ucount[type]);
+}
+
+bool inc_rlimit_ucounts(struct ucounts *ucounts, enum ucount_type type, long v);
+bool inc_rlimit_ucounts_and_test(struct ucounts *ucounts, enum ucount_type type, long v, long max);
+void dec_rlimit_ucounts(struct ucounts *ucounts, enum ucount_type type, long v);
+bool is_ucounts_overlimit(struct ucounts *ucounts, enum ucount_type type, long max);
+
 #ifdef CONFIG_USER_NS
 
 static inline struct user_namespace *get_user_ns(struct user_namespace *ns)
diff --git a/kernel/cred.c b/kernel/cred.c
index a27d725c7c79..c43e30407d22 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -357,7 +357,7 @@ int copy_creds(struct task_struct *p, unsigned long clone_flags)
 		kdebug("share_creds(%p{%d,%d})",
 		       p->cred, atomic_read(&p->cred->usage),
 		       read_cred_subscribers(p->cred));
-		atomic_inc(&p->cred->user->processes);
+		inc_rlimit_ucounts(task_ucounts(p), UCOUNT_RLIMIT_NPROC, 1);
 		return 0;
 	}
 
@@ -391,8 +391,8 @@ int copy_creds(struct task_struct *p, unsigned long clone_flags)
 	}
 #endif
 
-	atomic_inc(&new->user->processes);
 	p->cred = p->real_cred = get_cred(new);
+	inc_rlimit_ucounts(task_ucounts(p), UCOUNT_RLIMIT_NPROC, 1);
 	alter_cred_subscribers(new, 2);
 	validate_creds(new);
 	return 0;
@@ -493,14 +493,13 @@ int commit_creds(struct cred *new)
 	 */
 	alter_cred_subscribers(new, 2);
 	if (new->user != old->user || new->user_ns != old->user_ns) {
-		if (new->user != old->user)
-			atomic_inc(&new->user->processes);
 		set_cred_ucounts(new, new->user_ns, new->euid);
+		inc_rlimit_ucounts(new->ucounts, UCOUNT_RLIMIT_NPROC, 1);
 	}
 	rcu_assign_pointer(task->real_cred, new);
 	rcu_assign_pointer(task->cred, new);
 	if (new->user != old->user)
-		atomic_dec(&old->user->processes);
+		dec_rlimit_ucounts(old->ucounts, UCOUNT_RLIMIT_NPROC, 1);
 	alter_cred_subscribers(old, -2);
 
 	/* send notifications */
@@ -676,6 +675,7 @@ void __init cred_init(void)
 	 * ucount reference to copy.
 	 */
 	set_cred_ucounts(&init_cred, &init_user_ns, GLOBAL_ROOT_UID);
+	inc_rlimit_ucounts(init_cred.ucounts, UCOUNT_RLIMIT_NPROC, 1);
 }
 
 /**
diff --git a/kernel/exit.c b/kernel/exit.c
index 04029e35e69a..61c0fe902b50 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -188,7 +188,7 @@ void release_task(struct task_struct *p)
 	/* don't need to get the RCU readlock here - the process is dead and
 	 * can't be modifying its own credentials. But shut RCU-lockdep up */
 	rcu_read_lock();
-	atomic_dec(&__task_cred(p)->user->processes);
+	dec_rlimit_ucounts(task_ucounts(p), UCOUNT_RLIMIT_NPROC, 1);
 	rcu_read_unlock();
 
 	cgroup_release(p);
diff --git a/kernel/fork.c b/kernel/fork.c
index 37720a6d04ea..ef7936daeeda 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -819,10 +819,12 @@ void __init fork_init(void)
 	init_task.signal->rlim[RLIMIT_SIGPENDING] =
 		init_task.signal->rlim[RLIMIT_NPROC];
 
-	for (i = 0; i < UCOUNT_COUNTS; i++) {
+	for (i = 0; i < MAX_PER_NAMESPACE_UCOUNTS; i++) {
 		init_user_ns.ucount_max[i] = max_threads/2;
 	}
 
+	init_user_ns.ucount_max[UCOUNT_RLIMIT_NPROC] = task_rlimit(&init_task, RLIMIT_NPROC);
+
 #ifdef CONFIG_VMAP_STACK
 	cpuhp_setup_state(CPUHP_BP_PREPARE_DYN, "fork:vm_stack_cache",
 			  NULL, free_vm_stack_cache);
@@ -1964,8 +1966,7 @@ static __latent_entropy struct task_struct *copy_process(
 	DEBUG_LOCKS_WARN_ON(!p->softirqs_enabled);
 #endif
 	retval = -EAGAIN;
-	if (atomic_read(&p->real_cred->user->processes) >=
-			task_rlimit(p, RLIMIT_NPROC)) {
+	if (is_ucounts_overlimit(task_ucounts(p), UCOUNT_RLIMIT_NPROC, rlimit(RLIMIT_NPROC))) {
 		if (p->real_cred->user != INIT_USER &&
 		    !capable(CAP_SYS_RESOURCE) && !capable(CAP_SYS_ADMIN))
 			goto bad_fork_free;
@@ -2368,7 +2369,7 @@ static __latent_entropy struct task_struct *copy_process(
 #endif
 	delayacct_tsk_free(p);
 bad_fork_cleanup_count:
-	atomic_dec(&p->cred->user->processes);
+	dec_rlimit_ucounts(task_ucounts(p), UCOUNT_RLIMIT_NPROC, 1);
 	exit_creds(p);
 bad_fork_free:
 	p->state = TASK_DEAD;
diff --git a/kernel/sys.c b/kernel/sys.c
index 51f00fe20e4d..c2734ab9474e 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -474,7 +474,7 @@ static int set_user(struct cred *new)
 	 * for programs doing set*uid()+execve() by harmlessly deferring the
 	 * failure to the execve() stage.
 	 */
-	if (atomic_read(&new_user->processes) >= rlimit(RLIMIT_NPROC) &&
+	if (is_ucounts_overlimit(new->ucounts, UCOUNT_RLIMIT_NPROC, rlimit(RLIMIT_NPROC)) &&
 			new_user != INIT_USER)
 		current->flags |= PF_NPROC_EXCEEDED;
 	else
diff --git a/kernel/ucount.c b/kernel/ucount.c
index 0b4e956d87bb..ee683cc088af 100644
--- a/kernel/ucount.c
+++ b/kernel/ucount.c
@@ -7,6 +7,7 @@
 #include <linux/hash.h>
 #include <linux/kmemleak.h>
 #include <linux/user_namespace.h>
+#include <linux/security.h>
 
 #define UCOUNTS_HASHTABLE_BITS 10
 static struct hlist_head ucounts_hashtable[(1 << UCOUNTS_HASHTABLE_BITS)];
@@ -74,6 +75,7 @@ static struct ctl_table user_table[] = {
 	UCOUNT_ENTRY("max_inotify_instances"),
 	UCOUNT_ENTRY("max_inotify_watches"),
 #endif
+	{ },
 	{ }
 };
 #endif /* CONFIG_SYSCTL */
@@ -193,6 +195,19 @@ static inline bool atomic_long_inc_below(atomic_long_t *v, int u)
 	}
 }
 
+static inline long atomic_long_dec_value(atomic_long_t *v, long n)
+{
+	long c, old;
+	c = atomic_long_read(v);
+	for (;;) {
+		old = atomic_long_cmpxchg(v, c, c - n);
+		if (likely(old == c))
+			return c;
+		c = old;
+	}
+	return c;
+}
+
 struct ucounts *inc_ucount(struct user_namespace *ns, kuid_t uid,
 			   enum ucount_type type)
 {
@@ -226,6 +241,51 @@ void dec_ucount(struct ucounts *ucounts, enum ucount_type type)
 	put_ucounts(ucounts);
 }
 
+bool inc_rlimit_ucounts(struct ucounts *ucounts, enum ucount_type type, long v)
+{
+	struct ucounts *iter;
+	bool overlimit = false;
+
+	for (iter = ucounts; iter; iter = iter->ns->ucounts) {
+		long max = READ_ONCE(iter->ns->ucount_max[type]);
+		if (atomic_long_add_return(v, &iter->ucount[type]) > max)
+			overlimit = true;
+	}
+
+	return overlimit;
+}
+
+bool inc_rlimit_ucounts_and_test(struct ucounts *ucounts, enum ucount_type type,
+		long v, long max)
+{
+	bool overlimit = inc_rlimit_ucounts(ucounts, type, v);
+	if (!overlimit && get_ucounts_value(ucounts, type) > max)
+		overlimit = true;
+	return overlimit;
+}
+
+void dec_rlimit_ucounts(struct ucounts *ucounts, enum ucount_type type, long v)
+{
+	struct ucounts *iter;
+	for (iter = ucounts; iter; iter = iter->ns->ucounts) {
+		long dec = atomic_long_dec_value(&iter->ucount[type], v);
+		WARN_ON_ONCE(dec < 0);
+	}
+}
+
+bool is_ucounts_overlimit(struct ucounts *ucounts, enum ucount_type type, long max)
+{
+	struct ucounts *iter;
+	if (get_ucounts_value(ucounts, type) > max)
+		return true;
+	for (iter = ucounts; iter; iter = iter->ns->ucounts) {
+		max = READ_ONCE(iter->ns->ucount_max[type]);
+		if (get_ucounts_value(iter, type) > max)
+			return true;
+	}
+	return false;
+}
+
 static __init int user_namespace_sysctl_init(void)
 {
 #ifdef CONFIG_SYSCTL
diff --git a/kernel/user.c b/kernel/user.c
index a2478cddf536..7f5ff498207a 100644
--- a/kernel/user.c
+++ b/kernel/user.c
@@ -98,7 +98,6 @@ static DEFINE_SPINLOCK(uidhash_lock);
 /* root_user.__count is 1, for init task cred */
 struct user_struct root_user = {
 	.__count	= REFCOUNT_INIT(1),
-	.processes	= ATOMIC_INIT(1),
 	.sigpending	= ATOMIC_INIT(0),
 	.locked_shm     = 0,
 	.uid		= GLOBAL_ROOT_UID,
diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index 4b8a4468d391..974f10da072c 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -118,9 +118,10 @@ int create_user_ns(struct cred *new)
 	ns->owner = owner;
 	ns->group = group;
 	INIT_WORK(&ns->work, free_user_ns);
-	for (i = 0; i < UCOUNT_COUNTS; i++) {
+	for (i = 0; i < MAX_PER_NAMESPACE_UCOUNTS; i++) {
 		ns->ucount_max[i] = INT_MAX;
 	}
+	ns->ucount_max[UCOUNT_RLIMIT_NPROC] = rlimit(RLIMIT_NPROC);
 	ns->ucounts = ucounts;
 
 	/* Inherit USERNS_SETGROUPS_ALLOWED from our parent */
-- 
2.29.2

