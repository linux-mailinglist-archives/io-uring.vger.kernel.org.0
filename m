Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1327C40420C
	for <lists+io-uring@lfdr.de>; Thu,  9 Sep 2021 02:09:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347902AbhIIAK2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Sep 2021 20:10:28 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:40557 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348027AbhIIAK0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Sep 2021 20:10:26 -0400
Received: by mail-il1-f198.google.com with SMTP id f13-20020a056e02168d00b002244a6aa233so144924ila.7
        for <io-uring@vger.kernel.org>; Wed, 08 Sep 2021 17:09:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=E6ifD+DxBrKIc0PmerbZr6KIS62In3l8PDO6Br/j8+M=;
        b=vIrUhaF1V88T3Gd0Ug5P0KERrTTlv4PDERrVzzK6QicUnncmkxbC1RqpPoGnfGE5tV
         2AWiQCgF633/LuugYv6OG2eN6gkeKHIqaULm4RrDYIZCymvuGCPU10h4MB0WnG36CmDx
         mUqLZTtvngPTqM34UXVRIVyslGBVX76FLioeaIfcEDa0QKkj0f3bAuM7zcsBMHHxkJyL
         Gv4j5aT5xqOc94E9QFGsJBE//LTYnHDboglekGYncIGa8M0KRBx+92FhrTDwy7RPMJdv
         cHZMlKR3EHARJjkmyEAPd52UWvR/fPie8RzURNrr9qYH+zO8e1D5kLby6ccJ/6DwCIvD
         o0Zw==
X-Gm-Message-State: AOAM533aDLnd0bs091yopJpdCcIZEKmEa6BrbOgSeoj+Q9+P+oh0smvc
        QU0MhT8xV27pViD7EId+gdjERn6YIFavH9NHzgZGxNT97RSY
X-Google-Smtp-Source: ABdhPJygVe0H6BfQEZ6XB2+96sBIZBndxK95aym50XDhgRIeaOCpepNct4z3XC33RSygyODIBzzAYMiYTlGAO0UXA33ZvXnRXl/5
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:20cd:: with SMTP id 13mr123218ilq.156.1631146157792;
 Wed, 08 Sep 2021 17:09:17 -0700 (PDT)
Date:   Wed, 08 Sep 2021 17:09:17 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000004fe6b105cb84cf1e@google.com>
Subject: [syzbot] memory leak in create_io_worker
From:   syzbot <syzbot+65454c239241d3d647da@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    0bcfe68b8767 Revert "memcg: enable accounting for pollfd a..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=152ccba3300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c2f4c21cbd29de3d
dashboard link: https://syzkaller.appspot.com/bug?extid=65454c239241d3d647da
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=123d31b3300000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+65454c239241d3d647da@syzkaller.appspotmail.com

2021/09/08 01:29:02 executed programs: 33
2021/09/08 01:29:08 executed programs: 42
2021/09/08 01:29:15 executed programs: 62
2021/09/08 01:29:21 executed programs: 82
BUG: memory leak
unreferenced object 0xffff888126fcd6c0 (size 192):
  comm "syz-executor.1", pid 11934, jiffies 4294983026 (age 15.690s)
  hex dump (first 32 bytes):
    01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81632c91>] kmalloc_node include/linux/slab.h:609 [inline]
    [<ffffffff81632c91>] kzalloc_node include/linux/slab.h:732 [inline]
    [<ffffffff81632c91>] create_io_worker+0x41/0x1e0 fs/io-wq.c:739
    [<ffffffff8163311e>] io_wqe_create_worker fs/io-wq.c:267 [inline]
    [<ffffffff8163311e>] io_wqe_enqueue+0x1fe/0x330 fs/io-wq.c:866
    [<ffffffff81620b64>] io_queue_async_work+0xc4/0x200 fs/io_uring.c:1473
    [<ffffffff8162c59c>] __io_queue_sqe+0x34c/0x510 fs/io_uring.c:6933
    [<ffffffff8162c7ab>] io_req_task_submit+0x4b/0xa0 fs/io_uring.c:2233
    [<ffffffff8162cb48>] io_async_task_func+0x108/0x1c0 fs/io_uring.c:5462
    [<ffffffff816259e3>] tctx_task_work+0x1b3/0x3a0 fs/io_uring.c:2158
    [<ffffffff81269b43>] task_work_run+0x73/0xb0 kernel/task_work.c:164
    [<ffffffff812dcdd1>] tracehook_notify_signal include/linux/tracehook.h:212 [inline]
    [<ffffffff812dcdd1>] handle_signal_work kernel/entry/common.c:146 [inline]
    [<ffffffff812dcdd1>] exit_to_user_mode_loop kernel/entry/common.c:172 [inline]
    [<ffffffff812dcdd1>] exit_to_user_mode_prepare+0x151/0x180 kernel/entry/common.c:209
    [<ffffffff843ff25d>] __syscall_exit_to_user_mode_work kernel/entry/common.c:291 [inline]
    [<ffffffff843ff25d>] syscall_exit_to_user_mode+0x1d/0x40 kernel/entry/common.c:302
    [<ffffffff843fa4a2>] do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
    [<ffffffff84600068>] entry_SYSCALL_64_after_hwframe+0x44/0xae



---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
