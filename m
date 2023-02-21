Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AE0169E1CB
	for <lists+io-uring@lfdr.de>; Tue, 21 Feb 2023 14:57:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234183AbjBUN54 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 21 Feb 2023 08:57:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234186AbjBUN5x (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 21 Feb 2023 08:57:53 -0500
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD93A2A991;
        Tue, 21 Feb 2023 05:57:44 -0800 (PST)
Received: by mail-wr1-f52.google.com with SMTP id c5so5216923wrr.5;
        Tue, 21 Feb 2023 05:57:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dX2zL4ynD4tsLZJVAOZ5QiEaA3whpal2a4zVJpxHSGQ=;
        b=Fv5PAw/PD9TMB6l7f1dRpw5JSK/ive9grpaA7UhoOT8lNPbqahw6fdV/+SRaIXM9xH
         XhnpU+tfPqjg1wyrxTda8KAAov6kiGR+Xvo7tpgSmz7CjhYERlARyhkjVPriK44PAlHg
         /dN2bBpWKBV5bznkEYBsMuUwRoNWpLvtzO27Rj20OEiCFBlXykZNSJcN+7xqtzb+bHf9
         EiWECTGKB1UOwmoYaqWlBJp5OyuNB8M4GXsN0eSNFY6uPg1lFMH8VDWEnPLkcTDNRfQE
         snV7uz6SkS2yvKXGbH6c/owKYVx0SI//y+cWPdtsI9A1XvFxIwuNm2oI1Toglar6cWxo
         S0bw==
X-Gm-Message-State: AO0yUKVACP2lAnYoJPE0muVnWeigopSlGTe3hSGR2JOhNRWCjl7X0Qlu
        ITpqP/mql9+GYqFuNuZ8Nqs=
X-Google-Smtp-Source: AK7set9tddnTsoeabtc6JU5TGUwCxo5rwr74HD2REu6Mo9BK0oHhpMqdVSeWTJepL0AD3NGbvznAxw==
X-Received: by 2002:a05:6000:2cf:b0:2c5:5313:9d19 with SMTP id o15-20020a05600002cf00b002c553139d19mr4013084wry.26.1676987863269;
        Tue, 21 Feb 2023 05:57:43 -0800 (PST)
Received: from localhost (fwdproxy-cln-010.fbsv.net. [2a03:2880:31ff:a::face:b00c])
        by smtp.gmail.com with ESMTPSA id i18-20020adfe492000000b002c56287bd2csm4963461wrm.114.2023.02.21.05.57.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Feb 2023 05:57:42 -0800 (PST)
From:   Breno Leitao <leitao@debian.org>
To:     axboe@kernel.dk, asml.silence@gmail.com, io-uring@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, gustavold@meta.com, leit@meta.com
Subject: [PATCH 2/2] io_uring: Add KASAN support for alloc_caches
Date:   Tue, 21 Feb 2023 05:57:21 -0800
Message-Id: <20230221135721.3230763-2-leitao@debian.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230221135721.3230763-1-leitao@debian.org>
References: <20230221135721.3230763-1-leitao@debian.org>
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
 io_uring/alloc_cache.h | 11 ++++++++---
 io_uring/io_uring.c    | 12 ++++++++++--
 io_uring/net.c         |  2 +-
 io_uring/poll.c        |  2 +-
 4 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/io_uring/alloc_cache.h b/io_uring/alloc_cache.h
index 0d9ff9402a37..0d5cd2c0a0ba 100644
--- a/io_uring/alloc_cache.h
+++ b/io_uring/alloc_cache.h
@@ -16,12 +16,15 @@ static inline bool io_alloc_cache_put(struct io_alloc_cache *cache,
 	if (cache->nr_cached < IO_ALLOC_CACHE_MAX) {
 		cache->nr_cached++;
 		wq_stack_add_head(&entry->node, &cache->list);
+		/* KASAN poisons object */
+		kasan_slab_free_mempool(entry);
 		return true;
 	}
 	return false;
 }
 
-static inline struct io_cache_entry *io_alloc_cache_get(struct io_alloc_cache *cache)
+static inline struct io_cache_entry *io_alloc_cache_get(struct io_alloc_cache *cache,
+							size_t size)
 {
 	struct io_wq_work_node *node;
 	struct io_cache_entry *entry;
@@ -29,6 +32,7 @@ static inline struct io_cache_entry *io_alloc_cache_get(struct io_alloc_cache *c
 	if (cache->list.next) {
 		node = cache->list.next;
 		entry = container_of(node, struct io_cache_entry, node);
+		kasan_unpoison_range(entry, size);
 		cache->list.next = node->next;
 		return entry;
 	}
@@ -43,11 +47,12 @@ static inline void io_alloc_cache_init(struct io_alloc_cache *cache)
 }
 
 static inline void io_alloc_cache_free(struct io_alloc_cache *cache,
-					void (*free)(struct io_cache_entry *))
+					void (*free)(struct io_cache_entry *),
+					size_t size)
 {
 	struct io_cache_entry *entry;
 
-	while ((entry = io_alloc_cache_get(cache))) {
+	while ((entry = io_alloc_cache_get(cache, size))) {
 		free(entry);
 	}
 
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 80b6204769e8..6a98902b8f62 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2766,6 +2766,15 @@ static void io_req_caches_free(struct io_ring_ctx *ctx)
 	mutex_unlock(&ctx->uring_lock);
 }
 
+static __cold void io_uring_acache_free(struct io_ring_ctx *ctx)
+{
+
+	io_alloc_cache_free(&ctx->apoll_cache, io_apoll_cache_free,
+			    sizeof(struct async_poll));
+	io_alloc_cache_free(&ctx->netmsg_cache, io_netmsg_cache_free,
+			    sizeof(struct io_async_msghdr));
+}
+
 static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 {
 	io_sq_thread_finish(ctx);
@@ -2781,8 +2790,7 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 		__io_sqe_files_unregister(ctx);
 	io_cqring_overflow_kill(ctx);
 	io_eventfd_unregister(ctx);
-	io_alloc_cache_free(&ctx->apoll_cache, io_apoll_cache_free);
-	io_alloc_cache_free(&ctx->netmsg_cache, io_netmsg_cache_free);
+	io_uring_acache_free(ctx);
 	mutex_unlock(&ctx->uring_lock);
 	io_destroy_buffers(ctx);
 	if (ctx->sq_creds)
diff --git a/io_uring/net.c b/io_uring/net.c
index fbc34a7c2743..8dc67b23b030 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -139,7 +139,7 @@ static struct io_async_msghdr *io_msg_alloc_async(struct io_kiocb *req,
 	struct io_async_msghdr *hdr;
 
 	if (!(issue_flags & IO_URING_F_UNLOCKED)) {
-		entry = io_alloc_cache_get(&ctx->netmsg_cache);
+		entry = io_alloc_cache_get(&ctx->netmsg_cache, sizeof(struct io_async_msghdr));
 		if (entry) {
 			hdr = container_of(entry, struct io_async_msghdr, cache);
 			hdr->free_iov = NULL;
diff --git a/io_uring/poll.c b/io_uring/poll.c
index 8339a92b4510..295d59875f00 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -661,7 +661,7 @@ static struct async_poll *io_req_alloc_apoll(struct io_kiocb *req,
 		apoll = req->apoll;
 		kfree(apoll->double_poll);
 	} else if (!(issue_flags & IO_URING_F_UNLOCKED)) {
-		entry = io_alloc_cache_get(&ctx->apoll_cache);
+		entry = io_alloc_cache_get(&ctx->apoll_cache, sizeof(struct async_poll));
 		if (entry == NULL)
 			goto alloc_apoll;
 		apoll = container_of(entry, struct async_poll, cache);
-- 
2.39.0

