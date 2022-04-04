Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3609F4F2129
	for <lists+io-uring@lfdr.de>; Tue,  5 Apr 2022 06:09:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbiDECl3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 Apr 2022 22:41:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229781AbiDEClH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 Apr 2022 22:41:07 -0400
Received: from mail-qv1-xf2f.google.com (mail-qv1-xf2f.google.com [IPv6:2607:f8b0:4864:20::f2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FC3E2DF655
        for <io-uring@vger.kernel.org>; Mon,  4 Apr 2022 18:45:45 -0700 (PDT)
Received: by mail-qv1-xf2f.google.com with SMTP id cs16so3221382qvb.8
        for <io-uring@vger.kernel.org>; Mon, 04 Apr 2022 18:45:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KvlgjAMBJpEOSFKwyQETn2gddUoYb0oXK9fI5RyXNPA=;
        b=FuDds0TAHSq3lyjtHTiKvjdoTzfJO/T8/P2HuIklV5EDj/IKiL7+7Yty75TB3wAtIb
         acXmoqKftl2piLO0fxzmQbVGpSI6gEXv03vq/1TjXzlaH55g0ZDMSA26SVS9vUIQ+ut8
         hAgkXz729P0DV487DGKipTph8yEX4RU6amrDk/+CaIXCaDpm/w33hpgDShdTiqAeOC0J
         VVWh80sroNVqp/pNSekHfW996GP2CSLEQlYzCe37de3wDZWLBOhhIMEzRKYS5+mJXH8y
         ThSM5GWSS6fVg07CWvtur2j5v1+77Rt1hcjh9d37zcDrl94G7FQeMjFey6Idc0bR2Lh9
         lWoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KvlgjAMBJpEOSFKwyQETn2gddUoYb0oXK9fI5RyXNPA=;
        b=lRQ/jKy/jgOGGLsidUvFIGqHKGGPkYW4kA94JcryRO4gX6bWUqGIMmp86ErxuScuKL
         Donmku8bEpw9RlyrITViIsdk7jbwGrSpoXu3RpsUCE09dE9U5da91H7Y1s0eymZf3tus
         75ckkWrHGR3fqsTsy4dY2rSUCrwl703Smyngx+KmGTB6cQf7pVwMi5RBuLQbSymMQ82d
         1NDVFG/bockVbpluWXYoi81w2EH50/+RsukjucO0wZZ7h/P6qD28hN/QFSNTRfDRwaTx
         dKUU3M41brQGYnkfzZrKYyqyoLkTuKZkp2w4kDnx3PCtsAzOVNbzS1IoW47klqHQwT7X
         /idQ==
X-Gm-Message-State: AOAM5307t3rQ9zt3nr9bB9v4/I9oZjEwT8XnQ+rFBHEbwpmXEk1Zs+nM
        Mc2uzftKpQqPIfjse4d1vI8rwacKUbX6pg==
X-Google-Smtp-Source: ABdhPJz7hcT+rpBkxuvAZDq/KvPoZwePzHXRXcewOeWCVRuQzd1stEcdeRjRDoFAHZgQ51xJdphp9Q==
X-Received: by 2002:a05:6a00:b95:b0:4fa:ec15:7eb7 with SMTP id g21-20020a056a000b9500b004faec157eb7mr833060pfj.74.1649116600382;
        Mon, 04 Apr 2022 16:56:40 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id i7-20020a628707000000b004fa6eb33b02sm13157977pfe.49.2022.04.04.16.56.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Apr 2022 16:56:40 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        syzbot+c4b9303500a21750b250@syzkaller.appspotmail.com
Subject: [PATCH 6/6] io_uring: drop the old style inflight file tracking
Date:   Mon,  4 Apr 2022 17:56:26 -0600
Message-Id: <20220404235626.374753-7-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220404235626.374753-1-axboe@kernel.dk>
References: <20220404235626.374753-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_uring tracks requests that are referencing an io_uring descriptor to
be able to cancel without worrying about loops in the references. Since
we now assign the file at execution time, the easier approach is to drop
a potentially problematic reference before we punt the request. This
eliminates the need to special case these types of files beyond just
marking them as such, and simplifies cancelation quite a bit.

This also fixes a recent issue where an async punted tee operation would
with the io_uring descriptor as the output file would crash when
attempting to get a reference to the file from the io-wq worker. We
could have worked around that, but this is the much cleaner fix.

Fixes: 741bfcae2afe ("io_uring: defer file assignment")
Reported-by: syzbot+c4b9303500a21750b250@syzkaller.appspotmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 85 ++++++++++++++++-----------------------------------
 1 file changed, 27 insertions(+), 58 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c2118b07640b..b28ac067e4cc 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -112,8 +112,7 @@
 			IOSQE_IO_DRAIN | IOSQE_CQE_SKIP_SUCCESS)
 
 #define IO_REQ_CLEAN_FLAGS (REQ_F_BUFFER_SELECTED | REQ_F_NEED_CLEANUP | \
-				REQ_F_POLLED | REQ_F_INFLIGHT | REQ_F_CREDS | \
-				REQ_F_ASYNC_DATA)
+				REQ_F_POLLED | REQ_F_CREDS | REQ_F_ASYNC_DATA)
 
 #define IO_TCTX_REFS_CACHE_NR	(1U << 10)
 
