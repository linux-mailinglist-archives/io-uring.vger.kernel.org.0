Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EC0120559B
	for <lists+io-uring@lfdr.de>; Tue, 23 Jun 2020 17:16:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732881AbgFWPQj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Jun 2020 11:16:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732781AbgFWPQi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Jun 2020 11:16:38 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A5C9C061755
        for <io-uring@vger.kernel.org>; Tue, 23 Jun 2020 08:16:37 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id l9so4875331ilq.12
        for <io-uring@vger.kernel.org>; Tue, 23 Jun 2020 08:16:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Om6IuXcR2HqyUZcY/WExwEP5c5KtUHbf2aNY4zdcQmY=;
        b=ML5veUMlRwxgMlr6bB90BfJ8vaNgT4yVlOMZPd8yHb6W3xlhEQMmqbBDLjYvYfdqNS
         4ycBfNCEZJunYXvAXCait7DHlZX7lonp/vTSTTeO/Rysn0wM5rze35YHH5FuyL/iTKZO
         Cpr+qM507NiClfFRhmkbbVdrzTw5uaiz6MR+8Zl3yEvKRMNjHoRKaua9SWiRWB6UVNw8
         wnyBm7MHRx8uUD/S4bx8NlnbjjGz6JLEP/ia+DbujHjPlLuuTDxjIC9hv7qe0oNdE+Hr
         /t8jGmxfJECIJxScD/SVObxfo56aQLyZJqey0JcxOaA+Sq+1jmcGzPh6AEmB54qSgJ8O
         OwmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Om6IuXcR2HqyUZcY/WExwEP5c5KtUHbf2aNY4zdcQmY=;
        b=o0wcS8k3Rly7CcxaXypMWZFs0TPJ6XAFYtcFR0O2Czx14wBe2gHlm4AtPf26jNL12h
         x5N9aO6At4RPnNW1mM7N4TZymT7ennI1Zi5AvMUZVSKbQqHospwSxC4v/fNoMsWMnrz5
         9hCYBTbygazAb51+mijUe2CCbR175aneXM4+PNw0Rr6YzzXBD4ZqCgDF2+fF4SSe0g1C
         QDU8px2ece3mocrzOAcIkg8QSp5AnxX5ZxM36Mzz7/3HATdsxuot3/yKAp7JZfmbsg8K
         Bh3wUWF2Bnh84M/49pRt9OF/+ihGjm64OgCFRdIzxfszErUuxz9E0fDJ7U2gx6rqtyG3
         ESSQ==
X-Gm-Message-State: AOAM530bNWUYOEqc6UcHMhbEbTCnVJm5FFPQFOSXxOjLS/jg0TBK9LLH
        NzdSAVB7LIhI6QUDBD5F+2YnGH3qmAA=
X-Google-Smtp-Source: ABdhPJw3sZC7QFc5N4gwqrZeN8Cn4gOSi899e9iVb433+SplTm6WWsIOokqXaoVC1Uir9Ex0hmepLA==
X-Received: by 2002:a92:c7c6:: with SMTP id g6mr23842242ilk.49.1592925396131;
        Tue, 23 Jun 2020 08:16:36 -0700 (PDT)
Received: from x1.thefacebook.com ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id k1sm4275180ilr.35.2020.06.23.08.16.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2020 08:16:35 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     xuanzhuo@linux.alibaba.com, Dust.li@linux.alibaba.com,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/5] io_uring: provide generic io_req_complete() helper
Date:   Tue, 23 Jun 2020 09:16:25 -0600
Message-Id: <20200623151629.17197-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623151629.17197-1-axboe@kernel.dk>
References: <20200623151629.17197-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We have lots of callers of:

io_cqring_add_event(req, result);
io_put_req(req);

Provide a helper that does this for us. It helps clean up the code, and
also provides a more convenient location for us to change the completion
handling.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 106 ++++++++++++++++++++------------------------------
 1 file changed, 43 insertions(+), 63 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c686061c3762..0cdf088c56cd 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1335,7 +1335,7 @@ static void io_cqring_fill_event(struct io_kiocb *req, long res)
 	__io_cqring_fill_event(req, res, 0);
 }
 
-static void __io_cqring_add_event(struct io_kiocb *req, long res, long cflags)
+static void io_cqring_add_event(struct io_kiocb *req, long res, long cflags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	unsigned long flags;
@@ -1348,9 +1348,15 @@ static void __io_cqring_add_event(struct io_kiocb *req, long res, long cflags)
 	io_cqring_ev_posted(ctx);
 }
 
