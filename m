Return-Path: <io-uring+bounces-5638-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 14F809FEB05
	for <lists+io-uring@lfdr.de>; Mon, 30 Dec 2024 22:23:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AE1FE160F41
	for <lists+io-uring@lfdr.de>; Mon, 30 Dec 2024 21:23:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D9321925B3;
	Mon, 30 Dec 2024 21:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="vzlaqUYM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46381188CB1
	for <io-uring@vger.kernel.org>; Mon, 30 Dec 2024 21:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735593784; cv=none; b=qag24MbGnXYQMDyz3iZJifWJqMf/Qm1QikE2GkHpyd0Fv7DeIg6gGd5vGNXKQK4UrclQH7VlP1rmSVqP7MdBBI4XudSRgSO2B3pp0vxAop8UgiqTkYNr1wo7VXB9SAfvdJEXFWNjMLDQtYouG4/ok08nRjNU6yhx05tx0bFWMgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735593784; c=relaxed/simple;
	bh=die2DZgYZ9NSeaTM6jhGLtEP5xC4z0IyKB3oWbjLr3s=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=j0gA8ra6ei02foVDaIlGWmQzQHLHtUpbb81nokY+Pj3FrAMcMj8i8cwxJtpmlwnDp83JA/UrMK/cw5kXFwoyHZA3kfI4ZngJzoRJVLRC5LAS14yssA5qf96GYHjl88IQzgSiL9Qm2xnnx+ipkXb4JMCEe1iUkF5GvY6ZTuTLY9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=vzlaqUYM; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2156e078563so109296885ad.2
        for <io-uring@vger.kernel.org>; Mon, 30 Dec 2024 13:23:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1735593781; x=1736198581; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5DPnFKdTIRxY2s1CtHEqx5jcr8Sa9jUMpG6ZpJelnPc=;
        b=vzlaqUYMBgeMNVoKqfwogvHTBG/MtcW02/5f99wngEDoqgJGQx7dU0m+5Wsj12c5YF
         cFHru0nLmNvAC1u3GaBo8IGIs/8cimhmQkY7gUOJ44XhnGPNU12Dw2akLAFZD6UTqiin
         mqrIofVuJyczJlNBGr+EAx0HOFvsQVlXImWsN5f3mptIG0p3jgHshEdEt42GXwsPwlaq
         s26Ig7p7+ETbH8xgcRV15kd2e9HQn1RwbE/mmlpqY53AQ4eXW6rEFRbNcuJhdx62PYAk
         pWYuKRxUqhNlXspqOxBTV6LMMOirlBHoCStPYkZo4du8BIh6V/12cZ+E3rC3szUhNwuu
         /6fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735593781; x=1736198581;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=5DPnFKdTIRxY2s1CtHEqx5jcr8Sa9jUMpG6ZpJelnPc=;
        b=sxYIOST90PAJ/adLHirJeH1aPlymSg1DLafeFbERyAifRabeLtRGNMZg8+476DffnV
         s0NGUjZcpnbVjGdy3U7imzRq/oOBb//Qz3R4uph+GM2QSn/phJL41oArvvEhxgEU2AHo
         W2KSH6Yb4v7LGLplN3IMTrQMgVCWTntcmMR7JYv7l2IpHzjfxPln07fXDOvpDpxlfdPA
         kcR9fLjkguChKsjyaR/vvuavGqxGW2AmDNAhJmZpdgGFtXISh+vCgnuLSdocDrCC2v6v
         lucgYMK8GA/dWHG6Kh6Sr9X3m6I0/TwByUX93yCl84C9ZMReU/4V675e8sQA/FoCq9qb
         iqYA==
X-Gm-Message-State: AOJu0YyEsu2+dCsGfdlWBATt5bNQd0OBF8yRkm6Lm93PTpAc2YDM9o7k
	JU6oJH6xQ4oApoVzr38+hJRNKKhc4d66nwVXXYzbX1RkfkK1+UmB+S/QNmtZTXfJWb87daGRJej
	u
