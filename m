Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4A5050EE4B
	for <lists+io-uring@lfdr.de>; Tue, 26 Apr 2022 03:49:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241423AbiDZBwW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 Apr 2022 21:52:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241470AbiDZBwU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Apr 2022 21:52:20 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D417655493
        for <io-uring@vger.kernel.org>; Mon, 25 Apr 2022 18:49:14 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id z16so16535182pfh.3
        for <io-uring@vger.kernel.org>; Mon, 25 Apr 2022 18:49:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9KEfLt3SyZq5Q+BmSi1slxS/EHD0pTbAB1B3uljmJAE=;
        b=bMnU/0ty5PLd7cbiA/FZ2TiHm/UpDcVVoUWLGcWDvzs3tuHXCrHDxYHSzMqjMlOF9J
         JVRB/kmXDqtggAKf9x3BSD4mHFkFi3t9xFaq/G4+eCEZp9F7xk7Lfm5EPe1I1Ouakatv
         9D4ZSOmSD2z/eG+xsJzy128COxX0uzDku/RAjZDp3UAmh5RC+auuiDWMATuIrmDDNntT
         5STC7BGKkstfJ82DVAdD+5C//7bX5cAnke0jZZg4veHjmxUsJEUVLtgRErpjtwsOcUI9
         VWQr15yvehnrC7D6+H1wNGbQwcPgU9sUNR6cKw9QFhGYLIZ6KpBwiCUrP56OsVs9avOa
         IS8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9KEfLt3SyZq5Q+BmSi1slxS/EHD0pTbAB1B3uljmJAE=;
        b=twWyfMR1pA8kZMjnBHKscz2Sya5V2rovukVnx9LyjoE0rG1SeTlUjPcNFdPzSIY2lA
         HOM2OuhA/QqoP61oA79zpzGOB0BuUTlLQ6HZuFqJ3HYeidPCO4/oWD4wjn708c4s2H8x
         dAwaUsMy9el+Di33pP54Z794RrOkJJN/8DBXxIwMTqybTr408mJwcjV3LS4yOtWix8H/
         6uI0UYvmgaSnyb6gBvHT97oAMzlQ2ilNc+mUNO+YRPIAILUE2qE42f9u7p2JEN/wcoCJ
         MTLN01txMxYFY7akyO7zHuxtFTiijRdh5fS8Lr/hgPVe+EVc2mfcr7qyNME8r9c+saCU
         YE1A==
X-Gm-Message-State: AOAM532YDbUAL6HhCDbdca4RZd1KGaQQty1TpOTnwXFMpQRHoM0nxNBk
        qFIhtUYlQ7m15AZe5WC9/kjHhGKsJRNjeqDq
X-Google-Smtp-Source: ABdhPJzc1+znu75FTLiud8VYfWDMkPfoW3vJq/6IybN1WTi+n6QajDMmIKr835WVE9pB50nvCwQo0Q==
X-Received: by 2002:a65:45c5:0:b0:39c:ec64:cc16 with SMTP id m5-20020a6545c5000000b0039cec64cc16mr17503507pgr.505.1650937753903;
        Mon, 25 Apr 2022 18:49:13 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id i23-20020a056a00225700b0050d38d0f58dsm6076149pfu.213.2022.04.25.18.49.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Apr 2022 18:49:13 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6/6] io_uring: add IORING_SETUP_TASKRUN_FLAG
