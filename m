Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0887A4804EE
	for <lists+io-uring@lfdr.de>; Mon, 27 Dec 2021 22:48:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231567AbhL0VsA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Dec 2021 16:48:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbhL0Vr7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Dec 2021 16:47:59 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 699A4C06173E;
        Mon, 27 Dec 2021 13:47:59 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id v13-20020a17090a088d00b001b0e3a74cf7so11821979pjc.1;
        Mon, 27 Dec 2021 13:47:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=8BqrLLp8FovYcUrCTZAVmNxJZVj8n2OkgAiYe9u3Z7s=;
        b=XaF0lDrEBwOg5bdMGA+JOiBsoRQyHtZYrg7M2UMZGLVFVZJA0ED6g50L3Q8d2kebkk
         2yV/HhzXJUxhfTODT+C2FGsFXCEhO8L+rs6ceVzfdGOgvyWXqePGLkLDwIG3G5bepNlF
         //uvYCB+NkXYx54FVLQWQxvZxT/ynz7Kg/qJp/k8mKDy99VpTysMbTJg16+bwtOaWfMd
         s3Ch6RqeXqYNqKb4mkp/R8tGupElGiU3Lz/drXAoV+Y8a8rdcjuer8+jCymSsRwOc7dO
         B6+dxcZX127h3K20T9yGepQzW+GFAV83gl8jgCXGGfKpa4S4kxFrB963Hd4JQ/n1jnzC
         7r9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=8BqrLLp8FovYcUrCTZAVmNxJZVj8n2OkgAiYe9u3Z7s=;
        b=Auo3zFvTO1Qx+0ddzoEWnIUUhhdzDS0jHAj8AcsWOdb0BDiV+7NQ8N4KXxgaif/ibQ
         K45MHi9HK19rjRR33l0DXBfvw5yP65KKyPHNWjQRWx3nFrkIDfwgLUzPF3Qhbm41ZU7s
         yR+pGij1PaFitw4ooRm0z0NzA9fRudKennINbkB/h/j6d4iV8He9+epbsyu8OYw5VWqY
         /oC99BGrygyuImHrbXOeT+LUbjTr28zsJNRbxqctcypeRdptH5d1m+VEngbtbjdgstub
         bTKvDzLrkWBoteFJcVbch50MVXFLxLMVFxf0/9yJ0yDsbRM4oHsdh2fHaDx7yzVcsBPp
         lAAA==
X-Gm-Message-State: AOAM533il9lIXVYnOyYjIB4eIS+J7p39/TitXvBdQBF8JKXx3PmZ6ErO
        6lOEyJBAgA9ZOVBnPiD/szD+wLQadT9MuRTb/q01ab7vNuUCBA==
X-Google-Smtp-Source: ABdhPJwJS4x/dkPmfqRLXx7MUSP7S22262dT8wLWEXhTaUw6E17zsl3u3E40C48jdQWmydzFeDzhTuDVk4mQDJaidNg=
X-Received: by 2002:a17:90b:3b8e:: with SMTP id pc14mr23163753pjb.217.1640641678327;
 Mon, 27 Dec 2021 13:47:58 -0800 (PST)
MIME-Version: 1.0
From:   Palash Oswal <oswalpalash@gmail.com>
Date:   Mon, 27 Dec 2021 11:47:47 -0500
Message-ID: <CAGyP=7dYrn8ej=CcafiFQUH-=_g+1RqOn37FN3mXv=dxYDMAgw@mail.gmail.com>
Subject: KASAN: use-after-free Read in io_rsrc_node_ref_zero
To:     io-uring@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Hillf Danton <hdanton@sina.com>, Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

My instance of syzkaller found the following issue on v5.15.0 tree.
Git Tree : stable

Unfortunately I have not been able to create a consistent C reproducer
for this issue yet. I could use some help in simplifying the syz-repro
here. This bug hasn't been identified by the syzbot instance yet.

BUG: KASAN: use-after-free in io_rsrc_node_ref_zero+0x5b/0x2f0
fs/io_uring.c:7656
Read of size 8 at addr ffff888001d3a780 by task swapper/0/0

CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.15.0 #13
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.13.0-1ubuntu1.1 04/01/2014
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x5d/0x80 lib/dump_stack.c:106
 print_address_description+0x88/0x3e0 mm/kasan/report.c:256
 __kasan_report mm/kasan/report.c:442 [inline]
 kasan_report+0x1a2/0x1f0 mm/kasan/report.c:459
 __asan_report_load8_noabort+0x14/0x20 mm/kasan/report_generic.c:309
 io_rsrc_node_ref_zero+0x5b/0x2f0 fs/io_uring.c:7656
 percpu_ref_put_many include/linux/percpu-refcount.h:322 [inline]
 percpu_ref_put include/linux/percpu-refcount.h:338 [inline]
 percpu_ref_call_confirm_rcu lib/percpu-refcount.c:163 [inline]
 percpu_ref_switch_to_atomic_rcu+0x56f/0x5e0 lib/percpu-refcount.c:205
 rcu_do_batch kernel/rcu/tree.c:2508 [inline]
 rcu_core+0xf58/0x1500 kernel/rcu/tree.c:2743
 rcu_core_si+0xe/0x10 kernel/rcu/tree.c:2756
 __do_softirq+0x216/0x516 kernel/softirq.c:558
 invoke_softirq kernel/softirq.c:432 [inline]
 __irq_exit_rcu+0x88/0x120 kernel/softirq.c:636
 irq_exit_rcu+0xe/0x10 kernel/softirq.c:648
 sysvec_apic_timer_interrupt+0x76/0x90 arch/x86/kernel/apic/apic.c:1097
 </IRQ>
 asm_sysvec_apic_timer_interrupt+0x12/0x20
RIP: 0010:native_safe_halt+0xf/0x20 arch/x86/include/asm/irqflags.h:52
Code: e1 07 80 c1 03 38 c1 7c ba 48 89 df e8 9a 01 fd fd eb b0 00 00
cc cc 00 00 cc cc 55 48 89 e5 eb 07 0f 00 2d 53 fe 49 00 fb f4 <5d> c3
66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 48 89 e5 eb
RSP: 0018:ffffffffa3007d68 EFLAGS: 00000206
RAX: 000000000007c07e RBX: 0000000000000000 RCX: 000000000007c07e
RDX: 0000000000000001 RSI: 0000000000000004 RDI: 0000000000000001
RBP: ffffffffa3007d68 R08: dffffc0000000000 R09: ffffed100450631d
R10: ffffed100450631d R11: ffffffffa1fd6960 R12: 0000000000000000
R13: ffffffffa301bd40 R14: 1ffffffff4600fc4 R15: dffffc0000000000
 arch_safe_halt arch/x86/kernel/process.c:715 [inline]
 default_idle+0xe/0x20 arch/x86/kernel/process.c:716
 arch_cpu_idle+0x13/0x20 arch/x86/kernel/process.c:708
 default_idle_call+0x79/0x1c0 kernel/sched/idle.c:112
 cpuidle_idle_call kernel/sched/idle.c:194 [inline]
 do_idle+0x1f0/0x5c0 kernel/sched/idle.c:306
 cpu_startup_entry+0x25/0x30 kernel/sched/idle.c:403
 rest_init+0x10c/0x130 init/main.c:734
 arch_call_rest_init+0x13/0x15
 start_kernel+0x3f2/0x468 init/main.c:1142
 x86_64_start_reservations+0x24/0x26 arch/x86/kernel/head64.c:525
 x86_64_start_kernel+0x7c/0x7f arch/x86/kernel/head64.c:506
 secondary_startup_64_no_verify+0xb1/0xbb

