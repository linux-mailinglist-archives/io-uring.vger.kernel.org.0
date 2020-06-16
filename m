Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 844221FC25E
	for <lists+io-uring@lfdr.de>; Wed, 17 Jun 2020 01:36:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726569AbgFPXgV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 16 Jun 2020 19:36:21 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:48578 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726271AbgFPXgU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 16 Jun 2020 19:36:20 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05GNWnrI133223;
        Tue, 16 Jun 2020 23:36:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=oAFz4xdYUWxrngAlOHZwAhWrZ0QaH01dlglc3ObDIdE=;
 b=Otv2S0+7df6nG57SJhqzfS/S+JyM3WVKLL1npVKw3UuDRy8e+4w21i3F/wpdLUPD8pbC
 ZMArzsBxMixRFxRBz1HUh1cr4NBspbVBmYQ8OqiKn1JxbUi+Sp+3jXPE/fRyYlXdRxmv
 p3a4EJKVvBKt5FQWDe+EzPSb0yIM2YQLJYX7WCqjY2uVIEdrzfu8R3oCdKUzJQ9IdqLk
 LhbfA6zkFk1/J8eLiqKWcUHCjGxtmtgEeqwZB4hJjIT0gxtydPppyxXfsQYH7RYFNTb9
 xSLL7ibe6hyTxcFAjx1Ixh9I5Pd3CjD+BMGfKRJ6WpOQKi+M5PJdD/+I/5xe8SVJ9GKw 8A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 31q63y8aft-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 16 Jun 2020 23:36:17 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05GNSCa9173480;
        Tue, 16 Jun 2020 23:36:17 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 31q667nr88-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Jun 2020 23:36:17 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05GNaG6h024025;
        Tue, 16 Jun 2020 23:36:16 GMT
Received: from ca-ldom147.us.oracle.com (/10.129.68.131)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 16 Jun 2020 16:36:16 -0700
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk
Cc:     io-uring@vger.kernel.org
Subject: [PATCH 1/4] io_uring: add wrappers for memory accounting
Date:   Tue, 16 Jun 2020 16:36:07 -0700
Message-Id: <1592350570-24396-2-git-send-email-bijan.mottahedeh@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1592350570-24396-1-git-send-email-bijan.mottahedeh@oracle.com>
References: <1592350570-24396-1-git-send-email-bijan.mottahedeh@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9654 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0
 suspectscore=3 bulkscore=0 adultscore=0 mlxlogscore=999 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006160162
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9654 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 impostorscore=0
 mlxlogscore=999 priorityscore=1501 adultscore=0 malwarescore=0 spamscore=0
 clxscore=1015 cotscore=-2147483648 bulkscore=0 suspectscore=3
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006160162
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Facilitate separation of locked memory usage reporting vs. limiting for
upcoming patches.  No functional changes.

Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
---
 fs/io_uring.c | 48 ++++++++++++++++++++++++++++--------------------
 1 file changed, 28 insertions(+), 20 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index a07c44e..ebd3f62 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7028,12 +7028,14 @@ static int io_sq_offload_start(struct io_ring_ctx *ctx,
 	return ret;
 }
 
-static void io_unaccount_mem(struct user_struct *user, unsigned long nr_pages)
+static inline void __io_unaccount_mem(struct user_struct *user,
+				      unsigned long nr_pages)
 {
 	atomic_long_sub(nr_pages, &user->locked_vm);
 }
 
-static int io_account_mem(struct user_struct *user, unsigned long nr_pages)
+static inline int __io_account_mem(struct user_struct *user,
+				   unsigned long nr_pages)
 {
 	unsigned long page_limit, cur_pages, new_pages;
 
@@ -7051,6 +7053,20 @@ static int io_account_mem(struct user_struct *user, unsigned long nr_pages)
 	return 0;
 }
 
