Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAE455F6F8E
	for <lists+io-uring@lfdr.de>; Thu,  6 Oct 2022 22:43:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232002AbiJFUns (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 6 Oct 2022 16:43:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232156AbiJFUnr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 6 Oct 2022 16:43:47 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9A17A0268
        for <io-uring@vger.kernel.org>; Thu,  6 Oct 2022 13:43:46 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id bg9-20020a05600c3c8900b003bf249616b0so1587485wmb.3
        for <io-uring@vger.kernel.org>; Thu, 06 Oct 2022 13:43:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=jfuFoqaoIRFe8vBAM+OhqubenoM3MT5F7PhzON337EQ=;
        b=cdFzPTmgEPIosZMMtuCCGOQprx8hBdam7T7e4jaexmhDtZs1MGqrpLxXovMmqK9sRE
         4n0Q8pyWB/QTteGzZV3B9bnzNskENYjVJ3QNMUZSC8mRHBZKFMP5igpKvRhfesZjmX2a
         aeBCtb+FPRNLjITaw35K+/4H2UfMPboxclH7GAO1Npi3o8RWJ21fR9dt3gE2h1X+M/jM
         rKqDKq3zddEYkNUn8wjYrYEaJCg4a+AGkgVM+Z0BqsOdvZhz9EX+sWVvOXm+HzPLcsx2
         nYySHJLTpGRX3OF+4o1GXqEiwC0SBtiW12l1qdd9xlqyyvj+azo3r45Ccf01HohJ/Sj0
         Yqww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jfuFoqaoIRFe8vBAM+OhqubenoM3MT5F7PhzON337EQ=;
        b=z3Hax62i1eKnMa6qo6rYvYjEX5JA35qIDr4opv0mHHshUlYo2vbt/R7/Cx9FXYPgy4
         3ZUMEx6VsXHRzSWOFd0jOrl/Va8DjwqMz7+nnxXAZxS8F/A7AtVO7MPtGb0+Bv79z9lh
         23piyYG8h6KdSl7cb33QqiVmLks3QqLDsPNtwM4r8XTfSv6u5knSUNW2F3hjMEunm6ec
         XYCgiDRo7Xg7IAKQgbaZ7jNP6P1gWElr8j623TGMbKrQoYVl+NAPxS6nN9kRvAwwYKRR
         SQMSud4pWiBphgLrP+ogXipqLepVdFR1N4RE6Z+/6hTGnbYKoLX3Dh8lKv/U+yCGW0YO
         yUpg==
X-Gm-Message-State: ACrzQf3+tb6oHOZKSpgq0dR8d63Dvzpc5B4nQY653wjK/igKt4CulzoH
        L5TMVXe82HRj43wUFFM36oLOYK2SbDw=
X-Google-Smtp-Source: AMsMyM61gKMzpTQ8tC1yTwViCFZy8kUx5/bV3MoR8lU6cvcFLLf7hg9syOxt8Gw2rh7nJobU683FYQ==
X-Received: by 2002:a05:600c:1910:b0:3b4:bb80:c95e with SMTP id j16-20020a05600c191000b003b4bb80c95emr1039167wmq.54.1665089024527;
        Thu, 06 Oct 2022 13:43:44 -0700 (PDT)
Received: from 127.0.0.1localhost (94.196.209.4.threembb.co.uk. [94.196.209.4])
        by smtp.gmail.com with ESMTPSA id f62-20020a1c3841000000b003b31fc77407sm6662683wma.30.2022.10.06.13.43.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Oct 2022 13:43:44 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH 1/1] io_uring: optimise locking for local tw with submit_wait
Date:   Thu,  6 Oct 2022 21:42:33 +0100
Message-Id: <281fc79d98b5d91fe4778c5137a17a2ab4693e5c.1665088876.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Running local task_work requires taking uring_lock, for submit + wait we
can try to run them right after submit while we still hold the lock and
save one lock/unlokc pair. The optimisation was implemented in the first
local tw patches but got dropped for simplicity.

Suggested-by: Dylan Yudaken <dylany@fb.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 12 ++++++++++--
 io_uring/io_uring.h |  7 +++++++
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 355fc1f3083d..b092473eca1d 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3224,8 +3224,16 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 			mutex_unlock(&ctx->uring_lock);
 			goto out;
 		}
-		if ((flags & IORING_ENTER_GETEVENTS) && ctx->syscall_iopoll)
-			goto iopoll_locked;
+		if (flags & IORING_ENTER_GETEVENTS) {
+			if (ctx->syscall_iopoll)
+				goto iopoll_locked;
+			/*
+			 * Ignore errors, we'll soon call io_cqring_wait() and
+			 * it should handle ownership problems if any.
+			 */
+			if (ctx->flags & IORING_SETUP_DEFER_TASKRUN)
+				(void)io_run_local_work_locked(ctx);
+		}
 		mutex_unlock(&ctx->uring_lock);
 	}
 
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index e733d31f31d2..8504bc1f3839 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -275,6 +275,13 @@ static inline int io_run_task_work_ctx(struct io_ring_ctx *ctx)
 	return ret;
 }
 
+static inline int io_run_local_work_locked(struct io_ring_ctx *ctx)
+{
+	if (llist_empty(&ctx->work_llist))
+		return 0;
+	return __io_run_local_work(ctx, true);
+}
+
 static inline void io_tw_lock(struct io_ring_ctx *ctx, bool *locked)
 {
 	if (!*locked) {
-- 
2.37.3

