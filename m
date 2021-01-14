Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A69B2F5B47
	for <lists+io-uring@lfdr.de>; Thu, 14 Jan 2021 08:28:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726951AbhANH16 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 14 Jan 2021 02:27:58 -0500
Received: from mail-io1-f70.google.com ([209.85.166.70]:45571 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726820AbhANH15 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 14 Jan 2021 02:27:57 -0500
Received: by mail-io1-f70.google.com with SMTP id x7so6971233ion.12
        for <io-uring@vger.kernel.org>; Wed, 13 Jan 2021 23:27:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=YzeP38Whzabl2SILmCDC2he+feFF6GbC3cI7SHBtcxc=;
        b=hAo/fwmi9gELzk+6eE2cm5OzV1BIp0YhF2nXfTgpJmWRsCJhCAOJSjKZGjYACE7Bdj
         jq4z4fqfTsCNAh/VgUOjY5y7q3NWrkMOy0wzeV2e2xS3yruS6qZoAjWXUBw7bKO5AV3y
         C16JuFX3YkH7JCLQ1EY4PlaUiqmZQfum7SHHyXEDloBTFfRqJhDl4MZZ9zleWLafQvSS
         LSHZ8rbMEs1BQn8D0FP7YkC40XWpJ3rfWqehHascrkL2KMhbB9H/ONdd+kujNq4Ki6Gm
         Wh3aVTVJ5574T3buqkQbKXCps3Hgwigf7DaRcInA3TJsoLWYKUMBPxyF3rzVh3+HW77I
         79eA==
X-Gm-Message-State: AOAM533agMuxtASxu8SZt4m5fabBAm0K1vptW0n5vg8YOOaw22rvtDI2
        fTcJ2Zlix28WD/DYnJOVDMBRauZS72QtyITU9IExrZEOIfRE
X-Google-Smtp-Source: ABdhPJzTRwoQlONJjqJAj6alLo1oAepHaGIrbhEWMdEM+dzxy6wUGkTTZZ7uhH7HRbHegYY8oWGClnCnL/+huEnxGdfSOE055dM4
MIME-Version: 1.0
X-Received: by 2002:a02:cf9a:: with SMTP id w26mr5401177jar.25.1610609236357;
 Wed, 13 Jan 2021 23:27:16 -0800 (PST)
Date:   Wed, 13 Jan 2021 23:27:16 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000067b86b05b8d72ff6@google.com>
Subject: general protection fault in io_uring_setup
From:   syzbot <syzbot+06b7d55a62acca161485@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    65f0d241 Merge tag 'sound-5.11-rc4' of git://git.kernel.or..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16bbcd98d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ee2266946ed36986
dashboard link: https://syzkaller.appspot.com/bug?extid=06b7d55a62acca161485
compiler:       clang version 11.0.0 (https://github.com/llvm/llvm-project.git ca2dcbd030eadbf0aa9b660efe864ff08af6e18b)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17ef17fb500000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1045ef67500000

The issue was bisected to:

commit d9d05217cb6990b9a56e13b56e7a1b71e2551f6c
Author: Pavel Begunkov <asml.silence@gmail.com>
Date:   Fri Jan 8 20:57:25 2021 +0000

    io_uring: stop SQPOLL submit on creator's death

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=148ba0cf500000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=168ba0cf500000
console output: https://syzkaller.appspot.com/x/log.txt?x=128ba0cf500000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+06b7d55a62acca161485@syzkaller.appspotmail.com
Fixes: d9d05217cb69 ("io_uring: stop SQPOLL submit on creator's death")

Code: e8 cc ac 02 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 3b 0a fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffc6a96c958 EFLAGS: 00000206 ORIG_RAX: 00000000000001a9
RAX: ffffffffffffffda RBX: 0000000020000200 RCX: 0000000000441889
RDX: 0000000020ffd000 RSI: 0000000020000200 RDI: 0000000000003040
RBP: 000000000000d8dd R08: 0000000000000001 R09: 0000000020ffd000
R10: 0000000000000000 R11: 0000000000000206 R12: 0000000020ffd000
R13: 0000000020ffb000 R14: 0000000000000000 R15: 0000000000000000
general protection fault, probably for non-canonical address 0xdffffc0000000022: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000110-0x0000000000000117]
CPU: 0 PID: 8444 Comm: syz-executor770 Not tainted 5.11.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:io_ring_set_wakeup_flag fs/io_uring.c:6929 [inline]
RIP: 0010:io_disable_sqo_submit fs/io_uring.c:8891 [inline]
RIP: 0010:io_uring_create fs/io_uring.c:9711 [inline]
RIP: 0010:io_uring_setup fs/io_uring.c:9739 [inline]
RIP: 0010:__do_sys_io_uring_setup fs/io_uring.c:9745 [inline]
RIP: 0010:__se_sys_io_uring_setup+0x2abb/0x37b0 fs/io_uring.c:9742
Code: c0 00 00 00 48 89 d8 48 c1 e8 03 42 80 3c 28 00 74 08 48 89 df e8 c5 31 de ff 41 be 14 01 00 00 4c 03 33 4c 89 f0 48 c1 e8 03 <42> 8a 04 28 84 c0 0f 85 46 06 00 00 41 80 0e 01 48 8b 7c 24 30 e8
RSP: 0018:ffffc90000edfca0 EFLAGS: 00010007
RAX: 0000000000000022 RBX: ffff888021fe50c0 RCX: 0000000000000001
RDX: dffffc0000000000 RSI: 0000000000000004 RDI: ffffc90000edfb80
RBP: ffffc90000edff38 R08: dffffc0000000000 R09: 0000000000000003
R10: fffff520001dbf71 R11: 0000000000000004 R12: 0000000000000001
R13: dffffc0000000000 R14: 0000000000000114 R15: 00000000fffffff4
FS:  0000000000975940(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000204 CR3: 00000000222d6000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x441889
Code: e8 cc ac 02 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 3b 0a fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffc6a96c958 EFLAGS: 00000206 ORIG_RAX: 00000000000001a9
RAX: ffffffffffffffda RBX: 0000000020000200 RCX: 0000000000441889
RDX: 0000000020ffd000 RSI: 0000000020000200 RDI: 0000000000003040
RBP: 000000000000d8dd R08: 0000000000000001 R09: 0000000020ffd000
R10: 0000000000000000 R11: 0000000000000206 R12: 0000000020ffd000
R13: 0000000020ffb000 R14: 0000000000000000 R15: 0000000000000000
Modules linked in:
---[ end trace d873293344bf9303 ]---
RIP: 0010:io_ring_set_wakeup_flag fs/io_uring.c:6929 [inline]
RIP: 0010:io_disable_sqo_submit fs/io_uring.c:8891 [inline]
RIP: 0010:io_uring_create fs/io_uring.c:9711 [inline]
RIP: 0010:io_uring_setup fs/io_uring.c:9739 [inline]
RIP: 0010:__do_sys_io_uring_setup fs/io_uring.c:9745 [inline]
RIP: 0010:__se_sys_io_uring_setup+0x2abb/0x37b0 fs/io_uring.c:9742
Code: c0 00 00 00 48 89 d8 48 c1 e8 03 42 80 3c 28 00 74 08 48 89 df e8 c5 31 de ff 41 be 14 01 00 00 4c 03 33 4c 89 f0 48 c1 e8 03 <42> 8a 04 28 84 c0 0f 85 46 06 00 00 41 80 0e 01 48 8b 7c 24 30 e8
RSP: 0018:ffffc90000edfca0 EFLAGS: 00010007
RAX: 0000000000000022 RBX: ffff888021fe50c0 RCX: 0000000000000001
RDX: dffffc0000000000 RSI: 0000000000000004 RDI: ffffc90000edfb80
RBP: ffffc90000edff38 R08: dffffc0000000000 R09: 0000000000000003
R10: fffff520001dbf71 R11: 0000000000000004 R12: 0000000000000001
R13: dffffc0000000000 R14: 0000000000000114 R15: 00000000fffffff4
FS:  0000000000975940(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000204 CR3: 00000000222d6000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
