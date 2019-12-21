Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E2221287F7
	for <lists+io-uring@lfdr.de>; Sat, 21 Dec 2019 08:45:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725907AbfLUHpJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 21 Dec 2019 02:45:09 -0500
Received: from mail-il1-f199.google.com ([209.85.166.199]:50055 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725838AbfLUHpJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 21 Dec 2019 02:45:09 -0500
Received: by mail-il1-f199.google.com with SMTP id j21so4802042ilf.16
        for <io-uring@vger.kernel.org>; Fri, 20 Dec 2019 23:45:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=EyXAOQ96FZA4EZtJvsH4qKzXeMlCeEGpRUWOi5a4b80=;
        b=BjDQHD1CtIVkjUlwFkzPoMfQyP9OjaaX3UsOrBqxb4Zz8nPWh/ek/tPzDSVMuju1Vv
         V5WgX9o6f/8SB5d/fwvwmCiSI2XTWw5lbiH5Ry4sqGYfchdWcZdI/InkYnGv7xPUfoU+
         nrRCc1Tq0ag/HCuoWDTZAwv0qYAftwtGOGIPQAy/m/Pu2qQqRwyJ95sRMCZvw5bCq2ym
         3JUhKJ5aalXKXqpFLUVCO3rJt/54s4jkKa7En3oN1/Iyj9krn4NvHkkIupPC+e4Hpf4l
         qdKx1Jrt9kDbxjGrLSDemdupk9gX2v7oacRr0hsL4UUAyGe6JsPGnSDlWgWVthLjp7cr
         SijA==
X-Gm-Message-State: APjAAAWFBsnPIYvlqnIsruLMPMoRwgqHFHsOBwjrl0nP0P2TGsWpI87N
        ExZ53Asee7POgZErISRJLmmq5M5duzlDrfOZ7ezgjna/TqXd
X-Google-Smtp-Source: APXvYqw5o750qM75OAkZ2ZRp32ldpAIlFcUySWBJMF0kNLK6V9LjmT2H5Pku0ZhWlX6QASDLRYRf0Nq/PviQgDNuXOhd+pus6FCB
MIME-Version: 1.0
X-Received: by 2002:a6b:6a0a:: with SMTP id x10mr8062119iog.48.1576914308376;
 Fri, 20 Dec 2019 23:45:08 -0800 (PST)
Date:   Fri, 20 Dec 2019 23:45:08 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000031376f059a31f9fb@google.com>
Subject: WARNING: ODEBUG bug in io_sqe_files_unregister
From:   syzbot <syzbot+6bf913476056cb0f8d13@syzkaller.appspotmail.com>
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
console output: https://syzkaller.appspot.com/x/log.txt?x=12340ac1e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f183b01c3088afc6
dashboard link: https://syzkaller.appspot.com/bug?extid=6bf913476056cb0f8d13
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15653c3ee00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+6bf913476056cb0f8d13@syzkaller.appspotmail.com

------------[ cut here ]------------
ODEBUG: free active (active state 0) object type: work_struct hint:  
io_ring_file_ref_switch+0x0/0xac0 fs/io_uring.c:5186
WARNING: CPU: 0 PID: 11569 at lib/debugobjects.c:481  
debug_print_object+0x168/0x250 lib/debugobjects.c:481
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 11569 Comm: syz-executor.1 Not tainted  
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
RIP: 0010:debug_print_object+0x168/0x250 lib/debugobjects.c:481
Code: dd c0 24 70 88 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 b5 00 00 00 48  
8b 14 dd c0 24 70 88 48 c7 c7 20 1a 70 88 e8 67 6c b1 fd <0f> 0b 83 05 53  
2d ed 06 01 48 83 c4 20 5b 41 5c 41 5d 41 5e 5d c3
RSP: 0018:ffffc90001d57c30 EFLAGS: 00010082
RAX: 0000000000000000 RBX: 0000000000000003 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff815e9f66 RDI: fffff520003aaf78
RBP: ffffc90001d57c70 R08: ffff88809eb081c0 R09: ffffed1015d045c9
R10: ffffed1015d045c8 R11: ffff8880ae822e43 R12: 0000000000000001
R13: ffffffff8997da40 R14: ffffffff814c75d0 R15: ffff888098ba3f50
  __debug_check_no_obj_freed lib/debugobjects.c:963 [inline]
  debug_check_no_obj_freed+0x2d4/0x43f lib/debugobjects.c:994
  kfree+0xf8/0x2c0 mm/slab.c:3756
  io_sqe_files_unregister+0x1fb/0x2f0 fs/io_uring.c:4631
  io_ring_ctx_free fs/io_uring.c:5575 [inline]
  io_ring_ctx_wait_and_kill+0x430/0x9a0 fs/io_uring.c:5644
  io_uring_release+0x42/0x50 fs/io_uring.c:5652
  __fput+0x2ff/0x890 fs/file_table.c:280
  ____fput+0x16/0x20 fs/file_table.c:313
  task_work_run+0x145/0x1c0 kernel/task_work.c:113
  tracehook_notify_resume include/linux/tracehook.h:188 [inline]
  exit_to_usermode_loop+0x316/0x380 arch/x86/entry/common.c:164
  prepare_exit_to_usermode arch/x86/entry/common.c:195 [inline]
  syscall_return_slowpath arch/x86/entry/common.c:278 [inline]
  do_syscall_64+0x676/0x790 arch/x86/entry/common.c:304
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x4144b1
Code: 75 14 b8 03 00 00 00 0f 05 48 3d 01 f0 ff ff 0f 83 04 1b 00 00 c3 48  
83 ec 08 e8 0a fc ff ff 48 89 04 24 b8 03 00 00 00 0f 05 <48> 8b 3c 24 48  
89 c2 e8 53 fc ff ff 48 89 d0 48 83 c4 08 48 3d 01
RSP: 002b:00007fffce1df2c0 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 0000000000000004 RCX: 00000000004144b1
RDX: 0000001b2bc20000 RSI: 0000000000000000 RDI: 0000000000000003
RBP: 0000000000000001 R08: ffffffffffffffff R09: ffffffffffffffff
R10: 00007fffce1df3a0 R11: 0000000000000293 R12: 000000000075bf20
R13: 0000000000017a4a R14: 00000000007605f8 R15: 000000000075bf2c
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
