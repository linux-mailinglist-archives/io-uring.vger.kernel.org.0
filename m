Return-Path: <io-uring+bounces-6063-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2EED6A1A5B1
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 15:23:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 98F211884A25
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 14:23:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B710F20F972;
	Thu, 23 Jan 2025 14:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="nmn4uDTk"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC79920FA85
	for <io-uring@vger.kernel.org>; Thu, 23 Jan 2025 14:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737642192; cv=none; b=JpgHLdEQuX2jFcaL5oxJs7X8adQCc8w4jYhaKeKbMLnGAETKJkFKZQPdRaRZLcbLmBsCsG1m039Ut/xuktnfm28Idr0S6cA5WfwGfC70zPSQTBQkuCUNh3dXZ+14KmQIGF2/0AcUdmObk5Z7HpYq8cC6FqtvS4MTus9KdvMq2nI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737642192; c=relaxed/simple;
	bh=vkeQbFpEyETUlSIcKfs7My0YosbujnysyQjdLZoF9ig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZKhsYlhIMBiO07aiOOZP163BCHwaS25UxneoIGLYuv6egO8hnMHGpBFHngIG5ANs7PBGCnpV7h9wSnBIpY0tCcG0d3v8wFYfgsZEAiCPz56dTMx1e4ZQYtOPuZkvPbUL8jRt0rjIhmlE5JcUnL8zSe0xHmu1pRVVIyxKKSHnd28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=nmn4uDTk; arc=none smtp.client-ip=209.85.166.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-844ef6275c5so25054939f.0
        for <io-uring@vger.kernel.org>; Thu, 23 Jan 2025 06:23:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1737642189; x=1738246989; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K9ujyQBceeJ2pIIEVruffMMxQHcXi+JVCpdL99KcjUE=;
        b=nmn4uDTkg3KAocxe6h0uaVs7vY5rCtA947Nl3uqMujb7aYEGDEL6S7P/dm0djyYoMZ
         jf8fUbwAgQtV+Fpz74DrPEGQsH1QQrdey/EtLD7fWfvr8eJmO79A128eyuZYF0oi/3tB
         L9iepfEswcB74IvUiy+6obQ090UC8RCVR/OCfLkTsSy8S2fv3t4fkgOIHgxXefJoWrXy
         1vTMwbhUfybk9BFNF0E2aN0TCyDf7nYwgf3LfC238j8tOOvbLkvmPRg8Jj+cJrIlEKwj
         ja/vjv3Va1kvgfdopvGP7eopg7roFinoeAa83FiKwZspUYmDsNcfy0v3ebq0kN9AYP3U
         KPqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737642189; x=1738246989;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=K9ujyQBceeJ2pIIEVruffMMxQHcXi+JVCpdL99KcjUE=;
        b=Pi0COXXJnodq0A+STiJiBjijTw+PqT3jVypLG5zpU/qVYab4Mv8R5VWBEIGq2lkGfe
         jLU01TelK9xutC2lbGdSOMq7kZbEIoFQoLdIIx5V8TW4okAiuBb5Fpoi2xHgFeysTVrk
         WVoWgZ4z/ef8sc+CVPHYJEnqil/Rl2B0i2Cq0YpsJxNeBydBPmBhW9IzgZZRTmagP/pD
         d039S3/9qGMXbkh+fGddmApqDS7LXkoDvdfhlLpF4g2rV+BKnw3b6EZfGutuFVjA7VPB
         25rbfZV4Md22WCVTkem4vp4NlMfx/ibjxE/z8meBpmOiM9Dg6pts3HFcpiaOF/QpDRCR
         RhAw==
X-Gm-Message-State: AOJu0YwpbNqgGjgC6tYRW6roxboisw2jXDOI1AaRGmtbsqP7XowFvXUn
	SejTuyDQ2DiBWBL1VPK8V1IePCqDb2c7Erhr3EUYPnBqoBq4jQandIqE1RT0D6Y2zRXe2wMaLx2
	E
X-Gm-Gg: ASbGncslPmoL1/2XBW0BXNOIz5v+et3+CaPB+F3j9wc8DMNbGDDBHi0/zNVrUWXTe+P
	cV/+yNggqj8gV/X6DYwnjgTxwKbgJSluy7RDfZ2cVWOw/nIW4KPBp9zzcFPFxvPPTo0uR212sn+
	4wXnvlIYJ1SzysC3tTe7ajCoPqRD0hxm0b69tXe5GS9yI2Dl3Z6o7GXotb7GyjE7nQIkT/aXI+D
	KGhEyczIsiwNYAhnCCC1Q1I6qX2FPYzbl8g4a7UF2opgmSoVCMtmq04CaAMdO6ZReG164UgZagZ
	ZFex+3ao
