Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD85E69FAA6
	for <lists+io-uring@lfdr.de>; Wed, 22 Feb 2023 19:00:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232129AbjBVSAm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 22 Feb 2023 13:00:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232107AbjBVSAm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 22 Feb 2023 13:00:42 -0500
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2F933B67C;
        Wed, 22 Feb 2023 10:00:40 -0800 (PST)
Received: by mail-wm1-f50.google.com with SMTP id k37so3355849wms.0;
        Wed, 22 Feb 2023 10:00:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3tEj3MEVlOpJ71FbGuEdO9VoX/sQZcmpHXDBJnglnR8=;
        b=QYwJmn9Ohy3IjY9QpGtwY4RFFehHVbteWU31Ohv3UrGwdzMytxl/qwwASe+RnRDvRT
         UW1/XPLdW4s5ytPkctj85ncbl0POtTVYmN/9UTswWnPYtBhHHFUv1ezPjzBjhaCfebWM
         g+/ylY2/9bBZBJia3RtPnzUuT0rf+Z5mrp96ZaI25bPlBOc5/nsG8lPCVOmT3dtZges2
         9rxLVoljsLqHZlD6F5dBWylG9ktPYrB96Ivov3nXGh1LPIpS3ERpg64Ao09PzFE8l7Dn
         ScT4meSAO2op+9bVw9QZnCSw8/TzFCrUnk+jhXhk+C0Fzu90pfhgrL5ZB+Gg1a3iXnXS
         T0Xg==
X-Gm-Message-State: AO0yUKWHsaQblePR2uEKjXLFnn44N/GoK1bWAnIf3WUjFvryd1/eEzLR
        s0sFVLm0MHc0tD9mZ5qpeE0=
X-Google-Smtp-Source: AK7set9ogQVVSP9B9EI3tac+Ah1tPg+zCKdzkRz+J3yGPApxZCMrZvZyvUGkThsgdMHlyjDibPF+Nw==
X-Received: by 2002:a05:600c:16c5:b0:3dc:37d0:e9df with SMTP id l5-20020a05600c16c500b003dc37d0e9dfmr1606404wmn.14.1677088839316;
        Wed, 22 Feb 2023 10:00:39 -0800 (PST)
Received: from localhost (fwdproxy-cln-002.fbsv.net. [2a03:2880:31ff:2::face:b00c])
        by smtp.gmail.com with ESMTPSA id r1-20020adfdc81000000b002c5503a8d21sm5901528wrj.70.2023.02.22.10.00.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Feb 2023 10:00:38 -0800 (PST)
From:   Breno Leitao <leitao@debian.org>
To:     axboe@kernel.dk, asml.silence@gmail.com, io-uring@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, gustavold@meta.com, leit@meta.com,
        kasan-dev@googlegroups.com, Breno Leitao <leit@fb.com>
Subject: [PATCH v2 1/2] io_uring: Move from hlist to io_wq_work_node
Date:   Wed, 22 Feb 2023 10:00:34 -0800
Message-Id: <20230222180035.3226075-2-leitao@debian.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230222180035.3226075-1-leitao@debian.org>
References: <20230222180035.3226075-1-leitao@debian.org>
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

From: Breno Leitao <leit@fb.com>

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
 io_uring/alloc_cache.h         | 26 +++++++++++++-------------
 2 files changed, 14 insertions(+), 14 deletions(-)

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
index 729793ae9712..ae61eb383cae 100644
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
@@ -23,11 +23,11 @@ static inline bool io_alloc_cache_put(struct io_alloc_cache *cache,
 
 static inline struct io_cache_entry *io_alloc_cache_get(struct io_alloc_cache *cache)
 {
-	if (!hlist_empty(&cache->list)) {
-		struct hlist_node *node = cache->list.first;
-
-		hlist_del(node);
-		return container_of(node, struct io_cache_entry, node);
+	if (cache->list.next) {
+		struct io_cache_entry *entry;
+		entry = container_of(cache->list.next, struct io_cache_entry, node);
+		cache->list.next = cache->list.next->next;
+		return entry;
 	}
 
 	return NULL;
@@ -35,18 +35,18 @@ static inline struct io_cache_entry *io_alloc_cache_get(struct io_alloc_cache *c
 
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
-
-		hlist_del(node);
-		free(container_of(node, struct io_cache_entry, node));
+	while (1) {
+		struct io_cache_entry *entry = io_alloc_cache_get(cache);
+		if (!entry)
+			break;
+		free(entry);
 	}
 	cache->nr_cached = 0;
 }
-- 
2.30.2

