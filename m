Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1F8F35198E
	for <lists+io-uring@lfdr.de>; Thu,  1 Apr 2021 20:03:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235183AbhDARyF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Apr 2021 13:54:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235373AbhDARtG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Apr 2021 13:49:06 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DA95C0045F5
        for <io-uring@vger.kernel.org>; Thu,  1 Apr 2021 07:48:21 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id g25so1203690wmh.0
        for <io-uring@vger.kernel.org>; Thu, 01 Apr 2021 07:48:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=qQT4wHF0buoMk6Rvf+YgZ3s+3RkhrAIuvXek3tRvAVk=;
        b=V1ERIwCSRVrRjP803idpHllNIDxtIY68swClTSSxadvpTsPgh1vDU8xVILvecJDY6C
         1nqjXcMCLx/EMVCCi3RqELZDYhFfIBUpf0d4OgHDcp6VY1wbqruOja1FSldcDzB9uCiV
         PWb+94LQws5lkn50ENSS+zpdiS3yF7XnK7tiijYj5yXk+uGTE9z3ZK9vl7El2J3m2IKe
         PwtEPAV/ozFmHANmc2+slOAO/2DJX71fUefGXWaLAWFS+7tWJbtEO15mD3bV3tEG6UqZ
         Mt9f0cVDUymevSbelRIca1MTvCGtGgp2Mn4d+AqCWe3OnfnCBO6FNqXJQxu0wBBgvW+U
         oA0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qQT4wHF0buoMk6Rvf+YgZ3s+3RkhrAIuvXek3tRvAVk=;
        b=QUVwxnNtZPRqK7L1JVcmy6w52jJldI55teQ1RFCMT7zdWCCQobJEr/hFAdJ6gkh3ou
         yzj3ypbxA6Wd5ZJXUmkbvrV9FSILTJv+hFiH654DWxnaDUOfDkiun4/hH6GrjF/ym120
         Rsmqs5oy6Q9eMGwWc/WO2whd7OJe7bj+JNGTqhjHATmi2Va1hNDcLGNu2/VPhX73hqq3
         IL/gPvU0OBXQzO8cd7FofM2f+FjcgtLVVaPtd4jU8zdHee71AOpmp7muChgD8F5Fjsq8
         Tq0fUEIT7IZmwyrea9GwcIMNJ+wP870BJJLQiLaBdB1W6bmSSilZgpPMDgFf1/+59V/N
         0BUg==
X-Gm-Message-State: AOAM5320v821kjDi2M3QMWRPpuLIGPXFRQgISSHX9CVnBixVnCNrqBLC
        9gf4qzUgG63NADhtjZoTVxo=
X-Google-Smtp-Source: ABdhPJw5x/Gcpcn+7L0LzPjLignJCzqsPMTpE1pp0p6VXPUO78aWSMBsrphoS/mCNMi1KcQ0DFJX0Q==
X-Received: by 2002:a05:600c:198c:: with SMTP id t12mr8375146wmq.183.1617288500081;
        Thu, 01 Apr 2021 07:48:20 -0700 (PDT)
Received: from localhost.localdomain ([148.252.132.152])
        by smtp.gmail.com with ESMTPSA id x13sm8183948wmp.39.2021.04.01.07.48.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 07:48:19 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v4 04/26] io_uring: encapsulate rsrc node manipulations
Date:   Thu,  1 Apr 2021 15:43:43 +0100
Message-Id: <0827b080b2e61b3dec795380f7e1a1995595d41f.1617287883.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1617287883.git.asml.silence@gmail.com>
References: <cover.1617287883.git.asml.silence@gmail.com>
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
index b53ccac47440..3d9b58d8eb90 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7076,8 +7076,17 @@ static inline void io_rsrc_ref_unlock(struct io_ring_ctx *ctx)
 
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
@@ -7105,28 +7114,11 @@ static int io_rsrc_node_prealloc(struct io_ring_ctx *ctx)
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
@@ -7146,8 +7138,7 @@ static int io_rsrc_ref_quiesce(struct io_rsrc_data *data,
 			break;
 
 		percpu_ref_resurrect(&data->refs);
-		node = io_rsrc_node_get(ctx, data, rsrc_put);
-		io_rsrc_node_set(ctx, data, node);
+		io_rsrc_node_set(ctx, data, rsrc_put);
 		reinit_completion(&data->done);
 
 		mutex_unlock(&ctx->uring_lock);
@@ -7618,7 +7609,6 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 	unsigned nr_tables, i;
 	struct file *file;
 	int fd, ret;
-	struct io_rsrc_node *ref_node;
 	struct io_rsrc_data *file_data;
 
 	if (ctx->file_data)
@@ -7689,8 +7679,7 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 		return ret;
 	}
 
-	ref_node = io_rsrc_node_get(ctx, ctx->file_data, io_ring_file_put);
-	io_rsrc_node_set(ctx, file_data, ref_node);
+	io_rsrc_node_set(ctx, file_data, io_ring_file_put);
 	return ret;
 out_fput:
 	for (i = 0; i < ctx->nr_user_files; i++) {
@@ -7776,7 +7765,6 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 				 unsigned nr_args)
 {
 	struct io_rsrc_data *data = ctx->file_data;
-	struct io_rsrc_node *ref_node;
 	struct file *file, **file_slot;
 	__s32 __user *fds;
 	int fd, i, err;
@@ -7843,8 +7831,7 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 
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

