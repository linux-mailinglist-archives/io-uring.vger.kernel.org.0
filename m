Return-Path: <io-uring+bounces-4046-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F3A289B152F
	for <lists+io-uring@lfdr.de>; Sat, 26 Oct 2024 07:43:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AF5A42831C0
	for <lists+io-uring@lfdr.de>; Sat, 26 Oct 2024 05:43:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 408B886AE3;
	Sat, 26 Oct 2024 05:43:29 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 531746A009
	for <io-uring@vger.kernel.org>; Sat, 26 Oct 2024 05:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729921409; cv=none; b=oHl40pqCbVv64UU7PYtj9cbgymqTTwDvaX9+jOo8q3+pD+ZQAS79y4s8DJP5jpEEeZdbC1yfGvlMhFeJgSjmlBg/DvoEn4QzjK3nm6xLsOpOclYoI2vDxfdcVpb3vy3V6ndV0i39SLKCYXSZUuSJf977rgIcE3deN/0cX8vzxBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729921409; c=relaxed/simple;
	bh=iG3XM4IjDFg4pYlWN0BeyJZy1JumqfoCK7aKPqEZgIY=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=A3Uzbm2zdM21yT85i56n6NeM7Ey4XMJPzABESv+3BSndBO7kuiPcLnfnQyZg9Rk3EZ6RIr0Y85uJXcRKlHBwvKP4WtmX329KvClRM7M8p7GEysIHgwnOPc/sasOOKGKbIHmbDOfa2fQf6dhxiupa8FzbiAPI1FK+RZzrU++9IDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3a3c72d4ac4so24046325ab.3
        for <io-uring@vger.kernel.org>; Fri, 25 Oct 2024 22:43:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729921405; x=1730526205;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bIsQ0oVQ7TY0dQoBRb8Vhdd/HS1uhC5yoJiiqe6eazE=;
        b=LFM5jiUOKmmH4yVr8Zm+m7odidEMK3hpxDO5FbWMFcdXARoN31ZdIWXRQ8p8r6FmNP
         RrHDH0sTxB//lwUyIf8rJintzC9E+lIEx39mgu0qfxej8Da4MyIZ9fRmJpPubA+DcpEm
         EYYm0Ll+ALB41FkXhttKquPm08ar9qDBvkg8xGuuWmjuECxrqbgElyrti8dPsVPypR5T
         O9MY1Zish4rv/ybPveKmS0HqYAujda4h99ehJKSeua1LglCb6uAkgVUZCGZEjOV8WthP
         XepBYKNZtXb8Lv/3GFpWHVXm0voYNQIch7H78lJmjPINkMkt3rIyX+bCQKQ25lJQbfSQ
         zXzw==
X-Forwarded-Encrypted: i=1; AJvYcCXv9XcSHC9bahg0zd8rxCYXI09nZj8kjCEMosrHco4oxQXGLu9Kb5hA0HRM2d1NDul9Ll8/7W3ziQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyvQoxtP9Q7RFtQ+ZXbtyPBrM6dWGg3Y2H4GuZD4U98+RlXrQoc
	JrncBybK7q+19HU6B183Ktn8HwjznU9fo9VyyC6L4B9Gmmakj1NtyG5H+oCow70PNAc+DMqn71F
	ThrpW6ORvgpTIB0hrLoVuq+XenVfl588idqJKfrwPakZHapaz9JHPciI=
X-Google-Smtp-Source: AGHT+IHo2UNmMOmAQCFHqtMd4HZslw8RTLN7XP0PkzzlCL5ERqvCAWpemMY5XygzX/mosEMUwK07VLc3qzjQuVuMKZfI8pBly85M
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1aa2:b0:3a4:e62b:4dfd with SMTP id
 e9e14a558f8ab-3a4ed296312mr13767425ab.7.1729921405430; Fri, 25 Oct 2024
 22:43:25 -0700 (PDT)
Date: Fri, 25 Oct 2024 22:43:25 -0700
In-Reply-To: <67142ff9.050a0220.1e4b4d.002f.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <671c817d.050a0220.2b8c0f.01ad.GAE@google.com>
Subject: Re: [syzbot] [io-uring?] INFO: task hung in io_wq_put_and_exit (4)
From: syzbot <syzbot+58928048fd1416f1457c@syzkaller.appspotmail.com>
To: asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    b423f5a9a61f Merge tag 'acpi-6.12-rc5' of git://git.kernel..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=1393565f980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=fd919c0fc1af4272
dashboard link: https://syzkaller.appspot.com/bug?extid=58928048fd1416f1457c
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=122f04a7980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=132cbe40580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/49d1d501eff9/disk-b423f5a9.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/f973ba06cb5d/vmlinux-b423f5a9.xz
kernel image: https://storage.googleapis.com/syzbot-assets/a97302c30f3f/bzImage-b423f5a9.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+58928048fd1416f1457c@syzkaller.appspotmail.com

