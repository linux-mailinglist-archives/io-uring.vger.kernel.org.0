Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4487234C506
	for <lists+io-uring@lfdr.de>; Mon, 29 Mar 2021 09:35:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230252AbhC2Heo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 29 Mar 2021 03:34:44 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:37020 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230364AbhC2HeT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 29 Mar 2021 03:34:19 -0400
Received: by mail-io1-f72.google.com with SMTP id u23so1430168ioc.4
        for <io-uring@vger.kernel.org>; Mon, 29 Mar 2021 00:34:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=lBStvjRDQ5cgv9i64/xI95nXksjc9KFyRlQBs2TGHqI=;
        b=Ou8Ewy2bK312etXXcMJ/OQ5fmpTy6dW9JrFsO+RzFd9XM+qowTabW2KYC2D8wX7vN8
         DlN8QZXeqXNA9qxpCwM+yCBHIyoi3IJtSXx1EincLAh7u6iE/MLYzFA5jHt7/+7Vjd/G
         iSop1ByHpO90yVbnNsEaHiwFyYapVWxtEihjsbdgMt1Fz1rOOfebQ7NyCPGS2kUl2O4K
         bQf3lmMuZMktlTzGgAeUbIz5CFW6d/ugzpY7NuydZQ/ybxgXsZrxs2yRLJF++VYBN4UR
         ySSl6JIYKypOEyPvgfskt/4ZteXEdwnpOkmXIs6rmaimsHnggZydVqmWVsNkQraICzuA
         AkfQ==
X-Gm-Message-State: AOAM5324CyxpMcqG7zj9gs7zE1ik2uA2xHZtsIsouSiQSuUP9FD6VPOy
        jlEXCVTgp3mEznqlscNRAagj96qplaJ2i3drv+CBfkKw1/Jb
X-Google-Smtp-Source: ABdhPJySMKAh0t5qZNyTGzPjJ6vKcA86/lle9pjA3BOncntSeIqti786AppiH6+JKm8btWC9s4fDNnV10I801jQXkvV32DqMYugG
MIME-Version: 1.0
X-Received: by 2002:a5e:990f:: with SMTP id t15mr12105880ioj.180.1617003258436;
 Mon, 29 Mar 2021 00:34:18 -0700 (PDT)
Date:   Mon, 29 Mar 2021 00:34:18 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d1e19505bea7e8b8@google.com>
Subject: [syzbot] WARNING: suspicious RCU usage in io_sq_thread
From:   syzbot <syzbot+0cbf22e728582ade44f2@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    81b1d39f Merge tag '5.12-rc4-smb3' of git://git.samba.org/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=156f3d9ed00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d4e9addca54f3b44
dashboard link: https://syzkaller.appspot.com/bug?extid=0cbf22e728582ade44f2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+0cbf22e728582ade44f2@syzkaller.appspotmail.com

WARNING: suspicious RCU usage
5.12.0-rc4-syzkaller #0 Not tainted
-----------------------------
kernel/sched/core.c:8294 Illegal context switch in RCU-bh read-side critical section!

other info that might help us debug this:


rcu_scheduler_active = 2, debug_locks = 0
1 lock held by iou-sqp-10136/10139:
 #0: ffff88801a5a8c70 (&sqd->lock){+.+.}-{3:3}, at: io_sq_thread+0xff2/0x13a0 fs/io_uring.c:6794

stack backtrace:
CPU: 1 PID: 10139 Comm: iou-sqp-10136 Not tainted 5.12.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x141/0x1d7 lib/dump_stack.c:120
 ___might_sleep+0x229/0x2c0 kernel/sched/core.c:8294
 io_sq_thread+0xbae/0x13a0 fs/io_uring.c:6768
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
