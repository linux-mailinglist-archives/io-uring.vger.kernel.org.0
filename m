Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EAA567224F
	for <lists+io-uring@lfdr.de>; Wed, 18 Jan 2023 17:01:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230149AbjARQBc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 Jan 2023 11:01:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231256AbjARP7y (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 Jan 2023 10:59:54 -0500
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80C9054B07;
        Wed, 18 Jan 2023 07:56:42 -0800 (PST)
Received: by mail-ej1-f54.google.com with SMTP id ud5so84375683ejc.4;
        Wed, 18 Jan 2023 07:56:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kpirYHngnT4pnfeId8PwGYCJd6AYwIUHThaVH7Hubp4=;
        b=7T8YUUT4iRiPOjpbmsSSqfUMovJ41quEMrCAEwyFYNoZWH9nF4Ql3dD3b4vFhpB6Yw
         vrnct3W+QU9Cucdx34rP8VdsfiWwjJs0+oVNIDSPVVhXBPDjpB+HxEkPDx1FPOqL6iSG
         mulwwYFhXDYqZauKSb5UpvGCvL9bqqwmrd9b0pebgEJtPlE5W0FnFFQR9zPqFOgmq0Mi
         1DgxRGWiFuktg3X6sD0HAWELM9hCIvP3mWI49PsjE6QrePLYweIHBERIyef/VCjJtXLV
         z77ZXZtHSgySwCaOVnrqoMe6HXVNDzVruAumUxCCuZKHO/yPwe7yHiBTwfsonhf4NweK
         d2ZA==
X-Gm-Message-State: AFqh2kqChRMN0ZK8rcJ45UUJwaAAW7vSQMb410493XEYxXYHYqgn4qWA
        yOIS0dk73Zqz4T/8wmTagio=
X-Google-Smtp-Source: AMrXdXtr40LzqXP8+RQaUuAxxO44Xk05rql9rcrJEQ3/EUo+edYvelcfQ5ygO11ZQgMVz99c2FljdA==
X-Received: by 2002:a17:907:c388:b0:86e:65c8:6fe3 with SMTP id tm8-20020a170907c38800b0086e65c86fe3mr8253919ejc.7.1674057401112;
        Wed, 18 Jan 2023 07:56:41 -0800 (PST)
Received: from localhost (fwdproxy-cln-120.fbsv.net. [2a03:2880:31ff:78::face:b00c])
        by smtp.gmail.com with ESMTPSA id gw21-20020a170906f15500b0086dc9e05685sm5621406ejb.222.2023.01.18.07.56.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 07:56:40 -0800 (PST)
From:   Breno Leitao <leitao@debian.org>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org
Cc:     kasan-dev@googlegroups.com, leitao@debian.org, leit@fb.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] io_uring: Enable KASAN for request cache
Date:   Wed, 18 Jan 2023 07:56:30 -0800
Message-Id: <20230118155630.2762921-1-leitao@debian.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Every io_uring request is represented by struct io_kiocb, which is
cached locally by io_uring (not SLAB/SLUB) in the list called
submit_state.freelist. This patch simply enabled KASAN for this free
list.

This list is initially created by KMEM_CACHE, but later, managed by
io_uring. This patch basically poisons the objects that are not used
(i.e., they are the free list), and unpoisons it when the object is
allocated/removed from the list.

Touching these poisoned objects while in the freelist will cause a KASAN
warning.

Suggested-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 io_uring/io_uring.c |  3 ++-
 io_uring/io_uring.h | 11 ++++++++---
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 2ac1cd8d23ea..8cc0f12034d1 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -151,7 +151,7 @@ static void io_move_task_work_from_local(struct io_ring_ctx *ctx);
 static void __io_submit_flush_completions(struct io_ring_ctx *ctx);
 static __cold void io_fallback_tw(struct io_uring_task *tctx);
 
-static struct kmem_cache *req_cachep;
+struct kmem_cache *req_cachep;
 
 struct sock *io_uring_get_socket(struct file *file)
 {
@@ -230,6 +230,7 @@ static inline void req_fail_link_node(struct io_kiocb *req, int res)
 static inline void io_req_add_to_cache(struct io_kiocb *req, struct io_ring_ctx *ctx)
 {
 	wq_stack_add_head(&req->comp_list, &ctx->submit_state.free_list);
+	kasan_poison_object_data(req_cachep, req);
 }
 
 static __cold void io_ring_ctx_ref_free(struct percpu_ref *ref)
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index ab4b2a1c3b7e..0ccf62a19b65 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -3,6 +3,7 @@
 
 #include <linux/errno.h>
 #include <linux/lockdep.h>
+#include <linux/kasan.h>
 #include <linux/io_uring_types.h>
 #include <uapi/linux/eventpoll.h>
 #include "io-wq.h"
@@ -379,12 +380,16 @@ static inline bool io_alloc_req_refill(struct io_ring_ctx *ctx)
 	return true;
 }
 
+extern struct kmem_cache *req_cachep;
+
 static inline struct io_kiocb *io_alloc_req(struct io_ring_ctx *ctx)
 {
-	struct io_wq_work_node *node;
+	struct io_kiocb *req;
 
-	node = wq_stack_extract(&ctx->submit_state.free_list);
-	return container_of(node, struct io_kiocb, comp_list);
+	req = container_of(ctx->submit_state.free_list.next, struct io_kiocb, comp_list);
+	kasan_unpoison_object_data(req_cachep, req);
+	wq_stack_extract(&ctx->submit_state.free_list);
+	return req;
 }
 
 static inline bool io_allowed_run_tw(struct io_ring_ctx *ctx)
-- 
2.30.2

