Return-Path: <io-uring+bounces-3228-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A32F697BCA7
	for <lists+io-uring@lfdr.de>; Wed, 18 Sep 2024 14:59:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5D6AA282120
	for <lists+io-uring@lfdr.de>; Wed, 18 Sep 2024 12:59:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA126189F3E;
	Wed, 18 Sep 2024 12:59:45 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from cloud48395.mywhc.ca (cloud48395.mywhc.ca [173.209.37.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AF66189F3C
	for <io-uring@vger.kernel.org>; Wed, 18 Sep 2024 12:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.209.37.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726664385; cv=none; b=Y4ty7MBFPvUcc2lY5kvCJQl9o/wEe0fIZhVyFPMc/fgBpdBuyCfbcj7XXpWaE2KsCkYAwRn6jb0atBqt/3c+Biv/ED3CvYbIUyup8+u8yi9Hl2HDXNdKcKgimWJv3HTSzOIxSY4TT9OxnZBMqiA26xLr5tEzwwIDybcRlNl8xlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726664385; c=relaxed/simple;
	bh=DaHz9h7+WbTtfG5t2UeyX9qyIVMNAZ6O8OiAZiQ27+4=;
	h=From:Date:Message-ID:In-Reply-To:References:To:Subject; b=J/mYdQllMMU1/ilHDZf43ekCtItPgOXQnIdjxv7syLoTQpLR9FRlz7dO6X7G30jkwF2qO08OpW37b3oTdj0XS9fkkNwFs2aM4+fBXb8cv8tp9aBAKsYdgPYQiAdOjP7mNo75BgHMVnkX/FL6lZ3elv49g0UVEM+5XNyqwSu84Ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trillion01.com; spf=pass smtp.mailfrom=trillion01.com; arc=none smtp.client-ip=173.209.37.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trillion01.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trillion01.com
Received: from [45.44.224.220] (port=59294 helo=localhost)
	by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96.2)
	(envelope-from <olivier@trillion01.com>)
	id 1squHW-0004bG-0G;
	Wed, 18 Sep 2024 08:59:42 -0400
From: Olivier Langlois <olivier@trillion01.com>
Date: Wed, 18 Sep 2024 08:59:41 -0400
Message-ID: <edca1df43f5114f91f9d8ea95e2e8769ec6792b4.1726589775.git.olivier@trillion01.com>
In-Reply-To: <cover.1726589775.git.olivier@trillion01.com>
References: <cover.1726589775.git.olivier@trillion01.com>
To: Jens Axboe <axboe@kernel.dk>,Pavel Begunkov <asml.silence@gmail.com>,io-uring@vger.kernel.org
Subject: [PATCH v3 3/3] io_uring/napi: add static napi tracking strategy
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cloud48395.mywhc.ca
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - trillion01.com
X-Get-Message-Sender-Via: cloud48395.mywhc.ca: authenticated_id: olivier@trillion01.com
X-Authenticated-Sender: cloud48395.mywhc.ca: olivier@trillion01.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

add the static napi tracking strategy that allows the user to manually
manage the napi ids list to busy poll and offload the ring from
dynamically update the list.

Signed-off-by: Olivier Langlois <olivier@trillion01.com>
---
 include/linux/io_uring_types.h |   2 +-
 include/uapi/linux/io_uring.h  |  32 ++++++++-
 io_uring/fdinfo.c              |  41 ++++++++++++
 io_uring/napi.c                | 117 ++++++++++++++++++++++++++-------
 io_uring/napi.h                |  15 +++--
 5 files changed, 178 insertions(+), 29 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 3315005df117..f0a0cb2518bb 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -406,7 +406,7 @@ struct io_ring_ctx {
 	/* napi busy poll default timeout */
 	ktime_t			napi_busy_poll_dt;
 	bool			napi_prefer_busy_poll;
-	bool			napi_enabled;
+	u8			napi_track_mode;
 
 	DECLARE_HASHTABLE(napi_ht, 4);
 #endif
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index adc2524fd8e3..10d9030c4242 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -728,12 +728,40 @@ struct io_uring_buf_status {
 	__u32	resv[8];
 };
 
+enum io_uring_napi_op {
+	/* register/ungister backward compatible opcode */
+	IO_URING_NAPI_REGISTER_OP = 0,
+
+	/* opcodes to update napi_list when static tracking is used */
+	IO_URING_NAPI_STATIC_ADD_ID = 1,
+	IO_URING_NAPI_STATIC_DEL_ID = 2
+};
+
+enum io_uring_napi_tracking_strategy {
+	/* value must be 0 for backward compatibility */
+	IO_URING_NAPI_TRACKING_DYNAMIC = 0,
+	IO_URING_NAPI_TRACKING_STATIC = 1,
+	IO_URING_NAPI_TRACKING_INACTIVE = 255
+};
+
 /* argument for IORING_(UN)REGISTER_NAPI */
 struct io_uring_napi {
 	__u32	busy_poll_to;
 	__u8	prefer_busy_poll;
-	__u8	pad[3];
-	__u64	resv;
+
+	/* a io_uring_napi_op value */
+	__u8	opcode;
+	__u8	pad[2];
+
+	/*
+	 * for IO_URING_NAPI_REGISTER_OP, it is a
+	 * io_uring_napi_tracking_strategy value.
+	 *
+	 * for IO_URING_NAPI_STATIC_ADD_ID/IO_URING_NAPI_STATIC_DEL_ID
+	 * it is the napi id to add/del from napi_list.
+	 */
+	__u32	op_param;
+	__u32	resv;
 };
 
 /*
diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
index b1e0e0d85349..6f0e40e1469c 100644
--- a/io_uring/fdinfo.c
+++ b/io_uring/fdinfo.c
@@ -46,6 +46,46 @@ static __cold int io_uring_show_cred(struct seq_file *m, unsigned int id,
 	return 0;
 }
 
+#ifdef CONFIG_NET_RX_BUSY_POLL
+static __cold void common_tracking_show_fdinfo(struct io_ring_ctx *ctx,
+					       struct seq_file *m,
+					       const char *tracking_strategy)
+{
+	seq_puts(m, "NAPI:\tenabled\n");
+	seq_printf(m, "napi tracking:\t%s\n", tracking_strategy);
+	seq_printf(m, "napi_busy_poll_dt:\t%llu\n", ctx->napi_busy_poll_dt);
+	if (ctx->napi_prefer_busy_poll)
+		seq_puts(m, "napi_prefer_busy_poll:\ttrue\n");
+	else
+		seq_puts(m, "napi_prefer_busy_poll:\tfalse\n");
+}
+
+static __cold void napi_show_fdinfo(struct io_ring_ctx *ctx,
+				    struct seq_file *m)
+{
+	unsigned int mode = READ_ONCE(ctx->napi_track_mode);
+
+	switch (mode) {
+	case IO_URING_NAPI_TRACKING_INACTIVE:
+		seq_puts(m, "NAPI:\tdisabled\n");
+		break;
+	case IO_URING_NAPI_TRACKING_DYNAMIC:
+		common_tracking_show_fdinfo(ctx, m, "dynamic");
+		break;
+	case IO_URING_NAPI_TRACKING_STATIC:
+		common_tracking_show_fdinfo(ctx, m, "static");
+		break;
+	default:
+		seq_printf(m, "NAPI:\tunknown mode (%u)\n", mode);
+	}
+}
+#else
+static inline void napi_show_fdinfo(struct io_ring_ctx *ctx,
+				    struct seq_file *m)
+{
+}
+#endif
+
 /*
  * Caller holds a reference to the file already, we don't need to do
  * anything else to get an extra reference.
@@ -223,5 +263,6 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *file)
 	}
 
 	spin_unlock(&ctx->completion_lock);
+	napi_show_fdinfo(ctx, m);
 }
 #endif
diff --git a/io_uring/napi.c b/io_uring/napi.c
index 6fc127e74f10..d98b87d346ca 100644
--- a/io_uring/napi.c
+++ b/io_uring/napi.c
@@ -38,22 +38,14 @@ static inline ktime_t net_to_ktime(unsigned long t)
 	return ns_to_ktime(t << 10);
 }
 
-void __io_napi_add(struct io_ring_ctx *ctx, struct socket *sock)
+int __io_napi_add_id(struct io_ring_ctx *ctx, unsigned int napi_id)
 {
 	struct hlist_head *hash_list;
-	unsigned int napi_id;
-	struct sock *sk;
 	struct io_napi_entry *e;
 
-	sk = sock->sk;
-	if (!sk)
-		return;
-
-	napi_id = READ_ONCE(sk->sk_napi_id);
-
 	/* Non-NAPI IDs can be rejected. */
 	if (napi_id < MIN_NAPI_ID)
-		return;
+		return -EINVAL;
 
 	hash_list = &ctx->napi_ht[hash_min(napi_id, HASH_BITS(ctx->napi_ht))];
 
@@ -62,13 +54,13 @@ void __io_napi_add(struct io_ring_ctx *ctx, struct socket *sock)
 	if (e) {
 		WRITE_ONCE(e->timeout, jiffies + NAPI_TIMEOUT);
 		rcu_read_unlock();
-		return;
+		return -EEXIST;
 	}
 	rcu_read_unlock();
 
 	e = kmalloc(sizeof(*e), GFP_NOWAIT);
 	if (!e)
-		return;
+		return -ENOMEM;
 
 	e->napi_id = napi_id;
 	e->timeout = jiffies + NAPI_TIMEOUT;
@@ -77,12 +69,37 @@ void __io_napi_add(struct io_ring_ctx *ctx, struct socket *sock)
 	if (unlikely(io_napi_hash_find(hash_list, napi_id))) {
 		spin_unlock(&ctx->napi_lock);
 		kfree(e);
-		return;
+		return -EEXIST;
 	}
 
 	hlist_add_tail_rcu(&e->node, hash_list);
 	list_add_tail_rcu(&e->list, &ctx->napi_list);
 	spin_unlock(&ctx->napi_lock);
+	return 0;
+}
+
+static int __io_napi_del_id(struct io_ring_ctx *ctx, unsigned int napi_id)
+{
+	struct hlist_head *hash_list;
+	struct io_napi_entry *e;
+
+	/* Non-NAPI IDs can be rejected. */
+	if (napi_id < MIN_NAPI_ID)
+		return -EINVAL;
+
+	hash_list = &ctx->napi_ht[hash_min(napi_id, HASH_BITS(ctx->napi_ht))];
+	spin_lock(&ctx->napi_lock);
+	e = io_napi_hash_find(hash_list, napi_id);
+	if (unlikely(!e)) {
+		spin_unlock(&ctx->napi_lock);
+		return -ENOENT;
+	}
+
+	list_del_rcu(&e->list);
+	hash_del_rcu(&e->node);
+	kfree_rcu(e, rcu);
+	spin_unlock(&ctx->napi_lock);
+	return 0;
 }
 
 static void __io_napi_remove_stale(struct io_ring_ctx *ctx)
@@ -141,8 +158,26 @@ static bool io_napi_busy_loop_should_end(void *data,
 	return false;
 }
 
-static bool __io_napi_do_busy_loop(struct io_ring_ctx *ctx,
-				   void *loop_end_arg)
+/*
+ * never report stale entries
+ */
+static bool static_tracking_do_busy_loop(struct io_ring_ctx *ctx,
+					 void *loop_end_arg)
+{
+	struct io_napi_entry *e;
+	bool (*loop_end)(void *, unsigned long) = NULL;
+
+	if (loop_end_arg)
+		loop_end = io_napi_busy_loop_should_end;
+
+	list_for_each_entry_rcu(e, &ctx->napi_list, list)
+		napi_busy_loop_rcu(e->napi_id, loop_end, loop_end_arg,
+				   ctx->napi_prefer_busy_poll, BUSY_POLL_BUDGET);
+	return false;
+}
+
+static bool dynamic_tracking_do_busy_loop(struct io_ring_ctx *ctx,
+					  void *loop_end_arg)
 {
 	struct io_napi_entry *e;
 	bool (*loop_end)(void *, unsigned long) = NULL;
@@ -162,6 +197,14 @@ static bool __io_napi_do_busy_loop(struct io_ring_ctx *ctx,
 	return is_stale;
 }
 
+static inline bool __io_napi_do_busy_loop(struct io_ring_ctx *ctx,
+					  void *loop_end_arg)
+{
+	if (READ_ONCE(ctx->napi_track_mode) == IO_URING_NAPI_TRACKING_STATIC)
+		return static_tracking_do_busy_loop(ctx, loop_end_arg);
+	return dynamic_tracking_do_busy_loop(ctx, loop_end_arg);
+}
+
 static void io_napi_blocking_busy_loop(struct io_ring_ctx *ctx,
 				       struct io_wait_queue *iowq)
 {
@@ -198,6 +241,7 @@ void io_napi_init(struct io_ring_ctx *ctx)
 	spin_lock_init(&ctx->napi_lock);
 	ctx->napi_prefer_busy_poll = false;
 	ctx->napi_busy_poll_dt = ns_to_ktime(sys_dt);
+	ctx->napi_track_mode = IO_URING_NAPI_TRACKING_INACTIVE;
 }
 
 /*
@@ -219,6 +263,24 @@ void io_napi_free(struct io_ring_ctx *ctx)
 	spin_unlock(&ctx->napi_lock);
 }
 
+static int io_napi_register_napi(struct io_ring_ctx *ctx,
+				 struct io_uring_napi *napi)
+{
+	switch (napi->op_param) {
+	case IO_URING_NAPI_TRACKING_DYNAMIC:
+	case IO_URING_NAPI_TRACKING_STATIC:
+		break;
+	default:
+		return -EINVAL;
+	}
+	/* clean the napi list for new settings */
+	io_napi_free(ctx);
+	WRITE_ONCE(ctx->napi_track_mode, napi->op_param);
+	WRITE_ONCE(ctx->napi_busy_poll_dt, napi->busy_poll_to * NSEC_PER_USEC);
+	WRITE_ONCE(ctx->napi_prefer_busy_poll, !!napi->prefer_busy_poll);
+	return 0;
+}
+
 /*
  * io_napi_register() - Register napi with io-uring
  * @ctx: pointer to io-uring context structure
@@ -230,7 +292,8 @@ int io_register_napi(struct io_ring_ctx *ctx, void __user *arg)
 {
 	const struct io_uring_napi curr = {
 		.busy_poll_to 	  = ktime_to_us(ctx->napi_busy_poll_dt),
-		.prefer_busy_poll = ctx->napi_prefer_busy_poll
+		.prefer_busy_poll = ctx->napi_prefer_busy_poll,
+		.op_param	  = ctx->napi_track_mode
 	};
 	struct io_uring_napi napi;
 
@@ -238,16 +301,26 @@ int io_register_napi(struct io_ring_ctx *ctx, void __user *arg)
 		return -EINVAL;
 	if (copy_from_user(&napi, arg, sizeof(napi)))
 		return -EFAULT;
-	if (napi.pad[0] || napi.pad[1] || napi.pad[2] || napi.resv)
+	if (napi.pad[0] || napi.pad[1] || napi.resv)
 		return -EINVAL;
 
 	if (copy_to_user(arg, &curr, sizeof(curr)))
 		return -EFAULT;
 
-	WRITE_ONCE(ctx->napi_busy_poll_dt, napi.busy_poll_to * NSEC_PER_USEC);
-	WRITE_ONCE(ctx->napi_prefer_busy_poll, !!napi.prefer_busy_poll);
-	WRITE_ONCE(ctx->napi_enabled, true);
-	return 0;
+	switch (napi.opcode) {
+	case IO_URING_NAPI_REGISTER_OP:
+		return io_napi_register_napi(ctx, &napi);
+	case IO_URING_NAPI_STATIC_ADD_ID:
+		if (curr.op_param != IO_URING_NAPI_TRACKING_STATIC)
+			return -EINVAL;
+		return __io_napi_add_id(ctx, napi.op_param);
+	case IO_URING_NAPI_STATIC_DEL_ID:
+		if (curr.op_param != IO_URING_NAPI_TRACKING_STATIC)
+			return -EINVAL;
+		return __io_napi_del_id(ctx, napi.op_param);
+	default:
+		return -EINVAL;
+	}
 }
 
 /*
@@ -270,7 +343,7 @@ int io_unregister_napi(struct io_ring_ctx *ctx, void __user *arg)
 
 	WRITE_ONCE(ctx->napi_busy_poll_dt, 0);
 	WRITE_ONCE(ctx->napi_prefer_busy_poll, false);
-	WRITE_ONCE(ctx->napi_enabled, false);
+	WRITE_ONCE(ctx->napi_track_mode, IO_URING_NAPI_TRACKING_INACTIVE);
 	return 0;
 }
 
diff --git a/io_uring/napi.h b/io_uring/napi.h
index 27b88c3eb428..220574522484 100644
--- a/io_uring/napi.h
+++ b/io_uring/napi.h
@@ -15,7 +15,7 @@ void io_napi_free(struct io_ring_ctx *ctx);
 int io_register_napi(struct io_ring_ctx *ctx, void __user *arg);
 int io_unregister_napi(struct io_ring_ctx *ctx, void __user *arg);
 
-void __io_napi_add(struct io_ring_ctx *ctx, struct socket *sock);
+int __io_napi_add_id(struct io_ring_ctx *ctx, unsigned int napi_id);
 
 void __io_napi_adjust_timeout(struct io_ring_ctx *ctx,
 		struct io_wait_queue *iowq, ktime_t to_wait);
@@ -54,13 +54,20 @@ static inline void io_napi_add(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	struct socket *sock;
+	struct sock *sk;
 
-	if (!READ_ONCE(ctx->napi_enabled))
+	if (READ_ONCE(ctx->napi_track_mode) != IO_URING_NAPI_TRACKING_DYNAMIC)
 		return;
 
 	sock = sock_from_file(req->file);
-	if (sock)
-		__io_napi_add(ctx, sock);
+	if (!sock)
+		return;
+
+	sk = sock->sk;
+	if (!sk)
+		return;
+
+	__io_napi_add_id(ctx, READ_ONCE(sk->sk_napi_id));
 }
 
 #else
-- 
2.46.1


