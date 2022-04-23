Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F4BD50CCA5
	for <lists+io-uring@lfdr.de>; Sat, 23 Apr 2022 19:40:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236641AbiDWRmO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 23 Apr 2022 13:42:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236640AbiDWRmN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 23 Apr 2022 13:42:13 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC3F31C82C7
        for <io-uring@vger.kernel.org>; Sat, 23 Apr 2022 10:39:16 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id c12so17785152plr.6
        for <io-uring@vger.kernel.org>; Sat, 23 Apr 2022 10:39:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YgwECa3rb0Q9+Iub8+Y8nDe9cUIP2MSSg6rBhBX9U0U=;
        b=ZFjTXPEEs8wV+Ld1SrdmBcHNRN5ANc5zjSeAHbAI1xUhtivBqKgIOQOgTZoBETCtUq
         IYbqBL2faqIRWshMocWtpQNEBoPei7dr9X7OwVFptBkeQJcOJz+JDoTh+lcl9thd3GjR
         AI1xyVuERLNvkn5QyJA0cqFSFVzsw9BrviGLESQum72TAuT9ob27jhYRKFOgBceFHPZj
         nd0cRJCOJG6tBpb0Z0bJsQLNQb/YvKaRsiO5h/8Iv+YEsTFpLN5SfNbDLDZ6likuiIrv
         t6bsUSXM+Bm0BtGndz1fy+QqZxB1/W1GjsnV8BLFgndhUhWkH3e8e4Pc6FPf5YfC58KF
         e8wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YgwECa3rb0Q9+Iub8+Y8nDe9cUIP2MSSg6rBhBX9U0U=;
        b=ai4YM4C/nU7GA/FWNCBmNoorrVCkD8s1DSGkaWoCLWLYUCd7QRaLjCYWalSz7iIcnW
         kKSZps0v6Ft8VmZ8kp6a/IX4JX+51lTdkqzQmW+07Pc55d4RDIIC6aXh4uMrbiFvwle2
         CjP8kdvgMNjDynblAta68eB3SH+SjkUIBzdQ3QiOaHjkKAYI8YysA06Vm/7S9YfQe/P0
         19FSW9fdqClhD8hudrpbYi0qaoRerTu8xjurcPs2Vn4l2FZ22iezjdj+68nLbOVEVGJq
         bJpIdjXuUQIn3hzJ75Xtao+ZQpjMc6YIMmn2cAHCYg6jKGX5y+h8pZb0i0eZ6hB3j41W
         LcxQ==
X-Gm-Message-State: AOAM532paPVYhp/bqCkQ00TqjKsESNRLEzfTej9HHJ3awipXqTR2MRxH
        19zGG1jK96Ty8tsOT8Htb+Iv5+9iWXzfHBNd
X-Google-Smtp-Source: ABdhPJzXVrRp1ggpkr7jf2sAnlYPhjf8+TjeQMr2d7M9Ug0TE2VY77deikzUHt+vxo6j3SISfi0Acg==
X-Received: by 2002:a17:902:d2c7:b0:15a:218a:432c with SMTP id n7-20020a170902d2c700b0015a218a432cmr10125794plc.20.1650735556079;
        Sat, 23 Apr 2022 10:39:16 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e16-20020a63ee10000000b0039d1c7e80bcsm5198854pgi.75.2022.04.23.10.39.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Apr 2022 10:39:15 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/5] io_uring: serialize ctx->rings->sq_flags with atomic_or/and
Date:   Sat, 23 Apr 2022 11:39:08 -0600
Message-Id: <20220423173911.651905-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220423173911.651905-1-axboe@kernel.dk>
References: <20220423173911.651905-1-axboe@kernel.dk>
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
index 626bf840bed2..4fe3a53187cf 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -169,7 +169,7 @@ struct io_rings {
 	 * The application needs a full memory barrier before checking
 	 * for IORING_SQ_NEED_WAKEUP after updating the sq tail.
 	 */
-	u32			sq_flags;
+	atomic_t		sq_flags;
 	/*
 	 * Runtime CQ flags
 	 *
@@ -2030,8 +2030,7 @@ static bool __io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force)
 	all_flushed = list_empty(&ctx->cq_overflow_list);
 	if (all_flushed) {
 		clear_bit(IO_CHECK_CQ_OVERFLOW_BIT, &ctx->check_cq);
-		WRITE_ONCE(ctx->rings->sq_flags,
-			   ctx->rings->sq_flags & ~IORING_SQ_CQ_OVERFLOW);
+		atomic_andnot(IORING_SQ_CQ_OVERFLOW, &ctx->rings->sq_flags);
 	}
 
 	io_commit_cqring(ctx);
@@ -2125,8 +2124,7 @@ static bool io_cqring_event_overflow(struct io_ring_ctx *ctx, u64 user_data,
 	}
 	if (list_empty(&ctx->cq_overflow_list)) {
 		set_bit(IO_CHECK_CQ_OVERFLOW_BIT, &ctx->check_cq);
-		WRITE_ONCE(ctx->rings->sq_flags,
-			   ctx->rings->sq_flags | IORING_SQ_CQ_OVERFLOW);
+		atomic_or(IORING_SQ_CQ_OVERFLOW, &ctx->rings->sq_flags);
 
 	}
 	ocqe->cqe.user_data = user_data;
@@ -8105,23 +8103,6 @@ static inline bool io_sqd_events_pending(struct io_sq_data *sqd)
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
@@ -8237,8 +8218,8 @@ static int io_sq_thread(void *data)
 			bool needs_sched = true;
 
 			list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
-				io_ring_set_wakeup_flag(ctx);
-
+				atomic_or(IORING_SQ_NEED_WAKEUP,
+						&ctx->rings->sq_flags);
 				if ((ctx->flags & IORING_SETUP_IOPOLL) &&
 				    !wq_list_empty(&ctx->iopoll_list)) {
 					needs_sched = false;
@@ -8263,7 +8244,8 @@ static int io_sq_thread(void *data)
 				mutex_lock(&sqd->lock);
 			}
 			list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
-				io_ring_clear_wakeup_flag(ctx);
+				atomic_andnot(IORING_SQ_NEED_WAKEUP,
+						&ctx->rings->sq_flags);
 		}
 
 		finish_wait(&sqd->wait, &wait);
@@ -8273,7 +8255,7 @@ static int io_sq_thread(void *data)
 	io_uring_cancel_generic(true, sqd);
 	sqd->thread = NULL;
 	list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
-		io_ring_set_wakeup_flag(ctx);
+		atomic_or(IORING_SQ_NEED_WAKEUP, &ctx->rings->sq_flags);
 	io_run_task_work();
 	mutex_unlock(&sqd->lock);
 
@@ -12026,6 +12008,8 @@ static int __init io_uring_init(void)
 	BUILD_BUG_ON(ARRAY_SIZE(io_op_defs) != IORING_OP_LAST);
 	BUILD_BUG_ON(__REQ_F_LAST_BIT > 8 * sizeof(int));
 
+	BUILD_BUG_ON(sizeof(atomic_t) != sizeof(u32));
+
 	req_cachep = KMEM_CACHE(io_kiocb, SLAB_HWCACHE_ALIGN | SLAB_PANIC |
 				SLAB_ACCOUNT);
 	return 0;
-- 
2.35.1

