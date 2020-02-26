Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C06816F9CB
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2020 09:41:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727854AbgBZIkt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 26 Feb 2020 03:40:49 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:33514 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727823AbgBZIkt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 26 Feb 2020 03:40:49 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01Q8dUX1013730;
        Wed, 26 Feb 2020 08:40:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=CT6n6U935vcrUBg8uf+s666OpRuH6tq158bXwYwRJ/I=;
 b=JiIsQRjnXpNWR8RDOkYMWO7f8nH4LsVTW/PoyHxWI9bVbrFvFmxEWzIRosSEvjQB+ewL
 25+kfTx/2rHQm7OKp7SyYb2Fdmdtm67VQ5zV1iqlr3Q3pKh7ZQfwkEVbRfLxDV5RRLv1
 R4fRjaz5X+P8xlVIItg1Z7kt/fM1zroNFhUdc2wGtbH8+JYfqDSS97ig4hVTo+Rz6MBq
 nq+dP4w8JefZ06LrVX3AL/kGGwB1XDXaRnlMqRCqFSImurjemUD5mtpvVP+RZy/2DFIE
 QgzXwDhhGCF7shfvapptPCBuF3PKvKsohh4bTqG3eHWJmqV0HaDpTmpTNrATd32Yoax3 Mg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2ydcsn9xp1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Feb 2020 08:40:46 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01Q8cBdD091499;
        Wed, 26 Feb 2020 08:38:46 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2ydcs1hs1u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Feb 2020 08:38:45 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01Q8cikv010058;
        Wed, 26 Feb 2020 08:38:44 GMT
Received: from localhost.localdomain (/114.88.246.185)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 26 Feb 2020 00:38:43 -0800
From:   Bob Liu <bob.liu@oracle.com>
To:     linux-block@vger.kernel.org
Cc:     axboe@kernel.dk, martin.petersen@oracle.com,
        linux-fsdevel@vger.kernel.org, darrick.wong@oracle.com,
        io-uring@vger.kernel.org, Bob Liu <bob.liu@oracle.com>
Subject: [PATCH 1/4] io_uring: add IORING_OP_READ{WRITE}V_PI cmd
Date:   Wed, 26 Feb 2020 16:37:16 +0800
Message-Id: <20200226083719.4389-2-bob.liu@oracle.com>
X-Mailer: git-send-email 2.9.5
In-Reply-To: <20200226083719.4389-1-bob.liu@oracle.com>
References: <20200226083719.4389-1-bob.liu@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9542 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 phishscore=0 suspectscore=1 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002260065
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9542 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 lowpriorityscore=0 mlxlogscore=999 phishscore=0 spamscore=0 adultscore=0
 suspectscore=1 impostorscore=0 clxscore=1015 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002260065
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add read and write with protect information command.

Signed-off-by: Bob Liu <bob.liu@oracle.com>
---
 fs/io_uring.c                 | 12 ++++++++++++
 include/linux/fs.h            |  1 +
 include/uapi/linux/io_uring.h |  2 ++
 3 files changed, 15 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 562e3a1..c43d96a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -630,12 +630,14 @@ static inline bool io_prep_async_work(struct io_kiocb *req,
 
 	switch (req->opcode) {
 	case IORING_OP_WRITEV:
+	case IORING_OP_WRITEV_PI:
 	case IORING_OP_WRITE_FIXED:
 		/* only regular files should be hashed for writes */
 		if (req->flags & REQ_F_ISREG)
 			do_hashed = true;
 		/* fall-through */
 	case IORING_OP_READV:
+	case IORING_OP_READV_PI:
 	case IORING_OP_READ_FIXED:
 	case IORING_OP_SENDMSG:
 	case IORING_OP_RECVMSG:
@@ -1505,6 +1507,12 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	kiocb->ki_pos = READ_ONCE(sqe->off);
 	kiocb->ki_flags = iocb_flags(kiocb->ki_filp);
 	kiocb->ki_hint = ki_hint_validate(file_write_hint(kiocb->ki_filp));
+	if (req->opcode == IORING_OP_READV_PI ||
+			req->opcode == IORING_OP_WRITEV_PI) {
+		if (!(req->file->f_flags & O_DIRECT))
+			return -EINVAL;
+		kiocb->ki_flags |= IOCB_USE_PI;
+	}
 
 	ioprio = READ_ONCE(sqe->ioprio);
 	if (ioprio) {
@@ -3065,10 +3073,12 @@ static int io_req_defer_prep(struct io_kiocb *req,
 	case IORING_OP_NOP:
 		break;
 	case IORING_OP_READV:
+	case IORING_OP_READV_PI:
 	case IORING_OP_READ_FIXED:
 		ret = io_read_prep(req, sqe, true);
 		break;
 	case IORING_OP_WRITEV:
+	case IORING_OP_WRITEV_PI:
 	case IORING_OP_WRITE_FIXED:
 		ret = io_write_prep(req, sqe, true);
 		break;
@@ -3156,6 +3166,7 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	case IORING_OP_NOP:
 		ret = io_nop(req);
 		break;
+	case IORING_OP_READV_PI:
 	case IORING_OP_READV:
 	case IORING_OP_READ_FIXED:
 		if (sqe) {
@@ -3166,6 +3177,7 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 		ret = io_read(req, nxt, force_nonblock);
 		break;
 	case IORING_OP_WRITEV:
+	case IORING_OP_WRITEV_PI:
 	case IORING_OP_WRITE_FIXED:
 		if (sqe) {
 			ret = io_write_prep(req, sqe, force_nonblock);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 98e0349..65fda07 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -314,6 +314,7 @@ enum rw_hint {
 #define IOCB_SYNC		(1 << 5)
 #define IOCB_WRITE		(1 << 6)
 #define IOCB_NOWAIT		(1 << 7)
+#define IOCB_USE_PI		(1 << 8)
 
 struct kiocb {
 	struct file		*ki_filp;
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index a3300e1..98fa3f1 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -62,6 +62,8 @@ enum {
 	IORING_OP_NOP,
 	IORING_OP_READV,
 	IORING_OP_WRITEV,
+	IORING_OP_READV_PI,
+	IORING_OP_WRITEV_PI,
 	IORING_OP_FSYNC,
 	IORING_OP_READ_FIXED,
 	IORING_OP_WRITE_FIXED,
-- 
2.9.5

