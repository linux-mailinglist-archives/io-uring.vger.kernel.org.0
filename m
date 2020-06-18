Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EEA01FF521
	for <lists+io-uring@lfdr.de>; Thu, 18 Jun 2020 16:46:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726981AbgFROpH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 18 Jun 2020 10:45:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731034AbgFROob (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 18 Jun 2020 10:44:31 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B77B0C0619C0
        for <io-uring@vger.kernel.org>; Thu, 18 Jun 2020 07:44:20 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id h95so2772224pje.4
        for <io-uring@vger.kernel.org>; Thu, 18 Jun 2020 07:44:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references:reply-to
         :mime-version:content-transfer-encoding;
        bh=hItvrdMXW3x4/4yokWms4yIKM/BxkkcMkxbyn/WrUe0=;
        b=RfkCMfGNHVXXALcOZPZ2jdMi+X2j7BbBbajuLvtbMQgxMG/R/SN9Lmnx9NaM1whfmk
         FoFat2Ffm7ozF2Am9lqvkz0jsEoF+28OalJ8pxWgXrDzHjm9PzijBHVdQeoN953xZdDY
         tf/dvYtXZA04B8ODzL5vUKx87iaBZufPMtd6kedtozYO9BMoAcWeY9LWTHO0Ida6RpP3
         x1eoT/nTeXvRj4v/5yKnIft1RpIV2avzGEzDdkbF3szc11YLa/Lb2tqMcnSEDn0GFTjr
         Fg3FMcJwXY/ZGtqbb19AHc5aPFxfUxJG8rl9k5i052NZMKop0iiA8EZgxFfSHlvxzSqN
         C9BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:reply-to:mime-version:content-transfer-encoding;
        bh=hItvrdMXW3x4/4yokWms4yIKM/BxkkcMkxbyn/WrUe0=;
        b=fX8uaWP8UqEpVS5+A69cEwnWrExaqFIPOGEJCr2VNFEvxHG+JGNmtjixUkZsOWmlgX
         nydD6camCzzab862v5RDo6xco5XGY6vrE0t6b0gxlbQmkb9YhSj3kTgc7ppdHbCUTcjl
         yMUFZbmMuNXvrreM4lFy5K4BGR8KVzk0ACOKy8QmGXQJtZ0ILKPRu2OsCaFmm7PuBuGX
         XnokQAMHDj5z5iD8SEGP7yWb3TfNyf3zni3ev0E964n27i6meRqnPhOlUVe0tshiOHeD
         wd2Lvpyu4GigXooC0aq6NE9mvsuSQLrWsj5zJ3mrns0JZ9isYocHVhEkfO64VeXmjExM
         TgpQ==
X-Gm-Message-State: AOAM530dcoOsXqNvm12C8qm+exBp4YD9Og8/V6NvvAiPrrPX6NmHjZnK
        RGoOHTkAZhSx++6uhew/vzDI5ZmMvvLXcQ==
X-Google-Smtp-Source: ABdhPJxS5EFTVcmIXFEiggPIpu8uYctGJadye2v8tGqmJWPLNu+hH9ccfCYUZJj+BdxVYR30oM/QCw==
X-Received: by 2002:a17:902:7c8f:: with SMTP id y15mr3899856pll.95.1592491459962;
        Thu, 18 Jun 2020 07:44:19 -0700 (PDT)
Received: from x1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id g9sm3127197pfm.151.2020.06.18.07.44.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jun 2020 07:44:19 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, akpm@linux-foundation.org,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 15/15] io_uring: support true async buffered reads, if file provides it
Date:   Thu, 18 Jun 2020 08:43:55 -0600
Message-Id: <20200618144355.17324-16-axboe@kernel.dk>
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

If the file is flagged with FMODE_BUF_RASYNC, then we don't have to punt
the buffered read to an io-wq worker. Instead we can rely on page
unlocking callbacks to support retry based async IO. This is a lot more
efficient than doing async thread offload.

The retry is done similarly to how we handle poll based retry. From
the unlock callback, we simply queue the retry to a task_work based
handler.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 145 +++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 137 insertions(+), 8 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 40413fb9d07b..94282be1c413 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -78,6 +78,7 @@
 #include <linux/fs_struct.h>
 #include <linux/splice.h>
 #include <linux/task_work.h>
+#include <linux/pagemap.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/io_uring.h>
@@ -503,6 +504,8 @@ struct io_async_rw {
 	struct iovec			*iov;
 	ssize_t				nr_segs;
 	ssize_t				size;
+	struct wait_page_queue		wpq;
+	struct callback_head		task_work;
 };
 
 struct io_async_ctx {
@@ -2750,6 +2753,126 @@ static int io_read_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	return 0;
 }
 
