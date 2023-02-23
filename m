Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D2856A0E28
	for <lists+io-uring@lfdr.de>; Thu, 23 Feb 2023 17:44:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234635AbjBWQoX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 23 Feb 2023 11:44:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234026AbjBWQoX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 23 Feb 2023 11:44:23 -0500
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBFC639CD4;
        Thu, 23 Feb 2023 08:44:21 -0800 (PST)
Received: by mail-wr1-f42.google.com with SMTP id j2so10990011wrh.9;
        Thu, 23 Feb 2023 08:44:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+k0d3ITubH2glaeJAp2cfaEZXtQloEAVR31lcQ0bITk=;
        b=QlBPgV3u59OIN4TN6/CCgtQNRFPZhpiFaAhJ2/VczU9uZlblr1x7kJncMuRYoMWAUz
         e6dadVz/ncEOn/QbV0oQRQN7pTjaEoX7h2I5p3gM6OQfMC8iVQlpElqA4l4q39xrqtEi
         QLDBt6/6N+741jKJCe+Svf69qt6ilGbWp2BuYGdl3GKUSs5bl50SyEk/HsyIDNXV7kcD
         4csb1Kagp60HLc29eWJ/CqEARf+6q+tVdecRt9hoM0rxz3fbuonNFOKqXQDwUga6izN8
         HhVOGrKLbPB+JuP78CaHE7pWvOWT0f8j1rsdBt5GZ5j4tjk0yQ45K90J5tZvNfML4nge
         vqXg==
X-Gm-Message-State: AO0yUKUVwyhXgcrWy1zvMTW2Mc1Q6MN6gcrebfiJmbk8gWoWuxRXdKbZ
        cJEbx/Uq2eFyX9i2jn38jbI=
X-Google-Smtp-Source: AK7set9or6tnEjqY7bfp0bHKqbcrDxOf+chBbk8OwIg3pk6Fk+KvJYh0Z7u9ZT8gfGp+xotO5ajMoQ==
X-Received: by 2002:a5d:51ca:0:b0:2c7:1159:ea43 with SMTP id n10-20020a5d51ca000000b002c71159ea43mr2492370wrv.51.1677170660333;
        Thu, 23 Feb 2023 08:44:20 -0800 (PST)
Received: from localhost (fwdproxy-cln-008.fbsv.net. [2a03:2880:31ff:8::face:b00c])
        by smtp.gmail.com with ESMTPSA id v26-20020a5d591a000000b002c573cff730sm7700970wrd.68.2023.02.23.08.44.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Feb 2023 08:44:19 -0800 (PST)
From:   Breno Leitao <leitao@debian.org>
To:     axboe@kernel.dk, asml.silence@gmail.com, io-uring@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, gustavold@meta.com, leit@meta.com,
        kasan-dev@googlegroups.com
Subject: [PATCH v3 1/2] io_uring: Move from hlist to io_wq_work_node
Date:   Thu, 23 Feb 2023 08:43:52 -0800
Message-Id: <20230223164353.2839177-2-leitao@debian.org>
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

Having cache entries linked using the hlist format brings no benefit, and
also requires an unnecessary extra pointer address per cache entry.

Use the internal io_wq_work_node single-linked list for the internal
alloc caches (async_msghdr and async_poll)

This is required to be able to use KASAN on cache entries, since we do
not need to touch unused (and poisoned) cache entries when adding more
entries to the list.

Suggested-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 include/linux/io_uring_types.h |  2 +-
 io_uring/alloc_cache.h         | 24 +++++++++++++-----------
 2 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 0efe4d784358..efa66b6c32c9 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -188,7 +188,7 @@ struct io_ev_fd {
 };
 
 struct io_alloc_cache {
-	struct hlist_head	list;
+	struct io_wq_work_node	list;
 	unsigned int		nr_cached;
 };
 
diff --git a/io_uring/alloc_cache.h b/io_uring/alloc_cache.h
index 729793ae9712..301855e94309 100644
--- a/io_uring/alloc_cache.h
+++ b/io_uring/alloc_cache.h
@@ -7,7 +7,7 @@
 #define IO_ALLOC_CACHE_MAX	512
 
 struct io_cache_entry {
-	struct hlist_node	node;
+	struct io_wq_work_node node;
 };
 
 static inline bool io_alloc_cache_put(struct io_alloc_cache *cache,
@@ -15,7 +15,7 @@ static inline bool io_alloc_cache_put(struct io_alloc_cache *cache,
 {
 	if (cache->nr_cached < IO_ALLOC_CACHE_MAX) {
 		cache->nr_cached++;
-		hlist_add_head(&entry->node, &cache->list);
+		wq_stack_add_head(&entry->node, &cache->list);
 		return true;
 	}
 	return false;
@@ -23,11 +23,12 @@ static inline bool io_alloc_cache_put(struct io_alloc_cache *cache,
 
 static inline struct io_cache_entry *io_alloc_cache_get(struct io_alloc_cache *cache)
 {
-	if (!hlist_empty(&cache->list)) {
-		struct hlist_node *node = cache->list.first;
+	if (cache->list.next) {
+		struct io_cache_entry *entry;
 
-		hlist_del(node);
-		return container_of(node, struct io_cache_entry, node);
+		entry = container_of(cache->list.next, struct io_cache_entry, node);
+		cache->list.next = cache->list.next->next;
+		return entry;
 	}
 
 	return NULL;
@@ -35,18 +36,19 @@ static inline struct io_cache_entry *io_alloc_cache_get(struct io_alloc_cache *c
 
 static inline void io_alloc_cache_init(struct io_alloc_cache *cache)
 {
-	INIT_HLIST_HEAD(&cache->list);
+	cache->list.next = NULL;
 	cache->nr_cached = 0;
 }
 
 static inline void io_alloc_cache_free(struct io_alloc_cache *cache,
 					void (*free)(struct io_cache_entry *))
 {
-	while (!hlist_empty(&cache->list)) {
-		struct hlist_node *node = cache->list.first;
+	while (1) {
+		struct io_cache_entry *entry = io_alloc_cache_get(cache);
 
-		hlist_del(node);
-		free(container_of(node, struct io_cache_entry, node));
+		if (!entry)
+			break;
+		free(entry);
 	}
 	cache->nr_cached = 0;
 }
-- 
2.30.2

