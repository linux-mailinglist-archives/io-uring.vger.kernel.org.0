Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E47696774C8
	for <lists+io-uring@lfdr.de>; Mon, 23 Jan 2023 06:16:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbjAWFQn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 23 Jan 2023 00:16:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbjAWFQm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 23 Jan 2023 00:16:42 -0500
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4F1218A91
        for <io-uring@vger.kernel.org>; Sun, 22 Jan 2023 21:16:40 -0800 (PST)
Received: by mail-il1-f200.google.com with SMTP id o10-20020a056e02102a00b003006328df7bso7674808ilj.17
        for <io-uring@vger.kernel.org>; Sun, 22 Jan 2023 21:16:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nUw1aAdRjUAdHmyJY7wAMUE1oHuNao0Sr9sDriC9qfM=;
        b=6+OLnWpk+HZFMXI5MkWspX/aD6Qv3OLlv4HLWyRK/5b7aO+063Y+FSVGovPisk1tOJ
         13PmQmka41NEx3nUmoL5MExHS5OdwcmEwPYe8bITHOEaRDTB/PwdRUP8gNKE7WXbFxxI
         AXOvU7umEgvIhErJDSH/i52Z5tYNjRhSktfq+FD8ANh80dWN8lAiQToRGWUb01BvmZ9+
         8E4E7LmnUsw2iOgpqxyvHMA2LPmi8UaBMpG+Ia79qofP+TlsPuvvsfCyIa8A9j6VENW/
         c5wyPgQQXxKbL4m7hZ6IJEd76LmWkYiW/44qmqWcBzj0NqJARgfQQ6YduaGV3JG0wh7K
         L/Rw==
X-Gm-Message-State: AFqh2kqidY5Rr/FJRcRnvKlFPIaPwsUbC1HzN7U5qZhGaC3K5N0ky7jl
        v1SMMqUagcrQEyoDH48q6GCsF0PJJl0wUAlhPcepHXsRkU5z
X-Google-Smtp-Source: AMrXdXujfymYL22Rpds+l3PLO6tYWUloJf/X1IcIh2Rb2cPUZGGNUNB8wQiVjSNdVqZ44GaD2UHzwq2j3Z4D6Ns4N8oi5Fc6EruZ
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1025:b0:30f:6222:c5e6 with SMTP id
 o5-20020a056e02102500b0030f6222c5e6mr782247ilj.107.1674450999917; Sun, 22 Jan
 2023 21:16:39 -0800 (PST)
Date:   Sun, 22 Jan 2023 21:16:39 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000000b45a105f2e781db@google.com>
Subject: [syzbot] WARNING in io_get_cqe_overflow
From:   syzbot <syzbot+200ab9a0f030458682a9@syzkaller.appspotmail.com>
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

