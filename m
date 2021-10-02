Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F13E641FBBA
	for <lists+io-uring@lfdr.de>; Sat,  2 Oct 2021 14:15:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233132AbhJBMRh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 2 Oct 2021 08:17:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233130AbhJBMRh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 2 Oct 2021 08:17:37 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EB3CC0613EC
        for <io-uring@vger.kernel.org>; Sat,  2 Oct 2021 05:15:51 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id dn26so44593094edb.13
        for <io-uring@vger.kernel.org>; Sat, 02 Oct 2021 05:15:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=U7NKiFzJTNK+rJAoVSlfJ0mg7lU8eNuSKzs1CiUxjYU=;
        b=oJRq1BkG+lTALjVl4Pmbx5HXQ7plHmC96k+6KdphlfnBzvh6/NEGjcM6vqRJUsQViY
         +3kT8XMra0hcBr19/WdLLitkImKoiBwHd7UEomntdhSJ911ixwTfj/yBc6gC8emT2kTX
         SWmEkqBvRm9bPsol2k3bJGw2TLsiY6T/ZySuzyp5mNIYixob9d4GbWrENNAfuqkeJgTn
         pCFUOGXTamvnaKpnoJw/JXvSZOkRYRcxaFApoGYl2BMoV+qIttElwNfeOT7ZE0exgaSY
         0OyKPX+Q6N8BHKZez8Yf4rotB9jfFBwGaoa2A17TBxYfiZk6jiLn4norevuvG4eHhGt2
         1fow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=U7NKiFzJTNK+rJAoVSlfJ0mg7lU8eNuSKzs1CiUxjYU=;
        b=rcUFVct413PQUbRlXVggjvqgOsLyV0LbNOXQQi9pC3h3MAaQ7zXZNQBwh9r8N01j7B
         hZ1flsBE3TC968eSvstf+KDVD4XYcfMyLaqayjYmOje0JvO84N2Q8PlTmQtkjLEvjk5o
         HuCwgzi4tnIxiBfkpnKZ239/q5FuRsc0NoMWc5x1Ps9f2116l6WSyEB0beo9TgDlgMu+
         +vKwvVurQmVUwKp3TF5O0dQf1y2i6pO7ov3h0vhuqXI6ROX/dL4j5MN77uhd3BTqlOaE
         nkxSZdkjpWTazldAO8JQAfwvWI/vUSuARpIrV/Vbo12pfEe0zWh3tvkT6JaeLvMyt+wr
         py4Q==
X-Gm-Message-State: AOAM531e74mIqcd8x0TPJCIfuokz98gcCJ42TOR1eH3uWJBVrQ/FipsX
        TcJ7TWR/5ujPoAA3DDosd6nNa4UY834=
X-Google-Smtp-Source: ABdhPJxLz6DeAzC9y6J6T08EOb1JTzuD03VRlSGGgrD0LzPs+XqWWmpG4pxCBGqIk/5FJev/QmDouQ==
X-Received: by 2002:a17:907:75e1:: with SMTP id jz1mr3923099ejc.439.1633176949634;
        Sat, 02 Oct 2021 05:15:49 -0700 (PDT)
Received: from localhost.localdomain ([85.255.233.39])
        by smtp.gmail.com with ESMTPSA id d19sm1991651eds.60.2021.10.02.05.15.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Oct 2021 05:15:49 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [RFC] io_uring: optimise requests referencing ctx
Date:   Sat,  2 Oct 2021 13:15:03 +0100
Message-Id: <69934153393c9af5f44c5312b89d4beb9ce0b591.1633176671.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Currenlty, we allocate one ctx reference per request at submission time
and put them at free. It's batched and not so expensive but it still
bloats the kernel, adds 2 function calls for rcu and adds some overhead
for request counting in io_free_batch_list().

Always keep one reference with a request, even when it's freed and in
io_uring request caches. There is extra work at ring exit / quiesce
paths, which now need to put all cached requests. io_ring_exit_work() is
already looping, so it's not a problem. Add hybrid-busy waiting to
io_ctx_quiesce() as well for now.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---

I want to get rid of extra request ctx referencing, but across different
kernel versions have been getting "interesting" results loosing
performance for nops test. Thus, it's only RFC to see whether I'm the
only one seeing weird effects.



 fs/io_uring.c | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 98401ec46c12..e1877b5ccf26 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1805,7 +1805,6 @@ static void io_req_complete_post(struct io_kiocb *req, long res,
 		io_put_task(req->task, 1);
 		wq_list_add_head(&req->comp_list, &ctx->locked_free_list);
 		ctx->locked_free_nr++;
-		percpu_ref_put(&ctx->refs);
 	}
 	io_commit_cqring(ctx);
 	spin_unlock(&ctx->completion_lock);
@@ -1933,6 +1932,7 @@ static struct io_kiocb *io_alloc_req(struct io_ring_ctx *ctx)
 		ret = 1;
 	}
 
+	percpu_ref_get_many(&ctx->refs, ret);
 	for (i = 0; i < ret; i++) {
 		req = reqs[i];
 
@@ -1977,8 +1977,6 @@ static void __io_free_req(struct io_kiocb *req)
 	wq_list_add_head(&req->comp_list, &ctx->locked_free_list);
 	ctx->locked_free_nr++;
 	spin_unlock(&ctx->completion_lock);
-
-	percpu_ref_put(&ctx->refs);
 }
 
 static inline void io_remove_next_linked(struct io_kiocb *req)
@@ -2267,7 +2265,7 @@ static void io_free_batch_list(struct io_ring_ctx *ctx,
 	__must_hold(&ctx->uring_lock)
 {
 	struct task_struct *task = NULL;
-	int task_refs = 0, ctx_refs = 0;
+	int task_refs = 0;
 
 	do {
 		struct io_kiocb *req = container_of(node, struct io_kiocb,
@@ -2287,12 +2285,9 @@ static void io_free_batch_list(struct io_ring_ctx *ctx,
 			task_refs = 0;
 		}
 		task_refs++;
-		ctx_refs++;
 		wq_stack_add_head(&req->comp_list, &ctx->submit_state.free_list);
 	} while (node);
 
-	if (ctx_refs)
-		percpu_ref_put_many(&ctx->refs, ctx_refs);
 	if (task)
 		io_put_task(task, task_refs);
 }
@@ -7202,8 +7197,6 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 		return 0;
 	/* make sure SQ entry isn't read before tail */
 	nr = min3(nr, ctx->sq_entries, entries);
-	if (!percpu_ref_tryget_many(&ctx->refs, nr))
-		return -EAGAIN;
 	io_get_task_refs(nr);
 
 	io_submit_state_start(&ctx->submit_state, nr);
@@ -7233,7 +7226,6 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 		int unused = nr - ref_used;
 
 		current->io_uring->cached_refs += unused;
-		percpu_ref_put_many(&ctx->refs, unused);
 	}
 
 	io_submit_state_end(ctx);
@@ -9154,6 +9146,7 @@ static void io_destroy_buffers(struct io_ring_ctx *ctx)
 static void io_req_caches_free(struct io_ring_ctx *ctx)
 {
 	struct io_submit_state *state = &ctx->submit_state;
+	int nr;
 
 	mutex_lock(&ctx->uring_lock);
 	io_flush_cached_locked_reqs(ctx, state);
@@ -9165,7 +9158,10 @@ static void io_req_caches_free(struct io_ring_ctx *ctx)
 		node = wq_stack_extract(&state->free_list);
 		req = container_of(node, struct io_kiocb, comp_list);
 		kmem_cache_free(req_cachep, req);
+		nr++;
 	}
+	if (nr)
+		percpu_ref_put_many(&ctx->refs, nr);
 	mutex_unlock(&ctx->uring_lock);
 }
 
@@ -9335,6 +9331,8 @@ static void io_ring_exit_work(struct work_struct *work)
 			io_sq_thread_unpark(sqd);
 		}
 
+		io_req_caches_free(ctx);
+
 		if (WARN_ON_ONCE(time_after(jiffies, timeout))) {
 			/* there is little hope left, don't run it too often */
 			interval = HZ * 60;
@@ -10714,10 +10712,14 @@ static int io_ctx_quiesce(struct io_ring_ctx *ctx)
 	 */
 	mutex_unlock(&ctx->uring_lock);
 	do {
-		ret = wait_for_completion_interruptible(&ctx->ref_comp);
-		if (!ret)
+		ret = wait_for_completion_interruptible_timeout(&ctx->ref_comp, HZ);
+		if (ret) {
+			ret = min(0L, ret);
 			break;
+		}
+
 		ret = io_run_task_work_sig();
+		io_req_caches_free(ctx);
 	} while (ret >= 0);
 	mutex_lock(&ctx->uring_lock);
 
-- 
2.33.0

