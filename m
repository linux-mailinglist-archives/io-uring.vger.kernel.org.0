Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 740F655D465
	for <lists+io-uring@lfdr.de>; Tue, 28 Jun 2022 15:13:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233017AbiF0NgX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Jun 2022 09:36:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235941AbiF0NgX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Jun 2022 09:36:23 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3910863DD
        for <io-uring@vger.kernel.org>; Mon, 27 Jun 2022 06:36:22 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1656336980;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AzQ2x8u9+8abs2ZXi1QKt0WNLkPxccTGlwQkpOrihIw=;
        b=ftTeICYQuJpQf+sYCtrw1qwRHw2SzRyPqxgrjCr8+1/LAvhJWJzkU40sNZ05ja6N4aEK9p
        CP2vArJzRqkl1c+lo7qfma+Zp70LpaUZmd5P0OEDi7u7HtAtaqMmhuzMdZe65pquB7BePx
        EcFlwnZ0tmbNBbXC3j3DpJ7ra0Cl0LQ=
From:   Hao Xu <hao.xu@linux.dev>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 10/11] io-wq: add an work list for fixed worker
Date:   Mon, 27 Jun 2022 21:35:40 +0800
Message-Id: <20220627133541.15223-11-hao.xu@linux.dev>
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

Previously when a fixed worker handles its private works, it get all of
them from worker->acct.work_list to a temporary acct->work_list. This
prevents work cancellation since the cancellation process cannot find
works from this temporary work list. Thus add a new acct so to address
it.

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 io_uring/io-wq.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index d54056b98e2b..38d88da70a40 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -126,6 +126,7 @@ struct io_worker {
 	};
 	int index;
 	struct io_wqe_acct acct;
+	struct io_wqe_acct exec_acct;
 };
 
 #if BITS_PER_LONG == 64
@@ -723,14 +724,17 @@ static void io_worker_handle_work(struct io_worker *worker,
 
 static inline void io_worker_handle_private_work(struct io_worker *worker)
 {
-	struct io_wqe_acct acct;
+	struct io_wqe_acct *acct = &worker->acct;
+	struct io_wqe_acct *exec_acct = &worker->exec_acct;
 
-	raw_spin_lock(&worker->acct.lock);
-	acct = worker->acct;
-	wq_list_clean(&worker->acct.work_list);
-	worker->acct.nr_works = 0;
-	raw_spin_unlock(&worker->acct.lock);
-	io_worker_handle_work(worker, &acct, false);
+	raw_spin_lock(&acct->lock);
+	exec_acct->nr_works = acct->nr_works;
+	exec_acct->max_works = acct->max_works;
+	exec_acct->work_list = acct->work_list;
+	wq_list_clean(&acct->work_list);
+	acct->nr_works = 0;
+	raw_spin_unlock(&acct->lock);
+	io_worker_handle_work(worker, exec_acct, false);
 }
 
 static inline void io_worker_handle_public_work(struct io_worker *worker)
@@ -866,6 +870,7 @@ static void io_init_new_fixed_worker(struct io_wqe *wqe,
 {
 	struct io_wqe_acct *acct = io_wqe_get_acct(worker);
 	struct io_wqe_acct *iw_acct = &worker->acct;
+	struct io_wqe_acct *exec_acct = &worker->exec_acct;
 	unsigned index = acct->index;
 	unsigned *nr_fixed;
 
@@ -878,6 +883,7 @@ static void io_init_new_fixed_worker(struct io_wqe *wqe,
 	iw_acct->index = index;
 	INIT_WQ_LIST(&iw_acct->work_list);
 	raw_spin_lock_init(&iw_acct->lock);
+	raw_spin_lock_init(&exec_acct->lock);
 	raw_spin_unlock(&acct->lock);
 }
 
-- 
2.25.1