HEAD commit:    edb2f0dc90f2 Merge branch 'for-next/core' into for-kernelci
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=11cb0589480000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a1c301efa2b11613
dashboard link: https://syzkaller.appspot.com/bug?extid=200ab9a0f030458682a9
compiler:       Debian clang version 13.0.1-++20220126092033+75e33f71c2da-1~exp1~20220126212112.63, GNU ld (GNU Binutils for Debian) 2.35.2
userspace arch: arm64

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/ca1677dc6969/disk-edb2f0dc.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/22527595a2dd/vmlinux-edb2f0dc.xz
kernel image: https://storage.googleapis.com/syzbot-assets/45308e5f6962/Image-edb2f0dc.gz.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+200ab9a0f030458682a9@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 1 PID: 8481 at io_uring/io_uring.h:108 io_get_cqe_overflow+0x1c4/0x1f0 io_uring/io_uring.h:108
Modules linked in:
CPU: 1 PID: 8481 Comm: syz-executor.2 Not tainted 6.2.0-rc4-syzkaller-16807-gedb2f0dc90f2 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : io_get_cqe_overflow+0x1c4/0x1f0 io_uring/io_uring.h:108
lr : io_get_cqe_overflow+0x1c4/0x1f0 io_uring/io_uring.h:108
sp : ffff800013cfbb70
x29: ffff800013cfbb70 x28: ffff000119bb0778 x27: 0000000000000000
x26: ffff000119b53400 x25: 0000000000000001 x24: 0000000000000801
x23: 0000000000000000 x22: 0000000000000000 x21: 0000000000000000
x20: 0000000000000000 x19: ffff00012219e000 x18: 0000000000000000
x17: 0000000000000000 x16: ffff80000dd97118 x15: ffff000119b53400
x14: 0000000000000100 x13: 00000000ffffffff x12: 0000000000040000
x11: 000000000000129a x10: ffff800017e49000 x9 : ffff80000959f4d8
x8 : 000000000000129b x7 : ffff8000095986e8 x6 : 0000000000000000
x5 : 0000000000000000 x4 : 0000000000000001 x3 : ffff80000cd89cfd
x2 : 0000000000000001 x1 : 0000000000000000 x0 : 0000000000000000
Call trace:
 io_get_cqe_overflow+0x1c4/0x1f0 io_uring/io_uring.h:108
 io_get_cqe io_uring/io_uring.h:125 [inline]
 io_fill_cqe_aux io_uring/io_uring.c:832 [inline]
 __io_post_aux_cqe+0x58/0x190 io_uring/io_uring.c:880
 io_post_aux_cqe+0x40/0x58 io_uring/io_uring.c:890
 io_msg_ring_data+0x104/0x164 io_uring/msg_ring.c:74
 io_msg_ring+0x8c/0x2cc io_uring/msg_ring.c:227
 io_issue_sqe+0x1c4/0x518 io_uring/io_uring.c:1856
 io_queue_sqe io_uring/io_uring.c:2028 [inline]
 io_submit_sqe io_uring/io_uring.c:2286 [inline]
 io_submit_sqes+0x18c/0x454 io_uring/io_uring.c:2397
 __do_sys_io_uring_enter+0x168/0x9ac io_uring/io_uring.c:3345
 __se_sys_io_uring_enter io_uring/io_uring.c:3277 [inline]
 __arm64_sys_io_uring_enter+0x30/0x40 io_uring/io_uring.c:3277
 __invoke_syscall arch/arm64/kernel/syscall.c:38 [inline]
 invoke_syscall arch/arm64/kernel/syscall.c:52 [inline]
 el0_svc_common+0x138/0x220 arch/arm64/kernel/syscall.c:142
 do_el0_svc+0x48/0x104 arch/arm64/kernel/syscall.c:193
 el0_svc+0x58/0x150 arch/arm64/kernel/entry-common.c:637
 el0t_64_sync_handler+0x84/0xf0 arch/arm64/kernel/entry-common.c:655
 el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:584
