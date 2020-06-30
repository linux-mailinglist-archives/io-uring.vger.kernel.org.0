Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DD9A20F47E
	for <lists+io-uring@lfdr.de>; Tue, 30 Jun 2020 14:22:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387482AbgF3MWi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 30 Jun 2020 08:22:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733305AbgF3MWh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 30 Jun 2020 08:22:37 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3680C061755
        for <io-uring@vger.kernel.org>; Tue, 30 Jun 2020 05:22:36 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id w6so20322464ejq.6
        for <io-uring@vger.kernel.org>; Tue, 30 Jun 2020 05:22:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=pbimq0V5/Dfkez/1F/zWqShQg9izS4DQzGvOoN6G2uc=;
        b=CssW+92AEaIuJp4Lk+hZwK7mubeXzuNy7zMI2cmkr71YIyNTTZeTRFH8tdaj1MJTx/
         gS09RpkJobpa9iE3LZfkVJwatgPZzYIUt/eMNCfn965wEz12xD6+kzz6AQbObSRQgpXj
         igLRQOzCM9DL5UdSq+VAMlcdT6xNEzoEd3LZ2URl07gf2e0Dlh65d5GSp0myc5jnPXmT
         rI5H34vQL1KdEWaqx00MKTxfFWYm7YNi52LeIEtshwtVfAnY6D2ReJI4iclsx63rRdbX
         pNGl/0UFp6oaadwUxAOqoM5xOk7C2LST91RuE+EGVas65OWDrNoWp0LMtCAEd173zGiM
         QnqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pbimq0V5/Dfkez/1F/zWqShQg9izS4DQzGvOoN6G2uc=;
        b=IsGuKGPLF/ykaw8aEmHVUUUAPxwaJfpEvMRy1058XzhimvNVeWJ3Pnz6OS0sD24DUk
         7oSD8W8p4YMVMO6Qm5mZh/h6oX6kEYIXO2MWpQhoGvMnO2Wq1b8iqj9Vof8kdGc/Ajzx
         YBGrMPwp73TWukRu0zB5Ec1MeL0uvMOqnF7Wp35gSpg9Vq5idXscPW7VklBRL92gLN98
         GcXs+Ee+xfivuEisOs68E6nqh115CQyG4kJ4kq70BSaT8EAx1I9+Wu1AXyKruERhaVud
         dbogLh+z8OUhJ20yMTjwGGklj3JKAbNsrjCNKLqQ2Kyt4EmwIWmcnB+B3QMh9Fxs3+CS
         A9Nw==
X-Gm-Message-State: AOAM531pSLe89hjazlDd30sgXlZLQ7X/TKT26d2/FZna5laTBa9IocNN
        Go138W1BgocW+5Bxlf1sM7QiGcJZ
X-Google-Smtp-Source: ABdhPJw5jQZR4UBYqMFB3ekXhx8wEcuUsjHJbim3M0LlD2bI+cigUtzZWoM43PqeayLS0M+UzDNNog==
X-Received: by 2002:a17:906:6146:: with SMTP id p6mr12463865ejl.433.1593519755677;
        Tue, 30 Jun 2020 05:22:35 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.85])
        by smtp.gmail.com with ESMTPSA id y2sm2820069eda.85.2020.06.30.05.22.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2020 05:22:35 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 4/8] io_uring: fix missing ->mm on exit
Date:   Tue, 30 Jun 2020 15:20:39 +0300
Message-Id: <0f2b8d6cdd39a965f70d1d4b22de5570a53691f8.1593519186.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1593519186.git.asml.silence@gmail.com>
References: <cover.1593519186.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

There is a fancy bug, where exiting user task may not have ->mm,
that makes task_works to try to do kthread_use_mm(ctx->sqo_mm).

Don't do that if sqo_mm is NULL.

[  290.460558] WARNING: CPU: 6 PID: 150933 at kernel/kthread.c:1238
	kthread_use_mm+0xf3/0x110
[  290.460579] CPU: 6 PID: 150933 Comm: read-write2 Tainted: G
	I E     5.8.0-rc2-00066-g9b21720607cf #531
[  290.460580] RIP: 0010:kthread_use_mm+0xf3/0x110
...
[  290.460584] Call Trace:
[  290.460584]  __io_sq_thread_acquire_mm.isra.0.part.0+0x25/0x30
[  290.460584]  __io_req_task_submit+0x64/0x80
[  290.460584]  io_req_task_submit+0x15/0x20
[  290.460585]  task_work_run+0x67/0xa0
[  290.460585]  do_exit+0x35d/0xb70
[  290.460585]  do_group_exit+0x43/0xa0
[  290.460585]  get_signal+0x140/0x900
[  290.460586]  do_signal+0x37/0x780
[  290.460586]  __prepare_exit_to_usermode+0x126/0x1c0
[  290.460586]  __syscall_return_slowpath+0x3b/0x1c0
[  290.460587]  do_syscall_64+0x5f/0xa0
[  290.460587]  entry_SYSCALL_64_after_hwframe+0x44/0xa9

following with faults.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 776f593a5bf3..c7986c27272e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -958,7 +958,7 @@ static void io_sq_thread_drop_mm(struct io_ring_ctx *ctx)
 static int __io_sq_thread_acquire_mm(struct io_ring_ctx *ctx)
 {
 	if (!current->mm) {
-		if (unlikely(!mmget_not_zero(ctx->sqo_mm)))
+		if (unlikely(!ctx->sqo_mm || !mmget_not_zero(ctx->sqo_mm)))
 			return -EFAULT;
 		kthread_use_mm(ctx->sqo_mm);
 	}
@@ -7212,10 +7212,10 @@ static int io_sq_offload_start(struct io_ring_ctx *ctx,
 {
 	int ret;
 
-	mmgrab(current->mm);
-	ctx->sqo_mm = current->mm;
-
 	if (ctx->flags & IORING_SETUP_SQPOLL) {
+		mmgrab(current->mm);
+		ctx->sqo_mm = current->mm;
+
 		ret = -EPERM;
 		if (!capable(CAP_SYS_ADMIN))
 			goto err;
@@ -7259,8 +7259,10 @@ static int io_sq_offload_start(struct io_ring_ctx *ctx,
 	return 0;
 err:
 	io_finish_async(ctx);
-	mmdrop(ctx->sqo_mm);
-	ctx->sqo_mm = NULL;
+	if (ctx->sqo_mm) {
+		mmdrop(ctx->sqo_mm);
+		ctx->sqo_mm = NULL;
+	}
 	return ret;
 }
 
-- 
2.24.0

