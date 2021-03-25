Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FC403492D6
	for <lists+io-uring@lfdr.de>; Thu, 25 Mar 2021 14:13:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbhCYNMb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Mar 2021 09:12:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230260AbhCYNMW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Mar 2021 09:12:22 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17F44C06174A
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 06:12:20 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id 12so1143136wmf.5
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 06:12:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=5ioU93dO4Fe+dlzw2m/b22AbvALIjPfUt1f7VPb8tUE=;
        b=E9xg8t78AEjj3UpbvOmrT3qfr2LFT6wtw0ysyJIvPmeeJt2hxIYdRUe/PPpMlN7Tzc
         l2jol6ZnYMkErHX48iw1qR9OffBYrUiUPRiipdB4W3ZVtTuDmxSo6WbfPyEEzGJPxh6j
         ZuDKnYqQXczLI5B1MsjDC2rDptDwfFjZDMyhLMNGj0Wc71fU7yd5cg9qx96LGjF/G7GQ
         bTBGlJcm5t8shteW2ZdyPwdnbhkqjg7UQLPTycIjnJu1+lv9s8z9yrBJIMmlq1/80kKh
         zEZX5/PSktkB/TKQfzVt3EHbXWMdhBmU2vtfoI6v1561GmZBa1nWe4x7iY63Bu1V5oxM
         lUrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5ioU93dO4Fe+dlzw2m/b22AbvALIjPfUt1f7VPb8tUE=;
        b=OsMMNw8akOKZJwibiAzGISwfN3vc3n6Lx3MFT2PnGaaMSdOiZ94B/N/G54eJPqsW9b
         Ds4zvmpw5tLFvDhjMrJ6O6KKtlhQ0zZGTBx/b1dVFI3qhJmi5booVdgx7afRFGIpVtZb
         Jsg76OEImuqSyGpMVfDSdBzmq8sZyQ9QW//EULB9E3LHMXZ8vpE2KHjSM+mLtXPGdNVR
         oEnYY8utnmOkIZ5DsiPura7zVe++FdWlQvL4S96yrxZ/kQRr5SPnhKQoL6YN0DCFt9dG
         OhtRvUU+lB2FSJ5jNxEUq1y7qseHajg9aBLx/4LiqOPrG03SEVaWTLZdxPjHuZw5YMwi
         75/Q==
X-Gm-Message-State: AOAM53327L/M37m7VFCK1qEkgjXJpK3tb+bGJDbKmrxwJIMatkby5w9r
        ClXbQD87qR6XM4dC1LDop0OI18vJckKgZQ==
X-Google-Smtp-Source: ABdhPJxr9iSB1id8Gazpp4lKLU1fGn78gzOBfVHzu+rxJPVpH9Yhha4s9Cq4smy/iA9sx70wV1CJVg==
X-Received: by 2002:a1c:bc56:: with SMTP id m83mr8024919wmf.174.1616677938314;
        Thu, 25 Mar 2021 06:12:18 -0700 (PDT)
Received: from localhost.localdomain ([148.252.129.162])
        by smtp.gmail.com with ESMTPSA id i4sm5754285wmq.12.2021.03.25.06.12.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 06:12:17 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v3 04/17] io_uring: encapsulate rsrc node manipulations
Date:   Thu, 25 Mar 2021 13:07:53 +0000
Message-Id: <ba6243d0388c3d61b59e9835333265abb820c449.1616677487.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1616677487.git.asml.silence@gmail.com>
References: <cover.1616677487.git.asml.silence@gmail.com>
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
index a494850e4539..6d49049f378f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6964,8 +6964,17 @@ static inline void io_rsrc_ref_unlock(struct io_ring_ctx *ctx)
 
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
@@ -6993,28 +7002,11 @@ static int io_rsrc_node_prealloc(struct io_ring_ctx *ctx)
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
@@ -7034,8 +7026,7 @@ static int io_rsrc_ref_quiesce(struct io_rsrc_data *data,
 			break;
 
 		percpu_ref_resurrect(&data->refs);
-		node = io_rsrc_node_get(ctx, data, rsrc_put);
-		io_rsrc_node_set(ctx, data, node);
+		io_rsrc_node_set(ctx, data, rsrc_put);
 		reinit_completion(&data->done);
 
 		mutex_unlock(&ctx->uring_lock);
@@ -7506,7 +7497,6 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 	unsigned nr_tables, i;
 	struct file *file;
 	int fd, ret;
-	struct io_rsrc_node *ref_node;
 	struct io_rsrc_data *file_data;
 
 	if (ctx->file_data)
@@ -7577,8 +7567,7 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 		return ret;
 	}
 
-	ref_node = io_rsrc_node_get(ctx, ctx->file_data, io_ring_file_put);
-	io_rsrc_node_set(ctx, file_data, ref_node);
+	io_rsrc_node_set(ctx, file_data, io_ring_file_put);
 	return ret;
 out_fput:
 	for (i = 0; i < ctx->nr_user_files; i++) {
@@ -7664,7 +7653,6 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 				 unsigned nr_args)
 {
 	struct io_rsrc_data *data = ctx->file_data;
-	struct io_rsrc_node *ref_node;
 	struct file *file, **file_slot;
 	__s32 __user *fds;
 	int fd, i, err;
@@ -7731,8 +7719,7 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 
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