+static void io_unaccount_mem(struct io_ring_ctx *ctx, unsigned long nr_pages)
+{
+	if (ctx->account_mem)
+		__io_unaccount_mem(ctx->user, nr_pages);
+}
+
+static int io_account_mem(struct io_ring_ctx *ctx, unsigned long nr_pages)
+{
+	if (ctx->account_mem)
+		return (__io_account_mem(ctx->user, nr_pages));
+
+	return 0;
+}
+
 static void io_mem_free(void *ptr)
 {
 	struct page *page;
@@ -7125,8 +7141,7 @@ static int io_sqe_buffer_unregister(struct io_ring_ctx *ctx)
 		for (j = 0; j < imu->nr_bvecs; j++)
 			unpin_user_page(imu->bvec[j].bv_page);
 
-		if (ctx->account_mem)
-			io_unaccount_mem(ctx->user, imu->nr_bvecs);
+		io_unaccount_mem(ctx, imu->nr_bvecs);
 		kvfree(imu->bvec);
 		imu->nr_bvecs = 0;
 	}
@@ -7209,11 +7224,9 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, void __user *arg,
 		start = ubuf >> PAGE_SHIFT;
 		nr_pages = end - start;
 
-		if (ctx->account_mem) {
-			ret = io_account_mem(ctx->user, nr_pages);
-			if (ret)
-				goto err;
-		}
+		ret = io_account_mem(ctx, nr_pages);
+		if (ret)
+			goto err;
 
 		ret = 0;
 		if (!pages || nr_pages > got_pages) {
@@ -7226,8 +7239,7 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, void __user *arg,
 					GFP_KERNEL);
 			if (!pages || !vmas) {
 				ret = -ENOMEM;
-				if (ctx->account_mem)
-					io_unaccount_mem(ctx->user, nr_pages);
+				io_unaccount_mem(ctx, nr_pages);
 				goto err;
 			}
 			got_pages = nr_pages;
@@ -7237,8 +7249,7 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, void __user *arg,
 						GFP_KERNEL);
 		ret = -ENOMEM;
 		if (!imu->bvec) {
-			if (ctx->account_mem)
-				io_unaccount_mem(ctx->user, nr_pages);
+			io_unaccount_mem(ctx, nr_pages);
 			goto err;
 		}
 
@@ -7269,8 +7280,7 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, void __user *arg,
 			 */
 			if (pret > 0)
 				unpin_user_pages(pages, pret);
-			if (ctx->account_mem)
-				io_unaccount_mem(ctx->user, nr_pages);
+			io_unaccount_mem(ctx, nr_pages);
 			kvfree(imu->bvec);
 			goto err;
 		}
@@ -7375,9 +7385,7 @@ static void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	io_mem_free(ctx->sq_sqes);
 
 	percpu_ref_exit(&ctx->refs);
-	if (ctx->account_mem)
-		io_unaccount_mem(ctx->user,
-				ring_pages(ctx->sq_entries, ctx->cq_entries));
+	io_unaccount_mem(ctx, ring_pages(ctx->sq_entries, ctx->cq_entries));
 	free_uid(ctx->user);
 	put_cred(ctx->creds);
 	kfree(ctx->cancel_hash);
@@ -7916,7 +7924,7 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p,
 	account_mem = !capable(CAP_IPC_LOCK);
 
 	if (account_mem) {
-		ret = io_account_mem(user,
+		ret = __io_account_mem(user,
 				ring_pages(p->sq_entries, p->cq_entries));
 		if (ret) {
 			free_uid(user);
@@ -7927,7 +7935,7 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p,
 	ctx = io_ring_ctx_alloc(p);
 	if (!ctx) {
 		if (account_mem)
-			io_unaccount_mem(user, ring_pages(p->sq_entries,
+			__io_unaccount_mem(user, ring_pages(p->sq_entries,
 								p->cq_entries));
 		free_uid(user);
 		return -ENOMEM;
-- 
1.8.3.1

