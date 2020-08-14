Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E386244F06
	for <lists+io-uring@lfdr.de>; Fri, 14 Aug 2020 21:58:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727104AbgHNT6z (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 14 Aug 2020 15:58:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726297AbgHNT6y (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 14 Aug 2020 15:58:54 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A694AC061386
        for <io-uring@vger.kernel.org>; Fri, 14 Aug 2020 12:58:54 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id m34so5020396pgl.11
        for <io-uring@vger.kernel.org>; Fri, 14 Aug 2020 12:58:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZkMiOp9yfGz1HJGYzSYBcpkfS2qbYwV7wsZ7RJbHgLE=;
        b=P27nWp3OkK15N65UHm30oDPveWzy0KX5gVDXQ4EVoTWoo4XOGR45X24clUyWzBrQ4P
         nJUToFuuFvipy1wLAn6hctEA/fFNs1O7HrC/H5RX9sh/u2zGdU2xlTkl+/tO6CCMgu86
         SSx8JgNVvIpKQpgWLhOQa4gRXgGmetZSPP5lGKEbz4ADLJmVUiS1Ch+DVATikucuAORo
         7qd5glxQQfq2jZ62nKVvN9C7zGNQ6Eu8G56HSMiC1ZjGu3XqrL5MMkmf1tYf1r8wnAOM
         JH/irNL6LjgsAKYjR7LlXssd0dzQcyA3YdIkgJ0n4y6BDgibCEfqJg1TDAXhE+FmLtZH
         JCrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZkMiOp9yfGz1HJGYzSYBcpkfS2qbYwV7wsZ7RJbHgLE=;
        b=SgW5Y7GV+JwAxTxHWYFqqo3p02/8aZgHEuJFVWQEqFkHAFGx15hIhfOKnsG+bS/MRd
         5iBZTaeWUYKB4yNIfDFEHC6uu3X2G0cVazXv3v0fAfQwSSQtoMpsKNVuP6gqJc/L8miF
         uXwgDfzPGh/3Q8rcBBodhcnFUN7SLCjZUH0P1d9HQdadihCSBgGQwiClq9w1cMGLtDoY
         YEzhIn4K6Go7G6Zs9RheApQVqpPPKQYN5W4y5NMYT4lnlmpXwQQpnie9Ehaa33ZtU9Ht
         FHH1zZulePx+YZQybw5zwk0aE/ThDaG0f+FZmLBBdHpoUIQDRc3zimVN8T0uPzAre8Nr
         nghg==
X-Gm-Message-State: AOAM530aUkwDIECBimR57UlhHkGB3OIGbHZyPmHhDB//1iUFGfqo4fU0
        TM991GHeDig1l3+Rd5NW+4qIw9LYjjNftg==
X-Google-Smtp-Source: ABdhPJzluxaVnX6UUy0K+Aq7TIwtNo2HOFwgNAibPnPQDAI6QcwTPn8WAzOeGqY6tidu5z5mV8EvAw==
X-Received: by 2002:a63:df56:: with SMTP id h22mr2751087pgj.140.1597435133777;
        Fri, 14 Aug 2020 12:58:53 -0700 (PDT)
Received: from localhost.localdomain ([2605:e000:100e:8c61:58f:6be6:29b5:60da])
        by smtp.gmail.com with ESMTPSA id t11sm9695219pfe.165.2020.08.14.12.58.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2020 12:58:53 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     david@fromorbit.com, jmoyer@redhat.com,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/2] io_uring: retain iov_iter state over io_read/io_write calls
Date:   Fri, 14 Aug 2020 12:54:48 -0700
Message-Id: <20200814195449.533153-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200814195449.533153-1-axboe@kernel.dk>
References: <20200814195449.533153-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Instead of maintaining (and setting/remembering) iov_iter size and
segment counts, just put the iov_iter in the async part of the IO
structure.

This is mostly a preparation patch for doing appropriate internal retries
for short reads, but it also cleans up the state handling nicely and
simplifies it quite a bit.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 114 ++++++++++++++++++++++++--------------------------
 1 file changed, 54 insertions(+), 60 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 1ec25ee71372..409cfa1d6d90 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -508,9 +508,7 @@ struct io_async_msghdr {
 
 struct io_async_rw {
 	struct iovec			fast_iov[UIO_FASTIOV];
-	struct iovec			*iov;
-	ssize_t				nr_segs;
-	ssize_t				size;
+	struct iov_iter			iter;
 	struct wait_page_queue		wpq;
 };
 
@@ -915,8 +913,7 @@ static void io_file_put_work(struct work_struct *work);
 static ssize_t io_import_iovec(int rw, struct io_kiocb *req,
 			       struct iovec **iovec, struct iov_iter *iter,
 			       bool needs_lock);
-static int io_setup_async_rw(struct io_kiocb *req, ssize_t io_size,
-			     struct iovec *iovec, struct iovec *fast_iov,
+static int io_setup_async_rw(struct io_kiocb *req, struct iovec *iovec,
 			     struct iov_iter *iter);
 
 static struct kmem_cache *req_cachep;
@@ -2299,7 +2296,7 @@ static bool io_resubmit_prep(struct io_kiocb *req, int error)
 	ret = io_import_iovec(rw, req, &iovec, &iter, false);
 	if (ret < 0)
 		goto end_req;
-	ret = io_setup_async_rw(req, ret, iovec, inline_vecs, &iter);
+	ret = io_setup_async_rw(req, iovec, &iter);
 	if (!ret)
 		return true;
 	kfree(iovec);
@@ -2820,6 +2817,13 @@ static ssize_t io_import_iovec(int rw, struct io_kiocb *req,
 	ssize_t ret;
 	u8 opcode;
 
+	if (req->io) {
+		struct io_async_rw *iorw = &req->io->rw;
+
+		*iovec = NULL;
+		return iov_iter_count(&iorw->iter);
+	}
+
 	opcode = req->opcode;
 	if (opcode == IORING_OP_READ_FIXED || opcode == IORING_OP_WRITE_FIXED) {
 		*iovec = NULL;
@@ -2845,14 +2849,6 @@ static ssize_t io_import_iovec(int rw, struct io_kiocb *req,
 		return ret < 0 ? ret : sqe_len;
 	}
 
-	if (req->io) {
-		struct io_async_rw *iorw = &req->io->rw;
-
-		iov_iter_init(iter, rw, iorw->iov, iorw->nr_segs, iorw->size);
-		*iovec = NULL;
-		return iorw->size;
-	}
-
 	if (req->flags & REQ_F_BUFFER_SELECT) {
 		ret = io_iov_buffer_select(req, *iovec, needs_lock);
 		if (!ret) {
@@ -2930,21 +2926,19 @@ static ssize_t loop_rw_iter(int rw, struct file *file, struct kiocb *kiocb,
 	return ret;
 }
 
-static void io_req_map_rw(struct io_kiocb *req, ssize_t io_size,
-			  struct iovec *iovec, struct iovec *fast_iov,
+static void io_req_map_rw(struct io_kiocb *req, const struct iovec *iovec,
 			  struct iov_iter *iter)
 {
 	struct io_async_rw *rw = &req->io->rw;
 
-	rw->nr_segs = iter->nr_segs;
-	rw->size = io_size;
+	memcpy(&rw->iter, iter, sizeof(*iter));
 	if (!iovec) {
-		rw->iov = rw->fast_iov;
-		if (rw->iov != fast_iov)
-			memcpy(rw->iov, fast_iov,
+		rw->iter.iov = rw->fast_iov;
+		if (rw->fast_iov != iter->iov)
+			memcpy(rw->fast_iov, iter->iov,
 			       sizeof(struct iovec) * iter->nr_segs);
 	} else {
-		rw->iov = iovec;
+		rw->iter.iov = iovec;
 		req->flags |= REQ_F_NEED_CLEANUP;
 	}
 }
@@ -2963,8 +2957,7 @@ static int io_alloc_async_ctx(struct io_kiocb *req)
 	return  __io_alloc_async_ctx(req);
 }
 
-static int io_setup_async_rw(struct io_kiocb *req, ssize_t io_size,
-			     struct iovec *iovec, struct iovec *fast_iov,
+static int io_setup_async_rw(struct io_kiocb *req, struct iovec *iovec,
 			     struct iov_iter *iter)
 {
 	if (!io_op_defs[req->opcode].async_ctx)
@@ -2973,7 +2966,7 @@ static int io_setup_async_rw(struct io_kiocb *req, ssize_t io_size,
 		if (__io_alloc_async_ctx(req))
 			return -ENOMEM;
 
-		io_req_map_rw(req, io_size, iovec, fast_iov, iter);
+		io_req_map_rw(req, iovec, iter);
 	}
 	return 0;
 }
@@ -2981,18 +2974,19 @@ static int io_setup_async_rw(struct io_kiocb *req, ssize_t io_size,
 static inline int io_rw_prep_async(struct io_kiocb *req, int rw,
 				   bool force_nonblock)
 {
-	struct io_async_ctx *io = req->io;
-	struct iov_iter iter;
+	struct io_async_rw *iorw = &req->io->rw;
 	ssize_t ret;
 
-	io->rw.iov = io->rw.fast_iov;
+	iorw->iter.iov = iorw->fast_iov;
+	/* reset ->io around the iovec import, we don't want to use it */
 	req->io = NULL;
-	ret = io_import_iovec(rw, req, &io->rw.iov, &iter, !force_nonblock);
-	req->io = io;
+	ret = io_import_iovec(rw, req, (struct iovec **) &iorw->iter.iov,
+				&iorw->iter, !force_nonblock);
+	req->io = container_of(iorw, struct io_async_ctx, rw);
 	if (unlikely(ret < 0))
 		return ret;
 
-	io_req_map_rw(req, ret, io->rw.iov, io->rw.fast_iov, &iter);
+	io_req_map_rw(req, iorw->iter.iov, &iorw->iter);
 	return 0;
 }
 
@@ -3090,7 +3084,8 @@ static inline int kiocb_wait_page_queue_init(struct kiocb *kiocb,
  * succeed, or in rare cases where it fails, we then fall back to using the
  * async worker threads for a blocking retry.
  */
-static bool io_rw_should_retry(struct io_kiocb *req)
+static bool io_rw_should_retry(struct io_kiocb *req, struct iovec *iovec,
+			       struct iovec *fast_iov, struct iov_iter *iter)
 {
 	struct kiocb *kiocb = &req->rw.kiocb;
 	int ret;
@@ -3113,8 +3108,11 @@ static bool io_rw_should_retry(struct io_kiocb *req)
 	 * If request type doesn't require req->io to defer in general,
 	 * we need to allocate it here
 	 */
-	if (!req->io && __io_alloc_async_ctx(req))
-		return false;
+	if (!req->io) {
+		if (__io_alloc_async_ctx(req))
+			return false;
+		io_req_map_rw(req, iovec, iter);
+	}
 
 	ret = kiocb_wait_page_queue_init(kiocb, &req->io->rw.wpq,
 						io_async_buf_func, req);
@@ -3141,12 +3139,14 @@ static int io_read(struct io_kiocb *req, bool force_nonblock,
 {
 	struct iovec inline_vecs[UIO_FASTIOV], *iovec = inline_vecs;
 	struct kiocb *kiocb = &req->rw.kiocb;
-	struct iov_iter iter;
+	struct iov_iter __iter, *iter = &__iter;
 	size_t iov_count;
-	ssize_t io_size, ret, ret2;
-	unsigned long nr_segs;
+	ssize_t io_size, ret, ret2 = 0;
+
+	if (req->io)
+		iter = &req->io->rw.iter;
 
-	ret = io_import_iovec(READ, req, &iovec, &iter, !force_nonblock);
+	ret = io_import_iovec(READ, req, &iovec, iter, !force_nonblock);
 	if (ret < 0)
 		return ret;
 	io_size = ret;
@@ -3160,30 +3160,26 @@ static int io_read(struct io_kiocb *req, bool force_nonblock,
 	if (force_nonblock && !io_file_supports_async(req->file, READ))
 		goto copy_iov;
 
-	iov_count = iov_iter_count(&iter);
-	nr_segs = iter.nr_segs;
+	iov_count = iov_iter_count(iter);
 	ret = rw_verify_area(READ, req->file, &kiocb->ki_pos, iov_count);
 	if (unlikely(ret))
 		goto out_free;
 
-	ret2 = io_iter_do_read(req, &iter);
+	ret2 = io_iter_do_read(req, iter);
 
 	/* Catch -EAGAIN return for forced non-blocking submission */
 	if (!force_nonblock || (ret2 != -EAGAIN && ret2 != -EIO)) {
 		kiocb_done(kiocb, ret2, cs);
 	} else {
-		iter.count = iov_count;
-		iter.nr_segs = nr_segs;
 copy_iov:
-		ret = io_setup_async_rw(req, io_size, iovec, inline_vecs,
-					&iter);
+		ret = io_setup_async_rw(req, iovec, iter);
 		if (ret)
 			goto out_free;
 		/* it's copied and will be cleaned with ->io */
 		iovec = NULL;
 		/* if we can retry, do so with the callbacks armed */
-		if (io_rw_should_retry(req)) {
-			ret2 = io_iter_do_read(req, &iter);
+		if (io_rw_should_retry(req, iovec, inline_vecs, iter)) {
+			ret2 = io_iter_do_read(req, iter);
 			if (ret2 == -EIOCBQUEUED) {
 				goto out_free;
 			} else if (ret2 != -EAGAIN) {
@@ -3223,12 +3219,14 @@ static int io_write(struct io_kiocb *req, bool force_nonblock,
 {
 	struct iovec inline_vecs[UIO_FASTIOV], *iovec = inline_vecs;
 	struct kiocb *kiocb = &req->rw.kiocb;
-	struct iov_iter iter;
+	struct iov_iter __iter, *iter = &__iter;
 	size_t iov_count;
 	ssize_t ret, ret2, io_size;
-	unsigned long nr_segs;
 
-	ret = io_import_iovec(WRITE, req, &iovec, &iter, !force_nonblock);
+	if (req->io)
+		iter = &req->io->rw.iter;
+
+	ret = io_import_iovec(WRITE, req, &iovec, iter, !force_nonblock);
 	if (ret < 0)
 		return ret;
 	io_size = ret;
@@ -3247,8 +3245,7 @@ static int io_write(struct io_kiocb *req, bool force_nonblock,
 	    (req->flags & REQ_F_ISREG))
 		goto copy_iov;
 
-	iov_count = iov_iter_count(&iter);
-	nr_segs = iter.nr_segs;
+	iov_count = iov_iter_count(iter);
 	ret = rw_verify_area(WRITE, req->file, &kiocb->ki_pos, iov_count);
 	if (unlikely(ret))
 		goto out_free;
@@ -3269,9 +3266,9 @@ static int io_write(struct io_kiocb *req, bool force_nonblock,
 	kiocb->ki_flags |= IOCB_WRITE;
 
 	if (req->file->f_op->write_iter)
-		ret2 = call_write_iter(req->file, kiocb, &iter);
+		ret2 = call_write_iter(req->file, kiocb, iter);
 	else if (req->file->f_op->write)
-		ret2 = loop_rw_iter(WRITE, req->file, kiocb, &iter);
+		ret2 = loop_rw_iter(WRITE, req->file, kiocb, iter);
 	else
 		ret2 = -EINVAL;
 
@@ -3284,11 +3281,8 @@ static int io_write(struct io_kiocb *req, bool force_nonblock,
 	if (!force_nonblock || ret2 != -EAGAIN) {
 		kiocb_done(kiocb, ret2, cs);
 	} else {
-		iter.count = iov_count;
-		iter.nr_segs = nr_segs;
 copy_iov:
-		ret = io_setup_async_rw(req, io_size, iovec, inline_vecs,
-					&iter);
+		ret = io_setup_async_rw(req, iovec, iter);
 		if (ret)
 			goto out_free;
 		/* it's copied and will be cleaned with ->io */
@@ -5583,8 +5577,8 @@ static void __io_clean_op(struct io_kiocb *req)
 		case IORING_OP_WRITEV:
 		case IORING_OP_WRITE_FIXED:
 		case IORING_OP_WRITE:
-			if (io->rw.iov != io->rw.fast_iov)
-				kfree(io->rw.iov);
+			if (io->rw.iter.iov != io->rw.fast_iov)
+				kfree(io->rw.iter.iov);
 			break;
 		case IORING_OP_RECVMSG:
 		case IORING_OP_SENDMSG:
-- 
2.28.0

