Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66F6F2DE8CA
	for <lists+io-uring@lfdr.de>; Fri, 18 Dec 2020 19:08:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727535AbgLRSIZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Dec 2020 13:08:25 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:57250 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727326AbgLRSIZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Dec 2020 13:08:25 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BII4W10161954;
        Fri, 18 Dec 2020 18:07:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=9d/y+P5TqFElX9QPuhyiMUaH2umYQwLptkoniE10uUA=;
 b=DqAkmFKEtg0oG3RSc0U6xQp/HMCNM86H+HvAu7q3z1pALcJNkRLDi7O90Wyu524j6JdV
 K+HC2PNEEijl94LvkaIJ4jJ1vQYz0kTI1ieU2xvltgZJw8sgDgNrJs1GUZeQ+wuJ22vR
 /8kFkNzCW3IasscYwbuOYOyr43jFvLChPFBxLmwiGEjSKc3ETWnrT0kG/6mbsZ3Vsayl
 WXwIcbkwCz8CR7ODFE8HS4SuHyo0hjqcCp8I3GGt7GrT4Z+xoy11k3sQWk7exGT05M1N
 Jtnka65sdjOM3HwMOh/LJItbV9241Fdpq4CP1r2lAV/PKD8qMdclKGh8iQaZ0Hzl8cMC +w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 35cntmkfkj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 18 Dec 2020 18:07:41 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BII5MYq117038;
        Fri, 18 Dec 2020 18:07:40 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 35g3rgfaxm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Dec 2020 18:07:40 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0BII7dwe015973;
        Fri, 18 Dec 2020 18:07:39 GMT
Received: from ca-ldom147.us.oracle.com (/10.129.68.131)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 18 Dec 2020 10:07:39 -0800
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk, asml.silence@gmail.com, io-uring@vger.kernel.org
Subject: [PATCH v3 07/13] io_uring: add rsrc_ref locking routines
Date:   Fri, 18 Dec 2020 10:07:22 -0800
Message-Id: <1608314848-67329-8-git-send-email-bijan.mottahedeh@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1608314848-67329-1-git-send-email-bijan.mottahedeh@oracle.com>
References: <1608314848-67329-1-git-send-email-bijan.mottahedeh@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9839 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 spamscore=0 suspectscore=0 mlxscore=0 mlxlogscore=988 adultscore=0
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

Encapsulate resource reference locking into separate routines.

Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
---
 fs/io_uring.c | 26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e23f67f..bad2477 100644
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
@@ -7795,9 +7805,9 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
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
@@ -7887,10 +7897,10 @@ static void switch_fixed_rsrc_ref_node(struct fixed_rsrc_ref_node *ref_node,
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

