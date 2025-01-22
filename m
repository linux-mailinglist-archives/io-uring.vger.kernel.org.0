Return-Path: <io-uring+bounces-6046-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 17A7BA1961E
	for <lists+io-uring@lfdr.de>; Wed, 22 Jan 2025 17:08:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BED8316C7D0
	for <lists+io-uring@lfdr.de>; Wed, 22 Jan 2025 16:08:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 781A9214A79;
	Wed, 22 Jan 2025 16:08:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WEb5ADUP"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CD6D211475;
	Wed, 22 Jan 2025 16:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737562080; cv=none; b=bbBIIeb908gjyIdB5pAijzgTjWinyT456EMTapTbzQQnzI6dWuWSN3V0bNiEKMpBU1ElM472h4TUhWiCp1A4A3iiQe+CtgQR7lQVJhLJ8+pPoBt+Uy7a6df50A60sPzWwJURdEVyYkranbgsRh6qzIaEjG3j44EtoEuLggXyKCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737562080; c=relaxed/simple;
	bh=HYKEuJgXgUK//ZePhA4iQiyNt3lymn9tIGc8eFoiTGA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CE8IFmCDU5hZFS9YYQvnQ3bquha0yxnHRrl9MYB/FL6Vql+9DYdopwRQajulPTfGupnAexRQnKckAT1dd1uYfaV1g2RB1GVbpogd29ZO9XugWpzkqCGzieokKAJvlWKV8R6sPZj5s/2WzJaFffBS9w6QA7iD0L5tWWG9N+KoTqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WEb5ADUP; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-542678284e3so925620e87.1;
        Wed, 22 Jan 2025 08:07:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737562076; x=1738166876; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+BA0Dq1q60oIyJKUAlr4eKLYkxcKes1Z2J5zA+l+Dug=;
        b=WEb5ADUPKq9WWFlVlHLlk1lrEIwc9dEQo1J5KKviJJviusfSakJgPKw0a0ZjD2QelO
         pdDdxYfX6pC/O1pAJqjlrjRdcPLaewd98ysxAgXU1zt9sDOZSduM8I//vtR146X2uNA2
         XnwsKZbSW+dZzUuHvxQEpFl7KE2rbj98jEEUGOCDf+M2JNXi1DExlwdy5DzuZ+avicFf
         c1n60v4pcAGFQSlYZzyjY13uHEcvIrJheohVEDa+X0VjV0nCFR8MsKp4JH3vA78gUDbp
         qBqH2W2Ha3i6aWOElSwtxx5zHJvQD2jevj7VVlwuf3kTYh9RG0kb/H5WHd+hoGKJdFjh
         x/Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737562076; x=1738166876;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+BA0Dq1q60oIyJKUAlr4eKLYkxcKes1Z2J5zA+l+Dug=;
        b=D1mgiIuO0b8d92pYPjFBwc697fihybewC8s916HwURVNtpjjI6UGF2q5mO/6O/K5aX
         0omWfeCim0A8MuCnQtPO20/lfsY+9OthtNZxq6pifGyS2UJYZFdwTuBbkBHCcDkl1q/H
         ZYc/sZNSH+Ma3au+7tI8bvdPNa2oWEcRxuFmEIWdOxlqxrMmjtT7ytDVASIy1HyQlTwF
         97i0waTAC3n69e0xqAlvtsZ8ezpe42DXIKLPCEjj/ZHQLEyGpe/nRsb1sAt5vTe/pVQe
         WAay409CT0I/XR6Ozn/gdT2asjUWS0do9PF8KeWCSKYcMYZsGZuD4uFv0LebjWRtMuc5
         hirw==
