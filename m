Return-Path: <io-uring+bounces-11248-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id C4210CD70E4
	for <lists+io-uring@lfdr.de>; Mon, 22 Dec 2025 21:20:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id EB9843012BF5
	for <lists+io-uring@lfdr.de>; Mon, 22 Dec 2025 20:19:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81809307492;
	Mon, 22 Dec 2025 20:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="V5Zz24Y/"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D343527E05A
	for <io-uring@vger.kernel.org>; Mon, 22 Dec 2025 20:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766434798; cv=none; b=HJ/+rwGJCM4nJcqbHGV69nxuwr7YGHH/eDk+WsGt43qcTpz99mWQXOvGOxXJdMJ9aZ3DcWFxvXpDaod+weWC7v8TqrseQOpRUY0NwRmTHMx84Cq3iNPSemOfK8u2z0MhtIOXGWTuQibtyXJNFjsIPYXo0VAjAal9CQzquYIWmOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766434798; c=relaxed/simple;
	bh=bxHfopK2zt+r6o59OBS3rvbzxkorNi2BcLeAnFHmOkY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YGeKOViHy8np55FDX3PfSRcnWBODI5MV0h0wRFbxi9prtTDGKVXUQIn+3Dh1qukBipbY1R/fSAqHQaXtJN8zoa5hxr/VqNreUNdIBIKb6RMElM9MlFnOtMa/W3TDkaYtSW0L4AN5bceQg8TOHM46nw97tTXZIulaln5Ijkkn/BI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=V5Zz24Y/; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-7d481452588so276570b3a.3
        for <io-uring@vger.kernel.org>; Mon, 22 Dec 2025 12:19:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1766434795; x=1767039595; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pBDdIE22GMRCUvzc1m4gf6dWpI8PF5BAVu5OLRbY5g4=;
        b=V5Zz24Y/0X5TjmRvPpcNigx0e/mFb8bXpm8GE2gbX+VHV0bsDTNq0JJnlyI80EuLjs
         WVYIQ5duOZdQoFnoJOIQh5lvZIUMRJNI9FOpxkKjZ1yjA27Zca4/+oBPexsCU13QR5bf
         2AgCMdNY79S+ATU8JpR/yShNVLcddNfmmkJ1itJxKndtcIp3bs4j2OmSaijNOOQAk8wn
         40Xg+an1brRzjs6aLkuedtmzS1yQiAWKTCmYqjb5dQhw7vhmPJFjBruHw9rfCOz1nrL1
         pbLSRyI0UyElvXRdp3QlwkMfGYJRXqmTXNV0ilHKFjKZiin/Tu7UDS9yHBx9uRJ8sylj
         SB2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766434795; x=1767039595;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pBDdIE22GMRCUvzc1m4gf6dWpI8PF5BAVu5OLRbY5g4=;
        b=G3T+FO+n3mCrDXSiet1HMuAXtDQSyTPQI7ITRBYAppAcwhTrt94IkH6smByiSD+3sO
         qA09HPOCHAPrktHxgYI49bK2+X9N7+x335Ud1W1P7yzT3wraGS37UVmBxPPEUSjvsTS3
         t/cWfQqoRGaliXcnywfoDV59aCuCpa9ZptG9LGzNPmwF/DPWqFamWaMFYdNOd9aHK69Z
         TaZH1JxvJxWsi4UT/JjqnQjXsBlMBUfuHWCx7wZRWwZBxD/wdZ1U7VsB4o+LGz/jWyT3
         TSPAyLQej/L8i6dwWndAK4E8uMB14K7GLp/33wg4Bub+W+h3p6VSLaH7mcUB0Ua642lJ
         ACRw==
X-Forwarded-Encrypted: i=1; AJvYcCWVxHkBTj4gffjT4oJJdEKCLUAW9l0RqZX+QM2JFn82dpU9aA6p5rl8VbAs09eUdRAE5iyQNjWWEQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzh5lkZZ4ep5mPRgZO0e8n23i0nMpUvPRxb8yEh68sOwQAFuXHl
	IaVwwCFnvidkS2TF8s/LY1ZXaglZ8avAPCB5N+L67J9HSXbZ9xxuzZzFhZG8B7VW7NmV2+tcm9Q
	26HYw+um3AAEkXoXO3cPPaDgLjLoEOjH3GAo6o8Dj5A==
