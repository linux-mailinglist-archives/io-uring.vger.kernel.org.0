Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2DE36D60FD
	for <lists+io-uring@lfdr.de>; Tue,  4 Apr 2023 14:41:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235015AbjDDMlG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 4 Apr 2023 08:41:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234903AbjDDMlA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 4 Apr 2023 08:41:00 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5A4B2691;
        Tue,  4 Apr 2023 05:40:57 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id y4so130081362edo.2;
        Tue, 04 Apr 2023 05:40:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680612056;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OosuePooWAYrbPI47Qhw79nJ97AML6lNG9IhcjMYqms=;
        b=dSk/vKob9igkkdeg8NRXjQ7AQa5psSBN7jeNLQ7wZKtCoGXz3xvA+iirvCDAbsMnu5
         iblL8A2WF37DKGDHzOq+vUlxJzAILpV57JaEO6b3/qUCpm8bTXxx8q/+fe+FWv6ZGxKy
         b4jwFT9PPWHyPEQMbxMe/OiURYQcCrqA5i6km6aw7upGeNdxk2g3t6fQSv9MLjauIBWh
         dPLkt6Wd1KlvCd/VRa+TDrG+IGNHiHWX2wHVMR0wDLPTFuzClLh56+xclOFHG6vHPNMB
         mzpfE7ZE0u/w1pUag2Ku021PAw3oBN9cnDnTaCOWsVKlJ9SX7NeIovxSjavRnu/YvHnV
         djoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680612056;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OosuePooWAYrbPI47Qhw79nJ97AML6lNG9IhcjMYqms=;
        b=8LqIO7Ie/DrmxV6hODoRl+hxwM0f1fpwzLw8KzuOAsK+w2wQoAqXdzupYPzdeLGV5H
         x863p7F5SzNmoRp4/b+IJaPLQmxPJwIRYpc8QQx3P/YiHhlm6p/os3fp6bMovaWdHSIy
         yqSM03xggIvT/D7nkp34STQLB+WuF+2FzNj+cu5fMedVbDA9Pk25DpwgWNPtwRK9ldZq
         kH7M3npyelSuizFWFEk4xXn/fkJBnScbbLNlXLipfO965awF3OfLpBJTum9qEIUwMrwx
         VhxEZ0hoBOINzJnggIui37RaK7jjPJhhGBqdHxltFmQgbCwnP2p8vEGBL+BtgLQZsUzz
         rW9A==
X-Gm-Message-State: AAQBX9fRE73j1sBrqsHFCYQyCn4RVTzXpYhTdbO4vYn+C5+aii1cml06
        3twVlan1lhmez7COCvjPgHyBfM2hTfo=
X-Google-Smtp-Source: AKy350YXne1DLdlgMvuhZN/dWSThoLVVMmXCst3C2kNPaMCUW6+7VYFw9F5ESYBusUbBDPg6PaZSdQ==
X-Received: by 2002:a17:906:1dd4:b0:92a:8067:7637 with SMTP id v20-20020a1709061dd400b0092a80677637mr1939585ejh.61.1680612056176;
        Tue, 04 Apr 2023 05:40:56 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::2:2b22])
        by smtp.gmail.com with ESMTPSA id g8-20020a170906394800b008cafeec917dsm5978851eje.101.2023.04.04.05.40.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 05:40:56 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 10/13] io_uring/rsrc: cache struct io_rsrc_node
Date:   Tue,  4 Apr 2023 13:39:54 +0100
Message-Id: <252a9d9ef9654e6467af30fdc02f57c0118fb76e.1680576071.git.asml.silence@gmail.com>
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

Add allocation cache for struct io_rsrc_node, it's always allocated and
put under ->uring_lock, so it doesn't need any extra synchronisation
around caches.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring_types.h |  1 +
 io_uring/io_uring.c            | 11 +++++++++--
 io_uring/rsrc.c                | 23 +++++++++++++++--------
 io_uring/rsrc.h                |  9 +++++++--
 4 files changed, 32 insertions(+), 12 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 47496059e13a..5d772e36e7fc 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -332,6 +332,7 @@ struct io_ring_ctx {
 
 	/* protected by ->uring_lock */
 	struct list_head		rsrc_ref_list;
+	struct io_alloc_cache		rsrc_node_cache;
 
 	struct list_head		io_buffers_pages;
 
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index d6a0025afc31..419d6f42935f 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -310,6 +310,7 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	INIT_LIST_HEAD(&ctx->sqd_list);
 	INIT_LIST_HEAD(&ctx->cq_overflow_list);
 	INIT_LIST_HEAD(&ctx->io_buffers_cache);
+	io_alloc_cache_init(&ctx->rsrc_node_cache, sizeof(struct io_rsrc_node));
 	io_alloc_cache_init(&ctx->apoll_cache, sizeof(struct async_poll));
 	io_alloc_cache_init(&ctx->netmsg_cache, sizeof(struct io_async_msghdr));
 	init_completion(&ctx->ref_comp);
@@ -2790,6 +2791,11 @@ static void io_req_caches_free(struct io_ring_ctx *ctx)
 	mutex_unlock(&ctx->uring_lock);
 }
 
