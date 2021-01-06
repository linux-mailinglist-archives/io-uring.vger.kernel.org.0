Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D2042EC52F
	for <lists+io-uring@lfdr.de>; Wed,  6 Jan 2021 21:40:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727363AbhAFUkS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 6 Jan 2021 15:40:18 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:55946 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727171AbhAFUkR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 6 Jan 2021 15:40:17 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 106KZKD2038104;
        Wed, 6 Jan 2021 20:39:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=hCFynnveol1d/wyka1jD4mB9g9ERDvoxu53PO0FR1HI=;
 b=TkQMz80sJIl6sUyRqNXqQWzyZh+kHRzs73NTto8szzWBZ+3TAD1v54NRihQM8EC/6smn
 0+5pkehLf9iWw3hkGg5tvY05M4rP4K10ZCV3SiVu5JO1fvr22ax4ZUEvn9NmNnrVqTAf
 bAmE9AkGIGiGRGvYTANtgI4GIxgAWeThZBfE86/KEBO8CbZMxVpjUhXXBO8Ygi554cTh
 1w2/vXTpxIZ3y6u18XRpzTVBf/JUuDs201+YhTACemTYy9DTiNH/gElR6jwVt0z8C2mV
 outzZ/Yos2uMqiaJ7fUC8zxquatbl/A7WvlbiMvO6e9CiPvQBHf9IDooDqf7wzR924T7 6w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 35wcuxt592-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 06 Jan 2021 20:39:34 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 106KZ5Z2129091;
        Wed, 6 Jan 2021 20:39:34 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 35v1faa617-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Jan 2021 20:39:34 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 106KdXgu021601;
        Wed, 6 Jan 2021 20:39:33 GMT
Received: from ca-ldom147.us.oracle.com (/10.129.68.131)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 Jan 2021 20:39:32 +0000
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk, asml.silence@gmail.com, io-uring@vger.kernel.org
Subject: [PATCH v4 08/13] io_uring: implement fixed buffers registration similar to fixed files
Date:   Wed,  6 Jan 2021 12:39:17 -0800
Message-Id: <1609965562-13569-9-git-send-email-bijan.mottahedeh@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1609965562-13569-1-git-send-email-bijan.mottahedeh@oracle.com>
References: <1609965562-13569-1-git-send-email-bijan.mottahedeh@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9856 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 suspectscore=0 spamscore=0 bulkscore=0 adultscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101060117
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9856 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 clxscore=1015 spamscore=0 impostorscore=0 priorityscore=1501 mlxscore=0
 adultscore=0 mlxlogscore=999 lowpriorityscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101060117
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Apply fixed_rsrc functionality for fixed buffers support.

Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
---
 fs/io_uring.c | 234 +++++++++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 198 insertions(+), 36 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 61e87c4..91be618 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -104,6 +104,14 @@
 #define IORING_MAX_RESTRICTIONS	(IORING_RESTRICTION_LAST + \
 				 IORING_REGISTER_LAST + IORING_OP_LAST)
 
