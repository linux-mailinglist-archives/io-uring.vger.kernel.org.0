Return-Path: <io-uring+bounces-2801-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 789519551F8
	for <lists+io-uring@lfdr.de>; Fri, 16 Aug 2024 22:44:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C848EB22E05
	for <lists+io-uring@lfdr.de>; Fri, 16 Aug 2024 20:44:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACB911C4633;
	Fri, 16 Aug 2024 20:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="poka1ozR"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 211AE1C37A3
	for <io-uring@vger.kernel.org>; Fri, 16 Aug 2024 20:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723841055; cv=none; b=brkW5znJIrDxqGoKnDbX3e0r0wgImnqq4BwkYY0OxLdmY95sv+MvqgcZyHi9q+VgotlzUYx/8XE1BmEaVvYI26T0hOzR6A78/W9845Pm0TZiS2EmTIN8/69O6ZXcY7Ho6id1rGlFDOvcRBNqJ7eVoZ4Y6hI3ilw11rs4PeF2Zww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723841055; c=relaxed/simple;
	bh=Mhjw+LATf5RTFscSjrkKSb0R0zTDbui+lWsTaUGjr+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IIAPdlEWPQpzczNC5UCOKlNx3Dk18BX62gv9rx0hglwSlr8e5OoEN9cqJrj2IxjFXY2X1v5DMjv//dzjAzqGHrCtH1etYS53qwk42wmoq+ow0WkIX1XyiGG3xM/XWkPgoH2v4k/pRncgD0HbNIUIp5Xd96MP017UMZwojyhg1H4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=poka1ozR; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-70d2ff38af8so84376b3a.2
        for <io-uring@vger.kernel.org>; Fri, 16 Aug 2024 13:44:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1723841052; x=1724445852; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0CJ86QEHd2DNYgw+x5NJRs+gaRaLpF5c0ct13bOsR/o=;
        b=poka1ozR5OvNXL5AvphUqsC495vMpDN4IORogAivEqMobYC8JyqjhU8nNJPmCMjUUg
         QabYMO5YHDGr9AZ5DEFGRfbWU+rhZQtkmzbQUBPJkbUrWKnPkUZI8YYm0t9ObCzfd+Vr
         UW4LMN1I6tkuExlWRCPpSfp79cEQBQH5QsWCHhHJO/+Vm7+gG9UUYhlY+bupzQnt09cH
         BqRqv1eL7J/4OR1WG4fv49ddj/sGcED9vIZ500ebD4YAtxLjWNU9BOyIfrXJVjPjljxG
         IPaqU886/sAL7BoIHSxLp5ZHFiBnw9sJTsvPxR4yuALTXbXOOtsRlnm5mgei8mfuL7pX
         yPkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723841052; x=1724445852;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0CJ86QEHd2DNYgw+x5NJRs+gaRaLpF5c0ct13bOsR/o=;
        b=O8DzXZJgzM5fCJ6XpNTMOC8Gxduytkv30328+csLWIe+LVUsFS/ILVZs4N46ZetAES
         FNxOlJThuxpKD5weHvftO21ky0k/F+rvuZUs40KIRuojCcVHykAiA1g4WRDa1AbMLAz3
         w0khCxk+B942jY+dNAHiEG5tEBEKDvBBWAS+ODv9OwEjJKKlj+cjmmZN9GaSxDvXc2ym
         vBCjV03VgBsqLOn1WKw1EpLO2SJqlGY+LtD+gPf67iluYnSvYDhOqw7PQUb2t31WjAPI
         C/AFJrbufkkj0nb695jNpLyw+qfGH40b4coWikVmo/Z7xXsC5CfJFMidZuaL1NW0UX30
         9k1g==
X-Gm-Message-State: AOJu0YxiWjlbS5NwUgzye55+niMjLMcUO/AKPykPxU5CiRaABvFUEjFd
	doMday1NYrvRvjzQriV7r7/HaaC0nV3HUqNfUSG3cXLbZj5SsPawLCK/bJpWmq0+E+5RB0PqCJW
	t
X-Google-Smtp-Source: AGHT+IGdUy9MS4OB+3NqOsdGSEbDBaZflF2EmnnQxDlFEHDWKKBpm0/U8Nlh76GejI8nDCOdjZuUXg==
X-Received: by 2002:a17:902:da87:b0:1fc:52f4:1802 with SMTP id d9443c01a7336-202040aa821mr28225745ad.10.1723841052002;
        Fri, 16 Aug 2024 13:44:12 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-201f038a3d7sm29190995ad.186.2024.08.16.13.44.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Aug 2024 13:44:10 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/5] io_uring: move schedule wait logic into helper
Date: Fri, 16 Aug 2024 14:38:13 -0600
Message-ID: <20240816204302.85938-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240816204302.85938-2-axboe@kernel.dk>
References: <20240816204302.85938-2-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In preparation for expanding how we handle waits, move the actual
schedule and schedule_timeout() handling into a helper.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 37 +++++++++++++++++++++----------------
 1 file changed, 21 insertions(+), 16 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index f90a4490908b..2bdb66902f58 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2350,22 +2350,10 @@ static bool current_pending_io(void)
 	return percpu_counter_read_positive(&tctx->inflight);
 }
 
-/* when returns >0, the caller should retry */
-static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
-					  struct io_wait_queue *iowq)
+static int __io_cqring_wait_schedule(struct io_ring_ctx *ctx,
+				     struct io_wait_queue *iowq)
 {
-	int ret;
-
-	if (unlikely(READ_ONCE(ctx->check_cq)))
-		return 1;
-	if (unlikely(!llist_empty(&ctx->work_llist)))
-		return 1;
-	if (unlikely(test_thread_flag(TIF_NOTIFY_SIGNAL)))
-		return 1;
-	if (unlikely(task_sigpending(current)))
-		return -EINTR;
-	if (unlikely(io_should_wake(iowq)))
-		return 0;
+	int ret = 0;
 
 	/*
 	 * Mark us as being in io_wait if we have pending requests, so cpufreq
@@ -2374,7 +2362,6 @@ static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
 	 */
 	if (!iowq->no_iowait && current_pending_io())
 		current->in_iowait = 1;
-	ret = 0;
 	if (iowq->timeout == KTIME_MAX)
 		schedule();
 	else if (!schedule_hrtimeout_range_clock(&iowq->timeout, 0,
@@ -2384,6 +2371,24 @@ static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
 	return ret;
 }
 
+/* If this returns > 0, the caller should retry */
+static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
+					  struct io_wait_queue *iowq)
+{
+	if (unlikely(READ_ONCE(ctx->check_cq)))
+		return 1;
+	if (unlikely(!llist_empty(&ctx->work_llist)))
+		return 1;
+	if (unlikely(test_thread_flag(TIF_NOTIFY_SIGNAL)))
+		return 1;
+	if (unlikely(task_sigpending(current)))
+		return -EINTR;
+	if (unlikely(io_should_wake(iowq)))
+		return 0;
+
+	return __io_cqring_wait_schedule(ctx, iowq);
+}
+
 struct ext_arg {
 	size_t argsz;
 	struct __kernel_timespec __user *ts;
-- 
2.43.0


