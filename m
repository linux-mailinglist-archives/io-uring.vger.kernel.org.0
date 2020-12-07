Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2282F2D1D20
	for <lists+io-uring@lfdr.de>; Mon,  7 Dec 2020 23:20:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728066AbgLGWQ4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 7 Dec 2020 17:16:56 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:38576 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728032AbgLGWQv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 7 Dec 2020 17:16:51 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B7M9so1132280;
        Mon, 7 Dec 2020 22:16:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=kY8QqEnVh/nHKvex/2Yp3Xzp1jSElaXyOg0PTi57HgE=;
 b=CVEWP+HVtDuy7JyasJx8tUrsodOz2qddAkDZcyt+rBmI+hfWZDgYSSnLZRPtyDw/lz5P
 ALzmi7O1/E9k/NywX4EHLpyDFLay/dpq0u4jJc4ezvfsB6LOTeI64AZ33cblyPZz6q/S
 fPlDBJ67LAWKb0DVcEgTClLld/BAg9HI5WEufH5yftiVkxYweql0vt+sBQyvvmtACUVl
 p0aM4K+DWVttdEra0jZWWUpSAhxbToG7FHkjOo/iTmzBLdEwT2MD+r1oktWKIWZaBKfS
 KiCDK1p50A/BjQgssMTf7lEHGOVjTD0MAZmqvFmTtPIGcmT8fCvEhoKZXIA1v27lIHMQ 9g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 3581mqqv5u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 07 Dec 2020 22:16:07 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B7MAUWY063991;
        Mon, 7 Dec 2020 22:16:06 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 358m3wxb9t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Dec 2020 22:16:06 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B7MG6ee006156;
        Mon, 7 Dec 2020 22:16:06 GMT
Received: from ca-ldom147.us.oracle.com (/10.129.68.131)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 07 Dec 2020 14:16:06 -0800
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk, asml.silence@gmail.com, io-uring@vger.kernel.org
Subject: [PATCH v2 09/13] io_uring: create common fixed_rsrc_ref_node handling routines
Date:   Mon,  7 Dec 2020 14:15:48 -0800
Message-Id: <1607379352-68109-10-git-send-email-bijan.mottahedeh@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1607379352-68109-1-git-send-email-bijan.mottahedeh@oracle.com>
References: <1607379352-68109-1-git-send-email-bijan.mottahedeh@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9828 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 adultscore=0
 bulkscore=0 phishscore=0 suspectscore=2 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012070145
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9828 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 mlxlogscore=999
 clxscore=1015 malwarescore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 phishscore=0 spamscore=0 impostorscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012070145
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Create common routines to be used for both files/buffers registration.

Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
---
 fs/io_uring.c | 66 +++++++++++++++++++++++++++--------------------------------
 1 file changed, 30 insertions(+), 36 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index a51d1e6..384ff3c 100644
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
@@ -7736,6 +7743,17 @@ static void destroy_fixed_rsrc_ref_node(struct fixed_rsrc_ref_node *ref_node)
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
@@ -7818,11 +7836,7 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
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
@@ -7911,10 +7925,7 @@ static void switch_fixed_rsrc_ref_node(struct fixed_rsrc_ref_node *ref_node,
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
@@ -7992,10 +8003,9 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
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
@@ -8358,23 +8368,11 @@ static void io_buffers_map_free(struct io_ring_ctx *ctx)
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
 
@@ -8731,11 +8729,7 @@ static int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
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

