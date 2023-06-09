Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0980C72A245
	for <lists+io-uring@lfdr.de>; Fri,  9 Jun 2023 20:31:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230283AbjFISbs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 9 Jun 2023 14:31:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230300AbjFISbq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 9 Jun 2023 14:31:46 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AF393AA1
        for <io-uring@vger.kernel.org>; Fri,  9 Jun 2023 11:31:38 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id e9e14a558f8ab-3357fc32a31so1749675ab.1
        for <io-uring@vger.kernel.org>; Fri, 09 Jun 2023 11:31:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1686335497; x=1688927497;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0ndkXtrnsLBfYw1QVxH1IcCt9fclqgXBKBZInitESTI=;
        b=NBwl05WNFveMujUd4JDuwi4J9ojB6I0qkhW7A5fCFJA9fSffJKo+297E4q1Tdk6c2J
         q09BnAOZt6slb4hxrFX0pfomKSHIFtUNDEINVoJts71C7zvdWwe4Vh0jA19LW9SaWNHU
         nSv9MbgryBPIOza5ADvKxbl0qrqTjyX3G3FU7dly+oCSkqp1b4vDk4m1KFcTGYOB4fs8
         DPDkMkjLNPi6zPE0CBuiAmI4LcEClQeD/zmvKGpgRumSgtaOrt2r09uaRM8VVMKRHnLU
         8SCqoUuP7jqUTaeWjpnIiohaEwhPnAtzDoG8UMbStKgscD4lgtGaSlOa5JemFy/SKGSr
         NbBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686335497; x=1688927497;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0ndkXtrnsLBfYw1QVxH1IcCt9fclqgXBKBZInitESTI=;
        b=a0Zrno980vUnaUZ8+Yers2Da275i2p/k0s4WBhhVJgJNG+076ukQ33YC7WCC1NwpXj
         B+uH/9ja5P+meKcd3ZNfK0btKU0xCegEcsFYMtjOj41/JqHC5WPFJX2XF8VgVFF/Og5o
         POAShs3kX1vvmnDq0GAxA6s/FgtX8IOL5wgm+ZImj6J1Zi3A7GGbLSdH/GFBo+neHxOI
         S5AtvkNFRP1N37mrGUd4w3ITqJWeHEE/tnAjVj8t/yjG7El9oIT+3o93MlNNEWChHZ8J
         y+LPppKezOG12Q6gieqBvQtyr6NhF976xAww+EjZ49BzgKn2dDtwpQDfSHewV5nqwR6q
         HU9g==
X-Gm-Message-State: AC+VfDwPms0D+C4cOvSQdF/x69EbM27/TZVVO/sPNRQ+LDJgnV09PTm6
        m4K1LQZu9KzPkVlJo+Vd4PXpee0kSvDJLFjWFrk=
X-Google-Smtp-Source: ACHHUZ45RSiX1HunXcCeODlTWvUD/ySkh/IqNVPPi3sd1iUs7OhaIe02B/nSahNEa+g8F/tLictJdw==
X-Received: by 2002:a5d:9d8f:0:b0:77a:c93b:f9d8 with SMTP id ay15-20020a5d9d8f000000b0077ac93bf9d8mr2354591iob.2.1686335496742;
        Fri, 09 Jun 2023 11:31:36 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id j4-20020a02a684000000b0040fb2ba7357sm1103124jam.4.2023.06.09.11.31.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jun 2023 11:31:36 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     andres@anarazel.de, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6/6] io_uring/futex: enable use of the allocation caches for futex_q
Date:   Fri,  9 Jun 2023 12:31:25 -0600
Message-Id: <20230609183125.673140-7-axboe@kernel.dk>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230609183125.673140-1-axboe@kernel.dk>
References: <20230609183125.673140-1-axboe@kernel.dk>
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

