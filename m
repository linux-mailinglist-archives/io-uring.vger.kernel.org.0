Return-Path: <io-uring+bounces-1413-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E243689A1CE
	for <lists+io-uring@lfdr.de>; Fri,  5 Apr 2024 17:50:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1188B1C21969
	for <lists+io-uring@lfdr.de>; Fri,  5 Apr 2024 15:50:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 102F616FF4E;
	Fri,  5 Apr 2024 15:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="STAVmwH1"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4723216FF4B
	for <io-uring@vger.kernel.org>; Fri,  5 Apr 2024 15:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712332218; cv=none; b=pK8LoAPd+tt291QS98JlctnSSHP4n00W1e/zweg6i1CEZDnQM/FpC4E0iC/ms+sUzPsc+aRclbt9nkXWpeII6MlHmVaXSxaDvvcFoUqti6aO2VeOWNdbz6LsroaL5YB6Wf1M9N7ny+jq6PdtmEJ92yqTa1RuhKY9eBOuKtB4o3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712332218; c=relaxed/simple;
	bh=ARdPazd7WB6upcxA5AejUGvyIrW+OVCN8RQdiCudRgY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KgU2TB9VyhCsfNI+n70F8JxaHmDWyRmAPAoSH3nvs5BnR0j57wGnt9EZ1rz+1Q6LR3QaGanRw7GW1hSx2CaQkYa909HX3OlHshnND7uPxzQU5x1/5wfF2LLlpQidWzJjL/WdSugxbZ/FDk+2NGKKeaBJYbX0diPK2BlzsOiEnRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=STAVmwH1; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-a4e60a64abcso595662066b.1
        for <io-uring@vger.kernel.org>; Fri, 05 Apr 2024 08:50:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712332214; x=1712937014; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HV9Mw5Jjz68HHXUpaAbRtDprLc4zzD8EsXydMkjUPWQ=;
        b=STAVmwH1P/EFzcsy+39CxF2w7czFjNCigKhJCaoheQqnEQQ+PfqFZo0WAyL9JrxOah
         oSpntCqTmaKGOUPphKzELIGgnzyDWiUjZ6lToWB7dzs36cllZi5OYMo3SVABB2LSjM4x
         4/JEJVe0+oTcUNBoC2bC3s6Ev+F3vtU8JjXatD1foonmwbgGgFlTa0pb1tBY+J1EpE2R
         UTLt+I3CyUp0JFnsyRstOntou3aNUvekscVL0zmMWCQrNdGh/M/zmT7CR9F9Ns4UHbgE
         IzqE9MUIDzIp1edm1ptlPbSi9by/pHlak2W8g0LBvNE1X7V9xbT2N49LFgHgR0cvTu6O
         FyNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712332214; x=1712937014;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HV9Mw5Jjz68HHXUpaAbRtDprLc4zzD8EsXydMkjUPWQ=;
        b=YIqfRSzHbTREQHdk65/MHim6KprLRZgAEmI6VpGqOgLDQcHaT8F1hzNxxA8vv6t7rZ
         caw9ANOx1zJ0NCJ4nhvMpQlq31xS4c7JSB0ATBVHMYH3YIRrrpOWfTWonRWLHZQ4dPOq
         V9dVZFSGJFDLi4y6sOvBBw3tJCdZ6iZuqpXbpTsIRMmsv8LFxIdLlocaKMlXnmCmSL+6
         Sdhkk26weW1oFN0ibqyGZlJqitJGAqA9vERr7VBlDx3QUnV5ihzEqY/lr8LZLrwghHVi
         WzabXbrpjqNqlvSRztjaUKmJQFVuAGfzXcwKNeYoYzqYKXcy1PMIkUWdHBGmaxkivt4i
         RQfw==
X-Gm-Message-State: AOJu0Yw3A1ZbQIiSzXRy8IqKRz6/MmL6JLGpvfHMO0Dmb4fT3f9Ey29u
	/Yfib8hvaVdJ2SEgOBmMeu4t9rGlo0RpB2NxTHLeM19sM23ujjuBal3/2xVS
