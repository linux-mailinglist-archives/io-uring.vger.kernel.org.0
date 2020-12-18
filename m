Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AE3F2DE32A
	for <lists+io-uring@lfdr.de>; Fri, 18 Dec 2020 14:17:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726685AbgLRNQo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Dec 2020 08:16:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726515AbgLRNQn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Dec 2020 08:16:43 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 841ADC06138C
        for <io-uring@vger.kernel.org>; Fri, 18 Dec 2020 05:16:03 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id y17so2094578wrr.10
        for <io-uring@vger.kernel.org>; Fri, 18 Dec 2020 05:16:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=o9HJi75rMpthkrnsj6mu624TJt8fm1c4RY2NUJzUqSU=;
        b=hv2iKiLN8cUsbeNPALVO3ovpLeDA8aG9Zp0RhUWWunkuI88/duNOiSacdJaVVd+6TP
         ggjmFAwWLpjcsllcWEMS/N2hu9WHx+b4CnyZT8IDvJjN1f4sAySNnzMFafcnpiRxyl39
         g/2dDKeWq84jnWfo8JyNtaMmAFAkxf+xEelkA/++h2JwLVcPf2Ixe/Cq+TUQfaMUU4LM
         RpbIxDZQbo+N1WgKn2c0tDN3rDFuQJyBN/R2w3NScwRHssNcQEa0gvs6MFZbeW8PxO1p
         CkDupWKJ2DxPnz+mwpNr2RCNS8s38HW8maiUS9sbiW++zgkO+kbxxJRHmRyPEIV1EqI5
         1+MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=o9HJi75rMpthkrnsj6mu624TJt8fm1c4RY2NUJzUqSU=;
        b=cb92v2aEJtLMG0aTW2H5LhPg73xDqOA3r+D9m9SMaYgatCVeyrVFX4VYB0l/nao8fN
         neQiNAQOuO+raUOib3THHCge/aPzRL08AhIjZtdSLlboqtuCXT5XsueBY1aWGiqF7cET
         s9AzBew97zerdRj4Rn1BOSGoe/tqW/+7hFZhpMiuUEEBE4fT41HeWAGuUKvoJREy3NPD
         fJjdsa3SXL2/SQE+aQn1jz7TqEeN6zoDk14cJHuMDLLeZwkQ/hrRBhg7iv35CAhKVcF+
         Fccr0F+ewZX1UHfomjZy68bEK2R4hZnKsbLvZHQT+ovXZNLyexS/dHEqIosgyrjSrhUy
         8f2w==
X-Gm-Message-State: AOAM531rGBj0ej1DUrqBlk6Hr2ZKdIMr1hxPypLDlzfXotQLEOJnh7KM
        clvWftOtagdXUdWejnL2Pex1dZ60NExYNA==
X-Google-Smtp-Source: ABdhPJwWXPT2CUlBfN7dJhIP98NHbBwD5Ovwiwqxel9AAj+s4acv8jKbC7b5gg7wLxO1JfznlScsxQ==
X-Received: by 2002:adf:e64b:: with SMTP id b11mr4430133wrn.257.1608297362342;
        Fri, 18 Dec 2020 05:16:02 -0800 (PST)
Received: from localhost.localdomain ([85.255.234.120])
        by smtp.gmail.com with ESMTPSA id b9sm12778595wmd.32.2020.12.18.05.16.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Dec 2020 05:16:01 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 3/8] io_uring: account per-task #requests with files
Date:   Fri, 18 Dec 2020 13:12:23 +0000
Message-Id: <aa9578527c67c0db15fc3d088b74b93a1743235f.1608296656.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1608296656.git.asml.silence@gmail.com>
References: <cover.1608296656.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Similarly as we keep tctx->inflight add tctx->inflight_files tracking
number of requests with ->files set. That's a preparation patch, so it's
kept unused for now. Also, as it's not as hot as ->inflight use atomics.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c            | 27 +++++++++++++++++++--------
 include/linux/io_uring.h |  1 +
 2 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 1401c1444e77..3a3177739b13 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1497,6 +1497,7 @@ static bool io_grab_identity(struct io_kiocb *req)
 		req->flags |= REQ_F_INFLIGHT;
 
 		spin_lock_irq(&ctx->inflight_lock);
