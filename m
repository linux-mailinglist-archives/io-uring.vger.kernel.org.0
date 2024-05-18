Return-Path: <io-uring+bounces-1933-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 207258C9077
	for <lists+io-uring@lfdr.de>; Sat, 18 May 2024 13:00:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8B7471F214A1
	for <lists+io-uring@lfdr.de>; Sat, 18 May 2024 11:00:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC1611BC59;
	Sat, 18 May 2024 11:00:46 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f79.google.com (mail-io1-f79.google.com [209.85.166.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F3F71B95B
	for <io-uring@vger.kernel.org>; Sat, 18 May 2024 11:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716030046; cv=none; b=fWkN7wgexqAP4gg1pwiyyrzNcsfTnyJirDndk31m4mReM0mIxyPPk0Zbba1BRs7UBAjLg3nHz3243YGBzaZ511dGH/+a1dfATfqDiM7gjfMYnVWsQOMO331u1nOiyKJ3hn1ehxXLjo49UObj5y5mUysY0AV4LI70hlnk8ckdZ+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716030046; c=relaxed/simple;
	bh=01QUKvrdwJTuoYK+gwIGlmtvVCFNyjDaVEgOgqt4fkE=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=XQaimpHO7DXLQY2pDHILiPsNHW/KVQyLgyu5OBElJIK29u+Ov8F9+pgLRhGvYazRiZYntQ7Q3WZ3cHzQpSPp9ngr7DRk7V/1TrqRTJyynXzRozQwHmjsBNwqd+JB15P9kWtWrlRDVwh7JSU6up9lx8T05pCeOCmxLxRqLHMIwlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f79.google.com with SMTP id ca18e2360f4ac-7e1c22e7280so994921139f.0
        for <io-uring@vger.kernel.org>; Sat, 18 May 2024 04:00:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716030044; x=1716634844;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=c7VRjhcyzcSvtEIoOWjsOxVgYE5qtyU969WvVg3AWFM=;
        b=ZiqhNii7A6rn5cWg2NO2eSeI61Hgll+moqayzg4ekl1ANdqgo6lcKvZHr0luJrc2d9
         gGsuryasbOq6cUFcpcwyqw4CH0TbKZRSv6GrgFQ6R7eDhprZI1JEjHpQ4H4cD6sUJLb8
         nCKPn/6Ox5D+S2edNOSQi+nWHkZQPE0t532d0E0EmZMHEelTrf0w7F3jO2l0tFkgLLKR
         bNBHahyvXadW8dWh5TFNKQw7BM/TD1Dx0SaojjX1iontJXEYl+Q0RPriBT3NAB+YGsdg
         6UaW0JBFzmNjtHhpXGsHY8ba27ERrfDYA+4NyGQkJzA1HmFthRJZjHMQ0N2iGEvT/Dis
         xUPQ==
X-Forwarded-Encrypted: i=1; AJvYcCUcX/0cmrGLqaP5MiefIHOvbCqwgcFLFlO2wy9R4Xf8kKqq19LyDdfU2JZIP0Beb0z6Z4MX0kjJYhWdt/hur6O7VUYvXM9jZu4=
X-Gm-Message-State: AOJu0YyOv6cW+8vEpKbTLsS6mejAd/0E2TLKQCT/ByXzuNegdep8nngV
	KWYRBRj8ULKb4EFNt6HwCsNMSz8z5avaFuTlLeEgcjeyEEP0F4KbMnOMV5SHsrVElhOzJbb1Sp7
	jIcGiYrevcbyw3kLbeQ4FG6cmVQplCsfHw5XiWEtdad+O4Q2sJsUxiHI=
X-Google-Smtp-Source: AGHT+IGAmpYUZypH6Vql6YxSOpKBdK47XJmujqCxpAUlVuUUIqnpFPydIvqbyacFQlyTF+38Yq7tAYYNIythqQ0H6GOIf8AePV/N
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6638:248e:b0:488:7f72:b3ac with SMTP id
 8926c6da1cb9f-489585764d4mr1405056173.2.1716030044397; Sat, 18 May 2024
 04:00:44 -0700 (PDT)
Date: Sat, 18 May 2024 04:00:44 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000003870370618b861cc@google.com>
Subject: [syzbot] [io-uring?] KMSAN: uninit-value in io_req_cqe_overflow (2)
From: syzbot <syzbot+97d8b31fbab9db1efe55@syzkaller.appspotmail.com>
To: asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    a5131c3fdf26 Merge tag 'x86-shstk-2024-05-13' of git://git..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=156ebcf4980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=64e100d74625a6a5
dashboard link: https://syzkaller.appspot.com/bug?extid=97d8b31fbab9db1efe55
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1124b5b8980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=155aa55c980000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/81edac548743/disk-a5131c3f.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/42f67aa888e5/vmlinux-a5131c3f.xz
kernel image: https://storage.googleapis.com/syzbot-assets/2e5cf5b3704d/bzImage-a5131c3f.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+97d8b31fbab9db1efe55@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in io_req_cqe_overflow+0x193/0x1c0 io_uring/io_uring.c:810
 io_req_cqe_overflow+0x193/0x1c0 io_uring/io_uring.c:810
 __io_submit_flush_completions+0x7eb/0x1be0 io_uring/io_uring.c:1464
 io_submit_flush_completions io_uring/io_uring.h:148 [inline]
 io_submit_state_end io_uring/io_uring.c:2234 [inline]
 io_submit_sqes+0x2b30/0x2f10 io_uring/io_uring.c:2350
 __do_sys_io_uring_enter io_uring/io_uring.c:3246 [inline]
 __se_sys_io_uring_enter+0x40f/0x3c80 io_uring/io_uring.c:3183
 __x64_sys_io_uring_enter+0x11f/0x1a0 io_uring/io_uring.c:3183
 x64_sys_call+0x2c0/0x3b50 arch/x86/include/generated/asm/syscalls_64.h:427
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcf/0x1e0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Uninit was stored to memory at:
 io_req_set_res io_uring/io_uring.h:215 [inline]
 io_recv_finish+0xf10/0x1560 io_uring/net.c:861
 io_recv+0x12ec/0x1ea0 io_uring/net.c:1175
 io_issue_sqe+0x429/0x22c0 io_uring/io_uring.c:1751
 io_queue_sqe io_uring/io_uring.c:1965 [inline]
 io_submit_sqe io_uring/io_uring.c:2220 [inline]
 io_submit_sqes+0x1266/0x2f10 io_uring/io_uring.c:2335
 __do_sys_io_uring_enter io_uring/io_uring.c:3246 [inline]
 __se_sys_io_uring_enter+0x40f/0x3c80 io_uring/io_uring.c:3183
 __x64_sys_io_uring_enter+0x11f/0x1a0 io_uring/io_uring.c:3183
 x64_sys_call+0x2c0/0x3b50 arch/x86/include/generated/asm/syscalls_64.h:427
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcf/0x1e0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Uninit was created at:
 slab_post_alloc_hook mm/slub.c:3877 [inline]
 slab_alloc_node mm/slub.c:3918 [inline]
 __do_kmalloc_node mm/slub.c:4038 [inline]
 __kmalloc+0x6e4/0x1060 mm/slub.c:4052
 kmalloc include/linux/slab.h:632 [inline]
 io_alloc_async_data+0xc0/0x220 io_uring/io_uring.c:1662
 io_msg_alloc_async io_uring/net.c:166 [inline]
 io_recvmsg_prep_setup io_uring/net.c:725 [inline]
 io_recvmsg_prep+0xbe8/0x1a20 io_uring/net.c:806
 io_init_req io_uring/io_uring.c:2135 [inline]
 io_submit_sqe io_uring/io_uring.c:2182 [inline]
 io_submit_sqes+0x1135/0x2f10 io_uring/io_uring.c:2335
 __do_sys_io_uring_enter io_uring/io_uring.c:3246 [inline]
 __se_sys_io_uring_enter+0x40f/0x3c80 io_uring/io_uring.c:3183
 __x64_sys_io_uring_enter+0x11f/0x1a0 io_uring/io_uring.c:3183
 x64_sys_call+0x2c0/0x3b50 arch/x86/include/generated/asm/syscalls_64.h:427
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcf/0x1e0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

CPU: 1 PID: 5042 Comm: syz-executor135 Not tainted 6.9.0-syzkaller-01768-ga5131c3fdf26 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/02/2024
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

