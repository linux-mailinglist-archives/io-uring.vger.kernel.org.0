Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BADF32B1259
	for <lists+io-uring@lfdr.de>; Fri, 13 Nov 2020 00:03:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726460AbgKLXDM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 Nov 2020 18:03:12 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:54742 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726429AbgKLXDM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 Nov 2020 18:03:12 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0ACMtRki078855;
        Thu, 12 Nov 2020 23:03:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=I/fhLJ31/UavbroXKd87MFQMTTVIy1otYVmwzDgFtqU=;
 b=0YjAMsHPgFZyV7feCb5FD/lHZBk4XoWZKjL4YQJC6vln83RsIJBcOfsMGAc9iFmEZsCw
 6UBFLRNjJqk5MHJEzwoyyuC/NVDq/KFVpoI1FM3ccJcgwkleE4iAGZKNBPyjlVu6HldR
 iyBS9/4qdODkebhtXOVrsoV+hLM5ZoQHGV70p2ezH68+DthuGRafbo2t0A9a0xxy3Bl/
 BtI/7f1nbQNlXo1hFNp3ITTsuVK+NhjKV9WbdtQJxdWQvTYwszaawV7WNBXaX2JNtNCh
 f5zDBuzQN0LtcXHJIun1/sdgeguamK9d5DEbO2//7Wnxutv+N9E26i21HZiJH+B+Ht1H QQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 34p72ex9k2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 12 Nov 2020 23:03:09 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0ACMpCKq047964;
        Thu, 12 Nov 2020 23:01:09 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 34rt56tv2w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Nov 2020 23:01:09 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0ACN18p2011919;
        Thu, 12 Nov 2020 23:01:08 GMT
Received: from ca-ldom147.us.oracle.com (/10.129.68.131)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 12 Nov 2020 15:01:08 -0800
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk
Cc:     io-uring@vger.kernel.org
Subject: [PATCH 3/8] io_uring: generalize fixed file functionality
Date:   Thu, 12 Nov 2020 15:00:37 -0800
Message-Id: <1605222042-44558-4-git-send-email-bijan.mottahedeh@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1605222042-44558-1-git-send-email-bijan.mottahedeh@oracle.com>
References: <1605222042-44558-1-git-send-email-bijan.mottahedeh@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9803 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=999 suspectscore=4 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011120129
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9803 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 suspectscore=4 lowpriorityscore=0 adultscore=0 phishscore=0
 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011120129
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Generalize fixed_file functionality to fixed_rsrc in order to leverage
it for fixed buffers.

Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
---
 fs/io_uring.c | 161 +++++++++++++++++++++++++++++++++-------------------------
 1 file changed, 92 insertions(+), 69 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c6aa8bf..974a619 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -195,23 +195,39 @@ struct io_mapped_ubuf {
 	unsigned long	acct_pages;
 };
 
