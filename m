Return-Path: <io-uring+bounces-6101-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D403A1A9CF
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 19:48:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7F478163598
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 18:48:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CE50150981;
	Thu, 23 Jan 2025 18:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="SHCibSN0"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDCB714AD2E
	for <io-uring@vger.kernel.org>; Thu, 23 Jan 2025 18:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737658083; cv=none; b=Ny2rQBekbqFycpB4n/pgUZNwc7BmjWWAPG5dK+WqC2+ki++mBN72IwFnSZIwhb2alcfsxUxFaI24LPd7vZVEwTx0H7n0zSU6pUfjTjNNh9DQp4NwW8T0IgtcZKo1djAZvgpQfMZ+Ec7T2v1ks5oiyin9xr8iN3NLl+DnLgT5K8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737658083; c=relaxed/simple;
	bh=jQwOKvKlMUoIoZgrA4m5EmRuiCCPD+mfypN/GQ6i9qs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=blLUwbFHBjbg+eLIy2gXCdJ6lb0ErIn6lRMFVgXWD/tAgb2S0esuc9dc44l5IoxamJS9QOhhy+VZ0DNHD/EK2uMj2HR69814q0HvPNN/FQ0J/A4c9A59kY/8dvIttsgF6f0KGpQ6ZIG3b3+R2n44EQ1x+MySzUNTE9yB85Z/WBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=SHCibSN0; arc=none smtp.client-ip=209.85.166.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-851c4ee2a37so86876339f.3
        for <io-uring@vger.kernel.org>; Thu, 23 Jan 2025 10:48:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1737658079; x=1738262879; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VEays071pvLvL9nwza3/j9gEeJjM0rxxDw0OC4t2mHI=;
        b=SHCibSN0boHHTB/rFhK5Qrv8t2+GcQ0Pfi5Ev/y/KBTFVGcRXt92t3gvZUJvHz+5sx
         eMCDx5slKNWR+B9kJWRiorCGkc4qtdlTAXRHjW+MVPAGq6fwwNyRU19v7ezvQFGlw5RE
         pJxYIa2P2HT4ncR3cqVWZXyFr66tw306wEHZS7XXWa6wyl8XO3t7PrXst6Zdbb0AQzzd
         WuoWZxWMOElqYIB1uO1WPrwwLsHoqolV6IMvO8siljshOQNaghdycTjxOzQn60O/lSgi
         Z6ceLf70TofYYrOPJOa1ffA6hvJFRBb8u4aSfSsxMvER03X0bgsZSuySB0ZaAjVPyrlh
         C0Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737658079; x=1738262879;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VEays071pvLvL9nwza3/j9gEeJjM0rxxDw0OC4t2mHI=;
        b=hwvumQ8NXmz4s1cSRqkBEDG7p0+3NwOBpdDrMcUM9GRHXTTmRdbFO17PRFY/o7+FO7
         exslWFcJqt3op61oJ4NlUVSVYIbSWeqTdbsiHfeph7SnIutk4GH9OfHr+YjS5p1eZQdm
         I71LqJx2zVn0COcTJf8KwO0RSPhKMuA6xzi0FdGhGC6YapyHwrcPfP1RL9u3qDYCC/iq
         t8tnsMOnOXx4Hwuwdy1DQClWWDhvb99L4aawYMidgkDoa2JRBVyskR4QjnAHwkOcnsrK
         Jp4TpKLAMHbKwVqSY312N/0Nbze0fVNjM3kG6JfXr7Xdb8aIQxYJIF7i23kD4axHtKoc
         pHYw==
X-Gm-Message-State: AOJu0Ywy0XxTakVgIhkypmSPkXYH11fUyi9Whmt8hkE5QcjDyZb+Phxb
	019jEnwMRRjV+Qfwqi7Zinagqgt/6ziReHRzZp+GEDc6jIcEAZ4JnVOOu0qByxLfPlK0LSi2jGo
	v
