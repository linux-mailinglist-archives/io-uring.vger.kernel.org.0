Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E28021281A4
	for <lists+io-uring@lfdr.de>; Fri, 20 Dec 2019 18:47:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727440AbfLTRrv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 20 Dec 2019 12:47:51 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:40366 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727436AbfLTRrv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 20 Dec 2019 12:47:51 -0500
Received: by mail-io1-f67.google.com with SMTP id x1so10204006iop.7
        for <io-uring@vger.kernel.org>; Fri, 20 Dec 2019 09:47:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xJNVBrKEtNhIKQ5ueA4T9NgAtLlbeM8C0EPxyVEnMOY=;
        b=JqjVimXaE94DACjGkmruUb6eeDYb6DNkwOyu6ZGr1S5aPcUDTyRiiR3gaKH6TApEB1
         tQm+NTO6TGKHf7wf9mAoDTejqeolYrlLJbIslFOsUjNy8baHys679YmnwvGsLXzdwNP3
         2L09uuP0InHE/HrqEhYGAbSxEYH4JIO+TKZvAHTFtwWC9YQ7q2y0P6PkDeKNrAGjBHLo
         mkaoJovfUGbPhl8CYe1RAyqDLoxyLtWhA1HBAvdcBtKtMPwGtFvugcwqJiEKHCpSx6xF
         iYspeKCdl4C59C3q89rv2qzMkkw1E7xB64tVwiXHNlYoIQpUOxQzlbvfD1WSRbgYiCRf
         XIBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xJNVBrKEtNhIKQ5ueA4T9NgAtLlbeM8C0EPxyVEnMOY=;
        b=diBt0nxCi5ypSPdbAS0FEd2sHSYW073FRiZVyyM95q0763WPn6F6eDeyu/T1pe5H3G
         gWv1tvxFs3noKD58qm1P13pz+iZKOW+s7wfBL+w5TtaRNkFkW2VGRVQkpVe2vsyjth21
         zMKNiFdiWFu8HnID2J2rvRoTkHtDb6X5MJbgNc6EBH057S4wX5NCJ88dPBsxKHxWrX6u
         TaIZABkNZKGrf3BrPOXoVXLPuBXbhmpkt7TSdErUeHMsjZzleUkloTPgOkhsgOXCo6g9
         1aE4Z4MJbXX0sgEDZEnJQriNZYy/dRQD5PaCR92GYC22IJpmWl2Kw8xfxFbbCTFmyiBg
         jzTA==
X-Gm-Message-State: APjAAAWqA4c0OXFAOkTX6lNhjVQexxoVDZfIvpmY3R7HLIeV/4aABmDD
        tLk+7iJAn+Gy/1ufjXwDZY4lsIJXwfnUGQ==
X-Google-Smtp-Source: APXvYqzFJP0sy5PHLbqSmQVLjZm1MEQP/94Hps3fcW4BCwH8H96vhusS993G+o0YoxqxLrLqRIulSQ==
X-Received: by 2002:a02:2b03:: with SMTP id h3mr13388387jaa.32.1576864069736;
        Fri, 20 Dec 2019 09:47:49 -0800 (PST)
Received: from x1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id j88sm4969677ilf.83.2019.12.20.09.47.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Dec 2019 09:47:49 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6/7] io_uring: standardize the prep methods
Date:   Fri, 20 Dec 2019 10:47:41 -0700
Message-Id: <20191220174742.7449-7-axboe@kernel.dk>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191220174742.7449-1-axboe@kernel.dk>
References: <20191220174742.7449-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We currently have a mix of use cases. Most of the newer ones are pretty
uniform, but we have some older ones that use different calling
calling conventions. This is confusing.

For the opcodes that currently rely on the req->io->sqe copy saving
them from reuse, add a request type struct in the io_kiocb command
union to store the data they need.

