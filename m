Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7F4331F265
	for <lists+io-uring@lfdr.de>; Thu, 18 Feb 2021 23:37:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbhBRWhj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 18 Feb 2021 17:37:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbhBRWhd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 18 Feb 2021 17:37:33 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D41F7C061786
        for <io-uring@vger.kernel.org>; Thu, 18 Feb 2021 14:36:52 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id f7so3520977wrt.12
        for <io-uring@vger.kernel.org>; Thu, 18 Feb 2021 14:36:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=JGgGBJ6iTcbKviDbz9y0RzSzlsU0WbAQNuIja8EPXE0=;
        b=NgRgPncTkW79mHbOMChhxFDHdlFYZfV2UIRbPhJvJy3f3KM6VKB/J8IQjlMDjX8lBn
         PIGNkCzIm7z3UPAxzQz6EukjR7kJtpcuJexG0HU2rNDESO5c4Y5by6obMg3+g1sW5jEo
         Zz9zZPTKioUHh1Eo6SwgCU71Lg+8rLIc3fGQ4B3r3KuhQSS6Htn+QPjiaY4zwv9nxfn9
         hwFTJ5BmXYMFnt/NhEelYDdvthj1cdqgN3RBT5mcSxpn9gx885+FNGL49LXfCLVzYtci
         KMBcTz/djLOjm0RP1QeKmqM5o6ie1hLaZPIIlgap2XLAoeNbZK8rbVyoRz2PfWBTf+oD
         9vTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JGgGBJ6iTcbKviDbz9y0RzSzlsU0WbAQNuIja8EPXE0=;
        b=LM3+vEw+9FJZdpFdthqMjSR+cxfIUqjSzI4Vhuc07EAhXVqAd4G7mISPZ9Ggm6Q/It
         A725JnVs3eoJ0+qCBy0gCipIGlNH82A/GyJYSQuQEMwTTSY+0Gh0/kf5zSz7Fb0cLb4B
         pSQ/e0blQgpt77+5qb3k+nAHfV+M0q2jb6NcdIb/AbmCI3PzeHVCcCi5LEmngBUdIFk8
         El3jPS/Q2rn2FmMzqPMDrCM1kav4ipe88gg9REGPRDVhqQnLkvXPsHqLH1iv5M9+UW3c
         GlsNk/+DHjewGV12f4KjPhjb/uiuKl5YrpgJPXMXKKzMX++yITzW7yRRcTszzw8bPJ/z
         8xqA==
X-Gm-Message-State: AOAM5309WxTSBRR/9yszy9BMHbYxi8WZtFcpw7sLlkF2t20S/8gIyC/H
        MYZ03xVHaokWvzpQgnwwq1w8Aqy3NDhm5Q==
X-Google-Smtp-Source: ABdhPJzaJUtJ0xyGi2X/aWua4XaBhn+gp1T+qmuAOgQgrtVLii7UzWbRWq9yTg/hiMOHhY1C6i7KEw==
X-Received: by 2002:adf:ce91:: with SMTP id r17mr6112672wrn.219.1613687811556;
        Thu, 18 Feb 2021 14:36:51 -0800 (PST)
Received: from localhost.localdomain ([85.255.236.139])
        by smtp.gmail.com with ESMTPSA id w13sm9807439wrt.49.2021.02.18.14.36.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Feb 2021 14:36:51 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 2/3] io_uring: fail io-wq submission from a task_work
Date:   Thu, 18 Feb 2021 22:32:52 +0000
Message-Id: <ae6848eec1847ff3811f13363f15308f033e7d41.1613687339.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1613687339.git.asml.silence@gmail.com>
References: <cover.1613687339.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

In case of failure io_wq_submit_work() needs to post an CQE and so
potentially take uring_lock. The safest way to deal with it is to do
that from under task_work where we can safely take the lock.

Also, as io_iopoll_check() holds the lock tight and releases it
reluctantly, it will play nicer in the furuter with notifying an
iopolling task about new such pending failed requests.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 48 ++++++++++++++++++------------------------------
 1 file changed, 18 insertions(+), 30 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 8dab07f42b34..1cb5e40d9822 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2338,7 +2338,7 @@ static void io_req_task_cancel(struct callback_head *cb)
 	struct io_ring_ctx *ctx = req->ctx;
 
 	mutex_lock(&ctx->uring_lock);
-	__io_req_task_cancel(req, -ECANCELED);
+	__io_req_task_cancel(req, req->result);
 	mutex_unlock(&ctx->uring_lock);
 	percpu_ref_put(&ctx->refs);
 }
@@ -2371,11 +2371,22 @@ static void io_req_task_queue(struct io_kiocb *req)
 	req->task_work.func = io_req_task_submit;
 	ret = io_req_task_work_add(req);
 	if (unlikely(ret)) {
+		ret = -ECANCELED;
 		percpu_ref_get(&req->ctx->refs);
 		io_req_task_work_add_fallback(req, io_req_task_cancel);
 	}
 }
 
+static void io_req_task_queue_fail(struct io_kiocb *req, int ret)
+{
+	percpu_ref_get(&req->ctx->refs);
+	req->result = ret;
+	req->task_work.func = io_req_task_cancel;
+
+	if (unlikely(io_req_task_work_add(req)))
+		io_req_task_work_add_fallback(req, io_req_task_cancel);
+}
+
 static inline void io_queue_next(struct io_kiocb *req)
 {
 	struct io_kiocb *nxt = io_req_find_next(req);
@@ -6428,13 +6439,8 @@ static void io_wq_submit_work(struct io_wq_work *work)
 	if (timeout)
 		io_queue_linked_timeout(timeout);
 
-	if (work->flags & IO_WQ_WORK_CANCEL) {
-		/* io-wq is going to take down one */
-		refcount_inc(&req->refs);
-		percpu_ref_get(&req->ctx->refs);
-		io_req_task_work_add_fallback(req, io_req_task_cancel);
-		return;
-	}
+	if (work->flags & IO_WQ_WORK_CANCEL)
+		ret = -ECANCELED;
 
 	if (!ret) {
 		do {
@@ -6450,29 +6456,11 @@ static void io_wq_submit_work(struct io_wq_work *work)
 		} while (1);
 	}
 
+	/* avoid locking problems by failing it from a clean context */
 	if (ret) {
-		struct io_ring_ctx *lock_ctx = NULL;
-
-		if (req->ctx->flags & IORING_SETUP_IOPOLL)
-			lock_ctx = req->ctx;
-
-		/*
-		 * io_iopoll_complete() does not hold completion_lock to
-		 * complete polled io, so here for polled io, we can not call
-		 * io_req_complete() directly, otherwise there maybe concurrent
-		 * access to cqring, defer_list, etc, which is not safe. Given
-		 * that io_iopoll_complete() is always called under uring_lock,
-		 * so here for polled io, we also get uring_lock to complete
-		 * it.
-		 */
-		if (lock_ctx)
-			mutex_lock(&lock_ctx->uring_lock);
-
-		req_set_fail_links(req);
-		io_req_complete(req, ret);
-
-		if (lock_ctx)
-			mutex_unlock(&lock_ctx->uring_lock);
+		/* io-wq is going to take one down */
+		refcount_inc(&req->refs);
+		io_req_task_queue_fail(req, ret);
 	}
 }
 
-- 
2.24.0

