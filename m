Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA873319DCA
	for <lists+io-uring@lfdr.de>; Fri, 12 Feb 2021 13:04:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229965AbhBLMAv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 12 Feb 2021 07:00:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231194AbhBLL7v (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 12 Feb 2021 06:59:51 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2201AC061574
        for <io-uring@vger.kernel.org>; Fri, 12 Feb 2021 03:59:11 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id r21so7514901wrr.9
        for <io-uring@vger.kernel.org>; Fri, 12 Feb 2021 03:59:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WgrkfW+pQiBaTnW3/R+PO9qFb1i2q6Fk6rcxxrdHyfo=;
        b=IlNZBsqr9ttvguvZMmr3Ni+oPwKBZD3zsuJSz1fnaH3kWyNqdf2tqiMbvLNs9ddLTo
         JZGkbSQf0+QMakMkMOSeRJPi9DAakqsgrnpLY4S3APZDqpErhNR8FU8jpnRySFST/a+b
         uEBfomLdcUDTappf7c8Cr3VxbjsV/UdUqtlGWyLw9dQc6HwvDoR8edC7MMyjOrjT+wdU
         FYEu4OHWdOkucQjfCnRGwri1JSGv7xCmcH026VvLGwtPDgLyZ784MldLxV9R//vPfgSl
         IjbMu4P5MCQwoJ4u88yjCTIJClrqlbVWukEIA8l14APA7ilpOJHuRZutzTmkkFyHVWXV
         YcNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WgrkfW+pQiBaTnW3/R+PO9qFb1i2q6Fk6rcxxrdHyfo=;
        b=UoxOQ6Huyx5sUV74RtxSqvPS56HdLUiVl6cjv8c9EVZG3UPmHA0mEzcVlt/xoO2SL/
         jC5GuSqzW995DFT9lWam2wHHgZWXGkxD5UuKC0yHVUBhiAPoKxbjqgEU6p9VKEtTj9Ky
         xdOTIMp0/vjaPf+CPaxnap8v4ktL8/rBIeFejJFDjk1cf0eeTdWaS7VVQchAESajJFEl
         va8kpe4Fbqd5wZo998tIy93j07Iax/VkW5c3sFFLm11PFmbtxdrVI8Nx/Vjueit86Evh
         2/ol26N4LsZdFYHjF6XGjkEeOY6df9d8PZDyZ5rjqtoRB8tdAJJvNYqiE0LYnGP08UoK
         f+6Q==
X-Gm-Message-State: AOAM533vgTeLNnSte0K91udsLiFS8KZINYIZ0NJ3WKVeXkmB41yPZKdy
        9oZRGrheQTtPfVXvmwdoapiF40Ov1C5CBA==
X-Google-Smtp-Source: ABdhPJzHREyx2NJKFfa+sWV8v2wmlCn5V8jLZZcRWfmwBSyAgnIPhA5D1EXYkwD/+o7oeRLzdO1uZg==
X-Received: by 2002:a5d:4708:: with SMTP id y8mr3006052wrq.402.1613131149838;
        Fri, 12 Feb 2021 03:59:09 -0800 (PST)
Received: from localhost.localdomain ([185.69.144.228])
        by smtp.gmail.com with ESMTPSA id y15sm9948569wrm.93.2021.02.12.03.59.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Feb 2021 03:59:09 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 1/1] io_uring: don't split out consume out of SQE get
Date:   Fri, 12 Feb 2021 11:55:17 +0000
Message-Id: <5294703c66d2c332377c1f0d258c6baa70d736a7.1613130703.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Remove io_consume_sqe() and inline it back into io_get_sqe(). It
requires req dealloc on error, but in exchange we get cleaner
io_submit_sqes() and better locality for cached_sq_head.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 87f2f8e660e8..9c58be0579f3 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6762,7 +6762,7 @@ static const struct io_uring_sqe *io_get_sqe(struct io_ring_ctx *ctx)
 	 * 2) allows the kernel side to track the head on its own, even
 	 *    though the application is the one updating it.
 	 */
-	head = READ_ONCE(sq_array[ctx->cached_sq_head & ctx->sq_mask]);
+	head = READ_ONCE(sq_array[ctx->cached_sq_head++ & ctx->sq_mask]);
 	if (likely(head < ctx->sq_entries))
 		return &ctx->sq_sqes[head];
 
@@ -6772,11 +6772,6 @@ static const struct io_uring_sqe *io_get_sqe(struct io_ring_ctx *ctx)
 	return NULL;
 }
 
-static inline void io_consume_sqe(struct io_ring_ctx *ctx)
-{
-	ctx->cached_sq_head++;
-}
-
 /*
  * Check SQE restrictions (opcode and flags).
  *
@@ -6915,18 +6910,17 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 		struct io_kiocb *req;
 		int err;
 
-		sqe = io_get_sqe(ctx);
-		if (unlikely(!sqe)) {
-			io_consume_sqe(ctx);
-			break;
-		}
 		req = io_alloc_req(ctx);
 		if (unlikely(!req)) {
 			if (!submitted)
 				submitted = -EAGAIN;
 			break;
 		}
-		io_consume_sqe(ctx);
+		sqe = io_get_sqe(ctx);
+		if (unlikely(!sqe)) {
+			kmem_cache_free(req_cachep, req);
+			break;
+		}
 		/* will complete beyond this point, count as submitted */
 		submitted++;
 
-- 
2.24.0

