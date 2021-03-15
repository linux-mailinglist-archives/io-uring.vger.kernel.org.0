Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 613A333BCAE
	for <lists+io-uring@lfdr.de>; Mon, 15 Mar 2021 15:35:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231597AbhCOO2L (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 15 Mar 2021 10:28:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238916AbhCOO1Q (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 15 Mar 2021 10:27:16 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0521C06175F
        for <io-uring@vger.kernel.org>; Mon, 15 Mar 2021 07:27:15 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id j7so5795342wrd.1
        for <io-uring@vger.kernel.org>; Mon, 15 Mar 2021 07:27:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=2hobndD8jyfEotv2Q5BKA841L/LR8CQWWHs0E6nt+00=;
        b=gJGB8FuBrPPwqwquWygkfE5UUjXfPD+t74d1IhiudueYOfbw7txndQqKakIrmxZTV5
         WSlU25j/f4UA1BW7DTzR8hOeUQy53yyzStX0MQS0/N289exSzm3+r+Zij7r51gKXaG9n
         CRpbGfQ8xcLl2ju0pHMQXP0JoPn11oGD4c3BNslSj/Kh35xHw4XJDGFELE4JRr6GyJNa
         IExNmnkb020/dNllzqxCqWYGr3jxmUMxMZmBmHlm7ZxmyxP09SObw39j8+Y2xetVUieU
         c0HROyBRRyiuc2tzmkxRvKk/C1Hxk84hYCf7SqJpp/DVVT7afiUVhcJS4jBJPCVzyzGI
         qnFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2hobndD8jyfEotv2Q5BKA841L/LR8CQWWHs0E6nt+00=;
        b=dAbceadNHK3YzOYtYByg9GkQVXQve3wRpnfd0+UP1pD3LMnUWS68wervJhhyOqE140
         G0uR8FX865fEcKo09XnWy6SDov+yFPEbhynVye6B5vKCIKLQrViaVApY43a1NPerMRbc
         bvQNeIroL1b5zUogU8pmeMgicpwpWW+WHVcpNdoGfaO1ukFkKhdr1gPkaJ2wsbP8pm7V
         PRp00J1qpUuvvmd7bGDHzeeeCY2/vjL4LifUc2Qggc87DOse5YBL1RysADCi32eT564o
         +XQsxxdM09Dk87gU4FilpBvQvr+fqs7QlYMblCN3id9xM2wFff7MiWXGTPPE5SNZerNc
         ZXDQ==
X-Gm-Message-State: AOAM533ryt1WecHpzqX0NrxQtG2IuuBge+VMAfTrRwswXKAmpIaxXR1i
        GTXiqaqjPtHDgG4Y7DaP6oeXCIhVrGc=
X-Google-Smtp-Source: ABdhPJzTgSgReLUqBUyJqazB81mJPucmhXXNvgpcQ62HJoGQ6zXU62+rnOc9IzInW4C7pQvn0J/UXA==
X-Received: by 2002:adf:e582:: with SMTP id l2mr27835808wrm.207.1615818434652;
        Mon, 15 Mar 2021 07:27:14 -0700 (PDT)
Received: from localhost.localdomain ([148.252.132.232])
        by smtp.gmail.com with ESMTPSA id u9sm8782168wmc.38.2021.03.15.07.27.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 07:27:14 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 1/2] io_uring: add generic callback_head helpers
Date:   Mon, 15 Mar 2021 14:23:07 +0000
Message-Id: <46a140d2a7217d28b57cf26cbd9dd516bcf8fe65.1615818144.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1615818144.git.asml.silence@gmail.com>
References: <cover.1615818144.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We already have helpers to run/add callback_head but taking ctx and
working with ctx->exit_task_work. Extract generic versions of them
implemented in terms of struct callback_head, it will be used later.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 62 ++++++++++++++++++++++++++++++---------------------
 1 file changed, 36 insertions(+), 26 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 9fb4bc5f063b..f396063b4798 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1926,17 +1926,44 @@ static int io_req_task_work_add(struct io_kiocb *req)
 	return ret;
 }
 
-static void io_req_task_work_add_fallback(struct io_kiocb *req,
-					  task_work_func_t cb)
+static bool io_run_task_work_head(struct callback_head **work_head)
+{
+	struct callback_head *work, *next;
+	bool executed = false;
+
+	do {
+		work = xchg(work_head, NULL);
+		if (!work)
+			break;
+
+		do {
+			next = work->next;
+			work->func(work);
+			work = next;
+			cond_resched();
+		} while (work);
+		executed = true;
+	} while (1);
+
+	return executed;
+}
+
+static void io_task_work_add_head(struct callback_head **work_head,
+				  struct callback_head *task_work)
 {
-	struct io_ring_ctx *ctx = req->ctx;
 	struct callback_head *head;
 
-	init_task_work(&req->task_work, cb);
 	do {
-		head = READ_ONCE(ctx->exit_task_work);
-		req->task_work.next = head;
-	} while (cmpxchg(&ctx->exit_task_work, head, &req->task_work) != head);
+		head = READ_ONCE(*work_head);
+		task_work->next = head;
+	} while (cmpxchg(work_head, head, task_work) != head);
+}
+
+static void io_req_task_work_add_fallback(struct io_kiocb *req,
+					  task_work_func_t cb)
+{
+	init_task_work(&req->task_work, cb);
+	io_task_work_add_head(&req->ctx->exit_task_work, &req->task_work);
 }
 
 static void __io_req_task_cancel(struct io_kiocb *req, int error)
@@ -8468,26 +8495,9 @@ static int io_unregister_personality(struct io_ring_ctx *ctx, unsigned id)
 	return -EINVAL;
 }
 
-static bool io_run_ctx_fallback(struct io_ring_ctx *ctx)
+static inline bool io_run_ctx_fallback(struct io_ring_ctx *ctx)
 {
-	struct callback_head *work, *next;
-	bool executed = false;
-
-	do {
-		work = xchg(&ctx->exit_task_work, NULL);
-		if (!work)
-			break;
-
-		do {
-			next = work->next;
-			work->func(work);
-			work = next;
-			cond_resched();
-		} while (work);
-		executed = true;
-	} while (1);
-
-	return executed;
+	return io_run_task_work_head(&ctx->exit_task_work);
 }
 
 struct io_tctx_exit {
-- 
2.24.0

