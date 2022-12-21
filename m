Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E16BE652C19
	for <lists+io-uring@lfdr.de>; Wed, 21 Dec 2022 05:24:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234179AbiLUEYv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 20 Dec 2022 23:24:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233491AbiLUEYt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 20 Dec 2022 23:24:49 -0500
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9571F175A2
        for <io-uring@vger.kernel.org>; Tue, 20 Dec 2022 20:24:48 -0800 (PST)
Received: by mail-il1-f198.google.com with SMTP id l13-20020a056e021c0d00b003034e24b866so9611834ilh.22
        for <io-uring@vger.kernel.org>; Tue, 20 Dec 2022 20:24:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=c6Vv3GZn7ROVR+Uvu0zXaLGzZPu9ziyHOne2RRkvk8w=;
        b=JSQwVfQ3pzGSfIPyo//h/sNoIj0ByOS0WZiszRlEP6D/3Oy79D00O5PDySn/yiUQk2
         Gj5Baj5612BJ4+OlpeGKOGpCmzBo4sSNWo+PW8Di8YLBn9JlMdJQIym3rBRdlSHhkFYI
         qGyCwDXQ2FoFpJuXwoGeLUB7RwYKTjtJRiCpqxefWr9jCKBq5P/oD8kTGSAheY6MskTK
         /R1j/sLi/9tY4G29hZuewlfI2jsYWO/09Rsc4ym7z+YrI7czIxrmA2NLKiwVK6VMo/G4
         cIkNMXWnVZf4w4usgRSoRrGfnp+xpiYThmOBmDZokkPpaHv9HIf4lZAzW1o4ey0KKjNs
         Q3dw==
X-Gm-Message-State: AFqh2kqe3UD500FT0bKFTNKxZtw1S3I5RAy098r78+9TpaMf64oU2PuI
        WOLSwxyK3bW1TTuz8F4TB7wiM+25w0iV9gEJLdw6FS1caPdo
X-Google-Smtp-Source: AMrXdXsQ1hkMcM+9gqVZhW5O0O9Wj6Sm7ahZq6GeFKtj+FB0mKxLr2lRtIUITHqvaaMljVF9Q+/B+kZQhOP3m9aPdkkhWYv6FGix
MIME-Version: 1.0
X-Received: by 2002:a05:6638:60a:b0:363:ae32:346f with SMTP id
 g10-20020a056638060a00b00363ae32346fmr15266jar.31.1671596687953; Tue, 20 Dec
 2022 20:24:47 -0800 (PST)
Date:   Tue, 20 Dec 2022 20:24:47 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000cb143a05f04eee15@google.com>
Subject: [syzbot] WARNING in io_cqring_overflow_flush
From:   syzbot <syzbot+cf6ea1d6bb30a4ce10b2@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    77856d911a8c Merge tag 'arm64-fixes' of git://git.kernel.o..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=13e722d7880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=334a10f27a9ee2e0
dashboard link: https://syzkaller.appspot.com/bug?extid=cf6ea1d6bb30a4ce10b2
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=112eeb13880000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16b78bdb880000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/84863f051feb/disk-77856d91.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/87614e2a8a26/vmlinux-77856d91.xz
kernel image: https://storage.googleapis.com/syzbot-assets/cb76bad63a90/bzImage-77856d91.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+cf6ea1d6bb30a4ce10b2@syzkaller.appspotmail.com

------------[ cut here ]------------
do not call blocking ops when !TASK_RUNNING; state=1 set at [<ffffffff81606e0e>] prepare_to_wait_exclusive+0x7e/0x2c0 kernel/sched/wait.c:290
WARNING: CPU: 1 PID: 5084 at kernel/sched/core.c:9908 __might_sleep+0x109/0x160 kernel/sched/core.c:9908
Modules linked in:
CPU: 1 PID: 5084 Comm: syz-executor102 Not tainted 6.1.0-syzkaller-13031-g77856d911a8c #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
RIP: 0010:__might_sleep+0x109/0x160 kernel/sched/core.c:9908
Code: ac 03 00 48 8d bb b8 16 00 00 48 89 fa 48 c1 ea 03 80 3c 02 00 75 34 48 8b 93 b8 16 00 00 48 c7 c7 80 d6 2b 8a e8 74 f6 5b 08 <0f> 0b e9 75 ff ff ff e8 7b 78 78 00 e9 26 ff ff ff 89 34 24 e8 8e
RSP: 0018:ffffc90003ccfbb8 EFLAGS: 00010282
RAX: 0000000000000000 RBX: ffff88802aa48000 RCX: 0000000000000000
RDX: ffff88802aa48000 RSI: ffffffff8166707c RDI: fffff52000799f69
RBP: ffffffff8a2c3500 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000080000000 R11: 0000000000000000 R12: 0000000000000244
R13: dffffc0000000000 R14: 0000000000000001 R15: 0000000000001000
FS:  00007fbcc68c0700(0000) GS:ffff8880b9b00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fbcc6964018 CR3: 0000000028bc2000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 __mutex_lock_common kernel/locking/mutex.c:580 [inline]
 __mutex_lock+0x9f/0x1360 kernel/locking/mutex.c:747
 io_cqring_overflow_flush io_uring/io_uring.c:674 [inline]
 io_cqring_overflow_flush+0xe6/0x130 io_uring/io_uring.c:669
 io_cqring_wait io_uring/io_uring.c:2534 [inline]
 __do_sys_io_uring_enter+0x1590/0x21b0 io_uring/io_uring.c:3358
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7fbcc6912ec9
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 81 14 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fbcc68c02f8 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
RAX: ffffffffffffffda RBX: 00007fbcc69974a8 RCX: 00007fbcc6912ec9
RDX: 000000000000fc0f RSI: 0000000000001000 RDI: 0000000000000003
RBP: 00007fbcc69974a0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000003 R11: 0000000000000246 R12: 00007fbcc69974ac
R13: 0000000000000003 R14: 00007fbcc68c0400 R15: 0000000000022000
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
