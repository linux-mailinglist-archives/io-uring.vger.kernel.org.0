Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED2802DE8C9
	for <lists+io-uring@lfdr.de>; Fri, 18 Dec 2020 19:08:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727283AbgLRSIY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Dec 2020 13:08:24 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:37288 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725932AbgLRSIY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Dec 2020 13:08:24 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BII4QSs147236;
        Fri, 18 Dec 2020 18:07:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=Kox5kFrbG2DxOO+Lq2zunpIr2WeOMCLwX80Vc9ULhmU=;
 b=G/qzpIjBkONURnanXTJnybr5O8Fq2Ucbqokrg50gb9thNS4T5reluCyL2rCxR3zpcLxt
 3Iwa8bsr5StoYPD8UBmJG+fabl5XcNahW4KvOD71KEvQFSmsS5V/CIg6hBc8XIjQ1Jhi
 QGbG7fWhqNytopWRnAlZgghDVgrynzCM/tYmNXHopI5PyqKqu6JsHqnyjHKW3Q5L/OzF
 ghWvqG2Noac+0CecTvfVwS22bHJb667v4pfiw0ZfHMG++5gtcqVWwAvpq93zzj3XZObC
 zpRoKwC17gEs2pTSTDHz5DvLfR/ZbShuqo/uVHaem/zUPLd1ePu9S/MsOllfXU/uldsR kg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 35cn9ruhvb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 18 Dec 2020 18:07:41 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BII6Lwb048044;
        Fri, 18 Dec 2020 18:07:40 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 35d7t26pu2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Dec 2020 18:07:40 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0BII7dnE008703;
        Fri, 18 Dec 2020 18:07:40 GMT
Received: from ca-ldom147.us.oracle.com (/10.129.68.131)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 18 Dec 2020 10:07:39 -0800
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk, asml.silence@gmail.com, io-uring@vger.kernel.org
Subject: [PATCH v3 08/13] io_uring: implement fixed buffers registration similar to fixed files
Date:   Fri, 18 Dec 2020 10:07:23 -0800
Message-Id: <1608314848-67329-9-git-send-email-bijan.mottahedeh@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1608314848-67329-1-git-send-email-bijan.mottahedeh@oracle.com>
References: <1608314848-67329-1-git-send-email-bijan.mottahedeh@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9839 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0
 mlxlogscore=999 spamscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012180124
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9839 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 impostorscore=0 lowpriorityscore=0 clxscore=1015 spamscore=0
 malwarescore=0 priorityscore=1501 phishscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012180124
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Apply fixed_rsrc functionality for fixed buffers support.

Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
---
 fs/io_uring.c | 242 +++++++++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 206 insertions(+), 36 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index bad2477..bac2813 100644
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
 
@@ -2962,6 +2970,15 @@ static void kiocb_done(struct kiocb *kiocb, ssize_t ret,
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
@@ -2975,7 +2992,7 @@ static ssize_t io_import_fixed(struct io_kiocb *req, int rw,
 	if (unlikely(buf_index >= ctx->nr_user_bufs))
 		return -EFAULT;
 	index = array_index_nospec(buf_index, ctx->nr_user_bufs);
-	imu = &ctx->user_bufs[index];
+	imu = io_buf_from_index(ctx, index);
 	buf_addr = req->rw.addr;
 
 	/* overflow */
@@ -8299,28 +8316,71 @@ static unsigned long ring_pages(unsigned sq_entries, unsigned cq_entries)
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
 
-	kfree(ctx->user_bufs);
-	ctx->user_bufs = NULL;
+	if (!data)
+		return;
+
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
 
@@ -8373,7 +8433,13 @@ static bool headpage_already_acct(struct io_ring_ctx *ctx, struct page **pages,
 
 	/* check previously registered pages */
 	for (i = 0; i < ctx->nr_user_bufs; i++) {
-		struct io_mapped_ubuf *imu = &ctx->user_bufs[i];
+		struct fixed_rsrc_table *table;
+		struct io_mapped_ubuf *imu;
+		unsigned int index;
+
+		table = &ctx->buf_data->table[i >> IORING_BUF_TABLE_SHIFT];
+		index = i & IORING_BUF_TABLE_MASK;
+		imu = &table->bufs[index];
 
 		for (j = 0; j < imu->nr_bvecs; j++) {
 			if (!PageCompound(imu->bvec[j].bv_page))
@@ -8508,19 +8574,79 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
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
+	io_free_buf_tables(buf_data, nr_tables);
+	return 1;
+}
+
+static struct fixed_rsrc_data *io_buffers_map_alloc(struct io_ring_ctx *ctx,
+						    unsigned int nr_args)
+{
+	unsigned nr_tables;
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
@@ -8540,39 +8666,82 @@ static int io_buffer_validate(struct iovec *iov)
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
+		struct fixed_rsrc_table *table;
+		struct io_mapped_ubuf *imu;
+		unsigned int index;
 
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
 
+		table = &buf_data->table[i >> IORING_BUF_TABLE_SHIFT];
+		index = i & IORING_BUF_TABLE_MASK;
+		imu = &table->bufs[index];
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
@@ -9351,7 +9520,7 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx *ctx, struct seq_file *m)
 	}
 	seq_printf(m, "UserBufs:\t%u\n", ctx->nr_user_bufs);
 	for (i = 0; has_lock && i < ctx->nr_user_bufs; i++) {
-		struct io_mapped_ubuf *buf = &ctx->user_bufs[i];
+		struct io_mapped_ubuf *buf = io_buf_from_index(ctx, i);
 
 		seq_printf(m, "%5u: 0x%llx/%u\n", i, buf->ubuf,
 						(unsigned int) buf->len);
@@ -9854,6 +10023,7 @@ static bool io_register_op_must_quiesce(int op)
 	switch (op) {
 	case IORING_UNREGISTER_FILES:
 	case IORING_REGISTER_FILES_UPDATE:
+	case IORING_UNREGISTER_BUFFERS:
 	case IORING_REGISTER_PROBE:
 	case IORING_REGISTER_PERSONALITY:
 	case IORING_UNREGISTER_PERSONALITY:
-- 
1.8.3.1

