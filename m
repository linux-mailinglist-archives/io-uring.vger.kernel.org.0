Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0F711E021F
	for <lists+io-uring@lfdr.de>; Sun, 24 May 2020 21:22:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387755AbgEXTWf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 24 May 2020 15:22:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388257AbgEXTW3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 24 May 2020 15:22:29 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 399ADC08C5C0
        for <io-uring@vger.kernel.org>; Sun, 24 May 2020 12:22:29 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id w20so2751366pga.6
        for <io-uring@vger.kernel.org>; Sun, 24 May 2020 12:22:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kF6sqIhK1kfWOOpnyDDaJ/ad9nyWKxvOfw+GwZJVlBw=;
        b=gwUf5uPgRtpjmEmdekl/X9t1p9KbSX8a5FZv451K+HmJ+E2Dxys7Iv+FahH6uXL921
         Rl0Y5qaKfAJ0eZcvKH/3dgpG1oRJgXwwEQ7iU6vxiUjCHxy0LS/4Ic8jVU2Eu3LjGmN+
         rldYhIDm4b83DiavFv7abtxG5uSAqnGPy1LA2qmghBtOgoOmXtFwoiT5QoL4RP+GyKi5
         1QI5nAo9rFdzTXerS1E2gsghoGegqw49q0HHU6kI2nExtUVM3eLuYmzJ1n/wMbwh8yfT
         eVLUkBm32Dohxe4j71zdA/Dwmp7n/74hzA14Gx+QYz6Ec4eNIJvrlpSZtpUFZSxOOiyo
         U7Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kF6sqIhK1kfWOOpnyDDaJ/ad9nyWKxvOfw+GwZJVlBw=;
        b=Ywblc9Lw1lUXdcmtH/esnKObKLHFSvoUpjA07enErcsasrAHKqWPN++elBfDf4pcHD
         px3XOPZapUmYLCXs/Lkgu3GnnCXCX1iME9QF5Oz8Hyz1TVIlSHg/8T2uTQWEnpvh9O9u
         tt9WlGFw8mhkO4bw+bs6ftraFqo6S0cs7Fev4fQXJWglXpNnOgg+AcZ92ickFXTnG8V+
         h1Lb0aT/Ea4B/4BcgBJL3s0Jq3VjYLbfmdor7colRbfWD6nVT1260l9PnvYOiOSKxNiM
         zdIhegSPlSDjksNC7TXKDqSQ3f9ABE4YyJ0ndHpqskzwGUplwlpYfKdKb0+MwM5LXx0O
         VIgQ==
X-Gm-Message-State: AOAM533r9zGPTDI6HHpAvxjUAAqwVSqLPa2Xx4RX4wNz8XL1B5cP8Voy
        +tDR8BWDwpl12QIF8H2N94zCoMZI66vt2w==
X-Google-Smtp-Source: ABdhPJw949rfc/hqYgfl8eQoUT5vJ4BjzwrkpBKSe+ivpeT8GSGdsUzSxxCDQRY+v8G1lA3nTvPojA==
X-Received: by 2002:a63:5b0e:: with SMTP id p14mr2275730pgb.43.1590348148417;
        Sun, 24 May 2020 12:22:28 -0700 (PDT)
Received: from x1.lan ([2605:e000:100e:8c61:c871:e701:52fa:2107])
        by smtp.gmail.com with ESMTPSA id t21sm10312426pgu.39.2020.05.24.12.22.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 May 2020 12:22:27 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 12/12] io_uring: support true async buffered reads, if file provides it
Date:   Sun, 24 May 2020 13:22:06 -0600
Message-Id: <20200524192206.4093-13-axboe@kernel.dk>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200524192206.4093-1-axboe@kernel.dk>
References: <20200524192206.4093-1-axboe@kernel.dk>
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
 fs/io_uring.c | 112 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 112 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e95481c552ff..23073857239c 100644
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
@@ -2568,6 +2570,112 @@ static int io_read_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
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
 static int io_read(struct io_kiocb *req, bool force_nonblock)
 {
 	struct iovec inline_vecs[UIO_FASTIOV], *iovec = inline_vecs;
@@ -2601,6 +2709,7 @@ static int io_read(struct io_kiocb *req, bool force_nonblock)
 	if (!ret) {
 		ssize_t ret2;
 
+retry:
 		if (req->file->f_op->read_iter)
 			ret2 = call_read_iter(req->file, kiocb, &iter);
 		else
@@ -2619,6 +2728,9 @@ static int io_read(struct io_kiocb *req, bool force_nonblock)
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