INFO: task syz-executor295:5876 blocked for more than 143 seconds.
      Not tainted 6.12.0-rc4-syzkaller-00245-gb423f5a9a61f #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor295 state:D stack:25360 pid:5876  tgid:5876  ppid:5861   flags:0x00024002
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5328 [inline]
 __schedule+0x185a/0x4b70 kernel/sched/core.c:6690
 __schedule_loop kernel/sched/core.c:6767 [inline]
 schedule+0x14b/0x320 kernel/sched/core.c:6782
 schedule_timeout+0xb0/0x310 kernel/time/timer.c:2591
 do_wait_for_common kernel/sched/completion.c:95 [inline]
 __wait_for_common kernel/sched/completion.c:116 [inline]
 wait_for_common kernel/sched/completion.c:127 [inline]
 wait_for_completion+0x355/0x620 kernel/sched/completion.c:148
 io_wq_exit_workers io_uring/io-wq.c:1249 [inline]
 io_wq_put_and_exit+0x344/0x720 io_uring/io-wq.c:1277
 io_uring_clean_tctx+0x168/0x1e0 io_uring/tctx.c:193
 io_uring_cancel_generic+0x76a/0x820 io_uring/io_uring.c:3219
 io_uring_files_cancel include/linux/io_uring.h:20 [inline]
 do_exit+0x6a8/0x28e0 kernel/exit.c:895
 do_group_exit+0x207/0x2c0 kernel/exit.c:1088
 __do_sys_exit_group kernel/exit.c:1099 [inline]
 __se_sys_exit_group kernel/exit.c:1097 [inline]
 __x64_sys_exit_group+0x3f/0x40 kernel/exit.c:1097
 x64_sys_call+0x2634/0x2640 arch/x86/include/generated/asm/syscalls_64.h:232
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fdf6e9370f9
RSP: 002b:00007ffcae28c868 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fdf6e9370f9
RDX: 000000000000003c RSI: 00000000000000e7 RDI: 0000000000000000
RBP: 00007fdf6e9b22d0 R08: ffffffffffffffb8 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007fdf6e9b22d0
R13: 0000000000000000 R14: 00007fdf6e9b2d40 R15: 00007fdf6e908280
 </TASK>
INFO: task syz-executor295:5878 blocked for more than 145 seconds.
      Not tainted 6.12.0-rc4-syzkaller-00245-gb423f5a9a61f #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor295 state:D stack:25136 pid:5878  tgid:5878  ppid:5859   flags:0x00024002
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5328 [inline]
 __schedule+0x185a/0x4b70 kernel/sched/core.c:6690
 __schedule_loop kernel/sched/core.c:6767 [inline]
 schedule+0x14b/0x320 kernel/sched/core.c:6782
 schedule_timeout+0xb0/0x310 kernel/time/timer.c:2591
 do_wait_for_common kernel/sched/completion.c:95 [inline]
 __wait_for_common kernel/sched/completion.c:116 [inline]
 wait_for_common kernel/sched/completion.c:127 [inline]
 wait_for_completion+0x355/0x620 kernel/sched/completion.c:148
 io_wq_exit_workers io_uring/io-wq.c:1249 [inline]
 io_wq_put_and_exit+0x344/0x720 io_uring/io-wq.c:1277
 io_uring_clean_tctx+0x168/0x1e0 io_uring/tctx.c:193
 io_uring_cancel_generic+0x76a/0x820 io_uring/io_uring.c:3219
 io_uring_files_cancel include/linux/io_uring.h:20 [inline]
 do_exit+0x6a8/0x28e0 kernel/exit.c:895
 do_group_exit+0x207/0x2c0 kernel/exit.c:1088
 __do_sys_exit_group kernel/exit.c:1099 [inline]
 __se_sys_exit_group kernel/exit.c:1097 [inline]
 __x64_sys_exit_group+0x3f/0x40 kernel/exit.c:1097
 x64_sys_call+0x2634/0x2640 arch/x86/include/generated/asm/syscalls_64.h:232
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fdf6e9370f9
RSP: 002b:00007ffcae28c868 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fdf6e9370f9
RDX: 000000000000003c RSI: 00000000000000e7 RDI: 0000000000000000
RBP: 00007fdf6e9b22d0 R08: ffffffffffffffb8 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007fdf6e9b22d0
R13: 0000000000000000 R14: 00007fdf6e9b2d40 R15: 00007fdf6e908280
 </TASK>
