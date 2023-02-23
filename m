Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFA8F6A0E29
	for <lists+io-uring@lfdr.de>; Thu, 23 Feb 2023 17:44:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234658AbjBWQoY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 23 Feb 2023 11:44:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234589AbjBWQoX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 23 Feb 2023 11:44:23 -0500
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D48783A0BA;
        Thu, 23 Feb 2023 08:44:22 -0800 (PST)
Received: by mail-wr1-f46.google.com with SMTP id j2so10990037wrh.9;
        Thu, 23 Feb 2023 08:44:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EXP5WLQ9Rub89Gkwnqh+Yqr8BCe99md1ePNpoibd3cQ=;
        b=LYMm2oP4lSIzZSlbBMC560ETr2rafqjaUYA4Kj/BExQR2jbO8T9OCsIIu7MZXUrZeA
         I9izJvZIKLJpFOBQyoHFhFU9EKcVsDiwDSbV4wkKaapjsEPbn/1T46YhlhzGAAK4flOn
         GBXXUV5bksugkPeNltn04noWBn2F91A4azJEFFlk/8pkN0jWK1P5+MkSKStvsJnosSf/
         h65gY0FfE66CfYFvx9/azTOL0JS8FrRSJyuALd71U7WOiJO6OesD+RmpVJA/d7zP2A/Y
         yZPQhgo2xQJ9MYeiByJW6perIdLBLBL1IQv+FokTHkul/ybvKg9ARppN4314kht2oBz+
         WDuw==
X-Gm-Message-State: AO0yUKUwdDDKwbc3bVSVKP56/VVkkf9mTlHfyyuSDqfTCoErkpNax2la
        8Cu/mxp1tT3VaoFMZWKx8cw=
X-Google-Smtp-Source: AK7set9K5QvqKVmOt/8cme8KNipK1amHNGF6GbaUMQvnSx7QGat2BW5GCgQcbs9CZOdQncyha9R0/Q==
X-Received: by 2002:a5d:410b:0:b0:2c5:8c56:42d3 with SMTP id l11-20020a5d410b000000b002c58c5642d3mr9678543wrp.23.1677170661338;
        Thu, 23 Feb 2023 08:44:21 -0800 (PST)
Received: from localhost (fwdproxy-cln-026.fbsv.net. [2a03:2880:31ff:1a::face:b00c])
        by smtp.gmail.com with ESMTPSA id x4-20020adfdd84000000b002c556a4f1casm10274330wrl.42.2023.02.23.08.44.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Feb 2023 08:44:21 -0800 (PST)
From:   Breno Leitao <leitao@debian.org>
To:     axboe@kernel.dk, asml.silence@gmail.com, io-uring@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, gustavold@meta.com, leit@meta.com,
        kasan-dev@googlegroups.com
Subject: [PATCH v3 2/2] io_uring: Add KASAN support for alloc_caches
Date:   Thu, 23 Feb 2023 08:43:53 -0800
Message-Id: <20230223164353.2839177-3-leitao@debian.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230223164353.2839177-1-leitao@debian.org>
References: <20230223164353.2839177-1-leitao@debian.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add support for KASAN in the alloc_caches (apoll and netmsg_cache).
Thus, if something touches the unused caches, it will raise a KASAN
warning/exception.

It poisons the object when the object is put to the cache, and unpoisons
it when the object is gotten or freed.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 include/linux/io_uring_types.h | 1 +
 io_uring/alloc_cache.h         | 6 +++++-
 io_uring/io_uring.c            | 4 ++--
 io_uring/net.h                 | 5 ++++-
 4 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index efa66b6c32c9..35ebcfb46047 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -190,6 +190,7 @@ struct io_ev_fd {
 struct io_alloc_cache {
 	struct io_wq_work_node	list;
 	unsigned int		nr_cached;
+	size_t			elem_size;
 };
 
 struct io_ring_ctx {
diff --git a/io_uring/alloc_cache.h b/io_uring/alloc_cache.h
index 301855e94309..3aba7b356320 100644
--- a/io_uring/alloc_cache.h
+++ b/io_uring/alloc_cache.h
@@ -16,6 +16,8 @@ static inline bool io_alloc_cache_put(struct io_alloc_cache *cache,
 	if (cache->nr_cached < IO_ALLOC_CACHE_MAX) {
 		cache->nr_cached++;
 		wq_stack_add_head(&entry->node, &cache->list);
+		/* KASAN poisons object */
+		kasan_slab_free_mempool(entry);
 		return true;
 	}
 	return false;
@@ -27,6 +29,7 @@ static inline struct io_cache_entry *io_alloc_cache_get(struct io_alloc_cache *c
 		struct io_cache_entry *entry;
 
 		entry = container_of(cache->list.next, struct io_cache_entry, node);
+		kasan_unpoison_range(entry, cache->elem_size);
 		cache->list.next = cache->list.next->next;
 		return entry;
 	}
@@ -34,10 +37,11 @@ static inline struct io_cache_entry *io_alloc_cache_get(struct io_alloc_cache *c
 	return NULL;
 }
 
-static inline void io_alloc_cache_init(struct io_alloc_cache *cache)
+static inline void io_alloc_cache_init(struct io_alloc_cache *cache, size_t size)
 {
 	cache->list.next = NULL;
 	cache->nr_cached = 0;
+	cache->elem_size = size;
 }
 
 static inline void io_alloc_cache_free(struct io_alloc_cache *cache,
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 80b6204769e8..7a30a3e72fcc 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -309,8 +309,8 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	INIT_LIST_HEAD(&ctx->sqd_list);
 	INIT_LIST_HEAD(&ctx->cq_overflow_list);
 	INIT_LIST_HEAD(&ctx->io_buffers_cache);
-	io_alloc_cache_init(&ctx->apoll_cache);
-	io_alloc_cache_init(&ctx->netmsg_cache);
+	io_alloc_cache_init(&ctx->apoll_cache, sizeof(struct async_poll));
+	io_alloc_cache_init(&ctx->netmsg_cache, sizeof(struct io_async_msghdr));
 	init_completion(&ctx->ref_comp);
 	xa_init_flags(&ctx->personalities, XA_FLAGS_ALLOC1);
 	mutex_init(&ctx->uring_lock);
diff --git a/io_uring/net.h b/io_uring/net.h
index 5ffa11bf5d2e..191009979bcb 100644
--- a/io_uring/net.h
+++ b/io_uring/net.h
@@ -5,8 +5,8 @@
 
 #include "alloc_cache.h"
 
-#if defined(CONFIG_NET)
 struct io_async_msghdr {
+#if defined(CONFIG_NET)
 	union {
 		struct iovec		fast_iov[UIO_FASTIOV];
 		struct {
@@ -22,8 +22,11 @@ struct io_async_msghdr {
 	struct sockaddr __user		*uaddr;
 	struct msghdr			msg;
 	struct sockaddr_storage		addr;
+#endif
 };
 
+#if defined(CONFIG_NET)
+
 struct io_async_connect {
 	struct sockaddr_storage		address;
 };
-- 
2.30.2

