Return-Path: <io-uring+bounces-11121-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 3956ACC1018
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 06:25:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BCEBC30456CF
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 05:21:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88DB1335093;
	Tue, 16 Dec 2025 05:21:48 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com [209.85.210.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D24431A046
	for <io-uring@vger.kernel.org>; Tue, 16 Dec 2025 05:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765862507; cv=none; b=FJBn4cBASXmWaMbrpf9k4LZo65GjDpNLYQPXS8vbp6glqhG0zMBjYLjTmiXwCZt19wJIx3C9/TQbknoZu2WbK31oHjq3nH27F1DMEllGfnOkmRdZmZtBY7KzdliO9QPGW7DcuuOoz2RpxdLpGEcK/4JehPQ923NaWcqooA9yp10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765862507; c=relaxed/simple;
	bh=lB8+FWocWBfaqgrIfB+btJXFA+F/GcTyhUXPnHftTVs=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=ZThoMP0i7uStOBvK5arnEYaX0N38vlLHJfjKAJHlTAEttfGNduuYpIqIA+AtxEqHCYOXgDlwU5fG9/7ViXyDwXiAMymof0N/7Rkw2lu9sOLSYE7UMPiUARmhCInxrsiqdN3l+iHftbg4xqrEUFITOIsSxJajZVsVztDr8B/5BEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-7c75798bfacso9468686a34.1
        for <io-uring@vger.kernel.org>; Mon, 15 Dec 2025 21:21:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765862492; x=1766467292;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2j5c18997cWIEphc3/8gxdTjRwJf8GlBeLLyx+/QfYg=;
        b=fzCv9VjYNrL2KJgsv+mECJrAsvZaidmQ//X78N4ZIFLN21OhC9Frey9xCxJGSFik+q
         pNoPvYgcoaRZjyhl4y3lBn4zRZhQEVI8DreVUDcduN+yBK8l4kpcrVvI8iGTF0frUOaZ
         TlxML9qOU7v0+nWqPuqdj4KFI46eEuTCcz8kJM562b7tHK901xpEmH/mIOq8yYnQBnO5
         /vWlH3K5eLdkL0ZFRhGZmR1rDsA3kji4pu1eeEq/ybSgVbg6LLj9rKv876wPK2RNT3N6
         VidG7eezxhvUWztddiHojFEVdzx+4cjO9pm7i4YraRFlyQJobtxW6t8YmTXA5e9RZ8AI
         qndw==
X-Forwarded-Encrypted: i=1; AJvYcCUcs2VU+Yyr1JkoY86kdmV4HEZRtQlYJfHTpmNAAwQd/uW5JntVQDTQ++/7iQwUvKiLSysjoFFKZQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YycJg11B59tQKxJ7FBSzRdf3QOoWO/b2KST0lViQXJtTPIqfJv2
	/US+7bp3QUm5FI/JlNhj4iKyxZHJr8aFhMElsK3jx9O4y5iIr9WnHRrm1qpRh7frdDuN5YTk+mx
	ZW+QTYVtgkWIHPIBDsmzI/y4JpD+PIocxDXqKBTmxrtXPZUZBztiklFK+Nmg=
X-Google-Smtp-Source: AGHT+IHHu41z35PT75t3qXdxsC5A3Tvfuj7OOmpc54N7fE4xyWXtZDef522F/fqGsEeECNy31P4ru6T5em/jRkK4poUPLcGW6rmh
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:4c15:b0:659:9a49:8f9e with SMTP id
 006d021491bc7-65b451b6c62mr6480890eaf.23.1765862492423; Mon, 15 Dec 2025
 21:21:32 -0800 (PST)
Date: Mon, 15 Dec 2025 21:21:32 -0800
In-Reply-To: <20251215200909.3505001-1-csander@purestorage.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6940ec5c.a70a0220.104cf0.0346.GAE@google.com>
Subject: [syzbot ci] Re: io_uring: avoid uring_lock for IORING_SETUP_SINGLE_ISSUER
From: syzbot ci <syzbot+ci3ff889516a0b26a2@syzkaller.appspotmail.com>
To: axboe@kernel.dk, csander@purestorage.com, io-uring@vger.kernel.org, 
	joannelkoong@gmail.com, linux-kernel@vger.kernel.org, oliver.sang@intel.com, 
	syzbot@syzkaller.appspotmail.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v5] io_uring: avoid uring_lock for IORING_SETUP_SINGLE_ISSUER
https://lore.kernel.org/all/20251215200909.3505001-1-csander@purestorage.com
* [PATCH v5 1/6] io_uring: use release-acquire ordering for IORING_SETUP_R_DISABLED
* [PATCH v5 2/6] io_uring: clear IORING_SETUP_SINGLE_ISSUER for IORING_SETUP_SQPOLL
* [PATCH v5 3/6] io_uring: ensure io_uring_create() initializes submitter_task
* [PATCH v5 4/6] io_uring: use io_ring_submit_lock() in io_iopoll_req_issued()
* [PATCH v5 5/6] io_uring: factor out uring_lock helpers
* [PATCH v5 6/6] io_uring: avoid uring_lock for IORING_SETUP_SINGLE_ISSUER

