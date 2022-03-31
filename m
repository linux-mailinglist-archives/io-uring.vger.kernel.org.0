Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B3644EE18A
	for <lists+io-uring@lfdr.de>; Thu, 31 Mar 2022 21:15:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231398AbiCaTQm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 31 Mar 2022 15:16:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238640AbiCaTQl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 31 Mar 2022 15:16:41 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E19E60DA7
        for <io-uring@vger.kernel.org>; Thu, 31 Mar 2022 12:14:53 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id 8so481676ilq.4
        for <io-uring@vger.kernel.org>; Thu, 31 Mar 2022 12:14:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:from
         :subject:content-transfer-encoding;
        bh=nQmTj0sday0Ov5/qAiE2GvMp3p9VdvBqpoHfsBdYNig=;
        b=pjfLad/2zTzMSwwPTqCPDzG0jkjCh4SLAYYMlrjjB9Fehd4NPgYvhkKuRqy2YMJ3pH
         wYeodigpW1GXtTHGXGHJOXZSHpUrlyCYhFvt5XK7aqo0pR37doGpe9oWuiRDhI8lz7DW
         DtQpT5kcDUkTr17oiLky2r+HonSBnrOG0kcc2HLEOuyVzd6XeRxfZn/1dMzCwPfTRrGP
         RAPXD1YNqt7p16wr96x1Yjc4wDs3qYfqcVqYnOtLI4DQ2lE6/mPN9En2OkfDGajmpf81
         emaXK9eR2MfOlyYI1wp22JnQU4k9Ze7mPp7AorMUud0YDLpHpemI86penEGmcrEffiQc
         nRLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:from:subject:content-transfer-encoding;
        bh=nQmTj0sday0Ov5/qAiE2GvMp3p9VdvBqpoHfsBdYNig=;
        b=z+9MtXpfV2iMubovBRNbRzw6OMC5OWXfHglufGzLjH7Lr5Ba9gKzlrGsOFoTy5Mfg6
         h4SGQ9kHnTd61OjR77T1qXMKk8jwgwiRTUPer2BWOhSz0nNd7dMLp5fzOnXmpefhwhNI
         CF/UCgE5cKbbTWDWrwlHHz/CQsVAZdczWGBTn7VyMQyjg2XEagW36thJPBJ3lFn2fdK9
         WWLUgLM7YJ15CIiWN/Amp0+A+BW77PNuP2h8N9rdIXcXWNY54+PJsQbVuvfmTI4nTzyP
         AbjljhjEJ1+8gyAyyq/ScJBBoeF+GR6j3TAUvLyEyij9kY2aBf3dBdktR1gUNcXsr7C0
         MJww==
X-Gm-Message-State: AOAM530QVdL3sEkQ3w19kVeaLMYdDqsbEorSo85whBzbEWzbeeMYDVV9
        K519FU3KFRfRhpChNfbT6Q8PQuWYvx9UbgOz
X-Google-Smtp-Source: ABdhPJyvkivqD0FkZoFgBp4ku2zw+zlYzLL+/LX+bFs8A7ns7vKxcSDf91m/BbQbDvl1LgOPqmMuJg==
X-Received: by 2002:a05:6e02:1caa:b0:2c8:811f:56ba with SMTP id x10-20020a056e021caa00b002c8811f56bamr14083319ill.90.1648754092048;
        Thu, 31 Mar 2022 12:14:52 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id p18-20020a92c112000000b002c9cf295661sm134211ile.78.2022.03.31.12.14.51
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Mar 2022 12:14:51 -0700 (PDT)
Message-ID: <06f02d41-361b-c66a-46b6-c9a90d4edcc2@kernel.dk>
Date:   Thu, 31 Mar 2022 13:14:51 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v2] io_uring: drop the old style inflight file tracking
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
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

Fixes: 734a69489dd7 ("io_uring: defer file assignment")
Reported-by: syzbot+c4b9303500a21750b250@syzkaller.appspotmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

