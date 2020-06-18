Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40BAF1FF543
	for <lists+io-uring@lfdr.de>; Thu, 18 Jun 2020 16:46:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730957AbgFROqS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 18 Jun 2020 10:46:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730949AbgFROoG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 18 Jun 2020 10:44:06 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E08D0C06174E
        for <io-uring@vger.kernel.org>; Thu, 18 Jun 2020 07:44:05 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id j12so660367pfn.10
        for <io-uring@vger.kernel.org>; Thu, 18 Jun 2020 07:44:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references:reply-to
         :mime-version:content-transfer-encoding;
        bh=tVJM5ezTdcIMG+aKDW1osETe1l5d87INy1YG0FUdQcM=;
        b=veVE78EJYXVACUi1db6AgzNJIzh1hHgYOEDwJ41A29iyHkJ0tRhmtt2MLXV57P+t9T
         huAegqWFdBcpK4nimSirWfSC0b9sPD6lnc/YrwOmnptgxWF7i9cd+CEONozpAruie+nd
         wPqh4hcqGMRiDgDp72UNJ9uJRJ3Tm6xYgQAXv7jwxFhQBMol00k7MbnVC0E69rPw6FIM
         7UKG7C5tnxjAntploc2dKWqJuB+isxJpInUjNRMdqtbp8QrgmRcJRGjgnIdC2OqwERSf
         xgxD3JLAUc+AU3m+cc8OrVO8os02InMtoRgHoCVgMKC/eW5Z+iV6e3xMpQFkEs3n9M84
         vhKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:reply-to:mime-version:content-transfer-encoding;
        bh=tVJM5ezTdcIMG+aKDW1osETe1l5d87INy1YG0FUdQcM=;
        b=AXCmS+EOG6b2TguOKXouHgl2c8se5UOSoR8NVWPoIdPdrXKIhvl/x3o3qaaRUP504f
         h2JolnJ3+J1OHtG2gt4WsR8g6V/Ygb2ydv/RTFH5IOA0xeIxHT7X90+x/hjukvyoEMuT
         Vy10erhCuOkkxq5z0O7tzVWaUn0w747QmEWc/iddc7X1EV4jWh0TM9viWu4qMZRHkIBu
         B0v34ib840mKvo/5qB4hYSKWQFyVqC2mX1F43f/nl2dtawXm6gkL6n7nmMpdCnTGeMzn
         H4zHn0CPWfMPO5tlpkTI9CnOtZW6Z6WD1rlx9+ma8kZoCND0FVUKR4g+4X5WeHAaXNtw
         0UbQ==
X-Gm-Message-State: AOAM530cg2dyYynAL0nW+lGNKCJvZu17J1kkyqPRJAJ342AHqRIUXhQ3
        zCBW+oIHLaVgsd+JebF2o+zde+2p9ohFZw==
X-Google-Smtp-Source: ABdhPJybozkuJOyPuS+aF/bntPw1nY8EdCmOZ0hRiMVA9zO7UZT6xbjz8eMsCaZwMXp2bvsabGcJ4A==
X-Received: by 2002:aa7:9537:: with SMTP id c23mr3848900pfp.149.1592491444963;
        Thu, 18 Jun 2020 07:44:04 -0700 (PDT)
Received: from x1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id g9sm3127197pfm.151.2020.06.18.07.44.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jun 2020 07:44:04 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, akpm@linux-foundation.org,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 04/15] io_uring: re-issue block requests that failed because of resources
Date:   Thu, 18 Jun 2020 08:43:44 -0600
Message-Id: <20200618144355.17324-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200618144355.17324-1-axboe@kernel.dk>
References: <20200618144355.17324-1-axboe@kernel.dk>
Reply-To: "[PATCHSET v7 0/15]"@vger.kernel.org, Add@vger.kernel.org,
          support@vger.kernel.org, for@vger.kernel.org,
          async@vger.kernel.org, buffered@vger.kernel.org,
          reads@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Mark the plug with nowait == true, which will cause requests to avoid
blocking on request allocation. If they do, we catch them and reissue
them from a task_work based handler.

