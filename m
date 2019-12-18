Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DD30124EEC
	for <lists+io-uring@lfdr.de>; Wed, 18 Dec 2019 18:18:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727034AbfLRRSs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 Dec 2019 12:18:48 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:33277 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726996AbfLRRSr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 Dec 2019 12:18:47 -0500
Received: by mail-io1-f65.google.com with SMTP id z8so2799900ioh.0
        for <io-uring@vger.kernel.org>; Wed, 18 Dec 2019 09:18:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IouXew9R/5GmuXR4upDwOZ/NgJuR2ykwWfchpvEFRlg=;
        b=geOw6NScoWM/jlq3QwM2IFr/xXYgBSW4EN5QqzrNxD+j8gIe5WTxll6SL/Zr3Vt0eP
         0ix53ZvqLnebybelwTwmQC2xTVeM63pjwLGi6W4raBWpvrkwFvN26jxgdKIrH8Gltifn
         KfpnF99BBovbaqQTDoFSIigLPvPqbJeiXFsljv4akbSEPnmRGUtOsLgbRU5plBuOUjS0
         oawdBWRGmXt0S7AfFMJ+rtQstccY1v02mKPUkVkXSAGnGEuPLVHBBZyuzxogE5Ot/AfK
         td3HARUoTz/7R82IKc1G/MewdDFgG6LaC5xKf4AirDU40WY0Lqvrbzu7Oii3/s2KyG5t
         Vmrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IouXew9R/5GmuXR4upDwOZ/NgJuR2ykwWfchpvEFRlg=;
        b=BOL1WTMGU9OkQbaqqGDzG2TTOsNFjhNjIWFmG9POYx9AexfZ6ARpA3ncti7n/GDR/g
         FArmS46pasyNRPkJVzu3JPDltAkKJdBwqtvFS8E1pGdalXqjkz0mwVUO/qaQeE1jfJWR
         Rub7WF3xmvN9qhRKOPDNKnL+JyNqGptPKUMAl+c7q8dMWuzeslMaK2cZKEvwYtKGjKhc
         FFzJVO1eIiIo7gjkISSFMRDvMXyKZM0L+oDlIOtVVGopVzp0hG+gycAjBKhR4MBALiki
         dl7+HVnzE7fXGSRVJE/Cc6fTd7hEB6wegV8zD1gjhH9CSOMBqiOjLAma6D5ijkiEk86Z
         ICFg==
X-Gm-Message-State: APjAAAVYCcoVpp6u1B0UGVrvZ3rnRQ0C12FZriUZXJV5yknZXvnbrJhA
        ApK3w6VtD55Zqremn8PwYrsyTlWck4sqOw==
X-Google-Smtp-Source: APXvYqy+4jJCoIKYJdigujAsuKA/sMA7lYRacAmQawOLWOtW7eEkV0X9RiVzSGdNl96WDH0zt1XfXw==
X-Received: by 2002:a6b:3845:: with SMTP id f66mr2673463ioa.102.1576689526552;
        Wed, 18 Dec 2019 09:18:46 -0800 (PST)
Received: from x1.thefacebook.com ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id o12sm577488ioh.42.2019.12.18.09.18.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 09:18:46 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 04/13] io_uring: fix pre-prepped issue with force_nonblock == true
Date:   Wed, 18 Dec 2019 10:18:26 -0700
Message-Id: <20191218171835.13315-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191218171835.13315-1-axboe@kernel.dk>
References: <20191218171835.13315-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Some of these code paths assume that any force_nonblock == true issue
is not prepped, but that's not true if we did prep as part of link setup
earlier. Check if we already have an async context allocate before
setting up a new one.

Cleanup the async context setup in general, we have a lot of duplicated
code there.

Fixes: 03b1230ca12a ("io_uring: ensure async punted sendmsg/recvmsg requests copy data")
Fixes: f67676d160c6 ("io_uring: ensure async punted read/write requests copy iovec")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 175 ++++++++++++++++++++++++++++----------------------
 1 file changed, 98 insertions(+), 77 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 0e01cdc8a120..582c7c19bdd7 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1701,7 +1701,7 @@ static ssize_t loop_rw_iter(int rw, struct file *file, struct kiocb *kiocb,
 	return ret;
 }
 
