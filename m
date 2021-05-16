Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1060E382159
	for <lists+io-uring@lfdr.de>; Sun, 16 May 2021 23:58:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229889AbhEPV7w (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 16 May 2021 17:59:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229916AbhEPV7s (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 16 May 2021 17:59:48 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C0D9C06175F
        for <io-uring@vger.kernel.org>; Sun, 16 May 2021 14:58:32 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id q5so4425904wrs.4
        for <io-uring@vger.kernel.org>; Sun, 16 May 2021 14:58:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=5Z64bkjvg3wqWCx0ney0Xi/1Pm9ZLjRpWYIISsuzPt8=;
        b=vgbwifMt5zSc3qXwBoPW23IDekXbEeoDOcDotSgMyzd/WLV62MUiJMObJ20+BGgHco
         p3ZslwyLkIrgUALNTqCGmk+kyoR8kp43NQidujo5qKyfgnEQhRsaeVucDS2URwvcaFru
         /8Z8j4qwyfJWMbyDlxodjJlOWEpXeqTUm43se5EsunQgQUA5Gu7dM662UmrqtIZp9m6Y
         uOljS2vPnbVr/Q7qVrLw9D454us5e41gg/3VAY8fiG2g4yEU09mctxb2PuFb8uCPylDO
         fwYDX1auDwt7ZNiU6oiLVO5DCSeavzNCx/3n1+QCwjB9AJmDXOiDyfinpLG3Cy5epqyC
         g5DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5Z64bkjvg3wqWCx0ney0Xi/1Pm9ZLjRpWYIISsuzPt8=;
        b=VD/7CSq/wBTr/AthNceg8Op1lNvwazkwNTA/tGaQCTisw1kRV/L67L6gUIBOf6wUpQ
         VxEpROoBmu3CjWYnEIB8814geih+mk3cbsgWiyOofgdXNrDKfL01rwMx3/6J5lAoQJai
         RhmDBh8kgOApaSvkutSPkMLQlwK6VPpNjv+dv7fuHp0vg/O9l905hhQb4cc0dhrDwG4u
         DLK15djMF/7Nv4smqavgJDQgOW6y5XA38vGZ/uFs/USfQqdCNKuQRwwXr/9lHHm/bp0v
         R2b66CjudIGXrQOJdEcAOscIiZQZA8GzEkXfLQkml6beBrpEa8lqRM6E/kHKMEMrIMiU
         Wofg==
X-Gm-Message-State: AOAM5318Imy7rB/awCxzM3QbZNdCweF8LplbnZC3cDZPD9JAfkEWRryq
        T2TLPBaiF/R7gI7cSa2N+aFm4C4fNsk=
X-Google-Smtp-Source: ABdhPJy8qirKEWRQlVlsThGADflv1AcYdqCU48emMz1NdP0wAAqc2KOvRGT6i2H0OKp3XiFSFkuOog==
X-Received: by 2002:adf:a212:: with SMTP id p18mr71081151wra.353.1621202311425;
        Sun, 16 May 2021 14:58:31 -0700 (PDT)
Received: from localhost.localdomain ([148.252.128.7])
        by smtp.gmail.com with ESMTPSA id p10sm13666365wmq.14.2021.05.16.14.58.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 May 2021 14:58:31 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 06/13] io_uring: make fail flag not link specific
Date:   Sun, 16 May 2021 22:58:05 +0100
Message-Id: <e2224154dd6e53b665ac835d29436b177872fa10.1621201931.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1621201931.git.asml.silence@gmail.com>
References: <cover.1621201931.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The main difference is in req_set_fail_links() renamed into
req_set_fail(), which now sets REQ_F_FAIL_LINK/REQ_F_FAIL flag
unconditional on whether it has been a link or not. It only matters in
io_disarm_next(), which already handles it well, and all calls to it
have a fast path checking REQ_F_LINK/HARDLINK.

It looks cleaner, and sheds binary size
   text    data     bss     dec     hex filename
  84235   12390       8   96633   17979 ./fs/io_uring.o
  84151   12414       8   96573   1793d ./fs/io_uring.o

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 87 +++++++++++++++++++++++++--------------------------
 1 file changed, 43 insertions(+), 44 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 9dfffd66362e..1ab28224d896 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -705,7 +705,7 @@ enum {
 	REQ_F_BUFFER_SELECT_BIT	= IOSQE_BUFFER_SELECT_BIT,
 
 	/* first byte is taken by user flags, shift it to not overlap */
-	REQ_F_FAIL_LINK_BIT	= 8,
+	REQ_F_FAIL_BIT		= 8,
 	REQ_F_INFLIGHT_BIT,
 	REQ_F_CUR_POS_BIT,
 	REQ_F_NOWAIT_BIT,
@@ -741,7 +741,7 @@ enum {
 	REQ_F_BUFFER_SELECT	= BIT(REQ_F_BUFFER_SELECT_BIT),
 
 	/* fail rest of links */
-	REQ_F_FAIL_LINK		= BIT(REQ_F_FAIL_LINK_BIT),
+	REQ_F_FAIL		= BIT(REQ_F_FAIL_BIT),
 	/* on inflight list, should be cancelled and waited on exit reliably */
 	REQ_F_INFLIGHT		= BIT(REQ_F_INFLIGHT_BIT),
 	/* read/write uses file position */
@@ -1117,10 +1117,9 @@ static bool io_match_task(struct io_kiocb *head, struct task_struct *task,
 	return false;
 }
 
-static inline void req_set_fail_links(struct io_kiocb *req)
+static inline void req_set_fail(struct io_kiocb *req)
 {
-	if (req->flags & REQ_F_LINK)
-		req->flags |= REQ_F_FAIL_LINK;
+	req->flags |= REQ_F_FAIL;
 }
 
 static void io_ring_ctx_ref_free(struct percpu_ref *ref)
@@ -1589,7 +1588,7 @@ static void io_req_complete_post(struct io_kiocb *req, long res,
 		struct io_comp_state *cs = &ctx->submit_state.comp;
 
 		if (req->flags & (REQ_F_LINK | REQ_F_HARDLINK)) {
-			if (req->flags & (REQ_F_LINK_TIMEOUT | REQ_F_FAIL_LINK))
+			if (req->flags & (REQ_F_LINK_TIMEOUT | REQ_F_FAIL))
 				io_disarm_next(req);
 			if (req->link) {
 				io_req_task_queue(req->link);
@@ -1645,7 +1644,7 @@ static inline void io_req_complete(struct io_kiocb *req, long res)
 
 static void io_req_complete_failed(struct io_kiocb *req, long res)
 {
-	req_set_fail_links(req);
+	req_set_fail(req);
 	io_put_req(req);
 	io_req_complete_post(req, res, 0);
 }
@@ -1824,7 +1823,7 @@ static bool io_disarm_next(struct io_kiocb *req)
 
 	if (likely(req->flags & REQ_F_LINK_TIMEOUT))
 		posted = io_kill_linked_timeout(req);
-	if (unlikely((req->flags & REQ_F_FAIL_LINK) &&
+	if (unlikely((req->flags & REQ_F_FAIL) &&
 		     !(req->flags & REQ_F_HARDLINK))) {
 		posted |= (req->link != NULL);
 		io_fail_links(req);
@@ -1842,7 +1841,7 @@ static struct io_kiocb *__io_req_find_next(struct io_kiocb *req)
 	 * dependencies to the next request. In case of failure, fail the rest
 	 * of the chain.
 	 */
-	if (req->flags & (REQ_F_LINK_TIMEOUT | REQ_F_FAIL_LINK)) {
+	if (req->flags & (REQ_F_LINK_TIMEOUT | REQ_F_FAIL)) {
 		struct io_ring_ctx *ctx = req->ctx;
 		unsigned long flags;
 		bool posted;
@@ -2481,7 +2480,7 @@ static void __io_complete_rw(struct io_kiocb *req, long res, long res2,
 			req->flags |= REQ_F_REISSUE;
 			return;
 		}
-		req_set_fail_links(req);
+		req_set_fail(req);
 	}
 	if (req->flags & REQ_F_BUFFER_SELECTED)
 		cflags = io_put_rw_kbuf(req);
@@ -2504,7 +2503,7 @@ static void io_complete_rw_iopoll(struct kiocb *kiocb, long res, long res2)
 	if (unlikely(res != req->result)) {
 		if (!(res == -EAGAIN && io_rw_should_reissue(req) &&
 		    io_resubmit_prep(req))) {
-			req_set_fail_links(req);
+			req_set_fail(req);
 			req->flags |= REQ_F_DONT_REISSUE;
 		}
 	}
@@ -2760,7 +2759,7 @@ static void kiocb_done(struct kiocb *kiocb, ssize_t ret,
 		} else {
 			int cflags = 0;
 
-			req_set_fail_links(req);
+			req_set_fail(req);
 			if (req->flags & REQ_F_BUFFER_SELECTED)
 				cflags = io_put_rw_kbuf(req);
 			__io_req_complete(req, issue_flags, ret, cflags);
@@ -3482,7 +3481,7 @@ static int io_renameat(struct io_kiocb *req, unsigned int issue_flags)
 
 	req->flags &= ~REQ_F_NEED_CLEANUP;
 	if (ret < 0)
-		req_set_fail_links(req);
+		req_set_fail(req);
 	io_req_complete(req, ret);
 	return 0;
 }
@@ -3526,7 +3525,7 @@ static int io_unlinkat(struct io_kiocb *req, unsigned int issue_flags)
 
 	req->flags &= ~REQ_F_NEED_CLEANUP;
 	if (ret < 0)
-		req_set_fail_links(req);
+		req_set_fail(req);
 	io_req_complete(req, ret);
 	return 0;
 }
@@ -3563,7 +3562,7 @@ static int io_shutdown(struct io_kiocb *req, unsigned int issue_flags)
 
 	ret = __sys_shutdown_sock(sock, req->shutdown.how);
 	if (ret < 0)
-		req_set_fail_links(req);
+		req_set_fail(req);
 	io_req_complete(req, ret);
 	return 0;
 #else
@@ -3621,7 +3620,7 @@ static int io_tee(struct io_kiocb *req, unsigned int issue_flags)
 	req->flags &= ~REQ_F_NEED_CLEANUP;
 
 	if (ret != sp->len)
-		req_set_fail_links(req);
+		req_set_fail(req);
 	io_req_complete(req, ret);
 	return 0;
 }
@@ -3658,7 +3657,7 @@ static int io_splice(struct io_kiocb *req, unsigned int issue_flags)
 	req->flags &= ~REQ_F_NEED_CLEANUP;
 
 	if (ret != sp->len)
-		req_set_fail_links(req);
+		req_set_fail(req);
 	io_req_complete(req, ret);
 	return 0;
 }
@@ -3711,7 +3710,7 @@ static int io_fsync(struct io_kiocb *req, unsigned int issue_flags)
 				end > 0 ? end : LLONG_MAX,
 				req->sync.flags & IORING_FSYNC_DATASYNC);
 	if (ret < 0)
-		req_set_fail_links(req);
+		req_set_fail(req);
 	io_req_complete(req, ret);
 	return 0;
 }
@@ -3740,7 +3739,7 @@ static int io_fallocate(struct io_kiocb *req, unsigned int issue_flags)
 	ret = vfs_fallocate(req->file, req->sync.mode, req->sync.off,
 				req->sync.len);
 	if (ret < 0)
-		req_set_fail_links(req);
+		req_set_fail(req);
 	io_req_complete(req, ret);
 	return 0;
 }
@@ -3859,7 +3858,7 @@ static int io_openat2(struct io_kiocb *req, unsigned int issue_flags)
 	putname(req->open.filename);
 	req->flags &= ~REQ_F_NEED_CLEANUP;
 	if (ret < 0)
-		req_set_fail_links(req);
+		req_set_fail(req);
 	__io_req_complete(req, issue_flags, ret, 0);
 	return 0;
 }
@@ -3931,7 +3930,7 @@ static int io_remove_buffers(struct io_kiocb *req, unsigned int issue_flags)
 	if (head)
 		ret = __io_remove_buffers(ctx, head, p->bgid, p->nbufs);
 	if (ret < 0)
-		req_set_fail_links(req);
+		req_set_fail(req);
 
 	/* complete before unlock, IOPOLL may need the lock */
 	__io_req_complete(req, issue_flags, ret, 0);
@@ -4022,7 +4021,7 @@ static int io_provide_buffers(struct io_kiocb *req, unsigned int issue_flags)
 			__io_remove_buffers(ctx, head, p->bgid, -1U);
 	}
 	if (ret < 0)
-		req_set_fail_links(req);
+		req_set_fail(req);
 	/* complete before unlock, IOPOLL may need the lock */
 	__io_req_complete(req, issue_flags, ret, 0);
 	io_ring_submit_unlock(ctx, !force_nonblock);
@@ -4068,7 +4067,7 @@ static int io_epoll_ctl(struct io_kiocb *req, unsigned int issue_flags)
 		return -EAGAIN;
 
 	if (ret < 0)
-		req_set_fail_links(req);
+		req_set_fail(req);
 	__io_req_complete(req, issue_flags, ret, 0);
 	return 0;
 #else
@@ -4104,7 +4103,7 @@ static int io_madvise(struct io_kiocb *req, unsigned int issue_flags)
 
 	ret = do_madvise(current->mm, ma->addr, ma->len, ma->advice);
 	if (ret < 0)
-		req_set_fail_links(req);
+		req_set_fail(req);
 	io_req_complete(req, ret);
 	return 0;
 #else
@@ -4143,7 +4142,7 @@ static int io_fadvise(struct io_kiocb *req, unsigned int issue_flags)
 
 	ret = vfs_fadvise(req->file, fa->offset, fa->len, fa->advice);
 	if (ret < 0)
-		req_set_fail_links(req);
+		req_set_fail(req);
 	__io_req_complete(req, issue_flags, ret, 0);
 	return 0;
 }
@@ -4178,7 +4177,7 @@ static int io_statx(struct io_kiocb *req, unsigned int issue_flags)
 		       ctx->buffer);
 
 	if (ret < 0)
-		req_set_fail_links(req);
+		req_set_fail(req);
 	io_req_complete(req, ret);
 	return 0;
 }
@@ -4236,7 +4235,7 @@ static int io_close(struct io_kiocb *req, unsigned int issue_flags)
 	ret = filp_close(file, current->files);
 err:
 	if (ret < 0)
-		req_set_fail_links(req);
+		req_set_fail(req);
 	if (file)
 		fput(file);
 	__io_req_complete(req, issue_flags, ret, 0);
@@ -4269,7 +4268,7 @@ static int io_sync_file_range(struct io_kiocb *req, unsigned int issue_flags)
 	ret = sync_file_range(req->file, req->sync.off, req->sync.len,
 				req->sync.flags);
 	if (ret < 0)
-		req_set_fail_links(req);
+		req_set_fail(req);
 	io_req_complete(req, ret);
 	return 0;
 }
@@ -4373,7 +4372,7 @@ static int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
 		kfree(kmsg->free_iov);
 	req->flags &= ~REQ_F_NEED_CLEANUP;
 	if (ret < min_ret)
-		req_set_fail_links(req);
+		req_set_fail(req);
 	__io_req_complete(req, issue_flags, ret, 0);
 	return 0;
 }
@@ -4415,7 +4414,7 @@ static int io_send(struct io_kiocb *req, unsigned int issue_flags)
 		ret = -EINTR;
 
 	if (ret < min_ret)
