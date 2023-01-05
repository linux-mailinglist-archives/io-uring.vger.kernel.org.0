Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAC3765E9BE
	for <lists+io-uring@lfdr.de>; Thu,  5 Jan 2023 12:23:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232856AbjAELXu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 5 Jan 2023 06:23:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233214AbjAELXg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 5 Jan 2023 06:23:36 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4355350156
        for <io-uring@vger.kernel.org>; Thu,  5 Jan 2023 03:23:35 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id o15so27765897wmr.4
        for <io-uring@vger.kernel.org>; Thu, 05 Jan 2023 03:23:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wx9SshM8GFcLN9/NS/pxj++LkBKiVC0yVKFQS1M3qJU=;
        b=Z+oUlSp03uJeEdgGTlPcZNv5AIvWr7yU9eJ/7w7iXUuDzZbC0ln2ZJ+WGFJUCeNp5K
         Ff1aPOiF8Sr7m+vcJ3oPa4fz6lMZCZnF9GDVUIluHVyZE2msgoeXdQXWDTVxlltxzco7
         EqarckcYLJUEXJZr4tyhJPFD4uPbD+EMonShtcsE66RSoRYn7zZ+LcBiCKbF1VeLRWv5
         rse0wjE8OnbJNruxROcPJrMexw0lvIovlztZOHWQ4nAxGPJ1dLE3QRUuqiDSLy2z2Ypp
         UeH1G2isWfckqRvNe1wDMIwP8ny+gQm21MmPvATesa/xHqCvmVaGOkeb6jLx3atGfwA4
         l9QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wx9SshM8GFcLN9/NS/pxj++LkBKiVC0yVKFQS1M3qJU=;
        b=fwAUOZTmJZGpmL8AhRMR/C7ZlU65Rp1Z8+JIzIlIF6luEx3uSVCs1xjzv9Ww4mUbFe
         QQtS/RSERUjc9pMZmvAdDl1JHoK9Bn/lQWGUuna5L4vQRRIzCU+VksQoTqdIrfrkSkZZ
         mjJIZ9kePjavLH7ssYBWf0/0gw5uX35EXzXt4jMZVU3RGenZsiECwY5FArHqjsm4s3My
         8i/TlutRvmQ3v7RDKIjvGB8UbR9pmahToeSw90SZORggu/sQuR3+f+ylMzATnR53S6tj
         n32l/7Extk3pt77f929WleUwsiYvdn1W+7/40e4jzBPyC6mwNvMO1ELW3EaLTgQLGN9g
         1tqQ==
X-Gm-Message-State: AFqh2krPupsApClo/WlQNyVJFSZlasA2sXJi54rzkgfmFctIrl65qqXN
        Sr7NRuwBWQOxSkzoC8Y06UOKnqvO0Ck=
X-Google-Smtp-Source: AMrXdXuGtx3Xk67t5TYP5H9ERBKjZTrm4wRiPro7N8fYWwSwvooWhqfR3glh48uWqcilhTluqHu+6A==
X-Received: by 2002:a05:600c:4c21:b0:3cf:f18b:327e with SMTP id d33-20020a05600c4c2100b003cff18b327emr36864605wmp.4.1672917813662;
        Thu, 05 Jan 2023 03:23:33 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::2:5c5f])
        by smtp.gmail.com with ESMTPSA id u13-20020a05600c19cd00b003c6f1732f65sm2220688wmq.38.2023.01.05.03.23.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jan 2023 03:23:33 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCHSET REBASE 08/10] io_uring: set TASK_RUNNING right after schedule
Date:   Thu,  5 Jan 2023 11:22:27 +0000
Message-Id: <246dddee247d89fd52023f785ed17cc34962a008.1672916894.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1672916894.git.asml.silence@gmail.com>
References: <cover.1672916894.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Instead of constantly watching that the state of the task is running
before executing tw or taking locks in io_cqring_wait(), switch it back
to TASK_RUNNING immediately.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 2376adce9570..54ec0106ab83 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2541,6 +2541,7 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 		ret = io_cqring_wait_schedule(ctx, &iowq, &timeout);
 		if (ret < 0)
 			break;
+		__set_current_state(TASK_RUNNING);
 		/*
 		 * Run task_work after scheduling and before io_should_wake().
 		 * If we got woken because of task_work being processed, run it
@@ -2553,10 +2554,8 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 		check_cq = READ_ONCE(ctx->check_cq);
 		if (unlikely(check_cq)) {
 			/* let the caller flush overflows, retry */
-			if (check_cq & BIT(IO_CHECK_CQ_OVERFLOW_BIT)) {
-				finish_wait(&ctx->cq_wait, &iowq.wq);
+			if (check_cq & BIT(IO_CHECK_CQ_OVERFLOW_BIT))
 				io_cqring_do_overflow_flush(ctx);
-			}
 			if (check_cq & BIT(IO_CHECK_CQ_DROPPED_BIT)) {
 				ret = -EBADR;
 				break;
-- 
2.38.1

