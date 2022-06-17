Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3850854F385
	for <lists+io-uring@lfdr.de>; Fri, 17 Jun 2022 10:50:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381133AbiFQItr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 17 Jun 2022 04:49:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381202AbiFQItq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 17 Jun 2022 04:49:46 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7DCB6972A
        for <io-uring@vger.kernel.org>; Fri, 17 Jun 2022 01:49:45 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id hj18so6864832ejb.0
        for <io-uring@vger.kernel.org>; Fri, 17 Jun 2022 01:49:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NW2kcZCQGw9AbKy5ShhQW5km1CLdBuJViplrOpGjFTU=;
        b=dbx11rvaOSjFvXsqFtpZSW1/pzh0N96LzMuSeb/K/Lo56c+DIVKhh1UemGZMMY8wSI
         u3YuwvMNZjBGOeN6FGYmBLTja3TGuHt6VKgX7/40d3dRn1S2suMuY4SISQbwQuIoBWfK
         ZPx3vA0gYYIyr1safSnWxpkjDtAOsS3EX51Ai6QZDbci4cUSBMKb3rm+qXSd9cE5gb/v
         pollwUi/8sXW9e88gyLypZ6wRA5RHReQV4q6sfhjdibXpd2P5IV7FtI5hXs+8/H0o6jf
         Q9olGIkEQaTiFEKJro9YzlUW3VGwAXV9wkKQwQ4Od3JL0M0x8TMaxJDAawI2aK/d1iaH
         IWZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NW2kcZCQGw9AbKy5ShhQW5km1CLdBuJViplrOpGjFTU=;
        b=RnFtp4gyCmt4OMEnn+Aoc26p2nEycjY+blo6dlrs7bQWjv9Y3xi+a/v77C9HKRvU8M
         pXdQ3hyDHUdlBqkU6Hsg83ciaLE9IC7DnsmhBzqkMLyOz5vwL/1t6fN4EpeMzJc96q5b
         5Eah2gT+JrIIDQYL2cJptYZ4h3doTUpwL+xZWwdPOBCaxA6JHVefAG72gZo+Zf8aFAoq
         jLTugASkXXFRTByOV8qq4VGkcBu7VczkCsjFAnqRF65M6MziBKoFEU5/8J5Olx7AZGUP
         urIWstF67ahYK/jDVjm3/baJZ6fsklWtB5jfecCD5k4Ns6VxMXSjjX1W802vUIVxtjFu
         nbPQ==
X-Gm-Message-State: AJIora9HoEWhsFL8oARgvIvCcJ8+C9wW7JWfdX2uxsPcpGuPoJoGZpmK
        M7F/xEPR8ft8MGCIxvshIjGbWN5A+yHB8w==
X-Google-Smtp-Source: AGRyM1ss9RKTednYJu8vG3wCT7J8lZfx3dx5tXe9PSrDwuV21EBiJkFv+UUp7TEnf49I8hdaCPgvpw==
X-Received: by 2002:a17:907:3f8c:b0:71b:badb:9389 with SMTP id hr12-20020a1709073f8c00b0071bbadb9389mr5790819ejc.311.1655455784023;
        Fri, 17 Jun 2022 01:49:44 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:b65a])
        by smtp.gmail.com with ESMTPSA id u17-20020a1709060b1100b006ff52dfccf3sm1851895ejg.211.2022.06.17.01.49.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jun 2022 01:49:43 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 5/6] io_uring: deduplicate io_get_cqe() calls
Date:   Fri, 17 Jun 2022 09:48:04 +0100
Message-Id: <4fa077986cc3abab7c59ff4e7c390c783885465f.1655455613.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655455613.git.asml.silence@gmail.com>
References: <cover.1655455613.git.asml.silence@gmail.com>
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

Deduplicate calls to io_get_cqe() from __io_fill_cqe_req().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.h | 38 +++++++++++++-------------------------
 1 file changed, 13 insertions(+), 25 deletions(-)

diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 4134b206c33c..cd29d91c2175 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -47,19 +47,17 @@ static inline bool __io_fill_cqe_req(struct io_ring_ctx *ctx,
 				req->cqe.res, req->cqe.flags,
 				(req->flags & REQ_F_CQE32_INIT) ? req->extra1 : 0,
 				(req->flags & REQ_F_CQE32_INIT) ? req->extra2 : 0);
+	/*
+	 * If we can't get a cq entry, userspace overflowed the
+	 * submission (by quite a lot). Increment the overflow count in
+	 * the ring.
+	 */
+	cqe = io_get_cqe(ctx);
+	if (unlikely(!cqe))
+		return io_req_cqe_overflow(req);
+	memcpy(cqe, &req->cqe, sizeof(*cqe));
 
-	if (!(ctx->flags & IORING_SETUP_CQE32)) {
-		/*
-		 * If we can't get a cq entry, userspace overflowed the
-		 * submission (by quite a lot). Increment the overflow count in
-		 * the ring.
-		 */
-		cqe = io_get_cqe(ctx);
-		if (likely(cqe)) {
-			memcpy(cqe, &req->cqe, sizeof(*cqe));
-			return true;
-		}
-	} else {
+	if (ctx->flags & IORING_SETUP_CQE32) {
 		u64 extra1 = 0, extra2 = 0;
 
 		if (req->flags & REQ_F_CQE32_INIT) {
@@ -67,20 +65,10 @@ static inline bool __io_fill_cqe_req(struct io_ring_ctx *ctx,
 			extra2 = req->extra2;
 		}
 
-		/*
-		 * If we can't get a cq entry, userspace overflowed the
-		 * submission (by quite a lot). Increment the overflow count in
-		 * the ring.
-		 */
-		cqe = io_get_cqe(ctx);
-		if (likely(cqe)) {
-			memcpy(cqe, &req->cqe, sizeof(struct io_uring_cqe));
-			WRITE_ONCE(cqe->big_cqe[0], extra1);
-			WRITE_ONCE(cqe->big_cqe[1], extra2);
-			return true;
-		}
+		WRITE_ONCE(cqe->big_cqe[0], extra1);
+		WRITE_ONCE(cqe->big_cqe[1], extra2);
 	}
-	return io_req_cqe_overflow(req);
+	return true;
 }
 
 static inline void req_set_fail(struct io_kiocb *req)
-- 
2.36.1

