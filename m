Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 841CA5030FD
	for <lists+io-uring@lfdr.de>; Sat, 16 Apr 2022 01:09:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352182AbiDOVL5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 Apr 2022 17:11:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350280AbiDOVL4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 Apr 2022 17:11:56 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D99C765F7
        for <io-uring@vger.kernel.org>; Fri, 15 Apr 2022 14:09:26 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id c6so11074822edn.8
        for <io-uring@vger.kernel.org>; Fri, 15 Apr 2022 14:09:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SHnKPDbUAehmDdjtZZGt0kvEhu2U97VVq71FP2uXqVk=;
        b=Sh0OSfUYg5CrzU62+XpLfHkb3jknOYURZ5QpRwkjlCmr8vRsCMa7483eUF3OR4hIUx
         y5IWkpwWvAHxSI26az0mg4kwAhI0QTgGCEVcEc3BhyqIC/BTa2E5JCryupPiXLZB1C/T
         m6lDhXLEdIiVZPuJc+IoFUBiH/g5j2T0tHd31eORh8ig4ZEwAvLsy2QTkKKwrD+css4+
         EhYGLCVRjC4v+qFjZjy6lbn1VzgP2LREtS3gorcU1jN5dE6zumuEDELZl8P+pRu2AVFk
         cmmsPGuX76vAd2Ttvol7jx6NFCJzl5cw+CfihG+GbUBjqG2sXHr7EmMNOadH6bne4IzW
         AqZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SHnKPDbUAehmDdjtZZGt0kvEhu2U97VVq71FP2uXqVk=;
        b=Ct8/1LAU77GHoTsEEYHIbHdQV0uLvHQlzH0hsV06FdU5e0eabm60e8iIybPrxbXjad
         aMWBu/e7VIAJV3k06X1N1O9isU0yl3pCl4rw3/wKzaitA+8XM/7cSpKyrrKYkQuRzDvw
         12I/NovRxeFxfKfMetVO1ROEGBBm3QKq14kjRM/E9EdkURzb+q/ZjthaWpG+OjakvdsY
         plFYGIvLAsxgoEYcpSlcQsnAuxxEtw2U5d0drg5ljAec+a2oOodlzBgtWkZquD9VHEtx
         HgX0EXNI1FYFtFfc6E28sWgbPNt6MITPpE0vHOnzV/UPOAAyVxRbZKnPwGIXCPwaS7XH
         XBGQ==
X-Gm-Message-State: AOAM533+7OdPCGJutJgzYpvJ3wkC839dEnLgys+JIvjlftLJFtpQ4xcF
        +bowmuZJ0ZCTX+7tZX67wn27UBKYBQk=
X-Google-Smtp-Source: ABdhPJwvJT9fAcHULf3o7RJgwKKdIRu+5h514mdStcuNu0l5P5LsW+hiKcwjEDMpG36yWDYgvnucOQ==
X-Received: by 2002:aa7:c6d7:0:b0:41d:8afe:4a6a with SMTP id b23-20020aa7c6d7000000b0041d8afe4a6amr960940eds.281.1650056965261;
        Fri, 15 Apr 2022 14:09:25 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.133.118])
        by smtp.gmail.com with ESMTPSA id j10-20020aa7de8a000000b004215209b077sm2602938edv.37.2022.04.15.14.09.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 14:09:25 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 11/14] io_uring: refactor lazy link fail
Date:   Fri, 15 Apr 2022 22:08:30 +0100
Message-Id: <6a68aca9cf4492132da1d7c8a09068b74aba3c65.1650056133.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <cover.1650056133.git.asml.silence@gmail.com>
References: <cover.1650056133.git.asml.silence@gmail.com>
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

Remove the lazy link fail logic from io_submit_sqe() and hide it into a
helper. It simplifies the code and will be needed in next patches.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 87 ++++++++++++++++++++++++++++-----------------------
 1 file changed, 47 insertions(+), 40 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 3b9fcadb3895..9356e6ee8a97 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7685,7 +7685,44 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	return io_req_prep(req, sqe);
 }
 
