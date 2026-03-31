Return-Path: <io-uring+bounces-12894-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YCbRLzrIy2mnLgYAu9opvQ
	(envelope-from <io-uring+bounces-12894-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 31 Mar 2026 15:12:26 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 25C7B369FFE
	for <lists+io-uring@lfdr.de>; Tue, 31 Mar 2026 15:12:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D026F300D442
	for <lists+io-uring@lfdr.de>; Tue, 31 Mar 2026 13:12:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24A36364EA3;
	Tue, 31 Mar 2026 13:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="dZXs7Xaj"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42B0D271443
	for <io-uring@vger.kernel.org>; Tue, 31 Mar 2026 13:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774962744; cv=none; b=VCKJvM0/vvS8IPn3OK8YXvozOpnEML1LmT1wodlP9oVArpMBZB5WFQ46W9ovTHR3bxBvUB6cDdz/sqQFozqNqtUd+H80qQA0vqo5RMLBOjpRhqF+hF+RCfFI903Lya8LUyTr4hf5uK/lMpvzIfeXiRNoUbicZyIeA0KE+IP732M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774962744; c=relaxed/simple;
	bh=ixqHVKLBKuyQ4rpTHajemawMBZdOzLt57S7pPM17zSI=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Cc:Content-Type; b=EKc8renmlk9PpOmJJ1mjasVR9sSRNyN/GqWhUbBtkUvRjvgCG4BK2HwWLxiCJZytO9IEFqmZhRT0dfoQyOIbp+n3JRTbec+zwgwIExDQeB30bSJryC4sHXEaEofCCT4YuwBjZV4RdaIc78YR5wApdCVfh5Qqmqi4n1Apt5Asq0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=dZXs7Xaj; arc=none smtp.client-ip=209.85.210.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-7d4be94eeacso5353348a34.2
        for <io-uring@vger.kernel.org>; Tue, 31 Mar 2026 06:12:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1774962740; x=1775567540; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Wp+TdOSXWsGpVq8nC6H072ApljNiIOZczElehvNp6cs=;
        b=dZXs7XajgXP5ipliJGcLiHY3iQtM3sf5YH9DU5VT/fDSfG2W68ZWfY5J288PpimGFv
         yTOz8uRVT7v1d+VD2FyM5MApaMJybSz3zHW1+1d5qEfhuvQ3pCl3CzVxNgRCK1J/uvdv
         5kbBMK5uk7v+Bp0wPwRlq3puKg0aI2aZfDVlWC9Cj5AzKlnV3l+bIrZYFoFgoiQ8NJ00
         oQoyrYIlfmo4PD+XsgkVXEM6bOvQxkdlXoCSG12xC0Jx2gHIQ1mV8d/6jyUj344YsIBZ
         MDxVq6r5ycAxupchnBkkQ3bCFUZ+941mdsQP23pTZuxSUsWAk6mTzOVzRvoat0N76/9q
         dYVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774962740; x=1775567540;
        h=content-transfer-encoding:cc:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Wp+TdOSXWsGpVq8nC6H072ApljNiIOZczElehvNp6cs=;
        b=D29Bjm9NpSU2ABRKmt3A0NyD0eR0Xy6yUjWxhDz9D9Bczgss7N6E7ax8Wp2S5oGeMj
         NnIz/Dptdo1oFGPCMaUz9CP2mrjVCRUu1sZOvRxd6Fht9lHv1SRX563QiVl5FkYOQrrz
         PWWmgtZnZNiAfFBTvnq56cg196PZJUKJUvFYuTy4jqC8j79Nhog7bypTjjMVfdRp2AUm
         youFVGh+PKOqL397Xw5bDsh2tDaC9gFiHb9mTQbZYJVWpJFfbZ9con/7QNfSMaaJn9q1
         mFsdMgHW+H+CaN2uAdWbQvB7/1it+oWCZpoLdx51HOvkiyepIARiT0gA1DSWyenxgriu
         uNFQ==
X-Gm-Message-State: AOJu0YyROL8otHS+KUQwvSV8BjZTzAc8aCJNWDvxa1EUjkTGg/RlwkKC
	IBJS8ozjPGH9wy7vKyt1e1DvNkpXkiBJ5wbCkj5B9wHapoe6BusWdxARkBN3V+yXvfaMLyCQN4L
	9L16r
X-Gm-Gg: ATEYQzzij/f7diPPeoMkt1oK0h0zTUCsdtbf0UrG3fqdXXTm1yjNwMxIvZohD7x0bve
	GmbQjZD+Xw5GoybpRhHJBkF2BvTG8kgsbKA/gI7eC61CcgKC9uhQdrM29jE0nFKxAKRv2CEGaLz
	IxglLDr/b2iN9x53KPwnBdilQmocnEQ15AkVdt4JSuaOfsT6MPMo0Msf30wxlpqDBZbW4k302gC
	R77P2FC8AJL79t/KFd/YM2j7TB4m7FU07Lzt0dZlPxQFRQYQTHeEEkLQ0alfAo13y7tUjhZxbFu
	6wa8OzbY8gGAHg6INwZyXqusEnnBRddHGjvqgZGrgUbaDH6W1JK4VSkwMUSgE/yb5sQWSI6iaOb
	f+tYRsVuqI2T9peaqFn3rLkhxTOr24th+/BEU1Lv7zPF83CQBfYNyAk+Lpa3hG2sF9c6wtYRdQH
	doKnrQlERfA8RzyJ9ekLjMMEr67sTCslpCnXciL8GK/mafJoagjTojejpdddYxrhZQdRA470zGh
	0XIpUnc1g==
X-Received: by 2002:a05:6830:488f:b0:7c7:69c8:2d2 with SMTP id 46e09a7af769-7d9fad77586mr9173371a34.13.1774962740511;
        Tue, 31 Mar 2026 06:12:20 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7da0a7b5b41sm8350802a34.15.2026.03.31.06.12.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Mar 2026 06:12:19 -0700 (PDT)
Message-ID: <2915e619-06ec-414b-9458-92745c76e6f1@kernel.dk>
Date: Tue, 31 Mar 2026 07:12:19 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: io-uring <io-uring@vger.kernel.org>
From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v2] io_uring: protect remaining lockless ctx->rings accesses
 with RCU
