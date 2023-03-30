Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 293546D08C3
	for <lists+io-uring@lfdr.de>; Thu, 30 Mar 2023 16:54:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232527AbjC3Oyg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Mar 2023 10:54:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232517AbjC3Oyf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Mar 2023 10:54:35 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47C37C0;
        Thu, 30 Mar 2023 07:54:34 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id q19so16311543wrc.5;
        Thu, 30 Mar 2023 07:54:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680188072;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=og4wgHhZR2GI1KYFHJJde+4r5/spcbG2U9hgu2p3spE=;
        b=hRTo+Lt0jHxCwNBNqYPtSs/Fu3DRJIFkKl1hfQPK34dp4JAhtXHHi5Fzn0q/FXzjdO
         yWceZAoczbvHCjKwpfse9IW+0x6CFa5vppjOUpUnUE/UdW8LEscWvNv0fw/S/DsqiJri
         hZiRsl2bTtE/B4+R7sohDYRgKD+qjohZ/PqsdyZHV6Rd4qar5WpYCOJXtLHJUY+0L/B+
         XrwsAJNeY8MyxkC1lrfH78DOiXq6t/CtrUF2qb3YjeExRNeWmk5gaOBpFf5JS8kihd7X
         +LMLFIquPGdR8/txghJ/ZQfP80sozyEY0RuNHdszUpycfk7gzeDTBIrSxILoYMi/wM9D
         RSVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680188072;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=og4wgHhZR2GI1KYFHJJde+4r5/spcbG2U9hgu2p3spE=;
        b=j8/ltYu7Zifqfwwx7pcdixAAmKhKZqWekWCRfYQ3BfDSQyPZM98InL4VVwaRe+/n3H
         a0kDXq7y9MJr1rEaMhvZJY+7+SUO14FB6gsFzL+53C/YvTi3YZ9xmWWfF0F/ThYcpd2H
         /l8qqyv22WQo69nhPebkWHd1S88Poe3+Fvt1nGtLOJ4W9hRDJn57oELlyx4dd0+hBDYf
         tolfv1M9ECGAeWASj4GevwuUkC71IMeDo94+LBh5tcqB289dbFG62rQjBeQvXaCTEiMN
         1f75XkkXlZWH+wNvjRIQsbWg6VlNt5pXb0lOcR5XT3PRJkqnFN8yCMtA190w0okHshXu
         G8lg==
X-Gm-Message-State: AAQBX9forATOKaNK5FaXrsLManEuQuCIDtodYcc7CEfn3cuw0jZuQYo9
        hJcnBEIDYoIpTfS6aWZ6nIbYHGzGBic=
X-Google-Smtp-Source: AKy350YWivha0UWh8ExkJ5k3sHfMYKTaMkckXbx+VrNrZ5j4r+l/rDRvtAaAX9Tu+hnOdcYu6VzGrA==
X-Received: by 2002:adf:dd10:0:b0:2d8:e6ba:99e8 with SMTP id a16-20020adfdd10000000b002d8e6ba99e8mr17987366wrm.33.1680188072431;
        Thu, 30 Mar 2023 07:54:32 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-231-234.dab.02.net. [82.132.231.234])
        by smtp.gmail.com with ESMTPSA id d7-20020adffbc7000000b002d5a8d8442asm28727962wrs.37.2023.03.30.07.54.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Mar 2023 07:54:32 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 01/11] io_uring/rsrc: use non-pcpu refcounts for nodes
Date:   Thu, 30 Mar 2023 15:53:19 +0100
Message-Id: <243504691227d611f27a0f642ec8982db6ef4ead.1680187408.git.asml.silence@gmail.com>
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
index 7a43aed8e395..f2da9e251e3f 100644
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

