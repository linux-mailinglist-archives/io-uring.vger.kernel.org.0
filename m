Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD0412D1D26
	for <lists+io-uring@lfdr.de>; Mon,  7 Dec 2020 23:20:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728065AbgLGWQ5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 7 Dec 2020 17:16:57 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:38570 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727841AbgLGWQv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 7 Dec 2020 17:16:51 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B7M9qja132230;
        Mon, 7 Dec 2020 22:16:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=WvE26rpiJLsvKQxnCGCPL8x88CUtkympKHkqorwAXWc=;
 b=hzU/tK3SNJ6+z7MVRVeIN2hddRaHVD9v9yRubrCiDn7wM2/CFPWvv8P3hmU1SYxno+SI
 rF7crVUMwKwuH+8fgaNWNk8dWL3kw77RoCzMQY+jiZgSUPM+XdO42GkaDbjdUrzDOst5
 JXldyfeRyKY7AnJ9hfKSKyYVqJBazb0NZKXBSujTqS9csglHg7sMyvVONCjeuzPvjox/
 qI5arPV0gFwj3gUPPc4kNNemq5zYKUUvrfx343n/jImV58WsOPc5CMTjTKOUypBe9H28
 hYsE8kwbtoLgq1Uez6AsZQoLy4DlU6xnmcDy99M/1vlUGzfh7VhQ+8sA4h/KzPI/tNL5 xQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 3581mqqv5t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 07 Dec 2020 22:16:07 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B7MAV9c064039;
        Mon, 7 Dec 2020 22:16:06 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 358m3wxb9f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Dec 2020 22:16:06 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B7MG5I0006730;
        Mon, 7 Dec 2020 22:16:05 GMT
