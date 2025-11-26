Return-Path: <io-uring+bounces-10810-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 19AE8C88979
	for <lists+io-uring@lfdr.de>; Wed, 26 Nov 2025 09:15:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C7B2F3A43C2
	for <lists+io-uring@lfdr.de>; Wed, 26 Nov 2025 08:15:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 279E528A701;
	Wed, 26 Nov 2025 08:15:45 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 434EF248F4D
	for <io-uring@vger.kernel.org>; Wed, 26 Nov 2025 08:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764144945; cv=none; b=Selev5OCrZm9GfLmmfGH9t6LsZxqB5IY+PypIcTo5Zh960ZPj6gHzsDDgNzVEvvERLRYtTsXdl8ao5s1Rihyi3Jw5o3SBpN3oCE+mP2FZubrfCYZ7kFKC5TbS0n0z75hpX48Z9SioGE/hnkRb59/9DHECqgFlGbCt/PqVtuc2Tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764144945; c=relaxed/simple;
	bh=PtUAYWwvYF3UPHozwNSpG3K6vgYzywTfTUmb0V3h48Q=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=kpBwZC68AxomaipckJf421IG6vdeJPKD+PxVWeO2pEMplNH4F1COQ7MhhtX4L2t4QNaj+JvhPu7qxRItFn7LCRUcasJE7RaAuWxFwQ98lK3wim7MvdpUUSiLyX4gHOPFZ9kAA+piqah3K/9KO1hEFSytErMVRn/122hhZUqzr78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-43470d72247so60889925ab.3
        for <io-uring@vger.kernel.org>; Wed, 26 Nov 2025 00:15:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764144942; x=1764749742;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QwjwsClPRFe4JHK3xVTEx/neaHrI38fyR94E4WgbJZY=;
        b=XCs3+rOA8o8IJI40m2z740JIN0oGlepcx17sdVKtOSY8WKZSTbSeJxZrK/QB3pw5kt
         //ulHSM9yKpzf0wAqX8uSkxs43ItRKdql5+K6IbwKihXQ0FqPGO++SjFYAmoCuzQ4+wL
         KB4ayihM/fUUq8ZaOu3Z5mLmN62wz0kCzQ5DACvp6xEBm6L8m+BeV9E30CQoBrxLEuFy
         YHsxE2KqXYpXemH5XCWfLWvvCVSIqbczLR+CctapH93DErovX30K/0WOicgia+PbfGos
         TWIIC/6YGU7F3s2FZXQgvxZs3J0hS3+REkJg7ZEVYYGfzWvPQjroi50uR6x/xU/nTsLz
         4wIA==
X-Forwarded-Encrypted: i=1; AJvYcCVOBU7O72WmRb62X69maysDHZxzfLNopFY9pn3d9ZNNNr5LHBvLpQbRVGfTILLx5P3rtzgn6B8XJw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxzufTly5SHFHJ6T9vURtH0hk5RH8UhrEMN70vDDDEORX0dGx1N
	wvFIwWBo7bGCOqc20tv7DFqbx9M916oYz/Y5Qq9NgsyQZ24clY1NT/zyUJWWBOXTKqFkzXgSIxU
	xA20drfiPQo4/d3x+5NZBoZeCAEBKJOqZ8RWHq/0mQX4m2HzLF1zMXZuksnQ=
X-Google-Smtp-Source: AGHT+IEdhy1nS+9NZup+V/gr73F36uRMD/lUMDjKOsIfYFTFuC3pAIzppu2O86PrRCsn90qGovH20mwL8WLQsuOdmxtErBjobYEV
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:11:b0:435:a148:cbf with SMTP id
 e9e14a558f8ab-435b8e9d67amr149649195ab.42.1764144942475; Wed, 26 Nov 2025
 00:15:42 -0800 (PST)
Date: Wed, 26 Nov 2025 00:15:42 -0800
In-Reply-To: <20251125233928.3962947-1-csander@purestorage.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6926b72e.a70a0220.d98e3.00ce.GAE@google.com>
Subject: [syzbot ci] Re: io_uring: avoid uring_lock for IORING_SETUP_SINGLE_ISSUER
From: syzbot ci <syzbot+ci500177af251d1ddc@syzkaller.appspotmail.com>
To: axboe@kernel.dk, csander@purestorage.com, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v3] io_uring: avoid uring_lock for IORING_SETUP_SINGLE_ISSUER
https://lore.kernel.org/all/20251125233928.3962947-1-csander@purestorage.com
* [PATCH v3 1/4] io_uring: clear IORING_SETUP_SINGLE_ISSUER for IORING_SETUP_SQPOLL
* [PATCH v3 2/4] io_uring: use io_ring_submit_lock() in io_iopoll_req_issued()
* [PATCH v3 3/4] io_uring: factor out uring_lock helpers
* [PATCH v3 4/4] io_uring: avoid uring_lock for IORING_SETUP_SINGLE_ISSUER

