Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF560345768
	for <lists+io-uring@lfdr.de>; Tue, 23 Mar 2021 06:41:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbhCWFkm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Mar 2021 01:40:42 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:40184 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbhCWFkQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Mar 2021 01:40:16 -0400
Received: by mail-io1-f71.google.com with SMTP id x26so1102925ior.7
        for <io-uring@vger.kernel.org>; Mon, 22 Mar 2021 22:40:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=8UIJBBCFx9G0AZ6QPsyJ2f+Jnb2J4vHizufHfr/0rys=;
        b=T3qCySpxKhFCNzZDt0DICW5F/WrfT7XBwn+VVW/eOeoSaXKmVcqRdbXPd5Oqlz+Ia9
         r/wKOdnloaY/ks6vXJD2AIrPdv29IhXLn1C84oZLRCN0YdelfOSQuMV/xLQ7GZh7j6t/
         5sT/66ogUYyCShedU9gpMrTwBJYGsZDJpm+GolJJyPhsu1XjVEHorMbnATsWAD+hAlVE
         qVo2GgYiMgNV2MOqtzg8SwJ3ppsPZfGbmDQ4EQMxieQcuRII8uFhNUENtwrF4HB0Fewh
         c1ARz0cA4jBqbcl3nSpxPISYirDY9wb2JIMJhAnOAJC4OUxwVaIa5x0TQGCxALbw3XiN
         pQ0Q==
X-Gm-Message-State: AOAM533VaKYA4nJi7StouNi5CR99vQnSXoVwYWFNcaCNSKEYWiYCXefD
        weHiKgcfS4nYfJDRD7D9WWpaQf5nbfoGIj26PJUtiEittzpL
X-Google-Smtp-Source: ABdhPJywzjL2S5675jBi+LjUShhiMQm7FNQYgD96vO6uxEMlOimdM9ZcZ5MgYdoqaCNTTcck/jPUQlNts8o3Nona6u5GfutE1+LY
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:802:: with SMTP id u2mr3172526ilm.298.1616478015540;
 Mon, 22 Mar 2021 22:40:15 -0700 (PDT)
Date:   Mon, 22 Mar 2021 22:40:15 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e754b705be2d9d69@google.com>
Subject: [syzbot] WARNING in io_sq_thread_park
From:   syzbot <syzbot+e3a3f84f5cecf61f0583@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    84196390 Merge tag 'selinux-pr-20210322' of git://git.kern..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=152a6ad6d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5adab0bdee099d7a
dashboard link: https://syzkaller.appspot.com/bug?extid=e3a3f84f5cecf61f0583

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e3a3f84f5cecf61f0583@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 1 PID: 27907 at fs/io_uring.c:7147 io_sq_thread_park+0xb5/0xd0 fs/io_uring.c:7147
Modules linked in:
CPU: 1 PID: 27907 Comm: iou-sqp-27905 Not tainted 5.12.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:io_sq_thread_park+0xb5/0xd0 fs/io_uring.c:7147
Code: 3c 02 00 75 29 48 8b ab a8 00 00 00 48 85 ed 74 0d e8 df a3 99 ff 48 89 ef e8 f7 49 75 ff 5b 5d e9 d0 a3 99 ff e8 cb a3 99 ff <0f> 0b eb 85 48 89 ef e8 bf 36 dd ff eb cd 48 89 ef e8 b5 36 dd ff
RSP: 0018:ffffc90001bff9e8 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffff88802489a000 RCX: 0000000000000000
RDX: ffff88808e7e0000 RSI: ffffffff81da4a65 RDI: ffff88802489a000
RBP: ffff88802489a0a8 R08: 0000000000000001 R09: ffff88806a7420c7
R10: ffffed100d4e8418 R11: 0000000000000000 R12: ffff88806a742590
R13: ffff88806a742458 R14: 1ffff9200037ff42 R15: ffff88806a7424b8
FS:  00007f63505a8700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000540198 CR3: 0000000024531000 CR4: 0000000000350ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 000000000111062a
Call Trace:
 io_ring_ctx_wait_and_kill+0x214/0x700 fs/io_uring.c:8619
 io_uring_release+0x3e/0x50 fs/io_uring.c:8646
 __fput+0x288/0x920 fs/file_table.c:280
 task_work_run+0xdd/0x1a0 kernel/task_work.c:140
 io_run_task_work fs/io_uring.c:2238 [inline]
 io_run_task_work fs/io_uring.c:2228 [inline]
 io_uring_try_cancel_requests+0x8ec/0xc60 fs/io_uring.c:8770
 io_uring_cancel_sqpoll+0x1cf/0x290 fs/io_uring.c:8974
 io_sqpoll_cancel_cb+0x87/0xb0 fs/io_uring.c:8907
 io_run_task_work_head+0x58/0xb0 fs/io_uring.c:1961
 io_sq_thread+0x3e2/0x18d0 fs/io_uring.c:6763
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
