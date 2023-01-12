Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0C7E66706F
	for <lists+io-uring@lfdr.de>; Thu, 12 Jan 2023 12:05:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231575AbjALLFY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 Jan 2023 06:05:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231656AbjALLFE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 Jan 2023 06:05:04 -0500
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE0403AA
        for <io-uring@vger.kernel.org>; Thu, 12 Jan 2023 02:56:18 -0800 (PST)
Received: by mail-io1-f69.google.com with SMTP id z9-20020a6be009000000b006e0577c3686so10876345iog.0
        for <io-uring@vger.kernel.org>; Thu, 12 Jan 2023 02:56:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=c70SQndbZorZngnihNfYASa4lUls1tbZ8cLdA7wRKDY=;
        b=i+IqakQRh86D4RTamHuBwTjUyye90cccGkPPZFlvhZ+1UA7aLoTjtlmhWBWiqvnIBw
         BOAdRV7F2Ew6G9ZUmq3aI9kMHQFVNFmt8G3OB5317swyX/k7JWTyUrfSl/4irARX27Kd
         KHvDLZRootg7HIgP+FS0Y7Ij673faA3cK1dgYoAow68Oo8+1bWtwbSBEF2/+e5MFk504
         4DWcjLbfYKm9gYrtVR0epNnRaZw8wZ2Ln1pI1rrigLx5KqY45WPGhw7QxazAFLuwQBKp
         N8RNascfzZbT3eB/Nuy53CXc0XT7ZbYC37+ZSG2qp5VI7ZT6JPRkAEeCTdw8jYwmME5o
         yNVQ==
X-Gm-Message-State: AFqh2kpDT5PCeNejr34hsBVeu0bn1IsEJl/5PaOjqS4gRl15fEaqGDGd
        J1d3z5sLFCmtvcOKXuVdQntNtowwvRHhFzwGn95dkl2QxSTo
X-Google-Smtp-Source: AMrXdXuY2GcXUeKs+i5S4Uy0SdiTuv94AhTl8Vwf9vPC4f2xqexQ6LAyvZitNS1dTEAX1LhPlevI8s1XwvQb9bTkER90SIm4fb0E
MIME-Version: 1.0
X-Received: by 2002:a92:d64d:0:b0:30e:d14d:9204 with SMTP id
 x13-20020a92d64d000000b0030ed14d9204mr123257ilp.128.1673520977888; Thu, 12
 Jan 2023 02:56:17 -0800 (PST)
Date:   Thu, 12 Jan 2023 02:56:17 -0800
In-Reply-To: <fc382b22-6fb2-c759-fbfd-88ed23b61bc1@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000694ccd05f20ef7be@google.com>
Subject: Re: [syzbot] WARNING in io_cqring_event_overflow
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

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
WARNING in io_cqring_event_overflow

------------[ cut here ]------------
WARNING: CPU: 1 PID: 2836 at io_uring/io_uring.c:734 io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
Modules linked in:
CPU: 1 PID: 2836 Comm: kworker/u4:4 Not tainted 6.2.0-rc3-syzkaller-00011-g0af4af977a59 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
Workqueue: events_unbound io_ring_exit_work
pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
lr : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
sp : ffff8000164abad0
x29: ffff8000164abad0
 x28: ffff0000c655e578
 x27: ffff80000d49b000

x26: 0000000000000000
 x25: 0000000000000000
 x24: 0000000000000000

x23: 0000000000000000
 x22: 0000000000000000
 x21: 0000000000000000

x20: 0000000000000000
 x19: ffff0000d1727000
 x18: 00000000000000c0

x17: ffff80000df48158
 x16: ffff80000dd86118
 x15: ffff0000c60dce00

x14: 0000000000000110
 x13: 00000000ffffffff
 x12: ffff0000c60dce00

x11: ff808000095945e8
 x10: 0000000000000000
 x9 : ffff8000095945e8

