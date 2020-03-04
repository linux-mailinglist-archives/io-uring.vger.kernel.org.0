Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE6FE178C0D
	for <lists+io-uring@lfdr.de>; Wed,  4 Mar 2020 08:59:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725283AbgCDH7n (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 4 Mar 2020 02:59:43 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:42779 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726920AbgCDH7n (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 4 Mar 2020 02:59:43 -0500
Received: by mail-qt1-f194.google.com with SMTP id r6so684261qtt.9
        for <io-uring@vger.kernel.org>; Tue, 03 Mar 2020 23:59:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZvfFfoiDvwomK27nl9TtMPE/YuB+BqiJw1pTlVud7/c=;
        b=YZB8Lub8KYqPzHJRFlphw/+Mj19Z9y5xuVLO2ElE3XuVlf8XOkgKNjJ5MjYMkGZ46C
         4Ken3VTO87z/yUAGQ4TkHJoh64RM135Al1/JDHh68rhVPTajEk/ztz3o1nJJaRdwE5SC
         QUkXp5XyhdQb3+TPYfp1MI6QT38qas+33Nd9Iqx+q1rOi0lqxExvdmi68QlGPX8msWP7
         hkKSK1YGr0/vtgMgh8TN+L48Lj5j5Vjy7CoRGIMqXpiy40c9UloXFu2IZJpVDPEs8ciJ
         LGIYZr7ni/xf2H4l+qDhmmrtj5KbReGx328yS0cAo1n7m7dhUnQptPapD/XuuUVJqIn9
         sClg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZvfFfoiDvwomK27nl9TtMPE/YuB+BqiJw1pTlVud7/c=;
        b=THEkyYAVkp4KHw9k3/brZvGP02xTbs+x6vqdCD+ZS1guL1kWvbZ3sSrPxjcVF8ujjS
         RuRCU2N88ZSrmoDNDyGZzZjeUC0H58Hx4qObT7DgxWm/NsucB3JD0cEoXEH+X8hKzU4D
         o/JSE2pQ6JJWKUB+sd3SZ086F8pz1tDGq7JhYKZhgVn5BCcnYIs7Comuw3WiYkdaNcKY
         mGrw3EXwfyvNb43IQsDwE+GY3G8t4ASAR9Zr3lVvm+1nq5FX4NLlxFYX5P/nq1oUmm6h
         b0WJhOx+oKPLG3+a0lKcs8NGrv8YZeDXmCO/ZOv7B3Tcw3VRZcX3UypkByfwCaT8WhbZ
         SU5Q==
X-Gm-Message-State: ANhLgQ0GP3Svi4mSiXJKTozyJaGIyMmLuUE5GCr3IWRsS9keK8XQOS44
        fl9XaNL72NnF0bfmPi+HE5cFijMuvDA9YyUxFle1zA==
X-Google-Smtp-Source: ADFU+vuBXAS2lNdsEI9fkEjYC/iIIwvlVsaIwmxbP7wV7qqfPL1XIHUe4oobQJ4iczwiKUbjul/qLGKw3hYVqhfymfE=
X-Received: by 2002:ac8:3533:: with SMTP id y48mr1325776qtb.380.1583308780858;
 Tue, 03 Mar 2020 23:59:40 -0800 (PST)
MIME-Version: 1.0
References: <00000000000067c6df059df7f9f5@google.com>
In-Reply-To: <00000000000067c6df059df7f9f5@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Wed, 4 Mar 2020 08:59:29 +0100
Message-ID: <CACT4Y+ZVLs7O84qixsvFqk_Nur1WOaCU81RiCwDf3wOqvHB-ag@mail.gmail.com>
Subject: Re: KASAN: use-after-free Read in percpu_ref_switch_to_atomic_rcu
To:     syzbot <syzbot+e017e49c39ab484ac87a@syzkaller.appspotmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>, io-uring@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Cc:     Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Thomas Gleixner <tglx@linutronix.de>, tony.luck@intel.com,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Feb 7, 2020 at 9:14 AM syzbot
<syzbot+e017e49c39ab484ac87a@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following crash on:
>
> HEAD commit:    4c7d00cc Merge tag 'pwm/for-5.6-rc1' of git://git.kernel.o..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=12fec785e00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=e162021ddededa72
> dashboard link: https://syzkaller.appspot.com/bug?extid=e017e49c39ab484ac87a
> compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
>
> Unfortunately, I don't have any reproducer for this crash yet.
>
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+e017e49c39ab484ac87a@syzkaller.appspotmail.com

+io_uring maintainers

Here is a repro:
https://gist.githubusercontent.com/dvyukov/6b340beab6483a036f4186e7378882ce/raw/cd1922185516453c201df8eded1d4b006a6d6a3a/gistfile1.txt

> ==================================================================
> BUG: KASAN: use-after-free in percpu_ref_call_confirm_rcu lib/percpu-refcount.c:126 [inline]
> BUG: KASAN: use-after-free in percpu_ref_switch_to_atomic_rcu+0x3f7/0x400 lib/percpu-refcount.c:165
> Read of size 1 at addr ffff8880a8d91830 by task swapper/0/0
>
> CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.5.0-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  <IRQ>
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x1fb/0x318 lib/dump_stack.c:118
>  print_address_description+0x74/0x5c0 mm/kasan/report.c:374
>  __kasan_report+0x149/0x1c0 mm/kasan/report.c:506
>  kasan_report+0x26/0x50 mm/kasan/common.c:641
>  __asan_report_load1_noabort+0x14/0x20 mm/kasan/generic_report.c:132
>  percpu_ref_call_confirm_rcu lib/percpu-refcount.c:126 [inline]
>  percpu_ref_switch_to_atomic_rcu+0x3f7/0x400 lib/percpu-refcount.c:165
>  rcu_do_batch kernel/rcu/tree.c:2186 [inline]
>  rcu_core+0x81b/0x10c0 kernel/rcu/tree.c:2410
>  rcu_core_si+0x9/0x10 kernel/rcu/tree.c:2419
>  __do_softirq+0x283/0x7bd kernel/softirq.c:292
>  invoke_softirq kernel/softirq.c:373 [inline]
>  irq_exit+0x227/0x230 kernel/softirq.c:413
>  exiting_irq arch/x86/include/asm/apic.h:536 [inline]
>  smp_apic_timer_interrupt+0x113/0x280 arch/x86/kernel/apic/apic.c:1137
>  apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:829
>  </IRQ>
> RIP: 0010:native_safe_halt+0x12/0x20 arch/x86/include/asm/irqflags.h:61
> Code: 89 d9 80 e1 07 80 c1 03 38 c1 7c ba 48 89 df e8 e4 5f 9d f9 eb b0 cc cc 55 48 89 e5 e9 07 00 00 00 0f 00 2d 62 17 4c 00 fb f4 <5d> c3 66 90 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 e9 07 00 00
> RSP: 0018:ffffffff89207db8 EFLAGS: 00000282 ORIG_RAX: ffffffffffffff13
> RAX: 1ffffffff1255a25 RBX: ffffffff89275b00 RCX: dffffc0000000000
> RDX: 0000000000000000 RSI: ffffffff812c06aa RDI: ffffffff89276344
> RBP: ffffffff89207db8 R08: ffffffff89276358 R09: fffffbfff124eb61
> R10: fffffbfff124eb61 R11: 0000000000000000 R12: 1ffffffff124eb60
> R13: dffffc0000000000 R14: dffffc0000000000 R15: 1ffffffff1255a23
>  arch_safe_halt arch/x86/include/asm/paravirt.h:144 [inline]
>  default_idle+0x50/0x70 arch/x86/kernel/process.c:695
>  arch_cpu_idle+0xa/0x10 arch/x86/kernel/process.c:686
>  default_idle_call+0x59/0xa0 kernel/sched/idle.c:94
>  cpuidle_idle_call kernel/sched/idle.c:154 [inline]
>  do_idle+0x1ec/0x630 kernel/sched/idle.c:269
>  cpu_startup_entry+0x25/0x30 kernel/sched/idle.c:361
>  rest_init+0x29d/0x2b0 init/main.c:450
>  arch_call_rest_init+0xe/0x10
>  start_kernel+0x676/0x777 init/main.c:784
>  x86_64_start_reservations+0x18/0x2e arch/x86/kernel/head64.c:490
>  x86_64_start_kernel+0x7a/0x7d arch/x86/kernel/head64.c:471
>  secondary_startup_64+0xa4/0xb0 arch/x86/kernel/head_64.S:242
>
> Allocated by task 25166:
>  save_stack mm/kasan/common.c:72 [inline]
>  set_track mm/kasan/common.c:80 [inline]
>  __kasan_kmalloc+0x118/0x1c0 mm/kasan/common.c:515
>  kasan_kmalloc+0x9/0x10 mm/kasan/common.c:529
>  kmem_cache_alloc_trace+0x221/0x2f0 mm/slab.c:3551
>  kmalloc include/linux/slab.h:555 [inline]
>  kzalloc include/linux/slab.h:669 [inline]
>  io_sqe_files_register fs/io_uring.c:5528 [inline]
>  __io_uring_register fs/io_uring.c:6875 [inline]
>  __do_sys_io_uring_register fs/io_uring.c:6955 [inline]
>  __se_sys_io_uring_register+0x1df4/0x3260 fs/io_uring.c:6937
>  __x64_sys_io_uring_register+0x9b/0xb0 fs/io_uring.c:6937
>  do_syscall_64+0xf7/0x1c0 arch/x86/entry/common.c:294
>  entry_SYSCALL_64_after_hwframe+0x49/0xbe
>
> Freed by task 25160:
>  save_stack mm/kasan/common.c:72 [inline]
>  set_track mm/kasan/common.c:80 [inline]
>  kasan_set_free_info mm/kasan/common.c:337 [inline]
>  __kasan_slab_free+0x12e/0x1e0 mm/kasan/common.c:476
>  kasan_slab_free+0xe/0x10 mm/kasan/common.c:485
>  __cache_free mm/slab.c:3426 [inline]
>  kfree+0x10d/0x220 mm/slab.c:3757
>  io_sqe_files_unregister+0x238/0x2b0 fs/io_uring.c:5250
>  io_ring_ctx_free fs/io_uring.c:6229 [inline]
>  io_ring_ctx_wait_and_kill+0x343d/0x3b00 fs/io_uring.c:6310
>  io_uring_release+0x5d/0x70 fs/io_uring.c:6318
>  __fput+0x2e4/0x740 fs/file_table.c:280
>  ____fput+0x15/0x20 fs/file_table.c:313
>  task_work_run+0x176/0x1b0 kernel/task_work.c:113
>  tracehook_notify_resume include/linux/tracehook.h:188 [inline]
>  exit_to_usermode_loop arch/x86/entry/common.c:164 [inline]
>  prepare_exit_to_usermode+0x480/0x5b0 arch/x86/entry/common.c:195
>  syscall_return_slowpath+0x113/0x4a0 arch/x86/entry/common.c:278
>  do_syscall_64+0x11f/0x1c0 arch/x86/entry/common.c:304
>  entry_SYSCALL_64_after_hwframe+0x49/0xbe
>
> The buggy address belongs to the object at ffff8880a8d91800
>  which belongs to the cache kmalloc-256 of size 256
> The buggy address is located 48 bytes inside of
>  256-byte region [ffff8880a8d91800, ffff8880a8d91900)
> The buggy address belongs to the page:
> page:ffffea0002a36440 refcount:1 mapcount:0 mapping:ffff8880aa4008c0 index:0x0
> flags: 0xfffe0000000200(slab)
> raw: 00fffe0000000200 ffffea000265d2c8 ffffea00022f7948 ffff8880aa4008c0
> raw: 0000000000000000 ffff8880a8d91000 0000000100000008 0000000000000000
> page dumped because: kasan: bad access detected
>
> Memory state around the buggy address:
>  ffff8880a8d91700: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>  ffff8880a8d91780: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> >ffff8880a8d91800: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>                                      ^
>  ffff8880a8d91880: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff8880a8d91900: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> ==================================================================
>
>
> ---
> This bug is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this bug report. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>
> --
> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/00000000000067c6df059df7f9f5%40google.com.
