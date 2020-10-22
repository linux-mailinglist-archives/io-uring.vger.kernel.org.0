Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28EA2296798
	for <lists+io-uring@lfdr.de>; Fri, 23 Oct 2020 01:16:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S373330AbgJVXQU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 22 Oct 2020 19:16:20 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:42128 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S373332AbgJVXQU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 22 Oct 2020 19:16:20 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09MNEkgb144732;
        Thu, 22 Oct 2020 23:16:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=ZCSD0F+QSVeqjcufzFb2q777dSQPQbpkF9OLVMV6RTo=;
 b=NXR4OH/e3CGleihIZiFPsYAt0TZ/U4PkpCZX0tQ2O7fxKy1m2MjdZ5yKi81Q6hGfZ/IN
 KE4rw2l+JsJUNkPPfHd5yve8Gi3qJE0Tq4YxkTpqPyGbydU480vwgl7KkwIrPJGTC6cv
 v4Wp7uFFJy0ZD6dYXW8oNGocgfb6RR1gp0ND0FIQdwgPRYWGY6YwfpXFT/2xyHIW004c
 jo4SBdHRBfTbWK4XkXMgZcl2btIitUQux3m8+LBx/VmF3jfaF9MvGSQKrhAsD4y9WvZz
 EpvF0W/xaatOmXWqX6qxBdCWMx65haNLwsEZyBTpYWetjlY5Z7Fo11frA+S+bxdA5oBX 6A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 349jrq0ph4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 22 Oct 2020 23:16:18 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09MN545w147370;
        Thu, 22 Oct 2020 23:14:17 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 348aj0c1kx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Oct 2020 23:14:17 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09MNEG7b022654;
        Thu, 22 Oct 2020 23:14:16 GMT
Received: from ca-ldom147.us.oracle.com (/10.129.68.131)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 22 Oct 2020 16:14:16 -0700
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk, io-uring@vger.kernel.org
Subject: [RFC 5/8] io_uring: generalize files_update functionlity to rsrc_update
Date:   Thu, 22 Oct 2020 16:14:00 -0700
Message-Id: <1603408443-51303-6-git-send-email-bijan.mottahedeh@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1603408443-51303-1-git-send-email-bijan.mottahedeh@oracle.com>
References: <1603408443-51303-1-git-send-email-bijan.mottahedeh@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9782 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010220148
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9782 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 lowpriorityscore=0
 priorityscore=1501 impostorscore=0 adultscore=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 spamscore=0 suspectscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010220149
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Generalize files_update functionality to rsrc_update in order to leverage
it for buffers updates.

Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
---
 fs/io_uring.c                 | 57 ++++++++++++++++++++++++++++---------------
 include/uapi/linux/io_uring.h | 10 ++++++++
 2 files changed, 48 insertions(+), 19 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index daf32d3..f8fcf00 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -510,7 +510,7 @@ struct io_open {
 	unsigned long			nofile;
 };
 
