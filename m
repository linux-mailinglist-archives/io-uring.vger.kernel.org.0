Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 119662EC52C
	for <lists+io-uring@lfdr.de>; Wed,  6 Jan 2021 21:40:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727098AbhAFUkP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 6 Jan 2021 15:40:15 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:54924 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727021AbhAFUkP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 6 Jan 2021 15:40:15 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 106KYuL2052583;
        Wed, 6 Jan 2021 20:39:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=kyTUGx8lf3Dhds1HSXTPxArTCi+rzkh1Glb0CMEYLpE=;
 b=Nl8tM8nuop094bIl8+jAzeK3Rd4njOGCkleDLSkZ6mUEWgrnGO21pk9dCtl8g4SKRkQ7
 PamI6BJcPQD5oL5hNiRecsqhRsQAxnfq57xlD8AekkxFT+hxIRf+6mL0h5SL7UfhsID2
 bsuw7YQ0IOw9wnNLfLJkgKSEnJVj2kwn/ugyOvhWMWclpJB7TaxcHQiSjNgkdQbSQUw1
 d2EDHDsKR8DlJMPqmTW0ZGBpBY9eYULTzcqgff2WOgoOxH4mvm2dtZBM1Sv3MxulloFG
 /gOc1am6OujaRSpJVFPEuzMAa2VYRR4MxWqOyiVJcQFLmswtIfhgimKv++ynuMWj8TU7 ew== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 35wepm9s2f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 06 Jan 2021 20:39:32 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 106KZZWm145358;
        Wed, 6 Jan 2021 20:39:32 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 35w3g1jf15-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Jan 2021 20:39:32 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 106KdVfI021568;
        Wed, 6 Jan 2021 20:39:31 GMT
Received: from ca-ldom147.us.oracle.com (/10.129.68.131)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 Jan 2021 20:39:31 +0000
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk, asml.silence@gmail.com, io-uring@vger.kernel.org
Subject: [PATCH v4 02/13] io_uring: modularize io_sqe_buffers_register
Date:   Wed,  6 Jan 2021 12:39:11 -0800
Message-Id: <1609965562-13569-3-git-send-email-bijan.mottahedeh@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1609965562-13569-1-git-send-email-bijan.mottahedeh@oracle.com>
References: <1609965562-13569-1-git-send-email-bijan.mottahedeh@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9856 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 adultscore=0
 phishscore=0 spamscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
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

Move allocation of buffer management structures, and validation of
buffers into separate routines.

Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
---
 fs/io_uring.c | 51 ++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 34 insertions(+), 17 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 2708409..ed90dbe 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8490,13 +8490,8 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
 	return ret;
 }
 
-static int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
-				   unsigned int nr_args)
+static int io_buffers_map_alloc(struct io_ring_ctx *ctx, unsigned int nr_args)
 {
-	int i, ret;
-	struct iovec iov;
-	struct page *last_hpage = NULL;
-
 	if (ctx->user_bufs)
 		return -EBUSY;
 	if (!nr_args || nr_args > UIO_MAXIOV)
@@ -8507,6 +8502,37 @@ static int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
 	if (!ctx->user_bufs)
 		return -ENOMEM;
 
+	return 0;
+}
+
+static int io_buffer_validate(struct iovec *iov)
+{
+	/*
+	 * Don't impose further limits on the size and buffer
+	 * constraints here, we'll -EINVAL later when IO is
+	 * submitted if they are wrong.
+	 */
+	if (!iov->iov_base || !iov->iov_len)
+		return -EFAULT;
+
+	/* arbitrary limit, but we need something */
+	if (iov->iov_len > SZ_1G)
+		return -EFAULT;
+
+	return 0;
+}
+
+static int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
+				   unsigned int nr_args)
+{
+	int i, ret;
+	struct iovec iov;
+	struct page *last_hpage = NULL;
+
+	ret = io_buffers_map_alloc(ctx, nr_args);
+	if (ret)
+		return ret;
+
 	for (i = 0; i < nr_args; i++) {
 		struct io_mapped_ubuf *imu = &ctx->user_bufs[i];
 
@@ -8514,17 +8540,8 @@ static int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
 		if (ret)
 			break;
 
-		/*
-		 * Don't impose further limits on the size and buffer
-		 * constraints here, we'll -EINVAL later when IO is
-		 * submitted if they are wrong.
-		 */
-		ret = -EFAULT;
-		if (!iov.iov_base || !iov.iov_len)
-			break;
-
-		/* arbitrary limit, but we need something */
-		if (iov.iov_len > SZ_1G)
+		ret = io_buffer_validate(&iov);
+		if (ret)
 			break;
 
 		ret = io_sqe_buffer_register(ctx, &iov, imu, &last_hpage);
-- 
1.8.3.1

