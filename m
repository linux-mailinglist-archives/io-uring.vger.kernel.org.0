Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8B9F2D1D1F
	for <lists+io-uring@lfdr.de>; Mon,  7 Dec 2020 23:20:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728024AbgLGWQz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 7 Dec 2020 17:16:55 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:38610 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728071AbgLGWQw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 7 Dec 2020 17:16:52 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B7MAEfZ132576;
        Mon, 7 Dec 2020 22:16:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=FZP6b1JLiXrv625Da/zYq9KMYrmZbvLvb5JbfIkd0i4=;
 b=judJRrDc/CsOjUS0YgZzAqSObV7H99hdMSUowjPMtWE0VJbve1q+Xj6emX66JvRXyosa
 DNG1H0g1q6jElBkLnGhXznjNRqEujqygX+9uiko4CxTwee4loh0wRbEXQ1C4C6keY+Mc
 yhq6cmG433o7jlmSct0ztW40uaFYxsefIBeWIz5L5AroCpgyce7OQAdo3TSN6nujRl2R
 CIQODlLfCOhRgXi8iwdLGhavA494jTfKNTgBuFxM60pMBZ6Dmq4sNxS9FAONYbSGBFKx
 V4oh15iZzppQ/WBy0I0zEJx18cxt3QFu4yQw/HyvzwAuNnKozwaJdiovEc3b7/qwg5mz 6A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 3581mqqv5y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 07 Dec 2020 22:16:09 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B7MATWQ063891;
        Mon, 7 Dec 2020 22:16:08 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 358m3wxba9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Dec 2020 22:16:08 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B7MG7M3004843;
        Mon, 7 Dec 2020 22:16:07 GMT
Received: from ca-ldom147.us.oracle.com (/10.129.68.131)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 07 Dec 2020 14:16:06 -0800
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk, asml.silence@gmail.com, io-uring@vger.kernel.org
Subject: [PATCH v2 11/13] io_uring: support buffer registration updates
Date:   Mon,  7 Dec 2020 14:15:50 -0800
Message-Id: <1607379352-68109-12-git-send-email-bijan.mottahedeh@oracle.com>
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
 clxscore=1015 malwarescore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 phishscore=0 spamscore=0 impostorscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012070145
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Introduce IORING_REGISTER_BUFFERS_UPDATE and IORING_OP_BUFFERS_UPDATE,
consistent with file registration update.

Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
---
 fs/io_uring.c                 | 122 +++++++++++++++++++++++++++++++++++++++++-
 include/uapi/linux/io_uring.h |   8 +--
 2 files changed, 123 insertions(+), 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 1108682..b7a1f65 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1009,6 +1009,9 @@ struct io_op_def {
 		.work_flags		= IO_WQ_WORK_MM | IO_WQ_WORK_FILES |
 						IO_WQ_WORK_FS | IO_WQ_WORK_BLKCG,
 	},
+	[IORING_OP_BUFFERS_UPDATE] = {
+		.work_flags		= IO_WQ_WORK_MM,
+	},
 };
 
 enum io_mem_account {
@@ -1028,6 +1031,9 @@ static void __io_complete_rw(struct io_kiocb *req, long res, long res2,
 static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 				 struct io_uring_rsrc_update *ip,
 				 unsigned nr_args);
+static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
+				   struct io_uring_rsrc_update *up,
+				   unsigned nr_args);
 static void __io_clean_op(struct io_kiocb *req);
 static struct file *io_file_get(struct io_submit_state *state,
 				struct io_kiocb *req, int fd, bool fixed);
@@ -6012,6 +6018,12 @@ static int io_files_update(struct io_kiocb *req, bool force_nonblock,
 	return io_rsrc_update(req, force_nonblock, cs, __io_sqe_files_update);
 }
 
+static int io_buffers_update(struct io_kiocb *req, bool force_nonblock,
+			     struct io_comp_state *cs)
+{
+	return io_rsrc_update(req, force_nonblock, cs, __io_sqe_buffers_update);
+}
+
 static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	switch (req->opcode) {
@@ -6083,11 +6095,13 @@ static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return io_renameat_prep(req, sqe);
 	case IORING_OP_UNLINKAT:
 		return io_unlinkat_prep(req, sqe);
+	case IORING_OP_BUFFERS_UPDATE:
+		return io_rsrc_update_prep(req, sqe);
 	}
 
 	printk_once(KERN_WARNING "io_uring: unhandled opcode %d\n",
 			req->opcode);
-	return-EINVAL;
+	return -EINVAL;
 }
 
 static int io_req_defer_prep(struct io_kiocb *req,
@@ -6342,6 +6356,9 @@ static int io_issue_sqe(struct io_kiocb *req, bool force_nonblock,
 	case IORING_OP_UNLINKAT:
 		ret = io_unlinkat(req, force_nonblock);
 		break;
+	case IORING_OP_BUFFERS_UPDATE:
+		ret = io_buffers_update(req, force_nonblock, cs);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
@@ -8342,6 +8359,7 @@ static void io_buffer_unmap(struct io_ring_ctx *ctx, struct io_mapped_ubuf *imu)
 	if (imu->acct_pages)
 		io_unaccount_mem(ctx, imu->nr_bvecs, ACCT_PINNED);
 	kvfree(imu->bvec);
+	imu->bvec = NULL;
 	imu->nr_bvecs = 0;
 }
 
@@ -8545,6 +8563,7 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
 		if (pret > 0)
 			unpin_user_pages(pages, pret);
 		kvfree(imu->bvec);
+		imu->bvec = NULL;
 		goto done;
 	}
 
