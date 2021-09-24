Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3B89417CB0
	for <lists+io-uring@lfdr.de>; Fri, 24 Sep 2021 23:01:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348490AbhIXVCl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Sep 2021 17:02:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346625AbhIXVCd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Sep 2021 17:02:33 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 602A5C061613
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 14:00:59 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id c21so40397706edj.0
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 14:00:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=hcDQPZnOrAT3k0eSE6iDQYI8qvtq02IpL5YIj9ZK/wQ=;
        b=hbhMA6DtgCQGr+f95hsthQl78wDXmz/YSjNmlBzdZUBGVqpWPGSNRxAMB5EwDkO7WJ
         R57qSoLFr6mH0aeQNXGfhIluquWpxMZgH9T0J6Bt4M0nSTBThigIKNmH1X0KXMVt4O8e
         taYZl0qskrVrEpUlnyf6guUBVo86I9gDRY2UaMOlkw7dwNcmuvi8cC+u4lgS9QQIq3Q8
         kZ5ttwV6PGs5xb/wlJXMP2VSR663T6piHfQQ73f6dTmf6LnaRRUB0u5/zeY2rN6+axD9
         jTwb9BnXD1XaU0I/KLmwZW/CAEZD2xOPLgR5d0GTLgd8HRyr3e/lDniuYR51hRWhvrR5
         9LQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hcDQPZnOrAT3k0eSE6iDQYI8qvtq02IpL5YIj9ZK/wQ=;
        b=bn4LjcckEPvcS9hRIiUcPOMzNAB62iWsJpL53/pAOzJrzTKGB0gmR0dVrPdzsvn46x
         H6OcqEnX39yGthjXPH5AU5bgYAXdRht0KIJJFuwgns9od297GT+VrVtJJ1b98QpDXswO
         aO6Ykq3/tasPT9RtxDpRscnTGd3psb6xBgQ26P4tMBZ1Gk4p9ko0Pz2tNmJ1URY8q+cb
         JCWL21gGpTYfZlheImXlD4M+ZFAsGPA2iwuXyvIPkNFeFjgke4lh2E9q8MiXiik/fQUT
         XPkniqwmwp0Vo5XdAOSNfTdvT15U2SaGNI/OI+t7zN5wiCZ4CkLVLxIfUQOciIofsAzQ
         acUQ==
X-Gm-Message-State: AOAM5320LLw3t3Z6xvr26IvoTMYRGFB6v9gIIPKew9Td7mGilN5cFytK
        16dTQMqwBWMvk0GtrWxr6eWZGVJrm90=
X-Google-Smtp-Source: ABdhPJyQLIKVJch8wG8J9I4ey7Vcag0jrvTSGX429o3KHA5P7kMccYM9PviV8KodQFptvimJz+dZcw==
X-Received: by 2002:aa7:d459:: with SMTP id q25mr7468130edr.62.1632517257986;
        Fri, 24 Sep 2021 14:00:57 -0700 (PDT)
Received: from localhost.localdomain ([85.255.232.225])
        by smtp.gmail.com with ESMTPSA id bc4sm6276048edb.18.2021.09.24.14.00.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 14:00:57 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 10/24] io_uring: add a helper for batch free
Date:   Fri, 24 Sep 2021 21:59:50 +0100
Message-Id: <4fc8306b542c6b1dd1d08e8021ef3bdb0ad15010.1632516769.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1632516769.git.asml.silence@gmail.com>
References: <cover.1632516769.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add a helper io_free_batch_list(), which takes a single linked list and
puts/frees all requests from it in an efficient manner. Will be reused
later.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 34 +++++++++++++++++++++-------------
 1 file changed, 21 insertions(+), 13 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 205127394649..ad8af05af4bc 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2308,12 +2308,31 @@ static void io_req_free_batch(struct req_batch *rb, struct io_kiocb *req,
 	wq_stack_add_head(&req->comp_list, &state->free_list);
 }
 
+static void io_free_batch_list(struct io_ring_ctx *ctx,
+			       struct io_wq_work_list *list)
+	__must_hold(&ctx->uring_lock)
+{
+	struct io_wq_work_node *node;
+	struct req_batch rb;
+
+	io_init_req_batch(&rb);
+	node = list->first;
+	do {
+		struct io_kiocb *req = container_of(node, struct io_kiocb,
+						    comp_list);
+
+		node = req->comp_list.next;
+		if (req_ref_put_and_test(req))
+			io_req_free_batch(&rb, req, &ctx->submit_state);
+	} while (node);
+	io_req_free_batch_finish(ctx, &rb);
+}
+
 static void __io_submit_flush_completions(struct io_ring_ctx *ctx)
 	__must_hold(&ctx->uring_lock)
 {
 	struct io_wq_work_node *node, *prev;
 	struct io_submit_state *state = &ctx->submit_state;
-	struct req_batch rb;
 
 	spin_lock(&ctx->completion_lock);
 	wq_list_for_each(node, prev, &state->compl_reqs) {
@@ -2327,18 +2346,7 @@ static void __io_submit_flush_completions(struct io_ring_ctx *ctx)
 	spin_unlock(&ctx->completion_lock);
 	io_cqring_ev_posted(ctx);
 
-	io_init_req_batch(&rb);
-	node = state->compl_reqs.first;
-	do {
-		struct io_kiocb *req = container_of(node, struct io_kiocb,
-						    comp_list);
-
-		node = req->comp_list.next;
-		if (req_ref_put_and_test(req))
-			io_req_free_batch(&rb, req, &ctx->submit_state);
-	} while (node);
-
-	io_req_free_batch_finish(ctx, &rb);
+	io_free_batch_list(ctx, &state->compl_reqs);
 	INIT_WQ_LIST(&state->compl_reqs);
 }
 
-- 
2.33.0

