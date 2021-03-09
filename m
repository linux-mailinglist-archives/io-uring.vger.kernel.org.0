Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A83C633280C
	for <lists+io-uring@lfdr.de>; Tue,  9 Mar 2021 15:05:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230414AbhCIOEf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 9 Mar 2021 09:04:35 -0500
Received: from mail-il1-f199.google.com ([209.85.166.199]:37934 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230403AbhCIOES (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 9 Mar 2021 09:04:18 -0500
Received: by mail-il1-f199.google.com with SMTP id o7so10208869ilt.5
        for <io-uring@vger.kernel.org>; Tue, 09 Mar 2021 06:04:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=1VPBK6wBtCcTOrKaN1TxGhoj3hC0x3OTkbjKlJiuNpo=;
        b=k+xi0Loabdufb/EwOXINWZMBlELKyKmCF8xHIu33MQH+ddSyX9nKeoVPqybHOK8BNB
         YWmarRlucOuuak4W6QS0cDEy2tnheRnZm2jA+oxPluhrDyCEe4OaF4vR3/KyZ9N/7Tz4
         SanzsNDFkV/JS3s+hUBjB6xvEJfnnWnrud71IN9sbHZNFFJSgSAWEB2eAhnLnf+rQHwy
         QLGQC9HWdnveNosrDTQa/dQAx4pYXktpOtNLEnl332z16MB5nJIRFgsjyqkZeag32lZ5
         IUkbm2P+DmHAbSYzvyKRxQaaqthCDrSYRyesMXJVFRXSjVyGaTSmzXutp7W2qDpB/LIp
         8tmA==
X-Gm-Message-State: AOAM530tu7hKxBDiRe7wA2zTZ4NYNDMBxXwLhpAUkIiFRiJEiHt8DFvZ
        06IHxjEzE3Sd7povvYATFHcLhJU6A2r/VT/Hxhls9aa/j8cN
X-Google-Smtp-Source: ABdhPJxPLgqh1syUjNi0vmNy4jTvJyzRPEA9+nXToJjhs9fn6qOPsyIip2Uszu5M3myTNh5VV3QOdD0FbIgWEbAINZfZuzKuAlAM
MIME-Version: 1.0
X-Received: by 2002:a02:cbb2:: with SMTP id v18mr28614932jap.4.1615298657982;
 Tue, 09 Mar 2021 06:04:17 -0800 (PST)
Date:   Tue, 09 Mar 2021 06:04:17 -0800
In-Reply-To: <000000000000430bf505bcef3b00@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b71e9605bd1b064f@google.com>
Subject: Re: [syzbot] possible deadlock in io_sq_thread_finish
From:   syzbot <syzbot+ac39856cb1b332dbbdda@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    144c79ef Merge tag 'perf-tools-fixes-for-v5.12-2020-03-07'..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=129addbcd00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=db9c6adb4986f2f2
dashboard link: https://syzkaller.appspot.com/bug?extid=ac39856cb1b332dbbdda
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=167574dad00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12c8f566d00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+ac39856cb1b332dbbdda@syzkaller.appspotmail.com

============================================
WARNING: possible recursive locking detected
5.12.0-rc2-syzkaller #0 Not tainted
--------------------------------------------
kworker/u4:7/8696 is trying to acquire lock:
ffff888015395870 (&sqd->lock){+.+.}-{3:3}, at: io_sq_thread_stop fs/io_uring.c:7099 [inline]
ffff888015395870 (&sqd->lock){+.+.}-{3:3}, at: io_put_sq_data fs/io_uring.c:7115 [inline]
ffff888015395870 (&sqd->lock){+.+.}-{3:3}, at: io_sq_thread_finish+0x408/0x650 fs/io_uring.c:7139

but task is already holding lock:
ffff888015395870 (&sqd->lock){+.+.}-{3:3}, at: io_sq_thread_park fs/io_uring.c:7088 [inline]
ffff888015395870 (&sqd->lock){+.+.}-{3:3}, at: io_sq_thread_park+0x63/0xc0 fs/io_uring.c:7082

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&sqd->lock);
  lock(&sqd->lock);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

3 locks held by kworker/u4:7/8696:
 #0: ffff888010469138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888010469138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff888010469138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff888010469138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff888010469138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff888010469138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
 #1: ffffc9000253fda8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
 #2: ffff888015395870 (&sqd->lock){+.+.}-{3:3}, at: io_sq_thread_park fs/io_uring.c:7088 [inline]
 #2: ffff888015395870 (&sqd->lock){+.+.}-{3:3}, at: io_sq_thread_park+0x63/0xc0 fs/io_uring.c:7082

stack backtrace:
CPU: 0 PID: 8696 Comm: kworker/u4:7 Not tainted 5.12.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events_unbound io_ring_exit_work
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x141/0x1d7 lib/dump_stack.c:120
 print_deadlock_bug kernel/locking/lockdep.c:2829 [inline]
 check_deadlock kernel/locking/lockdep.c:2872 [inline]
 validate_chain kernel/locking/lockdep.c:3661 [inline]
 __lock_acquire.cold+0x14c/0x3b4 kernel/locking/lockdep.c:4900
 lock_acquire kernel/locking/lockdep.c:5510 [inline]
 lock_acquire+0x1ab/0x740 kernel/locking/lockdep.c:5475
 __mutex_lock_common kernel/locking/mutex.c:946 [inline]
 __mutex_lock+0x139/0x1120 kernel/locking/mutex.c:1093
 io_sq_thread_stop fs/io_uring.c:7099 [inline]
 io_put_sq_data fs/io_uring.c:7115 [inline]
 io_sq_thread_finish+0x408/0x650 fs/io_uring.c:7139
 io_ring_ctx_free fs/io_uring.c:8408 [inline]
 io_ring_exit_work+0x82/0x9a0 fs/io_uring.c:8539
 process_one_work+0x98d/0x1600 kernel/workqueue.c:2275
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2421
 kthread+0x3b1/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294

