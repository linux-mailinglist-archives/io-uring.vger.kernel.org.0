Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F23B2EC531
	for <lists+io-uring@lfdr.de>; Wed,  6 Jan 2021 21:40:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727175AbhAFUkT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 6 Jan 2021 15:40:19 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:54972 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727276AbhAFUkR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 6 Jan 2021 15:40:17 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 106KYuqN052582;
        Wed, 6 Jan 2021 20:39:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=Vo9ZTBrEXvgK1RAiNvtl/c7L2Cioo+3XsztWUIZMd0Q=;
 b=Ek4exe9HXWGj22vqnFyv5ilGVJdOzCRnWHcO6DSMZ5KTyOn+Aa7bw5PIxGz3CsXo29A/
 G7g8qtfnhdMqVskZ3WJbEJd3lUHIfBSAsuJqn4T0OKzxEGAkXkvH79x1SeRnXDvLLHWd
 q/3TG7OeooSoKB9aqTHf6Ll8j2E58SYqAeOEVNxAdZfLZqp/okb0tEMiGWtSy5/9OPUL
 qatpkcydLmLP0DhHzgXTT04O4DVT7OK1KzLe9ZSwUhg+l+8HHGBfF87P37GVoMrtgdFN
 g71mkE1FhNcaAJ4Wv/RZxwLFqR8nZ1Y0ufZLeUa3TmES3oznuT6V9uIu4IlT5AkRkblr hA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 35wepm9s2u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 06 Jan 2021 20:39:35 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 106KaQhq034397;
        Wed, 6 Jan 2021 20:39:34 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 35w3qshcw4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Jan 2021 20:39:34 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 106KdX8B029318;
        Wed, 6 Jan 2021 20:39:33 GMT
Received: from ca-ldom147.us.oracle.com (/10.129.68.131)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 Jan 2021 20:39:33 +0000
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk, asml.silence@gmail.com, io-uring@vger.kernel.org
Subject: [PATCH v4 09/13] io_uring: create common fixed_rsrc_ref_node handling routines
Date:   Wed,  6 Jan 2021 12:39:18 -0800
Message-Id: <1609965562-13569-10-git-send-email-bijan.mottahedeh@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1609965562-13569-1-git-send-email-bijan.mottahedeh@oracle.com>
References: <1609965562-13569-1-git-send-email-bijan.mottahedeh@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9856 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 spamscore=0 mlxlogscore=999 phishscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101060117
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9856 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 spamscore=0
 impostorscore=0 phishscore=0 lowpriorityscore=0 suspectscore=0
 priorityscore=1501 mlxscore=0 malwarescore=0 clxscore=1015 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101060117
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Create common routines to be used for both files/buffers registration.

Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
---
 fs/io_uring.c | 47 ++++++++++++++++++++++++-----------------------
 1 file changed, 24 insertions(+), 23 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 91be618..fbff8480 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7303,15 +7303,12 @@ static void io_sqe_rsrc_set_node(struct io_ring_ctx *ctx,
 	percpu_ref_get(&rsrc_data->refs);
 }
 
-static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
+static int io_rsrc_ref_quiesce(struct fixed_rsrc_data *data,
+			       struct io_ring_ctx *ctx)
 {
-	struct fixed_rsrc_data *data = ctx->file_data;
 	struct fixed_rsrc_ref_node *backup_node, *ref_node = NULL;
-	unsigned nr_tables, i;
 	int ret;
 
-	if (!data)
-		return -ENXIO;
 	backup_node = alloc_fixed_file_ref_node(ctx);
 	if (!backup_node)
 		return -ENOMEM;
@@ -7339,6 +7336,23 @@ static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
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
+	ret = io_rsrc_ref_quiesce(data, ctx);
+	if (ret)
+		return ret;
+
 	__io_sqe_files_unregister(ctx);
 	nr_tables = DIV_ROUND_UP(ctx->nr_user_files, IORING_MAX_FILES_TABLE);
 	for (i = 0; i < nr_tables; i++)
@@ -7348,7 +7362,6 @@ static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
 	kfree(data);
 	ctx->file_data = NULL;
 	ctx->nr_user_files = 0;
-	destroy_fixed_rsrc_ref_node(backup_node);
 	return 0;
 }
 
@@ -8384,22 +8397,14 @@ static void io_buffers_map_free(struct io_ring_ctx *ctx)
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
+	ret = io_rsrc_ref_quiesce(data, ctx);
+	if (ret)
+		return ret;
 
 	io_buffers_unmap(ctx);
 	io_buffers_map_free(ctx);
@@ -8751,11 +8756,7 @@ static int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
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

