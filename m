Return-Path: <io-uring+bounces-2748-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B161E950B3C
	for <lists+io-uring@lfdr.de>; Tue, 13 Aug 2024 19:11:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 69B8C284DDE
	for <lists+io-uring@lfdr.de>; Tue, 13 Aug 2024 17:11:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBAB9198A3D;
	Tue, 13 Aug 2024 17:10:59 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from cloud48395.mywhc.ca (cloud48395.mywhc.ca [173.209.37.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CC0B1A2561
	for <io-uring@vger.kernel.org>; Tue, 13 Aug 2024 17:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.209.37.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723569059; cv=none; b=MjxvTYR8qV2JU8PWUq/mCjlOX9cJ2xlfjgkGgUH1pHQiupGYUiNpYUb8bGnGfjgpyeRmnJlUDdY+9/YJzLQLgDO2CHESVZkGvilnRMT4Pku6/Rk17HGt8fO60D2RMZv6+zosMQerswLj8qb1ke1ap463Vxqr82mZB9dyezN+pqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723569059; c=relaxed/simple;
	bh=KmlziorRbtH0yTQFUtVB/oebTsE5wXOJwyMw3hcqvRg=;
	h=From:Date:Message-ID:In-Reply-To:References:To:Subject; b=kUTCV50iyMx1PkUdc9RubbXFlDTMp9q3G9kZqPG5tHfxNxb9KVr4So9LZ05fTJ95z4An4krVVcjn5DwzYOi3rS4THB8GI8LWbm8ScvXdQeGnQea5WHa3TMWwzA7er32Bh/Y/oew038MNaBIMNVIuR1hiAnZBkVDpBlqH3knz324=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trillion01.com; spf=pass smtp.mailfrom=trillion01.com; arc=none smtp.client-ip=173.209.37.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trillion01.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trillion01.com
Received: from [45.44.224.220] (port=43132 helo=localhost)
	by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96.2)
	(envelope-from <olivier@trillion01.com>)
	id 1sdv2u-0003I8-0I;
	Tue, 13 Aug 2024 13:10:56 -0400
From: Olivier Langlois <olivier@trillion01.com>
Date: Tue, 13 Aug 2024 13:10:55 -0400
Message-ID: <bfbb03a7ad6256b68d08429c0888a05032a1b182.1723567469.git.olivier@trillion01.com>
In-Reply-To: <cover.1723567469.git.olivier@trillion01.com>
References: <cover.1723567469.git.olivier@trillion01.com>
To: Jens Axboe <axboe@kernel.dk>,Pavel Begunkov <asml.silence@gmail.com>,io-uring@vger.kernel.org
Subject: [PATCH 1/2] io_uring/napi: Introduce io_napi_tracking_ops
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

The long term goal is to lay out a framework to be able to offer
different napi tracking strategies to the user. The obvious first
alternative strategy is the static tracking where the user would update
manually the napi_list to remove the overhead made by io_uring managing the
list dynamically.

Signed-off-by: Olivier Langlois <olivier@trillion01.com>
---
 include/linux/io_uring_types.h | 12 +++++-
 io_uring/fdinfo.c              |  4 ++
 io_uring/napi.c                | 76 ++++++++++++++++++++++++++++++----
 io_uring/napi.h                | 11 +----
 4 files changed, 86 insertions(+), 17 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 3315005df117..c1d1b28f8cca 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -217,6 +217,16 @@ struct io_alloc_cache {
 	size_t			elem_size;
 };
 
+#ifdef CONFIG_NET_RX_BUSY_POLL
+struct io_napi_tracking_ops {
+	void (*add_id)(struct io_kiocb *req);
+	bool (*do_busy_loop)(struct io_ring_ctx *ctx,
+			     void *loop_end_arg);
+	void (*show_fdinfo)(struct io_ring_ctx *ctx,
+			    struct seq_file *m);
+};
+#endif
+
 struct io_ring_ctx {
 	/* const or read-mostly hot data */
 	struct {
@@ -402,11 +412,11 @@ struct io_ring_ctx {
 #ifdef CONFIG_NET_RX_BUSY_POLL
 	struct list_head	napi_list;	/* track busy poll napi_id */
 	spinlock_t		napi_lock;	/* napi_list lock */
+	struct io_napi_tracking_ops *napi_ops;
 
 	/* napi busy poll default timeout */
 	ktime_t			napi_busy_poll_dt;
 	bool			napi_prefer_busy_poll;
-	bool			napi_enabled;
 
 	DECLARE_HASHTABLE(napi_ht, 4);
 #endif
diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
index b1e0e0d85349..fa773687a684 100644
--- a/io_uring/fdinfo.c
+++ b/io_uring/fdinfo.c
@@ -223,5 +223,9 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *file)
 	}
 
 	spin_unlock(&ctx->completion_lock);
+#ifdef CONFIG_NET_RX_BUSY_POLL
+	ctx->napi_ops->show_fdinfo(ctx, m);
+#endif
+
 }
 #endif
diff --git a/io_uring/napi.c b/io_uring/napi.c
index 1de1d4d62925..75ac850af0c0 100644
--- a/io_uring/napi.c
+++ b/io_uring/napi.c
@@ -38,7 +38,7 @@ static inline ktime_t net_to_ktime(unsigned long t)
 	return ns_to_ktime(t << 10);
 }
 
