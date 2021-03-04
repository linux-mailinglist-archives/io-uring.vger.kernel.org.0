Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A72B632C99F
	for <lists+io-uring@lfdr.de>; Thu,  4 Mar 2021 02:19:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240295AbhCDBKH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 Mar 2021 20:10:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348307AbhCDAeT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 3 Mar 2021 19:34:19 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53C25C0610D1
        for <io-uring@vger.kernel.org>; Wed,  3 Mar 2021 16:27:32 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id t25so17636223pga.2
        for <io-uring@vger.kernel.org>; Wed, 03 Mar 2021 16:27:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=quGGxWRUU5Ngr3MwgYz4rt2wAlYR60hVCCfV4qzouk0=;
        b=v/SnGptkzop4vsBFWaIZsTigViIsXjiSyi4z/l21q3g2zHzBVlMKo6/CSMc6A/1qtv
         9H/ojZbIyjM24YPUYVhV8o1njV2umLPXBJhMxMuXqAU7h0MWCqaWsV41vQsLGm38RWLK
         XTlpYsqL/hwqY9yU1tXFIs1uePUKaxkNxtafDmFwPvso0RDllQAB4TMoco3Lwqdz+0LP
         QBCLDowIpkKO+32NcdKWFLKTjj1aj8FsiRPiab+/SzRoW9i2u/6t6Tkhs4EEfOBBGIGY
         R785WCQ/QL7QN26hEJbpkbz9FqjD4l6UsY36wvNIBJIg3U601ZVH8CqlImgiXueIJ6+f
         SsuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=quGGxWRUU5Ngr3MwgYz4rt2wAlYR60hVCCfV4qzouk0=;
        b=YFcgzytGUCon0Hwot8R/pKJQRqKbY/XgJCrDiqjbwqmW350CKXa3dKGKxAQmOtS7jt
         5N0e7ml/Xuenq73ceXxfe7UOU4kD+mkjzIUnZ8BHkAnzFc7N5VCWzktXP1tG9eUBamSU
         P2ppVS+Bl81X5eags302nFI9cgXuBphGTtiQoY8SRvfuE+cjeAWL3jSi2HInkh65Q1gW
         hLIRYEgFTemb+haFrFNHnneAqp/f7ArotYQDJz8Zcca/P7VU4+D6uaQSg52h2dup9Z0O
         J2ZctREUnE/KMWUno823DRW6InSOhP2ouIsRqicqHs3oALxCSrJCNGuVjnkKMS2kZfKB
         klvg==
X-Gm-Message-State: AOAM532GQx3k8hGkhhYdnOdhCzsYCZNz4wmENsAI6dUrWYRBh+SKEO0M
        FuLNryANfUVzaZnnEHe7oGwhL0zLguWTN7lm
X-Google-Smtp-Source: ABdhPJyj9MX2BzbGBpidThMnU+kmPnOvQCqjCXXnen2Oy6iTtZahust6opC+OpVdGTwqp1fQEVcyDw==
X-Received: by 2002:a63:905:: with SMTP id 5mr1291888pgj.337.1614817651619;
        Wed, 03 Mar 2021 16:27:31 -0800 (PST)
Received: from localhost.localdomain ([2600:380:7540:52b5:3f01:150c:3b2:bf47])
        by smtp.gmail.com with ESMTPSA id b6sm23456983pgt.69.2021.03.03.16.27.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 16:27:31 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        syzbot+fb5458330b4442f2090d@syzkaller.appspotmail.com
Subject: [PATCH 22/33] io_uring: ensure that SQPOLL thread is started for exit
Date:   Wed,  3 Mar 2021 17:26:49 -0700
Message-Id: <20210304002700.374417-23-axboe@kernel.dk>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210304002700.374417-1-axboe@kernel.dk>
References: <20210304002700.374417-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If we create it in a disabled state because IORING_SETUP_R_DISABLED is
set on ring creation, we need to ensure that we've kicked the thread if
we're exiting before it's been explicitly disabled. Otherwise we can run
into a deadlock where exit is waiting go park the SQPOLL thread, but the
SQPOLL thread itself is waiting to get a signal to start.

That results in the below trace of both tasks hung, waiting on each other:

