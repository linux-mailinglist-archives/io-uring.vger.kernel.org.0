Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A8831FC260
	for <lists+io-uring@lfdr.de>; Wed, 17 Jun 2020 01:36:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726515AbgFPXgW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 16 Jun 2020 19:36:22 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:40122 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726564AbgFPXgV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 16 Jun 2020 19:36:21 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05GNWpv1041216;
        Tue, 16 Jun 2020 23:36:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=BZ7FdyaC/nvcquSOpvmQXhKlw9prkdlARQkn/kxW1Lk=;
 b=mVVciFmjCa2ZEJ3nUXYeSFZZXo1LEVI7qKMO3qHu4BkGV6kC3PxAYK8WZyIgSWydRWBZ
 KG5FAblO0KTRyw+7vjNr23rPyK6yWQyCL3j+ZXS1V6iHxXfPZAy7aAwUhE5P4XN61Et+
 hf7izh+4OmLH/wfTx2I+pQVLVq3hqCoyCjcExXbO4d8bzX7zZsE+WoL+CH36XgpCwtnv
 TasnTn1xhqDV+Bs+NZ50h/EEwf73oR6oxola/BsN0vQN39CmeONU0xdEhRS1NKci+Jzz
 /yZVh3qV5TfmEZKr3FczhxXdd21d+/QSylh0v13chGS6GepcwpCUKTvS96qK41ar2GfW 9g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 31q65yr9yv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 16 Jun 2020 23:36:19 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05GNT3mE193525;
        Tue, 16 Jun 2020 23:36:18 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 31q66m8649-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Jun 2020 23:36:18 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 05GNaHt7022427;
        Tue, 16 Jun 2020 23:36:17 GMT
Received: from ca-ldom147.us.oracle.com (/10.129.68.131)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 16 Jun 2020 16:36:17 -0700
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk
Cc:     io-uring@vger.kernel.org
Subject: [PATCH 4/4] io_uring: separate reporting of ring pages from registered pages
Date:   Tue, 16 Jun 2020 16:36:10 -0700
Message-Id: <1592350570-24396-5-git-send-email-bijan.mottahedeh@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1592350570-24396-1-git-send-email-bijan.mottahedeh@oracle.com>
References: <1592350570-24396-1-git-send-email-bijan.mottahedeh@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9654 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 bulkscore=0 adultscore=0 phishscore=0 suspectscore=3 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006160162
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9654 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 malwarescore=0
 bulkscore=0 phishscore=0 adultscore=0 priorityscore=1501 mlxscore=0
 spamscore=0 clxscore=1015 mlxlogscore=999 suspectscore=3 impostorscore=0
 cotscore=-2147483648 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006160162
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Ring pages are not pinned so it is more appropriate to report them
as locked.

Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
---
 fs/io_uring.c | 43 ++++++++++++++++++++++++++++++-------------
 1 file changed, 30 insertions(+), 13 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 851ff21..c308dad 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -876,6 +876,11 @@ struct io_op_def {
 	},
 };
 
+enum io_mem_account {
+	ACCT_LOCKED,
+	ACCT_PINNED,
+};
+
 static void io_wq_submit_work(struct io_wq_work **workptr);
 static void io_cqring_fill_event(struct io_kiocb *req, long res);
 static void io_put_req(struct io_kiocb *req);
@@ -7053,16 +7058,22 @@ static inline int __io_account_mem(struct user_struct *user,
 	return 0;
 }
 
-static void io_unaccount_mem(struct io_ring_ctx *ctx, unsigned long nr_pages)
+static void io_unaccount_mem(struct io_ring_ctx *ctx, unsigned long nr_pages,
+			     enum io_mem_account acct)
 {
 	if (ctx->limit_mem)
 		__io_unaccount_mem(ctx->user, nr_pages);
 
-	if (ctx->sqo_mm)
-		atomic64_sub(nr_pages, &ctx->sqo_mm->pinned_vm);
+	if (ctx->sqo_mm) {
+		if (acct == ACCT_LOCKED)
+			ctx->sqo_mm->locked_vm -= nr_pages;
+		else if (acct == ACCT_PINNED)
+			atomic64_sub(nr_pages, &ctx->sqo_mm->pinned_vm);
+	}
 }
 
