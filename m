Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02C48592F1C
	for <lists+io-uring@lfdr.de>; Mon, 15 Aug 2022 14:44:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231543AbiHOMoG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 15 Aug 2022 08:44:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242251AbiHOMoG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 15 Aug 2022 08:44:06 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43CB6DEE1
        for <io-uring@vger.kernel.org>; Mon, 15 Aug 2022 05:44:05 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id d5so1506152wms.5
        for <io-uring@vger.kernel.org>; Mon, 15 Aug 2022 05:44:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=FDcCBpO861fd0OK08nWM230qdzeMboYjo2plhdkxVSw=;
        b=gNZzoh3RsBd1XnhyJa88P8+2Q3i/QybIpvWulyCJpyvJhg/OmfFOxbkJNPNMIFYdFa
         cui69IDtGp0eIC9qvhabWdGoND+NaEMXFzE47T5y3EffhCbfoshsiZkQ0SUeI62jSrxY
         4XJQ/8VHWex6Q93nyzsuJafDGDyDcKZBMhZ9zpetO3yCW9j02/mpT7JowKr7UKyrG8QJ
         vp+AJV35SBE+I49HuXws7UsUFN5UsiwMFn/sCfgRi6WQMpTgTixO2Rb66XQYjh/Ht/Fo
         q039Idqj6Rpo7Am7FQSF2yKccPLEfaHZxlRJxcjjW6nERZ48fE3K1eRSspUWWDp6eWSC
         00wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=FDcCBpO861fd0OK08nWM230qdzeMboYjo2plhdkxVSw=;
        b=ADkhkQVf7RIcErfNstBQ+8u3En+LRmXTkess3QmqotMRrhtFvY4scSbWzgOWJJ+XXR
         3sAAGWpVrvxCNE3u7JB7RWFX52zuvXbKrBmKNeIQCdci4n2ClbDtQaBL3iY2/zcbp+eH
         C75yJoXccEpDAlFqhHzgHlf4voJDq/+MBqy+/iwBTwZADYiDUbMn1mzByo5ayVeVuyH5
         3usrpZ0flIAsVVgsI9jtCK7B9mLWIsCunBG39mjgzOsXgogh46N52IDQ4uYvLJNEyY1m
         Jkx6pOd70vDIjvOZMqYKtEEuP44VArq6yf63U3aFKVlydOFgMA+oBBcxVM5suZj0S0Ws
         LCnw==
X-Gm-Message-State: ACgBeo0vpkOpuVoNL4OiU3s9HObmCzxqJVrYprQ20Puc/Cw0330MxSqX
        USzxTPK5VqpBAcJuDGQ2nOCRN4UnsPk=
X-Google-Smtp-Source: AA6agR6S1z4L/VIvCQytKoQ4+Vx2nJOLvUV6EaeW/3Ak2SMR7Qxefeghl6cot/1TxaduVMak7j74Bw==
X-Received: by 2002:a05:600c:384c:b0:3a4:a146:2a04 with SMTP id s12-20020a05600c384c00b003a4a1462a04mr9838353wmr.176.1660567443390;
        Mon, 15 Aug 2022 05:44:03 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:5fc6])
        by smtp.gmail.com with ESMTPSA id f13-20020a05600c154d00b003a54fffa809sm10296109wmg.17.2022.08.15.05.44.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Aug 2022 05:44:03 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-5.20 1/3] io_uring/net: use right helpers for async recycle
Date:   Mon, 15 Aug 2022 13:42:00 +0100
Message-Id: <b7414da4e7c3c32c31fc02dfd1355af4ccf4ca5f.1660566179.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <cover.1660566179.git.asml.silence@gmail.com>
References: <cover.1660566179.git.asml.silence@gmail.com>
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

We have a helper that checks for whether a request contains anything in
->async_data or not, namely req_has_async_data(). It's better to use it
as it might have some extra considerations.

Fixes: 43e0bbbd0b0e3 ("io_uring: add netmsg cache")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 6d71748e2c5a..2129562bfd9f 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -116,7 +116,7 @@ static void io_netmsg_recycle(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_async_msghdr *hdr = req->async_data;
 
-	if (!hdr || issue_flags & IO_URING_F_UNLOCKED)
+	if (!req_has_async_data(req) || issue_flags & IO_URING_F_UNLOCKED)
 		return;
 
 	/* Let normal cleanup path reap it if we fail adding to the cache */
-- 
2.37.0

