Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26FE91281A0
	for <lists+io-uring@lfdr.de>; Fri, 20 Dec 2019 18:47:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727435AbfLTRrr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 20 Dec 2019 12:47:47 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:46058 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727388AbfLTRrr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 20 Dec 2019 12:47:47 -0500
Received: by mail-io1-f68.google.com with SMTP id i11so10191976ioi.12
        for <io-uring@vger.kernel.org>; Fri, 20 Dec 2019 09:47:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rjaQdJdvz24lf8S4fUEbTgJzKBxcKN+GALdwTGC7EMM=;
        b=sfJ9FWOFWp8Ml+qCSxGH2Q1fqjtYtGXpJJuMnQtbbM5TC7W+1/GFAm7h+jMGBAc1+R
         ZGDb4+idSreY3oBJ0TYFPm4ejGCv8lwCZNanaYga4KsxaYnw9TSeDEb9sbDxKvsJMTIO
         Ihab3iolMFhczJmKEeW+GWGXzFjmYDvHVWcxJ4c4+b2Jkf8jSdeDGyerNe+x7DWqPbg2
         MXdK/AcABlGwvCQSKKpAH4rMSw6WnJPIdoREKcJe7Q7Jq7hfDVJgEcIdKheDVsswlgrA
         DCCwbvzdAjn710qUQURpb+7KOr9GLoY6yDdg3V2nKUDQ/hWn8gQyMe4SJdHzCSA0CQsU
         Zowg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rjaQdJdvz24lf8S4fUEbTgJzKBxcKN+GALdwTGC7EMM=;
        b=hAZy3h1hlm3oDq8dotKRD+M/cx5QSz+ejWEoyrqQhbn9uT71bsoYpszy9++nW8yk58
         +HSAV/CMvOLo59JZxg9cmdJeUzs4pYZUbL3ydJtsoECenMxmO8/BAfDzNmAybP2P3Cgm
         QuEYJZtIYUs0gbvS0CVAR+4KDqWCKd7M/vln5Mj4Ms2m0HwyznY2j7BtyLKlC+Bvm2Vm
         gXOtFEbcIus1YlvK7oR6uipURkW5bkt83yBsd6srGNwnHewnYq9BjECK8hTfec0L8MYc
         nUbbsPaRXg56IZJneWVTZD2Z1gDy1Xqp7npK58dganHWFs0GKu9QConAQQQwgzOBLfky
         wuYQ==
X-Gm-Message-State: APjAAAVdaG/HFBZgVXecvjXwSJbYXPKkyuHt1Ga8ERoneWR/4bucta9J
        F6YdKwNkAsHR4jWEjkG4W/oVCK/ibpguCA==
X-Google-Smtp-Source: APXvYqxj4n1vbmfdhwI9n710DMsXBu5zZoyjapxFJX+TAYeWaOtf8bQVou4zlQ9Z1CX61ShaeJPUQQ==
X-Received: by 2002:a5d:8501:: with SMTP id q1mr10978892ion.268.1576864066281;
        Fri, 20 Dec 2019 09:47:46 -0800 (PST)
Received: from x1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id j88sm4969677ilf.83.2019.12.20.09.47.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Dec 2019 09:47:45 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/7] io_uring: add and use struct io_rw for read/writes
Date:   Fri, 20 Dec 2019 10:47:37 -0700
Message-Id: <20191220174742.7449-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191220174742.7449-1-axboe@kernel.dk>
References: <20191220174742.7449-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Put the kiocb in struct io_rw, and add the addr/len for the request as
well. Use the kiocb->private field for the buffer index for fixed reads
and writes.

Any use of kiocb->ki_filp is flipped to req->file. It's the same thing,
and less confusing.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 96 +++++++++++++++++++++++++++------------------------
 1 file changed, 50 insertions(+), 46 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 7a23d2351be2..b5f91d21fd04 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -332,6 +332,13 @@ struct io_timeout {
 	int				flags;
 };
 
+struct io_rw {
+	/* NOTE: kiocb has the file as the first member, so don't do it here */
+	struct kiocb			kiocb;
+	u64				addr;
+	u64				len;
+};
+
 struct io_async_connect {
 	struct sockaddr_storage		address;
 };
