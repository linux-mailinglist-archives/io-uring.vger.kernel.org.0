Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34799244F07
	for <lists+io-uring@lfdr.de>; Fri, 14 Aug 2020 21:58:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727998AbgHNT64 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 14 Aug 2020 15:58:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726636AbgHNT64 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 14 Aug 2020 15:58:56 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66767C061385
        for <io-uring@vger.kernel.org>; Fri, 14 Aug 2020 12:58:56 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id j21so5021730pgi.9
        for <io-uring@vger.kernel.org>; Fri, 14 Aug 2020 12:58:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AmWJYM1dJMlBGY8P6i/nthTIY+HSYzCY5b0ANWOSKM0=;
        b=x6CNQqTJFkJHPGW8mC6s1UaamSSfAjoh8o54FzHQfw5W7O4xzGAed1aiR6xG4SOx3R
         8ONVXDC3pul7PHLrFV59ivTgZn6gg4v9zj5WVVy+7wY5t77OFto61ePMSxXvTgWCHmwm
         x5ZIeXostnTdKYwRf0gSR5j3zDi5trpwA394n0B5ZRqVjTeHJpoC6eeQNxjWo3qS/yHM
         jxfP+LYgkQIagZbc8x34Y+UJS0Oo8iFiUwAQEsbFqyL+dbjFcxlkwOWf4CksUt9FnP+C
         PaJNXbkOgivkQB5EsNEeArGEyRS3GoVqVT4iiJEsBxFVLO4BUMJqTyoYLfzRXUGFdQ6c
         oSkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AmWJYM1dJMlBGY8P6i/nthTIY+HSYzCY5b0ANWOSKM0=;
        b=XHJBMCiZGO46sinRp4DvfIVJhDw0Y2X+Tymb05ozyPSMveTXnHC22FWkCPL5Ss43cA
         eNS5iN8WESONTSsaP4UPmH+C+90etnn5En2mNCQJUrohxLZHkwobst2pkPoheHv/qRFP
         IbApIZidYwsn6c1XS2zAd2il4il/SGAWLUpR+8dw6IORFq3Grw6JauDAdbhlIO+eARNB
         sqT2429R5AyjV4VlygiMS4sfLdcTcu/e0QSakWUbT7kHq6apFvEY+weyVZZtzjZh11Xi
         K/GyW38dzmGqjShaTXHuSoLHEFkVnr9on8ZHLAwUkWlXoAAcnYajQFJe47Rh05conj5z
         HIlw==
X-Gm-Message-State: AOAM533RBTEHI0Q0Jiy9pYfloWdTocMefkng4gE/OAD/KqO0pVx9waA2
        /JRlgiIl7MDoUMOGw3Izy+spGCzAn8G33w==
X-Google-Smtp-Source: ABdhPJxompti+TT+dBX7uD7ziQAs9pKXlRdWg0J8mtvQYZQeq8NncZq7Hlq2OazNRTGN6RwCREirPw==
X-Received: by 2002:a63:ab43:: with SMTP id k3mr1420030pgp.426.1597435135180;
        Fri, 14 Aug 2020 12:58:55 -0700 (PDT)
Received: from localhost.localdomain ([2605:e000:100e:8c61:58f:6be6:29b5:60da])
        by smtp.gmail.com with ESMTPSA id t11sm9695219pfe.165.2020.08.14.12.58.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2020 12:58:54 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     david@fromorbit.com, jmoyer@redhat.com,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/2] io_uring: internally retry short reads
Date:   Fri, 14 Aug 2020 12:54:49 -0700
Message-Id: <20200814195449.533153-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200814195449.533153-1-axboe@kernel.dk>
References: <20200814195449.533153-1-axboe@kernel.dk>
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

