Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1B253705C7
	for <lists+io-uring@lfdr.de>; Sat,  1 May 2021 07:52:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231695AbhEAFwK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 1 May 2021 01:52:10 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:37587 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231739AbhEAFwI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 1 May 2021 01:52:08 -0400
Received: by mail-il1-f199.google.com with SMTP id q2-20020a056e0220e2b0290150996f2750so399088ilv.4
        for <io-uring@vger.kernel.org>; Fri, 30 Apr 2021 22:51:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=dAtoNwPD7FCF677AGpToLr51wbvur/5fNAZn5Ya0mW8=;
        b=ucI3LrB56p4vCXue353RNieuICzJ1KSP1XRLPsIPjvndjJWSNy8IXb8VSASFIcBPAI
         RbjVq8wZyXl8iUe1nkoWyCKobL6mZmQymT6zHy8UJjEjH3cLibdh+d7vx52tDABM46WK
         qtLIiUydmsCy2LsRvMrf04WFGdC6kDjN05mWLw/CrpwIE0YVM0JD3FjlQnNkv0FnU1ih
         kpaSG4+Qca6wivGHMenMDmjRIhk2K05gI4MjG5Q3acyp1MG/58HrxN4zCojPn9AF/2sS
         xhuufk40UhJwt+zgFkX+ZT9JlqjDx9mxef3Pc6FLMrywIMoPgjcn/wp4qAjFMKLCLFHF
         MMVw==
X-Gm-Message-State: AOAM531G+T8Q+X8qF1lTMBk3DmHh2Ay4uQ6EG4OSGLgGBSFSzVszTS6J
        gjM6TgOfpqIt7CsRmk/WyHWDmhvLkf8NEUEpdRbzrloQ5Vr0
X-Google-Smtp-Source: ABdhPJwXIG82/d2Q8uOyVXJvuhpdm0Za7/yPa8xvd+6E620WPkeTofOL8AhlNblUhTCa8UoCZnj7MAxHLP9G+vDbUSlKkcNA+xcu
MIME-Version: 1.0
X-Received: by 2002:a02:ca45:: with SMTP id i5mr8156252jal.118.1619848276068;
 Fri, 30 Apr 2021 22:51:16 -0700 (PDT)
Date:   Fri, 30 Apr 2021 22:51:16 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000015ce3005c13e512a@google.com>
Subject: [syzbot] WARNING: refcount bug in __io_queue_sqe
From:   syzbot <syzbot+a2910119328ce8e7996f@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    16fc44d6 Merge tag 'mmc-v5.12-rc5' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1450f471d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c0a6882014fd3d45
dashboard link: https://syzkaller.appspot.com/bug?extid=a2910119328ce8e7996f
compiler:       Debian clang version 11.0.1-2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+a2910119328ce8e7996f@syzkaller.appspotmail.com

------------[ cut here ]------------
refcount_t: underflow; use-after-free.
WARNING: CPU: 0 PID: 10242 at lib/refcount.c:28 refcount_warn_saturate+0x15b/0x1a0 lib/refcount.c:28
Modules linked in:
CPU: 0 PID: 10242 Comm: syz-executor.2 Not tainted 5.12.0-rc8-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:refcount_warn_saturate+0x15b/0x1a0 lib/refcount.c:28
Code: c7 20 5a 71 8a 31 c0 e8 23 03 55 fd 0f 0b eb 85 e8 9a a0 88 fd c6 05 44 db 0b 0a 01 48 c7 c7 80 5a 71 8a 31 c0 e8 05 03 55 fd <0f> 0b e9 64 ff ff ff e8 79 a0 88 fd c6 05 24 db 0b 0a 01 48 c7 c7
RSP: 0018:ffffc90002e77928 EFLAGS: 00010246
RAX: 15eb98be5e94ee00 RBX: 0000000000000003 RCX: 0000000000040000
RDX: ffffc9000d56a000 RSI: 0000000000006606 RDI: 0000000000006607
RBP: 0000000000000003 R08: ffffffff8164f2f2 R09: ffffed1017383f1c
R10: ffffed1017383f1c R11: 0000000000000000 R12: dffffc0000000000
R13: ffff8881412ea608 R14: 00000000ffffffff R15: ffff888013dd9cdc
FS:  00007ffb95ca5700(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffffd5a8690 CR3: 0000000023ce1000 CR4: 00000000001526e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 __refcount_sub_and_test include/linux/refcount.h:283 [inline]
 __refcount_dec_and_test include/linux/refcount.h:315 [inline]
 refcount_dec_and_test include/linux/refcount.h:333 [inline]
 io_put_req fs/io_uring.c:2140 [inline]
 io_queue_linked_timeout fs/io_uring.c:6300 [inline]
 __io_queue_sqe+0xbef/0xec0 fs/io_uring.c:6354
 io_submit_sqe fs/io_uring.c:6534 [inline]
 io_submit_sqes+0x2bbd/0x7c50 fs/io_uring.c:6660
 __do_sys_io_uring_enter fs/io_uring.c:9240 [inline]
 __se_sys_io_uring_enter+0x256/0x1d60 fs/io_uring.c:9182
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x466459
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffb95ca5188 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
RAX: ffffffffffffffda RBX: 000000000056bf60 RCX: 0000000000466459
RDX: 0000000000000000 RSI: 00000000000055bc RDI: 0000000000000003
RBP: 00000000004bf9fb R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056bf60
R13: 00007ffcaf4241ff R14: 00007ffb95ca5300 R15: 0000000000022000


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
