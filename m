Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C636B54C5FD
	for <lists+io-uring@lfdr.de>; Wed, 15 Jun 2022 12:23:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343555AbiFOKXv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Jun 2022 06:23:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348757AbiFOKXi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Jun 2022 06:23:38 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCCF2183BC
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 03:23:37 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id i17-20020a7bc951000000b0039c4760ec3fso1977758wml.0
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 03:23:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HiCcQDq1baafO0nWvNgs2fXXD3ti+g1wIEHJP0lTT7Y=;
        b=ZJRrGqd+5Oq2zcwwKfU4LZsr5ZpxIIS3IrNwJ56kxaetC5EcOHAV+kLBsyyhM+qjQZ
         fkAbDtE8OZN1TmEmuUUYyMUxWDRbQ45nvorbJmiHGDewZdRE+bwps7fq2agLjHKMfmjS
         5QdDeGw8hsBWs7OkcGZpCwAezc00VhnlNWCIo+lfxxHqa2IMQLSuPeMmaVbVOfsKaVVc
         hhIzopfC8pERy1h3klYr4c1KgcojWpStQFO22Sd/LEyjId2ey9EhGIZ24qt5DBDF+H1t
         OQoj7tkksjhq4Tn5jGoXyfFSlyh11YubcpA9JmVCRXKtI953eHl1X4wAmQcPfj1rKKUi
         pfmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HiCcQDq1baafO0nWvNgs2fXXD3ti+g1wIEHJP0lTT7Y=;
        b=6H6flPCnseRo0iJQbJchcycXL2TOPyYhO4evRbPab9addxB6udsco4KhacLkD0wImt
         pxQwKCCxCwPhCdzfFR2uPPATqceAk8fM9Or5owniUf2VyF0/XY0x9R+DMkJJgijPk72G
         TRA9pbcvzIKDVp+D4XNRjUIR+02O0PKA5JXytdob7rGCC4ah7yfhwa1rX/3GeT6rcK7A
         3oAtcj4X4mos0Wo/iHktvcCFD6XyKZY6pFmyZg/hF0UlllUxZaziPar6FaMl0tXcvTO7
         uDl8F57z6j/zGInAriew+ixyPVuPWfRVPeCZaiOKK4Rf2+jHXOOEOACsOHP1aR9ut7/l
         zZkQ==
X-Gm-Message-State: AOAM5318JgE9KXDk+AuZk1b10K3OXJdZOqh5grRe7UzlHAlG81F6yEXy
        OfdqvUJZqOGxLA6xfaG8iZALioUnX+HKug==
X-Google-Smtp-Source: ABdhPJz0wpXled+Fm61QlwbQ0AXRXK/qEzc6tVZ8hoHsfb2Kp+qUKHW0Kuhd0c7rGlRRC7nO61hBSg==
X-Received: by 2002:a7b:cf2a:0:b0:39c:4eef:29e with SMTP id m10-20020a7bcf2a000000b0039c4eef029emr9248259wmg.28.1655288615845;
        Wed, 15 Jun 2022 03:23:35 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id p124-20020a1c2982000000b0039c7dbafa7asm1964984wmp.19.2022.06.15.03.23.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jun 2022 03:23:35 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 5.19 4/6] io_uring: fix ->extra{1,2} misuse
Date:   Wed, 15 Jun 2022 11:23:05 +0100
Message-Id: <4b3e5be512fbf4debec7270fd485b8a3b014d464.1655287457.git.asml.silence@gmail.com>
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

We don't really know the state of req->extra{1,2] fields in
__io_fill_cqe_req(), if an opcode handler is not aware of CQE32 option,
it never sets them up properly. Track the state of those fields with a
request flag.

Fixes: 76c68fbf1a1f9 ("io_uring: enable CQE32")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 10901db93f7e..808b7f4ace0b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -844,6 +844,7 @@ enum {
 	REQ_F_SINGLE_POLL_BIT,
 	REQ_F_DOUBLE_POLL_BIT,
 	REQ_F_PARTIAL_IO_BIT,
+	REQ_F_CQE32_INIT_BIT,
 	REQ_F_APOLL_MULTISHOT_BIT,
 	/* keep async read/write and isreg together and in order */
 	REQ_F_SUPPORT_NOWAIT_BIT,
@@ -913,6 +914,8 @@ enum {
 	REQ_F_PARTIAL_IO	= BIT(REQ_F_PARTIAL_IO_BIT),
 	/* fast poll multishot mode */
 	REQ_F_APOLL_MULTISHOT	= BIT(REQ_F_APOLL_MULTISHOT_BIT),
+	/* ->extra1 and ->extra2 are initialised */
+	REQ_F_CQE32_INIT	= BIT(REQ_F_CQE32_INIT_BIT),
 };
 
 struct async_poll {
@@ -2488,8 +2491,12 @@ static inline bool __io_fill_cqe_req(struct io_ring_ctx *ctx,
 						req->cqe.res, req->cqe.flags,
 						0, 0);
 	} else {
-		u64 extra1 = req->extra1;
-		u64 extra2 = req->extra2;
+		u64 extra1 = 0, extra2 = 0;
+
+		if (req->flags & REQ_F_CQE32_INIT) {
+			extra1 = req->extra1;
+			extra2 = req->extra2;
+		}
 
 		trace_io_uring_complete(req->ctx, req, req->cqe.user_data,
 					req->cqe.res, req->cqe.flags, extra1, extra2);
@@ -5019,6 +5026,7 @@ static inline void io_req_set_cqe32_extra(struct io_kiocb *req,
 {
 	req->extra1 = extra1;
 	req->extra2 = extra2;
+	req->flags |= REQ_F_CQE32_INIT;
 }
 
 /*
-- 
2.36.1

