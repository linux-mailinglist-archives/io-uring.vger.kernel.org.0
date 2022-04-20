Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F1AD508630
	for <lists+io-uring@lfdr.de>; Wed, 20 Apr 2022 12:41:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343901AbiDTKob (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 20 Apr 2022 06:44:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377808AbiDTKmt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 20 Apr 2022 06:42:49 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFC4BDEA7
        for <io-uring@vger.kernel.org>; Wed, 20 Apr 2022 03:40:02 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id z5-20020a17090a468500b001d2bc2743c4so1656555pjf.0
        for <io-uring@vger.kernel.org>; Wed, 20 Apr 2022 03:40:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FxtI5k+4FlY7wsO+RizlTOwYvGHriaYOxdBtSjMIgEI=;
        b=TEeDycnofZP4GRymi6wdBsMJJvMVjTaD2jemHUW5nsFNYfuPVUkS4CdJ5drHBcZCaZ
         x7jH+GVxKMFN9xWWm0+j51gNXb86kPWjGy5/ilm4iQsHy8Lze8lhnWJq7gSa2qnat8zq
         nh7rU4dt8VJnpmOEZ8wYf0kyYbZpvmd0F4qOo5dx55O1PN6tBdlxM31qlZcgtSpZfbt9
         OJZm8e9+fjWVMoM5fhBfa6J1rfdrS4aUOFq8+LlyohShW3ncdKLvq8cWrO5xFyw5Z8X9
         UDTgPaPKkBNUAcSf2lMBhpMFzR9ujfFP6kI+hbIVkw8AbKOGjREkh0ysjSgJsCAhjhYG
         ENNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FxtI5k+4FlY7wsO+RizlTOwYvGHriaYOxdBtSjMIgEI=;
        b=P9ibfT0RgB43KCn5LVvxGbAGSLQgA1TnPDDpvxL0/RPreiTmvTFCR00/dKTgfo09ZE
         DB6Yg3UQbIpY9UZ1de3Un2hm+lAzN5+7ZjpSlCVshEapxhc7BgaTSXmg297biAj3tn3o
         bT+hdK13Pd4DjFvHhiwG9Xer2AFA5RoQIL3OYjOsCIeBCQrAK5Rf2RVSixDbHy1LJ13V
         zevzhIrxOQ8pyMAx0XKWyImQfJP9HGoLvo2psahvw6/fkZ74rDw4A5niFvqlLBjsVa1O
         Yqf9alayk+te6VxoXHm0j6KIW0uY/ZxJbMg5ZNiBZfatL4AbdIslZakuMm3+YgGsVZoI
         KKEg==
X-Gm-Message-State: AOAM532+XNR6QWeh4+hBv7mo1ggb0gbaQgLlk91pq9MNfwH9UVxPMd4L
        Dc0OmkpoRB2/0YM+GZt2BXPpqZOZ+vAKQQ==
X-Google-Smtp-Source: ABdhPJyZRGA1G92y6pHfaFDUGv++PkQ/P30Pi0G7mkRBJ0x5JSET032HUvqscAv3Nq5U/0tHFOFarQ==
X-Received: by 2002:a17:90b:4a85:b0:1d2:aee9:23ce with SMTP id lp5-20020a17090b4a8500b001d2aee923cemr3673611pjb.99.1650451202354;
        Wed, 20 Apr 2022 03:40:02 -0700 (PDT)
Received: from HOWEYXU-MB0.tencent.com ([106.53.4.151])
        by smtp.gmail.com with ESMTPSA id y16-20020a63b510000000b00398d8b19bbfsm19491670pge.23.2022.04.20.03.40.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 20 Apr 2022 03:40:02 -0700 (PDT)
From:   Hao Xu <haoxu.linux@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 3/9] io-wq: add infra data structure for fixed workers
Date:   Wed, 20 Apr 2022 18:39:54 +0800
Message-Id: <20220420104000.23214-4-haoxu.linux@gmail.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220420104000.23214-1-haoxu.linux@gmail.com>
References: <20220420104000.23214-1-haoxu.linux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Hao Xu <howeyxu@tencent.com>

Add data sttructure and basic initialization for fixed worker.

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 fs/io-wq.c | 98 ++++++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 87 insertions(+), 11 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index e4f5575750f4..451b8fb389d1 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -26,6 +26,7 @@ enum {
 	IO_WORKER_F_RUNNING	= 2,	/* account as running */
 	IO_WORKER_F_FREE	= 4,	/* worker on free list */
 	IO_WORKER_F_BOUND	= 8,	/* is doing bounded work */
+	IO_WORKER_F_FIXED	= 16,	/* is a fixed worker */
 	IO_WORKER_F_EXIT	= 32,	/* worker is exiting */
 };
 
@@ -37,6 +38,61 @@ enum {
 	IO_ACCT_STALLED_BIT	= 0,	/* stalled on hash */
 };
 
