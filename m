Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36329599E2D
	for <lists+io-uring@lfdr.de>; Fri, 19 Aug 2022 17:31:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349664AbiHSP2f (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Aug 2022 11:28:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349743AbiHSP2d (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Aug 2022 11:28:33 -0400
Received: from out1.migadu.com (out1.migadu.com [91.121.223.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 519519FD4
        for <io-uring@vger.kernel.org>; Fri, 19 Aug 2022 08:28:31 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1660922909;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J4jWtznh3gADBZLpivIklxKj5BL1zAoiqN9NDNbiHuc=;
        b=nkDAfz4bKPPyJyz9VMoa1g/EzFqOQNCwly79NPqZhysSXnO97+f2p/zs7CuQ3fmPDONo7j
        b/9yHwlwt+4hMSadTebdElHXWdU+/NbAtpyFQif1zoyOnqvSOo0rhWIcCBbt5jhEC1qwl3
        vEPsQSJO70QfpKwv9ojS/NgntHQTcAY=
From:   Hao Xu <hao.xu@linux.dev>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        Wanpeng Li <wanpengli@tencent.com>
Subject: [PATCH 05/19] io_uring: add io_uringler_offload() for uringlet mode
Date:   Fri, 19 Aug 2022 23:27:24 +0800
Message-Id: <20220819152738.1111255-6-hao.xu@linux.dev>
In-Reply-To: <20220819152738.1111255-1-hao.xu@linux.dev>
References: <20220819152738.1111255-1-hao.xu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Hao Xu <howeyxu@tencent.com>

In uringlet mode, a io_uring_enter call shouldn't do the sqe submission
work, but just offload it to io-workers.

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 io_uring/io-wq.c    | 18 ++++++++++++++++++
 io_uring/io-wq.h    |  1 +
 io_uring/io_uring.c | 21 ++++++++++++++-------
 3 files changed, 33 insertions(+), 7 deletions(-)

diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index b533db18d7c0..212ea16cbb5e 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -771,6 +771,24 @@ void io_wq_worker_sleeping(struct task_struct *tsk)
 	io_wqe_dec_running(worker);
 }
 
+int io_uringlet_offload(struct io_wq *wq)
+{
+	struct io_wqe *wqe = wq->wqes[numa_node_id()];
+	struct io_wqe_acct *acct = io_get_acct(wqe, true);
+	bool waken;
+
+	raw_spin_lock(&wqe->lock);
+	rcu_read_lock();
+	waken = io_wqe_activate_free_worker(wqe, acct);
+	rcu_read_unlock();
+	raw_spin_unlock(&wqe->lock);
+
+	if (waken)
+		return 0;
+
+	return io_wqe_create_worker(wqe, acct);
+}
+
 static void io_init_new_worker(struct io_wqe *wqe, struct io_worker *worker,
 			       struct task_struct *tsk)
 {
diff --git a/io_uring/io-wq.h b/io_uring/io-wq.h
index b862b04e49ce..66d2aeb17951 100644
--- a/io_uring/io-wq.h
+++ b/io_uring/io-wq.h
@@ -90,4 +90,5 @@ static inline bool io_wq_current_is_worker(void)
 
 extern struct io_wq *io_init_wq_offload(struct io_ring_ctx *ctx,
 					struct task_struct *task);
+extern int io_uringlet_offload(struct io_wq *wq);
 #endif
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index b57e9059a388..554041705e96 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3051,15 +3051,22 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 		if (unlikely(ret))
 			goto out;
 
-		mutex_lock(&ctx->uring_lock);
-		ret = io_submit_sqes(ctx, to_submit);
-		if (ret != to_submit) {
+		if (!(ctx->flags & IORING_SETUP_URINGLET)) {
+			mutex_lock(&ctx->uring_lock);
+			ret = io_submit_sqes(ctx, to_submit);
+			if (ret != to_submit) {
+				mutex_unlock(&ctx->uring_lock);
+				goto out;
+			}
+			if ((flags & IORING_ENTER_GETEVENTS) && ctx->syscall_iopoll)
+				goto iopoll_locked;
 			mutex_unlock(&ctx->uring_lock);
-			goto out;
+		} else {
+			ret = io_uringlet_offload(ctx->let);
+			if (ret)
+				goto out;
+			ret = to_submit;
 		}
-		if ((flags & IORING_ENTER_GETEVENTS) && ctx->syscall_iopoll)
-			goto iopoll_locked;
-		mutex_unlock(&ctx->uring_lock);
 	}
 	if (flags & IORING_ENTER_GETEVENTS) {
 		int ret2;
-- 
2.25.1