X-Gm-Gg: ASbGnctV2qCjSFspKjW8lETWsoSPFCiRFlcrwppUQvmz+43GnYBCMQmzhJ3M40miowk
	1853gS++JK+6CC5u4IUUekPOAsoAfqSU3Cu5Wgqj1Ot0I4tjSOkFpD3tcWVpVeQ5sMXQgEeuMIB
	/CW927REONW9iBvunJAAPWp0LfKMdbIcJdOXY0yYTNdCzrivQDI3VMdTws/Dt4usjJwzqmPwlZH
	4sWLAR4p/oD7D58U8MMnFZM8Oh9afOfjRy3mS7NCwPHGCje06+SEQ==
X-Google-Smtp-Source: AGHT+IENqyQ5H4NP5LYPKEmfojCAN0bdeK449ecbstNWrNFAXklZIL7AU+dyQUMKJ4dFyPIjwzfwlA==
X-Received: by 2002:a05:6a00:a908:b0:72a:bcc2:eefb with SMTP id d2e1a72fcca58-72abdd502bcmr53884631b3a.2.1735593781101;
        Mon, 30 Dec 2024 13:23:01 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-842e35d4becsm15106006a12.79.2024.12.30.13.23.00
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Dec 2024 13:23:00 -0800 (PST)
Message-ID: <2e5c09cf-b884-4727-943a-bfe9d2826de3@kernel.dk>
Date: Mon, 30 Dec 2024 14:22:59 -0700
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
Subject: [PATCH] io_uring/timeout: flush timeouts outside of the timeout lock
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

syzbot reports that a recent fix causes nesting issues between the (now)
raw timeoutlock and the eventfd locking:

=============================
[ BUG: Invalid wait context ]
6.13.0-rc4-00080-g9828a4c0901f #29 Not tainted
-----------------------------
kworker/u32:0/68094 is trying to lock:
ffff000014d7a520 (&ctx->wqh#2){..-.}-{3:3}, at: eventfd_signal_mask+0x64/0x180
other info that might help us debug this:
context-{5:5}
6 locks held by kworker/u32:0/68094:
 #0: ffff0000c1d98148 ((wq_completion)iou_exit){+.+.}-{0:0}, at: process_one_work+0x4e8/0xfc0
 #1: ffff80008d927c78 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x53c/0xfc0
 #2: ffff0000c59bc3d8 (&ctx->completion_lock){+.+.}-{3:3}, at: io_kill_timeouts+0x40/0x180
 #3: ffff0000c59bc358 (&ctx->timeout_lock){-.-.}-{2:2}, at: io_kill_timeouts+0x48/0x180
 #4: ffff800085127aa0 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire+0x8/0x38
 #5: ffff800085127aa0 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire+0x8/0x38
stack backtrace:
CPU: 7 UID: 0 PID: 68094 Comm: kworker/u32:0 Not tainted 6.13.0-rc4-00080-g9828a4c0901f #29
Hardware name: linux,dummy-virt (DT)
Workqueue: iou_exit io_ring_exit_work
Call trace:
 show_stack+0x1c/0x30 (C)
 __dump_stack+0x24/0x30
 dump_stack_lvl+0x60/0x80
 dump_stack+0x14/0x20
 __lock_acquire+0x19f8/0x60c8
 lock_acquire+0x1a4/0x540
 _raw_spin_lock_irqsave+0x90/0xd0
 eventfd_signal_mask+0x64/0x180
 io_eventfd_signal+0x64/0x108
 io_req_local_work_add+0x294/0x430
 __io_req_task_work_add+0x1c0/0x270
 io_kill_timeout+0x1f0/0x288
 io_kill_timeouts+0xd4/0x180
 io_uring_try_cancel_requests+0x2e8/0x388
 io_ring_exit_work+0x150/0x550
 process_one_work+0x5e8/0xfc0
 worker_thread+0x7ec/0xc80
 kthread+0x24c/0x300
 ret_from_fork+0x10/0x20

because after the preempt-rt fix for the timeout lock nesting inside
the io-wq lock, we now have the eventfd spinlock nesting inside the
raw timeout spinlock.

Rather than play whack-a-mole with other nesting on the timeout lock,
split the deletion and killing of timeouts so queueing the task_work
for the timeout cancelations can get done outside of the timeout lock.

Reported-by: syzbot+b1fc199a40b65d601b65@syzkaller.appspotmail.com
Fixes: 020b40f35624 ("io_uring: make ctx->timeout_lock a raw spinlock")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/timeout.c b/io_uring/timeout.c
index bbe58638eca7..362689b17ccc 100644
--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -85,7 +85,27 @@ static void io_timeout_complete(struct io_kiocb *req, struct io_tw_state *ts)
 	io_req_task_complete(req, ts);
 }
 
