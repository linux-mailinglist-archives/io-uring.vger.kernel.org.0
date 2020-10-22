Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29DDF296793
	for <lists+io-uring@lfdr.de>; Fri, 23 Oct 2020 01:14:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S373216AbgJVXOW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 22 Oct 2020 19:14:22 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:59684 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S373279AbgJVXOW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 22 Oct 2020 19:14:22 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09MN9Cju035101;
        Thu, 22 Oct 2020 23:14:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=8FKZy3A/j176SupR8eKH3+YbvD3moCfSOZVBwN3mb10=;
 b=EwUO9FtYF0Tx3Ho0xq/wz4oXmOcvxLf73PeQRLRrMrBagO3GUh9PRplLdwUR0IzW3kR2
 piksicYJUXtwT2N46Byeduc6Co83Mu6m/SmcRmsJX6JmijhpKn7tz9D3CUMTVbVcYBRa
 +w0PkxpqYbLjv0mt4+Hy1yicDTXeVEfynFkafmFx8vVE1fP7/iOfQ/uULfk+JawGiuZF
 jg4OMremds46GmcGt9l0W4244ZzhQctIiM6um4t9nd8XHCoJQe/E7lX8KBIc2loKUtTS
 B6UBRlHccxzyKXWVY7Ne6hTXxiGuFszmPuPqEw7PlJLHfaux3y5FtBtBtn00gUvI48E8 QQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 347p4b8nax-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 22 Oct 2020 23:14:18 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09MN61mO084597;
        Thu, 22 Oct 2020 23:14:17 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 34ak1aeqqc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Oct 2020 23:14:17 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09MNEG67022651;
        Thu, 22 Oct 2020 23:14:16 GMT