-struct fixed_file_table {
-	struct file		**files;
+struct io_ring_ctx;
+
+struct io_rsrc_put {
+	struct list_head list;
+	union {
+		void *rsrc;
+		struct file *file;
+		struct io_mapped_ubuf *buf;
+	};
 };
 
-struct fixed_file_ref_node {
+struct fixed_rsrc_table {
+	union {
+		struct file		**files;
+		struct io_mapped_ubuf	*bufs;
+	};
+};
+
+struct fixed_rsrc_ref_node {
 	struct percpu_ref		refs;
 	struct list_head		node;
-	struct list_head		file_list;
-	struct fixed_file_data		*file_data;
+	struct list_head		rsrc_list;
+	struct fixed_rsrc_data		*rsrc_data;
+	void 				(*rsrc_put)(struct io_ring_ctx *ctx,
+						    struct io_rsrc_put *prsrc);
 	struct llist_node		llist;
 };
 
-struct fixed_file_data {
-	struct fixed_file_table		*table;
+struct fixed_rsrc_data {
+	struct fixed_rsrc_table		*table;
 	struct io_ring_ctx		*ctx;
 
-	struct fixed_file_ref_node	*node;
+	struct fixed_rsrc_ref_node	*node;
 	struct percpu_ref		refs;
 	struct completion		done;
 	struct list_head		ref_list;
@@ -318,7 +334,7 @@ struct io_ring_ctx {
 	 * readers must ensure that ->refs is alive as long as the file* is
 	 * used. Only updated through io_uring_register(2).
 	 */
-	struct fixed_file_data	*file_data;
+	struct fixed_rsrc_data	*file_data;
 	unsigned		nr_user_files;
 
 	/* if used, fixed mapped user buffers */
@@ -6270,7 +6286,7 @@ static struct io_wq_work *io_wq_submit_work(struct io_wq_work *work)
 static inline struct file *io_file_from_index(struct io_ring_ctx *ctx,
 					      int index)
 {
-	struct fixed_file_table *table;
+	struct fixed_rsrc_table *table;
 
 	table = &ctx->file_data->table[index >> IORING_FILE_TABLE_SHIFT];
 	return table->files[index & IORING_FILE_TABLE_MASK];
@@ -7136,18 +7152,18 @@ static void __io_sqe_files_unregister(struct io_ring_ctx *ctx)
 #endif
 }
 
-static void io_file_ref_kill(struct percpu_ref *ref)
+static void io_rsrc_ref_kill(struct percpu_ref *ref)
 {
-	struct fixed_file_data *data;
+	struct fixed_rsrc_data *data;
 
-	data = container_of(ref, struct fixed_file_data, refs);
+	data = container_of(ref, struct fixed_rsrc_data, refs);
 	complete(&data->done);
 }
 
 static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
 {
-	struct fixed_file_data *data = ctx->file_data;
-	struct fixed_file_ref_node *ref_node = NULL;
+	struct fixed_rsrc_data *data = ctx->file_data;
+	struct fixed_rsrc_ref_node *ref_node = NULL;
 	unsigned nr_tables, i;
 
 	if (!data)
@@ -7156,7 +7172,7 @@ static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
 	spin_lock(&data->lock);
 	if (!list_empty(&data->ref_list))
 		ref_node = list_first_entry(&data->ref_list,
-				struct fixed_file_ref_node, node);
+				struct fixed_rsrc_ref_node, node);
 	spin_unlock(&data->lock);
 	if (ref_node)
 		percpu_ref_kill(&ref_node->refs);
@@ -7398,13 +7414,13 @@ static int io_sqe_files_scm(struct io_ring_ctx *ctx)
 }
 #endif
 
-static int io_sqe_alloc_file_tables(struct fixed_file_data *file_data,
+static int io_sqe_alloc_file_tables(struct fixed_rsrc_data *file_data,
 				    unsigned nr_tables, unsigned nr_files)
 {
 	int i;
 
 	for (i = 0; i < nr_tables; i++) {
-		struct fixed_file_table *table = &file_data->table[i];
+		struct fixed_rsrc_table *table = &file_data->table[i];
 		unsigned this_files;
 
 		this_files = min(nr_files, IORING_MAX_FILES_TABLE);
@@ -7419,14 +7435,15 @@ static int io_sqe_alloc_file_tables(struct fixed_file_data *file_data,
 		return 0;
 
 	for (i = 0; i < nr_tables; i++) {
-		struct fixed_file_table *table = &file_data->table[i];
+		struct fixed_rsrc_table *table = &file_data->table[i];
 		kfree(table->files);
 	}
 	return 1;
 }
 
-static void io_ring_file_put(struct io_ring_ctx *ctx, struct file *file)
+static void io_ring_file_put(struct io_ring_ctx *ctx, struct io_rsrc_put *prsrc)
 {
+	struct file *file = prsrc->file;
 #if defined(CONFIG_UNIX)
 	struct sock *sock = ctx->ring_sock->sk;
 	struct sk_buff_head list, *head = &sock->sk_receive_queue;
@@ -7487,30 +7504,38 @@ static void io_ring_file_put(struct io_ring_ctx *ctx, struct file *file)
 #endif
 }
 
-struct io_file_put {
-	struct list_head list;
-	struct file *file;
-};
-
-static void __io_file_put_work(struct fixed_file_ref_node *ref_node)
+static void __io_rsrc_put_work(struct fixed_rsrc_ref_node *ref_node)
 {
-	struct fixed_file_data *file_data = ref_node->file_data;
-	struct io_ring_ctx *ctx = file_data->ctx;
-	struct io_file_put *pfile, *tmp;
+	struct fixed_rsrc_data *rsrc_data = ref_node->rsrc_data;
+	struct io_ring_ctx *ctx = rsrc_data->ctx;
+	struct io_rsrc_put *prsrc, *tmp;
 
-	list_for_each_entry_safe(pfile, tmp, &ref_node->file_list, list) {
-		list_del(&pfile->list);
-		io_ring_file_put(ctx, pfile->file);
-		kfree(pfile);
+	list_for_each_entry_safe(prsrc, tmp, &ref_node->rsrc_list, list) {
+		list_del(&prsrc->list);
+		ref_node->rsrc_put(ctx, prsrc);
+		kfree(prsrc);
 	}
 
-	spin_lock(&file_data->lock);
+	spin_lock(&rsrc_data->lock);
 	list_del(&ref_node->node);
-	spin_unlock(&file_data->lock);
+	spin_unlock(&rsrc_data->lock);
 
 	percpu_ref_exit(&ref_node->refs);
 	kfree(ref_node);
-	percpu_ref_put(&file_data->refs);
+	percpu_ref_put(&rsrc_data->refs);
+}
+
+static void io_rsrc_put_work(struct llist_node *node)
+{
+	struct fixed_rsrc_ref_node *ref_node;
+	struct llist_node *next;
+
+	while (node) {
+		next = node->next;
+		ref_node = llist_entry(node, struct fixed_rsrc_ref_node, llist);
+		__io_rsrc_put_work(ref_node);
+		node = next;
+	}
 }
 
 static void io_file_put_work(struct work_struct *work)
@@ -7520,26 +7545,18 @@ static void io_file_put_work(struct work_struct *work)
 
 	ctx = container_of(work, struct io_ring_ctx, file_put_work.work);
 	node = llist_del_all(&ctx->file_put_llist);
-
-	while (node) {
-		struct fixed_file_ref_node *ref_node;
-		struct llist_node *next = node->next;
-
-		ref_node = llist_entry(node, struct fixed_file_ref_node, llist);
-		__io_file_put_work(ref_node);
-		node = next;
-	}
+	io_rsrc_put_work(node);
 }
 
 static void io_file_data_ref_zero(struct percpu_ref *ref)
 {
-	struct fixed_file_ref_node *ref_node;
+	struct fixed_rsrc_ref_node *ref_node;
 	struct io_ring_ctx *ctx;
 	bool first_add;
 	int delay = HZ;
 
-	ref_node = container_of(ref, struct fixed_file_ref_node, refs);
-	ctx = ref_node->file_data->ctx;
+	ref_node = container_of(ref, struct fixed_rsrc_ref_node, refs);
+	ctx = ref_node->rsrc_data->ctx;
 
 	if (percpu_ref_is_dying(&ctx->file_data->refs))
 		delay = 0;
@@ -7551,10 +7568,10 @@ static void io_file_data_ref_zero(struct percpu_ref *ref)
 		queue_delayed_work(system_wq, &ctx->file_put_work, delay);
 }
 
-static struct fixed_file_ref_node *alloc_fixed_file_ref_node(
+static struct fixed_rsrc_ref_node *alloc_fixed_file_ref_node(
 			struct io_ring_ctx *ctx)
 {
-	struct fixed_file_ref_node *ref_node;
+	struct fixed_rsrc_ref_node *ref_node;
 
 	ref_node = kzalloc(sizeof(*ref_node), GFP_KERNEL);
 	if (!ref_node)
@@ -7566,12 +7583,13 @@ static struct fixed_file_ref_node *alloc_fixed_file_ref_node(
 		return ERR_PTR(-ENOMEM);
 	}
 	INIT_LIST_HEAD(&ref_node->node);
-	INIT_LIST_HEAD(&ref_node->file_list);
-	ref_node->file_data = ctx->file_data;
+	INIT_LIST_HEAD(&ref_node->rsrc_list);
+	ref_node->rsrc_data = ctx->file_data;
+	ref_node->rsrc_put = io_ring_file_put;
 	return ref_node;
 }
 
-static void destroy_fixed_file_ref_node(struct fixed_file_ref_node *ref_node)
+static void destroy_fixed_file_ref_node(struct fixed_rsrc_ref_node *ref_node)
 {
 	percpu_ref_exit(&ref_node->refs);
 	kfree(ref_node);
@@ -7584,8 +7602,8 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 	unsigned nr_tables, i;
 	struct file *file;
 	int fd, ret = -ENOMEM;
-	struct fixed_file_ref_node *ref_node;
-	struct fixed_file_data *file_data;
+	struct fixed_rsrc_ref_node *ref_node;
+	struct fixed_rsrc_data *file_data;
 
 	if (ctx->file_data)
 		return -EBUSY;
@@ -7608,7 +7626,7 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 	if (!file_data->table)
 		goto out_free;
 
-	if (percpu_ref_init(&file_data->refs, io_file_ref_kill,
+	if (percpu_ref_init(&file_data->refs, io_rsrc_ref_kill,
 				PERCPU_REF_ALLOW_REINIT, GFP_KERNEL))
 		goto out_free;
 
@@ -7617,7 +7635,7 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 	ctx->file_data = file_data;
 
 	for (i = 0; i < nr_args; i++, ctx->nr_user_files++) {
-		struct fixed_file_table *table;
+		struct fixed_rsrc_table *table;
 		unsigned index;
 
 		if (copy_from_user(&fd, &fds[i], sizeof(fd))) {
@@ -7728,28 +7746,33 @@ static int io_sqe_file_register(struct io_ring_ctx *ctx, struct file *file,
 #endif
 }
 
-static int io_queue_file_removal(struct fixed_file_data *data,
-				 struct file *file)
+static int io_queue_rsrc_removal(struct fixed_rsrc_data *data, void *rsrc)
 {
-	struct io_file_put *pfile;
-	struct fixed_file_ref_node *ref_node = data->node;
+	struct io_rsrc_put *prsrc;
+	struct fixed_rsrc_ref_node *ref_node = data->node;
 
-	pfile = kzalloc(sizeof(*pfile), GFP_KERNEL);
-	if (!pfile)
+	prsrc = kzalloc(sizeof(*prsrc), GFP_KERNEL);
+	if (!prsrc)
 		return -ENOMEM;
 
-	pfile->file = file;
-	list_add(&pfile->list, &ref_node->file_list);
+	prsrc->rsrc = rsrc;
+	list_add(&prsrc->list, &ref_node->rsrc_list);
 
 	return 0;
 }
 
+static inline int io_queue_file_removal(struct fixed_rsrc_data *data,
+					struct file *file)
+{
+	return io_queue_rsrc_removal(data, (void *)file);
+}
+
 static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 				 struct io_uring_files_update *up,
 				 unsigned nr_args)
 {
-	struct fixed_file_data *data = ctx->file_data;
-	struct fixed_file_ref_node *ref_node;
+	struct fixed_rsrc_data *data = ctx->file_data;
+	struct fixed_rsrc_ref_node *ref_node;
 	struct file *file;
 	__s32 __user *fds;
 	int fd, i, err;
@@ -7768,7 +7791,7 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 	done = 0;
 	fds = u64_to_user_ptr(up->fds);
 	while (nr_args) {
-		struct fixed_file_table *table;
+		struct fixed_rsrc_table *table;
 		unsigned index;
 
 		err = 0;
@@ -9182,7 +9205,7 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx *ctx, struct seq_file *m)
 	seq_printf(m, "SqThreadCpu:\t%d\n", sq ? task_cpu(sq->thread) : -1);
 	seq_printf(m, "UserFiles:\t%u\n", ctx->nr_user_files);
 	for (i = 0; has_lock && i < ctx->nr_user_files; i++) {
-		struct fixed_file_table *table;
+		struct fixed_rsrc_table *table;
 		struct file *f;
 
 		table = &ctx->file_data->table[i >> IORING_FILE_TABLE_SHIFT];
-- 
1.8.3.1

