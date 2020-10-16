Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03F22290921
	for <lists+io-uring@lfdr.de>; Fri, 16 Oct 2020 18:02:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410543AbgJPQCt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 16 Oct 2020 12:02:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2395555AbgJPQCt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 16 Oct 2020 12:02:49 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CC47C061755
        for <io-uring@vger.kernel.org>; Fri, 16 Oct 2020 09:02:48 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id o8so1521914pll.4
        for <io-uring@vger.kernel.org>; Fri, 16 Oct 2020 09:02:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EOkeCoC4Syx5AqWGUdkfBx+JHPNBX4he50kb9i8Nwvo=;
        b=mzRFbt+6uo1S1/dIueIa2cC+PTaxDi7M2RdgmkcOqB4rNoPAr2wjoCyrq5GsVm9Ae7
         IOfKBHXFsVlDSZBZZfIl7CqWQtdsIUhET/FbspnM84tuHh1AfOMQ6dYKmyR69uDfHK4w
         32moifhti9l3cCrRAGHoaHn5asvqy2BlTlfOHxHNyCWfH6tNLdLwbdyhRRN/XzND6PC6
         ZyGw5D9bfsPpQYpr5ltnRGAx3mBtWPREdh+cPDpCEt/+uJb1w5ATFIpfD/culnya33k5
         fke7PkW6ZZThkLC5PB1Uwyje/EEB7TwJ1OnPoRtbRrI+5GhzdrOWjAKfxm5Zg/gNC5/K
         DuIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EOkeCoC4Syx5AqWGUdkfBx+JHPNBX4he50kb9i8Nwvo=;
        b=JhHMzu++6NnnExz7bLHOszfAoEmzP++9sNkwNk7/0wNBlW9kWM24sX/xlIWJ+2WNb/
         82iyG5WX+w7qeV8wd56Fdfx3WJWKAoaUAenQjs7XNnGJRzl494ZjsU9bFeXhwt/fX9f5
         ij43rwhY/3JibsXJGxjIxIBdJAix+Hwx+uEpH2PV4xKTQEVmxdergpPYVmq1sw0iAl8U
         sPUIKeG8pySxBADargptIqAVW7DjqVTHnjygouV71pCVVDI5mJGWxX9s5A8ohGwh3Fvk
         XJBf50gZF2QLvy5IbmjZOZ6iuisFa8aXCORiArJ4F3FBXZdjgWjQ1T6RNEga+8Ff0uce
         ZBFg==
X-Gm-Message-State: AOAM530dbBTPmFS4MyR14iIG3tWWJHlmUB7oVrfgQft4N+f4lYNEijNg
        MA7uVN7U4XKY1E2VAemVGTylSAhSNRSbT1cp
X-Google-Smtp-Source: ABdhPJywil//jZAJy2L+9GeHUjyc/s58CimHxt1RHXxkfAvpukWfU+FzvVhvdByYFXwABmWiFJOkBw==
X-Received: by 2002:a17:902:9695:b029:d3:8b4f:558c with SMTP id n21-20020a1709029695b02900d38b4f558cmr4820439plp.27.1602864166190;
        Fri, 16 Oct 2020 09:02:46 -0700 (PDT)
Received: from p1.localdomain ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id t13sm3190109pfc.1.2020.10.16.09.02.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2020 09:02:45 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 14/18] io_uring: move io identity items into separate struct
Date:   Fri, 16 Oct 2020 10:02:20 -0600
Message-Id: <20201016160224.1575329-15-axboe@kernel.dk>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201016160224.1575329-1-axboe@kernel.dk>
References: <20201016160224.1575329-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io-wq contains a pointer to the identity, which we just hold in io_kiocb
for now. This is in preparation for putting this outside io_kiocb. The
only exception is struct files_struct, which we'll need different rules
for to avoid a circular dependency.

No functional changes in this patch.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io-wq.c               | 34 +++++++++++-----------
 fs/io-wq.h               | 12 ++------
 fs/io_uring.c            | 62 ++++++++++++++++++++--------------------
 include/linux/io_uring.h | 13 ++++++++-
 4 files changed, 64 insertions(+), 57 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index b7d8e544a804..0c852b75384d 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -430,9 +430,9 @@ static void io_wq_switch_mm(struct io_worker *worker, struct io_wq_work *work)
 		worker->mm = NULL;
 	}
 
