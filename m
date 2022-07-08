Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33BBA56BADF
	for <lists+io-uring@lfdr.de>; Fri,  8 Jul 2022 15:34:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238183AbiGHNag (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 8 Jul 2022 09:30:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237827AbiGHNac (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 8 Jul 2022 09:30:32 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83C2F2CDD0
        for <io-uring@vger.kernel.org>; Fri,  8 Jul 2022 06:30:31 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id f11so3815934plr.4
        for <io-uring@vger.kernel.org>; Fri, 08 Jul 2022 06:30:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IVdTfss5KaSAak1AOrGr/5IMWzulflFQjH6JxUOu+Vk=;
        b=c6W4keu7lJCtMbmRmlL+4OUqaFt05ytd2v8ccXyK5ndAcfLq9O8Tcvrgd8i64WUUB4
         cwOVBqOoZtJ5hlILICrdXzD215ShaN5b3iEmPccCKwUHkErNheyPEkrqni1ocDITGNYN
         IjMKwEF5ZSfFnApDXsPBtICiNjOTJNfIjCQfJxoo9siXZMyWe1QwNdpfhCH5ibGPhnsq
         BWujmI/zjXS71B8EdkgKL9ye5cI2QpnxoCAaKqKN+oFi1JLHPZHjEzc9WtnQGaGyo+IR
         N9LuwzeVhQvLIQtnv/0vCq7vLgTuqSjoWq+41xnYvGS2xNp7hlBTy8tw3xsYG8BaU33Z
         wqsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IVdTfss5KaSAak1AOrGr/5IMWzulflFQjH6JxUOu+Vk=;
        b=DBsuK0KpxnV+B1atktUbrd5NfMF/qJQtA7VWij3RTioPbD8EXZKbM+AufqghJYMJcs
         6OndLFDcxZL1S9Z/CZa6nNGq2Io9jezT8AwW8LGAM+EWEGjmFgqP8Mi/rOAyAe5PJY7z
         WPMQRC4jLL2ivTndvMrN5ECH4TMpPWH+7sDa4TZDxRglEUcSzhtyxheeuQ7pJZKdUB9x
         GOD1UrFLL/SlU96W1ktoBnzSfc6x11/9kXhjL/D8EbbxDi3xlrPCEJeCopQPS7V9lnLI
         xtQ2UQ5LIScan4v4m25aYzvmF47rQVviyzSaAFn871KDivWDYoqcjFWdKsrGiVdbTeKU
         nxFA==
X-Gm-Message-State: AJIora9nSjPi03M0G7m93ajeYIJab27z8js4UlB79WQcQ/3sSNVMUzIj
        0ebi5sZBMv+/OKbaLxBFvsqxbxfuSoFUQw==
X-Google-Smtp-Source: AGRyM1tfHXCCyJg1Zojl1A5XmPoJnz1FGkYSXIDxkKmMO5rNOsJe6ZouyTKAwY12EAa+1W65zugtlQ==
X-Received: by 2002:a17:902:c947:b0:16b:f442:8568 with SMTP id i7-20020a170902c94700b0016bf4428568mr3759288pla.55.1657287030759;
        Fri, 08 Jul 2022 06:30:30 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id a16-20020aa794b0000000b0052844157f09sm3800502pfl.51.2022.07.08.06.30.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jul 2022 06:30:30 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, dylany@fb.com, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/4] io_uring: impose max limit on apoll cache
Date:   Fri,  8 Jul 2022 07:30:21 -0600
Message-Id: <20220708133022.383961-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220708133022.383961-1-axboe@kernel.dk>
References: <20220708133022.383961-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Caches like this tend to grow to the peak size, and then never get any
smaller. Impose a max limit on the size, to prevent it from growing too
big.

A somewhat randomly chosen 512 is the max size we'll allow the cache
to get. If a batch of frees come in and would bring it over that, we
simply start kfree'ing the surplus.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/io_uring_types.h |  1 +
 io_uring/alloc_cache.h         | 16 ++++++++++++++--
 io_uring/io_uring.c            |  3 ++-
 3 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index b548da03b563..bf8f95332eda 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -160,6 +160,7 @@ struct io_ev_fd {
 
 struct io_alloc_cache {
 	struct hlist_head	list;
+	unsigned int		nr_cached;
 };
 
 struct io_ring_ctx {
diff --git a/io_uring/alloc_cache.h b/io_uring/alloc_cache.h
index 98f2374c37c7..729793ae9712 100644
--- a/io_uring/alloc_cache.h
+++ b/io_uring/alloc_cache.h
@@ -1,14 +1,24 @@
 #ifndef IOU_ALLOC_CACHE_H
 #define IOU_ALLOC_CACHE_H
 
+/*
+ * Don't allow the cache to grow beyond this size.
+ */
+#define IO_ALLOC_CACHE_MAX	512
+
 struct io_cache_entry {
 	struct hlist_node	node;
 };
 
-static inline void io_alloc_cache_put(struct io_alloc_cache *cache,
+static inline bool io_alloc_cache_put(struct io_alloc_cache *cache,
 				      struct io_cache_entry *entry)
 {
-	hlist_add_head(&entry->node, &cache->list);
+	if (cache->nr_cached < IO_ALLOC_CACHE_MAX) {
+		cache->nr_cached++;
+		hlist_add_head(&entry->node, &cache->list);
+		return true;
+	}
+	return false;
 }
 
 static inline struct io_cache_entry *io_alloc_cache_get(struct io_alloc_cache *cache)
@@ -26,6 +36,7 @@ static inline struct io_cache_entry *io_alloc_cache_get(struct io_alloc_cache *c
 static inline void io_alloc_cache_init(struct io_alloc_cache *cache)
 {
 	INIT_HLIST_HEAD(&cache->list);
+	cache->nr_cached = 0;
 }
 
 static inline void io_alloc_cache_free(struct io_alloc_cache *cache,
@@ -37,5 +48,6 @@ static inline void io_alloc_cache_free(struct io_alloc_cache *cache,
 		hlist_del(node);
 		free(container_of(node, struct io_cache_entry, node));
 	}
+	cache->nr_cached = 0;
 }
 #endif
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index a360a3d390c6..c9c23e459766 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1181,7 +1181,8 @@ void io_free_batch_list(struct io_ring_ctx *ctx, struct io_wq_work_node *node)
 
 				if (apoll->double_poll)
 					kfree(apoll->double_poll);
-				io_alloc_cache_put(&ctx->apoll_cache, &apoll->cache);
+				if (!io_alloc_cache_put(&ctx->apoll_cache, &apoll->cache))
+					kfree(apoll);
 				req->flags &= ~REQ_F_POLLED;
 			}
 			if (req->flags & IO_REQ_LINK_FLAGS)
-- 
2.35.1

