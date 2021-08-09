Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1B223E4545
	for <lists+io-uring@lfdr.de>; Mon,  9 Aug 2021 14:05:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235352AbhHIMFs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Aug 2021 08:05:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235350AbhHIMFo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Aug 2021 08:05:44 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 141D9C061796
        for <io-uring@vger.kernel.org>; Mon,  9 Aug 2021 05:05:24 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id d131-20020a1c1d890000b02902516717f562so11350759wmd.3
        for <io-uring@vger.kernel.org>; Mon, 09 Aug 2021 05:05:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=nSj43v5IKzfgB5/+tZoetqydVzqGYzd6ykVE3j/TN5A=;
        b=Q/DVWofIYA5s2L+a+WLRt9hgMlRtkUhI9qI5ljR86XFO8drQcoHAgc/DDjVbB+dKup
         vo6Hz265AVhmSCtRCq3veHnv4aWNXu1HQLo+sRP30tNJZCN/AdcV2R38FD6vCTIeagTj
         McwFpm7u8WyXVgOHAVfttpOqftRYa00Pl1/q92tb8UYlAyOSh08PpbRicx/NFAFQ2iSJ
         LaDVCBGzLEPhtPZGJrQmF59h3lBCoq+i+SxXUnB8D8gJriiIm08Q9cAuiI76rXypKxz4
         rn2AUeXwfTD2H40V3VDxWYT/gQIv113EdUJvY+d7lAKJ5ehKrBjhO7+pRrLlZjTQoC/2
         soAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nSj43v5IKzfgB5/+tZoetqydVzqGYzd6ykVE3j/TN5A=;
        b=Fws4lzLhHODHz68kEmFw7l1riz/uTIdoxELKs8UKXs8KDaIPbDRTvb9OOaJWD/fROD
         LqTb5aagah+HIlUAODglii3uyGrdkDdJ5gPLgpnurx2S0UbWm2ltrkw4va0U6tlQDwNL
         3zhJ0verOJgK6mYCX0s5TjswKbWRq7aPKuQ5i07k8QUClQcOpxw5c9NsbBAz/JVg/w6o
         IuhmT3DpQw79aGbBUgobQBO+X+gC2h7s5xOHRV0ob+WiA955ZXB3Ig2DW68J98M82u8N
         YwyvkcsLk+ao1hgHEf/deeo3nDExFeaHjEnmw9NAOR8bmlp84KZhBHcPcYa27kS8RUBW
         qAQQ==
X-Gm-Message-State: AOAM532xZg6k0lwmhcjAcEnqCu8PD0qIJCPMCoZ2ZRQSXyYOKftVXIHI
        pEpktMeRbBIIniCEXrQ+bMQ=
X-Google-Smtp-Source: ABdhPJwMWD/i1PSaAxirJMLS1cvigidi4Y9UUgtmJ/1bKkQY34IxuQfYfhxgMC/2A6zRR93+PT6RhQ==
X-Received: by 2002:a05:600c:2281:: with SMTP id 1mr2524656wmf.9.1628510722732;
        Mon, 09 Aug 2021 05:05:22 -0700 (PDT)
Received: from localhost.localdomain ([85.255.236.119])
        by smtp.gmail.com with ESMTPSA id g35sm4757062wmp.9.2021.08.09.05.05.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 05:05:22 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 21/28] io_uring: hide async dadta behind flags
Date:   Mon,  9 Aug 2021 13:04:21 +0100
Message-Id: <707ce8945e0247db7a585b5d1c9e8240a22e6708.1628471125.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1628471125.git.asml.silence@gmail.com>
References: <cover.1628471125.git.asml.silence@gmail.com>
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
index 0982b0dba6b0..9e359acf2f51 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -106,7 +106,8 @@
 				IOSQE_IO_HARDLINK | IOSQE_ASYNC | \
 				IOSQE_BUFFER_SELECT)
 #define IO_REQ_CLEAN_FLAGS (REQ_F_BUFFER_SELECTED | REQ_F_NEED_CLEANUP | \
-				REQ_F_POLLED | REQ_F_INFLIGHT | REQ_F_CREDS)
+				REQ_F_POLLED | REQ_F_INFLIGHT | REQ_F_CREDS | \
+				REQ_F_ASYNC_DATA)
 
 #define IO_TCTX_REFS_CACHE_NR	(1U << 10)
 
@@ -716,6 +717,7 @@ enum {
 	REQ_F_REISSUE_BIT,
 	REQ_F_DONT_REISSUE_BIT,
 	REQ_F_CREDS_BIT,
+	REQ_F_ASYNC_DATA_BIT,
 	/* keep async read/write and isreg together and in order */
 	REQ_F_NOWAIT_READ_BIT,
 	REQ_F_NOWAIT_WRITE_BIT,
@@ -771,6 +773,8 @@ enum {
 	REQ_F_ISREG		= BIT(REQ_F_ISREG_BIT),
 	/* has creds assigned */
 	REQ_F_CREDS		= BIT(REQ_F_CREDS_BIT),
+	/* ->async_data allocated */
+	REQ_F_ASYNC_DATA	= BIT(REQ_F_ASYNC_DATA_BIT),
 };
 
 struct async_poll {
@@ -828,8 +832,6 @@ struct io_kiocb {
 		struct io_completion	compl;
 	};
 
-	/* opcode allocated if it needs to store data for async defer */
-	void				*async_data;
 	u8				opcode;
 	/* polled IO has completed */
 	u8				iopoll_completed;
@@ -845,6 +847,14 @@ struct io_kiocb {
 
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
@@ -853,10 +863,8 @@ struct io_kiocb {
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
@@ -1127,6 +1135,11 @@ static bool io_match_task(struct io_kiocb *head, struct task_struct *task,
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
@@ -1808,10 +1821,6 @@ static void io_dismantle_req(struct io_kiocb *req)
 		io_put_file(req->file);
 	if (req->fixed_rsrc_refs)
 		percpu_ref_put(req->fixed_rsrc_refs);
-	if (req->async_data) {
-		kfree(req->async_data);
-		req->async_data = NULL;
-	}
 }
 
 static void __io_free_req(struct io_kiocb *req)
@@ -2422,7 +2431,7 @@ static bool io_resubmit_prep(struct io_kiocb *req)
 {
 	struct io_async_rw *rw = req->async_data;
 
-	if (!rw)
+	if (!req_has_async_data(req))
 		return !io_req_prep_async(req);
 	if (rw->iter.truncated)
 		return false;
@@ -2766,7 +2775,7 @@ static void kiocb_done(struct kiocb *kiocb, ssize_t ret,
 	bool check_reissue = kiocb->ki_complete == io_complete_rw;
 
 	/* add previously done IO, if any */
-	if (io && io->bytes_done > 0) {
+	if (req_has_async_data(req) && io->bytes_done > 0) {
 		if (ret < 0)
 			ret = io->bytes_done;
 		else
@@ -3141,6 +3150,8 @@ static inline int io_alloc_async_data(struct io_kiocb *req)
 {
 	WARN_ON_ONCE(!io_op_defs[req->opcode].async_size);
 	req->async_data = kmalloc(io_op_defs[req->opcode].async_size, GFP_KERNEL);
+	if (req->async_data)
+		req->flags |= REQ_F_ASYNC_DATA;
 	return req->async_data == NULL;
 }
 
@@ -3150,7 +3161,7 @@ static int io_setup_async_rw(struct io_kiocb *req, const struct iovec *iovec,
 {
 	if (!force && !io_op_defs[req->opcode].needs_async_setup)
 		return 0;
-	if (!req->async_data) {
+	if (!req_has_async_data(req)) {
 		if (io_alloc_async_data(req)) {
 			kfree(iovec);
 			return -ENOMEM;
@@ -3274,11 +3285,12 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
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
@@ -3381,11 +3393,12 @@ static int io_write(struct io_kiocb *req, unsigned int issue_flags)
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
@@ -4385,8 +4398,9 @@ static int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
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
@@ -4609,8 +4623,9 @@ static int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
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
@@ -4776,7 +4791,7 @@ static int io_connect(struct io_kiocb *req, unsigned int issue_flags)
 	int ret;
 	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
 
-	if (req->async_data) {
+	if (req_has_async_data(req)) {
 		io = req->async_data;
 	} else {
 		ret = move_addr_to_kernel(req->connect.addr,
@@ -4792,7 +4807,7 @@ static int io_connect(struct io_kiocb *req, unsigned int issue_flags)
 	ret = __sys_connect_file(req->file, &io->address,
 					req->connect.addr_len, file_flags);
 	if ((ret == -EAGAIN || ret == -EINPROGRESS) && force_nonblock) {
-		if (req->async_data)
+		if (req_has_async_data(req))
 			return -EAGAIN;
 		if (io_alloc_async_data(req)) {
 			ret = -ENOMEM;
@@ -5675,7 +5690,7 @@ static int io_timeout_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	if (unlikely(off && !req->ctx->off_timeout_used))
 		req->ctx->off_timeout_used = true;
 
-	if (!req->async_data && io_alloc_async_data(req))
+	if (!req_has_async_data(req) && io_alloc_async_data(req))
 		return -ENOMEM;
 
 	data = req->async_data;
@@ -5990,7 +6005,7 @@ static int io_req_prep_async(struct io_kiocb *req)
 {
 	if (!io_op_defs[req->opcode].needs_async_setup)
 		return 0;
-	if (WARN_ON_ONCE(req->async_data))
+	if (WARN_ON_ONCE(req_has_async_data(req)))
 		return -EFAULT;
 	if (io_alloc_async_data(req))
 		return -EAGAIN;
@@ -6156,7 +6171,10 @@ static void io_clean_op(struct io_kiocb *req)
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