X-Forwarded-Encrypted: i=1; AJvYcCVspPZgHzJM1MTZJc8nWm/WpESuklVG9+XUkoQFWMgZu2D/keoU42CU0UCJHKDOBB/kUtFlR34jdw==@vger.kernel.org, AJvYcCVxBjwzc9Kw4Rbs8YwcI66gaeWvJ0G+M7xDaopr0S36G9pAMh0sTuOhrtCeKGobabqWjbebEXoKqyqy8suN@vger.kernel.org, AJvYcCXRUwnVn1Wo+6c5wNk32hsIefy2qKU25DOwegnPCGCGq0PV6VL5o0ezfF1Xlw+pfRNOoZJNv5vA@vger.kernel.org, AJvYcCXqE3+nkhMkbUPGHpZChQwmO0jqnydBAiEB0/9WT5AjebnLIIwxKqq2cmLI4PdN8EnwSXGoz8ke@vger.kernel.org
X-Gm-Message-State: AOJu0Yxe3IkxX16jhC8TmQv2l/IZv4vrpyc61RcnwPb7SKgZ9bolWYbA
	enO+yyp9jIo9xEV4vgPrVmu9pRDl1/E/Sf06UExR6KaCWJvCEJkr
X-Gm-Gg: ASbGncsn9Lw6qcCOsuyjNtXPr8AxYrHFmrd2CJJhPzKjGa/47M4AuStYWF/mS/KEyW1
	HQYKnkcWdKBy47z101cFTrep+5lQIUXP73nhAWqHC+qPuCSJ5kMuRqt3Inw/aXtK5rhi74LEFGd
	JIvOGz2MViuEs7Yb5Is+qw0AnL0dpdBzm2fDn2Sp0lZMNwW2Sm/ivKzJO3SXnSAoAUQRa7yl0Hs
	m8AejuzxRVD9s7XdqFi89xBnZw1v3pec233um26BmA69FPXlanjqqeB4iYf8SZ/egBVRcd8+EJ8
	NnciHA==
X-Google-Smtp-Source: AGHT+IGGZpwAJ9lJiPJhXSzYlw+p5ZWyX/qDwlwfOEADUtFjFGOfxHiDxPvmkO/tSicDPCzuqDTAGw==
X-Received: by 2002:a05:6512:32c9:b0:542:9807:97b3 with SMTP id 2adb3069b0e04-543bb342b23mr680624e87.4.1737562075993;
        Wed, 22 Jan 2025 08:07:55 -0800 (PST)
Received: from dellarbn.yandex.net ([80.93.240.67])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5439af60c4esm2327409e87.128.2025.01.22.08.07.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2025 08:07:55 -0800 (PST)
From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kasan-dev@googlegroups.com,
	io-uring@vger.kernel.org,
	linux-mm@kvack.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	juntong.deng@outlook.com,
	lizetao1@huawei.com,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	stable@vger.kernel.org,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>
Subject: [PATCH] kasan, mempool: don't store free stacktrace in io_alloc_cache objects.
Date: Wed, 22 Jan 2025 17:06:45 +0100
Message-ID: <20250122160645.28926-1-ryabinin.a.a@gmail.com>
X-Mailer: git-send-email 2.45.3
In-Reply-To: <CAPAsAGwzBeGXbVtWtZKhbUDbD4b4PtgAS9MJYU2kkiNHgyKpfQ@mail.gmail.com>
References: <CAPAsAGwzBeGXbVtWtZKhbUDbD4b4PtgAS9MJYU2kkiNHgyKpfQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Running the testcase liburing/accept-reust.t with CONFIG_KASAN=y and
CONFIG_KASAN_EXTRA_INFO=y leads to the following crash:

    Unable to handle kernel paging request at virtual address 00000c6455008008
    ...
    pc : __kasan_mempool_unpoison_object+0x38/0x170
    lr : io_netmsg_cache_free+0x8c/0x180
    ...
    Call trace:
     __kasan_mempool_unpoison_object+0x38/0x170 (P)
     io_netmsg_cache_free+0x8c/0x180
     io_ring_exit_work+0xd4c/0x13a0
     process_one_work+0x52c/0x1000
     worker_thread+0x830/0xdc0
     kthread+0x2bc/0x348
     ret_from_fork+0x10/0x20

Since the commit b556a462eb8d ("kasan: save free stack traces for slab mempools")
kasan_mempool_poison_object() stores some info inside an object.
It was expected that the object must be reinitialized after
kasan_mempool_unpoison_object() call, and this is what happens in the
most of use cases.

However io_uring code expects that io_alloc_cache_put/get doesn't modify
the object, so kasan_mempool_poison_object() end up corrupting it leading
to crash later.

Add @notrack argument to kasan_mempool_poison_object() call to tell
KASAN to avoid storing info in objects for io_uring use case.

