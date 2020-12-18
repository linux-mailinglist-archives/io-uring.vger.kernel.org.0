Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5CD32DE8D6
	for <lists+io-uring@lfdr.de>; Fri, 18 Dec 2020 19:12:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728103AbgLRSK0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Dec 2020 13:10:26 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:40440 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727874AbgLRSK0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Dec 2020 13:10:26 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BII4QDQ147241;
        Fri, 18 Dec 2020 18:09:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=DLQZDpkH3xFrKQYlFQU+7dAhp32Cm9AWcpd9yCW+PuE=;
 b=ioWQW5KmF6t9vsKsr5nFDP5TrRKoFaBrpSWqt4rskJodQL5xfXbBooTnrm403ihdAAXD
 YQPxZkARvMOxPcTtCcUKbM+bc2ylHRs2WPPdZKG0hLAyG0dQtTb9QT3cxIjYe5vxBiy2
 jetHeIzY0QjkdaNxXUjP6T7lJwDKZvfzvWScW2wWdDJG2CH+JQxmIdGcOv8zQb1sG3U+
 vTXz/OIbBrn+BURSE0yF5dwTe/VpyjQsiGkb4cnoQoXV/DfnRwwXhnWlqhX1Fouyog94
 RYCdTA2aSKuYtV5Q/SZ1wCdv63svDiLduaR+bINIJKB5nde7hQo5OzRDXxSzaEaRTGzG gg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 35cn9ruj49-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 18 Dec 2020 18:09:42 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BII5RGV095909;
        Fri, 18 Dec 2020 18:07:41 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 35e6ev0xpq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Dec 2020 18:07:41 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0BII7fIL015980;
        Fri, 18 Dec 2020 18:07:41 GMT
Received: from ca-ldom147.us.oracle.com (/10.129.68.131)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 18 Dec 2020 10:07:41 -0800
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk, asml.silence@gmail.com, io-uring@vger.kernel.org
Subject: [PATCH v3 13/13] io_uring: support buffer registration sharing
Date:   Fri, 18 Dec 2020 10:07:28 -0800
Message-Id: <1608314848-67329-14-git-send-email-bijan.mottahedeh@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1608314848-67329-1-git-send-email-bijan.mottahedeh@oracle.com>
References: <1608314848-67329-1-git-send-email-bijan.mottahedeh@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9839 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012180124
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9839 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 impostorscore=0 lowpriorityscore=0 clxscore=1015 spamscore=0
 malwarescore=0 priorityscore=1501 phishscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012180124
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
index f5706e1..1341526 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8411,6 +8411,13 @@ static void io_buffers_map_free(struct io_ring_ctx *ctx)
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
@@ -8418,6 +8425,11 @@ static int io_sqe_buffers_unregister(struct io_ring_ctx *ctx)
 	if (!data)
 		return -ENXIO;
 
+	if (ctx->flags & IORING_SETUP_ATTACH_BUF) {
+		io_detach_buf_data(ctx);
+		return 0;
+	}
+
 	io_rsrc_ref_quiesce(data, ctx);
 	io_buffers_unmap(ctx);
 	io_buffers_map_free(ctx);
@@ -8662,9 +8674,13 @@ static struct fixed_rsrc_data *io_buffers_map_alloc(struct io_ring_ctx *ctx,
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
@@ -8729,9 +8745,17 @@ static int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
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
 		struct fixed_rsrc_table *table;
@@ -8759,7 +8783,6 @@ static int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
 			break;
 	}
 
-	ctx->buf_data = buf_data;
 	if (ret) {
 		io_sqe_buffers_unregister(ctx);
 		return ret;
@@ -9789,6 +9812,55 @@ static int io_uring_get_fd(struct io_ring_ctx *ctx)
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
@@ -9903,6 +9975,10 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p,
 	if (ret)
 		goto err;
 
+	ret = io_init_buf_data(ctx, p);
+	if (ret)
+		goto err;
+
 	ret = io_sq_offload_create(ctx, p);
 	if (ret)
 		goto err;
@@ -9974,6 +10050,7 @@ static long io_uring_setup(u32 entries, struct io_uring_params __user *params)
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

