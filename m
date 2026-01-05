Return-Path: <io-uring+bounces-11367-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 14F25CF5371
	for <lists+io-uring@lfdr.de>; Mon, 05 Jan 2026 19:21:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id F0DAA3015A82
	for <lists+io-uring@lfdr.de>; Mon,  5 Jan 2026 18:21:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6792935977;
	Mon,  5 Jan 2026 18:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="MkoP8naZ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="kfq9IjUU";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="MkoP8naZ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="kfq9IjUU"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C8F83A1E97
	for <io-uring@vger.kernel.org>; Mon,  5 Jan 2026 18:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767637276; cv=none; b=kOtXZnHdXyEpKQMH48g17I5L2IK561HHpIrtEWUUtjcb6jpMy/+D5rJrLR+fOCyeD4hpQQ/SxbTmCMiYULzaK6Av/ZE6FmhdjDBOHY+b4r8CGjr7elP7WIOh0YMwAWJClbxCQejiueLs7ybOU0iaJYFUVk0nkG6WpauX8W8FsPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767637276; c=relaxed/simple;
	bh=xF71NL/TJhU4Z1b93TCYJwm1nhmpYfa6zphTza0Zuts=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=ahNvtIylCv4X7c5wsZPpsBovLwHFnGcOSAmQgYBYl27D5yr9rPhG1TDt/qEMLBZ0vyUNM95Dx7VpxohhKR4QIRZ1WNelakd+itgWa2PC0/3k34t2GWsN+5cW2GXJCDxMkK81gH4tjpsqtJMpmz+FrmF9zalXiHdvg0MG0YuhCp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=MkoP8naZ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=kfq9IjUU; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=MkoP8naZ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=kfq9IjUU; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 78CE833744;
	Mon,  5 Jan 2026 18:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1767637272; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tegM+mEJNXUZonIMpb/W3gYYaJJQ2+18Iv0Kxb598UU=;
	b=MkoP8naZhlBav+15E61MR6o9LpSOCsUhtGc+pKle+3ocdEwoxyk3fattZLnoTw+aDmo3VS
	d2vL9TbjM0j1CIz5Rg3XqYMotgQE9OYAsOAIYIk7cuqgt6YJBNR2pu0fOlUeKYwrwCnpb0
	lEVFROKrWWPmtkKsWbwP2e3zcJP+UgU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1767637272;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tegM+mEJNXUZonIMpb/W3gYYaJJQ2+18Iv0Kxb598UU=;
	b=kfq9IjUUyl0eCooSxlZ2GSX16jPikL6LHMikqzTGV8x97G+MP205HbQ6zanj4FWegyAm8/
	ZQYXAIDm3+Ms/yAg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1767637272; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tegM+mEJNXUZonIMpb/W3gYYaJJQ2+18Iv0Kxb598UU=;
	b=MkoP8naZhlBav+15E61MR6o9LpSOCsUhtGc+pKle+3ocdEwoxyk3fattZLnoTw+aDmo3VS
	d2vL9TbjM0j1CIz5Rg3XqYMotgQE9OYAsOAIYIk7cuqgt6YJBNR2pu0fOlUeKYwrwCnpb0
	lEVFROKrWWPmtkKsWbwP2e3zcJP+UgU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1767637272;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tegM+mEJNXUZonIMpb/W3gYYaJJQ2+18Iv0Kxb598UU=;
	b=kfq9IjUUyl0eCooSxlZ2GSX16jPikL6LHMikqzTGV8x97G+MP205HbQ6zanj4FWegyAm8/
	ZQYXAIDm3+Ms/yAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 297393EA63;
	Mon,  5 Jan 2026 18:21:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Ij1oORcBXGlcMwAAD6G6ig
	(envelope-from <krisman@suse.de>); Mon, 05 Jan 2026 18:21:11 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring <io-uring@vger.kernel.org>
Subject: Re: [PATCH v2] io_uring/tctx: add separate lock for list of tctx's
 in ctx
In-Reply-To: <24a9e751-7442-4036-9b9f-8c144918c201@kernel.dk> (Jens Axboe's
	message of "Thu, 1 Jan 2026 08:17:38 -0700")
References: <24a9e751-7442-4036-9b9f-8c144918c201@kernel.dk>
Date: Mon, 05 Jan 2026 13:20:54 -0500
Message-ID: <87tswz7wft.fsf@mailhost.krisman.be>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spamd-Result: default: False [-4.23 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.13)[-0.656];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	TO_DN_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,kernel.dk:email]
X-Spam-Level: 
X-Spam-Flag: NO
X-Spam-Score: -4.23

Jens Axboe <axboe@kernel.dk> writes:

> ctx->tcxt_list holds the tasks using this ring, and it's currently
> protected by the normal ctx->uring_lock. However, this can cause a
> circular locking issue, as reported by syzbot, where cancelations off
> exec end up needing to remove an entry from this list:
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
>
> Add a separate lock just for the tctx_list, tctx_lock. This can nest
> under ->uring_lock, where necessary, and be used separately for list
> manipulation. For the cancelation off exec side, this removes the
> need to grab ->uring_lock, hence fixing the circular locking
> dependency.
>
> Reported-by: syzbot+b0e3b77ffaa8a4067ce5@syzkaller.appspotmail.com
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>
> ---
>
> v2: ensure task is running before grabbing nested tctx_lock
>
> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
> index e1adb0d20a0a..a3e8ddc9b380 100644
> --- a/include/linux/io_uring_types.h
> +++ b/include/linux/io_uring_types.h
> @@ -424,11 +424,17 @@ struct io_ring_ctx {
>  	struct user_struct		*user;
>  	struct mm_struct		*mm_account;
>  
> +	/*
> +	 * List of tctx nodes for this ctx, protected by tctx_lock. For
> +	 * cancelation purposes, nests under uring_lock.
> +	 */
> +	struct list_head		tctx_list;
> +	struct mutex			tctx_lock;
> +
>  	/* ctx exit and cancelation */
>  	struct llist_head		fallback_llist;
>  	struct delayed_work		fallback_work;
>  	struct work_struct		exit_work;
> -	struct list_head		tctx_list;
>  	struct completion		ref_comp;
>  
>  	/* io-wq management, e.g. thread count */
> diff --git a/io_uring/cancel.c b/io_uring/cancel.c
> index ca12ac10c0ae..07b8d852218b 100644
> --- a/io_uring/cancel.c
> +++ b/io_uring/cancel.c
> @@ -184,7 +184,9 @@ static int __io_async_cancel(struct io_cancel_data *cd,
>  	} while (1);
>  
>  	/* slow path, try all io-wq's */
> +	__set_current_state(TASK_RUNNING);

I was scratching my head over this, until I saw the syszbot report in
your v1. ok, This silents it. But I still don't get why this would
happen in the first place, how come we are not in TASK_RUNNING here?
What am I missing?

-- 
Gabriel Krisman Bertazi

