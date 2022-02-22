Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B7AF4C0568
	for <lists+io-uring@lfdr.de>; Wed, 23 Feb 2022 00:40:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236245AbiBVXkw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 22 Feb 2022 18:40:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235678AbiBVXkw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 22 Feb 2022 18:40:52 -0500
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1B213207F
        for <io-uring@vger.kernel.org>; Tue, 22 Feb 2022 15:40:25 -0800 (PST)
Received: by mail-il1-f199.google.com with SMTP id r9-20020a056e0219c900b002c271bebeeaso1427229ill.16
        for <io-uring@vger.kernel.org>; Tue, 22 Feb 2022 15:40:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=OooVyoOgW3l6HohSHtsDC5MFtd8nu7N8NE3HmObQJ5o=;
        b=2ZrgjhciPdeicuB6TbRpyUjWXaWYOJRs7gsdPOAG3t6cPOEXon0Al8n9RIk0fGo21O
         DlIwESQPqFHiHmbASxvSacTyi96vxXcnuD22j2wESNpgg/+ZqgD4STEfIyyk28bAFMnZ
         mhHpngsKt/+7msqmyLA/Wz8y/5sm0lk2J+DcbF5Og1z9b9Twl69jVvoGbxPaiHCefuAa
         K3hC/FLYxKDcS/NbxcsJz+gsKxbAcKQHGE74fQY5tfV+LO1RkrTPvspohMILCMmUCdf7
         O362vQhe8vwMMZXt2oqdhJ6x3gPdtCNeiMhqi7fcbDlDhTfFb11Tot3NWPZ4DPr1ofn4
         s7CA==
X-Gm-Message-State: AOAM530LvLNRvrNC+be4yVyAbFMZxDlHgYl6cGaRvgTMeC9o3OKEBr6W
        u9X2pz4FbZACsfEj8GzOrNf9iLfWJkS7SRgjAK9G71i3LCYc
X-Google-Smtp-Source: ABdhPJz1Fn+Fc9twJUyPU6QWtzbHGw3fAKOtx1KnBpDPEkMKqEXzMWm6kEI3vtUc/FsqtVLZMEPaHKQ/tQu+tmerahxeUEwSCk1w
MIME-Version: 1.0
X-Received: by 2002:a02:c772:0:b0:314:9319:9076 with SMTP id
 k18-20020a02c772000000b0031493199076mr19486218jao.176.1645573224994; Tue, 22
 Feb 2022 15:40:24 -0800 (PST)
Date:   Tue, 22 Feb 2022 15:40:24 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000871dfa05d8a3df7c@google.com>
Subject: [syzbot] memory leak in create_io_worker (2)
From:   syzbot <syzbot+7085977fe51df63eb2bf@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.4 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,LONGWORDS,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    7993e65fdd0f Merge tag 'mtd/fixes-for-5.17-rc5' of git://g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12b8d5bc700000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6668288739b7ad26
dashboard link: https://syzkaller.appspot.com/bug?extid=7085977fe51df63eb2bf
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17eae25a700000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17a51236700000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+7085977fe51df63eb2bf@syzkaller.appspotmail.com

executing program
executing program
executing program
executing program
executing program
BUG: memory leak
unreferenced object 0xffff888112ec56c0 (size 192):
  comm "syz-executor313", pid 30410, jiffies 4294958360 (age 18.100s)
  hex dump (first 32 bytes):
    01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff816515c6>] kmalloc_node include/linux/slab.h:599 [inline]
    [<ffffffff816515c6>] kzalloc_node include/linux/slab.h:726 [inline]
    [<ffffffff816515c6>] create_io_worker+0x46/0x250 fs/io-wq.c:812
    [<ffffffff81652ab2>] create_worker_cb+0xd2/0xf0 fs/io-wq.c:331
    [<ffffffff81273853>] task_work_run+0x73/0xb0 kernel/task_work.c:164
    [<ffffffff8163dadd>] tracehook_notify_signal include/linux/tracehook.h:213 [inline]
    [<ffffffff8163dadd>] io_run_task_work fs/io_uring.c:2595 [inline]
    [<ffffffff8163dadd>] io_run_task_work fs/io_uring.c:2591 [inline]
    [<ffffffff8163dadd>] io_run_task_work_sig+0x6d/0x110 fs/io_uring.c:7684
    [<ffffffff8164ec75>] io_cqring_wait_schedule fs/io_uring.c:7701 [inline]
    [<ffffffff8164ec75>] io_cqring_wait fs/io_uring.c:7770 [inline]
    [<ffffffff8164ec75>] __do_sys_io_uring_enter+0x715/0xf60 fs/io_uring.c:10178
    [<ffffffff844b4875>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
    [<ffffffff844b4875>] do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
    [<ffffffff84600068>] entry_SYSCALL_64_after_hwframe+0x44/0xae



---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
