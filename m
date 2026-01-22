Return-Path: <io-uring+bounces-11886-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cGyZNIhccml7jAAAu9opvQ
	(envelope-from <io-uring+bounces-11886-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 22 Jan 2026 18:21:12 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C6ED6B1C3
	for <lists+io-uring@lfdr.de>; Thu, 22 Jan 2026 18:21:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 47B9B32F7861
	for <lists+io-uring@lfdr.de>; Thu, 22 Jan 2026 16:44:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4995F3E461C;
	Thu, 22 Jan 2026 16:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="mtDrseSQ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f53.google.com (mail-oa1-f53.google.com [209.85.160.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 765A03EB20D
	for <io-uring@vger.kernel.org>; Thu, 22 Jan 2026 16:24:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769099083; cv=none; b=DbQ5T0TIkTah6JkQx2m/b8vWva08koekt+kKGIg8Jma2mejlIH169v9EHrmRIqqlOZivSIEURuOa4MCFRSyuFP73N2cIkmHdgWDPM+dwOm8D9oVGBgIwisk11b5cMLtDUQ7B+CIG36lHM0nIzDtERECACmhZgAzXo2k5jQ8eh6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769099083; c=relaxed/simple;
	bh=P4AXoDOvzNzxMKIIAM+KUBOn0DrN2CdgffuLbYimrZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EwANsYNzZuvToWQQTKiW3gXpQ8PY1ifBKCHJPBfwXkRScO9HBeEqzMHVupWDUQuQ/8lKbuvWM0CH0PPbxTNOjkoucJ+MmqTOAr4YH3C43pTzb5xXBgayKurZmQ/zvup9W5R5lTLXIHkWUWCyK97A34dtAQL8iOWV9UKSUqF7WJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=mtDrseSQ; arc=none smtp.client-ip=209.85.160.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-4043bcd09f2so439426fac.3
        for <io-uring@vger.kernel.org>; Thu, 22 Jan 2026 08:24:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1769099071; x=1769703871; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vFRkhLJp3y4Ff3FOD7aa1mcoC5KgmwMeHNrndkdXuRk=;
        b=mtDrseSQgA8FwED47E8/5IX+dvPUBL5K5d7Jaxsc3BHJGlVwG6lQJhSq881d5/jM1q
         D6T6WMbmWfxae7j08pcu9YJVvo5aXlPA51nkGd4ndhFtPN6ixUohBor+NDM99BpFngAq
         za+mBMOtneR4XBMo46KMIfLiarh5ELmpu3PI+OO0fOPrc4kwc0CwOAD0KvjRvUJyb83Y
         khZ3qlY3MN71IJ9Qr2v/2lVnZge+sBkx3/jz43CYw6ga5C6vXCJq+nmILfcQm7fTyzVA
         4YXTrYpRsALR0IRfItcGXihen237R8xgQtBsPOGTTzT/7y2z6Oe0ea2Og7OlPt/ygM3J
         b6Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769099071; x=1769703871;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vFRkhLJp3y4Ff3FOD7aa1mcoC5KgmwMeHNrndkdXuRk=;
        b=MbchEG/V+bzPG1/fdfbp/YNJEY4Ad1f6YmeeejxVXH6dFRED4AArVqj0H7JU+Qf8Zs
         Vcf47z/PziPN8y2h5xg35+A5VJJ57hZ2WlH+dT5BEdzfRIAXX+zxdkLvXpmwaWBCus9V
         9HnTDfPamKZudEobRa5U8nS/fb68s8vq9UoQOOV3RS4pZ3JI4mcrznN2lySFZvm9dlmj
         Cj9m6Wi2chNNhZIIpBko7EYSsm4ZWBujHkUGLPXQpvgFkh5j4rtMH10YjE/18fX3/V3H
         Jmkmzcxk8Xzo9yX0NJ72gfciXH04um8RpaZzSB7jBvjATN56Jz0Rb58E2TkTLwSGZ6tM
         5bYw==
X-Gm-Message-State: AOJu0Yzpi1EJBOxc/JhjfG1fyWYOAPlnOMn2wAcxq8SXjyJnv/ijneuU
	fAeTuION+Nqxl7wmkQFSkNp05tczqTad6YKOen2VTkZe/2vi4sBwiyX30IZM67GpBO5SpwC6DL7
	zqODMIXo=
X-Gm-Gg: AZuq6aJLcqH9Sy0WdcxxUMsm39wcbIos+V3FKNIBzZa8bJ7dk724kW+oKtXGzxnDTFM
	y7yaivqSGK1+9oFL/CZ+Ae8cHegFcVUZNM2rb15yNkRelhtyzFj4u6y3rszEV7Mp7OIzZs9rYDu
	oWoOzHv94z7yyAkSuGjN9PFIxGXdtFZv7y/Hh8P7S5OO/JWy0KlJa/dwmK9s/uCArkvyYBklje3
	bRnsptBGjRaLRw8/0W+d5kIiHsRyCZCu5f2gCAYmqOt713FJkxxMR/W8z+hLa/wxO0I8v68wyq0
	2va+bCz7+Lf8wU2CJEQYdjO2VpIzXhj8g/fElBNpw77Ei0dMXcAsWzXhSfE3qwymqU60WuFmCh4
	fVacxkDc2dMI/PemT3tWxWFknHFcKlq6D2Gg6UycWWsGoLrQRwssEy/d1Zpba0m2kXWddbQISrw
	WcJpyE71e78Ls+Vq4JTCnG5nmnmYBv3WsT3x52XLvcS4xho51vRGXREwI=
X-Received: by 2002:a05:6870:8314:b0:3e8:9bbb:36b7 with SMTP id 586e51a60fabf-408ab50bf89mr47241fac.22.1769099070646;
        Thu, 22 Jan 2026 08:24:30 -0800 (PST)
Received: from m2max ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4044bd14883sm13408105fac.12.2026.01.22.08.24.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jan 2026 08:24:29 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/2] io_uring: split out CQ waiting code into wait.c
Date: Thu, 22 Jan 2026 09:21:52 -0700
Message-ID: <20260122162424.353513-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260122162424.353513-1-axboe@kernel.dk>
References: <20260122162424.353513-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_TLS_LAST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-11886-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	NEURAL_HAM(-0.00)[-0.988];
	RCVD_COUNT_FIVE(0.00)[5];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel.dk:mid,kernel.dk:email,kernel-dk.20230601.gappssmtp.com:dkim]
