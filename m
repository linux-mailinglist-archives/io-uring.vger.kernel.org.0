Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45FBC41F2AB
	for <lists+io-uring@lfdr.de>; Fri,  1 Oct 2021 19:07:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231461AbhJARJe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 1 Oct 2021 13:09:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230187AbhJARJe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 1 Oct 2021 13:09:34 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0855C061775
        for <io-uring@vger.kernel.org>; Fri,  1 Oct 2021 10:07:49 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id b8so2644914edk.2
        for <io-uring@vger.kernel.org>; Fri, 01 Oct 2021 10:07:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=S9WXcbb7Ie/6cGA1dUZjKfoFSHX+7phtgnlJP9QUPHQ=;
        b=f5r6hI+DOAlyXaYYAVBVjtmdiOE4kUJi4Pqalkb6YJQyiTGSofpyDwt1wiknaZaXoO
         EVx1lQ7rp31YCsObmaAcMpyZVEQeLX1L9kvHLEMQCUyH8NqMcpzkQ9YpTEEWr9tVkn4M
         vlrJranfoNhOW9zBEAcjilynPqdod6xrSMMrYMKZ3foY1/FAIOlrwztkue4Ma7N8Crsu
         /tMAwJqrP/fPmzGQE1Uqo3tMbEPKH/6X+GlhiK5eTLiQ6xmdDB2KmmoXMma9DWKSGCkY
         eW6jeYNvrfTsJeVYET0SUS8p5y7CrsNAzGorYCGxqd3mDn8pAgGi8blyIA053///N5co
         KaxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=S9WXcbb7Ie/6cGA1dUZjKfoFSHX+7phtgnlJP9QUPHQ=;
        b=2lp+C7cXc2VYuI80UXQIT5oRPOtYVkURvWCzHoXzMpd4K1NLEV3uhg8oqOz0PiJukK
         fnMBLJfRqvc/1fq19wgsXb2Jp/gdsCLrEWlGAdbHpCzlRB52UO6kGYWTZd+tGKbDHEvl
         J/wRRCuzKSod4qWQyRlU8r6E8WRxkrHAq4HJjbJq/sJjnQZ2Wgdob3yRibowY76XK58R
         tuRKtfyOWs/jIe4zWhAjK4UYDxhQU8slBTfyGM7d8u/k/qdZkIFTgK0mhmAORFDgejWz
         F8HUB9RSeK9Aj773FaMvBysYsRzL71B2tPj7Jk6mGKHT8m6aXPpNrtnickRammdr86Jj
         DaUw==
X-Gm-Message-State: AOAM532TM3I1YqVBno+gGr8ST6Z3gJRgNZwwfNyNCq8ERSgMikAlhKZF
        k3p3VMVQVOWXYCay/49e0u0f1JVzce0=
X-Google-Smtp-Source: ABdhPJyVjFy0eCR3RSyjWjiOH/Xps5ZO6nme7zFlVLS0wrtihMeEohRLeJUBK/+RwQkXpvLqqvNbGQ==
X-Received: by 2002:a17:906:c1d0:: with SMTP id bw16mr7689461ejb.146.1633108068357;
        Fri, 01 Oct 2021 10:07:48 -0700 (PDT)
Received: from localhost.localdomain ([85.255.233.39])
        by smtp.gmail.com with ESMTPSA id y93sm3604480ede.42.2021.10.01.10.07.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Oct 2021 10:07:48 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
Subject: [PATCH 1/4] io_uring: extra a helper for drain init
Date:   Fri,  1 Oct 2021 18:07:00 +0100
Message-Id: <dcb412825b35b1cb8891245a387d7d69f8d14cef.1633107393.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1633107393.git.asml.silence@gmail.com>
References: <cover.1633107393.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add a helper io_init_req_drain for initialising requests with
IOSQE_DRAIN set. Also move bits from preambule of io_drain_req() in
there, because we already modify all the bits needed inside the helper.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 48 ++++++++++++++++++++++--------------------------
 1 file changed, 22 insertions(+), 26 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ed5bff887294..e75d9cac7d45 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6432,28 +6432,11 @@ static u32 io_get_sequence(struct io_kiocb *req)
 
 static bool io_drain_req(struct io_kiocb *req)
 {
-	struct io_kiocb *pos;
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_defer_entry *de;
 	int ret;
 	u32 seq;
 
-	/* not interested in head, start from the first linked */
-	io_for_each_link(pos, req->link) {
-		/*
-		 * If we need to drain a request in the middle of a link, drain
-		 * the head request and the next request/link after the current
-		 * link. Considering sequential execution of links,
-		 * IOSQE_IO_DRAIN will be maintained for every request of our
-		 * link.
-		 */
-		if (pos->flags & REQ_F_IO_DRAIN) {
-			ctx->drain_next = true;
-			req->flags |= REQ_F_IO_DRAIN;
-			break;
-		}
-	}
-
 	/* Still need defer if there is pending req in defer list. */
 	if (likely(list_empty_careful(&ctx->defer_list) &&
 		!(req->flags & REQ_F_IO_DRAIN))) {
@@ -6994,6 +6977,25 @@ static inline bool io_check_restriction(struct io_ring_ctx *ctx,
 	return true;
 }
 
+static void io_init_req_drain(struct io_kiocb *req)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+	struct io_kiocb *head = ctx->submit_state.link.head;
+
+	ctx->drain_active = true;
+	if (head) {
+		/*
+		 * If we need to drain a request in the middle of a link, drain
+		 * the head request and the next request/link after the current
+		 * link. Considering sequential execution of links,
+		 * IOSQE_IO_DRAIN will be maintained for every request of our
+		 * link.
+		 */
+		head->flags |= IOSQE_IO_DRAIN | REQ_F_FORCE_ASYNC;
+		ctx->drain_next = true;
+	}
+}
+
 static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 		       const struct io_uring_sqe *sqe)
 	__must_hold(&ctx->uring_lock)
@@ -7020,14 +7022,8 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 		if ((sqe_flags & IOSQE_BUFFER_SELECT) &&
 		    !io_op_defs[req->opcode].buffer_select)
 			return -EOPNOTSUPP;
-		if (sqe_flags & IOSQE_IO_DRAIN) {
-			struct io_submit_link *link = &ctx->submit_state.link;
-
-			ctx->drain_active = true;
-			req->flags |= REQ_F_FORCE_ASYNC;
-			if (link->head)
-				link->head->flags |= IOSQE_IO_DRAIN | REQ_F_FORCE_ASYNC;
-		}
+		if (sqe_flags & IOSQE_IO_DRAIN)
+			io_init_req_drain(req);
 	}
 	if (unlikely(ctx->restricted || ctx->drain_active || ctx->drain_next)) {
 		if (ctx->restricted && !io_check_restriction(ctx, req, sqe_flags))
@@ -7039,7 +7035,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 		if (unlikely(ctx->drain_next) && !ctx->submit_state.link.head) {
 			ctx->drain_next = false;
 			ctx->drain_active = true;
-			req->flags |= REQ_F_FORCE_ASYNC | IOSQE_IO_DRAIN;
+			req->flags |= IOSQE_IO_DRAIN | REQ_F_FORCE_ASYNC;
 		}
 	}
 
-- 
2.33.0