+static void io_rsrc_node_cache_free(struct io_cache_entry *entry)
+{
+	kfree(container_of(entry, struct io_rsrc_node, cache));
+}
+
 static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 {
 	io_sq_thread_finish(ctx);
@@ -2815,9 +2821,9 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 
 	/* there are no registered resources left, nobody uses it */
 	if (ctx->rsrc_node)
-		io_rsrc_node_destroy(ctx->rsrc_node);
+		io_rsrc_node_destroy(ctx, ctx->rsrc_node);
 	if (ctx->rsrc_backup_node)
-		io_rsrc_node_destroy(ctx->rsrc_backup_node);
+		io_rsrc_node_destroy(ctx, ctx->rsrc_backup_node);
 
 	WARN_ON_ONCE(!list_empty(&ctx->rsrc_ref_list));
 
@@ -2829,6 +2835,7 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 #endif
 	WARN_ON_ONCE(!list_empty(&ctx->ltimeout_list));
 
+	io_alloc_cache_free(&ctx->rsrc_node_cache, io_rsrc_node_cache_free);
 	if (ctx->mm_account) {
 		mmdrop(ctx->mm_account);
 		ctx->mm_account = NULL;
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 77cb2f8cfd68..cbf563fcb053 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -164,7 +164,7 @@ static void __io_rsrc_put_work(struct io_rsrc_node *ref_node)
 		kfree(prsrc);
 	}
 
-	io_rsrc_node_destroy(ref_node);
+	io_rsrc_node_destroy(rsrc_data->ctx, ref_node);
 	if (atomic_dec_and_test(&rsrc_data->refs))
 		complete(&rsrc_data->done);
 }
@@ -175,9 +175,10 @@ void io_wait_rsrc_data(struct io_rsrc_data *data)
 		wait_for_completion(&data->done);
 }
 
-void io_rsrc_node_destroy(struct io_rsrc_node *ref_node)
+void io_rsrc_node_destroy(struct io_ring_ctx *ctx, struct io_rsrc_node *node)
 {
-	kfree(ref_node);
+	if (!io_alloc_cache_put(&ctx->rsrc_node_cache, &node->cache))
+		kfree(node);
 }
 
 void io_rsrc_node_ref_zero(struct io_rsrc_node *node)
@@ -198,13 +199,19 @@ void io_rsrc_node_ref_zero(struct io_rsrc_node *node)
 	}
 }
 
-static struct io_rsrc_node *io_rsrc_node_alloc(void)
+static struct io_rsrc_node *io_rsrc_node_alloc(struct io_ring_ctx *ctx)
 {
 	struct io_rsrc_node *ref_node;
+	struct io_cache_entry *entry;
 
-	ref_node = kzalloc(sizeof(*ref_node), GFP_KERNEL);
-	if (!ref_node)
-		return NULL;
+	entry = io_alloc_cache_get(&ctx->rsrc_node_cache);
+	if (entry) {
+		ref_node = container_of(entry, struct io_rsrc_node, cache);
+	} else {
+		ref_node = kzalloc(sizeof(*ref_node), GFP_KERNEL);
+		if (!ref_node)
+			return NULL;
+	}
 
 	ref_node->refs = 1;
 	INIT_LIST_HEAD(&ref_node->node);
@@ -243,7 +250,7 @@ int io_rsrc_node_switch_start(struct io_ring_ctx *ctx)
 {
 	if (ctx->rsrc_backup_node)
 		return 0;
-	ctx->rsrc_backup_node = io_rsrc_node_alloc();
+	ctx->rsrc_backup_node = io_rsrc_node_alloc(ctx);
 	return ctx->rsrc_backup_node ? 0 : -ENOMEM;
 }
 
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index 11703082d125..3b9f4c57c47c 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -4,6 +4,8 @@
 
 #include <net/af_unix.h>
 
+#include "alloc_cache.h"
+
 #define IO_RSRC_TAG_TABLE_SHIFT	(PAGE_SHIFT - 3)
 #define IO_RSRC_TAG_TABLE_MAX	(1U << IO_RSRC_TAG_TABLE_SHIFT)
 #define IO_RSRC_TAG_TABLE_MASK	(IO_RSRC_TAG_TABLE_MAX - 1)
@@ -37,8 +39,11 @@ struct io_rsrc_data {
 };
 
 struct io_rsrc_node {
+	union {
+		struct io_cache_entry		cache;
+		struct io_rsrc_data		*rsrc_data;
+	};
 	struct list_head		node;
-	struct io_rsrc_data		*rsrc_data;
 	struct llist_node		llist;
 	int				refs;
 	bool				done;
@@ -65,7 +70,7 @@ void io_rsrc_put_tw(struct callback_head *cb);
 void io_rsrc_node_ref_zero(struct io_rsrc_node *node);
 void io_rsrc_put_work(struct work_struct *work);
 void io_wait_rsrc_data(struct io_rsrc_data *data);
-void io_rsrc_node_destroy(struct io_rsrc_node *ref_node);
+void io_rsrc_node_destroy(struct io_ring_ctx *ctx, struct io_rsrc_node *ref_node);
 int io_rsrc_node_switch_start(struct io_ring_ctx *ctx);
 int io_queue_rsrc_removal(struct io_rsrc_data *data, unsigned idx,
 			  struct io_rsrc_node *node, void *rsrc);
-- 
2.39.1