and found the following issue:
KASAN: slab-use-after-free Read in task_work_add

Full report is available here:
https://ci.syzbot.org/series/bce89909-ebf2-45f6-be49-bbd46e33e966

***

KASAN: slab-use-after-free Read in task_work_add

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      d358e5254674b70f34c847715ca509e46eb81e6f
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/db5ac991-f49c-460f-80e4-2a33be76fe7c/config
syz repro: https://ci.syzbot.org/findings/ddbf1feb-6618-4c0f-9a16-15b856f20d71/syz_repro

==================================================================
BUG: KASAN: slab-use-after-free in task_work_add+0xd7/0x440 kernel/task_work.c:73
Read of size 8 at addr ffff88816a8826f8 by task kworker/u9:2/54

CPU: 0 UID: 0 PID: 54 Comm: kworker/u9:2 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Workqueue: iou_exit io_ring_exit_work
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0xca/0x240 mm/kasan/report.c:482
 kasan_report+0x118/0x150 mm/kasan/report.c:595
 task_work_add+0xd7/0x440 kernel/task_work.c:73
 io_ring_ctx_lock_nested io_uring/io_uring.h:271 [inline]
 io_ring_ctx_lock io_uring/io_uring.h:282 [inline]
 io_req_caches_free+0x342/0x3e0 io_uring/io_uring.c:2869
 io_ring_ctx_free+0x56a/0x8e0 io_uring/io_uring.c:2908
 io_ring_exit_work+0xff9/0x1220 io_uring/io_uring.c:3113
 process_one_work kernel/workqueue.c:3257 [inline]
 process_scheduled_works+0xad1/0x1770 kernel/workqueue.c:3340
 worker_thread+0x8a0/0xda0 kernel/workqueue.c:3421
 kthread+0x711/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x599/0xb30 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246
 </TASK>

Allocated by task 7671:
 kasan_save_stack mm/kasan/common.c:56 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:77
 unpoison_slab_object mm/kasan/common.c:339 [inline]
 __kasan_slab_alloc+0x6c/0x80 mm/kasan/common.c:365
 kasan_slab_alloc include/linux/kasan.h:252 [inline]
 slab_post_alloc_hook mm/slub.c:4953 [inline]
 slab_alloc_node mm/slub.c:5263 [inline]
 kmem_cache_alloc_node_noprof+0x43c/0x720 mm/slub.c:5315
 alloc_task_struct_node kernel/fork.c:184 [inline]
 dup_task_struct+0x57/0x9a0 kernel/fork.c:915
 copy_process+0x4ea/0x3950 kernel/fork.c:2052
 kernel_clone+0x21e/0x820 kernel/fork.c:2651
 __do_sys_clone3 kernel/fork.c:2953 [inline]
 __se_sys_clone3+0x256/0x2d0 kernel/fork.c:2932
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Freed by task 6024:
 kasan_save_stack mm/kasan/common.c:56 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:77
 kasan_save_free_info+0x46/0x50 mm/kasan/generic.c:584
 poison_slab_object mm/kasan/common.c:252 [inline]
 __kasan_slab_free+0x5c/0x80 mm/kasan/common.c:284
 kasan_slab_free include/linux/kasan.h:234 [inline]
 slab_free_hook mm/slub.c:2540 [inline]
 slab_free mm/slub.c:6668 [inline]
 kmem_cache_free+0x197/0x620 mm/slub.c:6779
 rcu_do_batch kernel/rcu/tree.c:2605 [inline]
 rcu_core+0xd70/0x1870 kernel/rcu/tree.c:2857
 handle_softirqs+0x27d/0x850 kernel/softirq.c:622
 __do_softirq kernel/softirq.c:656 [inline]
 invoke_softirq kernel/softirq.c:496 [inline]
 __irq_exit_rcu+0xca/0x1f0 kernel/softirq.c:723
 irq_exit_rcu+0x9/0x30 kernel/softirq.c:739
 instr_sysvec_call_function_single arch/x86/kernel/smp.c:266 [inline]
 sysvec_call_function_single+0xa3/0xc0 arch/x86/kernel/smp.c:266
 asm_sysvec_call_function_single+0x1a/0x20 arch/x86/include/asm/idtentry.h:704

Last potentially related work creation:
 kasan_save_stack+0x3e/0x60 mm/kasan/common.c:56
 kasan_record_aux_stack+0xbd/0xd0 mm/kasan/generic.c:556
 __call_rcu_common kernel/rcu/tree.c:3119 [inline]
 call_rcu+0x157/0x9c0 kernel/rcu/tree.c:3239
 rcu_do_batch kernel/rcu/tree.c:2605 [inline]
 rcu_core+0xd70/0x1870 kernel/rcu/tree.c:2857
 handle_softirqs+0x27d/0x850 kernel/softirq.c:622
 run_ksoftirqd+0x9b/0x100 kernel/softirq.c:1063
 smpboot_thread_fn+0x542/0xa60 kernel/smpboot.c:160
 kthread+0x711/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x599/0xb30 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246