v2: right after sending out v1 I realized that we can then also kill
    the weird cancelation hacks we have for retaining a tracked file
    across punt. Kill it with fire, this drops even more dead code.

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 00bc123ab5e7..a607d023c85c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -113,8 +113,7 @@
 			IOSQE_IO_DRAIN | IOSQE_CQE_SKIP_SUCCESS)
 
 #define IO_REQ_CLEAN_FLAGS (REQ_F_BUFFER_SELECTED | REQ_F_NEED_CLEANUP | \
-				REQ_F_POLLED | REQ_F_INFLIGHT | REQ_F_CREDS | \
-				REQ_F_ASYNC_DATA)
+				REQ_F_POLLED | REQ_F_CREDS | REQ_F_ASYNC_DATA)
 
 #define IO_TCTX_REFS_CACHE_NR	(1U << 10)
 
@@ -501,7 +500,6 @@ struct io_uring_task {
 	const struct io_ring_ctx *last;
 	struct io_wq		*io_wq;
 	struct percpu_counter	inflight;
-	atomic_t		inflight_tracked;
 	atomic_t		in_idle;
 
 	spinlock_t		task_lock;
@@ -1190,6 +1188,7 @@ static int __io_register_rsrc_update(struct io_ring_ctx *ctx, unsigned type,
 static void io_clean_op(struct io_kiocb *req);
 static struct file *io_file_get(struct io_ring_ctx *ctx,
 				struct io_kiocb *req, int fd, bool fixed);
+static void io_drop_inflight_file(struct io_kiocb *req);
 static void __io_queue_sqe(struct io_kiocb *req);
 static void io_rsrc_put_work(struct work_struct *work);
 
@@ -1430,29 +1429,9 @@ static bool io_match_task(struct io_kiocb *head, struct task_struct *task,
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
@@ -1462,24 +1441,9 @@ static bool io_match_linked(struct io_kiocb *head)
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
@@ -1642,14 +1606,6 @@ static inline bool io_req_ffs_set(struct io_kiocb *req)
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
@@ -2560,6 +2516,8 @@ static void io_req_task_work_add(struct io_kiocb *req, bool priority)
 
 	WARN_ON_ONCE(!tctx);
 
+	io_drop_inflight_file(req);
+
 	spin_lock_irqsave(&tctx->task_lock, flags);
 	if (priority)
 		wq_list_add_tail(&req->io_task_work.node, &tctx->prior_task_list);
@@ -7198,11 +7156,6 @@ static void io_clean_op(struct io_kiocb *req)
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
@@ -7487,6 +7440,19 @@ static inline struct file *io_file_get_fixed(struct io_ring_ctx *ctx,
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
@@ -7495,8 +7461,8 @@ static struct file *io_file_get_normal(struct io_ring_ctx *ctx,
 	trace_io_uring_file_get(ctx, req, req->user_data, fd);
 
 	/* we don't allow fixed io_uring files */
-	if (file && unlikely(file->f_op == &io_uring_fops))
-		io_req_track_inflight(req);
+	if (unlikely(file && unlikely(file->f_op == &io_uring_fops)))
+		req->flags |= REQ_F_INFLIGHT;
 	return file;
 }
 
@@ -9412,7 +9378,6 @@ static __cold int io_uring_alloc_task_context(struct task_struct *task,
 	xa_init(&tctx->xa);
 	init_waitqueue_head(&tctx->wait);
 	atomic_set(&tctx->in_idle, 0);
-	atomic_set(&tctx->inflight_tracked, 0);
 	task->io_uring = tctx;
 	spin_lock_init(&tctx->task_lock);
 	INIT_WQ_LIST(&tctx->task_list);
@@ -10605,7 +10570,7 @@ static __cold void io_uring_clean_tctx(struct io_uring_task *tctx)
 static s64 tctx_inflight(struct io_uring_task *tctx, bool tracked)
 {
 	if (tracked)
-		return atomic_read(&tctx->inflight_tracked);
+		return 0;
 	return percpu_counter_sum(&tctx->inflight);
 }
 
-- 
Jens Axboe

