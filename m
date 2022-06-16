Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1711B54DE15
	for <lists+io-uring@lfdr.de>; Thu, 16 Jun 2022 11:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359481AbiFPJWv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Jun 2022 05:22:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376598AbiFPJWu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Jun 2022 05:22:50 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D7E211174
        for <io-uring@vger.kernel.org>; Thu, 16 Jun 2022 02:22:48 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id a10so422660wmj.5
        for <io-uring@vger.kernel.org>; Thu, 16 Jun 2022 02:22:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+oR3rNXZgU1ixzRI7JxN2AwlqFap+l1SjK5ceoxKnGA=;
        b=BwAdIGhAhpc7c501cFHLJotqPAyCzl6wkmPjxgsOnqKqo6F6kEje8zJHT5kcObE8FD
         Buu+qfSy9D9VEvXN3F9x3p1ixGCZU2+M7cs4S3rqcfxhToxXYiSYGwIfizNZy03hbQS8
         o+Ek7uX/l854KRgrhxAhzDd+U+VJFvTC6lXu6bIMor7jsoZvgAAud7IFJ6npAnGzB4yB
         DEDEpB3pStbqJ9y+1P4WpOj0o/O2vc/PcRfOtN6mrTxbBImxUCC9B+OwsxtQfJkevz6W
         e0H3XYZG/j+R8Kwg8oQc+fUQLjFvSCF/20wXPAPNvAjVRsHNMaplGzrXN2pFJ7gS02+G
         bPUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+oR3rNXZgU1ixzRI7JxN2AwlqFap+l1SjK5ceoxKnGA=;
        b=lDRN+PTvfPA1fAbTj6j1H0oEaR4XdXqlwWdKO5PxZXNRuFCnZSIPU16YipEJbYnHgq
         h9fn8G5THZA0MHphTZdK/bRSXmU0bWNnCPGpzivsyZqd0MY3J97TpQw2dDq+0h2dFiHb
         W+S/4ZamV+0xtCIOsjn/8/EWcetpqqprwQaglZODfm3rbWz6H8hTQ9wtK+XZ9XZyL6PG
         LJoghzZaYWgjqkBYK8Dk+FBzAP7uav1Leq2uXAHZa2cXV+VBZsyYxBkpxnpUSloUEm/M
         65vsGM1QYegUeSI3RvqTENKAxwRxdZh4YBzgQVX1JDudwiTLXIak2WIGXyMtC2Jk71v/
         DhfA==
X-Gm-Message-State: AOAM530OGcPAWeZmc96mvKK7/YGPHQxmBEtxzHa50w7PpGFyqi94dit+
        VVDyTSt168PMfhc2CL8/sFwYW0mWMFhrYA==
X-Google-Smtp-Source: ABdhPJwR2kkyCWmw0lVe9Oxc+RMP0YzPJG7P2+tVLDkV33mFEb41aT+tnP6UpHd2iUqVKX9HFvbPYg==
X-Received: by 2002:a05:600c:348d:b0:39c:652b:5153 with SMTP id a13-20020a05600c348d00b0039c652b5153mr14575342wmq.24.1655371367081;
        Thu, 16 Jun 2022 02:22:47 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id s6-20020a1cf206000000b0039c975aa553sm1695221wmc.25.2022.06.16.02.22.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jun 2022 02:22:46 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next v3 04/16] io_uring: don't inline io_put_kbuf
Date:   Thu, 16 Jun 2022 10:22:00 +0100
Message-Id: <2e21ccf0be471ffa654032914b9430813cae53f8.1655371007.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655371007.git.asml.silence@gmail.com>
References: <cover.1655371007.git.asml.silence@gmail.com>
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

