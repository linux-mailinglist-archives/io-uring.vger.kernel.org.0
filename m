Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82B88436C71
	for <lists+io-uring@lfdr.de>; Thu, 21 Oct 2021 23:10:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231895AbhJUVMn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Oct 2021 17:12:43 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:51963 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231862AbhJUVMn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Oct 2021 17:12:43 -0400
Received: by mail-io1-f71.google.com with SMTP id n10-20020a056602340a00b005de2be80c34so1323054ioz.18
        for <io-uring@vger.kernel.org>; Thu, 21 Oct 2021 14:10:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=KUZI7Tq5GdQzrJyNFkCdnybe2JowQJrzK6oXMxPrv+Y=;
        b=0tm69gT0Lj8lJT88F4egP7BFWtDnFJpy4XXjxCd8IBl7wPtPpFD9FxZecD+xSzO9Bh
         HFCUVonXHqQGKxgr5YIyplrMjx8oY64JPhcepFivBhuyBbS5jM1rgRgOeCYNWspIjkve
         N4uUwv2HXSzhmm7Js8ZhyBNX5D6WXSG6LhzcdTra20Wr5lCnsNke7ILMVFHzep4ecx0t
         O4Aw0y1MfKb0HbT9ukbBRx64NV3mzuuaAMK+cHZif/DNXNLRdNJnNlQ9Ik3ZbnBAKVEh
         Th7tU+u5VZWNggSVzGRDWtAz0bS7G9vuS2yZ3/EY4cFKyhfPol774YVwv4ClEVDV3/Wk
         pP3g==
X-Gm-Message-State: AOAM533d7UqMvf3TRv3nYrOc5ObxhEYHo2RSuzoBkC0b9QmesBxJBebZ
        bTJ6AnCxo5XEYCrMlXpz7TPodF2ULQbHrO8nsC9rUYttG7db
X-Google-Smtp-Source: ABdhPJzpf3Lzz429jL6xzKETVgRePCNbLGCml9v0KQX2eiEGirz48MJigIOQwYhOIsi2+dUXwoOA5HgI17OV4XafzoNoZgZIJhYm
MIME-Version: 1.0
X-Received: by 2002:a05:6602:134d:: with SMTP id i13mr5757952iov.164.1634850626714;
 Thu, 21 Oct 2021 14:10:26 -0700 (PDT)
Date:   Thu, 21 Oct 2021 14:10:26 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ddc11905cee3521c@google.com>
Subject: [syzbot] INFO: task hung in io_wqe_worker
From:   syzbot <syzbot+27d62ee6f256b186883e@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    d999ade1cc86 Merge tag 'perf-tools-fixes-for-v5.15-2021-10..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=136f87d0b00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=bab9d35f204746a7
dashboard link: https://syzkaller.appspot.com/bug?extid=27d62ee6f256b186883e
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10d3f7ccb00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15d3600cb00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+27d62ee6f256b186883e@syzkaller.appspotmail.com

INFO: task iou-wrk-6609:6612 blocked for more than 143 seconds.
      Not tainted 5.15.0-rc5-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:iou-wrk-6609    state:D stack:27944 pid: 6612 ppid:  6526 flags:0x00004006
Call Trace:
 context_switch kernel/sched/core.c:4940 [inline]
 __schedule+0xb44/0x5960 kernel/sched/core.c:6287
 schedule+0xd3/0x270 kernel/sched/core.c:6366
 schedule_timeout+0x1db/0x2a0 kernel/time/timer.c:1857
 do_wait_for_common kernel/sched/completion.c:85 [inline]
 __wait_for_common kernel/sched/completion.c:106 [inline]
 wait_for_common kernel/sched/completion.c:117 [inline]
 wait_for_completion+0x176/0x280 kernel/sched/completion.c:138
 io_worker_exit fs/io-wq.c:183 [inline]
 io_wqe_worker+0x66d/0xc40 fs/io-wq.c:597
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

Showing all locks held in the system:
1 lock held by khungtaskd/27:
 #0: ffffffff8b981ae0 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x53/0x260 kernel/locking/lockdep.c:6446

=============================================

NMI backtrace for cpu 0
CPU: 0 PID: 27 Comm: khungtaskd Not tainted 5.15.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 nmi_cpu_backtrace.cold+0x47/0x144 lib/nmi_backtrace.c:105
 nmi_trigger_cpumask_backtrace+0x1ae/0x220 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:146 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:210 [inline]
 watchdog+0xc1d/0xf50 kernel/hung_task.c:295
 kthread+0x3e5/0x4d0 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
