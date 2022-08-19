Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86AF8599E3B
	for <lists+io-uring@lfdr.de>; Fri, 19 Aug 2022 17:31:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349022AbiHSP2R (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Aug 2022 11:28:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349566AbiHSP2N (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Aug 2022 11:28:13 -0400
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB972296
        for <io-uring@vger.kernel.org>; Fri, 19 Aug 2022 08:28:10 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1660922889;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NEspg2Hen2izljK6C4Uf0o2lN1O6kLVZv/GIs0QRq74=;
        b=erbTCQv/naU1vuHzIcKw0EgYh/QcZhJIXUXd61h43TnznGdKIlTkX4mOq/kifS0fBpgC2v
        Uso5WSWmOve6yHI2lu9QAn7MZILJOqE5/pK8d3o/dGXf2SSzBWa38GJZL+uqfXwVqRaDRO
        CME1ZwZf+8S3NUhc43GWAWYEvzP9hZE=
From:   Hao Xu <hao.xu@linux.dev>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        Wanpeng Li <wanpengli@tencent.com>
Subject: [PATCH 01/19] io_uring: change return value of create_io_worker() and io_wqe_create_worker()
Date:   Fri, 19 Aug 2022 23:27:20 +0800
Message-Id: <20220819152738.1111255-2-hao.xu@linux.dev>
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

Change return value of create_io_worker() and io_wqe_create_worker() so
that it tells the detail error code.

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 io_uring/io-wq.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index c6536d4b2da0..f631acbd50df 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -140,7 +140,7 @@ struct io_cb_cancel_data {
 	bool cancel_all;
 };
 
-static bool create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index);
+static int create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index);
 static void io_wqe_dec_running(struct io_worker *worker);
 static bool io_acct_cancel_pending_work(struct io_wqe *wqe,
 					struct io_wqe_acct *acct,
@@ -289,7 +289,7 @@ static bool io_wqe_activate_free_worker(struct io_wqe *wqe,
  * We need a worker. If we find a free one, we're good. If not, and we're
  * below the max number of workers, create one.
  */
-static bool io_wqe_create_worker(struct io_wqe *wqe, struct io_wqe_acct *acct)
+static int io_wqe_create_worker(struct io_wqe *wqe, struct io_wqe_acct *acct)
 {
 	/*
 	 * Most likely an attempt to queue unbounded work on an io_wq that
@@ -301,7 +301,7 @@ static bool io_wqe_create_worker(struct io_wqe *wqe, struct io_wqe_acct *acct)
 	raw_spin_lock(&wqe->lock);
 	if (acct->nr_workers >= acct->max_workers) {
 		raw_spin_unlock(&wqe->lock);
-		return true;
+		return 0;
 	}
 	acct->nr_workers++;
 	raw_spin_unlock(&wqe->lock);
@@ -790,7 +790,7 @@ static void io_workqueue_create(struct work_struct *work)
 		kfree(worker);
 }
 
-static bool create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index)
+static int create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index)
 {
 	struct io_wqe_acct *acct = &wqe->acct[index];
 	struct io_worker *worker;
@@ -806,7 +806,7 @@ static bool create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index)
 		acct->nr_workers--;
 		raw_spin_unlock(&wqe->lock);
 		io_worker_ref_put(wq);
-		return false;
+		return -ENOMEM;
 	}
 
 	refcount_set(&worker->ref, 1);
@@ -828,7 +828,7 @@ static bool create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index)
 		schedule_work(&worker->work);
 	}
 
-	return true;
+	return 0;
 }
 
 /*
@@ -933,7 +933,7 @@ static void io_wqe_enqueue(struct io_wqe *wqe, struct io_wq_work *work)
 	    !atomic_read(&acct->nr_running))) {
 		bool did_create;
 
-		did_create = io_wqe_create_worker(wqe, acct);
+		did_create = !io_wqe_create_worker(wqe, acct);
 		if (likely(did_create))
 			return;
 
-- 
2.25.1

