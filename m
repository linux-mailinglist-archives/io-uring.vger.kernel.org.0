Return-Path: <io-uring+bounces-8898-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id ADAECB1E443
	for <lists+io-uring@lfdr.de>; Fri,  8 Aug 2025 10:17:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 724C818A754C
	for <lists+io-uring@lfdr.de>; Fri,  8 Aug 2025 08:17:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31DF9221FB4;
	Fri,  8 Aug 2025 08:17:31 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f78.google.com (mail-io1-f78.google.com [209.85.166.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D38F21C9E5
	for <io-uring@vger.kernel.org>; Fri,  8 Aug 2025 08:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754641051; cv=none; b=Icdg5YFnrkaK6Yv5M7si4WPpmD5A4NTg9oW11G2Xk1As1uWGyZdOaUIZFD49PU6kkUmG/roRNh7LOclDmC6o01SiDLJYr0eJvKZUtGSjuyTRGI/EHlMwM+gA/d8atfgezak+kx20q27So1e0LQbTJQ6sXvGOJpS3Pfxxu0m50Oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754641051; c=relaxed/simple;
	bh=B04/YkvVbOY4O9mytldsSTkpwmFtpXnTpoJsqa/csJc=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=ajlfrC7iMCiHCRzuBq/NMHLpor7nxSeS5jKCqHIMekraaTE+QDQQ9dQOP2LBChfgRAuZiW925ZM0rK0B34MDLeP1N6XzjY0Kd9wNASJxbCiJ4yEN0ag54eJIRQnWBxYLV6rosrbNjC8IReP+WegTEDR60G2SsXsAI2sOMyL6KkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f78.google.com with SMTP id ca18e2360f4ac-88170a3df7aso167475339f.0
        for <io-uring@vger.kernel.org>; Fri, 08 Aug 2025 01:17:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754641048; x=1755245848;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lsh6hxnOk7YLMikBhgTdzpxjqSBjt4BrFHEMC4bpYvA=;
        b=SVQWcKo17HmT+uPOjVmZtFM7Y16ICW5sby9Jzg0XAeiV/hg44jsNADsjFUBsDgWITo
         f++98O0/erz9H/Czx1P5a1ibGBt9TSz5VMtQw9ZTbuZ4J0HIkHv4Z+WmX9AAq71GCQ1l
         nprCDOfPGt7mBrehEziHWb0lpbRSj9BmB7Kgy6lYJPO85EDnvpQKDyIAGFmnb4BDikv1
         oOOtuf37z0TpmQod0jSiW6v13UnRHRbIzoF5OJvDDLoMWQW0Lw05HfNv8pGPHPL3n1zS
         pXtQE/vz5VtNnakftE3mDIUTrACjigrE8tikgqG3YI6UgoMAxdYH8v5tpuuGzuGMkWS/
         UolA==
X-Forwarded-Encrypted: i=1; AJvYcCVZPRvdcis82svnO8thGGJPp/FLITRC9+NR7sJ+c5xTnh30Dhb3R+nZg+TXaWpXEirIpXsndEAwqQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzJM8NPZX13sbaTIyPbbKlCHLdWS8KJS7fD8yeWagfBCusLKAV6
	DPP8ZJ3F8xg8ullW3m0MvXd1tsJ7l7rh092elWrAZ2S8q/62LIHrhQLXa/S4p5W7mkePZxdgFzS
	m4ytaOdi47uB63lCh1KH/4SgTe9PMAkt8qPpiPGQHP/5C3bu8D8+Nm20gZfY=
X-Google-Smtp-Source: AGHT+IHwitz8xFp3nAPezWYrSp8i+CEpgrBA13O82ZcKGqMEoijYb8OBd3WCE5ztoK+PSiThA370hvKtCV+nYBFCT9Jmmt8ykWGj
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:4a06:b0:87c:1d65:3aeb with SMTP id
 ca18e2360f4ac-883f11c040dmr386817539f.2.1754641048670; Fri, 08 Aug 2025
 01:17:28 -0700 (PDT)
Date: Fri, 08 Aug 2025 01:17:28 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6895b298.050a0220.7f033.0059.GAE@google.com>
Subject: [syzbot] [io-uring?] WARNING in __vmap_pages_range_noflush
From: syzbot <syzbot+23727438116feb13df15@syzkaller.appspotmail.com>
To: asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    6e64f4580381 Merge tag 'input-for-v6.17-rc0' of git://git...
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=166ceea2580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5549e3e577d8650d
dashboard link: https://syzkaller.appspot.com/bug?extid=23727438116feb13df15
compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10202ea2580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=140a9042580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/00c0275acc38/disk-6e64f458.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/aaa587e79838/vmlinux-6e64f458.xz
kernel image: https://storage.googleapis.com/syzbot-assets/b6b49690ca26/bzImage-6e64f458.xz

The issue was bisected to:

commit 087f997870a948820ec366701d178f402c6a23a3
Author: Pavel Begunkov <asml.silence@gmail.com>
Date:   Fri Nov 29 13:34:32 2024 +0000

    io_uring/memmap: implement mmap for regions

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=169795bc580000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=159795bc580000
console output: https://syzkaller.appspot.com/x/log.txt?x=119795bc580000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+23727438116feb13df15@syzkaller.appspotmail.com
Fixes: 087f997870a9 ("io_uring/memmap: implement mmap for regions")

------------[ cut here ]------------
WARNING: CPU: 1 PID: 5840 at mm/vmalloc.c:542 vmap_pages_pte_range mm/vmalloc.c:542 [inline]
WARNING: CPU: 1 PID: 5840 at mm/vmalloc.c:542 vmap_pages_pmd_range mm/vmalloc.c:569 [inline]
WARNING: CPU: 1 PID: 5840 at mm/vmalloc.c:542 vmap_pages_pud_range mm/vmalloc.c:587 [inline]
WARNING: CPU: 1 PID: 5840 at mm/vmalloc.c:542 vmap_pages_p4d_range mm/vmalloc.c:605 [inline]
WARNING: CPU: 1 PID: 5840 at mm/vmalloc.c:542 vmap_small_pages_range_noflush mm/vmalloc.c:627 [inline]
WARNING: CPU: 1 PID: 5840 at mm/vmalloc.c:542 __vmap_pages_range_noflush+0xd4e/0xe10 mm/vmalloc.c:656
Modules linked in:
CPU: 1 UID: 0 PID: 5840 Comm: syz-executor304 Tainted: G        W           6.16.0-syzkaller-11952-g6e64f4580381 #0 PREEMPT_{RT,(full)} 
Tainted: [W]=WARN
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/12/2025
RIP: 0010:vmap_pages_pte_range mm/vmalloc.c:542 [inline]
RIP: 0010:vmap_pages_pmd_range mm/vmalloc.c:569 [inline]
RIP: 0010:vmap_pages_pud_range mm/vmalloc.c:587 [inline]
RIP: 0010:vmap_pages_p4d_range mm/vmalloc.c:605 [inline]
RIP: 0010:vmap_small_pages_range_noflush mm/vmalloc.c:627 [inline]
RIP: 0010:__vmap_pages_range_noflush+0xd4e/0xe10 mm/vmalloc.c:656
Code: b1 ff eb 2f e8 53 5f b1 ff 45 31 e4 eb 25 e8 49 5f b1 ff 90 0f 0b 90 eb 14 e8 3e 5f b1 ff 90 0f 0b 90 eb 09 e8 33 5f b1 ff 90 <0f> 0b 90 41 bc f4 ff ff ff 44 89 e0 48 81 c4 e0 00 00 00 5b 41 5c
RSP: 0018:ffffc900049878d8 EFLAGS: 00010293
RAX: ffffffff820cfc2d RBX: ffff8880642b60c8 RCX: ffff8880331c8000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffea0003000000 R08: 0000000000000000 R09: 0000000000000000
R10: dffffc0000000000 R11: fffffbfff1e3a007 R12: ffffc9008be1a000
R13: 1ffff1100c856c19 R14: 0000000000000000 R15: dffffc0000000000
FS:  000055557fb73380(0000) GS:ffff8881269cb000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005641a237d168 CR3: 000000004069e000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 vmap_pages_range_noflush mm/vmalloc.c:681 [inline]
 vmap_pages_range mm/vmalloc.c:701 [inline]
 vmap+0x1ca/0x310 mm/vmalloc.c:3515
 io_region_init_ptr+0x24d/0x350 io_uring/memmap.c:125
 io_create_region+0x3a4/0x480 io_uring/memmap.c:228
 io_create_region_mmap_safe+0xc0/0x180 io_uring/memmap.c:245
 io_register_mem_region+0x27a/0x3c0 io_uring/register.c:616
 __io_uring_register io_uring/register.c:836 [inline]
 __do_sys_io_uring_register io_uring/register.c:929 [inline]
 __se_sys_io_uring_register+0x3b4/0x1130 io_uring/register.c:906
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f59fe9b6b39
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 c1 17 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffffb26e418 EFLAGS: 00000246 ORIG_RAX: 00000000000001ab
RAX: ffffffffffffffda RBX: 0000000000000045 RCX: 00007f59fe9b6b39
RDX: 0000200000000200 RSI: 0000000000000022 RDI: 0000000000000003
RBP: 0000000000000003 R08: 0000000010000000 R09: 0000000000000006
R10: 0000000000000001 R11: 0000000000000246 R12: 0000200000000300
R13: 0000200000000100 R14: 0000000000000001 R15: 0000000000000001
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection

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

