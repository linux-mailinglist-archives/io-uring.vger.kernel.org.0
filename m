Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F8006421A8
	for <lists+io-uring@lfdr.de>; Mon,  5 Dec 2022 03:45:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230448AbiLECpn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 4 Dec 2022 21:45:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231139AbiLECpl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 4 Dec 2022 21:45:41 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99008FADD
        for <io-uring@vger.kernel.org>; Sun,  4 Dec 2022 18:45:40 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id h7so10611291wrs.6
        for <io-uring@vger.kernel.org>; Sun, 04 Dec 2022 18:45:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PVLl5MtlPDSyk/qlXtfhxF35haHp/uds22QS3HFvxRc=;
        b=WjUeR/hNPShOaUOXLRC3VFXbDiGBvSfxKHW4xU5d5ILDhgVWi9vdJsENU85B8ioE/L
         nbbMkILUpYMmZm14wKTwweq9DlBC51xm9IKI12Xi79Y9ps2YICwDe3LH8tsId4wLaffX
         MPTNBiYanGN0TLsK9SfUW/FXDH7XHsnTAn/U1rOnBsvonMSsPDysPDTAVV/C2/TgT7FJ
         tsIoXnIKciI5frzVj1cKVXoIvHNVmwHzjNfTnsW8rZftWpRR+DzSCNtG2OLz/Mct29XA
         kRq3bnfPxuVAD2+ponEmA8gniAfiWJ/HSnIl0VtYmL9WAxgOsCiYNAf4rUzP4ZEMYZvB
         8i4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PVLl5MtlPDSyk/qlXtfhxF35haHp/uds22QS3HFvxRc=;
        b=rbPM2VljyEksz2KYXBRZ4BYv/dvLW8KSTPxi6XF9pncslhYetYHs+X8HBlGN45xS/L
         Ff5Ng1N/0DKWgf15CFwUE1jDXlaNFBoiJvjiMl9c6O9D21OSSmae3zMBVoiCN612faQs
         9THfb+7AuLr8oNOk41DrPsA2e4reZd/3rYhtwFpMPCrWXbcFobRDR8trIpCyZGLc6Z7C
         IXQ9LfQcyzhwEWRm8rBd/yS+K+Ct+szun0GUkvSGqF+oBX6vEa1LD62BPLEaO8naUllm
         NvzrZrFg95eo3q1l2kJDmqJTrsJLQFAvfgg9td3wdOJP+fcJk0WEYtifyyqQtV0Jjro8
         8pFg==
X-Gm-Message-State: ANoB5plSKI8hgAcjbbPF3DVG6ZY87mSnjuJp2YPju6H5E//bYP9CXoIn
        EpPA9Ngz4c6i/2QLTD7pkpIXX8R8FDE=
X-Google-Smtp-Source: AA0mqf7WSbVW8VFJRB0pnBHgacUGBAwK3Nopmvzj29ThSTDFUB4haQ13kqAMzYeC1HdK/YiV1ddPvA==
X-Received: by 2002:adf:eec5:0:b0:242:1352:2b62 with SMTP id a5-20020adfeec5000000b0024213522b62mr22565318wrp.370.1670208338832;
        Sun, 04 Dec 2022 18:45:38 -0800 (PST)
Received: from 127.0.0.1localhost (94.196.241.58.threembb.co.uk. [94.196.241.58])
        by smtp.gmail.com with ESMTPSA id t17-20020a05600c41d100b003cf71b1f66csm15281532wmh.0.2022.12.04.18.45.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Dec 2022 18:45:38 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 2/7] io_uring: don't check overflow flush failures
Date:   Mon,  5 Dec 2022 02:44:26 +0000
Message-Id: <e64f98e7468525a2e475243cc8c0e67b2ecb9127.1670207706.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1670207706.git.asml.silence@gmail.com>
References: <cover.1670207706.git.asml.silence@gmail.com>
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

The only way to fail overflowed CQEs flush is for CQ to be fully packed.
There is one place checking for flush failures, i.e. io_cqring_wait(),
but we limit the number to be waited for by the CQ size, so getting a
failure automatically means that we're done with waiting.

Don't check for failures, rarely but they might spuriously fail CQ
waiting with -EBUSY.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 24 ++++++------------------
 1 file changed, 6 insertions(+), 18 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 4721ff6cafaa..7239776a9d4b 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -629,13 +629,12 @@ static void io_cqring_overflow_kill(struct io_ring_ctx *ctx)
 }
 
 /* Returns true if there are no backlogged entries after the flush */
-static bool __io_cqring_overflow_flush(struct io_ring_ctx *ctx)
+static void __io_cqring_overflow_flush(struct io_ring_ctx *ctx)
 {
-	bool all_flushed;
 	size_t cqe_size = sizeof(struct io_uring_cqe);
 
 	if (__io_cqring_events(ctx) == ctx->cq_entries)
-		return false;
+		return;
 
 	if (ctx->flags & IORING_SETUP_CQE32)
 		cqe_size <<= 1;
@@ -654,30 +653,23 @@ static bool __io_cqring_overflow_flush(struct io_ring_ctx *ctx)
 		kfree(ocqe);
 	}
 
-	all_flushed = list_empty(&ctx->cq_overflow_list);
-	if (all_flushed) {
+	if (list_empty(&ctx->cq_overflow_list)) {
 		clear_bit(IO_CHECK_CQ_OVERFLOW_BIT, &ctx->check_cq);
 		atomic_andnot(IORING_SQ_CQ_OVERFLOW, &ctx->rings->sq_flags);
 	}
-
 	io_cq_unlock_post(ctx);
-	return all_flushed;
 }
 
-static bool io_cqring_overflow_flush(struct io_ring_ctx *ctx)
+static void io_cqring_overflow_flush(struct io_ring_ctx *ctx)
 {
-	bool ret = true;
-
 	if (test_bit(IO_CHECK_CQ_OVERFLOW_BIT, &ctx->check_cq)) {
 		/* iopoll syncs against uring_lock, not completion_lock */
 		if (ctx->flags & IORING_SETUP_IOPOLL)
 			mutex_lock(&ctx->uring_lock);
-		ret = __io_cqring_overflow_flush(ctx);
+		__io_cqring_overflow_flush(ctx);
 		if (ctx->flags & IORING_SETUP_IOPOLL)
 			mutex_unlock(&ctx->uring_lock);
 	}
-
-	return ret;
 }
 
 void __io_put_task(struct task_struct *task, int nr)
@@ -2505,11 +2497,7 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 
 	trace_io_uring_cqring_wait(ctx, min_events);
 	do {
-		/* if we can't even flush overflow, don't wait for more */
-		if (!io_cqring_overflow_flush(ctx)) {
-			ret = -EBUSY;
-			break;
-		}
+		io_cqring_overflow_flush(ctx);
 		prepare_to_wait_exclusive(&ctx->cq_wait, &iowq.wq,
 						TASK_INTERRUPTIBLE);
 		ret = io_cqring_wait_schedule(ctx, &iowq, timeout);
-- 
2.38.1

