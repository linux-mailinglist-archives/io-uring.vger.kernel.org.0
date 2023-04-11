Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3AAB6DD91C
	for <lists+io-uring@lfdr.de>; Tue, 11 Apr 2023 13:13:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230151AbjDKLNS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 11 Apr 2023 07:13:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbjDKLNK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 11 Apr 2023 07:13:10 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DC7F4697
        for <io-uring@vger.kernel.org>; Tue, 11 Apr 2023 04:12:52 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id sg7so30750513ejc.9
        for <io-uring@vger.kernel.org>; Tue, 11 Apr 2023 04:12:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1681211570;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v2nyzNZvTXnEQkp2ImwUNfiYpTnsqjdM4NaswRR4XZc=;
        b=MYXKmDT72HV8Zlx5fpvcLGvvDVyka6XhWvPUBb/LYBDBiBA3VUXEnCQzl1id0YXh0k
         1ed1Y6//sCrdZy8wUFLy8RAx0zUVKR5XDyHSIJ5PeTQxb42/qEDnLw1sx8NfIc1SXUZ8
         HFoSMpiLVsG81nLfEXW9iMTSPPAWWfzgPyfZAHqwt2QRjz7PdM6FIlLOuGXaMA5Mp4oc
         hm9ERTvFx5uwyDHIvIgDLYP13EdqJJzqVoxJTy2NvEreX3z3FXkIljG25rlV1rgiX+T5
         +uChAv55KOvySvJTeRQEgKlaPHRWqRRkmZvodOXmMH+/efKAO5kMqGFzpRwr9M6W74C2
         YJyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681211570;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=v2nyzNZvTXnEQkp2ImwUNfiYpTnsqjdM4NaswRR4XZc=;
        b=jI4Ec5PqdXcwPjU55pDlEv9ZEq0HFeM0FmdTXYa6sSNtr2P+FZ9ieldBhq22ZWobCn
         dXDf/o1xvSc9X1psE0X8d68hcoVkVKxwdJ7MKquDtRpxoY7TeTQl8bqt9dszrM+MMgS1
         JWvxAlwbU6ASJvQJHc4wftkIMEdMQCflakCpdKoJ/d14d/cF/3H0k5BWOwwRZIDV2xB0
         RQzVdjvzRSXYtbSIjnGs08YjuUFP+IAfjxZ7TZfLnFTqQTvt89Ciochw61ApEizaO9sK
         k7mwsaja3prXfqTerv6dvSzkSHKBekooW2gFqCl1jyDDQImFFI0R9y2x8PJZ65UiGPH0
         ZDnA==
X-Gm-Message-State: AAQBX9e080rPQuwx6NP3BBD651Yb+1b2H9z+pGBMCkN9qHx4Rl02w5dC
        u1uOA/JD3xqA4oZ90EORoOqNFQTG9bg=
X-Google-Smtp-Source: AKy350ZjmHBG/7FeCp1miwYTojDewuMJ/KvcpmG5mBagmeLyBpyQdn1tabn9ZHiLAXozZ4MIN4hgGw==
X-Received: by 2002:a17:907:a40a:b0:93b:d1ee:5f41 with SMTP id sg10-20020a170907a40a00b0093bd1ee5f41mr7580025ejc.31.1681211570484;
        Tue, 11 Apr 2023 04:12:50 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::2:ddc3])
        by smtp.gmail.com with ESMTPSA id ww7-20020a170907084700b00947a40ded80sm6006787ejb.104.2023.04.11.04.12.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Apr 2023 04:12:50 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 7/8] io_uring/rsrc: refactor io_rsrc_node_switch
Date:   Tue, 11 Apr 2023 12:06:07 +0100
Message-Id: <d146fe306ff98b1a5a60c997c252534f03d423d7.1681210788.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <cover.1681210788.git.asml.silence@gmail.com>
References: <cover.1681210788.git.asml.silence@gmail.com>
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

We use io_rsrc_node_switch() coupled with io_rsrc_node_switch_start()
for a bunch of cases including initialising ctx->rsrc_node, i.e. by
passing NULL instead of rsrc_data. Leave it to only deal with actual
node changing.

For that, first remove it from io_uring_create() and add a function
allocating the first node. Then also remove all calls to
io_rsrc_node_switch() from files/buffers register as we already have a
node installed and it does essentially nothing.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c |  5 ++---
 io_uring/rsrc.c     | 36 +++++++++++-------------------------
 io_uring/rsrc.h     |  7 +++++++
 3 files changed, 20 insertions(+), 28 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 075bae8a2bb1..9083a8466ebf 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3881,11 +3881,10 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
 	ret = io_sq_offload_create(ctx, p);
 	if (ret)
 		goto err;
-	/* always set a rsrc node */
-	ret = io_rsrc_node_switch_start(ctx);
+
+	ret = io_rsrc_init(ctx);
 	if (ret)
 		goto err;
