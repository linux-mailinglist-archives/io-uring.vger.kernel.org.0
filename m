Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD28B3DA715
	for <lists+io-uring@lfdr.de>; Thu, 29 Jul 2021 17:06:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237278AbhG2PGg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 29 Jul 2021 11:06:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237738AbhG2PGg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 29 Jul 2021 11:06:36 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B447C0613CF
        for <io-uring@vger.kernel.org>; Thu, 29 Jul 2021 08:06:32 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id g15so7373255wrd.3
        for <io-uring@vger.kernel.org>; Thu, 29 Jul 2021 08:06:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=Iq6RUv5kyumk30vhTEVAE+y7hOq4pg8THR7oGPeCJyc=;
        b=REHjlp0Gnw1KFFW9iu4VFeMmAGcYLO28GzQy7RAMSa2gwgRbs9feHqUH+KVG1Rh16V
         n9LWsi3jQOwCUAeQAM2pGqPMYnfkZD1dYl9etKe3tcZctxOiw7mdGKPxJGosVn3Tnb/l
         WGIVbcyaBnJ7BzQDn+CAcQlXjyYBFENm9CGX7HoMPnyLkSn6b9iPgNwud0968IMJXy6B
         6G1w+yAVtgGwZQCzFy/AzEeQS30EHDVZTyAL3iH4myHPg4KnjbXRYw6xgnKUDknv3P7r
         aWKUl3scWUcKLMrrdL5HxrzwXv0V6AF5A9lNMGPgWj86/XEz0PEpOU4d4yArkIQS/sSz
         vXZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Iq6RUv5kyumk30vhTEVAE+y7hOq4pg8THR7oGPeCJyc=;
        b=IPsOApULn62NWxfI2BUymYRzJWWBK8W3Z/IXpigDTQ9IGw7gx8qtQLpkoIXBrI19t/
         9ETWxltGCeCtFrSkpHFDmLX7bwTC0thNH4n8DtaoLEwQFTCdbzwzkQ5xCgmvb+mGzXy7
         xl1CPF+VObFuN5MlX+O9ZuI5yeu4MN0aZdCbo+5ECApove19KK4vETXUnM0A9E9+Taet
         UqDZ/OjkEIhIbTP0X8xd2ZwZS2u+wlP5n5Ne/qivA0dQGQOt7fM48gJ8aLs4bh1O2CGT
         NNmpUuZt0o0s6XNKY8s4JXfNiZYQ6AVfZ3wH86JoIKmQ0PnEqQuP8dbO43ffDh8VkAX2
         Pazg==
X-Gm-Message-State: AOAM5301BTFdxcNEkBR+aj4smYO8umrSztIjH9+XX7Qhm8skVIJKXn3S
        cSZbBhbhGLRspQQNT/wQvwg=
X-Google-Smtp-Source: ABdhPJy9P4NsDfmnFEBd9+rB1Qtx7XRstHd4ZOWZK7ttOvpc3KnjABXGOPd+nEet3ip+YaqmSNsf7g==
X-Received: by 2002:adf:d1c7:: with SMTP id b7mr5486281wrd.108.1627571191031;
        Thu, 29 Jul 2021 08:06:31 -0700 (PDT)
Received: from localhost.localdomain ([148.252.128.141])
        by smtp.gmail.com with ESMTPSA id e6sm4764577wrg.18.2021.07.29.08.06.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 08:06:30 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 09/23] io_uring: move io_rsrc_node_alloc() definition
Date:   Thu, 29 Jul 2021 16:05:36 +0100
Message-Id: <1c6f4803a9d8d9bd75b098a72e2b5c9698b3f0f6.1627570633.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1627570633.git.asml.silence@gmail.com>
References: <cover.1627570633.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Move the function together with io_rsrc_node_ref_zero() in the source
file as it is to get rid of forward declarations.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 87 +++++++++++++++++++++++++--------------------------
 1 file changed, 43 insertions(+), 44 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index a5f58d8ea70f..d45d18c9fb76 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1050,7 +1050,6 @@ static void io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 					 struct task_struct *task,
 					 bool cancel_all);
 static void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd);
