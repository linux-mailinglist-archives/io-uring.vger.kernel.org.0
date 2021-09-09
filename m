Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92CC3404368
	for <lists+io-uring@lfdr.de>; Thu,  9 Sep 2021 04:02:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349933AbhIICDU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Sep 2021 22:03:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349651AbhIICDR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Sep 2021 22:03:17 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86E3BC061575
        for <io-uring@vger.kernel.org>; Wed,  8 Sep 2021 19:02:08 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id f6so376516iox.0
        for <io-uring@vger.kernel.org>; Wed, 08 Sep 2021 19:02:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=AeHejp2eFesr5tYGnmlgrxfZGi4BeGouXtKR+e50VZI=;
        b=vgGXdMxyrhID3rwRTvPdcIRzdTuLkDY3dpYfsBtTL93d/oLsN5DimzH6yTFkkiKLQ7
         +dUHcvPF4NVpznexmvvmn/9TiV43DMMml0XIZyWAhfjbAoWkLgBviErVKMD1vBrJQ4f5
         HDVtDebj3t2836aEEOuQXoY7xY7+InC4/xcOvh2nJcJaIP2mEE9CeUlXOL8swguPex3k
         4FwxRBW6VN5xotql3uZEKBJatDqCuSJ+z5NGeC/aaGlDwBjU2TkatSLW5ScvVjPiTblc
         2v1RiFCDn47B5xTNXrej2gHbELrT1OyDxrBUT5jGoREfCZ/2nKRzNYQfhZjbWPl/1V6K
         koqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=AeHejp2eFesr5tYGnmlgrxfZGi4BeGouXtKR+e50VZI=;
        b=YRP+2BaDBqmrX8DJ8eNJBGWuTm3oWnV3rgltW/i7ww8g2S0J3aEVBITz6JqiK0jfs7
         zb7ZxWQZXNSV15LbUjvsBEdTFC4NiDmqD8WLp4nvpsPxlbB24eyKoHd8ryKb8SHYv+u3
         PsSLuBnX+Kn0XlxkZMUyzwLrIFV7SP8JcXwcALd9HP/XbF5MJKrG76IasVtsBbeeMkK7
         cDQYZqYze2V7HI+4rTPKHQVg047KKq0ppRCLgout7Fsz8vDOZZ+n1Skg7vBZ6pQANyIK
         BGVQ4+I3r1RTjfhsp6cbBN8uTOVfc7xzjYhL1F6OujGBT0TsYCUUrepHAgdjulYGsgiQ
         iBmA==
X-Gm-Message-State: AOAM533MB0ygAxHrYt4BCsPpf0T6oWy0bchvzmOlypdmLYF1D6Dazup5
        26yZmUKKRlnCwHoY8/woQR1S49HNmQ2DZw==
X-Google-Smtp-Source: ABdhPJx/ROaI7ZN2U2YtlpBzjQhfVSBpoGM79B7ArRNd/vqwIMDISWY2DPh6Ik57/7WD6F9CNK/Cqg==
X-Received: by 2002:a05:6638:185:: with SMTP id a5mr541172jaq.31.1631152927676;
        Wed, 08 Sep 2021 19:02:07 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id m26sm190722ioj.54.2021.09.08.19.02.07
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Sep 2021 19:02:07 -0700 (PDT)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io-wq: fix silly logic error in io_task_work_match()
Message-ID: <fd354feb-f52e-05f9-e1fe-f8548c73032c@kernel.dk>
Date:   Wed, 8 Sep 2021 20:02:06 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We check for the func with an OR condition, which means it always ends
up being false and we never match the task_work we want to cancel. In
the unexpected case that we do exit with that pending, we can trigger
a hang waiting for a worker to exit, but it was never created. syzbot
reports that as such:

INFO: task syz-executor687:8514 blocked for more than 143 seconds.
      Not tainted 5.14.0-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor687 state:D stack:27296 pid: 8514 ppid:  8479 flags:0x00024004
Call Trace:
 context_switch kernel/sched/core.c:4940 [inline]
 __schedule+0x940/0x26f0 kernel/sched/core.c:6287
 schedule+0xd3/0x270 kernel/sched/core.c:6366
 schedule_timeout+0x1db/0x2a0 kernel/time/timer.c:1857
 do_wait_for_common kernel/sched/completion.c:85 [inline]
 __wait_for_common kernel/sched/completion.c:106 [inline]
 wait_for_common kernel/sched/completion.c:117 [inline]
 wait_for_completion+0x176/0x280 kernel/sched/completion.c:138
 io_wq_exit_workers fs/io-wq.c:1162 [inline]
 io_wq_put_and_exit+0x40c/0xc70 fs/io-wq.c:1197
 io_uring_clean_tctx fs/io_uring.c:9607 [inline]
 io_uring_cancel_generic+0x5fe/0x740 fs/io_uring.c:9687
 io_uring_files_cancel include/linux/io_uring.h:16 [inline]
 do_exit+0x265/0x2a30 kernel/exit.c:780
 do_group_exit+0x125/0x310 kernel/exit.c:922
 get_signal+0x47f/0x2160 kernel/signal.c:2868
 arch_do_signal_or_restart+0x2a9/0x1c40 arch/x86/kernel/signal.c:865
 handle_signal_work kernel/entry/common.c:148 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:172 [inline]
 exit_to_user_mode_prepare+0x17d/0x290 kernel/entry/common.c:209
 __syscall_exit_to_user_mode_work kernel/entry/common.c:291 [inline]
 syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:302
 do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x445cd9
RSP: 002b:00007fc657f4b308 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
RAX: 0000000000000001 RBX: 00000000004cb448 RCX: 0000000000445cd9
RDX: 00000000000f4240 RSI: 0000000000000081 RDI: 00000000004cb44c
RBP: 00000000004cb440 R08: 000000000000000e R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000049b154
R13: 0000000000000003 R14: 00007fc657f4b400 R15: 0000000000022000

While in there, also decrement accr->nr_workers. This isn't strictly
needed as we're exiting, but let's make sure the accounting matches up.

Fixes: 3146cba99aa2 ("io-wq: make worker creation resilient against signals")
Reported-by: syzbot+f62d3e0a4ea4f38f5326@syzkaller.appspotmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 35e7ee26f7ea..c2e73ce6888a 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -1133,7 +1133,7 @@ static bool io_task_work_match(struct callback_head *cb, void *data)
 {
 	struct io_worker *worker;
 
-	if (cb->func != create_worker_cb || cb->func != create_worker_cont)
+	if (cb->func != create_worker_cb && cb->func != create_worker_cont)
 		return false;
 	worker = container_of(cb, struct io_worker, create_work);
 	return worker->wqe->wq == data;
@@ -1154,9 +1154,14 @@ static void io_wq_exit_workers(struct io_wq *wq)
 
 	while ((cb = task_work_cancel_match(wq->task, io_task_work_match, wq)) != NULL) {
 		struct io_worker *worker;
+		struct io_wqe_acct *acct;
 
 		worker = container_of(cb, struct io_worker, create_work);
-		atomic_dec(&worker->wqe->acct[worker->create_index].nr_running);
+		acct = io_wqe_get_acct(worker);
+		atomic_dec(&acct->nr_running);
+		raw_spin_lock(&worker->wqe->lock);
+		acct->nr_workers--;
+		raw_spin_unlock(&worker->wqe->lock);
 		io_worker_ref_put(wq);
 		clear_bit_unlock(0, &worker->create_state);
 		io_worker_release(worker);

-- 
Jens Axboe

