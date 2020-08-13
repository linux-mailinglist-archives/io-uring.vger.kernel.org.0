Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DA21243E96
	for <lists+io-uring@lfdr.de>; Thu, 13 Aug 2020 19:58:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726531AbgHMR6M (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 13 Aug 2020 13:58:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726174AbgHMR6M (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 13 Aug 2020 13:58:12 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99CB8C061757
        for <io-uring@vger.kernel.org>; Thu, 13 Aug 2020 10:58:12 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id a5so8132351ioa.13
        for <io-uring@vger.kernel.org>; Thu, 13 Aug 2020 10:58:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DCgEId5bQBB1OEiz1b0zTfza42vYywKOpNRKkOQNroU=;
        b=ZK3Eoc7cFYIXtxhLbAHk+tUcv/KMvMcU78kCtA1mtL67gMivSfysr7msaMaS8RYX1G
         V2OmEynIJmZwAaoBl3IrcVocEghCFSP6Pd1zu885NrUytV1Ma1gtVCp1s/1y+5dqH7nR
         8/dA5W0WmzWMaG/jGQyT9gFY9KkmXx1VMZl+3MHEvw9dWkn68rLNlaMCsohWaaCD3HOt
         vUF5jD9Vh8pu/C3aoSLVNWdybUJsBvIa7SATLFNkpmeU47e5bh0JvlnyvNN/XC1fkaLR
         TgsSM1OTHWFYQAJNtOz8JAEppCTRBamaURzfNNUYxQ6kE5+7MqYlqncDx65WPkHu0joS
         mf3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DCgEId5bQBB1OEiz1b0zTfza42vYywKOpNRKkOQNroU=;
        b=By2b+llVYyIgOdldjQ1Eaw9W6Y2CLoYAMy7rHJBcwWRt0SeQTJNz6dTPWcNFcj5Zzx
         ww3BrM153Tbo9FD3l4SRWhUoY0S1Rpt9VcVNO3oV73PZAetTA2PnvRAo6aGiYsvVqM40
         X8x4zZx/QK19Gatv8y156UH04ico37leeWTtYkTnDnU+qv/+tionwjD1rnMJiD+P08fK
         MNSi71O7bdmBGqhUHQ1jSIjS+6wAN8TYFvjkAdWL52SXuGrsH1o8QPepAVIXHBG0xJmQ
         gbdnb6kCJRlByfdOKNQ5nz168PMUeXvHp1/RMVKxFuoDQ3wzFpGBMyjCd0688pnqB9/q
         w4og==
X-Gm-Message-State: AOAM531YkiMjanrzieunfkL3OpVwzPKkuvjpTdn5t4XI1KV/PM+A1F14
        tHxlOi/S4KB9fjuhp3yXR+zoQxuLZlA=
X-Google-Smtp-Source: ABdhPJz6lgdp2okpy8aIy6HQSKRlTzjuqxcAeE5+LqQ4EJYGuRXjLUcwv1KQMMxf4c2XnPDJRN2vgg==
X-Received: by 2002:a02:9149:: with SMTP id b9mr6264426jag.50.1597341491254;
        Thu, 13 Aug 2020 10:58:11 -0700 (PDT)
Received: from localhost.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id y9sm3029562ila.65.2020.08.13.10.58.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2020 10:58:10 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     david@fromorbit.com, jmoyer@redhat.com,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/2] io_uring: internally retry short reads
Date:   Thu, 13 Aug 2020 11:56:05 -0600
Message-Id: <20200813175605.993571-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200813175605.993571-1-axboe@kernel.dk>
References: <20200813175605.993571-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We've had a few application cases of not handling short reads properly,
and it is understandable as short reads aren't really expected if the
application isn't doing non-blocking IO.

Now that we retain the iov_iter over retries, we can implement internal
retry pretty trivially. This ensures that we don't return a short read,
even for buffered reads on page cache conflicts.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 72 ++++++++++++++++++++++++++++++++-------------------
 1 file changed, 45 insertions(+), 27 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index a20fccf91d76..c6a9f1b11e85 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -509,6 +509,7 @@ struct io_async_msghdr {
 struct io_async_rw {
 	struct iovec			fast_iov[UIO_FASTIOV];
 	struct iov_iter			iter;
+	size_t				bytes_done;
 	struct wait_page_queue		wpq;
 };
 
@@ -914,7 +915,8 @@ static ssize_t io_import_iovec(int rw, struct io_kiocb *req,
 			       struct iovec **iovec, struct iov_iter *iter,
 			       bool needs_lock);
 static int io_setup_async_rw(struct io_kiocb *req, struct iovec *iovec,
-			     struct iovec *fast_iov, struct iov_iter *iter);
+			     struct iovec *fast_iov, struct iov_iter *iter,
+			     bool force);
 
 static struct kmem_cache *req_cachep;
 
@@ -2296,7 +2298,7 @@ static bool io_resubmit_prep(struct io_kiocb *req, int error)
 	ret = io_import_iovec(rw, req, &iovec, &iter, false);
 	if (ret < 0)
 		goto end_req;
-	ret = io_setup_async_rw(req, iovec, inline_vecs, &iter);
+	ret = io_setup_async_rw(req, iovec, inline_vecs, &iter, false);
 	if (!ret)
 		return true;
 	kfree(iovec);
@@ -2586,6 +2588,14 @@ static void kiocb_done(struct kiocb *kiocb, ssize_t ret,
 {
 	struct io_kiocb *req = container_of(kiocb, struct io_kiocb, rw.kiocb);
 
+	/* add previously done IO, if any */
+	if (req->io && req->io->rw.bytes_done > 0) {
+		if (ret < 0)
+			ret = req->io->rw.bytes_done;
+		else
+			ret += req->io->rw.bytes_done;
+	}
+
 	if (req->flags & REQ_F_CUR_POS)
 		req->file->f_pos = kiocb->ki_pos;
 	if (ret >= 0 && kiocb->ki_complete == io_complete_rw)
@@ -2932,6 +2942,7 @@ static void io_req_map_rw(struct io_kiocb *req, const struct iovec *iovec,
 	struct io_async_rw *rw = &req->io->rw;
 
 	memcpy(&rw->iter, iter, sizeof(*iter));
+	rw->bytes_done = 0;
 	if (!iovec) {
 		rw->iter.iov = rw->fast_iov;
 		if (rw->iter.iov != fast_iov)
@@ -2958,9 +2969,10 @@ static int io_alloc_async_ctx(struct io_kiocb *req)
 }
 
 static int io_setup_async_rw(struct io_kiocb *req, struct iovec *iovec,
-			     struct iovec *fast_iov, struct iov_iter *iter)
+			     struct iovec *fast_iov, struct iov_iter *iter,
+			     bool force)
 {
-	if (!io_op_defs[req->opcode].async_ctx)
+	if (!force && !io_op_defs[req->opcode].async_ctx)
 		return 0;
 	if (!req->io) {
 		if (__io_alloc_async_ctx(req))
@@ -3084,8 +3096,7 @@ static inline int kiocb_wait_page_queue_init(struct kiocb *kiocb,
  * succeed, or in rare cases where it fails, we then fall back to using the
  * async worker threads for a blocking retry.
  */
-static bool io_rw_should_retry(struct io_kiocb *req, struct iovec *iovec,
-			       struct iovec *fast_iov, struct iov_iter *iter)
+static bool io_rw_should_retry(struct io_kiocb *req)
 {
 	struct kiocb *kiocb = &req->rw.kiocb;
 	int ret;
@@ -3094,8 +3105,8 @@ static bool io_rw_should_retry(struct io_kiocb *req, struct iovec *iovec,
 	if (req->flags & REQ_F_NOWAIT)
 		return false;
 
-	/* already tried, or we're doing O_DIRECT */
-	if (kiocb->ki_flags & (IOCB_DIRECT | IOCB_WAITQ))
+	/* Only for buffered IO */
+	if (kiocb->ki_flags & IOCB_DIRECT)
 		return false;
 	/*
 	 * just use poll if we can, and don't attempt if the fs doesn't
@@ -3104,16 +3115,6 @@ static bool io_rw_should_retry(struct io_kiocb *req, struct iovec *iovec,
 	if (file_can_poll(req->file) || !(req->file->f_mode & FMODE_BUF_RASYNC))
 		return false;
 
-	/*
-	 * If request type doesn't require req->io to defer in general,
-	 * we need to allocate it here
-	 */
-	if (!req->io) {
-		if (__io_alloc_async_ctx(req))
-			return false;
-		io_req_map_rw(req, iovec, fast_iov, iter);
-	}
-
 	ret = kiocb_wait_page_queue_init(kiocb, &req->io->rw.wpq,
 						io_async_buf_func, req);
 	if (!ret) {
@@ -3167,29 +3168,46 @@ static int io_read(struct io_kiocb *req, bool force_nonblock,
 
 	ret2 = io_iter_do_read(req, iter);
 
-	/* Catch -EAGAIN return for forced non-blocking submission */
-	if (!force_nonblock || (ret2 != -EAGAIN && ret2 != -EIO)) {
-		kiocb_done(kiocb, ret2, cs);
-	} else {
+	if (!iov_iter_count(iter))
+		goto done;
+
+	if (ret2 >= 0) {
+		/* successful read, but partial */
+		if (req->flags & REQ_F_NOWAIT)
+			goto done;
+		io_size -= ret2;
 copy_iov:
-		ret = io_setup_async_rw(req, iovec, inline_vecs, iter);
+		ret = io_setup_async_rw(req, iovec, inline_vecs, iter, true);
 		if (ret)
 			goto out_free;
 		/* it's copied and will be cleaned with ->io */
 		iovec = NULL;
+		/* now use our persistent iterator, if we aren't already */
+		iter = &req->io->rw.iter;
+
+		if (ret2 > 0) {
+retry:
+			req->io->rw.bytes_done += ret2;
+		}
 		/* if we can retry, do so with the callbacks armed */
-		if (io_rw_should_retry(req, iovec, inline_vecs, iter)) {
+		if (io_rw_should_retry(req)) {
 			ret2 = io_iter_do_read(req, iter);
 			if (ret2 == -EIOCBQUEUED) {
 				goto out_free;
+			} else if (ret2 == io_size) {
+				goto done;
 			} else if (ret2 != -EAGAIN) {
-				kiocb_done(kiocb, ret2, cs);
-				goto out_free;
+				/* we got some bytes, but not all. retry. */
+				if (ret2 > 0)
+					goto retry;
+				goto done;
 			}
 		}
 		kiocb->ki_flags &= ~IOCB_WAITQ;
 		return -EAGAIN;
 	}
+done:
+	kiocb_done(kiocb, ret2, cs);
 out_free:
 	if (iovec)
 		kfree(iovec);
@@ -3282,7 +3300,7 @@ static int io_write(struct io_kiocb *req, bool force_nonblock,
 		kiocb_done(kiocb, ret2, cs);
 	} else {
 copy_iov:
-		ret = io_setup_async_rw(req, iovec, inline_vecs, iter);
+		ret = io_setup_async_rw(req, iovec, inline_vecs, iter, false);
 		if (ret)
 			goto out_free;
 		/* it's copied and will be cleaned with ->io */
-- 
2.28.0

