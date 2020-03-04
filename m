Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5AE217975A
	for <lists+io-uring@lfdr.de>; Wed,  4 Mar 2020 19:00:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727084AbgCDSAY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 4 Mar 2020 13:00:24 -0500
Received: from mail-il1-f196.google.com ([209.85.166.196]:33612 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728168AbgCDSAY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 4 Mar 2020 13:00:24 -0500
Received: by mail-il1-f196.google.com with SMTP id r4so2616422iln.0
        for <io-uring@vger.kernel.org>; Wed, 04 Mar 2020 10:00:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gmGr8prTa4Az7d1pampDxztcLQm7WMzybq8meENy1NM=;
        b=EutKY4TPZNdp3uWi7GqLPLbWrcbU+EmRcGaWDR5247eb92vMqrjgFYFAICJl0WI6Bf
         Mijoz7Wn0SwmgtINVK3DETfVNDIC+zR/xE1AnyHzcxIpk1o/RKzez/vN6y4zKpajqL3w
         X8zSO6GcviFk9V4CtJf5UrXyGAZO5r9Zm/9kDMpr6URMU+UUWrujVax7s134V111HL1c
         5GybZq/SKHpbz2RCd8znWY4r+q8mLVdL1JbJgMZIke7Hqf3xqOacjnFqxf//VjA+pfee
         3dxn3e8wJwN78TrCjiaUZ8xeu1Hm1ieo6O7IQt1VnvGYOsS37TsXQHG7AdkvPY0DwmFx
         tXrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gmGr8prTa4Az7d1pampDxztcLQm7WMzybq8meENy1NM=;
        b=W2uNck7fXUeI0ZtNdE4MqpXX4H5t3j+Uz/9tJI+yomsuouSSP5OjS0FeMWxPeI+YFM
         PDxq8lhVFi21u09a01m6iJqqZFx00KIDqlS735ffQRdWytoi3HXM6hN/wBGwchOHmBBl
         HIHlV5vv6q+XVZMVpW5qycmYSVB93O4ANNVIfxeOMUg19Mc6zPtVAf1tfLlrCDPsWVme
         yv4dV6i64FxEnyoJoKYm4AqkLoFspDKDCgXTq6mou7PRZvEhIau83yn8R1lNcdYJTGkU
         XjqyqPaS3nKjYZPgLS5+s3n/JK7ucD57HzeX0x26YkPrT+coBL0IT3CIk2WH/I+B7Lzq
         8rOg==
X-Gm-Message-State: ANhLgQ0uVY4nEB0G4TYYtL0dQGzMAD3PCCgtbOsVYmHJWgZDY8p/UqHX
        1m1Gka6UhDb86vOVu+gRSicbZbJPZXw=
X-Google-Smtp-Source: ADFU+vvZ+uUSP3kUiZ2i61wYcYMdhIUs3sI1aqOvHNCEtP1JGdxZN+mTUYWXYi+gag7928+DRagi8w==
X-Received: by 2002:a92:c149:: with SMTP id b9mr3948963ilh.178.1583344822458;
        Wed, 04 Mar 2020 10:00:22 -0800 (PST)
Received: from x1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id p23sm6715187ioo.54.2020.03.04.10.00.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2020 10:00:21 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     jlayton@kernel.org, josh@joshtriplett.org,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/6] io_uring: move read/write side file based prep into op handler
Date:   Wed,  4 Mar 2020 11:00:13 -0700
Message-Id: <20200304180016.28212-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200304180016.28212-1-axboe@kernel.dk>
References: <20200304180016.28212-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

In preparation for not needing req->file in on the prep side at all.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 73 +++++++++++++++++++++++++++++++--------------------
 1 file changed, 44 insertions(+), 29 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c29a721114e0..ed70ac09ca18 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2030,37 +2030,19 @@ static bool io_file_supports_async(struct file *file)
 	return false;
 }
 
