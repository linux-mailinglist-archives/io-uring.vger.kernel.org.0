Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9632956BADD
	for <lists+io-uring@lfdr.de>; Fri,  8 Jul 2022 15:34:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238177AbiGHNae (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 8 Jul 2022 09:30:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238191AbiGHNab (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 8 Jul 2022 09:30:31 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54DCE3123C
        for <io-uring@vger.kernel.org>; Fri,  8 Jul 2022 06:30:29 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id v4-20020a17090abb8400b001ef966652a3so1914470pjr.4
        for <io-uring@vger.kernel.org>; Fri, 08 Jul 2022 06:30:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=514W5daMKyJ+4ViVWbSkMV64Or+GQJ+btAt6Ij/vv3k=;
        b=pOyR0bXBUj9iWl92rG+6vvatiVCvBjC8E13zq3+ocOoO/bdXskQC9JUW4io2pkGbzd
         2fK3WWiB07rEDc6FNtTNN+oiebO8UJ5UzQVhgsyFAgroUe5SP63Z5On0tcbH9SbZxj3s
         9YazXHlIHwXOoJd6+eApwEAB5k4Bb0TgSI6a86/DgexzjfNCNaqMez9/TrFHelsHkL5t
         8pIAFg3j85s2tjudQG2cAHIvPniegI1QRaj0KMcveoBkM1b9LSmN0yz5O7zgBNaAy9q+
         e0ueXfCI5foHTHODpk+tqpzMvgMJkbbT3d4ovpxjLIDg4Yq0Qr+r6w0D/cQ/+CjL906f
         uS/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=514W5daMKyJ+4ViVWbSkMV64Or+GQJ+btAt6Ij/vv3k=;
        b=QZqioxxgtPiX40V0U3Kfcmc+F8jau8Y050dWble9/Vi3ysovmj6UuQ+0o7kok7kJUU
         GnMNYHeVaS7WIbnKvItxtNXzV5hWfvznVYfpcXzUXOhV/pwTAYj4Dj2q1JDQgEUM2kek
         LMAMySr9hlveTSKWY2JmUtEAdphlKGq35YHlGpnDlcdiGM1lvT+JaM+qRoaiozQN/j2k
         U0mSsiF5SDL9OC5bGP7M7XduiKSC1vDAkJWrXODOJGu/vy/vIekETE0H1FbpjD2WoEB3
         J3bJWy/MtTOo7Fu4+zdZzZ59B3MdsVHZVvtHYeEEtn6OrnArA75JUM76LZBJJv4TWRvM
         GLkg==
X-Gm-Message-State: AJIora+rW+rqh2aoU+57qPay6T23qDfPsdInFpYq/4Zinbh2ZfRITKJv
        TgHQLTdEJd1VScBEzQcQwqZgmllnllzqWg==
X-Google-Smtp-Source: AGRyM1tCPoDp7jQwRdrDMtcZAK+PaLE84eVnM6Hekyc463PwuoiCGwWCHhNmzrXW3qOQBlIt3A3hyg==
X-Received: by 2002:a17:902:7c06:b0:16a:755f:86dd with SMTP id x6-20020a1709027c0600b0016a755f86ddmr3719566pll.82.1657287028613;
        Fri, 08 Jul 2022 06:30:28 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id a16-20020aa794b0000000b0052844157f09sm3800502pfl.51.2022.07.08.06.30.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jul 2022 06:30:28 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, dylany@fb.com, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/4] io_uring: move apoll cache to poll.c
Date:   Fri,  8 Jul 2022 07:30:19 -0600
Message-Id: <20220708133022.383961-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220708133022.383961-1-axboe@kernel.dk>
References: <20220708133022.383961-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is where it's used, move the flush handler in there.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 12 ------------
 io_uring/poll.c     | 12 ++++++++++++
 io_uring/poll.h     |  2 ++
 3 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index caf979cd4327..4d1ce58b015e 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2445,18 +2445,6 @@ static void io_req_caches_free(struct io_ring_ctx *ctx)
 	mutex_unlock(&ctx->uring_lock);
 }
 
-static void io_flush_apoll_cache(struct io_ring_ctx *ctx)
-{
-	struct async_poll *apoll;
-
-	while (!list_empty(&ctx->apoll_cache)) {
-		apoll = list_first_entry(&ctx->apoll_cache, struct async_poll,
-						poll.wait.entry);
-		list_del(&apoll->poll.wait.entry);
-		kfree(apoll);
-	}
-}
-
 static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 {
 	io_sq_thread_finish(ctx);
diff --git a/io_uring/poll.c b/io_uring/poll.c
index 76592063abe7..052fcb647208 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -959,3 +959,15 @@ int io_poll_remove(struct io_kiocb *req, unsigned int issue_flags)
 	io_req_set_res(req, ret, 0);
 	return IOU_OK;
 }
+
+void io_flush_apoll_cache(struct io_ring_ctx *ctx)
+{
+	struct async_poll *apoll;
+
+	while (!list_empty(&ctx->apoll_cache)) {
+		apoll = list_first_entry(&ctx->apoll_cache, struct async_poll,
+						poll.wait.entry);
+		list_del(&apoll->poll.wait.entry);
+		kfree(apoll);
+	}
+}
diff --git a/io_uring/poll.h b/io_uring/poll.h
index c40673d7da01..95f192c7babb 100644
--- a/io_uring/poll.h
+++ b/io_uring/poll.h
@@ -30,3 +30,5 @@ int io_poll_cancel(struct io_ring_ctx *ctx, struct io_cancel_data *cd,
 int io_arm_poll_handler(struct io_kiocb *req, unsigned issue_flags);
 bool io_poll_remove_all(struct io_ring_ctx *ctx, struct task_struct *tsk,
 			bool cancel_all);
+
+void io_flush_apoll_cache(struct io_ring_ctx *ctx);
-- 
2.35.1

