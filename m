Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2FDA2EC90C
	for <lists+io-uring@lfdr.de>; Thu,  7 Jan 2021 04:20:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726233AbhAGDUD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 6 Jan 2021 22:20:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725803AbhAGDUD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 6 Jan 2021 22:20:03 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4C7AC0612F3
        for <io-uring@vger.kernel.org>; Wed,  6 Jan 2021 19:19:22 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id 190so3998271wmz.0
        for <io-uring@vger.kernel.org>; Wed, 06 Jan 2021 19:19:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yOdgAZJ+XZWIMsOlJNaeylUW56cEEjUTXCA8TNzAGYA=;
        b=nBUngJAZv9GnLprDNkiUVPeBIALYV952rQXhw77tRQSRJdAwNGs3cEyzlvurTuLiuC
         +Qe6Vc5t31pZJYVQWsx2kKh/Pc/YELR6YgHd3rpE8rQxXcKBc3WSIjuqq86oMWGnM3Gw
         d/rT07y4JFCbRHCQNy4qc4jmiqXvmyfFlzPqalerHj8qYQuz4xkugiK48O39Y+C2qXxH
         SrPtwSfGbZa5zy7h0mYKzy2Vr+VNLkC2AQdgsQ4UcoGsbCkBcm97HBjuSHFwvxl566BQ
         t1nDH2xdZjJbywm0e/HdU9SbyQ1prAH3ndeCsI29hznsKR4LuWuo6QMlPrGxbcxH5JRB
         Mcxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yOdgAZJ+XZWIMsOlJNaeylUW56cEEjUTXCA8TNzAGYA=;
        b=cseufcEkh4PwT+gBqJ5FkeEdSOZOuvzjenMNC8QKKTI14vcgdOfHhEw5uYGHIZEHZi
         7K0Su0K73ccALAAAp5zzwnfPJHxqS1bp16II+hJhorlcQ44N50lHzqrSzT7TTyWaj4BH
         lwo3y7VgJoj9Tfee7SQa65pk8sFwmJZwptudJ0hO5pgp105mfnFb9P+Krq7empOzsJLZ
         JimL+P4iCn9CBgfQdKxR1ZkEB248R+YqKslJlm+/oHWpbVGdSTRbsK62RhiN1urqMelw
         6/PiKQySXerBqhXI/kxEwOE4SpSfRzm7cGlhoNkOMEb4oP0ksyPYu+u1a7ntwzykwTIc
         RXBQ==
X-Gm-Message-State: AOAM530vosA3TCo41XuuJrlDpCGHwv9u7ECwYOjQB6ECc1+F5rmY6okS
        90CLg1N/qCgnku0XXqU70ayMLre2nP6AFg==
X-Google-Smtp-Source: ABdhPJzJ7H/16HJwl87h0RHOGsq74kUNro57MpCnzeBUEr0rqisGLbMQuzoKu07cbyGV2B9eudgmNA==
X-Received: by 2002:a1c:3987:: with SMTP id g129mr5986843wma.86.1609989561495;
        Wed, 06 Jan 2021 19:19:21 -0800 (PST)
Received: from localhost.localdomain ([185.69.144.125])
        by smtp.gmail.com with ESMTPSA id t1sm6181430wro.27.2021.01.06.19.19.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jan 2021 19:19:21 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     syzbot+91ca3f25bd7f795f019c@syzkaller.appspotmail.com
Subject: [PATCH 2/3] io_uring: dont kill fasync under completion_lock
Date:   Thu,  7 Jan 2021 03:15:42 +0000
Message-Id: <24eb9919fd63d08075a2d5d82d69ccdd210ec0b8.1609988832.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1609988832.git.asml.silence@gmail.com>
References: <cover.1609988832.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

      CPU0                    CPU1
       ----                    ----
  lock(&new->fa_lock);
                               local_irq_disable();
                               lock(&ctx->completion_lock);
                               lock(&new->fa_lock);
  <Interrupt>
    lock(&ctx->completion_lock);

 *** DEADLOCK ***

Move kill_fasync() out of io_commit_cqring() to io_cqring_ev_posted(),
so it doesn't hold completion_lock while doing it. That saves from the
reported deadlock, and it's just nice to shorten the locking time and
untangle nested locks (compl_lock -> wq_head::lock).

Reported-by: syzbot+91ca3f25bd7f795f019c@syzkaller.appspotmail.com
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 91e517ad1421..401316fe2ae2 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1345,11 +1345,6 @@ static void __io_commit_cqring(struct io_ring_ctx *ctx)
 
 	/* order cqe stores with ring update */
 	smp_store_release(&rings->cq.tail, ctx->cached_cq_tail);
-
-	if (wq_has_sleeper(&ctx->cq_wait)) {
-		wake_up_interruptible(&ctx->cq_wait);
-		kill_fasync(&ctx->cq_fasync, SIGIO, POLL_IN);
-	}
 }
 
 static void io_put_identity(struct io_uring_task *tctx, struct io_kiocb *req)
@@ -1711,6 +1706,10 @@ static void io_cqring_ev_posted(struct io_ring_ctx *ctx)
 		wake_up(&ctx->sq_data->wait);
 	if (io_should_trigger_evfd(ctx))
 		eventfd_signal(ctx->cq_ev_fd, 1);
+	if (wq_has_sleeper(&ctx->cq_wait)) {
+		wake_up_interruptible(&ctx->cq_wait);
+		kill_fasync(&ctx->cq_fasync, SIGIO, POLL_IN);
+	}
 }
 
 static void io_cqring_ev_posted_iopoll(struct io_ring_ctx *ctx)
@@ -1721,6 +1720,10 @@ static void io_cqring_ev_posted_iopoll(struct io_ring_ctx *ctx)
 	}
 	if (io_should_trigger_evfd(ctx))
 		eventfd_signal(ctx->cq_ev_fd, 1);
+	if (wq_has_sleeper(&ctx->cq_wait)) {
+		wake_up_interruptible(&ctx->cq_wait);
+		kill_fasync(&ctx->cq_fasync, SIGIO, POLL_IN);
+	}
 }
 
 /* Returns true if there are no backlogged entries after the flush */
-- 
2.24.0

