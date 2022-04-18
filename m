Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64EA7505EC1
	for <lists+io-uring@lfdr.de>; Mon, 18 Apr 2022 21:53:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347775AbiDRT4X (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 18 Apr 2022 15:56:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347788AbiDRT4W (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 18 Apr 2022 15:56:22 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A5B62C65C
        for <io-uring@vger.kernel.org>; Mon, 18 Apr 2022 12:53:42 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id b24so18605156edu.10
        for <io-uring@vger.kernel.org>; Mon, 18 Apr 2022 12:53:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=osdROghO41qH2OJiZms7xWOh6Hdtw1J1vGY7bQ1lS+Y=;
        b=oq6F2corIypCgkPtQcRGjbuqhAM7NWMuaKYLV6gC+XTisq8F/U6i57399xejsyeM21
         lgPY+RiJylMg6or2eXGI6AKvwYjS2M88cdziUf/T5EkZwYVs0NX2YuAZBQXc6AaaDpg2
         tqKmFfVKUREUhLZJk4YU5gBApS0xPZGhHhaKjEeN04C9rlJwjOfdgbCqGhA0vFuTHO8/
         uv8C9jW6mGDM+QB0l7Ca1ugwnZ6N7RtaLxyLXsvB1siPlQ0SEEahD+Qtf8oWWXnk9o+j
         ikonQzOOEK3EfyKrWM2MsJ1WSkJgd3MC1vz8+N8xiAKai7IjrCnZML8Q9oI91js0jbvk
         AEjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=osdROghO41qH2OJiZms7xWOh6Hdtw1J1vGY7bQ1lS+Y=;
        b=ADhGNVroqYJfsmo5GdYiwb7Ms/Ii21SWrCVwEOZnVlLeklUXS9FPgnF0uDpA46LFZv
         fRxZHPNfOkvjAfAxb90aoCLQ69A5QsFAs4+kWES7jyMTmpb730K2s3myK8w97I0Aj4tC
         JkMZXgKKydyjfposPVAEF6oVv8DPCLdNyVwx35lzIje7/VPC8v16XkPjZCZKxtsDONQo
         8NjuAn8HK0jQs77OBAJ0fpnjk4THmY8mrM5dd7pjw3KNBog1qlfMyjWMhK0JShd1IYHU
         IkILnRrvqEoi1AdbIdQ9eT/kR8MGXRHeVyZbHVx6yBOuTUOQJnZzsORSjZj1BQxrsFaK
         KnjQ==
X-Gm-Message-State: AOAM530baWL8xaGY2YHtVaZEAOtAVE7uxaAywBxAIefRhvlxiyeeCvE/
        NSPgM1LFWsOVukcR49O9ud3tohiJCC4=
X-Google-Smtp-Source: ABdhPJxGxSWEDjfNlLPgMNlIq0wSPnWFy0J0Quunu+2X6UtaZ803Xsjqzj87D7ymmO5Dh6H66GnxCA==
X-Received: by 2002:a05:6402:438f:b0:41b:51ca:f541 with SMTP id o15-20020a056402438f00b0041b51caf541mr13821790edc.80.1650311620335;
        Mon, 18 Apr 2022 12:53:40 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.129.70])
        by smtp.gmail.com with ESMTPSA id bf11-20020a0564021a4b00b00423e997a3ccsm1629143edb.19.2022.04.18.12.53.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Apr 2022 12:53:39 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 3/5] io_uring: store rsrc node in req instead of refs
Date:   Mon, 18 Apr 2022 20:51:13 +0100
Message-Id: <cee1c86ec9023f3e4f6ce8940d58c017ef8782f4.1650311386.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <cover.1650311386.git.asml.silence@gmail.com>
References: <cover.1650311386.git.asml.silence@gmail.com>
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

req->fixed_rsrc_refs keeps a pointer to rsrc node pcpu references, but
it's more natural just to store rsrc node directly. There were some
reasons for that in the past but not anymore.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 9626bc1cb0a0..c26de427b05d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -931,7 +931,7 @@ struct io_kiocb {
 	struct io_ring_ctx		*ctx;
 	struct task_struct		*task;
 
-	struct percpu_ref		*fixed_rsrc_refs;
+	struct io_rsrc_node		*rsrc_node;
 	/* store used ubuf, so we can prevent reloading */
 	struct io_mapped_ubuf		*imu;
 
@@ -1329,20 +1329,20 @@ static inline void io_req_put_rsrc_locked(struct io_kiocb *req,
 					  struct io_ring_ctx *ctx)
 	__must_hold(&ctx->uring_lock)
 {
-	struct percpu_ref *ref = req->fixed_rsrc_refs;
+	struct io_rsrc_node *node = req->rsrc_node;
 
-	if (ref) {
-		if (ref == &ctx->rsrc_node->refs)
+	if (node) {
+		if (node == ctx->rsrc_node)
 			ctx->rsrc_cached_refs++;
 		else
-			percpu_ref_put(ref);
+			percpu_ref_put(&node->refs);
 	}
 }
 
 static inline void io_req_put_rsrc(struct io_kiocb *req, struct io_ring_ctx *ctx)
 {
-	if (req->fixed_rsrc_refs)
-		percpu_ref_put(req->fixed_rsrc_refs);
+	if (req->rsrc_node)
+		percpu_ref_put(&req->rsrc_node->refs);
 }
 
 static __cold void io_rsrc_refs_drop(struct io_ring_ctx *ctx)
@@ -1365,8 +1365,8 @@ static inline void io_req_set_rsrc_node(struct io_kiocb *req,
 					struct io_ring_ctx *ctx,
 					unsigned int issue_flags)
 {
-	if (!req->fixed_rsrc_refs) {
-		req->fixed_rsrc_refs = &ctx->rsrc_node->refs;
+	if (!req->rsrc_node) {
+		req->rsrc_node = ctx->rsrc_node;
 
 		if (!(issue_flags & IO_URING_F_UNLOCKED)) {
 			lockdep_assert_held(&ctx->uring_lock);
@@ -1374,7 +1374,7 @@ static inline void io_req_set_rsrc_node(struct io_kiocb *req,
 			if (unlikely(ctx->rsrc_cached_refs < 0))
 				io_rsrc_refs_refill(ctx);
 		} else {
-			percpu_ref_get(req->fixed_rsrc_refs);
+			percpu_ref_get(&req->rsrc_node->refs);
 		}
 	}
 }
@@ -7606,7 +7606,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	req->flags = sqe_flags = READ_ONCE(sqe->flags);
 	req->cqe.user_data = READ_ONCE(sqe->user_data);
 	req->file = NULL;
-	req->fixed_rsrc_refs = NULL;
+	req->rsrc_node = NULL;
 	req->task = current;
 
 	if (unlikely(opcode >= IORING_OP_LAST)) {
-- 
2.35.2

