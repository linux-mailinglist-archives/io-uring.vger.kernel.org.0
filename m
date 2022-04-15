Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBB965030A5
	for <lists+io-uring@lfdr.de>; Sat, 16 Apr 2022 01:09:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349878AbiDOVLp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 Apr 2022 17:11:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345968AbiDOVLo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 Apr 2022 17:11:44 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F091DC6EE7
        for <io-uring@vger.kernel.org>; Fri, 15 Apr 2022 14:09:14 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id p15so17120708ejc.7
        for <io-uring@vger.kernel.org>; Fri, 15 Apr 2022 14:09:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JCRY0ldDYrWUs1x0cqLnyRmUU2ff3ZmuJlCI/F0mvUg=;
        b=fKUt1ooVVcg8thk1xQj3spk4D6DkjjTaw2ueJDo5dSk3dwVvzEqidpLBg9QLjdLPMQ
         TJS1WslSuk7oQaQQHr6GIIFx6nXd5yL0tdAFv0hJ6Ry8myI3xIKg/3EybJA6zKYScCtJ
         zhfXTErxsPN+pkVxY13inuWh3ST9RnXJ0S4GGRBTouI2TWWgw95OJgMvNACeGuCqhwb6
         73Iv0Jad2/nKg6fhDo9AWUdWYxVwvDf2xp9kxjyQrL9o8no3IFQou65gkqAWsBTsmGQM
         s52Yu3BYWt85YTt9H8Mr5JRc6gN3K8yTTe9hZ4aJ8wfJGgHzMATtHYsEjlXUISVrZtpn
         L9/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JCRY0ldDYrWUs1x0cqLnyRmUU2ff3ZmuJlCI/F0mvUg=;
        b=chOj+6Q0tha2LGvWaymgREH6nOvb6pBxBLzUJDE4Rx7/VODxoC8i9AComsHKsVIA0q
         PRhBNn43APBAg+3dzhWpnkVDqavh4+o8MHoMklJO7illTABWL4KFDOZQFmRfbN1ujUCV
         oXzb5ahNWgFNh+3+ozI4y6gxwTdn0AS2a8oQhEuOW52DzU8HcwjAGC4x7bgRcpfjkUUo
         eWUODfY5BqizfRq67bWRRUvXzGBG02s3N2ihvKgptMaFNCGPao9zOWrM+5vhTEPXIVtr
         5VFzCvOac4cafJsp5XJCtyrTsINje4I2rVHwm9zlUgBxUvNtsJatuychcjKRoHnwreLv
         HDvg==
X-Gm-Message-State: AOAM533UewYkB/pQ3ZaLfuoniD0cOfpezMJaKBeEpwaWwQK9D59qNrCp
        5vrZ3aOwdT3e3rz98dHPRLohuggv90Q=
X-Google-Smtp-Source: ABdhPJzItC2qowM01zhNiasK3K6/luZpOloumFJZM11xfs8zPIyIqJ+4Jcro7gquwZ4SAMZ5fLuYEg==
X-Received: by 2002:a17:907:9493:b0:6ef:6ade:92da with SMTP id dm19-20020a170907949300b006ef6ade92damr675496ejc.630.1650056953350;
        Fri, 15 Apr 2022 14:09:13 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.133.118])
        by smtp.gmail.com with ESMTPSA id j10-20020aa7de8a000000b004215209b077sm2602938edv.37.2022.04.15.14.09.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 14:09:13 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 03/14] io_uring: minor refactoring for some tw handlers
Date:   Fri, 15 Apr 2022 22:08:22 +0100
Message-Id: <7798327b684b7015f7e4300420142ddfcd317297.1650056133.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <cover.1650056133.git.asml.silence@gmail.com>
References: <cover.1650056133.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Get rid of some useless local variables

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index b24d65480c08..986a2d640702 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1734,7 +1734,6 @@ static inline void io_req_add_compl_list(struct io_kiocb *req)
 
 static void io_queue_async_work(struct io_kiocb *req, bool *dont_use)
 {
-	struct io_ring_ctx *ctx = req->ctx;
 	struct io_kiocb *link = io_prep_linked_timeout(req);
 	struct io_uring_task *tctx = req->task->io_uring;
 
@@ -1754,8 +1753,9 @@ static void io_queue_async_work(struct io_kiocb *req, bool *dont_use)
 	if (WARN_ON_ONCE(!same_thread_group(req->task, current)))
 		req->work.flags |= IO_WQ_WORK_CANCEL;
 
-	trace_io_uring_queue_async_work(ctx, req, req->cqe.user_data, req->opcode, req->flags,
-					&req->work, io_wq_is_hashed(&req->work));
+	trace_io_uring_queue_async_work(req->ctx, req, req->cqe.user_data,
+					req->opcode, req->flags, &req->work,
+					io_wq_is_hashed(&req->work));
 	io_wq_enqueue(tctx->io_wq, &req->work);
 	if (link)
 		io_queue_linked_timeout(link);
@@ -2647,18 +2647,14 @@ static void io_req_task_work_add(struct io_kiocb *req, bool priority)
 
 static void io_req_task_cancel(struct io_kiocb *req, bool *locked)
 {
-	struct io_ring_ctx *ctx = req->ctx;
-
 	/* not needed for normal modes, but SQPOLL depends on it */
-	io_tw_lock(ctx, locked);
+	io_tw_lock(req->ctx, locked);
 	io_req_complete_failed(req, req->cqe.res);
 }
 
 static void io_req_task_submit(struct io_kiocb *req, bool *locked)
 {
-	struct io_ring_ctx *ctx = req->ctx;
-
-	io_tw_lock(ctx, locked);
+	io_tw_lock(req->ctx, locked);
 	/* req->task == current here, checking PF_EXITING is safe */
 	if (likely(!(req->task->flags & PF_EXITING)))
 		__io_queue_sqe(req);
-- 
2.35.2

