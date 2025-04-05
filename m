Return-Path: <io-uring+bounces-7416-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 00AADA7C917
	for <lists+io-uring@lfdr.de>; Sat,  5 Apr 2025 14:30:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6C215189984A
	for <lists+io-uring@lfdr.de>; Sat,  5 Apr 2025 12:30:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 328541E5B7C;
	Sat,  5 Apr 2025 12:30:06 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 479281E5217
	for <io-uring@vger.kernel.org>; Sat,  5 Apr 2025 12:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743856206; cv=none; b=PJG+9gl2NFGtrrtvnLDTFvg1+LB+wr7gQcM5Si/qnJmhczRArfqj6mtPYgBqiZJCmIOuSlxlFmd6VQwDUlmQ2pSgGK6GYIchbv+msSLu8GYl+OQ+5Gc0pCKrax0FZFPodrAQowqq6b/SRrNRgU+FR5mthcVxwNXKQcb482tK8RI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743856206; c=relaxed/simple;
	bh=Jv29XiEWWp8oDJ1NzImIyXE8eeckhaM8RLs9PpNuQEU=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=EFK857nZRkkDsHaVOLz+wVj+vlwII5pxyDXYe75vB3m3lNVpf5M6/VQwoxuKQ6YxUg0AJVruBi9LmcA6ZgHrzvFvGWvNKzi5SIbA9fMpOO8CSqp82JAdhsOZpQfALajYrS/IWvx9XH5MNzaKN6gEwBQ34IK3dJxKOA+UVbRumIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3d43b460970so60202415ab.2
        for <io-uring@vger.kernel.org>; Sat, 05 Apr 2025 05:30:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743856203; x=1744461003;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BsWZGaUwGSYyvlgaO7DAahj15TOUicmvbWsBvTMNy1Q=;
        b=AeYDYCgwhY9LUqZZ+UEXKQpC0AAFINp3p0zUjITVNnG983+ybTu1cZ0nOI16o+RonP
         TgD09GMq3qnbvDks55qHdKv089gFP/unQxgeRFjoMBIqYHvtwm/G3jQyQycW25OAf0qf
         i5ny1H/lXfDzgK3ymG69Rx8gKMt4HBfVgokM1lwLyMPH7jE9h5ChU/mMUqeFbncX9AcI
         aJQLGHBbMekCsl1d6wnyhgjyJV0WaZ6SN4c7udc2fxPbYtvNrDy6ByOwmL4YEJH7I0FB
         7X7H0iBXGCgbF7O4h5HQT34NoF5oZLAiZmT+GX26kq7YbZRI77bw4YOmclA1qRH1Chv8
         PQGw==
X-Forwarded-Encrypted: i=1; AJvYcCVfhRk1nlZAWIfEwEofCSI+bB+FpKydcnsZ3uu0A7WxvTuG9HcsDiyw25j+cgR6PkmqdTX3yzFHbA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwQkWmLoNzapp3Mw/mpPJG2nbwh2saO4TACBReyldofYnzmhhci
	Ti2sE+RlcZVcAjKk2yKtzKMe/+JPWlamx6OpW6UFqi07CCJ9X2BgZ0sdXRs4/bYzRznCy9VZqBK
	7BKsJwbion4OqPvyxt6CRAeFlOMq0cV7fxLfUWmWXc3cgKiSwwnxO+B8=
X-Google-Smtp-Source: AGHT+IFUvnTNoYo+63VRPiMThILr+p2GvOT33z9m/c2TRSJ035imEQGLsa7a6ute9wI7lgkUj3EvZgXQOCvc7Cm3OIgIVnPRg5S6
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:3789:b0:3d0:4e0c:2c96 with SMTP id
 e9e14a558f8ab-3d6e52f0481mr62556225ab.2.1743856203449; Sat, 05 Apr 2025
 05:30:03 -0700 (PDT)
Date: Sat, 05 Apr 2025 05:30:03 -0700
In-Reply-To: <67159ae6-3dd9-4d40-a6b1-643d18e8b3a1@kernel.dk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67f1224b.050a0220.0a13.0239.GAE@google.com>
Subject: Re: [syzbot] [io-uring?] INFO: task hung in io_wq_put_and_exit (4)
From: syzbot <syzbot+58928048fd1416f1457c@syzkaller.appspotmail.com>
To: asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
INFO: task hung in io_wq_put_and_exit

INFO: task syz.0.15:6739 blocked for more than 143 seconds.
      Not tainted 6.14.0-syzkaller-00001-g626e6212aaf6 #0
      Blocked by coredump.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.0.15        state:D stack:23744 pid:6739  tgid:6738  ppid:6553   task_flags:0x400548 flags:0x00024000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5378 [inline]
 __schedule+0x18bc/0x4c40 kernel/sched/core.c:6765
 __schedule_loop kernel/sched/core.c:6842 [inline]
 schedule+0x14b/0x320 kernel/sched/core.c:6857
 schedule_timeout+0xb0/0x290 kernel/time/sleep_timeout.c:75
 do_wait_for_common kernel/sched/completion.c:95 [inline]
 __wait_for_common kernel/sched/completion.c:116 [inline]
 wait_for_common kernel/sched/completion.c:127 [inline]
 wait_for_completion+0x355/0x620 kernel/sched/completion.c:148
 io_wq_exit_workers io_uring/io-wq.c:1262 [inline]
 io_wq_put_and_exit+0x344/0x720 io_uring/io-wq.c:1290
 io_uring_clean_tctx+0x168/0x1e0 io_uring/tctx.c:205
 io_uring_cancel_generic+0x751/0x800 io_uring/io_uring.c:3183
 io_uring_files_cancel include/linux/io_uring.h:19 [inline]
 do_exit+0x6a3/0x2940 kernel/exit.c:894
 do_group_exit+0x207/0x2c0 kernel/exit.c:1087
 get_signal+0x16b2/0x1750 kernel/signal.c:3036
 arch_do_signal_or_restart+0x96/0x860 arch/x86/kernel/signal.c:337
 exit_to_user_mode_loop kernel/entry/common.c:111 [inline]
 exit_to_user_mode_prepare include/linux/entry-common.h:329 [inline]
 __syscall_exit_to_user_mode_work kernel/entry/common.c:207 [inline]
 syscall_exit_to_user_mode+0xce/0x340 kernel/entry/common.c:218
 do_syscall_64+0x100/0x230 arch/x86/entry/common.c:89
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f2dc697e719
RSP: 002b:00007f2dc77490e8 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
RAX: fffffffffffffe00 RBX: 00007f2dc6b35f88 RCX: 00007f2dc697e719
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 00007f2dc6b35f88
RBP: 00007f2dc6b35f80 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f2dc6b35f8c
R13: 0000000000000000 R14: 00007ffdb8b1f290 R15: 00007ffdb8b1f378
 </TASK>
INFO: task syz.4.19:6783 blocked for more than 146 seconds.
      Not tainted 6.14.0-syzkaller-00001-g626e6212aaf6 #0
      Blocked by coredump.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.4.19        state:D stack:25696 pid:6783  tgid:6779  ppid:6564   task_flags:0x400548 flags:0x00024000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5378 [inline]
 __schedule+0x18bc/0x4c40 kernel/sched/core.c:6765
 __schedule_loop kernel/sched/core.c:6842 [inline]
 schedule+0x14b/0x320 kernel/sched/core.c:6857
 schedule_timeout+0xb0/0x290 kernel/time/sleep_timeout.c:75
 do_wait_for_common kernel/sched/completion.c:95 [inline]
 __wait_for_common kernel/sched/completion.c:116 [inline]
 wait_for_common kernel/sched/completion.c:127 [inline]
 wait_for_completion+0x355/0x620 kernel/sched/completion.c:148
 io_wq_exit_workers io_uring/io-wq.c:1262 [inline]
 io_wq_put_and_exit+0x344/0x720 io_uring/io-wq.c:1290
 io_uring_clean_tctx+0x168/0x1e0 io_uring/tctx.c:205
 io_uring_cancel_generic+0x751/0x800 io_uring/io_uring.c:3183
 io_uring_files_cancel include/linux/io_uring.h:19 [inline]
 do_exit+0x6a3/0x2940 kernel/exit.c:894
 do_group_exit+0x207/0x2c0 kernel/exit.c:1087
 get_signal+0x16b2/0x1750 kernel/signal.c:3036
 arch_do_signal_or_restart+0x96/0x860 arch/x86/kernel/signal.c:337
 exit_to_user_mode_loop kernel/entry/common.c:111 [inline]
 exit_to_user_mode_prepare include/linux/entry-common.h:329 [inline]
 __syscall_exit_to_user_mode_work kernel/entry/common.c:207 [inline]
 syscall_exit_to_user_mode+0xce/0x340 kernel/entry/common.c:218
 do_syscall_64+0x100/0x230 arch/x86/entry/common.c:89
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f6cf337e719
RSP: 002b:00007f6cf40d00e8 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
RAX: fffffffffffffe00 RBX: 00007f6cf3535f88 RCX: 00007f6cf337e719
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 00007f6cf3535f88
RBP: 00007f6cf3535f80 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f6cf3535f8c
R13: 0000000000000000 R14: 00007ffd41156d10 R15: 00007ffd41156df8
 </TASK>
