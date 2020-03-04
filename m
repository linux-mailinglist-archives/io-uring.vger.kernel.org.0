Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C32CA179111
	for <lists+io-uring@lfdr.de>; Wed,  4 Mar 2020 14:15:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388108AbgCDNPR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 4 Mar 2020 08:15:17 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:37321 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387992AbgCDNPQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 4 Mar 2020 08:15:16 -0500
Received: by mail-wm1-f65.google.com with SMTP id a141so1829186wme.2;
        Wed, 04 Mar 2020 05:15:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=4MRxcOtUBZRfL8XeDiKqHk9pIsUgKAvPhPg7wgLoFXY=;
        b=gJaFgFl64uvl+2cI+O7bTfcmGvwwmZ+bN5fm7BsJ22AP+gfZpSCPqXoC19n78UY2B8
         TjFyj+x7IApCZ1XPt7yO1I+ZMcQuFoPG0PjUig3/tOgMoVDMPisE/PF5gHVvEZJ4ZGBy
         bxBJ/Lg1NaPkjpanadBl50l/fZH7ail7Xas1w7NLbwmt0tUJ8v8jTVicKS8AMNTrd+Xp
         C4iGCuZ0FjHRwkZcKo/FHZH13n8bmhdPChxsAUQXhdUKBr1A14QctPItj4/Cf5kV7y+H
         F2ovnGhj136FkPlP8ks9RoyhuS/BWO/q1SCks+Y5egnFPfMJexk8BBPNQ3g6ufnDpdbr
         jTPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4MRxcOtUBZRfL8XeDiKqHk9pIsUgKAvPhPg7wgLoFXY=;
        b=Tt0Q2gM+xiNomjCgHe/F/p3sS64GPzysoa8YezOPbM/DX4D3Z1kDExNeKTZSzo0nsV
         ItYA/C7RpILeWrBkn6fOrlr/EmZoXmAFrQU7X8gw1u+kElg/GI2nZrv69tRQf3K0fljN
         zsB2+9E1TlNphPQ2FuBvUpPAaSSoglJ2C0/l6JCkUpND8G6xfiCr/bydapaWagrm8M78
         JjsuuapSnHysHmDraUnmRnetPLh3mU7+mfDRMemFvLFD1d57ksY10MLMXxUYHUVU1vUl
         mNn7JHYeXtMfGhIdQZ40E772UM/MJZxywZnXkrpXofq5VahW1SDZUOAGGKcXDPSEzNyJ
         O1GA==
X-Gm-Message-State: ANhLgQ0ZFP2RChtAmS5gKMqaoa4WJwU/RPJ1z5azPMa5Z15xi3NYVIDL
        FdWhIOzl5A7xnGGXFK5DPn38hMYi
X-Google-Smtp-Source: ADFU+vsSKMJwO2ZYSrzPZD93NHqDSNFufTwcu5qEEwVMRazdnxqyBHAgCpT4lMmvHipnW3vFY/oLjQ==
X-Received: by 2002:a1c:ba87:: with SMTP id k129mr3719703wmf.102.1583327713411;
        Wed, 04 Mar 2020 05:15:13 -0800 (PST)
Received: from localhost.localdomain ([109.126.130.242])
        by smtp.gmail.com with ESMTPSA id c14sm24746746wro.36.2020.03.04.05.15.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2020 05:15:13 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] io-wq: shuffle io_worker_handle_work() code
Date:   Wed,  4 Mar 2020 16:14:09 +0300
Message-Id: <3b47f33c640d19d197e19ec566a619f21a7b1df4.1583314087.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1583314087.git.asml.silence@gmail.com>
References: <cover.1583314087.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is a preparation patch, it adds some helpers and makes
the next patches cleaner.

- extract io_impersonate_work() and io_assign_current_work()
- replace @next label with nested do-while
- move put_work() right after NULL'ing cur_work.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io-wq.c | 123 ++++++++++++++++++++++++++++-------------------------
 1 file changed, 64 insertions(+), 59 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 042c7e2057ef..e438dc4d7cb3 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -440,14 +440,43 @@ static void io_wq_switch_creds(struct io_worker *worker,
 		worker->saved_creds = old_creds;
 }
 
