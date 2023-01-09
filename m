Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0830662907
	for <lists+io-uring@lfdr.de>; Mon,  9 Jan 2023 15:51:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230082AbjAIOvf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Jan 2023 09:51:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234615AbjAIOvP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Jan 2023 09:51:15 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0B753E84B
        for <io-uring@vger.kernel.org>; Mon,  9 Jan 2023 06:47:39 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id tz12so20677652ejc.9
        for <io-uring@vger.kernel.org>; Mon, 09 Jan 2023 06:47:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kOPEVl8PMOwFRDDJfm+ptrMLsP3nfY1Nz8mblxqtLUE=;
        b=pCfDpHqPJWyRpPxWWsd5dK/6ivdLlC4j0DOVAMKqm/QaayY/IJRY0SvvHlZSsoZJf2
         SzILCk+hSNN9wLDRLBgYabn49ah3JXvSp6uYQMLCMt7beBsXWQe7KHLvSCAfXMDkmlXA
         bf+03ICJqwn8uRGwHUEgDEPOLqXr5wLMiu8L/tTv/jsRkVtdiwr6+qrO/hxa8HzCwzrL
         yAmmUSikRjOyW4QNtJPvL+j79vhRWT2ZjgCPl4M83XCyP4GlrTFggxAlRuYSFgZ5ke2j
         2yga7MHnTMI1MKdxCOIm4yDFmpwKyyaE0I1Fypxk0+g6aPPylpV92cCNik1wnUJg18lI
         eIWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kOPEVl8PMOwFRDDJfm+ptrMLsP3nfY1Nz8mblxqtLUE=;
        b=ZoaX7AIbeiI9eKKMznrSEJ6ZzJJfkwf8L9cMmILtHp+T/HtT9VkUT3gq2y+XFNMCyk
         1h1HHTWglXHuAF2jsS6xNjTXktOhRQQYi2GbJvCvxxoYsqduUBDvHO3wgE2wamOfAQri
         CBnzyVNm7uKA2mEh+t53A+bBBHv63CErzPJKAmk0gIoz811B+srLhhkHRNiot0rAnx2C
         61hPBmDxs51SeRLiW2vltywah3HYYYcRuO6VpPhnK1naq1aIPoFFDCzo4Vj1ywNxAcvu
         P94eCE3rCJS35rbKlPwna2TzfTMDttv914jHF3nCd3EWRLMbGzyJWgjbptj8VjmI0PPv
         YuYQ==
X-Gm-Message-State: AFqh2kq0xIP6zcWSGSsturj0ootFM4RCP0kUrNpHPUm+23WWik/cVIx9
        1PA1waUeYun5Rle7A+bgzhjDmlwZvnY=
X-Google-Smtp-Source: AMrXdXtvUWJr+ZZPGbVIiCMLrfgP1bRsSxdE/B5+US1Re47M37nNtVUaZ8pjf/woKmc7rlxZki6SKg==
X-Received: by 2002:a17:907:9d19:b0:7b9:f9d8:9554 with SMTP id kt25-20020a1709079d1900b007b9f9d89554mr3705810ejc.40.1673275658223;
        Mon, 09 Jan 2023 06:47:38 -0800 (PST)
Received: from 127.0.0.1localhost (188.29.102.7.threembb.co.uk. [188.29.102.7])
        by smtp.gmail.com with ESMTPSA id x11-20020a170906b08b00b0084c62b7b7d8sm3839578ejy.187.2023.01.09.06.47.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jan 2023 06:47:37 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH v3 09/11] io_uring: waitqueue-less cq waiting
Date:   Mon,  9 Jan 2023 14:46:11 +0000
Message-Id: <103d174d35d919d4cb0922d8a9c93a8f0c35f74a.1673274244.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1673274244.git.asml.silence@gmail.com>
References: <cover.1673274244.git.asml.silence@gmail.com>
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

With DEFER_TASKRUN only ctx->submitter_task might be waiting for CQEs,
we can use this to optimise io_cqring_wait(). Replace ->cq_wait
waitqueue with waking the task directly.

It works but misses an important optimisation covered by the following
patch, so this patch without follow ups might hurt performance.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 0dabd0f3271f..62d879b14873 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1263,7 +1263,7 @@ static void io_req_local_work_add(struct io_kiocb *req)
 		percpu_ref_put(&ctx->refs);
 		return;
 	}
-	/* need it for the following io_cqring_wake() */
+	/* needed for the following wake up */
 	smp_mb__after_atomic();
 
 	if (unlikely(atomic_read(&req->task->io_uring->in_idle))) {
@@ -1274,10 +1274,9 @@ static void io_req_local_work_add(struct io_kiocb *req)
 
 	if (ctx->flags & IORING_SETUP_TASKRUN_FLAG)
 		atomic_or(IORING_SQ_TASKRUN, &ctx->rings->sq_flags);
-
 	if (ctx->has_evfd)
 		io_eventfd_signal(ctx);
-	__io_cqring_wake(ctx);
+	wake_up_state(ctx->submitter_task, TASK_INTERRUPTIBLE);
 	percpu_ref_put(&ctx->refs);
 }
 
@@ -2578,12 +2577,17 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 	do {
 		unsigned long check_cq;
 
-		prepare_to_wait_exclusive(&ctx->cq_wait, &iowq.wq,
-						TASK_INTERRUPTIBLE);
+		if (ctx->flags & IORING_SETUP_DEFER_TASKRUN) {
+			set_current_state(TASK_INTERRUPTIBLE);
+		} else {
+			prepare_to_wait_exclusive(&ctx->cq_wait, &iowq.wq,
+							TASK_INTERRUPTIBLE);
+		}
+
 		ret = io_cqring_wait_schedule(ctx, &iowq);
+		__set_current_state(TASK_RUNNING);
 		if (ret < 0)
 			break;
-		__set_current_state(TASK_RUNNING);
 		/*
 		 * Run task_work after scheduling and before io_should_wake().
 		 * If we got woken because of task_work being processed, run it
@@ -2611,7 +2615,8 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 		cond_resched();
 	} while (1);
 
-	finish_wait(&ctx->cq_wait, &iowq.wq);
+	if (!(ctx->flags & IORING_SETUP_DEFER_TASKRUN))
+		finish_wait(&ctx->cq_wait, &iowq.wq);
 	restore_saved_sigmask_unless(ret == -EINTR);
 
 	return READ_ONCE(rings->cq.head) == READ_ONCE(rings->cq.tail) ? ret : 0;
-- 
2.38.1