-void __io_napi_add(struct io_ring_ctx *ctx, struct socket *sock)
+static inline void __io_napi_add(struct io_ring_ctx *ctx, struct socket *sock)
 {
 	struct hlist_head *hash_list;
 	unsigned int napi_id;
@@ -136,8 +136,52 @@ static bool io_napi_busy_loop_should_end(void *data,
 	return false;
 }
 
-static bool __io_napi_do_busy_loop(struct io_ring_ctx *ctx,
-				   void *loop_end_arg)
+/*
+ * does not perform any busy polling but still check if list entries are
+ * stalled if the list is not empty. This could happen by unregistering
+ * napi after having enabled it for some time.
+ */
+static bool no_tracking_do_busy_loop(struct io_ring_ctx *ctx,
+				     void *loop_end_arg)
+{
+	struct io_napi_entry *e;
+	bool is_stale = false;
+
+	list_for_each_entry_rcu(e, &ctx->napi_list, list) {
+		if (time_after(jiffies, e->timeout))
+			is_stale = true;
+	}
+
+	return is_stale;
+}
+
+static void no_tracking_show_fdinfo(struct io_ring_ctx *ctx,
+				    struct seq_file *m)
+{
+	seq_puts(m, "NAPI:\tdisabled\n");
+}
+
+/*
+ * default ops for a newly created ring for which NAPI busy poll is not enabled
+ */
+static struct io_napi_tracking_ops no_tracking_ops = {
+	.add_id = NULL,
+	.do_busy_loop = no_tracking_do_busy_loop,
+	.show_fdinfo = no_tracking_show_fdinfo,
+};
+
+static void dynamic_tracking_add_id(struct io_kiocb *req)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+	struct socket *sock;
+
+	sock = sock_from_file(req->file);
+	if (sock)
+		__io_napi_add(ctx, sock);
+}
+
+static bool dynamic_tracking_do_busy_loop(struct io_ring_ctx *ctx,
+					  void *loop_end_arg)
 {
 	struct io_napi_entry *e;
 	bool (*loop_end)(void *, unsigned long) = NULL;
@@ -157,6 +201,23 @@ static bool __io_napi_do_busy_loop(struct io_ring_ctx *ctx,
 	return is_stale;
 }
 
+static void dynamic_tracking_show_fdinfo(struct io_ring_ctx *ctx,
+					 struct seq_file *m)
+{
+	seq_puts(m, "NAPI:\tenabled\n");
+	seq_printf(m, "napi_busy_poll_to:\t%u\n", ctx->napi_busy_poll_to);
+	if (ctx->napi_prefer_busy_poll)
+		seq_puts(m, "napi_prefer_busy_poll:\ttrue\n");
+	else
+		seq_puts(m, "napi_prefer_busy_poll:\tfalse\n");
+}
+
+static struct io_napi_tracking_ops dynamic_tracking_ops = {
+	.add_id = dynamic_tracking_add_id,
+	.do_busy_loop = dynamic_tracking_do_busy_loop,
+	.show_fdinfo = dynamic_tracking_show_fdinfo,
+};
+
 static void io_napi_blocking_busy_loop(struct io_ring_ctx *ctx,
 				       struct io_wait_queue *iowq)
 {
@@ -172,7 +233,7 @@ static void io_napi_blocking_busy_loop(struct io_ring_ctx *ctx,
 
 	rcu_read_lock();
 	do {
-		is_stale = __io_napi_do_busy_loop(ctx, loop_end_arg);
+		is_stale = ctx->napi_ops->do_busy_loop(ctx, loop_end_arg);
 	} while (!io_napi_busy_loop_should_end(iowq, start_time) && !loop_end_arg);
 	rcu_read_unlock();
 
@@ -193,6 +254,7 @@ void io_napi_init(struct io_ring_ctx *ctx)
 	spin_lock_init(&ctx->napi_lock);
 	ctx->napi_prefer_busy_poll = false;
 	ctx->napi_busy_poll_dt = ns_to_ktime(sys_dt);
+	ctx->napi_ops = &no_tracking_ops;
 }
 
 /*
@@ -241,7 +303,7 @@ int io_register_napi(struct io_ring_ctx *ctx, void __user *arg)
 
 	WRITE_ONCE(ctx->napi_busy_poll_dt, napi.busy_poll_to * NSEC_PER_USEC);
 	WRITE_ONCE(ctx->napi_prefer_busy_poll, !!napi.prefer_busy_poll);
-	WRITE_ONCE(ctx->napi_enabled, true);
+	WRITE_ONCE(ctx->napi_ops, &dynamic_tracking_ops);
 	return 0;
 }
 
@@ -265,7 +327,7 @@ int io_unregister_napi(struct io_ring_ctx *ctx, void __user *arg)
 
 	WRITE_ONCE(ctx->napi_busy_poll_dt, 0);
 	WRITE_ONCE(ctx->napi_prefer_busy_poll, false);
-	WRITE_ONCE(ctx->napi_enabled, false);
+	WRITE_ONCE(ctx->napi_ops, &no_tracking_ops);
 	return 0;
 }
 
@@ -321,7 +383,7 @@ int io_napi_sqpoll_busy_poll(struct io_ring_ctx *ctx)
 		return 0;
 
 	rcu_read_lock();
-	is_stale = __io_napi_do_busy_loop(ctx, NULL);
+	is_stale = ctx->napi_ops->do_busy_loop(ctx, NULL);
 	rcu_read_unlock();
 
 	io_napi_remove_stale(ctx, is_stale);
diff --git a/io_uring/napi.h b/io_uring/napi.h
index 27b88c3eb428..3d68d8e7b108 100644
--- a/io_uring/napi.h
+++ b/io_uring/napi.h
@@ -15,8 +15,6 @@ void io_napi_free(struct io_ring_ctx *ctx);
 int io_register_napi(struct io_ring_ctx *ctx, void __user *arg);
 int io_unregister_napi(struct io_ring_ctx *ctx, void __user *arg);
 
-void __io_napi_add(struct io_ring_ctx *ctx, struct socket *sock);
-
 void __io_napi_adjust_timeout(struct io_ring_ctx *ctx,
 		struct io_wait_queue *iowq, ktime_t to_wait);
 void __io_napi_busy_loop(struct io_ring_ctx *ctx, struct io_wait_queue *iowq);
@@ -53,14 +51,9 @@ static inline void io_napi_busy_loop(struct io_ring_ctx *ctx,
 static inline void io_napi_add(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
-	struct socket *sock;
-
-	if (!READ_ONCE(ctx->napi_enabled))
-		return;
 
-	sock = sock_from_file(req->file);
-	if (sock)
-		__io_napi_add(ctx, sock);
+	if (ctx->napi_ops->add_id)
+		ctx->napi_ops->add_id(req);
 }
 
 #else
-- 
2.46.0


