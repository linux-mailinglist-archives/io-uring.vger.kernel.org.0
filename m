Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D01537EE7D
	for <lists+io-uring@lfdr.de>; Thu, 13 May 2021 00:58:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231261AbhELVvs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 12 May 2021 17:51:48 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:46015 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345958AbhELUhc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 12 May 2021 16:37:32 -0400
Received: by mail-io1-f70.google.com with SMTP id y15-20020a5d9b0f0000b02903e840cb5f09so16543200ion.12
        for <io-uring@vger.kernel.org>; Wed, 12 May 2021 13:36:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=p2gWWp2dZEJgHhYny1RpbKA50V7ZgrhW/5wfqVoEc2M=;
        b=EDd/OsN5HezLwvMBit0gZo6R6nsOfFkKl9nJ/WcYsKoQaPR2FcJgUWP1lVCVYsx9HM
         ELqi92qfzxMiG3GiiX13cNDW0SwxBqktDZG/E0mGzxhEw1N0NWBdOEbZQ14ssDnPdlso
         7SY9sXohArrzT+bElPlS3O+X/xMVdVvxV5MDYsDyMFxn/lYT9CZASOC0jWgcDYDjUk6l
         VClCSJdOWU00e4m0Z3prKRLcIJvxrlK2/suN6neVYpV4TpM2sfcrG+Q0h1n8+BZZwD1N
         YYseKQOabcDiV6M1XbxBG2rOqYyHEiubmRsbu6VBP4FieRti51niKhbDpj0CtlSGrDII
         00/A==
X-Gm-Message-State: AOAM531ojseUNy+n6GeC4AlVre3WhwcPcEY3LMAp/e+kImWsIktfbii4
        bf6rxEOdnuidYIGEtDBqlhPuz876hnYPQp3dGGtcBAaamKok
X-Google-Smtp-Source: ABdhPJwe3e5rvNfTerqpWt3Q7Zz0ibimpSGTUxCie7tvWszx+jULM13/TFQWqlDiFFAqTdvkuXoWVxw6jFXb2zYamAe3k8mxGeVa
MIME-Version: 1.0
X-Received: by 2002:a92:d3c1:: with SMTP id c1mr32529456ilh.21.1620851305578;
 Wed, 12 May 2021 13:28:25 -0700 (PDT)
Date:   Wed, 12 May 2021 13:28:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000004d849405c227da64@google.com>
Subject: [syzbot] WARNING in io_link_timeout_fn
From:   syzbot <syzbot+5a864149dd970b546223@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    88b06399 Merge tag 'for-5.13-rc1-part2-tag' of git://git.k..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13c0d265d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=807beec6b4d66bf1
dashboard link: https://syzkaller.appspot.com/bug?extid=5a864149dd970b546223
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10436223d00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1715208bd00000

The issue was bisected to:

commit 91f245d5d5de0802428a478802ec051f7de2f5d6
Author: Jens Axboe <axboe@kernel.dk>
Date:   Tue Feb 9 20:48:50 2021 +0000

    io_uring: enable kmemcg account for io_uring requests

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=144fbb23d00000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=164fbb23d00000
console output: https://syzkaller.appspot.com/x/log.txt?x=124fbb23d00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+5a864149dd970b546223@syzkaller.appspotmail.com
Fixes: 91f245d5d5de ("io_uring: enable kmemcg account for io_uring requests")

