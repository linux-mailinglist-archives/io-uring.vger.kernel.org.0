Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB8F250E2F0
	for <lists+io-uring@lfdr.de>; Mon, 25 Apr 2022 16:21:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242433AbiDYOYa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 Apr 2022 10:24:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232374AbiDYOYa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Apr 2022 10:24:30 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D000F22507
        for <io-uring@vger.kernel.org>; Mon, 25 Apr 2022 07:21:25 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id 125so15972701iov.10
        for <io-uring@vger.kernel.org>; Mon, 25 Apr 2022 07:21:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3KVl1tdwRigoZhQXyjpESkHY/nGU1jAsvgwdfBJ1/e0=;
        b=Ak+vEyqlN93NF9Aw6iBFNIXyg9uN0gydd40Aymc6zXIljnZOvHooYJnuxfh3KPDDZU
         weydlvOzcF9m72wtWxGXLxiY7TSz9xz1CovOtafYh3dqpWoRrmweqXwQSkTiFYRZ0/SG
         YTbvFKU8QHkj3ZW1D5uHqoVrbtzJ3qPHFULzneb9fUxSYCcqKb65vZrtGMXZkKbj5JuG
         4RPJCjcU1Uw0OAm/rnYoBciReu6P+3HhnHqNF1yqL+AfPuCrhGgMtrbMHLXhfwDCqaat
         ZpxLr9NW57yqH7z1S58eG58XfFhxEKpFLU00UMRE9XmiRLM74dNy+e6qCD1/HPcl/8ow
         DqZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3KVl1tdwRigoZhQXyjpESkHY/nGU1jAsvgwdfBJ1/e0=;
        b=VyOajB0A7JA5QA7KfUxYsKF1d1cKAbKa7wLTEM5syyiiZyYAIvxDf0m4JFvgCmO7Zq
         o0hz3B5X0Uq3pa2G0DJ1uIa4LuS/X/RspDcGC1oVajeLdXCMFZcpeU0OIYGvXgeiTHCp
         1+i0RxrWeVEHpL4ElwrbzlBPZ2acS4n3Q9DSbqCqrwMzorS1nrxJRtpKF69/tnW1vJtx
         gYKW6AsywrOTl66JDNjpXNrBI/OClsulyGTVSzKddMz9+zz2us8tke18Rigluv4tFlFH
         g/sP/xBSQpiyxr1oyFmQgNFwt8b+y2i0rxiQDqXFpKkrx8slDLtpR/L2t0oZkoCuHCwk
         1Rvg==
X-Gm-Message-State: AOAM531O1rdDRIfhL3/a2nt/NQwIG3EuD7GJsORVSTLgQYodP9p8Pv0j
        92IfBW06xkwFDFWqHK/idKWKWNtYeSUZfA==
X-Google-Smtp-Source: ABdhPJzDg3R4aF3C9Zc1zeL0/OoFoRpHT1hkUtE8nA0FoLDQJJhX9leeUJSHLlWYyPfkrQOlIXZUbA==
X-Received: by 2002:a05:6638:13d6:b0:32a:cd56:2373 with SMTP id i22-20020a05663813d600b0032acd562373mr4311050jaj.144.1650896484884;
        Mon, 25 Apr 2022 07:21:24 -0700 (PDT)
Received: from m1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id p6-20020a0566022b0600b0064c59797e67sm8136737iov.46.2022.04.25.07.21.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Apr 2022 07:21:23 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/6] io_uring: set task_work notify method at init time
Date:   Mon, 25 Apr 2022 08:21:16 -0600
Message-Id: <20220425142118.1448840-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220425142118.1448840-1-axboe@kernel.dk>
References: <20220425142118.1448840-1-axboe@kernel.dk>
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

