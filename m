Return-Path: <io-uring+bounces-8248-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 846D1AD039D
	for <lists+io-uring@lfdr.de>; Fri,  6 Jun 2025 15:57:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9FC327A8726
	for <lists+io-uring@lfdr.de>; Fri,  6 Jun 2025 13:55:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EA8128980E;
	Fri,  6 Jun 2025 13:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WMJHFBxe"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E372288CA3;
	Fri,  6 Jun 2025 13:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749218209; cv=none; b=L2+Lie/h0t3xkFrjjtZrbztNc/Pd+8MBj8nnz02meyNPUCStWnVMPplcJGSUkChyzsahwBYVUVyTkaPW/VF+7FW+zDf+b7DzucExIrIL11Ki/TTaJDNgXOF5sma0ymHeWSVk1jPUwpswgKzVjOVTZ3XNTpbYTEhBod2Z3c4H894=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749218209; c=relaxed/simple;
	bh=i3124dRDrSgAJDr+S4wMhaq4i3Iio62CzkpMX/msx8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g9spgI34xHbRYVYA1UVdtZFy/XycV0lI2ok2kPmVDkqoGNIpK+TrnJR1hr+PHPAhVm91IPAmbbQDtdrt8Miap9hGFcjGGscuehheY8Fjf2F0+1C+Yerf+f+rYU6flUO7DHzQAccIH9JX6aUe1+41IQ8x7NrSo+dmY+bVyrodov0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WMJHFBxe; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-ad89333d603so380697066b.2;
        Fri, 06 Jun 2025 06:56:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749218204; x=1749823004; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nWMe+CPV752eWO5pJOHKZI3Zz5P7ROmouZdNiOUAjLg=;
        b=WMJHFBxehjaW++XnXc+MrzQX12bULfmTAZpto2DdIz9Tvi6rV8Y1a+zeYNmL3j35LE
         JIrRgIRZd0bT8DGH1+tQ0XTjfBogKb4ygTEyZcfx0v6ME5nhTn/dV0AaD92dOpFxgP0J
         rSUQN2vQ1UA4KgzlNqyKSpspglkdrWBXA5zgRYDAtSdJG3vldSu0y5C7e9OLLaogWtBt
         WBcB8RsFUHfKya7opXZW1XI+teKobt+FGZm97wlF38iTd7/y47pPwAvi8tQ0JDYGpkjA
         eaqO+lDqdz2X36toXTe2b1BJ2yJDWYMtX086kXXwKoMDUdErOmOR6BND4x37+HdTzTaz
         mBtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749218204; x=1749823004;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nWMe+CPV752eWO5pJOHKZI3Zz5P7ROmouZdNiOUAjLg=;
        b=kznFAIu631ZyUg4oUV9uh0I9EHSXf99YdAHI6d88AwhoQDncQLXTGO+1ejChrTwfHd
         3RndVlUfEswnzE1mp9SwxqVq4VZ2fzBG/WTRrAMrFjDvLVpA+it80IM5qpM0FwcrJBy0
         3yuBpfk1fY2asf81M78zuQ43VW6sUa0qEtsnF8CL6fVhG6dYxXtPPiwK8oJhGOy73ASn
         6v46pxpQ5Sg642czfTVSQwWoZa3GYqLTHvSUZ6/9sQCmdz58ZxoOE27gbEdHOE/42pK2
         /kDa5mhcbI7FVcDljVpwMUsLzFpR5iVm6IQj/G6c4gumyTaPqheyo/ZqAjVqyd0HGsNZ
         dqHw==
X-Forwarded-Encrypted: i=1; AJvYcCXAQxkhLXQRLwiU3NEKYok0CI0FIAEPs1yu8NTWc7dytwxSGy4fvnW0XoXPKjVBg6eBRvb+PuEEAHDy3D14@vger.kernel.org, AJvYcCXzYfK3J0SONxsvKrOdvg34+F2fOyjiAYsBPxE6TbSS1ztosV5tvrzbEAODz2TbjWL02rw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxisZlZjLNUw2k6+uvuXTsFf+Cq8/+zCrBWBX4LJeutnD4R+SMu
	BHQ0W+xav5hpV6NZAh1gq4txkOVfGWn9MGs0UJQ6wsdWXVU1wGnFtWLFHTXCcA==
