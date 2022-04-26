Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D86F50EE47
	for <lists+io-uring@lfdr.de>; Tue, 26 Apr 2022 03:49:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241454AbiDZBwT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 Apr 2022 21:52:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241421AbiDZBwQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Apr 2022 21:52:16 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EBA4120104
        for <io-uring@vger.kernel.org>; Mon, 25 Apr 2022 18:49:10 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id m14-20020a17090a34ce00b001d5fe250e23so1103965pjf.3
        for <io-uring@vger.kernel.org>; Mon, 25 Apr 2022 18:49:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gBB3rIq31HTt0a91neDmCOiC54dYmIJQc4bKJW/WfqE=;
        b=zq40o1FjuWETZKF1Jl5ugBtEI0jhOAe4OyqWK8j7WxJ4/gQC7fmMPPVbg7a9qL8rzL
         KzvtCa6mZiShxeDp2lszZApguDyjMFb2C/M3v5YrZqZ9jWgN4sH8GWoA9oSnpZWrVWpF
         rMHMnGJDfUIjXNnkKa46htfRb+wvSKxH/zciZd59TOBW5k+IqIe7jEQYmyBtlxsTU6vC
         dsCTY37LLOZUY2gNQzlGiYnQYt5nXLj+v4eS/E1/ix3vfZRzpF6C3MJ6YVXKSoiSSgw/
         77f73iMDMYUMcUKtqpw2UF2WxBIIa02LhV+VaXHm6X4sOmDxBAoeqHyGaUm1zAtjCc/M
         YwEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gBB3rIq31HTt0a91neDmCOiC54dYmIJQc4bKJW/WfqE=;
        b=1ppAPzcZLQ8jr27gzu4Cn59konx2m4Z/tX61MxX4hmqHmi2YAjcgMKx7jS5XnDsaCt
         9A7Km5vv8b1TqWIbDTBzZJMrcL5tO/DKhKdrMCRCFY6YaY4Y0x+l+96cTG16ofLNciTI
         cXnM3Hi8kuDK9Jr+ClYXYaHMI4+WJ/kVA6VwVCMN1FldaFvWzJT0XywKgETdkpbnQLfh
         dB02DSegICZBbHe/IDHvU97E0is0GjWB4htAGWUvz9P+L0HZc1wq0NCeyHEhrxhZlfYE
         WnSUT3RFQ1ojcpZO92p7vpKXqouU+e0kjM6LDIs+Mmiz8p3yQ6835GgFybS7XsTr3hUr
         UP6A==
X-Gm-Message-State: AOAM5333/PphzuFewuB7stRZllY4VpLWk1vrfSQ8xwdQv90gttG+Vg4y
        wj0D3vLQu4wowrjN7IeovqRg3eub0ZqSTP4x
X-Google-Smtp-Source: ABdhPJzDF/NVY8bcDA3acRoRtKkdzWEL53oYvPFkxLPG8y3S0Ndoji8oVL/sggEQldnwYu15juP8NQ==
X-Received: by 2002:a17:90a:ac15:b0:1d9:839d:3fac with SMTP id o21-20020a17090aac1500b001d9839d3facmr7068657pjq.195.1650937749254;
        Mon, 25 Apr 2022 18:49:09 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id i23-20020a056a00225700b0050d38d0f58dsm6076149pfu.213.2022.04.25.18.49.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Apr 2022 18:49:08 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/6] io_uring: serialize ctx->rings->sq_flags with atomic_or/and
Date:   Mon, 25 Apr 2022 19:49:00 -0600
Message-Id: <20220426014904.60384-3-axboe@kernel.dk>
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

