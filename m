Return-Path: <io-uring+bounces-11164-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E01EACC9F9C
	for <lists+io-uring@lfdr.de>; Thu, 18 Dec 2025 02:25:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CEB473005B8F
	for <lists+io-uring@lfdr.de>; Thu, 18 Dec 2025 01:24:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C50A217993;
	Thu, 18 Dec 2025 01:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="FyBiqFZ6"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E27D21FDE01
	for <io-uring@vger.kernel.org>; Thu, 18 Dec 2025 01:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766021094; cv=none; b=WE99KI9ud2BdT5ZCNQT7MOsj1Yc+zBZvg/NBiCAoaA7dXUaugg6YjyCv43fO7GWK7AOEBSjo/dgIpmsUAtXoPgB4UBQ46pVLc6YOS7UcTYbkTND1TkiCexbLGoGlyLX84wxltTUxWi57mLmkfYXXWCGwBidv2SyaRiNN5WJcoTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766021094; c=relaxed/simple;
	bh=DWooMH5C1QDB5vQy0GKXpx3583jw/ecEO7bU5boe5a8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=u5kvnDkD4b9cDZiaebtszi6CQ3gk406pyfKi59L+BCI8lvwI/G7oz9tvl+MnK6Xqfbd82hzZ8wNq9h6VtAf0ZGeZrzXqGav4nmy4buqMn1rY8Ld6jTdMFsHehq9yFxvKv5jytQ6lTgRuQjQIkJQ571Epy0sr2/x/za6Zs7JSVeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=FyBiqFZ6; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2a08ced9a36so290445ad.2
        for <io-uring@vger.kernel.org>; Wed, 17 Dec 2025 17:24:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1766021092; x=1766625892; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7Sd9BeJ5hbUGRVg31mFOBPsK2RhgFXD696VkWVSI5rU=;
        b=FyBiqFZ6LhVVHKQ/tztxR3OE51tIQLQuStO9KgaX8vHrny1NN0v3GMh7fyE7P5b13Q
         yisF8mxW8DV6xkRr4wYGJGpaxOvRLrKNzB9Ilbkprh8+TK8kfHMRjqBexuXrAR1XDPUW
         YxRxIFb2Z2rQLuXe/79Gcmxz1firAzd3NpfbZr8gJyZlbP2a7bQ7LCMZNQ4j4vXGPeOt
         GLIOipzgJdygt+Q2Ip0QWuYzVBgOcg2exyWiC+sW+9a1nrm6jClTqBbDnm8aIJf+3xyf
         pRTyvvgJiO3eJGX/amNXMdTgA+qbGw8iHc5TFhOUAlC7l8EG2JHRo99NlWMjfmJ7mkUy
         ePbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766021092; x=1766625892;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7Sd9BeJ5hbUGRVg31mFOBPsK2RhgFXD696VkWVSI5rU=;
        b=Cc8wCt1+0pX/Nr6bMXH7WVrGWWAAdEXwjdtH5Nj10Cv+RdZjEccGmLvDKU5VHWHVwx
         jMyNtXUlqtL2vx4alMXKxK/HuT0KaSE2ZNVHsaGbwNHRe0Psw+/ZyLwzYAw5f2SD7nzM
         MHs/k/osRzTcOZIqfSuw3mKufxhcnS7Y3GGItnphx/VXmEJUH4Qqnq4mjtnoySO/ujKk
         rHAwxeO9/ZRg6+k+erMPNFC1TLKuhq44TOxB50X9uwOGXgKQ1/++ZOfXLxO3aLrsB1Bw
         ut7uekygmnQWIOlhZiPu8eOW0MIFnqau4oyPgBo9DUtLTMKj3Dg3b/J6jA5PR65IS3F/
         FpVA==
