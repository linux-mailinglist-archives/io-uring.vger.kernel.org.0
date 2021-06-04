Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05A1939B595
	for <lists+io-uring@lfdr.de>; Fri,  4 Jun 2021 11:11:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbhFDJNK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 4 Jun 2021 05:13:10 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:48890 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230039AbhFDJNK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 4 Jun 2021 05:13:10 -0400
Received: by mail-io1-f69.google.com with SMTP id u19-20020a6be3130000b02904a77f550cbcso4630600ioc.15
        for <io-uring@vger.kernel.org>; Fri, 04 Jun 2021 02:11:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=HGoRUY9mYZuduO3jacd1g9FzW8f74llZdR0Jp3fj9To=;
        b=fRN0gOqwP+JCod2GdT6WcaOS+c90Od+ZFo2r0j9TzkHQRc8jBNoJqeUZSU1WC67lZH
         kbqObGvrJbZkdWn9gYZNcMM3XKRwXK9CzP+UVzHJ0AVvpAjALQLa846V2wruS4soK9Ah
         IcIDCdSpiGOhkfNEXFBG4VknOPdzX23pG2w11ShPBdvAij+TzAMUnr1IlGNvsY3Y+q2D
         bS2pZaWd2qxaDBkq5l/iZ5C9IwA94ozjlmvoSrv5ej+vjGoxWWkVCT/DaqbWhbaTiAs/
         f4/Ffc5UdVMa5xiPNTuOg4mXB4PsqFulx9FULqGrf8FlvuYYNUPGbgGQQXq4HP1eeuNR
         Z5/g==
X-Gm-Message-State: AOAM533ZvZb4j9yPecbIQmUfLLIli9o+ScPUjt64dY2xwZF0kWrDXDje
        6vJZTVV0vZT6djR4JykJqI43ThjHP8taAqJkf83kEjYGszWj
X-Google-Smtp-Source: ABdhPJy+/F3BHFS+uLlxSLoGUZfPRfqovQW4uFdJbBnXAxM/uUdw689W8INUiFpnEInAjN/vFEWdAXDIjY2+57QBRckIRG+GUD+2
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:cd1:: with SMTP id c17mr3099575ilj.210.1622797884200;
 Fri, 04 Jun 2021 02:11:24 -0700 (PDT)
Date:   Fri, 04 Jun 2021 02:11:24 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000006e1be105c3ed13fe@google.com>
Subject: [syzbot] WARNING in io_wqe_enqueue
From:   syzbot <syzbot+ea2f1484cffe5109dc10@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    f88cd3fb Merge tag 'vfio-v5.13-rc5' of git://github.com/aw..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=175c1577d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=82d85e75046e5e64
dashboard link: https://syzkaller.appspot.com/bug?extid=ea2f1484cffe5109dc10

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+ea2f1484cffe5109dc10@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 1 PID: 11749 at fs/io-wq.c:244 io_wqe_wake_worker fs/io-wq.c:244 [inline]
WARNING: CPU: 1 PID: 11749 at fs/io-wq.c:244 io_wqe_enqueue+0x7f6/0x910 fs/io-wq.c:751
Modules linked in:
CPU: 1 PID: 11749 Comm: syz-executor.0 Not tainted 5.13.0-rc4-syzkaller #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.14.0-2 04/01/2014
RIP: 0010:io_wqe_wake_worker fs/io-wq.c:244 [inline]
RIP: 0010:io_wqe_enqueue+0x7f6/0x910 fs/io-wq.c:751
Code: ef e8 3e a3 d8 ff e9 2d f9 ff ff 4c 89 ef e8 31 a3 d8 ff e9 53 f9 ff ff 48 89 ef e8 24 a3 d8 ff e9 9f fa ff ff e8 aa 1a 94 ff <0f> 0b e9 08 fb ff ff 48 8b 7c 24 08 e8 19 a3 d8 ff e9 ca fd ff ff
RSP: 0018:ffffc90000e3fc78 EFLAGS: 00010212
RAX: 0000000000003811 RBX: 0000000000000001 RCX: ffffc90001639000
RDX: 0000000000040000 RSI: ffffffff81dff6b6 RDI: 0000000000000003
RBP: ffff88801494a810 R08: 0000000000000000 R09: ffff88801494a8a3
R10: ffffffff81dff1bc R11: 0000000000000002 R12: ffff88801494a800
R13: ffff88801494a898 R14: ffff88801494a8e8 R15: 0000000000000000
FS:  00007fe134468700(0000) GS:ffff88802cb00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000040c0e0 CR3: 0000000072963000 CR4: 0000000000150ee0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 io_queue_async_work+0x2d0/0x5f0 fs/io_uring.c:1274
 __io_queue_sqe+0x806/0x10f0 fs/io_uring.c:6438
 __io_req_task_submit+0x103/0x120 fs/io_uring.c:2039
 io_async_task_func+0x23e/0x4c0 fs/io_uring.c:5074
 __tctx_task_work fs/io_uring.c:1910 [inline]
 tctx_task_work+0x24e/0x550 fs/io_uring.c:1924
 task_work_run+0xdd/0x1a0 kernel/task_work.c:164
 tracehook_notify_signal include/linux/tracehook.h:212 [inline]
 handle_signal_work kernel/entry/common.c:145 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:171 [inline]
 exit_to_user_mode_prepare+0x24a/0x280 kernel/entry/common.c:208
 __syscall_exit_to_user_mode_work kernel/entry/common.c:290 [inline]
 syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:301
 do_syscall_64+0x47/0xb0 arch/x86/entry/common.c:57
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4665d9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fe134468188 EFLAGS: 00000246 ORIG_RAX: 0000000000000030
RAX: 0000000000000000 RBX: 000000000056bf80 RCX: 00000000004665d9
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000004
RBP: 00000000004bfcb9 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056bf80
R13: 00007ffe2f2a5b4f R14: 00007fe134468300 R15: 0000000000022000


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
