Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 727E16D60F2
	for <lists+io-uring@lfdr.de>; Tue,  4 Apr 2023 14:41:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234651AbjDDMk7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 4 Apr 2023 08:40:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234499AbjDDMk4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 4 Apr 2023 08:40:56 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B489AE4A;
        Tue,  4 Apr 2023 05:40:52 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id fi11so6525271edb.10;
        Tue, 04 Apr 2023 05:40:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680612051;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ynSkjWiStdChDNmK6w/UU6qev6e/KMNN2NT7DgiXXHE=;
        b=aPtNfhhD6HDyNQalImrT+8W73E2NbJu5FXJZWAiY0ChnnI3+bKrQz43eWEd9PNjY/y
         a7ynjbzXgZuY/TPKpj/LrlPgSsGh6SAUCFZoiM0jv+CQZGg3LhgkVN7GdIXgsuxFJ99i
         OfDsvIWKmojCZu2z+CQM83ChibNGTU81YOh5vuOIh5vC2Cma05hOIAvUzBoL/SFCNAf2
         SGB4hZiESzRvM5sxGhix+BiKDV6ewfWwpCAot0L/CKY7dwvjg4mdde3l6hZXT6qr8vJS
         P583DMeH/Nxhe7EGxAqbP7n20NtLnHet0dB8E9spE94CthjK/CZYlIIIKhfmI83qlpYA
         WsYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680612051;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ynSkjWiStdChDNmK6w/UU6qev6e/KMNN2NT7DgiXXHE=;
        b=YuZVd7Ik8M2dEhIjotqWIBODErKVIPZs4SC2QvEQQc+oZXa/MeA3GZeTJkBt4Pexoa
         Wry4rd/AfO2dGJx5jfJ8lj/aFEeLC6+coUAkezhAQYI2pXdrZWX9pI0WHQZLd8XR40/S
         l8oxer0ZxzF9MdUd7rIklNVqqv+ovkSHuZIXMqwfLbMyvq2jYZnegGOe41Zmp2GGBoQL
         rDGx+1kdkaplc0KcikLubA1njGzDnIk1rhyr/ENZEIjp8UHgXrx70FmRUQRi2atpVo5e
         /E0FiHPb3M8uE7ORzK9GgEuPNT/wu5sMkF/+moUJVqZddX3ePDZiR3J4DCnmAawFvHZI
         5k8Q==
X-Gm-Message-State: AAQBX9e4E17oD42AUWx3LhH0ROmFpaPHjZSXq4zPF5ieQbJ4xmVVxC9W
        azuYpv/Y//r8QjGWnlyaCZS3LYDMKnw=
X-Google-Smtp-Source: AKy350YF2WJ9TK49httqw/+r/uW4FIWYfL4RwApKmFW4UMsHkouHm6bgbXhbQE6bFG886Jkb/Bm2HQ==
X-Received: by 2002:a17:907:2071:b0:921:5e7b:1c27 with SMTP id qp17-20020a170907207100b009215e7b1c27mr2121888ejb.24.1680612050967;
        Tue, 04 Apr 2023 05:40:50 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::2:2b22])
        by smtp.gmail.com with ESMTPSA id g8-20020a170906394800b008cafeec917dsm5978851eje.101.2023.04.04.05.40.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 05:40:50 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 01/13] io_uring/rsrc: use non-pcpu refcounts for nodes
Date:   Tue,  4 Apr 2023 13:39:45 +0100
Message-Id: <e9ed8a9457b331a26555ff9443afc64cdaab7247.1680576071.git.asml.silence@gmail.com>
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

One problem with the current rsrc infra is that often updates will
generates lots of rsrc nodes, each carry pcpu refs. That takes quite a
lot of memory, especially if there is a stall, and takes lots of CPU
cycles. Only pcpu allocations takes >50 of CPU with a naive benchmark
updating files in a loop.

Replace pcpu refs with normal refcounting. There is already a hot path
avoiding atomics / refs, but following patches will further improve it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rsrc.c | 15 +++++----------
 io_uring/rsrc.h |  6 ++++--
 2 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index a5ed0ee7c160..1b9b7f98fb7e 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -155,7 +155,7 @@ void io_rsrc_refs_refill(struct io_ring_ctx *ctx)
 	__must_hold(&ctx->uring_lock)
 {
 	ctx->rsrc_cached_refs += IO_RSRC_REF_BATCH;
-	percpu_ref_get_many(&ctx->rsrc_node->refs, IO_RSRC_REF_BATCH);
+	refcount_add(IO_RSRC_REF_BATCH, &ctx->rsrc_node->refs);
 }
 
 static void __io_rsrc_put_work(struct io_rsrc_node *ref_node)
@@ -220,13 +220,11 @@ void io_wait_rsrc_data(struct io_rsrc_data *data)
 
 void io_rsrc_node_destroy(struct io_rsrc_node *ref_node)
 {
-	percpu_ref_exit(&ref_node->refs);
 	kfree(ref_node);
 }
 
-static __cold void io_rsrc_node_ref_zero(struct percpu_ref *ref)
+__cold void io_rsrc_node_ref_zero(struct io_rsrc_node *node)
 {
-	struct io_rsrc_node *node = container_of(ref, struct io_rsrc_node, refs);
 	struct io_ring_ctx *ctx = node->rsrc_data->ctx;
 	unsigned long flags;
 	bool first_add = false;
@@ -269,11 +267,7 @@ static struct io_rsrc_node *io_rsrc_node_alloc(void)
 	if (!ref_node)
 		return NULL;
 
-	if (percpu_ref_init(&ref_node->refs, io_rsrc_node_ref_zero,
-			    0, GFP_KERNEL)) {
-		kfree(ref_node);
-		return NULL;
-	}
+	refcount_set(&ref_node->refs, 1);
 	INIT_LIST_HEAD(&ref_node->node);
 	INIT_LIST_HEAD(&ref_node->rsrc_list);
 	ref_node->done = false;
@@ -298,7 +292,8 @@ void io_rsrc_node_switch(struct io_ring_ctx *ctx,
 		spin_unlock_irq(&ctx->rsrc_ref_lock);
 
 		atomic_inc(&data_to_kill->refs);
-		percpu_ref_kill(&rsrc_node->refs);
+		/* put master ref */
+		io_rsrc_put_node(rsrc_node, 1);
 		ctx->rsrc_node = NULL;
 	}
 
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index f27f4975217d..1467b31843bc 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -37,7 +37,7 @@ struct io_rsrc_data {
 };
 
 struct io_rsrc_node {
-	struct percpu_ref		refs;
+	refcount_t			refs;
 	struct list_head		node;
 	struct list_head		rsrc_list;
 	struct io_rsrc_data		*rsrc_data;
@@ -54,6 +54,7 @@ struct io_mapped_ubuf {
 };
 
 void io_rsrc_put_tw(struct callback_head *cb);
+void io_rsrc_node_ref_zero(struct io_rsrc_node *node);
 void io_rsrc_put_work(struct work_struct *work);
 void io_rsrc_refs_refill(struct io_ring_ctx *ctx);
 void io_wait_rsrc_data(struct io_rsrc_data *data);
@@ -109,7 +110,8 @@ int io_register_rsrc(struct io_ring_ctx *ctx, void __user *arg,
 
 static inline void io_rsrc_put_node(struct io_rsrc_node *node, int nr)
 {
-	percpu_ref_put_many(&node->refs, nr);
+	if (refcount_sub_and_test(nr, &node->refs))
+		io_rsrc_node_ref_zero(node);
 }
 
 static inline void io_req_put_rsrc(struct io_kiocb *req)
-- 
2.39.1

