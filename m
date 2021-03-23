Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72DBB34632A
	for <lists+io-uring@lfdr.de>; Tue, 23 Mar 2021 16:43:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233001AbhCWPlT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Mar 2021 11:41:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232932AbhCWPlM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Mar 2021 11:41:12 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65FFDC0613D8
        for <io-uring@vger.kernel.org>; Tue, 23 Mar 2021 08:41:12 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id o16so21265212wrn.0
        for <io-uring@vger.kernel.org>; Tue, 23 Mar 2021 08:41:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=1RNupxVidJ6hkYBaoQHzEq2wBYod5qPqDByhwtma190=;
        b=rj5WFR6dLGWD7tJjgCaTF/ihl/oMW+5lo3gFSQFQxijGILVoaCZSspkDNNXSrG2kqh
         OUxC4zME8MRRSiWFAaO9nf8Q5txsyq8m0xcfciA3UMvpiAmn2YKrCSwh/n7xemkYpl3L
         9T0ZXVAQOJ3gUrJ3ffPfmJNoVAnt8KawVAjeevZ8976GLJqPyF5y/2IOPSF9J5KzhvC2
         lywImdeZS9V+CZuSKrUW7+1tRfYDbGc0z5t/RJwmuu/SJbZhlkBsYV114CVLpdM82SJn
         5xgjQnTaiXNLdLzArxj1xGAYUYEglB7+yJoK0k/DIdd+ERSDVaYTl2yIudNADAZBf1+J
         XYdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1RNupxVidJ6hkYBaoQHzEq2wBYod5qPqDByhwtma190=;
        b=ZwtHvIEolWIRj8h6qD7lyveCj4foQkXJ4cIHHs3GP1mxuajJewrFt34K00kI306bBv
         ShXn6mx79eZ5BhTYRhoDqxPhvBuKoK1rnCKRmHSePDP0XQTsUaD/2NIF1YsWi1ui+qba
         yLMf1fjnFb/LYmOAS0KtdRKcmrqLVHcSQELyh+257bSRhHikTJkGkFxrz9+n076asHCd
         Up7golAcddLiofRhNsZYU9Yrd48HnJZHesVpbwhtZdixxOob1yIckVGd9AMXE3mpFGfL
         iy+e769i8bEavutaf/lmEue55V5VlyFW7uhtQKFMuWKGVldpfuBbuHBQyvZ4xtADBk3N
         Me6Q==
X-Gm-Message-State: AOAM530GsOvU8aEBn8SQjcdnidgLa9I7TFcTMqydVEAPqigbRUvATdzB
        CvLpjmYLiJvZMg7PP4nIq/hgcOGLQqBqeg==
X-Google-Smtp-Source: ABdhPJx9yVo65jFyMyPkIFaz3DLxDR0TIsD2A4aF35OwijGEu/4Knqg40BGo/173JjHk3WxUGnh0oQ==
X-Received: by 2002:adf:e5c8:: with SMTP id a8mr4725360wrn.352.1616514071223;
        Tue, 23 Mar 2021 08:41:11 -0700 (PDT)
Received: from localhost.localdomain ([85.255.236.168])
        by smtp.gmail.com with ESMTPSA id u2sm24493271wrp.12.2021.03.23.08.41.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Mar 2021 08:41:10 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 5/7] io_uring: move rsrc_put callback into io_rsrc_data
