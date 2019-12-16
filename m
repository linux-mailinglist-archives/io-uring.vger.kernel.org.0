Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63253121044
	for <lists+io-uring@lfdr.de>; Mon, 16 Dec 2019 17:59:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726016AbfLPQ7H (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 Dec 2019 11:59:07 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:33610 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725805AbfLPQ7H (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 Dec 2019 11:59:07 -0500
Received: by mail-io1-f66.google.com with SMTP id z8so5866602ioh.0
        for <io-uring@vger.kernel.org>; Mon, 16 Dec 2019 08:59:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=OqZFhzglQ8gxp5+pSvQjL5aF77NJ0njlES1d35q1Dxg=;
        b=V08RdP7BTlPF4fpXI5QiDmHRWaLZ2Gh7ZFcdKGk4Rp/HpKwT8K8amSFY1qpogFwbPl
         Vw9n1a0MiZaCQthsfnhPzZVOMs88+pzzWR5K7bdHpEy1R8dXVUz/gBxqeo1AmXxlH/g0
         v0Gps8bv6uMQxwU3FpfCys39sCFiniVQH7PWEH+xydciMCQLCm4KekYRCD925/u2U8/U
         fPojUKHCI1HDvpznvyO82e33rJ5w58J7rJ+qdDAOAMjMwlwGGb2a4/2ZXQfbFlLrLfI4
         sRvNoNhK9m9pRYY68x0XzdocxRyq2KzpHbIilUyFrF1t2oChfJBD9UDNZDE5SeyAZry8
         0AJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=OqZFhzglQ8gxp5+pSvQjL5aF77NJ0njlES1d35q1Dxg=;
        b=K1RVcUx4hamMdaj7AE01mMo+rnMnpAklKcGu0UEoDyPB6U8TYZ5Kr+Ybm+87G4CHJs
         Mb6vyE9WjWyszuqRcZkvizoDw1Fs42/NBmw7teULxL1wC4c60NYOhkqxsBCFDz0Y9Ryz
         B44AjDwDR1kg+btYO2jwKFI8MPaMDJti/x+1Ox6x7BK83zDcOeDzeqsA2yUZXN/LxdZ+
         6+TqXs6NjvyPj67rwb90hHGFByABBemgaX5Srf2WsVCId43Z2ZTgoVEV96kFsPsSJwnC
         TfRvldg8tVyUTr6DNme/x9i3aHZ/k0kipZe4Gy5O5latkc7CzNfUfKX4+NZNz/Xk67JE
         toKg==
X-Gm-Message-State: APjAAAVbvDhENv2ZwL7H+s0XKXVj9X3Imf3sao+bxBP6YAcofZ4WqdEX
        OmDhCGAWQkJoLNO/q2y0sNRr5wGRwyWKDA==
X-Google-Smtp-Source: APXvYqyEdk0i0fdYVHLrCgdncZHOQJ4Uq6NhzJiPWcAbKgskWFAlu7nv8TB1gYGy0c/XIz1WLmSWOQ==
X-Received: by 2002:a5d:84d2:: with SMTP id z18mr126190ior.81.1576515545517;
        Mon, 16 Dec 2019 08:59:05 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id y11sm4509165iol.23.2019.12.16.08.59.04
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Dec 2019 08:59:05 -0800 (PST)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v2] io_uring: fix pre-prepped issue with force_nonblock ==
 true
Message-ID: <f8730b8d-eae2-d123-d776-94a5993a8ebb@kernel.dk>
Date:   Mon, 16 Dec 2019 09:59:04 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
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

Finally, add an async context ->free_req() to handle the case where a
request is cancelled. We still need to free private data outside of
req->io for that case. To avoid the indirect free call for the fast
path, do the free manually and clear ->free_req() for that case.

Fixes: 03b1230ca12a ("io_uring: ensure async punted sendmsg/recvmsg requests copy data")
Fixes: f67676d160c6 ("io_uring: ensure async punted read/write requests copy iovec")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

V2:
- various fixes and cleanups.
- fix missing free of deferred private data

This is bigger than I'd like, but I think it's worth doing to clean
up the async punt path.

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 0085cf86dbd8..ff89fde0c606 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -324,6 +324,7 @@ struct io_async_rw {
 
 struct io_async_ctx {
 	struct io_uring_sqe		sqe;
+	void (*free_req)(struct io_kiocb *);
 	union {
 		struct io_async_rw	rw;
 		struct io_async_msghdr	msg;
@@ -879,8 +880,11 @@ static void __io_free_req(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 
-	if (req->io)
+	if (req->io) {
+		if (req->io->free_req)
+			req->io->free_req(req);
 		kfree(req->io);
+	}
 	if (req->file && !(req->flags & REQ_F_FIXED_FILE))
 		fput(req->file);
 	if (req->flags & REQ_F_INFLIGHT) {
@@ -1701,7 +1705,7 @@ static ssize_t loop_rw_iter(int rw, struct file *file, struct kiocb *kiocb,
 	return ret;
 }
 
-static void io_req_map_io(struct io_kiocb *req, ssize_t io_size,
+static void io_req_map_rw(struct io_kiocb *req, ssize_t io_size,
 			  struct iovec *iovec, struct iovec *fast_iov,
 			  struct iov_iter *iter)
 {
@@ -1715,19 +1719,35 @@ static void io_req_map_io(struct io_kiocb *req, ssize_t io_size,
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
+		req->io->free_req = NULL;
 		return 0;
 	}
 
-	return -ENOMEM;
+	return 1;
+}
+
+static void io_rw_free_req(struct io_kiocb *req)
+{
+	if (req->io->rw.iov != req->io->rw.fast_iov)
+		kfree(req->io->rw.iov);
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
+	req->io->free_req = io_rw_free_req;
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
@@ -1815,6 +1835,8 @@ static int io_read(struct io_kiocb *req, struct io_kiocb **nxt,
 	}
 out_free:
 	kfree(iovec);
+	if (req->io)
+		req->io->free_req = NULL;
 	return ret;
 }
 
@@ -1900,7 +1922,7 @@ static int io_write(struct io_kiocb *req, struct io_kiocb **nxt,
 			kiocb_done(kiocb, ret2, nxt, req->in_async);
 		} else {
 copy_iov:
-			ret = io_setup_async_io(req, io_size, iovec,
+			ret = io_setup_async_rw(req, io_size, iovec,
 						inline_vecs, &iter);
 			if (ret)
 				goto out_free;
@@ -1909,6 +1931,8 @@ static int io_write(struct io_kiocb *req, struct io_kiocb **nxt,
 	}
 out_free:
 	kfree(iovec);
+	if (req->io)
+		req->io->free_req = NULL;
 	return ret;
 }
 
@@ -2021,6 +2045,12 @@ static int io_sync_file_range(struct io_kiocb *req,
 	return 0;
 }
 
+static void io_sendrecv_msg_free(struct io_kiocb *req)
+{
+	if (req->io->msg.iov != req->io->msg.fast_iov)
+		kfree(req->io->msg.iov);
+}
+
 static int io_sendmsg_prep(struct io_kiocb *req, struct io_async_ctx *io)
 {
 #if defined(CONFIG_NET)
@@ -2050,7 +2080,7 @@ static int io_sendmsg(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 
 	sock = sock_from_file(req->file, &ret);
 	if (sock) {
-		struct io_async_ctx io, *copy;
+		struct io_async_ctx io;
 		struct sockaddr_storage addr;
 		unsigned flags;
 
@@ -2077,15 +2107,12 @@ static int io_sendmsg(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 
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
+			req->io->free_req = io_sendrecv_msg_free;
 			return -EAGAIN;
 		}
 		if (ret == -ERESTARTSYS)
@@ -2095,6 +2122,8 @@ static int io_sendmsg(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 out:
 	if (kmsg && kmsg->iov != kmsg->fast_iov)
 		kfree(kmsg->iov);
+	if (req->io)
+		req->io->free_req = NULL;
 	io_cqring_add_event(req, ret);
 	if (ret < 0)
 		req_set_fail_links(req);
@@ -2136,7 +2165,7 @@ static int io_recvmsg(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	sock = sock_from_file(req->file, &ret);
 	if (sock) {
 		struct user_msghdr __user *msg;
-		struct io_async_ctx io, *copy;
+		struct io_async_ctx io;
 		struct sockaddr_storage addr;
 		unsigned flags;
 
@@ -2165,15 +2194,12 @@ static int io_recvmsg(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 
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
+			req->io->free_req = io_sendrecv_msg_free;
 			return -EAGAIN;
 		}
 		if (ret == -ERESTARTSYS)
@@ -2183,6 +2209,8 @@ static int io_recvmsg(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 out:
 	if (kmsg && kmsg->iov != kmsg->fast_iov)
 		kfree(kmsg->iov);
+	if (req->io)
+		req->io->free_req = NULL;
 	io_cqring_add_event(req, ret);
 	if (ret < 0)
 		req_set_fail_links(req);
@@ -2272,15 +2300,13 @@ static int io_connect(struct io_kiocb *req, const struct io_uring_sqe *sqe,
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
@@ -2511,7 +2537,6 @@ static int io_poll_add(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	if (!poll->file)
 		return -EBADF;
 
-	req->io = NULL;
 	INIT_IO_WORK(&req->work, io_poll_complete_work);
 	events = READ_ONCE(sqe->poll_events);
 	poll->events = demangle_poll(events) | EPOLLERR | EPOLLHUP;
@@ -2692,7 +2717,6 @@ static int io_timeout_prep(struct io_kiocb *req, struct io_async_ctx *io,
 		data->mode = HRTIMER_MODE_REL;
 
 	hrtimer_init(&data->timer, CLOCK_MONOTONIC, data->mode);
-	req->io = io;
 	return 0;
 }
 
@@ -2701,22 +2725,16 @@ static int io_timeout(struct io_kiocb *req, const struct io_uring_sqe *sqe)
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
 
@@ -2858,23 +2876,35 @@ static int io_async_cancel(struct io_kiocb *req, const struct io_uring_sqe *sqe,
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
@@ -2886,41 +2916,34 @@ static int io_req_defer_prep(struct io_kiocb *req, struct io_async_ctx *io)
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
@@ -3366,7 +3389,6 @@ static bool io_submit_sqe(struct io_kiocb *req, struct io_submit_state *state,
 	 */
 	if (*link) {
 		struct io_kiocb *prev = *link;
-		struct io_async_ctx *io;
 
 		if (req->sqe->flags & IOSQE_IO_DRAIN)
 			(*link)->flags |= REQ_F_DRAIN_LINK | REQ_F_IO_DRAIN;
@@ -3374,15 +3396,13 @@ static bool io_submit_sqe(struct io_kiocb *req, struct io_submit_state *state,
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
Jens Axboe

