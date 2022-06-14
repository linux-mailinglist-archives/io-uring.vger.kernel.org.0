Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BC1054B0EF
	for <lists+io-uring@lfdr.de>; Tue, 14 Jun 2022 14:37:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244404AbiFNMe0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Jun 2022 08:34:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244942AbiFNMdv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Jun 2022 08:33:51 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF1D14B850
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 05:30:51 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id l2-20020a05600c4f0200b0039c55c50482so6160899wmq.0
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 05:30:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fBuzqx+gzC5/J7sqLEp0sAY1HfeFLOvDJjV1YuH4kBU=;
        b=bMqwj6XSkvQX4CWwa0hFVQ4ImMNMs96CmxzdwYKER52tRrGxzveUlZieIHF23UBFxy
         MlzIKBu5mGMEA0IwsLy2sW0lJN0hSZHR6R6pkTXq8TSmv3qsgSJoaBZh0/fHhFGkzO/q
         Qo4hkP1ZX7BJtjU6+F9DnHP6KXXed5CgkANiEeys5fMSlOkbcxdJpuGsjSFjyWdHYHV7
         ePvLWDxrDhGc8X3+4YJ8L5yNuyZE6eZm7DKom2tquTb5CmuD07WUcX63kDSthhmejr11
         0H2ibYuxvXXHSbrqM4OlDhTAZjGVGe8aNN1E9rsTjH+Afaegq9GaTj4MEX04U/DvBNFb
         j76w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fBuzqx+gzC5/J7sqLEp0sAY1HfeFLOvDJjV1YuH4kBU=;
        b=NJpaWtHtHsCAw3l29VhEn+JgvPZOBnugq1FQPvDMWBWGXKak+6d9n439vl/i0E4qYK
         R+wHpO1ohSvhc52WO0si3RStDqk90y5vXniHamvr1V8Ppiay/IzfeoyfDDAzcLmBSwEe
         0K2v8rOHn8jLNGkXv+sK9ate2V4+3lQc6RwopXRon0J6T07UVLMM/SXseon4eIYADAh5
         cxgp/lNuGysKktadYkIbBT5JgX2RKPfDGwSI3xSzyv2tAgWtzWViZXovKTsGTnoJJcsx
         +mOK6OmLiVk0W6Tbqp0/UqbTrnNqzhCRoGn35n+MhV8GN+fQulo6NigJkcAeycS0Anqm
         RcjA==
X-Gm-Message-State: AOAM531/GjRl8GUSsxVp+ady3IOMayctP98wpKMhz+vZhjx2TGzHVb2f
        rN2BWQQaFG4M+uTO719Au0m1e7WaJMisPQ==
X-Google-Smtp-Source: ABdhPJydbLtvL9CooGEWOM1X7dIkkJNnqUOnr1v3in/bOboA2sOEEkdIiXokmvf/r43l/A9dvux9iA==
X-Received: by 2002:a7b:c205:0:b0:39c:506d:e294 with SMTP id x5-20020a7bc205000000b0039c506de294mr3869257wmi.159.1655209849894;
        Tue, 14 Jun 2022 05:30:49 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id t7-20020a05600c198700b0039c5fb1f592sm12410651wmq.14.2022.06.14.05.30.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 05:30:49 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 12/25] io_uring: don't inline io_put_kbuf
Date:   Tue, 14 Jun 2022 13:29:50 +0100
Message-Id: <84e7d777da1c5cff7d34ec7fa65ad93789a09baf.1655209709.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655209709.git.asml.silence@gmail.com>
References: <cover.1655209709.git.asml.silence@gmail.com>
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
index 9cdbc018fd64..6f2adb481a0d 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -81,6 +81,39 @@ static int io_buffer_add_list(struct io_ring_ctx *ctx,
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

