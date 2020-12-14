Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 768822DA260
	for <lists+io-uring@lfdr.de>; Mon, 14 Dec 2020 22:10:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503255AbgLNVKM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Dec 2020 16:10:12 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:40716 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503657AbgLNVKD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Dec 2020 16:10:03 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BEKsHVc144088;
        Mon, 14 Dec 2020 21:09:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=8/Dq3PJ2+KoUmWzV8nHEo+y5qwzYO7/ROX6JQ984piY=;
 b=lhTtNlslA5EpHmLNK6sMrmisQdnc+g9Dx7mZ4zZVbV4s9V8ZJzXSFSbjlhD/YmnNu2lF
 cUBP5pF/3BCIExY3lwIOpOBL/t6bqJy/mIAhosybHEVSR8Zs3ptA8LZcn98ulDTzgt/x
 ALppnM95Xn1wZhF1cAtnL56HLCCyMgZ+vJFwBPQrgHz0dSil2yzJDQQvmmTZWPiRCBT+
 I3XIPCq1cPuL5cuFDuE48Gt6SwPBiYCq+4buTdZLDV6CFzl6mU+eW3BJy+3seTJTWjDv
 KqmaKciTvXSybfjhx2NJbbsalRJu7uEfBjTfqB4/mCiCjyRo2ec4nj3+QSSN3vYgta4x xw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 35cn9r7h3v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 14 Dec 2020 21:09:21 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BEKsoLM131517;
        Mon, 14 Dec 2020 21:09:20 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 35e6epe5ba-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Dec 2020 21:09:20 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0BEL9K9W019878;
        Mon, 14 Dec 2020 21:09:20 GMT
Received: from ca-ldom147.us.oracle.com (/10.129.68.131)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 14 Dec 2020 13:09:19 -0800
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk, io-uring@vger.kernel.org
Subject: [PATCH 1/5] liburing: support buffer registration updates
Date:   Mon, 14 Dec 2020 13:09:07 -0800
Message-Id: <1607980151-18816-2-git-send-email-bijan.mottahedeh@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1607980151-18816-1-git-send-email-bijan.mottahedeh@oracle.com>
References: <1607980151-18816-1-git-send-email-bijan.mottahedeh@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9834 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012140140
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9834 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 impostorscore=0 lowpriorityscore=0 clxscore=1015 spamscore=0
 malwarescore=0 priorityscore=1501 phishscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012140140
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
---
 src/include/liburing.h          | 12 ++++++++++++
 src/include/liburing/io_uring.h | 10 ++++++++--
 src/register.c                  | 27 ++++++++++++++++++++++++++-
 3 files changed, 46 insertions(+), 3 deletions(-)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index ebfc424..9648f8c 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -114,6 +114,9 @@ extern int io_uring_register_buffers(struct io_uring *ring,
 					const struct iovec *iovecs,
 					unsigned nr_iovecs);
 extern int io_uring_unregister_buffers(struct io_uring *ring);
+extern int io_uring_register_buffers_update(struct io_uring *ring, unsigned off,
+					struct iovec *iovecs,
+					unsigned nr_iovecs);
 extern int io_uring_register_files(struct io_uring *ring, const int *files,
 					unsigned nr_files);
 extern int io_uring_unregister_files(struct io_uring *ring);
@@ -373,6 +376,15 @@ static inline void io_uring_prep_files_update(struct io_uring_sqe *sqe,
 	io_uring_prep_rw(IORING_OP_FILES_UPDATE, sqe, -1, fds, nr_fds, offset);
 }
 
+static inline void io_uring_prep_buffers_update(struct io_uring_sqe *sqe,
+						struct iovec *iovs,
+						unsigned nr_iovs,
+						int offset)
+{
+	io_uring_prep_rw(IORING_OP_BUFFERS_UPDATE, sqe, -1, iovs, nr_iovs,
+			 offset);
+}
+
 static inline void io_uring_prep_fallocate(struct io_uring_sqe *sqe, int fd,
 					   int mode, off_t offset, off_t len)
 {
diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_uring.h
index 0bb55b0..4e61817 100644
--- a/src/include/liburing/io_uring.h
+++ b/src/include/liburing/io_uring.h
@@ -141,6 +141,7 @@ enum {
 	IORING_OP_SHUTDOWN,
 	IORING_OP_RENAMEAT,
 	IORING_OP_UNLINKAT,
+	IORING_OP_BUFFERS_UPDATE,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
@@ -284,15 +285,20 @@ enum {
 	IORING_UNREGISTER_PERSONALITY		= 10,
 	IORING_REGISTER_RESTRICTIONS		= 11,
 	IORING_REGISTER_ENABLE_RINGS		= 12,
+	IORING_REGISTER_BUFFERS_UPDATE		= 13,
 
 	/* this goes last */
 	IORING_REGISTER_LAST
 };
 
-struct io_uring_files_update {
+struct io_uring_rsrc_update {
 	__u32 offset;
 	__u32 resv;
-	__aligned_u64 /* __s32 * */ fds;
+	union {
+		__aligned_u64 /* __s32 * */ fds;
+		__aligned_u64 /* __s32 * */ iovs;
+		__aligned_u64 /* __s32 * */ rsrc;
+	};
 };
 
 #define IO_URING_OP_SUPPORTED	(1U << 0)
diff --git a/src/register.c b/src/register.c
index 994aaff..80292d9 100644
--- a/src/register.c
+++ b/src/register.c
@@ -14,6 +14,31 @@
 
 #include "syscall.h"
 
+/*
+ * Register an update for an existing buffer set. The updates will start at
+ * 'off' in the original array, and 'nr_iovecs' is the number of buffers we'll
+ * update.
+ *
+ * Returns number of files updated on success, -ERROR on failure.
+ */
+int io_uring_register_buffers_update(struct io_uring *ring, unsigned off,
+				     struct iovec *iovecs, unsigned nr_iovecs)
+{
+	struct io_uring_rsrc_update up = {
+		.offset	= off,
+		.iovs	= (unsigned long) iovecs,
+	};
+	int ret;
+
+	ret = __sys_io_uring_register(ring->ring_fd,
+					IORING_REGISTER_BUFFERS_UPDATE, &up,
+					nr_iovecs);
+	if (ret < 0)
+		return -errno;
+
+	return ret;
+}
+
 int io_uring_register_buffers(struct io_uring *ring, const struct iovec *iovecs,
 			      unsigned nr_iovecs)
 {
@@ -49,7 +74,7 @@ int io_uring_unregister_buffers(struct io_uring *ring)
 int io_uring_register_files_update(struct io_uring *ring, unsigned off,
 				   int *files, unsigned nr_files)
 {
-	struct io_uring_files_update up = {
+	struct io_uring_rsrc_update up = {
 		.offset	= off,
 		.fds	= (unsigned long) files,
 	};
-- 
1.8.3.1

