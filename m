Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C117F2A832E
	for <lists+io-uring@lfdr.de>; Thu,  5 Nov 2020 17:14:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731180AbgKEQOU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 5 Nov 2020 11:14:20 -0500
Received: from mail-io1-f72.google.com ([209.85.166.72]:43973 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730854AbgKEQOT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 5 Nov 2020 11:14:19 -0500
Received: by mail-io1-f72.google.com with SMTP id o3so1445878iou.10
        for <io-uring@vger.kernel.org>; Thu, 05 Nov 2020 08:14:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=mRJ15N3DTTcwfnKBXtFSdL2/0uB3J/4P0TWhY34qaus=;
        b=j5xmkTFj474oJIoxgrGd5sdWvV4258aNVc7CYhqRqn5WSuYhM2aJqn+iVshNx3Murv
         hBeCtaPBGwEsKMzjn+c8wneKSlw7xY1rQ76oPjs7VLbatrf4JmUfZ53VBlZerpjkdF2b
         KBXTjNqWPbZBnkHw7sm9eTdf0TQQNKORRRSXd4DlkMb5QKcyv2Pu/KEkY92F6I0OFwTN
         rUOsObDJOLKQs7c+droeYCQ7BHmMJJBVZeRvFHWNGntA1TGcjkZ2ShKxZ7dWUDowktXg
         vO52WwU3w3GNVtm1UNM9rNUNL49QMLSt3Cz8YfoOrSAEJYRYgL3fuSkryUvdf9uTUOCi
         dVGw==
X-Gm-Message-State: AOAM532WpbI0lXiyiSkxCeeoO3lWVxtUrYxpNQw+i+Yq5vIY3cdNt6Pu
        /YhhokSn3jlgqpJFMdzvd5cXVuI5gM+F7wEry4IIYdn2hJUm
X-Google-Smtp-Source: ABdhPJwLhWGbogXRqjhwQml+B8efWoNtMrljpjzWu0QzWfV2m/Zk1JUfZIsMzGtOVuUnmpVJTSprT1FUMfjy1kbsO+UPSygQiiyx
MIME-Version: 1.0
X-Received: by 2002:a92:a808:: with SMTP id o8mr2173202ilh.35.1604592856371;
 Thu, 05 Nov 2020 08:14:16 -0800 (PST)
Date:   Thu, 05 Nov 2020 08:14:16 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000003698a305b35e63fb@google.com>
Subject: KASAN: use-after-free Read in io_uring_show_cred
From:   syzbot <syzbot+65731228192d0cafab77@syzkaller.appspotmail.com>
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
console output: https://syzkaller.appspot.com/x/log.txt?x=10238e2a500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=61033507391c77ff
dashboard link: https://syzkaller.appspot.com/bug?extid=65731228192d0cafab77
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10f42732500000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=175fbb82500000

The issue was bisected to:

commit 1e6fa5216a0e59ef02e8b6b40d553238a3b81d49
Author: Jens Axboe <axboe@kernel.dk>
Date:   Thu Oct 15 14:46:24 2020 +0000

    io_uring: COW io_identity on mismatch

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13e38e2a500000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=10138e2a500000
console output: https://syzkaller.appspot.com/x/log.txt?x=17e38e2a500000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+65731228192d0cafab77@syzkaller.appspotmail.com
Fixes: 1e6fa5216a0e ("io_uring: COW io_identity on mismatch")

==================================================================
BUG: KASAN: use-after-free in io_uring_show_cred+0x5bb/0x5f0 fs/io_uring.c:8921
Read of size 8 at addr ffff8880132a04a0 by task syz-executor141/8511

CPU: 0 PID: 8511 Comm: syz-executor141 Not tainted 5.10.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xae/0x4c8 mm/kasan/report.c:385
 __kasan_report mm/kasan/report.c:545 [inline]
 kasan_report.cold+0x1f/0x37 mm/kasan/report.c:562
 io_uring_show_cred+0x5bb/0x5f0 fs/io_uring.c:8921
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
RIP: 0033:0x4403b9
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 db 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffedd6269c8 EFLAGS: 00000246 ORIG_RAX: 0000000000000127
RAX: ffffffffffffffda RBX: 00007ffedd6269d0 RCX: 00000000004403b9
RDX: 0000000000000001 RSI: 0000000020001400 RDI: 0000000000000004
RBP: 00000000006ca018 R08: 0000000000000000 R09: 65732f636f72702f
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000401c20
R13: 0000000000401cb0 R14: 0000000000000000 R15: 0000000000000000

Allocated by task 4887:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
 kasan_set_track mm/kasan/common.c:56 [inline]
 __kasan_kmalloc.constprop.0+0xc2/0xd0 mm/kasan/common.c:461
 kmalloc include/linux/slab.h:557 [inline]
 kzalloc include/linux/slab.h:664 [inline]
 tomoyo_encode2.part.0+0xe9/0x3a0 security/tomoyo/realpath.c:45
 tomoyo_encode2 security/tomoyo/realpath.c:31 [inline]
 tomoyo_encode+0x28/0x50 security/tomoyo/realpath.c:80
 tomoyo_realpath_from_path+0x186/0x620 security/tomoyo/realpath.c:288
 tomoyo_get_realpath security/tomoyo/file.c:151 [inline]
 tomoyo_path_perm+0x21b/0x400 security/tomoyo/file.c:822
 security_inode_getattr+0xcf/0x140 security/security.c:1279
 vfs_getattr fs/stat.c:121 [inline]
 vfs_fstat+0x43/0xb0 fs/stat.c:146
 __do_sys_newfstat+0x81/0x100 fs/stat.c:386
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Freed by task 4887:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
 kasan_set_track+0x1c/0x30 mm/kasan/common.c:56
 kasan_set_free_info+0x1b/0x30 mm/kasan/generic.c:355
 __kasan_slab_free+0x102/0x140 mm/kasan/common.c:422
 slab_free_hook mm/slub.c:1544 [inline]
 slab_free_freelist_hook+0x5d/0x150 mm/slub.c:1577
 slab_free mm/slub.c:3142 [inline]
 kfree+0xdb/0x360 mm/slub.c:4124
 tomoyo_path_perm+0x23d/0x400 security/tomoyo/file.c:842
 security_inode_getattr+0xcf/0x140 security/security.c:1279
 vfs_getattr fs/stat.c:121 [inline]
 vfs_fstat+0x43/0xb0 fs/stat.c:146
 __do_sys_newfstat+0x81/0x100 fs/stat.c:386
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

The buggy address belongs to the object at ffff8880132a0480
 which belongs to the cache kmalloc-96 of size 96
The buggy address is located 32 bytes inside of
 96-byte region [ffff8880132a0480, ffff8880132a04e0)
The buggy address belongs to the page:
page:000000005ad008dd refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x132a0
flags: 0xfff00000000200(slab)
raw: 00fff00000000200 ffffea0000935fc0 0000000700000007 ffff888010041780
raw: 0000000000000000 0000000080200020 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff8880132a0380: fb fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
 ffff8880132a0400: 00 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc
>ffff8880132a0480: fa fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
                               ^
 ffff8880132a0500: fa fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
 ffff8880132a0580: 00 00 00 00 00 00 00 00 00 00 00 00 fc fc fc fc
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
