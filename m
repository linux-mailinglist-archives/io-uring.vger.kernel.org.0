Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11B974E57DD
	for <lists+io-uring@lfdr.de>; Wed, 23 Mar 2022 18:52:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239933AbiCWRyC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Mar 2022 13:54:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239815AbiCWRyA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Mar 2022 13:54:00 -0400
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCE8385954
        for <io-uring@vger.kernel.org>; Wed, 23 Mar 2022 10:52:29 -0700 (PDT)
Received: by mail-il1-f200.google.com with SMTP id s4-20020a92c5c4000000b002c7884b8608so1282101ilt.21
        for <io-uring@vger.kernel.org>; Wed, 23 Mar 2022 10:52:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=zYiQiLP0CS4LsisvZLzMB1pBnXWj26AdiiH/LiFkOlY=;
        b=LdAnXiysuO9YBvuRCamuXVG1A50flzJKywKiUnQSgz7AXVBvFzTTNwT10VWhRlXKZs
         nmPGEBXgRB57JAS2jMRqt7OCwk+3yhr4E6hd7qvawCWtwCGRDhk1L1JxxShwxdCuw8XE
         OqPZfFczGmdFsWa69EmfbTj4SKYKU/sXAfrjjy341DmuRyH5SxY12Tw3feT69/Ry9gKZ
         haXAGoVNxXunUmeW0g3sKMug5i+6BG5Qp3wJvm63aKDOBt2yW6P4ky1U1rNq5fKUiHYc
         wzwLACUGy2ZrbQCww39EkfmB/l5AyvtCNsYwHFKvyxSy5fDmgsAHDlJFOHQwV7MyPf6z
         Xuwg==
X-Gm-Message-State: AOAM530l2gCim3e3FzRun/YRCA9AxngM3XYEGRrR47lspGqBFsjTGqL9
        SdPW/0j/MEs2ktAT1d3GVmiWQ89mqU4g3DktoUTRrpBvkifF
X-Google-Smtp-Source: ABdhPJwpotWrqsMzIpJ+Oq2bNctiIO3SBJMqH7N2YbYQPMDqnaAycniduUzH7UpidmAPHmQhOiT07PlBD8IdNL9PdpMdzcda3/T3
MIME-Version: 1.0
X-Received: by 2002:a02:ca50:0:b0:321:42d5:b4af with SMTP id
 i16-20020a02ca50000000b0032142d5b4afmr587393jal.82.1648057949112; Wed, 23 Mar
 2022 10:52:29 -0700 (PDT)
Date:   Wed, 23 Mar 2022 10:52:29 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a0506305dae664f2@google.com>
Subject: [syzbot] general protection fault in io_kill_timeouts
From:   syzbot <syzbot+f252f28df734e8521387@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    b61581ae229d Add linux-next specific files for 20220323
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=17bbb75b700000
kernel config:  https://syzkaller.appspot.com/x/.config?x=def28433baf109ed
dashboard link: https://syzkaller.appspot.com/bug?extid=f252f28df734e8521387
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=117d3a43700000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15538925700000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+f252f28df734e8521387@syzkaller.appspotmail.com

RDX: 0000000000000f90 RSI: 00000000200000c0 RDI: 00000000000078af
RBP: 00007fffd1ad3f90 R08: 0000000000000001 R09: 0000000000000001
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000003
R13: 431bde82d7b634db R14: 0000000000000000 R15: 0000000000000000
 </TASK>
general protection fault, probably for non-canonical address 0xdffffc0000000018: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x00000000000000c0-0x00000000000000c7]
CPU: 0 PID: 3589 Comm: syz-executor273 Tainted: G        W         5.17.0-next-20220323-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:io_commit_cqring fs/io_uring.c:1812 [inline]
RIP: 0010:io_kill_timeouts+0x267/0x2ce fs/io_uring.c:10297
Code: 74 09 3c 03 7f 05 e8 c5 ca a7 f8 49 8d bc 24 c0 00 00 00 b8 ff ff 37 00 44 8b ad 40 03 00 00 48 89 fa 48 c1 e0 2a 48 c1 ea 03 <8a> 14 02 48 89 f8 83 e0 07 83 c0 03 38 d0 7c 09 84 d2 74 05 e8 fd
RSP: 0018:ffffc9000399fcf8 EFLAGS: 00010206
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000018 RSI: ffffffff817ef121 RDI: 00000000000000c0
RBP: ffff888011a75000 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff817ef108 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: ffff888011a75040 R15: 0000000000000001
FS:  0000555557264300(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055a52ec10058 CR3: 0000000024024000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 io_ring_ctx_wait_and_kill+0x1c2/0x327 fs/io_uring.c:10317
 io_uring_create fs/io_uring.c:11385 [inline]
 io_uring_setup.cold+0x10a3/0x263b fs/io_uring.c:11412
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0x80 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f85ced00069
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 b1 14 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fffd1ad3f78 EFLAGS: 00000246 ORIG_RAX: 00000000000001a9
RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007f85ced00069
RDX: 0000000000000f90 RSI: 00000000200000c0 RDI: 00000000000078af
RBP: 00007fffd1ad3f90 R08: 0000000000000001 R09: 0000000000000001
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000003
R13: 431bde82d7b634db R14: 0000000000000000 R15: 0000000000000000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:io_commit_cqring fs/io_uring.c:1812 [inline]
RIP: 0010:io_kill_timeouts+0x267/0x2ce fs/io_uring.c:10297
Code: 74 09 3c 03 7f 05 e8 c5 ca a7 f8 49 8d bc 24 c0 00 00 00 b8 ff ff 37 00 44 8b ad 40 03 00 00 48 89 fa 48 c1 e0 2a 48 c1 ea 03 <8a> 14 02 48 89 f8 83 e0 07 83 c0 03 38 d0 7c 09 84 d2 74 05 e8 fd
RSP: 0018:ffffc9000399fcf8 EFLAGS: 00010206
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000018 RSI: ffffffff817ef121 RDI: 00000000000000c0
RBP: ffff888011a75000 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff817ef108 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: ffff888011a75040 R15: 0000000000000001
FS:  0000555557264300(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055a52ec10058 CR3: 0000000024024000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	74 09                	je     0xb
   2:	3c 03                	cmp    $0x3,%al
   4:	7f 05                	jg     0xb
   6:	e8 c5 ca a7 f8       	callq  0xf8a7cad0
   b:	49 8d bc 24 c0 00 00 	lea    0xc0(%r12),%rdi
  12:	00
  13:	b8 ff ff 37 00       	mov    $0x37ffff,%eax
  18:	44 8b ad 40 03 00 00 	mov    0x340(%rbp),%r13d
  1f:	48 89 fa             	mov    %rdi,%rdx
  22:	48 c1 e0 2a          	shl    $0x2a,%rax
  26:	48 c1 ea 03          	shr    $0x3,%rdx
* 2a:	8a 14 02             	mov    (%rdx,%rax,1),%dl <-- trapping instruction
  2d:	48 89 f8             	mov    %rdi,%rax
  30:	83 e0 07             	and    $0x7,%eax
  33:	83 c0 03             	add    $0x3,%eax
  36:	38 d0                	cmp    %dl,%al
  38:	7c 09                	jl     0x43
  3a:	84 d2                	test   %dl,%dl
  3c:	74 05                	je     0x43
  3e:	e8                   	.byte 0xe8
  3f:	fd                   	std


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
