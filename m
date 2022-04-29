Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D1D051468B
	for <lists+io-uring@lfdr.de>; Fri, 29 Apr 2022 12:19:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357362AbiD2KW0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 29 Apr 2022 06:22:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357329AbiD2KWU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 29 Apr 2022 06:22:20 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE59DC667E;
        Fri, 29 Apr 2022 03:19:02 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id r83so6197208pgr.2;
        Fri, 29 Apr 2022 03:19:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rrB+iTthb+bNS3lBLpFX7rVXhXl7gxHV2a/wJB/nLbY=;
        b=aabTLqoPA3HAi69J7qpQV+WtIpTBwm5Bl3umDu0lsB/WZjUaYHMomy2A/SIfl6qH55
         fNH2MqCWxcagQgI2CNYca83lp6ebBzEPur6Iu4mt7an11QkXp7CwUI0mbzrZtCR+s6aZ
         1tQiumL6XrWxMgzYBd/vccEV3C7HMuAnTjtTYx5KS6kGXTIZyKWiBG2jGZeM9rSW+cgn
         88i35Ci1xZDWpsoAUtiClCfdvLkkQXMUoXUzsZUBPc36bGfv+IqtOpTQJxhiJOnbGtQu
         b50QlcphLijM+tSMBiBwGDvf0Ja7A+p6seByD8He8bmtxAhV6LqmcAvlhg0/EqdVcUWa
         8IKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rrB+iTthb+bNS3lBLpFX7rVXhXl7gxHV2a/wJB/nLbY=;
        b=2Eh64BO8qLI+jPwI0TtdE2IjattAtiBBDmrPF+6G+yMr4fpsJrFNQZkxaC8STZX2fM
         YUg8QXU8xoJ8T6PCp4F5+mJTZ/KaXooFkRVCynF4jexiucEVQthcf+Yvm6gGNz9qJqTC
         tqSaKk0y2/ZSCD8yTSYrK3ZQkbDzPzjVPwX4z44Tsd0vvG8c/a03FErcSIAyP5zfJVyG
         FSyW/Fvfx7/hN3l948N1Bcch4aAhsto6auAmv8zSNIBy3t6LKaH91pE1PAMnlkaQlyLT
         YRElu2NDUOXmQ/mCRv8Ric3jyaYa0gcd5UIU3IAq8URxTrc1hxHW/jIq6U4MnKHjutvA
         vJLw==
X-Gm-Message-State: AOAM531DagOcKJ14IYtzHZCXA9MWuLIXPaFHePWIM4qUrclk8vfntkaZ
        SvjaeZGhVegj+hbqkNW22NbsOHCZfNw=
X-Google-Smtp-Source: ABdhPJxFwlAVfk9c+/RMDitmKDqXaGDGiVlvw25Fz4bjbRa5dIGqJzjkL+EDi8Hh18GO9X2pdgOM5w==
X-Received: by 2002:a62:cf02:0:b0:50d:3e00:60c with SMTP id b2-20020a62cf02000000b0050d3e00060cmr25967787pfg.69.1651227542231;
        Fri, 29 Apr 2022 03:19:02 -0700 (PDT)
Received: from HOWEYXU-MB0.tencent.com ([106.53.33.166])
        by smtp.gmail.com with ESMTPSA id k17-20020a628e11000000b0050d8d373331sm2600016pfe.214.2022.04.29.03.19.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 29 Apr 2022 03:19:01 -0700 (PDT)
From:   Hao Xu <haoxu.linux@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/9] io-wq: add infra data structure for fixed workers
Date:   Fri, 29 Apr 2022 18:18:52 +0800
Message-Id: <20220429101858.90282-4-haoxu.linux@gmail.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220429101858.90282-1-haoxu.linux@gmail.com>
References: <20220429101858.90282-1-haoxu.linux@gmail.com>
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
index 35ce622f77ba..ac8faf1f7a0a 100644
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

