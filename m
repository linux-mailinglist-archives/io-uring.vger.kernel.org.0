Return-Path: <io-uring+bounces-8784-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C991B0F5A7
	for <lists+io-uring@lfdr.de>; Wed, 23 Jul 2025 16:44:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D83F0179263
	for <lists+io-uring@lfdr.de>; Wed, 23 Jul 2025 14:44:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A986C2F4A1E;
	Wed, 23 Jul 2025 14:44:31 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f80.google.com (mail-io1-f80.google.com [209.85.166.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88F072EB5A9
	for <io-uring@vger.kernel.org>; Wed, 23 Jul 2025 14:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753281871; cv=none; b=hM24aCxOsFhAhtxfael98BgVuwwqW4SnHUGgEivF31lUB8jUBLn3pzROAUI1usFMN3XcT1PM1LKdUVnSpSAXZcC4VBRDzYTFYRtl9/sZVm8pFwMvAUh/hcXl0o6F4K602xyzji73Mjc3PG4VRYYPUEW6HYM7oe8fs1/HU991hFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753281871; c=relaxed/simple;
	bh=J2EzqFZiiazR3AYyUaJbyQwZKjPi0p1xA1cEQ3mj0rM=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=qPBErt86hJUx6NQBtVmkpshHDm1RBgiyF4TzT+0Il5yNqOsTrom5du8LaccJ87p+5BKvL99Xg/tNB+PJPzDfr4s19Jxan6yMM4qQ6BnaNc9PoE2BNQSXv+mVYRdjovPqjFyNhL69x5PPgQ/rAEbpLpcK2vl045WRjwfhq82ree0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f80.google.com with SMTP id ca18e2360f4ac-87c306a1b38so370466239f.1
        for <io-uring@vger.kernel.org>; Wed, 23 Jul 2025 07:44:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753281868; x=1753886668;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=f/Qo5veLzhQrZbJCtv8Yg+XwBjjhyIBA5terVLyQjJ0=;
        b=ZepEf/Bk//w3WQYfXGcD7yhDR7BXobfXhUgzc/TJW4dg7SowxLzAqs5pt668u/fuSi
         hmBoSQr+aZYejOjC10QrzkmTe3/WoR7LexytdIem/Z1oBJbmJN0XbZQ2HxOuNaQkQ8jR
         RVexO99wPd2nN57WvKYkkeUX+wSaoImaWCVIu+MxxzLq3mtNfCaaxnpU6JM5Mpx0ypbZ
         52mXjEOnWjc0KVFAQo7XFJRNnaAqVKboVJtsCoKsXmC22ZosEiDJbjU12nw0Y5VmfAPM
         u1EGtaf2IiJKmIO409Uv8x1MvN8RbLoteRfNa5/eG1ehu9VfJiNhJ2Pw7DXv1vQW+yEt
         Htog==
X-Forwarded-Encrypted: i=1; AJvYcCWTVbs/nYy3XVwKm9/cZEjHuY0kq1k70AYBL2LdWbl6U3iDGqWRlnEf9yhvpYiLwamAAsYaInzixg==@vger.kernel.org
X-Gm-Message-State: AOJu0YywkkhJUCxmFWlGMvSgoB4be+K+boK5d+zdY6qGVnWi6bhHO5QQ
	muzOpH0XFJe1U6V3+m6C+taBAq3EkJlDnTrQxwvIwsOvjJ4X7+g31R2zSAS4SDxxvNExr8yFAgm
	I7pyVIRsa3oUiVt+cKI1JKpRIzCZSbaI+KiYn/wCQ1y92s9We20pz44oUOLM=
X-Google-Smtp-Source: AGHT+IH/bZTUXapN1C1WSSJ/Htyw/UOAPNqevCYm/BxY8VWa2dOwisSPsMgrFat4dA0UVlS9ncc3O1T5FlPXRF2tD+k8kj43UuXR
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:3fcc:b0:87c:3872:6787 with SMTP id
 ca18e2360f4ac-87c64f3ff78mr602917039f.1.1753281868315; Wed, 23 Jul 2025
 07:44:28 -0700 (PDT)
Date: Wed, 23 Jul 2025 07:44:28 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6880f54c.050a0220.248954.0000.GAE@google.com>
Subject: [syzbot] [input?] [usb?] [io-uring?] INFO: task hung in
 io_wq_put_and_exit (5)
From: syzbot <syzbot+e328767eafd849df0a78@syzkaller.appspotmail.com>
To: anna-maria@linutronix.de, asml.silence@gmail.com, axboe@kernel.dk, 
	frederic@kernel.org, io-uring@vger.kernel.org, linux-input@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com, tglx@linutronix.de
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    bf61759db409 Merge tag 'sched_ext-for-6.16-rc6-fixes' of g..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=12b877d4580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=415e83411fefd73f
dashboard link: https://syzkaller.appspot.com/bug?extid=e328767eafd849df0a78
compiler:       gcc (Debian 12.2.0-14+deb12u1) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=110b938c580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1622a38c580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/22c5f1286a72/disk-bf61759d.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/cc79af4d966c/vmlinux-bf61759d.xz
kernel image: https://storage.googleapis.com/syzbot-assets/b2e6d621f424/bzImage-bf61759d.xz

The issue was bisected to:

commit e5598d6ae62626d261b046a2f19347c38681ff51
Author: Pavel Begunkov <asml.silence@gmail.com>
Date:   Thu Aug 24 22:53:31 2023 +0000

    io_uring: compact SQ/CQ heads/tails

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=12c92b82580000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=11c92b82580000
console output: https://syzkaller.appspot.com/x/log.txt?x=16c92b82580000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e328767eafd849df0a78@syzkaller.appspotmail.com
Fixes: e5598d6ae626 ("io_uring: compact SQ/CQ heads/tails")

INFO: task syz-executor971:5849 blocked for more than 143 seconds.
      Not tainted 6.16.0-rc6-syzkaller-00279-gbf61759db409 #0
      Blocked by coredump.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor971 state:D stack:26488 pid:5849  tgid:5849  ppid:5844   task_flags:0x400148 flags:0x00024002
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5397 [inline]
 __schedule+0x116a/0x5de0 kernel/sched/core.c:6786
 __schedule_loop kernel/sched/core.c:6864 [inline]
 schedule+0xe7/0x3a0 kernel/sched/core.c:6879
 schedule_timeout+0x257/0x290 kernel/time/sleep_timeout.c:75
 do_wait_for_common kernel/sched/completion.c:95 [inline]
 __wait_for_common+0x2ff/0x4e0 kernel/sched/completion.c:116
 io_wq_exit_workers io_uring/io-wq.c:1319 [inline]
 io_wq_put_and_exit+0x271/0x8d0 io_uring/io-wq.c:1347
 io_uring_clean_tctx+0x10d/0x190 io_uring/tctx.c:203
 io_uring_cancel_generic+0x69c/0x9a0 io_uring/io_uring.c:3212
 io_uring_files_cancel include/linux/io_uring.h:19 [inline]
 do_exit+0x2ce/0x2bd0 kernel/exit.c:911
 do_group_exit+0xd3/0x2a0 kernel/exit.c:1105
 __do_sys_exit_group kernel/exit.c:1116 [inline]
 __se_sys_exit_group kernel/exit.c:1114 [inline]
 __x64_sys_exit_group+0x3e/0x50 kernel/exit.c:1114
 x64_sys_call+0x1530/0x1730 arch/x86/include/generated/asm/syscalls_64.h:232
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xcd/0x4c0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f141ec08e39
RSP: 002b:00007ffcd1b0b6e8 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f141ec08e39
RDX: 000000000000003c RSI: 00000000000000e7 RDI: 0000000000000000
RBP: 00007f141ec843b0 R08: ffffffffffffffb8 R09: 0000000000000000
R10: 000000000000000e R11: 0000000000000246 R12: 00007f141ec843b0
R13: 0000000000000000 R14: 00007f141ec880c0 R15: 00007f141ebd7020
 </TASK>
INFO: task syz-executor971:5850 blocked for more than 143 seconds.
      Not tainted 6.16.0-rc6-syzkaller-00279-gbf61759db409 #0
      Blocked by coredump.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor971 state:D stack:26488 pid:5850  tgid:5850  ppid:5846   task_flags:0x400148 flags:0x00024002
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5397 [inline]
 __schedule+0x116a/0x5de0 kernel/sched/core.c:6786
 __schedule_loop kernel/sched/core.c:6864 [inline]
 schedule+0xe7/0x3a0 kernel/sched/core.c:6879
 schedule_timeout+0x257/0x290 kernel/time/sleep_timeout.c:75
 do_wait_for_common kernel/sched/completion.c:95 [inline]
 __wait_for_common+0x2ff/0x4e0 kernel/sched/completion.c:116
 io_wq_exit_workers io_uring/io-wq.c:1319 [inline]
 io_wq_put_and_exit+0x271/0x8d0 io_uring/io-wq.c:1347
 io_uring_clean_tctx+0x10d/0x190 io_uring/tctx.c:203
 io_uring_cancel_generic+0x69c/0x9a0 io_uring/io_uring.c:3212
 io_uring_files_cancel include/linux/io_uring.h:19 [inline]
 do_exit+0x2ce/0x2bd0 kernel/exit.c:911
 do_group_exit+0xd3/0x2a0 kernel/exit.c:1105
 __do_sys_exit_group kernel/exit.c:1116 [inline]
 __se_sys_exit_group kernel/exit.c:1114 [inline]
 __x64_sys_exit_group+0x3e/0x50 kernel/exit.c:1114
 x64_sys_call+0x1530/0x1730 arch/x86/include/generated/asm/syscalls_64.h:232
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xcd/0x4c0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f141ec08e39
RSP: 002b:00007ffcd1b0b6e8 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f141ec08e39
RDX: 000000000000003c RSI: 00000000000000e7 RDI: 0000000000000000
RBP: 00007f141ec843b0 R08: ffffffffffffffb8 R09: 0000000000000000
R10: 000000000000000e R11: 0000000000000246 R12: 00007f141ec843b0
R13: 0000000000000000 R14: 00007f141ec880c0 R15: 00007f141ebd7020
 </TASK>
INFO: task syz-executor971:5851 blocked for more than 143 seconds.
      Not tainted 6.16.0-rc6-syzkaller-00279-gbf61759db409 #0
      Blocked by coredump.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor971 state:D stack:27256 pid:5851  tgid:5851  ppid:5845   task_flags:0x400148 flags:0x00024002
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5397 [inline]
 __schedule+0x116a/0x5de0 kernel/sched/core.c:6786
 __schedule_loop kernel/sched/core.c:6864 [inline]
 schedule+0xe7/0x3a0 kernel/sched/core.c:6879
 schedule_timeout+0x257/0x290 kernel/time/sleep_timeout.c:75
 do_wait_for_common kernel/sched/completion.c:95 [inline]
 __wait_for_common+0x2ff/0x4e0 kernel/sched/completion.c:116
 io_wq_exit_workers io_uring/io-wq.c:1319 [inline]
 io_wq_put_and_exit+0x271/0x8d0 io_uring/io-wq.c:1347
 io_uring_clean_tctx+0x10d/0x190 io_uring/tctx.c:203
 io_uring_cancel_generic+0x69c/0x9a0 io_uring/io_uring.c:3212
 io_uring_files_cancel include/linux/io_uring.h:19 [inline]
 do_exit+0x2ce/0x2bd0 kernel/exit.c:911
 do_group_exit+0xd3/0x2a0 kernel/exit.c:1105
 __do_sys_exit_group kernel/exit.c:1116 [inline]
 __se_sys_exit_group kernel/exit.c:1114 [inline]
 __x64_sys_exit_group+0x3e/0x50 kernel/exit.c:1114
 x64_sys_call+0x1530/0x1730 arch/x86/include/generated/asm/syscalls_64.h:232
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xcd/0x4c0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f141ec08e39
RSP: 002b:00007ffcd1b0b6e8 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f141ec08e39
RDX: 000000000000003c RSI: 00000000000000e7 RDI: 0000000000000000
RBP: 00007f141ec843b0 R08: ffffffffffffffb8 R09: 0000000000000000
R10: 000000000000000e R11: 0000000000000246 R12: 00007f141ec843b0
R13: 0000000000000000 R14: 00007f141ec880c0 R15: 00007f141ebd7020
 </TASK>
INFO: task syz-executor971:5852 blocked for more than 144 seconds.
      Not tainted 6.16.0-rc6-syzkaller-00279-gbf61759db409 #0
      Blocked by coredump.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor971 state:D stack:26312 pid:5852  tgid:5852  ppid:5848   task_flags:0x400148 flags:0x00024002
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5397 [inline]
 __schedule+0x116a/0x5de0 kernel/sched/core.c:6786
 __schedule_loop kernel/sched/core.c:6864 [inline]
 schedule+0xe7/0x3a0 kernel/sched/core.c:6879
 schedule_timeout+0x257/0x290 kernel/time/sleep_timeout.c:75
 do_wait_for_common kernel/sched/completion.c:95 [inline]
 __wait_for_common+0x2ff/0x4e0 kernel/sched/completion.c:116
 io_wq_exit_workers io_uring/io-wq.c:1319 [inline]
 io_wq_put_and_exit+0x271/0x8d0 io_uring/io-wq.c:1347
 io_uring_clean_tctx+0x10d/0x190 io_uring/tctx.c:203
 io_uring_cancel_generic+0x69c/0x9a0 io_uring/io_uring.c:3212
 io_uring_files_cancel include/linux/io_uring.h:19 [inline]
 do_exit+0x2ce/0x2bd0 kernel/exit.c:911
 do_group_exit+0xd3/0x2a0 kernel/exit.c:1105
 __do_sys_exit_group kernel/exit.c:1116 [inline]
 __se_sys_exit_group kernel/exit.c:1114 [inline]
 __x64_sys_exit_group+0x3e/0x50 kernel/exit.c:1114
 x64_sys_call+0x1530/0x1730 arch/x86/include/generated/asm/syscalls_64.h:232
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xcd/0x4c0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f141ec08e39
RSP: 002b:00007ffcd1b0b6e8 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f141ec08e39
RDX: 000000000000003c RSI: 00000000000000e7 RDI: 0000000000000000
RBP: 00007f141ec843b0 R08: ffffffffffffffb8 R09: 0000000000000000
R10: 000000000000000e R11: 0000000000000246 R12: 00007f141ec843b0
R13: 0000000000000000 R14: 00007f141ec880c0 R15: 00007f141ebd7020
 </TASK>
INFO: task syz-executor971:5853 blocked for more than 144 seconds.
      Not tainted 6.16.0-rc6-syzkaller-00279-gbf61759db409 #0
      Blocked by coredump.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor971 state:D stack:27080 pid:5853  tgid:5853  ppid:5847   task_flags:0x400148 flags:0x00024002
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5397 [inline]
 __schedule+0x116a/0x5de0 kernel/sched/core.c:6786
 __schedule_loop kernel/sched/core.c:6864 [inline]
 schedule+0xe7/0x3a0 kernel/sched/core.c:6879
 schedule_timeout+0x257/0x290 kernel/time/sleep_timeout.c:75
 do_wait_for_common kernel/sched/completion.c:95 [inline]
 __wait_for_common+0x2ff/0x4e0 kernel/sched/completion.c:116
 io_wq_exit_workers io_uring/io-wq.c:1319 [inline]
 io_wq_put_and_exit+0x271/0x8d0 io_uring/io-wq.c:1347
 io_uring_clean_tctx+0x10d/0x190 io_uring/tctx.c:203
 io_uring_cancel_generic+0x69c/0x9a0 io_uring/io_uring.c:3212
 io_uring_files_cancel include/linux/io_uring.h:19 [inline]
 do_exit+0x2ce/0x2bd0 kernel/exit.c:911
 do_group_exit+0xd3/0x2a0 kernel/exit.c:1105
 __do_sys_exit_group kernel/exit.c:1116 [inline]
 __se_sys_exit_group kernel/exit.c:1114 [inline]
 __x64_sys_exit_group+0x3e/0x50 kernel/exit.c:1114
 x64_sys_call+0x1530/0x1730 arch/x86/include/generated/asm/syscalls_64.h:232
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xcd/0x4c0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f141ec08e39
RSP: 002b:00007ffcd1b0b6e8 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f141ec08e39
RDX: 000000000000003c RSI: 00000000000000e7 RDI: 0000000000000000
RBP: 00007f141ec843b0 R08: ffffffffffffffb8 R09: 0000000000000000
R10: 000000000000000e R11: 0000000000000246 R12: 00007f141ec843b0
R13: 0000000000000000 R14: 00007f141ec880c0 R15: 00007f141ebd7020
 </TASK>

Showing all locks held in the system:
1 lock held by khungtaskd/31:
 #0: ffffffff8e5c4e00 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:331 [inline]
 #0: ffffffff8e5c4e00 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:841 [inline]
 #0: ffffffff8e5c4e00 (rcu_read_lock){....}-{1:3}, at: debug_show_all_locks+0x36/0x1c0 kernel/locking/lockdep.c:6770
2 locks held by getty/5594:
 #0: ffff888032cc90a0 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x24/0x80 drivers/tty/tty_ldisc.c:243
 #1: ffffc900036cb2f0 (&ldata->atomic_read_lock){+.+.}-{4:4}, at: n_tty_read+0x41b/0x14f0 drivers/tty/n_tty.c:2222

=============================================

NMI backtrace for cpu 1
CPU: 1 UID: 0 PID: 31 Comm: khungtaskd Not tainted 6.16.0-rc6-syzkaller-00279-gbf61759db409 #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/07/2025
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x116/0x1f0 lib/dump_stack.c:120
 nmi_cpu_backtrace+0x27b/0x390 lib/nmi_backtrace.c:113
 nmi_trigger_cpumask_backtrace+0x29c/0x300 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:158 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:307 [inline]
 watchdog+0xf70/0x12c0 kernel/hung_task.c:470
 kthread+0x3c5/0x780 kernel/kthread.c:464
 ret_from_fork+0x5d4/0x6f0 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted 6.16.0-rc6-syzkaller-00279-gbf61759db409 #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/07/2025
RIP: 0010:pv_native_safe_halt+0xf/0x20 arch/x86/kernel/paravirt.c:82
Code: 7b 6d 02 e9 83 fb 02 00 0f 1f 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa 66 90 0f 00 2d 43 99 23 00 fb f4 <c3> cc cc cc cc 66 2e 0f 1f 84 00 00 00 00 00 66 90 90 90 90 90 90
RSP: 0018:ffffffff8e207e08 EFLAGS: 000002c6
RAX: 00000000000d6725 RBX: 0000000000000000 RCX: ffffffff8b867c99
RDX: 0000000000000000 RSI: ffffffff8de2fff6 RDI: ffffffff8c157460
RBP: fffffbfff1c52ef0 R08: 0000000000000001 R09: ffffed1017086645
R10: ffff8880b843322b R11: 0000000000000001 R12: 0000000000000000
R13: ffffffff8e297780 R14: ffffffff90a94550 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff888124720000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055e50c02d168 CR3: 000000000e382000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 arch_safe_halt arch/x86/include/asm/paravirt.h:107 [inline]
 default_idle+0x13/0x20 arch/x86/kernel/process.c:749
 default_idle_call+0x6d/0xb0 kernel/sched/idle.c:117
 cpuidle_idle_call kernel/sched/idle.c:185 [inline]
 do_idle+0x391/0x510 kernel/sched/idle.c:325
 cpu_startup_entry+0x4f/0x60 kernel/sched/idle.c:423
 rest_init+0x16b/0x2b0 init/main.c:745
 start_kernel+0x3ee/0x4d0 init/main.c:1102
 x86_64_start_reservations+0x18/0x30 arch/x86/kernel/head64.c:307
 x86_64_start_kernel+0x130/0x190 arch/x86/kernel/head64.c:288
 common_startup_64+0x13e/0x148
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection

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

