Return-Path: <io-uring+bounces-10815-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 86B26C8B344
	for <lists+io-uring@lfdr.de>; Wed, 26 Nov 2025 18:30:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 371323A4FFB
	for <lists+io-uring@lfdr.de>; Wed, 26 Nov 2025 17:30:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32F492DC779;
	Wed, 26 Nov 2025 17:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="cWbDBCRV"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 430BD2E62C0
	for <io-uring@vger.kernel.org>; Wed, 26 Nov 2025 17:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764178237; cv=none; b=bonfLrMBYxJCSLpM4Y0H0SGuNm7nOgUN4eR/SIhMEGVrf/HMbQgHAhXKmNt0pkRie+9rTpNHORHn3FOGkdLtaDVrH1qn4pTkKlECMW8cJ2l11PvE9CorFUmgDLOYGyAplTUWn05VayR4MSHPvDYFm+CF5xxXoF/fbYcWDpivmlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764178237; c=relaxed/simple;
	bh=V+cxRyyrF6+B+ZXNlZ7yWwy0FxRIR9IAYuWYZrCAvfo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BNmzbgkH6tnIwcFr8+JGAl10/UpW8MIxHSPPLEb3mtMZ1CZETbe/Qwh2OjcBTZOvIuoXm9GF3eK4O4TYfQ+p7mg73zzQVrkbpRys2xv4vagYNXfdHP6yxtkalHXAqfujvlffu4wli7/yrrYgsOv+ASrRfwo5Fgcg6SXUDru0I4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=cWbDBCRV; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-7baa28f553dso165585b3a.3
        for <io-uring@vger.kernel.org>; Wed, 26 Nov 2025 09:30:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1764178234; x=1764783034; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KLnhrlclL2hBFlvbHeGiCZG8szXvljowS2+JOUxb6ro=;
        b=cWbDBCRVS15QOB3rOBIstc7DmIP928pI8d5+gD5EKjRzgEfT5vs87S5EdquYWo06Ak
         ijEOHGe5xcaP182IOiFQcGbht6/MULvCVGjmxsiLpPz/tgSKs8KwiCwRSQDx38mzfpA4
         HtT8l1WrPm3snRxSoRvClwDq/+w+4buwGJS4fq6fEThRNY0FzZoccbIQ6DunieB1EppL
         WDm3WIA2Xa9te8SJ2DbD26C807ZB+lKSg3/hl/RcKga+LDUd2T3X0czaDbGsACZZAip9
         QYkiUDL2koPcJ0XoHt/Mof2JNPsfUVaVD8x/6ZsRe3AXEfJMzoS8B+zGhRUtQm8MCZTd
         h6Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764178234; x=1764783034;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KLnhrlclL2hBFlvbHeGiCZG8szXvljowS2+JOUxb6ro=;
        b=NGqhlLoa1Kyrst9ksE44VelvfQYtqUl0b5dxNiB8IAyPkpkfC6Zg81n4pYoitq1061
         G1MXWukn9ifY0UNwe5+MHshi/qqA8eYVQv7BcYaw7t0IZaW5ZQd54vlRe2o1g3/uMaLA
         AmDIu75INBuvBVr7TyehPmI81CehzBJsTHMWWYVk4QT/tSpwkxQ+j8+oXiK+eFxlgjKr
         hFgsN/REdMGz8qsjLBZXx5O4RF4S1DgRQzGwC/hXXX+0fz/hKmbMkRFd9RSOc2YV8i5d
         u59p5qrxM7hKGADwQEriQdi68x9YIi9wNn/uTPOFDItIUpP1pqtiRQ7g/yjDloJitV/A
         iPiQ==
X-Forwarded-Encrypted: i=1; AJvYcCWfs5ezf0Ps/ZmYKTnc1t/weo0l+vcaEEaxYe+nwgNnT+vUpNJWc7lwkcxhCNykW+x6NAguLHB/Hg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwXoAY1gVNkAOhSuabxLR9L43U9XG5VSL0wgfQIo4Ka8p/2/y0E
	6qFi4spk9V7HroYXjDte+h5W4PDPmjY/7vGUFzuUYTZVy6oHMI2iAJ27Sl6wAtA+LTmCdJ/kx7d
	6Cb6j6iTE4LEug9XyLGhdEfiFQ9+BQlFtTuh6p4kasR/zxy34vdW7NKpw9w==