-	if (mmget_not_zero(work->mm)) {
-		kthread_use_mm(work->mm);
-		worker->mm = work->mm;
+	if (mmget_not_zero(work->identity->mm)) {
+		kthread_use_mm(work->identity->mm);
+		worker->mm = work->identity->mm;
 		return;
 	}
 
@@ -446,9 +446,9 @@ static inline void io_wq_switch_blkcg(struct io_worker *worker,
 #ifdef CONFIG_BLK_CGROUP
 	if (!(work->flags & IO_WQ_WORK_BLKCG))
 		return;
-	if (work->blkcg_css != worker->blkcg_css) {
-		kthread_associate_blkcg(work->blkcg_css);
-		worker->blkcg_css = work->blkcg_css;
+	if (work->identity->blkcg_css != worker->blkcg_css) {
+		kthread_associate_blkcg(work->identity->blkcg_css);
+		worker->blkcg_css = work->identity->blkcg_css;
 	}
 #endif
 }
@@ -456,9 +456,9 @@ static inline void io_wq_switch_blkcg(struct io_worker *worker,
 static void io_wq_switch_creds(struct io_worker *worker,
 			       struct io_wq_work *work)
 {
-	const struct cred *old_creds = override_creds(work->creds);
+	const struct cred *old_creds = override_creds(work->identity->creds);
 
-	worker->cur_creds = work->creds;
+	worker->cur_creds = work->identity->creds;
 	if (worker->saved_creds)
 		put_cred(old_creds); /* creds set by previous switch */
 	else
@@ -468,19 +468,21 @@ static void io_wq_switch_creds(struct io_worker *worker,
 static void io_impersonate_work(struct io_worker *worker,
 				struct io_wq_work *work)
 {
-	if ((work->flags & IO_WQ_WORK_FILES) && current->files != work->files) {
+	if ((work->flags & IO_WQ_WORK_FILES) &&
+	    current->files != work->identity->files) {
 		task_lock(current);
-		current->files = work->files;
-		current->nsproxy = work->nsproxy;
+		current->files = work->identity->files;
+		current->nsproxy = work->identity->nsproxy;
 		task_unlock(current);
 	}
-	if ((work->flags & IO_WQ_WORK_FS) && current->fs != work->fs)
-		current->fs = work->fs;
-	if ((work->flags & IO_WQ_WORK_MM) && work->mm != worker->mm)
+	if ((work->flags & IO_WQ_WORK_FS) && current->fs != work->identity->fs)
+		current->fs = work->identity->fs;
+	if ((work->flags & IO_WQ_WORK_MM) && work->identity->mm != worker->mm)
 		io_wq_switch_mm(worker, work);
-	if ((work->flags & IO_WQ_WORK_CREDS) && worker->cur_creds != work->creds)
+	if ((work->flags & IO_WQ_WORK_CREDS) &&
+	    worker->cur_creds != work->identity->creds)
 		io_wq_switch_creds(worker, work);
-	current->signal->rlim[RLIMIT_FSIZE].rlim_cur = work->fsize;
+	current->signal->rlim[RLIMIT_FSIZE].rlim_cur = work->identity->fsize;
 	io_wq_switch_blkcg(worker, work);
 }
 
diff --git a/fs/io-wq.h b/fs/io-wq.h
index 31a29023605a..be21c500c925 100644
--- a/fs/io-wq.h
+++ b/fs/io-wq.h
@@ -1,6 +1,8 @@
 #ifndef INTERNAL_IO_WQ_H
 #define INTERNAL_IO_WQ_H
 
+#include <linux/io_uring.h>
+
 struct io_wq;
 
 enum {
@@ -91,15 +93,7 @@ static inline void wq_list_del(struct io_wq_work_list *list,
 
 struct io_wq_work {
 	struct io_wq_work_node list;
-	struct files_struct *files;
-	struct mm_struct *mm;
-#ifdef CONFIG_BLK_CGROUP
-	struct cgroup_subsys_state *blkcg_css;
-#endif
-	const struct cred *creds;
-	struct nsproxy *nsproxy;
-	struct fs_struct *fs;
-	unsigned long fsize;
+	struct io_identity *identity;
 	unsigned flags;
 };
 
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5b3f624fef6b..2d192f065c43 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -689,6 +689,7 @@ struct io_kiocb {
 	struct hlist_node		hash_node;
 	struct async_poll		*apoll;
 	struct io_wq_work		work;
+	struct io_identity		identity;
 };
 
 struct io_defer_entry {
@@ -1050,6 +1051,7 @@ static inline void io_req_init_async(struct io_kiocb *req)
 
 	memset(&req->work, 0, sizeof(req->work));
 	req->flags |= REQ_F_WORK_INITIALIZED;
+	req->work.identity = &req->identity;
 }
 
 static inline bool io_async_submit(struct io_ring_ctx *ctx)
@@ -1163,26 +1165,26 @@ static void io_req_clean_work(struct io_kiocb *req)
 	req->flags &= ~REQ_F_WORK_INITIALIZED;
 
 	if (req->work.flags & IO_WQ_WORK_MM) {
-		mmdrop(req->work.mm);
+		mmdrop(req->work.identity->mm);
 		req->work.flags &= ~IO_WQ_WORK_MM;
 	}
 #ifdef CONFIG_BLK_CGROUP
 	if (req->work.flags & IO_WQ_WORK_BLKCG) {
-		css_put(req->work.blkcg_css);
+		css_put(req->work.identity->blkcg_css);
 		req->work.flags &= ~IO_WQ_WORK_BLKCG;
 	}
 #endif
 	if (req->work.flags & IO_WQ_WORK_CREDS) {
-		put_cred(req->work.creds);
+		put_cred(req->work.identity->creds);
 		req->work.flags &= ~IO_WQ_WORK_CREDS;
 	}
 	if (req->work.flags & IO_WQ_WORK_FS) {
-		struct fs_struct *fs = req->work.fs;
+		struct fs_struct *fs = req->work.identity->fs;
 
-		spin_lock(&req->work.fs->lock);
+		spin_lock(&req->work.identity->fs->lock);
 		if (--fs->users)
 			fs = NULL;
-		spin_unlock(&req->work.fs->lock);
+		spin_unlock(&req->work.identity->fs->lock);
 		if (fs)
 			free_fs_struct(fs);
 		req->work.flags &= ~IO_WQ_WORK_FS;
@@ -1206,9 +1208,9 @@ static void io_prep_async_work(struct io_kiocb *req)
 	if (!(req->work.flags & IO_WQ_WORK_FILES) &&
 	    (io_op_defs[req->opcode].work_flags & IO_WQ_WORK_FILES) &&
 	    !(req->flags & REQ_F_NO_FILE_TABLE)) {
-		req->work.files = get_files_struct(current);
+		req->work.identity->files = get_files_struct(current);
 		get_nsproxy(current->nsproxy);
-		req->work.nsproxy = current->nsproxy;
+		req->work.identity->nsproxy = current->nsproxy;
 		req->flags |= REQ_F_INFLIGHT;
 
 		spin_lock_irq(&ctx->inflight_lock);
@@ -1219,35 +1221,33 @@ static void io_prep_async_work(struct io_kiocb *req)
 	if (!(req->work.flags & IO_WQ_WORK_MM) &&
 	    (def->work_flags & IO_WQ_WORK_MM)) {
 		mmgrab(current->mm);
-		req->work.mm = current->mm;
+		req->work.identity->mm = current->mm;
 		req->work.flags |= IO_WQ_WORK_MM;
 	}
 #ifdef CONFIG_BLK_CGROUP
 	if (!(req->work.flags & IO_WQ_WORK_BLKCG) &&
 	    (def->work_flags & IO_WQ_WORK_BLKCG)) {
 		rcu_read_lock();
-		req->work.blkcg_css = blkcg_css();
+		req->work.identity->blkcg_css = blkcg_css();
 		/*
 		 * This should be rare, either the cgroup is dying or the task
 		 * is moving cgroups. Just punt to root for the handful of ios.
 		 */
-		if (!css_tryget_online(req->work.blkcg_css))
-			req->work.blkcg_css = NULL;
-		else
+		if (css_tryget_online(req->work.identity->blkcg_css))
 			req->work.flags |= IO_WQ_WORK_BLKCG;
 		rcu_read_unlock();
 	}
 #endif
 	if (!(req->work.flags & IO_WQ_WORK_CREDS)) {
-		req->work.creds = get_current_cred();
+		req->work.identity->creds = get_current_cred();
 		req->work.flags |= IO_WQ_WORK_CREDS;
 	}
 	if (!(req->work.flags & IO_WQ_WORK_FS) &&
 	    (def->work_flags & IO_WQ_WORK_FS)) {
 		spin_lock(&current->fs->lock);
 		if (!current->fs->in_exec) {
-			req->work.fs = current->fs;
-			req->work.fs->users++;
+			req->work.identity->fs = current->fs;
+			req->work.identity->fs->users++;
 			req->work.flags |= IO_WQ_WORK_FS;
 		} else {
 			req->work.flags |= IO_WQ_WORK_CANCEL;
@@ -1255,9 +1255,9 @@ static void io_prep_async_work(struct io_kiocb *req)
 		spin_unlock(&current->fs->lock);
 	}
 	if (def->needs_fsize)
-		req->work.fsize = rlimit(RLIMIT_FSIZE);
+		req->work.identity->fsize = rlimit(RLIMIT_FSIZE);
 	else
-		req->work.fsize = RLIM_INFINITY;
+		req->work.identity->fsize = RLIM_INFINITY;
 }
 
 static void io_prep_async_link(struct io_kiocb *req)
@@ -1449,7 +1449,7 @@ static inline bool io_match_files(struct io_kiocb *req,
 		return true;
 	if ((req->flags & REQ_F_WORK_INITIALIZED) &&
 	    (req->work.flags & IO_WQ_WORK_FILES))
-		return req->work.files == files;
+		return req->work.identity->files == files;
 	return false;
 }
 
@@ -4088,7 +4088,7 @@ static int io_close(struct io_kiocb *req, bool force_nonblock,
 	}
 
 	/* No ->flush() or already async, safely close from here */
-	ret = filp_close(close->put_file, req->work.files);
+	ret = filp_close(close->put_file, req->work.identity->files);
 	if (ret < 0)
 		req_set_fail_links(req);
 	fput(close->put_file);
@@ -5696,8 +5696,8 @@ static void io_req_drop_files(struct io_kiocb *req)
 		wake_up(&ctx->inflight_wait);
 	spin_unlock_irqrestore(&ctx->inflight_lock, flags);
 	req->flags &= ~REQ_F_INFLIGHT;
-	put_files_struct(req->work.files);
-	put_nsproxy(req->work.nsproxy);
+	put_files_struct(req->work.identity->files);
+	put_nsproxy(req->work.identity->nsproxy);
 	req->work.flags &= ~IO_WQ_WORK_FILES;
 }
 
@@ -6056,14 +6056,14 @@ static void __io_queue_sqe(struct io_kiocb *req, struct io_comp_state *cs)
 again:
 	linked_timeout = io_prep_linked_timeout(req);
 
-	if ((req->flags & REQ_F_WORK_INITIALIZED) && req->work.creds &&
-	    req->work.creds != current_cred()) {
+	if ((req->flags & REQ_F_WORK_INITIALIZED) && req->work.identity->creds &&
+	    req->work.identity->creds != current_cred()) {
 		if (old_creds)
 			revert_creds(old_creds);
-		if (old_creds == req->work.creds)
+		if (old_creds == req->work.identity->creds)
 			old_creds = NULL; /* restored original creds */
 		else
-			old_creds = override_creds(req->work.creds);
+			old_creds = override_creds(req->work.identity->creds);
 		req->work.flags |= IO_WQ_WORK_CREDS;
 	}
 
@@ -6368,10 +6368,10 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	id = READ_ONCE(sqe->personality);
 	if (id) {
 		io_req_init_async(req);
-		req->work.creds = idr_find(&ctx->personality_idr, id);
-		if (unlikely(!req->work.creds))
+		req->work.identity->creds = idr_find(&ctx->personality_idr, id);
+		if (unlikely(!req->work.identity->creds))
 			return -EINVAL;
-		get_cred(req->work.creds);
+		get_cred(req->work.identity->creds);
 		req->work.flags |= IO_WQ_WORK_CREDS;
 	}
 
@@ -8241,7 +8241,7 @@ static bool io_wq_files_match(struct io_wq_work *work, void *data)
 	struct files_struct *files = data;
 
 	return !files || ((work->flags & IO_WQ_WORK_FILES) &&
-				work->files == files);
+				work->identity->files == files);
 }
 
 /*
@@ -8397,7 +8397,7 @@ static bool io_uring_cancel_files(struct io_ring_ctx *ctx,
 		spin_lock_irq(&ctx->inflight_lock);
 		list_for_each_entry(req, &ctx->inflight_list, inflight_entry) {
 			if (files && (req->work.flags & IO_WQ_WORK_FILES) &&
-			    req->work.files != files)
+			    req->work.identity->files != files)
 				continue;
 			/* req is being completed, ignore */
 			if (!refcount_inc_not_zero(&req->refs))
diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index 96315cfaf6d1..352aa6bbd36b 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -4,7 +4,18 @@
 
 #include <linux/sched.h>
 #include <linux/xarray.h>
-#include <linux/percpu-refcount.h>
+
+struct io_identity {
+	struct files_struct		*files;
+	struct mm_struct		*mm;
+#ifdef CONFIG_BLK_CGROUP
+	struct cgroup_subsys_state	*blkcg_css;
+#endif
+	const struct cred		*creds;
+	struct nsproxy			*nsproxy;
+	struct fs_struct		*fs;
+	unsigned long			fsize;
+};
 
 struct io_uring_task {
 	/* submission side */
-- 
2.28.0