CPU: 1 PID: 1414 Comm: kworker/u4:5 Not tainted 5.15.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events_unbound toggle_allocation_gate
RIP: 0010:bytes_is_nonzero mm/kasan/generic.c:85 [inline]
RIP: 0010:memory_is_nonzero mm/kasan/generic.c:102 [inline]
RIP: 0010:memory_is_poisoned_n mm/kasan/generic.c:128 [inline]
RIP: 0010:memory_is_poisoned mm/kasan/generic.c:159 [inline]
RIP: 0010:check_region_inline mm/kasan/generic.c:180 [inline]
RIP: 0010:kasan_check_range+0xde/0x180 mm/kasan/generic.c:189
Code: 74 f2 48 89 c2 b8 01 00 00 00 48 85 d2 75 56 5b 5d 41 5c c3 48 85 d2 74 5e 48 01 ea eb 09 48 83 c0 01 48 39 d0 74 50 80 38 00 <74> f2 eb d4 41 bc 08 00 00 00 48 89 ea 45 29 dc 4d 8d 1c 2c eb 0c
RSP: 0018:ffffc90005aa7988 EFLAGS: 00000046
RAX: ffffed10021cd084 RBX: ffffed10021cd085 RCX: ffffffff81348c59
RDX: ffffed10021cd085 RSI: 0000000000000008 RDI: ffff888010e68420
RBP: ffffed10021cd084 R08: 0000000000000000 R09: ffff888010e68427
R10: ffffed10021cd084 R11: 000000000000003f R12: ffffffff8baabbe0
R13: ffff888010e68420 R14: 0000000000000000 R15: ffff88801dfeda50
FS:  0000000000000000(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f93e8906000 CR3: 000000000b68e000 CR4: 0000000000350ee0
Call Trace:
 instrument_atomic_read include/linux/instrumented.h:71 [inline]
 atomic64_read include/linux/atomic/atomic-instrumented.h:605 [inline]
 switch_mm_irqs_off+0x1e9/0xa10 arch/x86/mm/tlb.c:615
 use_temporary_mm arch/x86/kernel/alternative.c:741 [inline]
 __text_poke+0x447/0x8c0 arch/x86/kernel/alternative.c:838
 text_poke_bp_batch+0x3d7/0x560 arch/x86/kernel/alternative.c:1178
 text_poke_flush arch/x86/kernel/alternative.c:1268 [inline]
 text_poke_flush arch/x86/kernel/alternative.c:1265 [inline]
 text_poke_finish+0x16/0x30 arch/x86/kernel/alternative.c:1275
 arch_jump_label_transform_apply+0x13/0x20 arch/x86/kernel/jump_label.c:146
 jump_label_update+0x1d5/0x430 kernel/jump_label.c:830
 static_key_enable_cpuslocked+0x1b1/0x260 kernel/jump_label.c:177
 static_key_enable+0x16/0x20 kernel/jump_label.c:190
 toggle_allocation_gate mm/kfence/core.c:626 [inline]
 toggle_allocation_gate+0x100/0x390 mm/kfence/core.c:618
 process_one_work+0x9bf/0x16b0 kernel/workqueue.c:2297
 worker_thread+0x658/0x11f0 kernel/workqueue.c:2444
 kthread+0x3e5/0x4d0 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
----------------
Code disassembly (best guess):
   0:	74 f2                	je     0xfffffff4
   2:	48 89 c2             	mov    %rax,%rdx
   5:	b8 01 00 00 00       	mov    $0x1,%eax
   a:	48 85 d2             	test   %rdx,%rdx
   d:	75 56                	jne    0x65
   f:	5b                   	pop    %rbx
  10:	5d                   	pop    %rbp
  11:	41 5c                	pop    %r12
  13:	c3                   	retq
  14:	48 85 d2             	test   %rdx,%rdx
  17:	74 5e                	je     0x77
  19:	48 01 ea             	add    %rbp,%rdx
  1c:	eb 09                	jmp    0x27
  1e:	48 83 c0 01          	add    $0x1,%rax
  22:	48 39 d0             	cmp    %rdx,%rax
  25:	74 50                	je     0x77
  27:	80 38 00             	cmpb   $0x0,(%rax)
* 2a:	74 f2                	je     0x1e <-- trapping instruction
  2c:	eb d4                	jmp    0x2
  2e:	41 bc 08 00 00 00    	mov    $0x8,%r12d
  34:	48 89 ea             	mov    %rbp,%rdx
  37:	45 29 dc             	sub    %r11d,%r12d
  3a:	4d 8d 1c 2c          	lea    (%r12,%rbp,1),%r11
  3e:	eb 0c                	jmp    0x4c


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
