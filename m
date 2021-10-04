Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF0A44216F0
	for <lists+io-uring@lfdr.de>; Mon,  4 Oct 2021 21:03:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237733AbhJDTFq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 Oct 2021 15:05:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237495AbhJDTFq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 Oct 2021 15:05:46 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6B3AC061745
        for <io-uring@vger.kernel.org>; Mon,  4 Oct 2021 12:03:56 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id p11so15946745edy.10
        for <io-uring@vger.kernel.org>; Mon, 04 Oct 2021 12:03:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XtmKv8EnYepVQuBeqvXOqQzo3sIgSsftuHXh1yvYldw=;
        b=kVrfdRGI5p5bSw6ipDLts1lxFucqZd5LZAVAzFIRIlrffQkakMEEw+7Of+NBAM3AK7
         iR9ix68m9ejZQ0UpUQN9Nv2xhdty02O8kJDHrxqGuBcspndp5Snqi8w0kPIMD8APK+1p
         fHSgVu80sDhCqcCnAqnjMu9U592hycoishjl44Ay1jP1CMb5RQCXDbMBofLdKPQ4xBUT
         IDuljOymTw5msVs0KxT4P+jGeTFpg38ztRWZuZmN2g5W+WSemuvGDlUu5OeXo9ygk0xi
         HzZWRJg7I2H66yzruUVojd/o4yC902TzrwPPS8Iq7aGlFe9mATgYWTtXTJ2U1GqPnti4
         16XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XtmKv8EnYepVQuBeqvXOqQzo3sIgSsftuHXh1yvYldw=;
        b=fMJ1yKYwLN0lDnwjwMTJuNHcai7QQOnHQzK96RVvbOoIZLdELMu594aQZYcKbm07kE
         VvBJj9OB+stO1pYzWquVTibd6dhyW5SDL33NVRt+G/0v9EQLzU6XyiQE0QVdAnLyQlUq
         6ivE4mEUQcZWnJDmqKvgxF1gwhcQ6Xcxe489Vl65jyUXm7Quxc1ic81FCtXSB9oBk+kW
         NbCOALy0cyk6QZzTe8u0BKttgsH2pZrxt7XKFztHo/BcGi+ldqsppifVND+f35QNglnd
         LRNkWeSu6BPktv3j89kwixgn/NfQ4aDr7q9msv/vrI0nF5PapoZ0BJrS+MX7TXOvK4Ah
         WPhA==
X-Gm-Message-State: AOAM533U15WL8SCTytf2VrycSh+3kJIxzoub0xtzZbxjOE04gjJOMcdB
        +1GC/Z8DV/KBwkzNPQ5ocXRjjHxLtlI=
X-Google-Smtp-Source: ABdhPJxKrW3vAq1g/+ctfjQcTQerjA9IS/2YMEErXit0oSuI44VfhHePEWn4OU96kU52reBX0KZPlA==
X-Received: by 2002:a17:906:3859:: with SMTP id w25mr16039663ejc.550.1633374235179;
        Mon, 04 Oct 2021 12:03:55 -0700 (PDT)
Received: from localhost.localdomain ([85.255.237.101])
        by smtp.gmail.com with ESMTPSA id k12sm6855045ejk.63.2021.10.04.12.03.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 12:03:54 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 08/16] io_uring: optimise ctx referencing by requests
Date:   Mon,  4 Oct 2021 20:02:53 +0100
Message-Id: <99613fbe396e80777228cde39bbda1aa8938554e.1633373302.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1633373302.git.asml.silence@gmail.com>
References: <cover.1633373302.git.asml.silence@gmail.com>
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
 fs/io_uring.c | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index b465fba8a0dc..2b7f38df6a0c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1807,7 +1807,6 @@ static void io_req_complete_post(struct io_kiocb *req, long res,
 		io_put_task(req->task, 1);
 		wq_list_add_head(&req->comp_list, &ctx->locked_free_list);
 		ctx->locked_free_nr++;
-		percpu_ref_put(&ctx->refs);
 	}
 	io_commit_cqring(ctx);
 	spin_unlock(&ctx->completion_lock);
@@ -1929,6 +1928,7 @@ static bool __io_alloc_req_refill(struct io_ring_ctx *ctx)
 		ret = 1;
 	}
 
+	percpu_ref_get_many(&ctx->refs, ret);
 	for (i = 0; i < ret; i++) {
 		req = reqs[i];
 
@@ -1986,8 +1986,6 @@ static void __io_free_req(struct io_kiocb *req)
 	wq_list_add_head(&req->comp_list, &ctx->locked_free_list);
 	ctx->locked_free_nr++;
 	spin_unlock(&ctx->completion_lock);
-
-	percpu_ref_put(&ctx->refs);
 }
 
 static inline void io_remove_next_linked(struct io_kiocb *req)
@@ -2276,7 +2274,7 @@ static void io_free_batch_list(struct io_ring_ctx *ctx,
 	__must_hold(&ctx->uring_lock)
 {
 	struct task_struct *task = NULL;
-	int task_refs = 0, ctx_refs = 0;
+	int task_refs = 0;
 
 	do {
 		struct io_kiocb *req = container_of(node, struct io_kiocb,
@@ -2296,12 +2294,9 @@ static void io_free_batch_list(struct io_ring_ctx *ctx,
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
@@ -7215,8 +7210,6 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 		return 0;
 	/* make sure SQ entry isn't read before tail */
 	nr = min3(nr, ctx->sq_entries, entries);
-	if (unlikely(!percpu_ref_tryget_many(&ctx->refs, nr)))
-		return -EAGAIN;
 	io_get_task_refs(nr);
 
 	io_submit_state_start(&ctx->submit_state, nr);
@@ -7246,7 +7239,6 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 		int unused = nr - ref_used;
 
 		current->io_uring->cached_refs += unused;
-		percpu_ref_put_many(&ctx->refs, unused);
 	}
 
 	io_submit_state_end(ctx);
@@ -9167,6 +9159,7 @@ static void io_destroy_buffers(struct io_ring_ctx *ctx)
 static void io_req_caches_free(struct io_ring_ctx *ctx)
 {
 	struct io_submit_state *state = &ctx->submit_state;
+	int nr = 0;
 
 	mutex_lock(&ctx->uring_lock);
 	io_flush_cached_locked_reqs(ctx, state);
@@ -9178,7 +9171,10 @@ static void io_req_caches_free(struct io_ring_ctx *ctx)
 		node = wq_stack_extract(&state->free_list);
 		req = container_of(node, struct io_kiocb, comp_list);
 		kmem_cache_free(req_cachep, req);
+		nr++;
 	}
+	if (nr)
+		percpu_ref_put_many(&ctx->refs, nr);
 	mutex_unlock(&ctx->uring_lock);
 }
 
@@ -9348,6 +9344,8 @@ static void io_ring_exit_work(struct work_struct *work)
 			io_sq_thread_unpark(sqd);
 		}
 
+		io_req_caches_free(ctx);
+
 		if (WARN_ON_ONCE(time_after(jiffies, timeout))) {
 			/* there is little hope left, don't run it too often */
 			interval = HZ * 60;
@@ -10727,10 +10725,14 @@ static int io_ctx_quiesce(struct io_ring_ctx *ctx)
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