Allocated by task 1639:
 kasan_save_stack mm/kasan/common.c:38 [inline]
 kasan_set_track mm/kasan/common.c:46 [inline]
 set_alloc_info mm/kasan/common.c:434 [inline]
 ____kasan_kmalloc+0xc4/0xf0 mm/kasan/common.c:513
 __kasan_kmalloc+0x9/0x10 mm/kasan/common.c:522
 kasan_kmalloc include/linux/kasan.h:264 [inline]
 kmem_cache_alloc_trace+0x201/0x2d0 mm/slub.c:3240
 kmalloc include/linux/slab.h:591 [inline]
 kzalloc include/linux/slab.h:721 [inline]
 io_rsrc_data_alloc+0x68/0x520 fs/io_uring.c:7794
 io_sqe_files_register+0x21f/0xf30 fs/io_uring.c:8231
 __do_sys_io_uring_register+0xb84/0x3460 fs/io_uring.c:10945
 __se_sys_io_uring_register fs/io_uring.c:10925 [inline]
 __x64_sys_io_uring_register+0x9f/0xb0 fs/io_uring.c:10925
 do_syscall_64+0x48/0xd0
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Freed by task 1640:
 kasan_save_stack mm/kasan/common.c:38 [inline]
 kasan_set_track+0x4c/0x80 mm/kasan/common.c:46
 kasan_set_free_info+0x23/0x40 mm/kasan/generic.c:360
 ____kasan_slab_free+0x110/0x150 mm/kasan/common.c:366
 __kasan_slab_free+0x11/0x20 mm/kasan/common.c:374
 kasan_slab_free include/linux/kasan.h:230 [inline]
 slab_free_hook mm/slub.c:1700 [inline]
 slab_free_freelist_hook+0x98/0x160 mm/slub.c:1726
 slab_free mm/slub.c:3492 [inline]
 kfree+0xda/0x290 mm/slub.c:4552
 io_rsrc_data_free fs/io_uring.c:7783 [inline]
 __io_sqe_files_unregister fs/io_uring.c:7861 [inline]
 io_sqe_files_unregister fs/io_uring.c:7874 [inline]
 __io_uring_register fs/io_uring.c:10829 [inline]
 __do_sys_io_uring_register+0x2172/0x3460 fs/io_uring.c:10945
 __se_sys_io_uring_register fs/io_uring.c:10925 [inline]
 __x64_sys_io_uring_register+0x9f/0xb0 fs/io_uring.c:10925
 do_syscall_64+0x48/0xd0
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Last potentially related work creation:
 kasan_save_stack+0x36/0x60 mm/kasan/common.c:38
 kasan_record_aux_stack+0xbc/0xe0 mm/kasan/generic.c:348
 insert_work+0x58/0x2d0 kernel/workqueue.c:1353
 __queue_work+0x911/0xc90 kernel/workqueue.c:1519
 queue_work_on+0x5d/0xa0 kernel/workqueue.c:1546
 queue_work include/linux/workqueue.h:501 [inline]
 call_usermodehelper_exec+0x240/0x3e0 kernel/umh.c:435
 call_modprobe kernel/kmod.c:98 [inline]
 __request_module+0x34b/0x790 kernel/kmod.c:170
 dev_load+0x5d/0xb0 net/core/dev_ioctl.c:446
 dev_ioctl+0x528/0x10d0 net/core/dev_ioctl.c:511
 sock_do_ioctl+0x2ee/0x510 net/socket.c:1132
 sock_ioctl+0x56d/0x950 net/socket.c:1235
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:874 [inline]
 __se_sys_ioctl+0xed/0x150 fs/ioctl.c:860
 __x64_sys_ioctl+0x80/0x90 fs/ioctl.c:860
 do_syscall_64+0x48/0xd0
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Second to last potentially related work creation:
 kasan_save_stack+0x36/0x60 mm/kasan/common.c:38
 kasan_record_aux_stack+0xbc/0xe0 mm/kasan/generic.c:348
 insert_work+0x58/0x2d0 kernel/workqueue.c:1353
 __queue_work+0x911/0xc90 kernel/workqueue.c:1519
 queue_work_on+0x5d/0xa0 kernel/workqueue.c:1546
 queue_work include/linux/workqueue.h:501 [inline]
 call_usermodehelper_exec+0x240/0x3e0 kernel/umh.c:435
 call_modprobe kernel/kmod.c:98 [inline]
 __request_module+0x34b/0x790 kernel/kmod.c:170
 dev_load+0x96/0xb0 net/core/dev_ioctl.c:448
 dev_ioctl+0x528/0x10d0 net/core/dev_ioctl.c:511
 sock_do_ioctl+0x2ee/0x510 net/socket.c:1132
 sock_ioctl+0x56d/0x950 net/socket.c:1235
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:874 [inline]
 __se_sys_ioctl+0xed/0x150 fs/ioctl.c:860
 __x64_sys_ioctl+0x80/0x90 fs/ioctl.c:860
 do_syscall_64+0x48/0xd0
 entry_SYSCALL_64_after_hwframe+0x44/0xae

