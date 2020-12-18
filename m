Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99D2D2DE8C6
	for <lists+io-uring@lfdr.de>; Fri, 18 Dec 2020 19:08:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726321AbgLRSIY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Dec 2020 13:08:24 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:57210 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726873AbgLRSIX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Dec 2020 13:08:23 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BII3pTC149809;
        Fri, 18 Dec 2020 18:07:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=VdzHkOS8Pk0sekAxuj3st3L++6lP+99VxMMgD47uIOo=;
 b=oNfkS7fQzYIiTvLq59DoJB5fPNx8QdMM2qQhx9qi8GHiT66JzsLf+yTodEk3BEcV1Ry6
 d3sgYnrW42Y7mFtZRPsUUUjfyG0VgoCtjplMvZ//c9w3yu1CzFlE3i3kF6pmim6Mel6b
 XSh59cppXFt7wB/N+zk+CIYoTkjvR50xy47YfYuHGOG/wq4iHbY024r8olZ8q+AIYCLu
 iLjwdxTrqW2+yMDCCLTJnXjlokvBBtd+aFuyUzIn0FhGQr7wtw4uH3sbnHNd2r+DG+q2
 vExf827VPSNuDe16EpSS89t//zUU8ilmNmWRpXu9AfD2TKRw+6n5GwRSqKE1cMao///c Fw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 35cntmkfkg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 18 Dec 2020 18:07:40 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BII5Ov2117380;
        Fri, 18 Dec 2020 18:07:40 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 35g3rgfaxk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Dec 2020 18:07:39 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0BII7dW2003610;
        Fri, 18 Dec 2020 18:07:39 GMT
Received: from ca-ldom147.us.oracle.com (/10.129.68.131)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 18 Dec 2020 10:07:39 -0800
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk, asml.silence@gmail.com, io-uring@vger.kernel.org
Subject: [PATCH v3 06/13] io_uring: generalize fixed_file_ref_node functionality
Date:   Fri, 18 Dec 2020 10:07:21 -0800
Message-Id: <1608314848-67329-7-git-send-email-bijan.mottahedeh@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1608314848-67329-1-git-send-email-bijan.mottahedeh@oracle.com>
References: <1608314848-67329-1-git-send-email-bijan.mottahedeh@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9839 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 spamscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012180124
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9839 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 impostorscore=0 priorityscore=1501 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012180124
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Split alloc_fixed_file_ref_node into resource generic/specific parts,
rename destroy_fixed_file_ref_node, and factor out fixed_file_ref_node
switching, to be be leveraged by fixed buffers.

Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
---
 fs/io_uring.c | 33 ++++++++++++++++++++++++++-------
 1 file changed, 26 insertions(+), 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 28e178b..e23f67f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7672,7 +7672,7 @@ static void io_rsrc_data_ref_zero(struct percpu_ref *ref)
 		queue_delayed_work(system_wq, &ctx->rsrc_put_work, delay);
 }
 
-static struct fixed_rsrc_ref_node *alloc_fixed_file_ref_node(
+static struct fixed_rsrc_ref_node *alloc_fixed_rsrc_ref_node(
 			struct io_ring_ctx *ctx)
 {
 	struct fixed_rsrc_ref_node *ref_node;
@@ -7688,9 +7688,21 @@ static struct fixed_rsrc_ref_node *alloc_fixed_file_ref_node(
 	}
 	INIT_LIST_HEAD(&ref_node->node);
 	INIT_LIST_HEAD(&ref_node->rsrc_list);
+	ref_node->done = false;
+	return ref_node;
+}
+
+static struct fixed_rsrc_ref_node *alloc_fixed_file_ref_node(
+			struct io_ring_ctx *ctx)
+{
+	struct fixed_rsrc_ref_node *ref_node;
+
+	ref_node = alloc_fixed_rsrc_ref_node(ctx);
+	if (!ref_node)
+		return NULL;
+
 	ref_node->rsrc_data = ctx->file_data;
 	ref_node->rsrc_put = io_ring_file_put;
-	ref_node->done = false;
 	return ref_node;
 }
 
@@ -7870,6 +7882,17 @@ static inline int io_queue_file_removal(struct fixed_rsrc_data *data,
 	return io_queue_rsrc_removal(data, (void *)file);
 }
 
+static void switch_fixed_rsrc_ref_node(struct fixed_rsrc_ref_node *ref_node,
+				       struct fixed_rsrc_data *data,
+				       struct io_ring_ctx *ctx)
+{
+	percpu_ref_kill(&data->node->refs);
+	spin_lock_bh(&ctx->rsrc_ref_lock);
+	list_add_tail(&ref_node->node, &ctx->rsrc_ref_list);
+	data->node = ref_node;
+	spin_unlock_bh(&ctx->rsrc_ref_lock);
+}
+
 static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 				 struct io_uring_rsrc_update *up,
 				 unsigned nr_args)
@@ -7946,11 +7969,7 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 	}
 
 	if (needs_switch) {
-		percpu_ref_kill(&data->node->refs);
-		spin_lock_bh(&ctx->rsrc_ref_lock);
-		list_add_tail(&ref_node->node, &ctx->rsrc_ref_list);
-		data->node = ref_node;
-		spin_unlock_bh(&ctx->rsrc_ref_lock);
+		switch_fixed_rsrc_ref_node(ref_node, data, ctx);
 		percpu_ref_get(&ctx->file_data->refs);
 	} else
 		destroy_fixed_rsrc_ref_node(ref_node);
-- 
1.8.3.1