INFO: task syz-executor295:5880 blocked for more than 147 seconds.
      Not tainted 6.12.0-rc4-syzkaller-00245-gb423f5a9a61f #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor295 state:D stack:25744 pid:5880  tgid:5880  ppid:5855   flags:0x00024002
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5328 [inline]
 __schedule+0x185a/0x4b70 kernel/sched/core.c:6690
 __schedule_loop kernel/sched/core.c:6767 [inline]
 schedule+0x14b/0x320 kernel/sched/core.c:6782
 schedule_timeout+0xb0/0x310 kernel/time/timer.c:2591
 do_wait_for_common kernel/sched/completion.c:95 [inline]
 __wait_for_common kernel/sched/completion.c:116 [inline]
 wait_for_common kernel/sched/completion.c:127 [inline]
 wait_for_completion+0x355/0x620 kernel/sched/completion.c:148
 io_wq_exit_workers io_uring/io-wq.c:1249 [inline]
 io_wq_put_and_exit+0x344/0x720 io_uring/io-wq.c:1277
 io_uring_clean_tctx+0x168/0x1e0 io_uring/tctx.c:193
 io_uring_cancel_generic+0x76a/0x820 io_uring/io_uring.c:3219
 io_uring_files_cancel include/linux/io_uring.h:20 [inline]
 do_exit+0x6a8/0x28e0 kernel/exit.c:895
 do_group_exit+0x207/0x2c0 kernel/exit.c:1088
 __do_sys_exit_group kernel/exit.c:1099 [inline]
 __se_sys_exit_group kernel/exit.c:1097 [inline]
 __x64_sys_exit_group+0x3f/0x40 kernel/exit.c:1097
 x64_sys_call+0x2634/0x2640 arch/x86/include/generated/asm/syscalls_64.h:232
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fdf6e9370f9
RSP: 002b:00007ffcae28c868 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fdf6e9370f9
RDX: 000000000000003c RSI: 00000000000000e7 RDI: 0000000000000000
RBP: 00007fdf6e9b22d0 R08: ffffffffffffffb8 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007fdf6e9b22d0
R13: 0000000000000000 R14: 00007fdf6e9b2d40 R15: 00007fdf6e908280
 </TASK>
INFO: task syz-executor295:5884 blocked for more than 148 seconds.
      Not tainted 6.12.0-rc4-syzkaller-00245-gb423f5a9a61f #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor295 state:D stack:25744 pid:5884  tgid:5884  ppid:5856   flags:0x00024002
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5328 [inline]
 __schedule+0x185a/0x4b70 kernel/sched/core.c:6690
 __schedule_loop kernel/sched/core.c:6767 [inline]
 schedule+0x14b/0x320 kernel/sched/core.c:6782
 schedule_timeout+0xb0/0x310 kernel/time/timer.c:2591
 do_wait_for_common kernel/sched/completion.c:95 [inline]
 __wait_for_common kernel/sched/completion.c:116 [inline]
 wait_for_common kernel/sched/completion.c:127 [inline]
 wait_for_completion+0x355/0x620 kernel/sched/completion.c:148
 io_wq_exit_workers io_uring/io-wq.c:1249 [inline]
 io_wq_put_and_exit+0x344/0x720 io_uring/io-wq.c:1277
 io_uring_clean_tctx+0x168/0x1e0 io_uring/tctx.c:193
 io_uring_cancel_generic+0x76a/0x820 io_uring/io_uring.c:3219
 io_uring_files_cancel include/linux/io_uring.h:20 [inline]
 do_exit+0x6a8/0x28e0 kernel/exit.c:895
 do_group_exit+0x207/0x2c0 kernel/exit.c:1088
 __do_sys_exit_group kernel/exit.c:1099 [inline]
 __se_sys_exit_group kernel/exit.c:1097 [inline]
 __x64_sys_exit_group+0x3f/0x40 kernel/exit.c:1097
 x64_sys_call+0x2634/0x2640 arch/x86/include/generated/asm/syscalls_64.h:232
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fdf6e9370f9
RSP: 002b:00007ffcae28c868 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fdf6e9370f9
RDX: 000000000000003c RSI: 00000000000000e7 RDI: 0000000000000000
RBP: 00007fdf6e9b22d0 R08: ffffffffffffffb8 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007fdf6e9b22d0
R13: 0000000000000000 R14: 00007fdf6e9b2d40 R15: 00007fdf6e908280
 </TASK>
