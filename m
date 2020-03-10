Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19044180111
	for <lists+io-uring@lfdr.de>; Tue, 10 Mar 2020 16:04:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727828AbgCJPEi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 10 Mar 2020 11:04:38 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:39222 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727693AbgCJPEh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 10 Mar 2020 11:04:37 -0400
Received: by mail-io1-f66.google.com with SMTP id f21so8923134iol.6
        for <io-uring@vger.kernel.org>; Tue, 10 Mar 2020 08:04:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YeYiZpJqpHfdPESRfRItJAIRyCSiIt3YlLEk55TTLq4=;
        b=CLav9xV6k54fuppMnKDIez+c6sTVPBj5+CTpVMTRmAeHYU4jLmIhsVO2yMjDrri/w8
         EsMKy/eCj+KThkG/mxATMJzqM33l8uSaTzPHeqggxPfpL4+TWfa2SDM3HZHzXUxiWal4
         TRt6nQAuWhf7YNPgdG+mWzE/4kP4E6vRSWiVcNYNyVrgGii/z9BWDMIx0ReGvFcdeFXT
         YlMa+mVlGmOtmd0oZzBiYvEMrJWMmG55CyWLdiogeyW9r1OVhZ0hYTA6+4awrCqSzv5c
         to2mXNexyT/t48d01XxjJUlYJAR8ylpKpmQs+KBoT6lWJGgIhLarOgpf+jinNHwv3ham
         YSCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YeYiZpJqpHfdPESRfRItJAIRyCSiIt3YlLEk55TTLq4=;
        b=QPaVJTV0VuETyYlGa18LwYCqEpOANpV1IjkCRf7viiroUJH+E/bglZG1JBgv8wccug
         o4c1mBhA3tfYx3aK1IYhy7Od2YxLvvbyPQL4qRSz+oI/g2hKXQDMzVqCq25qgbtfIZqN
         F/8TojNssuaYakPfrsaDK4CLS4Mq36oCzeiRc46gX7A8Lj0WSFvy2tbIjaOj89KPnUuW
         OVxdZs8L56yaMnA7vQs22/PPotIVpAPBi+QcTUWCgVH7ZxeOgUhiGhsxTlmDJVYHoOr1
         zYeswUintGusO37KgMUD96r/4MCpJexdPb72MTTw2Iyc6w0muHzq4so0YYboLSYDJmZz
         FsKg==
X-Gm-Message-State: ANhLgQ2j0mkeqzDRvy5XBmfAsY7EaqMQeZXTu5CzrEL+5RTjxDNeQWHn
        rMFcUUVCr6KeanHh8Udt+RIYxcDTEMlm4Q==
X-Google-Smtp-Source: ADFU+vt7ofIRJ4XbX56erYs3Ca+7sBpWvroVTFrf9UiHLrancinXfH8vO6AojgaIAbiDUNmbPMtVLg==
X-Received: by 2002:a6b:a08:: with SMTP id z8mr9966382ioi.174.1583852676262;
        Tue, 10 Mar 2020 08:04:36 -0700 (PDT)
Received: from x1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id e16sm4684750ioh.7.2020.03.10.08.04.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2020 08:04:35 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     andres@anarazel.de, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/9] io_uring: add IOSQE_BUFFER_SELECT support for IORING_OP_READV
Date:   Tue, 10 Mar 2020 09:04:21 -0600
Message-Id: <20200310150427.28489-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310150427.28489-1-axboe@kernel.dk>
References: <20200310150427.28489-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This adds support for the vectored read. This is limited to supporting
just 1 segment in the iov, and is provided just for convenience for
applications that use IORING_OP_READV already.

