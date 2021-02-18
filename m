Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0869A31EEF3
	for <lists+io-uring@lfdr.de>; Thu, 18 Feb 2021 19:54:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231391AbhBRSvw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 18 Feb 2021 13:51:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232683AbhBRSf5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 18 Feb 2021 13:35:57 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D37BC0617AA
        for <io-uring@vger.kernel.org>; Thu, 18 Feb 2021 10:33:49 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id o10so3304100wmc.1
        for <io-uring@vger.kernel.org>; Thu, 18 Feb 2021 10:33:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=2iQCZQQZpDVXpoQzIJilWCaJe/zryqZnTflKK4fnN5g=;
        b=TL6ikVEUKYTsN8663HDkuOLQYo7oQAzQ0v8WW3b3zDhcWOTUEKzRhKwA+uo9zhGJ+l
         KLQ3GpUDZjy7IdAHXP2zq2+a8LBCg9g7sBhOiUpdM2eoGMxy0Y1XYVEtDU62hCwOmV72
         T5LVL4Ksi4p02WCCgHrQ5eRqafAmk3RjPip6HoKlnNNuJTZGaaZsy3XKv5wO+WQK0Cpv
         DKmuy0VOZRWaFz51Jglu4h61crKR9mXdInCTZ8J/cGeOecYPqxXho7zlPXUhYA2Dkd7g
         piTZhhIbtMwaOFI1VAGSCKobiaz7mgzfj6+xfmioTkLWTbYP4XSm4zJNBs+IDr8G2jpf
         oJGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2iQCZQQZpDVXpoQzIJilWCaJe/zryqZnTflKK4fnN5g=;
        b=DfA61PqzV1ishwkM7x31zDFO3l6iuHFvx4sx6FuEzgRm0D2qUjYO2BPF9RaT2xQ85v
         FbEVYFWUhA8I0UqM7F6bDEaDa/7FROQ5I0mvU0nOfI+257JyBZl6OdQhPi9Bzm2O0ffu
         W6XshaiBeqeTUnnPEabMLnD0DcMHvzCMAgywsxNeeu3nhEOAN11cMH1iQuvGLsnIxsbe
         68PRmfPltgqlbrZdV891y4rmsQssCR1yXl39u0q99SofrdxXrvDsRSGaxjkiyuZ01fDA
         QLl2rnUG/AsAEezh3Vkup2CLeepH3BGmCf70TMGBkiNhSdhqn5zHEx45L/BmO5JRaOsV
         rjSA==
X-Gm-Message-State: AOAM531084U+GFUDhcz8MX0WhPnGlHpt92B3/r8MKtTi0TaCsrg564+N
        c9y7hrgLmNycWTA8ajv0ZMg=
X-Google-Smtp-Source: ABdhPJw7737Bicsvlwyx6jh/hxtDg2uzg/IQUHIZcOvCBGTUQVgpvVFQsbujqe/VXlwMB/SFOwK30Q==
X-Received: by 2002:a05:600c:4eca:: with SMTP id g10mr229596wmq.149.1613673227978;
        Thu, 18 Feb 2021 10:33:47 -0800 (PST)
Received: from localhost.localdomain ([85.255.236.139])
        by smtp.gmail.com with ESMTPSA id 36sm4034459wrh.94.2021.02.18.10.33.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Feb 2021 10:33:47 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 04/11] io_uring: move io_init_req()'s definition
Date:   Thu, 18 Feb 2021 18:29:40 +0000
Message-Id: <aeec2162f68527ba8016201f4dc984d8ec8d8230.1613671791.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1613671791.git.asml.silence@gmail.com>
References: <cover.1613671791.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

A preparation patch, symbol to symbol move io_init_req() +
io_check_restriction() a bit up. The submission path is pretty settled
down, so don't worry about backports and move the functions instead of
relying on forward declarations in the future.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 214 +++++++++++++++++++++++++-------------------------
 1 file changed, 107 insertions(+), 107 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index db6680bb02d3..1563853caac5 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -104,6 +104,10 @@
 #define IORING_MAX_RESTRICTIONS	(IORING_RESTRICTION_LAST + \
 				 IORING_REGISTER_LAST + IORING_OP_LAST)
 
