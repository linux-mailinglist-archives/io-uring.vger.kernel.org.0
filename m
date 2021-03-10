Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AC16333BF3
	for <lists+io-uring@lfdr.de>; Wed, 10 Mar 2021 13:02:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230512AbhCJMCL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 10 Mar 2021 07:02:11 -0500
Received: from raptor.unsafe.ru ([5.9.43.93]:56098 "EHLO raptor.unsafe.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231161AbhCJMBp (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Wed, 10 Mar 2021 07:01:45 -0500
Received: from comp-core-i7-2640m-0182e6.redhat.com (ip-94-113-225-162.net.upcbroadband.cz [94.113.225.162])
        by raptor.unsafe.ru (Postfix) with ESMTPSA id D46B240EF5;
        Wed, 10 Mar 2021 12:01:42 +0000 (UTC)
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
        Oleg Nesterov <oleg@redhat.com>,
        kernel test robot <oliver.sang@intel.com>
Subject: [PATCH v8 2/8] Add a reference to ucounts for each cred
Date:   Wed, 10 Mar 2021 13:01:27 +0100
Message-Id: <8495980367f9d7ba7cf7a95d3886f8cbf76c0d6c.1615372955.git.gladkov.alexey@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1615372955.git.gladkov.alexey@gmail.com>
References: <cover.1615372955.git.gladkov.alexey@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.4 (raptor.unsafe.ru [0.0.0.0]); Wed, 10 Mar 2021 12:01:43 +0000 (UTC)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

For RLIMIT_NPROC and some other rlimits the user_struct that holds the
global limit is kept alive for the lifetime of a process by keeping it
in struct cred. Adding a pointer to ucounts in the struct cred will
allow to track RLIMIT_NPROC not only for user in the system, but for
user in the user_namespace.

Updating ucounts may require memory allocation which may fail. So, we
cannot change cred.ucounts in the commit_creds() because this function
cannot fail and it should always return 0. For this reason, we modify
cred.ucounts before calling the commit_creds().

Changelog

v6:
* Fix null-ptr-deref in is_ucounts_overlimit() detected by trinity. This
  error was caused by the fact that cred_alloc_blank() left the ucounts
  pointer empty.

Reported-by: kernel test robot <oliver.sang@intel.com>
Signed-off-by: Alexey Gladkov <gladkov.alexey@gmail.com>
---
 fs/exec.c                      |  4 ++++
 include/linux/cred.h           |  2 ++
 include/linux/user_namespace.h |  4 ++++
 kernel/cred.c                  | 40 ++++++++++++++++++++++++++++++++++
 kernel/fork.c                  |  6 +++++
 kernel/sys.c                   | 12 ++++++++++
 kernel/ucount.c                | 40 +++++++++++++++++++++++++++++++---
 kernel/user_namespace.c        |  3 +++
 8 files changed, 108 insertions(+), 3 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 5d4d52039105..0371a3400be5 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1360,6 +1360,10 @@ int begin_new_exec(struct linux_binprm * bprm)
 	WRITE_ONCE(me->self_exec_id, me->self_exec_id + 1);
 	flush_signal_handlers(me, 0);
 
+	retval = set_cred_ucounts(bprm->cred);
+	if (retval < 0)
+		goto out_unlock;
+
 	/*
 	 * install the new credentials for this executable
 	 */
diff --git a/include/linux/cred.h b/include/linux/cred.h
index 18639c069263..ad160e5fe5c6 100644
--- a/include/linux/cred.h
+++ b/include/linux/cred.h
@@ -144,6 +144,7 @@ struct cred {
 #endif
 	struct user_struct *user;	/* real user ID subscription */
 	struct user_namespace *user_ns; /* user_ns the caps and keyrings are relative to. */
+	struct ucounts *ucounts;
 	struct group_info *group_info;	/* supplementary groups for euid/fsgid */
 	/* RCU deletion */
 	union {
@@ -170,6 +171,7 @@ extern int set_security_override_from_ctx(struct cred *, const char *);
 extern int set_create_files_as(struct cred *, struct inode *);
 extern int cred_fscmp(const struct cred *, const struct cred *);
 extern void __init cred_init(void);
+extern int set_cred_ucounts(struct cred *);
 
 /*
  * check for validity of credentials
diff --git a/include/linux/user_namespace.h b/include/linux/user_namespace.h
index 0bb833fd41f4..f71b5a4a3e74 100644
--- a/include/linux/user_namespace.h
+++ b/include/linux/user_namespace.h
@@ -97,11 +97,15 @@ struct ucounts {
 };
 
 extern struct user_namespace init_user_ns;
+extern struct ucounts init_ucounts;
 
 bool setup_userns_sysctls(struct user_namespace *ns);
 void retire_userns_sysctls(struct user_namespace *ns);
 struct ucounts *inc_ucount(struct user_namespace *ns, kuid_t uid, enum ucount_type type);
 void dec_ucount(struct ucounts *ucounts, enum ucount_type type);
+struct ucounts *alloc_ucounts(struct user_namespace *ns, kuid_t uid);
+struct ucounts *get_ucounts(struct ucounts *ucounts);
+void put_ucounts(struct ucounts *ucounts);
 
 #ifdef CONFIG_USER_NS
 
diff --git a/kernel/cred.c b/kernel/cred.c
index 421b1149c651..58a8a9e24347 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -60,6 +60,7 @@ struct cred init_cred = {
 	.user			= INIT_USER,
 	.user_ns		= &init_user_ns,
 	.group_info		= &init_groups,
+	.ucounts		= &init_ucounts,
 };
 
 static inline void set_cred_subscribers(struct cred *cred, int n)
@@ -119,6 +120,8 @@ static void put_cred_rcu(struct rcu_head *rcu)
 	if (cred->group_info)
 		put_group_info(cred->group_info);
 	free_uid(cred->user);
+	if (cred->ucounts)
+		put_ucounts(cred->ucounts);
 	put_user_ns(cred->user_ns);
 	kmem_cache_free(cred_jar, cred);
 }
@@ -222,6 +225,7 @@ struct cred *cred_alloc_blank(void)
 #ifdef CONFIG_DEBUG_CREDENTIALS
 	new->magic = CRED_MAGIC;
 #endif
+	new->ucounts = get_ucounts(&init_ucounts);
 
 	if (security_cred_alloc_blank(new, GFP_KERNEL_ACCOUNT) < 0)
 		goto error;
@@ -284,6 +288,11 @@ struct cred *prepare_creds(void)
 
 	if (security_prepare_creds(new, old, GFP_KERNEL_ACCOUNT) < 0)
 		goto error;
+
+	new->ucounts = get_ucounts(new->ucounts);
+	if (!new->ucounts)
+		goto error;
+
 	validate_creds(new);
 	return new;
 
@@ -363,6 +372,8 @@ int copy_creds(struct task_struct *p, unsigned long clone_flags)
 		ret = create_user_ns(new);
 		if (ret < 0)
 			goto error_put;
+		if (set_cred_ucounts(new) < 0)
+			goto error_put;
 	}
 
 #ifdef CONFIG_KEYS
@@ -653,6 +664,31 @@ int cred_fscmp(const struct cred *a, const struct cred *b)
 }
 EXPORT_SYMBOL(cred_fscmp);
 
+int set_cred_ucounts(struct cred *new)
+{
+	struct task_struct *task = current;
+	const struct cred *old = task->real_cred;
+	struct ucounts *old_ucounts = new->ucounts;
+
+	if (new->user == old->user && new->user_ns == old->user_ns)
+		return 0;
+
+	/*
+	 * This optimization is needed because alloc_ucounts() uses locks
+	 * for table lookups.
+	 */
+	if (old_ucounts && old_ucounts->ns == new->user_ns && uid_eq(old_ucounts->uid, new->euid))
+		return 0;
+
+	if (!(new->ucounts = alloc_ucounts(new->user_ns, new->euid)))
+		return -EAGAIN;
+
+	if (old_ucounts)
+		put_ucounts(old_ucounts);
+
+	return 0;
+}
+
 /*
  * initialise the credentials stuff
  */
@@ -719,6 +755,10 @@ struct cred *prepare_kernel_cred(struct task_struct *daemon)
 	if (security_prepare_creds(new, old, GFP_KERNEL_ACCOUNT) < 0)
 		goto error;
 
+	new->ucounts = get_ucounts(new->ucounts);
+	if (!new->ucounts)
+		goto error;
+
 	put_cred(old);
 	validate_creds(new);
 	return new;
diff --git a/kernel/fork.c b/kernel/fork.c
index d66cd1014211..40a5da7d3d70 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2957,6 +2957,12 @@ int ksys_unshare(unsigned long unshare_flags)
 	if (err)
 		goto bad_unshare_cleanup_cred;
 
+	if (new_cred) {
+		err = set_cred_ucounts(new_cred);
+		if (err)
+			goto bad_unshare_cleanup_cred;
+	}
+
 	if (new_fs || new_fd || do_sysvsem || new_cred || new_nsproxy) {
 		if (do_sysvsem) {
 			/*
diff --git a/kernel/sys.c b/kernel/sys.c
index 51f00fe20e4d..373def7debe8 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -553,6 +553,10 @@ long __sys_setreuid(uid_t ruid, uid_t euid)
 	if (retval < 0)
 		goto error;
 
+	retval = set_cred_ucounts(new);
+	if (retval < 0)
+		goto error;
+
 	return commit_creds(new);
 
 error:
@@ -611,6 +615,10 @@ long __sys_setuid(uid_t uid)
 	if (retval < 0)
 		goto error;
 
+	retval = set_cred_ucounts(new);
+	if (retval < 0)
+		goto error;
+
 	return commit_creds(new);
 
 error:
@@ -686,6 +694,10 @@ long __sys_setresuid(uid_t ruid, uid_t euid, uid_t suid)
 	if (retval < 0)
 		goto error;
 
+	retval = set_cred_ucounts(new);
+	if (retval < 0)
+		goto error;
+
 	return commit_creds(new);
 
 error:
diff --git a/kernel/ucount.c b/kernel/ucount.c
index 04c561751af1..50cc1dfb7d28 100644
--- a/kernel/ucount.c
+++ b/kernel/ucount.c
@@ -8,6 +8,12 @@
 #include <linux/kmemleak.h>
 #include <linux/user_namespace.h>
 
+struct ucounts init_ucounts = {
+	.ns    = &init_user_ns,
+	.uid   = GLOBAL_ROOT_UID,
+	.count = 1,
+};
+
 #define UCOUNTS_HASHTABLE_BITS 10
 static struct hlist_head ucounts_hashtable[(1 << UCOUNTS_HASHTABLE_BITS)];
 static DEFINE_SPINLOCK(ucounts_lock);
@@ -125,7 +131,15 @@ static struct ucounts *find_ucounts(struct user_namespace *ns, kuid_t uid, struc
 	return NULL;
 }
 
-static struct ucounts *get_ucounts(struct user_namespace *ns, kuid_t uid)
+static void hlist_add_ucounts(struct ucounts *ucounts)
+{
+	struct hlist_head *hashent = ucounts_hashentry(ucounts->ns, ucounts->uid);
+	spin_lock_irq(&ucounts_lock);
+	hlist_add_head(&ucounts->node, hashent);
+	spin_unlock_irq(&ucounts_lock);
+}
+
+struct ucounts *alloc_ucounts(struct user_namespace *ns, kuid_t uid)
 {
 	struct hlist_head *hashent = ucounts_hashentry(ns, uid);
 	struct ucounts *ucounts, *new;
@@ -160,7 +174,26 @@ static struct ucounts *get_ucounts(struct user_namespace *ns, kuid_t uid)
 	return ucounts;
 }
 
-static void put_ucounts(struct ucounts *ucounts)
+struct ucounts *get_ucounts(struct ucounts *ucounts)
+{
+	unsigned long flags;
+
+	if (!ucounts)
+		return NULL;
+
+	spin_lock_irqsave(&ucounts_lock, flags);
+	if (ucounts->count == INT_MAX) {
+		WARN_ONCE(1, "ucounts: counter has reached its maximum value");
+		ucounts = NULL;
+	} else {
+		ucounts->count += 1;
+	}
+	spin_unlock_irqrestore(&ucounts_lock, flags);
+
+	return ucounts;
+}
+
+void put_ucounts(struct ucounts *ucounts)
 {
 	unsigned long flags;
 
@@ -194,7 +227,7 @@ struct ucounts *inc_ucount(struct user_namespace *ns, kuid_t uid,
 {
 	struct ucounts *ucounts, *iter, *bad;
 	struct user_namespace *tns;
-	ucounts = get_ucounts(ns, uid);
+	ucounts = alloc_ucounts(ns, uid);
 	for (iter = ucounts; iter; iter = tns->ucounts) {
 		long max;
 		tns = iter->ns;
@@ -237,6 +270,7 @@ static __init int user_namespace_sysctl_init(void)
 	BUG_ON(!user_header);
 	BUG_ON(!setup_userns_sysctls(&init_user_ns));
 #endif
+	hlist_add_ucounts(&init_ucounts);
 	return 0;
 }
 subsys_initcall(user_namespace_sysctl_init);
diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index af612945a4d0..516db53166ab 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -1281,6 +1281,9 @@ static int userns_install(struct nsset *nsset, struct ns_common *ns)
 	put_user_ns(cred->user_ns);
 	set_cred_user_ns(cred, get_user_ns(user_ns));
 
+	if (set_cred_ucounts(cred) < 0)
+		return -EINVAL;
+
 	return 0;
 }
 
-- 
2.29.2

