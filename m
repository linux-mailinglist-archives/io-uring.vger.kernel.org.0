Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1010065E952
	for <lists+io-uring@lfdr.de>; Thu,  5 Jan 2023 11:51:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232196AbjAEKu7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 5 Jan 2023 05:50:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232214AbjAEKu2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 5 Jan 2023 05:50:28 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1418559F4
        for <io-uring@vger.kernel.org>; Thu,  5 Jan 2023 02:50:13 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id g10so13918996wmo.1
        for <io-uring@vger.kernel.org>; Thu, 05 Jan 2023 02:50:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=w77psyvSvnkLAXlGYEMZalmNp9OObVymnj+u/wsnPl8=;
        b=S/eVQryr10ApSIWT7Xy/49ple8aFvdfov/+TsVWRiv6VP1eu5EYANYp4Co/n3OV01T
         9Ksq9DeO6sFNfQ2DnJ/BJd1v4EPfNDVEU+QIaMMsZotIkWAOnF3c694ZSQU0/9MuUhez
         xCB7nO6TpraMWpwFxgXRYzmU6teIH1J8arFs84jogKze1BX9nwcnDUeS3kbLy8RQqUSC
         sT7QTuorclfHxPUoBKIfhub4zgpGpnUNnqFjEVpAUiW1d1Ipb2Dh6ki3ucFgqP2LDivV
         5hNUYn+jrYqffANS2Xjb+XgTcALhpekVRxHCFt8N7rvS4BJ5kOVrVCMHs/36F45mK4Tl
         qODg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=w77psyvSvnkLAXlGYEMZalmNp9OObVymnj+u/wsnPl8=;
        b=TwOYUhv74dabLOqTUPV3cS7cjCceqIc0pRzWC6sHIPusgGeklOcm3yvSoPY1qENNta
         H8QhD4jBZwvdmxwmZp27Xgo+TBn0Jt1GKjBcb1KX1AucynkmV6OhsdGuJoRqYElvuoJl
         VB3WuueTyXS2Q9qC0G4+ADbxMP1Cs69z6co2ZYvpENdh5hCaiTs/zhhivEqMF4GfVvh2
         rlrcYcIaNDexC+9t0ImF93P050QBf0Juy8IAMWkbPMsqOOSCj0cDoR+wdC4F8j/6jS/j
         3eiua4hNoVSjckSu/5Gc32+RhO5dDMaIiOSv2FfNfLZRrKWAbhOOAvLIg1D9UWTS2FHd
         JDxg==
X-Gm-Message-State: AFqh2kqf36qSbGeyzwpwbOY8L5RN41WcxYEyemroezDIDn/TK8swOXjZ
        ax4Gr+S8bO3oqEGFRXSsxd2LySawyFg=
X-Google-Smtp-Source: AMrXdXvtOGRxcBF0Sv91XxwPc+QsyErDpsvYi9Ty99tEvFgoa0mMNo2OZXq8+EnGPcHyhApO1K1spw==
X-Received: by 2002:a05:600c:601b:b0:3d3:56ce:5693 with SMTP id az27-20020a05600c601b00b003d356ce5693mr35328852wmb.17.1672915812221;
        Thu, 05 Jan 2023 02:50:12 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::2:5c5f])
        by smtp.gmail.com with ESMTPSA id v16-20020a05600c445000b003c6c3fb3cf6sm2185035wmn.18.2023.01.05.02.50.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jan 2023 02:50:11 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH v2] io_uring: fix CQ waiting timeout handling
Date:   Thu,  5 Jan 2023 10:49:15 +0000
Message-Id: <f7bffddd71b08f28a877d44d37ac953ddb01590d.1672915663.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
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

Jiffy to ktime CQ waiting conversion broke how we treat timeouts, in
particular we rearm it anew every time we get into
io_cqring_wait_schedule() without adjusting the timeout. Waiting for 2
CQEs and getting a task_work in the middle may double the timeout value,
or even worse in some cases task may wait indefinitely.

Cc: stable@vger.kernel.org
Fixes: 228339662b398 ("io_uring: don't convert to jiffies for waiting on timeouts")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---

v2: rebase

 io_uring/io_uring.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 472574192dd6..2ac1cd8d23ea 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2470,7 +2470,7 @@ int io_run_task_work_sig(struct io_ring_ctx *ctx)
 /* when returns >0, the caller should retry */
 static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
 					  struct io_wait_queue *iowq,
-					  ktime_t timeout)
+					  ktime_t *timeout)
 {
 	int ret;
 	unsigned long check_cq;
@@ -2488,7 +2488,7 @@ static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
 		if (check_cq & BIT(IO_CHECK_CQ_DROPPED_BIT))
 			return -EBADR;
 	}
-	if (!schedule_hrtimeout(&timeout, HRTIMER_MODE_ABS))
+	if (!schedule_hrtimeout(timeout, HRTIMER_MODE_ABS))
 		return -ETIME;
 
 	/*
@@ -2564,7 +2564,7 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 		}
 		prepare_to_wait_exclusive(&ctx->cq_wait, &iowq.wq,
 						TASK_INTERRUPTIBLE);
-		ret = io_cqring_wait_schedule(ctx, &iowq, timeout);
+		ret = io_cqring_wait_schedule(ctx, &iowq, &timeout);
 		if (__io_cqring_events_user(ctx) >= min_events)
 			break;
 		cond_resched();
-- 
2.38.1

