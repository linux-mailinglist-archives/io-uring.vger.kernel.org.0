Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7234931FD9B
	for <lists+io-uring@lfdr.de>; Fri, 19 Feb 2021 18:13:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbhBSRKn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Feb 2021 12:10:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbhBSRKm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Feb 2021 12:10:42 -0500
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1FD9C0617AB
        for <io-uring@vger.kernel.org>; Fri, 19 Feb 2021 09:10:26 -0800 (PST)
Received: by mail-il1-x12d.google.com with SMTP id e7so5070629ile.7
        for <io-uring@vger.kernel.org>; Fri, 19 Feb 2021 09:10:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nNQxd1/NHLKwpyn8GHFxpBR6gU4WPPWbRgnJEXpOxm4=;
        b=W3hyC2kjL1oAyGVDnNGY0SLtoJjzPqsPSgDr+7n9Ofl5H5x7z7jWMbRhiySW6voQUd
         lvdWiDv9qnspk/8HpbV4B08e7eYj4bKoQ8Wmbv8Ng/8YT+tDNoCFmzR75+L9bZY8R18U
         n+Nv3f+d1EMSgpd67CeO2fTXA5BBtDiJJBZmEtpSbxsgax/Jcnb16SACHbl86IgVQM0v
         Y24tVAiqGoFGnWDE5rgwsCgdc+Vrx/sS20fyq9Ko0xbz9IP8ANpVMHpb975oNDagF537
         vMKckm8airirdFVezcgQ2ucpJXqXNykFL2TqxKK/8/uAixJas1OGkmzm6iwstNjUjJiX
         E0lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nNQxd1/NHLKwpyn8GHFxpBR6gU4WPPWbRgnJEXpOxm4=;
        b=dbQ+BSmdsbUvOE28IOygQSK94JaKz8Sc7ryxZ+eL6qBXYA37nYRuBH986KpO+GHV8L
         sy8ASvDPFfZkhYfO6uYFfVCvk4vplquwsytdnjHuuyolpFBvRAXcuJacYN7kvp/q0qKw
         4fW8dYd7LQbTDdQhRzVZobcKmwChVjt+HNtIeoq4+RkBXkLQ6BCz9MyQ0igmrkqm0YjD
         r2s8OqCayvsoix+B4NzvSCi5LDjnfs5ulfftXz6as9aK9MxRMbMPKURgyIAATaocat49
         /rWjY30RxuTfCCBb11m7yr6RGgCo5cETaP/j8QRXrmhc6eFZrH95oHgPSczzjBcDl9oR
         9R8w==
X-Gm-Message-State: AOAM5303uuTNQxreRC4gNt8gNtIFUlOcOcm4ZNJiqt1jsRHjC+4Z8obv
        NPONAXLOjfZllFikw2uy7TUYWIGEdxB41yvm
X-Google-Smtp-Source: ABdhPJyO4zAdF1MuNNlxLX5E+5rQN2cA7OoHEGwLtvgNKfB3ncMEFcoR3gHE8xtnZbFE57pEphpp8w==
X-Received: by 2002:a05:6e02:18ca:: with SMTP id s10mr4560448ilu.286.1613754625915;
        Fri, 19 Feb 2021 09:10:25 -0800 (PST)
Received: from p1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id o17sm4805431ilo.73.2021.02.19.09.10.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Feb 2021 09:10:25 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     ebiederm@xmission.com, viro@zeniv.linux.org.uk,
        torvalds@linux-foundation.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 10/18] io-wq: worker idling always returns false
Date:   Fri, 19 Feb 2021 10:10:02 -0700
Message-Id: <20210219171010.281878-11-axboe@kernel.dk>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210219171010.281878-1-axboe@kernel.dk>
References: <20210219171010.281878-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Remove the bool return, and the checking for it in the caller.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io-wq.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index b53f569b5b4e..41042119bf0f 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -305,15 +305,13 @@ static void __io_worker_busy(struct io_wqe *wqe, struct io_worker *worker,
  * retry the loop in that case (we changed task state), we don't regrab
  * the lock if we return success.
  */
-static bool __io_worker_idle(struct io_wqe *wqe, struct io_worker *worker)
+static void __io_worker_idle(struct io_wqe *wqe, struct io_worker *worker)
 	__must_hold(wqe->lock)
 {
 	if (!(worker->flags & IO_WORKER_F_FREE)) {
 		worker->flags |= IO_WORKER_F_FREE;
 		hlist_nulls_add_head_rcu(&worker->nulls_node, &wqe->free_list);
 	}
-
-	return false;
 }
 
 static inline unsigned int io_get_work_hash(struct io_wq_work *work)
@@ -454,11 +452,7 @@ static int io_wqe_worker(void *data)
 			io_worker_handle_work(worker);
 			goto loop;
 		}
-		/* drops the lock on success, retry */
-		if (__io_worker_idle(wqe, worker)) {
-			__release(&wqe->lock);
-			goto loop;
-		}
+		__io_worker_idle(wqe, worker);
 		raw_spin_unlock_irq(&wqe->lock);
 		io_flush_signals();
 		if (schedule_timeout(WORKER_IDLE_TIMEOUT))
-- 
2.30.0

