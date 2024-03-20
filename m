Return-Path: <io-uring+bounces-1179-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C7488819BC
	for <lists+io-uring@lfdr.de>; Wed, 20 Mar 2024 23:58:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 304811C21314
	for <lists+io-uring@lfdr.de>; Wed, 20 Mar 2024 22:58:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76C818615F;
	Wed, 20 Mar 2024 22:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="eRxsdA7g"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C814085C73
	for <io-uring@vger.kernel.org>; Wed, 20 Mar 2024 22:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710975509; cv=none; b=WeTVx5MhvQDohbVRnCPjsDvpLqeAMh8E8IAOHnMXR8EdciVKm7nVNF9ni1ppRnv4k7YYf3AwCAl1UydkKnRnCSiRisaBAI52mjBoB4QBcQSCG4GaDiLLyz6W4VTEH93hCJ41Eqf883p28gwv59KxHUq9BmqHa3MALeKanYqItcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710975509; c=relaxed/simple;
	bh=caViakkOg5kJXZMP9AVtl4ebLqQ2aXaJBYp6zawekwI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j5WgLVSWhHVO65Qf4VYlp8E42ybRQAp+zIbiwLi/Yam/N733obcTpqiVV0w7ab8D4X/qKxjWxTPDAk1YTMLVH9lGfjSD5zEsgpzIuUP7YH3VDV1hAplYpPWtTGcpoSZcRRFAdOZx4/9FPpK+V1BvHlR9r6NgiInovDNyaeD5hbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=eRxsdA7g; arc=none smtp.client-ip=209.85.166.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-7cc5e664d52so6269939f.0
        for <io-uring@vger.kernel.org>; Wed, 20 Mar 2024 15:58:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1710975504; x=1711580304; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VPSzS6txPEkTrfLLkD9zuSt6VxfHBiyyTyoq7ztEnDo=;
        b=eRxsdA7glgdIAJUzQZOFNXcck9loPF2drew/JE89J0Og0kHF2bNxbEXQMT3RmO7PX8
         MMk6kKTRzmw8aAz/HSIo1jQhOForJUnRTAk9N/PVUWHIyfxaBRaeuN/NlS1+QvQpTSg5
         eB3HYOk8Yeyh0ExWomIeL+hxpErT/vVCQxMck8gDW61b05D6lmYVy57b/AXiue3zp3PY
         h5yQqC5wEjQMjnWeIV3LyR5ECR74xK/POjBeECQI0NAoDvPVsB2zJctedHQPzotChKbW
         d7A2wctiW3faXZM8UAI/pzlprkWeSozyUcey92Mwyk0JiVz0rzQXBSoT9ZBOtnLvPBat
         HIIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710975504; x=1711580304;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VPSzS6txPEkTrfLLkD9zuSt6VxfHBiyyTyoq7ztEnDo=;
        b=exkVMEYW1lJzMvYjwsqIFW85cJ2vFnXZWVKoL6zE9iaju4acPRw9ya5PJzU4TInUPU
         9he4oY15a1E4IE0FAOOfBrTOq57vgsOonBzgCxrRZYPmUqkSWWhFUfn0cELm+rdLs+QK
         2zrWkxUeLRqpFMlSYrOrCCiFfxYVHAHES2AYN29I0hPBSFapnLHc3Il6k3ru6b3p0ykL
         IQV9Kx3cc4G0G5DeIJ701zXNnJKfadQBF9F7eHePz/iPOcnMPpuDb241vxHb0h2rR0IQ
         uXhTeO52WjLgB3DEJX96YeI3EjhEEZwFxU3orAGUrm7Z4baJgFYCuRa42pQjy561ej3L
         naMQ==
X-Gm-Message-State: AOJu0Yydj1PNdA2prTwYiWHzF8C3nyqhU+zpQNe/qr8POvLdAytbPsrg
	yEYFMVTFqNJO30nxawkK4PLLXkFLcgtfvwlN88HkyJnwehV+rv/krk39rptMtJBuabpFIHJpJKg
	w