-static int io_account_mem(struct io_ring_ctx *ctx, unsigned long nr_pages)
+static int io_account_mem(struct io_ring_ctx *ctx, unsigned long nr_pages,
+			  enum io_mem_account acct)
 {
 	int ret;
 
@@ -7072,8 +7083,12 @@ static int io_account_mem(struct io_ring_ctx *ctx, unsigned long nr_pages)
 			return ret;
 	}
 
-	if (ctx->sqo_mm)
-		atomic64_add(nr_pages, &ctx->sqo_mm->pinned_vm);
+	if (ctx->sqo_mm) {
+		if (acct == ACCT_LOCKED)
+			ctx->sqo_mm->locked_vm += nr_pages;
+		else if (acct == ACCT_PINNED)
+			atomic64_add(nr_pages, &ctx->sqo_mm->pinned_vm);
+	}
 
 	return 0;
 }
@@ -7152,7 +7167,7 @@ static int io_sqe_buffer_unregister(struct io_ring_ctx *ctx)
 		for (j = 0; j < imu->nr_bvecs; j++)
 			unpin_user_page(imu->bvec[j].bv_page);
 
-		io_unaccount_mem(ctx, imu->nr_bvecs);
+		io_unaccount_mem(ctx, imu->nr_bvecs, ACCT_PINNED);
 		kvfree(imu->bvec);
 		imu->nr_bvecs = 0;
 	}
@@ -7235,7 +7250,7 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, void __user *arg,
 		start = ubuf >> PAGE_SHIFT;
 		nr_pages = end - start;
 
-		ret = io_account_mem(ctx, nr_pages);
+		ret = io_account_mem(ctx, nr_pages, ACCT_PINNED);
 		if (ret)
 			goto err;
 
@@ -7250,7 +7265,7 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, void __user *arg,
 					GFP_KERNEL);
 			if (!pages || !vmas) {
 				ret = -ENOMEM;
-				io_unaccount_mem(ctx, nr_pages);
+				io_unaccount_mem(ctx, nr_pages, ACCT_PINNED);
 				goto err;
 			}
 			got_pages = nr_pages;
@@ -7260,7 +7275,7 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, void __user *arg,
 						GFP_KERNEL);
 		ret = -ENOMEM;
 		if (!imu->bvec) {
-			io_unaccount_mem(ctx, nr_pages);
+			io_unaccount_mem(ctx, nr_pages, ACCT_PINNED);
 			goto err;
 		}
 
@@ -7291,7 +7306,7 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, void __user *arg,
 			 */
 			if (pret > 0)
 				unpin_user_pages(pages, pret);
-			io_unaccount_mem(ctx, nr_pages);
+			io_unaccount_mem(ctx, nr_pages, ACCT_PINNED);
 			kvfree(imu->bvec);
 			goto err;
 		}
@@ -7398,7 +7413,8 @@ static void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	io_mem_free(ctx->sq_sqes);
 
 	percpu_ref_exit(&ctx->refs);
-	io_unaccount_mem(ctx, ring_pages(ctx->sq_entries, ctx->cq_entries));
+	io_unaccount_mem(ctx, ring_pages(ctx->sq_entries, ctx->cq_entries),
+			 ACCT_LOCKED);
 	free_uid(ctx->user);
 	put_cred(ctx->creds);
 	kfree(ctx->cancel_hash);
@@ -8000,7 +8016,8 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p,
 		goto err;
 
 	trace_io_uring_create(ret, ctx, p->sq_entries, p->cq_entries, p->flags);
-	io_account_mem(ctx, ring_pages(p->sq_entries, p->cq_entries));
+	io_account_mem(ctx, ring_pages(p->sq_entries, p->cq_entries),
+		       ACCT_LOCKED);
 	ctx->limit_mem = limit_mem;
 	return ret;
 err:
-- 
1.8.3.1

