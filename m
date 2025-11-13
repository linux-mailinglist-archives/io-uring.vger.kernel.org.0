Return-Path: <io-uring+bounces-10594-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A0EAC574FE
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 13:01:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A08853B7835
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 12:00:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3C3F34EF0A;
	Thu, 13 Nov 2025 12:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QS16h5oz"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D00BA34A790
	for <io-uring@vger.kernel.org>; Thu, 13 Nov 2025 12:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763035210; cv=none; b=QYTTXuTqho3nxb+SQcfpyAht6pj+nDqGIze7BgmSy6MWHcbjj1Ujh/cU5sWAkgShVfpxDCkXh06WEIIQ6Tq6BSSkScjE8/3TfV7RMF4I20+IxRIkSlSEE7lQGe0xt8d5VPlGCoDov7MZMcaQCpC+unKYqZOMea/oA4wujKdpbzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763035210; c=relaxed/simple;
	bh=LClQ4VKSgGqRmpKA8muL2DWk6OhWvtI5zTQeCjFWmQI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B51ZIREKIzzZFB+vI1/dmFYYlDvvzEfeuBxVGT8QqY5fed9fagD/mBfpwaG2chOMUZFBZKVW7skhcdr2hgogBYGIV4Zvp/axqfhwc64pitCL7Moacn3+5+owu11Ndj6BmNwWs+djqpdoMtvsQDjPg2hADO3w9Ny3hXAMWYtC0Jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QS16h5oz; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-42b2e9ac45aso495827f8f.0
        for <io-uring@vger.kernel.org>; Thu, 13 Nov 2025 04:00:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763035204; x=1763640004; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h3KZQy0f9Z9laK13Rj/5BsEUG3RefPiUTImKCIeRBME=;
        b=QS16h5ozTuCt0h2/yQ7uuKDCc1Gb4op3O1viobgHjfdFl7c1JKdNCb2IH2OMYtxIV6
         yfhj1CwOXhgHiA1gTzaU2OEIDp80bdj7/3eg1cWmQ6PBem3SZjxXcoK3civNDqUrfMLH
         oQsXsvzHn19CFug/VwGdFJSZHyIbM1LEva4AHNu3rQAG3or8XLrOezCO4w/fHv5OjY+w
         cVGT3G2u3sOdw0njQsjTX+YJXF8kCEi/09c3EwzjzxaPvVhFtlDTR8nPaE5NT6Ua4bcN
         oh/XqE7QYjhd2eDu0gn4YmtlTBOCB9euy8z1xyTwsi0Hpsag2zrp5FLmO+QM41683YmW
         rpKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763035204; x=1763640004;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=h3KZQy0f9Z9laK13Rj/5BsEUG3RefPiUTImKCIeRBME=;
        b=IZvvXtibrlGCe2kO/9LfdAymCKBx05n+lPvfx/yKTMyCFDys8+k3QZ1L1aO0MtP5Zp
         n80ipRzrSl8AZs+7jIqwjJcQd6XEHd5WmnFMXx00QOu9z6W8SQyGjJzrwb1mrV8NLu7O
         ol3RRra29yUEgtCZL8Sd2veA2NjYCPASB8FdJ6yWF+37zLxQ6UAFhw7Ypkab5aCw/b95
         CbzGI6/ds3ZERPlzYSbqLTJ29vjbIxU4tCLP+3IdJpa9TVsGoJThujL+HRc/DB2yCk6q
         ZqJ3EjfPsYOJzW9qDN6nslpzGH9tu889j6q+29cbAmTyM663S0kyN5FKmStjtVOsY3Ls
         O+DA==
X-Gm-Message-State: AOJu0YzZpMbAsd2rwwMEYmXcinOjk9yQmTEHfS2raX4/fsL8eJFOl4h0
	nRxYveF5VuH1CRralxJytowJ7rcjBvlJqBwUaSHe/JBWQl5uvQp/+7KvhiBQNg==