+struct io_wqe_acct {
+	/*
+	 * union {
+	 *	1) for normal worker
+	 *	struct {
+	 *		unsigned nr_workers;
+	 *		unsigned max_workers;
+	 *		struct io_wq_work_list work_list;
+	 *	};
+	 *	2) for fixed worker
+	 *	struct {
+	 *		unsigned nr_workers; // not meaningful
+	 *		unsigned max_workers; // not meaningful
+	 *		unsigned nr_fixed;
+	 *		unsigned max_works;
+	 *		struct io_worker **fixed_workers;
+	 *	};
+	 *	3) for fixed worker's private acct
+	 *	struct {
+	 *		unsigned nr_works;
+	 *		unsigned max_works;
+	 *		struct io_wq_work_list work_list;
+	 *	};
+	 *};
+	 */
+	union {
+		unsigned nr_workers;
+		unsigned nr_works;
+	};
+	unsigned max_workers;
+	unsigned nr_fixed;
+	unsigned max_works;
+	union {
+		struct io_wq_work_list work_list;
+		struct io_worker **fixed_workers;
+	};
+	/*
+	 * nr_running is not meaningful for fixed worker
+	 * but still keep the same logic for it for the
+	 * convinence for now. So do nr_workers and
+	 * max_workers.
+	 */
+	atomic_t nr_running;
+	/*
+	 * For 1), it protects the work_list, the other two member nr_workers
+	 * and max_workers are protected by wqe->lock.
+	 * For 2), it protects nr_fixed, max_works, fixed_workers
+	 * For 3), it protects nr_works, max_works and work_list.
+	 */
+	raw_spinlock_t lock;
+	int index;
+	unsigned long flags;
+	bool fixed_worker_registered;
+};
+
 /*
  * One for each thread in a wqe pool
  */
@@ -62,6 +118,8 @@ struct io_worker {
 		struct rcu_head rcu;
 		struct work_struct work;
 	};
+	int index;
+	struct io_wqe_acct acct;
 };
 
 #if BITS_PER_LONG == 64
@@ -72,16 +130,6 @@ struct io_worker {
 
 #define IO_WQ_NR_HASH_BUCKETS	(1u << IO_WQ_HASH_ORDER)
 
-struct io_wqe_acct {
-	unsigned nr_workers;
-	unsigned max_workers;
-	int index;
-	atomic_t nr_running;
-	raw_spinlock_t lock;
-	struct io_wq_work_list work_list;
-	unsigned long flags;
-};
-
 enum {
 	IO_WQ_ACCT_BOUND,
 	IO_WQ_ACCT_UNBOUND,
@@ -94,6 +142,7 @@ enum {
 struct io_wqe {
 	raw_spinlock_t lock;
 	struct io_wqe_acct acct[IO_WQ_ACCT_NR];
+	struct io_wqe_acct fixed_acct[IO_WQ_ACCT_NR];
 
 	int node;
 
@@ -1205,6 +1254,31 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 			atomic_set(&acct->nr_running, 0);
 			INIT_WQ_LIST(&acct->work_list);
 			raw_spin_lock_init(&acct->lock);
+
+			acct = &wqe->fixed_acct[i];
+			acct->index = i;
+			INIT_WQ_LIST(&acct->work_list);
+			raw_spin_lock_init(&acct->lock);
+			/*
+			 * nr_running for a fixed worker is meaningless
+			 * for now, init it to 1 to wround around the
+			 * io_wqe_dec_running logic
+			 */
+			atomic_set(&acct->nr_running, 1);
+			/*
+			 * max_workers for a fixed worker is meaningless
+			 * for now, init it so since number of fixed workers
+			 * should be controlled by users.
+			 */
+			acct->max_workers = task_rlimit(current, RLIMIT_NPROC);
+			raw_spin_lock_init(&acct->lock);
+			/*
+			 * For fixed worker, not necessary
+			 * but do it explicitly for clearity
+			 */
+			acct->nr_fixed = 0;
+			acct->max_works = 0;
+			acct->fixed_workers = NULL;
 		}
 		wqe->wq = wq;
 		raw_spin_lock_init(&wqe->lock);
@@ -1287,7 +1361,7 @@ static void io_wq_exit_workers(struct io_wq *wq)
 
 static void io_wq_destroy(struct io_wq *wq)
 {
-	int node;
+	int i, node;
 
 	cpuhp_state_remove_instance_nocalls(io_wq_online, &wq->cpuhp_node);
 
@@ -1299,6 +1373,8 @@ static void io_wq_destroy(struct io_wq *wq)
 		};
 		io_wqe_cancel_pending_work(wqe, &match);
 		free_cpumask_var(wqe->cpu_mask);
+		for (i = 0; i < IO_WQ_ACCT_NR; i++)
+			kfree(wqe->fixed_acct[i].fixed_workers);
 		kfree(wqe);
 	}
 	io_wq_put_hash(wq->hash);
-- 
2.36.0

