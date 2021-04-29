Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCDED36ECE9
	for <lists+io-uring@lfdr.de>; Thu, 29 Apr 2021 17:01:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240648AbhD2PCK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 29 Apr 2021 11:02:10 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:50146 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240611AbhD2PCK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 29 Apr 2021 11:02:10 -0400
Received: by mail-io1-f72.google.com with SMTP id i204-20020a6bb8d50000b02903f266b8e1c5so25450841iof.16
        for <io-uring@vger.kernel.org>; Thu, 29 Apr 2021 08:01:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=p08hvBbKA+73t6PrwVyec5Fgw0enIkiE1avPmk1LtBY=;
        b=NBnp44LS+JtfT8pUFHWxtdmjpI3nikwSZD+wWCdnEamIgaqErfNTDXGfoUQhhEZgwE
         rPoKR0VnrWdDrCEAPd7f3NT8/qHZgJ+3DXhlvZbqyLPUMyhYJzSv2atoqz51Kyf0Ea85
         q4/9eT2oOAz6Z2e25JuEchFViXTGIHN/+tNa+eTVQynopsVMwbZW0bNm7njZbOy7jOF6
         mZAksbM9/rWMnP8K3wXUvkIDMnYwMuftqDjpR0Xuy9ss3DbwmFeTYfkzt3OTE02PD4FU
         /xydsYEVaxStPwGW67M/qwV3kwlz8Ud680PHK3kITdMriaOSVXVH1oH7c1KpSgePItyI
         eRwg==
X-Gm-Message-State: AOAM531vziP6x9sHrBVERbPFG53YZG8I/6PfzPaHv3c0eeq56lUNnW5I
        mQnDh5QPLT8JMt/E19e7ggUCh3zCr/PWZrG4KZdmf439/KMo
X-Google-Smtp-Source: ABdhPJyFL2nLdyv3A910LI1aEMALDvqFplKoJdnPUb6yPAgJUhSJ3fsN1630b3VlOcRDd6M4OTjoLlX6nskl/dPjzntWIgoHoMVl
MIME-Version: 1.0
X-Received: by 2002:a5d:9a8c:: with SMTP id c12mr29251309iom.166.1619708483616;
 Thu, 29 Apr 2021 08:01:23 -0700 (PDT)
Date:   Thu, 29 Apr 2021 08:01:23 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ce433f05c11dc4e6@google.com>
Subject: [syzbot] WARNING in io_uring_setup (2)
From:   syzbot <syzbot+1eca5b0d7ac82b74d347@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    d72cd4ad Merge tag 'scsi-misc' of git://git.kernel.org/pub..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=175285a3d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=53fdf14defd48c56
dashboard link: https://syzkaller.appspot.com/bug?extid=1eca5b0d7ac82b74d347
compiler:       Debian clang version 11.0.1-2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15aeff43d00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1747117dd00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+1eca5b0d7ac82b74d347@syzkaller.appspotmail.com

RSP: 002b:00007ffe79f6a2c8 EFLAGS: 00000202 ORIG_RAX: 00000000000001a9
RAX: ffffffffffffffda RBX: 0000000020000000 RCX: 000000000043fa99
RDX: 0000000000000010 RSI: 0000000020000000 RDI: 0000000000000345
RBP: 0000000000000001 R08: 0000000000000001 R09: bfe829bde5bd92dc
R10: 0000000000000000 R11: 0000000000000202 R12: 0000000020ffd000
R13: 0000000000000000 R14: 00000000004ad018 R15: 0000000000400488
------------[ cut here ]------------
WARNING: CPU: 0 PID: 8379 at fs/io_uring.c:7081 io_rsrc_node_switch_start fs/io_uring.c:7107 [inline]
WARNING: CPU: 0 PID: 8379 at fs/io_uring.c:7081 io_uring_create fs/io_uring.c:9610 [inline]
WARNING: CPU: 0 PID: 8379 at fs/io_uring.c:7081 io_uring_setup fs/io_uring.c:9689 [inline]
WARNING: CPU: 0 PID: 8379 at fs/io_uring.c:7081 __do_sys_io_uring_setup fs/io_uring.c:9695 [inline]
WARNING: CPU: 0 PID: 8379 at fs/io_uring.c:7081 __se_sys_io_uring_setup+0x2059/0x3100 fs/io_uring.c:9692
Modules linked in:
CPU: 0 PID: 8379 Comm: syz-executor223 Not tainted 5.12.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:io_rsrc_node_switch fs/io_uring.c:7107 [inline]
RIP: 0010:io_uring_create fs/io_uring.c:9611 [inline]
RIP: 0010:io_uring_setup fs/io_uring.c:9689 [inline]
RIP: 0010:__do_sys_io_uring_setup fs/io_uring.c:9695 [inline]
RIP: 0010:__se_sys_io_uring_setup+0x2059/0x3100 fs/io_uring.c:9692
Code: dc ff eb 05 e8 78 09 97 ff 48 b8 00 00 00 00 00 fc ff df 41 80 7c 05 00 00 74 08 4c 89 ff e8 ce a1 dd ff 49 c7 07 00 00 00 00 <0f> 0b e9 e1 00 00 00 e8 4b 09 97 ff 49 8d 5c 24 10 48 89 d8 48 c1
RSP: 0000:ffffc9000112fd00 EFLAGS: 00010246
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffff88802fee0000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff888011441780
RBP: ffffc9000112ff20 R08: 0000000000000dc0 R09: fffffbfff19bc9e3
R10: fffffbfff19bc9e3 R11: 0000000000000000 R12: ffff88802452010c
R13: 1ffff11005c31501 R14: 0000000000000000 R15: ffff88802e18a808
FS:  00000000009a23c0(0000) GS:ffff8880b9b00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f8918d3b000 CR3: 00000000133b0000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 do_syscall_64+0x3f/0xb0 arch/x86/entry/common.c:47
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x43fa99
Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c4 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffe79f6a2c8 EFLAGS: 00000202 ORIG_RAX: 00000000000001a9
RAX: ffffffffffffffda RBX: 0000000020000000 RCX: 000000000043fa99
RDX: 0000000000000010 RSI: 0000000020000000 RDI: 0000000000000345
RBP: 0000000000000001 R08: 0000000000000001 R09: bfe829bde5bd92dc
R10: 0000000000000000 R11: 0000000000000202 R12: 0000000020ffd000
R13: 0000000000000000 R14: 00000000004ad018 R15: 0000000000400488


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