x8 : ffff0000c60dce00
 x7 : ffff80000c1090e0
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
irq event stamp: 576210
hardirqs last  enabled at (576209): [<ffff80000c1238f8>] __raw_spin_unlock_irq include/linux/spinlock_api_smp.h:159 [inline]
hardirqs last  enabled at (576209): [<ffff80000c1238f8>] _raw_spin_unlock_irq+0x3c/0x70 kernel/locking/spinlock.c:202
hardirqs last disabled at (576210): [<ffff80000c110630>] el1_dbg+0x24/0x80 arch/arm64/kernel/entry-common.c:405
softirqs last  enabled at (576168): [<ffff80000bfd4634>] spin_unlock_bh include/linux/spinlock.h:395 [inline]
softirqs last  enabled at (576168): [<ffff80000bfd4634>] batadv_nc_purge_paths+0x1d0/0x214 net/batman-adv/network-coding.c:471
softirqs last disabled at (576166): [<ffff80000bfd44c4>] spin_lock_bh include/linux/spinlock.h:355 [inline]
softirqs last disabled at (576166): [<ffff80000bfd44c4>] batadv_nc_purge_paths+0x60/0x214 net/batman-adv/network-coding.c:442
---[ end trace 0000000000000000 ]---
------------[ cut here ]------------
WARNING: CPU: 0 PID: 2836 at io_uring/io_uring.c:734 io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
Modules linked in:

CPU: 0 PID: 2836 Comm: kworker/u4:4 Tainted: G        W          6.2.0-rc3-syzkaller-00011-g0af4af977a59 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
Workqueue: events_unbound io_ring_exit_work

pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
lr : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
sp : ffff8000164abad0
x29: ffff8000164abad0
 x28: ffff0000c3a36f78
 x27: ffff80000d49b000

x26: 0000000000000000
 x25: 0000000000000000
 x24: 0000000000000000

x23: 0000000000000000
 x22: 0000000000000000
 x21: 0000000000000000

x20: 0000000000000000
 x19: ffff0000c70e9000
 x18: 0000000000000232

x17: ffff80000c15d8bc
 x16: ffff80000dd86118
 x15: ffff0000c60dce00

x14: 0000000000000110
 x13: 00000000ffffffff
 x12: ffff0000c60dce00

x11: ff808000095945e8
 x10: 0000000000000000
 x9 : ffff8000095945e8

x8 : ffff0000c60dce00
 x7 : ffff80000c1090e0
 x6 : 0000000000000000

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
irq event stamp: 587416
hardirqs last  enabled at (587415): [<ffff80000c1238f8>] __raw_spin_unlock_irq include/linux/spinlock_api_smp.h:159 [inline]
hardirqs last  enabled at (587415): [<ffff80000c1238f8>] _raw_spin_unlock_irq+0x3c/0x70 kernel/locking/spinlock.c:202
hardirqs last disabled at (587416): [<ffff80000c110630>] el1_dbg+0x24/0x80 arch/arm64/kernel/entry-common.c:405
softirqs last  enabled at (587360): [<ffff80000bfd4634>] spin_unlock_bh include/linux/spinlock.h:395 [inline]
softirqs last  enabled at (587360): [<ffff80000bfd4634>] batadv_nc_purge_paths+0x1d0/0x214 net/batman-adv/network-coding.c:471
softirqs last disabled at (587358): [<ffff80000bfd44c4>] spin_lock_bh include/linux/spinlock.h:355 [inline]
softirqs last disabled at (587358): [<ffff80000bfd44c4>] batadv_nc_purge_paths+0x60/0x214 net/batman-adv/network-coding.c:442
---[ end trace 0000000000000000 ]---
------------[ cut here ]------------
WARNING: CPU: 0 PID: 2836 at io_uring/io_uring.c:734 io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
Modules linked in:
CPU: 0 PID: 2836 Comm: kworker/u4:4 Tainted: G        W          6.2.0-rc3-syzkaller-00011-g0af4af977a59 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
Workqueue: events_unbound io_ring_exit_work
pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
lr : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
sp : ffff8000164abad0
x29: ffff8000164abad0 x28: ffff0000cc27dc78 x27: ffff80000d49b000
x26: 0000000000000000 x25: 0000000000000000 x24: 0000000000000000
x23: 0000000000000000 x22: 0000000000000000 x21: 0000000000000000
x20: 0000000000000000 x19: ffff0000c60f2000 x18: 0000000000000364
x17: ffff80000c15d8bc x16: ffff80000dd86118 x15: ffff0000c60dce00
x14: 0000000000000110 x13: 00000000ffffffff x12: ffff0000c60dce00
x11: ff808000095945e8 x10: 0000000000000000 x9 : ffff8000095945e8
x8 : ffff0000c60dce00 x7 : ffff80000c1090e0 x6 : 0000000000000000
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
irq event stamp: 588956
hardirqs last  enabled at (588955): [<ffff80000c1238f8>] __raw_spin_unlock_irq include/linux/spinlock_api_smp.h:159 [inline]
hardirqs last  enabled at (588955): [<ffff80000c1238f8>] _raw_spin_unlock_irq+0x3c/0x70 kernel/locking/spinlock.c:202
hardirqs last disabled at (588956): [<ffff80000c110630>] el1_dbg+0x24/0x80 arch/arm64/kernel/entry-common.c:405
softirqs last  enabled at (587754): [<ffff80000b811ff8>] sock_orphan include/net/sock.h:2098 [inline]
softirqs last  enabled at (587754): [<ffff80000b811ff8>] unix_release_sock+0x15c/0x544 net/unix/af_unix.c:604
softirqs last disabled at (587752): [<ffff80000b811fdc>] sock_orphan include/net/sock.h:2094 [inline]
softirqs last disabled at (587752): [<ffff80000b811fdc>] unix_release_sock+0x140/0x544 net/unix/af_unix.c:604
---[ end trace 0000000000000000 ]---
------------[ cut here ]------------
WARNING: CPU: 1 PID: 2836 at io_uring/io_uring.c:734 io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
Modules linked in:

CPU: 1 PID: 2836 Comm: kworker/u4:4 Tainted: G        W          6.2.0-rc3-syzkaller-00011-g0af4af977a59 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
Workqueue: events_unbound io_ring_exit_work

pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
lr : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
sp : ffff8000164abad0
x29: ffff8000164abad0
 x28: ffff0000cc1fb478
 x27: ffff80000d49b000

x26: 0000000000000000
 x25: 0000000000000000
 x24: 0000000000000000

x23: 0000000000000000
 x22: 0000000000000000
 x21: 0000000000000000

x20: 0000000000000000
 x19: ffff0000c7bf0000
 x18: 0000000000000191

x17: ffff80000c15d8bc
 x16: ffff80000dd86118
 x15: ffff0000c60dce00

x14: 0000000000000110
 x13: 00000000ffffffff
 x12: ffff0000c60dce00

x11: ff808000095945e8
 x10: 0000000000000000
 x9 : ffff8000095945e8

x8 : ffff0000c60dce00
 x7 : ffff80000c1090e0
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
irq event stamp: 598112
hardirqs last  enabled at (598111): [<ffff80000c1238f8>] __raw_spin_unlock_irq include/linux/spinlock_api_smp.h:159 [inline]
hardirqs last  enabled at (598111): [<ffff80000c1238f8>] _raw_spin_unlock_irq+0x3c/0x70 kernel/locking/spinlock.c:202
hardirqs last disabled at (598112): [<ffff80000c110630>] el1_dbg+0x24/0x80 arch/arm64/kernel/entry-common.c:405
softirqs last  enabled at (597426): [<ffff80000bfd4634>] spin_unlock_bh include/linux/spinlock.h:395 [inline]
softirqs last  enabled at (597426): [<ffff80000bfd4634>] batadv_nc_purge_paths+0x1d0/0x214 net/batman-adv/network-coding.c:471
softirqs last disabled at (597424): [<ffff80000bfd44c4>] spin_lock_bh include/linux/spinlock.h:355 [inline]
softirqs last disabled at (597424): [<ffff80000bfd44c4>] batadv_nc_purge_paths+0x60/0x214 net/batman-adv/network-coding.c:442
---[ end trace 0000000000000000 ]---
------------[ cut here ]------------
WARNING: CPU: 0 PID: 2836 at io_uring/io_uring.c:734 io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
Modules linked in:
CPU: 0 PID: 2836 Comm: kworker/u4:4 Tainted: G        W          6.2.0-rc3-syzkaller-00011-g0af4af977a59 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
Workqueue: events_unbound io_ring_exit_work

pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
lr : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
sp : ffff8000164abad0
x29: ffff8000164abad0
 x28: ffff0000c39dbe78
 x27: ffff80000d49b000

x26: 0000000000000000
 x25: 0000000000000000
 x24: 0000000000000000

x23: 0000000000000000
 x22: 0000000000000000
 x21: 0000000000000000

x20: 0000000000000000
 x19: ffff0000c82e1000
 x18: 000000000000032e

x17: ffff80000c15d8bc
 x16: ffff80000dd86118
 x15: ffff0000c60dce00

x14: 0000000000000110
 x13: 00000000ffffffff
 x12: ffff0000c60dce00

x11: ff808000095945e8
 x10: 0000000000000000
 x9 : ffff8000095945e8

x8 : ffff0000c60dce00
 x7 : ffff80000c1090e0
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
irq event stamp: 600672
hardirqs last  enabled at (600671): [<ffff80000c1238f8>] __raw_spin_unlock_irq include/linux/spinlock_api_smp.h:159 [inline]
hardirqs last  enabled at (600671): [<ffff80000c1238f8>] _raw_spin_unlock_irq+0x3c/0x70 kernel/locking/spinlock.c:202
hardirqs last disabled at (600672): [<ffff80000c110630>] el1_dbg+0x24/0x80 arch/arm64/kernel/entry-common.c:405
softirqs last  enabled at (600626): [<ffff80000bfd4634>] spin_unlock_bh include/linux/spinlock.h:395 [inline]
softirqs last  enabled at (600626): [<ffff80000bfd4634>] batadv_nc_purge_paths+0x1d0/0x214 net/batman-adv/network-coding.c:471
softirqs last disabled at (600624): [<ffff80000bfd44c4>] spin_lock_bh include/linux/spinlock.h:355 [inline]
softirqs last disabled at (600624): [<ffff80000bfd44c4>] batadv_nc_purge_paths+0x60/0x214 net/batman-adv/network-coding.c:442
---[ end trace 0000000000000000 ]---
------------[ cut here ]------------
WARNING: CPU: 0 PID: 2836 at io_uring/io_uring.c:734 io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
Modules linked in:

CPU: 0 PID: 2836 Comm: kworker/u4:4 Tainted: G        W          6.2.0-rc3-syzkaller-00011-g0af4af977a59 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
Workqueue: events_unbound io_ring_exit_work

pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
lr : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
sp : ffff8000164abad0
x29: ffff8000164abad0
 x28: ffff0000cc27d878
 x27: ffff80000d49b000

x26: 0000000000000000
 x25: 0000000000000000
 x24: 0000000000000000

x23: 0000000000000000 x22: 0000000000000000 x21: 0000000000000000

x20: 0000000000000000
 x19: ffff0000d1727000
 x18: 0000000000000315

x17: ffff80000c15d8bc
 x16: ffff80000dd86118
 x15: ffff0000c60dce00

x14: 0000000000000110
 x13: 00000000ffffffff
 x12: ffff0000c60dce00

x11: ff808000095945e8
 x10: 0000000000000000
 x9 : ffff8000095945e8