-		req_set_fail_links(req);
+		req_set_fail(req);
 	__io_req_complete(req, issue_flags, ret, 0);
 	return 0;
 }
@@ -4610,7 +4609,7 @@ static int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 		kfree(kmsg->free_iov);
 	req->flags &= ~REQ_F_NEED_CLEANUP;
 	if (ret < min_ret || ((flags & MSG_WAITALL) && (kmsg->msg.msg_flags & (MSG_TRUNC | MSG_CTRUNC))))
-		req_set_fail_links(req);
+		req_set_fail(req);
 	__io_req_complete(req, issue_flags, ret, cflags);
 	return 0;
 }
@@ -4665,7 +4664,7 @@ static int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 	if (req->flags & REQ_F_BUFFER_SELECTED)
 		cflags = io_put_recv_kbuf(req);
 	if (ret < min_ret || ((flags & MSG_WAITALL) && (msg.msg_flags & (MSG_TRUNC | MSG_CTRUNC))))
-		req_set_fail_links(req);
+		req_set_fail(req);
 	__io_req_complete(req, issue_flags, ret, cflags);
 	return 0;
 }
@@ -4704,7 +4703,7 @@ static int io_accept(struct io_kiocb *req, unsigned int issue_flags)
 	if (ret < 0) {
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
-		req_set_fail_links(req);
+		req_set_fail(req);
 	}
 	__io_req_complete(req, issue_flags, ret, 0);
 	return 0;