Received: from ca-ldom147.us.oracle.com (/10.129.68.131)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 22 Oct 2020 16:14:16 -0700
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk, io-uring@vger.kernel.org
Subject: [RFC 4/8] io_uring: implement fixed buffers registration similar to fixed files
Date:   Thu, 22 Oct 2020 16:13:59 -0700
Message-Id: <1603408443-51303-5-git-send-email-bijan.mottahedeh@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1603408443-51303-1-git-send-email-bijan.mottahedeh@oracle.com>
References: <1603408443-51303-1-git-send-email-bijan.mottahedeh@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9782 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 mlxscore=0 phishscore=0
 spamscore=0 adultscore=0 mlxlogscore=999 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010220148
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9782 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 priorityscore=1501
 clxscore=1015 malwarescore=0 mlxscore=0 bulkscore=0 lowpriorityscore=0
 phishscore=0 adultscore=0 mlxlogscore=999 impostorscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010220148
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Apply fixed_rsrc functionality for fixed buffers support.

Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
---
 fs/io_uring.c | 294 +++++++++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 258 insertions(+), 36 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 1996c15..daf32d3 100644
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
@@ -337,8 +345,8 @@ struct io_ring_ctx {
 	unsigned		nr_user_files;
 
 	/* if used, fixed mapped user buffers */
+	struct fixed_rsrc_data	*buf_data;
 	unsigned		nr_user_bufs;
-	struct io_mapped_ubuf	*user_bufs;
 
 	struct user_struct	*user;
 
@@ -400,6 +408,9 @@ struct io_ring_ctx {
 	struct delayed_work		file_put_work;
 	struct llist_head		file_put_llist;
 
+	struct delayed_work		buf_put_work;
+	struct llist_head		buf_put_llist;
+
 	struct work_struct		exit_work;
 	struct io_restriction		restrictions;
 };
@@ -971,6 +982,7 @@ static struct file *io_file_get(struct io_submit_state *state,
 				struct io_kiocb *req, int fd, bool fixed);
 static void __io_queue_sqe(struct io_kiocb *req, struct io_comp_state *cs);
 static void io_file_put_work(struct work_struct *work);
+static void io_buf_put_work(struct work_struct *work);
 
 static ssize_t io_import_iovec(int rw, struct io_kiocb *req,
 			       struct iovec **iovec, struct iov_iter *iter,
@@ -1179,6 +1191,8 @@ static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	INIT_LIST_HEAD(&ctx->inflight_list);
 	INIT_DELAYED_WORK(&ctx->file_put_work, io_file_put_work);
 	init_llist_head(&ctx->file_put_llist);
+	INIT_DELAYED_WORK(&ctx->buf_put_work, io_buf_put_work);
+	init_llist_head(&ctx->buf_put_llist);
 	return ctx;
 err:
 	if (ctx->fallback_req)
@@ -2855,6 +2869,15 @@ static void kiocb_done(struct kiocb *kiocb, ssize_t ret,
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
@@ -2865,10 +2888,15 @@ static ssize_t io_import_fixed(struct io_kiocb *req, int rw,
 	size_t offset;
 	u64 buf_addr;
 
+	/* attempt to use fixed buffers without having provided iovecs */
+	if (unlikely(!ctx->buf_data))
+		return -EFAULT;
+
+	buf_index = req->buf_index;
 	if (unlikely(buf_index >= ctx->nr_user_bufs))
 		return -EFAULT;
 	index = array_index_nospec(buf_index, ctx->nr_user_bufs);
-	imu = &ctx->user_bufs[index];
+	imu = io_buf_from_index(ctx, index);
 	buf_addr = req->rw.addr;
 
 	/* overflow */
@@ -7969,28 +7997,73 @@ static unsigned long ring_pages(unsigned sq_entries, unsigned cq_entries)
 	return pages;
 }
 
-static int io_sqe_buffers_unregister(struct io_ring_ctx *ctx)
+static void io_buffer_unmap(struct io_ring_ctx *ctx, struct io_mapped_ubuf *imu)
 {
-	int i, j;
+	unsigned i;
 
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
+	unsigned i;
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
+	unsigned nr_tables, i;
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
+	spin_lock(&data->lock);
+	if (!list_empty(&data->ref_list))
+		ref_node = list_first_entry(&data->ref_list,
+					    struct fixed_rsrc_ref_node, node);
+	spin_unlock(&data->lock);
+	if (ref_node)
+		percpu_ref_kill(&ref_node->refs);
+
+	percpu_ref_kill(&data->refs);
+
+	/* wait for all refs nodes to complete */
+	flush_delayed_work(&ctx->buf_put_work);
+	wait_for_completion(&data->done);
+
+	io_buffers_unmap(ctx);
+	io_buffers_map_free(ctx);
+
 	return 0;
 }
 
@@ -8043,7 +8116,13 @@ static bool headpage_already_acct(struct io_ring_ctx *ctx, struct page **pages,
 
 	/* check previously registered pages */
 	for (i = 0; i < ctx->nr_user_bufs; i++) {
-		struct io_mapped_ubuf *imu = &ctx->user_bufs[i];
+		struct fixed_rsrc_table *table;
+		struct io_mapped_ubuf *imu;
+		unsigned index;
+
+		table = &ctx->buf_data->table[i >> IORING_BUF_TABLE_SHIFT];
+		index = i & IORING_BUF_TABLE_MASK;
+		imu = &table->bufs[index];
 
 		for (j = 0; j < imu->nr_bvecs; j++) {
 			if (!PageCompound(imu->bvec[j].bv_page))
@@ -8178,19 +8257,82 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
 	return ret;
 }
 
-static int io_buffers_map_alloc(struct io_ring_ctx *ctx, unsigned int nr_args)
+static void io_free_buf_tables(struct fixed_rsrc_data *buf_data,
+			       unsigned nr_tables)
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
+		kfree(table->bufs);
+	}
+}
 
-	return 0;
+static int io_alloc_buf_tables(struct fixed_rsrc_data *buf_data,
+			       unsigned nr_tables, unsigned nr_bufs)
+{
+	int i;
+		
+	for (i = 0; i < nr_tables; i++) {
+		struct fixed_rsrc_table *table = &buf_data->table[i];
+		unsigned this_bufs;
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
+	if (ctx->buf_data)
+		return ERR_PTR(-EBUSY);
+	if (!nr_args || nr_args > IORING_MAX_FIXED_BUFS)
+		return ERR_PTR(-EINVAL);
+
+	buf_data = kzalloc(sizeof(*ctx->buf_data), GFP_KERNEL);
+	if (!buf_data)
+		return ERR_PTR(-ENOMEM);
+	buf_data->ctx = ctx;
+	init_completion(&buf_data->done);
+	INIT_LIST_HEAD(&buf_data->ref_list);
+	spin_lock_init(&buf_data->lock);
+
+	nr_tables = DIV_ROUND_UP(nr_args, IORING_MAX_BUFS_TABLE);
+	buf_data->table = kcalloc(nr_tables, sizeof(buf_data->table),
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
@@ -8210,39 +8352,119 @@ static int io_buffer_validate(struct iovec *iov)
 	return 0;
 }
 
+static void io_buf_put_work(struct work_struct *work)
+{
+	struct io_ring_ctx *ctx;
+	struct llist_node *node;
+
+	ctx = container_of(work, struct io_ring_ctx, buf_put_work.work);
+	node = llist_del_all(&ctx->buf_put_llist);
+	io_rsrc_put_work(node);
+}
+
+static void io_buf_data_ref_zero(struct percpu_ref *ref)
+{
+	struct fixed_rsrc_ref_node *ref_node;
+	struct io_ring_ctx *ctx;
+	bool first_add;
+	int delay = HZ;
+
+	ref_node = container_of(ref, struct fixed_rsrc_ref_node, refs);
+	ctx = ref_node->rsrc_data->ctx;
+
+	if (percpu_ref_is_dying(&ctx->buf_data->refs))
+		delay = 0;
+
+	first_add = llist_add(&ref_node->llist, &ctx->buf_put_llist);
+	if (!delay)
+		mod_delayed_work(system_wq, &ctx->buf_put_work, 0);
+	else if (first_add)
+		queue_delayed_work(system_wq, &ctx->buf_put_work, delay);
+}
+
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
+	ref_node = kzalloc(sizeof(*ref_node), GFP_KERNEL);
+	if (!ref_node)
+		return ERR_PTR(-ENOMEM);
+
+	if (percpu_ref_init(&ref_node->refs, io_buf_data_ref_zero,
+			    0, GFP_KERNEL)) {
+		kfree(ref_node);
+		return ERR_PTR(-ENOMEM);
+	}
+	INIT_LIST_HEAD(&ref_node->node);
+	INIT_LIST_HEAD(&ref_node->rsrc_list);
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
+	buf_data = io_buffers_map_alloc(ctx, nr_args);
+	if (IS_ERR(buf_data))
+		return PTR_ERR(buf_data);
 
-	for (i = 0; i < nr_args; i++) {
-		struct io_mapped_ubuf *imu = &ctx->user_bufs[i];
+	for (i = 0; i < nr_args; i++, ctx->nr_user_bufs++) {
+		struct fixed_rsrc_table *table;
+		struct io_mapped_ubuf *imu;
+		unsigned index;
 
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
+	spin_lock(&buf_data->lock);
+	list_add(&ref_node->node, &buf_data->ref_list);
+	spin_unlock(&buf_data->lock);
+	percpu_ref_get(&buf_data->refs);
+	return 0;
 }
 
 static int io_eventfd_register(struct io_ring_ctx *ctx, void __user *arg)
@@ -9056,7 +9278,7 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx *ctx, struct seq_file *m)
 	}
 	seq_printf(m, "UserBufs:\t%u\n", ctx->nr_user_bufs);
 	for (i = 0; has_lock && i < ctx->nr_user_bufs; i++) {
-		struct io_mapped_ubuf *buf = &ctx->user_bufs[i];
+		struct io_mapped_ubuf *buf = io_buf_from_index(ctx, i);
 
 		seq_printf(m, "%5u: 0x%llx/%u\n", i, buf->ubuf,
 						(unsigned int) buf->len);
-- 
1.8.3.1