X-Google-Smtp-Source: AGHT+IE9jSuNIf2Gxg+UyXEzVCZ6VPlwhQLCHtemOraVrc0gGulMTttW8Qjz2EG42FgM+sthlHz/+Q==
X-Received: by 2002:a6b:5108:0:b0:7ce:f407:1edf with SMTP id f8-20020a6b5108000000b007cef4071edfmr6852065iob.0.1710975504349;
        Wed, 20 Mar 2024 15:58:24 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id z19-20020a6b0a13000000b007cf23a498dcsm434384ioi.38.2024.03.20.15.58.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Mar 2024 15:58:22 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 17/17] io_uring/alloc_cache: switch to array based caching
Date: Wed, 20 Mar 2024 16:55:32 -0600
Message-ID: <20240320225750.1769647-18-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240320225750.1769647-1-axboe@kernel.dk>
References: <20240320225750.1769647-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently lists are being used to manage this, but lists isn't a very
good choice for as extracting the current entry necessitates touching
the next entry as well, to update the list head.

Outside of that detail, games are also played with KASAN as the list
is inside the cached entry itself.

Finally, all users of this need a struct io_cache_entry embedded in
their struct, which is union'ized with something else in there that
isn't used across the free -> realloc cycle.

Get rid of all of that, and simply have it be an array. This will not
change the memory used, as we're just trading an 8-byte member entry
for the per-elem array size.

This reduces the overhead of the recycled allocations, and it reduces
the code we have to support recycling.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/io_uring_types.h |  2 +-
 io_uring/alloc_cache.h         | 51 +++++++++++++++-------------------
 io_uring/futex.c               | 26 ++++++-----------
 io_uring/futex.h               |  5 ++--
 io_uring/io_uring.c            | 35 ++++++++++++-----------
 io_uring/net.c                 | 13 ++++-----
 io_uring/net.h                 | 16 ++++-------
 io_uring/poll.c                | 11 ++------
 io_uring/poll.h                |  7 +----
 io_uring/rsrc.c                |  9 ++----
 io_uring/rsrc.h                |  5 +---
 io_uring/rw.c                  | 13 ++++-----
 io_uring/rw.h                  |  7 ++---
 io_uring/uring_cmd.c           | 13 ++-------
 io_uring/uring_cmd.h           |  6 +---
 15 files changed, 82 insertions(+), 137 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index e3ec84c43f1a..aeb4639785b5 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -220,7 +220,7 @@ struct io_ev_fd {
 };
 
 struct io_alloc_cache {
-	struct io_wq_work_node	list;
+	void			**entries;
 	unsigned int		nr_cached;
 	unsigned int		max_cached;
 	size_t			elem_size;
diff --git a/io_uring/alloc_cache.h b/io_uring/alloc_cache.h
index 138ad14b0b12..4349d3519563 100644
--- a/io_uring/alloc_cache.h
+++ b/io_uring/alloc_cache.h
@@ -6,61 +6,54 @@
  */
 #define IO_ALLOC_CACHE_MAX	128
 
-struct io_cache_entry {
-	struct io_wq_work_node node;
-};
-
 static inline bool io_alloc_cache_put(struct io_alloc_cache *cache,
-				      struct io_cache_entry *entry)
+				      void *entry)
 {
 	if (cache->nr_cached < cache->max_cached) {
-		cache->nr_cached++;
-		wq_stack_add_head(&entry->node, &cache->list);
-		kasan_mempool_poison_object(entry);
+		if (!kasan_mempool_poison_object(entry))
+			return false;
+		cache->entries[cache->nr_cached++] = entry;
 		return true;
 	}
 	return false;
 }
 
