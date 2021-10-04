Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 174DA4216F7
	for <lists+io-uring@lfdr.de>; Mon,  4 Oct 2021 21:04:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237646AbhJDTFv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 Oct 2021 15:05:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238860AbhJDTFu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 Oct 2021 15:05:50 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC424C061745
        for <io-uring@vger.kernel.org>; Mon,  4 Oct 2021 12:04:00 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id g10so9263438edj.1
        for <io-uring@vger.kernel.org>; Mon, 04 Oct 2021 12:04:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ARG8sL5jqwkAO0gSEEfzuc49v3xr21He/X7mg34KNJo=;
        b=aSMuUr9DKCbqmJXAzxbiyzUtPS2a4jLCLYOExS+ANuok0PdT3y7n3CQumXOiFgTP52
         pBWjhzwKUp3X7mYdOGzD1Ldtbbyq6CpmhdR+NKqL6uFzeXRE54UhLR3M0M5Jq4KWg9FP
         tfgWnMOyOXShMtWYpobXUU2UwiRU+kRN8zZG/ESTCiHFYZip/YiNUQnKpuO5R67hoi1g
         A/+IRgeMDMV8GPkju9GScVbKw6RY+GA8+9ANGaJxDsrBmlNZGaNOtUTH/uVUN8a5Z2uv
         Kvs1vVPnMue01Y4Fnzh+WwrDKKQXj5JPfvvRmcKaDMurO5oMaxv7lCZrd0SO8JWLF3rx
         /+qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ARG8sL5jqwkAO0gSEEfzuc49v3xr21He/X7mg34KNJo=;
        b=LsFoQgAdNu5W4Pj1HdZm6juQgMtNM8z/1LmjleeW4BYUOCVnL5uYr4zEwX1IhQWhLo
         vvPVyQ3ejblwZq86Q/7OrrQAvqZkI1bVQHwdfcsaYP2y4U7FMVBUapJemzEiKtNFqvHv
         3uAXVKmYGXiyNV3ZaPOQoMxa/r4ThpUj4IBLIThFenyKnqhyD2FFzAojUDN1F+MIUdl0
         tBT2e+QhIEgnw6pmUN8mN8+QaR8GjIQapwL3yGiX1fP9TIzQvGTaY+wTsxoZuyAGXZET
         9P+t0Yq2YBDkUji4xLceqhVSLbLmeaj22wIEbNHY57HMa3XBzDqbLLRJ0joZEIjvfJLh
         qy4w==
X-Gm-Message-State: AOAM530MJIV4VtwMqQjKSvAxG2NrqhCSm9MHENpAWvPVyXrah1ex+I8H
        CCN/WNs+umGeqJ0pQHuf3iTr1EN2eCs=
X-Google-Smtp-Source: ABdhPJzK8HrGU71e6aluShpKXBFhe5vwE05djybQUq3lmMxY5u7eTL/EvneUELM5Dt0Y7b5bPV6ipg==
X-Received: by 2002:a05:6402:40f:: with SMTP id q15mr19888107edv.333.1633374237857;
        Mon, 04 Oct 2021 12:03:57 -0700 (PDT)
Received: from localhost.localdomain ([85.255.237.101])
        by smtp.gmail.com with ESMTPSA id k12sm6855045ejk.63.2021.10.04.12.03.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 12:03:57 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 11/16] io_uring: control ->async_data with a REQ_F flag
Date:   Mon,  4 Oct 2021 20:02:56 +0100
Message-Id: <6892cf5883c459f36bda26f30ceb16742b20b84b.1633373302.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1633373302.git.asml.silence@gmail.com>
References: <cover.1633373302.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

->async_data is a slow path, so it won't matter much if we do the clean
up inside io_clean_op(). Moreover, in many cases it's allocated together
with setting one or more of IO_REQ_CLEAN_FLAGS flags, so it'd go through
io_clean_op() anyway.

Control ->async_data allocation with a new flag REQ_F_ASYNC_DATA, so we
can do all the maintainence under io_req_needs_clean() fast check.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 72 ++++++++++++++++++++++++++++++++-------------------
 1 file changed, 46 insertions(+), 26 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 50312ac4537d..1e93c0b1314c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -109,7 +109,8 @@
 #define SQE_VALID_FLAGS	(SQE_COMMON_FLAGS|IOSQE_BUFFER_SELECT|IOSQE_IO_DRAIN)
 
 #define IO_REQ_CLEAN_FLAGS (REQ_F_BUFFER_SELECTED | REQ_F_NEED_CLEANUP | \
-				REQ_F_POLLED | REQ_F_INFLIGHT | REQ_F_CREDS)
+				REQ_F_POLLED | REQ_F_INFLIGHT | REQ_F_CREDS | \
+				REQ_F_ASYNC_DATA)
 
 #define IO_TCTX_REFS_CACHE_NR	(1U << 10)
 
