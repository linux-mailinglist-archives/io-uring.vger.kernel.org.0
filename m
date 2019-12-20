Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E821A1281A5
	for <lists+io-uring@lfdr.de>; Fri, 20 Dec 2019 18:47:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727442AbfLTRrw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 20 Dec 2019 12:47:52 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:33023 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727436AbfLTRrw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 20 Dec 2019 12:47:52 -0500
Received: by mail-io1-f66.google.com with SMTP id z8so10232732ioh.0
        for <io-uring@vger.kernel.org>; Fri, 20 Dec 2019 09:47:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VLISfeSTBdtRUHeV1RLC0hc0PLr30Yjcm+/I9KroNco=;
        b=QOW89mP1W8VzjqySisD34JbwxMkOZIzyybF4Sn1sritnnMYYujYEMSHMygFzZWa8tz
         OnkSnSE+JIKbsNRCZb2Dxhn0Z4kuEjQhp7RPrr971MPkNQuTdcYUQ40n99eL3PZSXXiB
         DNXjGZNp5gypHGdpstqrIKj71/JLN7yc7WIpI/gpErzP11nut0HK8PuR30/pIWEBjqB3
         z4MKa62CE7TcyNe7N3jEAZqijUJdeENFdAb+iT/RiIKqgr8/rqkhxsn+CGXNDt87RgPN
         jtGMdEuAkEqYDqCzd9m+561TfC0FH6RTA6HigEHVJCNuycAPk+9bnwlioyoL/MZE+qzh
         PpYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VLISfeSTBdtRUHeV1RLC0hc0PLr30Yjcm+/I9KroNco=;
        b=kPqnVqUFmO34xYtayfF7NHBfBhfwWHvBADJL32tLur6KuB9lqok1l0bxxnJ7kN0vYh
         JI4y7qz2KZsGumh0Sg4pFrVVDdIgHyvqaIlJ5QWupoBx63g/G74l/Dox+A/Mr3xdUT2O
         WnDbck30B3fyZNBNB1NXKPR3mIZnuCHd0RmFmp3WJ3DmGMRLOfhbKDK4ZOYcSmTfQ1PA
         XRiLQFDTjUxFNSN1vi0fuTXChVVSNvqTSe+HxYv0/dJMkS8UdCGM+YA/sZzLpfwouhvp
         JZkW3YFtOA1SwVw4bcGP3LIKBlSmgdhaWWKOjCRR3RiRgFE1860KiTNwLukONb0G3JEj
         gl3A==
X-Gm-Message-State: APjAAAUaFZGpCs8aBEgiPZh0BsM9Od3cGvH+unS+Nm/QRiGBjw6vSUJ6
        amYtPWhLBRvgfIUaah4SaF6vTAfcQzzMug==
X-Google-Smtp-Source: APXvYqzFku6GZV1Jzd0hh+uWWD8fc3Bk/pJm7OOhqcs/AELhOoP4ZZNSXF2gLgP1vpRHad4+DatBow==
X-Received: by 2002:a02:7310:: with SMTP id y16mr13115545jab.133.1576864070600;
        Fri, 20 Dec 2019 09:47:50 -0800 (PST)
Received: from x1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id j88sm4969677ilf.83.2019.12.20.09.47.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Dec 2019 09:47:50 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7/7] io_uring: pass in 'sqe' to the prep handlers
Date:   Fri, 20 Dec 2019 10:47:42 -0700
Message-Id: <20191220174742.7449-8-axboe@kernel.dk>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191220174742.7449-1-axboe@kernel.dk>
References: <20191220174742.7449-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This moves the prep handlers outside of the opcode handlers, and allows
us to pass in the sqe directly. If the sqe is non-NULL, it means that
the request should be prepared for the first time.

With the opcode handlers not having access to the sqe at all, we are
guaranteed that the prep handler has setup the request fully by the
time we get there. As before, for opcodes that need to copy in more
data then the io_kiocb allows for, the io_async_ctx holds that info. If
a prep handler is invoked with req->io set, it must use that to retain
information for later.

Finally, we can remove io_kiocb->sqe as well.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 493 +++++++++++++++++++++++++-------------------------
 1 file changed, 251 insertions(+), 242 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 2cdfbb451fe2..562e3a1a1bf9 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -398,7 +398,6 @@ struct io_kiocb {
 		struct io_sr_msg	sr_msg;
 	};
 
-	const struct io_uring_sqe	*sqe;
 	struct io_async_ctx		*io;
 	struct file			*ring_file;
 	int				ring_fd;