Second to last potentially related work creation:
 kasan_save_stack+0x3e/0x60 mm/kasan/common.c:56
 kasan_record_aux_stack+0xbd/0xd0 mm/kasan/generic.c:556
 __call_rcu_common kernel/rcu/tree.c:3119 [inline]
 call_rcu+0x157/0x9c0 kernel/rcu/tree.c:3239
 context_switch kernel/sched/core.c:5259 [inline]
 __schedule+0x14c4/0x5000 kernel/sched/core.c:6863
 preempt_schedule_irq+0xb5/0x150 kernel/sched/core.c:7190
 irqentry_exit+0x5d8/0x660 kernel/entry/common.c:216
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:697

The buggy address belongs to the object at ffff88816a881d40
 which belongs to the cache task_struct of size 7232
The buggy address is located 2488 bytes inside of
 freed 7232-byte region [ffff88816a881d40, ffff88816a883980)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x16a880
head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
memcg:ffff8881726b0441
anon flags: 0x57ff00000000040(head|node=1|zone=2|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 057ff00000000040 ffff88816040a500 0000000000000000 0000000000000001
raw: 0000000000000000 0000000080040004 00000000f5000000 ffff8881726b0441
head: 057ff00000000040 ffff88816040a500 0000000000000000 0000000000000001
head: 0000000000000000 0000000080040004 00000000f5000000 ffff8881726b0441
head: 057ff00000000003 ffffea0005aa2001 00000000ffffffff 00000000ffffffff
head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000008
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 7291, tgid 7291 (syz.2.649), ts 88142964676, free_ts 88127352940
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x234/0x290 mm/page_alloc.c:1846
 prep_new_page mm/page_alloc.c:1854 [inline]
 get_page_from_freelist+0x2365/0x2440 mm/page_alloc.c:3915
 __alloc_frozen_pages_noprof+0x181/0x370 mm/page_alloc.c:5210
 alloc_pages_mpol+0x232/0x4a0 mm/mempolicy.c:2486
 alloc_slab_page mm/slub.c:3075 [inline]
 allocate_slab+0x86/0x3b0 mm/slub.c:3248
 new_slab mm/slub.c:3302 [inline]
 ___slab_alloc+0xf2b/0x1960 mm/slub.c:4656
 __slab_alloc+0x65/0x100 mm/slub.c:4779
 __slab_alloc_node mm/slub.c:4855 [inline]
 slab_alloc_node mm/slub.c:5251 [inline]
 kmem_cache_alloc_node_noprof+0x4ce/0x720 mm/slub.c:5315
 alloc_task_struct_node kernel/fork.c:184 [inline]
 dup_task_struct+0x57/0x9a0 kernel/fork.c:915
 copy_process+0x4ea/0x3950 kernel/fork.c:2052
 kernel_clone+0x21e/0x820 kernel/fork.c:2651
 __do_sys_clone3 kernel/fork.c:2953 [inline]
 __se_sys_clone3+0x256/0x2d0 kernel/fork.c:2932
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
page last free pid 5275 tgid 5275 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 free_pages_prepare mm/page_alloc.c:1395 [inline]
 __free_frozen_pages+0xbc8/0xd30 mm/page_alloc.c:2943
 __slab_free+0x21b/0x2a0 mm/slub.c:6004
 qlink_free mm/kasan/quarantine.c:163 [inline]
 qlist_free_all+0x97/0x100 mm/kasan/quarantine.c:179
 kasan_quarantine_reduce+0x148/0x160 mm/kasan/quarantine.c:286
 __kasan_slab_alloc+0x22/0x80 mm/kasan/common.c:349
 kasan_slab_alloc include/linux/kasan.h:252 [inline]
 slab_post_alloc_hook mm/slub.c:4953 [inline]
 slab_alloc_node mm/slub.c:5263 [inline]
 kmem_cache_alloc_noprof+0x37d/0x710 mm/slub.c:5270
 getname_flags+0xb8/0x540 fs/namei.c:146
 getname include/linux/fs.h:2498 [inline]
 do_sys_openat2+0xbc/0x200 fs/open.c:1426
 do_sys_open fs/open.c:1436 [inline]
 __do_sys_openat fs/open.c:1452 [inline]
 __se_sys_openat fs/open.c:1447 [inline]
 __x64_sys_openat+0x138/0x170 fs/open.c:1447
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Memory state around the buggy address:
 ffff88816a882580: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88816a882600: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff88816a882680: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                                ^
 ffff88816a882700: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88816a882780: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

