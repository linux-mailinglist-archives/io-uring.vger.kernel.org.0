Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CC5111D78F
	for <lists+io-uring@lfdr.de>; Thu, 12 Dec 2019 20:58:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730719AbfLLT6H (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 Dec 2019 14:58:07 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:40576 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730703AbfLLT6H (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 Dec 2019 14:58:07 -0500
Received: by mail-io1-f68.google.com with SMTP id x1so4109574iop.7
        for <io-uring@vger.kernel.org>; Thu, 12 Dec 2019 11:58:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=l+maOd4P+O7B5ETrIwc1oN9HxQ6W8b+FPnX2uuTQPPY=;
        b=GJ8kLZu+6KtFtjnH0X5PvMMyA57lHNse1t7bktPPXAr3JsubpKkT9Aol6J1qXbPjoN
         1wqjlbYsXjJHCfYCT9DQkSaIGZQ9PhE5dtOlICYNpuR90lpinouXqkzwmBIf0oi0Onfq
         ZrZlCVzOoq4YbgFCKWkg5fY6tfLbvH1usKRrXN1gRAn+/JC7UkabIWCiHZ+7SEwqZQH1
         NrWatVV37VXGFyMgzB/zK0b48iq6Orfj1oegzIx3h2pECCw+XhrW32imP9pX2bFJNvVk
         aIA5etNn+XyCcew4sHzEkzlU2hs5xWMdr6lfqp54JstBn3hQRMU8f/7D6QS8lOkq+iIE
         8dIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=l+maOd4P+O7B5ETrIwc1oN9HxQ6W8b+FPnX2uuTQPPY=;
        b=tAaPaoKpdOTiW1pm+jCB5b2FhrLeJh9nEWWRt8q/dKgIJDON2sLVqB/QptKw7U3DNJ
         piEtZMMHq1yyo943kU8UPlXr1MuQnIRd/Am7ZK/58NuisnfEwFqdvfrj0AP82HdylbtA
         i91aFoCP5tIFAo8LEkXmXWN+7TNuA/m3P1q4RRqxM4mkXVdr025+jcFxkQXDVXk/+2kK
         0qnq3Ghq9NiIdurc5P+yt61pT3myfKcxev1VgqE5SNXjZu+sNLp0jQdSBA84efQsGKx8
         BFDH8L/UfDeVKo5DFY0R/FqNc23pHeX4k3HtWJYyhXSe2AY98BOVIoQnd4pFxnmxjRfu
         DvZA==
X-Gm-Message-State: APjAAAWD2+So5/ERT2AdulwQ64TbQwKXAwR1LIl9+UDag5IFP94A8Q3S
        cFPpd8oonx+EJkr6nY/1NXFUzQ==
X-Google-Smtp-Source: APXvYqyaZLr9jLUxDZFm6WZBCeZQ274Xb4jQzck2Q7N/A2qrkROkZFfZy7vFzBqnrpZLShO9DXs3ng==
X-Received: by 2002:a02:8525:: with SMTP id g34mr9394230jai.72.1576180686149;
        Thu, 12 Dec 2019 11:58:06 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id v4sm1948688ile.60.2019.12.12.11.58.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Dec 2019 11:58:05 -0800 (PST)
To:     io-uring <io-uring@vger.kernel.org>
Cc:     Jann Horn <jannh@google.com>
From:   Jens Axboe <axboe@kernel.dk>
Subject: {ATCH v2] io_uring: avoid ring quiesce for fixed file set unregister
 and update
Message-ID: <b34773e2-dd18-e52e-9444-ad6135d15d7f@kernel.dk>
Date:   Thu, 12 Dec 2019 12:58:03 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
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

Changes since v1:
- Get rid of dirty work->files pointer trick
- Use private completion
- Fix issue with ring exit before file unregister
- Drop unnecessary READ_ONCE/WRITE_ONCE
- Fix race with switch
- Stop using internal percpu ref functions
- Fix percpu ref leak on table free

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e02ef8fbda51..6dfeeb9f63b1 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -177,6 +177,22 @@ struct fixed_file_table {
 	struct file		**files;
 };
 
+enum {
+	FFD_F_ATOMIC,
+	FFD_F_BUSY,
+};
+
+struct fixed_file_data {
+	struct fixed_file_table		*table;
+	struct io_ring_ctx		*ctx;
+
+	struct percpu_ref		refs;
+	struct llist_head		put_llist;
+	unsigned long			state;
+	struct io_wq_work		ref_work;
+	struct completion		done;
+};
+
 struct io_ring_ctx {
 	struct {
 		struct percpu_ref	refs;
@@ -229,7 +245,7 @@ struct io_ring_ctx {
 	 * readers must ensure that ->refs is alive as long as the file* is
 	 * used. Only updated through io_uring_register(2).
 	 */
-	struct fixed_file_table	*file_table;
+	struct fixed_file_data	*file_data;
 	unsigned		nr_user_files;
 
 	/* if used, fixed mapped user buffers */
@@ -424,6 +440,8 @@ static void io_double_put_req(struct io_kiocb *req);
 static void __io_double_put_req(struct io_kiocb *req);
 static struct io_kiocb *io_prep_linked_timeout(struct io_kiocb *req);
 static void io_queue_linked_timeout(struct io_kiocb *req);
+static int io_sqe_files_update(struct io_ring_ctx *ctx, void __user *arg,
+			       unsigned nr_args);
 
 static struct kmem_cache *req_cachep;
 
@@ -887,8 +905,12 @@ static void __io_free_req(struct io_kiocb *req)
 
 	if (req->io)
 		kfree(req->io);
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
 
@@ -2974,6 +2996,35 @@ static int io_async_cancel(struct io_kiocb *req, struct io_kiocb **nxt)
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
@@ -3005,6 +3056,8 @@ static int io_req_defer_prep(struct io_kiocb *req, struct io_async_ctx *io)
 		return io_timeout_prep(req, io, false);
 	case IORING_OP_LINK_TIMEOUT:
 		return io_timeout_prep(req, io, true);
+	case IORING_OP_FILES_UPDATE:
+		return -EINVAL;
 	default:
 		req->io = io;
 		return 0;
@@ -3120,6 +3173,9 @@ static int io_issue_sqe(struct io_kiocb *req, struct io_kiocb **nxt,
 	case IORING_OP_CLOSE:
 		ret = io_close(req, nxt, force_nonblock);
 		break;
+	case IORING_OP_FILES_UPDATE:
+		ret = io_files_update(req, force_nonblock);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
@@ -3233,8 +3289,8 @@ static inline struct file *io_file_from_index(struct io_ring_ctx *ctx,
 {
 	struct fixed_file_table *table;
 
-	table = &ctx->file_table[index >> IORING_FILE_TABLE_SHIFT];
-	return table->files[index & IORING_FILE_TABLE_MASK];
+	table = &ctx->file_data->table[index >> IORING_FILE_TABLE_SHIFT];
+	return table->files[index & IORING_FILE_TABLE_MASK];;
 }
 
 static int io_req_set_file(struct io_submit_state *state, struct io_kiocb *req)
@@ -3254,7 +3310,7 @@ static int io_req_set_file(struct io_submit_state *state, struct io_kiocb *req)
 		return ret;
 
 	if (flags & IOSQE_FIXED_FILE) {
-		if (unlikely(!ctx->file_table ||
+		if (unlikely(!ctx->file_data ||
 		    (unsigned) fd >= ctx->nr_user_files))
 			return -EBADF;
 		fd = array_index_nospec(fd, ctx->nr_user_files);
@@ -3262,6 +3318,7 @@ static int io_req_set_file(struct io_submit_state *state, struct io_kiocb *req)
 		if (!req->file)
 			return -EBADF;
 		req->flags |= REQ_F_FIXED_FILE;
+		percpu_ref_get(&ctx->file_data->refs);
 	} else {
 		if (req->needs_fixed_file)
 			return -EBADF;
@@ -3938,19 +3995,33 @@ static void __io_sqe_files_unregister(struct io_ring_ctx *ctx)
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
@@ -4100,7 +4171,7 @@ static int io_sqe_alloc_file_tables(struct io_ring_ctx *ctx, unsigned nr_tables,
 	int i;
 
 	for (i = 0; i < nr_tables; i++) {
-		struct fixed_file_table *table = &ctx->file_table[i];
+		struct fixed_file_table *table = &ctx->file_data->table[i];
 		unsigned this_files;
 
 		this_files = min(nr_files, IORING_MAX_FILES_TABLE);
@@ -4115,36 +4186,153 @@ static int io_sqe_alloc_file_tables(struct io_ring_ctx *ctx, unsigned nr_tables,
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
+static void io_ring_file_ref_switch(struct io_wq_work **workptr)
+{
+	struct fixed_file_data *data;
+	struct llist_node *node;
+	struct file *file, *tmp;
+
+	data = container_of(*workptr, struct fixed_file_data, ref_work);
+
+	while ((node = llist_del_all(&data->put_llist)) != NULL) {
+		llist_for_each_entry_safe(file, tmp, node, f_u.fu_llist)
+			io_ring_file_put(data->ctx, file);
+	}
+
+	percpu_ref_switch_to_percpu(&data->refs);
+	clear_bit(FFD_F_BUSY, &data->state);
+}
+
+static void io_file_data_ref_zero(struct percpu_ref *ref)
+{
+	struct fixed_file_data *data;
+
+	data = container_of(ref, struct fixed_file_data, refs);
+	if (test_and_set_bit(FFD_F_BUSY, &data->state))
+		return;
+	if (!llist_empty(&data->put_llist)) {
+		percpu_ref_get(&data->refs);
+		io_wq_enqueue(data->ctx->io_wq, &data->ref_work);
+	} else {
+		clear_bit(FFD_F_BUSY, &data->state);
+	}
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
+	INIT_IO_WORK(&ctx->file_data->ref_work, io_ring_file_ref_switch);
+	ctx->file_data->ref_work.flags = IO_WQ_WORK_INTERNAL;
 
 	if (io_sqe_alloc_file_tables(ctx, nr_tables, nr_args)) {
-		kfree(ctx->file_table);
-		ctx->file_table = NULL;
+		percpu_ref_exit(&ctx->file_data->refs);
+		kfree(ctx->file_data->table);
+		kfree(ctx->file_data);
+		ctx->file_data = NULL;
 		return -ENOMEM;
 	}
 
@@ -4161,13 +4349,14 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
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
@@ -4175,26 +4364,26 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
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
@@ -4206,69 +4395,6 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
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
@@ -4312,15 +4438,26 @@ static int io_sqe_file_register(struct io_ring_ctx *ctx, struct file *file,
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
 static int io_sqe_files_update(struct io_ring_ctx *ctx, void __user *arg,
 			       unsigned nr_args)
 {
+	struct fixed_file_data *data = ctx->file_data;
 	struct io_uring_files_update up;
+	bool did_unregister = false;
+	struct file *file;
 	__s32 __user *fds;
 	int fd, i, err;
 	__u32 done;
 
-	if (!ctx->file_table)
+	if (!data)
 		return -ENXIO;
 	if (!nr_args)
 		return -EINVAL;
@@ -4343,15 +4480,15 @@ static int io_sqe_files_update(struct io_ring_ctx *ctx, void __user *arg,
 			break;
 		}
 		i = array_index_nospec(up.offset, ctx->nr_user_files);
-		table = &ctx->file_table[i >> IORING_FILE_TABLE_SHIFT];
+		table = &ctx->file_data->table[i >> IORING_FILE_TABLE_SHIFT];
 		index = i & IORING_FILE_TABLE_MASK;
 		if (table->files[index]) {
-			io_sqe_file_unregister(ctx, i);
+			file = io_file_from_index(ctx, index);
+			llist_add(&file->f_u.fu_llist, &data->put_llist);
 			table->files[index] = NULL;
+			did_unregister = true;
 		}
 		if (fd != -1) {
-			struct file *file;
-
 			file = fget(fd);
 			if (!file) {
 				err = -EBADF;
@@ -4380,6 +4517,11 @@ static int io_sqe_files_update(struct io_ring_ctx *ctx, void __user *arg,
 		up.offset++;
 	}
 
+	if (did_unregister && !test_and_set_bit(FFD_F_ATOMIC, &data->state)) {
+		percpu_ref_put(&data->refs);
+		percpu_ref_switch_to_atomic(&data->refs, io_atomic_switch);
+	}
+
 	return done ? done : err;
 }
 
@@ -4778,13 +4920,15 @@ static int io_eventfd_unregister(struct io_ring_ctx *ctx)
 
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
@@ -5298,18 +5442,22 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
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
@@ -5350,9 +5498,13 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
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
Jens Axboe

