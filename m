Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 947C232C9AF
	for <lists+io-uring@lfdr.de>; Thu,  4 Mar 2021 02:19:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241660AbhCDBKV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 Mar 2021 20:10:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1451110AbhCDAfx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 3 Mar 2021 19:35:53 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F487C05BD41
        for <io-uring@vger.kernel.org>; Wed,  3 Mar 2021 16:27:44 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id a23so7819005pga.8
        for <io-uring@vger.kernel.org>; Wed, 03 Mar 2021 16:27:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=smVAzKobfUVUatAmffBRUPKqSPJl+/IoHD2tUPYZ31o=;
        b=U0ZdI+V45Z1wffkGKHiuOAoswxMv67D+eyOO/sgWzlZ9P7nEaKyEIQSHhtY+/+PrNP
         ddBZD8kKWqtyo23fK/y7uPNtP9hKG44C+XSrvJg7WhzQjfdyNRhClIeCmtkWddJeUd3L
         E34NqpUu+r0XD9L7WeVrp6YdotzHoJhAuLCBUHE7juKxG9VztMDpS48p65LcwoVu5IGD
         ZZak2Lf+I8K9jwuD9tvZaZTYG3pR2UxBVLwh6DrIwKNBi3yDlqnXnMK+k/Z+hjWoIcnr
         qOWoJ2c9MOLpp7BLlnDNCh1JwYkie3HtgrF/Sbd2NuUltSBZ4sduHX6YajxpMNhrUXgD
         MbPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=smVAzKobfUVUatAmffBRUPKqSPJl+/IoHD2tUPYZ31o=;
        b=kASOSKWA/rLnd5sN+VPiVsNtKRp0HitBmS5nmhyp5P8S4LBM/bdWPtSOPHPRFljj+J
         lRLpzNsW31U5vn1p8kNXwCupO5xVB+4DF55nN/19lUWcKHFvoTq8XrMHnq9GlJ0RUsPZ
         PMgRZKPdcir+2Hy4An1cTDE++d+irP+yHP6voyGPsA0BVWVbSa2ToRUjvGkDGFGgxZmW
         ridCD5aB2J1MfAotKNcg8Onwkkjj6UCb8uG3VXUpOCU6ubMER2wMHbpkyo8+AdH9kjmf
         1zQ0b4GEfrouU6idwK2n76f5v8bX6ziRGNP14mTjzDNPgP/GnJxbJLIzLAPYyhcDrb4h
         cp3w==
X-Gm-Message-State: AOAM532ei6Cr3dRq5zOPaYfBHzADwqc5F2legsljn2YajKjRqe+bFzTn
        VTGKnAbP8mQETcjqwkmIu0W7Cac2GFCGj7Jr
X-Google-Smtp-Source: ABdhPJyTdILvqNcSBHlE2rGxseYBIeWFthUyd2eKrCc+tjc8SXX2o0+BkJ+4dzAyb1+pTc/sZpOVaQ==
X-Received: by 2002:aa7:8a11:0:b029:1ee:42d8:a8f5 with SMTP id m17-20020aa78a110000b02901ee42d8a8f5mr1381283pfa.5.1614817663880;
        Wed, 03 Mar 2021 16:27:43 -0800 (PST)
Received: from localhost.localdomain ([2600:380:7540:52b5:3f01:150c:3b2:bf47])
        by smtp.gmail.com with ESMTPSA id b6sm23456983pgt.69.2021.03.03.16.27.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 16:27:43 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Alex Xu <alex_y_xu@yahoo.ca>
Subject: [PATCH 32/33] io_uring: ensure that threads freeze on suspend
Date:   Wed,  3 Mar 2021 17:26:59 -0700
Message-Id: <20210304002700.374417-33-axboe@kernel.dk>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210304002700.374417-1-axboe@kernel.dk>
References: <20210304002700.374417-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Alex reports that his system fails to suspend using 5.12-rc1, with the
following dump:

[  240.650300] PM: suspend entry (deep)
[  240.650748] Filesystems sync: 0.000 seconds
[  240.725605] Freezing user space processes ...
[  260.739483] Freezing of tasks failed after 20.013 seconds (3 tasks refusing to freeze, wq_busy=0):
[  260.739497] task:iou-mgr-446     state:S stack:    0 pid:  516 ppid:   439 flags:0x00004224
[  260.739504] Call Trace:
[  260.739507]  ? sysvec_apic_timer_interrupt+0xb/0x81
[  260.739515]  ? pick_next_task_fair+0x197/0x1cde
[  260.739519]  ? sysvec_reschedule_ipi+0x2f/0x6a
[  260.739522]  ? asm_sysvec_reschedule_ipi+0x12/0x20
[  260.739525]  ? __schedule+0x57/0x6d6
[  260.739529]  ? del_timer_sync+0xb9/0x115
[  260.739533]  ? schedule+0x63/0xd5
[  260.739536]  ? schedule_timeout+0x219/0x356
[  260.739540]  ? __next_timer_interrupt+0xf1/0xf1
[  260.739544]  ? io_wq_manager+0x73/0xb1
[  260.739549]  ? io_wq_create+0x262/0x262
[  260.739553]  ? ret_from_fork+0x22/0x30
[  260.739557] task:iou-mgr-517     state:S stack:    0 pid:  522 ppid:   439 flags:0x00004224
[  260.739561] Call Trace:
[  260.739563]  ? sysvec_apic_timer_interrupt+0xb/0x81
[  260.739566]  ? pick_next_task_fair+0x16f/0x1cde
[  260.739569]  ? sysvec_apic_timer_interrupt+0xb/0x81
[  260.739571]  ? asm_sysvec_apic_timer_interrupt+0x12/0x20
[  260.739574]  ? __schedule+0x5b7/0x6d6
[  260.739578]  ? del_timer_sync+0x70/0x115
[  260.739581]  ? schedule_timeout+0x211/0x356
[  260.739585]  ? __next_timer_interrupt+0xf1/0xf1
[  260.739588]  ? io_wq_check_workers+0x15/0x11f
[  260.739592]  ? io_wq_manager+0x69/0xb1
[  260.739596]  ? io_wq_create+0x262/0x262
[  260.739600]  ? ret_from_fork+0x22/0x30
[  260.739603] task:iou-wrk-517     state:S stack:    0 pid:  523 ppid:   439 flags:0x00004224
[  260.739607] Call Trace:
[  260.739609]  ? __schedule+0x5b7/0x6d6
[  260.739614]  ? schedule+0x63/0xd5
[  260.739617]  ? schedule_timeout+0x219/0x356
[  260.739621]  ? __next_timer_interrupt+0xf1/0xf1
[  260.739624]  ? task_thread.isra.0+0x148/0x3af
[  260.739628]  ? task_thread_unbound+0xa/0xa
[  260.739632]  ? task_thread_bound+0x7/0x7
[  260.739636]  ? ret_from_fork+0x22/0x30
[  260.739647] OOM killer enabled.
[  260.739648] Restarting tasks ... done.
[  260.740077] PM: suspend exit

Play nice and ensure that any thread we create will call try_to_freeze()
at an opportune time so that memory suspend can proceed. For the io-wq
worker threads, mark them as PF_NOFREEZE. They could potentially be
blocked for a long time.

Reported-by: Alex Xu (Hello71) <alex_y_xu@yahoo.ca>
Tested-by: Alex Xu (Hello71) <alex_y_xu@yahoo.ca>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io-wq.c    | 3 +++
 fs/io_uring.c | 5 ++---
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 1fdb2b621b51..a44bd22c045e 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -16,6 +16,7 @@
 #include <linux/rculist_nulls.h>
 #include <linux/cpu.h>
 #include <linux/tracehook.h>
+#include <linux/freezer.h>
 
 #include "../kernel/sched/sched.h"
 #include "io-wq.h"
@@ -263,6 +264,7 @@ static void io_wqe_dec_running(struct io_worker *worker)
 
 static void io_worker_start(struct io_worker *worker)
 {
+	current->flags |= PF_NOFREEZE;
 	worker->flags |= (IO_WORKER_F_UP | IO_WORKER_F_RUNNING);
 	io_wqe_inc_running(worker);
 	complete(&worker->started);
@@ -731,6 +733,7 @@ static int io_wq_manager(void *data)
 		set_current_state(TASK_INTERRUPTIBLE);
 		io_wq_check_workers(wq);
 		schedule_timeout(HZ);
+		try_to_freeze();
 		if (fatal_signal_pending(current))
 			set_bit(IO_WQ_BIT_EXIT, &wq->state);
 	} while (!test_bit(IO_WQ_BIT_EXIT, &wq->state));
diff --git a/fs/io_uring.c b/fs/io_uring.c
index d9161b181a21..7cf8d4a99d91 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -74,13 +74,11 @@
 #include <linux/fsnotify.h>
 #include <linux/fadvise.h>
 #include <linux/eventpoll.h>
-#include <linux/fs_struct.h>
 #include <linux/splice.h>
 #include <linux/task_work.h>
 #include <linux/pagemap.h>
 #include <linux/io_uring.h>
-#include <linux/blk-cgroup.h>
-#include <linux/audit.h>
+#include <linux/freezer.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/io_uring.h>
@@ -6736,6 +6734,7 @@ static int io_sq_thread(void *data)
 				io_ring_set_wakeup_flag(ctx);
 
 			schedule();
+			try_to_freeze();
 			list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
 				io_ring_clear_wakeup_flag(ctx);
 		}
-- 
2.30.1

