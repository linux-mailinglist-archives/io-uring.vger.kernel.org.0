Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FBF569E1C9
	for <lists+io-uring@lfdr.de>; Tue, 21 Feb 2023 14:57:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234005AbjBUN5u (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 21 Feb 2023 08:57:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234167AbjBUN5s (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 21 Feb 2023 08:57:48 -0500
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61D332A141;
        Tue, 21 Feb 2023 05:57:40 -0800 (PST)
Received: by mail-wr1-f51.google.com with SMTP id c12so4529775wrw.1;
        Tue, 21 Feb 2023 05:57:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YSMy4d7C3y9QQLTh7tMc5rp+Km3cKnTrKiObXhQbZYk=;
        b=dHoMC+aQyQVUjLFhfb1/VdaRtnJfZV5MgCYsEaKSsn98/DhT44XyfDtcs/50JC26+c
         tNFIyccl7Xez8pPtaU7cotB8+7Pv782jAZ/hsjalB35hKE5vm002TP5LXASLjI/UxJR1
         RfXog0WZqsgG3mHd9nyX9C/uz5QZuVZ8aHW9HDRo21ORVeOoQHdgyPsNtL8MBKyjH7QB
         dtbN6HpeMJ6AVDjZIavTbR0d2bjC5PRAW2aaEb7xPzUqHpIliBx+mOpbuYDoWvCyVk/2
         eMMHcSFeL5c4PIWCSzXA6kWyej7Yj7UAEH4YtfZwHbePOe+Jbb9iBzI1FFyqagPwpYLH
         Ttrg==
X-Gm-Message-State: AO0yUKXnL9R9D/+66ldHxZcokMiXxG3H8U3Ebnd+0sTtoklJCgCrzAjz
        300n1VPxXVCMGYnTy/BpQjc=
X-Google-Smtp-Source: AK7set+rooNjlGjHUBW3iVmIaIoLzaSLgvfU/NI34Y4ljmwSvswAnVkbfzLmoUhGpM7rbGytjI4tlA==
X-Received: by 2002:a05:6000:98c:b0:2c5:68a9:843f with SMTP id by12-20020a056000098c00b002c568a9843fmr3046536wrb.4.1676987858752;
        Tue, 21 Feb 2023 05:57:38 -0800 (PST)
Received: from localhost (fwdproxy-cln-008.fbsv.net. [2a03:2880:31ff:8::face:b00c])
        by smtp.gmail.com with ESMTPSA id h7-20020a5d6887000000b002c5501a5803sm2715946wru.65.2023.02.21.05.57.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Feb 2023 05:57:38 -0800 (PST)
From:   Breno Leitao <leitao@debian.org>
To:     axboe@kernel.dk, asml.silence@gmail.com, io-uring@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, gustavold@meta.com, leit@meta.com
Subject: [PATCH 1/2] io_uring: Move from hlist to io_wq_work_node
Date:   Tue, 21 Feb 2023 05:57:20 -0800
Message-Id: <20230221135721.3230763-1-leitao@debian.org>
X-Mailer: git-send-email 2.39.0
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
 io_uring/alloc_cache.h         | 27 +++++++++++++++------------
 2 files changed, 16 insertions(+), 13 deletions(-)

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
index 729793ae9712..0d9ff9402a37 100644
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
@@ -23,11 +23,14 @@ static inline bool io_alloc_cache_put(struct io_alloc_cache *cache,
 
 static inline struct io_cache_entry *io_alloc_cache_get(struct io_alloc_cache *cache)
 {
-	if (!hlist_empty(&cache->list)) {
-		struct hlist_node *node = cache->list.first;
-
-		hlist_del(node);
-		return container_of(node, struct io_cache_entry, node);
+	struct io_wq_work_node *node;
+	struct io_cache_entry *entry;
+
+	if (cache->list.next) {
+		node = cache->list.next;
+		entry = container_of(node, struct io_cache_entry, node);
+		cache->list.next = node->next;
+		return entry;
 	}
 
 	return NULL;
@@ -35,19 +38,19 @@ static inline struct io_cache_entry *io_alloc_cache_get(struct io_alloc_cache *c
 
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
+	struct io_cache_entry *entry;
 
-		hlist_del(node);
-		free(container_of(node, struct io_cache_entry, node));
+	while ((entry = io_alloc_cache_get(cache))) {
+		free(entry);
 	}
+
 	cache->nr_cached = 0;
 }
 #endif
-- 
2.39.0

