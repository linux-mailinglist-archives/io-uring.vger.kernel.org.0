Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F7562D1D25
	for <lists+io-uring@lfdr.de>; Mon,  7 Dec 2020 23:20:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727733AbgLGWQ4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 7 Dec 2020 17:16:56 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:58760 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728065AbgLGWQu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 7 Dec 2020 17:16:50 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B7M9ZQK112062;
        Mon, 7 Dec 2020 22:16:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=384HZQEiHraOxDbpMrltB34yw2yBjqTDIHP2OpKY04Y=;
 b=mX02tkiHmFNC9g5sO1DO4O9gmrIMmBCpca/Ghkstcq8Du5LUBTWufc2HOwGLJKwcptVV
 Dkds9Q5taHVLxztlnzOD6bmtmFgVkTfy5kxmyvGE6vFqCVj6tb4lGYLL93ak6z6qoOE+
 NivvXlRcfQRn286nC/gyJr/zSX6X9r8Mkt0PuXujOfpnMzZkxJ+AKCdhW/2ymCI1A5lh
 b/vcjqQ5aZmGOXSPiu/QAC2mAvwfh4/bJjTjtrrRY/T9aJ2r00DZih9q5b2Fm9pqfY0Q
 KdkK+Rae3k8WPE9AjlLZL0MvGg+cCnnZcfKaixqagbIS/R3KWkIS1S8emfs5nfZBljgX hA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 357yqbr17a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 07 Dec 2020 22:16:07 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B7M9f8M044379;
        Mon, 7 Dec 2020 22:16:06 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 358m4ww8xy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Dec 2020 22:16:06 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B7MG5qI017223;
        Mon, 7 Dec 2020 22:16:05 GMT
Received: from ca-ldom147.us.oracle.com (/10.129.68.131)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 07 Dec 2020 14:16:05 -0800
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk, asml.silence@gmail.com, io-uring@vger.kernel.org
Subject: [PATCH v2 07/13] io_uring: add rsrc_ref locking routines
Date:   Mon,  7 Dec 2020 14:15:46 -0800
Message-Id: <1607379352-68109-8-git-send-email-bijan.mottahedeh@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1607379352-68109-1-git-send-email-bijan.mottahedeh@oracle.com>
References: <1607379352-68109-1-git-send-email-bijan.mottahedeh@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9828 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 suspectscore=0
 bulkscore=0 malwarescore=0 phishscore=0 adultscore=0 mlxlogscore=963
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012070145
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9828 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=973
 clxscore=1015 malwarescore=0 bulkscore=0 phishscore=0 adultscore=0
 spamscore=0 priorityscore=1501 mlxscore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012070145
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Encapsulate resource reference locking into separate routines.

Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
---
 fs/io_uring.c | 26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 126237e..25b575e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7260,6 +7260,16 @@ static void io_rsrc_ref_kill(struct percpu_ref *ref)
 	complete(&data->done);
 }
 
+static inline void io_rsrc_ref_lock(struct io_ring_ctx *ctx)
+{
+	spin_lock_bh(&ctx->rsrc_ref_lock);
+}
+
+static inline void io_rsrc_ref_unlock(struct io_ring_ctx *ctx)
+{
+	spin_unlock_bh(&ctx->rsrc_ref_lock);
+}
+
 static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
 {
 	struct fixed_rsrc_data *data = ctx->file_data;
@@ -7269,9 +7279,9 @@ static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
 	if (!data)
 		return -ENXIO;
 
-	spin_lock_bh(&ctx->rsrc_ref_lock);
+	io_rsrc_ref_lock(ctx);
 	ref_node = data->node;
-	spin_unlock_bh(&ctx->rsrc_ref_lock);
+	io_rsrc_ref_unlock(ctx);
 	if (ref_node)
 		percpu_ref_kill(&ref_node->refs);
 
@@ -7649,7 +7659,7 @@ static void io_rsrc_data_ref_zero(struct percpu_ref *ref)
 	data = ref_node->rsrc_data;
 	ctx = data->ctx;
 
-	spin_lock_bh(&ctx->rsrc_ref_lock);
+	io_rsrc_ref_lock(ctx);
 	ref_node->done = true;
 
 	while (!list_empty(&ctx->rsrc_ref_list)) {
@@ -7661,7 +7671,7 @@ static void io_rsrc_data_ref_zero(struct percpu_ref *ref)
 		list_del(&ref_node->node);
 		first_add |= llist_add(&ref_node->llist, &ctx->rsrc_put_llist);
 	}
-	spin_unlock_bh(&ctx->rsrc_ref_lock);
+	io_rsrc_ref_unlock(ctx);
 
 	if (percpu_ref_is_dying(&data->refs))
 		delay = 0;
@@ -7792,9 +7802,9 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 	}
 
 	file_data->node = ref_node;
-	spin_lock_bh(&ctx->rsrc_ref_lock);
+	io_rsrc_ref_lock(ctx);
 	list_add_tail(&ref_node->node, &ctx->rsrc_ref_list);
-	spin_unlock_bh(&ctx->rsrc_ref_lock);
+	io_rsrc_ref_unlock(ctx);
 	percpu_ref_get(&file_data->refs);
 	return ret;
 out_fput:
@@ -7884,10 +7894,10 @@ static void switch_fixed_rsrc_ref_node(struct fixed_rsrc_ref_node *ref_node,
 				       struct io_ring_ctx *ctx)
 {
 	percpu_ref_kill(&data->node->refs);
-	spin_lock_bh(&ctx->rsrc_ref_lock);
+	io_rsrc_ref_lock(ctx);
 	list_add_tail(&ref_node->node, &ctx->rsrc_ref_list);
 	data->node = ref_node;
-	spin_unlock_bh(&ctx->rsrc_ref_lock);
+	io_rsrc_ref_unlock(ctx);
 }
 
 static int __io_sqe_files_update(struct io_ring_ctx *ctx,
-- 
1.8.3.1

