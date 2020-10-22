Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 280BA296791
	for <lists+io-uring@lfdr.de>; Fri, 23 Oct 2020 01:14:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S373283AbgJVXOU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 22 Oct 2020 19:14:20 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:59690 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S373209AbgJVXOU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 22 Oct 2020 19:14:20 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09MN9OoA035142;
        Thu, 22 Oct 2020 23:14:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=A/wKtdjCDYJ6vhEuvOwTcYuJB/UzT4FgVyr5B+oZfes=;
 b=goPHYbGKMzC/GIFxWBy1E9GkkRIU6KxrQqU3ucnMAU+14IxmLrnQcFNE96cFygTNhrkA
 EY+AqTKgWpPcR1sfxywA2w/smLj/DLJgY5QF6+7iQDkm8hwXSUsZCHj8NQs1houhLTTq
 hYg0FGhU1R3P4fBZBOU+RSHwIScBwF6yucyJ3e6QjZhd2HxyewqacPqZ4Cjpxb6wRXs9
 NqDpa6wHCT7D6K7DCHOpgpJRLXf7GHAigW9VzaHRW9o0amU3+vzQzCwnvT8yIXiehKSu
 JSqHhkq7/ILcKsoxMay8TcPGUToy1pJfCFTPZecLihGxz53kOgi/ZEPgJlNGKJw7IlZp pg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 347p4b8nay-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 22 Oct 2020 23:14:18 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09MN54bZ147309;
        Thu, 22 Oct 2020 23:14:17 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 348aj0c1ky-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Oct 2020 23:14:17 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09MNEG10023347;
        Thu, 22 Oct 2020 23:14:16 GMT
Received: from ca-ldom147.us.oracle.com (/10.129.68.131)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 22 Oct 2020 16:14:16 -0700
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk, io-uring@vger.kernel.org
Subject: [RFC 6/8] io_uring: support buffer registration updates
Date:   Thu, 22 Oct 2020 16:14:01 -0700
Message-Id: <1603408443-51303-7-git-send-email-bijan.mottahedeh@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1603408443-51303-1-git-send-email-bijan.mottahedeh@oracle.com>
References: <1603408443-51303-1-git-send-email-bijan.mottahedeh@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9782 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010220148
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9782 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 priorityscore=1501
 clxscore=1015 malwarescore=0 mlxscore=0 bulkscore=0 lowpriorityscore=0
 phishscore=0 adultscore=0 mlxlogscore=999 impostorscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010220148
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Introduce IORING_REGISTER_BUFFERS_UPDATE and IORING_OP_BUFFERS_UPDATE,
consistent with file registration update.

Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
---
 fs/io_uring.c                 | 139 +++++++++++++++++++++++++++++++++++++++++-
 include/uapi/linux/io_uring.h |   8 +--
 2 files changed, 140 insertions(+), 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f8fcf00..d69d642 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -958,6 +958,9 @@ struct io_op_def {
 		.hash_reg_file		= 1,
 		.unbound_nonreg_file	= 1,
 	},
+	[IORING_OP_BUFFERS_UPDATE] = {
+		.needs_mm		= 1,
+	},
 };
 
 enum io_mem_account {
@@ -977,6 +980,9 @@ static void __io_complete_rw(struct io_kiocb *req, long res, long res2,
 static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 				 struct io_uring_rsrc_update *ip,
 				 unsigned nr_args);
+static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
+				   struct io_uring_rsrc_update *up,
+				   unsigned nr_args);
 static void __io_clean_op(struct io_kiocb *req);
 static struct file *io_file_get(struct io_submit_state *state,
 				struct io_kiocb *req, int fd, bool fixed);
@@ -5741,6 +5747,19 @@ static void destroy_fixed_rsrc_ref_node(struct fixed_rsrc_ref_node *ref_node)
 	percpu_ref_exit(&ref_node->refs);
 	kfree(ref_node);
 }