-static void io_cqring_add_event(struct io_kiocb *req, long res)
+static void __io_req_complete(struct io_kiocb *req, long res, unsigned cflags)
 {
-	__io_cqring_add_event(req, res, 0);
+	io_cqring_add_event(req, res, cflags);
+	io_put_req(req);
+}
+
+static void io_req_complete(struct io_kiocb *req, long res)
+{
+	__io_req_complete(req, res, 0);
 }
 
 static inline bool io_is_fallback_req(struct io_kiocb *req)
@@ -1978,7 +1984,7 @@ static void io_complete_rw_common(struct kiocb *kiocb, long res)
 		req_set_fail_links(req);
 	if (req->flags & REQ_F_BUFFER_SELECTED)
 		cflags = io_put_kbuf(req);
-	__io_cqring_add_event(req, res, cflags);
+	io_cqring_add_event(req, res, cflags);
 }
 
 static void io_sq_thread_drop_mm(struct io_ring_ctx *ctx)
@@ -2041,9 +2047,8 @@ static bool io_resubmit_prep(struct io_kiocb *req, int error)
 		return true;
 	kfree(iovec);
 end_req:
-	io_cqring_add_event(req, ret);
 	req_set_fail_links(req);
-	io_put_req(req);
+	io_req_complete(req, ret);
 	return false;
 }
 
@@ -3110,10 +3115,9 @@ static int io_tee(struct io_kiocb *req, bool force_nonblock)
 	io_put_file(req, in, (sp->flags & SPLICE_F_FD_IN_FIXED));
 	req->flags &= ~REQ_F_NEED_CLEANUP;
 
-	io_cqring_add_event(req, ret);
 	if (ret != sp->len)
 		req_set_fail_links(req);
-	io_put_req(req);
+	io_req_complete(req, ret);
 	return 0;
 }
 
@@ -3147,10 +3151,9 @@ static int io_splice(struct io_kiocb *req, bool force_nonblock)
 	io_put_file(req, in, (sp->flags & SPLICE_F_FD_IN_FIXED));
 	req->flags &= ~REQ_F_NEED_CLEANUP;
 
-	io_cqring_add_event(req, ret);
 	if (ret != sp->len)
 		req_set_fail_links(req);
-	io_put_req(req);
+	io_req_complete(req, ret);
 	return 0;
 }
 
@@ -3164,8 +3167,7 @@ static int io_nop(struct io_kiocb *req)
 	if (unlikely(ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
 
-	io_cqring_add_event(req, 0);
-	io_put_req(req);
+	io_req_complete(req, 0);
 	return 0;
 }
 
@@ -3204,8 +3206,7 @@ static int io_fsync(struct io_kiocb *req, bool force_nonblock)
 				req->sync.flags & IORING_FSYNC_DATASYNC);
 	if (ret < 0)
 		req_set_fail_links(req);
-	io_cqring_add_event(req, ret);
-	io_put_req(req);
+	io_req_complete(req, ret);
 	return 0;
 }
 
@@ -3238,8 +3239,7 @@ static int io_fallocate(struct io_kiocb *req, bool force_nonblock)
 	current->signal->rlim[RLIMIT_FSIZE].rlim_cur = RLIM_INFINITY;
 	if (ret < 0)
 		req_set_fail_links(req);
-	io_cqring_add_event(req, ret);
-	io_put_req(req);
+	io_req_complete(req, ret);
 	return 0;
 }
 
@@ -3335,8 +3335,7 @@ static int io_openat2(struct io_kiocb *req, bool force_nonblock)
 	req->flags &= ~REQ_F_NEED_CLEANUP;
 	if (ret < 0)
 		req_set_fail_links(req);
-	io_cqring_add_event(req, ret);
-	io_put_req(req);
+	io_req_complete(req, ret);
 	return 0;
 }
 
@@ -3409,8 +3408,7 @@ static int io_remove_buffers(struct io_kiocb *req, bool force_nonblock)
 	io_ring_submit_lock(ctx, !force_nonblock);
 	if (ret < 0)
 		req_set_fail_links(req);
-	io_cqring_add_event(req, ret);
-	io_put_req(req);
+	io_req_complete(req, ret);
 	return 0;
 }
 
