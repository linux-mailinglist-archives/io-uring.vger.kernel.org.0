Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACB3635D51E
	for <lists+io-uring@lfdr.de>; Tue, 13 Apr 2021 04:03:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245348AbhDMCDb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 12 Apr 2021 22:03:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245183AbhDMCDa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 12 Apr 2021 22:03:30 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9ADFC061574
        for <io-uring@vger.kernel.org>; Mon, 12 Apr 2021 19:03:11 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id w4so11055228wrt.5
        for <io-uring@vger.kernel.org>; Mon, 12 Apr 2021 19:03:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=fSq3/gd3oUythXAR8rDJiTRRQnh9nEoRskewKWWVFSU=;
        b=BiOsmkQLadta9a2Uc1Z/eD1aWIX2CasTIBem89dsq6qD+7wb32Hh9tM3ubrmvPsIiJ
         fe4hVdbGrTJ+4g0XgoDHyXyGxObipG3jN2d/aRx6H71eVT9K9xOe+33XjdfSdRfEVFNe
         Z28CjHvazXuGdRAvOVZug2zo6BSR8i3b+sWNEdcbPzFHVR3J7ts8m/fyZP0UHF2RQ78A
         Rdx8/3gbwnQqD+ElByA1CSy8M0QVsrSdBYLNuJiFxR0QqDGJa4iGK+C/vplGGbZmCJgA
         fMpmKp1mp2gRY65jdTVAG+o8ot5vQpo9DFtGkCUbQRwjzUs6Glg7W2rIoH+CBwncQ45V
         ampQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fSq3/gd3oUythXAR8rDJiTRRQnh9nEoRskewKWWVFSU=;
        b=b7o8v9RxjZed3BzPUdqVm1Jej3LXPqGFFUcvv/wuXYAOYZiPywWVrR26kdMuoz0HMY
         r8Nr88UoHoNZSCGO6w4J97yNigpvojUgDqQToVeg3tnDGqu/G5PyokNZ3RCaKLL/W058
         HT9xHFGrpDdUBg6eq6NegjVLVSAb2JOSSw6eqYmyRJzFvSSANIFvl4JHOmMYLsgj26J5
         r8DfUc4FFZoYXXMGsJSwFNwxc5eKb/Dj9ENk6GVoUJnt+kwx1XOO83rwtdX0a6UnHSYh
         dbEXiN73Iw3lK8L++YM1FiGEADlpOJ0zEKUBYv9B0zKp+Gd3nk31dmqRqMnIHzjENWV6
         T90A==
X-Gm-Message-State: AOAM5311Gquxb0Z/EzfHHzayBRedakMY5Y6SqvXehBdN7oAKqXw/R7FZ
        cnsm5+okgdv8Kuws0+vFDfgO1LjUd7Q=
X-Google-Smtp-Source: ABdhPJw5p/s1nNzYvuzpfhr0KrOtLBBk0DLUiixjOCX/e5A7cLoZ0qmCWBGYksYQrgq0KJ75ugUVFQ==
X-Received: by 2002:a5d:6ac6:: with SMTP id u6mr12657699wrw.290.1618279390725;
        Mon, 12 Apr 2021 19:03:10 -0700 (PDT)
Received: from localhost.localdomain ([148.252.128.208])
        by smtp.gmail.com with ESMTPSA id k7sm18771331wrw.64.2021.04.12.19.03.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Apr 2021 19:03:10 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 9/9] io_uring: inline io_iopoll_getevents()
Date:   Tue, 13 Apr 2021 02:58:46 +0100
Message-Id: <7e50b8917390f38bee4f822c6f4a6a98a27be037.1618278933.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1618278933.git.asml.silence@gmail.com>
References: <cover.1618278933.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_iopoll_getevents() is of no use to us anymore, io_iopoll_check()
handles all the cases.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 52 +++++++++++++--------------------------------------
 1 file changed, 13 insertions(+), 39 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 1111968bbe7f..05c67ebeabd5 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2331,27 +2331,6 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, unsigned int *nr_events,
 	return ret;
 }
 
-/*
- * Poll for a minimum of 'min' events. Note that if min == 0 we consider that a
- * non-spinning poll check - we'll still enter the driver poll loop, but only
- * as a non-spinning completion check.
- */
-static int io_iopoll_getevents(struct io_ring_ctx *ctx, unsigned int *nr_events,
-				long min)
-{
-	while (!list_empty(&ctx->iopoll_list) && !need_resched()) {
-		int ret;
-
-		ret = io_do_iopoll(ctx, nr_events, min);
-		if (ret < 0)
-			return ret;
-		if (*nr_events >= min)
-			return 0;
-	}
-
-	return 1;
-}
-
 /*
  * We can't just wait for polled events to come to us, we have to actively
  * find and complete them.
@@ -2395,17 +2374,16 @@ static int io_iopoll_check(struct io_ring_ctx *ctx, long min)
 	 * that got punted to a workqueue.
 	 */
 	mutex_lock(&ctx->uring_lock);
+	/*
+	 * Don't enter poll loop if we already have events pending.
+	 * If we do, we can potentially be spinning for commands that
+	 * already triggered a CQE (eg in error).
+	 */
+	if (test_bit(0, &ctx->cq_check_overflow))
+		__io_cqring_overflow_flush(ctx, false);
+	if (io_cqring_events(ctx))
+		goto out;
 	do {
-		/*
-		 * Don't enter poll loop if we already have events pending.
-		 * If we do, we can potentially be spinning for commands that
-		 * already triggered a CQE (eg in error).
-		 */
-		if (test_bit(0, &ctx->cq_check_overflow))
-			__io_cqring_overflow_flush(ctx, false);
-		if (io_cqring_events(ctx))
-			break;
-
 		/*
 		 * If a submit got punted to a workqueue, we can have the
 		 * application entering polling for a command before it gets
@@ -2424,13 +2402,9 @@ static int io_iopoll_check(struct io_ring_ctx *ctx, long min)
 			if (list_empty(&ctx->iopoll_list))
 				break;
 		}
-
-		ret = io_iopoll_getevents(ctx, &nr_events, min);
-		if (ret <= 0)
-			break;
-		ret = 0;
-	} while (min && !nr_events && !need_resched());
-
+		ret = io_do_iopoll(ctx, &nr_events, min);
+	} while (!ret && nr_events < min && !need_resched());
+out:
 	mutex_unlock(&ctx->uring_lock);
 	return ret;
 }
@@ -2543,7 +2517,7 @@ static void io_complete_rw_iopoll(struct kiocb *kiocb, long res, long res2)
 /*
  * After the iocb has been issued, it's safe to be found on the poll list.
  * Adding the kiocb to the list AFTER submission ensures that we don't
- * find it from a io_iopoll_getevents() thread before the issuer is done
+ * find it from a io_do_iopoll() thread before the issuer is done
  * accessing the kiocb cookie.
  */
 static void io_iopoll_req_issued(struct io_kiocb *req, bool in_async)
-- 
2.24.0

