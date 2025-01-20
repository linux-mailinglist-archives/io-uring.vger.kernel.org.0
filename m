Return-Path: <io-uring+bounces-6025-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D181A17268
	for <lists+io-uring@lfdr.de>; Mon, 20 Jan 2025 18:52:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7D4613A4727
	for <lists+io-uring@lfdr.de>; Mon, 20 Jan 2025 17:52:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DCFA1EBFF5;
	Mon, 20 Jan 2025 17:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ethancedwards.com header.i=@ethancedwards.com header.b="Ybz90yHg"
X-Original-To: io-uring@vger.kernel.org
Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [80.241.56.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F011AC2FB;
	Mon, 20 Jan 2025 17:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737395550; cv=none; b=n9BhztaMcpN/NvKLDAHY+3oRtMoJt2YJ/5PQ+hmgUT/kYKZdYETiYOjZoHYVL3NdKaTe4vJh8uzR4vveZvFdkIxPIqHMCxcZg8UXer4yA/5i9X/Tw+8uvNjjTWiScS7Q62vQY7SMJQL9sjE+AQAXj/9A5zEkBeejrNRAR0WxPUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737395550; c=relaxed/simple;
	bh=zyv3+iT+IUVjJ3jDedXN/NLma3ZxoykGZtqaSenQMRo=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=OQZcQYqY5eeeM5T26FQL2djOg4SK77goLHRQIvNFAQRw6rSJwahGvi9Yy/p75qYq7g22w7KbN34nlAP9jXXRpJ5u1he1gjI8eImtEpCZW2vCiGtyrFXVTYpgODNjO8m4zKvpD+fcgrlf0vRfcrb7evZPsDpfsZOJGhQj5ka+Yg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ethancedwards.com; spf=pass smtp.mailfrom=ethancedwards.com; dkim=pass (2048-bit key) header.d=ethancedwards.com header.i=@ethancedwards.com header.b=Ybz90yHg; arc=none smtp.client-ip=80.241.56.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ethancedwards.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ethancedwards.com
Received: from smtp1.mailbox.org (smtp1.mailbox.org [10.196.197.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4YcHwd2qhJz9scX;
	Mon, 20 Jan 2025 18:52:17 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ethancedwards.com;
	s=MBO0001; t=1737395537;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=RzJ6A/8XkNvlkMHWGhHeZis4634ZvC3LL/mr9c+Teoc=;
	b=Ybz90yHgnSulcJXTSv2fHiDmL2qEWVZC9pTm0UcGDDUFOCe7sktshvjaIwaS9LHisbHxLc
	dAhXE7d+VL0/CuJeN8ziZC75zehNLpdEPZlfj5ULDdMDxmTmjHbrygLxafz2MwrLQw6gzk
	PhTFLMU9FSuXM+u14FyYVBJsqnKqT7ANAWwNRmKaXQeoHI83hwBemevKJ9MBk4s1O/Inc9
	hsbZYouF2DFF+Juv0j7f8yCFRwut6bXU2OXhjcc5p4/kFIA6EURt/gOQShQYiOvSJ3K/yA
	q67nbzwXoPYMBfoFYlbrDrAp8LqP3TfHK42Ge1PQpHgY6We1FFFKGpiH90fkig==
Date: Mon, 20 Jan 2025 12:52:13 -0500
From: Ethan Carter Edwards <ethan@ethancedwards.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Pavel Begunkov <asml.silence@gmail.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] io_uring: change 'unsigned' to 'unsigned int'
Message-ID: <o3qnrb2qffnsogqtswyd4nvkgcl4yhjbb57oiduzs7epileol5@narvnqug6uym>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Prefer 'unsigned int' to bare 'unsigned', as reported by checkpatch.pl:
WARNING: Prefer 'unsigned int' to bare use of 'unsigned'.

Signed-off-by: Ethan Carter Edwards <ethan@ethancedwards.com>
---
 io_uring/cancel.c    |  2 +-
 io_uring/eventfd.c   |  2 +-
 io_uring/filetable.c |  2 +-
 io_uring/io-wq.c     |  8 ++++----
 io_uring/io_uring.c  | 26 +++++++++++++-------------
 io_uring/kbuf.c      |  8 ++++----
 io_uring/net.c       | 26 +++++++++++++-------------
 io_uring/notif.c     |  2 +-
 io_uring/poll.c      | 18 +++++++++---------
 io_uring/register.c  | 20 ++++++++++----------
 io_uring/rsrc.c      | 16 ++++++++--------
 io_uring/rw.c        |  6 +++---
 io_uring/sqpoll.c    |  2 +-
 io_uring/tctx.c      |  4 ++--
 io_uring/timeout.c   |  2 +-
 io_uring/uring_cmd.c |  6 +++---
 io_uring/waitid.c    |  2 +-
 17 files changed, 76 insertions(+), 76 deletions(-)

diff --git a/io_uring/cancel.c b/io_uring/cancel.c
index 484193567839..1595fb1fdf12 100644
--- a/io_uring/cancel.c
+++ b/io_uring/cancel.c
@@ -101,7 +101,7 @@ static int io_async_cancel_one(struct io_uring_task *tctx,
 }
 
 int io_try_cancel(struct io_uring_task *tctx, struct io_cancel_data *cd,
-		  unsigned issue_flags)
+		  unsigned int issue_flags)
 {
 	struct io_ring_ctx *ctx = cd->ctx;
 	int ret;
diff --git a/io_uring/eventfd.c b/io_uring/eventfd.c
index 100d5da94cb9..b480294a2595 100644
--- a/io_uring/eventfd.c
+++ b/io_uring/eventfd.c
@@ -15,7 +15,7 @@ struct io_ev_fd {
 	struct eventfd_ctx	*cq_ev_fd;
 	unsigned int		eventfd_async;
 	/* protected by ->completion_lock */
-	unsigned		last_cq_tail;
+	unsigned int		last_cq_tail;
 	refcount_t		refs;
 	atomic_t		ops;
 	struct rcu_head		rcu;
diff --git a/io_uring/filetable.c b/io_uring/filetable.c
index a21660e3145a..6428ecf6e3a6 100644
--- a/io_uring/filetable.c
+++ b/io_uring/filetable.c
@@ -37,7 +37,7 @@ static int io_file_bitmap_get(struct io_ring_ctx *ctx)
 }
 
 bool io_alloc_file_tables(struct io_ring_ctx *ctx, struct io_file_table *table,
-			  unsigned nr_files)
+			  unsigned int nr_files)
 {
 	if (io_rsrc_data_alloc(&table->data, nr_files))
 		return false;
diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index a38f36b68060..d5b2b9b8fa88 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -77,8 +77,8 @@ struct io_worker {
 #define IO_WQ_NR_HASH_BUCKETS	(1u << IO_WQ_HASH_ORDER)
 
 struct io_wq_acct {
-	unsigned nr_workers;
-	unsigned max_workers;
+	unsigned int nr_workers;
+	unsigned int max_workers;
 	int index;
 	atomic_t nr_running;
 	raw_spinlock_t lock;
@@ -1126,7 +1126,7 @@ enum io_wq_cancel io_wq_cancel_cb(struct io_wq *wq, work_cancel_fn *cancel,
 	return IO_WQ_CANCEL_NOTFOUND;
 }
 
-static int io_wq_hash_wake(struct wait_queue_entry *wait, unsigned mode,
+static int io_wq_hash_wake(struct wait_queue_entry *wait, unsigned int mode,
 			    int sync, void *key)
 {
 	struct io_wq *wq = container_of(wait, struct io_wq, wait);
@@ -1145,7 +1145,7 @@ static int io_wq_hash_wake(struct wait_queue_entry *wait, unsigned mode,
 	return 1;
 }
 
-struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
+struct io_wq *io_wq_create(unsigned int bounded, struct io_wq_data *data)
 {
 	int ret, i;
 	struct io_wq *wq;
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 4758f1ba902b..2b7d71106c63 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -259,7 +259,7 @@ static __cold void io_fallback_req_func(struct work_struct *work)
 	percpu_ref_put(&ctx->refs);
 }
 
-static int io_alloc_hash_table(struct io_hash_table *table, unsigned bits)
+static int io_alloc_hash_table(struct io_hash_table *table, unsigned int bits)
 {
 	unsigned int hash_buckets;
 	int i;
@@ -882,7 +882,7 @@ bool io_req_post_cqe(struct io_kiocb *req, s32 res, u32 cflags)
 	return posted;
 }
 
-static void io_req_complete_post(struct io_kiocb *req, unsigned issue_flags)
+static void io_req_complete_post(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 
@@ -1143,9 +1143,9 @@ void tctx_task_work(struct callback_head *cb)
 
 static inline void io_req_local_work_add(struct io_kiocb *req,
 					 struct io_ring_ctx *ctx,
-					 unsigned flags)
+					 unsigned int flags)
 {
-	unsigned nr_wait, nr_tw, nr_tw_prev;
+	unsigned int nr_wait, nr_tw, nr_tw_prev;
 	struct llist_node *head;
 
 	/* See comment above IO_CQ_WAKE_INIT */
@@ -1236,7 +1236,7 @@ static void io_req_normal_work_add(struct io_kiocb *req)
 	io_fallback_tw(tctx, false);
 }
 
-void __io_req_task_work_add(struct io_kiocb *req, unsigned flags)
+void __io_req_task_work_add(struct io_kiocb *req, unsigned int flags)
 {
 	if (req->ctx->flags & IORING_SETUP_DEFER_TASKRUN)
 		io_req_local_work_add(req, req->ctx, flags);
@@ -1245,7 +1245,7 @@ void __io_req_task_work_add(struct io_kiocb *req, unsigned flags)
 }
 
 void io_req_task_work_add_remote(struct io_kiocb *req, struct io_ring_ctx *ctx,
-				 unsigned flags)
+				 unsigned int flags)
 {
 	if (WARN_ON_ONCE(!(ctx->flags & IORING_SETUP_DEFER_TASKRUN)))
 		return;
@@ -1460,7 +1460,7 @@ void __io_submit_flush_completions(struct io_ring_ctx *ctx)
 	ctx->submit_state.cq_flush = false;
 }
 
-static unsigned io_cqring_events(struct io_ring_ctx *ctx)
+static unsigned int io_cqring_events(struct io_ring_ctx *ctx)
 {
 	/* See comment at the top of this file */
 	smp_rmb();
@@ -2253,8 +2253,8 @@ static void io_commit_sqring(struct io_ring_ctx *ctx)
  */
 static bool io_get_sqe(struct io_ring_ctx *ctx, const struct io_uring_sqe **sqe)
 {
-	unsigned mask = ctx->sq_entries - 1;
-	unsigned head = ctx->cached_sq_head++ & mask;
+	unsigned int mask = ctx->sq_entries - 1;
+	unsigned int head = ctx->cached_sq_head++ & mask;
 
 	if (static_branch_unlikely(&io_key_has_sqarray) &&
 	    (!(ctx->flags & IORING_SETUP_NO_SQARRAY))) {
@@ -3236,7 +3236,7 @@ static struct io_uring_reg_wait *io_get_ext_arg_reg(struct io_ring_ctx *ctx,
 	return ctx->cq_wait_arg + offset;
 }
 
-static int io_validate_ext_arg(struct io_ring_ctx *ctx, unsigned flags,
+static int io_validate_ext_arg(struct io_ring_ctx *ctx, unsigned int flags,
 			       const void __user *argp, size_t argsz)
 {
 	struct io_uring_getevents_arg arg;
@@ -3252,7 +3252,7 @@ static int io_validate_ext_arg(struct io_ring_ctx *ctx, unsigned flags,
 	return 0;
 }
 
-static int io_get_ext_arg(struct io_ring_ctx *ctx, unsigned flags,
+static int io_get_ext_arg(struct io_ring_ctx *ctx, unsigned int flags,
 			  const void __user *argp, struct ext_arg *ext_arg)
 {
 	const struct io_uring_getevents_arg __user *uarg = argp;
@@ -3552,7 +3552,7 @@ static struct file *io_uring_get_file(struct io_ring_ctx *ctx)
 					 O_RDWR | O_CLOEXEC, NULL);
 }
 
-int io_uring_fill_params(unsigned entries, struct io_uring_params *p)
+int io_uring_fill_params(unsigned int entries, struct io_uring_params *p)
 {
 	if (!entries)
 		return -EINVAL;
@@ -3619,7 +3619,7 @@ int io_uring_fill_params(unsigned entries, struct io_uring_params *p)
 	return 0;
 }
 
-static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
+static __cold int io_uring_create(unsigned int entries, struct io_uring_params *p,
 				  struct io_uring_params __user *params)
 {
 	struct io_ring_ctx *ctx;
diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index eec5eb7de843..3f9601c72464 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -52,7 +52,7 @@ static int io_buffer_add_list(struct io_ring_ctx *ctx,
 	return xa_err(xa_store(&ctx->io_bl_xa, bgid, bl, GFP_KERNEL));
 }
 
-bool io_kbuf_recycle_legacy(struct io_kiocb *req, unsigned issue_flags)
+bool io_kbuf_recycle_legacy(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_buffer_list *bl;
@@ -70,7 +70,7 @@ bool io_kbuf_recycle_legacy(struct io_kiocb *req, unsigned issue_flags)
 	return true;
 }
 
-void __io_put_kbuf(struct io_kiocb *req, int len, unsigned issue_flags)
+void __io_put_kbuf(struct io_kiocb *req, int len, unsigned int issue_flags)
 {
 	/*
 	 * We can add this buffer back to two lists:
@@ -343,9 +343,9 @@ int io_buffers_peek(struct io_kiocb *req, struct buf_sel_arg *arg)
 }
 
 static int __io_remove_buffers(struct io_ring_ctx *ctx,
-			       struct io_buffer_list *bl, unsigned nbufs)
+			       struct io_buffer_list *bl, unsigned int nbufs)
 {
-	unsigned i = 0;
+	unsigned int i = 0;
 
 	/* shouldn't happen */
 	if (!nbufs)
diff --git a/io_uring/net.c b/io_uring/net.c
index c6cd38cc5dc4..298b6e571ad0 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -69,9 +69,9 @@ struct io_sr_msg {
 		void __user			*buf;
 	};
 	int				len;
-	unsigned			done_io;
-	unsigned			msg_flags;
-	unsigned			nr_multishot_loops;
+	unsigned int			done_io;
+	unsigned int			msg_flags;
+	unsigned int			nr_multishot_loops;
 	u16				flags;
 	/* initialised and used only by !msg send variants */
 	u16				buf_group;
@@ -496,7 +496,7 @@ static int io_bundle_nbufs(struct io_async_msghdr *kmsg, int ret)
 
 static inline bool io_send_finish(struct io_kiocb *req, int *ret,
 				  struct io_async_msghdr *kmsg,
-				  unsigned issue_flags)
+				  unsigned int issue_flags)
 {
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 	bool bundle_finished = *ret <= 0;
@@ -533,7 +533,7 @@ int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 	struct io_async_msghdr *kmsg = req->async_data;
 	struct socket *sock;
-	unsigned flags;
+	unsigned int flags;
 	int min_ret = 0;
 	int ret;
 
@@ -583,7 +583,7 @@ int io_send(struct io_kiocb *req, unsigned int issue_flags)
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 	struct io_async_msghdr *kmsg = req->async_data;
 	struct socket *sock;
-	unsigned flags;
+	unsigned int flags;
 	int min_ret = 0;
 	int ret;
 
@@ -840,7 +840,7 @@ int io_recvmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
  */
 static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
 				  struct io_async_msghdr *kmsg,
-				  bool mshot_finished, unsigned issue_flags)
+				  bool mshot_finished, unsigned int issue_flags)
 {
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 	unsigned int cflags = 0;
@@ -983,7 +983,7 @@ int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 	struct io_async_msghdr *kmsg = req->async_data;
 	struct socket *sock;
-	unsigned flags;
+	unsigned int flags;
 	int ret, min_ret = 0;
 	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
 	bool mshot_finished = true;
@@ -1136,7 +1136,7 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 	struct io_async_msghdr *kmsg = req->async_data;
 	struct socket *sock;
-	unsigned flags;
+	unsigned int flags;
 	int ret, min_ret = 0;
 	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
 	size_t len = sr->len;
@@ -1381,7 +1381,7 @@ int io_send_zc(struct io_kiocb *req, unsigned int issue_flags)
 	struct io_sr_msg *zc = io_kiocb_to_cmd(req, struct io_sr_msg);
 	struct io_async_msghdr *kmsg = req->async_data;
 	struct socket *sock;
-	unsigned msg_flags;
+	unsigned int msg_flags;
 	int ret, min_ret = 0;
 
 	sock = sock_from_file(req->file);
@@ -1449,7 +1449,7 @@ int io_sendmsg_zc(struct io_kiocb *req, unsigned int issue_flags)
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 	struct io_async_msghdr *kmsg = req->async_data;
 	struct socket *sock;
-	unsigned flags;
+	unsigned int flags;
 	int ret, min_ret = 0;
 
 	sock = sock_from_file(req->file);
@@ -1562,7 +1562,7 @@ int io_accept(struct io_kiocb *req, unsigned int issue_flags)
 		.flags = force_nonblock ? O_NONBLOCK : 0,
 	};
 	struct file *file;
-	unsigned cflags;
+	unsigned int cflags;
 	int ret, fd;
 
 	if (!(req->flags & REQ_F_POLLED) &&
@@ -1705,7 +1705,7 @@ int io_connect(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_connect *connect = io_kiocb_to_cmd(req, struct io_connect);
 	struct io_async_msghdr *io = req->async_data;
-	unsigned file_flags;
+	unsigned int file_flags;
 	int ret;
 	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
 
diff --git a/io_uring/notif.c b/io_uring/notif.c
index ee3a33510b3c..b2b64b8d6198 100644
--- a/io_uring/notif.c
+++ b/io_uring/notif.c
@@ -38,7 +38,7 @@ void io_tx_ubuf_complete(struct sk_buff *skb, struct ubuf_info *uarg,
 {
 	struct io_notif_data *nd = container_of(uarg, struct io_notif_data, uarg);
 	struct io_kiocb *notif = cmd_to_io_kiocb(nd);
-	unsigned tw_flags;
+	unsigned int tw_flags;
 
 	if (nd->zc_report) {
 		if (success && !nd->zc_used && skb)
diff --git a/io_uring/poll.c b/io_uring/poll.c
index bced9edd5233..54cab73c3ff4 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -53,7 +53,7 @@ struct io_poll_table {
 
 #define IO_WQE_F_DOUBLE		1
 
-static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
+static int io_poll_wake(struct wait_queue_entry *wait, unsigned int mode, int sync,
 			void *key);
 
 static inline struct io_kiocb *wqe_to_req(struct wait_queue_entry *wqe)
@@ -192,7 +192,7 @@ enum {
 
 static void __io_poll_execute(struct io_kiocb *req, int mask)
 {
-	unsigned flags = 0;
+	unsigned int flags = 0;
 
 	io_req_set_res(req, mask, 0);
 	req->io_task_work.func = io_poll_task_func;
@@ -386,7 +386,7 @@ static __cold int io_pollfree_wake(struct io_kiocb *req, struct io_poll *poll)
 	return 1;
 }
 
-static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
+static int io_poll_wake(struct wait_queue_entry *wait, unsigned int mode, int sync,
 			void *key)
 {
 	struct io_kiocb *req = wqe_to_req(wait);
@@ -540,7 +540,7 @@ static void io_poll_add_hash(struct io_kiocb *req, unsigned int issue_flags)
 static int __io_arm_poll_handler(struct io_kiocb *req,
 				 struct io_poll *poll,
 				 struct io_poll_table *ipt, __poll_t mask,
-				 unsigned issue_flags)
+				 unsigned int issue_flags)
 {
 	INIT_HLIST_NODE(&req->hash_node);
 	io_init_poll_iocb(poll, mask);
@@ -640,7 +640,7 @@ static void io_async_queue_proc(struct file *file, struct wait_queue_head *head,
 #define APOLL_MAX_RETRY		128
 
 static struct async_poll *io_req_alloc_apoll(struct io_kiocb *req,
-					     unsigned issue_flags)
+					     unsigned int issue_flags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	struct async_poll *apoll;
@@ -667,7 +667,7 @@ static struct async_poll *io_req_alloc_apoll(struct io_kiocb *req,
 	return apoll;
 }
 
-int io_arm_poll_handler(struct io_kiocb *req, unsigned issue_flags)
+int io_arm_poll_handler(struct io_kiocb *req, unsigned int issue_flags)
 {
 	const struct io_issue_def *def = &io_issue_defs[req->opcode];
 	struct async_poll *apoll;
@@ -716,7 +716,7 @@ int io_arm_poll_handler(struct io_kiocb *req, unsigned issue_flags)
 __cold bool io_poll_remove_all(struct io_ring_ctx *ctx, struct io_uring_task *tctx,
 			       bool cancel_all)
 {
-	unsigned nr_buckets = 1U << ctx->cancel_table.hash_bits;
+	unsigned int nr_buckets = 1U << ctx->cancel_table.hash_bits;
 	struct hlist_node *tmp;
 	struct io_kiocb *req;
 	bool found = false;
@@ -762,7 +762,7 @@ static struct io_kiocb *io_poll_find(struct io_ring_ctx *ctx, bool poll_only,
 static struct io_kiocb *io_poll_file_find(struct io_ring_ctx *ctx,
 					  struct io_cancel_data *cd)
 {
-	unsigned nr_buckets = 1U << ctx->cancel_table.hash_bits;
+	unsigned int nr_buckets = 1U << ctx->cancel_table.hash_bits;
 	struct io_kiocb *req;
 	int i;
 
@@ -806,7 +806,7 @@ static int __io_poll_cancel(struct io_ring_ctx *ctx, struct io_cancel_data *cd)
 }
 
 int io_poll_cancel(struct io_ring_ctx *ctx, struct io_cancel_data *cd,
-		   unsigned issue_flags)
+		   unsigned int issue_flags)
 {
 	int ret;
 
diff --git a/io_uring/register.c b/io_uring/register.c
index 371aec87e078..87ce82a2154c 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -35,7 +35,7 @@
 				 IORING_REGISTER_LAST + IORING_OP_LAST)
 
 static __cold int io_probe(struct io_ring_ctx *ctx, void __user *arg,
-			   unsigned nr_args)
+			   unsigned int nr_args)
 {
 	struct io_uring_probe *p;
 	size_t size;
@@ -73,7 +73,7 @@ static __cold int io_probe(struct io_ring_ctx *ctx, void __user *arg,
 	return ret;
 }
 
-int io_unregister_personality(struct io_ring_ctx *ctx, unsigned id)
+int io_unregister_personality(struct io_ring_ctx *ctx, unsigned int id)
 {
 	const struct cred *creds;
 
@@ -215,7 +215,7 @@ static __cold int __io_register_iowq_aff(struct io_ring_ctx *ctx,
 }
 
 static __cold int io_register_iowq_aff(struct io_ring_ctx *ctx,
-				       void __user *arg, unsigned len)
+				       void __user *arg, unsigned int len)
 {
 	cpumask_var_t new_mask;
 	int ret;
@@ -405,7 +405,7 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 {
 	struct io_ring_ctx_rings o = { }, n = { }, *to_free = NULL;
 	size_t size, sq_array_offset;
-	unsigned i, tail, old_head;
+	unsigned int i, tail, old_head;
 	struct io_uring_params p;
 	void *ptr;
 	int ret;
@@ -522,8 +522,8 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 	if (tail - old_head > p.sq_entries)
 		goto overflow;
 	for (i = old_head; i < tail; i++) {
-		unsigned src_head = i & (ctx->sq_entries - 1);
-		unsigned dst_head = i & (p.sq_entries - 1);
+		unsigned int src_head = i & (ctx->sq_entries - 1);
+		unsigned int dst_head = i & (p.sq_entries - 1);
 
 		n.sq_sqes[dst_head] = o.sq_sqes[src_head];
 	}
@@ -542,8 +542,8 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 		goto out;
 	}
 	for (i = old_head; i < tail; i++) {
-		unsigned src_head = i & (ctx->cq_entries - 1);
-		unsigned dst_head = i & (p.cq_entries - 1);
+		unsigned int src_head = i & (ctx->cq_entries - 1);
+		unsigned int dst_head = i & (p.cq_entries - 1);
 
 		n.rings->cqes[dst_head] = o.rings->cqes[src_head];
 	}
@@ -628,8 +628,8 @@ static int io_register_mem_region(struct io_ring_ctx *ctx, void __user *uarg)
 	return 0;
 }
 
-static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
-			       void __user *arg, unsigned nr_args)
+static int __io_uring_register(struct io_ring_ctx *ctx, unsigned int opcode,
+			       void __user *arg, unsigned int nr_args)
 	__releases(ctx->uring_lock)
 	__acquires(ctx->uring_lock)
 {
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 69937d0c94f9..b78b3ebf09d6 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -143,7 +143,7 @@ __cold void io_rsrc_data_free(struct io_ring_ctx *ctx, struct io_rsrc_data *data
 	data->nr = 0;
 }
 
-__cold int io_rsrc_data_alloc(struct io_rsrc_data *data, unsigned nr)
+__cold int io_rsrc_data_alloc(struct io_rsrc_data *data, unsigned int nr)
 {
 	data->nodes = kvmalloc_array(nr, sizeof(struct io_rsrc_node *),
 					GFP_KERNEL_ACCOUNT | __GFP_ZERO);
@@ -156,7 +156,7 @@ __cold int io_rsrc_data_alloc(struct io_rsrc_data *data, unsigned nr)
 
 static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 				 struct io_uring_rsrc_update2 *up,
-				 unsigned nr_args)
+				 unsigned int nr_args)
 {
 	u64 __user *tags = u64_to_user_ptr(up->tags);
 	__s32 __user *fds = u64_to_user_ptr(up->data);
@@ -276,9 +276,9 @@ static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
 	return done ? done : err;
 }
 
-static int __io_register_rsrc_update(struct io_ring_ctx *ctx, unsigned type,
+static int __io_register_rsrc_update(struct io_ring_ctx *ctx, unsigned int type,
 				     struct io_uring_rsrc_update2 *up,
-				     unsigned nr_args)
+				     unsigned int nr_args)
 {
 	__u32 tmp;
 
@@ -297,7 +297,7 @@ static int __io_register_rsrc_update(struct io_ring_ctx *ctx, unsigned type,
 }
 
 int io_register_files_update(struct io_ring_ctx *ctx, void __user *arg,
-			     unsigned nr_args)
+			     unsigned int nr_args)
 {
 	struct io_uring_rsrc_update2 up;
 
@@ -312,7 +312,7 @@ int io_register_files_update(struct io_ring_ctx *ctx, void __user *arg,
 }
 
 int io_register_rsrc_update(struct io_ring_ctx *ctx, void __user *arg,
-			    unsigned size, unsigned type)
+			    unsigned int size, unsigned int type)
 {
 	struct io_uring_rsrc_update2 up;
 
@@ -477,12 +477,12 @@ int io_sqe_files_unregister(struct io_ring_ctx *ctx)
 }
 
 int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
-			  unsigned nr_args, u64 __user *tags)
+			  unsigned int nr_args, u64 __user *tags)
 {
 	__s32 __user *fds = (__s32 __user *) arg;
 	struct file *file;
 	int fd, ret;
-	unsigned i;
+	unsigned int i;
 
 	if (ctx->file_table.data.nr)
 		return -EBUSY;
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 29bb3010f9c0..c6080acc73c0 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -261,7 +261,7 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 		      int ddir, bool do_import)
 {
 	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
-	unsigned ioprio;
+	unsigned int ioprio;
 	int ret;
 
 	rw->kiocb.ki_pos = READ_ONCE(sqe->off);
@@ -589,7 +589,7 @@ static int kiocb_done(struct io_kiocb *req, ssize_t ret,
 		       unsigned int issue_flags)
 {
 	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
-	unsigned final_ret = io_fixup_rw_res(req, ret);
+	unsigned int final_ret = io_fixup_rw_res(req, ret);
 
 	if (ret >= 0 && req->flags & REQ_F_CUR_POS)
 		req->file->f_pos = rw->kiocb.ki_pos;
@@ -698,7 +698,7 @@ static ssize_t loop_rw_iter(int ddir, struct io_rw *rw, struct iov_iter *iter)
  * do a thread based blocking retry of the operation. That's the unexpected
  * slow path.
  */
-static int io_async_buf_func(struct wait_queue_entry *wait, unsigned mode,
+static int io_async_buf_func(struct wait_queue_entry *wait, unsigned int mode,
 			     int sync, void *arg)
 {
 	struct wait_page_queue *wpq;
diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
index 8961a3c1e73c..524bd2443e22 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -81,7 +81,7 @@ void io_put_sq_data(struct io_sq_data *sqd)
 static __cold void io_sqd_update_thread_idle(struct io_sq_data *sqd)
 {
 	struct io_ring_ctx *ctx;
-	unsigned sq_thread_idle = 0;
+	unsigned int sq_thread_idle = 0;
 
 	list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
 		sq_thread_idle = max(sq_thread_idle, ctx->sq_thread_idle);
diff --git a/io_uring/tctx.c b/io_uring/tctx.c
index adc6e42c14df..f787c030937d 100644
--- a/io_uring/tctx.c
+++ b/io_uring/tctx.c
@@ -263,7 +263,7 @@ static int io_ring_add_registered_fd(struct io_uring_task *tctx, int fd,
  * successfully processed, or < 0 on error if none were processed.
  */
 int io_ringfd_register(struct io_ring_ctx *ctx, void __user *__arg,
-		       unsigned nr_args)
+		       unsigned int nr_args)
 {
 	struct io_uring_rsrc_update __user *arg = __arg;
 	struct io_uring_rsrc_update reg;
@@ -322,7 +322,7 @@ int io_ringfd_register(struct io_ring_ctx *ctx, void __user *__arg,
 }
 
 int io_ringfd_unregister(struct io_ring_ctx *ctx, void __user *__arg,
-			 unsigned nr_args)
+			 unsigned int nr_args)
 {
 	struct io_uring_rsrc_update __user *arg = __arg;
 	struct io_uring_task *tctx = current->io_uring;
diff --git a/io_uring/timeout.c b/io_uring/timeout.c
index e9cec9e4dc2f..47ddcf7f853d 100644
--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -511,7 +511,7 @@ static int __io_timeout_prep(struct io_kiocb *req,
 {
 	struct io_timeout *timeout = io_kiocb_to_cmd(req, struct io_timeout);
 	struct io_timeout_data *data;
-	unsigned flags;
+	unsigned int flags;
 	u32 off = READ_ONCE(sqe->off);
 
 	if (sqe->buf_index || sqe->len != 1 || sqe->splice_fd_in)
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index ce7726a04883..70f83feb674e 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -138,8 +138,8 @@ static void io_uring_cmd_work(struct io_kiocb *req, struct io_tw_state *ts)
 }
 
 void __io_uring_cmd_do_in_task(struct io_uring_cmd *ioucmd,
-			void (*task_work_cb)(struct io_uring_cmd *, unsigned),
-			unsigned flags)
+			void (*task_work_cb)(struct io_uring_cmd *, unsigned int),
+			unsigned int flags)
 {
 	struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
 
@@ -161,7 +161,7 @@ static inline void io_req_set_cqe32_extra(struct io_kiocb *req,
  * -EIOCBQUEUED upon receiving the command.
  */
 void io_uring_cmd_done(struct io_uring_cmd *ioucmd, ssize_t ret, u64 res2,
-		       unsigned issue_flags)
+		       unsigned int issue_flags)
 {
 	struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
 
diff --git a/io_uring/waitid.c b/io_uring/waitid.c
index daef5dd644f0..076c82c9e4a0 100644
--- a/io_uring/waitid.c
+++ b/io_uring/waitid.c
@@ -260,7 +260,7 @@ static void io_waitid_cb(struct io_kiocb *req, struct io_tw_state *ts)
 	io_waitid_complete(req, ret);
 }
 
-static int io_waitid_wait(struct wait_queue_entry *wait, unsigned mode,
+static int io_waitid_wait(struct wait_queue_entry *wait, unsigned int mode,
 			  int sync, void *key)
 {
 	struct wait_opts *wo = container_of(wait, struct wait_opts, child_wait);
-- 
2.48.0


