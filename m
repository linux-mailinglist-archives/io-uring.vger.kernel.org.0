Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECC6519DD33
	for <lists+io-uring@lfdr.de>; Fri,  3 Apr 2020 19:52:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727882AbgDCRww (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 3 Apr 2020 13:52:52 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:33142 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728342AbgDCRww (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 3 Apr 2020 13:52:52 -0400
Received: by mail-pf1-f196.google.com with SMTP id c138so3869903pfc.0
        for <io-uring@vger.kernel.org>; Fri, 03 Apr 2020 10:52:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8G2Oq1ldNs46+8KwFtXt1m7UkxmRUJemYj0TfaZ804M=;
        b=wsnI+AXhB4vAkgiUbJn/f6rVPtRZrV1AWCJHHSGbkojG7aOixReyDu0dKaHO8VLk+d
         fGVogIYsdJKt+kb0CtA4NhblupH9KTiuDSl2zNgjIZyXldN70r9X71E0Hds/YQe2XOie
         jEEhwf1IR7J0OpY6y0NPvUGnaN/3fl/Q8r70r1Hi7QEJfS61chRSfQraPbJvJUVTRc0q
         ZZPVmGGfox1G/FMa4RJ38Bnk5wzz1c/SnSfxJIrZRZIgrvB5caIJintrRGuJrhm4djoq
         p2CAIrRIBYrbLQ/xWNlRMMwDPyVo6pbgDulVFKxXpZHUmaGfAmr2/MfHCMlUln9hWXQ5
         sNkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8G2Oq1ldNs46+8KwFtXt1m7UkxmRUJemYj0TfaZ804M=;
        b=s2wZv++CM8EQHFDbAOn5ZzR34+9//vRCh/P1k+fvESu7De0FK2mgUvOcJ4Ef+3wKn3
         T2OletZC1oDN8aTmJw4A44aGqME7NB+52+2Pkc3uQfkJ7O6djwLI89kCxWJdUguoxECX
         3g/kL+QdwvMxH5Z15H8D048RywZo0xSK8IBrGZzv+Jms6gYVTOtwSk5++cdfTrZYb2EC
         u2eNyFKHAAVXVjDObATa43oHjSGtJwPRPRAzwmBWVCm/wzspIQ8XhLgOFGrCW0VYmgNR
         GH8xjAeY1hzPaZbfUtfzukzlTjM4Vpw314Odjei0f2UOccx01npr5JIwcpjelqIeUvwJ
         83YA==
X-Gm-Message-State: AGi0PuaWyCMm/V1TGdNGntqJuudNKQWGbx8r8owPJgdFNRKQWMgdjxIy
        pSfExJOihMli6vke+nv7OIiHvfXITnytCA==
X-Google-Smtp-Source: APiQypLyltUpe3nyBOGDUwsTNl2RXjmAxSSeyPj3HR71AjhsM/PIwDU/QYAg/wAF7bi8nzcsXhA+gw==
X-Received: by 2002:a65:6781:: with SMTP id e1mr8984270pgr.16.1585936370668;
        Fri, 03 Apr 2020 10:52:50 -0700 (PDT)
Received: from x1.localdomain ([2620:10d:c090:400::5:8ed0])
        by smtp.gmail.com with ESMTPSA id f8sm6168449pfq.178.2020.04.03.10.52.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Apr 2020 10:52:50 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Dan Melnic <dmm@fb.com>
Subject: [PATCH 3/3] io_uring: use io-wq manager as backup task if task is exiting
Date:   Fri,  3 Apr 2020 11:52:43 -0600
Message-Id: <20200403175243.14009-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200403175243.14009-1-axboe@kernel.dk>
References: <20200403175243.14009-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If the original task is (or has) exited, then the task work will not get
queued properly. Allow for using the io-wq manager task to queue this
work for execution, and ensure that the io-wq manager notices and runs
this work if woken up (or exiting).

Reported-by: Dan Melnic <dmm@fb.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io-wq.c    | 12 ++++++++++++
 fs/io-wq.h    |  2 ++
 fs/io_uring.c | 13 +++++++++----
 3 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index cc5cf2209fb0..4023c9846860 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -17,6 +17,7 @@
 #include <linux/kthread.h>
 #include <linux/rculist_nulls.h>
 #include <linux/fs_struct.h>
+#include <linux/task_work.h>
 
 #include "io-wq.h"
 
@@ -716,6 +717,9 @@ static int io_wq_manager(void *data)
 	complete(&wq->done);
 
 	while (!kthread_should_stop()) {
+		if (current->task_works)
+			task_work_run();
+
 		for_each_node(node) {
 			struct io_wqe *wqe = wq->wqes[node];
 			bool fork_worker[2] = { false, false };
@@ -738,6 +742,9 @@ static int io_wq_manager(void *data)
 		schedule_timeout(HZ);
 	}
 
+	if (current->task_works)
+		task_work_run();
+
 	return 0;
 err:
 	set_bit(IO_WQ_BIT_ERROR, &wq->state);
@@ -1124,3 +1131,8 @@ void io_wq_destroy(struct io_wq *wq)
 	if (refcount_dec_and_test(&wq->use_refs))
 		__io_wq_destroy(wq);
 }
+
+struct task_struct *io_wq_get_task(struct io_wq *wq)
+{
+	return wq->manager;
+}
diff --git a/fs/io-wq.h b/fs/io-wq.h
index 3ee7356d6be5..5ba12de7572f 100644
--- a/fs/io-wq.h
+++ b/fs/io-wq.h
@@ -136,6 +136,8 @@ typedef bool (work_cancel_fn)(struct io_wq_work *, void *);
 enum io_wq_cancel io_wq_cancel_cb(struct io_wq *wq, work_cancel_fn *cancel,
 					void *data);
 
+struct task_struct *io_wq_get_task(struct io_wq *wq);
+
 #if defined(CONFIG_IO_WQ)
 extern void io_wq_worker_sleeping(struct task_struct *);
 extern void io_wq_worker_running(struct task_struct *);
diff --git a/fs/io_uring.c b/fs/io_uring.c
index b343525a4d2e..2460c3333f70 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4120,6 +4120,7 @@ static int __io_async_wake(struct io_kiocb *req, struct io_poll_iocb *poll,
 			   __poll_t mask, task_work_func_t func)
 {
 	struct task_struct *tsk;
+	int ret;
 
 	/* for instances that support it check for an event match first: */
 	if (mask && !(mask & poll->events))
@@ -4133,11 +4134,15 @@ static int __io_async_wake(struct io_kiocb *req, struct io_poll_iocb *poll,
 	req->result = mask;
 	init_task_work(&req->task_work, func);
 	/*
-	 * If this fails, then the task is exiting. If that is the case, then
-	 * the exit check will ultimately cancel these work items. Hence we
-	 * don't need to check here and handle it specifically.
+	 * If this fails, then the task is exiting. Punt to one of the io-wq
+	 * threads to ensure the work gets run, we can't always rely on exit
+	 * cancelation taking care of this.
 	 */
-	task_work_add(tsk, &req->task_work, true);
+	ret = task_work_add(tsk, &req->task_work, true);
+	if (unlikely(ret)) {
+		tsk = io_wq_get_task(req->ctx->io_wq);
+		task_work_add(tsk, &req->task_work, true);
+	}
 	wake_up_process(tsk);
 	return 1;
 }
-- 
2.26.0

