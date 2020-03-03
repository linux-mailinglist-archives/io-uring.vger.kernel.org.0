Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6FD11786B1
	for <lists+io-uring@lfdr.de>; Wed,  4 Mar 2020 00:51:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728032AbgCCXvF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 3 Mar 2020 18:51:05 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:37272 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728017AbgCCXvF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 3 Mar 2020 18:51:05 -0500
Received: by mail-pf1-f193.google.com with SMTP id p14so2334213pfn.4
        for <io-uring@vger.kernel.org>; Tue, 03 Mar 2020 15:51:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6e5Kzw7CjWREIKNo00hqGcXx6rGNAuFWO/UTd3MR96s=;
        b=ayAByQOwflM7b2PXU3LelJEpRzqEGKXehuMKXP8III0liJ4K5leMU+mvjup4YG2q9D
         sT36p51mArBJNGNPjd3GMxU1QTo8KMCOKPq7DrNF4de39DQEUgbTnxxE2Uw/AAmr/JES
         tKdUvyhf3cKZAY1gsl9MJFtIHFOVEhFGT3vrZVs888NfpsjYryhwbZr5Fqf1zIb2VrNE
         uxGPIlCRiL0fy8TQdH/NjyWKAr/V/SZ4tI3O3JABAt1a3JZIlcpztNAjxDu0im60x8Eg
         W5iTVwtbcK742XV4DuuUcbHn2V8KWNmdVOdc4pq6qJ9JYu+p1GWOmKKz7ToJEqgJouJF
         1Xsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6e5Kzw7CjWREIKNo00hqGcXx6rGNAuFWO/UTd3MR96s=;
        b=N/RkrVAEi//5ttUHjTK1DvmX26HAjWQlmjnA9wCM8jukWuxs8qmZCyjcvjUzoQe5E7
         1UkzmPXyasND0R6yqw5B8JxdjTf7nDI5MAwGm51Xgz/oiuHrtqrMDwVrNCeSJ7harC9E
         xUyW9gmGDbNa9uJKZeNYy2kCJ+azDFzV069YIdNKkQ+iptuMmZGJswN4rkwg4Q9m3arx
         4XDnSrXWUbJ5m000mYXDfzMlpMQS5aW0RluWf4vyEXfF8LFx80yfwXYWFGJ/Cn8VYVma
         dIbdfbqT2a3YvlXj3CL38kXlhtqXHFtDH/QTpFFVsxCwccnqOLJqUmppWfUogg4gXANc
         b4Ew==
X-Gm-Message-State: ANhLgQ2cd9qjAjWbhTsIkYeoBHgO0Pa7biI9/h/GOud1EtiuYviAwzS/
        K1awKwtMpvuEtQ72D1opC7aZTg8JKAE=
X-Google-Smtp-Source: ADFU+vt0VfTETBmerg8/Pdqyz8AP8162WbvNg/3SbTKky6FSIbtWMK0qm1o8WF0X36edI397wt283A==
X-Received: by 2002:a63:7207:: with SMTP id n7mr6227900pgc.253.1583279462704;
        Tue, 03 Mar 2020 15:51:02 -0800 (PST)
Received: from x1.localdomain ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id d24sm27041503pfq.75.2020.03.03.15.51.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2020 15:51:02 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     jlayton@kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/4] io_uring: move read/write side file based prep into op handler
Date:   Tue,  3 Mar 2020 16:50:52 -0700
Message-Id: <20200303235053.16309-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303235053.16309-1-axboe@kernel.dk>
References: <20200303235053.16309-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

In preparation for not needing req->file in on the prep side at all.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 72 ++++++++++++++++++++++++++++++---------------------
 1 file changed, 43 insertions(+), 29 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 9d5e49a39dba..8044dec4e793 100644
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
@@ -2084,6 +2066,30 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
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
@@ -2487,13 +2493,10 @@ static int io_read_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
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
@@ -2518,6 +2521,13 @@ static int io_read(struct io_kiocb *req, bool force_nonblock)
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
@@ -2576,13 +2586,10 @@ static int io_write_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
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
@@ -2607,6 +2614,13 @@ static int io_write(struct io_kiocb *req, bool force_nonblock)
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