and found the following issues:
* SYZFAIL: failed to recv rpc
* WARNING in io_ring_ctx_wait_and_kill
* WARNING in io_uring_alloc_task_context
* WARNING: suspicious RCU usage in io_eventfd_unregister

Full report is available here:
https://ci.syzbot.org/series/dde98852-0135-44b2-bbef-9ff9d772f924

***

SYZFAIL: failed to recv rpc

tree:      linux-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/linux-next
base:      92fd6e84175befa1775e5c0ab682938eca27c0b2
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/9d67ded7-d9a8-41e3-8b58-51340991cf96/config
C repro:   https://ci.syzbot.org/findings/19ae4090-3486-4e2a-973e-dcb6ec3ba0d1/c_repro
syz repro: https://ci.syzbot.org/findings/19ae4090-3486-4e2a-973e-dcb6ec3ba0d1/syz_repro

SYZFAIL: failed to recv rpc
fd=3 want=4 recv=0 n=0 (errno 9: Bad file descriptor)


***

WARNING in io_ring_ctx_wait_and_kill

tree:      linux-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/linux-next
base:      92fd6e84175befa1775e5c0ab682938eca27c0b2
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/9d67ded7-d9a8-41e3-8b58-51340991cf96/config
C repro:   https://ci.syzbot.org/findings/f5ff9320-bf6f-40b4-a6b3-eee18fa83053/c_repro
syz repro: https://ci.syzbot.org/findings/f5ff9320-bf6f-40b4-a6b3-eee18fa83053/syz_repro

------------[ cut here ]------------
WARNING: io_uring/io_uring.h:266 at io_ring_ctx_lock io_uring/io_uring.h:266 [inline], CPU#0: syz.0.17/5967
WARNING: io_uring/io_uring.h:266 at io_ring_ctx_wait_and_kill+0x35f/0x490 io_uring/io_uring.c:3119, CPU#0: syz.0.17/5967
Modules linked in:
CPU: 0 UID: 0 PID: 5967 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:io_ring_ctx_lock io_uring/io_uring.h:266 [inline]
RIP: 0010:io_ring_ctx_wait_and_kill+0x35f/0x490 io_uring/io_uring.c:3119
Code: 4e 11 48 3b 84 24 20 01 00 00 0f 85 1e 01 00 00 48 8d 65 d8 5b 41 5c 41 5d 41 5e 41 5f 5d c3 cc cc cc cc cc e8 92 fa 96 00 90 <0f> 0b 90 e9 be fd ff ff 48 8d 7c 24 40 ba 70 00 00 00 31 f6 e8 08
RSP: 0018:ffffc90004117b80 EFLAGS: 00010293
RAX: ffffffff812ac5ee RBX: ffff88810d784000 RCX: ffff888104363a80
RDX: 0000000000000000 RSI: 0000000000001000 RDI: 0000000000000000
RBP: ffffc90004117d00 R08: ffffc90004117c7f R09: 0000000000000000
R10: ffffc90004117c40 R11: fffff52000822f90 R12: 1ffff92000822f74
R13: dffffc0000000000 R14: ffffc90004117c70 R15: 0000000000000000
FS:  000055558ddb3500(0000) GS:ffff88818e88a000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f07135e7dac CR3: 00000001728f4000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 io_uring_create+0x6b6/0x940 io_uring/io_uring.c:3738
 io_uring_setup io_uring/io_uring.c:3764 [inline]
 __do_sys_io_uring_setup io_uring/io_uring.c:3798 [inline]
 __se_sys_io_uring_setup+0x235/0x240 io_uring/io_uring.c:3789
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f071338f749
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fff80b05b58 EFLAGS: 00000246 ORIG_RAX: 00000000000001a9
RAX: ffffffffffffffda RBX: 00007f07135e5fa0 RCX: 00007f071338f749
RDX: 0000000000000000 RSI: 0000200000000040 RDI: 0000000000000024
RBP: 00007f0713413f91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f07135e5fa0 R14: 00007f07135e5fa0 R15: 0000000000000002
 </TASK>


***

WARNING in io_uring_alloc_task_context

tree:      linux-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/linux-next
base:      92fd6e84175befa1775e5c0ab682938eca27c0b2
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/9d67ded7-d9a8-41e3-8b58-51340991cf96/config
C repro:   https://ci.syzbot.org/findings/7aa56677-dbe1-4fdc-bbc4-cc701c10fa7e/c_repro
syz repro: https://ci.syzbot.org/findings/7aa56677-dbe1-4fdc-bbc4-cc701c10fa7e/syz_repro

