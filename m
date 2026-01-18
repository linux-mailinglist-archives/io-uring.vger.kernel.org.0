Return-Path: <io-uring+bounces-11804-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 5CF70D39926
	for <lists+io-uring@lfdr.de>; Sun, 18 Jan 2026 19:34:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 243663007267
	for <lists+io-uring@lfdr.de>; Sun, 18 Jan 2026 18:34:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 539492FF15B;
	Sun, 18 Jan 2026 18:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Xg1cYZiZ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 319662FD698
	for <io-uring@vger.kernel.org>; Sun, 18 Jan 2026 18:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768761261; cv=none; b=Nt5/iAf34k9DFuRWKiqZeICmsnRrAYdtAzHYhGhCo3jsNlWh+Dck2aRJBeMlIhk9VsXqoUjGiETSfiDcuRJpMvRSdsbkwFrZsMmTjyaWy9cYpsYQ+tEmJEg8s48HQvTpNwopCc44xciXpnrpwbqtGbc/0yS9/dFEIXEiY4ip18E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768761261; c=relaxed/simple;
	bh=7VzH9QxivanZ6xHeBb5w168MeRZC4wO2YabBx4KvkT4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eK0sB+nym1vMHI5WEoztvckk+eRck9MbT//Uymf0XFKsZVWAJ7p/kBqck3M5nz4IlXG+Rki3EdUXDGTWopssVBIx0H6bEHCQJJBIyN0xwgck2z7ZiWSX2vJ/hQ0xFYZTzIVvHmfhWbBNWTqCMsB2e+nMK6hIURk4AxBCMGCfPIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Xg1cYZiZ; arc=none smtp.client-ip=209.85.167.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f174.google.com with SMTP id 5614622812f47-45c962424daso997305b6e.2
        for <io-uring@vger.kernel.org>; Sun, 18 Jan 2026 10:34:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1768761258; x=1769366058; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0Ie+iFhhS0RrxSDCWeTpUtOBozZzsQPu+fSbKnddFRE=;
        b=Xg1cYZiZEr76uRz1U2/6TBb1yDRB+KDqtSFG78veH1G0W7ysdriqctd2n4Qq2VXKWf
         O7bFRe96GSFQpWwykPREu7eZEjiQ/NK8phuD0W5RIt1mSXxFl5tuLpaxmg+kD4f/Rq27
         vLwmk6ZFSmeFNZInepDP0H6CUUdU8xXDwOrHx1XDxDj5pSxlVWXdNozyyHmg27hEF8M6
         HKtgJKY7INXsov7MRP6WxRDFhud3HRHmvSOEqf5WcNhEehiqB/Fg1nUt6NevDWNnFeev
         hqPVhN1AQa0VYLfOURogq2SgSdIsa4RY3u1TRuOTqE8n6gPXekp8hserI5MTOqsNwzH4
         FdIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768761258; x=1769366058;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0Ie+iFhhS0RrxSDCWeTpUtOBozZzsQPu+fSbKnddFRE=;
        b=Q1HmFnlu3OnoXy9GQQEHRskuJHbjhGrqt5ehXChGxUECPcOCVPC9y6+m25Jj6RXo4P
         OZQAIFfN72vmiU3wZKDwAj2iT0BYAqL21HCgxpIKa2BE8LaYuQAw5cI58rp3/ORQGeFA
         gZN+D5NyZbfqq1nGaULVpV41I0X93021MK4NJv3gnvOWDA9zmInXvDBLuHILv0FZvj/o
         KHaMNgerM15NqNtz4fRMmx8vE+dJ/cfpDjxNGhpi4oq0l1pydf3RokaJMC4PXQkGxOyj
         cN/PmBY6Dsv6HNVwR7EerxKHIqtWGiE7jg5TDKBwYs+0ydOtFwWiOe57UjxeyzyfQ9/v
         u0Pw==
X-Gm-Message-State: AOJu0Yz7SG+apBogK/lnKGU+45WwzCIECM8Iksqkg1aXsgAuSPfvpMvI
	EE5aYThzxaKfxwT1ScHQ/DpkTXSzcc4pyE4WED1pbCr1STQqob77MPykYz9tWUxGii4=
X-Gm-Gg: AY/fxX51bHucQYBHnAdYfbLH8UD5dq+2tWhLaj/1jiJ1B4YeU8iFju45NEYfGbTShWm
	009GJv9sJJaUAGX3WYt/yoj0TNwh/MZdZE98dbxWbrD0ITkUiWpacCLbaQfZv4pz5a2A5Q6YBpM
	Jy89WSbogQzZQX538YYQoFeaxivH5FfYuHJKgYra95yBmz7sXIQEc98Sz8x2JX138jrcXODGG1R
	PbIVSe2fFP+KwePIQsPcPJ7IBgejV+ELqsBD1QwDQHqJJD6C2Jzp1sR8gAoQ/u+Q0juzcU+03us
	IeWTabdvj2OV/gmbmu2fALM8Vse3JSQtnpjBEY6BmJkI52ufkQS/unJ4YWlBpH1LcOT+hAU8bae
	6Uv8AsNe0wmrrIVY0R8UFcLRICYLf6Ir/7U8LTA95+WClDFQUMGuFzZJIMormyuJJulWc7oGD4/
	GfIwmQ1XX9WaD3WUzewh+6Wb8BY6wiHegMdtHfT6ROGZg2A4Q3eHbLO89VNUW2tULlSiOdMQ==
