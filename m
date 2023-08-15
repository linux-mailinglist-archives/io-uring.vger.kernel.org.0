Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E65D77D128
	for <lists+io-uring@lfdr.de>; Tue, 15 Aug 2023 19:34:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238911AbjHORdh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Aug 2023 13:33:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238929AbjHORdX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Aug 2023 13:33:23 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF7A210EC
        for <io-uring@vger.kernel.org>; Tue, 15 Aug 2023 10:33:22 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id a640c23a62f3a-99d6d5054bcso1075506366b.1
        for <io-uring@vger.kernel.org>; Tue, 15 Aug 2023 10:33:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692120801; x=1692725601;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m7df/JEGcQenNIMU2iBP11PVrs8ARCZ4IRK79yJbYn8=;
        b=OntxgMfOab9T8cCKnXI6DNZ+JS2nHJLrw8qdT6tomvOxWciklAmZMbvjkRxr9fzAFs
         y+JX9E3bc2qagb74TGT2pnTOAuTuIIo7lz0Wfno96teyWrzz5cedm6XXFeW0l26tZUhY
         M3j4FUYE1/B5OTVR0L8EmapMs5di7CCbJy9ihMlJg6akq9gq90jj6zz8PE/H+SIV7vVb
         eQT9f0muhy8NA4QWAlGPZiniUB9JaTETZepcL7HScfXjlHM2lgf5hLDZ7tchCiNPpLwf
         ywVZZaL7WtvI6N4PbS4/sFCNEjuIZKqYZSu+mZjGI5ByNxaAHX9rAWwHUlN8XPjMOPyh
         G7Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692120801; x=1692725601;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=m7df/JEGcQenNIMU2iBP11PVrs8ARCZ4IRK79yJbYn8=;
        b=A8BYoKJhX7q/QYykupsSWR8iTjfP0m+vuMCTlyOop8vwpKAM7zDZg6Lj7QcK/kFrqM
         u8xZ57k52UGaIHcAsWXWR+2m2ZKUho0FpTgSbVkyZ867WDih9RKcBW30bcTXhtb9ZTdc
         89R/bzKwzePyQt3dOjEKSG4/prZu8vxkW1pkGac2PPwfFJ2FoZEHvesbnfPV9DrpCzWU
         IV8XZrPpc3S+K/M0ctRryi39ZivH/mzlk8HsAXgI1JEd+cATqsLePkzHhOyF1gkthEND
         V7BsTTNnb2XlWkLgPFXF+KgWxoUa+H4ZUS/GmdWcF+RLfRkwAmk9EuaUX53XwUJVBeoO
         1DOA==
X-Gm-Message-State: AOJu0YwIVLOJzIN/M9kDNCxF1IR1eGdTRQvSSNN82Kt+HsH3FDVmZZio
        aSqgjdKLHy7Snvlq5EVoD+kbst03qn4=
X-Google-Smtp-Source: AGHT+IG+WjlTYocLVvigMd90N5ap6Qa6sJK3aTaWc6YGS+Z4ZCE5ZlTFAIKsrmCngV+mp2J9RTTF2g==
X-Received: by 2002:a17:907:6e0d:b0:988:8efc:54fa with SMTP id sd13-20020a1709076e0d00b009888efc54famr2594795ejc.37.1692120801118;
        Tue, 15 Aug 2023 10:33:21 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::2:6d35])
        by smtp.gmail.com with ESMTPSA id kk9-20020a170907766900b0099cc36c4681sm7269878ejc.157.2023.08.15.10.33.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Aug 2023 10:33:20 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 10/16] io_uring: static_key for !IORING_SETUP_NO_SQARRAY
Date:   Tue, 15 Aug 2023 18:31:39 +0100
Message-ID: <9c166012c57091af1c23fdc33594e7197c43d66e.1692119257.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1692119257.git.asml.silence@gmail.com>
References: <cover.1692119257.git.asml.silence@gmail.com>
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

At some point IORING_SETUP_NO_SQARRAY should become the default, so add
a static_key to optimise out the chunk of io_get_sqe() dealing with
sq_arrays.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index ac6d1687ba6c..c39606740c73 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -72,6 +72,7 @@
 #include <linux/io_uring.h>
 #include <linux/audit.h>
 #include <linux/security.h>
+#include <linux/jump_label.h>
 #include <asm/shmparam.h>
 
 #define CREATE_TRACE_POINTS
@@ -148,6 +149,8 @@ static bool io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 
 static void io_queue_sqe(struct io_kiocb *req);
 
+static __read_mostly DEFINE_STATIC_KEY_FALSE(io_key_has_sqarray);
+
 struct kmem_cache *req_cachep;
 
 struct sock *io_uring_get_socket(struct file *file)
@@ -2342,7 +2345,8 @@ static bool io_get_sqe(struct io_ring_ctx *ctx, const struct io_uring_sqe **sqe)
 	unsigned mask = ctx->sq_entries - 1;
 	unsigned head = ctx->cached_sq_head++ & mask;
 
-	if (!(ctx->flags & IORING_SETUP_NO_SQARRAY)) {
+	if (static_branch_unlikely(&io_key_has_sqarray) &&
+	    (!(ctx->flags & IORING_SETUP_NO_SQARRAY))) {
 		head = READ_ONCE(ctx->sq_array[head]);
 		if (unlikely(head >= ctx->sq_entries)) {
 			/* drop invalid entries */
@@ -2871,6 +2875,9 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 #endif
 	WARN_ON_ONCE(!list_empty(&ctx->ltimeout_list));
 
+	if (!(ctx->flags & IORING_SETUP_NO_SQARRAY))
+		static_branch_dec(&io_key_has_sqarray);
+
 	io_alloc_cache_free(&ctx->rsrc_node_cache, io_rsrc_node_cache_free);
 	if (ctx->mm_account) {
 		mmdrop(ctx->mm_account);
@@ -3844,6 +3851,9 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
 	if (!ctx)
 		return -ENOMEM;
 
+	if (!(ctx->flags & IORING_SETUP_NO_SQARRAY))
+		static_branch_inc(&io_key_has_sqarray);
+
 	if ((ctx->flags & IORING_SETUP_DEFER_TASKRUN) &&
 	    !(ctx->flags & IORING_SETUP_IOPOLL) &&
 	    !(ctx->flags & IORING_SETUP_SQPOLL))
-- 
2.41.0

