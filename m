Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D3CC78A982
	for <lists+io-uring@lfdr.de>; Mon, 28 Aug 2023 12:01:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230195AbjH1KAa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 28 Aug 2023 06:00:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230228AbjH1J74 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 28 Aug 2023 05:59:56 -0400
Received: from mail-pf1-f205.google.com (mail-pf1-f205.google.com [209.85.210.205])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FFCAB2
        for <io-uring@vger.kernel.org>; Mon, 28 Aug 2023 02:59:53 -0700 (PDT)
Received: by mail-pf1-f205.google.com with SMTP id d2e1a72fcca58-68bf123aca4so2581098b3a.1
        for <io-uring@vger.kernel.org>; Mon, 28 Aug 2023 02:59:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693216793; x=1693821593;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=estplTWSxKrAsxyRRN46bbjvd0eh61f81Ark1D69GWA=;
        b=e53Nk5lkBVWrSO9DJIL9QESS98Km86j6SQjX/iafmjMgRF/UzICyftk69HswOx/lFh
         IHekOK3nmpY8cVuplIK/k4auXfMJtdzNyqw/7PMRJDuq0txZmWkJHDp1Nc0Lu76rLrOy
         kDqYYGIqXaYC+DqruyO/SB7s9Jv2oNnT/9SiKdGX6bLlZOtRVhVDImMAbG5LwX/QRsgR
         AHLuZfwZTOyXQYFkHRpSegwFs5BoerD/cx7DlXNOKWPhd4KpMpdXGJbzzLSt98p7WC41
         rCt3ahO2Z9mdzGx2f/dIkjiwjGW9xfoue3RWynQxLx4/IewfVxBi4aKUIjZIXDhIKXzU
         FvSw==
X-Gm-Message-State: AOJu0Yybd662bxPs87LMUrCyadBm/sf0yqy3XNK/EqfjVV0wwmGlwuzS
        DHhXOWG16e/+ghdx62uWqgviDZeqd2TXgFNyKxq778tV8ldn
X-Google-Smtp-Source: AGHT+IHDaei6qWidJDdm6CroNx2NnLungXrApU1x38pM+tfjRV+A7R3/jLv4RjTrp/jWHptaEUjMDiPX48kuppPUbzaKJFAqKslX
MIME-Version: 1.0
X-Received: by 2002:a05:6a00:2d24:b0:68b:de2e:74f9 with SMTP id
 fa36-20020a056a002d2400b0068bde2e74f9mr3688060pfb.1.1693216792721; Mon, 28
 Aug 2023 02:59:52 -0700 (PDT)