+/*
+ * Shift of 7 is 128 entries, or exactly one page on 64-bit archs
+ */
+#define IORING_BUF_TABLE_SHIFT	7	/* struct io_mapped_ubuf */
+#define IORING_MAX_BUFS_TABLE	(1U << IORING_BUF_TABLE_SHIFT)
+#define IORING_BUF_TABLE_MASK	(IORING_MAX_BUFS_TABLE - 1)
+#define IORING_MAX_FIXED_BUFS	UIO_MAXIOV
+
 struct io_uring {
 	u32 head ____cacheline_aligned_in_smp;
 	u32 tail ____cacheline_aligned_in_smp;
@@ -336,8 +344,8 @@ struct io_ring_ctx {
 	unsigned		nr_user_files;
 
 	/* if used, fixed mapped user buffers */
+	struct fixed_rsrc_data	*buf_data;
 	unsigned		nr_user_bufs;
-	struct io_mapped_ubuf	*user_bufs;
 
 	struct user_struct	*user;
 
@@ -2958,6 +2966,15 @@ static void kiocb_done(struct kiocb *kiocb, ssize_t ret,
 		io_rw_done(kiocb, ret);
 }
 
+static inline struct io_mapped_ubuf *io_buf_from_index(struct io_ring_ctx *ctx,
+						       int index)
+{
+	struct fixed_rsrc_table *table;
+
+	table = &ctx->buf_data->table[index >> IORING_BUF_TABLE_SHIFT];
+	return &table->bufs[index & IORING_BUF_TABLE_MASK];
+}
+
 static ssize_t io_import_fixed(struct io_kiocb *req, int rw,
 			       struct iov_iter *iter)
 {
@@ -2971,7 +2988,7 @@ static ssize_t io_import_fixed(struct io_kiocb *req, int rw,
 	if (unlikely(buf_index >= ctx->nr_user_bufs))
 		return -EFAULT;
 	index = array_index_nospec(buf_index, ctx->nr_user_bufs);
-	imu = &ctx->user_bufs[index];
+	imu = io_buf_from_index(ctx, index);
 	buf_addr = req->rw.addr;
 
 	/* overflow */
@@ -8322,28 +8339,71 @@ static unsigned long ring_pages(unsigned sq_entries, unsigned cq_entries)
 	return pages;
 }
 
-static int io_sqe_buffers_unregister(struct io_ring_ctx *ctx)
+static void io_buffer_unmap(struct io_ring_ctx *ctx, struct io_mapped_ubuf *imu)
 {
-	int i, j;
+	unsigned int i;
 
-	if (!ctx->user_bufs)
-		return -ENXIO;
+	for (i = 0; i < imu->nr_bvecs; i++)
+		unpin_user_page(imu->bvec[i].bv_page);
 
-	for (i = 0; i < ctx->nr_user_bufs; i++) {
-		struct io_mapped_ubuf *imu = &ctx->user_bufs[i];
+	if (imu->acct_pages)
+		io_unaccount_mem(ctx, imu->nr_bvecs, ACCT_PINNED);
+	kvfree(imu->bvec);
+	imu->nr_bvecs = 0;
+}
 
-		for (j = 0; j < imu->nr_bvecs; j++)
-			unpin_user_page(imu->bvec[j].bv_page);
+static void io_buffers_unmap(struct io_ring_ctx *ctx)
+{
+	unsigned int i;
+	struct io_mapped_ubuf *imu;
 
-		if (imu->acct_pages)
-			io_unaccount_mem(ctx, imu->acct_pages, ACCT_PINNED);
-		kvfree(imu->bvec);
-		imu->nr_bvecs = 0;
+	for (i = 0; i < ctx->nr_user_bufs; i++) {
+		imu = io_buf_from_index(ctx, i);
+		io_buffer_unmap(ctx, imu);
 	}
+}
+
+static void io_buffers_map_free(struct io_ring_ctx *ctx)
+{
+	struct fixed_rsrc_data *data = ctx->buf_data;
+	unsigned int nr_tables, i;
+
+	if (!data)
+		return;
 
-	kfree(ctx->user_bufs);
-	ctx->user_bufs = NULL;
+	nr_tables = DIV_ROUND_UP(ctx->nr_user_bufs, IORING_MAX_BUFS_TABLE);
+	for (i = 0; i < nr_tables; i++)
+		kfree(data->table[i].bufs);
+	kfree(data->table);
+	percpu_ref_exit(&data->refs);
+	kfree(data);
+	ctx->buf_data = NULL;
 	ctx->nr_user_bufs = 0;
+}
+
+static int io_sqe_buffers_unregister(struct io_ring_ctx *ctx)
+{
+	struct fixed_rsrc_data *data = ctx->buf_data;
+	struct fixed_rsrc_ref_node *ref_node = NULL;
+
+	if (!data)
+		return -ENXIO;
+
+	io_rsrc_ref_lock(ctx);
+	ref_node = data->node;
+	io_rsrc_ref_unlock(ctx);
+	if (ref_node)
+		percpu_ref_kill(&ref_node->refs);
+
+	percpu_ref_kill(&data->refs);
+
+	/* wait for all refs nodes to complete */
+	flush_delayed_work(&ctx->rsrc_put_work);
+	wait_for_completion(&data->done);
+
+	io_buffers_unmap(ctx);
+	io_buffers_map_free(ctx);
+
 	return 0;
 }
 
@@ -8396,7 +8456,9 @@ static bool headpage_already_acct(struct io_ring_ctx *ctx, struct page **pages,
 
 	/* check previously registered pages */
 	for (i = 0; i < ctx->nr_user_bufs; i++) {
-		struct io_mapped_ubuf *imu = &ctx->user_bufs[i];
+		struct io_mapped_ubuf *imu;
+
+		imu = io_buf_from_index(ctx, i);
 
 		for (j = 0; j < imu->nr_bvecs; j++) {
 			if (!PageCompound(imu->bvec[j].bv_page))
@@ -8531,19 +8593,79 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
 	return ret;
 }
 
-static int io_buffers_map_alloc(struct io_ring_ctx *ctx, unsigned int nr_args)
+static void io_free_buf_tables(struct fixed_rsrc_data *buf_data,
+			       unsigned int nr_tables)
 {
-	if (ctx->user_bufs)
-		return -EBUSY;
-	if (!nr_args || nr_args > UIO_MAXIOV)
-		return -EINVAL;
+	int i;
 
-	ctx->user_bufs = kcalloc(nr_args, sizeof(struct io_mapped_ubuf),
-					GFP_KERNEL);
-	if (!ctx->user_bufs)
-		return -ENOMEM;
+	for (i = 0; i < nr_tables; i++) {
+		struct fixed_rsrc_table *table = &buf_data->table[i];
 
-	return 0;
+		kfree(table->bufs);
+	}
+}
+
+static int io_alloc_buf_tables(struct fixed_rsrc_data *buf_data,
+			       unsigned int nr_tables, unsigned int nr_bufs)
+{
+	int i;
+
+	for (i = 0; i < nr_tables; i++) {
+		struct fixed_rsrc_table *table = &buf_data->table[i];
+		unsigned int this_bufs;
+
+		this_bufs = min(nr_bufs, IORING_MAX_BUFS_TABLE);
+		table->bufs = kcalloc(this_bufs, sizeof(struct io_mapped_ubuf),
+				      GFP_KERNEL);
+		if (!table->bufs)
+			break;
+		nr_bufs -= this_bufs;
+	}
+
+	if (i == nr_tables)
+		return 0;
+
+	io_free_buf_tables(buf_data, i);
+	return 1;
+}
+
+static struct fixed_rsrc_data *io_buffers_map_alloc(struct io_ring_ctx *ctx,
+						    unsigned int nr_args)
+{
+	unsigned int nr_tables;
+	struct fixed_rsrc_data *buf_data;
+	int ret = -ENOMEM;
+
+	if (!nr_args || nr_args > IORING_MAX_FIXED_BUFS)
+		return ERR_PTR(-EINVAL);
+
+	buf_data = kzalloc(sizeof(*ctx->buf_data), GFP_KERNEL);
+	if (!buf_data)
+		return ERR_PTR(-ENOMEM);
+	buf_data->ctx = ctx;
+	init_completion(&buf_data->done);
+
+	nr_tables = DIV_ROUND_UP(nr_args, IORING_MAX_BUFS_TABLE);
+	buf_data->table = kcalloc(nr_tables, sizeof(*buf_data->table),
+				  GFP_KERNEL);
+	if (!buf_data->table)
+		goto out_free;
+
+	if (percpu_ref_init(&buf_data->refs, io_rsrc_ref_kill,
+			    PERCPU_REF_ALLOW_REINIT, GFP_KERNEL))
+		goto out_free;
+
+	if (io_alloc_buf_tables(buf_data, nr_tables, nr_args))
+		goto out_ref;
+
+	return buf_data;
+
+out_ref:
+	percpu_ref_exit(&buf_data->refs);
+out_free:
+	kfree(buf_data->table);
+	kfree(buf_data);
+	return ERR_PTR(ret);
 }
 
 static int io_buffer_validate(struct iovec *iov)
@@ -8563,39 +8685,78 @@ static int io_buffer_validate(struct iovec *iov)
 	return 0;
 }
 
+static void io_ring_buf_put(struct io_ring_ctx *ctx, struct io_rsrc_put *prsrc)
+{
+	io_buffer_unmap(ctx, prsrc->buf);
+}
+
+static struct fixed_rsrc_ref_node *alloc_fixed_buf_ref_node(
+			struct io_ring_ctx *ctx)
+{
+	struct fixed_rsrc_ref_node *ref_node;
+
+	ref_node = alloc_fixed_rsrc_ref_node(ctx);
+	ref_node->rsrc_data = ctx->buf_data;
+	ref_node->rsrc_put = io_ring_buf_put;
+	return ref_node;
+}
+
 static int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
 				   unsigned int nr_args)
 {
 	int i, ret;
 	struct iovec iov;
 	struct page *last_hpage = NULL;
+	struct fixed_rsrc_ref_node *ref_node;
+	struct fixed_rsrc_data *buf_data;
 
-	ret = io_buffers_map_alloc(ctx, nr_args);
-	if (ret)
-		return ret;
+	if (ctx->nr_user_bufs)
+		return -EBUSY;
 
-	for (i = 0; i < nr_args; i++) {
-		struct io_mapped_ubuf *imu = &ctx->user_bufs[i];
+	buf_data = io_buffers_map_alloc(ctx, nr_args);
+	if (IS_ERR(buf_data))
+		return PTR_ERR(buf_data);
+
+	for (i = 0; i < nr_args; i++, ctx->nr_user_bufs++) {
+		struct io_mapped_ubuf *imu;
 
 		ret = io_copy_iov(ctx, &iov, arg, i);
 		if (ret)
 			break;
 
+		/* allow sparse sets */
+		if (!iov.iov_base && !iov.iov_len)
+			continue;
+
 		ret = io_buffer_validate(&iov);
 		if (ret)
 			break;
 
+		imu = io_buf_from_index(ctx, i);
+
 		ret = io_sqe_buffer_register(ctx, &iov, imu, &last_hpage);
 		if (ret)
 			break;
+	}
 
-		ctx->nr_user_bufs++;
+	ctx->buf_data = buf_data;
+	if (ret) {
+		io_sqe_buffers_unregister(ctx);
+		return ret;
 	}
 
-	if (ret)
+	ref_node = alloc_fixed_buf_ref_node(ctx);
+	if (IS_ERR(ref_node)) {
 		io_sqe_buffers_unregister(ctx);
+		return PTR_ERR(ref_node);
+	}
 
-	return ret;
+	buf_data->node = ref_node;
+	io_rsrc_ref_lock(ctx);
+	list_add(&ref_node->node, &ctx->rsrc_ref_list);
+	io_rsrc_ref_unlock(ctx);
+	percpu_ref_get(&buf_data->refs);
+	return 0;
 }
 
 static int io_eventfd_register(struct io_ring_ctx *ctx, void __user *arg)
@@ -9393,7 +9554,7 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx *ctx, struct seq_file *m)
 	}
 	seq_printf(m, "UserBufs:\t%u\n", ctx->nr_user_bufs);
 	for (i = 0; has_lock && i < ctx->nr_user_bufs; i++) {
-		struct io_mapped_ubuf *buf = &ctx->user_bufs[i];
+		struct io_mapped_ubuf *buf = io_buf_from_index(ctx, i);
 
 		seq_printf(m, "%5u: 0x%llx/%u\n", i, buf->ubuf,
 						(unsigned int) buf->len);
@@ -9908,6 +10069,7 @@ static bool io_register_op_must_quiesce(int op)
 	switch (op) {
 	case IORING_UNREGISTER_FILES:
 	case IORING_REGISTER_FILES_UPDATE:
+	case IORING_UNREGISTER_BUFFERS:
 	case IORING_REGISTER_PROBE:
 	case IORING_REGISTER_PERSONALITY:
 	case IORING_UNREGISTER_PERSONALITY:
-- 
1.8.3.1

