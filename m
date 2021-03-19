Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2CC7342356
	for <lists+io-uring@lfdr.de>; Fri, 19 Mar 2021 18:28:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230042AbhCSR1h (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Mar 2021 13:27:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230337AbhCSR1I (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Mar 2021 13:27:08 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACBBDC061761
        for <io-uring@vger.kernel.org>; Fri, 19 Mar 2021 10:27:07 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id g20so5876254wmk.3
        for <io-uring@vger.kernel.org>; Fri, 19 Mar 2021 10:27:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=x5iE6JNK9P50vg/+t+1KhSL2+3A2s6LkvQ0RnxSvZOk=;
        b=LmHJ1+7Y/BrRq5eapQ5CXYG4n1Bi7w99vbJbM2gAh437D+prd99ucu/hiUJwJ8n4DZ
         pDfWRop4gMJx8FJC4hR62C53uiHoZl1vkkNVwJGKM1gnliKRGXzepZrW8U6/yg5v8qkc
         awLPnjpNDQGN8SVjtRzkoVqOcAPSPO+6hjcesFeniVMXwCr8R59CelkdbSJzP3qpuR/d
         G7s5b41CF63t7lKHOCyAbElrzcr2QTq7OHLS6/2A+fJmbjAIfuoq7wpqvdAQyyNBgkRk
         hzCuM8EJPppaQriBrN54npvGBhakg28LyIRpeXYIvHerOej+KelZpzO5FKJrPOz8m/h+
         Oy/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=x5iE6JNK9P50vg/+t+1KhSL2+3A2s6LkvQ0RnxSvZOk=;
        b=FYkVb5Y9ZE4QGIvNIkEZKTDNiRWxqOXat/XzMZRCxV0rF3JZY7mr84v3OTmTl+1AVw
         G2HQpnN95oVLEgUnGAxtkPImbt9xOjO8iLSGADJzBTx3+KMNsF3de1wDrjU3RVegQvs/
         Y0zwmyB5EuqOvVmMtHndtpCO9Wo/cu1HGk1wMo0iO98SnpUzhmeVs5aLGkIGAE8KI5cl
         tbqsg6Uc6+iJnJtfCJ5AEcVcOMoPz7axj07oHO8U4N5NC8z+CqygO7ZVbDgTM+tufAiJ
         AAMCCIipd9W/mMcFKsTBiNj1pCfGwZkpridgbs4d5hfnTWXzszvRva6axmHnJ4/iUC6a
         AYSA==
X-Gm-Message-State: AOAM533KHYZFJqwCPEz36fb3Dt1+RJs7SEHpVDPJj4TONlTKyyhPIaJ3
        4xJA96y6Ojb2y08Q7eqVDq254wmiJEX9QA==
X-Google-Smtp-Source: ABdhPJwDIRk2FRXZCsQYaPgca35fBaY91xQcd0jiOHWX/1Ur7/yTgv892O20od3wKPgDAIFR1DX1Tg==
X-Received: by 2002:a1c:7715:: with SMTP id t21mr4651457wmi.132.1616174826405;
        Fri, 19 Mar 2021 10:27:06 -0700 (PDT)
Received: from localhost.localdomain ([148.252.133.195])
        by smtp.gmail.com with ESMTPSA id i8sm7112943wmi.6.2021.03.19.10.27.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Mar 2021 10:27:06 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 16/16] io_uring: optimise io_req_task_work_add()
Date:   Fri, 19 Mar 2021 17:22:44 +0000
Message-Id: <23fda3980a56cec26385a81030a6cc9e01c04bf6.1616167719.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1616167719.git.asml.silence@gmail.com>
References: <cover.1616167719.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Inline io_task_work_add() into io_req_task_work_add(). They both work
with a request, so keeping them separate doesn't make things much more
clear, but merging allows optimise it. Apart from small wins like not
reading req->ctx or not calculating @notify in the hot path, i.e. with
tctx->task_state set, it avoids doing wake_up_process() for every single
add, but only after actually done task_work_add().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 50 ++++++++++++++++++--------------------------------
 1 file changed, 18 insertions(+), 32 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d7b4cbe2ac3a..3548b2e60ba5 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1931,13 +1931,17 @@ static void tctx_task_work(struct callback_head *cb)
 		cond_resched();
 }
 
-static int io_task_work_add(struct task_struct *tsk, struct io_kiocb *req,
-			    enum task_work_notify_mode notify)
+static int io_req_task_work_add(struct io_kiocb *req)
 {
+	struct task_struct *tsk = req->task;
 	struct io_uring_task *tctx = tsk->io_uring;
+	enum task_work_notify_mode notify;
 	struct io_wq_work_node *node, *prev;
 	unsigned long flags;
-	int ret;
+	int ret = 0;
+
+	if (unlikely(tsk->flags & PF_EXITING))
+		return -ESRCH;
 
 	WARN_ON_ONCE(!tctx);
 
@@ -1950,14 +1954,23 @@ static int io_task_work_add(struct task_struct *tsk, struct io_kiocb *req,
 	    test_and_set_bit(0, &tctx->task_state))
 		return 0;
 
-	if (!task_work_add(tsk, &tctx->task_work, notify))
+	/*
+	 * SQPOLL kernel thread doesn't need notification, just a wakeup. For
+	 * all other cases, use TWA_SIGNAL unconditionally to ensure we're
+	 * processing task_work. There's no reliable way to tell if TWA_RESUME
+	 * will do the job.
+	 */
+	notify = (req->ctx->flags & IORING_SETUP_SQPOLL) ? TWA_NONE : TWA_SIGNAL;
+
+	if (!task_work_add(tsk, &tctx->task_work, notify)) {
+		wake_up_process(tsk);
 		return 0;
+	}
 
 	/*
 	 * Slow path - we failed, find and delete work. if the work is not
 	 * in the list, it got run and we're fine.
 	 */
-	ret = 0;
 	spin_lock_irqsave(&tctx->task_lock, flags);
 	wq_list_for_each(node, prev, &tctx->task_list) {
 		if (&req->io_task_work.node == node) {
@@ -1971,33 +1984,6 @@ static int io_task_work_add(struct task_struct *tsk, struct io_kiocb *req,
 	return ret;
 }
 
-static int io_req_task_work_add(struct io_kiocb *req)
-{
-	struct task_struct *tsk = req->task;
-	struct io_ring_ctx *ctx = req->ctx;
-	enum task_work_notify_mode notify;
-	int ret;
-
-	if (tsk->flags & PF_EXITING)
-		return -ESRCH;
-
-	/*
-	 * SQPOLL kernel thread doesn't need notification, just a wakeup. For
-	 * all other cases, use TWA_SIGNAL unconditionally to ensure we're
-	 * processing task_work. There's no reliable way to tell if TWA_RESUME
-	 * will do the job.
-	 */
-	notify = TWA_NONE;
-	if (!(ctx->flags & IORING_SETUP_SQPOLL))
-		notify = TWA_SIGNAL;
-
-	ret = io_task_work_add(tsk, req, notify);
-	if (!ret)
-		wake_up_process(tsk);
-
-	return ret;
-}
-
 static bool io_run_task_work_head(struct callback_head **work_head)
 {
 	struct callback_head *work, *next;
-- 
2.24.0

