Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26FB4346329
	for <lists+io-uring@lfdr.de>; Tue, 23 Mar 2021 16:43:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232810AbhCWPlT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Mar 2021 11:41:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232931AbhCWPlM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Mar 2021 11:41:12 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86D77C061574
        for <io-uring@vger.kernel.org>; Tue, 23 Mar 2021 08:41:11 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id a132-20020a1c668a0000b029010f141fe7c2so11057108wmc.0
        for <io-uring@vger.kernel.org>; Tue, 23 Mar 2021 08:41:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=kLEg/MkTIxIGvWnAPLlr/aOroU25meTswkNLYOEYUs4=;
        b=g5dCMwuZNr6qezS6pUQHwUb9f/M0ps1b1hWIGxpnuBMBvjiSlqs3Y4AEDxrqFff0cn
         +piRfauddOO/2HZ/LbW72B3ylsKKI9VU3OOVu3d1ww2CSI6LKk0KcgUTws2ur31zpOVd
         DAsU5FnTsL3e/MZrJejrKiE3uQu2QDALgfEYBDqsM9Xk5PeUEAJsQ9WGfE7hGEvsouUx
         x2Xt8Z4HjAmEcp7q3uqc4qT8jINU7Jtfm49TEeC0KU7Bq4GyaB6pxLupKxBJPdWpuW5y
         HO2GKvNgovf9m0H7pIMHj//+OJtNRQzn0jUOe8HYcTXAgAF2DMwPfAUY2yGcbkOXH1R0
         dLKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kLEg/MkTIxIGvWnAPLlr/aOroU25meTswkNLYOEYUs4=;
        b=hRIiAWRy5AW2FzDmaF12O0T7qO/BknPPSEfnmODmiDj6RR6WxFjG085QJXN/WSarGi
         mFm9jj2x2vU45NRweBVyxcm1DOhZBxieCBsR1eI1mm7Vdb/j9/DQ/dKioMVcY8xP0fUo
         H0+SfesS6IMi3Jxq4hZWMkxPc7a28gf9QiVHUeYvcYg3yxFV4oG+VgYl0lJcBlqnkLPd
         tDLMfnz2FHlhm6egClFznyH7iwMyTE5TrmYJOAZEp680z39GL6X1zfjxuoV4gtDhJx+y
         QqUbLk2cKDLugp7BMvS6jBPANsah08+pHrLFVhFz1As9mo8t+T40BglazydMUespImsj
         eK9w==
X-Gm-Message-State: AOAM533kGF/+GMnfr5o/0VdRnNdtokrZurkPBKyPVMMMbo43xbOWWCDz
        rttVzBRCzalLxxg0XPhmkzs=
X-Google-Smtp-Source: ABdhPJyY6pU0kCtQQrb3SPpsJMCaW3p1nI3jMoZ/GjZ1zDHKcxRoGLcP4VW+hZGk/jFQkkHPRk5dIw==
X-Received: by 2002:a1c:5416:: with SMTP id i22mr3944311wmb.146.1616514070300;
        Tue, 23 Mar 2021 08:41:10 -0700 (PDT)
Received: from localhost.localdomain ([85.255.236.168])
        by smtp.gmail.com with ESMTPSA id u2sm24493271wrp.12.2021.03.23.08.41.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Mar 2021 08:41:09 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 4/7] io_uring: encapsulate rsrc node manipulations
Date:   Tue, 23 Mar 2021 15:36:55 +0000
Message-Id: <3ecf83200d3245d7dc9e897ef489ea5b0dced3f0.1616513699.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1616513699.git.asml.silence@gmail.com>
References: <cover.1616513699.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_rsrc_node_get() and io_rsrc_node_set() are always used together,
merge them into one so most users don't even see io_rsrc_node and don't
need to care about it.

