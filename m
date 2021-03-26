Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5746134ABE1
	for <lists+io-uring@lfdr.de>; Fri, 26 Mar 2021 16:52:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230409AbhCZPwO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Mar 2021 11:52:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230470AbhCZPwF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Mar 2021 11:52:05 -0400
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 539ACC0613B1
        for <io-uring@vger.kernel.org>; Fri, 26 Mar 2021 08:52:05 -0700 (PDT)
Received: by mail-il1-x131.google.com with SMTP id t6so5380258ilp.11
        for <io-uring@vger.kernel.org>; Fri, 26 Mar 2021 08:52:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2mAmxL/kkU5P2p4/GNsVO44FMkgxyU8s5QHvaqUZUn8=;
        b=UiPFxEcNXGdHzMJvXUv5dHcIiKqFHUT5CvVH7tlB7pv5EfO93D7/fRDE8iJ4x3HI57
         8Y7CrCde/Co4TH0jsIv8OC+m/0fBeui0uMAbCZCkk9RHM55gII3tog6KrdEf061FYwKO
         7+oZDIJZoUzznCdr7DZo6QeA4unSTb+nQqV2MX3t3QnmEU2O5yUj4vMSe41k7umvS6Ye
         bo8395n8p8FCi3APT50OsW/xoNDcD1M8KS4Z9TyAhchVZ9PnoXcR4Ls3kdviLzQsTEnn
         DtMOgg2H+t18zIPbNiahlsyrzPvpDEXcs6R9xVTxAXsmgHA4IB2Xqfld5txRED+sp4Ux
         /OzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2mAmxL/kkU5P2p4/GNsVO44FMkgxyU8s5QHvaqUZUn8=;
        b=HwZmgcx4iMn/B8QQ8PvpZlAqN+CsQ9L4vvdj3WabPt+lp4F8yLVoQ3mudYXReITRbL
         iz3OZOw/pa5nqvLeDXf3WIncNLWgI0j2KbXkibuLX7J32k2ydTcSQVzyOFaUTvynX4uo
         Bub8dL3pV6C+pWXvLzh5WlFCavl2EvNVRYMmWrGql0A+DbQrMmtn5NO82ibRUe3J7UJq
         BDtSw2p05qRU0zMnapwNrapR0p/fbLsHv0Os9Q0f45mEAScMCWxZc1+lbq8xS1NLkamS
         vW3JqDOdJvauoAGgqRXINQ7suQQzGogE9ffHYxyx7iA8YsWQ9LxW68mV7Gr6pFwz9tjP
         Myqg==
X-Gm-Message-State: AOAM533/lV8K+LvfeLp7WanaIBwTDu/pVGB0KJBC4iWePiSElHLR2em1
        1CCZdgjACLYq2PXAX4x2tBmVc1equ1znTw==
X-Google-Smtp-Source: ABdhPJxXt5U9gZ0BK/E9O0HuDrXXe2n0VRgav8rbbzQZAW8xOD3QsOfQSz0QSYEmpe6bp3Jw/HrY9g==
X-Received: by 2002:a05:6e02:4b2:: with SMTP id e18mr10044121ils.42.1616773924539;
        Fri, 26 Mar 2021 08:52:04 -0700 (PDT)
Received: from p1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id a7sm4456337ilj.64.2021.03.26.08.52.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Mar 2021 08:52:04 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     torvalds@linux-foundation.org, ebiederm@xmission.com,
        metze@samba.org, oleg@redhat.com, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/7] io_uring: handle signals for IO threads like a normal thread
Date:   Fri, 26 Mar 2021 09:51:15 -0600
Message-Id: <20210326155128.1057078-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210326155128.1057078-1-axboe@kernel.dk>
References: <20210326155128.1057078-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We go through various hoops to disallow signals for the IO threads, but
there's really no reason why we cannot just allow them. The IO threads
never return to userspace like a normal thread, and hence don't go through
normal signal processing. Instead, just check for a pending signal as part
of the work loop, and call get_signal() to handle it for us if anything
is pending.

With that, we can support receiving signals, including special ones like
SIGSTOP.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io-wq.c    | 24 +++++++++++++++++-------
 fs/io_uring.c | 12 ++++++++----
 2 files changed, 25 insertions(+), 11 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index b7c1fa932cb3..3e2f059a1737 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -16,7 +16,6 @@
 #include <linux/rculist_nulls.h>
 #include <linux/cpu.h>
 #include <linux/tracehook.h>
-#include <linux/freezer.h>
 
 #include "../kernel/sched/sched.h"
 #include "io-wq.h"
@@ -503,10 +502,16 @@ static int io_wqe_worker(void *data)
 		if (io_flush_signals())
 			continue;
 		ret = schedule_timeout(WORKER_IDLE_TIMEOUT);
-		if (try_to_freeze() || ret)
+		if (signal_pending(current)) {
+			struct ksignal ksig;
+
+			if (fatal_signal_pending(current))
+				break;
+			if (get_signal(&ksig))
+				continue;
+		}
+		if (ret)
 			continue;
-		if (fatal_signal_pending(current))
-			break;
 		/* timed out, exit unless we're the fixed worker */
 		if (test_bit(IO_WQ_BIT_EXIT, &wq->state) ||
 		    !(worker->flags & IO_WORKER_F_FIXED))
@@ -714,9 +719,14 @@ static int io_wq_manager(void *data)
 		set_current_state(TASK_INTERRUPTIBLE);
 		io_wq_check_workers(wq);
 		schedule_timeout(HZ);
-		try_to_freeze();
-		if (fatal_signal_pending(current))
-			set_bit(IO_WQ_BIT_EXIT, &wq->state);
+		if (signal_pending(current)) {
+			struct ksignal ksig;
+
+			if (fatal_signal_pending(current))
+				set_bit(IO_WQ_BIT_EXIT, &wq->state);
+			else if (get_signal(&ksig))
+				continue;
+		}
 	} while (!test_bit(IO_WQ_BIT_EXIT, &wq->state));
 
 	io_wq_check_workers(wq);
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 54ea561db4a5..350418a88db3 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -78,7 +78,6 @@
 #include <linux/task_work.h>
 #include <linux/pagemap.h>
 #include <linux/io_uring.h>
-#include <linux/freezer.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/io_uring.h>
@@ -6765,8 +6764,14 @@ static int io_sq_thread(void *data)
 			timeout = jiffies + sqd->sq_thread_idle;
 			continue;
 		}
-		if (fatal_signal_pending(current))
-			break;
+		if (signal_pending(current)) {
+			struct ksignal ksig;
+
+			if (fatal_signal_pending(current))
+				break;
+			if (get_signal(&ksig))
+				continue;
+		}
 		sqt_spin = false;
 		cap_entries = !list_is_singular(&sqd->ctx_list);
 		list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
@@ -6809,7 +6814,6 @@ static int io_sq_thread(void *data)
 
 			mutex_unlock(&sqd->lock);
 			schedule();
-			try_to_freeze();
 			mutex_lock(&sqd->lock);
 			list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
 				io_ring_clear_wakeup_flag(ctx);
-- 
2.31.0

