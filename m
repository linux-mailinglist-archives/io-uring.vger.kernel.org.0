Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC4213492CE
	for <lists+io-uring@lfdr.de>; Thu, 25 Mar 2021 14:13:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230241AbhCYNMd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Mar 2021 09:12:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230281AbhCYNMW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Mar 2021 09:12:22 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35DD4C06175F
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 06:12:21 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id n11-20020a05600c4f8bb029010e5cf86347so4330098wmq.1
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 06:12:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=COs/ZjdOAHHh43cTYcrhFMM6DgFpajMfbRp0d+Q4rGA=;
        b=Dl2XcDK0flhTEE1sig6fqG8Pj7LoVnMDp/My4onM9Q9AW76dtLRu1HUBEWv/VUYMyF
         Qh+olEI92zJIWPAqHGhZka0VF/HEBneACE8QOnGVZdEnnyF7Kft/PrGU6/H+ihkE29a2
         9lkaVZHvbr+EgszYXufDKHdO98zBus5D4reMy2J4pQ7lXxnZ/f/nvFPG1nF09FEnDWM7
         Rmd/Aa87TKcdNGHnjacjxw8K94UD3SQmTEiNk86/MZ3/T5biFy1onq0uzmpYaFbPDT+3
         +ImGEzrc8BLtX/bkx3qMPdiheC7EcflAYeuJmloiK/DUwpMGuNLqkUIAheLrpRuQqLWx
         NCEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=COs/ZjdOAHHh43cTYcrhFMM6DgFpajMfbRp0d+Q4rGA=;
        b=AAL8S1ApOuWwnAH0eysV2AXbj3DeQ7QXKd4al4pF/SHH6fjNYzkLjtpjWzYBcNo+DH
         aHgrOv1fgS5ktCamw5ehKv/XiNpvv+EO6S26hu6Z2EJQjcnRBixwt9sBxsUYtL+YjIzS
         /6YKpz6JUXsSF9BvbQwSeKn8l5Q3HdQZy7cLkWCsjxBowcek57gNAfuICgBmeGMkCHGu
         6xImrRhXL6p0LHjt0cp0cgEk7v5b5VMSZqF0dJic2c7luPRtvCoEogQBiZ887X624fj8
         8ugKaCBF4w0A6ATB/of0GJEcXMoX8vdfri/lS6jpQY9b8O+q7+a3z8SdAIySItzrlTgI
         gfvQ==
X-Gm-Message-State: AOAM531NSoASUGB4Au4i2lkdvUrFsiblfaqmWRa4Icz0A7AxHkn1AKNi
        otCakmTBWo/B7qoZ3Ga9r7vC3mbjQfy+CA==
X-Google-Smtp-Source: ABdhPJwgFgNfYVQddIM3rHOdRzd1SqbsKBaO92amdXdi22T18D8JkD7bRofTvGS9dTUdJNnGRK0Mqw==
X-Received: by 2002:a1c:5f89:: with SMTP id t131mr7675067wmb.173.1616677939650;
        Thu, 25 Mar 2021 06:12:19 -0700 (PDT)
Received: from localhost.localdomain ([148.252.129.162])
        by smtp.gmail.com with ESMTPSA id i4sm5754285wmq.12.2021.03.25.06.12.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 06:12:19 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v3 05/17] io_uring: move rsrc_put callback into io_rsrc_data
Date:   Thu, 25 Mar 2021 13:07:54 +0000
Message-Id: <852d5274a38bcf6e55144d582b8f6d4874fe46de.1616677487.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1616677487.git.asml.silence@gmail.com>
References: <cover.1616677487.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_rsrc_node's callback operates only on a single io_rsrc_data and only
with its resources, so rsrc_put() callback is actually a property of
io_rsrc_data. Move it there, it makes code much nicecr.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 31 ++++++++++++++-----------------
 1 file changed, 14 insertions(+), 17 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 6d49049f378f..ba89cd56b6f8 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -220,16 +220,17 @@ struct io_rsrc_node {
 	struct list_head		node;
 	struct list_head		rsrc_list;
 	struct io_rsrc_data		*rsrc_data;
-	void				(*rsrc_put)(struct io_ring_ctx *ctx,
-						    struct io_rsrc_put *prsrc);
 	struct llist_node		llist;
 	bool				done;
 };
 