Normally we can catch -EAGAIN directly, but the hard case is for split
requests. As an example, the application issues a 512KB request. The
block core will split this into 128KB if that's the max size for the
device. The first request issues just fine, but we run into -EAGAIN for
some latter splits for the same request. As the bio is split, we don't
get to see the -EAGAIN until one of the actual reads complete, and hence
we cannot handle it inline as part of submission.

This does potentially cause re-reads of parts of the range, as the whole
request is reissued. There's currently no better way to handle this.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 148 ++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 124 insertions(+), 24 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 2e257c5a1866..40413fb9d07b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -900,6 +900,13 @@ static int io_file_get(struct io_submit_state *state, struct io_kiocb *req,
 static void __io_queue_sqe(struct io_kiocb *req,
 			   const struct io_uring_sqe *sqe);
 
+static ssize_t io_import_iovec(int rw, struct io_kiocb *req,
+			       struct iovec **iovec, struct iov_iter *iter,
+			       bool needs_lock);
+static int io_setup_async_rw(struct io_kiocb *req, ssize_t io_size,
+			     struct iovec *iovec, struct iovec *fast_iov,
+			     struct iov_iter *iter);
+
 static struct kmem_cache *req_cachep;
 
 static const struct file_operations io_uring_fops;
@@ -1978,12 +1985,115 @@ static void io_complete_rw_common(struct kiocb *kiocb, long res)
 	__io_cqring_add_event(req, res, cflags);
 }
 
+static void io_sq_thread_drop_mm(struct io_ring_ctx *ctx)
+{
+	struct mm_struct *mm = current->mm;
+
+	if (mm) {
+		kthread_unuse_mm(mm);
+		mmput(mm);
+	}
+}
+
+static int io_sq_thread_acquire_mm(struct io_ring_ctx *ctx,
+				   struct io_kiocb *req)
+{
+	if (io_op_defs[req->opcode].needs_mm && !current->mm) {
+		if (unlikely(!mmget_not_zero(ctx->sqo_mm)))
+			return -EFAULT;
+		kthread_use_mm(ctx->sqo_mm);
+	}
+
+	return 0;
+}
+
+#ifdef CONFIG_BLOCK
+static bool io_resubmit_prep(struct io_kiocb *req, int error)
+{
+	struct iovec inline_vecs[UIO_FASTIOV], *iovec = inline_vecs;
+	ssize_t ret = -ECANCELED;
+	struct iov_iter iter;
+	int rw;
+
+	if (error) {
+		ret = error;
+		goto end_req;
+	}
+
+	switch (req->opcode) {
+	case IORING_OP_READV:
+	case IORING_OP_READ_FIXED:
+	case IORING_OP_READ:
+		rw = READ;
+		break;
+	case IORING_OP_WRITEV:
+	case IORING_OP_WRITE_FIXED:
+	case IORING_OP_WRITE:
+		rw = WRITE;
+		break;
+	default:
+		printk_once(KERN_WARNING "io_uring: bad opcode in resubmit %d\n",
+				req->opcode);
+		goto end_req;
+	}
+
+	ret = io_import_iovec(rw, req, &iovec, &iter, false);
+	if (ret < 0)
+		goto end_req;
+	ret = io_setup_async_rw(req, ret, iovec, inline_vecs, &iter);
+	if (!ret)
+		return true;
+	kfree(iovec);
+end_req:
+	io_cqring_add_event(req, ret);
+	req_set_fail_links(req);
+	io_put_req(req);
+	return false;
+}
+
+static void io_rw_resubmit(struct callback_head *cb)
+{
+	struct io_kiocb *req = container_of(cb, struct io_kiocb, task_work);
+	struct io_ring_ctx *ctx = req->ctx;
+	int err;
+
+	__set_current_state(TASK_RUNNING);
+
+	err = io_sq_thread_acquire_mm(ctx, req);
+
+	if (io_resubmit_prep(req, err)) {
+		refcount_inc(&req->refs);
+		io_queue_async_work(req);
+	}
+}
+#endif
+
+static bool io_rw_reissue(struct io_kiocb *req, long res)
+{
+#ifdef CONFIG_BLOCK
+	struct task_struct *tsk;
+	int ret;
+
+	if ((res != -EAGAIN && res != -EOPNOTSUPP) || io_wq_current_is_worker())
+		return false;
+
+	tsk = req->task;
+	init_task_work(&req->task_work, io_rw_resubmit);
+	ret = task_work_add(tsk, &req->task_work, true);
+	if (!ret)
+		return true;
+#endif
+	return false;
+}
+
 static void io_complete_rw(struct kiocb *kiocb, long res, long res2)
 {
 	struct io_kiocb *req = container_of(kiocb, struct io_kiocb, rw.kiocb);
 
-	io_complete_rw_common(kiocb, res);
-	io_put_req(req);
+	if (!io_rw_reissue(req, res)) {
+		io_complete_rw_common(kiocb, res);
+		io_put_req(req);
+	}
 }
 
 static void io_complete_rw_iopoll(struct kiocb *kiocb, long res, long res2)
