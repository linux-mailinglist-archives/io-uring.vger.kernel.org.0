Return-Path: <io-uring+bounces-608-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B91585693E
	for <lists+io-uring@lfdr.de>; Thu, 15 Feb 2024 17:15:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 48F85286987
	for <lists+io-uring@lfdr.de>; Thu, 15 Feb 2024 16:15:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 989E713A249;
	Thu, 15 Feb 2024 16:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="DwbEp+JO"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC7A984FC2
	for <io-uring@vger.kernel.org>; Thu, 15 Feb 2024 16:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708013411; cv=none; b=srK4sqBV8gYKnda4RhiQMeuSS4eXlnEVsObC2CdQj4Pf33LdGSs1Pm+dADGE52fCAKOuKPaDBrHVX9JtWri6EBOWeDg42AAWEVdwmdErISnZq3BIptXS3ObMsWKCRAJlLXhR1qq+g7oMOTEaoG4AZKkXvXn2LpJvkVuKJw59Y2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708013411; c=relaxed/simple;
	bh=SPbtbd/VPyQSoyZUrc2YiFvw71pEWWTOy06FiwBC7q8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AgPAMIC/ugVbDbxnhll2VZkkb3MWMBIVix7p8TyyMiZ/GFX8gCB3xhxEYd8FAMTKLITBLxpwHL4dRhZWUMWYtE82RVsfA2ANQNPDnhy1rUwKGSgyjkYjXkazt3+EhiG+iWYMrzoKsJGaWonJ25Zp8nUmiUy899ETtPb+DvF0p+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=DwbEp+JO; arc=none smtp.client-ip=209.85.166.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-363e7d542f4so417675ab.0
        for <io-uring@vger.kernel.org>; Thu, 15 Feb 2024 08:10:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1708013407; x=1708618207; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I4cnl52ova8W38aWfWiW7EBOK/wVRhZpBo5coezzJxs=;
        b=DwbEp+JOMBngwgRB7qvVFIDUlDdrVgP+ER7wTBtmwoQooOvpulcB5+Ato1sTuoJL3F
         tGIkEwFwsw0KyV3+CVPkej/eBnQjcITaT94ovbNucYjsD9FIF+088I37zbXxyw61WmV1
         FkT9bXOVCUtmP9/LPSjqg1Oej9t3XoaFYpx+YVtTiV7X5FjzUkJI0HIEbUQmMn/Fk0hg
         qtjY9BBX/DRXXes75jwxmmCPpztN1KUg1/R0lRREToecNN111QH9XHt18aPma/QeK0cX
         bxiko+XfZLjQxQ1AUf5levCqOk+8cg4yvUyDUXycYAsD6QQbsSKgDd7UgDcN4KsTUxIM
         ysSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708013407; x=1708618207;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I4cnl52ova8W38aWfWiW7EBOK/wVRhZpBo5coezzJxs=;
        b=Xmw/uira9X19Hqt6mFqxdAao7hvC2OblX43Vd4NYXRdOt+kSu9MKjEWM2w6Q1fZABh
         FpM9j/AeafHgL2Z5Sxugor5dIjdDoghQbGxkckY29DHKUOh/vQ1F3/m5/Y8aYM2M77kg
         6ziPFc35+iH2/BW+Go44aPO91pDSZ1qEN1WVTGuWrzJTw6qke2OrSWNbYOG57xt7gmPv
         OrlgMTEj/03KGpDyv6+ygWrows3A78S8c8MGwi+XO/Y2zhKfWKNhh0cH+nXgbFRTkfSD
         zizZcKriQ4EEfmLY05MlEaxt85mJu8sLAfhXD+xuQh5sSFhXJQMv463y7sVl8LCbjAFL
         NnzQ==
X-Gm-Message-State: AOJu0Yz1qIFHgE2YkNFYUkN26t6l4AR18Yc5lbSDDYUwyoZbC4TnhLzr
	FJJ8q7J2k1MGCnF2UKcwpKmGfXBWcnY/rNWnT7oubk3VXsWe75Mi01aXPe001SoWbI/MNMZpzqC
	2
X-Google-Smtp-Source: AGHT+IGTONfYW91A5x0netz5WqT0dw0qb1cMfHofxh3YJD0GIHTVvwSfxmnSsFXemk2kDDE0as1TXg==
X-Received: by 2002:a92:c26c:0:b0:363:c7c6:4f5f with SMTP id h12-20020a92c26c000000b00363c7c64f5fmr2115741ild.1.1708013407468;
        Thu, 15 Feb 2024 08:10:07 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id x4-20020a056e02074400b0036275404ab3sm458524ils.85.2024.02.15.08.10.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Feb 2024 08:10:06 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/4] io_uring: implement our own schedule timeout handling
Date: Thu, 15 Feb 2024 09:06:57 -0700
Message-ID: <20240215161002.3044270-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240215161002.3044270-1-axboe@kernel.dk>
References: <20240215161002.3044270-1-axboe@kernel.dk>
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
 io_uring/io_uring.c | 39 +++++++++++++++++++++++++++++++++++----
 io_uring/io_uring.h |  2 ++
 2 files changed, 37 insertions(+), 4 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 8f52acc14ebc..ebc646ad6acf 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2488,7 +2488,7 @@ static int io_wake_function(struct wait_queue_entry *curr, unsigned int mode,
 	 * Cannot safely flush overflowed CQEs from here, ensure we wake up
 	 * the task, and the next invocation will do it.
 	 */
-	if (io_should_wake(iowq) || io_has_work(iowq->ctx))
+	if (io_should_wake(iowq) || io_has_work(iowq->ctx) || iowq->hit_timeout)
 		return autoremove_wake_function(curr, mode, wake_flags, key);
 	return -1;
 }
@@ -2516,6 +2516,37 @@ static bool current_pending_io(void)
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
+static int io_cqring_schedule_timeout(struct io_wait_queue *iowq)
+{
+	iowq->hit_timeout = 0;
+	hrtimer_init_on_stack(&iowq->t, CLOCK_MONOTONIC, HRTIMER_MODE_ABS);
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
@@ -2529,10 +2560,10 @@ static int __io_cqring_wait_schedule(struct io_ring_ctx *ctx,
 	io_wait = current->in_iowait;
 	if (current_pending_io())
 		current->in_iowait = 1;
-	if (iowq->timeout == KTIME_MAX)
+	if (iowq->timeout != KTIME_MAX)
+		ret = io_cqring_schedule_timeout(iowq);
+	else
 		schedule();
-	else if (!schedule_hrtimeout(&iowq->timeout, HRTIMER_MODE_ABS))
-		ret = -ETIME;
 	current->in_iowait = io_wait;
 	return ret;
 }
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 6426ee382276..9d1045bdc505 100644
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
 	unsigned int napi_busy_poll_to;
-- 
2.43.0


