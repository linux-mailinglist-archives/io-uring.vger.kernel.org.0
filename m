Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F203233C33F
	for <lists+io-uring@lfdr.de>; Mon, 15 Mar 2021 18:04:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234179AbhCORDc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 15 Mar 2021 13:03:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235673AbhCORC5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 15 Mar 2021 13:02:57 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6EF2C061764
        for <io-uring@vger.kernel.org>; Mon, 15 Mar 2021 10:02:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-Id:Date:Cc:To:From;
        bh=gIWb+klX6fINwPkxrpqhyw/CwCJG1Rb8Ye7ywYdWy8U=; b=T1KTc5R50VshHXWin0Py/nuluF
        sir4zz8wOm7K2YSrRN2QWtcjxPUU50LVQY8YZN5yx5YrTpZs4Aqf9bSyWYUdWO++eAofkRcP4Rc9Z
        nP99xIuL5sS8fFJw6K28QIWjkfvfg7r6PMg/E2sYG8OPh2y5v1bIagg0i2sit2+xYBNDUYGYAlRDu
        SLnuEF7zsJ+et0pjRidP535ZEUBTzrO4OKuNkBao/Q/a9UsZKeDsJQbaWNipsgHEbv4ErFVQuraJo
        j8Sp/smdBJ0iWtPrzp45prcH3pQWYVnPjPCYtxDpnnvfuilr3+kRGHSbCVakECWrOtAqWFNxTty44
        FemaWENmxbJqyI/ALX1tw57U/Mg+Hv5K085/s62C4XS6AWpq+qGVTE1hYtVWunkDV8mv7kTMP3/Vp
        7l0HrQKR+isklRZjOOfoQf0cIu4W8ED9THVyIvAe4GnY/wwNgp7fSuLiq83Riwh1wlwN4yLtEvbsp
        0/JJEscA9lDULC+/S7XN8m4d;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lLqcJ-00057c-2Y; Mon, 15 Mar 2021 17:02:55 +0000
From:   Stefan Metzmacher <metze@samba.org>
To:     io-uring@vger.kernel.org
Cc:     Stefan Metzmacher <metze@samba.org>
Subject: [RFC PATCH 08/10] fs/proc: protect /proc/<pid>/[task/<tid>]/comm for PF_IO_WORKER
Date:   Mon, 15 Mar 2021 18:01:46 +0100
Message-Id: <97ad63bef490139bb4996e75dea408af1e78fa47.1615826736.git.metze@samba.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1615826736.git.metze@samba.org>
References: <cover.1615826736.git.metze@samba.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/proc/base.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 6e04278de582..7177e92790c4 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1665,6 +1665,7 @@ static ssize_t comm_write(struct file *file, const char __user *buf,
 				size_t count, loff_t *offset)
 {
 	struct inode *inode = file_inode(file);
+	bool is_same_tgroup = false;
 	struct task_struct *p;
 	char buffer[TASK_COMM_LEN];
 	const size_t maxlen = sizeof(buffer) - 1;
@@ -1677,7 +1678,10 @@ static ssize_t comm_write(struct file *file, const char __user *buf,
 	if (!p)
 		return -ESRCH;
 
-	if (same_thread_group(current, p))
+	if (!(p->flags & PF_IO_WORKER))
+		is_same_tgroup = same_thread_group(current, p);
+
+	if (is_same_tgroup)
 		set_task_comm(p, buffer);
 	else
 		count = -EINVAL;
@@ -1822,7 +1826,7 @@ void task_dump_owner(struct task_struct *task, umode_t mode,
 	kuid_t uid;
 	kgid_t gid;
 
-	if (unlikely(task->flags & PF_KTHREAD)) {
+	if (unlikely(task->flags & (PF_KTHREAD | PF_IO_WORKER))) {
 		*ruid = GLOBAL_ROOT_UID;
 		*rgid = GLOBAL_ROOT_GID;
 		return;
@@ -3478,19 +3482,22 @@ int proc_pid_readdir(struct file *file, struct dir_context *ctx)
 static int proc_tid_comm_permission(struct user_namespace *mnt_userns,
 				    struct inode *inode, int mask)
 {
-	bool is_same_tgroup;
+	bool is_same_tgroup = false;
 	struct task_struct *task;
 
 	task = get_proc_task(inode);
 	if (!task)
 		return -ESRCH;
-	is_same_tgroup = same_thread_group(current, task);
+	if (!(task->flags & PF_IO_WORKER))
+		is_same_tgroup = same_thread_group(current, task);
 	put_task_struct(task);
 
 	if (likely(is_same_tgroup && !(mask & MAY_EXEC))) {
 		/* This file (/proc/<pid>/task/<tid>/comm) can always be
 		 * read or written by the members of the corresponding
 		 * thread group.
+		 *
+		 * But we exclude PF_IO_WORKER kernel threads.
 		 */
 		return 0;
 	}
-- 
2.25.1