X-Gm-Gg: ASbGncs9SBv4ajJsX38wuWkHw/mSFCCFDvZogiMGuUgRFJ0pOxTiZZ2k4IAu4xAwgkE
	399SOFYDCb19CQHlH2KB3/3D24jjIv/7tMmiaPPWo8iD2uBd6IpkXhUStH0FPcb1KMxtiznkwur
	5lJyx8GCTF6RAD/tO9B1L0N4iodlmMvnSYAfyJlOKHmBA7mTSOe77XsgtSLEjfSMCks03Ove0Yd
	KjoIY1WCJ0bIniVfN5OQvB+rb03eOMOsjfm8AMMrvA4a3PgtEjl+iJUWetCHz/2t8aZGTYCenLm
	OSWmUwtwpV0Gog5z1Rgibq+guj7k47xE/FfFhcFCahalOUgDsj9ANGxNfozJWVBm6efEQtsY6V+
	6FiuSuNiKlWcFMcB+1TAq2qGzoljeKy4At8YOtojNg1CPruhFyJ/J50LEEfHdtf8Gh29ggQ==
X-Google-Smtp-Source: AGHT+IFbeftWCviGXNIemZTF2DmXPVZfg2TdG3b62DkOa2qU3mmvsfwD7ETwzpKo0Zpbud+N7iiXQw==
X-Received: by 2002:a5d:5d12:0:b0:42b:3083:5588 with SMTP id ffacd0b85a97d-42b4bdb0570mr6602052f8f.39.1763035204238;
        Thu, 13 Nov 2025 04:00:04 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:6794])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42b53e85e6fsm3686816f8f.18.2025.11.13.04.00.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Nov 2025 04:00:03 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk,
	Martin KaFai Lau <martin.lau@linux.dev>,
	bpf@vger.kernel.org,
	Alexei Starovoitov <alexei.starovoitov@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	ming.lei@redhat.com
Subject: [PATCH v3 04/10] io_uring: extract waiting parameters into a struct
Date: Thu, 13 Nov 2025 11:59:41 +0000
Message-ID: <5343b1306ad898181477470e0ce467bcca329262.1763031077.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1763031077.git.asml.silence@gmail.com>
References: <cover.1763031077.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a structure that keeps arguments needed for the current round of
waiting. Namely, the number of CQEs to wait for in a form of CQ tail
index and timeout.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 22 ++++++++++++----------
 io_uring/io_uring.h | 14 +++++++++++---
 io_uring/napi.c     |  4 ++--
 3 files changed, 25 insertions(+), 15 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 4139cfc84221..29f34fbcbb01 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2508,8 +2508,8 @@ static enum hrtimer_restart io_cqring_min_timer_wakeup(struct hrtimer *timer)
 	struct io_ring_ctx *ctx = iowq->ctx;
 
 	/* no general timeout, or shorter (or equal), we are done */
-	if (iowq->timeout == KTIME_MAX ||
-	    ktime_compare(iowq->min_timeout, iowq->timeout) >= 0)
+	if (iowq->ls.timeout == KTIME_MAX ||
+	    ktime_compare(iowq->min_timeout, iowq->ls.timeout) >= 0)
 		goto out_wake;
 	/* work we may need to run, wake function will see if we need to wake */
 	if (io_has_work(ctx))
@@ -2535,7 +2535,7 @@ static enum hrtimer_restart io_cqring_min_timer_wakeup(struct hrtimer *timer)
 	}
 
 	hrtimer_update_function(&iowq->t, io_cqring_timer_wakeup);
-	hrtimer_set_expires(timer, iowq->timeout);
+	hrtimer_set_expires(timer, iowq->ls.timeout);
 	return HRTIMER_RESTART;
 out_wake:
 	return io_cqring_timer_wakeup(timer);
@@ -2551,7 +2551,7 @@ static int io_cqring_schedule_timeout(struct io_wait_queue *iowq,
 		hrtimer_setup_on_stack(&iowq->t, io_cqring_min_timer_wakeup, clock_id,
 				       HRTIMER_MODE_ABS);
 	} else {
-		timeout = iowq->timeout;
+		timeout = iowq->ls.timeout;
 		hrtimer_setup_on_stack(&iowq->t, io_cqring_timer_wakeup, clock_id,
 				       HRTIMER_MODE_ABS);
 	}
