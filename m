Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE9C51613A7
	for <lists+io-uring@lfdr.de>; Mon, 17 Feb 2020 14:37:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726833AbgBQNhm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 17 Feb 2020 08:37:42 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:54160 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726397AbgBQNhm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 17 Feb 2020 08:37:42 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01HDUr5N006052;
        Mon, 17 Feb 2020 13:37:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2020-01-29;
 bh=yWDCg3ckzh4//bzmb6nvafbb8ctIsxm07TPa/cSuAr4=;
 b=wgwI+2DaSG38EizLwC2ig5GlhkFUlZe0j5rUYw79ChDvFK2BOqBk9ycFhUZs0HGxsKYS
 tM1VGcVSbTbCFIgiuhI4l3e0mCiqqhYyM0AQrZ/IlEmFoTeYWZcSn9CmI2Hex3vdCACr
 mu553Q6VsUrdhrGiHPCyigcjlPc2QYPCxr7OMWZGtblucYaZDG9lVG7rJ6Csu9zXAWln
 RZ/A/iJqoJufMMJpP1Gb5KwSjD1rMt88COt4q/jwy6kbiHVqRI9oDLoIRTc7qbGw+pLJ
 ///zIVyLwjz3UV3Y8NdgmP6/wNLZkdg/m+UJcqEWlAdo3oFoYtR0gg7MThwLBB9rdQkX CQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2y7aq5kf6a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Feb 2020 13:37:37 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01HDbbji030258;
        Mon, 17 Feb 2020 13:37:37 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2y6tc058mn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Feb 2020 13:37:36 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01HDbZFg024054;
        Mon, 17 Feb 2020 13:37:35 GMT
Received: from localhost.localdomain (/114.88.246.185)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 17 Feb 2020 05:37:35 -0800
From:   Bob Liu <bob.liu@oracle.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, Bob Liu <bob.liu@oracle.com>
Subject: [PATCH] example/io_uring-test.c: change to use real readv
Date:   Mon, 17 Feb 2020 21:37:07 +0800
Message-Id: <20200217133707.3667-1-bob.liu@oracle.com>
X-Mailer: git-send-email 2.9.5
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9533 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 suspectscore=1
 mlxscore=0 malwarescore=0 bulkscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002170112
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9533 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0 adultscore=0
 spamscore=0 priorityscore=1501 suspectscore=1 clxscore=1011 bulkscore=0
 phishscore=0 mlxlogscore=999 lowpriorityscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002170111
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Readv can read vecs in one sqe instead of multi sqe.

Signed-off-by: Bob Liu <bob.liu@oracle.com>
---
 examples/io_uring-test.c | 21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

diff --git a/examples/io_uring-test.c b/examples/io_uring-test.c
index 4f5ebf6..96fa4d1 100644
--- a/examples/io_uring-test.c
+++ b/examples/io_uring-test.c
@@ -20,7 +20,6 @@ int main(int argc, char *argv[])
 	struct io_uring_sqe *sqe;
 	struct io_uring_cqe *cqe;
 	struct iovec *iovecs;
-	off_t offset;
 	void *buf;
 
 	if (argc < 2) {
@@ -28,7 +27,7 @@ int main(int argc, char *argv[])
 		return 1;
 	}
 
-	ret = io_uring_queue_init(QD, &ring, 0);
+	ret = io_uring_queue_init(1, &ring, 0);
 	if (ret < 0) {
 		fprintf(stderr, "queue_init: %s\n", strerror(-ret));
 		return 1;
@@ -48,16 +47,10 @@ int main(int argc, char *argv[])
 		iovecs[i].iov_len = 4096;
 	}
 
-	offset = 0;
-	i = 0;
-	do {
-		sqe = io_uring_get_sqe(&ring);
-		if (!sqe)
-			break;
-		io_uring_prep_readv(sqe, fd, &iovecs[i], 1, offset);
-		offset += iovecs[i].iov_len;
-		i++;
-	} while (1);
+	sqe = io_uring_get_sqe(&ring);
+	if (!sqe)
+		return 1;
+	io_uring_prep_readv(sqe, fd, iovecs, QD, 0);
 
 	ret = io_uring_submit(&ring);
 	if (ret < 0) {
@@ -76,8 +69,8 @@ int main(int argc, char *argv[])
 
 		done++;
 		ret = 0;
-		if (cqe->res != 4096) {
-			fprintf(stderr, "ret=%d, wanted 4096\n", cqe->res);
+		if (cqe->res != 4096 * QD) {
+			fprintf(stderr, "ret=%d, wanted=%d\n", cqe->res, 4096*QD);
 			ret = 1;
 		}
 		io_uring_cqe_seen(&ring, cqe);
-- 
2.17.1

