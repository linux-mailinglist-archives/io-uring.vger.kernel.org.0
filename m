Return-Path: <io-uring+bounces-11346-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C743CEC28C
	for <lists+io-uring@lfdr.de>; Wed, 31 Dec 2025 16:22:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DD36830102AE
	for <lists+io-uring@lfdr.de>; Wed, 31 Dec 2025 15:22:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0923A261B8F;
	Wed, 31 Dec 2025 15:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="P3Dydvc2"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f51.google.com (mail-oa1-f51.google.com [209.85.160.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 207471925BC
	for <io-uring@vger.kernel.org>; Wed, 31 Dec 2025 15:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767194576; cv=none; b=cKKm9vwEyz3a6qp7GZk0UdhsPeiZm+sIFWd8ZlazXORgMsvZicVXceKVpeRIErPcqLDuh5vNcoGOjEG0s3oEJ81yYFezbpdUN6oBJ0JWKmrSW/TeTNOhDIRXa41VGLOWScjjOCYpwKQSzIOi3RUc62p5xEnqOq0TEyBDKR86FBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767194576; c=relaxed/simple;
	bh=mJ0u6EWMEeBBPII0Nzw3CEzg9gtZgi7upVQoxqZM7zg=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=f9CzHZa5tXt+IO9/vjw/6AGpUT51KjMlDcEyYKlM8+hISqbpvCI6NbRny5dQE51HEU0cS3r/Iu7wo+L6svmo4pMM3wl8Y7iAXgod8thmR22Wk5eS1iDYhONZsRpvXk7qtYSXGZMmjgGfvqgzqZ20Jhf5e8vB35wGN+5eS0Mak5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=P3Dydvc2; arc=none smtp.client-ip=209.85.160.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f51.google.com with SMTP id 586e51a60fabf-3f9ebb269c3so3933994fac.3
        for <io-uring@vger.kernel.org>; Wed, 31 Dec 2025 07:22:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1767194572; x=1767799372; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ANGd0a36CYW0qzjP68N4UtI0tlFvaUbrDuwsxsudyLg=;
        b=P3Dydvc2zHnCw5V5xUaKigUyPRxDeBNxi5e2eFMSdLGgmNHqVlsp7QyQHRq1NGA9Pu
         ZbGSZbLyxLG3lqnuPiorxYmR4JKReJOhNSubeI4IeEt9+HgQZyP7Qz54XqxQO08vDakB
         GCYaf+WNw7IsVbCVEq6rVJTmICiwZpLDlWAmNwUA0glwe7pppD+nFvF3krsQ3EBWM7up
         xruF93PSIiL+s+xr5cyFAWlvkPu5e08/0vz9BxFl8Zt86NrObajawxHSYf4BxTsZtNhB
         6NKiuYD1J2Jbf0iXlurj3z+qimIiZxc9AIRWqADzovgO3EZ/npeF5nT0dIpLxfEfdtbC
         a7xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767194572; x=1767799372;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ANGd0a36CYW0qzjP68N4UtI0tlFvaUbrDuwsxsudyLg=;
        b=tavLPrdY0VET3m7zleTGo5w2MYdBdKBZpbm+WA8Ea1LZF2zyYQ8AR8G/PgMwEebFXQ
         4FVzFdPIa9rm7SlyqWbGJQdJ3M+PGKDEE7IuU0D08letXZypy07B3AHeLGhWshUOKvem
         4GgAduJsY8nmerI9ml4Gd9ijcJ5e0McJd7GH+sYYaqIrHIsybJDPSMKuPzTFrNpeCNnV
         HvNUYXSMoUTlVm8aNwOZI8mBTCzfh9ybUsEMuzX/+zctIzt4BeI+KCTygYqVYvTnaJN9
         MP5pyHC7jfs3Vp8DK7YA2wPGaxC3PST39FguR3XQq5VrjOeOLPKVmgjrpqsJmZtS1Z9q
         pAXg==
X-Forwarded-Encrypted: i=1; AJvYcCUC5IpApN8xnl6OU7EgIAFMIDHLMG0kRhU446MqP3oFDxUFWQGS3h/LEgbtExFkm7WY1IHRmPn/Og==@vger.kernel.org
X-Gm-Message-State: AOJu0YzE0EznTGL7nrKVJjDbgpRAswhSlNA2JPDL3Aet4cE/FoSAKned
	m1WRp/zQZEG4uMF5vEqvekLXnrnEFLuOpSPkBNqrhkkElItZgKMHi//3pLVbpCsGYDk=
X-Gm-Gg: AY/fxX5KMjOKiErvIdFQSnXeQZdndhYFaeQAqEkhAeeOXeSDGG92PMzuMCkRVeBNW1u
	NskBKCszxPmzWj2VbdpIKbImlZMmcnCCbuGSa2Af8YQQBHU57drfgSnIjtDL8xJUNPSe/n7wmiG
	rl/8uGg4bVrzWts8RdAyQTwRG1YHGJrK1DJr0z0HSn/97HEz9DHVpWPAGXgBuPKjQWyu1gK34se
	352C3ajbqRCCzH7tys/2yMpVW1G3NBUXMoFDpfCrgmHLdIcf3M1IjqmT2fQWti+dOJ53BXlqcY5
	KRb38CMUTmX2jH6PoaVSfzJcOBftI+p78WFxRhz7aUGUKVEbYdC/c+mbGTOPI2DnhP2mgE3eUBQ
	qEb4tIIn3zI2CIfVlzP8OMy8tCqnoQq/FfQTP8yuyHTDl7qDbL7NFTcs6gw/yxORk9kjdFm3TVa
	2fivNdZZ+O
X-Google-Smtp-Source: AGHT+IGeuJHzqd5tO9B2riIyztY/uvXDgYW86rmenXOTcyTP8H73bfCrDTrYQn1wD4LVCoa7JAI27A==
X-Received: by 2002:a05:6870:f714:b0:3e7:eee7:948f with SMTP id 586e51a60fabf-3fda5611093mr17394777fac.9.1767194571740;
        Wed, 31 Dec 2025 07:22:51 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-3fdaabbf2e6sm22696164fac.17.2025.12.31.07.22.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 Dec 2025 07:22:50 -0800 (PST)
Message-ID: <69712573-c586-44ca-8c07-df7d23747fd8@kernel.dk>
Date: Wed, 31 Dec 2025 08:22:49 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] possible deadlock in io_uring_del_tctx_node
To: syzbot <syzbot+b0e3b77ffaa8a4067ce5@syzkaller.appspotmail.com>,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com
References: <6953bc09.050a0220.329c0f.0591.GAE@google.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <6953bc09.050a0220.329c0f.0591.GAE@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/30/25 4:48 AM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    7839932417dd Merge tag 'sched_ext-for-6.19-rc3-fixes' of g..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=1540bb92580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=a94030c847137a18
> dashboard link: https://syzkaller.appspot.com/bug?extid=b0e3b77ffaa8a4067ce5
> compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/d2f55b7baab3/disk-78399324.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/60100f150ad1/vmlinux-78399324.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/2a223b3daaf7/bzImage-78399324.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+b0e3b77ffaa8a4067ce5@syzkaller.appspotmail.com
> 
> ======================================================
> WARNING: possible circular locking dependency detected
> syzkaller #0 Tainted: G             L     
> ------------------------------------------------------
> syz.0.9999/12287 is trying to acquire lock:
> ffff88805851c0a8 (&ctx->uring_lock){+.+.}-{4:4}, at: io_uring_del_tctx_node+0xf0/0x2c0 io_uring/tctx.c:179
> 
> but task is already holding lock:
> ffff88802db5a2e0 (&sig->cred_guard_mutex){+.+.}-{4:4}, at: prepare_bprm_creds fs/exec.c:1360 [inline]
> ffff88802db5a2e0 (&sig->cred_guard_mutex){+.+.}-{4:4}, at: bprm_execve+0xb9/0x1400 fs/exec.c:1733
> 
> which lock already depends on the new lock.
> 
> 
> the existing dependency chain (in reverse order) is:
> 
> -> #2 (&sig->cred_guard_mutex){+.+.}-{4:4}:
>        __mutex_lock_common kernel/locking/mutex.c:614 [inline]
>        __mutex_lock+0x187/0x1350 kernel/locking/mutex.c:776
>        proc_pid_attr_write+0x547/0x630 fs/proc/base.c:2837
>        vfs_write+0x27e/0xb30 fs/read_write.c:684
>        ksys_write+0x145/0x250 fs/read_write.c:738
>        do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>        do_syscall_64+0xec/0xf80 arch/x86/entry/syscall_64.c:94
>        entry_SYSCALL_64_after_hwframe+0x77/0x7f
> 
> -> #1 (sb_writers#3){.+.+}-{0:0}:
>        percpu_down_read_internal include/linux/percpu-rwsem.h:53 [inline]
>        percpu_down_read_freezable include/linux/percpu-rwsem.h:83 [inline]
>        __sb_start_write include/linux/fs/super.h:19 [inline]
>        sb_start_write+0x4d/0x1c0 include/linux/fs/super.h:125
>        mnt_want_write+0x41/0x90 fs/namespace.c:499
>        open_last_lookups fs/namei.c:4529 [inline]
>        path_openat+0xadd/0x3dd0 fs/namei.c:4784
>        do_filp_open+0x1fa/0x410 fs/namei.c:4814
>        io_openat2+0x3e0/0x5c0 io_uring/openclose.c:143
>        __io_issue_sqe+0x181/0x4b0 io_uring/io_uring.c:1792
>        io_issue_sqe+0x165/0x1060 io_uring/io_uring.c:1815
>        io_queue_sqe io_uring/io_uring.c:2042 [inline]
>        io_submit_sqe io_uring/io_uring.c:2320 [inline]
>        io_submit_sqes+0xbf4/0x2140 io_uring/io_uring.c:2434
>        __do_sys_io_uring_enter io_uring/io_uring.c:3280 [inline]
>        __se_sys_io_uring_enter+0x2e0/0x2b60 io_uring/io_uring.c:3219
>        do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>        do_syscall_64+0xec/0xf80 arch/x86/entry/syscall_64.c:94
>        entry_SYSCALL_64_after_hwframe+0x77/0x7f
> 
> -> #0 (&ctx->uring_lock){+.+.}-{4:4}:
>        check_prev_add kernel/locking/lockdep.c:3165 [inline]
>        check_prevs_add kernel/locking/lockdep.c:3284 [inline]
>        validate_chain kernel/locking/lockdep.c:3908 [inline]
>        __lock_acquire+0x15a6/0x2cf0 kernel/locking/lockdep.c:5237
>        lock_acquire+0x107/0x340 kernel/locking/lockdep.c:5868
>        __mutex_lock_common kernel/locking/mutex.c:614 [inline]
>        __mutex_lock+0x187/0x1350 kernel/locking/mutex.c:776
>        io_uring_del_tctx_node+0xf0/0x2c0 io_uring/tctx.c:179
>        io_uring_clean_tctx+0xd4/0x1a0 io_uring/tctx.c:195
>        io_uring_cancel_generic+0x6ca/0x7d0 io_uring/cancel.c:646
>        io_uring_task_cancel include/linux/io_uring.h:24 [inline]
>        begin_new_exec+0x10ed/0x2440 fs/exec.c:1131
>        load_elf_binary+0x9f8/0x2d70 fs/binfmt_elf.c:1010
>        search_binary_handler fs/exec.c:1669 [inline]
>        exec_binprm fs/exec.c:1701 [inline]
>        bprm_execve+0x92e/0x1400 fs/exec.c:1753
>        do_execveat_common+0x510/0x6a0 fs/exec.c:1859
>        do_execve fs/exec.c:1933 [inline]
>        __do_sys_execve fs/exec.c:2009 [inline]
>        __se_sys_execve fs/exec.c:2004 [inline]
>        __x64_sys_execve+0x94/0xb0 fs/exec.c:2004
>        do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>        do_syscall_64+0xec/0xf80 arch/x86/entry/syscall_64.c:94
>        entry_SYSCALL_64_after_hwframe+0x77/0x7f
> 
> other info that might help us debug this:
> 
> Chain exists of:
>   &ctx->uring_lock --> sb_writers#3 --> &sig->cred_guard_mutex
> 
>  Possible unsafe locking scenario:
> 
>        CPU0                    CPU1
>        ----                    ----
>   lock(&sig->cred_guard_mutex);
>                                lock(sb_writers#3);
>                                lock(&sig->cred_guard_mutex);
>   lock(&ctx->uring_lock);
> 
>  *** DEADLOCK ***
> 
> 1 lock held by syz.0.9999/12287:
>  #0: ffff88802db5a2e0 (&sig->cred_guard_mutex){+.+.}-{4:4}, at: prepare_bprm_creds fs/exec.c:1360 [inline]
>  #0: ffff88802db5a2e0 (&sig->cred_guard_mutex){+.+.}-{4:4}, at: bprm_execve+0xb9/0x1400 fs/exec.c:1733
> 
> stack backtrace:
> CPU: 0 UID: 0 PID: 12287 Comm: syz.0.9999 Tainted: G             L      syzkaller #0 PREEMPT(full) 
> Tainted: [L]=SOFTLOCKUP
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/25/2025
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  print_circular_bug+0x2e2/0x300 kernel/locking/lockdep.c:2043
>  check_noncircular+0x12e/0x150 kernel/locking/lockdep.c:2175
>  check_prev_add kernel/locking/lockdep.c:3165 [inline]
>  check_prevs_add kernel/locking/lockdep.c:3284 [inline]
>  validate_chain kernel/locking/lockdep.c:3908 [inline]
>  __lock_acquire+0x15a6/0x2cf0 kernel/locking/lockdep.c:5237
>  lock_acquire+0x107/0x340 kernel/locking/lockdep.c:5868
>  __mutex_lock_common kernel/locking/mutex.c:614 [inline]
>  __mutex_lock+0x187/0x1350 kernel/locking/mutex.c:776
>  io_uring_del_tctx_node+0xf0/0x2c0 io_uring/tctx.c:179
>  io_uring_clean_tctx+0xd4/0x1a0 io_uring/tctx.c:195
>  io_uring_cancel_generic+0x6ca/0x7d0 io_uring/cancel.c:646
>  io_uring_task_cancel include/linux/io_uring.h:24 [inline]
>  begin_new_exec+0x10ed/0x2440 fs/exec.c:1131
>  load_elf_binary+0x9f8/0x2d70 fs/binfmt_elf.c:1010
>  search_binary_handler fs/exec.c:1669 [inline]
>  exec_binprm fs/exec.c:1701 [inline]
>  bprm_execve+0x92e/0x1400 fs/exec.c:1753
>  do_execveat_common+0x510/0x6a0 fs/exec.c:1859
>  do_execve fs/exec.c:1933 [inline]
>  __do_sys_execve fs/exec.c:2009 [inline]
>  __se_sys_execve fs/exec.c:2004 [inline]
>  __x64_sys_execve+0x94/0xb0 fs/exec.c:2004
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xec/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7ff3a8b8f749
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ff3a9a97038 EFLAGS: 00000246 ORIG_RAX: 000000000000003b
> RAX: ffffffffffffffda RBX: 00007ff3a8de5fa0 RCX: 00007ff3a8b8f749
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000200000000400
> RBP: 00007ff3a8c13f91 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007ff3a8de6038 R14: 00007ff3a8de5fa0 R15: 00007ff3a8f0fa28
>  </TASK>

I realize there's no reproducer for this yet, but I think the cause is
quite clear and the easiest way to solve it is likely to protect
->tctx_list by a separate lock. This lock can nest inside ->uring_lock,
where necessary, and be used independently just for list manipulation.
Something like the below.

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
index 6cb24cdf8e68..850951100352 100644
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