-static struct io_rsrc_node *io_rsrc_node_alloc(struct io_ring_ctx *ctx);
 
 static bool io_cqring_fill_event(struct io_ring_ctx *ctx, u64 user_data,
 				 long res, unsigned int cflags);
@@ -7146,6 +7145,49 @@ static void io_rsrc_node_destroy(struct io_rsrc_node *ref_node)
 	kfree(ref_node);
 }
 
+static void io_rsrc_node_ref_zero(struct percpu_ref *ref)
+{
+	struct io_rsrc_node *node = container_of(ref, struct io_rsrc_node, refs);
+	struct io_ring_ctx *ctx = node->rsrc_data->ctx;
+	bool first_add = false;
+
+	io_rsrc_ref_lock(ctx);
+	node->done = true;
+
+	while (!list_empty(&ctx->rsrc_ref_list)) {
+		node = list_first_entry(&ctx->rsrc_ref_list,
+					    struct io_rsrc_node, node);
+		/* recycle ref nodes in order */
+		if (!node->done)
+			break;
+		list_del(&node->node);
+		first_add |= llist_add(&node->llist, &ctx->rsrc_put_llist);
+	}
+	io_rsrc_ref_unlock(ctx);
+
+	if (first_add)
+		mod_delayed_work(system_wq, &ctx->rsrc_put_work, HZ);
+}
+
+static struct io_rsrc_node *io_rsrc_node_alloc(struct io_ring_ctx *ctx)
+{
+	struct io_rsrc_node *ref_node;
+
+	ref_node = kzalloc(sizeof(*ref_node), GFP_KERNEL);
+	if (!ref_node)
+		return NULL;
+
+	if (percpu_ref_init(&ref_node->refs, io_rsrc_node_ref_zero,
+			    0, GFP_KERNEL)) {
+		kfree(ref_node);
+		return NULL;
+	}
+	INIT_LIST_HEAD(&ref_node->node);
+	INIT_LIST_HEAD(&ref_node->rsrc_list);
+	ref_node->done = false;
+	return ref_node;
+}
+
 static void io_rsrc_node_switch(struct io_ring_ctx *ctx,
 				struct io_rsrc_data *data_to_kill)
 {
@@ -7662,49 +7704,6 @@ static void io_rsrc_put_work(struct work_struct *work)
 	}
 }
 
-static void io_rsrc_node_ref_zero(struct percpu_ref *ref)
-{
-	struct io_rsrc_node *node = container_of(ref, struct io_rsrc_node, refs);
-	struct io_ring_ctx *ctx = node->rsrc_data->ctx;
-	bool first_add = false;
-
-	io_rsrc_ref_lock(ctx);
-	node->done = true;
-
-	while (!list_empty(&ctx->rsrc_ref_list)) {
-		node = list_first_entry(&ctx->rsrc_ref_list,
-					    struct io_rsrc_node, node);
-		/* recycle ref nodes in order */
-		if (!node->done)
-			break;
-		list_del(&node->node);
-		first_add |= llist_add(&node->llist, &ctx->rsrc_put_llist);
-	}
-	io_rsrc_ref_unlock(ctx);
-
-	if (first_add)
-		mod_delayed_work(system_wq, &ctx->rsrc_put_work, HZ);
-}
-
-static struct io_rsrc_node *io_rsrc_node_alloc(struct io_ring_ctx *ctx)
-{
-	struct io_rsrc_node *ref_node;
-
-	ref_node = kzalloc(sizeof(*ref_node), GFP_KERNEL);
-	if (!ref_node)
-		return NULL;
-
-	if (percpu_ref_init(&ref_node->refs, io_rsrc_node_ref_zero,
-			    0, GFP_KERNEL)) {
-		kfree(ref_node);
-		return NULL;
-	}
-	INIT_LIST_HEAD(&ref_node->node);
-	INIT_LIST_HEAD(&ref_node->rsrc_list);
-	ref_node->done = false;
-	return ref_node;
-}
-
 static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 				 unsigned nr_args, u64 __user *tags)
 {
-- 
2.32.0

