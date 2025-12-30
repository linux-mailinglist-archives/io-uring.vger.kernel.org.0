Return-Path: <io-uring+bounces-11326-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D525CE9922
	for <lists+io-uring@lfdr.de>; Tue, 30 Dec 2025 12:48:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 96C6B3015108
	for <lists+io-uring@lfdr.de>; Tue, 30 Dec 2025 11:48:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27552296BAB;
	Tue, 30 Dec 2025 11:48:28 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f77.google.com (mail-oo1-f77.google.com [209.85.161.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BA7C27B357
	for <io-uring@vger.kernel.org>; Tue, 30 Dec 2025 11:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767095308; cv=none; b=NM7Nb12Ty0BeCBx5Z/eJXlsRDetNdQpuPTzhT5DKsjaNmWQKDxmKipdImF+e/1eWDxk7w2Qtwbu6fYYXXvggvAoWgRYeio8nSKAqS4N4uq82+SbK9rwJ2CRmAF9kKHHTj/7WLmo4wibUQzBrelxzBDUaheWupikNR/9REIlG0DM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767095308; c=relaxed/simple;
	bh=fL3F4ZOskxs+1ZDL4j+ZLF+bRFnwJTr/KCHTaQX4zkY=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=n4w1+QNg6e0d4gQ12LtOuCzHU9BCMw9SlWHxmKbT5cFo5scSOv4cLsWt8LgcQazpIeop9Zy0PFxeNytFU/zCvaBckyNXPiVvkKOwjAfJ0MLuGvsKg2Q/m90v7vTyVcPJF6ubzlE8ASzFyHFBjaHVpWiOKK86uKPm34f1G7VywG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f77.google.com with SMTP id 006d021491bc7-656bc3a7ab3so17570738eaf.2
        for <io-uring@vger.kernel.org>; Tue, 30 Dec 2025 03:48:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767095305; x=1767700105;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+8drJ/mVxz+p0KlOUgQqMIPDIe3iYbLUBnOrWnSBnIQ=;
        b=ii/zfe9njF2hPy9e58JXDIHtV5Ep1mmiIiJGNpon9JL8o9AWkK71RA/3bB1Az6dEAj
         blAsE7KWitkdg4IWPaRjxkaEDGD+1oRiY/HT+2ltU+k8mSBWA+nxx7clMvdc7XrWuh5T
         wNl0gKpMD9HG7FGJhrDY+s299+10bmll84E0j0sqb5+8UpgFI4Yamkco6QsxSnH/+0xK
         yRozD7jCbXZYfWIuF2+VLtRmk7WegQB8E4Cos6m+bGE5c2dtUEDHsPEGChmNKeUoR/Ww
         9AIWBimUDbnRTnYkEJAyf30i4bYvqSzdM2QzPvhP8cRelXxAIrqo39x7eBwy85ZgCjU4
         nWKw==
X-Forwarded-Encrypted: i=1; AJvYcCVbzcHQ9zQ26ozJazpUba05vxpRCVMWvsJZ8YiPziBJsYlGc2KEHFxp6IzBh3DwPjTOyvdItUfliQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxD6TgiveMAljZKtwntGb7wdQmnO9xKrFSGZ386vnrT/di4Mgi/
	4YMdt0IQfU8+1ixGFKlJ4MFcyKg0aFi2bvc0cFgB1+kyl+uN9LjK6w/juwILkpTNW3T11gF0OI+
	MX9V2FfQ5CxIfYixYPxPpKjzzhVQ5r6r0ysbryeiSpSmrArD17xBp5ailG2M=
X-Google-Smtp-Source: AGHT+IHZay9behCI88LEUBC+5kQ2AOCwu1W4VWpjguOgXeXs5uZ2ZDic6YA8qc3Btzbgy6vWrnNS35kz+awTzZ5hIafhEbp+TyEF
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:4d53:10b0:65b:250c:70e9 with SMTP id
 006d021491bc7-65d0ea6f1b9mr10838177eaf.27.1767095305278; Tue, 30 Dec 2025
 03:48:25 -0800 (PST)
Date: Tue, 30 Dec 2025 03:48:25 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6953bc09.050a0220.329c0f.0591.GAE@google.com>
Subject: [syzbot] [io-uring?] possible deadlock in io_uring_del_tctx_node
From: syzbot <syzbot+b0e3b77ffaa8a4067ce5@syzkaller.appspotmail.com>
To: axboe@kernel.dk, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    7839932417dd Merge tag 'sched_ext-for-6.19-rc3-fixes' of g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1540bb92580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a94030c847137a18
dashboard link: https://syzkaller.appspot.com/bug?extid=b0e3b77ffaa8a4067ce5
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/d2f55b7baab3/disk-78399324.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/60100f150ad1/vmlinux-78399324.xz
kernel image: https://storage.googleapis.com/syzbot-assets/2a223b3daaf7/bzImage-78399324.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b0e3b77ffaa8a4067ce5@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
syzkaller #0 Tainted: G             L     
------------------------------------------------------
syz.0.9999/12287 is trying to acquire lock:
ffff88805851c0a8 (&ctx->uring_lock){+.+.}-{4:4}, at: io_uring_del_tctx_node+0xf0/0x2c0 io_uring/tctx.c:179

but task is already holding lock:
ffff88802db5a2e0 (&sig->cred_guard_mutex){+.+.}-{4:4}, at: prepare_bprm_creds fs/exec.c:1360 [inline]
ffff88802db5a2e0 (&sig->cred_guard_mutex){+.+.}-{4:4}, at: bprm_execve+0xb9/0x1400 fs/exec.c:1733

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (&sig->cred_guard_mutex){+.+.}-{4:4}:
       __mutex_lock_common kernel/locking/mutex.c:614 [inline]
       __mutex_lock+0x187/0x1350 kernel/locking/mutex.c:776
       proc_pid_attr_write+0x547/0x630 fs/proc/base.c:2837
       vfs_write+0x27e/0xb30 fs/read_write.c:684
       ksys_write+0x145/0x250 fs/read_write.c:738
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0xec/0xf80 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #1 (sb_writers#3){.+.+}-{0:0}:
       percpu_down_read_internal include/linux/percpu-rwsem.h:53 [inline]
       percpu_down_read_freezable include/linux/percpu-rwsem.h:83 [inline]
       __sb_start_write include/linux/fs/super.h:19 [inline]
       sb_start_write+0x4d/0x1c0 include/linux/fs/super.h:125
       mnt_want_write+0x41/0x90 fs/namespace.c:499
       open_last_lookups fs/namei.c:4529 [inline]
       path_openat+0xadd/0x3dd0 fs/namei.c:4784
       do_filp_open+0x1fa/0x410 fs/namei.c:4814
       io_openat2+0x3e0/0x5c0 io_uring/openclose.c:143
       __io_issue_sqe+0x181/0x4b0 io_uring/io_uring.c:1792
       io_issue_sqe+0x165/0x1060 io_uring/io_uring.c:1815
       io_queue_sqe io_uring/io_uring.c:2042 [inline]
       io_submit_sqe io_uring/io_uring.c:2320 [inline]
       io_submit_sqes+0xbf4/0x2140 io_uring/io_uring.c:2434
       __do_sys_io_uring_enter io_uring/io_uring.c:3280 [inline]
       __se_sys_io_uring_enter+0x2e0/0x2b60 io_uring/io_uring.c:3219
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0xec/0xf80 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (&ctx->uring_lock){+.+.}-{4:4}:
       check_prev_add kernel/locking/lockdep.c:3165 [inline]
       check_prevs_add kernel/locking/lockdep.c:3284 [inline]
       validate_chain kernel/locking/lockdep.c:3908 [inline]
       __lock_acquire+0x15a6/0x2cf0 kernel/locking/lockdep.c:5237
       lock_acquire+0x107/0x340 kernel/locking/lockdep.c:5868
       __mutex_lock_common kernel/locking/mutex.c:614 [inline]
       __mutex_lock+0x187/0x1350 kernel/locking/mutex.c:776
       io_uring_del_tctx_node+0xf0/0x2c0 io_uring/tctx.c:179
       io_uring_clean_tctx+0xd4/0x1a0 io_uring/tctx.c:195
       io_uring_cancel_generic+0x6ca/0x7d0 io_uring/cancel.c:646
       io_uring_task_cancel include/linux/io_uring.h:24 [inline]
       begin_new_exec+0x10ed/0x2440 fs/exec.c:1131
       load_elf_binary+0x9f8/0x2d70 fs/binfmt_elf.c:1010
       search_binary_handler fs/exec.c:1669 [inline]
       exec_binprm fs/exec.c:1701 [inline]
       bprm_execve+0x92e/0x1400 fs/exec.c:1753
       do_execveat_common+0x510/0x6a0 fs/exec.c:1859
       do_execve fs/exec.c:1933 [inline]
       __do_sys_execve fs/exec.c:2009 [inline]
       __se_sys_execve fs/exec.c:2004 [inline]
       __x64_sys_execve+0x94/0xb0 fs/exec.c:2004
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0xec/0xf80 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

Chain exists of:
  &ctx->uring_lock --> sb_writers#3 --> &sig->cred_guard_mutex

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&sig->cred_guard_mutex);
                               lock(sb_writers#3);
                               lock(&sig->cred_guard_mutex);
  lock(&ctx->uring_lock);

 *** DEADLOCK ***

1 lock held by syz.0.9999/12287:
 #0: ffff88802db5a2e0 (&sig->cred_guard_mutex){+.+.}-{4:4}, at: prepare_bprm_creds fs/exec.c:1360 [inline]
 #0: ffff88802db5a2e0 (&sig->cred_guard_mutex){+.+.}-{4:4}, at: bprm_execve+0xb9/0x1400 fs/exec.c:1733

stack backtrace:
CPU: 0 UID: 0 PID: 12287 Comm: syz.0.9999 Tainted: G             L      syzkaller #0 PREEMPT(full) 
Tainted: [L]=SOFTLOCKUP
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/25/2025
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_circular_bug+0x2e2/0x300 kernel/locking/lockdep.c:2043
 check_noncircular+0x12e/0x150 kernel/locking/lockdep.c:2175
 check_prev_add kernel/locking/lockdep.c:3165 [inline]
 check_prevs_add kernel/locking/lockdep.c:3284 [inline]
 validate_chain kernel/locking/lockdep.c:3908 [inline]
 __lock_acquire+0x15a6/0x2cf0 kernel/locking/lockdep.c:5237
 lock_acquire+0x107/0x340 kernel/locking/lockdep.c:5868
 __mutex_lock_common kernel/locking/mutex.c:614 [inline]
 __mutex_lock+0x187/0x1350 kernel/locking/mutex.c:776
 io_uring_del_tctx_node+0xf0/0x2c0 io_uring/tctx.c:179
 io_uring_clean_tctx+0xd4/0x1a0 io_uring/tctx.c:195
 io_uring_cancel_generic+0x6ca/0x7d0 io_uring/cancel.c:646
 io_uring_task_cancel include/linux/io_uring.h:24 [inline]
 begin_new_exec+0x10ed/0x2440 fs/exec.c:1131
 load_elf_binary+0x9f8/0x2d70 fs/binfmt_elf.c:1010
 search_binary_handler fs/exec.c:1669 [inline]
 exec_binprm fs/exec.c:1701 [inline]
 bprm_execve+0x92e/0x1400 fs/exec.c:1753
 do_execveat_common+0x510/0x6a0 fs/exec.c:1859
 do_execve fs/exec.c:1933 [inline]
 __do_sys_execve fs/exec.c:2009 [inline]
 __se_sys_execve fs/exec.c:2004 [inline]
 __x64_sys_execve+0x94/0xb0 fs/exec.c:2004
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xec/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7ff3a8b8f749
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ff3a9a97038 EFLAGS: 00000246 ORIG_RAX: 000000000000003b
RAX: ffffffffffffffda RBX: 00007ff3a8de5fa0 RCX: 00007ff3a8b8f749
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000200000000400
RBP: 00007ff3a8c13f91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ff3a8de6038 R14: 00007ff3a8de5fa0 R15: 00007ff3a8f0fa28
 </TASK>
process '/newroot/95/file0' started with executable stack


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