-	io_rsrc_node_switch(ctx, NULL);
 
 	memset(&p->sq_off, 0, sizeof(p->sq_off));
 	p->sq_off.head = offsetof(struct io_rings, sq.head);
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 329cc3851dfd..f2c660ffea74 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -204,7 +204,7 @@ void io_rsrc_node_ref_zero(struct io_rsrc_node *node)
 	}
 }
 
-static struct io_rsrc_node *io_rsrc_node_alloc(struct io_ring_ctx *ctx)
+struct io_rsrc_node *io_rsrc_node_alloc(struct io_ring_ctx *ctx)
 {
 	struct io_rsrc_node *ref_node;
 	struct io_cache_entry *entry;
@@ -231,23 +231,18 @@ void io_rsrc_node_switch(struct io_ring_ctx *ctx,
 			 struct io_rsrc_data *data_to_kill)
 	__must_hold(&ctx->uring_lock)
 {
-	WARN_ON_ONCE(io_alloc_cache_empty(&ctx->rsrc_node_cache));
-	WARN_ON_ONCE(data_to_kill && !ctx->rsrc_node);
+	struct io_rsrc_node *node = ctx->rsrc_node;
+	struct io_rsrc_node *backup = io_rsrc_node_alloc(ctx);
 
-	if (data_to_kill) {
-		struct io_rsrc_node *rsrc_node = ctx->rsrc_node;
-
-		rsrc_node->rsrc_data = data_to_kill;
-		list_add_tail(&rsrc_node->node, &ctx->rsrc_ref_list);
-
-		data_to_kill->refs++;
-		/* put master ref */
-		io_put_rsrc_node(ctx, rsrc_node);
-		ctx->rsrc_node = NULL;
-	}
+	if (WARN_ON_ONCE(!backup))
+		return;
 
-	if (!ctx->rsrc_node)
-		ctx->rsrc_node = io_rsrc_node_alloc(ctx);
+	data_to_kill->refs++;
+	node->rsrc_data = data_to_kill;
+	list_add_tail(&node->node, &ctx->rsrc_ref_list);
+	/* put master ref */
+	io_put_rsrc_node(ctx, node);
+	ctx->rsrc_node = backup;
 }
 
 int io_rsrc_node_switch_start(struct io_ring_ctx *ctx)
@@ -921,9 +916,6 @@ int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 		return -EMFILE;
 	if (nr_args > rlimit(RLIMIT_NOFILE))
 		return -EMFILE;
-	ret = io_rsrc_node_switch_start(ctx);
-	if (ret)
-		return ret;
 	ret = io_rsrc_data_alloc(ctx, io_rsrc_file_put, tags, nr_args,
 				 &ctx->file_data);
 	if (ret)
@@ -978,7 +970,6 @@ int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 
 	/* default it to the whole table */
 	io_file_table_set_alloc_range(ctx, 0, ctx->nr_user_files);
-	io_rsrc_node_switch(ctx, NULL);
 	return 0;
 fail:
 	__io_sqe_files_unregister(ctx);
@@ -1260,9 +1251,6 @@ int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
 		return -EBUSY;
 	if (!nr_args || nr_args > IORING_MAX_REG_BUFFERS)
 		return -EINVAL;
-	ret = io_rsrc_node_switch_start(ctx);
-	if (ret)
-		return ret;
 	ret = io_rsrc_data_alloc(ctx, io_rsrc_buf_put, tags, nr_args, &data);
 	if (ret)
 		return ret;
@@ -1300,8 +1288,6 @@ int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
 	ctx->buf_data = data;
 	if (ret)
 		__io_sqe_buffers_unregister(ctx);
-	else
-		io_rsrc_node_switch(ctx, NULL);
 	return ret;
 }
 
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index 8729f2fee256..17dfe180208f 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -74,6 +74,7 @@ void io_rsrc_put_work(struct work_struct *work);
 void io_wait_rsrc_data(struct io_rsrc_data *data);
 void io_rsrc_node_destroy(struct io_ring_ctx *ctx, struct io_rsrc_node *ref_node);
 int io_rsrc_node_switch_start(struct io_ring_ctx *ctx);
+struct io_rsrc_node *io_rsrc_node_alloc(struct io_ring_ctx *ctx);
 int io_queue_rsrc_removal(struct io_rsrc_data *data, unsigned idx,
 			  struct io_rsrc_node *node, void *rsrc);
 void io_rsrc_node_switch(struct io_ring_ctx *ctx,
@@ -164,6 +165,12 @@ static inline u64 *io_get_tag_slot(struct io_rsrc_data *data, unsigned int idx)
 	return &data->tags[table_idx][off];
 }
 
+static inline int io_rsrc_init(struct io_ring_ctx *ctx)
+{
+	ctx->rsrc_node = io_rsrc_node_alloc(ctx);
+	return ctx->rsrc_node ? 0 : -ENOMEM;
+}
+
 int io_files_update(struct io_kiocb *req, unsigned int issue_flags);
 int io_files_update_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 
-- 
2.40.0

