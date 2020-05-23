Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 250491DF4D2
	for <lists+io-uring@lfdr.de>; Sat, 23 May 2020 06:31:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387575AbgEWEbn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 23 May 2020 00:31:43 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:50848 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387460AbgEWEbn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 23 May 2020 00:31:43 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04N4RtPM071742;
        Sat, 23 May 2020 04:31:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=BTz7ve27debhRuQSPj2mXcFroKc/phwU4uSR+HqbnYA=;
 b=xrX2ydrbDeU7ltsGQI8PrikTmL1R7qqTIioIqgAjnE3pHlYXWXaIwkxZj89OQ1kmTipQ
 6RABg7rQ148E2JwwIdng6s11g2aJTY3MdqpORDGyGrQ60daEO47poSexHqrD8Sc98RIa
 0cGHRod+PtahSwIrwwTAcDg3H83HkhUDLAXmmVW1kLKuF9ZND/F684JddiUB+7FPHQvq
 AZ6lOeJlOJdwXVa8ldzadwfIjIit455C8DniOdwrb3xXyPSonIxNiRBmBV8Cg9qh6cv9
 CXDdDjds7EdiJa3qtJDGGFqaqmDCqpMuNsxVij+hF7YyMotqwBq8N7dAHWXLBrQlyxaY Pg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 316uskg2q9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 23 May 2020 04:31:42 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04N4SjC8128420;
        Sat, 23 May 2020 04:31:41 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 316sv8pet3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 May 2020 04:31:41 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04N4VcvA014354;
        Sat, 23 May 2020 04:31:38 GMT
Received: from ca-ldom147.us.oracle.com (/10.129.68.131)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 22 May 2020 21:31:38 -0700
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH v2 1/4] io_uring: add io_statx structure
Date:   Fri, 22 May 2020 21:31:16 -0700
Message-Id: <1590208279-33811-2-git-send-email-bijan.mottahedeh@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1590208279-33811-1-git-send-email-bijan.mottahedeh@oracle.com>
References: <1590208279-33811-1-git-send-email-bijan.mottahedeh@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9629 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 suspectscore=1
 adultscore=0 phishscore=0 mlxscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005230035
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9629 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 lowpriorityscore=0
 suspectscore=1 spamscore=0 priorityscore=1501 clxscore=1015
 impostorscore=0 bulkscore=0 mlxlogscore=999 phishscore=0
 cotscore=-2147483648 adultscore=0 mlxscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005230035
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Separate statx data from open in io_kiocb. No functional changes.

Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
---
 fs/io_uring.c | 38 ++++++++++++++++++++++----------------
 1 file changed, 22 insertions(+), 16 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 654e1c7..fba0ddb 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -424,11 +424,7 @@ struct io_sr_msg {
 struct io_open {
 	struct file			*file;
 	int				dfd;
-	union {
-		unsigned		mask;
-	};
 	struct filename			*filename;
-	struct statx __user		*buffer;
 	struct open_how			how;
 	unsigned long			nofile;
 };
@@ -480,6 +476,15 @@ struct io_provide_buf {
 	__u16				bid;
 };
 
+struct io_statx {
+	struct file			*file;
+	int				dfd;
+	unsigned int			mask;
+	unsigned int			flags;
+	struct filename			*filename;
+	struct statx __user		*buffer;
+};
+
 struct io_async_connect {
 	struct sockaddr_storage		address;
 };
@@ -621,6 +626,7 @@ struct io_kiocb {
 		struct io_epoll		epoll;
 		struct io_splice	splice;
 		struct io_provide_buf	pbuf;
+		struct io_statx		statx;
 	};
 
 	struct io_async_ctx		*io;
@@ -3379,19 +3385,19 @@ static int io_statx_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (req->flags & REQ_F_NEED_CLEANUP)
 		return 0;
 
-	req->open.dfd = READ_ONCE(sqe->fd);
-	req->open.mask = READ_ONCE(sqe->len);
+	req->statx.dfd = READ_ONCE(sqe->fd);
+	req->statx.mask = READ_ONCE(sqe->len);
 	fname = u64_to_user_ptr(READ_ONCE(sqe->addr));
-	req->open.buffer = u64_to_user_ptr(READ_ONCE(sqe->addr2));
-	req->open.how.flags = READ_ONCE(sqe->statx_flags);
+	req->statx.buffer = u64_to_user_ptr(READ_ONCE(sqe->addr2));
+	req->statx.flags = READ_ONCE(sqe->statx_flags);
 
-	if (vfs_stat_set_lookup_flags(&lookup_flags, req->open.how.flags))
+	if (vfs_stat_set_lookup_flags(&lookup_flags, req->statx.flags))
 		return -EINVAL;
 
-	req->open.filename = getname_flags(fname, lookup_flags, NULL);
-	if (IS_ERR(req->open.filename)) {
-		ret = PTR_ERR(req->open.filename);
-		req->open.filename = NULL;
+	req->statx.filename = getname_flags(fname, lookup_flags, NULL);
+	if (IS_ERR(req->statx.filename)) {
+		ret = PTR_ERR(req->statx.filename);
+		req->statx.filename = NULL;
 		return ret;
 	}
 
@@ -3401,7 +3407,7 @@ static int io_statx_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 static int io_statx(struct io_kiocb *req, bool force_nonblock)
 {
-	struct io_open *ctx = &req->open;
+	struct io_statx *ctx = &req->statx;
 	unsigned lookup_flags;
 	struct path path;
 	struct kstat stat;
@@ -3414,7 +3420,7 @@ static int io_statx(struct io_kiocb *req, bool force_nonblock)
 		return -EAGAIN;
 	}
 
-	if (vfs_stat_set_lookup_flags(&lookup_flags, ctx->how.flags))
+	if (vfs_stat_set_lookup_flags(&lookup_flags, ctx->flags))
 		return -EINVAL;
 
 retry:
@@ -3426,7 +3432,7 @@ static int io_statx(struct io_kiocb *req, bool force_nonblock)
 	if (ret)
 		goto err;
 
-	ret = vfs_getattr(&path, &stat, ctx->mask, ctx->how.flags);
+	ret = vfs_getattr(&path, &stat, ctx->mask, ctx->flags);
 	path_put(&path);
 	if (retry_estale(ret, lookup_flags)) {
 		lookup_flags |= LOOKUP_REVAL;
-- 
1.8.3.1

