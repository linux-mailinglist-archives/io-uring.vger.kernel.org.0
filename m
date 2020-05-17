Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 346E51D679E
	for <lists+io-uring@lfdr.de>; Sun, 17 May 2020 13:15:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727929AbgEQLPF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 17 May 2020 07:15:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727832AbgEQLPF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 17 May 2020 07:15:05 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9486AC061A0C;
        Sun, 17 May 2020 04:15:04 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id x27so5379008lfg.9;
        Sun, 17 May 2020 04:15:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=M+qpSkBYpmxFEZtgoh/nztF0arwafxT5xyE4pzgMNGE=;
        b=uMYYswb4A3vQC/qhAU/KTnbU6ENUiENswRD8VCeTp4fFYYmfrqj7QI71oWKLIIZaFI
         ewoe642GOgqoCSg3mVVkHGhvkPN8uHITWUAKb0jD0SlJfEOaVbCBt+881YTDB9Rhgt25
         6a1lVpNQTZy8s67VbhknQv210afgpLpUDdlh64B+BLyBlrJrquwnazfcjBVWi9IIYSGT
         7ic6km4bVIu14AKRC6G/II2Uk30EU8AiWswXOpExuMJvHxFaxvftZ55JeI1rZbWSDHIp
         Cr5yA+awbgTLokS4zTxCmRhzG5AXwRYohxZnJDzHDwEQbezK0jccjbUHfMaze9yT0yLo
         kQMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=M+qpSkBYpmxFEZtgoh/nztF0arwafxT5xyE4pzgMNGE=;
        b=TM4iFMoz5Bn9IPS/+sd/s4PHXkXBsP29yriqQqc2g2ofUtPzMkgrDLTqucdvu+GDPF
         lB7yJ/CYzUBsziUSxvWhLVmOL0JYCdrn1HnGnkzwZn5Pv7ILW1X9bwHx31k2eOAjlPcV
         rxWdq3TJiVMOoG1C2d7BCZG+iXvldRJ/hHLEAlmHnMWTfZqRETrMQ0RVl+cKDi2gcebF
         MlGPr0h68lbd7uJ5Sy3VCZ64xsZqGzg5doeYydBt8pYAb4bcaE1I+iooCXvGrL6aDSSK
         k5kpNwr8ZNkE9KFpmjGZYCsGjfno7A1Fy13gEV1PPfWPin7yHnbYYG2DKpvbtxRZAyr8
         0mng==
X-Gm-Message-State: AOAM531Q7MSSdRyLw75FOIKGozoJd9XkJPaWtDpr4ubTCmcirvBs41x5
        rPUEgqONWyUwfcEHqmI9/0NzrGjJ
X-Google-Smtp-Source: ABdhPJwP5bgoVxTG4eeWzIg0XvRvoFxF+xfKe//I4gs+h6/ONpbPAc5XQdOtk39WnnP4qqiLB2orwQ==
X-Received: by 2002:a19:5206:: with SMTP id m6mr1287228lfb.144.1589714103004;
        Sun, 17 May 2020 04:15:03 -0700 (PDT)
Received: from localhost.localdomain ([82.209.196.123])
        by smtp.gmail.com with ESMTPSA id v2sm3970990ljv.86.2020.05.17.04.15.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 May 2020 04:15:02 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] io_uring: remove req->needs_fixed_files
Date:   Sun, 17 May 2020 14:13:40 +0300
Message-Id: <f694f6b81e555c15ee0e75ffbe9509bbfa8d4f27.1589713554.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1589713554.git.asml.silence@gmail.com>
References: <cover.1589713554.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

A submission is "async" IIF it's done by SQPOLL thread. Instead of
passing @async flag into io_submit_sqes(), deduce it from ctx->flags.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 3d0a08560689..739aae7070c1 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -626,7 +626,6 @@ struct io_kiocb {
 
 	struct io_async_ctx		*io;
 	int				cflags;
-	bool				needs_fixed_file;
 	u8				opcode;
 
 	struct io_ring_ctx	*ctx;
@@ -891,6 +890,11 @@ EXPORT_SYMBOL(io_uring_get_socket);
 
 static void io_file_put_work(struct work_struct *work);
 
+static inline bool io_async_submit(struct io_ring_ctx *ctx)
+{
+	return ctx->flags & IORING_SETUP_SQPOLL;
+}
+
 static void io_ring_ctx_ref_free(struct percpu_ref *ref)
 {
 	struct io_ring_ctx *ctx = container_of(ref, struct io_ring_ctx, refs);
@@ -5487,7 +5491,7 @@ static int io_req_set_file(struct io_submit_state *state, struct io_kiocb *req,
 	bool fixed;
 
 	fixed = (req->flags & REQ_F_FIXED_FILE) != 0;
-	if (unlikely(!fixed && req->needs_fixed_file))
+	if (unlikely(!fixed && io_async_submit(req->ctx)))
 		return -EBADF;
 
 	return io_file_get(state, req, fd, &req->file, fixed);
@@ -5866,7 +5870,7 @@ static inline void io_consume_sqe(struct io_ring_ctx *ctx)
 
 static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 		       const struct io_uring_sqe *sqe,
-		       struct io_submit_state *state, bool async)
+		       struct io_submit_state *state)
 {
 	unsigned int sqe_flags;
 	int id;
@@ -5887,7 +5891,6 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	refcount_set(&req->refs, 2);
 	req->task = NULL;
 	req->result = 0;
-	req->needs_fixed_file = async;
 	INIT_IO_WORK(&req->work, io_wq_submit_work);
 
 	if (unlikely(req->opcode >= IORING_OP_LAST))
@@ -5928,7 +5931,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 }
 
 static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
-			  struct file *ring_file, int ring_fd, bool async)
+			  struct file *ring_file, int ring_fd)
 {
 	struct io_submit_state state, *statep = NULL;
 	struct io_kiocb *link = NULL;
@@ -5972,7 +5975,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 			break;
 		}
 
-		err = io_init_req(ctx, req, sqe, statep, async);
+		err = io_init_req(ctx, req, sqe, statep);
 		io_consume_sqe(ctx);
 		/* will complete beyond this point, count as submitted */
 		submitted++;
@@ -5985,7 +5988,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 		}
 
 		trace_io_uring_submit_sqe(ctx, req->opcode, req->user_data,
-						true, async);
+						true, io_async_submit(ctx));
 		err = io_submit_sqe(req, sqe, &link);
 		if (err)
 			goto fail_req;
@@ -6124,7 +6127,7 @@ static int io_sq_thread(void *data)
 		}
 
 		mutex_lock(&ctx->uring_lock);
-		ret = io_submit_sqes(ctx, to_submit, NULL, -1, true);
+		ret = io_submit_sqes(ctx, to_submit, NULL, -1);
 		mutex_unlock(&ctx->uring_lock);
 		timeout = jiffies + ctx->sq_thread_idle;
 	}
@@ -7635,7 +7638,7 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 		submitted = to_submit;
 	} else if (to_submit) {
 		mutex_lock(&ctx->uring_lock);
-		submitted = io_submit_sqes(ctx, to_submit, f.file, fd, false);
+		submitted = io_submit_sqes(ctx, to_submit, f.file, fd);
 		mutex_unlock(&ctx->uring_lock);
 
 		if (submitted != to_submit)
-- 
2.24.0

