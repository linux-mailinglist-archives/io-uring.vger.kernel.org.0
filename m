Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 873223E453A
	for <lists+io-uring@lfdr.de>; Mon,  9 Aug 2021 14:05:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235339AbhHIMFg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Aug 2021 08:05:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235338AbhHIMFf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Aug 2021 08:05:35 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4956C0613D3
        for <io-uring@vger.kernel.org>; Mon,  9 Aug 2021 05:05:14 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id n12so11034485wrr.2
        for <io-uring@vger.kernel.org>; Mon, 09 Aug 2021 05:05:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=QoSeUIF3CpABLJ2fLJKgJdZ/o4jwmSKvnm+6eiBvd6g=;
        b=CP1O4k79JmgMv99cQ8EajsSWJodAdtoeMjMQqvCp6QyQ6wS5SzZzor280bJa2HLQmR
         bLU3EKU/Aa65WNcOWF9dGpRUblFQg3FGIgFk4Uw7a6s9bvM6DKp3udbLL8DvlOkDIVR4
         dhkAhnSmMDa1JIL+cItalCySyLmUkO8gvHrj2LUNagh2u6u1UGg+7OxLXaXglI7Y2qoa
         xjEJSK403lRRrmOyuTDksTjzU3/Bbfu5eYTNvG/pcxRADNxPKMkY6AEYzzTHiVwVnI8D
         eKk7NeX4YL1mmlK9tGHPWfniYAHl+GG7WI8KYdROEz1J4HQDcv5wyytx7M1ZoRun41nv
         /OQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QoSeUIF3CpABLJ2fLJKgJdZ/o4jwmSKvnm+6eiBvd6g=;
        b=QVToS/RF6pcnfcfcfpp+xXjJ2TN9WwT/5njaRBgqS05MAhovFPw7yKcWqNo+nm+HAe
         NoI6mv1o5uLiuchrGIEK724KyIC3/YGt8BP+7xYE9xRC3PVVcPualvPihHGrx4ohXMvh
         K92VMGb+fn8RrwC54TGh6/7uHPO/BS4539p4310r4WULbh44DfJE3YATucO/rGmGwFto
         JmxNd3xU7XFAtY/2nke3hFu2AVdZo2bqhW5qtLlKBxLPIgsuSOyE7KcFWJQGCQuyRIu+
         Gw25v7Irl4Q6QLNI6eolDxDXQnpmWCD7X1NLrJ7fWAGcUwahinuJDpeXn7otUFaylqwS
         BwQA==
X-Gm-Message-State: AOAM530q+i7Da/S8wGCBb07uidYncnJFX4z4Jzq+yGiOedvpDw87c7na
        +OUoLw1RnsRd26vcLp3IPLQ=
X-Google-Smtp-Source: ABdhPJzM/TM3r1dmZng2G3GPYzRhF0YlM17GgDTVGJZRiCMWOm6XWQs9W/gyczcvV3NPIZbg5SpAhQ==
X-Received: by 2002:a5d:68cb:: with SMTP id p11mr25068185wrw.364.1628510713634;
        Mon, 09 Aug 2021 05:05:13 -0700 (PDT)
Received: from localhost.localdomain ([85.255.236.119])
        by smtp.gmail.com with ESMTPSA id g35sm4757062wmp.9.2021.08.09.05.05.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 05:05:13 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 11/28] io_uring: optimise io_cqring_wait() hot path
Date:   Mon,  9 Aug 2021 13:04:11 +0100
Message-Id: <6f1b81c60b947d165583dc333947869c3d85d037.1628471125.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1628471125.git.asml.silence@gmail.com>
References: <cover.1628471125.git.asml.silence@gmail.com>
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
index 0f49736cd2b4..0fd04d25c520 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7062,15 +7062,7 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
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
@@ -7104,7 +7096,13 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
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

