Return-Path: <io-uring+bounces-2324-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C85A9132CB
	for <lists+io-uring@lfdr.de>; Sat, 22 Jun 2024 10:42:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 434C41C211FC
	for <lists+io-uring@lfdr.de>; Sat, 22 Jun 2024 08:42:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4431914B078;
	Sat, 22 Jun 2024 08:42:28 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f208.google.com (mail-il1-f208.google.com [209.85.166.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8BC7149DFF
	for <io-uring@vger.kernel.org>; Sat, 22 Jun 2024 08:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719045748; cv=none; b=XpLPcnVsoyW4sW+g4Alki5bPgod6u7kGyfku2458jY8cJGOrjhluaAsbw0H5o56w0s/aNBBYYKcCBwVwCG80g4fMApsmbj/9AX59qk+yF6kKF0l0C/obHScmMsUG54CM+PMAAK4pJpjkJAC2aocVgEjEt471uCDBGHp6rqHZJOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719045748; c=relaxed/simple;
	bh=lkQC8OcPoiLAIJ+F1lzmdNT/KUX9yKgXj09Imij5Al4=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=XQ8HMyNztIVhjD9Zu7ntj+Xt7Z+/Jw5cEXAc90bRZvcXJ9OJph3/lYBAu6c7uY4G4jDogTnOxdQDA3xC1Gp7y18EWQXlN6BvbbjmZmutHJlczs0QyDz+58JG2u8Z+oMxYiDXf3WmwjJMhoizB5EaviyWUXsAwX0T9rhGT319LzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f208.google.com with SMTP id e9e14a558f8ab-375e4d55457so29534525ab.0
        for <io-uring@vger.kernel.org>; Sat, 22 Jun 2024 01:42:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719045746; x=1719650546;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uF0RKDefBz9SqKwI3Yr8wFRbu9Rfp6DlJ4mlHJgIqEc=;
        b=ZREVaw757TsrjxfCUoxMan4Ls9dMgyH2BEQL8hBCvJo0UynJeZIp10sHImssCoyq81
         AN5doPaX7vVBvpBjpyztptRsaUyDx02S/o9AlvNe2N2Zf48GGOFZVp1nE0Lqg58Lh3EO
         LQfFMR/0OzoqlcocdL4FKL23kNQ1YepL8VNVDA+o83UXzKJSuJ9TTDHD7ZcKtfCDizP2
         WzWb9XdX5aOgO7ukLIDsptPltyGUK4j3ueo4Xe9KpCie/QwFPkkDJgNPJi87bVgzCUzS
         KlD3m6Han/DE6i0pgA1KB1cFLGrM+wWpcWG7j8uLUr6g0j1eP52OD6x/JqpOdJmH9La5
         La+g==
X-Forwarded-Encrypted: i=1; AJvYcCWAkUYdiN9eyecqD+QhfNkWAYmpPv6lLH0I+BXsJX7SrLc6UOidaWd3PZkUrBbW4KYU/Ye9m1Qly+wp7zbGNeKwyhZaVAlAmVs=
X-Gm-Message-State: AOJu0YwCQANzl9wzTD1nWeKPbJPCyu404SRr+Oc3jsV5W+5TRiv57cpe
	kl3prxbDc9ztfkBq3IbR+xWF4qZabicJqQFaYeyhBqOircneUg0/6rbvGztRLA4F9gLL8AYl1wv
	5bpW5iAciFGyjItt6akJuWP9VGWUQ8KWBy5vfYSuFGHz8WIEfoLRCF6s=
X-Google-Smtp-Source: AGHT+IH2fVqz4iZ5igDL6DuNXr3G6oPS8fgfunnAOi4vWXd7Zm5WVmDZVT9gCo4LHPz38RvpyRtmj7UVJ9HHoGXMiBCyKqxNzdwO
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1c4d:b0:375:cab8:f175 with SMTP id
 e9e14a558f8ab-3761d69f09bmr8318055ab.2.1719045745873; Sat, 22 Jun 2024
 01:42:25 -0700 (PDT)
Date: Sat, 22 Jun 2024 01:42:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000000925b0061b7687a2@google.com>
Subject: [syzbot] [io-uring?] KCSAN: data-race in io_submit_sqes /
 io_uring_poll (8)
From: syzbot <syzbot+6a4002279343ac44c448@syzkaller.appspotmail.com>
To: asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    66cc544fd75c Merge tag 'dmaengine-fix-6.10' of git://git.k..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=128ed3da980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=704451bc2941bcb0
dashboard link: https://syzkaller.appspot.com/bug?extid=6a4002279343ac44c448
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/4b6f7aacd04c/disk-66cc544f.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/083bb1b69afe/vmlinux-66cc544f.xz
kernel image: https://storage.googleapis.com/syzbot-assets/05a661578a53/bzImage-66cc544f.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+6a4002279343ac44c448@syzkaller.appspotmail.com

==================================================================
BUG: KCSAN: data-race in io_submit_sqes / io_uring_poll

read-write to 0xffff888107b41870 of 4 bytes by task 4848 on cpu 1:
 io_get_sqe io_uring/io_uring.c:2276 [inline]
 io_submit_sqes+0x23f/0x1080 io_uring/io_uring.c:2327
 __do_sys_io_uring_enter io_uring/io_uring.c:3245 [inline]
 __se_sys_io_uring_enter+0x1c6/0x15a0 io_uring/io_uring.c:3182
 __x64_sys_io_uring_enter+0x78/0x90 io_uring/io_uring.c:3182
 x64_sys_call+0x25ab/0x2d70 arch/x86/include/generated/asm/syscalls_64.h:427
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xc9/0x1c0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

read to 0xffff888107b41870 of 4 bytes by task 4847 on cpu 0:
 io_sqring_full io_uring/io_uring.h:285 [inline]
 io_uring_poll+0xcf/0x190 io_uring/io_uring.c:2739
 vfs_poll include/linux/poll.h:84 [inline]
 __io_arm_poll_handler+0x229/0xf30 io_uring/poll.c:622
 io_arm_poll_handler+0x411/0x5d0 io_uring/poll.c:756
 io_queue_async+0x89/0x320 io_uring/io_uring.c:1943
 io_queue_sqe io_uring/io_uring.c:1972 [inline]
 io_req_task_submit+0xb3/0xc0 io_uring/io_uring.c:1385
 io_handle_tw_list+0x1b9/0x200 io_uring/io_uring.c:1083
 tctx_task_work_run+0x6c/0x1b0 io_uring/io_uring.c:1155
 tctx_task_work+0x40/0x80 io_uring/io_uring.c:1173
 task_work_run+0x13a/0x1a0 kernel/task_work.c:180
 get_signal+0xeee/0x1080 kernel/signal.c:2681
 arch_do_signal_or_restart+0x95/0x4b0 arch/x86/kernel/signal.c:310
 exit_to_user_mode_loop kernel/entry/common.c:111 [inline]
 exit_to_user_mode_prepare include/linux/entry-common.h:328 [inline]
 __syscall_exit_to_user_mode_work kernel/entry/common.c:207 [inline]
 syscall_exit_to_user_mode+0x59/0x130 kernel/entry/common.c:218
 do_syscall_64+0xd6/0x1c0 arch/x86/entry/common.c:89
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

value changed: 0x000003b7 -> 0x000003d5



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