-static int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
+static __cold int io_submit_fail_init(const struct io_uring_sqe *sqe,
+				      struct io_kiocb *req, int ret)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+	struct io_submit_link *link = &ctx->submit_state.link;
+	struct io_kiocb *head = link->head;
+
+	trace_io_uring_req_failed(sqe, ctx, req, ret);
+
+	/*
+	 * Avoid breaking links in the middle as it renders links with SQPOLL
+	 * unusable. Instead of failing eagerly, continue assembling the link if
+	 * applicable and mark the head with REQ_F_FAIL. The link flushing code
+	 * should find the flag and handle the rest.
+	 */
+	req_fail_link_node(req, ret);
+	if (head && !(head->flags & REQ_F_FAIL))
+		req_fail_link_node(head, -ECANCELED);
+
+	if (!(req->flags & IO_REQ_LINK_FLAGS)) {
+		if (head) {
+			link->last->link = req;
+			link->head = NULL;
+			req = head;
+		}
+		io_queue_sqe_fallback(req);
+		return ret;
+	}
+
+	if (head)
+		link->last->link = req;
+	else
+		link->head = req;
+	link->last = req;
+	return 0;
+}
+
+static inline int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
 			 const struct io_uring_sqe *sqe)
 	__must_hold(&ctx->uring_lock)
 {
@@ -7693,32 +7730,8 @@ static int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	int ret;
 
 	ret = io_init_req(ctx, req, sqe);
-	if (unlikely(ret)) {
-		trace_io_uring_req_failed(sqe, ctx, req, ret);
-
-		/* fail even hard links since we don't submit */
-		if (link->head) {
-			/*
-			 * we can judge a link req is failed or cancelled by if
-			 * REQ_F_FAIL is set, but the head is an exception since
-			 * it may be set REQ_F_FAIL because of other req's failure
-			 * so let's leverage req->cqe.res to distinguish if a head
-			 * is set REQ_F_FAIL because of its failure or other req's
-			 * failure so that we can set the correct ret code for it.
-			 * init result here to avoid affecting the normal path.
-			 */
-			if (!(link->head->flags & REQ_F_FAIL))
-				req_fail_link_node(link->head, -ECANCELED);
-		} else if (!(req->flags & IO_REQ_LINK_FLAGS)) {
-			/*
-			 * the current req is a normal req, we should return
-			 * error and thus break the submittion loop.
-			 */
-			io_req_complete_failed(req, ret);
-			return ret;
-		}
-		req_fail_link_node(req, ret);
-	}
+	if (unlikely(ret))
+		return io_submit_fail_init(sqe, req, ret);
 
 	/* don't need @sqe from now on */
 	trace_io_uring_submit_sqe(ctx, req, req->cqe.user_data, req->opcode,
@@ -7733,25 +7746,19 @@ static int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	 * conditions are true (normal request), then just queue it.
 	 */
 	if (link->head) {
-		struct io_kiocb *head = link->head;
-
-		if (!(req->flags & REQ_F_FAIL)) {
-			ret = io_req_prep_async(req);
-			if (unlikely(ret)) {
-				req_fail_link_node(req, ret);
-				if (!(head->flags & REQ_F_FAIL))
-					req_fail_link_node(head, -ECANCELED);
-			}
-		}
-		trace_io_uring_link(ctx, req, head);
+		ret = io_req_prep_async(req);
+		if (unlikely(ret))
+			return io_submit_fail_init(sqe, req, ret);
+
+		trace_io_uring_link(ctx, req, link->head);
 		link->last->link = req;
 		link->last = req;
 
 		if (req->flags & IO_REQ_LINK_FLAGS)
 			return 0;
-		/* last request of a link, enqueue the link */
+		/* last request of the link, flush it */
+		req = link->head;
 		link->head = NULL;
-		req = head;
 	} else if (req->flags & IO_REQ_LINK_FLAGS) {
 		link->head = req;
 		link->last = req;
-- 
2.35.2