Date:   Tue, 23 Mar 2021 15:36:56 +0000
Message-Id: <db024edab92b2f21cf0a8bb9dd450532254f49f1.1616513699.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1616513699.git.asml.silence@gmail.com>
References: <cover.1616513699.git.asml.silence@gmail.com>
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
index 8b0d0774890a..9f9ed4151e71 100644
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
@@ -6958,9 +6959,7 @@ static inline void io_rsrc_ref_unlock(struct io_ring_ctx *ctx)
 }
 
 static void io_rsrc_node_set(struct io_ring_ctx *ctx,
-			     struct io_rsrc_data *rsrc_data,
-			     void (*rsrc_put)(struct io_ring_ctx *ctx,
-			                      struct io_rsrc_put *prsrc))
+			     struct io_rsrc_data *rsrc_data)
 {
 	struct io_rsrc_node *rsrc_node = ctx->rsrc_backup_node;
 
@@ -6968,7 +6967,6 @@ static void io_rsrc_node_set(struct io_ring_ctx *ctx,
 
 	ctx->rsrc_backup_node = NULL;
 	rsrc_node->rsrc_data = rsrc_data;
-	rsrc_node->rsrc_put = rsrc_put;
 
 	io_rsrc_ref_lock(ctx);
 	rsrc_data->node = rsrc_node;
@@ -6997,10 +6995,7 @@ static int io_rsrc_node_prealloc(struct io_ring_ctx *ctx)
 	return ctx->rsrc_backup_node ? 0 : -ENOMEM;
 }
 
-static int io_rsrc_ref_quiesce(struct io_rsrc_data *data,
-			       struct io_ring_ctx *ctx,
-			       void (*rsrc_put)(struct io_ring_ctx *ctx,
-			                        struct io_rsrc_put *prsrc))
+static int io_rsrc_ref_quiesce(struct io_rsrc_data *data, struct io_ring_ctx *ctx)
 {
 	int ret;
 
@@ -7021,7 +7016,7 @@ static int io_rsrc_ref_quiesce(struct io_rsrc_data *data,
 			break;
 
 		percpu_ref_resurrect(&data->refs);
-		io_rsrc_node_set(ctx, data, rsrc_put);
+		io_rsrc_node_set(ctx, data);
 		reinit_completion(&data->done);
 
 		mutex_unlock(&ctx->uring_lock);
@@ -7033,7 +7028,8 @@ static int io_rsrc_ref_quiesce(struct io_rsrc_data *data,
 	return ret;
 }
 
-static struct io_rsrc_data *io_rsrc_data_alloc(struct io_ring_ctx *ctx)
+static struct io_rsrc_data *io_rsrc_data_alloc(struct io_ring_ctx *ctx,
+					       rsrc_put_fn *do_put)
 {
 	struct io_rsrc_data *data;
 
@@ -7047,6 +7043,7 @@ static struct io_rsrc_data *io_rsrc_data_alloc(struct io_ring_ctx *ctx)
 		return NULL;
 	}
 	data->ctx = ctx;
+	data->do_put = do_put;
 	init_completion(&data->done);
 	return data;
 }
@@ -7071,7 +7068,7 @@ static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
 	 */
 	if (!data || percpu_ref_is_dying(&data->refs))
 		return -ENXIO;
-	ret = io_rsrc_ref_quiesce(data, ctx, io_ring_file_put);
+	ret = io_rsrc_ref_quiesce(data, ctx);
 	if (ret)
 		return ret;
 
@@ -7406,7 +7403,7 @@ static void __io_rsrc_put_work(struct io_rsrc_node *ref_node)
 
 	list_for_each_entry_safe(prsrc, tmp, &ref_node->rsrc_list, list) {
 		list_del(&prsrc->list);
-		ref_node->rsrc_put(ctx, prsrc);
+		rsrc_data->do_put(ctx, prsrc);
 		kfree(prsrc);
 	}
 
@@ -7504,7 +7501,7 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 	if (ret)
 		return ret;
 
-	file_data = io_rsrc_data_alloc(ctx);
+	file_data = io_rsrc_data_alloc(ctx, io_ring_file_put);
 	if (!file_data)
 		return -ENOMEM;
 	ctx->file_data = file_data;
@@ -7562,7 +7559,7 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 		return ret;
 	}
 
-	io_rsrc_node_set(ctx, file_data, io_ring_file_put);
+	io_rsrc_node_set(ctx, file_data);
 	return ret;
 out_fput:
 	for (i = 0; i < ctx->nr_user_files; i++) {
@@ -7714,7 +7711,7 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 
 	if (needs_switch) {
 		percpu_ref_kill(&data->node->refs);
-		io_rsrc_node_set(ctx, data, io_ring_file_put);
+		io_rsrc_node_set(ctx, data);
 	}
 	return done ? done : err;
 }
-- 
2.24.0

