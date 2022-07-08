Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3729056BAD8
	for <lists+io-uring@lfdr.de>; Fri,  8 Jul 2022 15:34:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238178AbiGHNaf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 8 Jul 2022 09:30:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238151AbiGHNac (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 8 Jul 2022 09:30:32 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96A923136B
        for <io-uring@vger.kernel.org>; Fri,  8 Jul 2022 06:30:30 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id b9so7516152pfp.10
        for <io-uring@vger.kernel.org>; Fri, 08 Jul 2022 06:30:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=o6Gj/NlJK5wozdOoGFtbf11C6QMB1USYMR99UDIMzac=;
        b=tpwqkbb5qYLaojqSWQUUvmeXNequcB6Vh11+Bjn94ljRp6k9sh6rvAlM+mxriF4cL8
         hBkQGSgg1Y/CQaXpFFX63SWw5Na1FVVc/0/3OmI9AFhkP7FuLZ5HxDSAG3OWnOmO1fW+
         34CIa+zExzUWS1SiI8lJWp2Ea4/eESIsI3qrReBwjadJ4NZzXe4WF0hMlyZXtUvtDt7m
         Q/CzQdX9FeSeV44gFQn2387le/b0xbdR2z7CPsd9vJvUN4/vXaAuur5czAjb70oHK3IC
         wjal9wtEpLUqBxDtJYiEvnpWz4AAabu3tNocKCOBNvJqYZd0DBpyNM3ROVCp/o/FW2ka
         W0+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=o6Gj/NlJK5wozdOoGFtbf11C6QMB1USYMR99UDIMzac=;
        b=cmzxVtpeohPTNHzUqcffFjh5k6+/ZAxlX43+tlrhFOWJQrMp1b1y2a4cZRAWnN857L
         RhSrlayjnvA8eP9C5HCET4cUe3pqgGtzjPBicblHiXKjZpEOq0FAxoXkXRSvFS9iMiQX
         j/LWY6Ab75Dot7az2aH3bBbm1e8QNwiNyURhpFWW7/8SusQnxb22iXqUbCbO3XycDXDO
         ijx5p8a8SJjp5+ePPGQmm6sDGTY+XkvfJjx3MBb7G8AAYb5Enqc8UT9he/1sSYa4+inz
         qm99IVwdPovWAXmvX4Vb9Rts3mQ+KkqBgXXXW0UvZkf6Sm0hLKrWZQn3RJfgUfXj9i/p
         zPMg==
X-Gm-Message-State: AJIora/5rS/DK2jp3mrZRiDNJOPlPaG4F8Gh+od5EPqF1h4KENDZWVg0
        cisPtd8x0iKcDKwCmsmR/F1z/1rKGFETpQ==
X-Google-Smtp-Source: AGRyM1tgQ6Kp0x2GTglaQm+xLdnM40jbRBaPTtlHxyne5uA1hRUjWC977GfH3R0jEbIiemZEEldw6A==
X-Received: by 2002:a63:4913:0:b0:40d:8235:2d1c with SMTP id w19-20020a634913000000b0040d82352d1cmr3300638pga.584.1657287029640;
        Fri, 08 Jul 2022 06:30:29 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id a16-20020aa794b0000000b0052844157f09sm3800502pfl.51.2022.07.08.06.30.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jul 2022 06:30:29 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, dylany@fb.com, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/4] io_uring: add abstraction around apoll cache
Date:   Fri,  8 Jul 2022 07:30:20 -0600
Message-Id: <20220708133022.383961-3-axboe@kernel.dk>
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

In preparation for adding limits, and one more user, abstract out the
core bits of the allocation+free cache.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/io_uring_types.h |  6 ++++-
 io_uring/alloc_cache.h         | 41 ++++++++++++++++++++++++++++++++++
 io_uring/io_uring.c            |  8 +++----
 io_uring/poll.c                | 18 +++++----------
 io_uring/poll.h                |  9 ++++++--
 5 files changed, 62 insertions(+), 20 deletions(-)
 create mode 100644 io_uring/alloc_cache.h

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 26ef11e978d4..b548da03b563 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -158,6 +158,10 @@ struct io_ev_fd {
 	struct rcu_head		rcu;
 };
 
