Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 551A3266A0D
	for <lists+io-uring@lfdr.de>; Fri, 11 Sep 2020 23:28:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725816AbgIKV2g (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 11 Sep 2020 17:28:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725815AbgIKV2d (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 11 Sep 2020 17:28:33 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E688BC061573
        for <io-uring@vger.kernel.org>; Fri, 11 Sep 2020 14:28:32 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id j7so1473383plk.11
        for <io-uring@vger.kernel.org>; Fri, 11 Sep 2020 14:28:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AD200LRnQmvlmzphQ9AJYkUP1OvoYIq8lrCQapDUH/o=;
        b=IFaRSP0mF1/VK49EqmXgBgYrIpuVAywjWMfqF8yyH21hleW+aa+cBETcxZCm3dgE3X
         Dln1+KEkoR50C7BANjzd62dpACDSt7hABVELnYO5vPjgTC3OVsvi7nZWjDTJSwjBdLqo
         h5eNz89/aScDjJusWWXj4kn6lFAdyULx0o5+9urpYCzjTZBNnXgy3qRI1BJi5uGNlf9y
         uu5UlsXusCHAC/GiIvuzJUprrsREK40RToxB+HdH28LsfRsFKM9EaO9tS0nGt0aW1pyr
         egAtBEJhXtOQRTSsxasElNdB54i0JIhwi3g66CJdtNUYt3yVzPpysUhhhrrAOopI5Wlv
         suxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AD200LRnQmvlmzphQ9AJYkUP1OvoYIq8lrCQapDUH/o=;
        b=aKNKua6XYUPCX2t5yk5eK9Us65ekaiC/JaUkh5wZzwNeh9zbmOLTU/giWa7yJDigse
         x9Q156yj3GNRZeWe9XqU0QjZp1ndOa1OVbfS7/t1hFf6CDUnzxEjlBOy52Y6g4R3EZFP
         R0hlBrj0SAwmXkSAZVhUS6VXGwuTkwpESGhLfKPmIMcPJhHlEnjamZr2eBsGL4ll9CqM
         bdIPTZkxd9yaL8cMlWK7tpdm9SRJugBBFJDLg6JG/OPoDpBsAPznM6dl1lxQA1W8N5tT
         22dzKir8Zz4YJ1oxy8gWMMaXgSq1cwVIE4j8zMYaL7tGHkyi4xdxFQ97JBpDPw/koty6
         2GUw==
X-Gm-Message-State: AOAM531qwfoPzDiC2QYeZZLbgC6tdGJmrVoHO65h8WHvRyvucbsepPxB
        LOC+ts29rUeIfBcg2q1D+zLeLHDrKV8IUeBh
X-Google-Smtp-Source: ABdhPJwDA68USQC5bZBA5T+wjpjiJfqjcB/T+srFVUQNi0gQ2nJEgwFPKHhi3tQKL5ZOvRGjfHNJOw==
X-Received: by 2002:a17:90b:816:: with SMTP id bk22mr4010081pjb.66.1599859711966;
        Fri, 11 Sep 2020 14:28:31 -0700 (PDT)
Received: from localhost.localdomain ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id u14sm3241876pfc.203.2020.09.11.14.28.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2020 14:28:31 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     jannh@google.com, asml.silence@gmail.com,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/2] io_uring: implement ->flush() sequence to handle ->files validity
Date:   Fri, 11 Sep 2020 15:26:25 -0600
Message-Id: <20200911212625.630477-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200911212625.630477-1-axboe@kernel.dk>
References: <20200911212625.630477-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The current scheme stashes away ->ring_fd and ->ring_file, and uses
that to check against whether or not ->files could have changed. This
works, but doesn't work so well for SQPOLL. If the application does
close the ring_fd, then we require that applications enter the kernel
to refresh our state.

Add an atomic sequence for the ->flush() count on the ring fd, and if
we get a mismatch between checking this sequence before and after
grabbing the ->files, then we fail the request.

This should offer the same protection that we currently have, with the
added benefit of being able to update the ->files automatically.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 137 ++++++++++++++++++++++++++++++--------------------
 1 file changed, 83 insertions(+), 54 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 4958a9dca51a..49be5e21f166 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -308,8 +308,11 @@ struct io_ring_ctx {
 	 */
 	struct fixed_file_data	*file_data;
 	unsigned		nr_user_files;
-	int 			ring_fd;
-	struct file 		*ring_file;
+
+	/* incremented when ->flush() is called */
+	atomic_t		files_seq;
+	/* assigned when ->files are grabbed */
+	int			cur_files_seq;
 
 	/* if used, fixed mapped user buffers */
 	unsigned		nr_user_bufs;
@@ -394,6 +397,7 @@ struct io_close {
 	struct file			*file;
 	struct file			*put_file;
 	int				fd;
+	int				files_seq;
 };
 
 struct io_timeout_data {
@@ -409,6 +413,7 @@ struct io_accept {
 	int __user			*addr_len;
 	int				flags;
 	unsigned long			nofile;
+	int				files_seq;
 };
 
 struct io_sync {
@@ -461,6 +466,7 @@ struct io_sr_msg {
 struct io_open {
 	struct file			*file;
 	int				dfd;
+	int				files_seq;
 	struct filename			*filename;
 	struct open_how			how;
 	unsigned long			nofile;
@@ -471,6 +477,7 @@ struct io_files_update {
 	u64				arg;
 	u32				nr_args;
 	u32				offset;
+	int				files_seq;
 };
 
 struct io_fadvise {
@@ -492,6 +499,7 @@ struct io_epoll {
 	int				epfd;
 	int				op;
 	int				fd;
+	int				files_seq;
 	struct epoll_event		event;
 };
 
@@ -518,6 +526,7 @@ struct io_statx {
 	int				dfd;
 	unsigned int			mask;
 	unsigned int			flags;
+	int				files_seq;
 	const char __user		*filename;
 	struct statx __user		*buffer;
 };
@@ -3602,6 +3611,28 @@ static int io_fallocate(struct io_kiocb *req, bool force_nonblock)
 	return 0;
 }
 
+/*
+ * Check that our ->files sequence matches. If files isn't assigned yet,
+ * just store the current sequence. If they are assigned, check against
+ * the sequence from when they got assigned. If we get a mismatch, we fail
+ * the request. This is only applicable to requests that sets ->file_table
+ * in io_op_defs[], indicating that they need access to the file_struct
+ * when executed async.
+ */
+static int io_check_files_seq(struct io_kiocb *req, int *seq)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+
+	if (!req->work.files) {
+		*seq = ctx->cur_files_seq;
+		return 0;
+	} else if (*seq == atomic_read(&ctx->files_seq)) {
+		return 0;
+	}
+
+	return -EBADF;
+}
+
 static int __io_openat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	const char __user *fname;
@@ -3627,6 +3658,7 @@ static int __io_openat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
 		return ret;
 	}
 	req->open.nofile = rlimit(RLIMIT_NOFILE);
+	req->open.files_seq = req->ctx->cur_files_seq;
 	req->flags |= REQ_F_NEED_CLEANUP;
 	return 0;
 }
@@ -3670,6 +3702,10 @@ static int io_openat2(struct io_kiocb *req, bool force_nonblock)
 	struct file *file;
 	int ret;
 
+	ret = io_check_files_seq(req, &req->open.files_seq);
+	if (ret)
+		goto done;
+
 	if (force_nonblock)
 		return -EAGAIN;
 
@@ -3692,6 +3728,7 @@ static int io_openat2(struct io_kiocb *req, bool force_nonblock)
 err:
 	putname(req->open.filename);
 	req->flags &= ~REQ_F_NEED_CLEANUP;
+done:
 	if (ret < 0)
 		req_set_fail_links(req);
 	io_req_complete(req, ret);
@@ -3881,6 +3918,7 @@ static int io_epoll_ctl_prep(struct io_kiocb *req,
 			return -EFAULT;
 	}
 
+	req->epoll.files_seq = req->ctx->cur_files_seq;
 	return 0;
 #else
 	return -EOPNOTSUPP;
@@ -3894,10 +3932,15 @@ static int io_epoll_ctl(struct io_kiocb *req, bool force_nonblock,
 	struct io_epoll *ie = &req->epoll;
 	int ret;
 
+	ret = io_check_files_seq(req, &ie->files_seq);
+	if (ret)
+		goto done;
+
 	ret = do_epoll_ctl(ie->epfd, ie->op, ie->fd, &ie->event, force_nonblock);
 	if (force_nonblock && ret == -EAGAIN)
 		return -EAGAIN;
 
+done:
 	if (ret < 0)
 		req_set_fail_links(req);
 	__io_req_complete(req, ret, 0, cs);
@@ -3993,6 +4036,7 @@ static int io_statx_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	req->statx.filename = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	req->statx.buffer = u64_to_user_ptr(READ_ONCE(sqe->addr2));
 	req->statx.flags = READ_ONCE(sqe->statx_flags);
+	req->statx.files_seq = req->ctx->cur_files_seq;
 
 	return 0;
 }
@@ -4002,6 +4046,10 @@ static int io_statx(struct io_kiocb *req, bool force_nonblock)
 	struct io_statx *ctx = &req->statx;
 	int ret;
 
+	ret = io_check_files_seq(req, &ctx->files_seq);
+	if (ret)
+		goto done;
+
 	if (force_nonblock) {
 		/* only need file table for an actual valid fd */
 		if (ctx->dfd == -1 || ctx->dfd == AT_FDCWD)
@@ -4012,6 +4060,7 @@ static int io_statx(struct io_kiocb *req, bool force_nonblock)
 	ret = do_statx(ctx->dfd, ctx->filename, ctx->flags, ctx->mask,
 		       ctx->buffer);
 
+done:
 	if (ret < 0)
 		req_set_fail_links(req);
 	io_req_complete(req, ret);
@@ -4037,11 +4086,11 @@ static int io_close_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return -EBADF;
 
 	req->close.fd = READ_ONCE(sqe->fd);
-	if ((req->file && req->file->f_op == &io_uring_fops) ||
-	    req->close.fd == req->ctx->ring_fd)
+	if (req->file && req->file->f_op == &io_uring_fops)
 		return -EBADF;
 
 	req->close.put_file = NULL;
+	req->close.files_seq = req->ctx->cur_files_seq;
 	return 0;
 }
 
@@ -4051,6 +4100,10 @@ static int io_close(struct io_kiocb *req, bool force_nonblock,
 	struct io_close *close = &req->close;
 	int ret;
 
+	ret = io_check_files_seq(req, &close->files_seq);
+	if (ret)
+		goto done;
+
 	/* might be already done during nonblock submission */
 	if (!close->put_file) {
 		ret = __close_fd_get_file(close->fd, &close->put_file);
@@ -4069,10 +4122,11 @@ static int io_close(struct io_kiocb *req, bool force_nonblock,
 
 	/* No ->flush() or already async, safely close from here */
 	ret = filp_close(close->put_file, req->work.files);
-	if (ret < 0)
-		req_set_fail_links(req);
 	fput(close->put_file);
 	close->put_file = NULL;
+done:
+	if (ret < 0)
+		req_set_fail_links(req);
 	__io_req_complete(req, ret, 0, cs);
 	return 0;
 }
@@ -4526,6 +4580,7 @@ static int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	accept->addr_len = u64_to_user_ptr(READ_ONCE(sqe->addr2));
 	accept->flags = READ_ONCE(sqe->accept_flags);
 	accept->nofile = rlimit(RLIMIT_NOFILE);
+	accept->files_seq = req->ctx->cur_files_seq;
 	return 0;
 }
 
@@ -4536,6 +4591,10 @@ static int io_accept(struct io_kiocb *req, bool force_nonblock,
 	unsigned int file_flags = force_nonblock ? O_NONBLOCK : 0;
 	int ret;
 
+	ret = io_check_files_seq(req, &accept->files_seq);
+	if (ret)
+		goto done;
+
 	if (req->file->f_flags & O_NONBLOCK)
 		req->flags |= REQ_F_NOWAIT;
 
@@ -4544,6 +4603,7 @@ static int io_accept(struct io_kiocb *req, bool force_nonblock,
 					accept->nofile);
 	if (ret == -EAGAIN && force_nonblock)
 		return -EAGAIN;
+done:
 	if (ret < 0) {
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
@@ -5513,6 +5573,7 @@ static int io_files_update_prep(struct io_kiocb *req,
 	if (!req->files_update.nr_args)
 		return -EINVAL;
 	req->files_update.arg = READ_ONCE(sqe->addr);
+	req->files_update.files_seq = req->ctx->cur_files_seq;
 	return 0;
 }
 
@@ -5523,6 +5584,10 @@ static int io_files_update(struct io_kiocb *req, bool force_nonblock,
 	struct io_uring_files_update up;
 	int ret;
 
+	ret = io_check_files_seq(req, &req->files_update.files_seq);
+	if (ret)
+		goto done;
+
 	if (force_nonblock)
 		return -EAGAIN;
 
@@ -5532,7 +5597,7 @@ static int io_files_update(struct io_kiocb *req, bool force_nonblock,
 	mutex_lock(&ctx->uring_lock);
 	ret = __io_sqe_files_update(ctx, &up, req->files_update.nr_args);
 	mutex_unlock(&ctx->uring_lock);
-
+done:
 	if (ret < 0)
 		req_set_fail_links(req);
 	__io_req_complete(req, ret, 0, cs);
@@ -6118,34 +6183,21 @@ static int io_req_set_file(struct io_submit_state *state, struct io_kiocb *req,
 
 static int io_grab_files(struct io_kiocb *req)
 {
-	int ret = -EBADF;
 	struct io_ring_ctx *ctx = req->ctx;
 
 	io_req_init_async(req);
 
 	if (req->work.files || (req->flags & REQ_F_NO_FILE_TABLE))
 		return 0;
-	if (!ctx->ring_file)
-		return -EBADF;
 
-	rcu_read_lock();
 	spin_lock_irq(&ctx->inflight_lock);
-	/*
-	 * We use the f_ops->flush() handler to ensure that we can flush
-	 * out work accessing these files if the fd is closed. Check if
-	 * the fd has changed since we started down this path, and disallow
-	 * this operation if it has.
-	 */
-	if (fcheck(ctx->ring_fd) == ctx->ring_file) {
-		list_add(&req->inflight_entry, &ctx->inflight_list);
-		req->flags |= REQ_F_INFLIGHT;
-		req->work.files = current->files;
-		ret = 0;
-	}
+	list_add(&req->inflight_entry, &ctx->inflight_list);
+	req->flags |= REQ_F_INFLIGHT;
+	ctx->cur_files_seq = atomic_read(&ctx->files_seq);
+	req->work.files = current->files;
 	spin_unlock_irq(&ctx->inflight_lock);
-	rcu_read_unlock();
 
-	return ret;
+	return 0;
 }
 
 static inline int io_prep_work_files(struct io_kiocb *req)
@@ -6705,14 +6757,7 @@ static enum sq_ret __io_sq_thread(struct io_ring_ctx *ctx,
 		mutex_unlock(&ctx->uring_lock);
 	}
 
-	/*
-	 * If ->ring_file is NULL, we're waiting on new fd/file assigment.
-	 * Don't submit anything new until that happens.
-	 */
-	if (ctx->ring_file)
-		to_submit = io_sqring_entries(ctx);
-	else
-		to_submit = 0;
+	to_submit = io_sqring_entries(ctx);
 
 	/*
 	 * If submit got -EBUSY, flag us as needing the application
@@ -6756,7 +6801,7 @@ static enum sq_ret __io_sq_thread(struct io_ring_ctx *ctx,
 		}
 
 		to_submit = io_sqring_entries(ctx);
-		if (!to_submit || ret == -EBUSY || !ctx->ring_file)
+		if (!to_submit || ret == -EBUSY)
 			return SQT_IDLE;
 
 		finish_wait(&sqd->wait, &ctx->sqo_wait_entry);
@@ -8557,6 +8602,9 @@ static int io_uring_flush(struct file *file, void *data)
 {
 	struct io_ring_ctx *ctx = file->private_data;
 
+	/* assume current files sequence is no longer valid */
+	atomic_inc(&ctx->files_seq);
+
 	io_uring_cancel_files(ctx, data);
 
 	/*
@@ -8568,13 +8616,8 @@ static int io_uring_flush(struct file *file, void *data)
 	} else if (ctx->flags & IORING_SETUP_SQPOLL) {
 		struct io_sq_data *sqd = ctx->sq_data;
 
-		/* Ring is being closed, mark us as neding new assignment */
+		/* quiesce sqpoll thread */
 		io_sq_thread_park(sqd);
-		mutex_lock(&ctx->uring_lock);
-		ctx->ring_fd = -1;
-		ctx->ring_file = NULL;
-		mutex_unlock(&ctx->uring_lock);
-		io_ring_set_wakeup_flag(ctx);
 		io_sq_thread_unpark(sqd);
 	}
 
@@ -8711,18 +8754,6 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 	if (ctx->flags & IORING_SETUP_SQPOLL) {
 		if (!list_empty_careful(&ctx->cq_overflow_list))
 			io_cqring_overflow_flush(ctx, false);
-		if (fd != ctx->ring_fd) {
-			struct io_sq_data *sqd = ctx->sq_data;
-
-			io_sq_thread_park(sqd);
-
-			mutex_lock(&ctx->uring_lock);
-			ctx->ring_fd = fd;
-			ctx->ring_file = f.file;
-			mutex_unlock(&ctx->uring_lock);
-
-			io_sq_thread_unpark(sqd);
-		}
 		if (flags & IORING_ENTER_SQ_WAKEUP)
 			wake_up(&ctx->sq_data->wait);
 		if (flags & IORING_ENTER_SQ_WAIT)
@@ -8730,8 +8761,6 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 		submitted = to_submit;
 	} else if (to_submit) {
 		mutex_lock(&ctx->uring_lock);
-		ctx->ring_fd = fd;
-		ctx->ring_file = f.file;
 		submitted = io_submit_sqes(ctx, to_submit);
 		mutex_unlock(&ctx->uring_lock);
 
-- 
2.28.0

