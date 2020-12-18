Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C29732DE8C2
	for <lists+io-uring@lfdr.de>; Fri, 18 Dec 2020 19:08:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726220AbgLRSIV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Dec 2020 13:08:21 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:41086 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725932AbgLRSIV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Dec 2020 13:08:21 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BII3nFB110443;
        Fri, 18 Dec 2020 18:07:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=yZOVPm9cSbiGhz3RH3kcGlVB+YA5rxc8cns5/m2yWRA=;
 b=PKlvqO0ndQT8B7pf8Xvl1PSK+cW3BCU/pvvU7/LYmNPf2TD5GkTGxFsO+hxL9xa+yCFp
 eQ9NOp5m9IWmqVszkuxWY4C5HqeQ9B3d1J+lRTLQ0K25waPFbWoKAYavP/FObzYgAlCf
 C1tlqFS3k+gNSeV/yf9J+EGfacgOpQZIECWK/8Fc7MyNw7h/+e/3R6AQILl44w3W7uaS
 arHvflwrgsLfX7ZsqtoPMbnKhPs+uLrhX7qKHVinW+hoIApY4O3ReKZ57nrIEzh2rZfq
 reGOpz1VO1GcFy+JWJtDzTkXM7aYYq5d8I4WV/hAOvyj93QmOh39+1DnKm7wQlhrGZ8d Xg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 35ckcbuq89-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 18 Dec 2020 18:07:38 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BII5QWS095708;
        Fri, 18 Dec 2020 18:07:38 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 35e6ev0xng-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Dec 2020 18:07:38 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0BII7cIc015965;
        Fri, 18 Dec 2020 18:07:38 GMT
Received: from ca-ldom147.us.oracle.com (/10.129.68.131)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 18 Dec 2020 10:07:37 -0800
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk, asml.silence@gmail.com, io-uring@vger.kernel.org
Subject: [PATCH v3 02/13] io_uring: modularize io_sqe_buffers_register
Date:   Fri, 18 Dec 2020 10:07:17 -0800
Message-Id: <1608314848-67329-3-git-send-email-bijan.mottahedeh@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1608314848-67329-1-git-send-email-bijan.mottahedeh@oracle.com>
References: <1608314848-67329-1-git-send-email-bijan.mottahedeh@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9839 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012180124
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9839 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 priorityscore=1501 mlxscore=0 suspectscore=0 adultscore=0 phishscore=0
 malwarescore=0 impostorscore=0 lowpriorityscore=0 clxscore=1015
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012180124
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

