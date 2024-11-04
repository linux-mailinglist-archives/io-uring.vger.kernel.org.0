Return-Path: <io-uring+bounces-4398-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 44D179BB138
	for <lists+io-uring@lfdr.de>; Mon,  4 Nov 2024 11:36:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B8B501F21D91
	for <lists+io-uring@lfdr.de>; Mon,  4 Nov 2024 10:36:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83C431B0F34;
	Mon,  4 Nov 2024 10:36:27 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6D001B0F26
	for <io-uring@vger.kernel.org>; Mon,  4 Nov 2024 10:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730716587; cv=none; b=DbjoqVK9SwoIBZkRnJxB7EDw+gPYvQNSuMIrEoPlp+hvgmusqM82YCUmfhIiCMKDdh0W8ymfDm/QJnCvnfjQ8tchGmkOIrvFMfbK7znSQ3eXbac1ycsO/ntdfs8wfxOQyl2LLnb3BKnJFobLao07xMAYBQ6lDhPthbHyJq3MZSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730716587; c=relaxed/simple;
	bh=OeXcuUqLK9bYzAA1BHzDEgYwPgFv19Wfs0jvrMvUS8Y=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=oSt2tCA9IVm1J0mD6OSmD5V+ChyVf+htBcF3ylhAU2yrznh+M5frPWYxpHMSYe78s/KO8ebske40yuvZVroNiPWANCav0eB2Jh10JORZ7LArqjNXmQVBMH+iyqTLY673FsBY7GybPimTrFQPuT9HVBXz4iUBNkTXaSIWjJPu7vA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3a3fa97f09cso42145915ab.0
        for <io-uring@vger.kernel.org>; Mon, 04 Nov 2024 02:36:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730716585; x=1731321385;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=45MKnYCR0HjR6EAdmcVBnlWYHf7EelS6cbO1gpSSq88=;
        b=Ty2ZFMxTn2NJEgmPwcBL5FcXq3cxxRePqMeoPIFYON7OEdyuDNbnER4vCh/R3vQg2R
         WzLDF/9i6s4jX8Oh6V3okufXm09c9tFTlBof7vUSKgPbuRk4sBB1CkHgddEnbde6kyJ7
         uA4ESW5YUtNblskGmyKHwES++YlaLeRVhRnVdg2DnWRI6jy8PIBi+vwOqLlADZzZiQCl
         aUPJ4XD7depLqCDuUBOWcTiI7tjB8O1Fd9/bQdTKuNFIXBmWw+MyNYvF+oLZL83V9mpz
         NDqzZMvxYRnc6M6mguEJwJamB3I+Hk8LT67q3blRCkOXS2r+RgK3gcyzD/q6JeCKpbnv
         gUBA==
X-Forwarded-Encrypted: i=1; AJvYcCUJgcUSCa9ZvL20sjp5XyXxw09hL5HjpfWd2windzE4JkmsYupSKAM2a5elcJeEaNoiL0y6sgqcew==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxrwy4v9LhugWPXhq38Zo3/7A1oejeFHV/fSJV7xcKLnWHKFJhr
	AT3BV0d2IxsYos6YLKsFOA6qTi5J/iSmspZCu1flRN8xag/4OakUPJyZ83r8I20Ivt2ZJKgGh59
	KvC6P0sAcE4kIwGOy37QcEDRBMqRlYH3IjNmLbHoTLTl7+oxqosYn8GE=
X-Google-Smtp-Source: AGHT+IHoGvGypx3NhStEVQDjdPhANng44DlnJGQ1DlDnMH5qtrMfgbn8AVZHdpkDjoLrjHec5/EDNltbCvS8IJcFrguYOE7jSkvp
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:13a5:b0:3a0:98b2:8f3b with SMTP id
 e9e14a558f8ab-3a6b026372fmr121545735ab.7.1730716583498; Mon, 04 Nov 2024
 02:36:23 -0800 (PST)
