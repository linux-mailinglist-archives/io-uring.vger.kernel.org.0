Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 487462DE8D5
	for <lists+io-uring@lfdr.de>; Fri, 18 Dec 2020 19:12:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728111AbgLRSK0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Dec 2020 13:10:26 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:59612 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728103AbgLRSK0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Dec 2020 13:10:26 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BII3uYu157982;
        Fri, 18 Dec 2020 18:09:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=AKN5/KPXeKSTcz7ZuG0yBbJII/ZmOvcnm1kmH9R83Cg=;
 b=ieRMytNrw+rmmquaPAuHsvJc2idlGKbR6ERlo3U0kAqKV3J98xcPEIlA1csrnZx+Ngbs
 nyQuPuztaFsS3UXn+aDjcIh2siCiCfO3LVUsCw/farrCCmpTaEhq8VGXH5MR0rDT1Srm
 uqw8+9FJQvFZnH8EEV97PMQIspQFMQauLNHwJlbIAiWk+x79KLn0ia46jiPTg8RzFowo
 u4NHMbvpg/GwQNdkDJGMYzAiYxGIy9Tea5ZMs1t9agYT7Caw7dj5EymrGqP/ZnBRBooU
 Rjatk56S1LVocG52giTxp3Vb0iZSm/e7VZw7tX8T4YF9ghP9444JODRn0/lvye1JOHcs nA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 35cntmkfv1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 18 Dec 2020 18:09:42 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BII6LrX048056;
        Fri, 18 Dec 2020 18:07:41 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 35d7t26pum-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Dec 2020 18:07:41 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0BII7fWg003625;
        Fri, 18 Dec 2020 18:07:41 GMT
Received: from ca-ldom147.us.oracle.com (/10.129.68.131)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 18 Dec 2020 10:07:40 -0800
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk, asml.silence@gmail.com, io-uring@vger.kernel.org
Subject: [PATCH v3 12/13] io_uring: create common fixed_rsrc_data allocation routines.
Date:   Fri, 18 Dec 2020 10:07:27 -0800
Message-Id: <1608314848-67329-13-git-send-email-bijan.mottahedeh@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1608314848-67329-1-git-send-email-bijan.mottahedeh@oracle.com>
References: <1608314848-67329-1-git-send-email-bijan.mottahedeh@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9839 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0
 mlxlogscore=999 spamscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012180124
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9839 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 impostorscore=0 priorityscore=1501 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012180124
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Create common alloc/free fixed_rsrc_data routines for both files and
buffers.

Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
---
 fs/io_uring.c | 77 ++++++++++++++++++++++++++++++++---------------------------
 1 file changed, 42 insertions(+), 35 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 87c1420..f5706e1 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7331,6 +7331,33 @@ static void io_rsrc_ref_quiesce(struct fixed_rsrc_data *data,
 	wait_for_completion(&data->done);
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
@@ -7345,9 +7372,7 @@ static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
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
@@ -7800,11 +7825,9 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
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
@@ -7812,12 +7835,8 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
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
@@ -7876,11 +7895,8 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
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
@@ -8639,39 +8655,30 @@ static int io_alloc_buf_tables(struct fixed_rsrc_data *buf_data,
 static struct fixed_rsrc_data *io_buffers_map_alloc(struct io_ring_ctx *ctx,
 						    unsigned int nr_args)
 {
-	unsigned nr_tables;
 	struct fixed_rsrc_data *buf_data;
+	unsigned int nr_tables;
 	int ret = -ENOMEM;
 
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

