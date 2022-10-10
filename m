Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 279C55F9A03
	for <lists+io-uring@lfdr.de>; Mon, 10 Oct 2022 09:33:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232456AbiJJHdH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 10 Oct 2022 03:33:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231824AbiJJHcn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 10 Oct 2022 03:32:43 -0400
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFF383FD7A
        for <io-uring@vger.kernel.org>; Mon, 10 Oct 2022 00:26:18 -0700 (PDT)
Received: by mail-qt1-f199.google.com with SMTP id ff14-20020a05622a4d8e00b00394aaf0f653so6350930qtb.19
        for <io-uring@vger.kernel.org>; Mon, 10 Oct 2022 00:26:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bQH1hlLstxWQkyLQwLvWnxYP8vf8A56g0BvfFlkNFs4=;
        b=xOnwanL9a/mWfUrlIubadneSQL3YeDNIJa76x2/RUvpfzgEAcVgEK1rL/B3MsJoOMM
         JHrjkiSK07jcEgiZ4JJoFSwv/GfR1Gy31ZWn5iYXA3NM9iSiGHzhSPGZbk9h6PAMXczo
         BvXW9w19ROk3ZgOQvSMu+P7PPGY059/EtkAwntU0sc15oCHXX7crkgQceKoCz2aA67AG
         LeOXj0Q23U1GzOBhJ8D7pPTosaIhv5fnwGc7EaTsVavDykLS7xGDh2kX1hBMeg0nbsTI
         fKqAyjZuOm0XBhNVw6A64SjP4Cf9KCCepeaBu+gyIZGzp7vLhMYVU7mIcgKfDfKCFEGr
         kXzw==
X-Gm-Message-State: ACrzQf3X/VYV/BG2tH0nhtby6TMVJC3rH6QjYA2jQ6bMWlb6gozHS9FP
        T8ZzIoERxBMqLEw8f9UeZ3sPIf77YGfbKIL4KvQp0KjptWnv
X-Google-Smtp-Source: AMsMyM6B0qGU3Hart1DbvtorvXOkvsY9fBhVVM4LI11Jdg6ES9axg1L2oCGTNhh8TzzN3y1SIEsUNsfea7V4xtmAmEI2PAQUs2zG
MIME-Version: 1.0
X-Received: by 2002:a05:6638:19c4:b0:363:afc3:b403 with SMTP id
 bi4-20020a05663819c400b00363afc3b403mr3402752jab.144.1665386145314; Mon, 10
 Oct 2022 00:15:45 -0700 (PDT)
Date:   Mon, 10 Oct 2022 00:15:45 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000009b01b805eaa8eda8@google.com>
Subject: [syzbot] KASAN: slab-out-of-bounds Read in io_uring_show_fdinfo
From:   syzbot <syzbot+e5198737e8a2d23d958c@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    a6afa4199d3d Merge tag 'mailbox-v6.1' of git://git.linaro...
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=10cfc3fa880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e2021a61197ebe02
dashboard link: https://syzkaller.appspot.com/bug?extid=e5198737e8a2d23d958c
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=108b448a880000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13a0403a880000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/b8f297fb220e/disk-a6afa419.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/9b6bc23e32ef/vmlinux-a6afa419.xz

The issue was bisected to:

commit 3b8fdd1dc35e395d19efbc8391a809a5b954ecf4
Author: Jens Axboe <axboe@kernel.dk>
Date:   Sun Sep 11 12:40:37 2022 +0000

    io_uring/fdinfo: fix sqe dumping for IORING_SETUP_SQE128

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1434f1ec880000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=1634f1ec880000
console output: https://syzkaller.appspot.com/x/log.txt?x=1234f1ec880000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e5198737e8a2d23d958c@syzkaller.appspotmail.com
Fixes: 3b8fdd1dc35e ("io_uring/fdinfo: fix sqe dumping for IORING_SETUP_SQE128")

==================================================================
BUG: KASAN: use-after-free in __io_uring_show_fdinfo io_uring/fdinfo.c:98 [inline]
BUG: KASAN: use-after-free in io_uring_show_fdinfo+0x625/0x1947 io_uring/fdinfo.c:206
Read of size 8 at addr ffff88806fbfff20 by task syz-executor255/3603

