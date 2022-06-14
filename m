Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36D9C54B37D
	for <lists+io-uring@lfdr.de>; Tue, 14 Jun 2022 16:42:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238564AbiFNOiB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Jun 2022 10:38:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243425AbiFNOh4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Jun 2022 10:37:56 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71892B7F2
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 07:37:54 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id r123-20020a1c2b81000000b0039c1439c33cso4910385wmr.5
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 07:37:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fBuzqx+gzC5/J7sqLEp0sAY1HfeFLOvDJjV1YuH4kBU=;
        b=SwzGMVM9xEcKeBEuYMvTsD0VVKufNx4b2jRMEwDx1+x9LNRb9naC3n+2yqUljU+lEK
         j0mQOII0K+n03YYEDH77nbnfAB5S8/P+B3Gokt9D4iwcsdZ7HRRXsd7EhGOiHaNQBWrW
         n8Rgg0LuwRvXChg64edRBRRFRLeXzvwRco099pNedxD9K9/xdiYuhTXEdHeiZt6hQnrR
         SzJytPxuLFvPjLjIAsxKviXeaocM7M4+MVKf01ArynNPT4iU5j6K2SVFRM8TUHTExRpu
         OMomoQE834AEYC+YKYHOaDLkIODyEarBpObK2hu9i1SeLuRkZQQ97X7IPW9c6M40WmHV
         D7YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fBuzqx+gzC5/J7sqLEp0sAY1HfeFLOvDJjV1YuH4kBU=;
        b=6wMfM1paCJFl7UaT/UD76Yaxi4ICOCcfd9+aHmi7gMnLHQM+2awpUyCcJCEWPshbD3
         hPiNnwM3iBOoJlImx12y8CjYWPFuEsvy7kqX1Nny4XAkiV+YF6HIBDbb1ibQcpD1RD3H
         EH5jH+RH/8fs6ed3IE0uHbT6ipNoXbKbFyzOH2HFmsRzRla6NtN6h4b/BVMIamAyaet3
         AAjMttlJIrfbje9uf1FioIe/5C0Xy6xoV8B53cNcbKz3wht7mODggwkQWzhOXtw1C6h3
         a9MAfk+3RUzJxvqNpKRFnM+F6aFx7QM2ch815OjboS4pm2/zHSBaPbKkAzXG3krS4eVZ
         Ut6A==
X-Gm-Message-State: AOAM5327mq4qzpdzbTZDssbLV2gg27y/CuCdcPtBDY1fQAEhXXYITvmz
        6kr5qTsGLUjN3PHm3+w5aXAPGuhxu9FITQ==
X-Google-Smtp-Source: ABdhPJwfnyxEwbO16KN33XtsjrR/RbW/9b/wWqBWOC+zYPmeSh10DAyzyvFRCbfrw7ECuYGxHmelZw==
X-Received: by 2002:a1c:cc07:0:b0:39c:7416:6a43 with SMTP id h7-20020a1ccc07000000b0039c74166a43mr4408303wmb.130.1655217472674;
        Tue, 14 Jun 2022 07:37:52 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id a4-20020adff7c4000000b0021033caa332sm12353064wrq.42.2022.06.14.07.37.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 07:37:52 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next v2 12/25] io_uring: don't inline io_put_kbuf
Date:   Tue, 14 Jun 2022 15:37:02 +0100
Message-Id: <8abee74fa6f3c6565b69a0facfaffafb3ed4bf8a.1655213915.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655213915.git.asml.silence@gmail.com>
References: <cover.1655213915.git.asml.silence@gmail.com>
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

