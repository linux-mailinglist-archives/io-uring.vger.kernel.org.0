Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6FE331EEFD
	for <lists+io-uring@lfdr.de>; Thu, 18 Feb 2021 19:54:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233387AbhBRSwa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 18 Feb 2021 13:52:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231691AbhBRSgg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 18 Feb 2021 13:36:36 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E2D0C06121C
        for <io-uring@vger.kernel.org>; Thu, 18 Feb 2021 10:33:54 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id o82so4661877wme.1
        for <io-uring@vger.kernel.org>; Thu, 18 Feb 2021 10:33:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=SkoDsucK4hIUHzoUqBtL3UTF6DUNGrYPy4JbNSIryRU=;
        b=qUgqKyjrZan7roEA1nqoXgYzwzuB0ENZIm9Sn2BV6KRbVXozjxyl52hyBHx1MM1F7u
         AN/ptqJZcCqsHO/OiIOEFBLrXmQ1xfaO404l3X4X69R9jdxs6Gr5aACTDckxUu55nWfo
         jEJYuEc9raG+uJYDf24VhJJQ/aF9+/ltcdQQnMcaLxzfGtus2u6vsSFqfTB7zXOJF2Ti
         C8V3SxNvhh2v1Ohd3aX7WVnYweBhRPiIGPRmYkcACFk0zZCVQx8UkUd6qjF9YnIbWKsc
         nI93ZzKOGzZLH7Vpdx19NPONv/49Bk8ZeACmSKByaZh5BtzDjNPoBumjAng4pxXK9uDr
         qijQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SkoDsucK4hIUHzoUqBtL3UTF6DUNGrYPy4JbNSIryRU=;
        b=gA4DmzpjO4UXmbhUsUk7/MBx4aONgXK7q0TxvoAXevG56xhuz2PsB9XrOSNUpiiYJ/
         v+BExU5DnIGEmNJiwL59l3KJn/2Cz6zaoETS8NW/ubzfB/Pwiae7mdbKaN5cWXu9MFhk
         OvcP+ye2C0M6Wl6DoDuQorYqIpbwg7xT1tMyVPiWoo+i9NYo25jO34jgm2wHByG+JOyc
         O/ispNCQ2zHcZiW8bi1OckCCuvSX6qHMsCmiANGfDM1/ciwfkPpiDvuogeWFVYPSj6DA
         4w3IjdWeKo50dm2yR1xX0Cw/b+K3lPoI/asa/d1KK57Z0oZCEn8FsXtKmqy7uV8UR96t
         ZbRw==
X-Gm-Message-State: AOAM53151nIawXYSHQs3a0zxxrLDAo/XqarAVVeld3zYGqEGMBOAeGcb
        pG9rvGfGClKXZPWY1kzXAqwOgSL72ixfkQ==
X-Google-Smtp-Source: ABdhPJy4IV1uCi2LswXxEDSxjBTL8resjPW88zmRltdIJxz/KDZW2rp99Dc9hd8kxDVebgaQeob/DQ==
X-Received: by 2002:a1c:4d05:: with SMTP id o5mr4807802wmh.51.1613673233302;
        Thu, 18 Feb 2021 10:33:53 -0800 (PST)
Received: from localhost.localdomain ([85.255.236.139])
        by smtp.gmail.com with ESMTPSA id 36sm4034459wrh.94.2021.02.18.10.33.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Feb 2021 10:33:52 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 09/11] io_uring: do io_*_prep() early in io_submit_sqe()
Date:   Thu, 18 Feb 2021 18:29:45 +0000
Message-Id: <ca9f9d69892f328a4e245943eb07f47b0f65a260.1613671791.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1613671791.git.asml.silence@gmail.com>
References: <cover.1613671791.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Now as preparations are split from async setup, we can do the first one
pretty early not spilling it across multiple call sites. And after it's
done SQE is not needed anymore and we can save on passing it deeply into
the submission stack.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 59 +++++++++++++++++++++------------------------------
 1 file changed, 24 insertions(+), 35 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 987cfd8db213..7d54b0abbb82 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6160,22 +6160,16 @@ static int io_req_prep_async(struct io_kiocb *req)
 	return 0;
 }
 
