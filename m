Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EC716D97E8
	for <lists+io-uring@lfdr.de>; Thu,  6 Apr 2023 15:21:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238222AbjDFNVB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 6 Apr 2023 09:21:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238099AbjDFNU5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 6 Apr 2023 09:20:57 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64E609EF0;
        Thu,  6 Apr 2023 06:20:25 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id a640c23a62f3a-93283bd90dbso111389866b.0;
        Thu, 06 Apr 2023 06:20:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680787223;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m8+70CIeUlL/bRzoWQFlxEHR02qO4uxN8VAdftx3jWU=;
        b=odRZJ8YvJwRQ98L5LnAtQ4v3cPf5ppkA/fChIdqnyu3qgEdzQX0S+OT6edH7PwOqdn
         Gm46Hm+zGCjodX7hINwoPoEWDBxFjKQWXowOnMxOVfqBJrCyYv3Y4ukGivocatNTNaD6
         1gRY634sstPd34Lu2bEWuI7H1LUVWAEdWa1C2UBNjlYAojKnbudjyKUAhYBlWT5d9wWe
         3Beg3Cy9SZSjXrfoKuAGbpjtAYmVSmm4Vlt9MT6UIvHj1IlrQiooGUPF6x/tD6jYRtja
         NyxyLPE8AnOAemmgxEF8XM/DL0TV0V/P2+ToOLkblx0qS3MLbRHeW5a9QiyVtVsOhj93
         b7YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680787223;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=m8+70CIeUlL/bRzoWQFlxEHR02qO4uxN8VAdftx3jWU=;
        b=OYMHKGFeuKaln5Ll5YEg5XmaN1MLdYlfrtz4dkUdmN0hXEzW/KQ/fDLZraJ2Kja0L+
         Ne7f2AsQXrqIEOkGI/U5hgOj0C7DXvCMOCg2eQDeqzXIGKxTYGjDuKidDchBas4qeZeR
         8F5odQ2dNQdugTCys87heKK+SffMaglOF4h+lJ/nJKoT87uqhukh1l3mh076UVLo8lqD
         dfgA94egxsC2ZTXh0BorM3g46/wKwzdt2EJjSFfCh4Dw7U5ysfO6GKdVo9EI3qOmz6Fx
         XChKcDmBcUDuvou2zJOxw4WMbTWnZnu5vP0Ub0HPJVdVyfIRqK5H9BsGcasNJ8qnyqxQ
         hN3A==
X-Gm-Message-State: AAQBX9ewzmOqyZADXR1G4fSzyUMgMPoK6gXXmF1olC/jZ6FKYfjb0y+u
        ts78mvyiSlfvUAVPa+QDkYAAmqG/tO4=
X-Google-Smtp-Source: AKy350YsJ6OVTFSfhzTFy7XYvvGUvFJfZojs4AkHfw5du+PSPqWvcdkF6e7b8D/fn+dfHlkzxXIvww==
X-Received: by 2002:a50:ee86:0:b0:502:1299:5fa5 with SMTP id f6-20020a50ee86000000b0050212995fa5mr5280100edr.16.1680787223618;
        Thu, 06 Apr 2023 06:20:23 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::2:a638])
        by smtp.gmail.com with ESMTPSA id m20-20020a509994000000b0050470aa444fsm312732edb.51.2023.04.06.06.20.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Apr 2023 06:20:23 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/8] io_uring: move pinning out of io_req_local_work_add
Date:   Thu,  6 Apr 2023 14:20:07 +0100
Message-Id: <49c0dbed390b0d6d04cb942dd3592879fd5bfb1b.1680782017.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <cover.1680782016.git.asml.silence@gmail.com>
References: <cover.1680782016.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Move ctx pinning from io_req_local_work_add() to the caller, looks
better and makes working with the code a bit easier.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index ae90d2753e0d..29a0516ee5ce 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1306,17 +1306,15 @@ static void io_req_local_work_add(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 
-	percpu_ref_get(&ctx->refs);
-
 	if (!llist_add(&req->io_task_work.node, &ctx->work_llist))
-		goto put_ref;
+		return;
 
 	/* needed for the following wake up */
 	smp_mb__after_atomic();
 
 	if (unlikely(atomic_read(&req->task->io_uring->in_cancel))) {
 		io_move_task_work_from_local(ctx);
-		goto put_ref;
+		return;
 	}
 
 	if (ctx->flags & IORING_SETUP_TASKRUN_FLAG)
@@ -1326,9 +1324,6 @@ static void io_req_local_work_add(struct io_kiocb *req)
 
 	if (READ_ONCE(ctx->cq_waiting))
 		wake_up_state(ctx->submitter_task, TASK_INTERRUPTIBLE);
-
-put_ref:
-	percpu_ref_put(&ctx->refs);
 }
 
 void __io_req_task_work_add(struct io_kiocb *req, bool allow_local)
@@ -1337,7 +1332,9 @@ void __io_req_task_work_add(struct io_kiocb *req, bool allow_local)
 	struct io_ring_ctx *ctx = req->ctx;
 
 	if (allow_local && ctx->flags & IORING_SETUP_DEFER_TASKRUN) {
+		percpu_ref_get(&ctx->refs);
 		io_req_local_work_add(req);
+		percpu_ref_put(&ctx->refs);
 		return;
 	}
 
-- 
2.40.0

