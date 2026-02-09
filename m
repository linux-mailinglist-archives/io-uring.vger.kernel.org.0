Return-Path: <io-uring+bounces-12109-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6JGPANwmimlKHwAAu9opvQ
	(envelope-from <io-uring+bounces-12109-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 09 Feb 2026 19:26:36 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 0ECB111384A
	for <lists+io-uring@lfdr.de>; Mon, 09 Feb 2026 19:26:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 305D6300691D
	for <lists+io-uring@lfdr.de>; Mon,  9 Feb 2026 18:26:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 078DC309DDC;
	Mon,  9 Feb 2026 18:26:29 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f77.google.com (mail-oo1-f77.google.com [209.85.161.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEB662FC000
	for <io-uring@vger.kernel.org>; Mon,  9 Feb 2026 18:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770661588; cv=none; b=bxkuBRdYiUd6sJR2vsKZUYIrnRWwfHWv1mEXOz6Nd/jjMgWqOfJ9QRHf7plkt+yo+1bS0wXp5PId2JbgkAgZkEPlRrjks1+AXGSrRaod7IQuWGgLPn7LOWPtgKMwRRIyThcOneZolhLlBX/oDpHDM6pmi82UFIaEURVWi4swMCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770661588; c=relaxed/simple;
	bh=kATcJXYpKadbYPrOB/jOUbVWpAu0Y6sTBp3MryIKec4=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=bVdvwQ+Sy0IkgxWti7fBSilEomyISuUN1ulOschU01yRFhhLz8akZ45/EmVvHy3DtM8QmbMtM0dQDTVuxasc7s1JWe1beWm4NN48BvSXDlEj91AhQuIWr6HJirWTFPxHAQ/Sg6vDzyK0hol1rgc2nArrlVw3AqHrpiA6ZbrnfHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f77.google.com with SMTP id 006d021491bc7-66b8c7f0debso16480eaf.3
        for <io-uring@vger.kernel.org>; Mon, 09 Feb 2026 10:26:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770661587; x=1771266387;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=d6K6HwARsQ9angFtuKgjbdlRRHqLC0+biKqQLvtr5M0=;
        b=q4pvL+y8MM6qaw8hBUbCJdCjliYc6Qkt8o+cCD+hm3GyrFhL6vnJXMJZmzMGCdR2qg
         G0McNkX0GhqaLFXZVAPdjesouHz8A0bULQCr+xAi1x8vzw2wfd+Elg4N6Od6eHIEjLUB
         +V9p1b9uVTBBbDWVewV5IereJ4ITiM0VR2ZmhGl77G8WSMDdzb/RFAR8Eh+TCIzaZzPH
         E6/R0Vqs3nsqy7sy2359Lt3h/roRgSDuGMn/CdDW15xZVbfxD30GoHCwaBWuttUq4D7w
         Yj34eRK43jb8qI4S7px5OOcHFo9E2+DE4BiD/TwINAnhEe3bZ1+xM3vvdp7nRGMQ4TkP
         x2IQ==
X-Forwarded-Encrypted: i=1; AJvYcCXSJbewNr5T3V2UaTlK2WRiak+6S/EPchwEJfMf9+zukJpffXDbZlB+ejY3LLM6wuQ+iK9iZT0lfA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyBLQn0HYgUAyuHM/FuF3rNgMSxsgZISBIpAMq2x4NHwnZqt3zh
	s5VDp2WMyGO2Ws1Mh2ru9hAYHfX7KBCSJ3hjmxiGcdL/5aJMblUScXN2UyNaxTlE3gjsNB5TvJb
	MJy4gGLMPhgSJCGpCjCsx9f4/loSC7o5pLe7njYZ7QYlxCOuPZB2GFruXEjo=
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a4a:ee18:0:b0:660:ffcf:42e7 with SMTP id
 006d021491bc7-66d0a3806cbmr5580323eaf.30.1770661587718; Mon, 09 Feb 2026
 10:26:27 -0800 (PST)
Date: Mon, 09 Feb 2026 10:26:27 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <698a26d3.050a0220.3b3015.007d.GAE@google.com>
Subject: [syzbot] [io-uring?] BUG: corrupted list in io_poll_remove_entries
From: syzbot <syzbot+ab12f0c08dd7ab8d057c@syzkaller.appspotmail.com>
To: axboe@kernel.dk, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.36 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	URI_HIDDEN_PATH(1.00)[https://syzkaller.appspot.com/x/.config?x=f1fac0919970b671];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	DMARC_POLICY_SOFTFAIL(0.10)[appspotmail.com : SPF not aligned (relaxed), No valid DKIM,none];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_THREE(0.00)[4];
	TAGGED_FROM(0.00)[bounces-12109-lists,io-uring=lfdr.de,ab12f0c08dd7ab8d057c];
	MISSING_XM_UA(0.00)[];
	SUBJECT_HAS_QUESTION(0.00)[];
	MIME_TRACE(0.00)[0:+];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[syzbot@syzkaller.appspotmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	R_DKIM_NA(0.00)[];
	REDIRECTOR_URL(0.00)[goo.gl];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,appspotmail.com:email,googlegroups.com:email,syzkaller.appspot.com:url]
X-Rspamd-Queue-Id: 0ECB111384A
X-Rspamd-Action: no action

Hello,

syzbot found the following issue on:

HEAD commit:    e7aa57247700 Merge tag 'spi-fix-v6.19-rc8' of git://git.ke..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14d3b65a580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f1fac0919970b671
dashboard link: https://syzkaller.appspot.com/bug?extid=ab12f0c08dd7ab8d057c
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1222965a580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=140e833a580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/c46beb4ff3a5/disk-e7aa5724.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/d162bcaaf9b9/vmlinux-e7aa5724.xz
kernel image: https://storage.googleapis.com/syzbot-assets/54b0844b8ea7/bzImage-e7aa5724.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+ab12f0c08dd7ab8d057c@syzkaller.appspotmail.com

list_del corruption. prev->next should be ffff88807dc6c3f0, but was ffff888146b205c8. (prev=ffff888146b205c8)
------------[ cut here ]------------
kernel BUG at lib/list_debug.c:62!
Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5969 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/24/2026
RIP: 0010:__list_del_entry_valid_or_report+0x14a/0x1d0 lib/list_debug.c:62
Code: 00 00 fc ff df 48 c1 ea 03 80 3c 02 00 0f 85 8d 00 00 00 48 8b 55 00 48 89 e9 48 89 de 48 c7 c7 40 3d fa 8b e8 37 b0 32 fc 90 <0f> 0b 4c 89 e7 e8 3c 24 5d fd 48 89 ea 48 b8 00 00 00 00 00 fc ff
RSP: 0018:ffffc90003bffaa8 EFLAGS: 00010082
RAX: 000000000000006d RBX: ffff88807dc6c3f0 RCX: 0000000000000000
RDX: 000000000000006d RSI: ffffffff81e5d6c9 RDI: fffff5200077ff46
RBP: ffff888146b205c8 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000080000001 R11: 0000000000000000 R12: ffff88807dc6c2b0
R13: ffff88807dc6c408 R14: ffff88807dc6c3f0 R15: ffff88807dc6c3c8
FS:  0000000000000000(0000) GS:ffff8881245d9000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f60e56708c0 CR3: 000000006b065000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 __list_del_entry_valid include/linux/list.h:132 [inline]
 __list_del_entry include/linux/list.h:223 [inline]
 list_del_init include/linux/list.h:295 [inline]
 io_poll_remove_waitq io_uring/poll.c:149 [inline]
 io_poll_remove_entry io_uring/poll.c:166 [inline]
 io_poll_remove_entries.part.0+0x156/0x7e0 io_uring/poll.c:197
 io_poll_remove_entries io_uring/poll.c:177 [inline]
 io_poll_task_func+0x39e/0xe30 io_uring/poll.c:343
 io_handle_tw_list+0x194/0x580 io_uring/io_uring.c:1122
 tctx_task_work_run+0x57/0x2b0 io_uring/io_uring.c:1182
 tctx_task_work+0x7a/0xd0 io_uring/io_uring.c:1200
 task_work_run+0x150/0x240 kernel/task_work.c:233
 exit_task_work include/linux/task_work.h:40 [inline]
 do_exit+0x829/0x2a30 kernel/exit.c:971
 do_group_exit+0xd5/0x2a0 kernel/exit.c:1112
 __do_sys_exit_group kernel/exit.c:1123 [inline]
 __se_sys_exit_group kernel/exit.c:1121 [inline]
 __x64_sys_exit_group+0x3e/0x50 kernel/exit.c:1121
 x64_sys_call+0x14fd/0x1510 arch/x86/include/generated/asm/syscalls_64.h:232
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xc9/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f60e579aeb9
Code: Unable to access opcode bytes at 0x7f60e579ae8f.
RSP: 002b:00007ffc2d47ddf8 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f60e579aeb9
RDX: 0000000000000064 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000003 R08: 0000000000000000 R09: 00007f60e59e1280
R10: 0000000000000001 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f60e59e1280 R14: 0000000000000003 R15: 00007ffc2d47deb0
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:__list_del_entry_valid_or_report+0x14a/0x1d0 lib/list_debug.c:62
Code: 00 00 fc ff df 48 c1 ea 03 80 3c 02 00 0f 85 8d 00 00 00 48 8b 55 00 48 89 e9 48 89 de 48 c7 c7 40 3d fa 8b e8 37 b0 32 fc 90 <0f> 0b 4c 89 e7 e8 3c 24 5d fd 48 89 ea 48 b8 00 00 00 00 00 fc ff
RSP: 0018:ffffc90003bffaa8 EFLAGS: 00010082
RAX: 000000000000006d RBX: ffff88807dc6c3f0 RCX: 0000000000000000
RDX: 000000000000006d RSI: ffffffff81e5d6c9 RDI: fffff5200077ff46
RBP: ffff888146b205c8 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000080000001 R11: 0000000000000000 R12: ffff88807dc6c2b0
R13: ffff88807dc6c408 R14: ffff88807dc6c3f0 R15: ffff88807dc6c3c8
FS:  0000000000000000(0000) GS:ffff8881245d9000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f60e56708c0 CR3: 000000006b065000 CR4: 00000000003526f0


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

