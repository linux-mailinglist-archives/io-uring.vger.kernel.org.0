Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10D731E2F5F
	for <lists+io-uring@lfdr.de>; Tue, 26 May 2020 21:53:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389848AbgEZTvr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 May 2020 15:51:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389945AbgEZTvo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 May 2020 15:51:44 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 292E5C03E97E
        for <io-uring@vger.kernel.org>; Tue, 26 May 2020 12:51:44 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id t7so9113931plr.0
        for <io-uring@vger.kernel.org>; Tue, 26 May 2020 12:51:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Yu5b4WPlNLJ4FShHKrav5N/oC/rLKGyUa0V1npLkROk=;
        b=BAnRbAHjptEKaSP7aORnMOMvcRRwJYbUJCnBMqSaZ5LExh/WyjZAx0kpm9bGHRNipQ
         c9xKOXLv3vjiGsiBY1sSp47ys77lF0zegk2Z/RxBhYkJ+oizHWibDzDtaVyKsqqZtscm
         FwEZma7bB2podeT+bwe2UFoh0El2zE5bb2ykyavUywEuTB1tSqo2t2I71EDQL0x1hfyY
         EpM1AheRzrX3I6SAVuYiX/AKHnQYJkQtPWkZ9rw2ptTOJVNcB9NTHSHihcMpSOsbvfIi
         +n+bRE/L+0dLet27JP+fhpHeclePFF8u5DEjtYpBV85c3CaIk2/0DZUoZRk4tv9rWv1y
         zZ+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Yu5b4WPlNLJ4FShHKrav5N/oC/rLKGyUa0V1npLkROk=;
        b=AXCX8assVxnwEopKzDDaNM4qVOVXR0Eo6ADudNYYX6LDT2j7pXx/SLr0Crz5R5YahO
         nFtpRHg0jrXZiRhrvOJTzcL33DwhS+4TpJlMJQ9AwQUj7GucGzsPrqjx+aGyXkMuvftD
         hRkRev3dnnIudhPt/KnbLyQAnaFTyGYg5Lb96mYROMriH8Sb+CMzjPfejnQjOuX3mmU8
         OxDnGz3/PSc2/kISg1jg0+tjsfrqs2svyEFzJACgMoHY/uyyAqsS2q1QPYgeGcmeTF40
         diowA6+qcsbJHvwa8XkiPZpJryDglmoOx3CTEjmWHpYDBbeosSoVn2bo69/GQB56vxP8
         P/NA==
X-Gm-Message-State: AOAM533iv4EWP8Je1g5/0juNQ/8HIgK00mF1lqF5jSYFPedx20ySD766
        nK7HwqcPA5H+5fAQRbC2ewbvINdT3B15mg==
X-Google-Smtp-Source: ABdhPJyp1ndQMqu6aI+tmLSQqXTreoaTLldbZ84COMrIiZ1LVkC/ujNtpmTAZp5Rn4xnmw8iMWAw9Q==
X-Received: by 2002:a17:902:228:: with SMTP id 37mr2636599plc.105.1590522703244;
        Tue, 26 May 2020 12:51:43 -0700 (PDT)
Received: from x1.lan ([2605:e000:100e:8c61:94bb:59d2:caf6:70e1])
        by smtp.gmail.com with ESMTPSA id c184sm313943pfc.57.2020.05.26.12.51.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2020 12:51:42 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, akpm@linux-foundation.org,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 12/12] io_uring: support true async buffered reads, if file provides it
Date:   Tue, 26 May 2020 13:51:23 -0600
Message-Id: <20200526195123.29053-13-axboe@kernel.dk>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526195123.29053-1-axboe@kernel.dk>
References: <20200526195123.29053-1-axboe@kernel.dk>
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
 fs/io_uring.c | 130 ++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 126 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e6865afa8467..95df63b0b2ce 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -79,6 +79,7 @@
 #include <linux/fs_struct.h>
 #include <linux/splice.h>
 #include <linux/task_work.h>
+#include <linux/pagemap.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/io_uring.h>
@@ -498,6 +499,8 @@ struct io_async_rw {
 	struct iovec			*iov;
 	ssize_t				nr_segs;
 	ssize_t				size;
+	struct wait_page_queue		wpq;
+	struct callback_head		task_work;
 };
 
 struct io_async_ctx {
@@ -2568,6 +2571,119 @@ static int io_read_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	return 0;
 }
 
+static void io_async_buf_cancel(struct callback_head *cb)
+{
+	struct io_async_rw *rw;
+	struct io_ring_ctx *ctx;
+	struct io_kiocb *req;
+
+	rw = container_of(cb, struct io_async_rw, task_work);
+	req = rw->wpq.wait.private;
+	ctx = req->ctx;
+
+	spin_lock_irq(&ctx->completion_lock);
+	io_cqring_fill_event(req, -ECANCELED);
+	io_commit_cqring(ctx);
+	spin_unlock_irq(&ctx->completion_lock);
+
+	io_cqring_ev_posted(ctx);
+	req_set_fail_links(req);
+	io_double_put_req(req);
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
+	mutex_lock(&ctx->uring_lock);
+	__io_queue_sqe(req, NULL);
+	mutex_unlock(&ctx->uring_lock);
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
+		get_task_struct(current);
+		req->task = current;
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
@@ -2601,10 +2717,7 @@ static int io_read(struct io_kiocb *req, bool force_nonblock)
 	if (!ret) {
 		ssize_t ret2;
 
-		if (req->file->f_op->read_iter)
-			ret2 = call_read_iter(req->file, kiocb, &iter);
-		else
-			ret2 = loop_rw_iter(READ, req->file, kiocb, &iter);
+		ret2 = io_iter_do_read(req, &iter);
 
 		/* Catch -EAGAIN return for forced non-blocking submission */
 		if (!force_nonblock || ret2 != -EAGAIN) {
@@ -2619,6 +2732,15 @@ static int io_read(struct io_kiocb *req, bool force_nonblock)
 			if (!(req->flags & REQ_F_NOWAIT) &&
 			    !file_can_poll(req->file))
 				req->flags |= REQ_F_MUST_PUNT;
+			/* if we can retry, do so with the callbacks armed */
+			if (io_rw_should_retry(req)) {
+				ret2 = io_iter_do_read(req, &iter);
+				if (ret2 != -EAGAIN) {
+					kiocb_done(kiocb, ret2);
+					goto out_free;
+				}
+			}
+			kiocb->ki_flags &= ~IOCB_WAITQ;
 			return -EAGAIN;
 		}
 	}
-- 
2.26.2

