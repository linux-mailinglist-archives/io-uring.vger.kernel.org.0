Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A72B662905
	for <lists+io-uring@lfdr.de>; Mon,  9 Jan 2023 15:51:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234744AbjAIOvd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Jan 2023 09:51:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234538AbjAIOvN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Jan 2023 09:51:13 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44A373E0FF
        for <io-uring@vger.kernel.org>; Mon,  9 Jan 2023 06:47:38 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id vm8so20704451ejc.2
        for <io-uring@vger.kernel.org>; Mon, 09 Jan 2023 06:47:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q/BxbVSZtF4cpWDNpJ1f3L845XrrbImRE4XcImaP/qM=;
        b=BgUZ1XgXhG5L9fbtDuxIKvUGw1ad03CPH0DE0G78N4kNVykqol91rQ3gZDfs6E7AMd
         9ahZCXfuB8fgQYQngdqy+wFEmPxuPMGug9KPu1Le4rCCS+Ac/puxkYXTm6LUdoqUZRpa
         eefDUartKNFqfnrC62TxokQwMf2LB6OlshOWGy9aCEP0FYIVqJMBUdJQRTHSidDB+f4/
         6XES/SiTvDut0f9/YWviLUZKyruOAH+jsjCzYYNPWsEyyrjfY2hazvFkKpgzCqkurOoo
         phHwIqbRtbJo9iTcVY9h8kNiTbL4/sadmcjLD3uZWVX1x6uVlIgwD2eJFHRaWJak9llr
         MhvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Q/BxbVSZtF4cpWDNpJ1f3L845XrrbImRE4XcImaP/qM=;
        b=kXIZWq6f5uh5jfmZneGGeZKpyqO9HslqBs9gBmgSDh3QeFZq/DLDGZnvfcK3v9K20C
         66zAgYo9zYUYMGmamlcUSy6n/rZaQfDLXUIjN4hcYMtSUZpgo4ZTWpIMEWNBB6VJ53wN
         0sTNogpC8gab/96zHvLmut0Ue4IaV0N36JanNaaqRjWTOGXkUrzx1SOnTfJCLhbEIDvE
         UpgNJCMjPOmjBpvAoeBvCi2dKzgXhnbBFq/Nh8jQGqhDGGo+oX4xo2lUnurOuAhXrBV+
         VQlzPA+ojqnLpTPFqkt9DpQLFBZgl87uBTTf14uAuv4xkgcbrfi5Pct2e4iUg/bZEGrR
         aoiA==
X-Gm-Message-State: AFqh2krTo2yUzTfmw97Mb9giAGmiVIVJ9Y3QTCkFtH4zNZF32R/j8Smm
        JTWxAa2pp8DqaxdTsPSObwmemAUfe4o=
X-Google-Smtp-Source: AMrXdXuO5aDjE0NgWUeObdawfsRs85oopZaCYewBOJaYnJ3UoLelTqe9jjpCoQtx1e7LY5E2Fq0tZg==
X-Received: by 2002:a17:907:cb84:b0:836:e8a6:f6f5 with SMTP id un4-20020a170907cb8400b00836e8a6f6f5mr57333633ejc.66.1673275656547;
        Mon, 09 Jan 2023 06:47:36 -0800 (PST)
Received: from 127.0.0.1localhost (188.29.102.7.threembb.co.uk. [188.29.102.7])
        by smtp.gmail.com with ESMTPSA id x11-20020a170906b08b00b0084c62b7b7d8sm3839578ejy.187.2023.01.09.06.47.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jan 2023 06:47:36 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH v3 07/11] io_uring: add lazy poll_wq activation
Date:   Mon,  9 Jan 2023 14:46:09 +0000
Message-Id: <060785e8e9137a920b232c0c7f575b131af19cac.1673274244.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1673274244.git.asml.silence@gmail.com>
References: <cover.1673274244.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Even though io_poll_wq_wake()'s waitqueue_active reuses a barrier we do
for another waitqueue, it's not going to be the case in the future and
so we want to have a fast path for it when the ring has never been
polled.