INFO: task syz-executor458:8401 blocked for more than 143 seconds.
      Not tainted 5.11.0-next-20210226-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor458 state:D stack:27536 pid: 8401 ppid:  8400 flags:0x00004004
Call Trace:
 context_switch kernel/sched/core.c:4324 [inline]
 __schedule+0x90c/0x21a0 kernel/sched/core.c:5075
 schedule+0xcf/0x270 kernel/sched/core.c:5154
 schedule_timeout+0x1db/0x250 kernel/time/timer.c:1868
 do_wait_for_common kernel/sched/completion.c:85 [inline]
 __wait_for_common kernel/sched/completion.c:106 [inline]
 wait_for_common kernel/sched/completion.c:117 [inline]
 wait_for_completion+0x168/0x270 kernel/sched/completion.c:138
 io_sq_thread_park fs/io_uring.c:7115 [inline]
 io_sq_thread_park+0xd5/0x130 fs/io_uring.c:7103
 io_uring_cancel_task_requests+0x24c/0xd90 fs/io_uring.c:8745
 __io_uring_files_cancel+0x110/0x230 fs/io_uring.c:8840
 io_uring_files_cancel include/linux/io_uring.h:47 [inline]
 do_exit+0x299/0x2a60 kernel/exit.c:780
 do_group_exit+0x125/0x310 kernel/exit.c:922
 __do_sys_exit_group kernel/exit.c:933 [inline]
 __se_sys_exit_group kernel/exit.c:931 [inline]
 __x64_sys_exit_group+0x3a/0x50 kernel/exit.c:931
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x43e899
RSP: 002b:00007ffe89376d48 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 00000000004af2f0 RCX: 000000000043e899
RDX: 000000000000003c RSI: 00000000000000e7 RDI: 0000000000000000
RBP: 0000000000000000 R08: ffffffffffffffc0 R09: 0000000010000000
R10: 0000000000008011 R11: 0000000000000246 R12: 00000000004af2f0
R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000001
INFO: task iou-sqp-8401:8402 can't die for more than 143 seconds.
task:iou-sqp-8401    state:D stack:30272 pid: 8402 ppid:  8400 flags:0x00004004
Call Trace:
 context_switch kernel/sched/core.c:4324 [inline]
 __schedule+0x90c/0x21a0 kernel/sched/core.c:5075
 schedule+0xcf/0x270 kernel/sched/core.c:5154
 schedule_timeout+0x1db/0x250 kernel/time/timer.c:1868
 do_wait_for_common kernel/sched/completion.c:85 [inline]
 __wait_for_common kernel/sched/completion.c:106 [inline]
 wait_for_common kernel/sched/completion.c:117 [inline]
 wait_for_completion+0x168/0x270 kernel/sched/completion.c:138
 io_sq_thread+0x27d/0x1ae0 fs/io_uring.c:6717
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
INFO: task iou-sqp-8401:8402 blocked for more than 143 seconds.

Reported-by: syzbot+fb5458330b4442f2090d@syzkaller.appspotmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5bd039aa97bb..549a5c5ee0b5 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7916,6 +7916,7 @@ static void io_sq_offload_start(struct io_ring_ctx *ctx)
 {
 	struct io_sq_data *sqd = ctx->sq_data;
 
+	ctx->flags &= ~IORING_SETUP_R_DISABLED;
 	if (ctx->flags & IORING_SETUP_SQPOLL)
 		complete(&sqd->startup);
 }
@@ -8692,6 +8693,8 @@ static void io_disable_sqo_submit(struct io_ring_ctx *ctx)
 {
 	mutex_lock(&ctx->uring_lock);
 	ctx->sqo_dead = 1;
+	if (ctx->flags & IORING_SETUP_R_DISABLED)
+		io_sq_offload_start(ctx);
 	mutex_unlock(&ctx->uring_lock);
 
 	/* make sure callers enter the ring to get error */
@@ -9659,10 +9662,7 @@ static int io_register_enable_rings(struct io_ring_ctx *ctx)
 	if (ctx->restrictions.registered)
 		ctx->restricted = 1;
 
-	ctx->flags &= ~IORING_SETUP_R_DISABLED;
-
 	io_sq_offload_start(ctx);
-
 	return 0;
 }
 
-- 
2.30.1

