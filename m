Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 609BD2DE32C
	for <lists+io-uring@lfdr.de>; Fri, 18 Dec 2020 14:17:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725885AbgLRNQq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Dec 2020 08:16:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726515AbgLRNQp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Dec 2020 08:16:45 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BF4FC061285
        for <io-uring@vger.kernel.org>; Fri, 18 Dec 2020 05:16:05 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id 190so2297339wmz.0
        for <io-uring@vger.kernel.org>; Fri, 18 Dec 2020 05:16:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=T1gXkpXtMtonsDdivBKHIPvmeYieApSOyhMQj82nJTY=;
        b=XTf/GXiOq1p22JKWxJ61aWJe1Tf/Z3VpXZMB0TBAfI4dTK1bG1h9tL8QT14tJuSwFL
         szoM8qC7vL/0SiQ86lkAmyw10eeu4q087/l3WW0supJmG3ShAZU5bL2xyMo7PQ1OcV/Z
         6cR3MhlyuHNO1Vv4VpH41TXwIv1xskgu6MEC2njXXS+o5LXl1apZozPhyJLkERXAEOyP
         Cpwp6MT3aOfGpLmqjUpZTyYjb0Nw0L60kp7Xd7UzYyUtMTZyjZ7NyZxEOSsrM2X0QENQ
         grRRTpfpGvnGP0o8Oht2TFMjQPPNMFAGNjSdKvc9eq3CaI9HrLynn0UmZrI0UlT3T8Ag
         Fubw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=T1gXkpXtMtonsDdivBKHIPvmeYieApSOyhMQj82nJTY=;
        b=K9EGGyZj/eejdXfsdIwS5g57wpd4qK9lvruOuiX7CRtJG82v46wL4y3IAEWDvVTtTU
         XeZNbEoz3YMP5TzfBPjEQ0MPHTwsNBNOEaZUeSOnokEja107mvTDIH04OFeHRHkWa3+l
         f6spU5IuePXuyXISIwsv+gA5viy7KP3wV3K2mXDnYdjsM82ogAR6mv3i0fWs5EiHhRQX
         m9eeZjI3pcqua1bbQHGegDmiVfOpObaKkFG6gAbU8XpMmGEBSyMUypyvbtNmPKPME8PA
         SKupbi/mNZDYTdagivN6VA2Oc9lNVFr/4xSH4BqxH1MLAXIVIb9SDJne0K7/Xj02s4AF
         mGDg==
X-Gm-Message-State: AOAM532oTjB/HXcL1i8EpBnbdiGlYUfzGsSohZFrfGCRcXJXMtT73aXL
        pL16rBTocq8O7/KxcXU9H/Qn5/vsTNtH8A==
X-Google-Smtp-Source: ABdhPJy8fA/YPFrJz8fw30ocoAijzjC2Zk2FhpEWZT2p20riUDevG8QB7q9uas+qRFTtVUhO7B9h6g==
X-Received: by 2002:a1c:4156:: with SMTP id o83mr4235860wma.178.1608297364270;
        Fri, 18 Dec 2020 05:16:04 -0800 (PST)
Received: from localhost.localdomain ([85.255.234.120])
        by smtp.gmail.com with ESMTPSA id b9sm12778595wmd.32.2020.12.18.05.16.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Dec 2020 05:16:03 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 5/8] io_uring: draft files cancel based on inflight cnt
Date:   Fri, 18 Dec 2020 13:12:25 +0000
Message-Id: <281837147e67a827bbd340fe6b10b0763d24779d.1608296656.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1608296656.git.asml.silence@gmail.com>
References: <cover.1608296656.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Do same thing for files cancellation as we do for task cancellations, in
particular keep trying to cancel while corresponding inflight counters
are not zero.

