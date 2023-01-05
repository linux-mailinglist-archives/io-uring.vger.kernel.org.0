Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21F5F65E935
	for <lists+io-uring@lfdr.de>; Thu,  5 Jan 2023 11:46:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232803AbjAEKpu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 5 Jan 2023 05:45:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232769AbjAEKpi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 5 Jan 2023 05:45:38 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A3DF3E0E9
        for <io-uring@vger.kernel.org>; Thu,  5 Jan 2023 02:45:37 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id co23so35717094wrb.4
        for <io-uring@vger.kernel.org>; Thu, 05 Jan 2023 02:45:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=F+dBSIOzXtuC/wWGbmLiyueE1g9asRHSjL8PxeYuA+Y=;
        b=gHsjo+i1IeZbogwb4TkdpvkM87U4/vBTAKrKjY6CG9ArfgSt5YTD2hyYgXfIZ/Qog/
         tWnckjpqxkckCJNbD1WAh0Y0F5KJq651/wLI3fFp6HKoGxZLWyM15+bvdpqci1uRQu1Y
         OZAO8YxLsNepLj+kaRfUSxCjdV4Kc5tilg1vT56bwbpGdy6F8gyEAtYjkQuRSXi/uKnJ
         zi+79woIy7adxRCRleSdXVzwZewg6xX5QuyFS0rMZ+7Y8XhX98mlzm/WmOc+hdZidZLT
         J1pueykcBH/+lAclr3LojcxHHnuyFzFOXkGPdiIgfEcvctiBpG0652hCkhUagL017uWa
         dEvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=F+dBSIOzXtuC/wWGbmLiyueE1g9asRHSjL8PxeYuA+Y=;
        b=L9uwrHBi+jlJOEpO1sD1sLF0Pe0YWMUpJInIbUa3O4Hv4QbTOc2Hg6wqAJMhPZGP9Z
         xiRTfzbvuyZMZabdkwdM2InoYdH939qeVUVWvUbX01prAg8Q2SkAhiKRmZKe/2sQocoN
         w/MJsh4KVeB8bj4wGJZD5Glt2nvbRrqMP9/GfnmLUPvith9yCbnlsSiiXHR+mKdBXyU1
         KmBw/CxNfIN/SC+hXHdET43ieZx5my9NV5MSxZ4oKV514NyjOv69H4ov35p4Sj6Lx/lz
         9Tspjl1cPLT3rSAXmbyIw/FsYUhThKoCgtJ89wjMC0BC4URPgUc3OWGzfi2/mfcEQw+q
         vizg==
X-Gm-Message-State: AFqh2koEbxDzDkHn6CXEJkUlS25Z7sHaCupcBVAWwJL/na177WGfLDRo
        zoi+OfED32bFOYBv7+u4GvBpzEBb0oY=
X-Google-Smtp-Source: AMrXdXu1aCPZJ4Yz2DVjd+2jTeW0kcg5MQ1UAiJH3b8ub5mg9PjS70KYUSGV2eedmBxfzJ4WnAuDSA==
X-Received: by 2002:adf:f4c5:0:b0:291:3f93:b7d1 with SMTP id h5-20020adff4c5000000b002913f93b7d1mr13114114wrp.64.1672915535896;
        Thu, 05 Jan 2023 02:45:35 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::2:1e6c])
        by smtp.gmail.com with ESMTPSA id e16-20020adfdbd0000000b002362f6fcaf5sm36129664wrj.48.2023.01.05.02.45.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jan 2023 02:45:35 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH] io_uring: fix CQ waiting timeout handling
Date:   Thu,  5 Jan 2023 10:44:33 +0000
Message-Id: <609a38a65f91643f9f9706b983a8aaa0e3001d77.1672915374.git.asml.silence@gmail.com>
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
 io_uring/io_uring.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index adecdf65b130..71cd2edcc432 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2401,7 +2401,7 @@ int io_run_task_work_sig(struct io_ring_ctx *ctx)
 /* when returns >0, the caller should retry */
 static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
 					  struct io_wait_queue *iowq,
-					  ktime_t timeout)
+					  ktime_t *timeout)
 {
 	int ret;
 	unsigned long check_cq;
@@ -2419,7 +2419,7 @@ static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
 		if (check_cq & BIT(IO_CHECK_CQ_DROPPED_BIT))
 			return -EBADR;
 	}
-	if (!schedule_hrtimeout(&timeout, HRTIMER_MODE_ABS))
+	if (!schedule_hrtimeout(timeout, HRTIMER_MODE_ABS))
 		return -ETIME;
 	return 1;
 }
@@ -2489,7 +2489,7 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 		}
 		prepare_to_wait_exclusive(&ctx->cq_wait, &iowq.wq,
 						TASK_INTERRUPTIBLE);
-		ret = io_cqring_wait_schedule(ctx, &iowq, timeout);
+		ret = io_cqring_wait_schedule(ctx, &iowq, &timeout);
 		cond_resched();
 	} while (ret > 0);
 
-- 
2.38.1