@@ -4768,7 +4767,7 @@ static int io_connect(struct io_kiocb *req, unsigned int issue_flags)
 		ret = -EINTR;
 out:
 	if (ret < 0)
-		req_set_fail_links(req);
+		req_set_fail(req);
 	__io_req_complete(req, issue_flags, ret, 0);
 	return 0;
 }
@@ -5239,7 +5238,7 @@ static bool io_poll_remove_one(struct io_kiocb *req)
 	if (do_complete) {
 		io_cqring_fill_event(req->ctx, req->user_data, -ECANCELED, 0);
 		io_commit_cqring(req->ctx);
-		req_set_fail_links(req);
+		req_set_fail(req);
 		io_put_req_deferred(req, 1);
 	}
 
@@ -5449,7 +5448,7 @@ static int io_poll_update(struct io_kiocb *req, unsigned int issue_flags)
 err:
 	if (ret < 0) {
 		spin_unlock_irq(&ctx->completion_lock);
-		req_set_fail_links(req);
+		req_set_fail(req);
 		io_req_complete(req, ret);
 		return 0;
 	}
@@ -5469,7 +5468,7 @@ static int io_poll_update(struct io_kiocb *req, unsigned int issue_flags)
 	if (!completing) {
 		ret = io_poll_add(preq, issue_flags);
 		if (ret < 0) {
-			req_set_fail_links(preq);
+			req_set_fail(preq);
 			io_req_complete(preq, ret);
 		}
 	}
