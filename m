Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6D7535B107
	for <lists+io-uring@lfdr.de>; Sun, 11 Apr 2021 02:50:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234883AbhDKAvN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 10 Apr 2021 20:51:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234548AbhDKAvN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 10 Apr 2021 20:51:13 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A617CC06138B
        for <io-uring@vger.kernel.org>; Sat, 10 Apr 2021 17:50:57 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id x15so9260777wrq.3
        for <io-uring@vger.kernel.org>; Sat, 10 Apr 2021 17:50:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=Y7DkMq1RBTe1ePHc6Ra/NoHqdGzL9eCfpbNWwnvXuXM=;
        b=ok9JV4CaVXiF/e4l2AXUkTTtI9I6rsW6LYD/rwm/DQKgBalWAU2NaKL/roW7HLvTOd
         lTSVCWv1nX/dppLNCYgN/nffhbjuTmtdebecVZm+U+ZhLzrdOvAGJjQr53+e1kpqXKYu
         i5fZUNI6aUTAjCZySFqLDcf2wqXJbfAR9UX70glgRz/hI0/hOJFm73FwxkfrM91iqa93
         ruGg2+yAVQV7ZzzwDwBxO3YJvRVSKaCMVal4IjBYePZoEVqAIb7xW6jHXyeNWVXkMJFf
         emP6yZo9VdzG63GRhviNLp6P+hI9O3VM8X26NIKhXxM85wLT7DtRQTrWz/1u1xThm45b
         g51Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Y7DkMq1RBTe1ePHc6Ra/NoHqdGzL9eCfpbNWwnvXuXM=;
        b=eviCV8Jnufwd+mdnwnnUAmdVEXjkQiihMcxrO5WB9LVEWNtBbMTB/hSmzSVwLSqaPK
         /IakXa5SYlBAQwUFSDHec8tQ6NyG1pkc/1T9aqJ/YAunwQkbCnQjFEwfmpRiozUblZ8Y
         Zbgc9JJvPx46fis8Tl0EB/0r7msMQFJIYwDOEffoP0tNuptgr+7v7V7B3t/lqVQF9zDL
         BpcOX8UOYCmy0DgJswfQP3PXwlZYiDlSFsQVVSfY6f5mYPhMQD84HCqlwCPqHON7WFJu
         TDzxlT1pmuQ/Kr6DR6AFTZRvaEGC5WgR6TCbW3FBseEDc75EVTFOjeCloKpD9+5B7Vv6
         Mq+Q==
X-Gm-Message-State: AOAM532fhXAfdCJj9h37Ao7YIIR5akw/T+tnbPxehla9Ttur3HZsM/z5
        uHNJH2iKQjmfCjCO2kzUMns=
X-Google-Smtp-Source: ABdhPJx4UVzVXfN8fUVwD2oTo4HrOYcpiu8JCZDNTi1H1LOmksI/icAdfvs42RwaLUOGGNdtc1Qn1Q==
X-Received: by 2002:adf:d218:: with SMTP id j24mr24260419wrh.297.1618102256448;
        Sat, 10 Apr 2021 17:50:56 -0700 (PDT)
Received: from localhost.localdomain ([85.255.237.117])
        by smtp.gmail.com with ESMTPSA id y20sm9204735wma.45.2021.04.10.17.50.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Apr 2021 17:50:56 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 03/16] io_uring: unify files and task cancel
Date:   Sun, 11 Apr 2021 01:46:27 +0100
Message-Id: <1a5986a97df4dc1378f3fe0ca1eb483dbcf42112.1618101759.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1618101759.git.asml.silence@gmail.com>
References: <cover.1618101759.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Now __io_uring_cancel() and __io_uring_files_cancel() are very similar
and mostly differ by how we count requests, merge them and allow
tctx_inflight() to handle counting.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c            | 56 ++++++++++------------------------------
 include/linux/io_uring.h | 12 ++++-----
 2 files changed, 19 insertions(+), 49 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 3353a0b1032a..0dcf9b7a7423 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8926,13 +8926,10 @@ static void io_uring_clean_tctx(struct io_uring_task *tctx)
 	}
 }
 
-static s64 tctx_inflight_tracked(struct io_uring_task *tctx)
-{
-	return atomic_read(&tctx->inflight_tracked);
-}
-
-static s64 tctx_inflight(struct io_uring_task *tctx)
+static s64 tctx_inflight(struct io_uring_task *tctx, bool tracked)
 {
+	if (tracked)
+		return atomic_read(&tctx->inflight_tracked);
 	return percpu_counter_sum(&tctx->inflight);
 }
 
