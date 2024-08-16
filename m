Return-Path: <io-uring+bounces-2802-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BA6E9551F5
	for <lists+io-uring@lfdr.de>; Fri, 16 Aug 2024 22:44:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D61A428673E
	for <lists+io-uring@lfdr.de>; Fri, 16 Aug 2024 20:44:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23EF81C463B;
	Fri, 16 Aug 2024 20:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="RGXdsat+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B60CB1C230D
	for <io-uring@vger.kernel.org>; Fri, 16 Aug 2024 20:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723841057; cv=none; b=uKLNgb8bYY5N071nToIJcifKnMBOF36oSnmYEEn+SCzODv9pcD32TJStgULmRVEjBlYeDkpNyh4t/uoV+cyMrKqO6CmHWESJE/tIMcJPIgSpCCPHmOGSq8w/GtJtqySXWicNyeMgy/T53I7Efhyigq2SLx1JLxJ0LBbbwq/9wNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723841057; c=relaxed/simple;
	bh=cZ4e0WcuWQx6VX1fthW7bnYW4j+Jn2MgorC9W4EbmYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ctBc5fdBTKTDkGYaS19p8leWr6eoHeh0N4CHlFmmeIwDscTFwCmKTzkIVRN0q0+Lz4Ac2BaPWW0bAOT0JiepHhDxoKbVtzZIW3Uk4Lfn6WW6zdMawSuifnmKLrXv+aXI6sm1rIvs4b43BUlb4o8fUIM1rcYnVc33QpwwTzoGvOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=RGXdsat+; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-201e2ebed48so1224405ad.0
        for <io-uring@vger.kernel.org>; Fri, 16 Aug 2024 13:44:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1723841053; x=1724445853; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pjuwZgy1No/wv7dcl9qPfV/1hVKvPzAmNfbDR9sXvXQ=;
        b=RGXdsat+3RWe3Cm9K3Vh4J8U/lEoK+MQyv9Af1+1pAjm1/Nti+JJN7r9GooSG8i/l4
         06BQjmu2LYqKdy3OiqQ4nporcyAV9QRPUd469WddVebZYBADNyxgnh+dbuRRzeAhpBen
         XCxEE+94L9eUa3WFENWtefOdlg7sweXHLQWnXz6wumB68dg3gXujjOQFTmIEMX7rqDHf
         QZlDLUXcWERD5ERbqtpqtTlS0p0uxTvt2bBb6WQxehYpzFwViO4T9zZ2eD0R0b5dlYzB
         r5mGyExGdsbQCSMaZYVkhNxZQMU/X79t0Bdw+HGplsGy4CIcEzMQVpvs8QndWTCIh6jx
         RB4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723841053; x=1724445853;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pjuwZgy1No/wv7dcl9qPfV/1hVKvPzAmNfbDR9sXvXQ=;
        b=E/haYYGzbzzy52XFb0CtWZMwWegeQ5jk2P1mtgTpMbdwJRTl7V7aYqxZw2syWoHCHZ
         OQn8Bnjn929E570OmJErl6VvNYpHIL3A9Uo6gLQbXlDfG47THgg6rtvQm7FAY3u3XhmZ
         GCIj1LQRSNjfiOiRhL5KM1gziaKhSeRF/aPUDj66BUqoLaX8LEchg2RflbexPgcYoh40
         BeXrv1yiDH9o10UzTllMmKn/km9QOlypj/u42tKnxlOa3yguqJQfc4aIuMiEveHOiNiR
         BF1+BGiP1LE6OXhk42T4gwy/hCtazVZNUhfUMNPITA0M/cDmJyT7rX7jMegxYDHIhGNx
         ekKA==
X-Gm-Message-State: AOJu0YxhvzgPnQ4fdCfK9lwULsymGfnRHWMyT4SBQrtXHt9nZjTiQCI5
	MgCdxWIFsLyfp9jaq7ocnxgt4t5FMLIwrLviwOgxVCR3Ar2up0/rsercEjz6j+3uIrLo9KhrUFt
	w
