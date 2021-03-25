Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12A253498D6
	for <lists+io-uring@lfdr.de>; Thu, 25 Mar 2021 18:59:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230046AbhCYR6c (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Mar 2021 13:58:32 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:33496 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230008AbhCYR6L (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Mar 2021 13:58:11 -0400
Received: by mail-io1-f71.google.com with SMTP id o1so4341464iou.0
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 10:58:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=Ud2GtM19aZ+Jjw6jcKZyQALMFPzFZgNlVDCtTbZgYjE=;
        b=Z9mdcacwxbRn+HvAYUILzoVnMWYY/PFIemHdeHTuFRevT6HMUV9UwSGzG4YezsZFVQ
         0yaFD+npUXxg67JDJpiLlsVfkZfy/PeDfVAZJ4IR40ZQDDBrx0TAK4uOvBcWXDcnN75y
         LqKyTxipWg13LpGzxJZel2xRW0qPty7dG2wWdTAilO9euXFrbNma1/ZFvoZKdGKPyIQa
         IwWOoZg6im0R+/vCbG+hy9bS+Wejx1Y6NeyUa/T0zQ026EGHQcTTPYo1RO4QoJOObSvn
         i4gygLxWcN0v9YTEhklVQ4mvx7zYBoG9yI9Ru27Ov8ejv3pHEz5f6Nw6J8BPAf3jYmeD
         qFog==
X-Gm-Message-State: AOAM533ud6IvRzqFJVYX1l9uw3CqMfxkYUat5MLMffpkKLHO0RAiB786
        rOfvPuxhWdEKpLw2wNHEKCKYzQIi2PMnCA3gqVVw+mHNVaHF
X-Google-Smtp-Source: ABdhPJzEVPGTgsSDXo19Ht7uHAF2vrtCuvmQi0PbOBV88ntiDT2wm7WZgCmnYdq+f7wJPaZkF+WccfI2vwG/9PBadwjAdP6jt0gi
MIME-Version: 1.0
X-Received: by 2002:a02:6654:: with SMTP id l20mr8597420jaf.55.1616695091264;
 Thu, 25 Mar 2021 10:58:11 -0700 (PDT)
Date:   Thu, 25 Mar 2021 10:58:11 -0700
In-Reply-To: <4befa1ec-11d8-fca8-692a-492b72b219f4@kernel.dk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a0025805be6028a0@google.com>
Subject: Re: [syzbot] WARNING in io_wq_put
From:   syzbot <syzbot+77a738a6bc947bf639ca@syzkaller.appspotmail.com>
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
WARNING: CPU: 1 PID: 191 at kernel/locking/irqflag-debug.c:10 warn_bogus_irq_restore+0x1f/0x30 kernel/locking/irqflag-debug.c:10
Modules linked in:
CPU: 1 PID: 191 Comm: kworker/u4:4 Not tainted 5.12.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue:  0x0 (events_unbound)
RIP: 0010:warn_bogus_irq_restore+0x1f/0x30 kernel/locking/irqflag-debug.c:10
Code: cc cc cc cc cc cc cc cc cc cc cc 80 3d c7 af b1 03 00 74 01 c3 c6 05 bd af b1 03 01 48 c7 c7 c0 5f ae 89 31 c0 e8 d1 dd f6 f7 <0f> 0b c3 cc cc cc cc cc cc cc cc cc cc cc cc cc cc 41 56 53 48 83
RSP: 0018:ffffc90000dc0a08 EFLAGS: 00010246
RAX: 6a712abdc5855100 RBX: ffffffff8f982d60 RCX: ffff8880118bb880
RDX: 0000000000000103 RSI: 0000000000000103 RDI: 0000000000000000
RBP: 1ffff920001b8142 R08: ffffffff81609502 R09: ffffed10173e5fe8
R10: ffffed10173e5fe8 R11: 0000000000000000 R12: 0000000000000003
R13: ffff88823ffe6880 R14: 0000000000000246 R15: dffffc0000000000
FS:  0000000000000000(0000) GS:ffff8880b9f00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f44d117d718 CR3: 000000001340a000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <IRQ>
 kvm_wait+0x10e/0x160 arch/x86/kernel/kvm.c:860
 pv_wait arch/x86/include/asm/paravirt.h:564 [inline]
 pv_wait_head_or_lock kernel/locking/qspinlock_paravirt.h:470 [inline]
 __pv_queued_spin_lock_slowpath+0x6b5/0xb90 kernel/locking/qspinlock.c:508
 pv_queued_spin_lock_slowpath arch/x86/include/asm/paravirt.h:554 [inline]
 queued_spin_lock_slowpath arch/x86/include/asm/qspinlock.h:51 [inline]
 queued_spin_lock include/asm-generic/qspinlock.h:85 [inline]
 do_raw_spin_lock+0x430/0x810 kernel/locking/spinlock_debug.c:113
 spin_lock include/linux/spinlock.h:354 [inline]
 mac80211_hwsim_tx_frame_no_nl+0x60e/0x1860 drivers/net/wireless/mac80211_hwsim.c:1514
 mac80211_hwsim_tx_frame+0x143/0x180 drivers/net/wireless/mac80211_hwsim.c:1775
 mac80211_hwsim_beacon_tx+0x4b9/0x870 drivers/net/wireless/mac80211_hwsim.c:1829
 __iterate_interfaces+0x23e/0x4b0 net/mac80211/util.c:793
 ieee80211_iterate_active_interfaces_atomic+0x9b/0x120 net/mac80211/util.c:829
 mac80211_hwsim_beacon+0xa4/0x180 drivers/net/wireless/mac80211_hwsim.c:1852
 __run_hrtimer kernel/time/hrtimer.c:1519 [inline]
 __hrtimer_run_queues+0x4c9/0xa00 kernel/time/hrtimer.c:1583
 hrtimer_run_softirq+0x176/0x1e0 kernel/time/hrtimer.c:1600
 __do_softirq+0x318/0x714 kernel/softirq.c:345
 invoke_softirq kernel/softirq.c:221 [inline]
 __irq_exit_rcu+0x1d8/0x200 kernel/softirq.c:422
 irq_exit_rcu+0x5/0x20 kernel/softirq.c:434
 sysvec_apic_timer_interrupt+0x91/0xb0 arch/x86/kernel/apic/apic.c:1100
 </IRQ>
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:632
RIP: 0010:__raw_spin_unlock_irq include/linux/spinlock_api_smp.h:169 [inline]
RIP: 0010:_raw_spin_unlock_irq+0x25/0x40 kernel/locking/spinlock.c:199
Code: b4 fd ff 66 90 53 48 89 fb 48 83 c7 18 48 8b 74 24 08 e8 0e 56 09 f8 48 89 df e8 56 2b 0b f8 e8 41 9f 2b f8 fb bf 01 00 00 00 <e8> c6 3b ff f7 65 8b 05 c7 9f ae 76 85 c0 74 02 5b c3 e8 7b fb ac
RSP: 0018:ffffc9000143fca0 EFLAGS: 00000286
RAX: 6a712abdc5855100 RBX: ffff8880b9f34c40 RCX: ffffffff8f59cb03
RDX: 0000000040000000 RSI: 0000000000000002 RDI: 0000000000000001
RBP: ffffc9000143fd00 R08: ffffffff817eef20 R09: ffffed10173e6989
R10: ffffed10173e6989 R11: 0000000000000000 R12: ffff8880b9f34c40
R13: ffff8880118bb880 R14: dffffc0000000000 R15: 0000000000000000
 finish_task_switch+0x145/0x620 kernel/sched/core.c:4193
 context_switch kernel/sched/core.c:4327 [inline]
 __schedule+0x9a1/0xe70 kernel/sched/core.c:5075
 schedule+0x14b/0x200 kernel/sched/core.c:5154
 worker_thread+0xfe6/0x1300 kernel/workqueue.c:2442
 kthread+0x39a/0x3c0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294


Tested on:

commit:         f5d2d23b io-wq: fix race around pending work on teardown
git tree:       git://git.kernel.dk/linux-block io_uring-5.12
console output: https://syzkaller.appspot.com/x/log.txt?x=12cad621d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9fdcf055a7409ee0
dashboard link: https://syzkaller.appspot.com/bug?extid=77a738a6bc947bf639ca
compiler:       Debian clang version 11.0.1-2

