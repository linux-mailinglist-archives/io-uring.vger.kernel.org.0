Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E75423DA71F
	for <lists+io-uring@lfdr.de>; Thu, 29 Jul 2021 17:06:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237738AbhG2PGn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 29 Jul 2021 11:06:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237212AbhG2PGm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 29 Jul 2021 11:06:42 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8007EC061765
        for <io-uring@vger.kernel.org>; Thu, 29 Jul 2021 08:06:38 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id l11-20020a7bcf0b0000b0290253545c2997so4258829wmg.4
        for <io-uring@vger.kernel.org>; Thu, 29 Jul 2021 08:06:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=Q3lNklOglVDIwGezXvVK/mNL4hHpmbRrqaCVuDRB4Ko=;
        b=krQiVj2Nx+9VbJ1GXYLoI8mBMEJqMS+oiyPjy4w2VFBZH6/+zgZxoXeYy+wYaljpO7
         kTZg5lxVJenDI9mrmH/z8jlahn0z3xIQLJ6I/9zpLTa0xz8Cj7X+uZYzEw3gEZisTLN/
         6bjqtBHJSFP8kMREZMOzmKnhGGuNd7QSR0znSMwOUuylArucIc2wQjQXtmek5KJbD2UG
         W0nri2NCPryjqQG0/gVByCuDEW5oVqrMlRNx61SI9Z4/h1DqO9x1PjdGjMN7/1oFawYx
         SgENXBElGGUHfqfyLo6XUbjWeJBNLl39IV8UlzI4AjH62RRO9/js61QwIc7ik3DL6HNC
         leAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Q3lNklOglVDIwGezXvVK/mNL4hHpmbRrqaCVuDRB4Ko=;
        b=d3pcBSnY2eT2oq6cVHPE4B3k97lFiPJ0Uz4V7oMnRceM9lUP2Y3WnyT1tq4VP4c4Z5
         eLqjrAPT6+JxpbvY3xz0NKpw6cTu4ZvcytVkc+QWmOZhE3VzGom1CmvmlSRalVPOM0x5
         zY4KSPXlnE0Gdp+BgKOyXTWUtMoNt6m9NNCJI5d958+YI9nuz0BFNLUAY1m74O2YVmGs
         hAUCadyRAFbMc4qWcfOZ/NwA3sjLsZCEwHV5uhe9f+9WwURqd/TkcB6NAmhHf6CcXqnZ
         +uuB9uYG6oiaIPMSKEWC+ilJvSREZjVv1badl7sdut8ovL1IFi1k3gFmUaZio78skvlI
         nQqg==
X-Gm-Message-State: AOAM530BOjntCIdifajFOHm2jukXK8eUl7YQYa/gsCf3bg5rrOqvwxIU
        UEJitfa/4vrlBiznyq5u1AAf1wmgRmE=
X-Google-Smtp-Source: ABdhPJwCaqls05m13W1MnOkWusZJP1R0GKFHf5IxNxPm26ADyQpatp1AgcP5ilVxFZd7QiYeq9eOKQ==
X-Received: by 2002:a1c:f203:: with SMTP id s3mr14434423wmc.138.1627571197068;
        Thu, 29 Jul 2021 08:06:37 -0700 (PDT)
Received: from localhost.localdomain ([148.252.128.141])
        by smtp.gmail.com with ESMTPSA id e6sm4764577wrg.18.2021.07.29.08.06.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 08:06:36 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 16/23] io_uring: hide async dadta behind flags
Date:   Thu, 29 Jul 2021 16:05:43 +0100
Message-Id: <96c9359d61ccd287009e9e47d60fdb87bc673043.1627570633.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1627570633.git.asml.silence@gmail.com>
References: <cover.1627570633.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Checking flags is a bit faster and can be batched, but the main reason
of controlling ->async_data with req->flags but not relying on NULL is
that we safely move it now to the end of io_kiocb, where cachelines are
rarely loaded, and use that freed space for something more hot like
io_mapped_ubuf.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 70 ++++++++++++++++++++++++++++++++-------------------
 1 file changed, 44 insertions(+), 26 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 7276f784a7fe..df970e0ad43b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -111,7 +111,8 @@
 				IOSQE_IO_HARDLINK | IOSQE_ASYNC | \
 				IOSQE_BUFFER_SELECT)
 #define IO_REQ_CLEAN_FLAGS (REQ_F_BUFFER_SELECTED | REQ_F_NEED_CLEANUP | \
