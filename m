Return-Path: <io-uring+bounces-2740-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ECDD5950055
	for <lists+io-uring@lfdr.de>; Tue, 13 Aug 2024 10:51:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A4ECE2850CF
	for <lists+io-uring@lfdr.de>; Tue, 13 Aug 2024 08:50:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A57C216A957;
	Tue, 13 Aug 2024 08:50:28 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7AE916A943
	for <io-uring@vger.kernel.org>; Tue, 13 Aug 2024 08:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723539028; cv=none; b=QQb6eiBRH5/K19CstVELGAysiDdRtc5T5VVhANNj9l7S5QfbDM1lGE2ixWWgB1mV74t/qlN+1vxi0qlSbN5kU6d4oU8D9iLgf2FrUysol3L4gWdSRxKR2KJ8A6bMByPGIEQvS475zbYUiKCFX+CD4HXAMV+LVIUp58nR+cjXEZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723539028; c=relaxed/simple;
	bh=a77vzZH8M9X2YCz4S1gBsgqpm0rdO/QsxjeeWdRToMs=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=SNj99x3bYYbgVrgFp1lqM/3m0qbfOzu/EUb4xieXi3eC2WHGtstnhkoOHPslK0k2vFsMddTlP+pqdzOfu5SFhQFOkZhoEvXa5SOP+L/lbQpfGfZeGSrAyIteg1kck25jZcPb9ILmRvF5h+Njd+nelCa70Ro/Yvvo7oo+6ZKiIoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-39827d07ca7so74526875ab.3
        for <io-uring@vger.kernel.org>; Tue, 13 Aug 2024 01:50:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723539026; x=1724143826;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LvENnSmObhEM6ZsL9ErHbWtIin6Dvt4eRyEgj1I7YQE=;
        b=dKwKQBq2vUt6E6c9ej2PiET67X3eOeEwGVhnAE9I0eAOcQf8e1LldF4mAqaPUfYn5p
         ehONB7jvOio/6a8vVuDifr0Ncr+AYRJ15BlAAYDC/yBmo/t6z1X8D3ZUierexJaLMPZd
         CwkzNoOBWvyYpVynl02ZRTcq+Lya9skOY5erMufS7om/1NJvP9AKXSG4kQL+cRRjWv5a
         IH+ZeQRFwe+XzMbnCg521ucgAt+yAZ027cJtxIrteonKkjF7dZN3X2RuuXPTeKDdA9iY
         6GH15kCG4v9r+AdUQf4dpTProYxNawey52jWPwUCBB2VyKEm3I1ET1NFZvPbPAjCXV4x
         fT1w==
X-Forwarded-Encrypted: i=1; AJvYcCVHhL9Bz9bZ7QmR3jMViTpQmCt75GiqFgOF1u4ANDh0JXy5zuAKbiw5adpr361lYJhxB0mNn6cVESLphtl7ecqnGIRMAzT6kl8=
X-Gm-Message-State: AOJu0Yw+cuNHWvQkmANcOkr6UxL5Ewf9FdyGBdNYV+q8bKQobCYVz5Bo
	8H3SlzNexyMMdK+IOCMd65Hbe/qm7S9xsc/g++F0eFzPH+9IuzaxQgjyfKpJgJho3aC26LfGmXi
	QsuCAf8T4K71Q15IDDlASnPWyGMZq6yr3z+dQyaweNeW9WDRkW7pgVFY=
X-Google-Smtp-Source: AGHT+IFmPg87DFHnivJ8edbz8wx7pox/ARjigon/ScmR0A8+TGhf+Tv7+eV+TA98qS3nQOYEe8Ha9nU/RhQGhE9uvWzC/cBmAAVz
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a43:b0:39a:e900:7e3e with SMTP id
 e9e14a558f8ab-39c4790206dmr1485795ab.3.1723539025904; Tue, 13 Aug 2024
 01:50:25 -0700 (PDT)
Date: Tue, 13 Aug 2024 01:50:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000065552a061f8cb396@google.com>
Subject: [syzbot] [io-uring?] KCSAN: data-race in io_sq_thread /
 io_sq_thread_park (9)
From: syzbot <syzbot+2b946a3fd80caf971b21@syzkaller.appspotmail.com>
To: asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    6a0e38264012 Merge tag 'for-6.11-rc2-tag' of git://git.ker..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1019759d980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=cb57e6ebf675f9d2
dashboard link: https://syzkaller.appspot.com/bug?extid=2b946a3fd80caf971b21
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/753a842a966b/disk-6a0e3826.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/e12e23519777/vmlinux-6a0e3826.xz
kernel image: https://storage.googleapis.com/syzbot-assets/bce0584a8cb4/bzImage-6a0e3826.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+2b946a3fd80caf971b21@syzkaller.appspotmail.com

==================================================================
BUG: KCSAN: data-race in io_sq_thread / io_sq_thread_park

write to 0xffff888111459638 of 8 bytes by task 10761 on cpu 1:
 io_sq_thread+0xdab/0xff0 io_uring/sqpoll.c:383
 ret_from_fork+0x4b/0x60 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

read to 0xffff888111459638 of 8 bytes by task 10329 on cpu 0:
 io_sq_thread_park+0x1b/0x80 io_uring/sqpoll.c:47
 io_ring_exit_work+0x197/0x500 io_uring/io_uring.c:2786
 process_one_work kernel/workqueue.c:3231 [inline]
 process_scheduled_works+0x483/0x9a0 kernel/workqueue.c:3312
 worker_thread+0x526/0x700 kernel/workqueue.c:3390
 kthread+0x1d1/0x210 kernel/kthread.c:389
 ret_from_fork+0x4b/0x60 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

value changed: 0xffff8881223d0000 -> 0x0000000000000000

Reported by Kernel Concurrency Sanitizer on:
CPU: 0 UID: 0 PID: 10329 Comm: kworker/u8:8 Not tainted 6.11.0-rc2-syzkaller-00027-g6a0e38264012 #0
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

