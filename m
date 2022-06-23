Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8204557CDA
	for <lists+io-uring@lfdr.de>; Thu, 23 Jun 2022 15:25:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231664AbiFWNZb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 23 Jun 2022 09:25:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231348AbiFWNZ3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 23 Jun 2022 09:25:29 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F1F249CA2
        for <io-uring@vger.kernel.org>; Thu, 23 Jun 2022 06:25:28 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id r81-20020a1c4454000000b003a0297a61ddso62680wma.2
        for <io-uring@vger.kernel.org>; Thu, 23 Jun 2022 06:25:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CHxW2CtP1hlZ1Q8f7DTNKmbOSEwU/odj12C32OaND+I=;
        b=HYX44xPspvYu3IXafVq1OaDEE0Dq5XSSWE71//4ZaogDzeLmyeLhsm/CZq6HFk9lkY
         mxQxQP/fEB8FMfk7VMDDG1FZ2JIpFJeU+/dDZH6qO29dvwkTsXRYnaDZ4yBvjXoP026F
         TsuSuk7nnGDjZnYTB3tyLQgNO04F4BravPjKas/EgTcHYC7DXyr1YfMkwcyBEzv2AC5g
         jKEc1Mw6h7brUPL35J56FgdRPIDtMV/8mgHBrCsdoLLSKS8WPM2KqHsfTTqu1DGiJp7L
         CP7naSHQiLVcekfQfOUvpOkEaMLsAcNiEKjJwWkfDgJ1R3uC3G2Y+6X+UEzQzhwAt1Xm
         kL8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CHxW2CtP1hlZ1Q8f7DTNKmbOSEwU/odj12C32OaND+I=;
        b=H5RqNL4pIR+rwdy5DhuQ+AHwMc65ptX68k43jr83kkgOKZAcPGxUJokktCjcrwciu1
         VuqCVOB83bJJ3FpqF4Xdrm3O6ty1l7sfxj0TyU/bXJ5r259qoU9wIRbAMxzkPWiTVaSd
         AMFN3MNBs22mhIvgdNzJRQc6e/7l7EBv1Awzcgf9Qvy1pv1LiyJYO3u8UGgB/Y9wp+pF
         SBWDzdNH+MfcSif264B1cpe+GtwhFBGYsYjU5DVBQMZnHRoNUxlRgSg535Hz0eorhVLc
         Hhou+dTVqivACzKXrvdEulNG6coNTSIUKzR3oAk4iEA/B11gdshhoexvs9/srZCMHD/L
         pP/g==
X-Gm-Message-State: AJIora8lZHBYf6KK77pLvwGSRbkO5jHM1sLK4vm4dPKqJXuWQoeQSDPd
        knXJwo7lWL7u0yGP1jmdC3XZNd+BrlrFYXF+
X-Google-Smtp-Source: AGRyM1u3tK/pf/DZlMWi0KbOH/pqXEgpX/nIj4X610/X0YmUnxosywoJJaaQR49gHZ8fUlddUB7dTg==
X-Received: by 2002:a05:600c:1e2a:b0:39c:51f8:80d4 with SMTP id ay42-20020a05600c1e2a00b0039c51f880d4mr4318011wmb.192.1655990726799;
        Thu, 23 Jun 2022 06:25:26 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id z14-20020a7bc7ce000000b0039c5a765388sm3160620wmk.28.2022.06.23.06.25.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jun 2022 06:25:26 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next v2 3/6] io_uring: add a helper for apoll alloc
Date:   Thu, 23 Jun 2022 14:24:46 +0100
Message-Id: <2f93282b47dd678e805dd0d7097f66968ced495c.1655990418.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655990418.git.asml.silence@gmail.com>
References: <cover.1655990418.git.asml.silence@gmail.com>
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

