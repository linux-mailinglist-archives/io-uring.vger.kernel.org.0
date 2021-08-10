Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EA283E5C42
	for <lists+io-uring@lfdr.de>; Tue, 10 Aug 2021 15:53:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240442AbhHJNxu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 10 Aug 2021 09:53:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242010AbhHJNxr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 10 Aug 2021 09:53:47 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 534DFC0613D3
        for <io-uring@vger.kernel.org>; Tue, 10 Aug 2021 06:53:25 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id d131-20020a1c1d890000b02902516717f562so2589029wmd.3
        for <io-uring@vger.kernel.org>; Tue, 10 Aug 2021 06:53:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bvjZs4o6aiJi32ZDFiXcWlGj44Ouqz5UyN+n7AXYAEU=;
        b=eixt1VCEb8rA+4wdQEjNCThTpBPqCC+5E7TWr0OC8xOHKMCIxcQZMN+Mi4kyk+Uq8V
         CkhA4AFVcyPmYH4Ggi3OEt49eTpNneHldLIksdIbKrRCN3SMAto9EmB936XMHW70Zt6J
         Y9gStXI6NhvsALM5cAqfb/GEnyFXPTL4sUH4Z2dRsbgo32ijw4KVtGmXjLwhzp5gfJeB
         88xhM5DLommRByLgcmVSIREXkZz7YMPkKW9fJU10q1SAevBZZFfX6ytddoBADPiLlD1f
         o041ZM6N5enZeBkCfEYeXHgF68lQkp0/fn5tlc+OZ109cMMAtN8bWKh0HRz2/M+984Jj
         /lVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bvjZs4o6aiJi32ZDFiXcWlGj44Ouqz5UyN+n7AXYAEU=;
        b=E578PtwOioczQ5lFNa/rxS6DYpgQT8vY5GoW71wU2vXhMmfrraneA+ydFn8v9t8KMY
         ovOCNJ9kAU1YpBJVYdOmuV6SzCcbyvJxmqHYxkZzZxOT3QIwQR77kxXARhpcsDt4fSqN
         jvu34awWfL9M6g52eWdkuWzHdg3oyx8wenk+f26e5Zvj6nYQ21iMNO+v2uBvHNgEdFfO
         JctFexkpiZpstha/fTtAGkTym9kVRfR/pjGD0DSS4H1mXyBR8KW3R4NUNPu5Gv+V7Go2
         rhAsC4QvU/HI2QBO5bvT8ERzKun0Sp05XRkIzyOCCfDX18Tb8NPUQMvMPXyyLFGKR/8b
         UqeA==
X-Gm-Message-State: AOAM530JRPJrP3tiQAg2EPl5WY/iwRLfc+o5tPN5BIQw+s5wJoXcccNx
        N/3C2IADBREgRRTLJyfKsQHqEIWyU7Y=
X-Google-Smtp-Source: ABdhPJzStNNzXHwm+gxWheqfJ2r4dG3I82svgafqEr8JMPzvyJ/GmFi9jWdY7yIdG2flzMAFlqEKzw==
X-Received: by 2002:a1c:4c05:: with SMTP id z5mr4768979wmf.145.1628603603904;
        Tue, 10 Aug 2021 06:53:23 -0700 (PDT)
Received: from localhost.localdomain ([148.252.133.97])
        by smtp.gmail.com with ESMTPSA id m14sm23290938wrs.56.2021.08.10.06.53.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Aug 2021 06:53:23 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [RFC] io_uring: remove file batch-get optimisation
Date:   Tue, 10 Aug 2021 14:52:47 +0100
Message-Id: <afe7a11e30f64e18785627aa5f49f7ce40cb5311.1628603451.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

For requests with non-fixed files, instead of grabbing just one
reference, we get by the number of left requests, so the following
requests using the same file can take it without atomics.

However, it's not all win. If there is one request in the middle
not using files or having a fixed file, we'll need to put back the left
references. Even worse if an application submits requests dealing with
different files, it will do a put for each new request, so doubling the
number of atomics needed. Also, even if not used, it's still takes some
cycles in the submission path.

