Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CDA14BED17
	for <lists+io-uring@lfdr.de>; Mon, 21 Feb 2022 23:17:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235338AbiBUWRr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 21 Feb 2022 17:17:47 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235352AbiBUWRq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 21 Feb 2022 17:17:46 -0500
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 618D3237F0
        for <io-uring@vger.kernel.org>; Mon, 21 Feb 2022 14:17:21 -0800 (PST)
Received: by mail-il1-f197.google.com with SMTP id g3-20020a925203000000b002c21a31fa82so3657417ilb.20
        for <io-uring@vger.kernel.org>; Mon, 21 Feb 2022 14:17:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=7G1L+UZCkRtKTExhB074lVqInT2YSOtP+eCs0vTOyRQ=;
        b=2B1a9KRortgbq99y14bLDHSlodcAhYFQ1XpOChBZ219P0BPDxaSnKfnqzb0gR6p/AB
         qzMK3xZg2u+cMw2MdbKvFriRA5zTPkRU2wrq7Gzvb3UVS5zPBWmJam2WDaLh7xHxAml6
         iiL7lghQbyU00IrrSMAcR5dufgvyosGxa05wrfA22MxUI2wVhShgZcvFtzKCqwP25G7d
         IcjiztjFMF/L0ujmr6fXfSit24PLKYRmE/GkoJvN4fpsKwR04UH7AASXc0kV5KvHK237
         BT5+ieu0rFGzXQSMoRkUetLvWrJmUuOzpC7Yzli8AqB0CTM5YsZQTBNfVWyHWNPl9soD
         bgaw==
X-Gm-Message-State: AOAM531LEWOtyAj5A4mm677xYbJaFu7AVHqBks7A7iARhufacZ80rf73
        oVF+FRmxFjtQQMuWQTkPwm4rOr7aCyUXS9vPD2dX9c8QWS5U
X-Google-Smtp-Source: ABdhPJypr3jhuQDsTYXQU0rpr1g75P5iIen+CQbW3DrbX0yPukwkWguvXyvmTzTZ+NxgClhlTAl7d7KkKqfy4kJLeJQchIksdgGA
MIME-Version: 1.0
X-Received: by 2002:a92:200e:0:b0:2bc:7923:9bd7 with SMTP id
 j14-20020a92200e000000b002bc79239bd7mr18543202ile.195.1645481840699; Mon, 21
 Feb 2022 14:17:20 -0800 (PST)
Date:   Mon, 21 Feb 2022 14:17:20 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000996de005d88e985f@google.com>
Subject: [syzbot] KASAN: use-after-free Read in io_rsrc_node_ref_zero
From:   syzbot <syzbot+ca8bf833622a1662745b@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, dylany@fb.com,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    7f25f0412c9e Merge tag 'fs.mount_setattr.v5.17-rc4' of git..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12255046700000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f6a069ed94a1ed1d
dashboard link: https://syzkaller.appspot.com/bug?extid=ca8bf833622a1662745b
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11bfa1de700000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11d86902700000

The issue was bisected to:

commit b36a2050040b2d839bdc044007cdd57101d7f881
Author: Dylan Yudaken <dylany@fb.com>
Date:   Fri Jan 21 12:38:56 2022 +0000

    io_uring: fix bug in slow unregistering of nodes

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=150cfdee700000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=170cfdee700000
console output: https://syzkaller.appspot.com/x/log.txt?x=130cfdee700000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+ca8bf833622a1662745b@syzkaller.appspotmail.com
Fixes: b36a2050040b ("io_uring: fix bug in slow unregistering of nodes")

==================================================================
BUG: KASAN: use-after-free in io_rsrc_node_ref_zero+0x5a/0x274 fs/io_uring.c:7821
Read of size 8 at addr ffff888014fd2a00 by task syz-executor309/3618

