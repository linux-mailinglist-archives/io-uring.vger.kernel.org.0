Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 699282B124F
	for <lists+io-uring@lfdr.de>; Fri, 13 Nov 2020 00:01:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726290AbgKLXBN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 Nov 2020 18:01:13 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:53208 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726231AbgKLXBM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 Nov 2020 18:01:12 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0ACMtUYc078864;
        Thu, 12 Nov 2020 23:01:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=f/9X8HcD1lvVUk1y+66DQrlm/CCzPJYPFqhp6pb7e4o=;
 b=k4lYleZAm+uM7kvoXKayR5bol/bslxAa/voapCJlrbJ4BPYjSYBxLB2My5hs07wrc4P/
 nfiwJLF5Ep5bSQXqYk0XI57L0CKrWzcuFe3RaxpsbpVuMZE6mPvrkM0YmteU+jQB23b6
 lExaGMKrx+/HmZDc3vLfDgrr7nsQ9hprRsmNgXpfEfIkUcxnamSYNRrO1MuaVHHkpIcx
 zHw0M9RNizcq5kn+PNjff61sWI7uuDE//OuopOU5fTTFwEuhcU5u928C9USb17mnstbr
 0svloksNQBqzQgnGqZpI17DUM5RJN54ujne4cbmeVO8QCT76OwDLdpQpHWIWU9OXGS9T +A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 34p72ex9cx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 12 Nov 2020 23:01:10 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0ACMpLXS120259;
        Thu, 12 Nov 2020 23:01:09 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 34p55s1e3m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Nov 2020 23:01:09 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0ACN187c011925;
        Thu, 12 Nov 2020 23:01:08 GMT
Received: from ca-ldom147.us.oracle.com (/10.129.68.131)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 12 Nov 2020 15:01:08 -0800
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk
Cc:     io-uring@vger.kernel.org
Subject: [PATCH 5/8] io_uring: generalize files_update functionlity to rsrc_update
Date:   Thu, 12 Nov 2020 15:00:39 -0800
Message-Id: <1605222042-44558-6-git-send-email-bijan.mottahedeh@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1605222042-44558-1-git-send-email-bijan.mottahedeh@oracle.com>
References: <1605222042-44558-1-git-send-email-bijan.mottahedeh@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9803 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 phishscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 bulkscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011120129
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9803 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 suspectscore=1 lowpriorityscore=0 adultscore=0 phishscore=0
 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011120129
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
index de0019e..71f6d5c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -515,7 +515,7 @@ struct io_open {
 	unsigned long			nofile;
 };
 
-struct io_files_update {
+struct io_rsrc_update {
 	struct file			*file;
 	u64				arg;
 	u32				nr_args;
@@ -709,7 +709,7 @@ struct io_kiocb {
 		struct io_sr_msg	sr_msg;
 		struct io_open		open;
 		struct io_close		close;
-		struct io_files_update	files_update;
+		struct io_rsrc_update	rsrc_update;
 		struct io_fadvise	fadvise;
 		struct io_madvise	madvise;
 		struct io_epoll		epoll;
@@ -1023,7 +1023,7 @@ static void __io_complete_rw(struct io_kiocb *req, long res, long res2,
 static void __io_queue_linked_timeout(struct io_kiocb *req);
 static void io_queue_linked_timeout(struct io_kiocb *req);
 static int __io_sqe_files_update(struct io_ring_ctx *ctx,
-				 struct io_uring_files_update *ip,
+				 struct io_uring_rsrc_update *ip,
 				 unsigned nr_args);
 static void __io_clean_op(struct io_kiocb *req);
 static struct file *io_file_get(struct io_submit_state *state,
@@ -5878,8 +5878,8 @@ static int io_async_cancel(struct io_kiocb *req)
 	return 0;
 }
 
-static int io_files_update_prep(struct io_kiocb *req,
-				const struct io_uring_sqe *sqe)
+static int io_rsrc_update_prep(struct io_kiocb *req,
+			       const struct io_uring_sqe *sqe)
 {
 	if (unlikely(req->ctx->flags & IORING_SETUP_SQPOLL))
 		return -EINVAL;
@@ -5888,29 +5888,32 @@ static int io_files_update_prep(struct io_kiocb *req,
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
@@ -5919,6 +5922,23 @@ static int io_files_update(struct io_kiocb *req, bool force_nonblock,
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
@@ -7619,8 +7639,7 @@ static struct fixed_rsrc_ref_node *alloc_fixed_file_ref_node(
 
 static void destroy_fixed_file_ref_node(struct fixed_rsrc_ref_node *ref_node)
 {
-	percpu_ref_exit(&ref_node->refs);
-	kfree(ref_node);
+	destroy_fixed_rsrc_ref_node(ref_node);
 }
 
 static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
@@ -7796,7 +7815,7 @@ static inline int io_queue_file_removal(struct fixed_rsrc_data *data,
 }
 
 static int __io_sqe_files_update(struct io_ring_ctx *ctx,
-				 struct io_uring_files_update *up,
+				 struct io_uring_rsrc_update *up,
 				 unsigned nr_args)
 {
 	struct fixed_rsrc_data *data = ctx->file_data;
@@ -7886,7 +7905,7 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 static int io_sqe_files_update(struct io_ring_ctx *ctx, void __user *arg,
 			       unsigned nr_args)
 {
-	struct io_uring_files_update up;
+	struct io_uring_rsrc_update up;
 
 	if (!ctx->file_data)
 		return -ENXIO;
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 6bb8229..87f0f56 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -290,6 +290,16 @@ struct io_uring_files_update {
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

