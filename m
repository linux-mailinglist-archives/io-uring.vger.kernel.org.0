Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 785CA36A9B1
	for <lists+io-uring@lfdr.de>; Mon, 26 Apr 2021 00:35:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231382AbhDYWfl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 25 Apr 2021 18:35:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231247AbhDYWfk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 25 Apr 2021 18:35:40 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA5EAC061574
        for <io-uring@vger.kernel.org>; Sun, 25 Apr 2021 15:34:59 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id f15-20020a05600c4e8fb029013f5599b8a9so2091312wmq.1
        for <io-uring@vger.kernel.org>; Sun, 25 Apr 2021 15:34:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=86pasEmkQG12Csv7MriVbWdjygLz09oPbu2KrIyiTLw=;
        b=Ou+/lKWIeSf/YPjKj0ryT6QhmXy+6jJ8s6IvHsx1VW7uh7jjFXaU3QL2KJurh0yvBH
         DC31EaX/9P6eWFfQwK2vsbqOYeoH017R/+vwjcgOg5bsE3VnZNHnxqRGsE46mz1BoSd4
         PwpvRGchq4wpN21oBrpz38h3tzD2v3Swm/HNaLLicivjYRXr8S/65uqtV5ZYyFsV16e9
         rirsOtJh0ZiA8gejvloTVsDRNSR7ch4ZhIrLQihVlcQbcMoVMcDZ6PHj7dfA0tX9jb6+
         GKmDjVvtKGk0qX9c/NrXqZ/C1p39HcKWTp+bDZXFFENMUnxqrKnGZdD4EgU7qpSoHco3
         kRoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=86pasEmkQG12Csv7MriVbWdjygLz09oPbu2KrIyiTLw=;
        b=TuV9MGxbCONL9p94eTUvDC5THNcuYUQlWkUaR3X5X8AZEaa0bCzcaIOZ80mpD4GkC5
         w96FSvLuehuycXGBdYFXqhB0BNe0icyf2lp5DoksQGvEmSdKhQ8sqkd0T8qqzI4BpZJ3
         R+qfhiiwBKORUgQQEdGRiH633OWnCSOAcdfV0Mt5hcx73p8+Aue1jhVkYqPFBSRstB9y
         mADlRcWDWUq/dvfafOyFlGXE+lkB0ef8z+M1Rfd9/LEGQJ4nKd7qUkWN17+4HWRbzUHf
         470gl4AvpJRRuH88NDo4An3+t+gQKUt+RP6MBGczl7BZqoBXMVDjgAbWW4D9ESehLkD+
         FmWA==
X-Gm-Message-State: AOAM531vw4bLuiMG5kS4u8cePuvoLZbbow+mkJ21aEfJMeBS9gU1tIfg
        NyzHCQiFkbS42gpIVKjv3Mc=
X-Google-Smtp-Source: ABdhPJw1ls7IEp2GSMm72rexcluadG8trI1SoNbcrTrhHI6Kb9yJ5P9vSm+YNJFPTSX9KEGFIrxf4Q==
X-Received: by 2002:a1c:2:: with SMTP id 2mr16469187wma.113.1619390098572;
        Sun, 25 Apr 2021 15:34:58 -0700 (PDT)
Received: from localhost.localdomain ([148.252.129.131])
        by smtp.gmail.com with ESMTPSA id r2sm17353394wrt.79.2021.04.25.15.34.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Apr 2021 15:34:58 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 2/2] io_uring: simplify SQPOLL cancellations
Date:   Sun, 25 Apr 2021 23:34:46 +0100
Message-Id: <3cd7f166b9c326a2c932b70e71a655b03257b366.1619389911.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1619389911.git.asml.silence@gmail.com>
References: <cover.1619389911.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

All sqpoll rings (even sharing sqpoll task) are currently dead bound
to the task that created them, iow when owner task dies it kills all
its SQPOLL rings and their inflight requests via task_work infra. It's
neither the nicist way nor the most convenient as adds extra
locking/waiting and dependencies.

Leave it alone and rely on SIGKILL being delivered on its thread group
exit, so there are only two cases left:

1) thread group is dying, so sqpoll task gets a signal and exit itself
   cancelling all requests.

2) an sqpoll ring is dying. Because refs_kill() is called the sqpoll not
   going to submit any new request, and that's what we need. And
   io_ring_exit_work() will do all the cancellation itself before
   actually killing ctx, so sqpoll doesn't need to worry about it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 45 +++------------------------------------------
 1 file changed, 3 insertions(+), 42 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 640a4bc77aa6..1cdc9b7c5c8c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -9020,41 +9020,6 @@ static s64 tctx_inflight(struct io_uring_task *tctx, bool tracked)
 	return percpu_counter_sum(&tctx->inflight);
 }
 
-static void io_sqpoll_cancel_cb(struct callback_head *cb)
-{
-	struct io_tctx_exit *work = container_of(cb, struct io_tctx_exit, task_work);
-	struct io_sq_data *sqd = work->ctx->sq_data;
-
-	if (sqd->thread)
-		io_uring_cancel_sqpoll(sqd);
-	list_del_init(&work->ctx->sqd_list);
-	io_sqd_update_thread_idle(sqd);
-	complete(&work->completion);
-}
-
-static void io_sqpoll_cancel_sync(struct io_ring_ctx *ctx)
-{
-	struct io_sq_data *sqd = ctx->sq_data;
-	struct io_tctx_exit work = { .ctx = ctx, };
-	struct task_struct *task;
-
-	io_sq_thread_park(sqd);
-	task = sqd->thread;
-	if (task) {
-		init_completion(&work.completion);
-		init_task_work(&work.task_work, io_sqpoll_cancel_cb);
-		io_task_work_add_head(&sqd->park_task_work, &work.task_work);
-		wake_up_process(task);
-	} else {
-		list_del_init(&ctx->sqd_list);
-		io_sqd_update_thread_idle(sqd);
-	}
-	io_sq_thread_unpark(sqd);
-
-	if (task)
-		wait_for_completion(&work.completion);
-}
-
 static void io_uring_try_cancel(struct files_struct *files)
 {
 	struct io_uring_task *tctx = current->io_uring;
@@ -9064,11 +9029,9 @@ static void io_uring_try_cancel(struct files_struct *files)
 	xa_for_each(&tctx->xa, index, node) {
 		struct io_ring_ctx *ctx = node->ctx;
 
-		if (ctx->sq_data) {
-			io_sqpoll_cancel_sync(ctx);
-			continue;
-		}
-		io_uring_try_cancel_requests(ctx, current, files);
+		/* sqpoll task will cancel all its requests */
+		if (!ctx->sq_data)
+			io_uring_try_cancel_requests(ctx, current, files);
 	}
 }
 
@@ -9116,8 +9079,6 @@ void __io_uring_cancel(struct files_struct *files)
 
 	/* make sure overflow events are dropped */
 	atomic_inc(&tctx->in_idle);
-	io_uring_try_cancel(files);
-
 	do {
 		/* read completions before cancelations */
 		inflight = tctx_inflight(tctx, !!files);
-- 
2.31.1