CPU: 1 PID: 3618 Comm: syz-executor309 Not tainted 5.17.0-rc4-syzkaller-00241-g7f25f0412c9e #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_address_description.constprop.0.cold+0x8d/0x303 mm/kasan/report.c:255
 __kasan_report mm/kasan/report.c:442 [inline]
 kasan_report.cold+0x83/0xdf mm/kasan/report.c:459
 io_rsrc_node_ref_zero+0x5a/0x274 fs/io_uring.c:7821
 percpu_ref_put_many.constprop.0+0x22b/0x260 include/linux/percpu-refcount.h:335
 rcu_do_batch kernel/rcu/tree.c:2527 [inline]
 rcu_core+0x7b1/0x1820 kernel/rcu/tree.c:2778
 __do_softirq+0x29b/0x9c2 kernel/softirq.c:558
 invoke_softirq kernel/softirq.c:432 [inline]
 __irq_exit_rcu+0x123/0x180 kernel/softirq.c:637
 irq_exit_rcu+0x5/0x20 kernel/softirq.c:649
 sysvec_apic_timer_interrupt+0x93/0xc0 arch/x86/kernel/apic/apic.c:1097
 </IRQ>
 <TASK>
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:638
RIP: 0010:preempt_count arch/x86/include/asm/preempt.h:27 [inline]
RIP: 0010:check_kcov_mode kernel/kcov.c:166 [inline]
RIP: 0010:__sanitizer_cov_trace_pc+0x0/0x60 kernel/kcov.c:200
Code: 48 89 ef 5d e9 41 8b 46 00 5d be 03 00 00 00 e9 d6 f7 67 02 66 0f 1f 44 00 00 48 8b be b0 01 00 00 e8 b4 ff ff ff 31 c0 c3 90 <65> 8b 05 39 5b 8a 7e 89 c1 48 8b 34 24 81 e1 00 01 00 00 65 48 8b
RSP: 0018:ffffc90002087e08 EFLAGS: 00000293
RAX: 0000000000000000 RBX: 0000000000000200 RCX: 0000000000000000
RDX: ffff88807e2b6140 RSI: ffffffff8167f8f4 RDI: 0000000000000003
RBP: 00000000000021ac R08: 0000000000000000 R09: 0000000000000001
R10: ffffffff8167f8ea R11: 0000000000000001 R12: 0000000000000000
R13: dffffc0000000000 R14: 00007fa4f85b44ac R15: 00007ffe9f5e7080
 __seqprop_raw_spinlock_sequence include/linux/seqlock.h:276 [inline]
 timekeeping_get_delta kernel/time/timekeeping.c:252 [inline]
 timekeeping_get_ns kernel/time/timekeeping.c:386 [inline]
 ktime_get+0x19a/0x470 kernel/time/timekeeping.c:829
 futex_init_timeout kernel/futex/syscalls.c:158 [inline]
 __do_sys_futex kernel/futex/syscalls.c:177 [inline]
 __se_sys_futex kernel/futex/syscalls.c:164 [inline]
 __x64_sys_futex+0x388/0x4a0 kernel/futex/syscalls.c:164
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7fa4f852b1c9
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 41 15 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffe9f5e04e8 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
RAX: ffffffffffffffda RBX: 000000000000babd RCX: 00007fa4f852b1c9
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 00007fa4f85b44ac
RBP: 0000000000000032 R08: 00007ffe9f5e7080 R09: 0000000000000000
R10: 00007ffe9f5e0520 R11: 0000000000000246 R12: 00007fa4f85b44ac
R13: 00007ffe9f5e0520 R14: 00007ffe9f5e0540 R15: 00007fa4f84e72d0
 </TASK>

Allocated by task 3606:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:45 [inline]
 set_alloc_info mm/kasan/common.c:436 [inline]
 ____kasan_kmalloc mm/kasan/common.c:515 [inline]
 ____kasan_kmalloc mm/kasan/common.c:474 [inline]
 __kasan_kmalloc+0xa6/0xd0 mm/kasan/common.c:524
 kasan_kmalloc include/linux/kasan.h:270 [inline]
 __do_kmalloc mm/slab.c:3694 [inline]
 __kmalloc+0x209/0x4d0 mm/slab.c:3703
 io_rsrc_data_alloc+0x40/0x3b8 fs/io_uring.c:7968
 io_sqe_buffers_register.cold+0x1f/0x443 fs/io_uring.c:9255
 __io_uring_register fs/io_uring.c:11039 [inline]
 __do_sys_io_uring_register+0x109b/0x15a0 fs/io_uring.c:11170
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Freed by task 3606:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
 kasan_set_track+0x21/0x30 mm/kasan/common.c:45
 kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:370
 ____kasan_slab_free mm/kasan/common.c:366 [inline]
 ____kasan_slab_free+0xff/0x140 mm/kasan/common.c:328
 kasan_slab_free include/linux/kasan.h:236 [inline]
 __cache_free mm/slab.c:3437 [inline]
 kfree+0xf8/0x2b0 mm/slab.c:3794
 __io_sqe_buffers_unregister+0xf6/0x18d fs/io_uring.c:8997
 io_sqe_buffers_unregister fs/io_uring.c:9012 [inline]
 __io_uring_register fs/io_uring.c:11045 [inline]
 __do_sys_io_uring_register.cold+0x28f/0x1611 fs/io_uring.c:11170
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

