Return-Path: <io-uring+bounces-9117-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E7B22B2E4E1
	for <lists+io-uring@lfdr.de>; Wed, 20 Aug 2025 20:26:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6B84F5E34AF
	for <lists+io-uring@lfdr.de>; Wed, 20 Aug 2025 18:26:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEEFE279DC0;
	Wed, 20 Aug 2025 18:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="nP7x55ll"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f171.google.com (mail-il1-f171.google.com [209.85.166.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AEF72797B5
	for <io-uring@vger.kernel.org>; Wed, 20 Aug 2025 18:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755714374; cv=none; b=LyioGTs/CfzuYaWPB4g+4avCwk+dk91kA8L0Hwy8bdjmtqCu3QVS0W6lfIngBQgQtPGQ5CRI+XmjAXrXUqJl1vAU++KpOY6B5kHP5gfqPJJLz+DuO7morjv6ogyoOa6tiVXcL2zyiycJ/N3pI69sQXY6wNXgaYXIYsHhigSu1fQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755714374; c=relaxed/simple;
	bh=hbWUdhEQpzBWuVBY5yLwP4swdEhLIzN/JCSyuhMe0L8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rt+70Lc6uDAxrrvi3PXrjIfw2z9l5yEK+Pv15hfvsPHp/kfohzEb0kxuZylXW4MVrDxvaw6n8NhHl16b0yz4bl23fy9mxFwwCNz0c0YnVhE8r1qmWGDetSmB2q8A9JdMzRVhMd67QwVC0Lq9ElIikQsFlGmlNAbkbQjlPgQDUbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=nP7x55ll; arc=none smtp.client-ip=209.85.166.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f171.google.com with SMTP id e9e14a558f8ab-3e56ff1c11eso800465ab.0
        for <io-uring@vger.kernel.org>; Wed, 20 Aug 2025 11:26:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1755714372; x=1756319172; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M/3tWjRAyU4r4MaWhkEpo7nUtSydRUbqJr0aFdhMNxE=;
        b=nP7x55llhd4UZjfVi7ylTJIv2qah/+dRg58la2iLeg659FooYxCrdzXjcWl7n332AE
         PDqBA9jR4TDumLCmaUd3+Hbj2vXfEguLGlMmWvowKEJ1Fk1mLsFYYR9gwHDUsUTQlNoC
         J0cY8Fjd0xgCXhoOTzQlNS5HLZBMNoFq7LEasRoQz+dz533avLhnV6azLBbtbp5Cnzi6
         mozqFrYjXcwcnC0FSeNvC8KL8gSdORzBIeZPSaVftaF8yWGTyivaCF1S/0hsFKtYbdSe
         h6IIboiEUQ0ePXfdqsMiAJ4WzR/gVcFslFwwYs9GQMCDwj5xMdbYZGnQp99n8xafQxjk
         W95g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755714372; x=1756319172;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=M/3tWjRAyU4r4MaWhkEpo7nUtSydRUbqJr0aFdhMNxE=;
        b=SU7jC2hfz8MnAlQp0RuTynw4CQ6GGBjuuqhrTHvIlN6KGRmJEwBDtFx9taT6K1+Um6
         vodKr07Q3K+rmGZ2smF/UmFXNNhOop4r818h7hG0W6yrzaJg8BxQy5Rvg4xH6VEe0IAE
         relf929c2g/2V5I+rBEYKbQTXFj/QrXH7tLU0C2kyZbwPqygFp1bzmEtJDrhyU9bPYG9
         BUQYhe+JmEKLAYH8lRLn+Lh+Lc1SiwtqrTNpEXwWfgmN91k6vWX2XLMoODPu0BMEjDct
         egdtRv02JykOVrV0R6Mfo2RhfozyhrEcpJY57oFO+PU9ZeqyiRiCXaRO807B7YHEI77X
         wheA==
X-Gm-Message-State: AOJu0Yzputtr4hVFZv+injqNB8Es6ex74I/SUpfhPyUzivvBqYKQyfcr
	xnnjku6ivC3ONSJKF54CbnMuZYpR+fxA1c0E8vRN7Tn/jf/PMGVzf/sCCLJ26tSUhaTSb2jghOX
	TAGIQ
X-Gm-Gg: ASbGncu1D9XiREs9nbN3FBfTwN3aIKNk0cDQnTxqhaSim3A8sR+je7r3wz6PqeQAF6G
	m2uCJ5g31zOsSFLI8KAeThFQKNn8+w/iIhitCZFb4js3JowQEA9jc8gssagVSyI0/MZBTEP5oXS
	s5MIY68UaH3BzVGt5rUNkaGsE3Zs7OQ4DjiVIiWZho333ZL7p4i8+VTBtnZlh/JpmJbNryf/dN8
	EB5EbLc1oKrk1j1QQmSCUgDDL/5ZXns8ZIA593gsIAPl/zA/CS+JpLdqC1IYq5gUPwzet2HrAn1
	Mq8KLzEcHFUBHbPSahA+OVApNQmUQtYGzTXYH0YgtE+bqxNrXoiR6on0r3CdissRnvqgIGXCs67
	X43D/RVmt58P9/cQn
X-Google-Smtp-Source: AGHT+IEe96hOVVdfvvyRmYAacvHhnOVDAwDdUcENMv2X9wYHfIqP4qDQ2Bzr+NjLEMFAkjp4wFs4+w==
X-Received: by 2002:a05:6e02:17cd:b0:3e5:6882:6604 with SMTP id e9e14a558f8ab-3e67cab609cmr72426605ab.15.1755714371494;
        Wed, 20 Aug 2025 11:26:11 -0700 (PDT)
Received: from m2max ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-50c947b3666sm4217951173.24.2025.08.20.11.26.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Aug 2025 11:26:09 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/9] io_uring/kbuf: introduce struct io_br_sel
Date: Wed, 20 Aug 2025 12:22:50 -0600
Message-ID: <20250820182601.442933-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250820182601.442933-1-axboe@kernel.dk>
References: <20250820182601.442933-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Rather than return addresses directly from buffer selection, add a
struct around it. No functional changes in this patch, it's in
preparation for storing more buffer related information locally, rather
than in struct io_kiocb.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/kbuf.c | 26 +++++++++++++-------------
 io_uring/kbuf.h | 19 +++++++++++++++++--
 io_uring/net.c  | 18 +++++++++---------
 io_uring/rw.c   | 34 ++++++++++++++++++++--------------
 4 files changed, 59 insertions(+), 38 deletions(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index b8b2f6dee754..61d9a8d439ba 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -151,18 +151,18 @@ static int io_provided_buffers_select(struct io_kiocb *req, size_t *len,
 	return 1;
 }
 
-static void __user *io_ring_buffer_select(struct io_kiocb *req, size_t *len,
-					  struct io_buffer_list *bl,
-					  unsigned int issue_flags)
+static struct io_br_sel io_ring_buffer_select(struct io_kiocb *req, size_t *len,
+					      struct io_buffer_list *bl,
+					      unsigned int issue_flags)
 {
 	struct io_uring_buf_ring *br = bl->buf_ring;
 	__u16 tail, head = bl->head;
+	struct io_br_sel sel = { };
 	struct io_uring_buf *buf;
-	void __user *ret;
 
 	tail = smp_load_acquire(&br->tail);
 	if (unlikely(tail == head))
-		return NULL;
+		return sel;
 
 	if (head + 1 == tail)
 		req->flags |= REQ_F_BL_EMPTY;
@@ -173,7 +173,7 @@ static void __user *io_ring_buffer_select(struct io_kiocb *req, size_t *len,
 	req->flags |= REQ_F_BUFFER_RING | REQ_F_BUFFERS_COMMIT;
 	req->buf_list = bl;
 	req->buf_index = buf->bid;
-	ret = u64_to_user_ptr(buf->addr);
+	sel.addr = u64_to_user_ptr(buf->addr);
 
 	if (issue_flags & IO_URING_F_UNLOCKED || !io_file_can_poll(req)) {
 		/*
@@ -189,27 +189,27 @@ static void __user *io_ring_buffer_select(struct io_kiocb *req, size_t *len,
 		io_kbuf_commit(req, bl, *len, 1);
 		req->buf_list = NULL;
 	}
-	return ret;
+	return sel;
 }
 
-void __user *io_buffer_select(struct io_kiocb *req, size_t *len,
-			      unsigned buf_group, unsigned int issue_flags)
+struct io_br_sel io_buffer_select(struct io_kiocb *req, size_t *len,
+				  unsigned buf_group, unsigned int issue_flags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
+	struct io_br_sel sel = { };
 	struct io_buffer_list *bl;
-	void __user *ret = NULL;
 
 	io_ring_submit_lock(req->ctx, issue_flags);
 
 	bl = io_buffer_get_list(ctx, buf_group);
 	if (likely(bl)) {
 		if (bl->flags & IOBL_BUF_RING)
-			ret = io_ring_buffer_select(req, len, bl, issue_flags);
+			sel = io_ring_buffer_select(req, len, bl, issue_flags);
 		else
-			ret = io_provided_buffer_select(req, len, bl);
+			sel.addr = io_provided_buffer_select(req, len, bl);
 	}
 	io_ring_submit_unlock(req->ctx, issue_flags);
-	return ret;
+	return sel;
 }
 
 /* cap it at a reasonable 256, will be one page even for 4K */
diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
index 20ad4fe716e6..8f97b033bd73 100644
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -62,8 +62,23 @@ struct buf_sel_arg {
 	unsigned short partial_map;
 };
 
-void __user *io_buffer_select(struct io_kiocb *req, size_t *len,
-			      unsigned buf_group, unsigned int issue_flags);
+/*
+ * Return value from io_buffer_list selection. Just returns the error or
+ * user address for now, will be extended to return the buffer list in the
+ * future.
+ */
+struct io_br_sel {
+	/*
+	 * Some selection parts return the user address, others return an error.
+	 */
+	union {
+		void __user *addr;
+		ssize_t val;
+	};
+};
+
+struct io_br_sel io_buffer_select(struct io_kiocb *req, size_t *len,
+				  unsigned buf_group, unsigned int issue_flags);
 int io_buffers_select(struct io_kiocb *req, struct buf_sel_arg *arg,
 		      unsigned int issue_flags);
 int io_buffers_peek(struct io_kiocb *req, struct buf_sel_arg *arg);
diff --git a/io_uring/net.c b/io_uring/net.c
index 5ce0f5470d17..8efa207f8125 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1037,22 +1037,22 @@ int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 
 retry_multishot:
 	if (io_do_buffer_select(req)) {
-		void __user *buf;
+		struct io_br_sel sel;
 		size_t len = sr->len;
 
-		buf = io_buffer_select(req, &len, sr->buf_group, issue_flags);
-		if (!buf)
+		sel = io_buffer_select(req, &len, sr->buf_group, issue_flags);
+		if (!sel.addr)
 			return -ENOBUFS;
 
 		if (req->flags & REQ_F_APOLL_MULTISHOT) {
-			ret = io_recvmsg_prep_multishot(kmsg, sr, &buf, &len);
+			ret = io_recvmsg_prep_multishot(kmsg, sr, &sel.addr, &len);
 			if (ret) {
 				io_kbuf_recycle(req, req->buf_list, issue_flags);
 				return ret;
 			}
 		}
 
-		iov_iter_ubuf(&kmsg->msg.msg_iter, ITER_DEST, buf, len);
+		iov_iter_ubuf(&kmsg->msg.msg_iter, ITER_DEST, sel.addr, len);
 	}
 
 	kmsg->msg.msg_get_inq = 1;
@@ -1155,13 +1155,13 @@ static int io_recv_buf_select(struct io_kiocb *req, struct io_async_msghdr *kmsg
 		iov_iter_init(&kmsg->msg.msg_iter, ITER_DEST, arg.iovs, ret,
 				arg.out_len);
 	} else {
-		void __user *buf;
+		struct io_br_sel sel;
 
 		*len = sr->len;
-		buf = io_buffer_select(req, len, sr->buf_group, issue_flags);
-		if (!buf)
+		sel = io_buffer_select(req, len, sr->buf_group, issue_flags);
+		if (!sel.addr)
 			return -ENOBUFS;
-		sr->buf = buf;
+		sr->buf = sel.addr;
 		sr->len = *len;
 map_ubuf:
 		ret = import_ubuf(ITER_DEST, sr->buf, sr->len,
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 7ad0f77abd54..db5d4e86f458 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -107,34 +107,35 @@ static int io_import_vec(int ddir, struct io_kiocb *req,
 }
 
 static int __io_import_rw_buffer(int ddir, struct io_kiocb *req,
-			     struct io_async_rw *io,
-			     unsigned int issue_flags)
+				 struct io_async_rw *io, struct io_br_sel *sel,
+				 unsigned int issue_flags)
 {
 	const struct io_issue_def *def = &io_issue_defs[req->opcode];
 	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
-	void __user *buf = u64_to_user_ptr(rw->addr);
 	size_t sqe_len = rw->len;
 
+	sel->addr = u64_to_user_ptr(rw->addr);
 	if (def->vectored && !(req->flags & REQ_F_BUFFER_SELECT))
-		return io_import_vec(ddir, req, io, buf, sqe_len);
+		return io_import_vec(ddir, req, io, sel->addr, sqe_len);
 
 	if (io_do_buffer_select(req)) {
-		buf = io_buffer_select(req, &sqe_len, io->buf_group, issue_flags);
-		if (!buf)
+		*sel = io_buffer_select(req, &sqe_len, io->buf_group, issue_flags);
+		if (!sel->addr)
 			return -ENOBUFS;
-		rw->addr = (unsigned long) buf;
+		rw->addr = (unsigned long) sel->addr;
 		rw->len = sqe_len;
 	}
-	return import_ubuf(ddir, buf, sqe_len, &io->iter);
+	return import_ubuf(ddir, sel->addr, sqe_len, &io->iter);
 }
 
 static inline int io_import_rw_buffer(int rw, struct io_kiocb *req,
 				      struct io_async_rw *io,
+				      struct io_br_sel *sel,
 				      unsigned int issue_flags)
 {
 	int ret;
 
-	ret = __io_import_rw_buffer(rw, req, io, issue_flags);
+	ret = __io_import_rw_buffer(rw, req, io, sel, issue_flags);
 	if (unlikely(ret < 0))
 		return ret;
 
@@ -306,10 +307,12 @@ static int __io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 
 static int io_rw_do_import(struct io_kiocb *req, int ddir)
 {
+	struct io_br_sel sel = { };
+
 	if (io_do_buffer_select(req))
 		return 0;
 
-	return io_import_rw_buffer(ddir, req, req->async_data, 0);
+	return io_import_rw_buffer(ddir, req, req->async_data, &sel, 0);
 }
 
 static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
@@ -899,7 +902,8 @@ static int io_rw_init_file(struct io_kiocb *req, fmode_t mode, int rw_type)
 	return 0;
 }
 
-static int __io_read(struct io_kiocb *req, unsigned int issue_flags)
+static int __io_read(struct io_kiocb *req, struct io_br_sel *sel,
+		     unsigned int issue_flags)
 {
 	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
 	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
@@ -913,7 +917,7 @@ static int __io_read(struct io_kiocb *req, unsigned int issue_flags)
 		if (unlikely(ret))
 			return ret;
 	} else if (io_do_buffer_select(req)) {
-		ret = io_import_rw_buffer(ITER_DEST, req, io, issue_flags);
+		ret = io_import_rw_buffer(ITER_DEST, req, io, sel, issue_flags);
 		if (unlikely(ret < 0))
 			return ret;
 	}
@@ -1015,9 +1019,10 @@ static int __io_read(struct io_kiocb *req, unsigned int issue_flags)
 
 int io_read(struct io_kiocb *req, unsigned int issue_flags)
 {
+	struct io_br_sel sel = { };
 	int ret;
 
-	ret = __io_read(req, issue_flags);
+	ret = __io_read(req, &sel, issue_flags);
 	if (ret >= 0)
 		return kiocb_done(req, ret, issue_flags);
 
@@ -1027,6 +1032,7 @@ int io_read(struct io_kiocb *req, unsigned int issue_flags)
 int io_read_mshot(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
+	struct io_br_sel sel = { };
 	unsigned int cflags = 0;
 	int ret;
 
@@ -1038,7 +1044,7 @@ int io_read_mshot(struct io_kiocb *req, unsigned int issue_flags)
 
 	/* make it sync, multishot doesn't support async execution */
 	rw->kiocb.ki_complete = NULL;
-	ret = __io_read(req, issue_flags);
+	ret = __io_read(req, &sel, issue_flags);
 
 	/*
 	 * If we get -EAGAIN, recycle our buffer and just let normal poll
-- 
2.50.1


