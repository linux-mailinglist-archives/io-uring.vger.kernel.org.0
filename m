Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B19EF32C9A9
	for <lists+io-uring@lfdr.de>; Thu,  4 Mar 2021 02:19:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231548AbhCDBKB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 Mar 2021 20:10:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351673AbhCDAct (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 3 Mar 2021 19:32:49 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0EA5C061222
        for <io-uring@vger.kernel.org>; Wed,  3 Mar 2021 16:27:20 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id q20so17536625pfu.8
        for <io-uring@vger.kernel.org>; Wed, 03 Mar 2021 16:27:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BwrNkYDBZO1vXk65pR2t5TqLaUbc64WpfatDDjV2WmU=;
        b=b3AsuCXbJ772+14ryEsrDcccyzWmvK24q/FBkK7H1TkbuQDSGclpsJUdgEaVc5gng1
         VNxkW/Use8ZTBJPSYB6e65DDfIFPn2asD0M9he6I+kldSitiZjgfj3LyK/Xy1RfdQcxK
         XvES82W7FSNa4L9QFcZD+HjD/nOIxec5j3si6tLCTBH6a+J/3+fzydc+kLHlOOycARCL
         R8gy/vdVfYBtvpNOPbULvvYBuiY901+bSQC8V1XXjjHue6YpyB3uUmNc24z0Hhudhmjt
         XrUycPdsFGfqTFNSbW9/cvx4P7arkKtk8Ew4XZt5JDQxnQQHY/rKyar+jwdgklWtFL4a
         BGnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BwrNkYDBZO1vXk65pR2t5TqLaUbc64WpfatDDjV2WmU=;
        b=YZ2gmvlsyS7bweSxWd2FFpB+Ieo/IgRwwIYSULktenLkjrZenQ3q2vnx6I1V0r1f7m
         5EG0yFdzf0s12FwLZ/oQyiiqct0FmW896dq5IUeJvhu1rx5mYtNtTlsSXnz19N+8IrOV
         u+LHGbuC2f8sHOPrqsz9C57v3iPfNDY4RcNhRVBRqDG0RGmv/EpZWUiacYJ258XjuNAb
         KJQpI0yb8U+LxaxZNQr9+BmtNXPWqQnhXII5N06HisjqtyEo5dicVbOPIsxVpi9SHx8Y
         xa9jaVnW6rMgRSBD69hz9PyhOyiJOESehhb7BPXSEnOBpkaQITa0gI9LDSVb8Udfok4b
         Sccg==
X-Gm-Message-State: AOAM5339nNtCotq76Kz0S0ibxL7eHtarwJUAPa2mc3IfZPFPaGNEWOKY
        0HLSHH+SiAik6VmHLu+G/B/bRUtaVO0t/xwb
X-Google-Smtp-Source: ABdhPJwhFdqO1Im88XVzK9Eyd/bAZpobjAY5lsoiDcgUlBWB7xBtTtj92dEJ2Wfwv/s5ja0uFjAzDg==
X-Received: by 2002:a65:4c01:: with SMTP id u1mr1371979pgq.182.1614817639872;
        Wed, 03 Mar 2021 16:27:19 -0800 (PST)
Received: from localhost.localdomain ([2600:380:7540:52b5:3f01:150c:3b2:bf47])
        by smtp.gmail.com with ESMTPSA id b6sm23456983pgt.69.2021.03.03.16.27.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 16:27:19 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 12/33] io_uring: signal worker thread unshare
Date:   Wed,  3 Mar 2021 17:26:39 -0700
Message-Id: <20210304002700.374417-13-axboe@kernel.dk>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210304002700.374417-1-axboe@kernel.dk>
References: <20210304002700.374417-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If the original task switches credentials or unshares any part of the
task state, then we should notify the io_uring workers to they can
re-fork as well. For credentials, this actually happens just fine for
the io-wq workers, as we grab and pass that down. For SQPOLL, we're
stuck with the original credentials, which means that it cannot be used
if the task does eg seteuid().

For unshare(2), the story is the same, except a task cannot do that and
expect the workers to assume the new identity.

Fix this up by just having the threads exit and re-fork if the ring task
does seteuid() (and friends), or does unshare(2) on any parts of the
task.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io-wq.c               | 21 ++++++++++++++++-----
 fs/io-wq.h               |  1 +
 fs/io_uring.c            | 26 ++++++++++++++++++++++++--
 include/linux/io_uring.h |  9 +++++++++
 kernel/cred.c            |  2 ++
 kernel/fork.c            |  2 ++
 6 files changed, 54 insertions(+), 7 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 65ae35ca8dba..c24473231eee 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -744,6 +744,7 @@ static int io_wq_manager(void *data)
 {
 	struct io_wq *wq = data;
 	char buf[TASK_COMM_LEN];
+	int node;
 
 	sprintf(buf, "iou-mgr-%d", wq->task_pid);
 	set_task_comm(current, buf);
@@ -761,6 +762,12 @@ static int io_wq_manager(void *data)
 	} while (!test_bit(IO_WQ_BIT_EXIT, &wq->state));
 
 	io_wq_check_workers(wq);