+
+static int io_buffers_update_prep(struct io_kiocb *req,
+				  const struct io_uring_sqe *sqe)
+{
+	return io_rsrc_update_prep(req, sqe);
+}
+
+static int io_buffers_update(struct io_kiocb *req, bool force_nonblock,
+			     struct io_comp_state *cs)
+{
+	return io_rsrc_update(req, force_nonblock, cs, __io_sqe_buffers_update);
+}
+
 static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	switch (req->opcode) {
@@ -5806,11 +5825,13 @@ static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return io_remove_buffers_prep(req, sqe);
 	case IORING_OP_TEE:
 		return io_tee_prep(req, sqe);
+	case IORING_OP_BUFFERS_UPDATE:
+		return io_buffers_update_prep(req, sqe);
 	}
 
 	printk_once(KERN_WARNING "io_uring: unhandled opcode %d\n",
 			req->opcode);
-	return-EINVAL;
+	return -EINVAL;
 }
 
 static int io_req_defer_prep(struct io_kiocb *req,
@@ -6049,6 +6070,9 @@ static int io_issue_sqe(struct io_kiocb *req, bool force_nonblock,
 	case IORING_OP_TEE:
 		ret = io_tee(req, force_nonblock);
 		break;
+	case IORING_OP_BUFFERS_UPDATE:
+		ret = io_buffers_update(req, force_nonblock, cs);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
@@ -8026,6 +8050,7 @@ static void io_buffer_unmap(struct io_ring_ctx *ctx, struct io_mapped_ubuf *imu)
 	if (imu->acct_pages)
 		io_unaccount_mem(ctx, imu->nr_bvecs, ACCT_PINNED);
 	kvfree(imu->bvec);
+	imu->bvec = NULL;
 	imu->nr_bvecs = 0;
 }
 
@@ -8243,6 +8268,7 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
 		if (pret > 0)
 			unpin_user_pages(pages, pret);
 		kvfree(imu->bvec);
+		imu->bvec = NULL;
 		goto done;
 	}
 
@@ -8404,6 +8430,8 @@ static void io_buf_data_ref_zero(struct percpu_ref *ref)
 static void io_ring_buf_put(struct io_ring_ctx *ctx, struct io_rsrc_put *prsrc)
 {
 	io_buffer_unmap(ctx, prsrc->buf);
+	kvfree(prsrc->buf);
+	prsrc->buf = NULL;
 }
 
 static struct fixed_rsrc_ref_node *alloc_fixed_buf_ref_node(
@@ -8486,6 +8514,111 @@ static int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
 	return 0;
 }
 
+static inline int io_queue_buffer_removal(struct fixed_rsrc_data *data,
+					  struct io_mapped_ubuf *imu)
+{
+	return io_queue_rsrc_removal(data, (void *)imu);
+}
+
+static void destroy_fixed_buf_ref_node(struct fixed_rsrc_ref_node *ref_node)
+{
+	destroy_fixed_rsrc_ref_node(ref_node);
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
+	if (needs_switch) {
+		percpu_ref_kill(&data->node->refs);
+		spin_lock(&data->lock);
+		list_add(&ref_node->node, &data->ref_list);
+		data->node = ref_node;
+		spin_unlock(&data->lock);
+		percpu_ref_get(&ctx->buf_data->refs);
+	} else
+		destroy_fixed_buf_ref_node(ref_node);
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
@@ -9799,6 +9932,7 @@ static bool io_register_op_must_quiesce(int op)
 	switch (op) {
 	case IORING_UNREGISTER_FILES:
 	case IORING_REGISTER_FILES_UPDATE:
+	case IORING_REGISTER_BUFFERS_UPDATE:
 	case IORING_REGISTER_PROBE:
 	case IORING_REGISTER_PERSONALITY:
 	case IORING_UNREGISTER_PERSONALITY:
@@ -9874,6 +10008,9 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
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
index 16344da..85de6b8 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -132,6 +132,7 @@ enum {
 	IORING_OP_PROVIDE_BUFFERS,
 	IORING_OP_REMOVE_BUFFERS,
 	IORING_OP_TEE,
+	IORING_OP_BUFFERS_UPDATE,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
@@ -271,17 +272,12 @@ enum {
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

