Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B1703E4532
	for <lists+io-uring@lfdr.de>; Mon,  9 Aug 2021 14:05:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235334AbhHIMF1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Aug 2021 08:05:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235332AbhHIMF1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Aug 2021 08:05:27 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA78AC0613D3
        for <io-uring@vger.kernel.org>; Mon,  9 Aug 2021 05:05:06 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id c9so21050195wri.8
        for <io-uring@vger.kernel.org>; Mon, 09 Aug 2021 05:05:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=I+p/cJm4aUDkvyNdc12YvtUC6YHUgVKc2uIuiTzMGMs=;
        b=fe2HyNQbm9kuEhs2729sp3AeOyW/9XRmATBu2I1hQwqkAtuf9D8k0JUjVVidN84/kg
         CHmUfBeW9ek9s6lfOOrSiNkYSi3QrlbnroYJKsP1wb01YWXiREs3kX11id/MX99dm7BK
         Q9juzTnrd0kgwY2UVc2xCXanHWAzOBu4HFfPYLV9taD2+u2AShtogDO2XP5iz4ALBGU6
         DNIZMYk3xgHcXCAaEkDAutToKTU7dvjHRahk+WYOLRzOi3zQF0uHyQrLWQE4MGQk9Lcq
         ez4W0BwEaOSdZHdaf1Z5vG+BEhWyv1MSXGDO2H450JR9jM2kp34W5nS/AItw8GYtvRQV
         6Yag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=I+p/cJm4aUDkvyNdc12YvtUC6YHUgVKc2uIuiTzMGMs=;
        b=Bc6psXJZ9Casx4HAaEsoFHbKbmgcdZELc79KLAbPKcH5g7yAa0F2AGjWDUvBsCigeU
         3TX+zrsLO7GlcncHbYc0n0mDmS0meRoi+iUPBrlA2LKIiPKH7AaqXi8vjMUIDvuPHL5S
         huJ/IErpdbayHLrUQoooseytdHfzo4riwIYcCxbOqBqm8yMO6BlEi8SvXKFgqD29YXLi
         z7Uch0BtH9gJJbCHTljdnZNcl4yK07dxpPqcgW0ybaT+CLVjs1Fk8Gi4JY9nR/Xmi4DF
         ohIRVc/tMVFctDkJBnPY/uOITzrlqvikpRoN/Rs82A5PkMHrHg5rNyRJlIolliXg8kO0
         oQIQ==
X-Gm-Message-State: AOAM533mFnJxtteH4fbEVr7aJfq2ciA2tn8vzoPcGEtLnjs22udXKbXK
        V0GdR0Nd2MaZ62KTUJtoYbFNbwBUR6I=
X-Google-Smtp-Source: ABdhPJx1VqhUJu6wHhHHV5NHRIyxgqotHE32ivHa4X6oF95ipju0ta+hadnDW0VUhZrgjXb89keHYA==
X-Received: by 2002:adf:ea41:: with SMTP id j1mr24662143wrn.147.1628510705511;
        Mon, 09 Aug 2021 05:05:05 -0700 (PDT)
Received: from localhost.localdomain ([85.255.236.119])
        by smtp.gmail.com with ESMTPSA id g35sm4757062wmp.9.2021.08.09.05.05.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 05:05:05 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 02/28] io_uring: inline fixed part of io_file_get()
Date:   Mon,  9 Aug 2021 13:04:02 +0100
Message-Id: <52115cd6ce28f33bd0923149c0e6cb611084a0b1.1628471125.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1628471125.git.asml.silence@gmail.com>
References: <cover.1628471125.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Optimise io_file_get() with registered files, which is in a hot path,
by inlining parts of the function. Saves a function call, and
inefficiencies of passing arguments, e.g. evaluating
(sqe_flags & IOSQE_FIXED_FILE).

It couldn't have been done before as compilers were refusing to inline
it because of the function size.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 65 ++++++++++++++++++++++++++++++---------------------
 1 file changed, 39 insertions(+), 26 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5072f84ef99f..900c1a4d6a0a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1058,7 +1058,8 @@ static int __io_register_rsrc_update(struct io_ring_ctx *ctx, unsigned type,
 				     struct io_uring_rsrc_update2 *up,
 				     unsigned nr_args);
 static void io_clean_op(struct io_kiocb *req);
