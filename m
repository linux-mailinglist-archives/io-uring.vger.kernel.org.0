Return-Path: <io-uring+bounces-7784-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 91F82AA47DD
	for <lists+io-uring@lfdr.de>; Wed, 30 Apr 2025 12:09:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6A7E39A74DD
	for <lists+io-uring@lfdr.de>; Wed, 30 Apr 2025 10:09:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D999E233D98;
	Wed, 30 Apr 2025 10:09:34 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f77.google.com (mail-io1-f77.google.com [209.85.166.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38104231830
	for <io-uring@vger.kernel.org>; Wed, 30 Apr 2025 10:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746007774; cv=none; b=ohIbzMrU9aOCJ5K0rG+8BHDW8zo2BnWtRkob8smAIxRNAsCMmv4RnpwCmVYNNdRLjD+oQYcMrAqcIWOT2dd3x1z4Ooj8crxyJjxOQq8ajttZjnp2Ixb9GGjxwu9M62y5xti1CO4dGRLWOBeoqR/9D07H9Jg/+iR0nDYA9Dl82qc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746007774; c=relaxed/simple;
	bh=a8gRg6Izfa8RFt7wbIAfGX+9/ib/Dd8gm/sC8Csgiz8=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=iJFzi3rn6SRUb9f3vsRs2RZpskJ9dm0CJoWalN6gUFEx5WuTskkjaLiGGWO04i7QBRpgdCczSlD+APOjedDmyCPYw+w0nZ6JENZIy9CzDbKbyIUu0ujVLaHwf2jx8fCrJupu+Hu9evOX06lhJlyhS4/6H3CxeitRtbHLaHhQRDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f77.google.com with SMTP id ca18e2360f4ac-85b418faf73so1361917739f.1
        for <io-uring@vger.kernel.org>; Wed, 30 Apr 2025 03:09:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746007772; x=1746612572;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2OOnF9wwZhmwyXdn4lTQkVB0yLq6TVTRIdVNFttGNbY=;
        b=qZC6uP7DvWAA3Gr/3bgkd1UeH6zttQh5ELRnDlD4xFLqxjWDR8angLP+4sRNNON2e7
         cjqsO0VPxNG0H6nHLJz78AoMbBejsdzM/qXijV/+Qk9YWXa6NbR3UvVw9hkOSiqx9ZMm
         8LmEZHBXLMD0egb6qfDq5HyLusHptrpdPK9OzBwM76E4q/sBvBUM5BqrWP3KDegbSfhY
         Gb6MUQYjlE+3OhbQ7Hrz/hecJFlwm/4HiyESH0Ey0p6Io+qeIr0/MPx6CmmO3c4YXKho
         Abxfrris4fQuNOtDiiqQ0Q9oc5zS0RLDLex2cmdAuhJNAAMsUCU/jlYGMlvpyD60BhKI
         H7tw==
X-Forwarded-Encrypted: i=1; AJvYcCW/p7vBVtvq8kFDfQzO3m9sADE+MRGWB+13u3au1K//5KseZ9n8tvXWymFZpBjTyttdhZPPE71iRA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzw7+yZzxffq0UhMcpW2d8knDmM1/2VBwgayUREMV9Pme+aOLTq
	84PnK+mgI/11Q9HtkSsBwfJJUSXnvrdVVo4NLym85rbpzVHLGUfYFI34Yt06k1Vo3z701HHr+BX
	QfkFoFuhZyAetI4+Y7cF6OtqCFffOBN/jBhl9mHWJWirxJXkGleo2JE4=
X-Google-Smtp-Source: AGHT+IFa1pJKVPROIgV9AM7FBZ3nQall2eYrq/us1tL8cUqcLVD/Nx2EKIj+QUoPI6BFm0A5T0wvGjGs1ui0NFc7ZalWUQcjO2T1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:4c10:b0:861:d6f3:a2d9 with SMTP id
 ca18e2360f4ac-86495e8c934mr362834439f.7.1746007772331; Wed, 30 Apr 2025
 03:09:32 -0700 (PDT)
Date: Wed, 30 Apr 2025 03:09:32 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6811f6dc.050a0220.39e3a1.0d0e.GAE@google.com>
Subject: [syzbot] [io-uring?] KCSAN: data-race in io_submit_sqes / io_uring_show_fdinfo
From: syzbot <syzbot+3e77fd302e99f5af9394@syzkaller.appspotmail.com>
To: asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    ca91b9500108 Merge tag 'v6.15-rc4-ksmbd-server-fixes' of g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14a7d774580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6bd11c5d4ce102b4
dashboard link: https://syzkaller.appspot.com/bug?extid=3e77fd302e99f5af9394
compiler:       Debian clang version 20.1.2 (++20250402124445+58df0ef89dd6-1~exp1~20250402004600.97), Debian LLD 20.1.2

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/3a00fa544114/disk-ca91b950.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/e82e624a4321/vmlinux-ca91b950.xz
kernel image: https://storage.googleapis.com/syzbot-assets/28e6034d0263/bzImage-ca91b950.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+3e77fd302e99f5af9394@syzkaller.appspotmail.com

==================================================================
BUG: KCSAN: data-race in io_submit_sqes / io_uring_show_fdinfo

read-write to 0xffff88810a2fe870 of 4 bytes by task 5625 on cpu 0:
 io_get_sqe io_uring/io_uring.c:2286 [inline]
 io_submit_sqes+0x235/0x1000 io_uring/io_uring.c:2339
 __io_sq_thread io_uring/sqpoll.c:189 [inline]
 io_sq_thread+0x778/0x1110 io_uring/sqpoll.c:312
 ret_from_fork+0x4b/0x60 arch/x86/kernel/process.c:153
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

read to 0xffff88810a2fe870 of 4 bytes by task 5624 on cpu 1:
 io_uring_show_fdinfo+0x150/0xc40 io_uring/fdinfo.c:126
 seq_show+0x331/0x3b0 fs/proc/fd.c:68
 traverse+0x141/0x3a0 fs/seq_file.c:111
 seq_lseek+0xb5/0x170 fs/seq_file.c:323
 vfs_llseek fs/read_write.c:387 [inline]
 ksys_lseek fs/read_write.c:400 [inline]
 __do_sys_lseek fs/read_write.c:410 [inline]
 __se_sys_lseek fs/read_write.c:408 [inline]
 __x64_sys_lseek+0xe5/0x160 fs/read_write.c:408
 x64_sys_call+0x2d2a/0x2fb0 arch/x86/include/generated/asm/syscalls_64.h:9
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xd0/0x1a0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

value changed: 0x0000e4d3 -> 0x0000e4f2

Reported by Kernel Concurrency Sanitizer on:
CPU: 1 UID: 0 PID: 5624 Comm: syz.0.732 Not tainted 6.15.0-rc4-syzkaller-00021-gca91b9500108 #0 PREEMPT(voluntary) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/19/2025
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

