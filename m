Return-Path: <io-uring+bounces-3746-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 97F699A11F4
	for <lists+io-uring@lfdr.de>; Wed, 16 Oct 2024 20:54:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C0CBD1C22E58
	for <lists+io-uring@lfdr.de>; Wed, 16 Oct 2024 18:53:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 170BC1B4F2F;
	Wed, 16 Oct 2024 18:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="2B7NXSDE"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC244215F4F
	for <io-uring@vger.kernel.org>; Wed, 16 Oct 2024 18:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729104792; cv=none; b=FRlubSgD3dLoy5muebfC+Ze+iAH1v339elLiuTbcFxx/N0pa4LB7LRWPRV6arJFNp9rPqY9d74ZUvnoigLNrLVBg5taX9bwPWffXkLkhI8WNztTKHghmG38RE6tUpealmt6RKJQXjg6oSGm1ZeBl7vx9VC428Mx6xviL7MkC/9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729104792; c=relaxed/simple;
	bh=stlUgp33BwTRN/0cQTOTCoDhqZGc/HHCVuHNB1SnHKg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i5BMmBwwc/rrSwian8jbWyCX2DysipKvqpXJ/jH5hA/5fz6GOYY1v5Oebv1K1gdPlMg63e0rnyrTIsM7G9VC69ugAJcERPSsIfHoNU6zvFk04GC5InSqD9WOMam+JFnXnaoeiPrcu95XLcy7ZjazbsDXjJ//TaYmhyVNj+4zxyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=2B7NXSDE; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-7ea68af2f62so100101a12.3
        for <io-uring@vger.kernel.org>; Wed, 16 Oct 2024 11:53:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1729104790; x=1729709590; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kKhajILgXPnH7N489X2OSTc+5BkU3eYPAK3guNmJgN4=;
        b=2B7NXSDEaEGEpj0Of9wgUDMZmq5zK80gJIUUwrJP0Z8+dIrK28bl76g15cbELZIjQ4
         u8MRJSOiqsyobPKgQEabuawbTn1WZA0BKd0JRqaWc7dNWL5z4kTc0uSQbbPXE3JHB2/5
         cJFaRKD4i64J9j+iAusfazEKHJFOtuc8+oWgWHWQ7nf73kvmopbV2ffkNtRGZn84//Ar
         MO/3Q2k4eJ3qMEKsR1pGpPC865MmW7Gf1/XtoybncZFS8mSj9X0ByPxJLinNlp3OrGxh
         cbIen0mYew27Qjhm6ROvDvfcDGhLujwqa/LpCmB3XufSqI0N9w7TxCtTnQK1DxHaCZ4m
         nbxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729104790; x=1729709590;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kKhajILgXPnH7N489X2OSTc+5BkU3eYPAK3guNmJgN4=;
        b=qzQ18ATT+CqVz4srazH1jdYDiVDa6s2aTT40Nksl4slwhvl4enO+YOKzHe5QRNg4zK
         SsQ/ofBGKzXhu71lzwmXVb57PyWjdKWusv/spKCob5kZ0Pks7ib3PS6B96bhSCNad7ly
         qSD6fFtEUxH/+o6eUCMvvpMQxRMPy33g2s2ySSX6SxR7kA2atDfHzY2bXVyLjsOIZ4c3
         X6Yc1ACcYuz5vfr7YrJ6UEGXYWhK+EUVqOMKxxPzyls3HrfiPEjYuO1sXZu86mOX9gsQ
         Onm67SCYxTXehi2v7fhLF1Tei0RbEbM94R/BmMwD40b+8gdlLavNv0jEZANjQS343tOR
         uHtw==
X-Gm-Message-State: AOJu0YzyumurIHPTsIMMrVFopEOAxieLzIt72BNmMj7pH0EUMd2zRFyC
	utSIIvevt3NOIa01xy8SW2yQGSfDpc/l4IoYx30y6937/Vvnwdiy9NV5U2/v70ed61W73S2BHvA
	b
X-Google-Smtp-Source: AGHT+IFUKSBYw0TVlOrWwfyB+Hat8M0ZvOzZaPKQW6ZyDBwTh6AcSIrs+UBlG+sTrrHZo3hmqYeeGA==
X-Received: by 2002:a05:6a21:9d83:b0:1cf:6d20:4d6 with SMTP id adf61e73a8af0-1d8c959539amr26460080637.16.1729104790090;
        Wed, 16 Oct 2024 11:53:10 -0700 (PDT)
Received: from localhost (fwdproxy-prn-014.fbsv.net. [2a03:2880:ff:e::face:b00c])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71e7750a74csm3389377b3a.212.2024.10.16.11.53.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Oct 2024 11:53:09 -0700 (PDT)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: David Wei <dw@davidwei.uk>,
	Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	David Ahern <dsahern@kernel.org>,
	Mina Almasry <almasrymina@google.com>,
	Stanislav Fomichev <stfomichev@gmail.com>,
	Joe Damato <jdamato@fastly.com>,
	Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH v6 07/15] net: page_pool: introduce page_pool_mp_return_in_cache
Date: Wed, 16 Oct 2024 11:52:44 -0700
Message-ID: <20241016185252.3746190-8-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241016185252.3746190-1-dw@davidwei.uk>
References: <20241016185252.3746190-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Pavel Begunkov <asml.silence@gmail.com>

Add a helper that allows a page pool memory provider to efficiently
return a netmem off the allocation callback.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: David Wei <dw@davidwei.uk>
---
 include/net/page_pool/memory_provider.h |  4 ++++
 net/core/page_pool.c                    | 19 +++++++++++++++++++
 2 files changed, 23 insertions(+)

diff --git a/include/net/page_pool/memory_provider.h b/include/net/page_pool/memory_provider.h
index 83d7eec0058d..352b3a35d31c 100644
--- a/include/net/page_pool/memory_provider.h
+++ b/include/net/page_pool/memory_provider.h
@@ -1,3 +1,5 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+
 #ifndef _NET_PAGE_POOL_MEMORY_PROVIDER_H
 #define _NET_PAGE_POOL_MEMORY_PROVIDER_H
 
@@ -7,4 +9,6 @@ int page_pool_mp_init_paged_area(struct page_pool *pool,
 void page_pool_mp_release_area(struct page_pool *pool,
 				struct net_iov_area *area);
 
+void page_pool_mp_return_in_cache(struct page_pool *pool, netmem_ref netmem);
+
 #endif
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 8bd4a3c80726..9078107c906d 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -1213,3 +1213,22 @@ void page_pool_mp_release_area(struct page_pool *pool,
 		page_pool_release_page_dma(pool, net_iov_to_netmem(niov));
 	}
 }
+
+/*
+ * page_pool_mp_return_in_cache() - return a netmem to the allocation cache.
+ * @pool:	pool from which pages were allocated
+ * @netmem:	netmem to return
+ *
+ * Return already allocated and accounted netmem to the page pool's allocation
+ * cache. The function doesn't provide synchronisation and must only be called
+ * from the napi context.
+ */
+void page_pool_mp_return_in_cache(struct page_pool *pool, netmem_ref netmem)
+{
+	if (WARN_ON_ONCE(pool->alloc.count >= PP_ALLOC_CACHE_REFILL))
+		return;
+
+	page_pool_dma_sync_for_device(pool, netmem, -1);
+	page_pool_fragment_netmem(netmem, 1);
+	pool->alloc.cache[pool->alloc.count++] = netmem;
+}
-- 
2.43.5


