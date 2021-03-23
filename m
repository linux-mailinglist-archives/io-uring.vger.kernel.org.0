Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 612CA346146
	for <lists+io-uring@lfdr.de>; Tue, 23 Mar 2021 15:18:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232257AbhCWOSK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Mar 2021 10:18:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232312AbhCWORb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Mar 2021 10:17:31 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42D7FC061763
        for <io-uring@vger.kernel.org>; Tue, 23 Mar 2021 07:17:31 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id x13so20935721wrs.9
        for <io-uring@vger.kernel.org>; Tue, 23 Mar 2021 07:17:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=1RNupxVidJ6hkYBaoQHzEq2wBYod5qPqDByhwtma190=;
        b=thkteSjNmGpe/gKOm/grJz5YiHREK5q6oDBGbLj09YUT80B2mDWyqt2FTE2PpYjiR7
         iRxNI7Igp1ax15FC8rDWyelJboVM5uf3vH6dMXfUKFeMGnGKYFrnTq8dAtqtMwkyU/S2
         smcNqlmme/QK2tv81qwWb/cnALy6neIZ9ipBRocB5EO8N6CYW49Lp1P8SnxqWbwSfosG
         /LqZjxQM/B9EdqRGgnq6AiQ1DFJ1ZK4+mJ9+sh/7b/BIiyijCJd1FjBd2A6DpggpKi3c
         tvfECf1thFr5P8B5Fm12DqVqwysJRryN4UIKRuGT1l73MAxGGyA2S0RlOisILy/XLxq3
         olWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1RNupxVidJ6hkYBaoQHzEq2wBYod5qPqDByhwtma190=;
        b=VgSdQsoNiLdt5kFMF4wHtQ5bk7mPNMCJv58CXJHARF5HqYGt39c7Vv892zPLcfZDth
         2tA2JOFtZPAPbYn+f+/a/lqkiGkLMBThsVScFFkD7xej8pKRD0Nz0eTb1zv04wApbmV2
         vQ6K47GmatehS9HIGhWnNLP65tciiciI/uSyy1QoN+xyNoivms6VG/IpFCAvHZIsx+mE
         TPs7TDSywb/Ki7JLQ788Q77PKlgeROJa8SAdHbfFTp1LBSYRI5DI5UjXlClYj/3XUa5B
         Etc1hgqYOdoe7GvTNsT+I4gEkew1fqz1XPPw4CHwwWPgtso5K8/3s5ZfO1/Z22JYRaKk
         M79w==
X-Gm-Message-State: AOAM531NPar4gTfP2xQsmlPkJtOlKoOwMtZmaM9zYPo5okEiBPG3H0nG
        UNBB44Bbp0VDzGN+J/1n6No=
X-Google-Smtp-Source: ABdhPJz/TqUobNDIj8FFeS/fS0lVCXRbZCSakwcxdwxmO6MhwYBW6Z5B8nQI/EXpjp5AosdbcODTcQ==
X-Received: by 2002:adf:e108:: with SMTP id t8mr4117491wrz.371.1616509049999;
        Tue, 23 Mar 2021 07:17:29 -0700 (PDT)
Received: from localhost.localdomain ([85.255.236.147])
        by smtp.gmail.com with ESMTPSA id c2sm2861277wmr.22.2021.03.23.07.17.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Mar 2021 07:17:29 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 5/7] io_uring: move rsrc_put callback into io_rsrc_data
Date:   Tue, 23 Mar 2021 14:13:15 +0000
Message-Id: <db024edab92b2f21cf0a8bb9dd450532254f49f1.1616508751.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1616508751.git.asml.silence@gmail.com>
References: <cover.1616508751.git.asml.silence@gmail.com>
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

