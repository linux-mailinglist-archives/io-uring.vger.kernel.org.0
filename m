Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5548B3127EC
	for <lists+io-uring@lfdr.de>; Sun,  7 Feb 2021 23:39:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbhBGWjA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 7 Feb 2021 17:39:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbhBGWi7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 7 Feb 2021 17:38:59 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40B4EC06174A
        for <io-uring@vger.kernel.org>; Sun,  7 Feb 2021 14:38:19 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id r7so5438751wrq.9
        for <io-uring@vger.kernel.org>; Sun, 07 Feb 2021 14:38:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qe5JI/A8MGPOdHVGCXNQAipB6aYf8ZVH8pqPzdUusr8=;
        b=Gn9ASZw2+WT90f4V5uSO9mooOrH4qOx4fu2Pudnll2Kk47Ul5C7ewOVXdfGqVaG7iG
         MiedS3eeXAz0C8eXZrEsA0gxLvcv3uvnpiQJi6M2ydUTFHUa7arV6try3D5kDEt+Qa1d
         nQU1mkhOuAISyOdVeNO8SHgviCvtqaRsD9dg8n/ZsbVsMUQ8Q365/l+RBAGdxR8RWgrk
         OnaWkbv5aT5Tw/0i8KtGOu1V9OHKON0+qR8jYhzYKklCLbOby6MmZOEQGsD8u4yzEKbX
         ksO7L0fp7l8zrkSl3L06RlFPdtK9j3JZDVzh583EH9twbzl2V58V+abFDAkBT3mJGNxU
         QLqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qe5JI/A8MGPOdHVGCXNQAipB6aYf8ZVH8pqPzdUusr8=;
        b=HGhBek1LSzvBrnWWIcK313E5Np85b4dWgDpuFSf0Ar8BhLTLmZ7JEmuM+SXIUMuAZn
         lF990FADmWQ79dvcPIyrLhqxMT85mw+hr++riw00bdXPvnjgZQhkk6kfUTykLM3aM186
         fSTrzfaeWpQMVyvU3DpsqmhJio83ZURVO3yCKIL0tatZmko+4s7YIw5NEvwUHzXkzfJF
         fDoeTuuXkKlD2ORuvTzmvzhp2a8DEya8RAL5RUbXA1G/ER6/NTqgZ9hsgWs0gSGPDrPl
         mahHCkYcaTxTBhHxEqyGVI4vRlXACMEx5dgkLFE46Jjt9srvgkwUm7tC21Bq+/3pHbKd
         PX/Q==
X-Gm-Message-State: AOAM533ihuuM7SUcf7VGZY++zx7Vge3lGoYrgiQZ90a1XE9UKuUUZcFp
        V8qpufIu3alQdmA6tZ4M4w5VAwWZT3A=
X-Google-Smtp-Source: ABdhPJzXHGoO4H91wM1ozIqLpfcacKCoShY7ueRVw3fJ35dYT0vjgNcr8SzBoxFDFTYWUz2Uksky2Q==
X-Received: by 2002:a5d:40c3:: with SMTP id b3mr2651052wrq.102.1612737498048;
        Sun, 07 Feb 2021 14:38:18 -0800 (PST)
Received: from localhost.localdomain ([148.252.128.244])
        by smtp.gmail.com with ESMTPSA id d16sm24388602wrr.59.2021.02.07.14.38.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Feb 2021 14:38:17 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 5.12] io_uring: cancel SQPOLL reqs acress exec
Date:   Sun,  7 Feb 2021 22:34:26 +0000
Message-Id: <a50e2df51707fc1de3708fe087e08b3aa16f492a.1612737169.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

For SQPOLL rings tctx_inflight() always returns zero, so it might skip
doing full cancellion. It's fine because we jam all sqpoll submissions
in any case and do go through files cancel for them, but not nice.

Do the intended full cancellation, by mimicing __io_uring_task_cancel()
waiting but impersonating SQPOLL task.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 57 ++++++++++++++++++++++++++++++++-------------------
 1 file changed, 36 insertions(+), 21 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index af3ac85d11cc..90d566e0fc89 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -9094,29 +9094,39 @@ void __io_uring_files_cancel(struct files_struct *files)
 
 static s64 tctx_inflight(struct io_uring_task *tctx)
 {
-	unsigned long index;
-	struct file *file;
-	s64 inflight;
-
-	inflight = percpu_counter_sum(&tctx->inflight);
-	if (!tctx->sqpoll)
-		return inflight;
+	return percpu_counter_sum(&tctx->inflight);
+}
 
-	/*
-	 * If we have SQPOLL rings, then we need to iterate and find them, and
-	 * add the pending count for those.
-	 */
-	xa_for_each(&tctx->xa, index, file) {
-		struct io_ring_ctx *ctx = file->private_data;
+static void io_uring_cancel_sqpoll(struct io_ring_ctx *ctx)
+{
+	struct io_uring_task *tctx;
+	s64 inflight;
+	DEFINE_WAIT(wait);
 
-		if (ctx->flags & IORING_SETUP_SQPOLL) {
-			struct io_uring_task *__tctx = ctx->sqo_task->io_uring;
+	if (!ctx->sq_data)
+		return;
+	tctx = ctx->sq_data->thread->io_uring;
+	io_disable_sqo_submit(ctx);
 
-			inflight += percpu_counter_sum(&__tctx->inflight);
-		}
-	}
+	atomic_inc(&tctx->in_idle);
+	do {
+		/* read completions before cancelations */
+		inflight = tctx_inflight(tctx);
+		if (!inflight)
+			break;
+		io_uring_cancel_task_requests(ctx, NULL);
 
-	return inflight;
+		prepare_to_wait(&tctx->wait, &wait, TASK_UNINTERRUPTIBLE);
+		/*
+		 * If we've seen completions, retry without waiting. This
+		 * avoids a race where a completion comes in before we did
+		 * prepare_to_wait().
+		 */
+		if (inflight == tctx_inflight(tctx))
+			schedule();
+		finish_wait(&tctx->wait, &wait);
+	} while (1);
+	atomic_dec(&tctx->in_idle);
 }
 
 /*
@@ -9133,8 +9143,13 @@ void __io_uring_task_cancel(void)
 	atomic_inc(&tctx->in_idle);
 
 	/* trigger io_disable_sqo_submit() */
-	if (tctx->sqpoll)
-		__io_uring_files_cancel(NULL);
+	if (tctx->sqpoll) {
+		struct file *file;
+		unsigned long index;
+
+		xa_for_each(&tctx->xa, index, file)
+			io_uring_cancel_sqpoll(file->private_data);
+	}
 
 	do {
 		/* read completions before cancelations */
-- 
2.24.0

