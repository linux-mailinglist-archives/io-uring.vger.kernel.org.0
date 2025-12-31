Return-Path: <io-uring+bounces-11347-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D51CBCEC2F4
	for <lists+io-uring@lfdr.de>; Wed, 31 Dec 2025 16:41:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id CC0C0300162A
	for <lists+io-uring@lfdr.de>; Wed, 31 Dec 2025 15:41:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62ABB1EB19B;
	Wed, 31 Dec 2025 15:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="WgNsJynl"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f53.google.com (mail-oa1-f53.google.com [209.85.160.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3D551925BC
	for <io-uring@vger.kernel.org>; Wed, 31 Dec 2025 15:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767195689; cv=none; b=TVKzYMJGt27FdJ6Ily+h95RJbnLx4NDyO34aePAoItjOl/cmyPzyTenIo7XDwN1NOIVn8YHe2678QTZFdG9Ji6lfiGY9RbSF39Tjrd9a7CHCC8SoLxXyjy8Iy0b6Da82QFmRMUSSTLSDXtHseUa/iSrFwwHurn/Euj0Py1QLCY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767195689; c=relaxed/simple;
	bh=7vmLHKGSo8/0JLIveYAs6mGUaQxATSUUbN6f1/rOtHo=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=DHWJ2UDTaO5fHLyLGzOJwChgE1XLNtDHfLYpc4Y0RYu5yO7e24tCi+p6N6Jr+QpbCv3bYmMAJ2r4ISEFmxE1+ujOAYaZD8jopFy3Bw0dhu+XXOce/FfGXMOQBOdMcmEktX+rqBqzCa7tjy0rmhIKUJZios5J2JWXzkFZeqzGIzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=WgNsJynl; arc=none smtp.client-ip=209.85.160.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-3f584ab62c6so4564708fac.1
        for <io-uring@vger.kernel.org>; Wed, 31 Dec 2025 07:41:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1767195684; x=1767800484; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LvizBz4ckv+Xw+fXiMeG0ijUI1LeyS0kWGPW3+SYB0I=;
        b=WgNsJynlkp2MCn9LwUNmjhyd1k4j9NaEfc26591kwfMQ9PZ82Q7XQa7wOtqqkDLzFr
         SHe7ycyddUl2Hn6D3BgVHUKRnslRCqFNLCy3F4x7R0Ys528DedFDwS8IHe2wSmrRpsZb
         S08hMGn/GQYCSN13vDXqv/eeL/azzNuesS62OM7yFfhPVLC7QDsEOnVE/TKka4SnrjMb
         ldaAK6GgmDLK+fEUYpxIWtJ94vRRuWURIVproFOuoMlrVh9mOBK2nGuGJ2gt+29a5gCJ
         WMbZgoDnUc3g6fSDZNbMzZOXq0FxV6n2+OvhpZtf+oDwvmG/2X/O4spWXHT+t6cUOBiu
         orog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767195684; x=1767800484;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LvizBz4ckv+Xw+fXiMeG0ijUI1LeyS0kWGPW3+SYB0I=;
        b=S3O/4rx1kl5Z49UjuGjpyieWMg7FySJydqndDk2BONCymiwX7NzM1u7+FWfrawazeW
         s+v+l/L+/LarrJxxTTtEXALo+zCbbsyhfIXqRO2RYpGUFbH3GUM2tp7OxG2K8OIMAJzp
         B+30RXb9y1cZAZQpfDvOSbQa4mRdRh6ybIKbMSGaHc/T+vPIP4COLEwArg9UCIVT3Vyv
         P18+G4SQxgYDDby9qrRenW2bIC1SnJDHHvBtRW3KRTi71i7DSoSLti9js+MD5Z12GpwE
         dPe6gvgP6Z6w9QZ2wcvV6uOO67KR/FhD0nddI8JkB+HJ5Pf+gpC0AU6SS30/89/6TMQs
         WrUA==
X-Gm-Message-State: AOJu0YyY9UmNh6fizjRRITuimJBOs12XYZgrv+fCWACvfeU9qnBloGUs
	5Jr+r7srfH4v0QaNOwAiDdRj+L3HsW453/kbWEkN+bLga8PeXdrYosyubiMQfnbk1Zq+XBdI+Fr
	nyKte
X-Gm-Gg: AY/fxX7DMjEKYsZsmj1nLOuylMn+cx1MpgOMkOd0LZL8Q/kCPHoVORM2iZzt0sEr98T
	Uz92R3Qoka6WsWn92acc96zu05fQbkjJSS5y/yZ2RaNK0cLjg/D0YuAXhzpFXMmzgBUaEBQLvtJ
	Y23fo57R8aeV6+ovAteKbeY2UiStWU4wTAFbOvgyS8pdty5PKs08balW4fi4nDM/KlSMa41f0zZ
	f7pgbvh/U/Fcwj+vwE3eoS5b+g36bzuQ1ufU8UlUQYbvojljsySQ53DmMoA8EF5iQrOfoWLYOi1
	jxccEDIKxJH1E6sDW6Xwd4tvwvrn7FkmO4kq5bA1gGWjkjvyt4qlCKrU5j8hNIVzdjTlf2H+Z/B
	qydGH4AAh2yFJ7LEdKt6mcPF7ZP79x7Fs2ie2B1Zkvo4zSOYD3qyS+rhok1wE1zR/J5aaKqNcdl
	WbNu1kElHm
X-Google-Smtp-Source: AGHT+IHyt+21j9erYnjsVVqChk8kGtnHj+2MD7NCoPpUI895HNUUXgMAGAg22yN2Wyml674oj6bKyg==
X-Received: by 2002:a05:6870:4411:b0:3e8:95d2:389d with SMTP id 586e51a60fabf-3fda589c70emr15961371fac.43.1767195683944;
        Wed, 31 Dec 2025 07:41:23 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-3fdaa8d366esm22416634fac.5.2025.12.31.07.41.22
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 Dec 2025 07:41:23 -0800 (PST)
Message-ID: <4cffd2b8-e7c9-48df-9207-0df6e3d5c6ce@kernel.dk>
Date: Wed, 31 Dec 2025 08:41:22 -0700
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
Subject: [PATCH] io_uring/tctx: add separate lock for list of tctx's in ctx
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

ctx->tcxt_list holds the tasks using this ring, and it's currently
protected by the normal ctx->uring_lock. However, this can cause a
circular locking issue, as reported by syzbot, where cancelations off
exec end up needing to remove an entry from this list:

======================================================
WARNING: possible circular locking dependency detected
syzkaller #0 Tainted: G             L
------------------------------------------------------
syz.0.9999/12287 is trying to acquire lock:
ffff88805851c0a8 (&ctx->uring_lock){+.+.}-{4:4}, at: io_uring_del_tctx_node+0xf0/0x2c0 io_uring/tctx.c:179

but task is already holding lock:
ffff88802db5a2e0 (&sig->cred_guard_mutex){+.+.}-{4:4}, at: prepare_bprm_creds fs/exec.c:1360 [inline]
ffff88802db5a2e0 (&sig->cred_guard_mutex){+.+.}-{4:4}, at: bprm_execve+0xb9/0x1400 fs/exec.c:1733

which lock already depends on the new lock.

the existing dependency chain (in reverse order) is:

-> #2 (&sig->cred_guard_mutex){+.+.}-{4:4}:
       __mutex_lock_common kernel/locking/mutex.c:614 [inline]
       __mutex_lock+0x187/0x1350 kernel/locking/mutex.c:776
       proc_pid_attr_write+0x547/0x630 fs/proc/base.c:2837
       vfs_write+0x27e/0xb30 fs/read_write.c:684
       ksys_write+0x145/0x250 fs/read_write.c:738
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0xec/0xf80 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #1 (sb_writers#3){.+.+}-{0:0}:
       percpu_down_read_internal include/linux/percpu-rwsem.h:53 [inline]
       percpu_down_read_freezable include/linux/percpu-rwsem.h:83 [inline]
       __sb_start_write include/linux/fs/super.h:19 [inline]
       sb_start_write+0x4d/0x1c0 include/linux/fs/super.h:125
       mnt_want_write+0x41/0x90 fs/namespace.c:499
       open_last_lookups fs/namei.c:4529 [inline]
       path_openat+0xadd/0x3dd0 fs/namei.c:4784
       do_filp_open+0x1fa/0x410 fs/namei.c:4814
       io_openat2+0x3e0/0x5c0 io_uring/openclose.c:143
       __io_issue_sqe+0x181/0x4b0 io_uring/io_uring.c:1792
       io_issue_sqe+0x165/0x1060 io_uring/io_uring.c:1815
       io_queue_sqe io_uring/io_uring.c:2042 [inline]
       io_submit_sqe io_uring/io_uring.c:2320 [inline]
       io_submit_sqes+0xbf4/0x2140 io_uring/io_uring.c:2434
       __do_sys_io_uring_enter io_uring/io_uring.c:3280 [inline]
       __se_sys_io_uring_enter+0x2e0/0x2b60 io_uring/io_uring.c:3219
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0xec/0xf80 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (&ctx->uring_lock){+.+.}-{4:4}:
       check_prev_add kernel/locking/lockdep.c:3165 [inline]
       check_prevs_add kernel/locking/lockdep.c:3284 [inline]
       validate_chain kernel/locking/lockdep.c:3908 [inline]
       __lock_acquire+0x15a6/0x2cf0 kernel/locking/lockdep.c:5237
       lock_acquire+0x107/0x340 kernel/locking/lockdep.c:5868
       __mutex_lock_common kernel/locking/mutex.c:614 [inline]
       __mutex_lock+0x187/0x1350 kernel/locking/mutex.c:776
       io_uring_del_tctx_node+0xf0/0x2c0 io_uring/tctx.c:179
       io_uring_clean_tctx+0xd4/0x1a0 io_uring/tctx.c:195
       io_uring_cancel_generic+0x6ca/0x7d0 io_uring/cancel.c:646
       io_uring_task_cancel include/linux/io_uring.h:24 [inline]
       begin_new_exec+0x10ed/0x2440 fs/exec.c:1131
       load_elf_binary+0x9f8/0x2d70 fs/binfmt_elf.c:1010
       search_binary_handler fs/exec.c:1669 [inline]
       exec_binprm fs/exec.c:1701 [inline]
       bprm_execve+0x92e/0x1400 fs/exec.c:1753
       do_execveat_common+0x510/0x6a0 fs/exec.c:1859
       do_execve fs/exec.c:1933 [inline]
       __do_sys_execve fs/exec.c:2009 [inline]
       __se_sys_execve fs/exec.c:2004 [inline]
       __x64_sys_execve+0x94/0xb0 fs/exec.c:2004
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0xec/0xf80 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

Chain exists of:
  &ctx->uring_lock --> sb_writers#3 --> &sig->cred_guard_mutex

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&sig->cred_guard_mutex);
                               lock(sb_writers#3);
                               lock(&sig->cred_guard_mutex);
  lock(&ctx->uring_lock);

 *** DEADLOCK ***

1 lock held by syz.0.9999/12287:
 #0: ffff88802db5a2e0 (&sig->cred_guard_mutex){+.+.}-{4:4}, at: prepare_bprm_creds fs/exec.c:1360 [inline]
 #0: ffff88802db5a2e0 (&sig->cred_guard_mutex){+.+.}-{4:4}, at: bprm_execve+0xb9/0x1400 fs/exec.c:1733

stack backtrace:
CPU: 0 UID: 0 PID: 12287 Comm: syz.0.9999 Tainted: G             L      syzkaller #0 PREEMPT(full)
Tainted: [L]=SOFTLOCKUP
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/25/2025
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_circular_bug+0x2e2/0x300 kernel/locking/lockdep.c:2043
 check_noncircular+0x12e/0x150 kernel/locking/lockdep.c:2175
 check_prev_add kernel/locking/lockdep.c:3165 [inline]
 check_prevs_add kernel/locking/lockdep.c:3284 [inline]
 validate_chain kernel/locking/lockdep.c:3908 [inline]
 __lock_acquire+0x15a6/0x2cf0 kernel/locking/lockdep.c:5237
 lock_acquire+0x107/0x340 kernel/locking/lockdep.c:5868
 __mutex_lock_common kernel/locking/mutex.c:614 [inline]
 __mutex_lock+0x187/0x1350 kernel/locking/mutex.c:776
 io_uring_del_tctx_node+0xf0/0x2c0 io_uring/tctx.c:179
 io_uring_clean_tctx+0xd4/0x1a0 io_uring/tctx.c:195
 io_uring_cancel_generic+0x6ca/0x7d0 io_uring/cancel.c:646
 io_uring_task_cancel include/linux/io_uring.h:24 [inline]
 begin_new_exec+0x10ed/0x2440 fs/exec.c:1131
 load_elf_binary+0x9f8/0x2d70 fs/binfmt_elf.c:1010
 search_binary_handler fs/exec.c:1669 [inline]
 exec_binprm fs/exec.c:1701 [inline]
 bprm_execve+0x92e/0x1400 fs/exec.c:1753
 do_execveat_common+0x510/0x6a0 fs/exec.c:1859
 do_execve fs/exec.c:1933 [inline]
 __do_sys_execve fs/exec.c:2009 [inline]
 __se_sys_execve fs/exec.c:2004 [inline]
 __x64_sys_execve+0x94/0xb0 fs/exec.c:2004
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xec/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7ff3a8b8f749
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ff3a9a97038 EFLAGS: 00000246 ORIG_RAX: 000000000000003b
RAX: ffffffffffffffda RBX: 00007ff3a8de5fa0 RCX: 00007ff3a8b8f749
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000200000000400
RBP: 00007ff3a8c13f91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ff3a8de6038 R14: 00007ff3a8de5fa0 R15: 00007ff3a8f0fa28
 </TASK>

Add a separate lock just for the tctx_list, tctx_lock. This can nest
under ->uring_lock, where necessary, and be used separately for list
manipulation. For the cancelation off exec side, this removes the
need to grab ->uring_lock, hence fixing the circular locking
dependency.

Reported-by: syzbot+b0e3b77ffaa8a4067ce5@syzkaller.appspotmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index e1adb0d20a0a..a3e8ddc9b380 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -424,11 +424,17 @@ struct io_ring_ctx {
 	struct user_struct		*user;
 	struct mm_struct		*mm_account;
 
+	/*
+	 * List of tctx nodes for this ctx, protected by tctx_lock. For
+	 * cancelation purposes, nests under uring_lock.
+	 */
+	struct list_head		tctx_list;
+	struct mutex			tctx_lock;
+
 	/* ctx exit and cancelation */
 	struct llist_head		fallback_llist;
 	struct delayed_work		fallback_work;
 	struct work_struct		exit_work;
-	struct list_head		tctx_list;
 	struct completion		ref_comp;
 
 	/* io-wq management, e.g. thread count */
diff --git a/io_uring/cancel.c b/io_uring/cancel.c
index ca12ac10c0ae..e1f9d5688bba 100644
--- a/io_uring/cancel.c
+++ b/io_uring/cancel.c
@@ -185,6 +185,7 @@ static int __io_async_cancel(struct io_cancel_data *cd,
 
 	/* slow path, try all io-wq's */
 	io_ring_submit_lock(ctx, issue_flags);
+	mutex_lock(&ctx->tctx_lock);
 	ret = -ENOENT;
 	list_for_each_entry(node, &ctx->tctx_list, ctx_node) {
 		ret = io_async_cancel_one(node->task->io_uring, cd);
@@ -194,6 +195,7 @@ static int __io_async_cancel(struct io_cancel_data *cd,
 			nr++;
 		}
 	}
+	mutex_unlock(&ctx->tctx_lock);
 	io_ring_submit_unlock(ctx, issue_flags);
 	return all ? nr : ret;
 }
@@ -484,6 +486,7 @@ static __cold bool io_uring_try_cancel_iowq(struct io_ring_ctx *ctx)
 	bool ret = false;
 
 	mutex_lock(&ctx->uring_lock);
+	mutex_lock(&ctx->tctx_lock);
 	list_for_each_entry(node, &ctx->tctx_list, ctx_node) {
 		struct io_uring_task *tctx = node->task->io_uring;
 
@@ -496,6 +499,7 @@ static __cold bool io_uring_try_cancel_iowq(struct io_ring_ctx *ctx)
 		cret = io_wq_cancel_cb(tctx->io_wq, io_cancel_ctx_cb, ctx, true);
 		ret |= (cret != IO_WQ_CANCEL_NOTFOUND);
 	}
+	mutex_unlock(&ctx->tctx_lock);
 	mutex_unlock(&ctx->uring_lock);
 
 	return ret;
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 709943fedaf4..87a87396e940 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -340,6 +340,7 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	INIT_LIST_HEAD(&ctx->ltimeout_list);
 	init_llist_head(&ctx->work_llist);
 	INIT_LIST_HEAD(&ctx->tctx_list);
+	mutex_init(&ctx->tctx_lock);
 	ctx->submit_state.free_list.next = NULL;
 	INIT_HLIST_HEAD(&ctx->waitid_list);
 	xa_init_flags(&ctx->zcrx_ctxs, XA_FLAGS_ALLOC);
@@ -3045,6 +3046,7 @@ static __cold void io_ring_exit_work(struct work_struct *work)
 	exit.ctx = ctx;
 
 	mutex_lock(&ctx->uring_lock);
+	mutex_lock(&ctx->tctx_lock);
 	while (!list_empty(&ctx->tctx_list)) {
 		WARN_ON_ONCE(time_after(jiffies, timeout));
 
@@ -3056,6 +3058,7 @@ static __cold void io_ring_exit_work(struct work_struct *work)
 		if (WARN_ON_ONCE(ret))
 			continue;
 
+		mutex_unlock(&ctx->tctx_lock);
 		mutex_unlock(&ctx->uring_lock);
 		/*
 		 * See comment above for
@@ -3064,7 +3067,9 @@ static __cold void io_ring_exit_work(struct work_struct *work)
 		 */
 		wait_for_completion_interruptible(&exit.completion);
 		mutex_lock(&ctx->uring_lock);
+		mutex_lock(&ctx->tctx_lock);
 	}
+	mutex_unlock(&ctx->tctx_lock);
 	mutex_unlock(&ctx->uring_lock);
 	spin_lock(&ctx->completion_lock);
 	spin_unlock(&ctx->completion_lock);
diff --git a/io_uring/register.c b/io_uring/register.c
index 62d39b3ff317..3d3822ff3fd9 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -320,6 +320,7 @@ static __cold int io_register_iowq_max_workers(struct io_ring_ctx *ctx,
 		return 0;
 
 	/* now propagate the restriction to all registered users */
+	mutex_lock(&ctx->tctx_lock);
 	list_for_each_entry(node, &ctx->tctx_list, ctx_node) {
 		tctx = node->task->io_uring;
 		if (WARN_ON_ONCE(!tctx->io_wq))
@@ -330,6 +331,7 @@ static __cold int io_register_iowq_max_workers(struct io_ring_ctx *ctx,
 		/* ignore errors, it always returns zero anyway */
 		(void)io_wq_max_workers(tctx->io_wq, new_count);
 	}
+	mutex_unlock(&ctx->tctx_lock);
 	return 0;
 err:
 	if (sqd) {
diff --git a/io_uring/tctx.c b/io_uring/tctx.c
index 5b66755579c0..6d6f44215ec8 100644
--- a/io_uring/tctx.c
+++ b/io_uring/tctx.c
@@ -136,9 +136,9 @@ int __io_uring_add_tctx_node(struct io_ring_ctx *ctx)
 			return ret;
 		}
 
-		mutex_lock(&ctx->uring_lock);
+		mutex_lock(&ctx->tctx_lock);
 		list_add(&node->ctx_node, &ctx->tctx_list);
-		mutex_unlock(&ctx->uring_lock);
+		mutex_unlock(&ctx->tctx_lock);
 	}
 	return 0;
 }
@@ -176,9 +176,9 @@ __cold void io_uring_del_tctx_node(unsigned long index)
 	WARN_ON_ONCE(current != node->task);
 	WARN_ON_ONCE(list_empty(&node->ctx_node));
 
-	mutex_lock(&node->ctx->uring_lock);
+	mutex_lock(&node->ctx->tctx_lock);
 	list_del(&node->ctx_node);
-	mutex_unlock(&node->ctx->uring_lock);
+	mutex_unlock(&node->ctx->tctx_lock);
 
 	if (tctx->last == node->ctx)
 		tctx->last = NULL;

-- 
Jens Axboe


