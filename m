Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D09041740F3
	for <lists+io-uring@lfdr.de>; Fri, 28 Feb 2020 21:31:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725900AbgB1UbB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 28 Feb 2020 15:31:01 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:38389 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbgB1UbB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 28 Feb 2020 15:31:01 -0500
Received: by mail-io1-f67.google.com with SMTP id s24so4922832iog.5
        for <io-uring@vger.kernel.org>; Fri, 28 Feb 2020 12:31:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZQUoFN5bURPzcqBi51fnknwzhxwDqQlh8Nluinu5EnQ=;
        b=Ss//dM/v5jy5D+6f9Wq3wU62pTYVliYO5mH6+KZfr8/stnZl2REiJL+1i6ePBmzhWN
         oOvN3/RSYIf7Pqv/1IqBIL16T7ynDGSXcy0U7LzCf6bHLd22SGMTILbl/Iq/VX9omKJE
         ClxrEXYH0B6QWwszaiyifh9juXy0q+N3Kl1Nb38rGHSKDDuUSHwBglRB10L9zs6kVUtl
         yTJ53RL32odP/6uFCqfCpMkK3mT2BMB2J9qJrhwSeETaZYarxjX5gumBTpQnjq9f97we
         wU8/RemOQRXwT3gO9gZydZ0I0EqXH3XQTMxcA8F2iqDhjj5+Qh5oJAjwDG53qAea1KV0
         9W9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZQUoFN5bURPzcqBi51fnknwzhxwDqQlh8Nluinu5EnQ=;
        b=goYJPe/V/qImyFOBoBH1nvZwVXED7eb8M5IzC7FibpUg/zdAO1NDECUV55e/rBUISw
         Rjwpd6pcECgo6NJTCVB0A0CRNVweUGnU5HY/DBC58PyF7/aDyFaGgcAy7Q5JjAPZtfqf
         dP5VpqVAT9Qtwi9X7hxRrZZPRYO9CW3EMB1g+nQU2x0iB+VLwmhhf/6Yc4sdkcMK9wDz
         6i3iIDBSIxFrJwk9yRmPDZ6393z41dAD1VrZFiPEC4LMqIUD91uph0PRqHlXEfhWRD9I
         QJQgAx276O90f45fgc8u8J2eUTZdpqjJCfJqlPPWHbW1VYfkFfWXsMd+G38Q1/VIcskr
         FDTw==
X-Gm-Message-State: APjAAAU0yblVrvINazfSWb03ZuP4WJvuJYAx7Lqibrv1BJjRGsjd1ScF
        y4K4V4U6I9+P+wru2AWq6mo2Hb6sun0=
X-Google-Smtp-Source: APXvYqwYLFE0wAuxqjqawj/fJmTf3PSNCn88ngJaNpgFVHniFmY5YZx4ylfy2j41LTpKvJjPKL97gQ==
X-Received: by 2002:a05:6638:18c:: with SMTP id a12mr2434784jaq.84.1582921860117;
        Fri, 28 Feb 2020 12:31:00 -0800 (PST)
Received: from x1.thefacebook.com ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id t15sm3397611ili.50.2020.02.28.12.30.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2020 12:30:59 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     andres@anarazel.de, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/6] io_uring: add IOSQE_BUFFER_SELECT support for IORING_OP_READV
Date:   Fri, 28 Feb 2020 13:30:51 -0700
Message-Id: <20200228203053.25023-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200228203053.25023-1-axboe@kernel.dk>
References: <20200228203053.25023-1-axboe@kernel.dk>
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
 fs/io_uring.c | 110 +++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 96 insertions(+), 14 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 224a452a637f..561120460422 100644
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
@@ -2205,12 +2206,96 @@ static struct io_buffer *io_buffer_select(struct io_kiocb *req, int gid,
 	return kbuf;
 }
 
+static void __user *io_rw_buffer_select(struct io_kiocb *req, size_t *len,
+					bool needs_lock)
+{
+	struct io_buffer *kbuf = (struct io_buffer *) req->rw.addr;
+	int gid;
+
+	gid = (int) (unsigned long) req->rw.kiocb.private;
+	kbuf = io_buffer_select(req, gid, kbuf, needs_lock);
+	if (IS_ERR(kbuf))
+		return kbuf;
+	req->rw.addr = (u64) kbuf;
+	if (*len > kbuf->len)
+		*len = kbuf->len;
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
@@ -2224,23 +2309,12 @@ static ssize_t io_import_iovec(int rw, struct io_kiocb *req,
 		return -EINVAL;
 
 	if (opcode == IORING_OP_READ || opcode == IORING_OP_WRITE) {
-		ssize_t ret;
-
 		if (req->flags & REQ_F_BUFFER_SELECT) {
-			struct io_buffer *kbuf = (struct io_buffer *) req->rw.addr;
-			int gid;
-
-			gid = (int) (unsigned long) req->rw.kiocb.private;
-			kbuf = io_buffer_select(req, gid, kbuf, needs_lock);
-			if (IS_ERR(kbuf)) {
+			buf = io_rw_buffer_select(req, &sqe_len, needs_lock);
+			if (IS_ERR(buf)) {
 				*iovec = NULL;
-				return PTR_ERR(kbuf);
+				return PTR_ERR(buf);
 			}
-			req->rw.addr = (u64) kbuf;
-			if (sqe_len > kbuf->len)
-				sqe_len = kbuf->len;
-			req->flags |= REQ_F_BUFFER_SELECTED;
-			buf = u64_to_user_ptr(kbuf->addr);
 		}
 
 		ret = import_single_range(rw, buf, sqe_len, *iovec, iter);
@@ -2258,6 +2332,14 @@ static ssize_t io_import_iovec(int rw, struct io_kiocb *req,
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

