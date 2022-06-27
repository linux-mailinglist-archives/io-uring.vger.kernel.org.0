Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB7D855D27B
	for <lists+io-uring@lfdr.de>; Tue, 28 Jun 2022 15:10:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235950AbiF0NgJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Jun 2022 09:36:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234557AbiF0NgJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Jun 2022 09:36:09 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBCF56362
        for <io-uring@vger.kernel.org>; Mon, 27 Jun 2022 06:36:08 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1656336967;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BX61HmQlVCCZmq3PJ/mL1vyIpiqCl6HtuPRTd4Rejt4=;
        b=gWj/IMcf4ROC5UwAFuMrE+lgGOPW0eaQRxChHddtXm7VJLP8IfBQ/677VckKQswlFG9srC
        PrD3wxlF3PnI7og8UxH77joIkjC0PLmNObM+CfGXE/9CgxGJvaVqYEddqSd7g6vKyGQ7EF
        FHId7i+tE+jVam8AaKBU3Zc7+uQ1IWE=
From:   Hao Xu <hao.xu@linux.dev>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 06/11] io-wq: fixed worker exit
Date:   Mon, 27 Jun 2022 21:35:36 +0800
Message-Id: <20220627133541.15223-7-hao.xu@linux.dev>
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

Implement the fixed worker exit

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 io_uring/io-wq.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index 70240b847112..11fe5787c409 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -264,6 +264,29 @@ static bool io_task_worker_match(struct callback_head *cb, void *data)
 	return worker == data;
 }
 
+static void io_fixed_worker_exit(struct io_worker *worker)
+{
+	int *nr_fixed;
+	int index = worker->acct.index;
+	struct io_wqe *wqe = worker->wqe;
+	struct io_wqe_acct *acct = io_get_acct(wqe, index == 0, true);
+	struct io_worker **fixed_workers;
+
+	raw_spin_lock(&acct->lock);
+	fixed_workers = acct->fixed_workers;
+	if (!fixed_workers || worker->index == -1) {
+		raw_spin_unlock(&acct->lock);
+		return;
+	}
+	nr_fixed = &acct->nr_fixed;
+	/* reuse variable index to represent fixed worker index in its array */
+	index = worker->index;
+	fixed_workers[index] = fixed_workers[*nr_fixed - 1];
+	(*nr_fixed)--;
+	fixed_workers[index]->index = index;
+	raw_spin_unlock(&acct->lock);
+}
+
 static void io_worker_exit(struct io_worker *worker)
 {
 	struct io_wqe *wqe = worker->wqe;
@@ -687,6 +710,7 @@ static int io_wqe_worker(void *data)
 	struct io_wqe *wqe = worker->wqe;
 	struct io_wq *wq = wqe->wq;
 	bool last_timeout = false;
+	bool fixed = worker->flags & IO_WORKER_F_FIXED;
 	char buf[TASK_COMM_LEN];
 
 	worker->flags |= (IO_WORKER_F_UP | IO_WORKER_F_RUNNING);
@@ -737,6 +761,8 @@ static int io_wqe_worker(void *data)
 
 	if (test_bit(IO_WQ_BIT_EXIT, &wq->state))
 		io_worker_handle_work(worker);
+	if (fixed)
+		io_fixed_worker_exit(worker);
 
 	audit_free(current);
 	io_worker_exit(worker);
-- 
2.25.1

