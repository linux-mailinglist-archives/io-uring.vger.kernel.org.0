Return-Path: <io-uring+bounces-2653-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DD56947598
	for <lists+io-uring@lfdr.de>; Mon,  5 Aug 2024 08:53:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9B493280E7A
	for <lists+io-uring@lfdr.de>; Mon,  5 Aug 2024 06:53:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDED9145345;
	Mon,  5 Aug 2024 06:53:18 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E4E513D26B
	for <io-uring@vger.kernel.org>; Mon,  5 Aug 2024 06:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722840798; cv=none; b=JxUQNW1AyKpmKmfOaU0WxnqjzdEuYX8wJTPp+PRqVo0wP2Xf6PhPYgaVIGZvrQuirwtvjmanDHFwytaLeKg9DzI63Omc+485fzgC9FqF53XOOqKh5j9SpK6DsFU3SWaflUZCiSatcQsqh4/1XqdjRcEnNTwFTf1bpFbgtNFrOMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722840798; c=relaxed/simple;
	bh=6tskoPbUuaVcd4fKsAnhVf0sXnpg+uCfl8yU7hFLvrM=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=jkBoputlI/PGaGksGDqfT+wGuQq9L1pWah+dCnFM+2+s8EVcWkhBqFpN/uXsyKElej3/pRuU0GfsAygXlJb8j1grWO8juH5AYxXbsK4vjOCNe8JBWlFOBciU2roqwcdc/YdCJ3puGuFvKSrdjVOHhzpf0idZyJ2vNeLU+fdJxkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-39b28ea6f37so37003305ab.1
        for <io-uring@vger.kernel.org>; Sun, 04 Aug 2024 23:53:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722840796; x=1723445596;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hMZaB1KHBAmqQpT5jdBBE4OUcF/kZf96Fj+w3n+d4pQ=;
        b=SD66Ogyfw6Ti6zEDsFrTLC/afj/yRA6hAToe/dfribOuulz+uNJv+ZowewlxXVCwij
         XwDP1LcFYA1d62U2jFT3NPxFWj9LGkJi593uoQvb2923P/1l99TqMSNU1pzJpycMTtk5
         u6eErsTvmvpst4wKEg2W4kbr0vP8hg83uYz2Njn/jby/404nSJ8QWkq38iEBckcIdnNH
         5md5q2ZM7lkEUauSaZtfT3rtlrjo88FIX4gEzzNA3omXnwrPQVC1CSwJe8GSAgk+yF1R
         37gGDQUl1FuVgSembvNvpwYEEKVxXYtmNQWlZDCIdviCyE9qY+KflQz2/UKmbIfHtzW6
         Y44Q==
X-Forwarded-Encrypted: i=1; AJvYcCVk2XTK/F3Y7LAUpQUaN/zGPDZ55oYniZRurVlG0wzp3AHaidZw6mrxi32/qM+ihqEfGpGwDkMEZsU9LbkOzW07CpSeJ4DjT8s=
X-Gm-Message-State: AOJu0Yz1tp5qNKPguoW332C/PRdnBlEUCMog3wSZaqrFEl2miQIc8M8I
	dOSLX6vQHKP5DrNziNgJDxMc47yNyOtC0RCKUaHAnmhBqOK90u+HiZV5PneoFrTrZ1SiXwCQzGH
	2E77v+ohOPsb04w7pAH17D0sxh6vhoC6MyFhQ4tWuiMoab4T+dfHdhog=
X-Google-Smtp-Source: AGHT+IEVIyNoz1NmttlE1YPg9GPAPhJ8Uhjr5qp8eurleKf2ZpNne3GGPIPlAWuoEwyJUAEcBlK3nJbTpnjRh5brgRZDsIjqK+27
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a6f:b0:398:b1d3:7c9d with SMTP id
 e9e14a558f8ab-39b1fc1fd7dmr8328715ab.3.1722840796508; Sun, 04 Aug 2024
 23:53:16 -0700 (PDT)
