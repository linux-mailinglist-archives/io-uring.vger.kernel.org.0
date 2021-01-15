Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B1492F82B1
	for <lists+io-uring@lfdr.de>; Fri, 15 Jan 2021 18:43:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729353AbhAORmR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 Jan 2021 12:42:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728176AbhAORmR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 Jan 2021 12:42:17 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0413C0613D3
        for <io-uring@vger.kernel.org>; Fri, 15 Jan 2021 09:41:36 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id r4so8290906wmh.5
        for <io-uring@vger.kernel.org>; Fri, 15 Jan 2021 09:41:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=IrwIOrdCmXPxlVs/+TUpFM1eOU3WOnCAxcZtrVOqn2s=;
        b=ZRvp+bSrJU0nuh16gQJheHIrOVk3brt+47RfZPuwHe2gri4yl3jb7bOFV3qaz2KyWX
         +uF4aqn8ZuVmgITyCCNm0JGCzF1Yxpr9k8s0IgcNwqNjh8xe/B+Cyk4k06lvL4CgSsQn
         EzZ35XvxLQxumwnz7DaMcr5i98n5RbI86CkkvMT5d0yuNiHnoaAM5y56msJkP9j2yIwb
         Q40wU3NzOh6249PeCnvLXWrJf/wGLee81NhocCZ6DPx1myc9yIgOvG1gfw4gdlSvqYUv
         iOoyrwaVQ2K1Q4uj9JuKq7Sch1fIO/SUgFODgiG31ZXLX63F8c0+xl8aPNVpQZUMB2TK
         V14w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IrwIOrdCmXPxlVs/+TUpFM1eOU3WOnCAxcZtrVOqn2s=;
        b=XAa+VKlabePzIs5K/YIkGBy2+zSWkTSgfhe83iY/OLR3VDO01wTYDmx4eOVLNI5EES
         4simhZeeTHwMosnhJNu6vj71fJV4eyVk8Kr4A/1JXLY21Whvs6Sgw1FXGiA4YvPitwRf
         xV1v/BJptIdbUTpS6bg3vICjvm88PplwSxmP/L3jz7YsAkyCPLT4u///yPHX9YfV6L1z
         LSSvzap83ZKLTyIBax16L4WyWjf4HDXzPihP3upGsdefWnOgOs/zX3Mq00BVQFqGtyFj
         N3/e5plgqPi2Pq0FaRsb4FczP1zBEA9TUkyhO3rRxAcCX2XEbBwjejsAfixg3p6oELij
         XB9g==
X-Gm-Message-State: AOAM5332mhpS+h407CVLGrjDnsONKYWqbXJQzvtXGALZ4nA7R4430Pjl
        tM/2PNUJn21frKiWCynqrow=
X-Google-Smtp-Source: ABdhPJzXt5TCqiRDIkGN2kQc0TYE5o+b98ojUKt0/DeAMbwsT0lCdx9UwV6c3rvEcbuHKcyOWI/tDQ==
X-Received: by 2002:a1c:2945:: with SMTP id p66mr3538167wmp.110.1610732495350;
        Fri, 15 Jan 2021 09:41:35 -0800 (PST)
Received: from localhost.localdomain ([85.255.233.192])
        by smtp.gmail.com with ESMTPSA id f7sm2060426wmg.43.2021.01.15.09.41.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 09:41:34 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
Subject: [PATCH 1/9] io_uring: rename file related variables to rsrc
Date:   Fri, 15 Jan 2021 17:37:44 +0000
Message-Id: <3cd3ce8ae9e55c3c7cdc8b8fc6109ebecd0573fe.1610729503.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1610729502.git.asml.silence@gmail.com>
References: <cover.1610729502.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>

This is a prep rename patch for subsequent patches to generalize file
registration.

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
[leave io_uring_files_update as struct]
[io_uring_rsrc_update:: rename fds -> data]
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c                 | 228 +++++++++++++++++-----------------
 include/uapi/linux/io_uring.h |   7 ++
 2 files changed, 124 insertions(+), 111 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ac4fe9af6dae..183a761fd9ae 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -195,24 +195,29 @@ struct io_mapped_ubuf {
 	unsigned long	acct_pages;
 };
 
