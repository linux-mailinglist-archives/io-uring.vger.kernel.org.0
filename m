Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 796212351C3
	for <lists+io-uring@lfdr.de>; Sat,  1 Aug 2020 12:52:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727984AbgHAKwH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 1 Aug 2020 06:52:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725931AbgHAKwG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 1 Aug 2020 06:52:06 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9211EC06174A
        for <io-uring@vger.kernel.org>; Sat,  1 Aug 2020 03:52:06 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id kq25so20933299ejb.3
        for <io-uring@vger.kernel.org>; Sat, 01 Aug 2020 03:52:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=o5zBreKtHZWe9dpPnOKiEF33+QOlNYY1sqbRwez0dlg=;
        b=XuZftO9q5taBgmz1voZOMj8nVIFU+sbOzaHM8x0qwMBWw0eO+jDZe+dUztauZB3i/d
         PCEmyHo9PIz/ibkRoUr7fa8KEElVpVXZ5P5IpZMVJd51RlxD70he1rmwop6QDhpNm5TP
         aU/NpFemHGjvERj8hW6x1rJp5lcnkrTXCt1KeKdWEJihUxjG66cO/b+891+5sFh0ZoMy
         lkV9QVu8K4P7loPHpHC9pclCVkAqvrgWyfNE8hqTOAiyEK3Msl/oC6ta8Anr5KoprFhd
         h9iLKYIyQacj3dZKeLOKw0gKhz6iqWoO4AmRgteTORT/l3QHA5v7pXmp2/eWQqZz8jdC
         fCPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=o5zBreKtHZWe9dpPnOKiEF33+QOlNYY1sqbRwez0dlg=;
        b=CpOjNxiPaMqJkEreS8iHmfFSEz4s7OyRD4cHSwNWtM5jI7i0Ha9rJCwM2dspKaNMue
         waN3bU83HM7xsMefhdQfPXfAEhzvLBPFP4U1BGRB2EN1ILzpL4EH2JbLmDRc63WLWD8z
         SpXegeBo/tSB4BVzpYcWMPinYWpKFHRkOsBTZ5qgONI2+4yrdfKWjdRY3sDdbCIM6fsC
         ceMYwMOjQ/8UgzpEoVT/UstEtXNnLasMJkMTubLPcqFlHveoy2+peU1C/x6NBN8mpYCe
         lT0lAtvxYY+RsdBBkIjWK1lM4V3LZy5kWA7+e03935aYTFE5s9meU2OyBeQhUTqyB94c
         L/qA==
X-Gm-Message-State: AOAM530lTW3UEpmexUOiy0V6mDlVS46laQUx4Q1av0JWguSiWxBLWn86
        ZzqsS6R2Krub0M+CoGHnhJo=
X-Google-Smtp-Source: ABdhPJxht15tQMWxH4TssP78AvNF4dZnsm83JIpsp41M/ncfWFnwzck0JfFnSQs+IIyT71FdQIz8zQ==
X-Received: by 2002:a17:906:374f:: with SMTP id e15mr7777637ejc.528.1596279125117;
        Sat, 01 Aug 2020 03:52:05 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.69])
        by smtp.gmail.com with ESMTPSA id s16sm10802723ejr.31.2020.08.01.03.52.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Aug 2020 03:52:04 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH] io_uring: flip if handling after io_setup_async_rw
Date:   Sat,  1 Aug 2020 13:50:02 +0300
Message-Id: <b5a869f3f739854a0458cc32be9af96e79b62dbc.1596275586.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

