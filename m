Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D4D040346B
	for <lists+io-uring@lfdr.de>; Wed,  8 Sep 2021 08:46:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347815AbhIHGrv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Sep 2021 02:47:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347783AbhIHGrt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Sep 2021 02:47:49 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15FCEC06175F;
        Tue,  7 Sep 2021 23:46:41 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id q22so1238556pfu.0;
        Tue, 07 Sep 2021 23:46:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=tPcz+2r5QYT3f31sjYhLKhxDJoI3LKZy65DdDOG+sHk=;
        b=nyBStD7Wwf69j9+s+sK3LvXqYugld0Sb938nk1neIAyHwFMJhTFvZpLwoQMmBZTafJ
         Alvhw/vrDBzgY7bADgHPCm+YVLVlUKaK/UTI/A9UGyI/zkUGNkkzg0/DxVsHvgAdRzNY
         5ngmhBuwk44ssVaDNbdz83tdlnG+T9smduh4Gtyeljf7zzL5HDgvIhEfzGHcgFObmiaV
         xsagqe56/yIMRE9SHPoxqJbClJLEvK5snehSQPsWji2d9RlfpjIWTCcZ4j+ZDGVT/PXE
         5rC5kdpZq6FBYS+CbxNphXHRlZXEZwEJvntMI+h4Lr6cObdN4Sw2d2af/njN4wjLnZbu
         l0Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=tPcz+2r5QYT3f31sjYhLKhxDJoI3LKZy65DdDOG+sHk=;
        b=fgMu0fawHSCmCT+7csLUIGcXrfsM3Ey1s0Z4Pgt9upqoAzuMlb62dD4zIt3dEi+YM1
         fvOvBzizRJfZ9A75CL3u2y6yyem9J5QonfXwBDu7IRhnKFa2ctDbOwpJiqDdR+LtIqWs
         pfKFeb4LBIIhG/q0ufLXrTHsFwIjqmr5AKvhKbrFxsTKq5ga7K+bMCsO5kVc6lgYgOUl
         vM2OOyLDa4JIHOI7ANCmWE2L8sN0he27W7dmBWuayXO5QR8+fu1naY6niPm3hR2X2XU3
         mr4JSe0VRgkzhYxb42AgpUKPXK5vzzrBiPsL3h+XnYwnlplXqOi7hbYRV+spUtYzmcY6
         5iRw==
X-Gm-Message-State: AOAM53249i3Lvtvk+6yJWW2h5PpX1KW4WCX+UMfLtM4xoTaFU9bT98x4
        tGIYrlPHsDNQlPkzdSmEwGfKRlXStNTKqG9E+g==
X-Google-Smtp-Source: ABdhPJwLSEKyQN5RxvuSRAMj06wbM008oHE7x9+ai+l4brmJit1iElcOKJ96hGRN9LJjH6CNO1ufXWDOoWqeV4MT5tU=
X-Received: by 2002:aa7:8747:0:b0:3f2:78f:977d with SMTP id
 g7-20020aa78747000000b003f2078f977dmr2061064pfo.59.1631083600477; Tue, 07 Sep
 2021 23:46:40 -0700 (PDT)
MIME-Version: 1.0
From:   Hao Sun <sunhao.th@gmail.com>
Date:   Wed, 8 Sep 2021 14:46:29 +0800
Message-ID: <CACkBjsa=DmomBxEub98ihEu0T37ryz+_4EQgGF1dURtTvdLEtQ@mail.gmail.com>
Subject: WARNING in io_wq_submit_work
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.co>,
        io-uring@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

When using Healer to fuzz the latest Linux kernel, the following crash
was triggered.

HEAD commit: 4b93c544e90e-thunderbolt: test: split up test cases
git tree: upstream
console output:
https://drive.google.com/file/d/1RZfBThifWgo2CiwPTeNzYG4P0gkZlINT/view?usp=sharing
kernel config: https://drive.google.com/file/d/1c0u2EeRDhRO-ZCxr9MP2VvAtJd6kfg-p/view?usp=sharing
C reproducer: https://drive.google.com/file/d/18LXBclar1FlOngPkayjq8k-vKcw-SR98/view?usp=sharing
Syzlang reproducer:
https://drive.google.com/file/d/1rUgX8kHPhxiYHIbuhZnDZknDe1DzDmhd/view?usp=sharing
Similar report:
https://groups.google.com/u/1/g/syzkaller-bugs/c/siEpifWtNAw/m/IkUK1DmOCgAJ

If you fix this issue, please add the following tag to the commit:
Reported-by: Hao Sun <sunhao.th@gmail.com>

