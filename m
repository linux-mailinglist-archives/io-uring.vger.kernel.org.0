Return-Path: <io-uring+bounces-5436-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 777469ECB89
	for <lists+io-uring@lfdr.de>; Wed, 11 Dec 2024 12:46:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1ECAE188A5A6
	for <lists+io-uring@lfdr.de>; Wed, 11 Dec 2024 11:46:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68B5E238E32;
	Wed, 11 Dec 2024 11:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aT1Zl6bJ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yb1-f180.google.com (mail-yb1-f180.google.com [209.85.219.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 217D0238E0F;
	Wed, 11 Dec 2024 11:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733917598; cv=none; b=V6iR+261YhjRtjgDGAy+IY/IswYtaivmyNbo9AV+g5n188hODivjU636U347/QR8C8IEIPKaXlAETQQpzwQLXd552eSligejkRkyuV6XxwUykis69SfB1tfW7LTn26ZroYkLEofpV4Nd3SOxF9AsT8I9i5uRLnkSe8+jfU1vRqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733917598; c=relaxed/simple;
	bh=zDtqtHSzU+HGgJQPZx044iADiBuKiJuzC8p/X23W4Yk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FmwYHHiP94UE3fLskG9dEM2CK+oN6lwmgNp7Pba9qLLn5xuezCAn5lPN32Qcjc44M4DZdFvWjmpWysY0LN0BQY1fVJ7zu2TGv9kSldxcsvW5kvNk/NK2fe9OjlkwVj66j+T0go32TP2UfkSAca3HZpI1abIPTNIWj9seLTWczB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aT1Zl6bJ; arc=none smtp.client-ip=209.85.219.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yb1-f180.google.com with SMTP id 3f1490d57ef6-e39f43344c5so6111517276.1;
        Wed, 11 Dec 2024 03:46:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733917595; x=1734522395; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w5D96SRj9jglkN0dqEzyp7zP2piK7fg62skqOU4zGhQ=;
        b=aT1Zl6bJHZX/i+r9shnURyOmneevjQ5mdeLwQ01FYiAwEzTPueIm/oOgcGzoVYgLMf
         TV6GPOaEcW8WWT/thunRBGkMG2v0b7496FegTwk6CySJVQiELp/euan7qrLnRhn0DkGa
         +xoNpbbAHIhtYO7EsOuRboZyn6e0i9z1N87jTHSYImHl0FqWOCOQDl4iazDCwrDdBsxk
         ckj4ynbPLbE9NPReVpOdTCuZaVjMHJv3J3GhY5II142pqZT+rdcmwBxj9Y5cGZO7Huo6
         41+u4wVKrPcbGiFnoV8SbSnEuwX/4GodWP1u/JlBnTST+J3IKSQHzZOeEMQFiOyKjeeV
         Y7mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733917595; x=1734522395;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w5D96SRj9jglkN0dqEzyp7zP2piK7fg62skqOU4zGhQ=;
        b=e39DXDMA+vpQDJ3AzpcDH55R2lcQ7r5h5Gj6Ed7mZQs8UDVXmDKlzzw5Cu+5FhmyNY
         v33PMNT7r4Wv4SpW+3nm3CrVa2XGXG9K4ARpNdgXKsyvP8UZ97Xj2yugVSiliLlt0wuh
         I7BaBG+0ja+zvCfV/Wl4Kb0i9kpyOrsc7HMqmr4kDuggGVx4rzVQpALkTp9qJKiN0AGE
         gRFJwOiJ5n+/IQ3ypeqXM/7gP5aZU1ishG7xcUAQlMRM4HdoHaUcy5hz8sGLBdpVAShy
         uMNz6CpjL3MYdmnBVwgOQM37pzoNFlMqBnauDHR+wrBl8e2/no93/tc9o4TQ0dDbbcNu
         uaqA==
X-Forwarded-Encrypted: i=1; AJvYcCWurvfxfEuUI/JnAcxq3P7gBx2Sd24Jxut4SOfA8Wfg1EEOJw81QNr78yT9v8B5vz5flSVKqLclAyD1X92J@vger.kernel.org, AJvYcCX3mBeq9jcfv+98y8w4LwIkZWafA6RRTEmMJ0EBZFJhdheAaawCZA0QMwqRku4MSUi866a9KtW3tA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwEyTCuDbdeS31nc277xByy8EJ/tBxPi9a4h6KdJpfGXeGkslf4
	K2evQMhhbh2WpM5Tkdo1/NL6M1zCrorMDraSamF8gOYcIklDheQ0ViDO6LbU6uVrJ/Nl7xPopKW
	/7IAgcB3TU+nN3rAGzi7IIJ4SERI=
X-Gm-Gg: ASbGncvJKGYyV2OutAPLnYOCru/IKyrFLt7VVcLJEatwrXK5NxF4LJR6mvEfe7lcFJb
	gYgLHJRQ7EJ5BAwdGmGXAweR+4VnbYRYvk7fATVx2Dc60MxmgWmCuHZF6EOy71EPS9vx+ew==
X-Google-Smtp-Source: AGHT+IGkJwaPIlNzWyRQlrcbT1+dqY3WwpdO/YvDEolz+UuM0NCmjJY9Yfm92nUPP8HmotysT6QHOD9Vt29DrQ9xVlk=
X-Received: by 2002:a05:6902:2481:b0:e38:b34d:121f with SMTP id
 3f1490d57ef6-e3c8e45ca3dmr2705381276.15.1733917594768; Wed, 11 Dec 2024
 03:46:34 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CADZouDRFJ9jtXHqkX-PTKeT=GxSwdMC42zEsAKR34psuG9tUMQ@mail.gmail.com>
 <1a779207-4fa8-4b8e-95d7-e0568791e6ac@kernel.dk>
In-Reply-To: <1a779207-4fa8-4b8e-95d7-e0568791e6ac@kernel.dk>
From: chase xd <sl1589472800@gmail.com>
Date: Wed, 11 Dec 2024 12:46:23 +0100
Message-ID: <CADZouDQEe6gZgobLOAR+oy1u+Xjc4js=KW164n0ha7Yv+gma=g@mail.gmail.com>
Subject: Re: possible deadlock in __wake_up_common_lock
To: Jens Axboe <axboe@kernel.dk>
Cc: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, the same payload triggers another deadlock scene with the fix:


[   52.511552][ T6505]
[   52.511814][ T6505] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
[   52.512391][ T6505] WARNING: possible recursive locking detected
[   52.512960][ T6505] 6.1.119-dirty #4 Not tainted
[   52.513403][ T6505] --------------------------------------------
[   52.513971][ T6505] a.out/6505 is trying to acquire lock:
[   52.514442][ T6505] ffff888020d36378 (&ctx->cq_wait){....}-{2:2},
at: __wake_up_common_lock+0xb8/0x140
[   52.515193][ T6505]
[   52.515193][ T6505] but task is already holding lock:
[   52.515762][ T6505] ffff888020d36378 (&ctx->cq_wait){....}-{2:2},
at: __wake_up_common_lock+0xb8/0x140
[   52.516505][ T6505]
[   52.516505][ T6505] other info that might help us debug this:
[   52.517133][ T6505]  Possible unsafe locking scenario:
[   52.517133][ T6505]
[   52.517711][ T6505]        CPU0
[   52.517969][ T6505]        ----
[   52.518229][ T6505]   lock(&ctx->cq_wait);
[   52.518561][ T6505]   lock(&ctx->cq_wait);
[   52.518922][ T6505]
[   52.518922][ T6505]  *** DEADLOCK ***
[   52.518922][ T6505]
[   52.519670][ T6505]  May be due to missing lock nesting notation
[   52.519670][ T6505]
[   52.520440][ T6505] 2 locks held by a.out/6505:
[   52.520857][ T6505]  #0: ffff888020d360a8
(&ctx->uring_lock){+.+.}-{3:3}, at:
__do_sys_io_uring_enter+0x8fc/0x2130
[   52.521678][ T6505]  #1: ffff888020d36378
(&ctx->cq_wait){....}-{2:2}, at: __wake_up_common_lock+0xb8/0x140
[   52.522445][ T6505]
[   52.522445][ T6505] stack backtrace:
[   52.522903][ T6505] CPU: 1 PID: 6505 Comm: a.out Not tainted 6.1.119-dir=
ty #4
[   52.523470][ T6505] Hardware name: QEMU Standard PC (i440FX + PIIX,
1996), BIOS 1.15.0-1 04/01/2014
[   52.524188][ T6505] Call Trace:
[   52.524469][ T6505]  <TASK>
[   52.524705][ T6505]  dump_stack_lvl+0x5b/0x85
[   52.525069][ T6505]  __lock_acquire.cold+0x219/0x3bd
[   52.525472][ T6505]  ? lockdep_hardirqs_on_prepare+0x420/0x420
[   52.525940][ T6505]  lock_acquire+0x1e3/0x5e0
[   52.526293][ T6505]  ? __wake_up_common_lock+0xb8/0x140
[   52.526711][ T6505]  ? lock_release+0x7c0/0x7c0
[   52.527078][ T6505]  ? lockdep_hardirqs_on_prepare+0x420/0x420
[   52.527545][ T6505]  ? hlock_class+0x4e/0x130
[   52.527898][ T6505]  ? __lock_acquire+0x1291/0x3650
[   52.528298][ T6505]  _raw_spin_lock_irqsave+0x3d/0x60
[   52.528707][ T6505]  ? __wake_up_common_lock+0xb8/0x140
[   52.529206][ T6505]  __wake_up_common_lock+0xb8/0x140
[   52.529693][ T6505]  ? __wake_up_common+0x650/0x650
[   52.530163][ T6505]  ? __io_req_task_work_add+0x2f6/0xd60
[   52.530678][ T6505]  __io_req_task_work_add+0x4a4/0xd60
[   52.531176][ T6505]  io_poll_wake+0x3cb/0x550
[   52.531601][ T6505]  __wake_up_common+0x14c/0x650
[   52.532059][ T6505]  __wake_up_common_lock+0xd4/0x140
[   52.532541][ T6505]  ? __wake_up_common+0x650/0x650
[   52.533007][ T6505]  ? lock_downgrade+0x6f0/0x6f0
[   52.533460][ T6505]  ? rwlock_bug.part.0+0x90/0x90
[   52.533919][ T6505]  ? io_arm_poll_handler+0x679/0xd70
[   52.534410][ T6505]  __io_submit_flush_completions+0x778/0xba0
[   52.534877][ T6505]  ? __sanitizer_cov_trace_switch+0x4e/0x90
[   52.535340][ T6505]  ? io_submit_sqes+0xa78/0x1ce0
[   52.535726][ T6505]  io_submit_sqes+0xa78/0x1ce0
[   52.536107][ T6505]  __do_sys_io_uring_enter+0x907/0x2130
[   52.536539][ T6505]  ? find_held_lock+0x2d/0x120
[   52.536913][ T6505]  ? io_run_task_work_sig+0x190/0x190
[   52.537331][ T6505]  ? rcu_is_watching+0x12/0xc0
[   52.537705][ T6505]  ? __do_sys_io_uring_register+0x10a/0x1310
[   52.538171][ T6505]  ? io_run_local_work+0x70/0x70
[   52.538557][ T6505]  ? lockdep_hardirqs_on_prepare+0x17f/0x420
[   52.539033][ T6505]  ? syscall_enter_from_user_mode+0xa7/0x140
[   52.539504][ T6505]  do_syscall_64+0x3a/0xb0
[   52.539852][ T6505]  entry_SYSCALL_64_after_hwframe+0x6e/0xd8
[   52.540343][ T6505] RIP: 0033:0x7fe9e68ed719
[   52.540706][ T6505] Code: 08 89 e8 5b 5d c3 66 2e 0f 1f 84 00 00 00
00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b
4c 28
[   52.542316][ T6505] RSP: 002b:00007ffc120f1ba8 EFLAGS: 00000216
ORIG_RAX: 00000000000001aa
[   52.543011][ T6505] RAX: ffffffffffffffda RBX: 00007ffc120f1ce8
RCX: 00007fe9e68ed719
[   52.543651][ T6505] RDX: 0000000000000000 RSI: 000000000000331b
RDI: 0000000000000003
[   52.544315][ T6505] RBP: 00007ffc120f1bd0 R08: 0000000000000000
R09: 0000000000000000
[   52.544988][ T6505] R10: 0000000000000000 R11: 0000000000000216
R12: 0000000000000000
[   52.545640][ T6505] R13: 00007ffc120f1cf8 R14: 000056073c9e1dd8
R15: 00007fe9e6a06020
[   52.546299][ T6505]  </TASK>
[  157.556099][    C0] rcu: INFO: rcu_preempt detected stalls on CPUs/tasks=
:
[  157.556774][    C0] rcu:     1-...!: (1 GPs behind)
idle=3D2104/1/0x4000000000000000 softirq=3D11084/11090 fqs=3D1
[  157.557694][    C0]  (detected by 0, t=3D10505 jiffies, g=3D3593, q=3D12=
3 ncpus=3D2)
[  157.558297][    C0] Sending NMI from CPU 0 to CPUs 1:
[  157.558745][    C1] NMI backtrace for cpu 1
[  157.558750][    C1] CPU: 1 PID: 6505 Comm: a.out Not tainted 6.1.119-dir=
ty #4
[  157.558758][    C1] Hardware name: QEMU Standard PC (i440FX + PIIX,
1996), BIOS 1.15.0-1 04/01/2014
[  157.558760][    C1] RIP: 0010:native_queued_spin_lock_slowpath+0x128/0x9=
a0
[  157.558775][    C1] Code: 00 00 00 65 48 2b 04 25 28 00 00 00 0f 85
0d 08 00 00 48 81 c4 88 00 00 00 5b 5d 41 5c 41 5d 41 5e 41 5f c3 cc
cc c0
[  157.558777][    C1] RSP: 0018:ffffc9000e947788 EFLAGS: 00000002
[  157.558780][    C1] RAX: 0000000000000000 RBX: 0000000000000001
RCX: ffffffff8920a35b
[  157.558782][    C1] RDX: ffffed10041a6c6d RSI: 0000000000000004
RDI: ffff888020d36360
[  157.558783][    C1] RBP: ffff888020d36360 R08: 0000000000000000
R09: ffff888020d36363
[  157.558784][    C1] R10: ffffed10041a6c6c R11: 3e4b5341542f3c20
R12: 0000000000000003
[  157.558785][    C1] R13: ffffed10041a6c6c R14: 0000000000000001
R15: 1ffff92001d28ef2
[  157.558788][    C1] FS:  00007fe9e67e9740(0000)
GS:ffff88807ec00000(0000) knlGS:0000000000000000
[  157.558791][    C1] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  157.558792][    C1] CR2: 00000000200024c0 CR3: 000000004d418000
CR4: 00000000000006e0
[  157.558794][    C1] Call Trace:
[  157.558807][    C1]  <NMI>
[  157.558810][    C1]  ? nmi_cpu_backtrace.cold+0x30/0x10c
[  157.558814][    C1]  ? nmi_cpu_backtrace_handler+0xc/0x20
[  157.558817][    C1]  ? nmi_handle+0x166/0x440
[  157.558820][    C1]  ? native_queued_spin_lock_slowpath+0x128/0x9a0
[  157.558822][    C1]  ? default_do_nmi+0x6c/0x170
[  157.558825][    C1]  ? exc_nmi+0xeb/0x110
[  157.558827][    C1]  ? end_repeat_nmi+0x16/0x67
[  157.558830][    C1]  ? native_queued_spin_lock_slowpath+0xab/0x9a0
[  157.558832][    C1]  ? native_queued_spin_lock_slowpath+0x128/0x9a0
[  157.558834][    C1]  ? native_queued_spin_lock_slowpath+0x128/0x9a0
[  157.558836][    C1]  ? native_queued_spin_lock_slowpath+0x128/0x9a0
[  157.558838][    C1]  </NMI>
[  157.558839][    C1]  <TASK>
[  157.558840][    C1]  ? __pv_queued_spin_lock_slowpath+0xb80/0xb80
[  157.558841][    C1]  ? lock_acquire+0x1e3/0x5e0
[  157.558845][    C1]  do_raw_spin_lock+0x211/0x2c0
[  157.558851][    C1]  ? rwlock_bug.part.0+0x90/0x90
[  157.558853][    C1]  ? __lock_acquire+0x1291/0x3650
[  157.558855][    C1]  _raw_spin_lock_irqsave+0x45/0x60
[  157.558859][    C1]  ? __wake_up_common_lock+0xb8/0x140
[  157.558861][    C1]  __wake_up_common_lock+0xb8/0x140
[  157.558863][    C1]  ? __wake_up_common+0x650/0x650
[  157.558867][    C1]  ? __io_req_task_work_add+0x2f6/0xd60
[  157.558871][    C1]  __io_req_task_work_add+0x4a4/0xd60
[  157.558881][    C1]  io_poll_wake+0x3cb/0x550
[  157.558884][    C1]  __wake_up_common+0x14c/0x650
[  157.558886][    C1]  __wake_up_common_lock+0xd4/0x140
[  157.558888][    C1]  ? __wake_up_common+0x650/0x650
[  157.558890][    C1]  ? lock_downgrade+0x6f0/0x6f0
[  157.558892][    C1]  ? rwlock_bug.part.0+0x90/0x90
[  157.558894][    C1]  ? io_arm_poll_handler+0x679/0xd70
[  157.558897][    C1]  __io_submit_flush_completions+0x778/0xba0
[  157.558900][    C1]  ? __sanitizer_cov_trace_switch+0x4e/0x90
[  157.558905][    C1]  ? io_submit_sqes+0xa78/0x1ce0
[  157.558906][    C1]  io_submit_sqes+0xa78/0x1ce0
[  157.558910][    C1]  __do_sys_io_uring_enter+0x907/0x2130
[  157.558913][    C1]  ? find_held_lock+0x2d/0x120
[  157.558915][    C1]  ? io_run_task_work_sig+0x190/0x190
[  157.558917][    C1]  ? rcu_is_watching+0x12/0xc0
[  157.558920][    C1]  ? __do_sys_io_uring_register+0x10a/0x1310
[  157.558922][    C1]  ? io_run_local_work+0x70/0x70
[  157.558924][    C1]  ? lockdep_hardirqs_on_prepare+0x17f/0x420
[  157.558926][    C1]  ? syscall_enter_from_user_mode+0xa7/0x140
[  157.558929][    C1]  do_syscall_64+0x3a/0xb0
[  157.558931][    C1]  entry_SYSCALL_64_after_hwframe+0x6e/0xd8
[  157.558933][    C1] RIP: 0033:0x7fe9e68ed719
[  157.558948][    C1] Code: 08 89 e8 5b 5d c3 66 2e 0f 1f 84 00 00 00
00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b
4c 28
[  157.558950][    C1] RSP: 002b:00007ffc120f1ba8 EFLAGS: 00000216
ORIG_RAX: 00000000000001aa
[  157.558956][    C1] RAX: ffffffffffffffda RBX: 00007ffc120f1ce8
RCX: 00007fe9e68ed719
[  157.558957][    C1] RDX: 0000000000000000 RSI: 000000000000331b
RDI: 0000000000000003
[  157.558958][    C1] RBP: 00007ffc120f1bd0 R08: 0000000000000000
R09: 0000000000000000
[  157.558959][    C1] R10: 0000000000000000 R11: 0000000000000216
R12: 0000000000000000
[  157.558960][    C1] R13: 00007ffc120f1cf8 R14: 000056073c9e1dd8
R15: 00007fe9e6a06020
[  157.558962][    C1]  </TASK>
[  157.559721][    C0] rcu: rcu_preempt kthread starved for 10500
jiffies! g3593 f0x0 RCU_GP_WAIT_FQS(5) ->state=3D0x0 ->cpu=3D0
[  157.598366][    C0] rcu:     Unless rcu_preempt kthread gets
sufficient CPU time, OOM is now expected behavior.
[  157.599182][    C0] rcu: RCU grace-period kthread stack dump:
[  157.599640][    C0] task:rcu_preempt     state:R  running task
stack:28016 pid:18    ppid:2      flags:0x00004000
[  157.600500][    C0] Call Trace:
[  157.600764][    C0]  <TASK>
[  157.600996][    C0]  __schedule+0xbe8/0x56e0
[  157.601374][    C0]  ? rcu_is_watching+0x12/0xc0
[  157.601827][    C0]  ? io_schedule_timeout+0x160/0x160
[  157.602293][    C0]  ? rcu_is_watching+0x12/0xc0
[  157.602677][    C0]  ? lockdep_init_map_type+0x2cb/0x7d0
[  157.603171][    C0]  schedule+0xe7/0x1c0
[  157.603529][    C0]  schedule_timeout+0x101/0x240
[  157.603928][    C0]  ? usleep_range_state+0x190/0x190
[  157.604377][    C0]  ? do_init_timer+0x110/0x110
[  157.604790][    C0]  ? _raw_spin_unlock_irqrestore+0x41/0x70
[  157.605292][    C0]  ? prepare_to_swait_event+0xf5/0x490
[  157.605722][    C0]  rcu_gp_fqs_loop+0x190/0xa20
[  157.606095][    C0]  ? rcu_dump_cpu_stacks+0x470/0x470
[  157.606562][    C0]  ? lockdep_hardirqs_on_prepare+0x17f/0x420
[  157.607045][    C0]  rcu_gp_kthread+0x279/0x380
[  157.607416][    C0]  ? rcu_gp_init+0x13f0/0x13f0
[  157.607799][    C0]  ? _raw_spin_unlock_irqrestore+0x58/0x70
[  157.608253][    C0]  ? __kthread_parkme+0xc4/0x200
[  157.608647][    C0]  ? rcu_gp_init+0x13f0/0x13f0
[  157.609019][    C0]  kthread+0x24e/0x2e0
[  157.609336][    C0]  ? _raw_spin_unlock_irq+0x23/0x50
[  157.609742][    C0]  ? kthread_complete_and_exit+0x20/0x20
[  157.610179][    C0]  ret_from_fork+0x22/0x30
[  157.610531][    C0]  </TASK>
[  157.610770][    C0] rcu: Stack dump where RCU GP kthread last ran:
[  157.611261][    C0] CPU: 0 PID: 624 Comm: kworker/u5:4 Not tainted
6.1.119-dirty #4
[  157.611868][    C0] Hardware name: QEMU Standard PC (i440FX + PIIX,
1996), BIOS 1.15.0-1 04/01/2014
[  157.612760][    C0] Workqueue: events_unbound toggle_allocation_gate
[  157.613274][    C0] RIP: 0010:smp_call_function_many_cond+0x350/0xcf0
[  157.613787][    C0] Code: d0 7c 08 84 d2 0f 85 b5 08 00 00 41 8b 46
08 a8 01 74 2f 48 89 ca 49 89 cf 48 c1 ea 03 41 83 e7 07 48 01 da 41
83 c1
[  157.615290][    C0] RSP: 0018:ffffc900039f79b0 EFLAGS: 00000202
[  157.615767][    C0] RAX: 0000000000000011 RBX: dffffc0000000000
RCX: ffff88807ec420c8
[  157.616423][    C0] RDX: ffffed100fd88419 RSI: 1ffff110059879c9
RDI: ffffffff8b399968
[  157.617053][    C0] RBP: 0000000000000200 R08: 0000000000000000
R09: 0000000000000000
[  157.617755][    C0] R10: ffffed10059879ca R11: 0000000000000000
R12: 0000000000000001
[  157.618462][    C0] R13: ffff88802cc3ce48 R14: ffff88807ec420c0
R15: 0000000000000003
[  157.619112][    C0] FS:  0000000000000000(0000)
GS:ffff88802cc00000(0000) knlGS:0000000000000000
[  157.619835][    C0] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  157.620346][    C0] CR2: 000056339ab60690 CR3: 000000000b68e000
CR4: 00000000000006f0
[  157.621009][    C0] Call Trace:
[  157.621267][    C0]  <IRQ>
[  157.621491][    C0]  ? rcu_check_gp_kthread_starvation.cold+0x1d3/0x1d5
[  157.622024][    C0]  ? do_raw_spin_unlock+0x54/0x230
[  157.622448][    C0]  ? rcu_sched_clock_irq+0x2408/0x2460
[  157.622881][    C0]  ? rcu_note_context_switch+0x1870/0x1870
[  157.623334][    C0]  ? _raw_spin_unlock_irqrestore+0x41/0x70
[  157.623796][    C0]  ? timekeeping_advance+0x651/0x920
[  157.624256][    C0]  ? rwlock_bug.part.0+0x90/0x90
[  157.624706][    C0]  ? change_clocksource+0x250/0x250
[  157.625147][    C0]  ? hrtimer_run_queues+0x21/0x3c0
[  157.625582][    C0]  ? tick_sched_do_timer+0x280/0x280
[  157.626000][    C0]  ? update_process_times+0xe8/0x160
[  157.626416][    C0]  ? tick_sched_handle+0x6f/0x130
[  157.626827][    C0]  ? tick_sched_timer+0xb2/0xd0
[  157.627261][    C0]  ? __hrtimer_run_queues+0x193/0xb30
[  157.627732][    C0]  ? enqueue_hrtimer+0x340/0x340
[  157.628129][    C0]  ? kvm_clock_get_cycles+0x18/0x30
[  157.628543][    C0]  ? hrtimer_interrupt+0x2f9/0x790
[  157.628943][    C0]  ? __local_bh_enable+0x7b/0x90
[  157.629331][    C0]  ? __sysvec_apic_timer_interrupt+0x18e/0x560
[  157.629876][    C0]  ? sysvec_apic_timer_interrupt+0xa3/0xc0
[  157.630420][    C0]  </IRQ>
[  157.630688][    C0]  <TASK>
[  157.630942][    C0]  ? asm_sysvec_apic_timer_interrupt+0x1a/0x20
[  157.631459][    C0]  ? smp_call_function_many_cond+0x350/0xcf0
[  157.632004][    C0]  ? optimize_nops+0x2e0/0x2e0
[  157.632402][    C0]  ? __kmem_cache_alloc_node+0xb5/0x2e0
[  157.632869][    C0]  ? smp_call_on_cpu+0x210/0x210
[  157.633281][    C0]  ? text_poke_memset+0x60/0x60
[  157.633693][    C0]  ? optimize_nops+0x2e0/0x2e0
[  157.634098][    C0]  on_each_cpu_cond_mask+0x3b/0x70
[  157.634561][    C0]  ? __kmem_cache_alloc_node+0xb5/0x2e0
[  157.635020][    C0]  text_poke_bp_batch+0x1c5/0x5d0
[  157.635456][    C0]  ? alternatives_enable_smp+0xe0/0xe0
[  157.635915][    C0]  ? __jump_label_patch+0x28c/0x330
[  157.636335][    C0]  ? arch_jump_label_transform_queue+0xa5/0x110
[  157.636836][    C0]  text_poke_finish+0x1a/0x30
[  157.637238][    C0]  arch_jump_label_transform_apply+0x17/0x30
[  157.637704][    C0]  static_key_enable_cpuslocked+0x167/0x230
[  157.638167][    C0]  static_key_enable+0x15/0x20
[  157.638539][    C0]  toggle_allocation_gate+0xeb/0x310
[  157.638953][    C0]  ? wake_up_kfence_timer+0x20/0x20
[  157.639399][    C0]  ? sched_core_balance+0xe80/0xe80
[  157.639858][    C0]  ? read_word_at_a_time+0xe/0x20
[  157.640284][    C0]  process_one_work+0x88c/0x1490
[  157.640687][    C0]  ? lock_release+0x7c0/0x7c0
[  157.641095][    C0]  ? pwq_dec_nr_in_flight+0x230/0x230
[  157.641569][    C0]  ? rwlock_bug.part.0+0x90/0x90
[  157.642010][    C0]  worker_thread+0x59f/0xed0
[  157.642419][    C0]  ? process_one_work+0x1490/0x1490
[  157.642875][    C0]  kthread+0x24e/0x2e0
[  157.643204][    C0]  ? _raw_spin_unlock_irq+0x23/0x50
[  157.643637][    C0]  ? kthread_complete_and_exit+0x20/0x20
[  157.644146][    C0]  ret_from_fork+0x22/0x30
[  157.644562][    C0]  </TASK>

