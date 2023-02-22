Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E36EE69FAA8
	for <lists+io-uring@lfdr.de>; Wed, 22 Feb 2023 19:00:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232165AbjBVSAo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 22 Feb 2023 13:00:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232145AbjBVSAn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 22 Feb 2023 13:00:43 -0500
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4D0838B6D;
        Wed, 22 Feb 2023 10:00:41 -0800 (PST)
Received: by mail-wm1-f46.google.com with SMTP id l2-20020a05600c1d0200b003e1f6dff952so7120033wms.1;
        Wed, 22 Feb 2023 10:00:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xNEnafHq9H7B13AnAe5txqBr7aKjs9xFRkNpLXSLW18=;
        b=rYesFRYSeEwu7aVyceL6VPAdNSkdlVRydPxAhVeCv9wSn4Zpr8DCobYYNXt8fTA3k/
         GqdUT+Wa7hJjbDv5ZnU+TDibA8/YTX3jTccMBYbMra//pvVyMUop6xGt8S80Hf+T5vwG
         p2WKGZJnoVn62FPNEF6KuuEkkKx/KqXyQ49PlToCGN/4P3U/SM589j3Z0J7IBTzHx2XS
         Tgf0KUfGL1TnuEA+Up5ivpVWn/x18V7NfXiZvYjIiso7kpm/v70mxjAdakqwZLfP+sEo
         c1/fxd1CX84JKp6egiqTq1h2b5N75x5zCMHcucwXZ0sWggmds4ZA9zvQzQ8EqwpvrEsB
         lAGg==
X-Gm-Message-State: AO0yUKV9vCmSdJ0es/yxSJXLaRJpQkuEJKqu3ecMMxWjvebyOC3TqIAp
        yPMbj7msdGlIXZshoZTKbfA=
X-Google-Smtp-Source: AK7set8rfsohKcf7wPp02rpSUpY/f0i6Yf0vmQu2AEMjQgrWYu+GIzB/oMWGqoZwV8IapTdF9GMkeQ==
X-Received: by 2002:a05:600c:4e41:b0:3e1:feb9:5a2f with SMTP id e1-20020a05600c4e4100b003e1feb95a2fmr7846372wmq.2.1677088840397;
        Wed, 22 Feb 2023 10:00:40 -0800 (PST)
Received: from localhost (fwdproxy-cln-023.fbsv.net. [2a03:2880:31ff:17::face:b00c])
        by smtp.gmail.com with ESMTPSA id 1-20020a05600c274100b003dfe549da4fsm9179448wmw.18.2023.02.22.10.00.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Feb 2023 10:00:40 -0800 (PST)
From:   Breno Leitao <leitao@debian.org>
To:     axboe@kernel.dk, asml.silence@gmail.com, io-uring@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, gustavold@meta.com, leit@meta.com,
        kasan-dev@googlegroups.com, Breno Leitao <leit@fb.com>
Subject: [PATCH v2 2/2] io_uring: Add KASAN support for alloc_caches
Date:   Wed, 22 Feb 2023 10:00:35 -0800
Message-Id: <20230222180035.3226075-3-leitao@debian.org>
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

Add support for KASAN in the alloc_caches (apoll and netmsg_cache).
Thus, if something touches the unused caches, it will raise a KASAN
warning/exception.

It poisons the object when the object is put to the cache, and unpoisons
it when the object is gotten or freed.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 io_uring/alloc_cache.h | 11 ++++++++---
 io_uring/io_uring.c    | 14 ++++++++++++--
 io_uring/net.c         |  2 +-
 io_uring/net.h         |  4 ----
 io_uring/poll.c        |  2 +-
 5 files changed, 22 insertions(+), 11 deletions(-)

diff --git a/io_uring/alloc_cache.h b/io_uring/alloc_cache.h
index ae61eb383cae..6c6bdde6306b 100644
--- a/io_uring/alloc_cache.h
+++ b/io_uring/alloc_cache.h
@@ -16,16 +16,20 @@ static inline bool io_alloc_cache_put(struct io_alloc_cache *cache,
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
 	if (cache->list.next) {
 		struct io_cache_entry *entry;
 		entry = container_of(cache->list.next, struct io_cache_entry, node);
+		kasan_unpoison_range(entry, size);
 		cache->list.next = cache->list.next->next;
 		return entry;
 	}
@@ -40,10 +44,11 @@ static inline void io_alloc_cache_init(struct io_alloc_cache *cache)
 }
 
 static inline void io_alloc_cache_free(struct io_alloc_cache *cache,
-					void (*free)(struct io_cache_entry *))
+					void (*free)(struct io_cache_entry *),
+					size_t size)
 {
 	while (1) {
-		struct io_cache_entry *entry = io_alloc_cache_get(cache);
+		struct io_cache_entry *entry = io_alloc_cache_get(cache, size);
 		if (!entry)
 			break;
 		free(entry);
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 80b6204769e8..01367145689b 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2766,6 +2766,17 @@ static void io_req_caches_free(struct io_ring_ctx *ctx)
 	mutex_unlock(&ctx->uring_lock);
 }
 
+static __cold void io_uring_acache_free(struct io_ring_ctx *ctx)
+{
+
+	io_alloc_cache_free(&ctx->apoll_cache, io_apoll_cache_free,
+			    sizeof(struct async_poll));
+#ifdef CONFIG_NET
+	io_alloc_cache_free(&ctx->netmsg_cache, io_netmsg_cache_free,
+			    sizeof(struct io_async_msghdr));
+#endif
+}
+
 static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 {
 	io_sq_thread_finish(ctx);
@@ -2781,8 +2792,7 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
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
diff --git a/io_uring/net.h b/io_uring/net.h
index 5ffa11bf5d2e..d8359de84996 100644
--- a/io_uring/net.h
+++ b/io_uring/net.h
@@ -62,8 +62,4 @@ int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 void io_send_zc_cleanup(struct io_kiocb *req);
 
 void io_netmsg_cache_free(struct io_cache_entry *entry);
-#else
-static inline void io_netmsg_cache_free(struct io_cache_entry *entry)
-{
-}
 #endif
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
2.30.2

