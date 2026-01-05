Return-Path: <io-uring+bounces-11368-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 10411CF540A
	for <lists+io-uring@lfdr.de>; Mon, 05 Jan 2026 19:39:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9D765307D806
	for <lists+io-uring@lfdr.de>; Mon,  5 Jan 2026 18:39:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C65AF3358D9;
	Mon,  5 Jan 2026 18:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="vHnVg2vt"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f43.google.com (mail-oa1-f43.google.com [209.85.160.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4589D2FF148
	for <io-uring@vger.kernel.org>; Mon,  5 Jan 2026 18:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767638353; cv=none; b=LxjIDMvbKaHbTAWbkLa/R+i4sm5V9VXyV/7Zm3OgDXQhHvGMZybvnIkw9kX+vlf4gTKOWyLluE54MjU5KX1mGS7mzOVGs1iQ1BKNRDyW4sra+olUxRb3PgaQ6h6ZdNWnNaxEH8JJlIqR4lJmc8SufgyTjmFGWtBtq1p+ph0KbPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767638353; c=relaxed/simple;
	bh=YOJpzrY/7UHJ8qB0QAjm6Uqy3dOLHZIcV2GrwdtiUtI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SBPTmnFUIxT27kAwo0ogunIfsXQbZAX+MNKwr5cs0B08zBOuQB+WNiIMhVSbLsRth46dhGynKuyJJaj1/e1WJnKFPJqQO2Rwozxy1qxQpvWlNU7HSn1k3NRnXHHatgQ0udhwfsQtqolF2WXeDTFBg/18ZDfauaUPCknOlIJEzsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=vHnVg2vt; arc=none smtp.client-ip=209.85.160.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-3ec3cdcda4eso169630fac.1
        for <io-uring@vger.kernel.org>; Mon, 05 Jan 2026 10:39:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1767638349; x=1768243149; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gzArAd7sVomeOf6mJhS/fbQ9XHZ1SPGtFXw8jIPzAx4=;
        b=vHnVg2vtCcUxZmdE4GoSyfCe9EfN1rFylXRlHhdJHHGUeUyB2xQ331hhgLKjTrdasV
         UUJoS8m0iStaCakBdRQEUL6+Wc656W5iTVWYDs6gDFNqE3PpVbKKwHkvizebcqD6DS5B
         0Vwtycvdm/NbzHsbFuZ5vXD2qVaJzykpLppgRve2Algk4jrT5NBUZTmMWZ4Y0WI+PWUs
         10py4p4McFBBy4lAKuWmzwRbf1tm1YhHdGtNGmpq3UfgR+p4tVbcchzGifX9jdpgjE2G
         O/sxsWxM9GYWEE85bwyxvQQg3UpKIU6wv2owijYGXZAtxjxFZ/NrhoTZ0+O1AR+EUj6q
         rr/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767638349; x=1768243149;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gzArAd7sVomeOf6mJhS/fbQ9XHZ1SPGtFXw8jIPzAx4=;
        b=FDTyE77GidUf/B/czpOnrYwB+74x9IgmznXMqnVhI67S3X8doY58uj0XvulWRh9/S6
         2m96F3roB3jT7WwCir8rRqF2TQqn/F0cFLw1+A4DMBXUw4OqI1bUy0pgRq031ZvkwBO6
         6kgwSnUmOMR+20v92Ss5TY/jOlicnj9mUOCUhp5AsHMRmetDRXYzeq60wsGkSczhVHb+
         BGlU2vnuvZgf9tG3hrLWNPRP8dTDoWDFUXL4lWvh1f1nQSm6ustt/Ks9sSgcJ8i2kaCP
         gdwzluqBuXTttU8QI9rBob2rN97nJLynUkdjdPeodZkq7MC5oU6LfPYQsxOFRzs7HEJc
         lXZQ==
X-Gm-Message-State: AOJu0YwHH/eXN5ZnnXNhMGxgiFy0gJLaZO7uza2BpwejUrscVypQ7T+4
	1qaL2oQqMY1A05B24XRwNj7P2B6P2wlBt0V6zorJkL6pHeYlJQe/S8FlC8bahrHmOgg=
X-Gm-Gg: AY/fxX7hRtEqmrdbnVkJMWDJVJtCqUudIrwPCwKkoDzDPpbGsemFsBw+n2yGSwMZVZ8
	gW5IB+Ny+MUFRJXPab/pIBe9TQpym9r+hdnODc46Aio9QYQRPlrIf9ayOuSWZ3viKzD0tqekowH
	+YlBA9PmQ9DvK6wT/f11dVNPXUPXkUTnaLSB+WtGp7EMqSe0sLGwWw34c+7G91KHK7a9EA/AnU3
	wajFVdfTqX+43BCe8XrgPmCLrQ7I7m9iuaIynUvf9m6rn8WGPW84syqMsCSLZTNkccdxxK3dF0r
	wMdgO3bUXGw/R8WgDIUvAicJb8h2gmJXuYZfRrCyydsE1qYbnO+5F1S756jXOqU5wh6jy8KTFnS
	gp3+WA1LMeRX6In3LznIi65QtdTzwsY5P49n+VnZaVOyKVvSoSnNszfRflv2VyO4aTI/hYYbdHy
	h5Z0D3/0AF
X-Google-Smtp-Source: AGHT+IGMWVWDbeDtMPp5FHCXGFEfaog2vFKdwu7HTNLmgVfjG13FQ01DRwu7RvGurUEqxTO1tL+flg==
X-Received: by 2002:a05:6871:79a2:b0:3e8:9b86:3c6b with SMTP id 586e51a60fabf-3ffa0cb74f1mr208332fac.44.1767638348885;
        Mon, 05 Jan 2026 10:39:08 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-3ffa03bba72sm225865fac.21.2026.01.05.10.39.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Jan 2026 10:39:08 -0800 (PST)
Message-ID: <716b7ef7-0553-4d4d-a020-c79ed9056079@kernel.dk>
Date: Mon, 5 Jan 2026 11:39:07 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] io_uring/tctx: add separate lock for list of tctx's in
 ctx
To: Gabriel Krisman Bertazi <krisman@suse.de>
Cc: io-uring <io-uring@vger.kernel.org>
References: <24a9e751-7442-4036-9b9f-8c144918c201@kernel.dk>
 <87tswz7wft.fsf@mailhost.krisman.be>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <87tswz7wft.fsf@mailhost.krisman.be>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/5/26 11:20 AM, Gabriel Krisman Bertazi wrote:
> Jens Axboe <axboe@kernel.dk> writes:
> 
>> ctx->tcxt_list holds the tasks using this ring, and it's currently
>> protected by the normal ctx->uring_lock. However, this can cause a
>> circular locking issue, as reported by syzbot, where cancelations off
>> exec end up needing to remove an entry from this list:
>>
>> ======================================================
>> WARNING: possible circular locking dependency detected
>> syzkaller #0 Tainted: G             L
>> ------------------------------------------------------
>> syz.0.9999/12287 is trying to acquire lock:
>> ffff88805851c0a8 (&ctx->uring_lock){+.+.}-{4:4}, at: io_uring_del_tctx_node+0xf0/0x2c0 io_uring/tctx.c:179
>>
>> but task is already holding lock:
>> ffff88802db5a2e0 (&sig->cred_guard_mutex){+.+.}-{4:4}, at: prepare_bprm_creds fs/exec.c:1360 [inline]
>> ffff88802db5a2e0 (&sig->cred_guard_mutex){+.+.}-{4:4}, at: bprm_execve+0xb9/0x1400 fs/exec.c:1733
>>
>> which lock already depends on the new lock.
>>
>> the existing dependency chain (in reverse order) is:
>>
>> -> #2 (&sig->cred_guard_mutex){+.+.}-{4:4}:
>>        __mutex_lock_common kernel/locking/mutex.c:614 [inline]
>>        __mutex_lock+0x187/0x1350 kernel/locking/mutex.c:776
>>        proc_pid_attr_write+0x547/0x630 fs/proc/base.c:2837
>>        vfs_write+0x27e/0xb30 fs/read_write.c:684
>>        ksys_write+0x145/0x250 fs/read_write.c:738
>>        do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>>        do_syscall_64+0xec/0xf80 arch/x86/entry/syscall_64.c:94
>>        entry_SYSCALL_64_after_hwframe+0x77/0x7f
>>
>> -> #1 (sb_writers#3){.+.+}-{0:0}:
>>        percpu_down_read_internal include/linux/percpu-rwsem.h:53 [inline]
>>        percpu_down_read_freezable include/linux/percpu-rwsem.h:83 [inline]
>>        __sb_start_write include/linux/fs/super.h:19 [inline]
>>        sb_start_write+0x4d/0x1c0 include/linux/fs/super.h:125
>>        mnt_want_write+0x41/0x90 fs/namespace.c:499
>>        open_last_lookups fs/namei.c:4529 [inline]
>>        path_openat+0xadd/0x3dd0 fs/namei.c:4784
>>        do_filp_open+0x1fa/0x410 fs/namei.c:4814
>>        io_openat2+0x3e0/0x5c0 io_uring/openclose.c:143
>>        __io_issue_sqe+0x181/0x4b0 io_uring/io_uring.c:1792
>>        io_issue_sqe+0x165/0x1060 io_uring/io_uring.c:1815
>>        io_queue_sqe io_uring/io_uring.c:2042 [inline]
>>        io_submit_sqe io_uring/io_uring.c:2320 [inline]
>>        io_submit_sqes+0xbf4/0x2140 io_uring/io_uring.c:2434
>>        __do_sys_io_uring_enter io_uring/io_uring.c:3280 [inline]
>>        __se_sys_io_uring_enter+0x2e0/0x2b60 io_uring/io_uring.c:3219
>>        do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>>        do_syscall_64+0xec/0xf80 arch/x86/entry/syscall_64.c:94
>>        entry_SYSCALL_64_after_hwframe+0x77/0x7f
>>
>> -> #0 (&ctx->uring_lock){+.+.}-{4:4}:
>>        check_prev_add kernel/locking/lockdep.c:3165 [inline]
>>        check_prevs_add kernel/locking/lockdep.c:3284 [inline]
>>        validate_chain kernel/locking/lockdep.c:3908 [inline]
>>        __lock_acquire+0x15a6/0x2cf0 kernel/locking/lockdep.c:5237
>>        lock_acquire+0x107/0x340 kernel/locking/lockdep.c:5868
>>        __mutex_lock_common kernel/locking/mutex.c:614 [inline]
>>        __mutex_lock+0x187/0x1350 kernel/locking/mutex.c:776
>>        io_uring_del_tctx_node+0xf0/0x2c0 io_uring/tctx.c:179
>>        io_uring_clean_tctx+0xd4/0x1a0 io_uring/tctx.c:195
>>        io_uring_cancel_generic+0x6ca/0x7d0 io_uring/cancel.c:646
>>        io_uring_task_cancel include/linux/io_uring.h:24 [inline]
>>        begin_new_exec+0x10ed/0x2440 fs/exec.c:1131
>>        load_elf_binary+0x9f8/0x2d70 fs/binfmt_elf.c:1010
>>        search_binary_handler fs/exec.c:1669 [inline]
>>        exec_binprm fs/exec.c:1701 [inline]
>>        bprm_execve+0x92e/0x1400 fs/exec.c:1753
>>        do_execveat_common+0x510/0x6a0 fs/exec.c:1859
>>        do_execve fs/exec.c:1933 [inline]
>>        __do_sys_execve fs/exec.c:2009 [inline]
>>        __se_sys_execve fs/exec.c:2004 [inline]
>>        __x64_sys_execve+0x94/0xb0 fs/exec.c:2004
>>        do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>>        do_syscall_64+0xec/0xf80 arch/x86/entry/syscall_64.c:94
>>        entry_SYSCALL_64_after_hwframe+0x77/0x7f
>>
>> other info that might help us debug this:
>>
>> Chain exists of:
>>   &ctx->uring_lock --> sb_writers#3 --> &sig->cred_guard_mutex
>>
>>  Possible unsafe locking scenario:
>>
>>        CPU0                    CPU1
>>        ----                    ----
>>   lock(&sig->cred_guard_mutex);
>>                                lock(sb_writers#3);
>>                                lock(&sig->cred_guard_mutex);
>>   lock(&ctx->uring_lock);
>>
>>  *** DEADLOCK ***
>>
>> 1 lock held by syz.0.9999/12287:
>>  #0: ffff88802db5a2e0 (&sig->cred_guard_mutex){+.+.}-{4:4}, at: prepare_bprm_creds fs/exec.c:1360 [inline]
>>  #0: ffff88802db5a2e0 (&sig->cred_guard_mutex){+.+.}-{4:4}, at: bprm_execve+0xb9/0x1400 fs/exec.c:1733
>>
>> stack backtrace:
>> CPU: 0 UID: 0 PID: 12287 Comm: syz.0.9999 Tainted: G             L      syzkaller #0 PREEMPT(full)
>> Tainted: [L]=SOFTLOCKUP
>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/25/2025
>> Call Trace:
>>  <TASK>
>>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>>  print_circular_bug+0x2e2/0x300 kernel/locking/lockdep.c:2043
>>  check_noncircular+0x12e/0x150 kernel/locking/lockdep.c:2175
>>  check_prev_add kernel/locking/lockdep.c:3165 [inline]
>>  check_prevs_add kernel/locking/lockdep.c:3284 [inline]
>>  validate_chain kernel/locking/lockdep.c:3908 [inline]
>>  __lock_acquire+0x15a6/0x2cf0 kernel/locking/lockdep.c:5237
>>  lock_acquire+0x107/0x340 kernel/locking/lockdep.c:5868
>>  __mutex_lock_common kernel/locking/mutex.c:614 [inline]
>>  __mutex_lock+0x187/0x1350 kernel/locking/mutex.c:776
>>  io_uring_del_tctx_node+0xf0/0x2c0 io_uring/tctx.c:179
>>  io_uring_clean_tctx+0xd4/0x1a0 io_uring/tctx.c:195
>>  io_uring_cancel_generic+0x6ca/0x7d0 io_uring/cancel.c:646
>>  io_uring_task_cancel include/linux/io_uring.h:24 [inline]
>>  begin_new_exec+0x10ed/0x2440 fs/exec.c:1131
>>  load_elf_binary+0x9f8/0x2d70 fs/binfmt_elf.c:1010
>>  search_binary_handler fs/exec.c:1669 [inline]
>>  exec_binprm fs/exec.c:1701 [inline]
>>  bprm_execve+0x92e/0x1400 fs/exec.c:1753
>>  do_execveat_common+0x510/0x6a0 fs/exec.c:1859
>>  do_execve fs/exec.c:1933 [inline]
>>  __do_sys_execve fs/exec.c:2009 [inline]
>>  __se_sys_execve fs/exec.c:2004 [inline]
>>  __x64_sys_execve+0x94/0xb0 fs/exec.c:2004
>>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>>  do_syscall_64+0xec/0xf80 arch/x86/entry/syscall_64.c:94
>>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>> RIP: 0033:0x7ff3a8b8f749
>> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
>> RSP: 002b:00007ff3a9a97038 EFLAGS: 00000246 ORIG_RAX: 000000000000003b
>> RAX: ffffffffffffffda RBX: 00007ff3a8de5fa0 RCX: 00007ff3a8b8f749
>> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000200000000400
>> RBP: 00007ff3a8c13f91 R08: 0000000000000000 R09: 0000000000000000
>> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
>> R13: 00007ff3a8de6038 R14: 00007ff3a8de5fa0 R15: 00007ff3a8f0fa28
>>  </TASK>
>>
>> Add a separate lock just for the tctx_list, tctx_lock. This can nest
>> under ->uring_lock, where necessary, and be used separately for list
>> manipulation. For the cancelation off exec side, this removes the
>> need to grab ->uring_lock, hence fixing the circular locking
>> dependency.
>>
>> Reported-by: syzbot+b0e3b77ffaa8a4067ce5@syzkaller.appspotmail.com
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>
>> ---
>>
>> v2: ensure task is running before grabbing nested tctx_lock
>>
>> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
>> index e1adb0d20a0a..a3e8ddc9b380 100644
>> --- a/include/linux/io_uring_types.h
>> +++ b/include/linux/io_uring_types.h
>> @@ -424,11 +424,17 @@ struct io_ring_ctx {
>>  	struct user_struct		*user;
>>  	struct mm_struct		*mm_account;
>>  
>> +	/*
>> +	 * List of tctx nodes for this ctx, protected by tctx_lock. For
>> +	 * cancelation purposes, nests under uring_lock.
>> +	 */
>> +	struct list_head		tctx_list;
>> +	struct mutex			tctx_lock;
>> +
>>  	/* ctx exit and cancelation */
>>  	struct llist_head		fallback_llist;
>>  	struct delayed_work		fallback_work;
>>  	struct work_struct		exit_work;
>> -	struct list_head		tctx_list;
>>  	struct completion		ref_comp;
>>  
>>  	/* io-wq management, e.g. thread count */
>> diff --git a/io_uring/cancel.c b/io_uring/cancel.c
>> index ca12ac10c0ae..07b8d852218b 100644
>> --- a/io_uring/cancel.c
>> +++ b/io_uring/cancel.c
>> @@ -184,7 +184,9 @@ static int __io_async_cancel(struct io_cancel_data *cd,
>>  	} while (1);
>>  
>>  	/* slow path, try all io-wq's */
>> +	__set_current_state(TASK_RUNNING);
> 
> I was scratching my head over this, until I saw the syszbot report in
> your v1. ok, This silents it. But I still don't get why this would
> happen in the first place, how come we are not in TASK_RUNNING here?
> What am I missing?

Maybe I should've mentioned that... The path is:

io_sync_cancel() (which already holds ->uring_lock)
	prepare_to_wait(..., TASK_INTERRUPTIBLE) (now != TASK_RUNNING)
	__io_sync_cancel()
		__io_async_cancel()
			io_ring_submit_lock() (does nothing, as it's locked)
			mutex_lock(&ctx->tctx_lock); < complaint

As opposed to the other double locks, this one already has ->uring_lock
grabbed, and then enters __io_async_cancel() with TASK_INTERRUPTIBLE and
tries to grab ->tctx_lock. Which lockdep then complains about.

-- 
Jens Axboe

