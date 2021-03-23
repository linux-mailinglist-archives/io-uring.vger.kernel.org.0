Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61D3F346149
	for <lists+io-uring@lfdr.de>; Tue, 23 Mar 2021 15:18:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232291AbhCWOSH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Mar 2021 10:18:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232307AbhCWORa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Mar 2021 10:17:30 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94ACCC061574
        for <io-uring@vger.kernel.org>; Tue, 23 Mar 2021 07:17:29 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id m20-20020a7bcb940000b029010cab7e5a9fso13088926wmi.3
        for <io-uring@vger.kernel.org>; Tue, 23 Mar 2021 07:17:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=kLEg/MkTIxIGvWnAPLlr/aOroU25meTswkNLYOEYUs4=;
        b=R3vgjulhVKN1dkL78AVWzreoAXtSux+9GHwwMD/s+DRfkLCav7pymcl2vd9U/2aXqu
         K4fkM+7kwCtixs+xEeOJYddf9HnaapDiHi3xQVc+IKhvNgUf1QnXWhjgvDT1dN4HYq+B
         aLLFDG+UtLj+ZsIFUt/PTpz/LXLRX5uj6mMp7lwz0yuV62YqUoMpCxpWMWevicHw3dX/
         Cp3oE4tzocuawzD4+258k9PmORu+zZuqVk8sCi7ViYLavttpPveHcb8/oYBu5coU8OJo
         7+gfCvReTid0yFRbWHUHYcrK+Y5ffy36vdhLYqHwFTWCZC9GzcHLwfIA6AURIosqNbJC
         iycQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kLEg/MkTIxIGvWnAPLlr/aOroU25meTswkNLYOEYUs4=;
        b=JKl+hOxfQZRfLNNp8Wo3Y7Wwi6U+9LYPlhv8FZNN9Bou1yUXIigWHwXL3Y/jVp6OrP
         pcAuGv4poFvaA1D9d8tr9zG5Pp0jvcHQX/2elh9YhBOjXZlGV6K//r2vHvhu+eSiLx+4
         N5AohuuAjRXtXTNI5BvIgobL7BLns2yZZ08R4DCCpuG1YA8jS32QAp9iYinUujIrpEye
         0OfOsN/0kcoLY83YNCkkw4/8PrksYDQxvxlx0n6lfkimEyUjrnq2MBwhjtG6ajeawGmK
         QvJ3DMHz788OD09xoS7K1Mq8/P52RbId8VrwUUkyGBVB3ihXaaOG8VEdjCVlES7Cf8pj
         x5EA==
X-Gm-Message-State: AOAM531hQHM04DPEdEndun4QkWO2sfgCcLnZ7URmRT73sDTj/E2W+Qb4
        148dOfrdnY1pDGEpMQLyJtA=
X-Google-Smtp-Source: ABdhPJzGkFDqUp/vC749wiEXjKScQ7LhZAGuZ0wm5xsX/RpssI9TkiOuULx1TKaMvK4MpcbG+MGBTg==
X-Received: by 2002:a1c:e244:: with SMTP id z65mr3626940wmg.130.1616509048225;
        Tue, 23 Mar 2021 07:17:28 -0700 (PDT)
Received: from localhost.localdomain ([85.255.236.147])
        by smtp.gmail.com with ESMTPSA id c2sm2861277wmr.22.2021.03.23.07.17.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Mar 2021 07:17:27 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 4/7] io_uring: encapsulate rsrc node manipulations
Date:   Tue, 23 Mar 2021 14:13:14 +0000
Message-Id: <3ecf83200d3245d7dc9e897ef489ea5b0dced3f0.1616508751.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1616508751.git.asml.silence@gmail.com>
References: <cover.1616508751.git.asml.silence@gmail.com>
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

