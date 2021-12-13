Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7CBF47322E
	for <lists+io-uring@lfdr.de>; Mon, 13 Dec 2021 17:46:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235167AbhLMQqf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Dec 2021 11:46:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232517AbhLMQqf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Dec 2021 11:46:35 -0500
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB6D9C061574
        for <io-uring@vger.kernel.org>; Mon, 13 Dec 2021 08:46:34 -0800 (PST)
Received: by mail-io1-xd2f.google.com with SMTP id b187so19160381iof.11
        for <io-uring@vger.kernel.org>; Mon, 13 Dec 2021 08:46:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=q/dm6B3isjg7N/J+FHgcDatG3fThO4OMnaegovaCy9o=;
        b=C/Hnj4fXR+l7iqtbcWhT72xAk93c5nOjYZJQ2nNzBkMH43t3eTN8bYzW+/cV32MPUO
         Re6GXa7+hiZ5NWilvoAA+frJQ/WdZ99E9LrexklLTabmON7Nx1S2s08ySFae9Van8pRo
         He+0b9sqNmqqdwtwDO2nYhNdWvKHnpEDWg/OxlBSlD8PVCVg7tJ6bgBmo4XhR7lC3/V5
         7rwPJI2dkxgbXIcYWDsZRwZR3byHF2TPyOWXn8VKxhV2/WLgMyzVKFZbbyLCKUCKafSD
         IXHBYqclRSJing6MMnY37ZLYcrf418QaGHmg1mx4RwBqi1BvZ9tqUq1AahedKwvlFW96
         gfaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=q/dm6B3isjg7N/J+FHgcDatG3fThO4OMnaegovaCy9o=;
        b=3kcO0AaLlRqpMnJwiBeNRlccHZR07sNQnqjKmM48UdJ2XxlRE1HCH9UanfquvT14IB
         k49CvhvIvnB+bkRC2gXRr5jqTAzX3Nn7xQKyJJ13Gf72L963TwdvIBywRQi+K/QucJo0
         ns+BD69TMXOG9NHbqLK9ZbtrhZyf4tHDXo21b0z/RHkDVnSfjDWflSdPvSviN3UlcjRv
         lbn+ydRZRorVou+nHTAfKuuHZEJLb8fsmEfXPbPem0+xEA9w6+AQc8USiW3gBf82e6Xm
         ssNtMEXHY5Vqk1LsL/Mim+zcvwfAW1Qtav1t9oeEPnRgELZjgc/EpqWRpzwiiijQKVjV
         wgrA==
X-Gm-Message-State: AOAM531jX4XQ9STxD4CxpADhyWZxwRwvFQjbEalymTVYYY1P0c5nO8Oo
        +i7uy6Zlf84By5fZOJPhvpWfKN368w2rbg==
X-Google-Smtp-Source: ABdhPJzW+RBxRqPeBR8WEoFjz7megM1b7S8VdQgIWpDRcT0/pTf7Ej/3tkaz5svwMOP7GxtTNKVjiQ==
X-Received: by 2002:a05:6638:2727:: with SMTP id m39mr33589061jav.75.1639413993997;
        Mon, 13 Dec 2021 08:46:33 -0800 (PST)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id v23sm7970527ioj.4.2021.12.13.08.46.33
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Dec 2021 08:46:33 -0800 (PST)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io-wq: drop wqe lock before creating new worker
Message-ID: <7bc9f658-79d0-cef4-87b3-060e5748fa3e@kernel.dk>
Date:   Mon, 13 Dec 2021 09:46:33 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We have two io-wq creation paths:

- On queue enqueue
- When a worker goes to sleep

The latter invokes worker creation with the wqe->lock held, but that can
run into problems if we end up exiting and need to cancel the queued work.
syzbot caught this:

