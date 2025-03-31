Return-Path: <io-uring+bounces-7333-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B287A77013
	for <lists+io-uring@lfdr.de>; Mon, 31 Mar 2025 23:25:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AE74F7A451B
	for <lists+io-uring@lfdr.de>; Mon, 31 Mar 2025 21:24:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 036A721A45F;
	Mon, 31 Mar 2025 21:25:22 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f77.google.com (mail-io1-f77.google.com [209.85.166.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B7D21D63DD
	for <io-uring@vger.kernel.org>; Mon, 31 Mar 2025 21:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743456321; cv=none; b=iBqwy82dwHwRzYzp+27owTjy//4ymCxUls4eAAGbNAZISY40kqlzcRvMsbjWD5vskWrF7cFTgMlTQs5k6CqDdc5Y+/z9pClHQ9+gIukIK1Xn9DNIVt6TTChS2CUq3ICLjjXiIqViBuWZWSaDbqcgXyzA0gQqrpWgFWS92esEIFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743456321; c=relaxed/simple;
	bh=kbVxx07mR1BQOpieWS72nLRI7TVYhLdd/hiFKCA90bc=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=PbmR/3CZ1IEN3X8SidC3KkKfM1EDjgSAtVaLqwo56CuDL3QNtZFsYxX8pTBCax1GX5SSBf4SN/pgk6O5qI1AnL9521xIm5kDPKUkdfVLYmq2rBtLFdI8TJgfsVn+oFXz5kN7Xk2G0VZjnbcjo1ESF0Bb57Om6vs4anY20FBQ7G8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f77.google.com with SMTP id ca18e2360f4ac-85e15e32366so494426039f.2
        for <io-uring@vger.kernel.org>; Mon, 31 Mar 2025 14:25:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743456319; x=1744061119;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uFQrTdF8fqNNfwFQ8ock3XgZs5XmJ4g5svfUAT+PrvU=;
        b=U2uPpz3fon10tNJ9Vab0yMMQodLWStLneBMipZvehz5bReMqGdmi1rCnFwsN5WHazQ
         TDjHCO2oH7+GBRffgTanYviMqlXRgWjpGsII0eLJfBJhiYmRvuDHfdYLkpPIb+M/2fat
         7ur3lz4IQm+1XL1U5TCAeP/JSlky4NlNYKDLmD2KsENycRTrqnfnmmL29NT9FfU/1qKY
         NmB4EU2XZUaoLi/e7iWTKETcIa89cik7q84wlBYwhUBFgb6z0Xl+UasCT2rW+UHb2kqX
         DA+AiP8kRmMOtdTy8+CAUjoBExxQbxoOymsM//AN44A1ZFgBPH69F2snbS5B/1R+uhN/
         M8Aw==
X-Forwarded-Encrypted: i=1; AJvYcCVv8YqToBuQEAbWT6D/zIdMJFmXoFsa7FT/03bokmxs3MvPpbVT9VnEO58Nrk5QIF+c0VELgPtz4A==@vger.kernel.org
X-Gm-Message-State: AOJu0YysSHUmyIp1AIMGxAf4YjmI83iFgT9X1rk6pcudASjPQOUvh519
	+aIlc+XNw2XAU2O+CXqfCKVMx9kdP3Yx6UaSaWMMZgZEyCSqW82pBtAOAen4+sesas8YT5Qc8y4
	ZVW+U3UDlB8yYzLqRKdDl4hynU2n2lPFKrn/5I3BvHondH+UQZcYlv9Q=
X-Google-Smtp-Source: AGHT+IH+wJVg/pndsmDWifUT3yO6fIkzaQLY6NCBXwGpBUC1zG/2C6/tpC0tr4ZUUWKaFCt482Ny7DfEH6sYX31dpUUcV3urc+7t
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:3d81:b0:3ce:4b12:fa17 with SMTP id
 e9e14a558f8ab-3d5e0a0cfe7mr112032225ab.19.1743456319467; Mon, 31 Mar 2025
 14:25:19 -0700 (PDT)
Date: Mon, 31 Mar 2025 14:25:19 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67eb083f.050a0220.1547ec.0175.GAE@google.com>
Subject: [syzbot] [io-uring?] WARNING in io_req_task_complete
From: syzbot <syzbot+7039663f7490865be042@syzkaller.appspotmail.com>
To: asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    609706855d90 Merge tag 'trace-latency-v6.15-3' of git://gi..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=135b8c74580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e29b75096ef62c41
dashboard link: https://syzkaller.appspot.com/bug?extid=7039663f7490865be042
compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-60970685.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/5b1637a9bb2b/vmlinux-60970685.xz
kernel image: https://storage.googleapis.com/syzbot-assets/8343880c0c31/bzImage-60970685.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+7039663f7490865be042@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 3 PID: 6086 at io_uring/io_uring.h:411 io_req_complete_defer io_uring/io_uring.h:411 [inline]
WARNING: CPU: 3 PID: 6086 at io_uring/io_uring.h:411 io_req_task_complete+0x164/0x200 io_uring/io_uring.c:1586
Modules linked in:
CPU: 3 UID: 0 PID: 6086 Comm: syz.1.28 Not tainted 6.14.0-syzkaller-11125-g609706855d90 #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:io_req_complete_defer io_uring/io_uring.h:411 [inline]
RIP: 0010:io_req_task_complete+0x164/0x200 io_uring/io_uring.c:1586
Code: bd a8 00 00 00 be ff ff ff ff e8 a7 57 ad 06 31 ff 41 89 c4 89 c6 e8 7b 10 fa fc 45 85 e4 0f 85 1d ff ff ff e8 3d 15 fa fc 90 <0f> 0b 90 e9 0f ff ff ff e8 2f 15 fa fc 48 8d bd 70 01 00 00 48 b8
RSP: 0018:ffffc90004017a90 EFLAGS: 00010246
RAX: 0000000000080000 RBX: ffff88805a877b80 RCX: ffffc9000c001000
RDX: 0000000000080000 RSI: ffffffff84c11c63 RDI: 0000000000000005
RBP: ffff888031082000 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: ffff88805a877ba8 R14: 0000000000000004 R15: fffffbfff210b986
FS:  00007fbfc42196c0(0000) GS:ffff8880d6cd4000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000020000000022c CR3: 0000000050852000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 io_notif_tw_complete+0x15b/0x350 io_uring/notif.c:32
 io_handle_tw_list+0x483/0x500 io_uring/io_uring.c:1057
 tctx_task_work_run+0xac/0x380 io_uring/io_uring.c:1121
 tctx_task_work+0x7a/0xd0 io_uring/io_uring.c:1139
 task_work_run+0x14d/0x240 kernel/task_work.c:227
 get_signal+0x1d1/0x26d0 kernel/signal.c:2808
 arch_do_signal_or_restart+0x8f/0x7d0 arch/x86/kernel/signal.c:337
 exit_to_user_mode_loop kernel/entry/common.c:111 [inline]
 exit_to_user_mode_prepare include/linux/entry-common.h:329 [inline]
 __syscall_exit_to_user_mode_work kernel/entry/common.c:207 [inline]
 syscall_exit_to_user_mode+0x150/0x2a0 kernel/entry/common.c:218
 do_syscall_64+0xda/0x260 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fbfc338d169
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fbfc42190e8 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
RAX: fffffffffffffe00 RBX: 00007fbfc35a5fa8 RCX: 00007fbfc338d169
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 00007fbfc35a5fa8
RBP: 00007fbfc35a5fa0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007fbfc35a5fac
R13: 0000000000000000 R14: 00007fff2d376730 R15: 00007fff2d376818
 </TASK>


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