INFO: task syz.2.17:6784 blocked for more than 148 seconds.
      Not tainted 6.14.0-syzkaller-00001-g626e6212aaf6 #0
      Blocked by coredump.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.2.17        state:D stack:23744 pid:6784  tgid:6780  ppid:6562   task_flags:0x400548 flags:0x00024000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5378 [inline]
 __schedule+0x18bc/0x4c40 kernel/sched/core.c:6765
 __schedule_loop kernel/sched/core.c:6842 [inline]
 schedule+0x14b/0x320 kernel/sched/core.c:6857
 schedule_timeout+0xb0/0x290 kernel/time/sleep_timeout.c:75
 do_wait_for_common kernel/sched/completion.c:95 [inline]
 __wait_for_common kernel/sched/completion.c:116 [inline]
 wait_for_common kernel/sched/completion.c:127 [inline]
 wait_for_completion+0x355/0x620 kernel/sched/completion.c:148
 io_wq_exit_workers io_uring/io-wq.c:1262 [inline]
 io_wq_put_and_exit+0x344/0x720 io_uring/io-wq.c:1290
 io_uring_clean_tctx+0x168/0x1e0 io_uring/tctx.c:205
 io_uring_cancel_generic+0x751/0x800 io_uring/io_uring.c:3183
 io_uring_files_cancel include/linux/io_uring.h:19 [inline]
 do_exit+0x6a3/0x2940 kernel/exit.c:894
 do_group_exit+0x207/0x2c0 kernel/exit.c:1087
 get_signal+0x16b2/0x1750 kernel/signal.c:3036
 arch_do_signal_or_restart+0x96/0x860 arch/x86/kernel/signal.c:337
 exit_to_user_mode_loop kernel/entry/common.c:111 [inline]
 exit_to_user_mode_prepare include/linux/entry-common.h:329 [inline]
 __syscall_exit_to_user_mode_work kernel/entry/common.c:207 [inline]
 syscall_exit_to_user_mode+0xce/0x340 kernel/entry/common.c:218
 do_syscall_64+0x100/0x230 arch/x86/entry/common.c:89
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fbb9517e719
RSP: 002b:00007fbb95f3b0e8 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
RAX: fffffffffffffe00 RBX: 00007fbb95335f88 RCX: 00007fbb9517e719
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 00007fbb95335f88
RBP: 00007fbb95335f80 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007fbb95335f8c
R13: 0000000000000000 R14: 00007ffc20ba6bf0 R15: 00007ffc20ba6cd8
 </TASK>
INFO: task syz.3.18:6820 blocked for more than 151 seconds.
      Not tainted 6.14.0-syzkaller-00001-g626e6212aaf6 #0
      Blocked by coredump.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.3.18        state:D stack:25184 pid:6820  tgid:6819  ppid:6563   task_flags:0x400548 flags:0x00024000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5378 [inline]
 __schedule+0x18bc/0x4c40 kernel/sched/core.c:6765
 __schedule_loop kernel/sched/core.c:6842 [inline]
 schedule+0x14b/0x320 kernel/sched/core.c:6857
 schedule_timeout+0xb0/0x290 kernel/time/sleep_timeout.c:75
 do_wait_for_common kernel/sched/completion.c:95 [inline]
 __wait_for_common kernel/sched/completion.c:116 [inline]
 wait_for_common kernel/sched/completion.c:127 [inline]
 wait_for_completion+0x355/0x620 kernel/sched/completion.c:148
 io_wq_exit_workers io_uring/io-wq.c:1262 [inline]
 io_wq_put_and_exit+0x344/0x720 io_uring/io-wq.c:1290
 io_uring_clean_tctx+0x168/0x1e0 io_uring/tctx.c:205
 io_uring_cancel_generic+0x751/0x800 io_uring/io_uring.c:3183
 io_uring_files_cancel include/linux/io_uring.h:19 [inline]
 do_exit+0x6a3/0x2940 kernel/exit.c:894


Tested on:

commit:         626e6212 io_uring/kbuf: conditional schedule on buffer..
git tree:       git://git.kernel.dk/linux.git syztest
console output: https://syzkaller.appspot.com/x/log.txt?x=105c9b4c580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a3f7ddbc4e0c74f1
dashboard link: https://syzkaller.appspot.com/bug?extid=58928048fd1416f1457c
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Note: no patches were applied.