X-Gm-Gg: ASbGncsq6g1599UWy/ZOUtRf0DGr3nOCKxY8Pyc0ZMf1CnENQ9lGCOfAPQUq+cH2FXj
	VoV82OL7S6VfuL+FIOn0LIahs72xb5HHqPpmjF4704w9aTna30E7mXN1thtxUsG3F7zJxcLOeU7
	cfnL2FwjmHhWLSWxfFk/GGM2CcCC8OQ9+AbPuDr6qpcpCWWz82EHZHOxYJ6qQsEs8RhxRKuLqnj
	8ipeCZRHpieZXp4/VnbnbKY1ZYPYTj1kXMK6yXFdE3iRlHMWkTm4pGlD2pF0+mh/kHRDEVBo7Pw
	LtKyEsCnZ1vqA/SPbFOEq2sbaSBVGI/nEdeSYgdv5L0tKQ==
X-Google-Smtp-Source: AGHT+IGTHo98cVWlTElkkwQOFkdLagcBVYC8pG8zXRDACYh8UdDhDdzYtg/jdxODl6/+g+QxBQfFvQ==
X-Received: by 2002:a17:907:7f2a:b0:ace:d710:a8d1 with SMTP id a640c23a62f3a-ade1a90a2f4mr306337766b.24.1749218204198;
        Fri, 06 Jun 2025 06:56:44 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:a199])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ade1dc379f6sm118026766b.110.2025.06.06.06.56.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Jun 2025 06:56:43 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	Martin KaFai Lau <martin.lau@linux.dev>,
	bpf@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC v2 1/5] io_uring: add struct for state controlling cqwait
Date: Fri,  6 Jun 2025 14:57:58 +0100
Message-ID: <933217fc63d9f7753e0e3e8dc239ba1a3f15add4.1749214572.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1749214572.git.asml.silence@gmail.com>
References: <cover.1749214572.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add struct iou_loop_state and place there parameter controlling the flow
of normal CQ waiting. It will be exposed to BPF for api of the helpers,
and while I could've used struct io_wait_queue, the name is not ideal,
and keeping only necessary bits makes further development a bit cleaner.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 20 ++++++++++----------
 io_uring/io_uring.h | 11 ++++++++---
 io_uring/napi.c     |  4 ++--
 3 files changed, 20 insertions(+), 15 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 5cdccf65c652..9cc4d8f335a1 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2404,8 +2404,8 @@ static enum hrtimer_restart io_cqring_min_timer_wakeup(struct hrtimer *timer)
 	struct io_ring_ctx *ctx = iowq->ctx;
 
 	/* no general timeout, or shorter (or equal), we are done */
-	if (iowq->timeout == KTIME_MAX ||
-	    ktime_compare(iowq->min_timeout, iowq->timeout) >= 0)
+	if (iowq->state.timeout == KTIME_MAX ||
+	    ktime_compare(iowq->min_timeout, iowq->state.timeout) >= 0)
 		goto out_wake;
 	/* work we may need to run, wake function will see if we need to wake */
 	if (io_has_work(ctx))
@@ -2431,7 +2431,7 @@ static enum hrtimer_restart io_cqring_min_timer_wakeup(struct hrtimer *timer)
 	}
 
 	hrtimer_update_function(&iowq->t, io_cqring_timer_wakeup);
-	hrtimer_set_expires(timer, iowq->timeout);
+	hrtimer_set_expires(timer, iowq->state.timeout);
 	return HRTIMER_RESTART;
 out_wake:
 	return io_cqring_timer_wakeup(timer);
@@ -2447,7 +2447,7 @@ static int io_cqring_schedule_timeout(struct io_wait_queue *iowq,
 		hrtimer_setup_on_stack(&iowq->t, io_cqring_min_timer_wakeup, clock_id,
 				       HRTIMER_MODE_ABS);
 	} else {
-		timeout = iowq->timeout;
+		timeout = iowq->state.timeout;
 		hrtimer_setup_on_stack(&iowq->t, io_cqring_timer_wakeup, clock_id,
 				       HRTIMER_MODE_ABS);
 	}
