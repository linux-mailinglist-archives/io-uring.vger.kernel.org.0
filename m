Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE19812BF5E
	for <lists+io-uring@lfdr.de>; Sat, 28 Dec 2019 22:53:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726100AbfL1VxK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 28 Dec 2019 16:53:10 -0500
Received: from mail-il1-f200.google.com ([209.85.166.200]:36425 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726080AbfL1VxJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 28 Dec 2019 16:53:09 -0500
Received: by mail-il1-f200.google.com with SMTP id t2so22280581ilp.3
        for <io-uring@vger.kernel.org>; Sat, 28 Dec 2019 13:53:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=dBLJhKt7bDmql16REWPUIvVdkd4XeGK8aXz3PHpRshc=;
        b=d/iF78/H5vGSSry/+bCtVmXXurS6c35jTiHngpOBgPr59vVasEWsNfiB/Auhaf5hvM
         Uc7norHgV72NlxtOhK+JztFIhsZy+MNHubq3CDcc7UMaQ2Pk85VRXvOXFgHV5W3WCMrs
         FmQ65tiybXF+fje8+L/EoQJk/lZx379blP/08vaNTr1+cK+m9GKFh6l9ZEWyKCsVpmnN
         8m4thVESDvH+hE2rQY1YLCgA9gUuBIQvoEnZ+VpyOWbzidcvT9rXrJl1FKmj4mXig2al
         TUVaFNcjevti9tXeq0Nu+JeEbrgEA2u4rZtYRcIepeKt3fsMH94g1NzE7tu3y7xYwto0
         WODQ==
X-Gm-Message-State: APjAAAUugQasjCDkjEXJUhoZeOvi04UB8uUX+ewkvWiWuA5e3gKsCojB
        pcjhA4LHOBBREK+Ce9h8LLbiaCmG587N4AwYmbsPF10L0lrQ
X-Google-Smtp-Source: APXvYqzqimDH9yxxhUKBBE5Hb9zL9sppKoe8qHp/BBcEZiuvsEGZAk5LQs11Xjl6dFpUkbfM+8HqE2uZfmh+zYCaZwOKIYqRI98e
MIME-Version: 1.0
X-Received: by 2002:a92:4707:: with SMTP id u7mr51321743ila.264.1577569989190;
 Sat, 28 Dec 2019 13:53:09 -0800 (PST)
Date:   Sat, 28 Dec 2019 13:53:09 -0800
In-Reply-To: <00000000000031376f059a31f9fb@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d08235059acaa215@google.com>
Subject: Re: WARNING: ODEBUG bug in io_sqe_files_unregister
From:   syzbot <syzbot+6bf913476056cb0f8d13@syzkaller.appspotmail.com>
To:     axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

syzbot has found a reproducer for the following crash on:

HEAD commit:    7ddd09fc Add linux-next specific files for 20191220
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=13d0dd25e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f183b01c3088afc6
dashboard link: https://syzkaller.appspot.com/bug?extid=6bf913476056cb0f8d13
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16945e49e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=121999c1e00000

The bug was bisected to:

commit cbb537634780172137459dead490d668d437ef4d
Author: Jens Axboe <axboe@kernel.dk>
Date:   Mon Dec 9 18:22:50 2019 +0000

     io_uring: avoid ring quiesce for fixed file set unregister and update

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10eadc56e00000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=12eadc56e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=14eadc56e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+6bf913476056cb0f8d13@syzkaller.appspotmail.com
Fixes: cbb537634780 ("io_uring: avoid ring quiesce for fixed file set  
unregister and update")

------------[ cut here ]------------
ODEBUG: free active (active state 0) object type: work_struct hint:  
io_ring_file_ref_switch+0x0/0xac0 fs/io_uring.c:5186
WARNING: CPU: 1 PID: 10017 at lib/debugobjects.c:481  
debug_print_object+0x168/0x250 lib/debugobjects.c:481
Kernel panic - not syncing: panic_on_warn set ...
CPU: 1 PID: 10017 Comm: syz-executor148 Not tainted  
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
RSP: 0018:ffffc9000331fc30 EFLAGS: 00010082
RAX: 0000000000000000 RBX: 0000000000000003 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff815e9f66 RDI: fffff52000663f78
RBP: ffffc9000331fc70 R08: ffff8880975da340 R09: ffffed1015d245c9
R10: ffffed1015d245c8 R11: ffff8880ae922e43 R12: 0000000000000001
R13: ffffffff8997da40 R14: ffffffff814c75d0 R15: ffff888216f92118
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
RIP: 0033:0x4035a0
Code: 01 f0 ff ff 0f 83 c0 0f 00 00 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f  
44 00 00 83 3d ad 07 2e 00 00 75 14 b8 03 00 00 00 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 94 0f 00 00 c3 48 83 ec 08 e8 fa 04 00 00
RSP: 002b:00007ffcba7e1fa8 EFLAGS: 00000246 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 0000000000000004 RCX: 00000000004035a0
RDX: 0000000000000000 RSI: 0000000000000006 RDI: 0000000000000003
RBP: 0000000000000000 R08: 00000000000003e8 R09: 00000000000003e8
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000000008f
R13: 0000000000000003 R14: 0000000000000004 R15: 00007ffcba7e2280
Kernel Offset: disabled
Rebooting in 86400 seconds..

