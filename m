Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70B1F599E34
	for <lists+io-uring@lfdr.de>; Fri, 19 Aug 2022 17:31:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348832AbiHSP3r (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Aug 2022 11:29:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349600AbiHSP3q (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Aug 2022 11:29:46 -0400
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 944FBE68E5
        for <io-uring@vger.kernel.org>; Fri, 19 Aug 2022 08:29:45 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1660922984;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ODhPmDjom+4oOLEwqrIFYRuyeK5mh/1I2zNwWSRUWlo=;
        b=jv4n//T+TBPum3/iOGn4amOoPSYoUC/eTxsJQAPtM/ZXxI/VrSE5BCzdyJ/NXssZxJpe4j
        ePnPHLq9kwKOs5lIL0i30sitWWA3dtbjP8cz1GOaJQrz7KI9OnP4R+054oEYnuS5+e+rK7
        Bw4qqyTPvzO8KD//PsBFAtSASln9VS8=
From:   Hao Xu <hao.xu@linux.dev>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        Wanpeng Li <wanpengli@tencent.com>
Subject: [PATCH 08/19] io-wq: add IO_WORKER_F_SUBMIT and its friends
Date:   Fri, 19 Aug 2022 23:27:27 +0800
Message-Id: <20220819152738.1111255-9-hao.xu@linux.dev>
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

Add IO_WORKER_F_SUBMIT to indicate that a uringlet worker is submitting
sqes and thus we should do some scheduling when it blocks.

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 io_uring/io-wq.c | 20 ++++++++++++++++++++
 io_uring/io-wq.h |  1 +
 2 files changed, 21 insertions(+)

diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index 55f1063f24c7..7e58bb5857ee 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -393,6 +393,21 @@ static inline bool io_wq_is_uringlet(struct io_wq *wq)
 	return wq->private;
 }
 
+static inline void io_worker_set_submit(struct io_worker *worker)
+{
+	worker->flags |= IO_WORKER_F_SUBMIT;
+}
+
+static inline void io_worker_clean_submit(struct io_worker *worker)
+{
+	worker->flags &= ~IO_WORKER_F_SUBMIT;
+}
+
+static inline bool io_worker_test_submit(struct io_worker *worker)
+{
+	return worker->flags & IO_WORKER_F_SUBMIT;
+}
+
 static void io_wqe_dec_running(struct io_worker *worker)
 {
 	struct io_wqe_acct *acct = io_wqe_get_acct(worker);
@@ -408,6 +423,9 @@ static void io_wqe_dec_running(struct io_worker *worker)
 	if (io_wq_is_uringlet(wq)) {
 		bool activated;
 
+		if (!io_worker_test_submit(worker))
+			return;
+
 		raw_spin_lock(&wqe->lock);
 		rcu_read_lock();
 		activated = io_wqe_activate_free_worker(wqe, acct);
@@ -688,7 +706,9 @@ static void io_wqe_worker_let(struct io_worker *worker)
 		do {
 			enum io_uringlet_state submit_state;
 
+			io_worker_set_submit(worker);
 			submit_state = wq->do_work(wq->private);
+			io_worker_clean_submit(worker);
 			if (submit_state == IO_URINGLET_SCHEDULED) {
 				empty_count = 0;
 				break;
diff --git a/io_uring/io-wq.h b/io_uring/io-wq.h
index 504a8a8e3fd8..1485e9009784 100644
--- a/io_uring/io-wq.h
+++ b/io_uring/io-wq.h
@@ -33,6 +33,7 @@ enum {
 	IO_WORKER_F_FREE	= 4,	/* worker on free list */
 	IO_WORKER_F_BOUND	= 8,	/* is doing bounded work */
 	IO_WORKER_F_SCHEDULED	= 16,	/* worker had been scheduled out before */
+	IO_WORKER_F_SUBMIT	= 32,	/* uringlet worker is submitting sqes */
 };
 
 typedef struct io_wq_work *(free_work_fn)(struct io_wq_work *);
-- 
2.25.1