-static void io_req_map_io(struct io_kiocb *req, ssize_t io_size,
+static void io_req_map_rw(struct io_kiocb *req, ssize_t io_size,
 			  struct iovec *iovec, struct iovec *fast_iov,
 			  struct iov_iter *iter)
 {
@@ -1715,19 +1715,39 @@ static void io_req_map_io(struct io_kiocb *req, ssize_t io_size,
 	}
 }
 
-static int io_setup_async_io(struct io_kiocb *req, ssize_t io_size,
-			     struct iovec *iovec, struct iovec *fast_iov,
-			     struct iov_iter *iter)
+static int io_alloc_async_ctx(struct io_kiocb *req)
 {
 	req->io = kmalloc(sizeof(*req->io), GFP_KERNEL);
 	if (req->io) {
-		io_req_map_io(req, io_size, iovec, fast_iov, iter);
 		memcpy(&req->io->sqe, req->sqe, sizeof(req->io->sqe));
 		req->sqe = &req->io->sqe;
 		return 0;
 	}
 
-	return -ENOMEM;
+	return 1;
+}
+
+static void io_rw_async(struct io_wq_work **workptr)
+{
+	struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
+	struct iovec *iov = NULL;
+
+	if (req->io->rw.iov != req->io->rw.fast_iov)
+		iov = req->io->rw.iov;
+	io_wq_submit_work(workptr);
+	kfree(iov);
+}
+
+static int io_setup_async_rw(struct io_kiocb *req, ssize_t io_size,
+			     struct iovec *iovec, struct iovec *fast_iov,
+			     struct iov_iter *iter)
+{
+	if (!req->io && io_alloc_async_ctx(req))
+		return -ENOMEM;
+
+	io_req_map_rw(req, io_size, iovec, fast_iov, iter);
+	req->work.func = io_rw_async;
+	return 0;
 }
 
 static int io_read_prep(struct io_kiocb *req, struct iovec **iovec,
@@ -1806,7 +1826,7 @@ static int io_read(struct io_kiocb *req, struct io_kiocb **nxt,
 			kiocb_done(kiocb, ret2, nxt, req->in_async);
 		} else {
 copy_iov:
-			ret = io_setup_async_io(req, io_size, iovec,
+			ret = io_setup_async_rw(req, io_size, iovec,
 						inline_vecs, &iter);
 			if (ret)
 				goto out_free;
@@ -1814,7 +1834,8 @@ static int io_read(struct io_kiocb *req, struct io_kiocb **nxt,
 		}
 	}
 out_free:
-	kfree(iovec);
+	if (!io_wq_current_is_worker())
+		kfree(iovec);
 	return ret;
 }
 
@@ -1900,7 +1921,7 @@ static int io_write(struct io_kiocb *req, struct io_kiocb **nxt,
 			kiocb_done(kiocb, ret2, nxt, req->in_async);
 		} else {
 copy_iov:
-			ret = io_setup_async_io(req, io_size, iovec,
+			ret = io_setup_async_rw(req, io_size, iovec,
 						inline_vecs, &iter);
 			if (ret)
 				goto out_free;
@@ -1908,7 +1929,8 @@ static int io_write(struct io_kiocb *req, struct io_kiocb **nxt,
 		}
 	}
 out_free:
-	kfree(iovec);
+	if (!io_wq_current_is_worker())
+		kfree(iovec);
 	return ret;
 }
 
@@ -2021,6 +2043,19 @@ static int io_sync_file_range(struct io_kiocb *req,
 	return 0;
 }
 
+#if defined(CONFIG_NET)
+static void io_sendrecv_async(struct io_wq_work **workptr)
+{
+	struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
+	struct iovec *iov = NULL;
+
+	if (req->io->rw.iov != req->io->rw.fast_iov)
+		iov = req->io->msg.iov;
+	io_wq_submit_work(workptr);
+	kfree(iov);
+}
+#endif
+
 static int io_sendmsg_prep(struct io_kiocb *req, struct io_async_ctx *io)
 {
 #if defined(CONFIG_NET)
@@ -2050,7 +2085,7 @@ static int io_sendmsg(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 
 	sock = sock_from_file(req->file, &ret);
 	if (sock) {
-		struct io_async_ctx io, *copy;
+		struct io_async_ctx io;
 		struct sockaddr_storage addr;
 		unsigned flags;
 
@@ -2077,15 +2112,12 @@ static int io_sendmsg(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 
 		ret = __sys_sendmsg_sock(sock, &kmsg->msg, flags);
 		if (force_nonblock && ret == -EAGAIN) {
-			copy = kmalloc(sizeof(*copy), GFP_KERNEL);
-			if (!copy) {
-				ret = -ENOMEM;
-				goto out;
-			}
-			memcpy(&copy->msg, &io.msg, sizeof(copy->msg));
-			req->io = copy;
-			memcpy(&req->io->sqe, req->sqe, sizeof(*req->sqe));
-			req->sqe = &req->io->sqe;
+			if (req->io)
+				return -EAGAIN;
+			if (io_alloc_async_ctx(req))
+				return -ENOMEM;
+			memcpy(&req->io->msg, &io.msg, sizeof(io.msg));
+			req->work.func = io_sendrecv_async;
 			return -EAGAIN;
 		}
 		if (ret == -ERESTARTSYS)
@@ -2093,7 +2125,7 @@ static int io_sendmsg(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	}
 
 out:
-	if (kmsg && kmsg->iov != kmsg->fast_iov)
+	if (!io_wq_current_is_worker() && kmsg && kmsg->iov != kmsg->fast_iov)
 		kfree(kmsg->iov);
 	io_cqring_add_event(req, ret);
 	if (ret < 0)
@@ -2136,7 +2168,7 @@ static int io_recvmsg(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	sock = sock_from_file(req->file, &ret);
 	if (sock) {
 		struct user_msghdr __user *msg;
-		struct io_async_ctx io, *copy;
+		struct io_async_ctx io;
 		struct sockaddr_storage addr;
 		unsigned flags;
 
@@ -2165,15 +2197,12 @@ static int io_recvmsg(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 
 		ret = __sys_recvmsg_sock(sock, &kmsg->msg, msg, kmsg->uaddr, flags);
 		if (force_nonblock && ret == -EAGAIN) {
-			copy = kmalloc(sizeof(*copy), GFP_KERNEL);
-			if (!copy) {
-				ret = -ENOMEM;
-				goto out;
-			}
-			memcpy(copy, &io, sizeof(*copy));
-			req->io = copy;
-			memcpy(&req->io->sqe, req->sqe, sizeof(*req->sqe));
-			req->sqe = &req->io->sqe;
+			if (req->io)
+				return -EAGAIN;
+			if (io_alloc_async_ctx(req))
+				return -ENOMEM;
+			memcpy(&req->io->msg, &io.msg, sizeof(io.msg));
+			req->work.func = io_sendrecv_async;
 			return -EAGAIN;
 		}
 		if (ret == -ERESTARTSYS)
@@ -2181,7 +2210,7 @@ static int io_recvmsg(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	}
 
 out:
-	if (kmsg && kmsg->iov != kmsg->fast_iov)
+	if (!io_wq_current_is_worker() && kmsg && kmsg->iov != kmsg->fast_iov)
 		kfree(kmsg->iov);
 	io_cqring_add_event(req, ret);
 	if (ret < 0)
@@ -2272,15 +2301,13 @@ static int io_connect(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	ret = __sys_connect_file(req->file, &io->connect.address, addr_len,
 					file_flags);
 	if ((ret == -EAGAIN || ret == -EINPROGRESS) && force_nonblock) {
-		io = kmalloc(sizeof(*io), GFP_KERNEL);
-		if (!io) {
+		if (req->io)
+			return -EAGAIN;
+		if (io_alloc_async_ctx(req)) {
 			ret = -ENOMEM;
 			goto out;
 		}
-		memcpy(&io->connect, &__io.connect, sizeof(io->connect));
-		req->io = io;
-		memcpy(&io->sqe, req->sqe, sizeof(*req->sqe));
-		req->sqe = &io->sqe;
+		memcpy(&req->io->connect, &__io.connect, sizeof(__io.connect));
 		return -EAGAIN;
 	}
 	if (ret == -ERESTARTSYS)
@@ -2511,7 +2538,6 @@ static int io_poll_add(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	if (!poll->file)
 		return -EBADF;
 
-	req->io = NULL;
 	INIT_IO_WORK(&req->work, io_poll_complete_work);
 	events = READ_ONCE(sqe->poll_events);
 	poll->events = demangle_poll(events) | EPOLLERR | EPOLLHUP;
@@ -2692,7 +2718,6 @@ static int io_timeout_prep(struct io_kiocb *req, struct io_async_ctx *io,
 		data->mode = HRTIMER_MODE_REL;
 
 	hrtimer_init(&data->timer, CLOCK_MONOTONIC, data->mode);
-	req->io = io;
 	return 0;
 }
 
@@ -2701,22 +2726,16 @@ static int io_timeout(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	unsigned count;
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_timeout_data *data;
-	struct io_async_ctx *io;
 	struct list_head *entry;
 	unsigned span = 0;
+	int ret;
 
-	io = req->io;
-	if (!io) {
-		int ret;
-
-		io = kmalloc(sizeof(*io), GFP_KERNEL);
-		if (!io)
+	if (!req->io) {
+		if (io_alloc_async_ctx(req))
 			return -ENOMEM;
-		ret = io_timeout_prep(req, io, false);
-		if (ret) {
-			kfree(io);
+		ret = io_timeout_prep(req, req->io, false);
+		if (ret)
 			return ret;
-		}
 	}
 	data = &req->io->timeout;
 
@@ -2858,23 +2877,35 @@ static int io_async_cancel(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	return 0;
 }
 
-static int io_req_defer_prep(struct io_kiocb *req, struct io_async_ctx *io)
+static int io_req_defer_prep(struct io_kiocb *req)
 {
 	struct iovec inline_vecs[UIO_FASTIOV], *iovec = inline_vecs;
+	struct io_async_ctx *io = req->io;
 	struct iov_iter iter;
 	ssize_t ret;
 
-	memcpy(&io->sqe, req->sqe, sizeof(io->sqe));
-	req->sqe = &io->sqe;
-
 	switch (io->sqe.opcode) {
 	case IORING_OP_READV:
 	case IORING_OP_READ_FIXED:
+		/* ensure prep does right import */
+		req->io = NULL;
 		ret = io_read_prep(req, &iovec, &iter, true);
+		req->io = io;
+		if (ret < 0)
+			break;
+		io_req_map_rw(req, ret, iovec, inline_vecs, &iter);
+		ret = 0;
 		break;
 	case IORING_OP_WRITEV:
 	case IORING_OP_WRITE_FIXED:
+		/* ensure prep does right import */
+		req->io = NULL;
 		ret = io_write_prep(req, &iovec, &iter, true);
+		req->io = io;
+		if (ret < 0)
+			break;
+		io_req_map_rw(req, ret, iovec, inline_vecs, &iter);
+		ret = 0;
 		break;
 	case IORING_OP_SENDMSG:
 		ret = io_sendmsg_prep(req, io);
@@ -2886,41 +2917,34 @@ static int io_req_defer_prep(struct io_kiocb *req, struct io_async_ctx *io)
 		ret = io_connect_prep(req, io);
 		break;
 	case IORING_OP_TIMEOUT:
-		return io_timeout_prep(req, io, false);
+		ret = io_timeout_prep(req, io, false);
+		break;
 	case IORING_OP_LINK_TIMEOUT:
-		return io_timeout_prep(req, io, true);
+		ret = io_timeout_prep(req, io, true);
+		break;
 	default:
-		req->io = io;
-		return 0;
+		ret = 0;
+		break;
 	}
 
-	if (ret < 0)
-		return ret;
-
-	req->io = io;
-	io_req_map_io(req, ret, iovec, inline_vecs, &iter);
-	return 0;
+	return ret;
 }
 
 static int io_req_defer(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
-	struct io_async_ctx *io;
 	int ret;
 
 	/* Still need defer if there is pending req in defer list. */
 	if (!req_need_defer(req) && list_empty(&ctx->defer_list))
 		return 0;
 
-	io = kmalloc(sizeof(*io), GFP_KERNEL);
-	if (!io)
+	if (io_alloc_async_ctx(req))
 		return -EAGAIN;
 
-	ret = io_req_defer_prep(req, io);
-	if (ret < 0) {
-		kfree(io);
+	ret = io_req_defer_prep(req);
+	if (ret < 0)
 		return ret;
-	}
 
 	spin_lock_irq(&ctx->completion_lock);
 	if (!req_need_defer(req) && list_empty(&ctx->defer_list)) {
@@ -3366,7 +3390,6 @@ static bool io_submit_sqe(struct io_kiocb *req, struct io_submit_state *state,
 	 */
 	if (*link) {
 		struct io_kiocb *prev = *link;
-		struct io_async_ctx *io;
 
 		if (req->sqe->flags & IOSQE_IO_DRAIN)
 			(*link)->flags |= REQ_F_DRAIN_LINK | REQ_F_IO_DRAIN;
@@ -3374,15 +3397,13 @@ static bool io_submit_sqe(struct io_kiocb *req, struct io_submit_state *state,
 		if (req->sqe->flags & IOSQE_IO_HARDLINK)
 			req->flags |= REQ_F_HARDLINK;
 
-		io = kmalloc(sizeof(*io), GFP_KERNEL);
-		if (!io) {
+		if (io_alloc_async_ctx(req)) {
 			ret = -EAGAIN;
 			goto err_req;
 		}
 
-		ret = io_req_defer_prep(req, io);
+		ret = io_req_defer_prep(req);
 		if (ret) {
-			kfree(io);
 			/* fail even hard links since we don't submit */
 			prev->flags |= REQ_F_FAIL_LINK;
 			goto err_req;
-- 
2.24.1

