Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A4683EC862
	for <lists+io-uring@lfdr.de>; Sun, 15 Aug 2021 11:41:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237218AbhHOJli (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 15 Aug 2021 05:41:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237141AbhHOJlh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 15 Aug 2021 05:41:37 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C827DC061764
        for <io-uring@vger.kernel.org>; Sun, 15 Aug 2021 02:41:07 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id h24-20020a1ccc180000b029022e0571d1a0so9685402wmb.5
        for <io-uring@vger.kernel.org>; Sun, 15 Aug 2021 02:41:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=rjhvQSylH13k8DBcnY1LH1uNbY8g44ShTPrhPTHp0YA=;
        b=uOeZkHLsSbD+F8kL4lPDbBRB3PThe+zuY1G/WQcldFaqFMOU8KDmgTkXssKFyLFO/z
         qtM/eIksZqmatvFDDuNQ7ienh3QEUDJuaLgoBLiDuyFR68IiO/r0bf5JKElpkxyCF396
         4hIxSYMr35LeWJoFo3Uqhc+uHJi1NsDN86r7RGw4X59c6rv8zZpk4fp+ARdztDL4Kn/7
         dwo8qcn2j81/IbODSQFfY5E11v82xIesgInT7g0AKnGbVxWFwXDLINI2SUHInOxGRV4k
         WQb0j7KOiVozOOpGDmMUb2NK+32Fxfn6YyXa39X7tssNw3DIg6PmVN0uCaFwszrpbbGy
         RhvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rjhvQSylH13k8DBcnY1LH1uNbY8g44ShTPrhPTHp0YA=;
        b=T6A2MYPUEr1D8uj357y4TA9Sdf98ckzbepg56oP9v0VoFfy/Wr2iz+OqJ1FOARmFOA
         iDGIm1UtISGC3JosTsaz32PC8As8L6Rb2Hq+4w6sowmF//yTO8gjzFXi1sLBrZ1bylmB
         jKDCUFn9s9Js1GtR868deCtDWN5bsAiTEfoFTUmsX+LcG5/d0LKp0K+yIUxA6kaN8yTR
         k1HX/HZShJrrGZXBXO9VF6qeWuAfCbOQk5OjS795JX/IbS6gpKd2YHbyY5W0TkYo1bMU
         dyO2R1ICio8syEVh7+0Xyc8T3d2TPDD4XBIHJIRJUNwc0wX99TNdRiLJiscCaNdc1D5w
         oRnw==
X-Gm-Message-State: AOAM532M/LjLwDV56eOIL8dKr+L4dZ2ZRo/c0LRSKqZXkZQc5ISOmdbP
        62pxwShDJYZ4Bziu/xDm4xCx3FN9nsU=
X-Google-Smtp-Source: ABdhPJwf0/whHtO9339MTpu+vZfOrKh2iFiRHUyTe/l1MdaXPkhc95uAhpNP5TfS6j+C7I2ZmoiITQ==
X-Received: by 2002:a1c:3c87:: with SMTP id j129mr10231440wma.54.1629020466491;
        Sun, 15 Aug 2021 02:41:06 -0700 (PDT)
Received: from localhost.localdomain ([148.252.133.97])
        by smtp.gmail.com with ESMTPSA id t8sm8828815wrx.27.2021.08.15.02.41.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Aug 2021 02:41:06 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 4/9] io_uring: kill not necessary resubmit switch
Date:   Sun, 15 Aug 2021 10:40:21 +0100
Message-Id: <47fa177cca04e5ffd308a35227966c8e15d8525b.1628981736.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1628981736.git.asml.silence@gmail.com>
References: <cover.1628981736.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

773af69121ecc ("io_uring: always reissue from task_work context") makes
all resubmission to be made from task_work, so we don't need that hack
with resubmit/not-resubmit switch anymore.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d2b968c8111f..fb3b07c0f15a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2291,7 +2291,7 @@ static inline bool io_run_task_work(void)
  * Find and free completed poll iocbs
  */
 static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
-			       struct list_head *done, bool resubmit)
+			       struct list_head *done)
 {
 	struct req_batch rb;
 	struct io_kiocb *req;
@@ -2306,7 +2306,7 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
 		req = list_first_entry(done, struct io_kiocb, inflight_entry);
 		list_del(&req->inflight_entry);
 
-		if (READ_ONCE(req->result) == -EAGAIN && resubmit &&
+		if (READ_ONCE(req->result) == -EAGAIN &&
 		    !(req->flags & REQ_F_DONT_REISSUE)) {
 			req->iopoll_completed = 0;
 			io_req_task_queue_reissue(req);
@@ -2329,7 +2329,7 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
 }
 
 static int io_do_iopoll(struct io_ring_ctx *ctx, unsigned int *nr_events,
-			long min, bool resubmit)
+			long min)
 {
 	struct io_kiocb *req, *tmp;
 	LIST_HEAD(done);
@@ -2369,7 +2369,7 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, unsigned int *nr_events,
 	}
 
 	if (!list_empty(&done))
-		io_iopoll_complete(ctx, nr_events, &done, resubmit);
+		io_iopoll_complete(ctx, nr_events, &done);
 
 	return 0;
 }
@@ -2387,7 +2387,7 @@ static void io_iopoll_try_reap_events(struct io_ring_ctx *ctx)
 	while (!list_empty(&ctx->iopoll_list)) {
 		unsigned int nr_events = 0;
 
-		io_do_iopoll(ctx, &nr_events, 0, false);
+		io_do_iopoll(ctx, &nr_events, 0);
 
 		/* let it sleep and repeat later if can't complete a request */
 		if (nr_events == 0)
@@ -2449,7 +2449,7 @@ static int io_iopoll_check(struct io_ring_ctx *ctx, long min)
 			    list_empty(&ctx->iopoll_list))
 				break;
 		}
-		ret = io_do_iopoll(ctx, &nr_events, min, true);
+		ret = io_do_iopoll(ctx, &nr_events, min);
 	} while (!ret && nr_events < min && !need_resched());
 out:
 	mutex_unlock(&ctx->uring_lock);
@@ -6855,7 +6855,7 @@ static int __io_sq_thread(struct io_ring_ctx *ctx, bool cap_entries)
 
 		mutex_lock(&ctx->uring_lock);
 		if (!list_empty(&ctx->iopoll_list))
-			io_do_iopoll(ctx, &nr_events, 0, true);
+			io_do_iopoll(ctx, &nr_events, 0);
 
 		/*
 		 * Don't submit if refs are dying, good for io_uring_register(),
-- 
2.32.0

