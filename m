Return-Path: <io-uring+bounces-11353-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B6165CED194
	for <lists+io-uring@lfdr.de>; Thu, 01 Jan 2026 16:17:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id F0F1A3007ECD
	for <lists+io-uring@lfdr.de>; Thu,  1 Jan 2026 15:17:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A7412DCF46;
	Thu,  1 Jan 2026 15:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="2kDB+tgg"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D87A2DCC05
	for <io-uring@vger.kernel.org>; Thu,  1 Jan 2026 15:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767280668; cv=none; b=AD7AJuDO0PIEsPKe/X3eiEhpsKTf/MjtN/uHJuXz9ZDEEiOFJ9B9x95JxdDhJuAjb73jDHY5Zl8qr6BvCNFyH54KzqWV1HqYcx/MjEMi0CkB4AGrdG94WXTdEGauZSMxYeUpGDicVcrYTGy7pGH77Tokft60AEBzm49wWNwh4mI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767280668; c=relaxed/simple;
	bh=fSWQTR48g30ms9J0KuEUvfJqk4hCB09MPGRGysCh/9A=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=iAitjQd+S1vGf4/flboIcQ/iq0e6hRzmwk6cFDvcnokVPUZxaTaSEA4g0FR5cp2KzcJCx3Yked2+ErlM+slc2rLuWeInFHt2NajnVtp0pYMiyjyNRCraosUwMnLDK0jFibGb3Pccb0JJgSQgpmR6YrokhTOcVh4s+xVb55mpMYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=2kDB+tgg; arc=none smtp.client-ip=209.85.210.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f54.google.com with SMTP id 46e09a7af769-7c75fc222c3so5416004a34.0
        for <io-uring@vger.kernel.org>; Thu, 01 Jan 2026 07:17:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1767280663; x=1767885463; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=goxo8lkdG8BNdANhbd/SbMaLC2sklJTNRRcM580vzbw=;
        b=2kDB+tgghAu45z+AQj+t1X0sdpEH2HO9GmSTGY6l2+CpYMaiH7QvMscsN61iR8CuL+
         tTDpyHABoG9vCEja/khUfz9QuO22Ybkr/IzWvti3FsdQyoC8K6O8q8jybhkB2nJa2uL4
         9UFkXhX04YGMu1jD6ezwbMJnIrNGzTfkjUJUYThkkEicE/VC0m9eA0Y6IQpM8ODsdSoT
         4eCXV7Wkz7/F57ZE8ZbG//EE3BoU+4IfeIQYsb7o7MDFGi1ZsD/0hIfXHGH9rTKmekON
         ZfJ2ybNHIrNicQVBo7FuR2pSEh9Rbrk5bK4fXwxAux6AZ7Pl9uhAXbev4BP3A/cqIO94
         +dJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767280663; x=1767885463;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=goxo8lkdG8BNdANhbd/SbMaLC2sklJTNRRcM580vzbw=;
        b=l5BEw6zt7y3eax03kEUIC/d1WNcB1FLPkt67C4XI3knPtOJTq86yNdKjqKngBYKADI
         hzdRLHJBlmpxfWGzp/LYSaKjTpn8R10Y7/JDgOztOr3kLbmfJpoEssFOrzoZG6AGNMMe
         I8nQiRmPZDTg643w8m4BUiaLjaW/RIUBfb1UdNi3PCC+oh5SypUE453XJSmNgt+FD+Al
         vzFt+8/qEEJXVdU/VLT9fcWCdDMNvDrD4dKGNJ9WtGOP/iqTzzSoJT6eDEDmeRn31+rJ
         bTtfi5GdSqkaIT4wjhf7pkFZTd8HsTFq64q3yXfwaOQmyrPXBtdQQPysoOl/cjEyBaKV
         zWdg==
X-Gm-Message-State: AOJu0YxOCNqXIlZqQs9Ziy48MZy03h69LsUPuxLcUKcZOzU2rswlSjyd
	DMMTlMuDF0HYf47Bm8EpN4lr+CF32MpadPlACcXAcqXQydIv8i6bfC3Js15SIolrWFg9g2S/A18
	hnTmd
X-Gm-Gg: AY/fxX7GajwfXxNvNLhmEiSccEkeDytIJGspL3Tf5KMi84GSbSllai2y2KixY2srayP
	DRifqtpbx4vyqxDsjrp8aTZtIyooj4Px2wdruBgoQozuVERav2as4+bA27HDoKWocxmKM+xk+it
	UR34MJmyXiV2lFkKl+ayxhQb3cu+komfV2JGD+ENpzUDXGn1iuFA2odka4tIv1UPp5GuRsOKwlH
	aOLgAVRuIS8ZarXGsNzE1uNqdPZz9/cjiPEnJkd/AaX0JIHxlrfBbcjyqYMvWDbrT8hYXv7r9oR
	/D8MQTd6ZQjPKUBDGnbgA4V3kM1oiGCvzwhE2Jho/WfOAGDl/N3uFDgQIQNjS2hstYkofwRxrjL
	7ZGmPO9CA6bPCiAyU3XXQazoy5SMuLZnhIxGTpjv3D8jNhjxh880faqTd9FkjVTfhNAR6h1sCsG
	2bND8FnWahhEkeWwWEAzY=
X-Google-Smtp-Source: AGHT+IGNMoTnDt4f+pY5OrZv6bYuF+FzPAPQ1kyB3tzFt4ymXOB4zlvH64co5kUt4FsQYzBOjWsqwg==
X-Received: by 2002:a05:6830:2642:b0:7c7:6217:5c60 with SMTP id 46e09a7af769-7cc66a603d6mr18222572a34.25.1767280660546;
        Thu, 01 Jan 2026 07:17:40 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7cc667ec281sm25748708a34.24.2026.01.01.07.17.39
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Jan 2026 07:17:39 -0800 (PST)
Message-ID: <24a9e751-7442-4036-9b9f-8c144918c201@kernel.dk>
Date: Thu, 1 Jan 2026 08:17:38 -0700
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
Subject: [PATCH v2] io_uring/tctx: add separate lock for list of tctx's in ctx
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

v2: ensure task is running before grabbing nested tctx_lock

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
index ca12ac10c0ae..07b8d852218b 100644
--- a/io_uring/cancel.c
+++ b/io_uring/cancel.c
@@ -184,7 +184,9 @@ static int __io_async_cancel(struct io_cancel_data *cd,
 	} while (1);
 
 	/* slow path, try all io-wq's */
+	__set_current_state(TASK_RUNNING);
 	io_ring_submit_lock(ctx, issue_flags);
+	mutex_lock(&ctx->tctx_lock);
 	ret = -ENOENT;
 	list_for_each_entry(node, &ctx->tctx_list, ctx_node) {
 		ret = io_async_cancel_one(node->task->io_uring, cd);
@@ -194,6 +196,7 @@ static int __io_async_cancel(struct io_cancel_data *cd,
 			nr++;
 		}
 	}
+	mutex_unlock(&ctx->tctx_lock);
 	io_ring_submit_unlock(ctx, issue_flags);
 	return all ? nr : ret;
 }
@@ -484,6 +487,7 @@ static __cold bool io_uring_try_cancel_iowq(struct io_ring_ctx *ctx)
 	bool ret = false;
 
 	mutex_lock(&ctx->uring_lock);
+	mutex_lock(&ctx->tctx_lock);
 	list_for_each_entry(node, &ctx->tctx_list, ctx_node) {
 		struct io_uring_task *tctx = node->task->io_uring;
 
@@ -496,6 +500,7 @@ static __cold bool io_uring_try_cancel_iowq(struct io_ring_ctx *ctx)
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


