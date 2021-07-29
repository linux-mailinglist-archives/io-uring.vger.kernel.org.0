Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F2043DA714
	for <lists+io-uring@lfdr.de>; Thu, 29 Jul 2021 17:06:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237688AbhG2PGe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 29 Jul 2021 11:06:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237648AbhG2PGd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 29 Jul 2021 11:06:33 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8990C061765
        for <io-uring@vger.kernel.org>; Thu, 29 Jul 2021 08:06:29 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id n28-20020a05600c3b9cb02902552e60df56so4243982wms.0
        for <io-uring@vger.kernel.org>; Thu, 29 Jul 2021 08:06:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=goAiCTcUe/HVYoNa3JGZQuLYRmuvvJCnSbqX7sdf3LU=;
        b=bg8ia4pdSH7iz/HpDuHyD6lRAjZHrz99G2l8ihe3kUMdcj9ytsGhMq083lAtEUS4Qt
         Woq+fX7vUKdQz//htKQdGMmycKXu2D+U7gLnJWeTHOP3kf+PhblY5O88CI37n3M76EWC
         +Sf+34yBGLlPtxEYM3X0iU1zf4Zp5ghYweeK5LG5F6Vnftn+CjLDfGEehdhgXXDH8/jO
         kRaLM8yyFR+ViUTzb1IqzV7hh0NRFlx49LZReKD7bixUCGirEHULKylfm1QP4UbxmTX8
         rhSdiWVMjU81th+9r5KCnKMV2CsrBoid9v9G2lo8PZpSit8JiMqf1LkK7bawNmZvJC4X
         UqAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=goAiCTcUe/HVYoNa3JGZQuLYRmuvvJCnSbqX7sdf3LU=;
        b=tOccyVmNjWVw68OvDwdeYdgAJ5s00HqS3UvQnpp7OnGznKBYxMoPhEcX55OgZac2hP
         jT6/hwPIdE4NkV5aXK89ckKzm35Y45S0xzmeq/gWmaTQncxBAM1JNi/to7ouag0lRPWX
         ZaQQDYk8IESue8iKScmkghl5O53+YuB6WHoukV7BpvPXockuzQTGBS/5zamDv06vbcQ5
         Q2NxWy8eq1sQcnjg2TvWHW0P00ne7czV7NLOMssh1aCFefifcoUjYAfcGJ7oVuU0MNvg
         1t1bskBOa0gKaeZIV8rNuKNvU/ulJaZ+sq+CyI76zPNSaxJ778XSGpyxwjww3FbkNSeB
         GcvQ==
X-Gm-Message-State: AOAM5333h4UyIMfsmAN3z7lEeUTCf8e3f9AQg8s41Wlen0eDIVxN1e7K
        jFn5Og5MsDbQ/cPHeKr+2Kc=
X-Google-Smtp-Source: ABdhPJwDapDoSFlLF4eWt8Cp8Ll+lkHKneX0vdL6lFfqsPBq0HOehEHKACa30kUwm2hGqr/h2s+9BQ==
X-Received: by 2002:a1c:ed03:: with SMTP id l3mr5112943wmh.56.1627571188496;
        Thu, 29 Jul 2021 08:06:28 -0700 (PDT)
Received: from localhost.localdomain ([148.252.128.141])
        by smtp.gmail.com with ESMTPSA id e6sm4764577wrg.18.2021.07.29.08.06.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 08:06:28 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 06/23] io_uring: optimise io_cqring_wait() hot path
Date:   Thu, 29 Jul 2021 16:05:33 +0100
Message-Id: <e20f9aa5d8aea54e719eb87343846104ebada2b9.1627570633.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1627570633.git.asml.silence@gmail.com>
References: <cover.1627570633.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Turns out we always init struct io_wait_queue in io_cqring_wait(), even
if it's not used after, i.e. there are already enough of CQEs. And often
it's exactly what happens, for instance, requests may have been
completed inline, or in case of io_uring_enter(submit=N, wait=1).

It shows up in my profiler, so optimise it by delaying the struct init.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index a7e7a555ae8e..85cd8c3a33e1 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7039,15 +7039,7 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 			  const sigset_t __user *sig, size_t sigsz,
 			  struct __kernel_timespec __user *uts)
 {
-	struct io_wait_queue iowq = {
-		.wq = {
-			.private	= current,
-			.func		= io_wake_function,
-			.entry		= LIST_HEAD_INIT(iowq.wq.entry),
-		},
-		.ctx		= ctx,
-		.to_wait	= min_events,
-	};
+	struct io_wait_queue iowq;
 	struct io_rings *rings = ctx->rings;
 	signed long timeout = MAX_SCHEDULE_TIMEOUT;
 	int ret;
@@ -7081,7 +7073,13 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 		timeout = timespec64_to_jiffies(&ts);
 	}
 
+	init_waitqueue_func_entry(&iowq.wq, io_wake_function);
+	iowq.wq.private = current;
+	INIT_LIST_HEAD(&iowq.wq.entry);
+	iowq.ctx = ctx;
+	iowq.to_wait = min_events;
 	iowq.nr_timeouts = atomic_read(&ctx->cq_timeouts);
+
 	trace_io_uring_cqring_wait(ctx, min_events);
 	do {
 		/* if we can't even flush overflow, don't wait for more */
-- 
2.32.0

