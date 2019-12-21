Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97F7512880F
	for <lists+io-uring@lfdr.de>; Sat, 21 Dec 2019 09:05:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726131AbfLUIFK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 21 Dec 2019 03:05:10 -0500
Received: from mail-io1-f72.google.com ([209.85.166.72]:39793 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725944AbfLUIFJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 21 Dec 2019 03:05:09 -0500
Received: by mail-io1-f72.google.com with SMTP id i4so7657628iog.6
        for <io-uring@vger.kernel.org>; Sat, 21 Dec 2019 00:05:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=deYFK8ddtWh1jagx++4fGZM5W0SjiPRG6DK7H6PrJhc=;
        b=i184WY/tEkWbGYFvhMoAcYJteSxVG6xpH6zQzPX6jCt2LyIf1It07Rh3t4R3GmVq9E
         CUm8oiCER1D5PZ0IPTSHPGeogzO8X5RYxIn8cyurk90gq0uzaHJ5aSAXZbhQAh1m13Vx
         V8okSF0garYoNmEWM56HS67cpSBNyQPcJSfZhlbsZ7otBLgPnYPc2QaERd4UIZqAksk5
         UvWwB69bHja5ALz73+/Wg71YD/ko8IFar/WDgY/alQWKeVRHMFCrwGuMeQr3asPuwGHO
         BMkrmdQvhmfwcwv38YIKMIOBTFCMBGBey4qSrSuwXj6e1BE0YzuRVHJ9maNFShAz8Pcg
         P44Q==
X-Gm-Message-State: APjAAAVma27G8UgHK/0X31QMJOIHvqpBF0xuvWCwyVmCnPIfg6FZAKXt
        q9XQu3c4KjAj0iWRAu43F4KgA3LffFNSBsgqk7+tlcfSNFg3
X-Google-Smtp-Source: APXvYqzhDnpMLztsh0UlrrdoM00CUjaZhiVYUYPccEAHhKGyarpAS/rqpAfitgprb+IaOAfl0N3+4vHIWUa3JSskvLWr8H67eDId
MIME-Version: 1.0
X-Received: by 2002:a02:3409:: with SMTP id x9mr15588491jae.3.1576915507909;
 Sat, 21 Dec 2019 00:05:07 -0800 (PST)
Date:   Sat, 21 Dec 2019 00:05:07 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b09d8c059a3240be@google.com>
Subject: WARNING in percpu_ref_exit (2)
From:   syzbot <syzbot+8c4a14856e657b43487c@syzkaller.appspotmail.com>
To:     axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    7ddd09fc Add linux-next specific files for 20191220
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=12a18cc6e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f183b01c3088afc6
dashboard link: https://syzkaller.appspot.com/bug?extid=8c4a14856e657b43487c
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14b8f351e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14b51925e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+8c4a14856e657b43487c@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 1 PID: 11482 at lib/percpu-refcount.c:111  
percpu_ref_exit+0xab/0xd0 lib/percpu-refcount.c:111
Kernel panic - not syncing: panic_on_warn set ...
CPU: 1 PID: 11482 Comm: syz-executor051 Not tainted  
5.5.0-rc2-next-20191220-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x197/0x210 lib/dump_stack.c:118
  panic+0x2e3/0x75c kernel/panic.c:221
  __warn.cold+0x2f/0x3e kernel/panic.c:582
  report_bug+0x289/0x300 lib/bug.c:195
  fixup_bug arch/x86/kernel/traps.c:174 [inline]
  fixup_bug arch/x86/kernel/traps.c:169 [inline]
  do_error_trap+0x11b/0x200 arch/x86/kernel/traps.c:267
  do_invalid_op+0x37/0x50 arch/x86/kernel/traps.c:286
  invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1027
RIP: 0010:percpu_ref_exit+0xab/0xd0 lib/percpu-refcount.c:111
Code: 00 00 00 00 fc ff df 48 c1 ea 03 80 3c 02 00 75 1d 48 c7 43 08 03 00  
00 00 e8 01 41 e5 fd 5b 41 5c 41 5d 5d c3 e8 f5 40 e5 fd <0f> 0b eb bf 4c  
89 ef e8 29 2c 23 fe eb d9 e8 82 2b 23 fe eb a7 4c
RSP: 0018:ffffc9000cb17968 EFLAGS: 00010293
RAX: ffff8880a3390640 RBX: ffff8880a83a8010 RCX: ffffffff83901432
RDX: 0000000000000000 RSI: ffffffff8390149b RDI: ffff8880a83a8028
RBP: ffffc9000cb17980 R08: ffff8880a3390640 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000607f51435750
R13: ffff8880a83a8018 R14: ffff888097b95000 R15: ffff888097b95228
  io_sqe_files_unregister+0x7d/0x2f0 fs/io_uring.c:4623
  io_ring_ctx_free fs/io_uring.c:5575 [inline]
  io_ring_ctx_wait_and_kill+0x430/0x9a0 fs/io_uring.c:5644
  io_uring_release+0x42/0x50 fs/io_uring.c:5652
  __fput+0x2ff/0x890 fs/file_table.c:280
  ____fput+0x16/0x20 fs/file_table.c:313
  task_work_run+0x145/0x1c0 kernel/task_work.c:113
  exit_task_work include/linux/task_work.h:22 [inline]
  do_exit+0x909/0x2f20 kernel/exit.c:797
  do_group_exit+0x135/0x360 kernel/exit.c:895
  get_signal+0x47c/0x24f0 kernel/signal.c:2734
  do_signal+0x87/0x1700 arch/x86/kernel/signal.c:815
  exit_to_usermode_loop+0x286/0x380 arch/x86/entry/common.c:160
  prepare_exit_to_usermode arch/x86/entry/common.c:195 [inline]
  syscall_return_slowpath arch/x86/entry/common.c:278 [inline]
  do_syscall_64+0x676/0x790 arch/x86/entry/common.c:304
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x4468f9
Code: e8 0c e8 ff ff 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 5b 07 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f7ef700ddb8 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
RAX: fffffffffffffe00 RBX: 00000000006dbc38 RCX: 00000000004468f9
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 00000000006dbc38
RBP: 00000000006dbc30 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000006dbc3c
R13: 00007fff8371e42f R14: 00007f7ef700e9c0 R15: 0000000000000001
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
