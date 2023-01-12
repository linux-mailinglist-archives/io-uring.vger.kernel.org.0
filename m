Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E96C666F8D
	for <lists+io-uring@lfdr.de>; Thu, 12 Jan 2023 11:26:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229851AbjALK0o (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 Jan 2023 05:26:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235699AbjALKZv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 Jan 2023 05:25:51 -0500
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD43B392C3
        for <io-uring@vger.kernel.org>; Thu, 12 Jan 2023 02:20:41 -0800 (PST)
Received: by mail-io1-f72.google.com with SMTP id e15-20020a056602158f00b006e01d8fa493so10926891iow.3
        for <io-uring@vger.kernel.org>; Thu, 12 Jan 2023 02:20:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Uh0tJmz4qRfDpKq6RIuvzDNwWyz6o8vq7R6bAsps51U=;
        b=xaESYcJnOZbtzc2oChl6yiTtgRB+KEvDZ66s2z1tR4T3RUQ/MWsBfnKHIEbuwDcPbq
         bAtx71IT6uBh5cAdh6b3c9HawGkNS4xY/aHw3FR9m6NZrnmzTMD31wCiweKkwR3RhNXf
         PX71IfSXb833FiWoASuhM3CPo3nJq6kokLkdihYa0IsYhLJh9P7dZB/RrtzY5EhjggaJ
         ujNshOFR8BoyrL6LdEU255HiMuwDeT3+mQKPnv4NjbpH+Vhi7bY1jP67XBbCvAjYRpVX
         knLohDx6mHYrw1xWqcgphiMMQ16HENSZzfffFVM1Y7MJuE+YBTFHdI9c5PphzU8vDduU
         AVmA==
X-Gm-Message-State: AFqh2kqJqTZdGv3os4olBnpBSB6J9dfwM3BQ9r7GWD2PH51nyWrsSwz1
        7DektjyLLu+uHZEybYBEK8okiM8oQpm31rd2J9O86bXxYgBy
X-Google-Smtp-Source: AMrXdXvTUQ5qCcIanITNVlK7Hqa2zVNf0yt9/qZzgSm0B/hNhub9Q/3DHcncYApgNh702VSEwFbHBuhwTAX/QPTT7IyKCOc8Kkoe
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1d1b:b0:30d:97cf:858 with SMTP id
 i27-20020a056e021d1b00b0030d97cf0858mr2378148ila.233.1673518841056; Thu, 12
 Jan 2023 02:20:41 -0800 (PST)
Date:   Thu, 12 Jan 2023 02:20:41 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000000bd60905f20e785a@google.com>
Subject: [syzbot] WARNING in io_cqring_event_overflow
From:   syzbot <syzbot+6805087452d72929404e@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    358a161a6a9e Merge branch 'for-next/fixes' into for-kernelci
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=14247bbe480000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2573056c6a11f00d
dashboard link: https://syzkaller.appspot.com/bug?extid=6805087452d72929404e
compiler:       Debian clang version 13.0.1-++20220126092033+75e33f71c2da-1~exp1~20220126212112.63, GNU ld (GNU Binutils for Debian) 2.35.2
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1045e181480000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13769f1c480000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/99d14e0f4c19/disk-358a161a.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/23275b612976/vmlinux-358a161a.xz
kernel image: https://storage.googleapis.com/syzbot-assets/ed79195fac61/Image-358a161a.gz.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+6805087452d72929404e@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 0 PID: 28 at io_uring/io_uring.c:734 io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
Modules linked in:
CPU: 0 PID: 28 Comm: kworker/u4:1 Not tainted 6.2.0-rc3-syzkaller-16369-g358a161a6a9e #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
Workqueue: events_unbound io_ring_exit_work
pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
lr : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
sp : ffff80000f7dbad0
x29: ffff80000f7dbad0 x28: ffff0000c3b3e578 x27: ffff80000d49b000
x26: 0000000000000000 x25: 0000000000000000 x24: 0000000000000000
x23: 0000000000000000 x22: 0000000000000000 x21: 0000000000000000
x20: 0000000000000000 x19: ffff0000c4d2c000 x18: 00000000000000c0
x17: ffff80000df48158 x16: ffff80000dd86118 x15: ffff0000c0cf8000
x14: 00000000000000b8 x13: 00000000ffffffff x12: ffff0000c0cf8000
x11: ff80800009594dec x10: 0000000000000000 x9 : ffff800009594dec
x8 : ffff0000c0cf8000 x7 : ffff80000c109860 x6 : 0000000000000000
x5 : 0000000000000000 x4 : 0000000000000000 x3 : 0000000000000000
x2 : 0000000000000000 x1 : 0000000000000000 x0 : 0000000000000000
Call trace:
 io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
 io_req_cqe_overflow+0x5c/0x70 io_uring/io_uring.c:773
 io_fill_cqe_req io_uring/io_uring.h:168 [inline]
 io_do_iopoll+0x474/0x62c io_uring/rw.c:1065
 io_iopoll_try_reap_events+0x6c/0x108 io_uring/io_uring.c:1513
 io_uring_try_cancel_requests+0x13c/0x258 io_uring/io_uring.c:3056
 io_ring_exit_work+0xec/0x390 io_uring/io_uring.c:2869
 process_one_work+0x2d8/0x504 kernel/workqueue.c:2289
 worker_thread+0x340/0x610 kernel/workqueue.c:2436
 kthread+0x12c/0x158 kernel/kthread.c:376
 ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:863
irq event stamp: 620806
hardirqs last  enabled at (620805): [<ffff80000c124078>] __raw_spin_unlock_irq include/linux/spinlock_api_smp.h:159 [inline]
hardirqs last  enabled at (620805): [<ffff80000c124078>] _raw_spin_unlock_irq+0x3c/0x70 kernel/locking/spinlock.c:202
hardirqs last disabled at (620806): [<ffff80000c110db0>] el1_dbg+0x24/0x80 arch/arm64/kernel/entry-common.c:405
softirqs last  enabled at (620784): [<ffff80000b2f555c>] neigh_managed_work+0xf8/0x118 net/core/neighbour.c:1626
softirqs last disabled at (620780): [<ffff80000b2f5498>] neigh_managed_work+0x34/0x118 net/core/neighbour.c:1621
---[ end trace 0000000000000000 ]---
------------[ cut here ]------------
WARNING: CPU: 1 PID: 28 at io_uring/io_uring.c:734 io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
Modules linked in:
CPU: 1 PID: 28 Comm: kworker/u4:1 Tainted: G        W          6.2.0-rc3-syzkaller-16369-g358a161a6a9e #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
Workqueue: events_unbound io_ring_exit_work

pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
lr : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
sp : ffff80000f7dbad0
x29: ffff80000f7dbad0
 x28: ffff0000c4f2f678
 x27: ffff80000d49b000

x26: 0000000000000000
 x25: 0000000000000000
 x24: 0000000000000000

x23: 0000000000000000
 x22: 0000000000000000
 x21: 0000000000000000

x20: 0000000000000000
 x19: ffff0000c4d2c000
 x18: 00000000000003de

x17: ffff80000c15d8bc
 x16: ffff80000dd86118
 x15: ffff0000c0cf8000

x14: 00000000000000b8
 x13: 00000000ffffffff
 x12: ffff0000c0cf8000

x11: ff80800009594dec
 x10: 0000000000000000
 x9 : ffff800009594dec

x8 : ffff0000c0cf8000
 x7 : ffff80000c109860
 x6 : 0000000000000000

x5 : 0000000000000000
 x4 : 0000000000000000
 x3 : 0000000000000000

x2 : 0000000000000000
 x1 : 0000000000000000
 x0 : 0000000000000000

Call trace:
 io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
 io_req_cqe_overflow+0x5c/0x70 io_uring/io_uring.c:773
 io_fill_cqe_req io_uring/io_uring.h:168 [inline]
 io_do_iopoll+0x474/0x62c io_uring/rw.c:1065
 io_iopoll_try_reap_events+0x6c/0x108 io_uring/io_uring.c:1513
 io_uring_try_cancel_requests+0x13c/0x258 io_uring/io_uring.c:3056
 io_ring_exit_work+0xec/0x390 io_uring/io_uring.c:2869
 process_one_work+0x2d8/0x504 kernel/workqueue.c:2289
 worker_thread+0x340/0x610 kernel/workqueue.c:2436
 kthread+0x12c/0x158 kernel/kthread.c:376
 ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:863
irq event stamp: 622216
hardirqs last  enabled at (622215): [<ffff80000c124078>] __raw_spin_unlock_irq include/linux/spinlock_api_smp.h:159 [inline]
hardirqs last  enabled at (622215): [<ffff80000c124078>] _raw_spin_unlock_irq+0x3c/0x70 kernel/locking/spinlock.c:202
hardirqs last disabled at (622216): [<ffff80000c110db0>] el1_dbg+0x24/0x80 arch/arm64/kernel/entry-common.c:405
softirqs last  enabled at (621028): [<ffff80000b811778>] sock_orphan include/net/sock.h:2098 [inline]
softirqs last  enabled at (621028): [<ffff80000b811778>] unix_release_sock+0x15c/0x544 net/unix/af_unix.c:604
softirqs last disabled at (621026): [<ffff80000b81175c>] sock_orphan include/net/sock.h:2094 [inline]
softirqs last disabled at (621026): [<ffff80000b81175c>] unix_release_sock+0x140/0x544 net/unix/af_unix.c:604
---[ end trace 0000000000000000 ]---
------------[ cut here ]------------
WARNING: CPU: 1 PID: 28 at io_uring/io_uring.c:734 io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
Modules linked in:
CPU: 1 PID: 28 Comm: kworker/u4:1 Tainted: G        W          6.2.0-rc3-syzkaller-16369-g358a161a6a9e #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
Workqueue: events_unbound io_ring_exit_work
pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
lr : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
sp : ffff80000f7dbad0
x29: ffff80000f7dbad0 x28: ffff0000c4f2fb78 x27: ffff80000d49b000
x26: 0000000000000000 x25: 0000000000000000 x24: 0000000000000000
x23: 0000000000000000 x22: 0000000000000000 x21: 0000000000000000
x20: 0000000000000000 x19: ffff0000c4d2f000 x18: 000000000000031e
x17: ffff80000c15d8bc x16: ffff80000dd86118 x15: ffff0000c0cf8000
x14: 00000000000000b8 x13: 00000000ffffffff x12: ffff0000c0cf8000
x11: ff80800009594dec x10: 0000000000000000 x9 : ffff800009594dec
x8 : ffff0000c0cf8000 x7 : ffff80000c109860 x6 : 0000000000000000
x5 : 0000000000000000 x4 : 0000000000000000 x3 : 0000000000000000
x2 : 0000000000000000 x1 : 0000000000000000 x0 : 0000000000000000
Call trace:
 io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
 io_req_cqe_overflow+0x5c/0x70 io_uring/io_uring.c:773
 io_fill_cqe_req io_uring/io_uring.h:168 [inline]
 io_do_iopoll+0x474/0x62c io_uring/rw.c:1065
 io_iopoll_try_reap_events+0x6c/0x108 io_uring/io_uring.c:1513
 io_uring_try_cancel_requests+0x13c/0x258 io_uring/io_uring.c:3056
 io_ring_exit_work+0xec/0x390 io_uring/io_uring.c:2869
 process_one_work+0x2d8/0x504 kernel/workqueue.c:2289
 worker_thread+0x340/0x610 kernel/workqueue.c:2436
 kthread+0x12c/0x158 kernel/kthread.c:376
 ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:863
irq event stamp: 623616
hardirqs last  enabled at (623615): [<ffff80000c124078>] __raw_spin_unlock_irq include/linux/spinlock_api_smp.h:159 [inline]
hardirqs last  enabled at (623615): [<ffff80000c124078>] _raw_spin_unlock_irq+0x3c/0x70 kernel/locking/spinlock.c:202
hardirqs last disabled at (623616): [<ffff80000c110db0>] el1_dbg+0x24/0x80 arch/arm64/kernel/entry-common.c:405
softirqs last  enabled at (622446): [<ffff80000b811778>] sock_orphan include/net/sock.h:2098 [inline]
softirqs last  enabled at (622446): [<ffff80000b811778>] unix_release_sock+0x15c/0x544 net/unix/af_unix.c:604
softirqs last disabled at (622444): [<ffff80000b81175c>] sock_orphan include/net/sock.h:2094 [inline]
softirqs last disabled at (622444): [<ffff80000b81175c>] unix_release_sock+0x140/0x544 net/unix/af_unix.c:604
---[ end trace 0000000000000000 ]---
------------[ cut here ]------------
WARNING: CPU: 1 PID: 28 at io_uring/io_uring.c:734 io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
Modules linked in:
CPU: 1 PID: 28 Comm: kworker/u4:1 Tainted: G        W          6.2.0-rc3-syzkaller-16369-g358a161a6a9e #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
Workqueue: events_unbound io_ring_exit_work

pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
lr : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
sp : ffff80000f7dbad0
x29: ffff80000f7dbad0
 x28: ffff0000c4404378
 x27: ffff80000d49b000

x26: 0000000000000000
 x25: 0000000000000000
 x24: 0000000000000000

x23: 0000000000000000
 x22: 0000000000000000
 x21: 0000000000000000

x20: 0000000000000000
 x19: ffff0000c93ee000
 x18: 00000000000002ce

x17: ffff80000c15d8bc
 x16: ffff80000dd86118
 x15: ffff0000c0cf8000

x14: 00000000000000b8
 x13: 00000000ffffffff
 x12: ffff0000c0cf8000

x11: ff80800009594dec
 x10: 0000000000000000
 x9 : ffff800009594dec

x8 : ffff0000c0cf8000
 x7 : ffff80000c109860
 x6 : 0000000000000000

x5 : 0000000000000000
 x4 : 0000000000000000
 x3 : 0000000000000000

x2 : 0000000000000000
 x1 : 0000000000000000
 x0 : 0000000000000000

Call trace:
 io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
 io_req_cqe_overflow+0x5c/0x70 io_uring/io_uring.c:773
 io_fill_cqe_req io_uring/io_uring.h:168 [inline]
 io_do_iopoll+0x474/0x62c io_uring/rw.c:1065
 io_iopoll_try_reap_events+0x6c/0x108 io_uring/io_uring.c:1513
 io_uring_try_cancel_requests+0x13c/0x258 io_uring/io_uring.c:3056
 io_ring_exit_work+0xec/0x390 io_uring/io_uring.c:2869
 process_one_work+0x2d8/0x504 kernel/workqueue.c:2289
 worker_thread+0x340/0x610 kernel/workqueue.c:2436
 kthread+0x12c/0x158 kernel/kthread.c:376
 ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:863
irq event stamp: 624992
hardirqs last  enabled at (624991): [<ffff80000c124078>] __raw_spin_unlock_irq include/linux/spinlock_api_smp.h:159 [inline]
hardirqs last  enabled at (624991): [<ffff80000c124078>] _raw_spin_unlock_irq+0x3c/0x70 kernel/locking/spinlock.c:202
hardirqs last disabled at (624992): [<ffff80000c110db0>] el1_dbg+0x24/0x80 arch/arm64/kernel/entry-common.c:405
softirqs last  enabled at (623820): [<ffff80000b811778>] sock_orphan include/net/sock.h:2098 [inline]
softirqs last  enabled at (623820): [<ffff80000b811778>] unix_release_sock+0x15c/0x544 net/unix/af_unix.c:604
softirqs last disabled at (623818): [<ffff80000b81175c>] sock_orphan include/net/sock.h:2094 [inline]
softirqs last disabled at (623818): [<ffff80000b81175c>] unix_release_sock+0x140/0x544 net/unix/af_unix.c:604
---[ end trace 0000000000000000 ]---
------------[ cut here ]------------
WARNING: CPU: 0 PID: 28 at io_uring/io_uring.c:734 io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
Modules linked in:
CPU: 0 PID: 28 Comm: kworker/u4:1 Tainted: G        W          6.2.0-rc3-syzkaller-16369-g358a161a6a9e #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
Workqueue: events_unbound io_ring_exit_work

pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
lr : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
sp : ffff80000f7dbad0
x29: ffff80000f7dbad0
 x28: ffff0000c995f778
 x27: ffff80000d49b000
x26: 0000000000000000 x25: 0000000000000000 x24: 0000000000000000
x23: 0000000000000000 x22: 0000000000000000 x21: 0000000000000000
x20: 0000000000000000 x19: ffff0000c93ef000 x18: 00000000000003d1
x17: ffff80000c15d8bc x16: ffff80000dd86118 x15: ffff0000c0cf8000
x14: 00000000000000b8 x13: 00000000ffffffff x12: ffff0000c0cf8000
x11: ff80800009594dec x10: 0000000000000000 x9 : ffff800009594dec
x8 : ffff0000c0cf8000 x7 : ffff80000c109860 x6 : 0000000000000000
x5 : 0000000000000000 x4 : 0000000000000000 x3 : 0000000000000000
x2 : 0000000000000000 x1 : 0000000000000000 x0 : 0000000000000000
Call trace:
 io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
 io_req_cqe_overflow+0x5c/0x70 io_uring/io_uring.c:773
 io_fill_cqe_req io_uring/io_uring.h:168 [inline]
 io_do_iopoll+0x474/0x62c io_uring/rw.c:1065
 io_iopoll_try_reap_events+0x6c/0x108 io_uring/io_uring.c:1513
 io_uring_try_cancel_requests+0x13c/0x258 io_uring/io_uring.c:3056
 io_ring_exit_work+0xec/0x390 io_uring/io_uring.c:2869
 process_one_work+0x2d8/0x504 kernel/workqueue.c:2289
 worker_thread+0x340/0x610 kernel/workqueue.c:2436
 kthread+0x12c/0x158 kernel/kthread.c:376
 ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:863
irq event stamp: 626290
hardirqs last  enabled at (626289): [<ffff80000c124078>] __raw_spin_unlock_irq include/linux/spinlock_api_smp.h:159 [inline]
hardirqs last  enabled at (626289): [<ffff80000c124078>] _raw_spin_unlock_irq+0x3c/0x70 kernel/locking/spinlock.c:202
hardirqs last disabled at (626290): [<ffff80000c110db0>] el1_dbg+0x24/0x80 arch/arm64/kernel/entry-common.c:405
softirqs last  enabled at (625116): [<ffff80000b811778>] sock_orphan include/net/sock.h:2098 [inline]
softirqs last  enabled at (625116): [<ffff80000b811778>] unix_release_sock+0x15c/0x544 net/unix/af_unix.c:604
softirqs last disabled at (625114): [<ffff80000b81175c>] sock_orphan include/net/sock.h:2094 [inline]
softirqs last disabled at (625114): [<ffff80000b81175c>] unix_release_sock+0x140/0x544 net/unix/af_unix.c:604
---[ end trace 0000000000000000 ]---
------------[ cut here ]------------
WARNING: CPU: 0 PID: 28 at io_uring/io_uring.c:734 io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
Modules linked in:
CPU: 0 PID: 28 Comm: kworker/u4:1 Tainted: G        W          6.2.0-rc3-syzkaller-16369-g358a161a6a9e #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
Workqueue: events_unbound io_ring_exit_work

pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
lr : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
sp : ffff80000f7dbad0
x29: ffff80000f7dbad0
 x28: ffff0000c995f878
 x27: ffff80000d49b000
x26: 0000000000000000 x25: 0000000000000000 x24: 0000000000000000
x23: 0000000000000000 x22: 0000000000000000 x21: 0000000000000000
x20: 0000000000000000 x19: ffff0000c93ef000 x18: 000000000000011c
x17: ffff80000c15d8bc x16: ffff80000dd86118 x15: ffff0000c0cf8000
x14: 00000000000000b8 x13: 00000000ffffffff x12: ffff0000c0cf8000
x11: ff80800009594dec x10: 0000000000000000 x9 : ffff800009594dec
x8 : ffff0000c0cf8000 x7 : ffff80000c109860 x6 : 0000000000000000
x5 : 0000000000000000 x4 : 0000000000000000 x3 : 0000000000000000
x2 : 0000000000000000 x1 : 0000000000000000 x0 : 0000000000000000
Call trace:
 io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
 io_req_cqe_overflow+0x5c/0x70 io_uring/io_uring.c:773
 io_fill_cqe_req io_uring/io_uring.h:168 [inline]
 io_do_iopoll+0x474/0x62c io_uring/rw.c:1065
 io_iopoll_try_reap_events+0x6c/0x108 io_uring/io_uring.c:1513
 io_uring_try_cancel_requests+0x13c/0x258 io_uring/io_uring.c:3056
 io_ring_exit_work+0xec/0x390 io_uring/io_uring.c:2869
 process_one_work+0x2d8/0x504 kernel/workqueue.c:2289
 worker_thread+0x340/0x610 kernel/workqueue.c:2436
 kthread+0x12c/0x158 kernel/kthread.c:376
 ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:863
irq event stamp: 627616
hardirqs last  enabled at (627615): [<ffff80000c124078>] __raw_spin_unlock_irq include/linux/spinlock_api_smp.h:159 [inline]
hardirqs last  enabled at (627615): [<ffff80000c124078>] _raw_spin_unlock_irq+0x3c/0x70 kernel/locking/spinlock.c:202
hardirqs last disabled at (627616): [<ffff80000c110db0>] el1_dbg+0x24/0x80 arch/arm64/kernel/entry-common.c:405
softirqs last  enabled at (626440): [<ffff80000b811778>] sock_orphan include/net/sock.h:2098 [inline]
softirqs last  enabled at (626440): [<ffff80000b811778>] unix_release_sock+0x15c/0x544 net/unix/af_unix.c:604
softirqs last disabled at (626438): [<ffff80000b81175c>] sock_orphan include/net/sock.h:2094 [inline]
softirqs last disabled at (626438): [<ffff80000b81175c>] unix_release_sock+0x140/0x544 net/unix/af_unix.c:604
---[ end trace 0000000000000000 ]---
------------[ cut here ]------------
WARNING: CPU: 0 PID: 28 at io_uring/io_uring.c:734 io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
Modules linked in:
CPU: 0 PID: 28 Comm: kworker/u4:1 Tainted: G        W          6.2.0-rc3-syzkaller-16369-g358a161a6a9e #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
Workqueue: events_unbound io_ring_exit_work
pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
lr : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
sp : ffff80000f7dbad0
x29: ffff80000f7dbad0 x28: ffff0000c4f2f278 x27: ffff80000d49b000
x26: 0000000000000000 x25: 0000000000000000 x24: 0000000000000000
x23: 0000000000000000 x22: 0000000000000000 x21: 0000000000000000
x20: 0000000000000000 x19: ffff0000c4d2f000 x18: 00000000000000c7
x17: ffff80000c15d8bc x16: ffff80000dd86118 x15: ffff0000c0cf8000
x14: 00000000000000b8 x13: 00000000ffffffff x12: ffff0000c0cf8000
x11: ff80800009594dec x10: 0000000000000000 x9 : ffff800009594dec
x8 : ffff0000c0cf8000 x7 : ffff80000c109860 x6 : 0000000000000000
x5 : 0000000000000000 x4 : 0000000000000000 x3 : 0000000000000000
x2 : 0000000000000000 x1 : 0000000000000000 x0 : 0000000000000000
Call trace:
 io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
 io_req_cqe_overflow+0x5c/0x70 io_uring/io_uring.c:773
 io_fill_cqe_req io_uring/io_uring.h:168 [inline]
 io_do_iopoll+0x474/0x62c io_uring/rw.c:1065
 io_iopoll_try_reap_events+0x6c/0x108 io_uring/io_uring.c:1513
 io_uring_try_cancel_requests+0x13c/0x258 io_uring/io_uring.c:3056
 io_ring_exit_work+0xec/0x390 io_uring/io_uring.c:2869
 process_one_work+0x2d8/0x504 kernel/workqueue.c:2289
 worker_thread+0x340/0x610 kernel/workqueue.c:2436
 kthread+0x12c/0x158 kernel/kthread.c:376
 ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:863
irq event stamp: 629014
hardirqs last  enabled at (629013): [<ffff80000c124078>] __raw_spin_unlock_irq include/linux/spinlock_api_smp.h:159 [inline]
hardirqs last  enabled at (629013): [<ffff80000c124078>] _raw_spin_unlock_irq+0x3c/0x70 kernel/locking/spinlock.c:202
hardirqs last disabled at (629014): [<ffff80000c110db0>] el1_dbg+0x24/0x80 arch/arm64/kernel/entry-common.c:405
softirqs last  enabled at (627834): [<ffff80000b811778>] sock_orphan include/net/sock.h:2098 [inline]
softirqs last  enabled at (627834): [<ffff80000b811778>] unix_release_sock+0x15c/0x544 net/unix/af_unix.c:604
softirqs last disabled at (627832): [<ffff80000b81175c>] sock_orphan include/net/sock.h:2094 [inline]
softirqs last disabled at (627832): [<ffff80000b81175c>] unix_release_sock+0x140/0x544 net/unix/af_unix.c:604
---[ end trace 0000000000000000 ]---
------------[ cut here ]------------
WARNING: CPU: 0 PID: 28 at io_uring/io_uring.c:734 io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
Modules linked in:
CPU: 0 PID: 28 Comm: kworker/u4:1 Tainted: G        W          6.2.0-rc3-syzkaller-16369-g358a161a6a9e #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
Workqueue: events_unbound io_ring_exit_work
pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
lr : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
sp : ffff80000f7dbad0
x29: ffff80000f7dbad0 x28: ffff0000c995fb78 x27: ffff80000d49b000
x26: 0000000000000000 x25: 0000000000000000 x24: 0000000000000000
x23: 0000000000000000 x22: 0000000000000000 x21: 0000000000000000
x20: 0000000000000000 x19: ffff0000c93ee000 x18: 00000000000003c2
x17: ffff80000c15d8bc x16: ffff80000dd86118 x15: ffff0000c0cf8000
x14: 00000000000000b8 x13: 00000000ffffffff x12: ffff0000c0cf8000
x11: ff80800009594dec x10: 0000000000000000 x9 : ffff800009594dec
x8 : ffff0000c0cf8000 x7 : ffff80000c109860 x6 : 0000000000000000
x5 : 0000000000000000 x4 : 0000000000000000 x3 : 0000000000000000
x2 : 0000000000000000 x1 : 0000000000000000 x0 : 0000000000000000
Call trace:
 io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
 io_req_cqe_overflow+0x5c/0x70 io_uring/io_uring.c:773
 io_fill_cqe_req io_uring/io_uring.h:168 [inline]
 io_do_iopoll+0x474/0x62c io_uring/rw.c:1065
 io_iopoll_try_reap_events+0x6c/0x108 io_uring/io_uring.c:1513
 io_uring_try_cancel_requests+0x13c/0x258 io_uring/io_uring.c:3056
 io_ring_exit_work+0xec/0x390 io_uring/io_uring.c:2869
 process_one_work+0x2d8/0x504 kernel/workqueue.c:2289
 worker_thread+0x340/0x610 kernel/workqueue.c:2436
 kthread+0x12c/0x158 kernel/kthread.c:376
 ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:863
irq event stamp: 630328
hardirqs last  enabled at (630327): [<ffff80000c124078>] __raw_spin_unlock_irq include/linux/spinlock_api_smp.h:159 [inline]
hardirqs last  enabled at (630327): [<ffff80000c124078>] _raw_spin_unlock_irq+0x3c/0x70 kernel/locking/spinlock.c:202
hardirqs last disabled at (630328): [<ffff80000c110db0>] el1_dbg+0x24/0x80 arch/arm64/kernel/entry-common.c:405
softirqs last  enabled at (629918): [<ffff8000080102e4>] _stext+0x2e4/0x37c
softirqs last disabled at (629893): [<ffff800008017c90>] ____do_softirq+0x14/0x20 arch/arm64/kernel/irq.c:80
---[ end trace 0000000000000000 ]---
------------[ cut here ]------------
WARNING: CPU: 0 PID: 28 at io_uring/io_uring.c:734 io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
Modules linked in:

CPU: 0 PID: 28 Comm: kworker/u4:1 Tainted: G        W          6.2.0-rc3-syzkaller-16369-g358a161a6a9e #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
Workqueue: events_unbound io_ring_exit_work

pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
lr : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
sp : ffff80000f7dbad0
x29: ffff80000f7dbad0
 x28: ffff0000c0d47d78
 x27: ffff80000d49b000

x26: 0000000000000000
 x25: 0000000000000000
 x24: 0000000000000000

x23: 0000000000000000
 x22: 0000000000000000
 x21: 0000000000000000

x20: 0000000000000000
 x19: ffff0000c93ee000
 x18: 00000000000003fd

x17: ffff80000c15d8bc
 x16: ffff80000dd86118
 x15: ffff0000c0cf8000

x14: 00000000000000b8
 x13: 00000000ffffffff
 x12: ffff0000c0cf8000

x11: ff80800009594dec
 x10: 0000000000000000
 x9 : ffff800009594dec

x8 : ffff0000c0cf8000
 x7 : ffff80000c109860
 x6 : 0000000000000000

x5 : 0000000000000000
 x4 : 0000000000000000
 x3 : 0000000000000000

x2 : 0000000000000000
 x1 : 0000000000000000
 x0 : 0000000000000000

Call trace:
 io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
 io_req_cqe_overflow+0x5c/0x70 io_uring/io_uring.c:773
 io_fill_cqe_req io_uring/io_uring.h:168 [inline]
 io_do_iopoll+0x474/0x62c io_uring/rw.c:1065
 io_iopoll_try_reap_events+0x6c/0x108 io_uring/io_uring.c:1513
 io_uring_try_cancel_requests+0x13c/0x258 io_uring/io_uring.c:3056
 io_ring_exit_work+0xec/0x390 io_uring/io_uring.c:2869
 process_one_work+0x2d8/0x504 kernel/workqueue.c:2289
 worker_thread+0x340/0x610 kernel/workqueue.c:2436
 kthread+0x12c/0x158 kernel/kthread.c:376
 ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:863
irq event stamp: 631624
hardirqs last  enabled at (631623): [<ffff80000c124078>] __raw_spin_unlock_irq include/linux/spinlock_api_smp.h:159 [inline]
hardirqs last  enabled at (631623): [<ffff80000c124078>] _raw_spin_unlock_irq+0x3c/0x70 kernel/locking/spinlock.c:202
hardirqs last disabled at (631624): [<ffff80000c110db0>] el1_dbg+0x24/0x80 arch/arm64/kernel/entry-common.c:405
softirqs last  enabled at (630450): [<ffff80000b811778>] sock_orphan include/net/sock.h:2098 [inline]
softirqs last  enabled at (630450): [<ffff80000b811778>] unix_release_sock+0x15c/0x544 net/unix/af_unix.c:604
softirqs last disabled at (630448): [<ffff80000b81175c>] sock_orphan include/net/sock.h:2094 [inline]
softirqs last disabled at (630448): [<ffff80000b81175c>] unix_release_sock+0x140/0x544 net/unix/af_unix.c:604
---[ end trace 0000000000000000 ]---
------------[ cut here ]------------
WARNING: CPU: 0 PID: 28 at io_uring/io_uring.c:734 io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
Modules linked in:

CPU: 0 PID: 28 Comm: kworker/u4:1 Tainted: G        W          6.2.0-rc3-syzkaller-16369-g358a161a6a9e #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
Workqueue: events_unbound io_ring_exit_work

pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
lr : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
sp : ffff80000f7dbad0
x29: ffff80000f7dbad0
 x28: ffff0000c4f2f978
 x27: ffff80000d49b000

x26: 0000000000000000
 x25: 0000000000000000
 x24: 0000000000000000

x23: 0000000000000000
 x22: 0000000000000000
 x21: 0000000000000000

x20: 0000000000000000
 x19: ffff0000c93ee000
 x18: 0000000000000106

x17: ffff80000c15d8bc
 x16: ffff80000dd86118
 x15: ffff0000c0cf8000

x14: 00000000000000b8
 x13: 00000000ffffffff
 x12: ffff0000c0cf8000

x11: ff80800009594dec
 x10: 0000000000000000
 x9 : ffff800009594dec

x8 : ffff0000c0cf8000
 x7 : ffff80000c109860
 x6 : 0000000000000000

x5 : 0000000000000000
 x4 : 0000000000000000
 x3 : 0000000000000000

x2 : 0000000000000000
 x1 : 0000000000000000
 x0 : 0000000000000000

Call trace:
 io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
 io_req_cqe_overflow+0x5c/0x70 io_uring/io_uring.c:773
 io_fill_cqe_req io_uring/io_uring.h:168 [inline]
 io_do_iopoll+0x474/0x62c io_uring/rw.c:1065
 io_iopoll_try_reap_events+0x6c/0x108 io_uring/io_uring.c:1513
 io_uring_try_cancel_requests+0x13c/0x258 io_uring/io_uring.c:3056
 io_ring_exit_work+0xec/0x390 io_uring/io_uring.c:2869
 process_one_work+0x2d8/0x504 kernel/workqueue.c:2289
 worker_thread+0x340/0x610 kernel/workqueue.c:2436
 kthread+0x12c/0x158 kernel/kthread.c:376
 ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:863
irq event stamp: 633024
hardirqs last  enabled at (633023): [<ffff80000c124078>] __raw_spin_unlock_irq include/linux/spinlock_api_smp.h:159 [inline]
hardirqs last  enabled at (633023): [<ffff80000c124078>] _raw_spin_unlock_irq+0x3c/0x70 kernel/locking/spinlock.c:202
hardirqs last disabled at (633024): [<ffff80000c110db0>] el1_dbg+0x24/0x80 arch/arm64/kernel/entry-common.c:405
softirqs last  enabled at (631846): [<ffff80000b811778>] sock_orphan include/net/sock.h:2098 [inline]
softirqs last  enabled at (631846): [<ffff80000b811778>] unix_release_sock+0x15c/0x544 net/unix/af_unix.c:604
softirqs last disabled at (631844): [<ffff80000b81175c>] sock_orphan include/net/sock.h:2094 [inline]
softirqs last disabled at (631844): [<ffff80000b81175c>] unix_release_sock+0x140/0x544 net/unix/af_unix.c:604
---[ end trace 0000000000000000 ]---
------------[ cut here ]------------
WARNING: CPU: 0 PID: 28 at io_uring/io_uring.c:734 io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
Modules linked in:

CPU: 0 PID: 28 Comm: kworker/u4:1 Tainted: G        W          6.2.0-rc3-syzkaller-16369-g358a161a6a9e #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
Workqueue: events_unbound io_ring_exit_work

pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
lr : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
sp : ffff80000f7dbad0
x29: ffff80000f7dbad0
 x28: ffff0000c4404978
 x27: ffff80000d49b000

x26: 0000000000000000
 x25: 0000000000000000
 x24: 0000000000000000

x23: 0000000000000000
 x22: 0000000000000000
 x21: 0000000000000000

x20: 0000000000000000
 x19: ffff0000c93ec000
 x18: 0000000000000061

x17: ffff80000c15d8bc
 x16: ffff80000dd86118
 x15: ffff0000c0cf8000

x14: 00000000000000b8
 x13: 00000000ffffffff
 x12: ffff0000c0cf8000

x11: ff80800009594dec
 x10: 0000000000000000
 x9 : ffff800009594dec

x8 : ffff0000c0cf8000
 x7 : ffff80000c109860
 x6 : 0000000000000000

x5 : 0000000000000000
 x4 : 0000000000000000
 x3 : 0000000000000000

x2 : 0000000000000000
 x1 : 0000000000000000
 x0 : 0000000000000000

Call trace:
 io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
 io_req_cqe_overflow+0x5c/0x70 io_uring/io_uring.c:773
 io_fill_cqe_req io_uring/io_uring.h:168 [inline]
 io_do_iopoll+0x474/0x62c io_uring/rw.c:1065
 io_iopoll_try_reap_events+0x6c/0x108 io_uring/io_uring.c:1513
 io_uring_try_cancel_requests+0x13c/0x258 io_uring/io_uring.c:3056
 io_ring_exit_work+0xec/0x390 io_uring/io_uring.c:2869
 process_one_work+0x2d8/0x504 kernel/workqueue.c:2289
 worker_thread+0x340/0x610 kernel/workqueue.c:2436
 kthread+0x12c/0x158 kernel/kthread.c:376
 ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:863
irq event stamp: 634358
hardirqs last  enabled at (634357): [<ffff80000c124078>] __raw_spin_unlock_irq include/linux/spinlock_api_smp.h:159 [inline]
hardirqs last  enabled at (634357): [<ffff80000c124078>] _raw_spin_unlock_irq+0x3c/0x70 kernel/locking/spinlock.c:202
hardirqs last disabled at (634358): [<ffff80000c110db0>] el1_dbg+0x24/0x80 arch/arm64/kernel/entry-common.c:405
softirqs last  enabled at (633180): [<ffff80000b811778>] sock_orphan include/net/sock.h:2098 [inline]
softirqs last  enabled at (633180): [<ffff80000b811778>] unix_release_sock+0x15c/0x544 net/unix/af_unix.c:604
softirqs last disabled at (633178): [<ffff80000b81175c>] sock_orphan include/net/sock.h:2094 [inline]
softirqs last disabled at (633178): [<ffff80000b81175c>] unix_release_sock+0x140/0x544 net/unix/af_unix.c:604
---[ end trace 0000000000000000 ]---
------------[ cut here ]------------
WARNING: CPU: 0 PID: 28 at io_uring/io_uring.c:734 io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
Modules linked in:

CPU: 0 PID: 28 Comm: kworker/u4:1 Tainted: G        W          6.2.0-rc3-syzkaller-16369-g358a161a6a9e #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
Workqueue: events_unbound io_ring_exit_work

pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
lr : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
sp : ffff80000f7dbad0
x29: ffff80000f7dbad0
 x28: ffff0000c9688978
 x27: ffff80000d49b000

x26: 0000000000000000
 x25: 0000000000000000
 x24: 0000000000000000

x23: 0000000000000000
 x22: 0000000000000000
 x21: 0000000000000000

x20: 0000000000000000
 x19: ffff0000c93eb000
 x18: 0000000000000398

x17: ffff80000c15d8bc
 x16: ffff80000dd86118
 x15: ffff0000c0cf8000

x14: 00000000000000b8
 x13: 00000000ffffffff
 x12: ffff0000c0cf8000

x11: ff80800009594dec
 x10: 0000000000000000
 x9 : ffff800009594dec

x8 : ffff0000c0cf8000
 x7 : ffff80000c109860
 x6 : 0000000000000000

x5 : 0000000000000000
 x4 : 0000000000000000
 x3 : 0000000000000000

x2 : 0000000000000000
 x1 : 0000000000000000
 x0 : 0000000000000000

Call trace:
 io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
 io_req_cqe_overflow+0x5c/0x70 io_uring/io_uring.c:773
 io_fill_cqe_req io_uring/io_uring.h:168 [inline]
 io_do_iopoll+0x474/0x62c io_uring/rw.c:1065
 io_iopoll_try_reap_events+0x6c/0x108 io_uring/io_uring.c:1513
 io_uring_try_cancel_requests+0x13c/0x258 io_uring/io_uring.c:3056
 io_ring_exit_work+0xec/0x390 io_uring/io_uring.c:2869
 process_one_work+0x2d8/0x504 kernel/workqueue.c:2289
 worker_thread+0x340/0x610 kernel/workqueue.c:2436
 kthread+0x12c/0x158 kernel/kthread.c:376
 ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:863
irq event stamp: 635652
hardirqs last  enabled at (635651): [<ffff80000c124078>] __raw_spin_unlock_irq include/linux/spinlock_api_smp.h:159 [inline]
hardirqs last  enabled at (635651): [<ffff80000c124078>] _raw_spin_unlock_irq+0x3c/0x70 kernel/locking/spinlock.c:202
hardirqs last disabled at (635652): [<ffff80000c110db0>] el1_dbg+0x24/0x80 arch/arm64/kernel/entry-common.c:405
softirqs last  enabled at (634476): [<ffff80000b811778>] sock_orphan include/net/sock.h:2098 [inline]
softirqs last  enabled at (634476): [<ffff80000b811778>] unix_release_sock+0x15c/0x544 net/unix/af_unix.c:604
softirqs last disabled at (634474): [<ffff80000b81175c>] sock_orphan include/net/sock.h:2094 [inline]
softirqs last disabled at (634474): [<ffff80000b81175c>] unix_release_sock+0x140/0x544 net/unix/af_unix.c:604
---[ end trace 0000000000000000 ]---
------------[ cut here ]------------
WARNING: CPU: 0 PID: 28 at io_uring/io_uring.c:734 io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
Modules linked in:
CPU: 0 PID: 28 Comm: kworker/u4:1 Tainted: G        W          6.2.0-rc3-syzkaller-16369-g358a161a6a9e #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
Workqueue: events_unbound io_ring_exit_work
pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
lr : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
sp : ffff80000f7dbad0
x29: ffff80000f7dbad0 x28: ffff0000c995f678 x27: ffff80000d49b000
x26: 0000000000000000 x25: 0000000000000000 x24: 0000000000000000
x23: 0000000000000000 x22: 0000000000000000 x21: 0000000000000000
x20: 0000000000000000 x19: ffff0000c4d28000 x18: 000000000000012e
x17: ffff80000c15d8bc x16: ffff80000dd86118 x15: ffff0000c0cf8000
x14: 00000000000000b8 x13: 00000000ffffffff x12: ffff0000c0cf8000
x11: ff80800009594dec x10: 0000000000000000 x9 : ffff800009594dec
x8 : ffff0000c0cf8000 x7 : ffff80000c109860 x6 : 0000000000000000
x5 : 0000000000000000 x4 : 0000000000000000 x3 : 0000000000000000
x2 : 0000000000000000 x1 : 0000000000000000 x0 : 0000000000000000
Call trace:
 io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
 io_req_cqe_overflow+0x5c/0x70 io_uring/io_uring.c:773
 io_fill_cqe_req io_uring/io_uring.h:168 [inline]
 io_do_iopoll+0x474/0x62c io_uring/rw.c:1065
 io_iopoll_try_reap_events+0x6c/0x108 io_uring/io_uring.c:1513
 io_uring_try_cancel_requests+0x13c/0x258 io_uring/io_uring.c:3056
 io_ring_exit_work+0xec/0x390 io_uring/io_uring.c:2869
 process_one_work+0x2d8/0x504 kernel/workqueue.c:2289
 worker_thread+0x340/0x610 kernel/workqueue.c:2436
 kthread+0x12c/0x158 kernel/kthread.c:376
 ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:863
irq event stamp: 636950
hardirqs last  enabled at (636949): [<ffff80000c124078>] __raw_spin_unlock_irq include/linux/spinlock_api_smp.h:159 [inline]
hardirqs last  enabled at (636949): [<ffff80000c124078>] _raw_spin_unlock_irq+0x3c/0x70 kernel/locking/spinlock.c:202
hardirqs last disabled at (636950): [<ffff80000c110db0>] el1_dbg+0x24/0x80 arch/arm64/kernel/entry-common.c:405
softirqs last  enabled at (635774): [<ffff80000b811778>] sock_orphan include/net/sock.h:2098 [inline]
softirqs last  enabled at (635774): [<ffff80000b811778>] unix_release_sock+0x15c/0x544 net/unix/af_unix.c:604
softirqs last disabled at (635772): [<ffff80000b81175c>] sock_orphan include/net/sock.h:2094 [inline]
softirqs last disabled at (635772): [<ffff80000b81175c>] unix_release_sock+0x140/0x544 net/unix/af_unix.c:604
---[ end trace 0000000000000000 ]---
------------[ cut here ]------------
WARNING: CPU: 0 PID: 28 at io_uring/io_uring.c:734 io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
Modules linked in:
CPU: 0 PID: 28 Comm: kworker/u4:1 Tainted: G        W          6.2.0-rc3-syzkaller-16369-g358a161a6a9e #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
Workqueue: events_unbound io_ring_exit_work

pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
lr : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
sp : ffff80000f7dbad0
x29: ffff80000f7dbad0
 x28: ffff0000c4f2f178
 x27: ffff80000d49b000

x26: 0000000000000000
 x25: 0000000000000000
 x24: 0000000000000000

x23: 0000000000000000
 x22: 0000000000000000
 x21: 0000000000000000

x20: 0000000000000000
 x19: ffff0000c4d28000
 x18: ffff80001912b5f0

x17: ffff80000c15d8bc
 x16: ffff80000dd86118
 x15: ffff0000c0cf8000

x14: 00000000000000b8
 x13: 00000000ffffffff
 x12: ffff0000c0cf8000

x11: ff80800009594dec
 x10: 0000000000000000
 x9 : ffff800009594dec

x8 : ffff0000c0cf8000
 x7 : ffff80000c109860
 x6 : 0000000000000000

x5 : 0000000000000000
 x4 : 0000000000000000
 x3 : 0000000000000000

x2 : 0000000000000000
 x1 : 0000000000000000
 x0 : 0000000000000000

Call trace:
 io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
 io_req_cqe_overflow+0x5c/0x70 io_uring/io_uring.c:773
 io_fill_cqe_req io_uring/io_uring.h:168 [inline]
 io_do_iopoll+0x474/0x62c io_uring/rw.c:1065
 io_iopoll_try_reap_events+0x6c/0x108 io_uring/io_uring.c:1513
 io_uring_try_cancel_requests+0x13c/0x258 io_uring/io_uring.c:3056
 io_ring_exit_work+0xec/0x390 io_uring/io_uring.c:2869
 process_one_work+0x2d8/0x504 kernel/workqueue.c:2289
 worker_thread+0x340/0x610 kernel/workqueue.c:2436
 kthread+0x12c/0x158 kernel/kthread.c:376
 ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:863
irq event stamp: 638316
hardirqs last  enabled at (638315): [<ffff80000c124078>] __raw_spin_unlock_irq include/linux/spinlock_api_smp.h:159 [inline]
hardirqs last  enabled at (638315): [<ffff80000c124078>] _raw_spin_unlock_irq+0x3c/0x70 kernel/locking/spinlock.c:202
hardirqs last disabled at (638316): [<ffff80000c110db0>] el1_dbg+0x24/0x80 arch/arm64/kernel/entry-common.c:405
softirqs last  enabled at (637136): [<ffff80000b811778>] sock_orphan include/net/sock.h:2098 [inline]
softirqs last  enabled at (637136): [<ffff80000b811778>] unix_release_sock+0x15c/0x544 net/unix/af_unix.c:604
softirqs last disabled at (637134): [<ffff80000b81175c>] sock_orphan include/net/sock.h:2094 [inline]
softirqs last disabled at (637134): [<ffff80000b81175c>] unix_release_sock+0x140/0x544 net/unix/af_unix.c:604
---[ end trace 0000000000000000 ]---
------------[ cut here ]------------
WARNING: CPU: 1 PID: 28 at io_uring/io_uring.c:734 io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
Modules linked in:
CPU: 1 PID: 28 Comm: kworker/u4:1 Tainted: G        W          6.2.0-rc3-syzkaller-16369-g358a161a6a9e #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
Workqueue: events_unbound io_ring_exit_work
pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
lr : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
sp : ffff80000f7dbad0
x29: ffff80000f7dbad0 x28: ffff0000c995fc78 x27: ffff80000d49b000
x26: 0000000000000000 x25: 0000000000000000 x24: 0000000000000000
x23: 0000000000000000 x22: 0000000000000000 x21: 0000000000000000
x20: 0000000000000000 x19: ffff0000c93ef000 x18: 000000000000017e
x17: 0000000000000000 x16: ffff80000dd86118 x15: ffff0000c0cf8000
x14: 00000000000000b8 x13: 00000000ffffffff x12: ffff0000c0cf8000
x11: ff80800009594dec x10: 0000000000000000 x9 : ffff800009594dec
x8 : ffff0000c0cf8000 x7 : ffff80000c109860 x6 : 0000000000000000
x5 : 0000000000000000 x4 : 0000000000000000 x3 : 0000000000000000
x2 : 0000000000000000 x1 : 0000000000000000 x0 : 0000000000000000
Call trace:
 io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
 io_req_cqe_overflow+0x5c/0x70 io_uring/io_uring.c:773
 io_fill_cqe_req io_uring/io_uring.h:168 [inline]
 io_do_iopoll+0x474/0x62c io_uring/rw.c:1065
 io_iopoll_try_reap_events+0x6c/0x108 io_uring/io_uring.c:1513
 io_uring_try_cancel_requests+0x13c/0x258 io_uring/io_uring.c:3056
 io_ring_exit_work+0xec/0x390 io_uring/io_uring.c:2869
 process_one_work+0x2d8/0x504 kernel/workqueue.c:2289
 worker_thread+0x340/0x610 kernel/workqueue.c:2436
 kthread+0x12c/0x158 kernel/kthread.c:376
 ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:863
irq event stamp: 639638
hardirqs last  enabled at (639637): [<ffff80000c124078>] __raw_spin_unlock_irq include/linux/spinlock_api_smp.h:159 [inline]
hardirqs last  enabled at (639637): [<ffff80000c124078>] _raw_spin_unlock_irq+0x3c/0x70 kernel/locking/spinlock.c:202
hardirqs last disabled at (639638): [<ffff80000c110db0>] el1_dbg+0x24/0x80 arch/arm64/kernel/entry-common.c:405
softirqs last  enabled at (638456): [<ffff80000b811778>] sock_orphan include/net/sock.h:2098 [inline]
softirqs last  enabled at (638456): [<ffff80000b811778>] unix_release_sock+0x15c/0x544 net/unix/af_unix.c:604
softirqs last disabled at (638454): [<ffff80000b81175c>] sock_orphan include/net/sock.h:2094 [inline]
softirqs last disabled at (638454): [<ffff80000b81175c>] unix_release_sock+0x140/0x544 net/unix/af_unix.c:604
---[ end trace 0000000000000000 ]---
------------[ cut here ]------------
WARNING: CPU: 1 PID: 28 at io_uring/io_uring.c:734 io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
Modules linked in:
CPU: 1 PID: 28 Comm: kworker/u4:1 Tainted: G        W          6.2.0-rc3-syzkaller-16369-g358a161a6a9e #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
Workqueue: events_unbound io_ring_exit_work

pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
lr : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
sp : ffff80000f7dbad0
x29: ffff80000f7dbad0
 x28: ffff0000c995f878
 x27: ffff80000d49b000

x26: 0000000000000000
 x25: 0000000000000000
 x24: 0000000000000000

x23: 0000000000000000
 x22: 0000000000000000
 x21: 0000000000000000

x20: 0000000000000000
 x19: ffff0000c4d2c000
 x18: 0000000000000380

x17: ffff80000c15d8bc
 x16: ffff80000dd86118
 x15: ffff0000c0cf8000

x14: 00000000000000b8
 x13: 00000000ffffffff
 x12: ffff0000c0cf8000

x11: ff80800009594dec
 x10: 0000000000000000
 x9 : ffff800009594dec

x8 : ffff0000c0cf8000
 x7 : ffff80000c109860
 x6 : 0000000000000000

x5 : 0000000000000000
 x4 : 0000000000000000 x3 : 0000000000000000
x2 : 0000000000000000
 x1 : 0000000000000000
 x0 : 0000000000000000
Call trace:
 io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
 io_req_cqe_overflow+0x5c/0x70 io_uring/io_uring.c:773
 io_fill_cqe_req io_uring/io_uring.h:168 [inline]
 io_do_iopoll+0x474/0x62c io_uring/rw.c:1065
 io_iopoll_try_reap_events+0x6c/0x108 io_uring/io_uring.c:1513
 io_uring_try_cancel_requests+0x13c/0x258 io_uring/io_uring.c:3056
 io_ring_exit_work+0xec/0x390 io_uring/io_uring.c:2869
 process_one_work+0x2d8/0x504 kernel/workqueue.c:2289
 worker_thread+0x340/0x610 kernel/workqueue.c:2436
 kthread+0x12c/0x158 kernel/kthread.c:376
 ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:863
irq event stamp: 641034
hardirqs last  enabled at (641033): [<ffff80000c124078>] __raw_spin_unlock_irq include/linux/spinlock_api_smp.h:159 [inline]
hardirqs last  enabled at (641033): [<ffff80000c124078>] _raw_spin_unlock_irq+0x3c/0x70 kernel/locking/spinlock.c:202
hardirqs last disabled at (641034): [<ffff80000c110db0>] el1_dbg+0x24/0x80 arch/arm64/kernel/entry-common.c:405
softirqs last  enabled at (639852): [<ffff80000b811778>] sock_orphan include/net/sock.h:2098 [inline]
softirqs last  enabled at (639852): [<ffff80000b811778>] unix_release_sock+0x15c/0x544 net/unix/af_unix.c:604
softirqs last disabled at (639850): [<ffff80000b81175c>] sock_orphan include/net/sock.h:2094 [inline]
softirqs last disabled at (639850): [<ffff80000b81175c>] unix_release_sock+0x140/0x544 net/unix/af_unix.c:604
---[ end trace 0000000000000000 ]---
------------[ cut here ]------------
WARNING: CPU: 1 PID: 28 at io_uring/io_uring.c:734 io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
Modules linked in:
CPU: 1 PID: 28 Comm: kworker/u4:1 Tainted: G        W          6.2.0-rc3-syzkaller-16369-g358a161a6a9e #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
Workqueue: events_unbound io_ring_exit_work
pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
lr : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
sp : ffff80000f7dbad0
x29: ffff80000f7dbad0 x28: ffff0000c4404978 x27: ffff80000d49b000
x26: 0000000000000000 x25: 0000000000000000 x24: 0000000000000000
x23: 0000000000000000 x22: 0000000000000000 x21: 0000000000000000
x20: 0000000000000000 x19: ffff0000c93ef000 x18: 0000000000000228
x17: ffff0001feff7268 x16: ffff80000dd86118 x15: ffff0000c0cf8000
x14: 00000000000000b8 x13: 00000000ffffffff x12: ffff0000c0cf8000
x11: ff80800009594dec x10: 0000000000000000 x9 : ffff800009594dec
x8 : ffff0000c0cf8000 x7 : ffff80000c109860 x6 : 0000000000000000
x5 : 0000000000000000 x4 : 0000000000000000 x3 : 0000000000000000
x2 : 0000000000000000 x1 : 0000000000000000 x0 : 0000000000000000
Call trace:
 io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
 io_req_cqe_overflow+0x5c/0x70 io_uring/io_uring.c:773
 io_fill_cqe_req io_uring/io_uring.h:168 [inline]
 io_do_iopoll+0x474/0x62c io_uring/rw.c:1065
 io_iopoll_try_reap_events+0x6c/0x108 io_uring/io_uring.c:1513
 io_uring_try_cancel_requests+0x13c/0x258 io_uring/io_uring.c:3056
 io_ring_exit_work+0xec/0x390 io_uring/io_uring.c:2869
 process_one_work+0x2d8/0x504 kernel/workqueue.c:2289
 worker_thread+0x340/0x610 kernel/workqueue.c:2436
 kthread+0x12c/0x158 kernel/kthread.c:376
 ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:863
irq event stamp: 642368
hardirqs last  enabled at (642367): [<ffff80000c124078>] __raw_spin_unlock_irq include/linux/spinlock_api_smp.h:159 [inline]
hardirqs last  enabled at (642367): [<ffff80000c124078>] _raw_spin_unlock_irq+0x3c/0x70 kernel/locking/spinlock.c:202
hardirqs last disabled at (642368): [<ffff80000c110db0>] el1_dbg+0x24/0x80 arch/arm64/kernel/entry-common.c:405
softirqs last  enabled at (641192): [<ffff80000b811778>] sock_orphan include/net/sock.h:2098 [inline]
softirqs last  enabled at (641192): [<ffff80000b811778>] unix_release_sock+0x15c/0x544 net/unix/af_unix.c:604
softirqs last disabled at (641190): [<ffff80000b81175c>] sock_orphan include/net/sock.h:2094 [inline]
softirqs last disabled at (641190): [<ffff80000b81175c>] unix_release_sock+0x140/0x544 net/unix/af_unix.c:604
---[ end trace 0000000000000000 ]---
------------[ cut here ]------------
WARNING: CPU: 1 PID: 28 at io_uring/io_uring.c:734 io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
Modules linked in:
CPU: 1 PID: 28 Comm: kworker/u4:1 Tainted: G        W          6.2.0-rc3-syzkaller-16369-g358a161a6a9e #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
Workqueue: events_unbound io_ring_exit_work

pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
lr : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
sp : ffff80000f7dbad0
x29: ffff80000f7dbad0
 x28: ffff0000c4f2f978
 x27: ffff80000d49b000

x26: 0000000000000000
 x25: 0000000000000000
 x24: 0000000000000000

x23: 0000000000000000
 x22: 0000000000000000
 x21: 0000000000000000

x20: 0000000000000000
 x19: ffff0000c93ef000
 x18: ffff800014643720

x17: ffff80000c15d8bc
 x16: ffff80000dd86118
 x15: ffff0000c0cf8000

x14: 00000000000000b8
 x13: 00000000ffffffff
 x12: ffff0000c0cf8000

x11: ff80800009594dec
 x10: 0000000000000000
 x9 : ffff800009594dec

x8 : ffff0000c0cf8000
 x7 : ffff80000c109860
 x6 : 0000000000000000

x5 : 0000000000000000
 x4 : 0000000000000000
 x3 : 0000000000000000

x2 : 0000000000000000
 x1 : 0000000000000000
 x0 : 0000000000000000

Call trace:
 io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
 io_req_cqe_overflow+0x5c/0x70 io_uring/io_uring.c:773
 io_fill_cqe_req io_uring/io_uring.h:168 [inline]
 io_do_iopoll+0x474/0x62c io_uring/rw.c:1065
 io_iopoll_try_reap_events+0x6c/0x108 io_uring/io_uring.c:1513
 io_uring_try_cancel_requests+0x13c/0x258 io_uring/io_uring.c:3056
 io_ring_exit_work+0xec/0x390 io_uring/io_uring.c:2869
 process_one_work+0x2d8/0x504 kernel/workqueue.c:2289
 worker_thread+0x340/0x610 kernel/workqueue.c:2436
 kthread+0x12c/0x158 kernel/kthread.c:376
 ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:863
irq event stamp: 643668
hardirqs last  enabled at (643667): [<ffff80000c124078>] __raw_spin_unlock_irq include/linux/spinlock_api_smp.h:159 [inline]
hardirqs last  enabled at (643667): [<ffff80000c124078>] _raw_spin_unlock_irq+0x3c/0x70 kernel/locking/spinlock.c:202
hardirqs last disabled at (643668): [<ffff80000c110db0>] el1_dbg+0x24/0x80 arch/arm64/kernel/entry-common.c:405
softirqs last  enabled at (642486): [<ffff80000b811778>] sock_orphan include/net/sock.h:2098 [inline]
softirqs last  enabled at (642486): [<ffff80000b811778>] unix_release_sock+0x15c/0x544 net/unix/af_unix.c:604
softirqs last disabled at (642484): [<ffff80000b81175c>] sock_orphan include/net/sock.h:2094 [inline]
softirqs last disabled at (642484): [<ffff80000b81175c>] unix_release_sock+0x140/0x544 net/unix/af_unix.c:604
---[ end trace 0000000000000000 ]---
------------[ cut here ]------------
WARNING: CPU: 1 PID: 28 at io_uring/io_uring.c:734 io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
Modules linked in:
CPU: 1 PID: 28 Comm: kworker/u4:1 Tainted: G        W          6.2.0-rc3-syzkaller-16369-g358a161a6a9e #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
Workqueue: events_unbound io_ring_exit_work

pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
lr : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
sp : ffff80000f7dbad0
x29: ffff80000f7dbad0
 x28: ffff0000c649e878
 x27: ffff80000d49b000

x26: 0000000000000000
 x25: 0000000000000000
 x24: 0000000000000000

x23: 0000000000000000
 x22: 0000000000000000
 x21: 0000000000000000

x20: 0000000000000000
 x19: ffff0000c4d28000 x18: 0000000000000065
x17: 000000000000b67e
 x16: ffff80000dd86118
 x15: ffff0000c0cf8000

x14: 00000000000000b8
 x13: 00000000ffffffff
 x12: ffff0000c0cf8000

x11: ff80800009594dec
 x10: 0000000000000000 x9 : ffff800009594dec

x8 : ffff0000c0cf8000
 x7 : ffff80000c109860
 x6 : 0000000000000000

x5 : 0000000000000000
 x4 : 0000000000000000
 x3 : 0000000000000000

x2 : 0000000000000000 x1 : 0000000000000000
 x0 : 0000000000000000

Call trace:
 io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
 io_req_cqe_overflow+0x5c/0x70 io_uring/io_uring.c:773
 io_fill_cqe_req io_uring/io_uring.h:168 [inline]
 io_do_iopoll+0x474/0x62c io_uring/rw.c:1065
 io_iopoll_try_reap_events+0x6c/0x108 io_uring/io_uring.c:1513
 io_uring_try_cancel_requests+0x13c/0x258 io_uring/io_uring.c:3056
 io_ring_exit_work+0xec/0x390 io_uring/io_uring.c:2869
 process_one_work+0x2d8/0x504 kernel/workqueue.c:2289
 worker_thread+0x340/0x610 kernel/workqueue.c:2436
 kthread+0x12c/0x158 kernel/kthread.c:376
 ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:863
irq event stamp: 644976
hardirqs last  enabled at (644975): [<ffff80000c124078>] __raw_spin_unlock_irq include/linux/spinlock_api_smp.h:159 [inline]
hardirqs last  enabled at (644975): [<ffff80000c124078>] _raw_spin_unlock_irq+0x3c/0x70 kernel/locking/spinlock.c:202
hardirqs last disabled at (644976): [<ffff80000c110db0>] el1_dbg+0x24/0x80 arch/arm64/kernel/entry-common.c:405
softirqs last  enabled at (643798): [<ffff80000b811778>] sock_orphan include/net/sock.h:2098 [inline]
softirqs last  enabled at (643798): [<ffff80000b811778>] unix_release_sock+0x15c/0x544 net/unix/af_unix.c:604
softirqs last disabled at (643796): [<ffff80000b81175c>] sock_orphan include/net/sock.h:2094 [inline]
softirqs last disabled at (643796): [<ffff80000b81175c>] unix_release_sock+0x140/0x544 net/unix/af_unix.c:604
---[ end trace 0000000000000000 ]---
------------[ cut here ]------------
WARNING: CPU: 0 PID: 28 at io_uring/io_uring.c:734 io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
Modules linked in:
CPU: 0 PID: 28 Comm: kworker/u4:1 Tainted: G        W          6.2.0-rc3-syzkaller-16369-g358a161a6a9e #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
Workqueue: events_unbound io_ring_exit_work
pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
lr : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
sp : ffff80000f7dbad0
x29: ffff80000f7dbad0 x28: ffff0000c995f078 x27: ffff80000d49b000
x26: 0000000000000000 x25: 0000000000000000 x24: 0000000000000000
x23: 0000000000000000 x22: 0000000000000000 x21: 0000000000000000
x20: 0000000000000000 x19: ffff0000c4d2a000 x18: 00000000000003c7
x17: 0000000000000000 x16: ffff80000dd86118 x15: ffff0000c0cf8000
x14: 00000000000000b8 x13: 00000000ffffffff x12: ffff0000c0cf8000
x11: ff80800009594dec x10: 0000000000000000 x9 : ffff800009594dec
x8 : ffff0000c0cf8000 x7 : ffff80000c109860 x6 : 0000000000000000
x5 : 0000000000000000 x4 : 0000000000000000 x3 : 0000000000000000
x2 : 0000000000000000 x1 : 0000000000000000 x0 : 0000000000000000
Call trace:
 io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
 io_req_cqe_overflow+0x5c/0x70 io_uring/io_uring.c:773
 io_fill_cqe_req io_uring/io_uring.h:168 [inline]
 io_do_iopoll+0x474/0x62c io_uring/rw.c:1065
 io_iopoll_try_reap_events+0x6c/0x108 io_uring/io_uring.c:1513
 io_uring_try_cancel_requests+0x13c/0x258 io_uring/io_uring.c:3056
 io_ring_exit_work+0xec/0x390 io_uring/io_uring.c:2869
 process_one_work+0x2d8/0x504 kernel/workqueue.c:2289
 worker_thread+0x340/0x610 kernel/workqueue.c:2436
 kthread+0x12c/0x158 kernel/kthread.c:376
 ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:863
irq event stamp: 646330
hardirqs last  enabled at (646329): [<ffff80000c124078>] __raw_spin_unlock_irq include/linux/spinlock_api_smp.h:159 [inline]
hardirqs last  enabled at (646329): [<ffff80000c124078>] _raw_spin_unlock_irq+0x3c/0x70 kernel/locking/spinlock.c:202
hardirqs last disabled at (646330): [<ffff80000c110db0>] el1_dbg+0x24/0x80 arch/arm64/kernel/entry-common.c:405
softirqs last  enabled at (645158): [<ffff80000b811778>] sock_orphan include/net/sock.h:2098 [inline]
softirqs last  enabled at (645158): [<ffff80000b811778>] unix_release_sock+0x15c/0x544 net/unix/af_unix.c:604
softirqs last disabled at (645156): [<ffff80000b81175c>] sock_orphan include/net/sock.h:2094 [inline]
softirqs last disabled at (645156): [<ffff80000b81175c>] unix_release_sock+0x140/0x544 net/unix/af_unix.c:604
---[ end trace 0000000000000000 ]---
------------[ cut here ]------------
WARNING: CPU: 1 PID: 28 at io_uring/io_uring.c:734 io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
Modules linked in:
CPU: 1 PID: 28 Comm: kworker/u4:1 Tainted: G        W          6.2.0-rc3-syzkaller-16369-g358a161a6a9e #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
Workqueue: events_unbound io_ring_exit_work
pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
lr : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
sp : ffff80000f7dbad0
x29: ffff80000f7dbad0 x28: ffff0000c4f2f278 x27: ffff80000d49b000
x26: 0000000000000000 x25: 0000000000000000 x24: 0000000000000000
x23: 0000000000000000 x22: 0000000000000000 x21: 0000000000000000
x20: 0000000000000000 x19: ffff0000c4d2f000 x18: 00000000000002d7
x17: ffff80000c15d8bc x16: ffff80000dd86118 x15: ffff0000c0cf8000
x14: 00000000000000b8 x13: 00000000ffffffff x12: ffff0000c0cf8000
x11: ff80800009594dec x10: 0000000000000000 x9 : ffff800009594dec
x8 : ffff0000c0cf8000 x7 : ffff80000c109860 x6 : 0000000000000000
x5 : 0000000000000000 x4 : 0000000000000000 x3 : 0000000000000000
x2 : 0000000000000000 x1 : 0000000000000000 x0 : 0000000000000000
Call trace:
 io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
 io_req_cqe_overflow+0x5c/0x70 io_uring/io_uring.c:773
 io_fill_cqe_req io_uring/io_uring.h:168 [inline]
 io_do_iopoll+0x474/0x62c io_uring/rw.c:1065
 io_iopoll_try_reap_events+0x6c/0x108 io_uring/io_uring.c:1513
 io_uring_try_cancel_requests+0x13c/0x258 io_uring/io_uring.c:3056
 io_ring_exit_work+0xec/0x390 io_uring/io_uring.c:2869
 process_one_work+0x2d8/0x504 kernel/workqueue.c:2289
 worker_thread+0x340/0x610 kernel/workqueue.c:2436
 kthread+0x12c/0x158 kernel/kthread.c:376
 ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:863
irq event stamp: 647682
hardirqs last  enabled at (647681): [<ffff80000c124078>] __raw_spin_unlock_irq include/linux/spinlock_api_smp.h:159 [inline]
hardirqs last  enabled at (647681): [<ffff80000c124078>] _raw_spin_unlock_irq+0x3c/0x70 kernel/locking/spinlock.c:202
hardirqs last disabled at (647682): [<ffff80000c110db0>] el1_dbg+0x24/0x80 arch/arm64/kernel/entry-common.c:405
softirqs last  enabled at (646506): [<ffff80000b811778>] sock_orphan include/net/sock.h:2098 [inline]
softirqs last  enabled at (646506): [<ffff80000b811778>] unix_release_sock+0x15c/0x544 net/unix/af_unix.c:604
softirqs last disabled at (646504): [<ffff80000b81175c>] sock_orphan include/net/sock.h:2094 [inline]
softirqs last disabled at (646504): [<ffff80000b81175c>] unix_release_sock+0x140/0x544 net/unix/af_unix.c:604
---[ end trace 0000000000000000 ]---
------------[ cut here ]------------
WARNING: CPU: 1 PID: 28 at io_uring/io_uring.c:734 io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
Modules linked in:
CPU: 1 PID: 28 Comm: kworker/u4:1 Tainted: G        W          6.2.0-rc3-syzkaller-16369-g358a161a6a9e #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
Workqueue: events_unbound io_ring_exit_work
pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
lr : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
sp : ffff80000f7dbad0
x29: ffff80000f7dbad0 x28: ffff0000c995fc78 x27: ffff80000d49b000
x26: 0000000000000000 x25: 0000000000000000 x24: 0000000000000000
x23: 0000000000000000 x22: 0000000000000000 x21: 0000000000000000
x20: 0000000000000000 x19: ffff0000c93ec000 x18: 00000000000003e1
x17: 0000000000000000 x16: ffff80000dd86118 x15: ffff0000c0cf8000
x14: 00000000000000b8 x13: 00000000ffffffff x12: ffff0000c0cf8000
x11: ff80800009594dec x10: 0000000000000000 x9 : ffff800009594dec
x8 : ffff0000c0cf8000 x7 : ffff80000c109860 x6 : 0000000000000000
x5 : 0000000000000000 x4 : 0000000000000000 x3 : 0000000000000000
x2 : 0000000000000000 x1 : 0000000000000000 x0 : 0000000000000000
Call trace:
 io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
 io_req_cqe_overflow+0x5c/0x70 io_uring/io_uring.c:773
 io_fill_cqe_req io_uring/io_uring.h:168 [inline]
 io_do_iopoll+0x474/0x62c io_uring/rw.c:1065
 io_iopoll_try_reap_events+0x6c/0x108 io_uring/io_uring.c:1513
 io_uring_try_cancel_requests+0x13c/0x258 io_uring/io_uring.c:3056
 io_ring_exit_work+0xec/0x390 io_uring/io_uring.c:2869
 process_one_work+0x2d8/0x504 kernel/workqueue.c:2289
 worker_thread+0x340/0x610 kernel/workqueue.c:2436
 kthread+0x12c/0x158 kernel/kthread.c:376
 ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:863
irq event stamp: 649060
hardirqs last  enabled at (649059): [<ffff80000c124078>] __raw_spin_unlock_irq include/linux/spinlock_api_smp.h:159 [inline]
hardirqs last  enabled at (649059): [<ffff80000c124078>] _raw_spin_unlock_irq+0x3c/0x70 kernel/locking/spinlock.c:202
hardirqs last disabled at (649060): [<ffff80000c110db0>] el1_dbg+0x24/0x80 arch/arm64/kernel/entry-common.c:405
softirqs last  enabled at (647884): [<ffff80000b811778>] sock_orphan include/net/sock.h:2098 [inline]
softirqs last  enabled at (647884): [<ffff80000b811778>] unix_release_sock+0x15c/0x544 net/unix/af_unix.c:604
softirqs last disabled at (647882): [<ffff80000b81175c>] sock_orphan include/net/sock.h:2094 [inline]
softirqs last disabled at (647882): [<ffff80000b81175c>] unix_release_sock+0x140/0x544 net/unix/af_unix.c:604
---[ end trace 0000000000000000 ]---
------------[ cut here ]------------
WARNING: CPU: 0 PID: 28 at io_uring/io_uring.c:734 io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
Modules linked in:
CPU: 0 PID: 28 Comm: kworker/u4:1 Tainted: G        W          6.2.0-rc3-syzkaller-16369-g358a161a6a9e #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
Workqueue: events_unbound io_ring_exit_work

pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
lr : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
sp : ffff80000f7dbad0
x29: ffff80000f7dbad0
 x28: ffff0000c9688278
 x27: ffff80000d49b000

x26: 0000000000000000
 x25: 0000000000000000
 x24: 0000000000000000

x23: 0000000000000000
 x22: 0000000000000000
 x21: 0000000000000000

x20: 0000000000000000
 x19: ffff0000c4d28000
 x18: 0000000000000291

x17: 0000000000000000
 x16: ffff80000dd86118
 x15: ffff0000c0cf8000

x14: 00000000000000b8
 x13: 00000000ffffffff
 x12: ffff0000c0cf8000

x11: ff80800009594dec
 x10: 0000000000000000
 x9 : ffff800009594dec

x8 : ffff0000c0cf8000
 x7 : ffff80000c109860
 x6 : 0000000000000000

x5 : 0000000000000000
 x4 : 0000000000000000
 x3 : 0000000000000000

x2 : 0000000000000000
 x1 : 0000000000000000
 x0 : 0000000000000000

Call trace:
 io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
 io_req_cqe_overflow+0x5c/0x70 io_uring/io_uring.c:773
 io_fill_cqe_req io_uring/io_uring.h:168 [inline]
 io_do_iopoll+0x474/0x62c io_uring/rw.c:1065
 io_iopoll_try_reap_events+0x6c/0x108 io_uring/io_uring.c:1513
 io_uring_try_cancel_requests+0x13c/0x258 io_uring/io_uring.c:3056
 io_ring_exit_work+0xec/0x390 io_uring/io_uring.c:2869
 process_one_work+0x2d8/0x504 kernel/workqueue.c:2289
 worker_thread+0x340/0x610 kernel/workqueue.c:2436
 kthread+0x12c/0x158 kernel/kthread.c:376
 ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:863
irq event stamp: 650446
hardirqs last  enabled at (650445): [<ffff80000c124078>] __raw_spin_unlock_irq include/linux/spinlock_api_smp.h:159 [inline]
hardirqs last  enabled at (650445): [<ffff80000c124078>] _raw_spin_unlock_irq+0x3c/0x70 kernel/locking/spinlock.c:202
hardirqs last disabled at (650446): [<ffff80000c110db0>] el1_dbg+0x24/0x80 arch/arm64/kernel/entry-common.c:405
softirqs last  enabled at (649612): [<ffff8000080102e4>] _stext+0x2e4/0x37c
softirqs last disabled at (649587): [<ffff800008017c90>] ____do_softirq+0x14/0x20 arch/arm64/kernel/irq.c:80
---[ end trace 0000000000000000 ]---
------------[ cut here ]------------
WARNING: CPU: 1 PID: 28 at io_uring/io_uring.c:734 io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
Modules linked in:
CPU: 1 PID: 28 Comm: kworker/u4:1 Tainted: G        W          6.2.0-rc3-syzkaller-16369-g358a161a6a9e #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
Workqueue: events_unbound io_ring_exit_work

pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
lr : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
sp : ffff80000f7dbad0
x29: ffff80000f7dbad0
 x28: ffff0000c995f678
 x27: ffff80000d49b000

x26: 0000000000000000
 x25: 0000000000000000
 x24: 0000000000000000

x23: 0000000000000000
 x22: 0000000000000000
 x21: 0000000000000000

x20: 0000000000000000
 x19: ffff0000c93ee000
 x18: ffff80001912b5f0

x17: ffff80000c15d8bc
 x16: ffff80000dd86118
 x15: ffff0000c0cf8000

x14: 00000000000000b8
 x13: 00000000ffffffff
 x12: ffff0000c0cf8000

x11: ff80800009594dec
 x10: 0000000000000000
 x9 : ffff800009594dec

x8 : ffff0000c0cf8000
 x7 : ffff80000c109860
 x6 : 0000000000000000

x5 : 0000000000000000
 x4 : 0000000000000000
 x3 : 0000000000000000

x2 : 0000000000000000
 x1 : 0000000000000000
 x0 : 0000000000000000

Call trace:
 io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
 io_req_cqe_overflow+0x5c/0x70 io_uring/io_uring.c:773
 io_fill_cqe_req io_uring/io_uring.h:168 [inline]
 io_do_iopoll+0x474/0x62c io_uring/rw.c:1065
 io_iopoll_try_reap_events+0x6c/0x108 io_uring/io_uring.c:1513
 io_uring_try_cancel_requests+0x13c/0x258 io_uring/io_uring.c:3056
 io_ring_exit_work+0xec/0x390 io_uring/io_uring.c:2869
 process_one_work+0x2d8/0x504 kernel/workqueue.c:2289
 worker_thread+0x340/0x610 kernel/workqueue.c:2436
 kthread+0x12c/0x158 kernel/kthread.c:376
 ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:863
irq event stamp: 651724
hardirqs last  enabled at (651723): [<ffff80000c124078>] __raw_spin_unlock_irq include/linux/spinlock_api_smp.h:159 [inline]
hardirqs last  enabled at (651723): [<ffff80000c124078>] _raw_spin_unlock_irq+0x3c/0x70 kernel/locking/spinlock.c:202
hardirqs last disabled at (651724): [<ffff80000c110db0>] el1_dbg+0x24/0x80 arch/arm64/kernel/entry-common.c:405
softirqs last  enabled at (650546): [<ffff80000b811778>] sock_orphan include/net/sock.h:2098 [inline]
softirqs last  enabled at (650546): [<ffff80000b811778>] unix_release_sock+0x15c/0x544 net/unix/af_unix.c:604
softirqs last disabled at (650544): [<ffff80000b81175c>] sock_orphan include/net/sock.h:2094 [inline]
softirqs last disabled at (650544): [<ffff80000b81175c>] unix_release_sock+0x140/0x544 net/unix/af_unix.c:604
---[ end trace 0000000000000000 ]---
------------[ cut here ]------------
WARNING: CPU: 0 PID: 28 at io_uring/io_uring.c:734 io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
Modules linked in

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