@@ -732,6 +733,7 @@ enum {
 	REQ_F_CREDS_BIT,
 	REQ_F_REFCOUNT_BIT,
 	REQ_F_ARM_LTIMEOUT_BIT,
+	REQ_F_ASYNC_DATA_BIT,
 	/* keep async read/write and isreg together and in order */
 	REQ_F_NOWAIT_READ_BIT,
 	REQ_F_NOWAIT_WRITE_BIT,
@@ -787,6 +789,8 @@ enum {
 	REQ_F_REFCOUNT		= BIT(REQ_F_REFCOUNT_BIT),
 	/* there is a linked timeout that has to be armed */
 	REQ_F_ARM_LTIMEOUT	= BIT(REQ_F_ARM_LTIMEOUT_BIT),
+	/* ->async_data allocated */
+	REQ_F_ASYNC_DATA	= BIT(REQ_F_ASYNC_DATA_BIT),
 };
 
 struct async_poll {
@@ -847,8 +851,6 @@ struct io_kiocb {
 		struct io_completion	compl;
 	};
 
-	/* opcode allocated if it needs to store data for async defer */
-	void				*async_data;
 	u8				opcode;
 	/* polled IO has completed */
 	u8				iopoll_completed;
@@ -863,6 +865,8 @@ struct io_kiocb {
 	u64				user_data;
 
 	struct percpu_ref		*fixed_rsrc_refs;
+	/* store used ubuf, so we can prevent reloading */
+	struct io_mapped_ubuf		*imu;
 
 	/* used by request caches, completion batching and iopoll */
 	struct io_wq_work_node		comp_list;
@@ -872,8 +876,9 @@ struct io_kiocb {
 	struct hlist_node		hash_node;
 	/* internal polling, see IORING_FEAT_FAST_POLL */
 	struct async_poll		*apoll;
-	/* store used ubuf, so we can prevent reloading */
-	struct io_mapped_ubuf		*imu;
+
+	/* opcode allocated if it needs to store data for async defer */
+	void				*async_data;
 	struct io_wq_work		work;
 	/* custom credentials, valid IFF REQ_F_CREDS is set */
 	const struct cred		*creds;
@@ -1219,6 +1224,11 @@ static bool io_match_task(struct io_kiocb *head, struct task_struct *task,
 	return false;
 }
 
+static inline bool req_has_async_data(struct io_kiocb *req)
+{
+	return req->flags & REQ_F_ASYNC_DATA;
+}
+
 static inline void req_set_fail(struct io_kiocb *req)
 {
 	req->flags |= REQ_F_FAIL;
@@ -1969,10 +1979,6 @@ static inline void io_dismantle_req(struct io_kiocb *req)
 		io_put_file(req->file);
 	if (req->fixed_rsrc_refs)
 		percpu_ref_put(req->fixed_rsrc_refs);
-	if (req->async_data) {
-		kfree(req->async_data);
-		req->async_data = NULL;
-	}
 }
 
 static __cold void __io_free_req(struct io_kiocb *req)
@@ -2561,7 +2567,7 @@ static bool io_resubmit_prep(struct io_kiocb *req)
 {
 	struct io_async_rw *rw = req->async_data;
 
-	if (!rw)
+	if (!req_has_async_data(req))
 		return !io_req_prep_async(req);
 	iov_iter_restore(&rw->iter, &rw->iter_state);
 	return true;
@@ -2881,7 +2887,7 @@ static void kiocb_done(struct kiocb *kiocb, ssize_t ret,
 	struct io_async_rw *io = req->async_data;
 
 	/* add previously done IO, if any */
-	if (io && io->bytes_done > 0) {
+	if (req_has_async_data(req) && io->bytes_done > 0) {
 		if (ret < 0)
 			ret = io->bytes_done;
 		else
@@ -3260,7 +3266,11 @@ static inline bool io_alloc_async_data(struct io_kiocb *req)
 {
 	WARN_ON_ONCE(!io_op_defs[req->opcode].async_size);
 	req->async_data = kmalloc(io_op_defs[req->opcode].async_size, GFP_KERNEL);
-	return req->async_data == NULL;
+	if (req->async_data) {
+		req->flags |= REQ_F_ASYNC_DATA;
+		return false;
+	}
+	return true;
 }
 
 static int io_setup_async_rw(struct io_kiocb *req, const struct iovec *iovec,
@@ -3269,7 +3279,7 @@ static int io_setup_async_rw(struct io_kiocb *req, const struct iovec *iovec,
 {
 	if (!force && !io_op_defs[req->opcode].needs_async_setup)
 		return 0;
-	if (!req->async_data) {
+	if (!req_has_async_data(req)) {
 		struct io_async_rw *iorw;
 
 		if (io_alloc_async_data(req)) {
@@ -3402,12 +3412,13 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
 	struct iovec inline_vecs[UIO_FASTIOV], *iovec = inline_vecs;
 	struct kiocb *kiocb = &req->rw.kiocb;
 	struct iov_iter __iter, *iter = &__iter;
-	struct io_async_rw *rw = req->async_data;
 	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
 	struct iov_iter_state __state, *state;
+	struct io_async_rw *rw;
 	ssize_t ret, ret2;
 
-	if (rw) {
+	if (req_has_async_data(req)) {
+		rw = req->async_data;
 		iter = &rw->iter;
 		state = &rw->iter_state;
 		/*
@@ -3537,12 +3548,13 @@ static int io_write(struct io_kiocb *req, unsigned int issue_flags)
 	struct iovec inline_vecs[UIO_FASTIOV], *iovec = inline_vecs;
 	struct kiocb *kiocb = &req->rw.kiocb;
 	struct iov_iter __iter, *iter = &__iter;
-	struct io_async_rw *rw = req->async_data;
 	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
 	struct iov_iter_state __state, *state;
+	struct io_async_rw *rw;
 	ssize_t ret, ret2;
 
-	if (rw) {
+	if (req_has_async_data(req)) {
+		rw = req->async_data;
 		iter = &rw->iter;
 		state = &rw->iter_state;
 		iov_iter_restore(iter, state);
@@ -4711,8 +4723,9 @@ static int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
 	if (unlikely(!sock))
 		return -ENOTSOCK;
 
-	kmsg = req->async_data;
-	if (!kmsg) {
+	if (req_has_async_data(req)) {
+		kmsg = req->async_data;
+	} else {
 		ret = io_sendmsg_copy_hdr(req, &iomsg);
 		if (ret)
 			return ret;
@@ -4928,8 +4941,9 @@ static int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 	if (unlikely(!sock))
 		return -ENOTSOCK;
 
-	kmsg = req->async_data;
-	if (!kmsg) {
+	if (req_has_async_data(req)) {
+		kmsg = req->async_data;
+	} else {
 		ret = io_recvmsg_copy_hdr(req, &iomsg);
 		if (ret)
 			return ret;
@@ -5120,7 +5134,7 @@ static int io_connect(struct io_kiocb *req, unsigned int issue_flags)
 	int ret;
 	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
 
-	if (req->async_data) {
+	if (req_has_async_data(req)) {
 		io = req->async_data;
 	} else {
 		ret = move_addr_to_kernel(req->connect.addr,
@@ -5136,7 +5150,7 @@ static int io_connect(struct io_kiocb *req, unsigned int issue_flags)
 	ret = __sys_connect_file(req->file, &io->address,
 					req->connect.addr_len, file_flags);
 	if ((ret == -EAGAIN || ret == -EINPROGRESS) && force_nonblock) {
-		if (req->async_data)
+		if (req_has_async_data(req))
 			return -EAGAIN;
 		if (io_alloc_async_data(req)) {
 			ret = -ENOMEM;
@@ -5427,7 +5441,10 @@ static void __io_queue_proc(struct io_poll_iocb *poll, struct io_poll_table *pt,
 		io_init_poll_iocb(poll, poll_one->events, io_poll_double_wake);
 		req_ref_get(req);
 		poll->wait.private = req;
+
 		*poll_ptr = poll;
+		if (req->opcode == IORING_OP_POLL_ADD)
+			req->flags |= REQ_F_ASYNC_DATA;
 	}
 
 	pt->nr_entries++;
@@ -6089,7 +6106,7 @@ static int io_timeout_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	if (unlikely(off && !req->ctx->off_timeout_used))
 		req->ctx->off_timeout_used = true;
 
-	if (!req->async_data && io_alloc_async_data(req))
+	if (!req_has_async_data(req) && io_alloc_async_data(req))
 		return -ENOMEM;
 
 	data = req->async_data;
@@ -6398,7 +6415,7 @@ static int io_req_prep_async(struct io_kiocb *req)
 {
 	if (!io_op_defs[req->opcode].needs_async_setup)
 		return 0;
-	if (WARN_ON_ONCE(req->async_data))
+	if (WARN_ON_ONCE(req_has_async_data(req)))
 		return -EFAULT;
 	if (io_alloc_async_data(req))
 		return -EAGAIN;
@@ -6541,7 +6558,10 @@ static void io_clean_op(struct io_kiocb *req)
 	}
 	if (req->flags & REQ_F_CREDS)
 		put_cred(req->creds);
-
+	if (req->flags & REQ_F_ASYNC_DATA) {
+		kfree(req->async_data);
+		req->async_data = NULL;
+	}
 	req->flags &= ~IO_REQ_CLEAN_FLAGS;
 }
 
-- 
2.33.0