-static int io_req_defer_prep(struct io_kiocb *req,
-			     const struct io_uring_sqe *sqe)
+static int io_req_defer_prep(struct io_kiocb *req)
 {
-	int ret;
-
-	if (!sqe)
+	if (!io_op_defs[req->opcode].needs_async_data)
 		return 0;
-	if (io_alloc_async_data(req))
-		return -EAGAIN;
-	ret = io_req_prep(req, sqe);
-	if (ret)
-		return ret;
+	/* some opcodes init it during the inital prep */
 	if (req->async_data)
-		return io_req_prep_async(req);
-	return 0;
-
+		return 0;
+	if (__io_alloc_async_data(req))
+		return -EAGAIN;
+	return io_req_prep_async(req);
 }
 
 static u32 io_get_sequence(struct io_kiocb *req)
@@ -6191,7 +6185,7 @@ static u32 io_get_sequence(struct io_kiocb *req)
 	return total_submitted - nr_reqs;
 }
 
-static int io_req_defer(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+static int io_req_defer(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_defer_entry *de;
@@ -6208,11 +6202,9 @@ static int io_req_defer(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (!req_need_defer(req, seq) && list_empty_careful(&ctx->defer_list))
 		return 0;
 
-	if (!req->async_data) {
-		ret = io_req_defer_prep(req, sqe);
-		if (ret)
-			return ret;
-	}
+	ret = io_req_defer_prep(req);
+	if (ret)
+		return ret;
 	io_prep_async_link(req);
 	de = kmalloc(sizeof(*de), GFP_KERNEL);
 	if (!de)
@@ -6631,11 +6623,11 @@ static void __io_queue_sqe(struct io_kiocb *req)
 		io_queue_linked_timeout(linked_timeout);
 }
 
-static void io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+static void io_queue_sqe(struct io_kiocb *req)
 {
 	int ret;
 
-	ret = io_req_defer(req, sqe);
+	ret = io_req_defer(req);
 	if (ret) {
 		if (ret != -EIOCBQUEUED) {
 fail_req:
@@ -6644,18 +6636,11 @@ static void io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 			io_req_complete(req, ret);
 		}
 	} else if (req->flags & REQ_F_FORCE_ASYNC) {
-		if (!req->async_data) {
-			ret = io_req_defer_prep(req, sqe);
-			if (unlikely(ret))
-				goto fail_req;
-		}
+		ret = io_req_defer_prep(req);
+		if (unlikely(ret))
+			goto fail_req;
 		io_queue_async_work(req);
 	} else {
-		if (sqe) {
-			ret = io_req_prep(req, sqe);
-			if (unlikely(ret))
-				goto fail_req;
-		}
 		__io_queue_sqe(req);
 	}
 }
@@ -6666,7 +6651,7 @@ static inline void io_queue_link_head(struct io_kiocb *req)
 		io_put_req(req);
 		io_req_complete(req, -ECANCELED);
 	} else
-		io_queue_sqe(req, NULL);
+		io_queue_sqe(req);
 }
 
 /*
@@ -6788,7 +6773,11 @@ static int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
 			link->head->flags |= REQ_F_FAIL_LINK;
 		return ret;
 	}
+	ret = io_req_prep(req, sqe);
+	if (unlikely(ret))
+		goto fail_req;
 
+	/* don't need @sqe from now on */
 	trace_io_uring_submit_sqe(ctx, req->opcode, req->user_data,
 				true, ctx->flags & IORING_SETUP_SQPOLL);
 
@@ -6813,7 +6802,7 @@ static int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
 			head->flags |= REQ_F_IO_DRAIN;
 			ctx->drain_next = 1;
 		}
-		ret = io_req_defer_prep(req, sqe);
+		ret = io_req_defer_prep(req);
 		if (unlikely(ret))
 			goto fail_req;
 		trace_io_uring_link(ctx, req, head);
@@ -6831,13 +6820,13 @@ static int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
 			ctx->drain_next = 0;
 		}
 		if (req->flags & (REQ_F_LINK | REQ_F_HARDLINK)) {
-			ret = io_req_defer_prep(req, sqe);
+			ret = io_req_defer_prep(req);
 			if (unlikely(ret))
 				req->flags |= REQ_F_FAIL_LINK;
 			link->head = req;
 			link->last = req;
 		} else {
-			io_queue_sqe(req, sqe);
+			io_queue_sqe(req);
 		}
 	}
 
-- 
2.24.0

