Return-Path: <io-uring+bounces-298-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C78BF819103
	for <lists+io-uring@lfdr.de>; Tue, 19 Dec 2023 20:44:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3DF6FB24CCC
	for <lists+io-uring@lfdr.de>; Tue, 19 Dec 2023 19:44:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F98A39846;
	Tue, 19 Dec 2023 19:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="hsLhFlns"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD7533D0A5
	for <io-uring@vger.kernel.org>; Tue, 19 Dec 2023 19:44:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1d03f03cda9so11212315ad.0
        for <io-uring@vger.kernel.org>; Tue, 19 Dec 2023 11:44:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1703015052; x=1703619852; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=95Gidald5O5LOVY/YTkCQtNRHeD7J4K2PB+/xTvFMNo=;
        b=hsLhFlnsLMClp18uYYvXXeQ0uKkqKlmsO68T6Zk+Id34iqKwC5V5DpK3tGqqfSqFAh
         HVRRe/bYOWVWm2wRlm/dCrQcf/Oo2b4beg17yLJ8ZBhLQ9XMUrFEhXOm5pzH8W5I5s80
         /124nWxhfV6kZ5xPmAO1xzgeJi24Mr7t6Vf/RESQhm9TjIUludZ62oH56C30nHgBwkb1
         8fduPYfpwQJCdSq0U1jwTMMkR2XhzIFSN1UUm9RJHhrb/O3c8uupOTQtTHZAR68TGpDD
         Zg6GDyJ/uoP9fg43kNxZ1TQnNNWXgb2OJhaB4npXssAShJ90YyPvx97vVex+Bv3U8KaH
         rqcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703015052; x=1703619852;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=95Gidald5O5LOVY/YTkCQtNRHeD7J4K2PB+/xTvFMNo=;
        b=JrMKW2VlulcaLdvNxkPrFzbb+xBR4rmKQGVTiIR5T+x0ZYsT82lGqrDI/LiS5RS7Hk
         tPUdPfHL+lbtdDoJhLWY4to69z0l+0N2fxjeqi/dIzFr4GmFWNa4O+hUn5i+9E6doK7D
         /A6NEGnk1zET81zxeOI7qxkw6tWdVzL58dXBu6QnBnFo8kPP486ybRUV9hSkX60cpJqS
         kPgcAJqMZbXSldccHzzHGaO4hnNCPx2j++hh5h5DmE053xlYB+3zdsFANGY7TfKEu3DJ
         h+WYU169ZBf6pk9liLDwDNssZzswLFhn2J2RkF+RGTtUgsbPnLAqsJjSPfeU5vMHQBxn
         jE0g==
X-Gm-Message-State: AOJu0YzMDf/olafe+T+yw3IrC821zu81sDvUylEJfPTkezz+E5Q5DtNA
	FQ4oDpFcg8WvrTCxFmaQ3QY65FINJEfvxmJvxnBUPw==
X-Google-Smtp-Source: AGHT+IF6eA093TW64b/rvWPz0Rl9AMhvMM25YwR7kyyKpCObOXkiW2UyyvYc5KcBL+EA5EtwO6U61g==
X-Received: by 2002:a17:902:b18d:b0:1d0:80db:a841 with SMTP id s13-20020a170902b18d00b001d080dba841mr36752167plr.3.1703015052583;
        Tue, 19 Dec 2023 11:44:12 -0800 (PST)
