Return-Path: <io-uring+bounces-4810-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 331B59D1F66
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 05:38:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EDFCB280DA2
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 04:38:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0029149C57;
	Tue, 19 Nov 2024 04:38:29 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 432621459F6
	for <io-uring@vger.kernel.org>; Tue, 19 Nov 2024 04:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731991109; cv=none; b=o7hVBmUJ+nzItL645YlgtVbkNDudAWkEV9+kPkwecBtdELQ3bPmIyWaDbJZMRi0crvFktjCXSLuGrqzRcuNos2siEwDg7I9fMl9GiYQXAsprJLI/E4yaC5OKhMPl8KvUWTlyh6cXlZsUg7aVd3/PK9qG1vPDXi3wpq6uzw6Sz9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731991109; c=relaxed/simple;
	bh=at7JDw2wSlb9prZGsNeSTPouS27shd0nnref3sxOBew=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=upICpIvUiq4XH/DRe5J7Y1OELYrvhOXiPc57M1aT24ELrBixZFI8Tss2f3njzc8nJAkF2HYG1bBBOdzLOPlJS8dyXhgxSuNEyZoheI/zwY59j4ohJxWhs/jybkI1w38ZdMv1A7zpQh3nsp9kGI5oIe1iYREvIqg0fmsbtnjJ0/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3a763a5464fso25875275ab.2
        for <io-uring@vger.kernel.org>; Mon, 18 Nov 2024 20:38:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731991107; x=1732595907;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PyhytCsuWindymjmcYTPQlyB9D+gYqumk2oyZHJvxds=;
        b=iGhRCv+1C1M2/b6o8yN7IDXJHlUdcy5dCwyZWIPtX5rIoQOgQsdhm17jfuPIc/84RV
         jhOJFeIQx3gYaxMvWUberI60XPovdSJ4UW2EgghXlSSjYAZVaZAA7dXD8duJcz7hzcih
         JcYia/dK9tut9nA2Z61su+rK8o8pFJz8gHoRydSya8PpHaf3m/JgrKoaeYGkdDzlTcct
         vFfTJxVVvNAHxDqy/67b4P4W45tUvK/QB5n6bzM/5INuijMuAMIXdG0WjjaKwE09dYas
         HGhagHs4J7lnP7enoikORyPS/vVN11sQTLp2Vfy101+KvdGOzpkv4Oo9QCDQtByW9YRE
         9vLA==
X-Forwarded-Encrypted: i=1; AJvYcCWOHVJTMTS65pPAJKlatTGvumYohKE/7yoJtq2n9her8cVWLxnTZN6j7Y+JsCS4V5DdPfxOCdQQ0w==@vger.kernel.org
X-Gm-Message-State: AOJu0YxV5KLaVbAG3gywn0/f2HhKWiee60liEvTh78be11B2k4NBh/Mt
	vtx+F5WqORUb6hoQJnHIvGXqbVkpdplGzouyFOU18g8KMEzE46Y4npefsLfBiVVju2NbtM4xVsV
	gkeg8PXYtzcypUz0pxMjJ5RTfyIWb3Xhho7HyG0xGiLsrtSnTTzyEcc0=
X-Google-Smtp-Source: AGHT+IHA5E9xSdc8gM4f7gYs8Mm9n9qUSQftEHTZ404DRN4cM+4ZCbQGJbF9HOpVXfhPFHW40PnGfWeFs1u3+F6oJGN3fSBIuQRH
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:3205:b0:3a7:1cf9:2427 with SMTP id
 e9e14a558f8ab-3a747ffa0bemr149373155ab.2.1731991107438; Mon, 18 Nov 2024
 20:38:27 -0800 (PST)
Date: Mon, 18 Nov 2024 20:38:27 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <673c1643.050a0220.87769.0066.GAE@google.com>
Subject: [syzbot] [io-uring?] WARNING in __io_uring_free
From: syzbot <syzbot+cc36d44ec9f368e443d3@syzkaller.appspotmail.com>
To: asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    cfaaa7d010d1 Merge tag 'net-6.12-rc8' of git://git.kernel...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13005cc0580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d2aeec8c0b2e420c
dashboard link: https://syzkaller.appspot.com/bug?extid=cc36d44ec9f368e443d3
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-cfaaa7d0.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/63eae0d3e67f/vmlinux-cfaaa7d0.xz
kernel image: https://storage.googleapis.com/syzbot-assets/6495d9e4ddee/bzImage-cfaaa7d0.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+cc36d44ec9f368e443d3@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 0 PID: 16 at io_uring/tctx.c:51 __io_uring_free+0xfa/0x140 io_uring/tctx.c:51
Modules linked in:
CPU: 0 UID: 0 PID: 16 Comm: ksoftirqd/0 Not tainted 6.12.0-rc7-syzkaller-00125-gcfaaa7d010d1 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:__io_uring_free+0xfa/0x140 io_uring/tctx.c:51
Code: 80 7c 25 00 00 74 08 4c 89 f7 e8 a1 8a 49 fd 49 c7 06 00 00 00 00 5b 41 5c 41 5d 41 5e 41 5f c3 cc cc cc cc e8 37 ad df fc 90 <0f> 0b 90 e9 6a ff ff ff e8 29 ad df fc 90 0f 0b 90 eb 84 e8 1e ad
RSP: 0018:ffffc900004279b8 EFLAGS: 00010246
RAX: ffffffff84b53cd9 RBX: ffff88804fc3b8e0 RCX: ffff88801b7e8000
RDX: 0000000000000100 RSI: 0000000000000000 RDI: ffff88801f058000
RBP: 0000000000000001 R08: ffffffff8154d881 R09: 1ffff11003e0b005
R10: dffffc0000000000 R11: ffffed1003e0b006 R12: dffffc0000000000
R13: 1ffff11003e0b120 R14: ffff88801f058900 R15: ffff88804fc3b800
FS:  0000000000000000(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005594393ad338 CR3: 000000000e734000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 io_uring_free include/linux/io_uring.h:31 [inline]
 __put_task_struct+0xd5/0x290 kernel/fork.c:975
 put_task_struct include/linux/sched/task.h:144 [inline]
 delayed_put_task_struct+0x125/0x300 kernel/exit.c:228
 rcu_do_batch kernel/rcu/tree.c:2567 [inline]
 rcu_core+0xaaa/0x17a0 kernel/rcu/tree.c:2823
 handle_softirqs+0x2c5/0x980 kernel/softirq.c:554
 run_ksoftirqd+0xca/0x130 kernel/softirq.c:927
 smpboot_thread_fn+0x544/0xa30 kernel/smpboot.c:164
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

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup

