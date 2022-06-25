Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D517655A91C
	for <lists+io-uring@lfdr.de>; Sat, 25 Jun 2022 12:56:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232651AbiFYKx3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 25 Jun 2022 06:53:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232285AbiFYKx2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 25 Jun 2022 06:53:28 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E06F817AB1
        for <io-uring@vger.kernel.org>; Sat, 25 Jun 2022 03:53:27 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id v65-20020a1cac44000000b003a03c76fa38so1969659wme.5
        for <io-uring@vger.kernel.org>; Sat, 25 Jun 2022 03:53:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=r9oi2EPTtmMyncZ4TJNImdYRsQ+SPW4kA43PFdaQF1Y=;
        b=aX1zZ9ZkwN9GWKicd1PqB8uxoJ4dWN/NdYF10beqcZws6KJCKU21VkFCLafws0yiY7
         N3/8THgMFn14+cms1MgfM+P/m8mlHcF7m4F2lsla+/PUqjxq/Y1P0Se9k/2ltU+rcYtU
         lER1HvmN7EztiU63lr0/0nJRH0mnvTOHhras5U7jz33HhKFIl/nYkxaK+33Th+dtHAJU
         sZpg24g3yvXdCmEgS/JjBNwyGtMlzENnY4Q9U+Epm9cwhLiD7MhaQw6KPAKeJQSLlL8X
         KpJnxx8il0dDhBrSrc6IoUGlB8mgy9TxT4UrtUDFP7kHyTdaS5ay6gNrwMhz3V3Tf4zB
         1yRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=r9oi2EPTtmMyncZ4TJNImdYRsQ+SPW4kA43PFdaQF1Y=;
        b=0txnsSlTknDvmU3XTqvDccEAUJHmNbQ7NFEaekXV+iw2NzM0Ogfy7UOUPDuZD063ce
         cuAeiR+PSDN4Ey30bY91YCuxT6kNfzEhjJmebLCcsRfUQFK9ZkK9RpOCCPdQkENBSIYa
         BImbAerb0XoFGdHV9YO10ynqd1yH+7opCLPXCxNab1wVPH/9dAaQc4LIRHp9cYHot1k0
         roiqJVcv/0SJYCxdQ2hAwSM4bRAHRoLbTGpnvjz76hL4fwTxb5wQzlgYFLa+cJO+e5U9
         Vt1gTkwZCLw/q5/Se1IaZWJ53dRMds+0c7q6D+1lVgJ/qwgt74JFaxbuESZwu9/HdkvK
         hTpQ==
X-Gm-Message-State: AJIora+C0EE64QnAYSd6/38rnlNnW1K2KBRWAAs7iorfa3fA5akDOUrq
        No4gvjvr9qK0Grs8p+VUm3VNt/qS8EbtFA==
X-Google-Smtp-Source: AGRyM1vwiNrVOtb3KSj7tf8W/Ld12DYO3r0oObjMG7MmHpmg8pxZY1LXBl9k8Kc0L1dUDhqw5XHw9A==
X-Received: by 2002:a05:600c:3b96:b0:397:485a:f5c5 with SMTP id n22-20020a05600c3b9600b00397485af5c5mr3958021wms.185.1656154406172;
        Sat, 25 Jun 2022 03:53:26 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id m17-20020a05600c3b1100b0039c5497deccsm15810144wms.1.2022.06.25.03.53.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Jun 2022 03:53:25 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 2/5] io_uring: fuse fallback_node and normal tw node
Date:   Sat, 25 Jun 2022 11:52:59 +0100
Message-Id: <d04ebde409f7b162fe247b361b4486b193293e46.1656153285.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1656153285.git.asml.silence@gmail.com>
References: <cover.1656153285.git.asml.silence@gmail.com>
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

Now as both normal and fallback paths use llist, just keep one node head
in struct io_task_work and kill off ->fallback_node.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring_types.h | 5 +----
 io_uring/io_uring.c            | 5 ++---
 2 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 918165a20053..3ca8f363f504 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -427,10 +427,7 @@ enum {
 typedef void (*io_req_tw_func_t)(struct io_kiocb *req, bool *locked);
 
 struct io_task_work {
-	union {
-		struct llist_node	node;
-		struct llist_node	fallback_node;
-	};
+	struct llist_node		node;
 	io_req_tw_func_t		func;
 };
 
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 45538b3c3a76..86a0b0c6f5bf 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -233,7 +233,7 @@ static __cold void io_fallback_req_func(struct work_struct *work)
 	bool locked = false;
 
 	percpu_ref_get(&ctx->refs);
-	llist_for_each_entry_safe(req, tmp, node, io_task_work.fallback_node)
+	llist_for_each_entry_safe(req, tmp, node, io_task_work.node)
 		req->io_task_work.func(req, &locked);
 
 	if (locked) {
@@ -1091,13 +1091,12 @@ void io_req_task_work_add(struct io_kiocb *req)
 	if (likely(!task_work_add(req->task, &tctx->task_work, ctx->notify_method)))
 		return;
 
-
 	node = llist_del_all(&tctx->task_list);
 
 	while (node) {
 		req = container_of(node, struct io_kiocb, io_task_work.node);
 		node = node->next;
-		if (llist_add(&req->io_task_work.fallback_node,
+		if (llist_add(&req->io_task_work.node,
 			      &req->ctx->fallback_llist))
 			schedule_delayed_work(&req->ctx->fallback_work, 1);
 	}
-- 
2.36.1

