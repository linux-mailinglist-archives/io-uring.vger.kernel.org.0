Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D4802AC329
	for <lists+io-uring@lfdr.de>; Mon,  9 Nov 2020 19:06:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730092AbgKISGT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Nov 2020 13:06:19 -0500
Received: from mail-io1-f71.google.com ([209.85.166.71]:39501 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729119AbgKISGT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Nov 2020 13:06:19 -0500
Received: by mail-io1-f71.google.com with SMTP id z18so6277179ioz.6
        for <io-uring@vger.kernel.org>; Mon, 09 Nov 2020 10:06:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=oGJS1xcLVmjeSr0kicAZZo67XlZTQ7FFIBD2yf36yuM=;
        b=d/s1QKU19Ml4Av53CiOBygW03AnWZveqWPWizF/Vx+HWjg7cCgC6Ecj2XupXR8upgE
         u0UvcEESEhy7WCAgMSOCi7Gfp1ByjluB5OnfxEWWEfea+GWTelc/V6b95KdDxgTMVnJd
         XeYs0e6clsu9FXsqXtR66xbkDW3BJ4RX9aQvaJPFt4XGqzAWPpzB0V3T2IiRdVsVb1GD
         s/qe/V9DpnumELx71WsVVuwJW3WiJxfRE1ba6K4twveFBs/rmiVkCMifltPTawfnjYcN
         WDuVPsWMI2ejaaNndeo6oKTjaNPYOllFGURiDHq6I6yfe+AqFn2/l66Aiq7nTeSVw1Dl
         FneQ==
X-Gm-Message-State: AOAM530K9cTUDYCwmMzERKB/Vci2CweP6jBDQ86HFoAMVlAsRi3/R1ZT
        zundZ6r74bjKQh99MrXriV6xxZTvlrHK6svdlpTSld6p0So8
X-Google-Smtp-Source: ABdhPJyVypA3dVFfLAgJSp/DnCjQIjz/xAskbEUiidyvXvz61uB3Hp4Wi8QNgwrHaNSfAFhTJo4FCrDRdW8wj531OCFtAoF5FTHC
MIME-Version: 1.0
X-Received: by 2002:a02:9716:: with SMTP id x22mr11524563jai.114.1604945176955;
 Mon, 09 Nov 2020 10:06:16 -0800 (PST)
Date:   Mon, 09 Nov 2020 10:06:16 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000028115c05b3b06bbd@google.com>
Subject: KASAN: slab-out-of-bounds Read in io_uring_show_cred
From:   syzbot <syzbot+46061b9b42fecc6e7d6d@syzkaller.appspotmail.com>
To:     axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    cf7cd542 Add linux-next specific files for 20201104
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=14649314500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e8dc0c5ac73afb92
dashboard link: https://syzkaller.appspot.com/bug?extid=46061b9b42fecc6e7d6d
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+46061b9b42fecc6e7d6d@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-out-of-bounds in io_uring_show_cred+0x598/0x5f0 fs/io_uring.c:9225
Read of size 4 at addr ffff8880253d13c8 by task syz-executor.3/10456

CPU: 1 PID: 10456 Comm: syz-executor.3 Not tainted 5.10.0-rc2-next-20201104-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xae/0x4c8 mm/kasan/report.c:385
 __kasan_report mm/kasan/report.c:545 [inline]
 kasan_report.cold+0x1f/0x37 mm/kasan/report.c:562
 io_uring_show_cred+0x598/0x5f0 fs/io_uring.c:9225
 idr_for_each+0x113/0x220 lib/idr.c:208
 __io_uring_show_fdinfo fs/io_uring.c:9272 [inline]
 io_uring_show_fdinfo+0x923/0xda0 fs/io_uring.c:9294
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
RIP: 0033:0x45deb9
Code: 0d b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 db b3 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f691c7eac78 EFLAGS: 00000246 ORIG_RAX: 0000000000000127
RAX: ffffffffffffffda RBX: 0000000000025e40 RCX: 000000000045deb9
RDX: 0000000000000333 RSI: 00000000200017c0 RDI: 0000000000000005
RBP: 000000000118c018 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000118bfd4
R13: 00007ffef15d676f R14: 00007f691c7eb9c0 R15: 000000000118bfd4

Allocated by task 10448:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
 kasan_set_track mm/kasan/common.c:56 [inline]
 __kasan_kmalloc.constprop.0+0xc2/0xd0 mm/kasan/common.c:461
 kmalloc include/linux/slab.h:552 [inline]
 io_register_personality fs/io_uring.c:9647 [inline]
 __io_uring_register fs/io_uring.c:9883 [inline]
 __do_sys_io_uring_register+0x10f0/0x40a0 fs/io_uring.c:9933
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

The buggy address belongs to the object at ffff8880253d1380
 which belongs to the cache kmalloc-96 of size 96
The buggy address is located 72 bytes inside of
 96-byte region [ffff8880253d1380, ffff8880253d13e0)
The buggy address belongs to the page:
page:000000003c207268 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x253d1
flags: 0xfff00000000200(slab)
raw: 00fff00000000200 ffffea0000a900c0 0000000500000005 ffff888010041780
raw: 0000000000000000 0000000080200020 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff8880253d1280: 00 00 00 00 00 00 00 00 00 00 fc fc fc fc fc fc
 ffff8880253d1300: fb fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
>ffff8880253d1380: 00 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc
                                              ^
 ffff8880253d1400: 00 00 00 00 00 00 00 00 00 00 fc fc fc fc fc fc
 ffff8880253d1480: 00 00 00 00 00 00 00 00 00 00 fc fc fc fc fc fc
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
