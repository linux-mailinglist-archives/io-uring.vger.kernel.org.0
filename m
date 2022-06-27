Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F49055CD0B
	for <lists+io-uring@lfdr.de>; Tue, 28 Jun 2022 15:02:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235951AbiF0Nf7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Jun 2022 09:35:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235629AbiF0Nf7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Jun 2022 09:35:59 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A73006362
        for <io-uring@vger.kernel.org>; Mon, 27 Jun 2022 06:35:58 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1656336956;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eFAqcjlFMxWhM2a8jmHB1NuKlvvBP5MivvkGdb6YA/0=;
        b=lIwHRVRc+Ey3e/ExskNuvvSrisVKSq+4aLWfDch6gc7HzTx7h9rvspcocLWXR6CGodctVl
        7bwCPMPVZXIwRWy8hoGoLj9oT8O/NZY5omfwcJf9JwZueGs2xZ5p9rKiU1XP8VLRG0aTrA
        nlphyrTfgxw4bceLEvKWfEnNnkzrrNY=
From:   Hao Xu <hao.xu@linux.dev>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 02/11] io-wq: change argument of create_io_worker() for convienence
Date:   Mon, 27 Jun 2022 21:35:32 +0800
Message-Id: <20220627133541.15223-3-hao.xu@linux.dev>
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

Change index to acct itself for create_io_worker() for convienence in
the next patches.

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 io_uring/io-wq.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index 0c26805ca6de..35ce622f77ba 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -139,7 +139,8 @@ struct io_cb_cancel_data {
 	bool cancel_all;
 };
 
-static bool create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index);
+static bool create_io_worker(struct io_wq *wq, struct io_wqe *wqe,
+			     struct io_wqe_acct *acct);
 static void io_wqe_dec_running(struct io_worker *worker);
 static bool io_acct_cancel_pending_work(struct io_wqe *wqe,
 					struct io_wqe_acct *acct,
@@ -306,7 +307,7 @@ static bool io_wqe_create_worker(struct io_wqe *wqe, struct io_wqe_acct *acct)
 	raw_spin_unlock(&wqe->lock);
 	atomic_inc(&acct->nr_running);
 	atomic_inc(&wqe->wq->worker_refs);
-	return create_io_worker(wqe->wq, wqe, acct->index);
+	return create_io_worker(wqe->wq, wqe, acct);
 }
 
 static void io_wqe_inc_running(struct io_worker *worker)
@@ -335,7 +336,7 @@ static void create_worker_cb(struct callback_head *cb)
 	}
 	raw_spin_unlock(&wqe->lock);
 	if (do_create) {
-		create_io_worker(wq, wqe, worker->create_index);
+		create_io_worker(wq, wqe, acct);
 	} else {
 		atomic_dec(&acct->nr_running);
 		io_worker_ref_put(wq);
@@ -812,9 +813,10 @@ static void io_workqueue_create(struct work_struct *work)
 		kfree(worker);
 }
 
-static bool create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index)
+static bool create_io_worker(struct io_wq *wq, struct io_wqe *wqe,
+			     struct io_wqe_acct *acct)
 {
-	struct io_wqe_acct *acct = &wqe->acct[index];
+	int index = acct->index;
 	struct io_worker *worker;
 	struct task_struct *tsk;
 
-- 
2.25.1

