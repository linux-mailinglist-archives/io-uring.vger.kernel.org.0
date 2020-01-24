Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53467149051
	for <lists+io-uring@lfdr.de>; Fri, 24 Jan 2020 22:42:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725821AbgAXVll (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Jan 2020 16:41:41 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41528 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727453AbgAXVll (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Jan 2020 16:41:41 -0500
Received: by mail-wr1-f65.google.com with SMTP id c9so3753224wrw.8;
        Fri, 24 Jan 2020 13:41:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=8CAixSIDtB9O3qPGCZVBwn1+jB3pPDmPnXjMp6dDnOE=;
        b=DmjHXOjb93el9InXj4zs0lkvZP9eC/c+s41/ajddpDv9w5cvaHlOErzHtNopbLR5UT
         epL/bwp66dOhCjQPyREwhhTlJpxCeUzcxD0EWPmlalSIG9bpNEdP4+Ix26mhBCZjSv1y
         ahHcJXQQ9XECp3wy5BU1iUJcrHIOFUGyqvsqSy4UR2rS60dIeh5W3qD6L2zHt35QEvB8
         i9VMgCIQ4A8rAfg2w9xTVKeZ80a+HpJWRgWx502VB04qWmWMzsWyemZ+zq+eLtKQN+rU
         4dg/+RwI3CXfwmNRSCCOjn4w56kb/p8/jGkCczLdiJyAeLim89nGVul0w8jhAS8uk0Tm
         g2Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8CAixSIDtB9O3qPGCZVBwn1+jB3pPDmPnXjMp6dDnOE=;
        b=TcSooNG4WFgEEyNSvGEhyz02w5nhEbE3rUUxdOQXzGo8Ooso1QuRNRNayu1I76914w
         h3sHrTYvmb4uAq3OeerdZbsUpIiyeRj3eaO9kVw74u62IZ+9yd+/nRwk0RwMoqFe5r11
         yR6269gO/fNgGz524IMkJBwUer4fG7cOeXO6BlVlrK3uIwBlhbvEUxHvRCuhd5pdV+13
         w2cT8InBMWzhkf8LH4Aa6tgfBFgqrDVNPqRBEUNdY6Ul1gmqnjj+Pp6dHKgKJHpD6J8/
         rLP0Cd8YjTeFfJUCeTKlL8jUed3cOl4RUdsJzEynS4rqHFd6bDb804eLu8mXWgmpldc4
         jNKA==
X-Gm-Message-State: APjAAAUBHSM/LEKL9spjockM7+M0EvzefIB5SMXoHWeyqeRKGbVdvOGT
        kX8fxVMWoR3rC1N85BGDOSNVguc2
X-Google-Smtp-Source: APXvYqx8Sv02RiJn26HhU7J0ino33VPAJuPI9HvDkmGt1hehlIbUsc/rimuB2ALldiZriaQkLINPOA==
X-Received: by 2002:adf:b60f:: with SMTP id f15mr6829169wre.372.1579902098569;
        Fri, 24 Jan 2020 13:41:38 -0800 (PST)
Received: from localhost.localdomain ([109.126.145.157])
        by smtp.gmail.com with ESMTPSA id f16sm9203055wrm.65.2020.01.24.13.41.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jan 2020 13:41:38 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/8] io_uring: move cur_mm into io_submit_state
Date:   Sat, 25 Jan 2020 00:40:28 +0300
Message-Id: <be4ad3420fbda926d2e969738c0ae6940a47d8ec.1579901866.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1579901866.git.asml.silence@gmail.com>
References: <cover.1579901866.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

cur_mm is only used per submission, so it could be place into
io_submit_state. There is the reasoning behind:
- it's more convenient, don't need to pass it down the call stack
- it's passed as a pointer, so in either case needs memory read/write
- now uses heap (ctx->submit_state) instead of stack
- set only once for non-IORING_SETUP_SQPOLL case.
- generates pretty similar code as @ctx is hot and always somewhere in a
register

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 46 ++++++++++++++++++++++++++--------------------
 1 file changed, 26 insertions(+), 20 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 951c2fc7b5b7..c0e72390d272 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -219,6 +219,8 @@ struct io_submit_state {
 
 	struct file		*ring_file;
 	int			ring_fd;
+
+	struct mm_struct	*mm;
 };
 
 struct io_ring_ctx {
@@ -4834,8 +4836,7 @@ static bool io_get_sqring(struct io_ring_ctx *ctx, struct io_kiocb *req,
 }
 
 static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
-			  struct file *ring_file, int ring_fd,
-			  struct mm_struct **mm, bool async)
+			  struct file *ring_file, int ring_fd, bool async)
 {
 	struct blk_plug plug;
 	struct io_kiocb *link = NULL;
@@ -4883,15 +4884,15 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 			break;
 		}
 
