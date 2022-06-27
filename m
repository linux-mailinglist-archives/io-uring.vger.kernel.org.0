Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8759055DB3E
	for <lists+io-uring@lfdr.de>; Tue, 28 Jun 2022 15:24:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234561AbiF0Nf4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Jun 2022 09:35:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235951AbiF0Nfz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Jun 2022 09:35:55 -0400
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DFEA63A5
        for <io-uring@vger.kernel.org>; Mon, 27 Jun 2022 06:35:55 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1656336953;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=weyq1RViEPpLZyQ6CiIHnd3SKxHsPNn7JBltw99c5cY=;
        b=bWSWdTFeskdmjOWI4QzkCEYKnOdDk/C/50LdmsSMAvKVTKtrGS3m3Bz2FfACNjceLd4Qnc
        UnVR2+rIuxXidAqCw+tSDkvfr+dJykyqDq5o6Vjsh+RbBwAvN8Hcv3wAB/V/ODGowKUvUv
        MTJlCD1opGJUmiWFfaN9iV6+1Y7n3/M=
From:   Hao Xu <hao.xu@linux.dev>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 01/11] io-wq: add a worker flag for individual exit
Date:   Mon, 27 Jun 2022 21:35:31 +0800
Message-Id: <20220627133541.15223-2-hao.xu@linux.dev>
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

Add a worker flag to control exit of an individual worker, this is
needed for fixed worker in the next patches but also as a generic
functionality.

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 io_uring/io-wq.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index 824623bcf1a5..0c26805ca6de 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -26,6 +26,7 @@ enum {
 	IO_WORKER_F_RUNNING	= 2,	/* account as running */
 	IO_WORKER_F_FREE	= 4,	/* worker on free list */
 	IO_WORKER_F_BOUND	= 8,	/* is doing bounded work */
+	IO_WORKER_F_EXIT	= 32,	/* worker is exiting */
 };
 
 enum {
@@ -639,8 +640,12 @@ static int io_wqe_worker(void *data)
 	while (!test_bit(IO_WQ_BIT_EXIT, &wq->state)) {
 		long ret;
 
+		if (worker->flags & IO_WORKER_F_EXIT)
+			break;
+
 		set_current_state(TASK_INTERRUPTIBLE);
-		while (io_acct_run_queue(acct))
+		while (!(worker->flags & IO_WORKER_F_EXIT) &&
+		       io_acct_run_queue(acct))
 			io_worker_handle_work(worker);
 
 		raw_spin_lock(&wqe->lock);
@@ -656,6 +661,10 @@ static int io_wqe_worker(void *data)
 		raw_spin_unlock(&wqe->lock);
 		if (io_flush_signals())
 			continue;
+		if (worker->flags & IO_WORKER_F_EXIT) {
+			__set_current_state(TASK_RUNNING);
+			break;
+		}
 		ret = schedule_timeout(WORKER_IDLE_TIMEOUT);
 		if (signal_pending(current)) {
 			struct ksignal ksig;
-- 
2.25.1

