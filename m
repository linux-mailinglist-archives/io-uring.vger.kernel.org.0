Return-Path: <io-uring+bounces-1709-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DA2E8BADE6
	for <lists+io-uring@lfdr.de>; Fri,  3 May 2024 15:41:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E4B411F21176
	for <lists+io-uring@lfdr.de>; Fri,  3 May 2024 13:41:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B81414A0AB;
	Fri,  3 May 2024 13:41:30 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1691139CF8
	for <io-uring@vger.kernel.org>; Fri,  3 May 2024 13:41:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714743690; cv=none; b=CqjDV0QpEeN6cV5N3+Wju5jnRgDMIzELf+MB4Z1ZtOXkaO9eFlGEV+1SbV5KhJjoyXn5t8WpNtoC3srOh3v7HAUvwOEO+lWhzBW6YzTE3ypzp0FmNW4r2r3eMW6N9rcMSp57U/HuZCYPwIeZIyWqxSFfI+vKKnpBtisVuMjgtRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714743690; c=relaxed/simple;
	bh=YzBsIJFXDqLgDA3FCpHuVIFrGfe1FFzjhQ/UF8NhHI0=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=a3BGXVYNDMtORysPA42JEaCRD0qWIXtGIIEsB6yiZCW+LXX2RKyaqC729ohMNuc4siODhpmjN2IqJ+CNE9EU4FricVVz826D7nO++GAsvRVYAQIA5As4Q7gvNC1fCluvIVTpH+ZoNvU88xLQ8wrfD0bNnsQsO55JsqD2usuIfiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-7def44d6078so141393839f.1
        for <io-uring@vger.kernel.org>; Fri, 03 May 2024 06:41:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714743688; x=1715348488;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pHF73fXV9YBzhlAyLN1LlD3cj+yK8oEXzez72G9MWbY=;
        b=f25DNvM7AHS83eD3Y0i9TArDYw25/MfpMwO2OmxH+SN3rkMElkcCPw5TcIejdiQo0x
         tVXBB8PjdLIwtNAV3Y4bNQ9y8m7zSuw0DUY7MxNmMgc4kH4T9hsmM7ao/XyLiiHkZyJI
         bhsJn7Gdexg3Hl5X6kU6YbLLroa1KNpOneZrkaQvsyrZ9bS1MLZX7HsZBkQXpwbsiwHo
         78nnUFNQifP5+kkUfOrCtu4bGhm9GExmMQtF3tEYtH2D3SX20iSwRUgwIwIKc+rGmym4
         hwk5BuNMZhRSO8AFm2JeHxbMVqDleaz8JtuPnYdaL5NDwXXUhaqFO9YtM4N6O7045I/a
         LtaQ==
X-Forwarded-Encrypted: i=1; AJvYcCW2aH6wsH2buET0cRQKnfDkTmKXtKb1VPCLPYX4x5tBwNIYutNLdoeTZTYwo1arZQl2KHwEw7aKDK0krRXJLngMyeP3wahv7Mk=
X-Gm-Message-State: AOJu0YyNI6gp/wo3aVak5gS9Gaq0f9zaTmE00iuD40IIrHxt8yzxJvQ4
	Xa/mg38A4c4qp1JPOh5CPpKFSNwVklkgbI0ZtXWa6ym+zQeIB7P9J8WKR+UqOMcxnv9oQFwVmjG
	sG5otaRFr6AoqVxgPOFiplQSLJuf4CJQx8hYYtLcJTtYXjtglOWOKSdo=
X-Google-Smtp-Source: AGHT+IGNaS7EuIrM/DtrBgMbQOBFKh5oHIf0eww9bEoUDBoVGZqDbHtx1ynsMXbVfoU1F/2kzogv+fEmPyn/TGBu7pAX2+QVf8Lk
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1389:b0:36c:4c3c:e16 with SMTP id
 d9-20020a056e02138900b0036c4c3c0e16mr93724ilo.2.1714743688106; Fri, 03 May
 2024 06:41:28 -0700 (PDT)
Date: Fri, 03 May 2024 06:41:28 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000006923bb06178ce04a@google.com>
Subject: [syzbot] [mm?] [io-uring?] WARNING in hpage_collapse_scan_pmd (2)
From: syzbot <syzbot+5ea2845f44caa77f5543@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, axboe@kernel.dk, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    e67572cd2204 Linux 6.9-rc6
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=1067d2f8980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3310e643b6ef5d69
dashboard link: https://syzkaller.appspot.com/bug?extid=5ea2845f44caa77f5543
compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10874a40980000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/d3c4905a7f32/disk-e67572cd.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/9e4d1fc8f9c1/vmlinux-e67572cd.xz
kernel image: https://storage.googleapis.com/syzbot-assets/4616b77edaee/bzImage-e67572cd.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+5ea2845f44caa77f5543@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 1 PID: 5288 at arch/x86/include/asm/pgtable.h:403 pte_uffd_wp arch/x86/include/asm/pgtable.h:403 [inline]
WARNING: CPU: 1 PID: 5288 at arch/x86/include/asm/pgtable.h:403 hpage_collapse_scan_pmd+0xd32/0x14c0 mm/khugepaged.c:1316
Modules linked in:
CPU: 1 PID: 5288 Comm: syz-executor.4 Not tainted 6.9.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/27/2024
RIP: 0010:pte_uffd_wp arch/x86/include/asm/pgtable.h:403 [inline]
RIP: 0010:hpage_collapse_scan_pmd+0xd32/0x14c0 mm/khugepaged.c:1316
Code: 90 90 e9 4b f6 ff ff 4c 8b 64 24 48 e8 f7 ee 9e ff 31 ff 4c 89 ee e8 fd e9 9e ff 4d 85 ed 0f 84 b5 01 00 00 e8 df ee 9e ff 90 <0f> 0b 90 41 be 09 00 00 00 0f b6 6c 24 47 48 8b 5c 24 10 e9 fb fa
RSP: 0018:ffffc90003abf9b0 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffff88807a402000 RCX: ffffffff81eed643
RDX: ffff888021ddbc00 RSI: ffffffff81eed651 RDI: 0000000000000007
RBP: 000000006897fc67 R08: 0000000000000007 R09: 0000000000000000
R10: 0000000000000002 R11: 0000000000000002 R12: 0000000020800000
R13: 0000000000000002 R14: 0000000000000400 R15: ffff88801e4dcc00
FS:  00007fd661dde6c0(0000) GS:ffff8880b9500000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f7e57ed9ba1 CR3: 0000000025328000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 madvise_collapse+0x738/0xb10 mm/khugepaged.c:2761
 madvise_vma_behavior+0x202/0x1b20 mm/madvise.c:1074
 madvise_walk_vmas+0x1cf/0x2c0 mm/madvise.c:1248
 do_madvise+0x309/0x640 mm/madvise.c:1428
 __do_sys_madvise mm/madvise.c:1441 [inline]
 __se_sys_madvise mm/madvise.c:1439 [inline]
 __x64_sys_madvise+0xa9/0x110 mm/madvise.c:1439
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcf/0x260 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fd66227dea9
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 e1 20 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fd661dde0c8 EFLAGS: 00000246 ORIG_RAX: 000000000000001c
RAX: ffffffffffffffda RBX: 00007fd6623ac050 RCX: 00007fd66227dea9
RDX: 0000000000000019 RSI: 00000000dfc3efff RDI: 00000000203c1000
RBP: 00007fd6622ca4a4 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 000000000000006e R14: 00007fd6623ac050 R15: 00007ffd98c8dfa8
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