FAULT_INJECTION: forcing a failure.
name failslab, interval 1, probability 0, space 0, times 0
CPU: 2 PID: 11607 Comm: syz-executor Not tainted 5.14.0+ #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.13.0-1ubuntu1.1 04/01/2014
Call Trace:
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:105
 fail_dump lib/fault-inject.c:52 [inline]
 should_fail.cold+0x5/0xa lib/fault-inject.c:146
 should_failslab+0x5/0x10 mm/slab_common.c:1326
 slab_pre_alloc_hook mm/slab.h:494 [inline]
 slab_alloc_node mm/slub.c:2880 [inline]
 kmem_cache_alloc_node+0x67/0x380 mm/slub.c:2995
 alloc_task_struct_node kernel/fork.c:171 [inline]
 dup_task_struct kernel/fork.c:883 [inline]
 copy_process+0x5df/0x73d0 kernel/fork.c:2027
 create_io_thread+0xb6/0xf0 kernel/fork.c:2533
 create_io_worker+0x25a/0x540 fs/io-wq.c:758
 io_wqe_create_worker fs/io-wq.c:267 [inline]
 io_wqe_enqueue+0x68c/0xba0 fs/io-wq.c:866
 io_queue_async_work+0x28b/0x5d0 fs/io_uring.c:1473
 __io_queue_sqe+0x6c3/0xc70 fs/io_uring.c:6933
 io_queue_sqe fs/io_uring.c:6951 [inline]
 io_submit_state_end fs/io_uring.c:7141 [inline]
 io_submit_sqes+0x1da4/0x9c00 fs/io_uring.c:7245
 __do_sys_io_uring_enter fs/io_uring.c:9875 [inline]
 __se_sys_io_uring_enter fs/io_uring.c:9817 [inline]
 __x64_sys_io_uring_enter+0x7a9/0xe80 fs/io_uring.c:9817
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4739cd
Code: 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa 48 89 f8 48
89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007eff5bd9dc58 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
RAX: ffffffffffffffda RBX: 000000000059c0a0 RCX: 00000000004739cd
RDX: 0000000000000000 RSI: 000000000000450c RDI: 0000000000000003
RBP: 00007eff5bd9dc90 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000002
R13: 00007ffc1b637edf R14: 00007ffc1b638080 R15: 00007eff5bd9ddc0
------------[ cut here ]------------
WARNING: CPU: 2 PID: 11607 at fs/io_uring.c:1164 req_ref_get
fs/io_uring.c:1164 [inline]
WARNING: CPU: 2 PID: 11607 at fs/io_uring.c:1164
io_wq_submit_work+0x2b4/0x310 fs/io_uring.c:6731
Modules linked in:
CPU: 2 PID: 11607 Comm: syz-executor Not tainted 5.14.0+ #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.13.0-1ubuntu1.1 04/01/2014
RIP: 0010:req_ref_get fs/io_uring.c:1164 [inline]
RIP: 0010:io_wq_submit_work+0x2b4/0x310 fs/io_uring.c:6731
Code: 49 89 c5 0f 84 5b fe ff ff e8 b8 14 91 ff 4c 89 ef e8 80 f3 ff
ff e9 49 fe ff ff e8 a6 14 91 ff e9 85 fe ff ff e8 9c 14 91 ff <0f> 0b
eb a7 4c 89 f7 e8 f0 93 d8 ff e9 79 fd ff ff 4c 89 ef e8 53
RSP: 0018:ffffc90009e4f868 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 000000000000007f RCX: ffff8881025b8000
RDX: 0000000000000000 RSI: ffff8881025b8000 RDI: 0000000000000002
RBP: ffff888025a43238 R08: ffffffff81e50ba4 R09: 000000000000007f
R10: 0000000000000005 R11: ffffed1004b4863b R12: ffff888025a43180
R13: ffff888025a431dc R14: ffff888025a431d8 R15: 0000000000100000
FS:  00007eff5bd9e700(0000) GS:ffff888063f00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000330ac48 CR3: 000000002ef85000 CR4: 0000000000350ee0
Call Trace:
 io_run_cancel fs/io-wq.c:809 [inline]
 io_acct_cancel_pending_work.isra.0+0x2c0/0x640 fs/io-wq.c:950
 io_wqe_cancel_pending_work+0x6c/0x130 fs/io-wq.c:968
 io_wq_destroy fs/io-wq.c:1185 [inline]
 io_wq_put_and_exit+0x78c/0xc10 fs/io-wq.c:1198
 io_uring_clean_tctx fs/io_uring.c:9607 [inline]
 io_uring_cancel_generic+0x5fe/0x740 fs/io_uring.c:9687
 io_uring_files_cancel include/linux/io_uring.h:16 [inline]
 do_exit+0x25c/0x2dd0 kernel/exit.c:780
 do_group_exit+0x125/0x340 kernel/exit.c:922
 get_signal+0x4d5/0x25a0 kernel/signal.c:2868
 arch_do_signal_or_restart+0x2ed/0x1c40 arch/x86/kernel/signal.c:865
 handle_signal_work kernel/entry/common.c:148 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:172 [inline]
 exit_to_user_mode_prepare+0x192/0x2a0 kernel/entry/common.c:209
 __syscall_exit_to_user_mode_work kernel/entry/common.c:291 [inline]
 syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:302
 do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4739cd
Code: 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa 48 89 f8 48
89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007eff5bd9dcd8 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
RAX: fffffffffffffe00 RBX: 000000000059c0a0 RCX: 00000000004739cd
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 000000000059c0a8
RBP: 000000000059c0a8 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000059c0ac
R13: 00007ffc1b637edf R14: 00007ffc1b638080 R15: 00007eff5bd9ddc0%