Reported-by: lizetao <lizetao1@huawei.com>
Closes: https://lkml.kernel.org/r/ec2a6ca08c614c10853fbb1270296ac4@huawei.com
Fixes: b556a462eb8d ("kasan: save free stack traces for slab mempools")
Cc: stable@vger.kernel.org
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Pavel Begunkov <asml.silence@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Simon Horman <horms@kernel.org>
Signed-off-by: Andrey Ryabinin <ryabinin.a.a@gmail.com>
---
 include/linux/kasan.h  | 13 +++++++------
 io_uring/alloc_cache.h |  2 +-
 io_uring/net.c         |  2 +-
 io_uring/rw.c          |  2 +-
 mm/kasan/common.c      | 11 ++++++-----
 mm/mempool.c           |  2 +-
 net/core/skbuff.c      |  2 +-
 7 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/include/linux/kasan.h b/include/linux/kasan.h
index 890011071f2b..4d0bf4af399d 100644
--- a/include/linux/kasan.h
+++ b/include/linux/kasan.h
@@ -328,18 +328,19 @@ static __always_inline void kasan_mempool_unpoison_pages(struct page *page,
 		__kasan_mempool_unpoison_pages(page, order, _RET_IP_);
 }
 
-bool __kasan_mempool_poison_object(void *ptr, unsigned long ip);
+bool __kasan_mempool_poison_object(void *ptr, bool notrack, unsigned long ip);
 /**
  * kasan_mempool_poison_object - Check and poison a mempool slab allocation.
  * @ptr: Pointer to the slab allocation.
+ * @notrack: Don't record stack trace of this call in the object.
  *
  * This function is intended for kernel subsystems that cache slab allocations
  * to reuse them instead of freeing them back to the slab allocator (e.g.
  * mempool).
  *
  * This function poisons a slab allocation and saves a free stack trace for it
- * without initializing the allocation's memory and without putting it into the
- * quarantine (for the Generic mode).
+ * (if @notrack == false) without initializing the allocation's memory and
+ * without putting it into the quarantine (for the Generic mode).
  *
  * This function also performs checks to detect double-free and invalid-free
  * bugs and reports them. The caller can use the return value of this function
@@ -354,10 +355,10 @@ bool __kasan_mempool_poison_object(void *ptr, unsigned long ip);
  *
  * Return: true if the allocation can be safely reused; false otherwise.
  */
-static __always_inline bool kasan_mempool_poison_object(void *ptr)
+static __always_inline bool kasan_mempool_poison_object(void *ptr, bool notrack)
 {
 	if (kasan_enabled())
-		return __kasan_mempool_poison_object(ptr, _RET_IP_);
+		return __kasan_mempool_poison_object(ptr, notrack, _RET_IP_);
 	return true;
 }
 
@@ -456,7 +457,7 @@ static inline bool kasan_mempool_poison_pages(struct page *page, unsigned int or
 	return true;
 }
 static inline void kasan_mempool_unpoison_pages(struct page *page, unsigned int order) {}
-static inline bool kasan_mempool_poison_object(void *ptr)
+static inline bool kasan_mempool_poison_object(void *ptr, bool notrack)
 {
 	return true;
 }