@@ -5494,7 +5493,7 @@ static enum hrtimer_restart io_timeout_fn(struct hrtimer *timer)
 	spin_unlock_irqrestore(&ctx->completion_lock, flags);
 
 	io_cqring_ev_posted(ctx);
-	req_set_fail_links(req);
+	req_set_fail(req);
 	io_put_req(req);
 	return HRTIMER_NORESTART;
 }
@@ -5530,7 +5529,7 @@ static int io_timeout_cancel(struct io_ring_ctx *ctx, __u64 user_data)
 	if (IS_ERR(req))
 		return PTR_ERR(req);
 
-	req_set_fail_links(req);
+	req_set_fail(req);
 	io_cqring_fill_event(ctx, req->user_data, -ECANCELED, 0);
 	io_put_req_deferred(req, 1);
 	return 0;
@@ -5609,7 +5608,7 @@ static int io_timeout_remove(struct io_kiocb *req, unsigned int issue_flags)
 	spin_unlock_irq(&ctx->completion_lock);
 	io_cqring_ev_posted(ctx);
 	if (ret < 0)
-		req_set_fail_links(req);
+		req_set_fail(req);
 	io_put_req(req);
 	return 0;
 }
@@ -5762,7 +5761,7 @@ static void io_async_find_and_cancel(struct io_ring_ctx *ctx,
 	io_cqring_ev_posted(ctx);
 
 	if (ret < 0)
-		req_set_fail_links(req);
+		req_set_fail(req);
 }
 
 static int io_async_cancel_prep(struct io_kiocb *req,
@@ -5819,7 +5818,7 @@ static int io_async_cancel(struct io_kiocb *req, unsigned int issue_flags)
 	io_cqring_ev_posted(ctx);
 
 	if (ret < 0)
-		req_set_fail_links(req);
+		req_set_fail(req);
 	io_put_req(req);
 	return 0;
 }
@@ -5861,7 +5860,7 @@ static int io_files_update(struct io_kiocb *req, unsigned int issue_flags)
 	mutex_unlock(&ctx->uring_lock);
 
 	if (ret < 0)
-		req_set_fail_links(req);
+		req_set_fail(req);
 	__io_req_complete(req, issue_flags, ret, 0);
 	return 0;
 }
@@ -6564,7 +6563,7 @@ static int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
 fail_req:
 		if (link->head) {
 			/* fail even hard links since we don't submit */
-			link->head->flags |= REQ_F_FAIL_LINK;
+			req_set_fail(link->head);
 			io_req_complete_failed(link->head, -ECANCELED);
 			link->head = NULL;
 		}
-- 
2.31.1