-static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
-		      bool force_nonblock)
+static int io_prep_rw(struct io_kiocb *req, bool force_nonblock)
 {
-	struct io_ring_ctx *ctx = req->ctx;
 	struct kiocb *kiocb = &req->rw.kiocb;
-	unsigned ioprio;
-	int ret;
 
 	if (S_ISREG(file_inode(req->file)->i_mode))
 		req->flags |= REQ_F_ISREG;
 
-	kiocb->ki_pos = READ_ONCE(sqe->off);
 	if (kiocb->ki_pos == -1 && !(req->file->f_mode & FMODE_STREAM)) {
 		req->flags |= REQ_F_CUR_POS;
 		kiocb->ki_pos = req->file->f_pos;
 	}
 	kiocb->ki_hint = ki_hint_validate(file_write_hint(kiocb->ki_filp));
-	kiocb->ki_flags = iocb_flags(kiocb->ki_filp);
-	ret = kiocb_set_rw_flags(kiocb, READ_ONCE(sqe->rw_flags));
-	if (unlikely(ret))
-		return ret;
-
-	ioprio = READ_ONCE(sqe->ioprio);
-	if (ioprio) {
-		ret = ioprio_check_cap(ioprio);
-		if (ret)
-			return ret;
-
-		kiocb->ki_ioprio = ioprio;
-	} else
-		kiocb->ki_ioprio = get_current_ioprio();
+	kiocb->ki_flags |= iocb_flags(kiocb->ki_filp);
 
 	/* don't allow async punt if RWF_NOWAIT was requested */
 	if ((kiocb->ki_flags & IOCB_NOWAIT) ||
@@ -2070,7 +2052,7 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	if (force_nonblock)
 		kiocb->ki_flags |= IOCB_NOWAIT;
 
-	if (ctx->flags & IORING_SETUP_IOPOLL) {
+	if (req->ctx->flags & IORING_SETUP_IOPOLL) {
 		if (!(kiocb->ki_flags & IOCB_DIRECT) ||
 		    !kiocb->ki_filp->f_op->iopoll)
 			return -EOPNOTSUPP;
@@ -2084,6 +2066,31 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 		kiocb->ki_complete = io_complete_rw;
 	}
 
+	return 0;
+}
+
+static int io_sqe_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	struct kiocb *kiocb = &req->rw.kiocb;
+	unsigned ioprio;
+	int ret;
+
+	kiocb->ki_pos = READ_ONCE(sqe->off);
+	kiocb->ki_flags = 0;
+	ret = kiocb_set_rw_flags(kiocb, READ_ONCE(sqe->rw_flags));
+	if (unlikely(ret))
+		return ret;
+
+	ioprio = READ_ONCE(sqe->ioprio);
+	if (ioprio) {
+		ret = ioprio_check_cap(ioprio);
+		if (ret)
+			return ret;
+
+		kiocb->ki_ioprio = ioprio;
+	} else
+		kiocb->ki_ioprio = get_current_ioprio();
+
 	req->rw.addr = READ_ONCE(sqe->addr);
 	req->rw.len = READ_ONCE(sqe->len);
 	/* we own ->private, reuse it for the buffer index  / buffer ID */
@@ -2487,13 +2494,10 @@ static int io_read_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	struct iov_iter iter;
 	ssize_t ret;
 
-	ret = io_prep_rw(req, sqe, force_nonblock);
+	ret = io_sqe_prep_rw(req, sqe);
 	if (ret)
 		return ret;
 
-	if (unlikely(!(req->file->f_mode & FMODE_READ)))
-		return -EBADF;
-
 	/* either don't need iovec imported or already have it */
 	if (!req->io || req->flags & REQ_F_NEED_CLEANUP)
 		return 0;
@@ -2518,6 +2522,13 @@ static int io_read(struct io_kiocb *req, bool force_nonblock)
 	size_t iov_count;
 	ssize_t io_size, ret;
 
+	if (unlikely(!(req->file->f_mode & FMODE_READ)))
+		return -EBADF;
+
+	ret = io_prep_rw(req, force_nonblock);
+	if (ret)
+		return ret;
+
 	ret = io_import_iovec(READ, req, &iovec, &iter, !force_nonblock);
 	if (ret < 0)
 		return ret;
@@ -2576,13 +2587,10 @@ static int io_write_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	struct iov_iter iter;
 	ssize_t ret;
 
-	ret = io_prep_rw(req, sqe, force_nonblock);
+	ret = io_sqe_prep_rw(req, sqe);
 	if (ret)
 		return ret;
 
-	if (unlikely(!(req->file->f_mode & FMODE_WRITE)))
-		return -EBADF;
-
 	/* either don't need iovec imported or already have it */
 	if (!req->io || req->flags & REQ_F_NEED_CLEANUP)
 		return 0;
@@ -2607,6 +2615,13 @@ static int io_write(struct io_kiocb *req, bool force_nonblock)
 	size_t iov_count;
 	ssize_t ret, io_size;
 
+	if (unlikely(!(req->file->f_mode & FMODE_WRITE)))
+		return -EBADF;
+
+	ret = io_prep_rw(req, force_nonblock);
+	if (ret)
+		return ret;
+
 	ret = io_import_iovec(WRITE, req, &iovec, &iter, !force_nonblock);
 	if (ret < 0)
 		return ret;
-- 
2.25.1