+#define SQE_VALID_FLAGS	(IOSQE_FIXED_FILE|IOSQE_IO_DRAIN|IOSQE_IO_LINK|	\
+				IOSQE_IO_HARDLINK | IOSQE_ASYNC | \
+				IOSQE_BUFFER_SELECT)
+
 struct io_uring {
 	u32 head ____cacheline_aligned_in_smp;
 	u32 tail ____cacheline_aligned_in_smp;
@@ -6639,6 +6643,109 @@ static inline void io_queue_link_head(struct io_kiocb *req)
 		io_queue_sqe(req, NULL);
 }
 
+/*
+ * Check SQE restrictions (opcode and flags).
+ *
+ * Returns 'true' if SQE is allowed, 'false' otherwise.
+ */
+static inline bool io_check_restriction(struct io_ring_ctx *ctx,
+					struct io_kiocb *req,
+					unsigned int sqe_flags)
+{
+	if (!ctx->restricted)
+		return true;
+
+	if (!test_bit(req->opcode, ctx->restrictions.sqe_op))
+		return false;
+
+	if ((sqe_flags & ctx->restrictions.sqe_flags_required) !=
+	    ctx->restrictions.sqe_flags_required)
+		return false;
+
+	if (sqe_flags & ~(ctx->restrictions.sqe_flags_allowed |
+			  ctx->restrictions.sqe_flags_required))
+		return false;
+
+	return true;
+}
+
+static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
+		       const struct io_uring_sqe *sqe)
+{
+	struct io_submit_state *state;
+	unsigned int sqe_flags;
+	int id, ret = 0;
+
+	req->opcode = READ_ONCE(sqe->opcode);
+	/* same numerical values with corresponding REQ_F_*, safe to copy */
+	req->flags = sqe_flags = READ_ONCE(sqe->flags);
+	req->user_data = READ_ONCE(sqe->user_data);
+	req->async_data = NULL;
+	req->file = NULL;
+	req->ctx = ctx;
+	req->link = NULL;
+	req->fixed_rsrc_refs = NULL;
+	/* one is dropped after submission, the other at completion */
+	refcount_set(&req->refs, 2);
+	req->task = current;
+	req->result = 0;
+
+	/* enforce forwards compatibility on users */
+	if (unlikely(sqe_flags & ~SQE_VALID_FLAGS))
+		return -EINVAL;
+
+	if (unlikely(req->opcode >= IORING_OP_LAST))
+		return -EINVAL;
+
+	if (unlikely(io_sq_thread_acquire_mm_files(ctx, req)))
+		return -EFAULT;
+
+	if (unlikely(!io_check_restriction(ctx, req, sqe_flags)))
+		return -EACCES;
+
+	if ((sqe_flags & IOSQE_BUFFER_SELECT) &&
+	    !io_op_defs[req->opcode].buffer_select)
+		return -EOPNOTSUPP;
+
+	id = READ_ONCE(sqe->personality);
+	if (id) {
+		struct io_identity *iod;
+
+		iod = idr_find(&ctx->personality_idr, id);
+		if (unlikely(!iod))
+			return -EINVAL;
+		refcount_inc(&iod->count);
+
+		__io_req_init_async(req);
+		get_cred(iod->creds);
+		req->work.identity = iod;
+		req->work.flags |= IO_WQ_WORK_CREDS;
+	}
+
+	state = &ctx->submit_state;
+
+	/*
+	 * Plug now if we have more than 1 IO left after this, and the target
+	 * is potentially a read/write to block based storage.
+	 */
+	if (!state->plug_started && state->ios_left > 1 &&
+	    io_op_defs[req->opcode].plug) {
+		blk_start_plug(&state->plug);
+		state->plug_started = true;
+	}
+
+	if (io_op_defs[req->opcode].needs_file) {
+		bool fixed = req->flags & REQ_F_FIXED_FILE;
+
+		req->file = io_file_get(state, req, READ_ONCE(sqe->fd), fixed);
+		if (unlikely(!req->file))
+			ret = -EBADF;
+	}
+
+	state->ios_left--;
+	return ret;
+}
+
 struct io_submit_link {
 	struct io_kiocb *head;
 	struct io_kiocb *last;
@@ -6771,113 +6878,6 @@ static const struct io_uring_sqe *io_get_sqe(struct io_ring_ctx *ctx)
 	return NULL;
 }
 
