Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59C8B1A1BB5
	for <lists+io-uring@lfdr.de>; Wed,  8 Apr 2020 08:00:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726652AbgDHGAA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Apr 2020 02:00:00 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:43561 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726632AbgDHF77 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Apr 2020 01:59:59 -0400
Received: by mail-wr1-f68.google.com with SMTP id i10so60393wrv.10;
        Tue, 07 Apr 2020 22:59:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=MyjaqxTspVHB0RoR9euNSLMsUfgZpaBT76QDvi+tcPY=;
        b=jISq4ag9INN0cNDo2K+g6jCxeXOqsphf8TjUX0yQlnkuLr3OeinztmyQ2QO+mYy7gE
         nAUMUGGouwiwrVMu1MOhy/nx/IYEjO0bO8zFxWcyDuw5pgoDwRo+53RRWEll905lroCF
         jXleU5ibmsQwD00Z72Tlk7bhaXw47oBjspBMqH9JgY4/B9OztNjOGUJ2NXwAv+zryfy5
         846LCVItAj10cC1JbJBPnyrcG+z8ZzF6NgTxoD1VFaxoEsYFZM3crZN7mTBq7LKQf54A
         kbOb21z/YVLial51op+byM2fc+gWo8Og+rNDnAdHeFk2uvDtu1JHFVYRhSVi+zGVhNb+
         d7nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MyjaqxTspVHB0RoR9euNSLMsUfgZpaBT76QDvi+tcPY=;
        b=GYc00IsW6qEOZVAv65o9oOe6/KGv9F8mta2kWVPxUShZcvsq5wE+PIphn2I6Ilv6Ce
         wiWpKVoJk2J9Ew+2tfTolx0IJDWYPfUXsZVBXnGRy+UqUpUhu52P9o/sUMeaYFin2Up3
         E7Te8AheWrK/MishiJw4X4b5Yh2/HsiSvrIros0O/r/jWnUucNgqNTMKiKZrWOaAGFcE
         DltxprXDxhIRqLLzPV9gb/lr0Fr0QQt+naywqbSEmM+hlL07qdD5TN3MrEa+DqA8vH5k
         DajhDrhs2rsuYig2hVHteLsmKDLtvjOqw7RY296U8FsZqRGAjRkzaYsRnDS9JGqAXkFm
         Oz3Q==
X-Gm-Message-State: AGi0Pua6t1h5pxlYSTE5bUvRx9piuX36GyCpqCpHT82syaXXjCbzXbqa
        seW4R1pYD3ujTdm7G2bsQXZqB3mO
X-Google-Smtp-Source: APiQypLegS5WMPl3g+9MEOlDr71NIpgtUy8WBSrYzKd6kkrHURT/M9N1a6W5wqL9Df79bmMRFMiKGQ==
X-Received: by 2002:adf:a3cb:: with SMTP id m11mr6564982wrb.225.1586325597645;
        Tue, 07 Apr 2020 22:59:57 -0700 (PDT)
Received: from localhost.localdomain ([109.126.129.227])
        by smtp.gmail.com with ESMTPSA id b15sm33454986wru.70.2020.04.07.22.59.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Apr 2020 22:59:57 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] io_uring: simplify io_get_sqring
Date:   Wed,  8 Apr 2020 08:58:43 +0300
Message-Id: <419217cd0b30c49511f26f50dbfc66ab4c0f54f6.1586325467.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1586325467.git.asml.silence@gmail.com>
References: <cover.1586325467.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Make io_get_sqring() to care only about sqes but not initialising
io_kiocb. Also, split it into get + consume, that will be helpful in the
future.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 40 ++++++++++++++++++++++------------------
 1 file changed, 22 insertions(+), 18 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 773f55c49cd8..fa6b7bb62616 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5778,8 +5778,7 @@ static void io_commit_sqring(struct io_ring_ctx *ctx)
  * used, it's important that those reads are done through READ_ONCE() to
  * prevent a re-load down the line.
  */
-static bool io_get_sqring(struct io_ring_ctx *ctx, struct io_kiocb *req,
-			  const struct io_uring_sqe **sqe_ptr)
+static const struct io_uring_sqe *io_get_sqe(struct io_ring_ctx *ctx)
 {
 	u32 *sq_array = ctx->sq_array;
 	unsigned head;
@@ -5793,25 +5792,18 @@ static bool io_get_sqring(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	 *    though the application is the one updating it.
 	 */
 	head = READ_ONCE(sq_array[ctx->cached_sq_head & ctx->sq_mask]);
-	if (likely(head < ctx->sq_entries)) {
-		/*
-		 * All io need record the previous position, if LINK vs DARIN,
-		 * it can be used to mark the position of the first IO in the
-		 * link list.
-		 */
-		req->sequence = ctx->cached_sq_head;
-		*sqe_ptr = &ctx->sq_sqes[head];
-		req->opcode = READ_ONCE((*sqe_ptr)->opcode);
-		req->user_data = READ_ONCE((*sqe_ptr)->user_data);
-		ctx->cached_sq_head++;
-		return true;
-	}
+	if (likely(head < ctx->sq_entries))
+		return &ctx->sq_sqes[head];
 
 	/* drop invalid entries */
-	ctx->cached_sq_head++;
 	ctx->cached_sq_dropped++;
 	WRITE_ONCE(ctx->rings->sq_dropped, ctx->cached_sq_dropped);
-	return false;
+	return NULL;
+}
+
+static inline void io_consume_sqe(struct io_ring_ctx *ctx)
+{
+	ctx->cached_sq_head++;
 }
 
 static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
@@ -5855,11 +5847,23 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 				submitted = -EAGAIN;
 			break;
 		}
-		if (!io_get_sqring(ctx, req, &sqe)) {
+		sqe = io_get_sqe(ctx);
+		if (!sqe) {
 			__io_req_do_free(req);
+			io_consume_sqe(ctx);
 			break;
 		}
 
+		/*
+		 * All io need record the previous position, if LINK vs DARIN,
+		 * it can be used to mark the position of the first IO in the
+		 * link list.
+		 */
+		req->sequence = ctx->cached_sq_head;
+		req->opcode = READ_ONCE(sqe->opcode);
+		req->user_data = READ_ONCE(sqe->user_data);
+		io_consume_sqe(ctx);
+
 		/* will complete beyond this point, count as submitted */
 		submitted++;
 
-- 
2.24.0

