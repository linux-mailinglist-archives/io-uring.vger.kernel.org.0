Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BF95290923
	for <lists+io-uring@lfdr.de>; Fri, 16 Oct 2020 18:02:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410545AbgJPQCu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 16 Oct 2020 12:02:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2395555AbgJPQCu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 16 Oct 2020 12:02:50 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 586F5C0613D3
        for <io-uring@vger.kernel.org>; Fri, 16 Oct 2020 09:02:49 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id g16so1622038pjv.3
        for <io-uring@vger.kernel.org>; Fri, 16 Oct 2020 09:02:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1fWO/b5cbyKHfRHq/oA3HrSf/NULuRP2MbPcV0W6ikA=;
        b=wJR+1p+nEwlndhnx1W7fLbjdPh7xbUYtZxzaJ3gzsKTboeW+dgRysy8ayUmlZDXyIA
         FwOZK5LOGGvufvfO0JcZFDATaSyA9RQtpePn1hEuQDalrZr6XAR1XR66Pu0R8Oxt4q+Q
         yT6Pt26wL3zYS8Y9xglphKnbTNssCPD4cocSz08ATOBYWYamToW383T2/j1cEmF8Yax8
         zag20IChwXZxOENH0g6ZBWTliBPBA/S54Dyhy2+3op47rfy6SqZLLM8SoeUDqYg1tTy9
         sl5Yi9X3gapj1F92lLkh+xG1j0guP71EWTV8Obvqps7yN0nH3EDy6hVc2uR6P0HMwLGs
         pWqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1fWO/b5cbyKHfRHq/oA3HrSf/NULuRP2MbPcV0W6ikA=;
        b=D9jUyzo6zd0y/3S3qNcM5KZrj68m6SkeFghewuF/gbwkMJKCtJ5dCdMjcGEviJJqa+
         AoN2koTVMk5AUO/i2aXAqehxkNltm/sQthsxtgchvPDj3ExpbHtLsSQYmswNxf/4B4I+
         FU2kahMYzLJLg6F4uMAhX6BEII8u68mG928tMDlxVOZvZ7pSZifgowL4zg245KRHuA2o
         9E2tALzXJi204ZFLN0Zc8FnGzSA90czLRaXoeYUyce0kNS6lggq00U29l7CoL9KXw9CC
         5uZgd9PGDM3mI1UufRlwOPLeH3td1H1SjTnqLCoDlq6sEdIWPcnILVDAdLq0Xr8dzYxx
         FCHg==
X-Gm-Message-State: AOAM531wfhutiX//WIA77AgDgiwthbDPWTv1hatUP4w/nie1iA5e8Pnj
        IVP2DowRQzjeOLVa13m5Pf/Ka5XBgmRKIIAL
X-Google-Smtp-Source: ABdhPJzqB6YxHJRlVmZ+nAFmpEns5yey48C33AUJqaSx+fHvlvjEFT6keQoB7XjFQnyULuyISz1IGw==
X-Received: by 2002:a17:902:7b90:b029:d4:d9e5:e5bf with SMTP id w16-20020a1709027b90b02900d4d9e5e5bfmr4843313pll.83.1602864167247;
        Fri, 16 Oct 2020 09:02:47 -0700 (PDT)
Received: from p1.localdomain ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id t13sm3190109pfc.1.2020.10.16.09.02.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2020 09:02:46 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 15/18] io_uring: COW io_identity on mismatch
Date:   Fri, 16 Oct 2020 10:02:21 -0600
Message-Id: <20201016160224.1575329-16-axboe@kernel.dk>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201016160224.1575329-1-axboe@kernel.dk>
References: <20201016160224.1575329-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If the io_identity doesn't completely match the task, then create a
copy of it and use that. The existing copy remains valid until the last
user of it has gone away.

This also changes the personality lookup to be indexed by io_identity,
instead of creds directly.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c            | 222 ++++++++++++++++++++++++++++++---------
 include/linux/io_uring.h |   1 +
 2 files changed, 171 insertions(+), 52 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 2d192f065c43..3a85b8348135 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1040,6 +1040,27 @@ static inline void req_set_fail_links(struct io_kiocb *req)
 		req->flags |= REQ_F_FAIL_LINK;
 }
 