X-Gm-Gg: ASbGncufKzgwp+XzEPIEz3wcjQPtbwCYt2ppK6ee5jTXjann0jmDEoFK4LmEl0yA0ln
	tyDBRl9iww6KCkiyVsO2nB/B3NEMTcmspK7vQ7Vys7NdrF4Lh2s7y4Q8DMCmCj6ogJlJRZiDUP3
	uQd8WmTXZKrwLlLCDMKVEGX82vnsUPsuHOg0MKhDqeTSc15j7Tb75OuB7WReVomqowHxL2GQmGk
	BYfbXdA5u7SztSLxT8doWYsSKdjvXGdu1s8asPVfZy0AJQNMQXQhyydnN+2NN11kQVuOt3xjiFb
	Y3K2/y4=
X-Google-Smtp-Source: AGHT+IGt10pv4llmqCbLcoMLoJ+DMorDCEuQQmpctIa5R6IMbc7ECGduQikUIg1pJCai04BVUys4OdpoVYV7enibOCA=
X-Received: by 2002:a05:7022:69a9:b0:119:e56a:4ffb with SMTP id
 a92af1059eb24-11c9d5538e8mr12774861c88.0.1764178233879; Wed, 26 Nov 2025
 09:30:33 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251125233928.3962947-1-csander@purestorage.com> <6926b72e.a70a0220.d98e3.00ce.GAE@google.com>
In-Reply-To: <6926b72e.a70a0220.d98e3.00ce.GAE@google.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Wed, 26 Nov 2025 09:30:22 -0800
X-Gm-Features: AWmQ_bkSdhwknO8HxFchySZfYgvXw8n11qh5McyAmxp9jEUhX7iJGL8u2DoqLtw
Message-ID: <CADUfDZo-+gXhHEyY5YAr6tkd6y-mnKL0Uci0KqiEY3G-Mu=uWg@mail.gmail.com>
Subject: Re: [syzbot ci] Re: io_uring: avoid uring_lock for IORING_SETUP_SINGLE_ISSUER
To: syzbot ci <syzbot+ci500177af251d1ddc@syzkaller.appspotmail.com>
Cc: axboe@kernel.dk, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 26, 2025 at 12:15=E2=80=AFAM syzbot ci
<syzbot+ci500177af251d1ddc@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v3] io_uring: avoid uring_lock for IORING_SETUP_SINGLE_ISSUER
> https://lore.kernel.org/all/20251125233928.3962947-1-csander@purestorage.=
com
> * [PATCH v3 1/4] io_uring: clear IORING_SETUP_SINGLE_ISSUER for IORING_SE=
TUP_SQPOLL
> * [PATCH v3 2/4] io_uring: use io_ring_submit_lock() in io_iopoll_req_iss=
ued()
> * [PATCH v3 3/4] io_uring: factor out uring_lock helpers
> * [PATCH v3 4/4] io_uring: avoid uring_lock for IORING_SETUP_SINGLE_ISSUE=
R
>
> and found the following issues:
> * SYZFAIL: failed to recv rpc

Looks like this might be a side effect of the "WARNING: suspicious RCU
usage in io_eventfd_unregister" report.

> * WARNING in io_ring_ctx_wait_and_kill

Looks like io_ring_ctx_wait_and_kill() can be called on a
IORING_SETUP_SINGLE_ISSUER io_ring_ctx before submitter_task has been
set if io_uring_create() errors out or a IORING_SETUP_R_DISABLED
io_ring_ctx is never enabled. I can relax this WARN_ON_ONCE()
condition.

> * WARNING in io_uring_alloc_task_context

Similar issue, __io_uring_add_tctx_node() is always called in
io_uring_create(), where submitter_task won't exist yet for
IORING_SETUP_SINGLE_ISSUER and IORING_SETUP_R_DISABLED.

> * WARNING: suspicious RCU usage in io_eventfd_unregister

Missed that io_eventfd_unregister() is also called from
io_ring_ctx_free(), not just __io_uring_register(). So we can't assert
that the uring_lock mutex is held.

Thanks, syzbot!