X-Gm-Gg: ASbGncuFlvpoVRorhHOz1y4mvhHgw95dYs01EmGmjr0zWiF4TPwXvdu1f8EpN1YgbTn
	hY/YL7AVLoD2dOO9BqmWdzTKNYabnp/ZU8Wj1F4TY20tJBQ7zahBuX659K60X1UAby/FgaXSI1b
	RVwYOi+yIBnxukst725lmo//38dh09f8c7PVWpiFHZ51O531TRxt4JUTdeHb/KzReqvN01kJjdn
	grKocECBTEu/95qV9GFZWZM16g8zHLZvscBtJkIqceTzZKjntLRxo1MgvF5xo11XfEiDMN1afsb
	QJbEL88J
X-Google-Smtp-Source: AGHT+IHZnierIP0tDrk4zZMd6kRy0lgtFVf15PfJnCApbaqfis1G3busZfeTDYhLXir11NX3/vO+fg==
X-Received: by 2002:a05:6602:418d:b0:84a:7902:d424 with SMTP id ca18e2360f4ac-851b6007ad6mr2376475639f.0.1737658079411;
        Thu, 23 Jan 2025 10:47:59 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ec1db6c4b0sm53432173.89.2025.01.23.10.47.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jan 2025 10:47:58 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: krisman@suse.de,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/3] io_uring: get rid of alloc cache init_once handling
Date: Thu, 23 Jan 2025 11:45:26 -0700
Message-ID: <20250123184754.555270-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250123184754.555270-1-axboe@kernel.dk>
References: <20250123184754.555270-1-axboe@kernel.dk>
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
cleared at the start of the struct, and wrap the rest of the struct in
a struct group so the offset is known.

While at it, improve the interaction with KASAN such that when/if
KASAN writes to members inside the struct that should be retained over
caching, it won't trip over itself. For rw and net, the retaining of
the iovec over caching is disabled if KASAN is enabled. A helper will
free and clear those members in that case.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/io_uring/cmd.h   |  2 +-
 include/linux/io_uring_types.h |  3 ++-
 io_uring/alloc_cache.h         | 43 +++++++++++++++++++++++++++-------
 io_uring/futex.c               |  4 ++--
 io_uring/io_uring.c            | 12 ++++++----
 io_uring/io_uring.h            |  5 ++--
 io_uring/net.c                 | 28 +++++-----------------
 io_uring/net.h                 | 20 +++++++++-------
 io_uring/poll.c                |  2 +-
 io_uring/rw.c                  | 27 +++++----------------
 io_uring/rw.h                  | 27 ++++++++++++---------
 io_uring/uring_cmd.c           | 11 ++-------
 12 files changed, 91 insertions(+), 93 deletions(-)

diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
index a3ce553413de..abd0c8bd950b 100644
--- a/include/linux/io_uring/cmd.h
+++ b/include/linux/io_uring/cmd.h
@@ -19,8 +19,8 @@ struct io_uring_cmd {
 };
 
 struct io_uring_cmd_data {
-	struct io_uring_sqe	sqes[2];
 	void			*op_data;
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
index a3a8cfec32ce..cca96aff3277 100644
--- a/io_uring/alloc_cache.h
+++ b/io_uring/alloc_cache.h
@@ -6,6 +6,19 @@
  */
 #define IO_ALLOC_CACHE_MAX	128
 
+#if defined(CONFIG_KASAN)
+static inline void io_alloc_cache_kasan(struct iovec **iov, int *nr)
+{
+	kfree(*iov);
+	*iov = NULL;
+	*nr = 0;
+}
+#else
+static inline void io_alloc_cache_kasan(struct iovec **iov, int *nr)
+{
+}
+#endif
+
 static inline bool io_alloc_cache_put(struct io_alloc_cache *cache,
 				      void *entry)
 {
@@ -23,35 +36,47 @@ static inline void *io_alloc_cache_get(struct io_alloc_cache *cache)
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
index 7bfbc7c22367..263e504be4a8 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -315,16 +315,18 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	INIT_LIST_HEAD(&ctx->cq_overflow_list);
 	INIT_LIST_HEAD(&ctx->io_buffers_cache);
 	ret = io_alloc_cache_init(&ctx->apoll_cache, IO_POLL_ALLOC_CACHE_MAX,
-			    sizeof(struct async_poll));
+			    sizeof(struct async_poll), 0);
 	ret |= io_alloc_cache_init(&ctx->netmsg_cache, IO_ALLOC_CACHE_MAX,
-			    sizeof(struct io_async_msghdr));
+			    sizeof(struct io_async_msghdr),
+			    offsetof(struct io_async_msghdr, clear));
 	ret |= io_alloc_cache_init(&ctx->rw_cache, IO_ALLOC_CACHE_MAX,
-			    sizeof(struct io_async_rw));
+			    sizeof(struct io_async_rw),
+			    offsetof(struct io_async_rw, clear));
 	ret |= io_alloc_cache_init(&ctx->uring_cache, IO_ALLOC_CACHE_MAX,
-			    sizeof(struct io_uring_cmd_data));
+			    sizeof(struct io_uring_cmd_data), 0);
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
index 85f55fbc25c9..41eef286f8b9 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -137,7 +137,6 @@ static void io_netmsg_iovec_free(struct io_async_msghdr *kmsg)
 static void io_netmsg_recycle(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_async_msghdr *hdr = req->async_data;
-	struct iovec *iov;
 
 	/* can't recycle, ensure we free the iovec if we have one */
 	if (unlikely(issue_flags & IO_URING_F_UNLOCKED)) {
@@ -146,39 +145,25 @@ static void io_netmsg_recycle(struct io_kiocb *req, unsigned int issue_flags)
 	}
 
 	/* Let normal cleanup path reap it if we fail adding to the cache */
-	iov = hdr->free_iov;
+	io_alloc_cache_kasan(&hdr->free_iov, &hdr->free_iov_nr);
 	if (io_alloc_cache_put(&req->ctx->netmsg_cache, hdr)) {
-		if (iov)
-			kasan_mempool_poison_object(iov);
 		req->async_data = NULL;
 		req->flags &= ~REQ_F_ASYNC_DATA;
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
 
 	/* If the async data was cached, we might have an iov cached inside. */
-	if (hdr->free_iov) {
-		kasan_mempool_unpoison_object(hdr->free_iov,
-					      hdr->free_iov_nr * sizeof(struct iovec));
+	if (hdr->free_iov)
 		req->flags |= REQ_F_NEED_CLEANUP;
-	}
 	return hdr;
 }
 
@@ -1813,11 +1798,10 @@ void io_netmsg_cache_free(const void *entry)
 {
 	struct io_async_msghdr *kmsg = (struct io_async_msghdr *) entry;
 
-	if (kmsg->free_iov) {
-		kasan_mempool_unpoison_object(kmsg->free_iov,
-				kmsg->free_iov_nr * sizeof(struct iovec));
+#if !defined(CONFIG_KASAN)
+	if (kmsg->free_iov)
 		io_netmsg_iovec_free(kmsg);
-	}
+#endif
 	kfree(kmsg);
 }
 #endif
diff --git a/io_uring/net.h b/io_uring/net.h
index 52bfee05f06a..b804c2b36e60 100644
--- a/io_uring/net.h
+++ b/io_uring/net.h
@@ -5,16 +5,20 @@
 
 struct io_async_msghdr {
 #if defined(CONFIG_NET)
-	struct iovec			fast_iov;
-	/* points to an allocated iov, if NULL we use fast_iov instead */
 	struct iovec			*free_iov;
+	/* points to an allocated iov, if NULL we use fast_iov instead */
 	int				free_iov_nr;
-	int				namelen;
-	__kernel_size_t			controllen;
-	__kernel_size_t			payloadlen;
-	struct sockaddr __user		*uaddr;
-	struct msghdr			msg;
-	struct sockaddr_storage		addr;
+	struct_group(clear,
+		int				namelen;
+		struct iovec			fast_iov;
+		__kernel_size_t			controllen;
+		__kernel_size_t			payloadlen;
+		struct sockaddr __user		*uaddr;
+		struct msghdr			msg;
+		struct sockaddr_storage		addr;
+	);
+#else
+	struct_group(clear);
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
index a9a2733be842..991ecfbea88e 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -158,16 +158,13 @@ static void io_rw_iovec_free(struct io_async_rw *rw)
 static void io_rw_recycle(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_async_rw *rw = req->async_data;
-	struct iovec *iov;
 
 	if (unlikely(issue_flags & IO_URING_F_UNLOCKED)) {
 		io_rw_iovec_free(rw);
 		return;
 	}
-	iov = rw->free_iovec;
+	io_alloc_cache_kasan(&rw->free_iovec, &rw->free_iov_nr);
 	if (io_alloc_cache_put(&req->ctx->rw_cache, rw)) {
-		if (iov)
-			kasan_mempool_poison_object(iov);
 		req->async_data = NULL;
 		req->flags &= ~REQ_F_ASYNC_DATA;
 	}
@@ -208,27 +205,16 @@ static void io_req_rw_cleanup(struct io_kiocb *req, unsigned int issue_flags)
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
-	if (rw->free_iovec) {
-		kasan_mempool_unpoison_object(rw->free_iovec,
-					      rw->free_iov_nr * sizeof(struct iovec));
+	if (rw->free_iovec)
 		req->flags |= REQ_F_NEED_CLEANUP;
-	}
 	rw->bytes_done = 0;
 	return 0;
 }
@@ -1323,10 +1309,9 @@ void io_rw_cache_free(const void *entry)
 {
 	struct io_async_rw *rw = (struct io_async_rw *) entry;
 
-	if (rw->free_iovec) {
-		kasan_mempool_unpoison_object(rw->free_iovec,
-				rw->free_iov_nr * sizeof(struct iovec));
+#if !defined(CONFIG_KASAN)
+	if (rw->free_iovec)
 		io_rw_iovec_free(rw);
-	}
+#endif
 	kfree(rw);
 }
diff --git a/io_uring/rw.h b/io_uring/rw.h
index 2d7656bd268d..eaa59bd64870 100644
--- a/io_uring/rw.h
+++ b/io_uring/rw.h
@@ -9,19 +9,24 @@ struct io_meta_state {
 
 struct io_async_rw {
 	size_t				bytes_done;
-	struct iov_iter			iter;
-	struct iov_iter_state		iter_state;
-	struct iovec			fast_iov;
 	struct iovec			*free_iovec;
-	int				free_iov_nr;
-	/* wpq is for buffered io, while meta fields are used with direct io */
-	union {
-		struct wait_page_queue		wpq;
-		struct {
-			struct uio_meta			meta;
-			struct io_meta_state		meta_state;
+	struct_group(clear,
+		struct iov_iter			iter;
+		struct iov_iter_state		iter_state;
+		struct iovec			fast_iov;
+		int				free_iov_nr;
+		/*
+		 * wpq is for buffered io, while meta fields are used with
+		 * direct io
+		 */
+		union {
+			struct wait_page_queue		wpq;
+			struct {
+				struct uio_meta			meta;
+				struct io_meta_state		meta_state;
+			};
 		};
-	};
+	);
 };
 
 int io_prep_read_fixed(struct io_kiocb *req, const struct io_uring_sqe *sqe);
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 6a63ec4b5445..1f6a82128b47 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -168,23 +168,16 @@ void io_uring_cmd_done(struct io_uring_cmd *ioucmd, ssize_t ret, u64 res2,
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
+	cache->op_data = NULL;
 
 	if (!(req->flags & REQ_F_FORCE_ASYNC)) {
 		/* defer memcpy until we need it */
-- 
2.47.2


