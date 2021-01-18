Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA2F12F9B50
	for <lists+io-uring@lfdr.de>; Mon, 18 Jan 2021 09:33:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733226AbhARIcS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 18 Jan 2021 03:32:18 -0500
Received: from raptor.unsafe.ru ([5.9.43.93]:32828 "EHLO raptor.unsafe.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726488AbhARIcQ (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Mon, 18 Jan 2021 03:32:16 -0500
Received: from comp-core-i7-2640m-0182e6.redhat.com (ip-89-103-122-167.net.upcbroadband.cz [89.103.122.167])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by raptor.unsafe.ru (Postfix) with ESMTPSA id 5C3EC20479;
        Mon, 18 Jan 2021 08:31:18 +0000 (UTC)
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
Subject: [PATCH v4 2/8] Add a reference to ucounts for each cred
Date:   Mon, 18 Jan 2021 09:31:08 +0100
Message-Id: <9b26dda8be0dc55fc2b030cd53e59c56787050a1.1610958162.git.gladkov.alexey@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <bea844285b19c8caf2e656c7ea329a7b2e812c42.1610722474.git.gladkov.alexey@gmail.com>
References: <bea844285b19c8caf2e656c7ea329a7b2e812c42.1610722474.git.gladkov.alexey@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.1 (raptor.unsafe.ru [5.9.43.93]); Mon, 18 Jan 2021 08:31:29 +0000 (UTC)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

For RLIMIT_NPROC and some other rlimits the user_struct that holds the
global limit is kept alive for the lifetime of a process by keeping it
in struct cred.  Add a ucounts reference to struct cred, so that
RLIMIT_NPROC can switch from using a per user limit to using a per user
per user namespace limit.

Changelog
---------
v4:
* Fixed typo in the kernel/cred.c

Signed-off-by: Alexey Gladkov <gladkov.alexey@gmail.com>
---
 include/linux/cred.h           |  1 +
 include/linux/user_namespace.h | 13 +++++++++++--
 kernel/cred.c                  | 20 ++++++++++++++++++--
 kernel/ucount.c                | 30 ++++++++++++++++++++----------
 kernel/user_namespace.c        |  1 +
 5 files changed, 51 insertions(+), 14 deletions(-)

diff --git a/include/linux/cred.h b/include/linux/cred.h
index 18639c069263..307744fcc387 100644
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
diff --git a/include/linux/user_namespace.h b/include/linux/user_namespace.h
index f84fc2d9ce20..9a3ba69e9223 100644
--- a/include/linux/user_namespace.h
+++ b/include/linux/user_namespace.h
@@ -85,7 +85,7 @@ struct user_namespace {
 	struct ctl_table_header *sysctls;
 #endif
 	struct ucounts		*ucounts;
-	int ucount_max[UCOUNT_COUNTS];
+	long ucount_max[UCOUNT_COUNTS];
 } __randomize_layout;
 
 struct ucounts {
@@ -93,7 +93,7 @@ struct ucounts {
 	struct user_namespace *ns;
 	kuid_t uid;
 	refcount_t count;
-	atomic_t ucount[UCOUNT_COUNTS];
+	atomic_long_t ucount[UCOUNT_COUNTS];
 };
 
 extern struct user_namespace init_user_ns;
@@ -102,6 +102,15 @@ bool setup_userns_sysctls(struct user_namespace *ns);
 void retire_userns_sysctls(struct user_namespace *ns);
 struct ucounts *inc_ucount(struct user_namespace *ns, kuid_t uid, enum ucount_type type);
 void dec_ucount(struct ucounts *ucounts, enum ucount_type type);
+void put_ucounts(struct ucounts *ucounts);
+void set_cred_ucounts(struct cred *cred, struct user_namespace *ns, kuid_t uid);
+
+static inline struct ucounts *get_ucounts(struct ucounts *ucounts)
+{
+	if (ucounts)
+		refcount_inc(&ucounts->count);
+	return ucounts;
+}
 
 #ifdef CONFIG_USER_NS
 
diff --git a/kernel/cred.c b/kernel/cred.c
index 421b1149c651..9473e71e784c 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -119,6 +119,8 @@ static void put_cred_rcu(struct rcu_head *rcu)
 	if (cred->group_info)
 		put_group_info(cred->group_info);
 	free_uid(cred->user);
+	if (cred->ucounts)
+		put_ucounts(cred->ucounts);
 	put_user_ns(cred->user_ns);
 	kmem_cache_free(cred_jar, cred);
 }
@@ -144,6 +146,9 @@ void __put_cred(struct cred *cred)
 	BUG_ON(cred == current->cred);
 	BUG_ON(cred == current->real_cred);
 
+	if (cred->ucounts)
+		BUG_ON(cred->ucounts->ns != cred->user_ns);
+
 	if (cred->non_rcu)
 		put_cred_rcu(&cred->rcu);
 	else
@@ -270,6 +275,7 @@ struct cred *prepare_creds(void)
 	get_group_info(new->group_info);
 	get_uid(new->user);
 	get_user_ns(new->user_ns);
+	get_ucounts(new->ucounts);
 
 #ifdef CONFIG_KEYS
 	key_get(new->session_keyring);
@@ -363,6 +369,7 @@ int copy_creds(struct task_struct *p, unsigned long clone_flags)
 		ret = create_user_ns(new);
 		if (ret < 0)
 			goto error_put;
+		set_cred_ucounts(new, new->user_ns, new->euid);
 	}
 
 #ifdef CONFIG_KEYS
