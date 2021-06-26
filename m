Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 892D43B501A
	for <lists+io-uring@lfdr.de>; Sat, 26 Jun 2021 22:41:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230192AbhFZUnl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 26 Jun 2021 16:43:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230107AbhFZUnj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 26 Jun 2021 16:43:39 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 656A9C061766
        for <io-uring@vger.kernel.org>; Sat, 26 Jun 2021 13:41:15 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id u20so3324988wmq.4
        for <io-uring@vger.kernel.org>; Sat, 26 Jun 2021 13:41:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=PsKPKzju2XvZwrOsdQefFRSCaWNnRvKcCRFYRJDi3Ys=;
        b=Q9KxCoiBqYvE3hljOAC9k8tbmeJymTClTbtcNc622yJHOwu0nxwc2X0+0UGVnvnmoC
         JTQdtgpZx0GdDkBNZbjmhs687jovDKnXYY4j7YY4wEzJNu5+Hi8NBt2r91z+piiRS9D0
         HRVoRvTjpnGiyzUyZkPRvfPTsrMPVhu739nuN5EONwhdLGVLbheou1B7I390WYtVRfNB
         8TrahN7jDNVGEASLwS4OdwZNLR5MrC+2LrLZEPR5IXmMYBoJuHMUJLau/Lok6j/qgZqk
         Zui3bQ9bA5WGDqy/JIXdZDFjQMIOd5Ntion5i6zlF/QUN2J1o+QORgH/I7uzDIsddcv1
         VcTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PsKPKzju2XvZwrOsdQefFRSCaWNnRvKcCRFYRJDi3Ys=;
        b=UPfemcqAUrfHJy08NrDqE+6rw3mAGKWl/4Mu0dpAMAI7DQ5f7H2bKEcGAJNhCPAg7j
         GUOptXLRZXnUOQtcHbjyL5esZ9SSkXhKRJdY7bBJbzscfiO9ib4H1z1wfYe9zBXXvihV
         qJcqtmGkKNp2mW2qHA64RyX3+Nf5bhOECJpEIQ9rwhY/wm9JmIG8kxBGu8qrbMPCI3Uy
         XG/3344J9UTJ0NqHFatG8Cm+nBpsvzQUQIY+7deCIrbPijHYRoItLPAgmOBrpfu6+h+l
         BKCVdC44py8cl3LGNajpKEuwHWSBq5wwf+l0RMXJoMvjko6qJiaHMbVjYzApADPyWHqa
         knCg==
X-Gm-Message-State: AOAM530xK8jbke0966RbWEo6nzFwDyyWg2Sx+Ip2fXWX40H40atbwqMR
        jPOkLMyvChcBK2SDBRNEQqc=
X-Google-Smtp-Source: ABdhPJxOlGma2b/mJJdBWTXzbaUxpNhoHOodBLqAdHJlBb1220BVCJIJFeIWZkRFF9/G/EGZLEZW7g==
X-Received: by 2002:a7b:c1c1:: with SMTP id a1mr14862563wmj.187.1624740074072;
        Sat, 26 Jun 2021 13:41:14 -0700 (PDT)
Received: from localhost.localdomain ([148.252.129.84])
        by smtp.gmail.com with ESMTPSA id b9sm11272613wrh.81.2021.06.26.13.41.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Jun 2021 13:41:13 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 3/6] io_uring: remove not needed PF_EXITING check
Date:   Sat, 26 Jun 2021 21:40:46 +0100
Message-Id: <f7f305ececb1e6044ea649fb983ca754805bb884.1624739600.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1624739600.git.asml.silence@gmail.com>
References: <cover.1624739600.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Since cancellation got moved before exit_signals(), there is no one left
who can call io_run_task_work() with PF_EXIING set, so remove the check.
Note that __io_req_task_submit() still needs a similar check.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f10cdb92f771..953bdc41d018 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2264,12 +2264,6 @@ static inline unsigned int io_put_rw_kbuf(struct io_kiocb *req)
 
 static inline bool io_run_task_work(void)
 {
-	/*
-	 * Not safe to run on exiting task, and the task_work handling will
-	 * not add work to such a task.
-	 */
-	if (unlikely(current->flags & PF_EXITING))
-		return false;
 	if (current->task_works) {
 		__set_current_state(TASK_RUNNING);
 		task_work_run();
@@ -9216,7 +9210,8 @@ static void io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 		ret |= io_cancel_defer_files(ctx, task, cancel_all);
 		ret |= io_poll_remove_all(ctx, task, cancel_all);
 		ret |= io_kill_timeouts(ctx, task, cancel_all);
-		ret |= io_run_task_work();
+		if (task)
+			ret |= io_run_task_work();
 		ret |= io_run_ctx_fallback(ctx);
 		if (!ret)
 			break;
-- 
2.32.0

