Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A79462A969E
	for <lists+io-uring@lfdr.de>; Fri,  6 Nov 2020 14:03:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727346AbgKFNDr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 6 Nov 2020 08:03:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727343AbgKFNDp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 6 Nov 2020 08:03:45 -0500
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D1F6C0613CF
        for <io-uring@vger.kernel.org>; Fri,  6 Nov 2020 05:03:45 -0800 (PST)
Received: by mail-wr1-x442.google.com with SMTP id n15so1259343wrq.2
        for <io-uring@vger.kernel.org>; Fri, 06 Nov 2020 05:03:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=UOnItG5nno6tYqKePXrKoJVqUGKQLP86EwNFQdiF6SI=;
        b=Sv7nLS40UmfWMI7118DmPdyLt28vieJPJz8Y+WeWhWqi0OQmhfIMMvJTXkGhOKqjWE
         RtlDr7dr6vswQW27N1ESMQMqu0ERgb8uYNHMZVStZNHC72b4jXhQuZUoeTxN0VN05wSe
         7gV8s6YIWFzWQdKWBBg52pFDuLVM1D0Bdb86C+ZmC+qrLQaiRJ/vW8z8Zpe1KBGCZIzr
         HFTyH5Hru362wS6fARAJkJZhCNRfYESiJ5ZRpXD5XueYRFOWKnv3dPZzy17zufVCrUjZ
         Qcd6FEkf2tAojArbI8hhO/h/4SY5TTdmOty35vMWA98RbLL8/3nBv5oWYK5qZksKCK3d
         Ss/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UOnItG5nno6tYqKePXrKoJVqUGKQLP86EwNFQdiF6SI=;
        b=tDtshJuPbAzJw3sC5haKuLMM0qjBfJ5Y71PNuvhJ7Cyu1yYZ4IMMrMBeFsenCw4DQn
         0gXFUmtoCc1mIUFUs5ewPJDN+1E2CnCIBXNOjKzPTFEeKIHbJJdxXQ07qQzJmnmg90dR
         miISHSR6lAzOPofF+d4Uhtd2nZ67d/jlXW7Dg8fuTlESqnQ8cHiHs4kPC3t68CzX2hbQ
         /MMQKLGjgjDHt/Dqeq9QKkIeQnkFVzHDLMRNWjP/VItvZmQanoW/yEBQVP+NRq2gP9zQ
         jNmN+5yjXMZc0SlGwz6LpEluDLfdvB5xvtnHCS7gVaYUdJIXA4L9zE0vN4oNjs2oeTIV
         sgog==
X-Gm-Message-State: AOAM531QcJj4PS79qdDVhvXcqAfAjsUOoFI8Vk9D6oFeujhTX4+zOBqR
        d46CfBGSBHoq9zinox/pwKk=
X-Google-Smtp-Source: ABdhPJyQzLqmBq7sZTkpDPEKMvhVNta98uW7w2TVhJ7nVsQ8cPBKT7Lv0sNKwRFECgyCTmCZvDr/tA==
X-Received: by 2002:a5d:490a:: with SMTP id x10mr2482777wrq.289.1604667824053;
        Fri, 06 Nov 2020 05:03:44 -0800 (PST)
Received: from localhost.localdomain (host109-152-100-228.range109-152.btcentralplus.com. [109.152.100.228])
        by smtp.gmail.com with ESMTPSA id e5sm1931839wrw.93.2020.11.06.05.03.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2020 05:03:43 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 4/6] io_uring: don't iterate io_uring_cancel_files()
Date:   Fri,  6 Nov 2020 13:00:24 +0000
Message-Id: <bbdd2b1003c8eba92c3465af2152c92dc5c484dd.1604667122.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1604667122.git.asml.silence@gmail.com>
References: <cover.1604667122.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_uring_cancel_files() guarantees to cancel all matching requests,
that's not necessary to do that in a loop. Move it up in the callchain
into io_uring_cancel_task_requests().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 34 ++++++++++++----------------------
 1 file changed, 12 insertions(+), 22 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 8716a864b8b5..22ac3ce57819 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8782,16 +8782,10 @@ static void io_cancel_defer_files(struct io_ring_ctx *ctx,
 	}
 }
 
-/*
- * Returns true if we found and killed one or more files pinning requests
- */
-static bool io_uring_cancel_files(struct io_ring_ctx *ctx,
+static void io_uring_cancel_files(struct io_ring_ctx *ctx,
 				  struct task_struct *task,
 				  struct files_struct *files)
 {
-	if (list_empty_careful(&ctx->inflight_list))
-		return false;
-
 	while (!list_empty_careful(&ctx->inflight_list)) {
 		struct io_kiocb *cancel_req = NULL, *req;
 		DEFINE_WAIT(wait);
@@ -8824,8 +8818,6 @@ static bool io_uring_cancel_files(struct io_ring_ctx *ctx,
 		schedule();
 		finish_wait(&ctx->inflight_wait, &wait);
 	}
-
-	return true;
 }
 
 static bool io_cancel_task_cb(struct io_wq_work *work, void *data)
@@ -8836,15 +8828,12 @@ static bool io_cancel_task_cb(struct io_wq_work *work, void *data)
 	return io_task_match(req, task);
 }
 
-static bool __io_uring_cancel_task_requests(struct io_ring_ctx *ctx,
-					    struct task_struct *task,
-					    struct files_struct *files)
+static void __io_uring_cancel_task_requests(struct io_ring_ctx *ctx,
+					    struct task_struct *task)
 {
-	bool ret;
-
-	ret = io_uring_cancel_files(ctx, task, files);
-	if (!files) {
+	while (1) {
 		enum io_wq_cancel cret;
+		bool ret = false;
 
 		cret = io_wq_cancel_cb(ctx->io_wq, io_cancel_task_cb, task, true);
 		if (cret != IO_WQ_CANCEL_NOTFOUND)
@@ -8860,9 +8849,11 @@ static bool __io_uring_cancel_task_requests(struct io_ring_ctx *ctx,
 
 		ret |= io_poll_remove_all(ctx, task);
 		ret |= io_kill_timeouts(ctx, task);
+		if (!ret)
+			break;
+		io_run_task_work();
+		cond_resched();
 	}
-
-	return ret;
 }
 
 /*
@@ -8883,11 +8874,10 @@ static void io_uring_cancel_task_requests(struct io_ring_ctx *ctx,
 
 	io_cancel_defer_files(ctx, task, files);
 	io_cqring_overflow_flush(ctx, true, task, files);
+	io_uring_cancel_files(ctx, task, files);
 
-	while (__io_uring_cancel_task_requests(ctx, task, files)) {
-		io_run_task_work();
-		cond_resched();
-	}
+	if (!files)
+		__io_uring_cancel_task_requests(ctx, task);
 
 	if ((ctx->flags & IORING_SETUP_SQPOLL) && ctx->sq_data) {
 		atomic_dec(&task->io_uring->in_idle);
-- 
2.24.0

