Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A3DF2D1D22
	for <lists+io-uring@lfdr.de>; Mon,  7 Dec 2020 23:20:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728032AbgLGWQ4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 7 Dec 2020 17:16:56 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:58768 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728067AbgLGWQv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 7 Dec 2020 17:16:51 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B7M9GZW111898;
        Mon, 7 Dec 2020 22:16:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=6qACRyvK0t/ODB9elDn7BwQbZ2y8iyatrpnVd1H2QCM=;
 b=ih2uJGqHYu+xwywD/9Rc422Yzf2PWML7a9Iv6ZhENSUoVW/IYyP78bJ5FBuECBlSvEfE
 dUrhVhlq5TEhn+ldpzpgNjP8dmP6YZPg74K8/y9nSlECu2w4cVvtk7b3KwgIR7XqqGHJ
 ew/165sKIUB6znj/VLqv8gm/G1V6ttCTTkMs6C0jFKURdSs8Jnf24ICq99wvN5sAuMpR
 6AWAP8+rSof6D9fGzLqU7BOt/p2NiF+rXK1FOBZZ6ditqnuLQsm/VX/2LMBjynuQeGbA
 BE+NAzJHwd0Bo6f1yHG7ceqgf9HSBOGQBIzRvpBQCIkbEnM8xv3XXRh3v0ldOktJ+AJ8 eA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 357yqbr179-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 07 Dec 2020 22:16:07 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B7MAbXn049084;
        Mon, 7 Dec 2020 22:16:06 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 358kyrxk0x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Dec 2020 22:16:06 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B7MG5NG004829;
        Mon, 7 Dec 2020 22:16:05 GMT
Received: from ca-ldom147.us.oracle.com (/10.129.68.131)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 07 Dec 2020 14:16:05 -0800
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk, asml.silence@gmail.com, io-uring@vger.kernel.org
Subject: [PATCH v2 06/13] io_uring: generalize fixed_file_ref_node functionality
Date:   Mon,  7 Dec 2020 14:15:45 -0800
Message-Id: <1607379352-68109-7-git-send-email-bijan.mottahedeh@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1607379352-68109-1-git-send-email-bijan.mottahedeh@oracle.com>
References: <1607379352-68109-1-git-send-email-bijan.mottahedeh@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9828 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 mlxscore=0
 malwarescore=0 suspectscore=0 mlxlogscore=999 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012070145
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9828 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 clxscore=1015 malwarescore=0 bulkscore=0 phishscore=0 adultscore=0
 spamscore=0 priorityscore=1501 mlxscore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012070145
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Split alloc_fixed_file_ref_node into resource generic/specific parts,
rename destroy_fixed_file_ref_node, and factor out fixed_file_ref_node
switching, to be be leveraged by fixed buffers.

Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
---
 fs/io_uring.c | 34 +++++++++++++++++++++++++---------
 1 file changed, 25 insertions(+), 9 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 1ed63bc..126237e 100644
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
@@ -7688,13 +7688,22 @@ static struct fixed_rsrc_ref_node *alloc_fixed_file_ref_node(
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
 	ref_node->rsrc_data = ctx->file_data;
 	ref_node->rsrc_put = io_ring_file_put;
-	ref_node->done = false;
 	return ref_node;
 }
 
-static void destroy_fixed_file_ref_node(struct fixed_rsrc_ref_node *ref_node)
+static void destroy_fixed_rsrc_ref_node(struct fixed_rsrc_ref_node *ref_node)
 {
 	percpu_ref_exit(&ref_node->refs);
 	kfree(ref_node);
@@ -7870,6 +7879,17 @@ static inline int io_queue_file_removal(struct fixed_rsrc_data *data,
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
 				 struct io_uring_files_update *up,
 				 unsigned nr_args)
@@ -7946,14 +7966,10 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
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
-		destroy_fixed_file_ref_node(ref_node);
+		destroy_fixed_rsrc_ref_node(ref_node);
 
 	return done ? done : err;
 }
-- 
1.8.3.1

