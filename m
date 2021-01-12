Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1D3E2F3DE6
	for <lists+io-uring@lfdr.de>; Wed, 13 Jan 2021 01:44:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730283AbhALVs4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 12 Jan 2021 16:48:56 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:48360 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392609AbhALVgN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 12 Jan 2021 16:36:13 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10CLYCTi115165;
        Tue, 12 Jan 2021 21:35:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=1vBc7ilC2PE8h5UmGrSCFNJuWQcrWSDTy9P/UgHr5jg=;
 b=JLpkRr1PdINTWfezeBEgfmRl+y+EmijsCQOK8DBwOQihbTmafF+oZU1CVYZRoZ9K4I0P
 IAWM4yOlqp9R8qXeYtPql9q2MHa1saC+m9zgpW5TCRZIcjOVhzYhsmH5OacTvY5UL+rl
 UfBih3kRMCe71p476pawPvxtIs4mhFRSQkxvXsq7kL5T2vdMRyshNbX9+uls3xoT6Da6
 2Lpko4E7hMJS5O1tKF9YexqbjhmmvlzjRBAJ/TaVdcwA6Tde6VP0gdAk8UsJv3eXHBkQ
 8e3k6jrUZSRu/x2CeltrltMcQlgKKbTSmVPdq5/9RW1hgbEp6DoJcDdrdzu4oloGn8Uw 7g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 360kg1rk5v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Jan 2021 21:35:30 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10CLGTnx174409;
        Tue, 12 Jan 2021 21:33:29 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 360kf665uw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Jan 2021 21:33:29 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 10CLXSHf011387;
        Tue, 12 Jan 2021 21:33:28 GMT
Received: from ca-ldom147.us.oracle.com (/10.129.68.131)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 12 Jan 2021 13:33:28 -0800
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk, asml.silence@gmail.com, io-uring@vger.kernel.org
Subject: [PATCH v5 10/13] io_uring: create common fixed_rsrc_data allocation routines
Date:   Tue, 12 Jan 2021 13:33:10 -0800
Message-Id: <1610487193-21374-11-git-send-email-bijan.mottahedeh@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1610487193-21374-1-git-send-email-bijan.mottahedeh@oracle.com>
References: <1610487193-21374-1-git-send-email-bijan.mottahedeh@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9862 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101120127
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9862 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 clxscore=1015 impostorscore=0 spamscore=0 priorityscore=1501 mlxscore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101120128
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
index d3a6185..96f760e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7365,6 +7365,33 @@ static int io_rsrc_ref_quiesce(struct fixed_rsrc_data *data,
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
@@ -7382,9 +7409,7 @@ static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
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
@@ -7826,11 +7851,9 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
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
@@ -7838,12 +7861,8 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
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
@@ -7902,11 +7921,8 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
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
@@ -8672,32 +8688,23 @@ static struct fixed_rsrc_data *io_buffers_map_alloc(struct io_ring_ctx *ctx,
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