X-Rspamd-Queue-Id: 1C6ED6B1C3
X-Rspamd-Action: no action

Move the completion queue waiting and scheduling code out of io_uring.c
into a dedicated wait.c file. This further removes code out of the
main io_uring C and header file, and into a topical new file.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/Makefile   |  13 +-
 io_uring/cancel.c   |   1 +
 io_uring/io_uring.c | 322 +-------------------------------------------
 io_uring/tw.c       |   1 +
 io_uring/tw.h       |   8 --
 io_uring/wait.c     | 308 ++++++++++++++++++++++++++++++++++++++++++
 io_uring/wait.h     |  49 +++++++
 7 files changed, 368 insertions(+), 334 deletions(-)
 create mode 100644 io_uring/wait.c
 create mode 100644 io_uring/wait.h

diff --git a/io_uring/Makefile b/io_uring/Makefile
index b7ea66a9fcfc..bf9eff88427a 100644
--- a/io_uring/Makefile
+++ b/io_uring/Makefile
@@ -8,12 +8,13 @@ endif
 
 obj-$(CONFIG_IO_URING)		+= io_uring.o opdef.o kbuf.o rsrc.o notif.o \
 					tctx.o filetable.o rw.o poll.o \
-					tw.o eventfd.o uring_cmd.o openclose.o \
-					sqpoll.o xattr.o nop.o fs.o splice.o \
-					sync.o msg_ring.o advise.o openclose.o \
-					statx.o timeout.o cancel.o \
-					waitid.o register.o truncate.o \
-					memmap.o alloc_cache.o query.o
+					tw.o wait.o eventfd.o uring_cmd.o \
+					openclose.o sqpoll.o xattr.o nop.o \
+					fs.o splice.o sync.o msg_ring.o \
+					advise.o openclose.o statx.o timeout.o \
+					cancel.o waitid.o register.o \
+					truncate.o memmap.o alloc_cache.o \
+					query.o
 
 obj-$(CONFIG_IO_URING_ZCRX)	+= zcrx.o
 obj-$(CONFIG_IO_WQ)		+= io-wq.o
diff --git a/io_uring/cancel.c b/io_uring/cancel.c
index 76c657a28fe7..653be6152a6f 100644
--- a/io_uring/cancel.c
+++ b/io_uring/cancel.c
@@ -19,6 +19,7 @@
 #include "waitid.h"
 #include "futex.h"
 #include "cancel.h"
+#include "wait.h"
 
 struct io_cancel {
 	struct file			*file;
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index f9b716c819d1..a50459238bee 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -93,6 +93,7 @@
 #include "rw.h"
 #include "alloc_cache.h"
 #include "eventfd.h"
+#include "wait.h"
 
 #define SQE_COMMON_FLAGS (IOSQE_FIXED_FILE | IOSQE_IO_LINK | \
 			  IOSQE_IO_HARDLINK | IOSQE_ASYNC)
@@ -166,16 +167,6 @@ static void io_poison_req(struct io_kiocb *req)
 	req->link = IO_URING_PTR_POISON;
 }
 
