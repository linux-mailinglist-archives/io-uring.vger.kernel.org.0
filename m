Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CA00334BDB
	for <lists+io-uring@lfdr.de>; Wed, 10 Mar 2021 23:45:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233942AbhCJWop (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 10 Mar 2021 17:44:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233889AbhCJWoa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 10 Mar 2021 17:44:30 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02A87C061574
        for <io-uring@vger.kernel.org>; Wed, 10 Mar 2021 14:44:30 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id lr10-20020a17090b4b8ab02900dd61b95c5eso5807018pjb.4
        for <io-uring@vger.kernel.org>; Wed, 10 Mar 2021 14:44:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LOD7UCLzdZv/GvvaVFLkBbpbgKjkQPfHEN9JWmlIG48=;
        b=MJU01lKlNTNHWyJdVSk+BjYXgXBC+8/FbSqBIoycFQaI6CX/94w6goYl6enoNIwfLH
         mpEQ2Ou7TH2dBI3ym9DADpDPoqdeRplBqCHya5SGSN4vbPmUi2F8I1hLJ1OuNjjRaguk
         h1RIf1swreFyHb6idLyqdaqU79HMOg1SgV6wbEyhz5tV4vzvCF0PdZxleUbwtCLJuo19
         umGaNl7isTBuVvwxjWdZkLf5iVOleq3fjJWl/Q1ENDvXMeFPd9H5lyQEC8WAikfgYny6
         xEppnQ3DErIVoQyM5U9elS+dOziXL2nS4QbYfxCSOlkwwnB8naNeT5jZyrjYMw8WOecE
         oV4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LOD7UCLzdZv/GvvaVFLkBbpbgKjkQPfHEN9JWmlIG48=;
        b=FVcomeXcK5m7XSTod/DlpA2ZzbUiySftaX2TK+B5eh3EFPlg6KJtHPDT0DrYW+guyH
         G86ZzGUNNK96FZLjXvsuQTORqQh6R/mIlNbt11HKO7kG9Vv7IP9M/EOED7PoAwlfEQ06
         bMhMz3Axc+E6NybgJXQR3XOia8QTbokebOLFz8xTw2nDTueKnvHw0dJIuG3ED0nQJXmz
         sPHT9tw0+Z+65hmaXAnPX3lSyCX5UYtoQUV5yZ6KK/5I8aIX4mQ9cNvBB7DLAAMExoX7
         sJdrogQ+QGVhIoFcAZAFS5PlmKr6c/ygdHPqGaHhuAdY37qInuy/VIqFs20jhpFyl+z5
         jaZw==
X-Gm-Message-State: AOAM531VcUmEXzw2+e6qP398fkNjLQYDTrAkMFcthHslp5gh5sSPXSXa
        W2vHBZ84a/842dphlok1HplK+lsI4CuiqQ==
X-Google-Smtp-Source: ABdhPJy3gY8g1whwmsbJlpeimMamzwPNNv72UAAeVgw+stOqYQkW9XcgvdgAd6me5TY4nY+/9UkTlg==
X-Received: by 2002:a17:90a:1fcc:: with SMTP id z12mr5640344pjz.65.1615416269278;
        Wed, 10 Mar 2021 14:44:29 -0800 (PST)
Received: from localhost.localdomain ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id j23sm475783pfn.94.2021.03.10.14.44.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 14:44:28 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Kevin Locke <kevin@kevinlocke.name>
Subject: [PATCH 25/27] kernel: make IO threads unfreezable by default
Date:   Wed, 10 Mar 2021 15:43:56 -0700
Message-Id: <20210310224358.1494503-26-axboe@kernel.dk>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210310224358.1494503-1-axboe@kernel.dk>
References: <20210310224358.1494503-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The io-wq threads were already marked as no-freeze, but the manager was
not. On resume, we perpetually have signal_pending() being true, and
hence the manager will loop and spin 100% of the time.

Just mark the tasks created by create_io_thread() as PF_NOFREEZE by
default, and remove any knowledge of it in io-wq and io_uring.

Reported-by: Kevin Locke <kevin@kevinlocke.name>
Tested-by: Kevin Locke <kevin@kevinlocke.name>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io-wq.c    | 3 +--
 fs/io_uring.c | 1 -
 kernel/fork.c | 1 +
 3 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 3d7060ba547a..0ae9ecadf295 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -591,7 +591,7 @@ static bool create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index)
 	tsk->pf_io_worker = worker;
 	worker->task = tsk;
 	set_cpus_allowed_ptr(tsk, cpumask_of_node(wqe->node));
-	tsk->flags |= PF_NOFREEZE | PF_NO_SETAFFINITY;
+	tsk->flags |= PF_NO_SETAFFINITY;
 
 	raw_spin_lock_irq(&wqe->lock);
 	hlist_nulls_add_head_rcu(&worker->nulls_node, &wqe->free_list);
@@ -709,7 +709,6 @@ static int io_wq_manager(void *data)
 		set_current_state(TASK_INTERRUPTIBLE);
 		io_wq_check_workers(wq);
 		schedule_timeout(HZ);
-		try_to_freeze();
 		if (fatal_signal_pending(current))
 			set_bit(IO_WQ_BIT_EXIT, &wq->state);
 	} while (!test_bit(IO_WQ_BIT_EXIT, &wq->state));
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 62f998bf2ce8..14165e18020c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6733,7 +6733,6 @@ static int io_sq_thread(void *data)
 
 			up_read(&sqd->rw_lock);
 			schedule();
-			try_to_freeze();
 			down_read(&sqd->rw_lock);
 			list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
 				io_ring_clear_wakeup_flag(ctx);
diff --git a/kernel/fork.c b/kernel/fork.c
index d3171e8e88e5..72e444cd0ffe 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2436,6 +2436,7 @@ struct task_struct *create_io_thread(int (*fn)(void *), void *arg, int node)
 	if (!IS_ERR(tsk)) {
 		sigfillset(&tsk->blocked);
 		sigdelsetmask(&tsk->blocked, sigmask(SIGKILL));
+		tsk->flags |= PF_NOFREEZE;
 	}
 	return tsk;
 }
-- 
2.30.2