Received: from ca-ldom147.us.oracle.com (/10.129.68.131)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 07 Dec 2020 14:16:05 -0800
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk, asml.silence@gmail.com, io-uring@vger.kernel.org
Subject: [PATCH v2 05/13] io_uring: separate ref_list from fixed_rsrc_data
Date:   Mon,  7 Dec 2020 14:15:44 -0800
Message-Id: <1607379352-68109-6-git-send-email-bijan.mottahedeh@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1607379352-68109-1-git-send-email-bijan.mottahedeh@oracle.com>
References: <1607379352-68109-1-git-send-email-bijan.mottahedeh@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9828 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 adultscore=0
 bulkscore=0 phishscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012070145
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9828 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 clxscore=1015 malwarescore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 phishscore=0 spamscore=0 impostorscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012070145
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Uplevel ref_list and make it common to all resources.  This is to
allow one common ref_list to be used for both files, and buffers
in upcoming patches.

Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
---
 fs/io_uring.c | 77 ++++++++++++++++++++++++++++-------------------------------
 1 file changed, 36 insertions(+), 41 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 33b2ff6..1ed63bc 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -231,8 +231,6 @@ struct fixed_rsrc_data {
 	struct fixed_rsrc_ref_node	*node;
 	struct percpu_ref		refs;
 	struct completion		done;
-	struct list_head		ref_list;
-	spinlock_t			lock;
 };
 
 struct io_buffer {
@@ -398,8 +396,10 @@ struct io_ring_ctx {
 		struct list_head	inflight_list;
 	} ____cacheline_aligned_in_smp;
 
-	struct delayed_work		file_put_work;
-	struct llist_head		file_put_llist;
+	struct delayed_work		rsrc_put_work;
+	struct llist_head		rsrc_put_llist;
+	struct list_head		rsrc_ref_list;
+	spinlock_t			rsrc_ref_lock;
 
 	struct work_struct		exit_work;
 	struct io_restriction		restrictions;
@@ -1024,7 +1024,7 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 static struct file *io_file_get(struct io_submit_state *state,
 				struct io_kiocb *req, int fd, bool fixed);
 static void __io_queue_sqe(struct io_kiocb *req, struct io_comp_state *cs);
-static void io_file_put_work(struct work_struct *work);
+static void io_rsrc_put_work(struct work_struct *work);
 
 static ssize_t io_import_iovec(int rw, struct io_kiocb *req,
 			       struct iovec **iovec, struct iov_iter *iter,
@@ -1325,8 +1325,10 @@ static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	INIT_LIST_HEAD(&ctx->timeout_list);
 	spin_lock_init(&ctx->inflight_lock);
 	INIT_LIST_HEAD(&ctx->inflight_list);
-	INIT_DELAYED_WORK(&ctx->file_put_work, io_file_put_work);
-	init_llist_head(&ctx->file_put_llist);
+	spin_lock_init(&ctx->rsrc_ref_lock);
+	INIT_LIST_HEAD(&ctx->rsrc_ref_list);
+	INIT_DELAYED_WORK(&ctx->rsrc_put_work, io_rsrc_put_work);
+	init_llist_head(&ctx->rsrc_put_llist);
 	return ctx;
 err:
 	if (ctx->fallback_req)
@@ -7267,16 +7269,16 @@ static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
 	if (!data)
 		return -ENXIO;
 
-	spin_lock_bh(&data->lock);
+	spin_lock_bh(&ctx->rsrc_ref_lock);
 	ref_node = data->node;
-	spin_unlock_bh(&data->lock);
+	spin_unlock_bh(&ctx->rsrc_ref_lock);
 	if (ref_node)
 		percpu_ref_kill(&ref_node->refs);
 
 	percpu_ref_kill(&data->refs);
 
 	/* wait for all refs nodes to complete */
-	flush_delayed_work(&ctx->file_put_work);
+	flush_delayed_work(&ctx->rsrc_put_work);
 	wait_for_completion(&data->done);
 
 	__io_sqe_files_unregister(ctx);
@@ -7617,30 +7619,25 @@ static void __io_rsrc_put_work(struct fixed_rsrc_ref_node *ref_node)
 	percpu_ref_put(&rsrc_data->refs);
 }
 
-static void io_rsrc_put_work(struct llist_node *node)
+static void io_rsrc_put_work(struct work_struct *work)
 {
-	struct fixed_rsrc_ref_node *ref_node;
-	struct llist_node *next;
+	struct io_ring_ctx *ctx;
+	struct llist_node *node;
+
+	ctx = container_of(work, struct io_ring_ctx, rsrc_put_work.work);
+	node = llist_del_all(&ctx->rsrc_put_llist);
 
 	while (node) {
-		next = node->next;
+		struct fixed_rsrc_ref_node *ref_node;
+		struct llist_node *next = node->next;
+
 		ref_node = llist_entry(node, struct fixed_rsrc_ref_node, llist);
 		__io_rsrc_put_work(ref_node);
 		node = next;
 	}
 }
 
-static void io_file_put_work(struct work_struct *work)
-{
-	struct io_ring_ctx *ctx;
-	struct llist_node *node;
-
-	ctx = container_of(work, struct io_ring_ctx, file_put_work.work);
-	node = llist_del_all(&ctx->file_put_llist);
-	io_rsrc_put_work(node);
-}
-
-static void io_file_data_ref_zero(struct percpu_ref *ref)
+static void io_rsrc_data_ref_zero(struct percpu_ref *ref)
 {
 	struct fixed_rsrc_ref_node *ref_node;
 	struct fixed_rsrc_data *data;
@@ -7652,27 +7649,27 @@ static void io_file_data_ref_zero(struct percpu_ref *ref)
 	data = ref_node->rsrc_data;
 	ctx = data->ctx;
 
-	spin_lock_bh(&data->lock);
+	spin_lock_bh(&ctx->rsrc_ref_lock);
 	ref_node->done = true;
 
-	while (!list_empty(&data->ref_list)) {
-		ref_node = list_first_entry(&data->ref_list,
+	while (!list_empty(&ctx->rsrc_ref_list)) {
+		ref_node = list_first_entry(&ctx->rsrc_ref_list,
 					struct fixed_rsrc_ref_node, node);
 		/* recycle ref nodes in order */
 		if (!ref_node->done)
 			break;
 		list_del(&ref_node->node);
-		first_add |= llist_add(&ref_node->llist, &ctx->file_put_llist);
+		first_add |= llist_add(&ref_node->llist, &ctx->rsrc_put_llist);
 	}
-	spin_unlock_bh(&data->lock);
+	spin_unlock_bh(&ctx->rsrc_ref_lock);
 
 	if (percpu_ref_is_dying(&data->refs))
 		delay = 0;
 
 	if (!delay)
-		mod_delayed_work(system_wq, &ctx->file_put_work, 0);
+		mod_delayed_work(system_wq, &ctx->rsrc_put_work, 0);
 	else if (first_add)
-		queue_delayed_work(system_wq, &ctx->file_put_work, delay);
+		queue_delayed_work(system_wq, &ctx->rsrc_put_work, delay);
 }
 
 static struct fixed_rsrc_ref_node *alloc_fixed_file_ref_node(
@@ -7684,7 +7681,7 @@ static struct fixed_rsrc_ref_node *alloc_fixed_file_ref_node(
 	if (!ref_node)
 		return ERR_PTR(-ENOMEM);
 
-	if (percpu_ref_init(&ref_node->refs, io_file_data_ref_zero,
+	if (percpu_ref_init(&ref_node->refs, io_rsrc_data_ref_zero,
 			    0, GFP_KERNEL)) {
 		kfree(ref_node);
 		return ERR_PTR(-ENOMEM);
@@ -7725,8 +7722,6 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 		return -ENOMEM;
 	file_data->ctx = ctx;
 	init_completion(&file_data->done);
-	INIT_LIST_HEAD(&file_data->ref_list);
-	spin_lock_init(&file_data->lock);
 
 	nr_tables = DIV_ROUND_UP(nr_args, IORING_MAX_FILES_TABLE);
 	file_data->table = kcalloc(nr_tables, sizeof(*file_data->table),
@@ -7788,9 +7783,9 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 	}
 
 	file_data->node = ref_node;
-	spin_lock_bh(&file_data->lock);
-	list_add_tail(&ref_node->node, &file_data->ref_list);
-	spin_unlock_bh(&file_data->lock);
+	spin_lock_bh(&ctx->rsrc_ref_lock);
+	list_add_tail(&ref_node->node, &ctx->rsrc_ref_list);
+	spin_unlock_bh(&ctx->rsrc_ref_lock);
 	percpu_ref_get(&file_data->refs);
 	return ret;
 out_fput:
@@ -7952,10 +7947,10 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 
 	if (needs_switch) {
 		percpu_ref_kill(&data->node->refs);
-		spin_lock_bh(&data->lock);
-		list_add_tail(&ref_node->node, &data->ref_list);
+		spin_lock_bh(&ctx->rsrc_ref_lock);
+		list_add_tail(&ref_node->node, &ctx->rsrc_ref_list);
 		data->node = ref_node;
-		spin_unlock_bh(&data->lock);
+		spin_unlock_bh(&ctx->rsrc_ref_lock);
 		percpu_ref_get(&ctx->file_data->refs);
 	} else
 		destroy_fixed_file_ref_node(ref_node);
-- 
1.8.3.1

