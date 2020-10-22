Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFAB9296797
	for <lists+io-uring@lfdr.de>; Fri, 23 Oct 2020 01:16:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S373333AbgJVXQU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 22 Oct 2020 19:16:20 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:32972 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S373330AbgJVXQU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 22 Oct 2020 19:16:20 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09MNFFs5056329;
        Thu, 22 Oct 2020 23:16:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=5NzQfX1/JWNotuRcw5+DhlaWwZzYm74OYjafpJ4qbZ4=;
 b=Sqh76e8daq868Xw2mgormZxaXoDoaJ4K/onuPj2VucZzHXbr+5AD6kUA0xyIJ3tp22Ug
 YgOE2jvPuobBIzUL0ue0oNlZAFNKF2J4VoT/iFy1x6pFXhAssmg6G7K5ieUQPivDiP6M
 2qLMYK/62AaWoD6uyLfMHQU9xZS82D4bm11PJgemT13N1wmrs/jJoADpftsuEoKXn0gH
 +4YK/q3hDYvEsOT6UU1GFxUQ7yLSmDzIWux14dQg907EQ0P5rok4xjwNHL/zw86J4i+O
 ZJSi5U9de920aVvKW2QJ7HDMX5Z86E/uzV5nTV/PhsJjcb98yB3vMnrrXtFbWgARKKU8 qA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 347p4b8ngb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 22 Oct 2020 23:16:17 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09MN5jeJ095161;
        Thu, 22 Oct 2020 23:14:17 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 348ah1dcj1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Oct 2020 23:14:17 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09MNEHg2018416;
        Thu, 22 Oct 2020 23:14:17 GMT
Received: from ca-ldom147.us.oracle.com (/10.129.68.131)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 22 Oct 2020 16:14:17 -0700
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk, io-uring@vger.kernel.org
Subject: [RFC 7/8] io_uring: support readv/writev with fixed buffers
Date:   Thu, 22 Oct 2020 16:14:02 -0700
Message-Id: <1603408443-51303-8-git-send-email-bijan.mottahedeh@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1603408443-51303-1-git-send-email-bijan.mottahedeh@oracle.com>
References: <1603408443-51303-1-git-send-email-bijan.mottahedeh@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9782 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 malwarescore=0 spamscore=0 suspectscore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010220148
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9782 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 priorityscore=1501
 clxscore=1015 malwarescore=0 mlxscore=0 bulkscore=0 lowpriorityscore=0
 phishscore=0 adultscore=0 mlxlogscore=999 impostorscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010220149
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Support readv/writev with fixed buffers, and introduce IOSQE_FIXED_BUFFER,
consistent with fixed files.

Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
---
 fs/io_uring.c                 | 61 +++++++++++++++++++++++++++++++++++++++----
 include/uapi/linux/io_uring.h |  3 +++
 2 files changed, 59 insertions(+), 5 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d69d642..a8d8871 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -599,6 +599,7 @@ enum {
 	REQ_F_HARDLINK_BIT	= IOSQE_IO_HARDLINK_BIT,
 	REQ_F_FORCE_ASYNC_BIT	= IOSQE_ASYNC_BIT,
 	REQ_F_BUFFER_SELECT_BIT	= IOSQE_BUFFER_SELECT_BIT,
+	REQ_F_FIXED_BUFFER_BIT	= IOSQE_FIXED_BUFFER_BIT,
 
 	REQ_F_LINK_HEAD_BIT,
 	REQ_F_FAIL_LINK_BIT,
@@ -658,8 +659,12 @@ enum {
 	REQ_F_WORK_INITIALIZED	= BIT(REQ_F_WORK_INITIALIZED_BIT),
 	/* linked timeout is active, i.e. prepared by link's head */
 	REQ_F_LTIMEOUT_ACTIVE	= BIT(REQ_F_LTIMEOUT_ACTIVE_BIT),
+	/* ctx owns buffer */
+	REQ_F_FIXED_BUFFER	= BIT(REQ_F_FIXED_BUFFER_BIT),
 };
 
+#define REQ_F_FIXED_RSRC	(REQ_F_FIXED_FILE | REQ_F_FIXED_BUFFER)
+
 struct async_poll {
 	struct io_poll_iocb	poll;
 	struct io_poll_iocb	*double_poll;
@@ -959,7 +964,7 @@ struct io_op_def {
 		.unbound_nonreg_file	= 1,
 	},
 	[IORING_OP_BUFFERS_UPDATE] = {
-		.needs_mm		= 1,
+		.work_flags		= IO_WQ_WORK_MM,
 	},
 };
 
@@ -3097,6 +3102,46 @@ static ssize_t io_iov_buffer_select(struct io_kiocb *req, struct iovec *iov,
 	return __io_iov_buffer_select(req, iov, needs_lock);
 }
 
+static ssize_t io_import_iovec_fixed(int rw, struct io_kiocb *req, void *buf,
+				     unsigned segs, unsigned fast_segs,
+				     struct iovec **iovec,
+				     struct iov_iter *iter)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+	struct io_mapped_ubuf *imu;
+	struct iovec *iov;
+	u16 index, buf_index;
+	ssize_t ret;
+	unsigned long seg;
+
+	if (unlikely(!ctx->buf_data))
+		return -EFAULT;
+
+	ret = import_iovec(rw, buf, segs, fast_segs, iovec, iter);
+	if (ret < 0)
+		return ret;
+
+	iov = (struct iovec *)iter->iov;
+
+	for (seg = 0; seg < iter->nr_segs; seg++) {
+		buf_index = *(u16 *)(&iov[seg].iov_base);
+		if (unlikely(buf_index < 0 || buf_index >= ctx->nr_user_bufs))
+			return -EFAULT;
+
+		index = array_index_nospec(buf_index, ctx->nr_user_bufs);
+		imu = io_buf_from_index(ctx, index);
+		if (!imu->ubuf || !imu->len)
+			return -EFAULT;
+		if (iov[seg].iov_len > imu->len)
+			return -EFAULT;
+
+		iov[seg].iov_base = (void *)imu->ubuf;
+		ret += iov[seg].iov_len;
+	}
+
+	return ret;
+}
+
 static ssize_t __io_import_iovec(int rw, struct io_kiocb *req,
 				 struct iovec **iovec, struct iov_iter *iter,
 				 bool needs_lock)