@@ -3497,8 +3495,7 @@ static int io_provide_buffers(struct io_kiocb *req, bool force_nonblock)
 	io_ring_submit_unlock(ctx, !force_nonblock);
 	if (ret < 0)
 		req_set_fail_links(req);
-	io_cqring_add_event(req, ret);
-	io_put_req(req);
+	io_req_complete(req, ret);
 	return 0;
 }
 
@@ -3541,8 +3538,7 @@ static int io_epoll_ctl(struct io_kiocb *req, bool force_nonblock)
 
 	if (ret < 0)
 		req_set_fail_links(req);
-	io_cqring_add_event(req, ret);
-	io_put_req(req);
+	io_req_complete(req, ret);
 	return 0;
 #else
 	return -EOPNOTSUPP;
@@ -3578,8 +3574,7 @@ static int io_madvise(struct io_kiocb *req, bool force_nonblock)
 	ret = do_madvise(ma->addr, ma->len, ma->advice);
 	if (ret < 0)
 		req_set_fail_links(req);
-	io_cqring_add_event(req, ret);
-	io_put_req(req);
+	io_req_complete(req, ret);
 	return 0;
 #else
 	return -EOPNOTSUPP;
@@ -3618,8 +3613,7 @@ static int io_fadvise(struct io_kiocb *req, bool force_nonblock)
 	ret = vfs_fadvise(req->file, fa->offset, fa->len, fa->advice);
 	if (ret < 0)
 		req_set_fail_links(req);
-	io_cqring_add_event(req, ret);
-	io_put_req(req);
+	io_req_complete(req, ret);
 	return 0;
 }
 
@@ -3658,8 +3652,7 @@ static int io_statx(struct io_kiocb *req, bool force_nonblock)
 
 	if (ret < 0)
 		req_set_fail_links(req);
-	io_cqring_add_event(req, ret);
-	io_put_req(req);
+	io_req_complete(req, ret);
 	return 0;
 }
 
@@ -3715,10 +3708,9 @@ static int io_close(struct io_kiocb *req, bool force_nonblock)
 	ret = filp_close(close->put_file, req->work.files);
 	if (ret < 0)
 		req_set_fail_links(req);
-	io_cqring_add_event(req, ret);
 	fput(close->put_file);
 	close->put_file = NULL;
-	io_put_req(req);
+	io_req_complete(req, ret);
 	return 0;
 }
 
@@ -3752,8 +3744,7 @@ static int io_sync_file_range(struct io_kiocb *req, bool force_nonblock)
 				req->sync.flags);
 	if (ret < 0)
 		req_set_fail_links(req);
-	io_cqring_add_event(req, ret);
-	io_put_req(req);
+	io_req_complete(req, ret);
 	return 0;
 }
 
@@ -3852,10 +3843,9 @@ static int io_sendmsg(struct io_kiocb *req, bool force_nonblock)
 	if (kmsg && kmsg->iov != kmsg->fast_iov)
 		kfree(kmsg->iov);
 	req->flags &= ~REQ_F_NEED_CLEANUP;
-	io_cqring_add_event(req, ret);
 	if (ret < 0)
 		req_set_fail_links(req);
-	io_put_req(req);
+	io_req_complete(req, ret);
 	return 0;
 }
 
@@ -3895,10 +3885,9 @@ static int io_send(struct io_kiocb *req, bool force_nonblock)
 			ret = -EINTR;
 	}
 
-	io_cqring_add_event(req, ret);
 	if (ret < 0)
 		req_set_fail_links(req);
-	io_put_req(req);
+	io_req_complete(req, ret);
 	return 0;
 }
 
@@ -4095,10 +4084,9 @@ static int io_recvmsg(struct io_kiocb *req, bool force_nonblock)
 	if (kmsg && kmsg->iov != kmsg->fast_iov)
 		kfree(kmsg->iov);
 	req->flags &= ~REQ_F_NEED_CLEANUP;
-	__io_cqring_add_event(req, ret, cflags);
 	if (ret < 0)
 		req_set_fail_links(req);
-	io_put_req(req);
+	__io_req_complete(req, ret, cflags);
 	return 0;
 }
 
@@ -4152,10 +4140,9 @@ static int io_recv(struct io_kiocb *req, bool force_nonblock)
 
 	kfree(kbuf);
 	req->flags &= ~REQ_F_NEED_CLEANUP;