Received: from localhost.localdomain ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id b2-20020a170902bd4200b001d369beee67sm7083397plx.131.2023.12.19.11.44.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Dec 2023 11:44:11 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/2] io_uring: drop any code related to SCM_RIGHTS
Date: Tue, 19 Dec 2023 12:42:58 -0700
Message-ID: <20231219194401.591059-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231219194401.591059-1-axboe@kernel.dk>
References: <20231219194401.591059-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is dead code after we dropped support for passing io_uring fds
over SCM_RIGHTS, get rid of it.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/io_uring_types.h |   3 -
 io_uring/filetable.c           |  11 +--
 io_uring/io_uring.c            |  32 +------
 io_uring/rsrc.c                | 169 +--------------------------------
 io_uring/rsrc.h                |  15 ---
 5 files changed, 10 insertions(+), 220 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index bebab36abce8..fc8f2570b92b 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -389,9 +389,6 @@ struct io_ring_ctx {
 	struct wait_queue_head		rsrc_quiesce_wq;
 	unsigned			rsrc_quiesce;
 
-	#if defined(CONFIG_UNIX)
-		struct socket		*ring_sock;
-	#endif
 	/* hashed buffered write serialization */
 	struct io_wq_hash		*hash_map;
 
diff --git a/io_uring/filetable.c b/io_uring/filetable.c
index e7d749991de4..6e86e6188dbe 100644
--- a/io_uring/filetable.c
+++ b/io_uring/filetable.c
@@ -87,13 +87,10 @@ static int io_install_fixed_file(struct io_ring_ctx *ctx, struct file *file,
 		io_file_bitmap_clear(&ctx->file_table, slot_index);
 	}
 
-	ret = io_scm_file_account(ctx, file);
-	if (!ret) {
-		*io_get_tag_slot(ctx->file_data, slot_index) = 0;
-		io_fixed_file_set(file_slot, file);
-		io_file_bitmap_set(&ctx->file_table, slot_index);
-	}
-	return ret;
+	*io_get_tag_slot(ctx->file_data, slot_index) = 0;
+	io_fixed_file_set(file_slot, file);
+	io_file_bitmap_set(&ctx->file_table, slot_index);
+	return 0;
 }
 
 int __io_fixed_fd_install(struct io_ring_ctx *ctx, struct file *file,
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index a9acccd45880..a9a519fa9926 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -60,7 +60,6 @@
 #include <linux/net.h>
 #include <net/sock.h>
 #include <net/af_unix.h>
-#include <net/scm.h>
 #include <linux/anon_inodes.h>
 #include <linux/sched/mm.h>
 #include <linux/uaccess.h>
@@ -2866,13 +2865,6 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 		io_rsrc_node_destroy(ctx, ctx->rsrc_node);
 
 	WARN_ON_ONCE(!list_empty(&ctx->rsrc_ref_list));
-
-#if defined(CONFIG_UNIX)
-	if (ctx->ring_sock) {
-		ctx->ring_sock->file = NULL; /* so that iput() is called */
-		sock_release(ctx->ring_sock);
-	}
-#endif
 	WARN_ON_ONCE(!list_empty(&ctx->ltimeout_list));
 
 	io_alloc_cache_free(&ctx->rsrc_node_cache, io_rsrc_node_cache_free);
@@ -3781,32 +3773,12 @@ static int io_uring_install_fd(struct file *file)
 /*
  * Allocate an anonymous fd, this is what constitutes the application
  * visible backing of an io_uring instance. The application mmaps this
- * fd to gain access to the SQ/CQ ring details. If UNIX sockets are enabled,
- * we have to tie this fd to a socket for file garbage collection purposes.
+ * fd to gain access to the SQ/CQ ring details.
  */
 static struct file *io_uring_get_file(struct io_ring_ctx *ctx)
 {
-	struct file *file;
-#if defined(CONFIG_UNIX)
-	int ret;
-
-	ret = sock_create_kern(&init_net, PF_UNIX, SOCK_RAW, IPPROTO_IP,
-				&ctx->ring_sock);
-	if (ret)
-		return ERR_PTR(ret);
-#endif
-
-	file = anon_inode_getfile_secure("[io_uring]", &io_uring_fops, ctx,
+	return anon_inode_getfile_secure("[io_uring]", &io_uring_fops, ctx,
 					 O_RDWR | O_CLOEXEC, NULL);
-#if defined(CONFIG_UNIX)
-	if (IS_ERR(file)) {
-		sock_release(ctx->ring_sock);
-		ctx->ring_sock = NULL;
-	} else {
-		ctx->ring_sock->file = file;
-	}
-#endif
-	return file;
 }
 
 static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index f521c5965a93..4818b79231dd 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -24,7 +24,6 @@ struct io_rsrc_update {
 };
 
 static void io_rsrc_buf_put(struct io_ring_ctx *ctx, struct io_rsrc_put *prsrc);
-static void io_rsrc_file_put(struct io_ring_ctx *ctx, struct io_rsrc_put *prsrc);
 static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
 				  struct io_mapped_ubuf **pimu,
 				  struct page **last_hpage);
@@ -157,7 +156,7 @@ static void io_rsrc_put_work(struct io_rsrc_node *node)
 
 	switch (node->type) {
 	case IORING_RSRC_FILE:
-		io_rsrc_file_put(node->ctx, prsrc);
+		fput(prsrc->file);
 		break;
 	case IORING_RSRC_BUFFER:
 		io_rsrc_buf_put(node->ctx, prsrc);
@@ -402,23 +401,13 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 				break;
 			}
 			/*
-			 * Don't allow io_uring instances to be registered. If
-			 * UNIX isn't enabled, then this causes a reference
-			 * cycle and this instance can never get freed. If UNIX
-			 * is enabled we'll handle it just fine, but there's
-			 * still no point in allowing a ring fd as it doesn't
-			 * support regular read/write anyway.
+			 * Don't allow io_uring instances to be registered.
 			 */
 			if (io_is_uring_fops(file)) {
 				fput(file);
 				err = -EBADF;
 				break;
 			}
-			err = io_scm_file_account(ctx, file);
-			if (err) {
-				fput(file);
-				break;
-			}
 			*io_get_tag_slot(data, i) = tag;
 			io_fixed_file_set(file_slot, file);
 			io_file_bitmap_set(&ctx->file_table, i);
@@ -675,22 +664,12 @@ void __io_sqe_files_unregister(struct io_ring_ctx *ctx)
 	for (i = 0; i < ctx->nr_user_files; i++) {
 		struct file *file = io_file_from_index(&ctx->file_table, i);
 
-		/* skip scm accounted files, they'll be freed by ->ring_sock */
-		if (!file || io_file_need_scm(file))
+		if (!file)
 			continue;
 		io_file_bitmap_clear(&ctx->file_table, i);
 		fput(file);
 	}
 
-#if defined(CONFIG_UNIX)
-	if (ctx->ring_sock) {
-		struct sock *sock = ctx->ring_sock->sk;
-		struct sk_buff *skb;
-
-		while ((skb = skb_dequeue(&sock->sk_receive_queue)) != NULL)
-			kfree_skb(skb);
-	}
-#endif
 	io_free_file_tables(&ctx->file_table);
 	io_file_table_set_alloc_range(ctx, 0, 0);
 	io_rsrc_data_free(ctx->file_data);
@@ -718,137 +697,6 @@ int io_sqe_files_unregister(struct io_ring_ctx *ctx)
 	return ret;
 }
 
