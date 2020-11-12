Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA7A42B1250
	for <lists+io-uring@lfdr.de>; Fri, 13 Nov 2020 00:01:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726063AbgKLXBM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 Nov 2020 18:01:12 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:42546 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726133AbgKLXBM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 Nov 2020 18:01:12 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0ACMsTsZ053661;
        Thu, 12 Nov 2020 23:01:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=gRN11atB4V4scogigdvFGlHZha0PqQJBbDCkNc5myTM=;
 b=cLMm+nnDpScRiOJlEZAqdnXrJujb+YX8Xmuybmuw1iQo+5g3Gy0im5xR5ptdzZ2PgP87
 KqHIfcF4fA4u0Rj6PjNIgJhOb8NkX14JQDrSVYY/j47rOgPG4HdkA0JMnglCkqNKBIT1
 Yci98S6y/Mnm23i9Crhro2VVWCi5wdpfeWuiFyEfUzQqB8z6rd+EzLKjmvThDzrPsEuy
 hhsstzkM2mtEwSTjUoLuzIujGFHcV2adp9YW5mcDYqpIURph0jqNC4gyRYoMaN2goVJ1
 YGEEyDhF3petXanSr0+x1WxwLGngFy2tqd1ysoyEPAimvDqrEW0k00bmKGBMXNy1wKk/ GA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 34nh3b8a8v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 12 Nov 2020 23:01:09 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0ACMpCmt047882;
        Thu, 12 Nov 2020 23:01:09 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 34rt56tv2s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Nov 2020 23:01:09 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0ACN18ii011916;
        Thu, 12 Nov 2020 23:01:08 GMT
Received: from ca-ldom147.us.oracle.com (/10.129.68.131)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 12 Nov 2020 15:01:08 -0800
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk
Cc:     io-uring@vger.kernel.org
Subject: [PATCH 2/8] io_uring: modularize io_sqe_buffers_register
Date:   Thu, 12 Nov 2020 15:00:36 -0800
Message-Id: <1605222042-44558-3-git-send-email-bijan.mottahedeh@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1605222042-44558-1-git-send-email-bijan.mottahedeh@oracle.com>
References: <1605222042-44558-1-git-send-email-bijan.mottahedeh@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9803 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=999 suspectscore=1 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011120129
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9803 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 priorityscore=1501
 clxscore=1015 malwarescore=0 mlxscore=0 spamscore=0 suspectscore=1
 mlxlogscore=999 impostorscore=0 phishscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011120129
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
index 29aa3e1..c6aa8bf 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8353,13 +8353,8 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
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
@@ -8370,6 +8365,37 @@ static int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
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
 
@@ -8377,17 +8403,8 @@ static int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
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

