Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3FE663D953
	for <lists+io-uring@lfdr.de>; Wed, 30 Nov 2022 16:23:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbiK3PXb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 30 Nov 2022 10:23:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229894AbiK3PX2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 30 Nov 2022 10:23:28 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3391177210
        for <io-uring@vger.kernel.org>; Wed, 30 Nov 2022 07:23:27 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id f18so5560337wrj.5
        for <io-uring@vger.kernel.org>; Wed, 30 Nov 2022 07:23:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NKZvNdTv2UR+lj5KsPKwOG/zN0kLMd+y14jmvQ1MFlY=;
        b=ORbnk+ZpgNEqqfAZdFbRtrSot8of8CrFkhsabWaOFtu4odoGjCmnNt6rsLPTw0xfZ/
         W/2FJ2fm5Pqw/11X7cTikoamajfwqTUXnb5NiQ5gQxvpMBrCOVutbCsDxVUIMvGt/uLN
         QieqdigvZfI3adYmhmO4USP96bv6AFEGH3Z6nIQPGpiWeX0N45Oy7Q7LZ8FHwstWUsg9
         hpbY9pWGerbSvyaWs0UvDQ16ocGjeWC7zplbFe4miEp5BitOCTWf5PVZUntkvGYRuSFO
         rBCc+25/CfK161oRkoYLoAYdMT9vGJwcd+RLgpYTaBkLSxTMw441REnEfed+Er4mn7Ux
         rWwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NKZvNdTv2UR+lj5KsPKwOG/zN0kLMd+y14jmvQ1MFlY=;
        b=NB3Q2WeA4VWs6YDP4UGYMdx9OAvwSD/dMiQGLvJoir8gsgdDhywmV3K23cXCZAZVMO
         uDxQZHq/nHzxvT63Lo+CEouiooGXm8eZ9j9Je64ixnyPJcTj3L1HrpxJMmminTWMBRIp
         7iiraMxFrKmqP0QVVBiIBrtARhOg1eHUQgUGhPE7c1RoW89dnChWNnbcaOnmbSf+UkJ1
         E7vgsp/+stUf5CSUZiSVwD2Lr7Yxzf/he0x0U+/usdBJtZEsoUzw8UDFzW5MeDu7FUsm
         GxaLCeKrXtYX4BLpLFCKmAK0jj7YbH8Lv9LGdWHG0OeytqGF5Q1rK4AQEG35quhEB2cf
         Trkw==
X-Gm-Message-State: ANoB5pk7dkP+XPYIXrVyLeWFZwmLJ5YFuTU95pbgBSClR8YDe3/XQhc4
        2eQ3zZhr9XQSnphktVs/Rfse7o8LDm4=
X-Google-Smtp-Source: AA0mqf51EnaMsUKxzocTCzURQAIYNECjeeof0ps6lGyLBbXCUIABpp0nO2kXDEvJ/qvtQlqjLUvFXQ==
X-Received: by 2002:adf:e28b:0:b0:241:c2c3:26c8 with SMTP id v11-20020adfe28b000000b00241c2c326c8mr34788307wri.278.1669821805564;
        Wed, 30 Nov 2022 07:23:25 -0800 (PST)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:97d])
        by smtp.gmail.com with ESMTPSA id v14-20020a05600c444e00b003a1980d55c4sm6381844wmn.47.2022.11.30.07.23.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Nov 2022 07:23:25 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 6/9] io_uring: don't raw spin unlock to match cq_lock
Date:   Wed, 30 Nov 2022 15:21:56 +0000
Message-Id: <4ca4f0564492b90214a190cd5b2a6c76522de138.1669821213.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1669821213.git.asml.silence@gmail.com>
References: <cover.1669821213.git.asml.silence@gmail.com>
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

There is one newly added place when we lock ring with io_cq_lock() but
unlocking is hand coded calling spin_unlock directly. It's ugly and
troublesome in the long run.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 2 +-
 io_uring/io_uring.h | 5 +++++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 15d285d8ce0f..c30765579a8e 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -860,7 +860,7 @@ bool io_aux_cqe(struct io_ring_ctx *ctx, bool defer, u64 user_data, s32 res, u32
 		io_cq_lock(ctx);
 		__io_flush_post_cqes(ctx);
 		/* no need to flush - flush is deferred */
-		spin_unlock(&ctx->completion_lock);
+		io_cq_unlock(ctx);
 	}
 
 	/* For defered completions this is not as strict as it is otherwise,
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 062899b1fe86..2277c05f52a6 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -93,6 +93,11 @@ static inline void io_cq_lock(struct io_ring_ctx *ctx)
 	spin_lock(&ctx->completion_lock);
 }
 
+static inline void io_cq_unlock(struct io_ring_ctx *ctx)
+{
+	spin_unlock(&ctx->completion_lock);
+}
+
 void io_cq_unlock_post(struct io_ring_ctx *ctx);
 
 static inline struct io_uring_cqe *io_get_cqe_overflow(struct io_ring_ctx *ctx,
-- 
2.38.1

