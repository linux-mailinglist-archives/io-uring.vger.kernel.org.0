Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 040D712BEAA
	for <lists+io-uring@lfdr.de>; Sat, 28 Dec 2019 20:21:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726455AbfL1TVY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 28 Dec 2019 14:21:24 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:37132 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726362AbfL1TVY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 28 Dec 2019 14:21:24 -0500
Received: by mail-pg1-f193.google.com with SMTP id q127so16100470pga.4
        for <io-uring@vger.kernel.org>; Sat, 28 Dec 2019 11:21:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1aUhtdil3rL+gH32qN402lmfSrdySv3dNFkkHxnrFik=;
        b=b51XnSMiaebBDPpUw5eBoW8pAr4K2mgLL25IUpVh5YoNzsQDDqyrgZARGGKF3FEX/k
         +M31Lq5Tn5ufFNw51c5NqY2CMhnDHT+ywxH2MNCVrnon5HP8QXSZQZJ1ooCTOO5BAMyx
         F1bKxRn3BGM/mqOzXjOUBdj1xKvF9owgJTTFzuTOdHKaUtcr6kB40av1+OYp12y1u8m6
         kCZoPnK+tGiOmtaP7JiaVHNbSRFOulg+pTotnUVgW64p9olPElCPogW5TuBwfTKYDU7p
         ZiyHHlU8udBulKmevubkFCqUTbd7BY3/xv4he4yQVT+meyYw2s7/tTCr/NYmOE+xaXz1
         RJqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1aUhtdil3rL+gH32qN402lmfSrdySv3dNFkkHxnrFik=;
        b=dtt6BqGpSFswZDAT+wz24eAA1nyH1xpTTHY26a1zVzgQNVrF5Gpiz6hFzQzt3304Zm
         wzfH1qIqcRJyBZoYjaOLMKTH2YRHbCkUOhk0a1z69sNNU4TH0ABNIKgH9K4DbizFpOZ6
         Qgn1YIy1txlf72sf1K8wvqwXkHfLDsxIU9UZ+wohThwfBT9ofyXVIN50sZRK02+YyZSA
         uKXEusViXsr3qek9wfrlaILzuBctOzu3skIGdHKX8CHtq80b4MAchM0S1IX0z/FXaHOp
         Jlzqu/EwR1PTFIOva+DFJ3YMmMO3khugnpQMAlvXa9KY0EBmghiOH1B+Ku04jkDGLRxz
         NA1w==
X-Gm-Message-State: APjAAAVwThItNULXDETher/p7K1GDar5wwJE05kQIvgAn8ZEDPBjaWn0
        JI/m06Sb2SP2a9+ZT9hWuPYCdnkZ2v32Og==
X-Google-Smtp-Source: APXvYqwKraA9SwIUyjOhOEydhXrH5GGFozxYPKsVkEQwEAYCae8bODHZM19HZ1rZORQ/rlWHO3DpYw==
X-Received: by 2002:a63:e17:: with SMTP id d23mr62553778pgl.173.1577560882649;
        Sat, 28 Dec 2019 11:21:22 -0800 (PST)
Received: from x1.localdomain ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id z30sm47067902pfq.154.2019.12.28.11.21.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Dec 2019 11:21:22 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/9] io_uring: add lookup table for various opcode needs
Date:   Sat, 28 Dec 2019 12:21:11 -0700
Message-Id: <20191228192118.4005-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191228192118.4005-1-axboe@kernel.dk>
References: <20191228192118.4005-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We currently have various switch statements that check if an opcode needs
a file, mm, etc. These are hard to keep in sync as opcodes are added. Add
a struct io_op_def that holds all of this information, so we have just
one spot to update when opcodes are added.

This also enables us to NOT allocate req->io if a deferred command
doesn't need it, and corrects some mistakes we had in terms of what
commands need mm context.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 209 +++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 156 insertions(+), 53 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 40735ecc09c9..0ee6b3057895 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -516,6 +516,137 @@ struct io_submit_state {
 	unsigned int		ios_left;
 };
 
