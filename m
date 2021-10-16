Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4EA443058D
	for <lists+io-uring@lfdr.de>; Sun, 17 Oct 2021 01:08:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241089AbhJPXKI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 16 Oct 2021 19:10:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241088AbhJPXKI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 16 Oct 2021 19:10:08 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA43CC061765
        for <io-uring@vger.kernel.org>; Sat, 16 Oct 2021 16:07:59 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id t16so53773156eds.9
        for <io-uring@vger.kernel.org>; Sat, 16 Oct 2021 16:07:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AWj9uxwjJruOmsQqZJENboc0eqybUoBQj7sWMM6vpQo=;
        b=MTD9pIC+/t8cRxyq8VWY7XOzNCmxz6a5bBadz1OADmP7DhQtc82bpyjfFW0HE/Uo0I
         NbU6HhmR1Ng1LHjeeGTPpnD4GWJm/IQNNmMXj0dflmtXEQqc5P4i0PsmQ3K5MBSSFqjP
         KaeXH8nnZ2vgiA2LZTWrCXRAa9YxnNX3MgEn973XwSE4i9x0PZMZWxyVrIjZ+pTW6eJ1
         NTwv92qh3/uCeC+kbarjbWcvmByNcIGDlHwB5bBeKmKMx+PTaMevQRNp8knxKNcZ+myH
         vIyUeo2y58YmjZ/esYy+HJYJyvnCjRPqqZHIOyPUuhkNXnbLVZ7q07giHON6xkfsPm7n
         Pv2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AWj9uxwjJruOmsQqZJENboc0eqybUoBQj7sWMM6vpQo=;
        b=fPx6M3eogQJZC9dvFNpMDHdiTbKfJKXnj/WMkUL1igEk65hpl7WqTH54+EP+0Er9LD
         iWch4eMzNI7ds6jTRdxZmQ4vBog62fW5k3q8HIk4a7AEb5gisxrgcN2WXuTsM7EjS7rF
         e/H7XqsrwGqsG7IoXK7/kaoInx6gZypKhN336Up3ujvOoA5eJjV5P8N8mWCbXlYSm0mU
         f6r8e2uwF8Wu7f1XB3EdNjauk7MWJk971qFXU391pnPt9okLSHQ53KVToYqatbxv4Me6
         sRGAzH+5RTjNJBL96KtQHMDvLPpvh0Xo3eEMO4/4EQ1C5zJcjbTfQrXZaZ+EYtuOnJyG
         4szA==
X-Gm-Message-State: AOAM5303q6dGXK/I4zfv5Afgh/goQt7o8Vl6pO0d+4rMUDQqSolarx1I
        kAsoUv0OBYo05Jcubk7cczVZEjVoqFRNOQ==
X-Google-Smtp-Source: ABdhPJzCLaZnZF3zTPANv9bL2f3Cglq2GmXM2Unijzi9pB1e/iuMEogPLDmbLCQhRbEGlrpmWeQOOw==
X-Received: by 2002:a17:906:cec6:: with SMTP id si6mr17943980ejb.270.1634425678337;
        Sat, 16 Oct 2021 16:07:58 -0700 (PDT)
Received: from localhost.localdomain ([185.69.145.201])
        by smtp.gmail.com with ESMTPSA id q14sm6791217eji.63.2021.10.16.16.07.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Oct 2021 16:07:58 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 2/3] io_uring: combine REQ_F_NOWAIT_{READ,WRITE} flags
Date:   Sun, 17 Oct 2021 00:07:09 +0100
Message-Id: <f832a20e5186c2e79c6519280c238f559a1d2bbc.1634425438.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1634425438.git.asml.silence@gmail.com>
References: <cover.1634425438.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Merge REQ_F_NOWAIT_READ and REQ_F_NOWAIT_WRITE into one flag, i.e.
REQ_F_SUPPORT_NOWAIT. First it gets rid of dependence on CONFIG_64BIT
but also simplifies the code.

