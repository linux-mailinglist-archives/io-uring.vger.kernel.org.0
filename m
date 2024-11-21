Return-Path: <io-uring+bounces-4918-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 71DF69D4E4A
	for <lists+io-uring@lfdr.de>; Thu, 21 Nov 2024 15:08:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1E7401F21290
	for <lists+io-uring@lfdr.de>; Thu, 21 Nov 2024 14:08:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78A091D0B8B;
	Thu, 21 Nov 2024 14:08:28 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D292E1CD3F
	for <io-uring@vger.kernel.org>; Thu, 21 Nov 2024 14:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732198108; cv=none; b=WuWqXA6Mp0hIryJJX0+oftsh9DVQFZePG+aD94/x6FbQzygEctE04dDmv/9LQw+juIOkzVPvi6f7Cmoro+KWQra0EEzgwq1OEIwjixhol3K3c9W+oqoKdzuKmP4C9hUgZMQw4sHxSzCiXn3pA0c4k1Hb53vUgBZxZpz9qACQToA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732198108; c=relaxed/simple;
	bh=m5jq80BC7DofVIBQ6U6Pjti1+INudzR2S00C1oURiMY=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=JvZcAiQD7WjNl0EpgJKlzBdjkmBY8O6NQvLLQv+0NHjypaqqIGudsgZqCPKAo8AksxX8gQOX9pMCyIPebl0hq4M7CzqWOCZSvQcJ8nDgCAbpVgPvp/Z8N3scHwq/tq3E5vqhLan5crvtlnPW7XXdEKzIUH2A62qcWSDdKzogs2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3a7776959fdso9379405ab.1
        for <io-uring@vger.kernel.org>; Thu, 21 Nov 2024 06:08:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732198106; x=1732802906;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kwNx5NRVwm5OzIE0GXZM0zaelGjldEUociQ77SD6NL0=;
        b=XYL8K/ZJ5V3BPE9dL/D0p9L3Smz6PTQbIbmT9TFwP7fKR1O3bFE2Svt0Z+OHDmvVWb
         4f344VThIe+26zn26xeL6XthiD4MnkMeN+U3lzhF2i515lJ16/HTJUJUgvDFIe/rNY+F
         0CLVwrGmldNAqG6zFDucRPl2+YZdkhfntdWfRLvVRGqxhJ1B159RkEd4iiKjQFkI5PVL
         UR901NtOoM5WUtm8J0/t8ORQ5g15NigEs6A9batCKZvOU8syJUcnnmYIPG1kZQWswHS9
         TzF6xgahS4t2PKbMCHYZNZtqee4hMYzqZ2CtuDKG+KolkLgtzy67ovRkR4fzFfhmNjZE
         aYoQ==
X-Forwarded-Encrypted: i=1; AJvYcCVmOt8Y5oTAmdFC7ZVqY0QDz+U5CFTDbm7Cm8cSsu/w73ULleHZ8PzlIzeTA161/QI1ckv4wSzq5w==@vger.kernel.org
X-Gm-Message-State: AOJu0YxfhNjpz1o8SQ/tEJJUCiAy4buYmzcSlqflkVXAahlupIvkRFa4
	2Jpc3xOtu1NXHHmw7Bme1GNS430bV7jSf/uQ8xQsDEXffADunbAinpGzMaMAl2VGCxrQY/gC9Yt
	Ct3RE37kLYN913TxW+3vvwUQEBvqtIyX7HVdFLm3jXkUzIikdsINJVH8=
X-Google-Smtp-Source: AGHT+IHhru2X680bepaUwT3rHuUhfCIw7DiKsJn1IMPr+OHLTjoA9F6bGjqbOoygqrRYm+3AcCOGTewOYu21taD7T1qxMIqjzbiA
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a88:b0:3a7:2b14:add8 with SMTP id
 e9e14a558f8ab-3a786564165mr62730805ab.18.1732198105814; Thu, 21 Nov 2024
 06:08:25 -0800 (PST)
Date: Thu, 21 Nov 2024 06:08:25 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <673f3ed9.050a0220.3c9d61.0173.GAE@google.com>
Subject: [syzbot] [io-uring?] KMSAN: uninit-value in io_nop
From: syzbot <syzbot+9a8500a45c2cabdf9577@syzkaller.appspotmail.com>
To: asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    43fb83c17ba2 Merge tag 'soc-arm-6.13' of git://git.kernel...
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=134feb78580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9f17942989df952c
dashboard link: https://syzkaller.appspot.com/bug?extid=9a8500a45c2cabdf9577
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16f767f7980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12f50ec0580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/e1e82262b7ac/disk-43fb83c1.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/7ca6e1c46dc5/vmlinux-43fb83c1.xz
kernel image: https://storage.googleapis.com/syzbot-assets/63aaea837532/bzImage-43fb83c1.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+9a8500a45c2cabdf9577@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in io_nop+0x549/0x8a0 io_uring/nop.c:55
 io_nop+0x549/0x8a0 io_uring/nop.c:55
 io_issue_sqe+0x420/0x2130 io_uring/io_uring.c:1712
 io_queue_sqe io_uring/io_uring.c:1922 [inline]
 io_submit_sqe io_uring/io_uring.c:2177 [inline]
 io_submit_sqes+0x11bc/0x2f80 io_uring/io_uring.c:2294
 __do_sys_io_uring_enter io_uring/io_uring.c:3365 [inline]
 __se_sys_io_uring_enter+0x423/0x4aa0 io_uring/io_uring.c:3300
 __x64_sys_io_uring_enter+0x11f/0x1a0 io_uring/io_uring.c:3300
 x64_sys_call+0xce5/0x3c30 arch/x86/include/generated/asm/syscalls_64.h:427
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcd/0x1e0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Uninit was created at:
 __alloc_pages_noprof+0x9a7/0xe00 mm/page_alloc.c:4774
 alloc_pages_mpol_noprof+0x299/0x990 mm/mempolicy.c:2265
 alloc_pages_noprof+0x1bf/0x1e0 mm/mempolicy.c:2345
 alloc_slab_page mm/slub.c:2412 [inline]
 allocate_slab+0x320/0x12e0 mm/slub.c:2578
 new_slab mm/slub.c:2631 [inline]
 ___slab_alloc+0x12ef/0x35e0 mm/slub.c:3818
 __kmem_cache_alloc_bulk mm/slub.c:4895 [inline]
 kmem_cache_alloc_bulk_noprof+0x486/0x1330 mm/slub.c:4967
 __io_alloc_req_refill+0x84/0x5b0 io_uring/io_uring.c:958
 io_alloc_req io_uring/io_uring.h:411 [inline]
 io_submit_sqes+0x9a2/0x2f80 io_uring/io_uring.c:2283
 __do_sys_io_uring_enter io_uring/io_uring.c:3365 [inline]
 __se_sys_io_uring_enter+0x423/0x4aa0 io_uring/io_uring.c:3300
 __x64_sys_io_uring_enter+0x11f/0x1a0 io_uring/io_uring.c:3300
 x64_sys_call+0xce5/0x3c30 arch/x86/include/generated/asm/syscalls_64.h:427
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcd/0x1e0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

CPU: 0 UID: 0 PID: 5798 Comm: syz-executor426 Not tainted 6.12.0-syzkaller-03657-g43fb83c17ba2 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/30/2024
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