X-Google-Smtp-Source: AGHT+IE9NKTrpddX6QhPT16aLMnBTd4dHuYegdJP5oy4pjanQAlid2wjyjl665TJSjvAuw0B9oCyzQ==
X-Received: by 2002:a17:902:d289:b0:202:13d7:9290 with SMTP id d9443c01a7336-20213d79b21mr12773235ad.8.1723841053448;
        Fri, 16 Aug 2024 13:44:13 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-201f038a3d7sm29190995ad.186.2024.08.16.13.44.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Aug 2024 13:44:12 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/5] io_uring: implement our own schedule timeout handling
Date: Fri, 16 Aug 2024 14:38:14 -0600
Message-ID: <20240816204302.85938-5-axboe@kernel.dk>
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

In preparation for having two distinct timeouts and avoid waking the
task if we don't need to.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 41 ++++++++++++++++++++++++++++++++++++-----
 io_uring/io_uring.h |  2 ++
 2 files changed, 38 insertions(+), 5 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 2bdb66902f58..6e53ebd58aab 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2322,7 +2322,7 @@ static int io_wake_function(struct wait_queue_entry *curr, unsigned int mode,
 	 * Cannot safely flush overflowed CQEs from here, ensure we wake up
 	 * the task, and the next invocation will do it.
 	 */
-	if (io_should_wake(iowq) || io_has_work(iowq->ctx))
+	if (io_should_wake(iowq) || io_has_work(iowq->ctx) || iowq->hit_timeout)
 		return autoremove_wake_function(curr, mode, wake_flags, key);
 	return -1;
 }
@@ -2350,6 +2350,38 @@ static bool current_pending_io(void)
 	return percpu_counter_read_positive(&tctx->inflight);
 }
 
+static enum hrtimer_restart io_cqring_timer_wakeup(struct hrtimer *timer)
+{
+	struct io_wait_queue *iowq = container_of(timer, struct io_wait_queue, t);
+	struct io_ring_ctx *ctx = iowq->ctx;
+
+	WRITE_ONCE(iowq->hit_timeout, 1);
+	if (ctx->flags & IORING_SETUP_DEFER_TASKRUN)
+		wake_up_process(ctx->submitter_task);
+	else
+		io_cqring_wake(ctx);
+	return HRTIMER_NORESTART;
+}
+
+static int io_cqring_schedule_timeout(struct io_wait_queue *iowq,
+				      clockid_t clock_id)
+{
+	iowq->hit_timeout = 0;
+	hrtimer_init_on_stack(&iowq->t, clock_id, HRTIMER_MODE_ABS);
+	iowq->t.function = io_cqring_timer_wakeup;
+	hrtimer_set_expires_range_ns(&iowq->t, iowq->timeout, 0);
+	hrtimer_start_expires(&iowq->t, HRTIMER_MODE_ABS);
+
+	if (!READ_ONCE(iowq->hit_timeout))
+		schedule();
+
+	hrtimer_cancel(&iowq->t);
+	destroy_hrtimer_on_stack(&iowq->t);
+	__set_current_state(TASK_RUNNING);
+
+	return READ_ONCE(iowq->hit_timeout) ? -ETIME : 0;
+}
+
 static int __io_cqring_wait_schedule(struct io_ring_ctx *ctx,
 				     struct io_wait_queue *iowq)
 {
@@ -2362,11 +2394,10 @@ static int __io_cqring_wait_schedule(struct io_ring_ctx *ctx,
 	 */
 	if (!iowq->no_iowait && current_pending_io())
 		current->in_iowait = 1;
-	if (iowq->timeout == KTIME_MAX)
+	if (iowq->timeout != KTIME_MAX)
+		ret = io_cqring_schedule_timeout(iowq, ctx->clockid);
+	else
 		schedule();
-	else if (!schedule_hrtimeout_range_clock(&iowq->timeout, 0,
-						 HRTIMER_MODE_ABS, ctx->clockid))
-		ret = -ETIME;
 	current->in_iowait = 0;
 	return ret;
 }
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index e0868b79774c..bac830a2d6ec 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -40,7 +40,9 @@ struct io_wait_queue {
 	struct io_ring_ctx *ctx;
 	unsigned cq_tail;
 	unsigned nr_timeouts;
+	int hit_timeout;
 	ktime_t timeout;
+	struct hrtimer t;
 #ifdef CONFIG_NET_RX_BUSY_POLL
 	ktime_t napi_busy_poll_dt;
 	bool napi_prefer_busy_poll;
-- 
2.43.0