X-Forwarded-Encrypted: i=1; AJvYcCU8A7APbjgHz+gKKoQ+iaF0dtH24bBkk+25boZCBs2Ylx29Qzsv56IkOr9io3oQPoglZJYarwJf4Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YyQUVIQ0CY5jrW9ND8eNLULZoA+ExmgUwFmc50FTn2Rl4++hspY
	dPBHRceLk+6gx0bhsKahJrr6YouD6TZzGbN3WRs6yuB3CuDZzdf2ON4FbDTOuXGnBE/uft3xz0k
	PG5/VXDYmnhE9UIZN9+9iz1LCZsxD5+CtdmbVCwBBeA==
X-Gm-Gg: AY/fxX5aoVblMGWEzWroGNKjahepQII2xOzY/urg+/z/kHTrMYyLMbgavudLDQkA9ke
	SZuXiXZPojZC2p1W01mMtvdAna623VCqi7FwF+FgtJS+62m0e96BVWRrwml/+LKmRQhW/nN2qM1
	T7q9ckZraw1bz3WN28E4YoIb25iokt00Q9vyqc3sr2yFI0U/qXaOzvdrt6pe4+9CGsZrgA0Zy7Z
	/etBpP7SLukd0/WjteNRuJ2YPgQudVEyBac8Hgj5dJNWGLB1brb0M6YSeeauD360k06uarH
X-Google-Smtp-Source: AGHT+IEldu5a8bLUUL/puyRgVgme/7sqkOv5mdPu2AP3HZ3baRe2cSd+p4yT5nxhPfFsBAVv3y5itQx8+Aw57x5IhrQ=
X-Received: by 2002:a05:7022:f406:b0:119:e56b:46b6 with SMTP id
 a92af1059eb24-120627a03femr326089c88.0.1766021091662; Wed, 17 Dec 2025
 17:24:51 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251215200909.3505001-1-csander@purestorage.com> <6940ec5c.a70a0220.104cf0.0346.GAE@google.com>
In-Reply-To: <6940ec5c.a70a0220.104cf0.0346.GAE@google.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Wed, 17 Dec 2025 17:24:40 -0800
X-Gm-Features: AQt7F2qLIdTS0N46_a0qJKru-s2JGrOMAQCIoqtDoWm7qEPjWvjTtqyEnFqhjjE
Message-ID: <CADUfDZpmBzNF-+EW3vDmiz4ur7X93WJ5PoK86pveEjgqzK5pcw@mail.gmail.com>
Subject: Re: [syzbot ci] Re: io_uring: avoid uring_lock for IORING_SETUP_SINGLE_ISSUER
To: syzbot ci <syzbot+ci3ff889516a0b26a2@syzkaller.appspotmail.com>
Cc: axboe@kernel.dk, io-uring@vger.kernel.org, joannelkoong@gmail.com, 
	linux-kernel@vger.kernel.org, oliver.sang@intel.com, 
	syzbot@syzkaller.appspotmail.com, syzbot@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 15, 2025 at 9:21=E2=80=AFPM syzbot ci