-struct fixed_file_table {
+struct io_rsrc_put {
+	struct list_head list;
+	struct file *file;
+};
+
+struct fixed_rsrc_table {
 	struct file		**files;
 };
 
-struct fixed_file_ref_node {
+struct fixed_rsrc_ref_node {
 	struct percpu_ref		refs;
 	struct list_head		node;
-	struct list_head		file_list;
-	struct fixed_file_data		*file_data;
+	struct list_head		rsrc_list;
+	struct fixed_rsrc_data		*rsrc_data;
 	struct llist_node		llist;
 	bool				done;
 };
 
-struct fixed_file_data {
-	struct fixed_file_table		*table;
+struct fixed_rsrc_data {
+	struct fixed_rsrc_table		*table;
 	struct io_ring_ctx		*ctx;
 
-	struct fixed_file_ref_node	*node;
+	struct fixed_rsrc_ref_node	*node;
 	struct percpu_ref		refs;
 	struct completion		done;
 	struct list_head		ref_list;
@@ -318,7 +323,7 @@ struct io_ring_ctx {
 	 * readers must ensure that ->refs is alive as long as the file* is
 	 * used. Only updated through io_uring_register(2).
 	 */
-	struct fixed_file_data	*file_data;
+	struct fixed_rsrc_data	*file_data;
 	unsigned		nr_user_files;
 
 	/* if used, fixed mapped user buffers */
@@ -382,8 +387,8 @@ struct io_ring_ctx {
 		struct list_head	inflight_list;
 	} ____cacheline_aligned_in_smp;
 
-	struct delayed_work		file_put_work;
-	struct llist_head		file_put_llist;
+	struct delayed_work		rsrc_put_work;
+	struct llist_head		rsrc_put_llist;
 
 	struct work_struct		exit_work;
 	struct io_restriction		restrictions;
@@ -492,7 +497,7 @@ struct io_open {
 	unsigned long			nofile;
 };
 
-struct io_files_update {
+struct io_rsrc_update {
 	struct file			*file;
 	u64				arg;
 	u32				nr_args;
@@ -686,7 +691,7 @@ struct io_kiocb {
 		struct io_sr_msg	sr_msg;
 		struct io_open		open;
 		struct io_close		close;
-		struct io_files_update	files_update;
+		struct io_rsrc_update	rsrc_update;
 		struct io_fadvise	fadvise;
 		struct io_madvise	madvise;
 		struct io_epoll		epoll;
@@ -716,7 +721,7 @@ struct io_kiocb {
 	u64				user_data;
 
 	struct io_kiocb			*link;
-	struct percpu_ref		*fixed_file_refs;
+	struct percpu_ref		*fixed_rsrc_refs;
 
 	/*
 	 * 1. used with ctx->iopoll_list with reads/writes
@@ -991,8 +996,8 @@ enum io_mem_account {
 	ACCT_PINNED,
 };
 
-static void destroy_fixed_file_ref_node(struct fixed_file_ref_node *ref_node);
-static struct fixed_file_ref_node *alloc_fixed_file_ref_node(
+static void destroy_fixed_rsrc_ref_node(struct fixed_rsrc_ref_node *ref_node);
+static struct fixed_rsrc_ref_node *alloc_fixed_file_ref_node(
 			struct io_ring_ctx *ctx);
 
 static void __io_complete_rw(struct io_kiocb *req, long res, long res2,
@@ -1005,13 +1010,13 @@ static struct io_kiocb *io_prep_linked_timeout(struct io_kiocb *req);
 static void __io_queue_linked_timeout(struct io_kiocb *req);
 static void io_queue_linked_timeout(struct io_kiocb *req);
 static int __io_sqe_files_update(struct io_ring_ctx *ctx,
-				 struct io_uring_files_update *ip,
+				 struct io_uring_rsrc_update *ip,
 				 unsigned nr_args);
 static void __io_clean_op(struct io_kiocb *req);
 static struct file *io_file_get(struct io_submit_state *state,
 				struct io_kiocb *req, int fd, bool fixed);
 static void __io_queue_sqe(struct io_kiocb *req, struct io_comp_state *cs);
-static void io_file_put_work(struct work_struct *work);
+static void io_rsrc_put_work(struct work_struct *work);
 
 static ssize_t io_import_iovec(int rw, struct io_kiocb *req,
 			       struct iovec **iovec, struct iov_iter *iter,
@@ -1051,9 +1056,9 @@ static inline void io_set_resource_node(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 
-	if (!req->fixed_file_refs) {
-		req->fixed_file_refs = &ctx->file_data->node->refs;
-		percpu_ref_get(req->fixed_file_refs);
+	if (!req->fixed_rsrc_refs) {
+		req->fixed_rsrc_refs = &ctx->file_data->node->refs;
+		percpu_ref_get(req->fixed_rsrc_refs);
 	}
 }
 
@@ -1312,8 +1317,8 @@ static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	INIT_LIST_HEAD(&ctx->timeout_list);
 	spin_lock_init(&ctx->inflight_lock);
 	INIT_LIST_HEAD(&ctx->inflight_list);
-	INIT_DELAYED_WORK(&ctx->file_put_work, io_file_put_work);
-	init_llist_head(&ctx->file_put_llist);
+	INIT_DELAYED_WORK(&ctx->rsrc_put_work, io_rsrc_put_work);
+	init_llist_head(&ctx->rsrc_put_llist);
 	return ctx;
 err:
 	if (ctx->fallback_req)
@@ -1958,8 +1963,8 @@ static void io_dismantle_req(struct io_kiocb *req)
 		kfree(req->async_data);
 	if (req->file)
 		io_put_file(req, req->file, (req->flags & REQ_F_FIXED_FILE));
-	if (req->fixed_file_refs)
-		percpu_ref_put(req->fixed_file_refs);
+	if (req->fixed_rsrc_refs)
+		percpu_ref_put(req->fixed_rsrc_refs);
 	io_req_clean_work(req);
 }
 
@@ -5934,7 +5939,7 @@ static int io_async_cancel(struct io_kiocb *req)
 	return 0;
 }
 
-static int io_files_update_prep(struct io_kiocb *req,
+static int io_rsrc_update_prep(struct io_kiocb *req,
 				const struct io_uring_sqe *sqe)
 {
 	if (unlikely(req->ctx->flags & IORING_SETUP_SQPOLL))
@@ -5944,11 +5949,11 @@ static int io_files_update_prep(struct io_kiocb *req,
 	if (sqe->ioprio || sqe->rw_flags)
 		return -EINVAL;
 
-	req->files_update.offset = READ_ONCE(sqe->off);
-	req->files_update.nr_args = READ_ONCE(sqe->len);
-	if (!req->files_update.nr_args)
+	req->rsrc_update.offset = READ_ONCE(sqe->off);
+	req->rsrc_update.nr_args = READ_ONCE(sqe->len);
+	if (!req->rsrc_update.nr_args)
 		return -EINVAL;
-	req->files_update.arg = READ_ONCE(sqe->addr);
+	req->rsrc_update.arg = READ_ONCE(sqe->addr);
 	return 0;
 }
 
@@ -5956,17 +5961,17 @@ static int io_files_update(struct io_kiocb *req, bool force_nonblock,
 			   struct io_comp_state *cs)
 {
 	struct io_ring_ctx *ctx = req->ctx;
-	struct io_uring_files_update up;
+	struct io_uring_rsrc_update up;
 	int ret;
 
 	if (force_nonblock)
 		return -EAGAIN;
 
-	up.offset = req->files_update.offset;
-	up.fds = req->files_update.arg;
+	up.offset = req->rsrc_update.offset;
+	up.data = req->rsrc_update.arg;
 
 	mutex_lock(&ctx->uring_lock);
-	ret = __io_sqe_files_update(ctx, &up, req->files_update.nr_args);
+	ret = __io_sqe_files_update(ctx, &up, req->rsrc_update.nr_args);
 	mutex_unlock(&ctx->uring_lock);
 
 	if (ret < 0)
@@ -6021,7 +6026,7 @@ static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	case IORING_OP_CLOSE:
 		return io_close_prep(req, sqe);
 	case IORING_OP_FILES_UPDATE:
-		return io_files_update_prep(req, sqe);
+		return io_rsrc_update_prep(req, sqe);
 	case IORING_OP_STATX:
 		return io_statx_prep(req, sqe);
 	case IORING_OP_FADVISE:
@@ -6391,7 +6396,7 @@ static struct io_wq_work *io_wq_submit_work(struct io_wq_work *work)
 static inline struct file *io_file_from_index(struct io_ring_ctx *ctx,
 					      int index)
 {
-	struct fixed_file_table *table;
+	struct fixed_rsrc_table *table;
 
 	table = &ctx->file_data->table[index >> IORING_FILE_TABLE_SHIFT];
 	return table->files[index & IORING_FILE_TABLE_MASK];
@@ -6777,7 +6782,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	req->ctx = ctx;
 	req->flags = 0;
 	req->link = NULL;
-	req->fixed_file_refs = NULL;
+	req->fixed_rsrc_refs = NULL;
 	/* one is dropped after submission, the other at completion */
 	refcount_set(&req->refs, 2);
 	req->task = current;
@@ -7252,28 +7257,28 @@ static void __io_sqe_files_unregister(struct io_ring_ctx *ctx)
 #endif
 }
 
-static void io_file_ref_kill(struct percpu_ref *ref)
+static void io_rsrc_ref_kill(struct percpu_ref *ref)
 {
-	struct fixed_file_data *data;
+	struct fixed_rsrc_data *data;
 
-	data = container_of(ref, struct fixed_file_data, refs);
+	data = container_of(ref, struct fixed_rsrc_data, refs);
 	complete(&data->done);
 }
 
-static void io_sqe_files_set_node(struct fixed_file_data *file_data,
-				  struct fixed_file_ref_node *ref_node)
+static void io_sqe_rsrc_set_node(struct fixed_rsrc_data *rsrc_data,
+				 struct fixed_rsrc_ref_node *ref_node)
 {
-	spin_lock_bh(&file_data->lock);
-	file_data->node = ref_node;
-	list_add_tail(&ref_node->node, &file_data->ref_list);
-	spin_unlock_bh(&file_data->lock);
-	percpu_ref_get(&file_data->refs);
+	spin_lock_bh(&rsrc_data->lock);
+	rsrc_data->node = ref_node;
+	list_add_tail(&ref_node->node, &rsrc_data->ref_list);
+	spin_unlock_bh(&rsrc_data->lock);
+	percpu_ref_get(&rsrc_data->refs);
 }
 
 static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
 {
-	struct fixed_file_data *data = ctx->file_data;
-	struct fixed_file_ref_node *backup_node, *ref_node = NULL;
+	struct fixed_rsrc_data *data = ctx->file_data;
+	struct fixed_rsrc_ref_node *backup_node, *ref_node = NULL;
 	unsigned nr_tables, i;
 	int ret;
 
@@ -7292,7 +7297,7 @@ static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
 	percpu_ref_kill(&data->refs);
 
 	/* wait for all refs nodes to complete */
-	flush_delayed_work(&ctx->file_put_work);
+	flush_delayed_work(&ctx->rsrc_put_work);
 	do {
 		ret = wait_for_completion_interruptible(&data->done);
 		if (!ret)
@@ -7301,7 +7306,7 @@ static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
 		if (ret < 0) {
 			percpu_ref_resurrect(&data->refs);
 			reinit_completion(&data->done);
-			io_sqe_files_set_node(data, backup_node);
+			io_sqe_rsrc_set_node(data, backup_node);
 			return ret;
 		}
 	} while (1);
@@ -7315,7 +7320,7 @@ static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
 	kfree(data);
 	ctx->file_data = NULL;
 	ctx->nr_user_files = 0;
-	destroy_fixed_file_ref_node(backup_node);
+	destroy_fixed_rsrc_ref_node(backup_node);
 	return 0;
 }
 
@@ -7538,13 +7543,13 @@ static int io_sqe_files_scm(struct io_ring_ctx *ctx)
 }
 #endif
 
-static int io_sqe_alloc_file_tables(struct fixed_file_data *file_data,
+static int io_sqe_alloc_file_tables(struct fixed_rsrc_data *file_data,
 				    unsigned nr_tables, unsigned nr_files)
 {
 	int i;
 
 	for (i = 0; i < nr_tables; i++) {
-		struct fixed_file_table *table = &file_data->table[i];
+		struct fixed_rsrc_table *table = &file_data->table[i];
 		unsigned this_files;
 
 		this_files = min(nr_files, IORING_MAX_FILES_TABLE);
@@ -7559,7 +7564,7 @@ static int io_sqe_alloc_file_tables(struct fixed_file_data *file_data,
 		return 0;
 
 	for (i = 0; i < nr_tables; i++) {
-		struct fixed_file_table *table = &file_data->table[i];
+		struct fixed_rsrc_table *table = &file_data->table[i];
 		kfree(table->files);
 	}
 	return 1;
@@ -7627,56 +7632,51 @@ static void io_ring_file_put(struct io_ring_ctx *ctx, struct file *file)
 #endif
 }
 
-struct io_file_put {
-	struct list_head list;
-	struct file *file;
-};
-
-static void __io_file_put_work(struct fixed_file_ref_node *ref_node)
+static void __io_rsrc_put_work(struct fixed_rsrc_ref_node *ref_node)
 {
-	struct fixed_file_data *file_data = ref_node->file_data;
-	struct io_ring_ctx *ctx = file_data->ctx;
-	struct io_file_put *pfile, *tmp;
+	struct fixed_rsrc_data *rsrc_data = ref_node->rsrc_data;
+	struct io_ring_ctx *ctx = rsrc_data->ctx;
+	struct io_rsrc_put *prsrc, *tmp;
 
-	list_for_each_entry_safe(pfile, tmp, &ref_node->file_list, list) {
-		list_del(&pfile->list);
-		io_ring_file_put(ctx, pfile->file);
-		kfree(pfile);
+	list_for_each_entry_safe(prsrc, tmp, &ref_node->rsrc_list, list) {
+		list_del(&prsrc->list);
+		io_ring_file_put(ctx, prsrc->file);
+		kfree(prsrc);
 	}
 
 	percpu_ref_exit(&ref_node->refs);
 	kfree(ref_node);
-	percpu_ref_put(&file_data->refs);
+	percpu_ref_put(&rsrc_data->refs);
 }
 
-static void io_file_put_work(struct work_struct *work)
+static void io_rsrc_put_work(struct work_struct *work)
 {
 	struct io_ring_ctx *ctx;
 	struct llist_node *node;
 
-	ctx = container_of(work, struct io_ring_ctx, file_put_work.work);
-	node = llist_del_all(&ctx->file_put_llist);
+	ctx = container_of(work, struct io_ring_ctx, rsrc_put_work.work);
+	node = llist_del_all(&ctx->rsrc_put_llist);
 
 	while (node) {
-		struct fixed_file_ref_node *ref_node;
+		struct fixed_rsrc_ref_node *ref_node;
 		struct llist_node *next = node->next;
 
-		ref_node = llist_entry(node, struct fixed_file_ref_node, llist);
-		__io_file_put_work(ref_node);
+		ref_node = llist_entry(node, struct fixed_rsrc_ref_node, llist);
+		__io_rsrc_put_work(ref_node);
 		node = next;
 	}
 }
 
-static void io_file_data_ref_zero(struct percpu_ref *ref)
+static void io_rsrc_data_ref_zero(struct percpu_ref *ref)
 {
-	struct fixed_file_ref_node *ref_node;
-	struct fixed_file_data *data;
+	struct fixed_rsrc_ref_node *ref_node;
+	struct fixed_rsrc_data *data;
 	struct io_ring_ctx *ctx;
 	bool first_add = false;
 	int delay = HZ;
 
-	ref_node = container_of(ref, struct fixed_file_ref_node, refs);
-	data = ref_node->file_data;
+	ref_node = container_of(ref, struct fixed_rsrc_ref_node, refs);
+	data = ref_node->rsrc_data;
 	ctx = data->ctx;
 
 	spin_lock_bh(&data->lock);
@@ -7684,12 +7684,12 @@ static void io_file_data_ref_zero(struct percpu_ref *ref)
 
 	while (!list_empty(&data->ref_list)) {
 		ref_node = list_first_entry(&data->ref_list,
-					struct fixed_file_ref_node, node);
+					struct fixed_rsrc_ref_node, node);
 		/* recycle ref nodes in order */
 		if (!ref_node->done)
 			break;
 		list_del(&ref_node->node);
-		first_add |= llist_add(&ref_node->llist, &ctx->file_put_llist);
+		first_add |= llist_add(&ref_node->llist, &ctx->rsrc_put_llist);
 	}
 	spin_unlock_bh(&data->lock);
 
@@ -7697,33 +7697,33 @@ static void io_file_data_ref_zero(struct percpu_ref *ref)
 		delay = 0;
 
 	if (!delay)
-		mod_delayed_work(system_wq, &ctx->file_put_work, 0);
+		mod_delayed_work(system_wq, &ctx->rsrc_put_work, 0);
 	else if (first_add)
-		queue_delayed_work(system_wq, &ctx->file_put_work, delay);
+		queue_delayed_work(system_wq, &ctx->rsrc_put_work, delay);
 }
 
-static struct fixed_file_ref_node *alloc_fixed_file_ref_node(
+static struct fixed_rsrc_ref_node *alloc_fixed_file_ref_node(
 			struct io_ring_ctx *ctx)
 {
-	struct fixed_file_ref_node *ref_node;
+	struct fixed_rsrc_ref_node *ref_node;
 
 	ref_node = kzalloc(sizeof(*ref_node), GFP_KERNEL);
 	if (!ref_node)
 		return NULL;
 
-	if (percpu_ref_init(&ref_node->refs, io_file_data_ref_zero,
+	if (percpu_ref_init(&ref_node->refs, io_rsrc_data_ref_zero,
 			    0, GFP_KERNEL)) {
 		kfree(ref_node);
 		return NULL;
 	}
 	INIT_LIST_HEAD(&ref_node->node);
-	INIT_LIST_HEAD(&ref_node->file_list);
-	ref_node->file_data = ctx->file_data;
+	INIT_LIST_HEAD(&ref_node->rsrc_list);
+	ref_node->rsrc_data = ctx->file_data;
 	ref_node->done = false;
 	return ref_node;
 }
 
-static void destroy_fixed_file_ref_node(struct fixed_file_ref_node *ref_node)
+static void destroy_fixed_rsrc_ref_node(struct fixed_rsrc_ref_node *ref_node)
 {
 	percpu_ref_exit(&ref_node->refs);
 	kfree(ref_node);
@@ -7736,8 +7736,8 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 	unsigned nr_tables, i;
 	struct file *file;
 	int fd, ret = -ENOMEM;
-	struct fixed_file_ref_node *ref_node;
-	struct fixed_file_data *file_data;
+	struct fixed_rsrc_ref_node *ref_node;
+	struct fixed_rsrc_data *file_data;
 
 	if (ctx->file_data)
 		return -EBUSY;
@@ -7760,7 +7760,7 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 	if (!file_data->table)
 		goto out_free;
 
-	if (percpu_ref_init(&file_data->refs, io_file_ref_kill,
+	if (percpu_ref_init(&file_data->refs, io_rsrc_ref_kill,
 				PERCPU_REF_ALLOW_REINIT, GFP_KERNEL))
 		goto out_free;
 
@@ -7769,7 +7769,7 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 	ctx->file_data = file_data;
 
 	for (i = 0; i < nr_args; i++, ctx->nr_user_files++) {
-		struct fixed_file_table *table;
+		struct fixed_rsrc_table *table;
 		unsigned index;
 
 		if (copy_from_user(&fd, &fds[i], sizeof(fd))) {
@@ -7813,7 +7813,7 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 		return -ENOMEM;
 	}
 
-	io_sqe_files_set_node(file_data, ref_node);
+	io_sqe_rsrc_set_node(file_data, ref_node);
 	return ret;
 out_fput:
 	for (i = 0; i < ctx->nr_user_files; i++) {
@@ -7876,28 +7876,34 @@ static int io_sqe_file_register(struct io_ring_ctx *ctx, struct file *file,
 #endif
 }
 
-static int io_queue_file_removal(struct fixed_file_data *data,
-				 struct file *file)
+static int io_queue_rsrc_removal(struct fixed_rsrc_data *data,
+				 struct file *rsrc)
 {
-	struct io_file_put *pfile;
-	struct fixed_file_ref_node *ref_node = data->node;
+	struct io_rsrc_put *prsrc;
+	struct fixed_rsrc_ref_node *ref_node = data->node;
 
-	pfile = kzalloc(sizeof(*pfile), GFP_KERNEL);
-	if (!pfile)
+	prsrc = kzalloc(sizeof(*prsrc), GFP_KERNEL);
+	if (!prsrc)
 		return -ENOMEM;
 
-	pfile->file = file;
-	list_add(&pfile->list, &ref_node->file_list);
+	prsrc->file = rsrc;
+	list_add(&prsrc->list, &ref_node->rsrc_list);
 
 	return 0;
 }
 
+static inline int io_queue_file_removal(struct fixed_rsrc_data *data,
+					struct file *file)
+{
+	return io_queue_rsrc_removal(data, file);
+}
+
 static int __io_sqe_files_update(struct io_ring_ctx *ctx,
-				 struct io_uring_files_update *up,
+				 struct io_uring_rsrc_update *up,
 				 unsigned nr_args)
 {
-	struct fixed_file_data *data = ctx->file_data;
-	struct fixed_file_ref_node *ref_node;
+	struct fixed_rsrc_data *data = ctx->file_data;
+	struct fixed_rsrc_ref_node *ref_node;
 	struct file *file;
 	__s32 __user *fds;
 	int fd, i, err;
@@ -7914,9 +7920,9 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 		return -ENOMEM;
 
 	done = 0;
-	fds = u64_to_user_ptr(up->fds);
+	fds = u64_to_user_ptr(up->data);
 	while (nr_args) {
-		struct fixed_file_table *table;
+		struct fixed_rsrc_table *table;
 		unsigned index;
 
 		err = 0;
@@ -7969,9 +7975,9 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 
 	if (needs_switch) {
 		percpu_ref_kill(&data->node->refs);
-		io_sqe_files_set_node(data, ref_node);
+		io_sqe_rsrc_set_node(data, ref_node);
 	} else
-		destroy_fixed_file_ref_node(ref_node);
+		destroy_fixed_rsrc_ref_node(ref_node);
 
 	return done ? done : err;
 }
@@ -7979,7 +7985,7 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 static int io_sqe_files_update(struct io_ring_ctx *ctx, void __user *arg,
 			       unsigned nr_args)
 {
-	struct io_uring_files_update up;
+	struct io_uring_rsrc_update up;
 
 	if (!ctx->file_data)
 		return -ENXIO;
@@ -9350,7 +9356,7 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx *ctx, struct seq_file *m)
 	seq_printf(m, "SqThreadCpu:\t%d\n", sq ? task_cpu(sq->thread) : -1);
 	seq_printf(m, "UserFiles:\t%u\n", ctx->nr_user_files);
 	for (i = 0; has_lock && i < ctx->nr_user_files; i++) {
-		struct fixed_file_table *table;
+		struct fixed_rsrc_table *table;
 		struct file *f;
 
 		table = &ctx->file_data->table[i >> IORING_FILE_TABLE_SHIFT];
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index d31a2a1e8ef9..f9f106c54d90 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -285,12 +285,19 @@ enum {
 	IORING_REGISTER_LAST
 };
 
+/* deprecated, see struct io_uring_rsrc_update */
 struct io_uring_files_update {
 	__u32 offset;
 	__u32 resv;
 	__aligned_u64 /* __s32 * */ fds;
 };
 
+struct io_uring_rsrc_update {
+	__u32 offset;
+	__u32 resv;
+	__aligned_u64 data;
+};
+
 #define IO_URING_OP_SUPPORTED	(1U << 0)
 
 struct io_uring_probe_op {
-- 
2.24.0

