Return-Path: <io-uring+bounces-7946-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 98CACAB2FB9
	for <lists+io-uring@lfdr.de>; Mon, 12 May 2025 08:36:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0D7111644E8
	for <lists+io-uring@lfdr.de>; Mon, 12 May 2025 06:36:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB6A72550B0;
	Mon, 12 May 2025 06:36:31 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f78.google.com (mail-io1-f78.google.com [209.85.166.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 062F1255F5A
	for <io-uring@vger.kernel.org>; Mon, 12 May 2025 06:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747031791; cv=none; b=bvVgI6ZoxsBQ3MKCwubJVWOAYCHOw/bkr5IjEMCsLM1nTM9+SZ9Fdx0FPx6UbH7Tq2zxsTSJK8QcF5EIPcQA75LiZoGjX76Zxg6gMrrgBq/OfKfzKRPMfNo7t9LvHSU0Jw+XmDeWRy3xMC9oIqaWy4aYQD55E/XzNhxc4HdvGSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747031791; c=relaxed/simple;
	bh=iTY5OVB5ZVBPsC3hHGreLcDqY72ZXsOXDjGTDKRQE8s=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=K7YG8sl+sLo8EcImZ0C3/2d7I8yczVvYqo+16hYTJeQJJz16/QXVP3DbHTE5HU/nKXN8Bt4QvHB6L9XuhXySPCcXmIOgqB5nqcL/z79vZngZikQaXbnRAwU4I8zm/sDb3Pxn/Gy734xenD66Z5kBfbGbCvFC1U1tv3XkN4M9u84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f78.google.com with SMTP id ca18e2360f4ac-869e9667f58so183171239f.3
        for <io-uring@vger.kernel.org>; Sun, 11 May 2025 23:36:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747031789; x=1747636589;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ALCSqFqOa8mQuP4T7hyujJbBxYyxsR29K9a4OWtUl2Q=;
        b=qynRtNbkUjn2gHyVbdlcrQdlP/a+WmbrVDcbKRmk+h2Z+Dgmw3rVUq1PetTxUNHDkz
         6MXJ0jVqdHSjqabRR49eBXPQ1x80iotyewdMPv80GR7YWFlm6KC/U35qY85352XIx4oc
         4POIQZ7DNE4CeBVyD4exmzGyQ3QqkuGyUzi7XqhFrFkIEk5UJhzD+nFQI+ZxTXwGPE+Z
         ejErJ/1guQGE8l4I/wX0sCRt4uvpPeVNtM/dN1JpY7DP2flsn3AUoWzBtwPXrDprkRyc
         egjsjoF5MnKNaOkilM9MmAA50OYy5ViwWtqG1Mvp8bPf+DRNahzD8E9f5XI6605TpQ5u
         4qKQ==
X-Forwarded-Encrypted: i=1; AJvYcCVCYqhZYBWVSmcDF3HFYiurmVbQHOv1XDUp+4bz5idLSGRIMgw/ViiUa3rz3mDLHAwL5g8lVgLvNg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy1pzyuUs6OBuS3BT2vQOxPv5ocftaAbKQh64Cz+e0gvATyt9oE
	0aUKKTcYvw+IX6dol2jpB5aSZeJpb8nMh1hter799DUhAlICpW4yYnoSVtziZDkPZ06oUxiItQC
	UFlQrutKLSpX7lXN/vYOZwXzLEGSbKk0YXI86nIaVjtwqts2ToDy/Oxs=
X-Google-Smtp-Source: AGHT+IFrz6OdnWcXPFcMz403h0bQpLQC4w0dlRYsMQZIzSqGXNC/QwPEzmDggiFo5lAYIAt+VtSCMBPGOGoGg1jMPAJ8JiF46l+y
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:3423:b0:85d:a5d3:618c with SMTP id
 ca18e2360f4ac-86763653dbdmr1331586039f.11.1747031789138; Sun, 11 May 2025
 23:36:29 -0700 (PDT)
Date: Sun, 11 May 2025 23:36:29 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <682196ed.050a0220.f2294.0053.GAE@google.com>
Subject: [syzbot] [io-uring] KCSAN: data-race in copy_mm / percpu_counter_destroy_many
From: syzbot <syzbot+8be9bf36c3cf574426c8@syzkaller.appspotmail.com>
To: asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    3ce9925823c7 Merge tag 'mm-hotfixes-stable-2025-05-10-14-2..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14ff74d4580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6154604431d9aaf9
dashboard link: https://syzkaller.appspot.com/bug?extid=8be9bf36c3cf574426c8
compiler:       Debian clang version 20.1.2 (++20250402124445+58df0ef89dd6-1~exp1~20250402004600.97), Debian LLD 20.1.2

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/afdc6302fc05/disk-3ce99258.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/fc7f98d3c420/vmlinux-3ce99258.xz
kernel image: https://storage.googleapis.com/syzbot-assets/ea7ca2da2258/bzImage-3ce99258.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+8be9bf36c3cf574426c8@syzkaller.appspotmail.com

==================================================================
BUG: KCSAN: data-race in copy_mm / percpu_counter_destroy_many

write to 0xffff8881045e19d8 of 8 bytes by task 2123 on cpu 0:
 __list_del include/linux/list.h:195 [inline]
 __list_del_entry include/linux/list.h:218 [inline]
 list_del include/linux/list.h:229 [inline]
 percpu_counter_destroy_many+0xc7/0x2b0 lib/percpu_counter.c:244
 __mmdrop+0x22e/0x350 kernel/fork.c:947
 mmdrop include/linux/sched/mm.h:55 [inline]
 io_ring_ctx_free+0x31e/0x360 io_uring/io_uring.c:2740
 io_ring_exit_work+0x529/0x560 io_uring/io_uring.c:2962
 process_one_work kernel/workqueue.c:3238 [inline]
 process_scheduled_works+0x4cb/0x9d0 kernel/workqueue.c:3319
 worker_thread+0x582/0x770 kernel/workqueue.c:3400
 kthread+0x486/0x510 kernel/kthread.c:464
 ret_from_fork+0x4b/0x60 arch/x86/kernel/process.c:153
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

read to 0xffff8881045e1600 of 1344 bytes by task 5051 on cpu 1:
 dup_mm kernel/fork.c:1728 [inline]
 copy_mm+0xfb/0x1310 kernel/fork.c:1786
 copy_process+0xcf1/0x1f90 kernel/fork.c:2429
 kernel_clone+0x16c/0x5b0 kernel/fork.c:2844
 __do_sys_clone kernel/fork.c:2987 [inline]
 __se_sys_clone kernel/fork.c:2971 [inline]
 __x64_sys_clone+0xe6/0x120 kernel/fork.c:2971
 x64_sys_call+0x2c59/0x2fb0 arch/x86/include/generated/asm/syscalls_64.h:57
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xd0/0x1a0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Reported by Kernel Concurrency Sanitizer on:
CPU: 1 UID: 0 PID: 5051 Comm: syz.1.494 Not tainted 6.15.0-rc5-syzkaller-00300-g3ce9925823c7 #0 PREEMPT(voluntary) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/19/2025
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