@@ -3107,6 +3152,12 @@ static ssize_t __io_import_iovec(int rw, struct io_kiocb *req,
 	u8 opcode;
 
 	opcode = req->opcode;
+
+	if ((opcode == IORING_OP_READV || opcode == IORING_OP_WRITEV) &&
+	    req->flags & REQ_F_FIXED_BUFFER)
+		return (io_import_iovec_fixed(rw, req, buf, sqe_len,
+					      UIO_FASTIOV, iovec, iter));
+
 	if (opcode == IORING_OP_READ_FIXED || opcode == IORING_OP_WRITE_FIXED) {
 		*iovec = NULL;
 		return io_import_fixed(req, rw, iter);
@@ -5494,7 +5545,7 @@ static int io_timeout_remove_prep(struct io_kiocb *req,
 {
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
-	if (unlikely(req->flags & (REQ_F_FIXED_FILE | REQ_F_BUFFER_SELECT)))
+	if (unlikely(req->flags & (REQ_F_FIXED_RSRC | REQ_F_BUFFER_SELECT)))
 		return -EINVAL;
 	if (sqe->ioprio || sqe->buf_index || sqe->len || sqe->timeout_flags)
 		return -EINVAL;
@@ -5669,7 +5720,7 @@ static int io_async_cancel_prep(struct io_kiocb *req,
 {
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
-	if (unlikely(req->flags & (REQ_F_FIXED_FILE | REQ_F_BUFFER_SELECT)))
+	if (unlikely(req->flags & (REQ_F_FIXED_RSRC | REQ_F_BUFFER_SELECT)))
 		return -EINVAL;
 	if (sqe->ioprio || sqe->off || sqe->len || sqe->cancel_flags)
 		return -EINVAL;
@@ -5691,7 +5742,7 @@ static int io_rsrc_update_prep(struct io_kiocb *req,
 {
 	if (unlikely(req->ctx->flags & IORING_SETUP_SQPOLL))
 		return -EINVAL;
-	if (unlikely(req->flags & (REQ_F_FIXED_FILE | REQ_F_BUFFER_SELECT)))
+	if (unlikely(req->flags & (REQ_F_FIXED_RSRC | REQ_F_BUFFER_SELECT)))
 		return -EINVAL;
 	if (sqe->ioprio || sqe->rw_flags)
 		return -EINVAL;
@@ -6546,7 +6597,7 @@ static inline bool io_check_restriction(struct io_ring_ctx *ctx,
 
 #define SQE_VALID_FLAGS	(IOSQE_FIXED_FILE|IOSQE_IO_DRAIN|IOSQE_IO_LINK|	\
 				IOSQE_IO_HARDLINK | IOSQE_ASYNC | \
-				IOSQE_BUFFER_SELECT)
+				IOSQE_BUFFER_SELECT | IOSQE_FIXED_BUFFER)
 
 static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 		       const struct io_uring_sqe *sqe,
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 85de6b8..8f92555 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -68,6 +68,7 @@ enum {
 	IOSQE_IO_HARDLINK_BIT,
 	IOSQE_ASYNC_BIT,
 	IOSQE_BUFFER_SELECT_BIT,
+	IOSQE_FIXED_BUFFER_BIT,
 };
 
 /*
@@ -85,6 +86,8 @@ enum {
 #define IOSQE_ASYNC		(1U << IOSQE_ASYNC_BIT)
 /* select buffer from sqe->buf_group */
 #define IOSQE_BUFFER_SELECT	(1U << IOSQE_BUFFER_SELECT_BIT)
+/* use fixed buffer set */
+#define IOSQE_FIXED_BUFFER	(1U << IOSQE_FIXED_BUFFER_BIT)
 
 /*
  * io_uring_setup() flags
-- 
1.8.3.1

