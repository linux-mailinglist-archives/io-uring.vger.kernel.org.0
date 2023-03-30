Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF0766D08D6
	for <lists+io-uring@lfdr.de>; Thu, 30 Mar 2023 16:55:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232648AbjC3OzR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Mar 2023 10:55:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232647AbjC3Oyz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Mar 2023 10:54:55 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85756CC0B;
        Thu, 30 Mar 2023 07:54:48 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id y14so19396356wrq.4;
        Thu, 30 Mar 2023 07:54:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680188086;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5L1thsz1ijtI+bii8vpLvzOuK72ES0dN5LpyxAEJB5c=;
        b=S8QHHi5z9LQOXa3uaWYMZ73OR1vDlNr3ze+rGxV67KXFNl+cuHXiqn5xbDswvDcMbt
         kdzkDFjmn2YYLGAt2MvCosiHyv0RaOltvUfqrEHfPO9pcC7c67zsfsQ6p9B6xrCr9TPw
         XLAxYueWYIYjma7qkjufO78bsMj3LhAjKmV32/78VXV0hIIfm7uZ/bjraokrdb+rnPuk
         CEV7/JHzJ3Dp5s5nGyMrzE3gJfrWX6m2go530EO+HSUcIN7nrLwni/bqJRAzqo9nLpQU
         66tK2GGCYaq/M/oAqOdbQ6UD0qAM5CT9N8nS/Ic26HZIIJXGZMJ3MCzFNgfZdgq/92Gs
         Ss6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680188086;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5L1thsz1ijtI+bii8vpLvzOuK72ES0dN5LpyxAEJB5c=;
        b=6kKQu9BAYX881ImrUsv0BvDOP7sxNGeEIOIXFIeXEE6lFPnun9Zd27RWuVkTM22FFG
         q+enWFsyAQpQRxuKMRJlkyOtFwoTRJhQx9uMfojsjRdXqCxLHShOH0vms6YXH5uhxXNh
         FAPKNAhvD3wmF4C67HKn6PUYxlU/ivOF93jx23VcVMK1+RDJopyCVa38t/u+B0kjIqqW
         VowGOzliUSRg60tDcLVIBL8Le4xzzN3vaYTrcB6EZ/KnM0XA8cvdwTgVNRvLul4sGF/l
         0VPoZoa6D5YpHt84leF4l/rA1LvbMEJCC7IPybIbcBXyYz/24DgYvCHE1qFNGlWXGa1u
         5K6g==
X-Gm-Message-State: AAQBX9e7/reayQqiCBKACW2L+p+LLRgtrtrwGPjLwMjO/dZk6mHiG5oZ
        WIeT3BROepx3xkh9lrrOHcceo6xC8mA=
X-Google-Smtp-Source: AKy350Y1t92VxNpQ0Ksc8TqGupI9EyiT/KYdiGXqDEGmSG2onayZh3ULzQ1M9OWwuGS9B0o1I6Q7fQ==
X-Received: by 2002:a5d:5601:0:b0:2d2:ac99:a72 with SMTP id l1-20020a5d5601000000b002d2ac990a72mr20884439wrv.46.1680188086134;
        Thu, 30 Mar 2023 07:54:46 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-231-234.dab.02.net. [82.132.231.234])
        by smtp.gmail.com with ESMTPSA id d7-20020adffbc7000000b002d5a8d8442asm28727962wrs.37.2023.03.30.07.54.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Mar 2023 07:54:45 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 10/11] io_uring/rsrc: cache struct io_rsrc_node
Date:   Thu, 30 Mar 2023 15:53:28 +0100
Message-Id: <7f5eb1b89e8dcf93739607c79bbf7aec1784cbbe.1680187408.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1680187408.git.asml.silence@gmail.com>
References: <cover.1680187408.git.asml.silence@gmail.com>
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
 io_uring/rsrc.h                |  5 ++++-
 4 files changed, 29 insertions(+), 11 deletions(-)

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
index 8c3886a4ca96..beedaf403284 100644
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
@@ -2791,6 +2792,11 @@ static void io_req_caches_free(struct io_ring_ctx *ctx)
 	mutex_unlock(&ctx->uring_lock);
 }
 
+void io_rsrc_node_cache_free(struct io_cache_entry *entry)
+{
+	kfree(container_of(entry, struct io_rsrc_node, cache));
+}
+
 static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 {
 	io_sq_thread_finish(ctx);
@@ -2816,9 +2822,9 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 
 	/* there are no registered resources left, nobody uses it */
 	if (ctx->rsrc_node)
-		io_rsrc_node_destroy(ctx->rsrc_node);
+		io_rsrc_node_destroy(ctx, ctx->rsrc_node);
 	if (ctx->rsrc_backup_node)
-		io_rsrc_node_destroy(ctx->rsrc_backup_node);
+		io_rsrc_node_destroy(ctx, ctx->rsrc_backup_node);
 
 	WARN_ON_ONCE(!list_empty(&ctx->rsrc_ref_list));
 
@@ -2830,6 +2836,7 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 #endif
 	WARN_ON_ONCE(!list_empty(&ctx->ltimeout_list));
 
+	io_alloc_cache_free(&ctx->rsrc_node_cache, io_rsrc_node_cache_free);
 	if (ctx->mm_account) {
 		mmdrop(ctx->mm_account);
 		ctx->mm_account = NULL;
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 0f4e245dee1b..345631091d80 100644
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
index 17293ab90f64..d1555eaae81a 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -4,6 +4,8 @@
 
 #include <net/af_unix.h>
 
+#include "alloc_cache.h"
+
 #define IO_RSRC_TAG_TABLE_SHIFT	(PAGE_SHIFT - 3)
 #define IO_RSRC_TAG_TABLE_MAX	(1U << IO_RSRC_TAG_TABLE_SHIFT)
 #define IO_RSRC_TAG_TABLE_MASK	(IO_RSRC_TAG_TABLE_MAX - 1)
@@ -37,6 +39,7 @@ struct io_rsrc_data {
 };
 
 struct io_rsrc_node {
+	struct io_cache_entry		cache;
 	int refs;
 	struct list_head		node;
 	struct io_rsrc_data		*rsrc_data;
@@ -65,7 +68,7 @@ void io_rsrc_put_tw(struct callback_head *cb);
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

