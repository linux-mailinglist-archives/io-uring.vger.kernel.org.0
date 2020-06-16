Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD54B1FC269
	for <lists+io-uring@lfdr.de>; Wed, 17 Jun 2020 01:40:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726134AbgFPXiU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 16 Jun 2020 19:38:20 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:49684 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725849AbgFPXiU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 16 Jun 2020 19:38:20 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05GNbQ9r149847;
        Tue, 16 Jun 2020 23:38:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=kHjdKVxZD7+dSLLMQY0co8+gV93yGxRYcxYjXO+ucAY=;
 b=X2Xp0cM5Mmo9o7EEZaQvBPjCLnm+XFmpiNB+tBpLQ+kiPsma8CimPUWomtVt3Wpx2trt
 ATdFKwLqdkcqW/PXtWu2BSgedPtwF4EI9fqPc4Upbru6MhB9/v0HFJ9l2PziqMUqPSpl
 2nzomtie7XGHOdoI7o6SiAw8ObULx4krCSInOYDH84kjvZqDFJsg2HMOIyUMLdF89jr8
 5efeCadVGhoW7R0zl/UoYvA6sBASvxdpdDvfhN5jUx90ZVzektz65OrTcOld3NPjgCK3
 w3A0XyUdbpSEB2D8+a3HO5zMXMw5iP810YMQqcM4ptRnMzxJJWuuW2yMxe7EhcE12kg5 bQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 31q63y8amw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 16 Jun 2020 23:38:18 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05GNT32c193480;
        Tue, 16 Jun 2020 23:36:17 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 31q66m8641-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Jun 2020 23:36:17 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05GNaHNI019778;
        Tue, 16 Jun 2020 23:36:17 GMT
Received: from ca-ldom147.us.oracle.com (/10.129.68.131)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 16 Jun 2020 16:36:16 -0700
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk
Cc:     io-uring@vger.kernel.org
Subject: [PATCH 3/4] io_uring: report pinned memory usage
Date:   Tue, 16 Jun 2020 16:36:09 -0700
Message-Id: <1592350570-24396-4-git-send-email-bijan.mottahedeh@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1592350570-24396-1-git-send-email-bijan.mottahedeh@oracle.com>
References: <1592350570-24396-1-git-send-email-bijan.mottahedeh@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9654 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 bulkscore=0 adultscore=0 phishscore=0 suspectscore=3 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006160162
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9654 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 impostorscore=0
 mlxlogscore=999 priorityscore=1501 adultscore=0 malwarescore=0 spamscore=0
 clxscore=1015 cotscore=-2147483648 bulkscore=0 suspectscore=3
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006160163
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Report pinned memory usage always, regardless of whether locked memory
limit is enforced.

Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
---
 fs/io_uring.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 0bcbc1a..851ff21 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7057,12 +7057,23 @@ static void io_unaccount_mem(struct io_ring_ctx *ctx, unsigned long nr_pages)
 {
 	if (ctx->limit_mem)
 		__io_unaccount_mem(ctx->user, nr_pages);
+
+	if (ctx->sqo_mm)
+		atomic64_sub(nr_pages, &ctx->sqo_mm->pinned_vm);
 }
 
 static int io_account_mem(struct io_ring_ctx *ctx, unsigned long nr_pages)
 {
-	if (ctx->limit_mem)
-		return (__io_account_mem(ctx->user, nr_pages));
+	int ret;
+
+	if (ctx->limit_mem) {
+		ret = __io_account_mem(ctx->user, nr_pages);
+		if (ret)
+			return ret;
+	}
+
+	if (ctx->sqo_mm)
+		atomic64_add(nr_pages, &ctx->sqo_mm->pinned_vm);
 
 	return 0;
 }
@@ -7364,8 +7375,10 @@ static void io_destroy_buffers(struct io_ring_ctx *ctx)
 static void io_ring_ctx_free(struct io_ring_ctx *ctx)
 {
 	io_finish_async(ctx);
-	if (ctx->sqo_mm)
+	if (ctx->sqo_mm) {
 		mmdrop(ctx->sqo_mm);
+		ctx->sqo_mm = NULL;
+	}
 
 	io_iopoll_reap_events(ctx);
 	io_sqe_buffer_unregister(ctx);
@@ -7941,7 +7954,6 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p,
 		return -ENOMEM;
 	}
 	ctx->compat = in_compat_syscall();
-	ctx->limit_mem = limit_mem;
 	ctx->user = user;
 	ctx->creds = get_current_cred();
 
@@ -7988,6 +8000,8 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p,
 		goto err;
 
 	trace_io_uring_create(ret, ctx, p->sq_entries, p->cq_entries, p->flags);
+	io_account_mem(ctx, ring_pages(p->sq_entries, p->cq_entries));
+	ctx->limit_mem = limit_mem;
 	return ret;
 err:
 	io_ring_ctx_wait_and_kill(ctx);
-- 
1.8.3.1

