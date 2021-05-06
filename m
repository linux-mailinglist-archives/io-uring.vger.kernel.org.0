Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3E663755BA
	for <lists+io-uring@lfdr.de>; Thu,  6 May 2021 16:33:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234904AbhEFOeU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 6 May 2021 10:34:20 -0400
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:39867 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234906AbhEFOeT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 6 May 2021 10:34:19 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UXzfsmc_1620311593;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UXzfsmc_1620311593)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 06 May 2021 22:33:20 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH RFC 5.13] io_uring: add IORING_REGISTER_PRIORITY
Date:   Thu,  6 May 2021 22:33:13 +0800
Message-Id: <1620311593-46083-1-git-send-email-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Users may want a higher priority for sq_thread or io-worker. Provide a
way to change the nice value(for SCHED_NORMAL) or scheduling policy.

Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---

currently support for sqthread, while space reserved for io-worker.

 fs/io_uring.c                 | 117 ++++++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/io_uring.h |  29 +++++++++++
 2 files changed, 146 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 63ff70587d4f..a77b7a05c058 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -83,6 +83,7 @@
 #include <trace/events/io_uring.h>
 
 #include <uapi/linux/io_uring.h>
+#include <uapi/linux/sched/types.h>
 
 #include "internal.h"
 #include "io-wq.h"
@@ -9908,6 +9909,115 @@ static int io_register_rsrc(struct io_ring_ctx *ctx, void __user *arg,
 	return -EINVAL;
 }
 
+/*
+ * Returns true if current's euid is same as p's uid or euid,
+ * or has CAP_SYS_NICE to p's user_ns.
+ *
+ * Called with rcu_read_lock, creds are safe
+ */
+static bool set_one_prio_perm(struct task_struct *p)
+{
+	const struct cred *cred = current_cred(), *pcred = __task_cred(p);
+
+	if (uid_eq(pcred->uid,  cred->euid) ||
+	    uid_eq(pcred->euid, cred->euid))
+		return true;
+	if (ns_capable(pcred->user_ns, CAP_SYS_NICE))
+		return true;
+	return false;
+}
+
+/*
+ * set the priority of a task
+ * - the caller must hold the RCU read lock
+ */
+static int set_one_prio(struct task_struct *p, int niceval, int error)
+{
+	int no_nice;
+
+	if (!set_one_prio_perm(p)) {
+		error = -EPERM;
+		goto out;
+	}
+	if (niceval < task_nice(p) && !can_nice(p, niceval)) {
+		error = -EACCES;
+		goto out;
+	}
+	no_nice = security_task_setnice(p, niceval);
+	if (no_nice) {
+		error = no_nice;
+		goto out;
+	}
+	if (error == -ESRCH)
+		error = 0;
+	set_user_nice(p, niceval);
+out:
+	return error;
+}
+
+static int io_register_priority(struct io_ring_ctx *ctx, void __user *arg)
+{
+	struct io_uring_priority prio;
+	int error = -ESRCH;
+
+	if (copy_from_user(&prio, arg, sizeof(struct io_uring_priority)))
+		return -EFAULT;
+
+	if (prio.target >= IORING_PRIORITY_TARGET_LAST)
+		return -EINVAL;
+
+	if (prio.mode >= IORING_PRIORITY_MODE_LAST)
+		return -EINVAL;
+
+
+	switch (prio.mode) {
+	case IORING_PRIORITY_MODE_NICE: {
+		int niceval = prio.nice;
+
+		if (niceval < MIN_NICE)
+			niceval = MIN_NICE;
+		if (niceval > MAX_NICE)
+			niceval = MAX_NICE;
+
+		if (prio.target == IORING_PRIORITY_TARGET_SQ) {
+			struct io_sq_data *sqd = ctx->sq_data;
+
+			if (!sqd)
+				return error;
+
+			io_sq_thread_park(sqd);
+			if (sqd->thread)
+				error = set_one_prio(sqd->thread, niceval, -ESRCH);
+			io_sq_thread_unpark(sqd);
+		}
+		break;
+	}
+	case IORING_PRIORITY_MODE_SCHEDULER: {
+		int policy = prio.param.policy;
+		int sched_priority = prio.param.sched_priority;
+		struct sched_param lparam = { .sched_priority = sched_priority };
+
+		if (policy < 0)
+			return -EINVAL;
+
+		if (prio.target == IORING_PRIORITY_TARGET_SQ) {
+			struct io_sq_data *sqd = ctx->sq_data;
+
+			if (!sqd)
+				return error;
+
+			io_sq_thread_park(sqd);
+			if (sqd->thread)
+				error = sched_setscheduler(sqd->thread, policy, &lparam);
+			io_sq_thread_unpark(sqd);
+		}
+		break;
+	}
+	}
+
+	return error;
+}
+
 static bool io_register_op_must_quiesce(int op)
 {
 	switch (op) {
@@ -9921,6 +10031,7 @@ static bool io_register_op_must_quiesce(int op)
 	case IORING_UNREGISTER_PERSONALITY:
 	case IORING_REGISTER_RSRC:
 	case IORING_REGISTER_RSRC_UPDATE:
+	case IORING_REGISTER_PRIORITY:
 		return false;
 	default:
 		return true;
@@ -10052,6 +10163,12 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 	case IORING_REGISTER_RSRC_UPDATE:
 		ret = io_register_rsrc_update(ctx, arg, nr_args);
 		break;
+	case IORING_REGISTER_PRIORITY:
+		ret = -EINVAL;
+		if (!arg || nr_args != 1)
+			break;
+		ret = io_register_priority(ctx, arg);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index e1ae46683301..4788a62bf3a1 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -300,6 +300,7 @@ enum {
 	IORING_REGISTER_ENABLE_RINGS		= 12,
 	IORING_REGISTER_RSRC			= 13,
 	IORING_REGISTER_RSRC_UPDATE		= 14,
+	IORING_REGISTER_PRIORITY		= 15,
 
 	/* this goes last */
 	IORING_REGISTER_LAST
@@ -396,4 +397,32 @@ struct io_uring_getevents_arg {
 	__u64	ts;
 };
 
+enum {
+	IORING_PRIORITY_TARGET_SQ,	/*  update priority of sqthread */
+	IORING_PRIORITY_TARGET_WQ,	/*  update priority of io worker */
+
+	IORING_PRIORITY_TARGET_LAST,
+};
+
+enum {
+	IORING_PRIORITY_MODE_NICE,
+	IORING_PRIORITY_MODE_SCHEDULER,
+
+	IORING_PRIORITY_MODE_LAST,
+};
+
+struct io_uring_sched_param {
+	__s32 policy;
+	__s32 sched_priority;
+};
+
+struct io_uring_priority {
+	__u32 target;
+	__u32 mode;
+	union {
+		__s32 nice;
+		struct io_uring_sched_param param;
+	};
+};
+
 #endif
-- 
1.8.3.1

