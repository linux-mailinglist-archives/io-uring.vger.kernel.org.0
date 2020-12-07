Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E60192D1D24
	for <lists+io-uring@lfdr.de>; Mon,  7 Dec 2020 23:20:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727824AbgLGWQ4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 7 Dec 2020 17:16:56 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:58758 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727733AbgLGWQv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 7 Dec 2020 17:16:51 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B7M9G73111876;
        Mon, 7 Dec 2020 22:16:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=HpqEH5UCRk3JOHMaboAn27PfqP6scuXCs0fYVIFpWkM=;
 b=Y+tVSX61xPPoM9fsqVAkhbQTnFkd8EVIQmaXljgudC+c007iL3v9GKRSAO1DFTRVKOR8
 7CfolP/7XScBxVoLEMZyb78+inJEDYM4KOGRm0MUVl6cwGr0ebwc6CbX22Z6p6mJVEhk
 bmf/blF3sVOkTDRJLKMOg4G2oTE/7osq06Rafz+JklevB7Wlldwut2sgz//RgFXS+Le8
 HT/ToRPfF0qrSmZNKw8OTNRt8n1KosCKS6xCHi1PWm+YEXQarQx2FHN6g7102NKyRt4R
 r+slOOrdmZsTN8SDmi14HJHxyE9bVRvZCm95lc2GIglYugYyRQIcx5rx1U3Cs/52q77P 3g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 357yqbr17e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 07 Dec 2020 22:16:08 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B7MAjq2082861;
        Mon, 7 Dec 2020 22:16:08 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 358ksmsaky-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Dec 2020 22:16:08 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B7MG7it006169;
        Mon, 7 Dec 2020 22:16:07 GMT
Received: from ca-ldom147.us.oracle.com (/10.129.68.131)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 07 Dec 2020 14:16:07 -0800
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk, asml.silence@gmail.com, io-uring@vger.kernel.org
Subject: [PATCH v2 13/13] io_uring: support buffer registration sharing
Date:   Mon,  7 Dec 2020 14:15:52 -0800
Message-Id: <1607379352-68109-14-git-send-email-bijan.mottahedeh@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1607379352-68109-1-git-send-email-bijan.mottahedeh@oracle.com>
References: <1607379352-68109-1-git-send-email-bijan.mottahedeh@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9828 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=2
 bulkscore=0 malwarescore=0 phishscore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012070145
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9828 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 mlxlogscore=999
 clxscore=1015 malwarescore=0 bulkscore=0 phishscore=0 adultscore=0
 spamscore=0 priorityscore=1501 mlxscore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012070145
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
index 479a6b9..b75cbd7 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8408,6 +8408,12 @@ static void io_buffers_map_free(struct io_ring_ctx *ctx)
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
@@ -8415,6 +8421,12 @@ static int io_sqe_buffers_unregister(struct io_ring_ctx *ctx)
 	if (!data)
 		return -ENXIO;
 
+	if (ctx->flags & IORING_SETUP_ATTACH_BUF) {
+		io_detach_buf_data(ctx);
+		ctx->nr_user_bufs = 0;
+		return 0;
+	}
+
 	io_rsrc_ref_quiesce(data, ctx);
 	io_buffers_unmap(ctx);
 	io_buffers_map_free(ctx);
@@ -8660,9 +8672,13 @@ static struct fixed_rsrc_data *io_buffers_map_alloc(struct io_ring_ctx *ctx,
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
@@ -8724,9 +8740,17 @@ static int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
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
@@ -8754,7 +8778,6 @@ static int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
 			break;
 	}
 
-	ctx->buf_data = buf_data;
 	if (ret) {
 		io_sqe_buffers_unregister(ctx);
 		return ret;
@@ -9783,6 +9806,55 @@ static int io_uring_get_fd(struct io_ring_ctx *ctx)
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
@@ -9897,6 +9969,10 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p,
 	if (ret)
 		goto err;
 
+	ret = io_init_buf_data(ctx, p);
+	if (ret)
+		goto err;
+
 	ret = io_sq_offload_create(ctx, p);
 	if (ret)
 		goto err;
@@ -9968,6 +10044,7 @@ static long io_uring_setup(u32 entries, struct io_uring_params __user *params)
 	if (p.flags & ~(IORING_SETUP_IOPOLL | IORING_SETUP_SQPOLL |
 			IORING_SETUP_SQ_AFF | IORING_SETUP_CQSIZE |
 			IORING_SETUP_CLAMP | IORING_SETUP_ATTACH_WQ |
+			IORING_SETUP_SHARE_BUF | IORING_SETUP_ATTACH_BUF |
 			IORING_SETUP_R_DISABLED))
 		return -EINVAL;
 
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 0d9ac12..2366126 100644
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

