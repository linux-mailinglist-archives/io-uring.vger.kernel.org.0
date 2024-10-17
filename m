Return-Path: <io-uring+bounces-3768-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 598019A1D01
	for <lists+io-uring@lfdr.de>; Thu, 17 Oct 2024 10:20:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8B3661C20D95
	for <lists+io-uring@lfdr.de>; Thu, 17 Oct 2024 08:20:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 067661CDFB8;
	Thu, 17 Oct 2024 08:20:35 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC4C93398B
	for <io-uring@vger.kernel.org>; Thu, 17 Oct 2024 08:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729153234; cv=none; b=p6Byxm2jD1bHh8v65kpdFuN4NHt0YVlLCTDkYQwidsEm3ZczfatTJsa4hYBFYKq/weZhfReORg4uQWqqLftD8yI7DXWGKTnEsgw479nOyIJaohxoquoc2iEnnAqg0fvQywdP512OlyazY6V1IX8mMeBHQ4AcjLUdUbR9OdTX7pU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729153234; c=relaxed/simple;
	bh=5JlZvbED4lSTM7df1+7Za8XN7cQ1XKt/zNPvoxdFwzo=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=KDzdz6/n7BzkaV6FGRjwqBSsxaytlCtCyVO46SGACHOkAs1+ntZb3ML9EpAvbfT91+8q9uU4orIgRqsMFoshBi00Gre0ByFFUcPORJKhMKa5vrYslT0yR8kznBqe/4od99AiRht9aR/YMipPf5tnOg89xpq8UBFE2+fiOoFG/hI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3a3ae3c2cacso6938855ab.2
        for <io-uring@vger.kernel.org>; Thu, 17 Oct 2024 01:20:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729153231; x=1729758031;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oYTBiBShMWCNdAW6gCnUYtnHJmnerNIryV/kjjDV/uM=;
        b=KzELVBR4wyOfNU2UL3hrJKeKSZjzCXZh7QftS7QPqTobRR6w5+X1cRW2WWRvwHt0Aj
         nDjbR5moUUFDzjWbedHlEmihUw1RGGVxTjxxSjINpUsYX65j1KcWkNluORrpRQrXrUEl
         nenppouvi7LYR3tF77GEDhxy/ntbZZS4FCm7kn23eIHyeuJh5WUE49+iBQPfvLZSx+Qz
         IzC/SKNwoUo6OYmW3O0vGx7AjIKXXY0H8RGBD0nkgFuluux4u1LQx/7BBSUMRkqoVeFp
         YbW8wF5814YlGKRl9NAJSoD1oZsUeZEmp1p5J/IYuCWQmZ5l26xJgmZQIV3z10VLIupV
         7HUw==
X-Forwarded-Encrypted: i=1; AJvYcCX4XbC+IVZOLrp8/EBt1P7EoknAM870ue28gpPL3Lfv01p2lEl6t1fc2xhhtBlSdI+wtBu+S6obew==@vger.kernel.org
X-Gm-Message-State: AOJu0YxVDV1kHrnaVh/Y7FSF6nGf3Jn/LtJCXyc8Jmpl7vMJ9cQIT3oX
	m5+SAMk5Mw0nHvjKOYgQZ0KWZBB93CflYxqR4LeoYw0N1E5/rsUf65bI/kWhNOnNzpwpKgwOEYj
	nHHYu3C48SKS0IwHkjoAKB1xFnJgimDHbpwYELiSlVv0L6ke2Y68Fz5Q=
X-Google-Smtp-Source: AGHT+IHyceELi0Dd4/3TJ97vd9SoTcwVXT4CrTeRM/ME3E1hzqaCB/8PkZGrnkR/aWUEVi5MmnP+0DYnEQ3d3pNQ71s5+dFmDgEO
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1caf:b0:3a3:778e:45cd with SMTP id
 e9e14a558f8ab-3a3b5fbc20cmr203953495ab.21.1729153230987; Thu, 17 Oct 2024
 01:20:30 -0700 (PDT)
Date: Thu, 17 Oct 2024 01:20:30 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6710c8ce.050a0220.d5849.0026.GAE@google.com>
Subject: [syzbot] [io-uring?] KCSAN: data-race in io_req_defer_failed /
 io_wq_free_work (3)
From: syzbot <syzbot+2b8e48083b04a2e58fab@syzkaller.appspotmail.com>
To: asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    c964ced77262 Merge tag 'for-linus' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14d3cf27980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=fd83253b74c9c570
dashboard link: https://syzkaller.appspot.com/bug?extid=2b8e48083b04a2e58fab
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/dc3d0edf69f7/disk-c964ced7.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/bb0052a85cf6/vmlinux-c964ced7.xz
kernel image: https://storage.googleapis.com/syzbot-assets/ec8def944d77/bzImage-c964ced7.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+2b8e48083b04a2e58fab@syzkaller.appspotmail.com

==================================================================
BUG: KCSAN: data-race in io_req_defer_failed / io_wq_free_work

write to 0xffff888117079648 of 8 bytes by task 3752 on cpu 1:
 io_req_defer_failed+0x73/0x440 io_uring/io_uring.c:935
 io_req_task_cancel+0x21/0x30 io_uring/io_uring.c:1361
 io_handle_tw_list+0x1b9/0x200 io_uring/io_uring.c:1063
 tctx_task_work_run+0x6c/0x1b0 io_uring/io_uring.c:1135
 tctx_task_work+0x40/0x80 io_uring/io_uring.c:1153
 task_work_run+0x13a/0x1a0 kernel/task_work.c:228
 get_signal+0xee9/0x1070 kernel/signal.c:2690
 arch_do_signal_or_restart+0x95/0x4b0 arch/x86/kernel/signal.c:337
 exit_to_user_mode_loop kernel/entry/common.c:111 [inline]
 exit_to_user_mode_prepare include/linux/entry-common.h:328 [inline]
 __syscall_exit_to_user_mode_work kernel/entry/common.c:207 [inline]
 syscall_exit_to_user_mode+0x59/0x130 kernel/entry/common.c:218
 do_syscall_64+0xd6/0x1c0 arch/x86/entry/common.c:89
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

read to 0xffff888117079648 of 8 bytes by task 3753 on cpu 0:
 req_ref_put_and_test io_uring/refs.h:22 [inline]
 io_wq_free_work+0x21/0x160 io_uring/io_uring.c:1779
 io_worker_handle_work+0x4cb/0x9d0 io_uring/io-wq.c:604
 io_wq_worker+0x286/0x820 io_uring/io-wq.c:655
 ret_from_fork+0x4b/0x60 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

value changed: 0x00000000802c2058 -> 0x00000000806c2118

Reported by Kernel Concurrency Sanitizer on:
CPU: 0 UID: 0 PID: 3753 Comm: iou-wrk-3752 Not tainted 6.12.0-rc3-syzkaller-00087-gc964ced77262 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
==================================================================


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

