Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14A431497A1
	for <lists+io-uring@lfdr.de>; Sat, 25 Jan 2020 20:55:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728925AbgAYTy7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 25 Jan 2020 14:54:59 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:56317 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728449AbgAYTyn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 25 Jan 2020 14:54:43 -0500
Received: by mail-wm1-f68.google.com with SMTP id q9so2754403wmj.5;
        Sat, 25 Jan 2020 11:54:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=mnYreOf4qLTvHSCPF33ma4KYvKiUKV+GebuEk6tceUk=;
        b=FTw0xHtHT0FI/HznR24JqGJraOzLmsOvZXvSF/CN8Vat0M3gNYUpmpULDBJYUILL2U
         SKodhhuOAtiD8bMIbGJH5rdfE2nUprXDwPvoHakHGowU2pH3Rwbj2RENoo6UsbL09QvU
         DkYvGq1KEHmKfHVmZR0NUYsp8u8OiucRlRtboDnMPnKuAqEJmPpSA15PTU2gnMEZjVYw
         WELZyhptU2IyPXU6e7iRxjHdOz3y6RnTMwgXzFUy/aRXid9SYU3GDIv/VhwLOnxOzwbG
         gEfv8UBbuYrn/RT/eVyJEqqDmFGc7AlEACypcBq6F+en+FkReSn2UN3Rx7AcSJrJo4+M
         aYjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mnYreOf4qLTvHSCPF33ma4KYvKiUKV+GebuEk6tceUk=;
        b=nRwf6sxxzPWX4iEPtu4cUfcMdj1BhZV4PahQ1eHLIkq5rkW1/4VdT/CPaLY+OX64ba
         wV1vlHkrI5zhz1tRTiFATF76Cx3hNi+M4wjEWxaYrRbfASRSJcUr3WevHzRiRj2ARYi3
         SxZBSwTBmnz8nHQKT1I0EQ4yh2MOjmBjSjuLnE79T/pYgdiEiVWggAwjju7gsDN3xiYB
         vT0w1iQUJEpK6coVzclkxQUZJyD8pUpWoGEMjcq0SkbJZq6owJNv5H9INwoTZxowmjyj
         F4cDUlqOWAsQATjb/lIfdDfvlEfTbjLtrPzo2dSC2sd5bSZRrNyOGLXwRDjYLBFp1m4n
         3i3Q==
X-Gm-Message-State: APjAAAWyq4O+LfkSx/SLZ+qFF0fhT2xeGETQtT4mTAbJdzWEjCCPcc/V
        /f2N9QFLn3PUPfg1BtokJnI=
X-Google-Smtp-Source: APXvYqz1n5M6hc4+slLK4huM1W4U7lZIT36HBxtrrWduCzjZUTSt78E2ufC5+mnnUcNoC/InXvRXlA==
X-Received: by 2002:a7b:cbd6:: with SMTP id n22mr5627788wmi.118.1579982081165;
        Sat, 25 Jan 2020 11:54:41 -0800 (PST)
Received: from localhost.localdomain ([109.126.145.157])
        by smtp.gmail.com with ESMTPSA id m21sm11883712wmi.27.2020.01.25.11.54.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Jan 2020 11:54:40 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 5/8] io_uring: move cur_mm into io_submit_state
Date:   Sat, 25 Jan 2020 22:53:42 +0300
Message-Id: <6c35a5a4bf7d0f501c64cab8d971ff282d83c4ac.1579981749.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1579981749.git.asml.silence@gmail.com>
References: <cover.1579981749.git.asml.silence@gmail.com>
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
index 4597f556d277..880c0e9bbe9e 100644
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
@@ -4921,7 +4922,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 static int io_sq_thread(void *data)
 {
 	struct io_ring_ctx *ctx = data;
-	struct mm_struct *cur_mm = NULL;
+	struct io_submit_state *submit = &ctx->submit_state;
 	const struct cred *old_cred;
 	mm_segment_t old_fs;
 	DEFINE_WAIT(wait);
@@ -4996,10 +4997,15 @@ static int io_sq_thread(void *data)
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
@@ -5030,16 +5036,17 @@ static int io_sq_thread(void *data)
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
 
@@ -5760,6 +5767,10 @@ static int io_sq_offload_start(struct io_ring_ctx *ctx,
 	mmgrab(current->mm);
 	ctx->sqo_mm = current->mm;
 
+	ctx->submit_state.mm = NULL;
+	if (!(ctx->flags & IORING_SETUP_SQPOLL))
+		ctx->submit_state.mm = ctx->sqo_mm;
+
 	if (ctx->flags & IORING_SETUP_SQPOLL) {
 		ret = -EPERM;
 		if (!capable(CAP_SYS_ADMIN))
@@ -6372,8 +6383,6 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 			wake_up(&ctx->sqo_wait);
 		submitted = to_submit;
 	} else if (to_submit) {
-		struct mm_struct *cur_mm;
-
 		if (current->mm != ctx->sqo_mm ||
 		    current_cred() != ctx->creds) {
 			ret = -EPERM;
@@ -6381,10 +6390,7 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
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

