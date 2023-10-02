Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F32387B55A5
	for <lists+io-uring@lfdr.de>; Mon,  2 Oct 2023 17:01:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237819AbjJBOiI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 2 Oct 2023 10:38:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237811AbjJBOiH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 2 Oct 2023 10:38:07 -0400
Received: from mail-ot1-f78.google.com (mail-ot1-f78.google.com [209.85.210.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0250BB4
        for <io-uring@vger.kernel.org>; Mon,  2 Oct 2023 07:38:03 -0700 (PDT)
Received: by mail-ot1-f78.google.com with SMTP id 46e09a7af769-6c65fe5e6f0so1166212a34.3
        for <io-uring@vger.kernel.org>; Mon, 02 Oct 2023 07:38:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696257482; x=1696862282;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cPvlpVCxggrsJ1ZuYlyGtFjY4Bpm1Ku4mYIQDej4bsU=;
        b=hu1R81CWHgK91Lf/AXJ0oKMH/5YZoeHc6V/bkTXNKj5qvh8KlLjGc7U1YGRqwonB9p
         3WvWg+ucCK125qR9C2elCgLBJ1Rh6b2QnRaHfdhupXwqcNfc+Ec91YeUt6itQZ9zzXOO
         fni0rUOdFFbyTcgwB1LaPR3oBV++qrKzw+bC+MPIfLl809vu5aeJTyKa8Jb4walJQJBS
         FPPTK7EU5yknZnDAmuJhr8H7MinibqWytAUntuvWmwMXPOw/Vhto8VsJ2jRzJRVQ4wK/
         IzYBVSh5n6PwhBI5O6cL2gv0PbjW+casV5MmwdwNs8bi5wXCmMblB/rNFl3l7HG4iBeJ
         Dihw==
X-Gm-Message-State: AOJu0YzYcmFoulB/y01sIbcbdVAXSSG1isE3F8HBwMENcDeqCegLsDf7
        DZ3EgNrmopRRSJi9N2xThTqXqo5stVFNrSTWNaD/l7mC0jd2
X-Google-Smtp-Source: AGHT+IEePAadETEB4lauvM++mLzQzXSkBVWcRYpGWu1P9iUEtnFYVlPBmC8JqrG9a0lGsyqGEYQioGdvJQJBRSYXbV36r0rd6TMQ
MIME-Version: 1.0
X-Received: by 2002:a05:6830:d7:b0:6c4:b847:cb9a with SMTP id
 x23-20020a05683000d700b006c4b847cb9amr3174297oto.0.1696257482382; Mon, 02 Oct
 2023 07:38:02 -0700 (PDT)
Date:   Mon, 02 Oct 2023 07:38:02 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000af635c0606bcb889@google.com>
Subject: [syzbot] [io-uring?] BUG: unable to handle kernel NULL pointer
 dereference in __io_remove_buffers (2)
From:   syzbot <syzbot+2113e61b8848fa7951d8@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    ec8c298121e3 Merge tag 'x86-urgent-2023-10-01' of git://gi..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16ef0ed6680000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3be743fa9361d5b0
dashboard link: https://syzkaller.appspot.com/bug?extid=2113e61b8848fa7951d8
compiler:       arm-linux-gnueabi-gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: arm

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/8ead8862021c/non_bootable_disk-ec8c2981.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/e19aa754d61c/vmlinux-ec8c2981.xz
kernel image: https://storage.googleapis.com/syzbot-assets/709e546bab85/zImage-ec8c2981.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+2113e61b8848fa7951d8@syzkaller.appspotmail.com

8<--- cut here ---
Unable to handle kernel NULL pointer dereference at virtual address 0000000e when read
[0000000e] *pgd=80000080004003, *pmd=00000000
Internal error: Oops: 207 [#1] PREEMPT SMP ARM
Modules linked in:
CPU: 0 PID: 28152 Comm: kworker/u5:4 Not tainted 6.6.0-rc3-syzkaller #0
Hardware name: ARM-Versatile Express
Workqueue: events_unbound io_ring_exit_work
PC is at __io_remove_buffers io_uring/kbuf.c:219 [inline]
PC is at __io_remove_buffers+0x38/0x184 io_uring/kbuf.c:209
LR is at io_destroy_buffers+0x48/0x138 io_uring/kbuf.c:264
pc : [<807c966c>]    lr : [<807c9c28>]    psr: 20000013
sp : eab35e48  ip : eab35e78  fp : eab35e74
r10: 827e4691  r9 : 8b0de000  r8 : ffffffff
r7 : 8b0de34c  r6 : 00000001  r5 : 8b0dc800  r4 : 00000000
r3 : 00000000  r2 : 00000000  r1 : 8b0dc800  r0 : 8b0de000
Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
Control: 30c5387d  Table: 8be86780  DAC: fffffffd
Register r0 information: slab kmalloc-2k start 8b0de000 pointer offset 0 size 2048
Register r1 information: slab kmalloc-2k start 8b0dc800 pointer offset 0 size 2048
Register r2 information: NULL pointer
Register r3 information: NULL pointer
Register r4 information: NULL pointer
Register r5 information: slab kmalloc-2k start 8b0dc800 pointer offset 0 size 2048
Register r6 information: non-paged memory
Register r7 information: slab kmalloc-2k start 8b0de000 pointer offset 844 size 2048
Register r8 information: non-paged memory
Register r9 information: slab kmalloc-2k start 8b0de000 pointer offset 0 size 2048
Register r10 information: non-slab/vmalloc memory
Register r11 information: 2-page vmalloc region starting at 0xeab34000 allocated at kernel_clone+0xac/0x424 kernel/fork.c:2909
Register r12 information: 2-page vmalloc region starting at 0xeab34000 allocated at kernel_clone+0xac/0x424 kernel/fork.c:2909
Process kworker/u5:4 (pid: 28152, stack limit = 0xeab34000)
Stack: (0xeab35e48 to 0xeab36000)
5e40:                   8bce69c0 00000014 8b0de000 8b0de040 8b0de34c 82604d40
5e60: 8b0de3cc 827e4691 eab35e9c eab35e78 807c9c28 807c9640 00000000 6ae810d6
5e80: 8b0de3bc 8b0de000 8b0de040 8b0de34c eab35f04 eab35ea0 818264d0 807c9bec
5ea0: eab35ebc 8b0de3cc 00079ebb 8b0de000 00000000 00000000 00000000 81825000
5ec0: 00000000 00030003 eab35ec8 eab35ec8 8b0de000 6ae810d6 eab35f48 8be74900
5ee0: 8b0de3bc 82c21400 82c0f000 00000140 8bce69c0 82c21405 eab35f44 eab35f08
5f00: 80265fd4 81826134 eab35f2c eab35f18 eab35f44 eab35f20 8026196c 8be74900
5f20: 8be7492c 82c0f000 82604d40 82c0f020 8bce69c0 61c88647 eab35f84 eab35f48
5f40: 80266520 80265e44 eab35f64 eab35f58 81847bb0 80278e68 eab35f84 8a4e0180
5f60: 8bce69c0 802662e0 8be74900 8b121ac0 e04f5e98 00000000 eab35fac eab35f88
5f80: 8026d8e0 802662ec 8a4e0180 8026d7dc 00000000 00000000 00000000 00000000
5fa0: 00000000 eab35fb0 80200104 8026d7e8 00000000 00000000 00000000 00000000
5fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
5fe0: 00000000 00000000 00000000 00000000 00000013 00000000 00000000 00000000
Backtrace: 
[<807c9634>] (__io_remove_buffers) from [<807c9c28>] (io_destroy_buffers+0x48/0x138 io_uring/kbuf.c:264)
 r10:827e4691 r9:8b0de3cc r8:82604d40 r7:8b0de34c r6:8b0de040 r5:8b0de000
 r4:00000014 r3:8bce69c0
[<807c9be0>] (io_destroy_buffers) from [<818264d0>] (io_ring_ctx_free io_uring/io_uring.c:2895 [inline])
[<807c9be0>] (io_destroy_buffers) from [<818264d0>] (io_ring_exit_work+0x3a8/0x5ec io_uring/io_uring.c:3151)
 r7:8b0de34c r6:8b0de040 r5:8b0de000 r4:8b0de3bc
[<81826128>] (io_ring_exit_work) from [<80265fd4>] (process_one_work+0x19c/0x4a8 kernel/workqueue.c:2630)
 r10:82c21405 r9:8bce69c0 r8:00000140 r7:82c0f000 r6:82c21400 r5:8b0de3bc
 r4:8be74900
[<80265e38>] (process_one_work) from [<80266520>] (process_scheduled_works kernel/workqueue.c:2703 [inline])
[<80265e38>] (process_one_work) from [<80266520>] (worker_thread+0x240/0x48c kernel/workqueue.c:2784)
 r10:61c88647 r9:8bce69c0 r8:82c0f020 r7:82604d40 r6:82c0f000 r5:8be7492c
 r4:8be74900
[<802662e0>] (worker_thread) from [<8026d8e0>] (kthread+0x104/0x134 kernel/kthread.c:388)
 r10:00000000 r9:e04f5e98 r8:8b121ac0 r7:8be74900 r6:802662e0 r5:8bce69c0
 r4:8a4e0180
[<8026d7dc>] (kthread) from [<80200104>] (ret_from_fork+0x14/0x30 arch/arm/kernel/entry-common.S:134)
Exception stack(0xeab35fb0 to 0xeab35ff8)
5fa0:                                     00000000 00000000 00000000 00000000
5fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
5fe0: 00000000 00000000 00000000 00000000 00000013 00000000
 r9:00000000 r8:00000000 r7:00000000 r6:00000000 r5:8026d7dc r4:8a4e0180
Code: 0a000022 e5913004 e1d120be e5d14013 (e1d380be) 
---[ end trace 0000000000000000 ]---
----------------
Code disassembly (best guess):
   0:	0a000022 	beq	0x90
   4:	e5913004 	ldr	r3, [r1, #4]
   8:	e1d120be 	ldrh	r2, [r1, #14]
   c:	e5d14013 	ldrb	r4, [r1, #19]
* 10:	e1d380be 	ldrh	r8, [r3, #14] <-- trapping instruction


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the bug is already fixed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want to overwrite bug's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the bug is a duplicate of another bug, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
