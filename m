Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CFA362E4BB
	for <lists+io-uring@lfdr.de>; Thu, 17 Nov 2022 19:47:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240024AbiKQSrl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 17 Nov 2022 13:47:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240006AbiKQSri (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 17 Nov 2022 13:47:38 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63D071057C
        for <io-uring@vger.kernel.org>; Thu, 17 Nov 2022 10:47:37 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id n21so7317560ejb.9
        for <io-uring@vger.kernel.org>; Thu, 17 Nov 2022 10:47:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=sFz191FqD6kPD4EU2He5lfCcYhi+KKyvboD67EiM0z8=;
        b=K8ihDKEIyS8PWOaNKw3lsONlg5GMKiDZtEYr+0gIX7BD2DrD3MNncavzM28Ad40Hah
         0i6EHK9W+pggbcaNzpW0IR/BSI227lUSrJpxtQyX7DVYSDxeGub1yMRE0NsjFYT/5NEm
         Bms5b0uzJOOa8oiVWTzvIJXl+aQAunJCzrmhIgvZ3Vq8hpWNgQ+HNbSm9nk4CNQIeCcU
         buWBUC5mIHbHNvCPohBEN/3FpIEGAcoWS8vUc/gDYuvYC3C/UL2pvL7JN+kkUx8xwFOH
         /g4Q0v3r5EcCTxNvlBz+1SggcJxtsmr24N7Htu1ELCQwMARxaqDK8QNgALJ9kiGYGGZ+
         nTuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sFz191FqD6kPD4EU2He5lfCcYhi+KKyvboD67EiM0z8=;
        b=IllTwYC5y70UQAUSGqUIHF11vQaU+tFlemJ2mNMQjsMaYb0a1/F0fQvZTo7SUE5g03
         ILsSwkNWdYLZoyukpzILFNNLLPR2iYCn5h+Na1cywiMvNwtcK4sNOLLvw9rE7lIm5NwS
         rg7m2Uif4ste+xYEOM6TXxryeZxBwVDrmcFBmiK0/VTkN6aSFQduHJcSm0ruXzzTWuA/
         t/hDzNYgDOT1L9dz+JDGPwQ08vJ8oY8XNxs2UirjETwjSmW3CNAFpeJNmL4xRT7VMWAn
         Xx256DMNjnlKcIijU0qwjl0lRfIWUQjEED2JSZO+MBI++XzhrHzpMI8nHuQejc1fCSXn
         4hUA==
X-Gm-Message-State: ANoB5pljuyMMHQX4pXL2SeztfTkfFAhhHus8Tn/st+x6Uq/JmS9TNYvG
        8Ng84+iymYyFGNWTHPuBEb+/LkfvS5c=
X-Google-Smtp-Source: AA0mqf7KtOHntDS7H+WNnrvDGmaXACLNNokQqTHxb48pIg/WX6llucUe8EHVakntWa3nbZ5HKzmE0w==
X-Received: by 2002:a17:906:3289:b0:78d:4cb3:f65d with SMTP id 9-20020a170906328900b0078d4cb3f65dmr3333758ejw.79.1668710855759;
        Thu, 17 Nov 2022 10:47:35 -0800 (PST)
Received: from 127.0.0.1localhost (188.28.224.148.threembb.co.uk. [188.28.224.148])
        by smtp.gmail.com with ESMTPSA id mb22-20020a170906eb1600b0077f20a722dfsm694128ejb.165.2022.11.17.10.47.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 10:47:35 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH] io_uring: kill tw-related outdated comments
Date:   Thu, 17 Nov 2022 18:47:04 +0000
Message-Id: <deb4db0984b07e026d08b7bd1886cfc120d67f17.1668710788.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
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

task_work fallback is executed from a workqueue, so current and
req->task are not necessarily the same. It's still safe to poke into it
as the request holds a task_struct reference.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 2 +-
 io_uring/poll.c     | 1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 94329c1ce91d..5a8a43fb6750 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1249,7 +1249,7 @@ static void io_req_task_cancel(struct io_kiocb *req, bool *locked)
 void io_req_task_submit(struct io_kiocb *req, bool *locked)
 {
 	io_tw_lock(req->ctx, locked);
-	/* req->task == current here, checking PF_EXITING is safe */
+
 	if (likely(!(req->task->flags & PF_EXITING)))
 		io_queue_sqe(req);
 	else
diff --git a/io_uring/poll.c b/io_uring/poll.c
index 2830b7daf952..5d4a0a4a379a 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -214,7 +214,6 @@ static int io_poll_check_events(struct io_kiocb *req, bool *locked)
 	struct io_ring_ctx *ctx = req->ctx;
 	int v, ret;
 
-	/* req->task == current here, checking PF_EXITING is safe */
 	if (unlikely(req->task->flags & PF_EXITING))
 		return -ECANCELED;
 
-- 
2.38.1

