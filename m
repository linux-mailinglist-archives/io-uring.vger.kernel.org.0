Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B6A52F3DE8
	for <lists+io-uring@lfdr.de>; Wed, 13 Jan 2021 01:44:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730454AbhALVs5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 12 Jan 2021 16:48:57 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:40538 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392623AbhALVgM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 12 Jan 2021 16:36:12 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10CLXoIK005610;
        Tue, 12 Jan 2021 21:35:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=2Snq7a7fFvMyZzVwF1prX8ROgb+dvkgETArtBzBmaoA=;
 b=h2hzq8sDcSbX0slEgYXx/kVYG3DYJFN6gN2OrZ989EFZhnGPcsbEdoVan/1roHC21JF4
 rFjQIEcqd25Ile+MxtWiAUzZt9qZa+05biCHiVa5cLgbJ6FgY26RjgSS4KNOp66YUsz6
 7ZM4/LxnXRdmPi3CYCFIlo2e3Pk55fdUfhhje8528tT9Ii92k6iCZYmwhYAO9YQympKI
 OldHWvHrul4vW2xbbyVY9+yRaQZXtRU3etgjo6eOTUwKsX0HZiebJ0Kb8kP5MtPI9EMj
 Ry0a4TCTH9Vfc5BMdLXFblbf69fiXecmG4WhCmkG+4ctiYqgcGaZ7/hiidVBYR8PR7mM EA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 360kcyrkn0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Jan 2021 21:35:29 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10CLFaCZ131342;
        Tue, 12 Jan 2021 21:33:29 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 360ke76qsd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Jan 2021 21:33:29 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 10CLXSOI005152;
        Tue, 12 Jan 2021 21:33:28 GMT
Received: from ca-ldom147.us.oracle.com (/10.129.68.131)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 12 Jan 2021 13:33:27 -0800
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk, asml.silence@gmail.com, io-uring@vger.kernel.org
Subject: [PATCH v5 07/13] io_uring: create common fixed_rsrc_ref_node handling routines
Date:   Tue, 12 Jan 2021 13:33:07 -0800
Message-Id: <1610487193-21374-8-git-send-email-bijan.mottahedeh@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1610487193-21374-1-git-send-email-bijan.mottahedeh@oracle.com>
References: <1610487193-21374-1-git-send-email-bijan.mottahedeh@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9862 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 mlxscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101120127
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9862 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0
 impostorscore=0 bulkscore=0 adultscore=0 suspectscore=0 malwarescore=0
 lowpriorityscore=0 clxscore=1015 mlxlogscore=999 mlxscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101120128
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Create common routines to be used for both files/buffers registration.

Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
---
 fs/io_uring.c | 53 +++++++++++++++++++++++++++++------------------------
 1 file changed, 29 insertions(+), 24 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 1477015..6ebfe1f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1018,6 +1018,8 @@ enum io_mem_account {
 static void destroy_fixed_rsrc_ref_node(struct fixed_rsrc_ref_node *ref_node);
 static struct fixed_rsrc_ref_node *alloc_fixed_file_ref_node(
 			struct io_ring_ctx *ctx);
+static struct fixed_rsrc_ref_node *alloc_fixed_buf_ref_node(
+			struct io_ring_ctx *ctx);
 
 static void __io_complete_rw(struct io_kiocb *req, long res, long res2,
 			     struct io_comp_state *cs);
@@ -7298,16 +7300,15 @@ static void io_sqe_rsrc_set_node(struct io_ring_ctx *ctx,
 	percpu_ref_get(&rsrc_data->refs);
 }
 
-static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
+static int io_rsrc_ref_quiesce(struct fixed_rsrc_data *data,
+			       struct io_ring_ctx *ctx,
+			       struct fixed_rsrc_ref_node *(*alloc)(
+			       struct io_ring_ctx *ctx))
 {
-	struct fixed_rsrc_data *data = ctx->file_data;
 	struct fixed_rsrc_ref_node *backup_node, *ref_node = NULL;
-	unsigned nr_tables, i;
 	int ret;
 
-	if (!data)
-		return -ENXIO;
-	backup_node = alloc_fixed_file_ref_node(ctx);
+	backup_node = alloc(ctx);
 	if (!backup_node)
 		return -ENOMEM;
 
@@ -7334,6 +7335,23 @@ static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
 		}
 	} while (1);
 
+	destroy_fixed_rsrc_ref_node(backup_node);
+	return 0;
+}
+
+static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
+{
+	struct fixed_rsrc_data *data = ctx->file_data;
+	unsigned int nr_tables, i;
+	int ret;
+
+	if (!data)
+		return -ENXIO;
+
+	ret = io_rsrc_ref_quiesce(data, ctx, alloc_fixed_file_ref_node);
+	if (ret)
+		return ret;
+
 	__io_sqe_files_unregister(ctx);
 	nr_tables = DIV_ROUND_UP(ctx->nr_user_files, IORING_MAX_FILES_TABLE);
 	for (i = 0; i < nr_tables; i++)
@@ -7343,7 +7361,6 @@ static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
 	kfree(data);
 	ctx->file_data = NULL;
 	ctx->nr_user_files = 0;
-	destroy_fixed_rsrc_ref_node(backup_node);
 	return 0;
 }
 
@@ -8379,22 +8396,14 @@ static void io_buffers_map_free(struct io_ring_ctx *ctx)
 static int io_sqe_buffers_unregister(struct io_ring_ctx *ctx)
 {
 	struct fixed_rsrc_data *data = ctx->buf_data;
-	struct fixed_rsrc_ref_node *ref_node = NULL;
+	int ret;
 
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
+	ret = io_rsrc_ref_quiesce(data, ctx, alloc_fixed_buf_ref_node);
+	if (ret)
+		return ret;
 
 	io_buffers_unmap(ctx);
 	io_buffers_map_free(ctx);
@@ -8746,11 +8755,7 @@ static int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
 		return PTR_ERR(ref_node);
 	}
 
-	buf_data->node = ref_node;
-	io_rsrc_ref_lock(ctx);
-	list_add(&ref_node->node, &ctx->rsrc_ref_list);
-	io_rsrc_ref_unlock(ctx);
-	percpu_ref_get(&buf_data->refs);
+	io_sqe_rsrc_set_node(ctx, buf_data, ref_node);
 	return 0;
 }
 
-- 
1.8.3.1