+/*
+ * None of these are dereferenced, they are simply used to check if any of
+ * them have changed. If we're under current and check they are still the
+ * same, we're fine to grab references to them for actual out-of-line use.
+ */
+static void io_init_identity(struct io_identity *id)
+{
+	id->files = current->files;
+	id->mm = current->mm;
+#ifdef CONFIG_BLK_CGROUP
+	rcu_read_lock();
+	id->blkcg_css = blkcg_css();
+	rcu_read_unlock();
+#endif
+	id->creds = current_cred();
+	id->nsproxy = current->nsproxy;
+	id->fs = current->fs;
+	id->fsize = rlimit(RLIMIT_FSIZE);
+	refcount_set(&id->count, 1);
+}
+
 /*
  * Note: must call io_req_init_async() for the first time you
  * touch any members of io_wq_work.
@@ -1051,6 +1072,7 @@ static inline void io_req_init_async(struct io_kiocb *req)
 
 	memset(&req->work, 0, sizeof(req->work));
 	req->flags |= REQ_F_WORK_INITIALIZED;
+	io_init_identity(&req->identity);
 	req->work.identity = &req->identity;
 }
 
@@ -1157,6 +1179,14 @@ static void __io_commit_cqring(struct io_ring_ctx *ctx)
 	}
 }
 
+static void io_put_identity(struct io_kiocb *req)
+{
+	if (req->work.identity == &req->identity)
+		return;
+	if (refcount_dec_and_test(&req->work.identity->count))
+		kfree(req->work.identity);
+}
+
 static void io_req_clean_work(struct io_kiocb *req)
 {
 	if (!(req->flags & REQ_F_WORK_INITIALIZED))
@@ -1189,28 +1219,67 @@ static void io_req_clean_work(struct io_kiocb *req)
 			free_fs_struct(fs);
 		req->work.flags &= ~IO_WQ_WORK_FS;
 	}
+
+	io_put_identity(req);
 }
 
-static void io_prep_async_work(struct io_kiocb *req)
+/*
+ * Create a private copy of io_identity, since some fields don't match
+ * the current context.
+ */
+static bool io_identity_cow(struct io_kiocb *req)
+{
+	const struct cred *creds = NULL;
+	struct io_identity *id;
+
+	if (req->work.flags & IO_WQ_WORK_CREDS)
+		creds = req->work.identity->creds;
+
+	id = kmemdup(req->work.identity, sizeof(*id), GFP_KERNEL);
+	if (unlikely(!id)) {
+		req->work.flags |= IO_WQ_WORK_CANCEL;
+		return false;
+	}
+
+	/*
+	 * We can safely just re-init the creds we copied  Either the field
+	 * matches the current one, or we haven't grabbed it yet. The only
+	 * exception is ->creds, through registered personalities, so handle
+	 * that one separately.
+	 */
+	io_init_identity(id);
+	if (creds)
+		req->work.identity->creds = creds;
+
+	/* add one for this request */
+	refcount_inc(&id->count);
+
+	/* drop old identity, assign new one. one ref for req, one for tctx */
+	if (req->work.identity != &req->identity &&
+	    refcount_sub_and_test(2, &req->work.identity->count))
+		kfree(req->work.identity);
+
+	req->work.identity = id;
+	return true;
+}
+
+static bool io_grab_identity(struct io_kiocb *req)
 {
 	const struct io_op_def *def = &io_op_defs[req->opcode];
+	struct io_identity *id = &req->identity;
 	struct io_ring_ctx *ctx = req->ctx;
 
-	io_req_init_async(req);
+	if (def->needs_fsize && id->fsize != rlimit(RLIMIT_FSIZE))
+		return false;
 
-	if (req->flags & REQ_F_ISREG) {
-		if (def->hash_reg_file || (ctx->flags & IORING_SETUP_IOPOLL))
-			io_wq_hash_work(&req->work, file_inode(req->file));
-	} else {
-		if (def->unbound_nonreg_file)
-			req->work.flags |= IO_WQ_WORK_UNBOUND;
-	}
 	if (!(req->work.flags & IO_WQ_WORK_FILES) &&
-	    (io_op_defs[req->opcode].work_flags & IO_WQ_WORK_FILES) &&
+	    (def->work_flags & IO_WQ_WORK_FILES) &&
 	    !(req->flags & REQ_F_NO_FILE_TABLE)) {
-		req->work.identity->files = get_files_struct(current);
-		get_nsproxy(current->nsproxy);
-		req->work.identity->nsproxy = current->nsproxy;
+		if (id->files != current->files ||
+		    id->nsproxy != current->nsproxy)
+			return false;
+		atomic_inc(&id->files->count);
+		get_nsproxy(id->nsproxy);
 		req->flags |= REQ_F_INFLIGHT;
 
 		spin_lock_irq(&ctx->inflight_lock);
@@ -1218,46 +1287,79 @@ static void io_prep_async_work(struct io_kiocb *req)
 		spin_unlock_irq(&ctx->inflight_lock);
 		req->work.flags |= IO_WQ_WORK_FILES;
 	}
-	if (!(req->work.flags & IO_WQ_WORK_MM) &&
-	    (def->work_flags & IO_WQ_WORK_MM)) {
-		mmgrab(current->mm);
-		req->work.identity->mm = current->mm;
-		req->work.flags |= IO_WQ_WORK_MM;
-	}
 #ifdef CONFIG_BLK_CGROUP
 	if (!(req->work.flags & IO_WQ_WORK_BLKCG) &&
 	    (def->work_flags & IO_WQ_WORK_BLKCG)) {
 		rcu_read_lock();
-		req->work.identity->blkcg_css = blkcg_css();
+		if (id->blkcg_css != blkcg_css()) {
+			rcu_read_unlock();
+			return false;
+		}
 		/*
 		 * This should be rare, either the cgroup is dying or the task
 		 * is moving cgroups. Just punt to root for the handful of ios.
 		 */
-		if (css_tryget_online(req->work.identity->blkcg_css))
+		if (css_tryget_online(id->blkcg_css))
 			req->work.flags |= IO_WQ_WORK_BLKCG;
 		rcu_read_unlock();
 	}
 #endif
 	if (!(req->work.flags & IO_WQ_WORK_CREDS)) {
-		req->work.identity->creds = get_current_cred();
+		if (id->creds != current_cred())
+			return false;
+		get_cred(id->creds);
 		req->work.flags |= IO_WQ_WORK_CREDS;
 	}
 	if (!(req->work.flags & IO_WQ_WORK_FS) &&
 	    (def->work_flags & IO_WQ_WORK_FS)) {
-		spin_lock(&current->fs->lock);
-		if (!current->fs->in_exec) {
-			req->work.identity->fs = current->fs;
-			req->work.identity->fs->users++;
+		if (current->fs != id->fs)
+			return false;
+		spin_lock(&id->fs->lock);
+		if (!id->fs->in_exec) {
+			id->fs->users++;
 			req->work.flags |= IO_WQ_WORK_FS;
 		} else {
 			req->work.flags |= IO_WQ_WORK_CANCEL;
 		}
 		spin_unlock(&current->fs->lock);
 	}
-	if (def->needs_fsize)
-		req->work.identity->fsize = rlimit(RLIMIT_FSIZE);
-	else
-		req->work.identity->fsize = RLIM_INFINITY;
+
+	return true;
+}
+
+static void io_prep_async_work(struct io_kiocb *req)
+{
+	const struct io_op_def *def = &io_op_defs[req->opcode];
+	struct io_identity *id = &req->identity;
+	struct io_ring_ctx *ctx = req->ctx;
+
+	io_req_init_async(req);
+
+	if (req->flags & REQ_F_ISREG) {
+		if (def->hash_reg_file || (ctx->flags & IORING_SETUP_IOPOLL))
+			io_wq_hash_work(&req->work, file_inode(req->file));
+	} else {
+		if (def->unbound_nonreg_file)
+			req->work.flags |= IO_WQ_WORK_UNBOUND;
+	}
+
+	/* ->mm can never change on us */
+	if (!(req->work.flags & IO_WQ_WORK_MM) &&
+	    (def->work_flags & IO_WQ_WORK_MM)) {
+		mmgrab(id->mm);
+		req->work.flags |= IO_WQ_WORK_MM;
+	}
+
+	/* if we fail grabbing identity, we must COW, regrab, and retry */
+	if (io_grab_identity(req))
+		return;
+
+	if (!io_identity_cow(req))
+		return;
+
+	/* can't fail at this point */
+	if (!io_grab_identity(req))
+		WARN_ON(1);
 }
 
 static void io_prep_async_link(struct io_kiocb *req)
@@ -1696,12 +1798,10 @@ static void io_dismantle_req(struct io_kiocb *req)
 
 static void __io_free_req(struct io_kiocb *req)
 {
-	struct io_uring_task *tctx;
-	struct io_ring_ctx *ctx;
+	struct io_uring_task *tctx = req->task->io_uring;
+	struct io_ring_ctx *ctx = req->ctx;
 
 	io_dismantle_req(req);
-	tctx = req->task->io_uring;
-	ctx = req->ctx;
 
 	atomic_long_inc(&tctx->req_complete);
 	if (tctx->in_idle)
@@ -6367,11 +6467,16 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 
 	id = READ_ONCE(sqe->personality);
 	if (id) {
+		struct io_identity *iod;
+
 		io_req_init_async(req);
-		req->work.identity->creds = idr_find(&ctx->personality_idr, id);
-		if (unlikely(!req->work.identity->creds))
+		iod = idr_find(&ctx->personality_idr, id);
+		if (unlikely(!iod))
 			return -EINVAL;
-		get_cred(req->work.identity->creds);
+		refcount_inc(&iod->count);
+		io_put_identity(req);
+		get_cred(iod->creds);
+		req->work.identity = iod;
 		req->work.flags |= IO_WQ_WORK_CREDS;
 	}
 
@@ -8164,11 +8269,14 @@ static int io_uring_fasync(int fd, struct file *file, int on)
 static int io_remove_personalities(int id, void *p, void *data)
 {
 	struct io_ring_ctx *ctx = data;
-	const struct cred *cred;
+	struct io_identity *iod;
 
-	cred = idr_remove(&ctx->personality_idr, id);
-	if (cred)
-		put_cred(cred);
+	iod = idr_remove(&ctx->personality_idr, id);
+	if (iod) {
+		put_cred(iod->creds);
+		if (refcount_dec_and_test(&iod->count))
+			kfree(iod);
+	}
 	return 0;
 }
 
@@ -9238,23 +9346,33 @@ static int io_probe(struct io_ring_ctx *ctx, void __user *arg, unsigned nr_args)
 
 static int io_register_personality(struct io_ring_ctx *ctx)
 {
-	const struct cred *creds = get_current_cred();
-	int id;
+	struct io_identity *id;
+	int ret;
 
-	id = idr_alloc_cyclic(&ctx->personality_idr, (void *) creds, 1,
-				USHRT_MAX, GFP_KERNEL);
-	if (id < 0)
-		put_cred(creds);
-	return id;
+	id = kmalloc(sizeof(*id), GFP_KERNEL);
+	if (unlikely(!id))
+		return -ENOMEM;
+
+	io_init_identity(id);
+	id->creds = get_current_cred();
+
+	ret = idr_alloc_cyclic(&ctx->personality_idr, id, 1, USHRT_MAX, GFP_KERNEL);
+	if (ret < 0) {
+		put_cred(id->creds);
+		kfree(id);
+	}
+	return ret;
 }
 
 static int io_unregister_personality(struct io_ring_ctx *ctx, unsigned id)
 {
-	const struct cred *old_creds;
+	struct io_identity *iod;
 
-	old_creds = idr_remove(&ctx->personality_idr, id);
-	if (old_creds) {
-		put_cred(old_creds);
+	iod = idr_remove(&ctx->personality_idr, id);
+	if (iod) {
+		put_cred(iod->creds);
+		if (refcount_dec_and_test(&iod->count))
+			kfree(iod);
 		return 0;
 	}
 
diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index 352aa6bbd36b..342cc574d5c0 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -15,6 +15,7 @@ struct io_identity {
 	struct nsproxy			*nsproxy;
 	struct fs_struct		*fs;
 	unsigned long			fsize;
+	refcount_t			count;
 };
 
 struct io_uring_task {
-- 
2.28.0

