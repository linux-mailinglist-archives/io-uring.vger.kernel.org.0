Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C79AB6DD91B
	for <lists+io-uring@lfdr.de>; Tue, 11 Apr 2023 13:13:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230085AbjDKLNR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 11 Apr 2023 07:13:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230075AbjDKLNE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 11 Apr 2023 07:13:04 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F78449E2
        for <io-uring@vger.kernel.org>; Tue, 11 Apr 2023 04:12:51 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id gb34so19514933ejc.12
        for <io-uring@vger.kernel.org>; Tue, 11 Apr 2023 04:12:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1681211569;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kXgohyCesDlyu8oDu5W3HIHKYO+1vXlCQPIxUEcV8ek=;
        b=kUBM1qRhCLGRVuhBh61FeTuTBI5/oPG7h/BPPrtY3vxArHb00u1FnSZQZxeVCJxXG1
         2mpZ09/FlKiFEXcvWsaqlNF12tBvShNVTCGICuEbyfOKMzTpk6POjg/hK4iwDhB8jdNF
         nPcbnTpLOMUmqRvlVmKeIWCwLbOL5XqzH2dLS61i3dul7HEsIhh7n/znj0jUJRglS3c0
         4VV5r/vRcVIN3ZvZYM33QI804Zqc3nl71qC3/v0CETlnf3u8LjNj7N8CQG84JhYC0Vve
         Ug67O0BdkF7+SuXvdXJ3Ld8JaVWB6+NV5DqmFhxS6gspXypXkIhCHEIKM8oW55MfuW+d
         pbYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681211569;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kXgohyCesDlyu8oDu5W3HIHKYO+1vXlCQPIxUEcV8ek=;
        b=0c4KcIWltsqegyVc54vmqMRyz8Lt2SI52GoP3WFASxBVlgY93YW1f17LAuBbTdFwzz
         AVC+wwHV73B2RV9nbSlsi+wLOZIQWr/m2aFqbNurd2+zUzclFitAG5tHnEYoP5l7/tWp
         nl1qEd6DsOZVmORTHVnyu4hBu27K3v3mnQrg+gOgl6wygCXb2eqSgsdFt2o3ew1FKg7z
         VtNkKWvdBX1aRtt9zWGRI0JjeMhrdvaurJIAbRg8g57xyWhi8cAtxjJAy8mRrg/ih34k
         3v/dnFuokh1mX3pdXm7FyAoQgwkuPJYAONzpfKKxfro9pFJnlFvUaplaS5exnqRVAMoD
         bmEw==
X-Gm-Message-State: AAQBX9eXkdO65HxftnuFuvb3DwuSA67LnBhFJA/GQOiKYsVmMnLhYvvc
        1as/z13JIprAY6ZYJdKdsUwH7sIzMvs=
X-Google-Smtp-Source: AKy350a2LrCR42SrWYOUm6byTTDIxC6aHp6dnyxGYWZWTh1AY4y8OehqU47lYu/x8nEnpftQE7c3KQ==
X-Received: by 2002:a17:906:3710:b0:94a:62e7:70e1 with SMTP id d16-20020a170906371000b0094a62e770e1mr6619267ejc.68.1681211569615;
        Tue, 11 Apr 2023 04:12:49 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::2:ddc3])
        by smtp.gmail.com with ESMTPSA id ww7-20020a170907084700b00947a40ded80sm6006787ejb.104.2023.04.11.04.12.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Apr 2023 04:12:49 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 5/8] io_uring/rsrc: consolidate node caching
Date:   Tue, 11 Apr 2023 12:06:05 +0100
Message-Id: <6d5410e51ccd29be7a716be045b51d6b371baef6.1681210788.git.asml.silence@gmail.com>
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

We store one pre-allocated rsrc node in ->rsrc_backup_node, merge it
with ->rsrc_node_cache.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring_types.h |  1 -
 io_uring/alloc_cache.h         |  5 +++++
 io_uring/io_uring.c            |  2 --
 io_uring/rsrc.c                | 20 +++++++++++---------
 4 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index fa621a508a01..40cab420b1bd 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -326,7 +326,6 @@ struct io_ring_ctx {
 	struct io_restriction		restrictions;
 
 	/* slow path rsrc auxilary data, used by update/register */
-	struct io_rsrc_node		*rsrc_backup_node;
 	struct io_mapped_ubuf		*dummy_ubuf;
 	struct io_rsrc_data		*file_data;
 	struct io_rsrc_data		*buf_data;
diff --git a/io_uring/alloc_cache.h b/io_uring/alloc_cache.h
index 851a527afb5e..241245cb54a6 100644
--- a/io_uring/alloc_cache.h
+++ b/io_uring/alloc_cache.h
@@ -23,6 +23,11 @@ static inline bool io_alloc_cache_put(struct io_alloc_cache *cache,
 	return false;
 }
 
+static inline bool io_alloc_cache_empty(struct io_alloc_cache *cache)
+{
+	return !cache->list.next;
+}
+
 static inline struct io_cache_entry *io_alloc_cache_get(struct io_alloc_cache *cache)
 {
 	if (cache->list.next) {
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index b171c26d331d..075bae8a2bb1 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2852,8 +2852,6 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	/* there are no registered resources left, nobody uses it */
 	if (ctx->rsrc_node)
 		io_rsrc_node_destroy(ctx, ctx->rsrc_node);
-	if (ctx->rsrc_backup_node)
-		io_rsrc_node_destroy(ctx, ctx->rsrc_backup_node);
 
 	WARN_ON_ONCE(!list_empty(&ctx->rsrc_ref_list));
 
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 24e4e2109549..73f9e10d9bf0 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -230,7 +230,7 @@ void io_rsrc_node_switch(struct io_ring_ctx *ctx,
 			 struct io_rsrc_data *data_to_kill)
 	__must_hold(&ctx->uring_lock)
 {
-	WARN_ON_ONCE(!ctx->rsrc_backup_node);
+	WARN_ON_ONCE(io_alloc_cache_empty(&ctx->rsrc_node_cache));
 	WARN_ON_ONCE(data_to_kill && !ctx->rsrc_node);
 
 	if (data_to_kill) {
@@ -245,18 +245,20 @@ void io_rsrc_node_switch(struct io_ring_ctx *ctx,
 		ctx->rsrc_node = NULL;
 	}
 
-	if (!ctx->rsrc_node) {
-		ctx->rsrc_node = ctx->rsrc_backup_node;
-		ctx->rsrc_backup_node = NULL;
-	}
+	if (!ctx->rsrc_node)
+		ctx->rsrc_node = io_rsrc_node_alloc(ctx);
 }
 
 int io_rsrc_node_switch_start(struct io_ring_ctx *ctx)
 {
-	if (ctx->rsrc_backup_node)
-		return 0;
-	ctx->rsrc_backup_node = io_rsrc_node_alloc(ctx);
-	return ctx->rsrc_backup_node ? 0 : -ENOMEM;
+	if (io_alloc_cache_empty(&ctx->rsrc_node_cache)) {
+		struct io_rsrc_node *node = kzalloc(sizeof(*node), GFP_KERNEL);
+
+		if (!node)
+			return -ENOMEM;
+		io_alloc_cache_put(&ctx->rsrc_node_cache, &node->cache);
+	}
+	return 0;
 }
 
 __cold static int io_rsrc_ref_quiesce(struct io_rsrc_data *data,
-- 
2.40.0

