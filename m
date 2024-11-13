Return-Path: <io-uring+bounces-4643-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 017659C6D6A
	for <lists+io-uring@lfdr.de>; Wed, 13 Nov 2024 12:08:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BB1FC2816C4
	for <lists+io-uring@lfdr.de>; Wed, 13 Nov 2024 11:08:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED7991FDFB1;
	Wed, 13 Nov 2024 11:08:24 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FD961FB728
	for <io-uring@vger.kernel.org>; Wed, 13 Nov 2024 11:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731496104; cv=none; b=lTZ13TJxDTnzO8busEzLfkf8fFXntSh0eLYZ2p7SoH6mxz7cOq7WEXQCpmhnRDmVzgQcWWvfijgm1+Lr4hEMp2J9o6T2tRLvI+bKZ8jkYNVLpTZ7qfAvr5rsJ+NESe8lrSA06PNnkqMCXQQLCkmKMc9IrlV2VI13vaNkoTJcTbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731496104; c=relaxed/simple;
	bh=BttepegVwmZfjhL0wAJzClhZUY/sI0zBSBjji2tJCHA=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=EkjNYPTmLruCxz82YToyn/2YeNyy/llu8lV8npDvGWYt/5o4wToQJFUjgrv1it0wHoxI+XP7EEXuJQRKwxIvRO30IW+lg9tjvu3DS0GOcdU6/nrHFg9a7TgTZCKFB6zQaXLmzNE+D7VofWCtXHgm3sgRlp3uKUOpjkgGLRcADpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3a6b7974696so80975505ab.1
        for <io-uring@vger.kernel.org>; Wed, 13 Nov 2024 03:08:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731496102; x=1732100902;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FxKyyJT3LSMHkt5w14DHewRVHGYzuoWGX77T7Jz2XrE=;
        b=e2MItKoH7HUXKmIb4vJ/JBeezafgMCT7wN7fxrQfpvJI9FHEeQrHTZVAptmHM2iWw4
         UtWqYO38FuFXKS67WE4kBo1bWavOFIUTO5C4iXfbTxfiVGGezJ8aWaY7U4Otmaf4KY7o
         N/ekvbesRsO/fYUAhJE3Ay62kB40Q5NyVU5gLch4fEy0vLJUSrOLRi645+U318+4lNLw
         E7xcVXpJ8qq8MDu9r4fBrMZ8vzOxMGoz77sTk2ZnnGHo3yK/9n29LuAtcPDhJFMIs8gI
         A9lJf8AHMm3W9l9qCWIAfQ442RWl3Wfd72lPUbdfhk7VEHkvYL302ThGGe4hJaLdROpF
         7kTw==
X-Forwarded-Encrypted: i=1; AJvYcCVQMKpW/EFSDfIYls7uMH+OZJVkhzGrdRkTZuk7rB0GbLfBRm39Sy4+gdg22s95mCO/h3hteJQFyw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwS190Weglb3yV1zaEl6m68sekZSeX2tKQrt6gklDP5yzpB9OUR
	qsEXV33KEawIC1Gu1EJ9eiAeTvqqEJbskZ2DBpjPqG2LXy3eAEpyhv0jSpPwnzEMswZh/ZcuVq/
	+OoiwO1X0bWCQkn2dT7pAv52R+EuGfh1ExpeTlxy4jYMZNYfjDSgaTyM=
X-Google-Smtp-Source: AGHT+IFxkz+oqfY40/x239QSKjuhklYHKhhajqoIuStvoJhvimR3uWz0oTt4CTw5EPVKx2zqpnppQrC7I5dQ662lq+Fe4Kw9gHaX
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:144c:b0:3a5:e1a8:8ab1 with SMTP id
 e9e14a558f8ab-3a6f19944bfmr211984735ab.3.1731496102525; Wed, 13 Nov 2024
 03:08:22 -0800 (PST)
Date: Wed, 13 Nov 2024 03:08:22 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <673488a6.050a0220.2a2fcc.000a.GAE@google.com>
Subject: [syzbot] [io-uring?] KCSAN: data-race in __se_sys_io_uring_register /
 io_sqe_files_register (3)
From: syzbot <syzbot+5a486fef3de40e0d8c76@syzkaller.appspotmail.com>
To: asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    2d5404caa8c7 Linux 6.12-rc7
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10e838c0580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=29fedde79f609854
dashboard link: https://syzkaller.appspot.com/bug?extid=5a486fef3de40e0d8c76
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/15a7713979b8/disk-2d5404ca.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/b51c4f695d4a/vmlinux-2d5404ca.xz
kernel image: https://storage.googleapis.com/syzbot-assets/e8c0f17bc00b/bzImage-2d5404ca.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+5a486fef3de40e0d8c76@syzkaller.appspotmail.com

==================================================================
BUG: KCSAN: data-race in __se_sys_io_uring_register / io_sqe_files_register

read-write to 0xffff8881021940b8 of 4 bytes by task 5923 on cpu 1:
 io_sqe_files_register+0x2c4/0x3b0 io_uring/rsrc.c:713
 __io_uring_register io_uring/register.c:403 [inline]
 __do_sys_io_uring_register io_uring/register.c:611 [inline]
 __se_sys_io_uring_register+0x8d0/0x1280 io_uring/register.c:591
 __x64_sys_io_uring_register+0x55/0x70 io_uring/register.c:591
 x64_sys_call+0x202/0x2d60 arch/x86/include/generated/asm/syscalls_64.h:428
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xc9/0x1c0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

read to 0xffff8881021940b8 of 4 bytes by task 5924 on cpu 0:
 __do_sys_io_uring_register io_uring/register.c:613 [inline]
 __se_sys_io_uring_register+0xe4a/0x1280 io_uring/register.c:591
 __x64_sys_io_uring_register+0x55/0x70 io_uring/register.c:591
 x64_sys_call+0x202/0x2d60 arch/x86/include/generated/asm/syscalls_64.h:428
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xc9/0x1c0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

value changed: 0x00000000 -> 0x00000001

Reported by Kernel Concurrency Sanitizer on:
CPU: 0 UID: 0 PID: 5924 Comm: syz.1.1000 Not tainted 6.12.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup

