Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F57F6D60FC
	for <lists+io-uring@lfdr.de>; Tue,  4 Apr 2023 14:41:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234813AbjDDMlF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 4 Apr 2023 08:41:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234878AbjDDMlA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 4 Apr 2023 08:41:00 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 313731739;
        Tue,  4 Apr 2023 05:40:57 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id w9so130035052edc.3;
        Tue, 04 Apr 2023 05:40:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680612055;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b0oibOM/o2KUQ8VFakULVS2Dn6jFvS8HYN/Ntyf1ZUA=;
        b=GwmjIJ4S5yZX09/3v4NT/IFIyTPeYrkm2Q05j90JZgJnwC1c3dxwX+NWIroO8dpNl2
         h8F8cEay5gFQK9LLVgLiJVuGYE6i7rPlr9vZD7WWGMZl07kU3CU5OYbrGI0cn8njH7vN
         ZV2fWsdunDt0/PMfTzCZMAQP/NilA8N9BY5wN1seG3Nca+3T9X5RTxY6lVSAyB54ZO4P
         8L8f2acB23xJt2TfDZRNRLwZ9YAZs0zdOy+Ra2tu/VvtwdQJUc2wjP+6aUWAYSzaqW5n
         kjhhl/tx5QVtBjwRbxmKHKH4TEwVEIkvzud54Abpwpla4nPce9+5e8RawpE/ARFOrmUh
         eYNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680612055;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b0oibOM/o2KUQ8VFakULVS2Dn6jFvS8HYN/Ntyf1ZUA=;
        b=UnYw9SdUufSlVnNAWvuhV9d6Y/AlYsI2o8fqf5yt77ljdC6XddO0hPe/K5H4BS0KhT
         guyntw987filBujoVZg4IgSVFb7ltyEUF9oNgEqlzmtVLvYujyWBpN7S3+3sb/rSRm7Y
         uA1hRLPH6ma2UNpeTGNYvDp6ROFZMocW/QYP4vFUHkBy5zCaQtBTcgrsvPH31bm4/F3M
         Qg4y7niOheXFlFp8R4lJVcV44F6aR2PejGrm8Pr1fSlHqG57R7CPpVFxyBG7GF/ATUCB
         vHqSImzndAcyvKgY8RXsYpGiIYLviovR2wWQOsywq1U2Y2V9yl5S8yPFFDneNKApSVNZ
         h5yw==
X-Gm-Message-State: AAQBX9e/TLvEpUhbjBq/nX5T+gL+4cS1iMQeklm2bxVkTgBzVm7r2jiI
        gHyCsQAAoG1+HXfTwrP2VJYS7VKLC6o=
X-Google-Smtp-Source: AKy350YFIXkgZlrL74pkzAzI+3vgLa0QPKW57HuWzMkKf3EpBV3b5tvPuT4p8Xpr8cAuxYE93qPAPA==
X-Received: by 2002:a17:906:3999:b0:93b:46f7:a716 with SMTP id h25-20020a170906399900b0093b46f7a716mr1763115eje.50.1680612055565;
        Tue, 04 Apr 2023 05:40:55 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::2:2b22])
        by smtp.gmail.com with ESMTPSA id g8-20020a170906394800b008cafeec917dsm5978851eje.101.2023.04.04.05.40.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 05:40:55 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 09/13] io_uring/rsrc: don't offload node free
Date:   Tue,  4 Apr 2023 13:39:53 +0100
Message-Id: <13fb1aac1e8d068ad8fd4a0c6d0d157ab61b90c0.1680576071.git.asml.silence@gmail.com>
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

