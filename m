Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BB933E0918
	for <lists+io-uring@lfdr.de>; Wed,  4 Aug 2021 22:00:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237951AbhHDUAk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 4 Aug 2021 16:00:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236868AbhHDUAk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 4 Aug 2021 16:00:40 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26684C0613D5
        for <io-uring@vger.kernel.org>; Wed,  4 Aug 2021 13:00:26 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id ca5so4615460pjb.5
        for <io-uring@vger.kernel.org>; Wed, 04 Aug 2021 13:00:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=6r61WDscWWfiuLR6aun4Jzm94/a1r9CEkT5zws5UZ6U=;
        b=s1FVQn/yWSpX+tQh+CiabzIbrwgplLPomFj2wI/nsXzduGtt2Nlt2SFYla+jM6L/fh
         JtM/Qelbbk6wUlhpu+hmVWybMAPznO+zVyN2txQmTCxCdmUSU5v8Hah1fR8iNHpAA8z8
         xrO3e5KQ1Gh7sT57HevlGVIkcEGKdeNCwO/7uAElck79RwV1gd5ibWzjzGyGEsmHPx1O
         QRMotCK+cqWe8xwC7m8OJSAq1s1O3G/e1BSWHcxLNVY66GuZdAFT/dqRvskH5pqr78vx
         8lsM2qc7vbU9Q6FXZfKylRGR/3bv8zH/I8vEkdNMLZElxsSNuFRqMi0Je7zwsQuAaojj
         jF9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=6r61WDscWWfiuLR6aun4Jzm94/a1r9CEkT5zws5UZ6U=;
        b=pPnuHXhZzKTeftu9Y9lYmSLUu9bgzE6UbNDsKEF0P22RGz406zi6G0lCUAvurxZNxq
         ZPyZTWiVpojxdTsbgDdc6kBSdP08osCqJkRv5Rplbu7cGQCCQrs4jPbDJLJ3vR6VFTxZ
         iqkj7beWrIMRL7qaBNriPneM2iWNjcNjBCnOcnLPu3H7VwdUegCMrcYDtOiOvMNS/yAI
         DJKE0TOyi53wNa+zruIt/9Godq+OyTQ1UzCiITu7Mrj1tR0wyrMitEvjtxieAfmSIPzh
         6NIuav0sFtvRVI1k4JsT9vczQKGaVmvrpGFVm0vfY6BcuSBcgrbtEIpAr9CWsRE6NCg4
         rRQw==
X-Gm-Message-State: AOAM531AP324cjSmXSd4+5DPAf5jTXlpZWfosgfxRamcT2IvIpEhETvg
        JyF9O8h9n1vo8T+PqfkXY+Q91A==
X-Google-Smtp-Source: ABdhPJzTD9QoULZN+qZt2D/aKyr7bBvG9F9umI7DPW0DUwdzSxRW2qhY3Ct2sokSraV7ud9tGg0U2Q==
X-Received: by 2002:a17:90a:98b:: with SMTP id 11mr823392pjo.144.1628107225618;
        Wed, 04 Aug 2021 13:00:25 -0700 (PDT)
Received: from [192.168.1.116] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id b128sm4059818pfb.144.2021.08.04.13.00.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Aug 2021 13:00:25 -0700 (PDT)
To:     io-uring <io-uring@vger.kernel.org>
Cc:     Nadav Amit <nadav.amit@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v2] io-wq: fix race between worker exiting and activating free
 worker
Message-ID: <f4f81bd0-a897-4409-f09a-a768b5a3c6c5@kernel.dk>
Date:   Wed, 4 Aug 2021 14:00:23 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Nadav correctly reports that we have a race between a worker exiting,
and new work being queued. This can lead to work being queued behind
an existing worker that could be sleeping on an event before it can
run to completion, and hence introducing potential big latency gaps
if we hit this race condition:

cpu0                                    cpu1
----                                    ----
                                        io_wqe_worker()
                                        schedule_timeout()
                                         // timed out
io_wqe_enqueue()
io_wqe_wake_worker()
// work_flags & IO_WQ_WORK_CONCURRENT
io_wqe_activate_free_worker()
                                         io_worker_exit()

Fix this by having the exiting worker go through the normal decrement
of a running worker, which will spawn a new one if needed.

The free worker activation is modified to only return success if we
were able to find a sleeping worker - if not, we keep looking through
the list. If we fail, we create a new worker as per usual.

Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/io-uring/BFF746C0-FEDE-4646-A253-3021C57C26C9@gmail.com/
Reported-by: Nadav Amit <nadav.amit@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io-wq.c b/fs/io-wq.c
index cf086b01c6c6..50dc93ffc153 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -130,6 +130,7 @@ struct io_cb_cancel_data {
 };
 
 static void create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index);
+static void io_wqe_dec_running(struct io_worker *worker);
 
 static bool io_worker_get(struct io_worker *worker)
 {
@@ -168,26 +169,21 @@ static void io_worker_exit(struct io_worker *worker)
 {
 	struct io_wqe *wqe = worker->wqe;
 	struct io_wqe_acct *acct = io_wqe_get_acct(worker);
-	unsigned flags;
 
 	if (refcount_dec_and_test(&worker->ref))
 		complete(&worker->ref_done);
 	wait_for_completion(&worker->ref_done);
 
-	preempt_disable();
-	current->flags &= ~PF_IO_WORKER;
-	flags = worker->flags;
-	worker->flags = 0;
-	if (flags & IO_WORKER_F_RUNNING)
-		atomic_dec(&acct->nr_running);
-	worker->flags = 0;
-	preempt_enable();
-
 	raw_spin_lock_irq(&wqe->lock);
-	if (flags & IO_WORKER_F_FREE)
+	if (worker->flags & IO_WORKER_F_FREE)
 		hlist_nulls_del_rcu(&worker->nulls_node);
 	list_del_rcu(&worker->all_list);
 	acct->nr_workers--;
+	preempt_disable();
+	io_wqe_dec_running(worker);
+	worker->flags = 0;
+	current->flags &= ~PF_IO_WORKER;
+	preempt_enable();
 	raw_spin_unlock_irq(&wqe->lock);
 
 	kfree_rcu(worker, rcu);
@@ -214,15 +210,19 @@ static bool io_wqe_activate_free_worker(struct io_wqe *wqe)
 	struct hlist_nulls_node *n;
 	struct io_worker *worker;
 
-	n = rcu_dereference(hlist_nulls_first_rcu(&wqe->free_list));
-	if (is_a_nulls(n))
-		return false;
-
-	worker = hlist_nulls_entry(n, struct io_worker, nulls_node);
-	if (io_worker_get(worker)) {
-		wake_up_process(worker->task);
+	/*
+	 * Iterate free_list and see if we can find an idle worker to
+	 * activate. If a given worker is on the free_list but in the process
+	 * of exiting, keep trying.
+	 */
+	hlist_nulls_for_each_entry_rcu(worker, n, &wqe->free_list, nulls_node) {
+		if (!io_worker_get(worker))
+			continue;
+		if (wake_up_process(worker->task)) {
+			io_worker_release(worker);
+			return true;
+		}
 		io_worker_release(worker);
-		return true;
 	}
 
 	return false;

-- 
Jens Axboe

