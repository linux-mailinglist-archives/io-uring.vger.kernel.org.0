Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53C392E8807
	for <lists+io-uring@lfdr.de>; Sat,  2 Jan 2021 17:12:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726644AbhABQLq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 2 Jan 2021 11:11:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726648AbhABQLo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 2 Jan 2021 11:11:44 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FDB3C0613CF
        for <io-uring@vger.kernel.org>; Sat,  2 Jan 2021 08:11:04 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id w5so26638023wrm.11
        for <io-uring@vger.kernel.org>; Sat, 02 Jan 2021 08:11:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=RQ+K3utyDChh+AJqoGDRwTXfrGipm/DzTjxpX0rgRAM=;
        b=sZKb6RA6UKGTdpp2sKDvjsPSuJLRouY3dmtX6gDekLDDnJncmN+EA8C460eaF9ibAM
         Kf1vF7aDGwdDfxbBFzXkTu7aNqkAggl9z0ntDO0E4LjkZ5CGy+Hrv2YQZSXuHjexudqA
         ddxpU8YQ9r7lRCtTMSKjvi6c+O39lTGnlte70AYkRUBqwpu4/XCqwDowGg1lbPjAwIDJ
         xsoJiVbW/miTYdomhEaoAHHkxRUtJ+Ilf0yjQOvx2nCMKusIwGxQj/Q3dMNk6a/gayWg
         rGvyEbRSPYKMG1noC/JgcIipmc/59sIk4xNTUOTuQ2rzVIKPtWfmny64AoGAKgCdzdR6
         0OBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RQ+K3utyDChh+AJqoGDRwTXfrGipm/DzTjxpX0rgRAM=;
        b=f/QdzL09Es26K4UtOw7dPmAKxrleIM85xtSM/PqvcxzP4bURTsb+qM5P/k+SaMiCsl
         DDWfx/m3Ul3RWg6NIwbhogngpaEtTevIAvfgq3SuZxYUCyL6Hv8oebcang+R8zEBv54Y
         0TvPGp48SqS9+NKSSzWUwhUV5LMJ+FZDERtN3xaJmzZMRy7svmX1edV2Zb1U17iBgutE
         /kg1RZVDKLpHkEZ3yXlQckpgUW/2S+5XBzqS6dq/FxYf3gbSBzaRuhHg40pZP4XxqYTL
         vmzoNAMm3rlPaFXmL25MF2/8XuvB45rtQ5CMw3IXSnPV97vvSFULrcOWPDT9D9D3s6wz
         152w==
X-Gm-Message-State: AOAM532jGgkmBvjbvfS5fFzjBRrlxMZ5fak7aU8zg1kWqyfBmJJ3dIE/
        916j0PfggEwDn1wrHtmIOSG2ddwl07g=
X-Google-Smtp-Source: ABdhPJx4eGaqAA3wKLGSW+Ow6jsOTM+Kz391TflanDhW6GumuWhcbClFA58FQ4TDby7D4aS/78AIQg==
X-Received: by 2002:a5d:5044:: with SMTP id h4mr73750214wrt.149.1609603863087;
        Sat, 02 Jan 2021 08:11:03 -0800 (PST)
Received: from localhost.localdomain ([85.255.236.0])
        by smtp.gmail.com with ESMTPSA id b83sm25222377wmd.48.2021.01.02.08.11.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Jan 2021 08:11:02 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 2/4] io_uring: patch up IOPOLL overflow_flush sync
Date:   Sat,  2 Jan 2021 16:06:52 +0000
Message-Id: <716bb8006495b33f11cb2f252ed5506d86f9f85c.1609600704.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1609600704.git.asml.silence@gmail.com>
References: <cover.1609600704.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

IOPOLL skips completion locking but keeps it under uring_lock, thus
io_cqring_overflow_flush() and so io_cqring_events() need extra care.
Add extra conditional locking around them.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 00dd85acd039..a4deef746bc3 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2312,7 +2312,8 @@ static void io_double_put_req(struct io_kiocb *req)
 		io_free_req(req);
 }
 
-static unsigned io_cqring_events(struct io_ring_ctx *ctx, bool noflush)
+static unsigned io_cqring_events(struct io_ring_ctx *ctx, bool noflush,
+				 bool iopoll_lock)
 {
 	if (test_bit(0, &ctx->cq_check_overflow)) {
 		/*
@@ -2323,7 +2324,15 @@ static unsigned io_cqring_events(struct io_ring_ctx *ctx, bool noflush)
 		if (noflush)
 			return -1U;
 
+		/*
+		 * iopoll doesn't care about ctx->completion_lock but uses
+		 * ctx->uring_lock
+		 */
+		if (iopoll_lock)
+			mutex_lock(&ctx->uring_lock);
 		io_cqring_overflow_flush(ctx, false, NULL, NULL);
+		if (iopoll_lock)
+			mutex_unlock(&ctx->uring_lock);
 	}
 
 	/* See comment at the top of this file */
@@ -2550,7 +2559,7 @@ static int io_iopoll_check(struct io_ring_ctx *ctx, long min)
 		 * If we do, we can potentially be spinning for commands that
 		 * already triggered a CQE (eg in error).
 		 */
-		if (io_cqring_events(ctx, false))
+		if (io_cqring_events(ctx, false, false))
 			break;
 
 		/*
@@ -7097,7 +7106,7 @@ static inline bool io_should_wake(struct io_wait_queue *iowq, bool noflush)
 	 * started waiting. For timeouts, we always want to return to userspace,
 	 * regardless of event count.
 	 */
-	return io_cqring_events(ctx, noflush) >= iowq->to_wait ||
+	return io_cqring_events(ctx, noflush, false) >= iowq->to_wait ||
 			atomic_read(&ctx->cq_timeouts) != iowq->nr_timeouts;
 }
 
@@ -7142,13 +7151,14 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 		.ctx		= ctx,
 		.to_wait	= min_events,
 	};
+	bool iopoll = ctx->flags & IORING_SETUP_IOPOLL;
 	struct io_rings *rings = ctx->rings;
 	struct timespec64 ts;
 	signed long timeout = 0;
 	int ret = 0;
 
 	do {
-		if (io_cqring_events(ctx, false) >= min_events)
+		if (io_cqring_events(ctx, false, iopoll) >= min_events)
 			return 0;
 		if (!io_run_task_work())
 			break;
@@ -7184,7 +7194,8 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 			continue;
 		else if (ret < 0)
 			break;
-		if (io_should_wake(&iowq, false))
+		/* iopoll ignores completion_lock, so not safe to flush */
+		if (io_should_wake(&iowq, iopoll))
 			break;
 		if (uts) {
 			timeout = schedule_timeout(timeout);
@@ -8623,7 +8634,7 @@ static __poll_t io_uring_poll(struct file *file, poll_table *wait)
 	smp_rmb();
 	if (!io_sqring_full(ctx))
 		mask |= EPOLLOUT | EPOLLWRNORM;
-	if (io_cqring_events(ctx, false))
+	if (io_cqring_events(ctx, false, ctx->flags & IORING_SETUP_IOPOLL))
 		mask |= EPOLLIN | EPOLLRDNORM;
 
 	return mask;
-- 
2.24.0

