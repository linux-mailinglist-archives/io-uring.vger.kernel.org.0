Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0102E55E198
	for <lists+io-uring@lfdr.de>; Tue, 28 Jun 2022 15:34:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234154AbiF0NgF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Jun 2022 09:36:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234557AbiF0NgE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Jun 2022 09:36:04 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E06CB6362
        for <io-uring@vger.kernel.org>; Mon, 27 Jun 2022 06:36:03 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1656336962;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vMfnbP3LS47Qq96xStumF96UHoQqwFDSioFSA6kvU68=;
        b=jTGWWy2Qy7MUPzEOnvVZN3nrOIMDFxObuoLeHSh6mSsvqe9OzEAsT9Fsd4F6fJGAjLc2ZK
        lB0SLlEhK65uKFsSYW69b3HBfm2mBWr/K02RAWsNhw80MvYpmgKMWmVFLhwMzsWa2Wl2pF
        jXQslnxrDV4GxYnQmrvoRyd8+4ktHH8=
From:   Hao Xu <hao.xu@linux.dev>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 04/11] io-wq: tweak io_get_acct()
Date:   Mon, 27 Jun 2022 21:35:34 +0800
Message-Id: <20220627133541.15223-5-hao.xu@linux.dev>
In-Reply-To: <20220627133541.15223-1-hao.xu@linux.dev>
References: <20220627133541.15223-1-hao.xu@linux.dev>
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

Add an argument for io_get_acct() to indicate fixed or normal worker

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 io_uring/io-wq.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index d9b3aeea2c6a..7775ba5fddba 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -213,20 +213,24 @@ static void io_worker_release(struct io_worker *worker)
 		complete(&worker->ref_done);
 }
 
-static inline struct io_wqe_acct *io_get_acct(struct io_wqe *wqe, bool bound)
+static inline struct io_wqe_acct *io_get_acct(struct io_wqe *wqe, bool bound,
+					      bool fixed)
 {
-	return &wqe->acct[bound ? IO_WQ_ACCT_BOUND : IO_WQ_ACCT_UNBOUND];
+	unsigned index = bound ? IO_WQ_ACCT_BOUND : IO_WQ_ACCT_UNBOUND;
+
+	return fixed ? &wqe->fixed_acct[index] : &wqe->acct[index];
 }
 
 static inline struct io_wqe_acct *io_work_get_acct(struct io_wqe *wqe,
 						   struct io_wq_work *work)
 {
-	return io_get_acct(wqe, !(work->flags & IO_WQ_WORK_UNBOUND));
+	return io_get_acct(wqe, !(work->flags & IO_WQ_WORK_UNBOUND), false);
 }
 
 static inline struct io_wqe_acct *io_wqe_get_acct(struct io_worker *worker)
 {
-	return io_get_acct(worker->wqe, worker->flags & IO_WORKER_F_BOUND);
+	return io_get_acct(worker->wqe, worker->flags & IO_WORKER_F_BOUND,
+			   worker->flags & IO_WORKER_F_FIXED);
 }
 
 static void io_worker_ref_put(struct io_wq *wq)
@@ -1129,7 +1133,7 @@ static void io_wqe_cancel_pending_work(struct io_wqe *wqe,
 	int i;
 retry:
 	for (i = 0; i < IO_WQ_ACCT_NR; i++) {
-		struct io_wqe_acct *acct = io_get_acct(wqe, i == 0);
+		struct io_wqe_acct *acct = io_get_acct(wqe, i == 0, false);
 
 		if (io_acct_cancel_pending_work(wqe, acct, match)) {
 			if (match->cancel_all)
-- 
2.25.1