>
> Full report is available here:
> https://ci.syzbot.org/series/dde98852-0135-44b2-bbef-9ff9d772f924
>
> ***
>
> SYZFAIL: failed to recv rpc
>
> tree:      linux-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/=
linux-next
> base:      92fd6e84175befa1775e5c0ab682938eca27c0b2
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~e=
xp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/9d67ded7-d9a8-41e3-8b58-51340991c=
f96/config
> C repro:   https://ci.syzbot.org/findings/19ae4090-3486-4e2a-973e-dcb6ec3=
ba0d1/c_repro
> syz repro: https://ci.syzbot.org/findings/19ae4090-3486-4e2a-973e-dcb6ec3=
ba0d1/syz_repro
>
> SYZFAIL: failed to recv rpc
> fd=3D3 want=3D4 recv=3D0 n=3D0 (errno 9: Bad file descriptor)
>
>
> ***
>
> WARNING in io_ring_ctx_wait_and_kill
>
> tree:      linux-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/=
linux-next
> base:      92fd6e84175befa1775e5c0ab682938eca27c0b2
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~e=
xp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/9d67ded7-d9a8-41e3-8b58-51340991c=
f96/config
> C repro:   https://ci.syzbot.org/findings/f5ff9320-bf6f-40b4-a6b3-eee18fa=
83053/c_repro
> syz repro: https://ci.syzbot.org/findings/f5ff9320-bf6f-40b4-a6b3-eee18fa=
83053/syz_repro
>
> ------------[ cut here ]------------
> WARNING: io_uring/io_uring.h:266 at io_ring_ctx_lock io_uring/io_uring.h:=
266 [inline], CPU#0: syz.0.17/5967
> WARNING: io_uring/io_uring.h:266 at io_ring_ctx_wait_and_kill+0x35f/0x490=
 io_uring/io_uring.c:3119, CPU#0: syz.0.17/5967
> Modules linked in:
> CPU: 0 UID: 0 PID: 5967 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:io_ring_ctx_lock io_uring/io_uring.h:266 [inline]
> RIP: 0010:io_ring_ctx_wait_and_kill+0x35f/0x490 io_uring/io_uring.c:3119
> Code: 4e 11 48 3b 84 24 20 01 00 00 0f 85 1e 01 00 00 48 8d 65 d8 5b 41 5=
c 41 5d 41 5e 41 5f 5d c3 cc cc cc cc cc e8 92 fa 96 00 90 <0f> 0b 90 e9 be=
 fd ff ff 48 8d 7c 24 40 ba 70 00 00 00 31 f6 e8 08
> RSP: 0018:ffffc90004117b80 EFLAGS: 00010293
> RAX: ffffffff812ac5ee RBX: ffff88810d784000 RCX: ffff888104363a80
> RDX: 0000000000000000 RSI: 0000000000001000 RDI: 0000000000000000
> RBP: ffffc90004117d00 R08: ffffc90004117c7f R09: 0000000000000000
> R10: ffffc90004117c40 R11: fffff52000822f90 R12: 1ffff92000822f74
> R13: dffffc0000000000 R14: ffffc90004117c70 R15: 0000000000000000
> FS:  000055558ddb3500(0000) GS:ffff88818e88a000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f07135e7dac CR3: 00000001728f4000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  io_uring_create+0x6b6/0x940 io_uring/io_uring.c:3738
>  io_uring_setup io_uring/io_uring.c:3764 [inline]
>  __do_sys_io_uring_setup io_uring/io_uring.c:3798 [inline]
>  __se_sys_io_uring_setup+0x235/0x240 io_uring/io_uring.c:3789
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f071338f749
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fff80b05b58 EFLAGS: 00000246 ORIG_RAX: 00000000000001a9
> RAX: ffffffffffffffda RBX: 00007f07135e5fa0 RCX: 00007f071338f749
> RDX: 0000000000000000 RSI: 0000200000000040 RDI: 0000000000000024
> RBP: 00007f0713413f91 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f07135e5fa0 R14: 00007f07135e5fa0 R15: 0000000000000002
>  </TASK>
>
>
> ***
>
> WARNING in io_uring_alloc_task_context
>
> tree:      linux-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/=
linux-next
> base:      92fd6e84175befa1775e5c0ab682938eca27c0b2
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~e=
xp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/9d67ded7-d9a8-41e3-8b58-51340991c=
f96/config
> C repro:   https://ci.syzbot.org/findings/7aa56677-dbe1-4fdc-bbc4-cc701c1=
0fa7e/c_repro
> syz repro: https://ci.syzbot.org/findings/7aa56677-dbe1-4fdc-bbc4-cc701c1=
0fa7e/syz_repro
>
> ------------[ cut here ]------------
> WARNING: io_uring/io_uring.h:266 at io_ring_ctx_lock io_uring/io_uring.h:=
266 [inline], CPU#0: syz.0.17/5982
> WARNING: io_uring/io_uring.h:266 at io_init_wq_offload io_uring/tctx.c:23=
 [inline], CPU#0: syz.0.17/5982
