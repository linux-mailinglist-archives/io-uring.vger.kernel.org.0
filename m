Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7338C11EA7D
	for <lists+io-uring@lfdr.de>; Fri, 13 Dec 2019 19:37:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728857AbfLMSgw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 13 Dec 2019 13:36:52 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:33988 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728877AbfLMSgu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 13 Dec 2019 13:36:50 -0500
Received: by mail-io1-f68.google.com with SMTP id z193so447662iof.1
        for <io-uring@vger.kernel.org>; Fri, 13 Dec 2019 10:36:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eyHlibCTkVJYSjXhuN43ilfR5yAlZnYweJ196QlE+p0=;
        b=ocdbt7Mdwfb2rLko+WXnuq3iVB270YFTr/ByltqObXinlPlP75JheWci0zfyvpAeb+
         s3nHgVco1BHdydeZbAki66ocP9/5TiHE6QfwotXNPaPx7iY4CJR4SQDDfiLrRtP/OkR4
         qJk850eQWBvcAtJgnd8Apf91Cwpb40jTYKzusndjPFDOa5MCocojltm2EsMXNQs7EgrP
         iuVIhFPBiLaUwa8EIllXpG1NCFG9JLC4CARXp+HwI7sePNyqmLrT+AVa3TGhZMliv/nu
         XSCvIMyDc0zLeAxMLr6SqB5iS7Qgg5jkNAidlRpmC5na/jzY1kyBNInBBZhK0dVKFDvr
         aU1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eyHlibCTkVJYSjXhuN43ilfR5yAlZnYweJ196QlE+p0=;
        b=GKzd8zXtkJ59WnKpYeJspHATyfLU87jqClTKDZsMHb9gSznfW6OxMB57iAxRHriKOP
         HqumU16fEdDurQq6lgiGK+WMGOa1vcMsUW9G+k4ZCkNdRaEpAaDEJob2UvJR9eZCPIt3
         rrNDVZm2Kvrf6hn+BzvTpmSlkEtLEgEhExHiQi3vE+6VOmCV7vqcD4PjeW2Xao9TBMbP
         jmFdDGErlY7N0hr1G3KmipJQdzhJYeMLl9HFvxx97JYBgzoC+pNzv0To19O8DHiKJmSA
         QSlEqwAHEcymPD1GVoiQ6JTReJZdXV6LZiNYw2bvCaWI0gI+fsc4AAOstvXoc2TOzXiA
         q4HA==
X-Gm-Message-State: APjAAAWkMZUbIHeDfG0kCKhH2QWc+7yTMS8KEvRWUbhi3JosY6JoD4Wc
        r5pgS1czn85IwnM5b68kx1JoByhdFw8mVQ==
X-Google-Smtp-Source: APXvYqzBumu32+8UFP/sVd5KSqEFHcxhFuctS/d3P9MTOesqxnxKL94zEHty/GWoqNgfnZiWICUj3A==
X-Received: by 2002:a5e:840f:: with SMTP id h15mr9107225ioj.286.1576262209025;
        Fri, 13 Dec 2019 10:36:49 -0800 (PST)
Received: from x1.thefacebook.com ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id w24sm2932031ilk.4.2019.12.13.10.36.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Dec 2019 10:36:48 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 10/10] io_uring: avoid ring quiesce for fixed file set unregister and update
Date:   Fri, 13 Dec 2019 11:36:32 -0700
Message-Id: <20191213183632.19441-11-axboe@kernel.dk>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191213183632.19441-1-axboe@kernel.dk>
References: <20191213183632.19441-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We currently fully quiesce the ring before an unregister or update of
the fixed fileset. This is very expensive, and we can be a bit smarter
about this.

Add a percpu refcount for the file tables as a whole. Grab a percpu ref
when we use a registered file, and put it on completion. This is cheap
to do. Upon removal of a file from a set, switch the ref count to atomic
mode. When we hit zero ref on the completion side, then we know we can
drop the previously registered files. When the old files have been
dropped, switch the ref back to percpu mode for normal operation.

