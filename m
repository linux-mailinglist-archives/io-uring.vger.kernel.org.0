Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74ACC267BCB
	for <lists+io-uring@lfdr.de>; Sat, 12 Sep 2020 20:49:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725880AbgILSta (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 12 Sep 2020 14:49:30 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:44047 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725875AbgILSt1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 12 Sep 2020 14:49:27 -0400
Received: by mail-il1-f197.google.com with SMTP id j11so9550798ilr.11
        for <io-uring@vger.kernel.org>; Sat, 12 Sep 2020 11:49:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=z5R//UxRboItQPh7MDI3JddIQL61MajQx6warYtOYbk=;
        b=lHEkDrXn0qo70XG2RqHIrCiImIejcI2wr4OJnqMaCwDz50Tbpz1A0/CF30VZH8lwY1
         JCYd3+A1gdwoDkgbLaIqdr0QGPwt1Scg4nlr8cwFPrkHPvNAEnDsZkZE+cwQ8ILBIVEw
         pQIscl0YAoKfLY3mGxF6HfFVkopLqqX2y9vHXgOtEo12mBSny0p38ZPGDD0p92pKpUmp
         7bwvcigys+tpJtuL9kwT/5z8QrKMaKFpKvYbGBjdF6N+YKiNS2U5Zn0tJFRM0WC3TVdL
         TwMev50GfnOOR2mGcOtfVeiXEsMn/uQW4ZOlfBTYnDhZNjBqVeGxtLQNuDylMRxPqCxy
         BA/A==
X-Gm-Message-State: AOAM530wGWtXsxnOkXCtoBeCvr4SDHMQNhCWCFgtWYlDXyBvd5jVzbtk
        6nN8K2tXevhLAJVsDhGMgNrnrPq4etylPefFMkmKvzqzeEmT
X-Google-Smtp-Source: ABdhPJxSw+rGOoF525+CoZRVY7+xls38p9IS6yfSueGw6LmNHJqJuQICeDB3rXspXnSC3chEEdehPq/J6p1+ACim7BWVBTjAPkmR
MIME-Version: 1.0
X-Received: by 2002:a02:c914:: with SMTP id t20mr6965290jao.117.1599936566237;
 Sat, 12 Sep 2020 11:49:26 -0700 (PDT)
Date:   Sat, 12 Sep 2020 11:49:26 -0700
In-Reply-To: <0000000000004ba2fe05aebfc526@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b1a2f805af224224@google.com>
Subject: Re: WARNING: refcount bug in io_wqe_worker
From:   syzbot <syzbot+956ef5eac18eadd0fb7f@syzkaller.appspotmail.com>
To:     anant.thazhemadam@gmail.com, asml.silence@gmail.com,
        axboe@kernel.dk, hdanton@sina.com, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    729e3d09 Merge tag 'ceph-for-5.9-rc5' of git://github.com/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12f2ce0d900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c61610091f4ca8c4
dashboard link: https://syzkaller.appspot.com/bug?extid=956ef5eac18eadd0fb7f
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10f3a853900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=157f7263900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+956ef5eac18eadd0fb7f@syzkaller.appspotmail.com

------------[ cut here ]------------
refcount_t: underflow; use-after-free.
WARNING: CPU: 0 PID: 7382 at lib/refcount.c:28 refcount_warn_saturate+0x1d1/0x1e0 lib/refcount.c:28
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 7382 Comm: io_wqe_worker-1 Not tainted 5.9.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x198/0x1fd lib/dump_stack.c:118
 panic+0x347/0x7c0 kernel/panic.c:231
 __warn.cold+0x20/0x46 kernel/panic.c:600
 report_bug+0x1bd/0x210 lib/bug.c:198
 handle_bug+0x38/0x90 arch/x86/kernel/traps.c:234
 exc_invalid_op+0x14/0x40 arch/x86/kernel/traps.c:254
 asm_exc_invalid_op+0x12/0x20 arch/x86/include/asm/idtentry.h:536
RIP: 0010:refcount_warn_saturate+0x1d1/0x1e0 lib/refcount.c:28
Code: e9 db fe ff ff 48 89 df e8 2c dd 18 fe e9 8a fe ff ff e8 c2 d6 d8 fd 48 c7 c7 60 dc 93 88 c6 05 0d 0d 12 07 01 e8 b1 d7 a9 fd <0f> 0b e9 af fe ff ff 0f 1f 84 00 00 00 00 00 41 56 41 55 41 54 55
RSP: 0018:ffffc9000810fe08 EFLAGS: 00010286
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff88809592a200 RSI: ffffffff815db9a7 RDI: fffff52001021fb3
RBP: 0000000000000003 R08: 0000000000000001 R09: ffff8880ae6318e7
R10: 0000000000000000 R11: 0000000000000000 R12: ffff88809a6080b8
R13: ffff8880a7896e30 R14: ffff8880a7896e00 R15: ffff8880a6727f00
 refcount_sub_and_test include/linux/refcount.h:274 [inline]
 refcount_dec_and_test include/linux/refcount.h:294 [inline]
 io_worker_exit fs/io-wq.c:236 [inline]
 io_wqe_worker+0xcdb/0x10e0 fs/io-wq.c:596
 kthread+0x3b5/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
Kernel Offset: disabled
Rebooting in 86400 seconds..

