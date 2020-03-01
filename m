Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AA69174E4A
	for <lists+io-uring@lfdr.de>; Sun,  1 Mar 2020 17:19:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726970AbgCAQTq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 1 Mar 2020 11:19:46 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:42925 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726627AbgCAQTq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 1 Mar 2020 11:19:46 -0500
Received: by mail-wr1-f66.google.com with SMTP id z11so652476wro.9;
        Sun, 01 Mar 2020 08:19:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=UGEbxdRDa0bt4CDoWlQyGQdUddEOs/B4sJuAgVESUWs=;
        b=hSMyRrB6rCbYbMVaxcwL8lUD397Cm2zrw7RshdWkB3Cwcot7Z0p0Lk5b4b++9KieHy
         kM8cS+ryk6B2uWKlPG1XVz5r4psuElloUbjZ85w5B3iJCc5rtxIOh+jPuSynFRZWFfJ/
         z6+xX+LKIy/OBGycT1ySEjnwP3oMk61Gob464WJlI5UASRZuR24y/lTpqAggodgEVncP
         fhMXE07F61rjUmrdg/R5vkDjdp5Vh2ZU6ht8042ByFD08uf68u9tjSI05l5Ixz9s9dVD
         WrNehsytSm16c30167L8W8EDhvH4C2+e23BoiyWZkSC4lzNCzykqkhELTAmWMJibNjxL
         YomA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UGEbxdRDa0bt4CDoWlQyGQdUddEOs/B4sJuAgVESUWs=;
        b=oDfR2lPH3x6USwiv0eUexwbrVf2wRK3y26DYyA5j/VPCjBG/T5/xxLWx8tTqwyedaT
         oAi8P0Q5NzQrKyrb0RhT7mvU1wDkCRaAGqXtIXil4ZnbJ51AwNhBA/MY18lcoGrqU8Ti
         3Me0dZb6k/UcSulnfOBgk7lkp6elpzzX/fLlfIfFlMeu9XLIkwoZVIah1nbVfZAw5rpC
         oOSSjb9DzzDERIqBBc+jrUWs83f4O/IQ5MkgOdSHlSpqT0dvSZRtfV+uWaBv9aBsYVav
         r6havnAfmj+VJ7IRHG91BGV9rbVK+fpEwrTbIpJClgML23bF869BxpZePnH/idg3c52b
         XpWA==
X-Gm-Message-State: APjAAAVtEiOzeFRZuhSobkuy3G/Yk45kGazSXZmbEvW2uVBUZuF/3UMt
        MuefstHowNqX7fd67k7XLdDKhsfe
X-Google-Smtp-Source: APXvYqy+nM2e2XRj+Q8u7DJngPsdbnIBw67osRtVxsaXbOBuHo5MExBw3f7I4PdVAtR+V/m+kCVryA==
X-Received: by 2002:adf:cc85:: with SMTP id p5mr16733152wrj.196.1583079582379;
        Sun, 01 Mar 2020 08:19:42 -0800 (PST)
Received: from localhost.localdomain ([109.126.130.242])
        by smtp.gmail.com with ESMTPSA id q9sm15864741wrn.8.2020.03.01.08.19.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Mar 2020 08:19:42 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6/9] io-wq: shuffle io_worker_handle_work() code
Date:   Sun,  1 Mar 2020 19:18:23 +0300
Message-Id: <47b40b0490cee89827b7237d76aeb0dfebc27e61.1583078091.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1583078091.git.asml.silence@gmail.com>
References: <cover.1583078091.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is a preparation patch and doesn't change much, but makes next
patches cleaner.

- extract io_impersonate_work() and io_assign_current_work()
- replace @next label with nested do-while
- move put_work() right after NULL'ing cur_work.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io-wq.c | 125 ++++++++++++++++++++++++++++-------------------------
 1 file changed, 66 insertions(+), 59 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index f74a105ab968..3a97d35b569e 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -440,15 +440,45 @@ static void io_wq_switch_creds(struct io_worker *worker,
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
+		bool is_internal;
 
 		/*
 		 * If we got some work, mark us as busy. If we didn't, but
@@ -464,69 +494,46 @@ static void io_worker_handle_work(struct io_worker *worker)
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
-		if (wq->get_work && !(work->flags & IO_WQ_WORK_INTERNAL)) {
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
+			is_internal = work->flags & IO_WQ_WORK_INTERNAL;
+			if (wq->get_work && !is_internal)
+				wq->get_work(work);
+
+			old_work = work;
+			work->func(&work);
+
+			spin_lock_irq(&worker->lock);
+			worker->cur_work = NULL;
+			spin_unlock_irq(&worker->lock);
+
+			if (wq->put_work && !is_internal)
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