Cc: Junxi Qian <qjx1298677004@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[gmail.com];
	RCPT_COUNT_TWO(0.00)[2];
	TAGGED_FROM(0.00)[bounces-12894-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	TO_DN_ALL(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-0.949];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel-dk.20230601.gappssmtp.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel.dk:email,kernel.dk:mid]
X-Rspamd-Queue-Id: 25C7B369FFE
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Commit 96189080265e addressed one case of ctx->rings being potentially
accessed while a resize is happening on the ring, but there are still
a few others that need handling. Add a helper for retrieving the
rings associated with an io_uring context, and add some sanity checking
to that to catch bad uses. ->rings_rcu is always valid, as long as it's
used within RCU read lock. Any use of ->rings_rcu or ->rings inside
either ->uring_lock or ->completion_lock is sane as well.

Do the minimum fix for the current kernel, but set it up such that this
basic infra can be extended for later kernels to make this harder to
mess up in the future.

Thanks to Junxi Qian for finding and debugging this issue.

Cc: stable@vger.kernel.org
Fixes: 79cfe9e59c2a ("io_uring/register: add IORING_REGISTER_RESIZE_RINGS")
Reviewed-by: Junxi Qian <qjx1298677004@gmail.com>
Tested-by: Junxi Qian <qjx1298677004@gmail.com>
Link: https://lore.kernel.org/io-uring/20260330172348.89416-1-qjx1298677004@gmail.com/
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 20ec8fdafcae..48f2f627319d 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2015,7 +2015,7 @@ int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 	if (ctx->flags & IORING_SETUP_SQ_REWIND)
 		entries = ctx->sq_entries;
 	else
-		entries = io_sqring_entries(ctx);
+		entries = __io_sqring_entries(ctx);
 
 	entries = min(nr, entries);
 	if (unlikely(!entries))
@@ -2250,7 +2250,9 @@ static __poll_t io_uring_poll(struct file *file, poll_table *wait)
 	 */
 	poll_wait(file, &ctx->poll_wq, wait);
 
