Return-Path: <io-uring+bounces-6791-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D079A463F8
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2025 16:02:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 63BAE3AFAA4
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2025 15:01:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1A1B19CD0B;
	Wed, 26 Feb 2025 15:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="Ozu8qxXD";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="0M7GPZf3"
X-Original-To: io-uring@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E04415278E;
	Wed, 26 Feb 2025 15:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740582121; cv=none; b=MTvuNSYpdXAkYjS2n6cqYPaDpmMMdVvJhboQMrAfhuKKscBTJVOgcs/D8fGoXWloT301lYOmgE09eoXvGCixtLQnoiE5vUjaOyfpPlg2SAt3XxQR+5IQqPf3Eg6fjj8iZEyQbte7X1+1LygS63Di+PtbzF2ZQSNAfGrkJmnHlqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740582121; c=relaxed/simple;
	bh=celbQI4md4Nw9NiTcdx99RF7CX7CNJgN/S3lD5ArXGI=;
	h=From:To:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=J26rD4/3UNZUrdD9uiMwvQQg87OCVdNqcZxisIc3fowrXTXqWpA5s4GDNCLxTXIq22AlKo9ngd1k+EHQwcucdCc9p9m4b0J5dTeB9AxTGeox/CIhi9Er8/iTGUdJsFW+q3q7VcZaa9UWPkvgKQr3SViAah0+p8WimKwlxDxbn0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=Ozu8qxXD; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=0M7GPZf3; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1740582118;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JWlX9TJLo6j7kLc4k/KFCY/zN5HPB61jkl2jDj8mI+4=;
	b=Ozu8qxXDgHlyYDgOIOrHxApCO4stPIj6JjjCbdNoJMzVCmA1zGPro86S1pXvvhGk4LmEp+
	XSAS0m/tKXYVxXvKNCKzcVgIaAsDdON/wFO9TqZAcULl8eVTLe2EGVkcdBaJgArIJ44m7W
	6gljhBtPvnu4o4uO0q1EiJjmm8icUBGiJK4O8CI3WiiS0sNXiq4ODv17LqBkayLOZwUKH6
	7aEtFQq3hx6bcyUKcXklxLJCsx8+FXzPHMrFO42mMAcRJrKyCOYlMVtUzrvr0dsWioWx9l
	B9diGFKhAsLety4R0kbJSGlw6SChnU0svqLjpEftN9Sq4ryHL3BGHUyBO7Vfdg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1740582118;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JWlX9TJLo6j7kLc4k/KFCY/zN5HPB61jkl2jDj8mI+4=;
	b=0M7GPZf3s+9CFrwhjsGBGwadoUM4Lp5OV+6AA7HjCpgMYRqYgK3FzTWHSJGxVnYD/I+QrS
	lqfT8G6EytwcmUCw==
To: syzbot <syzbot+e2b1803445d236442e54@syzkaller.appspotmail.com>,
 asml.silence@gmail.com, axboe@kernel.dk, bp@alien8.de,
 dave.hansen@linux.intel.com, hpa@zytor.com, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org, mingo@redhat.com,
 syzkaller-bugs@googlegroups.com, x86@kernel.org
Subject: [PATCH] x86/iopl: Cure TIF_IO_BITMAP inconsistencies
In-Reply-To: <67bead04.050a0220.38b081.0002.GAE@google.com>
References: <67bead04.050a0220.38b081.0002.GAE@google.com>
Date: Wed, 26 Feb 2025 16:01:57 +0100
Message-ID: <87wmdceom2.ffs@tglx>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

io_bitmap_exit() is invoked from exit_thread() when a task exists or
when a fork fails. In the latter case the exit_thread() cleans up
resources which were allocated during fork().

io_bitmap_exit() invokes task_update_io_bitmap(), which in turn ends up
in tss_update_io_bitmap(). tss_update_io_bitmap() operates on the
current task. If current has TIF_IO_BITMAP set, but no bitmap installed,
tss_update_io_bitmap() crashes with a NULL pointer dereference.