Date:   Mon, 25 Apr 2022 19:49:04 -0600
Message-Id: <20220426014904.60384-7-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220426014904.60384-1-axboe@kernel.dk>
References: <20220426014904.60384-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If IORING_SETUP_COOP_TASKRUN is set to use cooperative scheduling for
running task_work, then IORING_SETUP_TASKRUN_FLAG can be set so the
application can tell if task_work is pending in the kernel for this
ring. This allows use cases like io_uring_peek_cqe() to still function
appropriately, or for the task to know when it would be useful to
call io_uring_wait_cqe() to run pending events.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c                 | 14 +++++++++++---
 include/uapi/linux/io_uring.h |  7 +++++++
 2 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5e4842cd21c2..2c859ab326cd 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2536,6 +2536,8 @@ static void ctx_flush_and_put(struct io_ring_ctx *ctx, bool *locked)
 {
 	if (!ctx)
 		return;
+	if (ctx->flags & IORING_SETUP_TASKRUN_FLAG)
+		atomic_andnot(IORING_SQ_TASKRUN, &ctx->rings->sq_flags);
 	if (*locked) {
 		io_submit_flush_completions(ctx);
 		mutex_unlock(&ctx->uring_lock);
@@ -2676,6 +2678,9 @@ static void io_req_task_work_add(struct io_kiocb *req, bool priority)
 	if (running)
 		return;
 
+	if (ctx->flags & IORING_SETUP_TASKRUN_FLAG)
+		atomic_or(IORING_SQ_TASKRUN, &ctx->rings->sq_flags);
+
 	if (likely(!task_work_add(tsk, &tctx->task_work, ctx->notify_method)))
 		return;
 
@@ -11702,12 +11707,15 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
 	ret = -EINVAL;
 	if (ctx->flags & IORING_SETUP_SQPOLL) {
 		/* IPI related flags don't make sense with SQPOLL */
-		if (ctx->flags & IORING_SETUP_COOP_TASKRUN)
+		if (ctx->flags & (IORING_SETUP_COOP_TASKRUN |
+				  IORING_SETUP_TASKRUN_FLAG))
 			goto err;
 		ctx->notify_method = TWA_SIGNAL_NO_IPI;
 	} else if (ctx->flags & IORING_SETUP_COOP_TASKRUN) {
 		ctx->notify_method = TWA_SIGNAL_NO_IPI;
 	} else {
+		if (ctx->flags & IORING_SETUP_TASKRUN_FLAG)
+			goto err;
 		ctx->notify_method = TWA_SIGNAL;
 	}
 
@@ -11809,10 +11817,10 @@ static long io_uring_setup(u32 entries, struct io_uring_params __user *params)
 			IORING_SETUP_SQ_AFF | IORING_SETUP_CQSIZE |
 			IORING_SETUP_CLAMP | IORING_SETUP_ATTACH_WQ |
 			IORING_SETUP_R_DISABLED | IORING_SETUP_SUBMIT_ALL |
-			IORING_SETUP_COOP_TASKRUN))
+			IORING_SETUP_COOP_TASKRUN | IORING_SETUP_TASKRUN_FLAG))
 		return -EINVAL;
 
-	return  io_uring_create(entries, &p, params);
+	return io_uring_create(entries, &p, params);
 }
 
 SYSCALL_DEFINE2(io_uring_setup, u32, entries,
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 4654842ace88..ad53def6abb8 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -112,6 +112,12 @@ enum {
  * a task running in userspace, and saves an IPI.
  */
 #define IORING_SETUP_COOP_TASKRUN	(1U << 8)
+/*
+ * If COOP_TASKRUN is set, get notified if task work is available for
+ * running and a kernel transition would be needed to run it. This sets
+ * IORING_SQ_TASKRUN in the sq ring flags. Not valid with COOP_TASKRUN.
+ */
+#define IORING_SETUP_TASKRUN_FLAG	(1U << 9)
 
 enum {
 	IORING_OP_NOP,
@@ -263,6 +269,7 @@ struct io_sqring_offsets {
  */
 #define IORING_SQ_NEED_WAKEUP	(1U << 0) /* needs io_uring_enter wakeup */
 #define IORING_SQ_CQ_OVERFLOW	(1U << 1) /* CQ ring is overflown */
+#define IORING_SQ_TASKRUN	(1U << 2) /* task should enter the kernel */
 
 struct io_cqring_offsets {
 	__u32 head;
-- 
2.35.1