The buggy address belongs to the object at ffff888014fd2a00
 which belongs to the cache kmalloc-192 of size 192
The buggy address is located 0 bytes inside of
 192-byte region [ffff888014fd2a00, ffff888014fd2ac0)
The buggy address belongs to the page:
page:ffffea000053f480 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x14fd2
flags: 0xfff00000000200(slab|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000000200 ffffea000053f388 ffffea000052fac8 ffff888010c40000
raw: 0000000000000000 ffff888014fd2000 0000000100000010 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0x2420c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_COMP|__GFP_THISNODE), pid 1, ts 2173654799, free_ts 0
 prep_new_page mm/page_alloc.c:2434 [inline]
 get_page_from_freelist+0xa72/0x2f50 mm/page_alloc.c:4165
 __alloc_pages+0x1b2/0x500 mm/page_alloc.c:5389
 __alloc_pages_node include/linux/gfp.h:572 [inline]
 kmem_getpages mm/slab.c:1378 [inline]
 cache_grow_begin+0x75/0x390 mm/slab.c:2584
 cache_alloc_refill+0x27f/0x380 mm/slab.c:2957
 ____cache_alloc mm/slab.c:3040 [inline]
 ____cache_alloc mm/slab.c:3023 [inline]
 __do_cache_alloc mm/slab.c:3267 [inline]
 slab_alloc mm/slab.c:3308 [inline]
 kmem_cache_alloc_trace+0x380/0x4a0 mm/slab.c:3565
 kmalloc include/linux/slab.h:581 [inline]
 kzalloc include/linux/slab.h:715 [inline]
 call_usermodehelper_setup+0x9d/0x340 kernel/umh.c:365
 kobject_uevent_env+0xf28/0x1600 lib/kobject_uevent.c:614
 kernel_add_sysfs_param kernel/params.c:816 [inline]
 param_sysfs_builtin kernel/params.c:851 [inline]
 param_sysfs_init+0x367/0x43b kernel/params.c:970
 do_one_initcall+0x103/0x650 init/main.c:1300
 do_initcall_level init/main.c:1373 [inline]
 do_initcalls init/main.c:1389 [inline]
 do_basic_setup init/main.c:1408 [inline]
 kernel_init_freeable+0x6b1/0x73a init/main.c:1613
 kernel_init+0x1a/0x1d0 init/main.c:1502
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
page_owner free stack trace missing

Memory state around the buggy address:
 ffff888014fd2900: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888014fd2980: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
>ffff888014fd2a00: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                   ^
 ffff888014fd2a80: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
 ffff888014fd2b00: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================
----------------
Code disassembly (best guess):
   0:	48 89 ef             	mov    %rbp,%rdi
   3:	5d                   	pop    %rbp
   4:	e9 41 8b 46 00       	jmpq   0x468b4a
   9:	5d                   	pop    %rbp
   a:	be 03 00 00 00       	mov    $0x3,%esi
   f:	e9 d6 f7 67 02       	jmpq   0x267f7ea
  14:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  1a:	48 8b be b0 01 00 00 	mov    0x1b0(%rsi),%rdi
  21:	e8 b4 ff ff ff       	callq  0xffffffda
  26:	31 c0                	xor    %eax,%eax
  28:	c3                   	retq
  29:	90                   	nop
* 2a:	65 8b 05 39 5b 8a 7e 	mov    %gs:0x7e8a5b39(%rip),%eax        # 0x7e8a5b6a <-- trapping instruction
  31:	89 c1                	mov    %eax,%ecx
  33:	48 8b 34 24          	mov    (%rsp),%rsi
  37:	81 e1 00 01 00 00    	and    $0x100,%ecx
  3d:	65                   	gs
  3e:	48                   	rex.W
  3f:	8b                   	.byte 0x8b


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
