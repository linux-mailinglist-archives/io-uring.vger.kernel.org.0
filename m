Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACE642EC532
	for <lists+io-uring@lfdr.de>; Wed,  6 Jan 2021 21:40:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727305AbhAFUkQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 6 Jan 2021 15:40:16 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:55910 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727078AbhAFUkQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 6 Jan 2021 15:40:16 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 106KYmnc037719;
        Wed, 6 Jan 2021 20:39:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=g8s+5KuknS9B6reaW0EFILtEgjJGvhHQZvYw+W1LulU=;
 b=WrvTaMwhlwIsNE9tNSNHP3v8tls5n8SbvNgnMbKZLtvc/VqeRm8Yp1oHImYYFM73WQ2D
 8ZBxQh7Gwht5GWTLE9Z3MzVkQ+FB+oYpUWcDK/agEwPeucfFAfMmpZHrvk2hkK68ZJSG
 0i8gNG3W6lNuC/W14CdXzOpyRKEpVRIyk7id2N8tO6xbpy8S5II7qX3L/knHFZDuped6
 r6DLuUr+v09ls/DfVaheWd4LiU8ap4p4e2KvFqhJUs7kjPKGD9F2Y8ntFSRjbj9VjffF
 xGfzNqwWT/iFr2yWo5Bxc5coIh1pJjKk8Ayf2aZH4XI1USN6XAROBB5OB4420w5OBZeb /Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 35wcuxt58s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 06 Jan 2021 20:39:33 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 106KZakw145403;
        Wed, 6 Jan 2021 20:39:33 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 35w3g1jf1m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Jan 2021 20:39:32 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 106KdWUE021584;
        Wed, 6 Jan 2021 20:39:32 GMT
