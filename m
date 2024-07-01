Return-Path: <io-uring+bounces-2406-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 366B291E9D0
	for <lists+io-uring@lfdr.de>; Mon,  1 Jul 2024 22:50:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E700E283217
	for <lists+io-uring@lfdr.de>; Mon,  1 Jul 2024 20:50:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35AF316DEC0;
	Mon,  1 Jul 2024 20:50:23 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA6A21366
	for <io-uring@vger.kernel.org>; Mon,  1 Jul 2024 20:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719867023; cv=none; b=Xq4QZkIG+nNuJD/K+ujJESZ9W/P+WtRiVrKxG/aIvMCUPJ+NQe4favKPwAsS4krONhPpLNdDHIS9R8U4eujZmfdVqf4YavRXj2CepUA5dBQj78hrSxZ6Q5MxNdhJ5KDQZuie10OKOciCej2RAxCKASKegYXMK7tl50AJaddrVvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719867023; c=relaxed/simple;
	bh=sDzE7YpPHR3LR6h3gGbdoVVS/FgXk55Zx2hqr+8phRA=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=B8w1GeIxqiohZ6qrltM3TJadFxZEgLlDCVGKo/32aFyFDb21ZMPT3MZlpxLAnPtoMDXIHv2OTTJv1SxFJuF8plpVxCK9cswLkVuSJBQoerixjK2EuObLc3K5Pm7jNWPk3ljU0wWg+rdTUI7++M8sg3LtRHOiQ5KzzI24BjDObj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-7f3c9b72aebso368592539f.3
        for <io-uring@vger.kernel.org>; Mon, 01 Jul 2024 13:50:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719867021; x=1720471821;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sgcjFW3XYMXRUsUyvo0nFUiGW8OYCo7Qnh7ViycLBS8=;
        b=KJG1deAgNfzF1kbcz7xr3gdJHZLdvu+Xd2FZyATNvD7oB6UEE9YNRPorqIbwixgmlz
         auBJyp7hpgUVMAjFiTsQCLJIDqiaXsV6b/I/W2GSoclefZL7foxLE9dpgmyJD+LGe5Y1
         Q/pL36mWTS1/XyzadUUwlAAL8Csz1NbDgp0jPlWAQCzJvkhy8l8AOFbly5TbLRsQi9jw
         nzkWjYKWeiSQWnC8Z1zwBNFI51QhPbrM3QdpV+P56eDIaBnQAwoGcA4uLf+VFT0JeTT2
         NsCUPxUbgnOkZUxhlf1s/lfBmtouNzITgCxb2u+MtwdijXjHaPrWiZP3H0K/vF37QQCl
         1Iwg==
X-Forwarded-Encrypted: i=1; AJvYcCVBC/ACEKw1jrUlwDYkn5wT0uas7GntkKxs4Me+wwcC/AxE2onn5IT3obrqBBBJU8v6+HRL7Vu8dNzpdkfUjBVxSFxthUrJX5E=
X-Gm-Message-State: AOJu0YxO3RTFJz2XUU192le6qP8QeyIj/I4WCx9eBBbLZTDoCX+MKdbw
	yxNlTCJoeBbE9KHPV+PGTaii65ufkM1G9g+JgAqiyN8qT7RzYS00LfdbTNond7hFSQw80qmX3h5
	VJJrgEDBCgDKkRqtJS2if4rtJ0yRHEU5V36x98BIo14xwU/4Fu8cVty0=
X-Google-Smtp-Source: AGHT+IECcA58JwTwKmPW9w3HsnoyKI8G9uHOhq/XgpAkFMrQg6ZCHsi88IFMOAM21hc/20xUT6xj6kmkBEKV/rbQxil0vQ9sdD3N
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:3426:b0:7f6:1f4c:96b6 with SMTP id
 ca18e2360f4ac-7f62ee9d66emr47517939f.3.1719867020939; Mon, 01 Jul 2024
 13:50:20 -0700 (PDT)
Date: Mon, 01 Jul 2024 13:50:20 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d82187061c35bef8@google.com>
Subject: [syzbot] [io-uring?] WARNING in io_cqring_event_overflow (2)
From: syzbot <syzbot+f7f9c893345c5c615d34@syzkaller.appspotmail.com>
To: asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    74564adfd352 Add linux-next specific files for 20240701
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=135c21d1980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=111e4e0e6fbde8f0
dashboard link: https://syzkaller.appspot.com/bug?extid=f7f9c893345c5c615d34
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/04b8d7db78fb/disk-74564adf.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/d996f4370003/vmlinux-74564adf.xz
kernel image: https://storage.googleapis.com/syzbot-assets/6e7e630054e7/bzImage-74564adf.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+f7f9c893345c5c615d34@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 0 PID: 5145 at io_uring/io_uring.c:703 io_cqring_event_overflow+0x442/0x660 io_uring/io_uring.c:703
Modules linked in:
CPU: 0 UID: 0 PID: 5145 Comm: kworker/0:4 Not tainted 6.10.0-rc6-next-20240701-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/07/2024
Workqueue: events io_fallback_req_func
RIP: 0010:io_cqring_event_overflow+0x442/0x660 io_uring/io_uring.c:703
Code: 0f 95 c0 48 83 c4 20 5b 41 5c 41 5d 41 5e 41 5f 5d c3 cc cc cc cc e8 ed ae ed fc 90 0f 0b 90 e9 c5 fc ff ff e8 df ae ed fc 90 <0f> 0b 90 e9 6e fc ff ff e8 d1 ae ed fc c6 05 f6 ea f3 0a 01 90 48
RSP: 0018:ffffc900040d7a08 EFLAGS: 00010293
RAX: ffffffff84a5cf11 RBX: 0000000000000000 RCX: ffff8880299bbc00
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: ffffffff84a5cb74 R09: 0000000000000000
R10: dffffc0000000000 R11: ffffffff84a9f5d0 R12: ffff888021d0a000
R13: 0000000000000000 R14: ffff888021d0a000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8880b9400000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f4e669ff800 CR3: 000000002a360000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 __io_post_aux_cqe io_uring/io_uring.c:816 [inline]
 io_add_aux_cqe+0x27c/0x320 io_uring/io_uring.c:837
 io_msg_tw_complete+0x9d/0x4d0 io_uring/msg_ring.c:78
 io_fallback_req_func+0xce/0x1c0 io_uring/io_uring.c:256
 process_one_work kernel/workqueue.c:3224 [inline]
 process_scheduled_works+0xa2c/0x1830 kernel/workqueue.c:3305
 worker_thread+0x86d/0xd40 kernel/workqueue.c:3383
 kthread+0x2f0/0x390 kernel/kthread.c:389
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:144
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
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