@@ -500,7 +499,6 @@ struct io_uring_task {
 	const struct io_ring_ctx *last;
 	struct io_wq		*io_wq;
 	struct percpu_counter	inflight;
-	atomic_t		inflight_tracked;
 	atomic_t		in_idle;
 
 	spinlock_t		task_lock;
@@ -1186,6 +1184,8 @@ static void io_clean_op(struct io_kiocb *req);
 static struct file *io_file_get(struct io_ring_ctx *ctx,
 				struct io_kiocb *req, int fd, bool fixed,
 				bool locked);
+static void io_drop_inflight_file(struct io_kiocb *req);
+static bool io_assign_file(struct io_kiocb *req, bool locked);
 static void __io_queue_sqe(struct io_kiocb *req);
 static void io_rsrc_put_work(struct work_struct *work);
 
@@ -1431,29 +1431,9 @@ static bool io_match_task(struct io_kiocb *head, struct task_struct *task,
 			  bool cancel_all)
 	__must_hold(&req->ctx->timeout_lock)
 {
-	struct io_kiocb *req;
-
 	if (task && head->task != task)
 		return false;
-	if (cancel_all)
-		return true;
-
-	io_for_each_link(req, head) {
-		if (req->flags & REQ_F_INFLIGHT)
-			return true;
-	}
-	return false;
-}
-
-static bool io_match_linked(struct io_kiocb *head)
-{
-	struct io_kiocb *req;
-
-	io_for_each_link(req, head) {
-		if (req->flags & REQ_F_INFLIGHT)
-			return true;
-	}
-	return false;
+	return cancel_all;
 }
 
 /*
@@ -1463,24 +1443,9 @@ static bool io_match_linked(struct io_kiocb *head)
 static bool io_match_task_safe(struct io_kiocb *head, struct task_struct *task,
 			       bool cancel_all)
 {
-	bool matched;
-
 	if (task && head->task != task)
 		return false;
-	if (cancel_all)
-		return true;
-
-	if (head->flags & REQ_F_LINK_TIMEOUT) {
-		struct io_ring_ctx *ctx = head->ctx;
-
-		/* protect against races with linked timeouts */
-		spin_lock_irq(&ctx->timeout_lock);
-		matched = io_match_linked(head);
-		spin_unlock_irq(&ctx->timeout_lock);
-	} else {
-		matched = io_match_linked(head);
-	}
-	return matched;
+	return cancel_all;
 }
 
 static inline bool req_has_async_data(struct io_kiocb *req)
@@ -1643,14 +1608,6 @@ static inline bool io_req_ffs_set(struct io_kiocb *req)
 	return req->flags & REQ_F_FIXED_FILE;
 }
 
