Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C91D392AB2
	for <lists+io-uring@lfdr.de>; Thu, 27 May 2021 11:26:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235754AbhE0J1r (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 27 May 2021 05:27:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235720AbhE0J1p (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 27 May 2021 05:27:45 -0400
Received: from mail-ed1-x549.google.com (mail-ed1-x549.google.com [IPv6:2a00:1450:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7186C061574
        for <io-uring@vger.kernel.org>; Thu, 27 May 2021 02:26:12 -0700 (PDT)
Received: by mail-ed1-x549.google.com with SMTP id d8-20020a0564020008b0290387d38e3ce0so22970edu.1
        for <io-uring@vger.kernel.org>; Thu, 27 May 2021 02:26:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=tpMhr1a1ucqmSn8aEv/I+3Jaj5nsK3OJYJ5e/mt9yGY=;
        b=Q/vJeL9sXW+UWiU6U9hHz5sKys3i1VhTtuYfdmDOH6LWAJv59c7xS+WCzSmCqg2YYY
         oWgTSehjunfrSUIU9EvVXy+QBtMvEcc54tDlaraHYWHHR+Ub0ShwT0O+odW2IfZFZH+X
         LsaLOuJk+QZtLb07YaaF+ZpjF1d9LWfPowMGmtkeUXB+BwxP9oxHvBU7DyANkveEESI9
         xEYfQFccuWJOV3H/lLV33lDC/8VOP9eON2h8UK+IWLIPgIh/1O3QSpmNGGwF9LfW2rNo
         FLvtC/+C6Ks0XV5ljtiUfzZaPd5jgzusKowd/LtQU5mxdEdSBbshbyxdmiQSJcZxJGfQ
         GOAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=tpMhr1a1ucqmSn8aEv/I+3Jaj5nsK3OJYJ5e/mt9yGY=;
        b=ZaWr/oDEiHrSN6mI+OiTn+eJGDEwt9ZAecgjnJSU3ppZLi28aG9nNc3g7RCtZhot9R
         LNtWaAg3rwjv92Ov6kEwIVH25C42lyf4jK2G9qa38+C7cm3KR8YTITSmksknwXYEBhwT
         lNgI5KITzVLpiLG+ghm6YEYaYAnEzI5MdGuprhb2NFhwTs4JRr7r2eho6+bWV/PK0iE4
         cA/vsHwbjXi16tZ2V9Ri6jUxfGcJ4tj0VM7uc2IYj9310tVCBhpM3CkM2merguDtizuF
         K6puuTgZ4k82oY3oc2RVcDwzvM+1+D+inTQahCuBclOiiZBHY1+6UJ7VsaFpDsykStM4
         XHbA==
X-Gm-Message-State: AOAM530+0ivmS+FpCRlLmEZP9pfqOgNk9oeoaMdadQCdav+/bGh2KJRy
        w091uHT+PlWnZEQrytud64S8IE1m8Q==
X-Google-Smtp-Source: ABdhPJwS22Uj3FevXMnn8SahWbj0DRGcRuuq40bhjwiCfiDB3avakTHDTJL97/K5kl0wbB02hTCVF50nhg==
X-Received: from elver.muc.corp.google.com ([2a00:79e0:15:13:74ba:ff42:8494:7f35])
 (user=elver job=sendgmr) by 2002:a05:6402:1c97:: with SMTP id
 cy23mr3063078edb.213.1622107570950; Thu, 27 May 2021 02:26:10 -0700 (PDT)
Date:   Thu, 27 May 2021 11:25:48 +0200
Message-Id: <20210527092547.2656514-1-elver@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.1.818.g46aad6cb9e-goog
Subject: [PATCH] io_uring: fix data race to avoid potential NULL-deref
From:   Marco Elver <elver@google.com>
To:     elver@google.com, axboe@kernel.dk, asml.silence@gmail.com,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     kasan-dev@googlegroups.com, dvyukov@google.com,
        syzbot+bf2b3d0435b9b728946c@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Commit ba5ef6dc8a82 ("io_uring: fortify tctx/io_wq cleanup") introduced
setting tctx->io_wq to NULL a bit earlier. This has caused KCSAN to
detect a data race between accesses to tctx->io_wq:

  write to 0xffff88811d8df330 of 8 bytes by task 3709 on cpu 1:
   io_uring_clean_tctx                  fs/io_uring.c:9042 [inline]
   __io_uring_cancel                    fs/io_uring.c:9136
   io_uring_files_cancel                include/linux/io_uring.h:16 [inline]
   do_exit                              kernel/exit.c:781
   do_group_exit                        kernel/exit.c:923
   get_signal                           kernel/signal.c:2835
   arch_do_signal_or_restart            arch/x86/kernel/signal.c:789
   handle_signal_work                   kernel/entry/common.c:147 [inline]
   exit_to_user_mode_loop               kernel/entry/common.c:171 [inline]
   ...
  read to 0xffff88811d8df330 of 8 bytes by task 6412 on cpu 0:
   io_uring_try_cancel_iowq             fs/io_uring.c:8911 [inline]
   io_uring_try_cancel_requests         fs/io_uring.c:8933
   io_ring_exit_work                    fs/io_uring.c:8736
   process_one_work                     kernel/workqueue.c:2276
   ...

With the config used, KCSAN only reports data races with value changes:
this implies that in the case here we also know that tctx->io_wq was
non-NULL. Therefore, depending on interleaving, we may end up with:

              [CPU 0]                 |        [CPU 1]
  io_uring_try_cancel_iowq()          | io_uring_clean_tctx()
    if (!tctx->io_wq) // false        |   ...
    ...                               |   tctx->io_wq = NULL
    io_wq_cancel_cb(tctx->io_wq, ...) |   ...
      -> NULL-deref                   |

Note: It is likely that thus far we've gotten lucky and the compiler
optimizes the double-read into a single read into a register -- but this
is never guaranteed, and can easily change with a different config!

Fix the data race by restoring the previous behaviour, where both
setting io_wq to NULL and put of the wq are _serialized_ after
concurrent io_uring_try_cancel_iowq() via acquisition of the uring_lock
and removal of the node in io_uring_del_task_file().

Fixes: ba5ef6dc8a82 ("io_uring: fortify tctx/io_wq cleanup")
Suggested-by: Pavel Begunkov <asml.silence@gmail.com>
Reported-by: syzbot+bf2b3d0435b9b728946c@syzkaller.appspotmail.com
Signed-off-by: Marco Elver <elver@google.com>
Cc: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5f82954004f6..08830b954fbf 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -9039,11 +9039,16 @@ static void io_uring_clean_tctx(struct io_uring_task *tctx)
 	struct io_tctx_node *node;
 	unsigned long index;
 
-	tctx->io_wq = NULL;
 	xa_for_each(&tctx->xa, index, node)
 		io_uring_del_task_file(index);
-	if (wq)
+	if (wq) {
+		/*
+		 * Must be after io_uring_del_task_file() (removes nodes under
+		 * uring_lock) to avoid race with io_uring_try_cancel_iowq().
+		 */
+		tctx->io_wq = NULL;
 		io_wq_put_and_exit(wq);
+	}
 }
 
 static s64 tctx_inflight(struct io_uring_task *tctx, bool tracked)
-- 
2.31.1.818.g46aad6cb9e-goog

