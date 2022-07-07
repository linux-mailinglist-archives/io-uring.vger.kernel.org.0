Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3E2956AEFC
	for <lists+io-uring@lfdr.de>; Fri,  8 Jul 2022 01:24:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236535AbiGGXYW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 7 Jul 2022 19:24:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236354AbiGGXYV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 7 Jul 2022 19:24:21 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA4C724BE7
        for <io-uring@vger.kernel.org>; Thu,  7 Jul 2022 16:24:20 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id s27so20899846pga.13
        for <io-uring@vger.kernel.org>; Thu, 07 Jul 2022 16:24:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Il7y05J9bjSxLZ5WBWnYpwNQ/5889v50bfC9zbQfEgo=;
        b=LGcrEGNnSoGfgRoXn4Hw40WxleUoeRf59alefGMN0dIb5w4p3TTF1CHrFcbEIe5Ndj
         TxKsjdTjSZ2TIzKZhTJRHLTMPvUZ2BgF15NXCkTpD4UZfOnA44QfXrNlsK+dBa0IDu/L
         RchkaVJ4kxvxqZTwodBavAOP9KsK7nb7IwJxcs54h8gxbSq78h4pQitS8IghdbIFFxX8
         H0S6l08B088GKh3fw53fzaXgnNaRidJyJ9natOrmKVVOKNumDtwCvCV9oxcHS8ngoTL/
         4P1pbP6MiVv225rRLZ+FKg8hCz1RzBjI6pWWDoiDcG59dDHIx7QElmGqflnKxsImKZvs
         /Hzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Il7y05J9bjSxLZ5WBWnYpwNQ/5889v50bfC9zbQfEgo=;
        b=SOvY9PhzFGiAgDxRqi49fRDFwfd8GwQE1DFD0fKkf2oiHH5F/4awl61BY/fgDVdmXr
         PEmBtduQUUlDvRZvIuy9xOcPl9xTemv+EXWhk5YK1bKvbAFJloIDFG8Ih/sIK/RRYu8H
         tzhtQObIJESSlHPQS3VgKkSbdHAvbGMeybL55BuqSw/7i0xEKFJ2Qj5dIvc5WS+e/n2L
         SezhDVtVC5RQvGajFt9evHAFAAaxBiS05DaEVgSRebv5g9bbfeS61VMQG0KIEcIuvSb8
         Hei/L4lKCs5TlyhVerJq1bdM41+ojK4Q63y94+Dn5H5olWnZSUFpmb8N/28AHUXE1IAf
         MhVQ==
X-Gm-Message-State: AJIora/6qv/MX1Myk1WrHkGvKw+Ls93CwQ7wvVhfBQkWhAJoNWQSD05v
        kCsk3MDqxaew4JqV2Js36YeeGNlDneXS9Q==
X-Google-Smtp-Source: AGRyM1t3XX1PmtJxkMECwqNQffcCuYD9xgpDj6qm7yPcgH/tuKN5ADx61uwZpdkzDctRAC7gzGqV5A==
X-Received: by 2002:a63:1607:0:b0:412:8fc0:756b with SMTP id w7-20020a631607000000b004128fc0756bmr511022pgl.142.1657236260051;
        Thu, 07 Jul 2022 16:24:20 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id s65-20020a17090a69c700b001efeb4c813csm94014pjj.13.2022.07.07.16.24.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 16:24:19 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/4] io_uring: add abstraction around apoll cache
Date:   Thu,  7 Jul 2022 17:23:44 -0600
Message-Id: <20220707232345.54424-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220707232345.54424-1-axboe@kernel.dk>
References: <20220707232345.54424-1-axboe@kernel.dk>
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
 include/linux/io_uring_types.h |  6 +++++-
 io_uring/alloc_cache.h         |  4 ++++
 io_uring/io_uring.c            |  7 ++++---
 io_uring/poll.c                | 16 ++++++++--------
 io_uring/poll.h                |  5 ++++-
 5 files changed, 25 insertions(+), 13 deletions(-)
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
index 000000000000..49ac6ae237ef
--- /dev/null
+++ b/io_uring/alloc_cache.h
@@ -0,0 +1,4 @@
+static inline void io_alloc_cache_init(struct io_alloc_cache *cache)
+{
+	INIT_HLIST_HEAD(&cache->list);
+}
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 4d1ce58b015e..3b9033c401bf 100644
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
@@ -1180,8 +1181,8 @@ void io_free_batch_list(struct io_ring_ctx *ctx, struct io_wq_work_node *node)
 
 				if (apoll->double_poll)
 					kfree(apoll->double_poll);
-				list_add(&apoll->poll.wait.entry,
-						&ctx->apoll_cache);
+				hlist_add_head(&apoll->cache_list,
+						&ctx->apoll_cache.list);
 				req->flags &= ~REQ_F_POLLED;
 			}
 			if (req->flags & IO_REQ_LINK_FLAGS)
diff --git a/io_uring/poll.c b/io_uring/poll.c
index f0fe209490d8..f3aae3cc6501 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -589,10 +589,10 @@ static struct async_poll *io_req_alloc_apoll(struct io_kiocb *req,
 		apoll = req->apoll;
 		kfree(apoll->double_poll);
 	} else if (!(issue_flags & IO_URING_F_UNLOCKED) &&
-		   !list_empty(&ctx->apoll_cache)) {
-		apoll = list_first_entry(&ctx->apoll_cache, struct async_poll,
-						poll.wait.entry);
-		list_del_init(&apoll->poll.wait.entry);
+		   !hlist_empty(&ctx->apoll_cache.list)) {
+		apoll = hlist_entry(ctx->apoll_cache.list.first,
+						struct async_poll, cache_list);
+		hlist_del(&apoll->cache_list);
 	} else {
 		apoll = kmalloc(sizeof(*apoll), GFP_ATOMIC);
 		if (unlikely(!apoll))
@@ -963,10 +963,10 @@ void io_flush_apoll_cache(struct io_ring_ctx *ctx)
 {
 	struct async_poll *apoll;
 
-	while (!list_empty(&ctx->apoll_cache)) {
-		apoll = list_first_entry(&ctx->apoll_cache, struct async_poll,
-						poll.wait.entry);
-		list_del(&apoll->poll.wait.entry);
+	while (!hlist_empty(&ctx->apoll_cache.list)) {
+		apoll = hlist_entry(ctx->apoll_cache.list.first,
+						struct async_poll, cache_list);
+		hlist_del(&apoll->cache_list);
 		kfree(apoll);
 	}
 }
diff --git a/io_uring/poll.h b/io_uring/poll.h
index 95f192c7babb..cb528f8ef203 100644
--- a/io_uring/poll.h
+++ b/io_uring/poll.h
@@ -14,7 +14,10 @@ struct io_poll {
 };
 
 struct async_poll {
-	struct io_poll		poll;
+	union {
+		struct io_poll		poll;
+		struct hlist_node	cache_list;
+	};
 	struct io_poll		*double_poll;
 };
 
-- 
2.35.1