We're under the ctx uring_lock for the issue and completion path anyway,
wire up the futex_q allocator so we can just recycle entries rather than
hit the allocator every time.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/io_uring_types.h |  1 +
 io_uring/futex.c               | 65 +++++++++++++++++++++++++++-------
 io_uring/futex.h               |  8 +++++
 io_uring/io_uring.c            |  2 ++
 4 files changed, 63 insertions(+), 13 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index d796b578c129..a7f03d8d879f 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -274,6 +274,7 @@ struct io_ring_ctx {
 	unsigned int		locked_free_nr;
 
 	struct hlist_head	futex_list;
+	struct io_alloc_cache	futex_cache;
 
 	const struct cred	*sq_creds;	/* cred used for __io_sq_thread() */
 	struct io_sq_data	*sq_data;	/* if using sq thread polling */
diff --git a/io_uring/futex.c b/io_uring/futex.c
index a1d50145927a..e0707723c689 100644
--- a/io_uring/futex.c
+++ b/io_uring/futex.c
@@ -9,6 +9,7 @@
 
 #include "../kernel/futex/futex.h"
 #include "io_uring.h"
+#include "rsrc.h"
 #include "futex.h"
 
 struct io_futex {
@@ -22,22 +23,48 @@ struct io_futex {
 	ktime_t		timeout;
 };
 
+struct io_futex_data {
+	union {
+		struct futex_q		q;
+		struct io_cache_entry	cache;
+	};
+};
+
+void io_futex_cache_init(struct io_ring_ctx *ctx)
+{
+	io_alloc_cache_init(&ctx->futex_cache, IO_NODE_ALLOC_CACHE_MAX,
+				sizeof(struct io_futex_data));
+}
+
+static void io_futex_cache_entry_free(struct io_cache_entry *entry)
+{
+	kfree(container_of(entry, struct io_futex_data, cache));
+}
+
+void io_futex_cache_free(struct io_ring_ctx *ctx)
+{
+	io_alloc_cache_free(&ctx->futex_cache, io_futex_cache_entry_free);
+}
+
 static void io_futex_complete(struct io_kiocb *req, struct io_tw_state *ts)
 {
+	struct io_futex_data *ifd = req->async_data;
 	struct io_ring_ctx *ctx = req->ctx;
 
-	kfree(req->async_data);
 	io_tw_lock(ctx, ts);
+	if (!io_alloc_cache_put(&ctx->futex_cache, &ifd->cache))
+		kfree(ifd);
+	req->async_data = NULL;
 	hlist_del_init(&req->hash_node);
 	io_req_task_complete(req, ts);
 }
 
 static bool __io_futex_cancel(struct io_ring_ctx *ctx, struct io_kiocb *req)
 {
-	struct futex_q *q = req->async_data;
+	struct io_futex_data *ifd = req->async_data;
 
 	/* futex wake already done or in progress */
-	if (!futex_unqueue(q))
+	if (!futex_unqueue(&ifd->q))
 		return false;
 
 	hlist_del_init(&req->hash_node);
@@ -133,12 +160,23 @@ static void io_futex_wake_fn(struct wake_q_head *wake_q, struct futex_q *q)
 	io_req_task_work_add(req);
 }
 
+static struct io_futex_data *io_alloc_ifd(struct io_ring_ctx *ctx)
+{
+	struct io_cache_entry *entry;
+
+	entry = io_alloc_cache_get(&ctx->futex_cache);
+	if (entry)
+		return container_of(entry, struct io_futex_data, cache);
+
+	return kmalloc(sizeof(struct io_futex_data), GFP_NOWAIT);
+}
+
 int io_futex_wait(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_futex *iof = io_kiocb_to_cmd(req, struct io_futex);
 	struct io_ring_ctx *ctx = req->ctx;
+	struct io_futex_data *ifd;
 	unsigned int flags = 0;
-	struct futex_q *q;
 	int ret;
 
 	if (!futex_op_to_flags(FUTEX_WAIT, iof->futex_flags, &flags)) {
@@ -146,23 +184,24 @@ int io_futex_wait(struct io_kiocb *req, unsigned int issue_flags)
 		goto done;
 	}
 
-	q = kmalloc(sizeof(*q), GFP_NOWAIT);
-	if (!q) {
+	io_ring_submit_lock(ctx, issue_flags);
+	ifd = io_alloc_ifd(ctx);
+	if (!ifd) {
+		io_ring_submit_unlock(ctx, issue_flags);
 		ret = -ENOMEM;
 		goto done;
 	}
 
-	req->async_data = q;
-	*q = futex_q_init;
-	q->bitset = iof->futex_mask;
-	q->wake = io_futex_wake_fn;
-	q->wake_data = req;
+	req->async_data = ifd;
+	ifd->q = futex_q_init;
+	ifd->q.bitset = iof->futex_mask;
+	ifd->q.wake = io_futex_wake_fn;
+	ifd->q.wake_data = req;
 
-	io_ring_submit_lock(ctx, issue_flags);
 	hlist_add_head(&req->hash_node, &ctx->futex_list);
 	io_ring_submit_unlock(ctx, issue_flags);
 
-	ret = futex_queue_wait(q, iof->uaddr, flags, iof->futex_val);
+	ret = futex_queue_wait(&ifd->q, iof->uaddr, flags, iof->futex_val);
 	if (ret)
 		goto done;
 
diff --git a/io_uring/futex.h b/io_uring/futex.h
index 16add2c069cc..e60d0abaf676 100644
--- a/io_uring/futex.h
+++ b/io_uring/futex.h
@@ -11,6 +11,8 @@ int io_futex_cancel(struct io_ring_ctx *ctx, struct io_cancel_data *cd,
 		    unsigned int issue_flags);
 bool io_futex_remove_all(struct io_ring_ctx *ctx, struct task_struct *task,
 			 bool cancel_all);
+void io_futex_cache_init(struct io_ring_ctx *ctx);
+void io_futex_cache_free(struct io_ring_ctx *ctx);
 #else
 static inline int io_futex_cancel(struct io_ring_ctx *ctx,
 				  struct io_cancel_data *cd,
@@ -23,4 +25,10 @@ static inline bool io_futex_remove_all(struct io_ring_ctx *ctx,
 {
 	return false;
 }
+static inline void io_futex_cache_init(struct io_ring_ctx *ctx)
+{
+}
+static inline void io_futex_cache_free(struct io_ring_ctx *ctx)
+{
+}
 #endif
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 8270f37c312d..7db2a139d110 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -318,6 +318,7 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 			    sizeof(struct async_poll));
 	io_alloc_cache_init(&ctx->netmsg_cache, IO_ALLOC_CACHE_MAX,
 			    sizeof(struct io_async_msghdr));
+	io_futex_cache_init(ctx);
 	init_completion(&ctx->ref_comp);
 	xa_init_flags(&ctx->personalities, XA_FLAGS_ALLOC1);
 	mutex_init(&ctx->uring_lock);
@@ -2917,6 +2918,7 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	io_eventfd_unregister(ctx);
 	io_alloc_cache_free(&ctx->apoll_cache, io_apoll_cache_free);
 	io_alloc_cache_free(&ctx->netmsg_cache, io_netmsg_cache_free);
+	io_futex_cache_free(ctx);
 	io_destroy_buffers(ctx);
 	mutex_unlock(&ctx->uring_lock);
 	if (ctx->sq_creds)
-- 
2.39.2