struct delayed_work rsrc_put_work was previously used to offload node
freeing because io_rsrc_node_ref_zero() was previously called by RCU in
the IRQ context. Now, as percpu refcounting is gone, we can do it
eagerly at the spot without pushing it to a worker.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring_types.h |  3 --
 io_uring/io_uring.c            |  6 ----
 io_uring/rsrc.c                | 59 +++-------------------------------
 3 files changed, 4 insertions(+), 64 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 9492889f00c0..47496059e13a 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -330,9 +330,6 @@ struct io_ring_ctx {
 	struct io_rsrc_data		*file_data;
 	struct io_rsrc_data		*buf_data;
 
-	struct delayed_work		rsrc_put_work;
-	struct callback_head		rsrc_put_tw;
-	struct llist_head		rsrc_put_llist;
 	/* protected by ->uring_lock */
 	struct list_head		rsrc_ref_list;
 
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 764df5694d73..d6a0025afc31 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -326,9 +326,6 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	INIT_LIST_HEAD(&ctx->timeout_list);
 	INIT_LIST_HEAD(&ctx->ltimeout_list);
 	INIT_LIST_HEAD(&ctx->rsrc_ref_list);
-	INIT_DELAYED_WORK(&ctx->rsrc_put_work, io_rsrc_put_work);
-	init_task_work(&ctx->rsrc_put_tw, io_rsrc_put_tw);
-	init_llist_head(&ctx->rsrc_put_llist);
 	init_llist_head(&ctx->work_llist);
 	INIT_LIST_HEAD(&ctx->tctx_list);
 	ctx->submit_state.free_list.next = NULL;
@@ -2821,11 +2818,8 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 		io_rsrc_node_destroy(ctx->rsrc_node);
 	if (ctx->rsrc_backup_node)
 		io_rsrc_node_destroy(ctx->rsrc_backup_node);
-	flush_delayed_work(&ctx->rsrc_put_work);
-	flush_delayed_work(&ctx->fallback_work);
 
 	WARN_ON_ONCE(!list_empty(&ctx->rsrc_ref_list));
-	WARN_ON_ONCE(!llist_empty(&ctx->rsrc_put_llist));
 
 #if defined(CONFIG_UNIX)
 	if (ctx->ring_sock) {
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 9647c02be0dc..77cb2f8cfd68 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -145,15 +145,8 @@ static void io_rsrc_put_work_one(struct io_rsrc_data *rsrc_data,
 {
 	struct io_ring_ctx *ctx = rsrc_data->ctx;
 
-	if (prsrc->tag) {
-		if (ctx->flags & IORING_SETUP_IOPOLL) {
-			mutex_lock(&ctx->uring_lock);
-			io_post_aux_cqe(ctx, prsrc->tag, 0, 0);
-			mutex_unlock(&ctx->uring_lock);
-		} else {
-			io_post_aux_cqe(ctx, prsrc->tag, 0, 0);
-		}
-	}
+	if (prsrc->tag)
+		io_post_aux_cqe(ctx, prsrc->tag, 0, 0);
 	rsrc_data->do_put(ctx, prsrc);
 }
 
@@ -176,32 +169,6 @@ static void __io_rsrc_put_work(struct io_rsrc_node *ref_node)
 		complete(&rsrc_data->done);
 }
 
-void io_rsrc_put_work(struct work_struct *work)
-{
-	struct io_ring_ctx *ctx;
-	struct llist_node *node;
-
-	ctx = container_of(work, struct io_ring_ctx, rsrc_put_work.work);
-	node = llist_del_all(&ctx->rsrc_put_llist);
-
-	while (node) {
-		struct io_rsrc_node *ref_node;
-		struct llist_node *next = node->next;
-
-		ref_node = llist_entry(node, struct io_rsrc_node, llist);
-		__io_rsrc_put_work(ref_node);
-		node = next;
-	}
-}
-
-void io_rsrc_put_tw(struct callback_head *cb)
-{
-	struct io_ring_ctx *ctx = container_of(cb, struct io_ring_ctx,
-					       rsrc_put_tw);
-
-	io_rsrc_put_work(&ctx->rsrc_put_work.work);
-}
-
 void io_wait_rsrc_data(struct io_rsrc_data *data)
 {
 	if (data && !atomic_dec_and_test(&data->refs))
@@ -217,34 +184,18 @@ void io_rsrc_node_ref_zero(struct io_rsrc_node *node)
 	__must_hold(&node->rsrc_data->ctx->uring_lock)
 {
 	struct io_ring_ctx *ctx = node->rsrc_data->ctx;
-	bool first_add = false;
-	unsigned long delay = HZ;
 
 	node->done = true;
-
-	/* if we are mid-quiesce then do not delay */
-	if (node->rsrc_data->quiesce)
-		delay = 0;
-
 	while (!list_empty(&ctx->rsrc_ref_list)) {
 		node = list_first_entry(&ctx->rsrc_ref_list,
 					    struct io_rsrc_node, node);
 		/* recycle ref nodes in order */
 		if (!node->done)
 			break;
-		list_del(&node->node);
-		first_add |= llist_add(&node->llist, &ctx->rsrc_put_llist);
-	}
 
-	if (!first_add)
-		return;
-
-	if (ctx->submitter_task) {
-		if (!task_work_add(ctx->submitter_task, &ctx->rsrc_put_tw,
-				   ctx->notify_method))
-			return;
+		list_del(&node->node);
+		__io_rsrc_put_work(node);
 	}
-	mod_delayed_work(system_wq, &ctx->rsrc_put_work, delay);
 }
 
 static struct io_rsrc_node *io_rsrc_node_alloc(void)
@@ -320,13 +271,11 @@ __cold static int io_rsrc_ref_quiesce(struct io_rsrc_data *data,
 		if (ret < 0) {
 			atomic_inc(&data->refs);
 			/* wait for all works potentially completing data->done */
-			flush_delayed_work(&ctx->rsrc_put_work);
 			reinit_completion(&data->done);
 			mutex_lock(&ctx->uring_lock);
 			break;
 		}
 
-		flush_delayed_work(&ctx->rsrc_put_work);
 		ret = wait_for_completion_interruptible(&data->done);
 		if (!ret) {
 			mutex_lock(&ctx->uring_lock);
-- 
2.39.1