+static void io_impersonate_work(struct io_worker *worker,
+				struct io_wq_work *work)
+{
+	if (work->files && current->files != work->files) {
+		task_lock(current);
+		current->files = work->files;
+		task_unlock(current);
+	}
+	if (work->fs && current->fs != work->fs)
+		current->fs = work->fs;
+	if (work->mm != worker->mm)
+		io_wq_switch_mm(worker, work);
+	if (worker->cur_creds != work->creds)
+		io_wq_switch_creds(worker, work);
+}
+
+static void io_assign_current_work(struct io_worker *worker,
+				   struct io_wq_work *work)
+{
+	/* flush pending signals before assigning new work */
+	if (signal_pending(current))
+		flush_signals(current);
+	cond_resched();
+
+	spin_lock_irq(&worker->lock);
+	worker->cur_work = work;
+	spin_unlock_irq(&worker->lock);
+}
+
 static void io_worker_handle_work(struct io_worker *worker)
 	__releases(wqe->lock)
 {
-	struct io_wq_work *work, *old_work = NULL, *put_work = NULL;
 	struct io_wqe *wqe = worker->wqe;
 	struct io_wq *wq = wqe->wq;
 
 	do {
+		struct io_wq_work *work, *old_work;
 		unsigned hash = -1U;
 
 		/*
@@ -464,69 +493,45 @@ static void io_worker_handle_work(struct io_worker *worker)
 			wqe->flags |= IO_WQE_FLAG_STALLED;
 
 		spin_unlock_irq(&wqe->lock);
-		if (put_work && wq->put_work)
-			wq->put_work(old_work);
 		if (!work)
 			break;
-next:
-		/* flush any pending signals before assigning new work */
-		if (signal_pending(current))
-			flush_signals(current);
-
-		cond_resched();
 
-		spin_lock_irq(&worker->lock);
-		worker->cur_work = work;
-		spin_unlock_irq(&worker->lock);
-
-		if (work->files && current->files != work->files) {
-			task_lock(current);
-			current->files = work->files;
-			task_unlock(current);
-		}
-		if (work->fs && current->fs != work->fs)
-			current->fs = work->fs;
-		if (work->mm != worker->mm)
-			io_wq_switch_mm(worker, work);
-		if (worker->cur_creds != work->creds)
-			io_wq_switch_creds(worker, work);
-		/*
-		 * OK to set IO_WQ_WORK_CANCEL even for uncancellable work,
-		 * the worker function will do the right thing.
-		 */
-		if (test_bit(IO_WQ_BIT_CANCEL, &wq->state))
-			work->flags |= IO_WQ_WORK_CANCEL;
-
-		if (wq->get_work) {
-			put_work = work;
-			wq->get_work(work);
-		}
-
-		old_work = work;
-		work->func(&work);
-
-		spin_lock_irq(&worker->lock);
-		worker->cur_work = NULL;
-		spin_unlock_irq(&worker->lock);
-
-		spin_lock_irq(&wqe->lock);
-
-		if (hash != -1U) {
-			wqe->hash_map &= ~BIT(hash);
-			wqe->flags &= ~IO_WQE_FLAG_STALLED;
-		}
-		if (work && work != old_work) {
-			spin_unlock_irq(&wqe->lock);
-
-			if (put_work && wq->put_work) {
-				wq->put_work(put_work);
-				put_work = NULL;
+		/* handle a whole dependent link */
+		do {
+			io_assign_current_work(worker, work);
+			io_impersonate_work(worker, work);
+
+			/*
+			 * OK to set IO_WQ_WORK_CANCEL even for uncancellable
+			 * work, the worker function will do the right thing.
+			 */
+			if (test_bit(IO_WQ_BIT_CANCEL, &wq->state))
+				work->flags |= IO_WQ_WORK_CANCEL;
+
+			if (wq->get_work)
+				wq->get_work(work);
+
+			old_work = work;
+			work->func(&work);
+
+			spin_lock_irq(&worker->lock);
+			worker->cur_work = NULL;
+			spin_unlock_irq(&worker->lock);
+
+			if (wq->put_work)
+				wq->put_work(old_work);
+
+			if (hash != -1U) {
+				spin_lock_irq(&wqe->lock);
+				wqe->hash_map &= ~BIT_ULL(hash);
+				wqe->flags &= ~IO_WQE_FLAG_STALLED;
+				spin_unlock_irq(&wqe->lock);
+				/* dependent work is not hashed */
+				hash = -1U;
 			}
+		} while (work && work != old_work);
 
-			/* dependent work not hashed */
-			hash = -1U;
-			goto next;
-		}
+		spin_lock_irq(&wqe->lock);
 	} while (1);
 }
 
-- 
2.24.0