X-Gm-Gg: AY/fxX7WEPsaJ4ZgZhHLfL/hdZH1CJ1JeM3y9Sv9Sb8Gwu7FL195u+6VOPqCDU3DmpO
	sxYrGg5u9ifr9nawBexqSuoQfzh9CV0MvlAp15O/PtFYpmIsllT1T5ekIQaj1ezGe5MZmmYkP0a
	e/3bayXlQj2HVtPaDQ/R++PPSAxmM7GzfGLnEItmhzt7Ic3Egfzj366bqsMT11+yUHMPGqZpC5L
	rJTeNMpS1PVEj+vK4+4Nn1/DMqDflUb0d6aDmiE7o+owTTgZfWgaBwHgGLwosRRUue45os=
X-Google-Smtp-Source: AGHT+IEIYBMlV//xl/gfRGqXYlcBEe8xqwtaSKdL7SiKbEXrCI1RLk3uBLtrIGGyDs87zwJA450OAQiBrg17hVKdq2Y=
X-Received: by 2002:a05:7022:4287:b0:11e:3e9:3ea5 with SMTP id
 a92af1059eb24-1217230117bmr7116611c88.7.1766434794739; Mon, 22 Dec 2025
 12:19:54 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251218024459.1083572-1-csander@purestorage.com> <6943b4db.a70a0220.25eec0.0028.GAE@google.com>
In-Reply-To: <6943b4db.a70a0220.25eec0.0028.GAE@google.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Mon, 22 Dec 2025 15:19:43 -0500
X-Gm-Features: AQt7F2q6vezdgnMOqw5XR9V0daYMLn_FyPpNnCwdtm6dDnGyl1_aNH2JQzONwGY
Message-ID: <CADUfDZq7MK3r6c05CohT0hMowq-gqffGid-eC1cDGKy+4aaS=A@mail.gmail.com>
Subject: Re: [syzbot ci] Re: io_uring: avoid uring_lock for IORING_SETUP_SINGLE_ISSUER
To: syzbot ci <syzbot+ci6d21afd0455de45a@syzkaller.appspotmail.com>
Cc: axboe@kernel.dk, io-uring@vger.kernel.org, joannelkoong@gmail.com, 
	linux-kernel@vger.kernel.org, oliver.sang@intel.com, 
	syzbot@syzkaller.appspotmail.com, syzbot@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 18, 2025 at 3:01=E2=80=AFAM syzbot ci
<syzbot+ci6d21afd0455de45a@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v6] io_uring: avoid uring_lock for IORING_SETUP_SINGLE_ISSUER
> https://lore.kernel.org/all/20251218024459.1083572-1-csander@purestorage.=
com
> * [PATCH v6 1/6] io_uring: use release-acquire ordering for IORING_SETUP_=
R_DISABLED
> * [PATCH v6 2/6] io_uring: clear IORING_SETUP_SINGLE_ISSUER for IORING_SE=
TUP_SQPOLL
> * [PATCH v6 3/6] io_uring: ensure submitter_task is valid for io_ring_ctx=
's lifetime
> * [PATCH v6 4/6] io_uring: use io_ring_submit_lock() in io_iopoll_req_iss=
ued()
> * [PATCH v6 5/6] io_uring: factor out uring_lock helpers
> * [PATCH v6 6/6] io_uring: avoid uring_lock for IORING_SETUP_SINGLE_ISSUE=
R
>
> and found the following issue:
> INFO: task hung in io_wq_put_and_exit
>
> Full report is available here:
> https://ci.syzbot.org/series/21eac721-670b-4f34-9696-66f9b28233ac
>
> ***
>
> INFO: task hung in io_wq_put_and_exit
>
> tree:      torvalds
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torva=
lds/linux
> base:      d358e5254674b70f34c847715ca509e46eb81e6f
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~e=
xp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/1710cffe-7d78-4489-9aa1-823b8c253=
2ed/config
> syz repro: https://ci.syzbot.org/findings/74ae8703-9484-4d82-aa78-84cc37d=
cb1ef/syz_repro
>
> INFO: task syz.1.18:6046 blocked for more than 143 seconds.
>       Not tainted syzkaller #0
>       Blocked by coredump.
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> task:syz.1.18        state:D stack:25672 pid:6046  tgid:6045  ppid:5971  =
 task_flags:0x400548 flags:0x00080004
