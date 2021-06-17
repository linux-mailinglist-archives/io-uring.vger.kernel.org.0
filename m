Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13F453ABA61
	for <lists+io-uring@lfdr.de>; Thu, 17 Jun 2021 19:14:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231906AbhFQRQu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 17 Jun 2021 13:16:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232041AbhFQRQu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 17 Jun 2021 13:16:50 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5636BC06175F
        for <io-uring@vger.kernel.org>; Thu, 17 Jun 2021 10:14:42 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id l18-20020a1ced120000b029014c1adff1edso6865923wmh.4
        for <io-uring@vger.kernel.org>; Thu, 17 Jun 2021 10:14:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=IUwY0Ar/O1o1eCP2m6GThHVljk09mjZfqNGRMYBU1Fo=;
        b=BZz5Ql4kNjfbZ+SmA3k3Avs5fKNpWPgg8sOu3ofhKOyjphKlmNmXkepEa0538PQgLv
         nfbHhnl08BVBE+vapWbgBIqMSdkXKn20Vmicd5GB7RKX7m0ykKJSHCjwhVoyCTDhunbj
         6qHk/SS6SdnsJsJoIT/KaIp9cr9j0CC8c2np/x1rx6vC7T1lIn2BEGbNdggKd7s1qGLr
         ORFDN056Ua3Neg0B82YOognxa/KDddVmPXA3MmRCdnVXii8FvQ0rQ4LFtmqkaKlVHkVk
         gCeih/3Z5umQIvmKlVKTh37jRllcb66j1Rt0PubTTVmmgmJ7KQ9O6TK7s+gctsJuG94E
         E3JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IUwY0Ar/O1o1eCP2m6GThHVljk09mjZfqNGRMYBU1Fo=;
        b=jnwTKU0XhoHpBgBIF08Rj3EUOjRWG1KoKhVGc+9tiF2L2hBko4clZjXGUhQsTQsnkn
         c8Zwe8PYwNtofQxSeDOHShuRsQsZTUUb4P/H/OtLRfgftMyxXIfseA7+RXSCuDSVKGe2
         NLr0Iqiv18eIrxKLKh+InTANwKbMEXFNhyKJC6WPupvJGwKJWmHVD4howzjAB0kZOJAh
         zGdyEb0uHmW/2X+sN3Bc/DAaQcZDpVqjbm7D7jj4qYObFEu/8+sspm/mzwPXoyPFXaHZ
         yZpIS/HHMBD5RZVbblsyxhWR9hkWvImW7UH9i7X7ysqqMiRWor7y6LTNw1lBheFbL/gB
         fk7g==
X-Gm-Message-State: AOAM532+VYH111g401kz1UcMlXNp+ZYcQRD8Zx8qerk6XVk6YrTE6Jcj
        Af07jsZK8a2Gb1HDpCQnbz0y+ti8wZSivA==
X-Google-Smtp-Source: ABdhPJxk+thqkR0jpqR7vtZcjDTFldwuXsReGGpGEz7j8pXhPZpYK4mNFBWdIBv1AYnyci7JsnM3ig==
X-Received: by 2002:a05:600c:3209:: with SMTP id r9mr6463765wmp.26.1623950080995;
        Thu, 17 Jun 2021 10:14:40 -0700 (PDT)
Received: from localhost.localdomain ([148.252.132.93])
        by smtp.gmail.com with ESMTPSA id g17sm6208033wrp.61.2021.06.17.10.14.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Jun 2021 10:14:40 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 08/12] io_uring: inline __tctx_task_work()
Date:   Thu, 17 Jun 2021 18:14:06 +0100
Message-Id: <f9c05c4bc9763af7bd8e25ebc3c5f7b6f69148f8.1623949695.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1623949695.git.asml.silence@gmail.com>
References: <cover.1623949695.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Inline __tctx_task_work() into tctx_task_work() in preparation for
further optimisations.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 67 ++++++++++++++++++++++++---------------------------
 1 file changed, 31 insertions(+), 36 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 54838cdb2536..d8bc4f82efd1 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1888,48 +1888,43 @@ static void ctx_flush_and_put(struct io_ring_ctx *ctx)
 	percpu_ref_put(&ctx->refs);
 }
 
-static bool __tctx_task_work(struct io_uring_task *tctx)
-{
-	struct io_ring_ctx *ctx = NULL;
-	struct io_wq_work_list list;
-	struct io_wq_work_node *node;
-
-	if (wq_list_empty(&tctx->task_list))
-		return false;
-
-	spin_lock_irq(&tctx->task_lock);
-	list = tctx->task_list;
-	INIT_WQ_LIST(&tctx->task_list);
-	spin_unlock_irq(&tctx->task_lock);
-
-	node = list.first;
-	while (node) {
-		struct io_wq_work_node *next = node->next;
-		struct io_kiocb *req;
-
-		req = container_of(node, struct io_kiocb, io_task_work.node);
-		if (req->ctx != ctx) {
-			ctx_flush_and_put(ctx);
-			ctx = req->ctx;
-			percpu_ref_get(&ctx->refs);
-		}
-
-		req->task_work.func(&req->task_work);
-		node = next;
-	}
-
-	ctx_flush_and_put(ctx);
-	return list.first != NULL;
-}
-
 static void tctx_task_work(struct callback_head *cb)
 {
-	struct io_uring_task *tctx = container_of(cb, struct io_uring_task, task_work);
+	struct io_uring_task *tctx = container_of(cb, struct io_uring_task,
+						  task_work);
 
 	clear_bit(0, &tctx->task_state);
 
-	while (__tctx_task_work(tctx))
+	while (!wq_list_empty(&tctx->task_list)) {
+		struct io_ring_ctx *ctx = NULL;
+		struct io_wq_work_list list;
+		struct io_wq_work_node *node;
+
+		spin_lock_irq(&tctx->task_lock);
+		list = tctx->task_list;
+		INIT_WQ_LIST(&tctx->task_list);
+		spin_unlock_irq(&tctx->task_lock);
+
+		node = list.first;
+		while (node) {
+			struct io_wq_work_node *next = node->next;
+			struct io_kiocb *req = container_of(node, struct io_kiocb,
+							    io_task_work.node);
+
+			if (req->ctx != ctx) {
+				ctx_flush_and_put(ctx);
+				ctx = req->ctx;
+				percpu_ref_get(&ctx->refs);
+			}
+			req->task_work.func(&req->task_work);
+			node = next;
+		}
+
+		ctx_flush_and_put(ctx);
+		if (!list.first)
+			break;
 		cond_resched();
+	}
 }
 
 static int io_req_task_work_add(struct io_kiocb *req)
-- 
2.31.1