Cleanup the deep nesting and hard to read nature of io_read() as well,
it's much more straight forward now to read and understand. Added a
few comments explaining the logic as well.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 111 ++++++++++++++++++++++++++++++++------------------
 1 file changed, 71 insertions(+), 40 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 409cfa1d6d90..e1aacc0b9bd0 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -509,6 +509,7 @@ struct io_async_msghdr {
 struct io_async_rw {
 	struct iovec			fast_iov[UIO_FASTIOV];
 	struct iov_iter			iter;
+	size_t				bytes_done;
 	struct wait_page_queue		wpq;
 };
 
@@ -914,7 +915,7 @@ static ssize_t io_import_iovec(int rw, struct io_kiocb *req,
 			       struct iovec **iovec, struct iov_iter *iter,
 			       bool needs_lock);
 static int io_setup_async_rw(struct io_kiocb *req, struct iovec *iovec,
-			     struct iov_iter *iter);
+			     struct iov_iter *iter, bool force);
 
 static struct kmem_cache *req_cachep;
 
@@ -2296,7 +2297,7 @@ static bool io_resubmit_prep(struct io_kiocb *req, int error)
 	ret = io_import_iovec(rw, req, &iovec, &iter, false);
 	if (ret < 0)
 		goto end_req;
-	ret = io_setup_async_rw(req, iovec, &iter);
+	ret = io_setup_async_rw(req, iovec, &iter, false);
 	if (!ret)
 		return true;
 	kfree(iovec);
