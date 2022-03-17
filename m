Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDA734DBCD6
	for <lists+io-uring@lfdr.de>; Thu, 17 Mar 2022 03:05:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358428AbiCQCGW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Mar 2022 22:06:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358440AbiCQCGU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Mar 2022 22:06:20 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C52951EC6C
        for <io-uring@vger.kernel.org>; Wed, 16 Mar 2022 19:05:03 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id bi12so7881400ejb.3
        for <io-uring@vger.kernel.org>; Wed, 16 Mar 2022 19:05:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=riUb1Yr/VagyEBFpk/eX0rskGRzA6V3WF2FuDDfzZfk=;
        b=S/uZB38wfGvoS3thp5yXvMENH0aa10q1W92+iPD8uvA96FzUOsZnPu6TlgO8cSNyYp
         /d5yi98vHLtY1sDItkB5Qkk8pE7JPFH8QILCXihsnSyMm3/CgGx7m/cc0G0ewsqcCEsk
         NEvTvUiJqOVS/Xo0ix6ClSsiGUUP2T2DRRgDSIfDkmoHe+byax96fBOMFCVnxEcWCdht
         eghZAS4GRVwvDZcuvdLwXQtf3rUxZTgnBrs6CGeouU1XjBsu6cLd+AIO6AM2NH4f8qu4
         88TfTnB2D9Pj4sJm7jxnjcU6lee4kgtpzuahOHmspLdvcZ/Q++VIWYz1QawOUt962r9W
         dLAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=riUb1Yr/VagyEBFpk/eX0rskGRzA6V3WF2FuDDfzZfk=;
        b=RZqMQQTXoMxx/DJggbLcomvMuOrSIFHL3Um9AOr96wQz+I0cyTvKbZQbEtgz3g8N4N
         OtSTdKU6jnDQxm5bOiFJEPDLKOcS3s8NuY9ShLkf53qYxwCP5EeaQRJu/KI7KdESev+f
         1zqOQHJUtvUKeHPYZK5FmoNVOcrqcgL7IGVMwqJE9f9pxBpGM2COdnf77Q3D61RlvAks
         DvtTD5G5unBITTBkkdrIp7eeykS/6a9FVcKxyDlZ9/LCz8NMRVDPVw7oPMpOruYe49iX
         mKhp1IiPKINgUEWdy441n8InOKWxKcC+FgDCQfraFxbxL1n5sUoIY/sEbIdEtKASyHOU
         KRQw==
X-Gm-Message-State: AOAM531ZpGygWyKI1PR0Hey2Nw39i9OMxTViUtEOn3a5gH/NOJH+o5nA
        6oLiNdQJr/+QTXaXz9NIteNYS53Y1MlYfA==
X-Google-Smtp-Source: ABdhPJx8HPYTfn9i9Rok4m2X9/WR96y2gQNr8ud/qC8mayF6wtnKH/23qnJwnN/e2lFZxJt0NsHTTw==
X-Received: by 2002:a17:907:7da9:b0:6da:866a:3c59 with SMTP id oz41-20020a1709077da900b006da866a3c59mr2325642ejc.13.1647482702013;
        Wed, 16 Mar 2022 19:05:02 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.255.234.67])
        by smtp.gmail.com with ESMTPSA id b26-20020aa7df9a000000b00416b3005c4bsm1876048edy.46.2022.03.16.19.05.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 19:05:01 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 6/7] io_uring: thin down io_commit_cqring()
Date:   Thu, 17 Mar 2022 02:03:41 +0000
Message-Id: <ec4e81fd720d3bc7bca8cb9152e080dad1a052f1.1647481208.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1647481208.git.asml.silence@gmail.com>
References: <cover.1647481208.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_commit_cqring() is currently always under spinlock section, so it's
always better to keep it as slim as possible. Move
__io_commit_cqring_flush() out of it into ev_posted*(). If fast checks
do fail and this post-processing is required, we'll reacquire
->completion_lock, which is fine as we don't care about performance of
draining and offset timeouts.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5a87e0622ecb..c75a5767f58d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1771,20 +1771,21 @@ static __cold void io_flush_timeouts(struct io_ring_ctx *ctx)
 	spin_unlock_irq(&ctx->timeout_lock);
 }
 
+static inline void io_commit_cqring(struct io_ring_ctx *ctx)
+{
+	/* order cqe stores with ring update */
+	smp_store_release(&ctx->rings->cq.tail, ctx->cached_cq_tail);
+}
+
 static __cold void __io_commit_cqring_flush(struct io_ring_ctx *ctx)
 {
+	spin_lock(&ctx->completion_lock);
 	if (ctx->off_timeout_used)
 		io_flush_timeouts(ctx);
 	if (ctx->drain_active)
 		io_queue_deferred(ctx);
-}
-
-static inline void io_commit_cqring(struct io_ring_ctx *ctx)
-{
-	if (unlikely(ctx->off_timeout_used || ctx->drain_active))
-		__io_commit_cqring_flush(ctx);
-	/* order cqe stores with ring update */
-	smp_store_release(&ctx->rings->cq.tail, ctx->cached_cq_tail);
+	io_commit_cqring(ctx);
+	spin_unlock(&ctx->completion_lock);
 }
 
 static inline bool io_sqring_full(struct io_ring_ctx *ctx)
@@ -1852,6 +1853,9 @@ static void io_eventfd_signal(struct io_ring_ctx *ctx)
  */
 static inline void io_cqring_ev_posted(struct io_ring_ctx *ctx)
 {
+	if (unlikely(ctx->off_timeout_used || ctx->drain_active))
+		__io_commit_cqring_flush(ctx);
+
 	/*
 	 * wake_up_all() may seem excessive, but io_wake_function() and
 	 * io_should_wake() handle the termination of the loop and only
@@ -1865,6 +1869,9 @@ static inline void io_cqring_ev_posted(struct io_ring_ctx *ctx)
 
 static void io_cqring_ev_posted_iopoll(struct io_ring_ctx *ctx)
 {
+	if (unlikely(ctx->off_timeout_used || ctx->drain_active))
+		__io_commit_cqring_flush(ctx);
+
 	if (ctx->flags & IORING_SETUP_SQPOLL) {
 		if (wq_has_sleeper(&ctx->cq_wait))
 			wake_up_all(&ctx->cq_wait);
-- 
2.35.1

