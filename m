Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 856F050EE48
	for <lists+io-uring@lfdr.de>; Tue, 26 Apr 2022 03:49:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241421AbiDZBwU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 Apr 2022 21:52:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230262AbiDZBwR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Apr 2022 21:52:17 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78989120106
        for <io-uring@vger.kernel.org>; Mon, 25 Apr 2022 18:49:12 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id g3so14192309pgg.3
        for <io-uring@vger.kernel.org>; Mon, 25 Apr 2022 18:49:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3KVl1tdwRigoZhQXyjpESkHY/nGU1jAsvgwdfBJ1/e0=;
        b=75LZoyT4lWOfrBwFa81foRrYDiAucvXaDxQ4X34iXqtL6rAlpXlWtUxk1BsqdZZmAy
         jcui8TgL1JyvYaKl2Qy5pOmzaeuz8UaDEzdYNm7iuaRX4S5guG7YGrGeVndXoRvhnW16
         tZYpToDkuWU8PRoaS8uN04Td8LOv5s3wKbBebtLEMFvH1XT6dYfnagIdS2Cnojm0fqBz
         6gaywmxtaWu7Hnd1EFC2NPy5hXU7wzWCK8Em35PmfzZaSW8g3XNai4nL6cBQBL5wv4kR
         k8hSqYFT7uOzv0w+nDSLjm+bmnlyN7UR5yq5tpdXG+TK48iVwl+sLRmDrCPGv/vaXfVC
         lHEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3KVl1tdwRigoZhQXyjpESkHY/nGU1jAsvgwdfBJ1/e0=;
        b=1QQiLi41mbGVNrDKiPMexCRIdbiI36H3mp11qGJF5G5rb5MAPW7byafAkVmoCd629t
         PeszBFVBUSUErS4TLBPrH1it8renuCp0Nd5k/ItZV4aOM/Hm/bD36R6lGdQ3TkeK8U5A
         kUCCbGVhzZbfXk2ut7hW19gLh87VJENyvw0XcaKr2KD9084CHFIsB+jdr26AsXGuzPm/
         On28Vt5khJ/dODPHVon3huP1y4vjwU/EiTAwSw7hHSO4PrLv7DtbkSzF0yeE9sFh9aRB
         TdpnGP2c+SMvH9o4bivyiLV3QTLUf29zjcbnwAL78dG35igVuHVW6dKMbDPX1/WMDxjx
         RNrQ==
X-Gm-Message-State: AOAM533uOSkRzmIP7fj5uh+rOuHQ1efQmSHhXiu+LX7JZztrqXT4xUjD
        haQSZx4M5UFqdhL8pahtFua/bWmpl+vbYKqe
X-Google-Smtp-Source: ABdhPJxI+jhKw5gLlbzmJg9+0xwEm6y0Y/PyW4AEKU1lG02U4mFlh9HR7e367KuzQlj6snPMnOMbnw==
X-Received: by 2002:a63:ec50:0:b0:39d:2d53:76e7 with SMTP id r16-20020a63ec50000000b0039d2d5376e7mr17311443pgj.338.1650937751571;
        Mon, 25 Apr 2022 18:49:11 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id i23-20020a056a00225700b0050d38d0f58dsm6076149pfu.213.2022.04.25.18.49.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Apr 2022 18:49:10 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/6] io_uring: set task_work notify method at init time
Date:   Mon, 25 Apr 2022 19:49:02 -0600
Message-Id: <20220426014904.60384-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220426014904.60384-1-axboe@kernel.dk>
References: <20220426014904.60384-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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
index 511b52e4b9fd..7e9ac5fd3a8c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -367,6 +367,7 @@ struct io_ring_ctx {
 
 		struct io_rings		*rings;
 		unsigned int		flags;
+		enum task_work_notify_mode	notify_method;
 		unsigned int		compat: 1;
 		unsigned int		drain_next: 1;
 		unsigned int		restricted: 1;
@@ -2651,8 +2652,8 @@ static void tctx_task_work(struct callback_head *cb)
 static void io_req_task_work_add(struct io_kiocb *req, bool priority)
 {
 	struct task_struct *tsk = req->task;
+	struct io_ring_ctx *ctx = req->ctx;
 	struct io_uring_task *tctx = tsk->io_uring;
-	enum task_work_notify_mode notify;
 	struct io_wq_work_node *node;
 	unsigned long flags;
 	bool running;
@@ -2675,18 +2676,8 @@ static void io_req_task_work_add(struct io_kiocb *req, bool priority)
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
@@ -11704,6 +11695,14 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
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

