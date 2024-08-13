Return-Path: <io-uring+bounces-2749-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A7913950B3D
	for <lists+io-uring@lfdr.de>; Tue, 13 Aug 2024 19:11:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CB4351C22FBE
	for <lists+io-uring@lfdr.de>; Tue, 13 Aug 2024 17:11:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 251B41A0710;
	Tue, 13 Aug 2024 17:11:19 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from cloud48395.mywhc.ca (cloud48395.mywhc.ca [173.209.37.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2D501A01C5
	for <io-uring@vger.kernel.org>; Tue, 13 Aug 2024 17:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.209.37.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723569079; cv=none; b=GPq5qDW3Vu9gBQFZRl/02BpHkGyHLJQ3VRlraduA3mXJcFcD7ZlOKMmCFs6s2KwCuladxMOIS1A8ha5gebuUdidQ9SiTrYsqOmb4tIuJI9rNZAOnwO5fkmoKLcNqWhYtaZ2FkC3xc9gZRuzynIZbsV/FvmpL0YWvptkTDzzs4gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723569079; c=relaxed/simple;
	bh=7VlJ3hzXXkjKVOelB8jrZM6KiDBsAPTNOzsNv7kTZZM=;
	h=From:Date:Message-ID:In-Reply-To:References:To:Subject; b=Gi6eVbNtROyA9cMcN1xtC7VvAr3pufvKJ9XhXhcwi9Ar0pgM2H190LktZ+8PU1mDxxE07OaAditz13xg7XcHGSBTHlfkGzicWOhFR36UZMFCBUs5Am4TAVIj36vHBZSGBuDjBZCzxEG0yHTnyspmkqezukwC201lupCV7J7DS8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trillion01.com; spf=pass smtp.mailfrom=trillion01.com; arc=none smtp.client-ip=173.209.37.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trillion01.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trillion01.com
Received: from [45.44.224.220] (port=48534 helo=localhost)
	by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96.2)
	(envelope-from <olivier@trillion01.com>)
	id 1sdv3D-0003JO-14;
	Tue, 13 Aug 2024 13:11:15 -0400
From: Olivier Langlois <olivier@trillion01.com>
Date: Tue, 13 Aug 2024 13:11:14 -0400
Message-ID: <5fc9dd07e48a7178f547ed1b2aaa0814607fa246.1723567469.git.olivier@trillion01.com>
In-Reply-To: <cover.1723567469.git.olivier@trillion01.com>
References: <cover.1723567469.git.olivier@trillion01.com>
To: Jens Axboe <axboe@kernel.dk>,Pavel Begunkov <asml.silence@gmail.com>,io-uring@vger.kernel.org
Subject: [PATCH 2/2] io_uring/napi: add static napi tracking strategy
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
 include/uapi/linux/io_uring.h |  30 ++++++-
 io_uring/napi.c               | 162 ++++++++++++++++++++++++++++------
 2 files changed, 163 insertions(+), 29 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 2aaf7ee256ac..f72471b19af2 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -728,12 +728,38 @@ struct io_uring_buf_status {
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
+	IO_URING_NAPI_TRACKING_DYNAMIC = 0,
+	IO_URING_NAPI_TRACKING_STATIC = 1
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
diff --git a/io_uring/napi.c b/io_uring/napi.c
index 75ac850af0c0..b66ff15fcc72 100644
--- a/io_uring/napi.c
+++ b/io_uring/napi.c
@@ -38,37 +38,29 @@ static inline ktime_t net_to_ktime(unsigned long t)
 	return ns_to_ktime(t << 10);
 }
 
-static inline void __io_napi_add(struct io_ring_ctx *ctx, struct socket *sock)
+static int __io_napi_add_id(struct io_ring_ctx *ctx, unsigned int napi_id)
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
 
 	rcu_read_lock();
 	e = io_napi_hash_find(hash_list, napi_id);
 	if (e) {
-		e->timeout = jiffies + NAPI_TIMEOUT;
+		WRITE_ONCE(e->timeout, jiffies + NAPI_TIMEOUT);
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
@@ -77,23 +69,62 @@ static inline void __io_napi_add(struct io_ring_ctx *ctx, struct socket *sock)
 	if (unlikely(io_napi_hash_find(hash_list, napi_id))) {
 		spin_unlock(&ctx->napi_lock);
 		kfree(e);
-		return;
+		return -EEXIST;
 	}
 
 	hlist_add_tail_rcu(&e->node, hash_list);
-	list_add_tail(&e->list, &ctx->napi_list);
+	list_add_tail_rcu(&e->list, &ctx->napi_list);
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
+}
+
+static inline void __io_napi_add(struct io_ring_ctx *ctx, struct socket *sock)
+{
+	unsigned int napi_id;
+	struct sock *sk;
+
+	sk = sock->sk;
+	if (!sk)
+		return;
+
+	napi_id = READ_ONCE(sk->sk_napi_id);
+	__io_napi_add_id(ctx, napi_id);
 }
 
 static void __io_napi_remove_stale(struct io_ring_ctx *ctx)
 {
+	struct hlist_node *tmp;
 	struct io_napi_entry *e;
 	unsigned int i;
 
 	spin_lock(&ctx->napi_lock);
-	hash_for_each(ctx->napi_ht, i, e, node) {
+	hash_for_each_safe(ctx->napi_ht, i, tmp, e, node) {
 		if (time_after(jiffies, e->timeout)) {
-			list_del(&e->list);
+			list_del_rcu(&e->list);
 			hash_del_rcu(&e->node);
 			kfree_rcu(e, rcu);
 		}
@@ -201,23 +232,68 @@ static bool dynamic_tracking_do_busy_loop(struct io_ring_ctx *ctx,
 	return is_stale;
 }
 
-static void dynamic_tracking_show_fdinfo(struct io_ring_ctx *ctx,
-					 struct seq_file *m)
+static void common_tracking_show_fdinfo(struct io_ring_ctx *ctx,
+					struct seq_file *m,
+					const char *tracking_strategy)
 {
 	seq_puts(m, "NAPI:\tenabled\n");
-	seq_printf(m, "napi_busy_poll_to:\t%u\n", ctx->napi_busy_poll_to);
+	seq_printf(m, "napi tracking:\t%s\n", tracking_strategy);
+	seq_printf(m, "napi_busy_poll_to:\t%llu\n", ctx->napi_busy_poll_dt);
 	if (ctx->napi_prefer_busy_poll)
 		seq_puts(m, "napi_prefer_busy_poll:\ttrue\n");
 	else
 		seq_puts(m, "napi_prefer_busy_poll:\tfalse\n");
 }
 
+static void dynamic_tracking_show_fdinfo(struct io_ring_ctx *ctx,
+					 struct seq_file *m)
+{
+	common_tracking_show_fdinfo(ctx, m, "dynamic");
+}
+
 static struct io_napi_tracking_ops dynamic_tracking_ops = {
 	.add_id = dynamic_tracking_add_id,
 	.do_busy_loop = dynamic_tracking_do_busy_loop,
-	.show_fdinfo = dynamic_tracking_show_fdinfo,
+	.show_fdinfo  = dynamic_tracking_show_fdinfo,
+};
+
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
+	list_for_each_entry_rcu(e, &ctx->napi_list, list) {
+		napi_busy_loop_rcu(e->napi_id, loop_end, loop_end_arg,
+				   ctx->napi_prefer_busy_poll, BUSY_POLL_BUDGET);
+	}
+
+	return false;
+}
+
+static void static_tracking_show_fdinfo(struct io_ring_ctx *ctx,
+					struct seq_file *m)
+{
+	common_tracking_show_fdinfo(ctx, m, "static");
+}
+
+static struct io_napi_tracking_ops static_tracking_ops = {
+	.add_id = NULL,
+	.do_busy_loop = static_tracking_do_busy_loop,
+	.show_fdinfo = static_tracking_show_fdinfo,
 };
 
+static inline u32 io_napi_get_tracking(struct io_ring_ctx *ctx)
+{
+	return ctx->napi_ops == &static_tracking_ops;
+}
+
 static void io_napi_blocking_busy_loop(struct io_ring_ctx *ctx,
 				       struct io_wait_queue *iowq)
 {
@@ -273,9 +349,30 @@ void io_napi_free(struct io_ring_ctx *ctx)
 		hash_del_rcu(&e->node);
 		kfree_rcu(e, rcu);
 	}
+	INIT_LIST_HEAD_RCU(&ctx->napi_list);
 	spin_unlock(&ctx->napi_lock);
 }
 
+static int io_napi_register_napi(struct io_ring_ctx *ctx,
+				 struct io_uring_napi *napi)
+{
+	switch (napi->op_param) {
+	case IO_URING_NAPI_TRACKING_DYNAMIC:
+		WRITE_ONCE(ctx->napi_ops, &dynamic_tracking_ops);
+		break;
+	case IO_URING_NAPI_TRACKING_STATIC:
+		WRITE_ONCE(ctx->napi_ops, &static_tracking_ops);
+		/* clean the napi list for manual setup */
+		io_napi_free(ctx);
+		break;
+	default:
+		return -EINVAL;
+	}
+	WRITE_ONCE(ctx->napi_busy_poll_dt, napi->busy_poll_to * NSEC_PER_USEC);
+	WRITE_ONCE(ctx->napi_prefer_busy_poll, !!napi->prefer_busy_poll);
+	return 0;
+}
+
 /*
  * io_napi_register() - Register napi with io-uring
  * @ctx: pointer to io-uring context structure
@@ -287,7 +384,8 @@ int io_register_napi(struct io_ring_ctx *ctx, void __user *arg)
 {
 	const struct io_uring_napi curr = {
 		.busy_poll_to 	  = ktime_to_us(ctx->napi_busy_poll_dt),
-		.prefer_busy_poll = ctx->napi_prefer_busy_poll
+		.prefer_busy_poll = ctx->napi_prefer_busy_poll,
+		.op_param	  = io_napi_get_tracking(ctx)
 	};
 	struct io_uring_napi napi;
 
@@ -295,16 +393,26 @@ int io_register_napi(struct io_ring_ctx *ctx, void __user *arg)
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
-	WRITE_ONCE(ctx->napi_ops, &dynamic_tracking_ops);
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
-- 
2.46.0