-static inline bool io_alloc_cache_empty(struct io_alloc_cache *cache)
-{
-	return !cache->list.next;
-}
-
-static inline struct io_cache_entry *io_alloc_cache_get(struct io_alloc_cache *cache)
+static inline void *io_alloc_cache_get(struct io_alloc_cache *cache)
 {
-	if (cache->list.next) {
-		struct io_cache_entry *entry;
+	if (cache->nr_cached) {
+		void *entry = cache->entries[--cache->nr_cached];
 
-		entry = container_of(cache->list.next, struct io_cache_entry, node);
 		kasan_mempool_unpoison_object(entry, cache->elem_size);
-		cache->list.next = cache->list.next->next;
-		cache->nr_cached--;
 		return entry;
 	}
 
 	return NULL;
 }
 
-static inline void io_alloc_cache_init(struct io_alloc_cache *cache,
-				       unsigned max_nr, size_t size)
+static inline int io_alloc_cache_init(struct io_alloc_cache *cache,
+				      unsigned max_nr, size_t size)
 {
-	cache->list.next = NULL;
+	cache->entries = kvmalloc_array(max_nr, sizeof(void *), GFP_KERNEL);
+	if (!cache->entries)
+		return -ENOMEM;
 	cache->nr_cached = 0;
 	cache->max_cached = max_nr;
 	cache->elem_size = size;
+	return 0;
 }
 
 static inline void io_alloc_cache_free(struct io_alloc_cache *cache,
-					void (*free)(struct io_cache_entry *))
+				       void (*free)(const void *))
 {
-	while (1) {
-		struct io_cache_entry *entry = io_alloc_cache_get(cache);
+	void *entry;
 
-		if (!entry)
-			break;
+	if (!cache->entries)
+		return;
+
+	while ((entry = io_alloc_cache_get(cache)) != NULL)
 		free(entry);
-	}
-	cache->nr_cached = 0;
+
+	kvfree(cache->entries);
+	cache->entries = NULL;
 }
 #endif
diff --git a/io_uring/futex.c b/io_uring/futex.c
index 792a03df58de..3dd6d394ca88 100644
--- a/io_uring/futex.c
+++ b/io_uring/futex.c
@@ -27,27 +27,19 @@ struct io_futex {
 };
 
 struct io_futex_data {
-	union {
-		struct futex_q		q;
-		struct io_cache_entry	cache;
-	};
+	struct futex_q	q;
 	struct io_kiocb	*req;
 };
 
-void io_futex_cache_init(struct io_ring_ctx *ctx)
+int io_futex_cache_init(struct io_ring_ctx *ctx)
 {
-	io_alloc_cache_init(&ctx->futex_cache, IO_NODE_ALLOC_CACHE_MAX,
+	return io_alloc_cache_init(&ctx->futex_cache, IO_NODE_ALLOC_CACHE_MAX,
 				sizeof(struct io_futex_data));
 }
 
-static void io_futex_cache_entry_free(struct io_cache_entry *entry)
-{
-	kfree(container_of(entry, struct io_futex_data, cache));
-}
-
 void io_futex_cache_free(struct io_ring_ctx *ctx)
 {
-	io_alloc_cache_free(&ctx->futex_cache, io_futex_cache_entry_free);
+	io_alloc_cache_free(&ctx->futex_cache, kfree);
 }
 
 static void __io_futex_complete(struct io_kiocb *req, struct io_tw_state *ts)
@@ -63,7 +55,7 @@ static void io_futex_complete(struct io_kiocb *req, struct io_tw_state *ts)
 	struct io_ring_ctx *ctx = req->ctx;
 
 	io_tw_lock(ctx, ts);
-	if (!io_alloc_cache_put(&ctx->futex_cache, &ifd->cache))
+	if (!io_alloc_cache_put(&ctx->futex_cache, ifd))
 		kfree(ifd);
 	__io_futex_complete(req, ts);
 }
