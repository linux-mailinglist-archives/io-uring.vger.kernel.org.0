Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50BF9440727
	for <lists+io-uring@lfdr.de>; Sat, 30 Oct 2021 05:58:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbhJ3EAn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 30 Oct 2021 00:00:43 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:49784 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbhJ3EAm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 30 Oct 2021 00:00:42 -0400
Received: by mail-io1-f72.google.com with SMTP id l17-20020a05660227d100b005d6609eb90eso8179016ios.16
        for <io-uring@vger.kernel.org>; Fri, 29 Oct 2021 20:58:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=NxrKfv/XUeAiqCmDWtg9RMNFjn6j9DuSj8uFrnjfaB0=;
        b=HLEhDnjPTdvGpgTYSWHScZFcR6sLdXpfmIh3aTuxTjzY3VOd/8Otqm9bdao4jPsmLe
         54PWVvRVhfsZdYNxJ3ErFQqZ32scuKG29zg583nKULQZ34F4tatHjCSjYwk/aorbFawg
         isoAzC+ZU1MkTpSnwNddKcBSP+pcLkITaWQ4jgQ/krQ++aYvGrEjy34l2y5B8WfjoXxH
         2jwSbyU+C6hkUk5Trjf3dvzsCmF7i9CvqTM/Dh79Z5Y2VLGSwRFsMvOKBRBzobGLUrpB
         ljAgZuKMJ2JghFjdndC4MA8RWPYBpu4Eg6Oaqgz46wx3+CoR9X6oHKw/WD18mK+JNtHT
         Lagg==
X-Gm-Message-State: AOAM530ksV7MsI46xfNaWF9UKRPAXCZ88ujoCUo6gEM702/O5tNDAoGq
        2Em0H3cVQI881ZlrAlCr4qRN6kuDZcR4CBPQlLTsxveitXty
X-Google-Smtp-Source: ABdhPJy7n2A6fdVP1NqMzxx3//B/WNmefgMySnMxpGoYktdTWi2EFnJ0i3OTadvCBVovbWDV3X5ohd8DFyzToc0wqh2tTqwg5eQX
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:b43:: with SMTP id f3mr10784790ilu.194.1635566293237;
 Fri, 29 Oct 2021 20:58:13 -0700 (PDT)
Date:   Fri, 29 Oct 2021 20:58:13 -0700
In-Reply-To: <cebb75d5-076d-0b05-6c37-b880accc320e@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ea455405cf89f33d@google.com>
Subject: Re: [syzbot] KASAN: use-after-free Write in __io_free_req
From:   syzbot <syzbot+78b76ebc91042904f34e@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
WARNING: refcount bug in delayed_put_task_struct

------------[ cut here ]------------
refcount_t: underflow; use-after-free.
WARNING: CPU: 1 PID: 19 at lib/refcount.c:28 refcount_warn_saturate+0x1d1/0x1e0 lib/refcount.c:28
Modules linked in:
CPU: 1 PID: 19 Comm: ksoftirqd/1 Not tainted 5.15.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:refcount_warn_saturate+0x1d1/0x1e0 lib/refcount.c:28
Code: e9 db fe ff ff 48 89 df e8 7c aa 1a fe e9 8a fe ff ff e8 92 6c d3 fd 48 c7 c7 80 bb be 89 c6 05 95 a4 8d 09 01 e8 5b 36 19 05 <0f> 0b e9 af fe ff ff 0f 1f 84 00 00 00 00 00 41 56 41 55 41 54 55
RSP: 0018:ffffc90000d97d00 EFLAGS: 00010282
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff888011af5580 RSI: ffffffff815e8868 RDI: fffff520001b2f92
RBP: 0000000000000003 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff815e260e R11: 0000000000000000 R12: ffff888071c45580
R13: ffff888071c455a8 R14: 0000000000000004 R15: ffff888071c46a50
FS:  0000000000000000(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fe200c24218 CR3: 000000006f2d8000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 __refcount_sub_and_test include/linux/refcount.h:283 [inline]
 __refcount_dec_and_test include/linux/refcount.h:315 [inline]
 refcount_dec_and_test include/linux/refcount.h:333 [inline]
 put_task_struct include/linux/sched/task.h:112 [inline]
 delayed_put_task_struct+0x2e3/0x340 kernel/exit.c:172
 rcu_do_batch kernel/rcu/tree.c:2508 [inline]
 rcu_core+0x7ab/0x1470 kernel/rcu/tree.c:2743
 __do_softirq+0x29b/0x9c2 kernel/softirq.c:558
 run_ksoftirqd kernel/softirq.c:920 [inline]
 run_ksoftirqd+0x2d/0x60 kernel/softirq.c:912
 smpboot_thread_fn+0x645/0x9c0 kernel/smpboot.c:164
 kthread+0x3e5/0x4d0 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295


Tested on:

commit:         3ecd20a9 io-wq: remove worker to owner tw dependency
git tree:       https://github.com/isilence/linux.git syz-test-iofree
console output: https://syzkaller.appspot.com/x/log.txt?x=160209d4b00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=10c050a45aafafcc
dashboard link: https://syzkaller.appspot.com/bug?extid=78b76ebc91042904f34e
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