-static bool io_kill_timeout(struct io_kiocb *req, int status)
+static __cold bool io_flush_killed_timeouts(struct list_head *list, int err)
+{
+	if (list_empty(list))
+		return false;
+
+	while (!list_empty(list)) {
+		struct io_timeout *timeout;
+		struct io_kiocb *req;
+
+		timeout = list_first_entry(list, struct io_timeout, list);
+		list_del_init(&timeout->list);
+		req = cmd_to_io_kiocb(timeout);
+		if (err)
+			req_set_fail(req);
+		io_req_queue_tw_complete(req, err);
+	}
+
+	return true;
+}
+
+static void io_kill_timeout(struct io_kiocb *req, struct list_head *list)
 	__must_hold(&req->ctx->timeout_lock)
 {
 	struct io_timeout_data *io = req->async_data;
@@ -93,21 +113,17 @@ static bool io_kill_timeout(struct io_kiocb *req, int status)
 	if (hrtimer_try_to_cancel(&io->timer) != -1) {
 		struct io_timeout *timeout = io_kiocb_to_cmd(req, struct io_timeout);
 
-		if (status)
-			req_set_fail(req);
 		atomic_set(&req->ctx->cq_timeouts,
 			atomic_read(&req->ctx->cq_timeouts) + 1);
-		list_del_init(&timeout->list);
-		io_req_queue_tw_complete(req, status);
-		return true;
+		list_move_tail(&timeout->list, list);
 	}
-	return false;
 }
 
 __cold void io_flush_timeouts(struct io_ring_ctx *ctx)
 {
-	u32 seq;
 	struct io_timeout *timeout, *tmp;
+	LIST_HEAD(list);
+	u32 seq;
 
 	raw_spin_lock_irq(&ctx->timeout_lock);
 	seq = ctx->cached_cq_tail - atomic_read(&ctx->cq_timeouts);
@@ -131,10 +147,11 @@ __cold void io_flush_timeouts(struct io_ring_ctx *ctx)
 		if (events_got < events_needed)
 			break;
 
-		io_kill_timeout(req, 0);
+		io_kill_timeout(req, &list);
 	}
 	ctx->cq_last_tm_flush = seq;
 	raw_spin_unlock_irq(&ctx->timeout_lock);
+	io_flush_killed_timeouts(&list, 0);
 }
 
 static void io_req_tw_fail_links(struct io_kiocb *link, struct io_tw_state *ts)
@@ -661,7 +678,7 @@ __cold bool io_kill_timeouts(struct io_ring_ctx *ctx, struct io_uring_task *tctx
 			     bool cancel_all)
 {
 	struct io_timeout *timeout, *tmp;
-	int canceled = 0;
+	LIST_HEAD(list);
 
 	/*
 	 * completion_lock is needed for io_match_task(). Take it before
@@ -672,11 +689,11 @@ __cold bool io_kill_timeouts(struct io_ring_ctx *ctx, struct io_uring_task *tctx
 	list_for_each_entry_safe(timeout, tmp, &ctx->timeout_list, list) {
 		struct io_kiocb *req = cmd_to_io_kiocb(timeout);
 
-		if (io_match_task(req, tctx, cancel_all) &&
-		    io_kill_timeout(req, -ECANCELED))
-			canceled++;
+		if (io_match_task(req, tctx, cancel_all))
+			io_kill_timeout(req, &list);
 	}
 	raw_spin_unlock_irq(&ctx->timeout_lock);
 	spin_unlock(&ctx->completion_lock);
-	return canceled != 0;
+
+	return io_flush_killed_timeouts(&list, -ECANCELED);
 }

-- 
Jens Axboe


