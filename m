Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 959F14178ED
	for <lists+io-uring@lfdr.de>; Fri, 24 Sep 2021 18:36:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347499AbhIXQiV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Sep 2021 12:38:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347584AbhIXQh5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Sep 2021 12:37:57 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFCD5C0612A3
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 09:33:03 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id g8so38221605edt.7
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 09:33:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=rhw8kmRS89etFbKYmo4ENGJ5XnXS2E6m2UcIso45jIs=;
        b=ogTjjsv4rTmHZtJ+jlhMHl74RMnXEXgP2NxZSX0iH9sIHd5BMiRqZUovYqpl0blfo4
         uRoIbUcnMNC3FgqfjAGp0Lwi2IE+753bDW/yobRE6QYq6FvwfiJl9kFnsgn2Bv+hoikh
         psHnufqflrp51TFORPNa2gp7sVPpZzfAen058B7ZPp4gC1QhF5Ct8IRFMo0V6LVCN84h
         gHOpmSpAq7KShqRXuRufu12OWXbgqomsvBxG+vbDyYtjcfjnqyBGp+D1awoXZ8EW0L2B
         IilNUegqJLrQzqtKB7+5BmKXeRCRj+r4fZR7HF5UK4CWGV5rOg4/cWK1fYQV9W0D1+vv
         wZ2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rhw8kmRS89etFbKYmo4ENGJ5XnXS2E6m2UcIso45jIs=;
        b=1tqWggzdNtx4gZFy+uGqYQ/9bXkbj+XtbxG5ge2Gp3Q18VEsNboFOtSr9TL68jbxLu
         2Rz98UbnNKXmXEcjy0piFxPxryO3MlXbk09WrkhaB6HvSvAzdusqfJwUAS9ZSo7ffXmp
         J0Y4MxgDAVBiCNa7T6FTekp98l8a0FP+RftC1V6/kur+fV/Xo2icqpA8V75ZTpcAxweO
         G3yL/rXnQ/re6Tgsrp6WE3BXL58namHC4OrlWWwjJ74IwcYGhYSByQ33XonS7FkcmPbY
         llr8QK9qdta11N3Vw6qLjeRbrf1vAbCdIILWXMagrsFJEeoG+21PjYd79mbVXUR1menY
         itLA==
X-Gm-Message-State: AOAM530LpFMdHjEmndB/chKcpjj0zgXO63IYA1J/tFxwbwyAbKsDpyGU
        XI8zPiFnFvV3ZMPdWD9EIAAHkr7rWTo=
X-Google-Smtp-Source: ABdhPJzPXYo0DfXW71ms3JyGc1Um1InS22qCOe1yf706JCcDCri2V9Ymwy91xWgc0Ws/9zUEveJ0/w==
X-Received: by 2002:a50:9d8e:: with SMTP id w14mr5909590ede.74.1632501182303;
        Fri, 24 Sep 2021 09:33:02 -0700 (PDT)
Received: from localhost.localdomain ([85.255.232.225])
        by smtp.gmail.com with ESMTPSA id w10sm6167021eds.30.2021.09.24.09.33.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 09:33:02 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 17/23] io_uring: remove drain_active check from hot path
Date:   Fri, 24 Sep 2021 17:31:55 +0100
Message-Id: <c09c5cdbb08bec098271148ab46ef8562d6b0181.1632500264.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1632500264.git.asml.silence@gmail.com>
References: <cover.1632500264.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

req->ctx->active_drain is a bit too expensive, partially because of two
dereferences. Do a trick, if we see it set in io_init_req(), set
REQ_F_FORCE_ASYNC and it automatically goes through a slower path where
we can catch it. It's nearly free to do in io_init_req() because there
is already ->restricted check and it's in the same byte of a bitmask.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 53 ++++++++++++++++++++++++++++-----------------------
 1 file changed, 29 insertions(+), 24 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5cffbfc8a61f..c1c967088252 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6430,23 +6430,15 @@ static bool io_drain_req(struct io_kiocb *req)
 	int ret;
 	u32 seq;
 