io_put_kbuf() is huge, don't bloat the kernel with inlining.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/kbuf.c | 33 +++++++++++++++++++++++++++++++++
 io_uring/kbuf.h | 38 ++++++--------------------------------
 2 files changed, 39 insertions(+), 32 deletions(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 5885343705bd..223d9db2ba94 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -82,6 +82,39 @@ static int io_buffer_add_list(struct io_ring_ctx *ctx,
 	return xa_err(xa_store(&ctx->io_bl_xa, bgid, bl, GFP_KERNEL));
 }
 
+unsigned int __io_put_kbuf(struct io_kiocb *req, unsigned issue_flags)
+{
+	unsigned int cflags;
+
+	/*
+	 * We can add this buffer back to two lists:
+	 *
+	 * 1) The io_buffers_cache list. This one is protected by the
+	 *    ctx->uring_lock. If we already hold this lock, add back to this
+	 *    list as we can grab it from issue as well.
+	 * 2) The io_buffers_comp list. This one is protected by the
+	 *    ctx->completion_lock.
+	 *
+	 * We migrate buffers from the comp_list to the issue cache list
+	 * when we need one.
+	 */
+	if (req->flags & REQ_F_BUFFER_RING) {
+		/* no buffers to recycle for this case */
+		cflags = __io_put_kbuf_list(req, NULL);
+	} else if (issue_flags & IO_URING_F_UNLOCKED) {
+		struct io_ring_ctx *ctx = req->ctx;
+
+		spin_lock(&ctx->completion_lock);
+		cflags = __io_put_kbuf_list(req, &ctx->io_buffers_comp);
+		spin_unlock(&ctx->completion_lock);
+	} else {
+		lockdep_assert_held(&req->ctx->uring_lock);
+
+		cflags = __io_put_kbuf_list(req, &req->ctx->io_buffers_cache);
+	}
+	return cflags;
+}
+
 static void __user *io_provided_buffer_select(struct io_kiocb *req, size_t *len,
 					      struct io_buffer_list *bl)
 {
diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
index 80b6df2c7535..5da3d4039aed 100644
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -47,6 +47,8 @@ int io_provide_buffers(struct io_kiocb *req, unsigned int issue_flags);
 int io_register_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg);
 int io_unregister_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg);
 
+unsigned int __io_put_kbuf(struct io_kiocb *req, unsigned issue_flags);
+
 static inline bool io_do_buffer_select(struct io_kiocb *req)
 {
 	if (!(req->flags & REQ_F_BUFFER_SELECT))
@@ -70,7 +72,8 @@ static inline void io_kbuf_recycle(struct io_kiocb *req, unsigned issue_flags)
 	__io_kbuf_recycle(req, issue_flags);
 }
 
-static unsigned int __io_put_kbuf(struct io_kiocb *req, struct list_head *list)
+static inline unsigned int __io_put_kbuf_list(struct io_kiocb *req,
+					      struct list_head *list)
 {
 	if (req->flags & REQ_F_BUFFER_RING) {
 		if (req->buf_list)
@@ -90,44 +93,15 @@ static inline unsigned int io_put_kbuf_comp(struct io_kiocb *req)
 
 	if (!(req->flags & (REQ_F_BUFFER_SELECTED|REQ_F_BUFFER_RING)))
 		return 0;
-	return __io_put_kbuf(req, &req->ctx->io_buffers_comp);
+	return __io_put_kbuf_list(req, &req->ctx->io_buffers_comp);
 }
 
 static inline unsigned int io_put_kbuf(struct io_kiocb *req,
 				       unsigned issue_flags)
 {
-	unsigned int cflags;
 
 	if (!(req->flags & (REQ_F_BUFFER_SELECTED|REQ_F_BUFFER_RING)))
 		return 0;
-
-	/*
-	 * We can add this buffer back to two lists:
-	 *
-	 * 1) The io_buffers_cache list. This one is protected by the
-	 *    ctx->uring_lock. If we already hold this lock, add back to this
-	 *    list as we can grab it from issue as well.
-	 * 2) The io_buffers_comp list. This one is protected by the
-	 *    ctx->completion_lock.
-	 *
-	 * We migrate buffers from the comp_list to the issue cache list
-	 * when we need one.
-	 */
-	if (req->flags & REQ_F_BUFFER_RING) {
-		/* no buffers to recycle for this case */
-		cflags = __io_put_kbuf(req, NULL);
-	} else if (issue_flags & IO_URING_F_UNLOCKED) {
-		struct io_ring_ctx *ctx = req->ctx;
-
-		spin_lock(&ctx->completion_lock);
-		cflags = __io_put_kbuf(req, &ctx->io_buffers_comp);
-		spin_unlock(&ctx->completion_lock);
-	} else {
-		lockdep_assert_held(&req->ctx->uring_lock);
-
-		cflags = __io_put_kbuf(req, &req->ctx->io_buffers_cache);
-	}
-
-	return cflags;
+	return __io_put_kbuf(req, issue_flags);
 }
 #endif
-- 
2.36.1

