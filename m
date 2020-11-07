Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D52BB2AA811
	for <lists+io-uring@lfdr.de>; Sat,  7 Nov 2020 22:19:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725838AbgKGVTl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 7 Nov 2020 16:19:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725836AbgKGVTl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 7 Nov 2020 16:19:41 -0500
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE62DC0613CF
        for <io-uring@vger.kernel.org>; Sat,  7 Nov 2020 13:19:40 -0800 (PST)
Received: by mail-wr1-x443.google.com with SMTP id p1so4832253wrf.12
        for <io-uring@vger.kernel.org>; Sat, 07 Nov 2020 13:19:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=t4e0iXG5FIGIGJrC0LsHWvdTcPYlerce6UKZEEVPGFA=;
        b=fXpkWu7whTpNpXEree18BnDjV8CN08JuIUYcy6M3p7PevsLhtoCqh9gawQVJS4O7Mz
         Ttu1EgC2+WWry1D7XvwARelknl0CIAU752F//HMHUusX/5wIGBJ0uhPH1BOziHpBVmF1
         8Flen9KwAVekOs/E7dMLIypLf9g2eJe19J+mGQ+tZ03PNrp7WTo4VHuJoytsv/3Ofjt8
         8LFhSD0z8pNpZhN7aDWom0X2A6Bu1fFgzG9eVN3QFcbUMniqdn+caJaQQdh+vSgY4PKS
         fLbPzGUmWl4DtorXcrHLzE7qnqJ+QW/gzVgcLv8cNGF1yG/G5Yvssj1cJfk+IaULo0bg
         SQog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=t4e0iXG5FIGIGJrC0LsHWvdTcPYlerce6UKZEEVPGFA=;
        b=a0aXNKg9Bg1E1yVeBsNghidGW9tsXsJugsxUzh3i9tYbEicTXtfBoxHVy8crQk7mOu
         6+WGoctl60v+N64Tn7sIyA5vboetGHClMXc0aNXV6nnZM2rx9ZU5tbUOQ9XsPNOoSLJL
         TgmVj/HuNrLgfaGwnWPUofWdmAL/aTe+TOJ1PNUHfQiWYEuj6AI4c3ISyG+nnZTV3AwK
         HEtbYCL/DNhp12HBCXx9dv/ofr0ybB9v4UWreh3kTMIq3duwmjSekbe2RwtDgmgyYGAY
         k1Hnz62+ZxEf1z2l9LJ/4yMR/TXe13F69CpVSyujS2KQTUQZqyTG/0dLHSHkvI5NbvLt
         F/Kg==
X-Gm-Message-State: AOAM533IAgegsHo3u59eMenGH2NnS1qyrMMRbBLs4NGmVSrpLO7tDJiz
        pHYJdiPNsHxEOoJJiGeIc1Y=
X-Google-Smtp-Source: ABdhPJyfaGAsrt75ojMXKEZTguCHBHelKlwPPKDczQXj3+KrG9Tb1xFnldx2hn13iW+67j76O2DUbA==
X-Received: by 2002:adf:e48d:: with SMTP id i13mr9250093wrm.387.1604783979480;
        Sat, 07 Nov 2020 13:19:39 -0800 (PST)
Received: from localhost.localdomain (host109-152-100-164.range109-152.btcentralplus.com. [109.152.100.164])
        by smtp.gmail.com with ESMTPSA id j9sm7705183wrp.59.2020.11.07.13.19.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2020 13:19:38 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     Josef Grieb <josef.grieb@gmail.com>
Subject: [PATCH 5.11] io_uring: NULL files dereference by SQPOLL
Date:   Sat,  7 Nov 2020 21:16:29 +0000
Message-Id: <24446f4e23e80803d3ab1a4d27a6d1a605e37b32.1604783766.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

SQPOLL task may find sqo_task->files == NULL, so
__io_sq_thread_acquire_files() would left it unset and so all the
following fails, e.g. attempts to submit. Fail if sqo_task doesn't have
files.

[  118.962785] BUG: kernel NULL pointer dereference, address:
	0000000000000020
[  118.963812] #PF: supervisor read access in kernel mode
[  118.964534] #PF: error_code(0x0000) - not-present page
[  118.969029] RIP: 0010:__fget_files+0xb/0x80
[  119.005409] Call Trace:
[  119.005651]  fget_many+0x2b/0x30
[  119.005964]  io_file_get+0xcf/0x180
[  119.006315]  io_submit_sqes+0x3a4/0x950
[  119.006678]  ? io_double_put_req+0x43/0x70
[  119.007054]  ? io_async_task_func+0xc2/0x180
[  119.007481]  io_sq_thread+0x1de/0x6a0
[  119.007828]  kthread+0x114/0x150
[  119.008135]  ? __ia32_sys_io_uring_enter+0x3c0/0x3c0
[  119.008623]  ? kthread_park+0x90/0x90
[  119.008963]  ret_from_fork+0x22/0x30

Reported-by: Josef Grieb <josef.grieb@gmail.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 8d721a652d61..9c035c5c4080 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1080,7 +1080,7 @@ static void io_sq_thread_drop_mm_files(void)
 	}
 }
 
-static void __io_sq_thread_acquire_files(struct io_ring_ctx *ctx)
+static int __io_sq_thread_acquire_files(struct io_ring_ctx *ctx)
 {
 	if (!current->files) {
 		struct files_struct *files;
@@ -1091,7 +1091,7 @@ static void __io_sq_thread_acquire_files(struct io_ring_ctx *ctx)
 		files = ctx->sqo_task->files;
 		if (!files) {
 			task_unlock(ctx->sqo_task);
-			return;
+			return -EFAULT;
 		}
 		atomic_inc(&files->count);
 		get_nsproxy(ctx->sqo_task->nsproxy);
@@ -1105,6 +1105,7 @@ static void __io_sq_thread_acquire_files(struct io_ring_ctx *ctx)
 		current->thread_pid = thread_pid;
 		task_unlock(current);
 	}
+	return 0;
 }
 
 static int __io_sq_thread_acquire_mm(struct io_ring_ctx *ctx)
@@ -1136,15 +1137,19 @@ static int io_sq_thread_acquire_mm_files(struct io_ring_ctx *ctx,
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
@@ -2117,8 +2122,8 @@ static void __io_req_task_submit(struct io_kiocb *req)
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

