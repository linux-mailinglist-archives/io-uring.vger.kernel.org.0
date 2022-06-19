Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B40D6550A35
	for <lists+io-uring@lfdr.de>; Sun, 19 Jun 2022 13:26:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236544AbiFSL0z (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 19 Jun 2022 07:26:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236277AbiFSL0v (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 19 Jun 2022 07:26:51 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BA9511A07
        for <io-uring@vger.kernel.org>; Sun, 19 Jun 2022 04:26:50 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id i81-20020a1c3b54000000b0039c76434147so6450715wma.1
        for <io-uring@vger.kernel.org>; Sun, 19 Jun 2022 04:26:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fewyXD2tWiUZFUHM4SZq/xvzdVDlm/vCOa9X2cT+Fxg=;
        b=UZ1RCxFwvu4KEQotu8sI5qmGp3eeHt0nAIZ64Xt/YhEzpw6qUd0KJQurAZaUpdS4r/
         9wNqdi8Q7ETWL00BEE0s0kKg4Un/2GTPD3yuczCflPzYgX4cSPQ7ZV5N01P1AH5Odrin
         Q/QgcDPhAAPOGFiVeoxaYMu1MV1clEvCNhG0aSEf4peCifOPLTRKBoIAdT34t//0pLN3
         9/gsikg3hs4bZ838QIfUmn9mh2IJjT1C6Y6QwlfCopx4/wjCGcNMvr1TevhflWK4LLud
         8qecUvjyCElcC2+dYGu1XUwPm+6BpCU7JuyEk1fFpCZTEUCNESLKK9opvhLaFS4GF0qQ
         EAqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fewyXD2tWiUZFUHM4SZq/xvzdVDlm/vCOa9X2cT+Fxg=;
        b=8F2VPoLGqJX0ENtPiWxir0+WC6fSgga7cpwYxsAGG8VxeS8+nhuyfqeoXCTs1fwcaG
         igfEpl9o3FI6pBWO1SJyJmpWMQo48dZEMyAQu8Y5QVAKOSpKitnQGrekqWdUt6DSPmkK
         kijYjroUUl5nES7FzpiWWVG8ccgbhfmtHeYZAZ7GpTfkvJb30Rb6PDhf/cry1ZS51Cr4
         y9Fr4YD2z7RK44y1TGRS2pucCmAiZw0Iuhyi7AnYaT0IMQl+FzOGqEMzV4rcDjCWD57r
         z+dSGhDBdgPt0XmmsVA2UGNoO6w/FLjOA7SlNXuOqOPr77zI10h/HsR7XitquN8gP3bZ
         gkvg==
X-Gm-Message-State: AJIora9dtFxXfxMdc08SqkEO/lLK4/uFJqBLZx2BSGaPWe3lq3HF6hLP
        zOFqwog4TaKM7BmhbXg8qsACPIf7OXMPRw==
X-Google-Smtp-Source: AGRyM1soDDcnzV6nzuiaK7DN3FrLsLWHOCRH3emb49y9k5ggriqOOGm95xSWCxwGXkdppTpfMR15OQ==
X-Received: by 2002:a05:600c:3d94:b0:39e:da8a:1791 with SMTP id bi20-20020a05600c3d9400b0039eda8a1791mr17866882wmb.20.1655638008507;
        Sun, 19 Jun 2022 04:26:48 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id y14-20020adfee0e000000b002119c1a03e4sm9921653wrn.31.2022.06.19.04.26.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jun 2022 04:26:48 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 7/7] io_uring: add io_commit_cqring_flush()
Date:   Sun, 19 Jun 2022 12:26:10 +0100
Message-Id: <69cec30d9e4bfcf1a0c63e61ed6323cadc53d516.1655637157.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655637157.git.asml.silence@gmail.com>
References: <cover.1655637157.git.asml.silence@gmail.com>
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

Since __io_commit_cqring_flush users moved to different files, introduce
io_commit_cqring_flush() helper and encapsulate all flags testing details
inside.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 5 +----
 io_uring/io_uring.h | 6 ++++++
 io_uring/rw.c       | 5 +----
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index cff046b0734b..c24c285dfac9 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -529,10 +529,7 @@ void __io_commit_cqring_flush(struct io_ring_ctx *ctx)
 
 static inline void io_cqring_ev_posted(struct io_ring_ctx *ctx)
 {
-	if (unlikely(ctx->off_timeout_used || ctx->drain_active ||
-		     ctx->has_evfd))
-		__io_commit_cqring_flush(ctx);
-
+	io_commit_cqring_flush(ctx);
 	io_cqring_wake(ctx);
 }
 
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index bb8367908472..76cfb88af812 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -242,4 +242,10 @@ static inline void io_req_complete_defer(struct io_kiocb *req)
 	wq_list_add_tail(&req->comp_list, &state->compl_reqs);
 }
 
+static inline void io_commit_cqring_flush(struct io_ring_ctx *ctx)
+{
+	if (unlikely(ctx->off_timeout_used || ctx->drain_active || ctx->has_evfd))
+		__io_commit_cqring_flush(ctx);
+}
+
 #endif
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 5f24db65a81d..17707e78ab01 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -948,10 +948,7 @@ int io_write(struct io_kiocb *req, unsigned int issue_flags)
 
 static void io_cqring_ev_posted_iopoll(struct io_ring_ctx *ctx)
 {
-	if (unlikely(ctx->off_timeout_used || ctx->drain_active ||
-		     ctx->has_evfd))
-		__io_commit_cqring_flush(ctx);
-
+	io_commit_cqring_flush(ctx);
 	if (ctx->flags & IORING_SETUP_SQPOLL)
 		io_cqring_wake(ctx);
 }
-- 
2.36.1

