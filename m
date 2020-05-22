Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 619A31DF088
	for <lists+io-uring@lfdr.de>; Fri, 22 May 2020 22:23:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731119AbgEVUXg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 May 2020 16:23:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731076AbgEVUXd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 22 May 2020 16:23:33 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C11EC061A0E
        for <io-uring@vger.kernel.org>; Fri, 22 May 2020 13:23:33 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id b12so4815387plz.13
        for <io-uring@vger.kernel.org>; Fri, 22 May 2020 13:23:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1VFf/UOKNgDVHZUKx45LznEg0u8N2FCy/awErcAtR0g=;
        b=Qy+W6tsCL3NH8Bq3rG6/UjcK93NBssdcv0jZGDBJKxqpc8Af5iRRlidXvE4LvcTbjQ
         VswLrbHzrKsuwOrz8VLGnv4GIz9ELw0+Ck61xKY0Cn/sicxCkPfwlPILus5BsdR4XbHd
         FivBuJiFW4rFu1pVMTyYm5FNYETtOu+OOK1rt/4nQryYpkvnhwXM0A8XWOflc3woQ/sR
         5DVb+1ZIdrXK55MofhVLQcNwXyEsdQ/96R6uxVzL1zl1RP6pM7dRbw7qO6+uESrtdbTm
         TkK2TDXxpzbuWMaamdVVkjq2ku206Y+RpE6CKRjgQcmzRKlbx4iykHwOt3uPGN411ew9
         Vgxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1VFf/UOKNgDVHZUKx45LznEg0u8N2FCy/awErcAtR0g=;
        b=Qp/0KOxzuI/YWVxb+YhgOjlqkqaC7P7CKQjXwbP+kYILBg5Nxw9CW97pJyoXA+V7b4
         W5RR2sfa9mjOx8T6oNzoYDeYXUHp4Ym0O9YxiFeGgQaWDxPYPoT4U0kms9q/PaJQcj+T
         j6OyQQlXHINHvWFye3LzBzEmICZiFzpd2G70EBjn7hbtlzonQJvzaLY7E/nEBIrLE7e/
         22FyHjPVOv5kNR/VC4BzPWRoOyFaE2whOMj6zZeGErmQZ8EQhOqMwS8ZZDXvm1G/QKsl
         aHGaa++sIgxRthGBTN8d7oTcvuFBvAuFzaa6y2wMG36TGHJm1StqDvhaBlbyheX3Qdw5
         ZFqA==
X-Gm-Message-State: AOAM532uMfppO1WKF1DsuHqfD7XpBlU7VkXJkZa9iU5t+xk3IPY1BgZ/
        Xv8rSRmou1D4+/jtlf0hmEXGoiQ0moQ=
X-Google-Smtp-Source: ABdhPJyT3Ms2U6ScNVRxn8m3K+qYSXq6NTkzTCRzpeAAa7saFGGrDfVA2J0tFqYg01QCmFSbHYGH+w==
X-Received: by 2002:a17:902:228:: with SMTP id 37mr16857591plc.105.1590179012288;
        Fri, 22 May 2020 13:23:32 -0700 (PDT)
Received: from x1.lan ([2605:e000:100e:8c61:e0db:da55:b0a4:601])
        by smtp.gmail.com with ESMTPSA id e19sm7295561pfn.17.2020.05.22.13.23.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2020 13:23:31 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 11/11] io_uring: support true async buffered reads, if file provides it
Date:   Fri, 22 May 2020 14:23:11 -0600
Message-Id: <20200522202311.10959-12-axboe@kernel.dk>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200522202311.10959-1-axboe@kernel.dk>
References: <20200522202311.10959-1-axboe@kernel.dk>
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
 fs/io_uring.c | 101 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 101 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e95481c552ff..f0ca98bb688f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -498,6 +498,8 @@ struct io_async_rw {
 	struct iovec			*iov;
 	ssize_t				nr_segs;
 	ssize_t				size;
+	struct wait_page_async		wait;
+	struct callback_head		task_work;
 };
 
 struct io_async_ctx {
@@ -2568,6 +2570,101 @@ static int io_read_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	return 0;
 }
 
+static void io_async_buf_cancel(struct callback_head *cb)
+{
+	struct io_async_rw *rw;
+	struct io_ring_ctx *ctx;
+	struct io_kiocb *req;
+
+	rw = container_of(cb, struct io_async_rw, task_work);
+	req = rw->wait.wait.private;
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
+	req = rw->wait.wait.private;
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
+	struct wait_page_async *wp;
+	struct io_kiocb *req = wait->private;
+	struct io_async_rw *rw = &req->io->rw;
+	struct wait_page_key *key = arg;
+	struct task_struct *tsk;
+	int ret;
+
+	wp = container_of(wait, struct wait_page_async, wait);
+	if (wp->key.page != key->page)
+		return 0;
+	if (wp->key.bit_nr != key->bit_nr)
+		return 0;
+	if (test_bit(PG_locked, &key->page->flags))
+		return -1;
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
+	ret = kiocb_wait_page_async_init(kiocb, &req->io->rw.wait,
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
@@ -2601,6 +2698,7 @@ static int io_read(struct io_kiocb *req, bool force_nonblock)
 	if (!ret) {
 		ssize_t ret2;
 
+retry:
 		if (req->file->f_op->read_iter)
 			ret2 = call_read_iter(req->file, kiocb, &iter);
 		else
@@ -2619,6 +2717,9 @@ static int io_read(struct io_kiocb *req, bool force_nonblock)
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

