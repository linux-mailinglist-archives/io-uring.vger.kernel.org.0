Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FEA950C45E
	for <lists+io-uring@lfdr.de>; Sat, 23 Apr 2022 01:12:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233278AbiDVWnK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 Apr 2022 18:43:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234089AbiDVWm5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 22 Apr 2022 18:42:57 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B5EC1527AD
        for <io-uring@vger.kernel.org>; Fri, 22 Apr 2022 14:42:23 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d15so13592143pll.10
        for <io-uring@vger.kernel.org>; Fri, 22 Apr 2022 14:42:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=J60j/97MmKcQjPJOhpn7OPo3XA8ASXaP7Rv2l62NYsE=;
        b=0KC8yBMMQvzpsmn4ciPk8PxzbyZWYhFQVZgajOKgbwC+Nvs8CQ6S5+cHk5vZltkXpt
         jUIIYsdQgtglWWpD9vh0kptx4BN/uS2eYmMOX5yybzZK7Dh+JApVQiOIwrouZ/Yf6NiL
         b7yPfYxycPZDj9vTBGaFT8gZ3GqxCy21OcoRQJvvgsxwnSQI7dw9XARrT5hfblknLXhg
         G5SnNPQ0D3wUYragCbjicYia3JagOqlSBE4b2bvZkR48/EYczuQVdWWFlafMzDytMeo4
         OXXqTkcynfE5pPkMYJnkJyHsr8TBiVc6BeciSKgcAU8E+y/zRORGFtbkZRyNvQnXiXIL
         6ocw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=J60j/97MmKcQjPJOhpn7OPo3XA8ASXaP7Rv2l62NYsE=;
        b=2AL27iQAP0DRzIzb3xWfZ4Yre8yb7TSH7VXMezSnAm4IpvamPwNH0kqLj4Pen/LREr
         trpBz+hTal9tPgCT/k4o1Lw8C2TpRmhootr3N7uCukPFJxnCOS9z8yjgGgvSja5baUR9
         ckcD21yRrpeUy0hoHivH+FO2x5+McNbvs1tQ6k8cFhJBsFZMC3ojmFgLZZpKvrruPC5o
         ekQqCm395xqW0aUHbRzqbhMMrjp7RhBFCVjYfljDuVWJ+pl2wD+l1GzIA8v2iGs1XYQS
         lKcAbgRG0clKxFq3RNDxoLzkveiFJBybh6tlWGicyUAWm9PWYfgUYwfhxtAyMXm/Ps1j
         v9xw==
X-Gm-Message-State: AOAM532tK02SKg5W3e2rBqfW3xSYHMpuOEK0aM5XxgoIwKr+jfjjNo0d
        AjTU1t0g4kDzxvUFNUjvDiYw2LFcnm6OE9R0
X-Google-Smtp-Source: ABdhPJzz0JgkQnqGYS7OZdboJoH/ZaOMk2FfgK6qEPUHIlu32Q0/+b7ZQ6R291XZDJzQOQt4mRUA8Q==
X-Received: by 2002:a17:90b:1c0b:b0:1d2:7a8f:5e1b with SMTP id oc11-20020a17090b1c0b00b001d27a8f5e1bmr18305122pjb.237.1650663742306;
        Fri, 22 Apr 2022 14:42:22 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id c5-20020a62f845000000b0050ceac49c1dsm3473098pfm.125.2022.04.22.14.42.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Apr 2022 14:42:21 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/5] io_uring: set task_work notify method at init time
Date:   Fri, 22 Apr 2022 15:42:13 -0600
Message-Id: <20220422214214.260947-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220422214214.260947-1-axboe@kernel.dk>
References: <20220422214214.260947-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

While doing so, switch SQPOLL to TWA_SIGNAL_NO_IPI as well, as that
just does a task wakeup and then we can remove the special wakeup we
have in task_work_add.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 38e58fe4963d..20297fe4300b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -366,6 +366,7 @@ struct io_ring_ctx {
 
 		struct io_rings		*rings;
 		unsigned int		flags;
+		enum task_work_notify_mode	notify_method;
 		unsigned int		compat: 1;
 		unsigned int		drain_next: 1;
 		unsigned int		restricted: 1;
@@ -2650,8 +2651,8 @@ static void tctx_task_work(struct callback_head *cb)
 static void io_req_task_work_add(struct io_kiocb *req, bool priority)
 {
 	struct task_struct *tsk = req->task;
+	struct io_ring_ctx *ctx = req->ctx;
 	struct io_uring_task *tctx = tsk->io_uring;
-	enum task_work_notify_mode notify;
 	struct io_wq_work_node *node;
 	unsigned long flags;
 	bool running;
@@ -2674,18 +2675,8 @@ static void io_req_task_work_add(struct io_kiocb *req, bool priority)
 	if (running)
 		return;
 
-	/*
-	 * SQPOLL kernel thread doesn't need notification, just a wakeup. For
-	 * all other cases, use TWA_SIGNAL unconditionally to ensure we're
-	 * processing task_work. There's no reliable way to tell if TWA_RESUME
-	 * will do the job.
-	 */
-	notify = (req->ctx->flags & IORING_SETUP_SQPOLL) ? TWA_NONE : TWA_SIGNAL;
-	if (likely(!task_work_add(tsk, &tctx->task_work, notify))) {
-		if (notify == TWA_NONE)
-			wake_up_process(tsk);
+	if (likely(!task_work_add(tsk, &tctx->task_work, ctx->notify_method)))
 		return;
-	}
 
 	spin_lock_irqsave(&tctx->task_lock, flags);
 	tctx->task_running = false;
@@ -11360,6 +11351,14 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
 	if (!capable(CAP_IPC_LOCK))
 		ctx->user = get_uid(current_user());
 
+	/*
+	 * For SQPOLL, we just need a wakeup, always.
+	 */
+	if (ctx->flags & IORING_SETUP_SQPOLL)
+		ctx->notify_method = TWA_SIGNAL_NO_IPI;
+	else
+		ctx->notify_method = TWA_SIGNAL;
+
 	/*
 	 * This is just grabbed for accounting purposes. When a process exits,
 	 * the mm is exited and dropped before the files, hence we need to hang
-- 
2.35.1

