Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0DC25576B2
	for <lists+io-uring@lfdr.de>; Thu, 23 Jun 2022 11:35:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230326AbiFWJfN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 23 Jun 2022 05:35:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbiFWJfM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 23 Jun 2022 05:35:12 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13E2349257
        for <io-uring@vger.kernel.org>; Thu, 23 Jun 2022 02:35:09 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id z9so10664326wmf.3
        for <io-uring@vger.kernel.org>; Thu, 23 Jun 2022 02:35:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CHxW2CtP1hlZ1Q8f7DTNKmbOSEwU/odj12C32OaND+I=;
        b=VdwTizYSc6FNA4OvH/vIZXFCgjSaWyfANxSt9llOJXYt2AKrfWbkm2QysqYwU6B2wI
         117Dc2/iQF8Cmm+LwheobyUYqc7S8FHChqJpPlniPlqN/rEMOSOi+HR3ZqxqD+Y6EI1x
         hvHI7mLOEmHIdcgbXZLnvLPIhT16qYLFYeP/UIJHl+coDk3Nu9Tv5tUSKYMOifxXiMQz
         DX7CD7yGBVPma9UDKzgqvD9xZacQ+ooDsdUwOtpzbuYk/5WZj2TasIZR/ZCR2z9S4PMu
         FQD9ZAlFQUpVpFuRZ2FzyXdvYZxGNAhJv3R1Rspg+QIthfmisf+usVPZN+ge42caCar3
         Jdpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CHxW2CtP1hlZ1Q8f7DTNKmbOSEwU/odj12C32OaND+I=;
        b=JrxlOr9x1nczWLd0pxWF9iNeGEU4EvMYS7d/FLtlbqWqkzik4G1BO/35XA3NIUxpS8
         1IRrKKfGPl+O6/tLFWtdurPa/b7lUKyJ6K7mmpIK5PqLMfr9sHfzPOPVXJhIiRMEr1V8
         mFR593GaJTgzru371ULV6+4jxP9aXjUas31NQwkyFGKXLlaLBLCiWBm72ud77m4MYn10
         +P74+Sg7q0ByjOuw/Htrke+6ntWKuZQ85iTzFkDYMvtqmXuVQmxraQIwftggbragJFRH
         niKP+H1HnB7JVqqQ5vPP27oB1n/lyLq5ED1Dk7JVIcBnHr8qAuG8raP1/b/frgLVxYt6
         +bNA==
X-Gm-Message-State: AJIora8FCIurtpc+PYMsg/kG5AOLbUqmzb87GFAq46ynWt9RaOCaB0lb
        z3LjFqd2n6UB+rz9oa0KYQggqVJulsuEQtDA
X-Google-Smtp-Source: AGRyM1uMytgwG6hB8luwmYlYxjZk+L2w5gMf+smWva9Clx7A84qxLh/qUH0Nj/U0XvUt9v6/I6yrxw==
X-Received: by 2002:a7b:c4d8:0:b0:39c:97ed:baa3 with SMTP id g24-20020a7bc4d8000000b0039c97edbaa3mr2981029wmk.58.1655976907377;
        Thu, 23 Jun 2022 02:35:07 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id r21-20020a05600c35d500b003a02f957245sm2431202wmq.26.2022.06.23.02.35.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jun 2022 02:35:06 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 3/6] io_uring: add a helper for apoll alloc
Date:   Thu, 23 Jun 2022 10:34:32 +0100
Message-Id: <2f93282b47dd678e805dd0d7097f66968ced495c.1655976119.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655976119.git.asml.silence@gmail.com>
References: <cover.1655976119.git.asml.silence@gmail.com>
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

Extract a helper function for apoll allocation, makes the code easier to
read.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/poll.c | 44 ++++++++++++++++++++++++++++----------------
 1 file changed, 28 insertions(+), 16 deletions(-)

diff --git a/io_uring/poll.c b/io_uring/poll.c
index 7de8c52793cd..aef77f2a8a9a 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -508,10 +508,33 @@ static void io_async_queue_proc(struct file *file, struct wait_queue_head *head,
 	__io_queue_proc(&apoll->poll, pt, head, &apoll->double_poll);
 }
 
+static struct async_poll *io_req_alloc_apoll(struct io_kiocb *req,
+					     unsigned issue_flags)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+	struct async_poll *apoll;
+
+	if (req->flags & REQ_F_POLLED) {
+		apoll = req->apoll;
+		kfree(apoll->double_poll);
+	} else if (!(issue_flags & IO_URING_F_UNLOCKED) &&
+		   !list_empty(&ctx->apoll_cache)) {
+		apoll = list_first_entry(&ctx->apoll_cache, struct async_poll,
+						poll.wait.entry);
+		list_del_init(&apoll->poll.wait.entry);
+	} else {
+		apoll = kmalloc(sizeof(*apoll), GFP_ATOMIC);
+		if (unlikely(!apoll))
+			return NULL;
+	}
+	apoll->double_poll = NULL;
+	req->apoll = apoll;
+	return apoll;
+}
+
 int io_arm_poll_handler(struct io_kiocb *req, unsigned issue_flags)
 {
 	const struct io_op_def *def = &io_op_defs[req->opcode];
-	struct io_ring_ctx *ctx = req->ctx;
 	struct async_poll *apoll;
 	struct io_poll_table ipt;
 	__poll_t mask = POLLPRI | POLLERR | EPOLLET;
@@ -546,21 +569,10 @@ int io_arm_poll_handler(struct io_kiocb *req, unsigned issue_flags)
 	}
 	if (def->poll_exclusive)
 		mask |= EPOLLEXCLUSIVE;
-	if (req->flags & REQ_F_POLLED) {
-		apoll = req->apoll;
-		kfree(apoll->double_poll);
-	} else if (!(issue_flags & IO_URING_F_UNLOCKED) &&
-		   !list_empty(&ctx->apoll_cache)) {
-		apoll = list_first_entry(&ctx->apoll_cache, struct async_poll,
-						poll.wait.entry);
-		list_del_init(&apoll->poll.wait.entry);
-	} else {
-		apoll = kmalloc(sizeof(*apoll), GFP_ATOMIC);
-		if (unlikely(!apoll))
-			return IO_APOLL_ABORTED;
-	}
-	apoll->double_poll = NULL;
-	req->apoll = apoll;
+
+	apoll = io_req_alloc_apoll(req, issue_flags);
+	if (!apoll)
+		return IO_APOLL_ABORTED;
 	req->flags |= REQ_F_POLLED;
 	ipt.pt._qproc = io_async_queue_proc;
 
-- 
2.36.1