> Call Trace:
>  <TASK>
>  context_switch kernel/sched/core.c:5256 [inline]
>  __schedule+0x14bc/0x5000 kernel/sched/core.c:6863
>  __schedule_loop kernel/sched/core.c:6945 [inline]
>  schedule+0x165/0x360 kernel/sched/core.c:6960
>  schedule_timeout+0x9a/0x270 kernel/time/sleep_timeout.c:75
>  do_wait_for_common kernel/sched/completion.c:100 [inline]
>  __wait_for_common kernel/sched/completion.c:121 [inline]
>  wait_for_common kernel/sched/completion.c:132 [inline]
>  wait_for_completion+0x2bf/0x5d0 kernel/sched/completion.c:153
>  io_wq_exit_workers io_uring/io-wq.c:1328 [inline]
>  io_wq_put_and_exit+0x316/0x650 io_uring/io-wq.c:1356
>  io_uring_clean_tctx+0x11f/0x1a0 io_uring/tctx.c:207
>  io_uring_cancel_generic+0x6ca/0x7d0 io_uring/cancel.c:652
>  io_uring_files_cancel include/linux/io_uring.h:19 [inline]
>  do_exit+0x345/0x2310 kernel/exit.c:911
>  do_group_exit+0x21c/0x2d0 kernel/exit.c:1112
>  get_signal+0x1285/0x1340 kernel/signal.c:3034
>  arch_do_signal_or_restart+0x9a/0x7a0 arch/x86/kernel/signal.c:337
>  __exit_to_user_mode_loop kernel/entry/common.c:41 [inline]
>  exit_to_user_mode_loop+0x87/0x4f0 kernel/entry/common.c:75
>  __exit_to_user_mode_prepare include/linux/irq-entry-common.h:226 [inline=
]
>  syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:256 [=
inline]
>  syscall_exit_to_user_mode_work include/linux/entry-common.h:159 [inline]
>  syscall_exit_to_user_mode include/linux/entry-common.h:194 [inline]
>  do_syscall_64+0x2e3/0xf80 arch/x86/entry/syscall_64.c:100
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f6a8b58f7c9
> RSP: 002b:00007f6a8c4a00e8 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
> RAX: 0000000000000001 RBX: 00007f6a8b7e5fa8 RCX: 00007f6a8b58f7c9
> RDX: 00000000000f4240 RSI: 0000000000000081 RDI: 00007f6a8b7e5fac
> RBP: 00007f6a8b7e5fa0 R08: 3fffffffffffffff R09: 0000000000000000
> R10: 0000000000000800 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f6a8b7e6038 R14: 00007ffcac96d220 R15: 00007ffcac96d308
>  </TASK>
> INFO: task iou-wrk-6046:6047 blocked for more than 143 seconds.
>       Not tainted syzkaller #0
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> task:iou-wrk-6046    state:D stack:27760 pid:6047  tgid:6045  ppid:5971  =
 task_flags:0x404050 flags:0x00080002
> Call Trace:
>  <TASK>
>  context_switch kernel/sched/core.c:5256 [inline]
>  __schedule+0x14bc/0x5000 kernel/sched/core.c:6863
>  __schedule_loop kernel/sched/core.c:6945 [inline]
>  schedule+0x165/0x360 kernel/sched/core.c:6960
>  schedule_timeout+0x9a/0x270 kernel/time/sleep_timeout.c:75
>  do_wait_for_common kernel/sched/completion.c:100 [inline]
>  __wait_for_common kernel/sched/completion.c:121 [inline]
>  wait_for_common kernel/sched/completion.c:132 [inline]
>  wait_for_completion+0x2bf/0x5d0 kernel/sched/completion.c:153
>  io_ring_ctx_lock_nested+0x2b3/0x380 io_uring/io_uring.h:283
>  io_ring_ctx_lock io_uring/io_uring.h:290 [inline]
>  io_ring_submit_lock io_uring/io_uring.h:554 [inline]
>  io_files_update+0x677/0x7f0 io_uring/rsrc.c:504
>  __io_issue_sqe+0x181/0x4b0 io_uring/io_uring.c:1818
>  io_issue_sqe+0x1de/0x1190 io_uring/io_uring.c:1841
>  io_wq_submit_work+0x6e9/0xb90 io_uring/io_uring.c:1953
>  io_worker_handle_work+0x7cd/0x1180 io_uring/io-wq.c:650
>  io_wq_worker+0x42f/0xeb0 io_uring/io-wq.c:704
>  ret_from_fork+0x599/0xb30 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246
>  </TASK>