+
+	rcu_read_lock();
+	for_each_node(node)
+		io_wq_for_each_worker(wq->wqes[node], io_wq_worker_wake, NULL);
+	rcu_read_unlock();
+
 	/* we might not ever have created any workers */
 	if (atomic_read(&wq->worker_refs))
 		wait_for_completion(&wq->worker_done);
@@ -1097,11 +1104,6 @@ static void io_wq_destroy(struct io_wq *wq)
 	set_bit(IO_WQ_BIT_EXIT, &wq->state);
 	io_wq_destroy_manager(wq);
 
-	rcu_read_lock();
-	for_each_node(node)
-		io_wq_for_each_worker(wq->wqes[node], io_wq_worker_wake, NULL);
-	rcu_read_unlock();
-
 	spin_lock_irq(&wq->hash->wait.lock);
 	for_each_node(node) {
 		struct io_wqe *wqe = wq->wqes[node];
@@ -1165,3 +1167,12 @@ static __init int io_wq_init(void)
 	return 0;
 }
 subsys_initcall(io_wq_init);
+
+void io_wq_unshare(struct io_wq *wq)
+{
+	refcount_inc(&wq->refs);
+	set_bit(IO_WQ_BIT_EXIT, &wq->state);
+	io_wq_destroy_manager(wq);
+	clear_bit(IO_WQ_BIT_EXIT, &wq->state);
+	io_wq_put(wq);
+}
diff --git a/fs/io-wq.h b/fs/io-wq.h
index f6ef433df8a8..57e478af1e1d 100644
--- a/fs/io-wq.h
+++ b/fs/io-wq.h
@@ -115,6 +115,7 @@ struct io_wq_data {
 struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data);
 void io_wq_put(struct io_wq *wq);
 void io_wq_put_and_exit(struct io_wq *wq);
+void io_wq_unshare(struct io_wq *wq);
 
 void io_wq_enqueue(struct io_wq *wq, struct io_wq_work *work);
 void io_wq_hash_work(struct io_wq_work *work, void *val);
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 83973f6b3c0a..f89d7375a7c3 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8955,6 +8955,24 @@ void __io_uring_task_cancel(void)
 	io_uring_remove_task_files(tctx);
 }
 
+void __io_uring_unshare(void)
+{
+	struct io_uring_task *tctx = current->io_uring;
+	struct file *file;
+	unsigned long index;
+
+	io_wq_unshare(tctx->io_wq);
+	if (!tctx->sqpoll)
+		return;
+
+	xa_for_each(&tctx->xa, index, file) {
+		struct io_ring_ctx *ctx = file->private_data;
+
+		if (ctx->sq_data)
+			io_sq_thread_stop(ctx->sq_data);
+	}
+}
+
 static int io_uring_flush(struct file *file, void *data)
 {
 	struct io_uring_task *tctx = current->io_uring;
@@ -9170,10 +9188,14 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 		io_cqring_overflow_flush(ctx, false, NULL, NULL);
 
 		if (unlikely(ctx->sqo_exec)) {
-			ret = io_sq_thread_fork(ctx->sq_data, ctx);
+			struct io_sq_data *sqd = ctx->sq_data;
+
+			ret = io_sq_thread_fork(sqd, ctx);
+			if (ret)
+				set_bit(IO_SQ_THREAD_SHOULD_STOP, &sqd->state);
+			complete(&sqd->startup);
 			if (ret)
 				goto out;
-			ctx->sqo_exec = 0;
 		}
 		ret = -EOWNERDEAD;
 		if (unlikely(ctx->sqo_dead))
diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index 51ede771cd99..bfe2fcb4f478 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -35,7 +35,13 @@ struct sock *io_uring_get_socket(struct file *file);
 void __io_uring_task_cancel(void);
 void __io_uring_files_cancel(struct files_struct *files);
 void __io_uring_free(struct task_struct *tsk);
+void __io_uring_unshare(void);
 
+static inline void io_uring_unshare(void)
+{
+	if (current->io_uring)
+		__io_uring_unshare();
+}
 static inline void io_uring_task_cancel(void)
 {
 	if (current->io_uring && !xa_empty(&current->io_uring->xa))
@@ -56,6 +62,9 @@ static inline struct sock *io_uring_get_socket(struct file *file)
 {
 	return NULL;
 }
+static inline void io_uring_unshare(void)
+{
+}
 static inline void io_uring_task_cancel(void)
 {
 }
diff --git a/kernel/cred.c b/kernel/cred.c
index 421b1149c651..324e3ee61e1d 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -16,6 +16,7 @@
 #include <linux/binfmts.h>
 #include <linux/cn_proc.h>
 #include <linux/uidgid.h>
+#include <linux/io_uring.h>
 
 #if 0
 #define kdebug(FMT, ...)						\
@@ -509,6 +510,7 @@ int commit_creds(struct cred *new)
 	/* release the old obj and subj refs both */
 	put_cred(old);
 	put_cred(old);
+	io_uring_unshare();
 	return 0;
 }
 EXPORT_SYMBOL(commit_creds);
diff --git a/kernel/fork.c b/kernel/fork.c
index d66cd1014211..5d1b00083c9e 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2999,6 +2999,8 @@ int ksys_unshare(unsigned long unshare_flags)
 			commit_creds(new_cred);
 			new_cred = NULL;
 		}
+
+		io_uring_unshare();
 	}
 
 	perf_event_namespaces(current);
-- 
2.30.1

