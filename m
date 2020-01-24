Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 733F8149055
	for <lists+io-uring@lfdr.de>; Fri, 24 Jan 2020 22:42:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729126AbgAXVl7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Jan 2020 16:41:59 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:54277 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727893AbgAXVll (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Jan 2020 16:41:41 -0500
Received: by mail-wm1-f66.google.com with SMTP id g1so851738wmh.4;
        Fri, 24 Jan 2020 13:41:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=aTJ1fbIal1Of4AIk62/89JEP3RsoGauWfsBc0D4lvQ8=;
        b=t+eG2WIGctM+TXhM7rdgSJittuU4rSOe5m1Dfca7505ikTAa52lsa7GVtG6tfpoxOS
         580u9QbWtHgVVsrQFhq6r17Una1kDP9UL6UdSiRz/sFSCHmGdD2o3GnYNQmtxVSjL3N5
         Z8NjPd47MnaDlJVZo9msCYkl2mTXZQUl+Gfqof7HPL4IkMfjITMzmeLRZaUYgnJR9KwM
         ka/zqJWyXMTtmmo9nSBUo2fg8E7jEErGnF5BS6ofhLUhmLjnjvxNZG/peqtrlbYnb3U2
         BaC7F3T3M6YmHsEogzbOoH7/xkh5wjG4pu7oCBHixPI0k6oW5f6x0VEROM6iXgtw1Aq2
         Lr5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aTJ1fbIal1Of4AIk62/89JEP3RsoGauWfsBc0D4lvQ8=;
        b=FbQ0yRqrgj9Ob4Los6R9tdJgWi/Xz6sUu/LnB6UxZlExmGkfkBtmYkT82b0W3Ryp0d
         gqZGaxcYRrIkbEDk5pehK/u6ip+F8MEeVkm2TWUP4EyRouJnFMXHFu8r4eDnpND7AHBD
         Jkc4R2o1MPw1xJ6/u566RIAd9GJ5/zG7uNTsAtTerShQQbjJF8CDsXRIyPSsyS7INc42
         GdFbP3pYoQaqYWVQl5tpZ4nm1oDJ4usihbfvxWe2KmL6e9Ltsdi5aumoN0WwPXVilo/1
         oOLioxxuKla4n6Z9KdFQDFReYsKSIaUswlhWgFfkx2dhUPMD3ynHkW4pkr3lYLGoQTe0
         kwsw==
X-Gm-Message-State: APjAAAVecMOUTW3O8SNT8mfxychi5AJO3Pk/Y6X+Y40b0LW04Yz22GT4
        WJQ6+0l6FMoG4Ck1hsoni+K2RPEv
X-Google-Smtp-Source: APXvYqwQqT4NmJbS/+5n+iSZLb3iT0FO176nItFYp9dVM3a/WRdMYVV5SmhOeX91k+5paAnUnAlQnA==
X-Received: by 2002:a05:600c:22d3:: with SMTP id 19mr1124984wmg.92.1579902100140;
        Fri, 24 Jan 2020 13:41:40 -0800 (PST)
Received: from localhost.localdomain ([109.126.145.157])
        by smtp.gmail.com with ESMTPSA id f16sm9203055wrm.65.2020.01.24.13.41.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jan 2020 13:41:39 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6/8] io_uring: move *link into io_submit_state
Date:   Sat, 25 Jan 2020 00:40:29 +0300
Message-Id: <11a42896513c9349fad154c201e69e03ec52bf8c.1579901866.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1579901866.git.asml.silence@gmail.com>
References: <cover.1579901866.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

It's more convenient to have it in the submission state, than passing as
a pointer, so move it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c0e72390d272..f022453e3839 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -221,6 +221,7 @@ struct io_submit_state {
 	int			ring_fd;
 
 	struct mm_struct	*mm;
+	struct io_kiocb		*link;
 };
 
 struct io_ring_ctx {
@@ -4664,10 +4665,10 @@ static inline void io_queue_link_head(struct io_kiocb *req)
 #define SQE_VALID_FLAGS	(IOSQE_FIXED_FILE|IOSQE_IO_DRAIN|IOSQE_IO_LINK|	\
 				IOSQE_IO_HARDLINK | IOSQE_ASYNC)
 
-static bool io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
-			  struct io_kiocb **link)
+static bool io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_ring_ctx *ctx = req->ctx;
+	struct io_submit_state *state = &ctx->submit_state;
 	unsigned int sqe_flags;
 	int ret;
 
@@ -4697,8 +4698,8 @@ static bool io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	 * submitted sync once the chain is complete. If none of those
 	 * conditions are true (normal request), then just queue it.
 	 */
-	if (*link) {
-		struct io_kiocb *head = *link;
+	if (state->link) {
+		struct io_kiocb *head = state->link;
 
 		/*
 		 * Taking sequential execution of a link, draining both sides
@@ -4728,7 +4729,7 @@ static bool io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 		/* last request of a link, enqueue the link */
 		if (!(sqe_flags & (IOSQE_IO_LINK|IOSQE_IO_HARDLINK))) {
 			io_queue_link_head(head);
-			*link = NULL;
+			state->link = NULL;
 		}
 	} else {
 		if (unlikely(ctx->drain_next)) {
@@ -4741,7 +4742,7 @@ static bool io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			ret = io_req_defer_prep(req, sqe);
 			if (ret)
 				req->flags |= REQ_F_FAIL_LINK;
-			*link = req;
+			state->link = req;
 		} else {
 			io_queue_sqe(req, sqe);
 		}
@@ -4761,6 +4762,8 @@ static void io_submit_end(struct io_ring_ctx *ctx)
 	if (state->free_reqs)
 		kmem_cache_free_bulk(req_cachep, state->free_reqs,
 					&state->reqs[state->cur_req]);
+	if (state->link)
+		io_queue_link_head(state->link);
 }
 
 /*
@@ -4777,6 +4780,7 @@ static void io_submit_start(struct io_ring_ctx *ctx, unsigned int max_ios,
 
 	state->ring_file = ring_file;
 	state->ring_fd = ring_fd;
+	state->link = NULL;
 }
 
 static void io_commit_sqring(struct io_ring_ctx *ctx)
@@ -4839,7 +4843,6 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 			  struct file *ring_file, int ring_fd, bool async)
 {
 	struct blk_plug plug;
-	struct io_kiocb *link = NULL;
 	int i, submitted = 0;
 	bool mm_fault = false;
 
@@ -4897,14 +4900,12 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 		req->needs_fixed_file = async;
 		trace_io_uring_submit_sqe(ctx, req->opcode, req->user_data,
 						true, async);
-		if (!io_submit_sqe(req, sqe, &link))
+		if (!io_submit_sqe(req, sqe))
 			break;
 	}
 
 	if (submitted != nr)
 		percpu_ref_put_many(&ctx->refs, nr - submitted);
-	if (link)
-		io_queue_link_head(link);
 
 	io_submit_end(ctx);
 	if (nr > IO_PLUG_THRESHOLD)
-- 
2.24.0