X-Google-Smtp-Source: AGHT+IGIrSP/RndXMLxuJLdypqBzCg+wsIgmvgVcATX+4WQAeeQwEuOA3xDjKDmdUJSRmV36LZ2r1w==
X-Received: by 2002:a17:906:b311:b0:a51:9056:b878 with SMTP id n17-20020a170906b31100b00a519056b878mr1508723ejz.35.1712332214495;
        Fri, 05 Apr 2024 08:50:14 -0700 (PDT)
Received: from 127.0.0.1localhost ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id lc24-20020a170906f91800b00a46c8dbd5e4sm966105ejb.7.2024.04.05.08.50.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Apr 2024 08:50:13 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH for-next 3/4] io_uring: remove async request cache
Date: Fri,  5 Apr 2024 16:50:04 +0100
Message-ID: <7bffccd213e370abd4de480e739d8b08ab6c1326.1712331455.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <cover.1712331455.git.asml.silence@gmail.com>
References: <cover.1712331455.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_req_complete_post() was a sole user of ->locked_free_list, but
since we just gutted the function, the cache is not used anymore and
can be removed.

->locked_free_list served as an asynhronous counterpart of the main
request (i.e. struct io_kiocb) cache for all unlocked cases like io-wq.
Now they're all forced to be completed into the main cache directly,
off of the normal completion path or via io_free_req().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring_types.h |  4 ----
 io_uring/io_uring.c            | 22 ----------------------
 2 files changed, 26 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index b191710bec4f..9c49aa2dac38 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -347,10 +347,6 @@ struct io_ring_ctx {
 
 	spinlock_t		completion_lock;
 
-	/* IRQ completion list, under ->completion_lock */
-	unsigned int		locked_free_nr;
-	struct io_wq_work_list	locked_free_list;
-
 	struct list_head	io_buffers_comp;
 	struct list_head	cq_overflow_list;
 	struct io_hash_table	cancel_table;
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index c84650b0f7f2..b20ee6a0e32e 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -335,7 +335,6 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	init_llist_head(&ctx->work_llist);
 	INIT_LIST_HEAD(&ctx->tctx_list);
 	ctx->submit_state.free_list.next = NULL;
-	INIT_WQ_LIST(&ctx->locked_free_list);
 	INIT_HLIST_HEAD(&ctx->waitid_list);
 #ifdef CONFIG_FUTEX
 	INIT_HLIST_HEAD(&ctx->futex_list);
@@ -990,15 +989,6 @@ static void io_preinit_req(struct io_kiocb *req, struct io_ring_ctx *ctx)
 	memset(&req->big_cqe, 0, sizeof(req->big_cqe));
 }
 
-static void io_flush_cached_locked_reqs(struct io_ring_ctx *ctx,
-					struct io_submit_state *state)
-{
-	spin_lock(&ctx->completion_lock);
-	wq_list_splice(&ctx->locked_free_list, &state->free_list);
-	ctx->locked_free_nr = 0;
-	spin_unlock(&ctx->completion_lock);
-}
-
 /*
  * A request might get retired back into the request caches even before opcode
  * handlers and io_issue_sqe() are done with it, e.g. inline completion path.
@@ -1012,17 +1002,6 @@ __cold bool __io_alloc_req_refill(struct io_ring_ctx *ctx)
 	void *reqs[IO_REQ_ALLOC_BATCH];
 	int ret;
 
-	/*
-	 * If we have more than a batch's worth of requests in our IRQ side
-	 * locked cache, grab the lock and move them over to our submission
-	 * side cache.
-	 */
-	if (data_race(ctx->locked_free_nr) > IO_COMPL_BATCH) {
-		io_flush_cached_locked_reqs(ctx, &ctx->submit_state);
-		if (!io_req_cache_empty(ctx))
-			return true;
-	}
-
 	ret = kmem_cache_alloc_bulk(req_cachep, gfp, ARRAY_SIZE(reqs), reqs);
 
 	/*
@@ -2741,7 +2720,6 @@ static void io_req_caches_free(struct io_ring_ctx *ctx)
 	int nr = 0;
 
 	mutex_lock(&ctx->uring_lock);
-	io_flush_cached_locked_reqs(ctx, &ctx->submit_state);
 
 	while (!io_req_cache_empty(ctx)) {
 		req = io_extract_req(ctx);
-- 
2.44.0


