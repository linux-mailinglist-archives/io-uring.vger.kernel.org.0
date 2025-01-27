Return-Path: <io-uring+bounces-6137-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E1F74A1D8F9
	for <lists+io-uring@lfdr.de>; Mon, 27 Jan 2025 16:05:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 348ED3A48F6
	for <lists+io-uring@lfdr.de>; Mon, 27 Jan 2025 15:05:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB7CB38DEC;
	Mon, 27 Jan 2025 15:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i8jrHqCH"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA8442D7BF;
	Mon, 27 Jan 2025 15:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737990315; cv=none; b=DvQ60pCgDLzps/tunArerORIHg6HKp9e289Q0uydLQuciFky+HchRBORrn59aOnHt9GVG/Ij7eB53T6Pfbkv22JrOzDJSuQXz3TBdLjs8chnyAAh4Q/TcHSXntwX8kg3kyCA8GygqjAVo6pmvuO/QUbAfPJxpSk4EIM7MYmCmyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737990315; c=relaxed/simple;
	bh=2GHpFZLB6pKhMP7oeSbkXwAVGGLiGJn5ZVZLv5GwvQM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VKCZT8hrza2/ABrM69L1NdPGQGZSB1ICu4rv7OyAPFlffK0/+XNONaKOIv7qbjj9sqvLdsBb7x1OCvQ4CEg3DxBtuQzXncuhUhwPTu1D8pwD5GmHYp2ebaVDGfJCLH1IefDSjC8E25ucYyAUjvNSTlHxpjFjj+7mqfF8jdQ6SJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=i8jrHqCH; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-542678284e3so804383e87.1;
        Mon, 27 Jan 2025 07:05:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737990312; x=1738595112; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a99Cj+rOUzLKKfU2RGwugGZfMRB43qPpEZQgebXePjs=;
        b=i8jrHqCHmGa6RvUNrwPSfNvXDzjT1q+NiPXFmuIQ1B6ktzW8aVDCepdaUuL6Dies4s
         P/nMLsiFLyP3sZe4ffWHC0FjrRAGD+s+1zM+I5GqcFCERZYA+MAWqZFmwCLek8nggOfe
         /mLbyFZo9H8ZkmUtighFed2Y9FlVGy6+05z8mh6HZxS0HY21qMG2ESgEsFpBVkZ3GfwM
         zFvfVj0l1JqtzIWrQcZRIcJIPRsJVCD7vrJ/oBlK79YskCAUPG7vbmkt4nPnWaTN7ySS
         lZFfBYqN7aA0G7AMOioa2a8Qe8nGk4VBDO395JyZ1p0VtwKo8IZMAyB8m+nrvDtt+/lP
         E7Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737990312; x=1738595112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=a99Cj+rOUzLKKfU2RGwugGZfMRB43qPpEZQgebXePjs=;
        b=Yh/XwPpEq8owWKj1Lt5CLRHHINVptHWENzsD5OYfCEZW+Feyrk8wP0oyiiUkm/Tkrc
         9g3Y8kvkqZRwLje6SJOOMLMkOAui/FaNcc6fk+IwJ59xdE7XOGJ1ujcPV68fDfw1GUW7
         0Y2eDVG3dNlbwIOc/SQfS8f+alW6VDx1a9Tg0xiCQ0YT8UPByWRVKZXA8/ODXfiUmH8F
         UjmzFPmge9Ehdnq2+nXScRMuyqYsybRZ3CyztlIgSeHr0eODm+CL3wEo1E6TN03gLG+G
         HMO9mCoAAmBX105BcpaEeS7wRjRXzL+mEtSW692iIjnovyjAdAxqC3/AYqTYxuuZqs5Z
         MevA==
X-Forwarded-Encrypted: i=1; AJvYcCVhhjBms7ciyL+4tCQKIJb1QcMpaXF0fMOQkqoHITp+We1GFXwcVMd/RZMGI15rhNubFWoEFaikjw==@vger.kernel.org, AJvYcCWAV3N6JM3kg0x/v2voS2X7p6GoPAdI1a8akzgRjKBO697zKWnLjs35ViGZoCTx/bt4CYyCQoKd@vger.kernel.org, AJvYcCWn/Apj6styM2Enr63uBPSzGIDngeJbbC0f+lPbrHv2AG3Fd1wGternn8yKi0+FcQ+/Zer9yrAe@vger.kernel.org, AJvYcCXCNsoBKErYpgk+e+Jf5yrgKiSxPuNzpxUExyiubwU4Hh+wznpiJ5zpznFBBtWpR169++/2iPz8qpMp+ApR@vger.kernel.org
X-Gm-Message-State: AOJu0YxA92ZrXrnobacFX6J6pYtN2MwPY1VKVPUXd5z8naeIQMHubbza
	/DsvAKv0NUiirF2TwTaJJZPzTqo0TxTiOalGNUJPOSpcrYFrNcvp
X-Gm-Gg: ASbGncuPmNp3PSFmbko+BtHYjg8AlhFftAFStR702NXYdlT16rbA0XQwFOTB6D6a96x
	ZIyxqMyeAzymhIXgeW5sVWUuLWRwqVSfae0pdMBn/aEaKLgnk4gat+b+uyxka3G7eCdOyqqgOfV
	f9F5uGIf2gCwdRxMe0+/Xswr1zP2QD3QLC7OL/Cu7YhUuefHAPYn0ZUJSbpWxKO/E9LKoWYba+h
	Xa3RnQOS+PCqVSy2cXillchqrC6rpB38AhKp0hzbzi92b7b4lOmlWjEFPIoiq3M29z3a5v5KUPx
	+UTnpQwFPxCK/eblNw1B1n1TcJs=
X-Google-Smtp-Source: AGHT+IHeIZIN8oQR3WZy6k1X7FnNxiCnPJubuJR42xuKYwGelkaQbvxKLzFF0Y0dYY2Ot+nJGIpTnA==
X-Received: by 2002:ac2:4c4f:0:b0:542:297e:86c with SMTP id 2adb3069b0e04-543bb2ecf6emr3097051e87.0.1737990311100;
        Mon, 27 Jan 2025 07:05:11 -0800 (PST)
Received: from dellarbn.yandex.net ([80.93.240.68])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-543c83684c6sm1321436e87.107.2025.01.27.07.05.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jan 2025 07:05:10 -0800 (PST)
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
Subject: [PATCH v2] kasan, mempool: don't store free stacktrace in io_alloc_cache objects.
Date: Mon, 27 Jan 2025 16:03:57 +0100
Message-ID: <20250127150357.13565-1-ryabinin.a.a@gmail.com>
X-Mailer: git-send-email 2.45.3
In-Reply-To: <20250122160645.28926-1-ryabinin.a.a@gmail.com>
References: <20250122160645.28926-1-ryabinin.a.a@gmail.com>
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
 - Changes since v1:
    s/true/false @notrack in __kasan_slab_free() per @andreyknvl

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
index ed4873e18c75..f08752dcd50b 100644
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
+	poison_slab_object(cache, object, init, still_accessible, false);
 
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


