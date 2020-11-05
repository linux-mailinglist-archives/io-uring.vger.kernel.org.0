Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95EE12A8334
	for <lists+io-uring@lfdr.de>; Thu,  5 Nov 2020 17:14:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731311AbgKEQO0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 5 Nov 2020 11:14:26 -0500
Received: from mail-il1-f197.google.com ([209.85.166.197]:52188 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730721AbgKEQOT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 5 Nov 2020 11:14:19 -0500
Received: by mail-il1-f197.google.com with SMTP id f8so1415395ilj.18
        for <io-uring@vger.kernel.org>; Thu, 05 Nov 2020 08:14:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=LPep9Nteys3aoLNEl0+LmiCZ9NTgmMku4LQ+gLb0dvg=;
        b=k/XLRVXgFsGnMVeooM7cwGFU8OYz0aRE3oUU1bwoDIV8aU3rTYukNF7Uz0y1lWxoWu
         b+H31BzvGX3qJfX5/T5x1vG2yGv8elBMyROIQdHSBI91GOgaPRwX9BgoUvosDJcRRLbv
         xSrDdUjJ0Y3g5/DJIIoAAIzNdxgCMThd6NbejftUMwOmeqNbBfXnP1FJ7KnvlUCNYDjL
         1tOctXZir0qL8YzjS1Im+yRp0ybw21dgqgA6ThbxcQz094HNwdmoXcDhmbZq5uPM+4IR
         9NtMbeByse1x9+J22+xIC1gR9wAbJFw3UDgpkhdaQ2hU86spDtmp/E2Wd8F8ijaUHIjd
         rMXw==
X-Gm-Message-State: AOAM530QTlN4Yb4Aiz+olg0KajUgNwXyTSufdNe2T5gYT46FnKY28JkI
        2W2GBhXl8HMIcLf5nAfBWB+IVvyrwg9QEs7dyKt3S1VmEv2S
X-Google-Smtp-Source: ABdhPJzlExmcllBentIAGjJ/TCmoqYKXFCdIYJPQaPu6y/AefIfEmw5OsjI+bYcPlLDGSRSw2TPR4YPm3zf/OhLWuHrRT7B/llWj
MIME-Version: 1.0
X-Received: by 2002:a92:ba8b:: with SMTP id t11mr2397105ill.194.1604592856658;
 Thu, 05 Nov 2020 08:14:16 -0800 (PST)
Date:   Thu, 05 Nov 2020 08:14:16 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000003afa6905b35e6386@google.com>
Subject: general protection fault in io_uring_show_cred
From:   syzbot <syzbot+a6d494688cdb797bdfce@syzkaller.appspotmail.com>
To:     axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    4ef8451b Merge tag 'perf-tools-for-v5.10-2020-11-03' of gi..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12bf23a8500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=61033507391c77ff
dashboard link: https://syzkaller.appspot.com/bug?extid=a6d494688cdb797bdfce
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11022732500000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13649314500000

The issue was bisected to:

commit 1e6fa5216a0e59ef02e8b6b40d553238a3b81d49
Author: Jens Axboe <axboe@kernel.dk>
Date:   Thu Oct 15 14:46:24 2020 +0000

    io_uring: COW io_identity on mismatch

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14295fa8500000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=16295fa8500000
console output: https://syzkaller.appspot.com/x/log.txt?x=12295fa8500000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+a6d494688cdb797bdfce@syzkaller.appspotmail.com
Fixes: 1e6fa5216a0e ("io_uring: COW io_identity on mismatch")

general protection fault, probably for non-canonical address 0xdffffc04422cfb38: 0000 [#1] PREEMPT SMP KASAN
KASAN: probably user-memory-access in range [0x000000221167d9c0-0x000000221167d9c7]
CPU: 0 PID: 8480 Comm: syz-executor292 Not tainted 5.10.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:io_uring_show_cred+0x32f/0x5f0 fs/io_uring.c:8922
Code: 3c 02 00 0f 85 a8 02 00 00 49 8b ae a0 00 00 00 48 b8 00 00 00 00 00 fc ff df 48 8d 4d 04 48 89 ca 48 89 4c 24 18 48 c1 ea 03 <0f> b6 14 02 48 89 c8 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 e4
RSP: 0018:ffffc900015ff9f0 EFLAGS: 00010203
RAX: dffffc0000000000 RBX: ffff8880213f4c00 RCX: 000000221167d9c4
RDX: 00000004422cfb38 RSI: ffffffff81d32adc RDI: ffff888014b101a0
RBP: 000000221167d9c0 R08: 0000000000000001 R09: ffff8880272840ce
R10: ffffed1004e50819 R11: 0000000000000000 R12: 0000000000000001
R13: ffff8880136c4cb8 R14: ffff888014b10100 R15: ffffffff8b1fe940
FS:  0000000001182880(0000) GS:ffff8880b9e00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000455310 CR3: 000000001b604000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 idr_for_each+0x113/0x220 lib/idr.c:208
 __io_uring_show_fdinfo fs/io_uring.c:8974 [inline]
 io_uring_show_fdinfo+0x923/0xda0 fs/io_uring.c:8996
 seq_show+0x4a8/0x700 fs/proc/fd.c:65
 seq_read+0x432/0x1070 fs/seq_file.c:208
 do_loop_readv_writev fs/read_write.c:761 [inline]
 do_loop_readv_writev fs/read_write.c:748 [inline]
 do_iter_read+0x48e/0x6e0 fs/read_write.c:803
 vfs_readv+0xe5/0x150 fs/read_write.c:921
 do_preadv fs/read_write.c:1013 [inline]
 __do_sys_preadv fs/read_write.c:1063 [inline]
 __se_sys_preadv fs/read_write.c:1058 [inline]
 __x64_sys_preadv+0x231/0x310 fs/read_write.c:1058
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x4403a9
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 db 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fff45cb17f8 EFLAGS: 00000246 ORIG_RAX: 0000000000000127
RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 00000000004403a9
RDX: 0000000000000333 RSI: 00000000200017c0 RDI: 0000000000000004
RBP: 00000000006ca018 R08: 0000000000000000 R09: 65732f636f72702f
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000401c10
R13: 0000000000401ca0 R14: 0000000000000000 R15: 0000000000000000
Modules linked in:
---[ end trace 2f3a282977161035 ]---
RIP: 0010:io_uring_show_cred+0x32f/0x5f0 fs/io_uring.c:8922
Code: 3c 02 00 0f 85 a8 02 00 00 49 8b ae a0 00 00 00 48 b8 00 00 00 00 00 fc ff df 48 8d 4d 04 48 89 ca 48 89 4c 24 18 48 c1 ea 03 <0f> b6 14 02 48 89 c8 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 e4
RSP: 0018:ffffc900015ff9f0 EFLAGS: 00010203
RAX: dffffc0000000000 RBX: ffff8880213f4c00 RCX: 000000221167d9c4
RDX: 00000004422cfb38 RSI: ffffffff81d32adc RDI: ffff888014b101a0
RBP: 000000221167d9c0 R08: 0000000000000001 R09: ffff8880272840ce
R10: ffffed1004e50819 R11: 0000000000000000 R12: 0000000000000001
R13: ffff8880136c4cb8 R14: ffff888014b10100 R15: ffffffff8b1fe940
FS:  0000000001182880(0000) GS:ffff8880b9e00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000455310 CR3: 000000001b604000 CR4: 00000000001506f0
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
