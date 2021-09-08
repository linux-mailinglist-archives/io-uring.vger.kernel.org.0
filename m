Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 023CB4036A5
	for <lists+io-uring@lfdr.de>; Wed,  8 Sep 2021 11:10:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348484AbhIHJLU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Sep 2021 05:11:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245487AbhIHJLT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Sep 2021 05:11:19 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7713C061575
        for <io-uring@vger.kernel.org>; Wed,  8 Sep 2021 02:10:11 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id u16so2169792wrn.5
        for <io-uring@vger.kernel.org>; Wed, 08 Sep 2021 02:10:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hkwJYHnVixb4sxqn23l2F7bUV76D4fSYvXakcBuJTAs=;
        b=pZD0CwMGnPYFDEj+gS+dVEuiLS0rTuWr1FDLVgHLI8HIBpEHh/ojEfuddSs5hqem/S
         3TYuUr6sd1Mu12VxR1JJZ6kqN/1xq0E2uRFu/JcWJ7nL75sbLHdYRK2wBKufy7q2afjd
         c02kAGPcTkOLKtXqXzdxUTremt8R+nS5LP8kQIIYoVu4OjZ3ZUCNOXR22V+GxIeS7Bpl
         fpY8hB0Zn9H+WvIvmv6z6zsywifxo0ue4simxSfrSIFnnzwUE+Av3atFGSUlmAeNJTEz
         SeXznTslzgupG0l31DuCu3wO+Jwd4ClP8xz1MvlzPSpgbxKMlBk7MNCS4HxFxnoAReuh
         1/pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hkwJYHnVixb4sxqn23l2F7bUV76D4fSYvXakcBuJTAs=;
        b=TvwmJ0yWFclV13zZTS8aleibwdt+vVOqZ9XY1kN3qzom8WSyCncUWpas+NhqhbMBMa
         KjgCv+xs2vhQW3slPqB3zxwNe58t4Pk7juFM/CsT7CLJZq1cxIxZe5LH+qVGPs/T5YyQ
         2t2rAq3Ly3SDTzZS1k7u2RBJoJEjzrCrU1KVjnps87AuhKnPO9cW4BeOtLmnSXKLxfdC
         IHx4UWCYiNmV60Ad97L0lEfFIIWCmw/0OPeThcFH9kin8KjOTlNVa0B3B10Uei5ESliI
         d9LpPqp7BcGGj0nl6IEoxauiQ3Yg2/LXxBnl3B5AslOAOdusNVFjscqoyzNSpoelfqzw
         Gk0Q==
X-Gm-Message-State: AOAM530CdzCSJY5Srl8qqqxiB2Xfk8by/zmWfxIlc0JqCy3DlfaMcVGI
        O0yxV6Xkn5OC2m4VVEsAyTQ=
X-Google-Smtp-Source: ABdhPJxXMP+7lqgtlR8Zz3+zX9CC1/5VazZBJ0iBFV/BBcWbWVMhRR9ZtRacOHYjQ8KdlcBvpICLiQ==
X-Received: by 2002:a05:6000:34a:: with SMTP id e10mr2867182wre.421.1631092210549;
        Wed, 08 Sep 2021 02:10:10 -0700 (PDT)
Received: from localhost.localdomain ([185.69.144.232])
        by smtp.gmail.com with ESMTPSA id 19sm1464973wmo.39.2021.09.08.02.10.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Sep 2021 02:10:10 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     Hao Sun <sunhao.th@gmail.com>
Subject: [PATCH] io-wq: fix cancellation on create-worker failure
Date:   Wed,  8 Sep 2021 10:09:29 +0100
Message-Id: <93b9de0fcf657affab0acfd675d4abcd273ee863.1631092071.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

WARNING: CPU: 0 PID: 10392 at fs/io_uring.c:1151 req_ref_put_and_test
fs/io_uring.c:1151 [inline]
WARNING: CPU: 0 PID: 10392 at fs/io_uring.c:1151 req_ref_put_and_test
fs/io_uring.c:1146 [inline]
WARNING: CPU: 0 PID: 10392 at fs/io_uring.c:1151
io_req_complete_post+0xf5b/0x1190 fs/io_uring.c:1794
Modules linked in:
Call Trace:
 tctx_task_work+0x1e5/0x570 fs/io_uring.c:2158
 task_work_run+0xe0/0x1a0 kernel/task_work.c:164
 tracehook_notify_signal include/linux/tracehook.h:212 [inline]
 handle_signal_work kernel/entry/common.c:146 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:172 [inline]
 exit_to_user_mode_prepare+0x232/0x2a0 kernel/entry/common.c:209
 __syscall_exit_to_user_mode_work kernel/entry/common.c:291 [inline]
 syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:302
 do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x44/0xae

When io_wqe_enqueue() -> io_wqe_create_worker() fails, we can't just
call io_run_cancel() to clean up the request, it's already enqueued via
io_wqe_insert_work() and will be executed either by some other worker
during cancellation (e.g. in io_wq_put_and_exit()).

Reported-by: Hao Sun <sunhao.th@gmail.com>
Fixes: 3146cba99aa28 ("io-wq: make worker creation resilient against signals")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io-wq.c | 29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index d80e4a735677..35e7ee26f7ea 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -832,6 +832,11 @@ static void io_wqe_insert_work(struct io_wqe *wqe, struct io_wq_work *work)
 	wq_list_add_after(&work->list, &tail->list, &acct->work_list);
 }
 
+static bool io_wq_work_match_item(struct io_wq_work *work, void *data)
+{
+	return work == data;
+}
+
 static void io_wqe_enqueue(struct io_wqe *wqe, struct io_wq_work *work)
 {
 	struct io_wqe_acct *acct = io_work_get_acct(wqe, work);
@@ -844,7 +849,6 @@ static void io_wqe_enqueue(struct io_wqe *wqe, struct io_wq_work *work)
 	 */
 	if (test_bit(IO_WQ_BIT_EXIT, &wqe->wq->state) ||
 	    (work->flags & IO_WQ_WORK_CANCEL)) {
-run_cancel:
 		io_run_cancel(work, wqe);
 		return;
 	}
@@ -864,15 +868,22 @@ static void io_wqe_enqueue(struct io_wqe *wqe, struct io_wq_work *work)
 		bool did_create;
 
 		did_create = io_wqe_create_worker(wqe, acct);
-		if (unlikely(!did_create)) {
-			raw_spin_lock(&wqe->lock);
-			/* fatal condition, failed to create the first worker */
-			if (!acct->nr_workers) {
-				raw_spin_unlock(&wqe->lock);
-				goto run_cancel;
-			}
-			raw_spin_unlock(&wqe->lock);
+		if (likely(did_create))
+			return;
+
+		raw_spin_lock(&wqe->lock);
+		/* fatal condition, failed to create the first worker */
+		if (!acct->nr_workers) {
+			struct io_cb_cancel_data match = {
+				.fn		= io_wq_work_match_item,
+				.data		= work,
+				.cancel_all	= false,
+			};
+
+			if (io_acct_cancel_pending_work(wqe, acct, &match))
+				raw_spin_lock(&wqe->lock);
 		}
+		raw_spin_unlock(&wqe->lock);
 	}
 }
 
-- 
2.33.0