One thing to consider is when we don't have ->{read,write}_iter and go
through loop_rw_iter(). Just fail it with -EAGAIN if we expect nowait
behaviour but not sure whether it supports it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 61 ++++++++++++++++++---------------------------------
 1 file changed, 21 insertions(+), 40 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 14566d1bf174..06444b2f9a32 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -732,8 +732,7 @@ enum {
 	REQ_F_ARM_LTIMEOUT_BIT,
 	REQ_F_ASYNC_DATA_BIT,
 	/* keep async read/write and isreg together and in order */
-	REQ_F_NOWAIT_READ_BIT,
-	REQ_F_NOWAIT_WRITE_BIT,
+	REQ_F_SUPPORT_NOWAIT_BIT,
 	REQ_F_ISREG_BIT,
 
 	/* not a real bit, just to check we're not overflowing the space */
@@ -774,10 +773,8 @@ enum {
 	REQ_F_COMPLETE_INLINE	= BIT(REQ_F_COMPLETE_INLINE_BIT),
 	/* caller should reissue async */
 	REQ_F_REISSUE		= BIT(REQ_F_REISSUE_BIT),
-	/* supports async reads */
-	REQ_F_NOWAIT_READ	= BIT(REQ_F_NOWAIT_READ_BIT),
-	/* supports async writes */
-	REQ_F_NOWAIT_WRITE	= BIT(REQ_F_NOWAIT_WRITE_BIT),
+	/* supports async reads/writes */
+	REQ_F_SUPPORT_NOWAIT	= BIT(REQ_F_SUPPORT_NOWAIT_BIT),
 	/* regular file */
 	REQ_F_ISREG		= BIT(REQ_F_ISREG_BIT),
 	/* has creds assigned */
@@ -1390,18 +1387,13 @@ static bool req_need_defer(struct io_kiocb *req, u32 seq)
 	return false;
 }
 
-#define FFS_ASYNC_READ		0x1UL
-#define FFS_ASYNC_WRITE		0x2UL
-#ifdef CONFIG_64BIT
-#define FFS_ISREG		0x4UL
-#else
-#define FFS_ISREG		0x0UL
-#endif
-#define FFS_MASK		~(FFS_ASYNC_READ|FFS_ASYNC_WRITE|FFS_ISREG)
+#define FFS_NOWAIT		0x1UL
+#define FFS_ISREG		0x2UL
+#define FFS_MASK		~(FFS_NOWAIT|FFS_ISREG)
 
 static inline bool io_req_ffs_set(struct io_kiocb *req)
 {
-	return IS_ENABLED(CONFIG_64BIT) && (req->flags & REQ_F_FIXED_FILE);
+	return req->flags & REQ_F_FIXED_FILE;
 }
 
 static inline void io_req_track_inflight(struct io_kiocb *req)
@@ -2775,7 +2767,7 @@ static bool io_bdev_nowait(struct block_device *bdev)
  * any file. For now, just ensure that anything potentially problematic is done
  * inline.
  */
-static bool __io_file_supports_nowait(struct file *file, int rw)
+static bool __io_file_supports_nowait(struct file *file)
 {
 	umode_t mode = file_inode(file)->i_mode;
 
@@ -2798,24 +2790,14 @@ static bool __io_file_supports_nowait(struct file *file, int rw)
 	/* any ->read/write should understand O_NONBLOCK */
 	if (file->f_flags & O_NONBLOCK)
 		return true;
-
-	if (!(file->f_mode & FMODE_NOWAIT))
-		return false;
-
-	if (rw == READ)
-		return file->f_op->read_iter != NULL;
-
-	return file->f_op->write_iter != NULL;
+	return file->f_mode & FMODE_NOWAIT;
 }
 
-static bool io_file_supports_nowait(struct io_kiocb *req, int rw)
+static inline bool io_file_supports_nowait(struct io_kiocb *req)
 {
-	if (rw == READ && (req->flags & REQ_F_NOWAIT_READ))
+	if (likely(req->flags & REQ_F_SUPPORT_NOWAIT))
 		return true;
-	else if (rw == WRITE && (req->flags & REQ_F_NOWAIT_WRITE))
-		return true;
-
-	return __io_file_supports_nowait(req->file, rw);
+	return __io_file_supports_nowait(req->file);
 }
 
 static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
@@ -2847,7 +2829,7 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	 * reliably. If not, or it IOCB_NOWAIT is set, don't retry.
 	 */
 	if ((kiocb->ki_flags & IOCB_NOWAIT) ||
-	    ((file->f_flags & O_NONBLOCK) && !io_file_supports_nowait(req, rw)))
+	    ((file->f_flags & O_NONBLOCK) && !io_file_supports_nowait(req)))
 		req->flags |= REQ_F_NOWAIT;
 
 	ioprio = READ_ONCE(sqe->ioprio);
