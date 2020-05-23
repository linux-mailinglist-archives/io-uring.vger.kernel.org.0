Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBD391DFA75
	for <lists+io-uring@lfdr.de>; Sat, 23 May 2020 20:58:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387953AbgEWS62 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 23 May 2020 14:58:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729294AbgEWS6P (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 23 May 2020 14:58:15 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A4E4C05BD43
        for <io-uring@vger.kernel.org>; Sat, 23 May 2020 11:58:15 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id bg4so454078plb.3
        for <io-uring@vger.kernel.org>; Sat, 23 May 2020 11:58:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GQtcjtwnU9F7a1xhLgA90kANNYHFVxRq3n7Obk4hkPQ=;
        b=E0uPtgkYhXBae4y7rlBd21x1yAP+XlS0DVODNinqmDmyAgdYw2RsQ25SLxSF6ERpv1
         veDVT0mpV7fEOKRNLTGkblV6lALQZ7PV9rXDGl2Bb1su+TuWnaE6Jm8bR0c4ZKs+8Cm5
         sg5/gBNyxUSGxZBGBWMQ/mEMbxvZQZqOzwFTA9uHjv1f7B4gDztH1Yeak04JrtR2nFET
         JA/Xt+M3L1U8nLvWKWmX/YQumQTeD9jpadLQqXeXEqrTZYyncyoQBYa/uE8q5T+CZuhK
         Q0VUcexOGDzE/0KhBGJz3nHdLRM0fCW1MUKHVHw/Au0TxS0SGODZlE1ydZI+ZkrfDc+p
         BIuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GQtcjtwnU9F7a1xhLgA90kANNYHFVxRq3n7Obk4hkPQ=;
        b=XRQMIx/RdXe2oaHkXquiMhVmPmIyscrlzgOC3g6ho1TlC5qz69ukgKJGqmcKftTizs
         NGVN7GdMGtZLVGXCZc0cF1Cg5jf5DJGTvDzsers3y1RlmRSBpqAVmwC6DIMR4/vnbHxQ
         itoyR8t/scPPWw4yOVhiEoxJTEsyQDMp0Ih0iRp4Ooh56UfOhsZqwgEEnMHZeJnHqbjm
         BLYBlUbWDy986YNJwACnn33Z38+d/yPBvF4grHUniFIB10Wbw1lU+cKi3rhUUOi/GVzr
         PaAciBeeWP6Hy5pU28h0y2cQSY1wh/ySEi6wU6vCYv48pkv09KgW4q9bJLu8kUePh9CG
         Q2ug==
X-Gm-Message-State: AOAM531cHrbgYvOMojd/7zS9n+X7k9Dx/11tgOq4TZiXUgDKbgIoE6JJ
        C8yeBtLsiWxPD9ssTRRX/Guh1JXxCPrImw==
X-Google-Smtp-Source: ABdhPJx4KsH8h/drBYUvQJv/Dz+r/aEgN2c8froIAby4k4P0elQuuxHZl85dOhwf7AOlLjolOCHVug==
X-Received: by 2002:a17:902:bf08:: with SMTP id bi8mr19450469plb.319.1590260294621;
        Sat, 23 May 2020 11:58:14 -0700 (PDT)
Received: from x1.lan ([2605:e000:100e:8c61:c94:a67a:9209:cf5f])
        by smtp.gmail.com with ESMTPSA id 25sm9297319pjk.50.2020.05.23.11.58.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 May 2020 11:58:14 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 12/12] io_uring: support true async buffered reads, if file provides it
Date:   Sat, 23 May 2020 12:57:55 -0600
Message-Id: <20200523185755.8494-13-axboe@kernel.dk>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200523185755.8494-1-axboe@kernel.dk>
References: <20200523185755.8494-1-axboe@kernel.dk>
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
 fs/io_uring.c | 99 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 99 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e95481c552ff..dd532d2634c2 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -498,6 +498,8 @@ struct io_async_rw {
 	struct iovec			*iov;
 	ssize_t				nr_segs;
 	ssize_t				size;
+	struct wait_page_queue		wpq;
+	struct callback_head		task_work;
 };
 
 struct io_async_ctx {
@@ -2568,6 +2570,99 @@ static int io_read_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
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
+	ret = kiocb_wait_page_queue_init(kiocb, &req->io->rw.wpq,
+						io_async_buf_func, req);
+	if (ret)
+		return false;
+	get_task_struct(current);
+	req->task = current;
+	return true;
+}
+
 static int io_read(struct io_kiocb *req, bool force_nonblock)
 {
 	struct iovec inline_vecs[UIO_FASTIOV], *iovec = inline_vecs;
@@ -2601,6 +2696,7 @@ static int io_read(struct io_kiocb *req, bool force_nonblock)
 	if (!ret) {
 		ssize_t ret2;
 
+retry:
 		if (req->file->f_op->read_iter)
 			ret2 = call_read_iter(req->file, kiocb, &iter);
 		else
@@ -2619,6 +2715,9 @@ static int io_read(struct io_kiocb *req, bool force_nonblock)
 			if (!(req->flags & REQ_F_NOWAIT) &&
 			    !file_can_poll(req->file))
 				req->flags |= REQ_F_MUST_PUNT;
+			if (io_rw_should_retry(req))
+				goto retry;
+			kiocb->ki_flags &= ~IOCB_WAITQ;
 			return -EAGAIN;
 		}
 	}
-- 
2.26.2

