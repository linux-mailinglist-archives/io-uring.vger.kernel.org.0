Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D60C632C9AC
	for <lists+io-uring@lfdr.de>; Thu,  4 Mar 2021 02:19:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236787AbhCDBJ6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 Mar 2021 20:09:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384530AbhCDAby (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 3 Mar 2021 19:31:54 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B99AC0613B9
        for <io-uring@vger.kernel.org>; Wed,  3 Mar 2021 16:27:14 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id z5so2200644plg.3
        for <io-uring@vger.kernel.org>; Wed, 03 Mar 2021 16:27:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0DigGaSiDnIBYosyMZyiyF8o1ntXs5aszaJlII/X9As=;
        b=pPe+0OqlPubbQEPP+2EbKqAsw4QzvbJtLwEzk/w81IJohzx1BOu2csS2w7ae1zbmgX
         rGLGOqv/3qf+hSb1H9CZdwPVO76CQzuv4uk+1qZHRgErPLIHX1uQlPsU6lvHU/sCgRmd
         aig2bu0Zr3++7+sWKJtdCY6w88Di9Z1uc0eopFzuYnZvM+PbpdP3xeJ5vqnjAj0mvPi4
         hSfGCevsEUaIALzkQnxSMPeBGk09CjnvuH+dBzG11mVVO9gofTH6o/rn56gjxXfIbKen
         51Ax84QyO1Jr5FYUx1xc5uMzQUbY+mpMbggu2fsAP1i0sF8rjZ67OfLSTQypqeD/JvAN
         VP5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0DigGaSiDnIBYosyMZyiyF8o1ntXs5aszaJlII/X9As=;
        b=C8Q+heV3Qd3s99dyDZqCGzMZR73rPmBTF58ypwJqBLguUCIIo/cluzT7M29vrZNUHQ
         7FmsOPn0hkHBAew4ClM3V8PYC2JYccAtMQO7BXrSpabA78hL1JRMf5oHMSKiy4F2Bdwu
         kBZZBR2qgQ5MTgCHJx+JYU9vYxYPbKifP38dJC93Ao/Ib/MRILZwKt2gmW6BvlGUyVBC
         RZZKVTm6Sh2/Lnai8UnLnZsOgqRgHa0DGvpQQuZEYstKGu862OzOScFuSElJ8l3T9VZX
         VL/Jqoe3TNCdtN9GQAIbaEGhMyUWDgmSKtwVD5k5KZgtUsbt6+kxjD3lzuVfen9ItmmX
         LRcA==
X-Gm-Message-State: AOAM531RB7znRZklGO4FfsjfwxRcNOvPJ+++kZV0A2pn6mPO39XtStwU
        wUlzjqP38rpafoqaHRFki6AMkEn3XR3+zYQZ
X-Google-Smtp-Source: ABdhPJxnpjcATcHBK8MqYBDjDzUYrEEw/UVfzh8Jtp+CYq6UcXFxS2UfyBmqvK2FOOTqNBqTtvnMYQ==
X-Received: by 2002:a17:90a:ba16:: with SMTP id s22mr1737727pjr.88.1614817633857;
        Wed, 03 Mar 2021 16:27:13 -0800 (PST)
Received: from localhost.localdomain ([2600:380:7540:52b5:3f01:150c:3b2:bf47])
        by smtp.gmail.com with ESMTPSA id b6sm23456983pgt.69.2021.03.03.16.27.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 16:27:13 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 07/33] io_uring: SQPOLL stop error handling fixes
Date:   Wed,  3 Mar 2021 17:26:34 -0700
Message-Id: <20210304002700.374417-8-axboe@kernel.dk>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210304002700.374417-1-axboe@kernel.dk>
References: <20210304002700.374417-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If we fail to fork an SQPOLL worker, we can hit cancel, and hence
attempted thread stop, with the thread already being stopped. Ensure
we check for that.

Also guard thread stop fully by the sqd mutex, just like we do for
park.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 4a088581b0f2..d55c9ab6314a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6793,9 +6793,9 @@ static int io_sq_thread(void *data)
 		ctx->sqo_exec = 1;
 		io_ring_set_wakeup_flag(ctx);
 	}
-	mutex_unlock(&sqd->lock);
 
 	complete(&sqd->exited);
+	mutex_unlock(&sqd->lock);
 	do_exit(0);
 }
 
@@ -7118,13 +7118,19 @@ static bool io_sq_thread_park(struct io_sq_data *sqd)
 
 static void io_sq_thread_stop(struct io_sq_data *sqd)
 {
-	if (!sqd->thread)
+	if (test_bit(IO_SQ_THREAD_SHOULD_STOP, &sqd->state))
 		return;
-
-	set_bit(IO_SQ_THREAD_SHOULD_STOP, &sqd->state);
-	WARN_ON_ONCE(test_bit(IO_SQ_THREAD_SHOULD_PARK, &sqd->state));
-	wake_up_process(sqd->thread);
-	wait_for_completion(&sqd->exited);
+	mutex_lock(&sqd->lock);
+	if (sqd->thread) {
+		set_bit(IO_SQ_THREAD_SHOULD_STOP, &sqd->state);
+		WARN_ON_ONCE(test_bit(IO_SQ_THREAD_SHOULD_PARK, &sqd->state));
+		wake_up_process(sqd->thread);
+		mutex_unlock(&sqd->lock);
+		wait_for_completion(&sqd->exited);
+		WARN_ON_ONCE(sqd->thread);
+	} else {
+		mutex_unlock(&sqd->lock);
+	}
 }
 
 static void io_put_sq_data(struct io_sq_data *sqd)
@@ -8867,6 +8873,11 @@ static void io_uring_cancel_sqpoll(struct io_ring_ctx *ctx)
 	if (!io_sq_thread_park(sqd))
 		return;
 	tctx = ctx->sq_data->thread->io_uring;
+	/* can happen on fork/alloc failure, just ignore that state */
+	if (!tctx) {
+		io_sq_thread_unpark(sqd);
+		return;
+	}
 
 	atomic_inc(&tctx->in_idle);
 	do {
-- 
2.30.1

