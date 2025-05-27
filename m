Return-Path: <io-uring+bounces-8116-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D1459AC51CE
	for <lists+io-uring@lfdr.de>; Tue, 27 May 2025 17:15:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2E77916694E
	for <lists+io-uring@lfdr.de>; Tue, 27 May 2025 15:15:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70F6527A476;
	Tue, 27 May 2025 15:15:36 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f79.google.com (mail-io1-f79.google.com [209.85.166.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB4CD15624D
	for <io-uring@vger.kernel.org>; Tue, 27 May 2025 15:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748358936; cv=none; b=rH17Q+rxR896P+Vm7MjMPZBcBaPqbYd6S3Ytmi5bHkvxvkeDVUroqBJhkmsa4/Uq0TwN3LoxNyKGU/h0J4cAnNXjLxBbznoRePCDtKq69MccRTHsaQ1bFIuJusnb96SqDDjC4TZB7nV4l+o2foI7pBCj2/MFupP29hqvtY0f5ig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748358936; c=relaxed/simple;
	bh=o52gIWJXV36NqQKPyb9vj8CUHghtyk5NZwiBeUlu15o=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=U7atf5wxSZkSTE4cr0bzOodEcCBOwKx/WldSLGYiEO8quDOsEbtAYFBxYFJcNvVM89XSfG+buip3FHgxgJws3BAmKLBdR6lWJc2XArACLBha+aRXCisyBURW00qMD7CFX1CAkKvC5nJj8h3QwnLQv2waPgyPEWJaOzwnvX6vhR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f79.google.com with SMTP id ca18e2360f4ac-86a3d964d9fso355519839f.0
        for <io-uring@vger.kernel.org>; Tue, 27 May 2025 08:15:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748358934; x=1748963734;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tuF2cvvL2P3Eod+mVUZAyivjhb60HVt8Np+UoU6NyzQ=;
        b=R+7kDb58NGFwLYX1yE01Ob2BPyxfXNu2N6UK0+8h8gSTFzjTuTGEgK3YPMsafoKqlX
         rQuqVhBwtjHlWJVJr0KQ5MYTKzPNF1EFJpk20mXwfxhXjTIniYvaQhAddYqVi3ffjMo+
         JZZyWuYeBWeNoyCjQlY1Z2DI9TliMBRq2ravn5/+LyCNQq/FlBLeFjHEs9586eVeQS1U
         NNWljL+9bH46gdldGCZ+3FmvRrkyFDi+S/6K5htEzOujE9ieDHw72W396q12afbilBnw
         thzy0YPj3F9/7iAnSeUSII4SSP7SJ142S5YbGtt5pKxyJdJFXFsxIRKg30KDbXR45ln0
         Xq1g==
X-Forwarded-Encrypted: i=1; AJvYcCVi2gIpHOEls+mhsvK/mxlpNv9AQ0k/o13XdPKXix99911McDtAuip4k1xLD7FtCNvmapXK105cZA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxHHtaWq6IVl8IWJcjnC2TYIRn7RQe35D+7fgYpGcpG9Qi72GeO
	3Un/ywnmgIDk096Ois+kOzGCY16+qWiAgxZlmFyXi+RxqhxCFrVs5otpd0Ks8NGJztNIYEFwYh9
	caAfWWk17qqyn1HYyf5vsFV1KTeKFS7l6T5rEui8FCx4vxRhaDU/s1yFqhRI=
X-Google-Smtp-Source: AGHT+IFJ78q6Mrhi/GYctD+xVYoqs8X59Kofc60QxI1Eltbvz3rLJ81rZOhvG6LYwKU6xUyTxF4dQCG9uRIJjOArSz0TifO7nFEt
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:36cc:b0:867:16f4:5254 with SMTP id
 ca18e2360f4ac-86ce426ef9dmr173883639f.6.1748358933947; Tue, 27 May 2025
 08:15:33 -0700 (PDT)
Date: Tue, 27 May 2025 08:15:33 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6835d715.a70a0220.253bc2.00bb.GAE@google.com>
Subject: [syzbot] [io-uring?] KMSAN: uninit-value in xa_find
From: syzbot <syzbot+c3ff04150c30d3df0f57@syzkaller.appspotmail.com>
To: asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    914873bc7df9 Merge tag 'x86-build-2025-05-25' of git://git..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14727df4580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=19f03604c8d216a8
dashboard link: https://syzkaller.appspot.com/bug?extid=c3ff04150c30d3df0f57
compiler:       Debian clang version 20.1.6 (++20250514063057+1e4d39e07757-1~exp1~20250514183223.118), Debian LLD 20.1.6

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/624ebec879d9/disk-914873bc.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/f44c87154c1f/vmlinux-914873bc.xz
kernel image: https://storage.googleapis.com/syzbot-assets/a922731b5aab/bzImage-914873bc.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c3ff04150c30d3df0f57@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in xas_start lib/xarray.c:193 [inline]
BUG: KMSAN: uninit-value in xas_load+0xd20/0xd70 lib/xarray.c:239
 xas_start lib/xarray.c:193 [inline]
 xas_load+0xd20/0xd70 lib/xarray.c:239
 xas_find+0x2c8/0xd40 lib/xarray.c:1406
 xa_find+0x15a/0x2a0 lib/xarray.c:2194
 io_unregister_zcrx_ifqs+0x75/0x1d0 io_uring/zcrx.c:639
 io_ring_ctx_free+0x61/0x740 io_uring/io_uring.c:2723
 io_ring_exit_work+0xdec/0xe20 io_uring/io_uring.c:2963
 process_one_work kernel/workqueue.c:3238 [inline]
 process_scheduled_works+0xb97/0x1d90 kernel/workqueue.c:3319
 worker_thread+0xedf/0x1590 kernel/workqueue.c:3400
 kthread+0xd5c/0xf00 kernel/kthread.c:464
 ret_from_fork+0x71/0x90 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

Uninit was stored to memory at:
 xa_find+0x26c/0x2a0 lib/xarray.c:2186
 io_unregister_zcrx_ifqs+0x75/0x1d0 io_uring/zcrx.c:639
 io_ring_ctx_free+0x61/0x740 io_uring/io_uring.c:2723
 io_ring_exit_work+0xdec/0xe20 io_uring/io_uring.c:2963
 process_one_work kernel/workqueue.c:3238 [inline]
 process_scheduled_works+0xb97/0x1d90 kernel/workqueue.c:3319
 worker_thread+0xedf/0x1590 kernel/workqueue.c:3400
 kthread+0xd5c/0xf00 kernel/kthread.c:464
 ret_from_fork+0x71/0x90 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

Local variable id created at:
 io_unregister_zcrx_ifqs+0x3d/0x1d0 io_uring/zcrx.c:633
 io_ring_ctx_free+0x61/0x740 io_uring/io_uring.c:2723

CPU: 0 UID: 0 PID: 3749 Comm: kworker/u8:17 Not tainted 6.15.0-syzkaller-01972-g914873bc7df9 #0 PREEMPT(undef) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/07/2025
Workqueue: iou_exit io_ring_exit_work
=====================================================


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

