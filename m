Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85E54260633
	for <lists+io-uring@lfdr.de>; Mon,  7 Sep 2020 23:19:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726918AbgIGVTt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 7 Sep 2020 17:19:49 -0400
Received: from mail-il1-f208.google.com ([209.85.166.208]:44886 "EHLO
        mail-il1-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727114AbgIGVTQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 7 Sep 2020 17:19:16 -0400
Received: by mail-il1-f208.google.com with SMTP id j11so10575493ilr.11
        for <io-uring@vger.kernel.org>; Mon, 07 Sep 2020 14:19:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=EwRjuQ9atzJc/71khL9ziMZwpDz6RNRGvAyJm8uh71s=;
        b=T7fKR3xZkZmDrTC7K4QR8mlI/9kMCohZFpVMgrtCsVOCbXLNsWN871fuB3NUpxKa0u
         29XmAMQEZOKSny1+Zaefeh/5l1ICDZ3vv1hpoBOMOCDyDZvWJZ3wG3vLu8MGKfs00bSF
         f3kNkPrLF323C+wvgnqhcS69OqDyj5Et/L8c7DNW/KpI/RDd6XX/kejqE+M+r52+lM3E
         80el/iLYasQ0BtE7ob9HyB+j4MkIrd1yR9cnzHb19GS99JRmFs3F9g8NqsdMiLVluWzB
         id+IasvPTMnsnmn5JRPNS2JUaPIpZdDsrAdDX2wu9eUJE+Swua08CVG8qiPfTbQHHWix
         vB4g==
X-Gm-Message-State: AOAM531EEzuLcnlYUi5YPnEROdpfZK6Z3+URxawJ5e+r2CD6RwnkQY0+
        5P+VZu9i61nNPFatKVb7DqAYhqzAfZJ/DxakE3fFErQsyQP1
X-Google-Smtp-Source: ABdhPJy3NU8sEs7fFpd4pmftyPSS7r9qTsau1MWj3URpOD9bGFaw2zbLzfh7RBlUXCy1NDUr2aO7ZAJ06IOJclihoRRz3T7P8IsF
MIME-Version: 1.0
X-Received: by 2002:a5d:9ed3:: with SMTP id a19mr18703897ioe.28.1599513555606;
 Mon, 07 Sep 2020 14:19:15 -0700 (PDT)
Date:   Mon, 07 Sep 2020 14:19:15 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000004ba2fe05aebfc526@google.com>
Subject: WARNING: refcount bug in io_wqe_worker
From:   syzbot <syzbot+956ef5eac18eadd0fb7f@syzkaller.appspotmail.com>
To:     axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    7a695657 Add linux-next specific files for 20200903
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=152eff5d900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=39134fcec6c78e33
dashboard link: https://syzkaller.appspot.com/bug?extid=956ef5eac18eadd0fb7f
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1086a1a5900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+956ef5eac18eadd0fb7f@syzkaller.appspotmail.com

------------[ cut here ]------------
refcount_t: underflow; use-after-free.
WARNING: CPU: 1 PID: 12241 at lib/refcount.c:28 refcount_warn_saturate+0x1d1/0x1e0 lib/refcount.c:28
Modules linked in:
CPU: 1 PID: 12241 Comm: io_wqe_worker-1 Not tainted 5.9.0-rc3-next-20200903-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:refcount_warn_saturate+0x1d1/0x1e0 lib/refcount.c:28
Code: e9 db fe ff ff 48 89 df e8 dc 7e 17 fe e9 8a fe ff ff e8 02 0a d7 fd 48 c7 c7 00 2a 94 88 c6 05 b5 e2 19 07 01 e8 aa 7c a7 fd <0f> 0b e9 af fe ff ff 0f 1f 84 00 00 00 00 00 41 56 41 55 41 54 55
RSP: 0018:ffffc90009117e08 EFLAGS: 00010286
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff88809d63a340 RSI: ffffffff815dbe97 RDI: fffff52001222fb3
RBP: 0000000000000003 R08: 0000000000000001 R09: ffff8880ae720f8b
R10: 0000000000000000 R11: 0000000000000000 R12: ffff8880934e10b8
R13: ffff8880a8a63530 R14: ffff8880a8a63500 R15: ffff8880a7ebfa00
FS:  0000000000000000(0000) GS:ffff8880ae600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000004e47b0 CR3: 0000000097f7c000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 refcount_sub_and_test include/linux/refcount.h:274 [inline]
 refcount_dec_and_test include/linux/refcount.h:294 [inline]
 io_worker_exit fs/io-wq.c:236 [inline]
 io_wqe_worker+0xcdb/0x10e0 fs/io-wq.c:596
 kthread+0x3b5/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
Kernel panic - not syncing: panic_on_warn set ...
CPU: 1 PID: 12241 Comm: io_wqe_worker-1 Tainted: G    B             5.9.0-rc3-next-20200903-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x198/0x1fd lib/dump_stack.c:118
 panic+0x347/0x7c0 kernel/panic.c:231
 __warn.cold+0x38/0xbd kernel/panic.c:605
 report_bug+0x1bd/0x210 lib/bug.c:198
 handle_bug+0x38/0x90 arch/x86/kernel/traps.c:234
 exc_invalid_op+0x14/0x40 arch/x86/kernel/traps.c:254
 asm_exc_invalid_op+0x12/0x20 arch/x86/include/asm/idtentry.h:536
RIP: 0010:refcount_warn_saturate+0x1d1/0x1e0 lib/refcount.c:28
Code: e9 db fe ff ff 48 89 df e8 dc 7e 17 fe e9 8a fe ff ff e8 02 0a d7 fd 48 c7 c7 00 2a 94 88 c6 05 b5 e2 19 07 01 e8 aa 7c a7 fd <0f> 0b e9 af fe ff ff 0f 1f 84 00 00 00 00 00 41 56 41 55 41 54 55
RSP: 0018:ffffc90009117e08 EFLAGS: 00010286
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff88809d63a340 RSI: ffffffff815dbe97 RDI: fffff52001222fb3
RBP: 0000000000000003 R08: 0000000000000001 R09: ffff8880ae720f8b
R10: 0000000000000000 R11: 0000000000000000 R12: ffff8880934e10b8
R13: ffff8880a8a63530 R14: ffff8880a8a63500 R15: ffff8880a7ebfa00
 refcount_sub_and_test include/linux/refcount.h:274 [inline]
 refcount_dec_and_test include/linux/refcount.h:294 [inline]
 io_worker_exit fs/io-wq.c:236 [inline]
 io_wqe_worker+0xcdb/0x10e0 fs/io-wq.c:596
 kthread+0x3b5/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
