Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 855B6296794
	for <lists+io-uring@lfdr.de>; Fri, 23 Oct 2020 01:14:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S373280AbgJVXOW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 22 Oct 2020 19:14:22 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:50542 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S373216AbgJVXOW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 22 Oct 2020 19:14:22 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09MNEJ9K096631;
        Thu, 22 Oct 2020 23:14:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=obsQ40lnz8yMkoUPVtjr6tH34PKqEmFwZDzeQacrjxY=;
 b=mnfr1R+Dz0RtEzpc+jmE76UQ4Jv2Bk0fEMyxOF/MUbcVrqWsi6IndQLxu7Tmr3adDVeH
 rPDxCVgO8yvy0jY1V1sOGx+suBiMArXHezW73Ohnh2W3l3tePjH8DPsl40t9uF/kuLps
 4JDB+GLkEIFvNcPOlIW5lPuV0qn17sK9bSuycu6WOwiuzUsIwXxGmAwd8g05asZsc5Xl
 Gcnuk3XD5ZNSC8Qcria+oAIyVoLVjCttrNcwbmC5mlK3Pu5Fldp/6XA71Gb8dWl54EFu
 CdyO8MvFLVJJj6XOjjQQw2Rkh6vZU4eCT/ENiqYGRFsANvUoq8+hDNDgPB20LShaQZG/ QQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 34ak16rw44-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 22 Oct 2020 23:14:19 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09MN5joj095169;
        Thu, 22 Oct 2020 23:14:18 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 348ah1dcj6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Oct 2020 23:14:18 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09MNEHil028654;
        Thu, 22 Oct 2020 23:14:17 GMT
Received: from ca-ldom147.us.oracle.com (/10.129.68.131)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 22 Oct 2020 16:14:17 -0700
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk, io-uring@vger.kernel.org
Subject: [RFC 8/8] io_uring: support buffer registration sharing
Date:   Thu, 22 Oct 2020 16:14:03 -0700
Message-Id: <1603408443-51303-9-git-send-email-bijan.mottahedeh@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1603408443-51303-1-git-send-email-bijan.mottahedeh@oracle.com>
References: <1603408443-51303-1-git-send-email-bijan.mottahedeh@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9782 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 malwarescore=0 spamscore=0 suspectscore=2 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010220148
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9782 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0
 priorityscore=1501 clxscore=1015 malwarescore=0 mlxscore=0 adultscore=0
 lowpriorityscore=0 impostorscore=0 spamscore=0 mlxlogscore=999
 suspectscore=2 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010220149
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Implement buffer sharing among multiple rings.

A ring shares its (future) buffer registrations at setup time with
IORING_SETUP_SHARE_BUF. A ring attaches to another ring's buffer
registration at setup time with IORING_SETUP_ATTACH_BUF, after
authenticating with the buffer registration owner's fd. Any updates to
the owner's buffer registrations become immediately available to the
attached rings.

Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
---
 fs/io_uring.c                 | 140 +++++++++++++++++++++++++++++++++++-------
 include/uapi/linux/io_uring.h |   2 +
 2 files changed, 119 insertions(+), 23 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index a8d8871..050f18e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8134,6 +8134,12 @@ static void io_buffers_map_free(struct io_ring_ctx *ctx)
 	ctx->nr_user_bufs = 0;
 }
 
