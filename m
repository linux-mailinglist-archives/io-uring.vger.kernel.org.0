Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7176F32E120
	for <lists+io-uring@lfdr.de>; Fri,  5 Mar 2021 06:06:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229446AbhCEFGd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 5 Mar 2021 00:06:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229465AbhCEFGd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 5 Mar 2021 00:06:33 -0500
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D9EDC061574;
        Thu,  4 Mar 2021 21:06:33 -0800 (PST)
Received: by mail-lj1-x22d.google.com with SMTP id u4so1199211ljh.6;
        Thu, 04 Mar 2021 21:06:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=dvv4d17v0wrR1rzGcjfj08i43oOgXa86g/87JIiyQeg=;
        b=btxQoDBYRV7tvJzdxbrtQcgMR4/xu2Aqn0/vBIdEy3yu1meaK/ykwSVYpK4VwqAdmG
         Vc3ASsZK9zc2zhrQ4WA04RZVkH1cHtDx2H2NAijG/NTcRA7tVr0d8dXpET7VoDsrllkg
         MAPCITTmzh+2+ddicVgFxLSJGetlQiiFg2xzRLCtIdmqZyUNMTZznBcpIU5a70cHxhxr
         aavy0oc4WjLI7TRlbX5p2jiHhb6u1fJXatgoQ2SaxUv9wHaUCe38hK3gGroM0kWXnKNz
         AqWdhwrCuO6m2eZfIW8vvyva6n1d/w9dG/jaN1u7M6mbaO3gpIb31nJKE7RynutdVLN8
         LVnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=dvv4d17v0wrR1rzGcjfj08i43oOgXa86g/87JIiyQeg=;
        b=dXQN+lPfjY3ynwym9FHlQP/Rp7EYS4g52D3uBQJx8wI84jA04L24BWp/ZioiVQwj0b
         XWmxPyUOyevHYxrtyBkZxCZp0stBOHorY3+ul31nABLRm83l1ymS/Az3nsOHRaYIxjM9
         nJum8CAiyVViPMWEZW/vamA1mlwergv5P7jC9fZPjqrO6qwKOjuHF4hJ8yMIl8o4Dgb/
         MDr+YOaWjkvW9IgRg/gXmW8IluGf1jxFLk9Rp8/SEDwUEABOanMszFLInHH0XETkhD60
         Y8HURuiJy1HAz2WRNE3qcNV0gM25nnqJDUvIFtLGEAR6SNZT7t4NDJVi1HnMgUSJpozW
         8gZA==
X-Gm-Message-State: AOAM533spUG7JjcIHvb3IR4gu3nv2VR4h1EFOeNQw1suh9fWHbGE/fJ+
        t0AErsibF7V9RViUspL29IZofNo5Yo1rDR/FYEhXICI63N9IEA==
X-Google-Smtp-Source: ABdhPJzvTu7kL4B0kk10FHafsBuYKwVu5Fp0vJ2qEm1apRzvHewEQ+fcpanoLvD+nEBlTx0ji/a0ycM3uOOJC/t3lMI=
X-Received: by 2002:a2e:9195:: with SMTP id f21mr4095339ljg.340.1614920791278;
 Thu, 04 Mar 2021 21:06:31 -0800 (PST)
MIME-Version: 1.0
From:   Palash Oswal <oswalpalash@gmail.com>
Date:   Fri, 5 Mar 2021 10:36:19 +0530
Message-ID: <CAGyP=7eHKPdST4sVEKQZ9fZEhoT5MOMH2FZjzXVb6_SzSwGaAg@mail.gmail.com>
Subject: BUG: soft lockup in corrupted
To:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        axboe@kernel.dk, Hillf Danton <hdanton@sina.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

I was running syzkaller and I found the following issue :
Head Commit : 27e543cca13fab05689b2d0d61d200a83cfb00b6 ( v5.11.2 )
Git Tree : stable

Console logs:
watchdog: BUG: soft lockup - CPU#0 stuck for 23s! [syz-executor497:423]
Modules linked in:
CPU: 0 PID: 423 Comm: syz-executor497 Not tainted 5.11.2 #13
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-1 04/01/2014
RIP: 0010:__io_cqring_events fs/io_uring.c:1732 [inline]
RIP: 0010:io_cqring_events fs/io_uring.c:2399 [inline]
RIP: 0010:io_should_wake fs/io_uring.c:7190 [inline]
RIP: 0010:io_cqring_wait fs/io_uring.c:7283 [inline]
RIP: 0010:__do_sys_io_uring_enter+0x6b9/0x1040 fs/io_uring.c:9389
Code: 00 00 e8 ea 9a cd ff 31 ff 44 89 e6 e8 30 9d cd ff 45 85 e4 0f
85 5c 08 00 00 e8 d2 9a cd ff 48 8b 5d c0 48 8b 83 c0 00 00 00 <8b> 88
80 00 00 00 8b 83 00 02 00 00 29 c8 8b 4d c8 89 c7 89 85 78
watchdog: BUG: soft lockup - CPU#1 stuck for 23s! [syz-executor497:416]
RSP: 0018:ffffc900001efe58 EFLAGS: 00000293
Modules linked in:


CPU: 1 PID: 416 Comm: syz-executor497 Not tainted 5.11.2 #13
RAX: ffff888006d3e000 RBX: ffff8880059cb400 RCX: 0000000000000000
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-1 04/01/2014
RDX: ffff888006da98c0 RSI: ffffffff81543cde RDI: 0000000000000003
RIP: 0010:__sanitizer_cov_trace_const_cmp8+0x78/0x90 kernel/kcov.c:293
RBP: ffffc900001eff18 R08: ffff8880059cb680 R09: 0000000000002cc0
Code: 0c fd 28 00 00 00 48 39 ce 72 1f 48 83 c2 01 4c 89 64 08 e8 48
c7 44 08 e0 07 00 00 00 48 89 5c 08 f0 4c 89 74 f8 20 48 89 10 <5b> 41
5c 41 5d 41 5e 5d c3 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f
R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000000
RSP: 0018:ffffc900009f7e08 EFLAGS: 00000246
R13: ffff888005a68700 R14: ffff8880059cb400 R15: ffff8880059cb6a0

FS:  00000000015ed380(0000) GS:ffff88803ec00000(0000) knlGS:0000000000000000
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
RDX: 0000000000000000 RSI: ffff888007e98000 RDI: 0000000000000003
CR2: 00000000004bc0f0 CR3: 0000000007cd6003 CR4: 0000000000370ef0
RBP: ffffc900009f7e28 R08: ffff888006f39a80 R09: 0000000000002cc0
Call Trace:
R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000000
R13: ffff888007e98000 R14: ffffffff8152e286 R15: ffff888006f39aa0
FS:  00000000015ed380(0000) GS:ffff88803ed00000(0000) knlGS:0000000000000000
 __se_sys_io_uring_enter fs/io_uring.c:9306 [inline]
 __x64_sys_io_uring_enter+0x2f/0x40 fs/io_uring.c:9306
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 do_syscall_64+0x38/0x90 arch/x86/entry/common.c:46
CR2: 00000000004bc0f0 CR3: 0000000006c12006 CR4: 0000000000370ee0
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
Call Trace:
RIP: 0033:0x44508d
 signal_pending include/linux/sched/signal.h:369 [inline]
 io_run_task_work_sig+0x66/0x110 fs/io_uring.c:7213
Code: 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 f3 0f 1e fa 48 89 f8 48
89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
 io_cqring_wait fs/io_uring.c:7276 [inline]
 __do_sys_io_uring_enter+0x67b/0x1040 fs/io_uring.c:9389
RSP: 002b:00007ffff7178208 EFLAGS: 00000246
 ORIG_RAX: 00000000000001aa
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 000000000044508d
 __se_sys_io_uring_enter fs/io_uring.c:9306 [inline]
 __x64_sys_io_uring_enter+0x2f/0x40 fs/io_uring.c:9306
RDX: 0000000000000001 RSI: 0000000000000001 RDI: 0000000000000003
 do_syscall_64+0x38/0x90 arch/x86/entry/common.c:46
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
R10: 0000000000000001 R11: 0000000000000246 R12: 00000000004040c0
RIP: 0033:0x44508d
R13: 0000000000000000 R14: 00007ffff7178240 R15: 00007ffff7178230
Code: 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 f3 0f 1e fa 48 89 f8 48
89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffff7178208 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 000000000044508d
RDX: 0000000000000001 RSI: 0000000000000001 RDI: 0000000000000003
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000246 R12: 00000000004040c0
R13: 0000000000000000 R14: 00007ffff7178240 R15: 00007ffff7178230


Syzkaller Reproducer :
# {Threaded:false Collide:false Repeat:true RepeatTimes:0 Procs:8
Slowdown:1 Sandbox: Fault:false FaultCall:-1 FaultNth:0 Leak:false
NetInjection:false NetDevices:false NetReset:false Cgroups:false
BinfmtMisc:false CloseFDs:false KCSAN:false DevlinkPCI:false USB:false
VhciInjection:false Wifi:false IEEE802154:false Sysctl:false
UseTmpDir:false HandleSegv:false Repro:false Trace:false}
r0 = syz_io_uring_setup(0x1, &(0x7f0000000080)={0x0, 0x0, 0x0, 0x0,
0x0, 0x0, 0x0}, &(0x7f00000a0000)=nil, &(0x7f00000b0000)=nil,
&(0x7f0000000100)=<r1=>0x0, &(0x7f0000000140)=<r2=>0x0)
syz_io_uring_submit(r1, r2,
&(0x7f00000001c0)=@IORING_OP_OPENAT2={0x1c, 0x0, 0x0,
0xffffffffffffff9c, 0x0, 0x0, 0x0, 0x0, 0x12345}, 0x0)
syz_memcpy_off$IO_URING_METADATA_GENERIC(r1, 0x10c, &(0x7f0000000000), 0x0, 0x4)
io_uring_enter(r0, 0x1, 0x1, 0x1, 0x0, 0x0)


C Reproducer:
https://gist.github.com/oswalpalash/238a9956cee11f61449fc9a1f33da8c5
gcc -pthread repro.c -o repro
./repro

Kernel Build Config:
https://gist.github.com/oswalpalash/18e847d6e24e3452bc811526fd6f76bb
