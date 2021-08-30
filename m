Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D39C73FBB61
	for <lists+io-uring@lfdr.de>; Mon, 30 Aug 2021 20:03:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238440AbhH3SEL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 30 Aug 2021 14:04:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238335AbhH3SEH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 30 Aug 2021 14:04:07 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2F51C061575
        for <io-uring@vger.kernel.org>; Mon, 30 Aug 2021 11:03:13 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id m11so12704053ioo.6
        for <io-uring@vger.kernel.org>; Mon, 30 Aug 2021 11:03:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=l7CIamEdtq2mCiMSUK//3jVKMcyqAOrvF0FjTsDM3Rc=;
        b=ssDJBl+YNn0V62bx4CHnEQT4Se7prx+1KTyhIckhMiLARjhAmH0M08XhbVy4htrvNb
         z4N5/Roq2zN3Uri2QekYU962dWDnuPtiABSIeb2hx05B/trVEtZypkvjvtlsZPkYlYd7
         1CWFvD/Z0dqEhwzmbnFyFKBwTL5SDgAUR67Mz64/XZZU6BEQ9hP+uR3vDQoDFuC5sdfO
         mYDLYEW/miqiT0uZXz5enk/PxPD6B6h8wPEEyxwTxBTJedmtV3ywQk5ouaczY5BSFAXA
         V1SLhefIoXWTBaVHP+KFqXtcbohp0EE36HCJIyaINt9VHxz+FoEqWQcm8VpoVVOOhKR9
         Fy7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=l7CIamEdtq2mCiMSUK//3jVKMcyqAOrvF0FjTsDM3Rc=;
        b=L80D/ooL8j6HYeK0z8MF6xmyz4+zY2LWgcLLZ9Dm57aJgSw1Yh9cF88wHOwQRTxQh4
         F0Py4SCu1k+mXyuUvKPsQD7RipzRImLfHh18x9Id5bCsKO7CK9dB0/KaIBqvq1n5b+tW
         iDqt3Gc7XuWVb+oPz2pSzp0AZken3ScUXf2uZj9Xe8AjW2H+Ru+i7wn6vPTcuGn/WjHz
         qezuF/eQlKX0t6Okm5HYe3dET5rQND2WVGhlel1gI5lPO6Ljpw3XRhtcSH7ypSIebLk0
         RLEUn/9wBhgKmJMg80nHk0FJDoBFvZa5pZyTqfP3IfeuLYTDCC1bq+g7D2THQL8q2M3e
         cuEw==
X-Gm-Message-State: AOAM533yXCZ0kYIbu8sqFCrNzgdfQC1u92/jv3MtSFEe3sMJT8/IBnNe
        F2+AHVSQDVD/PTooQFtkEQOhEf+lGsAtOw==
X-Google-Smtp-Source: ABdhPJw0FUq69EPIojsDbX/yvMJS0p+eqt+dfxp7NB52w/id/X8T4L6Lw7rCX4JkL3VK/pnYYbiaHQ==
X-Received: by 2002:a6b:b883:: with SMTP id i125mr18634806iof.144.1630346592956;
        Mon, 30 Aug 2021 11:03:12 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id g14sm8648473ila.28.2021.08.30.11.03.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Aug 2021 11:03:12 -0700 (PDT)
To:     io-uring <io-uring@vger.kernel.org>
Cc:     Andres Freund <andres@anarazel.de>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io-wq: fix race between adding work and activating a free
 worker
Message-ID: <a6150a72-f7ec-acf3-2420-154c80ec0fa8@kernel.dk>
Date:   Mon, 30 Aug 2021 12:03:12 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The attempt to find and activate a free worker for new work is currently
combined with creating a new one if we don't find one, but that opens
io-wq up to a race where the worker that is found and activated can
put itself to sleep without knowing that it has been selected to perform
this new work.

