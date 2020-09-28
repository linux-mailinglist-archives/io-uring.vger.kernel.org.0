Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E77D327A88A
	for <lists+io-uring@lfdr.de>; Mon, 28 Sep 2020 09:27:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726610AbgI1H10 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 28 Sep 2020 03:27:26 -0400
Received: from mail-il1-f206.google.com ([209.85.166.206]:32873 "EHLO
        mail-il1-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726566AbgI1H1Z (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 28 Sep 2020 03:27:25 -0400
Received: by mail-il1-f206.google.com with SMTP id e73so97548ill.0
        for <io-uring@vger.kernel.org>; Mon, 28 Sep 2020 00:27:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=rtPwNtURyv9M8v1JEvmJ42g5GKgu7iY0IwuKVxXGZsU=;
        b=ttEI2qxE74AB/KK5XjxauJd+atC+vg+g+HWyExnIqRAPjLE02zVYNTKVLd5B43H7cU
         XsLa9+HhhU9l4HWJxv1JSql62/Wpx1or4q2Yl6zKSHmw3EqAWL9Ur8wWHihYw9Jj8Aqs
         FvCgPmT8mtX4exvZp/PI8kJI0aAkwGY1j4E+2cRXNWqeCNY+d1beKqBgUOl+e9OgpLgM
         dY6DX3rsweZQBAWZnE+ZTLrDvrmJADIZYRlcCGopux7zvRcbe68hU2kKmgdKjezmvTQE
         y6WO+Vlai8XkOe9/sBo2dHCnMqKyC56YAUgd2Q1sR5wntJ7LZmRtsw6WHUiFPOk2Deun
         sQQA==
X-Gm-Message-State: AOAM531Ttvw+vnVuidUzShaSWKpkvKepMUIp8uUgsSDIoJsASS1JMl3d
        xsGL7J+kZb3ehdFQwyrzPUUdFFBmuJmC5ScEGqKJFy485eqv
X-Google-Smtp-Source: ABdhPJxv6NMMK03JuJ/6TCFwYrp5WtsAA0Rc/OoAN3s68mo6U+Sp65Wt3OxKCsEi1tIDc++JsewmaWGfXItwLxRbOeoiippP7VEx
MIME-Version: 1.0
X-Received: by 2002:a02:1a83:: with SMTP id 125mr164279jai.48.1601278044864;
 Mon, 28 Sep 2020 00:27:24 -0700 (PDT)
Date:   Mon, 28 Sep 2020 00:27:24 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000000d060805b05a9940@google.com>
Subject: general protection fault in io_uring_flush
From:   syzbot <syzbot+b64c3e0ed576fc1d70e5@syzkaller.appspotmail.com>
To:     axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    d1d2220c Add linux-next specific files for 20200924
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=150e718d900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=254e028a642027c
dashboard link: https://syzkaller.appspot.com/bug?extid=b64c3e0ed576fc1d70e5
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11f0fe4b900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b64c3e0ed576fc1d70e5@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc0000000029: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000148-0x000000000000014f]
CPU: 0 PID: 8508 Comm: syz-executor.2 Not tainted 5.9.0-rc6-next-20200924-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:io_sq_thread_park fs/io_uring.c:7142 [inline]
RIP: 0010:io_uring_flush+0x105b/0x1640 fs/io_uring.c:8596
Code: 0f 85 f4 04 00 00 48 8b 44 24 20 48 8b 98 a8 01 00 00 48 b8 00 00 00 00 00 fc ff df 48 8d ab 48 01 00 00 48 89 ea 48 c1 ea 03 <80> 3c 02 00 0f 85 b9 04 00 00 48 83 bb 48 01 00 00 00 74 37 e8 1c
RSP: 0018:ffffc9000a66fd70 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffffff81dad5e8
RDX: 0000000000000029 RSI: ffffffff81dad5f5 RDI: ffff888099c7f1a8
RBP: 0000000000000148 R08: 0000000000000000 R09: ffff88809d6443c7
R10: 0000000000000000 R11: 0000000000000000 R12: ffff88809ad1fbc0
R13: 0000000000000000 R14: ffff888099c7f000 R15: 0000000000000000
FS:  00000000020a7940(0000) GS:ffff8880ae400000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000768000 CR3: 000000009c90d000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 filp_close+0xb4/0x170 fs/open.c:1276
 __close_fd+0x2f/0x50 fs/file.c:671
 __do_sys_close fs/open.c:1295 [inline]
 __se_sys_close fs/open.c:1293 [inline]
 __x64_sys_close+0x69/0x100 fs/open.c:1293
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x417901
Code: 75 14 b8 03 00 00 00 0f 05 48 3d 01 f0 ff ff 0f 83 a4 1a 00 00 c3 48 83 ec 08 e8 0a fc ff ff 48 89 04 24 b8 03 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 53 fc ff ff 48 89 d0 48 83 c4 08 48 3d 01
RSP: 002b:00007ffca0939140 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 0000000000417901
RDX: 0000001b31f20000 RSI: 0000000000000001 RDI: 0000000000000003
RBP: 0000000000000001 R08: 0000000000000000 R09: 0000000000000000
R10: 00007ffca0939230 R11: 0000000000000293 R12: 000000000118d9c0
R13: 000000000118d9c0 R14: ffffffffffffffff R15: 000000000118cf4c
Modules linked in:
---[ end trace 188a1c353995f688 ]---
RIP: 0010:io_sq_thread_park fs/io_uring.c:7142 [inline]
RIP: 0010:io_uring_flush+0x105b/0x1640 fs/io_uring.c:8596
Code: 0f 85 f4 04 00 00 48 8b 44 24 20 48 8b 98 a8 01 00 00 48 b8 00 00 00 00 00 fc ff df 48 8d ab 48 01 00 00 48 89 ea 48 c1 ea 03 <80> 3c 02 00 0f 85 b9 04 00 00 48 83 bb 48 01 00 00 00 74 37 e8 1c
RSP: 0018:ffffc9000a66fd70 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffffff81dad5e8
RDX: 0000000000000029 RSI: ffffffff81dad5f5 RDI: ffff888099c7f1a8
RBP: 0000000000000148 R08: 0000000000000000 R09: ffff88809d6443c7
R10: 0000000000000000 R11: 0000000000000000 R12: ffff88809ad1fbc0
R13: 0000000000000000 R14: ffff888099c7f000 R15: 0000000000000000
FS:  00000000020a7940(0000) GS:ffff8880ae400000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000004 CR3: 000000009c90d000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