Received: from ca-ldom147.us.oracle.com (/10.129.68.131)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 Jan 2021 20:39:32 +0000
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk, asml.silence@gmail.com, io-uring@vger.kernel.org
Subject: [PATCH v4 05/13] io_uring: separate ref_list from fixed_rsrc_data
Date:   Wed,  6 Jan 2021 12:39:14 -0800
Message-Id: <1609965562-13569-6-git-send-email-bijan.mottahedeh@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1609965562-13569-1-git-send-email-bijan.mottahedeh@oracle.com>
References: <1609965562-13569-1-git-send-email-bijan.mottahedeh@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9856 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 adultscore=0
 phishscore=0 spamscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101060117
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9856 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 clxscore=1015 spamscore=0 impostorscore=0 priorityscore=1501 mlxscore=0
 adultscore=0 mlxlogscore=999 lowpriorityscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101060117
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Uplevel ref_list and make it common to all resources.  This is to
allow one common ref_list to be used for both files, and buffers
in upcoming patches.

Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
---
 fs/io_uring.c | 35 ++++++++++++++++++-----------------
 1 file changed, 18 insertions(+), 17 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 88baa13..98e34eb 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -231,8 +231,6 @@ struct fixed_rsrc_data {
 	struct fixed_rsrc_ref_node	*node;
 	struct percpu_ref		refs;
 	struct completion		done;
-	struct list_head		ref_list;
-	spinlock_t			lock;
 };
 
 struct io_buffer {
@@ -400,6 +398,8 @@ struct io_ring_ctx {
 
 	struct delayed_work		rsrc_put_work;
 	struct llist_head		rsrc_put_llist;
+	struct list_head		rsrc_ref_list;
+	spinlock_t			rsrc_ref_lock;
 
 	struct work_struct		exit_work;
 	struct io_restriction		restrictions;
@@ -1332,6 +1332,8 @@ static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	INIT_LIST_HEAD(&ctx->timeout_list);
 	spin_lock_init(&ctx->inflight_lock);
 	INIT_LIST_HEAD(&ctx->inflight_list);
+	spin_lock_init(&ctx->rsrc_ref_lock);
+	INIT_LIST_HEAD(&ctx->rsrc_ref_list);
 	INIT_DELAYED_WORK(&ctx->rsrc_put_work, io_rsrc_put_work);
 	init_llist_head(&ctx->rsrc_put_llist);
 	return ctx;
@@ -7263,13 +7265,14 @@ static void io_rsrc_ref_kill(struct percpu_ref *ref)
 	complete(&data->done);
 }
 
-static void io_sqe_rsrc_set_node(struct fixed_rsrc_data *rsrc_data,
+static void io_sqe_rsrc_set_node(struct io_ring_ctx *ctx,
+				 struct fixed_rsrc_data *rsrc_data,
 				 struct fixed_rsrc_ref_node *ref_node)
 {
-	spin_lock_bh(&rsrc_data->lock);
+	spin_lock_bh(&ctx->rsrc_ref_lock);
 	rsrc_data->node = ref_node;
-	list_add_tail(&ref_node->node, &rsrc_data->ref_list);
-	spin_unlock_bh(&rsrc_data->lock);
+	list_add_tail(&ref_node->node, &ctx->rsrc_ref_list);
+	spin_unlock_bh(&ctx->rsrc_ref_lock);
 	percpu_ref_get(&rsrc_data->refs);
 }
 
@@ -7286,9 +7289,9 @@ static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
 	if (!backup_node)
 		return -ENOMEM;
 
-	spin_lock_bh(&data->lock);
+	spin_lock_bh(&ctx->rsrc_ref_lock);
 	ref_node = data->node;
-	spin_unlock_bh(&data->lock);
+	spin_unlock_bh(&ctx->rsrc_ref_lock);
 	if (ref_node)
 		percpu_ref_kill(&ref_node->refs);
 
@@ -7304,7 +7307,7 @@ static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
 		if (ret < 0) {
 			percpu_ref_resurrect(&data->refs);
 			reinit_completion(&data->done);
-			io_sqe_rsrc_set_node(data, backup_node);
+			io_sqe_rsrc_set_node(ctx, data, backup_node);
 			return ret;
 		}
 	} while (1);
@@ -7678,11 +7681,11 @@ static void io_rsrc_data_ref_zero(struct percpu_ref *ref)
 	data = ref_node->rsrc_data;
 	ctx = data->ctx;
 
-	spin_lock_bh(&data->lock);
+	spin_lock_bh(&ctx->rsrc_ref_lock);
 	ref_node->done = true;
 
-	while (!list_empty(&data->ref_list)) {
-		ref_node = list_first_entry(&data->ref_list,
+	while (!list_empty(&ctx->rsrc_ref_list)) {
+		ref_node = list_first_entry(&ctx->rsrc_ref_list,
 					struct fixed_rsrc_ref_node, node);
 		/* recycle ref nodes in order */
 		if (!ref_node->done)
@@ -7690,7 +7693,7 @@ static void io_rsrc_data_ref_zero(struct percpu_ref *ref)
 		list_del(&ref_node->node);
 		first_add |= llist_add(&ref_node->llist, &ctx->rsrc_put_llist);
 	}
-	spin_unlock_bh(&data->lock);
+	spin_unlock_bh(&ctx->rsrc_ref_lock);
 
 	if (percpu_ref_is_dying(&data->refs))
 		delay = 0;
@@ -7751,8 +7754,6 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 		return -ENOMEM;
 	file_data->ctx = ctx;
 	init_completion(&file_data->done);
-	INIT_LIST_HEAD(&file_data->ref_list);
-	spin_lock_init(&file_data->lock);
 
 	nr_tables = DIV_ROUND_UP(nr_args, IORING_MAX_FILES_TABLE);
 	file_data->table = kcalloc(nr_tables, sizeof(*file_data->table),
@@ -7813,7 +7814,7 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 		return -ENOMEM;
 	}
 
-	io_sqe_rsrc_set_node(file_data, ref_node);
+	io_sqe_rsrc_set_node(ctx, file_data, ref_node);
 	return ret;
 out_fput:
 	for (i = 0; i < ctx->nr_user_files; i++) {
@@ -7974,7 +7975,7 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 
 	if (needs_switch) {
 		percpu_ref_kill(&data->node->refs);
-		io_sqe_rsrc_set_node(data, ref_node);
+		io_sqe_rsrc_set_node(ctx, data, ref_node);
 	} else
 		destroy_fixed_rsrc_ref_node(ref_node);
 
-- 
1.8.3.1