There are two issues, which lead to that problem:

  1) io_bitmap_exit() should not invoke task_update_io_bitmap() when
     the task, which is cleaned up, is not the current task. That's a
     clear indicator for a cleanup after a failed fork().

  2) A task should not have TIF_IO_BITMAP set and neither a bitmap
     installed nor IOPL emulation level 3 activated.

     This happens, when a kernel thread is created in the context of a
     user space thread, which has TIF_IO_BITMAP set as the thread flags
     are copied and the IO bitmap pointer is cleared.

     Other than in the failed fork() case this has no impact because
     kernel threads including IO workers never return to user space and
     therefore never invoke tss_update_io_bitmap().

Cure this by adding the missing cleanups and checks:

  1) Prevent io_bitmap_exit() to invoke task_update_io_bitmap() if
     the to be cleaned up task is not the current task.

  2) Clear TIF_IO_BITMAP in copy_thread() unconditionally. For user
     space forks it is set later, when the IO bitmap is inherited in
     io_bitmap_share().

For paranoia sake, add a warning into tss_update_io_bitmap() to catch
the case, when that code is invoked with inconsistent state.

Fixes: ea5f1cd7ab49 ("x86/ioperm: Remove bitmap if all permissions dropped")
Reported-by: syzbot+e2b1803445d236442e54@syzkaller.appspotmail.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
---

--- a/arch/x86/kernel/ioport.c
+++ b/arch/x86/kernel/ioport.c
@@ -33,8 +33,9 @@ void io_bitmap_share(struct task_struct
 	set_tsk_thread_flag(tsk, TIF_IO_BITMAP);
 }
 
-static void task_update_io_bitmap(struct task_struct *tsk)
+static void task_update_io_bitmap(void)
 {
+	struct task_struct *tsk = current;
 	struct thread_struct *t = &tsk->thread;
 
 	if (t->iopl_emul == 3 || t->io_bitmap) {
@@ -54,7 +55,12 @@ void io_bitmap_exit(struct task_struct *
 	struct io_bitmap *iobm = tsk->thread.io_bitmap;
 
 	tsk->thread.io_bitmap = NULL;
-	task_update_io_bitmap(tsk);
+	/*
+	 * Don't touch the TSS when invoked on a failed fork(). TSS
+	 * reflects the state of @current and not the state of @tsk.
+	 */
+	if (tsk == current)
+		task_update_io_bitmap();
 	if (iobm && refcount_dec_and_test(&iobm->refcnt))
 		kfree(iobm);
 }
@@ -192,8 +198,7 @@ SYSCALL_DEFINE1(iopl, unsigned int, leve
 	}
 
 	t->iopl_emul = level;
-	task_update_io_bitmap(current);
-
+	task_update_io_bitmap();
 	return 0;
 }
 
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -176,6 +176,7 @@ int copy_thread(struct task_struct *p, c
 	frame->ret_addr = (unsigned long) ret_from_fork_asm;
 	p->thread.sp = (unsigned long) fork_frame;
 	p->thread.io_bitmap = NULL;
+	clear_tsk_thread_flag(p, TIF_IO_BITMAP);
 	p->thread.iopl_warn = 0;
 	memset(p->thread.ptrace_bps, 0, sizeof(p->thread.ptrace_bps));
 
@@ -464,6 +465,11 @@ void native_tss_update_io_bitmap(void)
 	} else {
 		struct io_bitmap *iobm = t->io_bitmap;
 
+		if (WARN_ON_ONCE(!iobm)) {
+			clear_thread_flag(TIF_IO_BITMAP);
+			native_tss_invalidate_io_bitmap();
+		}
+
 		/*
 		 * Only copy bitmap data when the sequence number differs. The
 		 * update time is accounted to the incoming task.