@@ -369,7 +376,7 @@ struct io_async_ctx {
 struct io_kiocb {
 	union {
 		struct file		*file;
-		struct kiocb		rw;
+		struct io_rw		rw;
 		struct io_poll_iocb	poll;
 		struct io_accept	accept;
 		struct io_sync		sync;
@@ -1180,7 +1187,7 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, unsigned int *nr_events,
 
 	ret = 0;
 	list_for_each_entry_safe(req, tmp, &ctx->poll_list, list) {
-		struct kiocb *kiocb = &req->rw;
+		struct kiocb *kiocb = &req->rw.kiocb;
 
 		/*
 		 * Move completed entries to our local list. If we find a
@@ -1335,7 +1342,7 @@ static inline void req_set_fail_links(struct io_kiocb *req)
 
 static void io_complete_rw_common(struct kiocb *kiocb, long res)
 {
-	struct io_kiocb *req = container_of(kiocb, struct io_kiocb, rw);
+	struct io_kiocb *req = container_of(kiocb, struct io_kiocb, rw.kiocb);
 
 	if (kiocb->ki_flags & IOCB_WRITE)
 		kiocb_end_write(req);
@@ -1347,7 +1354,7 @@ static void io_complete_rw_common(struct kiocb *kiocb, long res)
 
 static void io_complete_rw(struct kiocb *kiocb, long res, long res2)
 {
-	struct io_kiocb *req = container_of(kiocb, struct io_kiocb, rw);
+	struct io_kiocb *req = container_of(kiocb, struct io_kiocb, rw.kiocb);
 
 	io_complete_rw_common(kiocb, res);
 	io_put_req(req);
@@ -1355,7 +1362,7 @@ static void io_complete_rw(struct kiocb *kiocb, long res, long res2)
 
 static struct io_kiocb *__io_complete_rw(struct kiocb *kiocb, long res)
 {
-	struct io_kiocb *req = container_of(kiocb, struct io_kiocb, rw);
+	struct io_kiocb *req = container_of(kiocb, struct io_kiocb, rw.kiocb);
 	struct io_kiocb *nxt = NULL;
 
 	io_complete_rw_common(kiocb, res);
@@ -1366,7 +1373,7 @@ static struct io_kiocb *__io_complete_rw(struct kiocb *kiocb, long res)
 
 static void io_complete_rw_iopoll(struct kiocb *kiocb, long res, long res2)
 {
-	struct io_kiocb *req = container_of(kiocb, struct io_kiocb, rw);
+	struct io_kiocb *req = container_of(kiocb, struct io_kiocb, rw.kiocb);
 
 	if (kiocb->ki_flags & IOCB_WRITE)
 		kiocb_end_write(req);
@@ -1400,7 +1407,7 @@ static void io_iopoll_req_issued(struct io_kiocb *req)
 
 		list_req = list_first_entry(&ctx->poll_list, struct io_kiocb,
 						list);
-		if (list_req->rw.ki_filp != req->rw.ki_filp)
+		if (list_req->file != req->file)
 			ctx->poll_multi_file = true;
 	}
 
@@ -1475,7 +1482,7 @@ static int io_prep_rw(struct io_kiocb *req, bool force_nonblock)
 {
 	const struct io_uring_sqe *sqe = req->sqe;
 	struct io_ring_ctx *ctx = req->ctx;
-	struct kiocb *kiocb = &req->rw;
+	struct kiocb *kiocb = &req->rw.kiocb;
 	unsigned ioprio;
 	int ret;
 
@@ -1524,6 +1531,12 @@ static int io_prep_rw(struct io_kiocb *req, bool force_nonblock)
 			return -EINVAL;
 		kiocb->ki_complete = io_complete_rw;
 	}
+
+	req->rw.addr = READ_ONCE(req->sqe->addr);
+	req->rw.len = READ_ONCE(req->sqe->len);
+	/* we own ->private, reuse it for the buffer index */
+	req->rw.kiocb.private = (void *) (unsigned long)
+					READ_ONCE(req->sqe->buf_index);
 	return 0;
 }
 
@@ -1557,11 +1570,11 @@ static void kiocb_done(struct kiocb *kiocb, ssize_t ret, struct io_kiocb **nxt,
 		io_rw_done(kiocb, ret);
 }
 
-static ssize_t io_import_fixed(struct io_ring_ctx *ctx, int rw,
-			       const struct io_uring_sqe *sqe,
+static ssize_t io_import_fixed(struct io_kiocb *req, int rw,
 			       struct iov_iter *iter)
 {
-	size_t len = READ_ONCE(sqe->len);
+	struct io_ring_ctx *ctx = req->ctx;
+	size_t len = req->rw.len;
 	struct io_mapped_ubuf *imu;
 	unsigned index, buf_index;
 	size_t offset;
@@ -1571,13 +1584,13 @@ static ssize_t io_import_fixed(struct io_ring_ctx *ctx, int rw,
 	if (unlikely(!ctx->user_bufs))
 		return -EFAULT;
 
-	buf_index = READ_ONCE(sqe->buf_index);
+	buf_index = (unsigned long) req->rw.kiocb.private;
 	if (unlikely(buf_index >= ctx->nr_user_bufs))
 		return -EFAULT;
 
 	index = array_index_nospec(buf_index, ctx->nr_user_bufs);
 	imu = &ctx->user_bufs[index];
-	buf_addr = READ_ONCE(sqe->addr);
+	buf_addr = req->rw.addr;
 
 	/* overflow */
 	if (buf_addr + len < buf_addr)
@@ -1634,25 +1647,20 @@ static ssize_t io_import_fixed(struct io_ring_ctx *ctx, int rw,
 static ssize_t io_import_iovec(int rw, struct io_kiocb *req,
 			       struct iovec **iovec, struct iov_iter *iter)
 {
-	const struct io_uring_sqe *sqe = req->sqe;
-	void __user *buf = u64_to_user_ptr(READ_ONCE(sqe->addr));
-	size_t sqe_len = READ_ONCE(sqe->len);
+	void __user *buf = u64_to_user_ptr(req->rw.addr);
+	size_t sqe_len = req->rw.len;
 	u8 opcode;
 
-	/*
-	 * We're reading ->opcode for the second time, but the first read
-	 * doesn't care whether it's _FIXED or not, so it doesn't matter
-	 * whether ->opcode changes concurrently. The first read does care
-	 * about whether it is a READ or a WRITE, so we don't trust this read
-	 * for that purpose and instead let the caller pass in the read/write
-	 * flag.
-	 */
 	opcode = req->opcode;
 	if (opcode == IORING_OP_READ_FIXED || opcode == IORING_OP_WRITE_FIXED) {
 		*iovec = NULL;
-		return io_import_fixed(req->ctx, rw, sqe, iter);
+		return io_import_fixed(req, rw, iter);
 	}
 
+	/* buffer index only valid with fixed read/write */
+	if (req->rw.kiocb.private)
+		return -EINVAL;
+
 	if (req->io) {
 		struct io_async_rw *iorw = &req->io->rw;
 
@@ -1801,9 +1809,8 @@ static int io_read(struct io_kiocb *req, struct io_kiocb **nxt,
 		   bool force_nonblock)
 {
 	struct iovec inline_vecs[UIO_FASTIOV], *iovec = inline_vecs;
-	struct kiocb *kiocb = &req->rw;
+	struct kiocb *kiocb = &req->rw.kiocb;
 	struct iov_iter iter;
-	struct file *file;
 	size_t iov_count;
 	ssize_t io_size, ret;
 
@@ -1819,9 +1826,8 @@ static int io_read(struct io_kiocb *req, struct io_kiocb **nxt,
 
 	/* Ensure we clear previously set non-block flag */
 	if (!force_nonblock)
-		req->rw.ki_flags &= ~IOCB_NOWAIT;
+		req->rw.kiocb.ki_flags &= ~IOCB_NOWAIT;
 
-	file = req->file;
 	io_size = ret;
 	if (req->flags & REQ_F_LINK)
 		req->result = io_size;
@@ -1830,20 +1836,20 @@ static int io_read(struct io_kiocb *req, struct io_kiocb **nxt,
 	 * If the file doesn't support async, mark it as REQ_F_MUST_PUNT so
 	 * we know to async punt it even if it was opened O_NONBLOCK
 	 */
-	if (force_nonblock && !io_file_supports_async(file)) {
+	if (force_nonblock && !io_file_supports_async(req->file)) {
 		req->flags |= REQ_F_MUST_PUNT;
 		goto copy_iov;
 	}
 
 	iov_count = iov_iter_count(&iter);
-	ret = rw_verify_area(READ, file, &kiocb->ki_pos, iov_count);
+	ret = rw_verify_area(READ, req->file, &kiocb->ki_pos, iov_count);
 	if (!ret) {
 		ssize_t ret2;
 
-		if (file->f_op->read_iter)
-			ret2 = call_read_iter(file, kiocb, &iter);
+		if (req->file->f_op->read_iter)
+			ret2 = call_read_iter(req->file, kiocb, &iter);
 		else
-			ret2 = loop_rw_iter(READ, file, kiocb, &iter);
+			ret2 = loop_rw_iter(READ, req->file, kiocb, &iter);
 
 		/*
 		 * In case of a short read, punt to async. This can happen
@@ -1894,9 +1900,8 @@ static int io_write(struct io_kiocb *req, struct io_kiocb **nxt,
 		    bool force_nonblock)
 {
 	struct iovec inline_vecs[UIO_FASTIOV], *iovec = inline_vecs;
-	struct kiocb *kiocb = &req->rw;
+	struct kiocb *kiocb = &req->rw.kiocb;
 	struct iov_iter iter;
-	struct file *file;
 	size_t iov_count;
 	ssize_t ret, io_size;
 
@@ -1912,9 +1917,8 @@ static int io_write(struct io_kiocb *req, struct io_kiocb **nxt,
 
 	/* Ensure we clear previously set non-block flag */
 	if (!force_nonblock)
-		req->rw.ki_flags &= ~IOCB_NOWAIT;
+		req->rw.kiocb.ki_flags &= ~IOCB_NOWAIT;
 
-	file = kiocb->ki_filp;
 	io_size = ret;
 	if (req->flags & REQ_F_LINK)
 		req->result = io_size;
@@ -1934,7 +1938,7 @@ static int io_write(struct io_kiocb *req, struct io_kiocb **nxt,
 		goto copy_iov;
 
 	iov_count = iov_iter_count(&iter);
-	ret = rw_verify_area(WRITE, file, &kiocb->ki_pos, iov_count);
+	ret = rw_verify_area(WRITE, req->file, &kiocb->ki_pos, iov_count);
 	if (!ret) {
 		ssize_t ret2;
 
@@ -1946,17 +1950,17 @@ static int io_write(struct io_kiocb *req, struct io_kiocb **nxt,
 		 * we return to userspace.
 		 */
 		if (req->flags & REQ_F_ISREG) {
-			__sb_start_write(file_inode(file)->i_sb,
+			__sb_start_write(file_inode(req->file)->i_sb,
 						SB_FREEZE_WRITE, true);
-			__sb_writers_release(file_inode(file)->i_sb,
+			__sb_writers_release(file_inode(req->file)->i_sb,
 						SB_FREEZE_WRITE);
 		}
 		kiocb->ki_flags |= IOCB_WRITE;
 
-		if (file->f_op->write_iter)
-			ret2 = call_write_iter(file, kiocb, &iter);
+		if (req->file->f_op->write_iter)
+			ret2 = call_write_iter(req->file, kiocb, &iter);
 		else
-			ret2 = loop_rw_iter(WRITE, file, kiocb, &iter);
+			ret2 = loop_rw_iter(WRITE, req->file, kiocb, &iter);
 		if (!force_nonblock || ret2 != -EAGAIN) {
 			kiocb_done(kiocb, ret2, nxt, req->in_async);
 		} else {
@@ -2036,7 +2040,7 @@ static void io_fsync_finish(struct io_wq_work **workptr)
 	if (io_req_cancelled(req))
 		return;
 
-	ret = vfs_fsync_range(req->rw.ki_filp, req->sync.off,
+	ret = vfs_fsync_range(req->file, req->sync.off,
 				end > 0 ? end : LLONG_MAX,
 				req->sync.flags & IORING_FSYNC_DATASYNC);
 	if (ret < 0)
@@ -2102,7 +2106,7 @@ static void io_sync_file_range_finish(struct io_wq_work **workptr)
 	if (io_req_cancelled(req))
 		return;
 
-	ret = sync_file_range(req->rw.ki_filp, req->sync.off, req->sync.len,
+	ret = sync_file_range(req->file, req->sync.off, req->sync.len,
 				req->sync.flags);
 	if (ret < 0)
 		req_set_fail_links(req);
-- 
2.24.1