On Mon, Dec 9, 2024 at 3:59=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 12/9/24 5:03 AM, chase xd wrote:
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > WARNING: possible recursive locking detected
> > 6.1.119-dirty #3 Not tainted
> > --------------------------------------------
> > syz-executor199/6820 is trying to acquire lock:
> > ffff88807c386378 (&ctx->cq_wait){....}-{2:2}, at:
> > __wake_up_common_lock+0xb8/0x140 kernel/sched/wait.c:137
> >
> > but task is already holding lock:
> > ffff88807c386378 (&ctx->cq_wait){....}-{2:2}, at:
> > __wake_up_common_lock+0xb8/0x140 kernel/sched/wait.c:137
> >
> > other info that might help us debug this:
> >  Possible unsafe locking scenario:
> >
> >        CPU0
> >        ----
> >   lock(&ctx->cq_wait);
> >   lock(&ctx->cq_wait);
> >
> >  *** DEADLOCK ***
> >
> >  May be due to missing lock nesting notation
> >
> > 2 locks held by syz-executor199/6820:
> >  #0: ffff88807c3860a8 (&ctx->uring_lock){+.+.}-{3:3}, at:
> > __do_sys_io_uring_enter+0x8fc/0x2130 io_uring/io_uring.c:3313
> >  #1: ffff88807c386378 (&ctx->cq_wait){....}-{2:2}, at:
> > __wake_up_common_lock+0xb8/0x140 kernel/sched/wait.c:137
> >
> > stack backtrace:
> > CPU: 7 PID: 6820 Comm: syz-executor199 Not tainted 6.1.119-dirty #3
> > Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04=
/01/2014
> > Call Trace:
> >  <TASK>
> >  __dump_stack lib/dump_stack.c:88 [inline]
> >  dump_stack_lvl+0x5b/0x85 lib/dump_stack.c:106
> >  print_deadlock_bug kernel/locking/lockdep.c:2983 [inline]
> >  check_deadlock kernel/locking/lockdep.c:3026 [inline]
> >  validate_chain kernel/locking/lockdep.c:3812 [inline]
> >  __lock_acquire.cold+0x219/0x3bd kernel/locking/lockdep.c:5049
> >  lock_acquire kernel/locking/lockdep.c:5662 [inline]
> >  lock_acquire+0x1e3/0x5e0 kernel/locking/lockdep.c:5627
> >  __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
> >  _raw_spin_lock_irqsave+0x3d/0x60 kernel/locking/spinlock.c:162
> >  __wake_up_common_lock+0xb8/0x140 kernel/sched/wait.c:137
> >  __io_cqring_wake io_uring/io_uring.h:224 [inline]
> >  __io_cqring_wake io_uring/io_uring.h:211 [inline]
> >  io_req_local_work_add io_uring/io_uring.c:1135 [inline]
> >  __io_req_task_work_add+0x4a4/0xd60 io_uring/io_uring.c:1146
> >  io_poll_wake+0x3cb/0x550 io_uring/poll.c:465
> >  __wake_up_common+0x14c/0x650 kernel/sched/wait.c:107
> >  __wake_up_common_lock+0xd4/0x140 kernel/sched/wait.c:138
> >  __io_cqring_wake io_uring/io_uring.h:224 [inline]
> >  __io_cqring_wake io_uring/io_uring.h:211 [inline]
> >  io_cqring_wake io_uring/io_uring.h:231 [inline]
> >  io_cqring_ev_posted io_uring/io_uring.c:578 [inline]
> >  __io_cq_unlock_post io_uring/io_uring.c:586 [inline]
> >  __io_submit_flush_completions+0x778/0xba0 io_uring/io_uring.c:1346
> >  io_submit_flush_completions io_uring/io_uring.c:159 [inline]
> >  io_submit_state_end io_uring/io_uring.c:2203 [inline]
> >  io_submit_sqes+0xa78/0x1ce0 io_uring/io_uring.c:2317
> >  __do_sys_io_uring_enter+0x907/0x2130 io_uring/io_uring.c:3314
> >  do_syscall_x64 arch/x86/entry/common.c:51 [inline]
> >  do_syscall_64+0x3a/0xb0 arch/x86/entry/common.c:81
> >  entry_SYSCALL_64_after_hwframe+0x6e/0xd8
> > RIP: 0033:0x7fa54e70640d
> > Code: 28 c3 e8 46 1e 00 00 66 0f 1f 44 00 00 f3 0f 1e fa 48 89 f8 48
> > 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
> > 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
> > RSP: 002b:00007ffd0ad80be8 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
> > RAX: ffffffffffffffda RBX: 00007ffd0ad80df8 RCX: 00007fa54e70640d
> > RDX: 0000000000000000 RSI: 000000000000331b RDI: 0000000000000003
> > RBP: 0000000000000001 R08: 0000000000000000 R09: 0000000000000000
> > R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000001
> > R13: 00007ffd0ad80de8 R14: 00007fa54e783530 R15: 0000000000000001
> >  </TASK>
>
> I think this backport of:
>
> 3181e22fb799 ("io_uring: wake up optimisations")
>
> should fix that. Can you try?
>
>
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 4f0ae938b146..0b1361663267 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -582,6 +582,16 @@ static inline void __io_cq_unlock_post(struct io_rin=
g_ctx *ctx)
>         io_cqring_ev_posted(ctx);
>  }
>
> +static inline void __io_cq_unlock_post_flush(struct io_ring_ctx *ctx)
> +       __releases(ctx->completion_lock)
> +{
> +       io_commit_cqring(ctx);
> +       spin_unlock(&ctx->completion_lock);
> +       io_commit_cqring_flush(ctx);
> +       if (!(ctx->flags & IORING_SETUP_DEFER_TASKRUN))
> +               __io_cqring_wake(ctx);
> +}
> +
>  void io_cq_unlock_post(struct io_ring_ctx *ctx)
>  {
>         __io_cq_unlock_post(ctx);
> @@ -1339,7 +1349,7 @@ static void __io_submit_flush_completions(struct io=
_ring_ctx *ctx)
>                 if (!(req->flags & REQ_F_CQE_SKIP))
>                         __io_fill_cqe_req(ctx, req);
>         }
> -       __io_cq_unlock_post(ctx);
> +       __io_cq_unlock_post_flush(ctx);
>
>         io_free_batch_list(ctx, state->compl_reqs.first);
>         INIT_WQ_LIST(&state->compl_reqs);
>
> --
> Jens Axboe