If a file used many times, it rather makes sense to pre-register it, if
not, we may fall in the described pitfall. So, this optimisation is a
matter of use case. Go with the simpliest code-wise way, remove it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 53 ++++-----------------------------------------------
 1 file changed, 4 insertions(+), 49 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d65621247709..f14ebb2dda14 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -324,12 +324,6 @@ struct io_submit_state {
 	/* inline/task_work completion list, under ->uring_lock */
 	struct list_head	free_list;
 
-	/*
-	 * File reference cache
-	 */
-	struct file		*file;
-	unsigned int		fd;
-	unsigned int		file_refs;
 	unsigned int		ios_left;
 };
 
@@ -1055,7 +1049,6 @@ static int __io_register_rsrc_update(struct io_ring_ctx *ctx, unsigned type,
 				     unsigned nr_args);
 static void io_clean_op(struct io_kiocb *req);
 static struct file *io_file_get(struct io_ring_ctx *ctx,
-				struct io_submit_state *state,
 				struct io_kiocb *req, int fd, bool fixed);
 static void __io_queue_sqe(struct io_kiocb *req);
 static void io_rsrc_put_work(struct work_struct *work);
@@ -2610,40 +2603,6 @@ static void io_iopoll_req_issued(struct io_kiocb *req)
 	}
 }
 
-static inline void io_state_file_put(struct io_submit_state *state)
-{
-	if (state->file_refs) {
-		fput_many(state->file, state->file_refs);
-		state->file_refs = 0;
-	}
-}
-
-/*
- * Get as many references to a file as we have IOs left in this submission,
- * assuming most submissions are for one file, or at least that each file
- * has more than one submission.
- */
-static struct file *__io_file_get(struct io_submit_state *state, int fd)
-{
-	if (!state)
-		return fget(fd);
-
-	if (state->file_refs) {
-		if (state->fd == fd) {
-			state->file_refs--;
-			return state->file;
-		}
-		io_state_file_put(state);
-	}
-	state->file = fget_many(fd, state->ios_left);
-	if (unlikely(!state->file))
-		return NULL;
-
-	state->fd = fd;
-	state->file_refs = state->ios_left - 1;
-	return state->file;
-}
-
 static bool io_bdev_nowait(struct block_device *bdev)
 {
 	return !bdev || blk_queue_nowait(bdev_get_queue(bdev));
@@ -3641,8 +3600,7 @@ static int __io_splice_prep(struct io_kiocb *req,
 	if (unlikely(sp->flags & ~valid_flags))
 		return -EINVAL;
 
-	sp->file_in = io_file_get(req->ctx, NULL, req,
-				  READ_ONCE(sqe->splice_fd_in),
+	sp->file_in = io_file_get(req->ctx, req, READ_ONCE(sqe->splice_fd_in),
 				  (sp->flags & SPLICE_F_FD_IN_FIXED));
 	if (!sp->file_in)
 		return -EBADF;
@@ -6378,10 +6336,9 @@ static inline struct file *io_file_get_fixed(struct io_ring_ctx *ctx,
 }
 
 static struct file *io_file_get_normal(struct io_ring_ctx *ctx,
-				       struct io_submit_state *state,
 				       struct io_kiocb *req, int fd)
 {
-	struct file *file = __io_file_get(state, fd);
+	struct file *file = fget(fd);
 
 	trace_io_uring_file_get(ctx, fd);
 
@@ -6392,13 +6349,12 @@ static struct file *io_file_get_normal(struct io_ring_ctx *ctx,
 }
 
 static inline struct file *io_file_get(struct io_ring_ctx *ctx,
-				       struct io_submit_state *state,
 				       struct io_kiocb *req, int fd, bool fixed)
 {
 	if (fixed)
 		return io_file_get_fixed(ctx, req, fd);
 	else
-		return io_file_get_normal(ctx, state, req, fd);
+		return io_file_get_normal(ctx, req, fd);
 }
 
 static enum hrtimer_restart io_link_timeout_fn(struct hrtimer *timer)
@@ -6612,7 +6568,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	}
 
 	if (io_op_defs[req->opcode].needs_file) {
-		req->file = io_file_get(ctx, state, req, READ_ONCE(sqe->fd),
+		req->file = io_file_get(ctx, req, READ_ONCE(sqe->fd),
 					(sqe_flags & IOSQE_FIXED_FILE));
 		if (unlikely(!req->file))
 			ret = -EBADF;
@@ -6697,7 +6653,6 @@ static void io_submit_state_end(struct io_submit_state *state,
 		io_submit_flush_completions(ctx);
 	if (state->plug_started)
 		blk_finish_plug(&state->plug);
-	io_state_file_put(state);
 }
 
 /*
-- 
2.32.0