@@ -259,11 +251,11 @@ static void io_futex_wake_fn(struct wake_q_head *wake_q, struct futex_q *q)
 
 static struct io_futex_data *io_alloc_ifd(struct io_ring_ctx *ctx)
 {
-	struct io_cache_entry *entry;
+	struct io_futex_data *ifd;
 
-	entry = io_alloc_cache_get(&ctx->futex_cache);
-	if (entry)
-		return container_of(entry, struct io_futex_data, cache);
+	ifd = io_alloc_cache_get(&ctx->futex_cache);
+	if (ifd)
+		return ifd;
 
 	return kmalloc(sizeof(struct io_futex_data), GFP_NOWAIT);
 }
diff --git a/io_uring/futex.h b/io_uring/futex.h
index 0847e9e8a127..75ea753240ba 100644
--- a/io_uring/futex.h
+++ b/io_uring/futex.h
@@ -13,7 +13,7 @@ int io_futex_cancel(struct io_ring_ctx *ctx, struct io_cancel_data *cd,
 		    unsigned int issue_flags);
 bool io_futex_remove_all(struct io_ring_ctx *ctx, struct task_struct *task,
 			 bool cancel_all);
-void io_futex_cache_init(struct io_ring_ctx *ctx);
+int io_futex_cache_init(struct io_ring_ctx *ctx);
 void io_futex_cache_free(struct io_ring_ctx *ctx);
 #else
 static inline int io_futex_cancel(struct io_ring_ctx *ctx,
@@ -27,8 +27,9 @@ static inline bool io_futex_remove_all(struct io_ring_ctx *ctx,
 {
 	return false;
 }
-static inline void io_futex_cache_init(struct io_ring_ctx *ctx)
+static inline int io_futex_cache_init(struct io_ring_ctx *ctx)
 {
+	return 0;
 }
 static inline void io_futex_cache_free(struct io_ring_ctx *ctx)
 {
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 5eee07563079..2aa3f223739a 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -273,7 +273,7 @@ static int io_alloc_hash_table(struct io_hash_table *table, unsigned bits)
 static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 {
 	struct io_ring_ctx *ctx;
-	int hash_bits;
+	int ret, hash_bits;
 
 	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
 	if (!ctx)
@@ -302,17 +302,19 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	INIT_LIST_HEAD(&ctx->sqd_list);
 	INIT_LIST_HEAD(&ctx->cq_overflow_list);
 	INIT_LIST_HEAD(&ctx->io_buffers_cache);
-	io_alloc_cache_init(&ctx->rsrc_node_cache, IO_NODE_ALLOC_CACHE_MAX,
+	ret = io_alloc_cache_init(&ctx->rsrc_node_cache, IO_NODE_ALLOC_CACHE_MAX,
 			    sizeof(struct io_rsrc_node));
-	io_alloc_cache_init(&ctx->apoll_cache, IO_ALLOC_CACHE_MAX,
+	ret |= io_alloc_cache_init(&ctx->apoll_cache, IO_ALLOC_CACHE_MAX,
 			    sizeof(struct async_poll));
-	io_alloc_cache_init(&ctx->netmsg_cache, IO_ALLOC_CACHE_MAX,
+	ret |= io_alloc_cache_init(&ctx->netmsg_cache, IO_ALLOC_CACHE_MAX,
 			    sizeof(struct io_async_msghdr));
-	io_alloc_cache_init(&ctx->rw_cache, IO_ALLOC_CACHE_MAX,
+	ret |= io_alloc_cache_init(&ctx->rw_cache, IO_ALLOC_CACHE_MAX,
 			    sizeof(struct io_async_rw));
-	io_alloc_cache_init(&ctx->uring_cache, IO_ALLOC_CACHE_MAX,
+	ret |= io_alloc_cache_init(&ctx->uring_cache, IO_ALLOC_CACHE_MAX,
 			    sizeof(struct uring_cache));
-	io_futex_cache_init(ctx);
+	ret |= io_futex_cache_init(ctx);
+	if (ret)
+		goto err;
 	init_completion(&ctx->ref_comp);
 	xa_init_flags(&ctx->personalities, XA_FLAGS_ALLOC1);
 	mutex_init(&ctx->uring_lock);
@@ -342,6 +344,12 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 
 	return ctx;
 err:
+	io_alloc_cache_free(&ctx->rsrc_node_cache, kfree);
+	io_alloc_cache_free(&ctx->apoll_cache, kfree);
+	io_alloc_cache_free(&ctx->netmsg_cache, io_netmsg_cache_free);
+	io_alloc_cache_free(&ctx->rw_cache, io_rw_cache_free);
+	io_alloc_cache_free(&ctx->uring_cache, kfree);
+	io_futex_cache_free(ctx);
 	kfree(ctx->cancel_table.hbs);
 	kfree(ctx->cancel_table_locked.hbs);
 	xa_destroy(&ctx->io_bl_xa);
@@ -1479,7 +1487,7 @@ static void io_free_batch_list(struct io_ring_ctx *ctx,
 
 				if (apoll->double_poll)
 					kfree(apoll->double_poll);
-				if (!io_alloc_cache_put(&ctx->apoll_cache, &apoll->cache))
+				if (!io_alloc_cache_put(&ctx->apoll_cache, apoll))
 					kfree(apoll);
 				req->flags &= ~REQ_F_POLLED;
 			}
@@ -2853,11 +2861,6 @@ static void io_req_caches_free(struct io_ring_ctx *ctx)
 	mutex_unlock(&ctx->uring_lock);
 }
 
-static void io_rsrc_node_cache_free(struct io_cache_entry *entry)
-{
-	kfree(container_of(entry, struct io_rsrc_node, cache));
-}
-
 static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 {
 	io_sq_thread_finish(ctx);
@@ -2872,10 +2875,10 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 		__io_sqe_files_unregister(ctx);
 	io_cqring_overflow_kill(ctx);
 	io_eventfd_unregister(ctx);
-	io_alloc_cache_free(&ctx->apoll_cache, io_apoll_cache_free);
+	io_alloc_cache_free(&ctx->apoll_cache, kfree);
 	io_alloc_cache_free(&ctx->netmsg_cache, io_netmsg_cache_free);
 	io_alloc_cache_free(&ctx->rw_cache, io_rw_cache_free);
-	io_alloc_cache_free(&ctx->uring_cache, io_uring_cache_free);
+	io_alloc_cache_free(&ctx->uring_cache, kfree);
 	io_futex_cache_free(ctx);
 	io_destroy_buffers(ctx);
 	mutex_unlock(&ctx->uring_lock);
@@ -2891,7 +2894,7 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	WARN_ON_ONCE(!list_empty(&ctx->rsrc_ref_list));
 	WARN_ON_ONCE(!list_empty(&ctx->ltimeout_list));
 
-	io_alloc_cache_free(&ctx->rsrc_node_cache, io_rsrc_node_cache_free);
+	io_alloc_cache_free(&ctx->rsrc_node_cache, kfree);
 	if (ctx->mm_account) {
 		mmdrop(ctx->mm_account);
 		ctx->mm_account = NULL;
diff --git a/io_uring/net.c b/io_uring/net.c
index 5794b941254c..6485c50493ac 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -139,7 +139,7 @@ static void io_netmsg_recycle(struct io_kiocb *req, unsigned int issue_flags)
 
 	/* Let normal cleanup path reap it if we fail adding to the cache */
 	iov = hdr->free_iov;
-	if (io_alloc_cache_put(&req->ctx->netmsg_cache, &hdr->cache)) {
+	if (io_alloc_cache_put(&req->ctx->netmsg_cache, hdr)) {
 		if (iov)
 			kasan_mempool_poison_object(iov);
 		req->async_data = NULL;
@@ -150,12 +150,10 @@ static void io_netmsg_recycle(struct io_kiocb *req, unsigned int issue_flags)
 static struct io_async_msghdr *io_msg_alloc_async(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
-	struct io_cache_entry *entry;
 	struct io_async_msghdr *hdr;
 
-	entry = io_alloc_cache_get(&ctx->netmsg_cache);
-	if (entry) {
-		hdr = container_of(entry, struct io_async_msghdr, cache);
+	hdr = io_alloc_cache_get(&ctx->netmsg_cache);
+	if (hdr) {
 		if (hdr->free_iov) {
 			kasan_mempool_unpoison_object(hdr->free_iov,
 				hdr->free_iov_nr * sizeof(struct iovec));
@@ -1492,11 +1490,10 @@ int io_connect(struct io_kiocb *req, unsigned int issue_flags)
 	return IOU_OK;
 }
 
-void io_netmsg_cache_free(struct io_cache_entry *entry)
+void io_netmsg_cache_free(const void *entry)
 {
-	struct io_async_msghdr *kmsg;
+	struct io_async_msghdr *kmsg = (struct io_async_msghdr *) entry;
 
-	kmsg = container_of(entry, struct io_async_msghdr, cache);
 	if (kmsg->free_iov) {
 		kasan_mempool_unpoison_object(kmsg->free_iov,
 				kmsg->free_iov_nr * sizeof(struct iovec));
diff --git a/io_uring/net.h b/io_uring/net.h
index b47b43ec6459..c48c44a81850 100644
--- a/io_uring/net.h
+++ b/io_uring/net.h
@@ -7,19 +7,13 @@
 
 struct io_async_msghdr {
 #if defined(CONFIG_NET)
-	union {
-		struct iovec			fast_iov;
-		struct {
-			struct io_cache_entry	cache;
-			/* entry size of ->free_iov, if valid */
-			int			free_iov_nr;
-		};
-	};
+	struct iovec			fast_iov;
 	/* points to an allocated iov, if NULL we use fast_iov instead */
 	struct iovec			*free_iov;
+	int				free_iov_nr;
+	int				namelen;
 	__kernel_size_t			controllen;
 	__kernel_size_t			payloadlen;
-	int				namelen;
 	struct sockaddr __user		*uaddr;
 	struct msghdr			msg;
 	struct sockaddr_storage		addr;
@@ -57,9 +51,9 @@ int io_sendmsg_zc(struct io_kiocb *req, unsigned int issue_flags);
 int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 void io_send_zc_cleanup(struct io_kiocb *req);
 
-void io_netmsg_cache_free(struct io_cache_entry *entry);
+void io_netmsg_cache_free(const void *entry);
 #else
-static inline void io_netmsg_cache_free(struct io_cache_entry *entry)
+static inline void io_netmsg_cache_free(const void *entry)
 {
 }
 #endif
diff --git a/io_uring/poll.c b/io_uring/poll.c
index 5d55bbf1de15..536c4eda7c26 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -686,17 +686,15 @@ static struct async_poll *io_req_alloc_apoll(struct io_kiocb *req,
 					     unsigned issue_flags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
-	struct io_cache_entry *entry;
 	struct async_poll *apoll;
 
 	if (req->flags & REQ_F_POLLED) {
 		apoll = req->apoll;
 		kfree(apoll->double_poll);
 	} else if (!(issue_flags & IO_URING_F_UNLOCKED)) {
-		entry = io_alloc_cache_get(&ctx->apoll_cache);
-		if (entry == NULL)
+		apoll = io_alloc_cache_get(&ctx->apoll_cache);
+		if (!apoll)
 			goto alloc_apoll;
-		apoll = container_of(entry, struct async_poll, cache);
 		apoll->poll.retries = APOLL_MAX_RETRY;
 	} else {
 alloc_apoll:
@@ -1055,8 +1053,3 @@ int io_poll_remove(struct io_kiocb *req, unsigned int issue_flags)
 	io_req_set_res(req, ret, 0);
 	return IOU_OK;
 }
-
-void io_apoll_cache_free(struct io_cache_entry *entry)
-{
-	kfree(container_of(entry, struct async_poll, cache));
-}
diff --git a/io_uring/poll.h b/io_uring/poll.h
index 1dacae9e816c..f67c5aeabb63 100644
--- a/io_uring/poll.h
+++ b/io_uring/poll.h
@@ -17,10 +17,7 @@ struct io_poll {
 };
 
 struct async_poll {
-	union {
-		struct io_poll		poll;
-		struct io_cache_entry	cache;
-	};
+	struct io_poll		poll;
 	struct io_poll		*double_poll;
 };
 
@@ -46,6 +43,4 @@ int io_arm_poll_handler(struct io_kiocb *req, unsigned issue_flags);
 bool io_poll_remove_all(struct io_ring_ctx *ctx, struct task_struct *tsk,
 			bool cancel_all);
 
-void io_apoll_cache_free(struct io_cache_entry *entry);
-
 void io_poll_task_func(struct io_kiocb *req, struct io_tw_state *ts);
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 7195c01e675a..2def86427a5e 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -169,7 +169,7 @@ static void io_rsrc_put_work(struct io_rsrc_node *node)
 
 void io_rsrc_node_destroy(struct io_ring_ctx *ctx, struct io_rsrc_node *node)
 {
-	if (!io_alloc_cache_put(&ctx->rsrc_node_cache, &node->cache))
+	if (!io_alloc_cache_put(&ctx->rsrc_node_cache, node))
 		kfree(node);
 }
 
@@ -197,12 +197,9 @@ void io_rsrc_node_ref_zero(struct io_rsrc_node *node)
 struct io_rsrc_node *io_rsrc_node_alloc(struct io_ring_ctx *ctx)
 {
 	struct io_rsrc_node *ref_node;
-	struct io_cache_entry *entry;
 
-	entry = io_alloc_cache_get(&ctx->rsrc_node_cache);
-	if (entry) {
-		ref_node = container_of(entry, struct io_rsrc_node, cache);
-	} else {
+	ref_node = io_alloc_cache_get(&ctx->rsrc_node_cache);
+	if (!ref_node) {
 		ref_node = kzalloc(sizeof(*ref_node), GFP_KERNEL);
 		if (!ref_node)
 			return NULL;
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index e21000238954..b4cec653100d 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -36,10 +36,7 @@ struct io_rsrc_data {
 };
 
 struct io_rsrc_node {
-	union {
-		struct io_cache_entry		cache;
-		struct io_ring_ctx		*ctx;
-	};
+	struct io_ring_ctx		*ctx;
 	int				refs;
 	bool				empty;
 	u16				type;
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 57f2d315a620..6849795532ab 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -154,7 +154,7 @@ static void io_rw_recycle(struct io_kiocb *req, unsigned int issue_flags)
 		return;
 	}
 	iov = rw->free_iovec;
-	if (io_alloc_cache_put(&req->ctx->rw_cache, &rw->cache)) {
+	if (io_alloc_cache_put(&req->ctx->rw_cache, rw)) {
 		if (iov)
 			kasan_mempool_poison_object(iov);
 		req->async_data = NULL;
@@ -200,12 +200,10 @@ static void io_req_rw_cleanup(struct io_kiocb *req, unsigned int issue_flags)
 static int io_rw_alloc_async(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
-	struct io_cache_entry *entry;
 	struct io_async_rw *rw;
 
-	entry = io_alloc_cache_get(&ctx->rw_cache);
-	if (entry) {
-		rw = container_of(entry, struct io_async_rw, cache);
+	rw = io_alloc_cache_get(&ctx->rw_cache);
+	if (rw) {
 		if (rw->free_iovec) {
 			kasan_mempool_unpoison_object(rw->free_iovec,
 				rw->free_iov_nr * sizeof(struct iovec));
@@ -1180,11 +1178,10 @@ int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
 	return nr_events;
 }
 
-void io_rw_cache_free(struct io_cache_entry *entry)
+void io_rw_cache_free(const void *entry)
 {
-	struct io_async_rw *rw;
+	struct io_async_rw *rw = (struct io_async_rw *) entry;
 
-	rw = container_of(entry, struct io_async_rw, cache);
 	if (rw->free_iovec) {
 		kasan_mempool_unpoison_object(rw->free_iovec,
 				rw->free_iov_nr * sizeof(struct iovec));
diff --git a/io_uring/rw.h b/io_uring/rw.h
index cf51d0eb407a..3f432dc75441 100644
--- a/io_uring/rw.h
+++ b/io_uring/rw.h
@@ -3,10 +3,7 @@
 #include <linux/pagemap.h>
 
 struct io_async_rw {
-	union {
-		size_t			bytes_done;
-		struct io_cache_entry	cache;
-	};
+	size_t				bytes_done;
 	struct iov_iter			iter;
 	struct iov_iter_state		iter_state;
 	struct iovec			fast_iov;
@@ -28,4 +25,4 @@ void io_rw_fail(struct io_kiocb *req);
 void io_req_rw_complete(struct io_kiocb *req, struct io_tw_state *ts);
 int io_read_mshot_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_read_mshot(struct io_kiocb *req, unsigned int issue_flags);
-void io_rw_cache_free(struct io_cache_entry *entry);
+void io_rw_cache_free(const void *entry);
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 92346b5d9f5b..509cfd56726c 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -17,12 +17,10 @@
 static struct uring_cache *io_uring_async_get(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
-	struct io_cache_entry *entry;
 	struct uring_cache *cache;
 
-	entry = io_alloc_cache_get(&ctx->uring_cache);
-	if (entry) {
-		cache = container_of(entry, struct uring_cache, cache);
+	cache = io_alloc_cache_get(&ctx->uring_cache);
+	if (cache) {
 		req->flags |= REQ_F_ASYNC_DATA;
 		req->async_data = cache;
 		return cache;
@@ -39,7 +37,7 @@ static void io_req_uring_cleanup(struct io_kiocb *req, unsigned int issue_flags)
 
 	if (issue_flags & IO_URING_F_UNLOCKED)
 		return;
-	if (io_alloc_cache_put(&req->ctx->uring_cache, &cache->cache)) {
+	if (io_alloc_cache_put(&req->ctx->uring_cache, cache)) {
 		ioucmd->sqe = NULL;
 		req->async_data = NULL;
 		req->flags &= ~REQ_F_ASYNC_DATA;
@@ -354,8 +352,3 @@ int io_uring_cmd_sock(struct io_uring_cmd *cmd, unsigned int issue_flags)
 }
 EXPORT_SYMBOL_GPL(io_uring_cmd_sock);
 #endif
-
-void io_uring_cache_free(struct io_cache_entry *entry)
-{
-	kfree(container_of(entry, struct uring_cache, cache));
-}
diff --git a/io_uring/uring_cmd.h b/io_uring/uring_cmd.h
index 477ea8865639..a361f98664d2 100644
--- a/io_uring/uring_cmd.h
+++ b/io_uring/uring_cmd.h
@@ -1,15 +1,11 @@
 // SPDX-License-Identifier: GPL-2.0
 
 struct uring_cache {
-	union {
-		struct io_cache_entry cache;
-		struct io_uring_sqe sqes[2];
-	};
+	struct io_uring_sqe sqes[2];
 };
 
 int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags);
 int io_uring_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
-void io_uring_cache_free(struct io_cache_entry *entry);
 
 bool io_uring_try_cancel_uring_cmd(struct io_ring_ctx *ctx,
 				   struct task_struct *task, bool cancel_all);
-- 
2.43.0