> WARNING: io_uring/io_uring.h:266 at io_uring_alloc_task_context+0x677/0x8=
c0 io_uring/tctx.c:86, CPU#0: syz.0.17/5982
> Modules linked in:
> CPU: 0 UID: 0 PID: 5982 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:io_ring_ctx_lock io_uring/io_uring.h:266 [inline]
> RIP: 0010:io_init_wq_offload io_uring/tctx.c:23 [inline]
> RIP: 0010:io_uring_alloc_task_context+0x677/0x8c0 io_uring/tctx.c:86
> Code: d8 5b 41 5c 41 5d 41 5e 41 5f 5d c3 cc cc cc cc cc e8 3d ad 96 00 b=
b f4 ff ff ff eb ab e8 31 ad 96 00 eb 9c e8 2a ad 96 00 90 <0f> 0b 90 e9 12=
 fb ff ff 4c 8d 64 24 60 4c 8d b4 24 f0 00 00 00 ba
> RSP: 0018:ffffc90003dcf9c0 EFLAGS: 00010293
> RAX: ffffffff812b1356 RBX: 0000000000000000 RCX: ffff8881777957c0
> RDX: 0000000000000000 RSI: 0000000000001000 RDI: 0000000000000000
> RBP: ffffc90003dcfb50 R08: ffffffff8f7de377 R09: 1ffffffff1efbc6e
> R10: dffffc0000000000 R11: fffffbfff1efbc6f R12: ffff8881052bf000
> R13: ffff888104bf2000 R14: 0000000000001000 R15: 1ffff1102097e400
> FS:  00005555613bd500(0000) GS:ffff88818e88a000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f7773fe7dac CR3: 000000016cd1c000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  __io_uring_add_tctx_node+0x455/0x710 io_uring/tctx.c:112
>  io_uring_create+0x559/0x940 io_uring/io_uring.c:3719
>  io_uring_setup io_uring/io_uring.c:3764 [inline]
>  __do_sys_io_uring_setup io_uring/io_uring.c:3798 [inline]
>  __se_sys_io_uring_setup+0x235/0x240 io_uring/io_uring.c:3789
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f7773d8f749
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffe094f0b68 EFLAGS: 00000246 ORIG_RAX: 00000000000001a9
> RAX: ffffffffffffffda RBX: 00007f7773fe5fa0 RCX: 00007f7773d8f749
> RDX: 0000000000000000 RSI: 0000200000000780 RDI: 0000000000000f08
> RBP: 00007f7773e13f91 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f7773fe5fa0 R14: 00007f7773fe5fa0 R15: 0000000000000002
>  </TASK>
>
>
> ***
>
> WARNING: suspicious RCU usage in io_eventfd_unregister
>
> tree:      linux-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/=
linux-next
> base:      92fd6e84175befa1775e5c0ab682938eca27c0b2
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~e=
xp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/9d67ded7-d9a8-41e3-8b58-51340991c=
f96/config
> C repro:   https://ci.syzbot.org/findings/84c08f15-f4f9-4123-b889-1d8d19f=
3e0b1/c_repro
> syz repro: https://ci.syzbot.org/findings/84c08f15-f4f9-4123-b889-1d8d19f=
3e0b1/syz_repro
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> WARNING: suspicious RCU usage
> syzkaller #0 Not tainted
> -----------------------------
> io_uring/eventfd.c:160 suspicious rcu_dereference_protected() usage!
>
> other info that might help us debug this:
>
>
> rcu_scheduler_active =3D 2, debug_locks =3D 1
> 2 locks held by kworker/u10:12/3941:
>  #0: ffff888168f41148 ((wq_completion)iou_exit){+.+.}-{0:0}, at: process_=
one_work+0x841/0x15a0 kernel/workqueue.c:3236
>  #1: ffffc90021f3fb80 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, a=
t: process_one_work+0x868/0x15a0 kernel/workqueue.c:3237
>
> stack backtrace:
> CPU: 1 UID: 0 PID: 3941 Comm: kworker/u10:12 Not tainted syzkaller #0 PRE=
EMPT(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Workqueue: iou_exit io_ring_exit_work
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
>  lockdep_rcu_suspicious+0x140/0x1d0 kernel/locking/lockdep.c:6876
>  io_eventfd_unregister+0x18b/0x1c0 io_uring/eventfd.c:159
>  io_ring_ctx_free+0x18a/0x820 io_uring/io_uring.c:2882
>  io_ring_exit_work+0xe71/0x1030 io_uring/io_uring.c:3110
>  process_one_work+0x93a/0x15a0 kernel/workqueue.c:3261
>  process_scheduled_works kernel/workqueue.c:3344 [inline]
>  worker_thread+0x9b0/0xee0 kernel/workqueue.c:3425
>  kthread+0x711/0x8a0 kernel/kthread.c:463
>  ret_from_fork+0x599/0xb30 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246
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

