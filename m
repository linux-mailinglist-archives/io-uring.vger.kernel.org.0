Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BEC43FF421
	for <lists+io-uring@lfdr.de>; Thu,  2 Sep 2021 21:25:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347379AbhIBT0a (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 2 Sep 2021 15:26:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347326AbhIBT01 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 2 Sep 2021 15:26:27 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62539C061575
        for <io-uring@vger.kernel.org>; Thu,  2 Sep 2021 12:25:28 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id z2so2991287iln.0
        for <io-uring@vger.kernel.org>; Thu, 02 Sep 2021 12:25:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sgsKbRX0gP4pygNtc3vxlM3yTha56UOeyGUyK7pJ9fQ=;
        b=VNbjZmIUqOlLYX7DiIWO0Zb/xGTDK+gh0iqks7Kb5sg2QuzAUB3iHhITH4YaxNighx
         BCHYskfrgRds47gyWW8QfQEOxByZ1xDgfoz7c3JJnOvaNYWY3Bh+MHqcxq6RodchU8AT
         nplfwj0Vbl7bGyMtw+rlcqNgWH5UMv2W36lzfstaVGPdOgC1LAUsl3Mvf4xiwResPRU4
         6MYGR7zz7TO64Nrn8V0HBRhVsue6CWfoIjby1uYJvr6QbT8F+xhQFjNuk3yFNjuy0wZ7
         sINGqN60d8fy8OEBGfVAAbKvCvfrJ6NCLpAoOlMkKlgxGjyBtmXUizIJ2+iDZWhEBUYA
         ZfoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sgsKbRX0gP4pygNtc3vxlM3yTha56UOeyGUyK7pJ9fQ=;
        b=r1kbqTeHDTjRqLIsO41xRtpVgKdrCaBMlMb5W0b6yaUUm8fssH7HzFO6Gbet96e44h
         zRMHR5MgTeG1GLPEoBrzwCkMZYw7x1OcdRva3HnwLpUuV0CB8zTPAASa0KauZmswag3f
         m9cqKnCU0EO1t0L6NYkXv1A2n5LfME/kOYiMBMK9di4lV7rJ7hNPoOQp+ZSGrMP1iwzk
         PwNYYq2v4DmLSb2DPVVmvyaDHdL1m1WO6KNTX9KP6GV19Kn69sfRlgvO1L/LZ+JcPUTE
         SzATDsbPqjcD6Jy2+Ryv740TzrOGXhrjHiw0ddEcDPCXn+Jg17jcKsuNc/PQOxgNkn6k
         iwVA==
X-Gm-Message-State: AOAM532CSQ5IUxZLbFAcdpZI0Fa9P0P3niqP0b2Gjk2IVm88l7/+QV1Z
        RNHlbu/9fL6R3YkrTUePJukGjaEi5BqstA==
X-Google-Smtp-Source: ABdhPJxREtBEekZM7OOJez6F/l2aL4ZGhMwUxP2659cPRAWzam7kkCT3WPWWG8DZbzKPzHZ3LBsKOA==
X-Received: by 2002:a05:6e02:174a:: with SMTP id y10mr3634766ill.121.1630610727578;
        Thu, 02 Sep 2021 12:25:27 -0700 (PDT)
Received: from p1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id g12sm1399406iok.32.2021.09.02.12.25.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 12:25:27 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/5] io-wq: get rid of FIXED worker flag
Date:   Thu,  2 Sep 2021 13:25:19 -0600
Message-Id: <20210902192520.326283-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210902192520.326283-1-axboe@kernel.dk>
References: <20210902192520.326283-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

It makes the logic easier to follow if we just get rid of the fixed worker
flag, and simply ensure that we never exit the last worker in the group.
This also means that no particular worker is special.

Just track the last timeout state, and if we have hit it and no work
is pending, check if there are other workers. If yes, then we can exit
this one safely.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io-wq.c | 35 ++++++++++++++++-------------------
 1 file changed, 16 insertions(+), 19 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 027eb4e13e3b..50ea07764a99 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -23,8 +23,7 @@ enum {
 	IO_WORKER_F_UP		= 1,	/* up and active */
 	IO_WORKER_F_RUNNING	= 2,	/* account as running */
 	IO_WORKER_F_FREE	= 4,	/* worker on free list */
-	IO_WORKER_F_FIXED	= 8,	/* static idle worker */
-	IO_WORKER_F_BOUND	= 16,	/* is doing bounded work */
+	IO_WORKER_F_BOUND	= 8,	/* is doing bounded work */
 };
 
 enum {
@@ -132,7 +131,7 @@ struct io_cb_cancel_data {
 	bool cancel_all;
 };
 
-static void create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index, bool first);
+static void create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index);
 static void io_wqe_dec_running(struct io_worker *worker);
 
 static bool io_worker_get(struct io_worker *worker)