As recently done with with send/recv, flip the if after
rw_verify_aread() in io_{read,write}() and tabulise left bits left.
This removes mispredicted by a compiler jump on the success/fast path.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 146 +++++++++++++++++++++++++-------------------------
 1 file changed, 72 insertions(+), 74 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index fabf0b692384..6bce16dc5a54 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3034,57 +3034,56 @@ static int io_read(struct io_kiocb *req, bool force_nonblock,
 	struct kiocb *kiocb = &req->rw.kiocb;
 	struct iov_iter iter;
 	size_t iov_count;
-	ssize_t io_size, ret;
+	ssize_t io_size, ret, ret2;
+	unsigned long nr_segs;
 
 	ret = io_import_iovec(READ, req, &iovec, &iter, !force_nonblock);
 	if (ret < 0)
 		return ret;
+	io_size = ret;
+	req->result = io_size;
 
 	/* Ensure we clear previously set non-block flag */
 	if (!force_nonblock)
 		kiocb->ki_flags &= ~IOCB_NOWAIT;
 
-	io_size = ret;
-	req->result = io_size;
-
 	/* If the file doesn't support async, just async punt */
 	if (force_nonblock && !io_file_supports_async(req->file, READ))
 		goto copy_iov;
 
 	iov_count = iov_iter_count(&iter);
+	nr_segs = iter.nr_segs;
 	ret = rw_verify_area(READ, req->file, &kiocb->ki_pos, iov_count);
-	if (!ret) {
-		unsigned long nr_segs = iter.nr_segs;
-		ssize_t ret2 = 0;
+	if (unlikely(ret))
+		goto out_free;
 
-		ret2 = io_iter_do_read(req, &iter);
+	ret2 = io_iter_do_read(req, &iter);
 
-		/* Catch -EAGAIN return for forced non-blocking submission */
-		if (!force_nonblock || (ret2 != -EAGAIN && ret2 != -EIO)) {
-			kiocb_done(kiocb, ret2, cs);
-		} else {
-			iter.count = iov_count;
-			iter.nr_segs = nr_segs;
+	/* Catch -EAGAIN return for forced non-blocking submission */
+	if (!force_nonblock || (ret2 != -EAGAIN && ret2 != -EIO)) {
+		kiocb_done(kiocb, ret2, cs);
+	} else {
+		iter.count = iov_count;
+		iter.nr_segs = nr_segs;
 copy_iov:
-			ret = io_setup_async_rw(req, io_size, iovec,
-						inline_vecs, &iter);
-			if (ret)
+		ret = io_setup_async_rw(req, io_size, iovec, inline_vecs,
+					&iter);
+		if (ret)
+			goto out_free;
+		/* it's copied and will be cleaned with ->io */
+		iovec = NULL;
+		/* if we can retry, do so with the callbacks armed */
+		if (io_rw_should_retry(req)) {
+			ret2 = io_iter_do_read(req, &iter);
+			if (ret2 == -EIOCBQUEUED) {
+				goto out_free;
+			} else if (ret2 != -EAGAIN) {
+				kiocb_done(kiocb, ret2, cs);
 				goto out_free;
-			/* it's copied and will be cleaned with ->io */
-			iovec = NULL;
-			/* if we can retry, do so with the callbacks armed */
-			if (io_rw_should_retry(req)) {
-				ret2 = io_iter_do_read(req, &iter);
-				if (ret2 == -EIOCBQUEUED) {
-					goto out_free;
-				} else if (ret2 != -EAGAIN) {
-					kiocb_done(kiocb, ret2, cs);
-					goto out_free;
-				}
 			}
-			kiocb->ki_flags &= ~IOCB_WAITQ;
-			return -EAGAIN;
 		}
+		kiocb->ki_flags &= ~IOCB_WAITQ;
+		return -EAGAIN;
 	}
 out_free:
 	if (iovec)
@@ -3117,19 +3116,19 @@ static int io_write(struct io_kiocb *req, bool force_nonblock,
 	struct kiocb *kiocb = &req->rw.kiocb;
 	struct iov_iter iter;
 	size_t iov_count;
-	ssize_t ret, io_size;
+	ssize_t ret, ret2, io_size;
+	unsigned long nr_segs;
 
 	ret = io_import_iovec(WRITE, req, &iovec, &iter, !force_nonblock);
 	if (ret < 0)
 		return ret;
+	io_size = ret;
+	req->result = io_size;
 
 	/* Ensure we clear previously set non-block flag */
 	if (!force_nonblock)
 		req->rw.kiocb.ki_flags &= ~IOCB_NOWAIT;
 
-	io_size = ret;
-	req->result = io_size;
-
 	/* If the file doesn't support async, just async punt */
 	if (force_nonblock && !io_file_supports_async(req->file, WRITE))
 		goto copy_iov;
@@ -3140,51 +3139,50 @@ static int io_write(struct io_kiocb *req, bool force_nonblock,
 		goto copy_iov;
 
 	iov_count = iov_iter_count(&iter);
+	nr_segs = iter.nr_segs;
 	ret = rw_verify_area(WRITE, req->file, &kiocb->ki_pos, iov_count);
-	if (!ret) {
-		unsigned long nr_segs = iter.nr_segs;
-		ssize_t ret2;
+	if (unlikely(ret))
+		goto out_free;
 
-		/*
-		 * Open-code file_start_write here to grab freeze protection,
-		 * which will be released by another thread in
-		 * io_complete_rw().  Fool lockdep by telling it the lock got
-		 * released so that it doesn't complain about the held lock when
-		 * we return to userspace.
-		 */
-		if (req->flags & REQ_F_ISREG) {
-			__sb_start_write(file_inode(req->file)->i_sb,
-						SB_FREEZE_WRITE, true);
-			__sb_writers_release(file_inode(req->file)->i_sb,
-						SB_FREEZE_WRITE);
-		}
-		kiocb->ki_flags |= IOCB_WRITE;
+	/*
+	 * Open-code file_start_write here to grab freeze protection,
+	 * which will be released by another thread in
+	 * io_complete_rw().  Fool lockdep by telling it the lock got
+	 * released so that it doesn't complain about the held lock when
+	 * we return to userspace.
+	 */
+	if (req->flags & REQ_F_ISREG) {
+		__sb_start_write(file_inode(req->file)->i_sb,
+					SB_FREEZE_WRITE, true);
+		__sb_writers_release(file_inode(req->file)->i_sb,
+					SB_FREEZE_WRITE);
+	}
+	kiocb->ki_flags |= IOCB_WRITE;
 
-		if (req->file->f_op->write_iter)
-			ret2 = call_write_iter(req->file, kiocb, &iter);
-		else
-			ret2 = loop_rw_iter(WRITE, req->file, kiocb, &iter);
+	if (req->file->f_op->write_iter)
+		ret2 = call_write_iter(req->file, kiocb, &iter);
+	else
+		ret2 = loop_rw_iter(WRITE, req->file, kiocb, &iter);
 
-		/*
-		 * Raw bdev writes will return -EOPNOTSUPP for IOCB_NOWAIT. Just
-		 * retry them without IOCB_NOWAIT.
-		 */
-		if (ret2 == -EOPNOTSUPP && (kiocb->ki_flags & IOCB_NOWAIT))
-			ret2 = -EAGAIN;
-		if (!force_nonblock || ret2 != -EAGAIN) {
-			kiocb_done(kiocb, ret2, cs);
-		} else {
-			iter.count = iov_count;
-			iter.nr_segs = nr_segs;
+	/*
+	 * Raw bdev writes will return -EOPNOTSUPP for IOCB_NOWAIT. Just
+	 * retry them without IOCB_NOWAIT.
+	 */
+	if (ret2 == -EOPNOTSUPP && (kiocb->ki_flags & IOCB_NOWAIT))
+		ret2 = -EAGAIN;
+	if (!force_nonblock || ret2 != -EAGAIN) {
+		kiocb_done(kiocb, ret2, cs);
+	} else {
+		iter.count = iov_count;
+		iter.nr_segs = nr_segs;
 copy_iov:
-			ret = io_setup_async_rw(req, io_size, iovec,
-						inline_vecs, &iter);
-			if (ret)
-				goto out_free;
-			/* it's copied and will be cleaned with ->io */
-			iovec = NULL;
-			return -EAGAIN;
-		}
+		ret = io_setup_async_rw(req, io_size, iovec, inline_vecs,
+					&iter);
+		if (ret)
+			goto out_free;
+		/* it's copied and will be cleaned with ->io */
+		iovec = NULL;
+		return -EAGAIN;
 	}
 out_free:
 	if (iovec)
-- 
2.24.0

