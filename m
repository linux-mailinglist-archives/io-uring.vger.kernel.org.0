Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 965EE26918A
	for <lists+io-uring@lfdr.de>; Mon, 14 Sep 2020 18:31:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726370AbgINQb3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Sep 2020 12:31:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726450AbgINQ0J (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Sep 2020 12:26:09 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F34B8C06178C
        for <io-uring@vger.kernel.org>; Mon, 14 Sep 2020 09:26:08 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id y74so673346iof.12
        for <io-uring@vger.kernel.org>; Mon, 14 Sep 2020 09:26:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=W5NispRd57eK9c26j4M9JUK235lryxlMuTrOL2Rnlps=;
        b=O5E4n4OVkh6UhjnwpkIO0udqbdrmSPQEB1V7liRUk8GvivQanZIZnmrYrqnYscijSE
         fHRC8LFvTZYNopntDDDJFJEjljWpc1OhHmCrlrQgoGlvjAlqCA5LGKBseW103bno0yr8
         X1lKrleJJUIlbgB/oILLTtBF33pcU9DiYO8wysXnJKsd2gMpqSUHP5tGDiegaGCS62nF
         BCSvqxpchxcF8UUsxbad15NIec2FdWJkfBvi8GBQFFS4X0HSUUuG+M820yP4XCRzcs96
         5Z3xo1xaYK5hS/L0EYdRcXunU2ycuFa2ofziTi0DytRyXQsiD4gvJUbgbjXAEO+VKH06
         sm1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=W5NispRd57eK9c26j4M9JUK235lryxlMuTrOL2Rnlps=;
        b=rezWsKu3SSRehJFw9Jr/EV9lnMLbAh/h4usV2TxwdkLm7xlQY6rrFpiBp11U9zWEMm
         9xMQ4iRtDmccBQh1IJnKfVLWmDrqYuoAoL2sjxIfA39vvMHsx/3CHfPvMzQepZVuKFcO
         ejYCgF34tFfMQBos4TxF+mhk8mHIV7TiwxHlOjVAvXoBgefiYyiRFjax77leEzGEu2cY
         Tg/qmtqm29SPS6roFuuWdT+aO5jRlLUtcy/cIqlYEJsjGIoT/IMOTPWvdBuQXNh517KO
         4/89TaKIyxi8RqSHBWuIxn5X+C6A/aRNVLWlkGlwgwWqYhgtGctv7VObAnKGnRW/tU5Z
         dFGQ==
X-Gm-Message-State: AOAM531CWtcz334qGpXPSuRxMw485HCHhhOyOsy2yFKBR+FBxAQetKcd
        Ak755Rw0mXHvTbKUYiHZ6VuxCYq4GD1t4zjk
X-Google-Smtp-Source: ABdhPJy7Ly3paORVvapO67YFq/zfPZnhZzNP/glqBMjSzvA/DvCWUzfupFU3MYtu0I4cnbMek+65aw==
X-Received: by 2002:a5d:80d6:: with SMTP id h22mr11794868ior.154.1600100768072;
        Mon, 14 Sep 2020 09:26:08 -0700 (PDT)
Received: from x1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id o12sm7032261ilq.29.2020.09.14.09.26.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2020 09:26:07 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/5] io_uring: don't run task work on an exiting task
Date:   Mon, 14 Sep 2020 10:25:53 -0600
Message-Id: <20200914162555.1502094-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200914162555.1502094-1-axboe@kernel.dk>
References: <20200914162555.1502094-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This isn't safe, and isn't needed either. We are guaranteed that any
work we queue is on a live task (and will be run), or it goes to
our backup io-wq threads if the task is exiting.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 01756a131be6..a29c8913b1f0 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1753,6 +1753,9 @@ static int io_req_task_work_add(struct io_kiocb *req, struct callback_head *cb,
 	struct io_ring_ctx *ctx = req->ctx;
 	int ret, notify;
 
+	if (tsk->flags & PF_EXITING)
+		return -ESRCH;
+
 	/*
 	 * SQPOLL kernel thread doesn't need notification, just a wakeup. For
 	 * all other cases, use TWA_SIGNAL unconditionally to ensure we're
@@ -2012,6 +2015,12 @@ static inline unsigned int io_put_rw_kbuf(struct io_kiocb *req)
 
 static inline bool io_run_task_work(void)
 {
+	/*
+	 * Not safe to run on exiting task, and the task_work handling will
+	 * not add work to such a task.
+	 */
+	if (unlikely(current->flags & PF_EXITING))
+		return false;
 	if (current->task_works) {
 		__set_current_state(TASK_RUNNING);
 		task_work_run();
@@ -8184,6 +8193,8 @@ static void io_uring_cancel_files(struct io_ring_ctx *ctx,
 		/* cancel this request, or head link requests */
 		io_attempt_cancel(ctx, cancel_req);
 		io_put_req(cancel_req);
+		/* cancellations _may_ trigger task work */
+		io_run_task_work();
 		schedule();
 		finish_wait(&ctx->inflight_wait, &wait);
 	}
-- 
2.28.0