-	if (req->flags & REQ_F_FAIL) {
-		io_req_complete_fail_submit(req);
-		return true;
-	}
-
-	/*
-	 * If we need to drain a request in the middle of a link, drain the
-	 * head request and the next request/link after the current link.
-	 * Considering sequential execution of links, IOSQE_IO_DRAIN will be
-	 * maintained for every request of our link.
-	 */
-	if (ctx->drain_next) {
-		req->flags |= REQ_F_IO_DRAIN;
-		ctx->drain_next = false;
-	}
 	/* not interested in head, start from the first linked */
 	io_for_each_link(pos, req->link) {
+		/*
+		 * If we need to drain a request in the middle of a link, drain
+		 * the head request and the next request/link after the current
+		 * link. Considering sequential execution of links,
+		 * IOSQE_IO_DRAIN will be maintained for every request of our
+		 * link.
+		 */
 		if (pos->flags & REQ_F_IO_DRAIN) {
 			ctx->drain_next = true;
 			req->flags |= REQ_F_IO_DRAIN;
@@ -6938,13 +6930,12 @@ static void __io_queue_sqe(struct io_kiocb *req)
 static inline void io_queue_sqe(struct io_kiocb *req)
 	__must_hold(&req->ctx->uring_lock)
 {
-	if (unlikely(req->ctx->drain_active) && io_drain_req(req))
-		return;
-
 	if (likely(!(req->flags & (REQ_F_FORCE_ASYNC | REQ_F_FAIL)))) {
 		__io_queue_sqe(req);
 	} else if (req->flags & REQ_F_FAIL) {
 		io_req_complete_fail_submit(req);
+	} else if (unlikely(req->ctx->drain_active) && io_drain_req(req)) {
+		return;
 	} else {
 		int ret = io_req_prep_async(req);
 
@@ -6964,9 +6955,6 @@ static inline bool io_check_restriction(struct io_ring_ctx *ctx,
 					struct io_kiocb *req,
 					unsigned int sqe_flags)
 {
-	if (likely(!ctx->restricted))
-		return true;
-
 	if (!test_bit(req->opcode, ctx->restrictions.sqe_op))
 		return false;
 
@@ -7007,11 +6995,28 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 		if ((sqe_flags & IOSQE_BUFFER_SELECT) &&
 		    !io_op_defs[req->opcode].buffer_select)
 			return -EOPNOTSUPP;
-		if (sqe_flags & IOSQE_IO_DRAIN)
+		if (sqe_flags & IOSQE_IO_DRAIN) {
+			struct io_submit_link *link = &ctx->submit_state.link;
+
 			ctx->drain_active = true;
+			req->flags |= REQ_F_FORCE_ASYNC;
+			if (link->head)
+				link->head->flags |= IOSQE_IO_DRAIN | REQ_F_FORCE_ASYNC;
+		}
+	}
+	if (unlikely(ctx->restricted || ctx->drain_active || ctx->drain_next)) {
+		if (ctx->restricted && !io_check_restriction(ctx, req, sqe_flags))
+			return -EACCES;
+		/* knock it to the slow queue path, will be drained there */
+		if (ctx->drain_active)
+			req->flags |= REQ_F_FORCE_ASYNC;
+		/* if there is no link, we're at "next" request and need to drain */
+		if (unlikely(ctx->drain_next) && !ctx->submit_state.link.head) {
+			ctx->drain_next = false;
+			ctx->drain_active = true;
+			req->flags |= REQ_F_FORCE_ASYNC | IOSQE_IO_DRAIN;
+		}
 	}
-	if (!io_check_restriction(ctx, req, sqe_flags))
-		return -EACCES;
 
 	personality = READ_ONCE(sqe->personality);
 	if (personality) {
-- 
2.33.0