+static void io_detach_buf_data(struct io_ring_ctx *ctx)
+{
+	percpu_ref_put(&ctx->buf_data->refs);
+	ctx->buf_data = NULL;
+}
+
 static int io_sqe_buffers_unregister(struct io_ring_ctx *ctx)
 {
 	struct fixed_rsrc_data *data = ctx->buf_data;
@@ -8142,6 +8148,12 @@ static int io_sqe_buffers_unregister(struct io_ring_ctx *ctx)
 	if (!data)
 		return -ENXIO;
 
+	if (ctx->flags & IORING_SETUP_ATTACH_BUF) {
+		io_detach_buf_data(ctx);
+		ctx->nr_user_bufs = 0;
+		return 0;
+	}
+
 	spin_lock(&data->lock);
 	if (!list_empty(&data->ref_list))
 		ref_node = list_first_entry(&data->ref_list,
@@ -8388,46 +8400,67 @@ static int io_alloc_buf_tables(struct fixed_rsrc_data *buf_data,
 	return 1;
 }
 
+static struct fixed_rsrc_data *io_alloc_buf_data(struct io_ring_ctx *ctx)
+{
+	struct fixed_rsrc_data *buf_data;
+
+	buf_data = kzalloc(sizeof(*buf_data), GFP_KERNEL);
+	if (!buf_data)
+		return ERR_PTR(-ENOMEM);
+
+	buf_data->ctx = ctx;
+	init_completion(&buf_data->done);
+	INIT_LIST_HEAD(&buf_data->ref_list);
+	spin_lock_init(&buf_data->lock);
+
+	if (percpu_ref_init(&buf_data->refs, io_rsrc_ref_kill,
+			    PERCPU_REF_ALLOW_REINIT, GFP_KERNEL)) {
+		kfree(buf_data);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	return buf_data;
+}
+
+static void io_free_buf_data(struct io_ring_ctx *ctx)
+{
+	percpu_ref_exit(&ctx->buf_data->refs);
+	kfree(ctx->buf_data->table);
+	kfree(ctx->buf_data);
+}
+
 static struct fixed_rsrc_data *io_buffers_map_alloc(struct io_ring_ctx *ctx,
 						    unsigned int nr_args)
 {
-	unsigned nr_tables;
 	struct fixed_rsrc_data *buf_data;
+	unsigned nr_tables;
 	int ret = -ENOMEM;
 
-	if (ctx->buf_data)
+	if (ctx->nr_user_bufs)
 		return ERR_PTR(-EBUSY);
 	if (!nr_args || nr_args > IORING_MAX_FIXED_BUFS)
 		return ERR_PTR(-EINVAL);
 
-	buf_data = kzalloc(sizeof(*ctx->buf_data), GFP_KERNEL);
-	if (!buf_data)
-		return ERR_PTR(-ENOMEM);
-	buf_data->ctx = ctx;
-	init_completion(&buf_data->done);
-	INIT_LIST_HEAD(&buf_data->ref_list);
-	spin_lock_init(&buf_data->lock);
+	if (ctx->buf_data)
+		buf_data = ctx->buf_data;
+	else {
+		buf_data = io_alloc_buf_data(ctx);
+		if (IS_ERR(buf_data))
+			return buf_data;
+	}
 
 	nr_tables = DIV_ROUND_UP(nr_args, IORING_MAX_BUFS_TABLE);
-	buf_data->table = kcalloc(nr_tables, sizeof(buf_data->table),
+	buf_data->table = kcalloc(nr_tables, sizeof(struct fixed_rsrc_table),
 				  GFP_KERNEL);
 	if (!buf_data->table)
-		goto out_free;
-
-	if (percpu_ref_init(&buf_data->refs, io_rsrc_ref_kill,
-			    PERCPU_REF_ALLOW_REINIT, GFP_KERNEL))
-		goto out_free;
+		goto out;
 
 	if (io_alloc_buf_tables(buf_data, nr_tables, nr_args))
-		goto out_ref;
+		goto out;
 
 	return buf_data;
-
-out_ref:
-	percpu_ref_exit(&buf_data->refs);
-out_free:
-	kfree(buf_data->table);
-	kfree(buf_data);
+out:
+	io_free_buf_data(ctx);
 	return ERR_PTR(ret);
 }
 
@@ -8515,9 +8548,17 @@ static int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
 	struct fixed_rsrc_ref_node *ref_node;
 	struct fixed_rsrc_data *buf_data;
 
+	if (ctx->flags & IORING_SETUP_ATTACH_BUF) {
+		if (!ctx->buf_data)
+			return -EFAULT;
+		ctx->nr_user_bufs = ctx->buf_data->ctx->nr_user_bufs;
+		return 0;
+	}
+
 	buf_data = io_buffers_map_alloc(ctx, nr_args);
 	if (IS_ERR(buf_data))
 		return PTR_ERR(buf_data);
+	ctx->buf_data = buf_data;
 
 	for (i = 0; i < nr_args; i++, ctx->nr_user_bufs++) {
 		struct fixed_rsrc_table *table;
@@ -8545,7 +8586,6 @@ static int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
 			break;
 	}
 
-	ctx->buf_data = buf_data;
 	if (ret) {
 		io_sqe_buffers_unregister(ctx);
 		return ret;
@@ -9623,6 +9663,55 @@ static int io_uring_get_fd(struct io_ring_ctx *ctx)
 	return ret;
 }
 
+static int io_attach_buf_data(struct io_ring_ctx *ctx,
+			      struct io_uring_params *p)
+{
+	struct io_ring_ctx *ctx_attach;
+	struct fd f;
+
+	f = fdget(p->wq_fd);
+	if (!f.file)
+		return -EBADF;
+	if (f.file->f_op != &io_uring_fops) {
+		fdput(f);
+		return -EINVAL;
+	}
+
+	ctx_attach = f.file->private_data;
+	if (!ctx_attach->buf_data) {
+		fdput(f);
+		return -EINVAL;
+	}
+	ctx->buf_data = ctx_attach->buf_data;
+
+	percpu_ref_get(&ctx->buf_data->refs);
+	fdput(f);
+	return 0;
+}
+
+static int io_init_buf_data(struct io_ring_ctx *ctx, struct io_uring_params *p)
+{
+	if ((p->flags & (IORING_SETUP_SHARE_BUF | IORING_SETUP_ATTACH_BUF)) ==
+	    (IORING_SETUP_SHARE_BUF | IORING_SETUP_ATTACH_BUF))
+		return -EINVAL;
+
+	if (p->flags & IORING_SETUP_SHARE_BUF) {
+		struct fixed_rsrc_data *buf_data;
+
+		buf_data = io_alloc_buf_data(ctx);
+		if (IS_ERR(buf_data))
+			return PTR_ERR(buf_data);
+
+		ctx->buf_data = buf_data;
+		return 0;
+	}
+
+	if (p->flags & IORING_SETUP_ATTACH_BUF)
+		return io_attach_buf_data(ctx, p);
+
+	return 0;
+}
+
 static int io_uring_create(unsigned entries, struct io_uring_params *p,
 			   struct io_uring_params __user *params)
 {
@@ -9737,6 +9826,10 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p,
 	if (ret)
 		goto err;
 
+	ret = io_init_buf_data(ctx, p);
+	if (ret)
+		goto err;
+
 	ret = io_sq_offload_create(ctx, p);
 	if (ret)
 		goto err;
@@ -9807,6 +9900,7 @@ static long io_uring_setup(u32 entries, struct io_uring_params __user *params)
 	if (p.flags & ~(IORING_SETUP_IOPOLL | IORING_SETUP_SQPOLL |
 			IORING_SETUP_SQ_AFF | IORING_SETUP_CQSIZE |
 			IORING_SETUP_CLAMP | IORING_SETUP_ATTACH_WQ |
+			IORING_SETUP_SHARE_BUF | IORING_SETUP_ATTACH_BUF |
 			IORING_SETUP_R_DISABLED))
 		return -EINVAL;
 
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 8f92555..1079048 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -99,6 +99,8 @@ enum {
 #define IORING_SETUP_CLAMP	(1U << 4)	/* clamp SQ/CQ ring sizes */
 #define IORING_SETUP_ATTACH_WQ	(1U << 5)	/* attach to existing wq */
 #define IORING_SETUP_R_DISABLED	(1U << 6)	/* start with ring disabled */
+#define IORING_SETUP_SHARE_BUF	(1U << 7)	/* share buffer registration */
+#define IORING_SETUP_ATTACH_BUF	(1U << 8)	/* attach buffer registration */
 
 enum {
 	IORING_OP_NOP,
-- 
1.8.3.1