Prepare for all opcodes having a standard prep method, so we can call
it in a uniform fashion and outside of the opcode handler. This is in
preparation for passing in the 'sqe' pointer, rather than storing it
in the io_kiocb. Once we have uniform prep handlers, we can leave all
the prep work to that part, and not even pass in the sqe to the opcode
handler. This ensures that we don't reuse sqe data inadvertently.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 128 +++++++++++++++++++++++++-------------------------
 1 file changed, 63 insertions(+), 65 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 7e8d28750053..2cdfbb451fe2 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -371,7 +371,6 @@ struct io_async_rw {
 };
 
 struct io_async_ctx {
-	struct io_uring_sqe		sqe;
 	union {
 		struct io_async_rw	rw;
 		struct io_async_msghdr	msg;
@@ -433,7 +432,6 @@ struct io_kiocb {
 #define REQ_F_INFLIGHT		16384	/* on inflight list */
 #define REQ_F_COMP_LOCKED	32768	/* completion under lock */
 #define REQ_F_HARDLINK		65536	/* doesn't sever on completion < 0 */
-#define REQ_F_PREPPED		131072	/* request already opcode prepared */
 	u64			user_data;
 	u32			result;
 	u32			sequence;
@@ -1501,6 +1499,8 @@ static int io_prep_rw(struct io_kiocb *req, bool force_nonblock)
 	unsigned ioprio;
 	int ret;
 
+	if (!sqe)
+		return 0;
 	if (!req->file)
 		return -EBADF;
 
@@ -1552,6 +1552,7 @@ static int io_prep_rw(struct io_kiocb *req, bool force_nonblock)
 	/* we own ->private, reuse it for the buffer index */
 	req->rw.kiocb.private = (void *) (unsigned long)
 					READ_ONCE(req->sqe->buf_index);
+	req->sqe = NULL;
 	return 0;
 }
 
@@ -1773,13 +1774,7 @@ static void io_req_map_rw(struct io_kiocb *req, ssize_t io_size,
 static int io_alloc_async_ctx(struct io_kiocb *req)
 {
 	req->io = kmalloc(sizeof(*req->io), GFP_KERNEL);
-	if (req->io) {
-		memcpy(&req->io->sqe, req->sqe, sizeof(req->io->sqe));
-		req->sqe = &req->io->sqe;
-		return 0;
-	}
-
-	return 1;
+	return req->io == NULL;
 }
 
 static void io_rw_async(struct io_wq_work **workptr)
@@ -1810,12 +1805,14 @@ static int io_read_prep(struct io_kiocb *req, struct iovec **iovec,
 {
 	ssize_t ret;
 
-	ret = io_prep_rw(req, force_nonblock);
-	if (ret)
-		return ret;
+	if (req->sqe) {
+		ret = io_prep_rw(req, force_nonblock);
+		if (ret)
+			return ret;
 
-	if (unlikely(!(req->file->f_mode & FMODE_READ)))
-		return -EBADF;
+		if (unlikely(!(req->file->f_mode & FMODE_READ)))
+			return -EBADF;
+	}
 
 	return io_import_iovec(READ, req, iovec, iter);
 }
@@ -1829,15 +1826,9 @@ static int io_read(struct io_kiocb *req, struct io_kiocb **nxt,
 	size_t iov_count;
 	ssize_t io_size, ret;
 
-	if (!req->io) {
-		ret = io_read_prep(req, &iovec, &iter, force_nonblock);
-		if (ret < 0)
-			return ret;
-	} else {
-		ret = io_import_iovec(READ, req, &iovec, &iter);
-		if (ret < 0)
-			return ret;
-	}
+	ret = io_read_prep(req, &iovec, &iter, force_nonblock);
+	if (ret < 0)
+		return ret;
 
 	/* Ensure we clear previously set non-block flag */
 	if (!force_nonblock)
@@ -1901,12 +1892,14 @@ static int io_write_prep(struct io_kiocb *req, struct iovec **iovec,
 {
 	ssize_t ret;
 
-	ret = io_prep_rw(req, force_nonblock);
-	if (ret)
-		return ret;
+	if (req->sqe) {
+		ret = io_prep_rw(req, force_nonblock);
+		if (ret)
+			return ret;
 
-	if (unlikely(!(req->file->f_mode & FMODE_WRITE)))
-		return -EBADF;
+		if (unlikely(!(req->file->f_mode & FMODE_WRITE)))
+			return -EBADF;
+	}
 
 	return io_import_iovec(WRITE, req, iovec, iter);
 }
@@ -1920,15 +1913,9 @@ static int io_write(struct io_kiocb *req, struct io_kiocb **nxt,
 	size_t iov_count;
 	ssize_t ret, io_size;
 
-	if (!req->io) {
-		ret = io_write_prep(req, &iovec, &iter, force_nonblock);
-		if (ret < 0)
-			return ret;
-	} else {
-		ret = io_import_iovec(WRITE, req, &iovec, &iter);
-		if (ret < 0)
-			return ret;
-	}
+	ret = io_write_prep(req, &iovec, &iter, force_nonblock);
+	if (ret < 0)
+		return ret;
 
 	/* Ensure we clear previously set non-block flag */
 	if (!force_nonblock)
@@ -2013,7 +2000,7 @@ static int io_prep_fsync(struct io_kiocb *req)
 	const struct io_uring_sqe *sqe = req->sqe;
 	struct io_ring_ctx *ctx = req->ctx;
 
-	if (req->flags & REQ_F_PREPPED)
+	if (!req->sqe)
 		return 0;
 	if (!req->file)
 		return -EBADF;
@@ -2029,7 +2016,7 @@ static int io_prep_fsync(struct io_kiocb *req)
 
 	req->sync.off = READ_ONCE(sqe->off);
 	req->sync.len = READ_ONCE(sqe->len);
-	req->flags |= REQ_F_PREPPED;
+	req->sqe = NULL;
 	return 0;
 }
 
@@ -2095,7 +2082,7 @@ static int io_prep_sfr(struct io_kiocb *req)
 	const struct io_uring_sqe *sqe = req->sqe;
 	struct io_ring_ctx *ctx = req->ctx;
 
-	if (req->flags & REQ_F_PREPPED)
+	if (!sqe)
 		return 0;
 	if (!req->file)
 		return -EBADF;
@@ -2108,7 +2095,7 @@ static int io_prep_sfr(struct io_kiocb *req)
 	req->sync.off = READ_ONCE(sqe->off);
 	req->sync.len = READ_ONCE(sqe->len);
 	req->sync.flags = READ_ONCE(sqe->sync_range_flags);
-	req->flags |= REQ_F_PREPPED;
+	req->sqe = NULL;
 	return 0;
 }
 
@@ -2173,12 +2160,17 @@ static int io_sendmsg_prep(struct io_kiocb *req, struct io_async_ctx *io)
 #if defined(CONFIG_NET)
 	const struct io_uring_sqe *sqe = req->sqe;
 	struct io_sr_msg *sr = &req->sr_msg;
+	int ret;
 
+	if (!sqe)
+		return 0;
 	sr->msg_flags = READ_ONCE(sqe->msg_flags);
 	sr->msg = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	io->msg.iov = io->msg.fast_iov;
-	return sendmsg_copy_msghdr(&io->msg.msg, sr->msg, sr->msg_flags,
+	ret = sendmsg_copy_msghdr(&io->msg.msg, sr->msg, sr->msg_flags,
 					&io->msg.iov);
+	req->sqe = NULL;
+	return ret;
 #else
 	return -EOPNOTSUPP;
 #endif
@@ -2253,12 +2245,18 @@ static int io_recvmsg_prep(struct io_kiocb *req, struct io_async_ctx *io)
 {
 #if defined(CONFIG_NET)
 	struct io_sr_msg *sr = &req->sr_msg;
+	int ret;
+
+	if (!req->sqe)
+		return 0;
 
 	sr->msg_flags = READ_ONCE(req->sqe->msg_flags);
 	sr->msg = u64_to_user_ptr(READ_ONCE(req->sqe->addr));
 	io->msg.iov = io->msg.fast_iov;
-	return recvmsg_copy_msghdr(&io->msg.msg, sr->msg, sr->msg_flags,
+	ret = recvmsg_copy_msghdr(&io->msg.msg, sr->msg, sr->msg_flags,
 					&io->msg.uaddr, &io->msg.iov);
+	req->sqe = NULL;
+	return ret;
 #else
 	return -EOPNOTSUPP;
 #endif
@@ -2336,7 +2334,7 @@ static int io_accept_prep(struct io_kiocb *req)
 	const struct io_uring_sqe *sqe = req->sqe;
 	struct io_accept *accept = &req->accept;
 
-	if (req->flags & REQ_F_PREPPED)
+	if (!req->sqe)
 		return 0;
 
 	if (unlikely(req->ctx->flags & (IORING_SETUP_IOPOLL|IORING_SETUP_SQPOLL)))
@@ -2347,7 +2345,7 @@ static int io_accept_prep(struct io_kiocb *req)
 	accept->addr = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	accept->addr_len = u64_to_user_ptr(READ_ONCE(sqe->addr2));
 	accept->flags = READ_ONCE(sqe->accept_flags);
-	req->flags |= REQ_F_PREPPED;
+	req->sqe = NULL;
 	return 0;
 #else
 	return -EOPNOTSUPP;
@@ -2416,7 +2414,10 @@ static int io_connect_prep(struct io_kiocb *req, struct io_async_ctx *io)
 {
 #if defined(CONFIG_NET)
 	const struct io_uring_sqe *sqe = req->sqe;
+	int ret;
 
+	if (!sqe)
+		return 0;
 	if (unlikely(req->ctx->flags & (IORING_SETUP_IOPOLL|IORING_SETUP_SQPOLL)))
 		return -EINVAL;
 	if (sqe->ioprio || sqe->len || sqe->buf_index || sqe->rw_flags)
@@ -2424,8 +2425,10 @@ static int io_connect_prep(struct io_kiocb *req, struct io_async_ctx *io)
 
 	req->connect.addr = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	req->connect.addr_len =  READ_ONCE(sqe->addr2);
-	return move_addr_to_kernel(req->connect.addr, req->connect.addr_len,
+	ret = move_addr_to_kernel(req->connect.addr, req->connect.addr_len,
 					&io->connect.address);
+	req->sqe = NULL;
+	return ret;
 #else
 	return -EOPNOTSUPP;
 #endif
@@ -2526,7 +2529,7 @@ static int io_poll_remove_prep(struct io_kiocb *req)
 {
 	const struct io_uring_sqe *sqe = req->sqe;
 
-	if (req->flags & REQ_F_PREPPED)
+	if (!sqe)
 		return 0;
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
@@ -2535,7 +2538,7 @@ static int io_poll_remove_prep(struct io_kiocb *req)
 		return -EINVAL;
 
 	req->poll.addr = READ_ONCE(sqe->addr);
-	req->flags |= REQ_F_PREPPED;
+	req->sqe = NULL;
 	return 0;
 }
 
@@ -2696,7 +2699,7 @@ static int io_poll_add_prep(struct io_kiocb *req)
 	struct io_poll_iocb *poll = &req->poll;
 	u16 events;
 
-	if (req->flags & REQ_F_PREPPED)
+	if (!sqe)
 		return 0;
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
@@ -2705,9 +2708,9 @@ static int io_poll_add_prep(struct io_kiocb *req)
 	if (!poll->file)
 		return -EBADF;
 
-	req->flags |= REQ_F_PREPPED;
 	events = READ_ONCE(sqe->poll_events);
 	poll->events = demangle_poll(events) | EPOLLERR | EPOLLHUP;
+	req->sqe = NULL;
 	return 0;
 }
 
@@ -2845,7 +2848,7 @@ static int io_timeout_remove_prep(struct io_kiocb *req)
 {
 	const struct io_uring_sqe *sqe = req->sqe;
 
-	if (req->flags & REQ_F_PREPPED)
+	if (!sqe)
 		return 0;
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
@@ -2857,7 +2860,7 @@ static int io_timeout_remove_prep(struct io_kiocb *req)
 	if (req->timeout.flags)
 		return -EINVAL;
 
-	req->flags |= REQ_F_PREPPED;
+	req->sqe = NULL;
 	return 0;
 }
 
@@ -2893,6 +2896,8 @@ static int io_timeout_prep(struct io_kiocb *req, struct io_async_ctx *io,
 	struct io_timeout_data *data;
 	unsigned flags;
 
+	if (!sqe)
+		return 0;
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
 	if (sqe->ioprio || sqe->buf_index || sqe->len != 1)
@@ -2921,6 +2926,7 @@ static int io_timeout_prep(struct io_kiocb *req, struct io_async_ctx *io,
 		data->mode = HRTIMER_MODE_REL;
 
 	hrtimer_init(&data->timer, CLOCK_MONOTONIC, data->mode);
+	req->sqe = NULL;
 	return 0;
 }
 
@@ -2933,13 +2939,9 @@ static int io_timeout(struct io_kiocb *req)
 	unsigned span = 0;
 	int ret;
 
-	if (!req->io) {
-		if (io_alloc_async_ctx(req))
-			return -ENOMEM;
-		ret = io_timeout_prep(req, req->io, false);
-		if (ret)
-			return ret;
-	}
+	ret = io_timeout_prep(req, req->io, false);
+	if (ret)
+		return ret;
 	data = &req->io->timeout;
 
 	/*
@@ -3069,7 +3071,7 @@ static int io_async_cancel_prep(struct io_kiocb *req)
 {
 	const struct io_uring_sqe *sqe = req->sqe;
 
-	if (req->flags & REQ_F_PREPPED)
+	if (!sqe)
 		return 0;
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
@@ -3077,8 +3079,8 @@ static int io_async_cancel_prep(struct io_kiocb *req)
 	    sqe->cancel_flags)
 		return -EINVAL;
 
-	req->flags |= REQ_F_PREPPED;
 	req->cancel.addr = READ_ONCE(sqe->addr);
+	req->sqe = NULL;
 	return 0;
 }
 
@@ -3213,13 +3215,9 @@ static int io_issue_sqe(struct io_kiocb *req, struct io_kiocb **nxt,
 		ret = io_nop(req);
 		break;
 	case IORING_OP_READV:
-		if (unlikely(req->sqe->buf_index))
-			return -EINVAL;
 		ret = io_read(req, nxt, force_nonblock);
 		break;
 	case IORING_OP_WRITEV:
-		if (unlikely(req->sqe->buf_index))
-			return -EINVAL;
 		ret = io_write(req, nxt, force_nonblock);
 		break;
 	case IORING_OP_READ_FIXED:
-- 
2.24.1

