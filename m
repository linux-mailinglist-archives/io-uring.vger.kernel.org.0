Return-Path: <io-uring+bounces-5198-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EDBB19E3BD1
	for <lists+io-uring@lfdr.de>; Wed,  4 Dec 2024 14:56:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BD972166AA7
	for <lists+io-uring@lfdr.de>; Wed,  4 Dec 2024 13:56:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A4181CDFD2;
	Wed,  4 Dec 2024 13:56:27 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f205.google.com (mail-il1-f205.google.com [209.85.166.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90BD81F666A
	for <io-uring@vger.kernel.org>; Wed,  4 Dec 2024 13:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733320587; cv=none; b=sDWNZQ5Sgj1T1i/yiQx09v8bZW4W3LKdnmemanW4FTdGIeLSdfki4T/Gk84XZsV6Kn48TORUTyfeMroh0sKNqoFdnGOAMUM6soILv9pQorLFt2kWjVRMlwcI088hR2MKAeR84wNYMkYFmWBnART8vKdN9lmjOqi6aod+PSkFmv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733320587; c=relaxed/simple;
	bh=IIqv0YfRrcq4yOjAPt46G57LVEad234saSZ2S7kHmU8=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=OvlxGODQxXGWRqCr13KlaQDpLRAIUabTH6V1oD4Bx9pL7ALetJ2Tfda2l2lwMryX5rULULBY8hoPZ6f80TmOk8u4MUqwSLKCRestpnAVG1C0C/0YcHlCGgdxrIrIRwn5MZ4S0/ubhdUJRVy0YTMhhdNkPecMG6fmLiOgDQ7dSLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f205.google.com with SMTP id e9e14a558f8ab-3a7a1e95f19so75444855ab.1
        for <io-uring@vger.kernel.org>; Wed, 04 Dec 2024 05:56:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733320584; x=1733925384;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PeKQvVqhvqQ9Vgj6AG4YhaLPHD9fEEuLtDLtiQxASck=;
        b=w1x9LTW6GzGRv9WHfwoQD1Z9fXwstot/V5tNPqdLm2Ymb3o+hH89cgXvm/zat0Cw0S
         xplnHNrr/Y9Im/cMXKMwSWotizwM8rHyyxkmpQdDTxzvK7H8GXfEFLyuC0Pa90tjoMLt
         6/A4HODOxZD9bq1sNw1cFGJT97pj2nr7ft654kXtMPs8fQXMNpx1Fox8kmv6FNHq8Sdj
         KOVwbHX/fbM2nKT8Ss3zWGV74IF93iX3Gbt9wDlvMdy9AMetrser9UstPkkbGYOgXUMN
         Qx7w9yrhyYkIGw7LwoO8KU65ubf/ifbxQiieuPnqWXF6GbeigwGa+ZBTYFnQJKv9eeNQ
         jgiw==
X-Forwarded-Encrypted: i=1; AJvYcCUrho5SyGcFbyONDqPo96uiojXd/b9PQyIzfn+zwtBqaD92gpPfdSCpTiY0dHIeeONwpGHS8AMG+g==@vger.kernel.org
X-Gm-Message-State: AOJu0YxkTiB5MZtTDLg8CSHMiOVE8PaSayJjg5l9z/TCCOxKFiI1kYLQ
	/rhZMC42zCXJ9P7KhCACUHQujK0AGuq/cBa73L2uiljeS9JRV0hM3+1uk+9ZKStDtyqszWXEatc
	1YCExBHFx6tc4XVhIERwiSl87npDSl/hVxizySMAokSBKuinfzv1CITw=
X-Google-Smtp-Source: AGHT+IEwne+ZNYYPuUTkWa6QoLT5wSf5ZPppwzlEoKbEroRmt/jwLFqINAbcmY8JM/5X63zl37/pKsn98PMHMhvHoV+pCFjd3ryL
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:3d88:b0:3a7:e86a:e812 with SMTP id
 e9e14a558f8ab-3a7f9a8c510mr89331335ab.17.1733320584741; Wed, 04 Dec 2024
 05:56:24 -0800 (PST)
Date: Wed, 04 Dec 2024 05:56:24 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67505f88.050a0220.17bd51.0069.GAE@google.com>
Subject: [syzbot] [io-uring?] KASAN: null-ptr-deref Write in sys_io_uring_register
From: syzbot <syzbot+092bbab7da235a02a03a@syzkaller.appspotmail.com>
To: asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    c245a7a79602 Add linux-next specific files for 20241203
git tree:       linux-next
console+strace: https://syzkaller.appspot.com/x/log.txt?x=10ae840f980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=af3fe1d01b9e7b7
dashboard link: https://syzkaller.appspot.com/bug?extid=092bbab7da235a02a03a
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14a448df980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15cca330580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/8cc90a2ea120/disk-c245a7a7.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/0f6b1a1a0541/vmlinux-c245a7a7.xz
kernel image: https://storage.googleapis.com/syzbot-assets/9fa3eac09ddc/bzImage-c245a7a7.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+092bbab7da235a02a03a@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: null-ptr-deref in instrument_atomic_read_write include/linux/instrumented.h:96 [inline]
BUG: KASAN: null-ptr-deref in atomic_long_sub_and_test include/linux/atomic/atomic-instrumented.h:4521 [inline]
BUG: KASAN: null-ptr-deref in put_cred_many include/linux/cred.h:255 [inline]
BUG: KASAN: null-ptr-deref in put_cred include/linux/cred.h:269 [inline]
BUG: KASAN: null-ptr-deref in io_unregister_personality io_uring/register.c:82 [inline]
BUG: KASAN: null-ptr-deref in __io_uring_register io_uring/register.c:698 [inline]
BUG: KASAN: null-ptr-deref in __do_sys_io_uring_register io_uring/register.c:902 [inline]
BUG: KASAN: null-ptr-deref in __se_sys_io_uring_register+0x1227/0x3b60 io_uring/register.c:879
Write of size 8 at addr 0000000000000406 by task syz-executor274/5828

CPU: 1 UID: 0 PID: 5828 Comm: syz-executor274 Not tainted 6.13.0-rc1-next-20241203-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 print_report+0xe8/0x550 mm/kasan/report.c:492
 kasan_report+0x143/0x180 mm/kasan/report.c:602
 kasan_check_range+0x282/0x290 mm/kasan/generic.c:189
 instrument_atomic_read_write include/linux/instrumented.h:96 [inline]
 atomic_long_sub_and_test include/linux/atomic/atomic-instrumented.h:4521 [inline]
 put_cred_many include/linux/cred.h:255 [inline]
 put_cred include/linux/cred.h:269 [inline]
 io_unregister_personality io_uring/register.c:82 [inline]
 __io_uring_register io_uring/register.c:698 [inline]
 __do_sys_io_uring_register io_uring/register.c:902 [inline]
 __se_sys_io_uring_register+0x1227/0x3b60 io_uring/register.c:879
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f65bbcb03a9
Code: 48 83 c4 28 c3 e8 37 17 00 00 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffe8fac7478 EFLAGS: 00000246 ORIG_RAX: 00000000000001ab
RAX: ffffffffffffffda RBX: 000000000000371d RCX: 00007f65bbcb03a9
RDX: 0000000000000000 RSI: 000000000000000a RDI: 0000000000000003
RBP: 0000000000000003 R08: 00000000000ac5f8 R09: 00000000000ac5f8
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000001
R13: 00007ffe8fac7648 R14: 0000000000000001 R15: 0000000000000001
 </TASK>
==================================================================


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