The buggy address belongs to the object at ffff888001d3a780
 which belongs to the cache kmalloc-96 of size 96
The buggy address is located 0 bytes inside of
 96-byte region [ffff888001d3a780, ffff888001d3a7e0)
The buggy address belongs to the page:
page:000000008e5b5d32 refcount:1 mapcount:0 mapping:0000000000000000
index:0x0 pfn:0x1d3a
flags: 0xfffffc0000200(slab|node=0|zone=1|lastcpupid=0x1fffff)
raw: 000fffffc0000200 ffffea00000d4100 0000000c0000000c ffff888001041780
raw: 0000000000000000 0000000000200020 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff888001d3a680: fa fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
 ffff888001d3a700: fa fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
>ffff888001d3a780: fa fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
                   ^
 ffff888001d3a800: fa fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
 ffff888001d3a880: fa fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
==================================================================
------------[ cut here ]------------
WARNING: CPU: 0 PID: 81 at fs/io_uring.c:9283 io_ring_ctx_free
fs/io_uring.c:9283 [inline]
WARNING: CPU: 0 PID: 81 at fs/io_uring.c:9283
io_ring_exit_work+0x1cac/0x1e60 fs/io_uring.c:9446
Modules linked in:
CPU: 0 PID: 81 Comm: kworker/u2:1 Tainted: G    B             5.15.0 #13
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.13.0-1ubuntu1.1 04/01/2014
Workqueue: events_unbound io_ring_exit_work
RIP: 0010:io_ring_ctx_free fs/io_uring.c:9283 [inline]
RIP: 0010:io_ring_exit_work+0x1cac/0x1e60 fs/io_uring.c:9446
Code: 48 8b 04 25 28 00 00 00 48 3b 84 24 20 01 00 00 0f 85 b4 01 00
00 48 8d 65 d8 5b 41 5c 41 5d 41 5e 41 5f 5d c3 e8 e4 84 92 ff <0f> 0b
e9 38 f7 ff ff e8 d8 84 92 ff 0f 0b e9 5d f7 ff ff e8 cc 84
RSP: 0018:ffff888002217b80 EFLAGS: 00010293
RAX: ffffffffa01c677c RBX: ffff88800191e558 RCX: ffff888002209a00
RDX: 0000000000000000 RSI: 0000000000000008 RDI: ffff888022830340
RBP: ffff888002217d00 R08: dffffc0000000000 R09: ffffed1000323ca0
R10: ffffed1000323ca0 R11: 0000000000000000 R12: ffff888004935f28
R13: ffff88800191e4e8 R14: 0000000000000000 R15: dffffc0000000000
FS:  0000000000000000(0000) GS:ffff888022800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f4ef266c000 CR3: 00000000048f6001 CR4: 0000000000370ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 process_one_work+0x6c8/0x1050 kernel/workqueue.c:2297
 worker_thread+0x9f1/0x1520 kernel/workqueue.c:2444
 kthread+0x3af/0x4a0 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30
