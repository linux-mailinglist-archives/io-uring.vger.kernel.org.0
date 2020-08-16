Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13424245533
	for <lists+io-uring@lfdr.de>; Sun, 16 Aug 2020 03:44:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728796AbgHPBoN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 15 Aug 2020 21:44:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728774AbgHPBoM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 15 Aug 2020 21:44:12 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BC94C061786
        for <io-uring@vger.kernel.org>; Sat, 15 Aug 2020 18:44:12 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id t6so6016205pjr.0
        for <io-uring@vger.kernel.org>; Sat, 15 Aug 2020 18:44:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=EMPCgnFp3k4zf8DBYHwxenbSK9kKwDCP7jo8BbFQtRo=;
        b=Vpan/CH0jFmZTq/1Y6YGrctZlu7wgeICIoF73ZDVnGwjHvZKMbR4BVEy6FTeqkiJIH
         vFPa8bnS2GbLSlxlzmQRVno9xuD0IKCzH2JT8hDYwgur6mg0i3zfB7Wy0SyuzDrnLHXi
         KMJNRhz5F8koutnLSrv5PPhZ261kExxxrdZvgcianMxNDSrKrXTS5Z/yTKMqvLUYDuNl
         zooYOjk0n4VtjFYkvKZVxGVZ3oAa1G7XaRmYOAa9GA0F2rymQZaMCL4tJ6QIuL0b5rwq
         Q/C9W63Poa4zN9ASk4b8CIFjQQKoD8fUyCVxiilQUcGH5mZDGj0LeGGtCYj4RTrulxq0
         IQRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=EMPCgnFp3k4zf8DBYHwxenbSK9kKwDCP7jo8BbFQtRo=;
        b=iMLSDMlFT5LwXp+D1qbnkZUohJt4fNFD2CTuYLDiR+GsP53dBLgkQIrZgFc0UsjryW
         7lXzJYnDlytQAk8Teglv1X9F+0iwSpOIv/VVyFq0KX+I6+PuRI3yjnjr/dj2L8L3cEkt
         O66el6Z235/naFBM0qnHi5pDYi4+gjLHTgzeZTwL+zYjlzv8qzAi50eKveuV6B7Nx6IX
         oq/dTMIPolN7zBslV8c3HJqNFprIz68vAKXHBZUNOEiK2zK7SclTlgJmsyUx+G3KXItE
         HWo5TcnV6zj46Vwg/CqX83tLo8/KDT0SxVBYE1KzKSXLL1mfHDIUExe4G1utNGoasLeq
         RzWg==
X-Gm-Message-State: AOAM531e7sd8hS4tmKCeNSL0s1SzkXYlxLm7FV+Y7GNPXTEVF6lvjGQX
        FfVYsmRBeTAq4qgGQXyFY+km62a9kYzO1g==
X-Google-Smtp-Source: ABdhPJxwvK9nDNNrjPQkUA2Y2X5qs7saNzlpElUjPaBVDYGBh5VH9QxRoaQSDfk3Tz5+aQkjoVKTRw==
X-Received: by 2002:a17:90a:2169:: with SMTP id a96mr7119399pje.132.1597542251461;
        Sat, 15 Aug 2020 18:44:11 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:6299:2df1:e468:6351? ([2605:e000:100e:8c61:6299:2df1:e468:6351])
        by smtp.gmail.com with ESMTPSA id a17sm13467761pfk.29.2020.08.15.18.44.10
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 15 Aug 2020 18:44:10 -0700 (PDT)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH for-next] io_uring: get rid of req->io/io_async_ctx union
Message-ID: <9ff8c154-881e-4f38-eb1a-fb26a87821f0@kernel.dk>
Date:   Sat, 15 Aug 2020 18:44:09 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


There's really no point in having this union, it just means that we're
always allocating enough room to cater to any command. But that's
pointless, as the ->io field is request type private anyway.

This gets rid of the io_async_ctx structure, and fills in the required
size in the io_op_defs[] instead.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