@@ -241,7 +240,7 @@ static bool io_wqe_activate_free_worker(struct io_wqe *wqe,
  */
 static void io_wqe_create_worker(struct io_wqe *wqe, struct io_wqe_acct *acct)
 {
-	bool do_create = false, first = false;
+	bool do_create = false;
 
 	/*
 	 * Most likely an attempt to queue unbounded work on an io_wq that
@@ -252,8 +251,6 @@ static void io_wqe_create_worker(struct io_wqe *wqe, struct io_wqe_acct *acct)
 
 	raw_spin_lock(&wqe->lock);
 	if (acct->nr_workers < acct->max_workers) {
-		if (!acct->nr_workers)
-			first = true;
 		acct->nr_workers++;
 		do_create = true;
 	}
@@ -261,7 +258,7 @@ static void io_wqe_create_worker(struct io_wqe *wqe, struct io_wqe_acct *acct)
 	if (do_create) {
 		atomic_inc(&acct->nr_running);
 		atomic_inc(&wqe->wq->worker_refs);
-		create_io_worker(wqe->wq, wqe, acct->index, first);
+		create_io_worker(wqe->wq, wqe, acct->index);
 	}
 }
 
@@ -278,7 +275,7 @@ static void create_worker_cb(struct callback_head *cb)
 	struct io_wq *wq;
 	struct io_wqe *wqe;
 	struct io_wqe_acct *acct;
-	bool do_create = false, first = false;
+	bool do_create = false;
 
 	worker = container_of(cb, struct io_worker, create_work);
 	wqe = worker->wqe;
@@ -286,14 +283,12 @@ static void create_worker_cb(struct callback_head *cb)
 	acct = &wqe->acct[worker->create_index];
 	raw_spin_lock(&wqe->lock);
 	if (acct->nr_workers < acct->max_workers) {
-		if (!acct->nr_workers)
-			first = true;
 		acct->nr_workers++;
 		do_create = true;
 	}
 	raw_spin_unlock(&wqe->lock);
 	if (do_create) {
-		create_io_worker(wq, wqe, worker->create_index, first);
+		create_io_worker(wq, wqe, worker->create_index);
 	} else {
 		atomic_dec(&acct->nr_running);
 		io_worker_ref_put(wq);
@@ -548,6 +543,7 @@ static int io_wqe_worker(void *data)
 	struct io_wqe_acct *acct = io_wqe_get_acct(worker);
 	struct io_wqe *wqe = worker->wqe;
 	struct io_wq *wq = wqe->wq;
+	bool last_timeout = false;
 	char buf[TASK_COMM_LEN];
 
 	worker->flags |= (IO_WORKER_F_UP | IO_WORKER_F_RUNNING);
@@ -565,6 +561,13 @@ static int io_wqe_worker(void *data)
 			io_worker_handle_work(worker);
 			goto loop;
 		}
+		/* timed out, exit unless we're the last worker */
+		if (last_timeout && acct->nr_workers > 1) {
+			raw_spin_unlock(&wqe->lock);
+			__set_current_state(TASK_RUNNING);
+			break;
+		}
+		last_timeout = false;
 		__io_worker_idle(wqe, worker);
 		raw_spin_unlock(&wqe->lock);
 		if (io_flush_signals())
@@ -579,11 +582,7 @@ static int io_wqe_worker(void *data)
 				break;
 			continue;
 		}
-		if (ret)
-			continue;
-		/* timed out, exit unless we're the fixed worker */
-		if (!(worker->flags & IO_WORKER_F_FIXED))
-			break;
+		last_timeout = !ret;
 	}
 
 	if (test_bit(IO_WQ_BIT_EXIT, &wq->state)) {
@@ -634,7 +633,7 @@ void io_wq_worker_sleeping(struct task_struct *tsk)
 	raw_spin_unlock(&worker->wqe->lock);
 }
 
-static void create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index, bool first)
+static void create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index)
 {
 	struct io_wqe_acct *acct = &wqe->acct[index];
 	struct io_worker *worker;
@@ -675,8 +674,6 @@ static void create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index, bo
 	worker->flags |= IO_WORKER_F_FREE;
 	if (index == IO_WQ_ACCT_BOUND)
 		worker->flags |= IO_WORKER_F_BOUND;
-	if (first && (worker->flags & IO_WORKER_F_BOUND))
-		worker->flags |= IO_WORKER_F_FIXED;
 	raw_spin_unlock(&wqe->lock);
 	wake_up_new_task(tsk);
 }
-- 
2.33.0

