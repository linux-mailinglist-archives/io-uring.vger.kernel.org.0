Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B20F865E9B7
	for <lists+io-uring@lfdr.de>; Thu,  5 Jan 2023 12:23:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231244AbjAELXk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 5 Jan 2023 06:23:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233166AbjAELXd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 5 Jan 2023 06:23:33 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AED384E424
        for <io-uring@vger.kernel.org>; Thu,  5 Jan 2023 03:23:31 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id z8-20020a05600c220800b003d33b0bda11so2276250wml.0
        for <io-uring@vger.kernel.org>; Thu, 05 Jan 2023 03:23:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J32+a9orWjFm5kxfSVe7cvbZ2vnqIbSs9t/hFzOVmzg=;
        b=N4dpfa+ZpXQjakMpg5q3eicTBzPjtPsr22v3eNEqiheUaKkbgQPa5o6/PGd2X4kWar
         teLbS4f2KEUtrzWAz3MpEcc7d6Z2ERIo1I2r/lD/z0jgESPcDSytJ0lckSJyiWdpZToW
         OySJ44DE9RL82Vd/IYIaBZv+y+HurSBrqZLYidcMilpalpNtm6oyd7c8Uetg/72/ZWWZ
         PggqBHinvQLFEyY32kY0knPEhn8p0BB6Iug0vu9dYdKActFwJDNHEmvrVItbjaldofet
         +ICX2Mcr1t/gutOnPLcVY/2ZnpdNtXhqLwBo8CBCaWLbENtNfJgCnGb0G8yBjvw0V/Bl
         2mDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J32+a9orWjFm5kxfSVe7cvbZ2vnqIbSs9t/hFzOVmzg=;
        b=K/nGKYs2H3h0IzcadyxJ2F55mR5e5u4DSa7TiIRSIM9L+QMQmHx1WMS7sV6t/Uk5fb
         39N329ZjrIdfqohQJziaDVMU0ImOV4o/p6Tw3kUyv6IWucarMkKIEF/CJykblT1sQ0lu
         MWfA4AmJdlxXldLVdmKMY5DTLz8dp3QI0oZVm9OcMAWPK+v7eLSU7i2Xf8QHOcw3zZ0o
         taDSPrOQ3B4trUt7QwKsgYsdqcQGiVb0ngCis+qhs0fpXP63WSXAr2JXx2WZqxEBIJf6
         3utOXymxlBL0XwZLiXNCuUDSytXEsQKi5xoFy/UnQ5SfKySyDrqJQHWbk2FcGzUo+3i+
         ezGw==
X-Gm-Message-State: AFqh2kqyH0YZQCyM7wTutK54pyFkdM8btGsD7/THAiQc4DNPWyJOX8rL
        /VzzLS2ZaaoYqpC3BcU9FujcDrwHFX8=
X-Google-Smtp-Source: AMrXdXtxdrRda0VoqvpjUYhqzkYdcaBHr9wBjwfkuQk0c+Vt4NJ9HtA79XOdsWo7klgLs60E69AIrg==
X-Received: by 2002:a05:600c:358f:b0:3d9:7847:96e2 with SMTP id p15-20020a05600c358f00b003d9784796e2mr26818044wmq.2.1672917810116;
        Thu, 05 Jan 2023 03:23:30 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::2:5c5f])
        by smtp.gmail.com with ESMTPSA id u13-20020a05600c19cd00b003c6f1732f65sm2220688wmq.38.2023.01.05.03.23.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jan 2023 03:23:29 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCHSET REBASE 03/10] io_uring: kill io_run_task_work_ctx
Date:   Thu,  5 Jan 2023 11:22:22 +0000
Message-Id: <40953c65f7c88fb00cdc4d870ca5d5319fb3d7ea.1672916894.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1672916894.git.asml.silence@gmail.com>
References: <cover.1672916894.git.asml.silence@gmail.com>
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

There is only one user of io_run_task_work_ctx(), inline it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c |  6 +++++-
 io_uring/io_uring.h | 20 --------------------
 2 files changed, 5 insertions(+), 21 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index ec800a8bed28..bf6f9777d165 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2452,7 +2452,11 @@ static int io_wake_function(struct wait_queue_entry *curr, unsigned int mode,
 
 int io_run_task_work_sig(struct io_ring_ctx *ctx)
 {
-	if (io_run_task_work_ctx(ctx) > 0)
+	if (!llist_empty(&ctx->work_llist)) {
+		if (io_run_local_work(ctx) > 0)
+			return 1;
+	}
+	if (io_run_task_work() > 0)
 		return 1;
 	if (task_sigpending(current))
 		return -EINTR;
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 46c0f765a77a..8a5c3affd724 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -269,26 +269,6 @@ static inline bool io_task_work_pending(struct io_ring_ctx *ctx)
 	return task_work_pending(current) || !wq_list_empty(&ctx->work_llist);
 }
 
-static inline int io_run_task_work_ctx(struct io_ring_ctx *ctx)
-{
-	int ret = 0;
-	int ret2;
-
-	if (!llist_empty(&ctx->work_llist))
-		ret = io_run_local_work(ctx);
-
-	/* want to run this after in case more is added */
-	ret2 = io_run_task_work();
-
-	/* Try propagate error in favour of if tasks were run,
-	 * but still make sure to run them if requested
-	 */
-	if (ret >= 0)
-		ret += ret2;
-
-	return ret;
-}
-
 static inline int io_run_local_work_locked(struct io_ring_ctx *ctx)
 {
 	bool locked;
-- 
2.38.1

