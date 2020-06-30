Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D365920F480
	for <lists+io-uring@lfdr.de>; Tue, 30 Jun 2020 14:22:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387625AbgF3MWk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 30 Jun 2020 08:22:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733305AbgF3MWj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 30 Jun 2020 08:22:39 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80CCAC061755
        for <io-uring@vger.kernel.org>; Tue, 30 Jun 2020 05:22:39 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id e22so15941810edq.8
        for <io-uring@vger.kernel.org>; Tue, 30 Jun 2020 05:22:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=aL2is0fpL/CvfbAzQzjSV9Fkmt2yyAVxH5xLHmkazi0=;
        b=D6vyWfMr4ZfsVyQ7uLmBM78CYFkK4U7aBzgQ7mVSjskV6bMWTv1GzeYJ1Gn7jrDn1V
         SKI4am5l4iteUmPKKX/Yd6bcC9+G0Za+RcXVVKZzqgIFnswJ5qK+14Hq1s9mYsQP6h/m
         VzXlVj4N5qLR6XF0AXb+vMExjqhcf1sFCSAy8uffIzWeO1hXmD5nFLtJhn+jTtobbWwx
         MAdmhHOFHjKReaRu9qT4FsQMP/T5bKaz5Xy5Fck5YE6z6XJtm5iI6PgAkifX/WDgCT92
         H7Q/JFJAw/irtVVij9FnljYhEg20TErp73+P4JmcAv4V69ZC+xKgs5cJELUGfuqIWRz5
         H7pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aL2is0fpL/CvfbAzQzjSV9Fkmt2yyAVxH5xLHmkazi0=;
        b=FOAHInFJZ6p19xR4rRYAFAs/I8JOlDqTI4OxMlXnAc0I2Q63sJ+ik5hy19vp+Kw3XA
         UE7GxcY/2waGLc/D0ufhYJcqBErTXcEn/1KRXGV/QjA0pVzZSFxnImsmVDZFKwRtQMXH
         cPpXma8F03J6iYoR/vhwMEWpRUD+eG8J2HpCW3AfImzbIDZBE6WyWpYo2zMUE6oCtReh
         LheGFpZDzAqnaaT+4jJkOHCw09alNUCZR3vkBtWeCQfwjpBntmAaEgQs/XRhWIOsCO2U
         a6G5tnGEQQYA+Z4wjanaPJg+GXqxt0xQYinBk7+qv86qf+20GZ2x7mo0sgcSM5b7yw1R
         56KQ==
X-Gm-Message-State: AOAM530gY9GAtRO18SMwbErQDN5spAlvTemqPr7f28/iAQRPNMzpmoL2
        eQits62X9+r2ehBz3GxKoeI=
X-Google-Smtp-Source: ABdhPJyNuA1wTljcVpVk0AkQEJxtu9jv2QnDSmdEt78OsesCBSgm6u0uKNGaeWxcJIbgWCes1rxVJA==
X-Received: by 2002:a05:6402:b1a:: with SMTP id bm26mr22172444edb.144.1593519758274;
        Tue, 30 Jun 2020 05:22:38 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.85])
        by smtp.gmail.com with ESMTPSA id y2sm2820069eda.85.2020.06.30.05.22.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2020 05:22:37 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 6/8] io_uring: fix NULL mm in io_poll_task_func()
Date:   Tue, 30 Jun 2020 15:20:41 +0300
Message-Id: <20fa347e91c0f537b3ed6da9fcd83beaea7a119b.1593519186.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1593519186.git.asml.silence@gmail.com>
References: <cover.1593519186.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_poll_task_func() hand-coded link submission forgetting to set
TASK_RUNNING, acquire mm, etc. Call existing helper for that,
i.e. __io_req_task_submit().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 589cc157e29c..57c194de9165 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4492,13 +4492,8 @@ static void io_poll_task_func(struct callback_head *cb)
 	struct io_kiocb *nxt = NULL;
 
 	io_poll_task_handler(req, &nxt);
-	if (nxt) {
-		struct io_ring_ctx *ctx = nxt->ctx;
-
-		mutex_lock(&ctx->uring_lock);
-		__io_queue_sqe(nxt, NULL, NULL);
-		mutex_unlock(&ctx->uring_lock);
-	}
+	if (nxt)
+		__io_req_task_submit(nxt);
 }
 
 static int io_poll_double_wake(struct wait_queue_entry *wait, unsigned mode,
-- 
2.24.0

