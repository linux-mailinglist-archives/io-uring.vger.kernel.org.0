Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1285016EA6C
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2020 16:47:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729553AbgBYPrf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 25 Feb 2020 10:47:35 -0500
Received: from mail-il1-f193.google.com ([209.85.166.193]:38411 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729386AbgBYPrf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 25 Feb 2020 10:47:35 -0500
Received: by mail-il1-f193.google.com with SMTP id f5so11201059ilq.5
        for <io-uring@vger.kernel.org>; Tue, 25 Feb 2020 07:47:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=NJ9ZB3x5EusKPedEP8k69cKpBStrdbihTdCVOKPB8tQ=;
        b=r7hj85bE3YM7BKji/vM4T5vVw1aHaeUuMl4O/7QV67eyJ3bC8xbfEBOWxtghEXt3Ja
         8VsMZPkqa0LY7J01KPXB/bOYrlreht0aetRqyadyN18HlikPEDHyc8pBd6bgtN7rGgCN
         WO6J2nYWewNz1urVz5A4dqJDiKKsQDdzoBcqw9a393UVGAPMiWTYF3z01j2CzaMgMu2n
         AnU/Sgowu5tPU4MDuj/24/wSNlCrSWrVnNY6QAeMApDP+y1xfVkwaQ01xDew4DTtWo9J
         ZCmCLKqevWefv8pzN3Bmn9VIafMcRwCowM6mLmNOym5ciN1uHwcc6gZ/ty3epOiHI5CN
         PQag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=NJ9ZB3x5EusKPedEP8k69cKpBStrdbihTdCVOKPB8tQ=;
        b=bHi+Thc20TJnhn05fBVJ/5u0nLebwQwfyKIS4uVR/+QoGtaIKHp5uYtd8qR4pRP6Y4
         /bH5BOglwEqzxtYyIcsTIc98ohkENdWJXO5kI08R+48RxA1Q+8I39TW8iZS5I7Ts+xKP
         n3BU33iCGx+1McCAuRdecz0rb9J2t5pPQdQRbuk5W/s3BZhBexvIo4oe4pQ6SIwEd+DJ
         0pKDGO4wFe+icjZah6cdAkIDPbQqSimaXUI1fVqqZxhmij3chtQv0wJGVbl6SbCVQSrA
         Z3229cEfDQ0/pwZIgJDb0omnEPqjmdJInDJlKiGjsQ39UDZW6uOr1zdpqafH+LpdbWYq
         4l5A==
X-Gm-Message-State: APjAAAWGTOXi+uMiWkQZpG1E0q7JcC4P8KEjm4BTFEwKgUNSqGYJQVeJ
        q2w7gWF/Y0n7KKR9LcvJ4nAIWYiQfzU=
X-Google-Smtp-Source: APXvYqzYdc5eRYlBmkTPoZZIMSeOu8JV8AjIIWZJbEEPZItVliwLZDvGMhk3R+N3NjtTIkGaOt/low==
X-Received: by 2002:a92:dac3:: with SMTP id o3mr70781678ilq.237.1582645653202;
        Tue, 25 Feb 2020 07:47:33 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id v3sm5661884ili.0.2020.02.25.07.47.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Feb 2020 07:47:32 -0800 (PST)
To:     io-uring <io-uring@vger.kernel.org>
Cc:     Andres Freund <andres@anarazel.de>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io-wq: remove spin-for-work optimization
Message-ID: <13210add-5356-9c02-3430-4fe92fe0b32c@kernel.dk>
Date:   Tue, 25 Feb 2020 08:47:30 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Andres reports that buffered IO seems to suck up more cycles than we
would like, and he narrowed it down to the fact that the io-wq workers
will briefly spin for more work on completion of a work item. This was
a win on the networking side, but apparently some other cases take a
hit because of it. Remove the optimization to avoid burning more CPU
than we have to for disk IO.

Reported-by: Andres Freund <andres@anarazel.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 0a5ab1a8f69a..bf8ed1b0b90a 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -535,42 +535,23 @@ static void io_worker_handle_work(struct io_worker *worker)
 	} while (1);
 }
 
-static inline void io_worker_spin_for_work(struct io_wqe *wqe)
-{
-	int i = 0;
-
-	while (++i < 1000) {
-		if (io_wqe_run_queue(wqe))
-			break;
-		if (need_resched())
-			break;
-		cpu_relax();
-	}
-}
-
 static int io_wqe_worker(void *data)
 {
 	struct io_worker *worker = data;
 	struct io_wqe *wqe = worker->wqe;
 	struct io_wq *wq = wqe->wq;
-	bool did_work;
 
 	io_worker_start(wqe, worker);
 
-	did_work = false;
 	while (!test_bit(IO_WQ_BIT_EXIT, &wq->state)) {
 		set_current_state(TASK_INTERRUPTIBLE);
 loop:
-		if (did_work)
-			io_worker_spin_for_work(wqe);
 		spin_lock_irq(&wqe->lock);
 		if (io_wqe_run_queue(wqe)) {
 			__set_current_state(TASK_RUNNING);
 			io_worker_handle_work(worker);
-			did_work = true;
 			goto loop;
 		}
-		did_work = false;
 		/* drops the lock on success, retry */
 		if (__io_worker_idle(wqe, worker)) {
 			__release(&wqe->lock);

-- 
Jens Axboe