+struct io_op_def {
+	/* needs req->io allocated for deferral/async */
+	unsigned		async_ctx : 1;
+	/* needs current->mm setup, does mm access */
+	unsigned		needs_mm : 1;
+	/* needs req->file assigned */
+	unsigned		needs_file : 1;
+	/* needs req->file assigned IFF fd is >= 0 */
+	unsigned		fd_non_neg : 1;
+	/* hash wq insertion if file is a regular file */
+	unsigned		hash_reg_file : 1;
+	/* unbound wq insertion if file is a non-regular file */
+	unsigned		unbound_nonreg_file : 1;
+};
+
+static const struct io_op_def io_op_defs[IORING_OP_LAST] = {
+	{
+		/* IORING_OP_NOP */
+	},
+	{
+		/* IORING_OP_READV */
+		.async_ctx		= 1,
+		.needs_mm		= 1,
+		.needs_file		= 1,
+		.unbound_nonreg_file	= 1,
+	},
+	{
+		/* IORING_OP_WRITEV */
+		.async_ctx		= 1,
+		.needs_mm		= 1,
+		.needs_file		= 1,
+		.hash_reg_file		= 1,
+		.unbound_nonreg_file	= 1,
+	},
+	{
+		/* IORING_OP_FSYNC */
+		.needs_file		= 1,
+	},
+	{
+		/* IORING_OP_READ_FIXED */
+		.async_ctx		= 1,
+		.needs_file		= 1,
+		.unbound_nonreg_file	= 1,
+	},
+	{
+		/* IORING_OP_WRITE_FIXED */
+		.async_ctx		= 1,
+		.needs_file		= 1,
+		.hash_reg_file		= 1,
+		.unbound_nonreg_file	= 1,
+	},
+	{
+		/* IORING_OP_POLL_ADD */
+		.needs_file		= 1,
+		.unbound_nonreg_file	= 1,
+	},
+	{
+		/* IORING_OP_POLL_REMOVE */
+	},
+	{
+		/* IORING_OP_SYNC_FILE_RANGE */
+		.needs_file		= 1,
+	},
+	{
+		/* IORING_OP_SENDMSG */
+		.async_ctx		= 1,
+		.needs_mm		= 1,
+		.needs_file		= 1,
+		.unbound_nonreg_file	= 1,
+	},
+	{
+		/* IORING_OP_RECVMSG */
+		.async_ctx		= 1,
+		.needs_mm		= 1,
+		.needs_file		= 1,
+		.unbound_nonreg_file	= 1,
+	},
+	{
+		/* IORING_OP_TIMEOUT */
+		.async_ctx		= 1,
+		.needs_mm		= 1,
+	},
+	{
+		/* IORING_OP_TIMEOUT_REMOVE */
+	},
+	{
+		/* IORING_OP_ACCEPT */
+		.needs_mm		= 1,
+		.needs_file		= 1,
+		.unbound_nonreg_file	= 1,
+	},
+	{
+		/* IORING_OP_ASYNC_CANCEL */
+	},
+	{
+		/* IORING_OP_LINK_TIMEOUT */
+		.async_ctx		= 1,
+		.needs_mm		= 1,
+	},
+	{
+		/* IORING_OP_CONNECT */
+		.async_ctx		= 1,
+		.needs_mm		= 1,
+		.needs_file		= 1,
+		.unbound_nonreg_file	= 1,
+	},
+	{
+		/* IORING_OP_FALLOCATE */
+		.needs_file		= 1,
+	},
+	{
+		/* IORING_OP_OPENAT */
+		.needs_file		= 1,
+		.fd_non_neg		= 1,
+	},
+	{
+		/* IORING_OP_CLOSE */
+		.needs_file		= 1,
+	},
+	{
+		/* IORING_OP_FILES_UPDATE */
+		.needs_mm		= 1,
+	},
+	{
+		/* IORING_OP_STATX */
+		.needs_mm		= 1,
+		.needs_file		= 1,
+		.fd_non_neg		= 1,
+	},
+};
+
 static void io_wq_submit_work(struct io_wq_work **workptr);
 static void io_cqring_fill_event(struct io_kiocb *req, long res);
 static void io_put_req(struct io_kiocb *req);
@@ -671,41 +802,20 @@ static void __io_commit_cqring(struct io_ring_ctx *ctx)
 	}
 }
 