-	if (!io_sqring_full(ctx))
+	rcu_read_lock();
+
+	if (!__io_sqring_full(ctx))
 		mask |= EPOLLOUT | EPOLLWRNORM;
 
 	/*
@@ -2270,6 +2272,7 @@ static __poll_t io_uring_poll(struct file *file, poll_table *wait)
 	if (__io_cqring_events_user(ctx) || io_has_work(ctx))
 		mask |= EPOLLIN | EPOLLRDNORM;
 
+	rcu_read_unlock();
 	return mask;
 }
 
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 0fa844faf287..ee24bc5d77b3 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -142,16 +142,28 @@ struct io_wait_queue {
 #endif
 };
 
+static inline struct io_rings *io_get_rings(struct io_ring_ctx *ctx)
+{
+	return rcu_dereference_check(ctx->rings_rcu,
+			lockdep_is_held(&ctx->uring_lock) ||
+			lockdep_is_held(&ctx->completion_lock));
+}
+
 static inline bool io_should_wake(struct io_wait_queue *iowq)
 {
 	struct io_ring_ctx *ctx = iowq->ctx;
-	int dist = READ_ONCE(ctx->rings->cq.tail) - (int) iowq->cq_tail;
+	struct io_rings *rings;
+	int dist;
+
+	guard(rcu)();
+	rings = io_get_rings(ctx);
 
 	/*
 	 * Wake up if we have enough events, or if a timeout occurred since we
 	 * started waiting. For timeouts, we always want to return to userspace,
 	 * regardless of event count.
 	 */
+	dist = READ_ONCE(rings->cq.tail) - (int) iowq->cq_tail;
 	return dist >= 0 || atomic_read(&ctx->cq_timeouts) != iowq->nr_timeouts;
 }
 
@@ -431,9 +443,9 @@ static inline void io_cqring_wake(struct io_ring_ctx *ctx)
 	__io_wq_wake(&ctx->cq_wait);
 }
 
-static inline bool io_sqring_full(struct io_ring_ctx *ctx)
+static inline bool __io_sqring_full(struct io_ring_ctx *ctx)
 {
-	struct io_rings *r = ctx->rings;
+	struct io_rings *r = io_get_rings(ctx);
 
 	/*
 	 * SQPOLL must use the actual sqring head, as using the cached_sq_head
@@ -445,9 +457,15 @@ static inline bool io_sqring_full(struct io_ring_ctx *ctx)
 	return READ_ONCE(r->sq.tail) - READ_ONCE(r->sq.head) == ctx->sq_entries;
 }
 
-static inline unsigned int io_sqring_entries(struct io_ring_ctx *ctx)
+static inline bool io_sqring_full(struct io_ring_ctx *ctx)
 {
-	struct io_rings *rings = ctx->rings;
+	guard(rcu)();
+	return __io_sqring_full(ctx);
+}
+
+static inline unsigned int __io_sqring_entries(struct io_ring_ctx *ctx)
+{
+	struct io_rings *rings = io_get_rings(ctx);
 	unsigned int entries;
 
 	/* make sure SQ entry isn't read before tail */
@@ -455,6 +473,12 @@ static inline unsigned int io_sqring_entries(struct io_ring_ctx *ctx)
 	return min(entries, ctx->sq_entries);
 }
 
+static inline unsigned int io_sqring_entries(struct io_ring_ctx *ctx)
+{
+	guard(rcu)();
+	return __io_sqring_entries(ctx);
+}
+
 /*
  * Don't complete immediately but use deferred completion infrastructure.
  * Protected by ->uring_lock and can only be used either with
diff --git a/io_uring/wait.c b/io_uring/wait.c
index 0581cadf20ee..c24d018d53ab 100644
--- a/io_uring/wait.c
+++ b/io_uring/wait.c
@@ -79,12 +79,15 @@ static enum hrtimer_restart io_cqring_min_timer_wakeup(struct hrtimer *timer)
 	if (io_has_work(ctx))
 		goto out_wake;
 	/* got events since we started waiting, min timeout is done */
-	if (iowq->cq_min_tail != READ_ONCE(ctx->rings->cq.tail))
-		goto out_wake;
-	/* if we have any events and min timeout expired, we're done */
-	if (io_cqring_events(ctx))
-		goto out_wake;
+	scoped_guard(rcu) {
+		struct io_rings *rings = io_get_rings(ctx);
 
+		if (iowq->cq_min_tail != READ_ONCE(rings->cq.tail))
+			goto out_wake;
+		/* if we have any events and min timeout expired, we're done */
+		if (io_cqring_events(ctx))
+			goto out_wake;
+	}
 	/*
 	 * If using deferred task_work running and application is waiting on
 	 * more than one request, ensure we reset it now where we are switching
@@ -186,9 +189,9 @@ int io_cqring_wait(struct io_ring_ctx *ctx, int min_events, u32 flags,
 		   struct ext_arg *ext_arg)
 {
 	struct io_wait_queue iowq;
-	struct io_rings *rings = ctx->rings;
+	struct io_rings *rings;
 	ktime_t start_time;
-	int ret;
+	int ret, nr_wait;
 
 	min_events = min_t(int, min_events, ctx->cq_entries);
 
@@ -201,15 +204,23 @@ int io_cqring_wait(struct io_ring_ctx *ctx, int min_events, u32 flags,
 
 	if (unlikely(test_bit(IO_CHECK_CQ_OVERFLOW_BIT, &ctx->check_cq)))
 		io_cqring_do_overflow_flush(ctx);
-	if (__io_cqring_events_user(ctx) >= min_events)
+
+	rcu_read_lock();
+	rings = io_get_rings(ctx);
+	if (__io_cqring_events_user(ctx) >= min_events) {
+		rcu_read_unlock();
 		return 0;
+	}
 
 	init_waitqueue_func_entry(&iowq.wq, io_wake_function);
 	iowq.wq.private = current;
 	INIT_LIST_HEAD(&iowq.wq.entry);
 	iowq.ctx = ctx;
-	iowq.cq_tail = READ_ONCE(ctx->rings->cq.head) + min_events;
-	iowq.cq_min_tail = READ_ONCE(ctx->rings->cq.tail);
+	iowq.cq_tail = READ_ONCE(rings->cq.head) + min_events;
+	iowq.cq_min_tail = READ_ONCE(rings->cq.tail);
+	nr_wait = (int) iowq.cq_tail - READ_ONCE(rings->cq.tail);
+	rcu_read_unlock();
+	rings = NULL;
 	iowq.nr_timeouts = atomic_read(&ctx->cq_timeouts);
 	iowq.hit_timeout = 0;
 	iowq.min_timeout = ext_arg->min_time;
@@ -240,14 +251,6 @@ int io_cqring_wait(struct io_ring_ctx *ctx, int min_events, u32 flags,
 	trace_io_uring_cqring_wait(ctx, min_events);
 	do {
 		unsigned long check_cq;
-		int nr_wait;
-
-		/* if min timeout has been hit, don't reset wait count */
-		if (!iowq.hit_timeout)
-			nr_wait = (int) iowq.cq_tail -
-					READ_ONCE(ctx->rings->cq.tail);
-		else
-			nr_wait = 1;
 
 		if (ctx->flags & IORING_SETUP_DEFER_TASKRUN) {
 			atomic_set(&ctx->cq_wait_nr, nr_wait);
@@ -298,11 +301,20 @@ int io_cqring_wait(struct io_ring_ctx *ctx, int min_events, u32 flags,
 			break;
 		}
 		cond_resched();
+
+		/* if min timeout has been hit, don't reset wait count */
+		if (!iowq.hit_timeout)
+			scoped_guard(rcu)
+				nr_wait = (int) iowq.cq_tail -
+						READ_ONCE(ctx->rings_rcu->cq.tail);
+		else
+			nr_wait = 1;
 	} while (1);
 
 	if (!(ctx->flags & IORING_SETUP_DEFER_TASKRUN))
 		finish_wait(&ctx->cq_wait, &iowq.wq);
 	restore_saved_sigmask_unless(ret == -EINTR);
 
-	return READ_ONCE(rings->cq.head) == READ_ONCE(rings->cq.tail) ? ret : 0;
+	guard(rcu)();
+	return READ_ONCE(ctx->rings_rcu->cq.head) == READ_ONCE(ctx->rings_rcu->cq.tail) ? ret : 0;
 }
diff --git a/io_uring/wait.h b/io_uring/wait.h
index 5e236f74e1af..3a145fcfd3dd 100644
--- a/io_uring/wait.h
+++ b/io_uring/wait.h
@@ -28,12 +28,15 @@ void io_cqring_do_overflow_flush(struct io_ring_ctx *ctx);
 
 static inline unsigned int __io_cqring_events(struct io_ring_ctx *ctx)
 {
-	return ctx->cached_cq_tail - READ_ONCE(ctx->rings->cq.head);
+	struct io_rings *rings = io_get_rings(ctx);
+	return ctx->cached_cq_tail - READ_ONCE(rings->cq.head);
 }
 
 static inline unsigned int __io_cqring_events_user(struct io_ring_ctx *ctx)
 {
-	return READ_ONCE(ctx->rings->cq.tail) - READ_ONCE(ctx->rings->cq.head);
+	struct io_rings *rings = io_get_rings(ctx);
+
+	return READ_ONCE(rings->cq.tail) - READ_ONCE(rings->cq.head);
 }
 
 /*

-- 
Jens Axboe


