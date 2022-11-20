Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1137763154C
	for <lists+io-uring@lfdr.de>; Sun, 20 Nov 2022 17:58:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbiKTQ63 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 20 Nov 2022 11:58:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiKTQ61 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 20 Nov 2022 11:58:27 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36A531FFA1
        for <io-uring@vger.kernel.org>; Sun, 20 Nov 2022 08:58:26 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id kt23so23776716ejc.7
        for <io-uring@vger.kernel.org>; Sun, 20 Nov 2022 08:58:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=imtUJ3yy1StXVkqioRu5zthwXxodm89NdQACG4FRXMo=;
        b=F5adRcC1LRuVVqytzlvhbc2+vy98x75EHHulqQ/VSOVvygVuuODwmDQyXwntmp4A+6
         19l32ErFiuY212SuZbccbv5IhcnEC8aCGBIi+IVXcesj6rUR+5k7exRav97MxJuqhX3w
         4h2fXSllGtyTN3lv8YXajhUa/v8EkWJhmaFap/1FO1UhMxdFWUoH7C+OAIvmJvqNFxnE
         UP2jtOAvb2aeHKfJr3QGWWdzlVKxbkkFgeWTgwSEUdgau1iCm8z0C9FeL+n6SjcaEiYy
         xDIO8wufUywt1no3uv9xw3FsUMNYLpp826j9EPC99DMJDKkjNrEtswSNDVW93Fp9uGpf
         miCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=imtUJ3yy1StXVkqioRu5zthwXxodm89NdQACG4FRXMo=;
        b=jyZt8wB226Z1kVixInQDveELUGBH/0/6OxgJvFbCSjlYawl5/GBRppkXLYRNV94dv8
         9ESJ/LmPeyTKScknn9XV3d7slmHHsorV4qDME+eB4zDUftyqM2D1gSotX/tNeRY81PCe
         k1icCctfs1PjYyfgO2efT7x2ZtH5rtpTRPdxvkkEqKQOnAQPtB+EEmEtPvTWO4/SDN/e
         +3vrzkKf346C41AdqqFiv82y/77TAhn70BFKemHOnx21QSI6z2t6L3xWLLrQxQtnw+wr
         H+e4BOXbzZSmHn0IbJ3AGFzsxPb8Tf5cnUgLTIZjQkNUcvzNTHqEP8olX0ZijmjGMqTk
         5lOg==
X-Gm-Message-State: ANoB5pkZEuHJXnaMGB1dxPrMyqeb5X7yosXaWuXd+nINauo0OsnU1EMK
        dA/cxdF/rKHl5iG9KIMEbEGodqjVSXM=
X-Google-Smtp-Source: AA0mqf5Rbsx/GeEWJBP3rBlwEJsQIIrrrpq8U/EsIRpXgpd+2jhb8kGyV3f1wNxi3NxenGkZ11s1IA==
X-Received: by 2002:a17:907:1303:b0:78d:ee08:1867 with SMTP id vj3-20020a170907130300b0078dee081867mr12938291ejb.123.1668963504449;
        Sun, 20 Nov 2022 08:58:24 -0800 (PST)
Received: from 127.0.0.1localhost (188.28.224.148.threembb.co.uk. [188.28.224.148])
        by smtp.gmail.com with ESMTPSA id l9-20020a1709060cc900b007b47749838asm1904618ejh.45.2022.11.20.08.58.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Nov 2022 08:58:24 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH v3 1/2] io_uring: cmpxchg for poll arm refs release
Date:   Sun, 20 Nov 2022 16:57:41 +0000
Message-Id: <0c95251624397ea6def568ff040cad2d7926fd51.1668963050.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1668963050.git.asml.silence@gmail.com>
References: <cover.1668963050.git.asml.silence@gmail.com>
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

Replace atomically substracting the ownership reference at the end of
arming a poll with a cmpxchg. We try to release ownership by setting 0
assuming that poll_refs didn't change while we were arming. If it did
change, we keep the ownership and use it to queue a tw, which is fully
capable to process all events and (even tolerates spurious wake ups).

It's a bit more elegant as we reduce races b/w setting the cancellation
flag and getting refs with this release, and with that we don't have to
worry about any kinds of underflows. It's not the fastest path for
polling. The performance difference b/w cmpxchg and atomic dec is
usually negligible and it's not the fastest path.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/poll.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/io_uring/poll.c b/io_uring/poll.c
index 055632e9092a..1b78b527075d 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -518,7 +518,6 @@ static int __io_arm_poll_handler(struct io_kiocb *req,
 				 unsigned issue_flags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
-	int v;
 
 	INIT_HLIST_NODE(&req->hash_node);
 	req->work.cancel_seq = atomic_read(&ctx->cancel_seq);
@@ -586,11 +585,10 @@ static int __io_arm_poll_handler(struct io_kiocb *req,
 
 	if (ipt->owning) {
 		/*
-		 * Release ownership. If someone tried to queue a tw while it was
-		 * locked, kick it off for them.
+		 * Try to release ownership. If we see a change of state, e.g.
+		 * poll was waken up, queue up a tw, it'll deal with it.
 		 */
-		v = atomic_dec_return(&req->poll_refs);
-		if (unlikely(v & IO_POLL_REF_MASK))
+		if (atomic_cmpxchg(&req->poll_refs, 1, 0) != 1)
 			__io_poll_execute(req, 0);
 	}
 	return 0;
-- 
2.38.1