It's a preparation patch, io_uring_try_task_cancel still guarantees to
kill all requests matching files at first attempt. It also deduplicate a
bit those two functions allowing exporting only __io_uring_task_cancel()
from them to the core.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c            | 29 +++++++++++++++--------------
 include/linux/io_uring.h | 12 +++++-------
 2 files changed, 20 insertions(+), 21 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 1794ad4bfa39..d20a2a96c3f8 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8909,7 +8909,7 @@ static void io_uring_attempt_task_drop(struct file *file)
 		io_uring_del_task_file(current->io_uring, file);
 }
 
-void __io_uring_files_cancel(struct files_struct *files)
+static void io_uring_try_task_cancel(struct files_struct *files)
 {
 	struct io_uring_task *tctx = current->io_uring;
 	struct file *file;
@@ -8917,15 +8917,8 @@ void __io_uring_files_cancel(struct files_struct *files)
 
 	/* make sure overflow events are dropped */
 	atomic_inc(&tctx->in_idle);
-
-	xa_for_each(&tctx->xa, index, file) {
-		struct io_ring_ctx *ctx = file->private_data;
-
-		io_uring_cancel_task_requests(ctx, files);
-		if (files)
-			io_uring_del_task_file(tctx, file);
-	}
-
+	xa_for_each(&tctx->xa, index, file)
+		io_uring_cancel_task_requests(file->private_data, files);
 	atomic_dec(&tctx->in_idle);
 }
 
@@ -8968,7 +8961,7 @@ static s64 tctx_inflight(struct io_uring_task *tctx, bool files)
  * Find any io_uring fd that this task has registered or done IO on, and cancel
  * requests.
  */
-void __io_uring_task_cancel(void)
+void __io_uring_task_cancel(struct files_struct *files)
 {
 	struct io_uring_task *tctx = current->io_uring;
 	DEFINE_WAIT(wait);
@@ -8979,10 +8972,10 @@ void __io_uring_task_cancel(void)
 
 	do {
 		/* read completions before cancelations */
-		inflight = tctx_inflight(tctx, false);
+		inflight = tctx_inflight(tctx, !!files);
 		if (!inflight)
 			break;
-		__io_uring_files_cancel(NULL);
+		io_uring_try_task_cancel(files);
 
 		prepare_to_wait(&tctx->wait, &wait, TASK_UNINTERRUPTIBLE);
 
@@ -8990,13 +8983,21 @@ void __io_uring_task_cancel(void)
 		 * If we've seen completions, retry. This avoids a race where
 		 * a completion comes in before we did prepare_to_wait().
 		 */
-		if (inflight != tctx_inflight(tctx, false))
+		if (inflight != tctx_inflight(tctx, !!files))
 			continue;
 		schedule();
 	} while (1);
 
 	finish_wait(&tctx->wait, &wait);
 	atomic_dec(&tctx->in_idle);
+
+	if (files) {
+		struct file *file;
+		unsigned long index;
+
+		xa_for_each(&tctx->xa, index, file)
+			io_uring_del_task_file(tctx, file);
+	}
 }
 
 static int io_uring_flush(struct file *file, void *data)
diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index e1ff6f235d03..282f02bd04a5 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -37,19 +37,17 @@ struct io_uring_task {
 
 #if defined(CONFIG_IO_URING)
 struct sock *io_uring_get_socket(struct file *file);
-void __io_uring_task_cancel(void);
-void __io_uring_files_cancel(struct files_struct *files);
+void __io_uring_task_cancel(struct files_struct *files);
 void __io_uring_free(struct task_struct *tsk);
 
-static inline void io_uring_task_cancel(void)
+static inline void io_uring_files_cancel(struct files_struct *files)
 {
 	if (current->io_uring && !xa_empty(&current->io_uring->xa))
-		__io_uring_task_cancel();
+		__io_uring_task_cancel(files);
 }
-static inline void io_uring_files_cancel(struct files_struct *files)
+static inline void io_uring_task_cancel(void)
 {
-	if (current->io_uring && !xa_empty(&current->io_uring->xa))
-		__io_uring_files_cancel(files);
+	io_uring_files_cancel(NULL);
 }
 static inline void io_uring_free(struct task_struct *tsk)
 {
-- 
2.24.0

