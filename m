Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93BB02EC534
	for <lists+io-uring@lfdr.de>; Wed,  6 Jan 2021 21:40:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727150AbhAFUkU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 6 Jan 2021 15:40:20 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:55974 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727362AbhAFUkT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 6 Jan 2021 15:40:19 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 106KYmnd037719;
        Wed, 6 Jan 2021 20:39:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=YLBOrTQu6qneB3Nq8zUj+3l5Ola5H4hVynLNmuMcXQo=;
 b=DDKzcF8XA/tlx54cKNXZ9GeLYNzQCpODs1IKeoyIxUTch1PXS43lBcCyYQph+eOCwWUA
 x6vC4shfGZjLtgOlqLTyZ4a2pQwhFlKJ2+tArz7H7uRYr/OCOG8E83kItmv338sXlh9Y
 /Hg+99NVk+DyX39dg9albMEAur+N3Lk937nkWkkgXaas8oCzgPjFZXX2fTavA670AJBU
 cijjyGETGojiO+3VbQvYwc0rizxKrsCC7YQPshUFQsNUH20+C1i7giYLUKhr4erwtkMv
 lYFF391FNKSAyAyJYAdQ4seTxwo+CaPvld7yeWMzlakgPdLZeuvs2/AuOyYeVSOXxefv DA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 35wcuxt595-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 06 Jan 2021 20:39:35 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 106KZbQA145512;
        Wed, 6 Jan 2021 20:39:35 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 35w3g1jf2a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Jan 2021 20:39:35 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 106KdYPh021660;
        Wed, 6 Jan 2021 20:39:34 GMT
Received: from ca-ldom147.us.oracle.com (/10.129.68.131)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 Jan 2021 20:39:34 +0000
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk, asml.silence@gmail.com, io-uring@vger.kernel.org
Subject: [PATCH v4 13/13] io_uring: support buffer registration sharing
Date:   Wed,  6 Jan 2021 12:39:22 -0800
Message-Id: <1609965562-13569-14-git-send-email-bijan.mottahedeh@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1609965562-13569-1-git-send-email-bijan.mottahedeh@oracle.com>
References: <1609965562-13569-1-git-send-email-bijan.mottahedeh@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9856 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 adultscore=0
 phishscore=0 spamscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101060117
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9856 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 clxscore=1015 spamscore=0 impostorscore=0 priorityscore=1501 mlxscore=0
 adultscore=0 mlxlogscore=999 lowpriorityscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101060117
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
 fs/io_uring.c                 | 85 +++++++++++++++++++++++++++++++++++++++++--
 include/uapi/linux/io_uring.h |  2 +
 2 files changed, 83 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ea708ec..08ca435e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8438,6 +8438,13 @@ static void io_buffers_map_free(struct io_ring_ctx *ctx)
 	ctx->nr_user_bufs = 0;
 }
 
+static void io_detach_buf_data(struct io_ring_ctx *ctx)
+{
+	percpu_ref_put(&ctx->buf_data->refs);
+	ctx->buf_data = NULL;
+	ctx->nr_user_bufs = 0;
+}
+
 static int io_sqe_buffers_unregister(struct io_ring_ctx *ctx)
 {
 	struct fixed_rsrc_data *data = ctx->buf_data;
@@ -8446,6 +8453,11 @@ static int io_sqe_buffers_unregister(struct io_ring_ctx *ctx)
 	if (!data)
 		return -ENXIO;
 
+	if (ctx->flags & IORING_SETUP_ATTACH_BUF) {
+		io_detach_buf_data(ctx);
+		return 0;
+	}
+
 	ret = io_rsrc_ref_quiesce(data, ctx);
 	if (ret)
 		return ret;
@@ -8689,9 +8701,13 @@ static struct fixed_rsrc_data *io_buffers_map_alloc(struct io_ring_ctx *ctx,
 	if (!nr_args || nr_args > IORING_MAX_FIXED_BUFS)
 		return ERR_PTR(-EINVAL);
 
-	buf_data = alloc_fixed_rsrc_data(ctx);
-	if (IS_ERR(buf_data))
-		return buf_data;
+	if (ctx->buf_data) {
+		buf_data = ctx->buf_data;
+	} else {
+		buf_data = alloc_fixed_rsrc_data(ctx);
+		if (IS_ERR(buf_data))
+			return buf_data;
+	}
 
 	nr_tables = DIV_ROUND_UP(nr_args, IORING_MAX_BUFS_TABLE);
 	buf_data->table = kcalloc(nr_tables, sizeof(*buf_data->table),
@@ -8756,9 +8772,17 @@ static int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
 	if (ctx->nr_user_bufs)
 		return -EBUSY;
 
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
 		struct io_mapped_ubuf *imu;
@@ -8782,7 +8806,6 @@ static int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
 			break;
 	}
 
-	ctx->buf_data = buf_data;
 	if (ret) {
 		io_sqe_buffers_unregister(ctx);
 		return ret;
@@ -9833,6 +9856,55 @@ static struct file *io_uring_get_file(struct io_ring_ctx *ctx)
 	return file;
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
+		buf_data = alloc_fixed_rsrc_data(ctx);
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
@@ -9950,6 +10022,10 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p,
 	if (ret)
 		goto err;
 
+	ret = io_init_buf_data(ctx, p);
+	if (ret)
+		goto err;
+
 	ret = io_sq_offload_create(ctx, p);
 	if (ret)
 		goto err;
@@ -10030,6 +10106,7 @@ static long io_uring_setup(u32 entries, struct io_uring_params __user *params)
 	if (p.flags & ~(IORING_SETUP_IOPOLL | IORING_SETUP_SQPOLL |
 			IORING_SETUP_SQ_AFF | IORING_SETUP_CQSIZE |
 			IORING_SETUP_CLAMP | IORING_SETUP_ATTACH_WQ |
+			IORING_SETUP_SHARE_BUF | IORING_SETUP_ATTACH_BUF |
 			IORING_SETUP_R_DISABLED))
 		return -EINVAL;
 
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index b289ef8..3ad786a 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -98,6 +98,8 @@ enum {
 #define IORING_SETUP_CLAMP	(1U << 4)	/* clamp SQ/CQ ring sizes */
 #define IORING_SETUP_ATTACH_WQ	(1U << 5)	/* attach to existing wq */
 #define IORING_SETUP_R_DISABLED	(1U << 6)	/* start with ring disabled */
+#define IORING_SETUP_SHARE_BUF	(1U << 7)	/* share buffer registration */
+#define IORING_SETUP_ATTACH_BUF	(1U << 8)	/* attach buffer registration */
 
 enum {
 	IORING_OP_NOP,
-- 
1.8.3.1

