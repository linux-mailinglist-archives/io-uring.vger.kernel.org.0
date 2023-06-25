Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7362873D138
	for <lists+io-uring@lfdr.de>; Sun, 25 Jun 2023 15:54:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbjFYNyq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 25 Jun 2023 09:54:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjFYNyp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 25 Jun 2023 09:54:45 -0400
Received: from mail-il1-f207.google.com (mail-il1-f207.google.com [209.85.166.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD4171B1
        for <io-uring@vger.kernel.org>; Sun, 25 Jun 2023 06:54:44 -0700 (PDT)
Received: by mail-il1-f207.google.com with SMTP id e9e14a558f8ab-3406eef1dbeso11991035ab.2
        for <io-uring@vger.kernel.org>; Sun, 25 Jun 2023 06:54:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687701284; x=1690293284;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7EB8O7sLYUOVuoHUWCU4zAQCN50LsLRkmxPMuikieyU=;
        b=d3+BmQY3eE6dbDHD8QDR1ZjttlLN4EocOc8ekoAYJEFLeJeMuzSffeugAwC0bSvNvZ
         QTOX+RQldh3eRfALP1ULW+jPItJ12YfXVCXmoZxLGn9M6e/+xCeHJ+Jn+pF9coP4aa3h
         Gpdq0u6bBkIMEFDQJZ6DBUu5qB62KBP3niwVx+/reSr1/WzI8rD/+Mcd3OeaMQ00VYCa
         k3b3y5ZPDD1zjLg5xyJ5Eg9q5cS3BzOdJj+ix7zKqof8GFzKnDB+3ljc4qvvzMhAXLtF
         QrAo8sNqUhAOkuEzazhQ+YwLzFZEJVo+Si7SjoMkAo1Eiwr1TaLAARMmulmIYulHO2q0
         V23A==
X-Gm-Message-State: AC+VfDzd933GR8Pj1AbJn1mVtdNpo/fcTiLHsuR7OddwErx9rZ3ckA+I
        gEmCtk8c1s13PLmyBjxlh4+10euzePVUOlczPQo1Hj5zOTLl
X-Google-Smtp-Source: ACHHUZ6c3tdgfLKzqI+XozinXUatVqA+ZZ2LTbdvuId1RrrMTwZA5S1qPlTqcM6g3WV5w7rl0WbcggvgxzeEzzT7BOkU3UafZoPq
MIME-Version: 1.0
X-Received: by 2002:a92:ce8b:0:b0:345:9269:3425 with SMTP id
 r11-20020a92ce8b000000b0034592693425mr889110ilo.6.1687701284070; Sun, 25 Jun
 2023 06:54:44 -0700 (PDT)
Date:   Sun, 25 Jun 2023 06:54:44 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000862c5a05fef4935d@google.com>
Subject: [syzbot] [io-uring?] general protection fault in worker_thread (2)
From:   syzbot <syzbot+8aebf783fcc04684a047@syzkaller.appspotmail.com>
To:     axboe@kernel.dk, boqun.feng@gmail.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, longman@redhat.com, mingo@redhat.com,
        peterz@infradead.org, syzkaller-bugs@googlegroups.com,
        will@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    e660abd551f1 Merge tag 'acpi-6.4-rc8' of git://git.kernel...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17e5a5b7280000
kernel config:  https://syzkaller.appspot.com/x/.config?x=24ce1b2abaee24cc
dashboard link: https://syzkaller.appspot.com/bug?extid=8aebf783fcc04684a047
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12f0094b280000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7bc7510fe41f/non_bootable_disk-e660abd5.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/6157b122cedf/vmlinux-e660abd5.xz
kernel image: https://storage.googleapis.com/syzbot-assets/3ca86f1fadbf/bzImage-e660abd5.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+8aebf783fcc04684a047@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc0000000003: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000018-0x000000000000001f]
CPU: 3 PID: 5205 Comm: kworker/2:4 Not tainted 6.4.0-rc7-syzkaller-00041-ge660abd551f1 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.14.0-2 04/01/2014
RIP: 0010:__lock_acquire+0xe01/0x5f30 kernel/locking/lockdep.c:4956
Code: 00 00 3b 05 a1 ce 59 0f 0f 87 7a 09 00 00 41 be 01 00 00 00 e9 84 00 00 00 48 b8 00 00 00 00 00 fc ff df 4c 89 e2 48 c1 ea 03 <80> 3c 02 00 0f 85 9e 33 00 00 49 81 3c 24 20 78 15 90 0f 84 cd f2
RSP: 0018:ffffc90003d27be0 EFLAGS: 00010006
RAX: dffffc0000000000 RBX: 1ffff920007a4fad RCX: 0000000000000000
RDX: 0000000000000003 RSI: 0000000000000000 RDI: 0000000000000018
RBP: ffff88802f9fd6c0 R08: 0000000000000001 R09: 0000000000000001
R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000018
R13: 0000000000000000 R14: 0000000000000018 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88806b900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f896259d440 CR3: 00000000293e8000 CR4: 0000000000350ee0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 lock_acquire kernel/locking/lockdep.c:5705 [inline]
 lock_acquire+0x1b1/0x520 kernel/locking/lockdep.c:5670
 __raw_spin_lock_irq include/linux/spinlock_api_smp.h:119 [inline]
 _raw_spin_lock_irq+0x36/0x50 kernel/locking/spinlock.c:170
 worker_thread+0x16d/0x10c0 kernel/workqueue.c:2502
 kthread+0x344/0x440 kernel/kthread.c:379
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:__lock_acquire+0xe01/0x5f30 kernel/locking/lockdep.c:4956
Code: 00 00 3b 05 a1 ce 59 0f 0f 87 7a 09 00 00 41 be 01 00 00 00 e9 84 00 00 00 48 b8 00 00 00 00 00 fc ff df 4c 89 e2 48 c1 ea 03 <80> 3c 02 00 0f 85 9e 33 00 00 49 81 3c 24 20 78 15 90 0f 84 cd f2
RSP: 0018:ffffc90003d27be0 EFLAGS: 00010006
RAX: dffffc0000000000 RBX: 1ffff920007a4fad RCX: 0000000000000000
RDX: 0000000000000003 RSI: 0000000000000000 RDI: 0000000000000018
RBP: ffff88802f9fd6c0 R08: 0000000000000001 R09: 0000000000000001
R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000018
R13: 0000000000000000 R14: 0000000000000018 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88806b900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f896259d440 CR3: 00000000293e8000 CR4: 0000000000350ee0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	00 00                	add    %al,(%rax)
   2:	3b 05 a1 ce 59 0f    	cmp    0xf59cea1(%rip),%eax        # 0xf59cea9
   8:	0f 87 7a 09 00 00    	ja     0x988
   e:	41 be 01 00 00 00    	mov    $0x1,%r14d
  14:	e9 84 00 00 00       	jmpq   0x9d
  19:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
  20:	fc ff df
  23:	4c 89 e2             	mov    %r12,%rdx
  26:	48 c1 ea 03          	shr    $0x3,%rdx
* 2a:	80 3c 02 00          	cmpb   $0x0,(%rdx,%rax,1) <-- trapping instruction
  2e:	0f 85 9e 33 00 00    	jne    0x33d2
  34:	49 81 3c 24 20 78 15 	cmpq   $0xffffffff90157820,(%r12)
  3b:	90
  3c:	0f                   	.byte 0xf
  3d:	84 cd                	test   %cl,%ch
  3f:	f2                   	repnz


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the bug is already fixed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

If you want to change bug's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the bug is a duplicate of another bug, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
