Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C30366AF96
	for <lists+io-uring@lfdr.de>; Sun, 15 Jan 2023 08:16:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbjAOHQJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 15 Jan 2023 02:16:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbjAOHQI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 15 Jan 2023 02:16:08 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 736859EE5;
        Sat, 14 Jan 2023 23:16:06 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id b9-20020a17090a7ac900b00226ef160dcaso26568873pjl.2;
        Sat, 14 Jan 2023 23:16:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=p6n+gq7LHdcgfMZrSmQ/cw2Pqom8CQ/6NIY/tLMQxok=;
        b=SQz1CJcsRlrq+vyEIHG9rB/D1qeDti90VS39XNanIsz++MeK2oF8ybsyRWKTsVJtLc
         zabxpj/Z/j5e0fmnDC/cvaGvOXSwuagWLfxtqdjcaPFoGXAXZWVI503ePQ/lD8e4KxlS
         0JE9Kkswk5QG+9R4UWNS3yTxRiIDa4/dMnfukocfVUrls8XfpHs1R2WOmsQKiFGDJrPY
         gyhk6deG2LAV0l2Ebrb3Qg/rBjIOM3UWI75m3loQ1xWwO6uwy6kyAMVEHKfp2gENZh9M
         UMgC0j7WqW4amsBR7+lOOpJqx1SDN5okuVMI+Tuj7ngYlsiDff66nATi8T96zy8R9EdI
         lCTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=p6n+gq7LHdcgfMZrSmQ/cw2Pqom8CQ/6NIY/tLMQxok=;
        b=CfEus8pDMU75NM1DXHnHWfyibYM569TRDGqKdATeYs2I2BB0cgv29+dReHQHTvudvy
         Opi59rLfTsLEF8Rqd719e1iWaTUyAHPHgFIE8nc/TCbSp1n1eofFwHZ79ykpOOL+wsm9
         osRqI32z/dwQQQxuxSoAvPCGx7TShksga405o3G1sKeKcGZXRd/BxovQO3wUp7qhv25i
         n65X2wEzbaDv/27eozxmA4NS56n7EH9eiw42XnhoPJtc9XTZY+WkwUZrC69oj9P7cPoU
         toYxFTsEQtjJcXqt89q/eTYW2rTvANQVS1k7fX3S3Nnv43UG9YTJk1TzE0RNDIbCnl8B
         HQ0g==
X-Gm-Message-State: AFqh2krbK/zavWCwC6TZud+DmZTFVu8Kq/bTH2oA6J3zrNNtaXfG03t+
        sco0ARheGRwbf6DU9YBbn7A=
X-Google-Smtp-Source: AMrXdXvNFt66g0ILoxDQdqMR1deTa6z2xRRS6f0OuoqzmNeq3GxacDhKxSSDVYgZfEJlk35atds/KQ==
X-Received: by 2002:a17:903:2341:b0:192:5e53:15f3 with SMTP id c1-20020a170903234100b001925e5315f3mr113551988plh.48.1673766965979;
        Sat, 14 Jan 2023 23:16:05 -0800 (PST)
Received: from localhost.localdomain ([43.132.141.3])
        by smtp.gmail.com with ESMTPSA id z6-20020a1709027e8600b0019445b8ef29sm9284718pla.61.2023.01.14.23.16.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Jan 2023 23:16:05 -0800 (PST)
From:   Quanfa Fu <quanfafu@gmail.com>
To:     axboe@kernel.dk, asml.silence@gmail.com
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        Quanfa Fu <quanfafu@gmail.com>
Subject: [PATCH] io_uring: make io_sqpoll_wait_sq return void
Date:   Sun, 15 Jan 2023 15:15:19 +0800
Message-Id: <20230115071519.554282-1-quanfafu@gmail.com>
X-Mailer: git-send-email 2.31.1
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

Change the return type to void since it always return 0, and no need
to do the checking in syscall io_uring_enter.

Signed-off-by: Quanfa Fu <quanfafu@gmail.com>
---
 io_uring/io_uring.c | 8 +++-----
 io_uring/sqpoll.c   | 3 +--
 io_uring/sqpoll.h   | 2 +-
 3 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 2ac1cd8d23ea..7305c9e34566 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3330,11 +3330,9 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 		}
 		if (flags & IORING_ENTER_SQ_WAKEUP)
 			wake_up(&ctx->sq_data->wait);
-		if (flags & IORING_ENTER_SQ_WAIT) {
-			ret = io_sqpoll_wait_sq(ctx);
-			if (ret)
-				goto out;
-		}
+		if (flags & IORING_ENTER_SQ_WAIT)
+			io_sqpoll_wait_sq(ctx);
+
 		ret = to_submit;
 	} else if (to_submit) {
 		ret = io_uring_add_tctx_node(ctx);
diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
index 559652380672..0119d3f1a556 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -312,7 +312,7 @@ static int io_sq_thread(void *data)
 	do_exit(0);
 }
 
-int io_sqpoll_wait_sq(struct io_ring_ctx *ctx)
+void io_sqpoll_wait_sq(struct io_ring_ctx *ctx)
 {
 	DEFINE_WAIT(wait);
 
@@ -327,7 +327,6 @@ int io_sqpoll_wait_sq(struct io_ring_ctx *ctx)
 	} while (!signal_pending(current));
 
 	finish_wait(&ctx->sqo_sq_wait, &wait);
-	return 0;
 }
 
 __cold int io_sq_offload_create(struct io_ring_ctx *ctx,
diff --git a/io_uring/sqpoll.h b/io_uring/sqpoll.h
index 0c3fbcd1f583..e1b8d508d22d 100644
--- a/io_uring/sqpoll.h
+++ b/io_uring/sqpoll.h
@@ -26,4 +26,4 @@ void io_sq_thread_stop(struct io_sq_data *sqd);
 void io_sq_thread_park(struct io_sq_data *sqd);
 void io_sq_thread_unpark(struct io_sq_data *sqd);
 void io_put_sq_data(struct io_sq_data *sqd);
-int io_sqpoll_wait_sq(struct io_ring_ctx *ctx);
+void io_sqpoll_wait_sq(struct io_ring_ctx *ctx);
-- 
2.31.1