X-Google-Smtp-Source: AGHT+IE+6GJz+YBOWbAOVwDj3smyJYBClhv1rv6LTj7zD/jfu7D8CkfBqf9u1FKWxKw+AWd3rya0Pg==
X-Received: by 2002:a05:6602:48c:b0:834:d7b6:4fea with SMTP id ca18e2360f4ac-851b61f1347mr2548431039f.6.1737642188969;
        Thu, 23 Jan 2025 06:23:08 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-851b01f2690sm446847339f.18.2025.01.23.06.23.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jan 2025 06:23:07 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: krisman@suse.de,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/2] io_uring: get rid of alloc cache init_once handling
Date: Thu, 23 Jan 2025 07:21:12 -0700
Message-ID: <20250123142301.409846-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250123142301.409846-1-axboe@kernel.dk>
References: <20250123142301.409846-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

init_once is called when an object doesn't come from the cache, and
hence needs initial clearing of certain members. While the whole
struct could get cleared by memset() in that case, a few of the cache
members are large enough that this may cause unnecessary overhead if
the caches used aren't large enough to satisfy the workload. For those
cases, some churn of kmalloc+kfree is to be expected.

Ensure that the 3 users that need clearing put the members they need
cleared at the start of the struct, and place an empty placeholder
'init' member so that the cache initialization knows how much to
clear.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/io_uring/cmd.h   |  3 ++-
 include/linux/io_uring_types.h |  3 ++-
 io_uring/alloc_cache.h         | 30 +++++++++++++++++++++---------
 io_uring/futex.c               |  4 ++--
 io_uring/io_uring.c            | 13 ++++++++-----
 io_uring/io_uring.h            |  5 ++---
 io_uring/net.c                 | 11 +----------
 io_uring/net.h                 |  7 +++++--
 io_uring/poll.c                |  2 +-
 io_uring/rw.c                  | 10 +---------
 io_uring/rw.h                  |  5 ++++-
 io_uring/uring_cmd.c           | 10 +---------
 12 files changed, 50 insertions(+), 53 deletions(-)

diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
index a3ce553413de..8d7746d9fd23 100644
--- a/include/linux/io_uring/cmd.h
+++ b/include/linux/io_uring/cmd.h
@@ -19,8 +19,9 @@ struct io_uring_cmd {
 };
 
 struct io_uring_cmd_data {
-	struct io_uring_sqe	sqes[2];
 	void			*op_data;
+	int			init[0];
+	struct io_uring_sqe	sqes[2];
 };
 
 static inline const void *io_uring_sqe_cmd(const struct io_uring_sqe *sqe)
diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 623d8e798a11..3def525a1da3 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -222,7 +222,8 @@ struct io_alloc_cache {
 	void			**entries;
 	unsigned int		nr_cached;
 	unsigned int		max_cached;
-	size_t			elem_size;
+	unsigned int		elem_size;
+	unsigned int		init_clear;
 };
 
 struct io_ring_ctx {
diff --git a/io_uring/alloc_cache.h b/io_uring/alloc_cache.h
index a3a8cfec32ce..f57d5e13cbbb 100644
--- a/io_uring/alloc_cache.h
+++ b/io_uring/alloc_cache.h
@@ -23,35 +23,47 @@ static inline void *io_alloc_cache_get(struct io_alloc_cache *cache)
 	if (cache->nr_cached) {
 		void *entry = cache->entries[--cache->nr_cached];
 
+		/*
+		 * If KASAN is enabled, always clear the initial bytes that
+		 * must be zeroed post alloc, in case any of them overlap
+		 * with KASAN storage.
+		 */
+#if defined(CONFIG_KASAN)
 		kasan_mempool_unpoison_object(entry, cache->elem_size);
+		if (cache->init_clear)
+			memset(entry, 0, cache->init_clear);
+#endif
 		return entry;
 	}
 
 	return NULL;
 }
 