@@ -629,33 +628,31 @@ static inline bool io_prep_async_work(struct io_kiocb *req,
 {
 	bool do_hashed = false;
 
-	if (req->sqe) {
-		switch (req->opcode) {
-		case IORING_OP_WRITEV:
-		case IORING_OP_WRITE_FIXED:
-			/* only regular files should be hashed for writes */
-			if (req->flags & REQ_F_ISREG)
-				do_hashed = true;
-			/* fall-through */
-		case IORING_OP_READV:
-		case IORING_OP_READ_FIXED:
-		case IORING_OP_SENDMSG:
-		case IORING_OP_RECVMSG:
-		case IORING_OP_ACCEPT:
-		case IORING_OP_POLL_ADD:
-		case IORING_OP_CONNECT:
-			/*
-			 * We know REQ_F_ISREG is not set on some of these
-			 * opcodes, but this enables us to keep the check in
-			 * just one place.
-			 */
-			if (!(req->flags & REQ_F_ISREG))
-				req->work.flags |= IO_WQ_WORK_UNBOUND;
-			break;
-		}
-		if (io_req_needs_user(req))
-			req->work.flags |= IO_WQ_WORK_NEEDS_USER;
+	switch (req->opcode) {
+	case IORING_OP_WRITEV:
+	case IORING_OP_WRITE_FIXED:
+		/* only regular files should be hashed for writes */
+		if (req->flags & REQ_F_ISREG)
+			do_hashed = true;
+		/* fall-through */
+	case IORING_OP_READV:
+	case IORING_OP_READ_FIXED:
+	case IORING_OP_SENDMSG:
+	case IORING_OP_RECVMSG:
+	case IORING_OP_ACCEPT:
+	case IORING_OP_POLL_ADD:
+	case IORING_OP_CONNECT:
+		/*
+		 * We know REQ_F_ISREG is not set on some of these
+		 * opcodes, but this enables us to keep the check in
+		 * just one place.
+		 */
+		if (!(req->flags & REQ_F_ISREG))
+			req->work.flags |= IO_WQ_WORK_UNBOUND;
+		break;
 	}
+	if (io_req_needs_user(req))
+		req->work.flags |= IO_WQ_WORK_NEEDS_USER;
 
 	*link = io_prep_linked_timeout(req);
 	return do_hashed;
@@ -1491,16 +1488,14 @@ static bool io_file_supports_async(struct file *file)
 	return false;
 }
 
-static int io_prep_rw(struct io_kiocb *req, bool force_nonblock)
+static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
+		      bool force_nonblock)
 {
-	const struct io_uring_sqe *sqe = req->sqe;
 	struct io_ring_ctx *ctx = req->ctx;
 	struct kiocb *kiocb = &req->rw.kiocb;
 	unsigned ioprio;
 	int ret;
 
-	if (!sqe)
-		return 0;
 	if (!req->file)
 		return -EBADF;
 
@@ -1547,12 +1542,11 @@ static int io_prep_rw(struct io_kiocb *req, bool force_nonblock)
 		kiocb->ki_complete = io_complete_rw;
 	}
 
-	req->rw.addr = READ_ONCE(req->sqe->addr);
-	req->rw.len = READ_ONCE(req->sqe->len);
+	req->rw.addr = READ_ONCE(sqe->addr);
+	req->rw.len = READ_ONCE(sqe->len);
 	/* we own ->private, reuse it for the buffer index */
 	req->rw.kiocb.private = (void *) (unsigned long)
-					READ_ONCE(req->sqe->buf_index);
-	req->sqe = NULL;
+					READ_ONCE(sqe->buf_index);
 	return 0;
 }
 
@@ -1800,21 +1794,33 @@ static int io_setup_async_rw(struct io_kiocb *req, ssize_t io_size,
 	return 0;
 }
 
