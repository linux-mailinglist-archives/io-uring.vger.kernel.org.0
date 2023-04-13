Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65B926E1003
	for <lists+io-uring@lfdr.de>; Thu, 13 Apr 2023 16:29:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231598AbjDMO3G (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 13 Apr 2023 10:29:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231534AbjDMO3E (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 13 Apr 2023 10:29:04 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AFF2A5FE
        for <io-uring@vger.kernel.org>; Thu, 13 Apr 2023 07:29:01 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id v14-20020a05600c470e00b003f06520825fso13758428wmo.0
        for <io-uring@vger.kernel.org>; Thu, 13 Apr 2023 07:29:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681396139; x=1683988139;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cLniZvPHknjJJS9uxbnHH/hJ2WCLueA+3HT9X9D00zQ=;
        b=s3HeHlyZscqOuVHDisW3K+R6v5Urk3fnFMZs8ePtVXyu/aKTDA4ZLKDXnV2U1AH6a+
         6AuJ2jHfARioE+r06U/USnsmDTQyNmjvQ7kUM+CS+zlAdBHsfOD8thWIORr0Lfpxcdz6
         RRjlj8LY8F7JDLs8bCP/IJ5Aq9/ea7Y3rMSO4K0oFGxHVghLw3umwRYbAUiVMFwULmLC
         nC1qq5WgZLvJdkwf19bKRyIXxYy7Qf5jVc7JkPkFX7M9np8Ju9Kv5WTTYpduwD74LCS9
         iplWUe8RHL7MNAjRAM2tQb8aH7ijTdhlDvcVxTdbQ1Zq8EiI+lx9d6DD88SXPRqHWARh
         T0oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681396139; x=1683988139;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cLniZvPHknjJJS9uxbnHH/hJ2WCLueA+3HT9X9D00zQ=;
        b=bKJlbeaRueNkN7hKWDKKAkAB/buYEgEYjsPHUvF2CwrLuqfCIddcdI4BodLwhXo2A1
         ysXt6W7wmdpihhWeHZzuup0S4UoOBNH1mezGXshm+NCqyViOJXkmLgnwzauPYwW+aQlW
         1ys5Y57ZIr+X89F0HcV3mVHXAU8DulzUSv+j/cTiXZKVN1mmboGd2zBdwinGpo/Fd237
         0m0k5b4A3qHO+nrjr4y/CTnDqP9ose0toKWgbOSNpdVgIym40kUv/dxGq1QjMLUFTkWO
         FFobCbwy1rzRfVuqvOh4Ml2zujU98dBiI91HvYRwkEA5UrCKawMgETn5uaZYb7P0hABA
         c+0Q==
X-Gm-Message-State: AAQBX9dU/8ZrddM3Qi1xDGx2H8xcVjKPhJQDnitC6IClKjDxmwmFd4v/
        Uqu0Yqd+6qUSMrXIXCX+gJ/KvQbJR/E=
X-Google-Smtp-Source: AKy350YxdDgCOgdYcRRwxSJt+8SduCXwrSkwaxFyKnP+E4UCxZPXskdvfElr62mN3Zx1ewqqfr6i9Q==
X-Received: by 2002:a7b:cc93:0:b0:3ed:9212:b4fe with SMTP id p19-20020a7bcc93000000b003ed9212b4femr2097446wma.0.1681396139389;
        Thu, 13 Apr 2023 07:28:59 -0700 (PDT)
Received: from 127.0.0.1localhost (94.196.97.186.threembb.co.uk. [94.196.97.186])
        by smtp.gmail.com with ESMTPSA id z14-20020adff1ce000000b002f28de9f73bsm1387391wro.55.2023.04.13.07.28.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Apr 2023 07:28:59 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 07/10] io_uring/rsrc: inline switch_start fast path
Date:   Thu, 13 Apr 2023 15:28:11 +0100
Message-Id: <9619c1717a0e01f22c5fce2f1ba2735f804da0f2.1681395792.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <cover.1681395792.git.asml.silence@gmail.com>
References: <cover.1681395792.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Inline the part of io_rsrc_node_switch_start() that checks whether the
cache is empty or not, as most of the times it will have some number of
entries in there.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rsrc.c | 12 +++++-------
 io_uring/rsrc.h |  9 ++++++++-
 2 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 5415a18844e0..bfa0b382c6c6 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -230,15 +230,13 @@ void io_rsrc_node_switch(struct io_ring_ctx *ctx,
 	ctx->rsrc_node = backup;
 }
 
-int io_rsrc_node_switch_start(struct io_ring_ctx *ctx)
+int __io_rsrc_node_switch_start(struct io_ring_ctx *ctx)
 {
-	if (io_alloc_cache_empty(&ctx->rsrc_node_cache)) {
-		struct io_rsrc_node *node = kzalloc(sizeof(*node), GFP_KERNEL);
+	struct io_rsrc_node *node = kzalloc(sizeof(*node), GFP_KERNEL);
 
-		if (!node)
-			return -ENOMEM;
-		io_alloc_cache_put(&ctx->rsrc_node_cache, &node->cache);
-	}
+	if (!node)
+		return -ENOMEM;
+	io_alloc_cache_put(&ctx->rsrc_node_cache, &node->cache);
 	return 0;
 }
 
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index 5dd2fcb28069..732496afed4c 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -69,7 +69,7 @@ void io_rsrc_put_tw(struct callback_head *cb);
 void io_rsrc_node_ref_zero(struct io_rsrc_node *node);
 void io_rsrc_put_work(struct work_struct *work);
 void io_rsrc_node_destroy(struct io_ring_ctx *ctx, struct io_rsrc_node *ref_node);
-int io_rsrc_node_switch_start(struct io_ring_ctx *ctx);
+int __io_rsrc_node_switch_start(struct io_ring_ctx *ctx);
 struct io_rsrc_node *io_rsrc_node_alloc(struct io_ring_ctx *ctx);
 int io_queue_rsrc_removal(struct io_rsrc_data *data, unsigned idx,
 			  struct io_rsrc_node *node, void *rsrc);
@@ -111,6 +111,13 @@ static inline int io_scm_file_account(struct io_ring_ctx *ctx,
 	return __io_scm_file_account(ctx, file);
 }
 
+static inline int io_rsrc_node_switch_start(struct io_ring_ctx *ctx)
+{
+	if (unlikely(io_alloc_cache_empty(&ctx->rsrc_node_cache)))
+		return __io_rsrc_node_switch_start(ctx);
+	return 0;
+}
+
 int io_register_files_update(struct io_ring_ctx *ctx, void __user *arg,
 			     unsigned nr_args);
 int io_register_rsrc_update(struct io_ring_ctx *ctx, void __user *arg,
-- 
2.40.0

