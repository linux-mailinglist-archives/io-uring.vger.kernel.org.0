Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 911C8729A00
	for <lists+io-uring@lfdr.de>; Fri,  9 Jun 2023 14:30:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240381AbjFIM3d (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 9 Jun 2023 08:29:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231731AbjFIM3c (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 9 Jun 2023 08:29:32 -0400
Received: from out-28.mta0.migadu.com (out-28.mta0.migadu.com [IPv6:2001:41d0:1004:224b::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 753943AAE
        for <io-uring@vger.kernel.org>; Fri,  9 Jun 2023 05:28:53 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1686313244;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lhlblQ2RrpBpwre9osp84qt/3/ewTJ5oMF21HYvR9Hs=;
        b=PG7m+3mk7k9WkLMmkTo5aVGlW2dDZtz1au1E4n90cZ/jY+iuFotB5lWXFXf0RIwyR5BoqF
        4DycA43tlUQUlhry9QTVnLXvdQzo78x3bR6xW5tWi5evcEHfxky1XIYVZWmhVPErXZx+2n
        tvkWyRPmXla7Ndju6kl4J3+Eu3eSbbA=
From:   Hao Xu <hao.xu@linux.dev>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH 02/11] io-wq: add a new worker flag to indicate worker exit
Date:   Fri,  9 Jun 2023 20:20:22 +0800
Message-Id: <20230609122031.183730-3-hao.xu@linux.dev>
In-Reply-To: <20230609122031.183730-1-hao.xu@linux.dev>
References: <20230609122031.183730-1-hao.xu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Hao Xu <howeyxu@tencent.com>

Add a new worker flag IO_WORKER_F_EXIT to indicate a worker is going to
exit. This is important for fixed workers.

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 io_uring/io-wq.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index b70eebec2845..1717f1465613 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -29,6 +29,7 @@ enum {
 	IO_WORKER_F_RUNNING	= 2,	/* account as running */
 	IO_WORKER_F_FREE	= 4,	/* worker on free list */
 	IO_WORKER_F_BOUND	= 8,	/* is doing bounded work */
+	IO_WORKER_F_EXIT	= 16,	/* worker is exiting */
 };
 
 enum {
@@ -592,6 +593,11 @@ static void io_worker_handle_work(struct io_worker *worker)
 	} while (1);
 }
 
+static bool is_worker_exiting(struct io_worker *worker)
+{
+	return worker->flags & IO_WORKER_F_EXIT;
+}
+
 static int io_wq_worker(void *data)
 {
 	struct io_worker *worker = data;
@@ -609,7 +615,7 @@ static int io_wq_worker(void *data)
 		long ret;
 
 		set_current_state(TASK_INTERRUPTIBLE);
-		while (io_acct_run_queue(acct))
+		while (!is_worker_exiting(worker) && io_acct_run_queue(acct))
 			io_worker_handle_work(worker);
 
 		raw_spin_lock(&wq->lock);
@@ -628,6 +634,12 @@ static int io_wq_worker(void *data)
 		raw_spin_unlock(&wq->lock);
 		if (io_run_task_work())
 			continue;
+		if (is_worker_exiting(worker)) {
+			raw_spin_lock(&wq->lock);
+			acct->nr_workers--;
+			raw_spin_unlock(&wq->lock);
+			break;
+		}
 		ret = schedule_timeout(WORKER_IDLE_TIMEOUT);
 		if (signal_pending(current)) {
 			struct ksignal ksig;
-- 
2.25.1

