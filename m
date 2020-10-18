Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0A1829169B
	for <lists+io-uring@lfdr.de>; Sun, 18 Oct 2020 11:20:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725298AbgJRJUw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 18 Oct 2020 05:20:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726280AbgJRJUv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 18 Oct 2020 05:20:51 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B3D9C061755
        for <io-uring@vger.kernel.org>; Sun, 18 Oct 2020 02:20:50 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id e23so7428067wme.2
        for <io-uring@vger.kernel.org>; Sun, 18 Oct 2020 02:20:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=SpRtmWpIWo2mr1Bkro/1jtA0VJ1xvH7b4a9UveCo0uM=;
        b=Hcsfa2Dpm361ngziraxcPqoh9buUZL1aZ/WJx9f2vgpdlDt/KrZGfZninyjTWmGxzm
         ILRGEnzjOX6U6e09FbWOIyLR4AZrhjruoEp85/6N+GcTlHH5XVTHUO+V5JtnAc6CcIKk
         Afcb2FVD0tKMr1CAio8iOeLAv2bDT1fFq3CoPc32QSgaWc/H2oYa2BuvoxYG+F2Ll3s0
         xKeiHA/vZp/m8RMRp8pHGgnJSHFo9ReMvjv0u1RhbVQW1o0JnsKtlc6ct+Ij35V/WjKK
         0aggHMGWU83vWJeEe2C3+JqP9T9zhTT/Algw0QVhwNGmaWbxfj3UfOzFFprDdjY/n5TP
         BB1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SpRtmWpIWo2mr1Bkro/1jtA0VJ1xvH7b4a9UveCo0uM=;
        b=nB5Bw0jGXt5eWLZUholQXEo3S7RtyM8yogndD46tZ7DGftTpi1iUdinXSEcCMGCYjM
         2LXfrJPo84MwjI0hhqwBTHrKYcyLyIJQVuei7NNgmWlLq6klS8z3aiUdElRbpTCMBKAP
         micXh63R1t2FMbHCapjdESrdRTxvLQ+LxQeIQUgMAN3oXlIDtkEUdDlS58cqwmkoW4uQ
         xZy5D0GiK00zZ7Ui69UdkfULNC16Z0ScJo09QUvMAIJobjnR6xJcTpwho+RRH7Ah4B+Y
         29dqaEyaSZzeY3JR3qUCeijL6o5Vuo4UiHLX6YAf0M8O8Tkxtpzwr0i06woXi3OG4tFi
         Nr+A==
X-Gm-Message-State: AOAM533B3ZWcWuhIR3x4UKA/90420UKc73W8mLWevgvEeFzgQtjkIGRZ
        njWaHuP8O1tYNKQr0JNU8hmPhtQc6X1fxA==
X-Google-Smtp-Source: ABdhPJzjqdMRVMbwpZx2qJLfwbdukcGQLnQNDcx7Xoif+YeKPl6Ny4lHURAjYRyK/HtGrW252O9QVQ==
X-Received: by 2002:a1c:7d49:: with SMTP id y70mr5455441wmc.103.1603012849068;
        Sun, 18 Oct 2020 02:20:49 -0700 (PDT)
Received: from localhost.localdomain (host109-152-100-164.range109-152.btcentralplus.com. [109.152.100.164])
        by smtp.gmail.com with ESMTPSA id w11sm12782984wrs.26.2020.10.18.02.20.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2020 02:20:48 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 6/7] io_uring: inline io_poll_task_handler()
Date:   Sun, 18 Oct 2020 10:17:42 +0100
Message-Id: <480348e38810f765423a464f759698954643f3f9.1603011899.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1603011899.git.asml.silence@gmail.com>
References: <cover.1603011899.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_poll_task_handler() doesn't add clarity, inline it in its only user.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 31 ++++++++++++-------------------
 1 file changed, 12 insertions(+), 19 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 70f4f1ce3011..81b0b38ee506 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4924,32 +4924,25 @@ static void io_poll_complete(struct io_kiocb *req, __poll_t mask, int error)
 	io_commit_cqring(ctx);
 }
 
-static void io_poll_task_handler(struct io_kiocb *req, struct io_kiocb **nxt)
+static void io_poll_task_func(struct callback_head *cb)
 {
+	struct io_kiocb *req = container_of(cb, struct io_kiocb, task_work);
 	struct io_ring_ctx *ctx = req->ctx;
+	struct io_kiocb *nxt;
 
 	if (io_poll_rewait(req, &req->poll)) {
 		spin_unlock_irq(&ctx->completion_lock);
-		return;
-	}
-
-	hash_del(&req->hash_node);
-	io_poll_complete(req, req->result, 0);
-	spin_unlock_irq(&ctx->completion_lock);
-
-	*nxt = io_put_req_find_next(req);
-	io_cqring_ev_posted(ctx);
-}
+	} else {
+		hash_del(&req->hash_node);
+		io_poll_complete(req, req->result, 0);
+		spin_unlock_irq(&ctx->completion_lock);
 
-static void io_poll_task_func(struct callback_head *cb)
-{
-	struct io_kiocb *req = container_of(cb, struct io_kiocb, task_work);
-	struct io_ring_ctx *ctx = req->ctx;
-	struct io_kiocb *nxt = NULL;
+		nxt = io_put_req_find_next(req);
+		io_cqring_ev_posted(ctx);
+		if (nxt)
+			__io_req_task_submit(nxt);
+	}
 
-	io_poll_task_handler(req, &nxt);
-	if (nxt)
-		__io_req_task_submit(nxt);
 	percpu_ref_put(&ctx->refs);
 }
 
-- 
2.24.0