@@ -2586,6 +2587,14 @@ static void kiocb_done(struct kiocb *kiocb, ssize_t ret,
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
@@ -2932,6 +2941,7 @@ static void io_req_map_rw(struct io_kiocb *req, const struct iovec *iovec,
 	struct io_async_rw *rw = &req->io->rw;
 
 	memcpy(&rw->iter, iter, sizeof(*iter));
+	rw->bytes_done = 0;
 	if (!iovec) {
 		rw->iter.iov = rw->fast_iov;
 		if (rw->fast_iov != iter->iov)
@@ -2958,9 +2968,9 @@ static int io_alloc_async_ctx(struct io_kiocb *req)
 }
 
 static int io_setup_async_rw(struct io_kiocb *req, struct iovec *iovec,
-			     struct iov_iter *iter)
+			     struct iov_iter *iter, bool force)
 {
-	if (!io_op_defs[req->opcode].async_ctx)
+	if (!force && !io_op_defs[req->opcode].async_ctx)
 		return 0;
 	if (!req->io) {
 		if (__io_alloc_async_ctx(req))
@@ -3084,8 +3094,7 @@ static inline int kiocb_wait_page_queue_init(struct kiocb *kiocb,
  * succeed, or in rare cases where it fails, we then fall back to using the
  * async worker threads for a blocking retry.
  */
-static bool io_rw_should_retry(struct io_kiocb *req, struct iovec *iovec,
-			       struct iovec *fast_iov, struct iov_iter *iter)
+static bool io_rw_should_retry(struct io_kiocb *req)
 {
 	struct kiocb *kiocb = &req->rw.kiocb;
 	int ret;
@@ -3094,8 +3103,8 @@ static bool io_rw_should_retry(struct io_kiocb *req, struct iovec *iovec,
 	if (req->flags & REQ_F_NOWAIT)
 		return false;
 
-	/* already tried, or we're doing O_DIRECT */
-	if (kiocb->ki_flags & (IOCB_DIRECT | IOCB_WAITQ))
+	/* Only for buffered IO */
+	if (kiocb->ki_flags & IOCB_DIRECT)
 		return false;
 	/*
 	 * just use poll if we can, and don't attempt if the fs doesn't
@@ -3104,16 +3113,6 @@ static bool io_rw_should_retry(struct io_kiocb *req, struct iovec *iovec,
 	if (file_can_poll(req->file) || !(req->file->f_mode & FMODE_BUF_RASYNC))
 		return false;
 
-	/*
-	 * If request type doesn't require req->io to defer in general,
-	 * we need to allocate it here
-	 */
-	if (!req->io) {
-		if (__io_alloc_async_ctx(req))
-			return false;
-		io_req_map_rw(req, iovec, iter);
-	}
-
 	ret = kiocb_wait_page_queue_init(kiocb, &req->io->rw.wpq,
 						io_async_buf_func, req);
 	if (!ret) {
@@ -3140,8 +3139,8 @@ static int io_read(struct io_kiocb *req, bool force_nonblock,
 	struct iovec inline_vecs[UIO_FASTIOV], *iovec = inline_vecs;
 	struct kiocb *kiocb = &req->rw.kiocb;
 	struct iov_iter __iter, *iter = &__iter;
+	ssize_t io_size, ret, ret2;
 	size_t iov_count;
-	ssize_t io_size, ret, ret2 = 0;
 
 	if (req->io)
 		iter = &req->io->rw.iter;
@@ -3151,6 +3150,7 @@ static int io_read(struct io_kiocb *req, bool force_nonblock,
 		return ret;
 	io_size = ret;
 	req->result = io_size;
+	ret = 0;
 
 	/* Ensure we clear previously set non-block flag */
 	if (!force_nonblock)
@@ -3165,31 +3165,62 @@ static int io_read(struct io_kiocb *req, bool force_nonblock,
 	if (unlikely(ret))
 		goto out_free;
 
-	ret2 = io_iter_do_read(req, iter);
+	ret = io_iter_do_read(req, iter);
 
-	/* Catch -EAGAIN return for forced non-blocking submission */
-	if (!force_nonblock || (ret2 != -EAGAIN && ret2 != -EIO)) {
-		kiocb_done(kiocb, ret2, cs);
-	} else {
+	if (!ret) {
+		goto done;
+	} else if (ret == -EIOCBQUEUED) {
+		ret = 0;
+		goto out_free;
+	} else if (ret == -EAGAIN) {
+		ret2 = io_setup_async_rw(req, iovec, iter, false);
+		if (ret2 < 0)
+			ret = ret2;
+		goto out_free;
+	} else if (ret < 0) {
+		goto out_free;
+	}
+
+	/* read it all, or we did blocking attempt. no retry. */
+	if (!iov_iter_count(iter) || !force_nonblock)
+		goto done;
+
+	io_size -= ret;
 copy_iov:
-		ret = io_setup_async_rw(req, iovec, iter);
-		if (ret)
-			goto out_free;
-		/* it's copied and will be cleaned with ->io */
-		iovec = NULL;
-		/* if we can retry, do so with the callbacks armed */
-		if (io_rw_should_retry(req, iovec, inline_vecs, iter)) {
-			ret2 = io_iter_do_read(req, iter);
-			if (ret2 == -EIOCBQUEUED) {
-				goto out_free;
-			} else if (ret2 != -EAGAIN) {
-				kiocb_done(kiocb, ret2, cs);
-				goto out_free;
-			}
-		}
+	ret2 = io_setup_async_rw(req, iovec, iter, true);
+	if (ret2) {
+		ret = ret2;
+		goto out_free;
+	}
+	/* it's copied and will be cleaned with ->io */
+	iovec = NULL;
+	/* now use our persistent iterator, if we aren't already */
+	iter = &req->io->rw.iter;
+retry:
+	req->io->rw.bytes_done += ret;
+	/* if we can retry, do so with the callbacks armed */
+	if (!io_rw_should_retry(req)) {
 		kiocb->ki_flags &= ~IOCB_WAITQ;
 		return -EAGAIN;
 	}
+
+	/*
+	 * Now retry read with the IOCB_WAITQ parts set in the iocb. If we
+	 * get -EIOCBQUEUED, then we'll get a notification when the desired
+	 * page gets unlocked. We can also get a partial read here, and if we
+	 * do, then just retry at the new offset.
+	 */
+	ret = io_iter_do_read(req, iter);
+	if (ret == -EIOCBQUEUED) {
+		ret = 0;
+		goto out_free;
+	} else if (ret > 0 && ret < io_size) {
+		/* we got some bytes, but not all. retry. */
+		goto retry;
+	}
+done:
+	kiocb_done(kiocb, ret, cs);
+	ret = 0;
 out_free:
 	if (iovec)
 		kfree(iovec);
@@ -3282,7 +3313,7 @@ static int io_write(struct io_kiocb *req, bool force_nonblock,
 		kiocb_done(kiocb, ret2, cs);
 	} else {
 copy_iov:
-		ret = io_setup_async_rw(req, iovec, iter);
+		ret = io_setup_async_rw(req, iovec, iter, false);
 		if (ret)
 			goto out_free;
 		/* it's copied and will be cleaned with ->io */
-- 
2.28.0

