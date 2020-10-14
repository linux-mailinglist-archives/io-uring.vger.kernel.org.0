Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 821F228E038
	for <lists+io-uring@lfdr.de>; Wed, 14 Oct 2020 14:01:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730852AbgJNMBl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 14 Oct 2020 08:01:41 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:55317 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730863AbgJNMBZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 14 Oct 2020 08:01:25 -0400
Received: by mail-io1-f70.google.com with SMTP id t187so2184444iof.22
        for <io-uring@vger.kernel.org>; Wed, 14 Oct 2020 05:01:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=m6pDnHMdiVubenDMsWeSi3ZB8r2ghwq2DBPL+d9F3AA=;
        b=VC+oivqmi2cv3+N/T5ZFa176WX4fraJP1o7Vr+YlqtteqIoAqI0tdlSVXDfzcNMTfc
         lrAArGz9htckupqSGqGGFuMbW2CNl0T4JT9Ynl9jyIMbTtJrsUyS2oBWDoaLdimLK1qi
         qXJTlAEf0fgrnC799O5Kzr+0BwLe2h3L2+Jy5o5cOymiBpjmjxQnikLUYiclumrVjH1R
         h4oZgN57gq+o3KOoe2S6aGcYqsY8ObPY1njWQDwZngIfqcsalsp4WG3oR/2kPJw/zTzq
         643K5XfaNDxJbdsevpHfXGz+C0PPb8HmdihAcTI+8YvwAU/bj/Bs6oKdZOyRBV+5f05G
         0PEw==
X-Gm-Message-State: AOAM532kG6G0CcUrrWlx/OFom9VQyIF0v0xe0LA8IJ1nlNU/zPwmjJpi
        kuOkFJ/dZSTSLxFwilJ9soWkDBJGDSfm+ARzayS3BHvcsZk4
X-Google-Smtp-Source: ABdhPJxdho8NKnGbbUPFgQORA943leB6qV3R9Bcd9POiY3Qc6I6iK24VamqjNg7hfqz6iI6MtsVQDeVwdgWIitoPWh1XzZ6t4eBw
MIME-Version: 1.0
X-Received: by 2002:a05:6602:1d0:: with SMTP id w16mr2611673iot.102.1602676883882;
 Wed, 14 Oct 2020 05:01:23 -0700 (PDT)
Date:   Wed, 14 Oct 2020 05:01:23 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000005a849705b1a04ab8@google.com>
Subject: general protection fault in __do_sys_io_uring_register
From:   syzbot <syzbot+f4ebcc98223dafd8991e@syzkaller.appspotmail.com>
To:     axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    029f56db Merge tag 'x86_asm_for_v5.10' of git://git.kernel..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13b5c678500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d4ce0764b8e2dd3f
dashboard link: https://syzkaller.appspot.com/bug?extid=f4ebcc98223dafd8991e
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+f4ebcc98223dafd8991e@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 1 PID: 8927 Comm: syz-executor.3 Not tainted 5.9.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:io_file_from_index fs/io_uring.c:5963 [inline]
RIP: 0010:io_sqe_files_register fs/io_uring.c:7369 [inline]
RIP: 0010:__io_uring_register fs/io_uring.c:9463 [inline]
RIP: 0010:__do_sys_io_uring_register+0x2fd2/0x3ee0 fs/io_uring.c:9553
Code: ec 03 49 c1 ee 03 49 01 ec 49 01 ee e8 57 61 9c ff 41 80 3c 24 00 0f 85 9b 09 00 00 4d 8b af b8 01 00 00 4c 89 e8 48 c1 e8 03 <80> 3c 28 00 0f 85 76 09 00 00 49 8b 55 00 89 d8 c1 f8 09 48 98 4c
RSP: 0018:ffffc90009137d68 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffffc9000ef2a000
RDX: 0000000000040000 RSI: ffffffff81d81dd9 RDI: 0000000000000005
RBP: dffffc0000000000 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffed1012882a37
R13: 0000000000000000 R14: ffffed1012882a38 R15: ffff888094415000
FS:  00007f4266f3c700(0000) GS:ffff8880ae500000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000118c000 CR3: 000000008e57d000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45de59
Code: 0d b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 db b3 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f4266f3bc78 EFLAGS: 00000246 ORIG_RAX: 00000000000001ab
RAX: ffffffffffffffda RBX: 00000000000083c0 RCX: 000000000045de59
RDX: 0000000020000280 RSI: 0000000000000002 RDI: 0000000000000005
RBP: 000000000118bf68 R08: 0000000000000000 R09: 0000000000000000
R10: 40000000000000a1 R11: 0000000000000246 R12: 000000000118bf2c
R13: 00007fff2fa4f12f R14: 00007f4266f3c9c0 R15: 000000000118bf2c
Modules linked in:
---[ end trace 2a40a195e2d5e6e6 ]---
RIP: 0010:io_file_from_index fs/io_uring.c:5963 [inline]
RIP: 0010:io_sqe_files_register fs/io_uring.c:7369 [inline]
RIP: 0010:__io_uring_register fs/io_uring.c:9463 [inline]
RIP: 0010:__do_sys_io_uring_register+0x2fd2/0x3ee0 fs/io_uring.c:9553
Code: ec 03 49 c1 ee 03 49 01 ec 49 01 ee e8 57 61 9c ff 41 80 3c 24 00 0f 85 9b 09 00 00 4d 8b af b8 01 00 00 4c 89 e8 48 c1 e8 03 <80> 3c 28 00 0f 85 76 09 00 00 49 8b 55 00 89 d8 c1 f8 09 48 98 4c
RSP: 0018:ffffc90009137d68 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffffc9000ef2a000
RDX: 0000000000040000 RSI: ffffffff81d81dd9 RDI: 0000000000000005
RBP: dffffc0000000000 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffed1012882a37
R13: 0000000000000000 R14: ffffed1012882a38 R15: ffff888094415000
FS:  00007f4266f3c700(0000) GS:ffff8880ae400000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000074a918 CR3: 000000008e57d000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