irq event stamp: 662
hardirqs last  enabled at (661): [<ffff800008589058>] mod_objcg_state+0x19c/0x204 mm/memcontrol.c:3220
hardirqs last disabled at (662): [<ffff80000c118a7c>] el1_dbg+0x24/0x80 arch/arm64/kernel/entry-common.c:405
softirqs last  enabled at (612): [<ffff80000801c9f4>] local_bh_enable+0x10/0x34 include/linux/bottom_half.h:32
softirqs last disabled at (610): [<ffff80000801c9c0>] local_bh_disable+0x10/0x34 include/linux/bottom_half.h:19
---[ end trace 0000000000000000 ]---
------------[ cut here ]------------
WARNING: CPU: 0 PID: 8481 at io_uring/io_uring.h:108 io_get_cqe_overflow+0x1c4/0x1f0 io_uring/io_uring.h:108
Modules linked in:
CPU: 0 PID: 8481 Comm: syz-executor.2 Tainted: G        W          6.2.0-rc4-syzkaller-16807-gedb2f0dc90f2 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : io_get_cqe_overflow+0x1c4/0x1f0 io_uring/io_uring.h:108
lr : io_get_cqe_overflow+0x1c4/0x1f0 io_uring/io_uring.h:108
sp : ffff800013cfbb70
x29: ffff800013cfbb70 x28: ffff000129dd9478 x27: 0000000000000000
x26: ffff000119b53400 x25: 0000000000000001 x24: 0000000000000801
x23: 0000000000000000 x22: 0000000000000000 x21: 0000000000000000
x20: 0000000000000000 x19: ffff00012219e000 x18: 00000000000003fd
x17: ffff80000c16e8bc x16: ffff80000dd97118 x15: ffff000119b53400
x14: 0000000000000100 x13: 00000000ffffffff x12: 0000000000040000
x11: 000000000001dfc0 x10: ffff800017e49000 x9 : ffff80000959f4d8
x8 : 000000000001dfc1 x7 : ffff8000095986e8 x6 : 0000000000000000
x5 : 0000000000000000 x4 : 0000000000000001 x3 : 0000000000000000
x2 : 0000000000000001 x1 : 0000000000000000 x0 : 0000000000000000
Call trace:
 io_get_cqe_overflow+0x1c4/0x1f0 io_uring/io_uring.h:108
 io_get_cqe io_uring/io_uring.h:125 [inline]
 io_fill_cqe_aux io_uring/io_uring.c:832 [inline]
 __io_post_aux_cqe+0x58/0x190 io_uring/io_uring.c:880
 io_post_aux_cqe+0x40/0x58 io_uring/io_uring.c:890
 io_msg_ring_data+0x104/0x164 io_uring/msg_ring.c:74
 io_msg_ring+0x8c/0x2cc io_uring/msg_ring.c:227
 io_issue_sqe+0x1c4/0x518 io_uring/io_uring.c:1856
 io_queue_sqe io_uring/io_uring.c:2028 [inline]
 io_submit_sqe io_uring/io_uring.c:2286 [inline]
 io_submit_sqes+0x18c/0x454 io_uring/io_uring.c:2397
 __do_sys_io_uring_enter+0x168/0x9ac io_uring/io_uring.c:3345
 __se_sys_io_uring_enter io_uring/io_uring.c:3277 [inline]
 __arm64_sys_io_uring_enter+0x30/0x40 io_uring/io_uring.c:3277
 __invoke_syscall arch/arm64/kernel/syscall.c:38 [inline]
 invoke_syscall arch/arm64/kernel/syscall.c:52 [inline]
 el0_svc_common+0x138/0x220 arch/arm64/kernel/syscall.c:142
 do_el0_svc+0x48/0x104 arch/arm64/kernel/syscall.c:193
 el0_svc+0x58/0x150 arch/arm64/kernel/entry-common.c:637
 el0t_64_sync_handler+0x84/0xf0 arch/arm64/kernel/entry-common.c:655
 el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:584
