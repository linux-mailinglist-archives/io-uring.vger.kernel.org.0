Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8ADFE6D6100
	for <lists+io-uring@lfdr.de>; Tue,  4 Apr 2023 14:41:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234198AbjDDMlH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 4 Apr 2023 08:41:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234944AbjDDMlB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 4 Apr 2023 08:41:01 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BA941BC7;
        Tue,  4 Apr 2023 05:40:58 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id cn12so130060658edb.4;
        Tue, 04 Apr 2023 05:40:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680612058;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1CwMuzyH2dEdSI/CO0b8pg+tuSUqIX+/sHQt7TiN5ZM=;
        b=X/J1llEltWTp4lG2E3lTY7RTuXuKmHYGHhZGxSbzgjJt2spsoc45a6S/UqZmy9U95v
         3AJyxDDnt6hnM3wGswTBwN1w1rruCJajzH0hS0det28+p4PqaXO8No707bkfYlIH4gT4
         Ex2bhCgpaA6oAvTi8s4cYa4nscj59hZrpo1b3ng1sk6YDj3US4/VIvvsp4VvCSLg+Ujx
         h9EEbua/G4akmIB9ncr08dx49v8Qc70b1mVxMeD3YoySqg/Uc5IN/XwrJFru7RQb+Ybl
         izyZWc77RLGkl1EcLvSEk2Bp2iPDemOm0BTIkg8dWFmwopEODxnBjKwkbHz2tviJFjob
         IU8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680612058;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1CwMuzyH2dEdSI/CO0b8pg+tuSUqIX+/sHQt7TiN5ZM=;
        b=RORmEIuMWGFX33I16cb6QNsDJXHrR13ShHDaBgvBSPTZw50EamLC490Rc0GncfE4wv
         7s4LmboPKH1ClcLrVM6NFGw1pveRK+udra3LEMXle55Xi3IatgYBgYFjqsFWDg3IdmCT
         c91zEkMf2ZPHoujLaLBrZ88qOc39yYzJ+Q9j0rKBqGhyd50Bi+CS6RkzPPKX5ldIyLMx
         I2cva+YBgZBnyA1SRsVpVKpJpDkW7eeN4/JMfK7FvVtaOl53GMbs8irKCnbEbs9Q53h7
         Fxnvt/DuLQEeYghNBggxIEjaqnIiagmN67d96jFxms9BoRDMsPPu4gBblLICiYncnx60
         K5aA==
X-Gm-Message-State: AAQBX9eWMsB/9a17Mz/cGOp3xStxoDBFImnJ9V/r1fGIbbgE6OqWg8j8
        AEjTDpEc+ADikCg72l+KVgJeBR4VWYw=
X-Google-Smtp-Source: AKy350a8IAMbejy0JcLdVVhKR7yjVPSmMspTAxjLXFflw+wYwvMDI7z6y7yHHO3nQN94bCFvevvEjw==
X-Received: by 2002:a17:907:8c10:b0:8f0:143d:ee34 with SMTP id ta16-20020a1709078c1000b008f0143dee34mr2624104ejc.1.1680612057944;
        Tue, 04 Apr 2023 05:40:57 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::2:2b22])
        by smtp.gmail.com with ESMTPSA id g8-20020a170906394800b008cafeec917dsm5978851eje.101.2023.04.04.05.40.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 05:40:57 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 13/13] io_uring/rsrc: add custom limit for node caching
Date:   Tue,  4 Apr 2023 13:39:57 +0100
Message-Id: <d0cd538b944dac0bf878e276fc0199f21e6bccea.1680576071.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1680576071.git.asml.silence@gmail.com>
References: <cover.1680576071.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The number of entries in the rsrc node cache is limited to 512, which
still seems unnecessarily large. Add per cache thresholds and set to
to 32 for the rsrc node cache.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring_types.h | 1 +
 io_uring/alloc_cache.h         | 6 ++++--
 io_uring/io_uring.c            | 9 ++++++---
 io_uring/rsrc.h                | 2 ++
 4 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 5d772e36e7fc..4a6ce03a4903 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -190,6 +190,7 @@ struct io_ev_fd {
 struct io_alloc_cache {
 	struct io_wq_work_node	list;
 	unsigned int		nr_cached;
+	unsigned int		max_cached;
 	size_t			elem_size;
 };
 
diff --git a/io_uring/alloc_cache.h b/io_uring/alloc_cache.h
index 2fbecaa3a1ba..851a527afb5e 100644
--- a/io_uring/alloc_cache.h
+++ b/io_uring/alloc_cache.h
@@ -13,7 +13,7 @@ struct io_cache_entry {
 static inline bool io_alloc_cache_put(struct io_alloc_cache *cache,
 				      struct io_cache_entry *entry)
 {
-	if (cache->nr_cached < IO_ALLOC_CACHE_MAX) {
+	if (cache->nr_cached < cache->max_cached) {
 		cache->nr_cached++;
 		wq_stack_add_head(&entry->node, &cache->list);
 		/* KASAN poisons object */
@@ -38,10 +38,12 @@ static inline struct io_cache_entry *io_alloc_cache_get(struct io_alloc_cache *c
 	return NULL;
 }
 
-static inline void io_alloc_cache_init(struct io_alloc_cache *cache, size_t size)
+static inline void io_alloc_cache_init(struct io_alloc_cache *cache,
+				       unsigned max_nr, size_t size)
 {
 	cache->list.next = NULL;
 	cache->nr_cached = 0;
+	cache->max_cached = max_nr;
 	cache->elem_size = size;
 }
 
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index da36fa1eeac9..ae90d2753e0d 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -310,9 +310,12 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	INIT_LIST_HEAD(&ctx->sqd_list);
 	INIT_LIST_HEAD(&ctx->cq_overflow_list);
 	INIT_LIST_HEAD(&ctx->io_buffers_cache);
-	io_alloc_cache_init(&ctx->rsrc_node_cache, sizeof(struct io_rsrc_node));
-	io_alloc_cache_init(&ctx->apoll_cache, sizeof(struct async_poll));
-	io_alloc_cache_init(&ctx->netmsg_cache, sizeof(struct io_async_msghdr));
+	io_alloc_cache_init(&ctx->rsrc_node_cache, IO_NODE_ALLOC_CACHE_MAX,
+			    sizeof(struct io_rsrc_node));
+	io_alloc_cache_init(&ctx->apoll_cache, IO_ALLOC_CACHE_MAX,
+			    sizeof(struct async_poll));
+	io_alloc_cache_init(&ctx->netmsg_cache, IO_ALLOC_CACHE_MAX,
+			    sizeof(struct io_async_msghdr));
 	init_completion(&ctx->ref_comp);
 	xa_init_flags(&ctx->personalities, XA_FLAGS_ALLOC1);
 	mutex_init(&ctx->uring_lock);
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index 7ab9b2b2e757..8729f2fee256 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -6,6 +6,8 @@
 
 #include "alloc_cache.h"
 
+#define IO_NODE_ALLOC_CACHE_MAX 32
+
 #define IO_RSRC_TAG_TABLE_SHIFT	(PAGE_SHIFT - 3)
 #define IO_RSRC_TAG_TABLE_MAX	(1U << IO_RSRC_TAG_TABLE_SHIFT)
 #define IO_RSRC_TAG_TABLE_MASK	(IO_RSRC_TAG_TABLE_MAX - 1)
-- 
2.39.1

