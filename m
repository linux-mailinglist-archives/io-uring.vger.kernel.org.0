Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 178DB775ED2
	for <lists+io-uring@lfdr.de>; Wed,  9 Aug 2023 14:24:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229996AbjHIMYA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Aug 2023 08:24:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231426AbjHIMYA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Aug 2023 08:24:00 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDAB71BDA
        for <io-uring@vger.kernel.org>; Wed,  9 Aug 2023 05:23:59 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id ffacd0b85a97d-317e14b0935so513764f8f.0
        for <io-uring@vger.kernel.org>; Wed, 09 Aug 2023 05:23:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691583838; x=1692188638;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=FlcUjC9HkWL3r2g2PpcNofeW6voVqPES95qinvY0sIY=;
        b=qn1sUf2ILwK1HJbkXjj8k2uIRTbrj6KOkoR3hTR+fHhj55QCMOQDdnHRYw/tmhPc2t
         NsOtVzvS/cEGpVLRObKpzlldnVlC1vNCmMxdzZpLEEc2xK5WqTPbLDedF+xA56rCYJLC
         KpAJN4lf5gboOcRq3ui/3q/8tzkD9GaPr9F2Q1USxwkjQIIzEO4am1FD1/TVktX8ajPC
         yn9S/IW30P/SGbnKG5kQACiA3IyZzbd9Kv6Nhcd5tTfBmuR3Yk010DJrbawR0dbUrLHW
         rJlABN+oq1muT3sHTdjvBYhyNxRXQQGkDhF4asZjyD4vGQONuhuZ6cHktj9G4rrK+w4B
         d2wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691583838; x=1692188638;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FlcUjC9HkWL3r2g2PpcNofeW6voVqPES95qinvY0sIY=;
        b=RO9/Sup3JlNj0lHw0BvMDWWwzjJgz629b8MW5TuknlJ8z87HpDd7d2iFuIig+a9jHV
         YmaMGooxVV3hNo/kq6UMJ1bKcydMvkg4x5rUF5RL4j/7Dtwoz3Sf8XP/uLplxYnR2W3B
         Eu1KwirzhuUVcmsDanaSC2gCpRF8mSeK374nnPpM3yyEzQuFTnjH1fxNDS+eQt+tf3JS
         f/Ahi4Gyp0Z635cNDLEm0Y8TTdUNKnRHSdvaBscpj7qgunb+0ro7oh8QWKYjYHI8u+AN
         AY7o4sIRUA3V+vjzKM8WQzC+d4dJIWi7+47uS8tPKm8/82G2cXsdb/SJD/yOpefvkiVG
         Q8wA==
X-Gm-Message-State: AOJu0YzBMQExKdssmUCtsqtYElRd8VI/2HNQ9LKRIJRIIWtGPiAO7HIk
        84Elc8+71qWyu+Dm+JXPPrR4DCMLzqE=
X-Google-Smtp-Source: AGHT+IE5nuuDQtqBBRBwsUPyXY5USIHNG7W6BwI/z9xpvUOHwAY7CyM83jATAXIYZzB6IHEt+4DBww==
X-Received: by 2002:a5d:4d46:0:b0:317:58a4:916f with SMTP id a6-20020a5d4d46000000b0031758a4916fmr10581041wru.33.1691583837869;
        Wed, 09 Aug 2023 05:23:57 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-230-78.dab.02.net. [82.132.230.78])
        by smtp.gmail.com with ESMTPSA id c6-20020a7bc846000000b003fbc0a49b57sm1850889wml.6.2023.08.09.05.23.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Aug 2023 05:23:57 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 1/1] io_uring: fix drain stalls by invalid SQE
Date:   Wed,  9 Aug 2023 13:21:41 +0100
Message-ID: <66096d54651b1a60534bb2023f2947f09f50ef73.1691538547.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

cq_extra is protected by ->completion_lock, which io_get_sqe() misses.
The bug is harmless as it doesn't happen in real life, requires invalid
SQ index array and racing with submission, and only messes up the
userspace, i.e. stall requests execution but will be cleaned up on
ring destruction.

Fixes: 15641e427070f ("io_uring: don't cache number of dropped SQEs")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index e70cf5c2dc7f..0eed797ef270 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2390,7 +2390,9 @@ static bool io_get_sqe(struct io_ring_ctx *ctx, const struct io_uring_sqe **sqe)
 	}
 
 	/* drop invalid entries */
+	spin_lock(&ctx->completion_lock);
 	ctx->cq_extra--;
+	spin_unlock(&ctx->completion_lock);
 	WRITE_ONCE(ctx->rings->sq_dropped,
 		   READ_ONCE(ctx->rings->sq_dropped) + 1);
 	return false;
-- 
2.41.0