Interesting, a deadlock between io_wq_exit_workers() on submitter_task
(which is exiting) and io_ring_ctx_lock() on an io_uring worker
thread. io_ring_ctx_lock() is blocked until submitter_task runs task
work, but that will never happen because it's waiting on the
completion. Not sure what the best approach is here. Maybe have the
submitter_task alternate between running task work and waiting on the
completion? Or have some way for submitter_task to indicate that it's
exiting and disable the IORING_SETUP_SINGLE_ISSUER optimization in
io_ring_ctx_lock()?

Thanks,
Caleb


> INFO: task syz.0.17:6049 blocked for more than 143 seconds.
>       Not tainted syzkaller #0
>       Blocked by coredump.
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> task:syz.0.17        state:D stack:25592 pid:6049  tgid:6048  ppid:5967  =
 task_flags:0x400548 flags:0x00080004
> Call Trace:
>  <TASK>
>  context_switch kernel/sched/core.c:5256 [inline]
>  __schedule+0x14bc/0x5000 kernel/sched/core.c:6863
>  __schedule_loop kernel/sched/core.c:6945 [inline]
>  schedule+0x165/0x360 kernel/sched/core.c:6960
>  schedule_timeout+0x9a/0x270 kernel/time/sleep_timeout.c:75
>  do_wait_for_common kernel/sched/completion.c:100 [inline]
>  __wait_for_common kernel/sched/completion.c:121 [inline]
>  wait_for_common kernel/sched/completion.c:132 [inline]
>  wait_for_completion+0x2bf/0x5d0 kernel/sched/completion.c:153
>  io_wq_exit_workers io_uring/io-wq.c:1328 [inline]
>  io_wq_put_and_exit+0x316/0x650 io_uring/io-wq.c:1356
>  io_uring_clean_tctx+0x11f/0x1a0 io_uring/tctx.c:207
>  io_uring_cancel_generic+0x6ca/0x7d0 io_uring/cancel.c:652
>  io_uring_files_cancel include/linux/io_uring.h:19 [inline]
>  do_exit+0x345/0x2310 kernel/exit.c:911
>  do_group_exit+0x21c/0x2d0 kernel/exit.c:1112
>  get_signal+0x1285/0x1340 kernel/signal.c:3034
>  arch_do_signal_or_restart+0x9a/0x7a0 arch/x86/kernel/signal.c:337
>  __exit_to_user_mode_loop kernel/entry/common.c:41 [inline]
>  exit_to_user_mode_loop+0x87/0x4f0 kernel/entry/common.c:75
>  __exit_to_user_mode_prepare include/linux/irq-entry-common.h:226 [inline=
]
>  syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:256 [=
inline]
>  syscall_exit_to_user_mode_work include/linux/entry-common.h:159 [inline]
>  syscall_exit_to_user_mode include/linux/entry-common.h:194 [inline]
>  do_syscall_64+0x2e3/0xf80 arch/x86/entry/syscall_64.c:100
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fa96a98f7c9
> RSP: 002b:00007fa96b7430e8 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
> RAX: 0000000000000001 RBX: 00007fa96abe5fa8 RCX: 00007fa96a98f7c9
> RDX: 00000000000f4240 RSI: 0000000000000081 RDI: 00007fa96abe5fac
> RBP: 00007fa96abe5fa0 R08: 3fffffffffffffff R09: 0000000000000000
> R10: 0000000000000800 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fa96abe6038 R14: 00007ffd9fcc00d0 R15: 00007ffd9fcc01b8
>  </TASK>
> INFO: task iou-wrk-6049:6050 blocked for more than 143 seconds.
>       Not tainted syzkaller #0
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> task:iou-wrk-6049    state:D stack:27760 pid:6050  tgid:6048  ppid:5967  =
 task_flags:0x404050 flags:0x00080002
