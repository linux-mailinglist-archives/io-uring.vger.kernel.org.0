Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF4A850CCA7
	for <lists+io-uring@lfdr.de>; Sat, 23 Apr 2022 19:40:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236643AbiDWRmQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 23 Apr 2022 13:42:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236599AbiDWRmP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 23 Apr 2022 13:42:15 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5D441C82DE
        for <io-uring@vger.kernel.org>; Sat, 23 Apr 2022 10:39:18 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id c1so4420418pfo.0
        for <io-uring@vger.kernel.org>; Sat, 23 Apr 2022 10:39:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zilRxyG3Rx7e4Y1+CDzL7ItCYH/fmg1EFCrTFTzpgxY=;
        b=2s81b5doaIeuPHnOLsNevKQe96i/lCVqKzxBd83idfiKrkX7IOz3WSXJvgcK9P09CJ
         ZQuDXOp6unkhua3OZl4/ZWNs3SgPG6dGpZKU6mXArVXZBLQdHVlHfUSZQgfCwYR5vZtP
         awFwE1LFZslo8s952Cz3YHZnT6C9hm9Nv8jZG+wBt/Eg6Z0CglWhpQucx8KW6TTAhPT3
         dvVJfFYMawjgNElRS8g18lk5jVDd/P40CSMMly8D/No42qTKn5GIgnfpLbeJjwm3I+V3
         8QH3k8SaSw8JZqgRDwHobEiqxycO0/yx76YpFteiaF0+GluyBPOxwUsxqJlWCqKYewIJ
         Dj2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zilRxyG3Rx7e4Y1+CDzL7ItCYH/fmg1EFCrTFTzpgxY=;
        b=MqVVt/4eYNxBDpssYHJePavNps9OB1nqUn7ehw/+O9g1fLfAC9WRPgxVvop9k91+eS
         KtCHHloZGaj5jlQhLlVvTexgPQfeYAfMwhH/W6ij59V6i9B3nYUjX4eAHJo7wmef4tDF
         fSJKbcoARjJV/gBrBOEGLlF1N1TMVkbX3uET9lvf9ctPMoXY8bo/sjfS9G/vYN9IoCrO
         P8xRA9t2tjd7PE9fEHE7TG0Gh1troiP8Se+KQMXwHTkkBcEgL0WfQTox82XoUosjt8PE
         BHIzheh+1pdRmVMMyjN9o1VzhhdWBLaBogc8tCivUeWatB8mil9svHbR2QOH5OSq3iFj
         XqrQ==
X-Gm-Message-State: AOAM533lVBzI5dNxWTBwJ0nFWhM+I9YWESAq6h87l0JHhyItiUmKuEJh
        RsFinmhrMVRUqJjwqimKklilHQFkmIid+pvw
X-Google-Smtp-Source: ABdhPJz1RSlxgSdO0iG/ZY6n0NGjPRWySJ2TR8QrqHawMmQs4q8r2sifZqSL8OcdKua3ytVQ3V+5/Q==
X-Received: by 2002:a63:4c52:0:b0:398:db25:d2b8 with SMTP id m18-20020a634c52000000b00398db25d2b8mr8847371pgl.432.1650735558010;
        Sat, 23 Apr 2022 10:39:18 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e16-20020a63ee10000000b0039d1c7e80bcsm5198854pgi.75.2022.04.23.10.39.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Apr 2022 10:39:17 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/5] io_uring: set task_work notify method at init time
Date:   Sat, 23 Apr 2022 11:39:10 -0600
Message-Id: <20220423173911.651905-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220423173911.651905-1-axboe@kernel.dk>
References: <20220423173911.651905-1-axboe@kernel.dk>
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
index 4fe3a53187cf..45992ada2f06 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -366,6 +366,7 @@ struct io_ring_ctx {
 
 		struct io_rings		*rings;
 		unsigned int		flags;
+		enum task_work_notify_mode	notify_method;
 		unsigned int		compat: 1;
 		unsigned int		drain_next: 1;
 		unsigned int		restricted: 1;
@@ -2621,8 +2622,8 @@ static void tctx_task_work(struct callback_head *cb)
 static void io_req_task_work_add(struct io_kiocb *req, bool priority)
 {
 	struct task_struct *tsk = req->task;
+	struct io_ring_ctx *ctx = req->ctx;
 	struct io_uring_task *tctx = tsk->io_uring;
-	enum task_work_notify_mode notify;
 	struct io_wq_work_node *node;
 	unsigned long flags;
 	bool running;
@@ -2645,18 +2646,8 @@ static void io_req_task_work_add(struct io_kiocb *req, bool priority)
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
@@ -11332,6 +11323,14 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
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

