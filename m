Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4AE72D1D28
	for <lists+io-uring@lfdr.de>; Mon,  7 Dec 2020 23:20:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727195AbgLGWSt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 7 Dec 2020 17:18:49 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:43648 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726069AbgLGWSs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 7 Dec 2020 17:18:48 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B7MA2ke132483;
        Mon, 7 Dec 2020 22:18:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=yZOVPm9cSbiGhz3RH3kcGlVB+YA5rxc8cns5/m2yWRA=;
 b=PldUTyVJxmFgP4SxFnS51BEpxGGo7JnsmTC3fWkA9WJme2LtrETpVzOd3MHTtWMX3Qct
 FWUSlhzi7BCgJj13fTPUfPRClfsvttGUtgFNkE1pttCi8V/jtUlU91rGQzscsjpN0Yrs
 t/nk31MZOXN6ddeDoXWHPnmNVIkgTwbtE0ZsAq2+hCiqzVZYUQyH458t8aJZaeqzaQA0
 Kd5S3Ra9yi3WH//7myOpfM7/kvKw9s1RGOekqk32ZFvKku4+2bEeRUP6OxeAg9Dtxz3C
 m+9qGjUug1hgvAT9fWZ2M1EBJOsnH4kJ6qjKcdeq/xka//REZ2LzrIOYOgvI/zx4sTqE 7w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 3581mqqvbg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 07 Dec 2020 22:18:05 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B7M9eZJ044241;
        Mon, 7 Dec 2020 22:16:05 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 358m4ww8xg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Dec 2020 22:16:05 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B7MG42t017196;
        Mon, 7 Dec 2020 22:16:04 GMT
Received: from ca-ldom147.us.oracle.com (/10.129.68.131)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 07 Dec 2020 14:16:04 -0800
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk, asml.silence@gmail.com, io-uring@vger.kernel.org
Subject: [PATCH v2 02/13] io_uring: modularize io_sqe_buffers_register
Date:   Mon,  7 Dec 2020 14:15:41 -0800
Message-Id: <1607379352-68109-3-git-send-email-bijan.mottahedeh@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1607379352-68109-1-git-send-email-bijan.mottahedeh@oracle.com>
References: <1607379352-68109-1-git-send-email-bijan.mottahedeh@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9828 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 suspectscore=0
 bulkscore=0 malwarescore=0 phishscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012070145
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9828 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 clxscore=1015 malwarescore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 phishscore=0 spamscore=0 impostorscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012070145
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
index 7d6718a..d8505e2 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8461,13 +8461,8 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
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
@@ -8478,6 +8473,37 @@ static int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
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
 
@@ -8485,17 +8511,8 @@ static int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
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