-				REQ_F_POLLED | REQ_F_INFLIGHT | REQ_F_CREDS)
+				REQ_F_POLLED | REQ_F_INFLIGHT | REQ_F_CREDS | \
+				REQ_F_ASYNC_DATA)
 
 #define IO_TCTX_REFS_CACHE_NR	(1U << 10)
 
@@ -722,6 +723,7 @@ enum {
 	REQ_F_REISSUE_BIT,
 	REQ_F_DONT_REISSUE_BIT,
 	REQ_F_CREDS_BIT,
+	REQ_F_ASYNC_DATA_BIT,
 	/* keep async read/write and isreg together and in order */
 	REQ_F_ASYNC_READ_BIT,
 	REQ_F_ASYNC_WRITE_BIT,
@@ -777,6 +779,8 @@ enum {
 	REQ_F_ISREG		= BIT(REQ_F_ISREG_BIT),
 	/* has creds assigned */
 	REQ_F_CREDS		= BIT(REQ_F_CREDS_BIT),
+	/* ->async_data allocated */
+	REQ_F_ASYNC_DATA	= BIT(REQ_F_ASYNC_DATA_BIT),
 };
 
 struct async_poll {
@@ -834,8 +838,6 @@ struct io_kiocb {
 		struct io_completion	compl;
 	};
 
-	/* opcode allocated if it needs to store data for async defer */
-	void				*async_data;
 	u8				opcode;
 	/* polled IO has completed */
 	u8				iopoll_completed;
@@ -851,6 +853,14 @@ struct io_kiocb {
 
 	struct io_kiocb			*link;
 	struct percpu_ref		*fixed_rsrc_refs;
+	/* store used ubuf, so we can prevent reloading */
+	struct io_mapped_ubuf		*imu;
+
+	/*
+	 * Opcode allocated if it needs to store data for async defer,
+	 * only valid if REQ_F_ASYNC_DATA is set
+	 */
+	void				*async_data;
 
 	/* used with ctx->iopoll_list with reads/writes */
 	struct list_head		inflight_entry;
@@ -859,10 +869,8 @@ struct io_kiocb {
 	struct hlist_node		hash_node;
 	struct async_poll		*apoll;
 	struct io_wq_work		work;
+	/* only valid when REQ_F_CREDS is set */
 	const struct cred		*creds;
-
-	/* store used ubuf, so we can prevent reloading */
-	struct io_mapped_ubuf		*imu;
 };
 
 struct io_tctx_node {
@@ -1132,6 +1140,11 @@ static bool io_match_task(struct io_kiocb *head, struct task_struct *task,
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
@@ -1799,10 +1812,6 @@ static void io_dismantle_req(struct io_kiocb *req)
 		io_put_file(req->file);
 	if (req->fixed_rsrc_refs)
 		percpu_ref_put(req->fixed_rsrc_refs);
-	if (req->async_data) {
-		kfree(req->async_data);
-		req->async_data = NULL;
-	}
 }
 
 static void __io_free_req(struct io_kiocb *req)
@@ -2413,7 +2422,7 @@ static bool io_resubmit_prep(struct io_kiocb *req)
 {
 	struct io_async_rw *rw = req->async_data;
 
-	if (!rw)
+	if (!req_has_async_data(req))
 		return !io_req_prep_async(req);
 	/* may have left rw->iter inconsistent on -EIOCBQUEUED */
 	iov_iter_revert(&rw->iter, req->result - iov_iter_count(&rw->iter));
@@ -2755,7 +2764,7 @@ static void kiocb_done(struct kiocb *kiocb, ssize_t ret,
 	bool check_reissue = kiocb->ki_complete == io_complete_rw;
 
 	/* add previously done IO, if any */
-	if (io && io->bytes_done > 0) {
+	if (req_has_async_data(req) && io->bytes_done > 0) {
 		if (ret < 0)
 			ret = io->bytes_done;
 		else
@@ -3130,6 +3139,8 @@ static inline int io_alloc_async_data(struct io_kiocb *req)
 {
 	WARN_ON_ONCE(!io_op_defs[req->opcode].async_size);
 	req->async_data = kmalloc(io_op_defs[req->opcode].async_size, GFP_KERNEL);
+	if (req->async_data)
+		req->flags |= REQ_F_ASYNC_DATA;
 	return req->async_data == NULL;
 }
 
@@ -3139,7 +3150,7 @@ static int io_setup_async_rw(struct io_kiocb *req, const struct iovec *iovec,
 {
 	if (!force && !io_op_defs[req->opcode].needs_async_setup)
 		return 0;
-	if (!req->async_data) {
+	if (!req_has_async_data(req)) {
 		if (io_alloc_async_data(req)) {
 			kfree(iovec);
 			return -ENOMEM;
@@ -3263,11 +3274,12 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
 	struct iovec inline_vecs[UIO_FASTIOV], *iovec = inline_vecs;
 	struct kiocb *kiocb = &req->rw.kiocb;
 	struct iov_iter __iter, *iter = &__iter;
-	struct io_async_rw *rw = req->async_data;
+	struct io_async_rw *rw = NULL;
 	ssize_t io_size, ret, ret2;
 	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
 
-	if (rw) {
+	if (req_has_async_data(req)) {
+		rw = req->async_data;
 		iter = &rw->iter;
 		iovec = NULL;
 	} else {
@@ -3368,11 +3380,12 @@ static int io_write(struct io_kiocb *req, unsigned int issue_flags)
 	struct iovec inline_vecs[UIO_FASTIOV], *iovec = inline_vecs;
 	struct kiocb *kiocb = &req->rw.kiocb;
 	struct iov_iter __iter, *iter = &__iter;
-	struct io_async_rw *rw = req->async_data;
+	struct io_async_rw *rw = NULL;
 	ssize_t ret, ret2, io_size;
 	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
 
-	if (rw) {
+	if (req_has_async_data(req)) {
+		rw = req->async_data;
 		iter = &rw->iter;
 		iovec = NULL;
 	} else {
@@ -4369,8 +4382,9 @@ static int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
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
@@ -4593,8 +4607,9 @@ static int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
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
@@ -4760,7 +4775,7 @@ static int io_connect(struct io_kiocb *req, unsigned int issue_flags)
 	int ret;
 	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
 
-	if (req->async_data) {
+	if (req_has_async_data(req)) {
 		io = req->async_data;
 	} else {
 		ret = move_addr_to_kernel(req->connect.addr,
@@ -4776,7 +4791,7 @@ static int io_connect(struct io_kiocb *req, unsigned int issue_flags)
 	ret = __sys_connect_file(req->file, &io->address,
 					req->connect.addr_len, file_flags);
 	if ((ret == -EAGAIN || ret == -EINPROGRESS) && force_nonblock) {
-		if (req->async_data)
+		if (req_has_async_data(req))
 			return -EAGAIN;
 		if (io_alloc_async_data(req)) {
 			ret = -ENOMEM;
@@ -5659,7 +5674,7 @@ static int io_timeout_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	if (unlikely(off && !req->ctx->off_timeout_used))
 		req->ctx->off_timeout_used = true;
 
-	if (!req->async_data && io_alloc_async_data(req))
+	if (!req_has_async_data(req) && io_alloc_async_data(req))
 		return -ENOMEM;
 
 	data = req->async_data;
@@ -5974,7 +5989,7 @@ static int io_req_prep_async(struct io_kiocb *req)
 {
 	if (!io_op_defs[req->opcode].needs_async_setup)
 		return 0;
-	if (WARN_ON_ONCE(req->async_data))
+	if (WARN_ON_ONCE(req_has_async_data(req)))
 		return -EFAULT;
 	if (io_alloc_async_data(req))
 		return -EAGAIN;
@@ -6140,7 +6155,10 @@ static void io_clean_op(struct io_kiocb *req)
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
2.32.0