INFO: task syz-executor295:5887 blocked for more than 150 seconds.
      Not tainted 6.12.0-rc4-syzkaller-00245-gb423f5a9a61f #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor295 state:D stack:25360 pid:5887  tgid:5887  ppid:5862   flags:0x00024002
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5328 [inline]
 __schedule+0x185a/0x4b70 kernel/sched/core.c:6690
 __schedule_loop kernel/sched/core.c:6767 [inline]
 schedule+0x14b/0x320 kernel/sched/core.c:6782
 schedule_timeout+0xb0/0x310 kernel/time/timer.c:2591
 do_wait_for_common kernel/sched/completion.c:95 [inline]
 __wait_for_common kernel/sched/completion.c:116 [inline]
 wait_for_common kernel/sched/completion.c:127 [inline]
 wait_for_completion+0x355/0x620 kernel/sched/completion.c:148
 io_wq_exit_workers io_uring/io-wq.c:1249 [inline]
 io_wq_put_and_exit+0x344/0x720 io_uring/io-wq.c:1277
 io_uring_clean_tctx+0x168/0x1e0 io_uring/tctx.c:193
 io_uring_cancel_generic+0x76a/0x820 io_uring/io_uring.c:3219
 io_uring_files_cancel include/linux/io_uring.h:20 [inline]
 do_exit+0x6a8/0x28e0 kernel/exit.c:895
 do_group_exit+0x207/0x2c0 kernel/exit.c:1088
 __do_sys_exit_group kernel/exit.c:1099 [inline]
 __se_sys_exit_group kernel/exit.c:1097 [inline]
 __x64_sys_exit_group+0x3f/0x40 kernel/exit.c:1097
 x64_sys_call+0x2634/0x2640 arch/x86/include/generated/asm/syscalls_64.h:232
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fdf6e9370f9
RSP: 002b:00007ffcae28c868 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fdf6e9370f9
RDX: 000000000000003c RSI: 00000000000000e7 RDI: 0000000000000000
RBP: 00007fdf6e9b22d0 R08: ffffffffffffffb8 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007fdf6e9b22d0
R13: 0000000000000000 R14: 00007fdf6e9b2d40 R15: 00007fdf6e908280
 </TASK>

Showing all locks held in the system:
3 locks held by kworker/u8:0/11:
1 lock held by khungtaskd/30:
 #0: ffffffff8e937e20 (rcu_read_lock){....}-{1:2}, at: rcu_lock_acquire include/linux/rcupdate.h:337 [inline]
 #0: ffffffff8e937e20 (rcu_read_lock){....}-{1:2}, at: rcu_read_lock include/linux/rcupdate.h:849 [inline]
 #0: ffffffff8e937e20 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x55/0x2a0 kernel/locking/lockdep.c:6720
3 locks held by kworker/u8:2/35:
3 locks held by kworker/u8:3/52:
3 locks held by kworker/u8:5/148:
2 locks held by getty/5585:
 #0: ffff88803153f0a0 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x25/0x70 drivers/tty/tty_ldisc.c:243
 #1: ffffc90002f062f0 (&ldata->atomic_read_lock){+.+.}-{3:3}, at: n_tty_read+0x6a6/0x1e00 drivers/tty/n_tty.c:2211
1 lock held by iou-wrk-5876/5877:
1 lock held by iou-wrk-5878/5881:
3 locks held by kworker/u8:1/5879:
1 lock held by iou-wrk-5880/5882:
1 lock held by iou-wrk-5884/5885:
1 lock held by iou-wrk-5887/5888:

=============================================

NMI backtrace for cpu 1
CPU: 1 UID: 0 PID: 30 Comm: khungtaskd Not tainted 6.12.0-rc4-syzkaller-00245-gb423f5a9a61f #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 nmi_cpu_backtrace+0x49c/0x4d0 lib/nmi_backtrace.c:113
 nmi_trigger_cpumask_backtrace+0x198/0x320 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:162 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:223 [inline]
 watchdog+0xff4/0x1040 kernel/hung_task.c:379
 kthread+0x2f0/0x390 kernel/kthread.c:389
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 UID: 0 PID: 5888 Comm: iou-wrk-5887 Not tainted 6.12.0-rc4-syzkaller-00245-gb423f5a9a61f #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
RIP: 0010:unwind_next_frame+0x17b5/0x22d0 arch/x86/kernel/unwind_orc.c:664
Code: 01 c6 49 8d 55 40 4c 89 ef e8 37 0e 00 00 84 c0 0f 84 66 01 00 00 49 bc 00 00 00 00 00 fc ff df 48 8b 44 24 20 42 0f b6 04 20 <84> c0 0f 85 36 08 00 00 48 8b 6c 24 08 8b 84 24 84 00 00 00 39 45
RSP: 0018:ffffc900041771d0 EFLAGS: 00000202
RAX: 0000000000000000 RBX: ffffffff90add366 RCX: 0000000000000000
RDX: dffffc0000000000 RSI: ffffc90004170000 RDI: ffffc90004177658
RBP: dffffc0000000000 R08: ffffc90004177658 R09: 0000000000000000
R10: ffffc900041772f0 R11: fffff5200082ee60 R12: dffffc0000000000
R13: ffffc900041772a0 R14: ffffffff81fb4fe6 R15: ffffc900041772f0
FS:  000055559112e380(0000) GS:ffff8880b8600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055a37bfd3600 CR3: 0000000032e0a000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <NMI>


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

