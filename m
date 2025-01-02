Return-Path: <io-uring+bounces-5653-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 18D1AA00063
	for <lists+io-uring@lfdr.de>; Thu,  2 Jan 2025 22:00:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0333F3A3C19
	for <lists+io-uring@lfdr.de>; Thu,  2 Jan 2025 21:00:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 411C91B6D09;
	Thu,  2 Jan 2025 20:59:27 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f77.google.com (mail-io1-f77.google.com [209.85.166.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EB981B87FC
	for <io-uring@vger.kernel.org>; Thu,  2 Jan 2025 20:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735851567; cv=none; b=cdIJX7k+bqGA5Hsn0+mAlwhLWm3t2etpDYOge2Nt31dLKQ8w9/S0H9zUSl3tCg9gdHOqWYxTfWMWyg78jazUpr5omWD1aq5J9dPKq+v8C3K88feTIQLTGfY93kmg9MeHF04bqz1Wm1p/zem7bs8sk9AlJdnkheWGJywUL4C5HgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735851567; c=relaxed/simple;
	bh=pK9UTlpZTWLqNCkFYHu3iBdiCSTP1TJq3se7MqDfmCc=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=WHnjhAZKeXnWxorejqG+736LINU/Ag7wUSpFhUJlOigk0ZrYpCVmqRWmvPDJYOG0EJn7Inau/W4Ez23H0pRL2u3ABQkVZ+4SYjYnKUNbgy15S8P1s5KI0vQuvs6mTZYl8SBP+fUOCndv8TOwExG2BP06UqdtyFF4agVN3ZGTBBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f77.google.com with SMTP id ca18e2360f4ac-844e9b88efeso1868875539f.0
        for <io-uring@vger.kernel.org>; Thu, 02 Jan 2025 12:59:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735851564; x=1736456364;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PFCYjf2KYX8l97/0DZrsIltyvJp6mXarDmtiT0VBbps=;
        b=O0RRZEink7Nf1vHba1o45pNrzMsxRuNQ3gykpJYJ+Z7AsVOQkA9G/iDuV5E/SkEvxW
         /Be1mW2IC4xNBIDvGjRNGdVSFOaThL9l+vafjji/XEczDk+vJknDDPiWf1kVxFTaCOSG
         k8vJsXJP1nSfUfvMJEQjvmAjJ50dw43EH8CjAfh1EDViCJnF7JidAjHgu45WuKZLCDHJ
         KayHfTFlUdww6IhaiIqhJiD3/eR2z9M7Wy7TyDwfyTxAgqJkYauJ9zoWU2Z/iW3A9aP9
         lPIFqF6ipvakydkleXDWoijNGpaUJHzFHyd9QAF/CsB9YcbJCD1CULBt96vL999DGlcK
         Tvqg==
X-Forwarded-Encrypted: i=1; AJvYcCXVHZ/tUyArwc79qgfhj7ARIOuo8oq4IA2H+PuynkRXbPGDbJgJv2F4BXGq3ljRV+BvqXPNt1348A==@vger.kernel.org
X-Gm-Message-State: AOJu0YzdeJCJXexwee3sxFOcSdcYhonjbQY4TpvAUdjnCH5bI4UPQD6C
	MEqb8euAP9hnQh7ajOBFYAyIXfw/5/eQzA8Ps618VVmmKHJ7Jj+BbEBvJblA+t1OBQbzh8j/XCF
	UjikauTC5Ge49BIAhL/JaFBGzm5MxK3a94CLylNdr0RpNPzrelM4ArFg=
X-Google-Smtp-Source: AGHT+IH5LotNtez4Cc9TiAXbqMKSrSFmbKVdeMnbofSj/hPokw5fU0/GAdZcBP89Jd19S38u4ACiMKaKxZsCgpTDVRU+Bt4zX1Mk
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:318c:b0:3a7:c5c8:aa53 with SMTP id
 e9e14a558f8ab-3c2d2d51374mr429659085ab.13.1735851564551; Thu, 02 Jan 2025
 12:59:24 -0800 (PST)
Date: Thu, 02 Jan 2025 12:59:24 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6776fe2c.050a0220.3a8527.0054.GAE@google.com>
Subject: [syzbot] [io-uring?] KMSAN: uninit-value in io_recv
From: syzbot <syzbot+068ff190354d2f74892f@syzkaller.appspotmail.com>
To: asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    8379578b11d5 Merge tag 'for-v6.13-rc' of git://git.kernel...
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=1713fadf980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f9048090d7bb0d06
dashboard link: https://syzkaller.appspot.com/bug?extid=068ff190354d2f74892f
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1360d2c4580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11278818580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/fbfb6bbe8da9/disk-8379578b.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/d0d8a8059222/vmlinux-8379578b.xz
kernel image: https://storage.googleapis.com/syzbot-assets/a102540c5698/bzImage-8379578b.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+068ff190354d2f74892f@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in io_recv_buf_select io_uring/net.c:1094 [inline]
BUG: KMSAN: uninit-value in io_recv+0x930/0x1f90 io_uring/net.c:1158
 io_recv_buf_select io_uring/net.c:1094 [inline]
 io_recv+0x930/0x1f90 io_uring/net.c:1158
 io_issue_sqe+0x420/0x2130 io_uring/io_uring.c:1740
 io_queue_sqe io_uring/io_uring.c:1950 [inline]
 io_req_task_submit+0xfa/0x1d0 io_uring/io_uring.c:1374
 io_handle_tw_list+0x55f/0x5c0 io_uring/io_uring.c:1057
 tctx_task_work_run+0x109/0x3e0 io_uring/io_uring.c:1121
 tctx_task_work+0x6d/0xc0 io_uring/io_uring.c:1139
 task_work_run+0x268/0x310 kernel/task_work.c:239
 io_run_task_work+0x43a/0x4a0 io_uring/io_uring.h:343
 io_cqring_wait io_uring/io_uring.c:2527 [inline]
 __do_sys_io_uring_enter io_uring/io_uring.c:3439 [inline]
 __se_sys_io_uring_enter+0x204f/0x4ce0 io_uring/io_uring.c:3330
 __x64_sys_io_uring_enter+0x11f/0x1a0 io_uring/io_uring.c:3330
 x64_sys_call+0xce5/0x3c30 arch/x86/include/generated/asm/syscalls_64.h:427
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcd/0x1e0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Uninit was created at:
 slab_post_alloc_hook mm/slub.c:4125 [inline]
 slab_alloc_node mm/slub.c:4168 [inline]
 __do_kmalloc_node mm/slub.c:4297 [inline]
 __kmalloc_noprof+0x923/0x1230 mm/slub.c:4310
 kmalloc_noprof include/linux/slab.h:905 [inline]
 io_alloc_async_data+0xc0/0x220 io_uring/io_uring.c:1651
 io_msg_alloc_async io_uring/net.c:175 [inline]
 io_recvmsg_prep_setup io_uring/net.c:750 [inline]
 io_recvmsg_prep+0xbe8/0x1a20 io_uring/net.c:831
 io_init_req io_uring/io_uring.c:2120 [inline]
 io_submit_sqe io_uring/io_uring.c:2167 [inline]
 io_submit_sqes+0x1082/0x2f80 io_uring/io_uring.c:2322
 __do_sys_io_uring_enter io_uring/io_uring.c:3395 [inline]
 __se_sys_io_uring_enter+0x409/0x4ce0 io_uring/io_uring.c:3330
 __x64_sys_io_uring_enter+0x11f/0x1a0 io_uring/io_uring.c:3330
 x64_sys_call+0xce5/0x3c30 arch/x86/include/generated/asm/syscalls_64.h:427
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcd/0x1e0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

CPU: 1 UID: 0 PID: 5781 Comm: syz-executor452 Not tainted 6.13.0-rc4-syzkaller-00069-g8379578b11d5 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
=====================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

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