Move poll_wq wake ups into __io_commit_cqring_flush() using a new flag
called ->poll_activated. The idea behind the flag is to set it when the
ring was polled for the first time. This requires additional sync to not
miss events, which is done here by using task_work for ->task_complete
rings, and by default enabling the flag for all other types of rings.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring_types.h |  2 ++
 io_uring/io_uring.c            | 60 +++++++++++++++++++++++++++++++++-
 io_uring/io_uring.h            |  7 ++--
 3 files changed, 64 insertions(+), 5 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 0d94ee191c15..7b5e90520278 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -206,6 +206,7 @@ struct io_ring_ctx {
 		unsigned int		syscall_iopoll: 1;
 		/* all CQEs should be posted only by the submitter task */
 		unsigned int		task_complete: 1;
+		unsigned int		poll_activated: 1;
 
 		enum task_work_notify_mode	notify_method;
 		struct io_rings			*rings;
@@ -357,6 +358,7 @@ struct io_ring_ctx {
 	u32				iowq_limits[2];
 	bool				iowq_limits_set;
 
+	struct callback_head		poll_wq_task_work;
 	struct list_head		defer_list;
 	unsigned			sq_thread_idle;
 	/* protected by ->completion_lock */
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 8d19b0812f30..a6ed022c1356 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -573,6 +573,8 @@ static void io_eventfd_flush_signal(struct io_ring_ctx *ctx)
 
 void __io_commit_cqring_flush(struct io_ring_ctx *ctx)
 {
+	if (ctx->poll_activated)
+		io_poll_wq_wake(ctx);
 	if (ctx->off_timeout_used)
 		io_flush_timeouts(ctx);
 	if (ctx->drain_active) {
@@ -2784,11 +2786,53 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	kfree(ctx);
 }
 
+static __cold void io_activate_pollwq_cb(struct callback_head *cb)
+{
+	struct io_ring_ctx *ctx = container_of(cb, struct io_ring_ctx,
+					       poll_wq_task_work);
+
+	mutex_lock(&ctx->uring_lock);
+	ctx->poll_activated = true;
+	mutex_unlock(&ctx->uring_lock);
+
+	/*
+	 * Wake ups for some events between start of polling and activation
+	 * might've been lost due to loose synchronisation.
+	 */
+	wake_up_all(&ctx->poll_wq);
+	percpu_ref_put(&ctx->refs);
+}
+
+static __cold void io_activate_pollwq(struct io_ring_ctx *ctx)
+{
+	spin_lock(&ctx->completion_lock);
+	/* already activated or in progress */
+	if (ctx->poll_activated || ctx->poll_wq_task_work.func)
+		goto out;
+	if (WARN_ON_ONCE(!ctx->task_complete))
+		goto out;
+	if (!ctx->submitter_task)
+		goto out;
+	/*
+	 * with ->submitter_task only the submitter task completes requests, we
+	 * only need to sync with it, which is done by injecting a tw
+	 */
+	init_task_work(&ctx->poll_wq_task_work, io_activate_pollwq_cb);
+	percpu_ref_get(&ctx->refs);
+	if (task_work_add(ctx->submitter_task, &ctx->poll_wq_task_work, TWA_SIGNAL))
+		percpu_ref_put(&ctx->refs);
+out:
+	spin_unlock(&ctx->completion_lock);
+}
+
 static __poll_t io_uring_poll(struct file *file, poll_table *wait)
 {
 	struct io_ring_ctx *ctx = file->private_data;
 	__poll_t mask = 0;
 
+	if (unlikely(!ctx->poll_activated))
+		io_activate_pollwq(ctx);
+
 	poll_wait(file, &ctx->poll_wq, wait);
 	/*
 	 * synchronizes with barrier from wq_has_sleeper call in
@@ -3595,6 +3639,13 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
 	    !(ctx->flags & IORING_SETUP_SQPOLL))
 		ctx->task_complete = true;
 
+	/*
+	 * lazy poll_wq activation relies on ->task_complete for synchronisation
+	 * purposes, see io_activate_pollwq()
+	 */
+	if (!ctx->task_complete)
+		ctx->poll_activated = true;
+
 	/*
 	 * When SETUP_IOPOLL and SETUP_SQPOLL are both enabled, user
 	 * space applications don't need to do io completion events
@@ -3888,8 +3939,15 @@ static int io_register_enable_rings(struct io_ring_ctx *ctx)
 	if (!(ctx->flags & IORING_SETUP_R_DISABLED))
 		return -EBADFD;
 
-	if (ctx->flags & IORING_SETUP_SINGLE_ISSUER && !ctx->submitter_task)
+	if (ctx->flags & IORING_SETUP_SINGLE_ISSUER && !ctx->submitter_task) {
 		ctx->submitter_task = get_task_struct(current);
+		/*
+		 * Lazy activation attempts would fail if it was polled before
+		 * submitter_task is set.
+		 */
+		if (wq_has_sleeper(&ctx->poll_wq))
+			io_activate_pollwq(ctx);
+	}
 
 	if (ctx->restrictions.registered)
 		ctx->restricted = 1;
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index c75bbb94703c..5113e0ddb01d 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -222,7 +222,7 @@ static inline void io_commit_cqring(struct io_ring_ctx *ctx)
 
 static inline void io_poll_wq_wake(struct io_ring_ctx *ctx)
 {
-	if (waitqueue_active(&ctx->poll_wq))
+	if (wq_has_sleeper(&ctx->poll_wq))
 		__wake_up(&ctx->poll_wq, TASK_NORMAL, 0,
 				poll_to_key(EPOLL_URING_WAKE | EPOLLIN));
 }
@@ -230,8 +230,6 @@ static inline void io_poll_wq_wake(struct io_ring_ctx *ctx)
 /* requires smb_mb() prior, see wq_has_sleeper() */
 static inline void __io_cqring_wake(struct io_ring_ctx *ctx)
 {
-	io_poll_wq_wake(ctx);
-
 	/*
 	 * Trigger waitqueue handler on all waiters on our waitqueue. This
 	 * won't necessarily wake up all the tasks, io_should_wake() will make
@@ -316,7 +314,8 @@ static inline void io_req_complete_defer(struct io_kiocb *req)
 
 static inline void io_commit_cqring_flush(struct io_ring_ctx *ctx)
 {
-	if (unlikely(ctx->off_timeout_used || ctx->drain_active || ctx->has_evfd))
+	if (unlikely(ctx->off_timeout_used || ctx->drain_active ||
+		     ctx->has_evfd || ctx->poll_activated))
 		__io_commit_cqring_flush(ctx);
 }
 
-- 
2.38.1

