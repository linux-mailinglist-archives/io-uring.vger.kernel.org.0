Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE682599E32
	for <lists+io-uring@lfdr.de>; Fri, 19 Aug 2022 17:31:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349573AbiHSP2o (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Aug 2022 11:28:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348832AbiHSP2n (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Aug 2022 11:28:43 -0400
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5C2E3E756
        for <io-uring@vger.kernel.org>; Fri, 19 Aug 2022 08:28:41 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1660922920;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qc6R5KcTrXw6lUJn6MhZDB6ZDV0+9RmkY24ZBkoG9Ws=;
        b=SaO/NpW6iGeFYm26UWmjGNq7mOthbmkTrjVSgKAyxKbuvMe59b3jI7c2UCXlnEdj7iSzxe
        tL/xMpj+G2R1D0dFd0bmK0q3MocJezz/QR3EFrGRnWFihRPJZdWiy+evfxjQ2MGS6Ofu/p
        touFIG57BZuuPzIR/TBASSpFCKkMUiY=
From:   Hao Xu <hao.xu@linux.dev>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        Wanpeng Li <wanpengli@tencent.com>
Subject: [PATCH 06/19] io-wq: change the io-worker scheduling logic
Date:   Fri, 19 Aug 2022 23:27:25 +0800
Message-Id: <20220819152738.1111255-7-hao.xu@linux.dev>
In-Reply-To: <20220819152738.1111255-1-hao.xu@linux.dev>
References: <20220819152738.1111255-1-hao.xu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Hao Xu <howeyxu@tencent.com>

We do io-worker creation when a io-worker gets sleeping and some
condition is met. For uringlet mode, we need to do the scheduling too.
A uringlet worker gets sleeping because of blocking in some place below
io_uring layer in the kernel stack. So we should wake up or create a new
uringlet worker in this situation. Meanwhile, setting up a flag to let
the sqe submitter know it had been scheduled out.

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 io_uring/io-wq.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index 212ea16cbb5e..5f54af7579a4 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -404,14 +404,28 @@ static void io_wqe_dec_running(struct io_worker *worker)
 {
 	struct io_wqe_acct *acct = io_wqe_get_acct(worker);
 	struct io_wqe *wqe = worker->wqe;
+	struct io_wq *wq = wqe->wq;
+	bool zero_refs;
 
 	if (!(worker->flags & IO_WORKER_F_UP))
 		return;
 
-	if (!atomic_dec_and_test(&acct->nr_running))
-		return;
-	if (!io_acct_run_queue(acct))
-		return;
+	zero_refs = atomic_dec_and_test(&acct->nr_running);
+
+	if (io_wq_is_uringlet(wq)) {
+		bool activated;
+
+		raw_spin_lock(&wqe->lock);
+		rcu_read_lock();
+		activated = io_wqe_activate_free_worker(wqe, acct);
+		rcu_read_unlock();
+		raw_spin_unlock(&wqe->lock);
+		if (activated)
+			return;
+	} else {
+		if (!zero_refs || !io_acct_run_queue(acct))
+			return;
+	}
 
 	atomic_inc(&acct->nr_running);
 	atomic_inc(&wqe->wq->worker_refs);
-- 
2.25.1

