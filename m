Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76A5B2EC547
	for <lists+io-uring@lfdr.de>; Wed,  6 Jan 2021 21:42:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726989AbhAFUmU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 6 Jan 2021 15:42:20 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:49484 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727641AbhAFUmT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 6 Jan 2021 15:42:19 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 106KXV9Q101844;
        Wed, 6 Jan 2021 20:41:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=GI5gvzkAHCmamvPc8V72ebEaQPTefto0LxSlLKlWN1g=;
 b=NvmFeA0NjydrCJFESiCq+Sao03ZnLtd1YbxPLZbjMzHlSwtawX79kSl9yqLJ3ScxouAZ
 zfAUje6bcu9appNTTj7MPBv7cjA987SGifTSTz93jLKZtlvkAq5rAEP8pFyN4b2ZFtvG
 QEG4nyz+AP/xx/zTfPWLwYUjOfNtMhdLunffjfp3Sv8U8ePIc6Ps28ZD83XpPHFW7t8Z
 bIwK1a4m6af610jOlxgJN2RxxBdYJlAfexAF8cCx3wyy82ZBWVa0b0UAzE7+kdRTAnNy
 Lt6m2IOf+1W5kWBxdKcQmEqGIdX+2pD2DdPHJKe3TBoS4RLxSSkN4NzuV+o7JXIgBPJy MA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 35wftx9c1c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 06 Jan 2021 20:41:36 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 106KaTMs178119;
        Wed, 6 Jan 2021 20:39:35 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 35v4rd3tx4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Jan 2021 20:39:35 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 106KdYGB021612;
        Wed, 6 Jan 2021 20:39:34 GMT
Received: from ca-ldom147.us.oracle.com (/10.129.68.131)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 Jan 2021 20:39:34 +0000
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk, asml.silence@gmail.com, io-uring@vger.kernel.org
Subject: [PATCH v4 12/13] io_uring: create common fixed_rsrc_data allocation routines
Date:   Wed,  6 Jan 2021 12:39:21 -0800
Message-Id: <1609965562-13569-13-git-send-email-bijan.mottahedeh@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1609965562-13569-1-git-send-email-bijan.mottahedeh@oracle.com>
References: <1609965562-13569-1-git-send-email-bijan.mottahedeh@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9856 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 bulkscore=0
 suspectscore=0 spamscore=0 adultscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101060117
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9856 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 mlxscore=0
 bulkscore=0 priorityscore=1501 impostorscore=0 clxscore=1015
 lowpriorityscore=0 mlxlogscore=999 malwarescore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101060117
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Create common alloc/free fixed_rsrc_data routines for both files and
buffers.

Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
---
 fs/io_uring.c | 75 ++++++++++++++++++++++++++++++++---------------------------
 1 file changed, 41 insertions(+), 34 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index dcbf9b1..ea708ec 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7366,6 +7366,33 @@ static int io_rsrc_ref_quiesce(struct fixed_rsrc_data *data,
 	return 0;
 }
 
+static struct fixed_rsrc_data *alloc_fixed_rsrc_data(struct io_ring_ctx *ctx)
+{
+	struct fixed_rsrc_data *data;
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return ERR_PTR(-ENOMEM);
+
+	data->ctx = ctx;
+	init_completion(&data->done);
+
+	if (percpu_ref_init(&data->refs, io_rsrc_ref_kill,
+			    PERCPU_REF_ALLOW_REINIT, GFP_KERNEL)) {
+		kfree(data);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	return data;
+}
+
+static void free_fixed_rsrc_data(struct fixed_rsrc_data *data)
+{
+	percpu_ref_exit(&data->refs);
+	kfree(data->table);
+	kfree(data);
+}
+
 static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
 {
 	struct fixed_rsrc_data *data = ctx->file_data;
@@ -7383,9 +7410,7 @@ static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
 	nr_tables = DIV_ROUND_UP(ctx->nr_user_files, IORING_MAX_FILES_TABLE);
 	for (i = 0; i < nr_tables; i++)
 		kfree(data->table[i].files);
-	kfree(data->table);
-	percpu_ref_exit(&data->refs);
-	kfree(data);
+	free_fixed_rsrc_data(ctx->file_data);
 	ctx->file_data = NULL;
 	ctx->nr_user_files = 0;
 	return 0;
@@ -7827,11 +7852,9 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 	if (nr_args > IORING_MAX_FIXED_FILES)
 		return -EMFILE;
 
-	file_data = kzalloc(sizeof(*ctx->file_data), GFP_KERNEL);
-	if (!file_data)
-		return -ENOMEM;
-	file_data->ctx = ctx;
-	init_completion(&file_data->done);
+	file_data = alloc_fixed_rsrc_data(ctx);
+	if (IS_ERR(file_data))
+		return PTR_ERR(ref_node);
 
 	nr_tables = DIV_ROUND_UP(nr_args, IORING_MAX_FILES_TABLE);
 	file_data->table = kcalloc(nr_tables, sizeof(*file_data->table),
@@ -7839,12 +7862,8 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 	if (!file_data->table)
 		goto out_free;
 
-	if (percpu_ref_init(&file_data->refs, io_rsrc_ref_kill,
-				PERCPU_REF_ALLOW_REINIT, GFP_KERNEL))
-		goto out_free;
-
 	if (io_sqe_alloc_file_tables(file_data, nr_tables, nr_args))
-		goto out_ref;
+		goto out_free;
 	ctx->file_data = file_data;
 
 	for (i = 0; i < nr_args; i++, ctx->nr_user_files++) {
@@ -7903,11 +7922,8 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 	for (i = 0; i < nr_tables; i++)
 		kfree(file_data->table[i].files);
 	ctx->nr_user_files = 0;
-out_ref:
-	percpu_ref_exit(&file_data->refs);
 out_free:
-	kfree(file_data->table);
-	kfree(file_data);
+	free_fixed_rsrc_data(ctx->file_data);
 	ctx->file_data = NULL;
 	return ret;
 }
@@ -8673,32 +8689,23 @@ static struct fixed_rsrc_data *io_buffers_map_alloc(struct io_ring_ctx *ctx,
 	if (!nr_args || nr_args > IORING_MAX_FIXED_BUFS)
 		return ERR_PTR(-EINVAL);
 
-	buf_data = kzalloc(sizeof(*ctx->buf_data), GFP_KERNEL);
-	if (!buf_data)
-		return ERR_PTR(-ENOMEM);
-	buf_data->ctx = ctx;
-	init_completion(&buf_data->done);
+	buf_data = alloc_fixed_rsrc_data(ctx);
+	if (IS_ERR(buf_data))
+		return buf_data;
 
 	nr_tables = DIV_ROUND_UP(nr_args, IORING_MAX_BUFS_TABLE);
 	buf_data->table = kcalloc(nr_tables, sizeof(*buf_data->table),
 				  GFP_KERNEL);
 	if (!buf_data->table)
-		goto out_free;
-
-	if (percpu_ref_init(&buf_data->refs, io_rsrc_ref_kill,
-			    PERCPU_REF_ALLOW_REINIT, GFP_KERNEL))
-		goto out_free;
+		goto out;
 
 	if (io_alloc_buf_tables(buf_data, nr_tables, nr_args))
-		goto out_ref;
+		goto out;
 
 	return buf_data;
-
-out_ref:
-	percpu_ref_exit(&buf_data->refs);
-out_free:
-	kfree(buf_data->table);
-	kfree(buf_data);
+out:
+	free_fixed_rsrc_data(ctx->buf_data);
+	ctx->buf_data = NULL;
 	return ERR_PTR(ret);
 }
 
-- 
1.8.3.1