CPU: 0 PID: 3603 Comm: syz-executor255 Not tainted 6.0.0-syzkaller-09039-ga6afa4199d3d #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/22/2022
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_address_description mm/kasan/report.c:317 [inline]
 print_report.cold+0x2ba/0x719 mm/kasan/report.c:433
 kasan_report+0xb1/0x1e0 mm/kasan/report.c:495
 __io_uring_show_fdinfo io_uring/fdinfo.c:98 [inline]
 io_uring_show_fdinfo+0x625/0x1947 io_uring/fdinfo.c:206
 seq_show+0x587/0x800 fs/proc/fd.c:68
 seq_read_iter+0x4f5/0x1280 fs/seq_file.c:230
 seq_read+0x16d/0x210 fs/seq_file.c:162
 vfs_read+0x257/0x930 fs/read_write.c:468
 ksys_pread64 fs/read_write.c:665 [inline]
 __do_sys_pread64 fs/read_write.c:675 [inline]
 __se_sys_pread64 fs/read_write.c:672 [inline]
 __x64_sys_pread64+0x1f7/0x250 fs/read_write.c:672
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f7eb32dc369
Code: 28 c3 e8 1a 17 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffdd7256678 EFLAGS: 00000246 ORIG_RAX: 0000000000000011
RAX: ffffffffffffffda RBX: 00007ffdd7256780 RCX: 00007f7eb32dc369
RDX: 0000000000000011 RSI: 0000000020002140 RDI: 0000000000000005
RBP: 00007ffdd72566a0 R08: 00007ffdd7256510 R09: 0000000033303633
R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffdd7256780
R13: 00007ffdd72566a0 R14: 00007f7eb33180a1 R15: 0000000000000000
 </TASK>

The buggy address belongs to the physical page:
page:ffffea0001beffc0 refcount:0 mapcount:0 mapping:0000000000000000 index:0x1 pfn:0x6fbff
flags: 0xfff00000000000(node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000000000 dead000000000100 dead000000000122 0000000000000000
raw: 0000000000000001 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as freed
page last allocated via order 0, migratetype Movable, gfp_mask 0x8(__GFP_MOVABLE), pid 1, tgid 1 (swapper/0), ts 9881193944, free_ts 10384739419
 split_map_pages+0x1ef/0x520 mm/compaction.c:99
 isolate_freepages_range+0x30f/0x350 mm/compaction.c:737
 alloc_contig_range+0x2f6/0x490 mm/page_alloc.c:9331
 __alloc_contig_pages mm/page_alloc.c:9354 [inline]
 alloc_contig_pages+0x35a/0x4c0 mm/page_alloc.c:9431
 debug_vm_pgtable_alloc_huge_page mm/debug_vm_pgtable.c:1098 [inline]
 init_args mm/debug_vm_pgtable.c:1221 [inline]
 debug_vm_pgtable+0x88f/0x29d6 mm/debug_vm_pgtable.c:1259
 do_one_initcall+0xfe/0x650 init/main.c:1296
 do_initcall_level init/main.c:1369 [inline]
 do_initcalls init/main.c:1385 [inline]
 do_basic_setup init/main.c:1404 [inline]
 kernel_init_freeable+0x6b1/0x73a init/main.c:1623
 kernel_init+0x1a/0x1d0 init/main.c:1512
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1449 [inline]
 free_pcp_prepare+0x5e4/0xd20 mm/page_alloc.c:1499
 free_unref_page_prepare mm/page_alloc.c:3380 [inline]
 free_unref_page+0x19/0x4d0 mm/page_alloc.c:3476
 free_contig_range+0xb1/0x180 mm/page_alloc.c:9453
 destroy_args+0xa8/0x646 mm/debug_vm_pgtable.c:1031
 debug_vm_pgtable+0x2945/0x29d6 mm/debug_vm_pgtable.c:1354
 do_one_initcall+0xfe/0x650 init/main.c:1296
 do_initcall_level init/main.c:1369 [inline]
 do_initcalls init/main.c:1385 [inline]
 do_basic_setup init/main.c:1404 [inline]
 kernel_init_freeable+0x6b1/0x73a init/main.c:1623
 kernel_init+0x1a/0x1d0 init/main.c:1512
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306

Memory state around the buggy address:
 ffff88806fbffe00: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff88806fbffe80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>ffff88806fbfff00: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
                               ^
 ffff88806fbfff80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff88806fc00000: fa fb fb fb fb fb fb fc fc fc fc fa fb fb fb fb
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
