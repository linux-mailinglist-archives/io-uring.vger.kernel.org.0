Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AB646E6566
	for <lists+io-uring@lfdr.de>; Tue, 18 Apr 2023 15:07:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231639AbjDRNH3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 18 Apr 2023 09:07:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231578AbjDRNHX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 Apr 2023 09:07:23 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3014746A0
        for <io-uring@vger.kernel.org>; Tue, 18 Apr 2023 06:07:14 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id dx24so28990194ejb.11
        for <io-uring@vger.kernel.org>; Tue, 18 Apr 2023 06:07:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681823232; x=1684415232;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4vBbSPgsInYAGzgfWYoncvwz5lmk4919w53t/DC+ol4=;
        b=TvwqcbxB4Qe4yt369SXa2wmA9bvXPD2lEf3N/Wc83Go6ih66MWzqtKxTLUvuUZ6z58
         j82UYIClQqcBsxpaREYEMmNt4RcmlpmeZN1r6yzvshdeGPobkIFxSkRHXwS4DsiCFUK9
         mECNf5QDJ7oba/Ts4SXZ2doinCBhFWjBVDPVvud7QdX8izI2hf41QlMmrgnRsSpJBBQJ
         r8cVh0/EhyZmnvHT34fS6TbGAzgOcu0cBgOQi1diOVdWnAgUN8bTiwbav6LJs7hWDm7e
         f6bBpm18h0CQcjbnIf06LxUYjK1Z05pMU87wwSoxvWQgNY3iYMo8DjBSYQ9D9hvFU4BO
         +V6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681823232; x=1684415232;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4vBbSPgsInYAGzgfWYoncvwz5lmk4919w53t/DC+ol4=;
        b=dNIF4BZbgNL+bYx7HUT30A0+wSYy7WERNmcLy9Kx90i7pbQWBC/DwQiPe2ESlUrY42
         2FutA8Lx+psbu/hkqSW4idRl1/2/wuJB5cEu0n07IAuArsV6c9CH6HUvF4pvyhNHefIf
         S7b2PL4WUKfeoISfNiQg14HLmjC69IHHKLMF+1BMP0BcpRDRucf3cvcZHu8xcoWMOilM
         xxssAlXIWY7znHfivVcAd8+Vca5nbkh+7igLKvKxmO7CbozpgUFVSuD8tM+Djbv5iVYF
         VNkhUUJ5/6IRlqen50mK8f1zr2nYoE3HhpQV8IQnPXfJQlTXwmCic7aNvsq7C4xT4hhu
         B6Ng==
X-Gm-Message-State: AAQBX9fe+TETT3LDsQrQ1MZ7LEYtbyz1dW0HihoZm0pz3V/lCuGOyM1s
        8SHrj8fep7oWm2TI13yXGzUq2hFwRrw=
X-Google-Smtp-Source: AKy350Y0AIoFPe1Gf7XuOUZwKpXXhRupnRXoc3p3HYPuYRcM9asyIlqjaOZS+Y+Uwq5JgL2tqvgVhg==
X-Received: by 2002:a17:906:11d2:b0:932:e9c7:c32 with SMTP id o18-20020a17090611d200b00932e9c70c32mr12582013eja.59.1681823232336;
        Tue, 18 Apr 2023 06:07:12 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::2:cfa6])
        by smtp.gmail.com with ESMTPSA id o26-20020a1709061d5a00b0094e44899367sm7924919ejh.101.2023.04.18.06.07.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 06:07:12 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 8/8] io_uring/rsrc: disassociate nodes and rsrc_data
Date:   Tue, 18 Apr 2023 14:06:41 +0100
Message-Id: <4f259abe9cd4eea6a3b4ed83508635218acd3c3f.1681822823.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <cover.1681822823.git.asml.silence@gmail.com>
References: <cover.1681822823.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Make rsrc nodes independent from rsrd_data, for that we keep ctx and
rsrc type in nodes.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rsrc.c | 20 +++++++++-----------
 io_uring/rsrc.h |  3 ++-
 2 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 62988b3aa927..20dcc7668cb0 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -144,18 +144,17 @@ static void io_buffer_unmap(struct io_ring_ctx *ctx, struct io_mapped_ubuf **slo
 
 static void io_rsrc_put_work(struct io_rsrc_node *node)
 {
-	struct io_rsrc_data *data = node->rsrc_data;
 	struct io_rsrc_put *prsrc = &node->item;
 
 	if (prsrc->tag)
-		io_post_aux_cqe(data->ctx, prsrc->tag, 0, 0);
+		io_post_aux_cqe(node->ctx, prsrc->tag, 0, 0);
 
-	switch (data->rsrc_type) {
+	switch (node->type) {
 	case IORING_RSRC_FILE:
-		io_rsrc_file_put(data->ctx, prsrc);
+		io_rsrc_file_put(node->ctx, prsrc);
 		break;
 	case IORING_RSRC_BUFFER:
-		io_rsrc_buf_put(data->ctx, prsrc);
+		io_rsrc_buf_put(node->ctx, prsrc);
 		break;
 	default:
 		WARN_ON_ONCE(1);
@@ -170,9 +169,9 @@ void io_rsrc_node_destroy(struct io_ring_ctx *ctx, struct io_rsrc_node *node)
 }
 
 void io_rsrc_node_ref_zero(struct io_rsrc_node *node)
-	__must_hold(&node->rsrc_data->ctx->uring_lock)
+	__must_hold(&node->ctx->uring_lock)
 {
-	struct io_ring_ctx *ctx = node->rsrc_data->ctx;
+	struct io_ring_ctx *ctx = node->ctx;
 
 	while (!list_empty(&ctx->rsrc_ref_list)) {
 		node = list_first_entry(&ctx->rsrc_ref_list,
@@ -204,7 +203,7 @@ struct io_rsrc_node *io_rsrc_node_alloc(struct io_ring_ctx *ctx)
 			return NULL;
 	}
 
-	ref_node->rsrc_data = NULL;
+	ref_node->ctx = ctx;
 	ref_node->empty = 0;
 	ref_node->refs = 1;
 	return ref_node;
@@ -225,7 +224,7 @@ __cold static int io_rsrc_ref_quiesce(struct io_rsrc_data *data,
 	if (!backup)
 		return -ENOMEM;
 	ctx->rsrc_node->empty = true;
-	ctx->rsrc_node->rsrc_data = data;
+	ctx->rsrc_node->type = -1;
 	list_add_tail(&ctx->rsrc_node->node, &ctx->rsrc_ref_list);
 	io_put_rsrc_node(ctx, ctx->rsrc_node);
 	ctx->rsrc_node = backup;
@@ -655,10 +654,9 @@ int io_queue_rsrc_removal(struct io_rsrc_data *data, unsigned idx, void *rsrc)
 	}
 
 	node->item.rsrc = rsrc;
+	node->type = data->rsrc_type;
 	node->item.tag = *tag_slot;
 	*tag_slot = 0;
-
-	node->rsrc_data = data;
 	list_add_tail(&node->node, &ctx->rsrc_ref_list);
 	io_put_rsrc_node(ctx, node);
 	return 0;
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index 5d0733c4c08d..0a8a95e9b99e 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -40,10 +40,11 @@ struct io_rsrc_data {
 struct io_rsrc_node {
 	union {
 		struct io_cache_entry		cache;
-		struct io_rsrc_data		*rsrc_data;
+		struct io_ring_ctx		*ctx;
 	};
 	int				refs;
 	bool				empty;
+	u16				type;
 	struct list_head		node;
 	struct io_rsrc_put		item;
 };
-- 
2.40.0

