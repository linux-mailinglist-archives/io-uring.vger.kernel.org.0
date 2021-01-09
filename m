Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9490A2F017C
	for <lists+io-uring@lfdr.de>; Sat,  9 Jan 2021 17:28:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726504AbhAIQ2P (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 9 Jan 2021 11:28:15 -0500
Received: from mail-io1-f71.google.com ([209.85.166.71]:35793 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725978AbhAIQ2E (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 9 Jan 2021 11:28:04 -0500
Received: by mail-io1-f71.google.com with SMTP id a1so10123336ios.2
        for <io-uring@vger.kernel.org>; Sat, 09 Jan 2021 08:27:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=dVaLjIzyuJ0IlWE1M+hdDEBSon/4QDEoUFhuTYAoyBY=;
        b=QghbioG4XyTHUvflFxX1DZbAddJOkQ2P1WO9etp2yhUqvY+D8rTY1dY3YthBrtHX5Z
         MnljaFaVs1prve+H8k3ZwjJTg2VBp9N3/CcWthr8BLHLO9AcUaLwr0wtSspry6lmEzI/
         ew49oHT0COCyanaUMfg17xU6Gpa4XB4LICt+KkMKBiBBYDobutC6ISontRK4bTYrBKF9
         q/yA/cR2uGMEnYQEpl3JHTQaRQ2vWSg0E9sXU9jl2ZiFpoCSkzTwVcPEEHz1OYSKV9pj
         paEz9uGyRnXHRvFeXwVys8kW6Z9aXpgu9ImlOJM0AwfPWNCfqe04MN5xgIqTF1tiLIZ+
         gJXQ==
X-Gm-Message-State: AOAM533rB+6zb/2KA5UTCYH8sag+3rkwF6BNVB/qdKdRAXqTV3oVQ+Gb
        9huxHmIqEaK1FEfkIEpOLe8dNyuDJfUjahM9D10VZ7fXGbKS
X-Google-Smtp-Source: ABdhPJy3Xl/EoqJBjWqXZRQBBKOPUcbmEKkuzKWk+JCzM+kH8g3QlayNFKTev/vSVR9KBo6UgIMQAOdEEyP6/FqbXMHeUK4MtkSW
MIME-Version: 1.0
X-Received: by 2002:a92:cec4:: with SMTP id z4mr8992518ilq.217.1610209643452;
 Sat, 09 Jan 2021 08:27:23 -0800 (PST)
Date:   Sat, 09 Jan 2021 08:27:23 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000cfdf1c05b87a25e8@google.com>
Subject: BUG: unable to handle kernel paging request in percpu_ref_exit
From:   syzbot <syzbot+99ed55100402022a6276@syzkaller.appspotmail.com>
To:     axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@kernel.org, mingo@redhat.com, peterz@infradead.org,
        rostedt@goodmis.org, syzkaller-bugs@googlegroups.com,
        viro@zeniv.linux.org.uk, will@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    36bbbd0e Merge branch 'rcu/urgent' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=149afeeb500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8aa30b9da402d224
dashboard link: https://syzkaller.appspot.com/bug?extid=99ed55100402022a6276
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10496f70d00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10cedf70d00000

The issue was bisected to:

commit 4d004099a668c41522242aa146a38cc4eb59cb1e
Author: Peter Zijlstra <peterz@infradead.org>
Date:   Fri Oct 2 09:04:21 2020 +0000

    lockdep: Fix lockdep recursion

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=106238f7500000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=126238f7500000
console output: https://syzkaller.appspot.com/x/log.txt?x=146238f7500000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+99ed55100402022a6276@syzkaller.appspotmail.com
Fixes: 4d004099a668 ("lockdep: Fix lockdep recursion")

RBP: 0000000000000005 R08: 0000000000000001 R09: 0000000000401140
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000402860
R13: 00000000004028f0 R14: 0000000000000000 R15: 0000000000000000
BUG: unable to handle page fault for address: fffffffffffffffc
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD b08f067 P4D b08f067 PUD b091067 PMD 0 
Oops: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 8500 Comm: syz-executor191 Not tainted 5.11.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:percpu_ref_exit+0x2f/0x140 lib/percpu-refcount.c:130
Code: 54 55 53 48 89 fb e8 f0 fc b6 fd 48 8d 6b 08 48 b8 00 00 00 00 00 fc ff df 48 89 ea 48 c1 ea 03 80 3c 02 00 0f 85 d5 00 00 00 <4c> 8b 73 08 48 89 df e8 c5 fe ff ff 4d 85 f6 0f 84 b3 00 00 00 e8
RSP: 0018:ffffc9000126fcc8 EFLAGS: 00010246
RAX: dffffc0000000000 RBX: fffffffffffffff4 RCX: 0000000000000000
RDX: 1fffffffffffffff RSI: ffffffff83bb78b0 RDI: fffffffffffffff4
RBP: fffffffffffffffc R08: 0000000000000001 R09: ffffffff8ebda867
R10: fffffbfff1d7b50c R11: 0000000000000000 R12: 0000000000000000
R13: ffff88801adee000 R14: 0000000000000002 R15: fffffffffffffff4
FS:  000000000179f940(0000) GS:ffff8880b9e00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffffffffffffc CR3: 0000000020270000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 destroy_fixed_file_ref_node fs/io_uring.c:7703 [inline]
 io_sqe_files_unregister+0x30b/0x770 fs/io_uring.c:7293
 __io_uring_register fs/io_uring.c:9916 [inline]
 __do_sys_io_uring_register+0x1185/0x4080 fs/io_uring.c:10000
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x444df9
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 db d5 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffeb192ade8 EFLAGS: 00000246 ORIG_RAX: 00000000000001ab
RAX: ffffffffffffffda RBX: 00007ffeb192ae90 RCX: 0000000000444df9
RDX: 0000000000000000 RSI: 0000000000000003 RDI: 0000000000000004
RBP: 0000000000000005 R08: 0000000000000001 R09: 0000000000401140
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000402860
R13: 00000000004028f0 R14: 0000000000000000 R15: 0000000000000000
Modules linked in:
CR2: fffffffffffffffc
---[ end trace ed34d5d65a155c02 ]---
RIP: 0010:percpu_ref_exit+0x2f/0x140 lib/percpu-refcount.c:130
Code: 54 55 53 48 89 fb e8 f0 fc b6 fd 48 8d 6b 08 48 b8 00 00 00 00 00 fc ff df 48 89 ea 48 c1 ea 03 80 3c 02 00 0f 85 d5 00 00 00 <4c> 8b 73 08 48 89 df e8 c5 fe ff ff 4d 85 f6 0f 84 b3 00 00 00 e8
RSP: 0018:ffffc9000126fcc8 EFLAGS: 00010246
RAX: dffffc0000000000 RBX: fffffffffffffff4 RCX: 0000000000000000
RDX: 1fffffffffffffff RSI: ffffffff83bb78b0 RDI: fffffffffffffff4
RBP: fffffffffffffffc R08: 0000000000000001 R09: ffffffff8ebda867
R10: fffffbfff1d7b50c R11: 0000000000000000 R12: 0000000000000000
R13: ffff88801adee000 R14: 0000000000000002 R15: fffffffffffffff4
FS:  000000000179f940(0000) GS:ffff8880b9e00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffffffffffffc CR3: 0000000020270000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
