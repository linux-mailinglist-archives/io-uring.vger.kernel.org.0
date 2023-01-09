Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1141662908
	for <lists+io-uring@lfdr.de>; Mon,  9 Jan 2023 15:51:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234548AbjAIOvg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Jan 2023 09:51:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234815AbjAIOvQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Jan 2023 09:51:16 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDB76271A6
        for <io-uring@vger.kernel.org>; Mon,  9 Jan 2023 06:47:42 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id tz12so20678164ejc.9
        for <io-uring@vger.kernel.org>; Mon, 09 Jan 2023 06:47:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+S/GxxwY7MGRf0XItvsCVaZvfgzyrrliz/LimNKh8PM=;
        b=brWT38DZI6jp30z52TAmTZbMjUZM9WlUXb0LR18iHP/Xz9nmQggcZInJdZLdfA5pU1
         /nIC0zQB9zpVXp++fyJFzdPmiY1IRfrloHy0zbTkjZENpQx4p/Drx4DPvrC83AfWv7nS
         4VdxaR9HSf0tI5kbc3JcnbP8vs9FJPSQPgEI3vXhsWVfz0d0pJ0tqWqDLxd0BjBESwyg
         rWpZQwcIe4dnux62kRKHrQXC/mMsRhGQcUpYRYX1a0nlylQyieRuuwnpIogLjRLzxvZX
         tv4yINuPCLN69pMwVOZ6WzQmo04+cYgtqJaTfz4/uqrzjJSyGFoZMVBRkaDdL+yEs5sQ
         qJjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+S/GxxwY7MGRf0XItvsCVaZvfgzyrrliz/LimNKh8PM=;
        b=fpJIY+mPfjPVbcADPnElPS2JmiBZT3scjiFhM+kkqwvMvUVJR4EzEeceOl6ewCF67+
         ACQ/M6J+mRYpcsOfZwgDrOiT9uzrG5bfo12351EQllQAbjrpQBm2rShN127YBpxrl7J9
         NC6c+B1UPz5FI3Mwqicj44ldtUjUdplQ1xv26SDCQiE72JQoqD1s0pt5EbW4F7zcR576
         au6fzioj3FbN6MXY0FNXdDpu3odWLwBxf3UDg2m8W+mQKtkvoASj0ilL1XK/pybxl4Lx
         ZLcaof0dLWfgOR8MMosXLiOb5LkppGHVMYHQJG3pqW/bll0eIUFPLQTCPv+Gawrr6Pop
         5oPw==
X-Gm-Message-State: AFqh2kqGRzuvgU3hUkyaRRg29cgBYrwJnp0bFKKXyAP7KrAyvOF1j4kj
        to6FB+b0wTUOjGmHUEh8IeysKFSihXg=
X-Google-Smtp-Source: AMrXdXv5wcjMRIG307l7B27Mo1dP5AjPR9yVMlnSJv+8cj4dpHReUKYweZtF6OLkA1KDN4Cfj22LBA==
X-Received: by 2002:a17:907:d388:b0:846:cdd9:d29 with SMTP id vh8-20020a170907d38800b00846cdd90d29mr51808678ejc.28.1673275662313;
        Mon, 09 Jan 2023 06:47:42 -0800 (PST)
Received: from 127.0.0.1localhost (188.29.102.7.threembb.co.uk. [188.29.102.7])
        by smtp.gmail.com with ESMTPSA id x11-20020a170906b08b00b0084c62b7b7d8sm3839578ejy.187.2023.01.09.06.47.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jan 2023 06:47:42 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH v3 10/11] io_uring: add io_req_local_work_add wake fast path
Date:   Mon,  9 Jan 2023 14:46:12 +0000
Message-Id: <717702d772825a6647e6c315b4690277ba84c3fc.1673274244.git.asml.silence@gmail.com>
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

Don't wake the master task after queueing a deferred tw unless it's
currently waiting in io_cqring_wait.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring_types.h | 1 +
 io_uring/io_uring.c            | 7 ++++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 7b5e90520278..cc0cf0705b8f 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -295,6 +295,7 @@ struct io_ring_ctx {
 		spinlock_t		completion_lock;
 
 		bool			poll_multi_queue;
+		bool			cq_waiting;
 
 		/*
 		 * ->iopoll_list is protected by the ctx->uring_lock for
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 62d879b14873..9c95ceb1a9f2 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1276,7 +1276,9 @@ static void io_req_local_work_add(struct io_kiocb *req)
 		atomic_or(IORING_SQ_TASKRUN, &ctx->rings->sq_flags);
 	if (ctx->has_evfd)
 		io_eventfd_signal(ctx);
-	wake_up_state(ctx->submitter_task, TASK_INTERRUPTIBLE);
+
+	if (READ_ONCE(ctx->cq_waiting))
+		wake_up_state(ctx->submitter_task, TASK_INTERRUPTIBLE);
 	percpu_ref_put(&ctx->refs);
 }
 
@@ -2578,6 +2580,7 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 		unsigned long check_cq;
 
 		if (ctx->flags & IORING_SETUP_DEFER_TASKRUN) {
+			WRITE_ONCE(ctx->cq_waiting, 1);
 			set_current_state(TASK_INTERRUPTIBLE);
 		} else {
 			prepare_to_wait_exclusive(&ctx->cq_wait, &iowq.wq,
@@ -2586,6 +2589,8 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 
 		ret = io_cqring_wait_schedule(ctx, &iowq);
 		__set_current_state(TASK_RUNNING);
+		WRITE_ONCE(ctx->cq_waiting, 0);
+
 		if (ret < 0)
 			break;
 		/*
-- 
2.38.1

