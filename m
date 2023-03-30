Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E95DE6D08D4
	for <lists+io-uring@lfdr.de>; Thu, 30 Mar 2023 16:55:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232628AbjC3OzM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Mar 2023 10:55:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232611AbjC3Oyw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Mar 2023 10:54:52 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEC9ACC06;
        Thu, 30 Mar 2023 07:54:45 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id q19so16312196wrc.5;
        Thu, 30 Mar 2023 07:54:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680188084;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TsovVhZknI6qeDE8kTU6QPdUJtFC7EMxs3/MNa3hVfA=;
        b=kfwYRcon7F1ORzR/RlIjWpwfgQKmtyIOPTNAWE95Z/LyNWD0toDNGfhLyrWbWRxQXb
         EZt3Tr2IBWMTLdJpnV4WJ0Bl2sgYaZq2nvo9N8/yB3lRkojyRpIii51pcNtLKGcS51M9
         Xkh9fnMl5JKbqOEA+CA6TYVa6SjK5R2E57t0IOgkE8WPgFmMBt8EYZlkQzBho2D7nzHF
         1/G1J+H/W93aiCzFTM9hcH7YOoB/KF7ELA7O+LVOn8iwZv0m0ztL1/b3SkrjQql8lyK9
         3CNR/OuOZJOioEqSVeaNuvxAgridGwr9zeUt6qX5rncc6zQVeRooNNHnpoDJ33iWH19L
         Xrzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680188084;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TsovVhZknI6qeDE8kTU6QPdUJtFC7EMxs3/MNa3hVfA=;
        b=fy+UFcNTj/gT4mDvXZ+I8aqWUTsfhiqsZ1FbN9NjWa8tSyUYg3V9b0W9nhRZgCBdiq
         Ceuyd4uAh2Y5HWHqWCQTc37TgyfLzDaOqylh+lqAo05zR8vcbe8OTr2P9M07fgZlSPRA
         RGnKSRY0K4/GP5UxglSg7I2qo+HwdNFEwvZqnD7CnIQnAIik5rTP2osIc98+wdzGsV2+
         9+Nqj+ZmuJwa/d01K8B17rq/oJLbyvGgT/ksZJeT6L5N/6XLhxKUbyi9Fy7fmYUKBBrY
         JLKVdKZsaphVEcgsnWolENqSECtMLubCTTJbeCamJyS0pD9ml7YZP1Zfxa0c6jQq/U6q
         dikA==
X-Gm-Message-State: AAQBX9fCAlGAmJ01M/RlP8vOT9es2ay+MtHRwZT6J1BinXpf3rd5RWGi
        NZ33AQqNSxKYFtf1BXp8KOJlYsrRB7A=
X-Google-Smtp-Source: AKy350bZLin5UOSFoyvcKHM1YioDYl+10F72AKeB16kOXfNqx4LVzfg1EkauemOq09DDu7fIB4AIPg==
X-Received: by 2002:a5d:404a:0:b0:2d1:947:318b with SMTP id w10-20020a5d404a000000b002d10947318bmr18567845wrp.13.1680188084304;
        Thu, 30 Mar 2023 07:54:44 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-231-234.dab.02.net. [82.132.231.234])
        by smtp.gmail.com with ESMTPSA id d7-20020adffbc7000000b002d5a8d8442asm28727962wrs.37.2023.03.30.07.54.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Mar 2023 07:54:44 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 09/11] io_uring/rsrc: don't offload node free
Date:   Thu, 30 Mar 2023 15:53:27 +0100
Message-Id: <8083bdb49f57a968104137f1f256af8a5d46da64.1680187408.git.asml.silence@gmail.com>
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
index e94780c0a024..8c3886a4ca96 100644
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
@@ -2822,11 +2819,8 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
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
index 95e71300bb35..0f4e245dee1b 100644
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

