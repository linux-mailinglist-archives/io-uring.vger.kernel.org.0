Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5796737EFD6
	for <lists+io-uring@lfdr.de>; Thu, 13 May 2021 01:35:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231776AbhELX3D (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 12 May 2021 19:29:03 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:35413 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232660AbhELWjP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 12 May 2021 18:39:15 -0400
Received: by mail-il1-f199.google.com with SMTP id x7-20020a056e021ca7b029016344dffb7bso20775958ill.2
        for <io-uring@vger.kernel.org>; Wed, 12 May 2021 15:38:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=szSoE56UMB+c1bsbG7AHkdeB3bUPiZNML4nbMj0xf7k=;
        b=mbUdo+mrD9GesgnUz/bz02Mj/EDELTEQaLVWzsVzEInrIpA+vB/OTZ0/oMFpkEj+4i
         XDfO6Y/6/PnKhZPE/qUmqg0mvb3s3dDA+eoqNsJ29b36glFMAYdZ4v668ZSPAXinjKS+
         4byc5evJZalFUpgZqNXBL00ZtzP5PVk5Ipaw50LOwGTcNB1ALtBGc9gdl35Uc/Pz/IRA
         63ZODfGPSvnPgUR89aIEzCHCpax6pbEJUphIyCEvuAx5QL//2CQCW295LjihV9vpb4jL
         g4XnKJEz+igZwKzrx8jph9R/6dK4f6Q9eQ13RlSqkNvD7pYh5Yd0/pE4qerQGU1xoqsq
         OWDw==
X-Gm-Message-State: AOAM531/woOnrHlFk+6c0X/pOlgXmsoPo8inKJP3mEy2tPMjVGVhFjC1
        2Gb5znruhsfq8UIA5DVFETOvPqIZ3/Je+MOT7RkVj6rgmsdR
X-Google-Smtp-Source: ABdhPJzxevMuTplD1GvxOTx2u+5lJtiB/EjXttUrvM9GBeIdAqpgMghNdUj/rGvNOQ4y7MrkYTkgUxtaTiSylYxqo+2Y8AA+++Gy
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:13d0:: with SMTP id v16mr3591842ilj.168.1620859086249;
 Wed, 12 May 2021 15:38:06 -0700 (PDT)
Date:   Wed, 12 May 2021 15:38:06 -0700
In-Reply-To: <bb6f7045-863c-ca86-3925-7d65dc90d5b7@kernel.dk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000011220705c229aa98@google.com>
Subject: Re: [syzbot] WARNING in io_link_timeout_fn
From:   syzbot <syzbot+5a864149dd970b546223@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
WARNING in io_req_complete_failed

------------[ cut here ]------------
WARNING: CPU: 0 PID: 10153 at fs/io_uring.c:1505 req_ref_put_and_test fs/io_uring.c:1505 [inline]
WARNING: CPU: 0 PID: 10153 at fs/io_uring.c:1505 io_put_req fs/io_uring.c:2171 [inline]
WARNING: CPU: 0 PID: 10153 at fs/io_uring.c:1505 io_req_complete_failed+0x2ee/0x5a0 fs/io_uring.c:1649
Modules linked in:
CPU: 1 PID: 10153 Comm: syz-executor.3 Not tainted 5.12.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:req_ref_put_and_test fs/io_uring.c:1505 [inline]
RIP: 0010:io_put_req fs/io_uring.c:2171 [inline]
RIP: 0010:io_req_complete_failed+0x2ee/0x5a0 fs/io_uring.c:1649
Code: 58 bd da ff be 01 00 00 00 4c 89 f7 e8 5b 78 fe ff e9 09 fe ff ff e8 f1 32 97 ff 4c 89 ef e8 a9 fd 65 ff eb cb e8 e2 32 97 ff <0f> 0b e9 c8 fd ff ff 4c 89 f7 e8 23 0b db ff e9 3c fd ff ff 4c 89
RSP: 0018:ffffc9000afbfd10 EFLAGS: 00010293

RAX: 0000000000000000 RBX: 000000000000007f RCX: 0000000000000000
RDX: ffff88801f5e0000 RSI: ffffffff81dd35ae RDI: 0000000000000003
RBP: ffff888043314dc0 R08: 000000000000007f R09: ffff888043314e1f
R10: ffffffff81dd3374 R11: 000000000000000f R12: ffffffffffffffea
R13: ffff888043314e1c R14: ffff888043314e18 R15: 00000000ffffffea
FS:  00007fac1b577700(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f04f797dd40 CR3: 0000000012dfb000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 __io_queue_sqe+0x61e/0x10f0 fs/io_uring.c:6440
 __io_req_task_submit+0x103/0x120 fs/io_uring.c:2037
 __tctx_task_work fs/io_uring.c:1908 [inline]
 tctx_task_work+0x24e/0x550 fs/io_uring.c:1922
 task_work_run+0xdd/0x1a0 kernel/task_work.c:161
 tracehook_notify_signal include/linux/tracehook.h:212 [inline]
 handle_signal_work kernel/entry/common.c:145 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:171 [inline]
 exit_to_user_mode_prepare+0x24a/0x280 kernel/entry/common.c:208
 __syscall_exit_to_user_mode_work kernel/entry/common.c:290 [inline]
 syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:301
 do_syscall_64+0x47/0xb0 arch/x86/entry/common.c:57
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4665f9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48


Tested on:

commit:         a298232e io_uring: fix link timeout refs
git tree:       git://git.kernel.dk/linux-block.git io_uring-5.13
console output: https://syzkaller.appspot.com/x/log.txt?x=15f82965d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ae2e6c63d6410fd3
dashboard link: https://syzkaller.appspot.com/bug?extid=5a864149dd970b546223
compiler:       