+static void __io_async_buf_error(struct io_kiocb *req, int error)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+
+	spin_lock_irq(&ctx->completion_lock);
+	io_cqring_fill_event(req, error);
+	io_commit_cqring(ctx);
+	spin_unlock_irq(&ctx->completion_lock);
+
+	io_cqring_ev_posted(ctx);
+	req_set_fail_links(req);
+	io_double_put_req(req);
+}
+
+static void io_async_buf_cancel(struct callback_head *cb)
+{
+	struct io_async_rw *rw;
+	struct io_kiocb *req;
+
+	rw = container_of(cb, struct io_async_rw, task_work);
+	req = rw->wpq.wait.private;
+	__io_async_buf_error(req, -ECANCELED);
+}
+
+static void io_async_buf_retry(struct callback_head *cb)
+{
+	struct io_async_rw *rw;
+	struct io_ring_ctx *ctx;
+	struct io_kiocb *req;
+
+	rw = container_of(cb, struct io_async_rw, task_work);
+	req = rw->wpq.wait.private;
+	ctx = req->ctx;
+
+	__set_current_state(TASK_RUNNING);
+	if (!io_sq_thread_acquire_mm(ctx, req)) {
+		mutex_lock(&ctx->uring_lock);
+		__io_queue_sqe(req, NULL);
+		mutex_unlock(&ctx->uring_lock);
+	} else {
+		__io_async_buf_error(req, -EFAULT);
+	}
+}
+
+static int io_async_buf_func(struct wait_queue_entry *wait, unsigned mode,
+			     int sync, void *arg)
+{
+	struct wait_page_queue *wpq;
+	struct io_kiocb *req = wait->private;
+	struct io_async_rw *rw = &req->io->rw;
+	struct wait_page_key *key = arg;
+	struct task_struct *tsk;
+	int ret;
+
+	wpq = container_of(wait, struct wait_page_queue, wait);
+
+	ret = wake_page_match(wpq, key);
+	if (ret != 1)
+		return ret;
+
+	list_del_init(&wait->entry);
+
+	init_task_work(&rw->task_work, io_async_buf_retry);
+	/* submit ref gets dropped, acquire a new one */
+	refcount_inc(&req->refs);
+	tsk = req->task;
+	ret = task_work_add(tsk, &rw->task_work, true);
+	if (unlikely(ret)) {
+		/* queue just for cancelation */
+		init_task_work(&rw->task_work, io_async_buf_cancel);
+		tsk = io_wq_get_task(req->ctx->io_wq);
+		task_work_add(tsk, &rw->task_work, true);
+	}
+	wake_up_process(tsk);
+	return 1;
+}
+
+static bool io_rw_should_retry(struct io_kiocb *req)
+{
+	struct kiocb *kiocb = &req->rw.kiocb;
+	int ret;
+
+	/* never retry for NOWAIT, we just complete with -EAGAIN */
+	if (req->flags & REQ_F_NOWAIT)
+		return false;
+
+	/* already tried, or we're doing O_DIRECT */
+	if (kiocb->ki_flags & (IOCB_DIRECT | IOCB_WAITQ))
+		return false;
+	/*
+	 * just use poll if we can, and don't attempt if the fs doesn't
+	 * support callback based unlocks
+	 */
+	if (file_can_poll(req->file) || !(req->file->f_mode & FMODE_BUF_RASYNC))
+		return false;
+
+	/*
+	 * If request type doesn't require req->io to defer in general,
+	 * we need to allocate it here
+	 */
+	if (!req->io && __io_alloc_async_ctx(req))
+		return false;
+
+	ret = kiocb_wait_page_queue_init(kiocb, &req->io->rw.wpq,
+						io_async_buf_func, req);
+	if (!ret) {
+		io_get_req_task(req);
+		return true;
+	}
+
+	return false;
+}
+
+static int io_iter_do_read(struct io_kiocb *req, struct iov_iter *iter)
+{
+	if (req->file->f_op->read_iter)
+		return call_read_iter(req->file, &req->rw.kiocb, iter);
+	return loop_rw_iter(READ, req->file, &req->rw.kiocb, iter);
+}
+
 static int io_read(struct io_kiocb *req, bool force_nonblock)
 {
 	struct iovec inline_vecs[UIO_FASTIOV], *iovec = inline_vecs;
@@ -2784,10 +2907,7 @@ static int io_read(struct io_kiocb *req, bool force_nonblock)
 		unsigned long nr_segs = iter.nr_segs;
 		ssize_t ret2 = 0;
 
-		if (req->file->f_op->read_iter)
-			ret2 = call_read_iter(req->file, kiocb, &iter);
-		else
-			ret2 = loop_rw_iter(READ, req->file, kiocb, &iter);
+		ret2 = io_iter_do_read(req, &iter);
 
 		/* Catch -EAGAIN return for forced non-blocking submission */
 		if (!force_nonblock || (ret2 != -EAGAIN && ret2 != -EIO)) {
@@ -2799,17 +2919,26 @@ static int io_read(struct io_kiocb *req, bool force_nonblock)
 			ret = io_setup_async_rw(req, io_size, iovec,
 						inline_vecs, &iter);
 			if (ret)
-				goto out_free;
+				goto out;
 			/* any defer here is final, must blocking retry */
 			if (!(req->flags & REQ_F_NOWAIT) &&
 			    !file_can_poll(req->file))
 				req->flags |= REQ_F_MUST_PUNT;
+			/* if we can retry, do so with the callbacks armed */
+			if (io_rw_should_retry(req)) {
+				ret2 = io_iter_do_read(req, &iter);
+				if (ret2 == -EIOCBQUEUED) {
+					goto out;
+				} else if (ret2 != -EAGAIN) {
+					kiocb_done(kiocb, ret2);
+					goto out;
+				}
+			}
+			kiocb->ki_flags &= ~IOCB_WAITQ;
 			return -EAGAIN;
 		}
 	}
-out_free:
-	kfree(iovec);
-	req->flags &= ~REQ_F_NEED_CLEANUP;
+out:
 	return ret;
 }
 
-- 
2.27.0

