Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E87AB3274F2
	for <lists+io-uring@lfdr.de>; Sun, 28 Feb 2021 23:42:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231612AbhB1Wkq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 28 Feb 2021 17:40:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231605AbhB1Wkp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 28 Feb 2021 17:40:45 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0E92C0617A9
        for <io-uring@vger.kernel.org>; Sun, 28 Feb 2021 14:39:29 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id m1so12674673wml.2
        for <io-uring@vger.kernel.org>; Sun, 28 Feb 2021 14:39:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=8l+BF2+V42z6QbPe+IEtvndmpE3B9uvk2DGGksWlZJU=;
        b=dRb8CzUyaZe2QJagm5uiPwnOgfW4bPa/mJo7JGSN2xiSNgBP4cyzT1J0BzSGQKqWDK
         6NJjZOEvZugVKEDc2/GGc3LdkNbEj7dInQtbcMH1IjxyaNOTk4c/Rk9kSZtbuNW2Vvhx
         VnqDZNCnE8P2VuF1D+iqkWyTQBHgLbq94e280odvvohoI2ZdqRKgEArCKT/Gx9h2kmjT
         FVavVCpSUh+6MNQnDeW4lx7ugP5we9fjtws9XkhOi5lk8KNZxVg2rPsk8HFtz2kj6pm+
         pKKYEV4QQBE5riZJB0InrUzn5jT2OwxtIb1rEArunaewy3Q+fTM4ypmvpxzGG9fYBgJX
         YnNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8l+BF2+V42z6QbPe+IEtvndmpE3B9uvk2DGGksWlZJU=;
        b=ZhpPvsny4s2pvRgiEOs9T4NW11HHFeuEQEg6kEExqTd5wU4/c8kGcTNEl56LRUPsKb
         UHHk+n2bupaoCw1UrT15sYryxSc8aacYFUNlO2WRiwLlfkx05Qhx/z2PAfZ8qUo2PVpp
         89bJ0ydOe2jaxACky5qscPKl8gKmBCObIsl7o6Ai0VCj00aLBntYHUqpX8+T90qLVg1n
         gOwynDlMzbR1BV6RwAmWv2QI0uLaO8AaCldY4SeWU1Ma4+p+XSzORNYu4yIE7HTIj4cn
         MuMz8D7m719O4PE8U3lzOE09pVieH5BYUEP58gPMJANeDrQwVlAdtvjMZkZTq8vmi2lN
         VhVw==
X-Gm-Message-State: AOAM533OEJZCGFlHcyDUtLdoNasHmsHTYQp2TB+tRO+ECTx+wY037/iC
        hkRxE/R8Jqlfl+D2T0Cnw2I=
X-Google-Smtp-Source: ABdhPJxa8hPCRAwFtgA5L3F9WNxymNgUu0MV7qOd4dGvbq5gQriqkjL/CINHXR6WdtJt08+p5gnppA==
X-Received: by 2002:a1c:df8a:: with SMTP id w132mr12816149wmg.53.1614551968571;
        Sun, 28 Feb 2021 14:39:28 -0800 (PST)
Received: from localhost.localdomain ([85.255.232.38])
        by smtp.gmail.com with ESMTPSA id y62sm22832576wmy.9.2021.02.28.14.39.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Feb 2021 14:39:28 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 11/12] io_uring: merge defer_prep() and prep_async()
Date:   Sun, 28 Feb 2021 22:35:19 +0000
Message-Id: <ca85c69810b09b134e0b097366b7fb1548fbd53c.1614551467.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1614551467.git.asml.silence@gmail.com>
References: <cover.1614551467.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Merge two function and do renaming in favour of the second one, it
relays the meaning better.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c9ab7ee5d500..0bdaf5105d11 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5734,6 +5734,13 @@ static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 static int io_req_prep_async(struct io_kiocb *req)
 {
+	if (!io_op_defs[req->opcode].needs_async_setup)
+		return 0;
+	if (WARN_ON_ONCE(req->async_data))
+		return -EFAULT;
+	if (io_alloc_async_data(req))
+		return -EAGAIN;
+
 	switch (req->opcode) {
 	case IORING_OP_READV:
 		return io_rw_prep_async(req, READ);
@@ -5746,18 +5753,9 @@ static int io_req_prep_async(struct io_kiocb *req)
 	case IORING_OP_CONNECT:
 		return io_connect_prep_async(req);
 	}
-	return 0;
-}
-
-static int io_req_defer_prep(struct io_kiocb *req)
-{
-	if (!io_op_defs[req->opcode].needs_async_setup)
-		return 0;
-	if (WARN_ON_ONCE(req->async_data))
-		return -EFAULT;
-	if (io_alloc_async_data(req))
-		return -EAGAIN;
-	return io_req_prep_async(req);
+	printk_once(KERN_WARNING "io_uring: prep_async() bad opcode %d\n",
+		    req->opcode);
+	return -EFAULT;
 }
 
 static u32 io_get_sequence(struct io_kiocb *req)
@@ -5790,7 +5788,7 @@ static int io_req_defer(struct io_kiocb *req)
 	if (!req_need_defer(req, seq) && list_empty_careful(&ctx->defer_list))
 		return 0;
 
-	ret = io_req_defer_prep(req);
+	ret = io_req_prep_async(req);
 	if (ret)
 		return ret;
 	io_prep_async_link(req);
@@ -6216,7 +6214,7 @@ static void io_queue_sqe(struct io_kiocb *req)
 			io_req_complete_failed(req, ret);
 		}
 	} else if (req->flags & REQ_F_FORCE_ASYNC) {
-		ret = io_req_defer_prep(req);
+		ret = io_req_prep_async(req);
 		if (unlikely(ret))
 			goto fail_req;
 		io_queue_async_work(req);
@@ -6362,7 +6360,7 @@ static int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
 			head->flags |= REQ_F_IO_DRAIN;
 			ctx->drain_next = 1;
 		}
-		ret = io_req_defer_prep(req);
+		ret = io_req_prep_async(req);
 		if (unlikely(ret))
 			goto fail_req;
 		trace_io_uring_link(ctx, req, head);
-- 
2.24.0