-		if (io_op_defs[req->opcode].needs_mm && !*mm) {
+		if (io_op_defs[req->opcode].needs_mm && !ctx->submit_state.mm) {
 			mm_fault = mm_fault || !mmget_not_zero(ctx->sqo_mm);
 			if (!mm_fault) {
 				use_mm(ctx->sqo_mm);
-				*mm = ctx->sqo_mm;
+				ctx->submit_state.mm = ctx->sqo_mm;
 			}
 		}
 
-		req->has_user = *mm != NULL;
+		req->has_user = (ctx->submit_state.mm != NULL);
 		req->in_async = async;
 		req->needs_fixed_file = async;
 		trace_io_uring_submit_sqe(ctx, req->opcode, req->user_data,
@@ -4918,7 +4919,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 static int io_sq_thread(void *data)
 {
 	struct io_ring_ctx *ctx = data;
-	struct mm_struct *cur_mm = NULL;
+	struct io_submit_state *submit = &ctx->submit_state;
 	const struct cred *old_cred;
 	mm_segment_t old_fs;
 	DEFINE_WAIT(wait);
@@ -4993,10 +4994,15 @@ static int io_sq_thread(void *data)
 			 * adding ourselves to the waitqueue, as the unuse/drop
 			 * may sleep.
 			 */
-			if (cur_mm) {
-				unuse_mm(cur_mm);
-				mmput(cur_mm);
-				cur_mm = NULL;
+			if (submit->mm) {
+				/*
+				 * this thread is the only submitter, thus
+				 * it's safe to change submit->mm without
+				 * taking ctx->uring_lock
+				 */
+				unuse_mm(submit->mm);
+				mmput(submit->mm);
+				submit->mm = NULL;
 			}
 
 			prepare_to_wait(&ctx->sqo_wait, &wait,
@@ -5027,16 +5033,17 @@ static int io_sq_thread(void *data)
 		}
 
 		mutex_lock(&ctx->uring_lock);
-		ret = io_submit_sqes(ctx, to_submit, NULL, -1, &cur_mm, true);
+		ret = io_submit_sqes(ctx, to_submit, NULL, -1, true);
 		mutex_unlock(&ctx->uring_lock);
 		if (ret > 0)
 			inflight += ret;
 	}
 
 	set_fs(old_fs);
-	if (cur_mm) {
-		unuse_mm(cur_mm);
-		mmput(cur_mm);
+	if (submit->mm) {
+		unuse_mm(submit->mm);
+		mmput(submit->mm);
+		submit->mm = NULL;
 	}
 	revert_creds(old_cred);
 
@@ -5757,6 +5764,10 @@ static int io_sq_offload_start(struct io_ring_ctx *ctx,
 	mmgrab(current->mm);
 	ctx->sqo_mm = current->mm;
 
+	ctx->submit_state.mm = NULL;
+	if (!(ctx->flags & IORING_SETUP_SQPOLL))
+		ctx->submit_state.mm = ctx->sqo_mm;
+
 	if (ctx->flags & IORING_SETUP_SQPOLL) {
 		ret = -EPERM;
 		if (!capable(CAP_SYS_ADMIN))
@@ -6369,8 +6380,6 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 			wake_up(&ctx->sqo_wait);
 		submitted = to_submit;
 	} else if (to_submit) {
-		struct mm_struct *cur_mm;
-
 		if (current->mm != ctx->sqo_mm ||
 		    current_cred() != ctx->creds) {
 			ret = -EPERM;
@@ -6378,10 +6387,7 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 		}
 
 		mutex_lock(&ctx->uring_lock);
-		/* already have mm, so io_submit_sqes() won't try to grab it */
-		cur_mm = ctx->sqo_mm;
-		submitted = io_submit_sqes(ctx, to_submit, f.file, fd,
-					   &cur_mm, false);
+		submitted = io_submit_sqes(ctx, to_submit, f.file, fd, false);
 		mutex_unlock(&ctx->uring_lock);
 
 		if (submitted != to_submit)
-- 
2.24.0

