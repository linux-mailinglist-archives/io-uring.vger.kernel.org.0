Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74C221A5A71
	for <lists+io-uring@lfdr.de>; Sun, 12 Apr 2020 01:43:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728356AbgDKXGT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 11 Apr 2020 19:06:19 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:43257 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727102AbgDKXGS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 11 Apr 2020 19:06:18 -0400
Received: by mail-wr1-f65.google.com with SMTP id i10so6262450wrv.10;
        Sat, 11 Apr 2020 16:06:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=wHzMiPjLqcq82v2DVVRU/GZaBxD/oG/7XqnentZacgc=;
        b=qU9FVNEAILkEoZaSFYFtbuPJeknRgfMAUBtNkLVMSeCKYUKEl6jrI2z7oFxCo6058H
         gxeokafXKjJUwmTiN/oHm2ShCIQr730Y6o4dTvvKrlxwBhcoViktbXeUGvPGdnIroZ7Z
         SHVsfQaZxvu4g08HYLUfDPfK7x3lbJm5PNAB/fyhftxOkE7+EFjWTFrIbZV/KxBLboG/
         VIBKjNFqjpLzFiO1CCqPoeh/4nsPFIDIag6Z6ohtT5rZHjoOJ/v1iNrpjJuiQ4M1wV8o
         PF6psMztsaY/P0lqQoIjRjBaxJvIVH7SORPjAfGWMeZcarCeONIshb9GTu7VaDImj0pa
         Fb3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wHzMiPjLqcq82v2DVVRU/GZaBxD/oG/7XqnentZacgc=;
        b=tzN3YI4fJrNopgWtrRwrkqqkKGo4KAGN6dY1hyLjmK6/ZkJzviBBCzBAN53uC4d+YL
         wLHHZrxs/m3igStfV3eC2CHvEYnIArv8bqkoph5bI13ZVo1tDFGNBWuSYDxUAuawXiP2
         pL3Cto+kT7a4Y3PaCHon3xfid4HNR+nK/JHqwPPh+CucGphEDz9SBfJ3NU2kDbUU75fl
         qel+NHBllaSTOVcNLibrW+TEeSaKrpu1t9HxueJzotBKW9oFjGAcB8NylCcyJb9dFIvH
         Tj/afEEMvDlImfVNFbr1I67lxWHxqIV/Vm6sqMnBoLG2vCcjusIY6SP/2OPTu9eEbWtx
         SYoA==
X-Gm-Message-State: AGi0PubXHEajeJtVlrkXgyqKx2tqubBOUHpIKMEloY/UAe2Ql33Xlw4x
        NITU/hccdX76quKmLTvZPDwIe4NV
X-Google-Smtp-Source: APiQypLtKn3FvivuLshm/Ie+kFAjCfZn5+hI+J6l9fYhoLs3Z8WUD79SwXCOlmnpasAVQmwttaBKVA==
X-Received: by 2002:adf:d4ce:: with SMTP id w14mr11880885wrk.135.1586646377950;
        Sat, 11 Apr 2020 16:06:17 -0700 (PDT)
Received: from localhost.localdomain ([109.126.129.227])
        by smtp.gmail.com with ESMTPSA id k133sm8992741wma.0.2020.04.11.16.06.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Apr 2020 16:06:17 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] io_uring: track mm through current->mm
Date:   Sun, 12 Apr 2020 02:05:02 +0300
Message-Id: <78ce4523e0e4b3cd46e081c124fa9b6307303183.1586645520.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1586645520.git.asml.silence@gmail.com>
References: <cover.1586645520.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

As a preparation for extracting request init bits, remove self-coded mm
tracking from io_submit_sqes(), but rely on current->mm. It's more
convenient, than passing this piece of state in other functions.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 37 ++++++++++++++++---------------------
 1 file changed, 16 insertions(+), 21 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 343899915465..27868ec328b8 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5810,8 +5810,7 @@ static void io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 }
 
 static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
-			  struct file *ring_file, int ring_fd,
-			  struct mm_struct **mm, bool async)
+			  struct file *ring_file, int ring_fd, bool async)
 {
 	struct io_submit_state state, *statep = NULL;
 	struct io_kiocb *link = NULL;
@@ -5868,13 +5867,12 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 			break;
 		}
 
-		if (io_op_defs[req->opcode].needs_mm && !*mm) {
+		if (io_op_defs[req->opcode].needs_mm && !current->mm) {
 			if (unlikely(!mmget_not_zero(ctx->sqo_mm))) {
 				err = -EFAULT;
 				goto fail_req;
 			}
 			use_mm(ctx->sqo_mm);
-			*mm = ctx->sqo_mm;
 		}
 
 		req->needs_fixed_file = async;
@@ -5900,10 +5898,19 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 	return submitted;
 }
 
+static inline void io_sq_thread_drop_mm(struct io_ring_ctx *ctx)
+{
+	struct mm_struct *mm = current->mm;
+
+	if (mm) {
+		unuse_mm(mm);
+		mmput(mm);
+	}
+}
+
 static int io_sq_thread(void *data)
 {
 	struct io_ring_ctx *ctx = data;
-	struct mm_struct *cur_mm = NULL;
 	const struct cred *old_cred;
 	mm_segment_t old_fs;
 	DEFINE_WAIT(wait);
@@ -5944,11 +5951,7 @@ static int io_sq_thread(void *data)
 			 * adding ourselves to the waitqueue, as the unuse/drop
 			 * may sleep.
 			 */
-			if (cur_mm) {
-				unuse_mm(cur_mm);
-				mmput(cur_mm);
-				cur_mm = NULL;
-			}
+			io_sq_thread_drop_mm(ctx);
 
 			/*
 			 * We're polling. If we're within the defined idle
@@ -6012,7 +6015,7 @@ static int io_sq_thread(void *data)
 		}
 
 		mutex_lock(&ctx->uring_lock);
-		ret = io_submit_sqes(ctx, to_submit, NULL, -1, &cur_mm, true);
+		ret = io_submit_sqes(ctx, to_submit, NULL, -1, true);
 		mutex_unlock(&ctx->uring_lock);
 		timeout = jiffies + ctx->sq_thread_idle;
 	}
@@ -6021,10 +6024,7 @@ static int io_sq_thread(void *data)
 		task_work_run();
 
 	set_fs(old_fs);
-	if (cur_mm) {
-		unuse_mm(cur_mm);
-		mmput(cur_mm);
-	}
+	io_sq_thread_drop_mm(ctx);
 	revert_creds(old_cred);
 
 	kthread_parkme();
@@ -7493,13 +7493,8 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 			wake_up(&ctx->sqo_wait);
 		submitted = to_submit;
 	} else if (to_submit) {
-		struct mm_struct *cur_mm;
-
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