x8 : ffff0000c60dce00
 x7 : ffff80000c1090e0
 x6 : 0000000000000000
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
irq event stamp: 603390
hardirqs last  enabled at (603389): [<ffff80000c1238f8>] __raw_spin_unlock_irq include/linux/spinlock_api_smp.h:159 [inline]
hardirqs last  enabled at (603389): [<ffff80000c1238f8>] _raw_spin_unlock_irq+0x3c/0x70 kernel/locking/spinlock.c:202
hardirqs last disabled at (603390): [<ffff80000c110630>] el1_dbg+0x24/0x80 arch/arm64/kernel/entry-common.c:405
softirqs last  enabled at (603380): [<ffff80000bfd4634>] spin_unlock_bh include/linux/spinlock.h:395 [inline]
softirqs last  enabled at (603380): [<ffff80000bfd4634>] batadv_nc_purge_paths+0x1d0/0x214 net/batman-adv/network-coding.c:471
softirqs last disabled at (603378): [<ffff80000bfd44c4>] spin_lock_bh include/linux/spinlock.h:355 [inline]
softirqs last disabled at (603378): [<ffff80000bfd44c4>] batadv_nc_purge_paths+0x60/0x214 net/batman-adv/network-coding.c:442
---[ end trace 0000000000000000 ]---
------------[ cut here ]------------
WARNING: CPU: 1 PID: 2836 at io_uring/io_uring.c:734 io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
Modules linked in:
CPU: 1 PID: 2836 Comm: kworker/u4:4 Tainted: G        W          6.2.0-rc3-syzkaller-00011-g0af4af977a59 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
Workqueue: events_unbound io_ring_exit_work
pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
lr : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
sp : ffff8000164abad0
x29: ffff8000164abad0 x28: ffff0000c63c7478 x27: ffff80000d49b000
x26: 0000000000000000 x25: 0000000000000000 x24: 0000000000000000
x23: 0000000000000000 x22: 0000000000000000 x21: 0000000000000000
x20: 0000000000000000 x19: ffff0000c9364000 x18: 0000000000000150
x17: ffff8001f1b6b000 x16: ffff80000dd86118 x15: ffff0000c60dce00
x14: 0000000000000110 x13: 00000000ffffffff x12: ffff0000c60dce00
x11: ff808000095945e8 x10: 0000000000000000 x9 : ffff8000095945e8
x8 : ffff0000c60dce00 x7 : ffff80000c1090e0 x6 : 0000000000000000
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
irq event stamp: 613556
hardirqs last  enabled at (613555): [<ffff80000c1238f8>] __raw_spin_unlock_irq include/linux/spinlock_api_smp.h:159 [inline]
hardirqs last  enabled at (613555): [<ffff80000c1238f8>] _raw_spin_unlock_irq+0x3c/0x70 kernel/locking/spinlock.c:202
hardirqs last disabled at (613556): [<ffff80000c110630>] el1_dbg+0x24/0x80 arch/arm64/kernel/entry-common.c:405
softirqs last  enabled at (613530): [<ffff80000bd93034>] spin_unlock_bh include/linux/spinlock.h:395 [inline]
softirqs last  enabled at (613530): [<ffff80000bd93034>] ieee80211_ibss_work+0x184/0x9f0 net/mac80211/ibss.c:1701
softirqs last disabled at (613528): [<ffff80000bd92f18>] spin_lock_bh include/linux/spinlock.h:355 [inline]
softirqs last disabled at (613528): [<ffff80000bd92f18>] ieee80211_ibss_work+0x68/0x9f0 net/mac80211/ibss.c:1690
---[ end trace 0000000000000000 ]---
------------[ cut here ]------------
WARNING: CPU: 1 PID: 2836 at io_uring/io_uring.c:734 io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
Modules linked in:
CPU: 1 PID: 2836 Comm: kworker/u4:4 Tainted: G        W          6.2.0-rc3-syzkaller-00011-g0af4af977a59 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
Workqueue: events_unbound io_ring_exit_work

pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
lr : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
sp : ffff8000164abad0
x29: ffff8000164abad0
 x28: ffff0000cc1fb378
 x27: ffff80000d49b000

x26: 0000000000000000
 x25: 0000000000000000
 x24: 0000000000000000

x23: 0000000000000000 x22: 0000000000000000 x21: 0000000000000000
x20: 0000000000000000 x19: ffff0000c70e9000 x18: 000000000000028f
x17: 0000000000000075 x16: ffff80000dd86118 x15: ffff0000c60dce00
x14: 0000000000000110 x13: 00000000ffffffff x12: ffff0000c60dce00
x11: ff808000095945e8
 x10: 0000000000000000
 x9 : ffff8000095945e8

