Return-Path: <io-uring+bounces-5579-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DE0479F995A
	for <lists+io-uring@lfdr.de>; Fri, 20 Dec 2024 19:21:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3E814189902F
	for <lists+io-uring@lfdr.de>; Fri, 20 Dec 2024 18:15:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CBDF216388;
	Fri, 20 Dec 2024 18:15:39 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f208.google.com (mail-il1-f208.google.com [209.85.166.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA9E121B8F2
	for <io-uring@vger.kernel.org>; Fri, 20 Dec 2024 18:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734718539; cv=none; b=EJXA8msOw5eQ06wXrfqdIZynV8yEFXUgvskeMK5JOi5I+7tqKOh0CIVobqEt1zzHGSk3/9zB07QN6xt0RTFym8Z1zqPEzND/8QEYmqPAOpK/CLu+rTEaP9KR3G8vQKI2zfEpSpjP1hG6UFBSR5s6NVWKffyakyAkbFGl5us2uKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734718539; c=relaxed/simple;
	bh=o91vOnX27Y9Dxuoa3M2pjGaWZePj4FOzNMzk8eQl12U=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=qYfFWZBGSq/fZyoB3gDLldrbPV4Y9TIzz5AhFcO/V7WlPAaWbNJEEKNbqPPzc2/eDkG7NUIeIpBjrJYS1zwUfafR9X6H1yl/huZ2b8kNS4oGNfaWqPAeSmaN3MKjW548xsLNaDwHV9TArqNF5UWi0qyeKTqMALi7I8J0JutPx+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f208.google.com with SMTP id e9e14a558f8ab-3a9cbe8fea1so21468205ab.3
        for <io-uring@vger.kernel.org>; Fri, 20 Dec 2024 10:15:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734718537; x=1735323337;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JzD//PkzHNQXeRaBt7t8cUsMfU6PBnO1ghqqkJhdY/0=;
        b=KPAuL2N6ysp+Xj1L79XGBj0T0rNTdofG/AOui/FWADsdA7E1Hr0Df1sz181ZD7aRKa
         bya7q0a+QDmt7rDV4aOZCAPhXsxz2ZNcjD10KKgNxKXeYugBlczIWkte4fJ1hsF5GV5E
         XgIcm+SLdqhNpO1M9LegPbXJLYkp57lfH6evRett2ooUmlC4zUcYvneQJl8MolTB588a
         +oLlQR6o81+rBVH+CKznqImeZNeUjshJ4SapPmmbx5mFte795/dDj6Nc5ZavoW6YOLQw
         z8tP6NkppY0q6uRyjpJxTaXZ7VxgeEs0DJ7kQ99sDtitAo/JNs87D4I6AK+qULQO7E0Q
         ga+A==
X-Forwarded-Encrypted: i=1; AJvYcCVDB15QwUmQGoodv058pHWZOqbuoxopPymQRtFxlMcklnEnkg6uKccClPghAzjGIDyiR50WFFBebA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxPITsKXPWQcz22fnvevswUgYqDL60eXaxIb+13MxLW9VGs+MJY
	cHTLpdkmzLpbb8nJBWkBHtpk6F8NHiQxsA1LbKmKLKVctE9pGlEBOUdwW3poVmEeZvywGVIbtg4
	hkdq/ai5F+jDyc4zjOpRLZVFIeJta8CrhTtMmGP7ZgOu0AhxRTzAEUYQ=
X-Google-Smtp-Source: AGHT+IE4dxcJUY4fQH8VIplTCmm+qY6WGC52/GdOVj8WNkWGzs/c44XywggfJCMVTuLkjCUgUHj9Y200q/6gAZ9rYu4wXNI+uvAE
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:c269:0:b0:3a7:9533:c3ac with SMTP id
 e9e14a558f8ab-3c2d17bd4e4mr38947155ab.4.1734718536699; Fri, 20 Dec 2024
 10:15:36 -0800 (PST)
Date: Fri, 20 Dec 2024 10:15:36 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6765b448.050a0220.15b956.00d4.GAE@google.com>
Subject: [syzbot] [io-uring?] WARNING in __io_submit_flush_completions
From: syzbot <syzbot+1bcb75613069ad4957fc@syzkaller.appspotmail.com>
To: asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    8faabc041a00 Merge tag 'net-6.13-rc4' of git://git.kernel...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13249e0f980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c22efbd20f8da769
dashboard link: https://syzkaller.appspot.com/bug?extid=1bcb75613069ad4957fc
compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12172fe8580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=111f92df980000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/0bdb6cecaf61/disk-8faabc04.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/98b22dfadac0/vmlinux-8faabc04.xz
kernel image: https://storage.googleapis.com/syzbot-assets/65a511d3ba7f/bzImage-8faabc04.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+1bcb75613069ad4957fc@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 1 PID: 5856 at io_uring/io_uring.h:140 io_lockdep_assert_cq_locked+0x1e9/0x320 io_uring/io_uring.h:140
Modules linked in:
CPU: 1 UID: 0 PID: 5856 Comm: syz-executor609 Not tainted 6.13.0-rc3-syzkaller-00136-g8faabc041a00 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 11/25/2024
RIP: 0010:io_lockdep_assert_cq_locked+0x1e9/0x320 io_uring/io_uring.h:140
Code: 44 89 e6 e8 a9 a7 0c fd 45 85 e4 0f 84 13 ff ff ff e8 5b a5 0c fd e8 f6 4f d5 fc 48 85 c0 0f 85 00 ff ff ff e8 48 a5 0c fd 90 <0f> 0b 90 e9 f2 fe ff ff e8 3a a5 0c fd 31 ff 89 ee e8 71 a7 0c fd
RSP: 0018:ffffc90003e87a40 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 0000000000000002 RCX: ffffffff8161f9fa
RDX: ffff88803063bc00 RSI: ffffffff848ca9a8 RDI: 0000000000000005
RBP: ffff88803063bc00 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000001
R13: 0000000000000000 R14: ffff888030322138 R15: ffff88807468a078
FS:  0000555592081380(0000) GS:ffff8880b8700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f82824c70f0 CR3: 000000007c31c000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 io_get_cqe_overflow io_uring/io_uring.h:166 [inline]
 io_get_cqe io_uring/io_uring.h:182 [inline]
 io_fill_cqe_req io_uring/io_uring.h:195 [inline]
 __io_submit_flush_completions+0x131/0x1fd0 io_uring/io_uring.c:1443
 io_submit_flush_completions io_uring/io_uring.h:156 [inline]
 __io_run_local_work+0x13d/0x560 io_uring/io_uring.c:1325
 io_run_local_work io_uring/io_uring.c:1351 [inline]
 io_uring_try_cancel_requests+0x89a/0xd50 io_uring/io_uring.c:3105
 io_uring_cancel_generic+0x651/0x8e0 io_uring/io_uring.c:3166
 io_uring_files_cancel include/linux/io_uring.h:20 [inline]
 do_exit+0x541/0x2d70 kernel/exit.c:894
 do_group_exit+0xd3/0x2a0 kernel/exit.c:1087
 __do_sys_exit_group kernel/exit.c:1098 [inline]
 __se_sys_exit_group kernel/exit.c:1096 [inline]
 __x64_sys_exit_group+0x3e/0x50 kernel/exit.c:1096
 x64_sys_call+0x151f/0x1720 arch/x86/include/generated/asm/syscalls_64.h:232
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcd/0x250 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f828244b249
Code: 90 49 c7 c0 b8 ff ff ff be e7 00 00 00 ba 3c 00 00 00 eb 12 0f 1f 44 00 00 89 d0 0f 05 48 3d 00 f0 ff ff 77 1c f4 89 f0 0f 05 <48> 3d 00 f0 ff ff 76 e7 f7 d8 64 41 89 00 eb df 0f 1f 80 00 00 00
RSP: 002b:00007ffcfb7d1bc8 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f828244b249
RDX: 000000000000003c RSI: 00000000000000e7 RDI: 0000000000000000
RBP: 00007f82824c6290 R08: ffffffffffffffb8 R09: ffffffffffffffff
R10: 0000000000000007 R11: 0000000000000246 R12: 00007f82824c6290
R13: 0000000000000000 R14: 00007f82824c6ce0 R15: 00007f828241c4b0
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup

