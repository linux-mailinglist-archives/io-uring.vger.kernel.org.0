Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97E3220D4F6
	for <lists+io-uring@lfdr.de>; Mon, 29 Jun 2020 21:15:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731308AbgF2TNR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 29 Jun 2020 15:13:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731269AbgF2TNH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 29 Jun 2020 15:13:07 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0413CC008652
        for <io-uring@vger.kernel.org>; Mon, 29 Jun 2020 03:14:48 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id j4so13488467wrp.10
        for <io-uring@vger.kernel.org>; Mon, 29 Jun 2020 03:14:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=L7zA/jj5w324uEdXTwdkOrlCFVnkHfSweaUVQAy+I1o=;
        b=r6lF+nZrXstr9VXn7EBJ3Ti1elYOQ6eQq3Zt5eN4+ZU4mYloSI9oiT+ljDJ3qOWX95
         GT5YxCQ/izok2AeG0RUC3lvrCsBhUwR1bT3yeTlJuA1tL/uwhmvezS3zytuQWb1m2/07
         5F4kIIonDfJ+rvV/xUGy8zjTvDOwvc/FuZzkzZwlxyQtYv8X+CJaplw+Km1EioRNGANt
         zbdB8Q39PcgmGUUmDZDP5F/duopatYJTe0iFHDZe779Q5kWoNXF1OmyoQsuHSqo6lr5d
         h4048nrf9iY1gLGbyKnCgvQqhWIDw0lStaMdHBVHFIwd1qA1SFX5CGnfy558bKbNGMlh
         59xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=L7zA/jj5w324uEdXTwdkOrlCFVnkHfSweaUVQAy+I1o=;
        b=MdNVWcOH5WF3z0s9iEyZ6Awsaj8o+SbzAPw6/snLSVupBfzgg7W6b2Df/f7wAS//mm
         92A8ZHR4tdUMVn2bUO35buasxKRjJlRXuuNsQb3J9+Kc7zOZUglloktYoMEu0uqf+srY
         qI7YgQAYM0j1JVXSzEGJeqhA1fz3C0Nzjahk7TGQOZ8k53vaRD5BYuOj/ZGwMHT+O/mC
         JvuhQnsY0V0OhNz9o+gLwTfOZZvADWr4x0HkCSO3qNn3HmGHqZPEmXI4jsVhBfbK+L6r
         YcPuIiSkKFVbSFOYB7ZoLMTY1Tw3Lx+gHAZoaZNvf860jEpgK3e+3AuWfPQ/3ucjET/I
         bkIA==
X-Gm-Message-State: AOAM530uC/mAv6nsdISFm77dn+dXfpYyu9/+kRbN45ipiO6mEAs+zA/L
        Jr7U6x6pmkWlTH+Fi/U1KhaLWSBG
X-Google-Smtp-Source: ABdhPJxPvDGluIVAE7xmZ6u/gvXp51NTF+LOUafLg6rMIYUcRzanemXCQVPx9KgLj4h4Uzzg7FxHkg==
X-Received: by 2002:adf:f5ce:: with SMTP id k14mr15611728wrp.234.1593425686669;
        Mon, 29 Jun 2020 03:14:46 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.85])
        by smtp.gmail.com with ESMTPSA id a12sm37807233wrv.41.2020.06.29.03.14.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2020 03:14:46 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 1/5] io_uring: deduplicate freeing linked timeouts
Date:   Mon, 29 Jun 2020 13:12:59 +0300
Message-Id: <86b71d0daee05c56fc298798e9983c5c47c867d3.1593424923.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1593424923.git.asml.silence@gmail.com>
References: <cover.1593424923.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Linked timeout cancellation code is repeated in in io_req_link_next()
and io_fail_links(), and they differ in details even though shouldn't.
Basing on the fact that there is maximum one armed linked timeout in
a link, and it immediately follows the head, extract a function that
will check for it and defuse.

Justification:
- DRY and cleaner
- better inlining for io_req_link_next() (just 1 call site now)
- isolates linked_timeouts from common path
- reduces time under spinlock for failed links
- actually less code

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 88 +++++++++++++++++++++++----------------------------
 1 file changed, 40 insertions(+), 48 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 6710097564de..4cd6d24276c3 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1552,37 +1552,49 @@ static bool io_link_cancel_timeout(struct io_kiocb *req)
 	return false;
 }
 
