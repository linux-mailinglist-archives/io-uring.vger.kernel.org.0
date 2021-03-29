Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F1DD34D11D
	for <lists+io-uring@lfdr.de>; Mon, 29 Mar 2021 15:30:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231311AbhC2N32 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 29 Mar 2021 09:29:28 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:33322 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231419AbhC2N3I (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 29 Mar 2021 09:29:08 -0400
Received: by mail-il1-f197.google.com with SMTP id j9so2975810ilu.0
        for <io-uring@vger.kernel.org>; Mon, 29 Mar 2021 06:29:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=njm30lLdcys9Fbu5KHEo3yxnkqBEADwOZXdym5nv/uc=;
        b=DovW6HMur1PPlYI9rmIPU2s2XTJEDeQNTTyb/eHcksdBhL/vWqR6R9kHASxNBIv8JN
         eYbgujXq5lcF1szFiOS8GhoiUT7PYyT7K9J6AJpzDRnX579kPBrgIg/8uy7x06sYJIjg
         OY2AiysrCpZlPqOQGxglwX2e18FVXGmcw9bFnQgXZEIFxpCY15vk925Jzw5JMNpXqb45
         Aw1uZW35dPfhxpFW4LiPgiEb2nIfzO6DVi3g036qDwofj5OT2JIKueccAL4w8RiRoZ2o
         VrbJ2urSJZpYI4S//C+h2WaoVwq17p7yAN0XP6r47OKdYInswnxgQHA0le1ScXzVzhzK
         X0Fg==
X-Gm-Message-State: AOAM532QWJ0vWXD4JZaNv32TWNWjxh4lP/MuLJrikMvF2aPKGLWwgDrt
        qrzb+Af8V2dMGDCVIHOFWRQgy8WrI8RBK4KEH/sdg6BW2h1O
X-Google-Smtp-Source: ABdhPJwLG42hr66fm/k/yXoQdpdvfBL32PewoWr4++y/gQbAWCA1tHOBg50CsPlF5Ldfq+tTa/zu0oUNO2tDFWos2JiHEHW+ZwP2
MIME-Version: 1.0
X-Received: by 2002:a05:6638:685:: with SMTP id i5mr24439710jab.109.1617024546144;
 Mon, 29 Mar 2021 06:29:06 -0700 (PDT)
Date:   Mon, 29 Mar 2021 06:29:06 -0700
In-Reply-To: <61897224-d54b-9390-6721-57bed6a144e5@kernel.dk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000aa874e05beacddfd@google.com>
Subject: Re: [syzbot] WARNING: still has locks held in io_sq_thread
From:   syzbot <syzbot+796d767eb376810256f5@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
WARNING in kvm_wait

------------[ cut here ]------------
raw_local_irq_restore() called with IRQs enabled
WARNING: CPU: 1 PID: 5134 at kernel/locking/irqflag-debug.c:10 warn_bogus_irq_restore+0x1d/0x20 kernel/locking/irqflag-debug.c:10
Modules linked in:
CPU: 1 PID: 5134 Comm: syz-executor.2 Not tainted 5.12.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:warn_bogus_irq_restore+0x1d/0x20 kernel/locking/irqflag-debug.c:10
Code: bf ff cc cc cc cc cc cc cc cc cc cc cc 80 3d 65 c2 0f 04 00 74 01 c3 48 c7 c7 a0 7b 6b 89 c6 05 54 c2 0f 04 01 e8 65 19 bf ff <0f> 0b c3 48 39 77 10 0f 84 97 00 00 00 66 f7 47 22 f0 ff 74 4b 48
RSP: 0018:ffffc90002f5f9c0 EFLAGS: 00010286
RAX: 0000000000000000 RBX: ffff888023a7d040 RCX: 0000000000000000
RDX: ffff88801bbcc2c0 RSI: ffffffff815b7375 RDI: fffff520005ebf2a
RBP: 0000000000000200 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff815b00de R11: 0000000000000000 R12: 0000000000000003
R13: ffffed100474fa08 R14: 0000000000000001 R15: ffff8880b9f36000
FS:  000000000293e400(0000) GS:ffff8880b9f00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffd20e04f88 CR3: 00000000116b8000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 kvm_wait arch/x86/kernel/kvm.c:860 [inline]
 kvm_wait+0xc9/0xe0 arch/x86/kernel/kvm.c:837
 pv_wait arch/x86/include/asm/paravirt.h:564 [inline]
 pv_wait_head_or_lock kernel/locking/qspinlock_paravirt.h:470 [inline]
 __pv_queued_spin_lock_slowpath+0x8b8/0xb40 kernel/locking/qspinlock.c:508
 pv_queued_spin_lock_slowpath arch/x86/include/asm/paravirt.h:554 [inline]
 queued_spin_lock_slowpath arch/x86/include/asm/qspinlock.h:51 [inline]
 queued_spin_lock include/asm-generic/qspinlock.h:85 [inline]
 do_raw_spin_lock+0x200/0x2b0 kernel/locking/spinlock_debug.c:113
 spin_lock include/linux/spinlock.h:354 [inline]
 ext4_lock_group fs/ext4/ext4.h:3383 [inline]
 __ext4_new_inode+0x384f/0x5570 fs/ext4/ialloc.c:1188
 ext4_symlink+0x489/0xd50 fs/ext4/namei.c:3347
 vfs_symlink fs/namei.c:4176 [inline]
 vfs_symlink+0x10f/0x270 fs/namei.c:4161
 do_symlinkat+0x27a/0x300 fs/namei.c:4206
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x465d67
Code: 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 b8 58 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc15a180e8 EFLAGS: 00000206 ORIG_RAX: 0000000000000058
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 0000000000465d67
RDX: 00007ffc15a181d3 RSI: 00000000004bfab2 RDI: 00007ffc15a181c0
RBP: 0000000000000000 R08: 0000000000000000 R09: 00007ffc15a17f80
R10: 00007ffc15a17e37 R11: 0000000000000206 R12: 0000000000000001
R13: 0000000000000000 R14: 0000000000000001 R15: 00007ffc15a181c0


Tested on:

commit:         d80a59fb io_uring: drop sqd lock before handling signals f..
git tree:       git://git.kernel.dk/linux-block io_uring-5.12
console output: https://syzkaller.appspot.com/x/log.txt?x=14a9b21ad00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=473f8fc78a7207b4
dashboard link: https://syzkaller.appspot.com/bug?extid=796d767eb376810256f5
compiler:       

