Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FA6150E2F1
	for <lists+io-uring@lfdr.de>; Mon, 25 Apr 2022 16:21:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242425AbiDYOYd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 Apr 2022 10:24:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238888AbiDYOYb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Apr 2022 10:24:31 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3EB922B0A
        for <io-uring@vger.kernel.org>; Mon, 25 Apr 2022 07:21:27 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id 125so15972823iov.10
        for <io-uring@vger.kernel.org>; Mon, 25 Apr 2022 07:21:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DZJvpqgF7MRZExdNW3AfbjrEHr/GLOL2eJbCgcJpGkc=;
        b=x681J7ztxTA//tZUf2z5Kxy8W6LbF11pNiV2P5glXC67Dv0Dn8C1gdV4ow9SOquQpy
         A6QtTQ2YevVw5CVG9zsMf+SOIXOX7vdDEhu1haVy1zFiaQ4pnCUoEVD3/NLcliDhPUBm
         OjXPmR03HcZ5p36hfF+nD44o1gkF+AAJpEIelC9X2UIfO/7NE3Lv+ryENZ7dCGDq32oO
         QsfGRfP8qVwR8TfvBu4C3CQGHKA890MH0ChICmy9mxn+nPtJ+lmQCJ9QvnuuwC9jLrCy
         w7T3v+1Jp5iQrAUEXJchiUqhayCdZKbmA0MgdG26pS6EnGI998vb9YX1ay5nxAvtuVGl
         jh2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DZJvpqgF7MRZExdNW3AfbjrEHr/GLOL2eJbCgcJpGkc=;
        b=cRqMTdSLvXt3nLT6dnLO+6N6Y/dW3D1kvkuKyXIQKBPBTOWJ+pZLJeu4yzfwcSbX4g
         2vKU81TJ1sg/f0Oyt7YkcTn3GeA3hq8tqUbU6irwPVC54YyWj8d2jG93FRBLeyYuqexY
         oZafP4+wum0IWEbknWSEzu+Y2IRTQDif8EfayAPF6t6GTehYKQY5xNSYmwiB23Da2IUM
         ecp/wOrtAXlvuUE0lOyyaJtHikQAWEzszRmg8uWtim3vaK38vN3QDv7bOBRxboGSEjH0
         j1N1Euq/kW4UDrUQAwVbgC4h7d6Tb6r/zBKcrKvFv3F5TlMmwm193tvbZF+OxzpBphvn
         a7aA==
X-Gm-Message-State: AOAM533FgL/OgOI0TKQOAuT15S4zIkJMj30fvBM4Crum23npfQo6Bq4k
        noe0IfdJQjqVvvH0mMOKtnj3fxet6d0F3Q==
X-Google-Smtp-Source: ABdhPJxYxIdc52Bp0o0Ahe/w9FJ5Ua5aZQ04bh8P/sQW+vujEsWzSjDvfwqUCOx/BddITyfiAsRkCw==
X-Received: by 2002:a5e:8d1a:0:b0:653:856f:8936 with SMTP id m26-20020a5e8d1a000000b00653856f8936mr7054314ioj.55.1650896486914;
        Mon, 25 Apr 2022 07:21:26 -0700 (PDT)
Received: from m1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id p6-20020a0566022b0600b0064c59797e67sm8136737iov.46.2022.04.25.07.21.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Apr 2022 07:21:26 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6/6] io_uring: add IORING_SETUP_TASKRUN_FLAG
Date:   Mon, 25 Apr 2022 08:21:18 -0600
Message-Id: <20220425142118.1448840-7-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220425142118.1448840-1-axboe@kernel.dk>
References: <20220425142118.1448840-1-axboe@kernel.dk>
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
 fs/io_uring.c                 | 17 +++++++++++++----
 include/uapi/linux/io_uring.h |  7 +++++++
 2 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 81f5b491c1a5..cab1736919c9 100644
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
 
@@ -11699,10 +11704,14 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
 	 * For SQPOLL, we just need a wakeup, always. For !SQPOLL, if
 	 * COOP_TASKRUN is set, then IPIs are never needed by the app.
 	 */
-	if (ctx->flags & (IORING_SETUP_SQPOLL|IORING_SETUP_COOP_TASKRUN))
+	if (ctx->flags & (IORING_SETUP_SQPOLL|IORING_SETUP_COOP_TASKRUN)) {
 		ctx->notify_method = TWA_SIGNAL_NO_IPI;
-	else
+	} else {
+		ret = -EINVAL;
+		if (ctx->flags & IORING_SETUP_TASKRUN_FLAG)
+			goto err;
 		ctx->notify_method = TWA_SIGNAL;
+	}
 
 	/*
 	 * This is just grabbed for accounting purposes. When a process exits,
@@ -11802,10 +11811,10 @@ static long io_uring_setup(u32 entries, struct io_uring_params __user *params)
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