------------[ cut here ]------------
WARNING: CPU: 1 PID: 8784 at fs/io_uring.c:1499 req_ref_sub_and_test fs/io_uring.c:1499 [inline]
WARNING: CPU: 1 PID: 8784 at fs/io_uring.c:1499 io_put_req_deferred fs/io_uring.c:2191 [inline]
WARNING: CPU: 1 PID: 8784 at fs/io_uring.c:1499 io_link_timeout_fn+0x96c/0xb20 fs/io_uring.c:6369
Modules linked in:
CPU: 1 PID: 8784 Comm: systemd-cgroups Not tainted 5.13.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:req_ref_sub_and_test fs/io_uring.c:1499 [inline]
RIP: 0010:io_put_req_deferred fs/io_uring.c:2191 [inline]
RIP: 0010:io_link_timeout_fn+0x96c/0xb20 fs/io_uring.c:6369
Code: 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 84 f9 fd ff ff e8 ae ff da ff e9 ef fd ff ff e8 f4 03 96 ff <0f> 0b e9 6a fc ff ff e8 e8 03 96 ff 4c 89 ef e8 10 96 ff ff 48 8d
RSP: 0018:ffffc90000dc0d70 EFLAGS: 00010046
RAX: 0000000080010001 RBX: ffff88802c080c80 RCX: 0000000000000000
RDX: ffff8880373954c0 RSI: ffffffff81dece4c RDI: 0000000000000003
RBP: ffff88802c080cdc R08: 000000000000007f R09: ffff88802c080cdf
R10: ffffffff81decab3 R11: 0000000000000000 R12: 000000000000007f
R13: 0000000000000000 R14: ffff88802c15e000 R15: ffff88802c15e680
FS:  0000000000000000(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f6ba37daab4 CR3: 0000000015bdf000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <IRQ>
 __run_hrtimer kernel/time/hrtimer.c:1537 [inline]
 __hrtimer_run_queues+0x609/0xe40 kernel/time/hrtimer.c:1601
 hrtimer_interrupt+0x330/0xa00 kernel/time/hrtimer.c:1663
 local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1089 [inline]
 __sysvec_apic_timer_interrupt+0x146/0x540 arch/x86/kernel/apic/apic.c:1106
 sysvec_apic_timer_interrupt+0x8e/0xc0 arch/x86/kernel/apic/apic.c:1100
 </IRQ>
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:647
RIP: 0010:orc_find arch/x86/kernel/unwind_orc.c:166 [inline]
RIP: 0010:unwind_next_frame+0x308/0x1ce0 arch/x86/kernel/unwind_orc.c:443
Code: 48 8d 3c 40 4c 8d 8c 3f cc 27 3d 8e 83 c2 01 49 81 f9 a4 0c dd 8e 0f 83 f3 10 00 00 89 d7 48 8d 3c 7f 48 8d bc 3f cc 27 3d 8e <48> 81 ff a4 0c dd 8e 0f 87 d8 10 00 00 48 8d 3c 85 3c 8f d2 8d 29
RSP: 0018:ffffc9000918f6a8 EFLAGS: 00000293
RAX: 000000000002bff1 RBX: 1ffff92001231edd RCX: 000000000002bff1
RDX: 000000000002bffb RSI: 000000000000b9cd RDI: ffffffff8e4da7ae
RBP: 0000000000000001 R08: 0000000000000000 R09: ffffffff8e4da772
R10: fffff52001231efb R11: 0000000000084087 R12: ffffc9000918f7c8
R13: ffffc9000918f7b5 R14: ffffc9000918f780 R15: ffffffff81b9cd7f
 arch_stack_walk+0x7d/0xe0 arch/x86/kernel/stacktrace.c:25
 stack_trace_save+0x8c/0xc0 kernel/stacktrace.c:121
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track+0x1c/0x30 mm/kasan/common.c:46
 kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:357
 ____kasan_slab_free mm/kasan/common.c:360 [inline]
 ____kasan_slab_free mm/kasan/common.c:325 [inline]
 __kasan_slab_free+0xfb/0x130 mm/kasan/common.c:368
 kasan_slab_free include/linux/kasan.h:212 [inline]
 slab_free_hook mm/slub.c:1581 [inline]
 slab_free_freelist_hook+0xdf/0x240 mm/slub.c:1606
 slab_free mm/slub.c:3166 [inline]
 kmem_cache_free+0x8a/0x740 mm/slub.c:3182
 anon_vma_chain_free mm/rmap.c:141 [inline]
 unlink_anon_vmas+0x472/0x860 mm/rmap.c:439
 free_pgtables+0xe2/0x2f0 mm/memory.c:413
 exit_mmap+0x2b7/0x590 mm/mmap.c:3209
 __mmput+0x122/0x470 kernel/fork.c:1096
 mmput+0x58/0x60 kernel/fork.c:1117
 exit_mm kernel/exit.c:502 [inline]
 do_exit+0xb0a/0x2a60 kernel/exit.c:813
 do_group_exit+0x125/0x310 kernel/exit.c:923
 __do_sys_exit_group kernel/exit.c:934 [inline]
 __se_sys_exit_group kernel/exit.c:932 [inline]
 __x64_sys_exit_group+0x3a/0x50 kernel/exit.c:932
 do_syscall_64+0x3a/0xb0 arch/x86/entry/common.c:47
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f6ba4eb3618
Code: Unable to access opcode bytes at RIP 0x7f6ba4eb35ee.
RSP: 002b:00007ffd8038caf8 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f6ba4eb3618
RDX: 0000000000000000 RSI: 000000000000003c RDI: 0000000000000000
RBP: 00007f6ba51908e0 R08: 00000000000000e7 R09: fffffffffffffee8
R10: 00007f6ba336e158 R11: 0000000000000246 R12: 00007f6ba51908e0
R13: 00007f6ba5195c20 R14: 0000000000000000 R15: 0000000000000000


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
