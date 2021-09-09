Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4F47404293
	for <lists+io-uring@lfdr.de>; Thu,  9 Sep 2021 03:10:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349033AbhIIBL6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Sep 2021 21:11:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349146AbhIIBLy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Sep 2021 21:11:54 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1B84C0613C1
        for <io-uring@vger.kernel.org>; Wed,  8 Sep 2021 18:10:45 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id h29so229863ila.2
        for <io-uring@vger.kernel.org>; Wed, 08 Sep 2021 18:10:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=gMod3R1c1clRLbf+FER+j2bbcCK5jpdedDPu6mMrBLw=;
        b=U79Gx+dn1C11azcywTaIRyEe39zHra/aWw+kjCjCD8KAyGaKEZO1OWMZhLfLKtj6Uz
         zU1oRDgwwfnQFiMQ4ocd1b4ripAyRXkreX3Sny5Iwc3HQnp+VVaEN+E0T/8paDLSJstC
         2AzA0OpK6Sim8nnuAWgti9Kb+9foX3NscDtVB04OGlXnWZXMU9qPC+EjEScMN5vGNkcw
         tzU3yiqUCzqS8uoDIyKs+QBZLk8ADvEgLLfsCvlCWRlUfDecIkYYSF7NvKoknkXdqoMI
         DGTPXfZglloP5Oy3DoNoYzS4iSfSWcwqqTfpvgiKpttEIdqWBLHk9LFYxf3iE7eXb5Ru
         abKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=gMod3R1c1clRLbf+FER+j2bbcCK5jpdedDPu6mMrBLw=;
        b=UBDTUGCxlCtHo5URe8DtPm9tL0nWKBc/WQNrJ+LtojHjm/xc76zGqgHrUq08FSLSJk
         wfLphqLg+G38bTsi6FvnrutXKeIE28Ty7N+2dMcVwZGKoMf9loQ2eDWrSs7ycbrnIDiP
         cA5A7cy2kxBtYRdXV67nJfufP/mS3RTWIsAmQec5zLonYXaBo62LUcwfpWPR+s+SQJcv
         7f69v4VJNin3WCyY58X2TkzLzSDyJMpn14OzPl9Qo5eRwWYwS5UQGIwvLUa5b44Gcx1i
         PGBAcPbkmzLDqrW01mRDI6n8QA/hY/17ujZ4DnhRpu+RBJRC8Hl10cEeaSAModA6d+Er
         UvtQ==
X-Gm-Message-State: AOAM533U3V63XGRSxxCPhGYMBXot2dweG1QchSguiXLjIItXUXNqZ1di
        C2pswdbgmJZqUpjcXgrBFa6Ue/U1d+6SAQ==
X-Google-Smtp-Source: ABdhPJwYbBwxEgUTqSvMwyOWsqpmFREMd1PGmlC3WtPGelqofpE8J4mn3ishbyRrkb2mrl2a6DUpmw==
X-Received: by 2002:a92:3f01:: with SMTP id m1mr280854ila.105.1631149844855;
        Wed, 08 Sep 2021 18:10:44 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id c23sm151029ioi.31.2021.09.08.18.10.44
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Sep 2021 18:10:44 -0700 (PDT)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: drop ctx->uring_lock before acquiring sqd->lock
Message-ID: <0a9d09b1-2c71-96ea-1f93-339d97af4b50@kernel.dk>
Date:   Wed, 8 Sep 2021 19:10:44 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The SQPOLL thread dictates the lock order, and we hold the ctx->uring_lock
for all the registration opcodes. We also hold a ref to the ctx, and we
do drop the lock for other reasons to quiesce, so it's fine to drop the
ctx lock temporarily to grab the sqd->lock. This fixes the following
lockdep splat:

======================================================
WARNING: possible circular locking dependency detected
5.14.0-syzkaller #0 Not tainted
------------------------------------------------------
syz-executor.5/25433 is trying to acquire lock:
ffff888023426870 (&sqd->lock){+.+.}-{3:3}, at: io_register_iowq_max_workers fs/io_uring.c:10551 [inline]
ffff888023426870 (&sqd->lock){+.+.}-{3:3}, at: __io_uring_register fs/io_uring.c:10757 [inline]
ffff888023426870 (&sqd->lock){+.+.}-{3:3}, at: __do_sys_io_uring_register+0x10aa/0x2e70 fs/io_uring.c:10792

but task is already holding lock:
ffff8880885b40a8 (&ctx->uring_lock){+.+.}-{3:3}, at: __do_sys_io_uring_register+0x2e1/0x2e70 fs/io_uring.c:10791

which lock already depends on the new lock.

the existing dependency chain (in reverse order) is:

-> #1 (&ctx->uring_lock){+.+.}-{3:3}:
       __mutex_lock_common kernel/locking/mutex.c:596 [inline]
       __mutex_lock+0x131/0x12f0 kernel/locking/mutex.c:729
       __io_sq_thread fs/io_uring.c:7291 [inline]
       io_sq_thread+0x65a/0x1370 fs/io_uring.c:7368
       ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

-> #0 (&sqd->lock){+.+.}-{3:3}:
       check_prev_add kernel/locking/lockdep.c:3051 [inline]
       check_prevs_add kernel/locking/lockdep.c:3174 [inline]
       validate_chain kernel/locking/lockdep.c:3789 [inline]
       __lock_acquire+0x2a07/0x54a0 kernel/locking/lockdep.c:5015
       lock_acquire kernel/locking/lockdep.c:5625 [inline]
       lock_acquire+0x1ab/0x510 kernel/locking/lockdep.c:5590
       __mutex_lock_common kernel/locking/mutex.c:596 [inline]
       __mutex_lock+0x131/0x12f0 kernel/locking/mutex.c:729
       io_register_iowq_max_workers fs/io_uring.c:10551 [inline]
       __io_uring_register fs/io_uring.c:10757 [inline]
       __do_sys_io_uring_register+0x10aa/0x2e70 fs/io_uring.c:10792
       do_syscall_x64 arch/x86/entry/common.c:50 [inline]
       do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
       entry_SYSCALL_64_after_hwframe+0x44/0xae

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&ctx->uring_lock);
                               lock(&sqd->lock);
                               lock(&ctx->uring_lock);
  lock(&sqd->lock);

 *** DEADLOCK ***

---

Fixes: 2e480058ddc2 ("io-wq: provide a way to limit max number of workers")
Reported-by: syzbot+97fa56483f69d677969f@syzkaller.appspotmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d80d8359501f..b21a423a4de8 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -10551,7 +10551,14 @@ static int io_register_iowq_max_workers(struct io_ring_ctx *ctx,
 	if (ctx->flags & IORING_SETUP_SQPOLL) {
 		sqd = ctx->sq_data;
 		if (sqd) {
+			/*
+			 * Observe the correct sqd->lock -> ctx->uring_lock
+			 * ordering. Fine to drop uring_lock here, we hold
+			 * a ref to the ctx.
+			 */
+			mutex_unlock(&ctx->uring_lock);
 			mutex_lock(&sqd->lock);
+			mutex_lock(&ctx->uring_lock);
 			tctx = sqd->thread->io_uring;
 		}
 	} else {

-- 
Jens Axboe