-/*
- * Ensure the UNIX gc is aware of our file set, so we are certain that
- * the io_uring can be safely unregistered on process exit, even if we have
- * loops in the file referencing. We account only files that can hold other
- * files because otherwise they can't form a loop and so are not interesting
- * for GC.
- */
-int __io_scm_file_account(struct io_ring_ctx *ctx, struct file *file)
-{
-#if defined(CONFIG_UNIX)
-	struct sock *sk = ctx->ring_sock->sk;
-	struct sk_buff_head *head = &sk->sk_receive_queue;
-	struct scm_fp_list *fpl;
-	struct sk_buff *skb;
-
-	if (likely(!io_file_need_scm(file)))
-		return 0;
-
-	/*
-	 * See if we can merge this file into an existing skb SCM_RIGHTS
-	 * file set. If there's no room, fall back to allocating a new skb
-	 * and filling it in.
-	 */
-	spin_lock_irq(&head->lock);
-	skb = skb_peek(head);
-	if (skb && UNIXCB(skb).fp->count < SCM_MAX_FD)
-		__skb_unlink(skb, head);
-	else
-		skb = NULL;
-	spin_unlock_irq(&head->lock);
-
-	if (!skb) {
-		fpl = kzalloc(sizeof(*fpl), GFP_KERNEL);
-		if (!fpl)
-			return -ENOMEM;
-
-		skb = alloc_skb(0, GFP_KERNEL);
-		if (!skb) {
-			kfree(fpl);
-			return -ENOMEM;
-		}
-
-		fpl->user = get_uid(current_user());
-		fpl->max = SCM_MAX_FD;
-		fpl->count = 0;
-
-		UNIXCB(skb).fp = fpl;
-		skb->sk = sk;
-		skb->destructor = io_uring_destruct_scm;
-		refcount_add(skb->truesize, &sk->sk_wmem_alloc);
-	}
-
-	fpl = UNIXCB(skb).fp;
-	fpl->fp[fpl->count++] = get_file(file);
-	unix_inflight(fpl->user, file);
-	skb_queue_head(head, skb);
-	fput(file);
-#endif
-	return 0;
-}
-
-static __cold void io_rsrc_file_scm_put(struct io_ring_ctx *ctx, struct file *file)
-{
-#if defined(CONFIG_UNIX)
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
-#endif
-}
-
-static void io_rsrc_file_put(struct io_ring_ctx *ctx, struct io_rsrc_put *prsrc)
-{
-	struct file *file = prsrc->file;
-
-	if (likely(!io_file_need_scm(file)))
-		fput(file);
-	else
-		io_rsrc_file_scm_put(ctx, file);
-}
-
 int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 			  unsigned nr_args, u64 __user *tags)
 {
@@ -897,21 +745,12 @@ int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 			goto fail;
 
 		/*
-		 * Don't allow io_uring instances to be registered. If UNIX
-		 * isn't enabled, then this causes a reference cycle and this
-		 * instance can never get freed. If UNIX is enabled we'll
-		 * handle it just fine, but there's still no point in allowing
-		 * a ring fd as it doesn't support regular read/write anyway.
+		 * Don't allow io_uring instances to be registered.
 		 */
 		if (io_is_uring_fops(file)) {
 			fput(file);
 			goto fail;
 		}
-		ret = io_scm_file_account(ctx, file);
-		if (ret) {
-			fput(file);
-			goto fail;
-		}
 		file_slot = io_fixed_file_slot(&ctx->file_table, i);
 		io_fixed_file_set(file_slot, file);
 		io_file_bitmap_set(&ctx->file_table, i);
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index 08ac0d8e07ef..7238b9cfe33b 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -75,21 +75,6 @@ int io_sqe_files_unregister(struct io_ring_ctx *ctx);
 int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 			  unsigned nr_args, u64 __user *tags);
 
-int __io_scm_file_account(struct io_ring_ctx *ctx, struct file *file);
-
-static inline bool io_file_need_scm(struct file *filp)
-{
-	return false;
-}
-
-static inline int io_scm_file_account(struct io_ring_ctx *ctx,
-				      struct file *file)
-{
-	if (likely(!io_file_need_scm(file)))
-		return 0;
-	return __io_scm_file_account(ctx, file);
-}
-
 int io_register_files_update(struct io_ring_ctx *ctx, void __user *arg,
 			     unsigned nr_args);
 int io_register_rsrc_update(struct io_ring_ctx *ctx, void __user *arg,
-- 
2.43.0