-static int io_read_prep(struct io_kiocb *req, struct iovec **iovec,
-			struct iov_iter *iter, bool force_nonblock)
+static int io_read_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
+			bool force_nonblock)
 {
+	struct io_async_ctx *io;
+	struct iov_iter iter;
 	ssize_t ret;
 
-	if (req->sqe) {
-		ret = io_prep_rw(req, force_nonblock);
-		if (ret)
-			return ret;
+	ret = io_prep_rw(req, sqe, force_nonblock);
+	if (ret)
+		return ret;
 
-		if (unlikely(!(req->file->f_mode & FMODE_READ)))
-			return -EBADF;
-	}
+	if (unlikely(!(req->file->f_mode & FMODE_READ)))
+		return -EBADF;
 
-	return io_import_iovec(READ, req, iovec, iter);
+	if (!req->io)
+		return 0;
+
+	io = req->io;
+	io->rw.iov = io->rw.fast_iov;
+	req->io = NULL;
+	ret = io_import_iovec(READ, req, &io->rw.iov, &iter);
+	req->io = io;
+	if (ret < 0)
+		return ret;
+
+	io_req_map_rw(req, ret, io->rw.iov, io->rw.fast_iov, &iter);
+	return 0;
 }
 
 static int io_read(struct io_kiocb *req, struct io_kiocb **nxt,
@@ -1826,7 +1832,7 @@ static int io_read(struct io_kiocb *req, struct io_kiocb **nxt,
 	size_t iov_count;
 	ssize_t io_size, ret;
 
-	ret = io_read_prep(req, &iovec, &iter, force_nonblock);
+	ret = io_import_iovec(READ, req, &iovec, &iter);
 	if (ret < 0)
 		return ret;
 
@@ -1887,21 +1893,33 @@ static int io_read(struct io_kiocb *req, struct io_kiocb **nxt,
 	return ret;
 }
 
-static int io_write_prep(struct io_kiocb *req, struct iovec **iovec,
-			 struct iov_iter *iter, bool force_nonblock)
+static int io_write_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
+			 bool force_nonblock)
 {
+	struct io_async_ctx *io;
+	struct iov_iter iter;
 	ssize_t ret;
 
-	if (req->sqe) {
-		ret = io_prep_rw(req, force_nonblock);
-		if (ret)
-			return ret;
+	ret = io_prep_rw(req, sqe, force_nonblock);
+	if (ret)
+		return ret;
 
-		if (unlikely(!(req->file->f_mode & FMODE_WRITE)))
-			return -EBADF;
-	}
+	if (unlikely(!(req->file->f_mode & FMODE_WRITE)))
+		return -EBADF;
 
-	return io_import_iovec(WRITE, req, iovec, iter);
+	if (!req->io)
+		return 0;
+
+	io = req->io;
+	io->rw.iov = io->rw.fast_iov;
+	req->io = NULL;
+	ret = io_import_iovec(WRITE, req, &io->rw.iov, &iter);
+	req->io = io;
+	if (ret < 0)
+		return ret;
+
+	io_req_map_rw(req, ret, io->rw.iov, io->rw.fast_iov, &iter);
+	return 0;
 }
 
 static int io_write(struct io_kiocb *req, struct io_kiocb **nxt,
@@ -1913,7 +1931,7 @@ static int io_write(struct io_kiocb *req, struct io_kiocb **nxt,
 	size_t iov_count;
 	ssize_t ret, io_size;
 
-	ret = io_write_prep(req, &iovec, &iter, force_nonblock);
+	ret = io_import_iovec(WRITE, req, &iovec, &iter);
 	if (ret < 0)
 		return ret;
 
@@ -1995,13 +2013,10 @@ static int io_nop(struct io_kiocb *req)
 	return 0;
 }
 
-static int io_prep_fsync(struct io_kiocb *req)
+static int io_prep_fsync(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
-	const struct io_uring_sqe *sqe = req->sqe;
 	struct io_ring_ctx *ctx = req->ctx;
 
-	if (!req->sqe)
-		return 0;
 	if (!req->file)
 		return -EBADF;
 
@@ -2016,7 +2031,6 @@ static int io_prep_fsync(struct io_kiocb *req)
 
 	req->sync.off = READ_ONCE(sqe->off);
 	req->sync.len = READ_ONCE(sqe->len);
-	req->sqe = NULL;
 	return 0;
 }
 
@@ -2057,11 +2071,6 @@ static int io_fsync(struct io_kiocb *req, struct io_kiocb **nxt,
 		    bool force_nonblock)
 {
 	struct io_wq_work *work, *old_work;
-	int ret;
-
-	ret = io_prep_fsync(req);
-	if (ret)
-		return ret;
 
 	/* fsync always requires a blocking context */
 	if (force_nonblock) {
@@ -2077,13 +2086,10 @@ static int io_fsync(struct io_kiocb *req, struct io_kiocb **nxt,
 	return 0;
 }
 
-static int io_prep_sfr(struct io_kiocb *req)
+static int io_prep_sfr(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
-	const struct io_uring_sqe *sqe = req->sqe;
 	struct io_ring_ctx *ctx = req->ctx;
 
-	if (!sqe)
-		return 0;
 	if (!req->file)
 		return -EBADF;
 
@@ -2095,7 +2101,6 @@ static int io_prep_sfr(struct io_kiocb *req)
 	req->sync.off = READ_ONCE(sqe->off);
 	req->sync.len = READ_ONCE(sqe->len);
 	req->sync.flags = READ_ONCE(sqe->sync_range_flags);
-	req->sqe = NULL;
 	return 0;
 }
 
@@ -2122,11 +2127,6 @@ static int io_sync_file_range(struct io_kiocb *req, struct io_kiocb **nxt,
 			      bool force_nonblock)
 {
 	struct io_wq_work *work, *old_work;
-	int ret;
-
-	ret = io_prep_sfr(req);
-	if (ret)
-		return ret;
 
 	/* sync_file_range always requires a blocking context */
 	if (force_nonblock) {
@@ -2155,22 +2155,21 @@ static void io_sendrecv_async(struct io_wq_work **workptr)
 }
 #endif
 
-static int io_sendmsg_prep(struct io_kiocb *req, struct io_async_ctx *io)
+static int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 #if defined(CONFIG_NET)
-	const struct io_uring_sqe *sqe = req->sqe;
 	struct io_sr_msg *sr = &req->sr_msg;
-	int ret;
+	struct io_async_ctx *io = req->io;
 
-	if (!sqe)
-		return 0;
 	sr->msg_flags = READ_ONCE(sqe->msg_flags);
 	sr->msg = u64_to_user_ptr(READ_ONCE(sqe->addr));
+
+	if (!io)
+		return 0;
+
 	io->msg.iov = io->msg.fast_iov;
-	ret = sendmsg_copy_msghdr(&io->msg.msg, sr->msg, sr->msg_flags,
+	return sendmsg_copy_msghdr(&io->msg.msg, sr->msg, sr->msg_flags,
 					&io->msg.iov);
-	req->sqe = NULL;
-	return ret;
 #else
 	return -EOPNOTSUPP;
 #endif
@@ -2201,11 +2200,16 @@ static int io_sendmsg(struct io_kiocb *req, struct io_kiocb **nxt,
 				kmsg->iov = kmsg->fast_iov;
 			kmsg->msg.msg_iter.iov = kmsg->iov;
 		} else {
+			struct io_sr_msg *sr = &req->sr_msg;
+
 			kmsg = &io.msg;
 			kmsg->msg.msg_name = &addr;
-			ret = io_sendmsg_prep(req, &io);
+
+			io.msg.iov = io.msg.fast_iov;
+			ret = sendmsg_copy_msghdr(&io.msg.msg, sr->msg,
+					sr->msg_flags, &io.msg.iov);
 			if (ret)
-				goto out;
+				return ret;
 		}
 
 		flags = req->sr_msg.msg_flags;
@@ -2228,7 +2232,6 @@ static int io_sendmsg(struct io_kiocb *req, struct io_kiocb **nxt,
 			ret = -EINTR;
 	}
 
-out:
 	if (!io_wq_current_is_worker() && kmsg && kmsg->iov != kmsg->fast_iov)
 		kfree(kmsg->iov);
 	io_cqring_add_event(req, ret);
@@ -2241,22 +2244,22 @@ static int io_sendmsg(struct io_kiocb *req, struct io_kiocb **nxt,
 #endif
 }
 
-static int io_recvmsg_prep(struct io_kiocb *req, struct io_async_ctx *io)
+static int io_recvmsg_prep(struct io_kiocb *req,
+			   const struct io_uring_sqe *sqe)
 {
 #if defined(CONFIG_NET)
 	struct io_sr_msg *sr = &req->sr_msg;
-	int ret;
+	struct io_async_ctx *io = req->io;
+
+	sr->msg_flags = READ_ONCE(sqe->msg_flags);
+	sr->msg = u64_to_user_ptr(READ_ONCE(sqe->addr));
 
-	if (!req->sqe)
+	if (!io)
 		return 0;
 
-	sr->msg_flags = READ_ONCE(req->sqe->msg_flags);
-	sr->msg = u64_to_user_ptr(READ_ONCE(req->sqe->addr));
 	io->msg.iov = io->msg.fast_iov;
-	ret = recvmsg_copy_msghdr(&io->msg.msg, sr->msg, sr->msg_flags,
+	return recvmsg_copy_msghdr(&io->msg.msg, sr->msg, sr->msg_flags,
 					&io->msg.uaddr, &io->msg.iov);
-	req->sqe = NULL;
-	return ret;
 #else
 	return -EOPNOTSUPP;
 #endif
@@ -2287,11 +2290,17 @@ static int io_recvmsg(struct io_kiocb *req, struct io_kiocb **nxt,
 				kmsg->iov = kmsg->fast_iov;
 			kmsg->msg.msg_iter.iov = kmsg->iov;
 		} else {
+			struct io_sr_msg *sr = &req->sr_msg;
+
 			kmsg = &io.msg;
 			kmsg->msg.msg_name = &addr;
-			ret = io_recvmsg_prep(req, &io);
+
+			io.msg.iov = io.msg.fast_iov;
+			ret = recvmsg_copy_msghdr(&io.msg.msg, sr->msg,
+					sr->msg_flags, &io.msg.uaddr,
+					&io.msg.iov);
 			if (ret)
-				goto out;
+				return ret;
 		}
 
 		flags = req->sr_msg.msg_flags;
@@ -2315,7 +2324,6 @@ static int io_recvmsg(struct io_kiocb *req, struct io_kiocb **nxt,
 			ret = -EINTR;
 	}
 
-out:
 	if (!io_wq_current_is_worker() && kmsg && kmsg->iov != kmsg->fast_iov)
 		kfree(kmsg->iov);
 	io_cqring_add_event(req, ret);
@@ -2328,15 +2336,11 @@ static int io_recvmsg(struct io_kiocb *req, struct io_kiocb **nxt,
 #endif
 }
 
-static int io_accept_prep(struct io_kiocb *req)
+static int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 #if defined(CONFIG_NET)
-	const struct io_uring_sqe *sqe = req->sqe;
 	struct io_accept *accept = &req->accept;
 
-	if (!req->sqe)
-		return 0;
-
 	if (unlikely(req->ctx->flags & (IORING_SETUP_IOPOLL|IORING_SETUP_SQPOLL)))
 		return -EINVAL;
 	if (sqe->ioprio || sqe->len || sqe->buf_index)
@@ -2345,7 +2349,6 @@ static int io_accept_prep(struct io_kiocb *req)
 	accept->addr = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	accept->addr_len = u64_to_user_ptr(READ_ONCE(sqe->addr2));
 	accept->flags = READ_ONCE(sqe->accept_flags);
-	req->sqe = NULL;
 	return 0;
 #else
 	return -EOPNOTSUPP;
@@ -2393,10 +2396,6 @@ static int io_accept(struct io_kiocb *req, struct io_kiocb **nxt,
 #if defined(CONFIG_NET)
 	int ret;
 
-	ret = io_accept_prep(req);
-	if (ret)
-		return ret;
-
 	ret = __io_accept(req, nxt, force_nonblock);
 	if (ret == -EAGAIN && force_nonblock) {
 		req->work.func = io_accept_finish;
@@ -2410,25 +2409,25 @@ static int io_accept(struct io_kiocb *req, struct io_kiocb **nxt,
 #endif
 }
 
-static int io_connect_prep(struct io_kiocb *req, struct io_async_ctx *io)
+static int io_connect_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 #if defined(CONFIG_NET)
-	const struct io_uring_sqe *sqe = req->sqe;
-	int ret;
+	struct io_connect *conn = &req->connect;
+	struct io_async_ctx *io = req->io;
 
-	if (!sqe)
-		return 0;
 	if (unlikely(req->ctx->flags & (IORING_SETUP_IOPOLL|IORING_SETUP_SQPOLL)))
 		return -EINVAL;
 	if (sqe->ioprio || sqe->len || sqe->buf_index || sqe->rw_flags)
 		return -EINVAL;
 
-	req->connect.addr = u64_to_user_ptr(READ_ONCE(sqe->addr));
-	req->connect.addr_len =  READ_ONCE(sqe->addr2);
-	ret = move_addr_to_kernel(req->connect.addr, req->connect.addr_len,
+	conn->addr = u64_to_user_ptr(READ_ONCE(sqe->addr));
+	conn->addr_len =  READ_ONCE(sqe->addr2);
+
+	if (!io)
+		return 0;
+
+	return move_addr_to_kernel(conn->addr, conn->addr_len,
 					&io->connect.address);
-	req->sqe = NULL;
-	return ret;
 #else
 	return -EOPNOTSUPP;
 #endif
@@ -2445,7 +2444,9 @@ static int io_connect(struct io_kiocb *req, struct io_kiocb **nxt,
 	if (req->io) {
 		io = req->io;
 	} else {
-		ret = io_connect_prep(req, &__io);
+		ret = move_addr_to_kernel(req->connect.addr,
+						req->connect.addr_len,
+						&__io.connect.address);
 		if (ret)
 			goto out;
 		io = &__io;
@@ -2525,12 +2526,9 @@ static int io_poll_cancel(struct io_ring_ctx *ctx, __u64 sqe_addr)
 	return -ENOENT;
 }
 
-static int io_poll_remove_prep(struct io_kiocb *req)
+static int io_poll_remove_prep(struct io_kiocb *req,
+			       const struct io_uring_sqe *sqe)
 {
-	const struct io_uring_sqe *sqe = req->sqe;
-
-	if (!sqe)
-		return 0;
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
 	if (sqe->ioprio || sqe->off || sqe->len || sqe->buf_index ||
@@ -2538,7 +2536,6 @@ static int io_poll_remove_prep(struct io_kiocb *req)
 		return -EINVAL;
 
 	req->poll.addr = READ_ONCE(sqe->addr);
-	req->sqe = NULL;
 	return 0;
 }
 
@@ -2552,10 +2549,6 @@ static int io_poll_remove(struct io_kiocb *req)
 	u64 addr;
 	int ret;
 
-	ret = io_poll_remove_prep(req);
-	if (ret)
-		return ret;
-
 	addr = req->poll.addr;
 	spin_lock_irq(&ctx->completion_lock);
 	ret = io_poll_cancel(ctx, addr);
@@ -2693,14 +2686,11 @@ static void io_poll_req_insert(struct io_kiocb *req)
 	hlist_add_head(&req->hash_node, list);
 }
 
-static int io_poll_add_prep(struct io_kiocb *req)
+static int io_poll_add_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
-	const struct io_uring_sqe *sqe = req->sqe;
 	struct io_poll_iocb *poll = &req->poll;
 	u16 events;
 
-	if (!sqe)
-		return 0;
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
 	if (sqe->addr || sqe->ioprio || sqe->off || sqe->len || sqe->buf_index)
@@ -2710,7 +2700,6 @@ static int io_poll_add_prep(struct io_kiocb *req)
 
 	events = READ_ONCE(sqe->poll_events);
 	poll->events = demangle_poll(events) | EPOLLERR | EPOLLHUP;
-	req->sqe = NULL;
 	return 0;
 }
 
@@ -2721,11 +2710,6 @@ static int io_poll_add(struct io_kiocb *req, struct io_kiocb **nxt)
 	struct io_poll_table ipt;
 	bool cancel = false;
 	__poll_t mask;
-	int ret;
-
-	ret = io_poll_add_prep(req);
-	if (ret)
-		return ret;
 
 	INIT_IO_WORK(&req->work, io_poll_complete_work);
 	INIT_HLIST_NODE(&req->hash_node);
@@ -2844,12 +2828,9 @@ static int io_timeout_cancel(struct io_ring_ctx *ctx, __u64 user_data)
 	return 0;
 }
 
-static int io_timeout_remove_prep(struct io_kiocb *req)
+static int io_timeout_remove_prep(struct io_kiocb *req,
+				  const struct io_uring_sqe *sqe)
 {
-	const struct io_uring_sqe *sqe = req->sqe;
-
-	if (!sqe)
-		return 0;
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
 	if (sqe->flags || sqe->ioprio || sqe->buf_index || sqe->len)
@@ -2860,7 +2841,6 @@ static int io_timeout_remove_prep(struct io_kiocb *req)
 	if (req->timeout.flags)
 		return -EINVAL;
 
-	req->sqe = NULL;
 	return 0;
 }
 
@@ -2872,10 +2852,6 @@ static int io_timeout_remove(struct io_kiocb *req)
 	struct io_ring_ctx *ctx = req->ctx;
 	int ret;
 
-	ret = io_timeout_remove_prep(req);
-	if (ret)
-		return ret;
-
 	spin_lock_irq(&ctx->completion_lock);
 	ret = io_timeout_cancel(ctx, req->timeout.addr);
 
@@ -2889,15 +2865,12 @@ static int io_timeout_remove(struct io_kiocb *req)
 	return 0;
 }
 
-static int io_timeout_prep(struct io_kiocb *req, struct io_async_ctx *io,
+static int io_timeout_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			   bool is_timeout_link)
 {
-	const struct io_uring_sqe *sqe = req->sqe;
 	struct io_timeout_data *data;
 	unsigned flags;
 
-	if (!sqe)
-		return 0;
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
 	if (sqe->ioprio || sqe->buf_index || sqe->len != 1)
@@ -2910,7 +2883,7 @@ static int io_timeout_prep(struct io_kiocb *req, struct io_async_ctx *io,
 
 	req->timeout.count = READ_ONCE(sqe->off);
 
-	if (!io && io_alloc_async_ctx(req))
+	if (!req->io && io_alloc_async_ctx(req))
 		return -ENOMEM;
 
 	data = &req->io->timeout;
@@ -2926,7 +2899,6 @@ static int io_timeout_prep(struct io_kiocb *req, struct io_async_ctx *io,
 		data->mode = HRTIMER_MODE_REL;
 
 	hrtimer_init(&data->timer, CLOCK_MONOTONIC, data->mode);
-	req->sqe = NULL;
 	return 0;
 }
 
@@ -2937,11 +2909,7 @@ static int io_timeout(struct io_kiocb *req)
 	struct io_timeout_data *data;
 	struct list_head *entry;
 	unsigned span = 0;
-	int ret;
 
-	ret = io_timeout_prep(req, req->io, false);
-	if (ret)
-		return ret;
 	data = &req->io->timeout;
 
 	/*
@@ -3067,12 +3035,9 @@ static void io_async_find_and_cancel(struct io_ring_ctx *ctx,
 	io_put_req_find_next(req, nxt);
 }
 
-static int io_async_cancel_prep(struct io_kiocb *req)
+static int io_async_cancel_prep(struct io_kiocb *req,
+				const struct io_uring_sqe *sqe)
 {
-	const struct io_uring_sqe *sqe = req->sqe;
-
-	if (!sqe)
-		return 0;
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
 	if (sqe->flags || sqe->ioprio || sqe->off || sqe->len ||
@@ -3080,28 +3045,20 @@ static int io_async_cancel_prep(struct io_kiocb *req)
 		return -EINVAL;
 
 	req->cancel.addr = READ_ONCE(sqe->addr);
-	req->sqe = NULL;
 	return 0;
 }
 
 static int io_async_cancel(struct io_kiocb *req, struct io_kiocb **nxt)
 {
 	struct io_ring_ctx *ctx = req->ctx;
-	int ret;
-
-	ret = io_async_cancel_prep(req);
-	if (ret)
-		return ret;
 
 	io_async_find_and_cancel(ctx, req, req->cancel.addr, nxt, 0);
 	return 0;
 }
 
-static int io_req_defer_prep(struct io_kiocb *req)
+static int io_req_defer_prep(struct io_kiocb *req,
+			     const struct io_uring_sqe *sqe)
 {
-	struct iovec inline_vecs[UIO_FASTIOV], *iovec = inline_vecs;
-	struct io_async_ctx *io = req->io;
-	struct iov_iter iter;
 	ssize_t ret = 0;
 
 	switch (req->opcode) {
@@ -3109,61 +3066,47 @@ static int io_req_defer_prep(struct io_kiocb *req)
 		break;
 	case IORING_OP_READV:
 	case IORING_OP_READ_FIXED:
-		/* ensure prep does right import */
-		req->io = NULL;
-		ret = io_read_prep(req, &iovec, &iter, true);
-		req->io = io;
-		if (ret < 0)
-			break;
-		io_req_map_rw(req, ret, iovec, inline_vecs, &iter);
-		ret = 0;
+		ret = io_read_prep(req, sqe, true);
 		break;
 	case IORING_OP_WRITEV:
 	case IORING_OP_WRITE_FIXED:
-		/* ensure prep does right import */
-		req->io = NULL;
-		ret = io_write_prep(req, &iovec, &iter, true);
-		req->io = io;
-		if (ret < 0)
-			break;
-		io_req_map_rw(req, ret, iovec, inline_vecs, &iter);
-		ret = 0;
+		ret = io_write_prep(req, sqe, true);
 		break;
 	case IORING_OP_POLL_ADD:
-		ret = io_poll_add_prep(req);
+		ret = io_poll_add_prep(req, sqe);
 		break;
 	case IORING_OP_POLL_REMOVE:
-		ret = io_poll_remove_prep(req);
+		ret = io_poll_remove_prep(req, sqe);
 		break;
 	case IORING_OP_FSYNC:
-		ret = io_prep_fsync(req);
+		ret = io_prep_fsync(req, sqe);
 		break;
 	case IORING_OP_SYNC_FILE_RANGE:
-		ret = io_prep_sfr(req);
+		ret = io_prep_sfr(req, sqe);
 		break;
 	case IORING_OP_SENDMSG:
-		ret = io_sendmsg_prep(req, io);
+		ret = io_sendmsg_prep(req, sqe);
 		break;
 	case IORING_OP_RECVMSG:
-		ret = io_recvmsg_prep(req, io);
+		ret = io_recvmsg_prep(req, sqe);
 		break;
 	case IORING_OP_CONNECT:
-		ret = io_connect_prep(req, io);
+		ret = io_connect_prep(req, sqe);
 		break;
 	case IORING_OP_TIMEOUT:
-		ret = io_timeout_prep(req, io, false);
+		ret = io_timeout_prep(req, sqe, false);
 		break;
 	case IORING_OP_TIMEOUT_REMOVE:
-		ret = io_timeout_remove_prep(req);
+		ret = io_timeout_remove_prep(req, sqe);
 		break;
 	case IORING_OP_ASYNC_CANCEL:
-		ret = io_async_cancel_prep(req);
+		ret = io_async_cancel_prep(req, sqe);
 		break;
 	case IORING_OP_LINK_TIMEOUT:
-		ret = io_timeout_prep(req, io, true);
+		ret = io_timeout_prep(req, sqe, true);
 		break;
 	case IORING_OP_ACCEPT:
-		ret = io_accept_prep(req);
+		ret = io_accept_prep(req, sqe);
 		break;
 	default:
 		printk_once(KERN_WARNING "io_uring: unhandled opcode %d\n",
@@ -3175,7 +3118,7 @@ static int io_req_defer_prep(struct io_kiocb *req)
 	return ret;
 }
 
-static int io_req_defer(struct io_kiocb *req)
+static int io_req_defer(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	int ret;
@@ -3184,10 +3127,10 @@ static int io_req_defer(struct io_kiocb *req)
 	if (!req_need_defer(req) && list_empty(&ctx->defer_list))
 		return 0;
 
-	if (io_alloc_async_ctx(req))
+	if (!req->io && io_alloc_async_ctx(req))
 		return -EAGAIN;
 
-	ret = io_req_defer_prep(req);
+	ret = io_req_defer_prep(req, sqe);
 	if (ret < 0)
 		return ret;
 
@@ -3203,9 +3146,8 @@ static int io_req_defer(struct io_kiocb *req)
 	return -EIOCBQUEUED;
 }
 
-__attribute__((nonnull))
-static int io_issue_sqe(struct io_kiocb *req, struct io_kiocb **nxt,
-			bool force_nonblock)
+static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
+			struct io_kiocb **nxt, bool force_nonblock)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	int ret;
@@ -3215,48 +3157,109 @@ static int io_issue_sqe(struct io_kiocb *req, struct io_kiocb **nxt,
 		ret = io_nop(req);
 		break;
 	case IORING_OP_READV:
-		ret = io_read(req, nxt, force_nonblock);
-		break;
-	case IORING_OP_WRITEV:
-		ret = io_write(req, nxt, force_nonblock);
-		break;
 	case IORING_OP_READ_FIXED:
+		if (sqe) {
+			ret = io_read_prep(req, sqe, force_nonblock);
+			if (ret < 0)
+				break;
+		}
 		ret = io_read(req, nxt, force_nonblock);
 		break;
+	case IORING_OP_WRITEV:
 	case IORING_OP_WRITE_FIXED:
+		if (sqe) {
+			ret = io_write_prep(req, sqe, force_nonblock);
+			if (ret < 0)
+				break;
+		}
 		ret = io_write(req, nxt, force_nonblock);
 		break;
 	case IORING_OP_FSYNC:
+		if (sqe) {
+			ret = io_prep_fsync(req, sqe);
+			if (ret < 0)
+				break;
+		}
 		ret = io_fsync(req, nxt, force_nonblock);
 		break;
 	case IORING_OP_POLL_ADD:
+		if (sqe) {
+			ret = io_poll_add_prep(req, sqe);
+			if (ret)
+				break;
+		}
 		ret = io_poll_add(req, nxt);
 		break;
 	case IORING_OP_POLL_REMOVE:
+		if (sqe) {
+			ret = io_poll_remove_prep(req, sqe);
+			if (ret < 0)
+				break;
+		}
 		ret = io_poll_remove(req);
 		break;
 	case IORING_OP_SYNC_FILE_RANGE:
+		if (sqe) {
+			ret = io_prep_sfr(req, sqe);
+			if (ret < 0)
+				break;
+		}
 		ret = io_sync_file_range(req, nxt, force_nonblock);
 		break;
 	case IORING_OP_SENDMSG:
+		if (sqe) {
+			ret = io_sendmsg_prep(req, sqe);
+			if (ret < 0)
+				break;
+		}
 		ret = io_sendmsg(req, nxt, force_nonblock);
 		break;
 	case IORING_OP_RECVMSG:
+		if (sqe) {
+			ret = io_recvmsg_prep(req, sqe);
+			if (ret)
+				break;
+		}
 		ret = io_recvmsg(req, nxt, force_nonblock);
 		break;
 	case IORING_OP_TIMEOUT:
+		if (sqe) {
+			ret = io_timeout_prep(req, sqe, false);
+			if (ret)
+				break;
+		}
 		ret = io_timeout(req);
 		break;
 	case IORING_OP_TIMEOUT_REMOVE:
+		if (sqe) {
+			ret = io_timeout_remove_prep(req, sqe);
+			if (ret)
+				break;
+		}
 		ret = io_timeout_remove(req);
 		break;
 	case IORING_OP_ACCEPT:
+		if (sqe) {
+			ret = io_accept_prep(req, sqe);
+			if (ret)
+				break;
+		}
 		ret = io_accept(req, nxt, force_nonblock);
 		break;
 	case IORING_OP_CONNECT:
+		if (sqe) {
+			ret = io_connect_prep(req, sqe);
+			if (ret)
+				break;
+		}
 		ret = io_connect(req, nxt, force_nonblock);
 		break;
 	case IORING_OP_ASYNC_CANCEL:
+		if (sqe) {
+			ret = io_async_cancel_prep(req, sqe);
+			if (ret)
+				break;
+		}
 		ret = io_async_cancel(req, nxt);
 		break;
 	default:
@@ -3300,7 +3303,7 @@ static void io_wq_submit_work(struct io_wq_work **workptr)
 		req->has_user = (work->flags & IO_WQ_WORK_HAS_MM) != 0;
 		req->in_async = true;
 		do {
-			ret = io_issue_sqe(req, &nxt, false);
+			ret = io_issue_sqe(req, NULL, &nxt, false);
 			/*
 			 * We can get EAGAIN for polled IO even though we're
 			 * forcing a sync submission from here, since we can't
@@ -3366,14 +3369,15 @@ static inline struct file *io_file_from_index(struct io_ring_ctx *ctx,
 	return table->files[index & IORING_FILE_TABLE_MASK];
 }
 
-static int io_req_set_file(struct io_submit_state *state, struct io_kiocb *req)
+static int io_req_set_file(struct io_submit_state *state, struct io_kiocb *req,
+			   const struct io_uring_sqe *sqe)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	unsigned flags;
 	int fd, ret;
 
-	flags = READ_ONCE(req->sqe->flags);
-	fd = READ_ONCE(req->sqe->fd);
+	flags = READ_ONCE(sqe->flags);
+	fd = READ_ONCE(sqe->fd);
 
 	if (flags & IOSQE_IO_DRAIN)
 		req->flags |= REQ_F_IO_DRAIN;
@@ -3505,7 +3509,7 @@ static struct io_kiocb *io_prep_linked_timeout(struct io_kiocb *req)
 	return nxt;
 }
 
-static void __io_queue_sqe(struct io_kiocb *req)
+static void __io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_kiocb *linked_timeout;
 	struct io_kiocb *nxt = NULL;
@@ -3514,7 +3518,7 @@ static void __io_queue_sqe(struct io_kiocb *req)
 again:
 	linked_timeout = io_prep_linked_timeout(req);
 
-	ret = io_issue_sqe(req, &nxt, true);
+	ret = io_issue_sqe(req, sqe, &nxt, true);
 
 	/*
 	 * We async punt it if the file wasn't marked NOWAIT, or if the file
@@ -3561,7 +3565,7 @@ static void __io_queue_sqe(struct io_kiocb *req)
 	}
 }
 
-static void io_queue_sqe(struct io_kiocb *req)
+static void io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	int ret;
 
@@ -3571,7 +3575,7 @@ static void io_queue_sqe(struct io_kiocb *req)
 	}
 	req->ctx->drain_next = (req->flags & REQ_F_DRAIN_LINK);
 
-	ret = io_req_defer(req);
+	ret = io_req_defer(req, sqe);
 	if (ret) {
 		if (ret != -EIOCBQUEUED) {
 			io_cqring_add_event(req, ret);
@@ -3579,7 +3583,7 @@ static void io_queue_sqe(struct io_kiocb *req)
 			io_double_put_req(req);
 		}
 	} else
-		__io_queue_sqe(req);
+		__io_queue_sqe(req, sqe);
 }
 
 static inline void io_queue_link_head(struct io_kiocb *req)
@@ -3588,25 +3592,25 @@ static inline void io_queue_link_head(struct io_kiocb *req)
 		io_cqring_add_event(req, -ECANCELED);
 		io_double_put_req(req);
 	} else
-		io_queue_sqe(req);
+		io_queue_sqe(req, NULL);
 }
 
 #define SQE_VALID_FLAGS	(IOSQE_FIXED_FILE|IOSQE_IO_DRAIN|IOSQE_IO_LINK|	\
 				IOSQE_IO_HARDLINK)
 
-static bool io_submit_sqe(struct io_kiocb *req, struct io_submit_state *state,
-			  struct io_kiocb **link)
+static bool io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
+			  struct io_submit_state *state, struct io_kiocb **link)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	int ret;
 
 	/* enforce forwards compatibility on users */
-	if (unlikely(req->sqe->flags & ~SQE_VALID_FLAGS)) {
+	if (unlikely(sqe->flags & ~SQE_VALID_FLAGS)) {
 		ret = -EINVAL;
 		goto err_req;
 	}
 
-	ret = io_req_set_file(state, req);
+	ret = io_req_set_file(state, req, sqe);
 	if (unlikely(ret)) {
 err_req:
 		io_cqring_add_event(req, ret);
@@ -3624,10 +3628,10 @@ static bool io_submit_sqe(struct io_kiocb *req, struct io_submit_state *state,
 	if (*link) {
 		struct io_kiocb *prev = *link;
 
-		if (req->sqe->flags & IOSQE_IO_DRAIN)
+		if (sqe->flags & IOSQE_IO_DRAIN)
 			(*link)->flags |= REQ_F_DRAIN_LINK | REQ_F_IO_DRAIN;
 
-		if (req->sqe->flags & IOSQE_IO_HARDLINK)
+		if (sqe->flags & IOSQE_IO_HARDLINK)
 			req->flags |= REQ_F_HARDLINK;
 
 		if (io_alloc_async_ctx(req)) {
@@ -3635,7 +3639,7 @@ static bool io_submit_sqe(struct io_kiocb *req, struct io_submit_state *state,
 			goto err_req;
 		}
 
-		ret = io_req_defer_prep(req);
+		ret = io_req_defer_prep(req, sqe);
 		if (ret) {
 			/* fail even hard links since we don't submit */
 			prev->flags |= REQ_F_FAIL_LINK;
@@ -3643,15 +3647,18 @@ static bool io_submit_sqe(struct io_kiocb *req, struct io_submit_state *state,
 		}
 		trace_io_uring_link(ctx, req, prev);
 		list_add_tail(&req->link_list, &prev->link_list);
-	} else if (req->sqe->flags & (IOSQE_IO_LINK|IOSQE_IO_HARDLINK)) {
+	} else if (sqe->flags & (IOSQE_IO_LINK|IOSQE_IO_HARDLINK)) {
 		req->flags |= REQ_F_LINK;
-		if (req->sqe->flags & IOSQE_IO_HARDLINK)
+		if (sqe->flags & IOSQE_IO_HARDLINK)
 			req->flags |= REQ_F_HARDLINK;
 
 		INIT_LIST_HEAD(&req->link_list);
+		ret = io_req_defer_prep(req, sqe);
+		if (ret)
+			req->flags |= REQ_F_FAIL_LINK;
 		*link = req;
 	} else {
-		io_queue_sqe(req);
+		io_queue_sqe(req, sqe);
 	}
 
 	return true;
@@ -3696,14 +3703,15 @@ static void io_commit_sqring(struct io_ring_ctx *ctx)
 }
 
 /*
- * Fetch an sqe, if one is available. Note that req->sqe will point to memory
+ * Fetch an sqe, if one is available. Note that sqe_ptr will point to memory
  * that is mapped by userspace. This means that care needs to be taken to
  * ensure that reads are stable, as we cannot rely on userspace always
  * being a good citizen. If members of the sqe are validated and then later
  * used, it's important that those reads are done through READ_ONCE() to
  * prevent a re-load down the line.
  */
-static bool io_get_sqring(struct io_ring_ctx *ctx, struct io_kiocb *req)
+static bool io_get_sqring(struct io_ring_ctx *ctx, struct io_kiocb *req,
+			  const struct io_uring_sqe **sqe_ptr)
 {
 	struct io_rings *rings = ctx->rings;
 	u32 *sq_array = ctx->sq_array;
@@ -3730,9 +3738,9 @@ static bool io_get_sqring(struct io_ring_ctx *ctx, struct io_kiocb *req)
 		 * link list.
 		 */
 		req->sequence = ctx->cached_sq_head;
-		req->sqe = &ctx->sq_sqes[head];
-		req->opcode = READ_ONCE(req->sqe->opcode);
-		req->user_data = READ_ONCE(req->sqe->user_data);
+		*sqe_ptr = &ctx->sq_sqes[head];
+		req->opcode = READ_ONCE((*sqe_ptr)->opcode);
+		req->user_data = READ_ONCE((*sqe_ptr)->user_data);
 		ctx->cached_sq_head++;
 		return true;
 	}
@@ -3764,6 +3772,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 	}
 
 	for (i = 0; i < nr; i++) {
+		const struct io_uring_sqe *sqe;
 		struct io_kiocb *req;
 		unsigned int sqe_flags;
 
@@ -3773,7 +3782,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 				submitted = -EAGAIN;
 			break;
 		}
-		if (!io_get_sqring(ctx, req)) {
+		if (!io_get_sqring(ctx, req, &sqe)) {
 			__io_free_req(req);
 			break;
 		}
@@ -3787,7 +3796,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 		}
 
 		submitted++;
-		sqe_flags = req->sqe->flags;
+		sqe_flags = sqe->flags;
 
 		req->ring_file = ring_file;
 		req->ring_fd = ring_fd;
@@ -3795,7 +3804,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 		req->in_async = async;
 		req->needs_fixed_file = async;
 		trace_io_uring_submit_sqe(ctx, req->user_data, true, async);
-		if (!io_submit_sqe(req, statep, &link))
+		if (!io_submit_sqe(req, sqe, statep, &link))
 			break;
 		/*
 		 * If previous wasn't linked and we have a linked command,
-- 
2.24.1

