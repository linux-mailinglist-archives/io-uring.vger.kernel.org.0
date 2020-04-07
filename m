Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8599B1A092D
	for <lists+io-uring@lfdr.de>; Tue,  7 Apr 2020 10:16:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727962AbgDGIQO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Apr 2020 04:16:14 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:47049 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727883AbgDGIQO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Apr 2020 04:16:14 -0400
Received: by mail-il1-f200.google.com with SMTP id n18so2400765ilp.13
        for <io-uring@vger.kernel.org>; Tue, 07 Apr 2020 01:16:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=IJaW8e1pAg406HAS3eifVVxAuqJ0aaca8MQ2T7iKKWU=;
        b=MT6Zqn1bRrqc931poaIcJs9uvVX5PMrv6wXWDcA4USopUYMlcRwyRIMfzFcjg0hapC
         sAI1mUp2j9qElVrk8kBWvGOIveHJ1+Wd3+VxsHzuTrtvUKgEvt48ijBR0NakhPKpeZF2
         FAWFvLwbf7YlPxCIilFODf9Kdnz6B+2YMN38TFIIQUzAxU3sJ9L/wYtiPnjW0C+XRK+S
         dGsXBCTDLI+jkJBgE/YfVxgcjP+uwfvFEaGzCMWlEueqIlhR2THjjeA8faKrgg1Xp4DL
         lzlRP2S5SFFmtDC3d4gcknDUbcxYxXuxSACvjt3if/OHOAkFIjBSoiqHCE2j2+wAhIfm
         2EJw==
X-Gm-Message-State: AGi0PuZDUQ91MHTwZvjZX3sLjREQ630qw0XBfINoBQXifjcdmETLcwhn
        aRbVylymc2DzC0Zo6qAydYkfIik+rZkzPqLnxqhP8fIpz49g
X-Google-Smtp-Source: APiQypLvj1XMIJth9nQaOebGarxZ54oBjoIcjVBp91jSdnNJcksZbB7B5U15GQarxcic6eQdMqO5vTJIVTFUdPBYznxJzJII/xOB
MIME-Version: 1.0
X-Received: by 2002:a92:d150:: with SMTP id t16mr1233211ilg.164.1586247373398;
 Tue, 07 Apr 2020 01:16:13 -0700 (PDT)
Date:   Tue, 07 Apr 2020 01:16:13 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000037a76305a2aeff88@google.com>
Subject: INFO: trying to register non-static key in __io_uring_register
From:   syzbot <syzbot+e6eeca4a035da76b3065@syzkaller.appspotmail.com>
To:     axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk,
        xiaoguang.wang@linux.alibaba.com
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    b2e2a818 Add linux-next specific files for 20200406
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1418a1c7e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=595413e7170f444b
dashboard link: https://syzkaller.appspot.com/bug?extid=e6eeca4a035da76b3065
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17cd89cde00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=102d89cde00000

The bug was bisected to:

commit 0558955373023b08f638c9ede36741b0e4200f58
Author: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Date:   Tue Mar 31 06:05:18 2020 +0000

    io_uring: refactor file register/unregister/update handling

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=166f91c7e00000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=156f91c7e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=116f91c7e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+e6eeca4a035da76b3065@syzkaller.appspotmail.com
Fixes: 055895537302 ("io_uring: refactor file register/unregister/update handling")

INFO: trying to register non-static key.
the code is fine but needs lockdep annotation.
turning off the locking correctness validator.
CPU: 1 PID: 7099 Comm: syz-executor897 Not tainted 5.6.0-next-20200406-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x188/0x20d lib/dump_stack.c:118
 assign_lock_key kernel/locking/lockdep.c:913 [inline]
 register_lock_class+0x1664/0x1760 kernel/locking/lockdep.c:1225
 __lock_acquire+0x104/0x4e00 kernel/locking/lockdep.c:4223
 lock_acquire+0x1f2/0x8f0 kernel/locking/lockdep.c:4923
 __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
 _raw_spin_lock_irqsave+0x8c/0xbf kernel/locking/spinlock.c:159
 io_sqe_files_register fs/io_uring.c:6599 [inline]
 __io_uring_register+0x1fe8/0x2f00 fs/io_uring.c:8001
 __do_sys_io_uring_register fs/io_uring.c:8081 [inline]
 __se_sys_io_uring_register fs/io_uring.c:8063 [inline]
 __x64_sys_io_uring_register+0x192/0x560 fs/io_uring.c:8063
 do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xb3
RIP: 0033:0x440289
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 fb 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffff1bbf558 EFLAGS: 00000246 ORIG_RAX: 00000000000001ab
RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 0000000000440289
RDX: 0000000020000280 RSI: 0000000000000002 RDI: 0000000000000003
RBP: 00000000006ca018 R08: 0000000000000000 R09: 00000000004002c8
R10: 0000000000000001 R11: 0000000000000246 R12: 0000000000401b10
R13: 0000000000401ba0 R14: 0000000000000000 R15: 0000000000000000


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
