Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 520C65E7C61
	for <lists+io-uring@lfdr.de>; Fri, 23 Sep 2022 15:56:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230165AbiIWNz5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 23 Sep 2022 09:55:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiIWNz5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 23 Sep 2022 09:55:57 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1060A13D1E6
        for <io-uring@vger.kernel.org>; Fri, 23 Sep 2022 06:55:56 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id c192-20020a1c35c9000000b003b51339d350so958999wma.3
        for <io-uring@vger.kernel.org>; Fri, 23 Sep 2022 06:55:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=QCneN8Ifu30mD0TTGs6kJToR0dmdzG1pvPok6l1mx40=;
        b=k9hUJ72a8xbM1KhTRkoLwEUPpnDfzvrja+IWuGp+9MPqpOG0ZPWpfxCiWgIfydwn3m
         R0u60+BgJWcnioqnFwh/cb+kV6KzrfBeLDE2EyLF7WGu6YkOLgKQFo3M3mgESaU01/PJ
         Z6sfgSCEXW1PsFMPThk7Z9QXpbxC8D4maih3mxjhdYWTN2uFyJiAoikplf8ABLOHZaJ5
         49UwM4EsAhHi1Qa11sb1eah/bxm+JnFaRklUjeSjmDfEJp3LIwDoLrxASOjxdL0p0qkf
         jD4b8Osymoo57AZXD7B7ilf23/ShVz6dm6H9B7Wz/ld0dbMWf8kKSoSV4oHJpgorH2Df
         xCPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=QCneN8Ifu30mD0TTGs6kJToR0dmdzG1pvPok6l1mx40=;
        b=DHLQtPRiJYKjyqfY6jl/w80lr2V4R5zCvcJ0wlATiNDYCyQH4ugVpmZBpB2GJCGy/k
         zgRhK8Giil7wZWLGCUD0W1+UZoUpPOw9yrawdj4cbGC925TXhv7JJvTvrkbAk2TBh8Gh
         rAVUmi1busMBOZr3O/mk+q7rx8SOJzzejqdcsnSkIFlSIQmZNvfZB1VYgP9wiufoDud5
         5B7wJ+t5rwfIw3T0u/K4kNOSwgc48k4jIxtRthFG2l3dE/Tp6lCWwDWwZye7tGdMsf+y
         bnIxcK+hzZ71+dj1CN3B6lZiqzXGW32SKKOSsqcG7qiTA5LPcUIxKa2inHO8ByRBARwR
         Q6KQ==
X-Gm-Message-State: ACrzQf22gQOAGVv2oJ/3KQDpdha03SWzegVbS3hMmQd5lN62NFFhnZBK
        bbIIZTON74RB0toJFK2ziqABnfoWOWU=
X-Google-Smtp-Source: AMsMyM74+zCRVQ6IUsXCjFASUEeFxggoyPBVKLSagCeFO2R3BRLonCkkIvDHC8z7v8FhdWwVNjvYHQ==
X-Received: by 2002:a05:600c:21c3:b0:3b4:7e47:e3a with SMTP id x3-20020a05600c21c300b003b47e470e3amr5964678wmj.167.1663941354214;
        Fri, 23 Sep 2022 06:55:54 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.201.74.threembb.co.uk. [188.28.201.74])
        by smtp.gmail.com with ESMTPSA id bn27-20020a056000061b00b0022762b0e2a2sm8372686wrb.6.2022.09.23.06.55.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Sep 2022 06:55:53 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH for-next] io_uring: fix CQE reordering
Date:   Fri, 23 Sep 2022 14:53:25 +0100
Message-Id: <ec3bc55687b0768bbe20fb62d7d06cfced7d7e70.1663892031.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.2
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

Overflowing CQEs may result in reordeing, which is buggy in case of
links, F_MORE and so.

Reported-by: Dylan Yudaken <dylany@fb.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 12 ++++++++++--
 io_uring/io_uring.h | 12 +++++++++---
 2 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index f359e24b46c3..62d1f55fde55 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -609,7 +609,7 @@ static bool __io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force)
 
 	io_cq_lock(ctx);
 	while (!list_empty(&ctx->cq_overflow_list)) {
-		struct io_uring_cqe *cqe = io_get_cqe(ctx);
+		struct io_uring_cqe *cqe = io_get_cqe_overflow(ctx, true);
 		struct io_overflow_cqe *ocqe;
 
 		if (!cqe && !force)
@@ -736,12 +736,19 @@ bool io_req_cqe_overflow(struct io_kiocb *req)
  * control dependency is enough as we're using WRITE_ONCE to
  * fill the cq entry
  */
-struct io_uring_cqe *__io_get_cqe(struct io_ring_ctx *ctx)
+struct io_uring_cqe *__io_get_cqe(struct io_ring_ctx *ctx, bool overflow)
 {
 	struct io_rings *rings = ctx->rings;
 	unsigned int off = ctx->cached_cq_tail & (ctx->cq_entries - 1);
 	unsigned int free, queued, len;
 
+	/*
+	 * Posting into the CQ when there are pending overflowed CQEs may break
+	 * ordering guarantees, which will affect links, F_MORE users and more.
+	 * Force overflow the completion.
+	 */
+	if (!overflow && (ctx->check_cq & BIT(IO_CHECK_CQ_OVERFLOW_BIT)))
+		return NULL;
 
 	/* userspace may cheat modifying the tail, be safe and do min */
 	queued = min(__io_cqring_events(ctx), ctx->cq_entries);
@@ -2394,6 +2401,7 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 		if (ret < 0)
 			return ret;
 		io_cqring_overflow_flush(ctx);
+
 		if (io_cqring_events(ctx) >= min_events)
 			return 0;
 	} while (ret > 0);
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index d38173b9ac19..177bd55357d7 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -24,7 +24,7 @@ enum {
 	IOU_STOP_MULTISHOT	= -ECANCELED,
 };
 
-struct io_uring_cqe *__io_get_cqe(struct io_ring_ctx *ctx);
+struct io_uring_cqe *__io_get_cqe(struct io_ring_ctx *ctx, bool overflow);
 bool io_req_cqe_overflow(struct io_kiocb *req);
 int io_run_task_work_sig(struct io_ring_ctx *ctx);
 int __io_run_local_work(struct io_ring_ctx *ctx, bool locked);
@@ -93,7 +93,8 @@ static inline void io_cq_lock(struct io_ring_ctx *ctx)
 
 void io_cq_unlock_post(struct io_ring_ctx *ctx);
 
-static inline struct io_uring_cqe *io_get_cqe(struct io_ring_ctx *ctx)
+static inline struct io_uring_cqe *io_get_cqe_overflow(struct io_ring_ctx *ctx,
+						       bool overflow)
 {
 	if (likely(ctx->cqe_cached < ctx->cqe_sentinel)) {
 		struct io_uring_cqe *cqe = ctx->cqe_cached;
@@ -105,7 +106,12 @@ static inline struct io_uring_cqe *io_get_cqe(struct io_ring_ctx *ctx)
 		return cqe;
 	}
 
-	return __io_get_cqe(ctx);
+	return __io_get_cqe(ctx, overflow);
+}
+
+static inline struct io_uring_cqe *io_get_cqe(struct io_ring_ctx *ctx)
+{
+	return io_get_cqe_overflow(ctx, false);
 }
 
 static inline bool __io_fill_cqe_req(struct io_ring_ctx *ctx,
-- 
2.37.2

