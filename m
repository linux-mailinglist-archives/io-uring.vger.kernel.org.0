Return-Path: <io-uring+bounces-303-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9178D8191E8
	for <lists+io-uring@lfdr.de>; Tue, 19 Dec 2023 22:04:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 212FC282D7C
	for <lists+io-uring@lfdr.de>; Tue, 19 Dec 2023 21:04:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56A373C46D;
	Tue, 19 Dec 2023 21:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="DNaHuW9J"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCCD93B191
	for <io-uring@vger.kernel.org>; Tue, 19 Dec 2023 21:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-5c673b01eeeso2060941a12.1
        for <io-uring@vger.kernel.org>; Tue, 19 Dec 2023 13:04:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1703019848; x=1703624648; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C5DHyX6aeoJMKvf3FMrIDlFr+7zOXVmc0yCRXRvCbfw=;
        b=DNaHuW9JyCsGjRr32FZPjepveILYCjfq/NnQ5P+SElQi/jJBJDR7xLy3zeoRr0B47F
         /82kHVdDftMc5fRmHH75Olo/PpecEW6xhz72icYfBdAhSsXePomp4WDV8r9W0WjkjXe8
         VWmnPMCBx4WX1ixDBanNjr0xjl4c0EUQm9AQIRq3fhcajJDV/M5f7mGG9a8i8JhEPcRd
         1LqMXhFflA178I7DOiE9sILA9BFqdb+RTyHN6n0wz5fqzUi8sdDdwIdz3R5xnhtcf+dC
         41SZpoCCtBnTZAud1vNlupTsutLyJK5EgaYQEN/G/Lj+rAvUbCRF992UGQXckMkUvMm0
         Ou0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703019848; x=1703624648;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C5DHyX6aeoJMKvf3FMrIDlFr+7zOXVmc0yCRXRvCbfw=;
        b=XxfBuCJFoybRWXOcRlPR5ViDJy6FiPoTJd1ZEv65ab6jNsagAhKbWaeIBVGLuhERjt
         KmA2otFgYRMY+IScMDQhcZ7JJeJIWCOq1cn+hw8XLlo6zj4faX6Cq0MLecSpEuFb+aPj
         GHZXxvcFjvqfQ8FgCZk86WDdmeWO7E3Ae30/XstBuFxVXf/+Tq8PAdzpUknA7h7AlHAf
         XnHBHpFoiGQXmEP9mTkNraPIpbKf0uNFcEi2LimA7PWUAOw5iKgpgRvgIS7AbTn5/5O0
         PAz6LCqA1VbxmA++/z2kPyh5y7W41WcRw8iwdyzBXFFqaq04GEWPTWdbgtnsXAYnqv6G
         aXIQ==
X-Gm-Message-State: AOJu0YzqHFYVcoC0ZXaA4UvLFoXXmX8dsxpkok0KVEZwBKDaHp2g+4vl
	7AKjz4JIGAa58YQzIuTbdUPhLBGHh3nKqWydiJqRLQ==
X-Google-Smtp-Source: AGHT+IGng/UXhQ+pTyRj8hIhoKPfhzyfyq52gtF64Uvn9PD+x5fXxFr0YyiQhiVsLPL8ylYTdzjzaw==
X-Received: by 2002:a17:90a:b901:b0:28b:1f1e:827e with SMTP id p1-20020a17090ab90100b0028b1f1e827emr3955367pjr.48.1703019847844;
        Tue, 19 Dec 2023 13:04:07 -0800 (PST)
Received: from localhost (fwdproxy-prn-119.fbsv.net. [2a03:2880:ff:77::face:b00c])
        by smtp.gmail.com with ESMTPSA id oe7-20020a17090b394700b0028a69db1f51sm2110330pjb.30.2023.12.19.13.04.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Dec 2023 13:04:07 -0800 (PST)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	David Ahern <dsahern@kernel.org>,
	Mina Almasry <almasrymina@google.com>
Subject: [RFC PATCH v3 03/20] net: page pool: rework ppiov life cycle
Date: Tue, 19 Dec 2023 13:03:40 -0800
Message-Id: <20231219210357.4029713-4-dw@davidwei.uk>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20231219210357.4029713-1-dw@davidwei.uk>
References: <20231219210357.4029713-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Pavel Begunkov <asml.silence@gmail.com>

NOT FOR UPSTREAM
The final version will depend on how the ppiov infra looks like

Page pool is tracking how many pages were allocated and returned, which
serves for refcounting the pool, and so every page/frag allocated should
eventually come back to the page pool via appropriate ways, e.g. by
calling page_pool_put_page().

When it comes to normal page pools (i.e. without memory providers
attached), it's fine to return a page when it's still refcounted by
somewhat in the stack, in which case we'll "detach" the page from the
pool and rely on page refcount for it to return back to the kernel.

Memory providers are different, at least ppiov based ones, they need
all their buffers to eventually return back, so apart from custom pp
->release handlers, we'll catch when someone puts down a ppiov and call
its memory provider to handle it, i.e. __page_pool_iov_free().

The first problem is that __page_pool_iov_free() hard coded devmem
handling, and other providers need a flexible way to specify their own
callbacks.

The second problem is that it doesn't go through the generic page pool
paths and so can't do the mentioned pp accounting right. And we can't
even safely rely on page_pool_put_page() to be called somewhere before
to do the pp refcounting, because then the page pool might get destroyed
and ppiov->pp would point to garbage.

