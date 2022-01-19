Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65CED493310
	for <lists+io-uring@lfdr.de>; Wed, 19 Jan 2022 03:42:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351013AbiASCmr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 18 Jan 2022 21:42:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348845AbiASCmq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 Jan 2022 21:42:46 -0500
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC89CC061574
        for <io-uring@vger.kernel.org>; Tue, 18 Jan 2022 18:42:46 -0800 (PST)
Received: by mail-il1-x136.google.com with SMTP id r3so504128iln.3
        for <io-uring@vger.kernel.org>; Tue, 18 Jan 2022 18:42:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YzFioeRyxYSHuJZTk+fMuFAm6/7muWsw15E44yY09A0=;
        b=jjJtbko1id7Yut4uMx9L3VEkceJVyKgkPLTUIeW8brD73Yexbpiuz6rxoB7RitaTC9
         bOC7SXknFoEm1rlc73yW4837WIoKnF4QJCGZqv35NAYMFj47IS4SHFpEMpAiMNt1sLmr
         54Y7GIEz7JoGuvlSg1+QOMmyc6Gjob6DqtGBvdRhttfQq8EOkThenX8Q2X9h+3T1IIzl
         0CjFB69cac+bL+KdASXfkpAbwisVQ60ShbJ/oaYztbpa9nFe7t9AHuQhLuKznwerW9Cu
         CCRVFtBkn88UHWk6yDCg98oJ48vTUaq08MYmKF7R8m1bXMIcjnZ45B02a8ELPxs5x0zo
         /kEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YzFioeRyxYSHuJZTk+fMuFAm6/7muWsw15E44yY09A0=;
        b=C3WSrXwtuLIJ6s4CzwO4KiLB+FayqGg96bNo199ttCf7OxsQ2sOmsZTgZC2nKpr2c/
         lMDtqBHRRzwc4WjaWGoUD5Z+BcC9hCfAoB17fPuT7TFVFQGE4JYoBLNze1PTyS2Vg3Kh
         BqgtbshnXncTZMObtAEJrIaDNg489IUqDxsczp1V6ZaF12xxjxnIcX8DTkHvV6AQ4s0a
         fNyymQmsr6BZ7ch/owiHQzT1Jwq0b/nnYLDOTRoHxGVFBrNASBWgOSzuxo2EBTqjuQTG
         cTx6oCDnLPU1WyMnARZlb2/nJ/3r3/phxGQCqASFos6/2U3qjOnKVicLBSq5JtkC1NS7
         PdUw==
X-Gm-Message-State: AOAM532kW39PQKRNman8q1fjZTuaTIEXJoMMhOz5TDE6Qj/+I03ro40D
        +Vah7VvxK2M4hHafCQBr4F61605bWGWTHA==
X-Google-Smtp-Source: ABdhPJy3iTMwaZl1vWu9ZcxBi48QlisiWWst2vKyPZmVLE9zW6jA+Xlh4SHS6zVO4wqedRJ3iLlDnQ==
X-Received: by 2002:a05:6e02:1a0a:: with SMTP id s10mr16200643ild.217.1642560166067;
        Tue, 18 Jan 2022 18:42:46 -0800 (PST)
Received: from localhost.localdomain ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id v5sm9863704ile.72.2022.01.18.18.42.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jan 2022 18:42:45 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/6] io-wq: make io_worker lock a raw spinlock
Date:   Tue, 18 Jan 2022 19:42:37 -0700
Message-Id: <20220119024241.609233-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220119024241.609233-1-axboe@kernel.dk>
References: <20220119024241.609233-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

In preparation to nesting it under the wqe lock (which is raw due to
being acquired from the scheduler side), change the io_worker lock from
a normal spinlock to a raw spinlock.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io-wq.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index f8a5f172b9eb..c369910de793 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -48,7 +48,7 @@ struct io_worker {
 	struct io_wqe *wqe;
 
 	struct io_wq_work *cur_work;
-	spinlock_t lock;
+	raw_spinlock_t lock;
 
 	struct completion ref_done;
 
@@ -528,9 +528,9 @@ static void io_assign_current_work(struct io_worker *worker,
 		cond_resched();
 	}
 
-	spin_lock(&worker->lock);
+	raw_spin_lock(&worker->lock);
 	worker->cur_work = work;
-	spin_unlock(&worker->lock);
+	raw_spin_unlock(&worker->lock);
 }
 
 static void io_wqe_enqueue(struct io_wqe *wqe, struct io_wq_work *work);
@@ -814,7 +814,7 @@ static bool create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index)
 
 	refcount_set(&worker->ref, 1);
 	worker->wqe = wqe;
-	spin_lock_init(&worker->lock);
+	raw_spin_lock_init(&worker->lock);
 	init_completion(&worker->ref_done);
 
 	if (index == IO_WQ_ACCT_BOUND)
@@ -980,13 +980,13 @@ static bool io_wq_worker_cancel(struct io_worker *worker, void *data)
 	 * Hold the lock to avoid ->cur_work going out of scope, caller
 	 * may dereference the passed in work.
 	 */
-	spin_lock(&worker->lock);
+	raw_spin_lock(&worker->lock);
 	if (worker->cur_work &&
 	    match->fn(worker->cur_work, match->data)) {
 		set_notify_signal(worker->task);
 		match->nr_running++;
 	}
-	spin_unlock(&worker->lock);
+	raw_spin_unlock(&worker->lock);
 
 	return match->nr_running && !match->cancel_all;
 }
-- 
2.34.1

