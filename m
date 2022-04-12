Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C76304FE3BF
	for <lists+io-uring@lfdr.de>; Tue, 12 Apr 2022 16:26:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242247AbiDLO2A (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 12 Apr 2022 10:28:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356544AbiDLO1f (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 12 Apr 2022 10:27:35 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4382421255
        for <io-uring@vger.kernel.org>; Tue, 12 Apr 2022 07:25:17 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id ay11-20020a05600c1e0b00b0038eb92fa965so1892768wmb.4
        for <io-uring@vger.kernel.org>; Tue, 12 Apr 2022 07:25:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JYSPTGwe+4Z5itn4lRzCyeCI3Gpt38FzJyufXHZ4QAQ=;
        b=A3fKt0rTrwP32gxv6P3jjSO7aDoJqatvabKSjdSIBiPlXs0OdpWk4KcQTLoRirIy7q
         qzOYX0stZTWOv4kC1fPga2s0Pvqv63sFCukTEx82+hxBGMSgT9Eg4ak+/obXNF7TzYEa
         SN9Tv5Jeue/aDQ91Ln2pr5sALdLHPZnv1lsKcWqA9Qnj7uUgdRInEUlS7qkdupPNL4AN
         a06Ot2poJsMBoj4f5Z2V2ZeGqpFA1IeWw2jZKWZQSl25OXnY2NHICWUZIsU+0+3UNU2d
         I8mZtz1+KbUGMLIp7Nw1Ra9SmU6ZtcW5avltn8czXtfUpdDcGJxeAC+HJdeKX0rst3cl
         3nfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JYSPTGwe+4Z5itn4lRzCyeCI3Gpt38FzJyufXHZ4QAQ=;
        b=l2tjr0pzreI/FOrSW7yvzkWpXutBW7X49ZRKyfTowqNLBOLhjyCrsGjWyUSamq9wwX
         bJWZ/JV9Arq9gemf4wlRkb2LmnxmpidUbo7iuNvt8OK824K/fw6BVuxZ8l/YPTiuySyq
         a3QlHgfT5oW7smKA6QXrJttxJxOU3P1zbr1UXamIPQUZ05hXviruf75A7DvZiYCT7FhI
         qFcpEolLP+vsad0u/b/OwXwdhCyE20yPv2Ipaokbu8Gd4tKt4lmpm8bjkIHL9/aPQPPu
         o0NE+pNTSgNyUCBX+03YLjCcQCxmjzNOTE2I7BBUBiiiUIXL5ZwdwRwg4k2VRxDBsnIm
         +9Lg==
X-Gm-Message-State: AOAM530Kkx3YliRh1D36zQ62W7l38RzYQzR5WcJhmE79QnOcnGciRYCb
        SozKzgVGG2pCP6yld507Ize+8g5yvps=
X-Google-Smtp-Source: ABdhPJz4lUE2BG+KpcWbZOI0diC3IU+PMPw4oPfdxUdSwy5L0+ZGAYFhKBmKK/zDzYzm0zgtG8xNNw==
X-Received: by 2002:a7b:c5d1:0:b0:37f:a8a3:9e17 with SMTP id n17-20020a7bc5d1000000b0037fa8a39e17mr4252936wmk.109.1649773515643;
        Tue, 12 Apr 2022 07:25:15 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.129.222])
        by smtp.gmail.com with ESMTPSA id h2-20020a05600c414200b0038ec7a4f07esm2120292wmm.33.2022.04.12.07.25.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 07:25:15 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 1/1] io_uring: fix assign file locking issues
Date:   Tue, 12 Apr 2022 15:24:43 +0100
Message-Id: <0d9b9f37841645518503f6a207e509d14a286aba.1649773463.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.35.1
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

io-wq work cancellation path can't take uring_lock as how it's done on
file assignment, we have to handle IO_WQ_WORK_CANCEL first, this fixes
encountered hangs.

Fixes: 6bf9c47a3989 ("io_uring: defer file assignment")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f2269ffe09eb..cbd876c023b1 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7318,16 +7318,18 @@ static void io_wq_submit_work(struct io_wq_work *work)
 	if (timeout)
 		io_queue_linked_timeout(timeout);
 
-	if (!io_assign_file(req, issue_flags)) {
-		err = -EBADF;
-		work->flags |= IO_WQ_WORK_CANCEL;
-	}
 
 	/* either cancelled or io-wq is dying, so don't touch tctx->iowq */
 	if (work->flags & IO_WQ_WORK_CANCEL) {
+fail:
 		io_req_task_queue_fail(req, err);
 		return;
 	}
+	if (!io_assign_file(req, issue_flags)) {
+		err = -EBADF;
+		work->flags |= IO_WQ_WORK_CANCEL;
+		goto fail;
+	}
 
 	if (req->flags & REQ_F_FORCE_ASYNC) {
 		bool opcode_poll = def->pollin || def->pollout;
-- 
2.35.1

