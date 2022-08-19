Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B1B6599E40
	for <lists+io-uring@lfdr.de>; Fri, 19 Aug 2022 17:31:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349367AbiHSPan (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Aug 2022 11:30:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348983AbiHSPaY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Aug 2022 11:30:24 -0400
Received: from out1.migadu.com (out1.migadu.com [91.121.223.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 825B9AE74
        for <io-uring@vger.kernel.org>; Fri, 19 Aug 2022 08:30:23 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1660923022;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mg1OAUvD7o1eNEDbi7UJD/CkSdfbPxvgSM86lxHSws4=;
        b=Iejoh7L8c3jU7K4Pbvefsfs6fSmWUYNB571Y9TvyTHDTQef+iu4jSqPMaYCJ1CHcnfpTpR
        2qCPpJ4dnLXgofJaBBoQjJ76pjT/GeE7z2/iYilwVLUcdMpdfp0EoShiJLZd5ZgZm5aVr9
        AkXWQcxuwMINjl61wdtkcN+Q7Lt7ULQ=
From:   Hao Xu <hao.xu@linux.dev>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        Wanpeng Li <wanpengli@tencent.com>
Subject: [PATCH 18/19] io-wq: only do io_uringlet_end() at the first schedule time
Date:   Fri, 19 Aug 2022 23:27:37 +0800
Message-Id: <20220819152738.1111255-19-hao.xu@linux.dev>
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

A request may block multiple times during its life cycle. We should
only do io_uringlet_end() at the first time since this function may
modify ctx->submit_state info and for the non-first time, the task
already lost the control of submitting sqes. Allowing it to do so will
damage the submission state.

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 io_uring/io-wq.c    | 14 +++++++++++---
 io_uring/io_uring.c |  2 +-
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index 9fcaeea7a478..f845b7daced8 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -400,16 +400,24 @@ static void io_wqe_dec_running(struct io_worker *worker)
 
 	if (io_wq_is_uringlet(wq)) {
 		bool activated;
+		bool first_block;
 
 		if (!io_worker_test_submit(worker))
 			return;
 
-		io_uringlet_end(wq->private);
-		io_worker_set_scheduled(worker);
 		raw_spin_lock(&wq->lock);
-		wq->owner = IO_WQ_OWNER_TRANSMIT;
+		first_block = (wq->owner == worker ? true : false);
 		raw_spin_unlock(&wq->lock);
 
+		io_worker_set_scheduled(worker);
+
+		if (first_block) {
+			io_uringlet_end(wq->private);
+			raw_spin_lock(&wq->lock);
+			wq->owner = IO_WQ_OWNER_TRANSMIT;
+			raw_spin_unlock(&wq->lock);
+		}
+
 		raw_spin_lock(&wqe->lock);
 		rcu_read_lock();
 		activated = io_wqe_activate_free_worker(wqe, acct);
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index a48e34f63845..7ebc83b3a33f 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2171,7 +2171,7 @@ int io_submit_sqes_let(struct io_wq_work *work)
 
 	io_get_task_refs(entries);
 	io_submit_state_start(&ctx->submit_state, entries);
-	ctx->submit_state->need_plug = false;
+	ctx->submit_state.need_plug = false;
 	do {
 		const struct io_uring_sqe *sqe;
 		struct io_kiocb *req;
-- 
2.25.1