-static inline void *io_cache_alloc(struct io_alloc_cache *cache, gfp_t gfp,
-				   void (*init_once)(void *obj))
+static inline void *io_cache_alloc(struct io_alloc_cache *cache, gfp_t gfp)
 {
-	if (unlikely(!cache->nr_cached)) {
-		void *obj = kmalloc(cache->elem_size, gfp);
+	void *obj;
 
-		if (obj && init_once)
-			init_once(obj);
+	obj = io_alloc_cache_get(cache);
+	if (obj)
 		return obj;
-	}
-	return io_alloc_cache_get(cache);
+
+	obj = kmalloc(cache->elem_size, gfp);
+	if (obj && cache->init_clear)
+		memset(obj, 0, cache->init_clear);
+	return obj;
 }
 
 /* returns false if the cache was initialized properly */
 static inline bool io_alloc_cache_init(struct io_alloc_cache *cache,
-				       unsigned max_nr, size_t size)
+				       unsigned max_nr, unsigned int size,
+				       unsigned int init_bytes)
 {
 	cache->entries = kvmalloc_array(max_nr, sizeof(void *), GFP_KERNEL);
 	if (cache->entries) {
 		cache->nr_cached = 0;
 		cache->max_cached = max_nr;
 		cache->elem_size = size;
+		cache->init_clear = init_bytes;
 		return false;
 	}
 	return true;
diff --git a/io_uring/futex.c b/io_uring/futex.c
index 30139cc150f2..3159a2b7eeca 100644
--- a/io_uring/futex.c
+++ b/io_uring/futex.c
@@ -36,7 +36,7 @@ struct io_futex_data {
 bool io_futex_cache_init(struct io_ring_ctx *ctx)
 {
 	return io_alloc_cache_init(&ctx->futex_cache, IO_FUTEX_ALLOC_CACHE_MAX,
-				sizeof(struct io_futex_data));
+				sizeof(struct io_futex_data), 0);
 }
 
 void io_futex_cache_free(struct io_ring_ctx *ctx)
@@ -320,7 +320,7 @@ int io_futex_wait(struct io_kiocb *req, unsigned int issue_flags)
 	}
 
 	io_ring_submit_lock(ctx, issue_flags);
-	ifd = io_cache_alloc(&ctx->futex_cache, GFP_NOWAIT, NULL);
+	ifd = io_cache_alloc(&ctx->futex_cache, GFP_NOWAIT);
 	if (!ifd) {
 		ret = -ENOMEM;
 		goto done_unlock;
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 7bfbc7c22367..7d38bdccbad8 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -315,16 +315,19 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	INIT_LIST_HEAD(&ctx->cq_overflow_list);
 	INIT_LIST_HEAD(&ctx->io_buffers_cache);
 	ret = io_alloc_cache_init(&ctx->apoll_cache, IO_POLL_ALLOC_CACHE_MAX,
-			    sizeof(struct async_poll));
+			    sizeof(struct async_poll), 0);
 	ret |= io_alloc_cache_init(&ctx->netmsg_cache, IO_ALLOC_CACHE_MAX,
-			    sizeof(struct io_async_msghdr));
+			    sizeof(struct io_async_msghdr),
+			    offsetof(struct io_async_msghdr, init));
 	ret |= io_alloc_cache_init(&ctx->rw_cache, IO_ALLOC_CACHE_MAX,
-			    sizeof(struct io_async_rw));
+			    sizeof(struct io_async_rw),
+			    offsetof(struct io_async_rw, init));
 	ret |= io_alloc_cache_init(&ctx->uring_cache, IO_ALLOC_CACHE_MAX,
-			    sizeof(struct io_uring_cmd_data));
+			    sizeof(struct io_uring_cmd_data),
+			    offsetof(struct io_uring_cmd_data, init));
 	spin_lock_init(&ctx->msg_lock);
 	ret |= io_alloc_cache_init(&ctx->msg_cache, IO_ALLOC_CACHE_MAX,
-			    sizeof(struct io_kiocb));
+			    sizeof(struct io_kiocb), 0);
 	ret |= io_futex_cache_init(ctx);
 	if (ret)
 		goto free_ref;
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index f65e3f3ede51..67adbb3c1bf5 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -226,10 +226,9 @@ static inline void io_req_set_res(struct io_kiocb *req, s32 res, u32 cflags)
 }
 
 static inline void *io_uring_alloc_async_data(struct io_alloc_cache *cache,
-					      struct io_kiocb *req,
-					      void (*init_once)(void *obj))
+					      struct io_kiocb *req)
 {
-	req->async_data = io_cache_alloc(cache, GFP_KERNEL, init_once);
+	req->async_data = io_cache_alloc(cache, GFP_KERNEL);
 	if (req->async_data)
 		req->flags |= REQ_F_ASYNC_DATA;
 	return req->async_data;
diff --git a/io_uring/net.c b/io_uring/net.c
index 85f55fbc25c9..35bec4680fcc 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -155,21 +155,12 @@ static void io_netmsg_recycle(struct io_kiocb *req, unsigned int issue_flags)
 	}
 }
 