-	__io_cqring_add_event(req, ret, cflags);
 	if (ret < 0)
 		req_set_fail_links(req);
-	io_put_req(req);
+	__io_req_complete(req, ret, cflags);
 	return 0;
 }
 
@@ -4194,8 +4181,7 @@ static int io_accept(struct io_kiocb *req, bool force_nonblock)
 			ret = -EINTR;
 		req_set_fail_links(req);
 	}
-	io_cqring_add_event(req, ret);
-	io_put_req(req);
+	io_req_complete(req, ret);
 	return 0;
 }
 
@@ -4255,8 +4241,7 @@ static int io_connect(struct io_kiocb *req, bool force_nonblock)
 out:
 	if (ret < 0)
 		req_set_fail_links(req);
-	io_cqring_add_event(req, ret);
-	io_put_req(req);
+	io_req_complete(req, ret);
 	return 0;
 }
 #else /* !CONFIG_NET */
@@ -4548,7 +4533,7 @@ static void io_async_task_func(struct callback_head *cb)
 	if (!canceled) {
 		__set_current_state(TASK_RUNNING);
 		if (io_sq_thread_acquire_mm(ctx, req)) {
-			io_cqring_add_event(req, -EFAULT);
+			io_cqring_add_event(req, -EFAULT, 0);
 			goto end_req;
 		}
 		mutex_lock(&ctx->uring_lock);
@@ -4797,10 +4782,9 @@ static int io_poll_remove(struct io_kiocb *req)
 	ret = io_poll_cancel(ctx, addr);
 	spin_unlock_irq(&ctx->completion_lock);
 
-	io_cqring_add_event(req, ret);
 	if (ret < 0)
 		req_set_fail_links(req);
-	io_put_req(req);
+	io_req_complete(req, ret);
 	return 0;
 }
 
@@ -5156,8 +5140,7 @@ static int io_files_update(struct io_kiocb *req, bool force_nonblock)
 
 	if (ret < 0)
 		req_set_fail_links(req);
-	io_cqring_add_event(req, ret);
-	io_put_req(req);
+	io_req_complete(req, ret);
 	return 0;
 }
 
@@ -5650,8 +5633,7 @@ static void io_wq_submit_work(struct io_wq_work **workptr)
 
 	if (ret) {
 		req_set_fail_links(req);
-		io_cqring_add_event(req, ret);
-		io_put_req(req);
+		io_req_complete(req, ret);
 	}
 
 	io_steal_work(req, workptr);
@@ -5768,8 +5750,7 @@ static enum hrtimer_restart io_link_timeout_fn(struct hrtimer *timer)
 		io_async_find_and_cancel(ctx, req, prev->user_data, -ETIME);
 		io_put_req(prev);
 	} else {
-		io_cqring_add_event(req, -ETIME);
-		io_put_req(req);
+		io_req_complete(req, -ETIME);
 	}
 	return HRTIMER_NORESTART;
 }
@@ -5878,9 +5859,8 @@ static void __io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 	/* and drop final reference, if we failed */
 	if (ret) {
-		io_cqring_add_event(req, ret);
 		req_set_fail_links(req);
-		io_put_req(req);
+		io_req_complete(req, ret);
 	}
 	if (nxt) {
 		req = nxt;
@@ -5902,9 +5882,9 @@ static void io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (ret) {
 		if (ret != -EIOCBQUEUED) {
 fail_req:
-			io_cqring_add_event(req, ret);
 			req_set_fail_links(req);
-			io_double_put_req(req);
+			io_put_req(req);
+			io_req_complete(req, ret);
 		}
 	} else if (req->flags & REQ_F_FORCE_ASYNC) {
 		if (!req->io) {
@@ -5930,8 +5910,8 @@ static void io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 static inline void io_queue_link_head(struct io_kiocb *req)
 {
 	if (unlikely(req->flags & REQ_F_FAIL_LINK)) {
-		io_cqring_add_event(req, -ECANCELED);
-		io_double_put_req(req);
+		io_put_req(req);
+		io_req_complete(req, -ECANCELED);
 	} else
 		io_queue_sqe(req, NULL);
 }
@@ -6188,8 +6168,8 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 
 		if (unlikely(err)) {
 fail_req:
-			io_cqring_add_event(req, err);
-			io_double_put_req(req);
+			io_put_req(req);
+			io_req_complete(req, err);
 			break;
 		}
 
-- 
2.27.0

