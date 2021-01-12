Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9ED832F3BDC
	for <lists+io-uring@lfdr.de>; Tue, 12 Jan 2021 22:35:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406974AbhALVeM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 12 Jan 2021 16:34:12 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:39060 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406586AbhALVeK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 12 Jan 2021 16:34:10 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10CLDpn7169296;
        Tue, 12 Jan 2021 21:33:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=kV6YlTfszGsvxtl3/jTgvtyIP56xm+UJpMvSQlOczNw=;
 b=Kja1tTkx747Z7YKgqgcZHRbvKc8BJcInV+nSYJVvuB61wI8K6LCunYP+i3Pjjn/eUPSO
 it67s9Z/7cMB0pW1ZkOApYKhzgKMODwnH9yUIQzw/07OgloYpdxt4eRKO3ZtfW39zhsz
 pkuxhWyi8Zlyob8HXBbMDhMUV3a8I/71mD6taRcZbKoeTqLAez00jdW0LA0rjZ0oZVus
 Sa6h0wVcJObQ8wx6xJE3WV4thK+j47ZxlyVbTFdmTRmkt0MWl+oyLXx/350SODmimZ1U
 8R7ddhUwZk/HD7MNPw24rnrjdTxX/a6De8kXLnJDZ4k8p5InYy8PugeMHKwt2utWTUv0 cQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 360kcyrkea-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Jan 2021 21:33:28 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10CLG3k6103836;
        Tue, 12 Jan 2021 21:33:28 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 360keyeu7j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Jan 2021 21:33:28 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 10CLXQUD005148;
        Tue, 12 Jan 2021 21:33:27 GMT
Received: from ca-ldom147.us.oracle.com (/10.129.68.131)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 12 Jan 2021 13:33:26 -0800
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk, asml.silence@gmail.com, io-uring@vger.kernel.org
Subject: [PATCH v5 03/13] io_uring: separate ref_list from fixed_rsrc_data
Date:   Tue, 12 Jan 2021 13:33:03 -0800
Message-Id: <1610487193-21374-4-git-send-email-bijan.mottahedeh@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1610487193-21374-1-git-send-email-bijan.mottahedeh@oracle.com>
References: <1610487193-21374-1-git-send-email-bijan.mottahedeh@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9862 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 suspectscore=0 adultscore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101120127
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9862 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0
 impostorscore=0 bulkscore=0 adultscore=0 suspectscore=0 malwarescore=0
 lowpriorityscore=0 clxscore=1015 mlxlogscore=999 mlxscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101120127
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Uplevel ref_list and make it common to all resources.  This is to
allow one common ref_list to be used for both files, and buffers
in upcoming patches.

Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
---
 fs/io_uring.c | 35 ++++++++++++++++++-----------------
 1 file changed, 18 insertions(+), 17 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 12eede8..158b53f 100644
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
@@ -400,6 +398,8 @@ struct io_ring_ctx {
 
 	struct delayed_work		rsrc_put_work;
 	struct llist_head		rsrc_put_llist;
+	struct list_head		rsrc_ref_list;
+	spinlock_t			rsrc_ref_lock;
 
 	struct work_struct		exit_work;
 	struct io_restriction		restrictions;
@@ -1328,6 +1328,8 @@ static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	INIT_LIST_HEAD(&ctx->timeout_list);
 	spin_lock_init(&ctx->inflight_lock);
 	INIT_LIST_HEAD(&ctx->inflight_list);
+	spin_lock_init(&ctx->rsrc_ref_lock);
+	INIT_LIST_HEAD(&ctx->rsrc_ref_list);
 	INIT_DELAYED_WORK(&ctx->rsrc_put_work, io_rsrc_put_work);
 	init_llist_head(&ctx->rsrc_put_llist);
 	return ctx;
@@ -7258,13 +7260,14 @@ static void io_rsrc_ref_kill(struct percpu_ref *ref)
 	complete(&data->done);
 }
 
-static void io_sqe_rsrc_set_node(struct fixed_rsrc_data *rsrc_data,
+static void io_sqe_rsrc_set_node(struct io_ring_ctx *ctx,
+				 struct fixed_rsrc_data *rsrc_data,
 				 struct fixed_rsrc_ref_node *ref_node)
 {
-	spin_lock_bh(&rsrc_data->lock);
+	spin_lock_bh(&ctx->rsrc_ref_lock);
 	rsrc_data->node = ref_node;
-	list_add_tail(&ref_node->node, &rsrc_data->ref_list);
-	spin_unlock_bh(&rsrc_data->lock);
+	list_add_tail(&ref_node->node, &ctx->rsrc_ref_list);
+	spin_unlock_bh(&ctx->rsrc_ref_lock);
 	percpu_ref_get(&rsrc_data->refs);
 }
 
@@ -7281,9 +7284,9 @@ static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
 	if (!backup_node)
 		return -ENOMEM;
 
-	spin_lock_bh(&data->lock);
+	spin_lock_bh(&ctx->rsrc_ref_lock);
 	ref_node = data->node;
-	spin_unlock_bh(&data->lock);
+	spin_unlock_bh(&ctx->rsrc_ref_lock);
 	if (ref_node)
 		percpu_ref_kill(&ref_node->refs);
 
@@ -7299,7 +7302,7 @@ static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
 		if (ret < 0) {
 			percpu_ref_resurrect(&data->refs);
 			reinit_completion(&data->done);
-			io_sqe_rsrc_set_node(data, backup_node);
+			io_sqe_rsrc_set_node(ctx, data, backup_node);
 			return ret;
 		}
 	} while (1);
@@ -7673,11 +7676,11 @@ static void io_rsrc_data_ref_zero(struct percpu_ref *ref)
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
@@ -7685,7 +7688,7 @@ static void io_rsrc_data_ref_zero(struct percpu_ref *ref)
 		list_del(&ref_node->node);
 		first_add |= llist_add(&ref_node->llist, &ctx->rsrc_put_llist);
 	}
-	spin_unlock_bh(&data->lock);
+	spin_unlock_bh(&ctx->rsrc_ref_lock);
 
 	if (percpu_ref_is_dying(&data->refs))
 		delay = 0;
@@ -7746,8 +7749,6 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 		return -ENOMEM;
 	file_data->ctx = ctx;
 	init_completion(&file_data->done);
-	INIT_LIST_HEAD(&file_data->ref_list);
-	spin_lock_init(&file_data->lock);
 
 	nr_tables = DIV_ROUND_UP(nr_args, IORING_MAX_FILES_TABLE);
 	file_data->table = kcalloc(nr_tables, sizeof(*file_data->table),
@@ -7808,7 +7809,7 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 		return PTR_ERR(ref_node);
 	}
 
-	io_sqe_rsrc_set_node(file_data, ref_node);
+	io_sqe_rsrc_set_node(ctx, file_data, ref_node);
 	return ret;
 out_fput:
 	for (i = 0; i < ctx->nr_user_files; i++) {
@@ -7969,7 +7970,7 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 
 	if (needs_switch) {
 		percpu_ref_kill(&data->node->refs);
-		io_sqe_rsrc_set_node(data, ref_node);
+		io_sqe_rsrc_set_node(ctx, data, ref_node);
 	} else
 		destroy_fixed_rsrc_ref_node(ref_node);
 
-- 
1.8.3.1