+typedef void (rsrc_put_fn)(struct io_ring_ctx *ctx, struct io_rsrc_put *prsrc);
+
 struct io_rsrc_data {
 	struct fixed_rsrc_table		*table;
 	struct io_ring_ctx		*ctx;
 
+	rsrc_put_fn			*do_put;
 	struct io_rsrc_node		*node;
 	struct percpu_ref		refs;
 	struct completion		done;
@@ -6963,9 +6964,7 @@ static inline void io_rsrc_ref_unlock(struct io_ring_ctx *ctx)
 }
 
 static void io_rsrc_node_set(struct io_ring_ctx *ctx,
-			     struct io_rsrc_data *rsrc_data,
-			     void (*rsrc_put)(struct io_ring_ctx *ctx,
-			                      struct io_rsrc_put *prsrc))
+			     struct io_rsrc_data *rsrc_data)
 {
 	struct io_rsrc_node *rsrc_node = ctx->rsrc_backup_node;
 
@@ -6973,7 +6972,6 @@ static void io_rsrc_node_set(struct io_ring_ctx *ctx,
 
 	ctx->rsrc_backup_node = NULL;
 	rsrc_node->rsrc_data = rsrc_data;
-	rsrc_node->rsrc_put = rsrc_put;
 
 	io_rsrc_ref_lock(ctx);
 	rsrc_data->node = rsrc_node;
@@ -7002,10 +7000,7 @@ static int io_rsrc_node_prealloc(struct io_ring_ctx *ctx)
 	return ctx->rsrc_backup_node ? 0 : -ENOMEM;
 }
 
-static int io_rsrc_ref_quiesce(struct io_rsrc_data *data,
-			       struct io_ring_ctx *ctx,
-			       void (*rsrc_put)(struct io_ring_ctx *ctx,
-			                        struct io_rsrc_put *prsrc))
+static int io_rsrc_ref_quiesce(struct io_rsrc_data *data, struct io_ring_ctx *ctx)
 {
 	int ret;
 
@@ -7026,7 +7021,7 @@ static int io_rsrc_ref_quiesce(struct io_rsrc_data *data,
 			break;
 
 		percpu_ref_resurrect(&data->refs);
-		io_rsrc_node_set(ctx, data, rsrc_put);
+		io_rsrc_node_set(ctx, data);
 		reinit_completion(&data->done);
 
 		mutex_unlock(&ctx->uring_lock);
@@ -7038,7 +7033,8 @@ static int io_rsrc_ref_quiesce(struct io_rsrc_data *data,
 	return ret;
 }
 
-static struct io_rsrc_data *io_rsrc_data_alloc(struct io_ring_ctx *ctx)
+static struct io_rsrc_data *io_rsrc_data_alloc(struct io_ring_ctx *ctx,
+					       rsrc_put_fn *do_put)
 {
 	struct io_rsrc_data *data;
 
@@ -7052,6 +7048,7 @@ static struct io_rsrc_data *io_rsrc_data_alloc(struct io_ring_ctx *ctx)
 		return NULL;
 	}
 	data->ctx = ctx;
+	data->do_put = do_put;
 	init_completion(&data->done);
 	return data;
 }
@@ -7076,7 +7073,7 @@ static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
 	 */
 	if (!data || percpu_ref_is_dying(&data->refs))
 		return -ENXIO;
-	ret = io_rsrc_ref_quiesce(data, ctx, io_ring_file_put);
+	ret = io_rsrc_ref_quiesce(data, ctx);
 	if (ret)
 		return ret;
 
@@ -7411,7 +7408,7 @@ static void __io_rsrc_put_work(struct io_rsrc_node *ref_node)
 
 	list_for_each_entry_safe(prsrc, tmp, &ref_node->rsrc_list, list) {
 		list_del(&prsrc->list);
-		ref_node->rsrc_put(ctx, prsrc);
+		rsrc_data->do_put(ctx, prsrc);
 		kfree(prsrc);
 	}
 
@@ -7509,7 +7506,7 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 	if (ret)
 		return ret;
 
-	file_data = io_rsrc_data_alloc(ctx);
+	file_data = io_rsrc_data_alloc(ctx, io_ring_file_put);
 	if (!file_data)
 		return -ENOMEM;
 	ctx->file_data = file_data;
@@ -7567,7 +7564,7 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 		return ret;
 	}
 
-	io_rsrc_node_set(ctx, file_data, io_ring_file_put);
+	io_rsrc_node_set(ctx, file_data);
 	return ret;
 out_fput:
 	for (i = 0; i < ctx->nr_user_files; i++) {
@@ -7719,7 +7716,7 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 
 	if (needs_switch) {
 		percpu_ref_kill(&data->node->refs);
-		io_rsrc_node_set(ctx, data, io_ring_file_put);
+		io_rsrc_node_set(ctx, data);
 	}
 	return done ? done : err;
 }
-- 
2.24.0

