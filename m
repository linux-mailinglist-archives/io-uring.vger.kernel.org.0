Return-Path: <io-uring+bounces-598-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 98DD2853A9B
	for <lists+io-uring@lfdr.de>; Tue, 13 Feb 2024 20:14:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 206871F27F31
	for <lists+io-uring@lfdr.de>; Tue, 13 Feb 2024 19:14:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E77F31CAA3;
	Tue, 13 Feb 2024 19:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="IjPjubec"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f44.google.com (mail-io1-f44.google.com [209.85.166.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C2D85FF03
	for <io-uring@vger.kernel.org>; Tue, 13 Feb 2024 19:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707851641; cv=none; b=ACFva+5xvJ3rBwtJMIzyZ+lFqwhiE1gemaqno+TVhDp49fkNAzdn1HbwxCA4CwZb8i/MzqErWy07K48bB6jJzE3oHFi44M5BRzflTGa6TMWp4UetJIpPXdO8jLgrlR8dqDKSrwwP8EBZpU+Zn1dBAvfACUZajKR+ZMpWW3insHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707851641; c=relaxed/simple;
	bh=hzMJczFPiL49MXlzNIh2W66wvQ32YkE6TzhWCp2rVQk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gNh+sIMU8dQ9R31UfYNhb5G0hBSJf56lDySgzS8MyxIPBr9a+4XLrYAsTQN4hsC9eBxBUeXVVWYwsoygWNEQFlgusXOvczdSAsrc1/rp1MWbjF2JuUXY1j1oCw0s8UichdYfD9QL/HFL9Waer8eJkWbieBwUhDCH+PkBvMwEZXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=IjPjubec; arc=none smtp.client-ip=209.85.166.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f44.google.com with SMTP id ca18e2360f4ac-7bbdd28a52aso89846039f.1
        for <io-uring@vger.kernel.org>; Tue, 13 Feb 2024 11:13:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1707851637; x=1708456437; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hDpZTErlRHw22QWpqYvdD5JTThCnDYRT8sRzc1Z849Y=;
        b=IjPjubecbmx0HEcRVNrVK2T8ftqCtwVOP0yg6MM120kju9mkominnkaLb21D6oTB/X
         AKk/EPgD9YcicHNXZVvfdJtloDGTSphbprkr3KDDyvyFZZDsf0ndLy7m6rGrhb44ewAY
         CHAt7GmD/fVNS0KU+3nxYYD+3JgH34Qy2NCsUXsIGeo1clWs4PZ4lPgMJNkaau/WCWLe
         l16VNXFhWA9BHfK4+VcSKG2KQvMBQJZBJyorsux1LQmq1sO6dAorLi9nxlVNNCKUFQTL
         qRcNN6IAWhVmKvRSSBW/VY4YDSmNx9okOpyBclJF1tD4YXgTbex/sbRrRmhtpE1vVrBF
         t5gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707851637; x=1708456437;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hDpZTErlRHw22QWpqYvdD5JTThCnDYRT8sRzc1Z849Y=;
        b=ejtpu9VPzSry8pPAQY23zJMcvaepo0sEyEEkZtaUAMNs149cRfUUlwjOcxq2g/N8ao
         soU+cBsHedYEaf2BRjALTwB8oA8bu/SznP4mJy/7UE0pS6Fe9zo4lH+IjLy/YEJexOgg
         inQO0PFIdjFEE/TyURlfKjcmDBMNHOd0Guu7zKujCEjix+tMoyma9dynru1hnSF2HrPK
         r/+D10VeIFOEKz44NoCn6dBa6w+aVF2yyIG4OKYwKrRiR0p/6gFjV1hP/s5NCqrISkjX
         BT8C9y6Dy6X6GY6uF4JkHIh0fmqU5shJkHJ8S8yxDiuMzEr0eEpegVL7foOTAzn9ITXT
         koLA==
X-Gm-Message-State: AOJu0YyW/qfASyOS3s8L0hGqvkySv6JgbVVduZX16cx/CNxQ6y+BA1zs
	GrsugE6D3pAnCRei/WsHBuH+0NbyZtX80hIDamBC4XfMRWaY1uRRl4BKFIHYdSkSc8MFgwHJGzi
	3
X-Google-Smtp-Source: AGHT+IE8iXVzapFBgbD/7e3ezbf/m2ZFculC1Fy//teoCzU55B2c2AJZ+MGGuzLDJJKgmfC9PNV+0A==
X-Received: by 2002:a05:6602:52:b0:7c4:79cc:c4b3 with SMTP id z18-20020a056602005200b007c479ccc4b3mr704713ioz.0.1707851636988;
        Tue, 13 Feb 2024 11:13:56 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id cz17-20020a0566384a1100b004713ef05d60sm2032176jab.96.2024.02.13.11.13.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Feb 2024 11:13:55 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/4] io_uring: move schedule wait logic into helper
Date: Tue, 13 Feb 2024 12:03:38 -0700
Message-ID: <20240213191352.2452160-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240213191352.2452160-1-axboe@kernel.dk>
References: <20240213191352.2452160-1-axboe@kernel.dk>
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
index 479f610e314f..67cc7003b5bd 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2523,22 +2523,10 @@ static bool current_pending_io(void)
 	return percpu_counter_read_positive(&tctx->inflight);
 }
 
-/* when returns >0, the caller should retry */
-static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
-					  struct io_wait_queue *iowq)
+static int __io_cqring_wait_schedule(struct io_ring_ctx *ctx,
+				     struct io_wait_queue *iowq)
 {
-	int io_wait, ret;
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
+	int io_wait, ret = 0;
 
 	/*
 	 * Mark us as being in io_wait if we have pending requests, so cpufreq
@@ -2548,7 +2536,6 @@ static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
 	io_wait = current->in_iowait;
 	if (current_pending_io())
 		current->in_iowait = 1;
-	ret = 0;
 	if (iowq->timeout == KTIME_MAX)
 		schedule();
 	else if (!schedule_hrtimeout(&iowq->timeout, HRTIMER_MODE_ABS))
@@ -2557,6 +2544,24 @@ static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
 	return ret;
 }
 
+/* when returns >0, the caller should retry */
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
 /*
  * Wait until events become available, if we don't already have some. The
  * application must reap them itself, as they reside on the shared cq ring.
-- 
2.43.0


