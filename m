Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E06B2E8F56
	for <lists+io-uring@lfdr.de>; Mon,  4 Jan 2021 03:04:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727814AbhADCDo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 3 Jan 2021 21:03:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727815AbhADCDl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 3 Jan 2021 21:03:41 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 579ECC061796
        for <io-uring@vger.kernel.org>; Sun,  3 Jan 2021 18:03:01 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id m5so30658403wrx.9
        for <io-uring@vger.kernel.org>; Sun, 03 Jan 2021 18:03:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wuML8Vypd7iVsM2CZvQNj9M2GCjVfPufUjoOoJe/Aas=;
        b=dlaz3xvGU05/Idxv6vqCBzjv/TQTVUySO/qxtG4zTSeqMpCF+n9B52uxEdBzxLl2/D
         fK9suipFWqf7S+MSziyo9VryzW423FiPYhk59O4mQ+qp49OtjhTIuBet1kkQzuLv8uYi
         MsGD5bdkeAfsnfnKP6FXPtM8uChZTaoo2oWZXhvnwA0lVmsgFKQ0SClLkVHEtkd30idm
         Hr2D94yzP/Tp77fjab45xmgfz6vSZQqCY1ndBj9zKNJAdNE2ihjf4wN9olDuuVb56SJA
         Dhm4aQ/jRuCQXu7jRXjK8ErUDNTImw0dGazICai7j/VfaPZtEIrQDFBQCT7TONQIvcD8
         yHlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wuML8Vypd7iVsM2CZvQNj9M2GCjVfPufUjoOoJe/Aas=;
        b=WkbIJLk4NjnyypfNj5aDRA8B/TQKtyUhce++KS4SmQmA2YPslgzm8Dc9dNo2tbB/uw
         +TFHMxeKUFPIxHovxbPOzMAIIWb5PnjkduqqKitRkbmrm2ja7JrUpvHK1vtk7eY2re2f
         48kw2N8fTtQkrrLNBp9idIiZD0Dh+YuugYyXBki6NpvQn3wRKdHIN9YdZ8HfKiY/1hNA
         F25+gYD0VED3SZCu9Y8qGrbRW2FSPxAlsiqljrDQcUZsHR4EHz2upJhbu0pDur8+9m0G
         ZAP5q2cQWM7DoaGwQcx7DYvBAOITz4HrkHBF7MmCNtROW7lflq2ZpLaXSi4PWYElmGdV
         XGIg==
X-Gm-Message-State: AOAM530eDS5Ls46vZJoEGiAhxefxG6Q46QY2ShFWYQKBSRwryUwLq5Zc
        lFjRbphmL+aS23dTcIJXqjM=
X-Google-Smtp-Source: ABdhPJxmy5Cq+0bx00JcGZYJOOOzJJEri4r6Gcc7xZCjYoI4CREFLf7IpIcdQzXc7xyKp65tDBIUQg==
X-Received: by 2002:a5d:4241:: with SMTP id s1mr78055452wrr.269.1609725780199;
        Sun, 03 Jan 2021 18:03:00 -0800 (PST)
Received: from localhost.localdomain ([85.255.233.205])
        by smtp.gmail.com with ESMTPSA id c4sm96632893wrw.72.2021.01.03.18.02.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Jan 2021 18:02:59 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     syzbot+91ca3f25bd7f795f019c@syzkaller.appspotmail.com
Subject: [PATCH v2 4/6] io_uring: dont kill fasync under completion_lock
Date:   Mon,  4 Jan 2021 01:59:17 +0000
Message-Id: <bf17089a9bcf65375a70b527fce21f56620f8d1d.1609725418.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1609725418.git.asml.silence@gmail.com>
References: <cover.1609725418.git.asml.silence@gmail.com>
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
index 2beb1e72302d..9c554adf3993 100644
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
@@ -1713,6 +1708,10 @@ static void io_cqring_ev_posted(struct io_ring_ctx *ctx)
 		wake_up(&ctx->sq_data->wait);
 	if (io_should_trigger_evfd(ctx))
 		eventfd_signal(ctx->cq_ev_fd, 1);
+	if (wq_has_sleeper(&ctx->cq_wait)) {
+		wake_up_interruptible(&ctx->cq_wait);
+		kill_fasync(&ctx->cq_fasync, SIGIO, POLL_IN);
+	}
 }
 
 static void io_cqring_ev_posted_iopoll(struct io_ring_ctx *ctx)
@@ -1723,6 +1722,10 @@ static void io_cqring_ev_posted_iopoll(struct io_ring_ctx *ctx)
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

