Return-Path: <io-uring+bounces-12890-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oEqrDwiyymkX/QUAu9opvQ
	(envelope-from <io-uring+bounces-12890-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 30 Mar 2026 19:25:28 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id A71A035F46E
	for <lists+io-uring@lfdr.de>; Mon, 30 Mar 2026 19:25:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id E9732300C262
	for <lists+io-uring@lfdr.de>; Mon, 30 Mar 2026 17:25:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 181983DC4AA;
	Mon, 30 Mar 2026 17:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KXT4iWcN"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 854653A3E66
	for <io-uring@vger.kernel.org>; Mon, 30 Mar 2026 17:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774891505; cv=none; b=RREDGczm4FDRHnrUwQx4NcJlIAqjo4itm/PzGquUdJoDendRcxRJC4MyShz7pDlxqDIwJ6JCTOnD8uV7hUz250MXLdoDo8/ri82K25djbWjW3aa5IYznsSpZD4q1eiFhyQULqWys2Z8lLIorSj913SfUybdg8Rtgf6wI0IsizxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774891505; c=relaxed/simple;
	bh=ozaZCzcVDbSTnRcnD3mn1RdT6Yp90jK0gApqaNoWI5Q=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=q73eA4EK2Ufg5Yo55bqQnA8FSz/zuq29giJvYne1nntpqcPmEAWone+pWu5bhpsSO2UJvnfNk4aSnSfjFsdSuvLSim6N9+qcD0tNbOu5VcnfZADyJ0/LPbZWZ/0IXY+OqrIctUEIbvxhX7NnQFNkUl1Tm9vNpzAtHKIy8iXtbD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KXT4iWcN; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-35d965648a2so1463506a91.0
        for <io-uring@vger.kernel.org>; Mon, 30 Mar 2026 10:25:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774891503; x=1775496303; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gIkmVEYtUFF3zaelCFShZDvfsnrhTr2rGWhB4Po6xdk=;
        b=KXT4iWcNlxqaMwcUCzgBOGeTScYxoJHNgpFxX4Ax6mdTwL9KRyWnkGGSychm8IoAy4
         pk3luOV6hqGNXsUmOenupC+H0Z2/WsqROkikhOsYqhLg7B3au2yDpMt/TQihVc5fpljQ
         hpI6i/kej+jQ/ij3BuP841aWemWXMcYZT4uKWx5hShXKbkWp9dKWz2s8e4bDAjGQ1l/w
         u13ltlAQVOjrV67e4Zfdr6raytN9Bm3TUyfdPAeKc0qDLrdBvmWlNPXXpsdKXc9tML2X
         JM93pW3+ekAgDhaH7xSdRwRqYf0FJKWptnAjRvMUrg4vhSIKj8LkboicJWDZilYlHQbM
         qQ6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774891503; x=1775496303;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gIkmVEYtUFF3zaelCFShZDvfsnrhTr2rGWhB4Po6xdk=;
        b=Z8eGG5JbzRmofHqFPERGj62vkBDXa4OgNSugrbM+Hss43MLqQ5mz6tBUBV6aYaKkGO
         xmHOTCZV6iZw+cjgdaknOsP9KBKLZiwoyElbk8/6nossp3yQ30NPYmq5DvGAaRusg5rU
         8vQS9VJOkd9sjaqKDkTsztDqarol1Wn4PdMRcxNkaLOO2lGwqVZiqQDVlUAEAaIIJt0Y
         Y2XyUVnx1yhJtA4NeDeFl2QQyrPB3qNxo+CEt04G9P6qAVFcAno0CiQGaCwvRThMJkH8
         jiPh+YVUFrGLfxTa1MO2Wl0qvIIyBy5PtXSRH0uOTemwE6Za4S353IxaeG+q5SrpZEco
         LMIg==
X-Gm-Message-State: AOJu0YxngvRhRfxnrqBaF162cYnFaSC8+3giVcpuoGzR2bmxjnx6dSIk
	O/fc2lgVjTfSY1RWxB9DFTPRDuT0CGKk/p3MHXPV1WqgpZkLwEGLywSrMyKAkqHP
X-Gm-Gg: ATEYQzz2iv4cKZZcbANbSXfeTNnuYBr0UqTW47QvEkoM+pj5M3n7z5cW8vGtKdSE6go
	+9rTmWzGTWpLWE5ARoWd06WTAIQU7ANFs6KhJAnH/FexaFCfderT0JfCYjzG0wlVRSJP6m8XYdg
	7aOu/junCikVdaTYW9sOJPVoe+R2ybZU1EwEIyRCMRHeVOn2G0XvVm63Vfe8jZlhkKdymghSWZH
	90Yoye0rfvwZdFQHqI0ITALK7YE9Rt5IWcOtHc6jn1Rjz8fFy9+uUDjWD2NC9ztjVv0H3XSuSbH
	sjoPdd4GnIAxbf4ahJwXYRqQPyYiUaGDKcR3viJNKI0oQ/kXjby/FCQGa++fVAtPaP/ACxf85ae
	2XL4UEntPLx3QxabegH8bqAFic2rkCm26PSOKno9cQ0q5GAqOngV0fcPDma4Z3u8mMob04Vw3s2
	E2hC0Rt+VPbE2MhpfRo4kOmHsIcmUrYuGOPZKCjZk=
X-Received: by 2002:a17:90a:e705:b0:353:5595:3247 with SMTP id 98e67ed59e1d1-35c2ff618edmr12399990a91.12.1774891502331;
        Mon, 30 Mar 2026 10:25:02 -0700 (PDT)
Received: from localhost.localdomain ([183.63.97.217])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35c2db0a951sm4203324a91.5.2026.03.30.10.25.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2026 10:25:02 -0700 (PDT)
From: Junxi Qian <qjx1298677004@gmail.com>
To: io-uring@vger.kernel.org
Cc: axboe@kernel.dk
Subject: [PATCH] io_uring: protect remaining lockless ctx->rings accesses with RCU
Date: Tue, 31 Mar 2026 01:23:48 +0800
Message-Id: <20260330172348.89416-1-qjx1298677004@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12890-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_TWO(0.00)[2];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_NEQ_ENVFROM(0.00)[qjx1298677004@gmail.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_NONE(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_RCPT(0.00)[io-uring];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: A71A035F46E
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

io_register_resize_rings() briefly sets ctx->rings to NULL under
completion_lock before assigning the new rings and publishing them
via rcu_assign_pointer(ctx->rings_rcu, ...).  Several code paths
read ctx->rings without holding any of those locks, leading to a
NULL pointer dereference if they race with a resize:

  - io_uring_poll()              (VFS poll callback)
  - io_should_wake()             (waitqueue wake callback)
  - io_cqring_min_timer_wakeup() (hrtimer callback)
  - io_cqring_wait()             (called from io_uring_enter)

Commit 96189080265e only addressed io_ctx_mark_taskrun() in tw.c.
Protect the remaining sites by reading ctx->rings_rcu under
rcu_read_lock() (via guard(rcu)/scoped_guard(rcu)) and treating a
NULL rings as "no data available / force re-evaluation".

Fixes: 79cfe9e59c2a ("io_uring/register: add IORING_REGISTER_RESIZE_RINGS")
Cc: stable@vger.kernel.org
Signed-off-by: Junxi Qian <qjx1298677004@gmail.com>
---
I'm not entirely sure this is the best approach for all the affected
call sites -- I'd appreciate any feedback or suggestions on whether
this looks reasonable.
---
 io_uring/io_uring.c | 17 +++++++++---
 io_uring/io_uring.h |  9 ++++++-
 io_uring/wait.c     | 63 +++++++++++++++++++++++++++++++++------------
 3 files changed, 69 insertions(+), 20 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 9a37035e7..98029b039 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2240,6 +2240,7 @@ __cold void io_activate_pollwq(struct io_ring_ctx *ctx)
 static __poll_t io_uring_poll(struct file *file, poll_table *wait)
 {
 	struct io_ring_ctx *ctx = file->private_data;
+	struct io_rings *rings;
 	__poll_t mask = 0;
 
 	if (unlikely(!ctx->poll_activated))
@@ -2250,7 +2251,17 @@ static __poll_t io_uring_poll(struct file *file, poll_table *wait)
 	 */
 	poll_wait(file, &ctx->poll_wq, wait);
 
-	if (!io_sqring_full(ctx))
+	/*
+	 * Use the RCU-protected rings pointer to be safe against
+	 * concurrent ring resizing, which briefly NULLs ctx->rings.
+	 */
+	guard(rcu)();
+	rings = rcu_dereference(ctx->rings_rcu);
+	if (unlikely(!rings))
+		return 0;
+
+	if (READ_ONCE(rings->sq.tail) - READ_ONCE(rings->sq.head) !=
+							ctx->sq_entries)
 		mask |= EPOLLOUT | EPOLLWRNORM;
 
 	/*
@@ -2266,8 +2277,8 @@ static __poll_t io_uring_poll(struct file *file, poll_table *wait)
 	 * Users may get EPOLLIN meanwhile seeing nothing in cqring, this
 	 * pushes them to do the flush.
 	 */
-
-	if (__io_cqring_events_user(ctx) || io_has_work(ctx))
+	if (READ_ONCE(rings->cq.tail) != READ_ONCE(rings->cq.head) ||
+	    io_has_work(ctx))
 		mask |= EPOLLIN | EPOLLRDNORM;
 
 	return mask;
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 0fa844faf..ea953f2c7 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -145,7 +145,14 @@ struct io_wait_queue {
 static inline bool io_should_wake(struct io_wait_queue *iowq)
 {
 	struct io_ring_ctx *ctx = iowq->ctx;
-	int dist = READ_ONCE(ctx->rings->cq.tail) - (int) iowq->cq_tail;
+	struct io_rings *rings;
+	int dist;
+
+	guard(rcu)();
+	rings = rcu_dereference(ctx->rings_rcu);
+	if (unlikely(!rings))
+		return true;
+	dist = READ_ONCE(rings->cq.tail) - (int) iowq->cq_tail;
 
 	/*
 	 * Wake up if we have enough events, or if a timeout occurred since we
diff --git a/io_uring/wait.c b/io_uring/wait.c
index 0581cadf2..af25f8f16 100644
--- a/io_uring/wait.c
+++ b/io_uring/wait.c
@@ -78,12 +78,20 @@ static enum hrtimer_restart io_cqring_min_timer_wakeup(struct hrtimer *timer)
 	/* work we may need to run, wake function will see if we need to wake */
 	if (io_has_work(ctx))
 		goto out_wake;
-	/* got events since we started waiting, min timeout is done */
-	if (iowq->cq_min_tail != READ_ONCE(ctx->rings->cq.tail))
-		goto out_wake;
-	/* if we have any events and min timeout expired, we're done */
-	if (io_cqring_events(ctx))
-		goto out_wake;
+
+	scoped_guard(rcu) {
+		struct io_rings *rings = rcu_dereference(ctx->rings_rcu);
+
+		if (!rings)
+			goto out_wake;
+		/* got events since we started waiting, min timeout is done */
+		if (iowq->cq_min_tail != READ_ONCE(rings->cq.tail))
+			goto out_wake;
+		/* if we have any events and min timeout expired, we're done */
+		smp_rmb();
+		if (ctx->cached_cq_tail != READ_ONCE(rings->cq.head))
+			goto out_wake;
+	}
 
 	/*
 	 * If using deferred task_work running and application is waiting on
@@ -186,7 +194,7 @@ int io_cqring_wait(struct io_ring_ctx *ctx, int min_events, u32 flags,
 		   struct ext_arg *ext_arg)
 {
 	struct io_wait_queue iowq;
-	struct io_rings *rings = ctx->rings;
+	struct io_rings *rings;
 	ktime_t start_time;
 	int ret;
 
@@ -201,15 +209,27 @@ int io_cqring_wait(struct io_ring_ctx *ctx, int min_events, u32 flags,
 
 	if (unlikely(test_bit(IO_CHECK_CQ_OVERFLOW_BIT, &ctx->check_cq)))
 		io_cqring_do_overflow_flush(ctx);
-	if (__io_cqring_events_user(ctx) >= min_events)
-		return 0;
 
 	init_waitqueue_func_entry(&iowq.wq, io_wake_function);
 	iowq.wq.private = current;
 	INIT_LIST_HEAD(&iowq.wq.entry);
 	iowq.ctx = ctx;
-	iowq.cq_tail = READ_ONCE(ctx->rings->cq.head) + min_events;
-	iowq.cq_min_tail = READ_ONCE(ctx->rings->cq.tail);
+
+	scoped_guard(rcu) {
+		rings = rcu_dereference(ctx->rings_rcu);
+		if (rings) {
+			if (READ_ONCE(rings->cq.tail) -
+			    READ_ONCE(rings->cq.head) >=
+					(unsigned int)min_events)
+				return 0;
+			iowq.cq_tail = READ_ONCE(rings->cq.head) +
+							min_events;
+			iowq.cq_min_tail = READ_ONCE(rings->cq.tail);
+		} else {
+			iowq.cq_tail = min_events;
+			iowq.cq_min_tail = 0;
+		}
+	}
 	iowq.nr_timeouts = atomic_read(&ctx->cq_timeouts);
 	iowq.hit_timeout = 0;
 	iowq.min_timeout = ext_arg->min_time;
@@ -243,11 +263,16 @@ int io_cqring_wait(struct io_ring_ctx *ctx, int min_events, u32 flags,
 		int nr_wait;
 
 		/* if min timeout has been hit, don't reset wait count */
-		if (!iowq.hit_timeout)
-			nr_wait = (int) iowq.cq_tail -
-					READ_ONCE(ctx->rings->cq.tail);
-		else
+		if (!iowq.hit_timeout) {
+			scoped_guard(rcu) {
+				rings = rcu_dereference(ctx->rings_rcu);
+				nr_wait = rings ?
+					(int) iowq.cq_tail -
+					  READ_ONCE(rings->cq.tail) : 1;
+			}
+		} else {
 			nr_wait = 1;
+		}
 
 		if (ctx->flags & IORING_SETUP_DEFER_TASKRUN) {
 			atomic_set(&ctx->cq_wait_nr, nr_wait);
@@ -304,5 +329,11 @@ int io_cqring_wait(struct io_ring_ctx *ctx, int min_events, u32 flags,
 		finish_wait(&ctx->cq_wait, &iowq.wq);
 	restore_saved_sigmask_unless(ret == -EINTR);
 
-	return READ_ONCE(rings->cq.head) == READ_ONCE(rings->cq.tail) ? ret : 0;
+	scoped_guard(rcu) {
+		rings = rcu_dereference(ctx->rings_rcu);
+		if (rings &&
+		    READ_ONCE(rings->cq.head) != READ_ONCE(rings->cq.tail))
+			ret = 0;
+	}
+	return ret;
 }
-- 
2.34.1