@@ -485,8 +492,11 @@ int commit_creds(struct cred *new)
 	 * in set_user().
 	 */
 	alter_cred_subscribers(new, 2);
-	if (new->user != old->user)
-		atomic_inc(&new->user->processes);
+	if (new->user != old->user || new->user_ns != old->user_ns) {
+		if (new->user != old->user)
+			atomic_inc(&new->user->processes);
+		set_cred_ucounts(new, new->user_ns, new->euid);
+	}
 	rcu_assign_pointer(task->real_cred, new);
 	rcu_assign_pointer(task->cred, new);
 	if (new->user != old->user)
@@ -661,6 +671,11 @@ void __init cred_init(void)
 	/* allocate a slab in which we can store credentials */
 	cred_jar = kmem_cache_create("cred_jar", sizeof(struct cred), 0,
 			SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_ACCOUNT, NULL);
+	/*
+	 * This is needed here because this is the first cred and there is no
+	 * ucount reference to copy.
+	 */
+	set_cred_ucounts(&init_cred, &init_user_ns, GLOBAL_ROOT_UID);
 }
 
 /**
@@ -704,6 +719,7 @@ struct cred *prepare_kernel_cred(struct task_struct *daemon)
 	get_uid(new->user);
 	get_user_ns(new->user_ns);
 	get_group_info(new->group_info);
+	get_ucounts(new->ucounts);
 
 #ifdef CONFIG_KEYS
 	new->session_keyring = NULL;
diff --git a/kernel/ucount.c b/kernel/ucount.c
index 82acd2226460..0b4e956d87bb 100644
--- a/kernel/ucount.c
+++ b/kernel/ucount.c
@@ -125,7 +125,7 @@ static struct ucounts *find_ucounts(struct user_namespace *ns, kuid_t uid, struc
 	return NULL;
 }
 
-static struct ucounts *get_ucounts(struct user_namespace *ns, kuid_t uid)
+static struct ucounts *__get_ucounts(struct user_namespace *ns, kuid_t uid)
 {
 	struct hlist_head *hashent = ucounts_hashentry(ns, uid);
 	struct ucounts *ucounts, *new;
@@ -158,7 +158,7 @@ static struct ucounts *get_ucounts(struct user_namespace *ns, kuid_t uid)
 	return ucounts;
 }
 
-static void put_ucounts(struct ucounts *ucounts)
+void put_ucounts(struct ucounts *ucounts)
 {
 	unsigned long flags;
 
@@ -169,14 +169,24 @@ static void put_ucounts(struct ucounts *ucounts)
 	}
 }
 
-static inline bool atomic_inc_below(atomic_t *v, int u)
+void set_cred_ucounts(struct cred *cred, struct user_namespace *ns, kuid_t uid)
 {
-	int c, old;
-	c = atomic_read(v);
+	struct ucounts *old = cred->ucounts;
+	if (old && old->ns == ns && uid_eq(old->uid, uid))
+		return;
+	cred->ucounts = __get_ucounts(ns, uid);
+	if (old)
+		put_ucounts(old);
+}
+
+static inline bool atomic_long_inc_below(atomic_long_t *v, int u)
+{
+	long c, old;
+	c = atomic_long_read(v);
 	for (;;) {
 		if (unlikely(c >= u))
 			return false;
-		old = atomic_cmpxchg(v, c, c+1);
+		old = atomic_long_cmpxchg(v, c, c+1);
 		if (likely(old == c))
 			return true;
 		c = old;
@@ -188,19 +198,19 @@ struct ucounts *inc_ucount(struct user_namespace *ns, kuid_t uid,
 {
 	struct ucounts *ucounts, *iter, *bad;
 	struct user_namespace *tns;
-	ucounts = get_ucounts(ns, uid);
+	ucounts = __get_ucounts(ns, uid);
 	for (iter = ucounts; iter; iter = tns->ucounts) {
 		int max;
 		tns = iter->ns;
 		max = READ_ONCE(tns->ucount_max[type]);
-		if (!atomic_inc_below(&iter->ucount[type], max))
+		if (!atomic_long_inc_below(&iter->ucount[type], max))
 			goto fail;
 	}
 	return ucounts;
 fail:
 	bad = iter;
 	for (iter = ucounts; iter != bad; iter = iter->ns->ucounts)
-		atomic_dec(&iter->ucount[type]);
+		atomic_long_dec(&iter->ucount[type]);
 
 	put_ucounts(ucounts);
 	return NULL;
@@ -210,7 +220,7 @@ void dec_ucount(struct ucounts *ucounts, enum ucount_type type)
 {
 	struct ucounts *iter;
 	for (iter = ucounts; iter; iter = iter->ns->ucounts) {
-		int dec = atomic_dec_if_positive(&iter->ucount[type]);
+		int dec = atomic_long_dec_if_positive(&iter->ucount[type]);
 		WARN_ON_ONCE(dec < 0);
 	}
 	put_ucounts(ucounts);
diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index af612945a4d0..4b8a4468d391 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -1280,6 +1280,7 @@ static int userns_install(struct nsset *nsset, struct ns_common *ns)
 
 	put_user_ns(cred->user_ns);
 	set_cred_user_ns(cred, get_user_ns(user_ns));
+	set_cred_ucounts(cred, user_ns, cred->euid);
 
 	return 0;
 }
-- 
2.29.2