---[ end trace be1e878fc6a839ea ]---
----------------
Code disassembly (best guess):
   0: e1 07                 loope  0x9
   2: 80 c1 03             add    $0x3,%cl
   5: 38 c1                 cmp    %al,%cl
   7: 7c ba                 jl     0xffffffc3
   9: 48 89 df             mov    %rbx,%rdi
   c: e8 9a 01 fd fd       callq  0xfdfd01ab
  11: eb b0                 jmp    0xffffffc3
  13: 00 00                 add    %al,(%rax)
  15: cc                   int3
  16: cc                   int3
  17: 00 00                 add    %al,(%rax)
  19: cc                   int3
  1a: cc                   int3
  1b: 55                   push   %rbp
  1c: 48 89 e5             mov    %rsp,%rbp
  1f: eb 07                 jmp    0x28
  21: 0f 00 2d 53 fe 49 00 verw   0x49fe53(%rip)        # 0x49fe7b
  28: fb                   sti
  29: f4                   hlt
* 2a: 5d                   pop    %rbp <-- trapping instruction
  2b: c3                   retq
  2c: 66 2e 0f 1f 84 00 00 nopw   %cs:0x0(%rax,%rax,1)
  33: 00 00 00
  36: 0f 1f 44 00 00       nopl   0x0(%rax,%rax,1)
  3b: 55                   push   %rbp
  3c: 48 89 e5             mov    %rsp,%rbp
  3f: eb                   .byte 0xeb

I think the bug might be the call of kfree(ref_node) in
https://elixir.bootlin.com/linux/v5.15/source/fs/io_uring.c#L7686
while a concurrent thread uses the structure.


Syz repro:
# {Threaded:true Collide:true Repeat:true RepeatTimes:0 Procs:1
Slowdown:1 Sandbox:none Leak:false NetInjection:true NetDevices:true
NetReset:true Cgroups:true BinfmtMisc:true CloseFDs:true KCSAN:false
DevlinkPCI:false USB:false VhciInjection:false Wifi:false
IEEE802154:false Sysctl:true UseTmpDir:true HandleSegv:true
Repro:false Trace:false LegacyOptions:{Fault:false FaultCall:0
FaultNth:0}}
r0 = io_uring_setup(0x70c1, &(0x7f0000000000))
io_uring_register$IORING_REGISTER_FILES(r0, 0x2, &(0x7f0000000880), 0x21)
io_uring_register$IORING_REGISTER_FILES_UPDATE(r0, 0x6, 0x0, 0x0)
r1 = open$dir(&(0x7f0000000000)='./file0\x00', 0x23c41, 0x0)
write$binfmt_script(r1, 0x0, 0x2a)
open(&(0x7f00000001c0)='./file0/file0\x00', 0x800, 0x142)
io_uring_register$IORING_UNREGISTER_FILES(r0, 0x3, 0x0, 0x0)
io_uring_register$IORING_REGISTER_BUFFERS(r0, 0x0,
&(0x7f0000000380)=[{0x0}], 0x1)
r2 = io_uring_setup(0x7628, &(0x7f0000000080)={0x0, 0x7628})
r3 = open$dir(&(0x7f0000000000)='./file0\x00', 0x8840, 0x0)
io_uring_register$IORING_REGISTER_FILES(r2, 0x2,
&(0x7f0000000100)=[r3, 0xffffffffffffffff], 0x2)
r4 = io_uring_setup(0x7628, &(0x7f0000000080)={0x0, 0x7628})
r5 = open$dir(&(0x7f0000000000)='./file0\x00', 0x8840, 0x0)
io_uring_register$IORING_REGISTER_FILES(r4, 0x2,
&(0x7f0000000100)=[r5, 0xffffffffffffffff], 0x2)
r6 = open$dir(&(0x7f0000000080)='./file0/file0\x00', 0x28000, 0x104)
io_uring_register$IORING_REGISTER_FILES_UPDATE(r0, 0x6,
&(0x7f0000000180)={0x0, 0x0, &(0x7f0000000140)=[r3,
0xffffffffffffffff, r1, r4, r6]}, 0x5)
io_uring_register$IORING_UNREGISTER_BUFFERS(r0, 0x1, 0x0, 0x0)

Kernel Build Config:
https://gist.github.com/oswalpalash/18e847d6e24e3452bc811526fd6f76bb