@@ -8999,7 +8996,7 @@ static void io_uring_cancel_sqpoll(struct io_ring_ctx *ctx)
 	atomic_inc(&tctx->in_idle);
 	do {
 		/* read completions before cancelations */
-		inflight = tctx_inflight(tctx);
+		inflight = tctx_inflight(tctx, false);
 		if (!inflight)
 			break;
 		io_uring_try_cancel_requests(ctx, current, NULL);
@@ -9010,43 +9007,18 @@ static void io_uring_cancel_sqpoll(struct io_ring_ctx *ctx)
 		 * avoids a race where a completion comes in before we did
 		 * prepare_to_wait().
 		 */
-		if (inflight == tctx_inflight(tctx))
+		if (inflight == tctx_inflight(tctx, false))
 			schedule();
 		finish_wait(&tctx->wait, &wait);
 	} while (1);
 	atomic_dec(&tctx->in_idle);
 }
 
-void __io_uring_files_cancel(struct files_struct *files)
-{
-	struct io_uring_task *tctx = current->io_uring;
-	DEFINE_WAIT(wait);
-	s64 inflight;
-
-	/* make sure overflow events are dropped */
-	atomic_inc(&tctx->in_idle);
-	do {
-		/* read completions before cancelations */
-		inflight = tctx_inflight_tracked(tctx);
-		if (!inflight)
-			break;
-		io_uring_try_cancel(files);
-
-		prepare_to_wait(&tctx->wait, &wait, TASK_UNINTERRUPTIBLE);
-		if (inflight == tctx_inflight_tracked(tctx))
-			schedule();
-		finish_wait(&tctx->wait, &wait);
-	} while (1);
-	atomic_dec(&tctx->in_idle);
-
-	io_uring_clean_tctx(tctx);
-}
-
 /*
  * Find any io_uring fd that this task has registered or done IO on, and cancel
  * requests.
  */
-void __io_uring_task_cancel(void)
+void __io_uring_cancel(struct files_struct *files)
 {
 	struct io_uring_task *tctx = current->io_uring;
 	DEFINE_WAIT(wait);
@@ -9054,15 +9026,14 @@ void __io_uring_task_cancel(void)
 
 	/* make sure overflow events are dropped */
 	atomic_inc(&tctx->in_idle);
-	__io_uring_files_cancel(NULL);
+	io_uring_try_cancel(files);
 
 	do {
 		/* read completions before cancelations */
-		inflight = tctx_inflight(tctx);
+		inflight = tctx_inflight(tctx, !!files);
 		if (!inflight)
 			break;
-		io_uring_try_cancel(NULL);
-
+		io_uring_try_cancel(files);
 		prepare_to_wait(&tctx->wait, &wait, TASK_UNINTERRUPTIBLE);
 
 		/*
@@ -9070,16 +9041,17 @@ void __io_uring_task_cancel(void)
 		 * avoids a race where a completion comes in before we did
 		 * prepare_to_wait().
 		 */
-		if (inflight == tctx_inflight(tctx))
+		if (inflight == tctx_inflight(tctx, !!files))
 			schedule();
 		finish_wait(&tctx->wait, &wait);
 	} while (1);
-
 	atomic_dec(&tctx->in_idle);
 
 	io_uring_clean_tctx(tctx);
-	/* all current's requests should be gone, we can kill tctx */
-	__io_uring_free(current);
+	if (!files) {
+		/* for exec all current's requests should be gone, kill tctx */
+		__io_uring_free(current);
+	}
 }
 
 static void *io_uring_validate_mmap_request(struct file *file,
diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index 79cde9906be0..04b650bcbbe5 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -7,19 +7,17 @@
 
 #if defined(CONFIG_IO_URING)
 struct sock *io_uring_get_socket(struct file *file);
-void __io_uring_task_cancel(void);
-void __io_uring_files_cancel(struct files_struct *files);
+void __io_uring_cancel(struct files_struct *files);
 void __io_uring_free(struct task_struct *tsk);
 
-static inline void io_uring_task_cancel(void)
+static inline void io_uring_files_cancel(struct files_struct *files)
 {
 	if (current->io_uring)
-		__io_uring_task_cancel();
+		__io_uring_cancel(files);
 }
-static inline void io_uring_files_cancel(struct files_struct *files)
+static inline void io_uring_task_cancel(void)
 {
-	if (current->io_uring)
-		__io_uring_files_cancel(files);
+	return io_uring_files_cancel(NULL);
 }
 static inline void io_uring_free(struct task_struct *tsk)
 {
-- 
2.24.0

