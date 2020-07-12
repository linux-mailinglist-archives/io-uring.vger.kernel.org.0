Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39CBE21CAD0
	for <lists+io-uring@lfdr.de>; Sun, 12 Jul 2020 19:44:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729272AbgGLRn7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 12 Jul 2020 13:43:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728882AbgGLRn7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 12 Jul 2020 13:43:59 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40A96C061794
        for <io-uring@vger.kernel.org>; Sun, 12 Jul 2020 10:43:59 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id w16so12176680ejj.5
        for <io-uring@vger.kernel.org>; Sun, 12 Jul 2020 10:43:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Tb9x1TMIhgTcFYTrnDCW87Q084HgoH5eU8BgCs8Y9EY=;
        b=p1+O4pgHz94La+gXnnWV9hVqpOXTfDA2Blzm6u0m1xqKOi2BymM/JaZ8Q4UJHwonl1
         YInICIsVCqTHeqmj0DbCj95KlyU/vEgbQyh+9VHzUlp0As/Cpo4vhNHpMidBN0PXjY/L
         xfuW+GCVFN2wiDwZ9t21GIkdSZj3vi/QirvOh7HmcwugW4kctQkJJ0sDXeRnbibqv28e
         bLJcoE5kaYVUnbRZFExMKV2fGaE7iSz7UTQ+DgGVYnspAqHoOqAtn/mpFuJZInpxC1e5
         OGY2GCpbn2hcP8HW8bSZ4D4Q3pDJQT5yx6NBxXWAJ1gNuHRRwZmmVhIOcjWJ7pVpSNlg
         QhPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Tb9x1TMIhgTcFYTrnDCW87Q084HgoH5eU8BgCs8Y9EY=;
        b=tuFsrLPIZ50II02+g5wIl059UMcwt5Tk6k/ehPoOuakg234yj40GDlEgmsKx0A2b0T
         Alnck8ad05jxdL+bqWKz69V22AeVWtUEG6Vece7Z/dcsIyCnLYwO0v26qBUS4+zTGBB+
         2RBe5J3qVx17ysuKAYW0f08SIUUPHj7eB9bGo5bIqFLY6cNraKVQ0dDG2pbZ+tj6IEjG
         Zzq7nwnNpbD4BK572i3hihiz/mm6uu6npNs/0CKBffIwoo28W/wX+ZM8xpdIL8/zyLWk
         0/B6q754GFMkczl/oN5XsHs/Nc1V9cs8oR2cub9qVv/X6hfbQCzSQibhEm/3VZEvZMZ/
         Vu5A==
X-Gm-Message-State: AOAM532LjL4zSehU1vZRSbTTAAqaoLxaYv0SdyKNC6p5UhCiauvKkmO7
        5AMh0tocQ0B/HKZ32vDNNcqtNbsA
X-Google-Smtp-Source: ABdhPJyAEeNfmb+E8NcwhxLkK2MruVB6BKtj6iIxwCtRzUZHmaZG/N43W37RCDYeVHmYYbaaerkmrw==
X-Received: by 2002:a17:906:aac9:: with SMTP id kt9mr65687498ejb.488.1594575837930;
        Sun, 12 Jul 2020 10:43:57 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.69])
        by smtp.gmail.com with ESMTPSA id fi29sm7871767ejb.83.2020.07.12.10.43.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jul 2020 10:43:57 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 5.9] io_uring: replace rw->task_work with rq->task_work
Date:   Sun, 12 Jul 2020 20:42:04 +0300
Message-Id: <6cd829a0f19a26aa1c40b06dde74af949e8c68a5.1594574510.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_kiocb::task_work was de-unionised, and is not planned to be shared
back, because it's too useful and commonly used. Hence, instead of
keeping a separate task_work in struct io_async_rw just reuse
req->task_work.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 31 ++++---------------------------
 1 file changed, 4 insertions(+), 27 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index fda2089f7b13..6eae2fb469f9 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -505,7 +505,6 @@ struct io_async_rw {
 	ssize_t				nr_segs;
 	ssize_t				size;
 	struct wait_page_queue		wpq;
-	struct callback_head		task_work;
 };
 
 struct io_async_ctx {
@@ -2900,33 +2899,11 @@ static int io_read_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	return 0;
 }
 
-static void io_async_buf_cancel(struct callback_head *cb)
-{
-	struct io_async_rw *rw;
-	struct io_kiocb *req;
-
-	rw = container_of(cb, struct io_async_rw, task_work);
-	req = rw->wpq.wait.private;
-	__io_req_task_cancel(req, -ECANCELED);
-}
-
-static void io_async_buf_retry(struct callback_head *cb)
-{
-	struct io_async_rw *rw;
-	struct io_kiocb *req;
-
-	rw = container_of(cb, struct io_async_rw, task_work);
-	req = rw->wpq.wait.private;
-
-	__io_req_task_submit(req);
-}
-
 static int io_async_buf_func(struct wait_queue_entry *wait, unsigned mode,
 			     int sync, void *arg)
 {
 	struct wait_page_queue *wpq;
 	struct io_kiocb *req = wait->private;
-	struct io_async_rw *rw = &req->io->rw;
 	struct wait_page_key *key = arg;
 	int ret;
 
@@ -2938,17 +2915,17 @@ static int io_async_buf_func(struct wait_queue_entry *wait, unsigned mode,
 
 	list_del_init(&wait->entry);
 
-	init_task_work(&rw->task_work, io_async_buf_retry);
+	init_task_work(&req->task_work, io_req_task_submit);
 	/* submit ref gets dropped, acquire a new one */
 	refcount_inc(&req->refs);
-	ret = io_req_task_work_add(req, &rw->task_work);
+	ret = io_req_task_work_add(req, &req->task_work);
 	if (unlikely(ret)) {
 		struct task_struct *tsk;
 
 		/* queue just for cancelation */
-		init_task_work(&rw->task_work, io_async_buf_cancel);
+		init_task_work(&req->task_work, io_req_task_cancel);
 		tsk = io_wq_get_task(req->ctx->io_wq);
-		task_work_add(tsk, &rw->task_work, 0);
+		task_work_add(tsk, &req->task_work, 0);
 		wake_up_process(tsk);
 	}
 	return 1;
-- 
2.24.0

