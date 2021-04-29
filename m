Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0401036E8CB
	for <lists+io-uring@lfdr.de>; Thu, 29 Apr 2021 12:32:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240407AbhD2KdI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 29 Apr 2021 06:33:08 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:35398 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234709AbhD2KdG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 29 Apr 2021 06:33:06 -0400
Received: by mail-il1-f198.google.com with SMTP id x7-20020a056e021ca7b029016344dffb7bso34733293ill.2
        for <io-uring@vger.kernel.org>; Thu, 29 Apr 2021 03:32:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=Xjux6uWK6HqdmpxJpDGqjp9kZ+TR4joypvkzTViX7DI=;
        b=IBwaDpTXMOEYPrMUTFNQe4X8NJsT5VnOb5XNIFWIdFzx6jAIq64F2ZOvMWt1VKKyUt
         UHaorK2ecdwwEVDGae5MEYEp2oYV2QVlOsL7M34WMX98nrV6MIXzg3py9gA8hc5P5VY9
         gv4h6TqTmzPx1rlHPlndZ383UaF68kaJ7EoYdFvL4bvGnwFLXsoUiAuhmUkwnCFe3nd0
         nC58jpugJv7BYb6OwcFzvDO+Xbot6g9Fpz+44E2/xdXn55WX0bV8ETh//Dqs3Mt9gg50
         u24tKeqOcnrSqKktqujwA2ZAGRog9ndr/qXwWk6RDznSBvidIyxgVG0xYpRiJHzFQXWJ
         FeSQ==
X-Gm-Message-State: AOAM533/aKshYBgQ53vkat+AOqLdxwpmfUHUD5j11mgCEfKLYy8R1/PI
        lkRnS8dlp+OYyhVT93V/Lk54ibjW6UyP+Plr0eflsX0TslXv
X-Google-Smtp-Source: ABdhPJyZjWbQtEkf2xY7hcOB3Dro/TE+xgj6LrBMSfJyp59pKJsdAAnaHNHlAcuIug/tzd32Oe0Qh2vi9ENCinEEU5XNIxHynFUK
MIME-Version: 1.0
X-Received: by 2002:a6b:8e93:: with SMTP id q141mr978723iod.6.1619692339721;
 Thu, 29 Apr 2021 03:32:19 -0700 (PDT)
Date:   Thu, 29 Apr 2021 03:32:19 -0700
In-Reply-To: <000000000000b23f7805c119dee8@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000008dfbaf05c11a023c@google.com>
Subject: Re: [syzbot] WARNING in io_rsrc_node_switch
From:   syzbot <syzbot+a4715dd4b7c866136f79@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    d72cd4ad Merge tag 'scsi-misc' of git://git.kernel.org/pub..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12c045d5d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=65c207250bba4efe
dashboard link: https://syzkaller.appspot.com/bug?extid=a4715dd4b7c866136f79
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11893de1d00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=161c19d5d00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+a4715dd4b7c866136f79@syzkaller.appspotmail.com

RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 0000000000440a49
RDX: 0000000000000010 RSI: 00000000200002c0 RDI: 0000000000000182
RBP: 00007fff0b88f050 R08: 0000000000000001 R09: 00007fff0b88f038
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000003
R13: 00007fff0b88f03a R14: 00000000004b74b0 R15: 000000000000000c
------------[ cut here ]------------
WARNING: CPU: 0 PID: 8397 at fs/io_uring.c:7081 io_rsrc_node_switch+0x2a5/0x390 fs/io_uring.c:7081
Modules linked in:
CPU: 0 PID: 8397 Comm: syz-executor469 Not tainted 5.12.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:io_rsrc_node_switch+0x2a5/0x390 fs/io_uring.c:7081
Code: ff 4d 85 e4 74 a4 48 83 c4 20 5b 5d 41 5c 41 5d 41 5e 41 5f e9 fc 00 99 ff e8 f7 00 99 ff 0f 0b e9 ee fd ff ff e8 eb 00 99 ff <0f> 0b e9 9d fd ff ff 4c 89 f7 e8 7c e0 dc ff eb 8b 4c 89 ef e8 72
RSP: 0018:ffffc9000164fd90 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffff8880196fe000 RCX: 0000000000000000
RDX: ffff88801c7a1c40 RSI: ffffffff81db5d25 RDI: ffff8880196fe000
RBP: 0000000000000000 R08: 0000000000000dc0 R09: ffffffff8c0b37d3
R10: fffffbfff18166fa R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: ffff8880196fe808 R15: 0000000000000000
FS:  0000000001485300(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000200002c4 CR3: 00000000160b2000 CR4: 0000000000350ef0
Call Trace:
 io_uring_create fs/io_uring.c:9611 [inline]
 io_uring_setup+0xf75/0x2a80 fs/io_uring.c:9689
 do_syscall_64+0x3a/0xb0 arch/x86/entry/common.c:47
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x440a49
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 41 15 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fff0b88f008 EFLAGS: 00000246 ORIG_RAX: 00000000000001a9
RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 0000000000440a49
RDX: 0000000000000010 RSI: 00000000200002c0 RDI: 0000000000000182
RBP: 00007fff0b88f050 R08: 0000000000000001 R09: 00007fff0b88f038
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000003
R13: 00007fff0b88f03a R14: 00000000004b74b0 R15: 000000000000000c

