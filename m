Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BE3B2AAB08
	for <lists+io-uring@lfdr.de>; Sun,  8 Nov 2020 13:59:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727570AbgKHM7J (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 8 Nov 2020 07:59:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726607AbgKHM7J (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 8 Nov 2020 07:59:09 -0500
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B474C0613CF
        for <io-uring@vger.kernel.org>; Sun,  8 Nov 2020 04:59:08 -0800 (PST)
Received: by mail-wm1-x341.google.com with SMTP id h2so5610227wmm.0
        for <io-uring@vger.kernel.org>; Sun, 08 Nov 2020 04:59:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OHmyDtxNbKl1VmG8Yh5vXLOjz2CeO3Vk4CvISwHueps=;
        b=QI8t0GuWBUv7wLwWz7TZ/Snj7+Sg2/Rj8Qo75EAqRKGF2UxJwfKrB+3sgnAqHfcJm3
         TFkMevP6wgW5No9i8y5SksUrI3KARae0+oAo6K+Z6f6uE9wALK/HVwc2aQhlwLsPLR5M
         jMYdxLKb5eBbgm/P0MuAKJiNMohKbSC/q7Aa6TFuYgL6lnGU1R7kX4VP2wnZ/atwFc3F
         BbQUykv4bSB58SOKq/16/MPC+58SazRa2urt8LkXP091sWlNN5THzBxHANsdmYd1UHhQ
         WuY7467WQeXcBsQgW9Lgq3PXjTWSqogry69L1FGUR8y8oqrvnvBfCd1fZV5htQjMuXvA
         27FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OHmyDtxNbKl1VmG8Yh5vXLOjz2CeO3Vk4CvISwHueps=;
        b=bAtMWRDMOH0sbzPRorpqxunBQ6D9ywMIqBI2hWBiF7YhLP4yMj1AwvIwzMZFDYzBuN
         6t0CfnIQ5+wifEtbO65QDAMUvj6mDOCYLCi9/0ZJCmoM5d/WcRtp+EjzUAX1/wMiLaXM
         U72UzSr6pjAAnVOrZJ1lFpZVmqfUd5mV/G/dwFYV1mv20Gvcb39T5HtzZS9qqg+AHaoo
         gPKojQuvO2Hq5XJXo2k4+/iY0FUJZKBgbIjERWZNiF12jY37AKEJ8EfZNBL4eNCkP28C
         /zXNP3Of+FgWpd05p83Z9sgmdYknv/Ofs4tToKDYFDa59ClAJCUyV9L/AV7DQ99DUWTd
         Rh1w==
X-Gm-Message-State: AOAM530gSDg05neFmAb/Dthx7wz6wSXEB79LF/XT5IELroWaPYPgVzSy
        vO6WTzfCngi4KiMD35AKp4H6U4XUPthgfg==
X-Google-Smtp-Source: ABdhPJw2u1KWrhNe/0frn0RvebeFwLrSUtn1Xd7AW39LZYLhrIq7LC7w54qDbaVhRct/ML+pgrsS7g==
X-Received: by 2002:a1c:2583:: with SMTP id l125mr9388555wml.50.1604840347010;
        Sun, 08 Nov 2020 04:59:07 -0800 (PST)
Received: from localhost.localdomain (host109-152-100-164.range109-152.btcentralplus.com. [109.152.100.164])
        by smtp.gmail.com with ESMTPSA id h62sm9832342wrh.82.2020.11.08.04.59.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Nov 2020 04:59:06 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     Josef Grieb <josef.grieb@gmail.com>
Subject: [PATCH 5.11] io_uring: NULL files dereference by SQPOLL
Date:   Sun,  8 Nov 2020 12:55:55 +0000
Message-Id: <d30884b71aa3e74c53a1c1f531b957cad222b7d0.1604840129.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

SQPOLL task may find sqo_task->files == NULL and
__io_sq_thread_acquire_files() would leave it unset, so following
fget_many() and others try to dereference NULL and fault. Propagate
an error files are missing.

[  118.962785] BUG: kernel NULL pointer dereference, address:
	0000000000000020
[  118.963812] #PF: supervisor read access in kernel mode
[  118.964534] #PF: error_code(0x0000) - not-present page
[  118.969029] RIP: 0010:__fget_files+0xb/0x80
[  119.005409] Call Trace:
[  119.005651]  fget_many+0x2b/0x30
[  119.005964]  io_file_get+0xcf/0x180
[  119.006315]  io_submit_sqes+0x3a4/0x950
[  119.007481]  io_sq_thread+0x1de/0x6a0
[  119.007828]  kthread+0x114/0x150
[  119.008963]  ret_from_fork+0x22/0x30

Reported-by: Josef Grieb <josef.grieb@gmail.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
v2: -EFAULT -> -EOWNERDEAD (Jens Axboe)

 fs/io_uring.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index b5aaa6e097f9..aa8aa4945a06 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1062,7 +1062,7 @@ static void io_sq_thread_drop_mm_files(void)
 	}
 }
 
-static void __io_sq_thread_acquire_files(struct io_ring_ctx *ctx)
+static int __io_sq_thread_acquire_files(struct io_ring_ctx *ctx)
 {
 	if (!current->files) {
 		struct files_struct *files;
@@ -1073,7 +1073,7 @@ static void __io_sq_thread_acquire_files(struct io_ring_ctx *ctx)
 		files = ctx->sqo_task->files;
 		if (!files) {
 			task_unlock(ctx->sqo_task);
-			return;
+			return -EOWNERDEAD;
 		}
 		atomic_inc(&files->count);
 		get_nsproxy(ctx->sqo_task->nsproxy);
@@ -1087,6 +1087,7 @@ static void __io_sq_thread_acquire_files(struct io_ring_ctx *ctx)
 		current->thread_pid = thread_pid;
 		task_unlock(current);
 	}
+	return 0;
 }
 
 static int __io_sq_thread_acquire_mm(struct io_ring_ctx *ctx)
@@ -1118,15 +1119,19 @@ static int io_sq_thread_acquire_mm_files(struct io_ring_ctx *ctx,
 					 struct io_kiocb *req)
 {
 	const struct io_op_def *def = &io_op_defs[req->opcode];
+	int ret;
 
 	if (def->work_flags & IO_WQ_WORK_MM) {
-		int ret = __io_sq_thread_acquire_mm(ctx);
+		ret = __io_sq_thread_acquire_mm(ctx);
 		if (unlikely(ret))
 			return ret;
 	}
 
-	if (def->needs_file || (def->work_flags & IO_WQ_WORK_FILES))
-		__io_sq_thread_acquire_files(ctx);
+	if (def->needs_file || (def->work_flags & IO_WQ_WORK_FILES)) {
+		ret = __io_sq_thread_acquire_files(ctx);
+		if (unlikely(ret))
+			return ret;
+	}
 
 	return 0;
 }
@@ -2134,8 +2139,8 @@ static void __io_req_task_submit(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 
-	if (!__io_sq_thread_acquire_mm(ctx)) {
-		__io_sq_thread_acquire_files(ctx);
+	if (!__io_sq_thread_acquire_mm(ctx) &&
+	    !__io_sq_thread_acquire_files(ctx)) {
 		mutex_lock(&ctx->uring_lock);
 		__io_queue_sqe(req, NULL);
 		mutex_unlock(&ctx->uring_lock);
-- 
2.24.0

