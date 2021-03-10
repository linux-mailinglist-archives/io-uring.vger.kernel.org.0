Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA97D334BD5
	for <lists+io-uring@lfdr.de>; Wed, 10 Mar 2021 23:45:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233933AbhCJWon (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 10 Mar 2021 17:44:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233937AbhCJWoW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 10 Mar 2021 17:44:22 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6A92C061762
        for <io-uring@vger.kernel.org>; Wed, 10 Mar 2021 14:44:21 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id n17so5678793plc.7
        for <io-uring@vger.kernel.org>; Wed, 10 Mar 2021 14:44:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=59YkVLHv9p4gDp+PspYIzvk09Z0rD1LrFtUWdlBVLaA=;
        b=YfurdH5po3utSwvVL1T8o6Q2VyLLK3DFesPuGJ+lQvepc24hU/BzH968wt5mvdSuwH
         QzHTiZJuamaQs5OSaOaifiJobTuPvygZ3ph9B8tvTX1KyW6GtIl1oRCnehQY+r8r4C2N
         fwUqpZLytUoQmSknDltMKvGEiFqs/g/3EY5H0VWIj19NtpQpTk/qSeSC1kYrooz8q5VO
         U3yg+UQeFvUY8/FmOJFQgKdyZ/6y/K5LfqmKZwtr9YdR6hX+Dk3QR1mN1SiNJ++adSvl
         NUHk335F43uIPq/ggBUufEfJ0JXiK3s/MVIwD/EcMVU2GmqvR2N4rQMbwf+gSgQAn2Rz
         Rx5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=59YkVLHv9p4gDp+PspYIzvk09Z0rD1LrFtUWdlBVLaA=;
        b=C8zUqRxWTvdBtawQPBL/2zxcVgb4A6uh+lUnwoVjWyFf08vP7fKt8VjrcHkz8DUejC
         lb6RW5X8kuEQhJrcpAWMggjSlCkmasqvTDE6muNIcXfUf5qQFq25uA1H3O2Zf9irbM4I
         irO2l+LhJ9vvzp53ZxJxa7tEmnhNN6Og6aFDcZE4hBvXRlAYS4nVZKBadVbutamResv7
         cnpw4RakLK2HmPSU7/hoxuveV3gLL+TZTkOE6ctm9mMGqprJh4pX5DlMZW6E279TgjqS
         7cgVTsUZmXtpGcHyTp38ec87StEYIf8AcVJp+O7m+y2Z5W0UL4xu/EIqDEh9QXmoGi2D
         B3cg==
X-Gm-Message-State: AOAM533T75sUop5MvCKPK76gkLdH1KO9BjdTRQ6Av1vMhSeGSyKquvNw
        mDBDxLuzT8AL5xxnT5aopmCIUygYoaevLg==
X-Google-Smtp-Source: ABdhPJxGiQma0+8a6Ges+1MFo+TrH07glM/OQFYQpcv707UC7ARlgRv//8T6v8EOdQiNyJEYvgKONg==
X-Received: by 2002:a17:902:a617:b029:e5:b41e:4d7b with SMTP id u23-20020a170902a617b02900e5b41e4d7bmr5224024plq.33.1615416259770;
        Wed, 10 Mar 2021 14:44:19 -0800 (PST)
Received: from localhost.localdomain ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id j23sm475783pfn.94.2021.03.10.14.44.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 14:44:19 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 15/27] io_uring: clean R_DISABLED startup mess
Date:   Wed, 10 Mar 2021 15:43:46 -0700
Message-Id: <20210310224358.1494503-16-axboe@kernel.dk>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210310224358.1494503-1-axboe@kernel.dk>
References: <20210310224358.1494503-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

There are enough of problems with IORING_SETUP_R_DISABLED, including the
burden of checking and kicking off the SQO task all over the codebase --
for exit/cancel/etc.

Rework it, always start the thread but don't do submit unless the flag
is gone, that's much easier.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 25 ++++++-------------------
 1 file changed, 6 insertions(+), 19 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d4f018f5838d..3f6db813d670 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6606,7 +6606,8 @@ static int __io_sq_thread(struct io_ring_ctx *ctx, bool cap_entries)
 		if (!list_empty(&ctx->iopoll_list))
 			io_do_iopoll(ctx, &nr_events, 0);
 
-		if (to_submit && likely(!percpu_ref_is_dying(&ctx->refs)))
+		if (to_submit && likely(!percpu_ref_is_dying(&ctx->refs)) &&
+		    !(ctx->flags & IORING_SETUP_R_DISABLED))
 			ret = io_submit_sqes(ctx, to_submit);
 		mutex_unlock(&ctx->uring_lock);
 	}
@@ -7861,6 +7862,7 @@ static int io_sq_offload_create(struct io_ring_ctx *ctx,
 		wake_up_new_task(tsk);
 		if (ret)
 			goto err;
+		complete(&sqd->startup);
 	} else if (p->flags & IORING_SETUP_SQ_AFF) {
 		/* Can't have SQ_AFF without SQPOLL */
 		ret = -EINVAL;
@@ -7873,15 +7875,6 @@ static int io_sq_offload_create(struct io_ring_ctx *ctx,
 	return ret;
 }
 
-static void io_sq_offload_start(struct io_ring_ctx *ctx)
-{
-	struct io_sq_data *sqd = ctx->sq_data;
-
-	ctx->flags &= ~IORING_SETUP_R_DISABLED;
-	if (ctx->flags & IORING_SETUP_SQPOLL)
-		complete(&sqd->startup);
-}
-
 static inline void __io_unaccount_mem(struct user_struct *user,
 				      unsigned long nr_pages)
 {
@@ -8742,11 +8735,6 @@ static void io_uring_cancel_task_requests(struct io_ring_ctx *ctx,
 	struct task_struct *task = current;
 
 	if ((ctx->flags & IORING_SETUP_SQPOLL) && ctx->sq_data) {
-		/* never started, nothing to cancel */
-		if (ctx->flags & IORING_SETUP_R_DISABLED) {
-			io_sq_offload_start(ctx);
-			return;
-		}
 		io_sq_thread_park(ctx->sq_data);
 		task = ctx->sq_data->thread;
 		if (task)
@@ -9449,9 +9437,6 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p,
 	if (ret)
 		goto err;
 
-	if (!(p->flags & IORING_SETUP_R_DISABLED))
-		io_sq_offload_start(ctx);
-
 	memset(&p->sq_off, 0, sizeof(p->sq_off));
 	p->sq_off.head = offsetof(struct io_rings, sq.head);
 	p->sq_off.tail = offsetof(struct io_rings, sq.tail);
@@ -9668,7 +9653,9 @@ static int io_register_enable_rings(struct io_ring_ctx *ctx)
 	if (ctx->restrictions.registered)
 		ctx->restricted = 1;
 
-	io_sq_offload_start(ctx);
+	ctx->flags &= ~IORING_SETUP_R_DISABLED;
+	if (ctx->sq_data && wq_has_sleeper(&ctx->sq_data->wait))
+		wake_up(&ctx->sq_data->wait);
 	return 0;
 }
 
-- 
2.30.2

