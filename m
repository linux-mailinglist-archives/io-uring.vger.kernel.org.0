Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5DBD6D97F3
	for <lists+io-uring@lfdr.de>; Thu,  6 Apr 2023 15:21:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238357AbjDFNVG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 6 Apr 2023 09:21:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238146AbjDFNU6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 6 Apr 2023 09:20:58 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFEE69EF5;
        Thu,  6 Apr 2023 06:20:28 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id a640c23a62f3a-93071f06a9fso132379566b.2;
        Thu, 06 Apr 2023 06:20:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680787227;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8zdZ1Ga45GnUtwGLx09F3ysxwpFtaVprx6Z0g2Ab66A=;
        b=jZdZldPO+rvoqZVqD7J6wZPEcYq3V3IFHOd42pQGxOMlmAFU3eLylaNjDNRwxkcrPB
         zOTso4OUn+5nB+q7YU6FBUWzOkZd8oBayrT2KTRDXBMPayGs3/2Uocse7+C4GJRh57EG
         vo1pRzRjEpB7pCkbjL5oLu1c4dRnWSNqxV7ZsBr0dHAUWqceIRzbpeR6PvGD4fqZF7ZK
         gBF3l6th6ic1kYwybiyv+qojVGYJLXW9Em92ZN9yZzVXQf4I+1dgCwS6NGUdX+cJXlv0
         XVQK2Ca22aqyWU2+yptUb/WVYUbDSx4TKA9cbl9Cw3eDFNmbHheikpw0jYh2Cru8qeH9
         cFeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680787227;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8zdZ1Ga45GnUtwGLx09F3ysxwpFtaVprx6Z0g2Ab66A=;
        b=zoZnK5s5aQri2u/iGZimD6O1D++WEzpgN4W8YWw7ee/jX2t0vqHc7MDo0vSsN5nZj9
         xesdnLqez94mLGkj8O4MH+5klJgTRyzZAzDVarSwMMA0A2Dtai+x6dksVUanPLq1wqx3
         48CQe4u7wyoORywsnkOs5o1kqs08yAatBkcKDpPk15mTRs0wgCxgzhY6JSCVVjpQ0pMY
         93GJQWixKctWj5l1kWr06tYXOgaGVC4yvKkbMWSz+Gp/9D4SObEwWH2hEU95ftmtHUV2
         Z9i6idhGX1lMVThwdtQDkdjl6w5i9WiDBKJOW65nhgjcKTNffg5JBcNtpMtngc/Bx7jN
         /mEg==
X-Gm-Message-State: AAQBX9edAbpZUnmoWFyjPo/QtRrAvlPj+MU68qkV5cr4dZoQA3YueMIf
        mcRW/JroP9hcf03sIDBGCTPczFC+yNg=
X-Google-Smtp-Source: AKy350ZdIiogIUH6a1na6xPj5geiOARklM8r7A+y+EnG0LvDZ7FKfKXskNnXIlfNcs004hWJggGe5A==
X-Received: by 2002:aa7:c40c:0:b0:500:50f6:dd30 with SMTP id j12-20020aa7c40c000000b0050050f6dd30mr5629587edq.15.1680787227214;
        Thu, 06 Apr 2023 06:20:27 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::2:a638])
        by smtp.gmail.com with ESMTPSA id m20-20020a509994000000b0050470aa444fsm312732edb.51.2023.04.06.06.20.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Apr 2023 06:20:26 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 7/8] io_uring: refactor __io_cq_unlock_post_flush()
Date:   Thu,  6 Apr 2023 14:20:13 +0100
Message-Id: <baa9b8d822f024e4ee01c40209dbbe38d9c8c11d.1680782017.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <cover.1680782016.git.asml.silence@gmail.com>
References: <cover.1680782016.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Separate ->task_complete path in __io_cq_unlock_post_flush().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 8a327a81beaf..0ea50c46f27f 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -627,21 +627,23 @@ static inline void __io_cq_unlock_post(struct io_ring_ctx *ctx)
 	io_cqring_wake(ctx);
 }
 
-static inline void __io_cq_unlock_post_flush(struct io_ring_ctx *ctx)
+static void __io_cq_unlock_post_flush(struct io_ring_ctx *ctx)
 	__releases(ctx->completion_lock)
 {
 	io_commit_cqring(ctx);
-	__io_cq_unlock(ctx);
-	io_commit_cqring_flush(ctx);
 
-	/*
-	 * As ->task_complete implies that the ring is single tasked, cq_wait
-	 * may only be waited on by the current in io_cqring_wait(), but since
-	 * it will re-check the wakeup conditions once we return we can safely
-	 * skip waking it up.
-	 */
-	if (!(ctx->flags & IORING_SETUP_DEFER_TASKRUN))
+	if (ctx->task_complete) {
+		/*
+		 * ->task_complete implies that only current might be waiting
+		 * for CQEs, and obviously, we currently don't. No one is
+		 * waiting, wakeups are futile, skip them.
+		 */
+		io_commit_cqring_flush(ctx);
+	} else {
+		__io_cq_unlock(ctx);
+		io_commit_cqring_flush(ctx);
 		io_cqring_wake(ctx);
+	}
 }
 
 void io_cq_unlock_post(struct io_ring_ctx *ctx)
-- 
2.40.0