I wanted to get rid of ->needs_async_data (which used to be ->async_ctx)
in the io_op_defs, but with the retry code, we have a case where a
command (like a read/read-fixed, ditto writes) will need async_data
setup even if it doesn't usually. This means that we need both a size
field and a 'usually needs it' flag like we had before as well.
Alternatively, we could pass in the size to the alloc function instead.
We have 3 bits left in io_op_defs as it stands after this patch, which
is probably fine... So I preferred this approach.

diff --git a/fs/io_uring.c b/fs/io_uring.c
index dc506b75659c..bdfedabdc2ea 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -514,15 +514,6 @@ struct io_async_rw {
 	struct wait_page_queue		wpq;
 };
 
-struct io_async_ctx {
-	union {
-		struct io_async_rw	rw;
-		struct io_async_msghdr	msg;
-		struct io_async_connect	connect;
-		struct io_timeout_data	timeout;
-	};
-};
-
 enum {
 	REQ_F_FIXED_FILE_BIT	= IOSQE_FIXED_FILE_BIT,
 	REQ_F_IO_DRAIN_BIT	= IOSQE_IO_DRAIN_BIT,
@@ -632,7 +623,8 @@ struct io_kiocb {
 		struct io_completion	compl;
 	};
 
-	struct io_async_ctx		*io;
+	/* opcode allocated if it needs to store data for async defer */
+	void				*async_data;
 	u8				opcode;
 	/* polled IO has completed */
 	u8				iopoll_completed;
@@ -700,8 +692,6 @@ struct io_submit_state {
 };
 
 struct io_op_def {
-	/* needs req->io allocated for deferral/async */
-	unsigned		async_ctx : 1;
 	/* needs current->mm setup, does mm access */
 	unsigned		needs_mm : 1;
 	/* needs req->file assigned */
@@ -723,27 +713,34 @@ struct io_op_def {
 	unsigned		pollout : 1;
 	/* op supports buffer selection */
 	unsigned		buffer_select : 1;
+	/* needs rlimit(RLIMIT_FSIZE) assigned */
 	unsigned		needs_fsize : 1;
+	/* must always have async data allocated */
+	unsigned		needs_async_data : 1;
+	/* size of async data needed, if any */
+	unsigned short		async_size;
 };
 
 static const struct io_op_def io_op_defs[] = {
 	[IORING_OP_NOP] = {},
 	[IORING_OP_READV] = {
-		.async_ctx		= 1,
 		.needs_mm		= 1,
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
 		.pollin			= 1,
 		.buffer_select		= 1,
+		.needs_async_data	= 1,
+		.async_size		= sizeof(struct io_async_rw),
 	},
 	[IORING_OP_WRITEV] = {
-		.async_ctx		= 1,
 		.needs_mm		= 1,
 		.needs_file		= 1,
 		.hash_reg_file		= 1,
 		.unbound_nonreg_file	= 1,
 		.pollout		= 1,
 		.needs_fsize		= 1,
+		.needs_async_data	= 1,
+		.async_size		= sizeof(struct io_async_rw),
 	},
 	[IORING_OP_FSYNC] = {
 		.needs_file		= 1,
@@ -752,6 +749,7 @@ static const struct io_op_def io_op_defs[] = {
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
 		.pollin			= 1,
+		.async_size		= sizeof(struct io_async_rw),
 	},
 	[IORING_OP_WRITE_FIXED] = {
 		.needs_file		= 1,
@@ -759,6 +757,7 @@ static const struct io_op_def io_op_defs[] = {
 		.unbound_nonreg_file	= 1,
 		.pollout		= 1,
 		.needs_fsize		= 1,
+		.async_size		= sizeof(struct io_async_rw),
 	},
 	[IORING_OP_POLL_ADD] = {
 		.needs_file		= 1,
@@ -769,25 +768,28 @@ static const struct io_op_def io_op_defs[] = {
 		.needs_file		= 1,
 	},
 	[IORING_OP_SENDMSG] = {
-		.async_ctx		= 1,
 		.needs_mm		= 1,
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
 		.needs_fs		= 1,
 		.pollout		= 1,
+		.needs_async_data	= 1,
+		.async_size		= sizeof(struct io_async_msghdr),
 	},
 	[IORING_OP_RECVMSG] = {
-		.async_ctx		= 1,
 		.needs_mm		= 1,
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
 		.needs_fs		= 1,
 		.pollin			= 1,
 		.buffer_select		= 1,
+		.needs_async_data	= 1,
+		.async_size		= sizeof(struct io_async_msghdr),
 	},
 	[IORING_OP_TIMEOUT] = {
-		.async_ctx		= 1,
 		.needs_mm		= 1,
+		.needs_async_data	= 1,
+		.async_size		= sizeof(struct io_timeout_data),
 	},
 	[IORING_OP_TIMEOUT_REMOVE] = {},
 	[IORING_OP_ACCEPT] = {
@@ -799,15 +801,17 @@ static const struct io_op_def io_op_defs[] = {
 	},
 	[IORING_OP_ASYNC_CANCEL] = {},
 	[IORING_OP_LINK_TIMEOUT] = {
-		.async_ctx		= 1,
 		.needs_mm		= 1,
+		.needs_async_data	= 1,
+		.async_size		= sizeof(struct io_timeout_data),
 	},
 	[IORING_OP_CONNECT] = {
-		.async_ctx		= 1,
 		.needs_mm		= 1,
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
 		.pollout		= 1,
+		.needs_async_data	= 1,
+		.async_size		= sizeof(struct io_async_connect),
 	},
 	[IORING_OP_FALLOCATE] = {
 		.needs_file		= 1,
@@ -837,6 +841,7 @@ static const struct io_op_def io_op_defs[] = {
 		.unbound_nonreg_file	= 1,
 		.pollin			= 1,
 		.buffer_select		= 1,
+		.async_size		= sizeof(struct io_async_rw),
 	},
 	[IORING_OP_WRITE] = {
 		.needs_mm		= 1,
@@ -844,6 +849,7 @@ static const struct io_op_def io_op_defs[] = {
 		.unbound_nonreg_file	= 1,
 		.pollout		= 1,
 		.needs_fsize		= 1,
+		.async_size		= sizeof(struct io_async_rw),
 	},
 	[IORING_OP_FADVISE] = {
 		.needs_file		= 1,
@@ -1215,9 +1221,10 @@ static void io_queue_async_work(struct io_kiocb *req)
 
 static void io_kill_timeout(struct io_kiocb *req)
 {
+	struct io_timeout_data *io = req->async_data;
 	int ret;
 
-	ret = hrtimer_try_to_cancel(&req->io->timeout.timer);
+	ret = hrtimer_try_to_cancel(&io->timer);
 	if (ret != -1) {
 		atomic_set(&req->ctx->cq_timeouts,
 			atomic_read(&req->ctx->cq_timeouts) + 1);
@@ -1558,8 +1565,8 @@ static bool io_dismantle_req(struct io_kiocb *req)
 {
 	io_clean_op(req);
 
-	if (req->io)
-		kfree(req->io);
+	if (req->async_data)
+		kfree(req->async_data);
 	if (req->file)
 		io_put_file(req, req->file, (req->flags & REQ_F_FIXED_FILE));
 
@@ -1624,10 +1631,11 @@ static void __io_free_req(struct io_kiocb *req)
 
 static bool io_link_cancel_timeout(struct io_kiocb *req)
 {
+	struct io_timeout_data *io = req->async_data;
 	struct io_ring_ctx *ctx = req->ctx;
 	int ret;
 
-	ret = hrtimer_try_to_cancel(&req->io->timeout.timer);
+	ret = hrtimer_try_to_cancel(&io->timer);
 	if (ret != -1) {
 		io_cqring_fill_event(req, -ECANCELED);
 		io_commit_cqring(ctx);
@@ -2588,13 +2596,14 @@ static void kiocb_done(struct kiocb *kiocb, ssize_t ret,
 		       struct io_comp_state *cs)
 {
 	struct io_kiocb *req = container_of(kiocb, struct io_kiocb, rw.kiocb);
+	struct io_async_rw *io = req->async_data;
 
 	/* add previously done IO, if any */
-	if (req->io && req->io->rw.bytes_done > 0) {
+	if (io && io->bytes_done > 0) {
 		if (ret < 0)
-			ret = req->io->rw.bytes_done;
+			ret = io->bytes_done;
 		else
-			ret += req->io->rw.bytes_done;
+			ret += io->bytes_done;
 	}
 
 	if (req->flags & REQ_F_CUR_POS)
@@ -2828,8 +2837,8 @@ static ssize_t io_import_iovec(int rw, struct io_kiocb *req,
 	ssize_t ret;
 	u8 opcode;
 
-	if (req->io) {
-		struct io_async_rw *iorw = &req->io->rw;
+	if (req->async_data) {
+		struct io_async_rw *iorw = req->async_data;
 
 		*iovec = NULL;
 		return iov_iter_count(&iorw->iter);
@@ -2940,7 +2949,7 @@ static ssize_t loop_rw_iter(int rw, struct file *file, struct kiocb *kiocb,
 static void io_req_map_rw(struct io_kiocb *req, const struct iovec *iovec,
 			  const struct iovec *fast_iov, struct iov_iter *iter)
 {
-	struct io_async_rw *rw = &req->io->rw;
+	struct io_async_rw *rw = req->async_data;
 
 	memcpy(&rw->iter, iter, sizeof(*iter));
 	rw->free_iovec = NULL;
@@ -2965,28 +2974,29 @@ static void io_req_map_rw(struct io_kiocb *req, const struct iovec *iovec,
 	}
 }
 
-static inline int __io_alloc_async_ctx(struct io_kiocb *req)
+static inline int __io_alloc_async_data(struct io_kiocb *req)
 {
-	req->io = kmalloc(sizeof(*req->io), GFP_KERNEL);
-	return req->io == NULL;
+	WARN_ON_ONCE(!io_op_defs[req->opcode].async_size);
+	req->async_data = kmalloc(io_op_defs[req->opcode].async_size, GFP_KERNEL);
+	return req->async_data == NULL;
 }
 
-static int io_alloc_async_ctx(struct io_kiocb *req)
+static int io_alloc_async_data(struct io_kiocb *req)
 {
-	if (!io_op_defs[req->opcode].async_ctx)
+	if (!io_op_defs[req->opcode].needs_async_data)
 		return 0;
 
-	return  __io_alloc_async_ctx(req);
+	return  __io_alloc_async_data(req);
 }
 
 static int io_setup_async_rw(struct io_kiocb *req, const struct iovec *iovec,
 			     const struct iovec *fast_iov,
 			     struct iov_iter *iter, bool force)
 {
-	if (!force && !io_op_defs[req->opcode].async_ctx)
+	if (!force && !io_op_defs[req->opcode].needs_async_data)
 		return 0;
-	if (!req->io) {
-		if (__io_alloc_async_ctx(req))
+	if (!req->async_data) {
+		if (__io_alloc_async_data(req))
 			return -ENOMEM;
 
 		io_req_map_rw(req, iovec, fast_iov, iter);
@@ -2997,15 +3007,15 @@ static int io_setup_async_rw(struct io_kiocb *req, const struct iovec *iovec,
 static inline int io_rw_prep_async(struct io_kiocb *req, int rw,
 				   bool force_nonblock)
 {
-	struct io_async_rw *iorw = &req->io->rw;
+	struct io_async_rw *iorw = req->async_data;
 	ssize_t ret;
 
 	iorw->iter.iov = iorw->fast_iov;
-	/* reset ->io around the iovec import, we don't want to use it */
-	req->io = NULL;
+	/* reset ->async_data around the iovec import, we don't want to use it */
+	req->async_data = NULL;
 	ret = io_import_iovec(rw, req, (struct iovec **) &iorw->iter.iov,
 				&iorw->iter, !force_nonblock);
-	req->io = container_of(iorw, struct io_async_ctx, rw);
+	req->async_data = iorw;
 	if (unlikely(ret < 0))
 		return ret;
 
@@ -3026,7 +3036,7 @@ static int io_read_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 		return -EBADF;
 
 	/* either don't need iovec imported or already have it */
-	if (!req->io || req->flags & REQ_F_NEED_CLEANUP)
+	if (!req->async_data || req->flags & REQ_F_NEED_CLEANUP)
 		return 0;
 	return io_rw_prep_async(req, READ, force_nonblock);
 }
@@ -3109,6 +3119,7 @@ static inline int kiocb_wait_page_queue_init(struct kiocb *kiocb,
  */
 static bool io_rw_should_retry(struct io_kiocb *req)
 {
+	struct io_async_rw *rw = req->async_data;
 	struct kiocb *kiocb = &req->rw.kiocb;
 	int ret;
 
@@ -3126,8 +3137,7 @@ static bool io_rw_should_retry(struct io_kiocb *req)
 	if (file_can_poll(req->file) || !(req->file->f_mode & FMODE_BUF_RASYNC))
 		return false;
 
-	ret = kiocb_wait_page_queue_init(kiocb, &req->io->rw.wpq,
-						io_async_buf_func, req);
+	ret = kiocb_wait_page_queue_init(kiocb, &rw->wpq, io_async_buf_func, req);
 	if (!ret) {
 		io_get_req_task(req);
 		return true;
@@ -3152,11 +3162,12 @@ static int io_read(struct io_kiocb *req, bool force_nonblock,
 	struct iovec inline_vecs[UIO_FASTIOV], *iovec = inline_vecs;
 	struct kiocb *kiocb = &req->rw.kiocb;
 	struct iov_iter __iter, *iter = &__iter;
+	struct io_async_rw *rw = req->async_data;
 	ssize_t io_size, ret, ret2;
 	size_t iov_count;
 
-	if (req->io)
-		iter = &req->io->rw.iter;
+	if (rw)
+		iter = &rw->iter;
 
 	ret = io_import_iovec(READ, req, &iovec, iter, !force_nonblock);
 	if (ret < 0)
@@ -3208,12 +3219,13 @@ static int io_read(struct io_kiocb *req, bool force_nonblock,
 		ret = ret2;
 		goto out_free;
 	}
+	rw = req->async_data;
 	/* it's copied and will be cleaned with ->io */
 	iovec = NULL;
 	/* now use our persistent iterator, if we aren't already */
-	iter = &req->io->rw.iter;
+	iter = &rw->iter;
 retry:
-	req->io->rw.bytes_done += ret;
+	rw->bytes_done += ret;
 	/* if we can retry, do so with the callbacks armed */
 	if (!io_rw_should_retry(req)) {
 		kiocb->ki_flags &= ~IOCB_WAITQ;
@@ -3256,7 +3268,7 @@ static int io_write_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 		return -EBADF;
 
 	/* either don't need iovec imported or already have it */
-	if (!req->io || req->flags & REQ_F_NEED_CLEANUP)
+	if (!req->async_data || req->flags & REQ_F_NEED_CLEANUP)
 		return 0;
 	return io_rw_prep_async(req, WRITE, force_nonblock);
 }
@@ -3267,11 +3279,12 @@ static int io_write(struct io_kiocb *req, bool force_nonblock,
 	struct iovec inline_vecs[UIO_FASTIOV], *iovec = inline_vecs;
 	struct kiocb *kiocb = &req->rw.kiocb;
 	struct iov_iter __iter, *iter = &__iter;
+	struct io_async_rw *rw = req->async_data;
 	size_t iov_count;
 	ssize_t ret, ret2, io_size;
 
-	if (req->io)
-		iter = &req->io->rw.iter;
+	if (rw)
+		iter = &rw->iter;
 
 	ret = io_import_iovec(WRITE, req, &iovec, iter, !force_nonblock);
 	if (ret < 0)
@@ -4037,15 +4050,18 @@ static int io_sync_file_range(struct io_kiocb *req, bool force_nonblock)
 static int io_setup_async_msg(struct io_kiocb *req,
 			      struct io_async_msghdr *kmsg)
 {
-	if (req->io)
+	struct io_async_msghdr *async_msg = req->async_data;
+
+	if (async_msg)
 		return -EAGAIN;
-	if (io_alloc_async_ctx(req)) {
+	if (io_alloc_async_data(req)) {
 		if (kmsg->iov != kmsg->fast_iov)
 			kfree(kmsg->iov);
 		return -ENOMEM;
 	}
+	async_msg = req->async_data;
 	req->flags |= REQ_F_NEED_CLEANUP;
-	memcpy(&req->io->msg, kmsg, sizeof(*kmsg));
+	memcpy(async_msg, kmsg, sizeof(*kmsg));
 	return -EAGAIN;
 }
 
@@ -4060,8 +4076,8 @@ static int io_sendmsg_copy_hdr(struct io_kiocb *req,
 
 static int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
+	struct io_async_msghdr *async_msg = req->async_data;
 	struct io_sr_msg *sr = &req->sr_msg;
-	struct io_async_ctx *io = req->io;
 	int ret;
 
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
@@ -4076,13 +4092,13 @@ static int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		sr->msg_flags |= MSG_CMSG_COMPAT;
 #endif
 
-	if (!io || req->opcode == IORING_OP_SEND)
+	if (!async_msg || !io_op_defs[req->opcode].needs_async_data)
 		return 0;
 	/* iovec is already imported */
 	if (req->flags & REQ_F_NEED_CLEANUP)
 		return 0;
 
-	ret = io_sendmsg_copy_hdr(req, &io->msg);
+	ret = io_sendmsg_copy_hdr(req, async_msg);
 	if (!ret)
 		req->flags |= REQ_F_NEED_CLEANUP;
 	return ret;
@@ -4100,9 +4116,9 @@ static int io_sendmsg(struct io_kiocb *req, bool force_nonblock,
 	if (unlikely(!sock))
 		return ret;
 
-	if (req->io) {
-		kmsg = &req->io->msg;
-		kmsg->msg.msg_name = &req->io->msg.addr;
+	if (req->async_data) {
+		kmsg = req->async_data;
+		kmsg->msg.msg_name = &kmsg->addr;
 		/* if iov is set, it's allocated already */
 		if (!kmsg->iov)
 			kmsg->iov = kmsg->fast_iov;
@@ -4289,8 +4305,8 @@ static inline unsigned int io_put_recv_kbuf(struct io_kiocb *req)
 static int io_recvmsg_prep(struct io_kiocb *req,
 			   const struct io_uring_sqe *sqe)
 {
+	struct io_async_msghdr *async_msg = req->async_data;
 	struct io_sr_msg *sr = &req->sr_msg;
-	struct io_async_ctx *io = req->io;
 	int ret;
 
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
@@ -4306,13 +4322,13 @@ static int io_recvmsg_prep(struct io_kiocb *req,
 		sr->msg_flags |= MSG_CMSG_COMPAT;
 #endif
 
-	if (!io || req->opcode == IORING_OP_RECV)
+	if (!async_msg || !io_op_defs[req->opcode].needs_async_data)
 		return 0;
 	/* iovec is already imported */
 	if (req->flags & REQ_F_NEED_CLEANUP)
 		return 0;
 
-	ret = io_recvmsg_copy_hdr(req, &io->msg);
+	ret = io_recvmsg_copy_hdr(req, async_msg);
 	if (!ret)
 		req->flags |= REQ_F_NEED_CLEANUP;
 	return ret;
@@ -4331,9 +4347,9 @@ static int io_recvmsg(struct io_kiocb *req, bool force_nonblock,
 	if (unlikely(!sock))
 		return ret;
 
-	if (req->io) {
-		kmsg = &req->io->msg;
-		kmsg->msg.msg_name = &req->io->msg.addr;
+	if (req->async_data) {
+		kmsg = req->async_data;
+		kmsg->msg.msg_name = &kmsg->addr;
 		/* if iov is set, it's allocated already */
 		if (!kmsg->iov)
 			kmsg->iov = kmsg->fast_iov;
@@ -4475,7 +4491,7 @@ static int io_accept(struct io_kiocb *req, bool force_nonblock,
 static int io_connect_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_connect *conn = &req->connect;
-	struct io_async_ctx *io = req->io;
+	struct io_async_connect *io = req->async_data;
 
 	if (unlikely(req->ctx->flags & (IORING_SETUP_IOPOLL|IORING_SETUP_SQPOLL)))
 		return -EINVAL;
@@ -4489,22 +4505,22 @@ static int io_connect_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return 0;
 
 	return move_addr_to_kernel(conn->addr, conn->addr_len,
-					&io->connect.address);
+					&io->address);
 }
 
 static int io_connect(struct io_kiocb *req, bool force_nonblock,
 		      struct io_comp_state *cs)
 {
-	struct io_async_ctx __io, *io;
+	struct io_async_connect __io, *io;
 	unsigned file_flags;
 	int ret;
 
-	if (req->io) {
-		io = req->io;
+	if (req->async_data) {
+		io = req->async_data;
 	} else {
 		ret = move_addr_to_kernel(req->connect.addr,
 						req->connect.addr_len,
-						&__io.connect.address);
+						&__io.address);
 		if (ret)
 			goto out;
 		io = &__io;
@@ -4512,16 +4528,17 @@ static int io_connect(struct io_kiocb *req, bool force_nonblock,
 
 	file_flags = force_nonblock ? O_NONBLOCK : 0;
 
-	ret = __sys_connect_file(req->file, &io->connect.address,
+	ret = __sys_connect_file(req->file, &io->address,
 					req->connect.addr_len, file_flags);
 	if ((ret == -EAGAIN || ret == -EINPROGRESS) && force_nonblock) {
-		if (req->io)
+		if (req->async_data)
 			return -EAGAIN;
-		if (io_alloc_async_ctx(req)) {
+		if (io_alloc_async_data(req)) {
 			ret = -ENOMEM;
 			goto out;
 		}
-		memcpy(&req->io->connect, &__io.connect, sizeof(__io.connect));
+		io = req->async_data;
+		memcpy(req->async_data, &__io, sizeof(__io));
 		return -EAGAIN;
 	}
 	if (ret == -ERESTARTSYS)
@@ -4654,9 +4671,9 @@ static bool io_poll_rewait(struct io_kiocb *req, struct io_poll_iocb *poll)
 
 static struct io_poll_iocb *io_poll_get_double(struct io_kiocb *req)
 {
-	/* pure poll stashes this in ->io, poll driven retry elsewhere */
+	/* pure poll stashes this in ->async_data, poll driven retry elsewhere */
 	if (req->opcode == IORING_OP_POLL_ADD)
-		return (struct io_poll_iocb *) req->io;
+		return req->async_data;
 	return req->apoll->double_poll;
 }
 
@@ -5083,7 +5100,7 @@ static void io_poll_queue_proc(struct file *file, struct wait_queue_head *head,
 {
 	struct io_poll_table *pt = container_of(p, struct io_poll_table, pt);
 
-	__io_queue_proc(&pt->req->poll, pt, head, (struct io_poll_iocb **) &pt->req->io);
+	__io_queue_proc(&pt->req->poll, pt, head, (struct io_poll_iocb **) &pt->req->async_data);
 }
 
 static int io_poll_add_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
@@ -5166,11 +5183,12 @@ static enum hrtimer_restart io_timeout_fn(struct hrtimer *timer)
 
 static int __io_timeout_cancel(struct io_kiocb *req)
 {
+	struct io_timeout_data *io = req->async_data;
 	int ret;
 
 	list_del_init(&req->timeout.list);
 
-	ret = hrtimer_try_to_cancel(&req->io->timeout.timer);
+	ret = hrtimer_try_to_cancel(&io->timer);
 	if (ret == -1)
 		return -EALREADY;
 
@@ -5257,10 +5275,10 @@ static int io_timeout_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 
 	req->timeout.off = off;
 
-	if (!req->io && io_alloc_async_ctx(req))
+	if (!req->async_data && io_alloc_async_data(req))
 		return -ENOMEM;
 
-	data = &req->io->timeout;
+	data = req->async_data;
 	data->req = req;
 
 	if (get_timespec64(&data->ts, u64_to_user_ptr(sqe->addr)))
@@ -5278,7 +5296,7 @@ static int io_timeout_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 static int io_timeout(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
-	struct io_timeout_data *data = &req->io->timeout;
+	struct io_timeout_data *data = req->async_data;
 	struct list_head *entry;
 	u32 tail, off = req->timeout.off;
 
@@ -5447,7 +5465,7 @@ static int io_req_defer_prep(struct io_kiocb *req,
 	if (!sqe)
 		return 0;
 
-	if (io_alloc_async_ctx(req))
+	if (io_alloc_async_data(req))
 		return -EAGAIN;
 	ret = io_prep_work_files(req);
 	if (unlikely(ret))
@@ -5584,7 +5602,7 @@ static int io_req_defer(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (!req_need_defer(req, seq) && list_empty_careful(&ctx->defer_list))
 		return 0;
 
-	if (!req->io) {
+	if (!req->async_data) {
 		ret = io_req_defer_prep(req, sqe);
 		if (ret)
 			return ret;
@@ -5612,8 +5630,6 @@ static int io_req_defer(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 static void __io_clean_op(struct io_kiocb *req)
 {
-	struct io_async_ctx *io = req->io;
-
 	if (req->flags & REQ_F_BUFFER_SELECTED) {
 		switch (req->opcode) {
 		case IORING_OP_READV:
@@ -5636,15 +5652,19 @@ static void __io_clean_op(struct io_kiocb *req)
 		case IORING_OP_READ:
 		case IORING_OP_WRITEV:
 		case IORING_OP_WRITE_FIXED:
-		case IORING_OP_WRITE:
-			if (io->rw.free_iovec)
-				kfree(io->rw.free_iovec);
+		case IORING_OP_WRITE: {
+			struct io_async_rw *io = req->async_data;
+			if (io->free_iovec)
+				kfree(io->free_iovec);
 			break;
+			}
 		case IORING_OP_RECVMSG:
-		case IORING_OP_SENDMSG:
-			if (io->msg.iov != io->msg.fast_iov)
-				kfree(io->msg.iov);
+		case IORING_OP_SENDMSG: {
+			struct io_async_msghdr *io = req->async_data;
+			if (io->iov != io->fast_iov)
+				kfree(io->iov);
 			break;
+			}
 		case IORING_OP_SPLICE:
 		case IORING_OP_TEE:
 			io_put_file(req, req->splice.file_in,
@@ -6080,7 +6100,7 @@ static void __io_queue_linked_timeout(struct io_kiocb *req)
 	 * we got a chance to setup the timer
 	 */
 	if (!list_empty(&req->link_list)) {
-		struct io_timeout_data *data = &req->io->timeout;
+		struct io_timeout_data *data = req->async_data;
 
 		data->timer.function = io_link_timeout_fn;
 		hrtimer_start(&data->timer, timespec64_to_ktime(data->ts),
@@ -6204,7 +6224,7 @@ static void io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			io_req_complete(req, ret);
 		}
 	} else if (req->flags & REQ_F_FORCE_ASYNC) {
-		if (!req->io) {
+		if (!req->async_data) {
 			ret = io_req_defer_prep(req, sqe);
 			if (unlikely(ret))
 				goto fail_req;
@@ -6387,7 +6407,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 
 	req->opcode = READ_ONCE(sqe->opcode);
 	req->user_data = READ_ONCE(sqe->user_data);
-	req->io = NULL;
+	req->async_data = NULL;
 	req->file = NULL;
 	req->ctx = ctx;
 	req->flags = 0;

-- 
Jens Axboe