-static void io_req_link_next(struct io_kiocb *req, struct io_kiocb **nxtptr)
+static void io_kill_linked_timeout(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
+	struct io_kiocb *link;
 	bool wake_ev = false;
+	unsigned long flags = 0; /* false positive warning */
+
+	if (!(req->flags & REQ_F_COMP_LOCKED))
+		spin_lock_irqsave(&ctx->completion_lock, flags);
+
+	if (list_empty(&req->link_list))
+		goto out;
+	link = list_first_entry(&req->link_list, struct io_kiocb, link_list);
+	if (link->opcode != IORING_OP_LINK_TIMEOUT)
+		goto out;
+
+	list_del_init(&link->link_list);
+	wake_ev = io_link_cancel_timeout(link);
+	req->flags &= ~REQ_F_LINK_TIMEOUT;
+out:
+	if (!(req->flags & REQ_F_COMP_LOCKED))
+		spin_unlock_irqrestore(&ctx->completion_lock, flags);
+	if (wake_ev)
+		io_cqring_ev_posted(ctx);
+}
+
+static void io_req_link_next(struct io_kiocb *req, struct io_kiocb **nxtptr)
+{
+	struct io_kiocb *nxt;
 
 	/*
 	 * The list should never be empty when we are called here. But could
 	 * potentially happen if the chain is messed up, check to be on the
 	 * safe side.
 	 */
-	while (!list_empty(&req->link_list)) {
-		struct io_kiocb *nxt = list_first_entry(&req->link_list,
-						struct io_kiocb, link_list);
-
-		if (unlikely((req->flags & REQ_F_LINK_TIMEOUT) &&
-			     (nxt->flags & REQ_F_TIMEOUT))) {
-			list_del_init(&nxt->link_list);
-			wake_ev |= io_link_cancel_timeout(nxt);
-			req->flags &= ~REQ_F_LINK_TIMEOUT;
-			continue;
-		}
-
-		list_del_init(&req->link_list);
-		if (!list_empty(&nxt->link_list))
-			nxt->flags |= REQ_F_LINK_HEAD;
-		*nxtptr = nxt;
-		break;
-	}
+	if (unlikely(list_empty(&req->link_list)))
+		return;
 
-	if (wake_ev)
-		io_cqring_ev_posted(ctx);
+	nxt = list_first_entry(&req->link_list, struct io_kiocb, link_list);
+	list_del_init(&req->link_list);
+	if (!list_empty(&nxt->link_list))
+		nxt->flags |= REQ_F_LINK_HEAD;
+	*nxtptr = nxt;
 }
 
 /*
@@ -1591,9 +1603,6 @@ static void io_req_link_next(struct io_kiocb *req, struct io_kiocb **nxtptr)
 static void io_fail_links(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
-	unsigned long flags;
-
-	spin_lock_irqsave(&ctx->completion_lock, flags);
 
 	while (!list_empty(&req->link_list)) {
 		struct io_kiocb *link = list_first_entry(&req->link_list,
@@ -1602,18 +1611,12 @@ static void io_fail_links(struct io_kiocb *req)
 		list_del_init(&link->link_list);
 		trace_io_uring_fail_link(req, link);
 
-		if ((req->flags & REQ_F_LINK_TIMEOUT) &&
-		    link->opcode == IORING_OP_LINK_TIMEOUT) {
-			io_link_cancel_timeout(link);
-		} else {
-			io_cqring_fill_event(link, -ECANCELED);
-			__io_double_put_req(link);
-		}
+		io_cqring_fill_event(link, -ECANCELED);
+		__io_double_put_req(link);
 		req->flags &= ~REQ_F_LINK_TIMEOUT;
 	}
 
 	io_commit_cqring(ctx);
-	spin_unlock_irqrestore(&ctx->completion_lock, flags);
 	io_cqring_ev_posted(ctx);
 }
 
@@ -1623,30 +1626,19 @@ static void io_req_find_next(struct io_kiocb *req, struct io_kiocb **nxt)
 		return;
 	req->flags &= ~REQ_F_LINK_HEAD;
 
+	if (req->flags & REQ_F_LINK_TIMEOUT)
+		io_kill_linked_timeout(req);
+
 	/*
 	 * If LINK is set, we have dependent requests in this chain. If we
 	 * didn't fail this request, queue the first one up, moving any other
 	 * dependencies to the next request. In case of failure, fail the rest
 	 * of the chain.
 	 */
-	if (req->flags & REQ_F_FAIL_LINK) {
+	if (req->flags & REQ_F_FAIL_LINK)
 		io_fail_links(req);
-	} else if ((req->flags & (REQ_F_LINK_TIMEOUT | REQ_F_COMP_LOCKED)) ==
-			REQ_F_LINK_TIMEOUT) {
-		struct io_ring_ctx *ctx = req->ctx;
-		unsigned long flags;
-
-		/*
-		 * If this is a timeout link, we could be racing with the
-		 * timeout timer. Grab the completion lock for this case to
-		 * protect against that.
-		 */
-		spin_lock_irqsave(&ctx->completion_lock, flags);
-		io_req_link_next(req, nxt);
-		spin_unlock_irqrestore(&ctx->completion_lock, flags);
-	} else {
+	else
 		io_req_link_next(req, nxt);
-	}
 }
 
 static void __io_req_task_cancel(struct io_kiocb *req, int error)
-- 
2.24.0