-static inline unsigned int __io_cqring_events(struct io_ring_ctx *ctx)
-{
-	return ctx->cached_cq_tail - READ_ONCE(ctx->rings->cq.head);
-}
-
-static inline unsigned int __io_cqring_events_user(struct io_ring_ctx *ctx)
-{
-	return READ_ONCE(ctx->rings->cq.tail) - READ_ONCE(ctx->rings->cq.head);
-}
-
 static inline void req_fail_link_node(struct io_kiocb *req, int res)
 {
 	req_set_fail(req);
@@ -589,7 +580,7 @@ static void io_cqring_overflow_kill(struct io_ring_ctx *ctx)
 		__io_cqring_overflow_flush(ctx, true);
 }
 
-static void io_cqring_do_overflow_flush(struct io_ring_ctx *ctx)
+void io_cqring_do_overflow_flush(struct io_ring_ctx *ctx)
 {
 	mutex_lock(&ctx->uring_lock);
 	__io_cqring_overflow_flush(ctx, false);
@@ -1161,13 +1152,6 @@ void __io_submit_flush_completions(struct io_ring_ctx *ctx)
 	ctx->submit_state.cq_flush = false;
 }
 
-static unsigned io_cqring_events(struct io_ring_ctx *ctx)
-{
-	/* See comment at the top of this file */
-	smp_rmb();
-	return __io_cqring_events(ctx);
-}
-
 /*
  * We can't just wait for polled events to come to us, we have to actively
  * find and complete them.
@@ -2060,308 +2044,6 @@ int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 	return ret;
 }
 
-static int io_wake_function(struct wait_queue_entry *curr, unsigned int mode,
-			    int wake_flags, void *key)
-{
-	struct io_wait_queue *iowq = container_of(curr, struct io_wait_queue, wq);
-
-	/*
-	 * Cannot safely flush overflowed CQEs from here, ensure we wake up
-	 * the task, and the next invocation will do it.
-	 */
-	if (io_should_wake(iowq) || io_has_work(iowq->ctx))
-		return autoremove_wake_function(curr, mode, wake_flags, key);
-	return -1;
-}
-
-int io_run_task_work_sig(struct io_ring_ctx *ctx)
-{
-	if (io_local_work_pending(ctx)) {
-		__set_current_state(TASK_RUNNING);
-		if (io_run_local_work(ctx, INT_MAX, IO_LOCAL_TW_DEFAULT_MAX) > 0)
-			return 0;
-	}
-	if (io_run_task_work() > 0)
-		return 0;
-	if (task_sigpending(current))
-		return -EINTR;
-	return 0;
-}
-
-static bool current_pending_io(void)
-{
-	struct io_uring_task *tctx = current->io_uring;
-
-	if (!tctx)
-		return false;
-	return percpu_counter_read_positive(&tctx->inflight);
-}
-
-static enum hrtimer_restart io_cqring_timer_wakeup(struct hrtimer *timer)
-{
-	struct io_wait_queue *iowq = container_of(timer, struct io_wait_queue, t);
-
-	WRITE_ONCE(iowq->hit_timeout, 1);
-	iowq->min_timeout = 0;
-	wake_up_process(iowq->wq.private);
-	return HRTIMER_NORESTART;
-}
-
-/*
- * Doing min_timeout portion. If we saw any timeouts, events, or have work,
- * wake up. If not, and we have a normal timeout, switch to that and keep
- * sleeping.
- */
-static enum hrtimer_restart io_cqring_min_timer_wakeup(struct hrtimer *timer)
-{
-	struct io_wait_queue *iowq = container_of(timer, struct io_wait_queue, t);
-	struct io_ring_ctx *ctx = iowq->ctx;
-
-	/* no general timeout, or shorter (or equal), we are done */
-	if (iowq->timeout == KTIME_MAX ||
-	    ktime_compare(iowq->min_timeout, iowq->timeout) >= 0)
-		goto out_wake;
-	/* work we may need to run, wake function will see if we need to wake */
-	if (io_has_work(ctx))
-		goto out_wake;
-	/* got events since we started waiting, min timeout is done */
-	if (iowq->cq_min_tail != READ_ONCE(ctx->rings->cq.tail))
-		goto out_wake;
-	/* if we have any events and min timeout expired, we're done */
-	if (io_cqring_events(ctx))
-		goto out_wake;
-
-	/*
-	 * If using deferred task_work running and application is waiting on
-	 * more than one request, ensure we reset it now where we are switching
-	 * to normal sleeps. Any request completion post min_wait should wake
-	 * the task and return.
-	 */
-	if (ctx->flags & IORING_SETUP_DEFER_TASKRUN) {
-		atomic_set(&ctx->cq_wait_nr, 1);
-		smp_mb();
-		if (!llist_empty(&ctx->work_llist))
-			goto out_wake;
-	}
-
-	/* any generated CQE posted past this time should wake us up */
-	iowq->cq_tail = iowq->cq_min_tail;
-
-	hrtimer_update_function(&iowq->t, io_cqring_timer_wakeup);
-	hrtimer_set_expires(timer, iowq->timeout);
-	return HRTIMER_RESTART;
-out_wake:
-	return io_cqring_timer_wakeup(timer);
-}
-
-static int io_cqring_schedule_timeout(struct io_wait_queue *iowq,
-				      clockid_t clock_id, ktime_t start_time)
-{
-	ktime_t timeout;
-
-	if (iowq->min_timeout) {
-		timeout = ktime_add_ns(iowq->min_timeout, start_time);
-		hrtimer_setup_on_stack(&iowq->t, io_cqring_min_timer_wakeup, clock_id,
-				       HRTIMER_MODE_ABS);
-	} else {
-		timeout = iowq->timeout;
-		hrtimer_setup_on_stack(&iowq->t, io_cqring_timer_wakeup, clock_id,
-				       HRTIMER_MODE_ABS);
-	}
-
-	hrtimer_set_expires_range_ns(&iowq->t, timeout, 0);
-	hrtimer_start_expires(&iowq->t, HRTIMER_MODE_ABS);
-
-	if (!READ_ONCE(iowq->hit_timeout))
-		schedule();
-
-	hrtimer_cancel(&iowq->t);
-	destroy_hrtimer_on_stack(&iowq->t);
-	__set_current_state(TASK_RUNNING);
-
-	return READ_ONCE(iowq->hit_timeout) ? -ETIME : 0;
-}
-
-struct ext_arg {
-	size_t argsz;
-	struct timespec64 ts;
-	const sigset_t __user *sig;
-	ktime_t min_time;
-	bool ts_set;
-	bool iowait;
-};
-
-static int __io_cqring_wait_schedule(struct io_ring_ctx *ctx,
-				     struct io_wait_queue *iowq,
-				     struct ext_arg *ext_arg,
-				     ktime_t start_time)
-{
-	int ret = 0;
-
-	/*
-	 * Mark us as being in io_wait if we have pending requests, so cpufreq
-	 * can take into account that the task is waiting for IO - turns out
-	 * to be important for low QD IO.
-	 */
-	if (ext_arg->iowait && current_pending_io())
-		current->in_iowait = 1;
-	if (iowq->timeout != KTIME_MAX || iowq->min_timeout)
-		ret = io_cqring_schedule_timeout(iowq, ctx->clockid, start_time);
-	else
-		schedule();
-	current->in_iowait = 0;
-	return ret;
-}
-
-/* If this returns > 0, the caller should retry */
-static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
-					  struct io_wait_queue *iowq,
-					  struct ext_arg *ext_arg,
-					  ktime_t start_time)
-{
-	if (unlikely(READ_ONCE(ctx->check_cq)))
-		return 1;
-	if (unlikely(io_local_work_pending(ctx)))
-		return 1;
-	if (unlikely(task_work_pending(current)))
-		return 1;
-	if (unlikely(task_sigpending(current)))
-		return -EINTR;
-	if (unlikely(io_should_wake(iowq)))
-		return 0;
-
-	return __io_cqring_wait_schedule(ctx, iowq, ext_arg, start_time);
-}
-
-/*
- * Wait until events become available, if we don't already have some. The
- * application must reap them itself, as they reside on the shared cq ring.
- */
-static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events, u32 flags,
-			  struct ext_arg *ext_arg)
-{
-	struct io_wait_queue iowq;
-	struct io_rings *rings = ctx->rings;
-	ktime_t start_time;
-	int ret;
-
-	min_events = min_t(int, min_events, ctx->cq_entries);
-
-	if (!io_allowed_run_tw(ctx))
-		return -EEXIST;
-	if (io_local_work_pending(ctx))
-		io_run_local_work(ctx, min_events,
-				  max(IO_LOCAL_TW_DEFAULT_MAX, min_events));
-	io_run_task_work();
-
-	if (unlikely(test_bit(IO_CHECK_CQ_OVERFLOW_BIT, &ctx->check_cq)))
-		io_cqring_do_overflow_flush(ctx);
-	if (__io_cqring_events_user(ctx) >= min_events)
-		return 0;
-
-	init_waitqueue_func_entry(&iowq.wq, io_wake_function);
-	iowq.wq.private = current;
-	INIT_LIST_HEAD(&iowq.wq.entry);
-	iowq.ctx = ctx;
-	iowq.cq_tail = READ_ONCE(ctx->rings->cq.head) + min_events;
-	iowq.cq_min_tail = READ_ONCE(ctx->rings->cq.tail);
-	iowq.nr_timeouts = atomic_read(&ctx->cq_timeouts);
-	iowq.hit_timeout = 0;
-	iowq.min_timeout = ext_arg->min_time;
-	iowq.timeout = KTIME_MAX;
-	start_time = io_get_time(ctx);
-
-	if (ext_arg->ts_set) {
-		iowq.timeout = timespec64_to_ktime(ext_arg->ts);
-		if (!(flags & IORING_ENTER_ABS_TIMER))
-			iowq.timeout = ktime_add(iowq.timeout, start_time);
-	}
-
-	if (ext_arg->sig) {
-#ifdef CONFIG_COMPAT
-		if (in_compat_syscall())
-			ret = set_compat_user_sigmask((const compat_sigset_t __user *)ext_arg->sig,
-						      ext_arg->argsz);
-		else
-#endif
-			ret = set_user_sigmask(ext_arg->sig, ext_arg->argsz);
-
-		if (ret)
-			return ret;
-	}
-
-	io_napi_busy_loop(ctx, &iowq);
-
-	trace_io_uring_cqring_wait(ctx, min_events);
-	do {
-		unsigned long check_cq;
-		int nr_wait;
-
-		/* if min timeout has been hit, don't reset wait count */
-		if (!iowq.hit_timeout)
-			nr_wait = (int) iowq.cq_tail -
-					READ_ONCE(ctx->rings->cq.tail);
-		else
-			nr_wait = 1;
-
-		if (ctx->flags & IORING_SETUP_DEFER_TASKRUN) {
-			atomic_set(&ctx->cq_wait_nr, nr_wait);
-			set_current_state(TASK_INTERRUPTIBLE);
-		} else {
-			prepare_to_wait_exclusive(&ctx->cq_wait, &iowq.wq,
-							TASK_INTERRUPTIBLE);
-		}
-
-		ret = io_cqring_wait_schedule(ctx, &iowq, ext_arg, start_time);
-		__set_current_state(TASK_RUNNING);
-		atomic_set(&ctx->cq_wait_nr, IO_CQ_WAKE_INIT);
-
-		/*
-		 * Run task_work after scheduling and before io_should_wake().
-		 * If we got woken because of task_work being processed, run it
-		 * now rather than let the caller do another wait loop.
-		 */
-		if (io_local_work_pending(ctx))
-			io_run_local_work(ctx, nr_wait, nr_wait);
-		io_run_task_work();
-
-		/*
-		 * Non-local task_work will be run on exit to userspace, but
-		 * if we're using DEFER_TASKRUN, then we could have waited
-		 * with a timeout for a number of requests. If the timeout
-		 * hits, we could have some requests ready to process. Ensure
-		 * this break is _after_ we have run task_work, to avoid
-		 * deferring running potentially pending requests until the
-		 * next time we wait for events.
-		 */
-		if (ret < 0)
-			break;
-
-		check_cq = READ_ONCE(ctx->check_cq);
-		if (unlikely(check_cq)) {
-			/* let the caller flush overflows, retry */
-			if (check_cq & BIT(IO_CHECK_CQ_OVERFLOW_BIT))
-				io_cqring_do_overflow_flush(ctx);
-			if (check_cq & BIT(IO_CHECK_CQ_DROPPED_BIT)) {
-				ret = -EBADR;
-				break;
-			}
-		}
-
-		if (io_should_wake(&iowq)) {
-			ret = 0;
-			break;
-		}
-		cond_resched();
-	} while (1);
-
-	if (!(ctx->flags & IORING_SETUP_DEFER_TASKRUN))
-		finish_wait(&ctx->cq_wait, &iowq.wq);
-	restore_saved_sigmask_unless(ret == -EINTR);
-
-	return READ_ONCE(rings->cq.head) == READ_ONCE(rings->cq.tail) ? ret : 0;
-}
-
 static void io_rings_free(struct io_ring_ctx *ctx)
 {
 	io_free_region(ctx->user, &ctx->sq_region);
diff --git a/io_uring/tw.c b/io_uring/tw.c
index f20ffc529040..1ee2b8ab07c8 100644
--- a/io_uring/tw.c
+++ b/io_uring/tw.c
@@ -13,6 +13,7 @@
 #include "poll.h"
 #include "rw.h"
 #include "eventfd.h"
+#include "wait.h"
 
 void io_fallback_req_func(struct work_struct *work)
 {
diff --git a/io_uring/tw.h b/io_uring/tw.h
index 8683efca58ef..415e330fabde 100644
--- a/io_uring/tw.h
+++ b/io_uring/tw.h
@@ -8,14 +8,6 @@
 
 #define IO_LOCAL_TW_DEFAULT_MAX		20
 
-/*
- * No waiters. It's larger than any valid value of the tw counter
- * so that tests against ->cq_wait_nr would fail and skip wake_up().
- */
-#define IO_CQ_WAKE_INIT		(-1U)
-/* Forced wake up if there is a waiter regardless of ->cq_wait_nr */
-#define IO_CQ_WAKE_FORCE	(IO_CQ_WAKE_INIT >> 1)
-
 /*
  * Terminate the request if either of these conditions are true:
  *
diff --git a/io_uring/wait.c b/io_uring/wait.c
new file mode 100644
index 000000000000..0581cadf20ee
--- /dev/null
+++ b/io_uring/wait.c
@@ -0,0 +1,308 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Waiting for completion events
+ */
+#include <linux/kernel.h>
+#include <linux/sched/signal.h>
+#include <linux/io_uring.h>
+
+#include <trace/events/io_uring.h>
+
+#include <uapi/linux/io_uring.h>
+
+#include "io_uring.h"
+#include "napi.h"
+#include "wait.h"
+
+static int io_wake_function(struct wait_queue_entry *curr, unsigned int mode,
+			    int wake_flags, void *key)
+{
+	struct io_wait_queue *iowq = container_of(curr, struct io_wait_queue, wq);
+
+	/*
+	 * Cannot safely flush overflowed CQEs from here, ensure we wake up
+	 * the task, and the next invocation will do it.
+	 */
+	if (io_should_wake(iowq) || io_has_work(iowq->ctx))
+		return autoremove_wake_function(curr, mode, wake_flags, key);
+	return -1;
+}
+
+int io_run_task_work_sig(struct io_ring_ctx *ctx)
+{
+	if (io_local_work_pending(ctx)) {
+		__set_current_state(TASK_RUNNING);
+		if (io_run_local_work(ctx, INT_MAX, IO_LOCAL_TW_DEFAULT_MAX) > 0)
+			return 0;
+	}
+	if (io_run_task_work() > 0)
+		return 0;
+	if (task_sigpending(current))
+		return -EINTR;
+	return 0;
+}
+
+static bool current_pending_io(void)
+{
+	struct io_uring_task *tctx = current->io_uring;
+
+	if (!tctx)
+		return false;
+	return percpu_counter_read_positive(&tctx->inflight);
+}
+
+static enum hrtimer_restart io_cqring_timer_wakeup(struct hrtimer *timer)
+{
+	struct io_wait_queue *iowq = container_of(timer, struct io_wait_queue, t);
+
+	WRITE_ONCE(iowq->hit_timeout, 1);
+	iowq->min_timeout = 0;
+	wake_up_process(iowq->wq.private);
+	return HRTIMER_NORESTART;
+}
+
+/*
+ * Doing min_timeout portion. If we saw any timeouts, events, or have work,
+ * wake up. If not, and we have a normal timeout, switch to that and keep
+ * sleeping.
+ */
+static enum hrtimer_restart io_cqring_min_timer_wakeup(struct hrtimer *timer)
+{
+	struct io_wait_queue *iowq = container_of(timer, struct io_wait_queue, t);
+	struct io_ring_ctx *ctx = iowq->ctx;
+
+	/* no general timeout, or shorter (or equal), we are done */
+	if (iowq->timeout == KTIME_MAX ||
+	    ktime_compare(iowq->min_timeout, iowq->timeout) >= 0)
+		goto out_wake;
+	/* work we may need to run, wake function will see if we need to wake */
+	if (io_has_work(ctx))
+		goto out_wake;
+	/* got events since we started waiting, min timeout is done */
+	if (iowq->cq_min_tail != READ_ONCE(ctx->rings->cq.tail))
+		goto out_wake;
+	/* if we have any events and min timeout expired, we're done */
+	if (io_cqring_events(ctx))
+		goto out_wake;
+
+	/*
+	 * If using deferred task_work running and application is waiting on
+	 * more than one request, ensure we reset it now where we are switching
+	 * to normal sleeps. Any request completion post min_wait should wake
+	 * the task and return.
+	 */
+	if (ctx->flags & IORING_SETUP_DEFER_TASKRUN) {
+		atomic_set(&ctx->cq_wait_nr, 1);
+		smp_mb();
+		if (!llist_empty(&ctx->work_llist))
+			goto out_wake;
+	}
+
+	/* any generated CQE posted past this time should wake us up */
+	iowq->cq_tail = iowq->cq_min_tail;
+
+	hrtimer_update_function(&iowq->t, io_cqring_timer_wakeup);
+	hrtimer_set_expires(timer, iowq->timeout);
+	return HRTIMER_RESTART;
+out_wake:
+	return io_cqring_timer_wakeup(timer);
+}
+
+static int io_cqring_schedule_timeout(struct io_wait_queue *iowq,
+				      clockid_t clock_id, ktime_t start_time)
+{
+	ktime_t timeout;
+
+	if (iowq->min_timeout) {
+		timeout = ktime_add_ns(iowq->min_timeout, start_time);
+		hrtimer_setup_on_stack(&iowq->t, io_cqring_min_timer_wakeup, clock_id,
+				       HRTIMER_MODE_ABS);
+	} else {
+		timeout = iowq->timeout;
+		hrtimer_setup_on_stack(&iowq->t, io_cqring_timer_wakeup, clock_id,
+				       HRTIMER_MODE_ABS);
+	}
+
+	hrtimer_set_expires_range_ns(&iowq->t, timeout, 0);
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
+static int __io_cqring_wait_schedule(struct io_ring_ctx *ctx,
+				     struct io_wait_queue *iowq,
+				     struct ext_arg *ext_arg,
+				     ktime_t start_time)
+{
+	int ret = 0;
+
+	/*
+	 * Mark us as being in io_wait if we have pending requests, so cpufreq
+	 * can take into account that the task is waiting for IO - turns out
+	 * to be important for low QD IO.
+	 */
+	if (ext_arg->iowait && current_pending_io())
+		current->in_iowait = 1;
+	if (iowq->timeout != KTIME_MAX || iowq->min_timeout)
+		ret = io_cqring_schedule_timeout(iowq, ctx->clockid, start_time);
+	else
+		schedule();
+	current->in_iowait = 0;
+	return ret;
+}
+
+/* If this returns > 0, the caller should retry */
+static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
+					  struct io_wait_queue *iowq,
+					  struct ext_arg *ext_arg,
+					  ktime_t start_time)
+{
+	if (unlikely(READ_ONCE(ctx->check_cq)))
+		return 1;
+	if (unlikely(io_local_work_pending(ctx)))
+		return 1;
+	if (unlikely(task_work_pending(current)))
+		return 1;
+	if (unlikely(task_sigpending(current)))
+		return -EINTR;
+	if (unlikely(io_should_wake(iowq)))
+		return 0;
+
+	return __io_cqring_wait_schedule(ctx, iowq, ext_arg, start_time);
+}
+
+/*
+ * Wait until events become available, if we don't already have some. The
+ * application must reap them itself, as they reside on the shared cq ring.
+ */
+int io_cqring_wait(struct io_ring_ctx *ctx, int min_events, u32 flags,
+		   struct ext_arg *ext_arg)
+{
+	struct io_wait_queue iowq;
+	struct io_rings *rings = ctx->rings;
+	ktime_t start_time;
+	int ret;
+
+	min_events = min_t(int, min_events, ctx->cq_entries);
+
+	if (!io_allowed_run_tw(ctx))
+		return -EEXIST;
+	if (io_local_work_pending(ctx))
+		io_run_local_work(ctx, min_events,
+				  max(IO_LOCAL_TW_DEFAULT_MAX, min_events));
+	io_run_task_work();
+
+	if (unlikely(test_bit(IO_CHECK_CQ_OVERFLOW_BIT, &ctx->check_cq)))
+		io_cqring_do_overflow_flush(ctx);
+	if (__io_cqring_events_user(ctx) >= min_events)
+		return 0;
+
+	init_waitqueue_func_entry(&iowq.wq, io_wake_function);
+	iowq.wq.private = current;
+	INIT_LIST_HEAD(&iowq.wq.entry);
+	iowq.ctx = ctx;
+	iowq.cq_tail = READ_ONCE(ctx->rings->cq.head) + min_events;
+	iowq.cq_min_tail = READ_ONCE(ctx->rings->cq.tail);
+	iowq.nr_timeouts = atomic_read(&ctx->cq_timeouts);
+	iowq.hit_timeout = 0;
+	iowq.min_timeout = ext_arg->min_time;
+	iowq.timeout = KTIME_MAX;
+	start_time = io_get_time(ctx);
+
+	if (ext_arg->ts_set) {
+		iowq.timeout = timespec64_to_ktime(ext_arg->ts);
+		if (!(flags & IORING_ENTER_ABS_TIMER))
+			iowq.timeout = ktime_add(iowq.timeout, start_time);
+	}
+
+	if (ext_arg->sig) {
+#ifdef CONFIG_COMPAT
+		if (in_compat_syscall())
+			ret = set_compat_user_sigmask((const compat_sigset_t __user *)ext_arg->sig,
+						      ext_arg->argsz);
+		else
+#endif
+			ret = set_user_sigmask(ext_arg->sig, ext_arg->argsz);
+
+		if (ret)
+			return ret;
+	}
+
+	io_napi_busy_loop(ctx, &iowq);
+
+	trace_io_uring_cqring_wait(ctx, min_events);
+	do {
+		unsigned long check_cq;
+		int nr_wait;
+
+		/* if min timeout has been hit, don't reset wait count */
+		if (!iowq.hit_timeout)
+			nr_wait = (int) iowq.cq_tail -
+					READ_ONCE(ctx->rings->cq.tail);
+		else
+			nr_wait = 1;
+
+		if (ctx->flags & IORING_SETUP_DEFER_TASKRUN) {
+			atomic_set(&ctx->cq_wait_nr, nr_wait);
+			set_current_state(TASK_INTERRUPTIBLE);
+		} else {
+			prepare_to_wait_exclusive(&ctx->cq_wait, &iowq.wq,
+							TASK_INTERRUPTIBLE);
+		}
+
+		ret = io_cqring_wait_schedule(ctx, &iowq, ext_arg, start_time);
+		__set_current_state(TASK_RUNNING);
+		atomic_set(&ctx->cq_wait_nr, IO_CQ_WAKE_INIT);
+
+		/*
+		 * Run task_work after scheduling and before io_should_wake().
+		 * If we got woken because of task_work being processed, run it
+		 * now rather than let the caller do another wait loop.
+		 */
+		if (io_local_work_pending(ctx))
+			io_run_local_work(ctx, nr_wait, nr_wait);
+		io_run_task_work();
+
+		/*
+		 * Non-local task_work will be run on exit to userspace, but
+		 * if we're using DEFER_TASKRUN, then we could have waited
+		 * with a timeout for a number of requests. If the timeout
+		 * hits, we could have some requests ready to process. Ensure
+		 * this break is _after_ we have run task_work, to avoid
+		 * deferring running potentially pending requests until the
+		 * next time we wait for events.
+		 */
+		if (ret < 0)
+			break;
+
+		check_cq = READ_ONCE(ctx->check_cq);
+		if (unlikely(check_cq)) {
+			/* let the caller flush overflows, retry */
+			if (check_cq & BIT(IO_CHECK_CQ_OVERFLOW_BIT))
+				io_cqring_do_overflow_flush(ctx);
+			if (check_cq & BIT(IO_CHECK_CQ_DROPPED_BIT)) {
+				ret = -EBADR;
+				break;
+			}
+		}
+
+		if (io_should_wake(&iowq)) {
+			ret = 0;
+			break;
+		}
+		cond_resched();
+	} while (1);
+
+	if (!(ctx->flags & IORING_SETUP_DEFER_TASKRUN))
+		finish_wait(&ctx->cq_wait, &iowq.wq);
+	restore_saved_sigmask_unless(ret == -EINTR);
+
+	return READ_ONCE(rings->cq.head) == READ_ONCE(rings->cq.tail) ? ret : 0;
+}
diff --git a/io_uring/wait.h b/io_uring/wait.h
new file mode 100644
index 000000000000..5e236f74e1af
--- /dev/null
+++ b/io_uring/wait.h
@@ -0,0 +1,49 @@
+// SPDX-License-Identifier: GPL-2.0
+#ifndef IOU_WAIT_H
+#define IOU_WAIT_H
+
+#include <linux/io_uring_types.h>
+
+/*
+ * No waiters. It's larger than any valid value of the tw counter
+ * so that tests against ->cq_wait_nr would fail and skip wake_up().
+ */
+#define IO_CQ_WAKE_INIT		(-1U)
+/* Forced wake up if there is a waiter regardless of ->cq_wait_nr */
+#define IO_CQ_WAKE_FORCE	(IO_CQ_WAKE_INIT >> 1)
+
+struct ext_arg {
+	size_t argsz;
+	struct timespec64 ts;
+	const sigset_t __user *sig;
+	ktime_t min_time;
+	bool ts_set;
+	bool iowait;
+};
+
+int io_cqring_wait(struct io_ring_ctx *ctx, int min_events, u32 flags,
+		   struct ext_arg *ext_arg);
+int io_run_task_work_sig(struct io_ring_ctx *ctx);
+void io_cqring_do_overflow_flush(struct io_ring_ctx *ctx);
+
+static inline unsigned int __io_cqring_events(struct io_ring_ctx *ctx)
+{
+	return ctx->cached_cq_tail - READ_ONCE(ctx->rings->cq.head);
+}
+
+static inline unsigned int __io_cqring_events_user(struct io_ring_ctx *ctx)
+{
+	return READ_ONCE(ctx->rings->cq.tail) - READ_ONCE(ctx->rings->cq.head);
+}
+
+/*
+ * Reads the tail/head of the CQ ring while providing an acquire ordering,
+ * see comment at top of io_uring.c.
+ */
+static inline unsigned io_cqring_events(struct io_ring_ctx *ctx)
+{
+	smp_rmb();
+	return __io_cqring_events(ctx);
+}
+
+#endif
-- 
2.51.0


