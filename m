Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F5F9635BD4
	for <lists+io-uring@lfdr.de>; Wed, 23 Nov 2022 12:35:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237343AbiKWLfO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Nov 2022 06:35:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237328AbiKWLfH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Nov 2022 06:35:07 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA54511DA39
        for <io-uring@vger.kernel.org>; Wed, 23 Nov 2022 03:35:06 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id v1so28901794wrt.11
        for <io-uring@vger.kernel.org>; Wed, 23 Nov 2022 03:35:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y2QNLJ4mI8t02sLnWQNBMUUxoLK3U5B8jMH3lwt4n7E=;
        b=CEckmgPu6l+Jm0qGjxTpnktWEEcltPKgEoqQ+IOEcqbAnBg4EC/dWdrM/mo8KEzy5q
         Wc2vDAPFEdICRQmNMANIQodgQQYcSLnwJC3h82iJiuu28UIAjTEEQTDR6AUaND44565X
         2CcuPsBkZnhQttr5q1o6dbAS8VU7cqkfy3YgVV6ohI9JrAXrOeLTbZDxYq+CWYFZvMwT
         lq1obhccybh15k8cDrY5RVtvzcpLEuCFYfT1R4edVnR6FSwn+jUHh+/1dFGOC3D2qfjW
         eacqNpgUjXipGyXevdJeMVSJkCVj03xM4KzBT2/YV/B5KOZd/5ucxQujswBwOL3oJjt4
         FCsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y2QNLJ4mI8t02sLnWQNBMUUxoLK3U5B8jMH3lwt4n7E=;
        b=b3VTN/GrujeiDySVztlUFrninFlvVCf+709c9oNtYg6+9VAiLkXrvf2V8KuLTveyUv
         0kgF8l7Cc3mh4MuC4KirR/6szxL4dBj8jxmOBEWfCtPzceMhm03CYZzwvJfmjpDUkAox
         gXAf9z7+D/t6UicGsOvgBnlL1YRkoU5+3otzPbJKrU0CBnZrlifinBMs1Pe5LXxYCseJ
         p3XGLubBMD/Y1uFbfB8Wi7Xht9Ubbj3geZlfIyfq75+0ua8VGXRel6fCxENRqB8pTFsJ
         zWQbaRd49HPJXaUvW35xHk1myaf7+CPHLp3gZxLwXsaSfs5KHgZQa0HP3COluxYjLxVz
         G6sQ==
X-Gm-Message-State: ANoB5pmPUEjdBMYrsZLezMDH2+xqdFalIAKPWtYzHoJHnW8Om492FlpL
        gYflH9AJ4t9A01u+gfnhKzuKHuE+4Nc=
X-Google-Smtp-Source: AA0mqf53qiz+xgRHFGqvcAAChvpHXUktJOKvcCL8fbKt6N1CJ5Ecazwsfjt9iwGdOe0W9nSs7maR0w==
X-Received: by 2002:adf:dc86:0:b0:236:754e:f8b4 with SMTP id r6-20020adfdc86000000b00236754ef8b4mr16801670wrj.478.1669203305213;
        Wed, 23 Nov 2022 03:35:05 -0800 (PST)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:e1b])
        by smtp.gmail.com with ESMTPSA id g9-20020a05600c4ec900b003cfd58409desm2262064wmq.13.2022.11.23.03.35.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Nov 2022 03:35:04 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 5/7] io_uring: inline __io_req_complete_put()
Date:   Wed, 23 Nov 2022 11:33:40 +0000
Message-Id: <1923a4dfe80fa877f859a22ed3df2d5fc8ecf02b.1669203009.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1669203009.git.asml.silence@gmail.com>
References: <cover.1669203009.git.asml.silence@gmail.com>
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

Inline __io_req_complete_put() into io_req_complete_post(), there are no
other users.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 81e7e51816fb..bd9b286eb031 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -813,15 +813,19 @@ bool io_post_aux_cqe(struct io_ring_ctx *ctx,
 	return filled;
 }
 
-static void __io_req_complete_put(struct io_kiocb *req)
+void io_req_complete_post(struct io_kiocb *req)
 {
+	struct io_ring_ctx *ctx = req->ctx;
+
+	io_cq_lock(ctx);
+	if (!(req->flags & REQ_F_CQE_SKIP))
+		__io_fill_cqe_req(ctx, req);
+
 	/*
 	 * If we're the last reference to this request, add to our locked
 	 * free_list cache.
 	 */
 	if (req_ref_put_and_test(req)) {
-		struct io_ring_ctx *ctx = req->ctx;
-
 		if (req->flags & IO_REQ_LINK_FLAGS) {
 			if (req->flags & IO_DISARM_MASK)
 				io_disarm_next(req);
@@ -842,16 +846,6 @@ static void __io_req_complete_put(struct io_kiocb *req)
 		wq_list_add_head(&req->comp_list, &ctx->locked_free_list);
 		ctx->locked_free_nr++;
 	}
-}
-
-void io_req_complete_post(struct io_kiocb *req)
-{
-	struct io_ring_ctx *ctx = req->ctx;
-
-	io_cq_lock(ctx);
-	if (!(req->flags & REQ_F_CQE_SKIP))
-		__io_fill_cqe_req(ctx, req);
-	__io_req_complete_put(req);
 	io_cq_unlock_post(ctx);
 }
 
-- 
2.38.1