irq event stamp: 892
hardirqs last  enabled at (891): [<ffff80000816eb44>] raw_spin_rq_unlock_irq kernel/sched/sched.h:1370 [inline]
hardirqs last  enabled at (891): [<ffff80000816eb44>] finish_lock_switch+0x94/0xe8 kernel/sched/core.c:5052
hardirqs last disabled at (892): [<ffff80000c118a7c>] el1_dbg+0x24/0x80 arch/arm64/kernel/entry-common.c:405
softirqs last  enabled at (888): [<ffff8000080102e4>] _stext+0x2e4/0x37c
softirqs last disabled at (665): [<ffff800008017c88>] ____do_softirq+0x14/0x20 arch/arm64/kernel/irq.c:80
---[ end trace 0000000000000000 ]---
------------[ cut here ]------------
WARNING: CPU: 1 PID: 8481 at io_uring/io_uring.h:108 io_get_cqe_overflow+0x1c4/0x1f0 io_uring/io_uring.h:108
Modules linked in:
CPU: 1 PID: 8481 Comm: syz-executor.2 Tainted: G        W          6.2.0-rc4-syzkaller-16807-gedb2f0dc90f2 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : io_get_cqe_overflow+0x1c4/0x1f0 io_uring/io_uring.h:108
lr : io_get_cqe_overflow+0x1c4/0x1f0 io_uring/io_uring.h:108
sp : ffff800013cfbb70
x29: ffff800013cfbb70 x28: ffff000129dd9f78 x27: 0000000000000000
x26: ffff000119b53400 x25: 0000000000000001 x24: 0000000000000801
x23: 0000000000000000 x22: 0000000000000000 x21: 0000000000000000
x20: 0000000000000000 x19: ffff00012219e000 x18: 000000000000035a
x17: 0000000000000000 x16: ffff80000dd97118 x15: ffff000119b53400
x14: 0000000000000100 x13: 00000000ffffffff x12: 0000000000040000
x11: 00000000000399ac x10: ffff800017e49000 x9 : ffff80000959f4d8
x8 : 00000000000399ad x7 : ffff8000095986e8 x6 : 0000000000000000
x5 : 0000000000000000 x4 : 0000000000000001 x3 : 0000000000000000
x2 : 0000000000000001 x1 : 0000000000000000 x0 : 0000000000000000
Call trace:
 io_get_cqe_overflow+0x1c4/0x1f0 io_uring/io_uring.h:108
 io_get_cqe io_uring/io_uring.h:125 [inline]
 io_fill_cqe_aux io_uring/io_uring.c:832 [inline]
 __io_post_aux_cqe+0x58/0x190 io_uring/io_uring.c:880
 io_post_aux_cqe+0x40/0x58 io_uring/io_uring.c:890
 io_msg_ring_data+0x104/0x164 io_uring/msg_ring.c:74
 io_msg_ring+0x8c/0x2cc io_uring/msg_ring.c:227
 io_issue_sqe+0x1c4/0x518 io_uring/io_uring.c:1856
 io_queue_sqe io_uring/io_uring.c:2028 [inline]
 io_submit_sqe io_uring/io_uring.c:2286 [inline]
 io_submit_sqes+0x18c/0x454 io_uring/io_uring.c:2397
 __do_sys_io_uring_enter+0x168/0x9ac io_uring/io_uring.c:3345
 __se_sys_io_uring_enter io_uring/io_uring.c:3277 [inline]
 __arm64_sys_io_uring_enter+0x30/0x40 io_uring/io_uring.c:3277
 __invoke_syscall arch/arm64/kernel/syscall.c:38 [inline]
 invoke_syscall arch/arm64/kernel/syscall.c:52 [inline]
 el0_svc_common+0x138/0x220 arch/arm64/kernel/syscall.c:142
 do_el0_svc+0x48/0x104 arch/arm64/kernel/syscall.c:193
 el0_svc+0x58/0x150 arch/arm64/kernel/entry-common.c:637
 el0t_64_sync_handler+0x84/0xf0 arch/arm64/kernel/entry-common.c:655
 el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:584
