Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4ABB152AA49
	for <lists+io-uring@lfdr.de>; Tue, 17 May 2022 20:14:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346754AbiEQSOG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 May 2022 14:14:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352127AbiEQSNe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 May 2022 14:13:34 -0400
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEDEA522E5
        for <io-uring@vger.kernel.org>; Tue, 17 May 2022 11:13:22 -0700 (PDT)
Received: by mail-io1-f71.google.com with SMTP id s129-20020a6b2c87000000b00657c1a3b52fso12834058ios.21
        for <io-uring@vger.kernel.org>; Tue, 17 May 2022 11:13:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=Ec1+WPY44NjjWQGgm/fKM4RZ1+UwW/dQmTOsqUBCVt4=;
        b=rtu0CjaKDOzOVySie3uYOeXpo1WyX6xDklwn6reNPdqZtmTqvPOmjiOlm9v6WpOOBd
         SNV4Bv5hOhbytsHTwCg+rnWzuk/71UAxKh7fLfM0TnegboeQycp1CIvlK3pXmOhlkhp0
         +pL0ncFP+/0/vW7aW7xh94SQMbNc9kgQ7OK1SzKFvOE0BrmlcDN8yR4IB5VB2NkdlCe3
         GxCfcXat3AUkGs3a8GgeN9KHWh4ICBehF03XYhsJrtpbMfD6XRK9jug0tSegsrhM3iSJ
         Yv6LYfH078yhjGJ9OKi4plG6YeYmDPsRt8XzIVfMMoH6LBO7JhgitJMaFJqMoMUWH5sj
         8OcQ==
X-Gm-Message-State: AOAM530MtjEDYB9fI/55QOk0fbtjkCrpUG+rI/uQgQfdVcjIyj64lKKO
        L7IxFuttPGHxYS4LS9oHS6+LH9/OcadRFXj6e50Nplh1mPgz
X-Google-Smtp-Source: ABdhPJzb4u16T3LJkX1vKIkcnzOsUsEXniqdWgB0HMLgITYwOY48RC2c6eFUXknCPVdIfEOkCJOEJadExzNb2VzW3AdbkFIASFOR
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1b03:b0:2d1:249b:f94e with SMTP id
 i3-20020a056e021b0300b002d1249bf94emr5486209ilv.219.1652811202010; Tue, 17
 May 2022 11:13:22 -0700 (PDT)
Date:   Tue, 17 May 2022 11:13:21 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000093a60105df3918eb@google.com>
Subject: [syzbot] BUG: unable to handle kernel NULL pointer dereference in io_do_iopoll
From:   syzbot <syzbot+1a0a53300ce782f8b3ad@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    42226c989789 Linux 5.18-rc7
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=125b807ef00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=902c5209311d387c
dashboard link: https://syzkaller.appspot.com/bug?extid=1a0a53300ce782f8b3ad
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=149eb59ef00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17cc57c6f00000

The issue was bisected to:

commit 3f1d52abf098c85b177b8c6f5b310e8347d1bc42
Author: Jens Axboe <axboe@kernel.dk>
Date:   Tue Mar 29 16:43:56 2022 +0000

    io_uring: defer msg-ring file validity check until command issue

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1504cbaef00000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=1704cbaef00000
console output: https://syzkaller.appspot.com/x/log.txt?x=1304cbaef00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+1a0a53300ce782f8b3ad@syzkaller.appspotmail.com
Fixes: 3f1d52abf098 ("io_uring: defer msg-ring file validity check until command issue")

BUG: kernel NULL pointer dereference, address: 0000000000000000
#PF: supervisor instruction fetch in kernel mode
#PF: error_code(0x0010) - not-present page
PGD 0 P4D 0 
Oops: 0010 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 3596 Comm: syz-executor359 Not tainted 5.18.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:0x0
Code: Unable to access opcode bytes at RIP 0xffffffffffffffd6.
RSP: 0018:ffffc9000325fb68 EFLAGS: 00010246
RAX: ffffffff89dad220 RBX: dffffc0000000000 RCX: 0000000000000000
RDX: 0000000000000003 RSI: ffffc9000325fbe0 RDI: ffff8880213388c0
RBP: ffff888021338901 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff81ec11a0 R11: 0000000000000000 R12: 0000000000000003
R13: ffffc9000325fbe0 R14: ffff8880213388c0 R15: ffff888021338938
FS:  0000000000000000(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffffffffd6 CR3: 000000000ba8e000 CR4: 0000000000350ef0
Call Trace:
 <TASK>
 io_do_iopoll+0x262/0x1080 fs/io_uring.c:2776
 io_iopoll_try_reap_events+0xba/0x158 fs/io_uring.c:2829
 io_ring_ctx_wait_and_kill+0x1d9/0x327 fs/io_uring.c:10167
 io_uring_release+0x42/0x46 fs/io_uring.c:10184
 __fput+0x277/0x9d0 fs/file_table.c:317
 task_work_run+0xdd/0x1a0 kernel/task_work.c:164
 exit_task_work include/linux/task_work.h:37 [inline]
 do_exit+0xaff/0x2a00 kernel/exit.c:795
 do_group_exit+0xd2/0x2f0 kernel/exit.c:925
 __do_sys_exit_group kernel/exit.c:936 [inline]
 __se_sys_exit_group kernel/exit.c:934 [inline]
 __x64_sys_exit_group+0x3a/0x50 kernel/exit.c:934
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f115bc1bf19
Code: Unable to access opcode bytes at RIP 0x7f115bc1beef.
RSP: 002b:00007ffde3b5abf8 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 00007f115bc90290 RCX: 00007f115bc1bf19
RDX: 000000000000003c RSI: 00000000000000e7 RDI: 0000000000000000
RBP: 0000000000000000 R08: ffffffffffffffc0 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f115bc90290
R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000001
 </TASK>
Modules linked in:
CR2: 0000000000000000
---[ end trace 0000000000000000 ]---
RIP: 0010:0x0
Code: Unable to access opcode bytes at RIP 0xffffffffffffffd6.
RSP: 0018:ffffc9000325fb68 EFLAGS: 00010246
RAX: ffffffff89dad220 RBX: dffffc0000000000 RCX: 0000000000000000
RDX: 0000000000000003 RSI: ffffc9000325fbe0 RDI: ffff8880213388c0
RBP: ffff888021338901 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff81ec11a0 R11: 0000000000000000 R12: 0000000000000003
R13: ffffc9000325fbe0 R14: ffff8880213388c0 R15: ffff888021338938
FS:  0000000000000000(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffffffffd6 CR3: 000000000ba8e000 CR4: 0000000000350ef0


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
