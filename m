Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D75C8351A90
	for <lists+io-uring@lfdr.de>; Thu,  1 Apr 2021 20:06:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234311AbhDASB6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Apr 2021 14:01:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236985AbhDAR4l (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Apr 2021 13:56:41 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61FA1C0045F6
        for <io-uring@vger.kernel.org>; Thu,  1 Apr 2021 07:48:22 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id c8so2085172wrq.11
        for <io-uring@vger.kernel.org>; Thu, 01 Apr 2021 07:48:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=VLF4MmcuiCquoKpCD7d2s0Nvahpq7i5R56MDS9qvPxo=;
        b=rhGWB3GUhOwoH1Xux66jXFCZQj3QG8W+wcssrrWybuKlY+Td0M42WNNNNWB0kKC0CR
         RicoT46ObXwwHBGXJ9KeaZNcNdYYnjVsiA5IDJ0qTdug6sqfcVNOBaksTExColcwt54/
         XRDH12hWcLsTbhxl8mk7xK8JLUTGLycBHgNmxyAQj4FZwKnbSkRQY6Wvlmsz8MRV5Aue
         cjMFawCAgJSpg5ZNdoG0t8Tt7MI6IO3WCSiVSQorGjq3fFO5gCLtMlzA0o/GuIlTroOS
         6gu5rTAVnsmWFGCuNWqCBlgnYLbo3bSNxkGhE+JAc0yMPDGk/JHJYIoQVmOyIdwLom3+
         V/Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VLF4MmcuiCquoKpCD7d2s0Nvahpq7i5R56MDS9qvPxo=;
        b=UqGvcyewD1GRx4NeKv8cWvN/S7FUkFVv48zsruPWv/6mJg8WQxWuQSZ4XYbhUR5u6J
         d3BBKRMvZRBEqqgB4p46EnI5qc+wcCk2vmjDp8Sjr1TOSAkCcSzDh2+KEajtWfM1dpZF
         GyqpEiauhcaSwo/t7KNkPF+CEcaL04VbEXGhNWSpB67C3dti6dOo9jUo+f7i5XIFcCof
         zAc1ewdWi2gr2t7PJcQS55JZ0eWJY4ZVs794lUmf5+SXRuo/3myGr0o6ZyKUVuOh7QTi
         SozPNfttJ/NumYDT0xO9inn81t2P1q3ZzG1ePiqjkcizjr1THM/QnVBhZtU5SjyeTkAf
         mJog==
X-Gm-Message-State: AOAM532fakLX7nfthcb6fKGYudbClfTXp8PuKhY2/6yhCDVfZK7yLmpT
        ySt1ZAuhbM7kScFt94sgGXs=
X-Google-Smtp-Source: ABdhPJwKBMqP+XlEjsBzCNCVlJ5jVlhkEedTQEFXXIeIUNVxIHN8pbOzIB/8I8U42Wy7VNO0J3QVHQ==
X-Received: by 2002:adf:d217:: with SMTP id j23mr10474744wrh.113.1617288501199;
        Thu, 01 Apr 2021 07:48:21 -0700 (PDT)
Received: from localhost.localdomain ([148.252.132.152])
        by smtp.gmail.com with ESMTPSA id x13sm8183948wmp.39.2021.04.01.07.48.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 07:48:20 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v4 05/26] io_uring: move rsrc_put callback into io_rsrc_data
