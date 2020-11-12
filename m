Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33B072B1253
	for <lists+io-uring@lfdr.de>; Fri, 13 Nov 2020 00:01:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725929AbgKLXBO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 Nov 2020 18:01:14 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:42558 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726133AbgKLXBN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 Nov 2020 18:01:13 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0ACMs6gk053577;
        Thu, 12 Nov 2020 23:01:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=vzztL2tMUvL1SQyZ9WC3+EeQptdO3ICJNCJ15IBNJCU=;
 b=hqNgeMB8mTkH6Pur5gIeq/cF3TDV7NjRbhzinFYJXuWLFXydPZDER7wD4wKXt/I7cE5L
 hAGi4DEeOH/ChJrIWL00p0LMuCEu9saoXJe/X7gF4fU/BRj4R7H/OYIu+Fzt3Hez+JUC
 KKflCCD8y378WPU7sufJtwGg10fgjQy3+FZzScZ76Ngt7GB8lq5pVrvmkTSG11qfRvpL
 4HG7CGDf4GC6bigg5+fDMIbqsFwfHJeAsAB28U92pEQ7lN+oMZzDiWwBk82SIno1kBI9
 t3ctiGxaNtH4+87V1sDTtQAZKvrZUdb4d+2zBkyGLqZ9pgzXb5bppQCULMHbUjsu+j66 Vg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 34nh3b8a8x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 12 Nov 2020 23:01:11 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0ACMpCKC047953;
        Thu, 12 Nov 2020 23:01:10 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 34rt56tv3m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Nov 2020 23:01:10 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0ACN19Ms015714;
        Thu, 12 Nov 2020 23:01:09 GMT
Received: from ca-ldom147.us.oracle.com (/10.129.68.131)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 12 Nov 2020 15:01:09 -0800
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk
Cc:     io-uring@vger.kernel.org
Subject: [PATCH 7/8] io_uring: support readv/writev with fixed buffers
Date:   Thu, 12 Nov 2020 15:00:41 -0800
Message-Id: <1605222042-44558-8-git-send-email-bijan.mottahedeh@oracle.com>
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

Support readv/writev with fixed buffers, and introduce IOSQE_FIXED_BUFFER,
consistent with fixed files.

Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
---
 fs/io_uring.c                 | 59 ++++++++++++++++++++++++++++++++++++++++---
 include/uapi/linux/io_uring.h |  3 +++
 2 files changed, 58 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 6020fd2..12c4144 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -625,6 +625,7 @@ enum {
 	REQ_F_HARDLINK_BIT	= IOSQE_IO_HARDLINK_BIT,
 	REQ_F_FORCE_ASYNC_BIT	= IOSQE_ASYNC_BIT,
 	REQ_F_BUFFER_SELECT_BIT	= IOSQE_BUFFER_SELECT_BIT,
+	REQ_F_FIXED_BUFFER_BIT	= IOSQE_FIXED_BUFFER_BIT,
 
 	REQ_F_FAIL_LINK_BIT,
 	REQ_F_INFLIGHT_BIT,
@@ -681,8 +682,12 @@ enum {
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
@@ -3191,6 +3196,46 @@ static ssize_t io_iov_buffer_select(struct io_kiocb *req, struct iovec *iov,
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
 static ssize_t io_import_iovec(int rw, struct io_kiocb *req,
 				 struct iovec **iovec, struct iov_iter *iter,
 				 bool needs_lock)
@@ -3201,6 +3246,12 @@ static ssize_t io_import_iovec(int rw, struct io_kiocb *req,
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
@@ -5692,7 +5743,7 @@ static int io_timeout_remove_prep(struct io_kiocb *req,
 {
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
-	if (unlikely(req->flags & (REQ_F_FIXED_FILE | REQ_F_BUFFER_SELECT)))
+	if (unlikely(req->flags & (REQ_F_FIXED_RSRC | REQ_F_BUFFER_SELECT)))
 		return -EINVAL;
 	if (sqe->ioprio || sqe->buf_index || sqe->len || sqe->timeout_flags)
 		return -EINVAL;
@@ -5867,7 +5918,7 @@ static int io_async_cancel_prep(struct io_kiocb *req,
 {
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
-	if (unlikely(req->flags & (REQ_F_FIXED_FILE | REQ_F_BUFFER_SELECT)))
+	if (unlikely(req->flags & (REQ_F_FIXED_RSRC | REQ_F_BUFFER_SELECT)))
 		return -EINVAL;
 	if (sqe->ioprio || sqe->off || sqe->len || sqe->cancel_flags)
 		return -EINVAL;
@@ -5889,7 +5940,7 @@ static int io_rsrc_update_prep(struct io_kiocb *req,
 {
 	if (unlikely(req->ctx->flags & IORING_SETUP_SQPOLL))
 		return -EINVAL;
-	if (unlikely(req->flags & (REQ_F_FIXED_FILE | REQ_F_BUFFER_SELECT)))
+	if (unlikely(req->flags & (REQ_F_FIXED_RSRC | REQ_F_BUFFER_SELECT)))
 		return -EINVAL;
 	if (sqe->ioprio || sqe->rw_flags)
 		return -EINVAL;
@@ -6740,7 +6791,7 @@ static inline bool io_check_restriction(struct io_ring_ctx *ctx,
 
 #define SQE_VALID_FLAGS	(IOSQE_FIXED_FILE|IOSQE_IO_DRAIN|IOSQE_IO_LINK|	\
 				IOSQE_IO_HARDLINK | IOSQE_ASYNC | \
-				IOSQE_BUFFER_SELECT)
+				IOSQE_BUFFER_SELECT | IOSQE_FIXED_BUFFER)
 
 static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 		       const struct io_uring_sqe *sqe,
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 17682b5..41da59c 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -70,6 +70,7 @@ enum {
 	IOSQE_IO_HARDLINK_BIT,
 	IOSQE_ASYNC_BIT,
 	IOSQE_BUFFER_SELECT_BIT,
+	IOSQE_FIXED_BUFFER_BIT,
 };
 
 /*
@@ -87,6 +88,8 @@ enum {
 #define IOSQE_ASYNC		(1U << IOSQE_ASYNC_BIT)
 /* select buffer from sqe->buf_group */
 #define IOSQE_BUFFER_SELECT	(1U << IOSQE_BUFFER_SELECT_BIT)
+/* use fixed buffer set */
+#define IOSQE_FIXED_BUFFER	(1U << IOSQE_FIXED_BUFFER_BIT)
 
 /*
  * io_uring_setup() flags
-- 
1.8.3.1

