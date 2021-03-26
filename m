Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D059334ABF2
	for <lists+io-uring@lfdr.de>; Fri, 26 Mar 2021 16:53:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231195AbhCZPwu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Mar 2021 11:52:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230114AbhCZPwO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Mar 2021 11:52:14 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E4C4C0613B3
        for <io-uring@vger.kernel.org>; Fri, 26 Mar 2021 08:52:14 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id z3so5838568ioc.8
        for <io-uring@vger.kernel.org>; Fri, 26 Mar 2021 08:52:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UxQIrqL1e1bv0TRTUopnjE8m4DjY4XOhdCxrLXbG/MQ=;
        b=Ryt6S/JZtVfje1gjWOS/t0o0Wh1W0sKRoPp86aSmIEzuLprM33JiAcTE8SCHUpn8bU
         GxwTJC5xSyGSNDdEFKQoXnx7M0etduPePYTTLsLX3Q3gqvAkmLqkv/V0Y32iYqlK+U2p
         59UYoFxpZjJqaRX/YGLHK4v842D7mbC4Pif+1t3OqAncjMq7igH+y/zmm5VeGB6OpZz4
         yNyovWpB2VzkHc60Mi1iMjrUb7qjrQ7BcGdddY9aR08bX0JqGotZZ1LGcU8HAL6N5WrB
         sOEcN/bk3ljBw9Jrq4d+qhtFYee7iOqQlC0Q76Q3tfYfRxti61s1hoD04CmSWHkyC23u
         SboQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UxQIrqL1e1bv0TRTUopnjE8m4DjY4XOhdCxrLXbG/MQ=;
        b=mG+f29mJHjKbZ2YozymRIs2S0G5nuH0lOH9PG4S/+wtAmy+qiTHHMKfqO1kb21DK//
         r5Zd16p3fBM7d3n39CyJM2QHmLSNkGrrznUjmrQKtHHGPXpJPY0X2yyEpdaVTWBZvz/i
         HQEY7dPM/A9aeNEv/t/AkBlpCWAPo6/3FXPpQnRILaUnpr5+Yro0bzczuL0q1SSg2THF
         hcj1My+cAf5ukiCqCEwKU3zQm/PDMPZ+jL+QzGbz/XpLeS02roCuRtrG+3b6ngnmC9aH
         5YQ2tl2jw+LN2CFzKbCLhip0R2UJh78NMJbnKTFiHS+SjBKkCJAuadp1HzQA8fSIn60v
         L3TA==
X-Gm-Message-State: AOAM533BbrSr9qSVhw4e5MooYgqdxWHPkKojSQ4QBpRhogWhK6u3/DGK
        V3wpC2xRTkOFLRQduWbJthlDL36x8HgjwQ==
X-Google-Smtp-Source: ABdhPJxxGXzjendQFH5f3P7Q/JmG83kJRw4+RWa9A+cP3R9et+07qPBusau4Y00kjMT+xXF8fisl8w==
X-Received: by 2002:a05:6638:2101:: with SMTP id n1mr12853547jaj.7.1616773933951;
        Fri, 26 Mar 2021 08:52:13 -0700 (PDT)
Received: from p1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id a7sm4456337ilj.64.2021.03.26.08.52.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Mar 2021 08:52:13 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     torvalds@linux-foundation.org, ebiederm@xmission.com,
        metze@samba.org, oleg@redhat.com, linux-kernel@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 08/10] io_uring: do post-completion chore on t-out cancel
Date:   Fri, 26 Mar 2021 09:51:26 -0600
Message-Id: <20210326155128.1057078-14-axboe@kernel.dk>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210326155128.1057078-1-axboe@kernel.dk>
References: <20210326155128.1057078-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

Don't forget about io_commit_cqring() + io_cqring_ev_posted() after
exit/exec cancelling timeouts. Both functions declared only after
io_kill_timeouts(), so to avoid tons of forward declarations move
it down.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/72ace588772c0f14834a6a4185d56c445a366fb4.1616696997.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 42 ++++++++++++++++++++++--------------------
 1 file changed, 22 insertions(+), 20 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 4d0cb2548a67..69896ae204d6 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1262,26 +1262,6 @@ static void io_kill_timeout(struct io_kiocb *req, int status)
 	}
 }
 
-/*
- * Returns true if we found and killed one or more timeouts
- */
-static bool io_kill_timeouts(struct io_ring_ctx *ctx, struct task_struct *tsk,
-			     struct files_struct *files)
-{
-	struct io_kiocb *req, *tmp;
-	int canceled = 0;
-
-	spin_lock_irq(&ctx->completion_lock);
-	list_for_each_entry_safe(req, tmp, &ctx->timeout_list, timeout.list) {
-		if (io_match_task(req, tsk, files)) {
-			io_kill_timeout(req, -ECANCELED);
-			canceled++;
-		}
-	}
-	spin_unlock_irq(&ctx->completion_lock);
-	return canceled != 0;
-}
-
 static void __io_queue_deferred(struct io_ring_ctx *ctx)
 {
 	do {
@@ -8612,6 +8592,28 @@ static void io_ring_exit_work(struct work_struct *work)
 	io_ring_ctx_free(ctx);
 }
 
+/* Returns true if we found and killed one or more timeouts */
+static bool io_kill_timeouts(struct io_ring_ctx *ctx, struct task_struct *tsk,
+			     struct files_struct *files)
+{
+	struct io_kiocb *req, *tmp;
+	int canceled = 0;
+
+	spin_lock_irq(&ctx->completion_lock);
+	list_for_each_entry_safe(req, tmp, &ctx->timeout_list, timeout.list) {
+		if (io_match_task(req, tsk, files)) {
+			io_kill_timeout(req, -ECANCELED);
+			canceled++;
+		}
+	}
+	io_commit_cqring(ctx);
+	spin_unlock_irq(&ctx->completion_lock);
+
+	if (canceled != 0)
+		io_cqring_ev_posted(ctx);
+	return canceled != 0;
+}
+
 static void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
 {
 	unsigned long index;
-- 
2.31.0

