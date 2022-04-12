Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 466534FE374
	for <lists+io-uring@lfdr.de>; Tue, 12 Apr 2022 16:10:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355270AbiDLOM7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 12 Apr 2022 10:12:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350319AbiDLOM6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 12 Apr 2022 10:12:58 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B7B11D0C1
        for <io-uring@vger.kernel.org>; Tue, 12 Apr 2022 07:10:40 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id v64-20020a1cac43000000b0038cfd1b3a6dso1851161wme.5
        for <io-uring@vger.kernel.org>; Tue, 12 Apr 2022 07:10:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0YOEHUm4enytkIVd/vbB9pYHxdEe63oGBiFCJX+bxTE=;
        b=h+24a1njOXgd/YCSdOKYvDbZP0iS/OsS7BeoXZi6f48h9WzU5oI4y2wZybuk/58TNO
         /q1HK33otbIiTyfHNDYDScEtnGEn63xK4z/i4trNom/c2uQGrodxjbeuOeMgJ4cMQ9VM
         LUYdlpTPa5saJpaShyVlAx5jngfHWXomM0xZQyPFof9e14QSAksAW6yI0bvfSzoTAAjZ
         kPix2OtNjPZtNumTWHAc9rlmMfUc1tinHJugIFRSAi/B+ObbjQ0BaHDUMYCNuLQyKMbG
         f0Q2dfEC7r2HFeAVtujop7QJhfVxfVrRvdX/zKrADBGLJoJcoYnpTQn/SoAqf1X5pv2r
         UxHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0YOEHUm4enytkIVd/vbB9pYHxdEe63oGBiFCJX+bxTE=;
        b=7enGwfm3kKMC/ttle6jeooV4Xhcnb+0MbYXOmsU7qCVqfLhYh6i/FikwnrBF0bWGL3
         NzmDgz7B6DmNkBXFEo1WJtnFOh+giAu8iY2WoWCD4dENpR5Q9nzfcFodz/M3X9ozZhBW
         dEaLImT6eYnyUdby43Y6YIF3Kv/Y2v1PhmKU5uYfB+su2zCzjCB9mAvHQkoCA5MDrzRd
         NS4mRXJRynctD0ZqkjcBXNI5OtVhXlxv7Kzy8kCakzI9+ha3Cm2YopmITcr2+tN9u7hc
         rNqzZCVwfYJ2KmTqhOB6PzulUYdmmX+Slt1isTdi4Na5Nta7LCgzz5dbURfhgcphXvhI
         wegw==
X-Gm-Message-State: AOAM53195Wl0bfYe9wfbYpTY/iqD5ZR+nwLJySYffn0gtAJGKv024fWT
        BqAumM6+LuvO2mH9tdfLqxD9VlMwh1E=
X-Google-Smtp-Source: ABdhPJxI3prAd8vTC58ZUeIppwbPV8VIWDqIUWLEHDnWawGjS6+BEFE7V8baeR/ITKojMWnsw4QqTA==
X-Received: by 2002:a7b:c30e:0:b0:37f:a63d:3d1f with SMTP id k14-20020a7bc30e000000b0037fa63d3d1fmr4256657wmj.178.1649772638878;
        Tue, 12 Apr 2022 07:10:38 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.129.222])
        by smtp.gmail.com with ESMTPSA id ay41-20020a05600c1e2900b0038e75fda4edsm2363703wmb.47.2022.04.12.07.10.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 07:10:38 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 6/9] io_uring: add helper to return req to cache list
Date:   Tue, 12 Apr 2022 15:09:48 +0100
Message-Id: <f206f575486a8dd3d52f074ab37ed146b2d215b7.1649771823.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1649771823.git.asml.silence@gmail.com>
References: <cover.1649771823.git.asml.silence@gmail.com>
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

Don't hand code wq_stack_add_head() to ->free_list, which serves for
recycling io_kiocb, add a helper doing it for us.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 3ccc13acb498..a751ca167d21 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1493,6 +1493,11 @@ static inline void req_fail_link_node(struct io_kiocb *req, int res)
 	req->cqe.res = res;
 }
 
+static inline void io_req_add_to_cache(struct io_kiocb *req, struct io_ring_ctx *ctx)
+{
+	wq_stack_add_head(&req->comp_list, &ctx->submit_state.free_list);
+}
+
 static __cold void io_ring_ctx_ref_free(struct percpu_ref *ref)
 {
 	struct io_ring_ctx *ctx = container_of(ref, struct io_ring_ctx, refs);
@@ -2225,7 +2230,6 @@ static inline bool io_req_cache_empty(struct io_ring_ctx *ctx)
 static __cold bool __io_alloc_req_refill(struct io_ring_ctx *ctx)
 	__must_hold(&ctx->uring_lock)
 {
-	struct io_submit_state *state = &ctx->submit_state;
 	gfp_t gfp = GFP_KERNEL | __GFP_NOWARN;
 	void *reqs[IO_REQ_ALLOC_BATCH];
 	int ret, i;
@@ -2259,7 +2263,7 @@ static __cold bool __io_alloc_req_refill(struct io_ring_ctx *ctx)
 		struct io_kiocb *req = reqs[i];
 
 		io_preinit_req(req, ctx);
-		wq_stack_add_head(&req->comp_list, &state->free_list);
+		io_req_add_to_cache(req, ctx);
 	}
 	return true;
 }
@@ -2702,7 +2706,7 @@ static void io_free_batch_list(struct io_ring_ctx *ctx,
 		}
 		task_refs++;
 		node = req->comp_list.next;
-		wq_stack_add_head(&req->comp_list, &ctx->submit_state.free_list);
+		io_req_add_to_cache(req, ctx);
 	} while (node);
 
 	if (task)
@@ -7853,7 +7857,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 		req = io_alloc_req(ctx);
 		sqe = io_get_sqe(ctx);
 		if (unlikely(!sqe)) {
-			wq_stack_add_head(&req->comp_list, &ctx->submit_state.free_list);
+			io_req_add_to_cache(req, ctx);
 			break;
 		}
 		/* will complete beyond this point, count as submitted */
-- 
2.35.1

