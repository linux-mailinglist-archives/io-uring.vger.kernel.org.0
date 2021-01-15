Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BF1E2F7F0D
	for <lists+io-uring@lfdr.de>; Fri, 15 Jan 2021 16:09:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729489AbhAOPJX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 Jan 2021 10:09:23 -0500
Received: from raptor.unsafe.ru ([5.9.43.93]:34028 "EHLO raptor.unsafe.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728020AbhAOPJX (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Fri, 15 Jan 2021 10:09:23 -0500
Received: from comp-core-i7-2640m-0182e6.redhat.com (ip-89-103-122-167.net.upcbroadband.cz [89.103.122.167])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by raptor.unsafe.ru (Postfix) with ESMTPSA id 304C220A1C;
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
Subject: [RFC PATCH v3 4/8] Move RLIMIT_MSGQUEUE counter to ucounts
Date:   Fri, 15 Jan 2021 15:57:25 +0100
Message-Id: <d823db215431bf161fb3c9b8bb8f0ac1592919c2.1610722474.git.gladkov.alexey@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1610722473.git.gladkov.alexey@gmail.com>
References: <cover.1610722473.git.gladkov.alexey@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.1 (raptor.unsafe.ru [5.9.43.93]); Fri, 15 Jan 2021 14:59:12 +0000 (UTC)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Signed-off-by: Alexey Gladkov <gladkov.alexey@gmail.com>
---
 include/linux/sched/user.h     |  4 ----
 include/linux/user_namespace.h |  1 +
 ipc/mqueue.c                   | 29 +++++++++++++++--------------
 kernel/fork.c                  |  1 +
 kernel/ucount.c                |  1 +
 kernel/user_namespace.c        |  1 +
 6 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/include/linux/sched/user.h b/include/linux/sched/user.h
index d33d867ad6c1..8a34446681aa 100644
--- a/include/linux/sched/user.h
+++ b/include/linux/sched/user.h
@@ -18,10 +18,6 @@ struct user_struct {
 #endif
 #ifdef CONFIG_EPOLL
 	atomic_long_t epoll_watches; /* The number of file descriptors currently watched */
-#endif
-#ifdef CONFIG_POSIX_MQUEUE
-	/* protected by mq_lock	*/
-	unsigned long mq_bytes;	/* How many bytes can be allocated to mqueue? */
 #endif
 	unsigned long locked_shm; /* How many pages of mlocked shm ? */
 	unsigned long unix_inflight;	/* How many files in flight in unix sockets */
diff --git a/include/linux/user_namespace.h b/include/linux/user_namespace.h
index bca6d28c85ce..ff96a906d7da 100644
--- a/include/linux/user_namespace.h
+++ b/include/linux/user_namespace.h
@@ -51,6 +51,7 @@ enum ucount_type {
 	UCOUNT_INOTIFY_WATCHES,
 #endif
 	UCOUNT_RLIMIT_NPROC,
+	UCOUNT_RLIMIT_MSGQUEUE,
 	UCOUNT_COUNTS,
 };
 
diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index beff0cfcd1e8..05fcf067131f 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -144,7 +144,7 @@ struct mqueue_inode_info {
 	struct pid *notify_owner;
 	u32 notify_self_exec_id;
 	struct user_namespace *notify_user_ns;
-	struct user_struct *user;	/* user who created, for accounting */
+	struct ucounts *ucounts;	/* user who created, for accounting */
 	struct sock *notify_sock;
 	struct sk_buff *notify_cookie;
 
@@ -292,7 +292,6 @@ static struct inode *mqueue_get_inode(struct super_block *sb,
 		struct ipc_namespace *ipc_ns, umode_t mode,
 		struct mq_attr *attr)
 {
-	struct user_struct *u = current_user();
 	struct inode *inode;
 	int ret = -ENOMEM;
 
@@ -309,6 +308,8 @@ static struct inode *mqueue_get_inode(struct super_block *sb,
 	if (S_ISREG(mode)) {
 		struct mqueue_inode_info *info;
 		unsigned long mq_bytes, mq_treesize;
+		struct ucounts *ucounts;
+		bool overlimit;
 
 		inode->i_fop = &mqueue_file_operations;
 		inode->i_size = FILENT_SIZE;
@@ -321,7 +322,7 @@ static struct inode *mqueue_get_inode(struct super_block *sb,
 		info->notify_owner = NULL;
 		info->notify_user_ns = NULL;
 		info->qsize = 0;
-		info->user = NULL;	/* set when all is ok */
+		info->ucounts = NULL;	/* set when all is ok */
 		info->msg_tree = RB_ROOT;
 		info->msg_tree_rightmost = NULL;
 		info->node_cache = NULL;
@@ -371,19 +372,19 @@ static struct inode *mqueue_get_inode(struct super_block *sb,
 		if (mq_bytes + mq_treesize < mq_bytes)
 			goto out_inode;
 		mq_bytes += mq_treesize;
+		ucounts = current_ucounts();
 		spin_lock(&mq_lock);
-		if (u->mq_bytes + mq_bytes < u->mq_bytes ||
-		    u->mq_bytes + mq_bytes > rlimit(RLIMIT_MSGQUEUE)) {
+		overlimit = inc_rlimit_ucounts_and_test(ucounts, UCOUNT_RLIMIT_MSGQUEUE,
+				mq_bytes, rlimit(RLIMIT_MSGQUEUE));
+		if (overlimit) {
+			dec_rlimit_ucounts(ucounts, UCOUNT_RLIMIT_MSGQUEUE, mq_bytes);
 			spin_unlock(&mq_lock);
 			/* mqueue_evict_inode() releases info->messages */
 			ret = -EMFILE;
 			goto out_inode;
 		}
-		u->mq_bytes += mq_bytes;
 		spin_unlock(&mq_lock);
-
-		/* all is ok */
-		info->user = get_uid(u);
+		info->ucounts = get_ucounts(ucounts);
 	} else if (S_ISDIR(mode)) {
 		inc_nlink(inode);
 		/* Some things misbehave if size == 0 on a directory */
@@ -497,7 +498,7 @@ static void mqueue_free_inode(struct inode *inode)
 static void mqueue_evict_inode(struct inode *inode)
 {
 	struct mqueue_inode_info *info;
-	struct user_struct *user;
+	struct ucounts *ucounts;
 	struct ipc_namespace *ipc_ns;
 	struct msg_msg *msg, *nmsg;
 	LIST_HEAD(tmp_msg);
@@ -520,8 +521,8 @@ static void mqueue_evict_inode(struct inode *inode)
 		free_msg(msg);
 	}
 
-	user = info->user;
-	if (user) {
+	ucounts = info->ucounts;
+	if (ucounts) {
 		unsigned long mq_bytes, mq_treesize;
 
 		/* Total amount of bytes accounted for the mqueue */
@@ -533,7 +534,7 @@ static void mqueue_evict_inode(struct inode *inode)
 					  info->attr.mq_msgsize);
 
 		spin_lock(&mq_lock);
-		user->mq_bytes -= mq_bytes;
+		dec_rlimit_ucounts(ucounts, UCOUNT_RLIMIT_MSGQUEUE, mq_bytes);
 		/*
 		 * get_ns_from_inode() ensures that the
 		 * (ipc_ns = sb->s_fs_info) is either a valid ipc_ns
@@ -543,7 +544,7 @@ static void mqueue_evict_inode(struct inode *inode)
 		if (ipc_ns)
 			ipc_ns->mq_queues_count--;
 		spin_unlock(&mq_lock);
-		free_uid(user);
+		put_ucounts(ucounts);
 	}
 	if (ipc_ns)
 		put_ipc_ns(ipc_ns);
diff --git a/kernel/fork.c b/kernel/fork.c
index ef7936daeeda..f61a5a3dc02f 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -824,6 +824,7 @@ void __init fork_init(void)
 	}
 
 	init_user_ns.ucount_max[UCOUNT_RLIMIT_NPROC] = task_rlimit(&init_task, RLIMIT_NPROC);
+	init_user_ns.ucount_max[UCOUNT_RLIMIT_MSGQUEUE] = task_rlimit(&init_task, RLIMIT_MSGQUEUE);
 
 #ifdef CONFIG_VMAP_STACK
 	cpuhp_setup_state(CPUHP_BP_PREPARE_DYN, "fork:vm_stack_cache",
diff --git a/kernel/ucount.c b/kernel/ucount.c
index ee683cc088af..daeb657d4989 100644
--- a/kernel/ucount.c
+++ b/kernel/ucount.c
@@ -75,6 +75,7 @@ static struct ctl_table user_table[] = {
 	UCOUNT_ENTRY("max_inotify_instances"),
 	UCOUNT_ENTRY("max_inotify_watches"),
 #endif
+	{ },
 	{ },
 	{ }
 };
diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index 974f10da072c..9ace2a45a25d 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -122,6 +122,7 @@ int create_user_ns(struct cred *new)
 		ns->ucount_max[i] = INT_MAX;
 	}
 	ns->ucount_max[UCOUNT_RLIMIT_NPROC] = rlimit(RLIMIT_NPROC);
+	ns->ucount_max[UCOUNT_RLIMIT_MSGQUEUE] = rlimit(RLIMIT_MSGQUEUE);
 	ns->ucounts = ucounts;
 
 	/* Inherit USERNS_SETGROUPS_ALLOWED from our parent */
-- 
2.29.2