@@ -3238,7 +3220,8 @@ static ssize_t loop_rw_iter(int rw, struct io_kiocb *req, struct iov_iter *iter)
 	 */
 	if (kiocb->ki_flags & IOCB_HIPRI)
 		return -EOPNOTSUPP;
-	if (kiocb->ki_flags & IOCB_NOWAIT)
+	if ((kiocb->ki_flags & IOCB_NOWAIT) &&
+	    !(kiocb->ki_filp->f_flags & O_NONBLOCK))
 		return -EAGAIN;
 
 	while (iov_iter_count(iter)) {
@@ -3478,7 +3461,7 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
 
 	if (force_nonblock) {
 		/* If the file doesn't support async, just async punt */
-		if (unlikely(!io_file_supports_nowait(req, READ))) {
+		if (unlikely(!io_file_supports_nowait(req))) {
 			ret = io_setup_async_rw(req, iovec, s, true);
 			return ret ?: -EAGAIN;
 		}
@@ -3602,7 +3585,7 @@ static int io_write(struct io_kiocb *req, unsigned int issue_flags)
 
 	if (force_nonblock) {
 		/* If the file doesn't support async, just async punt */
-		if (unlikely(!io_file_supports_nowait(req, WRITE)))
+		if (unlikely(!io_file_supports_nowait(req)))
 			goto copy_iov;
 
 		/* file path doesn't support NOWAIT for non-direct_IO */
@@ -3634,7 +3617,7 @@ static int io_write(struct io_kiocb *req, unsigned int issue_flags)
 	}
 	kiocb->ki_flags |= IOCB_WRITE;
 
-	if (req->file->f_op->write_iter)
+	if (likely(req->file->f_op->write_iter))
 		ret2 = call_write_iter(req->file, kiocb, &s->iter);
 	else if (req->file->f_op->write)
 		ret2 = loop_rw_iter(WRITE, req, &s->iter);
@@ -6781,10 +6764,8 @@ static void io_fixed_file_set(struct io_fixed_file *file_slot, struct file *file
 {
 	unsigned long file_ptr = (unsigned long) file;
 
-	if (__io_file_supports_nowait(file, READ))
-		file_ptr |= FFS_ASYNC_READ;
-	if (__io_file_supports_nowait(file, WRITE))
-		file_ptr |= FFS_ASYNC_WRITE;
+	if (__io_file_supports_nowait(file))
+		file_ptr |= FFS_NOWAIT;
 	if (S_ISREG(file_inode(file)->i_mode))
 		file_ptr |= FFS_ISREG;
 	file_slot->file_ptr = file_ptr;
@@ -6803,7 +6784,7 @@ static inline struct file *io_file_get_fixed(struct io_ring_ctx *ctx,
 	file = (struct file *) (file_ptr & FFS_MASK);
 	file_ptr &= ~FFS_MASK;
 	/* mask in overlapping REQ_F and FFS bits */
-	req->flags |= (file_ptr << REQ_F_NOWAIT_READ_BIT);
+	req->flags |= (file_ptr << REQ_F_SUPPORT_NOWAIT_BIT);
 	io_req_set_rsrc_node(req, ctx);
 	return file;
 }
-- 
2.33.0