It helped to catch io_sqe_files_register() inferring rsrc data argument
for get and set differently, not a problem but a good sign.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 39 +++++++++++++--------------------------
 1 file changed, 13 insertions(+), 26 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index bcbb946db326..8b0d0774890a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6959,8 +6959,17 @@ static inline void io_rsrc_ref_unlock(struct io_ring_ctx *ctx)
 
 static void io_rsrc_node_set(struct io_ring_ctx *ctx,
 			     struct io_rsrc_data *rsrc_data,
-			     struct io_rsrc_node *rsrc_node)
+			     void (*rsrc_put)(struct io_ring_ctx *ctx,
+			                      struct io_rsrc_put *prsrc))
 {
+	struct io_rsrc_node *rsrc_node = ctx->rsrc_backup_node;
+
+	WARN_ON_ONCE(!rsrc_node);
+
+	ctx->rsrc_backup_node = NULL;
+	rsrc_node->rsrc_data = rsrc_data;
+	rsrc_node->rsrc_put = rsrc_put;
+
 	io_rsrc_ref_lock(ctx);
 	rsrc_data->node = rsrc_node;
 	list_add_tail(&rsrc_node->node, &ctx->rsrc_ref_list);
@@ -6988,28 +6997,11 @@ static int io_rsrc_node_prealloc(struct io_ring_ctx *ctx)
 	return ctx->rsrc_backup_node ? 0 : -ENOMEM;
 }
 
-static struct io_rsrc_node *
-io_rsrc_node_get(struct io_ring_ctx *ctx,
-		 struct io_rsrc_data *rsrc_data,
-		 void (*rsrc_put)(struct io_ring_ctx *ctx,
-		                  struct io_rsrc_put *prsrc))
-{
-	struct io_rsrc_node *node = ctx->rsrc_backup_node;
-
-	WARN_ON_ONCE(!node);
-
-	ctx->rsrc_backup_node = NULL;
-	node->rsrc_data = rsrc_data;
-	node->rsrc_put = rsrc_put;
-	return node;
-}
-
 static int io_rsrc_ref_quiesce(struct io_rsrc_data *data,
 			       struct io_ring_ctx *ctx,
 			       void (*rsrc_put)(struct io_ring_ctx *ctx,
 			                        struct io_rsrc_put *prsrc))
 {
-	struct io_rsrc_node *node;
 	int ret;
 
 	if (data->quiesce)
@@ -7029,8 +7021,7 @@ static int io_rsrc_ref_quiesce(struct io_rsrc_data *data,
 			break;
 
 		percpu_ref_resurrect(&data->refs);
-		node = io_rsrc_node_get(ctx, data, rsrc_put);
-		io_rsrc_node_set(ctx, data, node);
+		io_rsrc_node_set(ctx, data, rsrc_put);
 		reinit_completion(&data->done);
 
 		mutex_unlock(&ctx->uring_lock);
@@ -7501,7 +7492,6 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 	unsigned nr_tables, i;
 	struct file *file;
 	int fd, ret;
-	struct io_rsrc_node *ref_node;
 	struct io_rsrc_data *file_data;
 
 	if (ctx->file_data)
@@ -7572,8 +7562,7 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 		return ret;
 	}
 
-	ref_node = io_rsrc_node_get(ctx, ctx->file_data, io_ring_file_put);
-	io_rsrc_node_set(ctx, file_data, ref_node);
+	io_rsrc_node_set(ctx, file_data, io_ring_file_put);
 	return ret;
 out_fput:
 	for (i = 0; i < ctx->nr_user_files; i++) {
@@ -7659,7 +7648,6 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 				 unsigned nr_args)
 {
 	struct io_rsrc_data *data = ctx->file_data;
-	struct io_rsrc_node *ref_node;
 	struct file *file, **file_slot;
 	__s32 __user *fds;
 	int fd, i, err;
@@ -7726,8 +7714,7 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 
 	if (needs_switch) {
 		percpu_ref_kill(&data->node->refs);
-		ref_node = io_rsrc_node_get(ctx, data, io_ring_file_put);
-		io_rsrc_node_set(ctx, data, ref_node);
+		io_rsrc_node_set(ctx, data, io_ring_file_put);
 	}
 	return done ? done : err;
 }
-- 
2.24.0