> Call Trace:
>  <TASK>
>  context_switch kernel/sched/core.c:5256 [inline]
>  __schedule+0x14bc/0x5000 kernel/sched/core.c:6863
>  __schedule_loop kernel/sched/core.c:6945 [inline]
>  schedule+0x165/0x360 kernel/sched/core.c:6960
>  schedule_timeout+0x9a/0x270 kernel/time/sleep_timeout.c:75
>  do_wait_for_common kernel/sched/completion.c:100 [inline]
>  __wait_for_common kernel/sched/completion.c:121 [inline]
>  wait_for_common kernel/sched/completion.c:132 [inline]
>  wait_for_completion+0x2bf/0x5d0 kernel/sched/completion.c:153
>  io_ring_ctx_lock_nested+0x2b3/0x380 io_uring/io_uring.h:283
>  io_ring_ctx_lock io_uring/io_uring.h:290 [inline]
>  io_ring_submit_lock io_uring/io_uring.h:554 [inline]
>  io_files_update+0x677/0x7f0 io_uring/rsrc.c:504
>  __io_issue_sqe+0x181/0x4b0 io_uring/io_uring.c:1818
>  io_issue_sqe+0x1de/0x1190 io_uring/io_uring.c:1841
>  io_wq_submit_work+0x6e9/0xb90 io_uring/io_uring.c:1953
>  io_worker_handle_work+0x7cd/0x1180 io_uring/io-wq.c:650
>  io_wq_worker+0x42f/0xeb0 io_uring/io-wq.c:704
>  ret_from_fork+0x599/0xb30 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246
>  </TASK>
> INFO: task syz.2.19:6052 blocked for more than 144 seconds.
>       Not tainted syzkaller #0
>       Blocked by coredump.
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> task:syz.2.19        state:D stack:26208 pid:6052  tgid:6051  ppid:5972  =
 task_flags:0x400548 flags:0x00080004
> Call Trace:
>  <TASK>
>  context_switch kernel/sched/core.c:5256 [inline]
>  __schedule+0x14bc/0x5000 kernel/sched/core.c:6863
>  __schedule_loop kernel/sched/core.c:6945 [inline]
>  schedule+0x165/0x360 kernel/sched/core.c:6960
>  schedule_timeout+0x9a/0x270 kernel/time/sleep_timeout.c:75
>  do_wait_for_common kernel/sched/completion.c:100 [inline]
>  __wait_for_common kernel/sched/completion.c:121 [inline]
>  wait_for_common kernel/sched/completion.c:132 [inline]
>  wait_for_completion+0x2bf/0x5d0 kernel/sched/completion.c:153
>  io_wq_exit_workers io_uring/io-wq.c:1328 [inline]
>  io_wq_put_and_exit+0x316/0x650 io_uring/io-wq.c:1356
>  io_uring_clean_tctx+0x11f/0x1a0 io_uring/tctx.c:207
>  io_uring_cancel_generic+0x6ca/0x7d0 io_uring/cancel.c:652
>  io_uring_files_cancel include/linux/io_uring.h:19 [inline]
>  do_exit+0x345/0x2310 kernel/exit.c:911
>  do_group_exit+0x21c/0x2d0 kernel/exit.c:1112
>  get_signal+0x1285/0x1340 kernel/signal.c:3034
>  arch_do_signal_or_restart+0x9a/0x7a0 arch/x86/kernel/signal.c:337
>  __exit_to_user_mode_loop kernel/entry/common.c:41 [inline]
>  exit_to_user_mode_loop+0x87/0x4f0 kernel/entry/common.c:75
>  __exit_to_user_mode_prepare include/linux/irq-entry-common.h:226 [inline=
]
>  syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:256 [=
inline]
>  syscall_exit_to_user_mode_work include/linux/entry-common.h:159 [inline]
>  syscall_exit_to_user_mode include/linux/entry-common.h:194 [inline]
>  do_syscall_64+0x2e3/0xf80 arch/x86/entry/syscall_64.c:100
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f4b5cb8f7c9
> RSP: 002b:00007f4b5d9a80e8 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
> RAX: 0000000000000001 RBX: 00007f4b5cde5fa8 RCX: 00007f4b5cb8f7c9
> RDX: 00000000000f4240 RSI: 0000000000000081 RDI: 00007f4b5cde5fac
> RBP: 00007f4b5cde5fa0 R08: 3fffffffffffffff R09: 0000000000000000
> R10: 0000000000000800 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f4b5cde6038 R14: 00007ffcdd64aed0 R15: 00007ffcdd64afb8
>  </TASK>
> INFO: task iou-wrk-6052:6053 blocked for more than 144 seconds.
>       Not tainted syzkaller #0
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> task:iou-wrk-6052    state:D stack:27760 pid:6053  tgid:6051  ppid:5972  =
 task_flags:0x404050 flags:0x00080006
