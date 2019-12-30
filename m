Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E243D12D35E
	for <lists+io-uring@lfdr.de>; Mon, 30 Dec 2019 19:25:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727578AbfL3SZf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 30 Dec 2019 13:25:35 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:37666 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727403AbfL3SZf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 30 Dec 2019 13:25:35 -0500
Received: by mail-wr1-f66.google.com with SMTP id w15so20808542wru.4
        for <io-uring@vger.kernel.org>; Mon, 30 Dec 2019 10:25:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=fsW4/X7gDIJmm7UzGEpbhgrf5iR7kzmK0hXi1hEuKkc=;
        b=engR8AaHciHI9AsIHt6gQqjtpDWR8TglPo1mUi1ewoPgIAcuOEGwpk7hLopbhHY7Bt
         F0/O8QeePgr4tpFSpvwe/3v1zwRDOK8QO8DYgiVBj5J9mDUEJWrGAeGdZV+BvO8IVMSa
         b0d3vk22Z0U99l+ND4r8p3zuBUdsMVxgHcPkiByhW3UTFgNUGXM0FNx1AgK8P3xNLMh9
         73ikY0hdUKza7hgFH3c/bKiwHhQb1WsVLUB+stNsZVIsmZZqzZ2JTr/oYqrK6kstEgPI
         XPEgOkUR7E+vI7f8Y0Yfog4/+k6CWg0b5g+vmJ37OG/xoOZeQ6CF8AcP6AemMF6EIA93
         N8VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fsW4/X7gDIJmm7UzGEpbhgrf5iR7kzmK0hXi1hEuKkc=;
        b=Zr2Mynf2lj4oAPF+O1W0zBvdMTfhLki4xQJ2Liga7kHLi7dbU2gO4IpCQxb+L3Ej+N
         xrMF8CWuVW8vP1vc8FbGUC/dGYdBkrI2nyMXJq2vygFei1v/HdZdckt0Eqw5tLY9EZeM
         S1fBh3iqzOerb9Xns27ETS9HxpRRlIVV0e41TsdsP9S8KaPGppqJGDeW90zAN8bFbGgC
         IorBzOHexGe17jZNa6kKUgOpZEkysLb52uFdh7RHooXcDd+CGD5Lb5e7kpK0O/heUjY6
         FbOHrlZN9auaDKIimCbiRa7ecZGB9vMs3WmjfCXKagUxgqFrfK9c4jWczTRvLuNZrr21
         Xlxg==
X-Gm-Message-State: APjAAAW+htr7bHTqcp4GRvEkfE5160yBd4gW4HwDvgxBoJxDU3M8nvur
        NXOfN0PXS/ln6x+DAwSp6CM=
X-Google-Smtp-Source: APXvYqyK2FMvOZ1R0eFxa9eRfZ4EznTd6cIMqSo7k2xlTYcLBXco5Yuw2VfM/tpVYDeVgu5c7uXOdA==
X-Received: by 2002:adf:de84:: with SMTP id w4mr65187787wrl.97.1577730333610;
        Mon, 30 Dec 2019 10:25:33 -0800 (PST)
Received: from localhost.localdomain ([109.126.145.157])
        by smtp.gmail.com with ESMTPSA id u24sm231590wml.10.2019.12.30.10.25.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Dec 2019 10:25:33 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 2/4] io_uring: optimise head checks in io_get_sqring()
Date:   Mon, 30 Dec 2019 21:24:45 +0300
Message-Id: <b0e560deb230f3417c81903370cd86cf2730323b.1577729827.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1577729827.git.asml.silence@gmail.com>
References: <cover.1577729827.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

A user may ask to submit more than there is in the ring, and then
io_uring will submit as much as it can. However, in the last iteration
it will allocate an io_kiocb and immediately free it. It could do
better and adjust @to_submit to what is in the ring.

And since the ring's head is already checked here, there is no need to
do it in the loop, spamming with smp_load_acquire()'s barriers

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 4105c0e591c7..05d07974a5b3 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4527,7 +4527,6 @@ static void io_commit_sqring(struct io_ring_ctx *ctx)
 static bool io_get_sqring(struct io_ring_ctx *ctx, struct io_kiocb *req,
 			  const struct io_uring_sqe **sqe_ptr)
 {
-	struct io_rings *rings = ctx->rings;
 	u32 *sq_array = ctx->sq_array;
 	unsigned head;
 
@@ -4539,12 +4538,7 @@ static bool io_get_sqring(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	 * 2) allows the kernel side to track the head on its own, even
 	 *    though the application is the one updating it.
 	 */
-	head = ctx->cached_sq_head;
-	/* make sure SQ entry isn't read before tail */
-	if (unlikely(head == smp_load_acquire(&rings->sq.tail)))
-		return false;
-
-	head = READ_ONCE(sq_array[head & ctx->sq_mask]);
+	head = READ_ONCE(sq_array[ctx->cached_sq_head & ctx->sq_mask]);
 	if (likely(head < ctx->sq_entries)) {
 		/*
 		 * All io need record the previous position, if LINK vs DARIN,
@@ -4562,7 +4556,7 @@ static bool io_get_sqring(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	/* drop invalid entries */
 	ctx->cached_sq_head++;
 	ctx->cached_sq_dropped++;
-	WRITE_ONCE(rings->sq_dropped, ctx->cached_sq_dropped);
+	WRITE_ONCE(ctx->rings->sq_dropped, ctx->cached_sq_dropped);
 	return false;
 }
 
@@ -4582,7 +4576,8 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 			return -EBUSY;
 	}
 
-	nr = min(nr, ctx->sq_entries);
+	/* make sure SQ entry isn't read before tail */
+	nr = min3(nr, ctx->sq_entries, io_sqring_entries(ctx));
 
 	if (!percpu_ref_tryget_many(&ctx->refs, nr))
 		return -EAGAIN;
-- 
2.24.0

