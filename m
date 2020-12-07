Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78A3F2D1D23
	for <lists+io-uring@lfdr.de>; Mon,  7 Dec 2020 23:20:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728067AbgLGWQ4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 7 Dec 2020 17:16:56 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:58762 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727824AbgLGWQv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 7 Dec 2020 17:16:51 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B7M9GqL111917;
        Mon, 7 Dec 2020 22:16:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=0svNSEm2U5jVom2WL+v6/mqvVph8Q52Yu/mcx7/ELb4=;
 b=lgfqeRx/6X8Hgt8JGOP/fENlVemTX+8hhV19WFrxGQEYcpwNvu2YYkmsFYl417Z4PEOs
 kZL+8iW+Aq9wBsv3sH2XPkYBbXoIN7IDMDms8ubzk07dt9gNf7YmhU/Vy+z4OyZyuFKc
 /bT8U8X1fPLcbXsDIHVSFl02Bf8K5Domc4Qy950ytRV1WZFvUXGUI6kZBkqqtuyG14PK
 N5f9W3SkRdWvAvZ/D2UDHQuq6If7iDUyT0JlHS64ueJ9YvvPyrlqx1LoI1/3w4J6Hqfa
 R5FOLRO/1EZKjhFxPjFI4tjUPnFLudJ5dzi/x0B8RAgIHcZy+CbS1txBE4B8nWaGOvFP 7A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 357yqbr17c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 07 Dec 2020 22:16:07 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B7MAVi0064038;
        Mon, 7 Dec 2020 22:16:07 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 358m3wxb9x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Dec 2020 22:16:07 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B7MG6gO017227;
        Mon, 7 Dec 2020 22:16:06 GMT
Received: from ca-ldom147.us.oracle.com (/10.129.68.131)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 07 Dec 2020 14:16:06 -0800
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk, asml.silence@gmail.com, io-uring@vger.kernel.org
Subject: [PATCH v2 10/13] io_uring: generalize files_update functionlity to rsrc_update
Date:   Mon,  7 Dec 2020 14:15:49 -0800
Message-Id: <1607379352-68109-11-git-send-email-bijan.mottahedeh@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1607379352-68109-1-git-send-email-bijan.mottahedeh@oracle.com>
References: <1607379352-68109-1-git-send-email-bijan.mottahedeh@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9828 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 adultscore=0
 bulkscore=0 phishscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012070145
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9828 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 clxscore=1015 malwarescore=0 bulkscore=0 phishscore=0 adultscore=0
 spamscore=0 priorityscore=1501 mlxscore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012070145
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Generalize files_update functionality to rsrc_update in order to leverage
it for buffers updates.

Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
---
 fs/io_uring.c                 | 45 ++++++++++++++++++++++++++-----------------
 include/uapi/linux/io_uring.h | 10 ++++++++++
 2 files changed, 37 insertions(+), 18 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 384ff3c..1108682 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -517,7 +517,7 @@ struct io_open {
 	unsigned long			nofile;
 };
 
-struct io_files_update {
+struct io_rsrc_update {
 	struct file			*file;
 	u64				arg;
 	u32				nr_args;
@@ -711,7 +711,7 @@ struct io_kiocb {
 		struct io_sr_msg	sr_msg;
 		struct io_open		open;
 		struct io_close		close;
-		struct io_files_update	files_update;
+		struct io_rsrc_update	rsrc_update;
 		struct io_fadvise	fadvise;
 		struct io_madvise	madvise;
 		struct io_epoll		epoll;
@@ -1026,7 +1026,7 @@ static void __io_complete_rw(struct io_kiocb *req, long res, long res2,
 static void __io_queue_linked_timeout(struct io_kiocb *req);
 static void io_queue_linked_timeout(struct io_kiocb *req);
 static int __io_sqe_files_update(struct io_ring_ctx *ctx,
-				 struct io_uring_files_update *ip,
+				 struct io_uring_rsrc_update *ip,
 				 unsigned nr_args);
 static void __io_clean_op(struct io_kiocb *req);
 static struct file *io_file_get(struct io_submit_state *state,
@@ -5962,8 +5962,8 @@ static int io_async_cancel(struct io_kiocb *req)
 	return 0;
 }
 
-static int io_files_update_prep(struct io_kiocb *req,
-				const struct io_uring_sqe *sqe)
+static int io_rsrc_update_prep(struct io_kiocb *req,
+			       const struct io_uring_sqe *sqe)
 {
 	if (unlikely(req->ctx->flags & IORING_SETUP_SQPOLL))
 		return -EINVAL;
@@ -5972,29 +5972,32 @@ static int io_files_update_prep(struct io_kiocb *req,
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
@@ -6003,6 +6006,12 @@ static int io_files_update(struct io_kiocb *req, bool force_nonblock,
 	return 0;
 }
 
+static int io_files_update(struct io_kiocb *req, bool force_nonblock,
+			   struct io_comp_state *cs)
+{
+	return io_rsrc_update(req, force_nonblock, cs, __io_sqe_files_update);
+}
+
 static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	switch (req->opcode) {
@@ -6049,7 +6058,7 @@ static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	case IORING_OP_CLOSE:
 		return io_close_prep(req, sqe);
 	case IORING_OP_FILES_UPDATE:
-		return io_files_update_prep(req, sqe);
+		return io_rsrc_update_prep(req, sqe);
 	case IORING_OP_STATX:
 		return io_statx_prep(req, sqe);
 	case IORING_OP_FADVISE:
@@ -7929,7 +7938,7 @@ static void switch_fixed_rsrc_ref_node(struct fixed_rsrc_ref_node *ref_node,
 }
 
 static int __io_sqe_files_update(struct io_ring_ctx *ctx,
-				 struct io_uring_files_update *up,
+				 struct io_uring_rsrc_update *up,
 				 unsigned nr_args)
 {
 	struct fixed_rsrc_data *data = ctx->file_data;
@@ -8014,7 +8023,7 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 static int io_sqe_files_update(struct io_ring_ctx *ctx, void __user *arg,
 			       unsigned nr_args)
 {
-	struct io_uring_files_update up;
+	struct io_uring_rsrc_update up;
 
 	if (!ctx->file_data)
 		return -ENXIO;
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index d31a2a1..ba5deff 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -291,6 +291,16 @@ struct io_uring_files_update {
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

