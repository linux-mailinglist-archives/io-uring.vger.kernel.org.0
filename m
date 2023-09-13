Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5E2279E7AF
	for <lists+io-uring@lfdr.de>; Wed, 13 Sep 2023 14:11:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240090AbjIMMMB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 13 Sep 2023 08:12:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240258AbjIMMMA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 13 Sep 2023 08:12:00 -0400
Received: from mail-oi1-f207.google.com (mail-oi1-f207.google.com [209.85.167.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28D1619B0
        for <io-uring@vger.kernel.org>; Wed, 13 Sep 2023 05:11:56 -0700 (PDT)
Received: by mail-oi1-f207.google.com with SMTP id 5614622812f47-3a6e180e49aso8458782b6e.0
        for <io-uring@vger.kernel.org>; Wed, 13 Sep 2023 05:11:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694607115; x=1695211915;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sA/0c0IHogCe4hi7QnJekr/b9DyklOw4HKZzYkPtSa0=;
        b=p2eIPbM7ONg3Vsz+6315uNc3GdXEA8UZrSxqWomZaTGp3MMxhInp75zRwPNTEvDkeK
         7hgGX6Snrj+VDKHobqoD4uWuUqLDHiWUw1Wk9O8C9YoH8n/nFB0gpoQOOYhwWurStsVA
         rZsg0CM5lLGcltqYcr8SouyxDTbAg4/jaCglugzxpthNK7Bc7P6sQWVAHFswKNp35d0O
         xMkbgbuRtX99xwBxBAQjK75hL0v6QFpQTWROUGcPi3JrrsydJ2R9ILVmY9G2CzraKlSW
         6ar1xs7FA3aLChTtl+9IGTnUQxGVgp+mPh7NApGcLP7AfIRSfph3nlMjyh30FZFPBJra
         lYbw==
X-Gm-Message-State: AOJu0YwqjUZqDcHRxH3e8J0bKUs+lX1KhzqhRpfsKVfJxaydmoXayUIm
        a25yZ5z3Rf6paymV27PnI1dT6zo2tt+r1lDbAZls3vlIrCMi
X-Google-Smtp-Source: AGHT+IEyylRMZyrHN0Ip+7mrnKTdLzx1mV+IcN/X2UdmrCohufED3Xg6X4H9A/Kt2OznZC9k/DBCcZhdirXoOb9w/YswCfsJD6R7
MIME-Version: 1.0
X-Received: by 2002:a05:6808:220e:b0:3a9:b964:820d with SMTP id
 bd14-20020a056808220e00b003a9b964820dmr975352oib.5.1694607115512; Wed, 13 Sep
 2023 05:11:55 -0700 (PDT)
Date:   Wed, 13 Sep 2023 05:11:55 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002770be06053c7757@google.com>
Subject: [syzbot] [io-uring?] UBSAN: array-index-out-of-bounds in io_setup_async_msg
From:   syzbot <syzbot+a4c6e5ef999b68b26ed1@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    0bb80ecc33a8 Linux 6.6-rc1
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=12d1eb78680000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f4894cf58531f
dashboard link: https://syzkaller.appspot.com/bug?extid=a4c6e5ef999b68b26ed1
compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16613002680000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13912e30680000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/eeb0cac260c7/disk-0bb80ecc.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/a3c360110254/vmlinux-0bb80ecc.xz
kernel image: https://storage.googleapis.com/syzbot-assets/22b81065ba5f/bzImage-0bb80ecc.xz

The issue was bisected to:

commit 2af89abda7d9c2aeb573677e2c498ddb09f8058a
Author: Pavel Begunkov <asml.silence@gmail.com>
Date:   Thu Aug 24 22:53:32 2023 +0000

    io_uring: add option to remove SQ indirection

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=15892e30680000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=17892e30680000
console output: https://syzkaller.appspot.com/x/log.txt?x=13892e30680000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+a4c6e5ef999b68b26ed1@syzkaller.appspotmail.com
Fixes: 2af89abda7d9 ("io_uring: add option to remove SQ indirection")

================================================================================
UBSAN: array-index-out-of-bounds in io_uring/net.c:189:55
index 3779567444058 is out of range for type 'iovec [8]'
CPU: 1 PID: 5039 Comm: syz-executor396 Not tainted 6.6.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/04/2023
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x125/0x1b0 lib/dump_stack.c:106
 ubsan_epilogue lib/ubsan.c:217 [inline]
 __ubsan_handle_out_of_bounds+0x111/0x150 lib/ubsan.c:348
 io_setup_async_msg+0x2a0/0x2b0 io_uring/net.c:189
 io_recvmsg+0x169f/0x2170 io_uring/net.c:781
 io_issue_sqe+0x54a/0xd80 io_uring/io_uring.c:1878
 io_queue_sqe io_uring/io_uring.c:2063 [inline]
 io_submit_sqe io_uring/io_uring.c:2323 [inline]
 io_submit_sqes+0x96c/0x1ed0 io_uring/io_uring.c:2438
 __do_sys_io_uring_enter+0x14ea/0x2650 io_uring/io_uring.c:3647
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x38/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f8af8d7c4e9
Code: 48 83 c4 28 c3 e8 37 17 00 00 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fff24b82fa8 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
RAX: ffffffffffffffda RBX: 0000000000001592 RCX: 00007f8af8d7c4e9
RDX: 0000000000000000 RSI: 0000000000007689 RDI: 0000000000000003
RBP: 0000000000000003 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000001
R13: 00007fff24b83188 R14: 0000000000000001 R15: 0000000000000001
 </TASK>
================================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection

If the bug is already fixed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

If you want to overwrite bug's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the bug is a duplicate of another bug, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