diff --git a/io_uring/alloc_cache.h b/io_uring/alloc_cache.h
index a3a8cfec32ce..dd508dddea33 100644
--- a/io_uring/alloc_cache.h
+++ b/io_uring/alloc_cache.h
@@ -10,7 +10,7 @@ static inline bool io_alloc_cache_put(struct io_alloc_cache *cache,
 				      void *entry)
 {
 	if (cache->nr_cached < cache->max_cached) {
-		if (!kasan_mempool_poison_object(entry))
+		if (!kasan_mempool_poison_object(entry, true))
 			return false;
 		cache->entries[cache->nr_cached++] = entry;
 		return true;
diff --git a/io_uring/net.c b/io_uring/net.c
index 85f55fbc25c9..a954e37c7fd3 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -149,7 +149,7 @@ static void io_netmsg_recycle(struct io_kiocb *req, unsigned int issue_flags)
 	iov = hdr->free_iov;
 	if (io_alloc_cache_put(&req->ctx->netmsg_cache, hdr)) {
 		if (iov)
-			kasan_mempool_poison_object(iov);
+			kasan_mempool_poison_object(iov, true);
 		req->async_data = NULL;
 		req->flags &= ~REQ_F_ASYNC_DATA;
 	}
diff --git a/io_uring/rw.c b/io_uring/rw.c
index a9a2733be842..cba475003ba7 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -167,7 +167,7 @@ static void io_rw_recycle(struct io_kiocb *req, unsigned int issue_flags)
 	iov = rw->free_iovec;
 	if (io_alloc_cache_put(&req->ctx->rw_cache, rw)) {
 		if (iov)
-			kasan_mempool_poison_object(iov);
+			kasan_mempool_poison_object(iov, true);
 		req->async_data = NULL;
 		req->flags &= ~REQ_F_ASYNC_DATA;
 	}
diff --git a/mm/kasan/common.c b/mm/kasan/common.c
index ed4873e18c75..e7b54aa9494e 100644
--- a/mm/kasan/common.c
+++ b/mm/kasan/common.c
@@ -230,7 +230,8 @@ static bool check_slab_allocation(struct kmem_cache *cache, void *object,
 }
 
 static inline void poison_slab_object(struct kmem_cache *cache, void *object,
-				      bool init, bool still_accessible)
+				      bool init, bool still_accessible,
+				      bool notrack)
 {
 	void *tagged_object = object;
 
@@ -243,7 +244,7 @@ static inline void poison_slab_object(struct kmem_cache *cache, void *object,
 	kasan_poison(object, round_up(cache->object_size, KASAN_GRANULE_SIZE),
 			KASAN_SLAB_FREE, init);
 
-	if (kasan_stack_collection_enabled())
+	if (kasan_stack_collection_enabled() && !notrack)
 		kasan_save_free_info(cache, tagged_object);
 }
 
@@ -261,7 +262,7 @@ bool __kasan_slab_free(struct kmem_cache *cache, void *object, bool init,
 	if (!kasan_arch_is_ready() || is_kfence_address(object))
 		return false;
 
-	poison_slab_object(cache, object, init, still_accessible);
+	poison_slab_object(cache, object, init, still_accessible, true);
 
 	/*
 	 * If the object is put into quarantine, do not let slab put the object
@@ -495,7 +496,7 @@ void __kasan_mempool_unpoison_pages(struct page *page, unsigned int order,
 	__kasan_unpoison_pages(page, order, false);
 }
 
-bool __kasan_mempool_poison_object(void *ptr, unsigned long ip)
+bool __kasan_mempool_poison_object(void *ptr, bool notrack, unsigned long ip)
 {
 	struct folio *folio = virt_to_folio(ptr);
 	struct slab *slab;
@@ -519,7 +520,7 @@ bool __kasan_mempool_poison_object(void *ptr, unsigned long ip)
 	if (check_slab_allocation(slab->slab_cache, ptr, ip))
 		return false;
 
-	poison_slab_object(slab->slab_cache, ptr, false, false);
+	poison_slab_object(slab->slab_cache, ptr, false, false, notrack);
 	return true;
 }
 
diff --git a/mm/mempool.c b/mm/mempool.c
index 3223337135d0..283df5d2b995 100644
--- a/mm/mempool.c
+++ b/mm/mempool.c
@@ -115,7 +115,7 @@ static inline void poison_element(mempool_t *pool, void *element)
 static __always_inline bool kasan_poison_element(mempool_t *pool, void *element)
 {
 	if (pool->alloc == mempool_alloc_slab || pool->alloc == mempool_kmalloc)
-		return kasan_mempool_poison_object(element);
+		return kasan_mempool_poison_object(element, false);
 	else if (pool->alloc == mempool_alloc_pages)
 		return kasan_mempool_poison_pages(element,
 						(unsigned long)pool->pool_data);
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index a441613a1e6c..c9f58a698bb7 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1457,7 +1457,7 @@ static void napi_skb_cache_put(struct sk_buff *skb)
 	struct napi_alloc_cache *nc = this_cpu_ptr(&napi_alloc_cache);
 	u32 i;
 
-	if (!kasan_mempool_poison_object(skb))
+	if (!kasan_mempool_poison_object(skb, false))
 		return;
 
 	local_lock_nested_bh(&napi_alloc_cache.bh_lock);
-- 
2.45.3