Rather than require ctx->completion_lock for ensuring that we don't
clobber the flags, use the atomic bitop helpers instead. This removes
the need to grab the completion_lock, in preparation for needing to set
or clear sq_flags when we don't know the status of this lock.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 36 ++++++++++--------------------------
 1 file changed, 10 insertions(+), 26 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index bf95ef9240e5..511b52e4b9fd 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -170,7 +170,7 @@ struct io_rings {
 	 * The application needs a full memory barrier before checking
 	 * for IORING_SQ_NEED_WAKEUP after updating the sq tail.
 	 */
-	u32			sq_flags;
+	atomic_t		sq_flags;
 	/*
 	 * Runtime CQ flags
 	 *
@@ -2060,8 +2060,7 @@ static bool __io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force)
 	all_flushed = list_empty(&ctx->cq_overflow_list);
 	if (all_flushed) {
 		clear_bit(IO_CHECK_CQ_OVERFLOW_BIT, &ctx->check_cq);
-		WRITE_ONCE(ctx->rings->sq_flags,
-			   ctx->rings->sq_flags & ~IORING_SQ_CQ_OVERFLOW);
+		atomic_andnot(IORING_SQ_CQ_OVERFLOW, &ctx->rings->sq_flags);
 	}
 
 	io_commit_cqring(ctx);
@@ -2155,8 +2154,7 @@ static bool io_cqring_event_overflow(struct io_ring_ctx *ctx, u64 user_data,
 	}
 	if (list_empty(&ctx->cq_overflow_list)) {
 		set_bit(IO_CHECK_CQ_OVERFLOW_BIT, &ctx->check_cq);
-		WRITE_ONCE(ctx->rings->sq_flags,
-			   ctx->rings->sq_flags | IORING_SQ_CQ_OVERFLOW);
+		atomic_or(IORING_SQ_CQ_OVERFLOW, &ctx->rings->sq_flags);
 
 	}
 	ocqe->cqe.user_data = user_data;
@@ -8477,23 +8475,6 @@ static inline bool io_sqd_events_pending(struct io_sq_data *sqd)
 	return READ_ONCE(sqd->state);
 }
 
-static inline void io_ring_set_wakeup_flag(struct io_ring_ctx *ctx)
-{
-	/* Tell userspace we may need a wakeup call */
-	spin_lock(&ctx->completion_lock);
-	WRITE_ONCE(ctx->rings->sq_flags,
-		   ctx->rings->sq_flags | IORING_SQ_NEED_WAKEUP);
-	spin_unlock(&ctx->completion_lock);
-}
-
-static inline void io_ring_clear_wakeup_flag(struct io_ring_ctx *ctx)
-{
-	spin_lock(&ctx->completion_lock);
-	WRITE_ONCE(ctx->rings->sq_flags,
-		   ctx->rings->sq_flags & ~IORING_SQ_NEED_WAKEUP);
-	spin_unlock(&ctx->completion_lock);
-}
-
 static int __io_sq_thread(struct io_ring_ctx *ctx, bool cap_entries)
 {
 	unsigned int to_submit;
@@ -8609,8 +8590,8 @@ static int io_sq_thread(void *data)
 			bool needs_sched = true;
 
 			list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
-				io_ring_set_wakeup_flag(ctx);
-
+				atomic_or(IORING_SQ_NEED_WAKEUP,
+						&ctx->rings->sq_flags);
 				if ((ctx->flags & IORING_SETUP_IOPOLL) &&
 				    !wq_list_empty(&ctx->iopoll_list)) {
 					needs_sched = false;
@@ -8635,7 +8616,8 @@ static int io_sq_thread(void *data)
 				mutex_lock(&sqd->lock);
 			}
 			list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
-				io_ring_clear_wakeup_flag(ctx);
+				atomic_andnot(IORING_SQ_NEED_WAKEUP,
+						&ctx->rings->sq_flags);
 		}
 
 		finish_wait(&sqd->wait, &wait);
@@ -8645,7 +8627,7 @@ static int io_sq_thread(void *data)
 	io_uring_cancel_generic(true, sqd);
 	sqd->thread = NULL;
 	list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
-		io_ring_set_wakeup_flag(ctx);
+		atomic_or(IORING_SQ_NEED_WAKEUP, &ctx->rings->sq_flags);
 	io_run_task_work();
 	mutex_unlock(&sqd->lock);
 
@@ -12399,6 +12381,8 @@ static int __init io_uring_init(void)
 	BUILD_BUG_ON(ARRAY_SIZE(io_op_defs) != IORING_OP_LAST);
 	BUILD_BUG_ON(__REQ_F_LAST_BIT > 8 * sizeof(int));
 
+	BUILD_BUG_ON(sizeof(atomic_t) != sizeof(u32));
+
 	req_cachep = KMEM_CACHE(io_kiocb, SLAB_HWCACHE_ALIGN | SLAB_PANIC |
 				SLAB_ACCOUNT);
 	return 0;
-- 
2.35.1

