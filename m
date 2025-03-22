Return-Path: <io-uring+bounces-7188-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EDE8DA6C801
	for <lists+io-uring@lfdr.de>; Sat, 22 Mar 2025 08:06:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 472CD461F7F
	for <lists+io-uring@lfdr.de>; Sat, 22 Mar 2025 07:06:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B361618A6CF;
	Sat, 22 Mar 2025 07:06:25 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f207.google.com (mail-il1-f207.google.com [209.85.166.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F1B4155335
	for <io-uring@vger.kernel.org>; Sat, 22 Mar 2025 07:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742627185; cv=none; b=X4SUfLjWj+59j1iWp9iuYa53QSHRBxD8RHFjAl1q8WlGGzReyuAPxVsjbwcLkWJn4yLNBPzeUSfR04wQu/pv9V3reMSitDgLhugpum7UMhum5hgNl2TEw+3tB6Rpsam8P27rZ0iimzw2PdpzRvZ8UGfUkJ7DCw041mLlOnfudCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742627185; c=relaxed/simple;
	bh=t3bF9u8ElqEleVlp1ripiAK7i3A6Yap4anpntob/Znk=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=l0JN4Ms2aYb/xFClPCka9zMqYEZNFNs1apOBucgqd+Rogj8hNc8mGPMXHTN1uTnaJot3vjcX7AbodU+l8QiReeXlMFY9nyJ+bm7/gxfgdUFsPlxNL/r5wZp45uNqYhXGWtwV5vSawsJZCXwW4AJGmn3cKrXNdR1s863d8XIJSEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f207.google.com with SMTP id e9e14a558f8ab-3d451ad5b2dso38496915ab.0
        for <io-uring@vger.kernel.org>; Sat, 22 Mar 2025 00:06:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742627183; x=1743231983;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2AG8gvkCXOik8hJbx2oD62EDJnPG/t815ZY0Y2MGJPw=;
        b=xKeKd37VtWxHQ1zMFP1OjrR+ljwpZm1c0vAOMzYC8Dx1B4gaNSP9VbQFwJRhQ1/xco
         /GpHvgi0Qwm225cB119EL3zqCj4ekNci1klMSTVdUBY6sU5YaAlhj0Zp5jCnWeNFDiEz
         6K/W0of3b2Ijoy4hsRGw2MRLICpz1lz4Q2DqGBwvW8mXEAiYlklEsR5gLs5CLySqDX1g
         hdbWH3r2XMZ3WIqNlFeBUm3irii6WSgDmk8vaH/gD+DlsL3S4u6jnwixMjn8y/SBuaEv
         OIX4HNEK1y1xKUz5J80IpRhKrcmODSK04rDzVSjsCSsYFqZPSqqUSfSDLBhgHiwnXLMz
         LRGQ==
X-Forwarded-Encrypted: i=1; AJvYcCV6O2aXaWQZMnSxqc6nzQU0uwf3vFpoZMYvfdxAutLN0rgWnQRCFXZnRNTUAIvCIGRAMH3umc8Y9w==@vger.kernel.org
X-Gm-Message-State: AOJu0YyQsgF7JAB7Bj9K2uwnbim1+2gEDtHd3tKi+4mi4Qy65uRPIAIP
	Th81zaQ3SYRSwhqIwlBvKbvJtideYkH93E0Z2KFewBe6oYr4kLLzbyqK+MlRjwC7hJgdqJk28sG
	KK6TV/Z0nMBAi+1jjBGcF9WcxU473Lxmip0gAH52pjyi0R3GRXX8apkQ=
X-Google-Smtp-Source: AGHT+IE12fNTaRb1jMyOX6vNM30nL9juB++J/01+CcLGkYWinm5byDVoQDDQ7nl2l80rRhka1otPNPQiBAsJkPieuTB217LZccGj
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1f01:b0:3d3:d1a8:8e82 with SMTP id
 e9e14a558f8ab-3d595f91c7emr62605955ab.9.1742627183026; Sat, 22 Mar 2025
 00:06:23 -0700 (PDT)
Date: Sat, 22 Mar 2025 00:06:23 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67de616f.050a0220.31a16b.002b.GAE@google.com>
Subject: [syzbot] [io-uring?] WARNING: refcount bug in io_send_zc_cleanup (2)
From: syzbot <syzbot+cf285a028ffba71b2ef5@syzkaller.appspotmail.com>
To: asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    d07de43e3f05 Merge tag 'io_uring-6.14-20250321' of git://g..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=14223004580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=620facf12ff15d10
dashboard link: https://syzkaller.appspot.com/bug?extid=cf285a028ffba71b2ef5
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16be1c4c580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12223004580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/a241563b93db/disk-d07de43e.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/6c435395db14/vmlinux-d07de43e.xz
kernel image: https://storage.googleapis.com/syzbot-assets/59fc4b510cae/bzImage-d07de43e.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+cf285a028ffba71b2ef5@syzkaller.appspotmail.com

------------[ cut here ]------------
refcount_t: underflow; use-after-free.
WARNING: CPU: 0 PID: 5823 at lib/refcount.c:28 refcount_warn_saturate+0x15a/0x1d0 lib/refcount.c:28
Modules linked in:
CPU: 0 UID: 0 PID: 5823 Comm: syz-executor232 Not tainted 6.14.0-rc7-syzkaller-00186-gd07de43e3f05 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/12/2025
RIP: 0010:refcount_warn_saturate+0x15a/0x1d0 lib/refcount.c:28
Code: c0 e1 7f 8c e8 d7 bc 93 fc 90 0f 0b 90 90 eb 99 e8 6b 01 d4 fc c6 05 97 15 38 0b 01 90 48 c7 c7 20 e2 7f 8c e8 b7 bc 93 fc 90 <0f> 0b 90 90 e9 76 ff ff ff e8 48 01 d4 fc c6 05 71 15 38 0b 01 90
RSP: 0018:ffffc90003e8f9c0 EFLAGS: 00010246
RAX: bae32b5aa58f9a00 RBX: ffff88807f4ad8d0 RCX: ffff888034e08000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000003 R08: ffffffff81819d62 R09: fffffbfff1d3a69c
R10: dffffc0000000000 R11: fffffbfff1d3a69c R12: dffffc0000000000
R13: 1ffff11005aa3f80 R14: 1ffff1100fe95af6 R15: ffff88807f4ad7b0
FS:  000055557c8ba480(0000) GS:ffff8880b8600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000020000000022c CR3: 000000003574c000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 io_notif_flush io_uring/notif.h:40 [inline]
 io_send_zc_cleanup+0x121/0x170 io_uring/net.c:1222
 io_clean_op+0x58c/0x9a0 io_uring/io_uring.c:406
 io_free_batch_list io_uring/io_uring.c:1429 [inline]
 __io_submit_flush_completions+0xc16/0xd20 io_uring/io_uring.c:1470
 io_submit_flush_completions io_uring/io_uring.h:159 [inline]
 ctx_flush_and_put io_uring/io_uring.c:1031 [inline]
 io_handle_tw_list+0x473/0x500 io_uring/io_uring.c:1071
 tctx_task_work_run+0x9a/0x370 io_uring/io_uring.c:1123
 tctx_task_work+0x9a/0x100 io_uring/io_uring.c:1141
 task_work_run+0x24f/0x310 kernel/task_work.c:227
 ptrace_notify+0x2d9/0x380 kernel/signal.c:2522
 ptrace_report_syscall include/linux/ptrace.h:415 [inline]
 ptrace_report_syscall_exit include/linux/ptrace.h:477 [inline]
 syscall_exit_work+0xc7/0x1d0 kernel/entry/common.c:173
 syscall_exit_to_user_mode_prepare kernel/entry/common.c:200 [inline]
 __syscall_exit_to_user_mode_work kernel/entry/common.c:205 [inline]
 syscall_exit_to_user_mode+0x24a/0x340 kernel/entry/common.c:218
 do_syscall_64+0x100/0x230 arch/x86/entry/common.c:89
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fda97775569
Code: 48 83 c4 28 c3 e8 37 17 00 00 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffe9ef18ea8 EFLAGS: 00000216 ORIG_RAX: 00000000000001aa
RAX: 0000000000001000 RBX: 0000000000000007 RCX: 00007fda97775569
RDX: 0000000000000000 RSI: 00000000000047bc RDI: 0000000000000007
RBP: 0000200000000480 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000021 R11: 0000000000000216 R12: 000000000000081f
R13: 00002000000000c0 R14: 0000000000000001 R15: 0000000000000001
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

