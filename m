Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9087F54CEC7
	for <lists+io-uring@lfdr.de>; Wed, 15 Jun 2022 18:34:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356664AbiFOQem (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Jun 2022 12:34:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356728AbiFOQek (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Jun 2022 12:34:40 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F6FA3631F
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 09:34:37 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id j5-20020a05600c1c0500b0039c5dbbfa48so1452327wms.5
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 09:34:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jRmOa9uYxv7BEB0AnrrsA833tIw8T2Q7R1ToAIQEAg4=;
        b=UzccXbnFCfvTbHzD6bd0Wf7zZIehd+jh3R6cdVmC4IbMBky+NhjQ/PshtDPjMyS4jA
         ZDlrAzOn1ZEixhaj31pI7czeuvskUS6/ZSsEKTh4VXftoMciYWh6BOqk5fncCMIXQ6Oq
         oUvjd1jwOV7nn7dlyynsBbYRoOVaqtbz7eedDGjx6Iy4NeTzCyRtU4h3tES2X0n9H6Ra
         1mTvIJTLqCoHPaK3FPqqbBms+viqWF0XSr/8C8QMTobfwGcDmRxGfSBakN3MzMSrKQFq
         vukRaagZt/aE0hltm82iUEiEMbRnftVCac2Dgl4P46TUarhg5tK/qjtp+xssxPpZtYLQ
         aZxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jRmOa9uYxv7BEB0AnrrsA833tIw8T2Q7R1ToAIQEAg4=;
        b=A51O/u4sd86IabsKvS+84B0nBnUpeFM1V9YUEAkKmAU146AQPc9O7SCS+3fYPjht/y
         WXFGXK7EoVJAiexPQDITgIVm5LxfB3oCgjp/cq3I2RN12X5GCy/Y1ionGbQ9R4lYZgG7
         HXinlpJacdB5jCU7IbYXCzbSQNuoR47hmTKm10HFRR1OjyNbOUIhwZRXz4TwKIWlYoMj
         hpgfvmpBKMtBGHKf6BmfI3FKIaXt34DUq2LFB3COG44H268I6Uo7DjzK7pC5qpDZk6se
         rnVuvqUmNRF3Ih0PyxbMq3mJSuR0+SKvUGRNqIPF9h+cAuV/fG2cNA5CRpz7HKRrd2HF
         jDzg==
X-Gm-Message-State: AJIora8Kughm5vn6i4J+htd2P9wOn318Q9j188mGPINd11f+8CZ5iJns
        slGWLSLS5sNTFzDSj2aMXb7FOLIPHXJoWg==
X-Google-Smtp-Source: AGRyM1uHRM5TaEoz+TIsqtLnEz/r9XrIRT2LuRgcSKT/I78kx/6GaXuH8+ExsN2fa9vL39dnsIw+pw==
X-Received: by 2002:a1c:4484:0:b0:39c:4597:1f74 with SMTP id r126-20020a1c4484000000b0039c45971f74mr284050wma.13.1655310875498;
        Wed, 15 Jun 2022 09:34:35 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id u2-20020a056000038200b0020ff3a2a925sm17894953wrf.63.2022.06.15.09.34.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jun 2022 09:34:35 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 10/10] io_uring: don't set REQ_F_COMPLETE_INLINE in tw
Date:   Wed, 15 Jun 2022 17:33:56 +0100
Message-Id: <aca80f71464ad02c06f1311d998a2d6ee0b31573.1655310733.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655310733.git.asml.silence@gmail.com>
References: <cover.1655310733.git.asml.silence@gmail.com>
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

io_req_task_complete() enqueues requests for state completion itself, no
need for REQ_F_COMPLETE_INLINE, which is only serve the purpose of not
bloating the kernel.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index f47de2906549..ce3302a62112 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1769,7 +1769,6 @@ inline void io_req_task_complete(struct io_kiocb *req, bool *locked)
 {
 	if (*locked) {
 		req->cqe.flags |= io_put_kbuf(req, 0);
-		req->flags |= REQ_F_COMPLETE_INLINE;
 		io_req_add_compl_list(req);
 	} else {
 		req->cqe.flags |= io_put_kbuf(req, IO_URING_F_UNLOCKED);
-- 
2.36.1

