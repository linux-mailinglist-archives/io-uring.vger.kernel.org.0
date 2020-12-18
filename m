Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 131252DE8C7
	for <lists+io-uring@lfdr.de>; Fri, 18 Dec 2020 19:08:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726873AbgLRSIY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Dec 2020 13:08:24 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:41146 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726224AbgLRSIX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Dec 2020 13:08:23 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BII40Dn126538;
        Fri, 18 Dec 2020 18:07:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=vijrJT+A1NuvYAmf8wXztC/rajnxbTTTtxAuCKqhJTk=;
 b=eeHokOC2BCCtbmjSLL3Ho7jMLsR3XTA//kgqDEmFybtqAb7aGAkeTiLvRYP1ZO1/UJTR
 M47jg2EBqqIsiZ2ZpHMx0RUFQSzwWXy0uPysiXYfGelDWKAfUnTHqVJtXZWqHhriS2qt
 /5PeJJ+ygh6gGqCCe/YFC8knLHKkt2KhhK38JP2DUyqVNyQe2QIOodtnNkWUp7RkQ/ih
 5GZs0ZqeHONDAFywBfQA09wwUaw4T6Y/AGnCUsjDFP5FsdATcc50PO3Xq/qCqyCql3oT
 /DX/Mkt78MQeYSfpHMn/7qliuTBN6/Hs9Uv272+DQ97O1VJh4TYsJKaBecTn6H7mx4Z2 Nw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 35ckcbuq8d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 18 Dec 2020 18:07:40 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BII5NDx117222;
        Fri, 18 Dec 2020 18:07:39 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 35g3rgfaxj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Dec 2020 18:07:39 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0BII7d7j008682;
        Fri, 18 Dec 2020 18:07:39 GMT
Received: from ca-ldom147.us.oracle.com (/10.129.68.131)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 18 Dec 2020 10:07:38 -0800
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk, asml.silence@gmail.com, io-uring@vger.kernel.org
Subject: [PATCH v3 05/13] io_uring: separate ref_list from fixed_rsrc_data
Date:   Fri, 18 Dec 2020 10:07:20 -0800
Message-Id: <1608314848-67329-6-git-send-email-bijan.mottahedeh@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1608314848-67329-1-git-send-email-bijan.mottahedeh@oracle.com>
References: <1608314848-67329-1-git-send-email-bijan.mottahedeh@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9839 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 spamscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012180124
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9839 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 priorityscore=1501 mlxscore=0 suspectscore=0 adultscore=0 phishscore=0
 malwarescore=0 impostorscore=0 lowpriorityscore=0 clxscore=1015
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012180124
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Uplevel ref_list and make it common to all resources.  This is to
allow one common ref_list to be used for both files, and buffers
in upcoming patches.

Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
---
 fs/io_uring.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c47f2ac..28e178b 100644
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
@@ -1325,6 +1325,8 @@ static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	INIT_LIST_HEAD(&ctx->timeout_list);
 	spin_lock_init(&ctx->inflight_lock);
 	INIT_LIST_HEAD(&ctx->inflight_list);
+	spin_lock_init(&ctx->rsrc_ref_lock);
+	INIT_LIST_HEAD(&ctx->rsrc_ref_list);
 	INIT_DELAYED_WORK(&ctx->rsrc_put_work, io_rsrc_put_work);
 	init_llist_head(&ctx->rsrc_put_llist);
 	return ctx;
@@ -7267,9 +7269,9 @@ static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
 	if (!data)
 		return -ENXIO;
 
-	spin_lock_bh(&data->lock);
+	spin_lock_bh(&ctx->rsrc_ref_lock);
 	ref_node = data->node;
-	spin_unlock_bh(&data->lock);
+	spin_unlock_bh(&ctx->rsrc_ref_lock);
 	if (ref_node)
 		percpu_ref_kill(&ref_node->refs);
 
@@ -7647,11 +7649,11 @@ static void io_rsrc_data_ref_zero(struct percpu_ref *ref)
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
@@ -7659,7 +7661,7 @@ static void io_rsrc_data_ref_zero(struct percpu_ref *ref)
 		list_del(&ref_node->node);
 		first_add |= llist_add(&ref_node->llist, &ctx->rsrc_put_llist);
 	}
-	spin_unlock_bh(&data->lock);
+	spin_unlock_bh(&ctx->rsrc_ref_lock);
 
 	if (percpu_ref_is_dying(&data->refs))
 		delay = 0;
@@ -7720,8 +7722,6 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 		return -ENOMEM;
 	file_data->ctx = ctx;
 	init_completion(&file_data->done);
-	INIT_LIST_HEAD(&file_data->ref_list);
-	spin_lock_init(&file_data->lock);
 
 	nr_tables = DIV_ROUND_UP(nr_args, IORING_MAX_FILES_TABLE);
 	file_data->table = kcalloc(nr_tables, sizeof(*file_data->table),
@@ -7783,9 +7783,9 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
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
@@ -7947,10 +7947,10 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 
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
 		destroy_fixed_rsrc_ref_node(ref_node);
-- 
1.8.3.1

