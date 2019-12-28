Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EF9212BEAD
	for <lists+io-uring@lfdr.de>; Sat, 28 Dec 2019 20:21:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726502AbfL1TV0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 28 Dec 2019 14:21:26 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:38914 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726442AbfL1TV0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 28 Dec 2019 14:21:26 -0500
Received: by mail-pl1-f194.google.com with SMTP id g6so10115677plp.6
        for <io-uring@vger.kernel.org>; Sat, 28 Dec 2019 11:21:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0l5fOfPwpgJbGPyPrxy1YmLNd5AAdOmd/c6EROGNc5E=;
        b=BqTWQQR6Fcu7Gw+7HuYkVM4i+Fo7zdSpy1xlP60HSmzH3W2N4Iuy23EDegWJYa1Ie+
         qclHryTSjM9XgYmZcRNLqzM7AQRNmVkl1OqHsZo215xW60Ez6nRiJTsv2fT97UbO4/tu
         P66zAwmm0U0LdBHdzrayaJ1meUrxBMrUmTIE0dZGYjIr2pxqnHATMHo1NlncB17DTgNk
         xOmgTqDBjv58g04dhr+Ej8Liw5zGjI+mvNGl2qh+B3eNK9IKdhaVu3myOlnXg+hzzXur
         4X8EO1SdkMwbUAb0Ct+5jKQSVpV832QI0NeLOEFimATrJ2M431JoyHHC55ZuRMUOl25I
         a66g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0l5fOfPwpgJbGPyPrxy1YmLNd5AAdOmd/c6EROGNc5E=;
        b=qmwjnZiJQIWhg07b+RwkQcitVa4EwnVqHNcAo31IEaEnuUh2nQGTYxx0dTQPpQ28kq
         73hLoE1+11yg2JIBBOR2yKyYHQbUeIBizGLg88FAFQh1LrNUI98cDHA2u3HXK2Wd/rlz
         Y0keREyOPxcK42rEh5PBwNfCtpOg87Oc9Ls6KQp2ZS4HNyhzkAgroA+GDBTUTQVZUY8O
         vXH5qEqb6OPaCWnMwVLrITCJpA47Vjkel55wp2d6qnT3GRYXORVJJXf95qeehjSc+OGN
         S+YClZVIp9UjoW0t7sHbe4fTt2RBLsFn9Z836WmJ8qsXjd3Qv8XaY5q5wUu7JZ/EyWSJ
         hDGQ==
X-Gm-Message-State: APjAAAWEeq/+vYPW0QzvR495ED+W1BfwO7+VOJXbPgz7EG/30GMtFZ88
        nIgvczaDirgfz9p3seCmR1YVRqSTkI7kCQ==
X-Google-Smtp-Source: APXvYqzeaUdnJls8VMQ7BlRW7yKHcTKEgB7kldFcfE+pyy7YRdhTsh9Hezrrgd86DllUydy+wIEeVQ==
X-Received: by 2002:a17:90a:3742:: with SMTP id u60mr35709331pjb.29.1577560885307;
        Sat, 28 Dec 2019 11:21:25 -0800 (PST)
Received: from x1.localdomain ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id z30sm47067902pfq.154.2019.12.28.11.21.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Dec 2019 11:21:24 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5/9] io_uring: add non-vectored read/write commands
Date:   Sat, 28 Dec 2019 12:21:14 -0700
Message-Id: <20191228192118.4005-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191228192118.4005-1-axboe@kernel.dk>
References: <20191228192118.4005-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

For uses cases that don't already naturally have an iovec, it's easier
(or more convenient) to just use a buffer address + length. This is
particular true if the use case is from languages that want to create
a memory safe abstraction on top of io_uring, and where introducing
the need for the iovec may impose an ownership issue. For those cases,
they currently need an indirection buffer, which means allocating data
just for this purpose.

Add basic read/write that don't require the iovec.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c                 | 23 +++++++++++++++++++++++
 include/uapi/linux/io_uring.h |  2 ++
 2 files changed, 25 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 0ee9115a599d..464ca73f2dd3 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -656,6 +656,18 @@ static const struct io_op_def io_op_defs[IORING_OP_LAST] = {
 		.needs_file		= 1,
 		.fd_non_neg		= 1,
 	},
+	{
+		/* IORING_OP_READ */
+		.needs_mm		= 1,
+		.needs_file		= 1,
+		.unbound_nonreg_file	= 1,
+	},
+	{
+		/* IORING_OP_WRITE */
+		.needs_mm		= 1,
+		.needs_file		= 1,
+		.unbound_nonreg_file	= 1,
+	},
 };
 
 static void io_wq_submit_work(struct io_wq_work **workptr);
@@ -1869,6 +1881,13 @@ static ssize_t io_import_iovec(int rw, struct io_kiocb *req,
 	if (req->rw.kiocb.private)
 		return -EINVAL;
 
+	if (opcode == IORING_OP_READ || opcode == IORING_OP_WRITE) {
+		ssize_t ret;
+		ret = import_single_range(rw, buf, sqe_len, *iovec, iter);
+		*iovec = NULL;
+		return ret;
+	}
+
 	if (req->io) {
 		struct io_async_rw *iorw = &req->io->rw;
 
@@ -3635,10 +3654,12 @@ static int io_req_defer_prep(struct io_kiocb *req,
 		break;
 	case IORING_OP_READV:
 	case IORING_OP_READ_FIXED:
+	case IORING_OP_READ:
 		ret = io_read_prep(req, sqe, true);
 		break;
 	case IORING_OP_WRITEV:
 	case IORING_OP_WRITE_FIXED:
+	case IORING_OP_WRITE:
 		ret = io_write_prep(req, sqe, true);
 		break;
 	case IORING_OP_POLL_ADD:
@@ -3742,6 +3763,7 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 		break;
 	case IORING_OP_READV:
 	case IORING_OP_READ_FIXED:
+	case IORING_OP_READ:
 		if (sqe) {
 			ret = io_read_prep(req, sqe, force_nonblock);
 			if (ret < 0)
@@ -3751,6 +3773,7 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 		break;
 	case IORING_OP_WRITEV:
 	case IORING_OP_WRITE_FIXED:
+	case IORING_OP_WRITE:
 		if (sqe) {
 			ret = io_write_prep(req, sqe, force_nonblock);
 			if (ret < 0)
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 762a63a49af1..03d2dde46152 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -84,6 +84,8 @@ enum {
 	IORING_OP_CLOSE,
 	IORING_OP_FILES_UPDATE,
 	IORING_OP_STATX,
+	IORING_OP_READ,
+	IORING_OP_WRITE,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
-- 
2.24.1