<syzbot+ci3ff889516a0b26a2@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v5] io_uring: avoid uring_lock for IORING_SETUP_SINGLE_ISSUER
> https://lore.kernel.org/all/20251215200909.3505001-1-csander@purestorage.=
com
> * [PATCH v5 1/6] io_uring: use release-acquire ordering for IORING_SETUP_=
R_DISABLED
> * [PATCH v5 2/6] io_uring: clear IORING_SETUP_SINGLE_ISSUER for IORING_SE=
TUP_SQPOLL
> * [PATCH v5 3/6] io_uring: ensure io_uring_create() initializes submitter=
_task
> * [PATCH v5 4/6] io_uring: use io_ring_submit_lock() in io_iopoll_req_iss=
ued()
> * [PATCH v5 5/6] io_uring: factor out uring_lock helpers
> * [PATCH v5 6/6] io_uring: avoid uring_lock for IORING_SETUP_SINGLE_ISSUE=
R
>
> and found the following issue:
> KASAN: slab-use-after-free Read in task_work_add
>
> Full report is available here:
> https://ci.syzbot.org/series/bce89909-ebf2-45f6-be49-bbd46e33e966
>
> ***
>
> KASAN: slab-use-after-free Read in task_work_add
>
> tree:      torvalds
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torva=
lds/linux
> base:      d358e5254674b70f34c847715ca509e46eb81e6f
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~e=
xp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/db5ac991-f49c-460f-80e4-2a33be76f=
e7c/config
> syz repro: https://ci.syzbot.org/findings/ddbf1feb-6618-4c0f-9a16-15b856f=
20d71/syz_repro
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> BUG: KASAN: slab-use-after-free in task_work_add+0xd7/0x440 kernel/task_w=
ork.c:73
> Read of size 8 at addr ffff88816a8826f8 by task kworker/u9:2/54
>
> CPU: 0 UID: 0 PID: 54 Comm: kworker/u9:2 Not tainted syzkaller #0 PREEMPT=
(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Workqueue: iou_exit io_ring_exit_work
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
>  print_address_description mm/kasan/report.c:378 [inline]
>  print_report+0xca/0x240 mm/kasan/report.c:482
>  kasan_report+0x118/0x150 mm/kasan/report.c:595
>  task_work_add+0xd7/0x440 kernel/task_work.c:73
>  io_ring_ctx_lock_nested io_uring/io_uring.h:271 [inline]
>  io_ring_ctx_lock io_uring/io_uring.h:282 [inline]
>  io_req_caches_free+0x342/0x3e0 io_uring/io_uring.c:2869
>  io_ring_ctx_free+0x56a/0x8e0 io_uring/io_uring.c:2908

The call to io_req_caches_free() comes after the
put_task_struct(ctx->submitter_task) call in io_ring_ctx_free(), so I
guess the task_struct may have already been freed when
io_ring_ctx_lock() is called. Should be simple enough to fix by just
moving the put_task_struct() call to the end of io_ring_ctx_free().

Looking at this made me realize one other small bug, it's incorrect to
assume that if task_work_add() fails because the submitter_task has
exited, the uring lock has been acquired successfully. Even though
submitter_task will no longer be using the uring lock, other tasks
could. So this path needs to acquire the uring_lock mutex, similar to
the IORING_SETUP_SINGLE_ISSUER && IORING_SETUP_R_DISABLED case.

Thanks,
Caleb

>  io_ring_exit_work+0xff9/0x1220 io_uring/io_uring.c:3113
>  process_one_work kernel/workqueue.c:3257 [inline]
>  process_scheduled_works+0xad1/0x1770 kernel/workqueue.c:3340
>  worker_thread+0x8a0/0xda0 kernel/workqueue.c:3421
>  kthread+0x711/0x8a0 kernel/kthread.c:463
>  ret_from_fork+0x599/0xb30 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246
>  </TASK>
>
> Allocated by task 7671:
>  kasan_save_stack mm/kasan/common.c:56 [inline]
>  kasan_save_track+0x3e/0x80 mm/kasan/common.c:77
>  unpoison_slab_object mm/kasan/common.c:339 [inline]
>  __kasan_slab_alloc+0x6c/0x80 mm/kasan/common.c:365
>  kasan_slab_alloc include/linux/kasan.h:252 [inline]
>  slab_post_alloc_hook mm/slub.c:4953 [inline]
>  slab_alloc_node mm/slub.c:5263 [inline]
>  kmem_cache_alloc_node_noprof+0x43c/0x720 mm/slub.c:5315
>  alloc_task_struct_node kernel/fork.c:184 [inline]
>  dup_task_struct+0x57/0x9a0 kernel/fork.c:915
>  copy_process+0x4ea/0x3950 kernel/fork.c:2052
>  kernel_clone+0x21e/0x820 kernel/fork.c:2651
>  __do_sys_clone3 kernel/fork.c:2953 [inline]
>  __se_sys_clone3+0x256/0x2d0 kernel/fork.c:2932
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> Freed by task 6024:
>  kasan_save_stack mm/kasan/common.c:56 [inline]
>  kasan_save_track+0x3e/0x80 mm/kasan/common.c:77
>  kasan_save_free_info+0x46/0x50 mm/kasan/generic.c:584
>  poison_slab_object mm/kasan/common.c:252 [inline]
>  __kasan_slab_free+0x5c/0x80 mm/kasan/common.c:284
>  kasan_slab_free include/linux/kasan.h:234 [inline]
>  slab_free_hook mm/slub.c:2540 [inline]
>  slab_free mm/slub.c:6668 [inline]
>  kmem_cache_free+0x197/0x620 mm/slub.c:6779
>  rcu_do_batch kernel/rcu/tree.c:2605 [inline]
>  rcu_core+0xd70/0x1870 kernel/rcu/tree.c:2857
>  handle_softirqs+0x27d/0x850 kernel/softirq.c:622
>  __do_softirq kernel/softirq.c:656 [inline]
>  invoke_softirq kernel/softirq.c:496 [inline]
>  __irq_exit_rcu+0xca/0x1f0 kernel/softirq.c:723
>  irq_exit_rcu+0x9/0x30 kernel/softirq.c:739
>  instr_sysvec_call_function_single arch/x86/kernel/smp.c:266 [inline]
>  sysvec_call_function_single+0xa3/0xc0 arch/x86/kernel/smp.c:266
>  asm_sysvec_call_function_single+0x1a/0x20 arch/x86/include/asm/idtentry.=
h:704
>
> Last potentially related work creation:
>  kasan_save_stack+0x3e/0x60 mm/kasan/common.c:56
>  kasan_record_aux_stack+0xbd/0xd0 mm/kasan/generic.c:556
>  __call_rcu_common kernel/rcu/tree.c:3119 [inline]
>  call_rcu+0x157/0x9c0 kernel/rcu/tree.c:3239
>  rcu_do_batch kernel/rcu/tree.c:2605 [inline]
>  rcu_core+0xd70/0x1870 kernel/rcu/tree.c:2857
>  handle_softirqs+0x27d/0x850 kernel/softirq.c:622
>  run_ksoftirqd+0x9b/0x100 kernel/softirq.c:1063
>  smpboot_thread_fn+0x542/0xa60 kernel/smpboot.c:160
>  kthread+0x711/0x8a0 kernel/kthread.c:463
>  ret_from_fork+0x599/0xb30 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246
>
> Second to last potentially related work creation:
>  kasan_save_stack+0x3e/0x60 mm/kasan/common.c:56
>  kasan_record_aux_stack+0xbd/0xd0 mm/kasan/generic.c:556
>  __call_rcu_common kernel/rcu/tree.c:3119 [inline]
>  call_rcu+0x157/0x9c0 kernel/rcu/tree.c:3239
>  context_switch kernel/sched/core.c:5259 [inline]
>  __schedule+0x14c4/0x5000 kernel/sched/core.c:6863
>  preempt_schedule_irq+0xb5/0x150 kernel/sched/core.c:7190
>  irqentry_exit+0x5d8/0x660 kernel/entry/common.c:216
>  asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.=
h:697
>
> The buggy address belongs to the object at ffff88816a881d40
>  which belongs to the cache task_struct of size 7232
> The buggy address is located 2488 bytes inside of
>  freed 7232-byte region [ffff88816a881d40, ffff88816a883980)
>
> The buggy address belongs to the physical page:
> page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x16a8=
80
> head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
> memcg:ffff8881726b0441
> anon flags: 0x57ff00000000040(head|node=3D1|zone=3D2|lastcpupid=3D0x7ff)
> page_type: f5(slab)
> raw: 057ff00000000040 ffff88816040a500 0000000000000000 0000000000000001
> raw: 0000000000000000 0000000080040004 00000000f5000000 ffff8881726b0441
> head: 057ff00000000040 ffff88816040a500 0000000000000000 0000000000000001
> head: 0000000000000000 0000000080040004 00000000f5000000 ffff8881726b0441
> head: 057ff00000000003 ffffea0005aa2001 00000000ffffffff 00000000ffffffff
> head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000008
> page dumped because: kasan: bad access detected
> page_owner tracks the page as allocated
> page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd20c0(=
__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), =
pid 7291, tgid 7291 (syz.2.649), ts 88142964676, free_ts 88127352940
>  set_page_owner include/linux/page_owner.h:32 [inline]
>  post_alloc_hook+0x234/0x290 mm/page_alloc.c:1846
>  prep_new_page mm/page_alloc.c:1854 [inline]
>  get_page_from_freelist+0x2365/0x2440 mm/page_alloc.c:3915
>  __alloc_frozen_pages_noprof+0x181/0x370 mm/page_alloc.c:5210
>  alloc_pages_mpol+0x232/0x4a0 mm/mempolicy.c:2486
>  alloc_slab_page mm/slub.c:3075 [inline]
>  allocate_slab+0x86/0x3b0 mm/slub.c:3248
>  new_slab mm/slub.c:3302 [inline]
>  ___slab_alloc+0xf2b/0x1960 mm/slub.c:4656
>  __slab_alloc+0x65/0x100 mm/slub.c:4779
>  __slab_alloc_node mm/slub.c:4855 [inline]
>  slab_alloc_node mm/slub.c:5251 [inline]
>  kmem_cache_alloc_node_noprof+0x4ce/0x720 mm/slub.c:5315
>  alloc_task_struct_node kernel/fork.c:184 [inline]
>  dup_task_struct+0x57/0x9a0 kernel/fork.c:915
>  copy_process+0x4ea/0x3950 kernel/fork.c:2052
>  kernel_clone+0x21e/0x820 kernel/fork.c:2651
>  __do_sys_clone3 kernel/fork.c:2953 [inline]
>  __se_sys_clone3+0x256/0x2d0 kernel/fork.c:2932
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> page last free pid 5275 tgid 5275 stack trace:
>  reset_page_owner include/linux/page_owner.h:25 [inline]
>  free_pages_prepare mm/page_alloc.c:1395 [inline]
>  __free_frozen_pages+0xbc8/0xd30 mm/page_alloc.c:2943
>  __slab_free+0x21b/0x2a0 mm/slub.c:6004
>  qlink_free mm/kasan/quarantine.c:163 [inline]
>  qlist_free_all+0x97/0x100 mm/kasan/quarantine.c:179
>  kasan_quarantine_reduce+0x148/0x160 mm/kasan/quarantine.c:286
>  __kasan_slab_alloc+0x22/0x80 mm/kasan/common.c:349
>  kasan_slab_alloc include/linux/kasan.h:252 [inline]
>  slab_post_alloc_hook mm/slub.c:4953 [inline]
>  slab_alloc_node mm/slub.c:5263 [inline]
>  kmem_cache_alloc_noprof+0x37d/0x710 mm/slub.c:5270
>  getname_flags+0xb8/0x540 fs/namei.c:146
>  getname include/linux/fs.h:2498 [inline]
>  do_sys_openat2+0xbc/0x200 fs/open.c:1426
>  do_sys_open fs/open.c:1436 [inline]
>  __do_sys_openat fs/open.c:1452 [inline]
>  __se_sys_openat fs/open.c:1447 [inline]
>  __x64_sys_openat+0x138/0x170 fs/open.c:1447
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> Memory state around the buggy address:
>  ffff88816a882580: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff88816a882600: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> >ffff88816a882680: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>                                                                 ^
>  ffff88816a882700: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff88816a882780: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
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