X-Received: by 2002:a05:6808:244e:b0:45a:9eff:8322 with SMTP id 5614622812f47-45c9d8a6d79mr3574014b6e.58.1768761257989;
        Sun, 18 Jan 2026 10:34:17 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-45c9df08545sm4403291b6e.8.2026.01.18.10.34.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Jan 2026 10:34:17 -0800 (PST)
Message-ID: <0bc36797-fe4e-46ba-933d-0b3d508ed0dd@kernel.dk>
Date: Sun, 18 Jan 2026 11:34:15 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot ci] Re: io_uring: avoid uring_lock for
 IORING_SETUP_SINGLE_ISSUER
To: Caleb Sander Mateos <csander@purestorage.com>,
 syzbot ci <syzbot+ci6d21afd0455de45a@syzkaller.appspotmail.com>
Cc: io-uring@vger.kernel.org, joannelkoong@gmail.com,
 linux-kernel@vger.kernel.org, oliver.sang@intel.com,
 syzbot@syzkaller.appspotmail.com, syzbot@lists.linux.dev,
 syzkaller-bugs@googlegroups.com
References: <20251218024459.1083572-1-csander@purestorage.com>
 <6943b4db.a70a0220.25eec0.0028.GAE@google.com>
 <CADUfDZq7MK3r6c05CohT0hMowq-gqffGid-eC1cDGKy+4aaS=A@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CADUfDZq7MK3r6c05CohT0hMowq-gqffGid-eC1cDGKy+4aaS=A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/22/25 1:19 PM, Caleb Sander Mateos wrote:
> On Thu, Dec 18, 2025 at 3:01?AM syzbot ci
> <syzbot+ci6d21afd0455de45a@syzkaller.appspotmail.com> wrote:
>>
>> syzbot ci has tested the following series
>>
>> [v6] io_uring: avoid uring_lock for IORING_SETUP_SINGLE_ISSUER
>> https://lore.kernel.org/all/20251218024459.1083572-1-csander@purestorage.com
>> * [PATCH v6 1/6] io_uring: use release-acquire ordering for IORING_SETUP_R_DISABLED
>> * [PATCH v6 2/6] io_uring: clear IORING_SETUP_SINGLE_ISSUER for IORING_SETUP_SQPOLL
>> * [PATCH v6 3/6] io_uring: ensure submitter_task is valid for io_ring_ctx's lifetime
>> * [PATCH v6 4/6] io_uring: use io_ring_submit_lock() in io_iopoll_req_issued()
>> * [PATCH v6 5/6] io_uring: factor out uring_lock helpers
>> * [PATCH v6 6/6] io_uring: avoid uring_lock for IORING_SETUP_SINGLE_ISSUER
>>
>> and found the following issue:
>> INFO: task hung in io_wq_put_and_exit
>>
>> Full report is available here:
>> https://ci.syzbot.org/series/21eac721-670b-4f34-9696-66f9b28233ac
>>
>> ***
>>
>> INFO: task hung in io_wq_put_and_exit
>>
>> tree:      torvalds
>> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
>> base:      d358e5254674b70f34c847715ca509e46eb81e6f
>> arch:      amd64
>> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
>> config:    https://ci.syzbot.org/builds/1710cffe-7d78-4489-9aa1-823b8c2532ed/config
>> syz repro: https://ci.syzbot.org/findings/74ae8703-9484-4d82-aa78-84cc37dcb1ef/syz_repro
>>
>> INFO: task syz.1.18:6046 blocked for more than 143 seconds.
>>       Not tainted syzkaller #0
>>       Blocked by coredump.
>> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> task:syz.1.18        state:D stack:25672 pid:6046  tgid:6045  ppid:5971   task_flags:0x400548 flags:0x00080004
>> Call Trace:
>>  <TASK>
>>  context_switch kernel/sched/core.c:5256 [inline]
>>  __schedule+0x14bc/0x5000 kernel/sched/core.c:6863
>>  __schedule_loop kernel/sched/core.c:6945 [inline]
>>  schedule+0x165/0x360 kernel/sched/core.c:6960
>>  schedule_timeout+0x9a/0x270 kernel/time/sleep_timeout.c:75
>>  do_wait_for_common kernel/sched/completion.c:100 [inline]
>>  __wait_for_common kernel/sched/completion.c:121 [inline]
>>  wait_for_common kernel/sched/completion.c:132 [inline]
>>  wait_for_completion+0x2bf/0x5d0 kernel/sched/completion.c:153
>>  io_wq_exit_workers io_uring/io-wq.c:1328 [inline]
>>  io_wq_put_and_exit+0x316/0x650 io_uring/io-wq.c:1356
>>  io_uring_clean_tctx+0x11f/0x1a0 io_uring/tctx.c:207
>>  io_uring_cancel_generic+0x6ca/0x7d0 io_uring/cancel.c:652
>>  io_uring_files_cancel include/linux/io_uring.h:19 [inline]
>>  do_exit+0x345/0x2310 kernel/exit.c:911
>>  do_group_exit+0x21c/0x2d0 kernel/exit.c:1112
>>  get_signal+0x1285/0x1340 kernel/signal.c:3034
>>  arch_do_signal_or_restart+0x9a/0x7a0 arch/x86/kernel/signal.c:337
>>  __exit_to_user_mode_loop kernel/entry/common.c:41 [inline]
>>  exit_to_user_mode_loop+0x87/0x4f0 kernel/entry/common.c:75
>>  __exit_to_user_mode_prepare include/linux/irq-entry-common.h:226 [inline]
>>  syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:256 [inline]
>>  syscall_exit_to_user_mode_work include/linux/entry-common.h:159 [inline]
>>  syscall_exit_to_user_mode include/linux/entry-common.h:194 [inline]
>>  do_syscall_64+0x2e3/0xf80 arch/x86/entry/syscall_64.c:100
>>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>> RIP: 0033:0x7f6a8b58f7c9
>> RSP: 002b:00007f6a8c4a00e8 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
>> RAX: 0000000000000001 RBX: 00007f6a8b7e5fa8 RCX: 00007f6a8b58f7c9
>> RDX: 00000000000f4240 RSI: 0000000000000081 RDI: 00007f6a8b7e5fac
>> RBP: 00007f6a8b7e5fa0 R08: 3fffffffffffffff R09: 0000000000000000
>> R10: 0000000000000800 R11: 0000000000000246 R12: 0000000000000000
>> R13: 00007f6a8b7e6038 R14: 00007ffcac96d220 R15: 00007ffcac96d308
>>  </TASK>
>> INFO: task iou-wrk-6046:6047 blocked for more than 143 seconds.
>>       Not tainted syzkaller #0
>> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> task:iou-wrk-6046    state:D stack:27760 pid:6047  tgid:6045  ppid:5971   task_flags:0x404050 flags:0x00080002
>> Call Trace:
>>  <TASK>
>>  context_switch kernel/sched/core.c:5256 [inline]
>>  __schedule+0x14bc/0x5000 kernel/sched/core.c:6863
>>  __schedule_loop kernel/sched/core.c:6945 [inline]
>>  schedule+0x165/0x360 kernel/sched/core.c:6960
>>  schedule_timeout+0x9a/0x270 kernel/time/sleep_timeout.c:75
>>  do_wait_for_common kernel/sched/completion.c:100 [inline]
>>  __wait_for_common kernel/sched/completion.c:121 [inline]
>>  wait_for_common kernel/sched/completion.c:132 [inline]
>>  wait_for_completion+0x2bf/0x5d0 kernel/sched/completion.c:153
>>  io_ring_ctx_lock_nested+0x2b3/0x380 io_uring/io_uring.h:283
>>  io_ring_ctx_lock io_uring/io_uring.h:290 [inline]
>>  io_ring_submit_lock io_uring/io_uring.h:554 [inline]
>>  io_files_update+0x677/0x7f0 io_uring/rsrc.c:504
>>  __io_issue_sqe+0x181/0x4b0 io_uring/io_uring.c:1818
>>  io_issue_sqe+0x1de/0x1190 io_uring/io_uring.c:1841
>>  io_wq_submit_work+0x6e9/0xb90 io_uring/io_uring.c:1953
>>  io_worker_handle_work+0x7cd/0x1180 io_uring/io-wq.c:650
>>  io_wq_worker+0x42f/0xeb0 io_uring/io-wq.c:704
>>  ret_from_fork+0x599/0xb30 arch/x86/kernel/process.c:158
>>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246
>>  </TASK>
> 
> Interesting, a deadlock between io_wq_exit_workers() on submitter_task
> (which is exiting) and io_ring_ctx_lock() on an io_uring worker
> thread. io_ring_ctx_lock() is blocked until submitter_task runs task
> work, but that will never happen because it's waiting on the
> completion. Not sure what the best approach is here. Maybe have the
> submitter_task alternate between running task work and waiting on the
> completion? Or have some way for submitter_task to indicate that it's
> exiting and disable the IORING_SETUP_SINGLE_ISSUER optimization in
> io_ring_ctx_lock()?

Finally got around to taking a look at this patchset today, and it does
look sound to me. For cases that have zero expected io-wq activity, then
it seems like a no-brainer. For cases that have a lot of expected io-wq
activity, which are basically only things like fs/storage workloads on
suboptimal configurations, the then the suspend/resume mechanism may be
troublesome. But not quite sure what to do about that, or if it's evne
noticable?

For the case in question, yes I think we'll need the completion wait
cases to break for running task_work.

-- 
Jens Axboe

