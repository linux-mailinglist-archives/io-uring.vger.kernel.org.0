Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF864599E3C
	for <lists+io-uring@lfdr.de>; Fri, 19 Aug 2022 17:31:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349539AbiHSPaG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Aug 2022 11:30:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349346AbiHSPaF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Aug 2022 11:30:05 -0400
Received: from out1.migadu.com (out1.migadu.com [91.121.223.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 018BFE7242
        for <io-uring@vger.kernel.org>; Fri, 19 Aug 2022 08:30:03 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1660923002;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TwWnIxxzn5kzktussrHgbIB7YahPQii5RZvqgpXAMjU=;
        b=SCMs7unDIJz4PS8Ca5xPNV7udynbeu+Gsgc/HL9EQnHL4+bYRer7q9f1Ngw3aSIfDjMl3X
        FSxD4iqbQ1DXmVjUMe+g78EeCezTOLMzr0Gyz82FIJfBY/4DL+kmReZlOBOEaXlbpJ2Ddh
        ckNSGODznb1JgIs9dH8KmjZBLQQo/Cw=
From:   Hao Xu <hao.xu@linux.dev>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        Wanpeng Li <wanpengli@tencent.com>
Subject: [PATCH 13/19] io-wq: add wq->owner for uringlet mode
Date:   Fri, 19 Aug 2022 23:27:32 +0800
Message-Id: <20220819152738.1111255-14-hao.xu@linux.dev>
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

In uringlet mode, we allow exact one worker to submit sqes at the same
time. nr_running is not a good choice to aim that. Add an member
wq->owner and its lock to achieve that, this avoids race condition
between workers.

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 io_uring/io-wq.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index 00a1cdefb787..9fcaeea7a478 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -96,6 +96,9 @@ struct io_wq {
 
 	void *private;
 
+	raw_spinlock_t lock;
+	struct io_worker *owner;
+
 	struct io_wqe *wqes[];
 };
 
@@ -381,6 +384,8 @@ static inline bool io_worker_test_submit(struct io_worker *worker)
 	return worker->flags & IO_WORKER_F_SUBMIT;
 }
 
+#define IO_WQ_OWNER_TRANSMIT	((struct io_worker *)-1)
+
 static void io_wqe_dec_running(struct io_worker *worker)
 {
 	struct io_wqe_acct *acct = io_wqe_get_acct(worker);
@@ -401,6 +406,10 @@ static void io_wqe_dec_running(struct io_worker *worker)
 
 		io_uringlet_end(wq->private);
 		io_worker_set_scheduled(worker);
+		raw_spin_lock(&wq->lock);
+		wq->owner = IO_WQ_OWNER_TRANSMIT;
+		raw_spin_unlock(&wq->lock);
+
 		raw_spin_lock(&wqe->lock);
 		rcu_read_lock();
 		activated = io_wqe_activate_free_worker(wqe, acct);
@@ -674,6 +683,17 @@ static void io_wqe_worker_let(struct io_worker *worker)
 
 	while (!test_bit(IO_WQ_BIT_EXIT, &wq->state)) {
 		unsigned int empty_count = 0;
+		struct io_worker *owner;
+
+		raw_spin_lock(&wq->lock);
+		owner = wq->owner;
+		if (owner && owner != IO_WQ_OWNER_TRANSMIT && owner != worker) {
+			raw_spin_unlock(&wq->lock);
+			set_current_state(TASK_INTERRUPTIBLE);
+			goto sleep;
+		}
+		wq->owner = worker;
+		raw_spin_unlock(&wq->lock);
 
 		__io_worker_busy(wqe, worker);
 		set_current_state(TASK_INTERRUPTIBLE);
@@ -697,6 +717,7 @@ static void io_wqe_worker_let(struct io_worker *worker)
 			cond_resched();
 		} while (1);
 
+sleep:
 		raw_spin_lock(&wqe->lock);
 		__io_worker_idle(wqe, worker);
 		raw_spin_unlock(&wqe->lock);
@@ -780,6 +801,14 @@ int io_uringlet_offload(struct io_wq *wq)
 	struct io_wqe_acct *acct = io_get_acct(wqe, true);
 	bool waken;
 
+	raw_spin_lock(&wq->lock);
+	if (wq->owner) {
+		raw_spin_unlock(&wq->lock);
+		return 0;
+	}
+	wq->owner = IO_WQ_OWNER_TRANSMIT;
+	raw_spin_unlock(&wq->lock);
+
 	raw_spin_lock(&wqe->lock);
 	rcu_read_lock();
 	waken = io_wqe_activate_free_worker(wqe, acct);
@@ -1248,6 +1277,7 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 	wq->free_work = data->free_work;
 	wq->do_work = data->do_work;
 	wq->private = data->private;
+	raw_spin_lock_init(&wq->lock);
 
 	ret = -ENOMEM;
 	for_each_node(node) {
-- 
2.25.1