Date:   Mon, 28 Aug 2023 02:59:52 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000753fbd0603f8c10b@google.com>
Subject: [syzbot] [io-uring?] general protection fault in io_sqpoll_wq_cpu_affinity
From:   syzbot <syzbot+c74fea926a78b8a91042@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    626932085009 Add linux-next specific files for 20230825
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=12a97797a80000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8a8c992a790e5073
dashboard link: https://syzkaller.appspot.com/bug?extid=c74fea926a78b8a91042
compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/46ec18b3c2fb/disk-62693208.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/b4ea0cb78498/vmlinux-62693208.xz
kernel image: https://storage.googleapis.com/syzbot-assets/5fb3938c7272/bzImage-62693208.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c74fea926a78b8a91042@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc000000011d: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x00000000000008e8-0x00000000000008ef]
CPU: 1 PID: 27342 Comm: syz-executor.5 Not tainted 6.5.0-rc7-next-20230825-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/26/2023
RIP: 0010:io_sqpoll_wq_cpu_affinity+0x8c/0xe0 io_uring/sqpoll.c:433
Code: 48 c1 ea 03 80 3c 02 00 75 64 4c 8b a3 a8 00 00 00 48 b8 00 00 00 00 00 fc ff df 49 8d bc 24 e8 08 00 00 48 89 fa 48 c1 ea 03 <80> 3c 02 00 75 37 49 8b bc 24 e8 08 00 00 48 89 ee e8 7e ac 02 00
RSP: 0018:ffffc900051dfe00 EFLAGS: 00010206
RAX: dffffc0000000000 RBX: ffff888056c72400 RCX: 0000000000000000
RDX: 000000000000011d RSI: ffffffff841f12be RDI: 00000000000008e8
RBP: ffffc900051dfec8 R08: 0000000000000000 R09: ffffed100ad8e482
R10: ffffc900051dfde8 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000011 R15: ffffc900051dfec8
FS:  00007f1f3e2bc6c0(0000) GS:ffff8880b9900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffe2c9b3010 CR3: 0000000029652000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 __io_register_iowq_aff io_uring/io_uring.c:4207 [inline]
 __io_register_iowq_aff+0xa7/0xe0 io_uring/io_uring.c:4198
 io_register_iowq_aff io_uring/io_uring.c:4240 [inline]
 __io_uring_register io_uring/io_uring.c:4447 [inline]
 __do_sys_io_uring_register+0xf58/0x2250 io_uring/io_uring.c:4539
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x38/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f1f3d47cae9
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 e1 20 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f1f3e2bc0c8 EFLAGS: 00000246 ORIG_RAX: 00000000000001ab
RAX: ffffffffffffffda RBX: 00007f1f3d59bf80 RCX: 00007f1f3d47cae9
RDX: 0000000020000140 RSI: 0000000000000011 RDI: 0000000000000003
RBP: 00007f1f3d4c847a R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000246 R12: 0000000000000000
R13: 000000000000000b R14: 00007f1f3d59bf80 R15: 00007fffb91ba9f8
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:io_sqpoll_wq_cpu_affinity+0x8c/0xe0 io_uring/sqpoll.c:433
Code: 48 c1 ea 03 80 3c 02 00 75 64 4c 8b a3 a8 00 00 00 48 b8 00 00 00 00 00 fc ff df 49 8d bc 24 e8 08 00 00 48 89 fa 48 c1 ea 03 <80> 3c 02 00 75 37 49 8b bc 24 e8 08 00 00 48 89 ee e8 7e ac 02 00
RSP: 0018:ffffc900051dfe00 EFLAGS: 00010206
RAX: dffffc0000000000 RBX: ffff888056c72400 RCX: 0000000000000000
RDX: 000000000000011d RSI: ffffffff841f12be RDI: 00000000000008e8
RBP: ffffc900051dfec8 R08: 0000000000000000 R09: ffffed100ad8e482
R10: ffffc900051dfde8 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000011 R15: ffffc900051dfec8
FS:  00007f1f3e2bc6c0(0000) GS:ffff8880b9800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f6671b75198 CR3: 0000000029652000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	48 c1 ea 03          	shr    $0x3,%rdx
   4:	80 3c 02 00          	cmpb   $0x0,(%rdx,%rax,1)
   8:	75 64                	jne    0x6e
   a:	4c 8b a3 a8 00 00 00 	mov    0xa8(%rbx),%r12
  11:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
  18:	fc ff df
  1b:	49 8d bc 24 e8 08 00 	lea    0x8e8(%r12),%rdi
  22:	00
  23:	48 89 fa             	mov    %rdi,%rdx
  26:	48 c1 ea 03          	shr    $0x3,%rdx
* 2a:	80 3c 02 00          	cmpb   $0x0,(%rdx,%rax,1) <-- trapping instruction
  2e:	75 37                	jne    0x67
  30:	49 8b bc 24 e8 08 00 	mov    0x8e8(%r12),%rdi
  37:	00
  38:	48 89 ee             	mov    %rbp,%rsi
  3b:	e8 7e ac 02 00       	call   0x2acbe


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the bug is already fixed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want to overwrite bug's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the bug is a duplicate of another bug, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
