Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D52730F467
	for <lists+io-uring@lfdr.de>; Thu,  4 Feb 2021 15:00:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236461AbhBDN7C (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Feb 2021 08:59:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236517AbhBDN4w (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Feb 2021 08:56:52 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F15C4C061797
        for <io-uring@vger.kernel.org>; Thu,  4 Feb 2021 05:56:02 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id u14so3056826wmq.4
        for <io-uring@vger.kernel.org>; Thu, 04 Feb 2021 05:56:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=/jsxEFi3mexEE8IxhV1JI/eXfgYmjPJFqnHdB5iAOnM=;
        b=Hieu2/bIXdWMH2tMknlZWJfZuQPtTNUo4mzFRPPtkTKUq789DBe8aYjHZ4lpmpAytX
         pZQ7NBq/4cdWZl9AhZn6K4EsIYoIObe7QRx031+GDfkS7AgumEPG1o5VRhuqFmi3tF9N
         5pCIClhA9BzpylSvj1bqOzyrjhnmjZAyk+fpgu+RduUpqFUJGr+qgwOvNinmzriM00RD
         Bi6PqpefwWjXkfyK/n5+D+yJaPdxOLRqAC1OCpUNzwvspR/Z28XGgQD5268BJhgHIZUs
         sdi4ztX1Al2iAQsG+Ti3+w1Yenw+y4814r1dMQlwHPQrxVstozjAOIj401z2g4QQvi58
         cs6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/jsxEFi3mexEE8IxhV1JI/eXfgYmjPJFqnHdB5iAOnM=;
        b=nMa93smfwk+J9mpRZTk2XB5ut4qFslXUqbqYk+/Wa3gjqnpBIxIR0qxr4abPeMLCOu
         cmd6BVBhmyu66a5ij3U5KgOeMoQiToaph8qfnPAWTP6tMRreTpp5SKbKV9BlW2wqYsSV
         MEs7EzxvxkJgEgXofXzl9UOX2S8GbtbHkwWJIuPPnZ/MhZDlrXLKfQaSLbAlUKg3TLJe
         1oTdkJdbfJbyRrTvdczK2awpi7MKTHtttfhpb+Fm/QPDcKkHV5K8YvizpBXw1+Bw8op+
         OBlmBXmey3UqkbeJ5H+MmuEPjnIRRbFjTN8wbilv64BaBdCe9ONh6Nbds467gwPb+pR+
         30zA==
X-Gm-Message-State: AOAM5316xvySMCFR8oqyGCNiPhQQB3Ga8JCPeF9fHup17fy/6fShf8X+
        utVG7eGHpUnP9JXvV9XJUiM=
X-Google-Smtp-Source: ABdhPJzTmPCqccFaK1e2fU1q4OJXq/aNFMu+ZqqlzQgh1dCnZbW2ywAHtGkm6QogZUWH8dqmKPRzkw==
X-Received: by 2002:a7b:cc16:: with SMTP id f22mr7432781wmh.131.1612446961771;
        Thu, 04 Feb 2021 05:56:01 -0800 (PST)
Received: from localhost.localdomain ([148.252.133.145])
        by smtp.gmail.com with ESMTPSA id k4sm8910561wrm.53.2021.02.04.05.56.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Feb 2021 05:56:01 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 03/13] io_uring: refactor io_cqring_wait
Date:   Thu,  4 Feb 2021 13:51:58 +0000
Message-Id: <fa9fc611b6c0001e5deb77188bbe48c8f38fcd5e.1612446019.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1612446019.git.asml.silence@gmail.com>
References: <cover.1612446019.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

It's easy to make a mistake in io_cqring_wait() because for all
break/continue clauses we need to watch for prepare/finish_wait to be
used correctly. Extract all those into a new helper
io_cqring_wait_schedule(), and transforming the loop into simple series
of func calls: prepare(); check_and_schedule(); finish();

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 43 ++++++++++++++++++++++---------------------
 1 file changed, 22 insertions(+), 21 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5b735635b8f0..dcb9e937daa3 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7195,6 +7195,25 @@ static int io_run_task_work_sig(void)
 	return -EINTR;
 }
 
+/* when returns >0, the caller should retry */
+static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
+					  struct io_wait_queue *iowq,
+					  signed long *timeout)
+{
+	int ret;
+
+	/* make sure we run task_work before checking for signals */
+	ret = io_run_task_work_sig();
+	if (ret || io_should_wake(iowq))
+		return ret;
+	/* let the caller flush overflows, retry */
+	if (test_bit(0, &ctx->cq_check_overflow))
+		return 1;
+
+	*timeout = schedule_timeout(*timeout);
+	return !*timeout ? -ETIME : 1;
+}
+
 /*
  * Wait until events become available, if we don't already have some. The
  * application must reap them itself, as they reside on the shared cq ring.
@@ -7251,27 +7270,9 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 		io_cqring_overflow_flush(ctx, false, NULL, NULL);
 		prepare_to_wait_exclusive(&ctx->wait, &iowq.wq,
 						TASK_INTERRUPTIBLE);
-		/* make sure we run task_work before checking for signals */
-		ret = io_run_task_work_sig();
-		if (ret > 0) {
-			finish_wait(&ctx->wait, &iowq.wq);
-			continue;
-		}
-		else if (ret < 0)
-			break;
-		if (io_should_wake(&iowq))
-			break;
-		if (test_bit(0, &ctx->cq_check_overflow)) {
-			finish_wait(&ctx->wait, &iowq.wq);
-			continue;
-		}
-		timeout = schedule_timeout(timeout);
-		if (timeout == 0) {
-			ret = -ETIME;
-			break;
-		}
-	} while (1);
-	finish_wait(&ctx->wait, &iowq.wq);
+		ret = io_cqring_wait_schedule(ctx, &iowq, &timeout);
+		finish_wait(&ctx->wait, &iowq.wq);
+	} while (ret > 0);
 
 	restore_saved_sigmask_unless(ret == -EINTR);
 
-- 
2.24.0

