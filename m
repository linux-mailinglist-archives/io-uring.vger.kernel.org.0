Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B51F477D123
	for <lists+io-uring@lfdr.de>; Tue, 15 Aug 2023 19:34:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238889AbjHORde (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Aug 2023 13:33:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238924AbjHORdW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Aug 2023 13:33:22 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A525F11A
        for <io-uring@vger.kernel.org>; Tue, 15 Aug 2023 10:33:20 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id a640c23a62f3a-99cdb0fd093so768669466b.1
        for <io-uring@vger.kernel.org>; Tue, 15 Aug 2023 10:33:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692120799; x=1692725599;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gygTe6VeHXFhmmjNogX4unEtGJquuz2w9Xe1TMZyLMU=;
        b=pW7+m4oIczI1BeE3NqdHnc48XY8fb5nb0pw7TcgU/6ACbYS1NhbXMp3Oq2/t9lzbDF
         rJdSe53UE7KeEyQnWrT8QC8fMvSo3SUUCzL6qEnHmy3JqKbRxV2cuBsOrEzHZJifwPiH
         tkkdxCZPERySS/6x6aHbIUvBqi+m0mIyuxlz33pMpnT9kQh7JzeBKz9cjl+jj9ugMuT5
         xpcEeOloKLfeFznUdZVeVmTnUQGWmuqZqdyzI5XES6eVZ11OQ7b0zt1D1MECoyJTVmg9
         gmIXAKPW+NSTSau2/h4jPrQB5hiEAQGBKqbHq7uzZLQyQbPGi65n/0r9O0dCu4MqdUQ8
         fEGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692120799; x=1692725599;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gygTe6VeHXFhmmjNogX4unEtGJquuz2w9Xe1TMZyLMU=;
        b=HVMxZuRLkI9Ac7pYEoGT68t3B0gU7THVV4iynHtLFejh75LLSvEYdZSGaZGw6nRtQ8
         LUR9ZMLg4ZWGL+IpzSCmVqele+4Qfo4ltx10l2zwXzUMnmjP4HL3GW0phTc2Bi3AxuNy
         IG1DDT+TVN2KgOWYKbzPU3sgrUV46wbIJA01L/sCGNv1Kr5CTPdqseW9jNs3K2+R4j48
         ObpBI7tCU0Nrlh1HaXwyeV6X9kfJO1rp1ol+e5O63U6DT0ei/MPEoqjMNJGObZJuwTTd
         NuGAc28Z9gz4eZtZ1BxrMJ7Cn2U7qJ5MfcEuq40vE6CpaJYMimFj3UaYpQfWo58zk3vS
         347g==
X-Gm-Message-State: AOJu0YxQGC5VMdZRqtf+p3Q7SIWTkXtenQQtv0n2yN6UoCfSCwVb593M
        tt+2f1dhOizjT2IZJj5njCmcSEO1qWc=
X-Google-Smtp-Source: AGHT+IH/+cQH/gA0Y7DGSxxQYgSheaH4+RJqtacyS3NnMVEUFED/K6pS2uBLRGy1okr5HokqK3xSGA==
X-Received: by 2002:a17:906:9ca:b0:994:56d3:8a42 with SMTP id r10-20020a17090609ca00b0099456d38a42mr11083359eje.27.1692120798799;
        Tue, 15 Aug 2023 10:33:18 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::2:6d35])
        by smtp.gmail.com with ESMTPSA id kk9-20020a170907766900b0099cc36c4681sm7269878ejc.157.2023.08.15.10.33.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Aug 2023 10:33:18 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 06/16] io_uring: reorder cqring_flush and wakeups
Date:   Tue, 15 Aug 2023 18:31:35 +0100
Message-ID: <c6e71a25b020c8dcf554d30ac556378e0d6e318b.1692119257.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1692119257.git.asml.silence@gmail.com>
References: <cover.1692119257.git.asml.silence@gmail.com>
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

Unlike in the past, io_commit_cqring_flush() doesn't do anything that
may need io_cqring_wake() to be issued after, all requests it completes
will go via task_work. Do io_commit_cqring_flush() after
io_cqring_wake() to clean up __io_cq_unlock_post().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 14 +++-----------
 io_uring/rw.c       |  2 +-
 2 files changed, 4 insertions(+), 12 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index e5378dc7aa19..8d27d2a2e893 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -629,19 +629,11 @@ static inline void io_cq_lock(struct io_ring_ctx *ctx)
 static inline void __io_cq_unlock_post(struct io_ring_ctx *ctx)
 {
 	io_commit_cqring(ctx);
-
-	if (ctx->task_complete) {
-		/*
-		 * ->task_complete implies that only current might be waiting
-		 * for CQEs, and obviously, we currently don't. No one is
-		 * waiting, wakeups are futile, skip them.
-		 */
-		io_commit_cqring_flush(ctx);
-	} else {
+	if (!ctx->task_complete) {
 		spin_unlock(&ctx->completion_lock);
-		io_commit_cqring_flush(ctx);
 		io_cqring_wake(ctx);
 	}
+	io_commit_cqring_flush(ctx);
 }
 
 static void io_cq_unlock_post(struct io_ring_ctx *ctx)
@@ -649,8 +641,8 @@ static void io_cq_unlock_post(struct io_ring_ctx *ctx)
 {
 	io_commit_cqring(ctx);
 	spin_unlock(&ctx->completion_lock);
-	io_commit_cqring_flush(ctx);
 	io_cqring_wake(ctx);
+	io_commit_cqring_flush(ctx);
 }
 
 /* Returns true if there are no backlogged entries after the flush */
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 9b51afdae505..20140d3505f1 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -985,9 +985,9 @@ int io_write(struct io_kiocb *req, unsigned int issue_flags)
 
 static void io_cqring_ev_posted_iopoll(struct io_ring_ctx *ctx)
 {
-	io_commit_cqring_flush(ctx);
 	if (ctx->flags & IORING_SETUP_SQPOLL)
 		io_cqring_wake(ctx);
+	io_commit_cqring_flush(ctx);
 }
 
 void io_rw_fail(struct io_kiocb *req)
-- 
2.41.0

