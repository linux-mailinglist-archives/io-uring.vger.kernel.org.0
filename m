Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 676D94F8009
	for <lists+io-uring@lfdr.de>; Thu,  7 Apr 2022 15:06:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343535AbiDGNHs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 7 Apr 2022 09:07:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235552AbiDGNHq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 7 Apr 2022 09:07:46 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7E945BE6E
        for <io-uring@vger.kernel.org>; Thu,  7 Apr 2022 06:05:45 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id v64-20020a1cac43000000b0038cfd1b3a6dso5621962wme.5
        for <io-uring@vger.kernel.org>; Thu, 07 Apr 2022 06:05:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NYHlkyB791plEbX6Z4sKGvepIj48CC87NxaS6YoJCnk=;
        b=DGImBhTsbdmSxCDYdBkILCL1PtOvlO7GkCb2xXIgsOzJZfJc4vzkff8FfQ8s2XhZS2
         bWdbOIRq/RUMIGIQNJUYSUa7EYb58itZUKVAQ+yWpx6BTX/xIqMu4kk5LpT7Fwqm1lD0
         MtfS0n0NnXjf57VG0PjwoQqXZAQcvQpCVSKjDq3yIQTXYZa3IBzoEHhycus8NWPpTHPH
         Jaqh9GtK8yuzpgbqrsKeyMy+yJmX9mK1q2mB32LYZUOhTfNhdIxlssiy61mkOK0ydcv7
         lqHPhX4739oS+KR4VALPKlU/BFcDApzzxSjk+shkvl/5axX+HhneW9fGD9Hn/gd0nvB5
         bXcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NYHlkyB791plEbX6Z4sKGvepIj48CC87NxaS6YoJCnk=;
        b=raD/GDdp2GeAlxx1qMa0kTPpvfk6dSbqJMPtOxHlNg0hZCr86nnFwYm8aVt2Xo4OXb
         7GX4Qrm8+WnqOQ2eZzmwDOiLjL5zH73kfm2CSeAf/Lu+9YxPptJTTnXCYbB9YgHbKLla
         58qTqNvMeM3fn6HrPqNBaG+Ct2fjVu5b3scNKFAWAwI6vrq5i+1XqF7TNanSrUr3/rCT
         GC928q6Q+Z01i37abY5sLZAcucGOdQUh5Ots5VdrOq0NYyep/7mDA8sXLXpifMk6sG9e
         3uYT0CuzEuG77xWJJ8+9wekmOriqHSUPqn2xyR09ahe8TFs3O5L4vFM9cJBHhaxmuhrJ
         w+vQ==
X-Gm-Message-State: AOAM533/hC4Aip36BYSpniE/2RbkzFrt9EYCG8XWuv+uqVT1zG+blvr5
        irVG1CV4WMUZQyqvkyHybx23xpa7wrw=
X-Google-Smtp-Source: ABdhPJzPseGyuNtb4FZ4hw3ZABI7uTCd3bMA7MQ3IYhjPdR9LQGkSwEPvkiHOR+GqoGJAV4PBo2ppw==
X-Received: by 2002:a7b:c30e:0:b0:37f:a63d:3d1f with SMTP id k14-20020a7bc30e000000b0037fa63d3d1fmr12079135wmj.178.1649336744173;
        Thu, 07 Apr 2022 06:05:44 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.255.237.149])
        by smtp.gmail.com with ESMTPSA id v15-20020a056000144f00b002057eac999fsm17640306wrx.76.2022.04.07.06.05.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Apr 2022 06:05:43 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 2/2] io_uring: use nospec annotation for more indexes
Date:   Thu,  7 Apr 2022 14:05:05 +0100
Message-Id: <b01ef5ee83f72ed35ad525912370b729f5d145f4.1649336342.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1649336342.git.asml.silence@gmail.com>
References: <cover.1649336342.git.asml.silence@gmail.com>
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

There are still several places that using pre array_index_nospec()
indexes, fix them up.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c8993a656c1f..8b207dbdfb54 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8919,7 +8919,7 @@ static int io_close_fixed(struct io_kiocb *req, unsigned int issue_flags)
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_fixed_file *file_slot;
 	struct file *file;
-	int ret, i;
+	int ret;
 
 	io_ring_submit_lock(ctx, issue_flags);
 	ret = -ENXIO;
@@ -8932,8 +8932,8 @@ static int io_close_fixed(struct io_kiocb *req, unsigned int issue_flags)
 	if (ret)
 		goto out;
 
-	i = array_index_nospec(offset, ctx->nr_user_files);
-	file_slot = io_fixed_file_slot(&ctx->file_table, i);
+	offset = array_index_nospec(offset, ctx->nr_user_files);
+	file_slot = io_fixed_file_slot(&ctx->file_table, offset);
 	ret = -EBADF;
 	if (!file_slot->file_ptr)
 		goto out;
@@ -8989,8 +8989,7 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 
 		if (file_slot->file_ptr) {
 			file = (struct file *)(file_slot->file_ptr & FFS_MASK);
-			err = io_queue_rsrc_removal(data, up->offset + done,
-						    ctx->rsrc_node, file);
+			err = io_queue_rsrc_removal(data, i, ctx->rsrc_node, file);
 			if (err)
 				break;
 			file_slot->file_ptr = 0;
@@ -9672,7 +9671,7 @@ static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
 
 		i = array_index_nospec(offset, ctx->nr_user_bufs);
 		if (ctx->user_bufs[i] != ctx->dummy_ubuf) {
-			err = io_queue_rsrc_removal(ctx->buf_data, offset,
+			err = io_queue_rsrc_removal(ctx->buf_data, i,
 						    ctx->rsrc_node, ctx->user_bufs[i]);
 			if (unlikely(err)) {
 				io_buffer_unmap(ctx, &imu);
-- 
2.35.1

