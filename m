Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3167B533304
	for <lists+io-uring@lfdr.de>; Tue, 24 May 2022 23:37:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241938AbiEXVhm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 24 May 2022 17:37:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241010AbiEXVhj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 24 May 2022 17:37:39 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 242747C17D
        for <io-uring@vger.kernel.org>; Tue, 24 May 2022 14:37:38 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id d22so16930986plr.9
        for <io-uring@vger.kernel.org>; Tue, 24 May 2022 14:37:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=x3ipgQpo024kD3RcxwTPeVNFPz0g/sbgu3FNn+sS9wo=;
        b=UxGl0qwSnl6iGpFGhAn11BKVlKN4ZFfS20X+zCAdygBt/x7CRMr0fFw43aR9tgMbJZ
         RlHv37ZIyfym7CMTFaiLFhJrucuQcI0rRpcyG1UfhSE1aHJ8wZE60j/9o58UI2lQmQdS
         n2WrBeqE5qTqo2G8fbTKmYcTDw8x/7UlpEQ8eigwstSFxhMknc1BcbOSnJMcqi/BNem6
         6TzdognNR2OvoXcL2w6z8v97GZG8Nj0wbr87FLDoz9xsMinXz8QfOmpw5FaQlt0wM3Yn
         dwQtOoR3EJkeY+Mi36RIq41kieWkRnYdF0TUXnBriJiXsxDgJaTiQufGWtByefUvPyGY
         dKDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=x3ipgQpo024kD3RcxwTPeVNFPz0g/sbgu3FNn+sS9wo=;
        b=hgRNlerBI2iK7FuxYsd3qCgYD+CPg8CEg1BDdNd58gryZin6NZxFnlUABfY5UOPO+q
         gioslQdseiiGmdQk6NkYCPZqJaFoBYRV2q7IGJa+pZGJiDskm+j1VZs8LJLJiQrCq5lT
         venfVbMa2oBslotAfLf8beNV6vKbv0U/zgv2pKO3ynWNAMVQQFHZ4xPubYDQjUf2wyGA
         om9zCuybLLS7aTRJU3QIZrK6sYjIfqTwqk4rYb8B+c/f08RVKh6S6DBCwmRrRnUbOhl5
         /J4D/K0njRksRFOePVTZctoRUN9vpHICaIHzwkWhSrb01o/a6Cv45D6yiQPfOZXDFt0e
         kbuA==
X-Gm-Message-State: AOAM530vNKH5omvpipA/711EJbdZRCXfGdIQQBxvKcAgBAKamCM1ey0H
        hhqPkydYeeuXl9g3moL5ttezBOA/jvFKQA==
X-Google-Smtp-Source: ABdhPJwze6cPhcmVoi4iIDksmdpAWEwup9dKXw3BR5HM1shY96kvhm4N4rxja5s9QSC+A/x7bLUMbA==
X-Received: by 2002:a17:903:240c:b0:153:c452:f282 with SMTP id e12-20020a170903240c00b00153c452f282mr28431942plo.88.1653428257374;
        Tue, 24 May 2022 14:37:37 -0700 (PDT)
Received: from localhost.localdomain ([2600:380:4a61:523:72ca:65a5:f684:5e4])
        by smtp.gmail.com with ESMTPSA id k21-20020a170902761500b0015e8d4eb1easm7834327pll.52.2022.05.24.14.37.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 May 2022 14:37:36 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5/6] io_uring: drop confusion between cleanup flags
Date:   Tue, 24 May 2022 15:37:26 -0600
Message-Id: <20220524213727.409630-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220524213727.409630-1-axboe@kernel.dk>
References: <20220524213727.409630-1-axboe@kernel.dk>
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

If the opcode only stores data that needs to be kfree'ed in
req->async_data, then it doesn't need special handling in
our cleanup handler.

This has the added bonus of removing knowledge of those kinds of
special async_data to the io_uring core.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 18 ------------------
 1 file changed, 18 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 408265a03563..8188c47956ad 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8229,24 +8229,6 @@ static void io_clean_op(struct io_kiocb *req)
 
 	if (req->flags & REQ_F_NEED_CLEANUP) {
 		switch (req->opcode) {
-		case IORING_OP_READV:
-		case IORING_OP_READ_FIXED:
-		case IORING_OP_READ:
-		case IORING_OP_WRITEV:
-		case IORING_OP_WRITE_FIXED:
-		case IORING_OP_WRITE: {
-			struct io_async_rw *io = req->async_data;
-
-			kfree(io->free_iovec);
-			break;
-			}
-		case IORING_OP_RECVMSG:
-		case IORING_OP_SENDMSG: {
-			struct io_async_msghdr *io = req->async_data;
-
-			kfree(io->free_iov);
-			break;
-			}
 		case IORING_OP_OPENAT:
 		case IORING_OP_OPENAT2:
 			if (req->open.filename)
-- 
2.35.1