@@ -2169,6 +2279,9 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	if (kiocb->ki_flags & IOCB_NOWAIT)
 		req->flags |= REQ_F_NOWAIT;
 
+	if (kiocb->ki_flags & IOCB_DIRECT)
+		io_get_req_task(req);
+
 	if (force_nonblock)
 		kiocb->ki_flags |= IOCB_NOWAIT;
 
@@ -2668,6 +2781,7 @@ static int io_read(struct io_kiocb *req, bool force_nonblock)
 	iov_count = iov_iter_count(&iter);
 	ret = rw_verify_area(READ, req->file, &kiocb->ki_pos, iov_count);
 	if (!ret) {
+		unsigned long nr_segs = iter.nr_segs;
 		ssize_t ret2 = 0;
 
 		if (req->file->f_op->read_iter)
@@ -2679,6 +2793,8 @@ static int io_read(struct io_kiocb *req, bool force_nonblock)
 		if (!force_nonblock || (ret2 != -EAGAIN && ret2 != -EIO)) {
 			kiocb_done(kiocb, ret2);
 		} else {
+			iter.count = iov_count;
+			iter.nr_segs = nr_segs;
 copy_iov:
 			ret = io_setup_async_rw(req, io_size, iovec,
 						inline_vecs, &iter);
@@ -2765,6 +2881,7 @@ static int io_write(struct io_kiocb *req, bool force_nonblock)
 	iov_count = iov_iter_count(&iter);
 	ret = rw_verify_area(WRITE, req->file, &kiocb->ki_pos, iov_count);
 	if (!ret) {
+		unsigned long nr_segs = iter.nr_segs;
 		ssize_t ret2;
 
 		/*
@@ -2802,6 +2919,8 @@ static int io_write(struct io_kiocb *req, bool force_nonblock)
 		if (!force_nonblock || ret2 != -EAGAIN) {
 			kiocb_done(kiocb, ret2);
 		} else {
+			iter.count = iov_count;
+			iter.nr_segs = nr_segs;
 copy_iov:
 			ret = io_setup_async_rw(req, io_size, iovec,
 						inline_vecs, &iter);
@@ -4282,28 +4401,6 @@ static void io_async_queue_proc(struct file *file, struct wait_queue_head *head,
 	__io_queue_proc(&pt->req->apoll->poll, pt, head);
 }
 
-static void io_sq_thread_drop_mm(struct io_ring_ctx *ctx)
-{
-	struct mm_struct *mm = current->mm;
-
-	if (mm) {
-		kthread_unuse_mm(mm);
-		mmput(mm);
-	}
-}
-
-static int io_sq_thread_acquire_mm(struct io_ring_ctx *ctx,
-				   struct io_kiocb *req)
-{
-	if (io_op_defs[req->opcode].needs_mm && !current->mm) {
-		if (unlikely(!mmget_not_zero(ctx->sqo_mm)))
-			return -EFAULT;
-		kthread_use_mm(ctx->sqo_mm);
-	}
-
-	return 0;
-}
-
 static void io_async_task_func(struct callback_head *cb)
 {
 	struct io_kiocb *req = container_of(cb, struct io_kiocb, task_work);
@@ -5814,6 +5911,9 @@ static void io_submit_state_start(struct io_submit_state *state,
 				  unsigned int max_ios)
 {
 	blk_start_plug(&state->plug);
+#ifdef CONFIG_BLOCK
+	state->plug.nowait = true;
+#endif
 	state->free_reqs = 0;
 	state->file = NULL;
 	state->ios_left = max_ios;
-- 
2.27.0

