Return-Path: <io-uring+bounces-10171-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4ECCBC038E5
	for <lists+io-uring@lfdr.de>; Thu, 23 Oct 2025 23:34:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 744C33A4C2C
	for <lists+io-uring@lfdr.de>; Thu, 23 Oct 2025 21:34:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A126E2BE7B6;
	Thu, 23 Oct 2025 21:34:15 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f79.google.com (mail-io1-f79.google.com [209.85.166.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0A5221D011
	for <io-uring@vger.kernel.org>; Thu, 23 Oct 2025 21:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761255255; cv=none; b=f4NapX9PIkt1O2K4zuBGAMRX1kkOCF4YtwV+8iJwZwGNY0IbpeDFLr94ncP3BjjPeSnFRFhirV6fVP1UDH2tbamhejV3wF/3OWisbQIo8rycz3bZCBiK89RmPGp6rIIz73wqdlLrdGcRSFLbEGpLrBbMGWN+xTftJ3Ahd/R+J4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761255255; c=relaxed/simple;
	bh=b9mJ0wfHCdFAxMXdIFdF1OEj7j462EBU3I7Rxg8e0nU=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=JM9sqrHjZhtu305nN5s7yv44hfO0f1CGo3NBQse3I/URsBQrpWnWqLgr4u8ig3nuM4QyzYU5uY8ka6zeJvD0N+I30TgH1hHhBZJ9yUqWgl5YWXPwxbshCVS3nfsUNEt9Thgtj+0VYQYDKISHCdqGd+awlu6b4fhVMdfQ6wx5nVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f79.google.com with SMTP id ca18e2360f4ac-93e809242d0so349746539f.0
        for <io-uring@vger.kernel.org>; Thu, 23 Oct 2025 14:34:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761255253; x=1761860053;
        h=content-transfer-encoding:cc:to:from:subject:message-id:in-reply-to
         :date:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=loe8th7Xg9hRopVA0WvfRwtb93WZHAknxHHhI585kIM=;
        b=f3rjZEkTDtZT0Y6VaAu7X6N79Uamyzx0bQadX6TiZEh+Hw2yYEctpKKqC6gB4V+vob
         HzyWNMjeMny/5w0PeaX/wwyqrGs60Nlf7V67qY8eM0o78CNBusFCmJcEVazV0FggjSQF
         UbIoPxTPRyHUAGEklNwXkjZktWYf7uRa1YmQK/ihIv+kxJK3u9Tz87L9DfbLxIXqDSTV
         uocLE0TxxxhIRoME46ELqePTQTHXY2ObWor4VBOewmvX2sYEBmUX+6BeonL4fzwEQW4D
         CdWdj/O9iK2fJI1hw0mM4qVwMe4YU3MQ3l2ZIaSQ1pIyZrzh9xW35/wo/ReNJnCTQKlH
         2OOg==
X-Forwarded-Encrypted: i=1; AJvYcCUJh46uqw1clfzrjH50rWJCJitbNG+Syl/YUVLsrsizOm+koaNrmc71JjchpaMW9ZYQtigCZtzhSg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxfWn9NCFEFYQOeTW/Y95N2xuQnAmQJwje1/sgS/nUq9nW+yM/f
	WQPLpJzhLghkHO3HddiVpwHGqFmbzt5eFSvAD4JXyIIAvaZuM/bEuiMdUvjthjEIqUsLpk7MVHe
	1LnuOIhgb/sVDmb7QG8dP+Lus6RetXcG7fwvNyGlkpKBKpNhsttSYiBkwJpM=
X-Google-Smtp-Source: AGHT+IH75gHK6dAsXoGW8erErOQGTqLjf8vOAntJk6lzGTmhBleUeT2KX6rneyVPyH5+/Yvbs6I+46DO7YFT74TCH0t4qkC7RUNv
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:3287:b0:430:a3b0:8458 with SMTP id
 e9e14a558f8ab-431dc139f2cmr67391585ab.3.1761255253090; Thu, 23 Oct 2025
 14:34:13 -0700 (PDT)
Date: Thu, 23 Oct 2025 14:34:13 -0700
In-Reply-To: <CADUfDZqUS_gk=u+fx5QVp7+gNGTSt438YG+Z-FBZP8kougK3Fw@mail.gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68fa9f55.a70a0220.3bf6c6.00cc.GAE@google.com>
Subject: Re: [syzbot] [io-uring?] general protection fault in
 io_uring_show_fdinfo (4)
From: syzbot <syzbot+a77f64386b3e1b2ebb51@syzkaller.appspotmail.com>
To: csander@purestorage.com
Cc: axboe@kernel.dk, csander@purestorage.com, io-uring@vger.kernel.org, 
	kbusch@kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> On Thu, Oct 23, 2025 at 2:21=E2=80=AFPM syzbot
> <syzbot+a77f64386b3e1b2ebb51@syzkaller.appspotmail.com> wrote:
>>
>> Hello,
>>
>> syzbot found the following issue on:
>>
>> HEAD commit:    aaa9c3550b60 Add linux-next specific files for 20251022
>> git tree:       linux-next
>> console output: https://syzkaller.appspot.com/x/log.txt?x=3D11880c925800=
00
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=3Dc8b911aebadf=
6410
>> dashboard link: https://syzkaller.appspot.com/bug?extid=3Da77f64386b3e1b=
2ebb51
>> compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b79=
76-1~exp1~20250708183702.136), Debian LLD 20.1.8
>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D12e7373458=
0000
>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D102f43e25800=
00
>>
>> Downloadable assets:
>> disk image: https://storage.googleapis.com/syzbot-assets/44f7af9b7ca1/di=
sk-aaa9c355.raw.xz
>> vmlinux: https://storage.googleapis.com/syzbot-assets/9d09b0a9994d/vmlin=
ux-aaa9c355.xz
>> kernel image: https://storage.googleapis.com/syzbot-assets/ae729ccb2c5c/=
bzImage-aaa9c355.xz
>>
>> The issue was bisected to:
>>
>> commit 31dc41afdef21f264364288a30013b538c46152e
>> Author: Keith Busch <kbusch@kernel.org>
>> Date:   Thu Oct 16 18:09:38 2025 +0000
>>
>>     io_uring: add support for IORING_SETUP_SQE_MIXED
>>
>> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=3D12eac6145=
80000
>> final oops:     https://syzkaller.appspot.com/x/report.txt?x=3D11eac6145=
80000
>> console output: https://syzkaller.appspot.com/x/log.txt?x=3D16eac6145800=
00
>>
>> IMPORTANT: if you fix the issue, please add the following tag to the com=
mit:
>> Reported-by: syzbot+a77f64386b3e1b2ebb51@syzkaller.appspotmail.com
>> Fixes: 31dc41afdef2 ("io_uring: add support for IORING_SETUP_SQE_MIXED")
>>
>> Oops: general protection fault, probably for non-canonical address 0xdff=
ffc0000000000: 0000 [#1] SMP KASAN PTI
>> KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
>> CPU: 0 UID: 0 PID: 6032 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(=
full)
>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS =
Google 10/02/2025
>> RIP: 0010:__io_uring_show_fdinfo io_uring/fdinfo.c:103 [inline]
>> RIP: 0010:io_uring_show_fdinfo+0x371/0x1840 io_uring/fdinfo.c:255
>> Code: 0f 85 29 04 00 00 45 8b 36 44 89 f7 44 89 ee e8 a5 ec 94 00 45 39 =
ee 76 11 e8 db ea 94 00 45 89 fd 4c 8b 3c 24 e9 c9 03 00 00 <80> 3b 00 45 8=
9 fd 0f 85 17 04 00 00 0f b6 2c 25 00 00 00 00 48 8b
>> RSP: 0018:ffffc9000392f928 EFLAGS: 00010293
>> RAX: ffffffff812b42ab RBX: dffffc0000000000 RCX: 0000000000000000
>> RDX: ffff888026c65ac0 RSI: 00000000000001ff RDI: 0000000000000000
>> RBP: 0000000000000000 R08: ffff888069c000aa R09: 1ffff1100d380015
>> R10: dffffc0000000000 R11: ffffed100d380016 R12: 0000000000000008
>> R13: 00000000000001ff R14: 0000000000000000 R15: 0000000000000000
>> FS:  000055556a027500(0000) GS:ffff888125f29000(0000) knlGS:000000000000=
0000
>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> CR2: 0000001b30363fff CR3: 0000000076c50000 CR4: 00000000003526f0
>> Call Trace:
>>  <TASK>
>>  seq_show+0x5bc/0x730 fs/proc/fd.c:68
>>  seq_read_iter+0x4ef/0xe20 fs/seq_file.c:230
>>  seq_read+0x369/0x480 fs/seq_file.c:162
>>  vfs_read+0x200/0xa30 fs/read_write.c:570
>>  ksys_read+0x145/0x250 fs/read_write.c:715
>>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>>  do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
>>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>> RIP: 0033:0x7f198c78efc9
>> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 =
f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 f=
f ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
>> RSP: 002b:00007fffae1a3128 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
>> RAX: ffffffffffffffda RBX: 00007f198c9e5fa0 RCX: 00007f198c78efc9
>> RDX: 0000000000002020 RSI: 00002000000040c0 RDI: 0000000000000004
>> RBP: 00007f198c811f91 R08: 0000000000000000 R09: 0000000000000000
>> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
>> R13: 00007f198c9e5fa0 R14: 00007f198c9e5fa0 R15: 0000000000000003
>>  </TASK>
>> Modules linked in:
>> ---[ end trace 0000000000000000 ]---
>> RIP: 0010:__io_uring_show_fdinfo io_uring/fdinfo.c:103 [inline]
>> RIP: 0010:io_uring_show_fdinfo+0x371/0x1840 io_uring/fdinfo.c:255
>> Code: 0f 85 29 04 00 00 45 8b 36 44 89 f7 44 89 ee e8 a5 ec 94 00 45 39 =
ee 76 11 e8 db ea 94 00 45 89 fd 4c 8b 3c 24 e9 c9 03 00 00 <80> 3b 00 45 8=
9 fd 0f 85 17 04 00 00 0f b6 2c 25 00 00 00 00 48 8b
>> RSP: 0018:ffffc9000392f928 EFLAGS: 00010293
>> RAX: ffffffff812b42ab RBX: dffffc0000000000 RCX: 0000000000000000
>> RDX: ffff888026c65ac0 RSI: 00000000000001ff RDI: 0000000000000000
>> RBP: 0000000000000000 R08: ffff888069c000aa R09: 1ffff1100d380015
>> R10: dffffc0000000000 R11: ffffed100d380016 R12: 0000000000000008
>> R13: 00000000000001ff R14: 0000000000000000 R15: 0000000000000000
>> FS:  000055556a027500(0000) GS:ffff888125f29000(0000) knlGS:000000000000=
0000
>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> CR2: 0000001b30363fff CR3: 0000000076c50000 CR4: 00000000003526f0
>> ----------------
>> Code disassembly (best guess):
>>    0:   0f 85 29 04 00 00       jne    0x42f
>>    6:   45 8b 36                mov    (%r14),%r14d
>>    9:   44 89 f7                mov    %r14d,%edi
>>    c:   44 89 ee                mov    %r13d,%esi
>>    f:   e8 a5 ec 94 00          call   0x94ecb9
>>   14:   45 39 ee                cmp    %r13d,%r14d
>>   17:   76 11                   jbe    0x2a
>>   19:   e8 db ea 94 00          call   0x94eaf9
>>   1e:   45 89 fd                mov    %r15d,%r13d
>>   21:   4c 8b 3c 24             mov    (%rsp),%r15
>>   25:   e9 c9 03 00 00          jmp    0x3f3
>> * 2a:   80 3b 00                cmpb   $0x0,(%rbx) <-- trapping instruct=
ion
>>   2d:   45 89 fd                mov    %r15d,%r13d
>>   30:   0f 85 17 04 00 00       jne    0x44d
>>   36:   0f b6 2c 25 00 00 00    movzbl 0x0,%ebp
>>   3d:   00
>>   3e:   48                      rex.W
>>   3f:   8b                      .byte 0x8b
>>
>>
>> ---
>> This report is generated by a bot. It may contain errors.
>> See https://goo.gl/tpsmEJ for more information about syzbot.
>> syzbot engineers can be reached at syzkaller@googlegroups.com.
>>
>> syzbot will keep track of this issue. See:
>> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>> For information about bisection process see: https://goo.gl/tpsmEJ#bisec=
tion
>>
>> If the report is already addressed, let syzbot know by replying with:
>> #syz fix: exact-commit-title
>>
>> If you want syzbot to run the reproducer, reply with:
>> #syz test: git://repo/address.git branch-or-commit-hash
>> If you attach or paste a git patch, syzbot will apply it before testing.
>>
>> If you want to overwrite report's subsystems, reply with:
>> #syz set subsystems: new-subsystem
>> (See the list of subsystem names on the web dashboard)
>>
>> If the report is a duplicate of another one, reply with:
>> #syz dup: exact-subject-of-another-report
>>
>> If you want to undo deduplication, reply with:
>> #syz undup
>
> #syz dup: [syzbot] [io-uring?] general protection fault in

can't find the dup bug

> io_uring_show_fdinfo (3)

