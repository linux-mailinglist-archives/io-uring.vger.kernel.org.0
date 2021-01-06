Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25FCE2EC533
	for <lists+io-uring@lfdr.de>; Wed,  6 Jan 2021 21:40:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727276AbhAFUkT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 6 Jan 2021 15:40:19 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:55938 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727150AbhAFUkQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 6 Jan 2021 15:40:16 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 106KYl26037713;
        Wed, 6 Jan 2021 20:39:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=vHgg9HRJbzMCN5DlvFenAM8YeaYijB+g5NOi3eb3g08=;
 b=xx8zalZ50+vRyrHb0JBfOfrArIOWUz7HlbLhh7bcmYAWjPJg8zFgQ2JzCmAAZXKIQe2n
 5E3SYTTEGLNAtPulyoY6hvAqKJuhkQOzdnZaIkSY9IEXfn4s5WfNhFCbvZqleU07njmZ
 S3iyblxdENAJWG2Ky93YkcFb9ZHHoHBTTYYOCWiqUb0xa76YSLLUDNqRNEbis20KNXrG
 hz4julSYeUQk3imRXKCroKftIKQcHOkzpO2lfaTZDwNX7vgFF5BTyEZOyHylXF5vprrO
 NM2P/ycUudn9amuIlk3cuMIZ1zRNgU/fgIDhiFVXEqF0xbjN2ivabYz9DChsAP43hu3+ 3Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 35wcuxt58w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 06 Jan 2021 20:39:34 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 106KZatM145367;
        Wed, 6 Jan 2021 20:39:33 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 35w3g1jf1s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Jan 2021 20:39:33 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 106KdWqI027131;
        Wed, 6 Jan 2021 20:39:32 GMT
Received: from ca-ldom147.us.oracle.com (/10.129.68.131)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 Jan 2021 20:39:32 +0000
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk, asml.silence@gmail.com, io-uring@vger.kernel.org
Subject: [PATCH v4 07/13] io_uring: add rsrc_ref locking routines
Date:   Wed,  6 Jan 2021 12:39:16 -0800
Message-Id: <1609965562-13569-8-git-send-email-bijan.mottahedeh@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1609965562-13569-1-git-send-email-bijan.mottahedeh@oracle.com>
References: <1609965562-13569-1-git-send-email-bijan.mottahedeh@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9856 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 adultscore=0
 phishscore=0 spamscore=0 mlxlogscore=978 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101060117
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9856 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 clxscore=1015 spamscore=0 impostorscore=0 priorityscore=1501 mlxscore=0
 adultscore=0 mlxlogscore=992 lowpriorityscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101060117
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Encapsulate resource reference locking into separate routines.

Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
---
 fs/io_uring.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 1d04e82..61e87c4 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7265,14 +7265,24 @@ static void io_rsrc_ref_kill(struct percpu_ref *ref)
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
 static void io_sqe_rsrc_set_node(struct io_ring_ctx *ctx,
 				 struct fixed_rsrc_data *rsrc_data,
 				 struct fixed_rsrc_ref_node *ref_node)
 {
-	spin_lock_bh(&ctx->rsrc_ref_lock);
+	io_rsrc_ref_lock(ctx);
 	rsrc_data->node = ref_node;
 	list_add_tail(&ref_node->node, &ctx->rsrc_ref_list);
-	spin_unlock_bh(&ctx->rsrc_ref_lock);
+	io_rsrc_ref_unlock(ctx);
 	percpu_ref_get(&rsrc_data->refs);
 }
 
@@ -7289,9 +7299,9 @@ static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
 	if (!backup_node)
 		return -ENOMEM;
 
-	spin_lock_bh(&ctx->rsrc_ref_lock);
+	io_rsrc_ref_lock(ctx);
 	ref_node = data->node;
-	spin_unlock_bh(&ctx->rsrc_ref_lock);
+	io_rsrc_ref_unlock(ctx);
 	if (ref_node)
 		percpu_ref_kill(&ref_node->refs);
 
@@ -7681,7 +7691,7 @@ static void io_rsrc_data_ref_zero(struct percpu_ref *ref)
 	data = ref_node->rsrc_data;
 	ctx = data->ctx;
 
-	spin_lock_bh(&ctx->rsrc_ref_lock);
+	io_rsrc_ref_lock(ctx);
 	ref_node->done = true;
 
 	while (!list_empty(&ctx->rsrc_ref_list)) {
@@ -7693,7 +7703,7 @@ static void io_rsrc_data_ref_zero(struct percpu_ref *ref)
 		list_del(&ref_node->node);
 		first_add |= llist_add(&ref_node->llist, &ctx->rsrc_put_llist);
 	}
-	spin_unlock_bh(&ctx->rsrc_ref_lock);
+	io_rsrc_ref_unlock(ctx);
 
 	if (percpu_ref_is_dying(&data->refs))
 		delay = 0;
-- 
1.8.3.1