-struct io_files_update {
+struct io_rsrc_update {
 	struct file			*file;
 	u64				arg;
 	u32				nr_args;
@@ -685,7 +685,7 @@ struct io_kiocb {
 		struct io_sr_msg	sr_msg;
 		struct io_open		open;
 		struct io_close		close;
-		struct io_files_update	files_update;
+		struct io_rsrc_update	rsrc_update;
 		struct io_fadvise	fadvise;
 		struct io_madvise	madvise;
 		struct io_epoll		epoll;
@@ -975,7 +975,7 @@ static void __io_complete_rw(struct io_kiocb *req, long res, long res2,
 static void __io_queue_linked_timeout(struct io_kiocb *req);
 static void io_queue_linked_timeout(struct io_kiocb *req);
 static int __io_sqe_files_update(struct io_ring_ctx *ctx,
-				 struct io_uring_files_update *ip,
+				 struct io_uring_rsrc_update *ip,
 				 unsigned nr_args);
 static void __io_clean_op(struct io_kiocb *req);
 static struct file *io_file_get(struct io_submit_state *state,
@@ -5680,8 +5680,8 @@ static int io_async_cancel(struct io_kiocb *req)
 	return 0;
 }
 
-static int io_files_update_prep(struct io_kiocb *req,
-				const struct io_uring_sqe *sqe)
+static int io_rsrc_update_prep(struct io_kiocb *req,
+			       const struct io_uring_sqe *sqe)
 {
 	if (unlikely(req->ctx->flags & IORING_SETUP_SQPOLL))
 		return -EINVAL;
@@ -5690,29 +5690,32 @@ static int io_files_update_prep(struct io_kiocb *req,
 	if (sqe->ioprio || sqe->rw_flags)
 		return -EINVAL;
 
-	req->files_update.offset = READ_ONCE(sqe->off);
-	req->files_update.nr_args = READ_ONCE(sqe->len);
-	if (!req->files_update.nr_args)
+	req->rsrc_update.offset = READ_ONCE(sqe->off);
+	req->rsrc_update.nr_args = READ_ONCE(sqe->len);
+	if (!req->rsrc_update.nr_args)
 		return -EINVAL;
-	req->files_update.arg = READ_ONCE(sqe->addr);
+	req->rsrc_update.arg = READ_ONCE(sqe->addr);
 	return 0;
 }
 
-static int io_files_update(struct io_kiocb *req, bool force_nonblock,
-			   struct io_comp_state *cs)
+static int io_rsrc_update(struct io_kiocb *req, bool force_nonblock,
+			  struct io_comp_state *cs,
+			  int (*update)(struct io_ring_ctx *ctx,
+					struct io_uring_rsrc_update *up,
+					unsigned nr_args))
 {
 	struct io_ring_ctx *ctx = req->ctx;
-	struct io_uring_files_update up;
+	struct io_uring_rsrc_update up;
 	int ret;
 
 	if (force_nonblock)
 		return -EAGAIN;
 
-	up.offset = req->files_update.offset;
-	up.fds = req->files_update.arg;
+	up.offset = req->rsrc_update.offset;
+	up.rsrc = req->rsrc_update.arg;
 
 	mutex_lock(&ctx->uring_lock);
-	ret = __io_sqe_files_update(ctx, &up, req->files_update.nr_args);
+	ret = (*update)(ctx, &up, req->rsrc_update.nr_args);
 	mutex_unlock(&ctx->uring_lock);
 
 	if (ret < 0)
@@ -5721,6 +5724,23 @@ static int io_files_update(struct io_kiocb *req, bool force_nonblock,
 	return 0;
 }
 
+static int io_files_update_prep(struct io_kiocb *req,
+				const struct io_uring_sqe *sqe)
+{
+	return io_rsrc_update_prep(req, sqe);
+}
+
+static int io_files_update(struct io_kiocb *req, bool force_nonblock,
+			   struct io_comp_state *cs)
+{
+	return io_rsrc_update(req, force_nonblock, cs, __io_sqe_files_update);
+}
+
+static void destroy_fixed_rsrc_ref_node(struct fixed_rsrc_ref_node *ref_node)
+{
+	percpu_ref_exit(&ref_node->refs);
+	kfree(ref_node);
+}
 static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	switch (req->opcode) {
@@ -7422,8 +7442,7 @@ static struct fixed_rsrc_ref_node *alloc_fixed_file_ref_node(
 
 static void destroy_fixed_file_ref_node(struct fixed_rsrc_ref_node *ref_node)
 {
-	percpu_ref_exit(&ref_node->refs);
-	kfree(ref_node);
+	destroy_fixed_rsrc_ref_node(ref_node);
 }
 
 static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
@@ -7599,7 +7618,7 @@ static inline int io_queue_file_removal(struct fixed_rsrc_data *data,
 }
 
 static int __io_sqe_files_update(struct io_ring_ctx *ctx,
-				 struct io_uring_files_update *up,
+				 struct io_uring_rsrc_update *up,
 				 unsigned nr_args)
 {
 	struct fixed_rsrc_data *data = ctx->file_data;
@@ -7689,7 +7708,7 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 static int io_sqe_files_update(struct io_ring_ctx *ctx, void __user *arg,
 			       unsigned nr_args)
 {
-	struct io_uring_files_update up;
+	struct io_uring_rsrc_update up;
 
 	if (!ctx->file_data)
 		return -ENXIO;
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 98d8e06..16344da 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -282,6 +282,16 @@ struct io_uring_files_update {
 	__aligned_u64 /* __s32 * */ fds;
 };
 
+struct io_uring_rsrc_update {
+	__u32 offset;
+	__u32 resv;
+	union {
+		__aligned_u64 /* __s32 * */ fds;
+		__aligned_u64 /* __s32 * */ iovs;
+		__aligned_u64 /* __s32 * */ rsrc;
+	};
+};
+
 #define IO_URING_OP_SUPPORTED	(1U << 0)
 
 struct io_uring_probe_op {
-- 
1.8.3.1

