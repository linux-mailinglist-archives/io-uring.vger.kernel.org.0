Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D714B3FF339
	for <lists+io-uring@lfdr.de>; Thu,  2 Sep 2021 20:28:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346973AbhIBS3G (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 2 Sep 2021 14:29:06 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:40516 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235359AbhIBS3F (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 2 Sep 2021 14:29:05 -0400
Received: by mail-il1-f198.google.com with SMTP id f13-20020a056e02168d00b002244a6aa233so1833025ila.7
        for <io-uring@vger.kernel.org>; Thu, 02 Sep 2021 11:28:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=efhwk1n9DuG/RUbEblIFId1q49zGnCoR05RCbVNCapo=;
        b=IgKDj0jziRA+v9DFVGjRVoJ0kUMgRnyrajkEIoVwZrhmpE73o0Q971D8kZNZV2fGOS
         mUHKLEgSJiB1jQ8HgkKyRerDNwWqnYFWMO3kG8y/Pwcu7Iyllr6KCRSrZC8V21y6ipcF
         RyyNTLDkQN7h1bETTKq9f98wBCAK4Olo0c11P/+f3TPqzMsVyjmLW0TdeoSnw0M+PwkE
         jDKmsXuRWdS5Cua0w3C6h2raj+t1pgue6SLThn5VCWJZX/+5UOnn3t5iEiUCGlYvFKRl
         8XPxfavm8n+YK02NxoZRpRzFUXP30Zvlcgxdtcl0QbE7IkWC3qC2N/0hjz6SqMnvHOLh
         0zCQ==
X-Gm-Message-State: AOAM531G3pI9RpuL2jJv+k5ojn944IRLuDA906ywp7UFJmLARqCRx8Ok
        6xzlpbjWFwbunGQqvwxLUcshCU9DovZ9OjgAWvjZ2QsE7riF
X-Google-Smtp-Source: ABdhPJz/k5cez3kpq7cXPTBYfQVfN29zN44Y5LdAv+pGbQ4AhgvwGlVRz6l7r1KYmSKcuMGyKTxE5ssP6RjFBa9MMGcYfs+/ZrSf
MIME-Version: 1.0
X-Received: by 2002:a92:d20d:: with SMTP id y13mr3305657ily.294.1630607286919;
 Thu, 02 Sep 2021 11:28:06 -0700 (PDT)
Date:   Thu, 02 Sep 2021 11:28:06 -0700
In-Reply-To: <c2b300d4-9d52-9bab-813c-f11deedc434d@kernel.dk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000001ae8cc05cb075852@google.com>
Subject: Re: [syzbot] general protection fault in io_issue_sqe
From:   syzbot <syzbot+de67aa0cf1053e405871@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, haoxu@linux.alibaba.com,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
general protection fault in io_ring_ctx_wait_and_kill

general protection fault, probably for non-canonical address 0xdffffc0000000016: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x00000000000000b0-0x00000000000000b7]
CPU: 0 PID: 10163 Comm: syz-executor.2 Not tainted 5.14.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:io_ring_ctx_wait_and_kill+0x24d/0x450 fs/io_uring.c:9180
Code: ff 48 89 df e8 c4 fb ff ff e8 6f a8 94 ff 48 8b 04 24 48 8d b8 b0 00 00 00 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 d3 01 00 00 48 8b 04 24 48 8b a8 b0 00 00 00 48
RSP: 0018:ffffc9000a8b7a60 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: ffff888046aa6000 RCX: 0000000000000000
RDX: 0000000000000016 RSI: ffffffff81e10061 RDI: 00000000000000b0
RBP: 0000000000000000 R08: 0000000000000000 R09: ffff888046aa6643
R10: ffffffff81e1004b R11: 0000000000000000 R12: ffff888046aa63f8
R13: ffffc9000a8b7a90 R14: ffff8881453f4000 R15: ffff888046aa6040
FS:  0000000000000000(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000561b3ede9400 CR3: 000000000b68e000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 io_uring_release+0x3e/0x50 fs/io_uring.c:9198
 __fput+0x288/0x920 fs/file_table.c:280
 task_work_run+0xdd/0x1a0 kernel/task_work.c:164
 exit_task_work include/linux/task_work.h:32 [inline]
 do_exit+0xbae/0x2a30 kernel/exit.c:825
 do_group_exit+0x125/0x310 kernel/exit.c:922
 get_signal+0x47f/0x2160 kernel/signal.c:2808
 arch_do_signal_or_restart+0x2a9/0x1c40 arch/x86/kernel/signal.c:865
 handle_signal_work kernel/entry/common.c:148 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:172 [inline]
 exit_to_user_mode_prepare+0x17d/0x290 kernel/entry/common.c:209
 __syscall_exit_to_user_mode_work kernel/entry/common.c:291 [inline]
 syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:302
 do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4665f9
Code: Unable to access opcode bytes at RIP 0x4665cf.
RSP: 002b:00007faa595bc218 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
RAX: fffffffffffffe00 RBX: 000000000056c040 RCX: 00000000004665f9
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 000000000056c040
RBP: 000000000056c038 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056c044
R13: 00007fff98399dff R14: 00007faa595bc300 R15: 0000000000022000
Modules linked in:
---[ end trace 641488e48828d1de ]---
RIP: 0010:io_ring_ctx_wait_and_kill+0x24d/0x450 fs/io_uring.c:9180
Code: ff 48 89 df e8 c4 fb ff ff e8 6f a8 94 ff 48 8b 04 24 48 8d b8 b0 00 00 00 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 d3 01 00 00 48 8b 04 24 48 8b a8 b0 00 00 00 48
RSP: 0018:ffffc9000a8b7a60 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: ffff888046aa6000 RCX: 0000000000000000
RDX: 0000000000000016 RSI: ffffffff81e10061 RDI: 00000000000000b0
RBP: 0000000000000000 R08: 0000000000000000 R09: ffff888046aa6643
R10: ffffffff81e1004b R11: 0000000000000000 R12: ffff888046aa63f8
R13: ffffc9000a8b7a90 R14: ffff8881453f4000 R15: ffff888046aa6040
FS:  0000000000000000(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000561b3ede9400 CR3: 000000003cbf0000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess), 1 bytes skipped:
   0:	48 89 df             	mov    %rbx,%rdi
   3:	e8 c4 fb ff ff       	callq  0xfffffbcc
   8:	e8 6f a8 94 ff       	callq  0xff94a87c
   d:	48 8b 04 24          	mov    (%rsp),%rax
  11:	48 8d b8 b0 00 00 00 	lea    0xb0(%rax),%rdi
  18:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
  1f:	fc ff df
  22:	48 89 fa             	mov    %rdi,%rdx
  25:	48 c1 ea 03          	shr    $0x3,%rdx
* 29:	80 3c 02 00          	cmpb   $0x0,(%rdx,%rax,1) <-- trapping instruction
  2d:	0f 85 d3 01 00 00    	jne    0x206
  33:	48 8b 04 24          	mov    (%rsp),%rax
  37:	48 8b a8 b0 00 00 00 	mov    0xb0(%rax),%rbp
  3e:	48                   	rex.W


Tested on:

commit:         f85aaf32 io_uring: trigger worker exit when ring is ex..
git tree:       git://git.kernel.dk/linux-block for-5.15/io_uring
console output: https://syzkaller.appspot.com/x/log.txt?x=12c280a3300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=fa8e68781da309a
dashboard link: https://syzkaller.appspot.com/bug?extid=de67aa0cf1053e405871
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1