@@ -2592,7 +2592,7 @@ static int __io_cqring_wait_schedule(struct io_ring_ctx *ctx,
 	 */
 	if (ext_arg->iowait && current_pending_io())
 		current->in_iowait = 1;
-	if (iowq->timeout != KTIME_MAX || iowq->min_timeout)
+	if (iowq->ls.timeout != KTIME_MAX || iowq->min_timeout)
 		ret = io_cqring_schedule_timeout(iowq, ctx->clockid, start_time);
 	else
 		schedule();
@@ -2650,18 +2650,20 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events, u32 flags,
 	iowq.wqe.private = current;
 	INIT_LIST_HEAD(&iowq.wqe.entry);
 	iowq.ctx = ctx;
-	iowq.cq_tail = READ_ONCE(ctx->rings->cq.head) + min_events;
+	iowq.ls.cq_tail = READ_ONCE(ctx->rings->cq.head) + min_events;
 	iowq.cq_min_tail = READ_ONCE(ctx->rings->cq.tail);
 	iowq.nr_timeouts = atomic_read(&ctx->cq_timeouts);
 	iowq.hit_timeout = 0;
 	iowq.min_timeout = ext_arg->min_time;
-	iowq.timeout = KTIME_MAX;
+	iowq.ls.timeout = KTIME_MAX;
 	start_time = io_get_time(ctx);
 
 	if (ext_arg->ts_set) {
-		iowq.timeout = timespec64_to_ktime(ext_arg->ts);
+		ktime_t timeout = timespec64_to_ktime(ext_arg->ts);
+
 		if (!(flags & IORING_ENTER_ABS_TIMER))
-			iowq.timeout = ktime_add(iowq.timeout, start_time);
+			timeout = ktime_add(timeout, start_time);
+		iowq.ls.timeout = timeout;
 	}
 
 	if (ext_arg->sig) {
@@ -2686,7 +2688,7 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events, u32 flags,
 
 		/* if min timeout has been hit, don't reset wait count */
 		if (!iowq.hit_timeout)
-			nr_wait = (int) iowq.cq_tail -
+			nr_wait = (int) iowq.ls.cq_tail -
 					READ_ONCE(ctx->rings->cq.tail);
 		else
 			nr_wait = 1;
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index a4474eec8a13..caff186bc377 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -101,15 +101,23 @@ struct io_defer_entry {
 	struct io_kiocb		*req;
 };
 
+struct iou_loop_state {
+	/*
+	 * The CQE index to wait for. Only serves as a hint and can still be
+	 * woken up earlier.
+	 */
+	__u32		cq_tail;
+	ktime_t		timeout;
+};
+
 struct io_wait_queue {
+	struct iou_loop_state ls;
 	struct wait_queue_entry wqe;
 	struct io_ring_ctx *ctx;
-	unsigned cq_tail;
 	unsigned cq_min_tail;
 	unsigned nr_timeouts;
 	int hit_timeout;
 	ktime_t min_timeout;
-	ktime_t timeout;
 	struct hrtimer t;
 
 #ifdef CONFIG_NET_RX_BUSY_POLL
@@ -121,7 +129,7 @@ struct io_wait_queue {
 static inline bool io_should_wake(struct io_wait_queue *iowq)
 {
 	struct io_ring_ctx *ctx = iowq->ctx;
-	int dist = READ_ONCE(ctx->rings->cq.tail) - (int) iowq->cq_tail;
+	int dist = READ_ONCE(ctx->rings->cq.tail) - (int) iowq->ls.cq_tail;
 
 	/*
 	 * Wake up if we have enough events, or if a timeout occurred since we
diff --git a/io_uring/napi.c b/io_uring/napi.c
index 4a10de03e426..b804f8fdd883 100644
--- a/io_uring/napi.c
+++ b/io_uring/napi.c
@@ -360,8 +360,8 @@ void __io_napi_busy_loop(struct io_ring_ctx *ctx, struct io_wait_queue *iowq)
 		return;
 
 	iowq->napi_busy_poll_dt = READ_ONCE(ctx->napi_busy_poll_dt);
-	if (iowq->timeout != KTIME_MAX) {
-		ktime_t dt = ktime_sub(iowq->timeout, io_get_time(ctx));
+	if (iowq->ls.timeout != KTIME_MAX) {
+		ktime_t dt = ktime_sub(iowq->ls.timeout, io_get_time(ctx));
 
 		iowq->napi_busy_poll_dt = min_t(u64, iowq->napi_busy_poll_dt, dt);
 	}
-- 
2.49.0