Since there's a period between doing the update and the kernel being
done with it, add a IORING_OP_FILES_UPDATE opcode that can perform the
same action. The application knows the update has completed when it gets
the CQE for it. Between doing the update and receiving this completion,
the application must continue to use the unregistered fd if submitting
IO on this particular file.

This takes the runtime of test/file-register from liburing from 14s to
about 0.7s.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c                 | 409 +++++++++++++++++++++++++---------
 include/uapi/linux/io_uring.h |   1 +
 2 files changed, 300 insertions(+), 110 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 6f169b5a6494..81219a631a6d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -179,6 +179,21 @@ struct fixed_file_table {
 	struct file		**files;
 };
 
+enum {
+	FFD_F_ATOMIC,
+};
+
+struct fixed_file_data {
+	struct fixed_file_table		*table;
+	struct io_ring_ctx		*ctx;
+
+	struct percpu_ref		refs;
+	struct llist_head		put_llist;
+	unsigned long			state;
+	struct work_struct		ref_work;
+	struct completion		done;
+};
+
 struct io_ring_ctx {
 	struct {
 		struct percpu_ref	refs;
@@ -231,7 +246,7 @@ struct io_ring_ctx {
 	 * readers must ensure that ->refs is alive as long as the file* is
 	 * used. Only updated through io_uring_register(2).
 	 */
-	struct fixed_file_table	*file_table;
+	struct fixed_file_data	*file_data;
 	unsigned		nr_user_files;
 
 	/* if used, fixed mapped user buffers */
@@ -431,6 +446,8 @@ static void io_double_put_req(struct io_kiocb *req);
 static void __io_double_put_req(struct io_kiocb *req);
 static struct io_kiocb *io_prep_linked_timeout(struct io_kiocb *req);
 static void io_queue_linked_timeout(struct io_kiocb *req);
+static int io_sqe_files_update(struct io_ring_ctx *ctx, void __user *arg,
+			       unsigned nr_args);
 
 static struct kmem_cache *req_cachep;
 
@@ -897,8 +914,12 @@ static void __io_free_req(struct io_kiocb *req)
 			putname(req->io->open.filename);
 		kfree(req->io);
 	}
-	if (req->file && !(req->flags & REQ_F_FIXED_FILE))
-		fput(req->file);
+	if (req->file) {
+		if (req->flags & REQ_F_FIXED_FILE)
+			percpu_ref_put(&ctx->file_data->refs);
+		else
+			fput(req->file);
+	}
 	if (req->flags & REQ_F_INFLIGHT) {
 		unsigned long flags;
 
@@ -3033,6 +3054,35 @@ static int io_async_cancel(struct io_kiocb *req, struct io_kiocb **nxt)
 	return 0;
 }
 
+static int io_files_update(struct io_kiocb *req, bool force_nonblock)
+{
+	const struct io_uring_sqe *sqe = req->sqe;
+	struct io_ring_ctx *ctx = req->ctx;
+	void __user *arg;
+	unsigned nr_args;
+	int ret;
+
+	if (sqe->flags || sqe->ioprio || sqe->fd || sqe->off || sqe->rw_flags)
+		return -EINVAL;
+	if (force_nonblock) {
+		req->work.flags |= IO_WQ_WORK_NEEDS_FILES;
+		return -EAGAIN;
+	}
+
+	nr_args = READ_ONCE(sqe->len);
+	arg = u64_to_user_ptr(READ_ONCE(sqe->addr));
+
+	mutex_lock(&ctx->uring_lock);
+	ret = io_sqe_files_update(ctx, arg, nr_args);
+	mutex_unlock(&ctx->uring_lock);
+
+	if (ret < 0)
+		req_set_fail_links(req);
+	io_cqring_add_event(req, ret);
+	io_put_req(req);
+	return 0;
+}
+
 static int io_req_defer_prep(struct io_kiocb *req, struct io_async_ctx *io)
 {
 	struct iovec inline_vecs[UIO_FASTIOV], *iovec = inline_vecs;
@@ -3067,6 +3117,8 @@ static int io_req_defer_prep(struct io_kiocb *req, struct io_async_ctx *io)
 	case IORING_OP_OPENAT:
 		ret = io_openat_prep(req, io);
 		break;
+	case IORING_OP_FILES_UPDATE:
+		return -EINVAL;
 	default:
 		req->io = io;
 		return 0;
@@ -3182,6 +3234,9 @@ static int io_issue_sqe(struct io_kiocb *req, struct io_kiocb **nxt,
 	case IORING_OP_CLOSE:
 		ret = io_close(req, nxt, force_nonblock);
 		break;
+	case IORING_OP_FILES_UPDATE:
+		ret = io_files_update(req, force_nonblock);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
@@ -3295,8 +3350,8 @@ static inline struct file *io_file_from_index(struct io_ring_ctx *ctx,
 {
 	struct fixed_file_table *table;
 
-	table = &ctx->file_table[index >> IORING_FILE_TABLE_SHIFT];
-	return table->files[index & IORING_FILE_TABLE_MASK];
+	table = &ctx->file_data->table[index >> IORING_FILE_TABLE_SHIFT];
+	return table->files[index & IORING_FILE_TABLE_MASK];;
 }
 
 static int io_req_set_file(struct io_submit_state *state, struct io_kiocb *req)
@@ -3316,7 +3371,7 @@ static int io_req_set_file(struct io_submit_state *state, struct io_kiocb *req)
 		return ret;
 
 	if (flags & IOSQE_FIXED_FILE) {
-		if (unlikely(!ctx->file_table ||
+		if (unlikely(!ctx->file_data ||
 		    (unsigned) fd >= ctx->nr_user_files))
 			return -EBADF;
 		fd = array_index_nospec(fd, ctx->nr_user_files);
@@ -3324,6 +3379,7 @@ static int io_req_set_file(struct io_submit_state *state, struct io_kiocb *req)
 		if (!req->file)
 			return -EBADF;
 		req->flags |= REQ_F_FIXED_FILE;
+		percpu_ref_get(&ctx->file_data->refs);
 	} else {
 		if (req->needs_fixed_file)
 			return -EBADF;
@@ -4000,19 +4056,33 @@ static void __io_sqe_files_unregister(struct io_ring_ctx *ctx)
 #endif
 }
 
+static void io_file_ref_kill(struct percpu_ref *ref)
+{
+	struct fixed_file_data *data;
+
+	data = container_of(ref, struct fixed_file_data, refs);
+	complete(&data->done);
+}
+
 static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
 {
+	struct fixed_file_data *data = ctx->file_data;
 	unsigned nr_tables, i;
 
-	if (!ctx->file_table)
+	if (!data)
 		return -ENXIO;
 
+	percpu_ref_kill_and_confirm(&data->refs, io_file_ref_kill);
+	wait_for_completion(&data->done);
+	percpu_ref_exit(&data->refs);
+
 	__io_sqe_files_unregister(ctx);
 	nr_tables = DIV_ROUND_UP(ctx->nr_user_files, IORING_MAX_FILES_TABLE);
 	for (i = 0; i < nr_tables; i++)
-		kfree(ctx->file_table[i].files);
-	kfree(ctx->file_table);
-	ctx->file_table = NULL;
+		kfree(data->table[i].files);
+	kfree(data->table);
+	kfree(data);
+	ctx->file_data = NULL;
 	ctx->nr_user_files = 0;
 	return 0;
 }
@@ -4162,7 +4232,7 @@ static int io_sqe_alloc_file_tables(struct io_ring_ctx *ctx, unsigned nr_tables,
 	int i;
 
 	for (i = 0; i < nr_tables; i++) {
-		struct fixed_file_table *table = &ctx->file_table[i];
+		struct fixed_file_table *table = &ctx->file_data->table[i];
 		unsigned this_files;
 
 		this_files = min(nr_files, IORING_MAX_FILES_TABLE);
@@ -4177,36 +4247,158 @@ static int io_sqe_alloc_file_tables(struct io_ring_ctx *ctx, unsigned nr_tables,
 		return 0;
 
 	for (i = 0; i < nr_tables; i++) {
-		struct fixed_file_table *table = &ctx->file_table[i];
+		struct fixed_file_table *table = &ctx->file_data->table[i];
 		kfree(table->files);
 	}
 	return 1;
 }
 
+static void io_ring_file_put(struct io_ring_ctx *ctx, struct file *file)
+{
+#if defined(CONFIG_UNIX)
+	struct sock *sock = ctx->ring_sock->sk;
+	struct sk_buff_head list, *head = &sock->sk_receive_queue;
+	struct sk_buff *skb;
+	int i;
+
+	__skb_queue_head_init(&list);
+
+	/*
+	 * Find the skb that holds this file in its SCM_RIGHTS. When found,
+	 * remove this entry and rearrange the file array.
+	 */
+	skb = skb_dequeue(head);
+	while (skb) {
+		struct scm_fp_list *fp;
+
+		fp = UNIXCB(skb).fp;
+		for (i = 0; i < fp->count; i++) {
+			int left;
+
+			if (fp->fp[i] != file)
+				continue;
+
+			unix_notinflight(fp->user, fp->fp[i]);
+			left = fp->count - 1 - i;
+			if (left) {
+				memmove(&fp->fp[i], &fp->fp[i + 1],
+						left * sizeof(struct file *));
+			}
+			fp->count--;
+			if (!fp->count) {
+				kfree_skb(skb);
+				skb = NULL;
+			} else {
+				__skb_queue_tail(&list, skb);
+			}
+			fput(file);
+			file = NULL;
+			break;
+		}
+
+		if (!file)
+			break;
+
+		__skb_queue_tail(&list, skb);
+
+		skb = skb_dequeue(head);
+	}
+
+	if (skb_peek(&list)) {
+		spin_lock_irq(&head->lock);
+		while ((skb = __skb_dequeue(&list)) != NULL)
+			__skb_queue_tail(head, skb);
+		spin_unlock_irq(&head->lock);
+	}
+#else
+	fput(file);
+#endif
+}
+
+struct io_file_put {
+	struct llist_node llist;
+	struct file *file;
+	struct completion *done;
+};
+
+static void io_ring_file_ref_switch(struct work_struct *work)
+{
+	struct io_file_put *pfile, *tmp;
+	struct fixed_file_data *data;
+	struct llist_node *node;
+
+	data = container_of(work, struct fixed_file_data, ref_work);
+
+	while ((node = llist_del_all(&data->put_llist)) != NULL) {
+		llist_for_each_entry_safe(pfile, tmp, node, llist) {
+			io_ring_file_put(data->ctx, pfile->file);
+			if (pfile->done)
+				complete(pfile->done);
+			else
+				kfree(pfile);
+		}
+	}
+
+	percpu_ref_get(&data->refs);
+	percpu_ref_switch_to_percpu(&data->refs);
+}
+
+static void io_file_data_ref_zero(struct percpu_ref *ref)
+{
+	struct fixed_file_data *data;
+
+	data = container_of(ref, struct fixed_file_data, refs);
+
+	/* we can't safely switch from inside this context, punt to wq */
+	queue_work(system_wq, &data->ref_work);
+}
+
 static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 				 unsigned nr_args)
 {
 	__s32 __user *fds = (__s32 __user *) arg;
 	unsigned nr_tables;
+	struct file *file;
 	int fd, ret = 0;
 	unsigned i;
 
-	if (ctx->file_table)
+	if (ctx->file_data)
 		return -EBUSY;
 	if (!nr_args)
 		return -EINVAL;
 	if (nr_args > IORING_MAX_FIXED_FILES)
 		return -EMFILE;
 
+	ctx->file_data = kzalloc(sizeof(*ctx->file_data), GFP_KERNEL);
+	if (!ctx->file_data)
+		return -ENOMEM;
+	ctx->file_data->ctx = ctx;
+	init_completion(&ctx->file_data->done);
+
 	nr_tables = DIV_ROUND_UP(nr_args, IORING_MAX_FILES_TABLE);
-	ctx->file_table = kcalloc(nr_tables, sizeof(struct fixed_file_table),
+	ctx->file_data->table = kcalloc(nr_tables,
+					sizeof(struct fixed_file_table),
 					GFP_KERNEL);
-	if (!ctx->file_table)
+	if (!ctx->file_data->table) {
+		kfree(ctx->file_data);
+		ctx->file_data = NULL;
 		return -ENOMEM;
+	}
+
+	if (percpu_ref_init(&ctx->file_data->refs, io_file_data_ref_zero,
+				PERCPU_REF_ALLOW_REINIT, GFP_KERNEL)) {
+		kfree(ctx->file_data->table);
+		kfree(ctx->file_data);
+		ctx->file_data = NULL;
+	}
+	ctx->file_data->put_llist.first = NULL;
+	INIT_WORK(&ctx->file_data->ref_work, io_ring_file_ref_switch);
 
 	if (io_sqe_alloc_file_tables(ctx, nr_tables, nr_args)) {
-		kfree(ctx->file_table);
-		ctx->file_table = NULL;
+		percpu_ref_exit(&ctx->file_data->refs);
+		kfree(ctx->file_data->table);
+		kfree(ctx->file_data);
+		ctx->file_data = NULL;
 		return -ENOMEM;
 	}
 
@@ -4223,13 +4415,14 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 			continue;
 		}
 
-		table = &ctx->file_table[i >> IORING_FILE_TABLE_SHIFT];
+		table = &ctx->file_data->table[i >> IORING_FILE_TABLE_SHIFT];
 		index = i & IORING_FILE_TABLE_MASK;
-		table->files[index] = fget(fd);
+		file = fget(fd);
 
 		ret = -EBADF;
-		if (!table->files[index])
+		if (!file)
 			break;
+
 		/*
 		 * Don't allow io_uring instances to be registered. If UNIX
 		 * isn't enabled, then this causes a reference cycle and this
@@ -4237,26 +4430,26 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 		 * handle it just fine, but there's still no point in allowing
 		 * a ring fd as it doesn't support regular read/write anyway.
 		 */
-		if (table->files[index]->f_op == &io_uring_fops) {
-			fput(table->files[index]);
+		if (file->f_op == &io_uring_fops) {
+			fput(file);
 			break;
 		}
 		ret = 0;
+		table->files[index] = file;
 	}
 
 	if (ret) {
 		for (i = 0; i < ctx->nr_user_files; i++) {
-			struct file *file;
-
 			file = io_file_from_index(ctx, i);
 			if (file)
 				fput(file);
 		}
 		for (i = 0; i < nr_tables; i++)
-			kfree(ctx->file_table[i].files);
+			kfree(ctx->file_data->table[i].files);
 
-		kfree(ctx->file_table);
-		ctx->file_table = NULL;
+		kfree(ctx->file_data->table);
+		kfree(ctx->file_data);
+		ctx->file_data = NULL;
 		ctx->nr_user_files = 0;
 		return ret;
 	}
@@ -4268,69 +4461,6 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 	return ret;
 }
 
-static void io_sqe_file_unregister(struct io_ring_ctx *ctx, int index)
-{
-#if defined(CONFIG_UNIX)
-	struct file *file = io_file_from_index(ctx, index);
-	struct sock *sock = ctx->ring_sock->sk;
-	struct sk_buff_head list, *head = &sock->sk_receive_queue;
-	struct sk_buff *skb;
-	int i;
-
-	__skb_queue_head_init(&list);
-
-	/*
-	 * Find the skb that holds this file in its SCM_RIGHTS. When found,
-	 * remove this entry and rearrange the file array.
-	 */
-	skb = skb_dequeue(head);
-	while (skb) {
-		struct scm_fp_list *fp;
-
-		fp = UNIXCB(skb).fp;
-		for (i = 0; i < fp->count; i++) {
-			int left;
-
-			if (fp->fp[i] != file)
-				continue;
-
-			unix_notinflight(fp->user, fp->fp[i]);
-			left = fp->count - 1 - i;
-			if (left) {
-				memmove(&fp->fp[i], &fp->fp[i + 1],
-						left * sizeof(struct file *));
-			}
-			fp->count--;
-			if (!fp->count) {
-				kfree_skb(skb);
-				skb = NULL;
-			} else {
-				__skb_queue_tail(&list, skb);
-			}
-			fput(file);
-			file = NULL;
-			break;
-		}
-
-		if (!file)
-			break;
-
-		__skb_queue_tail(&list, skb);
-
-		skb = skb_dequeue(head);
-	}
-
-	if (skb_peek(&list)) {
-		spin_lock_irq(&head->lock);
-		while ((skb = __skb_dequeue(&list)) != NULL)
-			__skb_queue_tail(head, skb);
-		spin_unlock_irq(&head->lock);
-	}
-#else
-	fput(io_file_from_index(ctx, index));
-#endif
-}
-
 static int io_sqe_file_register(struct io_ring_ctx *ctx, struct file *file,
 				int index)
 {
@@ -4374,15 +4504,59 @@ static int io_sqe_file_register(struct io_ring_ctx *ctx, struct file *file,
 #endif
 }
 
+static void io_atomic_switch(struct percpu_ref *ref)
+{
+	struct fixed_file_data *data;
+
+	data = container_of(ref, struct fixed_file_data, refs);
+	clear_bit(FFD_F_ATOMIC, &data->state);
+}
+
+static bool io_queue_file_removal(struct fixed_file_data *data,
+				  struct file *file)
+{
+	struct io_file_put *pfile, pfile_stack;
+	DECLARE_COMPLETION_ONSTACK(done);
+
+	/*
+	 * If we fail allocating the struct we need for doing async reomval
+	 * of this file, just punt to sync and wait for it.
+	 */
+	pfile = kzalloc(sizeof(*pfile), GFP_KERNEL);
+	if (!pfile) {
+		pfile = &pfile_stack;
+		pfile->done = &done;
+	}
+
+	pfile->file = file;
+	llist_add(&pfile->llist, &data->put_llist);
+
+	if (pfile == &pfile_stack) {
+		if (!test_and_set_bit(FFD_F_ATOMIC, &data->state)) {
+			percpu_ref_put(&data->refs);
+			percpu_ref_switch_to_atomic(&data->refs,
+							io_atomic_switch);
+		}
+		wait_for_completion(&done);
+		flush_work(&data->ref_work);
+		return false;
+	}
+
+	return true;
+}
+
 static int io_sqe_files_update(struct io_ring_ctx *ctx, void __user *arg,
 			       unsigned nr_args)
 {
+	struct fixed_file_data *data = ctx->file_data;
 	struct io_uring_files_update up;
+	bool ref_switch = false;
+	struct file *file;
 	__s32 __user *fds;
 	int fd, i, err;
 	__u32 done;
 
-	if (!ctx->file_table)
+	if (!data)
 		return -ENXIO;
 	if (!nr_args)
 		return -EINVAL;
@@ -4405,15 +4579,15 @@ static int io_sqe_files_update(struct io_ring_ctx *ctx, void __user *arg,
 			break;
 		}
 		i = array_index_nospec(up.offset, ctx->nr_user_files);
-		table = &ctx->file_table[i >> IORING_FILE_TABLE_SHIFT];
+		table = &ctx->file_data->table[i >> IORING_FILE_TABLE_SHIFT];
 		index = i & IORING_FILE_TABLE_MASK;
 		if (table->files[index]) {
-			io_sqe_file_unregister(ctx, i);
+			file = io_file_from_index(ctx, index);
 			table->files[index] = NULL;
+			if (io_queue_file_removal(data, file))
+				ref_switch = true;
 		}
 		if (fd != -1) {
-			struct file *file;
-
 			file = fget(fd);
 			if (!file) {
 				err = -EBADF;
@@ -4442,6 +4616,11 @@ static int io_sqe_files_update(struct io_ring_ctx *ctx, void __user *arg,
 		up.offset++;
 	}
 
+	if (ref_switch && !test_and_set_bit(FFD_F_ATOMIC, &data->state)) {
+		percpu_ref_put(&data->refs);
+		percpu_ref_switch_to_atomic(&data->refs, io_atomic_switch);
+	}
+
 	return done ? done : err;
 }
 
@@ -4840,13 +5019,15 @@ static int io_eventfd_unregister(struct io_ring_ctx *ctx)
 
 static void io_ring_ctx_free(struct io_ring_ctx *ctx)
 {
+	/* do this before async shutdown, as we may need to queue work */
+	io_sqe_files_unregister(ctx);
+
 	io_finish_async(ctx);
 	if (ctx->sqo_mm)
 		mmdrop(ctx->sqo_mm);
 
 	io_iopoll_reap_events(ctx);
 	io_sqe_buffer_unregister(ctx);
-	io_sqe_files_unregister(ctx);
 	io_eventfd_unregister(ctx);
 
 #if defined(CONFIG_UNIX)
@@ -5360,18 +5541,22 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 	if (percpu_ref_is_dying(&ctx->refs))
 		return -ENXIO;
 
-	percpu_ref_kill(&ctx->refs);
+	if (opcode != IORING_UNREGISTER_FILES &&
+	    opcode != IORING_REGISTER_FILES_UPDATE) {
+		percpu_ref_kill(&ctx->refs);
 
-	/*
-	 * Drop uring mutex before waiting for references to exit. If another
-	 * thread is currently inside io_uring_enter() it might need to grab
-	 * the uring_lock to make progress. If we hold it here across the drain
-	 * wait, then we can deadlock. It's safe to drop the mutex here, since
-	 * no new references will come in after we've killed the percpu ref.
-	 */
-	mutex_unlock(&ctx->uring_lock);
-	wait_for_completion(&ctx->completions[0]);
-	mutex_lock(&ctx->uring_lock);
+		/*
+		 * Drop uring mutex before waiting for references to exit. If
+		 * another thread is currently inside io_uring_enter() it might
+		 * need to grab the uring_lock to make progress. If we hold it
+		 * here across the drain wait, then we can deadlock. It's safe
+		 * to drop the mutex here, since no new references will come in
+		 * after we've killed the percpu ref.
+		 */
+		mutex_unlock(&ctx->uring_lock);
+		wait_for_completion(&ctx->completions[0]);
+		mutex_lock(&ctx->uring_lock);
+	}
 
 	switch (opcode) {
 	case IORING_REGISTER_BUFFERS:
@@ -5412,9 +5597,13 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 		break;
 	}
 
-	/* bring the ctx back to life */
-	reinit_completion(&ctx->completions[0]);
-	percpu_ref_reinit(&ctx->refs);
+
+	if (opcode != IORING_UNREGISTER_FILES &&
+	    opcode != IORING_REGISTER_FILES_UPDATE) {
+		/* bring the ctx back to life */
+		reinit_completion(&ctx->completions[0]);
+		percpu_ref_reinit(&ctx->refs);
+	}
 	return ret;
 }
 
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 42a7f0e8dee3..cafee41efbe5 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -80,6 +80,7 @@ enum {
 	IORING_OP_FALLOCATE,
 	IORING_OP_OPENAT,
 	IORING_OP_CLOSE,
+	IORING_OP_FILES_UPDATE,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
-- 
2.24.1

