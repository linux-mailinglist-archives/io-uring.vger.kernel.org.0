Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 553B765B993
	for <lists+io-uring@lfdr.de>; Tue,  3 Jan 2023 04:05:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236604AbjACDFe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 2 Jan 2023 22:05:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236638AbjACDFb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 2 Jan 2023 22:05:31 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60B2EB7F8
        for <io-uring@vger.kernel.org>; Mon,  2 Jan 2023 19:05:30 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id p1-20020a05600c1d8100b003d8c9b191e0so22155887wms.4
        for <io-uring@vger.kernel.org>; Mon, 02 Jan 2023 19:05:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Qv2lXExtqdHyonmaWjP9naQwvPOWtKueXxlt47AT7+Q=;
        b=PnsIDb18B/vxcSI4wedC/aaATrKp56nZJMOKZlDzYLQy0dK/RQTsbGcgzzNIssn7vp
         3UjFVy5ONbgRVTPehSymUh9TymG2oWFx/A/8dBFu2XjutgC86DKDt2xqFVvoekxjxyG0
         pry/IHPmrcZDbZqMSwXfoas6bkJUtdsGb0LM/cWu/4E/LCErg2Xp9Ge8wGJ0fwgiHrFh
         eY3LK8M1UXmFJiWzxTdhossiiVSZN86PictO2NROia3/CiXxQMyxPeVZKVGo5oVkRQ8p
         tIbYdauFQKjjZuQ0obPH4jLJ+4tAsXZkI8+RJRwEM+kydHVeg7rqaAo6OuRGWdJVueBN
         Qv2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Qv2lXExtqdHyonmaWjP9naQwvPOWtKueXxlt47AT7+Q=;
        b=8PsEbYEj0ogmxqXUViW0r+YNoCDoQQCOlVQAOl0Npf7l5jWU/n2h8hXhdDCo6hUTmd
         zwNz/gQ/s7m8BMSjrHgMvoDOW+uNWYi70+3FoH2c4MFOj08jiiKELkBOfIC38pbA8Zho
         9oK0lYBl1CT8j/YOLEq56Y5tvb2103iiFAVKsD+T8mQeiPuJw36xFOr0K0k4forQ+NHb
         uB3y6JdYTOhGvA8jPxsTpWVpvm8rMbNm4y2b7HIEZmNeqT6Df+ZrQLaDbrtdF/KaBeOY
         UxO2CtP0MZhMQXeSOA0MTd2MJQvOlBDgfU35wdaxIu+zwo8I0lhlN8AE/mKhS+rS1EtJ
         bSNg==
X-Gm-Message-State: AFqh2kpfygWO5OcBHXXu1YqRdWgpauog74LT4hLD3zhB9Y0ImuosfavA
        0orgO5Lc3zVPIhaLrsNZcNsHxix9T08=
X-Google-Smtp-Source: AMrXdXsYu6VxU2QovbAAqeVYmUIapDtiNJ3vlnGNW7QLrG1ysRcgXWOYLWZRHbKWtYHPoga0lkHNoQ==
X-Received: by 2002:a05:600c:500a:b0:3d3:5b56:b834 with SMTP id n10-20020a05600c500a00b003d35b56b834mr30081030wmr.5.1672715128693;
        Mon, 02 Jan 2023 19:05:28 -0800 (PST)
Received: from 127.0.0.1localhost (188.28.229.101.threembb.co.uk. [188.28.229.101])
        by smtp.gmail.com with ESMTPSA id m1-20020a7bca41000000b003d1de805de5sm39967839wml.16.2023.01.02.19.05.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Jan 2023 19:05:28 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [RFC v2 12/13] io_uring: waitqueue-less cq waiting
Date:   Tue,  3 Jan 2023 03:04:03 +0000
Message-Id: <304db555100334593675eba81fd07f95d7ec02f5.1672713341.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1672713341.git.asml.silence@gmail.com>
References: <cover.1672713341.git.asml.silence@gmail.com>
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

With DEFER_TASKRUN only ctx->submitter_task might be waiting for CQEs,
we can use this to optimise io_cqring_wait(). Replace ->cq_wait
waitqueue with waking the task directly.

It works but misses an important optimisation covered by the following
patch, so this patch without follow ups might hurt performance.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 98d0d9e49be0..943032d2fd21 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1273,7 +1273,12 @@ static void io_req_local_work_add(struct io_kiocb *req)
 
 	if (ctx->has_evfd)
 		io_eventfd_signal(ctx);
-	__io_cqring_wake(ctx);
+
+	if (ctx->flags & IORING_SETUP_DEFER_TASKRUN) {
+		wake_up_state(ctx->submitter_task, TASK_INTERRUPTIBLE);
+	} else {
+		__io_cqring_wake(ctx);
+	}
 }
 
 void __io_req_task_work_add(struct io_kiocb *req, bool allow_local)
@@ -2558,12 +2563,17 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 	do {
 		unsigned long check_cq;
 
-		prepare_to_wait_exclusive(&ctx->cq_wait, &iowq.wq,
-						TASK_INTERRUPTIBLE);
+		if (ctx->flags & IORING_SETUP_DEFER_TASKRUN) {
+			set_current_state(TASK_INTERRUPTIBLE);
+		} else {
+			prepare_to_wait_exclusive(&ctx->cq_wait, &iowq.wq,
+							TASK_INTERRUPTIBLE);
+		}
+
 		ret = io_cqring_wait_schedule(ctx, &iowq, timeout);
+		__set_current_state(TASK_RUNNING);
 		if (ret < 0)
 			break;
-		__set_current_state(TASK_RUNNING);
 		/*
 		 * Run task_work after scheduling and before io_should_wake().
 		 * If we got woken because of task_work being processed, run it
@@ -2591,7 +2601,8 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 		cond_resched();
 	} while (1);
 
-	finish_wait(&ctx->cq_wait, &iowq.wq);
+	if (!(ctx->flags & IORING_SETUP_DEFER_TASKRUN))
+		finish_wait(&ctx->cq_wait, &iowq.wq);
 	restore_saved_sigmask_unless(ret == -EINTR);
 
 	return READ_ONCE(rings->cq.head) == READ_ONCE(rings->cq.tail) ? ret : 0;
-- 
2.38.1