The iov helpers will be used for IORING_OP_RECVMSG as well.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 111 +++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 97 insertions(+), 14 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 65e22240a2d9..b02272d08870 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -682,6 +682,7 @@ static const struct io_op_def io_op_defs[] = {
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
 		.pollin			= 1,
+		.buffer_select		= 1,
 	},
 	[IORING_OP_WRITEV] = {
 		.async_ctx		= 1,
@@ -1686,9 +1687,10 @@ static inline bool io_req_multi_free(struct req_batch *rb, struct io_kiocb *req)
 
 static int io_put_kbuf(struct io_kiocb *req)
 {
-	struct io_buffer *kbuf = (struct io_buffer *) req->rw.addr;
+	struct io_buffer *kbuf;
 	int cflags;
 
+	kbuf = (struct io_buffer *) (unsigned long) req->rw.addr;
 	cflags = kbuf->bid << IORING_CQE_BUFFER_SHIFT;
 	cflags |= IORING_CQE_F_BUFFER;
 	req->rw.addr = 0;
@@ -2242,12 +2244,95 @@ static struct io_buffer *io_buffer_select(struct io_kiocb *req, size_t *len,
 	return kbuf;
 }
 
+static void __user *io_rw_buffer_select(struct io_kiocb *req, size_t *len,
+					bool needs_lock)
+{
+	struct io_buffer *kbuf;
+	int bgid;
+
+	kbuf = (struct io_buffer *) (unsigned long) req->rw.addr;
+	bgid = (int) (unsigned long) req->rw.kiocb.private;
+	kbuf = io_buffer_select(req, len, bgid, kbuf, needs_lock);
+	if (IS_ERR(kbuf))
+		return kbuf;
+	req->rw.addr = (u64) (unsigned long) kbuf;
+	req->flags |= REQ_F_BUFFER_SELECTED;
+	return u64_to_user_ptr(kbuf->addr);
+}
+
+#ifdef CONFIG_COMPAT
+static ssize_t io_compat_import(struct io_kiocb *req, struct iovec *iov,
+				bool needs_lock)
+{
+	struct compat_iovec __user *uiov;
+	compat_ssize_t clen;
+	void __user *buf;
+	ssize_t len;
+
+	uiov = u64_to_user_ptr(req->rw.addr);
+	if (!access_ok(uiov, sizeof(*uiov)))
+		return -EFAULT;
+	if (__get_user(clen, &uiov->iov_len))
+		return -EFAULT;
+	if (clen < 0)
+		return -EINVAL;
+
+	len = clen;
+	buf = io_rw_buffer_select(req, &len, needs_lock);
+	if (IS_ERR(buf))
+		return PTR_ERR(buf);
+	iov[0].iov_base = buf;
+	iov[0].iov_len = (compat_size_t) len;
+	return 0;
+}
+#endif
+
+static ssize_t __io_iov_buffer_select(struct io_kiocb *req, struct iovec *iov,
+				      bool needs_lock)
+{
+	struct iovec __user *uiov = u64_to_user_ptr(req->rw.addr);
+	void __user *buf;
+	ssize_t len;
+
+	if (copy_from_user(iov, uiov, sizeof(*uiov)))
+		return -EFAULT;
+
+	len = iov[0].iov_len;
+	if (len < 0)
+		return -EINVAL;
+	buf = io_rw_buffer_select(req, &len, needs_lock);
+	if (IS_ERR(buf))
+		return PTR_ERR(buf);
+	iov[0].iov_base = buf;
+	iov[0].iov_len = len;
+	return 0;
+}
+
+static ssize_t io_iov_buffer_select(struct io_kiocb *req, struct iovec *iov,
+				    bool needs_lock)
+{
+	if (req->flags & REQ_F_BUFFER_SELECTED)
+		return 0;
+	if (!req->rw.len)
+		return 0;
+	else if (req->rw.len > 1)
+		return -EINVAL;
+
+#ifdef CONFIG_COMPAT
+	if (req->ctx->compat)
+		return io_compat_import(req, iov, needs_lock);
+#endif
+
+	return __io_iov_buffer_select(req, iov, needs_lock);
+}
+
 static ssize_t io_import_iovec(int rw, struct io_kiocb *req,
 			       struct iovec **iovec, struct iov_iter *iter,
 			       bool needs_lock)
 {
 	void __user *buf = u64_to_user_ptr(req->rw.addr);
 	size_t sqe_len = req->rw.len;
+	ssize_t ret;
 	u8 opcode;
 
 	opcode = req->opcode;
@@ -2261,22 +2346,12 @@ static ssize_t io_import_iovec(int rw, struct io_kiocb *req,
 		return -EINVAL;
 
 	if (opcode == IORING_OP_READ || opcode == IORING_OP_WRITE) {
-		ssize_t ret;
-
 		if (req->flags & REQ_F_BUFFER_SELECT) {
-			struct io_buffer *kbuf = (struct io_buffer *) req->rw.addr;
-			int bgid;
-
-			bgid = (int) (unsigned long) req->rw.kiocb.private;
-			kbuf = io_buffer_select(req, &sqe_len, bgid, kbuf,
-						needs_lock);
-			if (IS_ERR(kbuf)) {
+			buf = io_rw_buffer_select(req, &sqe_len, needs_lock);
+			if (IS_ERR(buf)) {
 				*iovec = NULL;
-				return PTR_ERR(kbuf);
+				return PTR_ERR(buf);
 			}
-			req->rw.addr = (u64) kbuf;
-			req->flags |= REQ_F_BUFFER_SELECTED;
-			buf = u64_to_user_ptr(kbuf->addr);
 		}
 
 		ret = import_single_range(rw, buf, sqe_len, *iovec, iter);
@@ -2294,6 +2369,14 @@ static ssize_t io_import_iovec(int rw, struct io_kiocb *req,
 		return iorw->size;
 	}
 
+	if (req->flags & REQ_F_BUFFER_SELECT) {
+		ret = io_iov_buffer_select(req, *iovec, needs_lock);
+		if (!ret)
+			iov_iter_init(iter, rw, *iovec, 1, (*iovec)->iov_len);
+		*iovec = NULL;
+		return ret;
+	}
+
 #ifdef CONFIG_COMPAT
 	if (req->ctx->compat)
 		return compat_import_iovec(rw, buf, sqe_len, UIO_FASTIOV,
-- 
2.25.1