irq event stamp: 974
hardirqs last  enabled at (973): [<ffff80000816eb44>] raw_spin_rq_unlock_irq kernel/sched/sched.h:1370 [inline]
hardirqs last  enabled at (973): [<ffff80000816eb44>] finish_lock_switch+0x94/0xe8 kernel/sched/core.c:5052
hardirqs last disabled at (974): [<ffff80000c118a7c>] el1_dbg+0x24/0x80 arch/arm64/kernel/entry-common.c:405
softirqs last  enabled at (970): [<ffff8000080102e4>] _stext+0x2e4/0x37c
softirqs last disabled at (895): [<ffff800008017c88>] ____do_softirq+0x14/0x20 arch/arm64/kernel/irq.c:80
---[ end trace 0000000000000000 ]---
------------[ cut here ]------------
WARNING: CPU: 1 PID: 8481 at io_uring/io_uring.h:108 io_get_cqe_overflow+0x1c4/0x1f0 io_uring/io_uring.h:108
Modules linked in:
CPU: 1 PID: 8481 Comm: syz-executor.2 Tainted: G        W          6.2.0-rc4-syzkaller-16807-gedb2f0dc90f2 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
pstate: 60400005 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : io_get_cqe_overflow+0x1c4/0x1f0 io_uring/io_uring.h:108
lr : io_get_cqe_overflow+0x1c4/0x1f0 io_uring/io_uring.h:108
sp : ffff800013cfbb70
x29: ffff800013cfbb70 x28: ffff000129dd9d78 x27: 0000000000000000
x26: ffff000119b53400 x25: 0000000000000001 x24: 0000000000000801
x23: 0000000000000000 x22: 0000000000000000 x21: 0000000000000000
x20: 0000000000000000 x19: ffff00012219e000 x18: 000000000000ba7e
x17: ffff80000c16e8bc x16: ffff80000dd97118 x15: ffff000119b53400
x14: 0000000000000100 x13: 00000000ffffffff x12: 0000000000040000
x11: 000000000003ffff x10: ffff800017e49000 x9 : ffff80000959f4d8
x8 : 0000000000040000 x7 : ffff8000095986e8 x6 : 0000000000000000
x5 : 0000000000000000 x4 : 0000000000000001 x3 : 0000000000000000
x2 : 0000000000000001 x1 : 0000000000000000 x0 : 0000000000000000
Call trace:
 io_get_cqe_overflow+0x1c4/0x1f0 io_uring/io_uring.h:108
 io_get_cqe io_uring/io_uring.h:125 [inline]
 io_fill_cqe_aux io_uring/io_uring.c:832 [inline]
 __io_post_aux_cqe+0x58/0x190 io_uring/io_uring.c:880
 io_post_aux_cqe+0x40/0x58 io_uring/io_uring.c:890
 io_msg_ring_data+0x104/0x164 io_uring/msg_ring.c:74
 io_msg_ring+0x8c/0x2cc io_uring/msg_ring.c:227
 io_issue_sqe+0x1c4/0x518 io_uring/io_uring.c:1856
 io_queue_sqe io_uring/io_uring.c:2028 [inline]
 io_submit_sqe io_uring/io_uring.c:2286 [inline]
 io_submit_sqes+0x18c/0x454 io_uring/io_uring.c:2397
 __do_sys_io_uring_enter+0x168/0x9ac io_uring/io_uring.c:3345
 __se_sys_io_uring_enter io_uring/io_uring.c:3277 [inline]
 __arm64_sys_io_uring_enter+0x30/0x40 io_uring/io_uring.c:3277
 __invoke_syscall arch/arm64/kernel/syscall.c:38 [inline]
 invoke_syscall arch/arm64/kernel/syscall.c:52 [inline]
 el0_svc_common+0x138/0x220 arch/arm64/kernel/syscall.c:142
 do_el0_svc+0x48/0x104 arch/arm64/kernel/syscall.c:193
 el0_svc+0x58/0x150 arch/arm64/kernel/entry-common.c:637
 el0t_64_sync_handler+0x84/0xf0 arch/arm64/kernel/entry-common.c:655
 el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:584
