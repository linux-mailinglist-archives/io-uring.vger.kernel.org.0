Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B854C27EF1E
	for <lists+io-uring@lfdr.de>; Wed, 30 Sep 2020 18:27:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725800AbgI3Q1F (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 30 Sep 2020 12:27:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbgI3Q1F (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 30 Sep 2020 12:27:05 -0400
Received: from mail-ua1-x943.google.com (mail-ua1-x943.google.com [IPv6:2607:f8b0:4864:20::943])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1538C061755
        for <io-uring@vger.kernel.org>; Wed, 30 Sep 2020 09:27:03 -0700 (PDT)
Received: by mail-ua1-x943.google.com with SMTP id n2so636983uaw.11
        for <io-uring@vger.kernel.org>; Wed, 30 Sep 2020 09:27:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=WG5G4sUVyvrQGsnlsQeC4+UV7h5QjTS42s+bj5YwJc8=;
        b=KK83dCEeXjQG172+8n2wHCYH/z7PFAea9ZoCuUEpetEP0BGozMkucuXzWLw1FkGHWw
         kr7QGAisEjc0+nDjmdufHtwmcrb0KEyDvEQ/fIQBN5EuqB3MJ3C4av0Qbk6/YNNkNUSZ
         0Xs4Z+lbV/XeCwYJhnszg0DmoedE+hD0PVyTS3dPdOWMxQ/l7ZYJXQ5CL1Q0MIUigJ0b
         O7wu0FCB4jhs4eys67jJM6zCPR1jwVf/t7OmwwXQXMozzlRKGdCriu9gzTsyPw6wg5uO
         p1wGVuxu0LLqMo3pRZ0a//pjaOUIypUGZWz2ZezwTcEPQPlLXWJ29j8bGlu68wvZA0Aw
         tcSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=WG5G4sUVyvrQGsnlsQeC4+UV7h5QjTS42s+bj5YwJc8=;
        b=nCuDYIoHgnAY8ncHdBDOo6hCmYEHXtmW24fePr0IAexzMWrAalpsyLVsc2IHiookeQ
         4k+IadJMle8/CWbpYrXvXin8b0FtcEp2TrFXh4d7YEBJiXHBy/IJ/Vj29SSG2YQ4K40X
         k1jqY9Y1a2P2Fa6ei+mEBI/W3FEWdUIzW0HReY9oVLb3mNgoeiHoYf1Pzt5RARfPKBzK
         rWKzGG1LjYdITp//m23nhHTL+8iHVTOyNpmrlZFX6X2EBuF7tba7QdCcdMXkSrc0aNRi
         ICqfC43hsfrdBp0LRNJ6pk9a5wDEOtZsKeAQixlA3fpyVF8Dg+uhK7DKM0z6OFBnCdio
         veAw==
X-Gm-Message-State: AOAM533hJR9xPmbfZufwy8SJ64XKteLqxIFyLXOR0RnvtxGnlp6HcLsL
        h7Pd0ukHOfGWG0Cag3mGIoUsRtgW8zcx0hYOS+9swet+AsHv/A==
X-Google-Smtp-Source: ABdhPJxcwXrDC8PvSTr8pVqVFbOJ6KvIEt094J69z54538zPeWZkFX+qQ7q+wMNmfb6DmvoM4MT0uKStQSO0OTmiQCw=
X-Received: by 2002:ab0:700c:: with SMTP id k12mr2196711ual.132.1601483222587;
 Wed, 30 Sep 2020 09:27:02 -0700 (PDT)
MIME-Version: 1.0
From:   Ju Hyung Park <qkrwngud825@gmail.com>
Date:   Thu, 1 Oct 2020 01:26:51 +0900
Message-ID: <CAD14+f3G2f4QEK+AQaEjAG4syUOK-9bDagXa8D=RxdFWdoi5fQ@mail.gmail.com>
Subject: io_uring possibly the culprit for qemu hang (linux-5.4.y)
To:     io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi everyone.

I have recently switched to a setup running QEMU 5.0(which supports
io_uring) for a Windows 10 guest on Linux v5.4.63.
The QEMU hosts /dev/nvme0n1p3 to the guest with virtio-blk with
discard/unmap enabled.

I've been having a weird issue where the system would randomly hang
whenever I turn on or shutdown the guest. The host will stay up for a
bit and then just hang. No response on SSH, etc. Even ping doesn't
work.

It's been hard to even get a log to debug the issue, but I've been
able to get a show-backtrace-all-active-cpus sysrq dmesg on the most
recent encounter with the issue and it's showing some io_uring
functions.

Since I've been encountering the issue ever since I switched to QEMU
5.0, I suspect io_uring may be the culprit to the issue.

While I'd love to try out the mainline kernel, it's currently not
feasible at the moment as I have to stay in linux-5.4.y. Backporting
mainline's io_uring also seems to be a non-trivial job.

Any tips would be appreciated. I can build my own kernel and I'm
willing to try out (backported) patches.

Thanks.

[243683.539303] NMI backtrace for cpu 1
[243683.539303] CPU: 1 PID: 1527 Comm: qemu-system-x86 Tainted: P
  W  O      5.4.63+ #1
[243683.539303] Hardware name: System manufacturer System Product
Name/PRIME Z370-A, BIOS 2401 07/12/2019
[243683.539304] RIP: 0010:io_uring_flush+0x98/0x140
[243683.539304] Code: e4 74 70 48 8b 93 e8 02 00 00 48 8b 32 48 8b 4a
08 48 89 4e 08 48 89 31 48 89 12 48 89 52 08 48 8b 72 f8 81 4a a8 00
40 00 00 <48> 85 f6 74 15 4c 3b 62 c8 75 0f ba 01 00 00 00 bf 02 00 00
00 e8
[243683.539304] RSP: 0018:ffff8881f20c3e28 EFLAGS: 00000006
[243683.539305] RAX: ffff888419cd94e0 RBX: ffff88842ba49800 RCX:
ffff888419cd94e0
[243683.539305] RDX: ffff888419cd94e0 RSI: ffff888419cd94d0 RDI:
ffff88842ba49af8
[243683.539306] RBP: ffff88842ba49af8 R08: 0000000000000001 R09:
ffff88840d17aaf8
[243683.539306] R10: 0000000000000001 R11: 00000000ffffffec R12:
ffff88843c68c080
[243683.539306] R13: ffff88842ba49ae8 R14: 0000000000000001 R15:
0000000000000000
[243683.539307] FS:  0000000000000000(0000) GS:ffff88843ea80000(0000)
knlGS:0000000000000000
[243683.539307] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[243683.539307] CR2: 00007f3234b31f90 CR3: 0000000002608001 CR4:
00000000003726e0
[243683.539307] Call Trace:
[243683.539308]  ? filp_close+0x2a/0x60
[243683.539308]  ? put_files_struct.part.0+0x57/0xb0
[243683.539309]  ? do_exit+0x321/0xa70
[243683.539309]  ? do_group_exit+0x35/0x90
[243683.539309]  ? __x64_sys_exit_group+0xf/0x10
[243683.539309]  ? do_syscall_64+0x41/0x160
[243683.539309]  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
[243684.753272] rcu: INFO: rcu_sched detected stalls on CPUs/tasks:
[243684.753278] rcu: 1-...0: (1 GPs behind)
idle=a5e/1/0x4000000000000000 softirq=7893711/7893712 fqs=2955
[243684.753280] (detected by 3, t=6002 jiffies, g=17109677, q=117817)
[243684.753282] Sending NMI from CPU 3 to CPUs 1:
[243684.754285] NMI backtrace for cpu 1
[243684.754285] CPU: 1 PID: 1527 Comm: qemu-system-x86 Tainted: P
  W  O      5.4.63+ #1
[243684.754286] Hardware name: System manufacturer System Product
Name/PRIME Z370-A, BIOS 2401 07/12/2019
[243684.754286] RIP: 0010:io_uring_flush+0x83/0x140
[243684.754287] Code: 89 ef e8 00 36 92 00 48 8b 83 e8 02 00 00 49 39
c5 74 52 4d 85 e4 74 70 48 8b 93 e8 02 00 00 48 8b 32 48 8b 4a 08 48
89 4e 08 <48> 89 31 48 89 12 48 89 52 08 48 8b 72 f8 81 4a a8 00 40 00
00 48
[243684.754287] RSP: 0018:ffff8881f20c3e28 EFLAGS: 00000002
[243684.754288] RAX: ffff888419cd94e0 RBX: ffff88842ba49800 RCX:
ffff888419cd94e0
[243684.754288] RDX: ffff888419cd94e0 RSI: ffff888419cd94e0 RDI:
ffff88842ba49af8
[243684.754289] RBP: ffff88842ba49af8 R08: 0000000000000001 R09:
ffff88840d17aaf8
[243684.754289] R10: 0000000000000001 R11: 00000000ffffffec R12:
ffff88843c68c080
[243684.754289] R13: ffff88842ba49ae8 R14: 0000000000000001 R15:
0000000000000000
[243684.754290] FS:  0000000000000000(0000) GS:ffff88843ea80000(0000)
knlGS:0000000000000000
[243684.754290] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[243684.754291] CR2: 00007f3234b31f90 CR3: 0000000002608001 CR4:
00000000003726e0
[243684.754291] Call Trace:
[243684.754291]  ? filp_close+0x2a/0x60
[243684.754291]  ? put_files_struct.part.0+0x57/0xb0
[243684.754292]  ? do_exit+0x321/0xa70
[243684.754292]  ? do_group_exit+0x35/0x90
[243684.754292]  ? __x64_sys_exit_group+0xf/0x10
[243684.754293]  ? do_syscall_64+0x41/0x160
[243684.754293]  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
