Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FA6A5045EA
	for <lists+io-uring@lfdr.de>; Sun, 17 Apr 2022 03:27:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232339AbiDQB34 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 16 Apr 2022 21:29:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231759AbiDQB34 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 16 Apr 2022 21:29:56 -0400
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69DD113E35
        for <io-uring@vger.kernel.org>; Sat, 16 Apr 2022 18:27:22 -0700 (PDT)
Received: by mail-io1-f70.google.com with SMTP id w28-20020a05660205dc00b00645d3cdb0f7so7347559iox.10
        for <io-uring@vger.kernel.org>; Sat, 16 Apr 2022 18:27:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=dX21WvP5WL6W9owr96JSchJVohGsQJ+V9E+b7RK7lfU=;
        b=z6IV/VDf1vzECvfIsNwyDeoPHsG0ES6V+PnWw12d/s6RlZ5+0sVuD5hC3iOsZm3HNO
         fvWxM31EPHj5BVR1W71F7owZ8fPMSUU292V7pGIIfGlb2kqpINMDXItYhbL31O1YwrSH
         aXX1OkrB/is0052eOp+ssFEgz/sClNk9HKqthKo5ZNb+n223YtrLEt4cCXzwaVvVnesD
         pIWfZXMzS5ZgjNk90k12Uu6KTd/wKZsOiJyci32/f31X4KbmVTuTe3fRJ/2uuTW7tnmR
         ciYtVbgxbGNrlTtn1NAsf/2a1dxNW074VDZpUZ+Z5G4qLFPlv8EDweB6c2vQgXkEgoCW
         HaOA==
X-Gm-Message-State: AOAM5322wUwjh5Ubwos7cAUgqkQzCaKNBksRQQQBr7fIAT+guULoOLs9
        n30FjN1lywqWp4hpqrxfUuimSw3DSoAOZfBy9vWJv5b7WJhe
X-Google-Smtp-Source: ABdhPJzkL+XYzFShzAdASAobQRAtg4p6t+z5aPETnpWwLk7qJJu9UMeLxIw6gMyE2Ro8GULzfItdK9A3JEtzX/C9FvddherKgOZC
MIME-Version: 1.0
X-Received: by 2002:a05:6638:380a:b0:326:3710:8ffe with SMTP id
 i10-20020a056638380a00b0032637108ffemr2433923jav.47.1650158841697; Sat, 16
 Apr 2022 18:27:21 -0700 (PDT)
Date:   Sat, 16 Apr 2022 18:27:21 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000951a1505dccf8b73@google.com>
Subject: [syzbot] memory leak in iovec_from_user
From:   syzbot <syzbot+96b43810dfe9c3bb95ed@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    ce522ba9ef7e Linux 5.18-rc2
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14225724f00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b8f1a3425e05af27
dashboard link: https://syzkaller.appspot.com/bug?extid=96b43810dfe9c3bb95ed
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13c45d88f00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17b428af700000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+96b43810dfe9c3bb95ed@syzkaller.appspotmail.com

executing program
BUG: memory leak
unreferenced object 0xffff88810d698300 (size 192):
  comm "syz-executor156", pid 3595, jiffies 4294944234 (age 12.580s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff823357be>] kmalloc_array include/linux/slab.h:621 [inline]
    [<ffffffff823357be>] iovec_from_user lib/iov_iter.c:1922 [inline]
    [<ffffffff823357be>] iovec_from_user+0x13e/0x280 lib/iov_iter.c:1905
    [<ffffffff82335945>] __import_iovec+0x45/0x250 lib/iov_iter.c:1948
    [<ffffffff81668c8e>] __io_import_iovec+0xfe/0x800 fs/io_uring.c:3497
    [<ffffffff8166d92f>] io_import_iovec fs/io_uring.c:3508 [inline]
    [<ffffffff8166d92f>] io_read+0x59f/0x880 fs/io_uring.c:3803
    [<ffffffff816727b4>] io_issue_sqe+0x364/0x3270 fs/io_uring.c:7122
    [<ffffffff816761c3>] __io_queue_sqe fs/io_uring.c:7489 [inline]
    [<ffffffff816761c3>] io_queue_sqe fs/io_uring.c:7531 [inline]
    [<ffffffff816761c3>] io_submit_sqe fs/io_uring.c:7736 [inline]
    [<ffffffff816761c3>] io_submit_sqes+0x553/0x3030 fs/io_uring.c:7842
    [<ffffffff81679390>] __do_sys_io_uring_enter+0x6f0/0x1100 fs/io_uring.c:10780
    [<ffffffff8451ca25>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
    [<ffffffff8451ca25>] do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
    [<ffffffff84600068>] entry_SYSCALL_64_after_hwframe+0x44/0xae

BUG: memory leak
unreferenced object 0xffff88810d6983c0 (size 192):
  comm "syz-executor156", pid 3603, jiffies 4294944759 (age 7.330s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff823357be>] kmalloc_array include/linux/slab.h:621 [inline]
    [<ffffffff823357be>] iovec_from_user lib/iov_iter.c:1922 [inline]
    [<ffffffff823357be>] iovec_from_user+0x13e/0x280 lib/iov_iter.c:1905
    [<ffffffff82335945>] __import_iovec+0x45/0x250 lib/iov_iter.c:1948
    [<ffffffff81668c8e>] __io_import_iovec+0xfe/0x800 fs/io_uring.c:3497
    [<ffffffff8166d92f>] io_import_iovec fs/io_uring.c:3508 [inline]
    [<ffffffff8166d92f>] io_read+0x59f/0x880 fs/io_uring.c:3803
    [<ffffffff816727b4>] io_issue_sqe+0x364/0x3270 fs/io_uring.c:7122
    [<ffffffff816761c3>] __io_queue_sqe fs/io_uring.c:7489 [inline]
    [<ffffffff816761c3>] io_queue_sqe fs/io_uring.c:7531 [inline]
    [<ffffffff816761c3>] io_submit_sqe fs/io_uring.c:7736 [inline]
    [<ffffffff816761c3>] io_submit_sqes+0x553/0x3030 fs/io_uring.c:7842
    [<ffffffff81679390>] __do_sys_io_uring_enter+0x6f0/0x1100 fs/io_uring.c:10780
    [<ffffffff8451ca25>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
    [<ffffffff8451ca25>] do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
    [<ffffffff84600068>] entry_SYSCALL_64_after_hwframe+0x44/0xae



---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
