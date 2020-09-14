Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C9A4268882
	for <lists+io-uring@lfdr.de>; Mon, 14 Sep 2020 11:34:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbgINJea (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Sep 2020 05:34:30 -0400
Received: from mail-io1-f77.google.com ([209.85.166.77]:40263 "EHLO
        mail-io1-f77.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726353AbgINJeV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Sep 2020 05:34:21 -0400
Received: by mail-io1-f77.google.com with SMTP id f8so10621533iow.7
        for <io-uring@vger.kernel.org>; Mon, 14 Sep 2020 02:34:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=E/QTzBsB9NrbrnyD5JfbMzAIiLjuZEKI1ZQTWSSXoa4=;
        b=aQXRIfBriHHlRa38AmStflvDxsZCMq3/R2GG/UFvbKcQuw+mCYn2nZIikjOl6YtPjW
         sLsejO1JNVOOQYA6teCW57luO1NCvPD3NQSVAse6B9XhfMVjsOy0stpLulTNPwXuvkBX
         6O9wp91vDUtrYEjACYRp3KEeRK9dj3Cb0fmsnzKjVYk8IybtINrUwaM/CbBWhYvo03rl
         QmzeL3LAnQLSeasYgHpZAaKkwm/PkHMbcMntOMZ9ymjDDqV8KLhnM3oMSwb7AUp7JxyV
         znd0x/sfIpYDQleXTg6jvcYOawzkGnmMgHqPEuwszFYm8pnm8EW/Fr6k9hokrzxiH5dL
         GruQ==
X-Gm-Message-State: AOAM532xJjabXZCdd8XnhsK5GUkCVGthHdYgAN8dSafbwiP4prYc2ii4
        R3SBlOX6oN7H81wakMZ67HMSIpMcYWn1VWDtfn7NKzE9zRGA
X-Google-Smtp-Source: ABdhPJz7iG02x/zNqSUBW/Ko76Ck8RPpcBpoX+83zp085P7Df7QS5p4V+Nb+NblkkR5CVY6nPVm0/N466WJViD3aaddPvibh3/fO
MIME-Version: 1.0
X-Received: by 2002:a05:6638:134b:: with SMTP id u11mr12503383jad.18.1600076059963;
 Mon, 14 Sep 2020 02:34:19 -0700 (PDT)
Date:   Mon, 14 Sep 2020 02:34:19 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002af53f05af42bd63@google.com>
Subject: WARNING: refcount bug in io_worker_exit
From:   syzbot <syzbot+c4934d8fed67bdb3b763@syzkaller.appspotmail.com>
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

HEAD commit:    e4c26faa Merge tag 'usb-5.9-rc5' of git://git.kernel.org/p..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1717bb21900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8f5c353182ed6199
dashboard link: https://syzkaller.appspot.com/bug?extid=c4934d8fed67bdb3b763
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c4934d8fed67bdb3b763@syzkaller.appspotmail.com

------------[ cut here ]------------
refcount_t: underflow; use-after-free.
WARNING: CPU: 0 PID: 714 at lib/refcount.c:28 refcount_warn_saturate+0x15b/0x1a0 lib/refcount.c:28
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 714 Comm: io_wqe_worker-1 Not tainted 5.9.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1d6/0x29e lib/dump_stack.c:118
 panic+0x2c0/0x800 kernel/panic.c:231
 __warn+0x227/0x250 kernel/panic.c:600
 report_bug+0x1b1/0x2e0 lib/bug.c:198
 handle_bug+0x42/0x80 arch/x86/kernel/traps.c:234
 exc_invalid_op+0x16/0x40 arch/x86/kernel/traps.c:254
 asm_exc_invalid_op+0x12/0x20 arch/x86/include/asm/idtentry.h:536
RIP: 0010:refcount_warn_saturate+0x15b/0x1a0 lib/refcount.c:28
Code: c7 3a 98 15 89 31 c0 e8 43 21 a6 fd 0f 0b eb 85 e8 aa 82 d4 fd c6 05 16 6b ea 05 01 48 c7 c7 66 98 15 89 31 c0 e8 25 21 a6 fd <0f> 0b e9 64 ff ff ff e8 89 82 d4 fd c6 05 f6 6a ea 05 01 48 c7 c7
RSP: 0018:ffffc90008e7fdb8 EFLAGS: 00010246
RAX: 4ee61c65d7036100 RBX: 0000000000000003 RCX: ffff8880934bc2c0
RDX: 0000000000000000 RSI: 0000000080000000 RDI: 0000000000000000
RBP: 0000000000000003 R08: ffffffff815e3810 R09: ffffed1015d062c0
R10: ffffed1015d062c0 R11: 0000000000000000 R12: ffff88809fbb50b8
R13: dffffc0000000000 R14: ffff88809e8a2400 R15: ffff8880a6179330
 refcount_sub_and_test include/linux/refcount.h:274 [inline]
 refcount_dec_and_test include/linux/refcount.h:294 [inline]
 io_worker_exit+0x63f/0x750 fs/io-wq.c:236
 io_wqe_worker+0x799/0x810 fs/io-wq.c:596
 kthread+0x37e/0x3a0 drivers/block/aoe/aoecmd.c:1234
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
