Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AC303492D3
	for <lists+io-uring@lfdr.de>; Thu, 25 Mar 2021 14:13:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230167AbhCYNMb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Mar 2021 09:12:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230241AbhCYNMR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Mar 2021 09:12:17 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75B8CC06174A
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 06:12:16 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id m20-20020a7bcb940000b029010cab7e5a9fso3070298wmi.3
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 06:12:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=yTlYKa55fZZzFpT4D0H45IcGleRaWg6QlYwu4+CQcDk=;
        b=qTOslu23bApTBbnmh+cwVA1YWBOWbyekrHlqubr2y1B2gz4ijD8clwCo2rg7I+YpGX
         SU+y7/5dnEh3tazRGP4e76j5txRcRSRigaRpAjr1HtmaUFJJFsY8kdbh9Lqy9ovhSxIG
         vUUhJBhMPit3ylr0qyHQq6GrB0GUp5vCeHimN7Cnr8r27Q69VGDf+HIHQNcagp8U5s7+
         V23rjNa3WZ/ivD4fs4vibHekLMP8lgWDOPNk8qL8AxtVM1WwdsgVbA6SnSq/8Pu4wKCH
         BwywI6cjtI4X4O+NB2QwLwqp+5Es/VuZFLJhdTf1QFeDDoWkNCgqtbGoYhLiNlcmF0Vr
         t90w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yTlYKa55fZZzFpT4D0H45IcGleRaWg6QlYwu4+CQcDk=;
        b=fAFQE5+DkBwOYJXLATfwrGRees/oavYcXRktTxK6D33BzKQxT+mOQCnsMMa/ap7uMb
         n6x+a6JUlBAV170DbuF9nAxcUv7UBNsmSi2Ti4M1zFffW1UuFq3PBhbxr+SdA47tXza3
         lSp/AEkLE1863uAFEUqdCjMbZWdhqMsAujt7U8NfA5rrYFU44rdWqw/6IFC/FrgtgnOm
         YyVzR6yfzy10ZrRaAXwq6yZaepnRERCK64ghAtvBsPHvHXzhMPu0mmxERHsjaGT7q3nd
         iEbSrdpmlSKMTR54ujrWmNcKVRUORa0YG6GqyE6mjDT3/SNFoae0ZJlHyEWs4yI52fud
         fSfA==
X-Gm-Message-State: AOAM533HUoZRiuedBMd6sznChtArYUdohjW5dX/9vzOFTQzOUbs1wIZj
        xa5h9Z9IR/TzAvrwffrjtb4bwhZvfimNiA==
X-Google-Smtp-Source: ABdhPJzHE0sMZdsGEwp0i2sLcdieHUdPa2gbAP+QONx9+L2r4xACs3/qLG2l0ZAIWzh2Ec0jhaF7CA==
X-Received: by 2002:a7b:c1c9:: with SMTP id a9mr7775281wmj.145.1616677935010;
        Thu, 25 Mar 2021 06:12:15 -0700 (PDT)
Received: from localhost.localdomain ([148.252.129.162])
        by smtp.gmail.com with ESMTPSA id i4sm5754285wmq.12.2021.03.25.06.12.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 06:12:14 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v3 01/17] io_uring: name rsrc bits consistently
Date:   Thu, 25 Mar 2021 13:07:50 +0000
Message-Id: <822a29e747bbdebc534dc9771fdb061ace15b978.1616677487.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1616677487.git.asml.silence@gmail.com>
References: <cover.1616677487.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Keep resource related structs' and functions' naming consistent, in
particular use "io_rsrc" prefix for everything.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 150 ++++++++++++++++++++++++--------------------------
 1 file changed, 71 insertions(+), 79 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 2d2e1184c205..b2c6d91749df 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -215,22 +215,22 @@ struct fixed_rsrc_table {
 	struct file		**files;
 };
 
