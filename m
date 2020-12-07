Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BE8B2D1D2A
	for <lists+io-uring@lfdr.de>; Mon,  7 Dec 2020 23:20:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727468AbgLGWSv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 7 Dec 2020 17:18:51 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:44520 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726231AbgLGWSu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 7 Dec 2020 17:18:50 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B7M9O3h072116;
        Mon, 7 Dec 2020 22:18:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=dH9W4JY2SqCWXoGqDLYcHW8jIYk1bwaaZzIZi+5Z+/A=;
 b=HL022oU9YvxC/DNMmFDGQiTphceKGdl3/28drYkUCjivs4ovWyRAK6VCHYDL07qnKVGO
 brqOJgSWnmKWyL9X9suRx1tU4m0YkKZ1p+C5sIqLGxB8qoBbov+WXb0tRgejAL8WNClT
 R2vwLDYVARhIZqAE+TlKoUv/0UW8lVvg3lLJIely37/mrqWgIdkFtbRS0Lm5F2nabhmc
 8ggsZSL/4CBEHApvHZSA9FYVOmrHexMbVIgKjoPcgJjkbtBqWXvHVShzxKLTs47B4bCN
 3vUeUtfZb1iQ2E0N7LN6bnQdxZl/JjDH6EIuXsDbySVo7pzOjr5vToX4CT6F/HxTcphy JQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 35825kyw7d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 07 Dec 2020 22:18:08 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B7MAj30082837;
        Mon, 7 Dec 2020 22:16:08 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 358ksmsam3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Dec 2020 22:16:08 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B7MG7D0006746;
        Mon, 7 Dec 2020 22:16:07 GMT
Received: from ca-ldom147.us.oracle.com (/10.129.68.131)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 07 Dec 2020 14:16:07 -0800
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk, asml.silence@gmail.com, io-uring@vger.kernel.org
Subject: [PATCH v2 12/13] io_uring: create common fixed_rsrc_data allocation routines.
Date:   Mon,  7 Dec 2020 14:15:51 -0800
Message-Id: <1607379352-68109-13-git-send-email-bijan.mottahedeh@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1607379352-68109-1-git-send-email-bijan.mottahedeh@oracle.com>
References: <1607379352-68109-1-git-send-email-bijan.mottahedeh@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9828 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=2
 bulkscore=0 malwarescore=0 phishscore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012070145
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9828 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 adultscore=0 bulkscore=0
 phishscore=0 mlxlogscore=999 clxscore=1015 priorityscore=1501 mlxscore=0
 spamscore=0 lowpriorityscore=0 malwarescore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012070145
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Create common alloc/free fixed_rsrc_data routines for both files and
buffers.

Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
---
 fs/io_uring.c | 79 ++++++++++++++++++++++++++++++++---------------------------
 1 file changed, 43 insertions(+), 36 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index b7a1f65..479a6b9 100644
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
@@ -7797,11 +7822,9 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
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
@@ -7809,12 +7832,8 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
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
@@ -7873,11 +7892,8 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
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
@@ -8635,41 +8651,32 @@ static int io_alloc_buf_tables(struct fixed_rsrc_data *buf_data,
 static struct fixed_rsrc_data *io_buffers_map_alloc(struct io_ring_ctx *ctx,
 						    unsigned int nr_args)
 {
-	unsigned nr_tables;
 	struct fixed_rsrc_data *buf_data;
+	unsigned nr_tables;
 	int ret = -ENOMEM;
 
-	if (ctx->buf_data)
+	if (ctx->nr_user_bufs)
 		return ERR_PTR(-EBUSY);
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

