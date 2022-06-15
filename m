Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B62254C5FF
	for <lists+io-uring@lfdr.de>; Wed, 15 Jun 2022 12:23:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346622AbiFOKXw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Jun 2022 06:23:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348789AbiFOKXk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Jun 2022 06:23:40 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C14326B
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 03:23:39 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id l126-20020a1c2584000000b0039c1a10507fso862576wml.1
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 03:23:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=d5QWZ1a51qrP2icOZdU3RovoevCor5hzeqJHx4rxttE=;
        b=K48hYadHwPDSDDHLdU50ea4yuU0QQbe/aYKtAmbSWmQsW1735Pah9ZAXAtpMaQWCU/
         Z/NiQ6Y3KWk73zyEvUtnR03GDCWNCysHhgMcck8q/qW4LT4auh2RFQHqJuvgmXmkExya
         tq/pKeVlw5YK4+zB5hJIBMarljMVrzW07iEXA2xhitU7heiBMfaGYltFVNcMyG9wR96Q
         XlG/Iv5HMjBycfpwKT7R8U+2EsagAVX+mcyBnIVJ8pL2pHonRQkYJGOrpqXYrowwUYFQ
         mrKBqLe0ASC8KNnSrTLey2WHe+s78hQ3AuiZv6byxZXShHPuLf7iRtPDVF7CM0ZJzA3G
         m+Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=d5QWZ1a51qrP2icOZdU3RovoevCor5hzeqJHx4rxttE=;
        b=XIppKCid+JgxZMEXjIfWHei/9IwnARzAMjV6dxC7YQXam9kbH8xBCl1n+/hdgJg6P1
         oJd9CmIEMbM/shIslUXtitM+4GhflpCtcPDewJw1rkEohv8cn1BP/Vl+VUD3P+MC/VPN
         IM0AUuw7jKzdrQHmTMRF58RE43UJtWRrzQlfhBFhfeluotR4k6Kr0WaPClh6ulbrpGSm
         pOdAJXE9R2qMQ5HzNItcQ5qvo2r1xIumc5+2OA02VCnYWxspe2Hl7K0Am8d6QWF/mSQr
         AX5LpfwO0//pj82mVGcJxmPJyc+L3sSI3IMzhguE0m7NH8SL0JgCt9wTllqhj7Ydngvi
         8mXA==
X-Gm-Message-State: AOAM532QAX+Gg6JrJh6Vt2m+dtHrAZL3RnDg0+jXE60/bIuVLsBud8n0
        Vatsv/NJLD0h7vjn31pmNjyEG49cBm3Eyw==
X-Google-Smtp-Source: ABdhPJzeAZkkdhro/dOpqPbXEcduuGT1pcUKyu6LRli91HjawPBke/HUAl/cvfIRZ+5GbOhSJeZ9Zg==
X-Received: by 2002:a05:600c:b51:b0:39d:b58f:67bf with SMTP id k17-20020a05600c0b5100b0039db58f67bfmr6680248wmr.195.1655288617351;
        Wed, 15 Jun 2022 03:23:37 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id p124-20020a1c2982000000b0039c7dbafa7asm1964984wmp.19.2022.06.15.03.23.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jun 2022 03:23:36 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 5.19 5/6] io_uring: inline __io_fill_cqe()
Date:   Wed, 15 Jun 2022 11:23:06 +0100
Message-Id: <71dab9afc3cde3f8b64d26f20d3b60bdc40726ff.1655287457.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655287457.git.asml.silence@gmail.com>
References: <cover.1655287457.git.asml.silence@gmail.com>
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

In preparation for the following patch, inline __io_fill_cqe(), there is
only one user.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 37 ++++++++++++++++---------------------
 1 file changed, 16 insertions(+), 21 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 808b7f4ace0b..792e9c95d217 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2447,26 +2447,6 @@ static bool io_cqring_event_overflow(struct io_ring_ctx *ctx, u64 user_data,
 	return true;
 }
 
-static inline bool __io_fill_cqe(struct io_ring_ctx *ctx, u64 user_data,
-				 s32 res, u32 cflags)
-{
-	struct io_uring_cqe *cqe;
-
-	/*
-	 * If we can't get a cq entry, userspace overflowed the
-	 * submission (by quite a lot). Increment the overflow count in
-	 * the ring.
-	 */
-	cqe = io_get_cqe(ctx);
-	if (likely(cqe)) {
-		WRITE_ONCE(cqe->user_data, user_data);
-		WRITE_ONCE(cqe->res, res);
-		WRITE_ONCE(cqe->flags, cflags);
-		return true;
-	}
-	return io_cqring_event_overflow(ctx, user_data, res, cflags, 0, 0);
-}
-
 static inline bool __io_fill_cqe_req(struct io_ring_ctx *ctx,
 				     struct io_kiocb *req)
 {
@@ -2523,9 +2503,24 @@ static inline bool __io_fill_cqe_req(struct io_ring_ctx *ctx,
 static noinline bool io_fill_cqe_aux(struct io_ring_ctx *ctx, u64 user_data,
 				     s32 res, u32 cflags)
 {
+	struct io_uring_cqe *cqe;
+
 	ctx->cq_extra++;
 	trace_io_uring_complete(ctx, NULL, user_data, res, cflags, 0, 0);
-	return __io_fill_cqe(ctx, user_data, res, cflags);
+
+	/*
+	 * If we can't get a cq entry, userspace overflowed the
+	 * submission (by quite a lot). Increment the overflow count in
+	 * the ring.
+	 */
+	cqe = io_get_cqe(ctx);
+	if (likely(cqe)) {
+		WRITE_ONCE(cqe->user_data, user_data);
+		WRITE_ONCE(cqe->res, res);
+		WRITE_ONCE(cqe->flags, cflags);
+		return true;
+	}
+	return io_cqring_event_overflow(ctx, user_data, res, cflags, 0, 0);
 }
 
 static void __io_req_complete_put(struct io_kiocb *req)
-- 
2.36.1

