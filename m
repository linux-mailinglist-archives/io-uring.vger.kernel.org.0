Return-Path: <io-uring+bounces-3051-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1865B96D337
	for <lists+io-uring@lfdr.de>; Thu,  5 Sep 2024 11:30:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4C5621C25806
	for <lists+io-uring@lfdr.de>; Thu,  5 Sep 2024 09:30:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4A5C198A30;
	Thu,  5 Sep 2024 09:27:55 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CB98198A25;
	Thu,  5 Sep 2024 09:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725528475; cv=none; b=Gtay8WlFsG9Vln3Lxtl6nVbKuG1iG+aU8RBhQ+GanP59lSRSBBtCybEd/jBB8912qo5FXZTzzLVNyy/7caJDcv7+iPBFeocvwfyTQmFV+T5L8x3dwblw+5cigthq3u+nN7dVjQKKza/wsezLdc84sJBbL+eFdYwPYSzHo5iZ2K4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725528475; c=relaxed/simple;
	bh=HhGLvHqBHzexJqM6r5ytVEg4CW0oOFnrqqKCCerjEA0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YVnj5tappVRgdX/uxzD4Yl+CoZ/LSlViEFI24otws47gMLZnC343pKeD0pB5lD/Lqxzr5HyOTxnapDAvyr5wu2ZptNL/ylr0g/S49vfd99eM8EmXd4o5Yh9vw9IDpJ40n37NnrdlWHQ5BO1aNC1i0R39Y5lxn+vEw4ZnS5eLMpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 410701063;
	Thu,  5 Sep 2024 02:28:20 -0700 (PDT)
Received: from e127648.arm.com (unknown [10.57.75.86])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 6DA053F73F;
	Thu,  5 Sep 2024 02:27:49 -0700 (PDT)
From: Christian Loehle <christian.loehle@arm.com>
To: linux-pm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	rafael@kernel.org,
	peterz@infradead.org
Cc: juri.lelli@redhat.com,
	mingo@redhat.com,
	dietmar.eggemann@arm.com,
	vschneid@redhat.com,
	vincent.guittot@linaro.org,
	Johannes.Thumshirn@wdc.com,
	adrian.hunter@intel.com,
	ulf.hansson@linaro.org,
	bvanassche@acm.org,
	andres@anarazel.de,
	asml.silence@gmail.com,
	linux-block@vger.kernel.org,
	io-uring@vger.kernel.org,
	qyousef@layalina.io,
	dsmythies@telus.net,
	axboe@kernel.dk,
	Christian Loehle <christian.loehle@arm.com>
Subject: [RFC PATCH 8/8] io_uring: Do not set iowait before sleeping
Date: Thu,  5 Sep 2024 10:26:45 +0100
Message-Id: <20240905092645.2885200-9-christian.loehle@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240905092645.2885200-1-christian.loehle@arm.com>
References: <20240905092645.2885200-1-christian.loehle@arm.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Setting in_iowait was introduced in commit
8a796565cec3 ("io_uring: Use io_schedule* in cqring wait")
to tackle a perf regression that was caused by menu taking iowait into
account for synchronous IO and thus not selecting deeper states like in
the io_uring counterpart.
That behaviour is gone, so the workaround can be removed.

Signed-off-by: Christian Loehle <christian.loehle@arm.com>
---
 io_uring/io_uring.c | 17 -----------------
 1 file changed, 17 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 3942db160f18..c819d40bdcf0 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2341,15 +2341,6 @@ int io_run_task_work_sig(struct io_ring_ctx *ctx)
 	return 0;
 }
 
-static bool current_pending_io(void)
-{
-	struct io_uring_task *tctx = current->io_uring;
-
-	if (!tctx)
-		return false;
-	return percpu_counter_read_positive(&tctx->inflight);
-}
-
 /* when returns >0, the caller should retry */
 static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
 					  struct io_wait_queue *iowq)
@@ -2367,19 +2358,11 @@ static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
 	if (unlikely(io_should_wake(iowq)))
 		return 0;
 
-	/*
-	 * Mark us as being in io_wait if we have pending requests, so cpufreq
-	 * can take into account that the task is waiting for IO - turns out
-	 * to be important for low QD IO.
-	 */
-	if (current_pending_io())
-		current->in_iowait = 1;
 	ret = 0;
 	if (iowq->timeout == KTIME_MAX)
 		schedule();
 	else if (!schedule_hrtimeout(&iowq->timeout, HRTIMER_MODE_ABS))
 		ret = -ETIME;
-	current->in_iowait = 0;
 	return ret;
 }
 
-- 
2.34.1