------------[ cut here ]------------
WARNING: io_uring/io_uring.h:266 at io_ring_ctx_lock io_uring/io_uring.h:266 [inline], CPU#0: syz.0.17/5982
WARNING: io_uring/io_uring.h:266 at io_init_wq_offload io_uring/tctx.c:23 [inline], CPU#0: syz.0.17/5982
WARNING: io_uring/io_uring.h:266 at io_uring_alloc_task_context+0x677/0x8c0 io_uring/tctx.c:86, CPU#0: syz.0.17/5982
Modules linked in:
CPU: 0 UID: 0 PID: 5982 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:io_ring_ctx_lock io_uring/io_uring.h:266 [inline]
RIP: 0010:io_init_wq_offload io_uring/tctx.c:23 [inline]
RIP: 0010:io_uring_alloc_task_context+0x677/0x8c0 io_uring/tctx.c:86
Code: d8 5b 41 5c 41 5d 41 5e 41 5f 5d c3 cc cc cc cc cc e8 3d ad 96 00 bb f4 ff ff ff eb ab e8 31 ad 96 00 eb 9c e8 2a ad 96 00 90 <0f> 0b 90 e9 12 fb ff ff 4c 8d 64 24 60 4c 8d b4 24 f0 00 00 00 ba
RSP: 0018:ffffc90003dcf9c0 EFLAGS: 00010293
RAX: ffffffff812b1356 RBX: 0000000000000000 RCX: ffff8881777957c0
RDX: 0000000000000000 RSI: 0000000000001000 RDI: 0000000000000000
RBP: ffffc90003dcfb50 R08: ffffffff8f7de377 R09: 1ffffffff1efbc6e
R10: dffffc0000000000 R11: fffffbfff1efbc6f R12: ffff8881052bf000
R13: ffff888104bf2000 R14: 0000000000001000 R15: 1ffff1102097e400
FS:  00005555613bd500(0000) GS:ffff88818e88a000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f7773fe7dac CR3: 000000016cd1c000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 __io_uring_add_tctx_node+0x455/0x710 io_uring/tctx.c:112
 io_uring_create+0x559/0x940 io_uring/io_uring.c:3719
 io_uring_setup io_uring/io_uring.c:3764 [inline]
 __do_sys_io_uring_setup io_uring/io_uring.c:3798 [inline]
 __se_sys_io_uring_setup+0x235/0x240 io_uring/io_uring.c:3789
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f7773d8f749
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffe094f0b68 EFLAGS: 00000246 ORIG_RAX: 00000000000001a9
RAX: ffffffffffffffda RBX: 00007f7773fe5fa0 RCX: 00007f7773d8f749
RDX: 0000000000000000 RSI: 0000200000000780 RDI: 0000000000000f08
RBP: 00007f7773e13f91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f7773fe5fa0 R14: 00007f7773fe5fa0 R15: 0000000000000002
 </TASK>


***

WARNING: suspicious RCU usage in io_eventfd_unregister

tree:      linux-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/linux-next
base:      92fd6e84175befa1775e5c0ab682938eca27c0b2
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/9d67ded7-d9a8-41e3-8b58-51340991cf96/config
C repro:   https://ci.syzbot.org/findings/84c08f15-f4f9-4123-b889-1d8d19f3e0b1/c_repro
syz repro: https://ci.syzbot.org/findings/84c08f15-f4f9-4123-b889-1d8d19f3e0b1/syz_repro

=============================
WARNING: suspicious RCU usage
syzkaller #0 Not tainted
-----------------------------
io_uring/eventfd.c:160 suspicious rcu_dereference_protected() usage!

other info that might help us debug this:


rcu_scheduler_active = 2, debug_locks = 1
2 locks held by kworker/u10:12/3941:
 #0: ffff888168f41148 ((wq_completion)iou_exit){+.+.}-{0:0}, at: process_one_work+0x841/0x15a0 kernel/workqueue.c:3236
 #1: ffffc90021f3fb80 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x868/0x15a0 kernel/workqueue.c:3237

stack backtrace:
CPU: 1 UID: 0 PID: 3941 Comm: kworker/u10:12 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Workqueue: iou_exit io_ring_exit_work
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 lockdep_rcu_suspicious+0x140/0x1d0 kernel/locking/lockdep.c:6876
 io_eventfd_unregister+0x18b/0x1c0 io_uring/eventfd.c:159
 io_ring_ctx_free+0x18a/0x820 io_uring/io_uring.c:2882
 io_ring_exit_work+0xe71/0x1030 io_uring/io_uring.c:3110
 process_one_work+0x93a/0x15a0 kernel/workqueue.c:3261
 process_scheduled_works kernel/workqueue.c:3344 [inline]
 worker_thread+0x9b0/0xee0 kernel/workqueue.c:3425
 kthread+0x711/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x599/0xb30 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