The solution is to make the pp ->release callback to be responsible for
properly recycling its buffers, e.g. calling what was
__page_pool_iov_free() before in case of devmem.
page_pool_iov_put_many() will be returning buffers to the page pool.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: David Wei <dw@davidwei.uk>
---
 include/net/page_pool/helpers.h | 15 ++++++++---
 net/core/page_pool.c            | 46 +++++++++++++++++----------------
 2 files changed, 35 insertions(+), 26 deletions(-)

diff --git a/include/net/page_pool/helpers.h b/include/net/page_pool/helpers.h
index 92804c499833..ef380ee8f205 100644
--- a/include/net/page_pool/helpers.h
+++ b/include/net/page_pool/helpers.h
@@ -137,15 +137,22 @@ static inline void page_pool_iov_get_many(struct page_pool_iov *ppiov,
 	refcount_add(count, &ppiov->refcount);
 }
 
-void __page_pool_iov_free(struct page_pool_iov *ppiov);
+static inline bool page_pool_iov_sub_and_test(struct page_pool_iov *ppiov,
+					      unsigned int count)
+{
+	return refcount_sub_and_test(count, &ppiov->refcount);
+}
 
 static inline void page_pool_iov_put_many(struct page_pool_iov *ppiov,
 					  unsigned int count)
 {
-	if (!refcount_sub_and_test(count, &ppiov->refcount))
-		return;
+	if (count > 1)
+		WARN_ON_ONCE(page_pool_iov_sub_and_test(ppiov, count - 1));
 
-	__page_pool_iov_free(ppiov);
+#ifdef CONFIG_PAGE_POOL
+	page_pool_put_defragged_page(ppiov->pp, page_pool_mangle_ppiov(ppiov),
+				     -1, false);
+#endif
 }
 
 /* page pool mm helpers */
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 38eff947f679..ecf90a1ccabe 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -599,6 +599,16 @@ void __page_pool_release_page_dma(struct page_pool *pool, struct page *page)
 	page_pool_set_dma_addr(page, 0);
 }
 
+static void page_pool_return_provider(struct page_pool *pool, struct page *page)
+{
+	int count;
+
+	if (pool->mp_ops->release_page(pool, page)) {
+		count = atomic_inc_return_relaxed(&pool->pages_state_release_cnt);
+		trace_page_pool_state_release(pool, page, count);
+	}
+}
+
 /* Disconnects a page (from a page_pool).  API users can have a need
  * to disconnect a page (from a page_pool), to allow it to be used as
  * a regular page (that will eventually be returned to the normal
@@ -607,13 +617,13 @@ void __page_pool_release_page_dma(struct page_pool *pool, struct page *page)
 void page_pool_return_page(struct page_pool *pool, struct page *page)
 {
 	int count;
-	bool put;
 
-	put = true;
-	if (static_branch_unlikely(&page_pool_mem_providers) && pool->mp_ops)
-		put = pool->mp_ops->release_page(pool, page);
-	else
-		__page_pool_release_page_dma(pool, page);
+	if (static_branch_unlikely(&page_pool_mem_providers) && pool->mp_ops) {
+		page_pool_return_provider(pool, page);
+		return;
+	}
+
+	__page_pool_release_page_dma(pool, page);
 
 	/* This may be the last page returned, releasing the pool, so
 	 * it is not safe to reference pool afterwards.
@@ -621,10 +631,8 @@ void page_pool_return_page(struct page_pool *pool, struct page *page)
 	count = atomic_inc_return_relaxed(&pool->pages_state_release_cnt);
 	trace_page_pool_state_release(pool, page, count);
 
-	if (put) {
-		page_pool_clear_pp_info(page);
-		put_page(page);
-	}
+	page_pool_clear_pp_info(page);
+	put_page(page);
 	/* An optimization would be to call __free_pages(page, pool->p.order)
 	 * knowing page is not part of page-cache (thus avoiding a
 	 * __page_cache_release() call).
@@ -1034,15 +1042,6 @@ void page_pool_update_nid(struct page_pool *pool, int new_nid)
 }
 EXPORT_SYMBOL(page_pool_update_nid);
 
-void __page_pool_iov_free(struct page_pool_iov *ppiov)
-{
-	if (ppiov->pp->mp_ops != &dmabuf_devmem_ops)
-		return;
-
-	netdev_free_devmem(ppiov);
-}
-EXPORT_SYMBOL_GPL(__page_pool_iov_free);
-
 /*** "Dmabuf devmem memory provider" ***/
 
 static int mp_dmabuf_devmem_init(struct page_pool *pool)
@@ -1093,9 +1092,12 @@ static bool mp_dmabuf_devmem_release_page(struct page_pool *pool,
 		return false;
 
 	ppiov = page_to_page_pool_iov(page);
-	page_pool_iov_put_many(ppiov, 1);
-	/* We don't want the page pool put_page()ing our page_pool_iovs. */
-	return false;
+
+	if (!page_pool_iov_sub_and_test(ppiov, 1))
+		return false;
+	netdev_free_devmem(ppiov);
+	/* tell page_pool that the ppiov is released */
+	return true;
 }
 
 const struct pp_memory_provider_ops dmabuf_devmem_ops = {
-- 
2.39.3