-/*
- * Check SQE restrictions (opcode and flags).
- *
- * Returns 'true' if SQE is allowed, 'false' otherwise.
- */
-static inline bool io_check_restriction(struct io_ring_ctx *ctx,
-					struct io_kiocb *req,
-					unsigned int sqe_flags)
-{
-	if (!ctx->restricted)
-		return true;
-
-	if (!test_bit(req->opcode, ctx->restrictions.sqe_op))
-		return false;
-
-	if ((sqe_flags & ctx->restrictions.sqe_flags_required) !=
-	    ctx->restrictions.sqe_flags_required)
-		return false;
-
-	if (sqe_flags & ~(ctx->restrictions.sqe_flags_allowed |
-			  ctx->restrictions.sqe_flags_required))
-		return false;
-
-	return true;
-}
-
-#define SQE_VALID_FLAGS	(IOSQE_FIXED_FILE|IOSQE_IO_DRAIN|IOSQE_IO_LINK|	\
-				IOSQE_IO_HARDLINK | IOSQE_ASYNC | \
-				IOSQE_BUFFER_SELECT)
-
-static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
-		       const struct io_uring_sqe *sqe)
-{
-	struct io_submit_state *state;
-	unsigned int sqe_flags;
-	int id, ret = 0;
-
-	req->opcode = READ_ONCE(sqe->opcode);
-	/* same numerical values with corresponding REQ_F_*, safe to copy */
-	req->flags = sqe_flags = READ_ONCE(sqe->flags);
-	req->user_data = READ_ONCE(sqe->user_data);
-	req->async_data = NULL;
-	req->file = NULL;
-	req->ctx = ctx;
-	req->link = NULL;
-	req->fixed_rsrc_refs = NULL;
-	/* one is dropped after submission, the other at completion */
-	refcount_set(&req->refs, 2);
-	req->task = current;
-	req->result = 0;
-
-	/* enforce forwards compatibility on users */
-	if (unlikely(sqe_flags & ~SQE_VALID_FLAGS))
-		return -EINVAL;
-
-	if (unlikely(req->opcode >= IORING_OP_LAST))
-		return -EINVAL;
-
-	if (unlikely(io_sq_thread_acquire_mm_files(ctx, req)))
-		return -EFAULT;
-
-	if (unlikely(!io_check_restriction(ctx, req, sqe_flags)))
-		return -EACCES;
-
-	if ((sqe_flags & IOSQE_BUFFER_SELECT) &&
-	    !io_op_defs[req->opcode].buffer_select)
-		return -EOPNOTSUPP;
-
-	id = READ_ONCE(sqe->personality);
-	if (id) {
-		struct io_identity *iod;
-
-		iod = idr_find(&ctx->personality_idr, id);
-		if (unlikely(!iod))
-			return -EINVAL;
-		refcount_inc(&iod->count);
-
-		__io_req_init_async(req);
-		get_cred(iod->creds);
-		req->work.identity = iod;
-		req->work.flags |= IO_WQ_WORK_CREDS;
-	}
-
-	state = &ctx->submit_state;
-
-	/*
-	 * Plug now if we have more than 1 IO left after this, and the target
-	 * is potentially a read/write to block based storage.
-	 */
-	if (!state->plug_started && state->ios_left > 1 &&
-	    io_op_defs[req->opcode].plug) {
-		blk_start_plug(&state->plug);
-		state->plug_started = true;
-	}
-
-	if (io_op_defs[req->opcode].needs_file) {
-		bool fixed = req->flags & REQ_F_FIXED_FILE;
-
-		req->file = io_file_get(state, req, READ_ONCE(sqe->fd), fixed);
-		if (unlikely(!req->file))
-			ret = -EBADF;
-	}
-
-	state->ios_left--;
-	return ret;
-}
-
 static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 {
 	struct io_submit_link link;
-- 
2.24.0