irq event stamp: 1012
hardirqs last  enabled at (1011): [<ffff80000816eb44>] raw_spin_rq_unlock_irq kernel/sched/sched.h:1370 [inline]
hardirqs last  enabled at (1011): [<ffff80000816eb44>] finish_lock_switch+0x94/0xe8 kernel/sched/core.c:5052
hardirqs last disabled at (1012): [<ffff80000c118a7c>] el1_dbg+0x24/0x80 arch/arm64/kernel/entry-common.c:405
softirqs last  enabled at (1008): [<ffff8000080102e4>] _stext+0x2e4/0x37c
softirqs last disabled at (977): [<ffff800008017c88>] ____do_softirq+0x14/0x20 arch/arm64/kernel/irq.c:80
---[ end trace 0000000000000000 ]---
------------[ cut here ]------------
WARNING: CPU: 1 PID: 8481 at io_uring/io_uring.h:108 io_get_cqe_overflow+0x1c4/0x1f0 io_uring/io_uring.h:108
Modules linked in:
CPU: 1 PID: 8481 Comm: syz-executor.2 Tainted: G        W          6.2.0-rc4-syzkaller-16807-gedb2f0dc90f2 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
pstate: 60400005 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : io_get_cqe_overflow+0x1c4/0x1f0 io_uring/io_uring.h:108
lr : io_get_cqe_overflow+0x1c4/0x1f0 io_uring/io_uring.h:108
sp : ffff800013cfbb70
x29: ffff800013cfbb70 x28: ffff000129dd9e78 x27: 0000000000000000
x26: ffff000119b53400 x25: 0000000000000001 x24: 0000000000000801
x23: 0000000000000000 x22: 0000000000000000 x21: 0000000000000000
x20: 0000000000000000 x19: ffff00012219e000 x18: 000000000000ba7e
x17: ffff80000c16e8bc x16: ffff80000dd97118 x15: ffff000119b53400
x14: 0000000000000100 x13: 00000000ffffffff x12: 0000000000040000
x11: 000000000003ffff x10: ffff800017e49000 x9 : ffff80000959f4d8
x8 : 0000000000040000 x7 : ffff8000095986e8 x6 : 0000000000000000
x5 : 0000000000000000 x4 : 0000000000000001 x3 : 0000000000000000
x2 : 0000000000000001 x1 : 0000000000000000 x0 : 0000000000000000
Call trace:
 io_get_cqe_overflow+0x1c4/0x1f0 io_uring/io_uring.h:108
 io_get_cqe io_uring/io_uring.h:125 [inline]
 io_fill_cqe_aux io_uring/io_uring.c:832 [inline]
 __io_post_aux_cqe+0x58/0x190 io_uring/io_uring.c:880
 io_post_aux_cqe+0x40/0x58 io_uring/io_uring.c:890
 io_msg_ring_data+0x104/0x164 io_uring/msg_ring.c:74
 io_msg_ring+0x8c/0x2cc io_uring/msg_ring.c:227
 io_issue_sqe+0x1c4/0x518 io_uring/io_uring.c:1856
 io_queue_sqe io_uring/io_uring.c:2028 [inline]
 io_submit_sqe io_uring/io_uring.c:2286 [inline]
 io_submit_sqes+0x18c/0x454 io_uring/io_uring.c:2397
 __do_sys_io_uring_enter+0x168/0x9ac io_uring/io_uring.c:3345
 __se_sys_io_uring_enter io_uring/io_uring.c:3277 [inline]
 __arm64_sys_io_uring_enter+0x30/0x40 io_uring/io_uring.c:3277
 __invoke_syscall arch/arm64/kernel/syscall.c:38 [inline]
 invoke_syscall arch/arm64/kernel/syscall.c:52 [inline]
 el0_svc_common+0x138/0x220 arch/arm64/kernel/syscall.c:142
 do_el0_svc+0x48/0x104 arch/arm64/kernel/syscall.c:193
 el0_svc+0x58/0x150 arch/arm64/kernel/entry-common.c:637
 el0t_64_sync_handler+0x84/0xf0 arch/arm64/kernel/entry-common.c:655
 el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:584
irq event stamp: 1220
hardirqs last  enabled at (1219): [<ffff80000816eb44>] raw_spin_rq_unlock_irq kernel/sched/sched.h:1370 [inline]
hardirqs last  enabled at (1219): [<ffff80000816eb44>] finish_lock_switch+0x94/0xe8 kernel/sched/core.c:5052
hardirqs last disabled at (1220): [<ffff80000c118a7c>] el1_dbg+0x24/0x80 arch/arm64/kernel/entry-common.c:405
softirqs last  enabled at (1216): [<ffff8000080102e4>] _stext+0x2e4/0x37c
softirqs last disabled at (1015): [<ffff800008017c88>] ____do_softirq+0x14/0x20 arch/arm64/kernel/irq.c:80
---[ end trace 0000000000000000 ]---


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
