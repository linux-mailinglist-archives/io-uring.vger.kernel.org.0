Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B50732C995
	for <lists+io-uring@lfdr.de>; Thu,  4 Mar 2021 02:19:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236248AbhCDBJ4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 Mar 2021 20:09:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355471AbhCDAa4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 3 Mar 2021 19:30:56 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AA14C0613E2
        for <io-uring@vger.kernel.org>; Wed,  3 Mar 2021 16:27:08 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id a24so15030499plm.11
        for <io-uring@vger.kernel.org>; Wed, 03 Mar 2021 16:27:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=e+tLZiEVBIwRW/C4OxeE8TZ/VQ3jHzJ+EiIqUJa98HQ=;
        b=ZA1kQxIFCksYFR+FWcsUh5AKtL8OjrYgVr3JlWg8znCefKQZkDom31n3siql9SlgID
         QAiajj+vyBSWPsS0r3xVqkKQTzYIT9zqEK4QxzBRurP2TlF4STyCM7nmXjnKboIauENp
         eLIvh3NR4NPSMlEhbbkiMZNdNxqL/bWfsfI9azhmZMqcX42o7+a5hFdMbhmmp6s8Lqbj
         FVrY6xdyj/Q+WxQ8BIsJaKnsLEVnyTrI9D1iBfU+FqnqeO3u6YFQKLIee+lkv3OFtWij
         i+JljuQXunN07DGBcEb4MHVOrL5RbA/OJl0Qv9Qv6XnEYrRbVfIfVD945Y8su79erQWJ
         7oLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=e+tLZiEVBIwRW/C4OxeE8TZ/VQ3jHzJ+EiIqUJa98HQ=;
        b=tSsfQupvFMMGVJV5CwzEB2uP1Gh6w2oi0BI259dH7lqfyE7DsoXICoVg6BhWXo3EEi
         RbZJcXZqXr8qEjYEf0v6kRgVXd2Vr3qGI8g8P91HSluGvjQqdaJuuRN1fkqeS7MtjaVR
         RBZuc7kReFEmgok2okILmAQtWkYN0L3yZ+TmRr16vYFKyJvfS7OI/F6sdoprmkirHjnn
         AunniCpEXfAGjXKcuXXleyVWN3LhoYZCwwLq46ws5JwyFMcO3R1MHzIWt4IlaZGNZpbX
         LADMrJPvcsKyvrODZV5Qv67O+iAJs/cBO1VunEYYYFtOfT6MzEnYM9BWAZxURjazkMxY
         gEXQ==
X-Gm-Message-State: AOAM530j5TiZFHG4dSY6aNYI7G7BflLniwZKy4SBfFMaCtLpiU+5xyTG
        Lsg2Ln0BB+bGAmks2yRqGoa4vn+TQxHMNRAB
X-Google-Smtp-Source: ABdhPJwTloi67xQCpWmNGkvme5deBjRnsDt8zmeH9yTa+qacBkJERgaDg3yweMP09zZjVoCot2Tstw==
X-Received: by 2002:a17:90a:5206:: with SMTP id v6mr1695763pjh.22.1614817627929;
        Wed, 03 Mar 2021 16:27:07 -0800 (PST)
Received: from localhost.localdomain ([2600:380:7540:52b5:3f01:150c:3b2:bf47])
        by smtp.gmail.com with ESMTPSA id b6sm23456983pgt.69.2021.03.03.16.27.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 16:27:07 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 02/33] io-wq: have manager wait for all workers to exit
Date:   Wed,  3 Mar 2021 17:26:29 -0700
Message-Id: <20210304002700.374417-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210304002700.374417-1-axboe@kernel.dk>
References: <20210304002700.374417-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Instead of having to wait separately on workers and manager, just have
the manager wait on the workers. We use an atomic_t for the reference
here, as we need to start at 0 and allow increment from that. Since the
number of workers is naturally capped by the allowed nr of processes,
and that uses an int, there is no risk of overflow.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io-wq.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 965022fe9961..a61f867f98f4 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -120,6 +120,9 @@ struct io_wq {
 	refcount_t refs;
 	struct completion done;
 
+	atomic_t worker_refs;
+	struct completion worker_done;
+
 	struct hlist_node cpuhp_node;
 
 	pid_t task_pid;
@@ -189,7 +192,8 @@ static void io_worker_exit(struct io_worker *worker)
 	raw_spin_unlock_irq(&wqe->lock);
 
 	kfree_rcu(worker, rcu);
-	io_wq_put(wqe->wq);
+	if (atomic_dec_and_test(&wqe->wq->worker_refs))
+		complete(&wqe->wq->worker_done);
 }
 
 static inline bool io_wqe_run_queue(struct io_wqe *wqe)
@@ -648,14 +652,15 @@ static bool create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index)
 	init_completion(&worker->ref_done);
 	init_completion(&worker->started);
 
-	refcount_inc(&wq->refs);
+	atomic_inc(&wq->worker_refs);
 
 	if (index == IO_WQ_ACCT_BOUND)
 		pid = io_wq_fork_thread(task_thread_bound, worker);
 	else
 		pid = io_wq_fork_thread(task_thread_unbound, worker);
 	if (pid < 0) {
-		io_wq_put(wq);
+		if (atomic_dec_and_test(&wq->worker_refs))
+			complete(&wq->worker_done);
 		kfree(worker);
 		return false;
 	}
@@ -753,6 +758,9 @@ static int io_wq_manager(void *data)
 	} while (!test_bit(IO_WQ_BIT_EXIT, &wq->state));
 
 	io_wq_check_workers(wq);
+	/* we might not ever have created any workers */
+	if (atomic_read(&wq->worker_refs))
+		wait_for_completion(&wq->worker_done);
 	wq->manager = NULL;
 	io_wq_put(wq);
 	do_exit(0);
@@ -796,6 +804,7 @@ static int io_wq_fork_manager(struct io_wq *wq)
 	if (wq->manager)
 		return 0;
 
+	reinit_completion(&wq->worker_done);
 	clear_bit(IO_WQ_BIT_EXIT, &wq->state);
 	refcount_inc(&wq->refs);
 	current->flags |= PF_IO_WORKER;
@@ -1050,6 +1059,9 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 	init_completion(&wq->done);
 	refcount_set(&wq->refs, 1);
 
+	init_completion(&wq->worker_done);
+	atomic_set(&wq->worker_refs, 0);
+
 	ret = io_wq_fork_manager(wq);
 	if (!ret)
 		return wq;
-- 
2.30.1