-static struct file *io_file_get(struct io_submit_state *state,
+static struct file *io_file_get(struct io_ring_ctx *ctx,
+				struct io_submit_state *state,
 				struct io_kiocb *req, int fd, bool fixed);
 static void __io_queue_sqe(struct io_kiocb *req);
 static void io_rsrc_put_work(struct work_struct *work);
@@ -3622,7 +3623,8 @@ static int __io_splice_prep(struct io_kiocb *req,
 	if (unlikely(sp->flags & ~valid_flags))
 		return -EINVAL;
 
-	sp->file_in = io_file_get(NULL, req, READ_ONCE(sqe->splice_fd_in),
+	sp->file_in = io_file_get(req->ctx, NULL, req,
+				  READ_ONCE(sqe->splice_fd_in),
 				  (sp->flags & SPLICE_F_FD_IN_FIXED));
 	if (!sp->file_in)
 		return -EBADF;
@@ -6354,36 +6356,48 @@ static void io_fixed_file_set(struct io_fixed_file *file_slot, struct file *file
 	file_slot->file_ptr = file_ptr;
 }
 
-static struct file *io_file_get(struct io_submit_state *state,
-				struct io_kiocb *req, int fd, bool fixed)
+static inline struct file *io_file_get_fixed(struct io_ring_ctx *ctx,
+					     struct io_kiocb *req, int fd)
 {
-	struct io_ring_ctx *ctx = req->ctx;
 	struct file *file;
+	unsigned long file_ptr;
 
-	if (fixed) {
-		unsigned long file_ptr;
+	if (unlikely((unsigned int)fd >= ctx->nr_user_files))
+		return NULL;
+	fd = array_index_nospec(fd, ctx->nr_user_files);
+	file_ptr = io_fixed_file_slot(&ctx->file_table, fd)->file_ptr;
+	file = (struct file *) (file_ptr & FFS_MASK);
+	file_ptr &= ~FFS_MASK;
+	/* mask in overlapping REQ_F and FFS bits */
+	req->flags |= (file_ptr << REQ_F_ASYNC_READ_BIT);
+	io_req_set_rsrc_node(req);
+	return file;
+}
 
-		if (unlikely((unsigned int)fd >= ctx->nr_user_files))
-			return NULL;
-		fd = array_index_nospec(fd, ctx->nr_user_files);
-		file_ptr = io_fixed_file_slot(&ctx->file_table, fd)->file_ptr;
-		file = (struct file *) (file_ptr & FFS_MASK);
-		file_ptr &= ~FFS_MASK;
-		/* mask in overlapping REQ_F and FFS bits */
-		req->flags |= (file_ptr << REQ_F_ASYNC_READ_BIT);
-		io_req_set_rsrc_node(req);
-	} else {
-		trace_io_uring_file_get(ctx, fd);
-		file = __io_file_get(state, fd);
+static struct file *io_file_get_normal(struct io_ring_ctx *ctx,
+				       struct io_submit_state *state,
+				       struct io_kiocb *req, int fd)
+{
+	struct file *file = __io_file_get(state, fd);
 
-		/* we don't allow fixed io_uring files */
-		if (file && unlikely(file->f_op == &io_uring_fops))
-			io_req_track_inflight(req);
-	}
+	trace_io_uring_file_get(ctx, fd);
 
+	/* we don't allow fixed io_uring files */
+	if (file && unlikely(file->f_op == &io_uring_fops))
+		io_req_track_inflight(req);
 	return file;
 }
 
+static inline struct file *io_file_get(struct io_ring_ctx *ctx,
+				       struct io_submit_state *state,
+				       struct io_kiocb *req, int fd, bool fixed)
+{
+	if (fixed)
+		return io_file_get_fixed(ctx, req, fd);
+	else
+		return io_file_get_normal(ctx, state, req, fd);
+}
+
 static enum hrtimer_restart io_link_timeout_fn(struct hrtimer *timer)
 {
 	struct io_timeout_data *data = container_of(timer,
@@ -6590,9 +6604,8 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	}
 
 	if (io_op_defs[req->opcode].needs_file) {
-		bool fixed = req->flags & REQ_F_FIXED_FILE;
-
-		req->file = io_file_get(state, req, READ_ONCE(sqe->fd), fixed);
+		req->file = io_file_get(ctx, state, req, READ_ONCE(sqe->fd),
+					(sqe_flags & IOSQE_FIXED_FILE));
 		if (unlikely(!req->file))
 			ret = -EBADF;
 	}
-- 
2.32.0