+struct io_alloc_cache {
+	struct hlist_head	list;
+};
+
 struct io_ring_ctx {
 	/* const or read-mostly hot data */
 	struct {
@@ -216,7 +220,7 @@ struct io_ring_ctx {
 
 		struct io_hash_table	cancel_table_locked;
 		struct list_head	cq_overflow_list;
-		struct list_head	apoll_cache;
+		struct io_alloc_cache	apoll_cache;
 		struct xarray		personalities;
 		u32			pers_next;
 	} ____cacheline_aligned_in_smp;
diff --git a/io_uring/alloc_cache.h b/io_uring/alloc_cache.h
new file mode 100644
index 000000000000..98f2374c37c7
--- /dev/null
+++ b/io_uring/alloc_cache.h
@@ -0,0 +1,41 @@
+#ifndef IOU_ALLOC_CACHE_H
+#define IOU_ALLOC_CACHE_H
+
+struct io_cache_entry {
+	struct hlist_node	node;
+};
+
+static inline void io_alloc_cache_put(struct io_alloc_cache *cache,
+				      struct io_cache_entry *entry)
+{
+	hlist_add_head(&entry->node, &cache->list);
+}
+
+static inline struct io_cache_entry *io_alloc_cache_get(struct io_alloc_cache *cache)
+{
+	if (!hlist_empty(&cache->list)) {
+		struct hlist_node *node = cache->list.first;
+
+		hlist_del(node);
+		return container_of(node, struct io_cache_entry, node);
+	}
+
+	return NULL;
+}
+
+static inline void io_alloc_cache_init(struct io_alloc_cache *cache)
+{
+	INIT_HLIST_HEAD(&cache->list);
+}
+
+static inline void io_alloc_cache_free(struct io_alloc_cache *cache,
+					void (*free)(struct io_cache_entry *))
+{
+	while (!hlist_empty(&cache->list)) {
+		struct hlist_node *node = cache->list.first;
+
+		hlist_del(node);
+		free(container_of(node, struct io_cache_entry, node));
+	}
+}
+#endif
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 4d1ce58b015e..a360a3d390c6 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -92,6 +92,7 @@
 
 #include "timeout.h"
 #include "poll.h"
+#include "alloc_cache.h"
 
 #define IORING_MAX_ENTRIES	32768
 #define IORING_MAX_CQ_ENTRIES	(2 * IORING_MAX_ENTRIES)
@@ -295,7 +296,7 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	INIT_LIST_HEAD(&ctx->sqd_list);
 	INIT_LIST_HEAD(&ctx->cq_overflow_list);
 	INIT_LIST_HEAD(&ctx->io_buffers_cache);
-	INIT_LIST_HEAD(&ctx->apoll_cache);
+	io_alloc_cache_init(&ctx->apoll_cache);
 	init_completion(&ctx->ref_comp);
 	xa_init_flags(&ctx->personalities, XA_FLAGS_ALLOC1);
 	mutex_init(&ctx->uring_lock);
@@ -1180,8 +1181,7 @@ void io_free_batch_list(struct io_ring_ctx *ctx, struct io_wq_work_node *node)
 
 				if (apoll->double_poll)
 					kfree(apoll->double_poll);
-				list_add(&apoll->poll.wait.entry,
-						&ctx->apoll_cache);
+				io_alloc_cache_put(&ctx->apoll_cache, &apoll->cache);
 				req->flags &= ~REQ_F_POLLED;
 			}
 			if (req->flags & IO_REQ_LINK_FLAGS)
@@ -2467,7 +2467,7 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	if (ctx->rings)
 		__io_cqring_overflow_flush(ctx, true);
 	io_eventfd_unregister(ctx);
-	io_flush_apoll_cache(ctx);
+	io_alloc_cache_free(&ctx->apoll_cache, io_apoll_cache_free);
 	mutex_unlock(&ctx->uring_lock);
 	io_destroy_buffers(ctx);
 	if (ctx->sq_creds)
diff --git a/io_uring/poll.c b/io_uring/poll.c
index 052fcb647208..dadd293749b0 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -590,16 +590,15 @@ static struct async_poll *io_req_alloc_apoll(struct io_kiocb *req,
 					     unsigned issue_flags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
+	struct io_cache_entry *entry;
 	struct async_poll *apoll;
 
 	if (req->flags & REQ_F_POLLED) {
 		apoll = req->apoll;
 		kfree(apoll->double_poll);
 	} else if (!(issue_flags & IO_URING_F_UNLOCKED) &&
-		   !list_empty(&ctx->apoll_cache)) {
-		apoll = list_first_entry(&ctx->apoll_cache, struct async_poll,
-						poll.wait.entry);
-		list_del_init(&apoll->poll.wait.entry);
+		   (entry = io_alloc_cache_get(&ctx->apoll_cache)) != NULL) {
+		apoll = container_of(entry, struct async_poll, cache);
 	} else {
 		apoll = kmalloc(sizeof(*apoll), GFP_ATOMIC);
 		if (unlikely(!apoll))
@@ -960,14 +959,7 @@ int io_poll_remove(struct io_kiocb *req, unsigned int issue_flags)
 	return IOU_OK;
 }
 
-void io_flush_apoll_cache(struct io_ring_ctx *ctx)
+void io_apoll_cache_free(struct io_cache_entry *entry)
 {
-	struct async_poll *apoll;
-
-	while (!list_empty(&ctx->apoll_cache)) {
-		apoll = list_first_entry(&ctx->apoll_cache, struct async_poll,
-						poll.wait.entry);
-		list_del(&apoll->poll.wait.entry);
-		kfree(apoll);
-	}
+	kfree(container_of(entry, struct async_poll, cache));
 }
diff --git a/io_uring/poll.h b/io_uring/poll.h
index 95f192c7babb..5f3bae50fc81 100644
--- a/io_uring/poll.h
+++ b/io_uring/poll.h
@@ -1,5 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 
+#include "alloc_cache.h"
+
 enum {
 	IO_APOLL_OK,
 	IO_APOLL_ABORTED,
@@ -14,7 +16,10 @@ struct io_poll {
 };
 
 struct async_poll {
-	struct io_poll		poll;
+	union {
+		struct io_poll		poll;
+		struct io_cache_entry	cache;
+	};
 	struct io_poll		*double_poll;
 };
 
@@ -31,4 +36,4 @@ int io_arm_poll_handler(struct io_kiocb *req, unsigned issue_flags);
 bool io_poll_remove_all(struct io_ring_ctx *ctx, struct task_struct *tsk,
 			bool cancel_all);
 
-void io_flush_apoll_cache(struct io_ring_ctx *ctx);
+void io_apoll_cache_free(struct io_cache_entry *entry);
-- 
2.35.1

