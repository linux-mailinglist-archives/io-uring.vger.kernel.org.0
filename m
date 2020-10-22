Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D06A29678F
	for <lists+io-uring@lfdr.de>; Fri, 23 Oct 2020 01:14:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S373281AbgJVXOT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 22 Oct 2020 19:14:19 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:40652 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S373209AbgJVXOT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 22 Oct 2020 19:14:19 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09MN9LUa123536;
        Thu, 22 Oct 2020 23:14:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=jeWu/DueEgfdRwBpyh13dszidgdbRaElndYKVAXZmA4=;
 b=RI/KpYdETlkVP0BLZxb1ShUgq7bvopmobl32tWkce9CKKvXQ4axf+GugHkb5q+h+1BM2
 2wtZ5TEsFhLCScQmalGvyFTMQp7pQJEqEZ2yiU9Vnhv10d+8XLViKqfVnLjwhxHI2Pli
 aT/wqvsquD7TIofZnIDbqKEs9EzxHwuAXrYF694nEGXZSzxDZ+6XcNmyIdwpckCXIrfb
 ZbchYufri3KuvRpWEm3uKwOZxH8zWbJ4VrRoNmuwE9nsAn+pFl56S32Lz9CGmh+pJpfV
 d3Vt5gSID9WlVX7f8rOVpkbuQCoXCGn8D7O0YlQbBLqPTZv0XaSgGrFHXVUNYWLDYk7a +w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 349jrq0pc7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 22 Oct 2020 23:14:17 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09MN6Axk085076;
        Thu, 22 Oct 2020 23:14:17 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 348a6r5n2m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Oct 2020 23:14:17 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09MNEF08022641;
        Thu, 22 Oct 2020 23:14:15 GMT
Received: from ca-ldom147.us.oracle.com (/10.129.68.131)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 22 Oct 2020 16:14:15 -0700
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk, io-uring@vger.kernel.org
Subject: [RFC 2/8] io_uring: modularize io_sqe_buffers_register
Date:   Thu, 22 Oct 2020 16:13:57 -0700
Message-Id: <1603408443-51303-3-git-send-email-bijan.mottahedeh@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1603408443-51303-1-git-send-email-bijan.mottahedeh@oracle.com>
References: <1603408443-51303-1-git-send-email-bijan.mottahedeh@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9782 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 bulkscore=0 spamscore=0 adultscore=0 suspectscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010220148
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9782 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 lowpriorityscore=0
 priorityscore=1501 impostorscore=0 adultscore=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 spamscore=0 suspectscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010220148
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
index 69a28d8..e635da2 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8155,13 +8155,8 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
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
@@ -8172,6 +8167,37 @@ static int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
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
 
@@ -8179,17 +8205,8 @@ static int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
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