-static inline bool io_req_needs_user(struct io_kiocb *req)
-{
-	return !(req->opcode == IORING_OP_READ_FIXED ||
-		 req->opcode == IORING_OP_WRITE_FIXED);
-}
-
 static inline bool io_prep_async_work(struct io_kiocb *req,
 				      struct io_kiocb **link)
 {
+	const struct io_op_def *def = &io_op_defs[req->opcode];
 	bool do_hashed = false;
 
-	switch (req->opcode) {
-	case IORING_OP_WRITEV:
-	case IORING_OP_WRITE_FIXED:
-		/* only regular files should be hashed for writes */
-		if (req->flags & REQ_F_ISREG)
+	if (req->flags & REQ_F_ISREG) {
+		if (def->hash_reg_file)
 			do_hashed = true;
-		/* fall-through */
-	case IORING_OP_READV:
-	case IORING_OP_READ_FIXED:
-	case IORING_OP_SENDMSG:
-	case IORING_OP_RECVMSG:
-	case IORING_OP_ACCEPT:
-	case IORING_OP_POLL_ADD:
-	case IORING_OP_CONNECT:
-		/*
-		 * We know REQ_F_ISREG is not set on some of these
-		 * opcodes, but this enables us to keep the check in
-		 * just one place.
-		 */
-		if (!(req->flags & REQ_F_ISREG))
+	} else {
+		if (def->unbound_nonreg_file)
 			req->work.flags |= IO_WQ_WORK_UNBOUND;
-		break;
 	}
-	if (io_req_needs_user(req))
+	if (def->needs_mm)
 		req->work.flags |= IO_WQ_WORK_NEEDS_USER;
 
 	*link = io_prep_linked_timeout(req);
@@ -1826,6 +1936,8 @@ static void io_req_map_rw(struct io_kiocb *req, ssize_t io_size,
 
 static int io_alloc_async_ctx(struct io_kiocb *req)
 {
+	if (!io_op_defs[req->opcode].async_ctx)
+		return 0;
 	req->io = kmalloc(sizeof(*req->io), GFP_KERNEL);
 	return req->io == NULL;
 }
@@ -3773,29 +3885,13 @@ static void io_wq_submit_work(struct io_wq_work **workptr)
 	}
 }
 
-static bool io_req_op_valid(int op)
-{
-	return op >= IORING_OP_NOP && op < IORING_OP_LAST;
-}
-
 static int io_req_needs_file(struct io_kiocb *req, int fd)
 {
-	switch (req->opcode) {
-	case IORING_OP_NOP:
-	case IORING_OP_POLL_REMOVE:
-	case IORING_OP_TIMEOUT:
-	case IORING_OP_TIMEOUT_REMOVE:
-	case IORING_OP_ASYNC_CANCEL:
-	case IORING_OP_LINK_TIMEOUT:
+	if (!io_op_defs[req->opcode].needs_file)
 		return 0;
-	case IORING_OP_OPENAT:
-	case IORING_OP_STATX:
-		return fd != -1;
-	default:
-		if (io_req_op_valid(req->opcode))
-			return 1;
-		return -EINVAL;
-	}
+	if (fd == -1 && io_op_defs[req->opcode].fd_non_neg)
+		return 0;
+	return 1;
 }
 
 static inline struct file *io_file_from_index(struct io_ring_ctx *ctx,
@@ -3812,7 +3908,7 @@ static int io_req_set_file(struct io_submit_state *state, struct io_kiocb *req,
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	unsigned flags;
-	int fd, ret;
+	int fd;
 
 	flags = READ_ONCE(sqe->flags);
 	fd = READ_ONCE(sqe->fd);
@@ -3820,9 +3916,8 @@ static int io_req_set_file(struct io_submit_state *state, struct io_kiocb *req,
 	if (flags & IOSQE_IO_DRAIN)
 		req->flags |= REQ_F_IO_DRAIN;
 
-	ret = io_req_needs_file(req, fd);
-	if (ret <= 0)
-		return ret;
+	if (!io_req_needs_file(req, fd))
+		return 0;
 
 	if (flags & IOSQE_FIXED_FILE) {
 		if (unlikely(!ctx->file_data ||
@@ -4248,7 +4343,16 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 			break;
 		}
 
-		if (io_req_needs_user(req) && !*mm) {
+		/* will complete beyond this point, count as submitted */
+		submitted++;
+
+		if (unlikely(req->opcode >= IORING_OP_LAST)) {
+			io_cqring_add_event(req, -EINVAL);
+			io_double_put_req(req);
+			break;
+		}
+
+		if (io_op_defs[req->opcode].needs_mm && !*mm) {
 			mm_fault = mm_fault || !mmget_not_zero(ctx->sqo_mm);
 			if (!mm_fault) {
 				use_mm(ctx->sqo_mm);
@@ -4256,7 +4360,6 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 			}
 		}
 
-		submitted++;
 		req->ring_file = ring_file;
 		req->ring_fd = ring_fd;
 		req->has_user = *mm != NULL;
-- 
2.24.1

