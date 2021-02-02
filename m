Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7267F30B415
	for <lists+io-uring@lfdr.de>; Tue,  2 Feb 2021 01:28:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231259AbhBBA0T (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 1 Feb 2021 19:26:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230122AbhBBA0T (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 1 Feb 2021 19:26:19 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38333C0613ED
        for <io-uring@vger.kernel.org>; Mon,  1 Feb 2021 16:25:39 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id m2so859568wmm.1
        for <io-uring@vger.kernel.org>; Mon, 01 Feb 2021 16:25:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=/jsxEFi3mexEE8IxhV1JI/eXfgYmjPJFqnHdB5iAOnM=;
        b=pLK3ebdficViLE/f5YIVQBTIK0/h/H11nO6G8RDXwTb9G1v0VecpOmCNLGBujZEecm
         MgzJWUXfTGx+sSQq8kO391Po6VIi/iK3Vu3OEOboYK17f0HI+vBkYMhzUXt+mQhZYpGZ
         ncMaS49xhdnaAGIzo1AWqRLP95THuFlMmCsOI/gwZ11efsrtWzAPJs13WVu3yXN0PyRx
         mNDT3aqG9rYexGlc9W6zqzaCoCUJ1+NrzhhzxjggiIB59LGdVIESGk7EhLq4CthJ7jfq
         YjjshrsFj1UtYw/wWyCVrtsXJg3h5PySWJBi7mZEgwm37yvN3PTFcMJ3hutcTwPye0Av
         vMIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/jsxEFi3mexEE8IxhV1JI/eXfgYmjPJFqnHdB5iAOnM=;
        b=O7iY8btmLcufzsKLPu/gsmhnAN4DVnUwwXuyX7Gs5Dn14yquNWGqf5M/3ovZA/KkBl
         K5rkSHLRUM3jOQBKp951Ch8oHtZ3dtv+hpCKLVQ4TyIyL23mdp43ftNbpohJ9OSsxgS7
         IAlvDB0K6VRwhLH+WVYlzv019tQjNLH0wPGzxN8ezBcFxrgSUkSEnvdIE4YyqVq9QxgR
         csdmNLsG1iajHC6Pcp+/I7rTBCMxE9WFx/Egn1sGzSxNwCaOUf4l7iTfjtgVGwaLDXKn
         vqV7UhQ/n6uzz2A0LXf+bRjSC3Qu0acB38IlKpjNxURP6Nz7gB+gkqQIUEdtFI1koSyB
         uGMA==
X-Gm-Message-State: AOAM532/zgGLR0gF3ZMWZWtup1/ScunCEdtGXHCAOo03nXcaF0K4GboD
        fv8ddEcyvl2G4knqkSQmVSkTPjl0P/8=
X-Google-Smtp-Source: ABdhPJw3B/ut3ER7kA6ZYtloiSqGy0GjX8aeYn0qaXcyusJdX+V6ZAkDqSxy2cYgrWDiUeeWCYk6Yw==
X-Received: by 2002:a7b:c196:: with SMTP id y22mr1133712wmi.91.1612225538015;
        Mon, 01 Feb 2021 16:25:38 -0800 (PST)
Received: from localhost.localdomain ([185.69.145.241])
        by smtp.gmail.com with ESMTPSA id n187sm851740wmf.29.2021.02.01.16.25.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 16:25:37 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 3/8] io_uring: refactor io_cqring_wait
Date:   Tue,  2 Feb 2021 00:21:41 +0000
Message-Id: <0eafe25b2ab578b81a754d1650c60ddd4224cddf.1612223953.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1612223953.git.asml.silence@gmail.com>
References: <cover.1612223953.git.asml.silence@gmail.com>
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