@@ -2488,7 +2488,7 @@ static int __io_cqring_wait_schedule(struct io_ring_ctx *ctx,
 	 */
 	if (ext_arg->iowait && current_pending_io())
 		current->in_iowait = 1;
-	if (iowq->timeout != KTIME_MAX || iowq->min_timeout)
+	if (iowq->state.timeout != KTIME_MAX || iowq->min_timeout)
 		ret = io_cqring_schedule_timeout(iowq, ctx->clockid, start_time);
 	else
 		schedule();
@@ -2546,18 +2546,18 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events, u32 flags,
 	iowq.wq.private = current;
 	INIT_LIST_HEAD(&iowq.wq.entry);
 	iowq.ctx = ctx;
-	iowq.cq_tail = READ_ONCE(ctx->rings->cq.head) + min_events;
+	iowq.state.target_cq_tail = READ_ONCE(ctx->rings->cq.head) + min_events;
 	iowq.cq_min_tail = READ_ONCE(ctx->rings->cq.tail);
 	iowq.nr_timeouts = atomic_read(&ctx->cq_timeouts);
 	iowq.hit_timeout = 0;
 	iowq.min_timeout = ext_arg->min_time;
-	iowq.timeout = KTIME_MAX;
+	iowq.state.timeout = KTIME_MAX;
 	start_time = io_get_time(ctx);
 
 	if (ext_arg->ts_set) {
-		iowq.timeout = timespec64_to_ktime(ext_arg->ts);
+		iowq.state.timeout = timespec64_to_ktime(ext_arg->ts);
 		if (!(flags & IORING_ENTER_ABS_TIMER))
-			iowq.timeout = ktime_add(iowq.timeout, start_time);
+			iowq.state.timeout = ktime_add(iowq.state.timeout, start_time);
 	}
 
 	if (ext_arg->sig) {
@@ -2582,7 +2582,7 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events, u32 flags,
 
 		/* if min timeout has been hit, don't reset wait count */
 		if (!iowq.hit_timeout)
-			nr_wait = (int) iowq.cq_tail -
+			nr_wait = (int) iowq.state.target_cq_tail -
 					READ_ONCE(ctx->rings->cq.tail);
 		else
 			nr_wait = 1;
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 0ea7a435d1de..edf698b81a95 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -39,15 +39,19 @@ enum {
 	IOU_REQUEUE		= -3072,
 };
 
+struct iou_loop_state {
+	__u32			target_cq_tail;
+	ktime_t			timeout;
+};
+
 struct io_wait_queue {
+	struct iou_loop_state state;
 	struct wait_queue_entry wq;
 	struct io_ring_ctx *ctx;
-	unsigned cq_tail;
 	unsigned cq_min_tail;
 	unsigned nr_timeouts;
 	int hit_timeout;
 	ktime_t min_timeout;
-	ktime_t timeout;
 	struct hrtimer t;
 
 #ifdef CONFIG_NET_RX_BUSY_POLL
@@ -59,7 +63,8 @@ struct io_wait_queue {
 static inline bool io_should_wake(struct io_wait_queue *iowq)
 {
 	struct io_ring_ctx *ctx = iowq->ctx;
-	int dist = READ_ONCE(ctx->rings->cq.tail) - (int) iowq->cq_tail;
+	u32 target = iowq->state.target_cq_tail;
+	int dist = READ_ONCE(ctx->rings->cq.tail) - target;
 
 	/*
 	 * Wake up if we have enough events, or if a timeout occurred since we
diff --git a/io_uring/napi.c b/io_uring/napi.c
index 4a10de03e426..e08bddc1dbd2 100644
--- a/io_uring/napi.c
+++ b/io_uring/napi.c
@@ -360,8 +360,8 @@ void __io_napi_busy_loop(struct io_ring_ctx *ctx, struct io_wait_queue *iowq)
 		return;
 
 	iowq->napi_busy_poll_dt = READ_ONCE(ctx->napi_busy_poll_dt);
-	if (iowq->timeout != KTIME_MAX) {
-		ktime_t dt = ktime_sub(iowq->timeout, io_get_time(ctx));
+	if (iowq->state.timeout != KTIME_MAX) {
+		ktime_t dt = ktime_sub(iowq->state.timeout, io_get_time(ctx));
 
 		iowq->napi_busy_poll_dt = min_t(u64, iowq->napi_busy_poll_dt, dt);
 	}
-- 
2.49.0