-static inline void io_req_track_inflight(struct io_kiocb *req)
-{
-	if (!(req->flags & REQ_F_INFLIGHT)) {
-		req->flags |= REQ_F_INFLIGHT;
-		atomic_inc(&current->io_uring->inflight_tracked);
-	}
-}
-
 static struct io_kiocb *__io_prep_linked_timeout(struct io_kiocb *req)
 {
 	if (WARN_ON_ONCE(!req->link))
@@ -2561,6 +2518,8 @@ static void io_req_task_work_add(struct io_kiocb *req, bool priority)
 
 	WARN_ON_ONCE(!tctx);
 
+	io_drop_inflight_file(req);
+
 	spin_lock_irqsave(&tctx->task_lock, flags);
 	if (priority)
 		wq_list_add_tail(&req->io_task_work.node, &tctx->prior_task_list);
@@ -6005,7 +5964,10 @@ static int io_poll_check_events(struct io_kiocb *req, bool locked)
 		if (!req->result) {
 			struct poll_table_struct pt = { ._key = req->cflags };
 
-			req->result = vfs_poll(req->file, &pt) & req->cflags;
+			if (unlikely(!io_assign_file(req, locked)))
+				req->result = -EBADF;
+			else
+				req->result = vfs_poll(req->file, &pt) & req->cflags;
 		}
 
 		/* multishot, just fill an CQE and proceed */
@@ -7223,11 +7185,6 @@ static void io_clean_op(struct io_kiocb *req)
 		kfree(req->apoll);
 		req->apoll = NULL;
 	}
-	if (req->flags & REQ_F_INFLIGHT) {
-		struct io_uring_task *tctx = req->task->io_uring;
-
-		atomic_dec(&tctx->inflight_tracked);
-	}
 	if (req->flags & REQ_F_CREDS)
 		put_cred(req->creds);
 	if (req->flags & REQ_F_ASYNC_DATA) {
@@ -7511,6 +7468,19 @@ static inline struct file *io_file_get_fixed(struct io_ring_ctx *ctx,
 	return file;
 }
 
+/*
+ * Drop the file for requeue operations. Only used of req->file is the
+ * io_uring descriptor itself.
+ */
+static void io_drop_inflight_file(struct io_kiocb *req)
+{
+	if (unlikely(req->flags & REQ_F_INFLIGHT)) {
+		fput(req->file);
+		req->file = NULL;
+		req->flags &= ~REQ_F_INFLIGHT;
+	}
+}
+
 static struct file *io_file_get_normal(struct io_ring_ctx *ctx,
 				       struct io_kiocb *req, int fd)
 {
@@ -7519,8 +7489,8 @@ static struct file *io_file_get_normal(struct io_ring_ctx *ctx,
 	trace_io_uring_file_get(ctx, req, req->user_data, fd);
 
 	/* we don't allow fixed io_uring files */
-	if (file && unlikely(file->f_op == &io_uring_fops))
-		io_req_track_inflight(req);
+	if (unlikely(file && unlikely(file->f_op == &io_uring_fops)))
+		req->flags |= REQ_F_INFLIGHT;
 	return file;
 }
 
@@ -9437,7 +9407,6 @@ static __cold int io_uring_alloc_task_context(struct task_struct *task,
 	xa_init(&tctx->xa);
 	init_waitqueue_head(&tctx->wait);
 	atomic_set(&tctx->in_idle, 0);
-	atomic_set(&tctx->inflight_tracked, 0);
 	task->io_uring = tctx;
 	spin_lock_init(&tctx->task_lock);
 	INIT_WQ_LIST(&tctx->task_list);
@@ -10630,7 +10599,7 @@ static __cold void io_uring_clean_tctx(struct io_uring_task *tctx)
 static s64 tctx_inflight(struct io_uring_task *tctx, bool tracked)
 {
 	if (tracked)
-		return atomic_read(&tctx->inflight_tracked);
+		return 0;
 	return percpu_counter_sum(&tctx->inflight);
 }
 
-- 
2.35.1

