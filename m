Return-Path: <io-uring+bounces-2950-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A0A2395E0CA
	for <lists+io-uring@lfdr.de>; Sun, 25 Aug 2024 05:15:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 56E3A1F219B5
	for <lists+io-uring@lfdr.de>; Sun, 25 Aug 2024 03:15:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D7873D62;
	Sun, 25 Aug 2024 03:15:21 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E14B77462
	for <io-uring@vger.kernel.org>; Sun, 25 Aug 2024 03:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724555721; cv=none; b=O2jief7GA0twaIkhDzOU+EkGiBElm9sJrdmNNoCCxQWBuYoiWLVSizCG6fAwI/2izl66aiqBWTVRhzOmmM4AaSphvIX04OkJwsqHcuwvo5lPhYEFX4ixuLbyoMGdrPfqIGOsJ02HVdCs4EOH1a320oosWibl+JsBoTSxblAsYP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724555721; c=relaxed/simple;
	bh=RK5NfLsyx4eUhsXeDSvEl18nl5lCXp1CulpGwaImu5s=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=Tu8a4N9OjpqRt06mVWngxOyYjR0wi2sh8zJu/f7Z6wPCJ3T0REqx3MHt/85fyXemfa6K4SqT7cnmM6WkUtzBjcW8V/nI4VLLt8NmQ4kZdOFPKKj3J2XFVPSUzR6kD925ScWUxR9Jp2dDdYfqW7mumpU9cXXzDEn4m4ni5NoJnoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-81faf98703eso366217739f.3
        for <io-uring@vger.kernel.org>; Sat, 24 Aug 2024 20:15:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724555719; x=1725160519;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YWkUy50VSZCVMxhPPIPKFCnvvr9xmzUrWiRrVivNeWI=;
        b=IDgNW9A7wixHJTmXWSTZcByP+VRqnH3DxRpH7VF6mQVk2f3yO1Ioh0pJ/Yf0d+01jD
         GXWtnCcnY64G4J6UNNpiz67Lxm8Z7lqmwMR/HkdZoekD99E37m8AQNXhY8xulF85Cfdw
         KLYAD8thOectuYI9BkrqnmDatTWIt3PZ9Wl6YIiLluGizSwk1XpSc35D6PD4sFM1/Ef5
         p5NhTLiJsM/jOBHIUWfZ9DZ/lZnQZuXDOdm1yg9sjivV6F9Agbfz6L9Ro/ePThKIJmrZ
         hW8UJzRvzUD2XDwTlXhfK7U5uB4GtBH0Y9RDzqG7kljqLfn7CGoncS05nEeVihmn2Lqz
         95UA==
X-Forwarded-Encrypted: i=1; AJvYcCUxqQYe02zPhtD0MNV02LeO3MqIW2eb838p1XSlA9fHyq0w6H6HxNXVbs2G6aSKgCTaLzAxw5t+yQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxv3gCK5cgRbcYQewGMspypZo891Fw03r6b7itN14ITaI5cPsoF
	egFhkDpe4MT2QS1wBDA9BVuwn3kcpm4/5ZtN49tkEP4WWS/LwyA3Yp/d5rw5i1PMxc+0AryqkGI
	gZaWykuBZ2F6FmXaoT2BpWxWLnoRM2N5OIs4pJNmsQh74s2BX/KuzvrE=
X-Google-Smtp-Source: AGHT+IGPJdMqpneQMbl9tfnMnbyjtwds5MJLvjyeXxbxE3Dny2XA8kV5JhbaSqgM3LQ+7nMUmT0pcnuZ1zjbE5J1mPqWBiGO44eF
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:c549:0:b0:39b:3c0c:c3a4 with SMTP id
 e9e14a558f8ab-39e3c985c48mr5170605ab.2.1724555718791; Sat, 24 Aug 2024
 20:15:18 -0700 (PDT)
Date: Sat, 24 Aug 2024 20:15:18 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000003a7ed0620796b9d@google.com>
Subject: [syzbot] [io-uring?] WARNING in io_sq_thread
From: syzbot <syzbot+82e078bac56cae572bce@syzkaller.appspotmail.com>
To: asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    bb1b0acdcd66 Add linux-next specific files for 20240820
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1363f893980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=49406de25a441ccf
dashboard link: https://syzkaller.appspot.com/bug?extid=82e078bac56cae572bce
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/ebc2ae824293/disk-bb1b0acd.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/5f62bd0c0e25/vmlinux-bb1b0acd.xz
kernel image: https://storage.googleapis.com/syzbot-assets/ddf6d0bc053d/bzImage-bb1b0acd.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+82e078bac56cae572bce@syzkaller.appspotmail.com

------------[ cut here ]------------
do not call blocking ops when !TASK_RUNNING; state=1 set at [<ffffffff816d32e6>] prepare_to_wait+0x186/0x210 kernel/sched/wait.c:237
WARNING: CPU: 1 PID: 5335 at kernel/sched/core.c:8556 __might_sleep+0xb9/0xe0 kernel/sched/core.c:8552
Modules linked in:
CPU: 1 UID: 0 PID: 5335 Comm: iou-sqp-5333 Not tainted 6.11.0-rc4-next-20240820-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/06/2024
RIP: 0010:__might_sleep+0xb9/0xe0 kernel/sched/core.c:8552
Code: 9d 0e 01 90 42 80 3c 23 00 74 08 48 89 ef e8 3e 9d 97 00 48 8b 4d 00 48 c7 c7 c0 60 0a 8c 44 89 ee 48 89 ca e8 b8 01 f1 ff 90 <0f> 0b 90 90 eb b5 89 d9 80 e1 07 80 c1 03 38 c1 0f 8c 70 ff ff ff
RSP: 0018:ffffc900041e7968 EFLAGS: 00010246
RAX: 11f47f6d1cba3d00 RBX: 1ffff110040802ec RCX: ffff888020400000
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
RBP: ffff888020401760 R08: ffffffff8155acc2 R09: fffffbfff1cfa354
R10: dffffc0000000000 R11: fffffbfff1cfa354 R12: dffffc0000000000
R13: 0000000000000001 R14: 0000000000000249 R15: ffffffff8c0ab880
FS:  00007ffbe99d66c0(0000) GS:ffff8880b9100000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffed4fbfdec CR3: 0000000024c2c000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 __mutex_lock_common kernel/locking/mutex.c:585 [inline]
 __mutex_lock+0xc1/0xd70 kernel/locking/mutex.c:752
 io_sq_thread+0x1310/0x1c40 io_uring/sqpoll.c:367
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

