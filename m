Return-Path: <io-uring+bounces-12891-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sJuGFCq8ymnh/gUAu9opvQ
	(envelope-from <io-uring+bounces-12891-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 30 Mar 2026 20:08:42 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A45BD35F965
	for <lists+io-uring@lfdr.de>; Mon, 30 Mar 2026 20:08:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 7DD4C3008615
	for <lists+io-uring@lfdr.de>; Mon, 30 Mar 2026 18:08:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 621023BB48;
	Mon, 30 Mar 2026 18:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="bgoD4qkY"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f45.google.com (mail-oo1-f45.google.com [209.85.161.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93AD630DEB0
	for <io-uring@vger.kernel.org>; Mon, 30 Mar 2026 18:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774894116; cv=none; b=q0HmyIGXVWF6uVypI+dbkXazgMbtuDwUKTMtx0e65LNaweYex6j2iO2UcTndxFddY81O33uQLMAkS5Z5/7rIs/8tRNP97eIdQGD89LxrXMyV9ObPCSLLd3MYuuqNxHtH4lVtMdyE8NkYHQtn5MVwta7ffw8uJZ4WrEuDQEyHa5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774894116; c=relaxed/simple;
	bh=L+8EYRduvjqg5E8Dwv5fYT9ZF4Eu/cll/LRcCCrhumk=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=UhNZfHMYevgvyn5LgsCUvp7n2GYkKF7trEOliFbQYCefvJNa+PDg3pjyH+c4GzC7OVwc45M4BTi2rrpEGjLBINTwxc9iyzCzwNfsPKg5dWksToPKLpEwSB0rvH46j2hDgg48984wfkv/F+DuzZWKTfCpFkSl8qTt8lBrXsbUYMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=bgoD4qkY; arc=none smtp.client-ip=209.85.161.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oo1-f45.google.com with SMTP id 006d021491bc7-67ba5921b84so2813411eaf.3
        for <io-uring@vger.kernel.org>; Mon, 30 Mar 2026 11:08:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1774894111; x=1775498911; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VLrxMo8sJ+zUgL1CmRe35sMtaw6Irl67QZ+OzAzCbSw=;
        b=bgoD4qkYkjx0FP3AF5wbbCHPAb5Ko0yNLW8Vp8WmXqROeVgYZ9sqBPMO9tLoSyYrfu
         RkTvm6lesD6zhXPypaURPP+cOmB8Z5MbC1qiJlldAVKDvK88m5LL3mkA+0OLuvIz0Ltr
         mvHki8wfdyItTvSeHHecqdlCGK/6pZqzbtdEx4IMW+cZpNu9y0ReilBZxTktLr1YwQX1
         zTKapU5/+AOKmVt2b6YpEKVguUf8aO9m22g/e2InSKa4H2w27HyZsu9it+2EgOW7JBhG
         XJEmxuFNisN6RwYXtEBp8uqI3wG9gfDNNjnhBFf6hUfI0hx269IBqd7XNJVqZY+N0A+K
         SteA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774894111; x=1775498911;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VLrxMo8sJ+zUgL1CmRe35sMtaw6Irl67QZ+OzAzCbSw=;
        b=D9zpUj1UdfxZiUohCPsQBL/YpXNj3T1poOQZ/M9riNMBD2wtWrV7SpC5MCDdBZrN7q
         pdcX7hEX4XtzrpMp7uStG9oy8jL5NnoNcoAv9/xhiaEP4iQb1YpX0YSeDHRgZZYwB4xe
         bfmESTYqNq0a+bzrzs4H1eclXV4RBsNkG+YFXqsQQdpHvUcCvwJ7zNY6zPsBTk2mb4R3
         78XrlOVcgpv5klCb6Xk9254A2yqVKEcQNFBPbVZ1OdicIC8tLehapoKYwvqTaM1yS1iR
         1JOtEac9zeoXvnEVFPyfO9wHH9iOXgh40aFlINYfKGRDBfqJdCZ7tiSjPtxjK/AuTJLG
         XQ2A==
X-Forwarded-Encrypted: i=1; AJvYcCUkxD4DzpxnGkWogdSgZ2wIOdA/noytVoQNstRYpTU38LZhf5wlpgnHnZYPx7HLLUJoUQQ22xPv5w==@vger.kernel.org
X-Gm-Message-State: AOJu0YzYVZ/PPKqc4MT4fRfx4agMzdacGHV6U3G3u1ao0nJC8VOLQWBx
	Ngtz6wu720uk9dQ6QX4foo9XYXVyWcMoUXd7KamGELJuF1rBlyyayufmsHvplfD3lZWm0zxDwbj
	731y+
X-Gm-Gg: ATEYQzz+xsog/velXc5U7QmvCSDoOe+Zr+9UvtmtUSyaEzP/p/JQIqWurhrwK1ZpjWV
	MJrFVTB1PbmZsicvkx98vIH3Lzwf4Zhj6egK5o6R4HEDfbCOwlX5kSJESmnp58PSKjWXuNQVbvE
	STt3Oo0y0OnYfd3MHSLWDT6Pz9ZgpQ/+K9VmFDEnGyBxQHGVxEjYF9zrwenMTu7MFbSqCFzGxy1
	uRmSF0CTNt/igOhamt3ZXHT2r7dhxp6Yhqt+pw81ChBNxLVfb/v2Fx2dUKYrAQyOR0gMW6B3wd3
	H/U1pQd5XyScgUy40hnk24WSR1KjYo9bGevMpPE2TgHLUfCEW32r1hVdyQwE/utqc+uvThXzmOT
	6BqefxmkM99x+1WTuIWpUuk4vqllSWf7XkbFwYmRQ32Epmj1fqQbXhZY8dtw4SEio4SrN8ncwoy
	O+laNAnkkFjX9OoY5bBY0ZoUW/s09GW1YEHsHyVDQAkMWML3+QqHwILfWZE4N/MbSl9WowWj5Ds
	WWxBFAyBwxAknztZgI=
X-Received: by 2002:a05:6820:1899:b0:67e:3004:137 with SMTP id 006d021491bc7-67e3004016bmr2973664eaf.4.1774894111086;
        Mon, 30 Mar 2026 11:08:31 -0700 (PDT)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-41d048e47cfsm4997075fac.3.2026.03.30.11.08.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Mar 2026 11:08:27 -0700 (PDT)
Message-ID: <a0c448c5-8fe8-43e8-a8ec-17f5912a4bc4@kernel.dk>
Date: Mon, 30 Mar 2026 12:08:24 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: protect remaining lockless ctx->rings accesses
 with RCU
To: Junxi Qian <qjx1298677004@gmail.com>, io-uring@vger.kernel.org
References: <20260330172348.89416-1-qjx1298677004@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260330172348.89416-1-qjx1298677004@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12891-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	FREEMAIL_TO(0.00)[gmail.com,vger.kernel.org];
	DMARC_NA(0.00)[kernel.dk];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,kernel.dk:mid]
X-Rspamd-Queue-Id: A45BD35F965
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 3/30/26 11:23 AM, Junxi Qian wrote:
> io_register_resize_rings() briefly sets ctx->rings to NULL under
> completion_lock before assigning the new rings and publishing them
> via rcu_assign_pointer(ctx->rings_rcu, ...).  Several code paths
> read ctx->rings without holding any of those locks, leading to a
> NULL pointer dereference if they race with a resize:
> 
>   - io_uring_poll()              (VFS poll callback)
>   - io_should_wake()             (waitqueue wake callback)
>   - io_cqring_min_timer_wakeup() (hrtimer callback)
>   - io_cqring_wait()             (called from io_uring_enter)
> 
> Commit 96189080265e only addressed io_ctx_mark_taskrun() in tw.c.
> Protect the remaining sites by reading ctx->rings_rcu under
> rcu_read_lock() (via guard(rcu)/scoped_guard(rcu)) and treating a
> NULL rings as "no data available / force re-evaluation".

First of all, thanks for the patch!

I took a look at this, but I'm not a huge fan of the scoped guard in
most spots, it just makes it harder to read. And I think that building
on top of this for later kernels will make sense, so cleaner to add some
helpers. Outside of that, the wait side can be a bit smarter rather than
just wrap everything in rcu multiple times (eg the nr_wait part).

There also should be no need to check 'rings' for NULL, it'll always be
a valid value.

How about something like this instead?


diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 16122f877aed..079b37835833 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2017,7 +2017,7 @@ int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 	if (ctx->flags & IORING_SETUP_SQ_REWIND)
 		entries = ctx->sq_entries;
 	else
-		entries = io_sqring_entries(ctx);
+		entries = __io_sqring_entries(ctx);
 
 	entries = min(nr, entries);
 	if (unlikely(!entries))
@@ -2253,7 +2253,9 @@ static __poll_t io_uring_poll(struct file *file, poll_table *wait)
 	 */
 	poll_wait(file, &ctx->poll_wq, wait);
 
-	if (!io_sqring_full(ctx))
+	rcu_read_lock();
+
+	if (!__io_sqring_full(ctx))
 		mask |= EPOLLOUT | EPOLLWRNORM;
 
 	/*
@@ -2273,6 +2275,7 @@ static __poll_t io_uring_poll(struct file *file, poll_table *wait)
 	if (__io_cqring_events_user(ctx) || io_has_work(ctx))
 		mask |= EPOLLIN | EPOLLRDNORM;
 
+	rcu_read_unlock();
 	return mask;
 }
 
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 91cf67b5d85b..5c47ed0b4276 100644
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
index 037e512dd80c..a4274b137f81 100644
--- a/io_uring/wait.h
+++ b/io_uring/wait.h
@@ -29,12 +29,15 @@ void io_cqring_overflow_flush_locked(struct io_ring_ctx *ctx);
 
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

