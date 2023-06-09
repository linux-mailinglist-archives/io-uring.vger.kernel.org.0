Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04CAA7299F8
	for <lists+io-uring@lfdr.de>; Fri,  9 Jun 2023 14:29:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239626AbjFIM3b (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 9 Jun 2023 08:29:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238515AbjFIM3b (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 9 Jun 2023 08:29:31 -0400
X-Greylist: delayed 491 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 09 Jun 2023 05:28:52 PDT
Received: from out-21.mta0.migadu.com (out-21.mta0.migadu.com [IPv6:2001:41d0:1004:224b::15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E6463AA9
        for <io-uring@vger.kernel.org>; Fri,  9 Jun 2023 05:28:52 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1686313257;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JbJwvURb/ngoXMSoDDhj8OOS8eskuwHDmLEoYpaKtzY=;
        b=nl0yV3eF9RH4oDKrzbNmYPK+4odpxcdtUcoRPooL+gMdNsBqA5ltAnUBZ+3Xjs0vOKlrZl
        zjzVsvwvSq3hfyr1f8bnafVW5yiG617MaqLFUBiHIb4wCqGW/ZBO5PMWY8Ny3t0Gu11PPW
        V+6HWW8DiO6n+Ykg57wJzb+JGw/FOFY=
From:   Hao Xu <hao.xu@linux.dev>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH 06/11] io-wq: return io_worker after successful inline worker creation
Date:   Fri,  9 Jun 2023 20:20:26 +0800
Message-Id: <20230609122031.183730-7-hao.xu@linux.dev>
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

After creating a io worker inline successfully, return the io_worker
structure. This is used by fixed worker.

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 io_uring/io-wq.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index 048856eef4d4..4338e5b23b07 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -137,7 +137,7 @@ struct io_cb_cancel_data {
 	bool cancel_all;
 };
 
-static bool create_io_worker(struct io_wq *wq, int index, bool fixed);
+static struct io_worker *create_io_worker(struct io_wq *wq, int index, bool fixed);
 static void io_wq_dec_running(struct io_worker *worker);
 static bool io_acct_cancel_pending_work(struct io_wq *wq,
 					struct io_wq_acct *acct,
@@ -284,8 +284,8 @@ static bool io_wq_activate_free_worker(struct io_wq *wq,
  * We need a worker. If we find a free one, we're good. If not, and we're
  * below the max number of workers, create one.
  */
-static bool io_wq_create_worker(struct io_wq *wq, struct io_wq_acct *acct,
-				bool fixed)
+static struct io_worker *io_wq_create_worker(struct io_wq *wq,
+					     struct io_wq_acct *acct, bool fixed)
 {
 	/*
 	 * Most likely an attempt to queue unbounded work on an io_wq that
@@ -297,7 +297,7 @@ static bool io_wq_create_worker(struct io_wq *wq, struct io_wq_acct *acct,
 	raw_spin_lock(&wq->lock);
 	if (acct->nr_workers >= acct->max_workers) {
 		raw_spin_unlock(&wq->lock);
-		return true;
+		return NULL;
 	}
 	acct->nr_workers++;
 	raw_spin_unlock(&wq->lock);
@@ -809,11 +809,11 @@ static void io_workqueue_create(struct work_struct *work)
 		kfree(worker);
 }
 
-static bool create_io_worker(struct io_wq *wq, int index, bool fixed)
+static struct io_worker *create_io_worker(struct io_wq *wq, int index, bool fixed)
 {
 	struct io_wq_acct *acct = &wq->acct[index];
 	struct io_worker *worker;
-	struct task_struct *tsk;
+	struct task_struct *tsk = NULL;
 
 	__set_current_state(TASK_RUNNING);
 
@@ -825,7 +825,7 @@ static bool create_io_worker(struct io_wq *wq, int index, bool fixed)
 		acct->nr_workers--;
 		raw_spin_unlock(&wq->lock);
 		io_worker_ref_put(wq);
-		return false;
+		return tsk ? (struct io_worker *)tsk : ERR_PTR(-ENOMEM);
 	}
 
 	refcount_set(&worker->ref, 1);
@@ -841,8 +841,8 @@ static bool create_io_worker(struct io_wq *wq, int index, bool fixed)
 
 	tsk = create_io_thread(io_wq_worker, worker, NUMA_NO_NODE);
 	if (!IS_ERR(tsk)) {
-		if (!fixed)
-			io_init_new_worker(wq, worker, tsk);
+		io_init_new_worker(wq, worker, tsk);
+		return worker;
 	} else if (fixed || !io_should_retry_thread(PTR_ERR(tsk))) {
 		kfree(worker);
 		goto fail;
@@ -851,7 +851,7 @@ static bool create_io_worker(struct io_wq *wq, int index, bool fixed)
 		schedule_work(&worker->work);
 	}
 
-	return true;
+	return (struct io_worker *)tsk;
 }
 
 /*
-- 
2.25.1