> Call Trace:
>  <TASK>
>  context_switch kernel/sched/core.c:5256 [inline]
>  __schedule+0x14bc/0x5000 kernel/sched/core.c:6863
>  __schedule_loop kernel/sched/core.c:6945 [inline]
>  schedule+0x165/0x360 kernel/sched/core.c:6960
>  schedule_timeout+0x9a/0x270 kernel/time/sleep_timeout.c:75
>  do_wait_for_common kernel/sched/completion.c:100 [inline]
>  __wait_for_common kernel/sched/completion.c:121 [inline]
>  wait_for_common kernel/sched/completion.c:132 [inline]
>  wait_for_completion+0x2bf/0x5d0 kernel/sched/completion.c:153
>  io_ring_ctx_lock_nested+0x2b3/0x380 io_uring/io_uring.h:283
>  io_ring_ctx_lock io_uring/io_uring.h:290 [inline]
>  io_ring_submit_lock io_uring/io_uring.h:554 [inline]
>  io_files_update+0x677/0x7f0 io_uring/rsrc.c:504
>  __io_issue_sqe+0x181/0x4b0 io_uring/io_uring.c:1818
>  io_issue_sqe+0x1de/0x1190 io_uring/io_uring.c:1841
>  io_wq_submit_work+0x6e9/0xb90 io_uring/io_uring.c:1953
>  io_worker_handle_work+0x7cd/0x1180 io_uring/io-wq.c:650
>  io_wq_worker+0x42f/0xeb0 io_uring/io-wq.c:704
>  ret_from_fork+0x599/0xb30 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246
>  </TASK>
>
> Showing all locks held in the system:
> 1 lock held by khungtaskd/35:
>  #0: ffffffff8df419e0 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire i=
nclude/linux/rcupdate.h:331 [inline]
>  #0: ffffffff8df419e0 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock incl=
ude/linux/rcupdate.h:867 [inline]
>  #0: ffffffff8df419e0 (rcu_read_lock){....}-{1:3}, at: debug_show_all_loc=
ks+0x2e/0x180 kernel/locking/lockdep.c:6775
> 5 locks held by kworker/u10:8/1120:
>  #0: ffff88823c63a918 (&rq->__lock){-.-.}-{2:2}, at: raw_spin_rq_lock_nes=
ted+0x2a/0x140 kernel/sched/core.c:639
>  #1: ffff88823c624588 (psi_seq){-.-.}-{0:0}, at: psi_task_switch+0x53/0x8=
80 kernel/sched/psi.c:933
>  #2: ffff88810ac50788 (&rdev->wiphy.mtx){+.+.}-{4:4}, at: class_wiphy_con=
structor include/net/cfg80211.h:6363 [inline]
>  #2: ffff88810ac50788 (&rdev->wiphy.mtx){+.+.}-{4:4}, at: cfg80211_wiphy_=
work+0xb4/0x450 net/wireless/core.c:424
>  #3: ffffffff8df419e0 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire i=
nclude/linux/rcupdate.h:331 [inline]
>  #3: ffffffff8df419e0 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock incl=
ude/linux/rcupdate.h:867 [inline]
>  #3: ffffffff8df419e0 (rcu_read_lock){....}-{1:3}, at: ieee80211_sta_acti=
ve_ibss+0xc3/0x330 net/mac80211/ibss.c:635
>  #4: ffffffff8df419e0 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire i=
nclude/linux/rcupdate.h:331 [inline]
>  #4: ffffffff8df419e0 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock incl=
ude/linux/rcupdate.h:867 [inline]
>  #4: ffffffff8df419e0 (rcu_read_lock){....}-{1:3}, at: class_rcu_construc=
tor include/linux/rcupdate.h:1195 [inline]
>  #4: ffffffff8df419e0 (rcu_read_lock){....}-{1:3}, at: unwind_next_frame+=
0xa5/0x2390 arch/x86/kernel/unwind_orc.c:479
> 2 locks held by getty/5656:
>  #0: ffff8881133040a0 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wa=
it+0x25/0x70 drivers/tty/tty_ldisc.c:243
>  #1: ffffc900035732f0 (&ldata->atomic_read_lock){+.+.}-{4:4}, at: n_tty_r=
ead+0x449/0x1460 drivers/tty/n_tty.c:2211
> 3 locks held by kworker/0:9/6480:
>  #0: ffff888100075948 ((wq_completion)events){+.+.}-{0:0}, at: process_on=
e_work kernel/workqueue.c:3232 [inline]
>  #0: ffff888100075948 ((wq_completion)events){+.+.}-{0:0}, at: process_sc=
heduled_works+0x9b4/0x1770 kernel/workqueue.c:3340
>  #1: ffffc9000546fb80 (deferred_process_work){+.+.}-{0:0}, at: process_on=
e_work kernel/workqueue.c:3233 [inline]
>  #1: ffffc9000546fb80 (deferred_process_work){+.+.}-{0:0}, at: process_sc=
heduled_works+0x9ef/0x1770 kernel/workqueue.c:3340
>  #2: ffffffff8f30ffc8 (rtnl_mutex){+.+.}-{4:4}, at: switchdev_deferred_pr=
ocess_work+0xe/0x20 net/switchdev/switchdev.c:104
> 1 lock held by syz-executor/6649:
>  #0: ffffffff8f30ffc8 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_lock net/core/rt=
netlink.c:80 [inline]
>  #0: ffffffff8f30ffc8 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_nets_lock net/co=
re/rtnetlink.c:341 [inline]
>  #0: ffffffff8f30ffc8 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_newlink+0x8ec/0x=
1c90 net/core/rtnetlink.c:4071
> 2 locks held by syz-executor/6651:
>  #0: ffffffff8f30ffc8 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_lock net/core/rt=
netlink.c:80 [inline]
>  #0: ffffffff8f30ffc8 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_nets_lock net/co=
re/rtnetlink.c:341 [inline]
>  #0: ffffffff8f30ffc8 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_newlink+0x8ec/0x=
1c90 net/core/rtnetlink.c:4071
>  #1: ffff88823c63a918 (&rq->__lock){-.-.}-{2:2}, at: raw_spin_rq_lock_nes=
ted+0x2a/0x140 kernel/sched/core.c:639
> 4 locks held by syz-executor/6653:
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> NMI backtrace for cpu 0
> CPU: 0 UID: 0 PID: 35 Comm: khungtaskd Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
>  nmi_cpu_backtrace+0x39e/0x3d0 lib/nmi_backtrace.c:113
>  nmi_trigger_cpumask_backtrace+0x17a/0x300 lib/nmi_backtrace.c:62
>  trigger_all_cpu_backtrace include/linux/nmi.h:160 [inline]
>  __sys_info lib/sys_info.c:157 [inline]
>  sys_info+0x135/0x170 lib/sys_info.c:165
>  check_hung_uninterruptible_tasks kernel/hung_task.c:346 [inline]
>  watchdog+0xf95/0xfe0 kernel/hung_task.c:515
>  kthread+0x711/0x8a0 kernel/kthread.c:463
>  ret_from_fork+0x599/0xb30 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246
>  </TASK>
> Sending NMI from CPU 0 to CPUs 1:
> NMI backtrace for cpu 1
> CPU: 1 UID: 0 PID: 6653 Comm: syz-executor Not tainted syzkaller #0 PREEM=
PT(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:io_serial_out+0x7c/0xc0 drivers/tty/serial/8250/8250_port.c:407
> Code: 3f a6 fc 44 89 f9 d3 e5 49 83 c6 40 4c 89 f0 48 c1 e8 03 42 80 3c 2=
0 00 74 08 4c 89 f7 e8 ec 91 0c fd 41 03 2e 89 d8 89 ea ee <5b> 41 5c 41 5e=
 41 5f 5d c3 cc cc cc cc cc 44 89 f9 80 e1 07 38 c1
> RSP: 0018:ffffc90008156590 EFLAGS: 00000002
> RAX: 000000000000005b RBX: 000000000000005b RCX: 0000000000000000
> RDX: 00000000000003f8 RSI: 0000000000000000 RDI: 0000000000000020
> RBP: 00000000000003f8 R08: ffff888102f08237 R09: 1ffff110205e1046
> R10: dffffc0000000000 R11: ffffffff851b9060 R12: dffffc0000000000
> R13: ffffffff998dd9e1 R14: ffffffff99bf2420 R15: 0000000000000000
> FS:  0000555595186500(0000) GS:ffff8882a9e37000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000055599f9c9018 CR3: 0000000112ed8000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  serial_port_out include/linux/serial_core.h:811 [inline]
>  serial8250_console_putchar drivers/tty/serial/8250/8250_port.c:3192 [inl=
ine]
>  serial8250_console_fifo_write drivers/tty/serial/8250/8250_port.c:-1 [in=
line]
>  serial8250_console_write+0x1410/0x1ba0 drivers/tty/serial/8250/8250_port=
.c:3342
>  console_emit_next_record kernel/printk/printk.c:3129 [inline]
>  console_flush_one_record kernel/printk/printk.c:3215 [inline]
>  console_flush_all+0x745/0xb60 kernel/printk/printk.c:3289
>  __console_flush_and_unlock kernel/printk/printk.c:3319 [inline]
>  console_unlock+0xbb/0x190 kernel/printk/printk.c:3359
>  vprintk_emit+0x4f8/0x5f0 kernel/printk/printk.c:2426
>  _printk+0xcf/0x120 kernel/printk/printk.c:2451
>  br_set_state+0x475/0x710 net/bridge/br_stp.c:57
>  br_init_port+0x99/0x200 net/bridge/br_stp_if.c:39
>  new_nbp+0x2f9/0x440 net/bridge/br_if.c:443
>  br_add_if+0x283/0xeb0 net/bridge/br_if.c:586
>  do_set_master+0x533/0x6d0 net/core/rtnetlink.c:2963
>  do_setlink+0xcf0/0x41c0 net/core/rtnetlink.c:3165
>  rtnl_changelink net/core/rtnetlink.c:3776 [inline]
>  __rtnl_newlink net/core/rtnetlink.c:3935 [inline]
>  rtnl_newlink+0x161c/0x1c90 net/core/rtnetlink.c:4072
>  rtnetlink_rcv_msg+0x7cf/0xb70 net/core/rtnetlink.c:6958
>  netlink_rcv_skb+0x208/0x470 net/netlink/af_netlink.c:2550
>  netlink_unicast_kernel net/netlink/af_netlink.c:1318 [inline]
>  netlink_unicast+0x82f/0x9e0 net/netlink/af_netlink.c:1344
>  netlink_sendmsg+0x805/0xb30 net/netlink/af_netlink.c:1894
>  sock_sendmsg_nosec net/socket.c:727 [inline]
>  __sock_sendmsg+0x21c/0x270 net/socket.c:742
>  __sys_sendto+0x3bd/0x520 net/socket.c:2206
>  __do_sys_sendto net/socket.c:2213 [inline]
>  __se_sys_sendto net/socket.c:2209 [inline]
>  __x64_sys_sendto+0xde/0x100 net/socket.c:2209
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f780c39165c
> Code: 2a 5f 02 00 44 8b 4c 24 2c 4c 8b 44 24 20 89 c5 44 8b 54 24 28 48 8=
b 54 24 18 b8 2c 00 00 00 48 8b 74 24 10 8b 7c 24 08 0f 05 <48> 3d 00 f0 ff=
 ff 77 34 89 ef 48 89 44 24 08 e8 70 5f 02 00 48 8b
> RSP: 002b:00007ffcecb618b0 EFLAGS: 00000293 ORIG_RAX: 000000000000002c
> RAX: ffffffffffffffda RBX: 00007f780d114620 RCX: 00007f780c39165c
> RDX: 0000000000000028 RSI: 00007f780d114670 RDI: 0000000000000003
> RBP: 0000000000000000 R08: 00007ffcecb61904 R09: 000000000000000c
> R10: 0000000000000000 R11: 0000000000000293 R12: 0000000000000003
> R13: 0000000000000000 R14: 00007f780d114670 R15: 0000000000000000
>  </TASK>
>
>
> ***
>
> If these findings have caused you to resend the series or submit a
> separate fix, please add the following tag to your commit message:
>   Tested-by: syzbot@syzkaller.appspotmail.com
>
> ---
> This report is generated by a bot. It may contain errors.
> syzbot ci engineers can be reached at syzkaller@googlegroups.com.