x8 : ffff0000c60dce00
 x7 : ffff80000c1090e0
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
irq event stamp: 621634
hardirqs last  enabled at (621633): [<ffff80000c1238f8>] __raw_spin_unlock_irq include/linux/spinlock_api_smp.h:159 [inline]
hardirqs last  enabled at (621633): [<ffff80000c1238f8>] _raw_spin_unlock_irq+0x3c/0x70 kernel/locking/spinlock.c:202
hardirqs last disabled at (621634): [<ffff80000c110630>] el1_dbg+0x24/0x80 arch/arm64/kernel/entry-common.c:405
softirqs last  enabled at (621566): [<ffff80000bfd4634>] spin_unlock_bh include/linux/spinlock.h:395 [inline]
softirqs last  enabled at (621566): [<ffff80000bfd4634>] batadv_nc_purge_paths+0x1d0/0x214 net/batman-adv/network-coding.c:471
softirqs last disabled at (621564): [<ffff80000bfd44c4>] spin_lock_bh include/linux/spinlock.h:355 [inline]
softirqs last disabled at (621564): [<ffff80000bfd44c4>] batadv_nc_purge_paths+0x60/0x214 net/batman-adv/network-coding.c:442
---[ end trace 0000000000000000 ]---
------------[ cut here ]------------
WARNING: CPU: 1 PID: 2836 at io_uring/io_uring.c:734 io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
Modules linked in:

CPU: 1 PID: 2836 Comm: kworker/u4:4 Tainted: G        W          6.2.0-rc3-syzkaller-00011-g0af4af977a59 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
Workqueue: events_unbound io_ring_exit_work

pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
lr : io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
sp : ffff8000164abad0
x29: ffff8000164abad0
 x28: ffff0000c4c59b78
 x27: ffff80000d49b000

x26: 0000000000000000
 x25: 0000000000000000
 x24: 0000000000000000

x23: 0000000000000000
 x22: 0000000000000000
 x21: 0000000000000000

x20: 0000000000000000
 x19: ffff0000c70eb000
 x18: 000000000000036d

x17: ffff80000c15d8bc
 x16: ffff80000dd86118
 x15: ffff0000c60dce00

x14: 0000000000000110
 x13: 00000000ffffffff
 x12: ffff0000c60dce00

x11: ff808000095945e8
 x10: 0000000000000000
 x9 : ffff8000095945e8

x8 : ffff0000c60dce00
 x7 : ffff80000c1090e0
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
irq event stamp: 623186
hardirqs last  enabled at (623185): [<ffff80000c1238f8>] __raw_spin_unlock_irq include/linux/spinlock_api_smp.h:159 [inline]
hardirqs last  enabled at (623185): [<ffff80000c1238f8>] _raw_spin_unlock_irq+0x3c/0x70 kernel/locking/spinlock.c:202
hardirqs last disabled at (623186): [<ffff80000c110630>] el1_dbg+0x24/0x80 arch/arm64/kernel/entry-common.c:405
softirqs last  enabled at (623164): [<ffff80000bd93034>] spin_unlock_bh include/linux/spinlock.h:395 [inline]
softirqs last  enabled at (623164): [<ffff80000bd93034>] ieee80211_ibss_work+0x184/0x9f0 net/mac80211/ibss.c:1701
softirqs last disabled at (623162): [<ffff80000bd92f18>] spin_lock_bh include/linux/spinlock.h:355 [inline]
softirqs last disabled at (623162): [<ffff80000bd92f18>] ieee80211_ibss_work+0x68/0x9f0 net/mac80211/ibss.c:1690
---[ end trace 0000000000000000 ]---


Tested on:

commit:         0af4af97 io_uring/poll: add hash if ready poll request..
git tree:       git://git.kernel.dk/linux.git syztest
console output: https://syzkaller.appspot.com/x/log.txt?x=1415a902480000
kernel config:  https://syzkaller.appspot.com/x/.config?x=965a23481ff8fa50
dashboard link: https://syzkaller.appspot.com/bug?extid=6805087452d72929404e
compiler:       Debian clang version 13.0.1-++20220126092033+75e33f71c2da-1~exp1~20220126212112.63, GNU ld (GNU Binutils for Debian) 2.35.2
userspace arch: arm64

Note: no patches were applied.