-struct fixed_rsrc_ref_node {
+struct io_rsrc_node {
 	struct percpu_ref		refs;
 	struct list_head		node;
 	struct list_head		rsrc_list;
-	struct fixed_rsrc_data		*rsrc_data;
+	struct io_rsrc_data		*rsrc_data;
 	void				(*rsrc_put)(struct io_ring_ctx *ctx,
 						    struct io_rsrc_put *prsrc);
 	struct llist_node		llist;
 	bool				done;
 };
 
-struct fixed_rsrc_data {
+struct io_rsrc_data {
 	struct fixed_rsrc_table		*table;
 	struct io_ring_ctx		*ctx;
 
-	struct fixed_rsrc_ref_node	*node;
+	struct io_rsrc_node		*node;
 	struct percpu_ref		refs;
 	struct completion		done;
 	bool				quiesce;
@@ -389,7 +389,7 @@ struct io_ring_ctx {
 	 * readers must ensure that ->refs is alive as long as the file* is
 	 * used. Only updated through io_uring_register(2).
 	 */
-	struct fixed_rsrc_data	*file_data;
+	struct io_rsrc_data	*file_data;
 	unsigned		nr_user_files;
 
 	/* if used, fixed mapped user buffers */
@@ -443,7 +443,7 @@ struct io_ring_ctx {
 	struct llist_head		rsrc_put_llist;
 	struct list_head		rsrc_ref_list;
 	spinlock_t			rsrc_ref_lock;
-	struct fixed_rsrc_ref_node	*rsrc_backup_node;
+	struct io_rsrc_node		*rsrc_backup_node;
 
 	struct io_restriction		restrictions;
 
@@ -1012,9 +1012,8 @@ static void io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 					 struct task_struct *task,
 					 struct files_struct *files);
 static void io_uring_cancel_sqpoll(struct io_ring_ctx *ctx);
-static void destroy_fixed_rsrc_ref_node(struct fixed_rsrc_ref_node *ref_node);
-static struct fixed_rsrc_ref_node *alloc_fixed_rsrc_ref_node(
-			struct io_ring_ctx *ctx);
+static void io_rsrc_node_destroy(struct io_rsrc_node *ref_node);
+static struct io_rsrc_node *io_rsrc_node_alloc(struct io_ring_ctx *ctx);
 static void io_ring_file_put(struct io_ring_ctx *ctx, struct io_rsrc_put *prsrc);
 
 static void io_cqring_fill_event(struct io_kiocb *req, long res);
@@ -1059,7 +1058,7 @@ EXPORT_SYMBOL(io_uring_get_socket);
 #define io_for_each_link(pos, head) \
 	for (pos = (head); pos; pos = pos->link)
 
-static inline void io_set_resource_node(struct io_kiocb *req)
+static inline void io_req_set_rsrc_node(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 
@@ -6164,7 +6163,7 @@ static void io_wq_submit_work(struct io_wq_work *work)
 #endif
 #define FFS_MASK		~(FFS_ASYNC_READ|FFS_ASYNC_WRITE|FFS_ISREG)
 
-static inline struct file **io_fixed_file_slot(struct fixed_rsrc_data *file_data,
+static inline struct file **io_fixed_file_slot(struct io_rsrc_data *file_data,
 					       unsigned i)
 {
 	struct fixed_rsrc_table *table;
@@ -6198,7 +6197,7 @@ static struct file *io_file_get(struct io_submit_state *state,
 		file_ptr &= ~FFS_MASK;
 		/* mask in overlapping REQ_F and FFS bits */
 		req->flags |= (file_ptr << REQ_F_ASYNC_READ_BIT);
-		io_set_resource_node(req);
+		io_req_set_rsrc_node(req);
 	} else {
 		trace_io_uring_file_get(ctx, fd);
 		file = __io_file_get(state, fd);
@@ -6948,9 +6947,8 @@ static void __io_sqe_files_unregister(struct io_ring_ctx *ctx)
 
 static void io_rsrc_data_ref_zero(struct percpu_ref *ref)
 {
-	struct fixed_rsrc_data *data;
+	struct io_rsrc_data *data = container_of(ref, struct io_rsrc_data, refs);
 
-	data = container_of(ref, struct fixed_rsrc_data, refs);
 	complete(&data->done);
 }
 
@@ -6964,20 +6962,20 @@ static inline void io_rsrc_ref_unlock(struct io_ring_ctx *ctx)
 	spin_unlock_bh(&ctx->rsrc_ref_lock);
 }
 
-static void io_sqe_rsrc_set_node(struct io_ring_ctx *ctx,
-				 struct fixed_rsrc_data *rsrc_data,
-				 struct fixed_rsrc_ref_node *ref_node)
+static void io_rsrc_node_set(struct io_ring_ctx *ctx,
+			     struct io_rsrc_data *rsrc_data,
+			     struct io_rsrc_node *rsrc_node)
 {
 	io_rsrc_ref_lock(ctx);
-	rsrc_data->node = ref_node;
-	list_add_tail(&ref_node->node, &ctx->rsrc_ref_list);
+	rsrc_data->node = rsrc_node;
+	list_add_tail(&rsrc_node->node, &ctx->rsrc_ref_list);
 	io_rsrc_ref_unlock(ctx);
 	percpu_ref_get(&rsrc_data->refs);
 }
 
-static void io_sqe_rsrc_kill_node(struct io_ring_ctx *ctx, struct fixed_rsrc_data *data)
+static void io_rsrc_node_kill(struct io_ring_ctx *ctx, struct io_rsrc_data *data)
 {
-	struct fixed_rsrc_ref_node *ref_node = NULL;
+	struct io_rsrc_node *ref_node = NULL;
 
 	io_rsrc_ref_lock(ctx);
 	ref_node = data->node;
@@ -6987,21 +6985,21 @@ static void io_sqe_rsrc_kill_node(struct io_ring_ctx *ctx, struct fixed_rsrc_dat
 		percpu_ref_kill(&ref_node->refs);
 }
 
-static int io_rsrc_refnode_prealloc(struct io_ring_ctx *ctx)
+static int io_rsrc_node_prealloc(struct io_ring_ctx *ctx)
 {
 	if (ctx->rsrc_backup_node)
 		return 0;
-	ctx->rsrc_backup_node = alloc_fixed_rsrc_ref_node(ctx);
+	ctx->rsrc_backup_node = io_rsrc_node_alloc(ctx);
 	return ctx->rsrc_backup_node ? 0 : -ENOMEM;
 }
 
-static struct fixed_rsrc_ref_node *
-io_rsrc_refnode_get(struct io_ring_ctx *ctx,
-		    struct fixed_rsrc_data *rsrc_data,
-		    void (*rsrc_put)(struct io_ring_ctx *ctx,
-		                     struct io_rsrc_put *prsrc))
+static struct io_rsrc_node *
+io_rsrc_node_get(struct io_ring_ctx *ctx,
+		 struct io_rsrc_data *rsrc_data,
+		 void (*rsrc_put)(struct io_ring_ctx *ctx,
+		                  struct io_rsrc_put *prsrc))
 {
-	struct fixed_rsrc_ref_node *node = ctx->rsrc_backup_node;
+	struct io_rsrc_node *node = ctx->rsrc_backup_node;
 
 	WARN_ON_ONCE(!node);
 
@@ -7011,12 +7009,12 @@ io_rsrc_refnode_get(struct io_ring_ctx *ctx,
 	return node;
 }
 
-static int io_rsrc_ref_quiesce(struct fixed_rsrc_data *data,
+static int io_rsrc_ref_quiesce(struct io_rsrc_data *data,
 			       struct io_ring_ctx *ctx,
 			       void (*rsrc_put)(struct io_ring_ctx *ctx,
 			                        struct io_rsrc_put *prsrc))
 {
-	struct fixed_rsrc_ref_node *node;
+	struct io_rsrc_node *node;
 	int ret;
 
 	if (data->quiesce)
@@ -7024,10 +7022,10 @@ static int io_rsrc_ref_quiesce(struct fixed_rsrc_data *data,
 
 	data->quiesce = true;
 	do {
-		ret = io_rsrc_refnode_prealloc(ctx);
+		ret = io_rsrc_node_prealloc(ctx);
 		if (ret)
 			break;
-		io_sqe_rsrc_kill_node(ctx, data);
+		io_rsrc_node_kill(ctx, data);
 		percpu_ref_kill(&data->refs);
 		flush_delayed_work(&ctx->rsrc_put_work);
 
@@ -7036,8 +7034,8 @@ static int io_rsrc_ref_quiesce(struct fixed_rsrc_data *data,
 			break;
 
 		percpu_ref_resurrect(&data->refs);
-		node = io_rsrc_refnode_get(ctx, data, rsrc_put);
-		io_sqe_rsrc_set_node(ctx, data, node);
+		node = io_rsrc_node_get(ctx, data, rsrc_put);
+		io_rsrc_node_set(ctx, data, node);
 		reinit_completion(&data->done);
 
 		mutex_unlock(&ctx->uring_lock);
@@ -7049,9 +7047,9 @@ static int io_rsrc_ref_quiesce(struct fixed_rsrc_data *data,
 	return ret;
 }
 
-static struct fixed_rsrc_data *alloc_fixed_rsrc_data(struct io_ring_ctx *ctx)
+static struct io_rsrc_data *io_rsrc_data_alloc(struct io_ring_ctx *ctx)
 {
-	struct fixed_rsrc_data *data;
+	struct io_rsrc_data *data;
 
 	data = kzalloc(sizeof(*data), GFP_KERNEL);
 	if (!data)
@@ -7067,7 +7065,7 @@ static struct fixed_rsrc_data *alloc_fixed_rsrc_data(struct io_ring_ctx *ctx)
 	return data;
 }
 
-static void free_fixed_rsrc_data(struct fixed_rsrc_data *data)
+static void io_rsrc_data_free(struct io_rsrc_data *data)
 {
 	percpu_ref_exit(&data->refs);
 	kfree(data->table);
@@ -7076,7 +7074,7 @@ static void free_fixed_rsrc_data(struct fixed_rsrc_data *data)
 
 static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
 {
-	struct fixed_rsrc_data *data = ctx->file_data;
+	struct io_rsrc_data *data = ctx->file_data;
 	unsigned nr_tables, i;
 	int ret;
 
@@ -7095,7 +7093,7 @@ static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
 	nr_tables = DIV_ROUND_UP(ctx->nr_user_files, IORING_MAX_FILES_TABLE);
 	for (i = 0; i < nr_tables; i++)
 		kfree(data->table[i].files);
-	free_fixed_rsrc_data(data);
+	io_rsrc_data_free(data);
 	ctx->file_data = NULL;
 	ctx->nr_user_files = 0;
 	return 0;
@@ -7324,7 +7322,7 @@ static int io_sqe_files_scm(struct io_ring_ctx *ctx)
 }
 #endif
 
-static int io_sqe_alloc_file_tables(struct fixed_rsrc_data *file_data,
+static int io_sqe_alloc_file_tables(struct io_rsrc_data *file_data,
 				    unsigned nr_tables, unsigned nr_files)
 {
 	int i;
@@ -7414,9 +7412,9 @@ static void io_ring_file_put(struct io_ring_ctx *ctx, struct io_rsrc_put *prsrc)
 #endif
 }
 
-static void __io_rsrc_put_work(struct fixed_rsrc_ref_node *ref_node)
+static void __io_rsrc_put_work(struct io_rsrc_node *ref_node)
 {
-	struct fixed_rsrc_data *rsrc_data = ref_node->rsrc_data;
+	struct io_rsrc_data *rsrc_data = ref_node->rsrc_data;
 	struct io_ring_ctx *ctx = rsrc_data->ctx;
 	struct io_rsrc_put *prsrc, *tmp;
 
@@ -7440,10 +7438,10 @@ static void io_rsrc_put_work(struct work_struct *work)
 	node = llist_del_all(&ctx->rsrc_put_llist);
 
 	while (node) {
-		struct fixed_rsrc_ref_node *ref_node;
+		struct io_rsrc_node *ref_node;
 		struct llist_node *next = node->next;
 
-		ref_node = llist_entry(node, struct fixed_rsrc_ref_node, llist);
+		ref_node = llist_entry(node, struct io_rsrc_node, llist);
 		__io_rsrc_put_work(ref_node);
 		node = next;
 	}
@@ -7451,27 +7449,23 @@ static void io_rsrc_put_work(struct work_struct *work)
 
 static void io_rsrc_node_ref_zero(struct percpu_ref *ref)
 {
-	struct fixed_rsrc_ref_node *ref_node;
-	struct fixed_rsrc_data *data;
-	struct io_ring_ctx *ctx;
+	struct io_rsrc_node *node = container_of(ref, struct io_rsrc_node, refs);
+	struct io_rsrc_data *data = node->rsrc_data;
+	struct io_ring_ctx *ctx = data->ctx;
 	bool first_add = false;
 	int delay = HZ;
 
-	ref_node = container_of(ref, struct fixed_rsrc_ref_node, refs);
-	data = ref_node->rsrc_data;
-	ctx = data->ctx;
-
 	io_rsrc_ref_lock(ctx);
-	ref_node->done = true;
+	node->done = true;
 
 	while (!list_empty(&ctx->rsrc_ref_list)) {
-		ref_node = list_first_entry(&ctx->rsrc_ref_list,
-					struct fixed_rsrc_ref_node, node);
+		node = list_first_entry(&ctx->rsrc_ref_list,
+					    struct io_rsrc_node, node);
 		/* recycle ref nodes in order */
-		if (!ref_node->done)
+		if (!node->done)
 			break;
-		list_del(&ref_node->node);
-		first_add |= llist_add(&ref_node->llist, &ctx->rsrc_put_llist);
+		list_del(&node->node);
+		first_add |= llist_add(&node->llist, &ctx->rsrc_put_llist);
 	}
 	io_rsrc_ref_unlock(ctx);
 
@@ -7484,10 +7478,9 @@ static void io_rsrc_node_ref_zero(struct percpu_ref *ref)
 		queue_delayed_work(system_wq, &ctx->rsrc_put_work, delay);
 }
 
-static struct fixed_rsrc_ref_node *alloc_fixed_rsrc_ref_node(
-			struct io_ring_ctx *ctx)
+static struct io_rsrc_node *io_rsrc_node_alloc(struct io_ring_ctx *ctx)
 {
-	struct fixed_rsrc_ref_node *ref_node;
+	struct io_rsrc_node *ref_node;
 
 	ref_node = kzalloc(sizeof(*ref_node), GFP_KERNEL);
 	if (!ref_node)
@@ -7505,19 +7498,18 @@ static struct fixed_rsrc_ref_node *alloc_fixed_rsrc_ref_node(
 }
 
 static void init_fixed_file_ref_node(struct io_ring_ctx *ctx,
-				     struct fixed_rsrc_ref_node *ref_node)
+				     struct io_rsrc_node *ref_node)
 {
 	ref_node->rsrc_data = ctx->file_data;
 	ref_node->rsrc_put = io_ring_file_put;
 }
 
-static void destroy_fixed_rsrc_ref_node(struct fixed_rsrc_ref_node *ref_node)
+static void io_rsrc_node_destroy(struct io_rsrc_node *ref_node)
 {
 	percpu_ref_exit(&ref_node->refs);
 	kfree(ref_node);
 }
 
-
 static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 				 unsigned nr_args)
 {
@@ -7525,8 +7517,8 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 	unsigned nr_tables, i;
 	struct file *file;
 	int fd, ret = -ENOMEM;
-	struct fixed_rsrc_ref_node *ref_node;
-	struct fixed_rsrc_data *file_data;
+	struct io_rsrc_node *ref_node;
+	struct io_rsrc_data *file_data;
 
 	if (ctx->file_data)
 		return -EBUSY;
@@ -7535,7 +7527,7 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 	if (nr_args > IORING_MAX_FIXED_FILES)
 		return -EMFILE;
 
-	file_data = alloc_fixed_rsrc_data(ctx);
+	file_data = io_rsrc_data_alloc(ctx);
 	if (!file_data)
 		return -ENOMEM;
 	ctx->file_data = file_data;
@@ -7592,14 +7584,14 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 		return ret;
 	}
 
-	ref_node = alloc_fixed_rsrc_ref_node(ctx);
+	ref_node = io_rsrc_node_alloc(ctx);
 	if (!ref_node) {
 		io_sqe_files_unregister(ctx);
 		return -ENOMEM;
 	}
 	init_fixed_file_ref_node(ctx, ref_node);
 
-	io_sqe_rsrc_set_node(ctx, file_data, ref_node);
+	io_rsrc_node_set(ctx, file_data, ref_node);
 	return ret;
 out_fput:
 	for (i = 0; i < ctx->nr_user_files; i++) {
@@ -7611,7 +7603,7 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 		kfree(file_data->table[i].files);
 	ctx->nr_user_files = 0;
 out_free:
-	free_fixed_rsrc_data(ctx->file_data);
+	io_rsrc_data_free(ctx->file_data);
 	ctx->file_data = NULL;
 	return ret;
 }
@@ -7659,10 +7651,10 @@ static int io_sqe_file_register(struct io_ring_ctx *ctx, struct file *file,
 #endif
 }
 
-static int io_queue_rsrc_removal(struct fixed_rsrc_data *data, void *rsrc)
+static int io_queue_rsrc_removal(struct io_rsrc_data *data, void *rsrc)
 {
 	struct io_rsrc_put *prsrc;
-	struct fixed_rsrc_ref_node *ref_node = data->node;
+	struct io_rsrc_node *ref_node = data->node;
 
 	prsrc = kzalloc(sizeof(*prsrc), GFP_KERNEL);
 	if (!prsrc)
@@ -7674,7 +7666,7 @@ static int io_queue_rsrc_removal(struct fixed_rsrc_data *data, void *rsrc)
 	return 0;
 }
 
-static inline int io_queue_file_removal(struct fixed_rsrc_data *data,
+static inline int io_queue_file_removal(struct io_rsrc_data *data,
 					struct file *file)
 {
 	return io_queue_rsrc_removal(data, (void *)file);
@@ -7684,8 +7676,8 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 				 struct io_uring_rsrc_update *up,
 				 unsigned nr_args)
 {
-	struct fixed_rsrc_data *data = ctx->file_data;
-	struct fixed_rsrc_ref_node *ref_node;
+	struct io_rsrc_data *data = ctx->file_data;
+	struct io_rsrc_node *ref_node;
 	struct file *file, **file_slot;
 	__s32 __user *fds;
 	int fd, i, err;
@@ -7696,7 +7688,7 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 		return -EOVERFLOW;
 	if (done > ctx->nr_user_files)
 		return -EINVAL;
-	err = io_rsrc_refnode_prealloc(ctx);
+	err = io_rsrc_node_prealloc(ctx);
 	if (err)
 		return err;
 
@@ -7752,8 +7744,8 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 
 	if (needs_switch) {
 		percpu_ref_kill(&data->node->refs);
-		ref_node = io_rsrc_refnode_get(ctx, data, io_ring_file_put);
-		io_sqe_rsrc_set_node(ctx, data, ref_node);
+		ref_node = io_rsrc_node_get(ctx, data, io_ring_file_put);
+		io_rsrc_node_set(ctx, data, ref_node);
 	}
 	return done ? done : err;
 }
@@ -8431,7 +8423,7 @@ static void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	io_destroy_buffers(ctx);
 
 	if (ctx->rsrc_backup_node)
-		destroy_fixed_rsrc_ref_node(ctx->rsrc_backup_node);
+		io_rsrc_node_destroy(ctx->rsrc_backup_node);
 
 #if defined(CONFIG_UNIX)
 	if (ctx->ring_sock) {
-- 
2.24.0

