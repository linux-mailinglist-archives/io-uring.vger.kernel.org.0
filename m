Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7379A1A1BBC
	for <lists+io-uring@lfdr.de>; Wed,  8 Apr 2020 08:00:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726555AbgDHGAL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Apr 2020 02:00:11 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:39305 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726680AbgDHGAC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Apr 2020 02:00:02 -0400
Received: by mail-wm1-f68.google.com with SMTP id y24so41680wma.4;
        Tue, 07 Apr 2020 23:00:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=0GRl9hplB7dTuIb/0RMEadqZcZYJpa7Pjh6TqfFWfDU=;
        b=FjVCjF+Nc3E3GqeQBjQVVimZ9W4DU7MXFg46Slo9lJplg8Z0AByeiHQqASYgEITYRq
         BZtckQbgItEKZ/bvDP8bGqmli8nVl5SdZ1Wuu6zlUCDx5EJ7l/hIXMFNodngFSk5Qiyj
         xz6KJjJoKkUo1mf5q/q1boP+xbrASOzfg/NX1MX7yCrKPNTHA6+2lsdEVKrb8VjBNGn1
         ArcWtQNmvvlvueNffxEQJY0APE+aAk+PrIGuEUVUYNBjwqLlwJ3xdWUpc26lsuTQWWpF
         Dynoiv/cTI62jq7dt+X2OXADN4KEE1cIBH773r956hUreupyhbmTmrIDsIpEDUoqPV18
         PfwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0GRl9hplB7dTuIb/0RMEadqZcZYJpa7Pjh6TqfFWfDU=;
        b=pGrSvpp6z9cEgxkizX1dvGoUE0HRvmZwmtaP6naFfdkmM27gSjuYp28SAJwh7CrJ+6
         /37V2HMNgdnmRjZAXh7Gom0VEridHcT9PBjMigWUXDAe3v7lRudJHjetqlB5hcsw8Y/b
         4nWY12XExEKeymXsbKe9nPAyE61CH3xtqY1EPgJzNjCA5K8t+S3xgBF9oZ51zuM06jmS
         B1Inx+vIqbvVTZ7eQ+ECO4FabzqxQG2VTQoyOT82U3r8DoBueTCgeq+MfS2QrEOO9xaP
         4SN3rnNMa43b6AuEzJV5zoQ2Lb+FbqsZ95qxU7FsW9dc1Du346Df5vordtcQ9acnGrXV
         zT/Q==
X-Gm-Message-State: AGi0PuYQskirmRc6015/UInWfbUD6gWYnEn3JfZ/bf3Y95/3TOLdcJzQ
        qQ7qXxDhSWD2RD2zsUl9Ui5uIMQp
X-Google-Smtp-Source: APiQypI+3fa52zGMHOwuiUaGH9naPnYkrzfOeWCAM055EPTdsu3GXBF3z/24bg0SQ2T4fK/z3lcmDA==
X-Received: by 2002:a05:600c:22d6:: with SMTP id 22mr2817761wmg.121.1586325600426;
        Tue, 07 Apr 2020 23:00:00 -0700 (PDT)
Received: from localhost.localdomain ([109.126.129.227])
        by smtp.gmail.com with ESMTPSA id b15sm33454986wru.70.2020.04.07.22.59.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Apr 2020 23:00:00 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] io_uring: remove req init from io_get_req()
Date:   Wed,  8 Apr 2020 08:58:45 +0300
Message-Id: <c30d8b27f0cf836dbb3be6079a3e4e2c37c7f726.1586325467.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1586325467.git.asml.silence@gmail.com>
References: <cover.1586325467.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_get_req() do two different things: io_kiocb allocation and
initialisation. Move init part out of it and rename into
io_alloc_req(). It's simpler this way and also have better data
locality.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 53 ++++++++++++++++++++++++++-------------------------
 1 file changed, 27 insertions(+), 26 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 9c3e920e789f..072e002f1184 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1293,8 +1293,8 @@ static struct io_kiocb *io_get_fallback_req(struct io_ring_ctx *ctx)
 	return NULL;
 }
 
-static struct io_kiocb *io_get_req(struct io_ring_ctx *ctx,
-				   struct io_submit_state *state)
+static struct io_kiocb *io_alloc_req(struct io_ring_ctx *ctx,
+				     struct io_submit_state *state)
 {
 	gfp_t gfp = GFP_KERNEL | __GFP_NOWARN;
 	struct io_kiocb *req;
@@ -1327,22 +1327,9 @@ static struct io_kiocb *io_get_req(struct io_ring_ctx *ctx,
 		req = state->reqs[state->free_reqs];
 	}
 
-got_it:
-	req->io = NULL;
-	req->file = NULL;
-	req->ctx = ctx;
-	req->flags = 0;
-	/* one is dropped after submission, the other at completion */
-	refcount_set(&req->refs, 2);
-	req->task = NULL;
-	req->result = 0;
-	INIT_IO_WORK(&req->work, io_wq_submit_work);
 	return req;
 fallback:
-	req = io_get_fallback_req(ctx);
-	if (req)
-		goto got_it;
-	return NULL;
+	return io_get_fallback_req(ctx);
 }
 
 static inline void io_put_file(struct io_kiocb *req, struct file *file,
@@ -5801,6 +5788,28 @@ static inline void io_consume_sqe(struct io_ring_ctx *ctx)
 	ctx->cached_sq_head++;
 }
 
+static void io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
+			const struct io_uring_sqe *sqe)
+{
+	/*
+	 * All io need record the previous position, if LINK vs DARIN,
+	 * it can be used to mark the position of the first IO in the
+	 * link list.
+	 */
+	req->sequence = ctx->cached_sq_head;
+	req->opcode = READ_ONCE(sqe->opcode);
+	req->user_data = READ_ONCE(sqe->user_data);
+	req->io = NULL;
+	req->file = NULL;
+	req->ctx = ctx;
+	req->flags = 0;
+	/* one is dropped after submission, the other at completion */
+	refcount_set(&req->refs, 2);
+	req->task = NULL;
+	req->result = 0;
+	INIT_IO_WORK(&req->work, io_wq_submit_work);
+}
+
 static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 			  struct file *ring_file, int ring_fd,
 			  struct mm_struct **mm, bool async)
@@ -5841,23 +5850,15 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 			io_consume_sqe(ctx);
 			break;
 		}
-		req = io_get_req(ctx, statep);
+		req = io_alloc_req(ctx, statep);
 		if (unlikely(!req)) {
 			if (!submitted)
 				submitted = -EAGAIN;
 			break;
 		}
 
-		/*
-		 * All io need record the previous position, if LINK vs DARIN,
-		 * it can be used to mark the position of the first IO in the
-		 * link list.
-		 */
-		req->sequence = ctx->cached_sq_head;
-		req->opcode = READ_ONCE(sqe->opcode);
-		req->user_data = READ_ONCE(sqe->user_data);
+		io_init_req(ctx, req, sqe);
 		io_consume_sqe(ctx);
-
 		/* will complete beyond this point, count as submitted */
 		submitted++;
 
-- 
2.24.0