============================================
WARNING: possible recursive locking detected
5.16.0-rc4-syzkaller #0 Not tainted
--------------------------------------------
iou-wrk-6468/6471 is trying to acquire lock:
ffff88801aa98018 (&wqe->lock){+.+.}-{2:2}, at: io_worker_cancel_cb+0xb7/0x210 fs/io-wq.c:187

but task is already holding lock:
ffff88801aa98018 (&wqe->lock){+.+.}-{2:2}, at: io_wq_worker_sleeping+0xb6/0x140 fs/io-wq.c:700

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&wqe->lock);
  lock(&wqe->lock);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

1 lock held by iou-wrk-6468/6471:
 #0: ffff88801aa98018 (&wqe->lock){+.+.}-{2:2}, at: io_wq_worker_sleeping+0xb6/0x140 fs/io-wq.c:700

stack backtrace:
CPU: 1 PID: 6471 Comm: iou-wrk-6468 Not tainted 5.16.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x1dc/0x2d8 lib/dump_stack.c:106
 print_deadlock_bug kernel/locking/lockdep.c:2956 [inline]
 check_deadlock kernel/locking/lockdep.c:2999 [inline]
 validate_chain+0x5984/0x8240 kernel/locking/lockdep.c:3788
 __lock_acquire+0x1382/0x2b00 kernel/locking/lockdep.c:5027
 lock_acquire+0x19f/0x4d0 kernel/locking/lockdep.c:5637
 __raw_spin_lock include/linux/spinlock_api_smp.h:133 [inline]
 _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:154
 io_worker_cancel_cb+0xb7/0x210 fs/io-wq.c:187
 io_wq_cancel_tw_create fs/io-wq.c:1220 [inline]
 io_queue_worker_create+0x3cf/0x4c0 fs/io-wq.c:372
 io_wq_worker_sleeping+0xbe/0x140 fs/io-wq.c:701
 sched_submit_work kernel/sched/core.c:6295 [inline]
 schedule+0x67/0x1f0 kernel/sched/core.c:6323
 schedule_timeout+0xac/0x300 kernel/time/timer.c:1857
 wait_woken+0xca/0x1b0 kernel/sched/wait.c:460
 unix_msg_wait_data net/unix/unix_bpf.c:32 [inline]
 unix_bpf_recvmsg+0x7f9/0xe20 net/unix/unix_bpf.c:77
 unix_stream_recvmsg+0x214/0x2c0 net/unix/af_unix.c:2832
 sock_recvmsg_nosec net/socket.c:944 [inline]
 sock_recvmsg net/socket.c:962 [inline]
 sock_read_iter+0x3a7/0x4d0 net/socket.c:1035
 call_read_iter include/linux/fs.h:2156 [inline]
 io_iter_do_read fs/io_uring.c:3501 [inline]
 io_read fs/io_uring.c:3558 [inline]
 io_issue_sqe+0x144c/0x9590 fs/io_uring.c:6671
 io_wq_submit_work+0x2d8/0x790 fs/io_uring.c:6836
 io_worker_handle_work+0x808/0xdd0 fs/io-wq.c:574
 io_wqe_worker+0x395/0x870 fs/io-wq.c:630
 ret_from_fork+0x1f/0x30

We can safely drop the lock before doing work creation, making the two
contexts the same in that regard.

Reported-by: syzbot+b18b8be69df33a3918e9@syzkaller.appspotmail.com
Fixes: 71a85387546e ("io-wq: check for wq exit after adding new worker task_work")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 8d2bb818a3bb..5c4f582d6549 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -395,7 +395,9 @@ static void io_wqe_dec_running(struct io_worker *worker)
 	if (atomic_dec_and_test(&acct->nr_running) && io_acct_run_queue(acct)) {
 		atomic_inc(&acct->nr_running);
 		atomic_inc(&wqe->wq->worker_refs);
+		raw_spin_unlock(&wqe->lock);
 		io_queue_worker_create(worker, acct, create_worker_cb);
+		raw_spin_lock(&wqe->lock);
 	}
 }
 
-- 
Jens Axboe

