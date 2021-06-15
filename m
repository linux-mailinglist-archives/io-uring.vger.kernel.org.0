Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C4EA3A8458
	for <lists+io-uring@lfdr.de>; Tue, 15 Jun 2021 17:48:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231753AbhFOPu1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Jun 2021 11:50:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231718AbhFOPuZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Jun 2021 11:50:25 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9C2AC061767
        for <io-uring@vger.kernel.org>; Tue, 15 Jun 2021 08:48:20 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id t11-20020a1cc30b0000b02901cec841b6a0so1136989wmf.0
        for <io-uring@vger.kernel.org>; Tue, 15 Jun 2021 08:48:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=WGH9fXa9TRNmk3xuaIbTR1N4K8kEnu0SWyecXhBasPQ=;
        b=Iqz/PMwFDYlQh5edj14gF9MXREQqqV9VA6kZhmqdP6ADDVPrOCsl/RAgIUmU6v+oPE
         e9XYAdMEdGPkLDFovgajq19PO7jJvj4EQD7SzL3Gji+oE3EFzgjbJwOAxgPuG8HXK1Do
         mzgI0Kz9RAgUBmRWhp7vUj+7f6xWS4oiuAilGOCibSQIknuK5COvwAC9UunBOOrCczBL
         QxuXEnyeTN8hGwvz2otjrPBj0utMLdau5mkdel6yO0JVfpd74eRj/YV1R41OybPrRcEU
         RUsw89OGC3zhA/xNjWY4cE9qDlRfmwEVR65ZKmAhq9FJY3HTx2HLnfzBQz5L6kzUMEWu
         QMCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WGH9fXa9TRNmk3xuaIbTR1N4K8kEnu0SWyecXhBasPQ=;
        b=q878DGKELPoLLHql0jhzLfB3kh3Ie05WHjn0pB385toycqwkFrSYL/5UqKAbns9m5U
         XLIQCcCK+lqzz9I2klAUrND+NXXQboFcYey0jaDxFR+hNoeqfcmofsIjCZ/76KcfFwK4
         qUbPxtO/VXdQEja3T4ZzTx+OoAy7xD2lqp7GIHG91C99n2RQWEcdNWfcDhVvY2iDB44Y
         g0614iWlpDitb8q7XmY/Xf9+ln5thWZqex/ltH4v0a2jfRFOlYUv69ieE6DcMfD6Pklr
         tLlE6Ld2LnB3eh32OkQKeLlwbTgBn1ix1cq6nH73UUT5mwEQSbXigYmh9GEHNvuPpxLt
         W7rA==
X-Gm-Message-State: AOAM530k6w8dGQ6PEOnDeOfDflssKeLB10oAWab3XWOr4AuCw7QLOEtM
        NkuupdwrOr7ZGxoHXVxsDns=
X-Google-Smtp-Source: ABdhPJxJsMTCyjYG0ypqA2Xq1FlePbpZeswBpACbsU3Wba7mdHpEXogXO9xN5UQruoYPpRoLPTS+Zg==
X-Received: by 2002:a7b:c931:: with SMTP id h17mr5089206wml.168.1623772099347;
        Tue, 15 Jun 2021 08:48:19 -0700 (PDT)
Received: from localhost.localdomain ([148.252.132.209])
        by smtp.gmail.com with ESMTPSA id o3sm20136378wrm.78.2021.06.15.08.48.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Jun 2021 08:48:19 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 2/3] io_uring: shove more drain bits out of hot path
Date:   Tue, 15 Jun 2021 16:47:57 +0100
Message-Id: <68bf4f7395ddaafbf1a26bd97b57d57d45a9f900.1623772051.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1623772051.git.asml.silence@gmail.com>
References: <cover.1623772051.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Place all drain_next logic into io_drain_req(), so it's never executed
if there was no drained requests before. The only thing we need is to
set ->drain_active if we see a request with IOSQE_IO_DRAIN, do that in
io_init_req() where flags are definitely in registers.

Also, all drain-related code is encapsulated in io_drain_req(), makes it
cleaner.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 42 ++++++++++++++++++++++--------------------
 1 file changed, 22 insertions(+), 20 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 07f8ef039938..947500af425c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5997,11 +5997,31 @@ static u32 io_get_sequence(struct io_kiocb *req)
 
 static bool io_drain_req(struct io_kiocb *req)
 {
+	struct io_kiocb *pos;
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_defer_entry *de;
 	int ret;
 	u32 seq;
 
+	/*
+	 * If we need to drain a request in the middle of a link, drain the
+	 * head request and the next request/link after the current link.
+	 * Considering sequential execution of links, IOSQE_IO_DRAIN will be
+	 * maintained for every request of our link.
+	 */
+	if (ctx->drain_next) {
+		req->flags |= REQ_F_IO_DRAIN;
+		ctx->drain_next = false;
+	}
+	/* not interested in head, start from the first linked */
+	io_for_each_link(pos, req->link) {
+		if (pos->flags & REQ_F_IO_DRAIN) {
+			ctx->drain_next = true;
+			req->flags |= REQ_F_IO_DRAIN;
+			break;
+		}
+	}
+
 	/* Still need defer if there is pending req in defer list. */
 	if (likely(list_empty_careful(&ctx->defer_list) &&
 		!(req->flags & REQ_F_IO_DRAIN))) {
@@ -6522,6 +6542,8 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	if ((sqe_flags & IOSQE_BUFFER_SELECT) &&
 	    !io_op_defs[req->opcode].buffer_select)
 		return -EOPNOTSUPP;
+	if (unlikely(sqe_flags & IOSQE_IO_DRAIN))
+		ctx->drain_active = true;
 
 	personality = READ_ONCE(sqe->personality);
 	if (personality) {
@@ -6573,22 +6595,6 @@ static int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
 		return ret;
 	}
 
-	if (unlikely(req->flags & REQ_F_IO_DRAIN)) {
-		ctx->drain_active = true;
-
-		/*
-		 * Taking sequential execution of a link, draining both sides
-		 * of the link also fullfils IOSQE_IO_DRAIN semantics for all
-		 * requests in the link. So, it drains the head and the
-		 * next after the link request. The last one is done via
-		 * drain_next flag to persist the effect across calls.
-		 */
-		if (link->head) {
-			link->head->flags |= REQ_F_IO_DRAIN;
-			ctx->drain_next = 1;
-		}
-	}
-
 	ret = io_req_prep(req, sqe);
 	if (unlikely(ret))
 		goto fail_req;
@@ -6621,10 +6627,6 @@ static int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
 			io_queue_sqe(head);
 		}
 	} else {
-		if (unlikely(ctx->drain_next)) {
-			req->flags |= REQ_F_IO_DRAIN;
-			ctx->drain_next = 0;
-		}
 		if (req->flags & (REQ_F_LINK | REQ_F_HARDLINK)) {
 			link->head = req;
 			link->last = req;
-- 
2.31.1