+		atomic_inc(&current->io_uring->inflight_files);
 		list_add(&req->inflight_entry, &ctx->inflight_list);
 		spin_unlock_irq(&ctx->inflight_lock);
 		req->work.flags |= IO_WQ_WORK_FILES;
@@ -6101,6 +6102,7 @@ static void io_req_drop_files(struct io_kiocb *req)
 	put_nsproxy(req->work.identity->nsproxy);
 	spin_lock_irqsave(&ctx->inflight_lock, flags);
 	list_del(&req->inflight_entry);
+	atomic_dec(&tctx->inflight_files);
 	spin_unlock_irqrestore(&ctx->inflight_lock, flags);
 	req->flags &= ~REQ_F_INFLIGHT;
 	req->work.flags &= ~IO_WQ_WORK_FILES;
@@ -8012,6 +8014,7 @@ static int io_uring_alloc_task_context(struct task_struct *task)
 	init_waitqueue_head(&tctx->wait);
 	tctx->last = NULL;
 	atomic_set(&tctx->in_idle, 0);
+	atomic_set(&tctx->inflight_files, 0);
 	tctx->sqpoll = false;
 	io_init_identity(&tctx->__identity);
 	tctx->identity = &tctx->__identity;
@@ -8927,13 +8930,17 @@ void __io_uring_files_cancel(struct files_struct *files)
 	atomic_dec(&tctx->in_idle);
 }
 
-static s64 tctx_inflight(struct io_uring_task *tctx)
+static s64 tctx_inflight(struct io_uring_task *tctx, bool files)
 {
 	unsigned long index;
 	struct file *file;
 	s64 inflight;
 
-	inflight = percpu_counter_sum(&tctx->inflight);
+	if (files)
+		inflight = atomic_read(&tctx->inflight_files);
+	else
+		inflight = percpu_counter_sum(&tctx->inflight);
+
 	if (!tctx->sqpoll)
 		return inflight;
 
@@ -8943,12 +8950,16 @@ static s64 tctx_inflight(struct io_uring_task *tctx)
 	 */
 	xa_for_each(&tctx->xa, index, file) {
 		struct io_ring_ctx *ctx = file->private_data;
+		struct io_uring_task *sqpoll_tctx;
 
-		if (ctx->flags & IORING_SETUP_SQPOLL) {
-			struct io_uring_task *__tctx = ctx->sqo_task->io_uring;
+		if (!(ctx->flags & IORING_SETUP_SQPOLL))
+			continue;
 
-			inflight += percpu_counter_sum(&__tctx->inflight);
-		}
+		sqpoll_tctx = ctx->sqo_task->io_uring;
+		if (files)
+			inflight += atomic_read(&sqpoll_tctx->inflight_files);
+		else
+			inflight += percpu_counter_sum(&sqpoll_tctx->inflight);
 	}
 
 	return inflight;
@@ -8969,7 +8980,7 @@ void __io_uring_task_cancel(void)
 
 	do {
 		/* read completions before cancelations */
-		inflight = tctx_inflight(tctx);
+		inflight = tctx_inflight(tctx, false);
 		if (!inflight)
 			break;
 		__io_uring_files_cancel(NULL);
@@ -8980,7 +8991,7 @@ void __io_uring_task_cancel(void)
 		 * If we've seen completions, retry. This avoids a race where
 		 * a completion comes in before we did prepare_to_wait().
 		 */
-		if (inflight != tctx_inflight(tctx))
+		if (inflight != tctx_inflight(tctx, false))
 			continue;
 		schedule();
 	} while (1);
diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index 35b2d845704d..e1ff6f235d03 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -28,6 +28,7 @@ struct io_uring_task {
 	struct wait_queue_head	wait;
 	struct file		*last;
 	struct percpu_counter	inflight;
+	atomic_t		inflight_files;
 	struct io_identity	__identity;
 	struct io_identity	*identity;
 	atomic_t		in_idle;
-- 
2.24.0