Date:   Thu,  1 Apr 2021 15:43:44 +0100
Message-Id: <9417c2fba3c09e8668f05747006a603d416d34b4.1617287883.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1617287883.git.asml.silence@gmail.com>
References: <cover.1617287883.git.asml.silence@gmail.com>
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
index 3d9b58d8eb90..42c9ef85800e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -224,16 +224,17 @@ struct io_rsrc_node {
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
@@ -7075,9 +7076,7 @@ static inline void io_rsrc_ref_unlock(struct io_ring_ctx *ctx)
 }
 
 static void io_rsrc_node_set(struct io_ring_ctx *ctx,
-			     struct io_rsrc_data *rsrc_data,
-			     void (*rsrc_put)(struct io_ring_ctx *ctx,
-			                      struct io_rsrc_put *prsrc))
+			     struct io_rsrc_data *rsrc_data)
 {
 	struct io_rsrc_node *rsrc_node = ctx->rsrc_backup_node;
 
@@ -7085,7 +7084,6 @@ static void io_rsrc_node_set(struct io_ring_ctx *ctx,
 
 	ctx->rsrc_backup_node = NULL;
 	rsrc_node->rsrc_data = rsrc_data;
-	rsrc_node->rsrc_put = rsrc_put;
 
 	io_rsrc_ref_lock(ctx);
 	rsrc_data->node = rsrc_node;
@@ -7114,10 +7112,7 @@ static int io_rsrc_node_prealloc(struct io_ring_ctx *ctx)
 	return ctx->rsrc_backup_node ? 0 : -ENOMEM;
 }
 
-static int io_rsrc_ref_quiesce(struct io_rsrc_data *data,
-			       struct io_ring_ctx *ctx,
-			       void (*rsrc_put)(struct io_ring_ctx *ctx,
-			                        struct io_rsrc_put *prsrc))
+static int io_rsrc_ref_quiesce(struct io_rsrc_data *data, struct io_ring_ctx *ctx)
 {
 	int ret;
 
@@ -7138,7 +7133,7 @@ static int io_rsrc_ref_quiesce(struct io_rsrc_data *data,
 			break;
 
 		percpu_ref_resurrect(&data->refs);
-		io_rsrc_node_set(ctx, data, rsrc_put);
+		io_rsrc_node_set(ctx, data);
 		reinit_completion(&data->done);
 
 		mutex_unlock(&ctx->uring_lock);
@@ -7150,7 +7145,8 @@ static int io_rsrc_ref_quiesce(struct io_rsrc_data *data,
 	return ret;
 }
 
-static struct io_rsrc_data *io_rsrc_data_alloc(struct io_ring_ctx *ctx)
+static struct io_rsrc_data *io_rsrc_data_alloc(struct io_ring_ctx *ctx,
+					       rsrc_put_fn *do_put)
 {
 	struct io_rsrc_data *data;
 
@@ -7164,6 +7160,7 @@ static struct io_rsrc_data *io_rsrc_data_alloc(struct io_ring_ctx *ctx)
 		return NULL;
 	}
 	data->ctx = ctx;
+	data->do_put = do_put;
 	init_completion(&data->done);
 	return data;
 }
@@ -7188,7 +7185,7 @@ static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
 	 */
 	if (!data || percpu_ref_is_dying(&data->refs))
 		return -ENXIO;
-	ret = io_rsrc_ref_quiesce(data, ctx, io_ring_file_put);
+	ret = io_rsrc_ref_quiesce(data, ctx);
 	if (ret)
 		return ret;
 
@@ -7523,7 +7520,7 @@ static void __io_rsrc_put_work(struct io_rsrc_node *ref_node)
 
 	list_for_each_entry_safe(prsrc, tmp, &ref_node->rsrc_list, list) {
 		list_del(&prsrc->list);
-		ref_node->rsrc_put(ctx, prsrc);
+		rsrc_data->do_put(ctx, prsrc);
 		kfree(prsrc);
 	}
 
@@ -7621,7 +7618,7 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 	if (ret)
 		return ret;
 
-	file_data = io_rsrc_data_alloc(ctx);
+	file_data = io_rsrc_data_alloc(ctx, io_ring_file_put);
 	if (!file_data)
 		return -ENOMEM;
 	ctx->file_data = file_data;
@@ -7679,7 +7676,7 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 		return ret;
 	}
 
-	io_rsrc_node_set(ctx, file_data, io_ring_file_put);
+	io_rsrc_node_set(ctx, file_data);
 	return ret;
 out_fput:
 	for (i = 0; i < ctx->nr_user_files; i++) {
@@ -7831,7 +7828,7 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 
 	if (needs_switch) {
 		percpu_ref_kill(&data->node->refs);
-		io_rsrc_node_set(ctx, data, io_ring_file_put);
+		io_rsrc_node_set(ctx, data);
 	}
 	return done ? done : err;
 }
-- 
2.24.0

