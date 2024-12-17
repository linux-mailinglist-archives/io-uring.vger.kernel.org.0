Return-Path: <io-uring+bounces-5520-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 464749F5077
	for <lists+io-uring@lfdr.de>; Tue, 17 Dec 2024 17:11:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AD18E16C0EC
	for <lists+io-uring@lfdr.de>; Tue, 17 Dec 2024 16:10:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F30231FBEB4;
	Tue, 17 Dec 2024 15:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="HtZUaw+Z"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f169.google.com (mail-il1-f169.google.com [209.85.166.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 679201FBEA0
	for <io-uring@vger.kernel.org>; Tue, 17 Dec 2024 15:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734451031; cv=none; b=Z27w/PeurRt/QypNt8HhMPeUZCFik5SdCmM/Nl+yHjymqn9rgCmcUlNnYrrKE6XmqNJq0J3ZjM5PZMRo+Zak0BDxwgDbgeyn1SkJqqwi5reYAFuHt1KwoC2MzDJ5eBU43qjAlC2onX5D2KfYtnVG8DS5aXxfxcKLj+PfNUI5hHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734451031; c=relaxed/simple;
	bh=N+CyoOZx+ZRH602xvh24JOm6N0VYLR+AIn3VC4yXeVI=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=lo1aZOlZW9sv3cTt0SFGza2xELqOncqmsZYYQqUVsM5SF7oyZStFxoZ5vQApe92kNHIoihdGqSYG2l6nQnqHUSkZUj3AtpLwGgIhcSE2Tj2mo4zlKqtKr7PThVVy13ytlilyXFu4hYnFAihfTUKLp40i1JKJD7LIFmEzh2L6fw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=HtZUaw+Z; arc=none smtp.client-ip=209.85.166.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f169.google.com with SMTP id e9e14a558f8ab-3a77bd62fdeso35395005ab.2
        for <io-uring@vger.kernel.org>; Tue, 17 Dec 2024 07:57:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1734451027; x=1735055827; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=idREBCr93ddmVgChf6zfW3uRQpNr1ScHCLVFVQMGcBo=;
        b=HtZUaw+ZbL2GpfsJEeibmMsnknzmS+aN39Ix1zZB3no1YIKPY+sILPg3So8V7rIpGr
         O5Yl0b7uXhyXsu1dcjFGGJ8rvZPSEA2QIk7zxF3uUwNQwboRye1E7+8A9kLmXLnoUrVp
         oNvJw7BvdmufVqjOjN/SCb1PHgDNREF67GKNe9uS1dmvOFEx2Oayiigh1QTd0RQLmG2G
         3NdQQkgD2rDfX8JcFQjM1T3O87mtHL7Z7QqHe/3YIOl0JmAZ/Y5OQNQiLL61rOcu0kn4
         3ECzKs8nbvY93IY8M0X1oJGH14+bZLbs8BtBAkFpnrqPhMuXfELPjHePx3xqcLB5Ui3k
         i6Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734451027; x=1735055827;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=idREBCr93ddmVgChf6zfW3uRQpNr1ScHCLVFVQMGcBo=;
        b=IMdC+bamkGpnmKtedQirpdofsypD6LGB5mDYKlJC9rb/9GkeKZledubMBipS8PSmL7
         EV9SigJLDOiu8MHCb6F9OF1YBCqXo7NdpzuurlSnLoIVJ/ob2swzGNoTDqR0TUEWsdpV
         btebeYddP1Fz36YjT78IhO8Wd2uIYGqmTaKGu3nU6Kt2cA/04mvnNeEdB1nnUtRTmw3g
         gnbA7a4f5bUTacotzsb99YwbLx5gYGEVGj3GSXSBkax9S6Gi7VvfE8tB5hjjXmt3JkN3
         cMj5pB4r2cFw8P9Q5/7tkMyloS5LlcFhnr1Zi4YdPOzn2klQj0+KpUSt9M5VxTC2Ff6D
         0qnQ==
X-Gm-Message-State: AOJu0YxxinrHHPzpC9pyOwhYN1AxwfuVJI/APQ2tRe9t7YctrNe9MunJ
	bWHFTh7DKWO/wgL/RSH5XIWHFICCoCGBjq+1y3333x+zkwrLEQ36IGzO8Xdj2Qidp8WlswCB271
	W
X-Gm-Gg: ASbGncsgHi8QHEx8l9kVGxwzzy659oDlI1nyanRHinRYUakvg5DdTT+9p/lnNMdlYRy
	z+b6kCUyS6hfaoOoHV9ljcOwKsVdJg1XJfEzsha5lvrPCb6Z+4oNJIqDautEosuU543X1vORr6y
	XECz/ZjwxHldB4A7U5+kDZTH++wVx3TpNxry9c2570qvq8XFs9GCKCFsNL2m8upT5j30J8351ku
	wdwAtKg9RgkdWPdXrsAWAgKnrFuJoSRwFC0L+/qoaOGre+Y38Sp
X-Google-Smtp-Source: AGHT+IE7a6gluxeydDMFiGE/1tDqaYBjS10IRdDzggwFgM1b+BkNylm9w19QHr96Z0sGwYHwwKiY+g==
X-Received: by 2002:a05:6e02:20ea:b0:3a7:e8e1:cbc9 with SMTP id e9e14a558f8ab-3aff8aa41a0mr153127555ab.22.1734451026911;
        Tue, 17 Dec 2024 07:57:06 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3b248228b02sm22131095ab.27.2024.12.17.07.57.06
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Dec 2024 07:57:06 -0800 (PST)
Message-ID: <94df1bda-b2d9-4065-86c2-25de20e59395@kernel.dk>
Date: Tue, 17 Dec 2024 08:57:05 -0700
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
Subject: [PATCH] io_uring: make ctx->timeout_lock a raw spinlock
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Chase reports that their tester complaints about a locking context
mismatch:

=============================
[ BUG: Invalid wait context ]
6.13.0-rc1-gf137f14b7ccb-dirty #9 Not tainted
-----------------------------
syz.1.25198/182604 is trying to lock:
ffff88805e66a358 (&ctx->timeout_lock){-.-.}-{3:3}, at: spin_lock_irq
include/linux/spinlock.h:376 [inline]
ffff88805e66a358 (&ctx->timeout_lock){-.-.}-{3:3}, at:
io_match_task_safe io_uring/io_uring.c:218 [inline]
ffff88805e66a358 (&ctx->timeout_lock){-.-.}-{3:3}, at:
io_match_task_safe+0x187/0x250 io_uring/io_uring.c:204
other info that might help us debug this:
context-{5:5}
1 lock held by syz.1.25198/182604:
 #0: ffff88802b7d48c0 (&acct->lock){+.+.}-{2:2}, at:
io_acct_cancel_pending_work+0x2d/0x6b0 io_uring/io-wq.c:1049
stack backtrace:
CPU: 0 UID: 0 PID: 182604 Comm: syz.1.25198 Not tainted
6.13.0-rc1-gf137f14b7ccb-dirty #9
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x82/0xd0 lib/dump_stack.c:120
 print_lock_invalid_wait_context kernel/locking/lockdep.c:4826 [inline]
 check_wait_context kernel/locking/lockdep.c:4898 [inline]
 __lock_acquire+0x883/0x3c80 kernel/locking/lockdep.c:5176
 lock_acquire.part.0+0x11b/0x370 kernel/locking/lockdep.c:5849
 __raw_spin_lock_irq include/linux/spinlock_api_smp.h:119 [inline]
 _raw_spin_lock_irq+0x36/0x50 kernel/locking/spinlock.c:170
 spin_lock_irq include/linux/spinlock.h:376 [inline]
 io_match_task_safe io_uring/io_uring.c:218 [inline]
 io_match_task_safe+0x187/0x250 io_uring/io_uring.c:204
 io_acct_cancel_pending_work+0xb8/0x6b0 io_uring/io-wq.c:1052
 io_wq_cancel_pending_work io_uring/io-wq.c:1074 [inline]
 io_wq_cancel_cb+0xb0/0x390 io_uring/io-wq.c:1112
 io_uring_try_cancel_requests+0x15e/0xd70 io_uring/io_uring.c:3062
 io_uring_cancel_generic+0x6ec/0x8c0 io_uring/io_uring.c:3140
 io_uring_files_cancel include/linux/io_uring.h:20 [inline]
 do_exit+0x494/0x27a0 kernel/exit.c:894
 do_group_exit+0xb3/0x250 kernel/exit.c:1087
 get_signal+0x1d77/0x1ef0 kernel/signal.c:3017
 arch_do_signal_or_restart+0x79/0x5b0 arch/x86/kernel/signal.c:337
 exit_to_user_mode_loop kernel/entry/common.c:111 [inline]
 exit_to_user_mode_prepare include/linux/entry-common.h:329 [inline]
 __syscall_exit_to_user_mode_work kernel/entry/common.c:207 [inline]
 syscall_exit_to_user_mode+0x150/0x2a0 kernel/entry/common.c:218
 do_syscall_64+0xd8/0x250 arch/x86/entry/common.c:89
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

which is because io_uring has ctx->timeout_lock nesting inside the
io-wq acct lock, the latter of which is used from inside the scheduler
and hence is a raw spinlock, while the former is a "normal" spinlock
and can hence be sleeping on PREEMPT_RT.

Change ctx->timeout_lock to be a raw spinlock to solve this nesting
dependency on PREEMPT_RT=y.

Reported-by: chase xd <sl1589472800@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 011860ade268..fd4cdb0860a2 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -345,7 +345,7 @@ struct io_ring_ctx {
 
 	/* timeouts */
 	struct {
-		spinlock_t		timeout_lock;
+		raw_spinlock_t		timeout_lock;
 		struct list_head	timeout_list;
 		struct list_head	ltimeout_list;
 		unsigned		cq_last_tm_flush;
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 06ff41484e29..605625e932eb 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -215,9 +215,9 @@ bool io_match_task_safe(struct io_kiocb *head, struct io_uring_task *tctx,
 		struct io_ring_ctx *ctx = head->ctx;
 
 		/* protect against races with linked timeouts */
-		spin_lock_irq(&ctx->timeout_lock);
+		raw_spin_lock_irq(&ctx->timeout_lock);
 		matched = io_match_linked(head);
-		spin_unlock_irq(&ctx->timeout_lock);
+		raw_spin_unlock_irq(&ctx->timeout_lock);
 	} else {
 		matched = io_match_linked(head);
 	}
@@ -333,7 +333,7 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	init_waitqueue_head(&ctx->cq_wait);
 	init_waitqueue_head(&ctx->poll_wq);
 	spin_lock_init(&ctx->completion_lock);
-	spin_lock_init(&ctx->timeout_lock);
+	raw_spin_lock_init(&ctx->timeout_lock);
 	INIT_WQ_LIST(&ctx->iopoll_list);
 	INIT_LIST_HEAD(&ctx->io_buffers_comp);
 	INIT_LIST_HEAD(&ctx->defer_list);
@@ -498,10 +498,10 @@ static void io_prep_async_link(struct io_kiocb *req)
 	if (req->flags & REQ_F_LINK_TIMEOUT) {
 		struct io_ring_ctx *ctx = req->ctx;
 
-		spin_lock_irq(&ctx->timeout_lock);
+		raw_spin_lock_irq(&ctx->timeout_lock);
 		io_for_each_link(cur, req)
 			io_prep_async_work(cur);
-		spin_unlock_irq(&ctx->timeout_lock);
+		raw_spin_unlock_irq(&ctx->timeout_lock);
 	} else {
 		io_for_each_link(cur, req)
 			io_prep_async_work(cur);
diff --git a/io_uring/timeout.c b/io_uring/timeout.c
index f3d502717aeb..bbe58638eca7 100644
--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -74,10 +74,10 @@ static void io_timeout_complete(struct io_kiocb *req, struct io_tw_state *ts)
 	if (!io_timeout_finish(timeout, data)) {
 		if (io_req_post_cqe(req, -ETIME, IORING_CQE_F_MORE)) {
 			/* re-arm timer */
-			spin_lock_irq(&ctx->timeout_lock);
+			raw_spin_lock_irq(&ctx->timeout_lock);
 			list_add(&timeout->list, ctx->timeout_list.prev);
 			hrtimer_start(&data->timer, timespec64_to_ktime(data->ts), data->mode);
-			spin_unlock_irq(&ctx->timeout_lock);
+			raw_spin_unlock_irq(&ctx->timeout_lock);
 			return;
 		}
 	}
@@ -109,7 +109,7 @@ __cold void io_flush_timeouts(struct io_ring_ctx *ctx)
 	u32 seq;
 	struct io_timeout *timeout, *tmp;
 
-	spin_lock_irq(&ctx->timeout_lock);
+	raw_spin_lock_irq(&ctx->timeout_lock);
 	seq = ctx->cached_cq_tail - atomic_read(&ctx->cq_timeouts);
 
 	list_for_each_entry_safe(timeout, tmp, &ctx->timeout_list, list) {
@@ -134,7 +134,7 @@ __cold void io_flush_timeouts(struct io_ring_ctx *ctx)
 		io_kill_timeout(req, 0);
 	}
 	ctx->cq_last_tm_flush = seq;
-	spin_unlock_irq(&ctx->timeout_lock);
+	raw_spin_unlock_irq(&ctx->timeout_lock);
 }
 
 static void io_req_tw_fail_links(struct io_kiocb *link, struct io_tw_state *ts)
@@ -200,9 +200,9 @@ void io_disarm_next(struct io_kiocb *req)
 	} else if (req->flags & REQ_F_LINK_TIMEOUT) {
 		struct io_ring_ctx *ctx = req->ctx;
 
-		spin_lock_irq(&ctx->timeout_lock);
+		raw_spin_lock_irq(&ctx->timeout_lock);
 		link = io_disarm_linked_timeout(req);
-		spin_unlock_irq(&ctx->timeout_lock);
+		raw_spin_unlock_irq(&ctx->timeout_lock);
 		if (link)
 			io_req_queue_tw_complete(link, -ECANCELED);
 	}
@@ -238,11 +238,11 @@ static enum hrtimer_restart io_timeout_fn(struct hrtimer *timer)
 	struct io_ring_ctx *ctx = req->ctx;
 	unsigned long flags;
 
-	spin_lock_irqsave(&ctx->timeout_lock, flags);
+	raw_spin_lock_irqsave(&ctx->timeout_lock, flags);
 	list_del_init(&timeout->list);
 	atomic_set(&req->ctx->cq_timeouts,
 		atomic_read(&req->ctx->cq_timeouts) + 1);
-	spin_unlock_irqrestore(&ctx->timeout_lock, flags);
+	raw_spin_unlock_irqrestore(&ctx->timeout_lock, flags);
 
 	if (!(data->flags & IORING_TIMEOUT_ETIME_SUCCESS))
 		req_set_fail(req);
@@ -285,9 +285,9 @@ int io_timeout_cancel(struct io_ring_ctx *ctx, struct io_cancel_data *cd)
 {
 	struct io_kiocb *req;
 
-	spin_lock_irq(&ctx->timeout_lock);
+	raw_spin_lock_irq(&ctx->timeout_lock);
 	req = io_timeout_extract(ctx, cd);
-	spin_unlock_irq(&ctx->timeout_lock);
+	raw_spin_unlock_irq(&ctx->timeout_lock);
 
 	if (IS_ERR(req))
 		return PTR_ERR(req);
@@ -330,7 +330,7 @@ static enum hrtimer_restart io_link_timeout_fn(struct hrtimer *timer)
 	struct io_ring_ctx *ctx = req->ctx;
 	unsigned long flags;
 
-	spin_lock_irqsave(&ctx->timeout_lock, flags);
+	raw_spin_lock_irqsave(&ctx->timeout_lock, flags);
 	prev = timeout->head;
 	timeout->head = NULL;
 
@@ -345,7 +345,7 @@ static enum hrtimer_restart io_link_timeout_fn(struct hrtimer *timer)
 	}
 	list_del(&timeout->list);
 	timeout->prev = prev;
-	spin_unlock_irqrestore(&ctx->timeout_lock, flags);
+	raw_spin_unlock_irqrestore(&ctx->timeout_lock, flags);
 
 	req->io_task_work.func = io_req_task_link_timeout;
 	io_req_task_work_add(req);
@@ -472,12 +472,12 @@ int io_timeout_remove(struct io_kiocb *req, unsigned int issue_flags)
 	} else {
 		enum hrtimer_mode mode = io_translate_timeout_mode(tr->flags);
 
-		spin_lock_irq(&ctx->timeout_lock);
+		raw_spin_lock_irq(&ctx->timeout_lock);
 		if (tr->ltimeout)
 			ret = io_linked_timeout_update(ctx, tr->addr, &tr->ts, mode);
 		else
 			ret = io_timeout_update(ctx, tr->addr, &tr->ts, mode);
-		spin_unlock_irq(&ctx->timeout_lock);
+		raw_spin_unlock_irq(&ctx->timeout_lock);
 	}
 
 	if (ret < 0)
@@ -572,7 +572,7 @@ int io_timeout(struct io_kiocb *req, unsigned int issue_flags)
 	struct list_head *entry;
 	u32 tail, off = timeout->off;
 
-	spin_lock_irq(&ctx->timeout_lock);
+	raw_spin_lock_irq(&ctx->timeout_lock);
 
 	/*
 	 * sqe->off holds how many events that need to occur for this
@@ -611,7 +611,7 @@ int io_timeout(struct io_kiocb *req, unsigned int issue_flags)
 	list_add(&timeout->list, entry);
 	data->timer.function = io_timeout_fn;
 	hrtimer_start(&data->timer, timespec64_to_ktime(data->ts), data->mode);
-	spin_unlock_irq(&ctx->timeout_lock);
+	raw_spin_unlock_irq(&ctx->timeout_lock);
 	return IOU_ISSUE_SKIP_COMPLETE;
 }
 
@@ -620,7 +620,7 @@ void io_queue_linked_timeout(struct io_kiocb *req)
 	struct io_timeout *timeout = io_kiocb_to_cmd(req, struct io_timeout);
 	struct io_ring_ctx *ctx = req->ctx;
 
-	spin_lock_irq(&ctx->timeout_lock);
+	raw_spin_lock_irq(&ctx->timeout_lock);
 	/*
 	 * If the back reference is NULL, then our linked request finished
 	 * before we got a chance to setup the timer
@@ -633,7 +633,7 @@ void io_queue_linked_timeout(struct io_kiocb *req)
 				data->mode);
 		list_add_tail(&timeout->list, &ctx->ltimeout_list);
 	}
-	spin_unlock_irq(&ctx->timeout_lock);
+	raw_spin_unlock_irq(&ctx->timeout_lock);
 	/* drop submission reference */
 	io_put_req(req);
 }
@@ -668,7 +668,7 @@ __cold bool io_kill_timeouts(struct io_ring_ctx *ctx, struct io_uring_task *tctx
 	 * timeout_lockfirst to keep locking ordering.
 	 */
 	spin_lock(&ctx->completion_lock);
-	spin_lock_irq(&ctx->timeout_lock);
+	raw_spin_lock_irq(&ctx->timeout_lock);
 	list_for_each_entry_safe(timeout, tmp, &ctx->timeout_list, list) {
 		struct io_kiocb *req = cmd_to_io_kiocb(timeout);
 
@@ -676,7 +676,7 @@ __cold bool io_kill_timeouts(struct io_ring_ctx *ctx, struct io_uring_task *tctx
 		    io_kill_timeout(req, -ECANCELED))
 			canceled++;
 	}
-	spin_unlock_irq(&ctx->timeout_lock);
+	raw_spin_unlock_irq(&ctx->timeout_lock);
 	spin_unlock(&ctx->completion_lock);
 	return canceled != 0;
 }
-- 
Jens Axboe