Fix this by moving the activation into where we add the new work item,
then we can retain it within the wqe->lock scope and elimiate the race
with the worker itself checking inside the lock, but sleeping outside of
it.

Cc: stable@vger.kernel.org
Reported-by: Andres Freund <andres@anarazel.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

The previously posted fix for a race when adding new work was fine, but
there's another gap here that is actually bigger. This one passes my
synthetic testing (limit max workers to 1, do buffered writes to a
file).

diff --git a/fs/io-wq.c b/fs/io-wq.c
index cd9bd095fb1b..709cbe8191af 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -236,9 +236,9 @@ static bool io_wqe_activate_free_worker(struct io_wqe *wqe)
  * We need a worker. If we find a free one, we're good. If not, and we're
  * below the max number of workers, create one.
  */
-static void io_wqe_wake_worker(struct io_wqe *wqe, struct io_wqe_acct *acct)
+static void io_wqe_create_worker(struct io_wqe *wqe, struct io_wqe_acct *acct)
 {
-	bool ret;
+	bool do_create = false, first = false;
 
 	/*
 	 * Most likely an attempt to queue unbounded work on an io_wq that
@@ -247,26 +247,18 @@ static void io_wqe_wake_worker(struct io_wqe *wqe, struct io_wqe_acct *acct)
 	if (unlikely(!acct->max_workers))
 		pr_warn_once("io-wq is not configured for unbound workers");
 
-	rcu_read_lock();
-	ret = io_wqe_activate_free_worker(wqe);
-	rcu_read_unlock();
-
-	if (!ret) {
-		bool do_create = false, first = false;
-
-		raw_spin_lock(&wqe->lock);
-		if (acct->nr_workers < acct->max_workers) {
-			if (!acct->nr_workers)
-				first = true;
-			acct->nr_workers++;
-			do_create = true;
-		}
-		raw_spin_unlock(&wqe->lock);
-		if (do_create) {
-			atomic_inc(&acct->nr_running);
-			atomic_inc(&wqe->wq->worker_refs);
-			create_io_worker(wqe->wq, wqe, acct->index, first);
-		}
+	raw_spin_lock(&wqe->lock);
+	if (acct->nr_workers < acct->max_workers) {
+		if (!acct->nr_workers)
+			first = true;
+		acct->nr_workers++;
+		do_create = true;
+	}
+	raw_spin_unlock(&wqe->lock);
+	if (do_create) {
+		atomic_inc(&acct->nr_running);
+		atomic_inc(&wqe->wq->worker_refs);
+		create_io_worker(wqe->wq, wqe, acct->index, first);
 	}
 }
 
@@ -794,7 +786,7 @@ static void io_wqe_insert_work(struct io_wqe *wqe, struct io_wq_work *work)
 static void io_wqe_enqueue(struct io_wqe *wqe, struct io_wq_work *work)
 {
 	struct io_wqe_acct *acct = io_work_get_acct(wqe, work);
-	bool do_wake;
+	bool do_create;
 
 	/*
 	 * If io-wq is exiting for this task, or if the request has explicitly
@@ -809,12 +801,15 @@ static void io_wqe_enqueue(struct io_wqe *wqe, struct io_wq_work *work)
 	raw_spin_lock(&wqe->lock);
 	io_wqe_insert_work(wqe, work);
 	wqe->flags &= ~IO_WQE_FLAG_STALLED;
-	do_wake = (work->flags & IO_WQ_WORK_CONCURRENT) ||
-			!atomic_read(&acct->nr_running);
+
+	rcu_read_lock();
+	do_create = !io_wqe_activate_free_worker(wqe);
+	rcu_read_unlock();
+
 	raw_spin_unlock(&wqe->lock);
 
-	if (do_wake)
-		io_wqe_wake_worker(wqe, acct);
+	if (do_create)
+		io_wqe_create_worker(wqe, acct);
 }
 
 void io_wq_enqueue(struct io_wq *wq, struct io_wq_work *work)

-- 
Jens Axboe

