Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21CBB515317
	for <lists+io-uring@lfdr.de>; Fri, 29 Apr 2022 19:56:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379838AbiD2SAL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 29 Apr 2022 14:00:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379840AbiD2SAL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 29 Apr 2022 14:00:11 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1284AD39B4
        for <io-uring@vger.kernel.org>; Fri, 29 Apr 2022 10:56:52 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id i20so8877835ion.0
        for <io-uring@vger.kernel.org>; Fri, 29 Apr 2022 10:56:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4LRQmmYxLF1byjl97YsI7bWFGDwUa0KmcfXskK+0pgo=;
        b=hRm50yO6G1kygB/Xjh9ODjM3qykpttj6Y1w8T6/zmIV83R6lhqkpCd6K/y0s1LPD4A
         K/NTdmEj8S5O2s9vgv69AflIkNehYG3lBp0J9+Fqt19MWKouB0PqCY9KaYKB9eRgm0no
         PLMnpfG1TFX62gF1+iYbrOsB075Q68RoPV10ouUTaDVUg1qAqzL2DKtaM/gPa6vNJYt6
         Ofdl1vPbkobShmJZG6jgQAy2948kLfx4f/ILr6ScLCLwzUEyOSSSAPJPqW4VAmmxoSyE
         QENstdNXD9StYPOSZVQ+9xnoSYKdNlQB20HVB++nAKQ0EdqjQLFfAzJk/lIGCbUa8LT9
         HXnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4LRQmmYxLF1byjl97YsI7bWFGDwUa0KmcfXskK+0pgo=;
        b=lOcnr0837iHwO0qYpiuOowz8ZCl2Vxhdg9bkNsGfgtTUpvFFwrWxdxmSsmIRf3V57q
         CGveGwOyZGK5Cwl/48XgvMIIMqZY+XQBIqLSRWRH4lAcQa5hWDnHVLJybR73we6QJqBA
         Asel0u4ezcPN+BnGPO0BddcrUxLqa71Q3saG6ZQ2n5JYlwIn6Un98ajQWkHZPbHFwKPM
         dm9CXCqVuLyJMiwiXBzgaPOkQdu7Rt6Qp8VVXvfJKwm+vzjES2etjcn3kss8w8Sj26fH
         1rI2wUUFS02kTRT2cTsJn/dIr1pIOzJlyAzHALQROiCDDfh+65bWqaCcNCl6C36lWo65
         rvDw==
X-Gm-Message-State: AOAM5321WwkUn0NdPHI/e7u7B1uSFhSuIwaUfDrLJw2hZ49i+yuPuc8E
        xTr67ocCGN+BIutvIwTSDHm8u+8Uwv7ZCw==
X-Google-Smtp-Source: ABdhPJwyzFN/zBdRSZUtRjOUDgaQ1BC7UQ6yD2LXYPCYFPqnXAC2BluO1flrf8ZnuXFgUvlgFzjPaA==
X-Received: by 2002:a02:1641:0:b0:321:2f51:1591 with SMTP id a62-20020a021641000000b003212f511591mr198029jaa.251.1651255009776;
        Fri, 29 Apr 2022 10:56:49 -0700 (PDT)
Received: from m1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id o9-20020a02cc29000000b0032b3a78179dsm744082jap.97.2022.04.29.10.56.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Apr 2022 10:56:49 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 10/11] io_uring: relocate io_buffer_get_list()
Date:   Fri, 29 Apr 2022 11:56:34 -0600
Message-Id: <20220429175635.230192-11-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220429175635.230192-1-axboe@kernel.dk>
References: <20220429175635.230192-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

In preparation for calling it from __io_put_kbuf(), move it up a bit to
avoid a forward declaration.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 42 +++++++++++++++++++++---------------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 9e1dd33980d8..42a952cb073b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1558,6 +1558,27 @@ static inline void io_req_set_rsrc_node(struct io_kiocb *req,
 	}
 }
 
+static struct io_buffer_list *io_buffer_get_list(struct io_ring_ctx *ctx,
+						 unsigned int bgid)
+{
+	struct list_head *hash_list;
+	struct io_buffer_list *bl;
+
+	if (bgid == ctx->io_bl_bgid)
+		return ctx->io_bl_last;
+
+	hash_list = &ctx->io_buffers[hash_32(bgid, IO_BUFFERS_HASH_BITS)];
+	list_for_each_entry(bl, hash_list, list) {
+		if (bl->bgid == bgid || bgid == -1U) {
+			ctx->io_bl_bgid = bgid;
+			ctx->io_bl_last = bl;
+			return bl;
+		}
+	}
+
+	return NULL;
+}
+
 static unsigned int __io_put_kbuf(struct io_kiocb *req, struct list_head *list)
 {
 	struct io_buffer *kbuf = req->kbuf;
@@ -1614,27 +1635,6 @@ static inline unsigned int io_put_kbuf(struct io_kiocb *req,
 	return cflags;
 }
 
-static struct io_buffer_list *io_buffer_get_list(struct io_ring_ctx *ctx,
-						 unsigned int bgid)
-{
-	struct list_head *hash_list;
-	struct io_buffer_list *bl;
-
-	if (bgid == ctx->io_bl_bgid)
-		return ctx->io_bl_last;
-
-	hash_list = &ctx->io_buffers[hash_32(bgid, IO_BUFFERS_HASH_BITS)];
-	list_for_each_entry(bl, hash_list, list) {
-		if (bl->bgid == bgid || bgid == -1U) {
-			ctx->io_bl_bgid = bgid;
-			ctx->io_bl_last = bl;
-			return bl;
-		}
-	}
-
-	return NULL;
-}
-
 static void io_kbuf_recycle(struct io_kiocb *req, unsigned issue_flags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
-- 
2.35.1