Date: Sun, 04 Aug 2024 23:53:16 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ae429e061eea2157@google.com>
Subject: [syzbot] [io-uring?] KCSAN: data-race in __flush_work / __flush_work (2)
From: syzbot <syzbot+b3e4f2f51ed645fd5df2@syzkaller.appspotmail.com>
To: asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    a5dbd76a8942 Merge tag 'x86-urgent-2024-08-04' of git://gi..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13d5a373980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d16924117a4f7e9
dashboard link: https://syzkaller.appspot.com/bug?extid=b3e4f2f51ed645fd5df2
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/ba663ad5dbf5/disk-a5dbd76a.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/226a427d6581/vmlinux-a5dbd76a.xz
kernel image: https://storage.googleapis.com/syzbot-assets/9f982777516a/bzImage-a5dbd76a.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b3e4f2f51ed645fd5df2@syzkaller.appspotmail.com

==================================================================
BUG: KCSAN: data-race in __flush_work / __flush_work

write to 0xffff8881223aa3e8 of 8 bytes by task 3998 on cpu 0:
 instrument_write include/linux/instrumented.h:41 [inline]
 ___set_bit include/asm-generic/bitops/instrumented-non-atomic.h:28 [inline]
 insert_wq_barrier kernel/workqueue.c:3790 [inline]
 start_flush_work kernel/workqueue.c:4142 [inline]
 __flush_work+0x30b/0x570 kernel/workqueue.c:4178
 flush_work kernel/workqueue.c:4229 [inline]
 flush_delayed_work+0x66/0x70 kernel/workqueue.c:4251
 io_fallback_tw+0x24b/0x320 io_uring/io_uring.c:1087
 tctx_task_work_run+0xd1/0x1b0 io_uring/io_uring.c:1099
 tctx_task_work+0x40/0x80 io_uring/io_uring.c:1124
 task_work_run+0x13a/0x1a0 kernel/task_work.c:228
 exit_task_work include/linux/task_work.h:40 [inline]
 do_exit+0x5dd/0x1720 kernel/exit.c:882
 do_group_exit+0x102/0x150 kernel/exit.c:1031
 get_signal+0xf2f/0x1080 kernel/signal.c:2917
 arch_do_signal_or_restart+0x95/0x4b0 arch/x86/kernel/signal.c:310
 exit_to_user_mode_loop kernel/entry/common.c:111 [inline]
 exit_to_user_mode_prepare include/linux/entry-common.h:328 [inline]
 __syscall_exit_to_user_mode_work kernel/entry/common.c:207 [inline]
 syscall_exit_to_user_mode+0x59/0x130 kernel/entry/common.c:218
 do_syscall_64+0xd6/0x1c0 arch/x86/entry/common.c:89
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

read to 0xffff8881223aa3e8 of 8 bytes by task 50 on cpu 1:
 __flush_work+0x42a/0x570 kernel/workqueue.c:4188
 flush_work kernel/workqueue.c:4229 [inline]
 flush_delayed_work+0x66/0x70 kernel/workqueue.c:4251
 io_uring_try_cancel_requests+0x35b/0x370 io_uring/io_uring.c:3000
 io_ring_exit_work+0x148/0x500 io_uring/io_uring.c:2779
 process_one_work kernel/workqueue.c:3231 [inline]
 process_scheduled_works+0x483/0x9a0 kernel/workqueue.c:3312
 worker_thread+0x526/0x700 kernel/workqueue.c:3390
 kthread+0x1d1/0x210 kernel/kthread.c:389
 ret_from_fork+0x4b/0x60 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

value changed: 0x0000000000400000 -> 0xffff88810006c00d

Reported by Kernel Concurrency Sanitizer on:
CPU: 1 UID: 0 PID: 50 Comm: kworker/u8:3 Not tainted 6.11.0-rc1-syzkaller-00334-ga5dbd76a8942 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/27/2024
Workqueue: iou_exit io_ring_exit_work
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

