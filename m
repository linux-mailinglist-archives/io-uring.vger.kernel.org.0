Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C844631EEF8
	for <lists+io-uring@lfdr.de>; Thu, 18 Feb 2021 19:54:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232560AbhBRSwS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 18 Feb 2021 13:52:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231314AbhBRSgQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 18 Feb 2021 13:36:16 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83D85C061A2A
        for <io-uring@vger.kernel.org>; Thu, 18 Feb 2021 10:33:51 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id x16so4611894wmk.3
        for <io-uring@vger.kernel.org>; Thu, 18 Feb 2021 10:33:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=kzDONG9JVYOjEh5FjbadJMDkGBACgCICHaoHcHC9nKQ=;
        b=bUPMubWGwzXGVC5V++8Q0ZfqSDv+Z1P6cMJI+7rr1dC0jwIkPr5IzCq7v6IthN2A2R
         ZeNGzrE99kiBYjIeKaQrqaQYnqNZPuCywFYogYHgQpKReNTNs7WMHVqOlf5cPhw1UKNu
         tUjp7g9ST7Bq39ASh9rA4Ul84N3XgEtxRzZBzEOrXPSz9qWSeiTxsFqwCsRm31ztZQwM
         mJ1qQE14eGJg5v3d0V7r22hyLanu+G2+1Z3rkKz8HYyuJH4m4cubkHZIZqaFhMRm7wSK
         BXQgz5/EThy4KAjQuZWc0MQJEPJdLFSjEEKQ3Y6mWgb5+w2cj9/1IW2P8CkLrXGM3SWd
         YPDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kzDONG9JVYOjEh5FjbadJMDkGBACgCICHaoHcHC9nKQ=;
        b=OlJoJvUog3xAMTW/u0PhJdFx2Z76eyIbeY99Xz6qkXE4YbmDu6BS/JR+6N24JJXjji
         zY9AXKtZe4TamcyFuQcoW3dytAENDWvtsDyeMvq6GGCLvQFrwygZYb0wemanGMkEWLQA
         2teRXEkbJh/17RHkG7MmIHS4YR9+qBeu21KLfFGV0N7s+dycLvqggyd/prEKquoh1XMd
         lqidAYb3kt9x0yr/l9/tvFTsH3SAQihqiVfwshWoRp4JtJkeUgVtCP81P7rq1ov1807X
         lVisbV2SubAgsz6W9LAnzk1pmusYn2P0KMh/7mkdtXd85abx8+8nOpjEt2kL9P7Xwy72
         K4Eg==
X-Gm-Message-State: AOAM532qKUOk+QTdE++J5qFVcOayjVwlNhC1GFiW1aW8yh4ODVeR0Bf8
        2TDE0bvh2xglRrOObIggiqWiCsQVNmhxnQ==
X-Google-Smtp-Source: ABdhPJwXzMgmyXmdaz761dd3XLqJCj25S7aI6olXr+sgUoSYED66JiUuHZPFiYv5AfKaKev9YVSjhQ==
X-Received: by 2002:a1c:9a06:: with SMTP id c6mr4702783wme.140.1613673230233;
        Thu, 18 Feb 2021 10:33:50 -0800 (PST)
Received: from localhost.localdomain ([85.255.236.139])
        by smtp.gmail.com with ESMTPSA id 36sm4034459wrh.94.2021.02.18.10.33.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Feb 2021 10:33:49 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 06/11] io_uring: move req link into submit_state
Date:   Thu, 18 Feb 2021 18:29:42 +0000
Message-Id: <78d9833199d7535a9454f1fcd758322e17b4099d.1613671791.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1613671791.git.asml.silence@gmail.com>
References: <cover.1613671791.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Move struct io_submit_link into submit_state, which is a part of a
submission state and so belongs to it. It saves us from explicitly
passing it, and init/deinit is now nicely hidden in
io_submit_state_[start,end].

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5c9b3b9ff92f..fe2379179b00 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -283,8 +283,14 @@ struct io_comp_state {
 	struct list_head	locked_free_list;
 };
 
+struct io_submit_link {
+	struct io_kiocb		*head;
+	struct io_kiocb		*last;
+};
+
 struct io_submit_state {
 	struct blk_plug		plug;
+	struct io_submit_link	link;
 
 	/*
 	 * io_kiocb alloc cache
@@ -6746,15 +6752,10 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	return ret;
 }
 
-struct io_submit_link {
-	struct io_kiocb *head;
-	struct io_kiocb *last;
-};
-
 static int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
-			 const struct io_uring_sqe *sqe,
-			 struct io_submit_link *link)
+			 const struct io_uring_sqe *sqe)
 {
+	struct io_submit_link *link = &ctx->submit_state.link;
 	int ret;
 
 	ret = io_init_req(ctx, req, sqe);
@@ -6829,6 +6830,8 @@ static int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
 static void io_submit_state_end(struct io_submit_state *state,
 				struct io_ring_ctx *ctx)
 {
+	if (state->link.head)
+		io_queue_link_head(state->link.head);
 	if (state->comp.nr)
 		io_submit_flush_completions(&state->comp, ctx);
 	if (state->plug_started)
@@ -6844,6 +6847,8 @@ static void io_submit_state_start(struct io_submit_state *state,
 {
 	state->plug_started = false;
 	state->ios_left = max_ios;
+	/* set only head, no need to init link_last in advance */
+	state->link.head = NULL;
 }
 
 static void io_commit_sqring(struct io_ring_ctx *ctx)
@@ -6891,7 +6896,6 @@ static const struct io_uring_sqe *io_get_sqe(struct io_ring_ctx *ctx)
 
 static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 {
-	struct io_submit_link link;
 	int submitted = 0;
 
 	/* if we have a backlog and couldn't flush it all, return BUSY */
@@ -6908,9 +6912,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 
 	percpu_counter_add(&current->io_uring->inflight, nr);
 	refcount_add(nr, &current->usage);
-
 	io_submit_state_start(&ctx->submit_state, nr);
-	link.head = NULL;
 
 	while (submitted < nr) {
 		const struct io_uring_sqe *sqe;
@@ -6929,7 +6931,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 		}
 		/* will complete beyond this point, count as submitted */
 		submitted++;
-		if (io_submit_sqe(ctx, req, sqe, &link))
+		if (io_submit_sqe(ctx, req, sqe))
 			break;
 	}
 
@@ -6942,10 +6944,8 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 		percpu_counter_sub(&tctx->inflight, unused);
 		put_task_struct_many(current, unused);
 	}
-	if (link.head)
-		io_queue_link_head(link.head);
-	io_submit_state_end(&ctx->submit_state, ctx);
 
+	io_submit_state_end(&ctx->submit_state, ctx);
 	 /* Commit SQ ring head once we've consumed and submitted all SQEs */
 	io_commit_sqring(ctx);
 
-- 
2.24.0

