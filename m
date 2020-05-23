Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 431451DF3FA
	for <lists+io-uring@lfdr.de>; Sat, 23 May 2020 03:51:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387587AbgEWBvO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 May 2020 21:51:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387582AbgEWBvL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 22 May 2020 21:51:11 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C79C2C08C5C5
        for <io-uring@vger.kernel.org>; Fri, 22 May 2020 18:51:11 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id 23so5999361pfy.8
        for <io-uring@vger.kernel.org>; Fri, 22 May 2020 18:51:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Wd+Rnx5Y+ukW2PvArxihC3mXgVqc6YPFp4BCl1P9bmM=;
        b=cuiALyzqy5LdaGkggEMKMw8ZCbPYkVsgaGoYkowUv2YSqau1sCJea1+tn9y+FD2jE0
         hqs9giU8Mi3LAGZ7Yy4V2tu22HzwH3W81J8+fBe9bvb1GODyDanjB735pb1vgFfx19+c
         vSLpeyOjo6AaiBKXXUUUCBj5yRXMrOhX4sjADgLdrD6qQfN2X3QnC6PsVLemka9yqxy2
         LDVcNP7vH1c4WJIP5GG2T5p+I+bqIcwJAREQ8SkTyyjweJ4KWTvpGe1TR5xjJXMA3Ww4
         5K73NgWM8zvy5ZCFXxxXE4JdmpfIlctPbay9J6SCA/1iaFUvCpYuDLZeLP+qDI2bVj7S
         4CWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Wd+Rnx5Y+ukW2PvArxihC3mXgVqc6YPFp4BCl1P9bmM=;
        b=ieo4WRZFGzy0XhwG7Ubr52MFt26oMNbnG60xxezhl9DVtqM8yAeitHq4HlS9rd9xbD
         mooQUTBtH5o1ClfiBJsJm12NH7eOXqHY8U7mYIUXHtOO6CDaGpE/0EkE4BkID66LFs5d
         z65grY4p44goSMa6Rw/9Cy5AMp8nM+81SmhUuZh17d1Aq9Mb91Tpn+8gkAqDWBO5bmix
         nqKwQd2F34g3pjUK7vxW3pLADch6+SRxhfVMTExaAHSRSadIGGpQj0y+WxCoriEFwnjC
         zBokWV+YsMz4KmisgnkGyzj6KpWlMte3y6LXWnZaxO9MicsbYdHr8r3W1FbwFKg0i6gz
         p/UQ==
X-Gm-Message-State: AOAM531nSNuniolQYKnoUyI2H82hpj7lGdgmS5vM3/tl/FK+cJ0GwLR6
        QzI3HoFE0LIXUEM1HgzERfXqB8k8sl0=
X-Google-Smtp-Source: ABdhPJyd+1pCYzGsi2Ok0s0JF7kIgQclUmTGxfhARdgyfgJsfSNYz06K7py8/X/MIRJH7+fbjmCzaw==
X-Received: by 2002:aa7:9096:: with SMTP id i22mr6644986pfa.250.1590198671034;
        Fri, 22 May 2020 18:51:11 -0700 (PDT)
Received: from x1.lan ([2605:e000:100e:8c61:e0db:da55:b0a4:601])
        by smtp.gmail.com with ESMTPSA id a71sm8255477pje.0.2020.05.22.18.51.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2020 18:51:10 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 11/11] io_uring: support true async buffered reads, if file provides it
Date:   Fri, 22 May 2020 19:50:49 -0600
Message-Id: <20200523015049.14808-12-axboe@kernel.dk>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200523015049.14808-1-axboe@kernel.dk>
References: <20200523015049.14808-1-axboe@kernel.dk>
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
 fs/io_uring.c | 102 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 102 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e95481c552ff..9eeae10db648 100644
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
@@ -2568,6 +2570,102 @@ static int io_read_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
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
+	key->page_match = 1;
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
@@ -2601,6 +2699,7 @@ static int io_read(struct io_kiocb *req, bool force_nonblock)
 	if (!ret) {
 		ssize_t ret2;
 
+retry:
 		if (req->file->f_op->read_iter)
 			ret2 = call_read_iter(req->file, kiocb, &iter);
 		else
@@ -2619,6 +2718,9 @@ static int io_read(struct io_kiocb *req, bool force_nonblock)
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