Date: Mon, 04 Nov 2024 02:36:23 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6728a3a7.050a0220.35b515.01b9.GAE@google.com>
Subject: [syzbot] [io-uring?] [usb?] WARNING in io_get_cqe_overflow (2)
From: syzbot <syzbot+e333341d3d985e5173b2@syzkaller.appspotmail.com>
To: asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    c88416ba074a Add linux-next specific files for 20241101
git tree:       linux-next
console+strace: https://syzkaller.appspot.com/x/log.txt?x=14c04740580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=704b6be2ac2f205f
dashboard link: https://syzkaller.appspot.com/bug?extid=e333341d3d985e5173b2
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16ec06a7980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12c04740580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/760a8c88d0c3/disk-c88416ba.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/46e4b0a851a2/vmlinux-c88416ba.xz
kernel image: https://storage.googleapis.com/syzbot-assets/428e2c784b75/bzImage-c88416ba.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e333341d3d985e5173b2@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 1 PID: 3508 at io_uring/io_uring.h:142 io_lockdep_assert_cq_locked io_uring/io_uring.h:142 [inline]
WARNING: CPU: 1 PID: 3508 at io_uring/io_uring.h:142 io_get_cqe_overflow+0x43f/0x590 io_uring/io_uring.h:166
Modules linked in:
CPU: 1 UID: 0 PID: 3508 Comm: kworker/u8:8 Not tainted 6.12.0-rc5-next-20241101-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
Workqueue: iou_exit io_ring_exit_work
RIP: 0010:io_lockdep_assert_cq_locked io_uring/io_uring.h:142 [inline]
RIP: 0010:io_get_cqe_overflow+0x43f/0x590 io_uring/io_uring.h:166
Code: 0f 0b 90 e9 62 fc ff ff e8 fe 43 ec fc 90 0f 0b 90 e9 90 fe ff ff e8 f0 43 ec fc 90 0f 0b 90 e9 82 fe ff ff e8 e2 43 ec fc 90 <0f> 0b 90 e9 74 fe ff ff e8 d4 43 ec fc 90 0f 0b 90 e9 66 fe ff ff
RSP: 0018:ffffc9000d0df810 EFLAGS: 00010293
RAX: ffffffff84a97a1e RBX: ffff888034e58000 RCX: ffff888032328000
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
RBP: 0000000000000001 R08: ffffffff84a97821 R09: fffff52001a1befc
R10: dffffc0000000000 R11: fffff52001a1befc R12: 0000000000000000
R13: dffffc0000000000 R14: dffffc0000000000 R15: ffffc9000d0df8a0
FS:  0000000000000000(0000) GS:ffff8880b8700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fd6dd6c11f0 CR3: 000000004b8ac000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 io_get_cqe io_uring/io_uring.h:182 [inline]
 io_fill_cqe_aux io_uring/io_uring.c:822 [inline]
 __io_post_aux_cqe io_uring/io_uring.c:843 [inline]
 io_post_aux_cqe+0xe5/0x420 io_uring/io_uring.c:855
 io_free_rsrc_node+0xe3/0x220 io_uring/rsrc.c:453
 io_put_rsrc_node io_uring/rsrc.h:81 [inline]
 io_rsrc_data_free+0xf2/0x200 io_uring/rsrc.c:140
 io_free_file_tables+0x23/0x70 io_uring/filetable.c:52
 io_sqe_files_unregister+0x53/0x140 io_uring/rsrc.c:477
 io_ring_ctx_free+0x49/0xdb0 io_uring/io_uring.c:2715
 io_ring_exit_work+0x80f/0x8a0 io_uring/io_uring.c:2952
 process_one_work kernel/workqueue.c:3229 [inline]
 process_scheduled_works+0xa63/0x1850 kernel/workqueue.c:3310
 worker_thread+0x870/0xd30 kernel/workqueue.c:3391
 kthread+0x2f0/0x390 kernel/kthread.c:389
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
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

