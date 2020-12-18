Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 801062DE8C8
	for <lists+io-uring@lfdr.de>; Fri, 18 Dec 2020 19:08:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726224AbgLRSIY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Dec 2020 13:08:24 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:41170 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727283AbgLRSIX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Dec 2020 13:08:23 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BII3nOq110596;
        Fri, 18 Dec 2020 18:07:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=1jZSFBlBr75t0SxSg8HCOZaeTmgy1pHgigUKggI8eM4=;
 b=mX6X+eyvB1UbOStut9RuU1sR/EKFQW21W5gPDCphRyYY9SbWJRZwUgQKJMq7CQ4wYDhq
 PZa7oJOe49clwuIUhdHDwE+jdQglXvm/dIahAI8KxCdrmcHYgMXM+PuxnA5eL0OQXd9A
 AoUZbeNQmqnuBIgNVS87/Z0USnTN9Kcb+XO+yiXKBK9Li5b0je8UbQjZap9i7ZHUqsuM
 vQJV4G2yJuakRS2WqqvHAzii+1hWG64eIa62h4efnn60opAP4XwbhovG0LLo78TFaQGG
 rjShWZCULeiT1Ng6xos7mlsc32d3gEeWFLb5q/CZCvr9TQWqmIw3IJekxNaHIrazjOch Eg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 35ckcbuq8h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 18 Dec 2020 18:07:40 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BII5OrQ028478;
        Fri, 18 Dec 2020 18:07:40 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 35d7eskjqe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Dec 2020 18:07:40 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0BII7esW016597;
        Fri, 18 Dec 2020 18:07:40 GMT
Received: from ca-ldom147.us.oracle.com (/10.129.68.131)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 18 Dec 2020 10:07:39 -0800
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk, asml.silence@gmail.com, io-uring@vger.kernel.org
Subject: [PATCH v3 09/13] io_uring: create common fixed_rsrc_ref_node handling routines
Date:   Fri, 18 Dec 2020 10:07:24 -0800
Message-Id: <1608314848-67329-10-git-send-email-bijan.mottahedeh@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1608314848-67329-1-git-send-email-bijan.mottahedeh@oracle.com>
References: <1608314848-67329-1-git-send-email-bijan.mottahedeh@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9839 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 bulkscore=0
 suspectscore=0 adultscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0
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

Create common routines to be used for both files/buffers registration.

Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
---
 fs/io_uring.c | 66 +++++++++++++++++++++++++++--------------------------------
 1 file changed, 30 insertions(+), 36 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index bac2813..7e1467c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7287,14 +7287,10 @@ static inline void io_rsrc_ref_unlock(struct io_ring_ctx *ctx)
 	spin_unlock_bh(&ctx->rsrc_ref_lock);
 }
 
-static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
+static void io_rsrc_ref_quiesce(struct fixed_rsrc_data *data,
+				struct io_ring_ctx *ctx)
 {
-	struct fixed_rsrc_data *data = ctx->file_data;
 	struct fixed_rsrc_ref_node *ref_node = NULL;
-	unsigned nr_tables, i;
-
-	if (!data)
-		return -ENXIO;
 
 	io_rsrc_ref_lock(ctx);
 	ref_node = data->node;
@@ -7307,6 +7303,17 @@ static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
 	/* wait for all refs nodes to complete */
 	flush_delayed_work(&ctx->rsrc_put_work);
 	wait_for_completion(&data->done);
+}
+
+static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
+{
+	struct fixed_rsrc_data *data = ctx->file_data;
+	unsigned nr_tables, i;
+
+	if (!data)
+		return -ENXIO;
+
+	io_rsrc_ref_quiesce(data, ctx);
 
 	__io_sqe_files_unregister(ctx);
 	nr_tables = DIV_ROUND_UP(ctx->nr_user_files, IORING_MAX_FILES_TABLE);
@@ -7739,6 +7746,17 @@ static void destroy_fixed_rsrc_ref_node(struct fixed_rsrc_ref_node *ref_node)
 	kfree(ref_node);
 }
 
+static void add_fixed_rsrc_ref_node(struct fixed_rsrc_ref_node *ref_node,
+				    struct fixed_rsrc_data *data,
+				    struct io_ring_ctx *ctx)
+{
+	io_rsrc_ref_lock(ctx);
+	list_add_tail(&ref_node->node, &ctx->rsrc_ref_list);
+	data->node = ref_node;
+	io_rsrc_ref_unlock(ctx);
+	percpu_ref_get(&data->refs);
+}
+
 static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 				 unsigned nr_args)
 {
@@ -7821,11 +7839,7 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 		return PTR_ERR(ref_node);
 	}
 
-	file_data->node = ref_node;
-	io_rsrc_ref_lock(ctx);
-	list_add_tail(&ref_node->node, &ctx->rsrc_ref_list);
-	io_rsrc_ref_unlock(ctx);
-	percpu_ref_get(&file_data->refs);
+	add_fixed_rsrc_ref_node(ref_node, file_data, ctx);
 	return ret;
 out_fput:
 	for (i = 0; i < ctx->nr_user_files; i++) {
@@ -7914,10 +7928,7 @@ static void switch_fixed_rsrc_ref_node(struct fixed_rsrc_ref_node *ref_node,
 				       struct io_ring_ctx *ctx)
 {
 	percpu_ref_kill(&data->node->refs);
-	io_rsrc_ref_lock(ctx);
-	list_add_tail(&ref_node->node, &ctx->rsrc_ref_list);
-	data->node = ref_node;
-	io_rsrc_ref_unlock(ctx);
+	add_fixed_rsrc_ref_node(ref_node, data, ctx);
 }
 
 static int __io_sqe_files_update(struct io_ring_ctx *ctx,
@@ -7995,10 +8006,9 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 		up->offset++;
 	}
 
-	if (needs_switch) {
+	if (needs_switch)
 		switch_fixed_rsrc_ref_node(ref_node, data, ctx);
-		percpu_ref_get(&ctx->file_data->refs);
-	} else
+	else
 		destroy_fixed_rsrc_ref_node(ref_node);
 
 	return done ? done : err;
@@ -8361,23 +8371,11 @@ static void io_buffers_map_free(struct io_ring_ctx *ctx)
 static int io_sqe_buffers_unregister(struct io_ring_ctx *ctx)
 {
 	struct fixed_rsrc_data *data = ctx->buf_data;
-	struct fixed_rsrc_ref_node *ref_node = NULL;
 
 	if (!data)
 		return -ENXIO;
 
-	io_rsrc_ref_lock(ctx);
-	ref_node = data->node;
-	io_rsrc_ref_unlock(ctx);
-	if (ref_node)
-		percpu_ref_kill(&ref_node->refs);
-
-	percpu_ref_kill(&data->refs);
-
-	/* wait for all refs nodes to complete */
-	flush_delayed_work(&ctx->rsrc_put_work);
-	wait_for_completion(&data->done);
-
+	io_rsrc_ref_quiesce(data, ctx);
 	io_buffers_unmap(ctx);
 	io_buffers_map_free(ctx);
 
@@ -8736,11 +8734,7 @@ static int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
 		return PTR_ERR(ref_node);
 	}
 
-	buf_data->node = ref_node;
-	io_rsrc_ref_lock(ctx);
-	list_add(&ref_node->node, &ctx->rsrc_ref_list);
-	io_rsrc_ref_unlock(ctx);
-	percpu_ref_get(&buf_data->refs);
+	add_fixed_rsrc_ref_node(ref_node, buf_data, ctx);
 	return 0;
 }
 
-- 
1.8.3.1