@@ -8674,6 +8693,8 @@ static int io_buffer_validate(struct iovec *iov)
 static void io_ring_buf_put(struct io_ring_ctx *ctx, struct io_rsrc_put *prsrc)
 {
 	io_buffer_unmap(ctx, prsrc->buf);
+	kvfree(prsrc->buf);
+	prsrc->buf = NULL;
 }
 
 static struct fixed_rsrc_ref_node *alloc_fixed_buf_ref_node(
@@ -8742,6 +8763,101 @@ static int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
 	return 0;
 }
 
+static inline int io_queue_buffer_removal(struct fixed_rsrc_data *data,
+					  struct io_mapped_ubuf *imu)
+{
+	return io_queue_rsrc_removal(data, (void *)imu);
+}
+
+static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
+				   struct io_uring_rsrc_update *up,
+				   unsigned nr_args)
+{
+	struct fixed_rsrc_data *data = ctx->buf_data;
+	struct fixed_rsrc_ref_node *ref_node;
+	struct io_mapped_ubuf *imu;
+	struct iovec iov;
+	struct iovec __user *iovs;
+	struct page *last_hpage = NULL;
+	__u32 done;
+	int i, err;
+	bool needs_switch = false;
+
+	if (check_add_overflow(up->offset, nr_args, &done))
+		return -EOVERFLOW;
+	if (done > ctx->nr_user_bufs)
+		return -EINVAL;
+
+	ref_node = alloc_fixed_buf_ref_node(ctx);
+	if (IS_ERR(ref_node))
+		return PTR_ERR(ref_node);
+
+	done = 0;
+	iovs = u64_to_user_ptr(up->iovs);
+	while (nr_args) {
+		struct fixed_rsrc_table *table;
+		unsigned index;
+
+		err = 0;
+		if (copy_from_user(&iov, &iovs[done], sizeof(iov))) {
+			err = -EFAULT;
+			break;
+		}
+		i = array_index_nospec(up->offset, ctx->nr_user_bufs);
+		table = &ctx->buf_data->table[i >> IORING_BUF_TABLE_SHIFT];
+		index = i & IORING_BUF_TABLE_MASK;
+		imu = &table->bufs[index];
+		if (table->bufs[index].ubuf) {
+			struct io_mapped_ubuf *dup;
+			dup = kmemdup(imu, sizeof(*imu), GFP_KERNEL);
+			if (!dup) {
+				err = -ENOMEM;
+				break;
+			}
+			err = io_queue_buffer_removal(data, dup);
+			if (err)
+				break;
+			memset(imu, 0, sizeof(*imu));
+			needs_switch = true;
+		}
+		if (!io_buffer_validate(&iov)) {
+			err = io_sqe_buffer_register(ctx, &iov, imu,
+						     &last_hpage);
+			if (err) {
+				memset(imu, 0, sizeof(*imu));
+				break;
+			}
+		}
+		nr_args--;
+		done++;
+		up->offset++;
+	}
+
+	if (needs_switch)
+		switch_fixed_rsrc_ref_node(ref_node, data, ctx);
+	else
+		destroy_fixed_rsrc_ref_node(ref_node);
+
+	return done ? done : err;
+}
+
+static int io_sqe_buffers_update(struct io_ring_ctx *ctx, void __user *arg,
+				 unsigned nr_args)
+{
+	struct io_uring_rsrc_update up;
+
+	if (!ctx->buf_data)
+		return -ENXIO;
+	if (!nr_args)
+		return -EINVAL;
+	if (copy_from_user(&up, arg, sizeof(up)))
+		return -EFAULT;
+	if (up.resv)
+		return -EINVAL;
+
+	return __io_sqe_buffers_update(ctx, &up, nr_args);
+}
+
 static int io_eventfd_register(struct io_ring_ctx *ctx, void __user *arg)
 {
 	__s32 __user *fds = arg;
@@ -10022,6 +10138,7 @@ static bool io_register_op_must_quiesce(int op)
 	case IORING_UNREGISTER_FILES:
 	case IORING_REGISTER_FILES_UPDATE:
 	case IORING_UNREGISTER_BUFFERS:
+	case IORING_REGISTER_BUFFERS_UPDATE:
 	case IORING_REGISTER_PROBE:
 	case IORING_REGISTER_PERSONALITY:
 	case IORING_UNREGISTER_PERSONALITY:
@@ -10097,6 +10214,9 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 			break;
 		ret = io_sqe_buffers_unregister(ctx);
 		break;
+	case IORING_REGISTER_BUFFERS_UPDATE:
+		ret = io_sqe_buffers_update(ctx, arg, nr_args);
+		break;
 	case IORING_REGISTER_FILES:
 		ret = io_sqe_files_register(ctx, arg, nr_args);
 		break;
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index ba5deff..0d9ac12 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -137,6 +137,7 @@ enum {
 	IORING_OP_SHUTDOWN,
 	IORING_OP_RENAMEAT,
 	IORING_OP_UNLINKAT,
+	IORING_OP_BUFFERS_UPDATE,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
@@ -280,17 +281,12 @@ enum {
 	IORING_UNREGISTER_PERSONALITY		= 10,
 	IORING_REGISTER_RESTRICTIONS		= 11,
 	IORING_REGISTER_ENABLE_RINGS		= 12,
+	IORING_REGISTER_BUFFERS_UPDATE		= 13,
 
 	/* this goes last */
 	IORING_REGISTER_LAST
 };
 
-struct io_uring_files_update {
-	__u32 offset;
-	__u32 resv;
-	__aligned_u64 /* __s32 * */ fds;
-};
-
 struct io_uring_rsrc_update {
 	__u32 offset;
 	__u32 resv;
-- 
1.8.3.1