-static void io_msg_async_data_init(void *obj)
-{
-	struct io_async_msghdr *hdr = (struct io_async_msghdr *)obj;
-
-	hdr->free_iov = NULL;
-	hdr->free_iov_nr = 0;
-}
-
 static struct io_async_msghdr *io_msg_alloc_async(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_async_msghdr *hdr;
 
-	hdr = io_uring_alloc_async_data(&ctx->netmsg_cache, req,
-					io_msg_async_data_init);
+	hdr = io_uring_alloc_async_data(&ctx->netmsg_cache, req);
 	if (!hdr)
 		return NULL;
 
diff --git a/io_uring/net.h b/io_uring/net.h
index 52bfee05f06a..22a1a34bca09 100644
--- a/io_uring/net.h
+++ b/io_uring/net.h
@@ -5,16 +5,19 @@
 
 struct io_async_msghdr {
 #if defined(CONFIG_NET)
-	struct iovec			fast_iov;
-	/* points to an allocated iov, if NULL we use fast_iov instead */
 	struct iovec			*free_iov;
+	/* points to an allocated iov, if NULL we use fast_iov instead */
 	int				free_iov_nr;
+	int				init[0];
 	int				namelen;
+	struct iovec			fast_iov;
 	__kernel_size_t			controllen;
 	__kernel_size_t			payloadlen;
 	struct sockaddr __user		*uaddr;
 	struct msghdr			msg;
 	struct sockaddr_storage		addr;
+#else
+	int				init[0];
 #endif
 };
 
diff --git a/io_uring/poll.c b/io_uring/poll.c
index cc01c40b43d3..356474c66f32 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -650,7 +650,7 @@ static struct async_poll *io_req_alloc_apoll(struct io_kiocb *req,
 		kfree(apoll->double_poll);
 	} else {
 		if (!(issue_flags & IO_URING_F_UNLOCKED))
-			apoll = io_cache_alloc(&ctx->apoll_cache, GFP_ATOMIC, NULL);
+			apoll = io_cache_alloc(&ctx->apoll_cache, GFP_ATOMIC);
 		else
 			apoll = kmalloc(sizeof(*apoll), GFP_ATOMIC);
 		if (!apoll)
diff --git a/io_uring/rw.c b/io_uring/rw.c
index a9a2733be842..0a0ad8a2bc0d 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -208,20 +208,12 @@ static void io_req_rw_cleanup(struct io_kiocb *req, unsigned int issue_flags)
 	}
 }
 
-static void io_rw_async_data_init(void *obj)
-{
-	struct io_async_rw *rw = (struct io_async_rw *)obj;
-
-	rw->free_iovec = NULL;
-	rw->bytes_done = 0;
-}
-
 static int io_rw_alloc_async(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_async_rw *rw;
 
-	rw = io_uring_alloc_async_data(&ctx->rw_cache, req, io_rw_async_data_init);
+	rw = io_uring_alloc_async_data(&ctx->rw_cache, req);
 	if (!rw)
 		return -ENOMEM;
 	if (rw->free_iovec) {
diff --git a/io_uring/rw.h b/io_uring/rw.h
index 2d7656bd268d..ab9e4df2504a 100644
--- a/io_uring/rw.h
+++ b/io_uring/rw.h
@@ -8,11 +8,14 @@ struct io_meta_state {
 };
 
 struct io_async_rw {
+	/* these must be cleared on initial alloc */
 	size_t				bytes_done;
+	struct iovec			*free_iovec;
+	int				init[0];
+	/* rest persists over caching */
 	struct iov_iter			iter;
 	struct iov_iter_state		iter_state;
 	struct iovec			fast_iov;
-	struct iovec			*free_iovec;
 	int				free_iov_nr;
 	/* wpq is for buffered io, while meta fields are used with direct io */
 	union {
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 6a63ec4b5445..0da7dc20eca6 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -168,21 +168,13 @@ void io_uring_cmd_done(struct io_uring_cmd *ioucmd, ssize_t ret, u64 res2,
 }
 EXPORT_SYMBOL_GPL(io_uring_cmd_done);
 
-static void io_uring_cmd_init_once(void *obj)
-{
-	struct io_uring_cmd_data *data = obj;
-
-	data->op_data = NULL;
-}	
-
 static int io_uring_cmd_prep_setup(struct io_kiocb *req,
 				   const struct io_uring_sqe *sqe)
 {
 	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
 	struct io_uring_cmd_data *cache;
 
-	cache = io_uring_alloc_async_data(&req->ctx->uring_cache, req,
-			io_uring_cmd_init_once);
+	cache = io_uring_alloc_async_data(&req->ctx->uring_cache, req);
 	if (!cache)
 		return -ENOMEM;
 
-- 
2.47.2


