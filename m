Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDF60403443
	for <lists+io-uring@lfdr.de>; Wed,  8 Sep 2021 08:29:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347650AbhIHGab (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Sep 2021 02:30:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236202AbhIHGaa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Sep 2021 02:30:30 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA9AAC061575;
        Tue,  7 Sep 2021 23:29:22 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id g13-20020a17090a3c8d00b00196286963b9so699456pjc.3;
        Tue, 07 Sep 2021 23:29:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=rOgArrul8Nce0Q7e8Vvqqh63DhsGUwueNDjefCyxA9Q=;
        b=kDKXXDSKrZ3DhzNrJrnqssd3WPYXj/lGPYf5TBQ+ms0hvaRcWhnPAoZ9h21J8C4403
         sacNGXW4l6/70gs6IQZyJ9H2fmHL+OLNYL85XMTMzfx450K1XNlBfTD5x4V7zLlDX0XK
         Z4zScs/A9eT/xs2iKNvDH7j4pyYM/hWxQOq2XCLA8UozrF+11KBMZGtNJtdIcyI4e2/F
         7SftMcY+1JdT+u/pKh2mkRrSyv0ISvmxm3/ykt1FhrvQHavmrmJO1f/+XlucT4axhXnM
         MgP9lTiIuBa9c9qEY4B2nrv8otDae2fnXbsgc8RlV3wHmpA9/6wcnoVN/VQO27+/DOCj
         ta2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=rOgArrul8Nce0Q7e8Vvqqh63DhsGUwueNDjefCyxA9Q=;
        b=ILaFtmY1QDCqz7PM6ToqLoL5nluuYaMHn404Exyjo21zjX7LgRC9FgB+W0pIjqJIwu
         qAeiyYsmWzJRVMRIfxasD8CMH7Wz/Glkx/g2MBR40TqPkXoZGTK9uRG2FxUqRBC4Fkd+
         ljiaryKMJbLQ3vgEkyf7T/o7QiSPiM/KARfZCrGDOpguK3iThDGitYsgv+1n8l6CG9bz
         P2LkdA5h6JJUdUaAuyVttJR/ttotSh5EM5kgdaV41yspAl/BgA9tcc0ZIz7b21BnOI33
         3jrYi+VOUkTiPL/Ab+DfclBRDIn/LskXb6cl+LxGAClXWSE+Jv/IU3+aei2MHhgxO9va
         mVSA==
X-Gm-Message-State: AOAM531U+u9xmh8JetIi+WreTinUL94zTNTsOryixksahfnVSTq4HLbP
        3qtTPsGT/cUp1nVwmXf9IzfsY+OR2gMzAaQ2/xXT816cSync
X-Google-Smtp-Source: ABdhPJyCbwKUxlmlzGfHI6ksQzmJ+Tf0biQlbJ4CjcyUKCcH8nz1Po59FHCGjDHcvaRYglXKOMEUSHMcocOk4dpJL5Y=
X-Received: by 2002:a17:90b:124c:: with SMTP id gx12mr2440991pjb.106.1631082562278;
 Tue, 07 Sep 2021 23:29:22 -0700 (PDT)
MIME-Version: 1.0
From:   Hao Sun <sunhao.th@gmail.com>
Date:   Wed, 8 Sep 2021 14:29:11 +0800
Message-ID: <CACkBjsauGR5r8YEEp-j3VtVucz72ser1rZVZSrAw_ap-EJRGPg@mail.gmail.com>
Subject: WARNING in io_req_complete_post
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
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
https://drive.google.com/file/d/1Hvkzo710Vli_7jWgdBV8ClUcC4U7agZF/view?usp=sharing
kernel config: https://drive.google.com/file/d/1c0u2EeRDhRO-ZCxr9MP2VvAtJd6kfg-p/view?usp=sharing
C reproducer: https://drive.google.com/file/d/11lWS0MzNVzXpGOC58UD-YGro__PbzdhB/view?usp=sharing
Syzlang reproducer:
https://drive.google.com/file/d/1U1W85GSVcOOaTNmoyDmpSwADAGNB0QsJ/view?usp=sharing

If you fix this issue, please add the following tag to the commit:
Reported-by: Hao Sun <sunhao.th@gmail.com>

FAULT_INJECTION: forcing a failure.
name failslab, interval 1, probability 0, space 0, times 0
CPU: 0 PID: 10392 Comm: syz-executor Not tainted 5.14.0+ #1
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
 io_submit_sqe fs/io_uring.c:7127 [inline]
 io_submit_sqes+0x2082/0x9c00 fs/io_uring.c:7233
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
RSP: 002b:00007f8a08c68c58 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
RAX: ffffffffffffffda RBX: 000000000059c0a0 RCX: 00000000004739cd
RDX: 0000000000000000 RSI: 000000000000450c RDI: 0000000000000003
RBP: 00007f8a08c68c90 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000004
R13: 00007ffc718b80af R14: 00007ffc718b8250 R15: 00007f8a08c68dc0
------------[ cut here ]------------
WARNING: CPU: 0 PID: 10392 at fs/io_uring.c:1151 req_ref_put_and_test
fs/io_uring.c:1151 [inline]
WARNING: CPU: 0 PID: 10392 at fs/io_uring.c:1151 req_ref_put_and_test
fs/io_uring.c:1146 [inline]
WARNING: CPU: 0 PID: 10392 at fs/io_uring.c:1151
io_req_complete_post+0xf5b/0x1190 fs/io_uring.c:1794
Modules linked in:
CPU: 0 PID: 10392 Comm: syz-executor Not tainted 5.14.0+ #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.13.0-1ubuntu1.1 04/01/2014
RIP: 0010:req_ref_put_and_test fs/io_uring.c:1151 [inline]
RIP: 0010:req_ref_put_and_test fs/io_uring.c:1146 [inline]
RIP: 0010:io_req_complete_post+0xf5b/0x1190 fs/io_uring.c:1794
Code: ff 48 c7 c2 80 d3 9a 89 be b0 02 00 00 48 c7 c7 e0 d3 9a 89 c6
05 f4 60 75 0b 01 e8 6f dc 0c 07 e9 7c fe ff ff e8 a5 4c 92 ff <0f> 0b
e9 b6 fb ff ff e8 99 4c 92 ff 49 8d 7d 58 31 c9 ba 01 00 00
RSP: 0018:ffffc9000e727d78 EFLAGS: 00010216
RAX: 0000000000036964 RBX: ffff88801797da40 RCX: 0000000000040000
RDX: ffffc900011d1000 RSI: ffff88810e0bd580 RDI: 0000000000000002
RBP: ffff88810d7ba000 R08: ffffffff81e3d39b R09: 000000000000007f
R10: 0000000000000005 R11: ffffed1002f2fb53 R12: ffff88810d7ba540
R13: ffff88801797da9c R14: 0000000000100000 R15: ffff88810d7ba640
FS:  00007f8a08c69700(0000) GS:ffff888063e00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000593ad4 CR3: 000000001f854000 CR4: 0000000000350ef0
Call Trace:
 tctx_task_work+0x1e5/0x570 fs/io_uring.c:2158
 task_work_run+0xe0/0x1a0 kernel/task_work.c:164
 tracehook_notify_signal include/linux/tracehook.h:212 [inline]
 handle_signal_work kernel/entry/common.c:146 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:172 [inline]
 exit_to_user_mode_prepare+0x232/0x2a0 kernel/entry/common.c:209
 __syscall_exit_to_user_mode_work kernel/entry/common.c:291 [inline]
 syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:302
 do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4739cd
Code: 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa 48 89 f8 48
89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f8a08c68c58 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
RAX: 0000000000000100 RBX: 000000000059c0a0 RCX: 00000000004739cd
RDX: 0000000000000000 RSI: 000000000000450c RDI: 0000000000000003
RBP: 00007f8a08c68c90 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000004
R13: 00007ffc718b80af R14: 00007ffc718b8250 R15: 00007f8a08c68dc0%
