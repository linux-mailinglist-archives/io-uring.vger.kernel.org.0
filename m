Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B06B23F877
	for <lists+io-uring@lfdr.de>; Sat,  8 Aug 2020 20:34:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726250AbgHHSex (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 8 Aug 2020 14:34:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726338AbgHHSet (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 8 Aug 2020 14:34:49 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C34EC061A2A
        for <io-uring@vger.kernel.org>; Sat,  8 Aug 2020 11:34:49 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id z20so2725068plo.6
        for <io-uring@vger.kernel.org>; Sat, 08 Aug 2020 11:34:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8L0zIz5uql2UDcF0yxiWlDIlb1DvTyWqTU6t0oIjvB0=;
        b=mysIfieigwANGx/0ERzmeZqX37FaXAeRDZPgSRZ/FfLCQ8bAbqXa9bkzOhgj8ZgK24
         ibr0RBW0R80Z7yKAUHh6hl2CVzk7catBuWJt/Mw8RkmRIESvZKlIX957dEi3DJ30rVu3
         uki11r0A7kmpCN7Js1deaSqGW0HueSwocrhmt4VssYFHt7sziI6PCGKQTFQl96y2hNIM
         nltYPPmd9TavRQNoUp1xaDsNaUqsDbTN40IiNKOj/41L+au/v5MOSYJczvwfqwyjjtWO
         J1wK32go5y9MNaovHmy+796wAr99suS80TPZwnp/gpPUsAlvCdxuAopGwhgU3aeyHznd
         V9iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8L0zIz5uql2UDcF0yxiWlDIlb1DvTyWqTU6t0oIjvB0=;
        b=hQUqdYNKxl/BO71Ee0UBdGvNnRMpWpMc1GvYN5U1eyLrPgOWCLtrv4DuJRmcrazpLx
         VFwjTMhvYUCWRoECmFRClAGOPfKx+6CTlxeOpH2QoULphAYNRQ73CMN4BRGWGlv/uAdv
         uuRhlfNhOzAa3J0jSD9Ab/PDT/kRA2My0uFax15SWJAQuaF/+cY/MgHCXCHlcvpsUAVC
         9dBH0SPv+V9GCS2M83WA873SFmjmjm20PpTiP+GlUiIYTlNUHJHLFXjWD6lDEM3T35dT
         F+vwqDhIP5IbRaOTfoBuZXxomTipZcP+KN931yUnHKUwhe9toI9AsVdAU66YHZKZ1qbW
         HKIA==
X-Gm-Message-State: AOAM532PZXP6ush8t13gVWj3z3I3wUY8+b+8q0LwkeqQ3/AHPe/tlGKk
        6/HjJj8IT1mTV8dSKroFixjogfdUMqw=
X-Google-Smtp-Source: ABdhPJxo+hkqXHMtyf7ZAMeF8G4gypvPh6zvCTcSOeANN6lLrYOk+ikzZ3Ra0f4jA844RUCtO5yphw==
X-Received: by 2002:a17:902:7e86:: with SMTP id z6mr17362785pla.161.1596911685590;
        Sat, 08 Aug 2020 11:34:45 -0700 (PDT)
Received: from localhost.localdomain ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id j142sm17955584pfd.100.2020.08.08.11.34.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Aug 2020 11:34:45 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     peterz@infradead.org, Jens Axboe <axboe@kernel.dk>,
        stable@vger.kernel.org, Josef <josef.grieb@gmail.com>
Subject: [PATCH 2/2] io_uring: use TWA_SIGNAL for task_work if the task isn't running
Date:   Sat,  8 Aug 2020 12:34:39 -0600
Message-Id: <20200808183439.342243-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200808183439.342243-1-axboe@kernel.dk>
References: <20200808183439.342243-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

An earlier commit:

b7db41c9e03b ("io_uring: fix regression with always ignoring signals in io_cqring_wait()")

ensured that we didn't get stuck waiting for eventfd reads when it's
registered with the io_uring ring for event notification, but we still
have a gap where the task can be waiting on other events in the kernel
and need a bigger nudge to make forward progress.

Ensure that we use signaled notifications for a task that isn't currently
running, to be certain the work is seen and processed immediately.

Cc: stable@vger.kernel.org # v5.7+
Reported-by: Josef <josef.grieb@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e9b27cdaa735..443eecdfeda9 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1712,21 +1712,27 @@ static int io_req_task_work_add(struct io_kiocb *req, struct callback_head *cb)
 	struct io_ring_ctx *ctx = req->ctx;
 	int ret, notify = TWA_RESUME;
 
+	ret = __task_work_add(tsk, cb);
+	if (unlikely(ret))
+		return ret;
+
 	/*
 	 * SQPOLL kernel thread doesn't need notification, just a wakeup.
-	 * If we're not using an eventfd, then TWA_RESUME is always fine,
-	 * as we won't have dependencies between request completions for
-	 * other kernel wait conditions.
+	 * For any other work, use signaled wakeups if the task isn't
+	 * running to avoid dependencies between tasks or threads. If
+	 * the issuing task is currently waiting in the kernel on a thread,
+	 * and same thread is waiting for a completion event, then we need
+	 * to ensure that the issuing task processes task_work. TWA_SIGNAL
+	 * is needed for that.
 	 */
 	if (ctx->flags & IORING_SETUP_SQPOLL)
 		notify = 0;
-	else if (ctx->cq_ev_fd)
+	else if (READ_ONCE(tsk->state) != TASK_RUNNING)
 		notify = TWA_SIGNAL;
 
-	ret = task_work_add(tsk, cb, notify);
-	if (!ret)
-		wake_up_process(tsk);
-	return ret;
+	__task_work_notify(tsk, notify);
+	wake_up_process(tsk);
+	return 0;
 }
 
 static void __io_req_task_cancel(struct io_kiocb *req, int error)
-- 
2.28.0

